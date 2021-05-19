Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CF338844F
	for <lists+linux-xfs@lfdr.de>; Wed, 19 May 2021 03:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbhESBW0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 May 2021 21:22:26 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:39586 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231835AbhESBWY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 May 2021 21:22:24 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id E6D70675A8
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 11:21:03 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljAtT-002bOE-Fv
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:21:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljAtT-001tK8-7s
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 11:21:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/23] xfs: pass perags through to the busy extent code
Date:   Wed, 19 May 2021 11:20:47 +1000
Message-Id: <20210519012102.450926-9-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519012102.450926-1-david@fromorbit.com>
References: <20210519012102.450926-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=T5Wa2CqtTbjqHhwULiAA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

All of the callers of the busy extent API either have perag
references available to use so we can pass a perag to the busy
extent functions rather than having them have to do unnecessary
lookups.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c       | 37 +++++++++++++++++----------------
 fs/xfs/libxfs/xfs_alloc.h       |  2 +-
 fs/xfs/libxfs/xfs_alloc_btree.c |  5 ++---
 fs/xfs/libxfs/xfs_rmap.c        | 32 ++++++++++++++++------------
 fs/xfs/libxfs/xfs_rmap_btree.c  |  7 +++----
 fs/xfs/scrub/repair.c           |  4 ++--
 fs/xfs/xfs_discard.c            |  2 +-
 fs/xfs/xfs_extent_busy.c        | 24 ++++++---------------
 fs/xfs/xfs_extent_busy.h        |  7 ++++---
 9 files changed, 57 insertions(+), 63 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index dc2b77829915..ce31c00dbf6f 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1063,7 +1063,7 @@ xfs_alloc_ag_vextent_small(
 	if (fbno == NULLAGBLOCK)
 		goto out;
 
-	xfs_extent_busy_reuse(args->mp, args->agno, fbno, 1,
+	xfs_extent_busy_reuse(args->mp, args->pag, fbno, 1,
 			      (args->datatype & XFS_ALLOC_NOBUSY));
 
 	if (args->datatype & XFS_ALLOC_USERDATA) {
@@ -1178,7 +1178,7 @@ xfs_alloc_ag_vextent(
 		if (error)
 			return error;
 
-		ASSERT(!xfs_extent_busy_search(args->mp, args->agno,
+		ASSERT(!xfs_extent_busy_search(args->mp, args->pag,
 					      args->agbno, args->len));
 	}
 
@@ -3292,7 +3292,7 @@ xfs_alloc_vextent(
 int
 xfs_free_extent_fix_freelist(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	struct xfs_buf		**agbp)
 {
 	struct xfs_alloc_arg	args;
@@ -3301,7 +3301,8 @@ xfs_free_extent_fix_freelist(
 	memset(&args, 0, sizeof(struct xfs_alloc_arg));
 	args.tp = tp;
 	args.mp = tp->t_mountp;
-	args.agno = agno;
+	args.agno = pag->pag_agno;
+	args.pag = pag;
 
 	/*
 	 * validate that the block number is legal - the enables us to detect
@@ -3310,17 +3311,12 @@ xfs_free_extent_fix_freelist(
 	if (args.agno >= args.mp->m_sb.sb_agcount)
 		return -EFSCORRUPTED;
 
-	args.pag = xfs_perag_get(args.mp, args.agno);
-	ASSERT(args.pag);
-
 	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
 	if (error)
-		goto out;
+		return error;
 
 	*agbp = args.agbp;
-out:
-	xfs_perag_put(args.pag);
-	return error;
+	return 0;
 }
 
 /*
@@ -3344,6 +3340,7 @@ __xfs_free_extent(
 	struct xfs_agf			*agf;
 	int				error;
 	unsigned int			busy_flags = 0;
+	struct xfs_perag		*pag;
 
 	ASSERT(len != 0);
 	ASSERT(type != XFS_AG_RESV_AGFL);
@@ -3352,33 +3349,37 @@ __xfs_free_extent(
 			XFS_ERRTAG_FREE_EXTENT))
 		return -EIO;
 
-	error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
+	pag = xfs_perag_get(mp, agno);
+	error = xfs_free_extent_fix_freelist(tp, pag, &agbp);
 	if (error)
-		return error;
+		goto err;
 	agf = agbp->b_addr;
 
 	if (XFS_IS_CORRUPT(mp, agbno >= mp->m_sb.sb_agblocks)) {
 		error = -EFSCORRUPTED;
-		goto err;
+		goto err_release;
 	}
 
 	/* validate the extent size is legal now we have the agf locked */
 	if (XFS_IS_CORRUPT(mp, agbno + len > be32_to_cpu(agf->agf_length))) {
 		error = -EFSCORRUPTED;
-		goto err;
+		goto err_release;
 	}
 
 	error = xfs_free_ag_extent(tp, agbp, agno, agbno, len, oinfo, type);
 	if (error)
-		goto err;
+		goto err_release;
 
 	if (skip_discard)
 		busy_flags |= XFS_EXTENT_BUSY_SKIP_DISCARD;
-	xfs_extent_busy_insert(tp, agno, agbno, len, busy_flags);
+	xfs_extent_busy_insert(tp, pag, agbno, len, busy_flags);
+	xfs_perag_put(pag);
 	return 0;
 
-err:
+err_release:
 	xfs_trans_brelse(tp, agbp);
+err:
+	xfs_perag_put(pag);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index a4427c5775c2..e30900b6f8ba 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -214,7 +214,7 @@ int xfs_alloc_read_agfl(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_free_agfl_block(struct xfs_trans *, xfs_agnumber_t, xfs_agblock_t,
 			struct xfs_buf *, struct xfs_owner_info *);
 int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
-int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
+int xfs_free_extent_fix_freelist(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_buf **agbp);
 
 xfs_extlen_t xfs_prealloc_blocks(struct xfs_mount *mp);
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index a540b6e799e0..19fdf87e86b9 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -72,7 +72,7 @@ xfs_allocbt_alloc_block(
 	}
 
 	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1, false);
+	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agbp->b_pag, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 
@@ -86,7 +86,6 @@ xfs_allocbt_free_block(
 	struct xfs_buf		*bp)
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
-	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_agblock_t		bno;
 	int			error;
 
@@ -96,7 +95,7 @@ xfs_allocbt_free_block(
 		return error;
 
 	atomic64_dec(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
+	xfs_extent_busy_insert(cur->bc_tp, agbp->b_pag, bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 61e8f10436ac..1d0a6b686eea 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -11,6 +11,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_bit.h"
 #include "xfs_mount.h"
+#include "xfs_sb.h"
 #include "xfs_defer.h"
 #include "xfs_btree.h"
 #include "xfs_trans.h"
@@ -2363,31 +2364,32 @@ xfs_rmap_finish_one(
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_perag		*pag;
 	struct xfs_btree_cur		*rcur;
 	struct xfs_buf			*agbp = NULL;
 	int				error = 0;
-	xfs_agnumber_t			agno;
 	struct xfs_owner_info		oinfo;
 	xfs_agblock_t			bno;
 	bool				unwritten;
 
-	agno = XFS_FSB_TO_AGNO(mp, startblock);
-	ASSERT(agno != NULLAGNUMBER);
+	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, startblock));
 	bno = XFS_FSB_TO_AGBNO(mp, startblock);
 
-	trace_xfs_rmap_deferred(mp, agno, type, bno, owner, whichfork,
+	trace_xfs_rmap_deferred(mp, pag->pag_agno, type, bno, owner, whichfork,
 			startoff, blockcount, state);
 
-	if (XFS_TEST_ERROR(false, mp,
-			XFS_ERRTAG_RMAP_FINISH_ONE))
-		return -EIO;
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RMAP_FINISH_ONE)) {
+		error = -EIO;
+		goto out_drop;
+	}
+
 
 	/*
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
 	rcur = *pcur;
-	if (rcur != NULL && rcur->bc_ag.agno != agno) {
+	if (rcur != NULL && rcur->bc_ag.agno != pag->pag_agno) {
 		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
@@ -2398,13 +2400,15 @@ xfs_rmap_finish_one(
 		 * rmapbt, because a shape change could cause us to
 		 * allocate blocks.
 		 */
-		error = xfs_free_extent_fix_freelist(tp, agno, &agbp);
+		error = xfs_free_extent_fix_freelist(tp, pag, &agbp);
 		if (error)
-			return error;
-		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
-			return -EFSCORRUPTED;
+			goto out_drop;
+		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
+			error = -EFSCORRUPTED;
+			goto out_drop;
+		}
 
-		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag->pag_agno);
 	}
 	*pcur = rcur;
 
@@ -2442,6 +2446,8 @@ xfs_rmap_finish_one(
 		ASSERT(0);
 		error = -EFSCORRUPTED;
 	}
+out_drop:
+	xfs_perag_put(pag);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index f1fee42dda2d..46a5295ecf35 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -100,8 +100,7 @@ xfs_rmapbt_alloc_block(
 		return 0;
 	}
 
-	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.agno, bno, 1,
-			false);
+	xfs_extent_busy_reuse(cur->bc_mp, agbp->b_pag, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 	be32_add_cpu(&agf->agf_rmap_blocks, 1);
@@ -133,10 +132,10 @@ xfs_rmapbt_free_block(
 	if (error)
 		return error;
 
-	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
+	pag = cur->bc_ag.agbp->b_pag;
+	xfs_extent_busy_insert(cur->bc_tp, pag, bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 
-	pag = cur->bc_ag.agbp->b_pag;
 	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);
 	return 0;
 }
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 1308b62a8170..6b62872c4d10 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -304,7 +304,7 @@ xrep_alloc_ag_block(
 			return error;
 		if (bno == NULLAGBLOCK)
 			return -ENOSPC;
-		xfs_extent_busy_reuse(sc->mp, sc->sa.agno, bno,
+		xfs_extent_busy_reuse(sc->mp, sc->sa.pag, bno,
 				1, false);
 		*fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.agno, bno);
 		if (resv == XFS_AG_RESV_RMAPBT)
@@ -519,7 +519,7 @@ xrep_put_freelist(
 			agbno, 0);
 	if (error)
 		return error;
-	xfs_extent_busy_insert(sc->tp, sc->sa.agno, agbno, 1,
+	xfs_extent_busy_insert(sc->tp, sc->sa.pag, agbno, 1,
 			XFS_EXTENT_BUSY_SKIP_DISCARD);
 
 	return 0;
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 3bf6dba1a040..972864250bd2 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -108,7 +108,7 @@ xfs_trim_extents(
 		 * If any blocks in the range are still busy, skip the
 		 * discard and try again the next time.
 		 */
-		if (xfs_extent_busy_search(mp, agno, fbno, flen)) {
+		if (xfs_extent_busy_search(mp, pag, fbno, flen)) {
 			trace_xfs_discard_busy(mp, agno, fbno, flen);
 			goto next_extent;
 		}
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 422667e0668b..ad22a003f959 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -22,28 +22,26 @@
 void
 xfs_extent_busy_insert(
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
 	unsigned int		flags)
 {
 	struct xfs_extent_busy	*new;
 	struct xfs_extent_busy	*busyp;
-	struct xfs_perag	*pag;
 	struct rb_node		**rbp;
 	struct rb_node		*parent = NULL;
 
 	new = kmem_zalloc(sizeof(struct xfs_extent_busy), 0);
-	new->agno = agno;
+	new->agno = pag->pag_agno;
 	new->bno = bno;
 	new->length = len;
 	INIT_LIST_HEAD(&new->list);
 	new->flags = flags;
 
 	/* trace before insert to be able to see failed inserts */
-	trace_xfs_extent_busy(tp->t_mountp, agno, bno, len);
+	trace_xfs_extent_busy(tp->t_mountp, pag->pag_agno, bno, len);
 
-	pag = xfs_perag_get(tp->t_mountp, new->agno);
 	spin_lock(&pag->pagb_lock);
 	rbp = &pag->pagb_tree.rb_node;
 	while (*rbp) {
@@ -66,7 +64,6 @@ xfs_extent_busy_insert(
 
 	list_add(&new->list, &tp->t_busy);
 	spin_unlock(&pag->pagb_lock);
-	xfs_perag_put(pag);
 }
 
 /*
@@ -81,21 +78,17 @@ xfs_extent_busy_insert(
 int
 xfs_extent_busy_search(
 	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len)
 {
-	struct xfs_perag	*pag;
 	struct rb_node		*rbp;
 	struct xfs_extent_busy	*busyp;
 	int			match = 0;
 
-	pag = xfs_perag_get(mp, agno);
+	/* find closest start bno overlap */
 	spin_lock(&pag->pagb_lock);
-
 	rbp = pag->pagb_tree.rb_node;
-
-	/* find closest start bno overlap */
 	while (rbp) {
 		busyp = rb_entry(rbp, struct xfs_extent_busy, rb_node);
 		if (bno < busyp->bno) {
@@ -115,7 +108,6 @@ xfs_extent_busy_search(
 		}
 	}
 	spin_unlock(&pag->pagb_lock);
-	xfs_perag_put(pag);
 	return match;
 }
 
@@ -281,17 +273,14 @@ xfs_extent_busy_update_extent(
 void
 xfs_extent_busy_reuse(
 	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
+	struct xfs_perag	*pag,
 	xfs_agblock_t		fbno,
 	xfs_extlen_t		flen,
 	bool			userdata)
 {
-	struct xfs_perag	*pag;
 	struct rb_node		*rbp;
 
 	ASSERT(flen > 0);
-
-	pag = xfs_perag_get(mp, agno);
 	spin_lock(&pag->pagb_lock);
 restart:
 	rbp = pag->pagb_tree.rb_node;
@@ -314,7 +303,6 @@ xfs_extent_busy_reuse(
 			goto restart;
 	}
 	spin_unlock(&pag->pagb_lock);
-	xfs_perag_put(pag);
 }
 
 /*
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 8aea07100092..4a118131059f 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -9,6 +9,7 @@
 #define	__XFS_EXTENT_BUSY_H__
 
 struct xfs_mount;
+struct xfs_perag;
 struct xfs_trans;
 struct xfs_alloc_arg;
 
@@ -31,7 +32,7 @@ struct xfs_extent_busy {
 };
 
 void
-xfs_extent_busy_insert(struct xfs_trans *tp, xfs_agnumber_t agno,
+xfs_extent_busy_insert(struct xfs_trans *tp, struct xfs_perag *pag,
 	xfs_agblock_t bno, xfs_extlen_t len, unsigned int flags);
 
 void
@@ -39,11 +40,11 @@ xfs_extent_busy_clear(struct xfs_mount *mp, struct list_head *list,
 	bool do_discard);
 
 int
-xfs_extent_busy_search(struct xfs_mount *mp, xfs_agnumber_t agno,
+xfs_extent_busy_search(struct xfs_mount *mp, struct xfs_perag *pag,
 	xfs_agblock_t bno, xfs_extlen_t len);
 
 void
-xfs_extent_busy_reuse(struct xfs_mount *mp, xfs_agnumber_t agno,
+xfs_extent_busy_reuse(struct xfs_mount *mp, struct xfs_perag *pag,
 	xfs_agblock_t fbno, xfs_extlen_t flen, bool userdata);
 
 bool
-- 
2.31.1

