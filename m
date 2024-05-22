Return-Path: <linux-xfs+bounces-8529-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD5028CB94D
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 05:00:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CB611F22167
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 03:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5C652F6A;
	Wed, 22 May 2024 03:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GkkW340e"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DADC5234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346800; cv=none; b=SjgwL0C11hL+2gRlAV3cY8fwQWMCvgpOp1vHUQKjJbjiPA3TGGLoRUqyt6eBNyQMSnLF7ZxeYGyY1E9XIlv7Cf7s+RQJ+/6n7PinXk6GEZRF5vKe1CP99SgejnSDJvp3rUntrlxA09HjG+SPfYp270y3qN99jAO7bR26W9m+WtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346800; c=relaxed/simple;
	bh=hE46O5h8hVo7klL44SMpiRX2KwZVxjNhwyOHoN+zAJk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UD6712IS6fj+JincMJEIxcVTW+FqbOlQwvwcG5Ky/Wva8Rrsfm7pVJrP2/8ITq3ab/tPmVsOh9Fg5ZhZcu7KNwu8HKCWlgSpK1SwLJodjBJ8EIYrkvVXR+0gESQd2jL+VZXUL4tUctCkt60mjaF9MlISOpA24qioWtFGQo0Pgfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GkkW340e; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD91FC2BD11;
	Wed, 22 May 2024 02:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346799;
	bh=hE46O5h8hVo7klL44SMpiRX2KwZVxjNhwyOHoN+zAJk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GkkW340e7emqjcal33mK4UtcZtzIfoOadEnmqx6g0M5+bVErYnz9UksvjvSGs2tD9
	 nz0FwkvPfKhyPHoyCjx6/QKInjStnT1RI5UwPR7gANJ3zIBHMPZY+o8wBsqU69GAeA
	 DFUxn/RuskE6ewYwnv5CegIeRJJHEn1kC0gNWQjqwwYBw6kolJddLMjxT5gJA9jTMt
	 JZVo3r1z8/8SIOspC29WuNMD61nZoSjf939GenL4n0mwYGmoaki+nX6aJCs2hiXAph
	 SfTaB5HWhw/j/YNUY0qaLHV/nvugIODCzxR1Edy59fIWEEohWf+FbRX4HVBai8AzVA
	 gJOMV8uvta1Lw==
Date: Tue, 21 May 2024 19:59:59 -0700
Subject: [PATCH 043/111] xfs: move the btree stats offset into struct
 btree_ops
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532355.2478931.9553212509600485143.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 07b7f2e3172b97da2a7ac273ecbaf173cc09a9f4

The statistics offset is completely static, move it into the btree_ops
structure instead of the cursor.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |   17 +++++++----------
 libxfs/xfs_bmap_btree.c     |    2 +-
 libxfs/xfs_btree.h          |   10 +++++++---
 libxfs/xfs_ialloc_btree.c   |   20 +++++++++-----------
 libxfs/xfs_refcount_btree.c |    3 +--
 libxfs/xfs_rmap_btree.c     |    3 +--
 6 files changed, 26 insertions(+), 29 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 51c6703db..fab420a6c 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -457,6 +457,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 	.key_len		= sizeof(xfs_alloc_key_t),
 
 	.lru_refs		= XFS_ALLOC_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_abtb_2),
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
@@ -484,6 +485,7 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 	.key_len		= sizeof(xfs_alloc_key_t),
 
 	.lru_refs		= XFS_ALLOC_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_abtc_2),
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
@@ -512,22 +514,17 @@ xfs_allocbt_init_common(
 	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)
 {
+	const struct xfs_btree_ops *ops = &xfs_bnobt_ops;
 	struct xfs_btree_cur	*cur;
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	if (btnum == XFS_BTNUM_CNT) {
-		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_cntbt_ops,
-				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
-	} else {
-		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_bnobt_ops,
-				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
-	}
+	if (btnum == XFS_BTNUM_CNT)
+		ops = &xfs_cntbt_ops;
 
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum, ops, mp->m_alloc_maxlevels,
+			xfs_allocbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
-
 	return cur;
 }
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 966e793b0..f149dddd9 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -530,6 +530,7 @@ const struct xfs_btree_ops xfs_bmbt_ops = {
 	.key_len		= sizeof(xfs_bmbt_key_t),
 
 	.lru_refs		= XFS_BMAP_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_bmbt_2),
 
 	.dup_cursor		= xfs_bmbt_dup_cursor,
 	.update_cursor		= xfs_bmbt_update_cursor,
@@ -563,7 +564,6 @@ xfs_bmbt_init_common(
 
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP, &xfs_bmbt_ops,
 			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
-	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.allocated = 0;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 39df108a3..2a1f30a84 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -87,9 +87,11 @@ uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
  * Generic stats interface
  */
 #define XFS_BTREE_STATS_INC(cur, stat)	\
-	XFS_STATS_INC_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat)
+	XFS_STATS_INC_OFF((cur)->bc_mp, \
+		(cur)->bc_ops->statoff + __XBTS_ ## stat)
 #define XFS_BTREE_STATS_ADD(cur, stat, val)	\
-	XFS_STATS_ADD_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat, val)
+	XFS_STATS_ADD_OFF((cur)->bc_mp, \
+		(cur)->bc_ops->statoff + __XBTS_ ## stat, val)
 
 enum xbtree_key_contig {
 	XBTREE_KEY_GAP = 0,
@@ -123,6 +125,9 @@ struct xfs_btree_ops {
 	/* LRU refcount to set on each btree buffer created */
 	unsigned int		lru_refs;
 
+	/* offset of btree stats array */
+	unsigned int		statoff;
+
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
 	void	(*update_cursor)(struct xfs_btree_cur *src,
@@ -280,7 +285,6 @@ struct xfs_btree_cur
 	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
 	uint8_t			bc_nlevels; /* number of levels in the tree */
 	uint8_t			bc_maxlevels; /* maximum levels for this btree type */
-	int			bc_statoff; /* offset of btree stats array */
 
 	/*
 	 * Short btree pointers need an agno to be able to turn the pointers
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 332d497ea..e23c5413f 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -402,6 +402,7 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 	.key_len		= sizeof(xfs_inobt_key_t),
 
 	.lru_refs		= XFS_INO_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_ibt_2),
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_inobt_set_root,
@@ -426,6 +427,7 @@ const struct xfs_btree_ops xfs_finobt_ops = {
 	.key_len		= sizeof(xfs_inobt_key_t),
 
 	.lru_refs		= XFS_INO_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_fibt_2),
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_finobt_set_root,
@@ -455,20 +457,16 @@ xfs_inobt_init_common(
 	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
 {
 	struct xfs_mount	*mp = pag->pag_mount;
+	const struct xfs_btree_ops *ops = &xfs_inobt_ops;
 	struct xfs_btree_cur	*cur;
 
-	if (btnum == XFS_BTNUM_INO) {
-		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_inobt_ops,
-				M_IGEO(mp)->inobt_maxlevels,
-				xfs_inobt_cur_cache);
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
-	} else {
-		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_finobt_ops,
-				M_IGEO(mp)->inobt_maxlevels,
-				xfs_inobt_cur_cache);
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
-	}
+	ASSERT(btnum == XFS_BTNUM_INO || btnum == XFS_BTNUM_FINO);
 
+	if (btnum == XFS_BTNUM_FINO)
+		ops = &xfs_finobt_ops;
+
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum, ops,
+			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	return cur;
 }
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 1774b0477..4ee259278 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -321,6 +321,7 @@ const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.key_len		= sizeof(struct xfs_refcount_key),
 
 	.lru_refs		= XFS_REFC_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_refcbt_2),
 
 	.dup_cursor		= xfs_refcountbt_dup_cursor,
 	.set_root		= xfs_refcountbt_set_root,
@@ -356,8 +357,6 @@ xfs_refcountbt_init_common(
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC,
 			&xfs_refcountbt_ops, mp->m_refc_maxlevels,
 			xfs_refcountbt_cur_cache);
-	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
-
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 6a7a9a176..6f9bc43c2 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -477,6 +477,7 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
 
 	.lru_refs		= XFS_RMAP_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_rmap_2),
 
 	.dup_cursor		= xfs_rmapbt_dup_cursor,
 	.set_root		= xfs_rmapbt_set_root,
@@ -507,8 +508,6 @@ xfs_rmapbt_init_common(
 	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
-	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
-
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	return cur;
 }


