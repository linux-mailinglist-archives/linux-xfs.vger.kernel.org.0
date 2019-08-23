Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 462449A4B6
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Aug 2019 03:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732174AbfHWBJT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Aug 2019 21:09:19 -0400
Received: from icp-osb-irony-out2.external.iinet.net.au ([203.59.1.155]:5622
        "EHLO icp-osb-irony-out2.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732721AbfHWBJT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 21:09:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2DWAQAROl9d/3Wz0XYNWBwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWeEM4Qgj1YBAQaBEYoRkSMJAQEBAQEBAQEBNwEBhDoDAgKDAjgTAgk?=
 =?us-ascii?q?BAQEEAQIBAQYDAYVYhhkCAQMjBFIQGA0CJgICRxAGE4UZq1BzfzMaikCBDCi?=
 =?us-ascii?q?BY4okeIEHgUSDHYdPglgEjDMKgleGD0JtlQoJgh+UWAyCJYs2AxCKUC2Dc4p?=
 =?us-ascii?q?1mGyBeU0uCoMnkRRljFYBAQ?=
X-IPAS-Result: =?us-ascii?q?A2DWAQAROl9d/3Wz0XYNWBwBAQEEAQEHBAEBgWeEM4Qgj?=
 =?us-ascii?q?1YBAQaBEYoRkSMJAQEBAQEBAQEBNwEBhDoDAgKDAjgTAgkBAQEEAQIBAQYDA?=
 =?us-ascii?q?YVYhhkCAQMjBFIQGA0CJgICRxAGE4UZq1BzfzMaikCBDCiBY4okeIEHgUSDH?=
 =?us-ascii?q?YdPglgEjDMKgleGD0JtlQoJgh+UWAyCJYs2AxCKUC2Dc4p1mGyBeU0uCoMnk?=
 =?us-ascii?q?RRljFYBAQ?=
X-IronPort-AV: E=Sophos;i="5.64,419,1559491200"; 
   d="scan'208";a="231796798"
Received: from unknown (HELO [192.168.1.222]) ([118.209.179.117])
  by icp-osb-irony-out2.iinet.net.au with ESMTP; 23 Aug 2019 09:00:06 +0800
Subject: [PATCH v2 09/15] xfs: mount-api - add xfs_remount_rw() helper
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 23 Aug 2019 09:00:06 +0800
Message-ID: <156652200638.2607.17067626550015292418.stgit@fedora-28>
In-Reply-To: <156652158924.2607.14608448087216437699.stgit@fedora-28>
References: <156652158924.2607.14608448087216437699.stgit@fedora-28>
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
---
 fs/xfs/xfs_super.c |  115 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 64 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7de64808eb00..9f7300958a38 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1341,6 +1341,68 @@ xfs_test_remount_options(
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
@@ -1404,57 +1466,8 @@ xfs_fs_remount(
 
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
 

