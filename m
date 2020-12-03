Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23922CD158
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Dec 2020 09:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgLCIev (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 3 Dec 2020 03:34:51 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:36640 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725912AbgLCIev (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 03:34:51 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0UHObv.Y_1606984438;
Received: from localhost(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0UHObv.Y_1606984438)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 03 Dec 2020 16:33:59 +0800
From:   Joseph Qi <joseph.qi@linux.alibaba.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: remove unneeded return value check for xfs_rmapbt_init_cursor()
Date:   Thu,  3 Dec 2020 16:33:58 +0800
Message-Id: <1606984438-13997-1-git-send-email-joseph.qi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since xfs_rmapbt_init_cursor() can always return a valid cursor, the
NULL check in caller is unneeded.
This also keeps the behavior consistent with other callers.

Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/xfs/libxfs/xfs_rmap.c | 9 ---------
 fs/xfs/scrub/bmap.c      | 5 -----
 fs/xfs/scrub/common.c    | 2 --
 3 files changed, 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 2668ebe..10e0cf99 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2404,10 +2404,6 @@ struct xfs_rmap_query_range_info {
 			return -EFSCORRUPTED;
 
 		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
-		if (!rcur) {
-			error = -ENOMEM;
-			goto out_cur;
-		}
 	}
 	*pcur = rcur;
 
@@ -2446,11 +2442,6 @@ struct xfs_rmap_query_range_info {
 		error = -EFSCORRUPTED;
 	}
 	return error;
-
-out_cur:
-	xfs_trans_brelse(tp, agbp);
-
-	return error;
 }
 
 /*
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index fed56d2..dd165c0 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -563,10 +563,6 @@ struct xchk_bmap_check_rmap_info {
 		return error;
 
 	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, agf, agno);
-	if (!cur) {
-		error = -ENOMEM;
-		goto out_agf;
-	}
 
 	sbcri.sc = sc;
 	sbcri.whichfork = whichfork;
@@ -575,7 +571,6 @@ struct xchk_bmap_check_rmap_info {
 		error = 0;
 
 	xfs_btree_del_cursor(cur, error);
-out_agf:
 	xfs_trans_brelse(sc->tp, agf);
 	return error;
 }
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 1887605..6757dc7 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -502,8 +502,6 @@ struct xchk_rmap_ownedby_info {
 	    xchk_ag_btree_healthy_enough(sc, sa->pag, XFS_BTNUM_RMAP)) {
 		sa->rmap_cur = xfs_rmapbt_init_cursor(mp, sc->tp, sa->agf_bp,
 				agno);
-		if (!sa->rmap_cur)
-			goto err;
 	}
 
 	/* Set up a refcountbt cursor for cross-referencing. */
-- 
1.8.3.1

