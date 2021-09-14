Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254D140A3B7
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Sep 2021 04:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237098AbhINCnd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Sep 2021 22:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236205AbhINCnd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:43:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D507D610D1;
        Tue, 14 Sep 2021 02:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587336;
        bh=uHhdo0g+9p9Df1VqBv3dS+jX5HZBM13wrBEIzN+nLBk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uFD0emFZ8C8RkKXN53ioLk8Gqkx6pJ1Hl/Vt/AoToaivm58dJRFhjmk5zc7ldnPSa
         xmT+ARcPXYFj4SniLpJEUw2lcjcaABwl3Trm7gJcFRRQMoSYs5TRA6BmDDERVi9/HP
         qdiQIv3IwFUT82uYzOIhYDlpqtihooFDYh5AHEVkoi+rzRIMi1R0OZp45jt7vIo2ar
         ieBWJBVyoIsHeqEKkCSpALvHIYP5rIHbOwQV3On3h3u81NI8T3Zw5y4jKcOD/MjP9X
         OeCp0rgqJAQlK8aTUMzYhURcZKfAwGwJLeVw0IhUEeKvy3IokEu2d2MfEDNOwC0Ap3
         R8lW5g5zz/Rdw==
Subject: [PATCH 25/43] xfs: convert mount flags to features
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:42:16 -0700
Message-ID: <163158733660.1604118.8914008454755284421.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 0560f31a09e523090d1ab2bfe21c69d028c2bdf2

Replace m_flags feature checks with xfs_has_<feature>() calls and
rework the setup code to set flags in m_features.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_mount.h    |   11 +++++++++++
 libxfs/xfs_attr.c      |    4 ++--
 libxfs/xfs_attr_leaf.c |   41 +++++++++++++++++++++++------------------
 libxfs/xfs_bmap.c      |    4 ++--
 libxfs/xfs_ialloc.c    |   10 ++++------
 5 files changed, 42 insertions(+), 28 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 351ceaef..aed31404 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -194,6 +194,17 @@ __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 
+/* Kernel mount features that we don't support */
+#define __XFS_UNSUPP_FEAT(name) \
+static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
+{ \
+	return false; \
+}
+__XFS_UNSUPP_FEAT(wsync)
+__XFS_UNSUPP_FEAT(noattr2)
+__XFS_UNSUPP_FEAT(ikeep)
+__XFS_UNSUPP_FEAT(swalloc)
+
 #define LIBXFS_MOUNT_DEBUGGER		0x0001
 #define LIBXFS_MOUNT_32BITINODES	0x0002
 #define LIBXFS_MOUNT_32BITINOOPT	0x0004
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 07b19652..3a712e36 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -224,7 +224,7 @@ xfs_attr_try_sf_addname(
 	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
 		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
-	if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(dp->i_mount))
 		xfs_trans_set_sync(args->trans);
 
 	return error;
@@ -808,7 +808,7 @@ xfs_attr_set(
 	 * If this is a synchronous mount, make sure that the
 	 * transaction goes to disk before returning to the user.
 	 */
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(args->trans);
 
 	if (!(args->op_flags & XFS_DA_OP_NOTIME))
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 3fff838e..308fc0f7 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -565,7 +565,7 @@ xfs_attr_shortform_bytesfit(
 	 * literal area, but for the old format we are done if there is no
 	 * space in the fixed attribute fork.
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_ATTR2))
+	if (!xfs_has_attr2(mp))
 		return 0;
 
 	dsize = dp->i_df.if_bytes;
@@ -618,21 +618,27 @@ xfs_attr_shortform_bytesfit(
 }
 
 /*
- * Switch on the ATTR2 superblock bit (implies also FEATURES2)
+ * Switch on the ATTR2 superblock bit (implies also FEATURES2) unless:
+ * - noattr2 mount option is set,
+ * - on-disk version bit says it is already set, or
+ * - the attr2 mount option is not set to enable automatic upgrade from attr1.
  */
 STATIC void
-xfs_sbversion_add_attr2(xfs_mount_t *mp, xfs_trans_t *tp)
+xfs_sbversion_add_attr2(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp)
 {
-	if ((mp->m_flags & XFS_MOUNT_ATTR2) &&
-	    !(xfs_has_attr2(mp))) {
-		spin_lock(&mp->m_sb_lock);
-		if (!xfs_has_attr2(mp)) {
-			xfs_add_attr2(mp);
-			spin_unlock(&mp->m_sb_lock);
-			xfs_log_sb(tp);
-		} else
-			spin_unlock(&mp->m_sb_lock);
-	}
+	if (xfs_has_noattr2(mp))
+		return;
+	if (mp->m_sb.sb_features2 & XFS_SB_VERSION2_ATTR2BIT)
+		return;
+	if (!xfs_has_attr2(mp))
+		return;
+
+	spin_lock(&mp->m_sb_lock);
+	xfs_add_attr2(mp);
+	spin_unlock(&mp->m_sb_lock);
+	xfs_log_sb(tp);
 }
 
 /*
@@ -807,8 +813,7 @@ xfs_attr_sf_removename(
 	 * Fix up the start offset of the attribute fork
 	 */
 	totsize -= size;
-	if (totsize == sizeof(xfs_attr_sf_hdr_t) &&
-	    (mp->m_flags & XFS_MOUNT_ATTR2) &&
+	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
 	    !(args->op_flags & XFS_DA_OP_ADDNAME)) {
 		xfs_attr_fork_remove(dp, args->trans);
@@ -818,7 +823,7 @@ xfs_attr_sf_removename(
 		ASSERT(dp->i_forkoff);
 		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
-				!(mp->m_flags & XFS_MOUNT_ATTR2) ||
+				!xfs_has_attr2(mp) ||
 				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
@@ -994,7 +999,7 @@ xfs_attr_shortform_allfit(
 		bytes += xfs_attr_sf_entsize_byname(name_loc->namelen,
 					be16_to_cpu(name_loc->valuelen));
 	}
-	if ((dp->i_mount->m_flags & XFS_MOUNT_ATTR2) &&
+	if (xfs_has_attr2(dp->i_mount) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
 	    (bytes == sizeof(struct xfs_attr_sf_hdr)))
 		return -1;
@@ -1119,7 +1124,7 @@ xfs_attr3_leaf_to_shortform(
 		goto out;
 
 	if (forkoff == -1) {
-		ASSERT(dp->i_mount->m_flags & XFS_MOUNT_ATTR2);
+		ASSERT(xfs_has_attr2(dp->i_mount));
 		ASSERT(dp->i_df.if_format != XFS_DINODE_FMT_BTREE);
 		xfs_attr_fork_remove(dp, args->trans);
 		goto out;
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index db9e8566..bea9340a 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1040,7 +1040,7 @@ xfs_bmap_set_attrforkoff(
 		ip->i_forkoff = xfs_attr_shortform_bytesfit(ip, size);
 		if (!ip->i_forkoff)
 			ip->i_forkoff = default_size;
-		else if ((ip->i_mount->m_flags & XFS_MOUNT_ATTR2) && version)
+		else if (xfs_has_attr2(ip->i_mount) && version)
 			*version = 2;
 		break;
 	default:
@@ -3415,7 +3415,7 @@ xfs_bmap_compute_alignments(
 	int			stripe_align = 0;
 
 	/* stripe alignment for allocation is determined by mount parameters */
-	if (mp->m_swidth && (mp->m_flags & XFS_MOUNT_SWALLOC))
+	if (mp->m_swidth && xfs_has_swalloc(mp))
 		stripe_align = mp->m_swidth;
 	else if (mp->m_dalign)
 		stripe_align = mp->m_dalign;
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 567f9996..4075ff5a 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -707,7 +707,7 @@ xfs_ialloc_ag_alloc(
 		 */
 		isaligned = 0;
 		if (igeo->ialloc_align) {
-			ASSERT(!(args.mp->m_flags & XFS_MOUNT_NOALIGN));
+			ASSERT(!xfs_has_noalign(args.mp));
 			args.alignment = args.mp->m_dalign;
 			isaligned = 1;
 		} else
@@ -1948,8 +1948,7 @@ xfs_difree_inobt(
 	 * remove the chunk if the block size is large enough for multiple inode
 	 * chunks (that might not be free).
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
-	    rec.ir_free == XFS_INOBT_ALL_FREE &&
+	if (!xfs_has_ikeep(mp) && rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
 		struct xfs_perag	*pag = agbp->b_pag;
 
@@ -2093,9 +2092,8 @@ xfs_difree_finobt(
 	 * enough for multiple chunks. Leave the finobt record to remain in sync
 	 * with the inobt.
 	 */
-	if (rec.ir_free == XFS_INOBT_ALL_FREE &&
-	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK &&
-	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
+	if (!xfs_has_ikeep(mp) && rec.ir_free == XFS_INOBT_ALL_FREE &&
+	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto error;

