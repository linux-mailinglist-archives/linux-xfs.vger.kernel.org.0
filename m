Return-Path: <linux-xfs+bounces-14317-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 988A69A2C82
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Oct 2024 20:49:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 296901F22B7B
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Oct 2024 18:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90EEF218D72;
	Thu, 17 Oct 2024 18:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rBHrKymn"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E99C219497
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190933; cv=none; b=Ld40rmttYcHV7fMIHCaIOxupeHdb9FNPmPjEIRZ4VclzaBe6aOlsYoo6Zup3Pci2wXX5uCQODNpivf0WNz+iWEpybZAmMPYgULGmcBux03zluD9t43G+ZXNqol1K8KmkvOPlYVTCapId9h2u+HYifyj+duKfC1PKICvfAqxmE8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190933; c=relaxed/simple;
	bh=jy2cnL/BF8CYeXdKjpJTmXMlD9YgFnGquha95VHIBW8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y/ig/uRfMR+8SllI93oY2cCU7UCPuu1nFa7aRrOpL6QwwYF3cu/IcG2HjemrRM6cozyXroGsQKUZIykSH4p8y7noNegvAmO2WRMqKNFar9tg5BefyVSYRmcUl59ehhnI9dwdBcACDMLFvCzyDG77IL3LbJ3bKh4Hvm2bRc+aR+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rBHrKymn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA76CC4CEC3;
	Thu, 17 Oct 2024 18:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190932;
	bh=jy2cnL/BF8CYeXdKjpJTmXMlD9YgFnGquha95VHIBW8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rBHrKymnQ9WhlFjcMlyPpoHqrh1R39749kZuAN078tkFpEeuU/8HbIvlyfGf5Ge4/
	 gHh2axbF9fMxaMjNteQgmVckcgYvu5MwQJGpFENxFsjEKipExB4lNfbGsVIYR0mbNK
	 nHfOtDTuiYURGSUeVDJ7bYjTKgRX/YE9AugrD79CoTa+8CwPyQgScgjEFcQmT/3L1K
	 x9cf68EhryBRPCfIHY47i2Pg/aAUD6lFt+dtqk8+9WrihVcdE7P+OIiBV4zmQargtL
	 GTkKsZK9amEcz2xBfcxqCaIrkgnFBRQ5vO8vy3icd8ByIt3JLznWNc1Z5psPYss/TA
	 Vfry4/+eUiZjg==
Date: Thu, 17 Oct 2024 11:48:52 -0700
Subject: [PATCH 06/22] xfs: add xfs_agbno_to_fsb and xfs_agbno_to_daddr
 helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919067960.3449971.13882048546085371556.stgit@frogsfrogsfrogs>
In-Reply-To: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
References: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Add helpers to convert an agbno to a daddr or fsbno based on a pag
structure.

This provides a simpler conversion and better type safety compared to the
existing code that passes the mount structure and the agno separately.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c             |    2 +-
 fs/xfs/libxfs/xfs_ag.h             |   16 ++++++++++++++++
 fs/xfs/libxfs/xfs_alloc.c          |   14 ++++++--------
 fs/xfs/libxfs/xfs_btree.c          |    7 +++----
 fs/xfs/libxfs/xfs_ialloc.c         |   29 +++++++++++++----------------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 +-
 fs/xfs/libxfs/xfs_refcount.c       |   11 ++++-------
 fs/xfs/libxfs/xfs_refcount_btree.c |    3 +--
 fs/xfs/scrub/bmap.c                |    5 ++---
 fs/xfs/scrub/bmap_repair.c         |    4 +---
 fs/xfs/scrub/cow_repair.c          |   18 +++++++-----------
 fs/xfs/scrub/ialloc.c              |    2 +-
 fs/xfs/scrub/ialloc_repair.c       |   13 +++++--------
 fs/xfs/scrub/newbt.c               |   17 +++++++----------
 fs/xfs/scrub/reap.c                |    8 +++-----
 fs/xfs/scrub/refcount_repair.c     |    5 ++---
 fs/xfs/scrub/repair.c              |    2 +-
 fs/xfs/scrub/rmap_repair.c         |    5 ++---
 fs/xfs/xfs_filestream.c            |    5 ++---
 fs/xfs/xfs_fsmap.c                 |   19 ++++++-------------
 fs/xfs/xfs_iwalk.c                 |    3 +--
 21 files changed, 85 insertions(+), 105 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 48ea596796b5d6..6d8a1e42615dec 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -873,7 +873,7 @@ xfs_ag_shrink_space(
 
 	/* internal log shouldn't also show up in the free space btrees */
 	error = xfs_alloc_vextent_exact_bno(&args,
-			XFS_AGB_TO_FSB(mp, pag->pag_agno, aglen - delta));
+			xfs_agbno_to_fsb(pag, aglen - delta));
 	if (!error && args.agbno == NULLAGBLOCK)
 		error = -ENOSPC;
 
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 13d8ba8a1cb705..074c31bb2d93de 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -330,4 +330,20 @@ int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
 			xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
 
+static inline xfs_fsblock_t
+xfs_agbno_to_fsb(
+	struct xfs_perag	*pag,
+	xfs_agblock_t		agbno)
+{
+	return XFS_AGB_TO_FSB(pag->pag_mount, pag->pag_agno, agbno);
+}
+
+static inline xfs_daddr_t
+xfs_agbno_to_daddr(
+	struct xfs_perag	*pag,
+	xfs_agblock_t		agbno)
+{
+	return XFS_AGB_TO_DADDR(pag->pag_mount, pag->pag_agno, agbno);
+}
+
 #endif /* __LIBXFS_AG_H */
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d36044baa4d65a..6b4a566bc532bf 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1259,7 +1259,7 @@ xfs_alloc_ag_vextent_small(
 		struct xfs_buf	*bp;
 
 		error = xfs_trans_get_buf(args->tp, args->mp->m_ddev_targp,
-				XFS_AGB_TO_DADDR(args->mp, args->agno, fbno),
+				xfs_agbno_to_daddr(args->pag, fbno),
 				args->mp->m_bsize, 0, &bp);
 		if (error)
 			goto error;
@@ -2933,9 +2933,8 @@ xfs_alloc_fix_freelist(
 		 * Deferring the free disconnects freeing up the AGFL slot from
 		 * freeing the block.
 		 */
-		error = xfs_free_extent_later(tp,
-				XFS_AGB_TO_FSB(mp, args->agno, bno), 1,
-				&targs.oinfo, XFS_AG_RESV_AGFL, 0);
+		error = xfs_free_extent_later(tp, xfs_agbno_to_fsb(pag, bno),
+				1, &targs.oinfo, XFS_AG_RESV_AGFL, 0);
 		if (error)
 			goto out_agbp_relse;
 	}
@@ -3596,7 +3595,7 @@ xfs_alloc_vextent_finish(
 		goto out_drop_perag;
 	}
 
-	args->fsbno = XFS_AGB_TO_FSB(mp, args->agno, args->agbno);
+	args->fsbno = xfs_agbno_to_fsb(args->pag, args->agbno);
 
 	ASSERT(args->len >= args->minlen);
 	ASSERT(args->len <= args->maxlen);
@@ -3648,7 +3647,6 @@ xfs_alloc_vextent_this_ag(
 	struct xfs_alloc_arg	*args,
 	xfs_agnumber_t		agno)
 {
-	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		minimum_agno;
 	uint32_t		alloc_flags = 0;
 	int			error;
@@ -3661,8 +3659,8 @@ xfs_alloc_vextent_this_ag(
 
 	trace_xfs_alloc_vextent_this_ag(args);
 
-	error = xfs_alloc_vextent_check_args(args, XFS_AGB_TO_FSB(mp, agno, 0),
-			&minimum_agno);
+	error = xfs_alloc_vextent_check_args(args,
+			xfs_agbno_to_fsb(args->pag, 0), &minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a5c4af148853f8..804a1c96941127 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1017,21 +1017,20 @@ xfs_btree_readahead_agblock(
 	struct xfs_btree_block	*block)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
 	xfs_agblock_t		left = be32_to_cpu(block->bb_u.s.bb_leftsib);
 	xfs_agblock_t		right = be32_to_cpu(block->bb_u.s.bb_rightsib);
 	int			rval = 0;
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLAGBLOCK) {
 		xfs_buf_readahead(mp->m_ddev_targp,
-				XFS_AGB_TO_DADDR(mp, agno, left),
+				xfs_agbno_to_daddr(cur->bc_ag.pag, left),
 				mp->m_bsize, cur->bc_ops->buf_ops);
 		rval++;
 	}
 
 	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLAGBLOCK) {
 		xfs_buf_readahead(mp->m_ddev_targp,
-				XFS_AGB_TO_DADDR(mp, agno, right),
+				xfs_agbno_to_daddr(cur->bc_ag.pag, right),
 				mp->m_bsize, cur->bc_ops->buf_ops);
 		rval++;
 	}
@@ -1091,7 +1090,7 @@ xfs_btree_ptr_to_daddr(
 
 	switch (cur->bc_ops->type) {
 	case XFS_BTREE_TYPE_AG:
-		*daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+		*daddr = xfs_agbno_to_daddr(cur->bc_ag.pag,
 				be32_to_cpu(ptr->s));
 		break;
 	case XFS_BTREE_TYPE_INODE:
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index a58a66a77155c6..6deb8346d1c34b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -768,8 +768,7 @@ xfs_ialloc_ag_alloc(
 		/* Allow space for the inode btree to split. */
 		args.minleft = igeo->inobt_maxlevels;
 		error = xfs_alloc_vextent_exact_bno(&args,
-				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
-						args.agbno));
+				xfs_agbno_to_fsb(pag, args.agbno));
 		if (error)
 			return error;
 
@@ -811,8 +810,8 @@ xfs_ialloc_ag_alloc(
 		 */
 		args.minleft = igeo->inobt_maxlevels;
 		error = xfs_alloc_vextent_near_bno(&args,
-				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
-						be32_to_cpu(agi->agi_root)));
+				xfs_agbno_to_fsb(pag,
+					be32_to_cpu(agi->agi_root)));
 		if (error)
 			return error;
 	}
@@ -824,8 +823,8 @@ xfs_ialloc_ag_alloc(
 	if (isaligned && args.fsbno == NULLFSBLOCK) {
 		args.alignment = igeo->cluster_align;
 		error = xfs_alloc_vextent_near_bno(&args,
-				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
-						be32_to_cpu(agi->agi_root)));
+				xfs_agbno_to_fsb(pag,
+					be32_to_cpu(agi->agi_root)));
 		if (error)
 			return error;
 	}
@@ -860,8 +859,8 @@ xfs_ialloc_ag_alloc(
 				 igeo->ialloc_blks;
 
 		error = xfs_alloc_vextent_near_bno(&args,
-				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
-						be32_to_cpu(agi->agi_root)));
+				xfs_agbno_to_fsb(pag,
+					be32_to_cpu(agi->agi_root)));
 		if (error)
 			return error;
 
@@ -1978,7 +1977,6 @@ xfs_difree_inode_chunk(
 	struct xfs_inobt_rec_incore	*rec)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	xfs_agnumber_t			agno = pag->pag_agno;
 	xfs_agblock_t			sagbno = XFS_AGINO_TO_AGBNO(mp,
 							rec->ir_startino);
 	int				startidx, endidx;
@@ -1989,8 +1987,7 @@ xfs_difree_inode_chunk(
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
-		return xfs_free_extent_later(tp,
-				XFS_AGB_TO_FSB(mp, agno, sagbno),
+		return xfs_free_extent_later(tp, xfs_agbno_to_fsb(pag, sagbno),
 				M_IGEO(mp)->ialloc_blks, &XFS_RMAP_OINFO_INODES,
 				XFS_AG_RESV_NONE, 0);
 	}
@@ -2036,9 +2033,9 @@ xfs_difree_inode_chunk(
 
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
-		error = xfs_free_extent_later(tp,
-				XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
-				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE, 0);
+		error = xfs_free_extent_later(tp, xfs_agbno_to_fsb(pag, agbno),
+				contigblk, &XFS_RMAP_OINFO_INODES,
+				XFS_AG_RESV_NONE, 0);
 		if (error)
 			return error;
 
@@ -2508,7 +2505,7 @@ xfs_imap(
 		offset = XFS_INO_TO_OFFSET(mp, ino);
 		ASSERT(offset < mp->m_sb.sb_inopblock);
 
-		imap->im_blkno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, agbno);
+		imap->im_blkno = xfs_agbno_to_daddr(pag, agbno);
 		imap->im_len = XFS_FSB_TO_BB(mp, 1);
 		imap->im_boffset = (unsigned short)(offset <<
 							mp->m_sb.sb_inodelog);
@@ -2538,7 +2535,7 @@ xfs_imap(
 	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
 		XFS_INO_TO_OFFSET(mp, ino);
 
-	imap->im_blkno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, cluster_agbno);
+	imap->im_blkno = xfs_agbno_to_daddr(pag, cluster_agbno);
 	imap->im_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
 	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 401b42d52af686..3291541ae9665a 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -120,7 +120,7 @@ __xfs_inobt_alloc_block(
 	args.resv = resv;
 
 	error = xfs_alloc_vextent_near_bno(&args,
-			XFS_AGB_TO_FSB(args.mp, args.pag->pag_agno, sbno));
+			xfs_agbno_to_fsb(args.pag, sbno));
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 198b84117df138..5e166553a7a6e9 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1154,8 +1154,7 @@ xfs_refcount_adjust_extents(
 					goto out_error;
 				}
 			} else {
-				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
-						cur->bc_ag.pag->pag_agno,
+				fsbno = xfs_agbno_to_fsb(cur->bc_ag.pag,
 						tmp.rc_startblock);
 				error = xfs_free_extent_later(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, NULL,
@@ -1217,8 +1216,7 @@ xfs_refcount_adjust_extents(
 			}
 			goto advloop;
 		} else {
-			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
-					cur->bc_ag.pag->pag_agno,
+			fsbno = xfs_agbno_to_fsb(cur->bc_ag.pag,
 					ext.rc_startblock);
 			error = xfs_free_extent_later(cur->bc_tp, fsbno,
 					ext.rc_blockcount, NULL,
@@ -1320,7 +1318,7 @@ xfs_refcount_continue_op(
 		return -EFSCORRUPTED;
 	}
 
-	ri->ri_startblock = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+	ri->ri_startblock = xfs_agbno_to_fsb(pag, new_agbno);
 
 	ASSERT(xfs_verify_fsbext(mp, ri->ri_startblock, ri->ri_blockcount));
 	ASSERT(pag->pag_agno == XFS_FSB_TO_AGNO(mp, ri->ri_startblock));
@@ -1956,8 +1954,7 @@ xfs_refcount_recover_cow_leftovers(
 			goto out_free;
 
 		/* Free the orphan record */
-		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno,
-				rr->rr_rrec.rc_startblock);
+		fsb = xfs_agbno_to_fsb(pag, rr->rr_rrec.rc_startblock);
 		xfs_refcount_free_cow_extent(tp, fsb,
 				rr->rr_rrec.rc_blockcount);
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 795928d1a66d88..c4b10fbf8892a1 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -74,8 +74,7 @@ xfs_refcountbt_alloc_block(
 	args.resv = XFS_AG_RESV_METADATA;
 
 	error = xfs_alloc_vextent_near_bno(&args,
-			XFS_AGB_TO_FSB(args.mp, args.pag->pag_agno,
-					xfs_refc_block(args.mp)));
+			xfs_agbno_to_fsb(args.pag, xfs_refc_block(args.mp)));
 	if (error)
 		goto out_error;
 	if (args.fsbno == NULLFSBLOCK) {
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 5ab2ac53c92002..a43912227dd478 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -600,9 +600,8 @@ xchk_bmap_check_rmap(
 		if (irec.br_startoff != check_rec.rm_offset)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);
-		if (irec.br_startblock != XFS_AGB_TO_FSB(sc->mp,
-				cur->bc_ag.pag->pag_agno,
-				check_rec.rm_startblock))
+		if (irec.br_startblock !=
+		    xfs_agbno_to_fsb(cur->bc_ag.pag, check_rec.rm_startblock))
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
 					check_rec.rm_offset);
 		if (irec.br_blockcount > check_rec.rm_blockcount)
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 4505f4829d53f1..dc8fdd2da174ed 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -237,7 +237,6 @@ xrep_bmap_walk_rmap(
 	void				*priv)
 {
 	struct xrep_bmap		*rb = priv;
-	struct xfs_mount		*mp = cur->bc_mp;
 	xfs_fsblock_t			fsbno;
 	int				error = 0;
 
@@ -269,8 +268,7 @@ xrep_bmap_walk_rmap(
 	if ((rec->rm_flags & XFS_RMAP_UNWRITTEN) && !rb->allow_unwritten)
 		return -EFSCORRUPTED;
 
-	fsbno = XFS_AGB_TO_FSB(mp, cur->bc_ag.pag->pag_agno,
-			rec->rm_startblock);
+	fsbno = xfs_agbno_to_fsb(cur->bc_ag.pag, rec->rm_startblock);
 
 	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK) {
 		rb->old_bmbt_block_count += rec->rm_blockcount;
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index 4de3f0f40f486c..19bded43c4fe1e 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -137,7 +137,6 @@ xrep_cow_mark_shared_staging(
 {
 	struct xrep_cow			*xc = priv;
 	struct xfs_refcount_irec	rrec;
-	xfs_fsblock_t			fsbno;
 
 	if (!xfs_refcount_check_domain(rec) ||
 	    rec->rc_domain != XFS_REFC_DOMAIN_SHARED)
@@ -145,9 +144,9 @@ xrep_cow_mark_shared_staging(
 
 	xrep_cow_trim_refcount(xc, &rrec, rec);
 
-	fsbno = XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno,
-			rrec.rc_startblock);
-	return xrep_cow_mark_file_range(xc, fsbno, rrec.rc_blockcount);
+	return xrep_cow_mark_file_range(xc,
+			xfs_agbno_to_fsb(cur->bc_ag.pag, rrec.rc_startblock),
+			rrec.rc_blockcount);
 }
 
 /*
@@ -178,8 +177,7 @@ xrep_cow_mark_missing_staging(
 		goto next;
 
 	error = xrep_cow_mark_file_range(xc,
-			XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno,
-				       xc->next_bno),
+			xfs_agbno_to_fsb(cur->bc_ag.pag, xc->next_bno),
 			rrec.rc_startblock - xc->next_bno);
 	if (error)
 		return error;
@@ -200,7 +198,6 @@ xrep_cow_mark_missing_staging_rmap(
 	void				*priv)
 {
 	struct xrep_cow			*xc = priv;
-	xfs_fsblock_t			fsbno;
 	xfs_agblock_t			rec_bno;
 	xfs_extlen_t			rec_len;
 	unsigned int			adj;
@@ -222,8 +219,8 @@ xrep_cow_mark_missing_staging_rmap(
 		rec_len -= adj;
 	}
 
-	fsbno = XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno, rec_bno);
-	return xrep_cow_mark_file_range(xc, fsbno, rec_len);
+	return xrep_cow_mark_file_range(xc,
+			xfs_agbno_to_fsb(cur->bc_ag.pag, rec_bno), rec_len);
 }
 
 /*
@@ -275,8 +272,7 @@ xrep_cow_find_bad(
 
 	if (xc->next_bno < xc->irec_startbno + xc->irec.br_blockcount) {
 		error = xrep_cow_mark_file_range(xc,
-				XFS_AGB_TO_FSB(sc->mp, pag->pag_agno,
-					       xc->next_bno),
+				xfs_agbno_to_fsb(pag, xc->next_bno),
 				xc->irec_startbno + xc->irec.br_blockcount -
 				xc->next_bno);
 		if (error)
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 750d7b0cd25a78..26938b90d22efc 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -396,7 +396,7 @@ xchk_iallocbt_check_cluster(
 	 * ir_startino can be large enough to make im_boffset nonzero.
 	 */
 	ir_holemask = (irec->ir_holemask & cluster_mask);
-	imap.im_blkno = XFS_AGB_TO_DADDR(mp, agno, agbno);
+	imap.im_blkno = xfs_agbno_to_daddr(bs->cur->bc_ag.pag, agbno);
 	imap.im_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
 	imap.im_boffset = XFS_INO_TO_OFFSET(mp, irec->ir_startino) <<
 			mp->m_sb.sb_inodelog;
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index c8d2196a04e15b..ff1a5952a9e7d0 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -307,7 +307,7 @@ xrep_ibt_process_cluster(
 	 * inobt because imap_to_bp directly maps the buffer without touching
 	 * either inode btree.
 	 */
-	imap.im_blkno = XFS_AGB_TO_DADDR(mp, sc->sa.pag->pag_agno, cluster_bno);
+	imap.im_blkno = xfs_agbno_to_daddr(sc->sa.pag, cluster_bno);
 	imap.im_len = XFS_FSB_TO_BB(mp, igeo->blocks_per_cluster);
 	imap.im_boffset = 0;
 	error = xfs_imap_to_bp(mp, sc->tp, &imap, &cluster_bp);
@@ -634,7 +634,6 @@ xrep_ibt_build_new_trees(
 	struct xfs_scrub	*sc = ri->sc;
 	struct xfs_btree_cur	*ino_cur;
 	struct xfs_btree_cur	*fino_cur = NULL;
-	xfs_fsblock_t		fsbno;
 	bool			need_finobt;
 	int			error;
 
@@ -656,9 +655,8 @@ xrep_ibt_build_new_trees(
 	 *
 	 * Start by setting up the inobt staging cursor.
 	 */
-	fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno,
-			XFS_IBT_BLOCK(sc->mp));
-	xrep_newbt_init_ag(&ri->new_inobt, sc, &XFS_RMAP_OINFO_INOBT, fsbno,
+	xrep_newbt_init_ag(&ri->new_inobt, sc, &XFS_RMAP_OINFO_INOBT,
+			xfs_agbno_to_fsb(sc->sa.pag, XFS_IBT_BLOCK(sc->mp)),
 			XFS_AG_RESV_NONE);
 	ri->new_inobt.bload.claim_block = xrep_ibt_claim_block;
 	ri->new_inobt.bload.get_records = xrep_ibt_get_records;
@@ -677,10 +675,9 @@ xrep_ibt_build_new_trees(
 		if (sc->mp->m_finobt_nores)
 			resv = XFS_AG_RESV_NONE;
 
-		fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno,
-				XFS_FIBT_BLOCK(sc->mp));
 		xrep_newbt_init_ag(&ri->new_finobt, sc, &XFS_RMAP_OINFO_INOBT,
-				fsbno, resv);
+				xfs_agbno_to_fsb(sc->sa.pag, XFS_FIBT_BLOCK(sc->mp)),
+				resv);
 		ri->new_finobt.bload.claim_block = xrep_fibt_claim_block;
 		ri->new_finobt.bload.get_records = xrep_fibt_get_records;
 
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 2aa14b7ab63060..baa00e1cf81ab2 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -186,11 +186,10 @@ xrep_newbt_add_extent(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len)
 {
-	struct xfs_mount	*mp = xnr->sc->mp;
 	struct xfs_alloc_arg	args = {
 		.tp		= NULL, /* no autoreap */
 		.oinfo		= xnr->oinfo,
-		.fsbno		= XFS_AGB_TO_FSB(mp, pag->pag_agno, agbno),
+		.fsbno		= xfs_agbno_to_fsb(pag, agbno),
 		.len		= len,
 		.resv		= xnr->resv,
 	};
@@ -210,8 +209,8 @@ xrep_newbt_validate_ag_alloc_hint(
 	    xfs_verify_fsbno(sc->mp, xnr->alloc_hint))
 		return;
 
-	xnr->alloc_hint = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno,
-					 XFS_AGFL_BLOCK(sc->mp) + 1);
+	xnr->alloc_hint =
+		xfs_agbno_to_fsb(sc->sa.pag, XFS_AGFL_BLOCK(sc->mp) + 1);
 }
 
 /* Allocate disk space for a new per-AG btree. */
@@ -376,7 +375,6 @@ xrep_newbt_free_extent(
 	struct xfs_scrub	*sc = xnr->sc;
 	xfs_agblock_t		free_agbno = resv->agbno;
 	xfs_extlen_t		free_aglen = resv->len;
-	xfs_fsblock_t		fsbno;
 	int			error;
 
 	if (!btree_committed || resv->used == 0) {
@@ -413,9 +411,9 @@ xrep_newbt_free_extent(
 	 * Use EFIs to free the reservations.  This reduces the chance
 	 * that we leak blocks if the system goes down.
 	 */
-	fsbno = XFS_AGB_TO_FSB(sc->mp, resv->pag->pag_agno, free_agbno);
-	error = xfs_free_extent_later(sc->tp, fsbno, free_aglen, &xnr->oinfo,
-			xnr->resv, XFS_FREE_EXTENT_SKIP_DISCARD);
+	error = xfs_free_extent_later(sc->tp,
+			xfs_agbno_to_fsb(resv->pag, free_agbno), free_aglen,
+			&xnr->oinfo, xnr->resv, XFS_FREE_EXTENT_SKIP_DISCARD);
 	if (error)
 		return error;
 
@@ -545,8 +543,7 @@ xrep_newbt_claim_block(
 			xnr->oinfo.oi_owner);
 
 	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
-		ptr->l = cpu_to_be64(XFS_AGB_TO_FSB(mp, resv->pag->pag_agno,
-								agbno));
+		ptr->l = cpu_to_be64(xfs_agbno_to_fsb(resv->pag, agbno));
 	else
 		ptr->s = cpu_to_be32(agbno);
 
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 53697f3c5e1b0b..d65ad6aa856f4d 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -263,7 +263,6 @@ xreap_agextent_binval(
 	struct xfs_scrub	*sc = rs->sc;
 	struct xfs_perag	*pag = sc->sa.pag;
 	struct xfs_mount	*mp = sc->mp;
-	xfs_agnumber_t		agno = sc->sa.pag->pag_agno;
 	xfs_agblock_t		agbno_next = agbno + *aglenp;
 	xfs_agblock_t		bno = agbno;
 
@@ -284,7 +283,7 @@ xreap_agextent_binval(
 	 */
 	while (bno < agbno_next) {
 		struct xrep_bufscan	scan = {
-			.daddr		= XFS_AGB_TO_DADDR(mp, agno, bno),
+			.daddr		= xfs_agbno_to_daddr(pag, bno),
 			.max_sectors	= xrep_bufscan_max_sectors(mp,
 							agbno_next - bno),
 			.daddr_step	= XFS_FSB_TO_BB(mp, 1),
@@ -391,7 +390,7 @@ xreap_agextent_iter(
 	xfs_fsblock_t		fsbno;
 	int			error = 0;
 
-	fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno, agbno);
+	fsbno = xfs_agbno_to_fsb(sc->sa.pag, agbno);
 
 	/*
 	 * If there are other rmappings, this block is cross linked and must
@@ -780,7 +779,6 @@ xreap_bmapi_binval(
 	xfs_fileoff_t		off;
 	xfs_fileoff_t		max_off;
 	xfs_extlen_t		scan_blocks;
-	xfs_agnumber_t		agno = sc->sa.pag->pag_agno;
 	xfs_agblock_t		bno;
 	xfs_agblock_t		agbno;
 	xfs_agblock_t		agbno_next;
@@ -837,7 +835,7 @@ xreap_bmapi_binval(
 	 */
 	while (bno < agbno_next) {
 		struct xrep_bufscan	scan = {
-			.daddr		= XFS_AGB_TO_DADDR(mp, agno, bno),
+			.daddr		= xfs_agbno_to_daddr(pag, bno),
 			.max_sectors	= xrep_bufscan_max_sectors(mp,
 								scan_blocks),
 			.daddr_step	= XFS_FSB_TO_BB(mp, 1),
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index a00d7ce7ae5b87..4240fff459cb1d 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -590,7 +590,6 @@ xrep_refc_build_new_tree(
 	struct xfs_scrub	*sc = rr->sc;
 	struct xfs_btree_cur	*refc_cur;
 	struct xfs_perag	*pag = sc->sa.pag;
-	xfs_fsblock_t		fsbno;
 	int			error;
 
 	error = xrep_refc_sort_records(rr);
@@ -603,8 +602,8 @@ xrep_refc_build_new_tree(
 	 * to root the new btree while it's under construction and before we
 	 * attach it to the AG header.
 	 */
-	fsbno = XFS_AGB_TO_FSB(sc->mp, pag->pag_agno, xfs_refc_block(sc->mp));
-	xrep_newbt_init_ag(&rr->new_btree, sc, &XFS_RMAP_OINFO_REFC, fsbno,
+	xrep_newbt_init_ag(&rr->new_btree, sc, &XFS_RMAP_OINFO_REFC,
+			xfs_agbno_to_fsb(pag, xfs_refc_block(sc->mp)),
 			XFS_AG_RESV_METADATA);
 	rr->new_btree.bload.get_records = xrep_refc_get_records;
 	rr->new_btree.bload.claim_block = xrep_refc_claim_block;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 67478294f11ae8..289adabbbb02a8 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -483,7 +483,7 @@ xrep_findroot_block(
 	int				block_level;
 	int				error = 0;
 
-	daddr = XFS_AGB_TO_DADDR(mp, ri->sc->sa.pag->pag_agno, agbno);
+	daddr = xfs_agbno_to_daddr(ri->sc->sa.pag, agbno);
 
 	/*
 	 * Blocks in the AGFL have stale contents that might just happen to
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index e8080eba37d29b..f99849ae8f67e2 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -1272,7 +1272,6 @@ xrep_rmap_build_new_tree(
 	struct xfs_perag	*pag = sc->sa.pag;
 	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
 	struct xfs_btree_cur	*rmap_cur;
-	xfs_fsblock_t		fsbno;
 	int			error;
 
 	/*
@@ -1290,9 +1289,9 @@ xrep_rmap_build_new_tree(
 	 * rmapbt per-AG reservation, which we will adjust further after
 	 * committing the new btree.
 	 */
-	fsbno = XFS_AGB_TO_FSB(sc->mp, pag->pag_agno, XFS_RMAP_BLOCK(sc->mp));
 	xrep_newbt_init_ag(&rr->new_btree, sc, &XFS_RMAP_OINFO_SKIP_UPDATE,
-			fsbno, XFS_AG_RESV_RMAPBT);
+			xfs_agbno_to_fsb(pag, XFS_RMAP_BLOCK(sc->mp)),
+			XFS_AG_RESV_RMAPBT);
 	rr->new_btree.bload.get_records = xrep_rmap_get_records;
 	rr->new_btree.bload.claim_block = xrep_rmap_claim_block;
 	rr->new_btree.alloc_vextent = xrep_rmap_alloc_vextent;
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index e3aaa055559781..f5661d6d703ac2 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -230,7 +230,7 @@ xfs_filestream_lookup_association(
 
 	trace_xfs_filestream_lookup(pag, ap->ip->i_ino);
 
-	ap->blkno = XFS_AGB_TO_FSB(args->mp, pag->pag_agno, 0);
+	ap->blkno = xfs_agbno_to_fsb(pag, 0);
 	xfs_bmap_adjacent(ap);
 
 	/*
@@ -347,7 +347,6 @@ xfs_filestream_select_ag(
 	struct xfs_alloc_arg	*args,
 	xfs_extlen_t		*longest)
 {
-	struct xfs_mount	*mp = args->mp;
 	struct xfs_inode	*pip;
 	xfs_ino_t		ino = 0;
 	int			error = 0;
@@ -373,7 +372,7 @@ xfs_filestream_select_ag(
 		return error;
 
 out_select:
-	ap->blkno = XFS_AGB_TO_FSB(mp, args->pag->pag_agno, 0);
+	ap->blkno = xfs_agbno_to_fsb(args->pag, 0);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 67140ef8c3232c..eff198ae1ce33a 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -391,15 +391,11 @@ xfs_getfsmap_datadev_helper(
 	const struct xfs_rmap_irec	*rec,
 	void				*priv)
 {
-	struct xfs_mount		*mp = cur->bc_mp;
 	struct xfs_getfsmap_info	*info = priv;
-	xfs_fsblock_t			fsb;
-	xfs_daddr_t			rec_daddr;
 
-	fsb = XFS_AGB_TO_FSB(mp, cur->bc_ag.pag->pag_agno, rec->rm_startblock);
-	rec_daddr = XFS_FSB_TO_DADDR(mp, fsb);
-
-	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr, 0);
+	return xfs_getfsmap_helper(cur->bc_tp, info, rec,
+			xfs_agbno_to_daddr(cur->bc_ag.pag, rec->rm_startblock),
+			0);
 }
 
 /* Transform a bnobt irec into a fsmap */
@@ -409,13 +405,8 @@ xfs_getfsmap_datadev_bnobt_helper(
 	const struct xfs_alloc_rec_incore *rec,
 	void				*priv)
 {
-	struct xfs_mount		*mp = cur->bc_mp;
 	struct xfs_getfsmap_info	*info = priv;
 	struct xfs_rmap_irec		irec;
-	xfs_daddr_t			rec_daddr;
-
-	rec_daddr = XFS_AGB_TO_DADDR(mp, cur->bc_ag.pag->pag_agno,
-			rec->ar_startblock);
 
 	irec.rm_startblock = rec->ar_startblock;
 	irec.rm_blockcount = rec->ar_blockcount;
@@ -423,7 +414,9 @@ xfs_getfsmap_datadev_bnobt_helper(
 	irec.rm_offset = 0;
 	irec.rm_flags = 0;
 
-	return xfs_getfsmap_helper(cur->bc_tp, info, &irec, rec_daddr, 0);
+	return xfs_getfsmap_helper(cur->bc_tp, info, &irec,
+			xfs_agbno_to_daddr(cur->bc_ag.pag, rec->ar_startblock),
+			0);
 }
 
 /* Set rmap flags based on the getfsmap flags */
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 86f14ec7c31fed..894318886a5670 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -100,7 +100,6 @@ xfs_iwalk_ichunk_ra(
 	struct xfs_inobt_rec_incore	*irec)
 {
 	struct xfs_ino_geometry		*igeo = M_IGEO(mp);
-	xfs_agnumber_t			agno = pag->pag_agno;
 	xfs_agblock_t			agbno;
 	struct blk_plug			plug;
 	int				i;	/* inode chunk index */
@@ -114,7 +113,7 @@ xfs_iwalk_ichunk_ra(
 		imask = xfs_inobt_maskn(i, igeo->inodes_per_cluster);
 		if (imask & ~irec->ir_free) {
 			xfs_buf_readahead(mp->m_ddev_targp,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
+					xfs_agbno_to_daddr(pag, agbno),
 					igeo->blocks_per_cluster * mp->m_bsize,
 					&xfs_inode_buf_ops);
 		}


