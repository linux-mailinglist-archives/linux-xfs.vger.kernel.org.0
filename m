Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3AF3B7DF9
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Jun 2021 09:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbhF3HXo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 30 Jun 2021 03:23:44 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34797 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232867AbhF3HXm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 03:23:42 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5750F10446FF
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jun 2021 17:21:13 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lyUX2-0013NR-FI
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 17:21:12 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lyUX2-007M4Y-7U
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 17:21:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: factor out log write ordering from xlog_cil_push_work()
Date:   Wed, 30 Jun 2021 17:21:06 +1000
Message-Id: <20210630072108.1752073-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630072108.1752073-1-david@fromorbit.com>
References: <20210630072108.1752073-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=k7W3vL2-wnp397sw1bIA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So we can use it for start record ordering as well as commit record
ordering in future.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c | 87 ++++++++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 4b6589bbddb5..8f88ee2abdf6 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -656,9 +656,54 @@ xlog_cil_set_ctx_write_state(
 
 
 /*
- * Write out the commit record of a checkpoint transaction associated with the
- * given ticket to close off a running log write. Return the lsn of the commit
- * record.
+ * Ensure that the order of log writes follows checkpoint sequence order. This
+ * relies on the context LSN being zero until the log write has guaranteed the
+ * LSN that the log write will start at via xlog_state_get_iclog_space().
+ */
+static int
+xlog_cil_order_write(
+	struct xfs_cil		*cil,
+	xfs_csn_t		sequence)
+{
+	struct xfs_cil_ctx	*ctx;
+
+restart:
+	spin_lock(&cil->xc_push_lock);
+	list_for_each_entry(ctx, &cil->xc_committing, committing) {
+		/*
+		 * Avoid getting stuck in this loop because we were woken by the
+		 * shutdown, but then went back to sleep once already in the
+		 * shutdown state.
+		 */
+		if (xlog_is_shutdown(cil->xc_log)) {
+			spin_unlock(&cil->xc_push_lock);
+			return -EIO;
+		}
+
+		/*
+		 * Higher sequences will wait for this one so skip them.
+		 * Don't wait for our own sequence, either.
+		 */
+		if (ctx->sequence >= sequence)
+			continue;
+		if (!ctx->commit_lsn) {
+			/*
+			 * It is still being pushed! Wait for the push to
+			 * complete, then start again from the beginning.
+			 */
+			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
+			goto restart;
+		}
+	}
+	spin_unlock(&cil->xc_push_lock);
+	return 0;
+}
+
+/*
+ * Write out the commit record of a checkpoint transaction to close off a
+ * running log write. These commit records are strictly ordered in ascending CIL
+ * sequence order so that log recovery will always replay the checkpoints in the
+ * correct order.
  */
 static int
 xlog_cil_write_commit_record(
@@ -895,39 +940,9 @@ xlog_cil_push_work(
 	if (error)
 		goto out_abort_free_ticket;
 
-	/*
-	 * now that we've written the checkpoint into the log, strictly
-	 * order the commit records so replay will get them in the right order.
-	 */
-restart:
-	spin_lock(&cil->xc_push_lock);
-	list_for_each_entry(new_ctx, &cil->xc_committing, committing) {
-		/*
-		 * Avoid getting stuck in this loop because we were woken by the
-		 * shutdown, but then went back to sleep once already in the
-		 * shutdown state.
-		 */
-		if (xlog_is_shutdown(log)) {
-			spin_unlock(&cil->xc_push_lock);
-			goto out_abort_free_ticket;
-		}
-
-		/*
-		 * Higher sequences will wait for this one so skip them.
-		 * Don't wait for our own sequence, either.
-		 */
-		if (new_ctx->sequence >= ctx->sequence)
-			continue;
-		if (!new_ctx->commit_lsn) {
-			/*
-			 * It is still being pushed! Wait for the push to
-			 * complete, then start again from the beginning.
-			 */
-			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
-			goto restart;
-		}
-	}
-	spin_unlock(&cil->xc_push_lock);
+	error = xlog_cil_order_write(ctx->cil, ctx->sequence);
+	if (error)
+		goto out_abort_free_ticket;
 
 	error = xlog_cil_write_commit_record(ctx, &commit_iclog);
 	if (error)
-- 
2.31.1

