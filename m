Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754AF5470F1
	for <lists+linux-xfs@lfdr.de>; Sat, 11 Jun 2022 03:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348616AbiFKB1O (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 Jun 2022 21:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347004AbiFKB1M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jun 2022 21:27:12 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D3633A480E
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jun 2022 18:27:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6347C10E7202
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 11:27:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-005AOJ-5i
        for linux-xfs@vger.kernel.org; Sat, 11 Jun 2022 11:27:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nzpu3-00ELL7-4d
        for linux-xfs@vger.kernel.org;
        Sat, 11 Jun 2022 11:27:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/50] xfs: pass perag to xfs_read_agf
Date:   Sat, 11 Jun 2022 11:26:16 +1000
Message-Id: <20220611012659.3418072-8-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220611012659.3418072-1-david@fromorbit.com>
References: <20220611012659.3418072-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a3ef68
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=s5MFVhOZub3HCYyy_RYA:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We have the perag in most places we call xfs_read_agf, so pass the
perag instead of a mount/agno pair.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 26 ++++++++++++--------------
 fs/xfs/libxfs/xfs_alloc.h |  4 ++--
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 5d6ca86c4882..ab04048bce2e 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3051,27 +3051,25 @@ const struct xfs_buf_ops xfs_agf_buf_ops = {
 /*
  * Read in the allocation group header (free/alloc section).
  */
-int					/* error */
+int
 xfs_read_agf(
-	struct xfs_mount	*mp,	/* mount point structure */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_agnumber_t		agno,	/* allocation group number */
-	int			flags,	/* XFS_BUF_ */
-	struct xfs_buf		**bpp)	/* buffer for the ag freelist header */
+	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
+	int			flags,
+	struct xfs_buf		**agfbpp)
 {
-	int		error;
+	struct xfs_mount	*mp = pag->pag_mount;
+	int			error;
 
-	trace_xfs_read_agf(mp, agno);
+	trace_xfs_read_agf(pag->pag_mount, pag->pag_agno);
 
-	ASSERT(agno != NULLAGNUMBER);
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
-			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
+			XFS_AG_DADDR(mp, pag->pag_agno, XFS_AGF_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), flags, agfbpp, &xfs_agf_buf_ops);
 	if (error)
 		return error;
 
-	ASSERT(!(*bpp)->b_error);
-	xfs_buf_set_ref(*bpp, XFS_AGF_REF);
+	xfs_buf_set_ref(*agfbpp, XFS_AGF_REF);
 	return 0;
 }
 
@@ -3097,7 +3095,7 @@ xfs_alloc_read_agf(
 	/* We don't support trylock when freeing. */
 	ASSERT((flags & (XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK)) !=
 			(XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK));
-	error = xfs_read_agf(pag->pag_mount, tp, pag->pag_agno,
+	error = xfs_read_agf(pag, tp,
 			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
 			&agfbp);
 	if (error)
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index b8cf5beb26d4..06e69fe9c957 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -185,8 +185,8 @@ xfs_alloc_get_rec(
 	xfs_extlen_t		*len,	/* output: length of extent */
 	int			*stat);	/* output: success/failure */
 
-int xfs_read_agf(struct xfs_mount *mp, struct xfs_trans *tp,
-			xfs_agnumber_t agno, int flags, struct xfs_buf **bpp);
+int xfs_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
+		struct xfs_buf **agfbpp);
 int xfs_alloc_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
 		struct xfs_buf **agfbpp);
 int xfs_alloc_read_agfl(struct xfs_mount *mp, struct xfs_trans *tp,
-- 
2.35.1

