Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEBC466E24
	for <lists+linux-xfs@lfdr.de>; Fri,  3 Dec 2021 01:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243809AbhLCAEo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 2 Dec 2021 19:04:44 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:36109 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349796AbhLCAEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:44 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id E5F10869BBB
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:16 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00G1L0-3D
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00Bki3-20
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 23/36] xfs: rework xfs_alloc_vextent()
Date:   Fri,  3 Dec 2021 11:00:58 +1100
Message-Id: <20211203000111.2800982-24-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61a95e4d
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=xH7Vk06bEwDpKNwPjcgA:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It's a multiplexing mess that can be greatly simplified, and really
needs to be simplified to allow active per-ag references to
propagate from initial AG selection code the the bmapi code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 398 ++++++++++++++++++++++++--------------
 1 file changed, 255 insertions(+), 143 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 34a3df5f85b7..0e259786d522 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3136,26 +3136,20 @@ xfs_alloc_read_agf(
 }
 
 /*
- * Allocate an extent (variable-size).
- * Depending on the allocation type, we either look in a single allocation
- * group or loop over the allocation groups to find the result.
+ * Pre-proces allocation arguments to set initial state that we don't require
+ * callers to set up correctly, as well as bounds check the allocation args
+ * that are set up.
  */
-int				/* error */
-xfs_alloc_vextent(
-	struct xfs_alloc_arg	*args)	/* allocation argument structure */
+static int
+xfs_alloc_vextent_check_args(
+	struct xfs_alloc_arg	*args)
 {
-	xfs_agblock_t		agsize;	/* allocation group size */
-	int			error;
-	int			flags;	/* XFS_ALLOC_FLAG_... locking flags */
-	struct xfs_mount	*mp;	/* mount structure pointer */
-	xfs_agnumber_t		sagno;	/* starting allocation group number */
-	xfs_alloctype_t		type;	/* input allocation type */
-	int			bump_rotor = 0;
-	xfs_agnumber_t		rotorstep = xfs_rotorstep; /* inode32 agf stepper */
-
-	mp = args->mp;
-	type = args->otype = args->type;
+	struct xfs_mount	*mp = args->mp;
+	xfs_agblock_t		agsize;
+
+	args->otype = args->type;
 	args->agbno = NULLAGBLOCK;
+
 	/*
 	 * Just fix this up, for the case where the last a.g. is shorter
 	 * (or there's only one a.g.) and the caller couldn't easily figure
@@ -3177,157 +3171,275 @@ xfs_alloc_vextent(
 	    args->mod >= args->prod) {
 		args->fsbno = NULLFSBLOCK;
 		trace_xfs_alloc_vextent_badargs(args);
-		return 0;
+		return -ENOSPC;
 	}
+	return 0;
+}
+/*
+ * Post-process allocation results to set the allocated block number correctly
+ * for the caller.
+ *
+ * XXX: xfs_alloc_vextent() should really be returning ENOSPC for ENOSPC, not
+ * hiding it behind a "successful" NULLFSBLOCK allocation.
+ */
+static void
+xfs_alloc_vextent_set_fsbno(
+	struct xfs_alloc_arg	*args)
+{
+	struct xfs_mount	*mp = args->mp;
 
-	switch (type) {
-	case XFS_ALLOCTYPE_THIS_AG:
-	case XFS_ALLOCTYPE_NEAR_BNO:
-	case XFS_ALLOCTYPE_THIS_BNO:
-		/*
-		 * These three force us into a single a.g.
-		 */
-		args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	/* Allocation failed with ENOSPC if NULLAGBLOCK was returned. */
+	if (args->agbno == NULLAGBLOCK) {
+		args->fsbno = NULLFSBLOCK;
+		return;
+	}
+
+	args->fsbno = XFS_AGB_TO_FSB(mp, args->agno, args->agbno);
+#ifdef DEBUG
+	ASSERT(args->len >= args->minlen);
+	ASSERT(args->len <= args->maxlen);
+	ASSERT(args->agbno % args->alignment == 0);
+	XFS_AG_CHECK_DADDR(mp, XFS_FSB_TO_DADDR(mp, args->fsbno), args->len);
+#endif
+}
+
+/*
+ * Allocate within a single AG only.
+ */
+static int
+xfs_alloc_vextent_this_ag(
+	struct xfs_alloc_arg	*args)
+{
+	struct xfs_mount	*mp = args->mp;
+	int			error;
+
+	error = xfs_alloc_vextent_check_args(args);
+	if (error) {
+		if (error == -ENOSPC)
+			return 0;
+		return error;
+	}
+
+	args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	args->pag = xfs_perag_get(mp, args->agno);
+	error = xfs_alloc_fix_freelist(args, 0);
+	if (error) {
+		trace_xfs_alloc_vextent_nofix(args);
+		goto out_error;
+	}
+	if (!args->agbp) {
+		trace_xfs_alloc_vextent_noagbp(args);
+		goto out_error;
+	}
+	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+	error = xfs_alloc_ag_vextent(args);
+	if (error)
+		goto out_error;
+
+	xfs_alloc_vextent_set_fsbno(args);
+out_error:
+	xfs_perag_put(args->pag);
+	return error;
+}
+
+/*
+ * Iterate all AGs trying to allocate an extent starting from @start_ag.
+ *
+ * If the
+ * incoming allocation type is XFS_ALLOCTYPE_NEAR_BNO, it means the allocation
+ * attempts in @start_agno have locality information. If we fail to allocate in
+ * that AG, then we revert to anywhere-in-AG for all the other AGs we attempt to
+ * allocation in as there is no locality optimisation possible for those
+ * allocations.
+ *
+ * When we wrap the AG iteration at the end of the filesystem, we have to be
+ * careful not to wrap into AGs below ones we already have locked in the
+ * transaction. This will result in an out-of-order locking of AGFs and hence
+ * can cause deadlocks.
+ *
+ * XXX(dgc): when wrapping in potential deadlock scenarios, we could use
+ * try-locks on the AGFs below the critical AG rather than skip them entirely.
+ * We won't deadlock in that case, we'll just skip the AGFs we can't lock.
+ */
+static int
+xfs_alloc_vextent_iterate_ags(
+	struct xfs_alloc_arg	*args,
+	xfs_agnumber_t		start_agno,
+	uint32_t		flags)
+{
+	struct xfs_mount	*mp = args->mp;
+	int			error = 0;
+
+	/*
+	 * Loop over allocation groups twice; first time with
+	 * trylock set, second time without.
+	 */
+	args->agno = start_agno;
+	for (;;) {
 		args->pag = xfs_perag_get(mp, args->agno);
-		error = xfs_alloc_fix_freelist(args, 0);
+		error = xfs_alloc_fix_freelist(args, flags);
 		if (error) {
 			trace_xfs_alloc_vextent_nofix(args);
-			goto error0;
-		}
-		if (!args->agbp) {
-			trace_xfs_alloc_vextent_noagbp(args);
 			break;
 		}
-		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
-		if ((error = xfs_alloc_ag_vextent(args)))
-			goto error0;
-		break;
-	case XFS_ALLOCTYPE_START_BNO:
 		/*
-		 * Try near allocation first, then anywhere-in-ag after
-		 * the first a.g. fails.
+		 * If we get a buffer back then the allocation will fly.
 		 */
-		if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
-		    xfs_is_inode32(mp)) {
-			args->fsbno = XFS_AGB_TO_FSB(mp,
-					((mp->m_agfrotor / rotorstep) %
-					mp->m_sb.sb_agcount), 0);
-			bump_rotor = 1;
+		if (args->agbp) {
+			error = xfs_alloc_ag_vextent(args);
+			break;
 		}
-		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
-		args->type = XFS_ALLOCTYPE_NEAR_BNO;
-		fallthrough;
-	case XFS_ALLOCTYPE_FIRST_AG:
+
+		trace_xfs_alloc_vextent_loopfailed(args);
+
 		/*
-		 * Rotate through the allocation groups looking for a winner.
+		 * Didn't work, figure out the next iteration.
 		 */
-		if (type == XFS_ALLOCTYPE_FIRST_AG) {
-			/*
-			 * Start with allocation group given by bno.
-			 */
-			args->agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
+		if (args->agno == start_agno &&
+		    args->otype == XFS_ALLOCTYPE_START_BNO)
 			args->type = XFS_ALLOCTYPE_THIS_AG;
-			sagno = 0;
-			flags = 0;
-		} else {
-			/*
-			 * Start with the given allocation group.
-			 */
-			args->agno = sagno = XFS_FSB_TO_AGNO(mp, args->fsbno);
-			flags = XFS_ALLOC_FLAG_TRYLOCK;
+		/*
+		* For the first allocation, we can try any AG to get
+		* space.  However, if we already have allocated a
+		* block, we don't want to try AGs whose number is below
+		* sagno. Otherwise, we may end up with out-of-order
+		* locking of AGF, which might cause deadlock.
+		*/
+		if (++(args->agno) == mp->m_sb.sb_agcount) {
+			if (args->tp->t_firstblock != NULLFSBLOCK)
+				args->agno = start_agno;
+			else
+				args->agno = 0;
 		}
 		/*
-		 * Loop over allocation groups twice; first time with
-		 * trylock set, second time without.
+		 * Reached the starting a.g., must either be done
+		 * or switch to non-trylock mode.
 		 */
-		for (;;) {
-			args->pag = xfs_perag_get(mp, args->agno);
-			error = xfs_alloc_fix_freelist(args, flags);
-			if (error) {
-				trace_xfs_alloc_vextent_nofix(args);
-				goto error0;
-			}
-			/*
-			 * If we get a buffer back then the allocation will fly.
-			 */
-			if (args->agbp) {
-				if ((error = xfs_alloc_ag_vextent(args)))
-					goto error0;
+		if (args->agno == start_agno) {
+			if (flags == 0) {
+				args->agbno = NULLAGBLOCK;
+				trace_xfs_alloc_vextent_allfailed(args);
 				break;
 			}
 
-			trace_xfs_alloc_vextent_loopfailed(args);
-
-			/*
-			 * Didn't work, figure out the next iteration.
-			 */
-			if (args->agno == sagno &&
-			    type == XFS_ALLOCTYPE_START_BNO)
-				args->type = XFS_ALLOCTYPE_THIS_AG;
-			/*
-			* For the first allocation, we can try any AG to get
-			* space.  However, if we already have allocated a
-			* block, we don't want to try AGs whose number is below
-			* sagno. Otherwise, we may end up with out-of-order
-			* locking of AGF, which might cause deadlock.
-			*/
-			if (++(args->agno) == mp->m_sb.sb_agcount) {
-				if (args->tp->t_firstblock != NULLFSBLOCK)
-					args->agno = sagno;
-				else
-					args->agno = 0;
-			}
-			/*
-			 * Reached the starting a.g., must either be done
-			 * or switch to non-trylock mode.
-			 */
-			if (args->agno == sagno) {
-				if (flags == 0) {
-					args->agbno = NULLAGBLOCK;
-					trace_xfs_alloc_vextent_allfailed(args);
-					break;
-				}
-
-				flags = 0;
-				if (type == XFS_ALLOCTYPE_START_BNO) {
-					args->agbno = XFS_FSB_TO_AGBNO(mp,
-						args->fsbno);
-					args->type = XFS_ALLOCTYPE_NEAR_BNO;
-				}
+			flags = 0;
+			if (args->otype == XFS_ALLOCTYPE_START_BNO) {
+				args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+				args->type = XFS_ALLOCTYPE_NEAR_BNO;
 			}
-			xfs_perag_put(args->pag);
-		}
-		if (bump_rotor) {
-			if (args->agno == sagno)
-				mp->m_agfrotor = (mp->m_agfrotor + 1) %
-					(mp->m_sb.sb_agcount * rotorstep);
-			else
-				mp->m_agfrotor = (args->agno * rotorstep + 1) %
-					(mp->m_sb.sb_agcount * rotorstep);
 		}
-		break;
-	default:
-		ASSERT(0);
-		/* NOTREACHED */
+		xfs_perag_put(args->pag);
 	}
-	if (args->agbno == NULLAGBLOCK)
-		args->fsbno = NULLFSBLOCK;
-	else {
-		args->fsbno = XFS_AGB_TO_FSB(mp, args->agno, args->agbno);
-#ifdef DEBUG
-		ASSERT(args->len >= args->minlen);
-		ASSERT(args->len <= args->maxlen);
-		ASSERT(args->agbno % args->alignment == 0);
-		XFS_AG_CHECK_DADDR(mp, XFS_FSB_TO_DADDR(mp, args->fsbno),
-			args->len);
-#endif
+	xfs_perag_put(args->pag);
+	return error;
+}
+
+/*
+ * Iterate from the AGs from the start AG to the end of the filesystem, trying
+ * to allocate blocks. It starts with a near allocation attempt in the initial
+ * AG, then falls back to anywhere-in-ag after the first AG fails. It will wrap
+ * back to zero if allowed by previous allocations in this transaction,
+ * otherwise will wrap back to the start AG and run a second blocking pass to
+ * the end of the filesystem.
+ */
+static int
+xfs_alloc_vextent_start_ag(
+	struct xfs_alloc_arg	*args)
+{
+	struct xfs_mount	*mp = args->mp;
+	xfs_agnumber_t		start_agno;
+	xfs_agnumber_t		rotorstep = xfs_rotorstep;
+	bool			bump_rotor = false;
+	int			error;
 
+	error = xfs_alloc_vextent_check_args(args);
+	if (error) {
+		if (error == -ENOSPC)
+			return 0;
+		return error;
 	}
-	xfs_perag_put(args->pag);
+
+	if ((args->datatype & XFS_ALLOC_INITIAL_USER_DATA) &&
+	    xfs_is_inode32(mp)) {
+		args->fsbno = XFS_AGB_TO_FSB(mp,
+				((mp->m_agfrotor / rotorstep) %
+				mp->m_sb.sb_agcount), 0);
+		bump_rotor = 1;
+	}
+	start_agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
+	args->type = XFS_ALLOCTYPE_NEAR_BNO;
+
+	error = xfs_alloc_vextent_iterate_ags(args, start_agno,
+			XFS_ALLOC_FLAG_TRYLOCK);
+	if (error)
+		return error;
+
+	if (bump_rotor) {
+		if (args->agno == start_agno)
+			mp->m_agfrotor = (mp->m_agfrotor + 1) %
+				(mp->m_sb.sb_agcount * rotorstep);
+		else
+			mp->m_agfrotor = (args->agno * rotorstep + 1) %
+				(mp->m_sb.sb_agcount * rotorstep);
+	}
+
+	xfs_alloc_vextent_set_fsbno(args);
 	return 0;
-error0:
-	xfs_perag_put(args->pag);
-	return error;
+}
+
+/*
+ * Iterate from the agno indicated from args->fsbno through to the end of the
+ * filesystem attempting blocking allocation. This does not wrap or try a second
+ * pass, so will not recurse into AGs lower than indicated by fsbno.
+ */
+static int
+xfs_alloc_vextent_first_ag(
+	struct xfs_alloc_arg	*args)
+{
+	struct xfs_mount	*mp = args->mp;
+	int			error;
+
+	error = xfs_alloc_vextent_check_args(args);
+	if (error) {
+		if (error == -ENOSPC)
+			return 0;
+		return error;
+	}
+
+	args->type = XFS_ALLOCTYPE_THIS_AG;
+	error =  xfs_alloc_vextent_iterate_ags(args,
+			XFS_FSB_TO_AGNO(mp, args->fsbno), 0);
+	if (error)
+		return error;
+	xfs_alloc_vextent_set_fsbno(args);
+	return 0;
+}
+
+/*
+ * Allocate an extent (variable-size).
+ * Depending on the allocation type, we either look in a single allocation
+ * group or loop over the allocation groups to find the result.
+ */
+int
+xfs_alloc_vextent(
+	struct xfs_alloc_arg	*args)
+{
+	switch (args->type) {
+	case XFS_ALLOCTYPE_THIS_AG:
+	case XFS_ALLOCTYPE_NEAR_BNO:
+	case XFS_ALLOCTYPE_THIS_BNO:
+		return xfs_alloc_vextent_this_ag(args);
+	case XFS_ALLOCTYPE_START_BNO:
+		return xfs_alloc_vextent_start_ag(args);
+	case XFS_ALLOCTYPE_FIRST_AG:
+		return xfs_alloc_vextent_first_ag(args);
+	default:
+		ASSERT(0);
+		/* NOTREACHED */
+	}
+	/* Should never get here */
+	return -EFSCORRUPTED;
 }
 
 /* Ensure that the freelist is at full capacity. */
-- 
2.33.0

