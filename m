Return-Path: <linux-xfs+bounces-7101-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 19B128A8DE6
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 23:27:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98F341F216FA
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 21:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8279657B6;
	Wed, 17 Apr 2024 21:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VLugoCSj"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79350657C5
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389220; cv=none; b=XnAzK5ZdSKq8li971qKO+/yV9e0eyTwPs+6OdtVhqioruCvlJDPVjOKn0qQAxydFAeB1k0K78j3rIUzQ5HbvGjsKB2WOlnOvyRnpuKuJi2wvFKjR23y/3HD/4X6+yicE7ndOiKUmtKi1HBATX5lTLDTQ+D28+9SSUYon9Dfx1Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389220; c=relaxed/simple;
	bh=Ax9A4ZIxlR47eoE1aNCkOcxAhIyJ8856Nxijo9DKCgQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DGQOFHwV2M8DF6fdFmjpuWIiKwSGCWwYLZ83Xoghpo5OzUwa5AO1NHXvJxb6pFOf2456N1x5blQMM6GQe/Od5Bg+48rDOUf6zHeArIQ8SMtZVMITxsI16lciT9F/GJ0eWCj99DoESDlEwXNlSpSB0/dCMsLWKf+UIifg2JFk65g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VLugoCSj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA585C116B1;
	Wed, 17 Apr 2024 21:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389220;
	bh=Ax9A4ZIxlR47eoE1aNCkOcxAhIyJ8856Nxijo9DKCgQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VLugoCSjk73aaohfHGHNiF4jP01yIYDltf1JQ/f2ao82hpld+kNIjgIaEPizHPJej
	 2q5Ws0lIPjXkz0ixf/e4OAH0VZYGCE/Uv7uHJlLdukQpJZRgUPwl/qsEc12JSg7Nrs
	 N+STt9psfgQcIvQm07vmVl0Tf2wVZ3em0NCO/zX9hzZzDDhPyKkN39cQHB6/NZlqHS
	 DGHUVCKuuycmdCao2E8G/S5ect6xZENhFouGVnlKAAyjGjuVpbDu7ed4RpAkEdfPPR
	 O83ORU6APjYecEdb2mIMePKqmyIG6rfUu5CLu8JyothljutX9szSis7tKhD62r8jeW
	 RQL0lciSzd/Hg==
Date: Wed, 17 Apr 2024 14:26:59 -0700
Subject: [PATCH 20/67] xfs: force small EFIs for reaping btree extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338842640.1853449.3125326919113892196.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3f3cec031099c37513727efc978a12b6346e326d

Introduce the concept of a defer ops barrier to separate consecutively
queued pending work items of the same type.  With a barrier in place,
the two work items will be tracked separately, and receive separate log
intent items.  The goal here is to prevent reaping of old metadata
blocks from creating unnecessarily huge EFIs that could then run the
risk of overflowing the scrub transaction.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |  107 +++++++++++++++++++++++++++++++++++++++++++++++-----
 libxfs/xfs_defer.h |    3 +
 2 files changed, 99 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 58ad1881d..98f1cbe6a 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -176,6 +176,58 @@ static struct kmem_cache	*xfs_defer_pending_cache;
  * Note that the continuation requested between t2 and t3 is likely to
  * reoccur.
  */
+STATIC struct xfs_log_item *
+xfs_defer_barrier_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return NULL;
+}
+
+STATIC void
+xfs_defer_barrier_abort_intent(
+	struct xfs_log_item		*intent)
+{
+	/* empty */
+}
+
+STATIC struct xfs_log_item *
+xfs_defer_barrier_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	return NULL;
+}
+
+STATIC int
+xfs_defer_barrier_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
+STATIC void
+xfs_defer_barrier_cancel_item(
+	struct list_head		*item)
+{
+	ASSERT(0);
+}
+
+static const struct xfs_defer_op_type xfs_barrier_defer_type = {
+	.max_items	= 1,
+	.create_intent	= xfs_defer_barrier_create_intent,
+	.abort_intent	= xfs_defer_barrier_abort_intent,
+	.create_done	= xfs_defer_barrier_create_done,
+	.finish_item	= xfs_defer_barrier_finish_item,
+	.cancel_item	= xfs_defer_barrier_cancel_item,
+};
 
 static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_BMAP]	= &xfs_bmap_update_defer_type,
@@ -184,6 +236,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
+	[XFS_DEFER_OPS_TYPE_BARRIER]	= &xfs_barrier_defer_type,
 };
 
 /* Create a log intent done item for a log intent item. */
@@ -773,6 +826,23 @@ xfs_defer_can_append(
 	return true;
 }
 
+/* Create a new pending item at the end of the transaction list. */
+static inline struct xfs_defer_pending *
+xfs_defer_alloc(
+	struct xfs_trans		*tp,
+	enum xfs_defer_ops_type		type)
+{
+	struct xfs_defer_pending	*dfp;
+
+	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
+			GFP_NOFS | __GFP_NOFAIL);
+	dfp->dfp_type = type;
+	INIT_LIST_HEAD(&dfp->dfp_work);
+	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
+
+	return dfp;
+}
+
 /* Add an item for later deferred processing. */
 struct xfs_defer_pending *
 xfs_defer_add(
@@ -787,23 +857,38 @@ xfs_defer_add(
 	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
 
 	dfp = xfs_defer_find_last(tp, type, ops);
-	if (!dfp || !xfs_defer_can_append(dfp, ops)) {
-		/* Create a new pending item at the end of the intake list. */
-		dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
-				GFP_NOFS | __GFP_NOFAIL);
-		dfp->dfp_type = type;
-		dfp->dfp_intent = NULL;
-		dfp->dfp_done = NULL;
-		dfp->dfp_count = 0;
-		INIT_LIST_HEAD(&dfp->dfp_work);
-		list_add_tail(&dfp->dfp_list, &tp->t_dfops);
-	}
+	if (!dfp || !xfs_defer_can_append(dfp, ops))
+		dfp = xfs_defer_alloc(tp, type);
 
 	xfs_defer_add_item(dfp, li);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
 	return dfp;
 }
 
+/*
+ * Add a defer ops barrier to force two otherwise adjacent deferred work items
+ * to be tracked separately and have separate log items.
+ */
+void
+xfs_defer_add_barrier(
+	struct xfs_trans		*tp)
+{
+	struct xfs_defer_pending	*dfp;
+	const enum xfs_defer_ops_type	type = XFS_DEFER_OPS_TYPE_BARRIER;
+	const struct xfs_defer_op_type	*ops = defer_op_types[type];
+
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+
+	/* If the last defer op added was a barrier, we're done. */
+	dfp = xfs_defer_find_last(tp, type, ops);
+	if (dfp)
+		return;
+
+	xfs_defer_alloc(tp, type);
+
+	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
+}
+
 /*
  * Create a pending deferred work item to replay the recovered intent item
  * and add it to the list.
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index b0284154f..5b1990ef3 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -20,6 +20,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
 	XFS_DEFER_OPS_TYPE_ATTR,
+	XFS_DEFER_OPS_TYPE_BARRIER,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
@@ -163,4 +164,6 @@ xfs_defer_add_item(
 int __init xfs_defer_init_item_caches(void);
 void xfs_defer_destroy_item_caches(void);
 
+void xfs_defer_add_barrier(struct xfs_trans *tp);
+
 #endif /* __XFS_DEFER_H__ */


