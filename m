Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3767D388DA3
	for <lists+linux-xfs@lfdr.de>; Wed, 19 May 2021 14:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345652AbhESMOl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 19 May 2021 08:14:41 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:41323 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241072AbhESMOl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:41 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 648B180B74A
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4h-002m0t-QN
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:19 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4h-002SGy-Id
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/39] xfs: CIL work is serialised, not pipelined
Date:   Wed, 19 May 2021 22:12:49 +1000
Message-Id: <20210519121317.585244-12-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=A5Cs0mGKsY9zP8qgzdMA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because we use a single work structure attached to the CIL rather
than the CIL context, we can only queue a single work item at a
time. This results in the CIL being single threaded and limits
performance when it becomes CPU bound.

The design of the CIL is that it is pipelined and multiple commits
can be running concurrently, but the way the work is currently
implemented means that it is not pipelining as it was intended. The
critical work to switch the CIL context can take a few milliseconds
to run, but the rest of the CIL context flush can take hundreds of
milliseconds to complete. The context switching is the serialisation
point of the CIL, once the context has been switched the rest of the
context push can run asynchrnously with all other context pushes.

Hence we can move the work to the CIL context so that we can run
multiple CIL pushes at the same time and spread the majority of
the work out over multiple CPUs. We can keep the per-cpu CIL commit
state on the CIL rather than the context, because the context is
pinned to the CIL until the switch is done and we aggregate and
drain the per-cpu state held on the CIL during the context switch.

However, because we no longer serialise the CIL work, we can have
effectively unlimited CIL pushes in progress. We don't want to do
this - not only does it create contention on the iclogs and the
state machine locks, we can run the log right out of space with
outstanding pushes. Instead, limit the work concurrency to 4
concurrent works being processed at a time. THis is enough
concurrency to remove the CIL from being a CPU bound bottleneck but
not enough to create new contention points or unbound concurrency
issues.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c  | 80 +++++++++++++++++++++++--------------------
 fs/xfs/xfs_log_priv.h |  2 +-
 fs/xfs/xfs_super.c    |  6 +++-
 3 files changed, 48 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index cb849e67b1c4..713ea66d4c0c 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -47,6 +47,34 @@ xlog_cil_ticket_alloc(
 	return tic;
 }
 
+/*
+ * Unavoidable forward declaration - xlog_cil_push_work() calls
+ * xlog_cil_ctx_alloc() itself.
+ */
+static void xlog_cil_push_work(struct work_struct *work);
+
+static struct xfs_cil_ctx *
+xlog_cil_ctx_alloc(void)
+{
+	struct xfs_cil_ctx	*ctx;
+
+	ctx = kmem_zalloc(sizeof(*ctx), KM_NOFS);
+	INIT_LIST_HEAD(&ctx->committing);
+	INIT_LIST_HEAD(&ctx->busy_extents);
+	INIT_WORK(&ctx->push_work, xlog_cil_push_work);
+	return ctx;
+}
+
+static void
+xlog_cil_ctx_switch(
+	struct xfs_cil		*cil,
+	struct xfs_cil_ctx	*ctx)
+{
+	ctx->sequence = ++cil->xc_current_sequence;
+	ctx->cil = cil;
+	cil->xc_ctx = ctx;
+}
+
 /*
  * After the first stage of log recovery is done, we know where the head and
  * tail of the log are. We need this log initialisation done before we can
@@ -641,11 +669,11 @@ static void
 xlog_cil_push_work(
 	struct work_struct	*work)
 {
-	struct xfs_cil		*cil =
-		container_of(work, struct xfs_cil, xc_push_work);
+	struct xfs_cil_ctx	*ctx =
+		container_of(work, struct xfs_cil_ctx, push_work);
+	struct xfs_cil		*cil = ctx->cil;
 	struct xlog		*log = cil->xc_log;
 	struct xfs_log_vec	*lv;
-	struct xfs_cil_ctx	*ctx;
 	struct xfs_cil_ctx	*new_ctx;
 	struct xlog_in_core	*commit_iclog;
 	struct xlog_ticket	*tic;
@@ -660,11 +688,10 @@ xlog_cil_push_work(
 	DECLARE_COMPLETION_ONSTACK(bdev_flush);
 	bool			push_commit_stable;
 
-	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
+	new_ctx = xlog_cil_ctx_alloc();
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
 
 	down_write(&cil->xc_ctx_lock);
-	ctx = cil->xc_ctx;
 
 	spin_lock(&cil->xc_push_lock);
 	push_seq = cil->xc_push_seq;
@@ -696,7 +723,7 @@ xlog_cil_push_work(
 
 
 	/* check for a previously pushed sequence */
-	if (push_seq < cil->xc_ctx->sequence) {
+	if (push_seq < ctx->sequence) {
 		spin_unlock(&cil->xc_push_lock);
 		goto out_skip;
 	}
@@ -761,19 +788,7 @@ xlog_cil_push_work(
 	}
 
 	/*
-	 * initialise the new context and attach it to the CIL. Then attach
-	 * the current context to the CIL committing list so it can be found
-	 * during log forces to extract the commit lsn of the sequence that
-	 * needs to be forced.
-	 */
-	INIT_LIST_HEAD(&new_ctx->committing);
-	INIT_LIST_HEAD(&new_ctx->busy_extents);
-	new_ctx->sequence = ctx->sequence + 1;
-	new_ctx->cil = cil;
-	cil->xc_ctx = new_ctx;
-
-	/*
-	 * The switch is now done, so we can drop the context lock and move out
+	 * Switch the contexts so we can drop the context lock and move out
 	 * of a shared context. We can't just go straight to the commit record,
 	 * though - we need to synchronise with previous and future commits so
 	 * that the commit records are correctly ordered in the log to ensure
@@ -798,7 +813,7 @@ xlog_cil_push_work(
 	 * deferencing a freed context pointer.
 	 */
 	spin_lock(&cil->xc_push_lock);
-	cil->xc_current_sequence = new_ctx->sequence;
+	xlog_cil_ctx_switch(cil, new_ctx);
 	spin_unlock(&cil->xc_push_lock);
 	up_write(&cil->xc_ctx_lock);
 
@@ -970,7 +985,7 @@ xlog_cil_push_background(
 	spin_lock(&cil->xc_push_lock);
 	if (cil->xc_push_seq < cil->xc_current_sequence) {
 		cil->xc_push_seq = cil->xc_current_sequence;
-		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
+		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_ctx->push_work);
 	}
 
 	/*
@@ -1036,7 +1051,7 @@ xlog_cil_push_now(
 
 	/* start on any pending background push to minimise wait time on it */
 	if (!async)
-		flush_work(&cil->xc_push_work);
+		flush_workqueue(log->l_mp->m_cil_workqueue);
 
 	/*
 	 * If the CIL is empty or we've already pushed the sequence then
@@ -1050,7 +1065,7 @@ xlog_cil_push_now(
 
 	cil->xc_push_seq = push_seq;
 	cil->xc_push_commit_stable = async;
-	queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
+	queue_work(log->l_mp->m_cil_workqueue, &cil->xc_ctx->push_work);
 	spin_unlock(&cil->xc_push_lock);
 }
 
@@ -1290,13 +1305,6 @@ xlog_cil_init(
 	if (!cil)
 		return -ENOMEM;
 
-	ctx = kmem_zalloc(sizeof(*ctx), KM_MAYFAIL);
-	if (!ctx) {
-		kmem_free(cil);
-		return -ENOMEM;
-	}
-
-	INIT_WORK(&cil->xc_push_work, xlog_cil_push_work);
 	INIT_LIST_HEAD(&cil->xc_cil);
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
@@ -1304,16 +1312,12 @@ xlog_cil_init(
 	init_waitqueue_head(&cil->xc_push_wait);
 	init_rwsem(&cil->xc_ctx_lock);
 	init_waitqueue_head(&cil->xc_commit_wait);
-
-	INIT_LIST_HEAD(&ctx->committing);
-	INIT_LIST_HEAD(&ctx->busy_extents);
-	ctx->sequence = 1;
-	ctx->cil = cil;
-	cil->xc_ctx = ctx;
-	cil->xc_current_sequence = ctx->sequence;
-
 	cil->xc_log = log;
 	log->l_cilp = cil;
+
+	ctx = xlog_cil_ctx_alloc();
+	xlog_cil_ctx_switch(cil, ctx);
+
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index a863ccb5ece6..87447fa34c43 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -245,6 +245,7 @@ struct xfs_cil_ctx {
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
 	struct work_struct	discard_endio_work;
+	struct work_struct	push_work;
 };
 
 /*
@@ -277,7 +278,6 @@ struct xfs_cil {
 	struct list_head	xc_committing;
 	wait_queue_head_t	xc_commit_wait;
 	xfs_csn_t		xc_current_sequence;
-	struct work_struct	xc_push_work;
 	wait_queue_head_t	xc_push_wait;	/* background push throttle */
 } ____cacheline_aligned_in_smp;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e339d1de2419..0608091f13a6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -501,9 +501,13 @@ xfs_init_mount_workqueues(
 	if (!mp->m_unwritten_workqueue)
 		goto out_destroy_buf;
 
+	/*
+	 * Limit the CIL pipeline depth to 4 concurrent works to bound the
+	 * concurrency the log spinlocks will be exposed to.
+	 */
 	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
 			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
-			0, mp->m_super->s_id);
+			4, mp->m_super->s_id);
 	if (!mp->m_cil_workqueue)
 		goto out_destroy_unwritten;
 
-- 
2.31.1

