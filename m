Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303BB659CF2
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbiL3Wey (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235634AbiL3Wet (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:34:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A008C1C935
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:34:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33080B81B91
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED32CC433EF;
        Fri, 30 Dec 2022 22:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439685;
        bh=7v8oq2bgVuoWLcSnB+fCYryEd5E3FA7Qhfyg5ZCMFVs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gYHmcxNCD7UGRT2jOL8rzsCqcfG/WbyFPesXnMc84O/80gfbe1RrYnVoW5uPzcyqd
         iqwg2d9qrxMEKeZL6YXtPHgilKZl+eo6g0NVFkD95ASkSALXH/OcEoXG4Viu1dgo9L
         pdFRbxY2//yuVryPLTBBlcJHm/5HLRARAYWKWa6g62xw+Rw68/SqmHUqI7PGZIxcsr
         /GzC274Rw2ME3lGaPUfpAY9M1v8xkdQpMKOvMNfvbssy3M52RmUtCS0PWB+IpkHjur
         RQQwBU4aJvPqEYrVw0VZH+51pn90qiNn8RNGlhw0gMihKRGj4SbtgPmZ+Qez9XyzmK
         wR2To4Bovg7jA==
Subject: [PATCH 7/8] xfs: pass refcount intent directly through the log intent
 code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:10:57 -0800
Message-ID: <167243825762.683219.12428848527612325437.stgit@magnolia>
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

Pass the incore refcount intent through the CUI logging code instead of
repeatedly boxing and unboxing parameters.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   96 +++++++++++++++++++-----------------------
 fs/xfs/libxfs/xfs_refcount.h |    4 --
 fs/xfs/xfs_refcount_item.c   |   62 +++++++++++----------------
 fs/xfs/xfs_trace.h           |   15 ++-----
 4 files changed, 74 insertions(+), 103 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 6f7ed9288fe4..bcf46aa0d08b 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1213,37 +1213,33 @@ xfs_refcount_adjust_extents(
 STATIC int
 xfs_refcount_adjust(
 	struct xfs_btree_cur	*cur,
-	xfs_agblock_t		agbno,
-	xfs_extlen_t		aglen,
-	xfs_agblock_t		*new_agbno,
-	xfs_extlen_t		*new_aglen,
+	xfs_agblock_t		*agbno,
+	xfs_extlen_t		*aglen,
 	enum xfs_refc_adjust_op	adj)
 {
 	bool			shape_changed;
 	int			shape_changes = 0;
 	int			error;
 
-	*new_agbno = agbno;
-	*new_aglen = aglen;
 	if (adj == XFS_REFCOUNT_ADJUST_INCREASE)
-		trace_xfs_refcount_increase(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-				agbno, aglen);
+		trace_xfs_refcount_increase(cur->bc_mp,
+				cur->bc_ag.pag->pag_agno, *agbno, *aglen);
 	else
-		trace_xfs_refcount_decrease(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-				agbno, aglen);
+		trace_xfs_refcount_decrease(cur->bc_mp,
+				cur->bc_ag.pag->pag_agno, *agbno, *aglen);
 
 	/*
 	 * Ensure that no rcextents cross the boundary of the adjustment range.
 	 */
 	error = xfs_refcount_split_extent(cur, XFS_REFC_DOMAIN_SHARED,
-			agbno, &shape_changed);
+			*agbno, &shape_changed);
 	if (error)
 		goto out_error;
 	if (shape_changed)
 		shape_changes++;
 
 	error = xfs_refcount_split_extent(cur, XFS_REFC_DOMAIN_SHARED,
-			agbno + aglen, &shape_changed);
+			*agbno + *aglen, &shape_changed);
 	if (error)
 		goto out_error;
 	if (shape_changed)
@@ -1253,7 +1249,7 @@ xfs_refcount_adjust(
 	 * Try to merge with the left or right extents of the range.
 	 */
 	error = xfs_refcount_merge_extents(cur, XFS_REFC_DOMAIN_SHARED,
-			new_agbno, new_aglen, adj, &shape_changed);
+			agbno, aglen, adj, &shape_changed);
 	if (error)
 		goto out_error;
 	if (shape_changed)
@@ -1262,7 +1258,7 @@ xfs_refcount_adjust(
 		cur->bc_ag.refc.shape_changes++;
 
 	/* Now that we've taken care of the ends, adjust the middle extents */
-	error = xfs_refcount_adjust_extents(cur, new_agbno, new_aglen, adj);
+	error = xfs_refcount_adjust_extents(cur, agbno, aglen, adj);
 	if (error)
 		goto out_error;
 
@@ -1298,21 +1294,20 @@ xfs_refcount_finish_one_cleanup(
 static inline int
 xfs_refcount_continue_op(
 	struct xfs_btree_cur		*cur,
-	xfs_fsblock_t			startblock,
-	xfs_agblock_t			new_agbno,
-	xfs_extlen_t			new_len,
-	xfs_fsblock_t			*new_fsbno)
+	struct xfs_refcount_intent	*ri,
+	xfs_agblock_t			new_agbno)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
 	struct xfs_perag		*pag = cur->bc_ag.pag;
 
-	if (XFS_IS_CORRUPT(mp, !xfs_verify_agbext(pag, new_agbno, new_len)))
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_agbext(pag, new_agbno,
+					ri->ri_blockcount)))
 		return -EFSCORRUPTED;
 
-	*new_fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+	ri->ri_startblock = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
 
-	ASSERT(xfs_verify_fsbext(mp, *new_fsbno, new_len));
-	ASSERT(pag->pag_agno == XFS_FSB_TO_AGNO(mp, *new_fsbno));
+	ASSERT(xfs_verify_fsbext(mp, ri->ri_startblock, ri->ri_blockcount));
+	ASSERT(pag->pag_agno == XFS_FSB_TO_AGNO(mp, ri->ri_startblock));
 
 	return 0;
 }
@@ -1327,11 +1322,7 @@ xfs_refcount_continue_op(
 int
 xfs_refcount_finish_one(
 	struct xfs_trans		*tp,
-	enum xfs_refcount_intent_type	type,
-	xfs_fsblock_t			startblock,
-	xfs_extlen_t			blockcount,
-	xfs_fsblock_t			*new_fsb,
-	xfs_extlen_t			*new_len,
+	struct xfs_refcount_intent	*ri,
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
@@ -1339,17 +1330,16 @@ xfs_refcount_finish_one(
 	struct xfs_buf			*agbp = NULL;
 	int				error = 0;
 	xfs_agblock_t			bno;
-	xfs_agblock_t			new_agbno;
 	unsigned long			nr_ops = 0;
 	int				shape_changes = 0;
 	struct xfs_perag		*pag;
 
-	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, startblock));
-	bno = XFS_FSB_TO_AGBNO(mp, startblock);
+	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ri->ri_startblock));
+	bno = XFS_FSB_TO_AGBNO(mp, ri->ri_startblock);
 
-	trace_xfs_refcount_deferred(mp, XFS_FSB_TO_AGNO(mp, startblock),
-			type, XFS_FSB_TO_AGBNO(mp, startblock),
-			blockcount);
+	trace_xfs_refcount_deferred(mp, XFS_FSB_TO_AGNO(mp, ri->ri_startblock),
+			ri->ri_type, XFS_FSB_TO_AGBNO(mp, ri->ri_startblock),
+			ri->ri_blockcount);
 
 	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE)) {
 		error = -EIO;
@@ -1380,42 +1370,42 @@ xfs_refcount_finish_one(
 	}
 	*pcur = rcur;
 
-	switch (type) {
+	switch (ri->ri_type) {
 	case XFS_REFCOUNT_INCREASE:
-		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
-				new_len, XFS_REFCOUNT_ADJUST_INCREASE);
+		error = xfs_refcount_adjust(rcur, &bno, &ri->ri_blockcount,
+				XFS_REFCOUNT_ADJUST_INCREASE);
 		if (error)
 			goto out_drop;
-		if (*new_len > 0)
-			error = xfs_refcount_continue_op(rcur, startblock,
-					new_agbno, *new_len, new_fsb);
+		if (ri->ri_blockcount > 0)
+			error = xfs_refcount_continue_op(rcur, ri, bno);
 		break;
 	case XFS_REFCOUNT_DECREASE:
-		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
-				new_len, XFS_REFCOUNT_ADJUST_DECREASE);
+		error = xfs_refcount_adjust(rcur, &bno, &ri->ri_blockcount,
+				XFS_REFCOUNT_ADJUST_DECREASE);
 		if (error)
 			goto out_drop;
-		if (*new_len > 0)
-			error = xfs_refcount_continue_op(rcur, startblock,
-					new_agbno, *new_len, new_fsb);
+		if (ri->ri_blockcount > 0)
+			error = xfs_refcount_continue_op(rcur, ri, bno);
 		break;
 	case XFS_REFCOUNT_ALLOC_COW:
-		*new_fsb = startblock + blockcount;
-		*new_len = 0;
-		error = __xfs_refcount_cow_alloc(rcur, bno, blockcount);
+		error = __xfs_refcount_cow_alloc(rcur, bno, ri->ri_blockcount);
+		if (error)
+			goto out_drop;
+		ri->ri_blockcount = 0;
 		break;
 	case XFS_REFCOUNT_FREE_COW:
-		*new_fsb = startblock + blockcount;
-		*new_len = 0;
-		error = __xfs_refcount_cow_free(rcur, bno, blockcount);
+		error = __xfs_refcount_cow_free(rcur, bno, ri->ri_blockcount);
+		if (error)
+			goto out_drop;
+		ri->ri_blockcount = 0;
 		break;
 	default:
 		ASSERT(0);
 		error = -EFSCORRUPTED;
 	}
-	if (!error && *new_len > 0)
-		trace_xfs_refcount_finish_one_leftover(mp, pag->pag_agno, type,
-				bno, blockcount, new_agbno, *new_len);
+	if (!error && ri->ri_blockcount > 0)
+		trace_xfs_refcount_finish_one_leftover(mp, pag->pag_agno,
+				ri->ri_type, bno, ri->ri_blockcount);
 out_drop:
 	xfs_perag_put(pag);
 	return error;
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 452f30556f5a..c633477ce3ce 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -75,9 +75,7 @@ void xfs_refcount_decrease_extent(struct xfs_trans *tp,
 extern void xfs_refcount_finish_one_cleanup(struct xfs_trans *tp,
 		struct xfs_btree_cur *rcur, int error);
 extern int xfs_refcount_finish_one(struct xfs_trans *tp,
-		enum xfs_refcount_intent_type type, xfs_fsblock_t startblock,
-		xfs_extlen_t blockcount, xfs_fsblock_t *new_fsb,
-		xfs_extlen_t *new_len, struct xfs_btree_cur **pcur);
+		struct xfs_refcount_intent *ri, struct xfs_btree_cur **pcur);
 
 extern int xfs_refcount_find_shared(struct xfs_btree_cur *cur,
 		xfs_agblock_t agbno, xfs_extlen_t aglen, xfs_agblock_t *fbno,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 858e3e9eb4a8..ff4d5087ba00 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -252,17 +252,12 @@ static int
 xfs_trans_log_finish_refcount_update(
 	struct xfs_trans		*tp,
 	struct xfs_cud_log_item		*cudp,
-	enum xfs_refcount_intent_type	type,
-	xfs_fsblock_t			startblock,
-	xfs_extlen_t			blockcount,
-	xfs_fsblock_t			*new_fsb,
-	xfs_extlen_t			*new_len,
+	struct xfs_refcount_intent	*ri,
 	struct xfs_btree_cur		**pcur)
 {
 	int				error;
 
-	error = xfs_refcount_finish_one(tp, type, startblock,
-			blockcount, new_fsb, new_len, pcur);
+	error = xfs_refcount_finish_one(tp, ri, pcur);
 
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
@@ -378,25 +373,20 @@ xfs_refcount_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_refcount_intent	*refc;
-	xfs_fsblock_t			new_fsb;
-	xfs_extlen_t			new_aglen;
+	struct xfs_refcount_intent	*ri;
 	int				error;
 
-	refc = container_of(item, struct xfs_refcount_intent, ri_list);
-	error = xfs_trans_log_finish_refcount_update(tp, CUD_ITEM(done),
-			refc->ri_type, refc->ri_startblock, refc->ri_blockcount,
-			&new_fsb, &new_aglen, state);
+	ri = container_of(item, struct xfs_refcount_intent, ri_list);
+	error = xfs_trans_log_finish_refcount_update(tp, CUD_ITEM(done), ri,
+			state);
 
 	/* Did we run out of reservation?  Requeue what we didn't finish. */
-	if (!error && new_aglen > 0) {
-		ASSERT(refc->ri_type == XFS_REFCOUNT_INCREASE ||
-		       refc->ri_type == XFS_REFCOUNT_DECREASE);
-		refc->ri_startblock = new_fsb;
-		refc->ri_blockcount = new_aglen;
+	if (!error && ri->ri_blockcount > 0) {
+		ASSERT(ri->ri_type == XFS_REFCOUNT_INCREASE ||
+		       ri->ri_type == XFS_REFCOUNT_DECREASE);
 		return -EAGAIN;
 	}
-	kmem_cache_free(xfs_refcount_intent_cache, refc);
+	kmem_cache_free(xfs_refcount_intent_cache, ri);
 	return error;
 }
 
@@ -463,18 +453,13 @@ xfs_cui_item_recover(
 	struct xfs_log_item		*lip,
 	struct list_head		*capture_list)
 {
-	struct xfs_bmbt_irec		irec;
 	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
-	struct xfs_phys_extent		*refc;
 	struct xfs_cud_log_item		*cudp;
 	struct xfs_trans		*tp;
 	struct xfs_btree_cur		*rcur = NULL;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
-	xfs_fsblock_t			new_fsb;
-	xfs_extlen_t			new_len;
 	unsigned int			refc_type;
 	bool				requeue_only = false;
-	enum xfs_refcount_intent_type	type;
 	int				i;
 	int				error = 0;
 
@@ -513,6 +498,9 @@ xfs_cui_item_recover(
 	cudp = xfs_trans_get_cud(tp, cuip);
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
+		struct xfs_refcount_intent	fake = { };
+		struct xfs_phys_extent		*refc;
+
 		refc = &cuip->cui_format.cui_extents[i];
 		refc_type = refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK;
 		switch (refc_type) {
@@ -520,7 +508,7 @@ xfs_cui_item_recover(
 		case XFS_REFCOUNT_DECREASE:
 		case XFS_REFCOUNT_ALLOC_COW:
 		case XFS_REFCOUNT_FREE_COW:
-			type = refc_type;
+			fake.ri_type = refc_type;
 			break;
 		default:
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
@@ -529,13 +517,12 @@ xfs_cui_item_recover(
 			error = -EFSCORRUPTED;
 			goto abort_error;
 		}
-		if (requeue_only) {
-			new_fsb = refc->pe_startblock;
-			new_len = refc->pe_len;
-		} else
+
+		fake.ri_startblock = refc->pe_startblock;
+		fake.ri_blockcount = refc->pe_len;
+		if (!requeue_only)
 			error = xfs_trans_log_finish_refcount_update(tp, cudp,
-				type, refc->pe_startblock, refc->pe_len,
-				&new_fsb, &new_len, &rcur);
+					&fake, &rcur);
 		if (error == -EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					&cuip->cui_format,
@@ -544,10 +531,13 @@ xfs_cui_item_recover(
 			goto abort_error;
 
 		/* Requeue what we didn't finish. */
-		if (new_len > 0) {
-			irec.br_startblock = new_fsb;
-			irec.br_blockcount = new_len;
-			switch (type) {
+		if (fake.ri_blockcount > 0) {
+			struct xfs_bmbt_irec	irec = {
+				.br_startblock	= fake.ri_startblock,
+				.br_blockcount	= fake.ri_blockcount,
+			};
+
+			switch (fake.ri_type) {
 			case XFS_REFCOUNT_INCREASE:
 				xfs_refcount_increase_extent(tp, &irec);
 				break;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 421d1e504ac4..6b0e9ae7c513 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3207,17 +3207,14 @@ DEFINE_REFCOUNT_DEFERRED_EVENT(xfs_refcount_deferred);
 
 TRACE_EVENT(xfs_refcount_finish_one_leftover,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 int type, xfs_agblock_t agbno, xfs_extlen_t len,
-		 xfs_agblock_t new_agbno, xfs_extlen_t new_len),
-	TP_ARGS(mp, agno, type, agbno, len, new_agbno, new_len),
+		 int type, xfs_agblock_t agbno, xfs_extlen_t len),
+	TP_ARGS(mp, agno, type, agbno, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 		__field(int, type)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
-		__field(xfs_agblock_t, new_agbno)
-		__field(xfs_extlen_t, new_len)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
@@ -3225,17 +3222,13 @@ TRACE_EVENT(xfs_refcount_finish_one_leftover,
 		__entry->type = type;
 		__entry->agbno = agbno;
 		__entry->len = len;
-		__entry->new_agbno = new_agbno;
-		__entry->new_len = new_len;
 	),
-	TP_printk("dev %d:%d type %d agno 0x%x agbno 0x%x fsbcount 0x%x new_agbno 0x%x new_fsbcount 0x%x",
+	TP_printk("dev %d:%d type %d agno 0x%x agbno 0x%x fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->type,
 		  __entry->agno,
 		  __entry->agbno,
-		  __entry->len,
-		  __entry->new_agbno,
-		  __entry->new_len)
+		  __entry->len)
 );
 
 /* simple inode-based error/%ip tracepoint class */

