Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C382146B
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 09:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbfEQHcz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 03:32:55 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45522 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbfEQHcz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oWU0xFlQMGFjdG4I3bPwIzbg65q5AtDBsVhz7r+NSys=; b=U8IVDc38ZzGx4O8ituGtsVBwL
        eSfQIaddII/H59epsHCd2dytfufYKIJhToMLhv4XTlGbq2fCSMyF/RrmVCY8/fwtPUhJENxmTRdlN
        9+yGj/xl7c25lMnQUC3MSADQpPh1+jaGnzN44glCzVWVgykpKmX7IyeC/ojib58LFT5iPQHmhJsLT
        Q+Aa4lUbJxWeMJ8RjdEDi2GOuQ4PsgzoH4meX12hkfzfUO+LY+7qObjDqkJ6ODhwCAQ7SClKfSSai
        WjdmsByEAa+/aPvOcOvgqkmVoC15N7rPKVZ0t/JvG46hyAif8paXZYmRcbSIelvmWkVQhAdDgVe1K
        /r4cEAo4Q==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXMM-000110-L7
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 18/20] xfs: merge xfs_trans_refcount.c into xfs_refcount_item.c
Date:   Fri, 17 May 2019 09:31:17 +0200
Message-Id: <20190517073119.30178-19-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190517073119.30178-1-hch@lst.de>
References: <20190517073119.30178-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Keep all the refcount item related code together in one file.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile             |   1 -
 fs/xfs/xfs_refcount_item.c  | 208 ++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans.h          |  11 --
 fs/xfs/xfs_trans_refcount.c | 224 ------------------------------------
 4 files changed, 207 insertions(+), 237 deletions(-)
 delete mode 100644 fs/xfs/xfs_trans_refcount.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 771a4738abd2..26f8c51d8803 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -107,7 +107,6 @@ xfs-y				+= xfs_log.o \
 				   xfs_trans_bmap.o \
 				   xfs_trans_buf.o \
 				   xfs_trans_inode.o \
-				   xfs_trans_refcount.o \
 				   xfs_trans_rmap.o \
 
 # optional features
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 70dcdf40ac92..7bcc49ee5885 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -217,7 +217,7 @@ static const struct xfs_item_ops xfs_cud_item_ops = {
 	.iop_release	= xfs_cud_item_release,
 };
 
-struct xfs_cud_log_item *
+static struct xfs_cud_log_item *
 xfs_trans_get_cud(
 	struct xfs_trans		*tp,
 	struct xfs_cui_log_item		*cuip)
@@ -234,6 +234,212 @@ xfs_trans_get_cud(
 	return cudp;
 }
 
+/*
+ * Finish an refcount update and log it to the CUD. Note that the
+ * transaction is marked dirty regardless of whether the refcount
+ * update succeeds or fails to support the CUI/CUD lifecycle rules.
+ */
+static int
+xfs_trans_log_finish_refcount_update(
+	struct xfs_trans		*tp,
+	struct xfs_cud_log_item		*cudp,
+	enum xfs_refcount_intent_type	type,
+	xfs_fsblock_t			startblock,
+	xfs_extlen_t			blockcount,
+	xfs_fsblock_t			*new_fsb,
+	xfs_extlen_t			*new_len,
+	struct xfs_btree_cur		**pcur)
+{
+	int				error;
+
+	error = xfs_refcount_finish_one(tp, type, startblock,
+			blockcount, new_fsb, new_len, pcur);
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the CUI and frees the CUD
+	 * 2.) shuts down the filesystem
+	 */
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
+
+	return error;
+}
+
+/* Sort refcount intents by AG. */
+static int
+xfs_refcount_update_diff_items(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_mount		*mp = priv;
+	struct xfs_refcount_intent	*ra;
+	struct xfs_refcount_intent	*rb;
+
+	ra = container_of(a, struct xfs_refcount_intent, ri_list);
+	rb = container_of(b, struct xfs_refcount_intent, ri_list);
+	return  XFS_FSB_TO_AGNO(mp, ra->ri_startblock) -
+		XFS_FSB_TO_AGNO(mp, rb->ri_startblock);
+}
+
+/* Get an CUI. */
+STATIC void *
+xfs_refcount_update_create_intent(
+	struct xfs_trans		*tp,
+	unsigned int			count)
+{
+	struct xfs_cui_log_item		*cuip;
+
+	ASSERT(tp != NULL);
+	ASSERT(count > 0);
+
+	cuip = xfs_cui_init(tp->t_mountp, count);
+	ASSERT(cuip != NULL);
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	xfs_trans_add_item(tp, &cuip->cui_item);
+	return cuip;
+}
+
+/* Set the phys extent flags for this reverse mapping. */
+static void
+xfs_trans_set_refcount_flags(
+	struct xfs_phys_extent		*refc,
+	enum xfs_refcount_intent_type	type)
+{
+	refc->pe_flags = 0;
+	switch (type) {
+	case XFS_REFCOUNT_INCREASE:
+	case XFS_REFCOUNT_DECREASE:
+	case XFS_REFCOUNT_ALLOC_COW:
+	case XFS_REFCOUNT_FREE_COW:
+		refc->pe_flags |= type;
+		break;
+	default:
+		ASSERT(0);
+	}
+}
+
+/* Log refcount updates in the intent item. */
+STATIC void
+xfs_refcount_update_log_item(
+	struct xfs_trans		*tp,
+	void				*intent,
+	struct list_head		*item)
+{
+	struct xfs_cui_log_item		*cuip = intent;
+	struct xfs_refcount_intent	*refc;
+	uint				next_extent;
+	struct xfs_phys_extent		*ext;
+
+	refc = container_of(item, struct xfs_refcount_intent, ri_list);
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
+
+	/*
+	 * atomic_inc_return gives us the value after the increment;
+	 * we want to use it as an array index so we need to subtract 1 from
+	 * it.
+	 */
+	next_extent = atomic_inc_return(&cuip->cui_next_extent) - 1;
+	ASSERT(next_extent < cuip->cui_format.cui_nextents);
+	ext = &cuip->cui_format.cui_extents[next_extent];
+	ext->pe_startblock = refc->ri_startblock;
+	ext->pe_len = refc->ri_blockcount;
+	xfs_trans_set_refcount_flags(ext, refc->ri_type);
+}
+
+/* Get an CUD so we can process all the deferred refcount updates. */
+STATIC void *
+xfs_refcount_update_create_done(
+	struct xfs_trans		*tp,
+	void				*intent,
+	unsigned int			count)
+{
+	return xfs_trans_get_cud(tp, intent);
+}
+
+/* Process a deferred refcount update. */
+STATIC int
+xfs_refcount_update_finish_item(
+	struct xfs_trans		*tp,
+	struct list_head		*item,
+	void				*done_item,
+	void				**state)
+{
+	struct xfs_refcount_intent	*refc;
+	xfs_fsblock_t			new_fsb;
+	xfs_extlen_t			new_aglen;
+	int				error;
+
+	refc = container_of(item, struct xfs_refcount_intent, ri_list);
+	error = xfs_trans_log_finish_refcount_update(tp, done_item,
+			refc->ri_type,
+			refc->ri_startblock,
+			refc->ri_blockcount,
+			&new_fsb, &new_aglen,
+			(struct xfs_btree_cur **)state);
+	/* Did we run out of reservation?  Requeue what we didn't finish. */
+	if (!error && new_aglen > 0) {
+		ASSERT(refc->ri_type == XFS_REFCOUNT_INCREASE ||
+		       refc->ri_type == XFS_REFCOUNT_DECREASE);
+		refc->ri_startblock = new_fsb;
+		refc->ri_blockcount = new_aglen;
+		return -EAGAIN;
+	}
+	kmem_free(refc);
+	return error;
+}
+
+/* Clean up after processing deferred refcounts. */
+STATIC void
+xfs_refcount_update_finish_cleanup(
+	struct xfs_trans	*tp,
+	void			*state,
+	int			error)
+{
+	struct xfs_btree_cur	*rcur = state;
+
+	xfs_refcount_finish_one_cleanup(tp, rcur, error);
+}
+
+/* Abort all pending CUIs. */
+STATIC void
+xfs_refcount_update_abort_intent(
+	void				*intent)
+{
+	xfs_cui_release(intent);
+}
+
+/* Cancel a deferred refcount update. */
+STATIC void
+xfs_refcount_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_refcount_intent	*refc;
+
+	refc = container_of(item, struct xfs_refcount_intent, ri_list);
+	kmem_free(refc);
+}
+
+const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
+	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
+	.diff_items	= xfs_refcount_update_diff_items,
+	.create_intent	= xfs_refcount_update_create_intent,
+	.abort_intent	= xfs_refcount_update_abort_intent,
+	.log_item	= xfs_refcount_update_log_item,
+	.create_done	= xfs_refcount_update_create_done,
+	.finish_item	= xfs_refcount_update_finish_item,
+	.finish_cleanup = xfs_refcount_update_finish_cleanup,
+	.cancel_item	= xfs_refcount_update_cancel_item,
+};
+
 /*
  * Process a refcount update intent item that was recovered from the log.
  * We need to update the refcountbt.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index cc6549100176..1fe910d6da82 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -255,17 +255,6 @@ int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
 		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
 		xfs_exntst_t state, struct xfs_btree_cur **pcur);
 
-/* refcount updates */
-enum xfs_refcount_intent_type;
-
-struct xfs_cud_log_item *xfs_trans_get_cud(struct xfs_trans *tp,
-		struct xfs_cui_log_item *cuip);
-int xfs_trans_log_finish_refcount_update(struct xfs_trans *tp,
-		struct xfs_cud_log_item *cudp,
-		enum xfs_refcount_intent_type type, xfs_fsblock_t startblock,
-		xfs_extlen_t blockcount, xfs_fsblock_t *new_fsb,
-		xfs_extlen_t *new_len, struct xfs_btree_cur **pcur);
-
 /* mapping updates */
 enum xfs_bmap_intent_type;
 
diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
deleted file mode 100644
index d793fb500378..000000000000
--- a/fs/xfs/xfs_trans_refcount.c
+++ /dev/null
@@ -1,224 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/*
- * Copyright (C) 2016 Oracle.  All Rights Reserved.
- * Author: Darrick J. Wong <darrick.wong@oracle.com>
- */
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_shared.h"
-#include "xfs_format.h"
-#include "xfs_log_format.h"
-#include "xfs_trans_resv.h"
-#include "xfs_mount.h"
-#include "xfs_defer.h"
-#include "xfs_trans.h"
-#include "xfs_trans_priv.h"
-#include "xfs_refcount_item.h"
-#include "xfs_alloc.h"
-#include "xfs_refcount.h"
-
-/*
- * Finish an refcount update and log it to the CUD. Note that the
- * transaction is marked dirty regardless of whether the refcount
- * update succeeds or fails to support the CUI/CUD lifecycle rules.
- */
-int
-xfs_trans_log_finish_refcount_update(
-	struct xfs_trans		*tp,
-	struct xfs_cud_log_item		*cudp,
-	enum xfs_refcount_intent_type	type,
-	xfs_fsblock_t			startblock,
-	xfs_extlen_t			blockcount,
-	xfs_fsblock_t			*new_fsb,
-	xfs_extlen_t			*new_len,
-	struct xfs_btree_cur		**pcur)
-{
-	int				error;
-
-	error = xfs_refcount_finish_one(tp, type, startblock,
-			blockcount, new_fsb, new_len, pcur);
-
-	/*
-	 * Mark the transaction dirty, even on error. This ensures the
-	 * transaction is aborted, which:
-	 *
-	 * 1.) releases the CUI and frees the CUD
-	 * 2.) shuts down the filesystem
-	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
-
-	return error;
-}
-
-/* Sort refcount intents by AG. */
-static int
-xfs_refcount_update_diff_items(
-	void				*priv,
-	struct list_head		*a,
-	struct list_head		*b)
-{
-	struct xfs_mount		*mp = priv;
-	struct xfs_refcount_intent	*ra;
-	struct xfs_refcount_intent	*rb;
-
-	ra = container_of(a, struct xfs_refcount_intent, ri_list);
-	rb = container_of(b, struct xfs_refcount_intent, ri_list);
-	return  XFS_FSB_TO_AGNO(mp, ra->ri_startblock) -
-		XFS_FSB_TO_AGNO(mp, rb->ri_startblock);
-}
-
-/* Get an CUI. */
-STATIC void *
-xfs_refcount_update_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_cui_log_item		*cuip;
-
-	ASSERT(tp != NULL);
-	ASSERT(count > 0);
-
-	cuip = xfs_cui_init(tp->t_mountp, count);
-	ASSERT(cuip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &cuip->cui_item);
-	return cuip;
-}
-
-/* Set the phys extent flags for this reverse mapping. */
-static void
-xfs_trans_set_refcount_flags(
-	struct xfs_phys_extent		*refc,
-	enum xfs_refcount_intent_type	type)
-{
-	refc->pe_flags = 0;
-	switch (type) {
-	case XFS_REFCOUNT_INCREASE:
-	case XFS_REFCOUNT_DECREASE:
-	case XFS_REFCOUNT_ALLOC_COW:
-	case XFS_REFCOUNT_FREE_COW:
-		refc->pe_flags |= type;
-		break;
-	default:
-		ASSERT(0);
-	}
-}
-
-/* Log refcount updates in the intent item. */
-STATIC void
-xfs_refcount_update_log_item(
-	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
-{
-	struct xfs_cui_log_item		*cuip = intent;
-	struct xfs_refcount_intent	*refc;
-	uint				next_extent;
-	struct xfs_phys_extent		*ext;
-
-	refc = container_of(item, struct xfs_refcount_intent, ri_list);
-
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
-
-	/*
-	 * atomic_inc_return gives us the value after the increment;
-	 * we want to use it as an array index so we need to subtract 1 from
-	 * it.
-	 */
-	next_extent = atomic_inc_return(&cuip->cui_next_extent) - 1;
-	ASSERT(next_extent < cuip->cui_format.cui_nextents);
-	ext = &cuip->cui_format.cui_extents[next_extent];
-	ext->pe_startblock = refc->ri_startblock;
-	ext->pe_len = refc->ri_blockcount;
-	xfs_trans_set_refcount_flags(ext, refc->ri_type);
-}
-
-/* Get an CUD so we can process all the deferred refcount updates. */
-STATIC void *
-xfs_refcount_update_create_done(
-	struct xfs_trans		*tp,
-	void				*intent,
-	unsigned int			count)
-{
-	return xfs_trans_get_cud(tp, intent);
-}
-
-/* Process a deferred refcount update. */
-STATIC int
-xfs_refcount_update_finish_item(
-	struct xfs_trans		*tp,
-	struct list_head		*item,
-	void				*done_item,
-	void				**state)
-{
-	struct xfs_refcount_intent	*refc;
-	xfs_fsblock_t			new_fsb;
-	xfs_extlen_t			new_aglen;
-	int				error;
-
-	refc = container_of(item, struct xfs_refcount_intent, ri_list);
-	error = xfs_trans_log_finish_refcount_update(tp, done_item,
-			refc->ri_type,
-			refc->ri_startblock,
-			refc->ri_blockcount,
-			&new_fsb, &new_aglen,
-			(struct xfs_btree_cur **)state);
-	/* Did we run out of reservation?  Requeue what we didn't finish. */
-	if (!error && new_aglen > 0) {
-		ASSERT(refc->ri_type == XFS_REFCOUNT_INCREASE ||
-		       refc->ri_type == XFS_REFCOUNT_DECREASE);
-		refc->ri_startblock = new_fsb;
-		refc->ri_blockcount = new_aglen;
-		return -EAGAIN;
-	}
-	kmem_free(refc);
-	return error;
-}
-
-/* Clean up after processing deferred refcounts. */
-STATIC void
-xfs_refcount_update_finish_cleanup(
-	struct xfs_trans	*tp,
-	void			*state,
-	int			error)
-{
-	struct xfs_btree_cur	*rcur = state;
-
-	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-}
-
-/* Abort all pending CUIs. */
-STATIC void
-xfs_refcount_update_abort_intent(
-	void				*intent)
-{
-	xfs_cui_release(intent);
-}
-
-/* Cancel a deferred refcount update. */
-STATIC void
-xfs_refcount_update_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_refcount_intent	*refc;
-
-	refc = container_of(item, struct xfs_refcount_intent, ri_list);
-	kmem_free(refc);
-}
-
-const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
-	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_refcount_update_diff_items,
-	.create_intent	= xfs_refcount_update_create_intent,
-	.abort_intent	= xfs_refcount_update_abort_intent,
-	.log_item	= xfs_refcount_update_log_item,
-	.create_done	= xfs_refcount_update_create_done,
-	.finish_item	= xfs_refcount_update_finish_item,
-	.finish_cleanup = xfs_refcount_update_finish_cleanup,
-	.cancel_item	= xfs_refcount_update_cancel_item,
-};
-- 
2.20.1

