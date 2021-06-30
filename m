Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CF53B7DF6
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Jun 2021 09:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhF3HXn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 30 Jun 2021 03:23:43 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:52839 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232865AbhF3HXm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Jun 2021 03:23:42 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 235361B0829
        for <linux-xfs@vger.kernel.org>; Wed, 30 Jun 2021 17:21:13 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lyUX2-0013NV-IB
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 17:21:12 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lyUX2-007M4e-AH
        for linux-xfs@vger.kernel.org; Wed, 30 Jun 2021 17:21:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] xfs: order CIL checkpoint start records
Date:   Wed, 30 Jun 2021 17:21:08 +1000
Message-Id: <20210630072108.1752073-6-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210630072108.1752073-1-david@fromorbit.com>
References: <20210630072108.1752073-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=0SoGSWBIiDR9d1GlltwA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because log recovery depends on strictly ordered start records as
well as strictly ordered commit records.

This is a zero day bug in the way XFS writes pipelined transactions
to the journal which is exposed by fixing the zero day bug that
prevents the CIL from pipelining checkpoints. This re-introduces
explicit concurrent commits back into the on-disk journal and hence
out of order start records.

The XFS journal commit code has never ordered start records and we
have relied on strict commit record ordering for correct recovery
ordering of concurrently written transactions. Unfortunately, root
cause analysis uncovered the fact that log recovery uses the LSN of
the start record for transaction commit processing. Hence, whilst
the commits are processed in strict order by recovery, the LSNs
associated with the commits can be out of order and so recovery may
stamp incorrect LSNs into objects and/or misorder intents in the AIL
for later processing. This can result in log recovery failures
and/or on disk corruption, sometimes silent.

Because this is a long standing log recovery issue, we can't just
fix log recovery and call it good. This still leaves older kernels
susceptible to recovery failures and corruption when replaying a log
from a kernel that pipelines checkpoints. There is also the issue
that in-memory ordering for AIL pushing and data integrity
operations are based on checkpoint start LSNs, and if the start LSN
is incorrect in the journal, it is also incorrect in memory.

Hence there's really only one choice for fixing this zero-day bug:
we need to strictly order checkpoint start records in ascending
sequence order in the log, the same way we already strictly order
commit records.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      |  1 +
 fs/xfs/xfs_log_cil.c  | 69 +++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_log_priv.h |  1 +
 3 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d3e1e1a07cdc..7c9990f64dc5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3769,6 +3769,7 @@ xlog_force_shutdown(
 	 * avoid races.
 	 */
 	spin_lock(&log->l_cilp->xc_push_lock);
+	wake_up_all(&log->l_cilp->xc_start_wait);
 	wake_up_all(&log->l_cilp->xc_commit_wait);
 	spin_unlock(&log->l_cilp->xc_push_lock);
 	xlog_state_shutdown_callbacks(log);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 30810b896e46..371577073a81 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -595,6 +595,7 @@ xlog_cil_committed(
 	 */
 	if (abort) {
 		spin_lock(&ctx->cil->xc_push_lock);
+		wake_up_all(&ctx->cil->xc_start_wait);
 		wake_up_all(&ctx->cil->xc_commit_wait);
 		spin_unlock(&ctx->cil->xc_push_lock);
 	}
@@ -648,7 +649,14 @@ xlog_cil_set_ctx_write_state(
 	ASSERT(!ctx->commit_lsn);
 	if (!ctx->start_lsn) {
 		spin_lock(&cil->xc_push_lock);
+		/*
+		 * The LSN we need to pass to the log items on transaction
+		 * commit is the LSN reported by the first log vector write, not
+		 * the commit lsn. If we use the commit record lsn then we can
+		 * move the tail beyond the grant write head.
+		 */
 		ctx->start_lsn = lsn;
+		wake_up_all(&cil->xc_start_wait);
 		spin_unlock(&cil->xc_push_lock);
 		return;
 	}
@@ -690,10 +698,16 @@ xlog_cil_set_ctx_write_state(
  * relies on the context LSN being zero until the log write has guaranteed the
  * LSN that the log write will start at via xlog_state_get_iclog_space().
  */
+enum _record_type {
+	_START_RECORD,
+	_COMMIT_RECORD,
+};
+
 static int
 xlog_cil_order_write(
 	struct xfs_cil		*cil,
-	xfs_csn_t		sequence)
+	xfs_csn_t		sequence,
+	enum _record_type	record)
 {
 	struct xfs_cil_ctx	*ctx;
 
@@ -716,19 +730,47 @@ xlog_cil_order_write(
 		 */
 		if (ctx->sequence >= sequence)
 			continue;
-		if (!ctx->commit_lsn) {
-			/*
-			 * It is still being pushed! Wait for the push to
-			 * complete, then start again from the beginning.
-			 */
-			xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
-			goto restart;
+
+		/* Wait until the LSN for the record has been recorded. */
+		switch (record) {
+		case _START_RECORD:
+			if (!ctx->start_lsn) {
+				xlog_wait(&cil->xc_start_wait, &cil->xc_push_lock);
+				goto restart;
+			}
+			break;
+		case _COMMIT_RECORD:
+			if (!ctx->commit_lsn) {
+				xlog_wait(&cil->xc_commit_wait, &cil->xc_push_lock);
+				goto restart;
+			}
+			break;
 		}
 	}
 	spin_unlock(&cil->xc_push_lock);
 	return 0;
 }
 
+/*
+ * Write out the log vector change now attached to the CIL context. This will
+ * write a start record that needs to be strictly ordered in ascending CIL
+ * sequence order so that log recovery will always use in-order start LSNs when
+ * replaying checkpoints.
+ */
+static int
+xlog_cil_write_chain(
+	struct xfs_cil_ctx	*ctx,
+	struct xfs_log_vec	*chain)
+{
+	struct xlog		*log = ctx->cil->xc_log;
+	int			error;
+
+	error = xlog_cil_order_write(ctx->cil, ctx->sequence, _START_RECORD);
+	if (error)
+		return error;
+	return xlog_write(log, ctx, chain, ctx->ticket, XLOG_START_TRANS);
+}
+
 /*
  * Write out the commit record of a checkpoint transaction to close off a
  * running log write. These commit records are strictly ordered in ascending CIL
@@ -754,6 +796,10 @@ xlog_cil_write_commit_record(
 	if (xlog_is_shutdown(log))
 		return -EIO;
 
+	error = xlog_cil_order_write(ctx->cil, ctx->sequence, _COMMIT_RECORD);
+	if (error)
+		return error;
+
 	error = xlog_write(log, ctx, &vec, ctx->ticket, XLOG_COMMIT_TRANS);
 	if (error)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
@@ -963,11 +1009,7 @@ xlog_cil_push_work(
 	 */
 	wait_for_completion(&bdev_flush);
 
-	error = xlog_write(log, ctx, &lvhdr, tic, XLOG_START_TRANS);
-	if (error)
-		goto out_abort_free_ticket;
-
-	error = xlog_cil_order_write(ctx->cil, ctx->sequence);
+	error = xlog_cil_write_chain(ctx, &lvhdr);
 	if (error)
 		goto out_abort_free_ticket;
 
@@ -1372,6 +1414,7 @@ xlog_cil_init(
 	spin_lock_init(&cil->xc_push_lock);
 	init_waitqueue_head(&cil->xc_push_wait);
 	init_rwsem(&cil->xc_ctx_lock);
+	init_waitqueue_head(&cil->xc_start_wait);
 	init_waitqueue_head(&cil->xc_commit_wait);
 
 	INIT_LIST_HEAD(&ctx->committing);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index f74e3968bb84..400471fa12d2 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -271,6 +271,7 @@ struct xfs_cil {
 	xfs_csn_t		xc_push_seq;
 	struct list_head	xc_committing;
 	wait_queue_head_t	xc_commit_wait;
+	wait_queue_head_t	xc_start_wait;
 	xfs_csn_t		xc_current_sequence;
 	struct work_struct	xc_push_work;
 	wait_queue_head_t	xc_push_wait;	/* background push throttle */
-- 
2.31.1

