Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03FF76DA1A0
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Apr 2023 21:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbjDFTkM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Apr 2023 15:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjDFTkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:40:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F109FF
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:40:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C54D60FAA
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDB1C433D2;
        Thu,  6 Apr 2023 19:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810009;
        bh=D88/XnpWGqY1223EaJNgOl1zITYV10wYxyRqGF5MF98=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=lJ92K1s1O9PcYjzsFjqueW3ymdY+Tx23aAbOwg6MHxWeO0EWS3677ioAnlKvOuNPJ
         O+jJMauVII/ym1abnYZvzmIy1DPxg0pfFGn6pUiqUEG3pOOMKLzuk5iYdI7OAFLnEu
         Leg38VyH2EppdFzKk/g+gU4lZQnLTw4pRcIxRZ1vLWtNLSWMI9NDlKfK6351s5Y+4f
         j4j/tZPQAhwsBB36xwuOrg2DGYx/rKsPLe7HGiPpaEjMZEufiyHXRoar1DYkJTIvcV
         R4P4W+tiLy/aMvUrNNe49EXEuuYAGpTH2T2G5gybBfnbkwQ7BY6pbrkoTHk02/m+pa
         qqZ3OSF4LXdig==
Date:   Thu, 06 Apr 2023 12:40:09 -0700
Subject: [PATCH 1/7] xfs_repair: build a parent pointer index
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080828272.617551.16472851997326940676.stgit@frogsfrogsfrogs>
In-Reply-To: <168080828258.617551.4008600376507330925.stgit@frogsfrogsfrogs>
References: <168080828258.617551.4008600376507330925.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're walking directories during phase 6, build an index of parent
pointers that we expect to find.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/Makefile |    2 +
 repair/phase6.c |   39 ++++++++++-
 repair/pptr.c   |  198 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/pptr.h   |   15 ++++
 4 files changed, 252 insertions(+), 2 deletions(-)
 create mode 100644 repair/pptr.c
 create mode 100644 repair/pptr.h


diff --git a/repair/Makefile b/repair/Makefile
index 2c40e59a3..18731613b 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -23,6 +23,7 @@ HFILES = \
 	err_protos.h \
 	globals.h \
 	incore.h \
+	pptr.h \
 	prefetch.h \
 	progress.h \
 	protos.h \
@@ -59,6 +60,7 @@ CFILES = \
 	phase5.c \
 	phase6.c \
 	phase7.c \
+	pptr.c \
 	prefetch.c \
 	progress.c \
 	quotacheck.c \
diff --git a/repair/phase6.c b/repair/phase6.c
index 24ee6c27a..4df3b2402 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -18,6 +18,7 @@
 #include "dinode.h"
 #include "progress.h"
 #include "versions.h"
+#include "repair/pptr.h"
 
 static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
@@ -974,6 +975,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(
 		_("can't make %s, createname error %d\n"),
 			ORPHANAGE, error);
+	add_parent_ptr(ip->i_ino, ORPHANAGE, pip);
 
 	/*
 	 * bump up the link count in the root directory to account
@@ -1160,6 +1162,10 @@ mv_orphanage(
 			do_error(
 	_("orphanage name create failed (%d)\n"), err);
 	}
+
+	if (xfs_has_parent(mp))
+		add_parent_ptr(ino_p->i_ino, xname.name, orphanage_ip);
+
 	libxfs_irele(ino_p);
 	libxfs_irele(orphanage_ip);
 }
@@ -2459,6 +2465,7 @@ shortform_dir2_entry_check(
 	struct xfs_dir2_sf_entry *next_sfep;
 	struct xfs_ifork	*ifp;
 	struct ino_tree_node	*irec;
+	xfs_dir2_dataptr_t	diroffset;
 	int			max_size;
 	int			ino_offset;
 	int			i;
@@ -2637,8 +2644,9 @@ shortform_dir2_entry_check(
 		/*
 		 * check for duplicate names in directory.
 		 */
-		if (!dir_hash_add(mp, hashtab, (xfs_dir2_dataptr_t)
-				(sfep - xfs_dir2_sf_firstentry(sfp)),
+		diroffset = xfs_dir2_byte_to_dataptr(
+				xfs_dir2_sf_get_offset(sfep));
+		if (!dir_hash_add(mp, hashtab, diroffset,
 				lino, sfep->namelen, sfep->name,
 				libxfs_dir2_sf_get_ftype(mp, sfep))) {
 			do_warn(
@@ -2672,6 +2680,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
 						lino, &max_size, &i,
 						&bytes_deleted, ino_dirty);
+				dir_hash_junkit(hashtab, diroffset);
 				continue;
 			} else if (parent == ino)  {
 				add_inode_reached(irec, ino_offset);
@@ -2696,6 +2705,7 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 				next_sfep = shortform_dir2_junk(mp, sfp, sfep,
 						lino, &max_size, &i,
 						&bytes_deleted, ino_dirty);
+				dir_hash_junkit(hashtab, diroffset);
 				continue;
 			}
 		}
@@ -2787,6 +2797,26 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is a duplicate name"),
 	}
 }
 
+static void
+dir_hash_add_parent_ptrs(
+	struct xfs_inode	*dp,
+	struct dir_hash_tab	*hashtab)
+{
+	struct dir_hash_ent	*p;
+
+	if (!xfs_has_parent(dp->i_mount))
+		return;
+
+	for (p = hashtab->first; p; p = p->nextbyorder) {
+		if (p->name.name[0] == '/' || (p->name.name[0] == '.' &&
+				(p->name.len == 1 || (p->name.len == 2 &&
+						p->name.name[1] == '.'))))
+			continue;
+
+		add_parent_ptr(p->inum, p->name.name, dp);
+	}
+}
+
 /*
  * processes all reachable inodes in directories
  */
@@ -2913,6 +2943,7 @@ _("error %d fixing shortform directory %llu\n"),
 		default:
 			break;
 	}
+	dir_hash_add_parent_ptrs(ip, hashtab);
 	dir_hash_done(hashtab);
 
 	/*
@@ -3204,6 +3235,8 @@ phase6(xfs_mount_t *mp)
 	ino_tree_node_t		*irec;
 	int			i;
 
+	parent_ptr_init(mp);
+
 	memset(&zerocr, 0, sizeof(struct cred));
 	memset(&zerofsx, 0, sizeof(struct fsxattr));
 	orphanage_ino = 0;
@@ -3304,4 +3337,6 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 			irec = next_ino_rec(irec);
 		}
 	}
+
+	parent_ptr_free(mp);
 }
diff --git a/repair/pptr.c b/repair/pptr.c
new file mode 100644
index 000000000..f1b3332fc
--- /dev/null
+++ b/repair/pptr.c
@@ -0,0 +1,198 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs.h"
+#include "libxfs/xfile.h"
+#include "libxfs/xfblob.h"
+#include "repair/err_protos.h"
+#include "repair/slab.h"
+#include "repair/pptr.h"
+
+#undef PPTR_DEBUG
+
+#ifdef PPTR_DEBUG
+# define dbg_printf(f, a...)  do {printf(f, ## a); fflush(stdout); } while (0)
+#else
+# define dbg_printf(f, a...)
+#endif
+
+/*
+ * Parent Pointer Validation
+ * =========================
+ *
+ * Phase 6 validates the connectivity of the directory tree after validating
+ * that all the space metadata are correct, and confirming all the inodes that
+ * we intend to keep.  The first part of phase 6 walks the directories of the
+ * filesystem to ensure that every file that isn't the root directory has a
+ * parent.  Unconnected files are attached to the orphanage.  Filesystems with
+ * the directory parent pointer feature enabled must also ensure that for every
+ * directory entry that points to a child file, that child has a matching
+ * parent pointer.
+ *
+ * There are many ways that we could check the parent pointers, but the means
+ * that we have chosen is to build a per-AG master index of all parent pointers
+ * of all inodes stored in that AG, and use that as the basis for comparison.
+ * This consumes a lot of memory, but performing both a forward scan to check
+ * dirent -> parent pointer and a backwards scan of parent pointer -> dirent
+ * takes longer than the simple method presented here.  Userspace adds the
+ * additional twist that inodes are not cached (and there are no ILOCKs), which
+ * makes that approach even less attractive.
+ *
+ * During the directory walk at the start of phase 6, we transform each child
+ * directory entry found into its parent pointer equivalent.  In other words,
+ * the forward information:
+ *
+ *     (dir_ino, name, child_ino)
+ *
+ * becomes this backwards information:
+ *
+ *     (child_agino*, dir_ino*, dir_gen, name*)
+ *
+ * Key fields are starred.
+ *
+ * This tuple is recorded in the per-AG master parent pointer index.  Note
+ * that names are stored separately in an xfblob data structure so that the
+ * rest of the information can be sorted and processed as fixed-size records;
+ * the incore parent pointer record contains a pointer to the xfblob data.
+ */
+
+struct ag_pptr {
+	/* parent directory handle */
+	xfs_ino_t		parent_ino;
+	unsigned int		parent_gen;
+
+	/* dirent name length */
+	unsigned int		namelen;
+
+	/* cookie for the actual dirent name */
+	xfblob_cookie		name_cookie;
+
+	/* agino of the child file */
+	xfs_agino_t		child_agino;
+
+	/* hash of the dirent name */
+	xfs_dahash_t		namehash;
+};
+
+struct ag_pptrs {
+	/* Lock to protect pptr_recs during the dirent scan. */
+	pthread_mutex_t		lock;
+
+	/* Parent pointer records for files in this AG. */
+	struct xfs_slab		*pptr_recs;
+};
+
+/* Global names storage file. */
+static struct xfblob	*names;
+static pthread_mutex_t	names_mutex = PTHREAD_MUTEX_INITIALIZER;
+static struct ag_pptrs	*fs_pptrs;
+
+void
+parent_ptr_free(
+	struct xfs_mount	*mp)
+{
+	xfs_agnumber_t		agno;
+
+	if (!xfs_has_parent(mp))
+		return;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		free_slab(&fs_pptrs[agno].pptr_recs);
+		pthread_mutex_destroy(&fs_pptrs[agno].lock);
+	}
+	free(fs_pptrs);
+	fs_pptrs = NULL;
+
+	xfblob_destroy(names);
+}
+
+void
+parent_ptr_init(
+	struct xfs_mount	*mp)
+{
+	xfs_agnumber_t		agno;
+	int			error;
+
+	if (!xfs_has_parent(mp))
+		return;
+
+	error = -xfblob_create(mp, "parent pointer names", &names);
+	if (error)
+		do_error(_("init parent pointer names failed: %s\n"),
+				strerror(error));
+
+	fs_pptrs = calloc(mp->m_sb.sb_agcount, sizeof(struct ag_pptrs));
+	if (!fs_pptrs)
+		do_error(
+ _("init parent pointer per-AG record array failed: %s\n"),
+				strerror(errno));
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		error = pthread_mutex_init(&fs_pptrs[agno].lock, NULL);
+		if (error)
+			do_error(
+ _("init agno %u parent pointer lock failed: %s\n"),
+					agno, strerror(error));
+
+		error = -init_slab(&fs_pptrs[agno].pptr_recs,
+				sizeof(struct ag_pptr));
+		if (error)
+			do_error(
+ _("init agno %u parent pointer recs failed: %s\n"),
+					agno, strerror(error));
+	}
+}
+
+/* Remember that @dp has a dirent (@fname, @ino). */
+void
+add_parent_ptr(
+	xfs_ino_t		ino,
+	const unsigned char	*fname,
+	struct xfs_inode	*dp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_name		dname = {
+		.name		= fname,
+		.len		= strlen(fname),
+	};
+	struct ag_pptr		ag_pptr = {
+		.child_agino	= XFS_INO_TO_AGINO(mp, ino),
+		.parent_ino	= dp->i_ino,
+		.parent_gen	= VFS_I(dp)->i_generation,
+		.namelen	= dname.len,
+	};
+	struct ag_pptrs		*ag_pptrs;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ino);
+	int			error;
+
+	if (!xfs_has_parent(mp))
+		return;
+
+	ag_pptr.namehash = libxfs_dir2_hashname(mp, &dname);
+
+	pthread_mutex_lock(&names_mutex);
+	error = -xfblob_store(names, &ag_pptr.name_cookie, fname,
+			ag_pptr.namelen);
+	pthread_mutex_unlock(&names_mutex);
+	if (error)
+		do_error(_("storing name '%s' failed: %s\n"),
+				fname, strerror(error));
+
+	ag_pptrs = &fs_pptrs[agno];
+	pthread_mutex_lock(&ag_pptrs->lock);
+	error = -slab_add(ag_pptrs->pptr_recs, &ag_pptr);
+	pthread_mutex_unlock(&ag_pptrs->lock);
+	if (error)
+		do_error(_("storing name '%s' key failed: %s\n"),
+				fname, strerror(error));
+
+	dbg_printf(
+ _("%s: dp %llu fname '%s' ino %llu namecookie 0x%llx\n"),
+			__func__,
+			(unsigned long long)dp->i_ino,
+			fname,
+			(unsigned long long)ino,
+			(unsigned long long)ag_pptr.name_cookie);
+}
diff --git a/repair/pptr.h b/repair/pptr.h
new file mode 100644
index 000000000..0ca2e1c6f
--- /dev/null
+++ b/repair/pptr.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __REPAIR_PPTR_H__
+#define __REPAIR_PPTR_H__
+
+void parent_ptr_free(struct xfs_mount *mp);
+void parent_ptr_init(struct xfs_mount *mp);
+
+void add_parent_ptr(xfs_ino_t ino, const unsigned char *fname,
+		struct xfs_inode *dp);
+
+#endif /* __REPAIR_PPTR_H__ */

