Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B5E659CF1
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbiL3Wec (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiL3Web (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:34:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C4F1A380
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:34:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 123B161C15
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7046EC433D2;
        Fri, 30 Dec 2022 22:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439669;
        bh=Kkpvm/JXON97QU9RxnVsHHO/aIEuCZO7olNLaKTPFrA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t0xTWntr94jVn7nfWxlHyOVDwfWO+XyjWCLvtVI4yQxwE/jcRN9m3WphfP6Orf1ZD
         znb5rFab7qSYfFnstJV5qftDG1fFSktAIqlVGlk719sx2g2eukIOJvMUXmt057NhEP
         UL6KGzUCapcb7Ti7AiHjki7Qavr1aXbBgvU66rudUEDqDm080aSyYE+m+wVZSGW3ip
         UtMmRj3t9upmxG82R6V1DxRCwSH1xe2vj3dG2DheWlTyOxjY8KPEJ+ipzHNgPlsun3
         kl3R6Ru9uJj1XSb7F7ftk6P5GtX7pTvLuugDpyLr5bDtmL/UC77GX87+Zb97lYG/vv
         zXG7c69iIYJHQ==
Subject: [PATCH 6/8] xfs: fix confusing variable names in xfs_rmap_item.c
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:10:57 -0800
Message-ID: <167243825748.683219.9933818207405590606.stgit@magnolia>
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

Variable names in this code module are inconsistent and confusing.
xfs_map_extent describe file mappings, so rename them "map".
xfs_rmap_intents describe block mapping intents, so rename them "ri".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rmap_item.c |   79 ++++++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 39 deletions(-)


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index e46d040a9fc5..a1619d67015f 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -244,40 +244,40 @@ xfs_trans_get_rud(
 /* Set the map extent flags for this reverse mapping. */
 static void
 xfs_trans_set_rmap_flags(
-	struct xfs_map_extent		*rmap,
+	struct xfs_map_extent		*map,
 	enum xfs_rmap_intent_type	type,
 	int				whichfork,
 	xfs_exntst_t			state)
 {
-	rmap->me_flags = 0;
+	map->me_flags = 0;
 	if (state == XFS_EXT_UNWRITTEN)
-		rmap->me_flags |= XFS_RMAP_EXTENT_UNWRITTEN;
+		map->me_flags |= XFS_RMAP_EXTENT_UNWRITTEN;
 	if (whichfork == XFS_ATTR_FORK)
-		rmap->me_flags |= XFS_RMAP_EXTENT_ATTR_FORK;
+		map->me_flags |= XFS_RMAP_EXTENT_ATTR_FORK;
 	switch (type) {
 	case XFS_RMAP_MAP:
-		rmap->me_flags |= XFS_RMAP_EXTENT_MAP;
+		map->me_flags |= XFS_RMAP_EXTENT_MAP;
 		break;
 	case XFS_RMAP_MAP_SHARED:
-		rmap->me_flags |= XFS_RMAP_EXTENT_MAP_SHARED;
+		map->me_flags |= XFS_RMAP_EXTENT_MAP_SHARED;
 		break;
 	case XFS_RMAP_UNMAP:
-		rmap->me_flags |= XFS_RMAP_EXTENT_UNMAP;
+		map->me_flags |= XFS_RMAP_EXTENT_UNMAP;
 		break;
 	case XFS_RMAP_UNMAP_SHARED:
-		rmap->me_flags |= XFS_RMAP_EXTENT_UNMAP_SHARED;
+		map->me_flags |= XFS_RMAP_EXTENT_UNMAP_SHARED;
 		break;
 	case XFS_RMAP_CONVERT:
-		rmap->me_flags |= XFS_RMAP_EXTENT_CONVERT;
+		map->me_flags |= XFS_RMAP_EXTENT_CONVERT;
 		break;
 	case XFS_RMAP_CONVERT_SHARED:
-		rmap->me_flags |= XFS_RMAP_EXTENT_CONVERT_SHARED;
+		map->me_flags |= XFS_RMAP_EXTENT_CONVERT_SHARED;
 		break;
 	case XFS_RMAP_ALLOC:
-		rmap->me_flags |= XFS_RMAP_EXTENT_ALLOC;
+		map->me_flags |= XFS_RMAP_EXTENT_ALLOC;
 		break;
 	case XFS_RMAP_FREE:
-		rmap->me_flags |= XFS_RMAP_EXTENT_FREE;
+		map->me_flags |= XFS_RMAP_EXTENT_FREE;
 		break;
 	default:
 		ASSERT(0);
@@ -335,7 +335,7 @@ STATIC void
 xfs_rmap_update_log_item(
 	struct xfs_trans		*tp,
 	struct xfs_rui_log_item		*ruip,
-	struct xfs_rmap_intent		*rmap)
+	struct xfs_rmap_intent		*ri)
 {
 	uint				next_extent;
 	struct xfs_map_extent		*map;
@@ -351,12 +351,12 @@ xfs_rmap_update_log_item(
 	next_extent = atomic_inc_return(&ruip->rui_next_extent) - 1;
 	ASSERT(next_extent < ruip->rui_format.rui_nextents);
 	map = &ruip->rui_format.rui_extents[next_extent];
-	map->me_owner = rmap->ri_owner;
-	map->me_startblock = rmap->ri_bmap.br_startblock;
-	map->me_startoff = rmap->ri_bmap.br_startoff;
-	map->me_len = rmap->ri_bmap.br_blockcount;
-	xfs_trans_set_rmap_flags(map, rmap->ri_type, rmap->ri_whichfork,
-			rmap->ri_bmap.br_state);
+	map->me_owner = ri->ri_owner;
+	map->me_startblock = ri->ri_bmap.br_startblock;
+	map->me_startoff = ri->ri_bmap.br_startoff;
+	map->me_len = ri->ri_bmap.br_blockcount;
+	xfs_trans_set_rmap_flags(map, ri->ri_type, ri->ri_whichfork,
+			ri->ri_bmap.br_state);
 }
 
 static struct xfs_log_item *
@@ -368,15 +368,15 @@ xfs_rmap_update_create_intent(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_rui_log_item		*ruip = xfs_rui_init(mp, count);
-	struct xfs_rmap_intent		*rmap;
+	struct xfs_rmap_intent		*ri;
 
 	ASSERT(count > 0);
 
 	xfs_trans_add_item(tp, &ruip->rui_item);
 	if (sort)
 		list_sort(mp, items, xfs_rmap_update_diff_items);
-	list_for_each_entry(rmap, items, ri_list)
-		xfs_rmap_update_log_item(tp, ruip, rmap);
+	list_for_each_entry(ri, items, ri_list)
+		xfs_rmap_update_log_item(tp, ruip, ri);
 	return &ruip->rui_item;
 }
 
@@ -398,13 +398,14 @@ xfs_rmap_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_rmap_intent		*rmap;
+	struct xfs_rmap_intent		*ri;
 	int				error;
 
-	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
-	error = xfs_trans_log_finish_rmap_update(tp, RUD_ITEM(done), rmap,
+	ri = container_of(item, struct xfs_rmap_intent, ri_list);
+
+	error = xfs_trans_log_finish_rmap_update(tp, RUD_ITEM(done), ri,
 			state);
-	kmem_cache_free(xfs_rmap_intent_cache, rmap);
+	kmem_cache_free(xfs_rmap_intent_cache, ri);
 	return error;
 }
 
@@ -421,10 +422,10 @@ STATIC void
 xfs_rmap_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_rmap_intent		*rmap;
+	struct xfs_rmap_intent		*ri;
 
-	rmap = container_of(item, struct xfs_rmap_intent, ri_list);
-	kmem_cache_free(xfs_rmap_intent_cache, rmap);
+	ri = container_of(item, struct xfs_rmap_intent, ri_list);
+	kmem_cache_free(xfs_rmap_intent_cache, ri);
 }
 
 const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
@@ -441,15 +442,15 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 static inline bool
 xfs_rui_validate_map(
 	struct xfs_mount		*mp,
-	struct xfs_map_extent		*rmap)
+	struct xfs_map_extent		*map)
 {
 	if (!xfs_has_rmapbt(mp))
 		return false;
 
-	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
+	if (map->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
 		return false;
 
-	switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
+	switch (map->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
 	case XFS_RMAP_EXTENT_MAP:
 	case XFS_RMAP_EXTENT_MAP_SHARED:
 	case XFS_RMAP_EXTENT_UNMAP:
@@ -463,14 +464,14 @@ xfs_rui_validate_map(
 		return false;
 	}
 
-	if (!XFS_RMAP_NON_INODE_OWNER(rmap->me_owner) &&
-	    !xfs_verify_ino(mp, rmap->me_owner))
+	if (!XFS_RMAP_NON_INODE_OWNER(map->me_owner) &&
+	    !xfs_verify_ino(mp, map->me_owner))
 		return false;
 
-	if (!xfs_verify_fileext(mp, rmap->me_startoff, rmap->me_len))
+	if (!xfs_verify_fileext(mp, map->me_startoff, map->me_len))
 		return false;
 
-	return xfs_verify_fsbext(mp, rmap->me_startblock, rmap->me_len);
+	return xfs_verify_fsbext(mp, map->me_startblock, map->me_len);
 }
 
 /*
@@ -593,18 +594,18 @@ xfs_rui_item_relog(
 {
 	struct xfs_rud_log_item		*rudp;
 	struct xfs_rui_log_item		*ruip;
-	struct xfs_map_extent		*extp;
+	struct xfs_map_extent		*map;
 	unsigned int			count;
 
 	count = RUI_ITEM(intent)->rui_format.rui_nextents;
-	extp = RUI_ITEM(intent)->rui_format.rui_extents;
+	map = RUI_ITEM(intent)->rui_format.rui_extents;
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	rudp = xfs_trans_get_rud(tp, RUI_ITEM(intent));
 	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
 
 	ruip = xfs_rui_init(tp->t_mountp, count);
-	memcpy(ruip->rui_format.rui_extents, extp, count * sizeof(*extp));
+	memcpy(ruip->rui_format.rui_extents, map, count * sizeof(*map));
 	atomic_set(&ruip->rui_next_extent, count);
 	xfs_trans_add_item(tp, &ruip->rui_item);
 	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);

