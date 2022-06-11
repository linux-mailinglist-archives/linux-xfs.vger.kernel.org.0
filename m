Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009645470EF
	for <lists+linux-xfs@lfdr.de>; Sat, 11 Jun 2022 03:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346537AbiFKB1L (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 Jun 2022 21:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbiFKB1J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:09 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 34BBA3A481D
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 3DC5610E71FD
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-005AO9-0d
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu2-00ELKj-VW
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:02 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/50] xfs: kill xfs_ialloc_pagi_init()
Date:   Sat, 11 Jun 2022 11:26:11 +1000
Message-Id: <20220611012659.3418072-3-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a3ef68
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=mnth8bXlkqBwt9m5dQ0A:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This is just a basic wrapper around xfs_ialloc_read_agi(), which can
be entirely handled by xfs_ialloc_read_agi() by passing a NULL
agibpp....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c     |  3 ++-
 fs/xfs/libxfs/xfs_ialloc.c | 39 ++++++++++++++------------------------
 fs/xfs/libxfs/xfs_ialloc.h | 10 ----------
 3 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 71d727c1546b..355af8fe90c8 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -128,9 +128,10 @@ xfs_initialize_perag_data(
 		if (error)
 			return error;
 
-		error = xfs_ialloc_pagi_init(mp, NULL, index);
+		error = xfs_ialloc_read_agi(mp, NULL, index, NULL);
 		if (error)
 			return error;
+
 		pag = xfs_perag_get(mp, index);
 		ifree += pag->pagi_freecount;
 		ialloc += pag->pagi_count;
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index bf2f4bc89193..cefac2a1ba0c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1610,7 +1610,7 @@ xfs_dialloc_good_ag(
 		return false;
 
 	if (!pag->pagi_init) {
-		error = xfs_ialloc_pagi_init(mp, tp, pag->pag_agno);
+		error = xfs_ialloc_read_agi(mp, tp, pag->pag_agno, NULL);
 		if (error)
 			return false;
 	}
@@ -2593,25 +2593,30 @@ xfs_read_agi(
 	return 0;
 }
 
+/*
+ * Read in the agi and initialise the per-ag data. If the caller supplies a
+ * @agibpp, return the locked AGI buffer to them, otherwise release it.
+ */
 int
 xfs_ialloc_read_agi(
 	struct xfs_mount	*mp,	/* file system mount structure */
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_agnumber_t		agno,	/* allocation group number */
-	struct xfs_buf		**bpp)	/* allocation group hdr buf */
+	struct xfs_buf		**agibpp)
 {
+	struct xfs_buf		*agibp;
 	struct xfs_agi		*agi;	/* allocation group header */
 	struct xfs_perag	*pag;	/* per allocation group data */
 	int			error;
 
 	trace_xfs_ialloc_read_agi(mp, agno);
 
-	error = xfs_read_agi(mp, tp, agno, bpp);
+	error = xfs_read_agi(mp, tp, agno, &agibp);
 	if (error)
 		return error;
 
-	agi = (*bpp)->b_addr;
-	pag = (*bpp)->b_pag;
+	agi = agibp->b_addr;
+	pag = agibp->b_pag;
 	if (!pag->pagi_init) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
 		pag->pagi_count = be32_to_cpu(agi->agi_count);
@@ -2624,26 +2629,10 @@ xfs_ialloc_read_agi(
 	 */
 	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
 		xfs_is_shutdown(mp));
-	return 0;
-}
-
-/*
- * Read in the agi to initialise the per-ag data in the mount structure
- */
-int
-xfs_ialloc_pagi_init(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_agnumber_t	agno)		/* allocation group number */
-{
-	struct xfs_buf	*bp = NULL;
-	int		error;
-
-	error = xfs_ialloc_read_agi(mp, tp, agno, &bp);
-	if (error)
-		return error;
-	if (bp)
-		xfs_trans_brelse(tp, bp);
+	if (agibpp)
+		*agibpp = agibp;
+	else
+		xfs_trans_brelse(tp, agibp);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index a7705b6a1fd3..1ff42bf1e4b3 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -72,16 +72,6 @@ xfs_ialloc_read_agi(
 	xfs_agnumber_t	agno,		/* allocation group number */
 	struct xfs_buf	**bpp);		/* allocation group hdr buf */
 
-/*
- * Read in the allocation group header to initialise the per-ag data
- * in the mount structure
- */
-int
-xfs_ialloc_pagi_init(
-	struct xfs_mount *mp,		/* file system mount structure */
-	struct xfs_trans *tp,		/* transaction pointer */
-        xfs_agnumber_t  agno);		/* allocation group number */
-
 /*
  * Lookup a record by ino in the btree given by cur.
  */
-- 
2.35.1

