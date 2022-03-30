Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8F44EB7A5
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Mar 2022 03:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241548AbiC3BMk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Mar 2022 21:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236681AbiC3BMi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Mar 2022 21:12:38 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A896175C31
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 18:10:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 7EDD0534102
        for <linux-xfs@vger.kernel.org>; Wed, 30 Mar 2022 12:10:51 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nZMrK-00BVQD-DD
        for linux-xfs@vger.kernel.org; Wed, 30 Mar 2022 12:10:50 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nZMrK-005VFH-CH
        for linux-xfs@vger.kernel.org;
        Wed, 30 Mar 2022 12:10:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfs: log shutdown triggers should only shut down the log
Date:   Wed, 30 Mar 2022 12:10:44 +1100
Message-Id: <20220330011048.1311625-5-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220330011048.1311625-1-david@fromorbit.com>
References: <20220330011048.1311625-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6243ae1b
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=MiGWg7VNLSfdgH8YA24A:9 a=AjGcO6oz07-iQ99wixmX:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We've got a mess on our hands.

1. xfs_trans_commit() cannot cancel transactions because the mount is
shut down - that causes dirty, aborted, unlogged log items to sit
unpinned in memory and potentially get written to disk before the
log is shut down. Hence xfs_trans_commit() can only abort
transactions when xlog_is_shutdown() is true.

2. xfs_force_shutdown() is used in places to cause the current
modification to be aborted via xfs_trans_commit() because it may be
impractical or impossible to cancel the transaction directly, and
hence xfs_trans_commit() must cancel transactions when
xfs_is_shutdown() is true in this situation. But we can't do that
because of #1.

3. Log IO errors cause log shutdowns by calling xfs_force_shutdown()
to shut down the mount and then the log from log IO completion.

4. xfs_force_shutdown() can result in a log force being issued,
which has to wait for log IO completion before it will mark the log
as shut down. If #3 races with some other shutdown trigger that runs
a log force, we rely on xfs_force_shutdown() silently ignoring #3
and avoiding shutting down the log until the failed log force
completes.

5. To ensure #2 always works, we have to ensure that
xfs_force_shutdown() does not return until the the log is shut down.
But in the case of #4, this will result in a deadlock because the
log Io completion will block waiting for a log force to complete
which is blocked waiting for log IO to complete....

So the very first thing we have to do here to untangle this mess is
dissociate log shutdown triggers from mount shutdowns. We already
have xlog_forced_shutdown, which will atomically transistion to the
log a shutdown state. Due to internal asserts it cannot be called
multiple times, but was done simply because the only place that
could call it was xfs_do_force_shutdown() (i.e. the mount shutdown!)
and that could only call it once and once only.  So the first thing
we do is remove the asserts.

We then convert all the internal log shutdown triggers to call
xlog_force_shutdown() directly instead of xfs_force_shutdown(). This
allows the log shutdown triggers to shut down the log without
needing to care about mount based shutdown constraints. This means
we shut down the log independently of the mount and the mount may
not notice this until it's next attempt to read or modify metadata.
At that point (e.g. xfs_trans_commit()) it will see that the log is
shutdown, error out and shutdown the mount.

To ensure that all the unmount behaviours and asserts track
correctly as a result of a log shutdown, propagate the shutdown up
to the mount if it is not already set. This keeps the mount and log
state in sync, and saves a huge amount of hassle where code fails
because of a log shutdown but only checks for mount shutdowns and
hence ends up doing the wrong thing. Cleaning up that mess is
an exercise for another day.

This enables us to address the other problems noted above in
followup patches.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c         | 32 +++++++++++++++++++++++---------
 fs/xfs/xfs_log_cil.c     |  4 ++--
 fs/xfs/xfs_log_recover.c |  6 +++---
 fs/xfs/xfs_mount.c       |  1 +
 fs/xfs/xfs_trans_ail.c   |  8 ++++----
 5 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e0d47e74c540..4188ed752169 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1374,7 +1374,7 @@ xlog_ioend_work(
 	 */
 	if (XFS_TEST_ERROR(error, log->l_mp, XFS_ERRTAG_IODONE_IOERR)) {
 		xfs_alert(log->l_mp, "log I/O error %d", error);
-		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 	}
 
 	xlog_state_done_syncing(iclog);
@@ -1913,7 +1913,7 @@ xlog_write_iclog(
 	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
 
 	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
-		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 		return;
 	}
 	if (is_vmalloc_addr(iclog->ic_data))
@@ -2488,7 +2488,7 @@ xlog_write(
 		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
 		     "ctx ticket reservation ran out. Need to up reservation");
 		xlog_print_tic_res(log->l_mp, ticket);
-		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 	}
 
 	len = xlog_write_calc_vec_length(ticket, log_vector, optype);
@@ -3822,9 +3822,10 @@ xlog_verify_iclog(
 #endif
 
 /*
- * Perform a forced shutdown on the log. This should be called once and once
- * only by the high level filesystem shutdown code to shut the log subsystem
- * down cleanly.
+ * Perform a forced shutdown on the log.
+ *
+ * This can be called from low level log code to trigger a shutdown, or from the
+ * high level mount shutdown code when the mount shuts down.
  *
  * Our main objectives here are to make sure that:
  *	a. if the shutdown was not due to a log IO error, flush the logs to
@@ -3833,6 +3834,8 @@ xlog_verify_iclog(
  *	   parties to find out. Nothing new gets queued after this is done.
  *	c. Tasks sleeping on log reservations, pinned objects and
  *	   other resources get woken up.
+ *	d. The mount is also marked as shut down so that log triggered shutdowns
+ *	   still behave the same as if they called xfs_forced_shutdown().
  *
  * Return true if the shutdown cause was a log IO error and we actually shut the
  * log down.
@@ -3851,8 +3854,6 @@ xlog_force_shutdown(
 	if (!log || xlog_in_recovery(log))
 		return false;
 
-	ASSERT(!xlog_is_shutdown(log));
-
 	/*
 	 * Flush all the completed transactions to disk before marking the log
 	 * being shut down. We need to do this first as shutting down the log
@@ -3879,11 +3880,24 @@ xlog_force_shutdown(
 	spin_lock(&log->l_icloglock);
 	if (test_and_set_bit(XLOG_IO_ERROR, &log->l_opstate)) {
 		spin_unlock(&log->l_icloglock);
-		ASSERT(0);
 		return false;
 	}
 	spin_unlock(&log->l_icloglock);
 
+	/*
+	 * If this log shutdown also sets the mount shutdown state, issue a
+	 * shutdown warning message.
+	 */
+	if (!test_and_set_bit(XFS_OPSTATE_SHUTDOWN, &log->l_mp->m_opstate)) {
+		xfs_alert_tag(log->l_mp, XFS_PTAG_SHUTDOWN_LOGERROR,
+"Filesystem has been shut down due to log error (0x%x).",
+				shutdown_flags);
+		xfs_alert(log->l_mp,
+"Please unmount the filesystem and rectify the problem(s).");
+		if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
+			xfs_stack_trace();
+	}
+
 	/*
 	 * We don't want anybody waiting for log reservations after this. That
 	 * means we have to wake up everybody queued up on reserveq as well as
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 796e4464f809..767c386ed4ce 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -540,7 +540,7 @@ xlog_cil_insert_items(
 	spin_unlock(&cil->xc_cil_lock);
 
 	if (tp->t_ticket->t_curr_res < 0)
-		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 }
 
 static void
@@ -854,7 +854,7 @@ xlog_cil_write_commit_record(
 
 	error = xlog_write(log, ctx, &vec, ctx->ticket, XLOG_COMMIT_TRANS);
 	if (error)
-		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index bc8ddc4b78e8..873c59ae6e46 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2485,7 +2485,7 @@ xlog_finish_defer_ops(
 		error = xfs_trans_alloc(mp, &resv, dfc->dfc_blkres,
 				dfc->dfc_rtxres, XFS_TRANS_RESERVE, &tp);
 		if (error) {
-			xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
+			xlog_force_shutdown(mp->m_log, SHUTDOWN_LOG_IO_ERROR);
 			return error;
 		}
 
@@ -3454,7 +3454,7 @@ xlog_recover_finish(
 		 */
 		xlog_recover_cancel_intents(log);
 		xfs_alert(log->l_mp, "Failed to recover intents");
-		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 		return error;
 	}
 
@@ -3501,7 +3501,7 @@ xlog_recover_finish(
 		 * end of intents processing can be pushed through the CIL
 		 * and AIL.
 		 */
-		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
+		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
 	}
 
 	return 0;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e9fb61b2290a..7e7f1f6f7c7a 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -21,6 +21,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_fsops.h"
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index c2ccb98c7bcd..d3a97a028560 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -873,17 +873,17 @@ xfs_trans_ail_delete(
 	int			shutdown_type)
 {
 	struct xfs_ail		*ailp = lip->li_ailp;
-	struct xfs_mount	*mp = ailp->ail_log->l_mp;
+	struct xlog		*log = ailp->ail_log;
 	xfs_lsn_t		tail_lsn;
 
 	spin_lock(&ailp->ail_lock);
 	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 		spin_unlock(&ailp->ail_lock);
-		if (shutdown_type && !xlog_is_shutdown(ailp->ail_log)) {
-			xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
+		if (shutdown_type && !xlog_is_shutdown(log)) {
+			xfs_alert_tag(log->l_mp, XFS_PTAG_AILDELETE,
 	"%s: attempting to delete a log item that is not in the AIL",
 					__func__);
-			xfs_force_shutdown(mp, shutdown_type);
+			xlog_force_shutdown(log, shutdown_type);
 		}
 		return;
 	}
-- 
2.35.1

