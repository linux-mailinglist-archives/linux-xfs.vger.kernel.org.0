Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06FB32E141
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Mar 2021 06:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhCEFMx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Mar 2021 00:12:53 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:48691 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229512AbhCEFMM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:12:12 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id B2C791ADD91
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:55 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-00Fbnq-4i
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kf-000lYv-TK
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/45] xfs: remove xfs_blkdev_issue_flush
Date:   Fri,  5 Mar 2021 16:11:02 +1100
Message-Id: <20210305051143.182133-5-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=Lz9GblgEbu-RQyWGrh4A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It's a one line wrapper around blkdev_issue_flush(). Just replace it
with direct calls to blkdev_issue_flush().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c   | 2 +-
 fs/xfs/xfs_file.c  | 6 +++---
 fs/xfs/xfs_log.c   | 2 +-
 fs/xfs/xfs_super.c | 7 -------
 fs/xfs/xfs_super.h | 1 -
 5 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 37a1d12762d8..7043546a04b8 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1958,7 +1958,7 @@ xfs_free_buftarg(
 	percpu_counter_destroy(&btp->bt_io_count);
 	list_lru_destroy(&btp->bt_lru);
 
-	xfs_blkdev_issue_flush(btp);
+	blkdev_issue_flush(btp->bt_bdev);
 
 	kmem_free(btp);
 }
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index a007ca0711d9..24c7f45fc4eb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -197,9 +197,9 @@ xfs_file_fsync(
 	 * inode size in case of an extending write.
 	 */
 	if (XFS_IS_REALTIME_INODE(ip))
-		xfs_blkdev_issue_flush(mp->m_rtdev_targp);
+		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
 	else if (mp->m_logdev_targp != mp->m_ddev_targp)
-		xfs_blkdev_issue_flush(mp->m_ddev_targp);
+		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
 
 	/*
 	 * Any inode that has dirty modifications in the log is pinned.  The
@@ -219,7 +219,7 @@ xfs_file_fsync(
 	 */
 	if (!log_flushed && !XFS_IS_REALTIME_INODE(ip) &&
 	    mp->m_logdev_targp == mp->m_ddev_targp)
-		xfs_blkdev_issue_flush(mp->m_ddev_targp);
+		blkdev_issue_flush(mp->m_ddev_targp->bt_bdev);
 
 	return error;
 }
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 317c466232d4..fee76c485727 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1962,7 +1962,7 @@ xlog_sync(
 	 * layer state machine for preflushes.
 	 */
 	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
-		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
+		blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
 		need_flush = false;
 	}
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e5e0713bebcd..ca2cb0448b5e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -339,13 +339,6 @@ xfs_blkdev_put(
 		blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 }
 
-void
-xfs_blkdev_issue_flush(
-	xfs_buftarg_t		*buftarg)
-{
-	blkdev_issue_flush(buftarg->bt_bdev);
-}
-
 STATIC void
 xfs_close_devices(
 	struct xfs_mount	*mp)
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 1ca484b8357f..79cb2dece811 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -88,7 +88,6 @@ struct block_device;
 
 extern void xfs_quiesce_attr(struct xfs_mount *mp);
 extern void xfs_flush_inodes(struct xfs_mount *mp);
-extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
 extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
 					   xfs_agnumber_t agcount);
 
-- 
2.28.0

