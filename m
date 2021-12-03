Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73556466E30
	for <lists+linux-xfs@lfdr.de>; Fri,  3 Dec 2021 01:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377739AbhLCAEu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 2 Dec 2021 19:04:50 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:37651 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377734AbhLCAEu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:50 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 9616B869E6D
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:24 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00G1La-Gu
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0p-00Bkj1-FY
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 35/36] xfs: convert xfs_alloc_vextent_iterate_ags() to use perag walker
Date:   Fri,  3 Dec 2021 11:01:10 +1100
Message-Id: <20211203000111.2800982-36-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61a95e54
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=rPMLGPRgkIbOATDFbHwA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that the AG iteration code in the core allocation code has been
cleaned up, we can easily convert it to use a for_each_perag..()
variant to use active references and skip AGs that it can't get
active references on.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.h    | 22 ++++++---
 fs/xfs/libxfs/xfs_alloc.c | 97 ++++++++++++++++++++-------------------
 2 files changed, 65 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 23040a1094b9..2198166efa2f 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -244,6 +244,7 @@ xfs_perag_next_wrap(
 	struct xfs_perag	*pag,
 	xfs_agnumber_t		*agno,
 	xfs_agnumber_t		stop_agno,
+	xfs_agnumber_t		restart_agno,
 	xfs_agnumber_t		wrap_agno)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
@@ -251,10 +252,11 @@ xfs_perag_next_wrap(
 	*agno = pag->pag_agno + 1;
 	xfs_perag_rele(pag);
 	while (*agno != stop_agno) {
-		if (*agno >= wrap_agno)
-			*agno = 0;
-		if (*agno == stop_agno)
-			break;
+		if (*agno >= wrap_agno) {
+			if (restart_agno >= stop_agno)
+				break;
+			*agno = restart_agno;
+		}
 
 		pag = xfs_perag_grab(mp, *agno);
 		if (pag)
@@ -265,14 +267,20 @@ xfs_perag_next_wrap(
 }
 
 /*
- * Iterate all AGs from start_agno through wrap_agno, then 0 through
+ * Iterate all AGs from start_agno through wrap_agno, then restart_agno through
  * (start_agno - 1).
  */
-#define for_each_perag_wrap_at(mp, start_agno, wrap_agno, agno, pag) \
+#define for_each_perag_wrap_range(mp, start_agno, restart_agno, wrap_agno, agno, pag) \
 	for ((agno) = (start_agno), (pag) = xfs_perag_grab((mp), (agno)); \
 		(pag) != NULL; \
 		(pag) = xfs_perag_next_wrap((pag), &(agno), (start_agno), \
-				(wrap_agno)))
+				(restart_agno), (wrap_agno)))
+/*
+ * Iterate all AGs from start_agno through wrap_agno, then 0 through
+ * (start_agno - 1).
+ */
+#define for_each_perag_wrap_at(mp, start_agno, wrap_agno, agno, pag) \
+	for_each_perag_wrap_range((mp), (start_agno), 0, (wrap_agno), (agno), (pag))
 
 /*
  * Iterate all AGs from start_agno through to the end of the filesystem, then 0
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b15dee98090a..71bfb0c6150c 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3132,6 +3132,7 @@ xfs_alloc_vextent_prepare_ag(
 	if (need_pag)
 		args->pag = xfs_perag_get(args->mp, args->agno);
 
+	args->agbp = NULL;
 	error = xfs_alloc_fix_freelist(args, 0);
 	if (error) {
 		trace_xfs_alloc_vextent_nofix(args);
@@ -3253,6 +3254,10 @@ xfs_alloc_vextent_this_ag(
  * transaction. This will result in an out-of-order locking of AGFs and hence
  * can cause deadlocks.
  *
+ * On return, args->pag may be left referenced if we finish before the "all
+ * failed" return point. The allocation finish still needs the perag, and
+ * so the caller will release it once they've finished the allocation.
+ *
  * XXX(dgc): when wrapping in potential deadlock scenarios, we could use
  * try-locks on the AGFs below the critical AG rather than skip them entirely.
  * We won't deadlock in that case, we'll just skip the AGFs we can't lock.
@@ -3265,67 +3270,65 @@ xfs_alloc_vextent_iterate_ags(
 	uint32_t		flags)
 {
 	struct xfs_mount	*mp = args->mp;
+	xfs_agnumber_t		restart_agno = 0;
+	xfs_agnumber_t		agno;
 	int			error = 0;
 
 	/*
-	 * Loop over allocation groups twice; first time with
-	 * trylock set, second time without.
+	 * If we already have allocated a block in this transaction, we don't
+	 * want to lock AGs whose number is below the start AG. This results in
+	 * out-of-order locking of AGF and deadlocks will result.
 	 */
-	args->agno = start_agno;
-	for (;;) {
+	if (args->tp->t_firstblock != NULLFSBLOCK)
+		restart_agno = start_agno;
+
+restart:
+	for_each_perag_wrap_range(mp, start_agno, restart_agno,
+			mp->m_sb.sb_agcount, agno, args->pag) {
+		args->agno = agno;
 		args->agbno = target_agbno;
-		args->pag = xfs_perag_get(args->mp, args->agno);
+		trace_printk("sag %u rag %u agno %u pag %u, agbno %u, agcnt %u",
+			start_agno, restart_agno, agno, args->pag->pag_agno,
+			target_agbno, mp->m_sb.sb_agcount);
+
 		error = xfs_alloc_vextent_prepare_ag(args);
 		if (error)
 			break;
-
-		if (args->agbp) {
-			/*
-			 * Allocation is supposed to succeed now, so break out
-			 * of the loop regardless of whether we succeed or not.
-			 */
-			if (args->agno == start_agno && target_agbno)
-				error = xfs_alloc_ag_vextent_near(args);
-			else
-				error = xfs_alloc_ag_vextent_size(args);
-			break;
+		if (!args->agbp) {
+			trace_xfs_alloc_vextent_loopfailed(args);
+			continue;
 		}
 
-		trace_xfs_alloc_vextent_loopfailed(args);
-
 		/*
-		* For the first allocation, we can try any AG to get
-		* space.  However, if we already have allocated a
-		* block, we don't want to try AGs whose number is below
-		* sagno. Otherwise, we may end up with out-of-order
-		* locking of AGF, which might cause deadlock.
-		*/
-		if (++(args->agno) == mp->m_sb.sb_agcount) {
-			if (args->tp->t_firstblock != NULLFSBLOCK)
-				args->agno = start_agno;
-			else
-				args->agno = 0;
-		}
-		/*
-		 * Reached the starting a.g., must either be done
-		 * or switch to non-trylock mode.
+		 * Allocation is supposed to succeed now, so break out of the
+		 * loop regardless of whether we succeed or not.
 		 */
-		if (args->agno == start_agno) {
-			if (flags == 0) {
-				args->agbno = NULLAGBLOCK;
-				trace_xfs_alloc_vextent_allfailed(args);
-				break;
-			}
-			flags = 0;
-		}
-		xfs_perag_put(args->pag);
+		if (args->agno == start_agno && target_agbno)
+			error = xfs_alloc_ag_vextent_near(args);
+		else
+			error = xfs_alloc_ag_vextent_size(args);
+		break;
+	}
+	if (error) {
+		xfs_perag_rele(args->pag);
 		args->pag = NULL;
+		return error;
 	}
+	if (args->agbp)
+		return 0;
+
 	/*
-	 * On success, perag is left referenced in args for the caller to clean
-	 * up after they've finished the allocation.
+	 * We didn't find an AG we can alloation from. If we were given
+	 * constraining flags by the caller, drop them and retry the allocation
+	 * without any constraints being set.
 	 */
-	return error;
+	if (flags) {
+		flags = 0;
+		goto restart;
+	}
+
+	trace_xfs_alloc_vextent_allfailed(args);
+	return 0;
 }
 
 /*
@@ -3367,7 +3370,7 @@ xfs_alloc_vextent_start_ag(
 	if (!error)
 		error = xfs_alloc_vextent_finish(args);
 	if (args->pag) {
-		xfs_perag_put(args->pag);
+		xfs_perag_rele(args->pag);
 		args->pag = NULL;
 	}
 
@@ -3408,7 +3411,7 @@ xfs_alloc_vextent_first_ag(
 	if (!error)
 		error = xfs_alloc_vextent_finish(args);
 	if (args->pag) {
-		xfs_perag_put(args->pag);
+		xfs_perag_rele(args->pag);
 		args->pag = NULL;
 	}
 	return error;
-- 
2.33.0

