Return-Path: <linux-xfs+bounces-337-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B7E802674
	for <lists+linux-xfs@lfdr.de>; Sun,  3 Dec 2023 20:02:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3C87B20939
	for <lists+linux-xfs@lfdr.de>; Sun,  3 Dec 2023 19:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0755317993;
	Sun,  3 Dec 2023 19:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EkYCPqYV"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD42C17985
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8563DC433C8;
	Sun,  3 Dec 2023 19:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630162;
	bh=fmga40Idg3VUvmUXfUDQuvwGdWedCtlgU1jcHojR1Zg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EkYCPqYVtfzbIHT85mS33Tg+7BP9mbYTPgfdA0migud+hHC1DxtXmER1V4eRbK7ap
	 W+ujzyYRYvwwUVyP2S5582cIJP4fbpyf433NBuLnHx1j5dCA3TTV1ArxSLtf8nJaTZ
	 SBXzmjQV2feK+9ZlcBcKsaISJVHdf6n4LF7vNSb33JGQJXpE7IlTGp7bZ39GRaq44G
	 shAFXo7xxWMj0GjtKs3USvE8leUqlOATqB0s1kGFktX0OXI0p8sA3x/xYbdQwnRdBR
	 +6u7zocOR6bPaVl/I60sivAvJZawG49mekIvL4L9g5d28nl8Clg/r3xgjKhxIwz86H
	 FxuZSEKQY+YlQ==
Date: Sun, 03 Dec 2023 11:02:42 -0800
Subject: [PATCH 8/8] xfs: move ->iop_recover to xfs_defer_op_type
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, hch@lst.de,
 leo.lilong@huawei.com
Cc: linux-xfs@vger.kernel.org
Message-ID: <170162989834.3037528.5749629380198768.stgit@frogsfrogsfrogs>
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

Finish off the series by moving the intent item recovery function
pointer to the xfs_defer_op_type struct, since this is really a deferred
work function now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c       |   17 +++++++++++++++
 fs/xfs/libxfs/xfs_defer.h       |    4 ++++
 fs/xfs/libxfs/xfs_log_recover.h |    2 ++
 fs/xfs/xfs_attr_item.c          |    4 ++--
 fs/xfs/xfs_bmap_item.c          |   22 ++++++++++----------
 fs/xfs/xfs_extfree_item.c       |   43 ++++++++++++++++++++-------------------
 fs/xfs/xfs_log_recover.c        |    9 +++-----
 fs/xfs/xfs_refcount_item.c      |   24 +++++++++++-----------
 fs/xfs/xfs_rmap_item.c          |   24 +++++++++++-----------
 fs/xfs/xfs_trans.h              |    4 ----
 10 files changed, 85 insertions(+), 68 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index eb262ea06122..dd565e4e3daf 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -713,6 +713,23 @@ xfs_defer_cancel_recovery(
 	xfs_defer_pending_cancel_work(mp, dfp);
 }
 
+/* Replay the deferred work item created from a recovered log intent item. */
+int
+xfs_defer_finish_recovery(
+	struct xfs_mount		*mp,
+	struct xfs_defer_pending	*dfp,
+	struct list_head		*capture_list)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	int				error;
+
+	error = ops->recover_work(dfp, capture_list);
+	if (error)
+		trace_xlog_intent_recovery_failed(mp, error,
+				ops->recover_work);
+	return error;
+}
+
 /*
  * Move deferred ops from one transaction to another and reset the source to
  * initial state. This is primarily used to carry state forward across
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index c1a648e99174..ef86a7f9b059 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -57,6 +57,8 @@ struct xfs_defer_op_type {
 	void (*finish_cleanup)(struct xfs_trans *tp,
 			struct xfs_btree_cur *state, int error);
 	void (*cancel_item)(struct list_head *item);
+	int (*recover_work)(struct xfs_defer_pending *dfp,
+			    struct list_head *capture_list);
 	unsigned int		max_items;
 };
 
@@ -130,6 +132,8 @@ void xfs_defer_start_recovery(struct xfs_log_item *lip,
 		enum xfs_defer_ops_type dfp_type, struct list_head *r_dfops);
 void xfs_defer_cancel_recovery(struct xfs_mount *mp,
 		struct xfs_defer_pending *dfp);
+int xfs_defer_finish_recovery(struct xfs_mount *mp,
+		struct xfs_defer_pending *dfp, struct list_head *capture_list);
 
 static inline void
 xfs_defer_add_item(
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 52162a17fc5e..c8e5d912895b 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -153,6 +153,8 @@ xlog_recover_resv(const struct xfs_trans_res *r)
 	return ret;
 }
 
+struct xfs_defer_pending;
+
 void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
 		xfs_lsn_t lsn, unsigned int dfp_type);
 int xlog_recover_finish_intent(struct xfs_trans *tp,
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index eaf8a877c2cc..5f7d8e8d87dc 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -604,7 +604,7 @@ xfs_attri_recover_work(
  * delete the attr that it describes.
  */
 STATIC int
-xfs_attri_item_recover(
+xfs_attr_recover_work(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
@@ -820,6 +820,7 @@ const struct xfs_defer_op_type xfs_attr_defer_type = {
 	.create_done	= xfs_attr_create_done,
 	.finish_item	= xfs_attr_finish_item,
 	.cancel_item	= xfs_attr_cancel_item,
+	.recover_work	= xfs_attr_recover_work,
 };
 
 /*
@@ -856,7 +857,6 @@ static const struct xfs_item_ops xfs_attri_item_ops = {
 	.iop_format	= xfs_attri_item_format,
 	.iop_unpin	= xfs_attri_item_unpin,
 	.iop_release    = xfs_attri_item_release,
-	.iop_recover	= xfs_attri_item_recover,
 	.iop_match	= xfs_attri_item_match,
 	.iop_relog	= xfs_attri_item_relog,
 };
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 89f2d9e89607..fa305d242f24 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -437,15 +437,6 @@ xfs_bmap_update_cancel_item(
 	kmem_cache_free(xfs_bmap_intent_cache, bi);
 }
 
-const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
-	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
-	.create_intent	= xfs_bmap_update_create_intent,
-	.abort_intent	= xfs_bmap_update_abort_intent,
-	.create_done	= xfs_bmap_update_create_done,
-	.finish_item	= xfs_bmap_update_finish_item,
-	.cancel_item	= xfs_bmap_update_cancel_item,
-};
-
 /* Is this recovered BUI ok? */
 static inline bool
 xfs_bui_validate(
@@ -508,7 +499,7 @@ xfs_bui_recover_work(
  * We need to update some inode's bmbt.
  */
 STATIC int
-xfs_bui_item_recover(
+xfs_bmap_recover_work(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
@@ -587,6 +578,16 @@ xfs_bui_item_recover(
 	return error;
 }
 
+const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
+	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_bmap_update_create_intent,
+	.abort_intent	= xfs_bmap_update_abort_intent,
+	.create_done	= xfs_bmap_update_create_done,
+	.finish_item	= xfs_bmap_update_finish_item,
+	.cancel_item	= xfs_bmap_update_cancel_item,
+	.recover_work	= xfs_bmap_recover_work,
+};
+
 STATIC bool
 xfs_bui_item_match(
 	struct xfs_log_item	*lip,
@@ -627,7 +628,6 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
 	.iop_format	= xfs_bui_item_format,
 	.iop_unpin	= xfs_bui_item_unpin,
 	.iop_release	= xfs_bui_item_release,
-	.iop_recover	= xfs_bui_item_recover,
 	.iop_match	= xfs_bui_item_match,
 	.iop_relog	= xfs_bui_item_relog,
 };
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6a434ade486c..49e96ffd64e0 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -567,15 +567,6 @@ xfs_extent_free_cancel_item(
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
 }
 
-const struct xfs_defer_op_type xfs_extent_free_defer_type = {
-	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
-	.create_intent	= xfs_extent_free_create_intent,
-	.abort_intent	= xfs_extent_free_abort_intent,
-	.create_done	= xfs_extent_free_create_done,
-	.finish_item	= xfs_extent_free_finish_item,
-	.cancel_item	= xfs_extent_free_cancel_item,
-};
-
 /*
  * AGFL blocks are accounted differently in the reserve pools and are not
  * inserted into the busy extent list.
@@ -632,16 +623,6 @@ xfs_agfl_free_finish_item(
 	return error;
 }
 
-/* sub-type with special handling for AGFL deferred frees */
-const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
-	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
-	.create_intent	= xfs_extent_free_create_intent,
-	.abort_intent	= xfs_extent_free_abort_intent,
-	.create_done	= xfs_extent_free_create_done,
-	.finish_item	= xfs_agfl_free_finish_item,
-	.cancel_item	= xfs_extent_free_cancel_item,
-};
-
 /* Is this recovered EFI ok? */
 static inline bool
 xfs_efi_validate_ext(
@@ -675,7 +656,7 @@ xfs_efi_recover_work(
  * the log.  We need to free the extents that it describes.
  */
 STATIC int
-xfs_efi_item_recover(
+xfs_extent_free_recover_work(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
@@ -724,6 +705,27 @@ xfs_efi_item_recover(
 	return error;
 }
 
+const struct xfs_defer_op_type xfs_extent_free_defer_type = {
+	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_extent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_extent_free_finish_item,
+	.cancel_item	= xfs_extent_free_cancel_item,
+	.recover_work	= xfs_extent_free_recover_work,
+};
+
+/* sub-type with special handling for AGFL deferred frees */
+const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
+	.max_items	= XFS_EFI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_extent_free_create_intent,
+	.abort_intent	= xfs_extent_free_abort_intent,
+	.create_done	= xfs_extent_free_create_done,
+	.finish_item	= xfs_agfl_free_finish_item,
+	.cancel_item	= xfs_extent_free_cancel_item,
+	.recover_work	= xfs_extent_free_recover_work,
+};
+
 STATIC bool
 xfs_efi_item_match(
 	struct xfs_log_item	*lip,
@@ -766,7 +768,6 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_format	= xfs_efi_item_format,
 	.iop_unpin	= xfs_efi_item_unpin,
 	.iop_release	= xfs_efi_item_release,
-	.iop_recover	= xfs_efi_item_recover,
 	.iop_match	= xfs_efi_item_match,
 	.iop_relog	= xfs_efi_item_relog,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6fab490959d4..1984f741802f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2563,7 +2563,6 @@ xlog_recover_process_intents(
 
 	list_for_each_entry_safe(dfp, n, &log->r_dfops, dfp_list) {
 		struct xfs_log_item	*lip = dfp->dfp_intent;
-		const struct xfs_item_ops *ops = lip->li_ops;
 
 		ASSERT(xlog_item_is_intent(lip));
 
@@ -2584,12 +2583,10 @@ xlog_recover_process_intents(
 		 * access lip after it returns.  It must dispose of @dfp if it
 		 * returns 0.
 		 */
-		error = ops->iop_recover(dfp, &capture_list);
-		if (error) {
-			trace_xlog_intent_recovery_failed(log->l_mp, error,
-					ops->iop_recover);
+		error = xfs_defer_finish_recovery(log->l_mp, dfp,
+				&capture_list);
+		if (error)
 			break;
-		}
 	}
 	if (error)
 		goto err;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index f561ca73c784..48f1a38b272e 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -433,16 +433,6 @@ xfs_refcount_update_cancel_item(
 	kmem_cache_free(xfs_refcount_intent_cache, ri);
 }
 
-const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
-	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
-	.create_intent	= xfs_refcount_update_create_intent,
-	.abort_intent	= xfs_refcount_update_abort_intent,
-	.create_done	= xfs_refcount_update_create_done,
-	.finish_item	= xfs_refcount_update_finish_item,
-	.finish_cleanup = xfs_refcount_finish_one_cleanup,
-	.cancel_item	= xfs_refcount_update_cancel_item,
-};
-
 /* Is this recovered CUI ok? */
 static inline bool
 xfs_cui_validate_phys(
@@ -491,7 +481,7 @@ xfs_cui_recover_work(
  * We need to update the refcountbt.
  */
 STATIC int
-xfs_cui_item_recover(
+xfs_refcount_recover_work(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
@@ -553,6 +543,17 @@ xfs_cui_item_recover(
 	return error;
 }
 
+const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
+	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_refcount_update_create_intent,
+	.abort_intent	= xfs_refcount_update_abort_intent,
+	.create_done	= xfs_refcount_update_create_done,
+	.finish_item	= xfs_refcount_update_finish_item,
+	.finish_cleanup = xfs_refcount_finish_one_cleanup,
+	.cancel_item	= xfs_refcount_update_cancel_item,
+	.recover_work	= xfs_refcount_recover_work,
+};
+
 STATIC bool
 xfs_cui_item_match(
 	struct xfs_log_item	*lip,
@@ -593,7 +594,6 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
 	.iop_format	= xfs_cui_item_format,
 	.iop_unpin	= xfs_cui_item_unpin,
 	.iop_release	= xfs_cui_item_release,
-	.iop_recover	= xfs_cui_item_recover,
 	.iop_match	= xfs_cui_item_match,
 	.iop_relog	= xfs_cui_item_relog,
 };
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 23e736179894..23684bc2ab85 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -452,16 +452,6 @@ xfs_rmap_update_cancel_item(
 	kmem_cache_free(xfs_rmap_intent_cache, ri);
 }
 
-const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
-	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
-	.create_intent	= xfs_rmap_update_create_intent,
-	.abort_intent	= xfs_rmap_update_abort_intent,
-	.create_done	= xfs_rmap_update_create_done,
-	.finish_item	= xfs_rmap_update_finish_item,
-	.finish_cleanup = xfs_rmap_finish_one_cleanup,
-	.cancel_item	= xfs_rmap_update_cancel_item,
-};
-
 /* Is this recovered RUI ok? */
 static inline bool
 xfs_rui_validate_map(
@@ -556,7 +546,7 @@ xfs_rui_recover_work(
  * We need to update the rmapbt.
  */
 STATIC int
-xfs_rui_item_recover(
+xfs_rmap_recover_work(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
@@ -606,6 +596,17 @@ xfs_rui_item_recover(
 	return error;
 }
 
+const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
+	.max_items	= XFS_RUI_MAX_FAST_EXTENTS,
+	.create_intent	= xfs_rmap_update_create_intent,
+	.abort_intent	= xfs_rmap_update_abort_intent,
+	.create_done	= xfs_rmap_update_create_done,
+	.finish_item	= xfs_rmap_update_finish_item,
+	.finish_cleanup = xfs_rmap_finish_one_cleanup,
+	.cancel_item	= xfs_rmap_update_cancel_item,
+	.recover_work	= xfs_rmap_recover_work,
+};
+
 STATIC bool
 xfs_rui_item_match(
 	struct xfs_log_item	*lip,
@@ -646,7 +647,6 @@ static const struct xfs_item_ops xfs_rui_item_ops = {
 	.iop_format	= xfs_rui_item_format,
 	.iop_unpin	= xfs_rui_item_unpin,
 	.iop_release	= xfs_rui_item_release,
-	.iop_recover	= xfs_rui_item_recover,
 	.iop_match	= xfs_rui_item_match,
 	.iop_relog	= xfs_rui_item_relog,
 };
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 4e38357237c3..5fb018ad9fc0 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -66,8 +66,6 @@ struct xfs_log_item {
 	{ (1u << XFS_LI_DIRTY),		"DIRTY" }, \
 	{ (1u << XFS_LI_WHITEOUT),	"WHITEOUT" }
 
-struct xfs_defer_pending;
-
 struct xfs_item_ops {
 	unsigned flags;
 	void (*iop_size)(struct xfs_log_item *, int *, int *);
@@ -80,8 +78,6 @@ struct xfs_item_ops {
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
 	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
 	void (*iop_release)(struct xfs_log_item *);
-	int (*iop_recover)(struct xfs_defer_pending *dfp,
-			   struct list_head *capture_list);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
 			struct xfs_trans *tp);


