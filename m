Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1F9699E44
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Feb 2023 21:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjBPUvb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Feb 2023 15:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBPUva (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:51:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8C84C3C3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:51:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2D10B82962
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFBBC433D2;
        Thu, 16 Feb 2023 20:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580686;
        bh=b/SqUFqjr3F2BfGlfHFu0X0sVMyqsSboDTNa+uPT0bk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ryuBj97LxLBGoIU0Tlp61p0LtuEVdgCpv8AI0wcD9Ht1ARcJ289UtNN3/KDBEsHXa
         l77v4b5L2kJybIoaNgFCpnag9nxbGhkcoV/ZDeakZbV0h4jzkX6VF0KUdhUP5+xNNx
         gPpy3PdglbQ7oJgeAkl50A3Ih3SWWaijDS0xE+6Yz5jpEQU2CjuMHybYLHphwQGBJP
         8aFejpb4VBxF5i9CBXKYqLfcO3VurkGvUrOGjEnyCyeM85+YdnUCJThxxxr2CPXh/U
         3AsZGfgX/j0Om6WIt7xQvyhYhc9xJD4XQtIcQzz0DBCq0mD0TyVpwR8fiOE+OtyQQq
         dS/97lvuuLafA==
Date:   Thu, 16 Feb 2023 12:51:26 -0800
Subject: [PATCH 2/2] xfs: deferred scrub of dirents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657875560.3475324.7202386445865446029.stgit@magnolia>
In-Reply-To: <167657875530.3475324.17245553975507455352.stgit@magnolia>
References: <167657875530.3475324.17245553975507455352.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the trylock-based parent pointer check fails, retain those dirents
and check them at the end.  This may involve dropping the locks on the
file being scanned, so yay.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir.c   |  237 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h |    2 
 2 files changed, 237 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 39ae59eb4f40..3f3223e563ae 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -22,6 +22,10 @@
 #include "scrub/dabtree.h"
 #include "scrub/readdir.h"
 #include "scrub/repair.h"
+#include "scrub/trace.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/xfblob.h"
 
 /* Set us up to scrub directories. */
 int
@@ -41,6 +45,21 @@ xchk_setup_directory(
 
 /* Directories */
 
+/* Deferred directory entry that we saved for later. */
+struct xchk_dirent {
+	/* Cookie for retrieval of the dirent name. */
+	xfblob_cookie			name_cookie;
+
+	/* Child inode number. */
+	xfs_ino_t			ino;
+
+	/* Directory offset. */
+	xfs_dir2_dataptr_t		diroffset;
+
+	/* Length of the pptr name. */
+	uint8_t				namelen;
+};
+
 struct xchk_dir {
 	struct xfs_scrub	*sc;
 
@@ -50,6 +69,15 @@ struct xchk_dir {
 	/* xattr key and da args for parent pointer validation. */
 	struct xfs_parent_scratch pptr_scratch;
 
+	/* Fixed-size array of xchk_dirent structures. */
+	struct xfarray		*dir_entries;
+
+	/* Blobs containing dirent names. */
+	struct xfblob		*dir_names;
+
+	/* If we've cycled the ILOCK, we must revalidate deferred dirents. */
+	bool			need_revalidate;
+
 	/* Name buffer for pptr validation and dirent revalidation. */
 	uint8_t			namebuf[MAXNAMELEN];
 
@@ -167,8 +195,25 @@ xchk_dir_check_pptr_fast(
 	/* Try to lock the inode. */
 	lockmode = xchk_dir_lock_child(sc, ip);
 	if (!lockmode) {
-		xchk_set_incomplete(sc);
-		return -ECANCELED;
+		struct xchk_dirent	save_de = {
+			.namelen	= name->len,
+			.ino		= ip->i_ino,
+			.diroffset	= dapos,
+		};
+
+		/* Couldn't lock the inode, so save the dirent for later. */
+		trace_xchk_dir_defer(sc->ip, name->name, name->len, ip->i_ino);
+
+		error = xfblob_store(sd->dir_names, &save_de.name_cookie,
+				name->name, name->len);
+		if (xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+			return error;
+
+		error = xfarray_append(sd->dir_entries, &save_de);
+		if (xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+			return error;
+
+		return 0;
 	}
 
 	error = xchk_dir_parent_pointer(sd, dapos, name, ip);
@@ -878,6 +923,164 @@ xchk_directory_blocks(
 	return error;
 }
 
+/*
+ * Revalidate a dirent that we collected in the past but couldn't check because
+ * of lock contention.  Returns 0 if the dirent is still valid, -ENOENT if it
+ * has gone away on us, or a negative errno.
+ */
+STATIC int
+xchk_dir_revalidate_dirent(
+	struct xchk_dir		*sd,
+	const struct xfs_name	*xname,
+	xfs_ino_t		ino,
+	xfs_dir2_dataptr_t	diroffset)
+{
+	struct xfs_scrub	*sc = sd->sc;
+	xfs_ino_t		child_ino;
+	xfs_dir2_dataptr_t	child_diroffset = XFS_DIR2_NULL_DATAPTR;
+	int			error;
+
+	error = xchk_dir_lookup(sc, sc->ip, xname, &child_ino,
+			&child_diroffset);
+	if (error == -ENOENT) {
+		/* Directory entry went away, nothing to revalidate. */
+		return -ENOENT;
+	}
+	if (error)
+		return error;
+
+	/* The inode number changed, nothing to revalidate. */
+	if (ino != child_ino)
+		return -ENOENT;
+
+	/* The directory offset changed, nothing to revalidate. */
+	if (diroffset != child_diroffset)
+		return -ENOENT;
+
+	return 0;
+}
+
+/*
+ * Check a directory entry's parent pointers the slow way, which means we cycle
+ * locks a bunch and put up with revalidation until we get it done.
+ */
+STATIC int
+xchk_dir_slow_dirent(
+	struct xchk_dir		*sd,
+	struct xchk_dirent	*dirent)
+{
+	struct xfs_name		xname = {
+		.name		= sd->namebuf,
+		.len		= dirent->namelen,
+	};
+	struct xfs_scrub	*sc = sd->sc;
+	struct xfs_inode	*ip;
+	unsigned int		lockmode;
+	int			error;
+
+	/* Check that the deferred dirent still exists. */
+	if (sd->need_revalidate) {
+		error = xchk_dir_revalidate_dirent(sd, &xname, dirent->ino,
+				dirent->diroffset);
+		if (error == -ENOENT)
+			return 0;
+		if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
+					&error))
+			return error;
+	}
+
+	error = xchk_iget(sc, dirent->ino, &ip);
+	if (error == -EINVAL || error == -ENOENT) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return 0;
+	}
+	if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0, &error))
+		return error;
+
+	/*
+	 * If we can grab both IOLOCK and ILOCK of the alleged child, we can
+	 * proceed with the validation.
+	 */
+	lockmode = xchk_dir_lock_child(sc, ip);
+	if (lockmode)
+		goto check_pptr;
+
+	/*
+	 * We couldn't lock the child file.  Drop all the locks and try to
+	 * get them again, one at a time.
+	 */
+	xchk_iunlock(sc, sc->ilock_flags);
+	sd->need_revalidate = true;
+
+	trace_xchk_dir_slowpath(sc->ip, xname.name, xname.len, ip->i_ino);
+
+	while (true) {
+		xchk_ilock(sc, XFS_IOLOCK_EXCL);
+		if (xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
+			xchk_ilock(sc, XFS_ILOCK_EXCL);
+			if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
+				break;
+			}
+			xchk_iunlock(sc, XFS_ILOCK_EXCL);
+		}
+		xchk_iunlock(sc, XFS_IOLOCK_EXCL);
+
+		if (xchk_should_terminate(sc, &error))
+			goto out_rele;
+
+		delay(1);
+	}
+	lockmode = XFS_IOLOCK_SHARED | XFS_ILOCK_EXCL;
+
+	/* Revalidate, since we just cycled the locks. */
+	error = xchk_dir_revalidate_dirent(sd, &xname, dirent->ino,
+			dirent->diroffset);
+	if (error == -ENOENT)
+		goto out_unlock;
+	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
+		goto out_unlock;
+
+check_pptr:
+	error = xchk_dir_parent_pointer(sd, dirent->diroffset, &xname, ip);
+out_unlock:
+	xfs_iunlock(ip, lockmode);
+out_rele:
+	xchk_irele(sc, ip);
+	return error;
+}
+
+/* Check all the dirents that we deferred the first time around. */
+STATIC int
+xchk_dir_finish_slow_dirents(
+	struct xchk_dir		*sd)
+{
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	foreach_xfarray_idx(sd->dir_entries, array_cur) {
+		struct xchk_dirent	dirent;
+
+		if (sd->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+			return 0;
+
+		error = xfarray_load(sd->dir_entries, array_cur, &dirent);
+		if (error)
+			return error;
+
+		error = xfblob_load(sd->dir_names, dirent.name_cookie,
+				sd->namebuf, dirent.namelen);
+		if (error)
+			return error;
+		sd->namebuf[MAXNAMELEN - 1] = 0;
+
+		error = xchk_dir_slow_dirent(sd, &dirent);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
 /* Scrub a whole directory. */
 int
 xchk_directory(
@@ -916,11 +1119,41 @@ xchk_directory(
 		return -ENOMEM;
 	sd->sc = sc;
 
+	if (xfs_has_parent(sc->mp)) {
+		/*
+		 * Set up some staging memory for dirents that we can't check
+		 * due to locking contention.
+		 */
+		error = xfarray_create(sc->mp, "directory entries", 0,
+				sizeof(struct xchk_dirent), &sd->dir_entries);
+		if (error)
+			goto out_sd;
+
+		error = xfblob_create(sc->mp, "dirent names", &sd->dir_names);
+		if (error)
+			goto out_entries;
+	}
+
 	/* Look up every name in this directory by hash. */
 	error = xchk_dir_walk(sc, sc->ip, xchk_dir_actor, sd);
 	if (error == -ECANCELED)
 		error = 0;
+	if (error)
+		goto out_names;
 
+	if (xfs_has_parent(sc->mp)) {
+		error = xchk_dir_finish_slow_dirents(sd);
+		if (error)
+			goto out_names;
+	}
+
+out_names:
+	if (sd->dir_names)
+		xfblob_destroy(sd->dir_names);
+out_entries:
+	if (sd->dir_entries)
+		xfarray_destroy(sd->dir_entries);
+out_sd:
 	kvfree(sd);
 	return error;
 }
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index e536d070f9c7..911d947db787 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -962,6 +962,8 @@ DEFINE_EVENT(xchk_pptr_class, name, \
 	TP_ARGS(ip, name, namelen, parent_ino))
 DEFINE_XCHK_PPTR_CLASS(xchk_parent_defer);
 DEFINE_XCHK_PPTR_CLASS(xchk_parent_slowpath);
+DEFINE_XCHK_PPTR_CLASS(xchk_dir_defer);
+DEFINE_XCHK_PPTR_CLASS(xchk_dir_slowpath);
 
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)

