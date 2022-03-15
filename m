Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4824D94BF
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Mar 2022 07:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345265AbiCOGoE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Mar 2022 02:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345261AbiCOGoC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 02:44:02 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5D8E1C1F
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 23:42:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D65EC533073
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 17:42:44 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nU0tH-005elM-Ke
        for linux-xfs@vger.kernel.org; Tue, 15 Mar 2022 17:42:43 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nU0tH-00D9KA-JW
        for linux-xfs@vger.kernel.org;
        Tue, 15 Mar 2022 17:42:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] xfs: async CIL flushes need pending pushes to be made stable
Date:   Tue, 15 Mar 2022 17:42:38 +1100
Message-Id: <20220315064241.3133751-5-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315064241.3133751-1-david@fromorbit.com>
References: <20220315064241.3133751-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62303565
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8
        a=yk_eRm6W7gORI4apyj4A:9 a=1CNFftbPRP8L7MoqJWF3:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When the AIL tries to flush the CIL, it relies on the CIL push
ending up on stable storage without having to wait for and
manipulate iclog state directly. However, if there is already a
pending CIL push when the AIL tries to flush the CIL, it won't set
the cil->xc_push_commit_stable flag and so the CIL push will not
actively flush the commit record iclog.

generic/530 when run on a single CPU test VM can trigger this fairly
reliably. This test exercises unlinked inode recovery, and can
result in inodes being pinned in memory by ongoing modifications to
the inode cluster buffer to record unlinked list modifications. As a
result, the first inode unlinked in a buffer can pin the tail of the
log whilst the inode cluster buffer is pinned by the current
checkpoint that has been pushed but isn't on stable storage because
because the cil->xc_push_commit_stable was not set. This results in
the log/AIL effectively deadlocking until something triggers the
commit record iclog to be pushed to stable storage (i.e. the
periodic log worker calling xfs_log_force()).

The fix is two-fold - first we should always set the
cil->xc_push_commit_stable when xlog_cil_flush() is called,
regardless of whether there is already a pending push or not.

Second, if the CIL is empty, we should trigger an iclog flush to
ensure that the iclogs of the last checkpoint have actually been
submitted to disk as that checkpoint may not have been run under
stable completion constraints.

Reported-and-tested-by: Matthew Wilcox <willy@infradead.org>
Fixes: 0020a190cf3e ("xfs: AIL needs asynchronous CIL forcing")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 3d8ebf2a1e55..48b16a5feb27 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1369,18 +1369,27 @@ xlog_cil_push_now(
 	if (!async)
 		flush_workqueue(cil->xc_push_wq);
 
+	spin_lock(&cil->xc_push_lock);
+
+	/*
+	 * If this is an async flush request, we always need to set the
+	 * xc_push_commit_stable flag even if something else has already queued
+	 * a push. The flush caller is asking for the CIL to be on stable
+	 * storage when the next push completes, so regardless of who has queued
+	 * the push, the flush requires stable semantics from it.
+	 */
+	cil->xc_push_commit_stable = async;
+
 	/*
 	 * If the CIL is empty or we've already pushed the sequence then
-	 * there's no work we need to do.
+	 * there's no more work that we need to do.
 	 */
-	spin_lock(&cil->xc_push_lock);
 	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
 		spin_unlock(&cil->xc_push_lock);
 		return;
 	}
 
 	cil->xc_push_seq = push_seq;
-	cil->xc_push_commit_stable = async;
 	queue_work(cil->xc_push_wq, &cil->xc_ctx->push_work);
 	spin_unlock(&cil->xc_push_lock);
 }
@@ -1520,6 +1529,13 @@ xlog_cil_flush(
 
 	trace_xfs_log_force(log->l_mp, seq, _RET_IP_);
 	xlog_cil_push_now(log, seq, true);
+
+	/*
+	 * If the CIL is empty, make sure that any previous checkpoint that may
+	 * still be in an active iclog is pushed to stable storage.
+	 */
+	if (list_empty(&log->l_cilp->xc_cil))
+		xfs_log_force(log->l_mp, 0);
 }
 
 /*
-- 
2.35.1

