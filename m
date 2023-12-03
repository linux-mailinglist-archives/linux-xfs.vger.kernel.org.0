Return-Path: <linux-xfs+bounces-331-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9691880266E
	for <lists+linux-xfs@lfdr.de>; Sun,  3 Dec 2023 20:01:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B69141C208F7
	for <lists+linux-xfs@lfdr.de>; Sun,  3 Dec 2023 19:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C57EA17993;
	Sun,  3 Dec 2023 19:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s7Zey8/W"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8606917735
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501F7C433C8;
	Sun,  3 Dec 2023 19:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630068;
	bh=cONwaNZ3jhs7TiU5NF/rCNICHmERoIFa0QKV41EcKzw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s7Zey8/WQMqAuflZuQL38tV3tNdn/vExOLssKd0jVYBZyyfcYxG0AieyMzH3gd7xk
	 hfEFnWs4igzjPEK66MD1WZi4IDkBAGpi+glEUmQEkX2j6bYUiMheo2pb+5tsblAK0V
	 pjpSb3dcYlY5b1lEN05U1sXNBVOZipP6UQNhkg7NgmLJ13vC1DpI/9tPZHZkSmH7ym
	 4GQSbifOOCxBJQI40pDCfYKcDrIjZKJ01/qvXcSZ1CSHT/VmoowlDP0yfDcFPG0h4O
	 8IATvR2DNhrhlKGodJfPlB5huj1QtNoxYubcZT8kZQzlpTlN5RDhqS4dmTsn3A5puH
	 SrWFUXvLPp2Rw==
Date: Sun, 03 Dec 2023 11:01:07 -0800
Subject: [PATCH 2/8] xfs: use xfs_defer_pending objects to recover intent
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, hch@lst.de,
 leo.lilong@huawei.com
Cc: linux-xfs@vger.kernel.org
Message-ID: <170162989737.3037528.16334530137884310180.stgit@frogsfrogsfrogs>
In-Reply-To: <170162989691.3037528.5056861908451814336.stgit@frogsfrogsfrogs>
References: <170162989691.3037528.5056861908451814336.stgit@frogsfrogsfrogs>
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

One thing I never quite got around to doing is porting the log intent
item recovery code to reconstruct the deferred pending work state.  As a
result, each intent item open codes xfs_defer_finish_one in its recovery
method, because that's what the EFI code did before xfs_defer.c even
existed.

This is a gross thing to have left unfixed -- if an EFI cannot proceed
due to busy extents, we end up creating separate new EFIs for each
unfinished work item, which is a change in behavior from what runtime
would have done.

Worse yet, Long Li pointed out that there's a UAF in the recovery code.
The ->commit_pass2 function adds the intent item to the AIL and drops
the refcount.  The one remaining refcount is now owned by the recovery
mechanism (aka the log intent items in the AIL) with the intent of
giving the refcount to the intent done item in the ->iop_recover
function.

However, if something fails later in recovery, xlog_recover_finish will
walk the recovered intent items in the AIL and release them.  If the CIL
hasn't been pushed before that point (which is possible since we don't
force the log until later) then the intent done release will try to free
its associated intent, which has already been freed.

This patch starts to address this mess by having the ->commit_pass2
functions recreate the xfs_defer_pending state.  The next few patches
will fix the recovery functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c       |  105 +++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_defer.h       |    5 ++
 fs/xfs/libxfs/xfs_log_recover.h |    3 +
 fs/xfs/xfs_attr_item.c          |   10 +---
 fs/xfs/xfs_bmap_item.c          |    9 +--
 fs/xfs/xfs_extfree_item.c       |    9 +--
 fs/xfs/xfs_log.c                |    1 
 fs/xfs/xfs_log_priv.h           |    1 
 fs/xfs/xfs_log_recover.c        |  111 ++++++++++++++++++++-------------------
 fs/xfs/xfs_refcount_item.c      |    9 +--
 fs/xfs/xfs_rmap_item.c          |    9 +--
 11 files changed, 157 insertions(+), 115 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index f71679ce23b9..363da37a8e7f 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -245,23 +245,53 @@ xfs_defer_create_intents(
 	return ret;
 }
 
-STATIC void
+static inline void
 xfs_defer_pending_abort(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+
+	trace_xfs_defer_pending_abort(mp, dfp);
+
+	if (dfp->dfp_intent && !dfp->dfp_done) {
+		ops->abort_intent(dfp->dfp_intent);
+		dfp->dfp_intent = NULL;
+	}
+}
+
+static inline void
+xfs_defer_pending_cancel_work(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	struct list_head		*pwi;
+	struct list_head		*n;
+
+	trace_xfs_defer_cancel_list(mp, dfp);
+
+	list_del(&dfp->dfp_list);
+	list_for_each_safe(pwi, n, &dfp->dfp_work) {
+		list_del(pwi);
+		dfp->dfp_count--;
+		trace_xfs_defer_cancel_item(mp, dfp, pwi);
+		ops->cancel_item(pwi);
+	}
+	ASSERT(dfp->dfp_count == 0);
+	kmem_cache_free(xfs_defer_pending_cache, dfp);
+}
+
+STATIC void
+xfs_defer_pending_abort_list(
 	struct xfs_mount		*mp,
 	struct list_head		*dop_list)
 {
 	struct xfs_defer_pending	*dfp;
-	const struct xfs_defer_op_type	*ops;
 
 	/* Abort intent items that don't have a done item. */
-	list_for_each_entry(dfp, dop_list, dfp_list) {
-		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_pending_abort(mp, dfp);
-		if (dfp->dfp_intent && !dfp->dfp_done) {
-			ops->abort_intent(dfp->dfp_intent);
-			dfp->dfp_intent = NULL;
-		}
-	}
+	list_for_each_entry(dfp, dop_list, dfp_list)
+		xfs_defer_pending_abort(mp, dfp);
 }
 
 /* Abort all the intents that were committed. */
@@ -271,7 +301,7 @@ xfs_defer_trans_abort(
 	struct list_head		*dop_pending)
 {
 	trace_xfs_defer_trans_abort(tp, _RET_IP_);
-	xfs_defer_pending_abort(tp->t_mountp, dop_pending);
+	xfs_defer_pending_abort_list(tp->t_mountp, dop_pending);
 }
 
 /*
@@ -389,27 +419,13 @@ xfs_defer_cancel_list(
 {
 	struct xfs_defer_pending	*dfp;
 	struct xfs_defer_pending	*pli;
-	struct list_head		*pwi;
-	struct list_head		*n;
-	const struct xfs_defer_op_type	*ops;
 
 	/*
 	 * Free the pending items.  Caller should already have arranged
 	 * for the intent items to be released.
 	 */
-	list_for_each_entry_safe(dfp, pli, dop_list, dfp_list) {
-		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_cancel_list(mp, dfp);
-		list_del(&dfp->dfp_list);
-		list_for_each_safe(pwi, n, &dfp->dfp_work) {
-			list_del(pwi);
-			dfp->dfp_count--;
-			trace_xfs_defer_cancel_item(mp, dfp, pwi);
-			ops->cancel_item(pwi);
-		}
-		ASSERT(dfp->dfp_count == 0);
-		kmem_cache_free(xfs_defer_pending_cache, dfp);
-	}
+	list_for_each_entry_safe(dfp, pli, dop_list, dfp_list)
+		xfs_defer_pending_cancel_work(mp, dfp);
 }
 
 /*
@@ -665,6 +681,39 @@ xfs_defer_add(
 	dfp->dfp_count++;
 }
 
+/*
+ * Create a pending deferred work item to replay the recovered intent item
+ * and add it to the list.
+ */
+void
+xfs_defer_start_recovery(
+	struct xfs_log_item		*lip,
+	enum xfs_defer_ops_type		dfp_type,
+	struct list_head		*r_dfops)
+{
+	struct xfs_defer_pending	*dfp;
+
+	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
+			GFP_NOFS | __GFP_NOFAIL);
+	dfp->dfp_type = dfp_type;
+	dfp->dfp_intent = lip;
+	INIT_LIST_HEAD(&dfp->dfp_work);
+	list_add_tail(&dfp->dfp_list, r_dfops);
+}
+
+/*
+ * Cancel a deferred work item created to recover a log intent item.  @dfp
+ * will be freed after this function returns.
+ */
+void
+xfs_defer_cancel_recovery(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp)
+{
+	xfs_defer_pending_abort(mp, dfp);
+	xfs_defer_pending_cancel_work(mp, dfp);
+}
+
 /*
  * Move deferred ops from one transaction to another and reset the source to
  * initial state. This is primarily used to carry state forward across
@@ -769,7 +818,7 @@ xfs_defer_ops_capture_abort(
 {
 	unsigned short			i;
 
-	xfs_defer_pending_abort(mp, &dfc->dfc_dfops);
+	xfs_defer_pending_abort_list(mp, &dfc->dfc_dfops);
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
 
 	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 8788ad5f6a73..5dce938ba3d5 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -125,6 +125,11 @@ void xfs_defer_ops_capture_abort(struct xfs_mount *mp,
 		struct xfs_defer_capture *d);
 void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
 
+void xfs_defer_start_recovery(struct xfs_log_item *lip,
+		enum xfs_defer_ops_type dfp_type, struct list_head *r_dfops);
+void xfs_defer_cancel_recovery(struct xfs_mount *mp,
+		struct xfs_defer_pending *dfp);
+
 int __init xfs_defer_init_item_caches(void);
 void xfs_defer_destroy_item_caches(void);
 
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index a5100a11faf9..271a4ce7375c 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -153,4 +153,7 @@ xlog_recover_resv(const struct xfs_trans_res *r)
 	return ret;
 }
 
+void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
+		xfs_lsn_t lsn, unsigned int dfp_type);
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 11e88a76a33c..a32716b8cbbd 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -772,14 +772,8 @@ xlog_recover_attri_commit_pass2(
 	attrip = xfs_attri_init(mp, nv);
 	memcpy(&attrip->attri_format, attri_formatp, len);
 
-	/*
-	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
-	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
-	 * directly and drop the ATTRI reference. Note that
-	 * xfs_trans_ail_update() drops the AIL lock.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &attrip->attri_item, lsn);
-	xfs_attri_release(attrip);
+	xlog_recover_intent_item(log, &attrip->attri_item, lsn,
+			XFS_DEFER_OPS_TYPE_ATTR);
 	xfs_attri_log_nameval_put(nv);
 	return 0;
 }
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e736a0844c89..6cbae4fdf43f 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -681,12 +681,9 @@ xlog_recover_bui_commit_pass2(
 	buip = xfs_bui_init(mp);
 	xfs_bui_copy_format(&buip->bui_format, bui_formatp);
 	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
-	/*
-	 * Insert the intent into the AIL directly and drop one reference so
-	 * that finishing or canceling the work will drop the other.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &buip->bui_item, lsn);
-	xfs_bui_release(buip);
+
+	xlog_recover_intent_item(log, &buip->bui_item, lsn,
+			XFS_DEFER_OPS_TYPE_BMAP);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 3fa8789820ad..cf0ddeb70580 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -820,12 +820,9 @@ xlog_recover_efi_commit_pass2(
 		return error;
 	}
 	atomic_set(&efip->efi_next_extent, efi_formatp->efi_nextents);
-	/*
-	 * Insert the intent into the AIL directly and drop one reference so
-	 * that finishing or canceling the work will drop the other.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &efip->efi_item, lsn);
-	xfs_efi_release(efip);
+
+	xlog_recover_intent_item(log, &efip->efi_item, lsn,
+			XFS_DEFER_OPS_TYPE_FREE);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index ee206facf0dc..a1650fc81382 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1542,6 +1542,7 @@ xlog_alloc_log(
 	log->l_covered_state = XLOG_STATE_COVER_IDLE;
 	set_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
 	INIT_DELAYED_WORK(&log->l_work, xfs_log_worker);
+	INIT_LIST_HEAD(&log->r_dfops);
 
 	log->l_prev_block  = -1;
 	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index fa3ad1d7b31c..e30c06ec20e3 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -407,6 +407,7 @@ struct xlog {
 	long			l_opstate;	/* operational state */
 	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
 	struct list_head	*l_buf_cancel_table;
+	struct list_head	r_dfops;	/* recovered log intent items */
 	int			l_iclog_hsize;  /* size of iclog header */
 	int			l_iclog_heads;  /* # of iclog header sectors */
 	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a1e18b24971a..b9d2152a2bad 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1723,30 +1723,24 @@ xlog_clear_stale_blocks(
  */
 void
 xlog_recover_release_intent(
-	struct xlog		*log,
-	unsigned short		intent_type,
-	uint64_t		intent_id)
+	struct xlog			*log,
+	unsigned short			intent_type,
+	uint64_t			intent_id)
 {
-	struct xfs_ail_cursor	cur;
-	struct xfs_log_item	*lip;
-	struct xfs_ail		*ailp = log->l_ailp;
+	struct xfs_defer_pending	*dfp, *n;
+
+	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
+		struct xfs_log_item	*lip = dfp->dfp_intent;
 
-	spin_lock(&ailp->ail_lock);
-	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0); lip != NULL;
-	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
 		if (lip->li_type != intent_type)
 			continue;
 		if (!lip->li_ops->iop_match(lip, intent_id))
 			continue;
 
-		spin_unlock(&ailp->ail_lock);
-		lip->li_ops->iop_release(lip);
-		spin_lock(&ailp->ail_lock);
-		break;
-	}
+		ASSERT(xlog_item_is_intent(lip));
 
-	xfs_trans_ail_cursor_done(&cur);
-	spin_unlock(&ailp->ail_lock);
+		xfs_defer_cancel_recovery(log->l_mp, dfp);
+	}
 }
 
 int
@@ -1939,6 +1933,29 @@ xlog_buf_readahead(
 		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
 }
 
+/*
+ * Create a deferred work structure for resuming and tracking the progress of a
+ * log intent item that was found during recovery.
+ */
+void
+xlog_recover_intent_item(
+	struct xlog			*log,
+	struct xfs_log_item		*lip,
+	xfs_lsn_t			lsn,
+	unsigned int			dfp_type)
+{
+	ASSERT(xlog_item_is_intent(lip));
+
+	xfs_defer_start_recovery(lip, dfp_type, &log->r_dfops);
+
+	/*
+	 * Insert the intent into the AIL directly and drop one reference so
+	 * that finishing or canceling the work will drop the other.
+	 */
+	xfs_trans_ail_insert(log->l_ailp, lip, lsn);
+	lip->li_ops->iop_unpin(lip, 0);
+}
+
 STATIC int
 xlog_recover_items_pass2(
 	struct xlog                     *log,
@@ -2533,29 +2550,22 @@ xlog_abort_defer_ops(
  */
 STATIC int
 xlog_recover_process_intents(
-	struct xlog		*log)
+	struct xlog			*log)
 {
 	LIST_HEAD(capture_list);
-	struct xfs_ail_cursor	cur;
-	struct xfs_log_item	*lip;
-	struct xfs_ail		*ailp;
-	int			error = 0;
+	struct xfs_defer_pending	*dfp, *n;
+	int				error = 0;
 #if defined(DEBUG) || defined(XFS_WARN)
-	xfs_lsn_t		last_lsn;
-#endif
+	xfs_lsn_t			last_lsn;
 
-	ailp = log->l_ailp;
-	spin_lock(&ailp->ail_lock);
-#if defined(DEBUG) || defined(XFS_WARN)
 	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
 #endif
-	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	     lip != NULL;
-	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
-		const struct xfs_item_ops	*ops;
 
-		if (!xlog_item_is_intent(lip))
-			break;
+	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
+		struct xfs_log_item	*lip = dfp->dfp_intent;
+		const struct xfs_item_ops *ops = lip->li_ops;
+
+		ASSERT(xlog_item_is_intent(lip));
 
 		/*
 		 * We should never see a redo item with a LSN higher than
@@ -2573,19 +2583,22 @@ xlog_recover_process_intents(
 		 * The recovery function can free the log item, so we must not
 		 * access lip after it returns.
 		 */
-		spin_unlock(&ailp->ail_lock);
-		ops = lip->li_ops;
 		error = ops->iop_recover(lip, &capture_list);
-		spin_lock(&ailp->ail_lock);
 		if (error) {
 			trace_xlog_intent_recovery_failed(log->l_mp, error,
 					ops->iop_recover);
 			break;
 		}
-	}
 
-	xfs_trans_ail_cursor_done(&cur);
-	spin_unlock(&ailp->ail_lock);
+		/*
+		 * XXX: @lip could have been freed, so detach the log item from
+		 * the pending item before freeing the pending item.  This does
+		 * not fix the existing UAF bug that occurs if ->iop_recover
+		 * fails after creating the intent done item.
+		 */
+		dfp->dfp_intent = NULL;
+		xfs_defer_cancel_recovery(log->l_mp, dfp);
+	}
 	if (error)
 		goto err;
 
@@ -2606,27 +2619,15 @@ xlog_recover_process_intents(
  */
 STATIC void
 xlog_recover_cancel_intents(
-	struct xlog		*log)
+	struct xlog			*log)
 {
-	struct xfs_log_item	*lip;
-	struct xfs_ail_cursor	cur;
-	struct xfs_ail		*ailp;
+	struct xfs_defer_pending	*dfp, *n;
 
-	ailp = log->l_ailp;
-	spin_lock(&ailp->ail_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	while (lip != NULL) {
-		if (!xlog_item_is_intent(lip))
-			break;
+	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
+		ASSERT(xlog_item_is_intent(dfp->dfp_intent));
 
-		spin_unlock(&ailp->ail_lock);
-		lip->li_ops->iop_release(lip);
-		spin_lock(&ailp->ail_lock);
-		lip = xfs_trans_ail_cursor_next(ailp, &cur);
+		xfs_defer_cancel_recovery(log->l_mp, dfp);
 	}
-
-	xfs_trans_ail_cursor_done(&cur);
-	spin_unlock(&ailp->ail_lock);
 }
 
 /*
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2d4444d61e98..b88cb2e98227 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -696,12 +696,9 @@ xlog_recover_cui_commit_pass2(
 	cuip = xfs_cui_init(mp, cui_formatp->cui_nextents);
 	xfs_cui_copy_format(&cuip->cui_format, cui_formatp);
 	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
-	/*
-	 * Insert the intent into the AIL directly and drop one reference so
-	 * that finishing or canceling the work will drop the other.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &cuip->cui_item, lsn);
-	xfs_cui_release(cuip);
+
+	xlog_recover_intent_item(log, &cuip->cui_item, lsn,
+			XFS_DEFER_OPS_TYPE_REFCOUNT);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 0e0e747028da..c30d4a4a14b2 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -702,12 +702,9 @@ xlog_recover_rui_commit_pass2(
 	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
 	xfs_rui_copy_format(&ruip->rui_format, rui_formatp);
 	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
-	/*
-	 * Insert the intent into the AIL directly and drop one reference so
-	 * that finishing or canceling the work will drop the other.
-	 */
-	xfs_trans_ail_insert(log->l_ailp, &ruip->rui_item, lsn);
-	xfs_rui_release(ruip);
+
+	xlog_recover_intent_item(log, &ruip->rui_item, lsn,
+			XFS_DEFER_OPS_TYPE_RMAP);
 	return 0;
 }
 


