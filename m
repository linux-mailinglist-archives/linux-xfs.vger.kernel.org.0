Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1065476741
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Dec 2021 02:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhLPBJz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Dec 2021 20:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhLPBJz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Dec 2021 20:09:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3B6C061574
        for <linux-xfs@vger.kernel.org>; Wed, 15 Dec 2021 17:09:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E49E261BB8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Dec 2021 01:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F7BC36AE1;
        Thu, 16 Dec 2021 01:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639616994;
        bh=68tLunglQaUDru1VRnVnSNOlJ+lStU8jjkicUwo/NuY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XK6kM+qse4a33UdUpfIAjhfGEiUSBrhz9XkowRRqEOvoxXUu+x6r3kh/J9ry/+e/I
         ocTq5onrt+2rOlLiIeKhFQuXzKrnjib4OgN1bKM173Lf4GQ8oKHTxgpaDCeISQ8pRq
         stzowCqMmkhw/qRR9E9ymefbHFepYquWWINdcBi0FsCOqtcaXck58SayxzzYy+pKfp
         jgm744Xh1cnbD1OEPYP8OItn66aZGL8gw7tbKqTPzocGPQP1P7k5yJTGW01ea9biDC
         OVjMXxCOSh0Z41SQvYcrv9zK31yQokLDRtWrkF5lO717JRlJ432pz6/Y6fQrOU50rH
         h8JLsQUrT2i7w==
Subject: [PATCH 7/7] xfs: only run COW extent recovery when there are no live
 extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Dec 2021 17:09:54 -0800
Message-ID: <163961699399.3129691.9449691191051808697.stgit@magnolia>
In-Reply-To: <163961695502.3129691.3496134437073533141.stgit@magnolia>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As part of multiple customer escalations due to file data corruption
after copy on write operations, I wrote some fstests that use fsstress
to hammer on COW to shake things loose.  Regrettably, I caught some
filesystem shutdowns due to incorrect rmap operations with the following
loop:

mount <filesystem>				# (0)
fsstress <run only readonly ops> &		# (1)
while true; do
	fsstress <run all ops>
	mount -o remount,ro			# (2)
	fsstress <run only readonly ops>
	mount -o remount,rw			# (3)
done

When (2) happens, notice that (1) is still running.  xfs_remount_ro will
call xfs_blockgc_stop to walk the inode cache to free all the COW
extents, but the blockgc mechanism races with (1)'s reader threads to
take IOLOCKs and loses, which means that it doesn't clean them all out.
Call such a file (A).

When (3) happens, xfs_remount_rw calls xfs_reflink_recover_cow, which
walks the ondisk refcount btree and frees any COW extent that it finds.
This function does not check the inode cache, which means that incore
COW forks of inode (A) is now inconsistent with the ondisk metadata.  If
one of those former COW extents are allocated and mapped into another
file (B) and someone triggers a COW to the stale reservation in (A), A's
dirty data will be written into (B) and once that's done, those blocks
will be transferred to (A)'s data fork without bumping the refcount.

The results are catastrophic -- file (B) and the refcount btree are now
corrupt.  In the first patch, we fixed the race condition in (2) so that
(A) will always flush the COW fork.  In this second patch, we move the
_recover_cow call to the initial mount call in (0) for safety.

As mentioned previously, xfs_reflink_recover_cow walks the refcount
btree looking for COW staging extents, and frees them.  This was
intended to be run at mount time (when we know there are no live inodes)
to clean up any leftover staging events that may have been left behind
during an unclean shutdown.  As a time "optimization" for readonly
mounts, we deferred this to the ro->rw transition, not realizing that
any failure to clean all COW forks during a rw->ro transition would
result in catastrophic corruption.

Therefore, remove this optimization and only run the recovery routine
when we're guaranteed not to have any COW staging extents anywhere,
which means we always run this at mount time.  While we're at it, move
the callsite to xfs_log_mount_finish because any refcount btree
expansion (however unlikely given that we're removing records from the
right side of the index) must be fed by a per-AG reservation, which
doesn't exist in its current location.

Fixes: 174edb0e46e5 ("xfs: store in-progress CoW allocations in the refcount btree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_recover.c |   24 +++++++++++++++++++++++-
 fs/xfs/xfs_mount.c       |   10 ----------
 fs/xfs/xfs_reflink.c     |    5 ++++-
 fs/xfs/xfs_super.c       |    9 ---------
 4 files changed, 27 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 53366cc0bc9e..8ecb9a8567b7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -27,7 +27,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_ag.h"
 #include "xfs_quota.h"
-
+#include "xfs_reflink.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -3498,6 +3498,28 @@ xlog_recover_finish(
 
 	xlog_recover_process_iunlinks(log);
 	xlog_recover_check_summary(log);
+
+	/*
+	 * Recover any CoW staging blocks that are still referenced by the
+	 * ondisk refcount metadata.  During mount there cannot be any live
+	 * staging extents as we have not permitted any user modifications.
+	 * Therefore, it is safe to free them all right now, even on a
+	 * read-only mount.
+	 */
+	error = xfs_reflink_recover_cow(log->l_mp);
+	if (error) {
+		xfs_alert(log->l_mp,
+	"Failed to recover leftover CoW staging extents, err %d.",
+				error);
+		/*
+		 * If we get an error here, make sure the log is shut down
+		 * but return zero so that any log items committed since the
+		 * end of intents processing can be pushed through the CIL
+		 * and AIL.
+		 */
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+	}
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 359109b6f0d3..bed73e8002a5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -936,15 +936,6 @@ xfs_mountfs(
 			xfs_warn(mp,
 	"Unable to allocate reserve blocks. Continuing without reserve pool.");
 
-		/* Recover any CoW blocks that never got remapped. */
-		error = xfs_reflink_recover_cow(mp);
-		if (error) {
-			xfs_err(mp,
-	"Error %d recovering leftover CoW allocations.", error);
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-			goto out_quota;
-		}
-
 		/* Reserve AG blocks for future btree expansion. */
 		error = xfs_fs_reserve_ag_blocks(mp);
 		if (error && error != -ENOSPC)
@@ -955,7 +946,6 @@ xfs_mountfs(
 
  out_agresv:
 	xfs_fs_unreserve_ag_blocks(mp);
- out_quota:
 	xfs_qm_unmount_quotas(mp);
  out_rtunmount:
 	xfs_rtunmount_inodes(mp);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cb0edb1d68ef..8b6c7163f684 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -749,7 +749,10 @@ xfs_reflink_end_cow(
 }
 
 /*
- * Free leftover CoW reservations that didn't get cleaned out.
+ * Free all CoW staging blocks that are still referenced by the ondisk refcount
+ * metadata.  The ondisk metadata does not track which inode created the
+ * staging extent, so callers must ensure that there are no cached inodes with
+ * live CoW staging extents.
  */
 int
 xfs_reflink_recover_cow(
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 778b57b1f020..c7ac486ca5d3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1739,15 +1739,6 @@ xfs_remount_rw(
 	 */
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
-
-	/* Recover any CoW blocks that never got remapped. */
-	error = xfs_reflink_recover_cow(mp);
-	if (error) {
-		xfs_err(mp,
-			"Error %d recovering leftover CoW allocations.", error);
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return error;
-	}
 	xfs_blockgc_start(mp);
 
 	/* Create the per-AG metadata reservation pool .*/

