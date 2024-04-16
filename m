Return-Path: <linux-xfs+bounces-6747-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4C2D8A5EE1
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Apr 2024 01:53:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B90131C20CA0
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Apr 2024 23:53:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 319D1159200;
	Mon, 15 Apr 2024 23:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C4VqPJF8"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E443F157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225184; cv=none; b=Uk6DThdhPpeh5XlU1f5In+Y3n709easvp3MRttKQnIiKbpUZNfmGAvoXhI4/EcvjiN5UqhBmhVLL/kRlemlDcKUeHUI0YJSX3K8jfmiYEa5+xBjyZmoa4NClPaKmKRUP4/47IoQE37bZJZUxobdw34R+MWwQeIyjzkKzM6H9r0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225184; c=relaxed/simple;
	bh=PSNq6x5JHkPLmHHC+xZPHCQONM29wg80pvaWzpIvZBI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G/lfgg32Y/XXJTcjqLrS0PZZ14/Uj2RRQ++8ljs0zmRpL1C4/bG5Lv9HgZg8NcDprkqVmCd7w9qTOftlIOVuj8J9S+qdhd6Brqlmy3TIwZHvzKpb7e8Jy27bbgG5sU8JuAlSc4n5r1DeGlFRXDZz/OzRUlM5ecsoKoVbg78Gi80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C4VqPJF8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D17C113CC;
	Mon, 15 Apr 2024 23:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225183;
	bh=PSNq6x5JHkPLmHHC+xZPHCQONM29wg80pvaWzpIvZBI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C4VqPJF8g0Au6f9hc58ojS4hXYiSCxRqKzMfyrlEFE625D54AYis7IE7AOSHCNf75
	 qi4iR6haHjQu35RGzcnAzl5lYxkSC3+MZ7CazBO0cp1dKkJW/pM7p6bNR1b7fZRggK
	 82EfZjlrUC735I/5bZ+uRig3Ml9aor1SAJHLAsPCRljgRVJ3/wzDy+cDaljwIb8Ns+
	 TMRh5I0Qa1vDVVbXXeNEeDCLwPXPRnghojqCW3r8yCknhFuPTVj/BFOx7sF2Z+4f7/
	 s0ghcpjr+AUhWgFkN8i3lds7+KYhpi7FJfGA7qdHJZmd52IDI8INjQxVgHwYX25r0F
	 auMwtDZiFBo7w==
Date: Mon, 15 Apr 2024 16:53:02 -0700
Subject: [PATCH 1/3] xfs: move orphan files to the orphanage
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322384290.89422.14102656947249313726.stgit@frogsfrogsfrogs>
In-Reply-To: <171322384265.89422.12835876074903686240.stgit@frogsfrogsfrogs>
References: <171322384265.89422.12835876074903686240.stgit@frogsfrogsfrogs>
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

When we're repairing a directory structure or fixing the dotdot entry of
a subdirectory, it's possible that we won't ever find a parent for the
subdirectory.  When this is the case, move it to the orphanage, aka
/lost+found.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |   19 +
 fs/xfs/Makefile                                    |    1 
 fs/xfs/scrub/dir_repair.c                          |  130 +++++
 fs/xfs/scrub/orphanage.c                           |  498 ++++++++++++++++++++
 fs/xfs/scrub/orphanage.h                           |   75 +++
 fs/xfs/scrub/parent_repair.c                       |  100 ++++
 fs/xfs/scrub/scrub.c                               |    2 
 fs/xfs/scrub/scrub.h                               |    4 
 fs/xfs/scrub/trace.h                               |   28 +
 fs/xfs/xfs_inode.c                                 |    6 
 fs/xfs/xfs_inode.h                                 |    1 
 11 files changed, 844 insertions(+), 20 deletions(-)
 create mode 100644 fs/xfs/scrub/orphanage.c
 create mode 100644 fs/xfs/scrub/orphanage.h


diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
index 3afa1bc5f47c..37dddaaeda50 100644
--- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
+++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
@@ -4778,14 +4778,21 @@ Orphaned files are adopted by the orphanage as follows:
    The ``xrep_orphanage_iolock_two`` function follows the inode locking
    strategy discussed earlier.
 
-3. Call ``xrep_orphanage_compute_blkres`` and ``xrep_orphanage_compute_name``
-   to compute the new name in the orphanage and the block reservation required.
-
-4. Use ``xrep_orphanage_adoption_prep`` to reserve resources to the repair
+3. Use ``xrep_adoption_trans_alloc`` to reserve resources to the repair
    transaction.
 
-5. Call ``xrep_orphanage_adopt`` to reparent the orphaned file into the lost
-   and found, and update the kernel dentry cache.
+4. Call ``xrep_orphanage_compute_name`` to compute the new name in the
+   orphanage.
+
+5. If the adoption is going to happen, call ``xrep_adoption_reparent`` to
+   reparent the orphaned file into the lost and found and invalidate the dentry
+   cache.
+
+6. Call ``xrep_adoption_finish`` to commit any filesystem updates, release the
+   orphanage ILOCK, and clean the scrub transaction.
+
+7. If a runtime error happens, call ``xrep_adoption_cancel`` to release all
+   resources.
 
 The proposed patches are in the
 `orphanage adoption
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index d48646f86563..1e23d1b3cd7b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -205,6 +205,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   inode_repair.o \
 				   newbt.o \
 				   nlinks_repair.o \
+				   orphanage.o \
 				   parent_repair.o \
 				   rcbag_btree.o \
 				   rcbag.o \
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 34fe720fde0e..c150b2efa2c2 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -42,6 +42,7 @@
 #include "scrub/readdir.h"
 #include "scrub/reap.h"
 #include "scrub/findparent.h"
+#include "scrub/orphanage.h"
 
 /*
  * Directory Repair
@@ -115,12 +116,21 @@ struct xrep_dir {
 	 */
 	struct xrep_parent_scan_info pscan;
 
+	/*
+	 * Context information for attaching this directory to the lost+found
+	 * if this directory does not have a parent.
+	 */
+	struct xrep_adoption	adoption;
+
 	/* How many subdirectories did we find? */
 	uint64_t		subdirs;
 
 	/* How many dirents did we find? */
 	unsigned int		dirents;
 
+	/* Should we move this directory to the orphanage? */
+	bool			needs_adoption;
+
 	/* Directory entry name, plus the trailing null. */
 	struct xfs_name		xname;
 	unsigned char		namebuf[MAXNAMELEN];
@@ -148,6 +158,10 @@ xrep_setup_directory(
 
 	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
 
+	error = xrep_orphanage_try_create(sc);
+	if (error)
+		return error;
+
 	error = xrep_tempfile_create(sc, S_IFDIR);
 	if (error)
 		return error;
@@ -1137,10 +1151,8 @@ xrep_dir_set_nlink(
 	/*
 	 * The directory is not on the incore unlinked list, which means that
 	 * it needs to be reachable via the directory tree.  Update the nlink
-	 * with our observed link count.
-	 *
-	 * XXX: A subsequent patch will handle parentless directories by moving
-	 * them to the lost and found instead of aborting the repair.
+	 * with our observed link count.  If the directory has no parent, it
+	 * will be moved to the orphanage.
 	 */
 	if (!xfs_inode_on_unlinked_list(dp))
 		goto reset_nlink;
@@ -1151,6 +1163,7 @@ xrep_dir_set_nlink(
 	 * inactivate when the last reference drops.
 	 */
 	if (rd->dirents == 0) {
+		rd->needs_adoption = false;
 		new_nlink = 0;
 		goto reset_nlink;
 	}
@@ -1159,7 +1172,8 @@ xrep_dir_set_nlink(
 	 * The directory is on the unlinked list and we found dirents.  This
 	 * directory needs to be reachable via the directory tree.  Remove the
 	 * dir from the unlinked list and update nlink with the observed link
-	 * count.
+	 * count.  If the directory has no parent, it will be moved to the
+	 * orphanage.
 	 */
 	pag = xfs_perag_get(sc->mp, XFS_INO_TO_AGNO(sc->mp, dp->i_ino));
 	if (!pag) {
@@ -1195,12 +1209,16 @@ xrep_dir_swap(
 		return -EFSCORRUPTED;
 
 	/*
-	 * If we never found the parent for this directory, we can't fix this
-	 * directory.
+	 * If we never found the parent for this directory, temporarily assign
+	 * the root dir as the parent; we'll move this to the orphanage after
+	 * exchanging the dir contents.  We hold the ILOCK of the dir being
+	 * repaired, so we're not worried about racy updates of dotdot.
 	 */
 	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
-	if (rd->pscan.parent_ino == NULLFSINO)
-		return -EFSCORRUPTED;
+	if (rd->pscan.parent_ino == NULLFSINO) {
+		rd->needs_adoption = true;
+		rd->pscan.parent_ino = rd->sc->mp->m_sb.sb_rootino;
+	}
 
 	/*
 	 * Reset the temporary directory's '..' entry to point to the parent
@@ -1358,6 +1376,91 @@ xrep_dir_setup_scan(
 	return error;
 }
 
+/*
+ * Move the current file to the orphanage.
+ *
+ * Caller must hold IOLOCK_EXCL on @sc->ip, and no other inode locks.  Upon
+ * successful return, the scrub transaction will have enough extra reservation
+ * to make the move; it will hold IOLOCK_EXCL and ILOCK_EXCL of @sc->ip and the
+ * orphanage; and both inodes will be ijoined.
+ */
+STATIC int
+xrep_dir_move_to_orphanage(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	xfs_ino_t		orig_parent, new_parent;
+	int			error;
+
+	/*
+	 * We are about to drop the ILOCK on sc->ip to lock the orphanage and
+	 * prepare for the adoption.  Therefore, look up the old dotdot entry
+	 * for sc->ip so that we can compare it after we re-lock sc->ip.
+	 */
+	error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot, &orig_parent);
+	if (error)
+		return error;
+
+	/*
+	 * Drop the ILOCK on the scrub target and commit the transaction.
+	 * Adoption computes its own resource requirements and gathers the
+	 * necessary components.
+	 */
+	error = xrep_trans_commit(sc);
+	if (error)
+		return error;
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	/* If we can take the orphanage's iolock then we're ready to move. */
+	if (!xrep_orphanage_ilock_nowait(sc, XFS_IOLOCK_EXCL)) {
+		xchk_iunlock(sc, sc->ilock_flags);
+		error = xrep_orphanage_iolock_two(sc);
+		if (error)
+			return error;
+	}
+
+	/* Grab transaction and ILOCK the two files. */
+	error = xrep_adoption_trans_alloc(sc, &rd->adoption);
+	if (error)
+		return error;
+
+	error = xrep_adoption_compute_name(&rd->adoption, &rd->xname);
+	if (error)
+		return error;
+
+	/*
+	 * Now that we've reacquired the ILOCK on sc->ip, look up the dotdot
+	 * entry again.  If the parent changed or the child was unlinked while
+	 * the child directory was unlocked, we don't need to move the child to
+	 * the orphanage after all.
+	 */
+	error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot, &new_parent);
+	if (error)
+		return error;
+
+	/*
+	 * Attach to the orphanage if we still have a linked directory and it
+	 * hasn't been moved.
+	 */
+	if (orig_parent == new_parent && VFS_I(sc->ip)->i_nlink > 0) {
+		error = xrep_adoption_move(&rd->adoption);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Launder the scrub transaction so we can drop the orphanage ILOCK
+	 * and IOLOCK.  Return holding the scrub target's ILOCK and IOLOCK.
+	 */
+	error = xrep_adoption_trans_roll(&rd->adoption);
+	if (error)
+		return error;
+
+	xrep_orphanage_iunlock(sc, XFS_ILOCK_EXCL);
+	xrep_orphanage_iunlock(sc, XFS_IOLOCK_EXCL);
+	return 0;
+}
+
 /*
  * Repair the directory metadata.
  *
@@ -1396,6 +1499,15 @@ xrep_directory(
 	if (error)
 		goto out_teardown;
 
+	if (rd->needs_adoption) {
+		if (!xrep_orphanage_can_adopt(rd->sc))
+			error = -EFSCORRUPTED;
+		else
+			error = xrep_dir_move_to_orphanage(rd);
+		if (error)
+			goto out_teardown;
+	}
+
 out_teardown:
 	xrep_dir_teardown(sc);
 	return error;
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
new file mode 100644
index 000000000000..41733be3ef45
--- /dev/null
+++ b/fs/xfs/scrub/orphanage.c
@@ -0,0 +1,498 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+#include "xfs_ialloc.h"
+#include "xfs_quota.h"
+#include "xfs_trans_space.h"
+#include "xfs_dir2.h"
+#include "xfs_icache.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/repair.h"
+#include "scrub/trace.h"
+#include "scrub/orphanage.h"
+#include "scrub/readdir.h"
+
+#include <linux/namei.h>
+
+/*
+ * The Orphanage
+ * =============
+ *
+ * If the directory tree is damaged, children of that directory become
+ * inaccessible via that file path.  If a child has no other parents, the file
+ * is said to be orphaned.  xfs_repair fixes this situation by creating a
+ * orphanage directory (specifically, /lost+found) and creating a directory
+ * entry pointing to the orphaned file.
+ *
+ * Online repair follows this tactic by creating a root-owned /lost+found
+ * directory if one does not exist.  If an orphan is found, it will move that
+ * files into orphanage.
+ */
+
+/* Make the orphanage owned by root. */
+STATIC int
+xrep_chown_orphanage(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_dquot	*udqp = NULL, *gdqp = NULL, *pdqp = NULL;
+	struct xfs_dquot	*oldu = NULL, *oldg = NULL, *oldp = NULL;
+	struct inode		*inode = VFS_I(dp);
+	int			error;
+
+	error = xfs_qm_vop_dqalloc(dp, GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, 0,
+			XFS_QMOPT_QUOTALL, &udqp, &gdqp, &pdqp);
+	if (error)
+		return error;
+
+	error = xfs_trans_alloc_ichange(dp, udqp, gdqp, pdqp, true, &tp);
+	if (error)
+		goto out_dqrele;
+
+	/*
+	 * Always clear setuid/setgid/sticky on the orphanage since we don't
+	 * normally want that functionality on this directory and xfs_repair
+	 * doesn't create it this way either.  Leave the other access bits
+	 * unchanged.
+	 */
+	inode->i_mode &= ~(S_ISUID | S_ISGID | S_ISVTX);
+
+	/*
+	 * Change the ownerships and register quota modifications
+	 * in the transaction.
+	 */
+	if (!uid_eq(inode->i_uid, GLOBAL_ROOT_UID)) {
+		if (XFS_IS_UQUOTA_ON(mp))
+			oldu = xfs_qm_vop_chown(tp, dp, &dp->i_udquot, udqp);
+		inode->i_uid = GLOBAL_ROOT_UID;
+	}
+	if (!gid_eq(inode->i_gid, GLOBAL_ROOT_GID)) {
+		if (XFS_IS_GQUOTA_ON(mp))
+			oldg = xfs_qm_vop_chown(tp, dp, &dp->i_gdquot, gdqp);
+		inode->i_gid = GLOBAL_ROOT_GID;
+	}
+	if (dp->i_projid != 0) {
+		if (XFS_IS_PQUOTA_ON(mp))
+			oldp = xfs_qm_vop_chown(tp, dp, &dp->i_pdquot, pdqp);
+		dp->i_projid = 0;
+	}
+
+	dp->i_diflags &= ~(XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT);
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	XFS_STATS_INC(mp, xs_ig_attrchg);
+
+	if (xfs_has_wsync(mp))
+		xfs_trans_set_sync(tp);
+	error = xfs_trans_commit(tp);
+
+	xfs_qm_dqrele(oldu);
+	xfs_qm_dqrele(oldg);
+	xfs_qm_dqrele(oldp);
+
+out_dqrele:
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
+	return error;
+}
+
+#define ORPHANAGE	"lost+found"
+
+/* Create the orphanage directory, and set sc->orphanage to it. */
+int
+xrep_orphanage_create(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct dentry		*root_dentry, *orphanage_dentry;
+	struct inode		*root_inode = VFS_I(sc->mp->m_rootip);
+	struct inode		*orphanage_inode;
+	int			error;
+
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+	if (xfs_is_readonly(mp)) {
+		sc->orphanage = NULL;
+		return 0;
+	}
+
+	ASSERT(sc->tp == NULL);
+	ASSERT(sc->orphanage == NULL);
+
+	/* Find the dentry for the root directory... */
+	root_dentry = d_find_alias(root_inode);
+	if (!root_dentry) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	/* ...which is a directory, right? */
+	if (!d_is_dir(root_dentry)) {
+		error = -EFSCORRUPTED;
+		goto out_dput_root;
+	}
+
+	/* Try to find the orphanage directory. */
+	inode_lock_nested(root_inode, I_MUTEX_PARENT);
+	orphanage_dentry = lookup_one_len(ORPHANAGE, root_dentry,
+			strlen(ORPHANAGE));
+	if (IS_ERR(orphanage_dentry)) {
+		error = PTR_ERR(orphanage_dentry);
+		goto out_unlock_root;
+	}
+
+	/*
+	 * Nothing found?  Call mkdir to create the orphanage.  Create the
+	 * directory without other-user access because we're live and someone
+	 * could have been relying partly on minimal access to a parent
+	 * directory to control access to a file we put in here.
+	 */
+	if (d_really_is_negative(orphanage_dentry)) {
+		error = vfs_mkdir(&nop_mnt_idmap, root_inode, orphanage_dentry,
+				0750);
+		if (error)
+			goto out_dput_orphanage;
+	}
+
+	/* Not a directory? Bail out. */
+	if (!d_is_dir(orphanage_dentry)) {
+		error = -ENOTDIR;
+		goto out_dput_orphanage;
+	}
+
+	/*
+	 * Grab a reference to the orphanage.  This /should/ succeed since
+	 * we hold the root directory locked and therefore nobody can delete
+	 * the orphanage.
+	 */
+	orphanage_inode = igrab(d_inode(orphanage_dentry));
+	if (!orphanage_inode) {
+		error = -ENOENT;
+		goto out_dput_orphanage;
+	}
+
+	/* Make sure the orphanage is owned by root. */
+	error = xrep_chown_orphanage(sc, XFS_I(orphanage_inode));
+	if (error)
+		goto out_dput_orphanage;
+
+	/* Stash the reference for later and bail out. */
+	sc->orphanage = XFS_I(orphanage_inode);
+	sc->orphanage_ilock_flags = 0;
+
+out_dput_orphanage:
+	dput(orphanage_dentry);
+out_unlock_root:
+	inode_unlock(VFS_I(sc->mp->m_rootip));
+out_dput_root:
+	dput(root_dentry);
+out:
+	return error;
+}
+
+void
+xrep_orphanage_ilock(
+	struct xfs_scrub	*sc,
+	unsigned int		ilock_flags)
+{
+	sc->orphanage_ilock_flags |= ilock_flags;
+	xfs_ilock(sc->orphanage, ilock_flags);
+}
+
+bool
+xrep_orphanage_ilock_nowait(
+	struct xfs_scrub	*sc,
+	unsigned int		ilock_flags)
+{
+	if (xfs_ilock_nowait(sc->orphanage, ilock_flags)) {
+		sc->orphanage_ilock_flags |= ilock_flags;
+		return true;
+	}
+
+	return false;
+}
+
+void
+xrep_orphanage_iunlock(
+	struct xfs_scrub	*sc,
+	unsigned int		ilock_flags)
+{
+	xfs_iunlock(sc->orphanage, ilock_flags);
+	sc->orphanage_ilock_flags &= ~ilock_flags;
+}
+
+/* Grab the IOLOCK of the orphanage and sc->ip. */
+int
+xrep_orphanage_iolock_two(
+	struct xfs_scrub	*sc)
+{
+	int			error = 0;
+
+	while (true) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		/*
+		 * Normal XFS takes the IOLOCK before grabbing a transaction.
+		 * Scrub holds a transaction, which means that we can't block
+		 * on either IOLOCK.
+		 */
+		if (xrep_orphanage_ilock_nowait(sc, XFS_IOLOCK_EXCL)) {
+			if (xchk_ilock_nowait(sc, XFS_IOLOCK_EXCL))
+				break;
+			xrep_orphanage_iunlock(sc, XFS_IOLOCK_EXCL);
+		}
+		delay(1);
+	}
+
+	return 0;
+}
+
+/* Release the orphanage. */
+void
+xrep_orphanage_rele(
+	struct xfs_scrub	*sc)
+{
+	if (!sc->orphanage)
+		return;
+
+	if (sc->orphanage_ilock_flags)
+		xfs_iunlock(sc->orphanage, sc->orphanage_ilock_flags);
+
+	xchk_irele(sc, sc->orphanage);
+	sc->orphanage = NULL;
+}
+
+/* Adoption moves a file into /lost+found */
+
+/* Can the orphanage adopt @sc->ip? */
+bool
+xrep_orphanage_can_adopt(
+	struct xfs_scrub	*sc)
+{
+	ASSERT(sc->ip != NULL);
+
+	if (!sc->orphanage)
+		return false;
+	if (sc->ip == sc->orphanage)
+		return false;
+	if (xfs_internal_inum(sc->mp, sc->ip->i_ino))
+		return false;
+	return true;
+}
+
+/*
+ * Create a new transaction to send a child to the orphanage.
+ *
+ * Allocate a new transaction with sufficient disk space to handle the
+ * adoption, take ILOCK_EXCL of the orphanage and sc->ip, joins them to the
+ * transaction, and reserve quota to reparent the latter.  Caller must hold the
+ * IOLOCK of the orphanage and sc->ip.
+ */
+int
+xrep_adoption_trans_alloc(
+	struct xfs_scrub	*sc,
+	struct xrep_adoption	*adopt)
+{
+	struct xfs_mount	*mp = sc->mp;
+	unsigned int		child_blkres = 0;
+	int			error;
+
+	ASSERT(sc->tp == NULL);
+	ASSERT(sc->ip != NULL);
+	ASSERT(sc->orphanage != NULL);
+	ASSERT(sc->ilock_flags & XFS_IOLOCK_EXCL);
+	ASSERT(sc->orphanage_ilock_flags & XFS_IOLOCK_EXCL);
+	ASSERT(!(sc->ilock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)));
+	ASSERT(!(sc->orphanage_ilock_flags &
+				(XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)));
+
+	/* Compute the worst case space reservation that we need. */
+	adopt->sc = sc;
+	adopt->orphanage_blkres = XFS_LINK_SPACE_RES(mp, MAXNAMELEN);
+	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
+		child_blkres = XFS_RENAME_SPACE_RES(mp, xfs_name_dotdot.len);
+	adopt->child_blkres = child_blkres;
+
+	/*
+	 * Allocate a transaction to link the child into the parent, along with
+	 * enough disk space to handle expansion of both the orphanage and the
+	 * dotdot entry of a child directory.
+	 */
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link,
+			adopt->orphanage_blkres + adopt->child_blkres, 0, 0,
+			&sc->tp);
+	if (error)
+		return error;
+
+	xfs_lock_two_inodes(sc->orphanage, XFS_ILOCK_EXCL,
+			    sc->ip, XFS_ILOCK_EXCL);
+	sc->ilock_flags |= XFS_ILOCK_EXCL;
+	sc->orphanage_ilock_flags |= XFS_ILOCK_EXCL;
+
+	xfs_trans_ijoin(sc->tp, sc->orphanage, 0);
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/*
+	 * Reserve enough quota in the orphan directory to add the new name.
+	 * Normally the orphanage should have user/group/project ids of zero
+	 * and hence is not subject to quota enforcement, but we're allowed to
+	 * exceed quota to reattach disconnected parts of the directory tree.
+	 */
+	error = xfs_trans_reserve_quota_nblks(sc->tp, sc->orphanage,
+			adopt->orphanage_blkres, 0, true);
+	if (error)
+		goto out_cancel;
+
+	/*
+	 * Reserve enough quota in the child directory to change dotdot.
+	 * Here we're also allowed to exceed file quota to repair inconsistent
+	 * metadata.
+	 */
+	if (adopt->child_blkres) {
+		error = xfs_trans_reserve_quota_nblks(sc->tp, sc->ip,
+				adopt->child_blkres, 0, true);
+		if (error)
+			goto out_cancel;
+	}
+
+	return 0;
+out_cancel:
+	xchk_trans_cancel(sc);
+	xrep_orphanage_iunlock(sc, XFS_ILOCK_EXCL);
+	xrep_orphanage_iunlock(sc, XFS_IOLOCK_EXCL);
+	return error;
+}
+
+/*
+ * Compute the xfs_name for the directory entry that we're adding to the
+ * orphanage.  Caller must hold ILOCKs of sc->ip and the orphanage and must not
+ * reuse namebuf until the adoption completes or is dissolved.
+ */
+int
+xrep_adoption_compute_name(
+	struct xrep_adoption	*adopt,
+	struct xfs_name		*xname)
+{
+	struct xfs_scrub	*sc = adopt->sc;
+	char			*namebuf = (void *)xname->name;
+	xfs_ino_t		ino;
+	unsigned int		incr = 0;
+	int			error = 0;
+
+	adopt->xname = xname;
+	xname->len = snprintf(namebuf, MAXNAMELEN, "%llu", sc->ip->i_ino);
+	xname->type = xfs_mode_to_ftype(VFS_I(sc->ip)->i_mode);
+
+	/* Make sure the filename is unique in the lost+found. */
+	error = xchk_dir_lookup(sc, sc->orphanage, xname, &ino);
+	while (error == 0 && incr < 10000) {
+		xname->len = snprintf(namebuf, MAXNAMELEN, "%llu.%u",
+				sc->ip->i_ino, ++incr);
+		error = xchk_dir_lookup(sc, sc->orphanage, xname, &ino);
+	}
+	if (error == 0) {
+		/* We already have 10,000 entries in the orphanage? */
+		return -EFSCORRUPTED;
+	}
+
+	if (error != -ENOENT)
+		return error;
+	return 0;
+}
+
+/*
+ * Move the current file to the orphanage under the computed name.
+ *
+ * Returns with a dirty transaction so that the caller can handle any other
+ * work, such as fixing up unlinked lists or resetting link counts.
+ */
+int
+xrep_adoption_move(
+	struct xrep_adoption	*adopt)
+{
+	struct xfs_scrub	*sc = adopt->sc;
+	bool			isdir = S_ISDIR(VFS_I(sc->ip)->i_mode);
+	int			error;
+
+	trace_xrep_adoption_reparent(sc->orphanage, adopt->xname,
+			sc->ip->i_ino);
+
+	/* Create the new name in the orphanage. */
+	error = xfs_dir_createname(sc->tp, sc->orphanage, adopt->xname,
+			sc->ip->i_ino, adopt->orphanage_blkres);
+	if (error)
+		return error;
+
+	/*
+	 * Bump the link count of the orphanage if we just added a
+	 * subdirectory, and update its timestamps.
+	 */
+	xfs_trans_ichgtime(sc->tp, sc->orphanage,
+			XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	if (isdir)
+		xfs_bumplink(sc->tp, sc->orphanage);
+	xfs_trans_log_inode(sc->tp, sc->orphanage, XFS_ILOG_CORE);
+
+	/* Replace the dotdot entry if the child is a subdirectory. */
+	if (isdir) {
+		error = xfs_dir_replace(sc->tp, sc->ip, &xfs_name_dotdot,
+				sc->orphanage->i_ino, adopt->child_blkres);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Notify dirent hooks that we moved the file to /lost+found, and
+	 * finish all the deferred work so that we know the adoption is fully
+	 * recorded in the log.
+	 */
+	xfs_dir_update_hook(sc->orphanage, sc->ip, 1, adopt->xname);
+	return 0;
+}
+
+/*
+ * Roll to a clean scrub transaction so that we can release the orphanage,
+ * even if xrep_adoption_move was not called.
+ *
+ * Commits all the work and deferred ops attached to an adoption request and
+ * rolls to a clean scrub transaction.  On success, returns 0 with the scrub
+ * context holding a clean transaction with no inodes joined.  On failure,
+ * returns negative errno with no scrub transaction.  All inode locks are
+ * still held after this function returns.
+ */
+int
+xrep_adoption_trans_roll(
+	struct xrep_adoption	*adopt)
+{
+	struct xfs_scrub	*sc = adopt->sc;
+	int			error;
+
+	trace_xrep_adoption_trans_roll(sc->orphanage, sc->ip,
+			!!(sc->tp->t_flags & XFS_TRANS_DIRTY));
+
+	/* Finish all the deferred ops to commit all repairs. */
+	error = xrep_defer_finish(sc);
+	if (error)
+		return error;
+
+	/* Roll the transaction once more to detach the inodes. */
+	return xfs_trans_roll(&sc->tp);
+}
diff --git a/fs/xfs/scrub/orphanage.h b/fs/xfs/scrub/orphanage.h
new file mode 100644
index 000000000000..319179ab788d
--- /dev/null
+++ b/fs/xfs/scrub/orphanage.h
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_ORPHANAGE_H__
+#define __XFS_SCRUB_ORPHANAGE_H__
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+int xrep_orphanage_create(struct xfs_scrub *sc);
+
+/*
+ * If we're doing a repair, ensure that the orphanage exists and attach it to
+ * the scrub context.
+ */
+static inline int
+xrep_orphanage_try_create(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	ASSERT(sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR);
+
+	error = xrep_orphanage_create(sc);
+	switch (error) {
+	case 0:
+	case -ENOENT:
+	case -ENOTDIR:
+	case -ENOSPC:
+		/*
+		 * If the orphanage can't be found or isn't a directory, we'll
+		 * keep going, but we won't be able to attach the file to the
+		 * orphanage if we can't find the parent.
+		 */
+		return 0;
+	}
+
+	return error;
+}
+
+int xrep_orphanage_iolock_two(struct xfs_scrub *sc);
+
+void xrep_orphanage_ilock(struct xfs_scrub *sc, unsigned int ilock_flags);
+bool xrep_orphanage_ilock_nowait(struct xfs_scrub *sc,
+		unsigned int ilock_flags);
+void xrep_orphanage_iunlock(struct xfs_scrub *sc, unsigned int ilock_flags);
+
+void xrep_orphanage_rele(struct xfs_scrub *sc);
+
+/* Information about a request to add a file to the orphanage. */
+struct xrep_adoption {
+	struct xfs_scrub	*sc;
+
+	/* Name used for the adoption. */
+	struct xfs_name		*xname;
+
+	/* Block reservations for orphanage and child (if directory). */
+	unsigned int		orphanage_blkres;
+	unsigned int		child_blkres;
+};
+
+bool xrep_orphanage_can_adopt(struct xfs_scrub *sc);
+
+int xrep_adoption_trans_alloc(struct xfs_scrub *sc,
+		struct xrep_adoption *adopt);
+int xrep_adoption_compute_name(struct xrep_adoption *adopt,
+		struct xfs_name *xname);
+int xrep_adoption_move(struct xrep_adoption *adopt);
+int xrep_adoption_trans_roll(struct xrep_adoption *adopt);
+#else
+struct xrep_adoption { /* empty */ };
+# define xrep_orphanage_rele(sc)	((void)0)
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
+
+#endif /* __XFS_SCRUB_ORPHANAGE_H__ */
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 826926c2bb0d..ebb5791bf839 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -32,6 +32,8 @@
 #include "scrub/iscan.h"
 #include "scrub/findparent.h"
 #include "scrub/readdir.h"
+#include "scrub/tempfile.h"
+#include "scrub/orphanage.h"
 
 /*
  * Repairing The Directory Parent Pointer
@@ -57,6 +59,13 @@ struct xrep_parent {
 	 * dotdot entry for this directory.
 	 */
 	struct xrep_parent_scan_info pscan;
+
+	/* Orphanage reparenting request. */
+	struct xrep_adoption	adoption;
+
+	/* Directory entry name, plus the trailing null. */
+	struct xfs_name		xname;
+	unsigned char		namebuf[MAXNAMELEN];
 };
 
 /* Tear down all the incore stuff we created. */
@@ -80,9 +89,10 @@ xrep_setup_parent(
 	if (!rp)
 		return -ENOMEM;
 	rp->sc = sc;
+	rp->xname.name = rp->namebuf;
 	sc->buf = rp;
 
-	return 0;
+	return xrep_orphanage_try_create(sc);
 }
 
 /*
@@ -179,6 +189,91 @@ xrep_parent_reset_dotdot(
 	return xfs_trans_roll(&sc->tp);
 }
 
+/*
+ * Move the current file to the orphanage.
+ *
+ * Caller must hold IOLOCK_EXCL on @sc->ip, and no other inode locks.  Upon
+ * successful return, the scrub transaction will have enough extra reservation
+ * to make the move; it will hold IOLOCK_EXCL and ILOCK_EXCL of @sc->ip and the
+ * orphanage; and both inodes will be ijoined.
+ */
+STATIC int
+xrep_parent_move_to_orphanage(
+	struct xrep_parent	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	xfs_ino_t		orig_parent, new_parent;
+	int			error;
+
+	/*
+	 * We are about to drop the ILOCK on sc->ip to lock the orphanage and
+	 * prepare for the adoption.  Therefore, look up the old dotdot entry
+	 * for sc->ip so that we can compare it after we re-lock sc->ip.
+	 */
+	error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot, &orig_parent);
+	if (error)
+		return error;
+
+	/*
+	 * Drop the ILOCK on the scrub target and commit the transaction.
+	 * Adoption computes its own resource requirements and gathers the
+	 * necessary components.
+	 */
+	error = xrep_trans_commit(sc);
+	if (error)
+		return error;
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	/* If we can take the orphanage's iolock then we're ready to move. */
+	if (!xrep_orphanage_ilock_nowait(sc, XFS_IOLOCK_EXCL)) {
+		xchk_iunlock(sc, sc->ilock_flags);
+		error = xrep_orphanage_iolock_two(sc);
+		if (error)
+			return error;
+	}
+
+	/* Grab transaction and ILOCK the two files. */
+	error = xrep_adoption_trans_alloc(sc, &rp->adoption);
+	if (error)
+		return error;
+
+	error = xrep_adoption_compute_name(&rp->adoption, &rp->xname);
+	if (error)
+		return error;
+
+	/*
+	 * Now that we've reacquired the ILOCK on sc->ip, look up the dotdot
+	 * entry again.  If the parent changed or the child was unlinked while
+	 * the child directory was unlocked, we don't need to move the child to
+	 * the orphanage after all.
+	 */
+	error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot, &new_parent);
+	if (error)
+		return error;
+
+	/*
+	 * Attach to the orphanage if we still have a linked directory and it
+	 * hasn't been moved.
+	 */
+	if (orig_parent == new_parent && VFS_I(sc->ip)->i_nlink > 0) {
+		error = xrep_adoption_move(&rp->adoption);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Launder the scrub transaction so we can drop the orphanage ILOCK
+	 * and IOLOCK.  Return holding the scrub target's ILOCK and IOLOCK.
+	 */
+	error = xrep_adoption_trans_roll(&rp->adoption);
+	if (error)
+		return error;
+
+	xrep_orphanage_iunlock(sc, XFS_ILOCK_EXCL);
+	xrep_orphanage_iunlock(sc, XFS_IOLOCK_EXCL);
+	return 0;
+}
+
 /*
  * Commit the new parent pointer structure (currently only the dotdot entry) to
  * the file that we're repairing.
@@ -188,7 +283,8 @@ xrep_parent_rebuild_tree(
 	struct xrep_parent	*rp)
 {
 	if (rp->pscan.parent_ino == NULLFSINO) {
-		/* Cannot fix orphaned directories yet. */
+		if (xrep_orphanage_can_adopt(rp->sc))
+			return xrep_parent_move_to_orphanage(rp);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 520d83db193c..6417628ce26b 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -27,6 +27,7 @@
 #include "scrub/stats.h"
 #include "scrub/xfile.h"
 #include "scrub/tempfile.h"
+#include "scrub/orphanage.h"
 
 /*
  * Online Scrub and Repair
@@ -217,6 +218,7 @@ xchk_teardown(
 	}
 
 	xrep_tempfile_rele(sc);
+	xrep_orphanage_rele(sc);
 	xchk_fsgates_disable(sc);
 	return error;
 }
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index d38f0b30416c..7abe498f7a46 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -105,6 +105,10 @@ struct xfs_scrub {
 	/* Lock flags for @ip. */
 	uint				ilock_flags;
 
+	/* The orphanage, for stashing files that have lost their parent. */
+	uint				orphanage_ilock_flags;
+	struct xfs_inode		*orphanage;
+
 	/* A temporary file on this filesystem, for staging new metadata. */
 	struct xfs_inode		*tempip;
 	uint				temp_ilock_flags;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d68ec8e2781e..7c49aa6f6b8d 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2588,6 +2588,34 @@ DEFINE_EVENT(xrep_dirent_class, name, \
 DEFINE_XREP_DIRENT_EVENT(xrep_dir_salvage_entry);
 DEFINE_XREP_DIRENT_EVENT(xrep_dir_stash_createname);
 DEFINE_XREP_DIRENT_EVENT(xrep_dir_replay_createname);
+DEFINE_XREP_DIRENT_EVENT(xrep_adoption_reparent);
+
+DECLARE_EVENT_CLASS(xrep_adoption_class,
+	TP_PROTO(struct xfs_inode *dp, struct xfs_inode *ip, bool moved),
+	TP_ARGS(dp, ip, moved),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir_ino)
+		__field(xfs_ino_t, child_ino)
+		__field(bool, moved)
+	),
+	TP_fast_assign(
+		__entry->dev = dp->i_mount->m_super->s_dev;
+		__entry->dir_ino = dp->i_ino;
+		__entry->child_ino = ip->i_ino;
+		__entry->moved = moved;
+	),
+	TP_printk("dev %d:%d dir 0x%llx child 0x%llx moved? %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir_ino,
+		  __entry->child_ino,
+		  __entry->moved)
+);
+#define DEFINE_XREP_ADOPTION_EVENT(name) \
+DEFINE_EVENT(xrep_adoption_class, name, \
+	TP_PROTO(struct xfs_inode *dp, struct xfs_inode *ip, bool moved), \
+	TP_ARGS(dp, ip, moved))
+DEFINE_XREP_ADOPTION_EVENT(xrep_adoption_trans_roll);
 
 DECLARE_EVENT_CLASS(xrep_parent_salvage_class,
 	TP_PROTO(struct xfs_inode *dp, xfs_ino_t ino),
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 09d643a9e997..803a64687014 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -914,10 +914,10 @@ xfs_droplink(
 /*
  * Increment the link count on an inode & log the change.
  */
-static void
+void
 xfs_bumplink(
-	xfs_trans_t *tp,
-	xfs_inode_t *ip)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
 {
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 8157ae7f8e59..18bc3d7750a0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -625,6 +625,7 @@ void xfs_end_io(struct work_struct *work);
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_remapping(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
 static inline bool
 xfs_inode_unlinked_incomplete(


