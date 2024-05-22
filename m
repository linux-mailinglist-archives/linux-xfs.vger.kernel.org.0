Return-Path: <linux-xfs+bounces-8618-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 545B38CB9BC
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 05:23:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D882D1F22611
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 03:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C29BE6F067;
	Wed, 22 May 2024 03:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YGxT6CDk"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DAE6BFD5
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716348177; cv=none; b=D2Vw9hTPmRdOOwhpo4qXqe40QZSulTeP/L215zAJ9/tDlzo56UTIliJy4z9xwKETrEod0pcTf6bLvIVswXM0TaMz5N1X0EUAkC4E3HoMUNWpYx1bQH0IEIypaOzdP1fD+8BdFEKe8TXFpKdScgnS65SmtTq/hMY3/n39er9wCz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716348177; c=relaxed/simple;
	bh=qIEhCebvn6CmksSbvvIP5s560205PBkvCL17gRL8WOo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UcpFX9OG2EOflxRcb9v2PUJlqmIcwgtybiK79cw3lbpDhKZGT5B1MtoW5QKrTXTCPlt/aUXelvNg8ExJN75SFJ0OdVuOAfYpyhtsrkjnC0/qFKRYLmrRtrVy2Mus1EzPZhU770Tphe0/Msnf6ioyVuv/wVoOpk/nPyBNTS+EixM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YGxT6CDk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFCCC2BD11;
	Wed, 22 May 2024 03:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716348177;
	bh=qIEhCebvn6CmksSbvvIP5s560205PBkvCL17gRL8WOo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YGxT6CDkn5CZGIofmrmnq6/SVVOQIN0xd0iF7W9ZYrPPx0ulJu99URlZBNlc2td8H
	 jzz0g83d//TfHCOnaBgMkmXeFp4hH3gWEtx+3+BMDSCHrvUw5sdaQwoIlFV4tR9MnY
	 ELVNWTFr9wICCmBWMN1qDRtgFVJLDKM3zZLYMBrRYlVu9KL/0tLiXQrO9C7U2gG6OO
	 NOWlF+aTTL3sifLcCdXSVct1w4QFzgnpo9yQTAiiRvIG+tOuCCLVO79UMcdesdZUJo
	 TYR7vg9sHze6bwyFf6i7QBRsCsNlZ/D3pjj3xFErAoxceUZ9QpbaQpNcAZhp7g6RHX
	 aezoAvaiV6iyQ==
Date: Tue, 21 May 2024 20:22:56 -0700
Subject: [PATCH 1/4] xfs_repair: define an in-memory btree for storing
 refcount bag info
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634535819.2483533.8075586577607267788.stgit@frogsfrogsfrogs>
In-Reply-To: <171634535800.2483533.14373829251885822374.stgit@frogsfrogsfrogs>
References: <171634535800.2483533.14373829251885822374.stgit@frogsfrogsfrogs>
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

Create a new in-memory btree type so that we can store refcount bag info
in a much more memory-efficient format.  Note that the xfs_repair rcbag
btree stores inode numbers (unlike the kernel rcbag btree) because
xfs_repair needs to compute the bitmap of inodes that must have the
reflink iflag set.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_api_defs.h |    4 +
 repair/Makefile          |    2 
 repair/rcbag_btree.c     |  331 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/rcbag_btree.h     |   70 ++++++++++
 4 files changed, 407 insertions(+)
 create mode 100644 repair/rcbag_btree.c
 create mode 100644 repair/rcbag_btree.h


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 209c7a189..cd2e6a8fb 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -63,6 +63,7 @@
 
 #define xfs_btree_bload			libxfs_btree_bload
 #define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
+#define xfs_btree_calc_size		libxfs_btree_calc_size
 #define xfs_btree_decrement		libxfs_btree_decrement
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
 #define xfs_btree_get_block		libxfs_btree_get_block
@@ -70,8 +71,11 @@
 #define xfs_btree_has_more_records	libxfs_btree_has_more_records
 #define xfs_btree_increment		libxfs_btree_increment
 #define xfs_btree_init_block		libxfs_btree_init_block
+#define xfs_btree_mem_head_nlevels	libxfs_btree_mem_head_nlevels
 #define xfs_btree_mem_head_read_buf	libxfs_btree_mem_head_read_buf
+#define xfs_btree_memblock_verify	libxfs_btree_memblock_verify
 #define xfs_btree_rec_addr		libxfs_btree_rec_addr
+#define xfs_btree_space_to_height	libxfs_btree_space_to_height
 #define xfs_btree_stage_afakeroot	libxfs_btree_stage_afakeroot
 #define xfs_btree_stage_ifakeroot	libxfs_btree_stage_ifakeroot
 #define xfs_btree_visit_blocks		libxfs_btree_visit_blocks
diff --git a/repair/Makefile b/repair/Makefile
index e5014deb0..5ea8d9618 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -28,6 +28,7 @@ HFILES = \
 	progress.h \
 	protos.h \
 	quotacheck.h \
+	rcbag_btree.h \
 	rmap.h \
 	rt.h \
 	scan.h \
@@ -64,6 +65,7 @@ CFILES = \
 	prefetch.c \
 	progress.c \
 	quotacheck.c \
+	rcbag_btree.c \
 	rmap.c \
 	rt.c \
 	sb.c \
diff --git a/repair/rcbag_btree.c b/repair/rcbag_btree.c
new file mode 100644
index 000000000..11d69f997
--- /dev/null
+++ b/repair/rcbag_btree.c
@@ -0,0 +1,331 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs.h"
+#include "btree.h"
+#include "err_protos.h"
+#include "libxlog.h"
+#include "incore.h"
+#include "globals.h"
+#include "dinode.h"
+#include "slab.h"
+#include "libfrog/bitmap.h"
+#include "rcbag_btree.h"
+
+static struct kmem_cache	*rcbagbt_cur_cache;
+
+STATIC void
+rcbagbt_init_key_from_rec(
+	union xfs_btree_key		*key,
+	const union xfs_btree_rec	*rec)
+{
+	struct rcbag_key	*bag_key = (struct rcbag_key *)key;
+	const struct rcbag_rec	*bag_rec = (const struct rcbag_rec *)rec;
+
+	BUILD_BUG_ON(sizeof(struct rcbag_key) > sizeof(union xfs_btree_key));
+	BUILD_BUG_ON(sizeof(struct rcbag_rec) > sizeof(union xfs_btree_rec));
+
+	bag_key->rbg_startblock = bag_rec->rbg_startblock;
+	bag_key->rbg_blockcount = bag_rec->rbg_blockcount;
+	bag_key->rbg_ino = bag_rec->rbg_ino;
+}
+
+STATIC void
+rcbagbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	struct rcbag_rec	*bag_rec = (struct rcbag_rec *)rec;
+	struct rcbag_rec	*bag_irec = (struct rcbag_rec *)&cur->bc_rec;
+
+	bag_rec->rbg_startblock = bag_irec->rbg_startblock;
+	bag_rec->rbg_blockcount = bag_irec->rbg_blockcount;
+	bag_rec->rbg_ino = bag_irec->rbg_ino;
+	bag_rec->rbg_refcount = bag_irec->rbg_refcount;
+}
+
+STATIC int64_t
+rcbagbt_key_diff(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key)
+{
+	struct rcbag_rec		*rec = (struct rcbag_rec *)&cur->bc_rec;
+	const struct rcbag_key		*kp = (const struct rcbag_key *)key;
+
+	if (kp->rbg_startblock > rec->rbg_startblock)
+		return 1;
+	if (kp->rbg_startblock < rec->rbg_startblock)
+		return -1;
+
+	if (kp->rbg_blockcount > rec->rbg_blockcount)
+		return 1;
+	if (kp->rbg_blockcount < rec->rbg_blockcount)
+		return -1;
+
+	if (kp->rbg_ino > rec->rbg_ino)
+		return 1;
+	if (kp->rbg_ino < rec->rbg_ino)
+		return -1;
+
+	return 0;
+}
+
+STATIC int64_t
+rcbagbt_diff_two_keys(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2,
+	const union xfs_btree_key	*mask)
+{
+	const struct rcbag_key		*kp1 = (const struct rcbag_key *)k1;
+	const struct rcbag_key		*kp2 = (const struct rcbag_key *)k2;
+
+	ASSERT(mask == NULL);
+
+	if (kp1->rbg_startblock > kp2->rbg_startblock)
+		return 1;
+	if (kp1->rbg_startblock < kp2->rbg_startblock)
+		return -1;
+
+	if (kp1->rbg_blockcount > kp2->rbg_blockcount)
+		return 1;
+	if (kp1->rbg_blockcount < kp2->rbg_blockcount)
+		return -1;
+
+	if (kp1->rbg_ino > kp2->rbg_ino)
+		return 1;
+	if (kp1->rbg_ino < kp2->rbg_ino)
+		return -1;
+
+	return 0;
+}
+
+STATIC int
+rcbagbt_keys_inorder(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*k1,
+	const union xfs_btree_key	*k2)
+{
+	const struct rcbag_key		*kp1 = (const struct rcbag_key *)k1;
+	const struct rcbag_key		*kp2 = (const struct rcbag_key *)k2;
+
+	if (kp1->rbg_startblock > kp2->rbg_startblock)
+		return 0;
+	if (kp1->rbg_startblock < kp2->rbg_startblock)
+		return 1;
+
+	if (kp1->rbg_blockcount > kp2->rbg_blockcount)
+		return 0;
+	if (kp1->rbg_blockcount < kp2->rbg_blockcount)
+		return 1;
+
+	if (kp1->rbg_ino > kp2->rbg_ino)
+		return 0;
+	if (kp1->rbg_ino < kp2->rbg_ino)
+		return 1;
+
+	return 0;
+}
+
+STATIC int
+rcbagbt_recs_inorder(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*r1,
+	const union xfs_btree_rec	*r2)
+{
+	const struct rcbag_rec		*rp1 = (const struct rcbag_rec *)r1;
+	const struct rcbag_rec		*rp2 = (const struct rcbag_rec *)r2;
+
+	if (rp1->rbg_startblock > rp2->rbg_startblock)
+		return 0;
+	if (rp1->rbg_startblock < rp2->rbg_startblock)
+		return 1;
+
+	if (rp1->rbg_blockcount > rp2->rbg_blockcount)
+		return 0;
+	if (rp1->rbg_blockcount < rp2->rbg_blockcount)
+		return 1;
+
+	if (rp1->rbg_ino > rp2->rbg_ino)
+		return 0;
+	if (rp1->rbg_ino < rp2->rbg_ino)
+		return 1;
+
+	return 0;
+}
+
+static xfs_failaddr_t
+rcbagbt_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_failaddr_t		fa;
+	unsigned int		level;
+	unsigned int		maxrecs;
+
+	if (!xfs_verify_magic(bp, block->bb_magic))
+		return __this_address;
+
+	fa = xfs_btree_fsblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+	if (fa)
+		return fa;
+
+	level = be16_to_cpu(block->bb_level);
+	if (level >= rcbagbt_maxlevels_possible())
+		return __this_address;
+
+	maxrecs = rcbagbt_maxrecs(mp, XFBNO_BLOCKSIZE, level == 0);
+	return libxfs_btree_memblock_verify(bp, maxrecs);
+}
+
+static void
+rcbagbt_rw_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa = rcbagbt_verify(bp);
+
+	if (fa)
+		do_error(_("refcount bag btree block 0x%llx corrupted at %p\n"),
+				(unsigned long long)xfs_buf_daddr(bp), fa);
+}
+
+/* skip crc checks on in-memory btrees to save time */
+static const struct xfs_buf_ops rcbagbt_mem_buf_ops = {
+	.name			= "rcbagbt_mem",
+	.magic			= { 0, cpu_to_be32(RCBAG_MAGIC) },
+	.verify_read		= rcbagbt_rw_verify,
+	.verify_write		= rcbagbt_rw_verify,
+	.verify_struct		= rcbagbt_verify,
+};
+
+static const struct xfs_btree_ops rcbagbt_mem_ops = {
+	.name			= "rcbag",
+	.type			= XFS_BTREE_TYPE_MEM,
+
+	.rec_len		= sizeof(struct rcbag_rec),
+	.key_len		= sizeof(struct rcbag_key),
+	.ptr_len		= XFS_BTREE_LONG_PTR_LEN,
+
+	.lru_refs		= 1,
+
+	.dup_cursor		= xfbtree_dup_cursor,
+	.set_root		= xfbtree_set_root,
+	.alloc_block		= xfbtree_alloc_block,
+	.free_block		= xfbtree_free_block,
+	.get_minrecs		= xfbtree_get_minrecs,
+	.get_maxrecs		= xfbtree_get_maxrecs,
+	.init_key_from_rec	= rcbagbt_init_key_from_rec,
+	.init_rec_from_cur	= rcbagbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfbtree_init_ptr_from_cur,
+	.key_diff		= rcbagbt_key_diff,
+	.buf_ops		= &rcbagbt_mem_buf_ops,
+	.diff_two_keys		= rcbagbt_diff_two_keys,
+	.keys_inorder		= rcbagbt_keys_inorder,
+	.recs_inorder		= rcbagbt_recs_inorder,
+};
+
+/* Create a cursor for an in-memory btree. */
+struct xfs_btree_cur *
+rcbagbt_mem_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfbtree		*xfbt)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_btree_alloc_cursor(mp, tp, &rcbagbt_mem_ops,
+			rcbagbt_maxlevels_possible(), rcbagbt_cur_cache);
+
+	cur->bc_mem.xfbtree = xfbt;
+	cur->bc_nlevels = xfbt->nlevels;
+	return cur;
+}
+
+/* Create an in-memory refcount bag btree. */
+int
+rcbagbt_mem_init(
+	struct xfs_mount	*mp,
+	struct xfbtree		*xfbt,
+	struct xfs_buftarg	*btp)
+{
+	xfbt->owner = 0;
+	return -xfbtree_init(mp, xfbt, btp, &rcbagbt_mem_ops);
+}
+
+/* Calculate number of records in a refcount bag btree block. */
+static inline unsigned int
+rcbagbt_block_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	if (leaf)
+		return blocklen / sizeof(struct rcbag_rec);
+	return blocklen /
+		(sizeof(struct rcbag_key) + sizeof(rcbag_ptr_t));
+}
+
+/*
+ * Calculate number of records in an refcount bag btree block.
+ */
+unsigned int
+rcbagbt_maxrecs(
+	struct xfs_mount	*mp,
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	blocklen -= RCBAG_BLOCK_LEN;
+	return rcbagbt_block_maxrecs(blocklen, leaf);
+}
+
+/* Compute the max possible height for refcount bag btrees. */
+unsigned int
+rcbagbt_maxlevels_possible(void)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = XFBNO_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
+
+	minrecs[0] = rcbagbt_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = rcbagbt_block_maxrecs(blocklen, false) / 2;
+
+	return libxfs_btree_space_to_height(minrecs, ULLONG_MAX);
+}
+
+/* Calculate the refcount bag btree size for some records. */
+unsigned long long
+rcbagbt_calc_size(
+	unsigned long long	nr_records)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = XFBNO_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
+
+	minrecs[0] = rcbagbt_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = rcbagbt_block_maxrecs(blocklen, false) / 2;
+
+	return libxfs_btree_calc_size(minrecs, nr_records);
+}
+
+int __init
+rcbagbt_init_cur_cache(void)
+{
+	rcbagbt_cur_cache = kmem_cache_create("rcbagbt_cur",
+			xfs_btree_cur_sizeof(rcbagbt_maxlevels_possible()),
+			0, 0, NULL);
+
+	if (!rcbagbt_cur_cache)
+		return ENOMEM;
+	return 0;
+}
+
+void
+rcbagbt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(rcbagbt_cur_cache);
+	rcbagbt_cur_cache = NULL;
+}
diff --git a/repair/rcbag_btree.h b/repair/rcbag_btree.h
new file mode 100644
index 000000000..acd7765c8
--- /dev/null
+++ b/repair/rcbag_btree.h
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __RCBAG_BTREE_H__
+#define __RCBAG_BTREE_H__
+
+struct xfs_buf;
+struct xfs_btree_cur;
+struct xfs_mount;
+
+#define RCBAG_MAGIC	0x74826671	/* 'JRBG' */
+
+struct rcbag_key {
+	uint32_t	rbg_startblock;
+	uint32_t	rbg_blockcount;
+	uint64_t	rbg_ino;
+};
+
+struct rcbag_rec {
+	uint32_t	rbg_startblock;
+	uint32_t	rbg_blockcount;
+	uint64_t	rbg_ino;
+	uint64_t	rbg_refcount;
+};
+
+typedef __be64 rcbag_ptr_t;
+
+/* reflinks only exist on crc enabled filesystems */
+#define RCBAG_BLOCK_LEN	XFS_BTREE_LBLOCK_CRC_LEN
+
+/*
+ * Record, key, and pointer address macros for btree blocks.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
+ */
+#define RCBAG_REC_ADDR(block, index) \
+	((struct rcbag_rec *) \
+		((char *)(block) + RCBAG_BLOCK_LEN + \
+		 (((index) - 1) * sizeof(struct rcbag_rec))))
+
+#define RCBAG_KEY_ADDR(block, index) \
+	((struct rcbag_key *) \
+		((char *)(block) + RCBAG_BLOCK_LEN + \
+		 ((index) - 1) * sizeof(struct rcbag_key)))
+
+#define RCBAG_PTR_ADDR(block, index, maxrecs) \
+	((rcbag_ptr_t *) \
+		((char *)(block) + RCBAG_BLOCK_LEN + \
+		 (maxrecs) * sizeof(struct rcbag_key) + \
+		 ((index) - 1) * sizeof(rcbag_ptr_t)))
+
+unsigned int rcbagbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
+
+unsigned long long rcbagbt_calc_size(unsigned long long nr_records);
+
+unsigned int rcbagbt_maxlevels_possible(void);
+
+int __init rcbagbt_init_cur_cache(void);
+void rcbagbt_destroy_cur_cache(void);
+
+struct xfbtree;
+struct xfs_btree_cur *rcbagbt_mem_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xfbtree *xfbtree);
+int rcbagbt_mem_init(struct xfs_mount *mp, struct xfbtree *xfbtree,
+		struct xfs_buftarg *btp);
+
+#endif /* __RCBAG_BTREE_H__ */


