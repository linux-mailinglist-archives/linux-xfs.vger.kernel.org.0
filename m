Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF8A2146D
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 09:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbfEQHdB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 03:33:01 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45650 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728061AbfEQHdB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:33:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qrW93c9jt7NQHJvWKY7Ok+KhP7saHzH4o7mIWpLAiSs=; b=eEzAQ5y8YMQl+JrKNiu0rh+pY
        ElFK5+1wYM3gJuHFcfMPmkQD7XjbeWW6WUwhg7UZszh3So34lZ5RwPPXwFgdBjUl3WqgXgYZmOVao
        TRo7MTURfo36+MeifYTTX70U5t6ckdfmwjN9nLqOmuVGaSxRzPD3lN2P8QFzAjtEPSvd4Hp47wi++
        RW2CG0WiOqMtjHLMsH5VmGckLhg5qbbTkY9nr/k1uFAieJ4ap3Dz0oHpLbDRBI2v/CYgAV743xM2P
        yF9oSWLZ6rSo0w7P63xDas9I5tK4QRXFNc14NNpaAe/261JgIWtM9uX73dibQr21OzAEDmH+i9vnU
        WCGapv2HQ==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXMS-00013p-SU
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:33:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 20/20] xfs: merge xfs_trans_bmap.c into xfs_bmap_item.c
Date:   Fri, 17 May 2019 09:31:19 +0200
Message-Id: <20190517073119.30178-21-hch@lst.de>
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

Keep all bmap item related code together.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile         |   1 -
 fs/xfs/xfs_bmap_item.c  | 200 ++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans.h      |  11 --
 fs/xfs/xfs_trans_bmap.c | 216 ----------------------------------------
 4 files changed, 199 insertions(+), 229 deletions(-)
 delete mode 100644 fs/xfs/xfs_trans_bmap.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 1730664770c5..9161af54a87c 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -104,7 +104,6 @@ xfs-y				+= xfs_log.o \
 				   xfs_rmap_item.o \
 				   xfs_log_recover.o \
 				   xfs_trans_ail.o \
-				   xfs_trans_bmap.o \
 				   xfs_trans_buf.o \
 				   xfs_trans_inode.o
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 40385c8b752a..ce5cf8aea3a4 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -6,6 +6,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_format.h"
+#include "xfs_shared.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
@@ -212,7 +213,7 @@ static const struct xfs_item_ops xfs_bud_item_ops = {
 	.iop_release	= xfs_bud_item_release,
 };
 
-struct xfs_bud_log_item *
+static struct xfs_bud_log_item *
 xfs_trans_get_bud(
 	struct xfs_trans		*tp,
 	struct xfs_bui_log_item		*buip)
@@ -229,6 +230,203 @@ xfs_trans_get_bud(
 	return budp;
 }
 
+/*
+ * Finish an bmap update and log it to the BUD. Note that the
+ * transaction is marked dirty regardless of whether the bmap update
+ * succeeds or fails to support the BUI/BUD lifecycle rules.
+ */
+static int
+xfs_trans_log_finish_bmap_update(
+	struct xfs_trans		*tp,
+	struct xfs_bud_log_item		*budp,
+	enum xfs_bmap_intent_type	type,
+	struct xfs_inode		*ip,
+	int				whichfork,
+	xfs_fileoff_t			startoff,
+	xfs_fsblock_t			startblock,
+	xfs_filblks_t			*blockcount,
+	xfs_exntst_t			state)
+{
+	int				error;
+
+	error = xfs_bmap_finish_one(tp, ip, type, whichfork, startoff,
+			startblock, blockcount, state);
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the BUI and frees the BUD
+	 * 2.) shuts down the filesystem
+	 */
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
+
+	return error;
+}
+
+/* Sort bmap intents by inode. */
+static int
+xfs_bmap_update_diff_items(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	struct xfs_bmap_intent		*ba;
+	struct xfs_bmap_intent		*bb;
+
+	ba = container_of(a, struct xfs_bmap_intent, bi_list);
+	bb = container_of(b, struct xfs_bmap_intent, bi_list);
+	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
+}
+
+/* Get an BUI. */
+STATIC void *
+xfs_bmap_update_create_intent(
+	struct xfs_trans		*tp,
+	unsigned int			count)
+{
+	struct xfs_bui_log_item		*buip;
+
+	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
+	ASSERT(tp != NULL);
+
+	buip = xfs_bui_init(tp->t_mountp);
+	ASSERT(buip != NULL);
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	xfs_trans_add_item(tp, &buip->bui_item);
+	return buip;
+}
+
+/* Set the map extent flags for this mapping. */
+static void
+xfs_trans_set_bmap_flags(
+	struct xfs_map_extent		*bmap,
+	enum xfs_bmap_intent_type	type,
+	int				whichfork,
+	xfs_exntst_t			state)
+{
+	bmap->me_flags = 0;
+	switch (type) {
+	case XFS_BMAP_MAP:
+	case XFS_BMAP_UNMAP:
+		bmap->me_flags = type;
+		break;
+	default:
+		ASSERT(0);
+	}
+	if (state == XFS_EXT_UNWRITTEN)
+		bmap->me_flags |= XFS_BMAP_EXTENT_UNWRITTEN;
+	if (whichfork == XFS_ATTR_FORK)
+		bmap->me_flags |= XFS_BMAP_EXTENT_ATTR_FORK;
+}
+
+/* Log bmap updates in the intent item. */
+STATIC void
+xfs_bmap_update_log_item(
+	struct xfs_trans		*tp,
+	void				*intent,
+	struct list_head		*item)
+{
+	struct xfs_bui_log_item		*buip = intent;
+	struct xfs_bmap_intent		*bmap;
+	uint				next_extent;
+	struct xfs_map_extent		*map;
+
+	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
+
+	/*
+	 * atomic_inc_return gives us the value after the increment;
+	 * we want to use it as an array index so we need to subtract 1 from
+	 * it.
+	 */
+	next_extent = atomic_inc_return(&buip->bui_next_extent) - 1;
+	ASSERT(next_extent < buip->bui_format.bui_nextents);
+	map = &buip->bui_format.bui_extents[next_extent];
+	map->me_owner = bmap->bi_owner->i_ino;
+	map->me_startblock = bmap->bi_bmap.br_startblock;
+	map->me_startoff = bmap->bi_bmap.br_startoff;
+	map->me_len = bmap->bi_bmap.br_blockcount;
+	xfs_trans_set_bmap_flags(map, bmap->bi_type, bmap->bi_whichfork,
+			bmap->bi_bmap.br_state);
+}
+
+/* Get an BUD so we can process all the deferred rmap updates. */
+STATIC void *
+xfs_bmap_update_create_done(
+	struct xfs_trans		*tp,
+	void				*intent,
+	unsigned int			count)
+{
+	return xfs_trans_get_bud(tp, intent);
+}
+
+/* Process a deferred rmap update. */
+STATIC int
+xfs_bmap_update_finish_item(
+	struct xfs_trans		*tp,
+	struct list_head		*item,
+	void				*done_item,
+	void				**state)
+{
+	struct xfs_bmap_intent		*bmap;
+	xfs_filblks_t			count;
+	int				error;
+
+	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
+	count = bmap->bi_bmap.br_blockcount;
+	error = xfs_trans_log_finish_bmap_update(tp, done_item,
+			bmap->bi_type,
+			bmap->bi_owner, bmap->bi_whichfork,
+			bmap->bi_bmap.br_startoff,
+			bmap->bi_bmap.br_startblock,
+			&count,
+			bmap->bi_bmap.br_state);
+	if (!error && count > 0) {
+		ASSERT(bmap->bi_type == XFS_BMAP_UNMAP);
+		bmap->bi_bmap.br_blockcount = count;
+		return -EAGAIN;
+	}
+	kmem_free(bmap);
+	return error;
+}
+
+/* Abort all pending BUIs. */
+STATIC void
+xfs_bmap_update_abort_intent(
+	void				*intent)
+{
+	xfs_bui_release(intent);
+}
+
+/* Cancel a deferred rmap update. */
+STATIC void
+xfs_bmap_update_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_bmap_intent		*bmap;
+
+	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
+	kmem_free(bmap);
+}
+
+const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
+	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
+	.diff_items	= xfs_bmap_update_diff_items,
+	.create_intent	= xfs_bmap_update_create_intent,
+	.abort_intent	= xfs_bmap_update_abort_intent,
+	.log_item	= xfs_bmap_update_log_item,
+	.create_done	= xfs_bmap_update_create_done,
+	.finish_item	= xfs_bmap_update_finish_item,
+	.cancel_item	= xfs_bmap_update_cancel_item,
+};
+
 /*
  * Process a bmap update intent item that was recovered from the log.
  * We need to update some inode's bmbt.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index bb411d8c41cf..d3dcabc27b97 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -244,15 +244,4 @@ void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
 
 extern kmem_zone_t	*xfs_trans_zone;
 
-/* mapping updates */
-enum xfs_bmap_intent_type;
-
-struct xfs_bud_log_item *xfs_trans_get_bud(struct xfs_trans *tp,
-		struct xfs_bui_log_item *buip);
-int xfs_trans_log_finish_bmap_update(struct xfs_trans *tp,
-		struct xfs_bud_log_item *rudp, enum xfs_bmap_intent_type type,
-		struct xfs_inode *ip, int whichfork, xfs_fileoff_t startoff,
-		xfs_fsblock_t startblock, xfs_filblks_t *blockcount,
-		xfs_exntst_t state);
-
 #endif	/* __XFS_TRANS_H__ */
diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
deleted file mode 100644
index c6f5b217d17c..000000000000
--- a/fs/xfs/xfs_trans_bmap.c
+++ /dev/null
@@ -1,216 +0,0 @@
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
-#include "xfs_bmap_item.h"
-#include "xfs_alloc.h"
-#include "xfs_bmap.h"
-#include "xfs_inode.h"
-
-/*
- * Finish an bmap update and log it to the BUD. Note that the
- * transaction is marked dirty regardless of whether the bmap update
- * succeeds or fails to support the BUI/BUD lifecycle rules.
- */
-int
-xfs_trans_log_finish_bmap_update(
-	struct xfs_trans		*tp,
-	struct xfs_bud_log_item		*budp,
-	enum xfs_bmap_intent_type	type,
-	struct xfs_inode		*ip,
-	int				whichfork,
-	xfs_fileoff_t			startoff,
-	xfs_fsblock_t			startblock,
-	xfs_filblks_t			*blockcount,
-	xfs_exntst_t			state)
-{
-	int				error;
-
-	error = xfs_bmap_finish_one(tp, ip, type, whichfork, startoff,
-			startblock, blockcount, state);
-
-	/*
-	 * Mark the transaction dirty, even on error. This ensures the
-	 * transaction is aborted, which:
-	 *
-	 * 1.) releases the BUI and frees the BUD
-	 * 2.) shuts down the filesystem
-	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
-
-	return error;
-}
-
-/* Sort bmap intents by inode. */
-static int
-xfs_bmap_update_diff_items(
-	void				*priv,
-	struct list_head		*a,
-	struct list_head		*b)
-{
-	struct xfs_bmap_intent		*ba;
-	struct xfs_bmap_intent		*bb;
-
-	ba = container_of(a, struct xfs_bmap_intent, bi_list);
-	bb = container_of(b, struct xfs_bmap_intent, bi_list);
-	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
-}
-
-/* Get an BUI. */
-STATIC void *
-xfs_bmap_update_create_intent(
-	struct xfs_trans		*tp,
-	unsigned int			count)
-{
-	struct xfs_bui_log_item		*buip;
-
-	ASSERT(count == XFS_BUI_MAX_FAST_EXTENTS);
-	ASSERT(tp != NULL);
-
-	buip = xfs_bui_init(tp->t_mountp);
-	ASSERT(buip != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &buip->bui_item);
-	return buip;
-}
-
-/* Set the map extent flags for this mapping. */
-static void
-xfs_trans_set_bmap_flags(
-	struct xfs_map_extent		*bmap,
-	enum xfs_bmap_intent_type	type,
-	int				whichfork,
-	xfs_exntst_t			state)
-{
-	bmap->me_flags = 0;
-	switch (type) {
-	case XFS_BMAP_MAP:
-	case XFS_BMAP_UNMAP:
-		bmap->me_flags = type;
-		break;
-	default:
-		ASSERT(0);
-	}
-	if (state == XFS_EXT_UNWRITTEN)
-		bmap->me_flags |= XFS_BMAP_EXTENT_UNWRITTEN;
-	if (whichfork == XFS_ATTR_FORK)
-		bmap->me_flags |= XFS_BMAP_EXTENT_ATTR_FORK;
-}
-
-/* Log bmap updates in the intent item. */
-STATIC void
-xfs_bmap_update_log_item(
-	struct xfs_trans		*tp,
-	void				*intent,
-	struct list_head		*item)
-{
-	struct xfs_bui_log_item		*buip = intent;
-	struct xfs_bmap_intent		*bmap;
-	uint				next_extent;
-	struct xfs_map_extent		*map;
-
-	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
-
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
-
-	/*
-	 * atomic_inc_return gives us the value after the increment;
-	 * we want to use it as an array index so we need to subtract 1 from
-	 * it.
-	 */
-	next_extent = atomic_inc_return(&buip->bui_next_extent) - 1;
-	ASSERT(next_extent < buip->bui_format.bui_nextents);
-	map = &buip->bui_format.bui_extents[next_extent];
-	map->me_owner = bmap->bi_owner->i_ino;
-	map->me_startblock = bmap->bi_bmap.br_startblock;
-	map->me_startoff = bmap->bi_bmap.br_startoff;
-	map->me_len = bmap->bi_bmap.br_blockcount;
-	xfs_trans_set_bmap_flags(map, bmap->bi_type, bmap->bi_whichfork,
-			bmap->bi_bmap.br_state);
-}
-
-/* Get an BUD so we can process all the deferred rmap updates. */
-STATIC void *
-xfs_bmap_update_create_done(
-	struct xfs_trans		*tp,
-	void				*intent,
-	unsigned int			count)
-{
-	return xfs_trans_get_bud(tp, intent);
-}
-
-/* Process a deferred rmap update. */
-STATIC int
-xfs_bmap_update_finish_item(
-	struct xfs_trans		*tp,
-	struct list_head		*item,
-	void				*done_item,
-	void				**state)
-{
-	struct xfs_bmap_intent		*bmap;
-	xfs_filblks_t			count;
-	int				error;
-
-	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
-	count = bmap->bi_bmap.br_blockcount;
-	error = xfs_trans_log_finish_bmap_update(tp, done_item,
-			bmap->bi_type,
-			bmap->bi_owner, bmap->bi_whichfork,
-			bmap->bi_bmap.br_startoff,
-			bmap->bi_bmap.br_startblock,
-			&count,
-			bmap->bi_bmap.br_state);
-	if (!error && count > 0) {
-		ASSERT(bmap->bi_type == XFS_BMAP_UNMAP);
-		bmap->bi_bmap.br_blockcount = count;
-		return -EAGAIN;
-	}
-	kmem_free(bmap);
-	return error;
-}
-
-/* Abort all pending BUIs. */
-STATIC void
-xfs_bmap_update_abort_intent(
-	void				*intent)
-{
-	xfs_bui_release(intent);
-}
-
-/* Cancel a deferred rmap update. */
-STATIC void
-xfs_bmap_update_cancel_item(
-	struct list_head		*item)
-{
-	struct xfs_bmap_intent		*bmap;
-
-	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
-	kmem_free(bmap);
-}
-
-const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
-	.max_items	= XFS_BUI_MAX_FAST_EXTENTS,
-	.diff_items	= xfs_bmap_update_diff_items,
-	.create_intent	= xfs_bmap_update_create_intent,
-	.abort_intent	= xfs_bmap_update_abort_intent,
-	.log_item	= xfs_bmap_update_log_item,
-	.create_done	= xfs_bmap_update_create_done,
-	.finish_item	= xfs_bmap_update_finish_item,
-	.cancel_item	= xfs_bmap_update_cancel_item,
-};
-- 
2.20.1

