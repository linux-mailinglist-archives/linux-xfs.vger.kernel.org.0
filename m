Return-Path: <linux-xfs+bounces-6743-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CAB758A5ED9
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Apr 2024 01:52:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1924B21DCF
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Apr 2024 23:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD531591F9;
	Mon, 15 Apr 2024 23:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cuy+SFnj"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A226157A61
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713225121; cv=none; b=edvxPiJ3fvqiWsQTFB80Kbyw9YmWeCiHWS135XcJwGfYRcqJMWVMMZsT21JApLglGusHzWJiOhkr67CUEA8z/uELNYy0hoQDEddQztY+ruNFP8Bm2FWFSYizFetahbhB+qtVoDlT4NIPKNiN+Z0lq7Poa+EX0wx6Iq8b2PhZE4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713225121; c=relaxed/simple;
	bh=ux7KrVpqfnzuBx/lNrNwGb86jX+rgjqNMTz/4pFV3z0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f9wp2YCwD+l3ehDA4/dawbRd5IBQIOlOl9vJCseJE2w3l3QBN55ZkrCHRWuHC7TKbki1DfZegy5RyejCQ7cnrA39jVdJ4jgJk6LHjw1dan5Rn7r567MnX9d999pRtZI6ZiEOtSOlEwhHW15gZwkn4Z+iy6Fmbs1wSpybnwoSevc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cuy+SFnj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A90C113CC;
	Mon, 15 Apr 2024 23:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713225120;
	bh=ux7KrVpqfnzuBx/lNrNwGb86jX+rgjqNMTz/4pFV3z0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cuy+SFnjbZyIR9UlV5nwktEd98KKLUtV3Ij75u6qhmm3Diy3UcR0VT18d3A5yPq68
	 gsrRPbkivdXswZBRR6L0H67jkFTx/CL3AIj94MLsGGDCdoCGne+D0s5yTESRFOsz5f
	 H/yV4zRg05iiBwhrgtaihhaznrnXvP5z6z1N8vBpGA7qkeH2TqwahxFGknv+qLm+NS
	 dka/M933ac36KYsxa8/OS+eFh2R6APpd1Hv8msiBoifsvaX0g0/DsJ+RuuHu4LG7/A
	 bEDtZumDc6BCQStHmDFhPWEmrHwVEuNraK65ZEr5/xyvszTyHUeV8EQGF6g/SCbktQ
	 0b8U5YhuoPe2w==
Date: Mon, 15 Apr 2024 16:52:00 -0700
Subject: [PATCH 2/5] xfs: online repair of directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322383904.89193.13086463854063919202.stgit@frogsfrogsfrogs>
In-Reply-To: <171322383857.89193.15436066970892287907.stgit@frogsfrogsfrogs>
References: <171322383857.89193.15436066970892287907.stgit@frogsfrogsfrogs>
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
the results in bulk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile              |    1 
 fs/xfs/scrub/dir.c           |    9 
 fs/xfs/scrub/dir_repair.c    | 1349 ++++++++++++++++++++++++++++++++++++++++++
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
 fs/xfs/scrub/xfblob.h        |   24 +
 15 files changed, 1563 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/dir_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7dbe6b3befb3..5c9449e14f74 100644
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
index 7bac74621af7..3fe6ffcf9c06 100644
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
index 000000000000..48aa80d8c7dc
--- /dev/null
+++ b/fs/xfs/scrub/dir_repair.c
@@ -0,0 +1,1349 @@
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
+#include "xfs_exchmaps.h"
+#include "xfs_exchrange.h"
+#include "xfs_ag.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/tempfile.h"
+#include "scrub/tempexch.h"
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
+ * entries are replayed to the temporary directory.  An atomic mapping exchange
+ * is used to commit the new directory blocks to the directory being repaired.
+ * This will disrupt readdir cursors.
+ *
+ * Locking Issues
+ * --------------
+ *
+ * If /a, /a/b, and /c are all directories, the VFS does not take i_rwsem on
+ * /a/b for a "mv /a/b /c/" operation.  This means that only b's ILOCK protects
+ * b's dotdot update.  This is in contrast to every other dotdot update (link,
+ * remove, mkdir).  If the repair code drops the ILOCK, it must either
+ * revalidate the dotdot entry or use dirent hooks to capture updates from
+ * other threads.
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
+	/* Information for exchanging data forks at the end. */
+	struct xrep_tempexch	tx;
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
+	struct xfs_name		xname;
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
+	rd->xname.name = rd->namebuf;
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
+	if (!xfs_dir2_namecheck(name, namelen))
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
+	error = xfblob_storename(rd->dir_names, &dirent.name_cookie, name);
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
+	struct xfs_dir2_sf_hdr		*hdr;
+	struct xfs_dir2_sf_entry	*sfep;
+	struct xfs_dir2_sf_entry	*next;
+	struct xfs_ifork		*ifp;
+	xfs_ino_t			ino;
+	unsigned char			*end;
+	int				error = 0;
+
+	ifp = xfs_ifork_ptr(rd->sc->ip, XFS_DATA_FORK);
+	hdr = ifp->if_data;
+	end = (unsigned char *)ifp->if_data + ifp->if_bytes;
+
+	ino = xfs_dir2_sf_get_parent_ino(hdr);
+	trace_xrep_dir_salvaged_parent(rd->sc->ip, ino);
+
+	sfep = xfs_dir2_sf_firstentry(hdr);
+	while ((unsigned char *)sfep < end) {
+		if (xchk_should_terminate(rd->sc, &error))
+			return error;
+
+		next = xfs_dir2_sf_nextentry(rd->sc->mp, hdr, sfep);
+		if ((unsigned char *)next > end)
+			break;
+
+		/* Ok, let's save this entry. */
+		error = xrep_dir_salvage_sf_entry(rd, hdr, sfep);
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
+	const struct xfs_name		*xname,
+	const struct xrep_dirent	*dirent)
+{
+	struct xfs_mount		*mp = rd->sc->mp;
+#ifdef DEBUG
+	xfs_ino_t			ino;
+#endif
+	uint				resblks;
+	int				error;
+
+	resblks = XFS_LINK_SPACE_RES(mp, xname->len);
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
+	error = xchk_dir_lookup(rd->sc, rd->sc->tempip, xname, &ino);
+	if (error != -ENOENT) {
+		ASSERT(error != -ENOENT);
+		goto out_cancel;
+	}
+#endif
+
+	error = xrep_dir_replay_createname(rd, xname, dirent->ino, resblks);
+	if (error)
+		goto out_cancel;
+
+	if (xname->type == XFS_DIR3_FT_DIR)
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
+		error = xfblob_loadname(rd->dir_names, dirent.name_cookie,
+				&rd->xname, dirent.namelen);
+		if (error)
+			return error;
+		rd->xname.type = dirent.ftype;
+
+		error = xrep_dir_replay_update(rd, &rd->xname, &dirent);
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
+	 * directory in preparation for exchanging the directory structures at
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
+	 * exchanging the directories to reduce memory usage.
+	 */
+	error = xrep_dir_find_entries(rd);
+	if (error)
+		return error;
+
+	/*
+	 * Cancel the repair transaction and drop the ILOCK so that we can
+	 * (later) use the atomic mapping exchange functions to compute the
+	 * correct block reservations and re-lock the inodes.
+	 *
+	 * We still hold IOLOCK_EXCL (aka i_rwsem) which will prevent directory
+	 * modifications, but there's nothing to prevent userspace from reading
+	 * the directory until we're ready for the exchange operation.  Reads
+	 * will return -EIO without shutting down the fs, so we're ok with
+	 * that.
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
+ * Prepare both inodes' directory forks for exchanging mappings.  Promote the
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
+	 * If the tempfile's directory is in shortform format, convert that to
+	 * a single leaf extent so that we can use the atomic mapping exchange.
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
+	 * to an empty extent list in preparation for the atomic mapping
+	 * exchange.
+	 */
+	if (ip_local) {
+		struct xfs_ifork	*ifp;
+
+		ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
+		xfs_idestroy_fork(ifp);
+		ifp->if_format = XFS_DINODE_FMT_EXTENTS;
+		ifp->if_nextents = 0;
+		ifp->if_bytes = 0;
+		ifp->if_data = NULL;
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
+/* Exchange the temporary directory's data fork with the one being repaired. */
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
+	/*
+	 * Clean the transaction before we start working on exchanging
+	 * directory contents.
+	 */
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
+	return xrep_tempexch_contents(sc, &rd->tx);
+}
+
+/*
+ * Exchange the new directory contents (which we created in the tempfile) with
+ * the directory being repaired.
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
+	error = xrep_tempexch_trans_alloc(sc, XFS_DATA_FORK, &rd->tx);
+	if (error)
+		return error;
+
+	/*
+	 * Exchange the tempdir's data fork with the file being repaired.  This
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
index c743772a523e..0dde5df2f8d3 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -46,6 +46,7 @@
 #include "scrub/repair.h"
 #include "scrub/iscan.h"
 #include "scrub/readdir.h"
+#include "scrub/tempfile.h"
 
 /*
  * Inode Record Repair
@@ -340,6 +341,10 @@ xrep_dinode_findmode_walk_directory(
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
index 8a7d9557897c..8b9aa73093d6 100644
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
 
 	xnc = container_of(nb, struct xchk_nlink_ctrs, dhook.dirent_hook.nb);
 
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
index 58cacb8e94c1..23eb08c4b5ad 100644
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
index 5da10ed1fe8c..050a8e8914f6 100644
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
index e94080469315..028690761c62 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -333,6 +333,13 @@ xchk_dir_lookup(
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
 	xfs_assert_ilocked(dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 04aec0e9e4c3..369f0430e4ba 100644
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
index 9cbfd8da5620..4e25aa95753a 100644
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
index 547189a14b6b..8e9e2bf121c2 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -325,7 +325,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_directory,
 		.scrub	= xchk_directory,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_directory,
 	},
 	[XFS_SCRUB_TYPE_XATTR] = {	/* extended attributes */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 0b3060be938f..4ca86a6a5be1 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -841,3 +841,16 @@ xrep_tempfile_copyout_local(
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
index d57e4f145a7c..e51399f595fe 100644
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
index ffaff7722bf2..d6d9e8d6109c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2500,6 +2500,118 @@ DEFINE_EVENT(xrep_xattr_class, name, \
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
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */
diff --git a/fs/xfs/scrub/xfblob.h b/fs/xfs/scrub/xfblob.h
index 78a67a06408f..ae78322613ca 100644
--- a/fs/xfs/scrub/xfblob.h
+++ b/fs/xfs/scrub/xfblob.h
@@ -23,4 +23,28 @@ int xfblob_free(struct xfblob *blob, xfblob_cookie cookie);
 unsigned long long xfblob_bytes(struct xfblob *blob);
 void xfblob_truncate(struct xfblob *blob);
 
+static inline int
+xfblob_storename(
+	struct xfblob		*blob,
+	xfblob_cookie		*cookie,
+	const struct xfs_name	*xname)
+{
+	return xfblob_store(blob, cookie, xname->name, xname->len);
+}
+
+static inline int
+xfblob_loadname(
+	struct xfblob		*blob,
+	xfblob_cookie		cookie,
+	struct xfs_name		*xname,
+	uint32_t		size)
+{
+	int ret = xfblob_load(blob, cookie, (void *)xname->name, size);
+	if (ret)
+		return ret;
+
+	xname->len = size;
+	return 0;
+}
+
 #endif /* __XFS_SCRUB_XFBLOB_H__ */


