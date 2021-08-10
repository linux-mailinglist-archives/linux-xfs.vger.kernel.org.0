Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96983E52B7
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Aug 2021 07:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236791AbhHJFS5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 Aug 2021 01:18:57 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:51520 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237565AbhHJFS4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:18:56 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 521B3109B0B
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:18:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDK9k-00GZYn-Tr
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:18:28 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDK9k-000Abl-MA
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:18:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/9] xfs: XLOG_STATE_IOERROR must die
Date:   Tue, 10 Aug 2021 15:18:18 +1000
Message-Id: <20210810051825.40715-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810051825.40715-1-david@fromorbit.com>
References: <20210810051825.40715-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=LvUAvJMmHZNYVc8vYtEA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We don't need an iclog state field to tell us the log has been shut
down. We can just check the xlog_is_shutdown() instead. The avoids
the need to have shutdown overwrite the current iclog state while
being active used by the log code and so having to ensure that every
iclog state check handles XLOG_STATE_IOERROR appropriately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      | 108 ++++++++++++------------------------------
 fs/xfs/xfs_log_cil.c  |   2 +-
 fs/xfs/xfs_log_priv.h |   4 +-
 fs/xfs/xfs_trace.h    |   1 -
 4 files changed, 32 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e2dc8acf48bc..08fef1e998ea 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -523,7 +523,7 @@ xlog_state_release_iclog(
 	lockdep_assert_held(&log->l_icloglock);
 
 	trace_xlog_iclog_release(iclog, _RET_IP_);
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (xlog_is_shutdown(log))
 		return -EIO;
 
 	/*
@@ -893,7 +893,7 @@ xlog_unmount_write(
 	error = xlog_write_unmount_record(log, tic);
 	/*
 	 * At this point, we're umounting anyway, so there's no point in
-	 * transitioning log state to IOERROR. Just continue...
+	 * transitioning log state to shutdown. Just continue...
 	 */
 out_err:
 	if (error)
@@ -1837,7 +1837,7 @@ xlog_write_iclog(
 	 * across the log IO to archieve that.
 	 */
 	down(&iclog->ic_sema);
-	if (unlikely(iclog->ic_state == XLOG_STATE_IOERROR)) {
+	if (xlog_is_shutdown(log)) {
 		/*
 		 * It would seem logical to return EIO here, but we rely on
 		 * the log state machine to propagate I/O errors instead of
@@ -2376,7 +2376,7 @@ xlog_write_copy_finish(
 			xlog_state_switch_iclogs(log, iclog, 0);
 		else
 			ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
-			       iclog->ic_state == XLOG_STATE_IOERROR);
+				xlog_is_shutdown(log));
 		if (!commit_iclog)
 			goto release_iclog;
 		spin_unlock(&log->l_icloglock);
@@ -2793,8 +2793,7 @@ xlog_state_set_callback(
 static bool
 xlog_state_iodone_process_iclog(
 	struct xlog		*log,
-	struct xlog_in_core	*iclog,
-	bool			*ioerror)
+	struct xlog_in_core	*iclog)
 {
 	xfs_lsn_t		lowest_lsn;
 	xfs_lsn_t		header_lsn;
@@ -2806,15 +2805,6 @@ xlog_state_iodone_process_iclog(
 		 * Skip all iclogs in the ACTIVE & DIRTY states:
 		 */
 		return false;
-	case XLOG_STATE_IOERROR:
-		/*
-		 * Between marking a filesystem SHUTDOWN and stopping the log,
-		 * we do flush all iclogs to disk (if there wasn't a log I/O
-		 * error). So, we do want things to go smoothly in case of just
-		 * a SHUTDOWN w/o a LOG_IO_ERROR.
-		 */
-		*ioerror = true;
-		return false;
 	case XLOG_STATE_DONE_SYNC:
 		/*
 		 * Now that we have an iclog that is in the DONE_SYNC state, do
@@ -2845,7 +2835,6 @@ xlog_state_do_callback(
 	struct xlog_in_core	*iclog;
 	struct xlog_in_core	*first_iclog;
 	bool			cycled_icloglock;
-	bool			ioerror;
 	int			flushcnt = 0;
 	int			repeats = 0;
 
@@ -2859,23 +2848,20 @@ xlog_state_do_callback(
 		 * Keep looping through iclogs until one full pass is made
 		 * without running any callbacks.
 		 */
-		first_iclog = log->l_iclog;
-		iclog = log->l_iclog;
 		cycled_icloglock = false;
-		ioerror = false;
-		repeats++;
+		first_iclog = log->l_iclog;
+		iclog = first_iclog;
 
 		do {
 			LIST_HEAD(cb_list);
 
-			if (xlog_state_iodone_process_iclog(log, iclog,
-							&ioerror))
-				break;
-
-			if (iclog->ic_state != XLOG_STATE_CALLBACK &&
-			    iclog->ic_state != XLOG_STATE_IOERROR) {
-				iclog = iclog->ic_next;
-				continue;
+			if (!xlog_is_shutdown(log)) {
+				if (xlog_state_iodone_process_iclog(log, iclog))
+					break;
+				if (iclog->ic_state != XLOG_STATE_CALLBACK) {
+					iclog = iclog->ic_next;
+					continue;
+				}
 			}
 			list_splice_init(&iclog->ic_callbacks, &cb_list);
 			spin_unlock(&log->l_icloglock);
@@ -2891,19 +2877,19 @@ xlog_state_do_callback(
 			else
 				xlog_state_clean_iclog(log, iclog);
 			iclog = iclog->ic_next;
-		} while (first_iclog != iclog);
+		} while (iclog != first_iclog);
 
-		if (repeats > 5000) {
+		if (++repeats > 5000) {
 			flushcnt += repeats;
 			repeats = 0;
 			xfs_warn(log->l_mp,
 				"%s: possible infinite loop (%d iterations)",
 				__func__, flushcnt);
 		}
-	} while (!ioerror && cycled_icloglock);
+	} while (!xlog_is_shutdown(log) && cycled_icloglock);
 
 	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
-	    log->l_iclog->ic_state == XLOG_STATE_IOERROR)
+	    xlog_is_shutdown(log))
 		wake_up_all(&log->l_flush_wait);
 
 	spin_unlock(&log->l_icloglock);
@@ -2913,13 +2899,6 @@ xlog_state_do_callback(
 /*
  * Finish transitioning this iclog to the dirty state.
  *
- * Make sure that we completely execute this routine only when this is
- * the last call to the iclog.  There is a good chance that iclog flushes,
- * when we reach the end of the physical log, get turned into 2 separate
- * calls to bwrite.  Hence, one iclog flush could generate two calls to this
- * routine.  By using the reference count bwritecnt, we guarantee that only
- * the second completion goes through.
- *
  * Callbacks could take time, so they are done outside the scope of the
  * global state machine log lock.
  */
@@ -3279,10 +3258,10 @@ xfs_log_force(
 	xlog_cil_force(log);
 
 	spin_lock(&log->l_icloglock);
-	iclog = log->l_iclog;
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (xlog_is_shutdown(log))
 		goto out_error;
 
+	iclog = log->l_iclog;
 	trace_xlog_iclog_force(iclog, _RET_IP_);
 
 	if (iclog->ic_state == XLOG_STATE_DIRTY ||
@@ -3348,10 +3327,10 @@ xlog_force_lsn(
 	bool			completed;
 
 	spin_lock(&log->l_icloglock);
-	iclog = log->l_iclog;
-	if (iclog->ic_state == XLOG_STATE_IOERROR)
+	if (xlog_is_shutdown(log))
 		goto out_error;
 
+	iclog = log->l_iclog;
 	while (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
 		trace_xlog_iclog_force_lsn(iclog, _RET_IP_);
 		iclog = iclog->ic_next;
@@ -3806,34 +3785,6 @@ xlog_verify_iclog(
 }
 #endif
 
-/*
- * Mark all iclogs IOERROR. l_icloglock is held by the caller.
- */
-STATIC int
-xlog_state_ioerror(
-	struct xlog	*log)
-{
-	xlog_in_core_t	*iclog, *ic;
-
-	iclog = log->l_iclog;
-	if (iclog->ic_state != XLOG_STATE_IOERROR) {
-		/*
-		 * Mark all the incore logs IOERROR.
-		 * From now on, no log flushes will result.
-		 */
-		ic = iclog;
-		do {
-			ic->ic_state = XLOG_STATE_IOERROR;
-			ic = ic->ic_next;
-		} while (ic != iclog);
-		return 0;
-	}
-	/*
-	 * Return non-zero, if state transition has already happened.
-	 */
-	return 1;
-}
-
 /*
  * This is called from xfs_force_shutdown, when we're forcibly
  * shutting down the filesystem, typically because of an IO error.
@@ -3849,6 +3800,8 @@ xlog_state_ioerror(
  * Note: for the !logerror case we need to flush the regions held in memory out
  * to disk first. This needs to be done before the log is marked as shutdown,
  * otherwise the iclog writes will fail.
+ *
+ * Return non-zero if log shutdown transition had already happened.
  */
 int
 xfs_log_force_umount(
@@ -3856,7 +3809,7 @@ xfs_log_force_umount(
 	int			logerror)
 {
 	struct xlog	*log;
-	int		retval;
+	int		retval = 0;
 
 	log = mp->m_log;
 
@@ -3876,10 +3829,8 @@ xfs_log_force_umount(
 	 * Somebody could've already done the hard work for us.
 	 * No need to get locks for this.
 	 */
-	if (logerror && log->l_iclog->ic_state == XLOG_STATE_IOERROR) {
-		ASSERT(xlog_is_shutdown(log));
+	if (logerror && xlog_is_shutdown(log))
 		return 1;
-	}
 
 	/*
 	 * Flush all the completed transactions to disk before marking the log
@@ -3904,8 +3855,10 @@ xfs_log_force_umount(
 	 * Mark the log and the iclogs with IO error flags to prevent any
 	 * further log IO from being issued or completed.
 	 */
-	log->l_flags |= XLOG_IO_ERROR;
-	retval = xlog_state_ioerror(log);
+	if (!(log->l_flags & XLOG_IO_ERROR)) {
+		log->l_flags |= XLOG_IO_ERROR;
+		retval = 1;
+	}
 	spin_unlock(&log->l_icloglock);
 
 	/*
@@ -3929,7 +3882,6 @@ xfs_log_force_umount(
 	spin_unlock(&log->l_cilp->xc_push_lock);
 	xlog_state_do_callback(log);
 
-	/* return non-zero if log IOERROR transition had already happened */
 	return retval;
 }
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 086e89334b5e..cd7b58f7f13e 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -898,7 +898,7 @@ xlog_cil_push_work(
 	 * callbacks and dropped the icloglock.
 	 */
 	spin_lock(&log->l_icloglock);
-	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
+	if (xlog_is_shutdown(log)) {
 		spin_unlock(&log->l_icloglock);
 		goto out_abort;
 	}
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index e29fcb12dcb1..88b1136e475e 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -47,7 +47,6 @@ enum xlog_iclog_state {
 	XLOG_STATE_DONE_SYNC,	/* Done syncing to disk */
 	XLOG_STATE_CALLBACK,	/* Callback functions now */
 	XLOG_STATE_DIRTY,	/* Dirty IC log, not ready for ACTIVE status */
-	XLOG_STATE_IOERROR,	/* IO error happened in sync'ing log */
 };
 
 #define XLOG_STATE_STRINGS \
@@ -56,8 +55,7 @@ enum xlog_iclog_state {
 	{ XLOG_STATE_SYNCING,	"XLOG_STATE_SYNCING" }, \
 	{ XLOG_STATE_DONE_SYNC,	"XLOG_STATE_DONE_SYNC" }, \
 	{ XLOG_STATE_CALLBACK,	"XLOG_STATE_CALLBACK" }, \
-	{ XLOG_STATE_DIRTY,	"XLOG_STATE_DIRTY" }, \
-	{ XLOG_STATE_IOERROR,	"XLOG_STATE_IOERROR" }
+	{ XLOG_STATE_DIRTY,	"XLOG_STATE_DIRTY" }
 
 /*
  * In core log flags
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 18a6e07f7dd4..70c142f6aeb2 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4017,7 +4017,6 @@ TRACE_DEFINE_ENUM(XLOG_STATE_SYNCING);
 TRACE_DEFINE_ENUM(XLOG_STATE_DONE_SYNC);
 TRACE_DEFINE_ENUM(XLOG_STATE_CALLBACK);
 TRACE_DEFINE_ENUM(XLOG_STATE_DIRTY);
-TRACE_DEFINE_ENUM(XLOG_STATE_IOERROR);
 
 DECLARE_EVENT_CLASS(xlog_iclog_class,
 	TP_PROTO(struct xlog_in_core *iclog, unsigned long caller_ip),
-- 
2.31.1

