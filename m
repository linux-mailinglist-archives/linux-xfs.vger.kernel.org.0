Return-Path: <linux-xfs+bounces-5871-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4039388D3EE
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Mar 2024 02:50:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB0DC1F353D9
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Mar 2024 01:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 394D21D530;
	Wed, 27 Mar 2024 01:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DMcNG574"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCCD1CF9A
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504246; cv=none; b=W5nnjgbjawuEsCRy9i4f6BJHlP9kEFmwCzU3S6fAm8IxHUmAXDRdtYYdTtuv6UZ/k8r7bhY8MWomvwFCko1q2+WSoxxht9XT9Bh4NHB5kXxmmMYufO2kn13uo8KfpeRqT+guqXbTdmm/DuiWJw+jqXsIJ6SXiV+JOdm4aNN1a7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504246; c=relaxed/simple;
	bh=4U9zWNmYjjSW2rBxUHqg6asvZon2OqGPANvyG+JHXWY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dz6rUB4mW3iUh0RWvhci5pyBUL9SK3A6aHdVWHUC9W3j9AM8ytcq0pR8tA1V2gCUFq6bxc3SYeU8dRWzAzEMalYWKb1v4UqnJAATxz/0uk+QA23cniqzgNTpf/xcc7hzSIRNz+h0gEy/3Xxg19r1eVGbTESUPeaiNE902o7XFjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DMcNG574; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD14C433C7;
	Wed, 27 Mar 2024 01:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504245;
	bh=4U9zWNmYjjSW2rBxUHqg6asvZon2OqGPANvyG+JHXWY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DMcNG574biEvdJgeJnZSP6fS8UXRa9XpAANBKnr296q5zNipVpyr72PX4wJnfG1K9
	 BUCs9+4qpcVpysjBY/o4MrAfg7ZlHNEcg2pufZMuylENvvZOHnXYyuP2IJqeuwIAO/
	 CsIFcqb94YF02TzW8TG0Y9weQvioDmrUM3cHiwqk4V9X0qL9Qflf69Hz+25lxaubMS
	 +waCGdoONXOWLyo9wmMrdenwLIcXGGo6MYgjzBwY5dJ3QMIlcu+se096fE/6FML76U
	 fuUBd7svd8W5GCZEqHYVlUvDjrYCs7fQLLxrOGGcouCDJXzJ8wDXfMP74fn9qM3Oln
	 Wgyb0DzH8hTVQ==
Date: Tue, 26 Mar 2024 18:50:44 -0700
Subject: [PATCH 1/2] xfs: only clear log incompat flags at clean unmount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150379743.3216346.12598577809015628376.stgit@frogsfrogsfrogs>
In-Reply-To: <171150379721.3216346.4387266050277204544.stgit@frogsfrogsfrogs>
References: <171150379721.3216346.4387266050277204544.stgit@frogsfrogsfrogs>
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

While reviewing the online fsck patchset, someone spied the
xfs_swapext_can_use_without_log_assistance function and wondered why we
go through this inverted-bitmask dance to avoid setting the
XFS_SB_FEAT_INCOMPAT_LOG_SWAPEXT feature.

(The same principles apply to the logged extended attribute update
feature bit in the since-merged LARP series.)

The reason for this dance is that xfs_add_incompat_log_feature is an
expensive operation -- it forces the log, pushes the AIL, and then if
nobody's beaten us to it, sets the feature bit and issues a synchronous
write of the primary superblock.  That could be a one-time cost
amortized over the life of the filesystem, but the log quiesce and cover
operations call xfs_clear_incompat_log_features to remove feature bits
opportunistically.  On a moderately loaded filesystem this leads to us
cycling those bits on and off over and over, which hurts performance.

Why do we clear the log incompat bits?  Back in ~2020 I think Dave and I
had a conversation on IRC[2] about what the log incompat bits represent.
IIRC in that conversation we decided that the log incompat bits protect
unrecovered log items so that old kernels won't try to recover them and
barf.  Since a clean log has no protected log items, we could clear the
bits at cover/quiesce time.

As Dave Chinner pointed out in the thread, clearing log incompat bits at
unmount time has positive effects for golden root disk image generator
setups, since the generator could be running a newer kernel than what
gets written to the golden image -- if there are log incompat fields set
in the golden image that was generated by a newer kernel/OS image
builder then the provisioning host cannot mount the filesystem even
though the log is clean and recovery is unnecessary to mount the
filesystem.

Given that it's expensive to set log incompat bits, we really only want
to do that once per bit per mount.  Therefore, I propose that we only
clear log incompat bits as part of writing a clean unmount record.  Do
this by adding an operational state flag to the xfs mount that guards
whether or not the feature bit clearing can actually take place.

This eliminates the l_incompat_users rwsem that we use to protect a log
cleaning operation from clearing a feature bit that a frontend thread is
trying to set -- this lock adds another way to fail w.r.t. locking.  For
the swapext series, I shard that into multiple locks just to work around
the lockdep complaints, and that's fugly.

Link: https://lore.kernel.org/linux-xfs/20240131230043.GA6180@frogsfrogsfrogs/
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |    3 -
 fs/xfs/xfs_log.c                                   |   28 -------------
 fs/xfs/xfs_log.h                                   |    2 -
 fs/xfs/xfs_log_priv.h                              |    3 -
 fs/xfs/xfs_log_recover.c                           |   15 -------
 fs/xfs/xfs_mount.c                                 |    8 +++-
 fs/xfs/xfs_mount.h                                 |    6 ++-
 fs/xfs/xfs_xattr.c                                 |   42 +++-----------------
 8 files changed, 19 insertions(+), 88 deletions(-)


diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 6333697ba3e82..1d161752f09ed 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -4047,9 +4047,6 @@ series.
 | one ``struct rw_semaphore`` for each feature.                            |
 | The log cleaning code tries to take this rwsem in exclusive mode to      |
 | clear the bit; if the lock attempt fails, the feature bit remains set.   |
-| Filesystem code signals its intention to use a log incompat feature in a |
-| transaction by calling ``xlog_use_incompat_feat``, which takes the rwsem |
-| in shared mode.                                                          |
 | The code supporting a log incompat feature should create wrapper         |
 | functions to obtain the log feature and call                             |
 | ``xfs_add_incompat_log_feature`` to set the feature bits in the primary  |
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5004f23d344ed..416c154949832 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1448,7 +1448,7 @@ xfs_log_work_queue(
  * Clear the log incompat flags if we have the opportunity.
  *
  * This only happens if we're about to log the second dummy transaction as part
- * of covering the log and we can get the log incompat feature usage lock.
+ * of covering the log.
  */
 static inline void
 xlog_clear_incompat(
@@ -1463,11 +1463,7 @@ xlog_clear_incompat(
 	if (log->l_covered_state != XLOG_STATE_COVER_DONE2)
 		return;
 
-	if (!down_write_trylock(&log->l_incompat_users))
-		return;
-
 	xfs_clear_incompat_log_features(mp);
-	up_write(&log->l_incompat_users);
 }
 
 /*
@@ -1585,8 +1581,6 @@ xlog_alloc_log(
 	}
 	log->l_sectBBsize = 1 << log2_size;
 
-	init_rwsem(&log->l_incompat_users);
-
 	xlog_get_iclog_buffer_size(mp, log);
 
 	spin_lock_init(&log->l_icloglock);
@@ -3871,23 +3865,3 @@ xfs_log_check_lsn(
 
 	return valid;
 }
-
-/*
- * Notify the log that we're about to start using a feature that is protected
- * by a log incompat feature flag.  This will prevent log covering from
- * clearing those flags.
- */
-void
-xlog_use_incompat_feat(
-	struct xlog		*log)
-{
-	down_read(&log->l_incompat_users);
-}
-
-/* Notify the log that we've finished using log incompat features. */
-void
-xlog_drop_incompat_feat(
-	struct xlog		*log)
-{
-	up_read(&log->l_incompat_users);
-}
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 2728886c29639..d69acf881153d 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -159,8 +159,6 @@ bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
 bool	  xlog_force_shutdown(struct xlog *log, uint32_t shutdown_flags);
 
-void xlog_use_incompat_feat(struct xlog *log);
-void xlog_drop_incompat_feat(struct xlog *log);
 int xfs_attr_use_log_assist(struct xfs_mount *mp);
 
 #endif	/* __XFS_LOG_H__ */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index e30c06ec20e33..43881575cd498 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -450,9 +450,6 @@ struct xlog {
 	xfs_lsn_t		l_recovery_lsn;
 
 	uint32_t		l_iclog_roundoff;/* padding roundoff */
-
-	/* Users of log incompat features should take a read lock. */
-	struct rw_semaphore	l_incompat_users;
 };
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 13f1d2e915405..346ad9fceca73 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3496,21 +3496,6 @@ xlog_recover_finish(
 	 */
 	xfs_log_force(log->l_mp, XFS_LOG_SYNC);
 
-	/*
-	 * Now that we've recovered the log and all the intents, we can clear
-	 * the log incompat feature bits in the superblock because there's no
-	 * longer anything to protect.  We rely on the AIL push to write out the
-	 * updated superblock after everything else.
-	 */
-	if (xfs_clear_incompat_log_features(log->l_mp)) {
-		error = xfs_sync_sb(log->l_mp, false);
-		if (error < 0) {
-			xfs_alert(log->l_mp,
-	"Failed to clear log incompat features on recovery");
-			goto out_error;
-		}
-	}
-
 	xlog_recover_process_iunlinks(log);
 
 	/*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index df370eb5dc15e..d37ba10f5fa33 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1095,6 +1095,11 @@ xfs_unmountfs(
 				"Freespace may not be correct on next mount.");
 	xfs_unmount_check(mp);
 
+	/*
+	 * Indicate that it's ok to clear log incompat bits before cleaning
+	 * the log and writing the unmount record.
+	 */
+	xfs_set_done_with_log_incompat(mp);
 	xfs_log_unmount(mp);
 	xfs_da_unmount(mp);
 	xfs_uuid_unmount(mp);
@@ -1364,7 +1369,8 @@ xfs_clear_incompat_log_features(
 	if (!xfs_has_crc(mp) ||
 	    !xfs_sb_has_incompat_log_feature(&mp->m_sb,
 				XFS_SB_FEAT_INCOMPAT_LOG_ALL) ||
-	    xfs_is_shutdown(mp))
+	    xfs_is_shutdown(mp) ||
+	    !xfs_is_done_with_log_incompat(mp))
 		return false;
 
 	/*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e880aa48de68b..6ec038b88454c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -412,6 +412,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
 #define XFS_OPSTATE_WARNED_LARP		9
 /* Mount time quotacheck is running */
 #define XFS_OPSTATE_QUOTACHECK_RUNNING	10
+/* Do we want to clear log incompat flags? */
+#define XFS_OPSTATE_UNSET_LOG_INCOMPAT	11
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -439,6 +441,7 @@ __XFS_IS_OPSTATE(quotacheck_running, QUOTACHECK_RUNNING)
 #else
 # define xfs_is_quotacheck_running(mp)	(false)
 #endif
+__XFS_IS_OPSTATE(done_with_log_incompat, UNSET_LOG_INCOMPAT)
 
 static inline bool
 xfs_should_warn(struct xfs_mount *mp, long nr)
@@ -457,7 +460,8 @@ xfs_should_warn(struct xfs_mount *mp, long nr)
 	{ (1UL << XFS_OPSTATE_WARNED_SCRUB),		"wscrub" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_SHRINK),		"wshrink" }, \
 	{ (1UL << XFS_OPSTATE_WARNED_LARP),		"wlarp" }, \
-	{ (1UL << XFS_OPSTATE_QUOTACHECK_RUNNING),	"quotacheck" }
+	{ (1UL << XFS_OPSTATE_QUOTACHECK_RUNNING),	"quotacheck" }, \
+	{ (1UL << XFS_OPSTATE_UNSET_LOG_INCOMPAT),	"unset_log_incompat" }
 
 /*
  * Max and min values for mount-option defined I/O
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 364104e1b38ae..4ebf7052eb673 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -22,10 +22,7 @@
 
 /*
  * Get permission to use log-assisted atomic exchange of file extents.
- *
- * Callers must not be running any transactions or hold any inode locks, and
- * they must release the permission by calling xlog_drop_incompat_feat
- * when they're done.
+ * Callers must not be running any transactions or hold any ILOCKs.
  */
 static inline int
 xfs_attr_grab_log_assist(
@@ -33,16 +30,7 @@ xfs_attr_grab_log_assist(
 {
 	int			error = 0;
 
-	/*
-	 * Protect ourselves from an idle log clearing the logged xattrs log
-	 * incompat feature bit.
-	 */
-	xlog_use_incompat_feat(mp->m_log);
-
-	/*
-	 * If log-assisted xattrs are already enabled, the caller can use the
-	 * log assisted swap functions with the log-incompat reference we got.
-	 */
+	/* xattr update log intent items are already enabled */
 	if (xfs_sb_version_haslogxattrs(&mp->m_sb))
 		return 0;
 
@@ -52,31 +40,19 @@ xfs_attr_grab_log_assist(
 	 * a V5 filesystem for the superblock field, but we'll require rmap
 	 * or reflink to avoid having to deal with really old kernels.
 	 */
-	if (!xfs_has_reflink(mp) && !xfs_has_rmapbt(mp)) {
-		error = -EOPNOTSUPP;
-		goto drop_incompat;
-	}
+	if (!xfs_has_reflink(mp) && !xfs_has_rmapbt(mp))
+		return -EOPNOTSUPP;
 
 	/* Enable log-assisted xattrs. */
 	error = xfs_add_incompat_log_feature(mp,
 			XFS_SB_FEAT_INCOMPAT_LOG_XATTRS);
 	if (error)
-		goto drop_incompat;
+		return error;
 
 	xfs_warn_mount(mp, XFS_OPSTATE_WARNED_LARP,
  "EXPERIMENTAL logged extended attributes feature in use. Use at your own risk!");
 
 	return 0;
-drop_incompat:
-	xlog_drop_incompat_feat(mp->m_log);
-	return error;
-}
-
-static inline void
-xfs_attr_rele_log_assist(
-	struct xfs_mount	*mp)
-{
-	xlog_drop_incompat_feat(mp->m_log);
 }
 
 static inline bool
@@ -100,7 +76,6 @@ xfs_attr_change(
 	struct xfs_da_args	*args)
 {
 	struct xfs_mount	*mp = args->dp->i_mount;
-	bool			use_logging = false;
 	int			error;
 
 	ASSERT(!(args->op_flags & XFS_DA_OP_LOGGED));
@@ -111,14 +86,9 @@ xfs_attr_change(
 			return error;
 
 		args->op_flags |= XFS_DA_OP_LOGGED;
-		use_logging = true;
 	}
 
-	error = xfs_attr_set(args);
-
-	if (use_logging)
-		xfs_attr_rele_log_assist(mp);
-	return error;
+	return xfs_attr_set(args);
 }
 
 


