Return-Path: <linux-xfs+bounces-16656-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 999A69F01A3
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 02:11:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B46116B3B0
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 01:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5B90DDBE;
	Fri, 13 Dec 2024 01:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kbK01EYl"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8556A8BEC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052262; cv=none; b=rcuTdmdLr1mn30N8Qj4cghO2gH8h53fgILFvIzyImkS/J/8gDNovgISUxVFxMhUq418bGgbx7zmbBKWyRqtLEBnU9911GUZfFPYNwE5XR/6g35FX4j/XxQar3UcQXK/KmwMYCchYvkRcFnFlQ+5qasOmMic/nJ/MvtXFqbI6OFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052262; c=relaxed/simple;
	bh=Q1NzNCJrK2AxuQo1svryoTfvz3KkVKaBWXEH+tO3RuA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YEq3oJoASC5Vbic9zwTJvZ/NzSnaAgV/LRW1S8aPKOqN1AV+h+y8g2/r8fRwC3Fbi5D596X6UTNb4kDnqVpN4X6pFTyC706ix2kctHFFfjhX/Ai8TgUorqlRJ1tXmRLZf1gvzAhBoMERFzMb/HiBUCBKyYSRyKeYYUAKHpw/EXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kbK01EYl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5827AC4CECE;
	Fri, 13 Dec 2024 01:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052262;
	bh=Q1NzNCJrK2AxuQo1svryoTfvz3KkVKaBWXEH+tO3RuA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kbK01EYluOdm1XduQIK10+CPDwAUiq+h//0BxTDhv0N+G3neRrNPtMqs+SzhvwneH
	 Zk8wA5jWPSwiE7xXim3Yj4RU3Dz3eoGAwfnveSaPinBIByTQxJbGZzr7dWzWEtqul5
	 gi/Yq417I3F7kGyUZlE38xwW8HHcIRRrbm0TBS8YOYhVgkLgqo2rR7CX4rcuSCNlUC
	 miWPssi11FjrPGimpr9kZYPEOlyEuAe+2VQubrjPwLQKjHqBYl1nvkWeAGylVo6I/I
	 h6Ge9ctu9bvP/Td15gpb/8Xw1bFtC+EDefnbXJmduTvEmCMiWuc3iCg0bpZHm9wYIP
	 Tf1DzxPlbv6HQ==
Date: Thu, 12 Dec 2024 17:11:01 -0800
Subject: [PATCH 03/43] xfs: introduce realtime refcount btree ondisk
 definitions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124618.1182620.6370020995613116382.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add the ondisk structure definitions for realtime refcount btrees. The
realtime refcount btree will be rooted from a hidden inode so it needs
to have a separate btree block magic and pointer format.

Next, add everything needed to read, write and manipulate refcount btree
blocks. This prepares the way for connecting the btree operations
implementation.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/Makefile                      |    1 
 fs/xfs/libxfs/xfs_btree.c            |    5 +
 fs/xfs/libxfs/xfs_format.h           |    9 +
 fs/xfs/libxfs/xfs_ondisk.h           |    1 
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  273 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |   70 +++++++++
 fs/xfs/libxfs/xfs_sb.c               |    8 +
 fs/xfs/libxfs/xfs_shared.h           |    7 +
 fs/xfs/xfs_mount.c                   |    7 +
 fs/xfs/xfs_mount.h                   |    9 +
 fs/xfs/xfs_stats.c                   |    3 
 fs/xfs/xfs_stats.h                   |    1 
 12 files changed, 392 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 338e10f81b7b71..b9356d01416e16 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -51,6 +51,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_rmap_btree.o \
 				   xfs_refcount.o \
 				   xfs_refcount_btree.o \
+				   xfs_rtrefcount_btree.o \
 				   xfs_rtrmap_btree.o \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 36ab06f8a3bc99..299ce7fd11b0a9 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -35,6 +35,7 @@
 #include "xfs_rmap.h"
 #include "xfs_quota.h"
 #include "xfs_metafile.h"
+#include "xfs_rtrefcount_btree.h"
 
 /*
  * Btree magic numbers.
@@ -5533,6 +5534,9 @@ xfs_btree_init_cur_caches(void)
 	if (error)
 		goto err;
 	error = xfs_rtrmapbt_init_cur_cache();
+	if (error)
+		goto err;
+	error = xfs_rtrefcountbt_init_cur_cache();
 	if (error)
 		goto err;
 
@@ -5552,6 +5556,7 @@ xfs_btree_destroy_cur_caches(void)
 	xfs_rmapbt_destroy_cur_cache();
 	xfs_refcountbt_destroy_cur_cache();
 	xfs_rtrmapbt_destroy_cur_cache();
+	xfs_rtrefcountbt_destroy_cur_cache();
 }
 
 /* Move the btree cursor before the first record. */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 16696bc3ff9445..17f7c0d1aaa452 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1796,6 +1796,15 @@ struct xfs_refcount_key {
 /* btree pointer type */
 typedef __be32 xfs_refcount_ptr_t;
 
+/*
+ * Realtime Reference Count btree format definitions
+ *
+ * This is a btree for reference count records for realtime volumes
+ */
+#define	XFS_RTREFC_CRC_MAGIC	0x52434e54	/* 'RCNT' */
+
+/* inode-rooted btree pointer type */
+typedef __be64 xfs_rtrefcount_ptr_t;
 
 /*
  * BMAP Btree format definitions
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 07e2f5fb3a94ae..efb035050c009c 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -85,6 +85,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtbuf_blkinfo,		48);
 	XFS_CHECK_STRUCT_SIZE(xfs_rtrmap_ptr_t,			8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rtrmap_root,		4);
+	XFS_CHECK_STRUCT_SIZE(xfs_rtrefcount_ptr_t,		8);
 
 	/*
 	 * m68k has problems with struct xfs_attr_leaf_name_remote, but we pad
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
new file mode 100644
index 00000000000000..d07d3b1e78f730
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
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
+#include "xfs_rtrefcount_btree.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_error.h"
+#include "xfs_extent_busy.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtbitmap.h"
+
+static struct kmem_cache	*xfs_rtrefcountbt_cur_cache;
+
+/*
+ * Realtime Reference Count btree.
+ *
+ * This is a btree used to track the owner(s) of a given extent in the realtime
+ * device.  See the comments in xfs_refcount_btree.c for more information.
+ *
+ * This tree is basically the same as the regular refcount btree except that
+ * it's rooted in an inode.
+ */
+
+static struct xfs_btree_cur *
+xfs_rtrefcountbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_rtrefcountbt_init_cursor(cur->bc_tp, to_rtg(cur->bc_group));
+}
+
+static xfs_failaddr_t
+xfs_rtrefcountbt_verify(
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
+	if (!xfs_has_reflink(mp))
+		return __this_address;
+	fa = xfs_btree_fsblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+	if (fa)
+		return fa;
+	level = be16_to_cpu(block->bb_level);
+	if (level > mp->m_rtrefc_maxlevels)
+		return __this_address;
+
+	return xfs_btree_fsblock_verify(bp, mp->m_rtrefc_mxr[level != 0]);
+}
+
+static void
+xfs_rtrefcountbt_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+
+	if (!xfs_btree_fsblock_verify_crc(bp))
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_rtrefcountbt_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
+
+	if (bp->b_error)
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+}
+
+static void
+xfs_rtrefcountbt_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+
+	fa = xfs_rtrefcountbt_verify(bp);
+	if (fa) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		return;
+	}
+	xfs_btree_fsblock_calc_crc(bp);
+
+}
+
+const struct xfs_buf_ops xfs_rtrefcountbt_buf_ops = {
+	.name			= "xfs_rtrefcountbt",
+	.magic			= { 0, cpu_to_be32(XFS_RTREFC_CRC_MAGIC) },
+	.verify_read		= xfs_rtrefcountbt_read_verify,
+	.verify_write		= xfs_rtrefcountbt_write_verify,
+	.verify_struct		= xfs_rtrefcountbt_verify,
+};
+
+const struct xfs_btree_ops xfs_rtrefcountbt_ops = {
+	.name			= "rtrefcount",
+	.type			= XFS_BTREE_TYPE_INODE,
+	.geom_flags		= XFS_BTGEO_IROOT_RECORDS,
+
+	.rec_len		= sizeof(struct xfs_refcount_rec),
+	.key_len		= sizeof(struct xfs_refcount_key),
+	.ptr_len		= XFS_BTREE_LONG_PTR_LEN,
+
+	.lru_refs		= XFS_REFC_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_rtrefcbt_2),
+
+	.dup_cursor		= xfs_rtrefcountbt_dup_cursor,
+	.buf_ops		= &xfs_rtrefcountbt_buf_ops,
+};
+
+/* Allocate a new rt refcount btree cursor. */
+struct xfs_btree_cur *
+xfs_rtrefcountbt_init_cursor(
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
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rtrefcountbt_ops,
+			mp->m_rtrefc_maxlevels, xfs_rtrefcountbt_cur_cache);
+
+	cur->bc_ino.ip = ip;
+	cur->bc_refc.nr_ops = 0;
+	cur->bc_refc.shape_changes = 0;
+	cur->bc_group = xfs_group_hold(rtg_group(rtg));
+	cur->bc_nlevels = be16_to_cpu(ip->i_df.if_broot->bb_level) + 1;
+	cur->bc_ino.forksize = xfs_inode_fork_size(ip, XFS_DATA_FORK);
+	cur->bc_ino.whichfork = XFS_DATA_FORK;
+	return cur;
+}
+
+/*
+ * Install a new rt reverse mapping btree root.  Caller is responsible for
+ * invalidating and freeing the old btree blocks.
+ */
+void
+xfs_rtrefcountbt_commit_staged_btree(
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
+/* Calculate number of records in a realtime refcount btree block. */
+static inline unsigned int
+xfs_rtrefcountbt_block_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+
+	if (leaf)
+		return blocklen / sizeof(struct xfs_refcount_rec);
+	return blocklen / (sizeof(struct xfs_refcount_key) +
+			   sizeof(xfs_rtrefcount_ptr_t));
+}
+
+/*
+ * Calculate number of records in an refcount btree block.
+ */
+unsigned int
+xfs_rtrefcountbt_maxrecs(
+	struct xfs_mount	*mp,
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	blocklen -= XFS_RTREFCOUNT_BLOCK_LEN;
+	return xfs_rtrefcountbt_block_maxrecs(blocklen, leaf);
+}
+
+/* Compute the max possible height for realtime refcount btrees. */
+unsigned int
+xfs_rtrefcountbt_maxlevels_ondisk(void)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
+
+	minrecs[0] = xfs_rtrefcountbt_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = xfs_rtrefcountbt_block_maxrecs(blocklen, false) / 2;
+
+	/* We need at most one record for every block in an rt group. */
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_RGBLOCKS);
+}
+
+int __init
+xfs_rtrefcountbt_init_cur_cache(void)
+{
+	xfs_rtrefcountbt_cur_cache = kmem_cache_create("xfs_rtrefcountbt_cur",
+			xfs_btree_cur_sizeof(
+					xfs_rtrefcountbt_maxlevels_ondisk()),
+			0, 0, NULL);
+
+	if (!xfs_rtrefcountbt_cur_cache)
+		return -ENOMEM;
+	return 0;
+}
+
+void
+xfs_rtrefcountbt_destroy_cur_cache(void)
+{
+	kmem_cache_destroy(xfs_rtrefcountbt_cur_cache);
+	xfs_rtrefcountbt_cur_cache = NULL;
+}
+
+/* Compute the maximum height of a realtime refcount btree. */
+void
+xfs_rtrefcountbt_compute_maxlevels(
+	struct xfs_mount	*mp)
+{
+	unsigned int		d_maxlevels, r_maxlevels;
+
+	if (!xfs_has_rtreflink(mp)) {
+		mp->m_rtrefc_maxlevels = 0;
+		return;
+	}
+
+	/*
+	 * The realtime refcountbt lives on the data device, which means that
+	 * its maximum height is constrained by the size of the data device and
+	 * the height required to store one refcount record for each rtextent
+	 * in an rt group.
+	 */
+	d_maxlevels = xfs_btree_space_to_height(mp->m_rtrefc_mnr,
+				mp->m_sb.sb_dblocks);
+	r_maxlevels = xfs_btree_compute_maxlevels(mp->m_rtrefc_mnr,
+				mp->m_sb.sb_rgextents);
+
+	/* Add one level to handle the inode root level. */
+	mp->m_rtrefc_maxlevels = min(d_maxlevels, r_maxlevels) + 1;
+}
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
new file mode 100644
index 00000000000000..b713b33818800c
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_RTREFCOUNT_BTREE_H__
+#define __XFS_RTREFCOUNT_BTREE_H__
+
+struct xfs_buf;
+struct xfs_btree_cur;
+struct xfs_mount;
+struct xbtree_ifakeroot;
+struct xfs_rtgroup;
+
+/* refcounts only exist on crc enabled filesystems */
+#define XFS_RTREFCOUNT_BLOCK_LEN	XFS_BTREE_LBLOCK_CRC_LEN
+
+struct xfs_btree_cur *xfs_rtrefcountbt_init_cursor(struct xfs_trans *tp,
+		struct xfs_rtgroup *rtg);
+struct xfs_btree_cur *xfs_rtrefcountbt_stage_cursor(struct xfs_mount *mp,
+		struct xfs_rtgroup *rtg, struct xfs_inode *ip,
+		struct xbtree_ifakeroot *ifake);
+void xfs_rtrefcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_trans *tp);
+unsigned int xfs_rtrefcountbt_maxrecs(struct xfs_mount *mp,
+		unsigned int blocklen, bool leaf);
+void xfs_rtrefcountbt_compute_maxlevels(struct xfs_mount *mp);
+
+/*
+ * Addresses of records, keys, and pointers within an incore rtrefcountbt block.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
+ */
+static inline struct xfs_refcount_rec *
+xfs_rtrefcount_rec_addr(
+	struct xfs_btree_block	*block,
+	unsigned int		index)
+{
+	return (struct xfs_refcount_rec *)
+		((char *)block + XFS_RTREFCOUNT_BLOCK_LEN +
+		 (index - 1) * sizeof(struct xfs_refcount_rec));
+}
+
+static inline struct xfs_refcount_key *
+xfs_rtrefcount_key_addr(
+	struct xfs_btree_block	*block,
+	unsigned int		index)
+{
+	return (struct xfs_refcount_key *)
+		((char *)block + XFS_RTREFCOUNT_BLOCK_LEN +
+		 (index - 1) * sizeof(struct xfs_refcount_key));
+}
+
+static inline xfs_rtrefcount_ptr_t *
+xfs_rtrefcount_ptr_addr(
+	struct xfs_btree_block	*block,
+	unsigned int		index,
+	unsigned int		maxrecs)
+{
+	return (xfs_rtrefcount_ptr_t *)
+		((char *)block + XFS_RTREFCOUNT_BLOCK_LEN +
+		 maxrecs * sizeof(struct xfs_refcount_key) +
+		 (index - 1) * sizeof(xfs_rtrefcount_ptr_t));
+}
+
+unsigned int xfs_rtrefcountbt_maxlevels_ondisk(void);
+int __init xfs_rtrefcountbt_init_cur_cache(void);
+void xfs_rtrefcountbt_destroy_cur_cache(void);
+
+#endif	/* __XFS_RTREFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 83fb14b4074c8d..3dc5f5dba162d0 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -29,6 +29,7 @@
 #include "xfs_exchrange.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1226,6 +1227,13 @@ xfs_sb_mount_common(
 	mp->m_refc_mnr[0] = mp->m_refc_mxr[0] / 2;
 	mp->m_refc_mnr[1] = mp->m_refc_mxr[1] / 2;
 
+	mp->m_rtrefc_mxr[0] = xfs_rtrefcountbt_maxrecs(mp, sbp->sb_blocksize,
+			true);
+	mp->m_rtrefc_mxr[1] = xfs_rtrefcountbt_maxrecs(mp, sbp->sb_blocksize,
+			false);
+	mp->m_rtrefc_mnr[0] = mp->m_rtrefc_mxr[0] / 2;
+	mp->m_rtrefc_mnr[1] = mp->m_rtrefc_mxr[1] / 2;
+
 	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 960716c387cc2b..b1e0d9bc1f7d70 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -42,6 +42,7 @@ extern const struct xfs_buf_ops xfs_rtbitmap_buf_ops;
 extern const struct xfs_buf_ops xfs_rtsummary_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
+extern const struct xfs_buf_ops xfs_rtrefcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rtrmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
@@ -58,6 +59,7 @@ extern const struct xfs_btree_ops xfs_rmapbt_ops;
 extern const struct xfs_btree_ops xfs_rmapbt_mem_ops;
 extern const struct xfs_btree_ops xfs_rtrmapbt_ops;
 extern const struct xfs_btree_ops xfs_rtrmapbt_mem_ops;
+extern const struct xfs_btree_ops xfs_rtrefcountbt_ops;
 
 static inline bool xfs_btree_is_bno(const struct xfs_btree_ops *ops)
 {
@@ -114,6 +116,11 @@ static inline bool xfs_btree_is_rtrmap(const struct xfs_btree_ops *ops)
 	return ops == &xfs_rtrmapbt_ops;
 }
 
+static inline bool xfs_btree_is_rtrefcount(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_rtrefcountbt_ops;
+}
+
 /* log size calculation functions */
 int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
 int	xfs_log_calc_minimum_size(struct xfs_mount *);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7b7d21b50d5409..66b91b582691cd 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -38,6 +38,7 @@
 #include "xfs_metafile.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/stats.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -656,7 +657,10 @@ static inline void
 xfs_rtbtree_compute_maxlevels(
 	struct xfs_mount	*mp)
 {
-	mp->m_rtbtree_maxlevels = mp->m_rtrmap_maxlevels;
+	unsigned int		levels;
+
+	levels = max(mp->m_rtrmap_maxlevels, mp->m_rtrefc_maxlevels);
+	mp->m_rtbtree_maxlevels = levels;
 }
 
 /*
@@ -729,6 +733,7 @@ xfs_mountfs(
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
+	xfs_rtrefcountbt_compute_maxlevels(mp);
 
 	xfs_agbtree_compute_maxlevels(mp);
 	xfs_rtbtree_compute_maxlevels(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1bc95fb170db61..9a1516080e6361 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -162,11 +162,14 @@ typedef struct xfs_mount {
 	uint			m_rtrmap_mnr[2]; /* min rtrmap btree records */
 	uint			m_refc_mxr[2];	/* max refc btree records */
 	uint			m_refc_mnr[2];	/* min refc btree records */
+	uint			m_rtrefc_mxr[2]; /* max rtrefc btree records */
+	uint			m_rtrefc_mnr[2]; /* min rtrefc btree records */
 	uint			m_alloc_maxlevels; /* max alloc btree levels */
 	uint			m_bm_maxlevels[2]; /* max bmap btree levels */
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
 	uint			m_rtrmap_maxlevels; /* max rtrmap btree level */
 	uint			m_refc_maxlevels; /* max refcount btree level */
+	uint			m_rtrefc_maxlevels; /* max rtrefc btree level */
 	unsigned int		m_agbtree_maxlevels; /* max level of all AG btrees */
 	unsigned int		m_rtbtree_maxlevels; /* max level of all rt btrees */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
@@ -408,6 +411,12 @@ static inline bool xfs_has_rtrmapbt(struct xfs_mount *mp)
 	       xfs_has_rmapbt(mp);
 }
 
+static inline bool xfs_has_rtreflink(struct xfs_mount *mp)
+{
+	return xfs_has_metadir(mp) && xfs_has_realtime(mp) &&
+	       xfs_has_reflink(mp);
+}
+
 /*
  * Some features are always on for v5 file systems, allow the compiler to
  * eliminiate dead code when building without v4 support.
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index b7f2988bc03bb7..35c7fb3ba32448 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -54,7 +54,8 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		{ "rmapbt_mem",		xfsstats_offset(xs_rcbag_2)	},
 		{ "rcbagbt",		xfsstats_offset(xs_rtrmap_2)	},
 		{ "rtrmapbt",		xfsstats_offset(xs_rtrmap_mem_2)},
-		{ "rtrmapbt_mem",	xfsstats_offset(xs_qm_dqreclaims)},
+		{ "rtrmapbt_mem",	xfsstats_offset(xs_rtrefcbt_2)	},
+		{ "rtrefcntbt",		xfsstats_offset(xs_qm_dqreclaims)},
 		/* we print both series of quota information together */
 		{ "qm",			xfsstats_offset(xs_xstrat_bytes)},
 	};
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 9c47de5dff2dd6..15ba1abcf2536f 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -129,6 +129,7 @@ struct __xfsstats {
 	uint32_t		xs_rcbag_2[__XBTS_MAX];
 	uint32_t		xs_rtrmap_2[__XBTS_MAX];
 	uint32_t		xs_rtrmap_mem_2[__XBTS_MAX];
+	uint32_t		xs_rtrefcbt_2[__XBTS_MAX];
 	uint32_t		xs_qm_dqreclaims;
 	uint32_t		xs_qm_dqreclaim_misses;
 	uint32_t		xs_qm_dquot_dups;


