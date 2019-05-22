Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E1F2698C
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2019 20:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbfEVSFv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 May 2019 14:05:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729519AbfEVSFu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 May 2019 14:05:50 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7659CC05E77E
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:50 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31F175C296
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:50 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 08/11] xfs: refactor by-size extent allocation mode
Date:   Wed, 22 May 2019 14:05:43 -0400
Message-Id: <20190522180546.17063-9-bfoster@redhat.com>
In-Reply-To: <20190522180546.17063-1-bfoster@redhat.com>
References: <20190522180546.17063-1-bfoster@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 22 May 2019 18:05:50 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

By-size allocation mode is essentially a near allocation mode
without a locality requirement. The existing code looks up a
suitably sized extent in the cntbt and either succeeds or falls back
to a forward or reverse scan and eventually to the AGFL.

While similar in concept to near allocation mode, the lookup/search
algorithm is far more simple. As such, size allocation mode is still
more cleanly implemented with a mode-specific algorithm function.
However, this function reuses underlying mechanism used by the bnobt
scan for a near mode allocation to instead walk the cntbt looking
for a suitably sized extent. Much of the setup, finish and AGFL
fallback code is also unnecessarily duplicated in the current
implementation and can be removed.

Implement a by-size allocation mode search algorithm, tweak the
generic infrastructure to handle by-size allocations and replace the
old by-size implementation. As with exact allocation mode, this
essentially provides the same behavior with less duplicate mode
specific code.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 275 +++++++++-----------------------------
 fs/xfs/xfs_trace.h        |   4 -
 2 files changed, 65 insertions(+), 214 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d180d1940039..6b8bd8f316cb 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -38,8 +38,6 @@ struct workqueue_struct *xfs_alloc_wq;
 #define	XFSA_FIXUP_BNO_OK	1
 #define	XFSA_FIXUP_CNT_OK	2
 
-STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
-
 /*
  * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of slots in
  * the beginning of the block for a proper header with the location information
@@ -751,6 +749,8 @@ xfs_alloc_cur_setup(
 
 	if (args->agbno != NULLAGBLOCK)
 		agbno = args->agbno;
+	if (args->type == XFS_ALLOCTYPE_THIS_AG)
+		acur->cur_len += args->alignment - 1;
 
 	/*
 	 * Initialize the cntbt cursor and determine whether to start the search
@@ -761,7 +761,7 @@ xfs_alloc_cur_setup(
 		acur->cnt = xfs_allocbt_init_cursor(args->mp, args->tp,
 					args->agbp, args->agno, XFS_BTNUM_CNT);
 	error = xfs_alloc_lookup_ge(acur->cnt, agbno, acur->cur_len, &i);
-	if (!i) {
+	if (!i && args->type != XFS_ALLOCTYPE_THIS_AG) {
 		acur->cur_len = args->minlen;
 		error = xfs_alloc_lookup_ge(acur->cnt, agbno, acur->cur_len,
 					    &i);
@@ -778,13 +778,15 @@ xfs_alloc_cur_setup(
 		return error;
 
 	/*
-	 * Exact allocation mode requires only one bnobt cursor.
+	 * Exact allocation mode uses the bnobt, by-size allocation mode uses
+	 * the cntbt, either one requires only one bnobt cursor.
 	 */
 	if (args->type == XFS_ALLOCTYPE_THIS_BNO) {
 		ASSERT(args->alignment == 1);
 		acur->cnt->bc_private.a.priv.abt.active = false;
 		return 0;
-	}
+	} else if (args->type == XFS_ALLOCTYPE_THIS_AG)
+		return 0;
 
 	if (!acur->bnogt)
 		acur->bnogt = xfs_allocbt_init_cursor(args->mp, args->tp,
@@ -886,9 +888,10 @@ xfs_alloc_cur_check(
 	/*
 	 * We have an aligned record that satisfies minlen and beats the current
 	 * candidate length. The remaining checks depend on allocation type.
-	 * Exact allocation checks one record and either succeeds or fails. Near
-	 * allocation computes and checks locality.  Near allocation computes
-	 * and checks locality.
+	 * Exact allocation checks one record and either succeeds or fails.
+	 * By-size allocation only needs to deactivate the cursor once we've
+	 * found a maxlen candidate. Near allocation computes and checks
+	 * locality. Near allocation computes and checks locality.
 	 */
 	if (args->type == XFS_ALLOCTYPE_THIS_BNO) {
 		if ((bnoa > args->agbno) ||
@@ -903,6 +906,12 @@ xfs_alloc_cur_check(
 			    args->agbno;
 		diff = 0;
 		trace_xfs_alloc_exact_done(args);
+	} else if (args->type == XFS_ALLOCTYPE_THIS_AG) {
+		if (lena >= args->maxlen) {
+			cur->bc_private.a.priv.abt.active = false;
+			trace_xfs_alloc_size_done(args);
+		}
+		bnew = bnoa;
 	} else {
 		ASSERT(args->type == XFS_ALLOCTYPE_NEAR_BNO);
 		diff = xfs_alloc_compute_diff(args->agbno, args->len,
@@ -1082,6 +1091,50 @@ xfs_alloc_walk_iter(
 	return error;
 }
 
+/*
+ * High level size allocation algorithm.
+ */
+STATIC int
+xfs_alloc_ag_vextent_size(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_cur	*acur,
+	int			*stat)
+{
+	int			error;
+	int			i;
+	bool			increment = true;
+
+	ASSERT(args->type == XFS_ALLOCTYPE_THIS_AG);
+	*stat = 0;
+
+	/*
+	 * The cursor either points at the first sufficiently sized extent for
+	 * an aligned maxlen allocation or off the edge of the tree. The only
+	 * way the former should fail is if the target extents are busy, so
+	 * return nothing and let the caller flush and retry. If the latter,
+	 * point the cursor at the last valid record and walk backwards from
+	 * there. There is still a chance to find a minlen extent.
+	 */
+	if (!xfs_alloc_cur_active(acur->cnt)) {
+		increment = false;
+		error = xfs_btree_decrement(acur->cnt, 0, &i);
+		if (error)
+			return error;
+		if (i)
+			acur->cnt->bc_private.a.priv.abt.active = true;
+	}
+
+	error = xfs_alloc_walk_iter(args, acur, acur->cnt, increment, false,
+				    INT_MAX, &i);
+	if (error)
+		return error;
+
+	ASSERT(i == 1 || acur->busy || !increment);
+	if (acur->len)
+		*stat = 1;
+	return 0;
+}
+
 /*
  * High level locality allocation algorithm. Search the bnobt (left and right)
  * in parallel with locality-optimized cntbt lookups to find an extent with
@@ -1309,7 +1362,10 @@ xfs_alloc_ag_vextent_type(
 	if (error)
 		goto out;
 
-	error = xfs_alloc_ag_vextent_cur(args, &acur, &i);
+	if (args->type == XFS_ALLOCTYPE_THIS_AG)
+		error = xfs_alloc_ag_vextent_size(args, &acur, &i);
+	else
+		error = xfs_alloc_ag_vextent_cur(args, &acur, &i);
 	if (error)
 		goto out;
 
@@ -1377,8 +1433,6 @@ xfs_alloc_ag_vextent(
 	args->wasfromfl = 0;
 	switch (args->type) {
 	case XFS_ALLOCTYPE_THIS_AG:
-		error = xfs_alloc_ag_vextent_size(args);
-		break;
 	case XFS_ALLOCTYPE_NEAR_BNO:
 	case XFS_ALLOCTYPE_THIS_BNO:
 		error = xfs_alloc_ag_vextent_type(args);
@@ -1422,205 +1476,6 @@ xfs_alloc_ag_vextent(
 	return error;
 }
 
-/*
- * Allocate a variable extent anywhere in the allocation group agno.
- * Extent's length (returned in len) will be between minlen and maxlen,
- * and of the form k * prod + mod unless there's nothing that large.
- * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
- */
-STATIC int				/* error */
-xfs_alloc_ag_vextent_size(
-	xfs_alloc_arg_t	*args)		/* allocation argument structure */
-{
-	xfs_btree_cur_t	*bno_cur;	/* cursor for bno btree */
-	xfs_btree_cur_t	*cnt_cur;	/* cursor for cnt btree */
-	int		error;		/* error result */
-	xfs_agblock_t	fbno;		/* start of found freespace */
-	xfs_extlen_t	flen;		/* length of found freespace */
-	int		i;		/* temp status variable */
-	xfs_agblock_t	rbno;		/* returned block number */
-	xfs_extlen_t	rlen;		/* length of returned extent */
-	bool		busy;
-	unsigned	busy_gen;
-
-restart:
-	/*
-	 * Allocate and initialize a cursor for the by-size btree.
-	 */
-	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_CNT);
-	bno_cur = NULL;
-	busy = false;
-
-	/*
-	 * Look for an entry >= maxlen+alignment-1 blocks.
-	 */
-	if ((error = xfs_alloc_lookup_ge(cnt_cur, 0,
-			args->maxlen + args->alignment - 1, &i)))
-		goto error0;
-
-	/*
-	 * If none then we have to settle for a smaller extent. In the case that
-	 * there are no large extents, this will return the last entry in the
-	 * tree unless the tree is empty. In the case that there are only busy
-	 * large extents, this will return the largest small extent unless there
-	 * are no smaller extents available.
-	 */
-	if (!i) {
-		error = xfs_alloc_ag_vextent_small(args, cnt_cur,
-						   &fbno, &flen, &i);
-		if (error)
-			goto error0;
-		if (i == 0 || flen == 0) {
-			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-			trace_xfs_alloc_size_noentry(args);
-			return 0;
-		}
-		ASSERT(i == 1);
-		busy = xfs_alloc_compute_aligned(args, fbno, flen, &rbno,
-				&rlen, &busy_gen);
-	} else {
-		/*
-		 * Search for a non-busy extent that is large enough.
-		 */
-		for (;;) {
-			error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, &i);
-			if (error)
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-
-			busy = xfs_alloc_compute_aligned(args, fbno, flen,
-					&rbno, &rlen, &busy_gen);
-
-			if (rlen >= args->maxlen)
-				break;
-
-			error = xfs_btree_increment(cnt_cur, 0, &i);
-			if (error)
-				goto error0;
-			if (i == 0) {
-				/*
-				 * Our only valid extents must have been busy.
-				 * Make it unbusy by forcing the log out and
-				 * retrying.
-				 */
-				xfs_btree_del_cursor(cnt_cur,
-						     XFS_BTREE_NOERROR);
-				trace_xfs_alloc_size_busy(args);
-				xfs_extent_busy_flush(args->mp,
-							args->pag, busy_gen);
-				goto restart;
-			}
-		}
-	}
-
-	/*
-	 * In the first case above, we got the last entry in the
-	 * by-size btree.  Now we check to see if the space hits maxlen
-	 * once aligned; if not, we search left for something better.
-	 * This can't happen in the second case above.
-	 */
-	rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
-	XFS_WANT_CORRUPTED_GOTO(args->mp, rlen == 0 ||
-			(rlen <= flen && rbno + rlen <= fbno + flen), error0);
-	if (rlen < args->maxlen) {
-		xfs_agblock_t	bestfbno;
-		xfs_extlen_t	bestflen;
-		xfs_agblock_t	bestrbno;
-		xfs_extlen_t	bestrlen;
-
-		bestrlen = rlen;
-		bestrbno = rbno;
-		bestflen = flen;
-		bestfbno = fbno;
-		for (;;) {
-			if ((error = xfs_btree_decrement(cnt_cur, 0, &i)))
-				goto error0;
-			if (i == 0)
-				break;
-			if ((error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen,
-					&i)))
-				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-			if (flen < bestrlen)
-				break;
-			busy = xfs_alloc_compute_aligned(args, fbno, flen,
-					&rbno, &rlen, &busy_gen);
-			rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
-			XFS_WANT_CORRUPTED_GOTO(args->mp, rlen == 0 ||
-				(rlen <= flen && rbno + rlen <= fbno + flen),
-				error0);
-			if (rlen > bestrlen) {
-				bestrlen = rlen;
-				bestrbno = rbno;
-				bestflen = flen;
-				bestfbno = fbno;
-				if (rlen == args->maxlen)
-					break;
-			}
-		}
-		if ((error = xfs_alloc_lookup_eq(cnt_cur, bestfbno, bestflen,
-				&i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-		rlen = bestrlen;
-		rbno = bestrbno;
-		flen = bestflen;
-		fbno = bestfbno;
-	}
-	args->wasfromfl = 0;
-	/*
-	 * Fix up the length.
-	 */
-	args->len = rlen;
-	if (rlen < args->minlen) {
-		if (busy) {
-			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-			trace_xfs_alloc_size_busy(args);
-			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
-			goto restart;
-		}
-		goto out_nominleft;
-	}
-	xfs_alloc_fix_len(args);
-
-	rlen = args->len;
-	XFS_WANT_CORRUPTED_GOTO(args->mp, rlen <= flen, error0);
-	/*
-	 * Allocate and initialize a cursor for the by-block tree.
-	 */
-	bno_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
-		args->agno, XFS_BTNUM_BNO);
-	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur, fbno, flen,
-			rbno, rlen, XFSA_FIXUP_CNT_OK)))
-		goto error0;
-	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
-	cnt_cur = bno_cur = NULL;
-	args->len = rlen;
-	args->agbno = rbno;
-	XFS_WANT_CORRUPTED_GOTO(args->mp,
-		args->agbno + args->len <=
-			be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
-		error0);
-	trace_xfs_alloc_size_done(args);
-	return 0;
-
-error0:
-	trace_xfs_alloc_size_error(args);
-	if (cnt_cur)
-		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_ERROR);
-	if (bno_cur)
-		xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
-	return error;
-
-out_nominleft:
-	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
-	trace_xfs_alloc_size_nominleft(args);
-	args->agbno = NULLAGBLOCK;
-	return 0;
-}
-
 /*
  * Free the extent starting at agno/bno for length.
  */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a11aac4505ea..519bf7d104ba 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1638,11 +1638,7 @@ DEFINE_ALLOC_EVENT(xfs_alloc_ag_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_ag_noentry);
 DEFINE_ALLOC_EVENT(xfs_alloc_ag_busy);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_noentry);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_nominleft);
 DEFINE_ALLOC_EVENT(xfs_alloc_size_done);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_error);
-DEFINE_ALLOC_EVENT(xfs_alloc_size_busy);
 DEFINE_ALLOC_EVENT(xfs_alloc_small_freelist);
 DEFINE_ALLOC_EVENT(xfs_alloc_small_notenough);
 DEFINE_ALLOC_EVENT(xfs_alloc_small_done);
-- 
2.17.2

