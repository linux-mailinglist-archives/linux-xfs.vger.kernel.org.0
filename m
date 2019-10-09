Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD66D0DAC
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Oct 2019 13:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbfJILbL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 9 Oct 2019 07:31:11 -0400
Received: from icp-osb-irony-out3.external.iinet.net.au ([203.59.1.153]:33473
        "EHLO icp-osb-irony-out3.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730111AbfJILbL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 07:31:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BRAABxxJ1d/0e30XYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYFqBAEBCwGEOYQjjygBAQEDBosuhR+MDwkBAQEBAQEBAQE3AQG?=
 =?us-ascii?q?EOwMCAoJyNwYOAgwBAQEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBhO?=
 =?us-ascii?q?FGa9vdX8zGoosgQwoAYFkikF4gQeEYYdSglgEjHsKgi83hjxDcZVogiyVNAy?=
 =?us-ascii?q?CLotnAxCLDC2ECos1mgeBe00uCoMnUJBGZ5EUAQE?=
X-IPAS-Result: =?us-ascii?q?A2BRAABxxJ1d/0e30XYNWRwBAQEBAQcBAREBBAQBAYFqB?=
 =?us-ascii?q?AEBCwGEOYQjjygBAQEDBosuhR+MDwkBAQEBAQEBAQE3AQGEOwMCAoJyNwYOA?=
 =?us-ascii?q?gwBAQEEAQEBAQEFAwGFWIYaAgEDIwRSEBgNAiYCAkcQBhOFGa9vdX8zGoosg?=
 =?us-ascii?q?QwoAYFkikF4gQeEYYdSglgEjHsKgi83hjxDcZVogiyVNAyCLotnAxCLDC2EC?=
 =?us-ascii?q?os1mgeBe00uCoMnUJBGZ5EUAQE?=
X-IronPort-AV: E=Sophos;i="5.67,273,1566835200"; 
   d="scan'208";a="216229078"
Received: from unknown (HELO [192.168.1.222]) ([118.209.183.71])
  by icp-osb-irony-out3.iinet.net.au with ESMTP; 09 Oct 2019 19:31:09 +0800
Subject: [PATCH v5 11/17] xfs: mount-api - add xfs_remount_rw() helper
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Wed, 09 Oct 2019 19:31:09 +0800
Message-ID: <157062066896.32346.115451854887763480.stgit@fedora-28>
In-Reply-To: <157062043952.32346.977737248061083292.stgit@fedora-28>
References: <157062043952.32346.977737248061083292.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Factor the remount read write code into a helper to simplify the
subsequent change from the super block method .remount_fs to the
mount-api fs_context_operations method .reconfigure.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |  115 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 64 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 314acafffd0b..94996d1a8c0f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1363,6 +1363,68 @@ xfs_test_remount_options(
 	return error;
 }
 
+STATIC int
+xfs_remount_rw(
+	struct xfs_mount	*mp)
+{
+	xfs_sb_t		*sbp = &mp->m_sb;
+	int error;
+
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
+		xfs_warn(mp,
+			"ro->rw transition prohibited on norecovery mount");
+		return -EINVAL;
+	}
+
+	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
+		xfs_warn(mp,
+	"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
+			(sbp->sb_features_ro_compat &
+				XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
+		return -EINVAL;
+	}
+
+	mp->m_flags &= ~XFS_MOUNT_RDONLY;
+
+	/*
+	 * If this is the first remount to writeable state we
+	 * might have some superblock changes to update.
+	 */
+	if (mp->m_update_sb) {
+		error = xfs_sync_sb(mp, false);
+		if (error) {
+			xfs_warn(mp, "failed to write sb changes");
+			return error;
+		}
+		mp->m_update_sb = false;
+	}
+
+	/*
+	 * Fill out the reserve pool if it is empty. Use the stashed
+	 * value if it is non-zero, otherwise go with the default.
+	 */
+	xfs_restore_resvblks(mp);
+	xfs_log_work_queue(mp);
+
+	/* Recover any CoW blocks that never got remapped. */
+	error = xfs_reflink_recover_cow(mp);
+	if (error) {
+		xfs_err(mp,
+			"Error %d recovering leftover CoW allocations.", error);
+			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		return error;
+	}
+	xfs_start_block_reaping(mp);
+
+	/* Create the per-AG metadata reservation pool .*/
+	error = xfs_fs_reserve_ag_blocks(mp);
+	if (error && error != -ENOSPC)
+		return error;
+
+	return 0;
+}
+
 STATIC int
 xfs_fs_remount(
 	struct super_block	*sb,
@@ -1426,57 +1488,8 @@ xfs_fs_remount(
 
 	/* ro -> rw */
 	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY)) {
-		if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
-			xfs_warn(mp,
-		"ro->rw transition prohibited on norecovery mount");
-			return -EINVAL;
-		}
-
-		if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		    xfs_sb_has_ro_compat_feature(sbp,
-					XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
-			xfs_warn(mp,
-"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
-				(sbp->sb_features_ro_compat &
-					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
-			return -EINVAL;
-		}
-
-		mp->m_flags &= ~XFS_MOUNT_RDONLY;
-
-		/*
-		 * If this is the first remount to writeable state we
-		 * might have some superblock changes to update.
-		 */
-		if (mp->m_update_sb) {
-			error = xfs_sync_sb(mp, false);
-			if (error) {
-				xfs_warn(mp, "failed to write sb changes");
-				return error;
-			}
-			mp->m_update_sb = false;
-		}
-
-		/*
-		 * Fill out the reserve pool if it is empty. Use the stashed
-		 * value if it is non-zero, otherwise go with the default.
-		 */
-		xfs_restore_resvblks(mp);
-		xfs_log_work_queue(mp);
-
-		/* Recover any CoW blocks that never got remapped. */
-		error = xfs_reflink_recover_cow(mp);
-		if (error) {
-			xfs_err(mp,
-	"Error %d recovering leftover CoW allocations.", error);
-			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-			return error;
-		}
-		xfs_start_block_reaping(mp);
-
-		/* Create the per-AG metadata reservation pool .*/
-		error = xfs_fs_reserve_ag_blocks(mp);
-		if (error && error != -ENOSPC)
+		error = xfs_remount_rw(mp);
+		if (error)
 			return error;
 	}
 

