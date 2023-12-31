Return-Path: <linux-xfs+bounces-1355-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6938820DD0
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C0531F2136D
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 20:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B76BA30;
	Sun, 31 Dec 2023 20:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ot7Xvb9T"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBC3BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588FDC433C7;
	Sun, 31 Dec 2023 20:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055037;
	bh=pAUjcj6eDK4O+lk3UHyHVGwP9gskHCussAAFFjOoQ8c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ot7Xvb9TH15sb2ucdIDc7kiljnfTXI4LQfO7aHGxVrwsXgVMwDN9f5NQls6MG5WYg
	 KBrCtz82hWSX6QxPcMHRkW81LHMwx+18NupZnYjkgu2kyO2fi7TpYbyjPc0B+dhSF+
	 BmtEhQsWAdDOGVACMcUzsMgqURK3sVysRIza/+jSrgZIpsb7y7jVffqTeqZWDOfsy8
	 TRUmSgutst2JqvjvMyJ/kL465MFz0tGyq83WS3BNKXj8cVWAJrjla13qsbYwsUdasP
	 l7SyCXC+B+t3ld5Ul8sqL2bjMbkgtf1bLurINhmF05Ya6SMWqnGq7MOeTTpAwhF12i
	 a4zubP6SgRqKA==
Date: Sun, 31 Dec 2023 12:37:16 -0800
Subject: [PATCH 1/4] xfs: online repair of directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404836050.1753619.16054601221422863619.stgit@frogsfrogsfrogs>
In-Reply-To: <170404836024.1753619.16650627532281286267.stgit@frogsfrogsfrogs>
References: <170404836024.1753619.16650627532281286267.stgit@frogsfrogsfrogs>
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

If a directory looks like it's in bad shape, try to sift through the
rubble to find whatever directory entries we can, scan the directory
tree for the parent (if needed), stage the new directory contents in a
temporary file and use the atomic extent swapping mechanism to commit
the results in bulk.  As a side effect of this patch, directory
inactivation will be able to purge any leftover dir blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile              |    1 
 fs/xfs/scrub/dir.c           |    9 
 fs/xfs/scrub/dir_repair.c    | 1346 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/inode_repair.c  |    5 
 fs/xfs/scrub/nlinks.c        |   23 +
 fs/xfs/scrub/nlinks_repair.c |    9 
 fs/xfs/scrub/parent.c        |    4 
 fs/xfs/scrub/readdir.c       |    7 
 fs/xfs/scrub/repair.c        |    1 
 fs/xfs/scrub/repair.h        |    4 
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/tempfile.c      |   13 
 fs/xfs/scrub/tempfile.h      |    2 
 fs/xfs/scrub/trace.h         |  112 +++
 fs/xfs/xfs_inode.c           |   51 ++
 15 files changed, 1587 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/dir_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index be3dceb85e0f9..fd64a9043522c 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -198,6 +198,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   attr_repair.o \
 				   bmap_repair.o \
 				   cow_repair.o \
+				   dir_repair.o \
 				   fscounters_repair.o \
 				   ialloc_repair.o \
 				   inode_repair.o \
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 7bac74621af77..3fe6ffcf9c062 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -21,12 +21,21 @@
 #include "scrub/dabtree.h"
 #include "scrub/readdir.h"
 #include "scrub/health.h"
+#include "scrub/repair.h"
 
 /* Set us up to scrub directories. */
 int
 xchk_setup_directory(
 	struct xfs_scrub	*sc)
 {
+	int			error;
+
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_directory(sc);
+		if (error)
+			return error;
+	}
+
 	return xchk_setup_inode_contents(sc, 0);
 }
 
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
new file mode 100644
index 0000000000000..0b320212da230
--- /dev/null
+++ b/fs/xfs/scrub/dir_repair.c
@@ -0,0 +1,1346 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_bmap.h"
+#include "xfs_quota.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_bmap_util.h"
+#include "xfs_swapext.h"
+#include "xfs_xchgrange.h"
+#include "xfs_ag.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/tempfile.h"
+#include "scrub/tempswap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/xfblob.h"
+#include "scrub/readdir.h"
+#include "scrub/reap.h"
+
+/*
+ * Directory Repair
+ * ================
+ *
+ * We repair directories by reading the directory data blocks looking for
+ * directory entries that look salvageable (name passes verifiers, entry points
+ * to a valid allocated inode, etc).  Each entry worth salvaging is stashed in
+ * memory, and the stashed entries are periodically replayed into a temporary
+ * directory to constrain memory use.  Batching the construction of the
+ * temporary directory in this fashion reduces lock cycling of the directory
+ * being repaired and the temporary directory, and will later become important
+ * for parent pointer scanning.
+ *
+ * Directory entries added to the temporary directory do not elevate the link
+ * counts of the inodes found.  When salvaging completes, the remaining stashed
+ * entries are replayed to the temporary directory.  An atomic extent swap is
+ * used to commit the new directory blocks to the directory being repaired.
+ * This will disrupt readdir cursors.
+ *
+ * Legacy Locking Issues
+ * ---------------------
+ *
+ * Prior to Linux 6.5, if /a, /a/b, and /c were all directories, the VFS would
+ * not take i_rwsem on /a/b for a "mv /a/b /c/" operation.  This meant that
+ * only b's ILOCK protected b's dotdot update.  b's IOLOCK was not taken,
+ * unlike every other dotdot update (link, remove, mkdir).  If the repair code
+ * dropped the ILOCK, we it was required either to revalidate the dotdot entry
+ * or to use dirent hooks to capture updates from other threads.
+ */
+
+/* Directory entry to be restored in the new directory. */
+struct xrep_dirent {
+	/* Cookie for retrieval of the dirent name. */
+	xfblob_cookie		name_cookie;
+
+	/* Target inode number. */
+	xfs_ino_t		ino;
+
+	/* Length of the dirent name. */
+	uint8_t			namelen;
+
+	/* File type of the dirent. */
+	uint8_t			ftype;
+};
+
+/*
+ * Stash up to 8 pages of recovered dirent data in dir_entries and dir_names
+ * before we write them to the temp dir.
+ */
+#define XREP_DIR_MAX_STASH_BYTES	(PAGE_SIZE * 8)
+
+struct xrep_dir {
+	struct xfs_scrub	*sc;
+
+	/* Fixed-size array of xrep_dirent structures. */
+	struct xfarray		*dir_entries;
+
+	/* Blobs containing directory entry names. */
+	struct xfblob		*dir_names;
+
+	/* Information for swapping data forks at the end. */
+	struct xrep_tempswap	tx;
+
+	/* Preallocated args struct for performing dir operations */
+	struct xfs_da_args	args;
+
+	/*
+	 * This is the parent that we're going to set on the reconstructed
+	 * directory.
+	 */
+	xfs_ino_t		parent_ino;
+
+	/* How many subdirectories did we find? */
+	uint64_t		subdirs;
+
+	/* How many dirents did we find? */
+	unsigned int		dirents;
+
+	/* Directory entry name, plus the trailing null. */
+	unsigned char		namebuf[MAXNAMELEN];
+};
+
+/* Tear down all the incore stuff we created. */
+static void
+xrep_dir_teardown(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_dir		*rd = sc->buf;
+
+	xfblob_destroy(rd->dir_names);
+	xfarray_destroy(rd->dir_entries);
+}
+
+/* Set up for a directory repair. */
+int
+xrep_setup_directory(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_dir		*rd;
+	int			error;
+
+	error = xrep_tempfile_create(sc, S_IFDIR);
+	if (error)
+		return error;
+
+	rd = kvzalloc(sizeof(struct xrep_dir), XCHK_GFP_FLAGS);
+	if (!rd)
+		return -ENOMEM;
+	rd->sc = sc;
+	sc->buf = rd;
+
+	return 0;
+}
+
+/*
+ * If we're the root of a directory tree, we are our own parent.  If we're an
+ * unlinked directory, the parent /won't/ have a link to us.  Set the parent
+ * directory to the root for both cases.  Returns NULLFSINO if we don't know
+ * what to do.
+ */
+static inline xfs_ino_t
+xrep_dir_self_parent(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+
+	if (sc->ip->i_ino == sc->mp->m_sb.sb_rootino)
+		return sc->mp->m_sb.sb_rootino;
+
+	if (VFS_I(sc->ip)->i_nlink == 0)
+		return sc->mp->m_sb.sb_rootino;
+
+	return NULLFSINO;
+}
+
+/*
+ * Look up the dotdot entry.  Returns NULLFSINO if we don't know what to do.
+ * The next patch will check this more carefully.
+ */
+static inline xfs_ino_t
+xrep_dir_lookup_parent(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	xfs_ino_t		ino;
+	int			error;
+
+	error = xfs_dir_lookup(sc->tp, sc->ip, &xfs_name_dotdot, &ino, NULL);
+	if (error)
+		return NULLFSINO;
+	if (!xfs_verify_dir_ino(sc->mp, ino))
+		return NULLFSINO;
+
+	return ino;
+}
+
+/*
+ * Try to find the parent of the directory being repaired.
+ *
+ * NOTE: This function will someday be augmented by the directory parent repair
+ * code, which will know how to check the parent and scan the filesystem if
+ * we cannot find anything.  Inode scans will have to be done before we start
+ * salvaging directory entries, so we do this now.
+ */
+STATIC int
+xrep_dir_find_parent(
+	struct xrep_dir		*rd)
+{
+	xfs_ino_t		ino;
+
+	ino = xrep_dir_self_parent(rd);
+	if (ino != NULLFSINO) {
+		rd->parent_ino = ino;
+		return 0;
+	}
+
+	ino = xrep_dir_lookup_parent(rd);
+	if (ino != NULLFSINO) {
+		rd->parent_ino = ino;
+		return 0;
+	}
+
+	/* NOTE: A future patch will deal with moving orphans. */
+	return -EFSCORRUPTED;
+}
+
+/*
+ * Decide if we want to salvage this entry.  We don't bother with oversized
+ * names or the dot entry.
+ */
+STATIC int
+xrep_dir_want_salvage(
+	struct xrep_dir		*rd,
+	const char		*name,
+	int			namelen,
+	xfs_ino_t		ino)
+{
+	struct xfs_mount	*mp = rd->sc->mp;
+
+	/* No pointers to ourselves or to garbage. */
+	if (ino == rd->sc->ip->i_ino)
+		return false;
+	if (!xfs_verify_dir_ino(mp, ino))
+		return false;
+
+	/* No weird looking names or dot entries. */
+	if (namelen >= MAXNAMELEN || namelen <= 0)
+		return false;
+	if (namelen == 1 && name[0] == '.')
+		return false;
+
+	return true;
+}
+
+/*
+ * Remember that we want to create a dirent in the tempdir.  These stashed
+ * actions will be replayed later.
+ */
+STATIC int
+xrep_dir_stash_createname(
+	struct xrep_dir		*rd,
+	const struct xfs_name	*name,
+	xfs_ino_t		ino)
+{
+	struct xrep_dirent	dirent = {
+		.ino		= ino,
+		.namelen	= name->len,
+		.ftype		= name->type,
+	};
+	int			error;
+
+	trace_xrep_dir_stash_createname(rd->sc->tempip, name, ino);
+
+	error = xfblob_store(rd->dir_names, &dirent.name_cookie, name->name,
+			name->len);
+	if (error)
+		return error;
+
+	return xfarray_append(rd->dir_entries, &dirent);
+}
+
+/* Allocate an in-core record to hold entries while we rebuild the dir data. */
+STATIC int
+xrep_dir_salvage_entry(
+	struct xrep_dir		*rd,
+	unsigned char		*name,
+	unsigned int		namelen,
+	xfs_ino_t		ino)
+{
+	struct xfs_name		xname = {
+		.name		= name,
+	};
+	struct xfs_scrub	*sc = rd->sc;
+	struct xfs_inode	*ip;
+	unsigned int		i = 0;
+	int			error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	/*
+	 * Truncate the name to the first character that would trip namecheck.
+	 * If we no longer have a name after that, ignore this entry.
+	 */
+	while (i < namelen && name[i] != 0 && name[i] != '/')
+		i++;
+	if (i == 0)
+		return 0;
+	xname.len = i;
+
+	/* Ignore '..' entries; we already picked the new parent. */
+	if (xname.len == 2 && name[0] == '.' && name[1] == '.') {
+		trace_xrep_dir_salvaged_parent(sc->ip, ino);
+		return 0;
+	}
+
+	trace_xrep_dir_salvage_entry(sc->ip, &xname, ino);
+
+	/*
+	 * Compute the ftype or dump the entry if we can't.  We don't lock the
+	 * inode because inodes can't change type while we have a reference.
+	 */
+	error = xchk_iget(sc, ino, &ip);
+	if (error)
+		return 0;
+
+	xname.type = xfs_mode_to_ftype(VFS_I(ip)->i_mode);
+	xchk_irele(sc, ip);
+
+	return xrep_dir_stash_createname(rd, &xname, ino);
+}
+
+/* Record a shortform directory entry for later reinsertion. */
+STATIC int
+xrep_dir_salvage_sf_entry(
+	struct xrep_dir			*rd,
+	struct xfs_dir2_sf_hdr		*sfp,
+	struct xfs_dir2_sf_entry	*sfep)
+{
+	xfs_ino_t			ino;
+
+	ino = xfs_dir2_sf_get_ino(rd->sc->mp, sfp, sfep);
+	if (!xrep_dir_want_salvage(rd, sfep->name, sfep->namelen, ino))
+		return 0;
+
+	return xrep_dir_salvage_entry(rd, sfep->name, sfep->namelen, ino);
+}
+
+/* Record a regular directory entry for later reinsertion. */
+STATIC int
+xrep_dir_salvage_data_entry(
+	struct xrep_dir			*rd,
+	struct xfs_dir2_data_entry	*dep)
+{
+	xfs_ino_t			ino;
+
+	ino = be64_to_cpu(dep->inumber);
+	if (!xrep_dir_want_salvage(rd, dep->name, dep->namelen, ino))
+		return 0;
+
+	return xrep_dir_salvage_entry(rd, dep->name, dep->namelen, ino);
+}
+
+/* Try to recover block/data format directory entries. */
+STATIC int
+xrep_dir_recover_data(
+	struct xrep_dir		*rd,
+	struct xfs_buf		*bp)
+{
+	struct xfs_da_geometry	*geo = rd->sc->mp->m_dir_geo;
+	unsigned int		offset;
+	unsigned int		end;
+	int			error = 0;
+
+	/*
+	 * Loop over the data portion of the block.
+	 * Each object is a real entry (dep) or an unused one (dup).
+	 */
+	offset = geo->data_entry_offset;
+	end = min_t(unsigned int, BBTOB(bp->b_length),
+			xfs_dir3_data_end_offset(geo, bp->b_addr));
+
+	while (offset < end) {
+		struct xfs_dir2_data_unused	*dup = bp->b_addr + offset;
+		struct xfs_dir2_data_entry	*dep = bp->b_addr + offset;
+
+		if (xchk_should_terminate(rd->sc, &error))
+			return error;
+
+		/* Skip unused entries. */
+		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			offset += be16_to_cpu(dup->length);
+			continue;
+		}
+
+		/* Don't walk off the end of the block. */
+		offset += xfs_dir2_data_entsize(rd->sc->mp, dep->namelen);
+		if (offset > end)
+			break;
+
+		/* Ok, let's save this entry. */
+		error = xrep_dir_salvage_data_entry(rd, dep);
+		if (error)
+			return error;
+
+	}
+
+	return 0;
+}
+
+/* Try to recover shortform directory entries. */
+STATIC int
+xrep_dir_recover_sf(
+	struct xrep_dir			*rd)
+{
+	struct xfs_dir2_sf_hdr		*sfp;
+	struct xfs_dir2_sf_entry	*sfep;
+	struct xfs_dir2_sf_entry	*next;
+	struct xfs_ifork		*ifp;
+	xfs_ino_t			ino;
+	unsigned char			*end;
+	int				error = 0;
+
+	ifp = xfs_ifork_ptr(rd->sc->ip, XFS_DATA_FORK);
+	sfp = (struct xfs_dir2_sf_hdr *)rd->sc->ip->i_df.if_u1.if_data;
+	end = (unsigned char *)ifp->if_u1.if_data + ifp->if_bytes;
+
+	ino = xfs_dir2_sf_get_parent_ino(sfp);
+	trace_xrep_dir_salvaged_parent(rd->sc->ip, ino);
+
+	sfep = xfs_dir2_sf_firstentry(sfp);
+	while ((unsigned char *)sfep < end) {
+		if (xchk_should_terminate(rd->sc, &error))
+			return error;
+
+		next = xfs_dir2_sf_nextentry(rd->sc->mp, sfp, sfep);
+		if ((unsigned char *)next > end)
+			break;
+
+		/* Ok, let's save this entry. */
+		error = xrep_dir_salvage_sf_entry(rd, sfp, sfep);
+		if (error)
+			return error;
+
+		sfep = next;
+	}
+
+	return 0;
+}
+
+/*
+ * Try to figure out the format of this directory from the data fork mappings
+ * and the directory size.  If we can be reasonably sure of format, we can be
+ * more aggressive in salvaging directory entries.  On return, @magic_guess
+ * will be set to DIR3_BLOCK_MAGIC if we think this is a "block format"
+ * directory; DIR3_DATA_MAGIC if we think this is a "data format" directory,
+ * and 0 if we can't tell.
+ */
+STATIC void
+xrep_dir_guess_format(
+	struct xrep_dir		*rd,
+	__be32			*magic_guess)
+{
+	struct xfs_inode	*dp = rd->sc->ip;
+	struct xfs_mount	*mp = rd->sc->mp;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	xfs_fileoff_t		last;
+	int			error;
+
+	ASSERT(xfs_has_crc(mp));
+
+	*magic_guess = 0;
+
+	/*
+	 * If there's a single directory block and the directory size is
+	 * exactly one block, this has to be a single block format directory.
+	 */
+	error = xfs_bmap_last_offset(dp, &last, XFS_DATA_FORK);
+	if (!error && XFS_FSB_TO_B(mp, last) == geo->blksize &&
+	    dp->i_disk_size == geo->blksize) {
+		*magic_guess = cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
+		return;
+	}
+
+	/*
+	 * If the last extent before the leaf offset matches the directory
+	 * size and the directory size is larger than 1 block, this is a
+	 * data format directory.
+	 */
+	last = geo->leafblk;
+	error = xfs_bmap_last_before(rd->sc->tp, dp, &last, XFS_DATA_FORK);
+	if (!error &&
+	    XFS_FSB_TO_B(mp, last) > geo->blksize &&
+	    XFS_FSB_TO_B(mp, last) == dp->i_disk_size) {
+		*magic_guess = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
+		return;
+	}
+}
+
+/* Recover directory entries from a specific directory block. */
+STATIC int
+xrep_dir_recover_dirblock(
+	struct xrep_dir		*rd,
+	__be32			magic_guess,
+	xfs_dablk_t		dabno)
+{
+	struct xfs_dir2_data_hdr *hdr;
+	struct xfs_buf		*bp;
+	__be32			oldmagic;
+	int			error;
+
+	/*
+	 * Try to read buffer.  We invalidate them in the next step so we don't
+	 * bother to set a buffer type or ops.
+	 */
+	error = xfs_da_read_buf(rd->sc->tp, rd->sc->ip, dabno,
+			XFS_DABUF_MAP_HOLE_OK, &bp, XFS_DATA_FORK, NULL);
+	if (error || !bp)
+		return error;
+
+	hdr = bp->b_addr;
+	oldmagic = hdr->magic;
+
+	trace_xrep_dir_recover_dirblock(rd->sc->ip, dabno,
+			be32_to_cpu(hdr->magic), be32_to_cpu(magic_guess));
+
+	/*
+	 * If we're sure of the block's format, proceed with the salvage
+	 * operation using the specified magic number.
+	 */
+	if (magic_guess) {
+		hdr->magic = magic_guess;
+		goto recover;
+	}
+
+	/*
+	 * If we couldn't guess what type of directory this is, then we will
+	 * only salvage entries from directory blocks that match the magic
+	 * number and pass verifiers.
+	 */
+	switch (hdr->magic) {
+	case cpu_to_be32(XFS_DIR2_BLOCK_MAGIC):
+	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
+		if (!xrep_buf_verify_struct(bp, &xfs_dir3_block_buf_ops))
+			goto out;
+		if (xfs_dir3_block_header_check(bp, rd->sc->ip->i_ino) != NULL)
+			goto out;
+		break;
+	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
+	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
+		if (!xrep_buf_verify_struct(bp, &xfs_dir3_data_buf_ops))
+			goto out;
+		if (xfs_dir3_data_header_check(bp, rd->sc->ip->i_ino) != NULL)
+			goto out;
+		break;
+	default:
+		goto out;
+	}
+
+recover:
+	error = xrep_dir_recover_data(rd, bp);
+
+out:
+	hdr->magic = oldmagic;
+	xfs_trans_brelse(rd->sc->tp, bp);
+	return error;
+}
+
+static inline void
+xrep_dir_init_args(
+	struct xrep_dir		*rd,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*name)
+{
+	memset(&rd->args, 0, sizeof(struct xfs_da_args));
+	rd->args.geo = rd->sc->mp->m_dir_geo;
+	rd->args.whichfork = XFS_DATA_FORK;
+	rd->args.owner = rd->sc->ip->i_ino;
+	rd->args.trans = rd->sc->tp;
+	rd->args.dp = dp;
+	if (!name)
+		return;
+	rd->args.name = name->name;
+	rd->args.namelen = name->len;
+	rd->args.filetype = name->type;
+	rd->args.hashval = xfs_dir2_hashname(rd->sc->mp, name);
+}
+
+/* Replay a stashed createname into the temporary directory. */
+STATIC int
+xrep_dir_replay_createname(
+	struct xrep_dir		*rd,
+	const struct xfs_name	*name,
+	xfs_ino_t		inum,
+	xfs_extlen_t		total)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	struct xfs_inode	*dp = rd->sc->tempip;
+	bool			is_block, is_leaf;
+	int			error;
+
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+
+	error = xfs_dir_ino_validate(sc->mp, inum);
+	if (error)
+		return error;
+
+	trace_xrep_dir_replay_createname(dp, name, inum);
+
+	xrep_dir_init_args(rd, dp, name);
+	rd->args.inumber = inum;
+	rd->args.total = total;
+	rd->args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return xfs_dir2_sf_addname(&rd->args);
+
+	error = xfs_dir2_isblock(&rd->args, &is_block);
+	if (error)
+		return error;
+	if (is_block)
+		return xfs_dir2_block_addname(&rd->args);
+
+	error = xfs_dir2_isleaf(&rd->args, &is_leaf);
+	if (error)
+		return error;
+	if (is_leaf)
+		return xfs_dir2_leaf_addname(&rd->args);
+
+	return xfs_dir2_node_addname(&rd->args);
+}
+
+/*
+ * Add this stashed incore directory entry to the temporary directory.
+ * The caller must hold the tempdir's IOLOCK, must not hold any ILOCKs, and
+ * must not be in transaction context.
+ */
+STATIC int
+xrep_dir_replay_update(
+	struct xrep_dir			*rd,
+	const struct xrep_dirent	*dirent)
+{
+	struct xfs_name			name = {
+		.len			= dirent->namelen,
+		.type			= dirent->ftype,
+		.name			= rd->namebuf,
+	};
+	struct xfs_mount		*mp = rd->sc->mp;
+#ifdef DEBUG
+	xfs_ino_t			ino;
+#endif
+	uint				resblks;
+	int				error;
+
+	resblks = XFS_LINK_SPACE_RES(mp, dirent->namelen);
+	error = xchk_trans_alloc(rd->sc, resblks);
+	if (error)
+		return error;
+
+	/* Lock the temporary directory and join it to the transaction */
+	xrep_tempfile_ilock(rd->sc);
+	xfs_trans_ijoin(rd->sc->tp, rd->sc->tempip, 0);
+
+	/*
+	 * Create a replacement dirent in the temporary directory.  Note that
+	 * _createname doesn't check for existing entries.  There shouldn't be
+	 * any in the temporary dir, but we'll verify this in debug mode.
+	 */
+#ifdef DEBUG
+	error = xchk_dir_lookup(rd->sc, rd->sc->tempip, &name, &ino);
+	if (error != -ENOENT) {
+		ASSERT(error != -ENOENT);
+		goto out_cancel;
+	}
+#endif
+
+	error = xrep_dir_replay_createname(rd, &name, dirent->ino, resblks);
+	if (error)
+		goto out_cancel;
+
+	if (name.type == XFS_DIR3_FT_DIR)
+		rd->subdirs++;
+	rd->dirents++;
+
+	/* Commit and unlock. */
+	error = xrep_trans_commit(rd->sc);
+	if (error)
+		return error;
+
+	xrep_tempfile_iunlock(rd->sc);
+	return 0;
+out_cancel:
+	xchk_trans_cancel(rd->sc);
+	xrep_tempfile_iunlock(rd->sc);
+	return error;
+}
+
+/*
+ * Flush stashed incore dirent updates that have been recorded by the scanner.
+ * This is done to reduce the memory requirements of the directory rebuild,
+ * since directories can contain up to 32GB of directory data.
+ *
+ * Caller must not hold transactions or ILOCKs.  Caller must hold the tempdir
+ * IOLOCK.
+ */
+STATIC int
+xrep_dir_replay_updates(
+	struct xrep_dir		*rd)
+{
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	/* Add all the salvaged dirents to the temporary directory. */
+	foreach_xfarray_idx(rd->dir_entries, array_cur) {
+		struct xrep_dirent	dirent;
+
+		error = xfarray_load(rd->dir_entries, array_cur, &dirent);
+		if (error)
+			return error;
+
+		/* The dirent name is stored in the in-core buffer. */
+		error = xfblob_load(rd->dir_names, dirent.name_cookie,
+				rd->namebuf, dirent.namelen);
+		if (error)
+			return error;
+		rd->namebuf[MAXNAMELEN - 1] = 0;
+
+		error = xrep_dir_replay_update(rd, &dirent);
+		if (error)
+			return error;
+	}
+
+	/* Empty out both arrays now that we've added the entries. */
+	xfarray_truncate(rd->dir_entries);
+	xfblob_truncate(rd->dir_names);
+	return 0;
+}
+
+/*
+ * Periodically flush stashed directory entries to the temporary dir.  This
+ * is done to reduce the memory requirements of the directory rebuild, since
+ * directories can contain up to 32GB of directory data.
+ */
+STATIC int
+xrep_dir_flush_stashed(
+	struct xrep_dir		*rd)
+{
+	int			error;
+
+	/*
+	 * Entering this function, the scrub context has a reference to the
+	 * inode being repaired, the temporary file, and a scrub transaction
+	 * that we use during dirent salvaging to avoid livelocking if there
+	 * are cycles in the directory structures.  We hold ILOCK_EXCL on both
+	 * the inode being repaired and the temporary file, though they are
+	 * not ijoined to the scrub transaction.
+	 *
+	 * To constrain kernel memory use, we occasionally write salvaged
+	 * dirents from the xfarray and xfblob structures into the temporary
+	 * directory in preparation for swapping the directory structures at
+	 * the end.  Updating the temporary file requires a transaction, so we
+	 * commit the scrub transaction and drop the two ILOCKs so that
+	 * we can allocate whatever transaction we want.
+	 *
+	 * We still hold IOLOCK_EXCL on the inode being repaired, which
+	 * prevents anyone from accessing the damaged directory data while we
+	 * repair it.
+	 */
+	error = xrep_trans_commit(rd->sc);
+	if (error)
+		return error;
+	xchk_iunlock(rd->sc, XFS_ILOCK_EXCL);
+
+	/*
+	 * Take the IOLOCK of the temporary file while we modify dirents.  This
+	 * isn't strictly required because the temporary file is never revealed
+	 * to userspace, but we follow the same locking rules.  We still hold
+	 * sc->ip's IOLOCK.
+	 */
+	error = xrep_tempfile_iolock_polled(rd->sc);
+	if (error)
+		return error;
+
+	/* Write to the tempdir all the updates that we've stashed. */
+	error = xrep_dir_replay_updates(rd);
+	xrep_tempfile_iounlock(rd->sc);
+	if (error)
+		return error;
+
+	/*
+	 * Recreate the salvage transaction and relock the dir we're salvaging.
+	 */
+	error = xchk_trans_alloc(rd->sc, 0);
+	if (error)
+		return error;
+	xchk_ilock(rd->sc, XFS_ILOCK_EXCL);
+	return 0;
+}
+
+/* Decide if we've stashed too much dirent data in memory. */
+static inline bool
+xrep_dir_want_flush_stashed(
+	struct xrep_dir		*rd)
+{
+	unsigned long long	bytes;
+
+	bytes = xfarray_bytes(rd->dir_entries) + xfblob_bytes(rd->dir_names);
+	return bytes > XREP_DIR_MAX_STASH_BYTES;
+}
+
+/* Extract as many directory entries as we can. */
+STATIC int
+xrep_dir_recover(
+	struct xrep_dir		*rd)
+{
+	struct xfs_bmbt_irec	got;
+	struct xfs_scrub	*sc = rd->sc;
+	struct xfs_da_geometry	*geo = sc->mp->m_dir_geo;
+	xfs_fileoff_t		offset;
+	xfs_dablk_t		dabno;
+	__be32			magic_guess;
+	int			nmap;
+	int			error;
+
+	xrep_dir_guess_format(rd, &magic_guess);
+
+	/* Iterate each directory data block in the data fork. */
+	for (offset = 0;
+	     offset < geo->leafblk;
+	     offset = got.br_startoff + got.br_blockcount) {
+		nmap = 1;
+		error = xfs_bmapi_read(sc->ip, offset, geo->leafblk - offset,
+				&got, &nmap, 0);
+		if (error)
+			return error;
+		if (nmap != 1)
+			return -EFSCORRUPTED;
+		if (!xfs_bmap_is_written_extent(&got))
+			continue;
+
+		for (dabno = round_up(got.br_startoff, geo->fsbcount);
+		     dabno < got.br_startoff + got.br_blockcount;
+		     dabno += geo->fsbcount) {
+			if (xchk_should_terminate(rd->sc, &error))
+				return error;
+
+			error = xrep_dir_recover_dirblock(rd,
+					magic_guess, dabno);
+			if (error)
+				return error;
+
+			/* Flush dirents to constrain memory usage. */
+			if (xrep_dir_want_flush_stashed(rd)) {
+				error = xrep_dir_flush_stashed(rd);
+				if (error)
+					return error;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Find all the directory entries for this inode by scraping them out of the
+ * directory leaf blocks by hand, and flushing them into the temp dir.
+ */
+STATIC int
+xrep_dir_find_entries(
+	struct xrep_dir		*rd)
+{
+	struct xfs_inode	*dp = rd->sc->ip;
+	int			error;
+
+	/*
+	 * Salvage directory entries from the old directory, and write them to
+	 * the temporary directory.
+	 */
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		error = xrep_dir_recover_sf(rd);
+	} else {
+		error = xfs_iread_extents(rd->sc->tp, dp, XFS_DATA_FORK);
+		if (error)
+			return error;
+
+		error = xrep_dir_recover(rd);
+	}
+	if (error)
+		return error;
+
+	return xrep_dir_flush_stashed(rd);
+}
+
+/* Scan all files in the filesystem for dirents. */
+STATIC int
+xrep_dir_salvage_entries(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	int			error;
+
+	/*
+	 * Drop the ILOCK on this directory so that we can scan for this
+	 * directory's parent.  Figure out who is going to be the parent of
+	 * this directory, then retake the ILOCK so that we can salvage
+	 * directory entries.
+	 */
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+	error = xrep_dir_find_parent(rd);
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
+	if (error)
+		return error;
+
+	/*
+	 * Collect directory entries by parsing raw leaf blocks to salvage
+	 * whatever we can.  When we're done, free the staging memory before
+	 * swapping the directories to reduce memory usage.
+	 */
+	error = xrep_dir_find_entries(rd);
+	if (error)
+		return error;
+
+	/*
+	 * Cancel the repair transaction and drop the ILOCK so that we can
+	 * (later) use the atomic extent swap helper functions to compute the
+	 * correct block reservations and re-lock the inodes.
+	 *
+	 * We still hold IOLOCK_EXCL (aka i_rwsem) which will prevent directory
+	 * modifications, but there's nothing to prevent userspace from reading
+	 * the directory until we're ready for the swap operation.  Reads will
+	 * return -EIO without shutting down the fs, so we're ok with that.
+	 */
+	error = xrep_trans_commit(sc);
+	if (error)
+		return error;
+
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+	return 0;
+}
+
+
+/*
+ * Free all the directory blocks and reset the data fork.  The caller must
+ * join the inode to the transaction.  This function returns with the inode
+ * joined to a clean scrub transaction.
+ */
+STATIC int
+xrep_dir_reset_fork(
+	struct xrep_dir		*rd,
+	xfs_ino_t		parent_ino)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->tempip, XFS_DATA_FORK);
+	int			error;
+
+	/* Unmap all the directory buffers. */
+	if (xfs_ifork_has_extents(ifp)) {
+		error = xrep_reap_ifork(sc, sc->tempip, XFS_DATA_FORK);
+		if (error)
+			return error;
+	}
+
+	trace_xrep_dir_reset_fork(sc->tempip, parent_ino);
+
+	/* Reset the data fork to an empty data fork. */
+	xfs_idestroy_fork(ifp);
+	ifp->if_bytes = 0;
+	sc->tempip->i_disk_size = 0;
+
+	/* Reinitialize the short form directory. */
+	xrep_dir_init_args(rd, sc->tempip, NULL);
+	return xfs_dir2_sf_create(&rd->args, parent_ino);
+}
+
+/*
+ * Prepare both inodes' directory forks for extent swapping.  Promote the
+ * tempfile from short format to leaf format, and if the file being repaired
+ * has a short format data fork, turn it into an empty extent list.
+ */
+STATIC int
+xrep_dir_swap_prep(
+	struct xfs_scrub	*sc,
+	bool			temp_local,
+	bool			ip_local)
+{
+	int			error;
+
+	/*
+	 * If the tempfile's directory is in shortform format, convert that
+	 * to a single leaf extent so that we can use the atomic extent swap.
+	 */
+	if (temp_local) {
+		struct xfs_da_args	args = {
+			.dp		= sc->tempip,
+			.geo		= sc->mp->m_dir_geo,
+			.whichfork	= XFS_DATA_FORK,
+			.trans		= sc->tp,
+			.total		= 1,
+			.owner		= sc->ip->i_ino,
+		};
+
+		error = xfs_dir2_sf_to_block(&args);
+		if (error)
+			return error;
+
+		/*
+		 * Roll the deferred log items to get us back to a clean
+		 * transaction.
+		 */
+		error = xfs_defer_finish(&sc->tp);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * If the file being repaired had a shortform data fork, convert that
+	 * to an empty extent list in preparation for the atomic extent swap.
+	 */
+	if (ip_local) {
+		struct xfs_ifork	*ifp;
+
+		ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
+		xfs_idestroy_fork(ifp);
+		ifp->if_format = XFS_DINODE_FMT_EXTENTS;
+		ifp->if_nextents = 0;
+		ifp->if_bytes = 0;
+		ifp->if_u1.if_root = NULL;
+		ifp->if_height = 0;
+
+		xfs_trans_log_inode(sc->tp, sc->ip,
+				XFS_ILOG_CORE | XFS_ILOG_DDATA);
+	}
+
+	return 0;
+}
+
+/*
+ * Replace the inode number of a directory entry.
+ */
+static int
+xrep_dir_replace(
+	struct xrep_dir		*rd,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*name,
+	xfs_ino_t		inum,
+	xfs_extlen_t		total)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	bool			is_block, is_leaf;
+	int			error;
+
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+
+	error = xfs_dir_ino_validate(sc->mp, inum);
+	if (error)
+		return error;
+
+	xrep_dir_init_args(rd, dp, name);
+	rd->args.inumber = inum;
+	rd->args.total = total;
+
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return xfs_dir2_sf_replace(&rd->args);
+
+	error = xfs_dir2_isblock(&rd->args, &is_block);
+	if (error)
+		return error;
+	if (is_block)
+		return xfs_dir2_block_replace(&rd->args);
+
+	error = xfs_dir2_isleaf(&rd->args, &is_leaf);
+	if (error)
+		return error;
+	if (is_leaf)
+		return xfs_dir2_leaf_replace(&rd->args);
+
+	return xfs_dir2_node_replace(&rd->args);
+}
+
+/*
+ * Reset the link count of this directory and adjust the unlinked list pointers
+ * as needed.
+ */
+STATIC int
+xrep_dir_set_nlink(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	struct xfs_inode	*dp = sc->ip;
+	struct xfs_perag	*pag;
+	unsigned int		new_nlink = rd->subdirs + 2;
+	int			error;
+
+	/*
+	 * The directory is not on the incore unlinked list, which means that
+	 * it needs to be reachable via the directory tree.  Update the nlink
+	 * with our observed link count.
+	 *
+	 * XXX: A subsequent patch will handle parentless directories by moving
+	 * them to the lost and found instead of aborting the repair.
+	 */
+	if (!xfs_inode_on_unlinked_list(dp))
+		goto reset_nlink;
+
+	/*
+	 * The directory is on the unlinked list and we did not find any
+	 * dirents.  Set the link count to zero and let the directory
+	 * inactivate when the last reference drops.
+	 */
+	if (rd->dirents == 0) {
+		new_nlink = 0;
+		goto reset_nlink;
+	}
+
+	/*
+	 * The directory is on the unlinked list and we found dirents.  This
+	 * directory needs to be reachable via the directory tree.  Remove the
+	 * dir from the unlinked list and update nlink with the observed link
+	 * count.
+	 */
+	pag = xfs_perag_get(sc->mp, XFS_INO_TO_AGNO(sc->mp, dp->i_ino));
+	if (!pag) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	error = xfs_iunlink_remove(sc->tp, pag, dp);
+	xfs_perag_put(pag);
+	if (error)
+		return error;
+
+reset_nlink:
+	if (VFS_I(dp)->i_nlink != new_nlink)
+		set_nlink(VFS_I(dp), new_nlink);
+	return 0;
+}
+
+/* Swap the temporary directory's data fork with the one being repaired. */
+STATIC int
+xrep_dir_swap(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	bool			ip_local, temp_local;
+	int			error = 0;
+
+	/*
+	 * If we found enough subdirs to overflow this directory's link count,
+	 * bail out to userspace before we modify anything.
+	 */
+	if (rd->subdirs + 2 > XFS_MAXLINK)
+		return -EFSCORRUPTED;
+
+	/*
+	 * Reset the temporary directory's '..' entry to point to the parent
+	 * that we found.  The temporary directory was created with the root
+	 * directory as the parent, so we can skip this if repairing a
+	 * subdirectory of the root.
+	 *
+	 * It's also possible that this replacement could also expand a sf
+	 * tempdir into block format.
+	 */
+	if (rd->parent_ino != sc->mp->m_rootip->i_ino) {
+		error = xrep_dir_replace(rd, rd->sc->tempip, &xfs_name_dotdot,
+				rd->parent_ino, rd->tx.req.resblks);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Changing the dot and dotdot entries could have changed the shape of
+	 * the directory, so we recompute these.
+	 */
+	ip_local = sc->ip->i_df.if_format == XFS_DINODE_FMT_LOCAL;
+	temp_local = sc->tempip->i_df.if_format == XFS_DINODE_FMT_LOCAL;
+
+	/*
+	 * If the both files have a local format data fork and the rebuilt
+	 * directory data would fit in the repaired file's data fork, copy
+	 * the contents from the tempfile and update the directory link count.
+	 * We're done now.
+	 */
+	if (ip_local && temp_local &&
+	    sc->tempip->i_disk_size <= xfs_inode_data_fork_size(sc->ip)) {
+		xrep_tempfile_copyout_local(sc, XFS_DATA_FORK);
+		return xrep_dir_set_nlink(rd);
+	}
+
+	/* Clean the transaction before we start working on the extent swap. */
+	error = xrep_tempfile_roll_trans(rd->sc);
+	if (error)
+		return error;
+
+	/* Otherwise, make sure both data forks are in block-mapping mode. */
+	error = xrep_dir_swap_prep(sc, temp_local, ip_local);
+	if (error)
+		return error;
+
+	/*
+	 * Set nlink of the directory in the same transaction sequence that
+	 * (atomically) commits the new directory data.
+	 */
+	error = xrep_dir_set_nlink(rd);
+	if (error)
+		return error;
+
+	return xrep_tempswap_contents(sc, &rd->tx);
+}
+
+/*
+ * Swap the new directory contents (which we created in the tempfile) into the
+ * directory being repaired.
+ */
+STATIC int
+xrep_dir_rebuild_tree(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	int			error;
+
+	trace_xrep_dir_rebuild_tree(sc->ip, rd->parent_ino);
+
+	/*
+	 * Take the IOLOCK on the temporary file so that we can run dir
+	 * operations with the same locks held as we would for a normal file.
+	 * We still hold sc->ip's IOLOCK.
+	 */
+	error = xrep_tempfile_iolock_polled(rd->sc);
+	if (error)
+		return error;
+
+	/* Allocate transaction and ILOCK the scrub file and the temp file. */
+	error = xrep_tempswap_trans_alloc(sc, XFS_DATA_FORK, &rd->tx);
+	if (error)
+		return error;
+
+	/*
+	 * Swap the tempdir's data fork with the file being repaired.  This
+	 * recreates the transaction and re-takes the ILOCK in the scrub
+	 * context.
+	 */
+	error = xrep_dir_swap(rd);
+	if (error)
+		return error;
+
+	/*
+	 * Release the old directory blocks and reset the data fork of the temp
+	 * directory to an empty shortform directory because inactivation does
+	 * nothing for directories.
+	 */
+	error = xrep_dir_reset_fork(rd, sc->mp->m_rootip->i_ino);
+	if (error)
+		return error;
+
+	/*
+	 * Roll to get a transaction without any inodes joined to it.  Then we
+	 * can drop the tempfile's ILOCK and IOLOCK before doing more work on
+	 * the scrub target directory.
+	 */
+	error = xfs_trans_roll(&sc->tp);
+	if (error)
+		return error;
+
+	xrep_tempfile_iunlock(sc);
+	xrep_tempfile_iounlock(sc);
+	return 0;
+}
+
+/* Set up the filesystem scan so we can regenerate directory entries. */
+STATIC int
+xrep_dir_setup_scan(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	char			*descr;
+	int			error;
+
+	rd->parent_ino = NULLFSINO;
+
+	/* Set up some staging memory for salvaging dirents. */
+	descr = xchk_xfile_ino_descr(sc, "directory entries");
+	error = xfarray_create(descr, 0, sizeof(struct xrep_dirent),
+			&rd->dir_entries);
+	kfree(descr);
+	if (error)
+		return error;
+
+	descr = xchk_xfile_ino_descr(sc, "directory entry names");
+	error = xfblob_create(descr, &rd->dir_names);
+	kfree(descr);
+	if (error)
+		goto out_xfarray;
+
+	return 0;
+
+out_xfarray:
+	xfarray_destroy(rd->dir_entries);
+	rd->dir_entries = NULL;
+	return error;
+}
+
+/*
+ * Repair the directory metadata.
+ *
+ * XXX: Directory entry buffers can be multiple fsblocks in size.  The buffer
+ * cache in XFS can't handle aliased multiblock buffers, so this might
+ * misbehave if the directory blocks are crosslinked with other filesystem
+ * metadata.
+ *
+ * XXX: Is it necessary to check the dcache for this directory to make sure
+ * that we always recreate every cached entry?
+ */
+int
+xrep_directory(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_dir		*rd = sc->buf;
+	int			error;
+
+	/* The rmapbt is required to reap the old data fork. */
+	if (!xfs_has_rmapbt(sc->mp))
+		return -EOPNOTSUPP;
+
+	error = xrep_dir_setup_scan(rd);
+	if (error)
+		return error;
+
+	error = xrep_dir_salvage_entries(rd);
+	if (error)
+		goto out_teardown;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		goto out_teardown;
+
+	error = xrep_dir_rebuild_tree(rd);
+	if (error)
+		goto out_teardown;
+
+out_teardown:
+	xrep_dir_teardown(sc);
+	return error;
+}
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 50bcc5a4c3df1..e46b1256b0851 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -46,6 +46,7 @@
 #include "scrub/repair.h"
 #include "scrub/iscan.h"
 #include "scrub/readdir.h"
+#include "scrub/tempfile.h"
 
 /*
  * Inode Record Repair
@@ -295,6 +296,10 @@ xrep_dinode_findmode_walk_directory(
 	unsigned int		lock_mode;
 	int			error = 0;
 
+	/* Ignore temporary repair directories. */
+	if (xrep_is_tempfile(dp))
+		return 0;
+
 	/*
 	 * Scan the directory to see if there it contains an entry pointing to
 	 * the directory that we are repairing.
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 8eb0f96932866..a6d68d9eb3d7e 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -27,6 +27,7 @@
 #include "scrub/nlinks.h"
 #include "scrub/trace.h"
 #include "scrub/readdir.h"
+#include "scrub/tempfile.h"
 
 /*
  * Live Inode Link Count Checking
@@ -152,6 +153,13 @@ xchk_nlinks_live_update(
 
 	xnc = container_of(nb, struct xchk_nlink_ctrs, hooks.dirent_hook.nb);
 
+	/*
+	 * Ignore temporary directories being used to stage dir repairs, since
+	 * we don't bump the link counts of the children.
+	 */
+	if (xrep_is_tempfile(p->dp))
+		return NOTIFY_DONE;
+
 	trace_xchk_nlinks_live_update(xnc->sc->mp, p->dp, action, p->ip->i_ino,
 			p->delta, p->name->name, p->name->len);
 
@@ -303,6 +311,13 @@ xchk_nlinks_collect_dir(
 	unsigned int		lock_mode;
 	int			error = 0;
 
+	/*
+	 * Ignore temporary directories being used to stage dir repairs, since
+	 * we don't bump the link counts of the children.
+	 */
+	if (xrep_is_tempfile(dp))
+		return 0;
+
 	/* Prevent anyone from changing this directory while we walk it. */
 	xfs_ilock(dp, XFS_IOLOCK_SHARED);
 	lock_mode = xfs_ilock_data_map_shared(dp);
@@ -537,6 +552,14 @@ xchk_nlinks_compare_inode(
 	unsigned int		actual_nlink;
 	int			error;
 
+	/*
+	 * Ignore temporary files being used to stage repairs, since we assume
+	 * they're correct for non-directories, and the directory repair code
+	 * doesn't bump the link counts for the children.
+	 */
+	if (xrep_is_tempfile(ip))
+		return 0;
+
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	mutex_lock(&xnc->lock);
 
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 58cacb8e94c1b..23eb08c4b5ad5 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -26,6 +26,7 @@
 #include "scrub/iscan.h"
 #include "scrub/nlinks.h"
 #include "scrub/trace.h"
+#include "scrub/tempfile.h"
 
 /*
  * Live Inode Link Count Repair
@@ -68,6 +69,14 @@ xrep_nlinks_repair_inode(
 	bool			dirty = false;
 	int			error;
 
+	/*
+	 * Ignore temporary files being used to stage repairs, since we assume
+	 * they're correct for non-directories, and the directory repair code
+	 * doesn't bump the link counts for the children.
+	 */
+	if (xrep_is_tempfile(ip))
+		return 0;
+
 	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &sc->tp);
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 5da10ed1fe8ce..050a8e8914f6e 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -17,6 +17,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/readdir.h"
+#include "scrub/tempfile.h"
 
 /* Set us up to scrub parents. */
 int
@@ -143,7 +144,8 @@ xchk_parent_validate(
 	}
 	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
 		return error;
-	if (dp == sc->ip || dp == sc->tempip || !S_ISDIR(VFS_I(dp)->i_mode)) {
+	if (dp == sc->ip || xrep_is_tempfile(dp) ||
+	    !S_ISDIR(VFS_I(dp)->i_mode)) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		goto out_rele;
 	}
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index d58a15c63a2dc..d70dbbd4c9040 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -335,6 +335,13 @@ xchk_dir_lookup(
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
 
+	/*
+	 * A temporary directory's block headers are written with the owner
+	 * set to sc->ip, so we must switch the owner here for the lookup.
+	 */
+	if (dp == sc->tempip)
+		args.owner = sc->ip->i_ino;
+
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	ASSERT(xfs_isilocked(dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 83b7aa48dec19..ef17a08320782 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -35,6 +35,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_attr.h"
+#include "xfs_dir2.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 2bc5dd18d46f4..8fc582b286c0a 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -91,6 +91,7 @@ int xrep_metadata_inode_forks(struct xfs_scrub *sc);
 int xrep_setup_ag_rmapbt(struct xfs_scrub *sc);
 int xrep_setup_ag_refcountbt(struct xfs_scrub *sc);
 int xrep_setup_xattr(struct xfs_scrub *sc);
+int xrep_setup_directory(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -125,6 +126,7 @@ int xrep_bmap_cow(struct xfs_scrub *sc);
 int xrep_nlinks(struct xfs_scrub *sc);
 int xrep_fscounters(struct xfs_scrub *sc);
 int xrep_xattr(struct xfs_scrub *sc);
+int xrep_directory(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -195,6 +197,7 @@ xrep_setup_nothing(
 #define xrep_setup_ag_rmapbt		xrep_setup_nothing
 #define xrep_setup_ag_refcountbt	xrep_setup_nothing
 #define xrep_setup_xattr		xrep_setup_nothing
+#define xrep_setup_directory		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
@@ -221,6 +224,7 @@ xrep_setup_nothing(
 #define xrep_fscounters			xrep_notsupported
 #define xrep_rtsummary			xrep_notsupported
 #define xrep_xattr			xrep_notsupported
+#define xrep_directory			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 0b8fdd62055fe..bda7a0c91e241 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -328,7 +328,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_directory,
 		.scrub	= xchk_directory,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_directory,
 	},
 	[XFS_SCRUB_TYPE_XATTR] = {	/* extended attributes */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index f1726822e18f7..49361e03ad8a4 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -853,3 +853,16 @@ xrep_tempfile_copyout_local(
 	ilog_flags |= xfs_ilog_fdata(whichfork);
 	xfs_trans_log_inode(sc->tp, sc->ip, ilog_flags);
 }
+
+/* Decide if a given XFS inode is a temporary file for a repair. */
+bool
+xrep_is_tempfile(
+	const struct xfs_inode	*ip)
+{
+	const struct inode	*inode = &ip->i_vnode;
+
+	if (IS_PRIVATE(inode) && !(inode->i_opflags & IOP_XATTR))
+		return true;
+
+	return false;
+}
diff --git a/fs/xfs/scrub/tempfile.h b/fs/xfs/scrub/tempfile.h
index d57e4f145a7c8..e51399f595fe9 100644
--- a/fs/xfs/scrub/tempfile.h
+++ b/fs/xfs/scrub/tempfile.h
@@ -35,11 +35,13 @@ int xrep_tempfile_set_isize(struct xfs_scrub *sc, unsigned long long isize);
 
 int xrep_tempfile_roll_trans(struct xfs_scrub *sc);
 void xrep_tempfile_copyout_local(struct xfs_scrub *sc, int whichfork);
+bool xrep_is_tempfile(const struct xfs_inode *ip);
 #else
 static inline void xrep_tempfile_iolock_both(struct xfs_scrub *sc)
 {
 	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 }
+# define xrep_is_tempfile(ip)		(false)
 # define xrep_tempfile_rele(sc)
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 87a68aee16bf5..f8b7f0fc38051 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2581,6 +2581,118 @@ DEFINE_EVENT(xrep_xattr_class, name, \
 DEFINE_XREP_XATTR_EVENT(xrep_xattr_rebuild_tree);
 DEFINE_XREP_XATTR_EVENT(xrep_xattr_reset_fork);
 
+TRACE_EVENT(xrep_dir_recover_dirblock,
+	TP_PROTO(struct xfs_inode *dp, xfs_dablk_t dabno, uint32_t magic,
+		 uint32_t magic_guess),
+	TP_ARGS(dp, dabno, magic, magic_guess),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir_ino)
+		__field(xfs_dablk_t, dabno)
+		__field(uint32_t, magic)
+		__field(uint32_t, magic_guess)
+	),
+	TP_fast_assign(
+		__entry->dev = dp->i_mount->m_super->s_dev;
+		__entry->dir_ino = dp->i_ino;
+		__entry->dabno = dabno;
+		__entry->magic = magic;
+		__entry->magic_guess = magic_guess;
+	),
+	TP_printk("dev %d:%d dir 0x%llx dablk 0x%x magic 0x%x magic_guess 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir_ino,
+		  __entry->dabno,
+		  __entry->magic,
+		  __entry->magic_guess)
+);
+
+DECLARE_EVENT_CLASS(xrep_dir_class,
+	TP_PROTO(struct xfs_inode *dp, xfs_ino_t parent_ino),
+	TP_ARGS(dp, parent_ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir_ino)
+		__field(xfs_ino_t, parent_ino)
+	),
+	TP_fast_assign(
+		__entry->dev = dp->i_mount->m_super->s_dev;
+		__entry->dir_ino = dp->i_ino;
+		__entry->parent_ino = parent_ino;
+	),
+	TP_printk("dev %d:%d dir 0x%llx parent 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir_ino,
+		  __entry->parent_ino)
+)
+#define DEFINE_XREP_DIR_EVENT(name) \
+DEFINE_EVENT(xrep_dir_class, name, \
+	TP_PROTO(struct xfs_inode *dp, xfs_ino_t parent_ino), \
+	TP_ARGS(dp, parent_ino))
+DEFINE_XREP_DIR_EVENT(xrep_dir_rebuild_tree);
+DEFINE_XREP_DIR_EVENT(xrep_dir_reset_fork);
+
+DECLARE_EVENT_CLASS(xrep_dirent_class,
+	TP_PROTO(struct xfs_inode *dp, const struct xfs_name *name,
+		 xfs_ino_t ino),
+	TP_ARGS(dp, name, ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir_ino)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, name->len)
+		__field(xfs_ino_t, ino)
+		__field(uint8_t, ftype)
+	),
+	TP_fast_assign(
+		__entry->dev = dp->i_mount->m_super->s_dev;
+		__entry->dir_ino = dp->i_ino;
+		__entry->namelen = name->len;
+		memcpy(__get_str(name), name->name, name->len);
+		__entry->ino = ino;
+		__entry->ftype = name->type;
+	),
+	TP_printk("dev %d:%d dir 0x%llx ftype %s name '%.*s' ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir_ino,
+		  __print_symbolic(__entry->ftype, XFS_DIR3_FTYPE_STR),
+		  __entry->namelen,
+		  __get_str(name),
+		  __entry->ino)
+)
+#define DEFINE_XREP_DIRENT_EVENT(name) \
+DEFINE_EVENT(xrep_dirent_class, name, \
+	TP_PROTO(struct xfs_inode *dp, const struct xfs_name *name, \
+		 xfs_ino_t ino), \
+	TP_ARGS(dp, name, ino))
+DEFINE_XREP_DIRENT_EVENT(xrep_dir_salvage_entry);
+DEFINE_XREP_DIRENT_EVENT(xrep_dir_stash_createname);
+DEFINE_XREP_DIRENT_EVENT(xrep_dir_replay_createname);
+
+DECLARE_EVENT_CLASS(xrep_parent_salvage_class,
+	TP_PROTO(struct xfs_inode *dp, xfs_ino_t ino),
+	TP_ARGS(dp, ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir_ino)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->dev = dp->i_mount->m_super->s_dev;
+		__entry->dir_ino = dp->i_ino;
+		__entry->ino = ino;
+	),
+	TP_printk("dev %d:%d dir 0x%llx parent 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir_ino,
+		  __entry->ino)
+)
+#define DEFINE_XREP_PARENT_SALVAGE_EVENT(name) \
+DEFINE_EVENT(xrep_parent_salvage_class, name, \
+	TP_PROTO(struct xfs_inode *dp, xfs_ino_t ino), \
+	TP_ARGS(dp, ino))
+DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_dir_salvaged_parent);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 970daeb160b24..0d7dcb128f857 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_dir2.h"
 #include "xfs_attr.h"
+#include "xfs_bit.h"
 #include "xfs_trans_space.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
@@ -1553,6 +1554,51 @@ xfs_release(
 	return error;
 }
 
+/*
+ * Mark all the buffers attached to this directory stale.  In theory we should
+ * never be freeing a directory with any blocks at all, but this covers the
+ * case where we've recovered a directory swap with a "temporary" directory
+ * created by online repair and now need to dump it.
+ */
+STATIC void
+xfs_inactive_dir(
+	struct xfs_inode	*dp)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(dp, XFS_DATA_FORK);
+	xfs_fileoff_t		off;
+
+	/*
+	 * Invalidate each directory block.  All directory blocks are of
+	 * fsbcount length and alignment, so we only need to walk those same
+	 * offsets.  We hold the only reference to this inode, so we must wait
+	 * for the buffer locks.
+	 */
+	for_each_xfs_iext(ifp, &icur, &got) {
+		for (off = round_up(got.br_startoff, geo->fsbcount);
+		     off < got.br_startoff + got.br_blockcount;
+		     off += geo->fsbcount) {
+			struct xfs_buf	*bp = NULL;
+			xfs_fsblock_t	fsbno;
+			int		error;
+
+			fsbno = (off - got.br_startoff) + got.br_startblock;
+			error = xfs_buf_incore(mp->m_ddev_targp,
+					XFS_FSB_TO_DADDR(mp, fsbno),
+					XFS_FSB_TO_BB(mp, geo->fsbcount),
+					XBF_LIVESCAN, &bp);
+			if (error)
+				continue;
+
+			xfs_buf_stale(bp);
+			xfs_buf_relse(bp);
+		}
+	}
+}
+
 /*
  * xfs_inactive_truncate
  *
@@ -1863,6 +1909,11 @@ xfs_inactive(
 			goto out;
 	}
 
+	if (S_ISDIR(VFS_I(ip)->i_mode) && ip->i_df.if_nextents > 0) {
+		xfs_inactive_dir(ip);
+		truncate = 1;
+	}
+
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		error = xfs_inactive_symlink(ip);
 	else if (truncate)


