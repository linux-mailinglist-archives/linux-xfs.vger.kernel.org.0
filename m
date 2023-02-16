Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F5E699EB4
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Feb 2023 22:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjBPVJE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Feb 2023 16:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjBPVJB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:09:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4720553800
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:08:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9B4860A65
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F69DC433EF;
        Thu, 16 Feb 2023 21:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581734;
        bh=GxDTcqMcEpKAuLVUx9V6e96dnIo9tcX12+3HArJlnV0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=btpzlOgWbYwj0pD43bFof9TSUdgqvy+B5RKSSOzdMOqXA9e/6gocnDe5SaUqO2VYZ
         lzjSfLSYGu2n8Yw3EDILse6ILgzm6OsKe4MfWhXCiCrx27sNcWzPkGhBG1T+mGhtX5
         Hg1mtPHVlc3bPA4hWX69B+myfZGfFgAGXH2LKXx3EmuXXryQarUGp8ijsGCAgJATew
         0oRWu+/McbPNCgByg+Vhz4IwGIziwmmKoOVH5Uobqe5oT8pWAcepxEFsY/qaqliCFS
         w9WgD7PKW8WlLQRk+NMPozUKZWLratIX7+vzSlaE3b4GO8KQ0AFgUNqnB5RzPaXFaL
         33XoMLSQ5pnoQ==
Date:   Thu, 16 Feb 2023 13:08:53 -0800
Subject: [PATCH 2/8] xfs_repair: check parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657881991.3477807.18417077389314514199.stgit@magnolia>
In-Reply-To: <167657881963.3477807.5005383731904631094.stgit@magnolia>
References: <167657881963.3477807.5005383731904631094.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the parent pointer index that we constructed in the previous patch
to check that each file's parent pointer records exactly match the
directory entries that we recorded while walking directory entries.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    5 
 libxfs/xfblob.c          |    9 +
 libxfs/xfblob.h          |    2 
 repair/Makefile          |    2 
 repair/listxattr.c       |  283 +++++++++++++++++++++
 repair/listxattr.h       |   15 +
 repair/phase6.c          |    2 
 repair/pptr.c            |  618 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/pptr.h            |    2 
 9 files changed, 938 insertions(+)
 create mode 100644 repair/listxattr.c
 create mode 100644 repair/listxattr.h


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index b8ee0247..92cdb6cc 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -34,7 +34,9 @@
 #define xfs_alloc_vextent		libxfs_alloc_vextent
 
 #define xfs_attr3_leaf_hdr_from_disk	libxfs_attr3_leaf_hdr_from_disk
+#define xfs_attr3_leaf_read		libxfs_attr3_leaf_read
 #define xfs_attr_get			libxfs_attr_get
+#define xfs_attr_is_leaf		libxfs_attr_is_leaf
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
 #define xfs_attr_set			libxfs_attr_set
@@ -63,6 +65,7 @@
 #define xfs_bwrite			libxfs_bwrite
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
 #define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
+#define xfs_da3_node_read		libxfs_da3_node_read
 #define xfs_da_get_buf			libxfs_da_get_buf
 #define xfs_da_hashname			libxfs_da_hashname
 #define xfs_da_read_buf			libxfs_da_read_buf
@@ -130,6 +133,7 @@
 #define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
 #define xfs_inode_from_disk		libxfs_inode_from_disk
 #define xfs_inode_from_disk_ts		libxfs_inode_from_disk_ts
+#define xfs_inode_hasattr		libxfs_inode_hasattr
 #define xfs_inode_to_disk		libxfs_inode_to_disk
 #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
 #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
@@ -142,6 +146,7 @@
 #define xfs_mode_to_ftype		libxfs_mode_to_ftype
 #define xfs_parent_add			libxfs_parent_add
 #define xfs_parent_finish		libxfs_parent_finish
+#define xfs_parent_irec_from_disk	libxfs_parent_irec_from_disk
 #define xfs_parent_start		libxfs_parent_start
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_put			libxfs_perag_put
diff --git a/libxfs/xfblob.c b/libxfs/xfblob.c
index 6c1c8e6f..2c6e69a2 100644
--- a/libxfs/xfblob.c
+++ b/libxfs/xfblob.c
@@ -146,3 +146,12 @@ xfblob_free(
 	xfile_discard(blob->xfile, cookie, sizeof(key) + key.xb_size);
 	return 0;
 }
+
+/* Drop all the blobs. */
+void
+xfblob_truncate(
+	struct xfblob	*blob)
+{
+	xfile_discard(blob->xfile, PAGE_SIZE, blob->last_offset - PAGE_SIZE);
+	blob->last_offset = PAGE_SIZE;
+}
diff --git a/libxfs/xfblob.h b/libxfs/xfblob.h
index d1282810..0d6de8ce 100644
--- a/libxfs/xfblob.h
+++ b/libxfs/xfblob.h
@@ -22,4 +22,6 @@ int xfblob_store(struct xfblob *blob, xfblob_cookie *cookie, const void *ptr,
 		uint32_t size);
 int xfblob_free(struct xfblob *blob, xfblob_cookie cookie);
 
+void xfblob_truncate(struct xfblob *blob);
+
 #endif /* __XFS_SCRUB_XFBLOB_H__ */
diff --git a/repair/Makefile b/repair/Makefile
index 18731613..925864c2 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -23,6 +23,7 @@ HFILES = \
 	err_protos.h \
 	globals.h \
 	incore.h \
+	listxattr.h \
 	pptr.h \
 	prefetch.h \
 	progress.h \
@@ -53,6 +54,7 @@ CFILES = \
 	incore_ext.c \
 	incore_ino.c \
 	init.c \
+	listxattr.c \
 	phase1.c \
 	phase2.c \
 	phase3.c \
diff --git a/repair/listxattr.c b/repair/listxattr.c
new file mode 100644
index 00000000..484f9a00
--- /dev/null
+++ b/repair/listxattr.c
@@ -0,0 +1,283 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs.h"
+#include "libxlog.h"
+#include "libfrog/bitmap.h"
+#include "repair/listxattr.h"
+
+/* Call a function for every entry in a shortform xattr structure. */
+STATIC int
+xattr_walk_sf(
+	struct xfs_inode		*ip,
+	xattr_walk_fn			attr_fn,
+	void				*priv)
+{
+	struct xfs_attr_shortform	*sf;
+	struct xfs_attr_sf_entry	*sfe;
+	unsigned int			i;
+	int				error;
+
+	sf = (struct xfs_attr_shortform *)ip->i_af.if_u1.if_data;
+	for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
+		error = attr_fn(ip, sfe->flags, sfe->nameval, sfe->namelen,
+				&sfe->nameval[sfe->namelen], sfe->valuelen,
+				priv);
+		if (error)
+			return error;
+
+		sfe = xfs_attr_sf_nextentry(sfe);
+	}
+
+	return 0;
+}
+
+/* Call a function for every entry in this xattr leaf block. */
+STATIC int
+xattr_walk_leaf_entries(
+	struct xfs_inode		*ip,
+	xattr_walk_fn			attr_fn,
+	struct xfs_buf			*bp,
+	void				*priv)
+{
+	struct xfs_attr3_icleaf_hdr	ichdr;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_attr_leafblock	*leaf = bp->b_addr;
+	struct xfs_attr_leaf_entry	*entry;
+	unsigned int			i;
+	int				error;
+
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
+	entry = xfs_attr3_leaf_entryp(leaf);
+
+	for (i = 0; i < ichdr.count; entry++, i++) {
+		void			*value;
+		char			*name;
+		unsigned int		namelen, valuelen;
+
+		if (entry->flags & XFS_ATTR_LOCAL) {
+			struct xfs_attr_leaf_name_local		*name_loc;
+
+			name_loc = xfs_attr3_leaf_name_local(leaf, i);
+			name = name_loc->nameval;
+			namelen = name_loc->namelen;
+			value = &name_loc->nameval[name_loc->namelen];
+			valuelen = be16_to_cpu(name_loc->valuelen);
+		} else {
+			struct xfs_attr_leaf_name_remote	*name_rmt;
+
+			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
+			name = name_rmt->name;
+			namelen = name_rmt->namelen;
+			value = NULL;
+			valuelen = be32_to_cpu(name_rmt->valuelen);
+		}
+
+		error = attr_fn(ip, entry->flags, name, namelen, value,
+				valuelen, priv);
+		if (error)
+			return error;
+
+	}
+
+	return 0;
+}
+
+/*
+ * Call a function for every entry in a leaf-format xattr structure.  Avoid
+ * memory allocations for the loop detector since there's only one block.
+ */
+STATIC int
+xattr_walk_leaf(
+	struct xfs_inode		*ip,
+	xattr_walk_fn			attr_fn,
+	void				*priv)
+{
+	struct xfs_buf			*leaf_bp;
+	int				error;
+
+	error = -libxfs_attr3_leaf_read(NULL, ip, 0, &leaf_bp);
+	if (error)
+		return error;
+
+	error = xattr_walk_leaf_entries(ip, attr_fn, leaf_bp, priv);
+	libxfs_trans_brelse(NULL, leaf_bp);
+	return error;
+}
+
+/* Find the leftmost leaf in the xattr dabtree. */
+STATIC int
+xattr_walk_find_leftmost_leaf(
+	struct xfs_inode		*ip,
+	struct bitmap			*seen_blocks,
+	struct xfs_buf			**leaf_bpp)
+{
+	struct xfs_da3_icnode_hdr	nodehdr;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_da_intnode		*node;
+	struct xfs_da_node_entry	*btree;
+	struct xfs_buf			*bp;
+	//xfs_failaddr_t			fa;
+	xfs_dablk_t			blkno = 0;
+	unsigned int			expected_level = 0;
+	int				error;
+
+	for (;;) {
+		uint16_t		magic;
+
+		error = -libxfs_da3_node_read(NULL, ip, blkno, &bp,
+				XFS_ATTR_FORK);
+		if (error)
+			return error;
+
+		node = bp->b_addr;
+		magic = be16_to_cpu(node->hdr.info.magic);
+		if (magic == XFS_ATTR_LEAF_MAGIC ||
+		    magic == XFS_ATTR3_LEAF_MAGIC)
+			break;
+
+		error = EFSCORRUPTED;
+		if (magic != XFS_DA_NODE_MAGIC &&
+		    magic != XFS_DA3_NODE_MAGIC)
+			goto out_buf;
+
+#if 0
+		fa = xfs_da3_node_header_check(bp, ip->i_ino);
+		if (fa)
+			goto out_buf;
+#endif
+
+		libxfs_da3_node_hdr_from_disk(mp, &nodehdr, node);
+
+		if (nodehdr.count == 0 || nodehdr.level >= XFS_DA_NODE_MAXDEPTH)
+			goto out_buf;
+
+		/* Check the level from the root node. */
+		if (blkno == 0)
+			expected_level = nodehdr.level - 1;
+		else if (expected_level != nodehdr.level)
+			goto out_buf;
+		else
+			expected_level--;
+
+		/* Remember that we've seen this node. */
+		error = -bitmap_set(seen_blocks, blkno, 1);
+		if (error)
+			goto out_buf;
+
+		/* Find the next level towards the leaves of the dabtree. */
+		btree = nodehdr.btree;
+		blkno = be32_to_cpu(btree->before);
+		libxfs_trans_brelse(NULL, bp);
+
+		/* Make sure we haven't seen this new block already. */
+		if (bitmap_test(seen_blocks, blkno, 1))
+			return EFSCORRUPTED;
+	}
+
+	error = EFSCORRUPTED;
+#if 0
+	fa = xfs_attr3_leaf_header_check(bp, ip->i_ino);
+	if (fa)
+		goto out_buf;
+#endif
+
+	if (expected_level != 0)
+		goto out_buf;
+
+	/* Remember that we've seen this leaf. */
+	error = -bitmap_set(seen_blocks, blkno, 1);
+	if (error)
+		goto out_buf;
+
+	*leaf_bpp = bp;
+	return 0;
+
+out_buf:
+	libxfs_trans_brelse(NULL, bp);
+	return error;
+}
+
+/* Call a function for every entry in a node-format xattr structure. */
+STATIC int
+xattr_walk_node(
+	struct xfs_inode		*ip,
+	xattr_walk_fn			attr_fn,
+	void				*priv)
+{
+	struct xfs_attr3_icleaf_hdr	leafhdr;
+	struct bitmap			*seen_blocks;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_attr_leafblock	*leaf;
+	struct xfs_buf			*leaf_bp;
+	int				error;
+
+	bitmap_alloc(&seen_blocks);
+
+	error = xattr_walk_find_leftmost_leaf(ip, seen_blocks, &leaf_bp);
+	if (error)
+		goto out_bitmap;
+
+	for (;;) {
+		error = xattr_walk_leaf_entries(ip, attr_fn, leaf_bp,
+				priv);
+		if (error)
+			goto out_leaf;
+
+		/* Find the right sibling of this leaf block. */
+		leaf = leaf_bp->b_addr;
+		libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+		if (leafhdr.forw == 0)
+			goto out_leaf;
+
+		libxfs_trans_brelse(NULL, leaf_bp);
+
+		/* Make sure we haven't seen this new leaf already. */
+		if (bitmap_test(seen_blocks, leafhdr.forw, 1))
+			goto out_bitmap;
+
+		error = -libxfs_attr3_leaf_read(NULL, ip, leafhdr.forw,
+				&leaf_bp);
+		if (error)
+			goto out_bitmap;
+
+		/* Remember that we've seen this new leaf. */
+		error = -bitmap_set(seen_blocks, leafhdr.forw, 1);
+		if (error)
+			goto out_leaf;
+	}
+
+out_leaf:
+	libxfs_trans_brelse(NULL, leaf_bp);
+out_bitmap:
+	bitmap_free(&seen_blocks);
+	return error;
+}
+
+/* Call a function for every extended attribute in a file. */
+int
+xattr_walk(
+	struct xfs_inode	*ip,
+	xattr_walk_fn		attr_fn,
+	void			*priv)
+{
+	int			error;
+
+	if (!libxfs_inode_hasattr(ip))
+		return 0;
+
+	if (ip->i_af.if_format == XFS_DINODE_FMT_LOCAL)
+		return xattr_walk_sf(ip, attr_fn, priv);
+
+	/* attr functions require that the attr fork is loaded */
+	error = -libxfs_iread_extents(NULL, ip, XFS_ATTR_FORK);
+	if (error)
+		return error;
+
+	if (libxfs_attr_is_leaf(ip))
+		return xattr_walk_leaf(ip, attr_fn, priv);
+
+	return xattr_walk_node(ip, attr_fn, priv);
+}
diff --git a/repair/listxattr.h b/repair/listxattr.h
new file mode 100644
index 00000000..cd18fdd2
--- /dev/null
+++ b/repair/listxattr.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __REPAIR_LISTXATTR_H__
+#define __REPAIR_LISTXATTR_H__
+
+typedef int (*xattr_walk_fn)(struct xfs_inode *ip, unsigned int attr_flags,
+		const unsigned char *name, unsigned int namelen,
+		const void *value, unsigned int valuelen, void *priv);
+
+int xattr_walk(struct xfs_inode *ip, xattr_walk_fn attr_fn, void *priv);
+
+#endif /* __REPAIR_LISTXATTR_H__ */
diff --git a/repair/phase6.c b/repair/phase6.c
index 48ec236d..1994162a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3344,5 +3344,7 @@ _("        - resetting contents of realtime bitmap and summary inodes\n"));
 		}
 	}
 
+	/* Check and repair directory parent pointers, if enabled. */
+	check_parent_ptrs(mp);
 	parent_ptr_free(mp);
 }
diff --git a/repair/pptr.c b/repair/pptr.c
index b10c7f41..d1e7f5ee 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -6,8 +6,13 @@
 #include "libxfs.h"
 #include "libxfs/xfile.h"
 #include "libxfs/xfblob.h"
+#include "libfrog/workqueue.h"
+#include "repair/globals.h"
 #include "repair/err_protos.h"
 #include "repair/slab.h"
+#include "repair/listxattr.h"
+#include "repair/threads.h"
+#include "repair/incore.h"
 #include "repair/pptr.h"
 
 #undef PPTR_DEBUG
@@ -126,6 +131,21 @@ struct ag_pptr {
 	xfs_agino_t		child_agino;
 };
 
+struct file_pptr {
+	/* parent directory handle */
+	xfs_ino_t		parent_ino;
+	unsigned int		parent_gen;
+
+	/* dirent offset */
+	xfs_dir2_dataptr_t	diroffset;
+
+	/* parent pointer name length */
+	unsigned int		namelen;
+
+	/* cookie for the file dirent name */
+	xfblob_cookie		name_cookie;
+};
+
 struct ag_pptrs {
 	/* Lock to protect pptr_recs during the dirent scan. */
 	pthread_mutex_t		lock;
@@ -134,11 +154,80 @@ struct ag_pptrs {
 	struct xfs_slab		*pptr_recs;
 };
 
+struct file_scan {
+	struct ag_pptrs		*ag_pptrs;
+
+	/* cursor for comparing ag_pptrs.pptr_recs against file_pptrs_recs */
+	struct xfs_slab_cursor	*ag_pptr_recs_cur;
+
+	/* xfs_parent_name_rec records for a file that we're checking */
+	struct xfs_slab		*file_pptr_recs;
+
+	/* cursor for comparing file_pptr_recs against pptrs_recs */
+	struct xfs_slab_cursor	*file_pptr_recs_cur;
+
+	/* names associated with file_pptr_recs */
+	struct xfblob		*file_pptr_names;
+
+	/* Number of parent pointers recorded for this file. */
+	unsigned int		nr_file_pptrs;
+
+	/* Does this file have garbage xattrs with ATTR_PARENT set? */
+	bool			have_garbage;
+};
+
 /* Global names storage file. */
 static struct xfblob	*names;
 static pthread_mutex_t	names_mutex = PTHREAD_MUTEX_INITIALIZER;
 static struct ag_pptrs	*fs_pptrs;
 
+static int
+cmp_ag_pptr(
+	const void		*a,
+	const void		*b)
+{
+	const struct ag_pptr	*pa = a;
+	const struct ag_pptr	*pb = b;
+
+	if (pa->child_agino < pb->child_agino)
+		return -1;
+	if (pa->child_agino > pb->child_agino)
+		return 1;
+
+	if (pa->parent_ino < pb->parent_ino)
+		return -1;
+	if (pa->parent_ino > pb->parent_ino)
+		return 1;
+
+	if (pa->diroffset < pb->diroffset)
+		return -1;
+	if (pa->diroffset > pb->diroffset)
+		return 1;
+
+	return 0;
+}
+
+static int
+cmp_file_pptr(
+	const void		*a,
+	const void		*b)
+{
+	const struct file_pptr	*pa = a;
+	const struct file_pptr	*pb = b;
+
+	if (pa->parent_ino < pb->parent_ino)
+		return -1;
+	if (pa->parent_ino > pb->parent_ino)
+		return 1;
+
+	if (pa->diroffset < pb->diroffset)
+		return -1;
+	if (pa->diroffset > pb->diroffset)
+		return 1;
+
+	return 0;
+}
+
 void
 parent_ptr_free(
 	struct xfs_mount	*mp)
@@ -240,3 +329,532 @@ add_parent_ptr(
 			diroffset, (unsigned long long)ino,
 			(unsigned long long)ag_pptr.name_cookie);
 }
+
+/* Schedule this extended attribute for deletion. */
+static void
+record_garbage_xattr(
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan,
+	unsigned int		attr_filter,
+	const void		*name,
+	unsigned int		namelen)
+{
+	if (no_modify) {
+		if (!fscan->have_garbage)
+			do_warn(
+ _("would delete garbage parent pointer extended attributes in ino %llu\n"),
+					(unsigned long long)ip->i_ino);
+		fscan->have_garbage = true;
+		return;
+	}
+
+	if (fscan->have_garbage)
+		return;
+	fscan->have_garbage = true;
+
+	do_warn(
+ _("deleting garbage parent pointer extended attributes in ino %llu\n"),
+			(unsigned long long)ip->i_ino);
+	/* XXX do the work */
+}
+
+/* Decide if this is a directory parent pointer and stash it if so. */
+static int
+examine_xattr(
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct file_pptr	file_pptr = { };
+	struct xfs_parent_name_irec irec;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct file_scan	*fscan = priv;
+	const struct xfs_parent_name_rec *rec = (const void *)name;
+	int			error;
+
+	/* Ignore anything that isn't a parent pointer. */
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return 0;
+
+	/* No incomplete parent pointers. */
+	if (attr_flags & XFS_ATTR_INCOMPLETE)
+		goto corrupt;
+
+	/* Does the ondisk parent pointer structure make sense? */
+	if (!xfs_parent_namecheck(mp, rec, namelen, attr_flags) ||
+	    !xfs_parent_valuecheck(mp, value, valuelen))
+		goto corrupt;
+
+	libxfs_parent_irec_from_disk(&irec, rec, value, valuelen);
+
+	file_pptr.parent_ino = irec.p_ino;
+	file_pptr.parent_gen = irec.p_gen;
+	file_pptr.diroffset = irec.p_diroffset;
+	file_pptr.namelen = irec.p_namelen;
+
+	error = -xfblob_store(fscan->file_pptr_names,
+			&file_pptr.name_cookie, irec.p_name, irec.p_namelen);
+	if (error)
+		do_error(
+ _("storing ino %llu parent pointer '%.*s' failed: %s\n"),
+				(unsigned long long)ip->i_ino, irec.p_namelen,
+				(const char *)irec.p_name, strerror(error));
+
+	error = -slab_add(fscan->file_pptr_recs, &file_pptr);
+	if (error)
+		do_error(_("storing ino %llu parent pointer rec failed: %s\n"),
+				(unsigned long long)ip->i_ino, strerror(error));
+
+	dbg_printf(
+ _("%s: dp %llu fname '%.*s' namelen %u diroffset %u ino %llu cookie 0x%llx\n"),
+			__func__, (unsigned long long)irec.p_ino,
+			irec.p_namelen, (const char *)irec.p_name,
+			irec.p_namelen, irec.p_diroffset,
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)file_pptr.name_cookie);
+	fscan->nr_file_pptrs++;
+	return 0;
+corrupt:
+	record_garbage_xattr(ip, fscan, attr_flags, name, namelen);
+	return 0;
+}
+
+/* Remove all pptrs from @ip. */
+static void
+clear_all_pptrs(
+	struct xfs_inode	*ip)
+{
+	if (no_modify) {
+		do_warn(_("would delete unlinked ino %llu parent pointers\n"),
+				(unsigned long long)ip->i_ino);
+		return;
+	}
+
+	do_warn(_("deleting unlinked ino %llu parent pointers\n"),
+			(unsigned long long)ip->i_ino);
+	/* XXX actually do the work */
+}
+
+/* Add @ag_pptr to @ip. */
+static void
+add_missing_parent_ptr(
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan,
+	const struct ag_pptr	*ag_pptr)
+{
+	unsigned char		name[MAXNAMELEN];
+	int			error;
+
+	error = -xfblob_load(names, ag_pptr->name_cookie, name,
+			ag_pptr->namelen);
+	if (error)
+		do_error(
+ _("loading missing name for ino %llu parent pointer (ino %llu gen 0x%x diroffset %u namecookie 0x%llx) failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)ag_pptr->parent_ino,
+				ag_pptr->parent_gen, ag_pptr->diroffset,
+				(unsigned long long)ag_pptr->name_cookie,
+				strerror(error));
+
+	if (no_modify) {
+		do_warn(
+ _("would add missing ino %llu parent pointer (ino %llu gen 0x%x diroffset %u name '%.*s')\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)ag_pptr->parent_ino,
+				ag_pptr->parent_gen, ag_pptr->diroffset,
+				ag_pptr->namelen, name);
+		return;
+	}
+
+	do_warn(
+ _("adding missing ino %llu parent pointer (ino %llu gen 0x%x diroffset %u name '%.*s')\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)ag_pptr->parent_ino,
+			ag_pptr->parent_gen, ag_pptr->diroffset,
+			ag_pptr->namelen, name);
+
+	/* XXX actually do the work */
+}
+
+/* Remove @file_pptr from @ip. */
+static void
+remove_incorrect_parent_ptr(
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan,
+	const struct file_pptr	*file_pptr)
+{
+	unsigned char		name[MAXNAMELEN] = { };
+	int			error;
+
+	error = -xfblob_load(fscan->file_pptr_names, file_pptr->name_cookie,
+			name, file_pptr->namelen);
+	if (error)
+		do_error(
+ _("loading incorrect name for ino %llu parent pointer (ino %llu gen 0x%x diroffset %u namecookie 0x%llx) failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen, file_pptr->diroffset,
+				(unsigned long long)file_pptr->name_cookie,
+				strerror(error));
+
+	if (no_modify) {
+		do_warn(
+ _("would remove bad ino %llu parent pointer (ino %llu gen 0x%x diroffset %u name '%.*s')\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen, file_pptr->diroffset,
+				file_pptr->namelen, name);
+		return;
+	}
+
+	do_warn(
+ _("removing bad ino %llu parent pointer (ino %llu gen 0x%x diroffset %u name '%.*s')\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)file_pptr->parent_ino,
+			file_pptr->parent_gen, file_pptr->diroffset,
+			file_pptr->namelen, name);
+
+	/* XXX actually do the work */
+}
+
+/*
+ * We found parent pointers that point to the same inode and directory offset.
+ * Make sure they have the same generation number and dirent name.
+ */
+static void
+compare_parent_pointers(
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan,
+	const struct ag_pptr	*ag_pptr,
+	const struct file_pptr	*file_pptr)
+{
+	unsigned char		name1[MAXNAMELEN] = { };
+	unsigned char		name2[MAXNAMELEN] = { };
+	int			error;
+
+	error = -xfblob_load(names, ag_pptr->name_cookie, name1,
+			ag_pptr->namelen);
+	if (error)
+		do_error(
+ _("loading master-list name for ino %llu parent pointer (ino %llu gen 0x%x diroffset %u namecookie 0x%llx namelen %u) failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)ag_pptr->parent_ino,
+				ag_pptr->parent_gen, ag_pptr->diroffset,
+				(unsigned long long)ag_pptr->name_cookie,
+				ag_pptr->namelen, strerror(error));
+
+	error = -xfblob_load(fscan->file_pptr_names, file_pptr->name_cookie,
+			name2, file_pptr->namelen);
+	if (error)
+		do_error(
+ _("loading file-list name for ino %llu parent pointer (ino %llu gen 0x%x diroffset %u namecookie 0x%llx namelen %u) failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen, file_pptr->diroffset,
+				(unsigned long long)file_pptr->name_cookie,
+				ag_pptr->namelen, strerror(error));
+
+	if (ag_pptr->parent_gen != file_pptr->parent_gen)
+		goto reset;
+	if (ag_pptr->namelen != file_pptr->namelen)
+		goto reset;
+	if (memcmp(name1, name2, ag_pptr->namelen))
+		goto reset;
+
+	return;
+
+reset:
+	if (no_modify) {
+		do_warn(
+ _("would update ino %llu parent pointer (ino %llu gen 0x%x diroffset %u name '%.*s')\n"),
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)ag_pptr->parent_ino,
+				ag_pptr->parent_gen, ag_pptr->diroffset,
+				ag_pptr->namelen, name1);
+		return;
+	}
+
+	do_warn(
+ _("updating ino %llu parent pointer (ino %llu gen 0x%x diroffset %u name '%.*s')\n"),
+			(unsigned long long)ip->i_ino,
+			(unsigned long long)ag_pptr->parent_ino,
+			ag_pptr->parent_gen, ag_pptr->diroffset,
+			ag_pptr->namelen, name1);
+
+	/* XXX do the work */
+}
+
+/*
+ * Make sure that the parent pointers we observed match the ones ondisk.
+ *
+ * Earlier, we generated a master list of parent pointers for files in this AG
+ * based on what we saw during the directory walk at the start of phase 6.
+ * Now that we've read in all of this file's parent pointers, make sure the
+ * lists match.
+ */
+static void
+crosscheck_file_parent_ptrs(
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan)
+{
+	struct ag_pptr		*ag_pptr;
+	struct file_pptr	*file_pptr;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	int			error;
+
+	ag_pptr = peek_slab_cursor(fscan->ag_pptr_recs_cur);
+
+	if (!ag_pptr || ag_pptr->child_agino > agino) {
+		/*
+		 * The cursor for the master pptr list has gone beyond this
+		 * file that we're scanning.  Evidently it has no parents at
+		 * all, so we better not have found any pptrs attached to the
+		 * file.
+		 */
+		if (fscan->nr_file_pptrs > 0)
+			clear_all_pptrs(ip);
+
+		return;
+	}
+
+	if (ag_pptr->child_agino < agino) {
+		/*
+		 * The cursor for the master pptr list is behind the file that
+		 * we're scanning.  This suggests that the incore inode tree
+		 * doesn't know about a file that is mentioned by a dirent.
+		 * At this point the inode liveness is supposed to be settled,
+		 * which means our incore information is inconsistent.
+		 */
+		do_error(
+ _("found dirent referring to ino %llu even though inobt scan moved on to ino %llu?!\n"),
+				(unsigned long long)XFS_AGINO_TO_INO(mp,
+					XFS_INO_TO_AGNO(mp, ip->i_ino),
+					ag_pptr->child_agino),
+				(unsigned long long)ip->i_ino);
+		/* does not return */
+	}
+
+	/*
+	 * The master pptr list cursor is pointing to the inode that we want
+	 * to check.  Sort the pptr records that we recorded from the ondisk
+	 * pptrs for this file, then set up for the comparison.
+	 */
+	qsort_slab(fscan->file_pptr_recs, cmp_file_pptr);
+
+	error = -init_slab_cursor(fscan->file_pptr_recs, cmp_file_pptr,
+			&fscan->file_pptr_recs_cur);
+	if (error)
+		do_error(_("init ino %llu parent pointer cursor failed: %s\n"),
+				(unsigned long long)ip->i_ino, strerror(error));
+
+	do {
+		file_pptr = peek_slab_cursor(fscan->file_pptr_recs_cur);
+
+		dbg_printf(
+ _("%s: dp %llu dp_gen 0x%x namelen %u diroffset %u ino %llu namecookie 0x%llx (master)\n"),
+				__func__,
+				(unsigned long long)ag_pptr->parent_ino,
+				ag_pptr->parent_gen,
+				ag_pptr->namelen,
+				ag_pptr->diroffset,
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)ag_pptr->name_cookie);
+
+		if (file_pptr) {
+			dbg_printf(
+ _("%s: dp %llu dp_gen 0x%x namelen %u diroffset %u ino %llu namecookie 0x%llx (file)\n"),
+					__func__,
+					(unsigned long long)file_pptr->parent_ino,
+					file_pptr->parent_gen,
+					file_pptr->namelen,
+					file_pptr->diroffset,
+					(unsigned long long)ip->i_ino,
+					(unsigned long long)file_pptr->name_cookie);
+		} else {
+			dbg_printf(
+ _("%s: ran out of parent pointers for ino %llu (file)\n"),
+					__func__,
+					(unsigned long long)ip->i_ino);
+		}
+
+		if (!file_pptr ||
+		    file_pptr->parent_ino > ag_pptr->parent_ino ||
+		    file_pptr->diroffset > ag_pptr->diroffset) {
+			/*
+			 * The master pptr list knows about pptrs that are not
+			 * in the ondisk metadata.  Add the missing pptr and
+			 * advance only the master pptr cursor.
+			 */
+			add_missing_parent_ptr(ip, fscan, ag_pptr);
+			advance_slab_cursor(fscan->ag_pptr_recs_cur);
+		} else if (file_pptr->parent_ino < ag_pptr->parent_ino ||
+			   file_pptr->diroffset < ag_pptr->diroffset) {
+			/*
+			 * The ondisk pptrs mention a link that is not in the
+			 * master list.  Delete the extra pptr and advance only
+			 * the file pptr cursor.
+			 */
+			remove_incorrect_parent_ptr(ip, fscan, file_pptr);
+			advance_slab_cursor(fscan->file_pptr_recs_cur);
+		} else {
+			/*
+			 * Exact match, make sure the parent_gen and dirent
+			 * name parts of the parent pointer match.  Move both
+			 * cursors forward.
+			 */
+			compare_parent_pointers(ip, fscan, ag_pptr, file_pptr);
+			advance_slab_cursor(fscan->ag_pptr_recs_cur);
+			advance_slab_cursor(fscan->file_pptr_recs_cur);
+		}
+
+		ag_pptr = peek_slab_cursor(fscan->ag_pptr_recs_cur);
+	} while (ag_pptr && ag_pptr->child_agino == agino);
+
+	while ((file_pptr = pop_slab_cursor(fscan->file_pptr_recs_cur))) {
+		dbg_printf(
+ _("%s: dp %llu dp_gen 0x%x namelen %u diroffset %u ino %llu namecookie 0x%llx (excess)\n"),
+				__func__,
+				(unsigned long long)file_pptr->parent_ino,
+				file_pptr->parent_gen,
+				file_pptr->namelen,
+				file_pptr->diroffset,
+				(unsigned long long)ip->i_ino,
+				(unsigned long long)file_pptr->name_cookie);
+
+		/*
+		 * The master pptr list does not have any more pptrs for this
+		 * file, but we still have unprocessed ondisk pptrs.  Delete
+		 * all these ondisk pptrs.
+		 */
+		remove_incorrect_parent_ptr(ip, fscan, file_pptr);
+	}
+}
+
+/* Ensure this file's parent pointers match what we found in the dirent scan. */
+static void
+check_file_parent_ptrs(
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan)
+{
+	int			error;
+
+	error = -init_slab(&fscan->file_pptr_recs, sizeof(struct file_pptr));
+	if (error)
+		do_error(_("init file parent pointer recs failed: %s\n"),
+				strerror(error));
+
+	fscan->have_garbage = false;
+	fscan->nr_file_pptrs = 0;
+
+	error = xattr_walk(ip, examine_xattr, fscan);
+	if (error && !no_modify)
+		do_error(_("ino %llu parent pointer scan failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
+	if (error) {
+		do_warn(_("ino %llu parent pointer scan failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
+		goto out_free;
+	}
+
+	crosscheck_file_parent_ptrs(ip, fscan);
+
+out_free:
+	free_slab(&fscan->file_pptr_recs);
+	xfblob_truncate(fscan->file_pptr_names);
+}
+
+/* Check all the parent pointers of files in this AG. */
+static void
+check_ag_parent_ptrs(
+	struct workqueue	*wq,
+	uint32_t		agno,
+	void			*arg)
+{
+	struct xfs_mount	*mp = wq->wq_ctx;
+	struct file_scan	fscan = {
+		.ag_pptrs	= &fs_pptrs[agno],
+	};
+	struct ag_pptrs		*ag_pptrs = &fs_pptrs[agno];
+	struct ino_tree_node	*irec;
+	int			error;
+
+	qsort_slab(ag_pptrs->pptr_recs, cmp_ag_pptr);
+
+	error = -init_slab_cursor(ag_pptrs->pptr_recs, cmp_ag_pptr,
+			&fscan.ag_pptr_recs_cur);
+	if (error)
+		do_error(
+ _("init agno %u parent pointer slab cursor failed: %s\n"),
+				agno, strerror(error));
+
+	error = -xfblob_create(mp, "file parent pointer names",
+			&fscan.file_pptr_names);
+	if (error)
+		do_error(
+ _("init agno %u file parent pointer names failed: %s\n"),
+				agno, strerror(error));
+
+	for (irec = findfirst_inode_rec(agno);
+	     irec != NULL;
+	     irec = next_ino_rec(irec)) {
+		unsigned int	ino_offset;
+
+		for (ino_offset = 0;
+		     ino_offset < XFS_INODES_PER_CHUNK;
+		     ino_offset++) {
+			struct xfs_inode *ip;
+			xfs_ino_t	ino;
+
+			if (is_inode_free(irec, ino_offset))
+				continue;
+
+			ino = XFS_AGINO_TO_INO(mp, agno,
+					irec->ino_startnum + ino_offset);
+			error = -libxfs_iget(mp, NULL, ino, 0, &ip);
+			if (error && !no_modify)
+				do_error(
+ _("loading ino %llu for parent pointer check failed: %s\n"),
+						(unsigned long long)ino,
+						strerror(error));
+			if (error) {
+				do_warn(
+ _("loading ino %llu for parent pointer check failed: %s\n"),
+						(unsigned long long)ino,
+						strerror(error));
+				continue;
+			}
+
+			check_file_parent_ptrs(ip, &fscan);
+			libxfs_irele(ip);
+		}
+	}
+
+	xfblob_destroy(fscan.file_pptr_names);
+	free_slab_cursor(&fscan.ag_pptr_recs_cur);
+}
+
+/* Check all the parent pointers of all files in this filesystem. */
+void
+check_parent_ptrs(
+	struct xfs_mount	*mp)
+{
+	struct workqueue	wq;
+	xfs_agnumber_t		agno;
+
+	if (!xfs_has_parent(mp))
+		return;
+
+	create_work_queue(&wq, mp, ag_stride);
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
+		queue_work(&wq, check_ag_parent_ptrs, agno, NULL);
+
+	destroy_work_queue(&wq);
+}
diff --git a/repair/pptr.h b/repair/pptr.h
index 2c632ec9..d72c1ac2 100644
--- a/repair/pptr.h
+++ b/repair/pptr.h
@@ -12,4 +12,6 @@ void parent_ptr_init(struct xfs_mount *mp);
 void add_parent_ptr(xfs_ino_t ino, const unsigned char *fname,
 		xfs_dir2_dataptr_t diroffset, struct xfs_inode *dp);
 
+void check_parent_ptrs(struct xfs_mount *mp);
+
 #endif /* __REPAIR_PPTR_H__ */

