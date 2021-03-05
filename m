Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E3432E149
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Mar 2021 06:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCEFMz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Mar 2021 00:12:55 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59333 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229666AbhCEFMP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:12:15 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BC20D1040F3C
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:51 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kh-00FbpD-80
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:51 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kh-000laF-0G
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 31/45] xfs: CIL context doesn't need to count iovecs
Date:   Fri,  5 Mar 2021 16:11:29 +1100
Message-Id: <20210305051143.182133-32-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=XTp5-oq1X3BrlmPbjW0A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that we account for log opheaders in the log item formatting
code, we don't actually use the aggregated count of log iovecs in
the CIL for anything. Remove it and the tracking code that
calculates it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 34abc3bae587..4047f95a0fc4 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -252,22 +252,18 @@ xlog_cil_alloc_shadow_bufs(
 
 /*
  * Prepare the log item for insertion into the CIL. Calculate the difference in
- * log space and vectors it will consume, and if it is a new item pin it as
- * well.
+ * log space it will consume, and if it is a new item pin it as well.
  */
 STATIC void
 xfs_cil_prepare_item(
 	struct xlog		*log,
 	struct xfs_log_vec	*lv,
 	struct xfs_log_vec	*old_lv,
-	int			*diff_len,
-	int			*diff_iovecs)
+	int			*diff_len)
 {
 	/* Account for the new LV being passed in */
-	if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED) {
+	if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
 		*diff_len += lv->lv_bytes;
-		*diff_iovecs += lv->lv_niovecs;
-	}
 
 	/*
 	 * If there is no old LV, this is the first time we've seen the item in
@@ -284,7 +280,6 @@ xfs_cil_prepare_item(
 		ASSERT(lv->lv_buf_len != XFS_LOG_VEC_ORDERED);
 
 		*diff_len -= old_lv->lv_bytes;
-		*diff_iovecs -= old_lv->lv_niovecs;
 		lv->lv_item->li_lv_shadow = old_lv;
 	}
 
@@ -333,12 +328,10 @@ static void
 xlog_cil_insert_format_items(
 	struct xlog		*log,
 	struct xfs_trans	*tp,
-	int			*diff_len,
-	int			*diff_iovecs)
+	int			*diff_len)
 {
 	struct xfs_log_item	*lip;
 
-
 	/* Bail out if we didn't find a log item.  */
 	if (list_empty(&tp->t_items)) {
 		ASSERT(0);
@@ -381,7 +374,6 @@ xlog_cil_insert_format_items(
 			 * set the item up as though it is a new insertion so
 			 * that the space reservation accounting is correct.
 			 */
-			*diff_iovecs -= lv->lv_niovecs;
 			*diff_len -= lv->lv_bytes;
 
 			/* Ensure the lv is set up according to ->iop_size */
@@ -406,7 +398,7 @@ xlog_cil_insert_format_items(
 		ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
 		lip->li_ops->iop_format(lip, lv);
 insert:
-		xfs_cil_prepare_item(log, lv, old_lv, diff_len, diff_iovecs);
+		xfs_cil_prepare_item(log, lv, old_lv, diff_len);
 	}
 }
 
@@ -426,7 +418,6 @@ xlog_cil_insert_items(
 	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
 	struct xfs_log_item	*lip;
 	int			len = 0;
-	int			diff_iovecs = 0;
 	int			iclog_space;
 	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
 
@@ -436,7 +427,7 @@ xlog_cil_insert_items(
 	 * We can do this safely because the context can't checkpoint until we
 	 * are done so it doesn't matter exactly how we update the CIL.
 	 */
-	xlog_cil_insert_format_items(log, tp, &len, &diff_iovecs);
+	xlog_cil_insert_format_items(log, tp, &len);
 
 	spin_lock(&cil->xc_cil_lock);
 
@@ -471,7 +462,6 @@ xlog_cil_insert_items(
 	}
 	tp->t_ticket->t_curr_res -= len;
 	ctx->space_used += len;
-	ctx->nvecs += diff_iovecs;
 
 	/*
 	 * If we've overrun the reservation, dump the tx details before we move
-- 
2.28.0

