Return-Path: <linux-xfs+bounces-1600-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68FFB820EE5
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 22:41:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C5601C219A4
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E406BE5F;
	Sun, 31 Dec 2023 21:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ploUjSYz"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA59CBE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:41:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E89C433C8;
	Sun, 31 Dec 2023 21:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058871;
	bh=TRtqJGnVr4rJFiKyLUVIoZORiVI2Dw6CF3rSbE91QPM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ploUjSYzajhIpyS3bM8hddLiyc4l2dbPBt/k7Ma1Pn6fi8VvXhH7ySG9Vudroodzd
	 Q8uOARW8dxRx3WWOJsuibjp5XRGtz/LI02dXnDwRAHq9rZI0RDYwLV1viuq9aBIfix
	 JsAh5z2F+cQeZtyNqKfY+6YkezY2jpJrGlpRQA/ZxA0Zki9il1NNLlHo9oPGc5Gwot
	 1aZ5pi89Z0VvjgCfm5cDylQ2PJz3RYK2IcHln71jzhWdjLtQlPobveE4zw9leKuFUO
	 /shD//AFiaZ69rSb3avappQ1NZPujzz16cate0sms+Gq4nC7YvmX3HW4wRouhKIaiZ
	 Qgyz61iKfeP0g==
Date: Sun, 31 Dec 2023 13:41:10 -0800
Subject: [PATCH 36/39] xfs: online repair of the realtime rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850479.1764998.16240055087580879187.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Repair the realtime rmap btree while mounted.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/libxfs/xfs_rtrmap_btree.c |    2 
 fs/xfs/libxfs/xfs_rtrmap_btree.h |    3 
 fs/xfs/scrub/common.c            |    5 
 fs/xfs/scrub/repair.c            |  135 +++++++
 fs/xfs/scrub/repair.h            |   13 +
 fs/xfs/scrub/rtrmap.c            |    7 
 fs/xfs/scrub/rtrmap_repair.c     |  749 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c             |    2 
 fs/xfs/scrub/trace.h             |   57 +++
 10 files changed, 971 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/rtrmap_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 69ca5cb7e4000..f9092ae77e684 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -235,6 +235,7 @@ xfs-y				+= $(addprefix scrub/, \
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   rgsuper_repair.o \
 				   rtbitmap_repair.o \
+				   rtrmap_repair.o \
 				   rtsummary_repair.o \
 				   )
 
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 355c50196e986..51a8ffff1c755 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -705,7 +705,7 @@ xfs_rtrmapbt_create_path(
 }
 
 /* Calculate the rtrmap btree size for some records. */
-static unsigned long long
+unsigned long long
 xfs_rtrmapbt_calc_size(
 	struct xfs_mount	*mp,
 	unsigned long long	len)
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index 108ab8c0aea44..5aec719be053f 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -202,4 +202,7 @@ struct xfs_imeta_update;
 
 int xfs_rtrmapbt_create(struct xfs_imeta_update *upd, struct xfs_inode **ipp);
 
+unsigned long long xfs_rtrmapbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index e16185e9ddd9b..558e267924399 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -993,7 +993,10 @@ int
 xchk_setup_rt(
 	struct xfs_scrub	*sc)
 {
-	return xchk_trans_alloc(sc, 0);
+	uint			resblks;
+
+	resblks = xrep_calc_rtgroup_resblks(sc);
+	return xchk_trans_alloc(sc, resblks);
 }
 
 /* Set us up with AG headers and btree cursors. */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 4789014be4a36..c9c538083c722 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -39,6 +39,8 @@
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtalloc.h"
+#include "xfs_imeta.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -382,6 +384,39 @@ xrep_calc_ag_resblks(
 	return max(max(bnobt_sz, inobt_sz), max(rmapbt_sz, refcbt_sz));
 }
 
+#ifdef CONFIG_XFS_RT
+/*
+ * Figure out how many blocks to reserve for a rtgroup repair.  We calculate
+ * the worst case estimate for the number of blocks we'd need to rebuild one of
+ * any type of per-rtgroup btree.
+ */
+xfs_extlen_t
+xrep_calc_rtgroup_resblks(
+	struct xfs_scrub		*sc)
+{
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_scrub_metadata	*sm = sc->sm;
+	struct xfs_rtgroup		*rtg;
+	xfs_extlen_t			usedlen;
+	xfs_extlen_t			rmapbt_sz = 0;
+
+	if (!(sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
+		return 0;
+
+	rtg = xfs_rtgroup_get(mp, sm->sm_agno);
+	usedlen = rtg->rtg_blockcount;
+	xfs_rtgroup_put(rtg);
+
+	if (xfs_has_rmapbt(mp))
+		rmapbt_sz = xfs_rtrmapbt_calc_size(mp, usedlen);
+
+	trace_xrep_calc_rtgroup_resblks_btsize(mp, sm->sm_agno, usedlen,
+			rmapbt_sz);
+
+	return rmapbt_sz;
+}
+#endif /* CONFIG_XFS_RT */
+
 /*
  * Reconstructing per-AG Btrees
  *
@@ -1302,3 +1337,103 @@ xrep_is_rtmeta_ino(
 
 	return false;
 }
+
+/* Check the sanity of a rmap record for a metadata btree inode. */
+int
+xrep_check_ino_btree_mapping(
+	struct xfs_scrub		*sc,
+	const struct xfs_rmap_irec	*rec)
+{
+	enum xbtree_recpacking		outcome;
+	int				error;
+
+	/*
+	 * Metadata btree inodes never have extended attributes, and all blocks
+	 * should have the bmbt block flag set.
+	 */
+	if ((rec->rm_flags & XFS_RMAP_ATTR_FORK) ||
+	    !(rec->rm_flags & XFS_RMAP_BMBT_BLOCK))
+		return -EFSCORRUPTED;
+
+	/* Make sure the block is within the AG. */
+	if (!xfs_verify_agbext(sc->sa.pag, rec->rm_startblock,
+				rec->rm_blockcount))
+		return -EFSCORRUPTED;
+
+	/* Make sure this isn't free space. */
+	error = xfs_alloc_has_records(sc->sa.bno_cur, rec->rm_startblock,
+			rec->rm_blockcount, &outcome);
+	if (error)
+		return error;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		return -EFSCORRUPTED;
+
+	return 0;
+}
+
+/*
+ * Reset the block count of the inode being repaired, and adjust the dquot
+ * block usage to match.  The inode must not have an xattr fork.
+ */
+void
+xrep_inode_set_nblocks(
+	struct xfs_scrub	*sc,
+	int64_t			new_blocks)
+{
+	int64_t			delta;
+
+	delta = new_blocks - sc->ip->i_nblocks;
+	sc->ip->i_nblocks = new_blocks;
+
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	if (delta != 0)
+		xfs_trans_mod_dquot_byino(sc->tp, sc->ip, XFS_TRANS_DQ_BCOUNT,
+				delta);
+}
+
+/* Reset the block reservation for a metadata inode. */
+int
+xrep_reset_imeta_reservation(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_inode	*ip = sc->ip;
+	int64_t			delta;
+	int			error;
+
+	delta = ip->i_nblocks + ip->i_delayed_blks - ip->i_meta_resv_asked;
+	if (delta == 0)
+		return 0;
+
+	if (delta > 0) {
+		int64_t		give_back;
+
+		/* Too many blocks, free from the incore reservation. */
+		give_back = min_t(uint64_t, delta, ip->i_delayed_blks);
+		if (give_back > 0) {
+			xfs_mod_delalloc(ip->i_mount, -give_back);
+			xfs_mod_fdblocks(ip->i_mount, give_back, true);
+			ip->i_delayed_blks -= give_back;
+		}
+
+		return 0;
+	}
+
+	/* Not enough reservation, try to add more.  @delta is negative here. */
+	error = xfs_mod_fdblocks(sc->mp, delta, true);
+	while (error == -ENOSPC) {
+		delta++;
+		if (delta == 0) {
+			xfs_warn(sc->mp,
+"Insufficient free space to reset space reservation for inode 0x%llx after repair.",
+					ip->i_ino);
+			return 0;
+		}
+		error = xfs_mod_fdblocks(sc->mp, delta, true);
+	}
+	if (error)
+		return error;
+
+	xfs_mod_delalloc(sc->mp, -delta);
+	ip->i_delayed_blks += -delta;
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index b66e0b5331394..a382ba0478aa0 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -96,6 +96,7 @@ int xrep_setup_parent(struct xfs_scrub *sc);
 int xrep_setup_nlinks(struct xfs_scrub *sc);
 int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *resblks);
 int xrep_setup_dirtree(struct xfs_scrub *sc);
+int xrep_setup_rtrmapbt(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -112,12 +113,16 @@ int xrep_rtgroup_init(struct xfs_scrub *sc, struct xfs_rtgroup *rtg,
 void xrep_rtgroup_btcur_init(struct xfs_scrub *sc, struct xchk_rt *sr);
 int xrep_require_rtext_inuse(struct xfs_scrub *sc, xfs_rtblock_t rtbno,
 		xfs_filblks_t len);
+xfs_extlen_t xrep_calc_rtgroup_resblks(struct xfs_scrub *sc);
 #else
 # define xrep_rtgroup_init(sc, rtg, sr, lockflags)	(-ENOSYS)
+# define xrep_calc_rtgroup_resblks(sc)			(0)
 #endif /* CONFIG_XFS_RT */
 
 bool xrep_is_rtmeta_ino(struct xfs_scrub *sc, struct xfs_rtgroup *rtg,
 		xfs_ino_t ino);
+int xrep_check_ino_btree_mapping(struct xfs_scrub *sc,
+		const struct xfs_rmap_irec *rec);
 
 /* Metadata revalidators */
 
@@ -153,11 +158,13 @@ int xrep_rtbitmap(struct xfs_scrub *sc);
 int xrep_rtsummary(struct xfs_scrub *sc);
 int xrep_rgsuperblock(struct xfs_scrub *sc);
 int xrep_rgbitmap(struct xfs_scrub *sc);
+int xrep_rtrmapbt(struct xfs_scrub *sc);
 #else
 # define xrep_rtbitmap			xrep_notsupported
 # define xrep_rtsummary			xrep_notsupported
 # define xrep_rgsuperblock		xrep_notsupported
 # define xrep_rgbitmap			xrep_notsupported
+# define xrep_rtrmapbt			xrep_notsupported
 #endif /* CONFIG_XFS_RT */
 
 #ifdef CONFIG_XFS_QUOTA
@@ -176,6 +183,8 @@ int xrep_trans_alloc_hook_dummy(struct xfs_mount *mp, void **cookiep,
 void xrep_trans_cancel_hook_dummy(void **cookiep, struct xfs_trans *tp);
 
 bool xrep_buf_verify_struct(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
+void xrep_inode_set_nblocks(struct xfs_scrub *sc, int64_t new_blocks);
+int xrep_reset_imeta_reservation(struct xfs_scrub *sc);
 
 #else
 
@@ -199,6 +208,8 @@ xrep_calc_ag_resblks(
 	return 0;
 }
 
+#define xrep_calc_rtgroup_resblks	xrep_calc_ag_resblks
+
 static inline int
 xrep_reset_perag_resv(
 	struct xfs_scrub	*sc)
@@ -226,6 +237,7 @@ xrep_setup_nothing(
 #define xrep_setup_nlinks		xrep_setup_nothing
 #define xrep_setup_dirtree		xrep_setup_nothing
 #define xrep_setup_metapath		xrep_setup_nothing
+#define xrep_setup_rtrmapbt		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
@@ -264,6 +276,7 @@ static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_metapath			xrep_notsupported
 #define xrep_rgsuperblock		xrep_notsupported
 #define xrep_rgbitmap			xrep_notsupported
+#define xrep_rtrmapbt			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index c3e1cee81b6d2..ce21fa95a5da7 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -27,6 +27,7 @@
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/trace.h"
+#include "scrub/repair.h"
 
 /* Set us up with the realtime metadata locked. */
 int
@@ -44,6 +45,12 @@ xchk_setup_rtrmapbt(
 	if (!rtg)
 		return -ENOENT;
 
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_rtrmapbt(sc);
+		if (error)
+			return error;
+	}
+
 	error = xchk_setup_rt(sc);
 	if (error)
 		goto out_rtg;
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
new file mode 100644
index 0000000000000..c56558ce919ab
--- /dev/null
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -0,0 +1,749 @@
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
+#include "xfs_btree.h"
+#include "xfs_btree_staging.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_alloc.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_quota.h"
+#include "xfs_rtalloc.h"
+#include "xfs_ag.h"
+#include "xfs_rtgroup.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/fsb_bitmap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/iscan.h"
+#include "scrub/newbt.h"
+#include "scrub/reap.h"
+
+/*
+ * Realtime Reverse Mapping Btree Repair
+ * =====================================
+ *
+ * This isn't quite as difficult as repairing the rmap btree on the data
+ * device, since we only store the data fork extents of realtime files on the
+ * realtime device.  We still have to freeze the filesystem and stop the
+ * background threads like we do for the rmap repair, but we only have to scan
+ * realtime inodes.
+ *
+ * Collecting entries for the new realtime rmap btree is easy -- all we have
+ * to do is generate rtrmap entries from the data fork mappings of all realtime
+ * files in the filesystem.  We then scan the rmap btrees of the data device
+ * looking for extents belonging to the old btree and note them in a bitmap.
+ *
+ * To rebuild the realtime rmap btree, we bulk-load the collected mappings into
+ * a new btree cursor and atomically swap that into the realtime inode.  Then
+ * we can free the blocks from the old btree.
+ *
+ * We use the 'xrep_rtrmap' prefix for all the rmap functions.
+ */
+
+/*
+ * Packed rmap record.  The UNWRITTEN flags are hidden in the upper bits of
+ * offset, just like the on-disk record.
+ */
+struct xrep_rtrmap_extent {
+	xfs_rgblock_t	startblock;
+	xfs_extlen_t	blockcount;
+	uint64_t	owner;
+	uint64_t	offset;
+} __packed;
+
+/* Context for collecting rmaps */
+struct xrep_rtrmap {
+	/* new rtrmapbt information */
+	struct xrep_newbt	new_btree;
+
+	/* rmap records generated from primary metadata */
+	struct xfarray		*rtrmap_records;
+
+	struct xfs_scrub	*sc;
+
+	/* bitmap of old rtrmapbt blocks */
+	struct xfsb_bitmap	old_rtrmapbt_blocks;
+
+	/* inode scan cursor */
+	struct xchk_iscan	iscan;
+
+	/* get_records()'s position in the free space record array. */
+	xfarray_idx_t		array_cur;
+};
+
+/* Set us up to repair rt reverse mapping btrees. */
+int
+xrep_setup_rtrmapbt(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_rtrmap	*rr;
+
+	rr = kzalloc(sizeof(struct xrep_rtrmap), XCHK_GFP_FLAGS);
+	if (!rr)
+		return -ENOMEM;
+
+	rr->sc = sc;
+	sc->buf = rr;
+	return 0;
+}
+
+/* Make sure there's nothing funny about this mapping. */
+STATIC int
+xrep_rtrmap_check_mapping(
+	struct xfs_scrub	*sc,
+	const struct xfs_rmap_irec *rec)
+{
+	xfs_rtblock_t		rtbno;
+
+	if (xfs_rtrmap_check_irec(sc->sr.rtg, rec) != NULL)
+		return -EFSCORRUPTED;
+
+	/* Make sure this isn't free space. */
+	rtbno = xfs_rgbno_to_rtb(sc->mp, sc->sr.rtg->rtg_rgno,
+			rec->rm_startblock);
+	return xrep_require_rtext_inuse(sc, rtbno, rec->rm_blockcount);
+}
+
+/* Store a reverse-mapping record. */
+static inline int
+xrep_rtrmap_stash(
+	struct xrep_rtrmap	*rr,
+	xfs_rgblock_t		startblock,
+	xfs_extlen_t		blockcount,
+	uint64_t		owner,
+	uint64_t		offset,
+	unsigned int		flags)
+{
+	struct xrep_rtrmap_extent	rre = {
+		.startblock	= startblock,
+		.blockcount	= blockcount,
+		.owner		= owner,
+	};
+	struct xfs_rmap_irec	rmap = {
+		.rm_startblock	= startblock,
+		.rm_blockcount	= blockcount,
+		.rm_owner	= owner,
+		.rm_offset	= offset,
+		.rm_flags	= flags,
+	};
+	struct xfs_scrub	*sc = rr->sc;
+	int			error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	trace_xrep_rtrmap_found(sc->mp, &rmap);
+
+	rre.offset = xfs_rmap_irec_offset_pack(&rmap);
+	return xfarray_append(rr->rtrmap_records, &rre);
+}
+
+/* Finding all file and bmbt extents. */
+
+/* Context for accumulating rmaps for an inode fork. */
+struct xrep_rtrmap_ifork {
+	/*
+	 * Accumulate rmap data here to turn multiple adjacent bmaps into a
+	 * single rmap.
+	 */
+	struct xfs_rmap_irec	accum;
+
+	struct xrep_rtrmap	*rr;
+};
+
+/* Stash an rmap that we accumulated while walking an inode fork. */
+STATIC int
+xrep_rtrmap_stash_accumulated(
+	struct xrep_rtrmap_ifork	*rf)
+{
+	if (rf->accum.rm_blockcount == 0)
+		return 0;
+
+	return xrep_rtrmap_stash(rf->rr, rf->accum.rm_startblock,
+			rf->accum.rm_blockcount, rf->accum.rm_owner,
+			rf->accum.rm_offset, rf->accum.rm_flags);
+}
+
+/* Accumulate a bmbt record. */
+STATIC int
+xrep_rtrmap_visit_bmbt(
+	struct xfs_btree_cur	*cur,
+	struct xfs_bmbt_irec	*rec,
+	void			*priv)
+{
+	struct xrep_rtrmap_ifork *rf = priv;
+	struct xfs_rmap_irec	*accum = &rf->accum;
+	struct xfs_mount	*mp = rf->rr->sc->mp;
+	xfs_rgnumber_t		rgno;
+	xfs_rgblock_t		rgbno;
+	unsigned int		rmap_flags = 0;
+	int			error;
+
+	rgbno = xfs_rtb_to_rgbno(mp, rec->br_startblock, &rgno);
+	if (rgno != rf->rr->sc->sr.rtg->rtg_rgno)
+		return 0;
+
+	if (rec->br_state == XFS_EXT_UNWRITTEN)
+		rmap_flags |= XFS_RMAP_UNWRITTEN;
+
+	/* If this bmap is adjacent to the previous one, just add it. */
+	if (accum->rm_blockcount > 0 &&
+	    rec->br_startoff == accum->rm_offset + accum->rm_blockcount &&
+	    rgbno == accum->rm_startblock + accum->rm_blockcount &&
+	    rmap_flags == accum->rm_flags) {
+		accum->rm_blockcount += rec->br_blockcount;
+		return 0;
+	}
+
+	/* Otherwise stash the old rmap and start accumulating a new one. */
+	error = xrep_rtrmap_stash_accumulated(rf);
+	if (error)
+		return error;
+
+	accum->rm_startblock = rgbno;
+	accum->rm_blockcount = rec->br_blockcount;
+	accum->rm_offset = rec->br_startoff;
+	accum->rm_flags = rmap_flags;
+	return 0;
+}
+
+/*
+ * Iterate the block mapping btree to collect rmap records for anything in this
+ * fork that maps to the rt volume.  Sets @mappings_done to true if we've
+ * scanned the block mappings in this fork.
+ */
+STATIC int
+xrep_rtrmap_scan_bmbt(
+	struct xrep_rtrmap_ifork *rf,
+	struct xfs_inode	*ip,
+	bool			*mappings_done)
+{
+	struct xrep_rtrmap	*rr = rf->rr;
+	struct xfs_btree_cur	*cur;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	int			error = 0;
+
+	*mappings_done = false;
+
+	/*
+	 * If the incore extent cache is already loaded, we'll just use the
+	 * incore extent scanner to record mappings.  Don't bother walking the
+	 * ondisk extent tree.
+	 */
+	if (!xfs_need_iread_extents(ifp))
+		return 0;
+
+	/* Accumulate all the mappings in the bmap btree. */
+	cur = xfs_bmbt_init_cursor(rr->sc->mp, rr->sc->tp, ip, XFS_DATA_FORK);
+	error = xfs_bmap_query_all(cur, xrep_rtrmap_visit_bmbt, rf);
+	xfs_btree_del_cursor(cur, error);
+	if (error)
+		return error;
+
+	/* Stash any remaining accumulated rmaps and exit. */
+	*mappings_done = true;
+	return xrep_rtrmap_stash_accumulated(rf);
+}
+
+/*
+ * Iterate the in-core extent cache to collect rmap records for anything in
+ * this fork that matches the AG.
+ */
+STATIC int
+xrep_rtrmap_scan_iext(
+	struct xrep_rtrmap_ifork *rf,
+	struct xfs_ifork	*ifp)
+{
+	struct xfs_bmbt_irec	rec;
+	struct xfs_iext_cursor	icur;
+	int			error;
+
+	for_each_xfs_iext(ifp, &icur, &rec) {
+		if (isnullstartblock(rec.br_startblock))
+			continue;
+		error = xrep_rtrmap_visit_bmbt(NULL, &rec, rf);
+		if (error)
+			return error;
+	}
+
+	return xrep_rtrmap_stash_accumulated(rf);
+}
+
+/* Find all the extents on the realtime device mapped by an inode fork. */
+STATIC int
+xrep_rtrmap_scan_dfork(
+	struct xrep_rtrmap	*rr,
+	struct xfs_inode	*ip)
+{
+	struct xrep_rtrmap_ifork rf = {
+		.accum		= { .rm_owner = ip->i_ino, },
+		.rr		= rr,
+	};
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	int			error = 0;
+
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
+		bool		mappings_done;
+
+		/*
+		 * Scan the bmbt for mappings.  If the incore extent tree is
+		 * loaded, we want to scan the cached mappings since that's
+		 * faster when the extent counts are very high.
+		 */
+		error = xrep_rtrmap_scan_bmbt(&rf, ip, &mappings_done);
+		if (error || mappings_done)
+			return error;
+	} else if (ifp->if_format != XFS_DINODE_FMT_EXTENTS) {
+		/* realtime data forks should only be extents or btree */
+		return -EFSCORRUPTED;
+	}
+
+	/* Scan incore extent cache. */
+	return xrep_rtrmap_scan_iext(&rf, ifp);
+}
+
+/* Record reverse mappings for a file. */
+STATIC int
+xrep_rtrmap_scan_inode(
+	struct xrep_rtrmap	*rr,
+	struct xfs_inode	*ip)
+{
+	unsigned int		lock_mode;
+	int			error = 0;
+
+	/* Skip the rt rmap btree inode. */
+	if (rr->sc->ip == ip)
+		return 0;
+
+	lock_mode = xfs_ilock_data_map_shared(ip);
+
+	/* Check the data fork if it's on the realtime device. */
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		error = xrep_rtrmap_scan_dfork(rr, ip);
+		if (error)
+			goto out_unlock;
+	}
+
+	xchk_iscan_mark_visited(&rr->iscan, ip);
+out_unlock:
+	xfs_iunlock(ip, lock_mode);
+	return error;
+}
+
+/* Record extents that belong to the realtime rmap inode. */
+STATIC int
+xrep_rtrmap_walk_rmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_rtrmap		*rr = priv;
+	struct xfs_mount		*mp = cur->bc_mp;
+	xfs_fsblock_t			fsbno;
+	int				error = 0;
+
+	if (xchk_should_terminate(rr->sc, &error))
+		return error;
+
+	/* Skip extents which are not owned by this inode and fork. */
+	if (rec->rm_owner != rr->sc->ip->i_ino)
+		return 0;
+
+	error = xrep_check_ino_btree_mapping(rr->sc, rec);
+	if (error)
+		return error;
+
+	fsbno = XFS_AGB_TO_FSB(mp, cur->bc_ag.pag->pag_agno,
+			rec->rm_startblock);
+
+	return xfsb_bitmap_set(&rr->old_rtrmapbt_blocks, fsbno,
+			rec->rm_blockcount);
+}
+
+/* Scan one AG for reverse mappings for the realtime rmap btree. */
+STATIC int
+xrep_rtrmap_scan_ag(
+	struct xrep_rtrmap	*rr,
+	struct xfs_perag	*pag)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	int			error;
+
+	error = xrep_ag_init(sc, pag, &sc->sa);
+	if (error)
+		return error;
+
+	error = xfs_rmap_query_all(sc->sa.rmap_cur, xrep_rtrmap_walk_rmap, rr);
+	xchk_ag_free(sc, &sc->sa);
+	return error;
+}
+
+STATIC int
+xrep_rtrmap_find_super_rmaps(
+	struct xrep_rtrmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+
+	/* Create a record for the rtgroup superblock. */
+	return xrep_rtrmap_stash(rr, 0, sc->mp->m_sb.sb_rextsize,
+			XFS_RMAP_OWN_FS, 0, 0);
+}
+
+/* Generate all the reverse-mappings for the realtime device. */
+STATIC int
+xrep_rtrmap_find_rmaps(
+	struct xrep_rtrmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_perag	*pag;
+	struct xfs_inode	*ip;
+	xfs_agnumber_t		agno;
+	int			error;
+
+	/* Generate rmaps for the rtgroup superblock */
+	error = xrep_rtrmap_find_super_rmaps(rr);
+	if (error)
+		return error;
+
+	/*
+	 * Set up for a potentially lengthy filesystem scan by reducing our
+	 * transaction resource usage for the duration.  Specifically:
+	 *
+	 * Unlock the realtime metadata inodes and cancel the transaction to
+	 * release the log grant space while we scan the filesystem.
+	 *
+	 * Create a new empty transaction to eliminate the possibility of the
+	 * inode scan deadlocking on cyclical metadata.
+	 *
+	 * We pass the empty transaction to the file scanning function to avoid
+	 * repeatedly cycling empty transactions.  This can be done even though
+	 * we take the IOLOCK to quiesce the file because empty transactions
+	 * do not take sb_internal.
+	 */
+	xchk_trans_cancel(sc);
+	xchk_rtgroup_unlock(sc, &sc->sr);
+	error = xchk_trans_alloc_empty(sc);
+	if (error)
+		return error;
+
+	while ((error = xchk_iscan_iter(&rr->iscan, &ip)) == 1) {
+		error = xrep_rtrmap_scan_inode(rr, ip);
+		xchk_irele(sc, ip);
+		if (error)
+			break;
+
+		if (xchk_should_terminate(sc, &error))
+			break;
+	}
+	xchk_iscan_iter_finish(&rr->iscan);
+	if (error)
+		return error;
+
+	/*
+	 * Switch out for a real transaction and lock the RT metadata in
+	 * preparation for building a new tree.
+	 */
+	xchk_trans_cancel(sc);
+	error = xchk_setup_rt(sc);
+	if (error)
+		return error;
+	error = xchk_rtgroup_drain_and_lock(sc, &sc->sr, XCHK_RTGLOCK_ALL);
+	if (error)
+		return error;
+
+	/* Scan for old rtrmap blocks. */
+	for_each_perag(sc->mp, agno, pag) {
+		error = xrep_rtrmap_scan_ag(rr, pag);
+		if (error) {
+			xfs_perag_rele(pag);
+			return error;
+		}
+	}
+
+	return 0;
+}
+
+/* Building the new rtrmap btree. */
+
+/* Retrieve rtrmapbt data for bulk load. */
+STATIC int
+xrep_rtrmap_get_records(
+	struct xfs_btree_cur		*cur,
+	unsigned int			idx,
+	struct xfs_btree_block		*block,
+	unsigned int			nr_wanted,
+	void				*priv)
+{
+	struct xrep_rtrmap_extent	rec;
+	struct xfs_rmap_irec		*irec = &cur->bc_rec.r;
+	struct xrep_rtrmap		*rr = priv;
+	union xfs_btree_rec		*block_rec;
+	unsigned int			loaded;
+	int				error;
+
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		error = xfarray_load_next(rr->rtrmap_records, &rr->array_cur,
+				&rec);
+		if (error)
+			return error;
+
+		irec->rm_startblock = rec.startblock;
+		irec->rm_blockcount = rec.blockcount;
+		irec->rm_owner = rec.owner;
+
+		if (xfs_rmap_irec_offset_unpack(rec.offset, irec) != NULL)
+			return -EFSCORRUPTED;
+
+		error = xrep_rtrmap_check_mapping(rr->sc, irec);
+		if (error)
+			return error;
+
+		block_rec = xfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return loaded;
+}
+
+/* Feed one of the new btree blocks to the bulk loader. */
+STATIC int
+xrep_rtrmap_claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_rtrmap	*rr = priv;
+
+	return xrep_newbt_claim_block(cur, &rr->new_btree, ptr);
+}
+
+/* Figure out how much space we need to create the incore btree root block. */
+STATIC size_t
+xrep_rtrmap_iroot_size(
+	struct xfs_btree_cur	*cur,
+	unsigned int		level,
+	unsigned int		nr_this_level,
+	void			*priv)
+{
+	return xfs_rtrmap_broot_space_calc(cur->bc_mp, level, nr_this_level);
+}
+
+/*
+ * Use the collected rmap information to stage a new rmap btree.  If this is
+ * successful we'll return with the new btree root information logged to the
+ * repair transaction but not yet committed.  This implements section (III)
+ * above.
+ */
+STATIC int
+xrep_rtrmap_build_new_tree(
+	struct xrep_rtrmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	struct xfs_rtgroup	*rtg = sc->sr.rtg;
+	struct xfs_btree_cur	*rmap_cur;
+	uint64_t		nr_records;
+	int			error;
+
+	/*
+	 * Prepare to construct the new btree by reserving disk space for the
+	 * new btree and setting up all the accounting information we'll need
+	 * to root the new btree while it's under construction and before we
+	 * attach it to the realtime rmapbt inode.
+	 */
+	error = xrep_newbt_init_metadir_inode(&rr->new_btree, sc);
+	if (error)
+		return error;
+
+	rr->new_btree.bload.get_records = xrep_rtrmap_get_records;
+	rr->new_btree.bload.claim_block = xrep_rtrmap_claim_block;
+	rr->new_btree.bload.iroot_size = xrep_rtrmap_iroot_size;
+
+	rmap_cur = xfs_rtrmapbt_stage_cursor(sc->mp, rtg, rtg->rtg_rmapip,
+			&rr->new_btree.ifake);
+
+	nr_records = xfarray_length(rr->rtrmap_records);
+
+	/* Compute how many blocks we'll need for the rmaps collected. */
+	error = xfs_btree_bload_compute_geometry(rmap_cur,
+			&rr->new_btree.bload, nr_records);
+	if (error)
+		goto err_cur;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		goto err_cur;
+
+	/*
+	 * Guess how many blocks we're going to need to rebuild an entire
+	 * rtrmapbt from the number of extents we found, and pump up our
+	 * transaction to have sufficient block reservation.  We're allowed
+	 * to exceed quota to repair inconsistent metadata, though this is
+	 * unlikely.
+	 */
+	error = xfs_trans_reserve_more_inode(sc->tp, rtg->rtg_rmapip,
+			rr->new_btree.bload.nr_blocks, 0, true);
+	if (error)
+		goto err_cur;
+
+	/* Reserve the space we'll need for the new btree. */
+	error = xrep_newbt_alloc_blocks(&rr->new_btree,
+			rr->new_btree.bload.nr_blocks);
+	if (error)
+		goto err_cur;
+
+	/* Add all observed rmap records. */
+	rr->new_btree.ifake.if_fork->if_format = XFS_DINODE_FMT_RMAP;
+	rr->array_cur = XFARRAY_CURSOR_INIT;
+	error = xfs_btree_bload(rmap_cur, &rr->new_btree.bload, rr);
+	if (error)
+		goto err_cur;
+
+	/*
+	 * Install the new rtrmap btree in the inode.  After this point the old
+	 * btree is no longer accessible, the new tree is live, and we can
+	 * delete the cursor.
+	 */
+	xfs_rtrmapbt_commit_staged_btree(rmap_cur, sc->tp);
+	xrep_inode_set_nblocks(rr->sc, rr->new_btree.ifake.if_blocks);
+	xfs_btree_del_cursor(rmap_cur, 0);
+
+	/* Dispose of any unused blocks and the accounting information. */
+	error = xrep_newbt_commit(&rr->new_btree);
+	if (error)
+		return error;
+
+	return xrep_roll_trans(sc);
+
+err_cur:
+	xfs_btree_del_cursor(rmap_cur, error);
+	xrep_newbt_cancel(&rr->new_btree);
+	return error;
+}
+
+/* Reaping the old btree. */
+
+/* Reap the old rtrmapbt blocks. */
+STATIC int
+xrep_rtrmap_remove_old_tree(
+	struct xrep_rtrmap	*rr)
+{
+	int			error;
+
+	/*
+	 * Free all the extents that were allocated to the former rtrmapbt and
+	 * aren't cross-linked with something else.
+	 */
+	error = xrep_reap_metadir_fsblocks(rr->sc, &rr->old_rtrmapbt_blocks);
+	if (error)
+		return error;
+
+	/*
+	 * Ensure the proper reservation for the rtrmap inode so that we don't
+	 * fail to expand the new btree.
+	 */
+	return xrep_reset_imeta_reservation(rr->sc);
+}
+
+/* Set up the filesystem scan components. */
+STATIC int
+xrep_rtrmap_setup_scan(
+	struct xrep_rtrmap	*rr)
+{
+	struct xfs_scrub	*sc = rr->sc;
+	char			*descr;
+	int			error;
+
+	xfsb_bitmap_init(&rr->old_rtrmapbt_blocks);
+
+	/* Set up some storage */
+	descr = xchk_xfile_rtgroup_descr(sc, "reverse mapping records");
+	error = xfarray_create(descr, 0, sizeof(struct xrep_rtrmap_extent),
+			&rr->rtrmap_records);
+	kfree(descr);
+	if (error)
+		goto out_bitmap;
+
+	/* Retry iget every tenth of a second for up to 30 seconds. */
+	xchk_iscan_start(sc, 30000, 100, &rr->iscan);
+	return 0;
+
+out_bitmap:
+	xfsb_bitmap_destroy(&rr->old_rtrmapbt_blocks);
+	return error;
+}
+
+/* Tear down scan components. */
+STATIC void
+xrep_rtrmap_teardown(
+	struct xrep_rtrmap	*rr)
+{
+	xchk_iscan_teardown(&rr->iscan);
+	xfarray_destroy(rr->rtrmap_records);
+	xfsb_bitmap_destroy(&rr->old_rtrmapbt_blocks);
+}
+
+/* Repair the realtime rmap btree. */
+int
+xrep_rtrmapbt(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_rtrmap	*rr = sc->buf;
+	int			error;
+
+	/* Functionality is not yet complete. */
+	return xrep_notsupported(sc);
+
+	/* Make sure any problems with the fork are fixed. */
+	error = xrep_metadata_inode_forks(sc);
+	if (error)
+		return error;
+
+	error = xrep_rtrmap_setup_scan(rr);
+	if (error)
+		return error;
+
+	/* Collect rmaps for realtime files. */
+	error = xrep_rtrmap_find_rmaps(rr);
+	if (error)
+		goto out_records;
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/* Rebuild the rtrmap information. */
+	error = xrep_rtrmap_build_new_tree(rr);
+	if (error)
+		goto out_records;
+
+	/* Kill the old tree. */
+	error = xrep_rtrmap_remove_old_tree(rr);
+	if (error)
+		goto out_records;
+
+out_records:
+	xrep_rtrmap_teardown(rr);
+	return error;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 435003e5a1e92..8193ad6702b4d 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -479,7 +479,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_rtrmapbt,
 		.scrub	= xchk_rtrmapbt,
 		.has	= xfs_has_rtrmapbt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_rtrmapbt,
 	},
 };
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index c90324ca86579..95fdb82660dc3 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2314,6 +2314,32 @@ TRACE_EVENT(xrep_calc_ag_resblks_btsize,
 		  __entry->rmapbt_sz,
 		  __entry->refcbt_sz)
 )
+
+#ifdef CONFIG_XFS_RT
+TRACE_EVENT(xrep_calc_rtgroup_resblks_btsize,
+	TP_PROTO(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		 xfs_rgblock_t usedlen, xfs_rgblock_t rmapbt_sz),
+	TP_ARGS(mp, rgno, usedlen, rmapbt_sz),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(xfs_rgblock_t, usedlen)
+		__field(xfs_rgblock_t, rmapbt_sz)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->rgno = rgno;
+		__entry->usedlen = usedlen;
+		__entry->rmapbt_sz = rmapbt_sz;
+	),
+	TP_printk("dev %d:%d rgno 0x%x usedlen %u rmapbt %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rgno,
+		  __entry->usedlen,
+		  __entry->rmapbt_sz)
+);
+#endif /* CONFIG_XFS_RT */
+
 TRACE_EVENT(xrep_reset_counters,
 	TP_PROTO(struct xfs_mount *mp, struct xchk_fscounters *fsc),
 	TP_ARGS(mp, fsc),
@@ -3899,6 +3925,37 @@ TRACE_EVENT(xrep_rgbitmap_load_word,
 		  (__entry->ondisk_word & __entry->word_mask),
 		  __entry->word_mask)
 );
+
+TRACE_EVENT(xrep_rtrmap_found,
+	TP_PROTO(struct xfs_mount *mp, const struct xfs_rmap_irec *rec),
+	TP_ARGS(mp, rec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, rtdev)
+		__field(xfs_rgblock_t, rgbno)
+		__field(xfs_extlen_t, len)
+		__field(uint64_t, owner)
+		__field(uint64_t, offset)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->rtdev = mp->m_rtdev_targp->bt_dev;
+		__entry->rgbno = rec->rm_startblock;
+		__entry->len = rec->rm_blockcount;
+		__entry->owner = rec->rm_owner;
+		__entry->offset = rec->rm_offset;
+		__entry->flags = rec->rm_flags;
+	),
+	TP_printk("dev %d:%d rtdev %d:%d rgbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->rtdev), MINOR(__entry->rtdev),
+		  __entry->rgbno,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset,
+		  __entry->flags)
+);
 #endif /* CONFIG_XFS_RT */
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */


