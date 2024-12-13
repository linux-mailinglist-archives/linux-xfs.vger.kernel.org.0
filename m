Return-Path: <linux-xfs+bounces-16665-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C5759F01B3
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 02:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA580286CCA
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 01:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F36E18EA2;
	Fri, 13 Dec 2024 01:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pl3eWBgK"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCD017C60
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052403; cv=none; b=ojPnkbCRd9LxB+4Argv09QtIA3QLjOXFSdIllpkQR21QZAVx616Y4mafvRonXJT6E5w9xpVJ7djeeIK49hXMBAF4LGcHlS9tCy8BJJCJMzJi1WgPWkjJuapCDjii5egKNuFuAukHI4b+eeEUSbgFcuB5te2dhTQ9fv7pN3h26sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052403; c=relaxed/simple;
	bh=UFbcZ3VT3SKKD+QCMj6A8RGMSsKHrd6pK19tJ27HrI4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GwcLsxADRyM4mGo41I1Gb5LQ0nesLE8oioK4G6zYG0jfixSJjr8ib8WXoiMpaI2Z/E5HbqBR3tPDkoWTjrE9nv4/OhedUc/hlgzWWCRyaGeigEZCQbhAqx2HRqRVKv6wkSK/H5w2AecjjFqbmUdjvOknr2DYYMp8u2xb0izkjzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pl3eWBgK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7644C4CECE;
	Fri, 13 Dec 2024 01:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052402;
	bh=UFbcZ3VT3SKKD+QCMj6A8RGMSsKHrd6pK19tJ27HrI4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Pl3eWBgK5Xzh7SVBw1ZnCKprJ+VY8eMed/E1Gnqurr6SF9wx9uP3nDb3/z1IPe6Jz
	 mWXsl3xKk9uiRpG2d447xx1KOpStCVCYu1jwSqpCswCS0wefKlVEgnNPsGxHvWSg2Q
	 tCyjimoc9Qqz2ZZoKXQNjMycqNlFGnqWtNO3jC6vA4/FVR4XRqAbawRQZ23A/M7yq9
	 wxiEeMn/K60tC4KZhKbjrMOzvZbRle9uAUoZ0kpLQEBT2HZH33UfSykkv3dWa+GvIm
	 8hbK62MDODdF0RD59H0NGZuLjhtJY9WHUvH1ziHGYG1AQXPldQ6w5ivnJPqQs7erCJ
	 NwJQdzLd6eaWA==
Date: Thu, 12 Dec 2024 17:13:22 -0800
Subject: [PATCH 12/43] xfs: wire up a new metafile type for the realtime
 refcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124773.1182620.12087827616201844932.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Plumb in the pieces we need to embed the root of the realtime refcount
btree in an inode's data fork, complete with metafile type and on-disk
interpretation functions.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h           |    8 +
 fs/xfs/libxfs/xfs_inode_fork.c       |    6 -
 fs/xfs/libxfs/xfs_ondisk.h           |    1 
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  264 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |  112 ++++++++++++++
 fs/xfs/xfs_inode_item_recover.c      |    4 +
 6 files changed, 392 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index b6828f92c131fb..b1007fb661ba73 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1805,6 +1805,14 @@ typedef __be32 xfs_refcount_ptr_t;
  */
 #define	XFS_RTREFC_CRC_MAGIC	0x52434e54	/* 'RCNT' */
 
+/*
+ * rt refcount root header, on-disk form only.
+ */
+struct xfs_rtrefcount_root {
+	__be16		bb_level;	/* 0 is a leaf */
+	__be16		bb_numrecs;	/* current # of data records */
+};
+
 /* inode-rooted btree pointer type */
 typedef __be64 xfs_rtrefcount_ptr_t;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 8d33751a3a83b3..de25faf728ee29 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -28,6 +28,7 @@
 #include "xfs_health.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 struct kmem_cache *xfs_ifork_cache;
 
@@ -274,8 +275,7 @@ xfs_iformat_data_fork(
 			case XFS_METAFILE_RTRMAP:
 				return xfs_iformat_rtrmap(ip, dip);
 			case XFS_METAFILE_RTREFCOUNT:
-				ASSERT(0); /* to be implemented later */
-				return -EFSCORRUPTED;
+				return xfs_iformat_rtrefcount(ip, dip);
 			default:
 				break;
 			}
@@ -625,7 +625,7 @@ xfs_iflush_fork(
 			xfs_iflush_rtrmap(ip, dip);
 			break;
 		case XFS_METAFILE_RTREFCOUNT:
-			ASSERT(0); /* to be implemented later */
+			xfs_iflush_rtrefcount(ip, dip);
 			break;
 		default:
 			ASSERT(0);
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index efb035050c009c..a85ecddaa48eed 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -86,6 +86,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_rtrmap_ptr_t,			8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtrmap_root,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_rtrefcount_ptr_t,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtrefcount_root,	4);
 
 	/*
 	 * m68k has problems with struct xfs_attr_leaf_name_remote, but we pad
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index ff72ed09e75f08..6a5bc7ea42fbe6 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -77,6 +77,41 @@ xfs_rtrefcountbt_get_maxrecs(
 	return cur->bc_mp->m_rtrefc_mxr[level != 0];
 }
 
+/*
+ * Calculate number of records in a realtime refcount btree inode root.
+ */
+unsigned int
+xfs_rtrefcountbt_droot_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	blocklen -= sizeof(struct xfs_rtrefcount_root);
+
+	if (leaf)
+		return blocklen / sizeof(struct xfs_refcount_rec);
+	return blocklen / (2 * sizeof(struct xfs_refcount_key) +
+			sizeof(xfs_rtrefcount_ptr_t));
+}
+
+/*
+ * Get the maximum records we could store in the on-disk format.
+ *
+ * For non-root nodes this is equivalent to xfs_rtrefcountbt_get_maxrecs, but
+ * for the root node this checks the available space in the dinode fork so that
+ * we can resize the in-memory buffer to match it.  After a resize to the
+ * maximum size this function returns the same value as
+ * xfs_rtrefcountbt_get_maxrecs for the root node, too.
+ */
+STATIC int
+xfs_rtrefcountbt_get_dmaxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	if (level != cur->bc_nlevels - 1)
+		return cur->bc_mp->m_rtrefc_mxr[level != 0];
+	return xfs_rtrefcountbt_droot_maxrecs(cur->bc_ino.forksize, level == 0);
+}
+
 STATIC void
 xfs_rtrefcountbt_init_key_from_rec(
 	union xfs_btree_key		*key,
@@ -247,6 +282,87 @@ xfs_rtrefcountbt_keys_contiguous(
 				 be32_to_cpu(key2->refc.rc_startblock));
 }
 
+static inline void
+xfs_rtrefcountbt_move_ptrs(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*broot,
+	short			old_size,
+	size_t			new_size,
+	unsigned int		numrecs)
+{
+	void			*dptr;
+	void			*sptr;
+
+	sptr = xfs_rtrefcount_broot_ptr_addr(mp, broot, 1, old_size);
+	dptr = xfs_rtrefcount_broot_ptr_addr(mp, broot, 1, new_size);
+	memmove(dptr, sptr, numrecs * sizeof(xfs_rtrefcount_ptr_t));
+}
+
+static struct xfs_btree_block *
+xfs_rtrefcountbt_broot_realloc(
+	struct xfs_btree_cur	*cur,
+	unsigned int		new_numrecs)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
+	struct xfs_btree_block	*broot;
+	unsigned int		new_size;
+	unsigned int		old_size = ifp->if_broot_bytes;
+	const unsigned int	level = cur->bc_nlevels - 1;
+
+	new_size = xfs_rtrefcount_broot_space_calc(mp, level, new_numrecs);
+
+	/* Handle the nop case quietly. */
+	if (new_size == old_size)
+		return ifp->if_broot;
+
+	if (new_size > old_size) {
+		unsigned int	old_numrecs;
+
+		/*
+		 * If there wasn't any memory allocated before, just allocate
+		 * it now and get out.
+		 */
+		if (old_size == 0)
+			return xfs_broot_realloc(ifp, new_size);
+
+		/*
+		 * If there is already an existing if_broot, then we need to
+		 * realloc it and possibly move the node block pointers because
+		 * those are not butted up against the btree block header.
+		 */
+		old_numrecs = xfs_rtrefcountbt_maxrecs(mp, old_size, level);
+		broot = xfs_broot_realloc(ifp, new_size);
+		if (level > 0)
+			xfs_rtrefcountbt_move_ptrs(mp, broot, old_size,
+					new_size, old_numrecs);
+		goto out_broot;
+	}
+
+	/*
+	 * We're reducing numrecs.  If we're going all the way to zero, just
+	 * free the block.
+	 */
+	ASSERT(ifp->if_broot != NULL && old_size > 0);
+	if (new_size == 0)
+		return xfs_broot_realloc(ifp, 0);
+
+	/*
+	 * Shrink the btree root by possibly moving the rtrmapbt pointers,
+	 * since they are not butted up against the btree block header.  Then
+	 * reallocate broot.
+	 */
+	if (level > 0)
+		xfs_rtrefcountbt_move_ptrs(mp, ifp->if_broot, old_size,
+				new_size, new_numrecs);
+	broot = xfs_broot_realloc(ifp, new_size);
+
+out_broot:
+	ASSERT(xfs_rtrefcount_droot_space(broot) <=
+	       xfs_inode_fork_size(cur->bc_ino.ip, cur->bc_ino.whichfork));
+	return broot;
+}
+
 const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 	.name			= "rtrefcount",
 	.type			= XFS_BTREE_TYPE_INODE,
@@ -264,6 +380,7 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 	.free_block		= xfs_btree_free_metafile_block,
 	.get_minrecs		= xfs_rtrefcountbt_get_minrecs,
 	.get_maxrecs		= xfs_rtrefcountbt_get_maxrecs,
+	.get_dmaxrecs		= xfs_rtrefcountbt_get_dmaxrecs,
 	.init_key_from_rec	= xfs_rtrefcountbt_init_key_from_rec,
 	.init_high_key_from_rec	= xfs_rtrefcountbt_init_high_key_from_rec,
 	.init_rec_from_cur	= xfs_rtrefcountbt_init_rec_from_cur,
@@ -274,6 +391,7 @@ const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
 	.keys_inorder		= xfs_rtrefcountbt_keys_inorder,
 	.recs_inorder		= xfs_rtrefcountbt_recs_inorder,
 	.keys_contiguous	= xfs_rtrefcountbt_keys_contiguous,
+	.broot_realloc		= xfs_rtrefcountbt_broot_realloc,
 };
 
 /* Allocate a new rt refcount btree cursor. */
@@ -457,3 +575,149 @@ xfs_rtrefcountbt_calc_reserves(
 
 	return xfs_rtrefcountbt_max_size(mp, mp->m_sb.sb_rgextents);
 }
+
+/*
+ * Convert on-disk form of btree root to in-memory form.
+ */
+STATIC void
+xfs_rtrefcountbt_from_disk(
+	struct xfs_inode		*ip,
+	struct xfs_rtrefcount_root	*dblock,
+	int				dblocklen,
+	struct xfs_btree_block		*rblock)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_refcount_key	*fkp;
+	__be64				*fpp;
+	struct xfs_refcount_key	*tkp;
+	__be64				*tpp;
+	struct xfs_refcount_rec	*frp;
+	struct xfs_refcount_rec	*trp;
+	unsigned int			numrecs;
+	unsigned int			maxrecs;
+	unsigned int			rblocklen;
+
+	rblocklen = xfs_rtrefcount_broot_space(mp, dblock);
+
+	xfs_btree_init_block(mp, rblock, &xfs_rtrefcountbt_ops, 0, 0,
+			ip->i_ino);
+
+	rblock->bb_level = dblock->bb_level;
+	rblock->bb_numrecs = dblock->bb_numrecs;
+
+	if (be16_to_cpu(rblock->bb_level) > 0) {
+		maxrecs = xfs_rtrefcountbt_droot_maxrecs(dblocklen, false);
+		fkp = xfs_rtrefcount_droot_key_addr(dblock, 1);
+		tkp = xfs_rtrefcount_key_addr(rblock, 1);
+		fpp = xfs_rtrefcount_droot_ptr_addr(dblock, 1, maxrecs);
+		tpp = xfs_rtrefcount_broot_ptr_addr(mp, rblock, 1, rblocklen);
+		numrecs = be16_to_cpu(dblock->bb_numrecs);
+		memcpy(tkp, fkp, 2 * sizeof(*fkp) * numrecs);
+		memcpy(tpp, fpp, sizeof(*fpp) * numrecs);
+	} else {
+		frp = xfs_rtrefcount_droot_rec_addr(dblock, 1);
+		trp = xfs_rtrefcount_rec_addr(rblock, 1);
+		numrecs = be16_to_cpu(dblock->bb_numrecs);
+		memcpy(trp, frp, sizeof(*frp) * numrecs);
+	}
+}
+
+/* Load a realtime reference count btree root in from disk. */
+int
+xfs_iformat_rtrefcount(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_rtrefcount_root *dfp = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	struct xfs_btree_block	*broot;
+	unsigned int		numrecs;
+	unsigned int		level;
+	int			dsize;
+
+	/*
+	 * growfs must create the rtrefcount inodes before adding a realtime
+	 * volume to the filesystem, so we cannot use the rtrefcount predicate
+	 * here.
+	 */
+	if (!xfs_has_reflink(ip->i_mount))
+		return -EFSCORRUPTED;
+
+	dsize = XFS_DFORK_SIZE(dip, mp, XFS_DATA_FORK);
+	numrecs = be16_to_cpu(dfp->bb_numrecs);
+	level = be16_to_cpu(dfp->bb_level);
+
+	if (level > mp->m_rtrefc_maxlevels ||
+	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize)
+		return -EFSCORRUPTED;
+
+	broot = xfs_broot_alloc(xfs_ifork_ptr(ip, XFS_DATA_FORK),
+			xfs_rtrefcount_broot_space_calc(mp, level, numrecs));
+	if (broot)
+		xfs_rtrefcountbt_from_disk(ip, dfp, dsize, broot);
+	return 0;
+}
+
+/*
+ * Convert in-memory form of btree root to on-disk form.
+ */
+void
+xfs_rtrefcountbt_to_disk(
+	struct xfs_mount		*mp,
+	struct xfs_btree_block		*rblock,
+	int				rblocklen,
+	struct xfs_rtrefcount_root	*dblock,
+	int				dblocklen)
+{
+	struct xfs_refcount_key	*fkp;
+	__be64				*fpp;
+	struct xfs_refcount_key	*tkp;
+	__be64				*tpp;
+	struct xfs_refcount_rec	*frp;
+	struct xfs_refcount_rec	*trp;
+	unsigned int			maxrecs;
+	unsigned int			numrecs;
+
+	ASSERT(rblock->bb_magic == cpu_to_be32(XFS_RTREFC_CRC_MAGIC));
+	ASSERT(uuid_equal(&rblock->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid));
+	ASSERT(rblock->bb_u.l.bb_blkno == cpu_to_be64(XFS_BUF_DADDR_NULL));
+	ASSERT(rblock->bb_u.l.bb_leftsib == cpu_to_be64(NULLFSBLOCK));
+	ASSERT(rblock->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK));
+
+	dblock->bb_level = rblock->bb_level;
+	dblock->bb_numrecs = rblock->bb_numrecs;
+
+	if (be16_to_cpu(rblock->bb_level) > 0) {
+		maxrecs = xfs_rtrefcountbt_droot_maxrecs(dblocklen, false);
+		fkp = xfs_rtrefcount_key_addr(rblock, 1);
+		tkp = xfs_rtrefcount_droot_key_addr(dblock, 1);
+		fpp = xfs_rtrefcount_broot_ptr_addr(mp, rblock, 1, rblocklen);
+		tpp = xfs_rtrefcount_droot_ptr_addr(dblock, 1, maxrecs);
+		numrecs = be16_to_cpu(rblock->bb_numrecs);
+		memcpy(tkp, fkp, 2 * sizeof(*fkp) * numrecs);
+		memcpy(tpp, fpp, sizeof(*fpp) * numrecs);
+	} else {
+		frp = xfs_rtrefcount_rec_addr(rblock, 1);
+		trp = xfs_rtrefcount_droot_rec_addr(dblock, 1);
+		numrecs = be16_to_cpu(rblock->bb_numrecs);
+		memcpy(trp, frp, sizeof(*frp) * numrecs);
+	}
+}
+
+/* Flush a realtime reference count btree root out to disk. */
+void
+xfs_iflush_rtrefcount(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	struct xfs_rtrefcount_root *dfp = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+
+	ASSERT(ifp->if_broot != NULL);
+	ASSERT(ifp->if_broot_bytes > 0);
+	ASSERT(xfs_rtrefcount_droot_space(ifp->if_broot) <=
+			xfs_inode_fork_size(ip, XFS_DATA_FORK));
+	xfs_rtrefcountbt_to_disk(ip->i_mount, ifp->if_broot,
+			ifp->if_broot_bytes, dfp,
+			XFS_DFORK_SIZE(dip, ip->i_mount, XFS_DATA_FORK));
+}
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
index 3cd44590c9304c..e558a10c4744ad 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -25,6 +25,7 @@ void xfs_rtrefcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
 unsigned int xfs_rtrefcountbt_maxrecs(struct xfs_mount *mp,
 		unsigned int blocklen, bool leaf);
 void xfs_rtrefcountbt_compute_maxlevels(struct xfs_mount *mp);
+unsigned int xfs_rtrefcountbt_droot_maxrecs(unsigned int blocklen, bool leaf);
 
 /*
  * Addresses of records, keys, and pointers within an incore rtrefcountbt block.
@@ -71,4 +72,115 @@ xfs_filblks_t xfs_rtrefcountbt_calc_reserves(struct xfs_mount *mp);
 unsigned long long xfs_rtrefcountbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
+/* Addresses of key, pointers, and records within an ondisk rtrefcount block. */
+
+static inline struct xfs_refcount_rec *
+xfs_rtrefcount_droot_rec_addr(
+	struct xfs_rtrefcount_root	*block,
+	unsigned int			index)
+{
+	return (struct xfs_refcount_rec *)
+		((char *)(block + 1) +
+		 (index - 1) * sizeof(struct xfs_refcount_rec));
+}
+
+static inline struct xfs_refcount_key *
+xfs_rtrefcount_droot_key_addr(
+	struct xfs_rtrefcount_root	*block,
+	unsigned int			index)
+{
+	return (struct xfs_refcount_key *)
+		((char *)(block + 1) +
+		 (index - 1) * sizeof(struct xfs_refcount_key));
+}
+
+static inline xfs_rtrefcount_ptr_t *
+xfs_rtrefcount_droot_ptr_addr(
+	struct xfs_rtrefcount_root	*block,
+	unsigned int			index,
+	unsigned int			maxrecs)
+{
+	return (xfs_rtrefcount_ptr_t *)
+		((char *)(block + 1) +
+		 maxrecs * sizeof(struct xfs_refcount_key) +
+		 (index - 1) * sizeof(xfs_rtrefcount_ptr_t));
+}
+
+/*
+ * Address of pointers within the incore btree root.
+ *
+ * These are to be used when we know the size of the block and
+ * we don't have a cursor.
+ */
+static inline xfs_rtrefcount_ptr_t *
+xfs_rtrefcount_broot_ptr_addr(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*bb,
+	unsigned int		index,
+	unsigned int		block_size)
+{
+	return xfs_rtrefcount_ptr_addr(bb, index,
+			xfs_rtrefcountbt_maxrecs(mp, block_size, false));
+}
+
+/*
+ * Compute the space required for the incore btree root containing the given
+ * number of records.
+ */
+static inline size_t
+xfs_rtrefcount_broot_space_calc(
+	struct xfs_mount	*mp,
+	unsigned int		level,
+	unsigned int		nrecs)
+{
+	size_t			sz = XFS_RTREFCOUNT_BLOCK_LEN;
+
+	if (level > 0)
+		return sz + nrecs * (sizeof(struct xfs_refcount_key) +
+				     sizeof(xfs_rtrefcount_ptr_t));
+	return sz + nrecs * sizeof(struct xfs_refcount_rec);
+}
+
+/*
+ * Compute the space required for the incore btree root given the ondisk
+ * btree root block.
+ */
+static inline size_t
+xfs_rtrefcount_broot_space(struct xfs_mount *mp, struct xfs_rtrefcount_root *bb)
+{
+	return xfs_rtrefcount_broot_space_calc(mp, be16_to_cpu(bb->bb_level),
+			be16_to_cpu(bb->bb_numrecs));
+}
+
+/* Compute the space required for the ondisk root block. */
+static inline size_t
+xfs_rtrefcount_droot_space_calc(
+	unsigned int		level,
+	unsigned int		nrecs)
+{
+	size_t			sz = sizeof(struct xfs_rtrefcount_root);
+
+	if (level > 0)
+		return sz + nrecs * (sizeof(struct xfs_refcount_key) +
+				     sizeof(xfs_rtrefcount_ptr_t));
+	return sz + nrecs * sizeof(struct xfs_refcount_rec);
+}
+
+/*
+ * Compute the space required for the ondisk root block given an incore root
+ * block.
+ */
+static inline size_t
+xfs_rtrefcount_droot_space(struct xfs_btree_block *bb)
+{
+	return xfs_rtrefcount_droot_space_calc(be16_to_cpu(bb->bb_level),
+			be16_to_cpu(bb->bb_numrecs));
+}
+
+int xfs_iformat_rtrefcount(struct xfs_inode *ip, struct xfs_dinode *dip);
+void xfs_rtrefcountbt_to_disk(struct xfs_mount *mp,
+		struct xfs_btree_block *rblock, int rblocklen,
+		struct xfs_rtrefcount_root *dblock, int dblocklen);
+void xfs_iflush_rtrefcount(struct xfs_inode *ip, struct xfs_dinode *dip);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index daaa4098f4d5a6..4e583bfc5ca814 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -23,6 +23,7 @@
 #include "xfs_icache.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 STATIC void
 xlog_recover_inode_ra_pass2(
@@ -286,6 +287,9 @@ xlog_recover_inode_dbroot(
 		case XFS_METAFILE_RTRMAP:
 			xfs_rtrmapbt_to_disk(mp, src, len, dfork, dsize);
 			return 0;
+		case XFS_METAFILE_RTREFCOUNT:
+			xfs_rtrefcountbt_to_disk(mp, src, len, dfork, dsize);
+			return 0;
 		default:
 			ASSERT(0);
 			return -EFSCORRUPTED;


