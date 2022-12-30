Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01D2659CEA
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiL3WdP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbiL3WdN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:33:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879971900C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:33:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2456D61C2A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D14C433EF;
        Fri, 30 Dec 2022 22:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439591;
        bh=AdSiDci7Gleh0zXb+kFMwMuwhb5yqO6IFbOVq9MKqUo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a63oO6QzZ0CPz9sdIhTTTtQvoJ0E0Weo8/Fv+Y3edcSRu4oim3KWq2bflB4Gw7QDg
         JbVJR7zImd3tcNd4AH7QVm8LEzndPsnA/J15CUWsYN3AAhvyBJ2w8yJ/F6gPwjT37z
         m7B+FzTSBw7LrOfD5+Ml31BVbfiYIEf35Qk9kx5WZXflYpQ0dqgDa7lJah3lG/gLD6
         +XQtLUN9LaF8D5+3RCOU/L+e3NyHvGgnE1NsqhWagg9GRHlkROdPLo0wFVWZxA76BH
         TGD1lheo8jeM+a/EKieM+f2nGSH+17ZiJ+0/xdgNo1sN4NPypOPiSzr1/EDOn7pTQS
         IMNUR1DQWyc/Q==
Subject: [PATCH 1/8] xfs: pass the xfs_bmbt_irec directly through the log
 intent code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:10:56 -0800
Message-ID: <167243825676.683219.17984653726497120319.stgit@magnolia>
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

Instead of repeatedly boxing and unboxing the incore extent mapping
structure as it passes through the BUI code, pass the pointer directly
through.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   32 +++++++++---------
 fs/xfs/libxfs/xfs_bmap.h |    5 +--
 fs/xfs/xfs_bmap_item.c   |   81 +++++++++++++++++-----------------------------
 3 files changed, 46 insertions(+), 72 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0d56a8d862e8..c8c65387136c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6146,39 +6146,37 @@ xfs_bmap_unmap_extent(
 int
 xfs_bmap_finish_one(
 	struct xfs_trans		*tp,
-	struct xfs_inode		*ip,
-	enum xfs_bmap_intent_type	type,
-	int				whichfork,
-	xfs_fileoff_t			startoff,
-	xfs_fsblock_t			startblock,
-	xfs_filblks_t			*blockcount,
-	xfs_exntst_t			state)
+	struct xfs_bmap_intent		*bi)
 {
+	struct xfs_bmbt_irec		*bmap = &bi->bi_bmap;
 	int				error = 0;
 
 	ASSERT(tp->t_firstblock == NULLFSBLOCK);
 
 	trace_xfs_bmap_deferred(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, startblock), type,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
-			ip->i_ino, whichfork, startoff, *blockcount, state);
+			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
+			bi->bi_type,
+			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
+			bi->bi_owner->i_ino, bi->bi_whichfork,
+			bmap->br_startoff, bmap->br_blockcount,
+			bmap->br_state);
 
-	if (WARN_ON_ONCE(whichfork != XFS_DATA_FORK))
+	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK))
 		return -EFSCORRUPTED;
 
 	if (XFS_TEST_ERROR(false, tp->t_mountp,
 			XFS_ERRTAG_BMAP_FINISH_ONE))
 		return -EIO;
 
-	switch (type) {
+	switch (bi->bi_type) {
 	case XFS_BMAP_MAP:
-		error = xfs_bmapi_remap(tp, ip, startoff, *blockcount,
-				startblock, 0);
-		*blockcount = 0;
+		error = xfs_bmapi_remap(tp, bi->bi_owner, bmap->br_startoff,
+				bmap->br_blockcount, bmap->br_startblock, 0);
+		bmap->br_blockcount = 0;
 		break;
 	case XFS_BMAP_UNMAP:
-		error = __xfs_bunmapi(tp, ip, startoff, blockcount,
-				XFS_BMAPI_REMAP, 1);
+		error = __xfs_bunmapi(tp, bi->bi_owner, bmap->br_startoff,
+				&bmap->br_blockcount, XFS_BMAPI_REMAP, 1);
 		break;
 	default:
 		ASSERT(0);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 16db95b11589..01c2df35c3e3 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -234,10 +234,7 @@ struct xfs_bmap_intent {
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
-int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_inode *ip,
-		enum xfs_bmap_intent_type type, int whichfork,
-		xfs_fileoff_t startoff, xfs_fsblock_t startblock,
-		xfs_filblks_t *blockcount, xfs_exntst_t state);
+int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
 void	xfs_bmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_bmbt_irec *imap);
 void	xfs_bmap_unmap_extent(struct xfs_trans *tp, struct xfs_inode *ip,
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 41323da523d1..13aa5359c02f 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -246,18 +246,11 @@ static int
 xfs_trans_log_finish_bmap_update(
 	struct xfs_trans		*tp,
 	struct xfs_bud_log_item		*budp,
-	enum xfs_bmap_intent_type	type,
-	struct xfs_inode		*ip,
-	int				whichfork,
-	xfs_fileoff_t			startoff,
-	xfs_fsblock_t			startblock,
-	xfs_filblks_t			*blockcount,
-	xfs_exntst_t			state)
+	struct xfs_bmap_intent		*bi)
 {
 	int				error;
 
-	error = xfs_bmap_finish_one(tp, ip, type, whichfork, startoff,
-			startblock, blockcount, state);
+	error = xfs_bmap_finish_one(tp, bi);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
@@ -378,25 +371,17 @@ xfs_bmap_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_bmap_intent		*bmap;
-	xfs_filblks_t			count;
+	struct xfs_bmap_intent		*bi;
 	int				error;
 
-	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
-	count = bmap->bi_bmap.br_blockcount;
-	error = xfs_trans_log_finish_bmap_update(tp, BUD_ITEM(done),
-			bmap->bi_type,
-			bmap->bi_owner, bmap->bi_whichfork,
-			bmap->bi_bmap.br_startoff,
-			bmap->bi_bmap.br_startblock,
-			&count,
-			bmap->bi_bmap.br_state);
-	if (!error && count > 0) {
-		ASSERT(bmap->bi_type == XFS_BMAP_UNMAP);
-		bmap->bi_bmap.br_blockcount = count;
+	bi = container_of(item, struct xfs_bmap_intent, bi_list);
+
+	error = xfs_trans_log_finish_bmap_update(tp, BUD_ITEM(done), bi);
+	if (!error && bi->bi_bmap.br_blockcount > 0) {
+		ASSERT(bi->bi_type == XFS_BMAP_UNMAP);
 		return -EAGAIN;
 	}
-	kmem_cache_free(xfs_bmap_intent_cache, bmap);
+	kmem_cache_free(xfs_bmap_intent_cache, bi);
 	return error;
 }
 
@@ -471,17 +456,13 @@ xfs_bui_item_recover(
 	struct xfs_log_item		*lip,
 	struct list_head		*capture_list)
 {
-	struct xfs_bmbt_irec		irec;
+	struct xfs_bmap_intent		fake = { };
 	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
-	struct xfs_map_extent		*bmap;
+	struct xfs_map_extent		*map;
 	struct xfs_bud_log_item		*budp;
-	xfs_filblks_t			count;
-	xfs_exntst_t			state;
-	unsigned int			bui_type;
-	int				whichfork;
 	int				iext_delta;
 	int				error = 0;
 
@@ -491,14 +472,12 @@ xfs_bui_item_recover(
 		return -EFSCORRUPTED;
 	}
 
-	bmap = &buip->bui_format.bui_extents[0];
-	state = (bmap->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
-			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
-	whichfork = (bmap->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
+	map = &buip->bui_format.bui_extents[0];
+	fake.bi_whichfork = (map->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
 			XFS_ATTR_FORK : XFS_DATA_FORK;
-	bui_type = bmap->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
+	fake.bi_type = map->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
 
-	error = xlog_recover_iget(mp, bmap->me_owner, &ip);
+	error = xlog_recover_iget(mp, map->me_owner, &ip);
 	if (error)
 		return error;
 
@@ -512,34 +491,34 @@ xfs_bui_item_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	if (bui_type == XFS_BMAP_MAP)
+	if (fake.bi_type == XFS_BMAP_MAP)
 		iext_delta = XFS_IEXT_ADD_NOSPLIT_CNT;
 	else
 		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
 
-	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
+	error = xfs_iext_count_may_overflow(ip, fake.bi_whichfork, iext_delta);
 	if (error == -EFBIG)
 		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
 	if (error)
 		goto err_cancel;
 
-	count = bmap->me_len;
-	error = xfs_trans_log_finish_bmap_update(tp, budp, bui_type, ip,
-			whichfork, bmap->me_startoff, bmap->me_startblock,
-			&count, state);
+	fake.bi_owner = ip;
+	fake.bi_bmap.br_startblock = map->me_startblock;
+	fake.bi_bmap.br_startoff = map->me_startoff;
+	fake.bi_bmap.br_blockcount = map->me_len;
+	fake.bi_bmap.br_state = (map->me_flags & XFS_BMAP_EXTENT_UNWRITTEN) ?
+			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
+
+	error = xfs_trans_log_finish_bmap_update(tp, budp, &fake);
 	if (error == -EFSCORRUPTED)
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bmap,
-				sizeof(*bmap));
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, map,
+				sizeof(*map));
 	if (error)
 		goto err_cancel;
 
-	if (count > 0) {
-		ASSERT(bui_type == XFS_BMAP_UNMAP);
-		irec.br_startblock = bmap->me_startblock;
-		irec.br_blockcount = count;
-		irec.br_startoff = bmap->me_startoff;
-		irec.br_state = state;
-		xfs_bmap_unmap_extent(tp, ip, &irec);
+	if (fake.bi_bmap.br_blockcount > 0) {
+		ASSERT(fake.bi_type == XFS_BMAP_UNMAP);
+		xfs_bmap_unmap_extent(tp, ip, &fake.bi_bmap);
 	}
 
 	/*

