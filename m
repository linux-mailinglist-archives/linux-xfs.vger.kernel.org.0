Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABDFD37500A
	for <lists+linux-xfs@lfdr.de>; Thu,  6 May 2021 09:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhEFHWG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 May 2021 03:22:06 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:57876 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233428AbhEFHWB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 May 2021 03:22:01 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 255C233D8
        for <linux-xfs@vger.kernel.org>; Thu,  6 May 2021 17:20:57 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1leYJc-005lnq-2C
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:56 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1leYJb-001979-Qd
        for linux-xfs@vger.kernel.org; Thu, 06 May 2021 17:20:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/22] xfs: make for_each_perag... a first class citizen
Date:   Thu,  6 May 2021 17:20:36 +1000
Message-Id: <20210506072054.271157-5-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210506072054.271157-1-david@fromorbit.com>
References: <20210506072054.271157-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=CsKEjzspqjrNbpSBHhsA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

for_each_perag_tag() is defined in xfs_icache.c for local use.
Promote this to xfs_ag.h and define equivalent iteration functions
so that we can use them to iterate AGs instead to replace open coded
perag walks and perag lookups.

We also convert as many of the straight forward open coded AG walks
to use these iterators as possible. Anything that is not a direct
conversion to an iterator is ignored and will be updated in future
commits.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.h    | 17 +++++++++++++++++
 fs/xfs/scrub/fscounters.c | 36 ++++++++++++++----------------------
 fs/xfs/xfs_extent_busy.c  |  7 ++-----
 fs/xfs/xfs_fsops.c        |  8 ++------
 fs/xfs/xfs_health.c       |  4 +---
 fs/xfs/xfs_icache.c       | 15 ++-------------
 6 files changed, 38 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index ec37f9d9f310..33783120263c 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -114,6 +114,23 @@ struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
 				   int tag);
 void	xfs_perag_put(struct xfs_perag *pag);
 
+/*
+ * Perag iteration APIs
+ */
+#define for_each_perag(mp, next_agno, pag) \
+	for ((next_agno) = 0, (pag) = xfs_perag_get((mp), 0); \
+		(pag) != NULL; \
+		(next_agno) = (pag)->pag_agno + 1, \
+		xfs_perag_put(pag), \
+		(pag) = xfs_perag_get((mp), (next_agno)))
+
+#define for_each_perag_tag(mp, next_agno, pag, tag) \
+	for ((next_agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
+		(pag) != NULL; \
+		(next_agno) = (pag)->pag_agno + 1, \
+		xfs_perag_put(pag), \
+		(pag) = xfs_perag_get_tag((mp), (next_agno), (tag)))
+
 struct aghdr_init_data {
 	/* per ag data */
 	xfs_agblock_t		agno;		/* ag to init */
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 453ae9adf94c..2dfdac566399 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -71,11 +71,11 @@ xchk_fscount_warmup(
 	xfs_agnumber_t		agno;
 	int			error = 0;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		pag = xfs_perag_get(mp, agno);
-
+	for_each_perag(mp, agno, pag) {
+		if (xchk_should_terminate(sc, &error))
+			break;
 		if (pag->pagi_init && pag->pagf_init)
-			goto next_loop_perag;
+			continue;
 
 		/* Lock both AG headers. */
 		error = xfs_ialloc_read_agi(mp, sc->tp, agno, &agi_bp);
@@ -89,21 +89,15 @@ xchk_fscount_warmup(
 		 * These are supposed to be initialized by the header read
 		 * function.
 		 */
-		error = -EFSCORRUPTED;
-		if (!pag->pagi_init || !pag->pagf_init)
+		if (!pag->pagi_init || !pag->pagf_init) {
+			error = -EFSCORRUPTED;
 			break;
+		}
 
 		xfs_buf_relse(agf_bp);
 		agf_bp = NULL;
 		xfs_buf_relse(agi_bp);
 		agi_bp = NULL;
-next_loop_perag:
-		xfs_perag_put(pag);
-		pag = NULL;
-		error = 0;
-
-		if (xchk_should_terminate(sc, &error))
-			break;
 	}
 
 	if (agf_bp)
@@ -196,13 +190,14 @@ xchk_fscount_aggregate_agcounts(
 	fsc->ifree = 0;
 	fsc->fdblocks = 0;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		pag = xfs_perag_get(mp, agno);
+	for_each_perag(mp, agno, pag) {
+		if (xchk_should_terminate(sc, &error))
+			break;
 
 		/* This somehow got unset since the warmup? */
 		if (!pag->pagi_init || !pag->pagf_init) {
-			xfs_perag_put(pag);
-			return -EFSCORRUPTED;
+			error = -EFSCORRUPTED;
+			break;
 		}
 
 		/* Count all the inodes */
@@ -229,12 +224,9 @@ xchk_fscount_aggregate_agcounts(
 		fsc->fdblocks -= pag->pag_meta_resv.ar_reserved;
 		fsc->fdblocks -= pag->pag_rmapbt_resv.ar_orig_reserved;
 
-		xfs_perag_put(pag);
-
-		if (xchk_should_terminate(sc, &error))
-			break;
 	}
-
+	if (pag)
+		xfs_perag_put(pag);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 184732aa8674..6af0b5a1c7b0 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -605,12 +605,11 @@ void
 xfs_extent_busy_wait_all(
 	struct xfs_mount	*mp)
 {
+	struct xfs_perag	*pag;
 	DEFINE_WAIT		(wait);
 	xfs_agnumber_t		agno;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		struct xfs_perag *pag = xfs_perag_get(mp, agno);
-
+	for_each_perag(mp, agno, pag) {
 		do {
 			prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
 			if  (RB_EMPTY_ROOT(&pag->pagb_tree))
@@ -618,8 +617,6 @@ xfs_extent_busy_wait_all(
 			schedule();
 		} while (1);
 		finish_wait(&pag->pagb_wait, &wait);
-
-		xfs_perag_put(pag);
 	}
 }
 
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index be9cf88d2ad7..07c745cd483e 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -576,10 +576,8 @@ xfs_fs_reserve_ag_blocks(
 	int			err2;
 
 	mp->m_finobt_nores = false;
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		pag = xfs_perag_get(mp, agno);
+	for_each_perag(mp, agno, pag) {
 		err2 = xfs_ag_resv_init(pag, NULL);
-		xfs_perag_put(pag);
 		if (err2 && !error)
 			error = err2;
 	}
@@ -605,10 +603,8 @@ xfs_fs_unreserve_ag_blocks(
 	int			error = 0;
 	int			err2;
 
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		pag = xfs_perag_get(mp, agno);
+	for_each_perag(mp, agno, pag) {
 		err2 = xfs_ag_resv_free(pag);
-		xfs_perag_put(pag);
 		if (err2 && !error)
 			error = err2;
 	}
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index b79475ea3dbd..5de3195f6cb2 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -34,14 +34,12 @@ xfs_health_unmount(
 		return;
 
 	/* Measure AG corruption levels. */
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		pag = xfs_perag_get(mp, agno);
+	for_each_perag(mp, agno, pag) {
 		xfs_ag_measure_sickness(pag, &sick, &checked);
 		if (sick) {
 			trace_xfs_ag_unfixed_corruption(mp, agno, sick);
 			warn = true;
 		}
-		xfs_perag_put(pag);
 	}
 
 	/* Measure realtime volume corruption levels. */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 588ea2bf88bb..7dad83a6f586 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1061,15 +1061,13 @@ xfs_reclaim_inodes_ag(
 	int			*nr_to_scan)
 {
 	struct xfs_perag	*pag;
-	xfs_agnumber_t		ag = 0;
+	xfs_agnumber_t		agno;
 
-	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
+	for_each_perag_tag(mp, agno, pag, XFS_ICI_RECLAIM_TAG) {
 		unsigned long	first_index = 0;
 		int		done = 0;
 		int		nr_found = 0;
 
-		ag = pag->pag_agno + 1;
-
 		first_index = READ_ONCE(pag->pag_ici_reclaim_cursor);
 		do {
 			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
@@ -1134,7 +1132,6 @@ xfs_reclaim_inodes_ag(
 		if (done)
 			first_index = 0;
 		WRITE_ONCE(pag->pag_ici_reclaim_cursor, first_index);
-		xfs_perag_put(pag);
 	}
 }
 
@@ -1554,14 +1551,6 @@ xfs_inode_clear_cowblocks_tag(
 	return xfs_blockgc_clear_iflag(ip, XFS_ICOWBLOCKS);
 }
 
-#define for_each_perag_tag(mp, next_agno, pag, tag) \
-	for ((next_agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
-		(pag) != NULL; \
-		(next_agno) = (pag)->pag_agno + 1, \
-		xfs_perag_put(pag), \
-		(pag) = xfs_perag_get_tag((mp), (next_agno), (tag)))
-
-
 /* Disable post-EOF and CoW block auto-reclamation. */
 void
 xfs_blockgc_stop(
-- 
2.31.1

