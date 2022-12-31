Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91BBD65A27B
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 04:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236377AbiLaDYX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 22:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236380AbiLaDYT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:24:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B489012ABF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:24:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34B3E61D65
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F12C433D2;
        Sat, 31 Dec 2022 03:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457055;
        bh=otGss8kfvjEmcdsiSjcmUxMt/sLkfUjCDS6JzVgxQaI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Pma5pcN5JERzFK+h1wxyOTWXr/Y5AKm+FPLaajRIQZcKZn1pvpYsQ3g3bI4JYhphd
         24mwMk3/kiePkvpJUA+22GRVdej/lyawujjMPyEJ/fVz7t0ViuYVIIxaqQgp1Ij0ik
         +cYeZYgN2OJBNrKR9hx3CFvhYWcfwrAohpE+fsOcxhiz/zQZC7YscbBdBE9rbatWAa
         AALAhnSPU50sprpRnpLKxPHl+eD52FDoTrnZ8YnCwFhxcLOu5Qda0xyVgObWtsnmJE
         Gqmf2Qt8xY7xChvyKdHGfjOJTsrCDSfPSWztDM65Ic/XrFgxSBZmOP2BvLVl+NWIAn
         BvlUGV50esR/g==
Subject: [PATCH 1/1] xfs: export reference count information to userspace
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:27 -0800
Message-ID: <167243876710.727360.8240045963010167777.stgit@magnolia>
In-Reply-To: <167243876696.727360.8931971090577962407.stgit@magnolia>
References: <167243876696.727360.8931971090577962407.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Export refcount info to userspace so we can prototype a sharing-aware
defrag/fs rearranging tool.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/xfs_fsrefs.c              |  935 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsrefs.h              |   34 +
 fs/xfs/xfs_ioctl.c               |  135 +++++
 fs/xfs/xfs_trace.c               |    1 
 fs/xfs/xfs_trace.h               |   74 +++
 include/uapi/linux/fsrefcounts.h |   96 ++++
 7 files changed, 1276 insertions(+)
 create mode 100644 fs/xfs/xfs_fsrefs.c
 create mode 100644 fs/xfs/xfs_fsrefs.h
 create mode 100644 include/uapi/linux/fsrefcounts.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 2f84dff55b6e..168302373a9f 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -78,6 +78,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_filestream.o \
 				   xfs_fsmap.o \
 				   xfs_fsops.o \
+				   xfs_fsrefs.o \
 				   xfs_globals.o \
 				   xfs_health.o \
 				   xfs_icache.o \
diff --git a/fs/xfs/xfs_fsrefs.c b/fs/xfs/xfs_fsrefs.c
new file mode 100644
index 000000000000..d35848bfbd86
--- /dev/null
+++ b/fs/xfs/xfs_fsrefs.c
@@ -0,0 +1,935 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_btree.h"
+#include "xfs_trace.h"
+#include "xfs_alloc.h"
+#include "xfs_bit.h"
+#include <linux/fsrefcounts.h>
+#include "xfs_fsrefs.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_rtalloc.h"
+#include "xfs_rtrefcount_btree.h"
+#include "xfs_ag.h"
+#include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
+
+/* getfsrefs query state */
+struct xfs_fsrefs_info {
+	struct xfs_fsrefs_head	*head;
+	struct fsrefs		*fsrefs_recs;	/* mapping records */
+
+	struct xfs_btree_cur	*refc_cur;	/* refcount btree cursor */
+	struct xfs_btree_cur	*bno_cur;	/* bnobt btree cursor */
+
+	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
+	struct xfs_perag	*pag;		/* perag structure */
+	struct xfs_rtgroup	*rtg;
+
+	xfs_daddr_t		next_daddr;	/* next daddr we expect */
+	/* daddr of low fsmap key when we're using the rtbitmap */
+	xfs_daddr_t		low_daddr;
+
+	struct xfs_refcount_irec low;		/* low refcount key */
+	struct xfs_refcount_irec high;		/* high refcount key */
+
+	u32			dev;		/* device id */
+	bool			last;		/* last extent? */
+};
+
+/* Associate a device with a getfsrefs handler. */
+struct xfs_fsrefs_dev {
+	u32			dev;
+	int			(*fn)(struct xfs_trans *tp,
+				      const struct xfs_fsrefs *keys,
+				      struct xfs_fsrefs_info *info);
+};
+
+/* Convert an xfs_fsrefs to an fsrefs. */
+static void
+xfs_fsrefs_from_internal(
+	struct fsrefs		*dest,
+	struct xfs_fsrefs	*src)
+{
+	dest->fcr_device = src->fcr_device;
+	dest->fcr_flags = src->fcr_flags;
+	dest->fcr_physical = BBTOB(src->fcr_physical);
+	dest->fcr_owners = src->fcr_owners;
+	dest->fcr_length = BBTOB(src->fcr_length);
+	dest->fcr_reserved[0] = 0;
+	dest->fcr_reserved[1] = 0;
+	dest->fcr_reserved[2] = 0;
+	dest->fcr_reserved[3] = 0;
+}
+
+/* Convert an fsrefs to an xfs_fsrefs. */
+void
+xfs_fsrefs_to_internal(
+	struct xfs_fsrefs	*dest,
+	struct fsrefs		*src)
+{
+	dest->fcr_device = src->fcr_device;
+	dest->fcr_flags = src->fcr_flags;
+	dest->fcr_physical = BTOBBT(src->fcr_physical);
+	dest->fcr_owners = src->fcr_owners;
+	dest->fcr_length = BTOBBT(src->fcr_length);
+}
+
+/* Compare two getfsrefs device handlers. */
+static int
+xfs_fsrefs_dev_compare(
+	const void			*p1,
+	const void			*p2)
+{
+	const struct xfs_fsrefs_dev	*d1 = p1;
+	const struct xfs_fsrefs_dev	*d2 = p2;
+
+	return d1->dev - d2->dev;
+}
+
+static inline bool
+xfs_fsrefs_rec_before_start(
+	struct xfs_fsrefs_info		*info,
+	const struct xfs_refcount_irec	*rec,
+	xfs_daddr_t			rec_daddr)
+{
+	if (info->low_daddr != -1ULL)
+		return rec_daddr < info->low_daddr;
+	return rec->rc_startblock < info->low.rc_startblock;
+}
+
+/*
+ * Format a refcount record for fsrefs, having translated rc_startblock into
+ * the appropriate daddr units.
+ */
+STATIC int
+xfs_fsrefs_helper(
+	struct xfs_trans		*tp,
+	struct xfs_fsrefs_info		*info,
+	const struct xfs_refcount_irec	*rec,
+	xfs_daddr_t			rec_daddr,
+	xfs_daddr_t			len_daddr)
+{
+	struct xfs_fsrefs		fcr;
+	struct fsrefs			*row;
+	struct xfs_mount		*mp = tp->t_mountp;
+
+	if (fatal_signal_pending(current))
+		return -EINTR;
+
+	if (len_daddr == 0)
+		len_daddr = XFS_FSB_TO_BB(mp, rec->rc_blockcount);
+
+	/*
+	 * Filter out records that start before our startpoint, if the
+	 * caller requested that.
+	 */
+	if (xfs_fsrefs_rec_before_start(info, rec, rec_daddr))
+		return 0;
+
+	/* Are we just counting mappings? */
+	if (info->head->fch_count == 0) {
+		if (info->head->fch_entries == UINT_MAX)
+			return -ECANCELED;
+
+		info->head->fch_entries++;
+		return 0;
+	}
+
+	/* Fill out the extent we found */
+	if (info->head->fch_entries >= info->head->fch_count)
+		return -ECANCELED;
+
+	if (info->pag)
+		trace_xfs_fsrefs_mapping(mp, info->dev, info->pag->pag_agno,
+				rec);
+	else if (info->rtg)
+		trace_xfs_fsrefs_mapping(mp, info->dev, info->rtg->rtg_rgno,
+				rec);
+	else
+		trace_xfs_fsrefs_mapping(mp, info->dev, NULLAGNUMBER, rec);
+
+	fcr.fcr_device = info->dev;
+	fcr.fcr_flags = 0;
+	fcr.fcr_physical = rec_daddr;
+	fcr.fcr_owners = rec->rc_refcount;
+	fcr.fcr_length = len_daddr;
+
+	trace_xfs_getfsrefs_mapping(mp, &fcr);
+
+	row = &info->fsrefs_recs[info->head->fch_entries++];
+	xfs_fsrefs_from_internal(row, &fcr);
+	return 0;
+}
+
+/* Synthesize fsrefs records from free space data. */
+STATIC int
+xfs_fsrefs_ddev_bnobt_helper(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_alloc_rec_incore *rec,
+	void				*priv)
+{
+	struct xfs_refcount_irec	irec;
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_fsrefs_info		*info = priv;
+	xfs_agnumber_t			next_agno;
+	xfs_agblock_t			next_agbno;
+	xfs_daddr_t			rec_daddr;
+
+	/*
+	 * Figure out if there's a gap between the last fsrefs record we
+	 * emitted and this free extent.  If there is, report the gap as a
+	 * refcount==1 record.
+	 */
+	next_agno = xfs_daddr_to_agno(mp, info->next_daddr);
+	next_agbno = xfs_daddr_to_agbno(mp, info->next_daddr);
+
+	ASSERT(next_agno >= cur->bc_ag.pag->pag_agno);
+	ASSERT(rec->ar_startblock >= next_agbno);
+
+	/*
+	 * If we've already moved on to the next AG, we don't have any fsrefs
+	 * records to synthesize.
+	 */
+	if (next_agno > cur->bc_ag.pag->pag_agno)
+		return 0;
+
+	info->next_daddr = XFS_AGB_TO_DADDR(mp, cur->bc_ag.pag->pag_agno,
+			rec->ar_startblock + rec->ar_blockcount);
+
+	if (rec->ar_startblock == next_agbno)
+		return 0;
+
+	/* Emit a record for the in-use space */
+	irec.rc_startblock = next_agbno;
+	irec.rc_blockcount = rec->ar_startblock - next_agbno;
+	irec.rc_refcount = 1;
+	irec.rc_domain = XFS_REFC_DOMAIN_SHARED;
+	rec_daddr = XFS_AGB_TO_DADDR(mp, cur->bc_ag.pag->pag_agno,
+			irec.rc_startblock);
+
+	return xfs_fsrefs_helper(cur->bc_tp, info, &irec, rec_daddr, 0);
+}
+
+/* Emit records to fill a gap in the refcount btree with singly-owned blocks. */
+STATIC int
+xfs_fsrefs_ddev_fill_refcount_gap(
+	struct xfs_trans		*tp,
+	struct xfs_fsrefs_info		*info,
+	xfs_agblock_t			agbno)
+{
+	struct xfs_alloc_rec_incore	low = {0};
+	struct xfs_alloc_rec_incore	high = {0};
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_btree_cur		*cur = info->bno_cur;
+	struct xfs_agf			*agf;
+	int				error;
+
+	ASSERT(xfs_daddr_to_agno(mp, info->next_daddr) ==
+			cur->bc_ag.pag->pag_agno);
+
+	low.ar_startblock = xfs_daddr_to_agbno(mp, info->next_daddr);
+	if (low.ar_startblock >= agbno)
+		return 0;
+
+	high.ar_startblock = agbno;
+	error = xfs_alloc_query_range(cur, &low, &high,
+			xfs_fsrefs_ddev_bnobt_helper, info);
+	if (error)
+		return error;
+
+	/*
+	 * Synthesize records for single-owner extents between the last
+	 * fsrefcount record emitted and the end of the query range.
+	 */
+	agf = cur->bc_ag.agbp->b_addr;
+	low.ar_startblock = min_t(xfs_agblock_t, agbno,
+				  be32_to_cpu(agf->agf_length));
+	if (xfs_daddr_to_agbno(mp, info->next_daddr) > low.ar_startblock)
+		return 0;
+
+	info->last = true;
+	return xfs_fsrefs_ddev_bnobt_helper(cur, &low, info);
+}
+
+/* Transform a refcountbt irec into a fsrefs */
+STATIC int
+xfs_fsrefs_ddev_helper(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*rec,
+	void				*priv)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_fsrefs_info		*info = priv;
+	xfs_daddr_t			rec_daddr;
+	int				error;
+
+	/*
+	 * Stop once we get to the CoW staging extents; they're all shoved to
+	 * the right side of the btree and were already covered by the bnobt
+	 * scan.
+	 */
+	if (rec->rc_domain != XFS_REFC_DOMAIN_SHARED)
+		return -ECANCELED;
+
+	/* Report on any gaps first */
+	error = xfs_fsrefs_ddev_fill_refcount_gap(cur->bc_tp, info,
+			rec->rc_startblock);
+	if (error)
+		return error;
+
+	rec_daddr = XFS_AGB_TO_DADDR(mp, cur->bc_ag.pag->pag_agno,
+			rec->rc_startblock);
+	info->next_daddr = XFS_AGB_TO_DADDR(mp, cur->bc_ag.pag->pag_agno,
+			rec->rc_startblock + rec->rc_blockcount);
+
+	return xfs_fsrefs_helper(cur->bc_tp, info, rec, rec_daddr, 0);
+}
+
+/* Execute a getfsrefs query against the regular data device. */
+STATIC int
+xfs_fsrefs_ddev(
+	struct xfs_trans	*tp,
+	const struct xfs_fsrefs	*keys,
+	struct xfs_fsrefs_info	*info)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_buf		*agf_bp = NULL;
+	struct xfs_perag	*pag = NULL;
+	xfs_fsblock_t		start_fsb;
+	xfs_fsblock_t		end_fsb;
+	xfs_agnumber_t		start_ag;
+	xfs_agnumber_t		end_ag;
+	xfs_agnumber_t		agno;
+	uint64_t		eofs;
+	int			error = 0;
+
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	if (keys[0].fcr_physical >= eofs)
+		return 0;
+	start_fsb = XFS_DADDR_TO_FSB(mp, keys[0].fcr_physical);
+	end_fsb = XFS_DADDR_TO_FSB(mp, min(eofs - 1, keys[1].fcr_physical));
+
+	info->refc_cur = info->bno_cur = NULL;
+
+	/*
+	 * Convert the fsrefs low/high keys to AG based keys.  Initialize
+	 * low to the fsrefs low key and max out the high key to the end
+	 * of the AG.
+	 */
+	info->low.rc_startblock = XFS_FSB_TO_AGBNO(mp, start_fsb);
+	info->low.rc_blockcount = 0;
+	info->low.rc_refcount = 0;
+	info->low.rc_domain = XFS_REFC_DOMAIN_SHARED;
+
+	info->high.rc_startblock = -1U;
+	info->high.rc_blockcount = 0;
+	info->high.rc_refcount = 0;
+	info->high.rc_domain = XFS_REFC_DOMAIN_SHARED;
+
+	start_ag = XFS_FSB_TO_AGNO(mp, start_fsb);
+	end_ag = XFS_FSB_TO_AGNO(mp, end_fsb);
+
+	/* Query each AG */
+	agno = start_ag;
+	for_each_perag_range(mp, agno, end_ag, pag) {
+		/*
+		 * Set the AG high key from the fsrefs high key if this
+		 * is the last AG that we're querying.
+		 */
+		info->pag = pag;
+		if (pag->pag_agno == end_ag)
+			info->high.rc_startblock = XFS_FSB_TO_AGBNO(mp,
+					end_fsb);
+
+		if (info->refc_cur) {
+			xfs_btree_del_cursor(info->refc_cur, XFS_BTREE_NOERROR);
+			info->refc_cur = NULL;
+		}
+		if (info->bno_cur) {
+			xfs_btree_del_cursor(info->bno_cur, XFS_BTREE_NOERROR);
+			info->bno_cur = NULL;
+		}
+		if (agf_bp) {
+			xfs_trans_brelse(tp, agf_bp);
+			agf_bp = NULL;
+		}
+
+		error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
+		if (error)
+			break;
+
+		trace_xfs_fsrefs_low_key(mp, info->dev, pag->pag_agno,
+				&info->low);
+		trace_xfs_fsrefs_high_key(mp, info->dev, pag->pag_agno,
+				&info->high);
+
+		info->bno_cur = xfs_allocbt_init_cursor(mp, tp, agf_bp, pag,
+						XFS_BTNUM_BNO);
+
+		if (xfs_has_reflink(mp)) {
+			info->refc_cur = xfs_refcountbt_init_cursor(mp, tp,
+							agf_bp, pag);
+
+			/*
+			 * Fill the query with refcount records and synthesize
+			 * singly-owned block records from free space data.
+			 */
+			error = xfs_refcount_query_range(info->refc_cur,
+					&info->low, &info->high,
+					xfs_fsrefs_ddev_helper, info);
+			if (error && error != -ECANCELED)
+				break;
+		}
+
+		/*
+		 * Synthesize refcount==1 records from the free space data
+		 * between the end of the last fsrefs record reported and the
+		 * end of the range.  If we don't have refcount support, the
+		 * starting point will be the start of the query range.
+		 */
+		error = xfs_fsrefs_ddev_fill_refcount_gap(tp, info,
+				info->high.rc_startblock);
+		if (error)
+			break;
+
+		/*
+		 * Set the AG low key to the start of the AG prior to
+		 * moving on to the next AG.
+		 */
+		if (pag->pag_agno == start_ag)
+			info->low.rc_startblock = 0;
+
+		info->pag = NULL;
+	}
+
+	if (info->refc_cur) {
+		xfs_btree_del_cursor(info->refc_cur, error);
+		info->refc_cur = NULL;
+	}
+	if (info->bno_cur) {
+		xfs_btree_del_cursor(info->bno_cur, error);
+		info->bno_cur = NULL;
+	}
+	if (agf_bp)
+		xfs_trans_brelse(tp, agf_bp);
+	if (info->pag) {
+		xfs_perag_put(info->pag);
+		info->pag = NULL;
+	} else if (pag) {
+		/* loop termination case */
+		xfs_perag_put(pag);
+	}
+
+	return error;
+}
+
+/* Execute a getfsrefs query against the log device. */
+STATIC int
+xfs_fsrefs_logdev(
+	struct xfs_trans		*tp,
+	const struct xfs_fsrefs		*keys,
+	struct xfs_fsrefs_info		*info)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_refcount_irec	refc;
+
+	/* Set up search keys */
+	info->low.rc_startblock = XFS_BB_TO_FSBT(mp, keys[0].fcr_physical);
+	info->low.rc_blockcount = 0;
+	info->low.rc_refcount = 0;
+
+	info->high.rc_startblock = -1U;
+	info->high.rc_blockcount = 0;
+	info->high.rc_refcount = 0;
+
+	trace_xfs_fsrefs_low_key(mp, info->dev, 0, &info->low);
+	trace_xfs_fsrefs_high_key(mp, info->dev, 0, &info->high);
+
+	if (keys[0].fcr_physical > 0)
+		return 0;
+
+	/* Fabricate an refc entry for the external log device. */
+	refc.rc_startblock = 0;
+	refc.rc_blockcount = mp->m_sb.sb_logblocks;
+	refc.rc_refcount = 1;
+	refc.rc_domain = XFS_REFC_DOMAIN_SHARED;
+
+	return xfs_fsrefs_helper(tp, info, &refc, 0, 0);
+}
+
+#ifdef CONFIG_XFS_RT
+/* Synthesize fsrefs records from rtbitmap records. */
+STATIC int
+xfs_fsrefs_rtdev_bitmap_helper(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv)
+{
+	struct xfs_refcount_irec	irec;
+	struct xfs_fsrefs_info		*info = priv;
+	xfs_rtblock_t			rt_startblock;
+	xfs_rtblock_t			rec_rtlen;
+	xfs_rtblock_t			next_rtbno;
+	xfs_daddr_t			rec_daddr;
+
+	/*
+	 * Figure out if there's a gap between the last fsrefs record we
+	 * emitted and this free extent.  If there is, report the gap as a
+	 * refcount==1 record.
+	 */
+	next_rtbno = XFS_BB_TO_FSBT(mp, info->next_daddr);
+	rt_startblock = xfs_rtx_to_rtb(mp, rec->ar_startext);
+	rec_rtlen = xfs_rtx_to_rtb(mp, rec->ar_extcount);
+
+	ASSERT(rt_startblock >= next_rtbno);
+
+	info->next_daddr = XFS_FSB_TO_BB(mp, rt_startblock + rec_rtlen);
+
+	if (rt_startblock == next_rtbno)
+		return 0;
+
+	/* Emit a record for the in-use space */
+	irec.rc_startblock = next_rtbno;
+	irec.rc_blockcount = rt_startblock - next_rtbno;
+	irec.rc_refcount = 1;
+	irec.rc_domain = XFS_REFC_DOMAIN_SHARED;
+	rec_daddr = XFS_FSB_TO_BB(mp, next_rtbno);
+
+	return xfs_fsrefs_helper(tp, info, &irec, rec_daddr,
+			XFS_FSB_TO_BB(mp, rt_startblock - next_rtbno));
+}
+
+/* Emit records to fill a gap in the refcount btree with singly-owned blocks. */
+STATIC int
+xfs_fsrefs_rtdev_fill_refcount_gap(
+	struct xfs_trans	*tp,
+	struct xfs_fsrefs_info	*info,
+	xfs_rtblock_t		next_rtbno)
+{
+	struct xfs_rtalloc_rec	low = { 0 };
+	struct xfs_rtalloc_rec	high = { 0 };
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_rtblock_t		rtbno;
+	xfs_daddr_t		rec_daddr;
+	xfs_extlen_t		mod;
+	int			error;
+
+	/*
+	 * Set up query parameters to return free extents covering the range we
+	 * want.
+	 */
+	rtbno = XFS_BB_TO_FSBT(mp, info->next_daddr);
+	low.ar_startext = xfs_rtb_to_rtxt(mp, rtbno);
+
+	high.ar_startext = xfs_rtb_to_rtx(mp, next_rtbno, &mod);
+	if (mod)
+		high.ar_startext++;
+
+	error = xfs_rtalloc_query_range(mp, tp, &low, &high,
+			xfs_fsrefs_rtdev_bitmap_helper, info);
+	if (error)
+		return error;
+
+	/*
+	 * Synthesize records for single-owner extents between the last
+	 * fsrefcount record emitted and the end of the query range.
+	 */
+	high.ar_startext = min(mp->m_sb.sb_rextents, high.ar_startext);
+	rec_daddr = XFS_FSB_TO_BB(mp, xfs_rtx_to_rtb(mp, high.ar_startext));
+	if (info->next_daddr > rec_daddr)
+		return 0;
+
+	info->last = true;
+	return xfs_fsrefs_rtdev_bitmap_helper(mp, tp, &high, info);
+}
+
+/* Transform a absolute-startblock refcount (rtdev, logdev) into a fsrefs */
+STATIC int
+xfs_fsrefs_rtdev_helper(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*rec,
+	void				*priv)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_fsrefs_info		*info = priv;
+	xfs_rtblock_t			rtbno;
+	int				error;
+
+	/*
+	 * Stop once we get to the CoW staging extents; they're all shoved to
+	 * the right side of the btree and were already covered by the rtbitmap
+	 * scan.
+	 */
+	if (rec->rc_domain != XFS_REFC_DOMAIN_SHARED)
+		return -ECANCELED;
+
+	/* Report on any gaps first */
+	rtbno = xfs_rgbno_to_rtb(mp, cur->bc_ino.rtg->rtg_rgno,
+			rec->rc_startblock);
+	error = xfs_fsrefs_rtdev_fill_refcount_gap(cur->bc_tp, info, rtbno);
+	if (error)
+		return error;
+
+	/* Report this refcount extent. */
+	info->next_daddr = XFS_FSB_TO_BB(mp, rtbno + rec->rc_blockcount);
+	return xfs_fsrefs_helper(cur->bc_tp, info, rec,
+			XFS_FSB_TO_BB(mp, rtbno), 0);
+}
+
+/* Execute a getfsrefs query against the realtime bitmap. */
+STATIC int
+xfs_fsrefs_rtdev_rtbitmap(
+	struct xfs_trans	*tp,
+	const struct xfs_fsrefs	*keys,
+	struct xfs_fsrefs_info	*info)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_rtblock_t		start_fsb;
+	xfs_rtblock_t		end_fsb;
+	uint64_t		eofs;
+	int			error;
+
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	if (keys[0].fcr_physical >= eofs)
+		return 0;
+	start_fsb = XFS_BB_TO_FSBT(mp, keys[0].fcr_physical);
+	end_fsb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fcr_physical));
+
+	info->refc_cur = NULL;
+
+	/* Set up search keys */
+	info->low.rc_startblock = start_fsb;
+	info->low_daddr = XFS_FSB_TO_BB(mp, start_fsb);
+	info->low.rc_blockcount = 0;
+	info->low.rc_refcount = 0;
+
+	info->high.rc_startblock = end_fsb;
+	info->high.rc_blockcount = 0;
+	info->high.rc_refcount = 0;
+
+	trace_xfs_fsrefs_low_key(mp, info->dev, NULLAGNUMBER, &info->low);
+	trace_xfs_fsrefs_high_key(mp, info->dev, NULLAGNUMBER, &info->high);
+
+	/* Synthesize refcount==1 records from the free space data. */
+	xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
+	error = xfs_fsrefs_rtdev_fill_refcount_gap(tp, info, end_fsb);
+	xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
+	return error;
+}
+
+#define XFS_RTGLOCK_FSREFS	(XFS_RTGLOCK_BITMAP_SHARED | \
+				 XFS_RTGLOCK_REFCOUNT)
+
+/* Execute a getfsrefs query against the realtime device. */
+STATIC int
+xfs_fsrefs_rtdev(
+	struct xfs_trans	*tp,
+	const struct xfs_fsrefs	*keys,
+	struct xfs_fsrefs_info	*info)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_rtgroup	*rtg;
+	xfs_rtblock_t		start_fsb;
+	xfs_rtblock_t		end_fsb;
+	uint64_t		eofs;
+	xfs_rgnumber_t		start_rg, end_rg;
+	int			error = 0;
+
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	if (keys[0].fcr_physical >= eofs)
+		return 0;
+	start_fsb = XFS_BB_TO_FSBT(mp, keys[0].fcr_physical);
+	end_fsb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fcr_physical));
+
+	info->refc_cur = NULL;
+
+	/*
+	 * Convert the fsrefs low/high keys to rtgroup based keys.  Initialize
+	 * low to the fsrefs low key and max out the high key to the end of the
+	 * rtgroup.
+	 */
+	info->low.rc_startblock = xfs_rtb_to_rgbno(mp, start_fsb, &start_rg);
+	info->low.rc_blockcount = 0;
+	info->low.rc_refcount = 0;
+	info->low.rc_domain = XFS_REFC_DOMAIN_SHARED;
+
+	info->high.rc_startblock = -1U;
+	info->high.rc_blockcount = 0;
+	info->high.rc_refcount = 0;
+	info->high.rc_domain = XFS_REFC_DOMAIN_SHARED;
+
+	end_rg = xfs_rtb_to_rgno(mp, end_fsb);
+
+	for_each_rtgroup_range(mp, start_rg, end_rg, rtg) {
+		/*
+		 * Set the rtgroup high key from the fsrefs high key if this
+		 * is the last rtgroup that we're querying.
+		 */
+		info->rtg = rtg;
+		if (rtg->rtg_rgno == end_rg) {
+			xfs_rgnumber_t	junk;
+
+			info->high.rc_startblock = xfs_rtb_to_rgbno(mp,
+					end_fsb, &junk);
+		}
+
+		if (info->refc_cur) {
+			xfs_rtgroup_unlock(info->refc_cur->bc_ino.rtg,
+					XFS_RTGLOCK_FSREFS);
+			xfs_btree_del_cursor(info->refc_cur, XFS_BTREE_NOERROR);
+			info->refc_cur = NULL;
+		}
+
+		trace_xfs_fsrefs_low_key(mp, info->dev, rtg->rtg_rgno,
+				&info->low);
+		trace_xfs_fsrefs_high_key(mp, info->dev, rtg->rtg_rgno,
+				&info->high);
+
+		xfs_rtgroup_lock(NULL, rtg, XFS_RTGLOCK_FSREFS);
+		info->refc_cur = xfs_rtrefcountbt_init_cursor(mp, tp, rtg,
+						rtg->rtg_refcountip);
+
+		/*
+		 * Fill the query with refcount records and synthesize
+		 * singly-owned block records from free space data.
+		 */
+		error = xfs_refcount_query_range(info->refc_cur,
+				&info->low, &info->high,
+				xfs_fsrefs_rtdev_helper, info);
+		if (error && error != -ECANCELED)
+			break;
+
+		/*
+		 * Set the rtgroup low key to the start of the rtgroup prior to
+		 * moving on to the next rtgroup.
+		 */
+		if (rtg->rtg_rgno == start_rg)
+			info->low.rc_startblock = 0;
+
+		/*
+		 * If this is the last rtgroup, report any gap at the end of it
+		 * before we drop the reference to the perag when the loop
+		 * terminates.
+		 */
+		if (rtg->rtg_rgno == end_rg) {
+			info->last = true;
+			error = xfs_fsrefs_rtdev_fill_refcount_gap(tp, info,
+					end_fsb);
+			if (error)
+				break;
+		}
+		info->rtg = NULL;
+	}
+
+	if (info->refc_cur) {
+		xfs_rtgroup_unlock(info->refc_cur->bc_ino.rtg,
+				XFS_RTGLOCK_FSREFS);
+		xfs_btree_del_cursor(info->refc_cur, error);
+		info->refc_cur = NULL;
+	}
+	if (info->rtg) {
+		xfs_rtgroup_put(info->rtg);
+		info->rtg = NULL;
+	} else if (rtg) {
+		/* loop termination case */
+		xfs_rtgroup_put(rtg);
+	}
+
+	return error;
+}
+#endif
+
+/* Do we recognize the device? */
+STATIC bool
+xfs_fsrefs_is_valid_device(
+	struct xfs_mount	*mp,
+	struct xfs_fsrefs	*fcr)
+{
+	if (fcr->fcr_device == 0 || fcr->fcr_device == UINT_MAX ||
+	    fcr->fcr_device == new_encode_dev(mp->m_ddev_targp->bt_dev))
+		return true;
+	if (mp->m_logdev_targp &&
+	    fcr->fcr_device == new_encode_dev(mp->m_logdev_targp->bt_dev))
+		return true;
+	if (mp->m_rtdev_targp &&
+	    fcr->fcr_device == new_encode_dev(mp->m_rtdev_targp->bt_dev))
+		return true;
+	return false;
+}
+
+/* Ensure that the low key is less than the high key. */
+STATIC bool
+xfs_fsrefs_check_keys(
+	struct xfs_fsrefs	*low_key,
+	struct xfs_fsrefs	*high_key)
+{
+	if (low_key->fcr_device > high_key->fcr_device)
+		return false;
+	if (low_key->fcr_device < high_key->fcr_device)
+		return true;
+
+	if (low_key->fcr_physical > high_key->fcr_physical)
+		return false;
+	if (low_key->fcr_physical < high_key->fcr_physical)
+		return true;
+
+	return false;
+}
+
+/*
+ * There are only two devices if we didn't configure RT devices at build time.
+ */
+#ifdef CONFIG_XFS_RT
+#define XFS_GETFSREFS_DEVS	3
+#else
+#define XFS_GETFSREFS_DEVS	2
+#endif /* CONFIG_XFS_RT */
+
+/*
+ * Get filesystem's extent refcounts as described in head, and format for
+ * output. Fills in the supplied records array until there are no more reverse
+ * mappings to return or head.fch_entries == head.fch_count.  In the second
+ * case, this function returns -ECANCELED to indicate that more records would
+ * have been returned.
+ *
+ * Key to Confusion
+ * ----------------
+ * There are multiple levels of keys and counters at work here:
+ * xfs_fsrefs_head.fch_keys	-- low and high fsrefs keys passed in;
+ *				   these reflect fs-wide sector addrs.
+ * dkeys			-- fch_keys used to query each device;
+ *				   these are fch_keys but w/ the low key
+ *				   bumped up by fcr_length.
+ * xfs_fsrefs_info.next_daddr-- next disk addr we expect to see; this
+ *				   is how we detect gaps in the fsrefs
+				   records and report them.
+ * xfs_fsrefs_info.low/high	-- per-AG low/high keys computed from
+ *				   dkeys; used to query the metadata.
+ */
+int
+xfs_getfsrefs(
+	struct xfs_mount	*mp,
+	struct xfs_fsrefs_head	*head,
+	struct fsrefs		*fsrefs_recs)
+{
+	struct xfs_trans	*tp = NULL;
+	struct xfs_fsrefs	dkeys[2];	/* per-dev keys */
+	struct xfs_fsrefs_dev	handlers[XFS_GETFSREFS_DEVS];
+	struct xfs_fsrefs_info	info = { NULL };
+	int			i;
+	int			error = 0;
+
+	if (head->fch_iflags & ~FCH_IF_VALID)
+		return -EINVAL;
+	if (!xfs_fsrefs_is_valid_device(mp, &head->fch_keys[0]) ||
+	    !xfs_fsrefs_is_valid_device(mp, &head->fch_keys[1]))
+		return -EINVAL;
+
+	head->fch_entries = 0;
+
+	/* Set up our device handlers. */
+	memset(handlers, 0, sizeof(handlers));
+	handlers[0].dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
+	handlers[0].fn = xfs_fsrefs_ddev;
+	if (mp->m_logdev_targp != mp->m_ddev_targp) {
+		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
+		handlers[1].fn = xfs_fsrefs_logdev;
+	}
+#ifdef CONFIG_XFS_RT
+	if (mp->m_rtdev_targp) {
+		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
+		if (xfs_has_rtreflink(mp))
+			handlers[2].fn = xfs_fsrefs_rtdev;
+		else
+			handlers[2].fn = xfs_fsrefs_rtdev_rtbitmap;
+	}
+#endif /* CONFIG_XFS_RT */
+
+	xfs_sort(handlers, XFS_GETFSREFS_DEVS, sizeof(struct xfs_fsrefs_dev),
+			xfs_fsrefs_dev_compare);
+
+	/*
+	 * To continue where we left off, we allow userspace to use the last
+	 * mapping from a previous call as the low key of the next.  This is
+	 * identified by a non-zero length in the low key. We have to increment
+	 * the low key in this scenario to ensure we don't return the same
+	 * mapping again, and instead return the very next mapping.  Bump the
+	 * physical offset as there can be no other mapping for the same
+	 * physical block range.
+	 */
+	dkeys[0] = head->fch_keys[0];
+	dkeys[0].fcr_physical += dkeys[0].fcr_length;
+	dkeys[0].fcr_length = 0;
+	memset(&dkeys[1], 0xFF, sizeof(struct xfs_fsrefs));
+
+	if (!xfs_fsrefs_check_keys(dkeys, &head->fch_keys[1]))
+		return -EINVAL;
+
+	info.next_daddr = head->fch_keys[0].fcr_physical +
+			  head->fch_keys[0].fcr_length;
+	info.fsrefs_recs = fsrefs_recs;
+	info.head = head;
+
+	/* For each device we support... */
+	for (i = 0; i < XFS_GETFSREFS_DEVS; i++) {
+		/* Is this device within the range the user asked for? */
+		if (!handlers[i].fn)
+			continue;
+		if (head->fch_keys[0].fcr_device > handlers[i].dev)
+			continue;
+		if (head->fch_keys[1].fcr_device < handlers[i].dev)
+			break;
+
+		/*
+		 * If this device number matches the high key, we have to pass
+		 * the high key to the handler to limit the query results.  If
+		 * the device number exceeds the low key, zero out the low key
+		 * so that we get everything from the beginning.
+		 */
+		if (handlers[i].dev == head->fch_keys[1].fcr_device)
+			dkeys[1] = head->fch_keys[1];
+		if (handlers[i].dev > head->fch_keys[0].fcr_device)
+			memset(&dkeys[0], 0, sizeof(struct xfs_fsrefs));
+
+		/*
+		 * Grab an empty transaction so that we can use its recursive
+		 * buffer locking abilities to detect cycles in the refcountbt
+		 * without deadlocking.
+		 */
+		error = xfs_trans_alloc_empty(mp, &tp);
+		if (error)
+			break;
+
+		info.dev = handlers[i].dev;
+		info.last = false;
+		info.pag = NULL;
+		info.rtg = NULL;
+		info.low_daddr = -1ULL;
+		error = handlers[i].fn(tp, dkeys, &info);
+		if (error)
+			break;
+		xfs_trans_cancel(tp);
+		tp = NULL;
+		info.next_daddr = 0;
+	}
+
+	if (tp)
+		xfs_trans_cancel(tp);
+	head->fch_oflags = FCH_OF_DEV_T;
+	return error;
+}
diff --git a/fs/xfs/xfs_fsrefs.h b/fs/xfs/xfs_fsrefs.h
new file mode 100644
index 000000000000..fa74e1a84d92
--- /dev/null
+++ b/fs/xfs/xfs_fsrefs.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_FSREFS_H__
+#define __XFS_FSREFS_H__
+
+struct fsrefs;
+
+/* internal fsrefs representation */
+struct xfs_fsrefs {
+	dev_t		fcr_device;	/* device id */
+	uint32_t	fcr_flags;	/* mapping flags */
+	uint64_t	fcr_physical;	/* device offset of segment */
+	uint64_t	fcr_owners;	/* number of owners */
+	xfs_filblks_t	fcr_length;	/* length of segment, blocks */
+};
+
+struct xfs_fsrefs_head {
+	uint32_t	fch_iflags;	/* control flags */
+	uint32_t	fch_oflags;	/* output flags */
+	unsigned int	fch_count;	/* # of entries in array incl. input */
+	unsigned int	fch_entries;	/* # of entries filled in (output). */
+
+	struct xfs_fsrefs fch_keys[2];	/* low and high keys */
+};
+
+void xfs_fsrefs_to_internal(struct xfs_fsrefs *dest, struct fsrefs *src);
+
+int xfs_getfsrefs(struct xfs_mount *mp, struct xfs_fsrefs_head *head,
+		struct fsrefs *out_recs);
+
+#endif /* __XFS_FSREFS_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index fdd8fd35fc48..3eda06f93f5b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -31,6 +31,8 @@
 #include "xfs_btree.h"
 #include <linux/fsmap.h>
 #include "xfs_fsmap.h"
+#include <linux/fsrefcounts.h>
+#include "xfs_fsrefs.h"
 #include "scrub/xfs_scrub.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
@@ -1621,6 +1623,136 @@ xfs_ioc_getfsmap(
 	return error;
 }
 
+STATIC int
+xfs_ioc_getfsrefcounts(
+	struct xfs_inode	*ip,
+	struct fsrefs_head	__user *arg)
+{
+	struct xfs_fsrefs_head	xhead = {0};
+	struct fsrefs_head	head;
+	struct fsrefs		*recs;
+	unsigned int		count;
+	__u32			last_flags = 0;
+	bool			done = false;
+	int			error;
+
+	if (copy_from_user(&head, arg, sizeof(struct fsrefs_head)))
+		return -EFAULT;
+	if (memchr_inv(head.fch_reserved, 0, sizeof(head.fch_reserved)) ||
+	    memchr_inv(head.fch_keys[0].fcr_reserved, 0,
+		       sizeof(head.fch_keys[0].fcr_reserved)) ||
+	    memchr_inv(head.fch_keys[1].fcr_reserved, 0,
+		       sizeof(head.fch_keys[1].fcr_reserved)))
+		return -EINVAL;
+
+	/*
+	 * Use an internal memory buffer so that we don't have to copy fsrefs
+	 * data to userspace while holding locks.  Start by trying to allocate
+	 * up to 128k for the buffer, but fall back to a single page if needed.
+	 */
+	count = min_t(unsigned int, head.fch_count,
+			131072 / sizeof(struct fsrefs));
+	recs = kvzalloc(count * sizeof(struct fsrefs), GFP_KERNEL);
+	if (!recs) {
+		count = min_t(unsigned int, head.fch_count,
+				PAGE_SIZE / sizeof(struct fsrefs));
+		recs = kvzalloc(count * sizeof(struct fsrefs), GFP_KERNEL);
+		if (!recs)
+			return -ENOMEM;
+	}
+
+	xhead.fch_iflags = head.fch_iflags;
+	xfs_fsrefs_to_internal(&xhead.fch_keys[0], &head.fch_keys[0]);
+	xfs_fsrefs_to_internal(&xhead.fch_keys[1], &head.fch_keys[1]);
+
+	trace_xfs_getfsrefs_low_key(ip->i_mount, &xhead.fch_keys[0]);
+	trace_xfs_getfsrefs_high_key(ip->i_mount, &xhead.fch_keys[1]);
+
+	head.fch_entries = 0;
+	do {
+		struct fsrefs __user	*user_recs;
+		struct fsrefs		*last_rec;
+
+		user_recs = &arg->fch_recs[head.fch_entries];
+		xhead.fch_entries = 0;
+		xhead.fch_count = min_t(unsigned int, count,
+					head.fch_count - head.fch_entries);
+
+		/* Run query, record how many entries we got. */
+		error = xfs_getfsrefs(ip->i_mount, &xhead, recs);
+		switch (error) {
+		case 0:
+			/*
+			 * There are no more records in the result set.  Copy
+			 * whatever we got to userspace and break out.
+			 */
+			done = true;
+			break;
+		case -ECANCELED:
+			/*
+			 * The internal memory buffer is full.  Copy whatever
+			 * records we got to userspace and go again if we have
+			 * not yet filled the userspace buffer.
+			 */
+			error = 0;
+			break;
+		default:
+			goto out_free;
+		}
+		head.fch_entries += xhead.fch_entries;
+		head.fch_oflags = xhead.fch_oflags;
+
+		/*
+		 * If the caller wanted a record count or there aren't any
+		 * new records to return, we're done.
+		 */
+		if (head.fch_count == 0 || xhead.fch_entries == 0)
+			break;
+
+		/* Copy all the records we got out to userspace. */
+		if (copy_to_user(user_recs, recs,
+				 xhead.fch_entries * sizeof(struct fsrefs))) {
+			error = -EFAULT;
+			goto out_free;
+		}
+
+		/* Remember the last record flags we copied to userspace. */
+		last_rec = &recs[xhead.fch_entries - 1];
+		last_flags = last_rec->fcr_flags;
+
+		/* Set up the low key for the next iteration. */
+		xfs_fsrefs_to_internal(&xhead.fch_keys[0], last_rec);
+		trace_xfs_getfsrefs_low_key(ip->i_mount, &xhead.fch_keys[0]);
+	} while (!done && head.fch_entries < head.fch_count);
+
+	/*
+	 * If there are no more records in the query result set and we're not
+	 * in counting mode, mark the last record returned with the LAST flag.
+	 */
+	if (done && head.fch_count > 0 && head.fch_entries > 0) {
+		struct fsrefs __user	*user_rec;
+
+		last_flags |= FCR_OF_LAST;
+		user_rec = &arg->fch_recs[head.fch_entries - 1];
+
+		if (copy_to_user(&user_rec->fcr_flags, &last_flags,
+					sizeof(last_flags))) {
+			error = -EFAULT;
+			goto out_free;
+		}
+	}
+
+	/* copy back header */
+	if (copy_to_user(arg, &head, sizeof(struct fsrefs_head))) {
+		error = -EFAULT;
+		goto out_free;
+	}
+
+out_free:
+	kmem_free(recs);
+	return error;
+}
+
 STATIC int
 xfs_ioc_scrub_metadata(
 	struct file			*file,
@@ -1955,6 +2087,9 @@ xfs_file_ioctl(
 	case FS_IOC_GETFSMAP:
 		return xfs_ioc_getfsmap(ip, arg);
 
+	case FS_IOC_GETFSREFCOUNTS:
+		return xfs_ioc_getfsrefcounts(ip, arg);
+
 	case XFS_IOC_SCRUBV_METADATA:
 		return xfs_ioc_scrubv_metadata(filp, arg);
 	case XFS_IOC_SCRUB_METADATA:
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 64f11a535763..948532a8274c 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -45,6 +45,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
+#include "xfs_fsrefs.h"
 
 static inline void
 xfs_rmapbt_crack_agno_opdev(
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ba892e6a8233..b422a206edb5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -92,6 +92,7 @@ struct xfs_rtgroup;
 struct xfs_extent_free_item;
 struct xfs_rmap_intent;
 struct xfs_refcount_intent;
+struct xfs_fsrefs;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -4140,6 +4141,79 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_low_key);
 DEFINE_GETFSMAP_EVENT(xfs_getfsmap_high_key);
 DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 
+/* fsrefs traces */
+DECLARE_EVENT_CLASS(xfs_fsrefs_class,
+	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_agnumber_t agno,
+		 const struct xfs_refcount_irec *refc),
+	TP_ARGS(mp, keydev, agno, refc),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, keydev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, bno)
+		__field(xfs_extlen_t, len)
+		__field(uint64_t, owners)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->keydev = new_decode_dev(keydev);
+		__entry->agno = agno;
+		__entry->bno = refc->rc_startblock;
+		__entry->len = refc->rc_blockcount;
+		__entry->owners = refc->rc_refcount;
+	),
+	TP_printk("dev %d:%d keydev %d:%d agno 0x%x refcbno 0x%x fsbcount 0x%x owners %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
+		  __entry->agno,
+		  __entry->bno,
+		  __entry->len,
+		  __entry->owners)
+)
+#define DEFINE_FSREFS_EVENT(name) \
+DEFINE_EVENT(xfs_fsrefs_class, name, \
+	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_agnumber_t agno, \
+		 const struct xfs_refcount_irec *refc), \
+	TP_ARGS(mp, keydev, agno, refc))
+DEFINE_FSREFS_EVENT(xfs_fsrefs_low_key);
+DEFINE_FSREFS_EVENT(xfs_fsrefs_high_key);
+DEFINE_FSREFS_EVENT(xfs_fsrefs_mapping);
+
+DECLARE_EVENT_CLASS(xfs_getfsrefs_class,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_fsrefs *fsrefs),
+	TP_ARGS(mp, fsrefs),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, keydev)
+		__field(xfs_daddr_t, block)
+		__field(xfs_daddr_t, len)
+		__field(uint64_t, owners)
+		__field(uint32_t, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->keydev = new_decode_dev(fsrefs->fcr_device);
+		__entry->block = fsrefs->fcr_physical;
+		__entry->len = fsrefs->fcr_length;
+		__entry->owners = fsrefs->fcr_owners;
+		__entry->flags = fsrefs->fcr_flags;
+	),
+	TP_printk("dev %d:%d keydev %d:%d daddr 0x%llx bbcount 0x%llx owners %llu flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
+		  __entry->block,
+		  __entry->len,
+		  __entry->owners,
+		  __entry->flags)
+)
+#define DEFINE_GETFSREFS_EVENT(name) \
+DEFINE_EVENT(xfs_getfsrefs_class, name, \
+	TP_PROTO(struct xfs_mount *mp, struct xfs_fsrefs *fsrefs), \
+	TP_ARGS(mp, fsrefs))
+DEFINE_GETFSREFS_EVENT(xfs_getfsrefs_low_key);
+DEFINE_GETFSREFS_EVENT(xfs_getfsrefs_high_key);
+DEFINE_GETFSREFS_EVENT(xfs_getfsrefs_mapping);
+
 DECLARE_EVENT_CLASS(xfs_trans_resv_class,
 	TP_PROTO(struct xfs_mount *mp, unsigned int type,
 		 struct xfs_trans_res *res),
diff --git a/include/uapi/linux/fsrefcounts.h b/include/uapi/linux/fsrefcounts.h
new file mode 100644
index 000000000000..edb02bf99599
--- /dev/null
+++ b/include/uapi/linux/fsrefcounts.h
@@ -0,0 +1,96 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * FS_IOC_GETFSREFCOUNTS ioctl infrastructure.
+ *
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef _LINUX_FSREFCOUNTS_H
+#define _LINUX_FSREFCOUNTS_H
+
+#include <linux/types.h>
+
+/*
+ *	Structure for FS_IOC_GETFSREFCOUNTS.
+ *
+ *	The memory layout for this call are the scalar values defined in
+ *	struct fsrefs_head, followed by two struct fsrefs that describe the
+ *	lower and upper bound of mappings to return, followed by an array of
+ *	struct fsrefs mappings.
+ *
+ *	fch_iflags control the output of the call, whereas fch_oflags report
+ *	on the overall record output.  fch_count should be set to the length
+ *	of the fch_recs array, and fch_entries will be set to the number of
+ *	entries filled out during each call.  If fch_count is zero, the number
+ *	of refcount mappings will be returned in fch_entries, though no
+ *	mappings will be returned.  fch_reserved must be set to zero.
+ *
+ *	The two elements in the fch_keys array are used to constrain the
+ *	output.  The first element in the array should represent the lowest
+ *	disk mapping ("low key") that the user wants to learn about.  If this
+ *	value is all zeroes, the filesystem will return the first entry it
+ *	knows about.  For a subsequent call, the contents of
+ *	fsrefs_head.fch_recs[fsrefs_head.fch_count - 1] should be copied into
+ *	fch_keys[0] to have the kernel start where it left off.
+ *
+ *	The second element in the fch_keys array should represent the highest
+ *	disk mapping ("high key") that the user wants to learn about.  If this
+ *	value is all ones, the filesystem will not stop until it runs out of
+ *	mapping to return or runs out of space in fch_recs.
+ *
+ *	fcr_device can be either a 32-bit cookie representing a device, or a
+ *	32-bit dev_t if the FCH_OF_DEV_T flag is set.  fcr_physical and
+ *	fcr_length are expressed in units of bytes.  fcr_owners is the number
+ *	of owners.
+ */
+struct fsrefs {
+	__u32		fcr_device;	/* device id */
+	__u32		fcr_flags;	/* mapping flags */
+	__u64		fcr_physical;	/* device offset of segment */
+	__u64		fcr_owners;	/* number of owners */
+	__u64		fcr_length;	/* length of segment */
+	__u64		fcr_reserved[4];	/* must be zero */
+};
+
+struct fsrefs_head {
+	__u32		fch_iflags;	/* control flags */
+	__u32		fch_oflags;	/* output flags */
+	__u32		fch_count;	/* # of entries in array incl. input */
+	__u32		fch_entries;	/* # of entries filled in (output). */
+	__u64		fch_reserved[6];	/* must be zero */
+
+	struct fsrefs	fch_keys[2];	/* low and high keys for the mapping search */
+	struct fsrefs	fch_recs[];	/* returned records */
+};
+
+/* Size of an fsrefs_head with room for nr records. */
+static inline unsigned long long
+fsrefs_sizeof(
+	unsigned int	nr)
+{
+	return sizeof(struct fsrefs_head) + nr * sizeof(struct fsrefs);
+}
+
+/* Start the next fsrefs query at the end of the current query results. */
+static inline void
+fsrefs_advance(
+	struct fsrefs_head	*head)
+{
+	head->fch_keys[0] = head->fch_recs[head->fch_entries - 1];
+}
+
+/*	fch_iflags values - set by FS_IOC_GETFSREFCOUNTS caller in the header. */
+/* no flags defined yet */
+#define FCH_IF_VALID		0
+
+/*	fch_oflags values - returned in the header segment only. */
+#define FCH_OF_DEV_T		0x1	/* fcr_device values will be dev_t */
+
+/*	fcr_flags values - returned for each non-header segment */
+#define FCR_OF_LAST		(1U << 0)	/* segment is the last in the dataset */
+
+/* XXX stealing XFS_IOC_GETBIOSIZE */
+#define FS_IOC_GETFSREFCOUNTS		_IOWR('X', 47, struct fsrefs_head)
+
+#endif /* _LINUX_FSREFCOUNTS_H */

