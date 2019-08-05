Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 692B980FBE
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Aug 2019 02:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfHEAf1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 4 Aug 2019 20:35:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47994 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfHEAf0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:35:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750OKD8023915
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=5pl6PVB3b+QhaHa/s/p2LjtBYqRNPPTs1vnunBG9ouo=;
 b=4+f3VMuCNBNgRCOPo3NobsEJLgYe8Ddvd3hMn0dYKBv2VSomxG1fvK5UnP+bsaRwAZIG
 pTc/yNGe2gi6PLFnuH+r2rCBWAl0mMgXs5OaJxcyBV+3JYGKG1IFRsrFdQAUg/YOO2Ei
 fn27ihYgL9KQCrfSou9EuCcgyDwEu4/XOzHF1j5SKTDgSJUGNTuEbCDzC7+R1Z3x4o26
 KgKUDXd4LPDAwWoJu4JnCVlA6BEUMmMcxuT9gbvsWsZmMXknW3UbRRupfzO/GW7xPImA
 M0w9KZeBW1AUBg7zHNvdSqSULV7Rd4sgWQ2qSHyWh+nS6u1A9PVKYaUox/klloJRStsV Aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u51ptmbab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:35:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750N0co195600
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u51kktspk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:35:23 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x750ZMZV012708
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:35:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 04 Aug 2019 17:35:22 -0700
Subject: [PATCH 06/18] xfs: repair refcount btrees
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 04 Aug 2019 17:35:21 -0700
Message-ID: <156496532125.804304.12613306634706417006.stgit@magnolia>
In-Reply-To: <156496528310.804304.8105015456378794397.stgit@magnolia>
References: <156496528310.804304.8105015456378794397.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9339 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9339 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Reconstruct the refcount data from the rmap btree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/scrub/refcount_repair.c |  567 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h          |    2 
 fs/xfs/scrub/scrub.c           |    2 
 fs/xfs/scrub/trace.h           |   11 -
 5 files changed, 577 insertions(+), 6 deletions(-)
 create mode 100644 fs/xfs/scrub/refcount_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 3b7fdccf2818..4ac6256fe7c3 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -164,6 +164,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   array.o \
 				   bitmap.o \
 				   ialloc_repair.o \
+				   refcount_repair.o \
 				   repair.o \
 				   )
 endif
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
new file mode 100644
index 000000000000..cbcfb96fd2e0
--- /dev/null
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -0,0 +1,567 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_error.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/array.h"
+
+/*
+ * Rebuilding the Reference Count Btree
+ * ====================================
+ *
+ * This algorithm is "borrowed" from xfs_repair.  Imagine the rmap
+ * entries as rectangles representing extents of physical blocks, and
+ * that the rectangles can be laid down to allow them to overlap each
+ * other; then we know that we must emit a refcnt btree entry wherever
+ * the amount of overlap changes, i.e. the emission stimulus is
+ * level-triggered:
+ *
+ *                 -    ---
+ *       --      ----- ----   ---        ------
+ * --   ----     ----------- ----     ---------
+ * -------------------------------- -----------
+ * ^ ^  ^^ ^^    ^ ^^ ^^^  ^^^^  ^ ^^ ^  ^     ^
+ * 2 1  23 21    3 43 234  2123  1 01 2  3     0
+ *
+ * For our purposes, a rmap is a tuple (startblock, len, fileoff, owner).
+ *
+ * Note that in the actual refcnt btree we don't store the refcount < 2
+ * cases because the bnobt tells us which blocks are free; single-use
+ * blocks aren't recorded in the bnobt or the refcntbt.  If the rmapbt
+ * supports storing multiple entries covering a given block we could
+ * theoretically dispense with the refcntbt and simply count rmaps, but
+ * that's inefficient in the (hot) write path, so we'll take the cost of
+ * the extra tree to save time.  Also there's no guarantee that rmap
+ * will be enabled.
+ *
+ * Given an array of rmaps sorted by physical block number, a starting
+ * physical block (sp), a bag to hold rmaps that cover sp, and the next
+ * physical block where the level changes (np), we can reconstruct the
+ * refcount btree as follows:
+ *
+ * While there are still unprocessed rmaps in the array,
+ *  - Set sp to the physical block (pblk) of the next unprocessed rmap.
+ *  - Add to the bag all rmaps in the array where startblock == sp.
+ *  - Set np to the physical block where the bag size will change.  This
+ *    is the minimum of (the pblk of the next unprocessed rmap) and
+ *    (startblock + len of each rmap in the bag).
+ *  - Record the bag size as old_bag_size.
+ *
+ *  - While the bag isn't empty,
+ *     - Remove from the bag all rmaps where startblock + len == np.
+ *     - Add to the bag all rmaps in the array where startblock == np.
+ *     - If the bag size isn't old_bag_size, store the refcount entry
+ *       (sp, np - sp, bag_size) in the refcnt btree.
+ *     - If the bag is empty, break out of the inner loop.
+ *     - Set old_bag_size to the bag size
+ *     - Set sp = np.
+ *     - Set np to the physical block where the bag size will change.
+ *       This is the minimum of (the pblk of the next unprocessed rmap)
+ *       and (startblock + len of each rmap in the bag).
+ *
+ * Like all the other repairers, we make a list of all the refcount
+ * records we need, then reinitialize the refcount btree root and
+ * insert all the records.
+ */
+
+/* The only parts of the rmap that we care about for computing refcounts. */
+struct xrep_refc_rmap {
+	xfs_agblock_t		startblock;
+	xfs_extlen_t		blockcount;
+} __packed;
+
+/* Smallest possible representation of a refcount extent. */
+struct xrep_refc_extent {
+	xfs_agblock_t		startblock;
+	xfs_extlen_t		blockcount;
+	xfs_nlink_t		refcount;
+} __packed;
+
+struct xrep_refc {
+	struct xfbma		*rmap_bag; /* rmaps we're tracking */
+	struct xfbma		*refcount_records;	/* refcount extents */
+	struct xfs_bitmap	*btlist;   /* old refcountbt blocks */
+	struct xfs_scrub	*sc;
+	xfs_extlen_t		btblocks;  /* # of refcountbt blocks */
+};
+
+/* Grab the next (abbreviated) rmap record from the rmapbt. */
+STATIC int
+xrep_refc_next_rrm(
+	struct xfs_btree_cur	*cur,
+	struct xrep_refc	*rr,
+	struct xrep_refc_rmap	*rrm,
+	bool			*have_rec)
+{
+	struct xfs_rmap_irec	rmap;
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_fsblock_t		fsbno;
+	int			have_gt;
+	int			error = 0;
+
+	*have_rec = false;
+	/*
+	 * Loop through the remaining rmaps.  Remember CoW staging
+	 * extents and the refcountbt blocks from the old tree for later
+	 * disposal.  We can only share written data fork extents, so
+	 * keep looping until we find an rmap for one.
+	 */
+	do {
+		if (xchk_should_terminate(rr->sc, &error))
+			goto out_error;
+
+		error = xfs_btree_increment(cur, 0, &have_gt);
+		if (error)
+			goto out_error;
+		if (!have_gt)
+			return 0;
+
+		error = xfs_rmap_get_rec(cur, &rmap, &have_gt);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 1, out_error);
+
+		if (rmap.rm_owner == XFS_RMAP_OWN_COW) {
+			struct xrep_refc_extent	ext = {
+				.startblock	= rmap.rm_startblock +
+					XFS_REFC_COW_START,
+				.blockcount	= rmap.rm_blockcount,
+				.refcount	= 1,
+			};
+
+			/* Pass CoW staging extents right through. */
+			error = xfbma_append(rr->refcount_records, &ext);
+			if (error)
+				goto out_error;
+		} else if (rmap.rm_owner == XFS_RMAP_OWN_REFC) {
+			/* refcountbt block, dump it when we're done. */
+			rr->btblocks += rmap.rm_blockcount;
+			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
+					cur->bc_private.a.agno,
+					rmap.rm_startblock);
+			error = xfs_bitmap_set(rr->btlist, fsbno,
+					rmap.rm_blockcount);
+			if (error)
+				goto out_error;
+		}
+	} while (XFS_RMAP_NON_INODE_OWNER(rmap.rm_owner) ||
+		 xfs_internal_inum(mp, rmap.rm_owner) ||
+		 (rmap.rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+				   XFS_RMAP_UNWRITTEN)));
+
+	rrm->startblock = rmap.rm_startblock;
+	rrm->blockcount = rmap.rm_blockcount;
+	*have_rec = true;
+	return 0;
+
+out_error:
+	return error;
+}
+
+/* Compare two btree extents. */
+static int
+xrep_refc_extent_cmp(
+	const void			*a,
+	const void			*b)
+{
+	const struct xrep_refc_extent	*ap = a;
+	const struct xrep_refc_extent	*bp = b;
+
+	if (ap->startblock > bp->startblock)
+		return 1;
+	else if (ap->startblock < bp->startblock)
+		return -1;
+	return 0;
+}
+
+/* Record a reference count extent. */
+STATIC int
+xrep_refc_remember(
+	struct xfs_scrub		*sc,
+	struct xrep_refc		*rr,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len,
+	xfs_nlink_t			refcount)
+{
+	struct xrep_refc_extent		rre = {
+		.startblock	= agbno,
+		.blockcount	= len,
+		.refcount	= refcount,
+	};
+
+	trace_xrep_refcount_extent_fn(sc->mp, sc->sa.agno, agbno, len,
+			refcount);
+
+	return xfbma_append(rr->refcount_records, &rre);
+}
+
+#define RRM_NEXT(r)	((r).startblock + (r).blockcount)
+/*
+ * Find the next block where the refcount changes, given the next rmap we
+ * looked at and the ones we're already tracking.
+ */
+static inline xfs_agblock_t
+xrep_refc_next_edge(
+	struct xfbma		*rmap_bag,
+	struct xrep_refc_rmap	*next_rrm,
+	bool			next_valid)
+{
+	struct xrep_refc_rmap	rrm;
+	uint64_t		i;
+	xfs_agblock_t		nbno;
+
+	nbno = next_valid ? next_rrm->startblock : NULLAGBLOCK;
+	foreach_xfbma_item(rmap_bag, i, rrm)
+		nbno = min_t(xfs_agblock_t, nbno, RRM_NEXT(rrm));
+	return nbno;
+}
+
+/* Iterate all the rmap records to generate reference count data. */
+STATIC int
+xrep_refc_generate_refcounts(
+	struct xfs_scrub	*sc,
+	struct xrep_refc	*rr)
+{
+	struct xrep_refc_rmap	rrm;
+	struct xfs_btree_cur	*cur;
+	xfs_agblock_t		sbno;
+	xfs_agblock_t		cbno;
+	xfs_agblock_t		nbno;
+	size_t			old_stack_sz;
+	size_t			stack_sz = 0;
+	bool			have;
+	int			have_gt;
+	int			error;
+
+	/* Start the rmapbt cursor to the left of all records. */
+	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.agno);
+	error = xfs_rmap_lookup_le(cur, 0, 0, 0, 0, 0, &have_gt);
+	if (error)
+		goto out;
+	ASSERT(have_gt == 0);
+
+	/* Process reverse mappings into refcount data. */
+	while (xfs_btree_has_more_records(cur)) {
+		/* Push all rmaps with pblk == sbno onto the stack */
+		error = xrep_refc_next_rrm(cur, rr, &rrm, &have);
+		if (error)
+			goto out;
+		if (!have)
+			break;
+		sbno = cbno = rrm.startblock;
+		while (have && rrm.startblock == sbno) {
+			error = xfbma_insert_anywhere(rr->rmap_bag, &rrm);
+			if (error)
+				goto out;
+			stack_sz++;
+			error = xrep_refc_next_rrm(cur, rr, &rrm, &have);
+			if (error)
+				goto out;
+		}
+		error = xfs_btree_decrement(cur, 0, &have_gt);
+		if (error)
+			goto out;
+		XFS_WANT_CORRUPTED_GOTO(sc->mp, have_gt, out);
+
+		/* Set nbno to the bno of the next refcount change */
+		nbno = xrep_refc_next_edge(rr->rmap_bag, &rrm, have);
+		if (nbno == NULLAGBLOCK) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
+
+		ASSERT(nbno > sbno);
+		old_stack_sz = stack_sz;
+
+		/* While stack isn't empty... */
+		while (stack_sz) {
+			uint64_t	i;
+
+			/* Pop all rmaps that end at nbno */
+			foreach_xfbma_item(rr->rmap_bag, i, rrm) {
+				if (RRM_NEXT(rrm) != nbno)
+					continue;
+				error = xfbma_nullify(rr->rmap_bag, i);
+				if (error)
+					goto out;
+				stack_sz--;
+			}
+
+			/* Push array items that start at nbno */
+			error = xrep_refc_next_rrm(cur, rr, &rrm, &have);
+			if (error)
+				goto out;
+			while (have && rrm.startblock == nbno) {
+				error = xfbma_insert_anywhere(rr->rmap_bag,
+						&rrm);
+				if (error)
+					goto out;
+				stack_sz++;
+				error = xrep_refc_next_rrm(cur, rr, &rrm,
+						&have);
+				if (error)
+					goto out;
+			}
+			error = xfs_btree_decrement(cur, 0, &have_gt);
+			if (error)
+				goto out;
+			XFS_WANT_CORRUPTED_GOTO(sc->mp, have_gt, out);
+
+			/* Emit refcount if necessary */
+			ASSERT(nbno > cbno);
+			if (stack_sz != old_stack_sz) {
+				if (old_stack_sz > 1) {
+					error = xrep_refc_remember(sc, rr, cbno,
+							nbno - cbno,
+							old_stack_sz);
+					if (error)
+						goto out;
+				}
+				cbno = nbno;
+			}
+
+			/* Stack empty, go find the next rmap */
+			if (stack_sz == 0)
+				break;
+			old_stack_sz = stack_sz;
+			sbno = nbno;
+
+			/* Set nbno to the bno of the next refcount change */
+			nbno = xrep_refc_next_edge(rr->rmap_bag, &rrm, have);
+			if (nbno == NULLAGBLOCK) {
+				error = -EFSCORRUPTED;
+				goto out;
+			}
+
+			ASSERT(nbno > sbno);
+		}
+	}
+
+	ASSERT(stack_sz == 0);
+out:
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
+#undef RRM_NEXT
+
+/*
+ * Generate all the reference counts for this AG and a list of the old
+ * refcount btree blocks.  Figure out if we have enough free space to
+ * reconstruct the inode btrees.  The caller must clean up the lists if
+ * anything goes wrong.
+ */
+STATIC int
+xrep_refc_find_refcounts(
+	struct xfs_scrub	*sc,
+	struct xfbma		*refcount_records,
+	struct xfs_bitmap	*old_refcountbt_blocks)
+{
+	struct xrep_refc	rr = {
+		.sc			= sc,
+		.refcount_records	= refcount_records,
+		.btlist			= old_refcountbt_blocks,
+	};
+	struct xfs_mount	*mp = sc->mp;
+	xfs_extlen_t		blocks;
+	int			error;
+
+	/* Set up some storage */
+	rr.rmap_bag = xfbma_init(sizeof(struct xrep_refc_rmap));
+	if (IS_ERR(rr.rmap_bag))
+		return PTR_ERR(rr.rmap_bag);
+
+	/* Generate all the refcount records. */
+	error = xrep_refc_generate_refcounts(sc, &rr);
+	if (error)
+		goto out;
+
+	/* Do we actually have enough space to do this? */
+	blocks = xfs_refcountbt_calc_size(mp, xfbma_length(refcount_records));
+	if (!xrep_ag_has_space(sc->sa.pag, blocks, XFS_AG_RESV_METADATA)) {
+		error = -ENOSPC;
+		goto out;
+	}
+
+out:
+	xfbma_destroy(rr.rmap_bag);
+	return error;
+}
+
+/* Initialize new refcountbt root and implant it into the AGF. */
+STATIC int
+xrep_refc_reset_btree(
+	struct xfs_scrub	*sc,
+	int			*log_flags)
+{
+	struct xfs_buf		*bp;
+	struct xfs_agf		*agf;
+	xfs_fsblock_t		btfsb;
+	int			error;
+
+	agf = XFS_BUF_TO_AGF(sc->sa.agf_bp);
+
+	/* Initialize a new refcountbt root. */
+	error = xrep_alloc_ag_block(sc, &XFS_RMAP_OINFO_REFC, &btfsb,
+			XFS_AG_RESV_METADATA);
+	if (error)
+		return error;
+	error = xrep_init_btblock(sc, btfsb, &bp, XFS_BTNUM_REFC,
+			&xfs_refcountbt_buf_ops);
+	if (error)
+		return error;
+	agf->agf_refcount_root = cpu_to_be32(XFS_FSB_TO_AGBNO(sc->mp, btfsb));
+	agf->agf_refcount_level = cpu_to_be32(1);
+	agf->agf_refcount_blocks = cpu_to_be32(1);
+	*log_flags |= XFS_AGF_REFCOUNT_BLOCKS | XFS_AGF_REFCOUNT_ROOT |
+		      XFS_AGF_REFCOUNT_LEVEL;
+
+	return 0;
+}
+
+/* Insert a single record into the refcount btree. */
+STATIC int
+xrep_refc_insert_rec(
+	const void			*item,
+	void				*priv)
+{
+	const struct xrep_refc_extent	*rre = item;
+	struct xfs_refcount_irec	refc = {
+		.rc_startblock	= rre->startblock,
+		.rc_blockcount	= rre->blockcount,
+		.rc_refcount	= rre->refcount,
+	};
+	struct xfs_scrub		*sc = priv;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_btree_cur		*cur;
+	int				have_gt;
+	int				error;
+
+	/* Insert into the refcountbt. */
+	cur = xfs_refcountbt_init_cursor(mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.agno);
+	error = xfs_refcount_lookup_eq(cur, rre->startblock, &have_gt);
+	if (error)
+		goto out;
+	XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 0, out);
+	error = xfs_refcount_insert(cur, &refc, &have_gt);
+	if (error)
+		goto out;
+	XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 1, out);
+	xfs_btree_del_cursor(cur, error);
+	return xrep_roll_ag_trans(sc);
+out:
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
+
+/* Build new refcount btree and dispose of the old one. */
+STATIC int
+xrep_refc_rebuild_tree(
+	struct xfs_scrub	*sc,
+	struct xfbma		*refcount_records,
+	struct xfs_bitmap	*old_refcountbt_blocks)
+{
+	int			error;
+
+	/*
+	 * Sort the refcount extents by startblock to avoid btree splits when
+	 * we rebuild the refcount btree.
+	 */
+	error = xfbma_sort(refcount_records, xrep_refc_extent_cmp);
+	if (error)
+		return error;
+
+	/* Free the old refcountbt blocks if they're not in use. */
+	error = xrep_reap_extents(sc, old_refcountbt_blocks,
+			&XFS_RMAP_OINFO_REFC, XFS_AG_RESV_METADATA);
+	if (error)
+		return error;
+
+	/* Add all records. */
+	return xfbma_iter_del(refcount_records, xrep_refc_insert_rec, sc);
+}
+
+/* Rebuild the refcount btree. */
+int
+xrep_refcountbt(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_bitmap	old_refcountbt_blocks;
+	struct xfbma		*refcount_records;
+	struct xfs_mount	*mp = sc->mp;
+	int			log_flags = 0;
+	int			error;
+
+	/* We require the rmapbt to rebuild anything. */
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return -EOPNOTSUPP;
+
+	xchk_perag_get(sc->mp, &sc->sa);
+
+	/* Set up some storage */
+	refcount_records = xfbma_init(sizeof(struct xrep_refc_extent));
+	if (IS_ERR(refcount_records))
+		return PTR_ERR(refcount_records);
+
+	/* Collect all reference counts. */
+	xfs_bitmap_init(&old_refcountbt_blocks);
+	error = xrep_refc_find_refcounts(sc, refcount_records,
+			&old_refcountbt_blocks);
+	if (error)
+		goto out;
+
+	/*
+	 * Blow out the old refcount btrees.  This is the point at which
+	 * we are no longer able to bail out gracefully.
+	 */
+	error = xrep_refc_reset_btree(sc, &log_flags);
+	if (error)
+		goto out;
+	xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, log_flags);
+
+	/* Invalidate all the inobt/finobt blocks in btlist. */
+	error = xrep_invalidate_blocks(sc, &old_refcountbt_blocks);
+	if (error)
+		goto out;
+	error = xrep_roll_ag_trans(sc);
+	if (error)
+		goto out;
+
+	/* Now rebuild the refcount information. */
+	error = xrep_refc_rebuild_tree(sc, refcount_records,
+			&old_refcountbt_blocks);
+	if (error)
+		goto out;
+	sc->flags |= XREP_RESET_PERAG_RESV;
+out:
+	xfs_bitmap_destroy(&old_refcountbt_blocks);
+	xfbma_destroy(refcount_records);
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 21472fbf11d5..f952d6739700 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -67,6 +67,7 @@ int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
 int xrep_allocbt(struct xfs_scrub *sc);
 int xrep_iallocbt(struct xfs_scrub *sc);
+int xrep_refcountbt(struct xfs_scrub *sc);
 
 #else
 
@@ -108,6 +109,7 @@ xrep_reset_perag_resv(
 #define xrep_agi			xrep_notsupported
 #define xrep_allocbt			xrep_notsupported
 #define xrep_iallocbt			xrep_notsupported
+#define xrep_refcountbt			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 6011823d0d40..b104231af049 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -254,7 +254,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_ag_refcountbt,
 		.scrub	= xchk_refcountbt,
 		.has	= xfs_sb_version_hasreflink,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_refcountbt,
 	},
 	[XFS_SCRUB_TYPE_INODE] = {	/* inode record */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cdf0dffc17d2..f7e64a5cc751 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -729,8 +729,9 @@ DEFINE_REPAIR_RMAP_EVENT(xrep_bmap_extent_fn);
 
 TRACE_EVENT(xrep_refcount_extent_fn,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 struct xfs_refcount_irec *irec),
-	TP_ARGS(mp, agno, irec),
+		 xfs_agblock_t startblock, xfs_extlen_t blockcount,
+		 xfs_nlink_t refcount),
+	TP_ARGS(mp, agno, startblock, blockcount, refcount),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -741,9 +742,9 @@ TRACE_EVENT(xrep_refcount_extent_fn,
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = agno;
-		__entry->startblock = irec->rc_startblock;
-		__entry->blockcount = irec->rc_blockcount;
-		__entry->refcount = irec->rc_refcount;
+		__entry->startblock = startblock;
+		__entry->blockcount = blockcount;
+		__entry->refcount = refcount;
 	),
 	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),

