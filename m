Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE61C388DC4
	for <lists+linux-xfs@lfdr.de>; Wed, 19 May 2021 14:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239598AbhESMOw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 19 May 2021 08:14:52 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:49009 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353398AbhESMOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:45 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id E7C091AFDE7
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002m1i-Et
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002SHn-7D
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 28/39] xfs: rework per-iclog header CIL reservation
Date:   Wed, 19 May 2021 22:13:06 +1000
Message-Id: <20210519121317.585244-29-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=qEEhvzcIvicejZNefQMA:9
        a=i2n7kevwJ6R4lag6:21 a=1JLYaXtgG_pBa2v3:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

For every iclog that a CIL push will use up, we need to ensure we
have space reserved for the iclog header in each iclog. It is
extremely difficult to do this accurately with a per-cpu counter
without expensive summing of the counter in every commit. However,
we know what the maximum CIL size is going to be because of the
hard space limit we have, and hence we know exactly how many iclogs
we are going to need to write out the CIL.

We are constrained by the requirement that small transactions only
have reservation space for a single iclog header built into them.
At commit time we don't know how much of the current transaction
reservation is made up of iclog header reservations as calculated by
xfs_log_calc_unit_res() when the ticket was reserved. As larger
reservations have multiple header spaces reserved, we can steal
more than one iclog header reservation at a time, but we only steal
the exact number needed for the given log vector size delta.

As a result, we don't know exactly when we are going to steal iclog
header reservations, nor do we know exactly how many we are going to
need for a given CIL.

To make things simple, start by calculating the worst case number of
iclog headers a full CIL push will require. Record this into an
atomic variable in the CIL. Then add a byte counter to the log
ticket that records exactly how much iclog header space has been
reserved in this ticket by xfs_log_calc_unit_res(). This tells us
exactly how much space we can steal from the ticket at transaction
commit time.

Now, at transaction commit time, we can check if the CIL has a full
iclog header reservation and, if not, steal the entire reservation
the current ticket holds for iclog headers. This minimises the
number of times we need to do atomic operations in the fast path,
but still guarantees we get all the reservations we need.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      |  9 ++++---
 fs/xfs/xfs_log_cil.c  | 55 +++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_log_priv.h | 20 +++++++++-------
 3 files changed, 59 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 65b28fce4db4..77d9ea7daf26 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3307,7 +3307,8 @@ xfs_log_ticket_get(
 static int
 xlog_calc_unit_res(
 	struct xlog		*log,
-	int			unit_bytes)
+	int			unit_bytes,
+	int			*niclogs)
 {
 	int			iclog_space;
 	uint			num_headers;
@@ -3387,6 +3388,8 @@ xlog_calc_unit_res(
 	/* roundoff padding for transaction data and one for commit record */
 	unit_bytes += 2 * log->l_iclog_roundoff;
 
+	if (niclogs)
+		*niclogs = num_headers;
 	return unit_bytes;
 }
 
@@ -3395,7 +3398,7 @@ xfs_log_calc_unit_res(
 	struct xfs_mount	*mp,
 	int			unit_bytes)
 {
-	return xlog_calc_unit_res(mp->m_log, unit_bytes);
+	return xlog_calc_unit_res(mp->m_log, unit_bytes, NULL);
 }
 
 /*
@@ -3413,7 +3416,7 @@ xlog_ticket_alloc(
 
 	tic = kmem_cache_zalloc(xfs_log_ticket_zone, GFP_NOFS | __GFP_NOFAIL);
 
-	unit_res = xlog_calc_unit_res(log, unit_bytes);
+	unit_res = xlog_calc_unit_res(log, unit_bytes, &tic->t_iclog_hdrs);
 
 	atomic_set(&tic->t_ref, 1);
 	tic->t_task		= current;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 4637f8711ada..87d4eb321fdc 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -44,9 +44,20 @@ xlog_cil_ticket_alloc(
 	 * transaction overhead reservation from the first transaction commit.
 	 */
 	tic->t_curr_res = 0;
+	tic->t_iclog_hdrs = 0;
 	return tic;
 }
 
+static inline void
+xlog_cil_set_iclog_hdr_count(struct xfs_cil *cil)
+{
+	struct xlog	*log = cil->xc_log;
+
+	atomic_set(&cil->xc_iclog_hdrs,
+		   (XLOG_CIL_BLOCKING_SPACE_LIMIT(log) /
+			(log->l_iclog_size - log->l_iclog_hsize)));
+}
+
 /*
  * Unavoidable forward declaration - xlog_cil_push_work() calls
  * xlog_cil_ctx_alloc() itself.
@@ -70,6 +81,7 @@ xlog_cil_ctx_switch(
 	struct xfs_cil		*cil,
 	struct xfs_cil_ctx	*ctx)
 {
+	xlog_cil_set_iclog_hdr_count(cil);
 	set_bit(XLOG_CIL_EMPTY, &cil->xc_flags);
 	ctx->sequence = ++cil->xc_current_sequence;
 	ctx->cil = cil;
@@ -92,6 +104,7 @@ xlog_cil_init_post_recovery(
 {
 	log->l_cilp->xc_ctx->ticket = xlog_cil_ticket_alloc(log);
 	log->l_cilp->xc_ctx->sequence = 1;
+	xlog_cil_set_iclog_hdr_count(log->l_cilp);
 }
 
 static inline int
@@ -419,7 +432,6 @@ xlog_cil_insert_items(
 	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
 	struct xfs_log_item	*lip;
 	int			len = 0;
-	int			iclog_space;
 	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
 
 	ASSERT(tp);
@@ -442,19 +454,36 @@ xlog_cil_insert_items(
 	    test_and_clear_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
 		ctx_res = ctx->ticket->t_unit_res;
 
-	spin_lock(&cil->xc_cil_lock);
-
-	/* do we need space for more log record headers? */
-	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
-	if (len > 0 && (ctx->space_used / iclog_space !=
-				(ctx->space_used + len) / iclog_space)) {
-		split_res = (len + iclog_space - 1) / iclog_space;
-		/* need to take into account split region headers, too */
-		split_res *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
-		ctx->ticket->t_unit_res += split_res;
+	/*
+	 * Check if we need to steal iclog headers. atomic_read() is not a
+	 * locked atomic operation, so we can check the value before we do any
+	 * real atomic ops in the fast path. If we've already taken the CIL unit
+	 * reservation from this commit, we've already got one iclog header
+	 * space reserved so we have to account for that otherwise we risk
+	 * overrunning the reservation on this ticket.
+	 *
+	 * If the CIL is already at the hard limit, we might need more header
+	 * space that originally reserved. So steal more header space from every
+	 * commit that occurs once we are over the hard limit to ensure the CIL
+	 * push won't run out of reservation space.
+	 *
+	 * This can steal more than we need, but that's OK.
+	 */
+	if (atomic_read(&cil->xc_iclog_hdrs) > 0 ||
+	    ctx->space_used + len >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
+		int	split_res = log->l_iclog_hsize +
+					sizeof(struct xlog_op_header);
+		if (ctx_res)
+			ctx_res += split_res * (tp->t_ticket->t_iclog_hdrs - 1);
+		else
+			ctx_res = split_res * tp->t_ticket->t_iclog_hdrs;
+		atomic_sub(tp->t_ticket->t_iclog_hdrs, &cil->xc_iclog_hdrs);
 	}
-	tp->t_ticket->t_curr_res -= split_res + ctx_res + len;
-	ctx->ticket->t_curr_res += split_res + ctx_res;
+
+	spin_lock(&cil->xc_cil_lock);
+	tp->t_ticket->t_curr_res -= ctx_res + len;
+	ctx->ticket->t_unit_res += ctx_res;
+	ctx->ticket->t_curr_res += ctx_res;
 	ctx->space_used += len;
 
 	/*
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 11606c378b7f..85a85ab569fe 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -137,15 +137,16 @@ enum xlog_iclog_state {
 #define XLOG_ICL_NEED_FUA	(1 << 1)	/* iclog needs REQ_FUA */
 
 typedef struct xlog_ticket {
-	struct list_head   t_queue;	 /* reserve/write queue */
-	struct task_struct *t_task;	 /* task that owns this ticket */
-	xlog_tid_t	   t_tid;	 /* transaction identifier	 : 4  */
-	atomic_t	   t_ref;	 /* ticket reference count       : 4  */
-	int		   t_curr_res;	 /* current reservation in bytes : 4  */
-	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
-	char		   t_ocnt;	 /* original count		 : 1  */
-	char		   t_cnt;	 /* current count		 : 1  */
-	char		   t_flags;	 /* properties of reservation	 : 1  */
+	struct list_head	t_queue;	/* reserve/write queue */
+	struct task_struct	*t_task;	/* task that owns this ticket */
+	xlog_tid_t		t_tid;		/* transaction identifier */
+	atomic_t		t_ref;		/* ticket reference count */
+	int			t_curr_res;	/* current reservation */
+	int			t_unit_res;	/* unit reservation */
+	char			t_ocnt;		/* original count */
+	char			t_cnt;		/* current count */
+	char			t_flags;	/* properties of reservation */
+	int			t_iclog_hdrs;	/* iclog hdrs in t_curr_res */
 } xlog_ticket_t;
 
 /*
@@ -245,6 +246,7 @@ struct xfs_cil_ctx {
 struct xfs_cil {
 	struct xlog		*xc_log;
 	unsigned long		xc_flags;
+	atomic_t		xc_iclog_hdrs;
 	struct list_head	xc_cil;
 	spinlock_t		xc_cil_lock;
 
-- 
2.31.1

