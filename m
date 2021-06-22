Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A283AFB97
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Jun 2021 06:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbhFVEI2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 22 Jun 2021 00:08:28 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33666 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229668AbhFVEI0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jun 2021 00:08:26 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 71F218625E5
        for <linux-xfs@vger.kernel.org>; Tue, 22 Jun 2021 14:06:08 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lvXfr-00FZEx-H4
        for linux-xfs@vger.kernel.org; Tue, 22 Jun 2021 14:06:07 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lvXfr-005PwV-9M
        for linux-xfs@vger.kernel.org; Tue, 22 Jun 2021 14:06:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: Fix a CIL UAF by getting get rid of the iclog callback lock
Date:   Tue, 22 Jun 2021 14:06:03 +1000
Message-Id: <20210622040604.1290539-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622040604.1290539-1-david@fromorbit.com>
References: <20210622040604.1290539-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=Fxz0yc47MEUxRqV9:21 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8
        a=dyVswvn_PzJtY2rAyiUA:9 a=s0jyaZ7ElpLc7b0pKZbp:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The iclog callback chain has it's own lock. That was added way back
in 2008 by myself to alleviate severe lock contention on the
icloglock in commit 114d23aae512 ("[XFS] Per iclog callback chain
lock"). This was long before delayed logging took the icloglock out
of the hot transaction commit path and removed all contention on it.
Hence the separate ic_callback_lock doesn't serve any scalability
purpose anymore, and hasn't for close on a decade.

Further, we only attach callbacks to iclogs in one place where we
are already taking the icloglock soon after attaching the callbacks.
We also have to drop the icloglock to run callbacks and grab it
immediately afterwards again. So given that the icloglock is no
longer hot, making it cover callbacks again doesn't really change
the locking patterns very much at all.

We also need to extend the icloglock to cover callback addition to
fix a zero-day UAF in the CIL push code. This occurs when shutdown
races with xlog_cil_push_work() and the shutdown runs the callbacks
before the push releases the iclog. This results in the CIL context
structure attached to the iclog being freed by the callback before
the CIL push has finished referencing it, leading to UAF bugs.

Hence, to avoid this UAF, we need the callback attachment to be
atomic with post processing of the commit iclog and references to
the structures being attached to the iclog. This requires holding
the icloglock as that's the only way to serialise iclog state
against a shutdown in progress.

The result is we need to be using the icloglock to protect the
callback list addition and removal and serialise them with shutdown.
That makes the ic_callback_lock redundant and so it can be removed.

Fixes: 71e330b59390 ("xfs: Introduce delayed logging core code")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      | 34 ++++++----------------------------
 fs/xfs/xfs_log_cil.c  | 16 ++++++++++++----
 fs/xfs/xfs_log_priv.h |  3 ---
 3 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 05b00fa4d661..c896c9041b8e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1484,7 +1484,6 @@ xlog_alloc_log(
 		iclog->ic_state = XLOG_STATE_ACTIVE;
 		iclog->ic_log = log;
 		atomic_set(&iclog->ic_refcnt, 0);
-		spin_lock_init(&iclog->ic_callback_lock);
 		INIT_LIST_HEAD(&iclog->ic_callbacks);
 		iclog->ic_datap = (char *)iclog->ic_data + log->l_iclog_hsize;
 
@@ -2760,32 +2759,6 @@ xlog_state_iodone_process_iclog(
 	}
 }
 
-/*
- * Keep processing entries in the iclog callback list until we come around and
- * it is empty.  We need to atomically see that the list is empty and change the
- * state to DIRTY so that we don't miss any more callbacks being added.
- *
- * This function is called with the icloglock held and returns with it held. We
- * drop it while running callbacks, however, as holding it over thousands of
- * callbacks is unnecessary and causes excessive contention if we do.
- */
-static void
-xlog_state_do_iclog_callbacks(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog)
-{
-	LIST_HEAD(tmp);
-
-	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
-
-	spin_lock(&iclog->ic_callback_lock);
-	list_splice_init(&iclog->ic_callbacks, &tmp);
-	spin_unlock(&iclog->ic_callback_lock);
-
-	xlog_cil_process_committed(&tmp);
-	trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
-}
-
 STATIC void
 xlog_state_do_callback(
 	struct xlog		*log)
@@ -2814,6 +2787,8 @@ xlog_state_do_callback(
 		repeats++;
 
 		do {
+			LIST_HEAD(cb_list);
+
 			if (xlog_state_iodone_process_iclog(log, iclog,
 							&ioerror))
 				break;
@@ -2823,9 +2798,12 @@ xlog_state_do_callback(
 				iclog = iclog->ic_next;
 				continue;
 			}
+			list_splice_init(&iclog->ic_callbacks, &cb_list);
 			spin_unlock(&log->l_icloglock);
 
-			xlog_state_do_iclog_callbacks(log, iclog);
+			trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
+			xlog_cil_process_committed(&cb_list);
+			trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
 			cycled_icloglock = true;
 
 			spin_lock(&log->l_icloglock);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 3c2b1205944d..27bed1d9cf29 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -873,15 +873,21 @@ xlog_cil_push_work(
 
 	xfs_log_ticket_ungrant(log, tic);
 
-	spin_lock(&commit_iclog->ic_callback_lock);
+	/*
+	 * Once we attach the ctx to the iclog, a shutdown can process the
+	 * iclog, run the callbacks and free the ctx. The only thing preventing
+	 * this potential UAF situation here is that we are holding the
+	 * icloglock. Hence we cannot access the ctx after we have attached the
+	 * callbacks and dropped the icloglock.
+	 */
+	spin_lock(&log->l_icloglock);
 	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
-		spin_unlock(&commit_iclog->ic_callback_lock);
+		spin_unlock(&log->l_icloglock);
 		goto out_abort;
 	}
 	ASSERT_ALWAYS(commit_iclog->ic_state == XLOG_STATE_ACTIVE ||
 		      commit_iclog->ic_state == XLOG_STATE_WANT_SYNC);
 	list_add_tail(&ctx->iclog_entry, &commit_iclog->ic_callbacks);
-	spin_unlock(&commit_iclog->ic_callback_lock);
 
 	/*
 	 * now the checkpoint commit is complete and we've attached the
@@ -898,8 +904,10 @@ xlog_cil_push_work(
 	 * iclogs to complete before we submit the commit_iclog. In this case,
 	 * the commit_iclog write needs to issue a pre-flush so that the
 	 * ordering is correctly preserved down to stable storage.
+	 *
+	 * NOTE: It is not safe reference the ctx after this check as we drop
+	 * the icloglock if we have to wait for completion of other iclogs.
 	 */
-	spin_lock(&log->l_icloglock);
 	if (ctx->start_lsn != commit_lsn) {
 		xlog_wait_on_iclog(commit_iclog->ic_prev);
 		spin_lock(&log->l_icloglock);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 293d82b1fc0d..4c41bbfa33b0 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -216,9 +216,6 @@ typedef struct xlog_in_core {
 	enum xlog_iclog_state	ic_state;
 	unsigned int		ic_flags;
 	char			*ic_datap;	/* pointer to iclog data */
-
-	/* Callback structures need their own cacheline */
-	spinlock_t		ic_callback_lock ____cacheline_aligned_in_smp;
 	struct list_head	ic_callbacks;
 
 	/* reference counts need their own cacheline */
-- 
2.31.1

