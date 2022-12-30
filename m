Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A4A659E3D
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 00:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiL3X2k (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 18:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3X22 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:28:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D890013F32
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:28:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A5F4B81DA2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00A7C433EF;
        Fri, 30 Dec 2022 23:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442902;
        bh=HRdg6frqmBuTlpPHMKGPYgW1gg//3RBFsXHhlYMdEIA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rbqPlXMhRlvCFGbJn7ebACdCC1Bm1gkW/+BmIYlv6wvs+3sbhkS2zOIPECizcVUaH
         qKK6hlGccVfTLfh55XXKoYnrTDYiU6WoJgVsrJLsLxE+eskflzeGHcWG9+NVON/HL0
         CyaWNxkhlOEgZmNGW4Qf5KqZjx71op6pI+VDLpec8j4f8zv9muxyR3XLtpG+e8aPBY
         JKX7m9bzxWvwEkbUgonwBJlAiiLw6ebVrT4vduR8rZsOH1wIRgqjUIBZ6i1nDymNZh
         ir4/Vn25N+Btv+mjH2Dk3eqkJrM7DUiDpCcFFw7JvDNEtj0/PKUVIcW648hnOKsL2h
         wacMmSusCy7gg==
Subject: [PATCH 2/5] xfs: repair free space btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:48 -0800
Message-ID: <167243836895.693494.14621979846225889487.stgit@magnolia>
In-Reply-To: <167243836860.693494.7976721071711129282.stgit@magnolia>
References: <167243836860.693494.7976721071711129282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rebuild the free space btrees from the gaps in the rmap btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/libxfs/xfs_ag.h          |    9 
 fs/xfs/libxfs/xfs_ag_resv.c     |    2 
 fs/xfs/libxfs/xfs_alloc.c       |   18 +
 fs/xfs/libxfs/xfs_alloc.h       |    2 
 fs/xfs/libxfs/xfs_alloc_btree.c |   13 +
 fs/xfs/libxfs/xfs_types.h       |    7 
 fs/xfs/scrub/alloc.c            |   14 +
 fs/xfs/scrub/alloc_repair.c     |  912 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h           |   13 +
 fs/xfs/scrub/newbt.c            |   13 +
 fs/xfs/scrub/newbt.h            |    4 
 fs/xfs/scrub/reap.c             |   17 +
 fs/xfs/scrub/repair.c           |   69 +++
 fs/xfs/scrub/repair.h           |   24 +
 fs/xfs/scrub/scrub.c            |   14 -
 fs/xfs/scrub/scrub.h            |    8 
 fs/xfs/scrub/trace.h            |   24 +
 fs/xfs/scrub/xfarray.h          |   22 +
 fs/xfs/xfs_extent_busy.c        |   13 +
 fs/xfs/xfs_extent_busy.h        |    2 
 21 files changed, 1184 insertions(+), 17 deletions(-)
 create mode 100644 fs/xfs/scrub/alloc_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e82d937a4513..b0ba3eec7068 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -177,6 +177,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
+				   alloc_repair.o \
 				   newbt.o \
 				   reap.o \
 				   repair.o \
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 5b4b8658685f..bb87f6677495 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -82,6 +82,15 @@ struct xfs_perag {
 	 */
 	uint16_t	pag_checked;
 	uint16_t	pag_sick;
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+	/*
+	 * Alternate btree heights so that online repair won't trip the write
+	 * verifiers while rebuilding the AG btrees.
+	 */
+	uint8_t		pagf_alt_levels[XFS_BTNUM_AGF];
+#endif
+
 	spinlock_t	pag_state_lock;
 
 	spinlock_t	pagb_lock;	/* lock for pagb_tree */
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 5af123d13a63..2e6128a25635 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -411,6 +411,8 @@ xfs_ag_resv_free_extent(
 		fallthrough;
 	case XFS_AG_RESV_NONE:
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
+		fallthrough;
+	case XFS_AG_RESV_IGNORE:
 		return;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e0ddae7a62ec..62136ecaa071 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -247,14 +247,11 @@ xfs_alloc_btrec_to_irec(
 	irec->ar_blockcount = be32_to_cpu(rec->alloc.ar_blockcount);
 }
 
-/* Simple checks for free space records. */
-xfs_failaddr_t
-xfs_alloc_check_irec(
-	struct xfs_btree_cur		*cur,
+inline xfs_failaddr_t
+xfs_alloc_check_perag_irec(
+	struct xfs_perag		*pag,
 	const struct xfs_alloc_rec_incore *irec)
 {
-	struct xfs_perag		*pag = cur->bc_ag.pag;
-
 	if (irec->ar_blockcount == 0)
 		return __this_address;
 
@@ -265,6 +262,15 @@ xfs_alloc_check_irec(
 	return NULL;
 }
 
+/* Simple checks for free space records. */
+xfs_failaddr_t
+xfs_alloc_check_irec(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_alloc_rec_incore *irec)
+{
+	return xfs_alloc_check_perag_irec(cur->bc_ag.pag, irec);
+}
+
 static inline int
 xfs_alloc_complain_bad_rec(
 	struct xfs_btree_cur		*cur,
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 6d17f8d36a37..5b05c8bfa60a 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -173,6 +173,8 @@ xfs_alloc_get_rec(
 union xfs_btree_rec;
 void xfs_alloc_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_alloc_rec_incore *irec);
+xfs_failaddr_t xfs_alloc_check_perag_irec(struct xfs_perag *pag,
+		const struct xfs_alloc_rec_incore *irec);
 xfs_failaddr_t xfs_alloc_check_irec(struct xfs_btree_cur *cur,
 		const struct xfs_alloc_rec_incore *irec);
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index a91e2a81ba2c..6162223ce18d 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -323,7 +323,18 @@ xfs_allocbt_verify(
 	if (bp->b_ops->magic[0] == cpu_to_be32(XFS_ABTC_MAGIC))
 		btnum = XFS_BTNUM_CNTi;
 	if (pag && pag->pagf_init) {
-		if (level >= pag->pagf_levels[btnum])
+		unsigned int	maxlevel = pag->pagf_levels[btnum];
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+		/*
+		 * Online repair could be rewriting the free space btrees, so
+		 * we'll validate against the larger of either tree while this
+		 * is going on.
+		 */
+		maxlevel = max_t(unsigned int, maxlevel,
+				pag->pagf_alt_levels[btnum]);
+#endif
+		if (level >= maxlevel)
 			return __this_address;
 	} else if (level >= mp->m_alloc_maxlevels)
 		return __this_address;
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 851220021484..c2868e8b6a1e 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -202,6 +202,13 @@ enum xfs_ag_resv_type {
 	XFS_AG_RESV_AGFL,
 	XFS_AG_RESV_METADATA,
 	XFS_AG_RESV_RMAPBT,
+
+	/*
+	 * Don't increase fdblocks when freeing extent.  This is a pony for
+	 * the bnobt repair functions to re-free the free space without
+	 * altering fdblocks.  If you think you need this you're wrong.
+	 */
+	XFS_AG_RESV_IGNORE,
 };
 
 /* Results of scanning a btree keyspace to check occupancy. */
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 94f4b836c48d..e16a48486c6d 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -12,10 +12,11 @@
 #include "xfs_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
+#include "xfs_ag.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
-#include "xfs_ag.h"
+#include "scrub/repair.h"
 
 /*
  * Set us up to scrub free space btrees.
@@ -24,10 +25,19 @@ int
 xchk_setup_ag_allocbt(
 	struct xfs_scrub	*sc)
 {
+	int			error;
+
 	if (xchk_need_fshook_drain(sc))
 		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
 
-	return xchk_setup_ag_btree(sc, false);
+	error = xchk_setup_ag_btree(sc, false);
+	if (error)
+		return error;
+
+	if (xchk_could_repair(sc))
+		return xrep_setup_ag_allocbt(sc);
+
+	return 0;
 }
 
 /* Free space btree scrubber. */
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
new file mode 100644
index 000000000000..1e06ffe26029
--- /dev/null
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -0,0 +1,912 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
+#include "xfs_alloc_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_refcount.h"
+#include "xfs_extent_busy.h"
+#include "xfs_health.h"
+#include "xfs_bmap.h"
+#include "xfs_ialloc.h"
+#include "xfs_ag.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/newbt.h"
+#include "scrub/reap.h"
+
+/*
+ * Free Space Btree Repair
+ * =======================
+ *
+ * The reverse mappings are supposed to record all space usage for the entire
+ * AG.  Therefore, we can recalculate the free extents in an AG by looking for
+ * gaps in the physical extents recorded in the rmapbt.  On a reflink
+ * filesystem this is a little more tricky in that we have to be aware that
+ * the rmap records are allowed to overlap.
+ *
+ * We derive which blocks belonged to the old bnobt/cntbt by recording all the
+ * OWN_AG extents and subtracting out the blocks owned by all other OWN_AG
+ * metadata: the rmapbt blocks visited while iterating the reverse mappings
+ * and the AGFL blocks.
+ *
+ * Once we have both of those pieces, we can reconstruct the bnobt and cntbt
+ * by blowing out the free block state and freeing all the extents that we
+ * found.  This adds the requirement that we can't have any busy extents in
+ * the AG because the busy code cannot handle duplicate records.
+ *
+ * Note that we can only rebuild both free space btrees at the same time
+ * because the regular extent freeing infrastructure loads both btrees at the
+ * same time.
+ *
+ * We use the prefix 'xrep_abt' here because we regenerate both free space
+ * allocation btrees at the same time.
+ */
+
+struct xrep_abt {
+	/* Blocks owned by the rmapbt or the agfl. */
+	struct xagb_bitmap	not_allocbt_blocks;
+
+	/* All OWN_AG blocks. */
+	struct xagb_bitmap	old_allocbt_blocks;
+
+	/*
+	 * New bnobt information.  All btree block reservations are added to
+	 * the reservation list in new_bnobt.
+	 */
+	struct xrep_newbt	new_bnobt;
+
+	/* new cntbt information */
+	struct xrep_newbt	new_cntbt;
+
+	/* Free space extents. */
+	struct xfarray		*free_records;
+
+	struct xfs_scrub	*sc;
+
+	/* Number of non-null records in @free_records. */
+	uint64_t		nr_real_records;
+
+	/* get_records()'s position in the free space record array. */
+	xfarray_idx_t		array_cur;
+
+	/*
+	 * Next block we anticipate seeing in the rmap records.  If the next
+	 * rmap record is greater than next_agbno, we have found unused space.
+	 */
+	xfs_agblock_t		next_agbno;
+
+	/* Number of free blocks in this AG. */
+	xfs_agblock_t		nr_blocks;
+
+	/* Longest free extent we found in the AG. */
+	xfs_agblock_t		longest;
+};
+
+/* Set up to repair AG free space btrees. */
+int
+xrep_setup_ag_allocbt(
+	struct xfs_scrub	*sc)
+{
+	unsigned int		busy_gen;
+
+	/*
+	 * Make sure the busy extent list is clear because we can't put extents
+	 * on there twice.
+	 */
+	busy_gen = READ_ONCE(sc->sa.pag->pagb_gen);
+	if (!xfs_extent_busy_list_empty(sc->sa.pag))
+		xfs_extent_busy_flush(sc->mp, sc->sa.pag, busy_gen);
+
+	return 0;
+}
+
+/* Check for any obvious conflicts in the free extent. */
+STATIC int
+xrep_abt_check_free_ext(
+	struct xfs_scrub	*sc,
+	const struct xfs_alloc_rec_incore *rec)
+{
+	enum xbtree_recpacking	outcome;
+	int			error;
+
+	if (xfs_alloc_check_perag_irec(sc->sa.pag, rec) != NULL)
+		return -EFSCORRUPTED;
+
+	/* Must not be an inode chunk. */
+	error = xfs_ialloc_has_inodes_at_extent(sc->sa.ino_cur,
+			rec->ar_startblock, rec->ar_blockcount, &outcome);
+	if (error)
+		return error;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		return -EFSCORRUPTED;
+
+	/* Must not be shared or CoW staging. */
+	if (sc->sa.refc_cur) {
+		error = xfs_refcount_has_records(sc->sa.refc_cur,
+				XFS_REFC_DOMAIN_SHARED, rec->ar_startblock,
+				rec->ar_blockcount, &outcome);
+		if (error)
+			return error;
+		if (outcome != XBTREE_RECPACKING_EMPTY)
+			return -EFSCORRUPTED;
+
+		error = xfs_refcount_has_records(sc->sa.refc_cur,
+				XFS_REFC_DOMAIN_COW, rec->ar_startblock,
+				rec->ar_blockcount, &outcome);
+		if (error)
+			return error;
+		if (outcome != XBTREE_RECPACKING_EMPTY)
+			return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+/*
+ * Stash a free space record for all the space since the last bno we found
+ * all the way up to @end.
+ */
+static int
+xrep_abt_stash(
+	struct xrep_abt		*ra,
+	xfs_agblock_t		end)
+{
+	struct xfs_alloc_rec_incore arec = {
+		.ar_startblock	= ra->next_agbno,
+		.ar_blockcount	= end - ra->next_agbno,
+	};
+	struct xfs_scrub	*sc = ra->sc;
+	int			error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	error = xrep_abt_check_free_ext(ra->sc, &arec);
+	if (error)
+		return error;
+
+	trace_xrep_abt_found(sc->mp, sc->sa.pag->pag_agno, &arec);
+
+	error = xfarray_append(ra->free_records, &arec);
+	if (error)
+		return error;
+
+	ra->nr_blocks += arec.ar_blockcount;
+	return 0;
+}
+
+/* Record extents that aren't in use from gaps in the rmap records. */
+STATIC int
+xrep_abt_walk_rmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_abt			*ra = priv;
+	int				error;
+
+	/* Record all the OWN_AG blocks... */
+	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
+		error = xagb_bitmap_set(&ra->old_allocbt_blocks,
+				rec->rm_startblock, rec->rm_blockcount);
+		if (error)
+			return error;
+	}
+
+	/* ...and all the rmapbt blocks... */
+	error = xagb_bitmap_set_btcur_path(&ra->not_allocbt_blocks, cur);
+	if (error)
+		return error;
+
+	/* ...and all the free space. */
+	if (rec->rm_startblock > ra->next_agbno) {
+		error = xrep_abt_stash(ra, rec->rm_startblock);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * rmap records can overlap on reflink filesystems, so project
+	 * next_agbno as far out into the AG space as we currently know about.
+	 */
+	ra->next_agbno = max_t(xfs_agblock_t, ra->next_agbno,
+			rec->rm_startblock + rec->rm_blockcount);
+	return 0;
+}
+
+/* Collect an AGFL block for the not-to-release list. */
+static int
+xrep_abt_walk_agfl(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		agbno,
+	void			*priv)
+{
+	struct xrep_abt		*ra = priv;
+
+	return xagb_bitmap_set(&ra->not_allocbt_blocks, agbno, 1);
+}
+
+/*
+ * Compare two free space extents by block number.  We want to sort in order of
+ * increasing block number.
+ */
+static int
+xrep_bnobt_extent_cmp(
+	const void		*a,
+	const void		*b)
+{
+	const struct xfs_alloc_rec_incore *ap = a;
+	const struct xfs_alloc_rec_incore *bp = b;
+
+	if (ap->ar_startblock > bp->ar_startblock)
+		return 1;
+	else if (ap->ar_startblock < bp->ar_startblock)
+		return -1;
+	return 0;
+}
+
+/*
+ * Re-sort the free extents by block number so so that we can put the records
+ * into the bnobt in the correct order.  Make sure the records do not overlap
+ * in physical space.
+ */
+STATIC int
+xrep_bnobt_sort_records(
+	struct xrep_abt			*ra)
+{
+	struct xfs_alloc_rec_incore	arec;
+	xfarray_idx_t			cur = XFARRAY_CURSOR_INIT;
+	xfs_agblock_t			next_agbno = 0;
+	int				error;
+
+	error = xfarray_sort(ra->free_records, xrep_bnobt_extent_cmp, 0);
+	if (error)
+		return error;
+
+	while ((error = xfarray_iter(ra->free_records, &cur, &arec)) == 1) {
+		if (arec.ar_startblock < next_agbno)
+			return -EFSCORRUPTED;
+
+		next_agbno = arec.ar_startblock + arec.ar_blockcount;
+	}
+
+	return error;
+}
+
+/*
+ * Compare two free space extents by length and then block number.  We want
+ * to sort first in order of increasing length and then in order of increasing
+ * block number.
+ */
+static int
+xrep_cntbt_extent_cmp(
+	const void			*a,
+	const void			*b)
+{
+	const struct xfs_alloc_rec_incore *ap = a;
+	const struct xfs_alloc_rec_incore *bp = b;
+
+	if (ap->ar_blockcount > bp->ar_blockcount)
+		return 1;
+	else if (ap->ar_blockcount < bp->ar_blockcount)
+		return -1;
+	return xrep_bnobt_extent_cmp(a, b);
+}
+
+/*
+ * Sort the free extents by length so so that we can put the records into the
+ * cntbt in the correct order.  Don't let userspace kill us if we're resorting
+ * after allocating btree blocks.
+ */
+STATIC int
+xrep_cntbt_sort_records(
+	struct xrep_abt			*ra,
+	bool				is_resort)
+{
+	return xfarray_sort(ra->free_records, xrep_cntbt_extent_cmp,
+			is_resort ? 0 : XFARRAY_SORT_KILLABLE);
+}
+
+/*
+ * Iterate all reverse mappings to find (1) the gaps between rmap records (all
+ * unowned space), (2) the OWN_AG extents (which encompass the free space
+ * btrees, the rmapbt, and the agfl), (3) the rmapbt blocks, and (4) the AGFL
+ * blocks.  The free space is (1) + (2) - (3) - (4).
+ */
+STATIC int
+xrep_abt_find_freespace(
+	struct xrep_abt		*ra)
+{
+	struct xfs_scrub	*sc = ra->sc;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
+	struct xfs_buf		*agfl_bp;
+	xfs_agblock_t		agend;
+	int			error;
+
+	xagb_bitmap_init(&ra->not_allocbt_blocks);
+
+	xrep_ag_btcur_init(sc, &sc->sa);
+
+	/*
+	 * Iterate all the reverse mappings to find gaps in the physical
+	 * mappings, all the OWN_AG blocks, and all the rmapbt extents.
+	 */
+	error = xfs_rmap_query_all(sc->sa.rmap_cur, xrep_abt_walk_rmap, ra);
+	if (error)
+		goto err;
+
+	/* Insert a record for space between the last rmap and EOAG. */
+	agend = be32_to_cpu(agf->agf_length);
+	if (ra->next_agbno < agend) {
+		error = xrep_abt_stash(ra, agend);
+		if (error)
+			goto err;
+	}
+
+	/* Collect all the AGFL blocks. */
+	error = xfs_alloc_read_agfl(sc->sa.pag, sc->tp, &agfl_bp);
+	if (error)
+		goto err;
+
+	error = xfs_agfl_walk(mp, agf, agfl_bp, xrep_abt_walk_agfl, ra);
+	if (error)
+		goto err_agfl;
+
+	/* Compute the old bnobt/cntbt blocks. */
+	error = xagb_bitmap_disunion(&ra->old_allocbt_blocks,
+			&ra->not_allocbt_blocks);
+	if (error)
+		goto err_agfl;
+
+	ra->nr_real_records = xfarray_length(ra->free_records);
+err_agfl:
+	xfs_trans_brelse(sc->tp, agfl_bp);
+err:
+	xchk_ag_btcur_free(&sc->sa);
+	xagb_bitmap_destroy(&ra->not_allocbt_blocks);
+	return error;
+}
+
+/*
+ * We're going to use the observed free space records to reserve blocks for the
+ * new free space btrees, so we play an iterative game where we try to converge
+ * on the number of blocks we need:
+ *
+ * 1. Estimate how many blocks we'll need to store the records.
+ * 2. If the first free record has more blocks than we need, we're done.
+ *    We will have to re-sort the records prior to building the cntbt.
+ * 3. If that record has exactly the number of blocks we need, null out the
+ *    record.  We're done.
+ * 4. Otherwise, we still need more blocks.  Null out the record, subtract its
+ *    length from the number of blocks we need, and go back to step 1.
+ *
+ * Fortunately, we don't have to do any transaction work to play this game, so
+ * we don't have to tear down the staging cursors.
+ */
+STATIC int
+xrep_abt_reserve_space(
+	struct xrep_abt		*ra,
+	struct xfs_btree_cur	*bno_cur,
+	struct xfs_btree_cur	*cnt_cur,
+	bool			*needs_resort)
+{
+	struct xfs_scrub	*sc = ra->sc;
+	xfarray_idx_t		record_nr;
+	unsigned int		allocated = 0;
+	int			error = 0;
+
+	record_nr = xfarray_length(ra->free_records) - 1;
+	do {
+		struct xfs_alloc_rec_incore arec;
+		xfs_fsblock_t		fsbno;
+		uint64_t		required;
+		unsigned int		desired;
+		unsigned int		len;
+
+		/* Compute how many blocks we'll need. */
+		error = xfs_btree_bload_compute_geometry(cnt_cur,
+				&ra->new_cntbt.bload, ra->nr_real_records);
+		if (error)
+			break;
+
+		error = xfs_btree_bload_compute_geometry(bno_cur,
+				&ra->new_bnobt.bload, ra->nr_real_records);
+		if (error)
+			break;
+
+		/* How many btree blocks do we need to store all records? */
+		required = ra->new_bnobt.bload.nr_blocks +
+			   ra->new_cntbt.bload.nr_blocks;
+		ASSERT(required < INT_MAX);
+
+		/* If we've reserved enough blocks, we're done. */
+		if (allocated >= required)
+			break;
+
+		desired = required - allocated;
+
+		/* We need space but there's none left; bye! */
+		if (ra->nr_real_records == 0) {
+			error = -ENOSPC;
+			break;
+		}
+
+		/* Grab the first record from the list. */
+		error = xfarray_load(ra->free_records, record_nr, &arec);
+		if (error)
+			break;
+
+		ASSERT(arec.ar_blockcount <= UINT_MAX);
+		len = min_t(unsigned int, arec.ar_blockcount, desired);
+		fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno,
+				arec.ar_startblock);
+
+		trace_xrep_newbt_alloc_blocks(sc->mp, sc->sa.pag->pag_agno,
+				arec.ar_startblock, len, XFS_RMAP_OWN_AG);
+
+		error = xrep_newbt_add_blocks(&ra->new_bnobt, fsbno, len);
+		if (error)
+			break;
+		allocated += len;
+		ra->nr_blocks -= len;
+
+		if (arec.ar_blockcount > desired) {
+			/*
+			 * Record has more space than we need.  The number of
+			 * free records doesn't change, so shrink the free
+			 * record, inform the caller that the records are no
+			 * longer sorted by length, and exit.
+			 */
+			arec.ar_startblock += desired;
+			arec.ar_blockcount -= desired;
+			error = xfarray_store(ra->free_records, record_nr,
+					&arec);
+			if (error)
+				break;
+
+			*needs_resort = true;
+			return 0;
+		}
+
+		/*
+		 * We're going to use up the entire record, so unset it and
+		 * move on to the next one.  This changes the number of free
+		 * records (but doesn't break the sorting order), so we must
+		 * go around the loop once more to re-run _bload_init.
+		 */
+		error = xfarray_unset(ra->free_records, record_nr);
+		if (error)
+			break;
+		ra->nr_real_records--;
+		record_nr--;
+	} while (1);
+
+	return error;
+}
+
+STATIC int
+xrep_abt_dispose_one(
+	struct xrep_abt		*ra,
+	struct xrep_newbt_resv	*resv)
+{
+	struct xfs_scrub	*sc = ra->sc;
+	struct xfs_perag	*pag = sc->sa.pag;
+	xfs_agblock_t		free_agbno = resv->agbno + resv->used;
+	xfs_extlen_t		free_aglen = resv->len - resv->used;
+	int			error;
+
+	ASSERT(pag == resv->pag);
+
+	/* Add a deferred rmap for each extent we used. */
+	if (resv->used > 0)
+		xfs_rmap_alloc_extent(sc->tp, pag->pag_agno, resv->agbno,
+				resv->used, XFS_RMAP_OWN_AG);
+
+	/*
+	 * For each reserved btree block we didn't use, add it to the free
+	 * space btree.  We didn't touch fdblocks when we reserved them, so
+	 * we don't touch it now.
+	 */
+	if (free_aglen == 0)
+		return 0;
+
+	trace_xrep_newbt_free_blocks(sc->mp, resv->pag->pag_agno, free_agbno,
+			free_aglen, ra->new_bnobt.oinfo.oi_owner);
+
+	error = __xfs_free_extent(sc->tp, resv->pag, free_agbno, free_aglen,
+			&ra->new_bnobt.oinfo, XFS_AG_RESV_IGNORE, true);
+	if (error)
+		return error;
+
+	return xrep_defer_finish(sc);
+}
+
+/*
+ * Deal with all the space we reserved.  Blocks that were allocated for the
+ * free space btrees need to have a (deferred) rmap added for the OWN_AG
+ * allocation, and blocks that didn't get used can be freed via the usual
+ * (deferred) means.
+ */
+STATIC void
+xrep_abt_dispose_reservations(
+	struct xrep_abt		*ra,
+	int			error)
+{
+	struct xrep_newbt_resv	*resv, *n;
+
+	if (error)
+		goto junkit;
+
+	for_each_xrep_newbt_reservation(&ra->new_bnobt, resv, n) {
+		error = xrep_abt_dispose_one(ra, resv);
+		if (error)
+			goto junkit;
+	}
+
+junkit:
+	for_each_xrep_newbt_reservation(&ra->new_bnobt, resv, n) {
+		xfs_perag_put(resv->pag);
+		list_del(&resv->list);
+		kfree(resv);
+	}
+
+	xrep_newbt_cancel(&ra->new_bnobt);
+	xrep_newbt_cancel(&ra->new_cntbt);
+}
+
+/* Retrieve free space data for bulk load. */
+STATIC int
+xrep_abt_get_records(
+	struct xfs_btree_cur		*cur,
+	unsigned int			idx,
+	struct xfs_btree_block		*block,
+	unsigned int			nr_wanted,
+	void				*priv)
+{
+	struct xfs_alloc_rec_incore	*arec = &cur->bc_rec.a;
+	struct xrep_abt			*ra = priv;
+	union xfs_btree_rec		*block_rec;
+	unsigned int			loaded;
+	int				error;
+
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		error = xfarray_load_next(ra->free_records, &ra->array_cur,
+				arec);
+		if (error)
+			return error;
+
+		ra->longest = max(ra->longest, arec->ar_blockcount);
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
+xrep_abt_claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct xrep_abt		*ra = priv;
+
+	return xrep_newbt_claim_block(cur, &ra->new_bnobt, ptr);
+}
+
+/*
+ * Reset the AGF counters to reflect the free space btrees that we just
+ * rebuilt, then reinitialize the per-AG data.
+ */
+STATIC int
+xrep_abt_reset_counters(
+	struct xrep_abt		*ra)
+{
+	struct xfs_scrub	*sc = ra->sc;
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
+	unsigned int		freesp_btreeblks = 0;
+
+	/*
+	 * Compute the contribution to agf_btreeblks for the new free space
+	 * btrees.  This is the computed btree size minus anything we didn't
+	 * use.
+	 */
+	freesp_btreeblks += ra->new_bnobt.bload.nr_blocks - 1;
+	freesp_btreeblks += ra->new_cntbt.bload.nr_blocks - 1;
+
+	freesp_btreeblks -= xrep_newbt_unused_blocks(&ra->new_bnobt);
+	freesp_btreeblks -= xrep_newbt_unused_blocks(&ra->new_cntbt);
+
+	/*
+	 * The AGF header contains extra information related to the free space
+	 * btrees, so we must update those fields here.
+	 */
+	agf->agf_btreeblks = cpu_to_be32(freesp_btreeblks +
+				(be32_to_cpu(agf->agf_rmap_blocks) - 1));
+	agf->agf_freeblks = cpu_to_be32(ra->nr_blocks);
+	agf->agf_longest = cpu_to_be32(ra->longest);
+	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, XFS_AGF_BTREEBLKS |
+						 XFS_AGF_LONGEST |
+						 XFS_AGF_FREEBLKS);
+
+	/*
+	 * After we commit the new btree to disk, it is possible that the
+	 * process to reap the old btree blocks will race with the AIL trying
+	 * to checkpoint the old btree blocks into the filesystem.  If the new
+	 * tree is shorter than the old one, the allocbt write verifier will
+	 * fail and the AIL will shut down the filesystem.
+	 *
+	 * To avoid this, save the old incore btree height values as the alt
+	 * height values before re-initializing the perag info from the updated
+	 * AGF to capture all the new values.
+	 */
+	pag->pagf_alt_levels[XFS_BTNUM_BNOi] = pag->pagf_levels[XFS_BTNUM_BNOi];
+	pag->pagf_alt_levels[XFS_BTNUM_CNTi] = pag->pagf_levels[XFS_BTNUM_CNTi];
+
+	/* Reinitialize with the values we just logged. */
+	return xrep_reinit_pagf(sc);
+}
+
+/*
+ * Use the collected free space information to stage new free space btrees.
+ * If this is successful we'll return with the new btree root
+ * information logged to the repair transaction but not yet committed.
+ */
+STATIC int
+xrep_abt_build_new_trees(
+	struct xrep_abt		*ra)
+{
+	struct xfs_scrub	*sc = ra->sc;
+	struct xfs_btree_cur	*bno_cur;
+	struct xfs_btree_cur	*cnt_cur;
+	struct xfs_perag	*pag = sc->sa.pag;
+	bool			needs_resort = false;
+	int			error;
+
+	/*
+	 * Sort the free extents by length so that we can set up the free space
+	 * btrees in as few extents as possible.  This reduces the amount of
+	 * deferred rmap / free work we have to do at the end.
+	 */
+	error = xrep_cntbt_sort_records(ra, false);
+	if (error)
+		return error;
+
+	/*
+	 * Prepare to construct the new btree by reserving disk space for the
+	 * new btree and setting up all the accounting information we'll need
+	 * to root the new btree while it's under construction and before we
+	 * attach it to the AG header.
+	 */
+	xrep_newbt_init_bare(&ra->new_bnobt, sc);
+	xrep_newbt_init_bare(&ra->new_cntbt, sc);
+
+	ra->new_bnobt.bload.get_records = xrep_abt_get_records;
+	ra->new_cntbt.bload.get_records = xrep_abt_get_records;
+
+	ra->new_bnobt.bload.claim_block = xrep_abt_claim_block;
+	ra->new_cntbt.bload.claim_block = xrep_abt_claim_block;
+
+	/* Allocate cursors for the staged btrees. */
+	bno_cur = xfs_allocbt_stage_cursor(sc->mp, &ra->new_bnobt.afake,
+			pag, XFS_BTNUM_BNO);
+	cnt_cur = xfs_allocbt_stage_cursor(sc->mp, &ra->new_cntbt.afake,
+			pag, XFS_BTNUM_CNT);
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		goto err_cur;
+
+	/* Reserve the space we'll need for the new btrees. */
+	error = xrep_abt_reserve_space(ra, bno_cur, cnt_cur, &needs_resort);
+	if (error)
+		goto err_cur;
+
+	/*
+	 * If we need to re-sort the free extents by length, do so so that we
+	 * can put the records into the cntbt in the correct order.
+	 */
+	if (needs_resort) {
+		error = xrep_cntbt_sort_records(ra, needs_resort);
+		if (error)
+			goto err_cur;
+	}
+
+	/*
+	 * Due to btree slack factors, it's possible for a new btree to be one
+	 * level taller than the old btree.  Update the alternate incore btree
+	 * height so that we don't trip the verifiers when writing the new
+	 * btree blocks to disk.
+	 */
+	pag->pagf_alt_levels[XFS_BTNUM_BNOi] =
+					ra->new_bnobt.bload.btree_height;
+	pag->pagf_alt_levels[XFS_BTNUM_CNTi] =
+					ra->new_cntbt.bload.btree_height;
+
+	/* Load the free space by length tree. */
+	ra->array_cur = XFARRAY_CURSOR_INIT;
+	ra->longest = 0;
+	error = xfs_btree_bload(cnt_cur, &ra->new_cntbt.bload, ra);
+	if (error)
+		goto err_levels;
+
+	error = xrep_bnobt_sort_records(ra);
+	if (error)
+		return error;
+
+	/* Load the free space by block number tree. */
+	ra->array_cur = XFARRAY_CURSOR_INIT;
+	error = xfs_btree_bload(bno_cur, &ra->new_bnobt.bload, ra);
+	if (error)
+		goto err_levels;
+
+	/*
+	 * Install the new btrees in the AG header.  After this point the old
+	 * btrees are no longer accessible and the new trees are live.
+	 */
+	xfs_allocbt_commit_staged_btree(bno_cur, sc->tp, sc->sa.agf_bp);
+	xfs_btree_del_cursor(bno_cur, 0);
+	xfs_allocbt_commit_staged_btree(cnt_cur, sc->tp, sc->sa.agf_bp);
+	xfs_btree_del_cursor(cnt_cur, 0);
+
+	/* Reset the AGF counters now that we've changed the btree shape. */
+	error = xrep_abt_reset_counters(ra);
+	if (error)
+		goto err_newbt;
+
+	/* Dispose of any unused blocks and the accounting information. */
+	xrep_abt_dispose_reservations(ra, error);
+
+	return xrep_roll_ag_trans(sc);
+
+err_levels:
+	pag->pagf_alt_levels[XFS_BTNUM_BNOi] = 0;
+	pag->pagf_alt_levels[XFS_BTNUM_CNTi] = 0;
+err_cur:
+	xfs_btree_del_cursor(cnt_cur, error);
+	xfs_btree_del_cursor(bno_cur, error);
+err_newbt:
+	xrep_abt_dispose_reservations(ra, error);
+	return error;
+}
+
+/*
+ * Now that we've logged the roots of the new btrees, invalidate all of the
+ * old blocks and free them.
+ */
+STATIC int
+xrep_abt_remove_old_trees(
+	struct xrep_abt		*ra)
+{
+	struct xfs_perag	*pag = ra->sc->sa.pag;
+	int			error;
+
+	/* Free the old btree blocks if they're not in use. */
+	error = xrep_reap_agblocks(ra->sc, &ra->old_allocbt_blocks,
+			&XFS_RMAP_OINFO_AG, XFS_AG_RESV_IGNORE);
+	if (error)
+		return error;
+
+	/*
+	 * Now that we've zapped all the old allocbt blocks we can turn off
+	 * the alternate height mechanism.
+	 */
+	pag->pagf_alt_levels[XFS_BTNUM_BNOi] = 0;
+	pag->pagf_alt_levels[XFS_BTNUM_CNTi] = 0;
+	return 0;
+}
+
+/* Repair the freespace btrees for some AG. */
+int
+xrep_allocbt(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_abt		*ra;
+	struct xfs_mount	*mp = sc->mp;
+	int			error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_has_rmapbt(mp))
+		return -EOPNOTSUPP;
+
+	ra = kzalloc(sizeof(struct xrep_abt), XCHK_GFP_FLAGS);
+	if (!ra)
+		return -ENOMEM;
+	ra->sc = sc;
+
+	/* We rebuild both data structures. */
+	sc->sick_mask = XFS_SICK_AG_BNOBT | XFS_SICK_AG_CNTBT;
+
+	/*
+	 * Make sure the busy extent list is clear because we can't put extents
+	 * on there twice.  In theory we cleared this before we started, but
+	 * let's not risk the filesystem.
+	 */
+	if (!xfs_extent_busy_list_empty(sc->sa.pag)) {
+		error = -EDEADLOCK;
+		goto out_ra;
+	}
+
+	/* Set up enough storage to handle maximally fragmented free space. */
+	error = xfarray_create(mp, "free space extents",
+			mp->m_sb.sb_agblocks / 2,
+			sizeof(struct xfs_alloc_rec_incore),
+			&ra->free_records);
+	if (error)
+		goto out_ra;
+
+	/* Collect the free space data and find the old btree blocks. */
+	xagb_bitmap_init(&ra->old_allocbt_blocks);
+	error = xrep_abt_find_freespace(ra);
+	if (error)
+		goto out_bitmap;
+
+	/* Rebuild the free space information. */
+	error = xrep_abt_build_new_trees(ra);
+	if (error)
+		goto out_bitmap;
+
+	/* Kill the old trees. */
+	error = xrep_abt_remove_old_trees(ra);
+
+out_bitmap:
+	xagb_bitmap_destroy(&ra->old_allocbt_blocks);
+	xfarray_destroy(ra->free_records);
+out_ra:
+	kfree(ra);
+	return error;
+}
+
+/* Make sure both btrees are ok after we've rebuilt them. */
+int
+xrep_revalidate_allocbt(
+	struct xfs_scrub	*sc)
+{
+	__u32			old_type = sc->sm->sm_type;
+	int			error;
+
+	/*
+	 * We must update sm_type temporarily so that the tree-to-tree cross
+	 * reference checks will work in the correct direction, and also so
+	 * that tracing will report correctly if there are more errors.
+	 */
+	sc->sm->sm_type = XFS_SCRUB_TYPE_BNOBT;
+	error = xchk_bnobt(sc);
+	if (error)
+		goto out;
+
+	sc->sm->sm_type = XFS_SCRUB_TYPE_CNTBT;
+	error = xchk_cntbt(sc);
+out:
+	sc->sm->sm_type = old_type;
+	return error;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 92578c4aed13..7f2714092514 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -175,8 +175,21 @@ static inline bool xchk_needs_repair(const struct xfs_scrub_metadata *sm)
 			       XFS_SCRUB_OFLAG_XCORRUPT |
 			       XFS_SCRUB_OFLAG_PREEN);
 }
+
+/*
+ * "Should we prepare for a repair?"
+ *
+ * Return true if the caller permits us to repair metadata and we're not
+ * setting up for a post-repair evaluation.
+ */
+static inline bool xchk_could_repair(const struct xfs_scrub *sc)
+{
+	return (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
+		!(sc->flags & XREP_ALREADY_FIXED);
+}
 #else
 # define xchk_needs_repair(sc)		(false)
+# define xchk_could_repair(sc)		(false)
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 507137e7bc24..efa73f676ad4 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -565,3 +565,16 @@ xrep_newbt_claim_block(
 		ptr->s = cpu_to_be32(agbno);
 	return 0;
 }
+
+/* How many reserved blocks are unused? */
+unsigned int
+xrep_newbt_unused_blocks(
+	struct xrep_newbt	*xnr)
+{
+	struct xrep_newbt_resv	*resv;
+	unsigned int		unused = 0;
+
+	list_for_each_entry(resv, &xnr->resv_list, list)
+		unused += resv->len - resv->used;
+	return unused;
+}
diff --git a/fs/xfs/scrub/newbt.h b/fs/xfs/scrub/newbt.h
index a1eda5213b83..96ae0dc3bc41 100644
--- a/fs/xfs/scrub/newbt.h
+++ b/fs/xfs/scrub/newbt.h
@@ -50,6 +50,9 @@ struct xrep_newbt {
 	enum xfs_ag_resv_type	resv;
 };
 
+#define for_each_xrep_newbt_reservation(xnr, resv, n)	\
+	list_for_each_entry_safe((resv), (n), &(xnr)->resv_list, list)
+
 void xrep_newbt_init_bare(struct xrep_newbt *xnr, struct xfs_scrub *sc);
 void xrep_newbt_init_ag(struct xrep_newbt *xnr, struct xfs_scrub *sc,
 		const struct xfs_owner_info *oinfo, xfs_fsblock_t alloc_hint,
@@ -64,5 +67,6 @@ int xrep_newbt_commit(struct xrep_newbt *xnr);
 int xrep_newbt_claim_block(struct xfs_btree_cur *cur, struct xrep_newbt *xnr,
 		union xfs_btree_ptr *ptr);
 int xrep_newbt_relog_autoreap(struct xrep_newbt *xnr);
+unsigned int xrep_newbt_unused_blocks(struct xrep_newbt *xnr);
 
 #endif /* __XFS_SCRUB_NEWBT_H__ */
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 797536e6eba8..3ff4adaf3fe8 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -331,11 +331,23 @@ xreap_agextent(
 		return 0;
 	}
 
-	if (rs->resv == XFS_AG_RESV_AGFL) {
+	switch (rs->resv) {
+	case XFS_AG_RESV_AGFL:
 		ASSERT(*aglenp == 1);
 		error = xreap_put_freelist(sc, agbno);
 		rs->force_roll = true;
-	} else {
+		break;
+	case XFS_AG_RESV_IGNORE:
+		/*
+		 * bnobt/cntbt blocks are counted as free space, so we pass
+		 * XFS_AG_RESV_IGNORE when reaping the old free space btree
+		 * blocks to avoid changing fdblocks.
+		 */
+		error = __xfs_free_extent(sc->tp, sc->sa.pag, agbno, *aglenp,
+				rs->oinfo, rs->resv, true);
+		rs->force_roll = true;
+		break;
+	default:
 		/*
 		 * Use deferred frees to get rid of the old btree blocks to try
 		 * to minimize the window in which we could crash and lose the
@@ -343,6 +355,7 @@ xreap_agextent(
 		 */
 		__xfs_free_extent_later(sc->tp, fsbno, *aglenp, rs->oinfo, true);
 		rs->deferred++;
+		break;
 	}
 
 	return error;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index b4117ff221aa..964b48fffc58 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -735,3 +735,72 @@ xrep_ino_dqattach(
 
 	return error;
 }
+
+/* Initialize all the btree cursors for an AG repair. */
+void
+xrep_ag_btcur_init(
+	struct xfs_scrub	*sc,
+	struct xchk_ag		*sa)
+{
+	struct xfs_mount	*mp = sc->mp;
+
+	/* Set up a bnobt cursor for cross-referencing. */
+	if (sc->sm->sm_type != XFS_SCRUB_TYPE_BNOBT &&
+	    sc->sm->sm_type != XFS_SCRUB_TYPE_CNTBT) {
+		sa->bno_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
+				sc->sa.pag, XFS_BTNUM_BNO);
+		sa->cnt_cur = xfs_allocbt_init_cursor(mp, sc->tp, sa->agf_bp,
+				sc->sa.pag, XFS_BTNUM_CNT);
+	}
+
+	/* Set up a inobt cursor for cross-referencing. */
+	if (sc->sm->sm_type != XFS_SCRUB_TYPE_INOBT &&
+	    sc->sm->sm_type != XFS_SCRUB_TYPE_FINOBT) {
+		sa->ino_cur = xfs_inobt_init_cursor(mp, sc->tp, sa->agi_bp,
+				sc->sa.pag, XFS_BTNUM_INO);
+		if (xfs_has_finobt(mp))
+			sa->fino_cur = xfs_inobt_init_cursor(mp, sc->tp,
+					sa->agi_bp, sc->sa.pag, XFS_BTNUM_FINO);
+	}
+
+	/* Set up a rmapbt cursor for cross-referencing. */
+	if (sc->sm->sm_type != XFS_SCRUB_TYPE_RMAPBT &&
+	    xfs_has_rmapbt(mp))
+		sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, sa->agf_bp,
+				sc->sa.pag);
+
+	/* Set up a refcountbt cursor for cross-referencing. */
+	if (sc->sm->sm_type != XFS_SCRUB_TYPE_REFCNTBT &&
+	    xfs_has_reflink(mp))
+		sa->refc_cur = xfs_refcountbt_init_cursor(mp, sc->tp,
+				sa->agf_bp, sc->sa.pag);
+}
+
+/*
+ * Reinitialize the in-core AG state after a repair by rereading the AGF
+ * buffer.  We had better get the same AGF buffer as the one that's attached
+ * to the scrub context.
+ */
+int
+xrep_reinit_pagf(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_buf		*bp;
+	int			error;
+
+	ASSERT(pag);
+	ASSERT(pag->pagf_init);
+
+	pag->pagf_init = 0;
+	error = xfs_alloc_read_agf(pag, sc->tp, 0, &bp);
+	if (error)
+		return error;
+
+	if (bp != sc->sa.agf_bp) {
+		ASSERT(bp == sc->sa.agf_bp);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 3179746a063e..71f2423b6de7 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -51,6 +51,15 @@ int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
 void xrep_force_quotacheck(struct xfs_scrub *sc, xfs_dqtype_t type);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
 
+/* Repair setup functions */
+int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
+
+void xrep_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
+
+/* Metadata revalidators */
+
+int xrep_revalidate_allocbt(struct xfs_scrub *sc);
+
 /* Metadata repairers */
 
 int xrep_probe(struct xfs_scrub *sc);
@@ -58,6 +67,9 @@ int xrep_superblock(struct xfs_scrub *sc);
 int xrep_agf(struct xfs_scrub *sc);
 int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
+int xrep_allocbt(struct xfs_scrub *sc);
+
+int xrep_reinit_pagf(struct xfs_scrub *sc);
 
 #else
 
@@ -77,11 +89,23 @@ xrep_calc_ag_resblks(
 	return 0;
 }
 
+/* repair setup functions for no-repair */
+static inline int
+xrep_setup_nothing(
+	struct xfs_scrub	*sc)
+{
+	return 0;
+}
+#define xrep_setup_ag_allocbt		xrep_setup_nothing
+
+#define xrep_revalidate_allocbt		(NULL)
+
 #define xrep_probe			xrep_notsupported
 #define xrep_superblock			xrep_notsupported
 #define xrep_agf			xrep_notsupported
 #define xrep_agfl			xrep_notsupported
 #define xrep_agi			xrep_notsupported
+#define xrep_allocbt			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 60975d050b82..6e52aa7a14b0 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -240,13 +240,15 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_allocbt,
 		.scrub	= xchk_bnobt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_allocbt,
+		.repair_eval = xrep_revalidate_allocbt,
 	},
 	[XFS_SCRUB_TYPE_CNTBT] = {	/* cntbt */
 		.type	= ST_PERAG,
 		.setup	= xchk_setup_ag_allocbt,
 		.scrub	= xchk_cntbt,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_allocbt,
+		.repair_eval = xrep_revalidate_allocbt,
 	},
 	[XFS_SCRUB_TYPE_INOBT] = {	/* inobt */
 		.type	= ST_PERAG,
@@ -527,7 +529,10 @@ xfs_scrub_metadata(
 		goto out_teardown;
 
 	/* Scrub for errors. */
-	error = sc->ops->scrub(sc);
+	if ((sc->flags & XREP_ALREADY_FIXED) && sc->ops->repair_eval != NULL)
+		error = sc->ops->repair_eval(sc);
+	else
+		error = sc->ops->scrub(sc);
 	if (error == -EDEADLOCK && !(sc->flags & XCHK_TRY_HARDER))
 		goto try_harder;
 	if (error == -ECHRNG && !(sc->flags & XCHK_NEED_DRAIN))
@@ -537,8 +542,7 @@ xfs_scrub_metadata(
 
 	xchk_update_health(sc);
 
-	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
-	    !(sc->flags & XREP_ALREADY_FIXED)) {
+	if (xchk_could_repair(sc)) {
 		bool needs_fix = xchk_needs_repair(sc->sm);
 
 		/* Userspace asked us to rebuild the structure regardless. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 83ad1662d802..c21a8d732530 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -35,6 +35,14 @@ struct xchk_meta_ops {
 	/* Repair or optimize the metadata. */
 	int		(*repair)(struct xfs_scrub *);
 
+	/*
+	 * Re-scrub the metadata we repaired, in case there's extra work that
+	 * we need to do to check our repair work.  If this is NULL, we'll use
+	 * the ->scrub function pointer, assuming that the regular scrub is
+	 * sufficient.
+	 */
+	int		(*repair_eval)(struct xfs_scrub *sc);
+
 	/* Decide if we even have this piece of metadata. */
 	bool		(*has)(struct xfs_mount *);
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 788a02aee689..d78d28d7c12b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1126,11 +1126,33 @@ DEFINE_EVENT(xrep_rmap_class, name, \
 		 xfs_agblock_t agbno, xfs_extlen_t len, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
-DEFINE_REPAIR_RMAP_EVENT(xrep_alloc_extent_fn);
 DEFINE_REPAIR_RMAP_EVENT(xrep_ialloc_extent_fn);
 DEFINE_REPAIR_RMAP_EVENT(xrep_rmap_extent_fn);
 DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_extent_fn);
 
+TRACE_EVENT(xrep_abt_found,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 const struct xfs_alloc_rec_incore *rec),
+	TP_ARGS(mp, agno, rec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, startblock)
+		__field(xfs_extlen_t, blockcount)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->startblock = rec->ar_startblock;
+		__entry->blockcount = rec->ar_blockcount;
+	),
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->startblock,
+		  __entry->blockcount)
+)
+
 TRACE_EVENT(xrep_refcount_extent_fn,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 struct xfs_refcount_irec *irec),
diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index 69f0c922c98a..95684e0c572e 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -55,6 +55,28 @@ static inline int xfarray_append(struct xfarray *array, const void *ptr)
 uint64_t xfarray_length(struct xfarray *array);
 int xfarray_load_next(struct xfarray *array, xfarray_idx_t *idx, void *rec);
 
+/*
+ * Iterate the non-null elements in a sparse xfarray.  Callers should
+ * initialize *idx to XFARRAY_CURSOR_INIT before the first call; on return, it
+ * will be set to one more than the index of the record that was retrieved.
+ * Returns 1 if a record was retrieved, 0 if there weren't any more records, or
+ * a negative errno.
+ */
+static inline int
+xfarray_iter(
+	struct xfarray	*array,
+	xfarray_idx_t	*idx,
+	void		*rec)
+{
+	int ret = xfarray_load_next(array, idx, rec);
+
+	if (ret == -ENODATA)
+		return 0;
+	if (ret == 0)
+		return 1;
+	return ret;
+}
+
 /* Declarations for xfile array sort functionality. */
 
 typedef cmp_func_t xfarray_cmp_fn;
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index ad22a003f959..ea384d031804 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -628,3 +628,16 @@ xfs_extent_busy_ag_cmp(
 		diff = b1->bno - b2->bno;
 	return diff;
 }
+
+/* Are there any busy extents in this AG? */
+bool
+xfs_extent_busy_list_empty(
+	struct xfs_perag	*pag)
+{
+	bool			res;
+
+	spin_lock(&pag->pagb_lock);
+	res = RB_EMPTY_ROOT(&pag->pagb_tree);
+	spin_unlock(&pag->pagb_lock);
+	return res;
+}
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 4a118131059f..19828c9854d1 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -67,4 +67,6 @@ static inline void xfs_extent_busy_sort(struct list_head *list)
 	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
 }
 
+bool xfs_extent_busy_list_empty(struct xfs_perag *pag);
+
 #endif /* __XFS_EXTENT_BUSY_H__ */

