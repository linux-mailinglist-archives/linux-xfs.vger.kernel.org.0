Return-Path: <linux-xfs+bounces-13810-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 23DE799983C
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 02:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56AA51F2235F
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 00:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F356A2581;
	Fri, 11 Oct 2024 00:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPKn/4R2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAF823BB
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607483; cv=none; b=MUsIiw4E7GCau7GHvHVnL3KD71TNg7fmts5wl/IcXsGv67LP1mRMh46rwz46odil2lYI8Tp9rTIPjz4z9fUrLhE5Kn6SABvuFhnA1HZqaYM21wQPy6Zgj8de3xBjg3dR9YWSH9k0XutY7iQcPPqi5WCBgDw3by0NHZA2IJnUhzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607483; c=relaxed/simple;
	bh=yowHJzEFC/7z75wkOqk99xyiZYBugda+lMAFP/AMVLU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WU5aVZmKVXm69jSUwHaB7buo3sMyyvyNEkoHN7uicfu9zB3ON/FePnMz7BpS1q4Y8+3btq2vD8oTcRykoqpCiU7L3InYx5yiNeWO7/pOVyrL2JKDOoT7TmIiVDkSy0Z/RMkFN5Bjy44sROo1cdEECAL1iSG6cBErJrKGY5e2aTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPKn/4R2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21060C4CEC5;
	Fri, 11 Oct 2024 00:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607483;
	bh=yowHJzEFC/7z75wkOqk99xyiZYBugda+lMAFP/AMVLU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZPKn/4R2zAnBOoNy8++aYXnxNfagI1HH5/1s7sclmV94tjzAH0/Xd/T4ujoPDM/p3
	 FPkfWEBTLKf+/aB/XEVuwvBdxW7EYq3OZR6oKGNjcpcrrtQVpPXc36irKWsIXCmpd8
	 i4XDbeyv19FPnWvgOyyoFqsgxKUUzmrHor3HfV5iPxs19qIYus3k+Zsan09Jm+ecCG
	 75Cy9r2154V+mBCNlnvw7++APuKbycKuWgHBwGCZYMNLM5r8ww9qipN/mFIm56tFio
	 TZC79kGbPAOq8cEiCUlh89H/lmfMzyPIjDGXqtVlbPTVmtjC9CL/nakjQ1gfH7WshV
	 CBWo/IsAX4NDA==
Date: Thu, 10 Oct 2024 17:44:42 -0700
Subject: [PATCH 02/16] xfs: factor out a generic xfs_group structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860641288.4176300.12597066672597648144.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Split the lookup and refcount handling of struct xfs_perag into an
embedded xfs_group structure that can be reused for the upcoming
realtime groups.

It will be extended with more features later.

Note that he xg_type field will only need a single bit even with
realtime group support.  For now it fills a hole, but it might be
worth to fold it into another field if we can use this space better.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_ag.c             |  139 ++++++------------------------
 fs/xfs/libxfs/xfs_ag.h             |   76 +++++++++++++---
 fs/xfs/libxfs/xfs_ag_resv.c        |   19 ++--
 fs/xfs/libxfs/xfs_alloc.c          |   39 ++++----
 fs/xfs/libxfs/xfs_alloc_btree.c    |    2 
 fs/xfs/libxfs/xfs_bmap.c           |    2 
 fs/xfs/libxfs/xfs_btree.c          |    6 +
 fs/xfs/libxfs/xfs_group.c          |  169 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_group.h          |   41 +++++++++
 fs/xfs/libxfs/xfs_ialloc.c         |   40 ++++-----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   16 ++-
 fs/xfs/libxfs/xfs_refcount.c       |    4 -
 fs/xfs/libxfs/xfs_refcount_btree.c |    8 +-
 fs/xfs/libxfs/xfs_rmap.c           |    4 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |    7 +
 fs/xfs/libxfs/xfs_sb.c             |    6 +
 fs/xfs/libxfs/xfs_types.h          |    8 ++
 fs/xfs/scrub/agheader_repair.c     |   22 ++---
 fs/xfs/scrub/alloc_repair.c        |    2 
 fs/xfs/scrub/common.h              |    3 -
 fs/xfs/scrub/ialloc_repair.c       |    2 
 fs/xfs/scrub/iscan.c               |    4 -
 fs/xfs/scrub/newbt.c               |    8 +-
 fs/xfs/scrub/repair.c              |    4 -
 fs/xfs/scrub/rmap.c                |    2 
 fs/xfs/scrub/rmap_repair.c         |   10 +-
 fs/xfs/scrub/trace.h               |   82 +++++++++--------
 fs/xfs/xfs_discard.c               |    4 -
 fs/xfs/xfs_extent_busy.c           |    4 -
 fs/xfs/xfs_extfree_item.c          |    2 
 fs/xfs/xfs_filestream.c            |    8 +-
 fs/xfs/xfs_fsmap.c                 |   12 +--
 fs/xfs/xfs_icache.c                |   55 ++++--------
 fs/xfs/xfs_inode.c                 |    6 +
 fs/xfs/xfs_iwalk.c                 |    6 +
 fs/xfs/xfs_log_recover.c           |    6 +
 fs/xfs/xfs_mount.h                 |    6 +
 fs/xfs/xfs_refcount_item.c         |    2 
 fs/xfs/xfs_reflink.c               |    2 
 fs/xfs/xfs_rmap_item.c             |    2 
 fs/xfs/xfs_super.c                 |   11 +-
 fs/xfs/xfs_trace.c                 |    1 
 fs/xfs/xfs_trace.h                 |  149 ++++++++++++++++++++------------
 44 files changed, 603 insertions(+), 399 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_group.c
 create mode 100644 fs/xfs/libxfs/xfs_group.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index dd692619bed580..94cb8ca9f9da77 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -14,6 +14,7 @@ xfs-y				+= xfs_trace.o
 
 # build the libxfs code first
 xfs-y				+= $(addprefix libxfs/, \
+				   xfs_group.o \
 				   xfs_ag.o \
 				   xfs_alloc.o \
 				   xfs_alloc_btree.o \
diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 72a9a8c3501e81..d1aa42a75dc104 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -30,85 +30,7 @@
 #include "xfs_trace.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
-
-
-/*
- * Passive reference counting access wrappers to the perag structures.  If the
- * per-ag structure is to be freed, the freeing code is responsible for cleaning
- * up objects with passive references before freeing the structure. This is
- * things like cached buffers.
- */
-struct xfs_perag *
-xfs_perag_get(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	struct xfs_perag	*pag;
-
-	rcu_read_lock();
-	pag = xa_load(&mp->m_perags, agno);
-	if (pag) {
-		trace_xfs_perag_get(pag, _RET_IP_);
-		ASSERT(atomic_read(&pag->pag_ref) >= 0);
-		atomic_inc(&pag->pag_ref);
-	}
-	rcu_read_unlock();
-	return pag;
-}
-
-/* Get a passive reference to the given perag. */
-struct xfs_perag *
-xfs_perag_hold(
-	struct xfs_perag	*pag)
-{
-	ASSERT(atomic_read(&pag->pag_ref) > 0 ||
-	       atomic_read(&pag->pag_active_ref) > 0);
-
-	trace_xfs_perag_hold(pag, _RET_IP_);
-	atomic_inc(&pag->pag_ref);
-	return pag;
-}
-
-void
-xfs_perag_put(
-	struct xfs_perag	*pag)
-{
-	trace_xfs_perag_put(pag, _RET_IP_);
-	ASSERT(atomic_read(&pag->pag_ref) > 0);
-	atomic_dec(&pag->pag_ref);
-}
-
-/*
- * Active references for perag structures. This is for short term access to the
- * per ag structures for walking trees or accessing state. If an AG is being
- * shrunk or is offline, then this will fail to find that AG and return NULL
- * instead.
- */
-struct xfs_perag *
-xfs_perag_grab(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	struct xfs_perag	*pag;
-
-	rcu_read_lock();
-	pag = xa_load(&mp->m_perags, agno);
-	if (pag) {
-		trace_xfs_perag_grab(pag, _RET_IP_);
-		if (!atomic_inc_not_zero(&pag->pag_active_ref))
-			pag = NULL;
-	}
-	rcu_read_unlock();
-	return pag;
-}
-
-void
-xfs_perag_rele(
-	struct xfs_perag	*pag)
-{
-	trace_xfs_perag_rele(pag, _RET_IP_);
-	atomic_dec(&pag->pag_active_ref);
-}
+#include "xfs_group.h"
 
 /*
  * xfs_initialize_perag_data
@@ -183,6 +105,19 @@ xfs_initialize_perag_data(
 	return error;
 }
 
+static void
+xfs_perag_uninit(
+	struct xfs_group	*xg)
+{
+#ifdef __KERNEL__
+	struct xfs_perag	*pag = to_perag(xg);
+
+	xfs_defer_drain_free(&pag->pag_intents_drain);
+	cancel_delayed_work_sync(&pag->pag_blockgc_work);
+	xfs_buf_cache_destroy(&pag->pag_bcache);
+#endif
+}
+
 /*
  * Free up the per-ag resources  within the specified AG range.
  */
@@ -195,22 +130,8 @@ xfs_free_perag_range(
 {
 	xfs_agnumber_t		agno;
 
-	for (agno = first_agno; agno < end_agno; agno++) {
-		struct xfs_perag	*pag = xa_erase(&mp->m_perags, agno);
-
-		ASSERT(pag);
-		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
-		xfs_defer_drain_free(&pag->pag_intents_drain);
-
-		cancel_delayed_work_sync(&pag->pag_blockgc_work);
-		xfs_buf_cache_destroy(&pag->pag_bcache);
-
-		/* drop the mount's active reference */
-		xfs_perag_rele(pag);
-		XFS_IS_CORRUPT(pag->pag_mount,
-				atomic_read(&pag->pag_active_ref) != 0);
-		kfree_rcu_mightsleep(pag);
-	}
+	for (agno = first_agno; agno < end_agno; agno++)
+		xfs_group_free(mp, agno, XG_TYPE_AG, xfs_perag_uninit);
 }
 
 /* Find the size of the AG, in blocks. */
@@ -311,16 +232,9 @@ xfs_perag_alloc(
 	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
 			&pag->agino_max);
 
-	pag->pag_agno = index;
-	pag->pag_mount = mp;
-	/* Active ref owned by mount indicates AG is online. */
-	atomic_set(&pag->pag_active_ref, 1);
-
-	error = xa_insert(&mp->m_perags, index, pag, GFP_KERNEL);
-	if (error) {
-		WARN_ON_ONCE(error == -EBUSY);
+	error = xfs_group_insert(mp, &pag->pag_group, index, XG_TYPE_AG);
+	if (error)
 		goto out_buf_cache_destroy;
-	}
 
 	return 0;
 
@@ -812,7 +726,7 @@ xfs_ag_shrink_space(
 	struct xfs_trans	**tpp,
 	xfs_extlen_t		delta)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_alloc_arg	args = {
 		.tp	= *tpp,
 		.mp	= mp,
@@ -829,7 +743,7 @@ xfs_ag_shrink_space(
 	xfs_agblock_t		aglen;
 	int			error, err2;
 
-	ASSERT(pag->pag_agno == mp->m_sb.sb_agcount - 1);
+	ASSERT(pag_agno(pag) == mp->m_sb.sb_agcount - 1);
 	error = xfs_ialloc_read_agi(pag, *tpp, 0, &agibp);
 	if (error)
 		return error;
@@ -926,8 +840,8 @@ xfs_ag_shrink_space(
 
 	/* Update perag geometry */
 	pag->block_count -= delta;
-	__xfs_agino_range(pag->pag_mount, pag->block_count, &pag->agino_min,
-				&pag->agino_max);
+	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+			&pag->agino_max);
 
 	xfs_ialloc_log_agi(*tpp, agibp, XFS_AGI_LENGTH);
 	xfs_alloc_log_agf(*tpp, agfbp, XFS_AGF_LENGTH);
@@ -952,12 +866,13 @@ xfs_ag_extend_space(
 	struct xfs_trans	*tp,
 	xfs_extlen_t		len)
 {
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_buf		*bp;
 	struct xfs_agi		*agi;
 	struct xfs_agf		*agf;
 	int			error;
 
-	ASSERT(pag->pag_agno == pag->pag_mount->m_sb.sb_agcount - 1);
+	ASSERT(pag_agno(pag) == mp->m_sb.sb_agcount - 1);
 
 	error = xfs_ialloc_read_agi(pag, tp, 0, &bp);
 	if (error)
@@ -997,8 +912,8 @@ xfs_ag_extend_space(
 
 	/* Update perag geometry */
 	pag->block_count = be32_to_cpu(agf->agf_length);
-	__xfs_agino_range(pag->pag_mount, pag->block_count, &pag->agino_min,
-				&pag->agino_max);
+	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+			&pag->agino_max);
 	return 0;
 }
 
@@ -1025,7 +940,7 @@ xfs_ag_get_geometry(
 
 	/* Fill out form. */
 	memset(ageo, 0, sizeof(*ageo));
-	ageo->ag_number = pag->pag_agno;
+	ageo->ag_number = pag_agno(pag);
 
 	agi = agi_bp->b_addr;
 	ageo->ag_icount = be32_to_cpu(agi->agi_count);
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index ef1f532673ea86..b08daa27fb5879 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -7,6 +7,8 @@
 #ifndef __LIBXFS_AG_H
 #define __LIBXFS_AG_H 1
 
+#include "xfs_group.h"
+
 struct xfs_mount;
 struct xfs_trans;
 struct xfs_perag;
@@ -30,10 +32,7 @@ struct xfs_ag_resv {
  * performance of allocation group selection.
  */
 struct xfs_perag {
-	struct xfs_mount *pag_mount;	/* owner filesystem */
-	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
-	atomic_t	pag_ref;	/* passive reference count */
-	atomic_t	pag_active_ref;	/* active reference count */
+	struct xfs_group pag_group;
 	unsigned long	pag_opstate;
 	uint8_t		pagf_bno_level;	/* # of levels in bno btree */
 	uint8_t		pagf_cnt_level;	/* # of levels in cnt btree */
@@ -121,6 +120,21 @@ struct xfs_perag {
 #endif /* __KERNEL__ */
 };
 
+static inline struct xfs_perag *to_perag(struct xfs_group *xg)
+{
+	return container_of(xg, struct xfs_perag, pag_group);
+}
+
+static inline struct xfs_mount *pag_mount(const struct xfs_perag *pag)
+{
+	return pag->pag_group.xg_mount;
+}
+
+static inline xfs_agnumber_t pag_agno(const struct xfs_perag *pag)
+{
+	return pag->pag_group.xg_index;
+}
+
 /*
  * Per-AG operational state. These are atomic flag bits.
  */
@@ -150,13 +164,43 @@ void xfs_free_perag_range(struct xfs_mount *mp, xfs_agnumber_t first_agno,
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 /* Passive AG references */
-struct xfs_perag *xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno);
-struct xfs_perag *xfs_perag_hold(struct xfs_perag *pag);
-void xfs_perag_put(struct xfs_perag *pag);
+static inline struct xfs_perag *
+xfs_perag_get(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	return to_perag(xfs_group_get(mp, agno, XG_TYPE_AG));
+}
+
+static inline struct xfs_perag *
+xfs_perag_hold(
+	struct xfs_perag	*pag)
+{
+	return to_perag(xfs_group_hold(&pag->pag_group));
+}
+
+static inline void
+xfs_perag_put(
+	struct xfs_perag	*pag)
+{
+	xfs_group_put(&pag->pag_group);
+}
 
 /* Active AG references */
-struct xfs_perag *xfs_perag_grab(struct xfs_mount *, xfs_agnumber_t);
-void xfs_perag_rele(struct xfs_perag *pag);
+static inline struct xfs_perag *
+xfs_perag_grab(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	return to_perag(xfs_group_grab(mp, agno, XG_TYPE_AG));
+}
+
+static inline void
+xfs_perag_rele(
+	struct xfs_perag	*pag)
+{
+	xfs_group_rele(&pag->pag_group);
+}
 
 /*
  * Per-ag geometry infomation and validation
@@ -232,9 +276,9 @@ xfs_perag_next(
 	xfs_agnumber_t		*agno,
 	xfs_agnumber_t		end_agno)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 
-	*agno = pag->pag_agno + 1;
+	*agno = pag->pag_group.xg_index + 1;
 	xfs_perag_rele(pag);
 	while (*agno <= end_agno) {
 		pag = xfs_perag_grab(mp, *agno);
@@ -265,9 +309,9 @@ xfs_perag_next_wrap(
 	xfs_agnumber_t		restart_agno,
 	xfs_agnumber_t		wrap_agno)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 
-	*agno = pag->pag_agno + 1;
+	*agno = pag->pag_group.xg_index + 1;
 	xfs_perag_rele(pag);
 	while (*agno != stop_agno) {
 		if (*agno >= wrap_agno) {
@@ -334,7 +378,7 @@ xfs_agbno_to_fsb(
 	struct xfs_perag	*pag,
 	xfs_agblock_t		agbno)
 {
-	return XFS_AGB_TO_FSB(pag->pag_mount, pag->pag_agno, agbno);
+	return XFS_AGB_TO_FSB(pag_mount(pag), pag_agno(pag), agbno);
 }
 
 static inline xfs_daddr_t
@@ -342,7 +386,7 @@ xfs_agbno_to_daddr(
 	struct xfs_perag	*pag,
 	xfs_agblock_t		agbno)
 {
-	return XFS_AGB_TO_DADDR(pag->pag_mount, pag->pag_agno, agbno);
+	return XFS_AGB_TO_DADDR(pag_mount(pag), pag_agno(pag), agbno);
 }
 
 static inline xfs_ino_t
@@ -350,7 +394,7 @@ xfs_agino_to_ino(
 	struct xfs_perag	*pag,
 	xfs_agino_t		agino)
 {
-	return XFS_AGINO_TO_INO(pag->pag_mount, pag->pag_agno, agino);
+	return XFS_AGINO_TO_INO(pag_mount(pag), pag_agno(pag), agino);
 }
 
 #endif /* __LIBXFS_AG_H */
diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 4b1bd7cc7ba28c..f5d853089019f0 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -70,6 +70,7 @@ xfs_ag_resv_critical(
 	struct xfs_perag		*pag,
 	enum xfs_ag_resv_type		type)
 {
+	struct xfs_mount		*mp = pag_mount(pag);
 	xfs_extlen_t			avail;
 	xfs_extlen_t			orig;
 
@@ -92,8 +93,8 @@ xfs_ag_resv_critical(
 
 	/* Critically low if less than 10% or max btree height remains. */
 	return XFS_TEST_ERROR(avail < orig / 10 ||
-			      avail < pag->pag_mount->m_agbtree_maxlevels,
-			pag->pag_mount, XFS_ERRTAG_AG_RESV_CRITICAL);
+			      avail < mp->m_agbtree_maxlevels,
+			mp, XFS_ERRTAG_AG_RESV_CRITICAL);
 }
 
 /*
@@ -137,8 +138,8 @@ __xfs_ag_resv_free(
 	trace_xfs_ag_resv_free(pag, type, 0);
 
 	resv = xfs_perag_resv(pag, type);
-	if (pag->pag_agno == 0)
-		pag->pag_mount->m_ag_max_usable += resv->ar_asked;
+	if (pag_agno(pag) == 0)
+		pag_mount(pag)->m_ag_max_usable += resv->ar_asked;
 	/*
 	 * RMAPBT blocks come from the AGFL and AGFL blocks are always
 	 * considered "free", so whatever was reserved at mount time must be
@@ -148,7 +149,7 @@ __xfs_ag_resv_free(
 		oldresv = resv->ar_orig_reserved;
 	else
 		oldresv = resv->ar_reserved;
-	xfs_add_fdblocks(pag->pag_mount, oldresv);
+	xfs_add_fdblocks(pag_mount(pag), oldresv);
 	resv->ar_reserved = 0;
 	resv->ar_asked = 0;
 	resv->ar_orig_reserved = 0;
@@ -170,7 +171,7 @@ __xfs_ag_resv_init(
 	xfs_extlen_t			ask,
 	xfs_extlen_t			used)
 {
-	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_mount		*mp = pag_mount(pag);
 	struct xfs_ag_resv		*resv;
 	int				error;
 	xfs_extlen_t			hidden_space;
@@ -209,7 +210,7 @@ __xfs_ag_resv_init(
 		trace_xfs_ag_resv_init_error(pag, error, _RET_IP_);
 		xfs_warn(mp,
 "Per-AG reservation for AG %u failed.  Filesystem may run out of space.",
-				pag->pag_agno);
+				pag_agno(pag));
 		return error;
 	}
 
@@ -219,7 +220,7 @@ __xfs_ag_resv_init(
 	 * counter, we only make the adjustment for AG 0.  This assumes that
 	 * there aren't any AGs hungrier for per-AG reservation than AG 0.
 	 */
-	if (pag->pag_agno == 0)
+	if (pag_agno(pag) == 0)
 		mp->m_ag_max_usable -= ask;
 
 	resv = xfs_perag_resv(pag, type);
@@ -237,7 +238,7 @@ xfs_ag_resv_init(
 	struct xfs_perag		*pag,
 	struct xfs_trans		*tp)
 {
-	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_mount		*mp = pag_mount(pag);
 	xfs_extlen_t			ask;
 	xfs_extlen_t			used;
 	int				error = 0, error2;
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f68622328d2a63..66e38310a13129 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -275,7 +275,7 @@ xfs_alloc_complain_bad_rec(
 
 	xfs_warn(mp,
 		"%sbt record corruption in AG %d detected at %pS!",
-		cur->bc_ops->name, cur->bc_ag.pag->pag_agno, fa);
+		cur->bc_ops->name, pag_agno(cur->bc_ag.pag), fa);
 	xfs_warn(mp,
 		"start block 0x%x block count 0x%x", irec->ar_startblock,
 		irec->ar_blockcount);
@@ -799,7 +799,7 @@ xfs_agfl_verify(
 	 * use it by using uncached buffers that don't have the perag attached
 	 * so we can detect and avoid this problem.
 	 */
-	if (bp->b_pag && be32_to_cpu(agfl->agfl_seqno) != bp->b_pag->pag_agno)
+	if (bp->b_pag && be32_to_cpu(agfl->agfl_seqno) != pag_agno((bp->b_pag)))
 		return __this_address;
 
 	for (i = 0; i < xfs_agfl_size(mp); i++) {
@@ -879,13 +879,12 @@ xfs_alloc_read_agfl(
 	struct xfs_trans	*tp,
 	struct xfs_buf		**bpp)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_buf		*bp;
 	int			error;
 
-	error = xfs_trans_read_buf(
-			mp, tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGFL_DADDR(mp)),
+	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, pag_agno(pag), XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGFL);
@@ -2428,7 +2427,7 @@ xfs_alloc_longest_free_extent(
 	 * reservations and AGFL rules in place, we can return this extent.
 	 */
 	if (pag->pagf_longest > delta)
-		return min_t(xfs_extlen_t, pag->pag_mount->m_ag_max_usable,
+		return min_t(xfs_extlen_t, pag_mount(pag)->m_ag_max_usable,
 				pag->pagf_longest - delta);
 
 	/* Otherwise, let the caller try for 1 block if there's space. */
@@ -2611,7 +2610,7 @@ xfs_agfl_reset(
 	xfs_warn(mp,
 	       "WARNING: Reset corrupted AGFL on AG %u. %d blocks leaked. "
 	       "Please unmount and run xfs_repair.",
-	         pag->pag_agno, pag->pagf_flcount);
+		pag_agno(pag), pag->pagf_flcount);
 
 	agf->agf_flfirst = 0;
 	agf->agf_fllast = cpu_to_be32(xfs_agfl_size(mp) - 1);
@@ -3191,7 +3190,7 @@ xfs_validate_ag_length(
 	 * use it by using uncached buffers that don't have the perag attached
 	 * so we can detect and avoid this problem.
 	 */
-	if (bp->b_pag && seqno != bp->b_pag->pag_agno)
+	if (bp->b_pag && seqno != pag_agno(bp->b_pag))
 		return __this_address;
 
 	/*
@@ -3360,13 +3359,13 @@ xfs_read_agf(
 	int			flags,
 	struct xfs_buf		**agfbpp)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	int			error;
 
 	trace_xfs_read_agf(pag);
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGF_DADDR(mp)),
+			XFS_AG_DADDR(mp, pag_agno(pag), XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, agfbpp, &xfs_agf_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
@@ -3389,6 +3388,7 @@ xfs_alloc_read_agf(
 	int			flags,
 	struct xfs_buf		**agfbpp)
 {
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_buf		*agfbp;
 	struct xfs_agf		*agf;
 	int			error;
@@ -3415,7 +3415,7 @@ xfs_alloc_read_agf(
 		pag->pagf_cnt_level = be32_to_cpu(agf->agf_cnt_level);
 		pag->pagf_rmap_level = be32_to_cpu(agf->agf_rmap_level);
 		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
-		if (xfs_agfl_needs_reset(pag->pag_mount, agf))
+		if (xfs_agfl_needs_reset(mp, agf))
 			set_bit(XFS_AGSTATE_AGFL_NEEDS_RESET, &pag->pag_opstate);
 		else
 			clear_bit(XFS_AGSTATE_AGFL_NEEDS_RESET, &pag->pag_opstate);
@@ -3428,16 +3428,15 @@ xfs_alloc_read_agf(
 		 * counter only tracks non-root blocks.
 		 */
 		allocbt_blks = pag->pagf_btreeblks;
-		if (xfs_has_rmapbt(pag->pag_mount))
+		if (xfs_has_rmapbt(mp))
 			allocbt_blks -= be32_to_cpu(agf->agf_rmap_blocks) - 1;
 		if (allocbt_blks > 0)
-			atomic64_add(allocbt_blks,
-					&pag->pag_mount->m_allocbt_blks);
+			atomic64_add(allocbt_blks, &mp->m_allocbt_blks);
 
 		set_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 	}
 #ifdef DEBUG
-	else if (!xfs_is_shutdown(pag->pag_mount)) {
+	else if (!xfs_is_shutdown(mp)) {
 		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
 		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
 		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
@@ -3655,7 +3654,7 @@ xfs_alloc_vextent_this_ag(
 	int			error;
 
 	ASSERT(args->pag != NULL);
-	ASSERT(args->pag->pag_agno == agno);
+	ASSERT(pag_agno(args->pag) == agno);
 
 	args->agno = agno;
 	args->agbno = 0;
@@ -3868,7 +3867,7 @@ xfs_alloc_vextent_exact_bno(
 	int			error;
 
 	ASSERT(args->pag != NULL);
-	ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
+	ASSERT(pag_agno(args->pag) == XFS_FSB_TO_AGNO(mp, target));
 
 	args->agno = XFS_FSB_TO_AGNO(mp, target);
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
@@ -3907,7 +3906,7 @@ xfs_alloc_vextent_near_bno(
 	int			error;
 
 	if (!needs_perag)
-		ASSERT(args->pag->pag_agno == XFS_FSB_TO_AGNO(mp, target));
+		ASSERT(pag_agno(args->pag) == XFS_FSB_TO_AGNO(mp, target));
 
 	args->agno = XFS_FSB_TO_AGNO(mp, target);
 	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
@@ -3944,7 +3943,7 @@ xfs_free_extent_fix_freelist(
 	memset(&args, 0, sizeof(struct xfs_alloc_arg));
 	args.tp = tp;
 	args.mp = tp->t_mountp;
-	args.agno = pag->pag_agno;
+	args.agno = pag_agno(pag);
 	args.pag = pag;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 5175d0b4d32e48..88e1545ed4c9dc 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -178,7 +178,7 @@ xfs_allocbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
 
 	if (xfs_btree_is_bno(cur->bc_ops))
 		ptr->s = agf->agf_bno_root;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8090e8249116d0..bfc3155bb57d79 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3280,7 +3280,7 @@ xfs_bmap_longest_free_extent(
 	}
 
 	longest = xfs_alloc_longest_free_extent(pag,
-				xfs_alloc_min_freelist(pag->pag_mount, pag),
+				xfs_alloc_min_freelist(pag_mount(pag), pag),
 				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
 	if (*blen < longest)
 		*blen = longest;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 804a1c96941127..9a13dbf5f54a33 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -372,7 +372,7 @@ xfs_btree_check_ptr(
 		case XFS_BTREE_TYPE_AG:
 			xfs_err(cur->bc_mp,
 "AG %u: Corrupt %sbt pointer at level %d index %d.",
-				cur->bc_ag.pag->pag_agno, cur->bc_ops->name,
+				pag_agno(cur->bc_ag.pag), cur->bc_ops->name,
 				level, index);
 			break;
 		}
@@ -1312,7 +1312,7 @@ xfs_btree_owner(
 	case XFS_BTREE_TYPE_INODE:
 		return cur->bc_ino.ip->i_ino;
 	case XFS_BTREE_TYPE_AG:
-		return cur->bc_ag.pag->pag_agno;
+		return pag_agno(cur->bc_ag.pag);
 	default:
 		ASSERT(0);
 		return 0;
@@ -4744,7 +4744,7 @@ xfs_btree_agblock_v5hdr_verify(
 		return __this_address;
 	if (block->bb_u.s.bb_blkno != cpu_to_be64(xfs_buf_daddr(bp)))
 		return __this_address;
-	if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
+	if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag_agno(pag))
 		return __this_address;
 	return NULL;
 }
diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
new file mode 100644
index 00000000000000..5b81221c3e9665
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2018 Red Hat, Inc.
+ */
+
+#include "xfs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_group.h"
+
+/*
+ * Groups can have passive and active references.
+ *
+ * For passive references the code freeing a group is responsible for cleaning
+ * up objects that hold the passive references (e.g. cached buffers).
+ * Routines manipulating passive references are xfs_group_get, xfs_group_hold
+ * and xfs_group_put.
+ *
+ * Active references are for short term access to the group for walking trees or
+ * accessing state. If a group is being shrunk or offlined, the lookup will fail
+ * to find that group and return NULL instead.
+ * Routines manipulating active references are xfs_group_grab and
+ * xfs_group_rele.
+ */
+
+struct xfs_group *
+xfs_group_get(
+	struct xfs_mount	*mp,
+	uint32_t		index,
+	enum xfs_group_type	type)
+{
+	struct xfs_group	*xg;
+
+	rcu_read_lock();
+	xg = xa_load(&mp->m_groups[type].xa, index);
+	if (xg) {
+		trace_xfs_group_get(xg, _RET_IP_);
+		ASSERT(atomic_read(&xg->xg_ref) >= 0);
+		atomic_inc(&xg->xg_ref);
+	}
+	rcu_read_unlock();
+	return xg;
+}
+
+struct xfs_group *
+xfs_group_hold(
+	struct xfs_group	*xg)
+{
+	ASSERT(atomic_read(&xg->xg_ref) > 0 ||
+	       atomic_read(&xg->xg_active_ref) > 0);
+
+	trace_xfs_group_hold(xg, _RET_IP_);
+	atomic_inc(&xg->xg_ref);
+	return xg;
+}
+
+void
+xfs_group_put(
+	struct xfs_group	*xg)
+{
+	trace_xfs_group_put(xg, _RET_IP_);
+
+	ASSERT(atomic_read(&xg->xg_ref) > 0);
+	atomic_dec(&xg->xg_ref);
+}
+
+struct xfs_group *
+xfs_group_grab(
+	struct xfs_mount	*mp,
+	uint32_t		index,
+	enum xfs_group_type	type)
+{
+	struct xfs_group	*xg;
+
+	rcu_read_lock();
+	xg = xa_load(&mp->m_groups[type].xa, index);
+	if (xg) {
+		trace_xfs_group_grab(xg, _RET_IP_);
+		if (!atomic_inc_not_zero(&xg->xg_active_ref))
+			xg = NULL;
+	}
+	rcu_read_unlock();
+	return xg;
+}
+
+/*
+ * Find the next group after @xg, or the first group if @xg is NULL.
+ */
+struct xfs_group *
+xfs_group_grab_next_mark(
+	struct xfs_mount	*mp,
+	struct xfs_group	*xg,
+	xa_mark_t		mark,
+	enum xfs_group_type	type)
+{
+	unsigned long		index = 0;
+
+	if (xg) {
+		index = xg->xg_index + 1;
+		xfs_group_rele(xg);
+	}
+
+	rcu_read_lock();
+	xg = xa_find(&mp->m_groups[type].xa, &index, ULONG_MAX, mark);
+	if (xg) {
+		trace_xfs_group_grab_next_tag(xg, _RET_IP_);
+		if (!atomic_inc_not_zero(&xg->xg_active_ref))
+			xg = NULL;
+	}
+	rcu_read_unlock();
+	return xg;
+}
+
+void
+xfs_group_rele(
+	struct xfs_group	*xg)
+{
+	trace_xfs_group_rele(xg, _RET_IP_);
+	atomic_dec(&xg->xg_active_ref);
+}
+
+void
+xfs_group_free(
+	struct xfs_mount	*mp,
+	uint32_t		index,
+	enum xfs_group_type	type,
+	void			(*uninit)(struct xfs_group *xg))
+{
+	struct xfs_group	*xg = xa_erase(&mp->m_groups[type].xa, index);
+
+	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_ref) != 0);
+
+	if (uninit)
+		uninit(xg);
+
+	/* drop the mount's active reference */
+	xfs_group_rele(xg);
+	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_active_ref) != 0);
+	kfree_rcu_mightsleep(xg);
+}
+
+int
+xfs_group_insert(
+	struct xfs_mount	*mp,
+	struct xfs_group	*xg,
+	uint32_t		index,
+	enum xfs_group_type	type)
+{
+	int			error;
+
+	xg->xg_mount = mp;
+	xg->xg_index = index;
+	xg->xg_type = type;
+
+	/* Active ref owned by mount indicates group is online. */
+	atomic_set(&xg->xg_active_ref, 1);
+
+	error = xa_insert(&mp->m_groups[type].xa, index, xg, GFP_KERNEL);
+	if (error) {
+		WARN_ON_ONCE(error == -EBUSY);
+		return error;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
new file mode 100644
index 00000000000000..f211108eb6ca4d
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2018 Red Hat, Inc.
+ */
+#ifndef __LIBXFS_GROUP_H
+#define __LIBXFS_GROUP_H 1
+
+struct xfs_group {
+	struct xfs_mount	*xg_mount;
+	uint32_t		xg_index;
+	enum xfs_group_type	xg_type;
+	atomic_t		xg_ref;		/* passive reference count */
+	atomic_t		xg_active_ref;	/* active reference count */
+};
+
+struct xfs_group *xfs_group_get(struct xfs_mount *mp, uint32_t index,
+		enum xfs_group_type type);
+struct xfs_group *xfs_group_hold(struct xfs_group *xg);
+void xfs_group_put(struct xfs_group *xg);
+
+struct xfs_group *xfs_group_grab(struct xfs_mount *mp, uint32_t index,
+		enum xfs_group_type type);
+struct xfs_group *xfs_group_grab_next_mark(struct xfs_mount *mp,
+		struct xfs_group *xg, xa_mark_t mark, enum xfs_group_type type);
+void xfs_group_rele(struct xfs_group *xg);
+
+void xfs_group_free(struct xfs_mount *mp, uint32_t index,
+		enum xfs_group_type type, void (*uninit)(struct xfs_group *xg));
+int xfs_group_insert(struct xfs_mount *mp, struct xfs_group *xg,
+		uint32_t index, enum xfs_group_type);
+
+#define xfs_group_set_mark(_xg, _mark) \
+	xa_set_mark(&(_xg)->xg_mount->m_groups[(_xg)->xg_type].xa, \
+			(_xg)->xg_index, (_mark))
+#define xfs_group_clear_mark(_xg, _mark) \
+	xa_clear_mark(&(_xg)->xg_mount->m_groups[(_xg)->xg_type].xa, \
+			(_xg)->xg_index, (_mark))
+#define xfs_group_marked(_mp, _type, _mark) \
+	xa_marked(&(_mp)->m_groups[(_type)].xa, (_mark))
+
+#endif /* __LIBXFS_GROUP_H */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index f5167847f05119..78e1920c1ff964 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -142,7 +142,7 @@ xfs_inobt_complain_bad_rec(
 
 	xfs_warn(mp,
 		"%sbt record corruption in AG %d detected at %pS!",
-		cur->bc_ops->name, cur->bc_ag.pag->pag_agno, fa);
+		cur->bc_ops->name, pag_agno(cur->bc_ag.pag), fa);
 	xfs_warn(mp,
 "start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
 		irec->ir_startino, irec->ir_count, irec->ir_freecount,
@@ -551,7 +551,7 @@ xfs_inobt_insert_sprec(
 	struct xfs_buf			*agbp,
 	struct xfs_inobt_rec_incore	*nrec)	/* in/out: new/merged rec. */
 {
-	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_mount		*mp = pag_mount(pag);
 	struct xfs_btree_cur		*cur;
 	int				error;
 	int				i;
@@ -645,7 +645,7 @@ xfs_finobt_insert_sprec(
 	struct xfs_buf			*agbp,
 	struct xfs_inobt_rec_incore	*nrec)	/* in/out: new rec. */
 {
-	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_mount		*mp = pag_mount(pag);
 	struct xfs_btree_cur		*cur;
 	int				error;
 	int				i;
@@ -880,7 +880,7 @@ xfs_ialloc_ag_alloc(
 	 * rather than a linear progression to prevent the next generation
 	 * number from being easily guessable.
 	 */
-	error = xfs_ialloc_inode_init(args.mp, tp, NULL, newlen, pag->pag_agno,
+	error = xfs_ialloc_inode_init(args.mp, tp, NULL, newlen, pag_agno(pag),
 			args.agbno, args.len, get_random_u32());
 
 	if (error)
@@ -1071,7 +1071,7 @@ xfs_dialloc_check_ino(
 	if (error)
 		return -EAGAIN;
 
-	error = xfs_imap_to_bp(pag->pag_mount, tp, &imap, &bp);
+	error = xfs_imap_to_bp(pag_mount(pag), tp, &imap, &bp);
 	if (error)
 		return -EAGAIN;
 
@@ -1122,7 +1122,7 @@ xfs_dialloc_ag_inobt(
 	/*
 	 * If in the same AG as the parent, try to get near the parent.
 	 */
-	if (pagno == pag->pag_agno) {
+	if (pagno == pag_agno(pag)) {
 		int		doneleft;	/* done, to the left */
 		int		doneright;	/* done, to the right */
 
@@ -1599,7 +1599,7 @@ xfs_dialloc_ag(
 	 * parent. If so, find the closest available inode to the parent. If
 	 * not, consider the agi hint or find the first free inode in the AG.
 	 */
-	if (pag->pag_agno == pagno)
+	if (pag_agno(pag) == pagno)
 		error = xfs_dialloc_ag_finobt_near(pagino, &cur, &rec);
 	else
 		error = xfs_dialloc_ag_finobt_newino(agi, cur, &rec);
@@ -2053,7 +2053,7 @@ xfs_difree_inobt(
 	struct xfs_icluster		*xic,
 	struct xfs_inobt_rec_incore	*orec)
 {
-	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_mount		*mp = pag_mount(pag);
 	struct xfs_agi			*agi = agbp->b_addr;
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
@@ -2187,7 +2187,7 @@ xfs_difree_finobt(
 	xfs_agino_t			agino,
 	struct xfs_inobt_rec_incore	*ibtrec) /* inobt record */
 {
-	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_mount		*mp = pag_mount(pag);
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
 	int				offset = agino - ibtrec->ir_startino;
@@ -2310,9 +2310,9 @@ xfs_difree(
 	/*
 	 * Break up inode number into its components.
 	 */
-	if (pag->pag_agno != XFS_INO_TO_AGNO(mp, inode)) {
-		xfs_warn(mp, "%s: agno != pag->pag_agno (%d != %d).",
-			__func__, XFS_INO_TO_AGNO(mp, inode), pag->pag_agno);
+	if (pag_agno(pag) != XFS_INO_TO_AGNO(mp, inode)) {
+		xfs_warn(mp, "%s: agno != pag_agno(pag) (%d != %d).",
+			__func__, XFS_INO_TO_AGNO(mp, inode), pag_agno(pag));
 		ASSERT(0);
 		return -EINVAL;
 	}
@@ -2373,7 +2373,7 @@ xfs_imap_lookup(
 	xfs_agblock_t		*offset_agbno,
 	int			flags)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_inobt_rec_incore rec;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
@@ -2384,7 +2384,7 @@ xfs_imap_lookup(
 	if (error) {
 		xfs_alert(mp,
 			"%s: xfs_ialloc_read_agi() returned error %d, agno %d",
-			__func__, error, pag->pag_agno);
+			__func__, error, pag_agno(pag));
 		return error;
 	}
 
@@ -2434,7 +2434,7 @@ xfs_imap(
 	struct xfs_imap		*imap,	/* location map structure */
 	uint			flags)	/* flags for inode btree lookup */
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	xfs_agblock_t		agbno;	/* block number of inode in the alloc group */
 	xfs_agino_t		agino;	/* inode number within alloc group */
 	xfs_agblock_t		chunk_agbno;	/* first block in inode chunk */
@@ -2726,13 +2726,13 @@ xfs_read_agi(
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**agibpp)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	int			error;
 
 	trace_xfs_read_agi(pag);
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGI_DADDR(mp)),
+			XFS_AG_DADDR(mp, pag_agno(pag), XFS_AGI_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, agibpp, &xfs_agi_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
@@ -2780,7 +2780,7 @@ xfs_ialloc_read_agi(
 	 * we are in the middle of a forced shutdown.
 	 */
 	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		xfs_is_shutdown(pag->pag_mount));
+		xfs_is_shutdown(pag_mount(pag)));
 	if (agibpp)
 		*agibpp = agibp;
 	else
@@ -3119,13 +3119,13 @@ xfs_ialloc_check_shrink(
 	int			has;
 	int			error;
 
-	if (!xfs_has_sparseinodes(pag->pag_mount))
+	if (!xfs_has_sparseinodes(pag_mount(pag)))
 		return 0;
 
 	cur = xfs_inobt_init_cursor(pag, tp, agibp);
 
 	/* Look up the inobt record that would correspond to the new EOFS. */
-	agino = XFS_AGB_TO_AGINO(pag->pag_mount, new_length);
+	agino = XFS_AGB_TO_AGINO(pag_mount(pag), new_length);
 	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &has);
 	if (error || !has)
 		goto out;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 3291541ae9665a..91d44be2ce48bc 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -248,7 +248,7 @@ xfs_inobt_init_ptr_from_cur(
 {
 	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agi->agi_seqno));
+	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agi->agi_seqno));
 
 	ptr->s = agi->agi_root;
 }
@@ -260,7 +260,7 @@ xfs_finobt_init_ptr_from_cur(
 {
 	struct xfs_agi		*agi = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agi->agi_seqno));
+	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agi->agi_seqno));
 	ptr->s = agi->agi_free_root;
 }
 
@@ -478,7 +478,7 @@ xfs_inobt_init_cursor(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_btree_cur	*cur;
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_inobt_ops,
@@ -504,7 +504,7 @@ xfs_finobt_init_cursor(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_btree_cur	*cur;
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_finobt_ops,
@@ -715,7 +715,7 @@ static xfs_extlen_t
 xfs_inobt_max_size(
 	struct xfs_perag	*pag)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	xfs_agblock_t		agblocks = pag->block_count;
 
 	/* Bail out if we're uninitialized, which can happen in mkfs. */
@@ -727,7 +727,7 @@ xfs_inobt_max_size(
 	 * never be available for the kinds of things that would require btree
 	 * expansion.  We therefore can pretend the space isn't there.
 	 */
-	if (xfs_ag_contains_log(mp, pag->pag_agno))
+	if (xfs_ag_contains_log(mp, pag_agno(pag)))
 		agblocks -= mp->m_sb.sb_logblocks;
 
 	return xfs_btree_calc_size(M_IGEO(mp)->inobt_mnr,
@@ -791,10 +791,10 @@ xfs_finobt_calc_reserves(
 	xfs_extlen_t		tree_len = 0;
 	int			error;
 
-	if (!xfs_has_finobt(pag->pag_mount))
+	if (!xfs_has_finobt(pag_mount(pag)))
 		return 0;
 
-	if (xfs_has_inobtcounts(pag->pag_mount))
+	if (xfs_has_inobtcounts(pag_mount(pag)))
 		error = xfs_finobt_read_blocks(pag, tp, &tree_len);
 	else
 		error = xfs_finobt_count_blocks(pag, tp, &tree_len);
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 5e166553a7a6e9..b8789c42c230b4 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -154,7 +154,7 @@ xfs_refcount_complain_bad_rec(
 
 	xfs_warn(mp,
  "Refcount BTree record corruption in AG %d detected at %pS!",
-				cur->bc_ag.pag->pag_agno, fa);
+				pag_agno(cur->bc_ag.pag), fa);
 	xfs_warn(mp,
 		"Start block 0x%x, block count 0x%x, references 0x%x",
 		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
@@ -1321,7 +1321,7 @@ xfs_refcount_continue_op(
 	ri->ri_startblock = xfs_agbno_to_fsb(pag, new_agbno);
 
 	ASSERT(xfs_verify_fsbext(mp, ri->ri_startblock, ri->ri_blockcount));
-	ASSERT(pag->pag_agno == XFS_FSB_TO_AGNO(mp, ri->ri_startblock));
+	ASSERT(pag_agno(pag) == XFS_FSB_TO_AGNO(mp, ri->ri_startblock));
 
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index c4b10fbf8892a1..db389fdbd929a4 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -81,7 +81,7 @@ xfs_refcountbt_alloc_block(
 		*stat = 0;
 		return 0;
 	}
-	ASSERT(args.agno == cur->bc_ag.pag->pag_agno);
+	ASSERT(args.agno == pag_agno(cur->bc_ag.pag));
 	ASSERT(args.len == 1);
 
 	new->s = cpu_to_be32(args.agbno);
@@ -169,7 +169,7 @@ xfs_refcountbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_refcount_root;
 }
@@ -361,7 +361,7 @@ xfs_refcountbt_init_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
+	ASSERT(pag_agno(pag) < mp->m_sb.sb_agcount);
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_refcountbt_ops,
 			mp->m_refc_maxlevels, xfs_refcountbt_cur_cache);
@@ -514,7 +514,7 @@ xfs_refcountbt_calc_reserves(
 	 * never be available for the kinds of things that would require btree
 	 * expansion.  We therefore can pretend the space isn't there.
 	 */
-	if (xfs_ag_contains_log(mp, pag->pag_agno))
+	if (xfs_ag_contains_log(mp, pag_agno(pag)))
 		agblocks -= mp->m_sb.sb_logblocks;
 
 	*ask += xfs_refcountbt_max_size(mp, agblocks);
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 6ef4687b3aba8f..b6764d6b3ab891 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -213,7 +213,7 @@ xfs_rmap_check_irec(
 	struct xfs_perag		*pag,
 	const struct xfs_rmap_irec	*irec)
 {
-	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_mount		*mp = pag_mount(pag);
 	bool				is_inode;
 	bool				is_unwritten;
 	bool				is_bmbt;
@@ -288,7 +288,7 @@ xfs_rmap_complain_bad_rec(
 	else
 		xfs_warn(mp,
  "Reverse Mapping BTree record corruption in AG %d detected at %pS!",
-			cur->bc_ag.pag->pag_agno, fa);
+			pag_agno(cur->bc_ag.pag), fa);
 	xfs_warn(mp,
 		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index b49006c1ca7eee..6fd460fc7c9c1d 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -227,7 +227,7 @@ xfs_rmapbt_init_ptr_from_cur(
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
 
-	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(pag_agno(cur->bc_ag.pag) == be32_to_cpu(agf->agf_seqno));
 
 	ptr->s = agf->agf_rmap_root;
 }
@@ -647,9 +647,8 @@ xfs_rmapbt_mem_cursor(
 	struct xfbtree		*xfbt)
 {
 	struct xfs_btree_cur	*cur;
-	struct xfs_mount	*mp = pag->pag_mount;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rmapbt_mem_ops,
+	cur = xfs_btree_alloc_cursor(pag_mount(pag), tp, &xfs_rmapbt_mem_ops,
 			xfs_rmapbt_maxlevels_ondisk(), xfs_rmapbt_cur_cache);
 	cur->bc_mem.xfbtree = xfbt;
 	cur->bc_nlevels = xfbt->nlevels;
@@ -863,7 +862,7 @@ xfs_rmapbt_calc_reserves(
 	 * never be available for the kinds of things that would require btree
 	 * expansion.  We therefore can pretend the space isn't there.
 	 */
-	if (xfs_ag_contains_log(mp, pag->pag_agno))
+	if (xfs_ag_contains_log(mp, pag_agno(pag)))
 		agblocks -= mp->m_sb.sb_logblocks;
 
 	/* Reserve 1% of the AG or enough for 1 block per record. */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d95409f3cba667..d2012fbf07aa65 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1120,7 +1120,7 @@ xfs_update_secondary_sbs(
 		struct xfs_buf		*bp;
 
 		error = xfs_buf_get(mp->m_ddev_targp,
-				 XFS_AG_DADDR(mp, pag->pag_agno, XFS_SB_DADDR),
+				 XFS_AG_DADDR(mp, pag_agno(pag), XFS_SB_DADDR),
 				 XFS_FSS_TO_BB(mp, 1), &bp);
 		/*
 		 * If we get an error reading or writing alternate superblocks,
@@ -1132,7 +1132,7 @@ xfs_update_secondary_sbs(
 		if (error) {
 			xfs_warn(mp,
 		"error allocating secondary superblock for ag %d",
-				pag->pag_agno);
+				pag_agno(pag));
 			if (!saved_error)
 				saved_error = error;
 			continue;
@@ -1153,7 +1153,7 @@ xfs_update_secondary_sbs(
 		if (error) {
 			xfs_warn(mp,
 		"write error %d updating a secondary superblock near ag %d",
-				error, pag->pag_agno);
+				error, pag_agno(pag));
 			if (!saved_error)
 				saved_error = error;
 			continue;
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index a8cd44d03ef648..d3cb6ff3b91301 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -212,6 +212,14 @@ enum xbtree_recpacking {
 	XBTREE_RECPACKING_FULL,
 };
 
+enum xfs_group_type {
+	XG_TYPE_AG,
+	XG_TYPE_MAX,
+} __packed;
+
+#define XG_TYPE_STRINGS \
+	{ XG_TYPE_AG,	"ag" }
+
 /*
  * Type verifier functions
  */
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 82a850eba6c88c..0ea04d6e21cd83 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -208,7 +208,7 @@ xrep_agf_init_header(
 	memset(agf, 0, BBTOB(agf_bp->b_length));
 	agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
 	agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
-	agf->agf_seqno = cpu_to_be32(pag->pag_agno);
+	agf->agf_seqno = cpu_to_be32(pag_agno(pag));
 	agf->agf_length = cpu_to_be32(pag->block_count);
 	agf->agf_flfirst = old_agf->agf_flfirst;
 	agf->agf_fllast = old_agf->agf_fllast;
@@ -384,7 +384,7 @@ xrep_agf(
 	 * was corrupt after xfs_alloc_read_agf failed with -EFSCORRUPTED.
 	 */
 	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, sc->sa.pag->pag_agno,
+			XFS_AG_DADDR(mp, pag_agno(sc->sa.pag),
 						XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &agf_bp, NULL);
 	if (error)
@@ -687,7 +687,7 @@ xrep_agfl_init_header(
 	agfl = XFS_BUF_TO_AGFL(agfl_bp);
 	memset(agfl, 0xFF, BBTOB(agfl_bp->b_length));
 	agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
-	agfl->agfl_seqno = cpu_to_be32(sc->sa.pag->pag_agno);
+	agfl->agfl_seqno = cpu_to_be32(pag_agno(sc->sa.pag));
 	uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
 
 	/*
@@ -741,7 +741,7 @@ xrep_agfl(
 	 * was corrupt after xfs_alloc_read_agfl failed with -EFSCORRUPTED.
 	 */
 	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, sc->sa.pag->pag_agno,
+			XFS_AG_DADDR(mp, pag_agno(sc->sa.pag),
 						XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &agfl_bp, NULL);
 	if (error)
@@ -897,7 +897,7 @@ xrep_agi_init_header(
 	memset(agi, 0, BBTOB(agi_bp->b_length));
 	agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
 	agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
-	agi->agi_seqno = cpu_to_be32(pag->pag_agno);
+	agi->agi_seqno = cpu_to_be32(pag_agno(pag));
 	agi->agi_length = cpu_to_be32(pag->block_count);
 	agi->agi_newino = cpu_to_be32(NULLAGINO);
 	agi->agi_dirino = cpu_to_be32(NULLAGINO);
@@ -1112,9 +1112,9 @@ xrep_iunlink_igrab(
 	struct xfs_perag	*pag,
 	struct xfs_inode	*ip)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 
-	if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
+	if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag_agno(pag))
 		return false;
 
 	if (!xfs_inode_on_unlinked_list(ip))
@@ -1138,7 +1138,7 @@ xrep_iunlink_visit(
 	unsigned int		bucket;
 	int			error;
 
-	ASSERT(XFS_INO_TO_AGNO(mp, ip->i_ino) == ragi->sc->sa.pag->pag_agno);
+	ASSERT(XFS_INO_TO_AGNO(mp, ip->i_ino) == pag_agno(ragi->sc->sa.pag));
 	ASSERT(xfs_inode_on_unlinked_list(ip));
 
 	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
@@ -1169,7 +1169,7 @@ xrep_iunlink_mark_incore(
 	struct xrep_agi		*ragi)
 {
 	struct xfs_perag	*pag = ragi->sc->sa.pag;
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	uint32_t		first_index = 0;
 	bool			done = false;
 	unsigned int		nr_found = 0;
@@ -1209,7 +1209,7 @@ xrep_iunlink_mark_incore(
 			 * us to see this inode, so another lookup from the
 			 * same index will not find it again.
 			 */
-			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
+			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag_agno(pag))
 				continue;
 			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
@@ -1761,7 +1761,7 @@ xrep_agi(
 	 * was corrupt after xfs_ialloc_read_agi failed with -EFSCORRUPTED.
 	 */
 	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, sc->sa.pag->pag_agno,
+			XFS_AG_DADDR(mp, pag_agno(sc->sa.pag),
 						XFS_AGI_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &ragi->agi_bp, NULL);
 	if (error)
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 1e0c2db6dcf7df..ab0084c4249657 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -543,7 +543,7 @@ xrep_abt_dispose_one(
 
 	/* Add a deferred rmap for each extent we used. */
 	if (resv->used > 0)
-		xfs_rmap_alloc_extent(sc->tp, pag->pag_agno, resv->agbno,
+		xfs_rmap_alloc_extent(sc->tp, pag_agno(pag), resv->agbno,
 				resv->used, XFS_RMAP_OWN_AG);
 
 	/*
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 47148cc4a833e5..f3db628b14e1b9 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -216,7 +216,8 @@ int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 #define xchk_xfile_ag_descr(sc, fmt, ...) \
 	kasprintf(XCHK_GFP_FLAGS, "XFS (%s): AG 0x%x " fmt, \
 			(sc)->mp->m_super->s_id, \
-			(sc)->sa.pag ? (sc)->sa.pag->pag_agno : (sc)->sm->sm_agno, \
+			(sc)->sa.pag ? \
+				pag_agno((sc)->sa.pag) : (sc)->sm->sm_agno, \
 			##__VA_ARGS__)
 #define xchk_xfile_ino_descr(sc, fmt, ...) \
 	kasprintf(XCHK_GFP_FLAGS, "XFS (%s): inode 0x%llx " fmt, \
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index 7d876f0036fc49..647dd941098afb 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -814,7 +814,7 @@ xrep_iallocbt(
 	sc->sick_mask = XFS_SICK_AG_INOBT | XFS_SICK_AG_FINOBT;
 
 	/* Set up enough storage to handle an AG with nothing but inodes. */
-	xfs_agino_range(mp, sc->sa.pag->pag_agno, &first_agino, &last_agino);
+	xfs_agino_range(mp, pag_agno(sc->sa.pag), &first_agino, &last_agino);
 	last_agino /= XFS_INODES_PER_CHUNK;
 	descr = xchk_xfile_ag_descr(sc, "inode index records");
 	error = xfarray_create(descr, last_agino,
diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index cf9d983667cec6..84f117667ca2bf 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -67,7 +67,7 @@ xchk_iscan_mask_skipino(
 	xfs_agnumber_t		skip_agno = XFS_INO_TO_AGNO(mp, iscan->skip_ino);
 	xfs_agnumber_t		skip_agino = XFS_INO_TO_AGINO(mp, iscan->skip_ino);
 
-	if (pag->pag_agno != skip_agno)
+	if (pag_agno(pag) != skip_agno)
 		return;
 	if (skip_agino < rec->ir_startino)
 		return;
@@ -95,7 +95,7 @@ xchk_iscan_find_next(
 	struct xfs_btree_cur	*cur;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_trans	*tp = sc->tp;
-	xfs_agnumber_t		agno = pag->pag_agno;
+	xfs_agnumber_t		agno = pag_agno(pag);
 	xfs_agino_t		lastino = NULLAGINO;
 	xfs_agino_t		first, last;
 	xfs_agino_t		agino = *cursor;
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 81cad6c4fe6d9d..70af27d987342f 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -58,7 +58,7 @@ xrep_newbt_estimate_slack(
 
 	if (sc->ops->type == ST_PERAG) {
 		free = sc->sa.pag->pagf_freeblks;
-		sz = xfs_ag_block_count(sc->mp, sc->sa.pag->pag_agno);
+		sz = xfs_ag_block_count(sc->mp, pag_agno(sc->sa.pag));
 	} else {
 		free = percpu_counter_sum(&sc->mp->m_fdblocks);
 		sz = sc->mp->m_sb.sb_dblocks;
@@ -205,7 +205,7 @@ xrep_newbt_validate_ag_alloc_hint(
 	struct xfs_scrub	*sc = xnr->sc;
 	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(sc->mp, xnr->alloc_hint);
 
-	if (agno == sc->sa.pag->pag_agno &&
+	if (agno == pag_agno(sc->sa.pag) &&
 	    xfs_verify_fsbno(sc->mp, xnr->alloc_hint))
 		return;
 
@@ -250,8 +250,8 @@ xrep_newbt_alloc_ag_blocks(
 			return -ENOSPC;
 
 		agno = XFS_FSB_TO_AGNO(mp, args.fsbno);
-		if (agno != sc->sa.pag->pag_agno) {
-			ASSERT(agno == sc->sa.pag->pag_agno);
+		if (agno != pag_agno(sc->sa.pag)) {
+			ASSERT(agno == pag_agno(sc->sa.pag));
 			return -EFSCORRUPTED;
 		}
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f4ead287bd9821..3b4f6c207576a6 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -413,7 +413,7 @@ xrep_fix_freelist(
 
 	args.mp = sc->mp;
 	args.tp = sc->tp;
-	args.agno = sc->sa.pag->pag_agno;
+	args.agno = pag_agno(sc->sa.pag);
 	args.alignment = 1;
 	args.pag = sc->sa.pag;
 
@@ -972,7 +972,7 @@ xrep_reset_perag_resv(
 	if (error == -ENOSPC) {
 		xfs_err(sc->mp,
 "Insufficient free space to reset per-AG reservation for AG %u after repair.",
-				sc->sa.pag->pag_agno);
+				pag_agno(sc->sa.pag));
 		error = 0;
 	}
 
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index ba5bbc3fb754db..26b5c90b3f6aee 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -410,7 +410,7 @@ xchk_rmapbt_walk_ag_metadata(
 		goto out;
 
 	/* OWN_LOG: Internal log */
-	if (xfs_ag_contains_log(mp, sc->sa.pag->pag_agno)) {
+	if (xfs_ag_contains_log(mp, pag_agno(sc->sa.pag))) {
 		error = xagb_bitmap_set(&cr->log_owned,
 				XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart),
 				mp->m_sb.sb_logblocks);
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 57d445f7cb2a5d..f88f58db909867 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -344,7 +344,7 @@ xrep_rmap_visit_bmbt(
 	int			error;
 
 	if (XFS_FSB_TO_AGNO(mp, rec->br_startblock) !=
-			rf->rr->sc->sa.pag->pag_agno)
+			pag_agno(rf->rr->sc->sa.pag))
 		return 0;
 
 	agbno = XFS_FSB_TO_AGBNO(mp, rec->br_startblock);
@@ -391,7 +391,7 @@ xrep_rmap_visit_iroot_btree_block(
 		return 0;
 
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, xfs_buf_daddr(bp));
-	if (XFS_FSB_TO_AGNO(cur->bc_mp, fsbno) != rf->rr->sc->sa.pag->pag_agno)
+	if (XFS_FSB_TO_AGNO(cur->bc_mp, fsbno) != pag_agno(rf->rr->sc->sa.pag))
 		return 0;
 
 	agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
@@ -801,7 +801,7 @@ xrep_rmap_find_log_rmaps(
 {
 	struct xfs_scrub	*sc = rr->sc;
 
-	if (!xfs_ag_contains_log(sc->mp, sc->sa.pag->pag_agno))
+	if (!xfs_ag_contains_log(sc->mp, pag_agno(sc->sa.pag)))
 		return 0;
 
 	return xrep_rmap_stash(rr,
@@ -976,7 +976,7 @@ xrep_rmap_try_reserve(
 {
 	struct xrep_rmap_agfl	ra = {
 		.bitmap		= freesp_blocks,
-		.agno		= rr->sc->sa.pag->pag_agno,
+		.agno		= pag_agno(rr->sc->sa.pag),
 	};
 	struct xfs_scrub	*sc = rr->sc;
 	struct xrep_newbt_resv	*resv, *n;
@@ -1596,7 +1596,7 @@ xrep_rmap_setup_scan(
 
 	/* Set up in-memory rmap btree */
 	error = xfs_rmapbt_mem_init(sc->mp, &rr->rmap_btree, sc->xmbtp,
-			sc->sa.pag->pag_agno);
+			pag_agno(sc->sa.pag));
 	if (error)
 		goto out_mutex;
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index a1ec6445ae5fbf..58cc61f2ed5372 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -792,8 +792,8 @@ TRACE_EVENT(xchk_iallocbt_check_cluster,
 		__field(uint16_t, holemask)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->startino = startino;
 		__entry->map_daddr = map_daddr;
 		__entry->map_len = map_len;
@@ -936,8 +936,8 @@ TRACE_EVENT(xchk_refcount_incorrect,
 		__field(xfs_nlink_t, seen)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
@@ -1929,8 +1929,8 @@ DECLARE_EVENT_CLASS(xrep_extent_class,
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
@@ -1963,8 +1963,8 @@ DECLARE_EVENT_CLASS(xrep_reap_find_class,
 		__field(bool, crosslinked)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->crosslinked = crosslinked;
@@ -1997,8 +1997,8 @@ TRACE_EVENT(xrep_ibt_walk_rmap,
 		__field(unsigned int, flags)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->agbno = rec->rm_startblock;
 		__entry->len = rec->rm_blockcount;
 		__entry->owner = rec->rm_owner;
@@ -2026,8 +2026,8 @@ TRACE_EVENT(xrep_abt_found,
 		__field(xfs_extlen_t, blockcount)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->startblock = rec->ar_startblock;
 		__entry->blockcount = rec->ar_blockcount;
 	),
@@ -2052,8 +2052,8 @@ TRACE_EVENT(xrep_ibt_found,
 		__field(uint64_t, freemask)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->startino = rec->ir_startino;
 		__entry->holemask = rec->ir_holemask;
 		__entry->count = rec->ir_count;
@@ -2083,8 +2083,8 @@ TRACE_EVENT(xrep_refc_found,
 		__field(xfs_nlink_t, refcount)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->domain = rec->rc_domain;
 		__entry->startblock = rec->rc_startblock;
 		__entry->blockcount = rec->rc_blockcount;
@@ -2144,8 +2144,8 @@ TRACE_EVENT(xrep_rmap_found,
 		__field(unsigned int, flags)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->agbno = rec->rm_startblock;
 		__entry->len = rec->rm_blockcount;
 		__entry->owner = rec->rm_owner;
@@ -2174,8 +2174,8 @@ TRACE_EVENT(xrep_findroot_block,
 		__field(uint16_t, level)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->agbno = agbno;
 		__entry->magic = magic;
 		__entry->level = level;
@@ -2201,8 +2201,8 @@ TRACE_EVENT(xrep_calc_ag_resblks,
 		__field(xfs_agblock_t, usedlen)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->icount = icount;
 		__entry->aglen = aglen;
 		__entry->freelen = freelen;
@@ -2230,8 +2230,8 @@ TRACE_EVENT(xrep_calc_ag_resblks_btsize,
 		__field(xfs_agblock_t, refcbt_sz)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->bnobt_sz = bnobt_sz;
 		__entry->inobt_sz = inobt_sz;
 		__entry->rmapbt_sz = rmapbt_sz;
@@ -2282,8 +2282,8 @@ DECLARE_EVENT_CLASS(xrep_newbt_extent_class,
 		__field(int64_t, owner)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->owner = owner;
@@ -2597,8 +2597,8 @@ TRACE_EVENT(xrep_cow_free_staging,
 		__field(xfs_extlen_t, blockcount)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->agbno = agbno;
 		__entry->blockcount = blockcount;
 	),
@@ -2657,8 +2657,8 @@ TRACE_EVENT(xrep_rmap_live_update,
 		__field(unsigned int, flags)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->op = op;
 		__entry->agbno = p->startblock;
 		__entry->len = p->blockcount;
@@ -3317,9 +3317,9 @@ TRACE_EVENT(xrep_iunlink_visit,
 		__field(xfs_agino_t, next_agino)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
-		__entry->agino = XFS_INO_TO_AGINO(pag->pag_mount, ip->i_ino);
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
+		__entry->agino = XFS_INO_TO_AGINO(pag_mount(pag), ip->i_ino);
 		__entry->bucket = bucket;
 		__entry->bucket_agino = bucket_agino;
 		__entry->prev_agino = ip->i_prev_unlinked;
@@ -3405,8 +3405,8 @@ TRACE_EVENT(xrep_iunlink_walk_ondisk_bucket,
 		__field(xfs_agino_t, next_agino)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->bucket = bucket;
 		__entry->prev_agino = prev_agino;
 		__entry->next_agino = next_agino;
@@ -3431,8 +3431,8 @@ DECLARE_EVENT_CLASS(xrep_iunlink_resolve_class,
 		__field(xfs_agino_t, next_agino)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->bucket = bucket;
 		__entry->prev_agino = prev_agino;
 		__entry->next_agino = next_agino;
@@ -3518,8 +3518,8 @@ TRACE_EVENT(xrep_iunlink_add_to_bucket,
 		__field(xfs_agino_t, next_agino)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->bucket = bucket;
 		__entry->agino = agino;
 		__entry->next_agino = curr_head;
@@ -3544,8 +3544,8 @@ TRACE_EVENT(xrep_iunlink_commit_bucket,
 		__field(xfs_agino_t, agino)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->bucket = bucket;
 		__entry->old_agino = old_agino;
 		__entry->agino = agino;
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 79648f8c6b270b..dfd6edcebb6ea4 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -159,7 +159,7 @@ xfs_trim_gather_extents(
 	struct xfs_trim_cur	*tcur,
 	struct xfs_busy_extents	*extents)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_trans	*tp;
 	struct xfs_btree_cur	*cur;
 	struct xfs_buf		*agbp;
@@ -365,7 +365,7 @@ xfs_trim_perag_extents(
 		 * list  after this function call, as it may have been freed by
 		 * the time control returns to us.
 		 */
-		error = xfs_discard_extents(pag->pag_mount, extents);
+		error = xfs_discard_extents(pag_mount(pag), extents);
 		if (error)
 			break;
 
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 81099400a171dc..79b0f833c511e3 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -283,7 +283,7 @@ xfs_extent_busy_update_extent(
 
 out_force_log:
 	spin_unlock(&pag->pagb_lock);
-	xfs_log_force(pag->pag_mount, XFS_LOG_SYNC);
+	xfs_log_force(pag_mount(pag), XFS_LOG_SYNC);
 	trace_xfs_extent_busy_force(pag, fbno, flen);
 	spin_lock(&pag->pagb_lock);
 	return false;
@@ -659,7 +659,7 @@ xfs_extent_busy_ag_cmp(
 		container_of(l2, struct xfs_extent_busy, list);
 	s32 diff;
 
-	diff = b1->pag->pag_agno - b2->pag->pag_agno;
+	diff = pag_agno(b1->pag) - pag_agno(b2->pag);
 	if (!diff)
 		diff = b1->bno - b2->bno;
 	return diff;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 7f1be08dbc1123..c198962edea163 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -362,7 +362,7 @@ xfs_extent_free_diff_items(
 	struct xfs_extent_free_item	*ra = xefi_entry(a);
 	struct xfs_extent_free_item	*rb = xefi_entry(b);
 
-	return ra->xefi_pag->pag_agno - rb->xefi_pag->pag_agno;
+	return pag_agno(ra->xefi_pag) - pag_agno(rb->xefi_pag);
 }
 
 /* Log a free extent to the intent item. */
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index f5661d6d703ac2..59a641fffe8fe5 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -90,7 +90,7 @@ xfs_filestream_pick_ag(
 			maxfree = pag->pagf_freeblks;
 			if (max_pag)
 				xfs_perag_rele(max_pag);
-			atomic_inc(&pag->pag_active_ref);
+			atomic_inc(&pag->pag_group.xg_active_ref);
 			max_pag = pag;
 		}
 
@@ -225,7 +225,7 @@ xfs_filestream_lookup_association(
 	 * down immediately after we mark the lookup as done.
 	 */
 	pag = container_of(mru, struct xfs_fstrm_item, mru)->pag;
-	atomic_inc(&pag->pag_active_ref);
+	atomic_inc(&pag->pag_group.xg_active_ref);
 	xfs_mru_cache_done(mp->m_filestream);
 
 	trace_xfs_filestream_lookup(pag, ap->ip->i_ino);
@@ -278,7 +278,7 @@ xfs_filestream_create_association(
 		struct xfs_fstrm_item *item =
 			container_of(mru, struct xfs_fstrm_item, mru);
 
-		agno = (item->pag->pag_agno + 1) % mp->m_sb.sb_agcount;
+		agno = (pag_agno(item->pag) + 1) % mp->m_sb.sb_agcount;
 		xfs_fstrm_free_func(mp, mru);
 	} else if (xfs_is_inode32(mp)) {
 		xfs_agnumber_t	 rotorstep = xfs_rotorstep;
@@ -317,7 +317,7 @@ xfs_filestream_create_association(
 	if (!item)
 		goto out_put_fstrms;
 
-	atomic_inc(&args->pag->pag_active_ref);
+	atomic_inc(&args->pag->pag_group.xg_active_ref);
 	item->pag = args->pag;
 	error = xfs_mru_cache_insert(mp->m_filestream, pino, &item->mru);
 	if (error)
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index eff198ae1ce33a..918e1c38a15592 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -353,7 +353,7 @@ xfs_getfsmap_helper(
 		return -ECANCELED;
 
 	trace_xfs_fsmap_mapping(mp, info->dev,
-			info->pag ? info->pag->pag_agno : NULLAGNUMBER, rec);
+			info->pag ? pag_agno(info->pag) : NULLAGNUMBER, rec);
 
 	fmr.fmr_device = info->dev;
 	fmr.fmr_physical = rec_daddr;
@@ -519,7 +519,7 @@ __xfs_getfsmap_datadev(
 		 * is the last AG that we're querying.
 		 */
 		info->pag = pag;
-		if (pag->pag_agno == end_ag) {
+		if (pag_agno(pag) == end_ag) {
 			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
 					end_fsb);
 			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
@@ -541,9 +541,9 @@ __xfs_getfsmap_datadev(
 		if (error)
 			break;
 
-		trace_xfs_fsmap_low_key(mp, info->dev, pag->pag_agno,
+		trace_xfs_fsmap_low_key(mp, info->dev, pag_agno(pag),
 				&info->low);
-		trace_xfs_fsmap_high_key(mp, info->dev, pag->pag_agno,
+		trace_xfs_fsmap_high_key(mp, info->dev, pag_agno(pag),
 				&info->high);
 
 		error = query_fn(tp, info, &bt_cur, priv);
@@ -554,7 +554,7 @@ __xfs_getfsmap_datadev(
 		 * Set the AG low key to the start of the AG prior to
 		 * moving on to the next AG.
 		 */
-		if (pag->pag_agno == start_ag)
+		if (pag_agno(pag) == start_ag)
 			memset(&info->low, 0, sizeof(info->low));
 
 		/*
@@ -562,7 +562,7 @@ __xfs_getfsmap_datadev(
 		 * before we drop the reference to the perag when the loop
 		 * terminates.
 		 */
-		if (pag->pag_agno == end_ag) {
+		if (pag_agno(pag) == end_ag) {
 			info->last = true;
 			error = query_fn(tp, info, &bt_cur, priv);
 			if (error)
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6b119a7a324fa4..b269a25dadf25d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -204,7 +204,7 @@ xfs_reclaim_work_queue(
 {
 
 	rcu_read_lock();
-	if (xa_marked(&mp->m_perags, XFS_PERAG_RECLAIM_MARK)) {
+	if (xfs_group_marked(mp, XG_TYPE_AG, XFS_PERAG_RECLAIM_MARK)) {
 		queue_delayed_work(mp->m_reclaim_workqueue, &mp->m_reclaim_work,
 			msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
 	}
@@ -219,15 +219,14 @@ static inline void
 xfs_blockgc_queue(
 	struct xfs_perag	*pag)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 
 	if (!xfs_is_blockgc_enabled(mp))
 		return;
 
 	rcu_read_lock();
 	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG))
-		queue_delayed_work(pag->pag_mount->m_blockgc_wq,
-				   &pag->pag_blockgc_work,
+		queue_delayed_work(mp->m_blockgc_wq, &pag->pag_blockgc_work,
 				   msecs_to_jiffies(xfs_blockgc_secs * 1000));
 	rcu_read_unlock();
 }
@@ -239,7 +238,6 @@ xfs_perag_set_inode_tag(
 	xfs_agino_t		agino,
 	unsigned int		tag)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
 	bool			was_tagged;
 
 	lockdep_assert_held(&pag->pag_ici_lock);
@@ -253,13 +251,13 @@ xfs_perag_set_inode_tag(
 	if (was_tagged)
 		return;
 
-	/* propagate the tag up into the perag radix tree */
-	xa_set_mark(&mp->m_perags, pag->pag_agno, ici_tag_to_mark(tag));
+	/* propagate the tag up into the pag xarray tree */
+	xfs_group_set_mark(&pag->pag_group, ici_tag_to_mark(tag));
 
 	/* start background work */
 	switch (tag) {
 	case XFS_ICI_RECLAIM_TAG:
-		xfs_reclaim_work_queue(mp);
+		xfs_reclaim_work_queue(pag_mount(pag));
 		break;
 	case XFS_ICI_BLOCKGC_TAG:
 		xfs_blockgc_queue(pag);
@@ -276,8 +274,6 @@ xfs_perag_clear_inode_tag(
 	xfs_agino_t		agino,
 	unsigned int		tag)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
-
 	lockdep_assert_held(&pag->pag_ici_lock);
 
 	/*
@@ -295,9 +291,8 @@ xfs_perag_clear_inode_tag(
 	if (radix_tree_tagged(&pag->pag_ici_root, tag))
 		return;
 
-	/* clear the tag from the perag radix tree */
-	xa_clear_mark(&mp->m_perags, pag->pag_agno, ici_tag_to_mark(tag));
-
+	/* clear the tag from the pag xarray */
+	xfs_group_clear_mark(&pag->pag_group, ici_tag_to_mark(tag));
 	trace_xfs_perag_clear_inode_tag(pag, _RET_IP_);
 }
 
@@ -310,22 +305,9 @@ xfs_perag_grab_next_tag(
 	struct xfs_perag	*pag,
 	int			tag)
 {
-	unsigned long		index = 0;
-
-	if (pag) {
-		index = pag->pag_agno + 1;
-		xfs_perag_rele(pag);
-	}
-
-	rcu_read_lock();
-	pag = xa_find(&mp->m_perags, &index, ULONG_MAX, ici_tag_to_mark(tag));
-	if (pag) {
-		trace_xfs_perag_grab_next_tag(pag, _RET_IP_);
-		if (!atomic_inc_not_zero(&pag->pag_active_ref))
-			pag = NULL;
-	}
-	rcu_read_unlock();
-	return pag;
+	return to_perag(xfs_group_grab_next_mark(mp,
+			pag ? &pag->pag_group : NULL,
+			ici_tag_to_mark(tag), XG_TYPE_AG));
 }
 
 /*
@@ -1014,7 +996,7 @@ xfs_reclaim_inodes(
 	if (xfs_want_reclaim_sick(mp))
 		icw.icw_flags |= XFS_ICWALK_FLAG_RECLAIM_SICK;
 
-	while (xa_marked(&mp->m_perags, XFS_PERAG_RECLAIM_MARK)) {
+	while (xfs_group_marked(mp, XG_TYPE_AG, XFS_PERAG_RECLAIM_MARK)) {
 		xfs_ail_push_all_sync(mp->m_ail);
 		xfs_icwalk(mp, XFS_ICWALK_RECLAIM, &icw);
 	}
@@ -1056,7 +1038,7 @@ long
 xfs_reclaim_inodes_count(
 	struct xfs_mount	*mp)
 {
-	XA_STATE		(xas, &mp->m_perags, 0);
+	XA_STATE		(xas, &mp->m_groups[XG_TYPE_AG].xa, 0);
 	long			reclaimable = 0;
 	struct xfs_perag	*pag;
 
@@ -1499,7 +1481,7 @@ xfs_blockgc_worker(
 {
 	struct xfs_perag	*pag = container_of(to_delayed_work(work),
 					struct xfs_perag, pag_blockgc_work);
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	int			error;
 
 	trace_xfs_blockgc_worker(mp, __return_address);
@@ -1507,7 +1489,7 @@ xfs_blockgc_worker(
 	error = xfs_icwalk_ag(pag, XFS_ICWALK_BLOCKGC, NULL);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
-				pag->pag_agno, error);
+				pag_agno(pag), error);
 	xfs_blockgc_queue(pag);
 }
 
@@ -1548,8 +1530,7 @@ xfs_blockgc_flush_all(
 	 * queued, it will not be requeued.  Then flush whatever is left.
 	 */
 	while ((pag = xfs_perag_grab_next_tag(mp, pag, XFS_ICI_BLOCKGC_TAG)))
-		mod_delayed_work(pag->pag_mount->m_blockgc_wq,
-				&pag->pag_blockgc_work, 0);
+		mod_delayed_work(mp->m_blockgc_wq, &pag->pag_blockgc_work, 0);
 
 	while ((pag = xfs_perag_grab_next_tag(mp, pag, XFS_ICI_BLOCKGC_TAG)))
 		flush_delayed_work(&pag->pag_blockgc_work);
@@ -1688,7 +1669,7 @@ xfs_icwalk_ag(
 	enum xfs_icwalk_goal	goal,
 	struct xfs_icwalk	*icw)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	uint32_t		first_index;
 	int			last_error = 0;
 	int			skipped;
@@ -1741,7 +1722,7 @@ xfs_icwalk_ag(
 			 * us to see this inode, so another lookup from the
 			 * same index will not find it again.
 			 */
-			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
+			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag_agno(pag))
 				continue;
 			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a787dce6e081ce..07356c0c1ed7cc 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1514,7 +1514,7 @@ xfs_iunlink_reload_next(
 	xfs_agino_t		next_agino)
 {
 	struct xfs_perag	*pag = agibp->b_pag;
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_inode	*next_ip = NULL;
 	int			error;
 
@@ -1529,7 +1529,7 @@ xfs_iunlink_reload_next(
 
 	xfs_info_ratelimited(mp,
  "Found unrecovered unlinked inode 0x%x in AG 0x%x.  Initiating recovery.",
-			next_agino, pag->pag_agno);
+			next_agino, pag_agno(pag));
 
 	/*
 	 * Use an untrusted lookup just to be cautious in case the AGI has been
@@ -1572,7 +1572,7 @@ xfs_ifree_mark_inode_stale(
 	struct xfs_inode	*free_ip,
 	xfs_ino_t		inum)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_inode_log_item *iip;
 	struct xfs_inode	*ip;
 
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index a89ae2aef7c445..ec2d56f1840fc6 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -188,7 +188,7 @@ xfs_iwalk_ag_recs(
 			return 0;
 
 		if (iwag->inobt_walk_fn) {
-			error = iwag->inobt_walk_fn(mp, tp, pag->pag_agno, irec,
+			error = iwag->inobt_walk_fn(mp, tp, pag_agno(pag), irec,
 					iwag->data);
 			if (error)
 				return error;
@@ -405,7 +405,7 @@ xfs_iwalk_ag(
 	int				error = 0;
 
 	/* Set up our cursor at the right place in the inode btree. */
-	ASSERT(pag->pag_agno == XFS_INO_TO_AGNO(mp, iwag->startino));
+	ASSERT(pag_agno(pag) == XFS_INO_TO_AGNO(mp, iwag->startino));
 	agino = XFS_INO_TO_AGINO(mp, iwag->startino);
 	error = xfs_iwalk_ag_start(iwag, agino, &cur, &agi_bp, &has_more);
 
@@ -677,7 +677,7 @@ xfs_iwalk_threaded(
 		iwag->sz_recs = xfs_iwalk_prefetch(inode_records);
 		iwag->lastino = NULLFSINO;
 		xfs_pwork_queue(&pctl, &iwag->pwork);
-		startino = XFS_AGINO_TO_INO(mp, pag->pag_agno + 1, 0);
+		startino = XFS_AGINO_TO_INO(mp, pag_agno(pag) + 1, 0);
 		if (flags & XFS_IWALK_SAME_AG)
 			break;
 	}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 58f5e194266c7c..a3cc76bb93274d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2677,7 +2677,7 @@ xlog_recover_clear_agi_bucket(
 	struct xfs_perag	*pag,
 	int			bucket)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_trans	*tp;
 	struct xfs_agi		*agi;
 	struct xfs_buf		*agibp;
@@ -2708,7 +2708,7 @@ xlog_recover_clear_agi_bucket(
 	xfs_trans_cancel(tp);
 out_error:
 	xfs_warn(mp, "%s: failed to clear agi %d. Continuing.", __func__,
-			pag->pag_agno);
+			pag_agno(pag));
 	return;
 }
 
@@ -2718,7 +2718,7 @@ xlog_recover_iunlink_bucket(
 	struct xfs_agi		*agi,
 	int			bucket)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = pag_mount(pag);
 	struct xfs_inode	*prev_ip = NULL;
 	struct xfs_inode	*ip;
 	xfs_agino_t		prev_agino, agino;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 96496f39f551ae..530d7f025506ce 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -71,6 +71,10 @@ struct xfs_inodegc {
 	unsigned int		cpu;
 };
 
+struct xfs_groups {
+	struct xarray		xa;
+};
+
 /*
  * The struct xfsmount layout is optimised to separate read-mostly variables
  * from variables that are frequently modified. We put the read-mostly variables
@@ -208,7 +212,7 @@ typedef struct xfs_mount {
 	 */
 	atomic64_t		m_allocbt_blks;
 
-	struct xarray		m_perags;	/* per-ag accounting info */
+	struct xfs_groups	m_groups[XG_TYPE_MAX];
 	uint64_t		m_resblks;	/* total reserved blocks */
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 27398512b179b2..29f101005f3eda 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -244,7 +244,7 @@ xfs_refcount_update_diff_items(
 	struct xfs_refcount_intent	*ra = ci_entry(a);
 	struct xfs_refcount_intent	*rb = ci_entry(b);
 
-	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
+	return pag_agno(ra->ri_pag) - pag_agno(rb->ri_pag);
 }
 
 /* Log refcount updates in the intent item. */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 5bf6682e701b5a..2e82b5b6ed52d2 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -144,7 +144,7 @@ xfs_reflink_find_shared(
 	if (error)
 		return error;
 
-	cur = xfs_refcountbt_init_cursor(pag->pag_mount, tp, agbp, pag);
+	cur = xfs_refcountbt_init_cursor(pag_mount(pag), tp, agbp, pag);
 
 	error = xfs_refcount_find_shared(cur, agbno, aglen, fbno, flen,
 			find_end_of_shared);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 88b5580e1e19f5..1b83d09351f028 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -243,7 +243,7 @@ xfs_rmap_update_diff_items(
 	struct xfs_rmap_intent		*ra = ri_entry(a);
 	struct xfs_rmap_intent		*rb = ri_entry(b);
 
-	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
+	return pag_agno(ra->ri_pag) - pag_agno(rb->ri_pag);
 }
 
 /* Log rmap updates in the intent item. */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fbb3a1594c0dcc..457c2d70968d9a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -238,7 +238,7 @@ xfs_set_inode_alloc_perag(
 	xfs_ino_t		ino,
 	xfs_agnumber_t		max_metadata)
 {
-	if (!xfs_is_inode32(pag->pag_mount)) {
+	if (!xfs_is_inode32(pag_mount(pag))) {
 		set_bit(XFS_AGSTATE_ALLOWS_INODES, &pag->pag_opstate);
 		clear_bit(XFS_AGSTATE_PREFERS_METADATA, &pag->pag_opstate);
 		return false;
@@ -251,7 +251,7 @@ xfs_set_inode_alloc_perag(
 	}
 
 	set_bit(XFS_AGSTATE_ALLOWS_INODES, &pag->pag_opstate);
-	if (pag->pag_agno < max_metadata)
+	if (pag_agno(pag) < max_metadata)
 		set_bit(XFS_AGSTATE_PREFERS_METADATA, &pag->pag_opstate);
 	else
 		clear_bit(XFS_AGSTATE_PREFERS_METADATA, &pag->pag_opstate);
@@ -2011,17 +2011,20 @@ static const struct fs_context_operations xfs_context_ops = {
  * mount option parsing having already been performed as this can be called from
  * fsopen() before any parameters have been set.
  */
-static int xfs_init_fs_context(
+static int
+xfs_init_fs_context(
 	struct fs_context	*fc)
 {
 	struct xfs_mount	*mp;
+	int			i;
 
 	mp = kzalloc(sizeof(struct xfs_mount), GFP_KERNEL | __GFP_NOFAIL);
 	if (!mp)
 		return -ENOMEM;
 
 	spin_lock_init(&mp->m_sb_lock);
-	xa_init(&mp->m_perags);
+	for (i = 0; i < XG_TYPE_MAX; i++)
+		xa_init(&mp->m_groups[i].xa);
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 7ef50107224647..a1a63c47eb6af2 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -6,6 +6,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_group.h"
 #include "xfs_bit.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f0f79584b85e99..b8604c4e137292 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -72,6 +72,7 @@ struct xfs_btree_cur;
 struct xfs_defer_op_type;
 struct xfs_refcount_irec;
 struct xfs_fsmap;
+struct xfs_group;
 struct xfs_rmap_irec;
 struct xfs_icreate_log;
 struct xfs_iunlink_item;
@@ -192,10 +193,11 @@ DECLARE_EVENT_CLASS(xfs_perag_class,
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
-		__entry->refcount = atomic_read(&pag->pag_ref);
-		__entry->active_refcount = atomic_read(&pag->pag_active_ref);
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
+		__entry->refcount = atomic_read(&pag->pag_group.xg_ref);
+		__entry->active_refcount =
+			atomic_read(&pag->pag_group.xg_active_ref);
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d agno 0x%x passive refs %d active refs %d caller %pS",
@@ -210,16 +212,51 @@ DECLARE_EVENT_CLASS(xfs_perag_class,
 DEFINE_EVENT(xfs_perag_class, name,	\
 	TP_PROTO(const struct xfs_perag *pag, unsigned long caller_ip), \
 	TP_ARGS(pag, caller_ip))
-DEFINE_PERAG_REF_EVENT(xfs_perag_get);
-DEFINE_PERAG_REF_EVENT(xfs_perag_hold);
-DEFINE_PERAG_REF_EVENT(xfs_perag_put);
-DEFINE_PERAG_REF_EVENT(xfs_perag_grab);
-DEFINE_PERAG_REF_EVENT(xfs_perag_grab_next_tag);
-DEFINE_PERAG_REF_EVENT(xfs_perag_rele);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_reclaim_inodes_count);
 
+TRACE_DEFINE_ENUM(XG_TYPE_AG);
+
+DECLARE_EVENT_CLASS(xfs_group_class,
+	TP_PROTO(struct xfs_group *xg, unsigned long caller_ip),
+	TP_ARGS(xg, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
+		__field(xfs_agnumber_t, agno)
+		__field(int, refcount)
+		__field(int, active_refcount)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = xg->xg_mount->m_super->s_dev;
+		__entry->type = xg->xg_type;
+		__entry->agno = xg->xg_index;
+		__entry->refcount = atomic_read(&xg->xg_ref);
+		__entry->active_refcount = atomic_read(&xg->xg_active_ref);
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d %sno 0x%x passive refs %d active refs %d caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
+		  __entry->agno,
+		  __entry->refcount,
+		  __entry->active_refcount,
+		  (char *)__entry->caller_ip)
+);
+
+#define DEFINE_GROUP_REF_EVENT(name)	\
+DEFINE_EVENT(xfs_group_class, name,	\
+	TP_PROTO(struct xfs_group *xg, unsigned long caller_ip), \
+	TP_ARGS(xg, caller_ip))
+DEFINE_GROUP_REF_EVENT(xfs_group_get);
+DEFINE_GROUP_REF_EVENT(xfs_group_hold);
+DEFINE_GROUP_REF_EVENT(xfs_group_put);
+DEFINE_GROUP_REF_EVENT(xfs_group_grab);
+DEFINE_GROUP_REF_EVENT(xfs_group_grab_next_tag);
+DEFINE_GROUP_REF_EVENT(xfs_group_rele);
+
 TRACE_EVENT(xfs_inodegc_worker,
 	TP_PROTO(struct xfs_mount *mp, unsigned int shrinker_hits),
 	TP_ARGS(mp, shrinker_hits),
@@ -307,8 +344,8 @@ DECLARE_EVENT_CLASS(xfs_ag_class,
 		__field(xfs_agnumber_t, agno)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 	),
 	TP_printk("dev %d:%d agno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -672,9 +709,9 @@ DECLARE_EVENT_CLASS(xfs_filestream_class,
 		__field(int, streams)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
 		__entry->ino = ino;
-		__entry->agno = pag->pag_agno;
+		__entry->agno = pag_agno(pag);
 		__entry->streams = atomic_read(&pag->pagf_fstrms);
 	),
 	TP_printk("dev %d:%d ino 0x%llx agno 0x%x streams %d",
@@ -702,10 +739,10 @@ TRACE_EVENT(xfs_filestream_pick,
 		__field(xfs_extlen_t, free)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
 		__entry->ino = ino;
 		if (pag) {
-			__entry->agno = pag->pag_agno;
+			__entry->agno = pag_agno(pag);
 			__entry->streams = atomic_read(&pag->pagf_fstrms);
 		} else {
 			__entry->agno = NULLAGNUMBER;
@@ -913,8 +950,8 @@ TRACE_EVENT(xfs_irec_merge_pre,
 		__field(uint16_t, nholemask)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->agino = rec->ir_startino;
 		__entry->holemask = rec->ir_holemask;
 		__entry->nagino = nrec->ir_startino;
@@ -940,8 +977,8 @@ TRACE_EVENT(xfs_irec_merge_post,
 		__field(uint16_t, holemask)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->agino = nrec->ir_startino;
 		__entry->holemask = nrec->ir_holemask;
 	),
@@ -1651,8 +1688,8 @@ DECLARE_EVENT_CLASS(xfs_extent_busy_class,
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
@@ -1685,8 +1722,8 @@ TRACE_EVENT(xfs_extent_busy_trim,
 		__field(xfs_extlen_t, tlen)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->tbno = tbno;
@@ -1778,8 +1815,8 @@ TRACE_EVENT(xfs_free_extent,
 		__field(int, haveright)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->resv = resv;
@@ -2442,8 +2479,8 @@ DECLARE_EVENT_CLASS(xfs_discard_class,
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
@@ -2548,7 +2585,7 @@ TRACE_EVENT(xfs_btree_alloc_block,
 			__entry->ino = cur->bc_ino.ip->i_ino;
 			break;
 		case XFS_BTREE_TYPE_AG:
-			__entry->agno = cur->bc_ag.pag->pag_agno;
+			__entry->agno = pag_agno(cur->bc_ag.pag);
 			__entry->ino = 0;
 			break;
 		case XFS_BTREE_TYPE_MEM:
@@ -2804,7 +2841,7 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		__entry->agno = pag_agno(cur->bc_ag.pag);
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->owner = oinfo->oi_owner;
@@ -2849,7 +2886,7 @@ DECLARE_EVENT_CLASS(xfs_btree_error_class,
 			__entry->ino = cur->bc_ino.ip->i_ino;
 			break;
 		case XFS_BTREE_TYPE_AG:
-			__entry->agno = cur->bc_ag.pag->pag_agno;
+			__entry->agno = pag_agno(cur->bc_ag.pag);
 			__entry->ino = 0;
 			break;
 		case XFS_BTREE_TYPE_MEM:
@@ -2903,7 +2940,7 @@ TRACE_EVENT(xfs_rmap_convert_state,
 			__entry->ino = cur->bc_ino.ip->i_ino;
 			break;
 		case XFS_BTREE_TYPE_AG:
-			__entry->agno = cur->bc_ag.pag->pag_agno;
+			__entry->agno = pag_agno(cur->bc_ag.pag);
 			__entry->ino = 0;
 			break;
 		case XFS_BTREE_TYPE_MEM:
@@ -2938,7 +2975,7 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		__entry->agno = pag_agno(cur->bc_ag.pag);
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->owner = owner;
@@ -3111,8 +3148,8 @@ DECLARE_EVENT_CLASS(xfs_ag_resv_class,
 	TP_fast_assign(
 		struct xfs_ag_resv	*r = xfs_perag_resv(pag, resv);
 
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->resv = resv;
 		__entry->freeblks = pag->pagf_freeblks;
 		__entry->flcount = pag->pagf_flcount;
@@ -3156,8 +3193,8 @@ TRACE_EVENT(xfs_ag_resv_init_error,
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->error = error;
 		__entry->caller_ip = caller_ip;
 	),
@@ -3182,7 +3219,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		__entry->agno = pag_agno(cur->bc_ag.pag);
 		__entry->agbno = agbno;
 		__entry->len = len;
 	),
@@ -3213,7 +3250,7 @@ TRACE_EVENT(xfs_refcount_lookup,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		__entry->agno = pag_agno(cur->bc_ag.pag);
 		__entry->agbno = agbno;
 		__entry->dir = dir;
 	),
@@ -3239,7 +3276,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		__entry->agno = pag_agno(cur->bc_ag.pag);
 		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
@@ -3275,7 +3312,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		__entry->agno = pag_agno(cur->bc_ag.pag);
 		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
@@ -3317,7 +3354,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		__entry->agno = pag_agno(cur->bc_ag.pag);
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
@@ -3367,7 +3404,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		__entry->agno = pag_agno(cur->bc_ag.pag);
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
@@ -3422,7 +3459,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		__entry->agno = pag_agno(cur->bc_ag.pag);
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
@@ -4045,8 +4082,8 @@ TRACE_EVENT(xfs_iunlink_update_bucket,
 		__field(xfs_agino_t, new_ptr)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->bucket = bucket;
 		__entry->old_ptr = old_ptr;
 		__entry->new_ptr = new_ptr;
@@ -4070,8 +4107,8 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
 		__field(xfs_agino_t, new_ptr)
 	),
 	TP_fast_assign(
-		__entry->dev = iup->pag->pag_mount->m_super->s_dev;
-		__entry->agno = iup->pag->pag_agno;
+		__entry->dev = pag_mount(iup->pag)->m_super->s_dev;
+		__entry->agno = pag_agno(iup->pag);
 		__entry->agino =
 			XFS_INO_TO_AGINO(iup->ip->i_mount, iup->ip->i_ino);
 		__entry->old_ptr = old_ptr;
@@ -4192,8 +4229,8 @@ DECLARE_EVENT_CLASS(xfs_ag_corrupt_class,
 		__field(unsigned int, flags)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->flags = flags;
 	),
 	TP_printk("dev %d:%d agno 0x%x flags 0x%x",
@@ -4246,8 +4283,8 @@ TRACE_EVENT(xfs_iwalk_ag_rec,
 		__field(uint64_t, freemask)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->startino = irec->ir_startino;
 		__entry->freemask = irec->ir_free;
 	),
@@ -4309,7 +4346,7 @@ TRACE_EVENT(xfs_btree_commit_afakeroot,
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
 		__assign_str(name);
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		__entry->agno = pag_agno(cur->bc_ag.pag);
 		__entry->agbno = cur->bc_ag.afake->af_root;
 		__entry->levels = cur->bc_ag.afake->af_levels;
 		__entry->blocks = cur->bc_ag.afake->af_blocks;
@@ -4424,7 +4461,7 @@ TRACE_EVENT(xfs_btree_bload_block,
 			__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsb);
 			__entry->agbno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsb);
 		} else {
-			__entry->agno = cur->bc_ag.pag->pag_agno;
+			__entry->agno = pag_agno(cur->bc_ag.pag);
 			__entry->agbno = be32_to_cpu(ptr->s);
 		}
 		__entry->nr_records = nr_records;
@@ -4659,8 +4696,8 @@ DECLARE_EVENT_CLASS(xfs_perag_intents_class,
 		__field(void *, caller_ip)
 	),
 	TP_fast_assign(
-		__entry->dev = pag->pag_mount->m_super->s_dev;
-		__entry->agno = pag->pag_agno;
+		__entry->dev = pag_mount(pag)->m_super->s_dev;
+		__entry->agno = pag_agno(pag);
 		__entry->nr_intents = atomic_read(&pag->pag_intents_drain.dr_count);
 		__entry->caller_ip = caller_ip;
 	),


