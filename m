Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C036659CEF
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbiL3WeD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235531AbiL3WeC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:34:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168511D0DF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:34:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C262B81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D03C433D2;
        Fri, 30 Dec 2022 22:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439638;
        bh=03iF7BQd6pjtBz37V+J1r9lQpl/J+xwUeGzATCHvZmU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cG3TBH8lsyTjhm35G5s7BotvzynphLfEoyMO8T2GUf26M5gTCrQlJmHkHwKcyEigH
         jZNCHifZVJ8aUxxHBzyuSFnBPonvJYYeq9Gzvs9kyP0PqqFcDYkEskbtI4ITy6cvUN
         A0EneBnaEne4ch9HlXddR896i0JlzoHnEDz6ByNSV/yQIjeD1gh40xiAMv/G+UJwNJ
         8FteslA/zSqq1JigH2So8Ig5eqzUgP8PKIbGZwXDRDGqcOz0tQnaMMFFw1wbN2tDGB
         9ScQmAYf6cr8myCoX9wFeqqEvNY2RtqkABtfZRlPGRGZ9K6rveRUv9LDkld9vR+/+5
         fuqbdyk4QVh/w==
Subject: [PATCH 4/8] xfs: fix confusing xfs_extent_item variable names
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:10:57 -0800
Message-ID: <167243825719.683219.739351647627977855.stgit@magnolia>
In-Reply-To: <167243825653.683219.11053689306747459204.stgit@magnolia>
References: <167243825653.683219.11053689306747459204.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Change the name of all pointers to xfs_extent_item structures to "xefi"
to make the name consistent and because the current selections ("new"
and "free") mean other things in C.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   32 ++++++++++-----------
 fs/xfs/xfs_extfree_item.c |   70 +++++++++++++++++++++++----------------------
 2 files changed, 51 insertions(+), 51 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 989cf341779b..f8ff81c3de76 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2472,20 +2472,20 @@ xfs_defer_agfl_block(
 	struct xfs_owner_info		*oinfo)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_extent_free_item	*new;		/* new element */
+	struct xfs_extent_free_item	*xefi;
 
 	ASSERT(xfs_extfree_item_cache != NULL);
 	ASSERT(oinfo != NULL);
 
-	new = kmem_cache_zalloc(xfs_extfree_item_cache,
+	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
-	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
-	new->xefi_blockcount = 1;
-	new->xefi_owner = oinfo->oi_owner;
+	xefi->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
+	xefi->xefi_blockcount = 1;
+	xefi->xefi_owner = oinfo->oi_owner;
 
 	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
 
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
+	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &xefi->xefi_list);
 }
 
 /*
@@ -2500,7 +2500,7 @@ __xfs_free_extent_later(
 	const struct xfs_owner_info	*oinfo,
 	bool				skip_discard)
 {
-	struct xfs_extent_free_item	*new;		/* new element */
+	struct xfs_extent_free_item	*xefi;
 #ifdef DEBUG
 	struct xfs_mount		*mp = tp->t_mountp;
 	xfs_agnumber_t			agno;
@@ -2519,27 +2519,27 @@ __xfs_free_extent_later(
 #endif
 	ASSERT(xfs_extfree_item_cache != NULL);
 
-	new = kmem_cache_zalloc(xfs_extfree_item_cache,
+	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
 			       GFP_KERNEL | __GFP_NOFAIL);
-	new->xefi_startblock = bno;
-	new->xefi_blockcount = (xfs_extlen_t)len;
+	xefi->xefi_startblock = bno;
+	xefi->xefi_blockcount = (xfs_extlen_t)len;
 	if (skip_discard)
-		new->xefi_flags |= XFS_EFI_SKIP_DISCARD;
+		xefi->xefi_flags |= XFS_EFI_SKIP_DISCARD;
 	if (oinfo) {
 		ASSERT(oinfo->oi_offset == 0);
 
 		if (oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK)
-			new->xefi_flags |= XFS_EFI_ATTR_FORK;
+			xefi->xefi_flags |= XFS_EFI_ATTR_FORK;
 		if (oinfo->oi_flags & XFS_OWNER_INFO_BMBT_BLOCK)
-			new->xefi_flags |= XFS_EFI_BMBT_BLOCK;
-		new->xefi_owner = oinfo->oi_owner;
+			xefi->xefi_flags |= XFS_EFI_BMBT_BLOCK;
+		xefi->xefi_owner = oinfo->oi_owner;
 	} else {
-		new->xefi_owner = XFS_RMAP_OWN_NULL;
+		xefi->xefi_owner = XFS_RMAP_OWN_NULL;
 	}
 	trace_xfs_bmap_free_defer(tp->t_mountp,
 			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
 			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
-	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &new->xefi_list);
+	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
 }
 
 #ifdef DEBUG
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 618d2f9ff535..011b50469301 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -345,30 +345,30 @@ static int
 xfs_trans_free_extent(
 	struct xfs_trans		*tp,
 	struct xfs_efd_log_item		*efdp,
-	struct xfs_extent_free_item	*free)
+	struct xfs_extent_free_item	*xefi)
 {
 	struct xfs_owner_info		oinfo = { };
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_extent		*extp;
 	uint				next_extent;
 	xfs_agnumber_t			agno = XFS_FSB_TO_AGNO(mp,
-							free->xefi_startblock);
+							xefi->xefi_startblock);
 	xfs_agblock_t			agbno = XFS_FSB_TO_AGBNO(mp,
-							free->xefi_startblock);
+							xefi->xefi_startblock);
 	int				error;
 
-	oinfo.oi_owner = free->xefi_owner;
-	if (free->xefi_flags & XFS_EFI_ATTR_FORK)
+	oinfo.oi_owner = xefi->xefi_owner;
+	if (xefi->xefi_flags & XFS_EFI_ATTR_FORK)
 		oinfo.oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
-	if (free->xefi_flags & XFS_EFI_BMBT_BLOCK)
+	if (xefi->xefi_flags & XFS_EFI_BMBT_BLOCK)
 		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
 
 	trace_xfs_bmap_free_deferred(tp->t_mountp, agno, 0, agbno,
-			free->xefi_blockcount);
+			xefi->xefi_blockcount);
 
-	error = __xfs_free_extent(tp, free->xefi_startblock,
-			free->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
-			free->xefi_flags & XFS_EFI_SKIP_DISCARD);
+	error = __xfs_free_extent(tp, xefi->xefi_startblock,
+			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
+			xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
@@ -382,8 +382,8 @@ xfs_trans_free_extent(
 	next_extent = efdp->efd_next_extent;
 	ASSERT(next_extent < efdp->efd_format.efd_nextents);
 	extp = &(efdp->efd_format.efd_extents[next_extent]);
-	extp->ext_start = free->xefi_startblock;
-	extp->ext_len = free->xefi_blockcount;
+	extp->ext_start = xefi->xefi_startblock;
+	extp->ext_len = xefi->xefi_blockcount;
 	efdp->efd_next_extent++;
 
 	return error;
@@ -411,7 +411,7 @@ STATIC void
 xfs_extent_free_log_item(
 	struct xfs_trans		*tp,
 	struct xfs_efi_log_item		*efip,
-	struct xfs_extent_free_item	*free)
+	struct xfs_extent_free_item	*xefi)
 {
 	uint				next_extent;
 	struct xfs_extent		*extp;
@@ -427,8 +427,8 @@ xfs_extent_free_log_item(
 	next_extent = atomic_inc_return(&efip->efi_next_extent) - 1;
 	ASSERT(next_extent < efip->efi_format.efi_nextents);
 	extp = &efip->efi_format.efi_extents[next_extent];
-	extp->ext_start = free->xefi_startblock;
-	extp->ext_len = free->xefi_blockcount;
+	extp->ext_start = xefi->xefi_startblock;
+	extp->ext_len = xefi->xefi_blockcount;
 }
 
 static struct xfs_log_item *
@@ -440,15 +440,15 @@ xfs_extent_free_create_intent(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_efi_log_item		*efip = xfs_efi_init(mp, count);
-	struct xfs_extent_free_item	*free;
+	struct xfs_extent_free_item	*xefi;
 
 	ASSERT(count > 0);
 
 	xfs_trans_add_item(tp, &efip->efi_item);
 	if (sort)
 		list_sort(mp, items, xfs_extent_free_diff_items);
-	list_for_each_entry(free, items, xefi_list)
-		xfs_extent_free_log_item(tp, efip, free);
+	list_for_each_entry(xefi, items, xefi_list)
+		xfs_extent_free_log_item(tp, efip, xefi);
 	return &efip->efi_item;
 }
 
@@ -470,13 +470,13 @@ xfs_extent_free_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_extent_free_item	*free;
+	struct xfs_extent_free_item	*xefi;
 	int				error;
 
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
+	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
 
-	error = xfs_trans_free_extent(tp, EFD_ITEM(done), free);
-	kmem_cache_free(xfs_extfree_item_cache, free);
+	error = xfs_trans_free_extent(tp, EFD_ITEM(done), xefi);
+	kmem_cache_free(xfs_extfree_item_cache, xefi);
 	return error;
 }
 
@@ -493,10 +493,10 @@ STATIC void
 xfs_extent_free_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_extent_free_item	*free;
+	struct xfs_extent_free_item	*xefi;
 
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	kmem_cache_free(xfs_extfree_item_cache, free);
+	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
+	kmem_cache_free(xfs_extfree_item_cache, xefi);
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
@@ -522,7 +522,7 @@ xfs_agfl_free_finish_item(
 	struct xfs_owner_info		oinfo = { };
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_efd_log_item		*efdp = EFD_ITEM(done);
-	struct xfs_extent_free_item	*free;
+	struct xfs_extent_free_item	*xefi;
 	struct xfs_extent		*extp;
 	struct xfs_buf			*agbp;
 	int				error;
@@ -531,13 +531,13 @@ xfs_agfl_free_finish_item(
 	uint				next_extent;
 	struct xfs_perag		*pag;
 
-	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	ASSERT(free->xefi_blockcount == 1);
-	agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
-	agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
-	oinfo.oi_owner = free->xefi_owner;
+	xefi = container_of(item, struct xfs_extent_free_item, xefi_list);
+	ASSERT(xefi->xefi_blockcount == 1);
+	agno = XFS_FSB_TO_AGNO(mp, xefi->xefi_startblock);
+	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
+	oinfo.oi_owner = xefi->xefi_owner;
 
-	trace_xfs_agfl_free_deferred(mp, agno, 0, agbno, free->xefi_blockcount);
+	trace_xfs_agfl_free_deferred(mp, agno, 0, agbno, xefi->xefi_blockcount);
 
 	pag = xfs_perag_get(mp, agno);
 	error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
@@ -558,11 +558,11 @@ xfs_agfl_free_finish_item(
 	next_extent = efdp->efd_next_extent;
 	ASSERT(next_extent < efdp->efd_format.efd_nextents);
 	extp = &(efdp->efd_format.efd_extents[next_extent]);
-	extp->ext_start = free->xefi_startblock;
-	extp->ext_len = free->xefi_blockcount;
+	extp->ext_start = xefi->xefi_startblock;
+	extp->ext_len = xefi->xefi_blockcount;
 	efdp->efd_next_extent++;
 
-	kmem_cache_free(xfs_extfree_item_cache, free);
+	kmem_cache_free(xfs_extfree_item_cache, xefi);
 	return error;
 }
 

