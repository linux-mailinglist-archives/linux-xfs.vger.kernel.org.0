Return-Path: <linux-xfs+bounces-8586-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3198B8CB98E
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 05:14:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 542531C20C29
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 03:14:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 883F74C62;
	Wed, 22 May 2024 03:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SreZjayp"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0F541C71
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347676; cv=none; b=fAzwGJnyzfMxZSjtsH4q0HX7ezznfva9RVUn5KzSFw89mgNJkCT7Pv0VzOzZsOpoyCRMWev5psHgmjDvq2WoHOTLD2cwfex0/5HcbEC812jtxIlTldHVXX4Wh2ulS/1R1X6XeI1nW0Gw0MMmy4u3Qj6acHHnLge09PN6x8BerUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347676; c=relaxed/simple;
	bh=UgEOPuiNcNZRJXYYckr/IcUPtXAXPL52nF33ok1O3ZU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qJPDjj7n69ZHwPJrs3efPNMxtuL243+odpPU9jQ33GqzJqiBTg5W9psTkerPOLud9f5CNmKV6LGrnqX6aIbQ4XvKtxDC4XpouBav6pVTEtpNrqjd99d8DQahV8qIQu8K/DqmxeMArSdW9S5prxFt+cj3cNfUKf8Pl+64tihyWxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SreZjayp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187E4C2BD11;
	Wed, 22 May 2024 03:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347676;
	bh=UgEOPuiNcNZRJXYYckr/IcUPtXAXPL52nF33ok1O3ZU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SreZjaypvFBYkGeUppJT7mrMUbszSxY6WjhNTnH3IeX3Fr9w6N/WvyM7hw6uONgkA
	 wVbZ+fWkwrCQuIGqzxYLp+9b+mGtIgWgpSl0pmgfK3+gSI1H6YE9dZ5H/lbVWk33P/
	 O7V38VoewV82WOET9HfF0vDdq7mZa24dihmTyyshXzf8M13b6iOhvpKr3ieE8SyaKB
	 EcRb45jBWFowF13BeBLF0idhg2VLWvbkx1UdZYF9imgntI8UGpvuXM8D/HoXAjjc8S
	 3JOD4RUxQlWFeTad3tTh0pAfsNDIbtQ2jjfPKwNeLuVq1c880Kl8UFT9fq69uRKLW2
	 I7OXpnHGmX6dw==
Date: Tue, 21 May 2024 20:14:35 -0700
Subject: [PATCH 099/111] xfs: hook live rmap operations during a repair
 operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533187.2478931.7011883267737446225.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 7e1b84b24d257700e417bc9cd724c1efdff653d7

Hook the regular rmap code when an rmapbt repair operation is running so
that we can unlock the AGF buffer to scan the filesystem and keep the
in-memory btree up to date during the scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag.c   |    1 
 libxfs/xfs_ag.h   |    3 +
 libxfs/xfs_rmap.c |  154 ++++++++++++++++++++++++++++++++++++++++++-----------
 libxfs/xfs_rmap.h |   29 ++++++++++
 4 files changed, 154 insertions(+), 33 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 06a881285..e2fc3e882 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -415,6 +415,7 @@ xfs_initialize_perag(
 		init_waitqueue_head(&pag->pag_active_wq);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
+		xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
 
 		error = xfs_buf_cache_init(&pag->pag_bcache);
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index e019b79db..35de09a25 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -120,6 +120,9 @@ struct xfs_perag {
 	 * inconsistencies.
 	 */
 	struct xfs_defer_drain	pag_intents_drain;
+
+	/* Hook to feed rmapbt updates to an active online repair. */
+	struct xfs_hooks	pag_rmap_update_hooks;
 #endif /* __KERNEL__ */
 };
 
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index a7be2aa92..c3195e532 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -820,6 +820,86 @@ xfs_rmap_unmap(
 	return error;
 }
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+/*
+ * Use a static key here to reduce the overhead of rmapbt live updates.  If
+ * the compiler supports jump labels, the static branch will be replaced by a
+ * nop sled when there are no hook users.  Online fsck is currently the only
+ * caller, so this is a reasonable tradeoff.
+ *
+ * Note: Patching the kernel code requires taking the cpu hotplug lock.  Other
+ * parts of the kernel allocate memory with that lock held, which means that
+ * XFS callers cannot hold any locks that might be used by memory reclaim or
+ * writeback when calling the static_branch_{inc,dec} functions.
+ */
+DEFINE_STATIC_XFS_HOOK_SWITCH(xfs_rmap_hooks_switch);
+
+void
+xfs_rmap_hook_disable(void)
+{
+	xfs_hooks_switch_off(&xfs_rmap_hooks_switch);
+}
+
+void
+xfs_rmap_hook_enable(void)
+{
+	xfs_hooks_switch_on(&xfs_rmap_hooks_switch);
+}
+
+/* Call downstream hooks for a reverse mapping update. */
+static inline void
+xfs_rmap_update_hook(
+	struct xfs_trans		*tp,
+	struct xfs_perag		*pag,
+	enum xfs_rmap_intent_type	op,
+	xfs_agblock_t			startblock,
+	xfs_extlen_t			blockcount,
+	bool				unwritten,
+	const struct xfs_owner_info	*oinfo)
+{
+	if (xfs_hooks_switched_on(&xfs_rmap_hooks_switch)) {
+		struct xfs_rmap_update_params	p = {
+			.startblock	= startblock,
+			.blockcount	= blockcount,
+			.unwritten	= unwritten,
+			.oinfo		= *oinfo, /* struct copy */
+		};
+
+		if (pag)
+			xfs_hooks_call(&pag->pag_rmap_update_hooks, op, &p);
+	}
+}
+
+/* Call the specified function during a reverse mapping update. */
+int
+xfs_rmap_hook_add(
+	struct xfs_perag	*pag,
+	struct xfs_rmap_hook	*hook)
+{
+	return xfs_hooks_add(&pag->pag_rmap_update_hooks, &hook->rmap_hook);
+}
+
+/* Stop calling the specified function during a reverse mapping update. */
+void
+xfs_rmap_hook_del(
+	struct xfs_perag	*pag,
+	struct xfs_rmap_hook	*hook)
+{
+	xfs_hooks_del(&pag->pag_rmap_update_hooks, &hook->rmap_hook);
+}
+
+/* Configure rmap update hook functions. */
+void
+xfs_rmap_hook_setup(
+	struct xfs_rmap_hook	*hook,
+	notifier_fn_t		mod_fn)
+{
+	xfs_hook_setup(&hook->rmap_hook, mod_fn);
+}
+#else
+# define xfs_rmap_update_hook(t, p, o, s, b, u, oi)	do { } while (0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 /*
  * Remove a reference to an extent in the rmap btree.
  */
@@ -840,7 +920,7 @@ xfs_rmap_free(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-
+	xfs_rmap_update_hook(tp, pag, XFS_RMAP_UNMAP, bno, len, false, oinfo);
 	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -1092,6 +1172,7 @@ xfs_rmap_alloc(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
+	xfs_rmap_update_hook(tp, pag, XFS_RMAP_MAP, bno, len, false, oinfo);
 	error = xfs_rmap_map(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -2507,6 +2588,38 @@ xfs_rmap_finish_one_cleanup(
 		xfs_trans_brelse(tp, agbp);
 }
 
+/* Commit an rmap operation into the ondisk tree. */
+int
+__xfs_rmap_finish_intent(
+	struct xfs_btree_cur		*rcur,
+	enum xfs_rmap_intent_type	op,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	const struct xfs_owner_info	*oinfo,
+	bool				unwritten)
+{
+	switch (op) {
+	case XFS_RMAP_ALLOC:
+	case XFS_RMAP_MAP:
+		return xfs_rmap_map(rcur, bno, len, unwritten, oinfo);
+	case XFS_RMAP_MAP_SHARED:
+		return xfs_rmap_map_shared(rcur, bno, len, unwritten, oinfo);
+	case XFS_RMAP_FREE:
+	case XFS_RMAP_UNMAP:
+		return xfs_rmap_unmap(rcur, bno, len, unwritten, oinfo);
+	case XFS_RMAP_UNMAP_SHARED:
+		return xfs_rmap_unmap_shared(rcur, bno, len, unwritten, oinfo);
+	case XFS_RMAP_CONVERT:
+		return xfs_rmap_convert(rcur, bno, len, !unwritten, oinfo);
+	case XFS_RMAP_CONVERT_SHARED:
+		return xfs_rmap_convert_shared(rcur, bno, len, !unwritten,
+				oinfo);
+	default:
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+}
+
 /*
  * Process one of the deferred rmap operations.  We pass back the
  * btree cursor to maintain our lock on the rmapbt between calls.
@@ -2573,39 +2686,14 @@ xfs_rmap_finish_one(
 	unwritten = ri->ri_bmap.br_state == XFS_EXT_UNWRITTEN;
 	bno = XFS_FSB_TO_AGBNO(rcur->bc_mp, ri->ri_bmap.br_startblock);
 
-	switch (ri->ri_type) {
-	case XFS_RMAP_ALLOC:
-	case XFS_RMAP_MAP:
-		error = xfs_rmap_map(rcur, bno, ri->ri_bmap.br_blockcount,
-				unwritten, &oinfo);
-		break;
-	case XFS_RMAP_MAP_SHARED:
-		error = xfs_rmap_map_shared(rcur, bno,
-				ri->ri_bmap.br_blockcount, unwritten, &oinfo);
-		break;
-	case XFS_RMAP_FREE:
-	case XFS_RMAP_UNMAP:
-		error = xfs_rmap_unmap(rcur, bno, ri->ri_bmap.br_blockcount,
-				unwritten, &oinfo);
-		break;
-	case XFS_RMAP_UNMAP_SHARED:
-		error = xfs_rmap_unmap_shared(rcur, bno,
-				ri->ri_bmap.br_blockcount, unwritten, &oinfo);
-		break;
-	case XFS_RMAP_CONVERT:
-		error = xfs_rmap_convert(rcur, bno, ri->ri_bmap.br_blockcount,
-				!unwritten, &oinfo);
-		break;
-	case XFS_RMAP_CONVERT_SHARED:
-		error = xfs_rmap_convert_shared(rcur, bno,
-				ri->ri_bmap.br_blockcount, !unwritten, &oinfo);
-		break;
-	default:
-		ASSERT(0);
-		error = -EFSCORRUPTED;
-	}
+	error = __xfs_rmap_finish_intent(rcur, ri->ri_type, bno,
+			ri->ri_bmap.br_blockcount, &oinfo, unwritten);
+	if (error)
+		return error;
 
-	return error;
+	xfs_rmap_update_hook(tp, ri->ri_pag, ri->ri_type, bno,
+			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
+	return 0;
 }
 
 /*
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 58c67896d..9d01fe689 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -186,6 +186,10 @@ void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 		struct xfs_btree_cur *rcur, int error);
 int xfs_rmap_finish_one(struct xfs_trans *tp, struct xfs_rmap_intent *ri,
 		struct xfs_btree_cur **pcur);
+int __xfs_rmap_finish_intent(struct xfs_btree_cur *rcur,
+		enum xfs_rmap_intent_type op, xfs_agblock_t bno,
+		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
+		bool unwritten);
 
 int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
@@ -235,4 +239,29 @@ extern struct kmem_cache	*xfs_rmap_intent_cache;
 int __init xfs_rmap_intent_init_cache(void);
 void xfs_rmap_intent_destroy_cache(void);
 
+/*
+ * Parameters for tracking reverse mapping changes.  The hook function arg
+ * parameter is enum xfs_rmap_intent_type, and the rest is below.
+ */
+struct xfs_rmap_update_params {
+	xfs_agblock_t			startblock;
+	xfs_extlen_t			blockcount;
+	struct xfs_owner_info		oinfo;
+	bool				unwritten;
+};
+
+#ifdef CONFIG_XFS_LIVE_HOOKS
+
+struct xfs_rmap_hook {
+	struct xfs_hook			rmap_hook;
+};
+
+void xfs_rmap_hook_disable(void);
+void xfs_rmap_hook_enable(void);
+
+int xfs_rmap_hook_add(struct xfs_perag *pag, struct xfs_rmap_hook *hook);
+void xfs_rmap_hook_del(struct xfs_perag *pag, struct xfs_rmap_hook *hook);
+void xfs_rmap_hook_setup(struct xfs_rmap_hook *hook, notifier_fn_t mod_fn);
+#endif
+
 #endif	/* __XFS_RMAP_H__ */


