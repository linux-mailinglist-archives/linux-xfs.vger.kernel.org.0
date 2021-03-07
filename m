Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475E633047C
	for <lists+linux-xfs@lfdr.de>; Sun,  7 Mar 2021 21:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhCGU0G (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 7 Mar 2021 15:26:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232849AbhCGUZ5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 7 Mar 2021 15:25:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DAEA65165;
        Sun,  7 Mar 2021 20:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615148757;
        bh=ANXu+xvTfkku0KZG8HFR3XbGTE4V/jR/re5DtOQAjk0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eVfatMtjtsD0s0eue6NpXBalZ16Ux1e6cIoH8YamWGVlRhZ3aGaTiZ1nZ6+fWeb4x
         b2kSEJ4ondooMg1EhtLGCTXEsptirGgdtNjea2BQ2k4UGhhhiw2j3I3mivainuZlHd
         v/IicRA7N4nlJNFtx1wwgfpqMDfzlO7WsFrmVmm+SBLpOS5sctanpo5F7SbyC/eKyr
         NJpK1pDSVBAHt9AEa9HP5jbNnBHE2jXyD1kpK0qgLJScNbSwgP670kmyFh6szN3DSh
         zzPwP1Bds5qHhL0Qh07UzoqxHKUE2wY5drLczrCvGvwNEudprIisHByYsyPvZ4FHyW
         EnhCLL328M3IQ==
Subject: [PATCH 3/4] xfs: force log and push AIL to clear pinned inodes when
 aborting mount
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
        christian.brauner@ubuntu.com
Date:   Sun, 07 Mar 2021 12:25:57 -0800
Message-ID: <161514875722.698643.971171271199400538.stgit@magnolia>
In-Reply-To: <161514874040.698643.2749449122589431232.stgit@magnolia>
References: <161514874040.698643.2749449122589431232.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we allocate quota inodes in the process of mounting a filesystem but
then decide to abort the mount, it's possible that the quota inodes are
sitting around pinned by the log.  Now that inode reclaim relies on the
AIL to flush inodes, we have to force the log and push the AIL in
between releasing the quota inodes and kicking off reclaim to tear down
all the incore inodes.  Do this by extracting the bits we need from the
unmount path and reusing them.

This was originally found during a fuzz test of metadata directories
(xfs/1546), but the actual symptom was that reclaim hung up on the quota
inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c |  100 ++++++++++++++++++++++++++++------------------------
 1 file changed, 54 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 52370d0a3f43..556ce373145f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -634,6 +634,57 @@ xfs_check_summary_counts(
 	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
 }
 
+/*
+ * Force the log contents and checkpoint them into the filesystem, the reclaim
+ * inodes in preparation to unmount.
+ */
+static void
+xfs_unmount_flush_inodes(
+	struct xfs_mount	*mp)
+{
+	/*
+	 * We can potentially deadlock here if we have an inode cluster
+	 * that has been freed has its buffer still pinned in memory because
+	 * the transaction is still sitting in a iclog. The stale inodes
+	 * on that buffer will be pinned to the buffer until the
+	 * transaction hits the disk and the callbacks run. Pushing the AIL will
+	 * skip the stale inodes and may never see the pinned buffer, so
+	 * nothing will push out the iclog and unpin the buffer. Hence we
+	 * need to force the log here to ensure all items are flushed into the
+	 * AIL before we go any further.
+	 */
+	xfs_log_force(mp, XFS_LOG_SYNC);
+
+	/*
+	 * Wait for all busy extents to be freed, including completion of
+	 * any discard operation.
+	 */
+	xfs_extent_busy_wait_all(mp);
+	flush_workqueue(xfs_discard_wq);
+
+	/*
+	 * We now need to tell the world we are unmounting. This will allow
+	 * us to detect that the filesystem is going away and we should error
+	 * out anything that we have been retrying in the background. This will
+	 * prevent neverending retries in AIL pushing from hanging the unmount.
+	 */
+	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
+
+	/*
+	 * Flush all pending changes from the AIL.
+	 */
+	xfs_ail_push_all_sync(mp->m_ail);
+
+	/*
+	 * Reclaim all inodes. At this point there should be no dirty inodes and
+	 * none should be pinned or locked. Stop background inode reclaim here
+	 * if it is still running.
+	 */
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	xfs_reclaim_inodes(mp);
+	xfs_health_unmount(mp);
+}
+
 /*
  * This function does the following on an initial mount of a file system:
  *	- reads the superblock from disk and init the mount struct
@@ -1008,7 +1059,7 @@ xfs_mountfs(
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
 	/*
-	 * Cancel all delayed reclaim work and reclaim the inodes directly.
+	 * Flush all inode reclamation work and flush the log.
 	 * We have to do this /after/ rtunmount and qm_unmount because those
 	 * two will have scheduled delayed reclaim for the rt/quota inodes.
 	 *
@@ -1018,11 +1069,8 @@ xfs_mountfs(
 	 * qm_unmount_quotas and therefore rely on qm_unmount to release the
 	 * quota inodes.
 	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp);
-	xfs_health_unmount(mp);
+	xfs_unmount_flush_inodes(mp);
  out_log_dealloc:
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 	xfs_log_mount_cancel(mp);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
@@ -1063,47 +1111,7 @@ xfs_unmountfs(
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
 
-	/*
-	 * We can potentially deadlock here if we have an inode cluster
-	 * that has been freed has its buffer still pinned in memory because
-	 * the transaction is still sitting in a iclog. The stale inodes
-	 * on that buffer will be pinned to the buffer until the
-	 * transaction hits the disk and the callbacks run. Pushing the AIL will
-	 * skip the stale inodes and may never see the pinned buffer, so
-	 * nothing will push out the iclog and unpin the buffer. Hence we
-	 * need to force the log here to ensure all items are flushed into the
-	 * AIL before we go any further.
-	 */
-	xfs_log_force(mp, XFS_LOG_SYNC);
-
-	/*
-	 * Wait for all busy extents to be freed, including completion of
-	 * any discard operation.
-	 */
-	xfs_extent_busy_wait_all(mp);
-	flush_workqueue(xfs_discard_wq);
-
-	/*
-	 * We now need to tell the world we are unmounting. This will allow
-	 * us to detect that the filesystem is going away and we should error
-	 * out anything that we have been retrying in the background. This will
-	 * prevent neverending retries in AIL pushing from hanging the unmount.
-	 */
-	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
-
-	/*
-	 * Flush all pending changes from the AIL.
-	 */
-	xfs_ail_push_all_sync(mp->m_ail);
-
-	/*
-	 * Reclaim all inodes. At this point there should be no dirty inodes and
-	 * none should be pinned or locked. Stop background inode reclaim here
-	 * if it is still running.
-	 */
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp);
-	xfs_health_unmount(mp);
+	xfs_unmount_flush_inodes(mp);
 
 	xfs_qm_unmount(mp);
 

