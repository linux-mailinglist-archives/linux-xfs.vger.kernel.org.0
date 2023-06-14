Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F629711BC1
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 02:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjEZAzE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 20:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjEZAzC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:55:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E61712E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:54:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9D7D64BF6
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38127C433D2;
        Fri, 26 May 2023 00:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062498;
        bh=aIwV3AClDnOiLpmGUEvh3ojpi0lQVJBhGqrR5aEMm20=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hM7uv+ORz/yzl+nbevzXv6FMquZxxKkmrV+swuh+Sie/RnVm4LMWd4L1yFnCnfc2A
         1HNCHrZR+os6Hwv6O1HrzyJ98QxTrNTT73ydqZT86lIT6THg0rlmdk7WZVJp+cYb79
         VSQBI+tnugk3ydhom3jZS8tnZIg/LMQ/+daZl6ipNimxLUHySfGW1qNidXQ5y4ugfn
         7zOnfq4gX6tF6i2Y4cmV5AqAutC+gPVlpH+sALvZFwL2pw/Yj90MUAFYy9nP1Jf9h5
         TNn/pB4+8bbr08dbWP+BGkZhNYn5+LUJxLdGgvkFPj5NI9uoWrHgpiT8nSl+9n/lpS
         UJVUBIJ7eU9pA==
Date:   Thu, 25 May 2023 17:54:57 -0700
Subject: [PATCH 5/5] xfs: repair problems in CoW forks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506058784.3730621.16092881893247240968.stgit@frogsfrogsfrogs>
In-Reply-To: <168506058705.3730621.6175016885493289346.stgit@frogsfrogsfrogs>
References: <168506058705.3730621.6175016885493289346.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Try to repair errors that we see in file CoW forks so that we don't do
stupid things like remap garbage into a file.  There's not a lot we can
do with the COW fork -- the ondisk metadata record only that the COW
staging extents are owned by the refcount btree, which effectively means
that we can't reconstruct this incore structure from scratch.

Actually, this is even worse -- we can't touch written extents, because
those map space that are actively under writeback, and there's not much
to do with delalloc reservations.  Hence we can only detect crosslinked
unwritten extents and fix them by punching out the problematic parts and
replacing them with delalloc extents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile           |    1 
 fs/xfs/scrub/cow_repair.c |  609 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/reap.c       |   25 ++
 fs/xfs/scrub/repair.h     |    2 
 fs/xfs/scrub/scrub.c      |    2 
 fs/xfs/scrub/trace.h      |   84 ++++++
 6 files changed, 722 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/cow_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 60f4c8c508f6..d3da47be96d4 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -181,6 +181,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   alloc_repair.o \
 				   bmap_repair.o \
+				   cow_repair.o \
 				   ialloc_repair.o \
 				   inode_repair.o \
 				   newbt.o \
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
new file mode 100644
index 000000000000..551b2fb78ab4
--- /dev/null
+++ b/fs/xfs/scrub/cow_repair.c
@@ -0,0 +1,609 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
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
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+#include "xfs_inode_fork.h"
+#include "xfs_alloc.h"
+#include "xfs_bmap.h"
+#include "xfs_rmap.h"
+#include "xfs_refcount.h"
+#include "xfs_quota.h"
+#include "xfs_ialloc.h"
+#include "xfs_ag.h"
+#include "xfs_error.h"
+#include "xfs_errortag.h"
+#include "xfs_icache.h"
+#include "xfs_refcount_btree.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/bitmap.h"
+#include "scrub/reap.h"
+
+/*
+ * CoW Fork Mapping Repair
+ * =======================
+ *
+ * Although CoW staging extents are owned by incore CoW inode forks, on disk
+ * they are owned by the refcount btree.  The ondisk metadata does not record
+ * any ownership information, which limits what we can do to repair the
+ * mappings in the CoW fork.  At most, we can replace ifork mappings that lack
+ * an entry in the refcount btree or are described by a reverse mapping record
+ * whose owner is not OWN_COW.
+ *
+ * Replacing extents is also tricky -- we can't touch written CoW fork extents
+ * since they are undergoing writeback, and delalloc extents do not require
+ * repair since they only exist incore.  Hence the most we can do is find the
+ * bad parts of unwritten mappings, allocate a replacement set of blocks, and
+ * replace the incore mapping.  We use the regular reaping process to unmap
+ * or free the discarded blocks, as appropriate.
+ */
+struct xrep_cow {
+	struct xfs_scrub	*sc;
+
+	/* Bitmap of file offset ranges that need replacing. */
+	struct xbitmap		bad_fileoffs;
+
+	/* Bitmap of fsblocks that were removed from the CoW fork. */
+	struct xfsb_bitmap	old_cowfork_fsblocks;
+
+	/* CoW fork mappings used to scan for bad CoW staging extents. */
+	struct xfs_bmbt_irec	irec;
+
+	/* refcount btree block number of irec.br_startblock */
+	unsigned int		irec_startbno;
+
+	/* refcount btree block number of the next refcount record we expect */
+	unsigned int		next_bno;
+};
+
+/* CoW staging extent. */
+struct xrep_cow_extent {
+	xfs_fsblock_t		fsbno;
+	xfs_extlen_t		len;
+};
+
+/*
+ * Mark the part of the file range that corresponds to the given physical
+ * space.  Caller must ensure that the physical range is within xc->irec.
+ */
+STATIC int
+xrep_cow_mark_file_range(
+	struct xrep_cow		*xc,
+	xfs_fsblock_t		startblock,
+	xfs_filblks_t		blockcount)
+{
+	xfs_fileoff_t		startoff;
+
+	startoff = xc->irec.br_startoff +
+				(startblock - xc->irec.br_startblock);
+
+	trace_xrep_cow_mark_file_range(xc->sc->ip, startblock, startoff,
+			blockcount);
+
+	return xbitmap_set(&xc->bad_fileoffs, startoff, blockcount);
+}
+
+/*
+ * Trim @src to fit within the CoW fork mapping being examined, and put the
+ * result in @dst.
+ */
+static inline void
+xrep_cow_trim_refcount(
+	struct xrep_cow			*xc,
+	struct xfs_refcount_irec	*dst,
+	const struct xfs_refcount_irec	*src)
+{
+	unsigned int			adj;
+
+	memcpy(dst, src, sizeof(*dst));
+
+	if (dst->rc_startblock < xc->irec_startbno) {
+		adj = xc->irec_startbno - dst->rc_startblock;
+		dst->rc_blockcount -= adj;
+		dst->rc_startblock += adj;
+	}
+
+	if (dst->rc_startblock + dst->rc_blockcount >
+	    xc->irec_startbno + xc->irec.br_blockcount) {
+		adj = (dst->rc_startblock + dst->rc_blockcount) -
+		      (xc->irec_startbno + xc->irec.br_blockcount);
+		dst->rc_blockcount -= adj;
+	}
+}
+
+/* Mark any shared CoW staging extents. */
+STATIC int
+xrep_cow_mark_shared_staging(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*rec,
+	void				*priv)
+{
+	struct xrep_cow			*xc = priv;
+	struct xfs_refcount_irec	rrec;
+	xfs_fsblock_t			fsbno;
+
+	if (!xfs_refcount_check_domain(rec) ||
+	    rec->rc_domain != XFS_REFC_DOMAIN_SHARED)
+		return -EFSCORRUPTED;
+
+	xrep_cow_trim_refcount(xc, &rrec, rec);
+
+	fsbno = XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno,
+			rrec.rc_startblock);
+	return xrep_cow_mark_file_range(xc, fsbno, rrec.rc_blockcount);
+}
+
+/*
+ * Mark any portion of the CoW fork file offset range where there is not a CoW
+ * staging extent record in the refcountbt, and keep a record of where we did
+ * find correct refcountbt records.  Staging records are always cleaned out at
+ * mount time, so any two inodes trying to map the same staging area would have
+ * already taken the fs down due to refcount btree verifier errors.  Hence this
+ * inode should be the sole creator of the staging extent records ondisk.
+ */
+STATIC int
+xrep_cow_mark_missing_staging(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*rec,
+	void				*priv)
+{
+	struct xrep_cow			*xc = priv;
+	struct xfs_refcount_irec	rrec;
+	int				error;
+
+	if (!xfs_refcount_check_domain(rec) ||
+	    rec->rc_domain != XFS_REFC_DOMAIN_COW)
+		return -EFSCORRUPTED;
+
+	xrep_cow_trim_refcount(xc, &rrec, rec);
+
+	if (xc->next_bno >= rrec.rc_startblock)
+		goto next;
+
+	error = xrep_cow_mark_file_range(xc,
+			XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno,
+				       xc->next_bno),
+			rrec.rc_startblock - xc->next_bno);
+	if (error)
+		return error;
+
+next:
+	xc->next_bno = rrec.rc_startblock + rrec.rc_blockcount;
+	return 0;
+}
+
+/*
+ * Mark any area that does not correspond to a CoW staging rmap.  These are
+ * cross-linked areas that must be avoided.
+ */
+STATIC int
+xrep_cow_mark_missing_staging_rmap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xrep_cow			*xc = priv;
+	xfs_fsblock_t			fsbno;
+	xfs_agblock_t			rec_bno;
+	xfs_extlen_t			rec_len;
+	unsigned int			adj;
+
+	if (rec->rm_owner == XFS_RMAP_OWN_COW)
+		return 0;
+
+	rec_bno = rec->rm_startblock;
+	rec_len = rec->rm_blockcount;
+	if (rec_bno < xc->irec_startbno) {
+		adj = xc->irec_startbno - rec_bno;
+		rec_len -= adj;
+		rec_bno += adj;
+	}
+
+	if (rec_bno + rec_len > xc->irec_startbno + xc->irec.br_blockcount) {
+		adj = (rec_bno + rec_len) -
+		      (xc->irec_startbno + xc->irec.br_blockcount);
+		rec_len -= adj;
+	}
+
+	fsbno = XFS_AGB_TO_FSB(xc->sc->mp, cur->bc_ag.pag->pag_agno, rec_bno);
+	return xrep_cow_mark_file_range(xc, fsbno, rec_len);
+}
+
+/*
+ * Find any part of the CoW fork mapping that isn't a single-owner CoW staging
+ * extent and mark the corresponding part of the file range in the bitmap.
+ */
+STATIC int
+xrep_cow_find_bad(
+	struct xrep_cow			*xc)
+{
+	struct xfs_refcount_irec	rc_low = { 0 };
+	struct xfs_refcount_irec	rc_high = { 0 };
+	struct xfs_rmap_irec		rm_low = { 0 };
+	struct xfs_rmap_irec		rm_high = { 0 };
+	struct xfs_perag		*pag;
+	struct xfs_scrub		*sc = xc->sc;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	agno = XFS_FSB_TO_AGNO(sc->mp, xc->irec.br_startblock);
+	xc->irec_startbno = XFS_FSB_TO_AGBNO(sc->mp, xc->irec.br_startblock);
+
+	pag = xfs_perag_get(sc->mp, agno);
+	if (!pag)
+		return -EFSCORRUPTED;
+
+	error = xrep_ag_init(sc, pag, &sc->sa);
+	if (error)
+		goto out_pag;
+
+	/* Mark any CoW fork extents that are shared. */
+	rc_low.rc_startblock = xc->irec_startbno;
+	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_SHARED;
+	error = xfs_refcount_query_range(sc->sa.refc_cur, &rc_low, &rc_high,
+			xrep_cow_mark_shared_staging, xc);
+	if (error)
+		goto out_sa;
+
+	/* Make sure there are CoW staging extents for the whole mapping. */
+	rc_low.rc_startblock = xc->irec_startbno;
+	rc_high.rc_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	rc_low.rc_domain = rc_high.rc_domain = XFS_REFC_DOMAIN_COW;
+	xc->next_bno = xc->irec_startbno;
+	error = xfs_refcount_query_range(sc->sa.refc_cur, &rc_low, &rc_high,
+			xrep_cow_mark_missing_staging, xc);
+	if (error)
+		goto out_sa;
+
+	if (xc->next_bno < xc->irec_startbno + xc->irec.br_blockcount) {
+		error = xrep_cow_mark_file_range(xc,
+				XFS_AGB_TO_FSB(sc->mp, pag->pag_agno,
+					       xc->next_bno),
+				xc->irec_startbno + xc->irec.br_blockcount -
+				xc->next_bno);
+		if (error)
+			goto out_sa;
+	}
+
+	/* Mark any area has an rmap that isn't a COW staging extent. */
+	rm_low.rm_startblock = xc->irec_startbno;
+	memset(&rm_high, 0xFF, sizeof(rm_high));
+	rm_high.rm_startblock = xc->irec_startbno + xc->irec.br_blockcount - 1;
+	error = xfs_rmap_query_range(sc->sa.rmap_cur, &rm_low, &rm_high,
+			xrep_cow_mark_missing_staging_rmap, xc);
+	if (error)
+		goto out_sa;
+
+	/*
+	 * If userspace is forcing us to rebuild the CoW fork or someone turned
+	 * on the debugging knob, replace everything in the CoW fork.
+	 */
+	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
+	    XFS_TEST_ERROR(false, sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
+		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
+				xc->irec.br_blockcount);
+		if (error)
+			return error;
+	}
+
+out_sa:
+	xchk_ag_free(sc, &sc->sa);
+out_pag:
+	xfs_perag_put(pag);
+	return 0;
+}
+
+/*
+ * Allocate a replacement CoW staging extent of up to the given number of
+ * blocks, and fill out the mapping.
+ */
+STATIC int
+xrep_cow_alloc(
+	struct xfs_scrub	*sc,
+	xfs_filblks_t		maxlen,
+	struct xrep_cow_extent	*repl)
+{
+	struct xfs_alloc_arg	args = {
+		.tp		= sc->tp,
+		.mp		= sc->mp,
+		.oinfo		= XFS_RMAP_OINFO_SKIP_UPDATE,
+		.minlen		= 1,
+		.maxlen		= maxlen,
+		.prod		= 1,
+		.resv		= XFS_AG_RESV_NONE,
+		.datatype	= XFS_ALLOC_USERDATA,
+	};
+	int			error;
+
+	error = xfs_trans_reserve_more(sc->tp, maxlen, 0);
+	if (error)
+		return error;
+
+	error = xfs_alloc_vextent_start_ag(&args,
+			XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino));
+	if (error)
+		return error;
+	if (args.fsbno == NULLFSBLOCK)
+		return -ENOSPC;
+
+	xfs_refcount_alloc_cow_extent(sc->tp, args.fsbno, args.len);
+
+	repl->fsbno = args.fsbno;
+	repl->len = args.len;
+	return 0;
+}
+
+/*
+ * Look up the current CoW fork mapping so that we only allocate enough to
+ * replace a single mapping.  If we don't find a mapping that covers the start
+ * of the file range, or we find a delalloc or written extent, something is
+ * seriously wrong, since we didn't drop the ILOCK.
+ */
+static inline int
+xrep_cow_find_mapping(
+	struct xrep_cow		*xc,
+	struct xfs_iext_cursor	*icur,
+	xfs_fileoff_t		startoff,
+	struct xfs_bmbt_irec	*got)
+{
+	struct xfs_inode	*ip = xc->sc->ip;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_COW_FORK);
+
+	if (!xfs_iext_lookup_extent(ip, ifp, startoff, icur, got))
+		goto bad;
+
+	if (got->br_startoff > startoff)
+		goto bad;
+
+	if (got->br_blockcount == 0)
+		goto bad;
+
+	if (isnullstartblock(got->br_startblock))
+		goto bad;
+
+	if (xfs_bmap_is_written_extent(got))
+		goto bad;
+
+	return 0;
+bad:
+	ASSERT(0);
+	return -EFSCORRUPTED;
+}
+
+#define REPLACE_LEFT_SIDE	(1U << 0)
+#define REPLACE_RIGHT_SIDE	(1U << 1)
+
+/*
+ * Given a CoW fork mapping @got and a replacement mapping @repl, remap the
+ * beginning of @got with the space described by @rep.
+ */
+static inline void
+xrep_cow_replace_mapping(
+	struct xfs_inode		*ip,
+	struct xfs_iext_cursor		*icur,
+	const struct xfs_bmbt_irec	*got,
+	const struct xrep_cow_extent	*repl)
+{
+	struct xfs_bmbt_irec		new = *got; /* struct copy */
+
+	ASSERT(repl->len > 0);
+	ASSERT(!isnullstartblock(got->br_startblock));
+
+	trace_xrep_cow_replace_mapping(ip, got, repl->fsbno, repl->len);
+
+	if (got->br_blockcount == repl->len) {
+		/*
+		 * The new extent is a complete replacement for the existing
+		 * extent.  Update the COW fork record.
+		 */
+		new.br_startblock = repl->fsbno;
+		xfs_iext_update_extent(ip, BMAP_COWFORK, icur, &new);
+		return;
+	}
+
+	/*
+	 * The new extent can replace the beginning of the COW fork record.
+	 * Move the left side of @got upwards, then insert the new record.
+	 */
+	new.br_startoff += repl->len;
+	new.br_startblock += repl->len;
+	new.br_blockcount -= repl->len;
+	xfs_iext_update_extent(ip, BMAP_COWFORK, icur, &new);
+
+	new.br_startoff = got->br_startoff;
+	new.br_startblock = repl->fsbno;
+	new.br_blockcount = repl->len;
+	xfs_iext_insert(ip, icur, &new, BMAP_COWFORK);
+}
+
+/*
+ * Replace the unwritten CoW staging extent backing the given file range with a
+ * new space extent that isn't as problematic.
+ */
+STATIC int
+xrep_cow_replace_range(
+	struct xrep_cow		*xc,
+	xfs_fileoff_t		startoff,
+	xfs_extlen_t		*blockcount)
+{
+	struct xfs_iext_cursor	icur;
+	struct xrep_cow_extent	repl;
+	struct xfs_bmbt_irec	got;
+	struct xfs_scrub	*sc = xc->sc;
+	xfs_fileoff_t		nextoff;
+	int			error;
+
+	/*
+	 * Put the existing CoW fork mapping in @got.  If @got ends before
+	 * @rep, truncate @rep so we only replace one extent mapping at a time.
+	 */
+	error = xrep_cow_find_mapping(xc, &icur, startoff, &got);
+	if (error)
+		return error;
+	nextoff = min(startoff + *blockcount,
+		      got.br_startoff + got.br_blockcount);
+
+	/*
+	 * Allocate a replacement extent.  If we don't fill all the blocks,
+	 * shorten the quantity that will be deleted in this step.
+	 */
+	error = xrep_cow_alloc(sc, nextoff - startoff, &repl);
+	if (error)
+		return error;
+
+	/*
+	 * Replace the old mapping with the new one, and commit the metadata
+	 * changes made so far.
+	 */
+	xrep_cow_replace_mapping(sc->ip, &icur, &got, &repl);
+
+	xfs_inode_set_cowblocks_tag(sc->ip);
+	error = xfs_defer_finish(&sc->tp);
+	if (error)
+		return error;
+
+	/* Note the old CoW staging extents; we'll reap them all later. */
+	error = xfsb_bitmap_set(&xc->old_cowfork_fsblocks, got.br_startblock,
+			repl.len);
+	if (error)
+		return error;
+
+	*blockcount = repl.len;
+	return 0;
+}
+
+/*
+ * Replace a bad part of an unwritten CoW staging extent with a fresh delalloc
+ * reservation.
+ */
+STATIC int
+xrep_cow_replace(
+	uint64_t		startoff,
+	uint64_t		blockcount,
+	void			*priv)
+{
+	struct xrep_cow		*xc = priv;
+	int			error = 0;
+
+	while (blockcount > 0) {
+		xfs_extlen_t	len = min_t(xfs_filblks_t, blockcount,
+					    XFS_MAX_BMBT_EXTLEN);
+
+		error = xrep_cow_replace_range(xc, startoff, &len);
+		if (error)
+			break;
+
+		blockcount -= len;
+		startoff += len;
+	}
+
+	return error;
+}
+
+/*
+ * Repair an inode's CoW fork.  The CoW fork is an in-core structure, so
+ * there's no btree to rebuid.  Instead, we replace any mappings that are
+ * cross-linked or lack ondisk CoW fork records in the refcount btree.
+ */
+int
+xrep_bmap_cow(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_cow		*xc;
+	struct xfs_iext_cursor	icur;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, XFS_COW_FORK);
+	int			error;
+
+	if (!xfs_has_rmapbt(sc->mp) || !xfs_has_reflink(sc->mp))
+		return -EOPNOTSUPP;
+
+	if (!ifp)
+		return 0;
+
+	/* realtime files aren't supported yet */
+	if (XFS_IS_REALTIME_INODE(sc->ip))
+		return -EOPNOTSUPP;
+
+	/*
+	 * If we're somehow not in extents format, then reinitialize it to
+	 * an empty extent mapping fork and exit.
+	 */
+	if (ifp->if_format != XFS_DINODE_FMT_EXTENTS) {
+		ifp->if_format = XFS_DINODE_FMT_EXTENTS;
+		ifp->if_nextents = 0;
+		return 0;
+	}
+
+	xc = kzalloc(sizeof(struct xrep_cow), XCHK_GFP_FLAGS);
+	if (!xc)
+		return -ENOMEM;
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	xc->sc = sc;
+	xbitmap_init(&xc->bad_fileoffs);
+	xfsb_bitmap_init(&xc->old_cowfork_fsblocks);
+
+	for_each_xfs_iext(ifp, &icur, &xc->irec) {
+		if (xchk_should_terminate(sc, &error))
+			goto out_bitmap;
+
+		/*
+		 * delalloc reservations only exist incore, so there is no
+		 * ondisk metadata that we can examine.  Hence we leave them
+		 * alone.
+		 */
+		if (isnullstartblock(xc->irec.br_startblock))
+			continue;
+
+		/*
+		 * COW fork extents are only in the written state if writeback
+		 * is actively writing to disk.  We cannot restart the write
+		 * at a different disk address since we've already issued the
+		 * IO, so we leave these alone and hope for the best.
+		 */
+		if (xfs_bmap_is_written_extent(&xc->irec))
+			continue;
+
+		error = xrep_cow_find_bad(xc);
+		if (error)
+			goto out_bitmap;
+	}
+
+	/* Replace any bad unwritten mappings with fresh reservations. */
+	error = xbitmap_walk(&xc->bad_fileoffs, xrep_cow_replace, xc);
+	if (error)
+		goto out_bitmap;
+
+	/*
+	 * Reap as many of the old CoW blocks as we can.  They are owned ondisk
+	 * by the refcount btree, not the inode, so it is correct to treat them
+	 * like inode metadata.
+	 */
+	error = xrep_reap_fsblocks(sc, &xc->old_cowfork_fsblocks,
+			&XFS_RMAP_OINFO_COW);
+	if (error)
+		goto out_bitmap;
+
+out_bitmap:
+	xfsb_bitmap_destroy(&xc->old_cowfork_fsblocks);
+	xbitmap_destroy(&xc->bad_fileoffs);
+	kmem_free(xc);
+	return error;
+}
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index f904cad5a3c4..d39c14f7cbcf 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -20,6 +20,7 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_extent_busy.h"
 #include "xfs_ag.h"
@@ -313,6 +314,14 @@ xreap_agextent(
 		trace_xreap_dispose_unmap_extent(sc->sa.pag, agbno, *aglenp);
 
 		rs->force_roll = true;
+		if (rs->oinfo == &XFS_RMAP_OINFO_COW) {
+			/*
+			 * If we're unmapping CoW staging extents, remove the
+			 * records from the refcountbt as well.
+			 */
+			xfs_refcount_free_cow_extent(sc->tp, fsbno, *aglenp);
+			return 0;
+		}
 		return xfs_rmap_free(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno,
 				*aglenp, rs->oinfo);
 	}
@@ -331,6 +340,22 @@ xreap_agextent(
 		return 0;
 	}
 
+	/*
+	 * If we're getting rid of CoW staging extents, use deferred work items
+	 * to remove the refcountbt records (which removes the rmap records)
+	 * and free the extent.  We're not worried about the system going down
+	 * here because log recovery walks the refcount btree to clean out the
+	 * CoW staging extents.
+	 */
+	if (rs->oinfo == &XFS_RMAP_OINFO_COW) {
+		ASSERT(rs->resv == XFS_AG_RESV_NONE);
+
+		rs->force_roll = true;
+		xfs_refcount_free_cow_extent(sc->tp, fsbno, *aglenp);
+		__xfs_free_extent_later(sc->tp, fsbno, *aglenp, NULL, true);
+		return 0;
+	}
+
 	switch (rs->resv) {
 	case XFS_AG_RESV_AGFL:
 		ASSERT(*aglenp == 1);
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index df59f15e0379..2c6733941356 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -101,6 +101,7 @@ int xrep_refcountbt(struct xfs_scrub *sc);
 int xrep_inode(struct xfs_scrub *sc);
 int xrep_bmap_data(struct xfs_scrub *sc);
 int xrep_bmap_attr(struct xfs_scrub *sc);
+int xrep_bmap_cow(struct xfs_scrub *sc);
 
 int xrep_reinit_pagf(struct xfs_scrub *sc);
 int xrep_reinit_pagi(struct xfs_scrub *sc);
@@ -162,6 +163,7 @@ xrep_setup_nothing(
 #define xrep_inode			xrep_notsupported
 #define xrep_bmap_data			xrep_notsupported
 #define xrep_bmap_attr			xrep_notsupported
+#define xrep_bmap_cow			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index da65e5bf0bc1..00bf8d2dfa43 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -297,7 +297,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_inode_bmap,
 		.scrub	= xchk_bmap_cow,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_bmap_cow,
 	},
 	[XFS_SCRUB_TYPE_DIR] = {	/* directory */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cc2e59c7deff..d900f435fd02 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1552,6 +1552,90 @@ TRACE_EVENT(xrep_dinode_count_rmaps,
 		  __entry->block0)
 );
 
+TRACE_EVENT(xrep_cow_mark_file_range,
+	TP_PROTO(struct xfs_inode *ip, xfs_fsblock_t startblock,
+		 xfs_fileoff_t startoff, xfs_filblks_t blockcount),
+	TP_ARGS(ip, startblock, startoff, blockcount),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsblock_t, startblock)
+		__field(xfs_fileoff_t, startoff)
+		__field(xfs_filblks_t, blockcount)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->startoff = startoff;
+		__entry->startblock = startblock;
+		__entry->blockcount = blockcount;
+	),
+	TP_printk("dev %d:%d ino 0x%llx fileoff 0x%llx startblock 0x%llx fsbcount 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->startoff,
+		  __entry->startblock,
+		  __entry->blockcount)
+);
+
+TRACE_EVENT(xrep_cow_replace_mapping,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_bmbt_irec *irec,
+		 xfs_fsblock_t new_startblock, xfs_extlen_t new_blockcount),
+	TP_ARGS(ip, irec, new_startblock, new_blockcount),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsblock_t, startblock)
+		__field(xfs_fileoff_t, startoff)
+		__field(xfs_filblks_t, blockcount)
+		__field(xfs_exntst_t, state)
+		__field(xfs_fsblock_t, new_startblock)
+		__field(xfs_extlen_t, new_blockcount)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->startoff = irec->br_startoff;
+		__entry->startblock = irec->br_startblock;
+		__entry->blockcount = irec->br_blockcount;
+		__entry->state = irec->br_state;
+		__entry->new_startblock = new_startblock;
+		__entry->new_blockcount = new_blockcount;
+	),
+	TP_printk("dev %d:%d ino 0x%llx startoff 0x%llx startblock 0x%llx fsbcount 0x%llx state 0x%x new_startblock 0x%llx new_fsbcount 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->startoff,
+		  __entry->startblock,
+		  __entry->blockcount,
+		  __entry->state,
+		  __entry->new_startblock,
+		  __entry->new_blockcount)
+);
+
+TRACE_EVENT(xrep_cow_free_staging,
+	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno,
+		 xfs_extlen_t blockcount),
+	TP_ARGS(pag, agbno, blockcount),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, blockcount)
+	),
+	TP_fast_assign(
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->agbno = agbno;
+		__entry->blockcount = blockcount;
+	),
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->blockcount)
+);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

