Return-Path: <linux-xfs+bounces-8908-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D64C18D8942
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 21:01:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C2FB1F218D4
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 19:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EF04130AD7;
	Mon,  3 Jun 2024 19:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sdaD3IEL"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B0E259C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441302; cv=none; b=UV2nwhvueqdd2tQTVfuZTOpECIvmRD6R11p2nUm+qwa8+hCw6OZYnZqgikfFLfCV7baEDr5w+LSmzqAB2EkufXJXhIxXexk/oJSRfhkpHLYKtMkNgYs1obLO3Oc7yVboKq9DO6Upg8AvEsctqrUo7LRpXNGij/tm1kWEpydboy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441302; c=relaxed/simple;
	bh=vsynHXvx4EW+xTK5KoovoHbuXHjan6tukDBD17dzm54=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A2dPyXyvQ7A5LKfDScN4mqYFkGKhg96qLdWc9PaBInNhxZXpOPSWOv2Z2udXSyktsZEuNEBmoK2yX+vjxI3p+hxj5IjO4GfdK5A8Gz4Rvjh5qqIQCIHLR/ff7+Y69l4PHMnmonA+DOfMpFa/zjZMiSB6A+EvKX0owEijfDLChjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sdaD3IEL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A8FC2BD10;
	Mon,  3 Jun 2024 19:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441302;
	bh=vsynHXvx4EW+xTK5KoovoHbuXHjan6tukDBD17dzm54=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sdaD3IEL1fDRngJGy0MYkgahLNwHX/4R+LBMeFJthsA6QwTDcBi7aCdHwbsayKvw5
	 l25cYzqqPAEulAqH1aJNEmT+4DztaDct35pOoaexrkGQc92MMKl/5A2IA4+uhpOC52
	 Qz54AVe3H0mljKus0RivHQM+Y2mbVQfC5K16qii3gbjIgr+6lD+1KD40q3pqQtxRpq
	 4lkbMymMk4dZXGsrlUn5FziPv5+9q5on4K6lWfxo5K7oe172dUnfZlS9Rycme7p/AK
	 srXwZYR6YJU3csu8a7iv4MopxgIlRmyJ+xqT2vbyoeXtPqq1qspnEhNJfaUPXbdzIE
	 9k2UScuG9+w5A==
Date: Mon, 03 Jun 2024 12:01:42 -0700
Subject: [PATCH 037/111] xfs: initialize btree blocks using btree_ops
 structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039928.1443973.9020247109979959642.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: c87e3bf7802477cb4500dfafe0ab039313aa2dda

Notice now that the btree ops structure encodes btree geometry flags and
the magic number through the buffer ops.  Refactor the btree block
initialization functions to use the btree ops so that we no longer have
to open code all that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_ag.c            |   33 ++++++++++---------------
 libxfs/xfs_ag.h            |    2 +-
 libxfs/xfs_bmap.c          |    8 ++----
 libxfs/xfs_bmap_btree.c    |   20 +++++++++++++--
 libxfs/xfs_bmap_btree.h    |    3 ++
 libxfs/xfs_btree.c         |   57 ++++++++++++++++++--------------------------
 libxfs/xfs_btree.h         |   28 ++++++----------------
 libxfs/xfs_btree_staging.c |    5 ++--
 8 files changed, 69 insertions(+), 87 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index b16f9c5c5..932bdfb8d 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -490,7 +490,7 @@ xfs_btroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, id->type, 0, 0, id->agno);
+	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 0, id->agno);
 }
 
 /* Finish initializing a free space btree. */
@@ -548,7 +548,7 @@ xfs_freesp_init_recs(
 }
 
 /*
- * Alloc btree root block init functions
+ * bnobt/cntbt btree root block init functions
  */
 static void
 xfs_bnoroot_init(
@@ -556,17 +556,7 @@ xfs_bnoroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 0, id->agno);
-	xfs_freesp_init_recs(mp, bp, id);
-}
-
-static void
-xfs_cntroot_init(
-	struct xfs_mount	*mp,
-	struct xfs_buf		*bp,
-	struct aghdr_init_data	*id)
-{
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 0, id->agno);
+	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 0, id->agno);
 	xfs_freesp_init_recs(mp, bp, id);
 }
 
@@ -582,7 +572,7 @@ xfs_rmaproot_init(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_rmap_rec	*rrec;
 
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_RMAP, 0, 4, id->agno);
+	xfs_btree_init_block(mp, bp, id->bc_ops, 0, 4, id->agno);
 
 	/*
 	 * mark the AG header regions as static metadata The BNO
@@ -795,7 +785,7 @@ struct xfs_aghdr_grow_data {
 	size_t			numblks;
 	const struct xfs_buf_ops *ops;
 	aghdr_init_work_f	work;
-	xfs_btnum_t		type;
+	const struct xfs_btree_ops *bc_ops;
 	bool			need_init;
 };
 
@@ -849,13 +839,15 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_bnobt_buf_ops,
 		.work = &xfs_bnoroot_init,
+		.bc_ops = &xfs_bnobt_ops,
 		.need_init = true
 	},
 	{ /* CNT root block */
 		.daddr = XFS_AGB_TO_DADDR(mp, id->agno, XFS_CNT_BLOCK(mp)),
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_cntbt_buf_ops,
-		.work = &xfs_cntroot_init,
+		.work = &xfs_bnoroot_init,
+		.bc_ops = &xfs_cntbt_ops,
 		.need_init = true
 	},
 	{ /* INO root block */
@@ -863,7 +855,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_inobt_buf_ops,
 		.work = &xfs_btroot_init,
-		.type = XFS_BTNUM_INO,
+		.bc_ops = &xfs_inobt_ops,
 		.need_init = true
 	},
 	{ /* FINO root block */
@@ -871,7 +863,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_finobt_buf_ops,
 		.work = &xfs_btroot_init,
-		.type = XFS_BTNUM_FINO,
+		.bc_ops = &xfs_finobt_ops,
 		.need_init =  xfs_has_finobt(mp)
 	},
 	{ /* RMAP root block */
@@ -879,6 +871,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_rmapbt_buf_ops,
 		.work = &xfs_rmaproot_init,
+		.bc_ops = &xfs_rmapbt_ops,
 		.need_init = xfs_has_rmapbt(mp)
 	},
 	{ /* REFC root block */
@@ -886,7 +879,7 @@ xfs_ag_init_headers(
 		.numblks = BTOBB(mp->m_sb.sb_blocksize),
 		.ops = &xfs_refcountbt_buf_ops,
 		.work = &xfs_btroot_init,
-		.type = XFS_BTNUM_REFC,
+		.bc_ops = &xfs_refcountbt_ops,
 		.need_init = xfs_has_reflink(mp)
 	},
 	{ /* NULL terminating block */
@@ -904,7 +897,7 @@ xfs_ag_init_headers(
 
 		id->daddr = dp->daddr;
 		id->numblks = dp->numblks;
-		id->type = dp->type;
+		id->bc_ops = dp->bc_ops;
 		error = xfs_ag_init_hdr(mp, id, dp->work, dp->ops);
 		if (error)
 			break;
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 4b343c4fa..77c0fa2bb 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -331,7 +331,7 @@ struct aghdr_init_data {
 	/* per header data */
 	xfs_daddr_t		daddr;		/* header location */
 	size_t			numblks;	/* size of header */
-	xfs_btnum_t		type;		/* type of btree root block */
+	const struct xfs_btree_ops *bc_ops;	/* btree ops */
 };
 
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 9e44f4cae..a7b6c44f1 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -638,9 +638,7 @@ xfs_bmap_extents_to_btree(
 	 * Fill in the root.
 	 */
 	block = ifp->if_broot;
-	xfs_btree_init_block_int(mp, block, XFS_BUF_DADDR_NULL,
-				 XFS_BTNUM_BMAP, 1, 1, ip->i_ino,
-				 XFS_BTGEO_LONG_PTRS);
+	xfs_bmbt_init_block(ip, block, NULL, 1, 1);
 	/*
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
@@ -686,9 +684,7 @@ xfs_bmap_extents_to_btree(
 	 */
 	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
-	xfs_btree_init_block_int(mp, ablock, xfs_buf_daddr(abp),
-				XFS_BTNUM_BMAP, 0, 0, ip->i_ino,
-				XFS_BTGEO_LONG_PTRS);
+	xfs_bmbt_init_block(ip, ablock, abp, 0, 0);
 
 	for_each_xfs_iext(ifp, &icur, &rec) {
 		if (isnullstartblock(rec.br_startblock))
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 41b4419b5..a3732b4c4 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -25,6 +25,22 @@
 
 static struct kmem_cache	*xfs_bmbt_cur_cache;
 
+void
+xfs_bmbt_init_block(
+	struct xfs_inode		*ip,
+	struct xfs_btree_block		*buf,
+	struct xfs_buf			*bp,
+	__u16				level,
+	__u16				numrecs)
+{
+	if (bp)
+		xfs_btree_init_block(ip->i_mount, bp, &xfs_bmbt_ops, level,
+				numrecs, ip->i_ino);
+	else
+		xfs_btree_init_block_int(ip->i_mount, buf, &xfs_bmbt_ops,
+				XFS_BUF_DADDR_NULL, level, numrecs, ip->i_ino);
+}
+
 /*
  * Convert on-disk form of btree root to in-memory form.
  */
@@ -43,9 +59,7 @@ xfs_bmdr_to_bmbt(
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
-	xfs_btree_init_block_int(mp, rblock, XFS_BUF_DADDR_NULL,
-				 XFS_BTNUM_BMAP, 0, 0, ip->i_ino,
-				 XFS_BTGEO_LONG_PTRS);
+	xfs_bmbt_init_block(ip, rblock, NULL, 0, 0);
 	rblock->bb_level = dblock->bb_level;
 	ASSERT(be16_to_cpu(rblock->bb_level) > 0);
 	rblock->bb_numrecs = dblock->bb_numrecs;
diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index 151b8491f..e93aa42e2 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
@@ -120,4 +120,7 @@ unsigned int xfs_bmbt_maxlevels_ondisk(void);
 int __init xfs_bmbt_init_cur_cache(void);
 void xfs_bmbt_destroy_cur_cache(void);
 
+void xfs_bmbt_init_block(struct xfs_inode *ip, struct xfs_btree_block *buf,
+		struct xfs_buf *bp, __u16 level, __u16 numrecs);
+
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 3b9c95bcf..5675dd5ae 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -29,24 +29,17 @@
 /*
  * Btree magic numbers.
  */
-static const uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
-	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, 0, XFS_BMAP_MAGIC, XFS_IBT_MAGIC,
-	  XFS_FIBT_MAGIC, 0 },
-	{ XFS_ABTB_CRC_MAGIC, XFS_ABTC_CRC_MAGIC, XFS_RMAP_CRC_MAGIC,
-	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC,
-	  XFS_REFC_CRC_MAGIC }
-};
-
 uint32_t
 xfs_btree_magic(
-	int			crc,
-	xfs_btnum_t		btnum)
+	struct xfs_mount		*mp,
+	const struct xfs_btree_ops	*ops)
 {
-	uint32_t		magic = xfs_magics[crc][btnum];
+	int				idx = xfs_has_crc(mp) ? 1 : 0;
+	__be32				magic = ops->buf_ops->magic[idx];
 
 	/* Ensure we asked for crc for crc-only magics. */
 	ASSERT(magic != 0);
-	return magic;
+	return be32_to_cpu(magic);
 }
 
 /*
@@ -125,8 +118,7 @@ __xfs_btree_check_lblock(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_btnum_t		btnum = cur->bc_btnum;
-	int			crc = xfs_has_crc(mp);
+	bool			crc = xfs_has_crc(mp);
 	xfs_failaddr_t		fa;
 	xfs_fsblock_t		fsb = NULLFSBLOCK;
 
@@ -140,7 +132,7 @@ __xfs_btree_check_lblock(
 			return __this_address;
 	}
 
-	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(crc, btnum))
+	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(mp, cur->bc_ops))
 		return __this_address;
 	if (be16_to_cpu(block->bb_level) != level)
 		return __this_address;
@@ -194,8 +186,7 @@ __xfs_btree_check_sblock(
 {
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_perag	*pag = cur->bc_ag.pag;
-	xfs_btnum_t		btnum = cur->bc_btnum;
-	int			crc = xfs_has_crc(mp);
+	bool			crc = xfs_has_crc(mp);
 	xfs_failaddr_t		fa;
 	xfs_agblock_t		agbno = NULLAGBLOCK;
 
@@ -207,7 +198,7 @@ __xfs_btree_check_sblock(
 			return __this_address;
 	}
 
-	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(crc, btnum))
+	if (be32_to_cpu(block->bb_magic) != xfs_btree_magic(mp, cur->bc_ops))
 		return __this_address;
 	if (be16_to_cpu(block->bb_level) != level)
 		return __this_address;
@@ -1163,21 +1154,20 @@ void
 xfs_btree_init_block_int(
 	struct xfs_mount	*mp,
 	struct xfs_btree_block	*buf,
+	const struct xfs_btree_ops *ops,
 	xfs_daddr_t		blkno,
-	xfs_btnum_t		btnum,
 	__u16			level,
 	__u16			numrecs,
-	__u64			owner,
-	unsigned int		geom_flags)
+	__u64			owner)
 {
 	bool			crc = xfs_has_crc(mp);
-	__u32			magic = xfs_btree_magic(crc, btnum);
+	__u32			magic = xfs_btree_magic(mp, ops);
 
 	buf->bb_magic = cpu_to_be32(magic);
 	buf->bb_level = cpu_to_be16(level);
 	buf->bb_numrecs = cpu_to_be16(numrecs);
 
-	if (geom_flags & XFS_BTGEO_LONG_PTRS) {
+	if (ops->geom_flags & XFS_BTGEO_LONG_PTRS) {
 		buf->bb_u.l.bb_leftsib = cpu_to_be64(NULLFSBLOCK);
 		buf->bb_u.l.bb_rightsib = cpu_to_be64(NULLFSBLOCK);
 		if (crc) {
@@ -1204,15 +1194,15 @@ xfs_btree_init_block_int(
 
 void
 xfs_btree_init_block(
-	struct xfs_mount *mp,
-	struct xfs_buf	*bp,
-	xfs_btnum_t	btnum,
-	__u16		level,
-	__u16		numrecs,
-	__u64		owner)
+	struct xfs_mount		*mp,
+	struct xfs_buf			*bp,
+	const struct xfs_btree_ops	*ops,
+	__u16				level,
+	__u16				numrecs,
+	__u64				owner)
 {
-	xfs_btree_init_block_int(mp, XFS_BUF_TO_BLOCK(bp), xfs_buf_daddr(bp),
-				 btnum, level, numrecs, owner, 0);
+	xfs_btree_init_block_int(mp, XFS_BUF_TO_BLOCK(bp), ops,
+			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
 void
@@ -1235,9 +1225,8 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp),
-				xfs_buf_daddr(bp), cur->bc_btnum, level,
-				numrecs, owner, cur->bc_ops->geom_flags);
+	xfs_btree_init_block_int(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
+			xfs_buf_daddr(bp), level, numrecs, owner);
 }
 
 /*
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index b36530e56..923f884fe 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -63,7 +63,8 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
 #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 
-uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
+struct xfs_btree_ops;
+uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
 
 /*
  * For logging record fields.
@@ -434,25 +435,12 @@ xfs_btree_reada_bufs(
 /*
  * Initialise a new btree block header
  */
-void
-xfs_btree_init_block(
-	struct xfs_mount *mp,
-	struct xfs_buf	*bp,
-	xfs_btnum_t	btnum,
-	__u16		level,
-	__u16		numrecs,
-	__u64		owner);
-
-void
-xfs_btree_init_block_int(
-	struct xfs_mount	*mp,
-	struct xfs_btree_block	*buf,
-	xfs_daddr_t		blkno,
-	xfs_btnum_t		btnum,
-	__u16			level,
-	__u16			numrecs,
-	__u64			owner,
-	unsigned int		geom_flags);
+void xfs_btree_init_block(struct xfs_mount *mp, struct xfs_buf *bp,
+		const struct xfs_btree_ops *ops, __u16 level, __u16 numrecs,
+		__u64 owner);
+void xfs_btree_init_block_int(struct xfs_mount *mp,
+		struct xfs_btree_block *buf, const struct xfs_btree_ops *ops,
+		xfs_daddr_t blkno, __u16 level, __u16 numrecs, __u64 owner);
 
 /*
  * Common btree core entry points.
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index ac99543e0..ba3383cad 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -411,9 +411,8 @@ xfs_btree_bload_prep_block(
 
 		/* Initialize it and send it out. */
 		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
-				XFS_BUF_DADDR_NULL, cur->bc_btnum, level,
-				nr_this_block, cur->bc_ino.ip->i_ino,
-				cur->bc_ops->geom_flags);
+				cur->bc_ops, XFS_BUF_DADDR_NULL, level,
+				nr_this_block, cur->bc_ino.ip->i_ino);
 
 		*bpp = NULL;
 		*blockp = ifp->if_broot;


