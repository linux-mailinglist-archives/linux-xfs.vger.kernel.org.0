Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1283995AD
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Jun 2021 23:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhFBWAI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 2 Jun 2021 18:00:08 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:51965 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229576AbhFBWAI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 18:00:08 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 9BCE880B676
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jun 2021 07:58:06 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loYsE-008FfF-Nl
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 07:58:02 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1loYsE-0006S0-G6
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 07:58:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: don't take a spinlock unconditionally in the DIO fastpath
Date:   Thu,  3 Jun 2021 07:58:02 +1000
Message-Id: <20210602215802.24753-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=LvPSQ2Ov66fEIrourcsA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because this happens at high thread counts on high IOPS devices
doing mixed read/write AIO-DIO to a single file at about a million
iops:

   64.09%     0.21%  [kernel]            [k] io_submit_one
   - 63.87% io_submit_one
      - 44.33% aio_write
         - 42.70% xfs_file_write_iter
            - 41.32% xfs_file_dio_write_aligned
               - 25.51% xfs_file_write_checks
                  - 21.60% _raw_spin_lock
                     - 21.59% do_raw_spin_lock
                        - 19.70% __pv_queued_spin_lock_slowpath

This also happens of the IO completion IO path:

   22.89%     0.69%  [kernel]            [k] xfs_dio_write_end_io
   - 22.49% xfs_dio_write_end_io
      - 21.79% _raw_spin_lock
         - 20.97% do_raw_spin_lock
            - 20.10% __pv_queued_spin_lock_slowpath

IOWs, fio is burning ~14 whole CPUs on this spin lock.

So, do an unlocked check against inode size first, then if we are
at/beyond EOF, take the spinlock and recheck. This makes the
spinlock disappear from the overwrite fastpath.

I'd like to report that fixing this makes things go faster. It
doesn't - it just exposes the the XFS_ILOCK as the next severe
contention point doing extent mapping lookups, and that now burns
all the 14 CPUs this spinlock was burning.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_file.c | 42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 396ef36dcd0a..c068dcd414f4 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -384,21 +384,30 @@ xfs_file_write_checks(
 		}
 		goto restart;
 	}
+
 	/*
 	 * If the offset is beyond the size of the file, we need to zero any
 	 * blocks that fall between the existing EOF and the start of this
-	 * write.  If zeroing is needed and we are currently holding the
-	 * iolock shared, we need to update it to exclusive which implies
-	 * having to redo all checks before.
+	 * write.  If zeroing is needed and we are currently holding the iolock
+	 * shared, we need to update it to exclusive which implies having to
+	 * redo all checks before.
+	 *
+	 * We need to serialise against EOF updates that occur in IO completions
+	 * here. We want to make sure that nobody is changing the size while we
+	 * do this check until we have placed an IO barrier (i.e.  hold the
+	 * XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.  The
+	 * spinlock effectively forms a memory barrier once we have the
+	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value and
+	 * hence be able to correctly determine if we need to run zeroing.
 	 *
-	 * We need to serialise against EOF updates that occur in IO
-	 * completions here. We want to make sure that nobody is changing the
-	 * size while we do this check until we have placed an IO barrier (i.e.
-	 * hold the XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.
-	 * The spinlock effectively forms a memory barrier once we have the
-	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value
-	 * and hence be able to correctly determine if we need to run zeroing.
+	 * We can do an unlocked check here safely as IO completion can only
+	 * extend EOF. Truncate is locked out at this point, so the EOF can
+	 * not move backwards, only forwards. Hence we only need to take the
+	 * slow path and spin locks when we are at or beyond the current EOF.
 	 */
+	if (iocb->ki_pos <= i_size_read(inode))
+		goto out;
+
 	spin_lock(&ip->i_flags_lock);
 	isize = i_size_read(inode);
 	if (iocb->ki_pos > isize) {
@@ -426,7 +435,7 @@ xfs_file_write_checks(
 			drained_dio = true;
 			goto restart;
 		}
-	
+
 		trace_xfs_zero_eof(ip, isize, iocb->ki_pos - isize);
 		error = iomap_zero_range(inode, isize, iocb->ki_pos - isize,
 				NULL, &xfs_buffered_write_iomap_ops);
@@ -435,6 +444,7 @@ xfs_file_write_checks(
 	} else
 		spin_unlock(&ip->i_flags_lock);
 
+out:
 	return file_modified(file);
 }
 
@@ -500,7 +510,17 @@ xfs_dio_write_end_io(
 	 * other IO completions here to update the EOF. Failing to serialise
 	 * here can result in EOF moving backwards and Bad Things Happen when
 	 * that occurs.
+	 *
+	 * As IO completion only ever extends EOF, we can do an unlocked check
+	 * here to avoid taking the spinlock. If we land within the current EOF,
+	 * then we do not need to do an extending update at all, and we don't
+	 * need to take the lock to check this. If we race with an update moving
+	 * EOF, then we'll either still be beyond EOF and need to take the lock,
+	 * or we'll be within EOF and we don't need to take it at all.
 	 */
+	if (offset + size <= i_size_read(inode))
+		goto out;
+
 	spin_lock(&ip->i_flags_lock);
 	if (offset + size > i_size_read(inode)) {
 		i_size_write(inode, offset + size);
-- 
2.31.1

