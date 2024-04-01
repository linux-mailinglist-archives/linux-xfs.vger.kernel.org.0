Return-Path: <linux-xfs+bounces-6123-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CCB36894209
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Apr 2024 18:49:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 420281F21B54
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Apr 2024 16:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B601D482E4;
	Mon,  1 Apr 2024 16:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9cSZkxm"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709B18F5C;
	Mon,  1 Apr 2024 16:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990133; cv=none; b=BRYTXrlyf8Tyhy4DhPN2LIskElO09eH+0ehHmXyfSJrFtg5EKsP0B4todheWqIUlR9ddnkLTZ7edIPYKvugimK/KsXto+/GthxGSQgz89hIUFEw+4tkjHNps+XntvbMdh76FHQOuenNAPSE6auWYX+cagC2JhTgNcjPnZ9x/N6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990133; c=relaxed/simple;
	bh=0/k1dn7mLnUdFyaBdFCRCLykLc4RCX3P9FnKGLJ1B78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+QNan1fpeqD8htlKOn9giforYFpt/V8IoGH1rBa0JdeKne/14d7XLBnmkgsSboE9zpQOajbvBdUvcK3w8/IasoLOHUoTPtVBNWc2pKALtkH4Dhzj4SR0qRguczLC27DgVxyk7oPz6M6ySrM59J+KHwdYj9Im001zLujevg/Bcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9cSZkxm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81962C433C7;
	Mon,  1 Apr 2024 16:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990133;
	bh=0/k1dn7mLnUdFyaBdFCRCLykLc4RCX3P9FnKGLJ1B78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z9cSZkxm9gfbonBAyFFj21ew/YpxpXdyaad3uIQOCYMPxUtWoICWjbFj6RrcQGaf+
	 WcnIFo3KsXhFHwrb5crECvBJrxlRyOuylumXsKSgQZKAaZrnDLEYtMSumf4Z/IVQJK
	 zyhKCxVQOU45Sa06quptju/1hIxWy73DXCusUYa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>
Subject: [PATCH 6.6 257/396] xfs: use xfs_defer_pending objects to recover intent items
Date: Mon,  1 Apr 2024 17:45:06 +0200
Message-ID: <20240401152555.570538724@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

commit 03f7767c9f6120ac933378fdec3bfd78bf07bc11 upstream.

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_defer.c       |  105 ++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_defer.h       |    5 +
 fs/xfs/libxfs/xfs_log_recover.h |    3 +
 fs/xfs/xfs_attr_item.c          |   10 ---
 fs/xfs/xfs_bmap_item.c          |    9 +--
 fs/xfs/xfs_extfree_item.c       |    9 +--
 fs/xfs/xfs_log.c                |    1 
 fs/xfs/xfs_log_priv.h           |    1 
 fs/xfs/xfs_log_recover.c        |  115 ++++++++++++++++++++--------------------
 fs/xfs/xfs_refcount_item.c      |    9 +--
 fs/xfs/xfs_rmap_item.c          |    9 +--
 11 files changed, 159 insertions(+), 117 deletions(-)

--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -245,23 +245,53 @@ xfs_defer_create_intents(
 	return ret;
 }
 
-STATIC void
+static inline void
 xfs_defer_pending_abort(
 	struct xfs_mount		*mp,
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
+	struct xfs_mount		*mp,
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
@@ -666,6 +682,39 @@ xfs_defer_add(
 }
 
 /*
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
+/*
  * Move deferred ops from one transaction to another and reset the source to
  * initial state. This is primarily used to carry state forward across
  * transaction rolls with pending dfops.
@@ -769,7 +818,7 @@ xfs_defer_ops_capture_abort(
 {
 	unsigned short			i;
 
-	xfs_defer_pending_abort(mp, &dfc->dfc_dfops);
+	xfs_defer_pending_abort_list(mp, &dfc->dfc_dfops);
 	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
 
 	for (i = 0; i < dfc->dfc_held.dr_bufs; i++)
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -125,6 +125,11 @@ void xfs_defer_ops_capture_abort(struct
 		struct xfs_defer_capture *d);
 void xfs_defer_resources_rele(struct xfs_defer_resources *dres);
 
+void xfs_defer_start_recovery(struct xfs_log_item *lip,
+		enum xfs_defer_ops_type dfp_type, struct list_head *r_dfops);
+void xfs_defer_cancel_recovery(struct xfs_mount *mp,
+		struct xfs_defer_pending *dfp);
+
 int __init xfs_defer_init_item_caches(void);
 void xfs_defer_destroy_item_caches(void);
 
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -153,4 +153,7 @@ xlog_recover_resv(const struct xfs_trans
 	return ret;
 }
 
+void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
+		xfs_lsn_t lsn, unsigned int dfp_type);
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
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
 
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1542,6 +1542,7 @@ xlog_alloc_log(
 	log->l_covered_state = XLOG_STATE_COVER_IDLE;
 	set_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
 	INIT_DELAYED_WORK(&log->l_work, xfs_log_worker);
+	INIT_LIST_HEAD(&log->r_dfops);
 
 	log->l_prev_block  = -1;
 	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
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
-
-	spin_lock(&ailp->ail_lock);
-	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0); lip != NULL;
-	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
+	struct xfs_defer_pending	*dfp, *n;
+
+	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
+		struct xfs_log_item	*lip = dfp->dfp_intent;
+
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
 
@@ -2606,27 +2619,15 @@ err:
  */
 STATIC void
 xlog_recover_cancel_intents(
-	struct xlog		*log)
+	struct xlog			*log)
 {
-	struct xfs_log_item	*lip;
-	struct xfs_ail_cursor	cur;
-	struct xfs_ail		*ailp;
-
-	ailp = log->l_ailp;
-	spin_lock(&ailp->ail_lock);
-	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
-	while (lip != NULL) {
-		if (!xlog_item_is_intent(lip))
-			break;
+	struct xfs_defer_pending	*dfp, *n;
 
-		spin_unlock(&ailp->ail_lock);
-		lip->li_ops->iop_release(lip);
-		spin_lock(&ailp->ail_lock);
-		lip = xfs_trans_ail_cursor_next(ailp, &cur);
-	}
+	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
+		ASSERT(xlog_item_is_intent(dfp->dfp_intent));
 
-	xfs_trans_ail_cursor_done(&cur);
-	spin_unlock(&ailp->ail_lock);
+		xfs_defer_cancel_recovery(log->l_mp, dfp);
+	}
 }
 
 /*
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
 



