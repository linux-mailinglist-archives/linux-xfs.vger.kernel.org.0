Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29167711B85
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 02:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbjEZApY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 20:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240779AbjEZApX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:45:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A151194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:45:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8919363A6B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E85C433EF;
        Fri, 26 May 2023 00:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061920;
        bh=YqwTdA+I0uX9Ena+WkHvJPt+V61eZW72fhcXjCEtLl0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hBE6y7ms/jhNbNgFFSy4p5AARaYRC+vaCxu6i0pilRmpud+eGCZYz4gWmSdWCmAm2
         fZ47r1IBqGzuYAoCdrvx60qVAdVMjK5z8VBryWP4oQ+M3A2cg8rM3XZq30oDsI1r0r
         ijshGDsSglRIIwUVbxwtfgh66lKlnh4K9JNhaYBZUxB/pboxM5O14KFeiuPTw0DdSd
         /+RBa7vx9ERtJAGpXYDexLawJyzrF/SrH9M/v2GORB+lmvEpQNM0suM8vQMndGXx4s
         nvOwcSNS07cFKoi5QeP/xHAjcU7qIpNSaBpqBX5+pnPE4D/d5LK/XHIldSbgPSSGqd
         FZmqv1XqiiqaQ==
Date:   Thu, 25 May 2023 17:45:19 -0700
Subject: [PATCH 9/9] xfs: use per-AG bitmaps to reap unused AG metadata blocks
 during repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506055748.3728180.3343593199301204602.stgit@frogsfrogsfrogs>
In-Reply-To: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
References: <168506055606.3728180.16225214578338421625.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The AGFL repair code uses a series of bitmaps to figure out where there
are OWN_AG blocks that are not claimed by the free space and rmap
btrees.  These blocks become the new AGFL, and any overflow is reaped.
The bitmaps current track xfs_fsblock_t even though we already know the
AG number.

In the last patch, we introduced a new bitmap "type" for tracking
xfs_agblock_t extents.  Port the reaping code and the AGFL repair to use
this new type, which makes it very obvious what we're tracking.  This
also eliminates a bunch of unnecessary agblock <-> fsblock conversions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |   74 ++++++++++++++++++----------------------
 fs/xfs/scrub/bitmap.c          |   41 ++--------------------
 fs/xfs/scrub/bitmap.h          |    6 +--
 fs/xfs/scrub/reap.c            |   14 ++------
 fs/xfs/scrub/reap.h            |    5 +--
 5 files changed, 45 insertions(+), 95 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 9ad2987ed6e5..9e99486b5f20 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -445,13 +445,13 @@ xrep_agf(
 
 struct xrep_agfl {
 	/* Bitmap of alleged AGFL blocks that we're not going to add. */
-	struct xbitmap		crossed;
+	struct xagb_bitmap	crossed;
 
 	/* Bitmap of other OWN_AG metadata blocks. */
-	struct xbitmap		agmetablocks;
+	struct xagb_bitmap	agmetablocks;
 
 	/* Bitmap of free space. */
-	struct xbitmap		*freesp;
+	struct xagb_bitmap	*freesp;
 
 	/* rmapbt cursor for finding crosslinked blocks */
 	struct xfs_btree_cur	*rmap_cur;
@@ -467,7 +467,6 @@ xrep_agfl_walk_rmap(
 	void			*priv)
 {
 	struct xrep_agfl	*ra = priv;
-	xfs_fsblock_t		fsb;
 	int			error = 0;
 
 	if (xchk_should_terminate(ra->sc, &error))
@@ -475,14 +474,13 @@ xrep_agfl_walk_rmap(
 
 	/* Record all the OWN_AG blocks. */
 	if (rec->rm_owner == XFS_RMAP_OWN_AG) {
-		fsb = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-				rec->rm_startblock);
-		error = xbitmap_set(ra->freesp, fsb, rec->rm_blockcount);
+		error = xagb_bitmap_set(ra->freesp, rec->rm_startblock,
+				rec->rm_blockcount);
 		if (error)
 			return error;
 	}
 
-	return xbitmap_set_btcur_path(&ra->agmetablocks, cur);
+	return xagb_bitmap_set_btcur_path(&ra->agmetablocks, cur);
 }
 
 /* Strike out the blocks that are cross-linked according to the rmapbt. */
@@ -493,12 +491,10 @@ xrep_agfl_check_extent(
 	void			*priv)
 {
 	struct xrep_agfl	*ra = priv;
-	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(ra->sc->mp, start);
+	xfs_agblock_t		agbno = start;
 	xfs_agblock_t		last_agbno = agbno + len - 1;
 	int			error;
 
-	ASSERT(XFS_FSB_TO_AGNO(ra->sc->mp, start) == ra->sc->sa.pag->pag_agno);
-
 	while (agbno <= last_agbno) {
 		bool		other_owners;
 
@@ -508,7 +504,7 @@ xrep_agfl_check_extent(
 			return error;
 
 		if (other_owners) {
-			error = xbitmap_set(&ra->crossed, agbno, 1);
+			error = xagb_bitmap_set(&ra->crossed, agbno, 1);
 			if (error)
 				return error;
 		}
@@ -534,7 +530,7 @@ STATIC int
 xrep_agfl_collect_blocks(
 	struct xfs_scrub	*sc,
 	struct xfs_buf		*agf_bp,
-	struct xbitmap		*agfl_extents,
+	struct xagb_bitmap	*agfl_extents,
 	xfs_agblock_t		*flcount)
 {
 	struct xrep_agfl	ra;
@@ -544,8 +540,8 @@ xrep_agfl_collect_blocks(
 
 	ra.sc = sc;
 	ra.freesp = agfl_extents;
-	xbitmap_init(&ra.agmetablocks);
-	xbitmap_init(&ra.crossed);
+	xagb_bitmap_init(&ra.agmetablocks);
+	xagb_bitmap_init(&ra.crossed);
 
 	/* Find all space used by the free space btrees & rmapbt. */
 	cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
@@ -557,7 +553,7 @@ xrep_agfl_collect_blocks(
 	/* Find all blocks currently being used by the bnobt. */
 	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp,
 			sc->sa.pag, XFS_BTNUM_BNO);
-	error = xbitmap_set_btblocks(&ra.agmetablocks, cur);
+	error = xagb_bitmap_set_btblocks(&ra.agmetablocks, cur);
 	xfs_btree_del_cursor(cur, error);
 	if (error)
 		goto out_bmp;
@@ -565,7 +561,7 @@ xrep_agfl_collect_blocks(
 	/* Find all blocks currently being used by the cntbt. */
 	cur = xfs_allocbt_init_cursor(mp, sc->tp, agf_bp,
 			sc->sa.pag, XFS_BTNUM_CNT);
-	error = xbitmap_set_btblocks(&ra.agmetablocks, cur);
+	error = xagb_bitmap_set_btblocks(&ra.agmetablocks, cur);
 	xfs_btree_del_cursor(cur, error);
 	if (error)
 		goto out_bmp;
@@ -574,17 +570,17 @@ xrep_agfl_collect_blocks(
 	 * Drop the freesp meta blocks that are in use by btrees.
 	 * The remaining blocks /should/ be AGFL blocks.
 	 */
-	error = xbitmap_disunion(agfl_extents, &ra.agmetablocks);
+	error = xagb_bitmap_disunion(agfl_extents, &ra.agmetablocks);
 	if (error)
 		goto out_bmp;
 
 	/* Strike out the blocks that are cross-linked. */
 	ra.rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, agf_bp, sc->sa.pag);
-	error = xbitmap_walk(agfl_extents, xrep_agfl_check_extent, &ra);
+	error = xagb_bitmap_walk(agfl_extents, xrep_agfl_check_extent, &ra);
 	xfs_btree_del_cursor(ra.rmap_cur, error);
 	if (error)
 		goto out_bmp;
-	error = xbitmap_disunion(agfl_extents, &ra.crossed);
+	error = xagb_bitmap_disunion(agfl_extents, &ra.crossed);
 	if (error)
 		goto out_bmp;
 
@@ -592,12 +588,12 @@ xrep_agfl_collect_blocks(
 	 * Calculate the new AGFL size.  If we found more blocks than fit in
 	 * the AGFL we'll free them later.
 	 */
-	*flcount = min_t(uint64_t, xbitmap_hweight(agfl_extents),
+	*flcount = min_t(uint64_t, xagb_bitmap_hweight(agfl_extents),
 			 xfs_agfl_size(mp));
 
 out_bmp:
-	xbitmap_destroy(&ra.crossed);
-	xbitmap_destroy(&ra.agmetablocks);
+	xagb_bitmap_destroy(&ra.crossed);
+	xagb_bitmap_destroy(&ra.agmetablocks);
 	return error;
 }
 
@@ -627,7 +623,7 @@ xrep_agfl_update_agf(
 }
 
 struct xrep_agfl_fill {
-	struct xbitmap		used_extents;
+	struct xagb_bitmap	used_extents;
 	struct xfs_scrub	*sc;
 	__be32			*agfl_bno;
 	xfs_agblock_t		flcount;
@@ -643,17 +639,15 @@ xrep_agfl_fill(
 {
 	struct xrep_agfl_fill	*af = priv;
 	struct xfs_scrub	*sc = af->sc;
-	xfs_fsblock_t		fsbno = start;
+	xfs_agblock_t		agbno = start;
 	int			error;
 
-	trace_xrep_agfl_insert(sc->sa.pag, XFS_FSB_TO_AGBNO(sc->mp, start),
-			len);
+	trace_xrep_agfl_insert(sc->sa.pag, agbno, len);
 
-	while (fsbno < start + len && af->fl_off < af->flcount)
-		af->agfl_bno[af->fl_off++] =
-				cpu_to_be32(XFS_FSB_TO_AGBNO(sc->mp, fsbno++));
+	while (agbno < start + len && af->fl_off < af->flcount)
+		af->agfl_bno[af->fl_off++] = cpu_to_be32(agbno++);
 
-	error = xbitmap_set(&af->used_extents, start, fsbno - 1);
+	error = xagb_bitmap_set(&af->used_extents, start, agbno - 1);
 	if (error)
 		return error;
 
@@ -668,7 +662,7 @@ STATIC int
 xrep_agfl_init_header(
 	struct xfs_scrub	*sc,
 	struct xfs_buf		*agfl_bp,
-	struct xbitmap		*agfl_extents,
+	struct xagb_bitmap	*agfl_extents,
 	xfs_agblock_t		flcount)
 {
 	struct xrep_agfl_fill	af = {
@@ -696,17 +690,17 @@ xrep_agfl_init_header(
 	 * blocks than fit in the AGFL, they will be freed in a subsequent
 	 * step.
 	 */
-	xbitmap_init(&af.used_extents);
+	xagb_bitmap_init(&af.used_extents);
 	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp),
-	xbitmap_walk(agfl_extents, xrep_agfl_fill, &af);
-	error = xbitmap_disunion(agfl_extents, &af.used_extents);
+	xagb_bitmap_walk(agfl_extents, xrep_agfl_fill, &af);
+	error = xagb_bitmap_disunion(agfl_extents, &af.used_extents);
 	if (error)
 		return error;
 
 	/* Write new AGFL to disk. */
 	xfs_trans_buf_set_type(sc->tp, agfl_bp, XFS_BLFT_AGFL_BUF);
 	xfs_trans_log_buf(sc->tp, agfl_bp, 0, BBTOB(agfl_bp->b_length) - 1);
-	xbitmap_destroy(&af.used_extents);
+	xagb_bitmap_destroy(&af.used_extents);
 	return 0;
 }
 
@@ -715,7 +709,7 @@ int
 xrep_agfl(
 	struct xfs_scrub	*sc)
 {
-	struct xbitmap		agfl_extents;
+	struct xagb_bitmap	agfl_extents;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_buf		*agf_bp;
 	struct xfs_buf		*agfl_bp;
@@ -726,7 +720,7 @@ xrep_agfl(
 	if (!xfs_has_rmapbt(mp))
 		return -EOPNOTSUPP;
 
-	xbitmap_init(&agfl_extents);
+	xagb_bitmap_init(&agfl_extents);
 
 	/*
 	 * Read the AGF so that we can query the rmapbt.  We hope that there's
@@ -775,10 +769,10 @@ xrep_agfl(
 		goto err;
 
 	/* Dump any AGFL overflow. */
-	error = xrep_reap_ag_metadata(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
+	error = xrep_reap_agblocks(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
 			XFS_AG_RESV_AGFL);
 err:
-	xbitmap_destroy(&agfl_extents);
+	xagb_bitmap_destroy(&agfl_extents);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index d926d708f295..e0c89a9a0ca0 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -301,21 +301,15 @@ xagb_bitmap_set_btblocks(
  * blocks going from the leaf towards the root.
  */
 int
-xbitmap_set_btcur_path(
-	struct xbitmap		*bitmap,
+xagb_bitmap_set_btcur_path(
+	struct xagb_bitmap	*bitmap,
 	struct xfs_btree_cur	*cur)
 {
-	struct xfs_buf		*bp;
-	xfs_fsblock_t		fsb;
 	int			i;
 	int			error;
 
 	for (i = 0; i < cur->bc_nlevels && cur->bc_levels[i].ptr == 1; i++) {
-		xfs_btree_get_block(cur, i, &bp);
-		if (!bp)
-			continue;
-		fsb = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
-		error = xbitmap_set(bitmap, fsb, 1);
+		error = xagb_bitmap_visit_btblock(cur, i, bitmap);
 		if (error)
 			return error;
 	}
@@ -323,35 +317,6 @@ xbitmap_set_btcur_path(
 	return 0;
 }
 
-/* Collect a btree's block in the bitmap. */
-STATIC int
-xbitmap_collect_btblock(
-	struct xfs_btree_cur	*cur,
-	int			level,
-	void			*priv)
-{
-	struct xbitmap		*bitmap = priv;
-	struct xfs_buf		*bp;
-	xfs_fsblock_t		fsbno;
-
-	xfs_btree_get_block(cur, level, &bp);
-	if (!bp)
-		return 0;
-
-	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
-	return xbitmap_set(bitmap, fsbno, 1);
-}
-
-/* Walk the btree and mark the bitmap wherever a btree block is found. */
-int
-xbitmap_set_btblocks(
-	struct xbitmap		*bitmap,
-	struct xfs_btree_cur	*cur)
-{
-	return xfs_btree_visit_blocks(cur, xbitmap_collect_btblock,
-			XFS_BTREE_VISIT_ALL, bitmap);
-}
-
 /* How many bits are set in this bitmap? */
 uint64_t
 xbitmap_hweight(
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index a3ad564d94b7..4fe58bad6734 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -16,10 +16,6 @@ void xbitmap_destroy(struct xbitmap *bitmap);
 int xbitmap_clear(struct xbitmap *bitmap, uint64_t start, uint64_t len);
 int xbitmap_set(struct xbitmap *bitmap, uint64_t start, uint64_t len);
 int xbitmap_disunion(struct xbitmap *bitmap, struct xbitmap *sub);
-int xbitmap_set_btcur_path(struct xbitmap *bitmap,
-		struct xfs_btree_cur *cur);
-int xbitmap_set_btblocks(struct xbitmap *bitmap,
-		struct xfs_btree_cur *cur);
 uint64_t xbitmap_hweight(struct xbitmap *bitmap);
 
 /*
@@ -106,5 +102,7 @@ static inline int xagb_bitmap_walk(struct xagb_bitmap *bitmap,
 
 int xagb_bitmap_set_btblocks(struct xagb_bitmap *bitmap,
 		struct xfs_btree_cur *cur);
+int xagb_bitmap_set_btcur_path(struct xagb_bitmap *bitmap,
+		struct xfs_btree_cur *cur);
 
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 4f57b428ffe2..6d1d731c4019 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -422,19 +422,13 @@ xreap_agmeta_extent(
 {
 	struct xreap_state	*rs = priv;
 	struct xfs_scrub	*sc = rs->sc;
-	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
-	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
+	xfs_agblock_t		agbno = fsbno;
 	xfs_agblock_t		agbno_next = agbno + len;
 	int			error = 0;
 
 	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(sc->ip == NULL);
 
-	if (agno != sc->sa.pag->pag_agno) {
-		ASSERT(sc->sa.pag->pag_agno == agno);
-		return -EFSCORRUPTED;
-	}
-
 	while (agbno < agbno_next) {
 		xfs_extlen_t	aglen;
 		bool		crosslinked;
@@ -468,9 +462,9 @@ xreap_agmeta_extent(
 
 /* Dispose of every block of every AG metadata extent in the bitmap. */
 int
-xrep_reap_ag_metadata(
+xrep_reap_agblocks(
 	struct xfs_scrub		*sc,
-	struct xbitmap			*bitmap,
+	struct xagb_bitmap		*bitmap,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type)
 {
@@ -484,7 +478,7 @@ xrep_reap_ag_metadata(
 	ASSERT(xfs_has_rmapbt(sc->mp));
 	ASSERT(sc->ip == NULL);
 
-	error = xbitmap_walk(bitmap, xreap_agmeta_extent, &rs);
+	error = xagb_bitmap_walk(bitmap, xreap_agmeta_extent, &rs);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/reap.h b/fs/xfs/scrub/reap.h
index 7f234abfa78d..fe24626af164 100644
--- a/fs/xfs/scrub/reap.h
+++ b/fs/xfs/scrub/reap.h
@@ -6,8 +6,7 @@
 #ifndef __XFS_SCRUB_REAP_H__
 #define __XFS_SCRUB_REAP_H__
 
-int xrep_reap_ag_metadata(struct xfs_scrub *sc, struct xbitmap *bitmap,
-		const struct xfs_owner_info *oinfo,
-		enum xfs_ag_resv_type type);
+int xrep_reap_agblocks(struct xfs_scrub *sc, struct xagb_bitmap *bitmap,
+		const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
 
 #endif /* __XFS_SCRUB_REAP_H__ */

