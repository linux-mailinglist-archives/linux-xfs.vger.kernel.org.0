Return-Path: <linux-xfs+bounces-10124-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8708F91EC91
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 03:19:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 097321F220CE
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 01:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C14946C;
	Tue,  2 Jul 2024 01:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDWn1hgk"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06689441
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883142; cv=none; b=p5xe87encTb6OU5V8w16m2aPk53YLmz2fpx8huT5XylIpDHU3y1VuOD3Q2no4WscEPwMQ4wCD31dz97XsIvMWOzoR0xIY7c9HDwGqP93QmjZBcipfZK3o6M0p3aK1130A80yk5UXFhwtx2ljUnz0kOJfiJnxAxVONRcXGEVrfiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883142; c=relaxed/simple;
	bh=hXsbBjwfoge+L76tmqFWO+yD9d6+EWYi6zO7dS5agp8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lSoZkZrUfC0skC3gW4wDxWx3gyjWTKaesCJsSfLWu0RlAGZhYKcofEyxmHLViuE6/fFd+M6e/w+Aw0LmekfbkcmG17wgNECGaJ2T0FERArN2GSJYz47KJJfMGhYfXX2/oxr193x9EClaEnvayXni2tb7hRJVNy7dIF2LCWkn/W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDWn1hgk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F3EC116B1;
	Tue,  2 Jul 2024 01:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883142;
	bh=hXsbBjwfoge+L76tmqFWO+yD9d6+EWYi6zO7dS5agp8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VDWn1hgkhWlRoJY1u+8/XN4/+l2QAHmtNlvg/4v9/bQyuNAHbiEXL3InSe9pM9uSC
	 UHsx2p1jn3Ma4h9Biy+CyRzQNCg/2tY9V2Ifwq2j32dfGUy8KZViCAgMqvD8mINpwE
	 I8LFjADo9SrEmlminxJFkDNVTMS4QykJ6OYMSsI85uQwAI5yNueUWR0pLtdIX02OsX
	 LF84dpzKhd3t7kyP/9J6vq2df5dzYw+p/CgeZpAQ31+udiF/OxhWNEFo1FwqW+/1yu
	 RQy8m72bpkivZo8Mc5cN/v4X2QXL8ZlnY4ynaw8sdljvJ+J+XCoNeY8Tgf7k5+yMyO
	 /OX4CUDfxBUUQ==
Date: Mon, 01 Jul 2024 18:19:02 -0700
Subject: [PATCH 06/12] xfs_repair: build a parent pointer index
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988122258.2010218.748165248811754209.stgit@frogsfrogsfrogs>
In-Reply-To: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
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

When we're walking directories during phase 6, build an index of parent
pointers that we expect to find.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/Makefile |    2 +
 repair/phase6.c |   35 +++++++++
 repair/pptr.c   |  215 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/pptr.h   |   15 ++++
 4 files changed, 267 insertions(+)
 create mode 100644 repair/pptr.c
 create mode 100644 repair/pptr.h


diff --git a/repair/Makefile b/repair/Makefile
index d948588781de..b0acc8c46a33 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -24,6 +24,7 @@ HFILES = \
 	err_protos.h \
 	globals.h \
 	incore.h \
+	pptr.h \
 	prefetch.h \
 	progress.h \
 	protos.h \
@@ -63,6 +64,7 @@ CFILES = \
 	phase5.c \
 	phase6.c \
 	phase7.c \
+	pptr.c \
 	prefetch.c \
 	progress.c \
 	quotacheck.c \
diff --git a/repair/phase6.c b/repair/phase6.c
index 9d41aad784a1..fe56feb6ecef 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -18,6 +18,7 @@
 #include "dinode.h"
 #include "progress.h"
 #include "versions.h"
+#include "repair/pptr.h"
 
 static struct cred		zerocr;
 static struct fsxattr 		zerofsx;
@@ -999,6 +1000,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(
 		_("can't make %s, createname error %d\n"),
 			ORPHANAGE, error);
+	add_parent_ptr(ip->i_ino, (unsigned char *)ORPHANAGE, pip, false);
 
 	if (ppargs) {
 		error = -libxfs_parent_addname(tp, ppargs, pip, &xname, ip);
@@ -1255,6 +1257,10 @@ mv_orphanage(
 			do_error(
 	_("orphanage name create failed (%d)\n"), err);
 	}
+
+	if (xfs_has_parent(mp))
+		add_parent_ptr(ino_p->i_ino, xname.name, orphanage_ip, false);
+
 	libxfs_irele(ino_p);
 	libxfs_irele(orphanage_ip);
 	libxfs_parent_finish(mp, ppargs);
@@ -2894,6 +2900,30 @@ _("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " already points to ino %" PR
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
+		if (p->junkit)
+			continue;
+		if (p->name.name[0] == '/')
+			continue;
+		if (p->name.name[0] == '.' &&
+		    (p->name.len == 1 ||
+		     (p->name.len == 2 && p->name.name[1] == '.')))
+			continue;
+
+		add_parent_ptr(p->inum, p->name.name, dp, dotdot_update);
+	}
+}
+
 /*
  * processes all reachable inodes in directories
  */
@@ -3020,6 +3050,7 @@ _("error %d fixing shortform directory %llu\n"),
 		default:
 			break;
 	}
+	dir_hash_add_parent_ptrs(ip, hashtab);
 	dir_hash_done(hashtab);
 
 	/*
@@ -3311,6 +3342,8 @@ phase6(xfs_mount_t *mp)
 	ino_tree_node_t		*irec;
 	int			i;
 
+	parent_ptr_init(mp);
+
 	memset(&zerocr, 0, sizeof(struct cred));
 	memset(&zerofsx, 0, sizeof(struct fsxattr));
 	orphanage_ino = 0;
@@ -3411,4 +3444,6 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 			irec = next_ino_rec(irec);
 		}
 	}
+
+	parent_ptr_free(mp);
 }
diff --git a/repair/pptr.c b/repair/pptr.c
new file mode 100644
index 000000000000..193daa0a5467
--- /dev/null
+++ b/repair/pptr.c
@@ -0,0 +1,215 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs.h"
+#include "libxfs/xfile.h"
+#include "libxfs/xfblob.h"
+#include "libfrog/platform.h"
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
+	uint32_t		parent_gen;
+
+	/* dirent name length */
+	unsigned short		namelen;
+
+	/* AG_PPTR_* flags */
+	unsigned short		flags;
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
+/* This might be a duplicate due to dotdot reprocessing */
+#define AG_PPTR_POSSIBLE_DUP	(1U << 0)
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
+	char			*descr;
+	xfs_agnumber_t		agno;
+	int			error;
+
+	if (!xfs_has_parent(mp))
+		return;
+
+	descr = kasprintf(GFP_KERNEL, "xfs_repair (%s): parent pointer names",
+			mp->m_fsname);
+	error = -xfblob_create(descr, &names);
+	kfree(descr);
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
+	struct xfs_inode	*dp,
+	bool			possible_dup)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_name		dname = {
+		.name		= fname,
+		.len		= strlen((char *)fname),
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
+	if (possible_dup)
+		ag_pptr.flags |= AG_PPTR_POSSIBLE_DUP;
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
+ _("%s: dp %llu gen 0x%x fname '%s' namehash 0x%x ino %llu namecookie 0x%llx\n"),
+			__func__,
+			(unsigned long long)dp->i_ino,
+			VFS_I(dp)->i_generation,
+			fname,
+			ag_pptr.namehash,
+			(unsigned long long)ino,
+			(unsigned long long)ag_pptr.name_cookie);
+}
diff --git a/repair/pptr.h b/repair/pptr.h
new file mode 100644
index 000000000000..7522379423ff
--- /dev/null
+++ b/repair/pptr.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __REPAIR_PPTR_H__
+#define __REPAIR_PPTR_H__
+
+void parent_ptr_free(struct xfs_mount *mp);
+void parent_ptr_init(struct xfs_mount *mp);
+
+void add_parent_ptr(xfs_ino_t ino, const unsigned char *fname,
+		struct xfs_inode *dp, bool possible_dup);
+
+#endif /* __REPAIR_PPTR_H__ */


