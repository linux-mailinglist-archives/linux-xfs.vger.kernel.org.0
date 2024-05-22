Return-Path: <linux-xfs+bounces-8535-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CC238CB956
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 05:01:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06521B20817
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 03:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9998D4C89;
	Wed, 22 May 2024 03:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzQyz/W8"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5983C139E
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346878; cv=none; b=TD4Wx9BRMgEtMHF7djBTFf7BGHLbk9y9Dx4p/dgEAR0VaSOuMcd37f6CNSmD5jXJFBnEX+NwYNJwwSPrrg1Al+N+qkVUr9H8tQorGK2x6p26yS7XqlZPZA9DXdAhzhkDzAejmebug/EJii8ckimvMiazOrxBp7BOt2yGEKzVSVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346878; c=relaxed/simple;
	bh=EIgV+0rlkbNws7psncy85qga41CRhbPJ+VAsInJzttE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XZFvpuK/JxPThmP3rQ7vpT7nLhUCvwLvO8Crlnh1hln/uJb9Rye3byAhQ/4HOzXZucskrmq628nklM7ABfA0kLDzCkm4HcS0v3USuUmbAevSOrLqGAOLCC1m//Exm0m74aX2Fi0/uGwbBDF2L85lHvoSLszZr874oKfy9OqKtQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzQyz/W8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EABFC2BD11;
	Wed, 22 May 2024 03:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346878;
	bh=EIgV+0rlkbNws7psncy85qga41CRhbPJ+VAsInJzttE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mzQyz/W8C3fjZKY6hmOOl3ZmbzaAd5cy7+ERFBnPZ4vkPw3Us/8d5jVDLwh/JJQ8V
	 FO+SJ7lacg7knx0pWqnLCGe2/O061GvgNSm7ms6uQnQ2Uzxj2f3MBmZ3ASWlfYQ/eD
	 Ov3DvKDbkI8p/etxTHBp/RkKd2OfZZ3BogtLAUSljyj4viQG9Eag7R5gSVDL0aY1v7
	 c6Gy/EsnHqntD1R/4q2Lfh7YEjQ/4RQuzjMel1YXzuA43SlYO73nNT3CX102Ps3Zh7
	 OMN9AKNzSfi1WJhYcZWmUaBjf6KYYoAFoiryZxa85fBVVUGKsEcnT3LXjSOXe//KtD
	 +gZX5hOdOivug==
Date: Tue, 21 May 2024 20:01:17 -0700
Subject: [PATCH 048/111] xfs: split the per-btree union in struct
 xfs_btree_cur
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532425.2478931.13479473351009767109.stgit@frogsfrogsfrogs>
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

Source kernel commit: 88ee2f4849119b82b95d6e8e2d9daa81214eb080

Split up the union that encodes btree-specific fields in struct
xfs_btree_cur.  Most fields in there are specific to the btree type
encoded in xfs_btree_ops.type, and we can use the obviously named union
for that.  But one field is specific to the bmapbt and two are shared by
the refcount and rtrefcountbt.  Move those to a separate union to make
the usage clear and not need a separate struct for the refcount-related
fields.

This will also make unnecessary some very awkward btree cursor
refc/rtrefc switching logic in the rtrefcount patchset.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c           |   22 +++++++++--------
 libxfs/xfs_bmap_btree.c     |    9 +++----
 libxfs/xfs_btree.c          |    2 +-
 libxfs/xfs_btree.h          |   55 ++++++++++++++++++-------------------------
 libxfs/xfs_btree_staging.c  |    1 +
 libxfs/xfs_refcount.c       |   24 +++++++++----------
 libxfs/xfs_refcount_btree.c |    4 ++-
 7 files changed, 54 insertions(+), 63 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index b81f3e3da..2d332989b 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -670,7 +670,7 @@ xfs_bmap_extents_to_btree(
 		goto out_root_realloc;
 	}
 
-	cur->bc_ino.allocated++;
+	cur->bc_bmap.allocated++;
 	ip->i_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
@@ -888,7 +888,7 @@ xfs_bmap_add_attrfork_btree(
 			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 			return -ENOSPC;
 		}
-		cur->bc_ino.allocated = 0;
+		cur->bc_bmap.allocated = 0;
 		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	}
 	return 0;
@@ -916,7 +916,7 @@ xfs_bmap_add_attrfork_extents(
 	error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0, flags,
 					  XFS_DATA_FORK);
 	if (cur) {
-		cur->bc_ino.allocated = 0;
+		cur->bc_bmap.allocated = 0;
 		xfs_btree_del_cursor(cur, error);
 	}
 	return error;
@@ -1740,7 +1740,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = PREV.br_blockcount - new->br_blockcount;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock) -
-			(bma->cur ? bma->cur->bc_ino.allocated : 0));
+			(bma->cur ? bma->cur->bc_bmap.allocated : 0));
 
 		PREV.br_startoff = new_endoff;
 		PREV.br_blockcount = temp;
@@ -1830,7 +1830,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = PREV.br_blockcount - new->br_blockcount;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock) -
-			(bma->cur ? bma->cur->bc_ino.allocated : 0));
+			(bma->cur ? bma->cur->bc_bmap.allocated : 0));
 
 		PREV.br_startblock = nullstartblock(da_new);
 		PREV.br_blockcount = temp;
@@ -1953,8 +1953,8 @@ xfs_bmap_add_extent_delay_real(
 		xfs_mod_delalloc(mp, (int64_t)da_new - da_old);
 
 	if (bma->cur) {
-		da_new += bma->cur->bc_ino.allocated;
-		bma->cur->bc_ino.allocated = 0;
+		da_new += bma->cur->bc_bmap.allocated;
+		bma->cur->bc_bmap.allocated = 0;
 	}
 
 	/* adjust for changes in reserved delayed indirect blocks */
@@ -2519,7 +2519,7 @@ xfs_bmap_add_extent_unwritten_real(
 
 	/* clear out the allocated field, done with it now in any case. */
 	if (cur) {
-		cur->bc_ino.allocated = 0;
+		cur->bc_bmap.allocated = 0;
 		*curp = cur;
 	}
 
@@ -2907,7 +2907,7 @@ xfs_bmap_add_extent_hole_real(
 
 	/* clear out the allocated field, done with it now in any case. */
 	if (cur)
-		cur->bc_ino.allocated = 0;
+		cur->bc_bmap.allocated = 0;
 
 	xfs_bmap_check_leaf_extents(cur, ip, whichfork);
 done:
@@ -5623,7 +5623,7 @@ __xfs_bunmapi(
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (cur) {
 		if (!error)
-			cur->bc_ino.allocated = 0;
+			cur->bc_bmap.allocated = 0;
 		xfs_btree_del_cursor(cur, error);
 	}
 	return error;
@@ -6139,7 +6139,7 @@ xfs_bmap_split_extent(
 
 del_cursor:
 	if (cur) {
-		cur->bc_ino.allocated = 0;
+		cur->bc_bmap.allocated = 0;
 		xfs_btree_del_cursor(cur, error);
 	}
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 54020dea2..9f66eee9a 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -197,10 +197,10 @@ xfs_bmbt_update_cursor(
 	ASSERT((dst->bc_tp->t_highest_agno != NULLAGNUMBER) ||
 	       (dst->bc_ino.ip->i_diflags & XFS_DIFLAG_REALTIME));
 
-	dst->bc_ino.allocated += src->bc_ino.allocated;
+	dst->bc_bmap.allocated += src->bc_bmap.allocated;
 	dst->bc_tp->t_highest_agno = src->bc_tp->t_highest_agno;
 
-	src->bc_ino.allocated = 0;
+	src->bc_bmap.allocated = 0;
 }
 
 STATIC int
@@ -255,7 +255,7 @@ xfs_bmbt_alloc_block(
 	}
 
 	ASSERT(args.len == 1);
-	cur->bc_ino.allocated++;
+	cur->bc_bmap.allocated++;
 	cur->bc_ino.ip->i_nblocks++;
 	xfs_trans_log_inode(args.tp, cur->bc_ino.ip, XFS_ILOG_CORE);
 	xfs_trans_mod_dquot_byino(args.tp, cur->bc_ino.ip,
@@ -567,8 +567,7 @@ xfs_bmbt_init_common(
 			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
 
 	cur->bc_ino.ip = ip;
-	cur->bc_ino.allocated = 0;
-
+	cur->bc_bmap.allocated = 0;
 	return cur;
 }
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index f8c348e49..6d90e10b3 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -442,7 +442,7 @@ xfs_btree_del_cursor(
 	 * zero, then we should be shut down or on our way to shutdown due to
 	 * cancelling a dirty transaction on error.
 	 */
-	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
+	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_bmap.allocated == 0 ||
 	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 
 	switch (cur->bc_ops->type) {
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 5f2b5ef85..153d86725 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -243,30 +243,6 @@ union xfs_btree_irec {
 	struct xfs_refcount_irec	rc;
 };
 
-/* Per-AG btree information. */
-struct xfs_btree_cur_ag {
-	struct xfs_perag		*pag;
-	union {
-		struct xfs_buf		*agbp;
-		struct xbtree_afakeroot	*afake;	/* for staging cursor */
-	};
-	union {
-		struct {
-			unsigned int	nr_ops;	/* # record updates */
-			unsigned int	shape_changes;	/* # of extent splits */
-		} refc;
-	};
-};
-
-/* Btree-in-inode cursor information */
-struct xfs_btree_cur_ino {
-	struct xfs_inode		*ip;
-	struct xbtree_ifakeroot		*ifake;	/* for staging cursor */
-	int				allocated;
-	short				forksize;
-	char				whichfork;
-};
-
 struct xfs_btree_level {
 	/* buffer pointer */
 	struct xfs_buf		*bp;
@@ -296,15 +272,30 @@ struct xfs_btree_cur
 	uint8_t			bc_nlevels; /* number of levels in the tree */
 	uint8_t			bc_maxlevels; /* maximum levels for this btree type */
 
-	/*
-	 * Short btree pointers need an agno to be able to turn the pointers
-	 * into physical addresses for IO, so the btree cursor switches between
-	 * bc_ino and bc_ag based on bc_ops->type.
-	 * the cursor.
-	 */
+	/* per-type information */
 	union {
-		struct xfs_btree_cur_ag	bc_ag;
-		struct xfs_btree_cur_ino bc_ino;
+		struct {
+			struct xfs_inode	*ip;
+			short			forksize;
+			char			whichfork;
+			struct xbtree_ifakeroot	*ifake;	/* for staging cursor */
+		} bc_ino;
+		struct {
+			struct xfs_perag	*pag;
+			struct xfs_buf		*agbp;
+			struct xbtree_afakeroot	*afake;	/* for staging cursor */
+		} bc_ag;
+	};
+
+	/* per-format private data */
+	union {
+		struct {
+			int		allocated;
+		} bc_bmap;	/* bmapbt */
+		struct {
+			unsigned int	nr_ops;		/* # record updates */
+			unsigned int	shape_changes;	/* # of extent splits */
+		} bc_refc;	/* refcountbt */
 	};
 
 	/* Must be at the end of the struct! */
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index e1fd57dee..80bcb7ba2 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -172,6 +172,7 @@ xfs_btree_commit_afakeroot(
 	trace_xfs_btree_commit_afakeroot(cur);
 
 	kfree((void *)cur->bc_ops);
+	cur->bc_ag.afake = NULL;
 	cur->bc_ag.agbp = agbp;
 	cur->bc_ops = ops;
 	cur->bc_flags &= ~XFS_BTREE_STAGING;
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index d0d0d8617..47049488b 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1076,7 +1076,7 @@ xfs_refcount_still_have_space(
 	 * to handle each of the shape changes to the refcount btree.
 	 */
 	overhead = xfs_allocfree_block_count(cur->bc_mp,
-				cur->bc_ag.refc.shape_changes);
+				cur->bc_refc.shape_changes);
 	overhead += cur->bc_mp->m_refc_maxlevels;
 	overhead *= cur->bc_mp->m_sb.sb_blocksize;
 
@@ -1084,17 +1084,17 @@ xfs_refcount_still_have_space(
 	 * Only allow 2 refcount extent updates per transaction if the
 	 * refcount continue update "error" has been injected.
 	 */
-	if (cur->bc_ag.refc.nr_ops > 2 &&
+	if (cur->bc_refc.nr_ops > 2 &&
 	    XFS_TEST_ERROR(false, cur->bc_mp,
 			XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE))
 		return false;
 
-	if (cur->bc_ag.refc.nr_ops == 0)
+	if (cur->bc_refc.nr_ops == 0)
 		return true;
 	else if (overhead > cur->bc_tp->t_log_res)
 		return false;
-	return  cur->bc_tp->t_log_res - overhead >
-		cur->bc_ag.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
+	return cur->bc_tp->t_log_res - overhead >
+		cur->bc_refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
 }
 
 /*
@@ -1154,7 +1154,7 @@ xfs_refcount_adjust_extents(
 			 * Either cover the hole (increment) or
 			 * delete the range (decrement).
 			 */
-			cur->bc_ag.refc.nr_ops++;
+			cur->bc_refc.nr_ops++;
 			if (tmp.rc_refcount) {
 				error = xfs_refcount_insert(cur, &tmp,
 						&found_tmp);
@@ -1215,7 +1215,7 @@ xfs_refcount_adjust_extents(
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
 				cur->bc_ag.pag->pag_agno, &ext);
-		cur->bc_ag.refc.nr_ops++;
+		cur->bc_refc.nr_ops++;
 		if (ext.rc_refcount > 1) {
 			error = xfs_refcount_update(cur, &ext);
 			if (error)
@@ -1304,7 +1304,7 @@ xfs_refcount_adjust(
 	if (shape_changed)
 		shape_changes++;
 	if (shape_changes)
-		cur->bc_ag.refc.shape_changes++;
+		cur->bc_refc.shape_changes++;
 
 	/* Now that we've taken care of the ends, adjust the middle extents */
 	error = xfs_refcount_adjust_extents(cur, agbno, aglen, adj);
@@ -1399,8 +1399,8 @@ xfs_refcount_finish_one(
 	 */
 	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
-		nr_ops = rcur->bc_ag.refc.nr_ops;
-		shape_changes = rcur->bc_ag.refc.shape_changes;
+		nr_ops = rcur->bc_refc.nr_ops;
+		shape_changes = rcur->bc_refc.shape_changes;
 		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
@@ -1412,8 +1412,8 @@ xfs_refcount_finish_one(
 			return error;
 
 		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, ri->ri_pag);
-		rcur->bc_ag.refc.nr_ops = nr_ops;
-		rcur->bc_ag.refc.shape_changes = shape_changes;
+		rcur->bc_refc.nr_ops = nr_ops;
+		rcur->bc_refc.shape_changes = shape_changes;
 	}
 	*pcur = rcur;
 
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 3d61eeaca..529091a6b 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -361,8 +361,8 @@ xfs_refcountbt_init_common(
 			&xfs_refcountbt_ops, mp->m_refc_maxlevels,
 			xfs_refcountbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
-	cur->bc_ag.refc.nr_ops = 0;
-	cur->bc_ag.refc.shape_changes = 0;
+	cur->bc_refc.nr_ops = 0;
+	cur->bc_refc.shape_changes = 0;
 	return cur;
 }
 


