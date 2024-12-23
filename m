Return-Path: <linux-xfs+bounces-17546-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AAF59FB764
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Dec 2024 23:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 544801884E9D
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Dec 2024 22:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9911F1A8F6B;
	Mon, 23 Dec 2024 22:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eBawhlSg"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C01186E20
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994662; cv=none; b=pz4swv9OU85eKKLNlOBhL6XZJHEtNegmTBKSyNeBLlDIsV77388Ofplvi1Ajsc73qBHqMd2XbF5oBIrvfys8NrpGnrwre6Q/CYy/X/a7LW1al6ebTK3och8fxFqV4dSw+SvG/cJwRkoQWG57/yXpXgvXC6zswy1f0e5v+wKajnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994662; c=relaxed/simple;
	bh=Fzb4lLaq6u30+bNeLTEycJCOaqcc+K0ZbncMvU+xx9E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tgnBLiyTY+9zv4yyeGO5aEHWKnj+aTwvoGQGA+a1yGIuXNhgL/VTwa06dgJVvV9eh8j+dWWKy/KAVayJtk+jkTuUyUfOcKq/OL+n9MBpM8O5/rCktEz2SM5CnV82vTLELH7Tpi5PjjBS6KyKW5zM9u7QG7J5VPGpa3O9THGQLMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eBawhlSg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BBAEC4CED3;
	Mon, 23 Dec 2024 22:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994662;
	bh=Fzb4lLaq6u30+bNeLTEycJCOaqcc+K0ZbncMvU+xx9E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eBawhlSgxnErbemWY26CYawr1t3xkUI3yBiY5ykCH6hcHrc0a20c4sR3gBMlNTMZ6
	 arnAMSu2US+HdgmrrXnchKwKCzq/ZvI/NjhpabhFWQmQ46ugxjlbMNqMsBfzZS1n71
	 4hJwfS77hQUPhC77w4YbinoU8xNBDTg2FD8YPRwzrNpFnKz5kRf+i8xpv8ioFfGq4H
	 n/P5xk8ej3U0tvpQhAf0JBP6PKsTu9dw/NsIMmdQQy22uEMfSAllH9VI3EFmjMsgwB
	 Ty/FJtqQsVL7aEo8Na5xWUEWa6U8SCJaIQPU+nGoklJHiJq9HqBbxXHh/JEnqvRNRF
	 ZRcw0vr7hxukg==
Date: Mon, 23 Dec 2024 14:57:41 -0800
Subject: [PATCH 04/37] xfs: introduce realtime rmap btree ondisk definitions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499418781.2380130.4393630152845831820.stgit@frogsfrogsfrogs>
In-Reply-To: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
References: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add the ondisk structure definitions for realtime rmap btrees. The
realtime rmap btree will be rooted from a hidden inode so it needs to
have a separate btree block magic and pointer format.

Next, add everything needed to read, write and manipulate rmap btree
blocks. This prepares the way for connecting the btree operations
implementation, though embedding the rtrmap btree root in the inode
comes later in the series.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/libxfs/xfs_btree.c        |    5 +
 fs/xfs/libxfs/xfs_format.h       |   10 +
 fs/xfs/libxfs/xfs_ondisk.h       |    1 
 fs/xfs/libxfs/xfs_rtrmap_btree.c |  271 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |   82 +++++++++++
 fs/xfs/libxfs/xfs_sb.c           |    6 +
 fs/xfs/libxfs/xfs_shared.h       |    7 +
 fs/xfs/xfs_mount.c               |    5 -
 fs/xfs/xfs_mount.h               |    9 +
 fs/xfs/xfs_stats.c               |    3 
 fs/xfs/xfs_stats.h               |    1 
 12 files changed, 398 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ed9b0dabc1f11d..ff45efb2463f73 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -51,6 +51,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_rmap_btree.o \
 				   xfs_refcount.o \
 				   xfs_refcount_btree.o \
+				   xfs_rtrmap_btree.o \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
 				   xfs_trans_inode.o \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5ab201ef041e7d..0e271919374780 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -30,6 +30,7 @@
 #include "xfs_health.h"
 #include "xfs_buf_mem.h"
 #include "xfs_btree_mem.h"
+#include "xfs_rtrmap_btree.h"
 
 /*
  * Btree magic numbers.
@@ -5525,6 +5526,9 @@ xfs_btree_init_cur_caches(void)
 	if (error)
 		goto err;
 	error = xfs_refcountbt_init_cur_cache();
+	if (error)
+		goto err;
+	error = xfs_rtrmapbt_init_cur_cache();
 	if (error)
 		goto err;
 
@@ -5543,6 +5547,7 @@ xfs_btree_destroy_cur_caches(void)
 	xfs_bmbt_destroy_cur_cache();
 	xfs_rmapbt_destroy_cur_cache();
 	xfs_refcountbt_destroy_cur_cache();
+	xfs_rtrmapbt_destroy_cur_cache();
 }
 
 /* Move the btree cursor before the first record. */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 4d47a3e723aa13..469fc7afa591b4 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1725,6 +1725,16 @@ typedef __be32 xfs_rmap_ptr_t;
 	 XFS_FIBT_BLOCK(mp) + 1 : \
 	 XFS_IBT_BLOCK(mp) + 1)
 
+/*
+ * Realtime Reverse mapping btree format definitions
+ *
+ * This is a btree for reverse mapping records for realtime volumes
+ */
+#define	XFS_RTRMAP_CRC_MAGIC	0x4d415052	/* 'MAPR' */
+
+/* inode-based btree pointer type */
+typedef __be64 xfs_rtrmap_ptr_t;
+
 /*
  * Reference Count Btree format definitions
  *
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index ad0dedf00f1898..2c50877a1a2f0b 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -83,6 +83,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_raw,		4);
 	XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_raw,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtbuf_blkinfo,		48);
+	XFS_CHECK_STRUCT_SIZE(xfs_rtrmap_ptr_t,			8);
 
 	/*
 	 * m68k has problems with struct xfs_attr_leaf_name_remote, but we pad
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
new file mode 100644
index 00000000000000..d3e4c52dcaa9d0
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -0,0 +1,271 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_alloc.h"
+#include "xfs_btree.h"
+#include "xfs_btree_staging.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_error.h"
+#include "xfs_extent_busy.h"
+#include "xfs_rtgroup.h"
+
+static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
+
+/*
+ * Realtime Reverse Map btree.
+ *
+ * This is a btree used to track the owner(s) of a given extent in the realtime
+ * device.  See the comments in xfs_rmap_btree.c for more information.
+ *
+ * This tree is basically the same as the regular rmap btree except that it
+ * is rooted in an inode and does not live in free space.
+ */
+
+static struct xfs_btree_cur *
+xfs_rtrmapbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_rtrmapbt_init_cursor(cur->bc_tp, to_rtg(cur->bc_group));
+}
+
+static xfs_failaddr_t
+xfs_rtrmapbt_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_failaddr_t		fa;
+	int			level;
+
+	if (!xfs_verify_magic(bp, block->bb_magic))
+		return __this_address;
+
+	if (!xfs_has_rmapbt(mp))
+		return __this_address;
+	fa = xfs_btree_fsblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+	if (fa)
+		return fa;
+	level = be16_to_cpu(block->bb_level);
+	if (level > mp->m_rtrmap_maxlevels)
+		return __this_address;
+
+	return xfs_btree_fsblock_verify(bp, mp->m_rtrmap_mxr[level != 0]);
+}
+
+static void
+xfs_rtrmapbt_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+
+	if (!xfs_btree_fsblock_verify_crc(bp))
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_rtrmapbt_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
+
+	if (bp->b_error)
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+}
+
+static void
+xfs_rtrmapbt_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+
+	fa = xfs_rtrmapbt_verify(bp);
+	if (fa) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		return;
+	}
+	xfs_btree_fsblock_calc_crc(bp);
+
+}
+
+const struct xfs_buf_ops xfs_rtrmapbt_buf_ops = {
+	.name			= "xfs_rtrmapbt",
+	.magic			= { 0, cpu_to_be32(XFS_RTRMAP_CRC_MAGIC) },
+	.verify_read		= xfs_rtrmapbt_read_verify,
+	.verify_write		= xfs_rtrmapbt_write_verify,
+	.verify_struct		= xfs_rtrmapbt_verify,
+};
+
+const struct xfs_btree_ops xfs_rtrmapbt_ops = {
+	.name			= "rtrmap",
+	.type			= XFS_BTREE_TYPE_INODE,
+	.geom_flags		= XFS_BTGEO_OVERLAPPING |
+				  XFS_BTGEO_IROOT_RECORDS,
+
+	.rec_len		= sizeof(struct xfs_rmap_rec),
+	/* Overlapping btree; 2 keys per pointer. */
+	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.ptr_len		= XFS_BTREE_LONG_PTR_LEN,
+
+	.lru_refs		= XFS_RMAP_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_rtrmap_2),
+
+	.dup_cursor		= xfs_rtrmapbt_dup_cursor,
+	.buf_ops		= &xfs_rtrmapbt_buf_ops,
+};
+
+/* Allocate a new rt rmap btree cursor. */
+struct xfs_btree_cur *
+xfs_rtrmapbt_init_cursor(
+	struct xfs_trans	*tp,
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_inode	*ip = NULL;
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_btree_cur	*cur;
+
+	return NULL; /* XXX */
+
+	xfs_assert_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
+
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rtrmapbt_ops,
+			mp->m_rtrmap_maxlevels, xfs_rtrmapbt_cur_cache);
+
+	cur->bc_ino.ip = ip;
+	cur->bc_group = xfs_group_hold(rtg_group(rtg));
+	cur->bc_ino.whichfork = XFS_DATA_FORK;
+	cur->bc_nlevels = be16_to_cpu(ip->i_df.if_broot->bb_level) + 1;
+	cur->bc_ino.forksize = xfs_inode_fork_size(ip, XFS_DATA_FORK);
+
+	return cur;
+}
+
+/*
+ * Install a new rt reverse mapping btree root.  Caller is responsible for
+ * invalidating and freeing the old btree blocks.
+ */
+void
+xfs_rtrmapbt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	struct xfs_trans	*tp)
+{
+	struct xbtree_ifakeroot	*ifake = cur->bc_ino.ifake;
+	struct xfs_ifork	*ifp;
+	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	/*
+	 * Free any resources hanging off the real fork, then shallow-copy the
+	 * staging fork's contents into the real fork to transfer everything
+	 * we just built.
+	 */
+	ifp = xfs_ifork_ptr(cur->bc_ino.ip, XFS_DATA_FORK);
+	xfs_idestroy_fork(ifp);
+	memcpy(ifp, ifake->if_fork, sizeof(struct xfs_ifork));
+
+	cur->bc_ino.ip->i_projid = cur->bc_group->xg_gno;
+	xfs_trans_log_inode(tp, cur->bc_ino.ip, flags);
+	xfs_btree_commit_ifakeroot(cur, tp, XFS_DATA_FORK);
+}
+
+/* Calculate number of records in a rt reverse mapping btree block. */
+static inline unsigned int
+xfs_rtrmapbt_block_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	if (leaf)
+		return blocklen / sizeof(struct xfs_rmap_rec);
+	return blocklen /
+		(2 * sizeof(struct xfs_rmap_key) + sizeof(xfs_rtrmap_ptr_t));
+}
+
+/*
+ * Calculate number of records in an rt reverse mapping btree block.
+ */
+unsigned int
+xfs_rtrmapbt_maxrecs(
+	struct xfs_mount	*mp,
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	blocklen -= XFS_RTRMAP_BLOCK_LEN;
+	return xfs_rtrmapbt_block_maxrecs(blocklen, leaf);
+}
+
+/* Compute the max possible height for realtime reverse mapping btrees. */
+unsigned int
+xfs_rtrmapbt_maxlevels_ondisk(void)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
+
+	minrecs[0] = xfs_rtrmapbt_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = xfs_rtrmapbt_block_maxrecs(blocklen, false) / 2;
+
+	/* We need at most one record for every block in an rt group. */
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_RGBLOCKS);
+}
+
+int __init
+xfs_rtrmapbt_init_cur_cache(void)
+{
+	xfs_rtrmapbt_cur_cache = kmem_cache_create("xfs_rtrmapbt_cur",
+			xfs_btree_cur_sizeof(xfs_rtrmapbt_maxlevels_ondisk()),
+			0, 0, NULL);
+
+	if (!xfs_rtrmapbt_cur_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void
+xfs_rtrmapbt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(xfs_rtrmapbt_cur_cache);
+	xfs_rtrmapbt_cur_cache = NULL;
+}
+
+/* Compute the maximum height of an rt reverse mapping btree. */
+void
+xfs_rtrmapbt_compute_maxlevels(
+	struct xfs_mount	*mp)
+{
+	unsigned int		d_maxlevels, r_maxlevels;
+
+	if (!xfs_has_rtrmapbt(mp)) {
+		mp->m_rtrmap_maxlevels = 0;
+		return;
+	}
+
+	/*
+	 * The realtime rmapbt lives on the data device, which means that its
+	 * maximum height is constrained by the size of the data device and
+	 * the height required to store one rmap record for each block in an
+	 * rt group.
+	 */
+	d_maxlevels = xfs_btree_space_to_height(mp->m_rtrmap_mnr,
+				mp->m_sb.sb_dblocks);
+	r_maxlevels = xfs_btree_compute_maxlevels(mp->m_rtrmap_mnr,
+				mp->m_groups[XG_TYPE_RTG].blocks);
+
+	/* Add one level to handle the inode root level. */
+	mp->m_rtrmap_maxlevels = min(d_maxlevels, r_maxlevels) + 1;
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
new file mode 100644
index 00000000000000..7d1a3a49a2d69b
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_RTRMAP_BTREE_H__
+#define __XFS_RTRMAP_BTREE_H__
+
+struct xfs_buf;
+struct xfs_btree_cur;
+struct xfs_mount;
+struct xbtree_ifakeroot;
+struct xfs_rtgroup;
+
+/* rmaps only exist on crc enabled filesystems */
+#define XFS_RTRMAP_BLOCK_LEN	XFS_BTREE_LBLOCK_CRC_LEN
+
+struct xfs_btree_cur *xfs_rtrmapbt_init_cursor(struct xfs_trans *tp,
+		struct xfs_rtgroup *rtg);
+struct xfs_btree_cur *xfs_rtrmapbt_stage_cursor(struct xfs_mount *mp,
+		struct xfs_rtgroup *rtg, struct xfs_inode *ip,
+		struct xbtree_ifakeroot *ifake);
+void xfs_rtrmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_trans *tp);
+unsigned int xfs_rtrmapbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
+void xfs_rtrmapbt_compute_maxlevels(struct xfs_mount *mp);
+
+/*
+ * Addresses of records, keys, and pointers within an incore rtrmapbt block.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
+ */
+static inline struct xfs_rmap_rec *
+xfs_rtrmap_rec_addr(
+	struct xfs_btree_block	*block,
+	unsigned int		index)
+{
+	return (struct xfs_rmap_rec *)
+		((char *)block + XFS_RTRMAP_BLOCK_LEN +
+		 (index - 1) * sizeof(struct xfs_rmap_rec));
+}
+
+static inline struct xfs_rmap_key *
+xfs_rtrmap_key_addr(
+	struct xfs_btree_block	*block,
+	unsigned int		index)
+{
+	return (struct xfs_rmap_key *)
+		((char *)block + XFS_RTRMAP_BLOCK_LEN +
+		 (index - 1) * 2 * sizeof(struct xfs_rmap_key));
+}
+
+static inline struct xfs_rmap_key *
+xfs_rtrmap_high_key_addr(
+	struct xfs_btree_block	*block,
+	unsigned int		index)
+{
+	return (struct xfs_rmap_key *)
+		((char *)block + XFS_RTRMAP_BLOCK_LEN +
+		 sizeof(struct xfs_rmap_key) +
+		 (index - 1) * 2 * sizeof(struct xfs_rmap_key));
+}
+
+static inline xfs_rtrmap_ptr_t *
+xfs_rtrmap_ptr_addr(
+	struct xfs_btree_block	*block,
+	unsigned int		index,
+	unsigned int		maxrecs)
+{
+	return (xfs_rtrmap_ptr_t *)
+		((char *)block + XFS_RTRMAP_BLOCK_LEN +
+		 maxrecs * 2 * sizeof(struct xfs_rmap_key) +
+		 (index - 1) * sizeof(xfs_rtrmap_ptr_t));
+}
+
+unsigned int xfs_rtrmapbt_maxlevels_ondisk(void);
+
+int __init xfs_rtrmapbt_init_cur_cache(void);
+void xfs_rtrmapbt_destroy_cur_cache(void);
+
+#endif /* __XFS_RTRMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 3b5623611eba02..83fb14b4074c8d 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -28,6 +28,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_exchrange.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1215,6 +1216,11 @@ xfs_sb_mount_common(
 	mp->m_rmap_mnr[0] = mp->m_rmap_mxr[0] / 2;
 	mp->m_rmap_mnr[1] = mp->m_rmap_mxr[1] / 2;
 
+	mp->m_rtrmap_mxr[0] = xfs_rtrmapbt_maxrecs(mp, sbp->sb_blocksize, true);
+	mp->m_rtrmap_mxr[1] = xfs_rtrmapbt_maxrecs(mp, sbp->sb_blocksize, false);
+	mp->m_rtrmap_mnr[0] = mp->m_rtrmap_mxr[0] / 2;
+	mp->m_rtrmap_mnr[1] = mp->m_rtrmap_mxr[1] / 2;
+
 	mp->m_refc_mxr[0] = xfs_refcountbt_maxrecs(mp, sbp->sb_blocksize, true);
 	mp->m_refc_mxr[1] = xfs_refcountbt_maxrecs(mp, sbp->sb_blocksize, false);
 	mp->m_refc_mnr[0] = mp->m_refc_mxr[0] / 2;
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index e7efdb9ceaf382..da23dac22c3f08 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -42,6 +42,7 @@ extern const struct xfs_buf_ops xfs_rtbitmap_buf_ops;
 extern const struct xfs_buf_ops xfs_rtsummary_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
+extern const struct xfs_buf_ops xfs_rtrmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
 extern const struct xfs_buf_ops xfs_symlink_buf_ops;
@@ -55,6 +56,7 @@ extern const struct xfs_btree_ops xfs_bmbt_ops;
 extern const struct xfs_btree_ops xfs_refcountbt_ops;
 extern const struct xfs_btree_ops xfs_rmapbt_ops;
 extern const struct xfs_btree_ops xfs_rmapbt_mem_ops;
+extern const struct xfs_btree_ops xfs_rtrmapbt_ops;
 
 static inline bool xfs_btree_is_bno(const struct xfs_btree_ops *ops)
 {
@@ -100,6 +102,11 @@ static inline bool xfs_btree_is_mem_rmap(const struct xfs_btree_ops *ops)
 # define xfs_btree_is_mem_rmap(...)	(false)
 #endif
 
+static inline bool xfs_btree_is_rtrmap(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_rtrmapbt_ops;
+}
+
 /* log size calculation functions */
 int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
 int	xfs_log_calc_minimum_size(struct xfs_mount *);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 97137126b16f5a..7b7d21b50d5409 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -37,6 +37,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_metafile.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/stats.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -655,8 +656,7 @@ static inline void
 xfs_rtbtree_compute_maxlevels(
 	struct xfs_mount	*mp)
 {
-	/* This will be filled in later. */
-	mp->m_rtbtree_maxlevels = 0;
+	mp->m_rtbtree_maxlevels = mp->m_rtrmap_maxlevels;
 }
 
 /*
@@ -727,6 +727,7 @@ xfs_mountfs(
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
 	xfs_mount_setup_inode_geom(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
+	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
 	xfs_agbtree_compute_maxlevels(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index ddb9d19a3a3d53..1bc95fb170db61 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -158,11 +158,14 @@ typedef struct xfs_mount {
 	uint			m_bmap_dmnr[2];	/* min bmap btree records */
 	uint			m_rmap_mxr[2];	/* max rmap btree records */
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
+	uint			m_rtrmap_mxr[2]; /* max rtrmap btree records */
+	uint			m_rtrmap_mnr[2]; /* min rtrmap btree records */
 	uint			m_refc_mxr[2];	/* max refc btree records */
 	uint			m_refc_mnr[2];	/* min refc btree records */
 	uint			m_alloc_maxlevels; /* max alloc btree levels */
 	uint			m_bm_maxlevels[2]; /* max bmap btree levels */
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
+	uint			m_rtrmap_maxlevels; /* max rtrmap btree level */
 	uint			m_refc_maxlevels; /* max refcount btree level */
 	unsigned int		m_agbtree_maxlevels; /* max level of all AG btrees */
 	unsigned int		m_rtbtree_maxlevels; /* max level of all rt btrees */
@@ -399,6 +402,12 @@ static inline bool xfs_has_rtsb(struct xfs_mount *mp)
 	return xfs_has_rtgroups(mp) && xfs_has_realtime(mp);
 }
 
+static inline bool xfs_has_rtrmapbt(struct xfs_mount *mp)
+{
+	return xfs_has_rtgroups(mp) && xfs_has_realtime(mp) &&
+	       xfs_has_rmapbt(mp);
+}
+
 /*
  * Some features are always on for v5 file systems, allow the compiler to
  * eliminiate dead code when building without v4 support.
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index ffb52725c2a8e8..f94fb70b524ffb 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -52,7 +52,8 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		{ "rmapbt",		xfsstats_offset(xs_refcbt_2)	},
 		{ "refcntbt",		xfsstats_offset(xs_rmap_mem_2)	},
 		{ "rmapbt_mem",		xfsstats_offset(xs_rcbag_2)	},
-		{ "rcbagbt",		xfsstats_offset(xs_qm_dqreclaims)},
+		{ "rcbagbt",		xfsstats_offset(xs_rtrmap_2)	},
+		{ "rtrmapbt",		xfsstats_offset(xs_qm_dqreclaims)},
 		/* we print both series of quota information together */
 		{ "qm",			xfsstats_offset(xs_xstrat_bytes)},
 	};
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index a61fb56ed2e66c..05dc69c6d94906 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -127,6 +127,7 @@ struct __xfsstats {
 	uint32_t		xs_refcbt_2[__XBTS_MAX];
 	uint32_t		xs_rmap_mem_2[__XBTS_MAX];
 	uint32_t		xs_rcbag_2[__XBTS_MAX];
+	uint32_t		xs_rtrmap_2[__XBTS_MAX];
 	uint32_t		xs_qm_dqreclaims;
 	uint32_t		xs_qm_dqreclaim_misses;
 	uint32_t		xs_qm_dquot_dups;


