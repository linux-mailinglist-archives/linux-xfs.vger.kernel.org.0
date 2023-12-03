Return-Path: <linux-xfs+bounces-340-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA91480267A
	for <lists+linux-xfs@lfdr.de>; Sun,  3 Dec 2023 20:03:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06CB91C20311
	for <lists+linux-xfs@lfdr.de>; Sun,  3 Dec 2023 19:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484991799C;
	Sun,  3 Dec 2023 19:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngSMat9I"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8F117748
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:03:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80457C433C7;
	Sun,  3 Dec 2023 19:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630209;
	bh=1m0Gx+KlUxrImIw8mAq0kI/B/mv8a7WNbWa0US+Rs1E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ngSMat9IodLYfvYmVBZLNfSbcygy7//GvKTzrQ+T215McDUt8Wdd41sRzrXYHtRPj
	 DWtAMpN3LyAUQ9PcgMVDzEl8+fl+CV2Vf07s2EduYge1M+OXCovaZeCzfefRk6fAav
	 uAJ2oXdU8rLEq18h+iKPRnYsGpBxh72PvsMxGUqm7z1qX6WEwfNQO2Kpa5XdX2On58
	 cyFJ1ibkBDmENFTRWOxxYG3WPHKXM1UagnFmT/Vap/Gzay3Avg9NnQTT0FndoeFc/6
	 d0RTpJpWCTGesxXGC/oBrLKQz0n+p3w3raVXa850eSaqx3dpDZoIUMx9sFcsQPBP3Z
	 ayCIk8gdWx2hQ==
Date: Sun, 03 Dec 2023 11:03:29 -0800
Subject: [PATCH 3/9] xfs: collapse the ->finish_item helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170162990215.3037772.6031433086898908600.stgit@frogsfrogsfrogs>
In-Reply-To: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs>
References: <170162990150.3037772.1562521806690622168.stgit@frogsfrogsfrogs>
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

Each log item's ->finish_item function sets up a small amount of state
and calls another function to do the work.  Collapse that other function
into ->finish_item to reduce the call stack height.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c     |   60 ++++++++++-------------------
 fs/xfs/xfs_bmap_item.c     |   18 +--------
 fs/xfs/xfs_extfree_item.c  |   90 ++++++++++++++++----------------------------
 fs/xfs/xfs_refcount_item.c |   18 ---------
 fs/xfs/xfs_rmap_item.c     |   18 ---------
 5 files changed, 58 insertions(+), 146 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 237e5e61d173..5589438d5ea1 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -310,34 +310,6 @@ xfs_attrd_item_intent(
 	return &ATTRD_ITEM(lip)->attrd_attrip->attri_item;
 }
 
-/*
- * Performs one step of an attribute update intent and marks the attrd item
- * dirty..  An attr operation may be a set or a remove.  Note that the
- * transaction is marked dirty regardless of whether the operation succeeds or
- * fails to support the ATTRI/ATTRD lifecycle rules.
- */
-STATIC int
-xfs_xattri_finish_update(
-	struct xfs_attr_intent		*attr,
-	struct xfs_attrd_log_item	*attrdp)
-{
-	struct xfs_da_args		*args = attr->xattri_da_args;
-	int				error;
-
-	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP))
-		return -EIO;
-
-	/* If an attr removal is trivially complete, we're done. */
-	if (attr->xattri_op_flags == XFS_ATTRI_OP_FLAGS_REMOVE &&
-	    !xfs_inode_hasattr(args->dp))
-		return 0;
-
-	error = xfs_attr_set_iter(attr);
-	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
-		error = -EAGAIN;
-	return error;
-}
-
 /* Log an attr to the intent item. */
 STATIC void
 xfs_attr_log_item(
@@ -434,23 +406,33 @@ xfs_attr_finish_item(
 	struct xfs_btree_cur		**state)
 {
 	struct xfs_attr_intent		*attr;
-	struct xfs_attrd_log_item	*done_item = NULL;
+	struct xfs_da_args		*args;
 	int				error;
 
 	attr = container_of(item, struct xfs_attr_intent, xattri_list);
-	if (done)
-		done_item = ATTRD_ITEM(done);
+	args = attr->xattri_da_args;
 
-	/*
-	 * Always reset trans after EAGAIN cycle
-	 * since the transaction is new
-	 */
-	attr->xattri_da_args->trans = tp;
+	/* Reset trans after EAGAIN cycle since the transaction is new */
+	args->trans = tp;
 
-	error = xfs_xattri_finish_update(attr, done_item);
-	if (error != -EAGAIN)
-		xfs_attr_free_item(attr);
+	if (XFS_TEST_ERROR(false, args->dp->i_mount, XFS_ERRTAG_LARP)) {
+		error = -EIO;
+		goto out;
+	}
 
+	/* If an attr removal is trivially complete, we're done. */
+	if (attr->xattri_op_flags == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    !xfs_inode_hasattr(args->dp)) {
+		error = 0;
+		goto out;
+	}
+
+	error = xfs_attr_set_iter(attr);
+	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
+		return -EAGAIN;
+
+out:
+	xfs_attr_free_item(attr);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index c62d029ad723..da5c91cc00cc 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -238,20 +238,6 @@ xfs_trans_get_bud(
 	return budp;
 }
 
-/*
- * Finish an bmap update and log it to the BUD. Note that the
- * transaction is marked dirty regardless of whether the bmap update
- * succeeds or fails to support the BUI/BUD lifecycle rules.
- */
-static int
-xfs_trans_log_finish_bmap_update(
-	struct xfs_trans		*tp,
-	struct xfs_bud_log_item		*budp,
-	struct xfs_bmap_intent		*bi)
-{
-	return xfs_bmap_finish_one(tp, bi);
-}
-
 /* Sort bmap intents by inode. */
 static int
 xfs_bmap_update_diff_items(
@@ -378,7 +364,7 @@ xfs_bmap_update_put_group(
 	xfs_perag_intent_put(bi->bi_pag);
 }
 
-/* Process a deferred rmap update. */
+/* Process a deferred bmap update. */
 STATIC int
 xfs_bmap_update_finish_item(
 	struct xfs_trans		*tp,
@@ -391,7 +377,7 @@ xfs_bmap_update_finish_item(
 
 	bi = container_of(item, struct xfs_bmap_intent, bi_list);
 
-	error = xfs_trans_log_finish_bmap_update(tp, BUD_ITEM(done), bi);
+	error = xfs_bmap_finish_one(tp, bi);
 	if (!error && bi->bi_bmap.br_blockcount > 0) {
 		ASSERT(bi->bi_type == XFS_BMAP_UNMAP);
 		return -EAGAIN;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index e8e02f816cbe..581a70acd1ac 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -364,59 +364,6 @@ xfs_efd_from_efi(
 	efdp->efd_next_extent = efip->efi_format.efi_nextents;
 }
 
-/*
- * Free an extent and log it to the EFD. Note that the transaction is marked
- * dirty regardless of whether the extent free succeeds or fails to support the
- * EFI/EFD lifecycle rules.
- */
-static int
-xfs_trans_free_extent(
-	struct xfs_trans		*tp,
-	struct xfs_efd_log_item		*efdp,
-	struct xfs_extent_free_item	*xefi)
-{
-	struct xfs_owner_info		oinfo = { };
-	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_extent		*extp;
-	uint				next_extent;
-	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp,
-							xefi->xefi_startblock);
-	int				error;
-
-	oinfo.oi_owner = xefi->xefi_owner;
-	if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
-		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
-	if (xefi->xefi_flags & XFS_EFI_BMBT_BLOCK)
-		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
-
-	trace_xfs_bmap_free_deferred(tp->t_mountp, xefi->xefi_pag->pag_agno, 0,
-			agbno, xefi->xefi_blockcount);
-
-	error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
-			xefi->xefi_blockcount, &oinfo, xefi->xefi_agresv,
-			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
-
-	/*
-	 * If we need a new transaction to make progress, the caller will log a
-	 * new EFI with the current contents. It will also log an EFD to cancel
-	 * the existing EFI, and so we need to copy all the unprocessed extents
-	 * in this EFI to the EFD so this works correctly.
-	 */
-	if (error == -EAGAIN) {
-		xfs_efd_from_efi(efdp);
-		return error;
-	}
-
-	next_extent = efdp->efd_next_extent;
-	ASSERT(next_extent < efdp->efd_format.efd_nextents);
-	extp = &(efdp->efd_format.efd_extents[next_extent]);
-	extp->ext_start = xefi->xefi_startblock;
-	extp->ext_len = xefi->xefi_blockcount;
-	efdp->efd_next_extent++;
-
-	return error;
-}
-
 /* Sort bmap items by AG. */
 static int
 xfs_extent_free_diff_items(
@@ -517,19 +464,48 @@ xfs_extent_free_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
+	struct xfs_owner_info		oinfo = { };
 	struct xfs_extent_free_item	*xefi;
+	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_extent		*extp;
+	uint				next_extent;
+	xfs_agblock_t			agbno;
 	int				error;
 
 	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
+	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
 
-	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
+	oinfo.oi_owner = xefi->xefi_owner;
+	if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
+		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
+	if (xefi->xefi_flags & XFS_EFI_BMBT_BLOCK)
+		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
+
+	trace_xfs_bmap_free_deferred(tp->t_mountp, xefi->xefi_pag->pag_agno, 0,
+			agbno, xefi->xefi_blockcount);
 
 	/*
-	 * Don't free the XEFI if we need a new transaction to complete
-	 * processing of it.
+	 * If we need a new transaction to make progress, the caller will log a
+	 * new EFI with the current contents. It will also log an EFD to cancel
+	 * the existing EFI, and so we need to copy all the unprocessed extents
+	 * in this EFI to the EFD so this works correctly.
 	 */
-	if (error == -EAGAIN)
+	error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
+			xefi->xefi_blockcount, &oinfo, xefi->xefi_agresv,
+			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
+	if (error == -EAGAIN) {
+		xfs_efd_from_efi(efdp);
 		return error;
+	}
+
+	/* Add the work we finished to the EFD, even though nobody uses that */
+	next_extent = efdp->efd_next_extent;
+	ASSERT(next_extent < efdp->efd_format.efd_nextents);
+	extp = &(efdp->efd_format.efd_extents[next_extent]);
+	extp->ext_start = xefi->xefi_startblock;
+	extp->ext_len = xefi->xefi_blockcount;
+	efdp->efd_next_extent++;
 
 	xfs_extent_free_put_group(xefi);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2628b1e3969c..7273f538db2e 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -244,21 +244,6 @@ xfs_trans_get_cud(
 	return cudp;
 }
 
-/*
- * Finish an refcount update and log it to the CUD. Note that the
- * transaction is marked dirty regardless of whether the refcount
- * update succeeds or fails to support the CUI/CUD lifecycle rules.
- */
-static int
-xfs_trans_log_finish_refcount_update(
-	struct xfs_trans		*tp,
-	struct xfs_cud_log_item		*cudp,
-	struct xfs_refcount_intent	*ri,
-	struct xfs_btree_cur		**pcur)
-{
-	return xfs_refcount_finish_one(tp, ri, pcur);
-}
-
 /* Sort refcount intents by AG. */
 static int
 xfs_refcount_update_diff_items(
@@ -383,10 +368,9 @@ xfs_refcount_update_finish_item(
 	int				error;
 
 	ri = container_of(item, struct xfs_refcount_intent, ri_list);
-	error = xfs_trans_log_finish_refcount_update(tp, CUD_ITEM(done), ri,
-			state);
 
 	/* Did we run out of reservation?  Requeue what we didn't finish. */
+	error = xfs_refcount_finish_one(tp, ri, state);
 	if (!error && ri->ri_blockcount > 0) {
 		ASSERT(ri->ri_type == XFS_REFCOUNT_INCREASE ||
 		       ri->ri_type == XFS_REFCOUNT_DECREASE);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 8f216a13a7f2..d54fd925b746 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -285,21 +285,6 @@ xfs_trans_set_rmap_flags(
 	}
 }
 
-/*
- * Finish an rmap update and log it to the RUD. Note that the transaction is
- * marked dirty regardless of whether the rmap update succeeds or fails to
- * support the RUI/RUD lifecycle rules.
- */
-static int
-xfs_trans_log_finish_rmap_update(
-	struct xfs_trans		*tp,
-	struct xfs_rud_log_item		*rudp,
-	struct xfs_rmap_intent		*ri,
-	struct xfs_btree_cur		**pcur)
-{
-	return xfs_rmap_finish_one(tp, ri, pcur);
-}
-
 /* Sort rmap intents by AG. */
 static int
 xfs_rmap_update_diff_items(
@@ -409,8 +394,7 @@ xfs_rmap_update_finish_item(
 
 	ri = container_of(item, struct xfs_rmap_intent, ri_list);
 
-	error = xfs_trans_log_finish_rmap_update(tp, RUD_ITEM(done), ri,
-			state);
+	error = xfs_rmap_finish_one(tp, ri, state);
 
 	xfs_rmap_update_put_group(ri);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);


