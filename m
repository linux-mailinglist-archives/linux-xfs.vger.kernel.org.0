Return-Path: <linux-xfs+bounces-5256-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 352CF87F295
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Mar 2024 22:51:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87872B21A14
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Mar 2024 21:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B8CC5A4E9;
	Mon, 18 Mar 2024 21:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6l3yUuj"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D315A4E3
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798684; cv=none; b=eOMtqBugpPhqYTKmRwjv0Cp8Dk+TLvTw1VSrr9AnVM4jA55n5pbaL2UtI+GRjW/jdWS3812LaeTk+acGtwY291iseW2sJu1wly5X04JMEaif4qwcM+Fd5Rnt2MI5iKe4LCw7BoM4d0plXVoiXPbLKyA9y4sAbZkIdhnsk/g75lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798684; c=relaxed/simple;
	bh=TRkpZV9kMJzsD6JhH2Myy0fAsZeyyuwAp+ZRc3oDu14=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eOSxk0W8ISMd75du1bfYEy3/VXOpvMtSvltuNW99XIlFVqyr2ZjzelDyIPxkdU45Cb1cwzfacHR6QpCwXpeNVVZxmfXknIeRY4TOZyrm8ar5s3kMfNsFmzWHazTNo9FRDC1hZ6W0fXk6eCckcmDb0rwb75JBklFNSF5XfiQ1Qzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6l3yUuj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8530AC433F1;
	Mon, 18 Mar 2024 21:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798683;
	bh=TRkpZV9kMJzsD6JhH2Myy0fAsZeyyuwAp+ZRc3oDu14=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n6l3yUujkohfeVdCxLmesJ0+Jh3VjJAaolwCZzLYmHNQ6I7z3uAXW7GBykKVc3GJw
	 RIgQ1SCZLUFgN7BKJxpHgQqohw+A3+iqykAmI4lhUGZbnFhFpDvc9Th751IOX4jSgQ
	 QnxzEohKqgkJPhRcYYhSCXdMU/QH7xlg9DruGmPeOmwpRZ0HEIsXQKq/6q2q981mhs
	 Lfrjv2Nti1+9EuzLegO72nxusOKIEmWxH1r1cBiVZ9V6f0TR1L3uQKcdahOf0sc2r3
	 zI528s/wu44h5wHzW8bxriegi9sQmP07i1+CEo7A9NED91tGkc7Od9q6ee2UAI7IcH
	 S5b3p3Xe0ab0g==
Date: Mon, 18 Mar 2024 14:51:23 -0700
Subject: [PATCH 13/23] xfs: implement live updates for directory repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802905.3808642.9375044064218443341.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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

While we're scanning the filesystem for parent pointers that we can turn
into dirents, we cannot hold the IOLOCK or ILOCK of the directory being
repaired.  Therefore, we need to set up a dirent hook so that we can
keep the temporary directory up to date with the rest of the filesystem.
Hence we add the ability to *remove* entries from the temporary dir.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir_repair.c |  221 +++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/scrub/findparent.c |   10 +-
 fs/xfs/scrub/findparent.h |   10 ++
 fs/xfs/scrub/trace.h      |    2 
 4 files changed, 220 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index caa92a7c4563b..845540d2cf4d3 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -85,6 +85,12 @@
  * other threads.
  */
 
+/* Create a dirent in the tempdir. */
+#define XREP_DIRENT_ADD		(1)
+
+/* Remove a dirent from the tempdir. */
+#define XREP_DIRENT_REMOVE	(2)
+
 /* Directory entry to be restored in the new directory. */
 struct xrep_dirent {
 	/* Cookie for retrieval of the dirent name. */
@@ -98,6 +104,9 @@ struct xrep_dirent {
 
 	/* File type of the dirent. */
 	uint8_t			ftype;
+
+	/* XREP_DIRENT_{ADD,REMOVE} */
+	uint8_t			action;
 };
 
 /*
@@ -341,6 +350,7 @@ xrep_dir_stash_createname(
 	xfs_ino_t		ino)
 {
 	struct xrep_dirent	dirent = {
+		.action		= XREP_DIRENT_ADD,
 		.ino		= ino,
 		.namelen	= name->len,
 		.ftype		= name->type,
@@ -357,6 +367,34 @@ xrep_dir_stash_createname(
 	return xfarray_append(rd->dir_entries, &dirent);
 }
 
+/*
+ * Remember that we want to remove a dirent from the tempdir.  These stashed
+ * actions will be replayed later.
+ */
+STATIC int
+xrep_dir_stash_removename(
+	struct xrep_dir		*rd,
+	const struct xfs_name	*name,
+	xfs_ino_t		ino)
+{
+	struct xrep_dirent	dirent = {
+		.action		= XREP_DIRENT_REMOVE,
+		.ino		= ino,
+		.namelen	= name->len,
+		.ftype		= name->type,
+	};
+	int			error;
+
+	trace_xrep_dir_stash_removename(rd->sc->tempip, name, ino);
+
+	error = xfblob_store(rd->dir_names, &dirent.name_cookie, name->name,
+			name->len);
+	if (error)
+		return error;
+
+	return xfarray_append(rd->dir_entries, &dirent);
+}
+
 /* Allocate an in-core record to hold entries while we rebuild the dir data. */
 STATIC int
 xrep_dir_salvage_entry(
@@ -708,6 +746,43 @@ xrep_dir_replay_createname(
 	return xfs_dir2_node_addname(&rd->args);
 }
 
+/* Replay a stashed removename onto the temporary directory. */
+STATIC int
+xrep_dir_replay_removename(
+	struct xrep_dir		*rd,
+	const struct xfs_name	*name,
+	xfs_extlen_t		total)
+{
+	struct xfs_inode	*dp = rd->args.dp;
+	bool			is_block, is_leaf;
+	int			error;
+
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+
+	xrep_dir_init_args(rd, dp, name);
+	rd->args.op_flags = 0;
+	rd->args.total = total;
+
+	trace_xrep_dir_replay_removename(dp, name, 0);
+
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return xfs_dir2_sf_removename(&rd->args);
+
+	error = xfs_dir2_isblock(&rd->args, &is_block);
+	if (error)
+		return error;
+	if (is_block)
+		return xfs_dir2_block_removename(&rd->args);
+
+	error = xfs_dir2_isleaf(&rd->args, &is_leaf);
+	if (error)
+		return error;
+	if (is_leaf)
+		return xfs_dir2_leaf_removename(&rd->args);
+
+	return xfs_dir2_node_removename(&rd->args);
+}
+
 /*
  * Add this stashed incore directory entry to the temporary directory.
  * The caller must hold the tempdir's IOLOCK, must not hold any ILOCKs, and
@@ -739,26 +814,64 @@ xrep_dir_replay_update(
 	xrep_tempfile_ilock(rd->sc);
 	xfs_trans_ijoin(rd->sc->tp, rd->sc->tempip, 0);
 
-	/*
-	 * Create a replacement dirent in the temporary directory.  Note that
-	 * _createname doesn't check for existing entries.  There shouldn't be
-	 * any in the temporary dir, but we'll verify this in debug mode.
-	 */
+	switch (dirent->action) {
+	case XREP_DIRENT_ADD:
+		/*
+		 * Create a replacement dirent in the temporary directory.
+		 * Note that _createname doesn't check for existing entries.
+		 * There shouldn't be any in the temporary dir, but we'll
+		 * verify this in debug mode.
+		 */
 #ifdef DEBUG
-	error = xchk_dir_lookup(rd->sc, rd->sc->tempip, &name, &ino);
-	if (error != -ENOENT) {
-		ASSERT(error != -ENOENT);
+		error = xchk_dir_lookup(rd->sc, rd->sc->tempip, &name, &ino);
+		if (error != -ENOENT) {
+			ASSERT(error != -ENOENT);
+			goto out_cancel;
+		}
+#endif
+
+		error = xrep_dir_replay_createname(rd, &name, dirent->ino,
+				resblks);
+		if (error)
+			goto out_cancel;
+
+		if (name.type == XFS_DIR3_FT_DIR)
+			rd->subdirs++;
+		rd->dirents++;
+		break;
+	case XREP_DIRENT_REMOVE:
+		/*
+		 * Remove a dirent from the temporary directory.  Note that
+		 * _removename doesn't check the inode target of the exist
+		 * entry.  There should be a perfect match in the temporary
+		 * dir, but we'll verify this in debug mode.
+		 */
+#ifdef DEBUG
+		error = xchk_dir_lookup(rd->sc, rd->sc->tempip, &name, &ino);
+		if (error) {
+			ASSERT(error != 0);
+			goto out_cancel;
+		}
+		if (ino != dirent->ino) {
+			ASSERT(ino == dirent->ino);
+			error = -EIO;
+			goto out_cancel;
+		}
+#endif
+
+		error = xrep_dir_replay_removename(rd, &name, resblks);
+		if (error)
+			goto out_cancel;
+
+		if (name.type == XFS_DIR3_FT_DIR)
+			rd->subdirs--;
+		rd->dirents--;
+		break;
+	default:
+		ASSERT(0);
+		error = -EIO;
 		goto out_cancel;
 	}
-#endif
-
-	error = xrep_dir_replay_createname(rd, &name, dirent->ino, resblks);
-	if (error)
-		goto out_cancel;
-
-	if (name.type == XFS_DIR3_FT_DIR)
-		rd->subdirs++;
-	rd->dirents++;
 
 	/* Commit and unlock. */
 	error = xrep_trans_commit(rd->sc);
@@ -1278,6 +1391,71 @@ xrep_dir_scan_dirtree(
 	return 0;
 }
 
+/*
+ * Capture dirent updates being made by other threads which are relevant to the
+ * directory being repaired.
+ */
+STATIC int
+xrep_dir_live_update(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_dir_update_params	*p = data;
+	struct xrep_dir			*rd;
+	struct xfs_scrub		*sc;
+	int				error = 0;
+
+	rd = container_of(nb, struct xrep_dir, pscan.dhook.dirent_hook.nb);
+	sc = rd->sc;
+
+	/*
+	 * This thread updated a child dirent in the directory that we're
+	 * rebuilding.  Stash the update for replay against the temporary
+	 * directory.
+	 */
+	if (p->dp->i_ino == sc->ip->i_ino &&
+	    xchk_iscan_want_live_update(&rd->pscan.iscan, p->ip->i_ino)) {
+		mutex_lock(&rd->pscan.lock);
+		if (p->delta > 0)
+			error = xrep_dir_stash_createname(rd, p->name,
+					p->ip->i_ino);
+		else
+			error = xrep_dir_stash_removename(rd, p->name,
+					p->ip->i_ino);
+		mutex_unlock(&rd->pscan.lock);
+		if (error)
+			goto out_abort;
+	}
+
+	/*
+	 * This thread updated another directory's child dirent that points to
+	 * the directory that we're rebuilding, so remember the new dotdot
+	 * target.
+	 */
+	if (p->ip->i_ino == sc->ip->i_ino &&
+	    xchk_iscan_want_live_update(&rd->pscan.iscan, p->dp->i_ino)) {
+		if (p->delta > 0) {
+			trace_xrep_dir_stash_createname(sc->tempip,
+					&xfs_name_dotdot,
+					p->dp->i_ino);
+
+			xrep_findparent_scan_found(&rd->pscan, p->dp->i_ino);
+		} else {
+			trace_xrep_dir_stash_removename(sc->tempip,
+					&xfs_name_dotdot,
+					rd->pscan.parent_ino);
+
+			xrep_findparent_scan_found(&rd->pscan, NULLFSINO);
+		}
+	}
+
+	return NOTIFY_DONE;
+out_abort:
+	xchk_iscan_abort(&rd->pscan.iscan);
+	return NOTIFY_DONE;
+}
+
 /*
  * Free all the directory blocks and reset the data fork.  The caller must
  * join the inode to the transaction.  This function returns with the inode
@@ -1627,6 +1805,9 @@ xrep_dir_rebuild_tree(
 	if (error)
 		return error;
 
+	if (xchk_iscan_aborted(&rd->pscan.iscan))
+		return -ECANCELED;
+
 	/*
 	 * Exchange the tempdir's data fork with the file being repaired.  This
 	 * recreates the transaction and re-takes the ILOCK in the scrub
@@ -1682,7 +1863,11 @@ xrep_dir_setup_scan(
 	if (error)
 		goto out_xfarray;
 
-	error = xrep_findparent_scan_start(sc, &rd->pscan);
+	if (xfs_has_parent(sc->mp))
+		error = __xrep_findparent_scan_start(sc, &rd->pscan,
+				xrep_dir_live_update);
+	else
+		error = xrep_findparent_scan_start(sc, &rd->pscan);
 	if (error)
 		goto out_xfblob;
 
diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index 712dd73e4789f..c78422ad757bf 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -238,9 +238,10 @@ xrep_findparent_live_update(
  * will be called when there is a dotdot update for the inode being repaired.
  */
 int
-xrep_findparent_scan_start(
+__xrep_findparent_scan_start(
 	struct xfs_scrub		*sc,
-	struct xrep_parent_scan_info	*pscan)
+	struct xrep_parent_scan_info	*pscan,
+	notifier_fn_t			custom_fn)
 {
 	int				error;
 
@@ -262,7 +263,10 @@ xrep_findparent_scan_start(
 	 * ILOCK, which means that any in-progress inode updates will finish
 	 * before we can scan the inode.
 	 */
-	xfs_dir_hook_setup(&pscan->dhook, xrep_findparent_live_update);
+	if (custom_fn)
+		xfs_dir_hook_setup(&pscan->dhook, custom_fn);
+	else
+		xfs_dir_hook_setup(&pscan->dhook, xrep_findparent_live_update);
 	error = xfs_dir_hook_add(sc->mp, &pscan->dhook);
 	if (error)
 		goto out_iscan;
diff --git a/fs/xfs/scrub/findparent.h b/fs/xfs/scrub/findparent.h
index 501f99d3164ed..d998c7a88152c 100644
--- a/fs/xfs/scrub/findparent.h
+++ b/fs/xfs/scrub/findparent.h
@@ -24,8 +24,14 @@ struct xrep_parent_scan_info {
 	bool			lookup_parent;
 };
 
-int xrep_findparent_scan_start(struct xfs_scrub *sc,
-		struct xrep_parent_scan_info *pscan);
+int __xrep_findparent_scan_start(struct xfs_scrub *sc,
+		struct xrep_parent_scan_info *pscan,
+		notifier_fn_t custom_fn);
+static inline int xrep_findparent_scan_start(struct xfs_scrub *sc,
+		struct xrep_parent_scan_info *pscan)
+{
+	return __xrep_findparent_scan_start(sc, pscan, NULL);
+}
 int xrep_findparent_scan(struct xrep_parent_scan_info *pscan);
 void xrep_findparent_scan_teardown(struct xrep_parent_scan_info *pscan);
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 46e2ded8b77fb..8d212406a7461 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2687,6 +2687,8 @@ DEFINE_XREP_DIRENT_EVENT(xrep_dir_salvage_entry);
 DEFINE_XREP_DIRENT_EVENT(xrep_dir_stash_createname);
 DEFINE_XREP_DIRENT_EVENT(xrep_dir_replay_createname);
 DEFINE_XREP_DIRENT_EVENT(xrep_adoption_reparent);
+DEFINE_XREP_DIRENT_EVENT(xrep_dir_stash_removename);
+DEFINE_XREP_DIRENT_EVENT(xrep_dir_replay_removename);
 
 DECLARE_EVENT_CLASS(xrep_adoption_class,
 	TP_PROTO(struct xfs_inode *dp, struct xfs_inode *ip, bool moved),


