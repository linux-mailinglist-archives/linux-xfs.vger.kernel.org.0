Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853435470F6
	for <lists+linux-xfs@lfdr.de>; Sat, 11 Jun 2022 03:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346797AbiFKB1R (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 Jun 2022 21:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347367AbiFKB1N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:13 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 550983A4820
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 554F310E71FE
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-005AOB-1g
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-00ELKo-0e
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/50] xfs: pass perag to xfs_ialloc_read_agi()
Date:   Sat, 11 Jun 2022 11:26:12 +1000
Message-Id: <20220611012659.3418072-4-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62a3ef68
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=f84wIbli6KdFIQT5XmUA:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_ialloc_read_agi() initialises the perag if it hasn't been done
yet, so it makes sense to pass it the perag rather than pull a
reference from the buffer. This allows callers to be per-ag centric
rather than passing mount/agno pairs everywhere.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c           | 23 +++++++++++++----------
 fs/xfs/libxfs/xfs_ialloc.c       | 23 ++++++++++-------------
 fs/xfs/libxfs/xfs_ialloc.h       |  7 ++-----
 fs/xfs/libxfs/xfs_ialloc_btree.c |  9 ++++-----
 fs/xfs/scrub/common.c            |  2 +-
 fs/xfs/scrub/fscounters.c        |  2 +-
 fs/xfs/scrub/repair.c            |  2 +-
 7 files changed, 32 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 355af8fe90c8..74862823311a 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -128,11 +128,13 @@ xfs_initialize_perag_data(
 		if (error)
 			return error;
 
-		error = xfs_ialloc_read_agi(mp, NULL, index, NULL);
-		if (error)
+		pag = xfs_perag_get(mp, index);
+		error = xfs_ialloc_read_agi(pag, NULL, NULL);
+		if (error) {
+			xfs_perag_put(pag);
 			return error;
+		}
 
-		pag = xfs_perag_get(mp, index);
 		ifree += pag->pagi_freecount;
 		ialloc += pag->pagi_count;
 		bfree += pag->pagf_freeblks;
@@ -784,7 +786,7 @@ xfs_ag_shrink_space(
 	int			error, err2;
 
 	ASSERT(pag->pag_agno == mp->m_sb.sb_agcount - 1);
-	error = xfs_ialloc_read_agi(mp, *tpp, pag->pag_agno, &agibp);
+	error = xfs_ialloc_read_agi(pag, *tpp, &agibp);
 	if (error)
 		return error;
 
@@ -816,7 +818,7 @@ xfs_ag_shrink_space(
 	 * Disable perag reservations so it doesn't cause the allocation request
 	 * to fail. We'll reestablish reservation before we return.
 	 */
-	error = xfs_ag_resv_free(agibp->b_pag);
+	error = xfs_ag_resv_free(pag);
 	if (error)
 		return error;
 
@@ -833,7 +835,7 @@ xfs_ag_shrink_space(
 		xfs_trans_bhold(*tpp, agfbp);
 		err2 = xfs_trans_roll(tpp);
 		if (err2)
-			return err2;
+			return error;
 		xfs_trans_bjoin(*tpp, agfbp);
 		goto resv_init_out;
 	}
@@ -845,7 +847,7 @@ xfs_ag_shrink_space(
 	be32_add_cpu(&agi->agi_length, -delta);
 	be32_add_cpu(&agf->agf_length, -delta);
 
-	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
+	err2 = xfs_ag_resv_init(pag, *tpp);
 	if (err2) {
 		be32_add_cpu(&agi->agi_length, delta);
 		be32_add_cpu(&agf->agf_length, delta);
@@ -869,8 +871,9 @@ xfs_ag_shrink_space(
 	xfs_ialloc_log_agi(*tpp, agibp, XFS_AGI_LENGTH);
 	xfs_alloc_log_agf(*tpp, agfbp, XFS_AGF_LENGTH);
 	return 0;
+
 resv_init_out:
-	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
+	err2 = xfs_ag_resv_init(pag, *tpp);
 	if (!err2)
 		return error;
 resv_err:
@@ -895,7 +898,7 @@ xfs_ag_extend_space(
 
 	ASSERT(pag->pag_agno == pag->pag_mount->m_sb.sb_agcount - 1);
 
-	error = xfs_ialloc_read_agi(pag->pag_mount, tp, pag->pag_agno, &bp);
+	error = xfs_ialloc_read_agi(pag, tp, &bp);
 	if (error)
 		return error;
 
@@ -946,7 +949,7 @@ xfs_ag_get_geometry(
 	int			error;
 
 	/* Lock the AG headers. */
-	error = xfs_ialloc_read_agi(pag->pag_mount, NULL, pag->pag_agno, &agi_bp);
+	error = xfs_ialloc_read_agi(pag, NULL, &agi_bp);
 	if (error)
 		return error;
 	error = xfs_alloc_read_agf(pag->pag_mount, NULL, pag->pag_agno, 0, &agf_bp);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index cefac2a1ba0c..a7259404377d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1610,7 +1610,7 @@ xfs_dialloc_good_ag(
 		return false;
 
 	if (!pag->pagi_init) {
-		error = xfs_ialloc_read_agi(mp, tp, pag->pag_agno, NULL);
+		error = xfs_ialloc_read_agi(pag, tp, NULL);
 		if (error)
 			return false;
 	}
@@ -1679,7 +1679,7 @@ xfs_dialloc_try_ag(
 	 * Then read in the AGI buffer and recheck with the AGI buffer
 	 * lock held.
 	 */
-	error = xfs_ialloc_read_agi(pag->pag_mount, *tpp, pag->pag_agno, &agbp);
+	error = xfs_ialloc_read_agi(pag, *tpp, &agbp);
 	if (error)
 		return error;
 
@@ -2169,7 +2169,7 @@ xfs_difree(
 	/*
 	 * Get the allocation group header.
 	 */
-	error = xfs_ialloc_read_agi(mp, tp, pag->pag_agno, &agbp);
+	error = xfs_ialloc_read_agi(pag, tp, &agbp);
 	if (error) {
 		xfs_warn(mp, "%s: xfs_ialloc_read_agi() returned error %d.",
 			__func__, error);
@@ -2215,7 +2215,7 @@ xfs_imap_lookup(
 	int			error;
 	int			i;
 
-	error = xfs_ialloc_read_agi(mp, tp, pag->pag_agno, &agbp);
+	error = xfs_ialloc_read_agi(pag, tp, &agbp);
 	if (error) {
 		xfs_alert(mp,
 			"%s: xfs_ialloc_read_agi() returned error %d, agno %d",
@@ -2599,24 +2599,21 @@ xfs_read_agi(
  */
 int
 xfs_ialloc_read_agi(
-	struct xfs_mount	*mp,	/* file system mount structure */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_agnumber_t		agno,	/* allocation group number */
+	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
 	struct xfs_buf		**agibpp)
 {
 	struct xfs_buf		*agibp;
-	struct xfs_agi		*agi;	/* allocation group header */
-	struct xfs_perag	*pag;	/* per allocation group data */
+	struct xfs_agi		*agi;
 	int			error;
 
-	trace_xfs_ialloc_read_agi(mp, agno);
+	trace_xfs_ialloc_read_agi(pag->pag_mount, pag->pag_agno);
 
-	error = xfs_read_agi(mp, tp, agno, &agibp);
+	error = xfs_read_agi(pag->pag_mount, tp, pag->pag_agno, &agibp);
 	if (error)
 		return error;
 
 	agi = agibp->b_addr;
-	pag = agibp->b_pag;
 	if (!pag->pagi_init) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
 		pag->pagi_count = be32_to_cpu(agi->agi_count);
@@ -2628,7 +2625,7 @@ xfs_ialloc_read_agi(
 	 * we are in the middle of a forced shutdown.
 	 */
 	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		xfs_is_shutdown(mp));
+		xfs_is_shutdown(pag->pag_mount));
 	if (agibpp)
 		*agibpp = agibp;
 	else
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 1ff42bf1e4b3..72cb33170d9f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -66,11 +66,8 @@ xfs_ialloc_log_agi(
  * Read in the allocation group header (inode allocation section)
  */
 int					/* error */
-xfs_ialloc_read_agi(
-	struct xfs_mount *mp,		/* file system mount structure */
-	struct xfs_trans *tp,		/* transaction pointer */
-	xfs_agnumber_t	agno,		/* allocation group number */
-	struct xfs_buf	**bpp);		/* allocation group hdr buf */
+xfs_ialloc_read_agi(struct xfs_perag *pag, struct xfs_trans *tp,
+		struct xfs_buf **agibpp);
 
 /*
  * Lookup a record by ino in the btree given by cur.
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index b2ad2fdc40f5..aa4367a0a0de 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -722,7 +722,7 @@ xfs_inobt_cur(
 	ASSERT(*agi_bpp == NULL);
 	ASSERT(*curpp == NULL);
 
-	error = xfs_ialloc_read_agi(mp, tp, pag->pag_agno, agi_bpp);
+	error = xfs_ialloc_read_agi(pag, tp, agi_bpp);
 	if (error)
 		return error;
 
@@ -757,16 +757,15 @@ xfs_inobt_count_blocks(
 /* Read finobt block count from AGI header. */
 static int
 xfs_finobt_read_blocks(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
 	xfs_extlen_t		*tree_blocks)
 {
 	struct xfs_buf		*agbp;
 	struct xfs_agi		*agi;
 	int			error;
 
-	error = xfs_ialloc_read_agi(mp, tp, pag->pag_agno, &agbp);
+	error = xfs_ialloc_read_agi(pag, tp, &agbp);
 	if (error)
 		return error;
 
@@ -794,7 +793,7 @@ xfs_finobt_calc_reserves(
 		return 0;
 
 	if (xfs_has_inobtcounts(mp))
-		error = xfs_finobt_read_blocks(mp, tp, pag, &tree_len);
+		error = xfs_finobt_read_blocks(pag, tp, &tree_len);
 	else
 		error = xfs_inobt_count_blocks(mp, tp, pag, XFS_BTNUM_FINO,
 				&tree_len);
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 97b54ac3075f..62997791694a 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -416,7 +416,7 @@ xchk_ag_read_headers(
 	if (!sa->pag)
 		return -ENOENT;
 
-	error = xfs_ialloc_read_agi(mp, sc->tp, agno, &sa->agi_bp);
+	error = xfs_ialloc_read_agi(sa->pag, sc->tp, &sa->agi_bp);
 	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGI))
 		return error;
 
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 48a6cbdf95d0..bd06a184c81c 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -78,7 +78,7 @@ xchk_fscount_warmup(
 			continue;
 
 		/* Lock both AG headers. */
-		error = xfs_ialloc_read_agi(mp, sc->tp, agno, &agi_bp);
+		error = xfs_ialloc_read_agi(pag, sc->tp, &agi_bp);
 		if (error)
 			break;
 		error = xfs_alloc_read_agf(mp, sc->tp, agno, 0, &agf_bp);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 1e7b6b209ee8..14acf1df3dd3 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -199,7 +199,7 @@ xrep_calc_ag_resblks(
 		icount = pag->pagi_count;
 	} else {
 		/* Try to get the actual counters from disk. */
-		error = xfs_ialloc_read_agi(mp, NULL, sm->sm_agno, &bp);
+		error = xfs_ialloc_read_agi(pag, NULL, &bp);
 		if (!error) {
 			icount = pag->pagi_count;
 			xfs_buf_relse(bp);
-- 
2.35.1

