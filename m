Return-Path: <linux-xfs+bounces-15035-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7790F9BD836
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2024 23:12:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BA131C20E92
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2024 22:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D864A1FEFCD;
	Tue,  5 Nov 2024 22:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rgZlgSOe"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988351F667B
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844717; cv=none; b=mEllVof4ew8ixi0aTcRTj9sl1E8ewNFUDP1pqmoaU+hyRibN06QJk+AtAavgjWtWGAVg2JRH433MDM+uX9OctesQC1IPjLXMcVp1GGMRerlZVXHZ2RFF3Jxx0/dgEQMsqnIljy5+4vFREIzuxDEelyQnu1HBrSTNJ0Fu1h0Dsmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844717; c=relaxed/simple;
	bh=AL2fZQ0L7xZlo0o4nrkxyKSUoNX++LlZsWSy7QuOZUw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kQUExhU6546uVBsZvBf9HBdF0TUiMQaQd1hmi77B5G3E/rvd/AjkyHQnUDgKYBulJioEKJolGx/pnmCswJ8VssEMOgIMDPhIsDisCg+EGusnGNu9TS7jPqdDMOjcm0KNM1yI2WnXOA96EcDFYyWxs5Z+ROgdhNqiz6Zw7ZveDg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rgZlgSOe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB18C4CECF;
	Tue,  5 Nov 2024 22:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844717;
	bh=AL2fZQ0L7xZlo0o4nrkxyKSUoNX++LlZsWSy7QuOZUw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rgZlgSOePUcxlD+Y1zsvp6VAqTCAbHMnDRnu4lvuSwFPqLWSe4cAcEGojH+W0COlu
	 xpOFvgwWCVOw8+aTAQZLFMtmPqVRKNkR+Y8Pcs5ffrURsT7JYGeZoFTsAuTyd81oCE
	 q7iNHOClxzbT1xNGskXMnZVn4KNeUmj6McmQtaVF6seEvq0ahVKi0ggNhDr7zJ6UIW
	 ZaMWz2oPRJioadofFC539/T0HLlWFuPeHUpEm4TweMT62Ed0SYLY/Ot/NQrdQlUCES
	 HzdBok0QpJgt+fozfnqxlOHgpqBW8UiAR/3522SgWBGYEH4lR0I3a6pe2yoMWuqd60
	 gRyc9mDRz1N8w==
Date: Tue, 05 Nov 2024 14:11:56 -0800
Subject: [PATCH 21/23] xfs: convert remaining trace points to pass pag
 structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394811.1868694.2646581930915630816.stgit@frogsfrogsfrogs>
In-Reply-To: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
References: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Convert all tracepoints that take [mp,agno] tuples to take a pag argument
instead so that decoding only happens when tracepoints are enabled and to
clean up the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c      |    4 +-
 fs/xfs/libxfs/xfs_ialloc.c     |    4 +-
 fs/xfs/libxfs/xfs_inode_util.c |    4 +-
 fs/xfs/scrub/alloc_repair.c    |    2 -
 fs/xfs/scrub/ialloc.c          |    3 -
 fs/xfs/scrub/ialloc_repair.c   |    2 -
 fs/xfs/scrub/repair.c          |    2 -
 fs/xfs/scrub/rmap_repair.c     |    4 +-
 fs/xfs/scrub/trace.h           |   61 ++++++++++++++---------------
 fs/xfs/xfs_discard.c           |   11 ++---
 fs/xfs/xfs_extent_busy.c       |   13 ++----
 fs/xfs/xfs_health.c            |    8 ++--
 fs/xfs/xfs_iwalk.c             |    2 -
 fs/xfs/xfs_trace.h             |   84 ++++++++++++++++++++--------------------
 14 files changed, 98 insertions(+), 106 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6970a47bea1bd2..cd5c44a75cd138 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3360,7 +3360,7 @@ xfs_read_agf(
 	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
-	trace_xfs_read_agf(pag->pag_mount, pag->pag_agno);
+	trace_xfs_read_agf(pag);
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGF_DADDR(mp)),
@@ -3391,7 +3391,7 @@ xfs_alloc_read_agf(
 	int			error;
 	int			allocbt_blks;
 
-	trace_xfs_alloc_read_agf(pag->pag_mount, pag->pag_agno);
+	trace_xfs_alloc_read_agf(pag);
 
 	/* We don't support trylock when freeing. */
 	ASSERT((flags & (XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK)) !=
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 085032443f1267..f5167847f05119 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2729,7 +2729,7 @@ xfs_read_agi(
 	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
-	trace_xfs_read_agi(pag->pag_mount, pag->pag_agno);
+	trace_xfs_read_agi(pag);
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGI_DADDR(mp)),
@@ -2760,7 +2760,7 @@ xfs_ialloc_read_agi(
 	struct xfs_agi		*agi;
 	int			error;
 
-	trace_xfs_ialloc_read_agi(pag->pag_mount, pag->pag_agno);
+	trace_xfs_ialloc_read_agi(pag);
 
 	error = xfs_read_agi(pag, tp,
 			(flags & XFS_IALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index cc38e1c3c3e1d3..ec64eda3bbe2e1 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -442,8 +442,8 @@ xfs_iunlink_update_bucket(
 	ASSERT(xfs_verify_agino_or_null(pag, new_agino));
 
 	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	trace_xfs_iunlink_update_bucket(tp->t_mountp, pag->pag_agno, bucket_index,
-			old_value, new_agino);
+	trace_xfs_iunlink_update_bucket(pag, bucket_index, old_value,
+			new_agino);
 
 	/*
 	 * We should never find the head of the list already set to the value
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 6fd0e193f0b739..1e0c2db6dcf7df 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -210,7 +210,7 @@ xrep_abt_stash(
 	if (error)
 		return error;
 
-	trace_xrep_abt_found(sc->mp, sc->sa.pag->pag_agno, &arec);
+	trace_xrep_abt_found(sc->sa.pag, &arec);
 
 	error = xfarray_append(ra->free_records, &arec);
 	if (error)
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index c1c798076d66ab..ee71cf2050b72e 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -367,7 +367,6 @@ xchk_iallocbt_check_cluster(
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_buf			*cluster_bp;
 	unsigned int			nr_inodes;
-	xfs_agnumber_t			agno = bs->cur->bc_ag.pag->pag_agno;
 	xfs_agblock_t			agbno;
 	unsigned int			cluster_index;
 	uint16_t			cluster_mask = 0;
@@ -406,7 +405,7 @@ xchk_iallocbt_check_cluster(
 		return 0;
 	}
 
-	trace_xchk_iallocbt_check_cluster(mp, agno, irec->ir_startino,
+	trace_xchk_iallocbt_check_cluster(bs->cur->bc_ag.pag, irec->ir_startino,
 			imap.im_blkno, imap.im_len, cluster_base, nr_inodes,
 			cluster_mask, ir_holemask,
 			XFS_INO_TO_OFFSET(mp, irec->ir_startino +
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index f1c24f2da497ed..ffa0d67508aa00 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -192,7 +192,7 @@ xrep_ibt_stash(
 	if (ri->rie.ir_freecount > 0)
 		ri->finobt_recs++;
 
-	trace_xrep_ibt_found(ri->sc->mp, ri->sc->sa.pag->pag_agno, &ri->rie);
+	trace_xrep_ibt_found(ri->sc->sa.pag, &ri->rie);
 
 	error = xfarray_append(ri->inode_records, &ri->rie);
 	if (error)
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 47f9b04e3798f1..707ca52650e130 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -611,7 +611,7 @@ xrep_findroot_block(
 	else
 		fab->root = NULLAGBLOCK;
 
-	trace_xrep_findroot_block(mp, ri->sc->sa.pag->pag_agno, agbno,
+	trace_xrep_findroot_block(ri->sc->sa.pag, agbno,
 			be32_to_cpu(btblock->bb_magic), fab->height - 1);
 out:
 	xfs_trans_brelse(ri->sc->tp, bp);
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index f99849ae8f67e2..57d445f7cb2a5d 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -231,7 +231,7 @@ xrep_rmap_stash(
 	if (xchk_iscan_aborted(&rr->iscan))
 		return -EFSCORRUPTED;
 
-	trace_xrep_rmap_found(sc->mp, sc->sa.pag->pag_agno, &rmap);
+	trace_xrep_rmap_found(sc->sa.pag, &rmap);
 
 	mutex_lock(&rr->lock);
 	mcur = xfs_rmapbt_mem_cursor(sc->sa.pag, sc->tp, &rr->rmap_btree);
@@ -1552,7 +1552,7 @@ xrep_rmapbt_live_update(
 	if (!xrep_rmapbt_want_live_update(&rr->iscan, &p->oinfo))
 		goto out_unlock;
 
-	trace_xrep_rmap_live_update(mp, rr->sc->sa.pag->pag_agno, action, p);
+	trace_xrep_rmap_live_update(rr->sc->sa.pag, action, p);
 
 	error = xrep_trans_alloc_hook_dummy(mp, &txcookie, &tp);
 	if (error)
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 16c275cb6520de..a1ec6445ae5fbf 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -772,12 +772,12 @@ TRACE_EVENT(xchk_xref_error,
 );
 
 TRACE_EVENT(xchk_iallocbt_check_cluster,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agino_t startino, xfs_daddr_t map_daddr,
-		 unsigned short map_len, unsigned int chunk_ino,
-		 unsigned int nr_inodes, uint16_t cluster_mask,
-		 uint16_t holemask, unsigned int cluster_ino),
-	TP_ARGS(mp, agno, startino, map_daddr, map_len, chunk_ino, nr_inodes,
+	TP_PROTO(const struct xfs_perag *pag, xfs_agino_t startino,
+		 xfs_daddr_t map_daddr,  unsigned short map_len,
+		 unsigned int chunk_ino,  unsigned int nr_inodes,
+		 uint16_t cluster_mask, uint16_t holemask,
+		 unsigned int cluster_ino),
+	TP_ARGS(pag, startino, map_daddr, map_len, chunk_ino, nr_inodes,
 		cluster_mask, holemask, cluster_ino),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -792,8 +792,8 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
 		__field(uint16_t, holemask)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->startino = startino;
 		__entry->map_daddr = map_daddr;
 		__entry->map_len = map_len;
@@ -2016,9 +2016,9 @@ TRACE_EVENT(xrep_ibt_walk_rmap,
 );
 
 TRACE_EVENT(xrep_abt_found,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+	TP_PROTO(const struct xfs_perag *pag,
 		 const struct xfs_alloc_rec_incore *rec),
-	TP_ARGS(mp, agno, rec),
+	TP_ARGS(pag, rec),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -2026,8 +2026,8 @@ TRACE_EVENT(xrep_abt_found,
 		__field(xfs_extlen_t, blockcount)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->startblock = rec->ar_startblock;
 		__entry->blockcount = rec->ar_blockcount;
 	),
@@ -2039,9 +2039,9 @@ TRACE_EVENT(xrep_abt_found,
 )
 
 TRACE_EVENT(xrep_ibt_found,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+	TP_PROTO(const struct xfs_perag *pag,
 		 const struct xfs_inobt_rec_incore *rec),
-	TP_ARGS(mp, agno, rec),
+	TP_ARGS(pag, rec),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -2052,8 +2052,8 @@ TRACE_EVENT(xrep_ibt_found,
 		__field(uint64_t, freemask)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->startino = rec->ir_startino;
 		__entry->holemask = rec->ir_holemask;
 		__entry->count = rec->ir_count;
@@ -2132,9 +2132,8 @@ TRACE_EVENT(xrep_bmap_found,
 );
 
 TRACE_EVENT(xrep_rmap_found,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 const struct xfs_rmap_irec *rec),
-	TP_ARGS(mp, agno, rec),
+	TP_PROTO(const struct xfs_perag *pag, const struct xfs_rmap_irec *rec),
+	TP_ARGS(pag, rec),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -2145,8 +2144,8 @@ TRACE_EVENT(xrep_rmap_found,
 		__field(unsigned int, flags)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->agbno = rec->rm_startblock;
 		__entry->len = rec->rm_blockcount;
 		__entry->owner = rec->rm_owner;
@@ -2164,9 +2163,9 @@ TRACE_EVENT(xrep_rmap_found,
 );
 
 TRACE_EVENT(xrep_findroot_block,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
 		 uint32_t magic, uint16_t level),
-	TP_ARGS(mp, agno, agbno, magic, level),
+	TP_ARGS(pag, agbno, magic, level),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -2175,8 +2174,8 @@ TRACE_EVENT(xrep_findroot_block,
 		__field(uint16_t, level)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->agbno = agbno;
 		__entry->magic = magic;
 		__entry->level = level;
@@ -2298,8 +2297,8 @@ DECLARE_EVENT_CLASS(xrep_newbt_extent_class,
 );
 #define DEFINE_NEWBT_EXTENT_EVENT(name) \
 DEFINE_EVENT(xrep_newbt_extent_class, name, \
-	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len, \
-		 int64_t owner), \
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno, \
+		 xfs_extlen_t len, int64_t owner), \
 	TP_ARGS(pag, agbno, len, owner))
 DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_alloc_ag_blocks);
 DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_alloc_file_blocks);
@@ -2644,9 +2643,9 @@ DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_update_inode);
 DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_unfixable_inode);
 
 TRACE_EVENT(xrep_rmap_live_update,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, unsigned int op,
+	TP_PROTO(const struct xfs_perag *pag, unsigned int op,
 		 const struct xfs_rmap_update_params *p),
-	TP_ARGS(mp, agno, op, p),
+	TP_ARGS(pag, op, p),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -2658,8 +2657,8 @@ TRACE_EVENT(xrep_rmap_live_update,
 		__field(unsigned int, flags)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->op = op;
 		__entry->agbno = p->startblock;
 		__entry->len = p->blockcount;
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index e1b4a8c59d0cc8..79648f8c6b270b 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -117,8 +117,7 @@ xfs_discard_extents(
 
 	blk_start_plug(&plug);
 	list_for_each_entry(busyp, &extents->extent_list, list) {
-		trace_xfs_discard_extent(mp, busyp->pag->pag_agno, busyp->bno,
-					 busyp->length);
+		trace_xfs_discard_extent(busyp->pag, busyp->bno, busyp->length);
 
 		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
 				xfs_agbno_to_daddr(busyp->pag, busyp->bno),
@@ -239,11 +238,11 @@ xfs_trim_gather_extents(
 		 * overlapping ranges for now.
 		 */
 		if (fbno + flen < tcur->start) {
-			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
+			trace_xfs_discard_exclude(pag, fbno, flen);
 			goto next_extent;
 		}
 		if (fbno > tcur->end) {
-			trace_xfs_discard_exclude(mp, pag->pag_agno, fbno, flen);
+			trace_xfs_discard_exclude(pag, fbno, flen);
 			if (tcur->by_bno) {
 				tcur->count = 0;
 				break;
@@ -261,7 +260,7 @@ xfs_trim_gather_extents(
 
 		/* Too small?  Give up. */
 		if (flen < tcur->minlen) {
-			trace_xfs_discard_toosmall(mp, pag->pag_agno, fbno, flen);
+			trace_xfs_discard_toosmall(pag, fbno, flen);
 			if (tcur->by_bno)
 				goto next_extent;
 			tcur->count = 0;
@@ -273,7 +272,7 @@ xfs_trim_gather_extents(
 		 * discard and try again the next time.
 		 */
 		if (xfs_extent_busy_search(pag, fbno, flen)) {
-			trace_xfs_discard_busy(mp, pag->pag_agno, fbno, flen);
+			trace_xfs_discard_busy(pag, fbno, flen);
 			goto next_extent;
 		}
 
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 7353f9844684b0..81099400a171dc 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -41,7 +41,7 @@ xfs_extent_busy_insert_list(
 	new->flags = flags;
 
 	/* trace before insert to be able to see failed inserts */
-	trace_xfs_extent_busy(pag->pag_mount, pag->pag_agno, bno, len);
+	trace_xfs_extent_busy(pag, bno, len);
 
 	spin_lock(&pag->pagb_lock);
 	rbp = &pag->pagb_tree.rb_node;
@@ -278,13 +278,13 @@ xfs_extent_busy_update_extent(
 		ASSERT(0);
 	}
 
-	trace_xfs_extent_busy_reuse(pag->pag_mount, pag->pag_agno, fbno, flen);
+	trace_xfs_extent_busy_reuse(pag, fbno, flen);
 	return true;
 
 out_force_log:
 	spin_unlock(&pag->pagb_lock);
 	xfs_log_force(pag->pag_mount, XFS_LOG_SYNC);
-	trace_xfs_extent_busy_force(pag->pag_mount, pag->pag_agno, fbno, flen);
+	trace_xfs_extent_busy_force(pag, fbno, flen);
 	spin_lock(&pag->pagb_lock);
 	return false;
 }
@@ -496,8 +496,7 @@ xfs_extent_busy_trim(
 out:
 
 	if (fbno != *bno || flen != *len) {
-		trace_xfs_extent_busy_trim(args->mp, args->agno, *bno, *len,
-					  fbno, flen);
+		trace_xfs_extent_busy_trim(args->pag, *bno, *len, fbno, flen);
 		*bno = fbno;
 		*len = flen;
 		*busy_gen = args->pag->pagb_gen;
@@ -526,9 +525,7 @@ xfs_extent_busy_clear_one(
 			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
 			return false;
 		}
-		trace_xfs_extent_busy_clear(pag->pag_mount,
-				busyp->pag->pag_agno, busyp->bno,
-				busyp->length);
+		trace_xfs_extent_busy_clear(pag, busyp->bno, busyp->length);
 		rb_erase(&busyp->rb_node, &pag->pagb_tree);
 	}
 
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 10f116d093a225..d6492128582a3e 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -41,7 +41,7 @@ xfs_health_unmount(
 	for_each_perag(mp, agno, pag) {
 		xfs_ag_measure_sickness(pag, &sick, &checked);
 		if (sick) {
-			trace_xfs_ag_unfixed_corruption(mp, agno, sick);
+			trace_xfs_ag_unfixed_corruption(pag, sick);
 			warn = true;
 		}
 	}
@@ -233,7 +233,7 @@ xfs_ag_mark_sick(
 	unsigned int		mask)
 {
 	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
-	trace_xfs_ag_mark_sick(pag->pag_mount, pag->pag_agno, mask);
+	trace_xfs_ag_mark_sick(pag, mask);
 
 	spin_lock(&pag->pag_state_lock);
 	pag->pag_sick |= mask;
@@ -247,7 +247,7 @@ xfs_ag_mark_corrupt(
 	unsigned int		mask)
 {
 	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
-	trace_xfs_ag_mark_corrupt(pag->pag_mount, pag->pag_agno, mask);
+	trace_xfs_ag_mark_corrupt(pag, mask);
 
 	spin_lock(&pag->pag_state_lock);
 	pag->pag_sick |= mask;
@@ -262,7 +262,7 @@ xfs_ag_mark_healthy(
 	unsigned int		mask)
 {
 	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
-	trace_xfs_ag_mark_healthy(pag->pag_mount, pag->pag_agno, mask);
+	trace_xfs_ag_mark_healthy(pag, mask);
 
 	spin_lock(&pag->pag_state_lock);
 	pag->pag_sick &= ~mask;
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index ab5252f19509a6..d4ef7485e8f740 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -182,7 +182,7 @@ xfs_iwalk_ag_recs(
 	for (i = 0; i < iwag->nr_recs; i++) {
 		struct xfs_inobt_rec_incore	*irec = &iwag->recs[i];
 
-		trace_xfs_iwalk_ag_rec(mp, pag->pag_agno, irec);
+		trace_xfs_iwalk_ag_rec(pag, irec);
 
 		if (xfs_pwork_want_abort(&iwag->pwork))
 			return 0;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7b1fbcf970655a..dcd0452fc7e438 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -300,15 +300,15 @@ TRACE_EVENT(xfs_inodegc_shrinker_scan,
 );
 
 DECLARE_EVENT_CLASS(xfs_ag_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
-	TP_ARGS(mp, agno),
+	TP_PROTO(const struct xfs_perag *pag),
+	TP_ARGS(pag),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 	),
 	TP_printk("dev %d:%d agno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -316,8 +316,8 @@ DECLARE_EVENT_CLASS(xfs_ag_class,
 );
 #define DEFINE_AG_EVENT(name)	\
 DEFINE_EVENT(xfs_ag_class, name,	\
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),	\
-	TP_ARGS(mp, agno))
+	TP_PROTO(const struct xfs_perag *pag),	\
+	TP_ARGS(pag))
 
 DEFINE_AG_EVENT(xfs_read_agf);
 DEFINE_AG_EVENT(xfs_alloc_read_agf);
@@ -1636,9 +1636,9 @@ TRACE_EVENT(xfs_bunmap,
 );
 
 DECLARE_EVENT_CLASS(xfs_extent_busy_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len),
-	TP_ARGS(mp, agno, agbno, len),
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
+		 xfs_extlen_t len),
+	TP_ARGS(pag, agbno, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -1646,8 +1646,8 @@ DECLARE_EVENT_CLASS(xfs_extent_busy_class,
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
@@ -1659,19 +1659,18 @@ DECLARE_EVENT_CLASS(xfs_extent_busy_class,
 );
 #define DEFINE_BUSY_EVENT(name) \
 DEFINE_EVENT(xfs_extent_busy_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_extlen_t len), \
-	TP_ARGS(mp, agno, agbno, len))
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno, \
+			xfs_extlen_t len), \
+	TP_ARGS(pag, agbno, len))
 DEFINE_BUSY_EVENT(xfs_extent_busy);
 DEFINE_BUSY_EVENT(xfs_extent_busy_force);
 DEFINE_BUSY_EVENT(xfs_extent_busy_reuse);
 DEFINE_BUSY_EVENT(xfs_extent_busy_clear);
 
 TRACE_EVENT(xfs_extent_busy_trim,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len,
-		 xfs_agblock_t tbno, xfs_extlen_t tlen),
-	TP_ARGS(mp, agno, agbno, len, tbno, tlen),
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
+		 xfs_extlen_t len, xfs_agblock_t tbno, xfs_extlen_t tlen),
+	TP_ARGS(pag, agbno, len, tbno, tlen),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -1681,8 +1680,8 @@ TRACE_EVENT(xfs_extent_busy_trim,
 		__field(xfs_extlen_t, tlen)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->tbno = tbno;
@@ -2428,9 +2427,9 @@ DEFINE_LOG_RECOVER_ICREATE_ITEM(xfs_log_recover_icreate_cancel);
 DEFINE_LOG_RECOVER_ICREATE_ITEM(xfs_log_recover_icreate_recover);
 
 DECLARE_EVENT_CLASS(xfs_discard_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len),
-	TP_ARGS(mp, agno, agbno, len),
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
+		 xfs_extlen_t len),
+	TP_ARGS(pag, agbno, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -2438,8 +2437,8 @@ DECLARE_EVENT_CLASS(xfs_discard_class,
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
@@ -2452,9 +2451,9 @@ DECLARE_EVENT_CLASS(xfs_discard_class,
 
 #define DEFINE_DISCARD_EVENT(name) \
 DEFINE_EVENT(xfs_discard_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_extlen_t len), \
-	TP_ARGS(mp, agno, agbno, len))
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno, \
+		xfs_extlen_t len), \
+	TP_ARGS(pag, agbno, len))
 DEFINE_DISCARD_EVENT(xfs_discard_extent);
 DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
 DEFINE_DISCARD_EVENT(xfs_discard_exclude);
@@ -4030,9 +4029,9 @@ DEFINE_TRANS_EVENT(xfs_trans_commit_items);
 DEFINE_TRANS_EVENT(xfs_trans_free_items);
 
 TRACE_EVENT(xfs_iunlink_update_bucket,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, unsigned int bucket,
+	TP_PROTO(const struct xfs_perag *pag, unsigned int bucket,
 		 xfs_agino_t old_ptr, xfs_agino_t new_ptr),
-	TP_ARGS(mp, agno, bucket, old_ptr, new_ptr),
+	TP_ARGS(pag, bucket, old_ptr, new_ptr),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -4041,8 +4040,8 @@ TRACE_EVENT(xfs_iunlink_update_bucket,
 		__field(xfs_agino_t, new_ptr)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->bucket = bucket;
 		__entry->old_ptr = old_ptr;
 		__entry->new_ptr = new_ptr;
@@ -4180,16 +4179,16 @@ DEFINE_FS_CORRUPT_EVENT(xfs_rt_mark_healthy);
 DEFINE_FS_CORRUPT_EVENT(xfs_rt_unfixed_corruption);
 
 DECLARE_EVENT_CLASS(xfs_ag_corrupt_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, unsigned int flags),
-	TP_ARGS(mp, agno, flags),
+	TP_PROTO(const struct xfs_perag *pag, unsigned int flags),
+	TP_ARGS(pag, flags),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 		__field(unsigned int, flags)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->flags = flags;
 	),
 	TP_printk("dev %d:%d agno 0x%x flags 0x%x",
@@ -4198,9 +4197,8 @@ DECLARE_EVENT_CLASS(xfs_ag_corrupt_class,
 );
 #define DEFINE_AG_CORRUPT_EVENT(name)	\
 DEFINE_EVENT(xfs_ag_corrupt_class, name,	\
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 unsigned int flags), \
-	TP_ARGS(mp, agno, flags))
+	TP_PROTO(const struct xfs_perag *pag, unsigned int flags), \
+	TP_ARGS(pag, flags))
 DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_sick);
 DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_corrupt);
 DEFINE_AG_CORRUPT_EVENT(xfs_ag_mark_healthy);
@@ -4233,9 +4231,9 @@ DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_unfixed_corruption);
 
 TRACE_EVENT(xfs_iwalk_ag_rec,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+	TP_PROTO(const struct xfs_perag *pag, \
 		 struct xfs_inobt_rec_incore *irec),
-	TP_ARGS(mp, agno, irec),
+	TP_ARGS(pag, irec),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -4243,8 +4241,8 @@ TRACE_EVENT(xfs_iwalk_ag_rec,
 		__field(uint64_t, freemask)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->startino = irec->ir_startino;
 		__entry->freemask = irec->ir_free;
 	),


