Return-Path: <linux-xfs+bounces-10895-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E883940215
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 02:25:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C6F971F22CF8
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 00:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A83124A21;
	Tue, 30 Jul 2024 00:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oo5DnNtS"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9A74A11
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299121; cv=none; b=j6yrCyzKBoS/A1kDc+ktLh5f3sVHO6pp9wWjXruP6mXvvwalJdVA6k3VZybYeiJUSBjxtBqQvrg2gBlUdYrVHvjVula9izO9OB6y7yQP+1x0OGnsUYkeIKmCmoBSw0WljffLKF8/8lm+2E2L6K9gwHo1Rx21RK7eoqrkgdC/hpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299121; c=relaxed/simple;
	bh=2VHZjoBWOfhQ0urk5VYCnQ2xjkjfJSpRkxB+F2Ib/jc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MEhGyB0oT7MMKkvIj9bJom/B5KAOZ7yeAXAelYAhMBNMoBjfSGHACArkbspkBiRlN3EAz+MC+4OEJN9MF6By6qNxvXZbZ44MtjbN9xoyAnPPThsnf+UAsR2IpxL5NkTFrkTScDfIq9Zij/tB2ywlinc3gxXeCKSuX8MSakEPKrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oo5DnNtS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3C5C32786;
	Tue, 30 Jul 2024 00:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299120;
	bh=2VHZjoBWOfhQ0urk5VYCnQ2xjkjfJSpRkxB+F2Ib/jc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Oo5DnNtSeXu6/ykoAW9AABXFvKTVc9DId8Ex5UgStY2FQg7PYOpCDuN/rQQvhTL9n
	 oDC+DrVWzpTnB84JUGjWFYHfXvK70GcPXbjY53oi1A5Zqhq679F36ue0o1r9gdMUev
	 FgKLMKPdCUFinawA2gLU4XwBGaoWxNEE+H+kAJG/h61fRvpFlKHhYp+ms4HX91ogoB
	 /ltfe4IIe1L2f/ToJAohqp2E2sp0MHXpoD8aFqOQdYSCB2OGW1QTSZxsYYF3SFKpCr
	 FEODuL0RXcpqz4gJzJ3QAQgXVSKmkeIMOQa6lp7h0IRg8h1NY3S3Fvi1rdiUtwqVU8
	 ZHFJAOFU7V1qA==
Date: Mon, 29 Jul 2024 17:25:20 -0700
Subject: [PATCH 006/115] xfs: create deferred log items for file mapping
 exchanges
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842526.1338752.8516972356571696255.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 966ceafc7a437105ecfe1cadb3747b2965a260ca

Now that we've created the skeleton of a log intent item to track and
restart file mapping exchange operations, add the upper level logic to
log.  This builds on the existing bmap update intent items that have
been around for a while now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trace.h      |   14 +
 libxfs/Makefile          |    2 
 libxfs/defer_item.c      |   88 ++++
 libxfs/defer_item.h      |    5 
 libxfs/libxfs_priv.h     |   30 +
 libxfs/xfs_defer.c       |    6 
 libxfs/xfs_defer.h       |    2 
 libxfs/xfs_exchmaps.c    | 1042 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_exchmaps.h    |  118 +++++
 libxfs/xfs_log_format.h  |   24 +
 libxfs/xfs_trans_space.h |    4 
 11 files changed, 1333 insertions(+), 2 deletions(-)
 create mode 100644 libxfs/xfs_exchmaps.c
 create mode 100644 libxfs/xfs_exchmaps.h


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 6b9d3358a..2e5e89d65 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -329,6 +329,9 @@
 #define trace_xfs_refcount_cow_decrease(...)	((void) 0)
 #define trace_xfs_refcount_recover_extent(...)	((void) 0)
 
+#define trace_xfs_reflink_set_inode_flag(...)	((void) 0)
+#define trace_xfs_reflink_unset_inode_flag(...)	((void) 0)
+
 #define trace_xfs_rmap_find_left_neighbor_candidate(...)	((void) 0)
 #define trace_xfs_rmap_find_left_neighbor_query(...)	((void) 0)
 #define trace_xfs_rmap_find_left_neighbor_result(...)	((void) 0)
@@ -342,6 +345,17 @@
 #define trace_xfs_rmap_map_error(...)		((void) 0)
 #define trace_xfs_rmap_delete_error(...)	((void) 0)
 
+#define trace_xfs_exchmaps_defer(...)		((void) 0)
+#define trace_xfs_exchmaps_delta_nextents(...)	((void) 0)
+#define trace_xfs_exchmaps_delta_nextents_step(...) ((void) 0)
+#define trace_xfs_exchmaps_mapping1_skip(...)	((void) 0)
+#define trace_xfs_exchmaps_mapping1(...)	((void) 0)
+#define trace_xfs_exchmaps_mapping2(...)	((void) 0)
+#define trace_xfs_exchmaps_final_estimate(...)	((void) 0)
+#define trace_xfs_exchmaps_initial_estimate(...) ((void) 0)
+#define trace_xfs_exchmaps_overhead(...)	((void) 0)
+#define trace_xfs_exchmaps_update_inode_size(...) ((void) 0)
+
 #define trace_xfs_fs_mark_healthy(a,b)		((void) 0)
 
 #define trace_xlog_intent_recovery_failed(...)	((void) 0)
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 1c88dbc2a..e3fa18fee 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -45,6 +45,7 @@ HFILES = \
 	xfs_da_btree.h \
 	xfs_dir2.h \
 	xfs_errortag.h \
+	xfs_exchmaps.h \
 	xfs_ialloc.h \
 	xfs_ialloc_btree.h \
 	xfs_inode_buf.h \
@@ -94,6 +95,7 @@ CFILES = buf_mem.c \
 	xfs_dir2_node.c \
 	xfs_dir2_sf.c \
 	xfs_dquot_buf.c \
+	xfs_exchmaps.c \
 	xfs_ialloc.c \
 	xfs_iext_tree.c \
 	xfs_inode_buf.c \
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 21dd1d0f4..fd329e77c 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -25,6 +25,8 @@
 #include "xfs_attr.h"
 #include "libxfs.h"
 #include "defer_item.h"
+#include "xfs_ag.h"
+#include "xfs_exchmaps.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -677,3 +679,89 @@ const struct xfs_defer_op_type xfs_attr_defer_type = {
 	.finish_item	= xfs_attr_finish_item,
 	.cancel_item	= xfs_attr_cancel_item,
 };
+
+/* File Mapping Exchanges */
+
+STATIC struct xfs_log_item *
+xfs_exchmaps_create_intent(
+	struct xfs_trans		*tp,
+	struct list_head		*items,
+	unsigned int			count,
+	bool				sort)
+{
+	return NULL;
+}
+STATIC struct xfs_log_item *
+xfs_exchmaps_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*intent,
+	unsigned int			count)
+{
+	return NULL;
+}
+
+/* Add this deferred XMI to the transaction. */
+void
+xfs_exchmaps_defer_add(
+	struct xfs_trans		*tp,
+	struct xfs_exchmaps_intent	*xmi)
+{
+	trace_xfs_exchmaps_defer(tp->t_mountp, xmi);
+
+	xfs_defer_add(tp, &xmi->xmi_list, &xfs_exchmaps_defer_type);
+}
+
+static inline struct xfs_exchmaps_intent *xmi_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_exchmaps_intent, xmi_list);
+}
+
+/* Process a deferred swapext update. */
+STATIC int
+xfs_exchmaps_finish_item(
+	struct xfs_trans		*tp,
+	struct xfs_log_item		*done,
+	struct list_head		*item,
+	struct xfs_btree_cur		**state)
+{
+	struct xfs_exchmaps_intent	*xmi = xmi_entry(item);
+	int				error;
+
+	/*
+	 * Exchange one more extent between the two files.  If there's still
+	 * more work to do, we want to requeue ourselves after all other
+	 * pending deferred operations have finished.  This includes all of the
+	 * dfops that we queued directly as well as any new ones created in the
+	 * process of finishing the others.
+	 */
+	error = xfs_exchmaps_finish_one(tp, xmi);
+	if (error != -EAGAIN)
+		kmem_cache_free(xfs_exchmaps_intent_cache, xmi);
+	return error;
+}
+
+/* Abort all pending XMIs. */
+STATIC void
+xfs_exchmaps_abort_intent(
+	struct xfs_log_item		*intent)
+{
+}
+
+/* Cancel a deferred swapext update. */
+STATIC void
+xfs_exchmaps_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_exchmaps_intent	*xmi = xmi_entry(item);
+
+	kmem_cache_free(xfs_exchmaps_intent_cache, xmi);
+}
+
+const struct xfs_defer_op_type xfs_exchmaps_defer_type = {
+	.name		= "exchmaps",
+	.create_intent	= xfs_exchmaps_create_intent,
+	.abort_intent	= xfs_exchmaps_abort_intent,
+	.create_done	= xfs_exchmaps_create_done,
+	.finish_item	= xfs_exchmaps_finish_item,
+	.cancel_item	= xfs_exchmaps_cancel_item,
+};
diff --git a/libxfs/defer_item.h b/libxfs/defer_item.h
index 6d3abf158..a5a07867c 100644
--- a/libxfs/defer_item.h
+++ b/libxfs/defer_item.h
@@ -10,4 +10,9 @@ struct xfs_bmap_intent;
 
 void xfs_bmap_defer_add(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
 
+struct xfs_exchmaps_intent;
+
+void xfs_exchmaps_defer_add(struct xfs_trans *tp,
+		struct xfs_exchmaps_intent *xmi);
+
 #endif /* __LIBXFS_DEFER_ITEM_H_ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 81f641f32..9ddba767b 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -219,6 +219,35 @@ static inline bool WARN_ON(bool expr) {
 	(inode)->i_version = (version);	\
 } while (0)
 
+#define __must_check	__attribute__((__warn_unused_result__))
+
+/*
+ * Allows for effectively applying __must_check to a macro so we can have
+ * both the type-agnostic benefits of the macros while also being able to
+ * enforce that the return value is, in fact, checked.
+ */
+static inline bool __must_check __must_check_overflow(bool overflow)
+{
+	return unlikely(overflow);
+}
+
+/*
+ * For simplicity and code hygiene, the fallback code below insists on
+ * a, b and *d having the same type (similar to the min() and max()
+ * macros), whereas gcc's type-generic overflow checkers accept
+ * different types. Hence we don't just make check_add_overflow an
+ * alias for __builtin_add_overflow, but add type checks similar to
+ * below.
+ */
+#define check_add_overflow(a, b, d) __must_check_overflow(({	\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	__builtin_add_overflow(__a, __b, __d);	\
+}))
+
 #define min_t(type,x,y) \
 	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
 #define max_t(type,x,y) \
@@ -541,6 +570,7 @@ void xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *lip, int type,
 #define xfs_log_in_recovery(mp)		(false)
 
 /* xfs_icache.c */
+#define xfs_inode_clear_cowblocks_tag(ip)	do { } while (0)
 #define xfs_inode_set_cowblocks_tag(ip)	do { } while (0)
 #define xfs_inode_set_eofblocks_tag(ip)	do { } while (0)
 
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index b80ac04ab..3a91bb3a5 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -21,6 +21,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
+#include "xfs_exchmaps.h"
 
 static struct kmem_cache	*xfs_defer_pending_cache;
 
@@ -1170,6 +1171,10 @@ xfs_defer_init_item_caches(void)
 	error = xfs_attr_intent_init_cache();
 	if (error)
 		goto err;
+	error = xfs_exchmaps_intent_init_cache();
+	if (error)
+		goto err;
+
 	return 0;
 err:
 	xfs_defer_destroy_item_caches();
@@ -1180,6 +1185,7 @@ xfs_defer_init_item_caches(void)
 void
 xfs_defer_destroy_item_caches(void)
 {
+	xfs_exchmaps_intent_destroy_cache();
 	xfs_attr_intent_destroy_cache();
 	xfs_extfree_intent_destroy_cache();
 	xfs_bmap_intent_destroy_cache();
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 18a9fb92d..81cca60d7 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -72,7 +72,7 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 extern const struct xfs_defer_op_type xfs_attr_defer_type;
-
+extern const struct xfs_defer_op_type xfs_exchmaps_defer_type;
 
 /*
  * Deferred operation item relogging limits.
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
new file mode 100644
index 000000000..b2c35032d
--- /dev/null
+++ b/libxfs/xfs_exchmaps.c
@@ -0,0 +1,1042 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_bmap.h"
+#include "xfs_exchmaps.h"
+#include "xfs_trace.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_errortag.h"
+#include "xfs_health.h"
+#include "defer_item.h"
+
+struct kmem_cache	*xfs_exchmaps_intent_cache;
+
+/* bmbt mappings adjacent to a pair of records. */
+struct xfs_exchmaps_adjacent {
+	struct xfs_bmbt_irec		left1;
+	struct xfs_bmbt_irec		right1;
+	struct xfs_bmbt_irec		left2;
+	struct xfs_bmbt_irec		right2;
+};
+
+#define ADJACENT_INIT { \
+	.left1  = { .br_startblock = HOLESTARTBLOCK }, \
+	.right1 = { .br_startblock = HOLESTARTBLOCK }, \
+	.left2  = { .br_startblock = HOLESTARTBLOCK }, \
+	.right2 = { .br_startblock = HOLESTARTBLOCK }, \
+}
+
+/* Information to reset reflink flag / CoW fork state after an exchange. */
+
+/*
+ * If the reflink flag is set on either inode, make sure it has an incore CoW
+ * fork, since all reflink inodes must have them.  If there's a CoW fork and it
+ * has mappings in it, make sure the inodes are tagged appropriately so that
+ * speculative preallocations can be GC'd if we run low of space.
+ */
+static inline void
+xfs_exchmaps_ensure_cowfork(
+	struct xfs_inode	*ip)
+{
+	struct xfs_ifork	*cfork;
+
+	if (xfs_is_reflink_inode(ip))
+		xfs_ifork_init_cow(ip);
+
+	cfork = xfs_ifork_ptr(ip, XFS_COW_FORK);
+	if (!cfork)
+		return;
+	if (cfork->if_bytes > 0)
+		xfs_inode_set_cowblocks_tag(ip);
+	else
+		xfs_inode_clear_cowblocks_tag(ip);
+}
+
+/*
+ * Adjust the on-disk inode size upwards if needed so that we never add
+ * mappings into the file past EOF.  This is crucial so that log recovery won't
+ * get confused by the sudden appearance of post-eof mappings.
+ */
+STATIC void
+xfs_exchmaps_update_size(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*imap,
+	xfs_fsize_t		new_isize)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_fsize_t		len;
+
+	if (new_isize < 0)
+		return;
+
+	len = min(XFS_FSB_TO_B(mp, imap->br_startoff + imap->br_blockcount),
+		  new_isize);
+
+	if (len <= ip->i_disk_size)
+		return;
+
+	trace_xfs_exchmaps_update_inode_size(ip, len);
+
+	ip->i_disk_size = len;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
+/* Advance the incore state tracking after exchanging a mapping. */
+static inline void
+xmi_advance(
+	struct xfs_exchmaps_intent	*xmi,
+	const struct xfs_bmbt_irec	*irec)
+{
+	xmi->xmi_startoff1 += irec->br_blockcount;
+	xmi->xmi_startoff2 += irec->br_blockcount;
+	xmi->xmi_blockcount -= irec->br_blockcount;
+}
+
+/* Do we still have more mappings to exchange? */
+static inline bool
+xmi_has_more_exchange_work(const struct xfs_exchmaps_intent *xmi)
+{
+	return xmi->xmi_blockcount > 0;
+}
+
+/* Do we have post-operation cleanups to perform? */
+static inline bool
+xmi_has_postop_work(const struct xfs_exchmaps_intent *xmi)
+{
+	return xmi->xmi_flags & (XFS_EXCHMAPS_CLEAR_INO1_REFLINK |
+				 XFS_EXCHMAPS_CLEAR_INO2_REFLINK);
+}
+
+/* Check all mappings to make sure we can actually exchange them. */
+int
+xfs_exchmaps_check_forks(
+	struct xfs_mount		*mp,
+	const struct xfs_exchmaps_req	*req)
+{
+	struct xfs_ifork		*ifp1, *ifp2;
+	int				whichfork = xfs_exchmaps_reqfork(req);
+
+	/* No fork? */
+	ifp1 = xfs_ifork_ptr(req->ip1, whichfork);
+	ifp2 = xfs_ifork_ptr(req->ip2, whichfork);
+	if (!ifp1 || !ifp2)
+		return -EINVAL;
+
+	/* We don't know how to exchange local format forks. */
+	if (ifp1->if_format == XFS_DINODE_FMT_LOCAL ||
+	    ifp2->if_format == XFS_DINODE_FMT_LOCAL)
+		return -EINVAL;
+
+	/* We don't support realtime data forks yet. */
+	if (!XFS_IS_REALTIME_INODE(req->ip1))
+		return 0;
+	if (whichfork == XFS_ATTR_FORK)
+		return 0;
+	return -EINVAL;
+}
+
+#ifdef CONFIG_XFS_QUOTA
+/* Log the actual updates to the quota accounting. */
+static inline void
+xfs_exchmaps_update_quota(
+	struct xfs_trans		*tp,
+	struct xfs_exchmaps_intent	*xmi,
+	struct xfs_bmbt_irec		*irec1,
+	struct xfs_bmbt_irec		*irec2)
+{
+	int64_t				ip1_delta = 0, ip2_delta = 0;
+	unsigned int			qflag;
+
+	qflag = XFS_IS_REALTIME_INODE(xmi->xmi_ip1) ? XFS_TRANS_DQ_RTBCOUNT :
+						      XFS_TRANS_DQ_BCOUNT;
+
+	if (xfs_bmap_is_real_extent(irec1)) {
+		ip1_delta -= irec1->br_blockcount;
+		ip2_delta += irec1->br_blockcount;
+	}
+
+	if (xfs_bmap_is_real_extent(irec2)) {
+		ip1_delta += irec2->br_blockcount;
+		ip2_delta -= irec2->br_blockcount;
+	}
+
+	xfs_trans_mod_dquot_byino(tp, xmi->xmi_ip1, qflag, ip1_delta);
+	xfs_trans_mod_dquot_byino(tp, xmi->xmi_ip2, qflag, ip2_delta);
+}
+#else
+# define xfs_exchmaps_update_quota(tp, xmi, irec1, irec2)	((void)0)
+#endif
+
+/* Decide if we want to skip this mapping from file1. */
+static inline bool
+xfs_exchmaps_can_skip_mapping(
+	struct xfs_exchmaps_intent	*xmi,
+	struct xfs_bmbt_irec		*irec)
+{
+	/* Do not skip this mapping if the caller did not tell us to. */
+	if (!(xmi->xmi_flags & XFS_EXCHMAPS_INO1_WRITTEN))
+		return false;
+
+	/* Do not skip mapped, written mappings. */
+	if (xfs_bmap_is_written_extent(irec))
+		return false;
+
+	/*
+	 * The mapping is unwritten or a hole.  It cannot be a delalloc
+	 * reservation because we already excluded those.  It cannot be an
+	 * unwritten mapping with dirty page cache because we flushed the page
+	 * cache.  We don't support realtime files yet, so we needn't (yet)
+	 * deal with them.
+	 */
+	return true;
+}
+
+/*
+ * Walk forward through the file ranges in @xmi until we find two different
+ * mappings to exchange.  If there is work to do, return the mappings;
+ * otherwise we've reached the end of the range and xmi_blockcount will be
+ * zero.
+ *
+ * If the walk skips over a pair of mappings to the same storage, save them as
+ * the left records in @adj (if provided) so that the simulation phase can
+ * avoid an extra lookup.
+  */
+static int
+xfs_exchmaps_find_mappings(
+	struct xfs_exchmaps_intent	*xmi,
+	struct xfs_bmbt_irec		*irec1,
+	struct xfs_bmbt_irec		*irec2,
+	struct xfs_exchmaps_adjacent	*adj)
+{
+	int				nimaps;
+	int				bmap_flags;
+	int				error;
+
+	bmap_flags = xfs_bmapi_aflag(xfs_exchmaps_whichfork(xmi));
+
+	for (; xmi_has_more_exchange_work(xmi); xmi_advance(xmi, irec1)) {
+		/* Read mapping from the first file */
+		nimaps = 1;
+		error = xfs_bmapi_read(xmi->xmi_ip1, xmi->xmi_startoff1,
+				xmi->xmi_blockcount, irec1, &nimaps,
+				bmap_flags);
+		if (error)
+			return error;
+		if (nimaps != 1 ||
+		    irec1->br_startblock == DELAYSTARTBLOCK ||
+		    irec1->br_startoff != xmi->xmi_startoff1) {
+			/*
+			 * We should never get no mapping or a delalloc mapping
+			 * or something that doesn't match what we asked for,
+			 * since the caller flushed both inodes and we hold the
+			 * ILOCKs for both inodes.
+			 */
+			ASSERT(0);
+			return -EINVAL;
+		}
+
+		if (xfs_exchmaps_can_skip_mapping(xmi, irec1)) {
+			trace_xfs_exchmaps_mapping1_skip(xmi->xmi_ip1, irec1);
+			continue;
+		}
+
+		/* Read mapping from the second file */
+		nimaps = 1;
+		error = xfs_bmapi_read(xmi->xmi_ip2, xmi->xmi_startoff2,
+				irec1->br_blockcount, irec2, &nimaps,
+				bmap_flags);
+		if (error)
+			return error;
+		if (nimaps != 1 ||
+		    irec2->br_startblock == DELAYSTARTBLOCK ||
+		    irec2->br_startoff != xmi->xmi_startoff2) {
+			/*
+			 * We should never get no mapping or a delalloc mapping
+			 * or something that doesn't match what we asked for,
+			 * since the caller flushed both inodes and we hold the
+			 * ILOCKs for both inodes.
+			 */
+			ASSERT(0);
+			return -EINVAL;
+		}
+
+		/*
+		 * We can only exchange as many blocks as the smaller of the
+		 * two mapping maps.
+		 */
+		irec1->br_blockcount = min(irec1->br_blockcount,
+					   irec2->br_blockcount);
+
+		trace_xfs_exchmaps_mapping1(xmi->xmi_ip1, irec1);
+		trace_xfs_exchmaps_mapping2(xmi->xmi_ip2, irec2);
+
+		/* We found something to exchange, so return it. */
+		if (irec1->br_startblock != irec2->br_startblock)
+			return 0;
+
+		/*
+		 * Two mappings pointing to the same physical block must not
+		 * have different states; that's filesystem corruption.  Move
+		 * on to the next mapping if they're both holes or both point
+		 * to the same physical space extent.
+		 */
+		if (irec1->br_state != irec2->br_state) {
+			xfs_bmap_mark_sick(xmi->xmi_ip1,
+					xfs_exchmaps_whichfork(xmi));
+			xfs_bmap_mark_sick(xmi->xmi_ip2,
+					xfs_exchmaps_whichfork(xmi));
+			return -EFSCORRUPTED;
+		}
+
+		/*
+		 * Save the mappings if we're estimating work and skipping
+		 * these identical mappings.
+		 */
+		if (adj) {
+			memcpy(&adj->left1, irec1, sizeof(*irec1));
+			memcpy(&adj->left2, irec2, sizeof(*irec2));
+		}
+	}
+
+	return 0;
+}
+
+/* Exchange these two mappings. */
+static void
+xfs_exchmaps_one_step(
+	struct xfs_trans		*tp,
+	struct xfs_exchmaps_intent	*xmi,
+	struct xfs_bmbt_irec		*irec1,
+	struct xfs_bmbt_irec		*irec2)
+{
+	int				whichfork = xfs_exchmaps_whichfork(xmi);
+
+	xfs_exchmaps_update_quota(tp, xmi, irec1, irec2);
+
+	/* Remove both mappings. */
+	xfs_bmap_unmap_extent(tp, xmi->xmi_ip1, whichfork, irec1);
+	xfs_bmap_unmap_extent(tp, xmi->xmi_ip2, whichfork, irec2);
+
+	/*
+	 * Re-add both mappings.  We exchange the file offsets between the two
+	 * maps and add the opposite map, which has the effect of filling the
+	 * logical offsets we just unmapped, but with with the physical mapping
+	 * information exchanged.
+	 */
+	swap(irec1->br_startoff, irec2->br_startoff);
+	xfs_bmap_map_extent(tp, xmi->xmi_ip1, whichfork, irec2);
+	xfs_bmap_map_extent(tp, xmi->xmi_ip2, whichfork, irec1);
+
+	/* Make sure we're not adding mappings past EOF. */
+	if (whichfork == XFS_DATA_FORK) {
+		xfs_exchmaps_update_size(tp, xmi->xmi_ip1, irec2,
+				xmi->xmi_isize1);
+		xfs_exchmaps_update_size(tp, xmi->xmi_ip2, irec1,
+				xmi->xmi_isize2);
+	}
+
+	/*
+	 * Advance our cursor and exit.   The caller (either defer ops or log
+	 * recovery) will log the XMD item, and if *blockcount is nonzero, it
+	 * will log a new XMI item for the remainder and call us back.
+	 */
+	xmi_advance(xmi, irec1);
+}
+
+/* Clear the reflink flag after an exchange. */
+static inline void
+xfs_exchmaps_clear_reflink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	trace_xfs_reflink_unset_inode_flag(ip);
+
+	ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
+/* Finish whatever work might come after an exchange operation. */
+static int
+xfs_exchmaps_do_postop_work(
+	struct xfs_trans		*tp,
+	struct xfs_exchmaps_intent	*xmi)
+{
+	if (xmi->xmi_flags & XFS_EXCHMAPS_CLEAR_INO1_REFLINK) {
+		xfs_exchmaps_clear_reflink(tp, xmi->xmi_ip1);
+		xmi->xmi_flags &= ~XFS_EXCHMAPS_CLEAR_INO1_REFLINK;
+	}
+
+	if (xmi->xmi_flags & XFS_EXCHMAPS_CLEAR_INO2_REFLINK) {
+		xfs_exchmaps_clear_reflink(tp, xmi->xmi_ip2);
+		xmi->xmi_flags &= ~XFS_EXCHMAPS_CLEAR_INO2_REFLINK;
+	}
+
+	return 0;
+}
+
+/* Finish one step in a mapping exchange operation, possibly relogging. */
+int
+xfs_exchmaps_finish_one(
+	struct xfs_trans		*tp,
+	struct xfs_exchmaps_intent	*xmi)
+{
+	struct xfs_bmbt_irec		irec1, irec2;
+	int				error;
+
+	if (xmi_has_more_exchange_work(xmi)) {
+		/*
+		 * If the operation state says that some range of the files
+		 * have not yet been exchanged, look for mappings in that range
+		 * to exchange.  If we find some mappings, exchange them.
+		 */
+		error = xfs_exchmaps_find_mappings(xmi, &irec1, &irec2, NULL);
+		if (error)
+			return error;
+
+		if (xmi_has_more_exchange_work(xmi))
+			xfs_exchmaps_one_step(tp, xmi, &irec1, &irec2);
+
+		/*
+		 * If the caller asked us to exchange the file sizes after the
+		 * exchange and either we just exchanged the last mappings in
+		 * the range or we didn't find anything to exchange, update the
+		 * ondisk file sizes.
+		 */
+		if ((xmi->xmi_flags & XFS_EXCHMAPS_SET_SIZES) &&
+		    !xmi_has_more_exchange_work(xmi)) {
+			xmi->xmi_ip1->i_disk_size = xmi->xmi_isize1;
+			xmi->xmi_ip2->i_disk_size = xmi->xmi_isize2;
+
+			xfs_trans_log_inode(tp, xmi->xmi_ip1, XFS_ILOG_CORE);
+			xfs_trans_log_inode(tp, xmi->xmi_ip2, XFS_ILOG_CORE);
+		}
+	} else if (xmi_has_postop_work(xmi)) {
+		/*
+		 * Now that we're finished with the exchange operation,
+		 * complete the post-op cleanup work.
+		 */
+		error = xfs_exchmaps_do_postop_work(tp, xmi);
+		if (error)
+			return error;
+	}
+
+	/* If we still have work to do, ask for a new transaction. */
+	if (xmi_has_more_exchange_work(xmi) || xmi_has_postop_work(xmi)) {
+		trace_xfs_exchmaps_defer(tp->t_mountp, xmi);
+		return -EAGAIN;
+	}
+
+	/*
+	 * If we reach here, we've finished all the exchange work and the post
+	 * operation work.  The last thing we need to do before returning to
+	 * the caller is to make sure that COW forks are set up correctly.
+	 */
+	if (!(xmi->xmi_flags & XFS_EXCHMAPS_ATTR_FORK)) {
+		xfs_exchmaps_ensure_cowfork(xmi->xmi_ip1);
+		xfs_exchmaps_ensure_cowfork(xmi->xmi_ip2);
+	}
+
+	return 0;
+}
+
+/*
+ * Compute the amount of bmbt blocks we should reserve for each file.  In the
+ * worst case, each exchange will fill a hole with a new mapping, which could
+ * result in a btree split every time we add a new leaf block.
+ */
+static inline uint64_t
+xfs_exchmaps_bmbt_blocks(
+	struct xfs_mount		*mp,
+	const struct xfs_exchmaps_req	*req)
+{
+	return howmany_64(req->nr_exchanges,
+					XFS_MAX_CONTIG_BMAPS_PER_BLOCK(mp)) *
+			XFS_EXTENTADD_SPACE_RES(mp, xfs_exchmaps_reqfork(req));
+}
+
+/* Compute the space we should reserve for the rmap btree expansions. */
+static inline uint64_t
+xfs_exchmaps_rmapbt_blocks(
+	struct xfs_mount		*mp,
+	const struct xfs_exchmaps_req	*req)
+{
+	if (!xfs_has_rmapbt(mp))
+		return 0;
+	if (XFS_IS_REALTIME_INODE(req->ip1))
+		return 0;
+
+	return howmany_64(req->nr_exchanges,
+					XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)) *
+			XFS_RMAPADD_SPACE_RES(mp);
+}
+
+/* Estimate the bmbt and rmapbt overhead required to exchange mappings. */
+static int
+xfs_exchmaps_estimate_overhead(
+	struct xfs_exchmaps_req		*req)
+{
+	struct xfs_mount		*mp = req->ip1->i_mount;
+	xfs_filblks_t			bmbt_blocks;
+	xfs_filblks_t			rmapbt_blocks;
+	xfs_filblks_t			resblks = req->resblks;
+
+	/*
+	 * Compute the number of bmbt and rmapbt blocks we might need to handle
+	 * the estimated number of exchanges.
+	 */
+	bmbt_blocks = xfs_exchmaps_bmbt_blocks(mp, req);
+	rmapbt_blocks = xfs_exchmaps_rmapbt_blocks(mp, req);
+
+	trace_xfs_exchmaps_overhead(mp, bmbt_blocks, rmapbt_blocks);
+
+	/* Make sure the change in file block count doesn't overflow. */
+	if (check_add_overflow(req->ip1_bcount, bmbt_blocks, &req->ip1_bcount))
+		return -EFBIG;
+	if (check_add_overflow(req->ip2_bcount, bmbt_blocks, &req->ip2_bcount))
+		return -EFBIG;
+
+	/*
+	 * Add together the number of blocks we need to handle btree growth,
+	 * then add it to the number of blocks we need to reserve to this
+	 * transaction.
+	 */
+	if (check_add_overflow(resblks, bmbt_blocks, &resblks))
+		return -ENOSPC;
+	if (check_add_overflow(resblks, bmbt_blocks, &resblks))
+		return -ENOSPC;
+	if (check_add_overflow(resblks, rmapbt_blocks, &resblks))
+		return -ENOSPC;
+	if (check_add_overflow(resblks, rmapbt_blocks, &resblks))
+		return -ENOSPC;
+
+	/* Can't actually reserve more than UINT_MAX blocks. */
+	if (req->resblks > UINT_MAX)
+		return -ENOSPC;
+
+	req->resblks = resblks;
+	trace_xfs_exchmaps_final_estimate(req);
+	return 0;
+}
+
+/* Decide if we can merge two real mappings. */
+static inline bool
+xmi_can_merge(
+	const struct xfs_bmbt_irec	*b1,
+	const struct xfs_bmbt_irec	*b2)
+{
+	/* Don't merge holes. */
+	if (b1->br_startblock == HOLESTARTBLOCK ||
+	    b2->br_startblock == HOLESTARTBLOCK)
+		return false;
+
+	/* We don't merge holes. */
+	if (!xfs_bmap_is_real_extent(b1) || !xfs_bmap_is_real_extent(b2))
+		return false;
+
+	if (b1->br_startoff   + b1->br_blockcount == b2->br_startoff &&
+	    b1->br_startblock + b1->br_blockcount == b2->br_startblock &&
+	    b1->br_state			  == b2->br_state &&
+	    b1->br_blockcount + b2->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
+		return true;
+
+	return false;
+}
+
+/*
+ * Decide if we can merge three mappings.  Caller must ensure all three
+ * mappings must not be holes or delalloc reservations.
+ */
+static inline bool
+xmi_can_merge_all(
+	const struct xfs_bmbt_irec	*l,
+	const struct xfs_bmbt_irec	*m,
+	const struct xfs_bmbt_irec	*r)
+{
+	xfs_filblks_t			new_len;
+
+	new_len = l->br_blockcount + m->br_blockcount + r->br_blockcount;
+	return new_len <= XFS_MAX_BMBT_EXTLEN;
+}
+
+#define CLEFT_CONTIG	0x01
+#define CRIGHT_CONTIG	0x02
+#define CHOLE		0x04
+#define CBOTH_CONTIG	(CLEFT_CONTIG | CRIGHT_CONTIG)
+
+#define NLEFT_CONTIG	0x10
+#define NRIGHT_CONTIG	0x20
+#define NHOLE		0x40
+#define NBOTH_CONTIG	(NLEFT_CONTIG | NRIGHT_CONTIG)
+
+/* Estimate the effect of a single exchange on mapping count. */
+static inline int
+xmi_delta_nextents_step(
+	struct xfs_mount		*mp,
+	const struct xfs_bmbt_irec	*left,
+	const struct xfs_bmbt_irec	*curr,
+	const struct xfs_bmbt_irec	*new,
+	const struct xfs_bmbt_irec	*right)
+{
+	bool				lhole, rhole, chole, nhole;
+	unsigned int			state = 0;
+	int				ret = 0;
+
+	lhole = left->br_startblock == HOLESTARTBLOCK;
+	rhole = right->br_startblock == HOLESTARTBLOCK;
+	chole = curr->br_startblock == HOLESTARTBLOCK;
+	nhole = new->br_startblock == HOLESTARTBLOCK;
+
+	if (chole)
+		state |= CHOLE;
+	if (!lhole && !chole && xmi_can_merge(left, curr))
+		state |= CLEFT_CONTIG;
+	if (!rhole && !chole && xmi_can_merge(curr, right))
+		state |= CRIGHT_CONTIG;
+	if ((state & CBOTH_CONTIG) == CBOTH_CONTIG &&
+	    !xmi_can_merge_all(left, curr, right))
+		state &= ~CRIGHT_CONTIG;
+
+	if (nhole)
+		state |= NHOLE;
+	if (!lhole && !nhole && xmi_can_merge(left, new))
+		state |= NLEFT_CONTIG;
+	if (!rhole && !nhole && xmi_can_merge(new, right))
+		state |= NRIGHT_CONTIG;
+	if ((state & NBOTH_CONTIG) == NBOTH_CONTIG &&
+	    !xmi_can_merge_all(left, new, right))
+		state &= ~NRIGHT_CONTIG;
+
+	switch (state & (CLEFT_CONTIG | CRIGHT_CONTIG | CHOLE)) {
+	case CLEFT_CONTIG | CRIGHT_CONTIG:
+		/*
+		 * left/curr/right are the same mapping, so deleting curr
+		 * causes 2 new mappings to be created.
+		 */
+		ret += 2;
+		break;
+	case 0:
+		/*
+		 * curr is not contiguous with any mapping, so we remove curr
+		 * completely
+		 */
+		ret--;
+		break;
+	case CHOLE:
+		/* hole, do nothing */
+		break;
+	case CLEFT_CONTIG:
+	case CRIGHT_CONTIG:
+		/* trim either left or right, no change */
+		break;
+	}
+
+	switch (state & (NLEFT_CONTIG | NRIGHT_CONTIG | NHOLE)) {
+	case NLEFT_CONTIG | NRIGHT_CONTIG:
+		/*
+		 * left/curr/right will become the same mapping, so adding
+		 * curr causes the deletion of right.
+		 */
+		ret--;
+		break;
+	case 0:
+		/* new is not contiguous with any mapping */
+		ret++;
+		break;
+	case NHOLE:
+		/* hole, do nothing. */
+		break;
+	case NLEFT_CONTIG:
+	case NRIGHT_CONTIG:
+		/* new is absorbed into left or right, no change */
+		break;
+	}
+
+	trace_xfs_exchmaps_delta_nextents_step(mp, left, curr, new, right, ret,
+			state);
+	return ret;
+}
+
+/* Make sure we don't overflow the extent (mapping) counters. */
+static inline int
+xmi_ensure_delta_nextents(
+	struct xfs_exchmaps_req	*req,
+	struct xfs_inode	*ip,
+	int64_t			delta)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	int			whichfork = xfs_exchmaps_reqfork(req);
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+	uint64_t		new_nextents;
+	xfs_extnum_t		max_nextents;
+
+	if (delta < 0)
+		return 0;
+
+	/*
+	 * It's always an error if the delta causes integer overflow.  delta
+	 * needs an explicit cast here to avoid warnings about implicit casts
+	 * coded into the overflow check.
+	 */
+	if (check_add_overflow(ifp->if_nextents, (uint64_t)delta,
+				&new_nextents))
+		return -EFBIG;
+
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) &&
+	    new_nextents > 10)
+		return -EFBIG;
+
+	/*
+	 * We always promote both inodes to have large extent counts if the
+	 * superblock feature is enabled, so we only need to check against the
+	 * theoretical maximum.
+	 */
+	max_nextents = xfs_iext_max_nextents(xfs_has_large_extent_counts(mp),
+					     whichfork);
+	if (new_nextents > max_nextents)
+		return -EFBIG;
+
+	return 0;
+}
+
+/* Find the next mapping after irec. */
+static inline int
+xmi_next(
+	struct xfs_inode		*ip,
+	int				bmap_flags,
+	const struct xfs_bmbt_irec	*irec,
+	struct xfs_bmbt_irec		*nrec)
+{
+	xfs_fileoff_t			off;
+	xfs_filblks_t			blockcount;
+	int				nimaps = 1;
+	int				error;
+
+	off = irec->br_startoff + irec->br_blockcount;
+	blockcount = XFS_MAX_FILEOFF - off;
+	error = xfs_bmapi_read(ip, off, blockcount, nrec, &nimaps, bmap_flags);
+	if (error)
+		return error;
+	if (nrec->br_startblock == DELAYSTARTBLOCK ||
+	    nrec->br_startoff != off) {
+		/*
+		 * If we don't get the mapping we want, return a zero-length
+		 * mapping, which our estimator function will pretend is a hole.
+		 * We shouldn't get delalloc reservations.
+		 */
+		nrec->br_startblock = HOLESTARTBLOCK;
+	}
+
+	return 0;
+}
+
+int __init
+xfs_exchmaps_intent_init_cache(void)
+{
+	xfs_exchmaps_intent_cache = kmem_cache_create("xfs_exchmaps_intent",
+			sizeof(struct xfs_exchmaps_intent),
+			0, 0, NULL);
+
+	return xfs_exchmaps_intent_cache != NULL ? 0 : -ENOMEM;
+}
+
+void
+xfs_exchmaps_intent_destroy_cache(void)
+{
+	kmem_cache_destroy(xfs_exchmaps_intent_cache);
+	xfs_exchmaps_intent_cache = NULL;
+}
+
+/*
+ * Decide if we will exchange the reflink flags between the two files after the
+ * exchange.  The only time we want to do this is if we're exchanging all
+ * mappings under EOF and the inode reflink flags have different states.
+ */
+static inline bool
+xmi_can_exchange_reflink_flags(
+	const struct xfs_exchmaps_req	*req,
+	unsigned int			reflink_state)
+{
+	struct xfs_mount		*mp = req->ip1->i_mount;
+
+	if (hweight32(reflink_state) != 1)
+		return false;
+	if (req->startoff1 != 0 || req->startoff2 != 0)
+		return false;
+	if (req->blockcount != XFS_B_TO_FSB(mp, req->ip1->i_disk_size))
+		return false;
+	if (req->blockcount != XFS_B_TO_FSB(mp, req->ip2->i_disk_size))
+		return false;
+	return true;
+}
+
+
+/* Allocate and initialize a new incore intent item from a request. */
+struct xfs_exchmaps_intent *
+xfs_exchmaps_init_intent(
+	const struct xfs_exchmaps_req	*req)
+{
+	struct xfs_exchmaps_intent	*xmi;
+	unsigned int			rs = 0;
+
+	xmi = kmem_cache_zalloc(xfs_exchmaps_intent_cache,
+			GFP_NOFS | __GFP_NOFAIL);
+	INIT_LIST_HEAD(&xmi->xmi_list);
+	xmi->xmi_ip1 = req->ip1;
+	xmi->xmi_ip2 = req->ip2;
+	xmi->xmi_startoff1 = req->startoff1;
+	xmi->xmi_startoff2 = req->startoff2;
+	xmi->xmi_blockcount = req->blockcount;
+	xmi->xmi_isize1 = xmi->xmi_isize2 = -1;
+	xmi->xmi_flags = req->flags & XFS_EXCHMAPS_PARAMS;
+
+	if (xfs_exchmaps_whichfork(xmi) == XFS_ATTR_FORK)
+		return xmi;
+
+	if (req->flags & XFS_EXCHMAPS_SET_SIZES) {
+		xmi->xmi_flags |= XFS_EXCHMAPS_SET_SIZES;
+		xmi->xmi_isize1 = req->ip2->i_disk_size;
+		xmi->xmi_isize2 = req->ip1->i_disk_size;
+	}
+
+	/* Record the state of each inode's reflink flag before the op. */
+	if (xfs_is_reflink_inode(req->ip1))
+		rs |= 1;
+	if (xfs_is_reflink_inode(req->ip2))
+		rs |= 2;
+
+	/*
+	 * Figure out if we're clearing the reflink flags (which effectively
+	 * exchanges them) after the operation.
+	 */
+	if (xmi_can_exchange_reflink_flags(req, rs)) {
+		if (rs & 1)
+			xmi->xmi_flags |= XFS_EXCHMAPS_CLEAR_INO1_REFLINK;
+		if (rs & 2)
+			xmi->xmi_flags |= XFS_EXCHMAPS_CLEAR_INO2_REFLINK;
+	}
+
+	return xmi;
+}
+
+/*
+ * Estimate the number of exchange operations and the number of file blocks
+ * in each file that will be affected by the exchange operation.
+ */
+int
+xfs_exchmaps_estimate(
+	struct xfs_exchmaps_req		*req)
+{
+	struct xfs_exchmaps_intent	*xmi;
+	struct xfs_bmbt_irec		irec1, irec2;
+	struct xfs_exchmaps_adjacent	adj = ADJACENT_INIT;
+	xfs_filblks_t			ip1_blocks = 0, ip2_blocks = 0;
+	int64_t				d_nexts1, d_nexts2;
+	int				bmap_flags;
+	int				error;
+
+	ASSERT(!(req->flags & ~XFS_EXCHMAPS_PARAMS));
+
+	bmap_flags = xfs_bmapi_aflag(xfs_exchmaps_reqfork(req));
+	xmi = xfs_exchmaps_init_intent(req);
+
+	/*
+	 * To guard against the possibility of overflowing the extent counters,
+	 * we have to estimate an upper bound on the potential increase in that
+	 * counter.  We can split the mapping at each end of the range, and for
+	 * each step of the exchange we can split the mapping that we're
+	 * working on if the mappings do not align.
+	 */
+	d_nexts1 = d_nexts2 = 3;
+
+	while (xmi_has_more_exchange_work(xmi)) {
+		/*
+		 * Walk through the file ranges until we find something to
+		 * exchange.  Because we're simulating the exchange, pass in
+		 * adj to capture skipped mappings for correct estimation of
+		 * bmbt record merges.
+		 */
+		error = xfs_exchmaps_find_mappings(xmi, &irec1, &irec2, &adj);
+		if (error)
+			goto out_free;
+		if (!xmi_has_more_exchange_work(xmi))
+			break;
+
+		/* Update accounting. */
+		if (xfs_bmap_is_real_extent(&irec1))
+			ip1_blocks += irec1.br_blockcount;
+		if (xfs_bmap_is_real_extent(&irec2))
+			ip2_blocks += irec2.br_blockcount;
+		req->nr_exchanges++;
+
+		/* Read the next mappings from both files. */
+		error = xmi_next(req->ip1, bmap_flags, &irec1, &adj.right1);
+		if (error)
+			goto out_free;
+
+		error = xmi_next(req->ip2, bmap_flags, &irec2, &adj.right2);
+		if (error)
+			goto out_free;
+
+		/* Update extent count deltas. */
+		d_nexts1 += xmi_delta_nextents_step(req->ip1->i_mount,
+				&adj.left1, &irec1, &irec2, &adj.right1);
+
+		d_nexts2 += xmi_delta_nextents_step(req->ip1->i_mount,
+				&adj.left2, &irec2, &irec1, &adj.right2);
+
+		/* Now pretend we exchanged the mappings. */
+		if (xmi_can_merge(&adj.left2, &irec1))
+			adj.left2.br_blockcount += irec1.br_blockcount;
+		else
+			memcpy(&adj.left2, &irec1, sizeof(irec1));
+
+		if (xmi_can_merge(&adj.left1, &irec2))
+			adj.left1.br_blockcount += irec2.br_blockcount;
+		else
+			memcpy(&adj.left1, &irec2, sizeof(irec2));
+
+		xmi_advance(xmi, &irec1);
+	}
+
+	/* Account for the blocks that are being exchanged. */
+	if (XFS_IS_REALTIME_INODE(req->ip1) &&
+	    xfs_exchmaps_reqfork(req) == XFS_DATA_FORK) {
+		req->ip1_rtbcount = ip1_blocks;
+		req->ip2_rtbcount = ip2_blocks;
+	} else {
+		req->ip1_bcount = ip1_blocks;
+		req->ip2_bcount = ip2_blocks;
+	}
+
+	/*
+	 * Make sure that both forks have enough slack left in their extent
+	 * counters that the exchange operation will not overflow.
+	 */
+	trace_xfs_exchmaps_delta_nextents(req, d_nexts1, d_nexts2);
+	if (req->ip1 == req->ip2) {
+		error = xmi_ensure_delta_nextents(req, req->ip1,
+				d_nexts1 + d_nexts2);
+	} else {
+		error = xmi_ensure_delta_nextents(req, req->ip1, d_nexts1);
+		if (error)
+			goto out_free;
+		error = xmi_ensure_delta_nextents(req, req->ip2, d_nexts2);
+	}
+	if (error)
+		goto out_free;
+
+	trace_xfs_exchmaps_initial_estimate(req);
+	error = xfs_exchmaps_estimate_overhead(req);
+out_free:
+	kmem_cache_free(xfs_exchmaps_intent_cache, xmi);
+	return error;
+}
+
+/* Set the reflink flag before an operation. */
+static inline void
+xfs_exchmaps_set_reflink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	trace_xfs_reflink_set_inode_flag(ip);
+
+	ip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
+/*
+ * If either file has shared blocks and we're exchanging data forks, we must
+ * flag the other file as having shared blocks so that we get the shared-block
+ * rmap functions if we need to fix up the rmaps.
+ */
+void
+xfs_exchmaps_ensure_reflink(
+	struct xfs_trans			*tp,
+	const struct xfs_exchmaps_intent	*xmi)
+{
+	unsigned int				rs = 0;
+
+	if (xfs_is_reflink_inode(xmi->xmi_ip1))
+		rs |= 1;
+	if (xfs_is_reflink_inode(xmi->xmi_ip2))
+		rs |= 2;
+
+	if ((rs & 1) && !xfs_is_reflink_inode(xmi->xmi_ip2))
+		xfs_exchmaps_set_reflink(tp, xmi->xmi_ip2);
+
+	if ((rs & 2) && !xfs_is_reflink_inode(xmi->xmi_ip1))
+		xfs_exchmaps_set_reflink(tp, xmi->xmi_ip1);
+}
+
+/* Set the large extent count flag before an operation if needed. */
+static inline void
+xfs_exchmaps_ensure_large_extent_counts(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	if (xfs_inode_has_large_extent_counts(ip))
+		return;
+
+	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+}
+
+/* Widen the extent counter fields of both inodes if necessary. */
+void
+xfs_exchmaps_upgrade_extent_counts(
+	struct xfs_trans			*tp,
+	const struct xfs_exchmaps_intent	*xmi)
+{
+	if (!xfs_has_large_extent_counts(tp->t_mountp))
+		return;
+
+	xfs_exchmaps_ensure_large_extent_counts(tp, xmi->xmi_ip1);
+	xfs_exchmaps_ensure_large_extent_counts(tp, xmi->xmi_ip2);
+}
+
+/*
+ * Schedule an exchange a range of mappings from one inode to another.
+ *
+ * The use of file mapping exchange log intent items ensures the operation can
+ * be resumed even if the system goes down.  The caller must commit the
+ * transaction to start the work.
+ *
+ * The caller must ensure the inodes must be joined to the transaction and
+ * ILOCKd; they will still be joined to the transaction at exit.
+ */
+void
+xfs_exchange_mappings(
+	struct xfs_trans		*tp,
+	const struct xfs_exchmaps_req	*req)
+{
+	struct xfs_exchmaps_intent	*xmi;
+
+	xfs_assert_ilocked(req->ip1, XFS_ILOCK_EXCL);
+	xfs_assert_ilocked(req->ip2, XFS_ILOCK_EXCL);
+	ASSERT(!(req->flags & ~XFS_EXCHMAPS_LOGGED_FLAGS));
+	if (req->flags & XFS_EXCHMAPS_SET_SIZES)
+		ASSERT(!(req->flags & XFS_EXCHMAPS_ATTR_FORK));
+	ASSERT(xfs_has_exchange_range(tp->t_mountp));
+
+	if (req->blockcount == 0)
+		return;
+
+	xmi = xfs_exchmaps_init_intent(req);
+	xfs_exchmaps_defer_add(tp, xmi);
+	xfs_exchmaps_ensure_reflink(tp, xmi);
+	xfs_exchmaps_upgrade_extent_counts(tp, xmi);
+}
diff --git a/libxfs/xfs_exchmaps.h b/libxfs/xfs_exchmaps.h
new file mode 100644
index 000000000..e8fc3f80c
--- /dev/null
+++ b/libxfs/xfs_exchmaps.h
@@ -0,0 +1,118 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_EXCHMAPS_H__
+#define __XFS_EXCHMAPS_H__
+
+/* In-core deferred operation info about a file mapping exchange request. */
+struct xfs_exchmaps_intent {
+	/* List of other incore deferred work. */
+	struct list_head	xmi_list;
+
+	/* Inodes participating in the operation. */
+	struct xfs_inode	*xmi_ip1;
+	struct xfs_inode	*xmi_ip2;
+
+	/* File offset range information. */
+	xfs_fileoff_t		xmi_startoff1;
+	xfs_fileoff_t		xmi_startoff2;
+	xfs_filblks_t		xmi_blockcount;
+
+	/* Set these file sizes after the operation, unless negative. */
+	xfs_fsize_t		xmi_isize1;
+	xfs_fsize_t		xmi_isize2;
+
+	uint64_t		xmi_flags;	/* XFS_EXCHMAPS_* flags */
+};
+
+/* flags that can be passed to xfs_exchmaps_{estimate,mappings} */
+#define XFS_EXCHMAPS_PARAMS		(XFS_EXCHMAPS_ATTR_FORK | \
+					 XFS_EXCHMAPS_SET_SIZES | \
+					 XFS_EXCHMAPS_INO1_WRITTEN)
+
+static inline int
+xfs_exchmaps_whichfork(const struct xfs_exchmaps_intent *xmi)
+{
+	if (xmi->xmi_flags & XFS_EXCHMAPS_ATTR_FORK)
+		return XFS_ATTR_FORK;
+	return XFS_DATA_FORK;
+}
+
+/* Parameters for a mapping exchange request. */
+struct xfs_exchmaps_req {
+	/* Inodes participating in the operation. */
+	struct xfs_inode	*ip1;
+	struct xfs_inode	*ip2;
+
+	/* File offset range information. */
+	xfs_fileoff_t		startoff1;
+	xfs_fileoff_t		startoff2;
+	xfs_filblks_t		blockcount;
+
+	/* XFS_EXCHMAPS_* operation flags */
+	uint64_t		flags;
+
+	/*
+	 * Fields below this line are filled out by xfs_exchmaps_estimate;
+	 * callers should initialize this part of the struct to zero.
+	 */
+
+	/*
+	 * Data device blocks to be moved out of ip1, and free space needed to
+	 * handle the bmbt changes.
+	 */
+	xfs_filblks_t		ip1_bcount;
+
+	/*
+	 * Data device blocks to be moved out of ip2, and free space needed to
+	 * handle the bmbt changes.
+	 */
+	xfs_filblks_t		ip2_bcount;
+
+	/* rt blocks to be moved out of ip1. */
+	xfs_filblks_t		ip1_rtbcount;
+
+	/* rt blocks to be moved out of ip2. */
+	xfs_filblks_t		ip2_rtbcount;
+
+	/* Free space needed to handle the bmbt changes */
+	unsigned long long	resblks;
+
+	/* Number of exchanges needed to complete the operation */
+	unsigned long long	nr_exchanges;
+};
+
+static inline int
+xfs_exchmaps_reqfork(const struct xfs_exchmaps_req *req)
+{
+	if (req->flags & XFS_EXCHMAPS_ATTR_FORK)
+		return XFS_ATTR_FORK;
+	return XFS_DATA_FORK;
+}
+
+int xfs_exchmaps_estimate(struct xfs_exchmaps_req *req);
+
+extern struct kmem_cache	*xfs_exchmaps_intent_cache;
+
+int __init xfs_exchmaps_intent_init_cache(void);
+void xfs_exchmaps_intent_destroy_cache(void);
+
+struct xfs_exchmaps_intent *xfs_exchmaps_init_intent(
+		const struct xfs_exchmaps_req *req);
+void xfs_exchmaps_ensure_reflink(struct xfs_trans *tp,
+		const struct xfs_exchmaps_intent *xmi);
+void xfs_exchmaps_upgrade_extent_counts(struct xfs_trans *tp,
+		const struct xfs_exchmaps_intent *xmi);
+
+int xfs_exchmaps_finish_one(struct xfs_trans *tp,
+		struct xfs_exchmaps_intent *xmi);
+
+int xfs_exchmaps_check_forks(struct xfs_mount *mp,
+		const struct xfs_exchmaps_req *req);
+
+void xfs_exchange_mappings(struct xfs_trans *tp,
+		const struct xfs_exchmaps_req *req);
+
+#endif /* __XFS_EXCHMAPS_H__ */
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 09024431c..8dbe1f997 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -904,7 +904,29 @@ struct xfs_xmi_log_format {
 	uint64_t		xmi_isize2;	/* intended file2 size */
 };
 
-#define XFS_EXCHMAPS_LOGGED_FLAGS		(0)
+/* Exchange mappings between extended attribute forks instead of data forks. */
+#define XFS_EXCHMAPS_ATTR_FORK		(1ULL << 0)
+
+/* Set the file sizes when finished. */
+#define XFS_EXCHMAPS_SET_SIZES		(1ULL << 1)
+
+/*
+ * Exchange the mappings of the two files only if the file allocation units
+ * mapped to file1's range have been written.
+ */
+#define XFS_EXCHMAPS_INO1_WRITTEN	(1ULL << 2)
+
+/* Clear the reflink flag from inode1 after the operation. */
+#define XFS_EXCHMAPS_CLEAR_INO1_REFLINK	(1ULL << 3)
+
+/* Clear the reflink flag from inode2 after the operation. */
+#define XFS_EXCHMAPS_CLEAR_INO2_REFLINK	(1ULL << 4)
+
+#define XFS_EXCHMAPS_LOGGED_FLAGS	(XFS_EXCHMAPS_ATTR_FORK | \
+					 XFS_EXCHMAPS_SET_SIZES | \
+					 XFS_EXCHMAPS_INO1_WRITTEN | \
+					 XFS_EXCHMAPS_CLEAR_INO1_REFLINK | \
+					 XFS_EXCHMAPS_CLEAR_INO2_REFLINK)
 
 /* This is the structure used to lay out an mapping exchange done log item. */
 struct xfs_xmd_log_format {
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 87b31c69a..9640fc232 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -10,6 +10,10 @@
  * Components of space reservations.
  */
 
+/* Worst case number of bmaps that can be held in a block. */
+#define XFS_MAX_CONTIG_BMAPS_PER_BLOCK(mp)    \
+		(((mp)->m_bmap_dmxr[0]) - ((mp)->m_bmap_dmnr[0]))
+
 /* Worst case number of rmaps that can be held in a block. */
 #define XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)    \
 		(((mp)->m_rmap_mxr[0]) - ((mp)->m_rmap_mnr[0]))


