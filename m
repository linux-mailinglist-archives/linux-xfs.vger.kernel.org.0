Return-Path: <linux-xfs+bounces-3180-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E3B841B3D
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jan 2024 06:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 391121C23C08
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jan 2024 05:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD4537702;
	Tue, 30 Jan 2024 05:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tzgf2yMh"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE523376F6
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591338; cv=none; b=chRtEabhQH9rJaumhFP7a2cI7dWvkUHLmoBxuI62sZyQLJiOW9JOVJV5M96p7bN4c8lhoPtULizvJHcHtor4BzHtlXXfl9hr+EXLqVUKO3KU3Fchfv/Uaz6gF5QYlqZVE6MIn2fRa5DNMCtAn8+cx+/lJmddXu1eja9w3tTSq0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591338; c=relaxed/simple;
	bh=zgOGbf7j015M4tihsGlB1/TStHyVc4ruZ4DdpNo+jGU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UyRDVUNDLt19n0vpM0Be2ukPKIuAQn2VOhBTH2DyA7iMDBkJg7139NCX1kWTucUCyxpIjNgg/33AVJKxy8Kr/nv++8b/8FBTekrKxeub75zJCSj2m89t0VGOqVBaaaKQUdZcnIamy2n2Z6CPB1lpf1ANguE7BguKZ1iZKRksoSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tzgf2yMh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EDEC433C7;
	Tue, 30 Jan 2024 05:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591338;
	bh=zgOGbf7j015M4tihsGlB1/TStHyVc4ruZ4DdpNo+jGU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Tzgf2yMh4FcUbDPuKlc5gw2bMTyHUEI4uakak0ZeaL4gGwC2Sg3WSPeevcQ9vVAzo
	 /rKr8TrvjF7wTuiFXviS9OPbc49eyIDJ+HZFkwxLB/ttlIuqrvMFoO7uXIvHg1ev72
	 liHQM8d3Dg0KxTrRJu9prrHQJQHsxcSVWDvmjCxAZNhJcXOTKC0rD9nstCx6SEu88G
	 IByAH55U5naScPiwTse2EqmKtX8RLfq7lPO3LCBgntgRzQvw3qbmPQ0lqGQ046qp8s
	 NGDPeRvVqcTX6yT06FcmN3oxL0vn1ynqicMzm9SEUsd7wvz4Hb+WPUP0DFefGCctZk
	 PysN1scHeVWKQ==
Date: Mon, 29 Jan 2024 21:08:58 -0800
Subject: [PATCH 3/4] xfs: track directory entry updates during live nlinks
 fsck
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063308.3353617.12152353568487234637.stgit@frogsfrogsfrogs>
In-Reply-To: <170659063247.3353617.664642117268018311.stgit@frogsfrogsfrogs>
References: <170659063247.3353617.664642117268018311.stgit@frogsfrogsfrogs>
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

Create the necessary hooks in the directory operations
(create/link/unlink/rename) code so that our live nlink scrub code can
stay up to date with link count updates in the rest of the filesystem.
This will be the means to keep our shadow link count information up to
date while the scan runs in real time.

In online fsck part 2, we'll use these same hooks to handle repairs
to directories and parent pointer information.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c |    3 +
 fs/xfs/scrub/nlinks.c |   93 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/nlinks.h |    6 +++
 fs/xfs/scrub/scrub.c  |    3 +
 fs/xfs/scrub/scrub.h  |    4 +-
 fs/xfs/scrub/trace.h  |   33 +++++++++++++++
 fs/xfs/xfs_inode.c    |  108 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h    |   31 ++++++++++++++
 fs/xfs/xfs_mount.h    |    3 +
 fs/xfs/xfs_super.c    |    2 +
 fs/xfs/xfs_symlink.c  |    1 
 11 files changed, 284 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index c5a6c47d3df2e..699092195f41b 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1302,6 +1302,9 @@ xchk_fsgates_enable(
 	if (scrub_fsgates & XCHK_FSGATES_QUOTA)
 		xfs_dqtrx_hook_enable();
 
+	if (scrub_fsgates & XCHK_FSGATES_DIRENTS)
+		xfs_dir_hook_enable();
+
 	sc->flags |= scrub_fsgates;
 }
 
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index c899a50a83daf..421615136972b 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -43,8 +43,7 @@ int
 xchk_setup_nlinks(
 	struct xfs_scrub	*sc)
 {
-	/* Not ready for general consumption yet. */
-	return -EOPNOTSUPP;
+	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
 
 	sc->buf = kzalloc(sizeof(struct xchk_nlink_ctrs), XCHK_GFP_FLAGS);
 	if (!sc->buf)
@@ -63,6 +62,21 @@ xchk_setup_nlinks(
  * must be taken with certain errno values (i.e. EFSBADCRC, EFSCORRUPTED,
  * ECANCELED) that are absorbed into a scrub state flag update by
  * xchk_*_process_error.
+ *
+ * Because we are scanning a live filesystem, it's possible that another thread
+ * will try to update the link counts for an inode that we've already scanned.
+ * This will cause our counts to be incorrect.  Therefore, we hook all
+ * directory entry updates because that is when link count updates occur.  By
+ * shadowing transaction updates in this manner, live nlink check can ensure by
+ * locking the inode and the shadow structure that its own copies are not out
+ * of date.  Because the hook code runs in a different process context from the
+ * scrub code and the scrub state flags are not accessed atomically, failures
+ * in the hook code must abort the iscan and the scrubber must notice the
+ * aborted scan and set the incomplete flag.
+ *
+ * Note that we use jump labels and srcu notifier hooks to minimize the
+ * overhead when live nlinks is /not/ running.  Locking order for nlink
+ * observations is inode ILOCK -> iscan_lock/xchk_nlink_ctrs lock.
  */
 
 /*
@@ -120,6 +134,63 @@ xchk_nlinks_update_incore(
 	return error;
 }
 
+/*
+ * Apply a link count change from the regular filesystem into our shadow link
+ * count structure based on a directory update in progress.
+ */
+STATIC int
+xchk_nlinks_live_update(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_dir_update_params	*p = data;
+	struct xchk_nlink_ctrs		*xnc;
+	int				error;
+
+	xnc = container_of(nb, struct xchk_nlink_ctrs, hooks.dirent_hook.nb);
+
+	trace_xchk_nlinks_live_update(xnc->sc->mp, p->dp, action, p->ip->i_ino,
+			p->delta, p->name->name, p->name->len);
+
+	/*
+	 * If we've already scanned @dp, update the number of parents that link
+	 * to @ip.  If @ip is a subdirectory, update the number of child links
+	 * going out of @dp.
+	 */
+	if (xchk_iscan_want_live_update(&xnc->collect_iscan, p->dp->i_ino)) {
+		mutex_lock(&xnc->lock);
+		error = xchk_nlinks_update_incore(xnc, p->ip->i_ino, p->delta,
+				0, 0);
+		if (!error && S_ISDIR(VFS_IC(p->ip)->i_mode))
+			error = xchk_nlinks_update_incore(xnc, p->dp->i_ino, 0,
+					0, p->delta);
+		mutex_unlock(&xnc->lock);
+		if (error)
+			goto out_abort;
+	}
+
+	/*
+	 * If @ip is a subdirectory and we've already scanned it, update the
+	 * number of backrefs pointing to @dp.
+	 */
+	if (S_ISDIR(VFS_IC(p->ip)->i_mode) &&
+	    xchk_iscan_want_live_update(&xnc->collect_iscan, p->ip->i_ino)) {
+		mutex_lock(&xnc->lock);
+		error = xchk_nlinks_update_incore(xnc, p->dp->i_ino, 0,
+				p->delta, 0);
+		mutex_unlock(&xnc->lock);
+		if (error)
+			goto out_abort;
+	}
+
+	return NOTIFY_DONE;
+
+out_abort:
+	xchk_iscan_abort(&xnc->collect_iscan);
+	return NOTIFY_DONE;
+}
+
 /* Bump the observed link count for the inode referenced by this entry. */
 STATIC int
 xchk_nlinks_collect_dirent(
@@ -747,6 +818,11 @@ xchk_nlinks_teardown_scan(
 {
 	struct xchk_nlink_ctrs	*xnc = priv;
 
+	/* Discourage any hook functions that might be running. */
+	xchk_iscan_abort(&xnc->collect_iscan);
+
+	xfs_dir_hook_del(xnc->sc->mp, &xnc->hooks);
+
 	xfarray_destroy(xnc->nlinks);
 	xnc->nlinks = NULL;
 
@@ -793,6 +869,19 @@ xchk_nlinks_setup_scan(
 	if (error)
 		goto out_teardown;
 
+	/*
+	 * Hook into the directory entry code so that we can capture updates to
+	 * file link counts.  The hook only triggers for inodes that were
+	 * already scanned, and the scanner thread takes each inode's ILOCK,
+	 * which means that any in-progress inode updates will finish before we
+	 * can scan the inode.
+	 */
+	ASSERT(sc->flags & XCHK_FSGATES_DIRENTS);
+	xfs_hook_setup(&xnc->hooks.dirent_hook, xchk_nlinks_live_update);
+	error = xfs_dir_hook_add(mp, &xnc->hooks);
+	if (error)
+		goto out_teardown;
+
 	/* Use deferred cleanup to pass the inode link count data to repair. */
 	sc->buf_cleanup = xchk_nlinks_teardown_scan;
 	return 0;
diff --git a/fs/xfs/scrub/nlinks.h b/fs/xfs/scrub/nlinks.h
index 69a3460c5e52f..58d247c051292 100644
--- a/fs/xfs/scrub/nlinks.h
+++ b/fs/xfs/scrub/nlinks.h
@@ -22,6 +22,12 @@ struct xchk_nlink_ctrs {
 	 */
 	struct xchk_iscan	collect_iscan;
 	struct xchk_iscan	compare_iscan;
+
+	/*
+	 * Hook into directory updates so that we can receive live updates
+	 * from other writer threads.
+	 */
+	struct xfs_dir_hook	hooks;
 };
 
 /*
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 8c60774d5f345..883c47b6c6860 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -160,6 +160,9 @@ xchk_fsgates_disable(
 	if (sc->flags & XCHK_FSGATES_QUOTA)
 		xfs_dqtrx_hook_disable();
 
+	if (sc->flags & XCHK_FSGATES_DIRENTS)
+		xfs_dir_hook_disable();
+
 	sc->flags &= ~XCHK_FSGATES_ALL;
 }
 
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index de6b45f99dd5f..f99a3c21d02ea 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -122,6 +122,7 @@ struct xfs_scrub {
 #define XCHK_FSGATES_DRAIN	(1U << 2)  /* defer ops draining enabled */
 #define XCHK_NEED_DRAIN		(1U << 3)  /* scrub needs to drain defer ops */
 #define XCHK_FSGATES_QUOTA	(1U << 4)  /* quota live update enabled */
+#define XCHK_FSGATES_DIRENTS	(1U << 5)  /* directory live update enabled */
 #define XREP_RESET_PERAG_RESV	(1U << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1U << 31) /* checking our repair work */
 
@@ -132,7 +133,8 @@ struct xfs_scrub {
  * must be enabled during scrub setup and can only be torn down afterwards.
  */
 #define XCHK_FSGATES_ALL	(XCHK_FSGATES_DRAIN | \
-				 XCHK_FSGATES_QUOTA)
+				 XCHK_FSGATES_QUOTA | \
+				 XCHK_FSGATES_DIRENTS)
 
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 0deea8f18a30b..9512170ea9a7b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -116,6 +116,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 	{ XCHK_FSGATES_DRAIN,			"fsgates_drain" }, \
 	{ XCHK_NEED_DRAIN,			"need_drain" }, \
 	{ XCHK_FSGATES_QUOTA,			"fsgates_quota" }, \
+	{ XCHK_FSGATES_DIRENTS,			"fsgates_dirents" }, \
 	{ XREP_RESET_PERAG_RESV,		"reset_perag_resv" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 
@@ -1363,6 +1364,38 @@ TRACE_EVENT(xchk_nlinks_collect_metafile,
 		  __entry->ino)
 );
 
+TRACE_EVENT(xchk_nlinks_live_update,
+	TP_PROTO(struct xfs_mount *mp, const struct xfs_inode *dp,
+		 int action, xfs_ino_t ino, int delta,
+		 const char *name, unsigned int namelen),
+	TP_ARGS(mp, dp, action, ino, delta, name, namelen),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir)
+		__field(int, action)
+		__field(xfs_ino_t, ino)
+		__field(int, delta)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, namelen)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->dir = dp ? dp->i_ino : NULLFSINO;
+		__entry->action = action;
+		__entry->ino = ino;
+		__entry->delta = delta;
+		__entry->namelen = namelen;
+		memcpy(__get_str(name), name, namelen);
+	),
+	TP_printk("dev %d:%d dir 0x%llx ino 0x%llx nlink_delta %d name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir,
+		  __entry->ino,
+		  __entry->delta,
+		  __entry->namelen,
+		  __get_str(name))
+);
+
 TRACE_EVENT(xchk_nlinks_check_zero,
 	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino,
 		 const struct xchk_nlink *live),
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5670a2966e19f..a65ec91a5c0f8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -947,6 +947,72 @@ xfs_bumplink(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+/*
+ * Use a static key here to reduce the overhead of directory live update hooks.
+ * If the compiler supports jump labels, the static branch will be replaced by
+ * a nop sled when there are no hook users.  Online fsck is currently the only
+ * caller, so this is a reasonable tradeoff.
+ *
+ * Note: Patching the kernel code requires taking the cpu hotplug lock.  Other
+ * parts of the kernel allocate memory with that lock held, which means that
+ * XFS callers cannot hold any locks that might be used by memory reclaim or
+ * writeback when calling the static_branch_{inc,dec} functions.
+ */
+DEFINE_STATIC_XFS_HOOK_SWITCH(xfs_dir_hooks_switch);
+
+void
+xfs_dir_hook_disable(void)
+{
+	xfs_hooks_switch_off(&xfs_dir_hooks_switch);
+}
+
+void
+xfs_dir_hook_enable(void)
+{
+	xfs_hooks_switch_on(&xfs_dir_hooks_switch);
+}
+
+/* Call hooks for a directory update relating to a child dirent update. */
+inline void
+xfs_dir_update_hook(
+	struct xfs_inode		*dp,
+	struct xfs_inode		*ip,
+	int				delta,
+	const struct xfs_name		*name)
+{
+	if (xfs_hooks_switched_on(&xfs_dir_hooks_switch)) {
+		struct xfs_dir_update_params	p = {
+			.dp		= dp,
+			.ip		= ip,
+			.delta		= delta,
+			.name		= name,
+		};
+		struct xfs_mount	*mp = ip->i_mount;
+
+		xfs_hooks_call(&mp->m_dir_update_hooks, 0, &p);
+	}
+}
+
+/* Call the specified function during a directory update. */
+int
+xfs_dir_hook_add(
+	struct xfs_mount	*mp,
+	struct xfs_dir_hook	*hook)
+{
+	return xfs_hooks_add(&mp->m_dir_update_hooks, &hook->dirent_hook);
+}
+
+/* Stop calling the specified function during a directory update. */
+void
+xfs_dir_hook_del(
+	struct xfs_mount	*mp,
+	struct xfs_dir_hook	*hook)
+{
+	xfs_hooks_del(&mp->m_dir_update_hooks, &hook->dirent_hook);
+}
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 int
 xfs_create(
 	struct mnt_idmap	*idmap,
@@ -1057,6 +1123,12 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * Create ip with a reference from dp, and add '.' and '..' references
+	 * if it's a directory.
+	 */
+	xfs_dir_update_hook(dp, ip, 1, name);
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1271,6 +1343,7 @@ xfs_link(
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	xfs_bumplink(tp, sip);
+	xfs_dir_update_hook(tdp, sip, 1, target_name);
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -2584,6 +2657,12 @@ xfs_remove(
 		goto out_trans_cancel;
 	}
 
+	/*
+	 * Drop the link from dp to ip, and if ip was a directory, remove the
+	 * '.' and '..' references since we freed the directory.
+	 */
+	xfs_dir_update_hook(dp, ip, -1, name);
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2774,6 +2853,20 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
+
+	/*
+	 * Inform our hook clients that we've finished an exchange operation as
+	 * follows: removed the source and target files from their directories;
+	 * added the target to the source directory; and added the source to
+	 * the target directory.  All inodes are locked, so it's ok to model a
+	 * rename this way so long as we say we deleted entries before we add
+	 * new ones.
+	 */
+	xfs_dir_update_hook(dp1, ip1, -1, name1);
+	xfs_dir_update_hook(dp2, ip2, -1, name2);
+	xfs_dir_update_hook(dp1, ip2, 1, name1);
+	xfs_dir_update_hook(dp2, ip1, 1, name2);
+
 	return xfs_finish_rename(tp);
 
 out_trans_abort:
@@ -3157,6 +3250,21 @@ xfs_rename(
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
+	/*
+	 * Inform our hook clients that we've finished a rename operation as
+	 * follows: removed the source and target files from their directories;
+	 * that we've added the source to the target directory; and finally
+	 * that we've added the whiteout, if there was one.  All inodes are
+	 * locked, so it's ok to model a rename this way so long as we say we
+	 * deleted entries before we add new ones.
+	 */
+	if (target_ip)
+		xfs_dir_update_hook(target_dp, target_ip, -1, target_name);
+	xfs_dir_update_hook(src_dp, src_ip, -1, src_name);
+	xfs_dir_update_hook(target_dp, src_ip, 1, target_name);
+	if (wip)
+		xfs_dir_update_hook(src_dp, wip, 1, src_name);
+
 	error = xfs_finish_rename(tp);
 	if (wip)
 		xfs_irele(wip);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 15a16e1404eea..764d88198366d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -171,6 +171,12 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
 	return &ip->i_vnode;
 }
 
+/* convert from const xfs inode to const vfs inode */
+static inline const struct inode *VFS_IC(const struct xfs_inode *ip)
+{
+	return &ip->i_vnode;
+}
+
 /*
  * For regular files we only update the on-disk filesize when actually
  * writing data back to disk.  Until then only the copy in the VFS inode
@@ -626,4 +632,29 @@ bool xfs_ifork_zapped(const struct xfs_inode *ip, int whichfork);
 void xfs_inode_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_filblks_t *dblocks, xfs_filblks_t *rblocks);
 
+struct xfs_dir_update_params {
+	const struct xfs_inode	*dp;
+	const struct xfs_inode	*ip;
+	const struct xfs_name	*name;
+	int			delta;
+};
+
+#ifdef CONFIG_XFS_LIVE_HOOKS
+void xfs_dir_update_hook(struct xfs_inode *dp, struct xfs_inode *ip,
+		int delta, const struct xfs_name *name);
+
+struct xfs_dir_hook {
+	struct xfs_hook		dirent_hook;
+};
+
+void xfs_dir_hook_disable(void);
+void xfs_dir_hook_enable(void);
+
+int xfs_dir_hook_add(struct xfs_mount *mp, struct xfs_dir_hook *hook);
+void xfs_dir_hook_del(struct xfs_mount *mp, struct xfs_dir_hook *hook);
+
+#else
+# define xfs_dir_update_hook(dp, ip, delta, name)	((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 503fe3c7edbf8..e86dfe67894fb 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -252,6 +252,9 @@ typedef struct xfs_mount {
 
 	/* cpus that have inodes queued for inactivation */
 	struct cpumask		m_inodegc_cpumask;
+
+	/* Hook to feed dirent updates to an active online repair. */
+	struct xfs_hooks	m_dir_update_hooks;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 5a2512d20bd07..42f9a141e43b8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2013,6 +2013,8 @@ static int xfs_init_fs_context(
 	mp->m_logbsize = -1;
 	mp->m_allocsize_log = 16; /* 64k */
 
+	xfs_hooks_init(&mp->m_dir_update_hooks);
+
 	fc->s_fs_info = mp;
 	fc->ops = &xfs_context_ops;
 
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 92974a4414c83..fd5397085f379 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -322,6 +322,7 @@ xfs_symlink(
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+	xfs_dir_update_hook(dp, ip, 1, link_name);
 
 	/*
 	 * If this is a synchronous mount, make sure that the


