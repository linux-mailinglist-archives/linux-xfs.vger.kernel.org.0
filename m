Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96391DFDEA
	for <lists+linux-xfs@lfdr.de>; Sun, 24 May 2020 11:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgEXJS0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 24 May 2020 05:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgEXJSZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 May 2020 05:18:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA89AC061A0E
        for <linux-xfs@vger.kernel.org>; Sun, 24 May 2020 02:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=M/Wa0SmVWjsDa5no1qS5JEE5IPiU5Bu8IAVMblfBA6Q=; b=KA7PHToXGiqc0xPOmaS1Nh0uMH
        sASAsihsUP8hT3W6HJjTcY221M3OXBvBm5M6Rxjyj67wgr75oy6TTdQyEKr52W6KMTYWcp5zd7o5u
        999ibWnYKdv88zNGXCnnvQno4FmeUobrkpA2K7sp0h5PchNpyiGkMScxcoj+qt73agQDkBlgN0xm5
        bLH3Db0lKBkm111Z8nGVx70kgWNIMkutWEOv/8NAGIxiMOujWquCHwdYq/f+00e+QwKkMqKjOCD6v
        IAqnMPwYcCs81f+t1Y79j0k4glC5++WGLa0hWToZcR1zKrM4OtrhCfIWQf/ECaiifSJxB8ELYXowu
        H4q0q1kA==;
Received: from [2001:4bb8:18c:5da7:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jcmm1-0004sg-90
        for linux-xfs@vger.kernel.org; Sun, 24 May 2020 09:18:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/14] xfs: move the di_forkoff field to struct xfs_inode
Date:   Sun, 24 May 2020 11:17:52 +0200
Message-Id: <20200524091757.128995-10-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200524091757.128995-1-hch@lst.de>
References: <20200524091757.128995-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation of removing the historic icinode struct, move the
forkoff field into the containing xfs_inode structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c  | 22 +++++++++++-----------
 fs/xfs/libxfs/xfs_bmap.c       | 32 ++++++++++++++++----------------
 fs/xfs/libxfs/xfs_inode_buf.c  |  4 ++--
 fs/xfs/libxfs/xfs_inode_buf.h  |  1 -
 fs/xfs/libxfs/xfs_inode_fork.h |  4 ++--
 fs/xfs/xfs_icache.c            |  2 +-
 fs/xfs/xfs_inode.c             |  8 ++++----
 fs/xfs/xfs_inode.h             |  1 +
 fs/xfs/xfs_inode_item.c        |  2 +-
 9 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index f3d18a1f5b20c..129b9d8bf0476 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -518,10 +518,10 @@ xfs_attr_copy_value(
  * Query whether the requested number of additional bytes of extended
  * attribute space will be able to fit inline.
  *
- * Returns zero if not, else the di_forkoff fork offset to be used in the
+ * Returns zero if not, else the i_forkoff fork offset to be used in the
  * literal area for attribute data once the new bytes have been added.
  *
- * di_forkoff must be 8 byte aligned, hence is stored as a >>3 value;
+ * i_forkoff must be 8 byte aligned, hence is stored as a >>3 value;
  * special case for dev/uuid inodes, they have fixed size data forks.
  */
 int
@@ -554,7 +554,7 @@ xfs_attr_shortform_bytesfit(
 	 * literal area rebalancing.
 	 */
 	if (bytes <= XFS_IFORK_ASIZE(dp))
-		return dp->i_d.di_forkoff;
+		return dp->i_forkoff;
 
 	/*
 	 * For attr2 we can try to move the forkoff if there is space in the
@@ -575,7 +575,7 @@ xfs_attr_shortform_bytesfit(
 		 * minimum offset only needs to be the space required for
 		 * the btree root.
 		 */
-		if (!dp->i_d.di_forkoff && dp->i_df.if_bytes >
+		if (!dp->i_forkoff && dp->i_df.if_bytes >
 		    xfs_default_attroffset(dp))
 			dsize = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 		break;
@@ -586,10 +586,10 @@ xfs_attr_shortform_bytesfit(
 		 * minforkoff to where the btree root can finish so we have
 		 * plenty of room for attrs
 		 */
-		if (dp->i_d.di_forkoff) {
-			if (offset < dp->i_d.di_forkoff)
+		if (dp->i_forkoff) {
+			if (offset < dp->i_forkoff)
 				return 0;
-			return dp->i_d.di_forkoff;
+			return dp->i_forkoff;
 		}
 		dsize = XFS_BMAP_BROOT_SPACE(mp, dp->i_df.if_broot);
 		break;
@@ -677,7 +677,7 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 
 	dp = args->dp;
 	mp = dp->i_mount;
-	dp->i_d.di_forkoff = forkoff;
+	dp->i_forkoff = forkoff;
 
 	ifp = dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
@@ -720,7 +720,7 @@ xfs_attr_fork_remove(
 	xfs_idestroy_fork(ip->i_afp);
 	kmem_cache_free(xfs_ifork_zone, ip->i_afp);
 	ip->i_afp = NULL;
-	ip->i_d.di_forkoff = 0;
+	ip->i_forkoff = 0;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
@@ -775,8 +775,8 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 		xfs_attr_fork_remove(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
-		dp->i_d.di_forkoff = xfs_attr_shortform_bytesfit(dp, totsize);
-		ASSERT(dp->i_d.di_forkoff);
+		dp->i_forkoff = xfs_attr_shortform_bytesfit(dp, totsize);
+		ASSERT(dp->i_forkoff);
 		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!(mp->m_flags & XFS_MOUNT_ATTR2) ||
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4c7d3f84ca3ff..1b1c89278c35e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -66,13 +66,13 @@ xfs_bmap_compute_maxlevels(
 	 * either a signed 32-bit number for the data fork, or a signed 16-bit
 	 * number for the attr fork.
 	 *
-	 * Note that we can no longer assume that if we are in ATTR1 that
-	 * the fork offset of all the inodes will be
-	 * (xfs_default_attroffset(ip) >> 3) because we could have mounted
-	 * with ATTR2 and then mounted back with ATTR1, keeping the
-	 * di_forkoff's fixed but probably at various positions. Therefore,
-	 * for both ATTR1 and ATTR2 we have to assume the worst case scenario
-	 * of a minimum size available.
+	 * Note that we can no longer assume that if we are in ATTR1 that the
+	 * fork offset of all the inodes will be
+	 * (xfs_default_attroffset(ip) >> 3) because we could have mounted with
+	 * ATTR2 and then mounted back with ATTR1, keeping the i_forkoff's fixed
+	 * but probably at various positions. Therefore, for both ATTR1 and
+	 * ATTR2 we have to assume the worst case scenario of a minimum size
+	 * available.
 	 */
 	if (whichfork == XFS_DATA_FORK) {
 		maxleafents = MAXEXTNUM;
@@ -205,9 +205,9 @@ xfs_default_attroffset(
 }
 
 /*
- * Helper routine to reset inode di_forkoff field when switching
- * attribute fork from local to extent format - we reset it where
- * possible to make space available for inline data fork extents.
+ * Helper routine to reset inode i_forkoff field when switching attribute fork
+ * from local to extent format - we reset it where possible to make space
+ * available for inline data fork extents.
  */
 STATIC void
 xfs_bmap_forkoff_reset(
@@ -219,8 +219,8 @@ xfs_bmap_forkoff_reset(
 	    ip->i_df.if_format != XFS_DINODE_FMT_BTREE) {
 		uint	dfl_forkoff = xfs_default_attroffset(ip) >> 3;
 
-		if (dfl_forkoff > ip->i_d.di_forkoff)
-			ip->i_d.di_forkoff = dfl_forkoff;
+		if (dfl_forkoff > ip->i_forkoff)
+			ip->i_forkoff = dfl_forkoff;
 	}
 }
 
@@ -1035,14 +1035,14 @@ xfs_bmap_set_attrforkoff(
 {
 	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_DEV:
-		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
+		ip->i_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
 		break;
 	case XFS_DINODE_FMT_LOCAL:
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
-		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
-		if (!ip->i_d.di_forkoff)
-			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
+		ip->i_forkoff = xfs_attr_shortform_bytesfit(ip, size);
+		if (!ip->i_forkoff)
+			ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		else if ((ip->i_mount->m_flags & XFS_MOUNT_ATTR2) && version)
 			*version = 2;
 		break;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 8c4b7bd69285f..69a6844b1698d 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -245,7 +245,7 @@ xfs_inode_from_disk(
 	ip->i_disk_size = be64_to_cpu(from->di_size);
 	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
 	ip->i_extsize = be32_to_cpu(from->di_extsize);
-	to->di_forkoff = from->di_forkoff;
+	ip->i_forkoff = from->di_forkoff;
 	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
 	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
 	to->di_flags	= be16_to_cpu(from->di_flags);
@@ -310,7 +310,7 @@ xfs_inode_to_disk(
 	to->di_extsize = cpu_to_be32(ip->i_extsize);
 	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
 	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
-	to->di_forkoff = from->di_forkoff;
+	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
 	to->di_dmstate = cpu_to_be16(from->di_dmstate);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 8cc96f2766ff4..032486dbf8275 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -16,7 +16,6 @@ struct xfs_dinode;
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
 	uint16_t	di_dmstate;	/* DMIG state info */
 	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index a4953e95c4f3f..7d6982b23446c 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -38,8 +38,8 @@ struct xfs_ifork {
  * Fork handling.
  */
 
-#define XFS_IFORK_Q(ip)			((ip)->i_d.di_forkoff != 0)
-#define XFS_IFORK_BOFF(ip)		((int)((ip)->i_d.di_forkoff << 3))
+#define XFS_IFORK_Q(ip)			((ip)->i_forkoff != 0)
+#define XFS_IFORK_BOFF(ip)		((int)((ip)->i_forkoff << 3))
 
 #define XFS_IFORK_PTR(ip,w)		\
 	((w) == XFS_DATA_FORK ? \
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5cd36486af1ef..53e39af55251a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -67,7 +67,7 @@ xfs_inode_alloc(
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
 	ip->i_nblocks = 0;
-	ip->i_d.di_forkoff = 0;
+	ip->i_forkoff = 0;
 	ip->i_sick = 0;
 	ip->i_checked = 0;
 	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index dff853a7ed0c3..648261905591d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1858,7 +1858,7 @@ xfs_inactive(
 	}
 
 	ASSERT(!ip->i_afp);
-	ASSERT(ip->i_d.di_forkoff == 0);
+	ASSERT(ip->i_forkoff == 0);
 
 	/*
 	 * Free the inode.
@@ -2756,7 +2756,7 @@ xfs_ifree(
 	ip->i_d.di_flags = 0;
 	ip->i_d.di_flags2 = 0;
 	ip->i_d.di_dmevmask = 0;
-	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
+	ip->i_forkoff = 0;		/* mark the attr fork not in use */
 	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 
 	/* Don't attempt to replay owner changes for a deleted inode */
@@ -3754,11 +3754,11 @@ xfs_iflush_int(
 			ip->i_nblocks, ip);
 		goto flush_out;
 	}
-	if (XFS_TEST_ERROR(ip->i_d.di_forkoff > mp->m_sb.sb_inodesize,
+	if (XFS_TEST_ERROR(ip->i_forkoff > mp->m_sb.sb_inodesize,
 				mp, XFS_ERRTAG_IFLUSH_6)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: bad inode %Lu, forkoff 0x%x, ptr "PTR_FMT,
-			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
+			__func__, ip->i_ino, ip->i_forkoff, ip);
 		goto flush_out;
 	}
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 59f7341ece285..75baa3e802fcf 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -63,6 +63,7 @@ typedef struct xfs_inode {
 		uint32_t	i_cowextsize;	/* basic cow extent size */
 		uint16_t	i_flushiter;	/* incremented on flush */
 	};
+	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 8357fe37d3eb8..a83ddc4e029f0 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -328,7 +328,7 @@ xfs_inode_to_log_dinode(
 	to->di_extsize = ip->i_extsize;
 	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
 	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
-	to->di_forkoff = from->di_forkoff;
+	to->di_forkoff = ip->i_forkoff;
 	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_dmevmask = from->di_dmevmask;
 	to->di_dmstate = from->di_dmstate;
-- 
2.26.2

