Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368406529D0
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Dec 2022 00:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiLTXXZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 20 Dec 2022 18:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiLTXXT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 18:23:19 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E1910DA
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:17 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u7so5634856plq.11
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fuZEqVlxpSn9sX+UcYKr1kC6HlS28V4I6PWxHtEA2cI=;
        b=g1NYrpZVyoysA3EHoOfj3JiBqQt2fKRYevhhSrM5RITH+5mFruGJH3k2wOhqF65XjJ
         b4v2fng8yvGdZAiDXw6XooEXy4vARLqOqK4ibMsh8iMa5de6pENWwjqWRaW7Sj8i0yC0
         m3OWR3ZME/MjgMFvV4bFEY6YmXlP7la/4oaUdFXMExthiiPIxLOgYaRC9T4boibsvoGO
         idM2Mwkf2wZT5rK4W9U7YvnTZFzmh57qC5BdTQf07TF8cCVsogsae0n8zU/yXNmk+s3k
         NZxH0MKtRDyzW0heABwdXb42XUjdOdduZDBpSwLf3UAiJkqPXgUEIRhLDYFYAmv/1YSZ
         +7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fuZEqVlxpSn9sX+UcYKr1kC6HlS28V4I6PWxHtEA2cI=;
        b=NlwCjJAqLf0qoCimyZOfMTjE0mfrI5AGdZsyiy1lh1c1qOoKbFxCruAqYOU4HLct7a
         n9ypUnAlGfIW3nAIo+URYYQDOzVKurjiCjOpO5gnTllEgbv0wGELHgC+neBiVFD7wOkS
         NYxZ2SbensdjBvjYH+sw/rOS0DYawYEVPjCKb8sk40aJPU5f4T6AXlj0L4HfedAkEvid
         EPQZer0Sr5Qb/9n0we7MnWOGVXDeA40K98xedwCiSL0RBz3/cVYQFwi4LXsgeIwkLPLt
         EBXxsWekzAeDm/WN5scEmtAExWBxscUUGSklnGzYb91bpF8zx/hVHZ2dzDI/5IVCdfUD
         9+oA==
X-Gm-Message-State: AFqh2kr8XC87Ot01+zIAejGiAoQne+T6bNezjB/mSCzkkxTb7fiCMFNX
        RCMfri7euHad4G1UplQl0EENvqnWIqZZ6vMt
X-Google-Smtp-Source: AMrXdXvk+BGCxInVasB2id03YfkDbsXasCKfMSvADPyynH6YUbiO1iVu6vg42lh58X+FoVmWGvjA/Q==
X-Received: by 2002:a17:902:f68d:b0:191:3f74:47a6 with SMTP id l13-20020a170902f68d00b001913f7447a6mr3920074plg.60.1671578596551;
        Tue, 20 Dec 2022 15:23:16 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902d2c900b00176b84eb29asm9870461plc.301.2022.12.20.15.23.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 15:23:14 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1p7lx1-00Asnj-Bu
        for linux-xfs@vger.kernel.org; Wed, 21 Dec 2022 10:23:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1p7lx1-00Ec6T-17
        for linux-xfs@vger.kernel.org;
        Wed, 21 Dec 2022 10:23:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 9/9] xfs: grant heads track byte counts, not LSNs
Date:   Wed, 21 Dec 2022 10:23:08 +1100
Message-Id: <20221220232308.3482960-10-david@fromorbit.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221220232308.3482960-1-david@fromorbit.com>
References: <20221220232308.3482960-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The grant heads in the log track the space reserved in the log for
running transactions. They do this by tracking how far ahead of the
tail that the reservation has reached, and the units for doing this
are {cycle,bytes} for the reserve head rather than {cycle,blocks}
which are normal used by LSNs.

This is annoyingly complex because we have to split, crack and
combined these tuples for any calculation we do to determine log
space and targets. This is computationally expensive as well as
difficult to do atomically and locklessly, as well as limiting the
size of the log to 2^32 bytes.

Really, though, all the grant heads are tracking is how much space
is currently available for use in the log. We can track this as a
simply byte count - we just don't care what the actual physical
location in the log the head and tail are at, just how much space we
have remaining before the head and tail overlap.

So, convert the grant heads to track the byte reservations that are
active rather than the current (cycle, offset) tuples. This means an
empty log has zero bytes consumed, and a full log is when the the
reservations reach the size of the log minus the space consumed by
the AIL.

This greatly simplifies the accounting and checks for whether there
is space available. We no longer need to crack or combine LSNs to
determine how much space the log has left, nor do we need to look at
the head or tail of the log to determine how close to full we are.

There is, however, a complexity that needs to be handled. We know
how much space is being tracked in the AIL now via log->l_tail_space
and the log tickets track active reservations and return the unused
portions to the grant heads when ungranted.  Unfortunately, we don't
track the used portion of the grant, so when we transfer log items
from the CIL to the AIL, the space accounted to the grant heads is
transferred to the log tail space.  Hence when we move the AIL head
forwards on item insert, we have to remove that space from the grant
heads.

We also remove the xlog_verify_grant_tail() debug function as it is
no longer useful. The check it performs has been racy since delayed
logging was introduced, but now it is clearly only detecting false
positives so remove it.

The result of this substantially simpler accounting algorithm is an
increase in sustained transaction rate from ~1.3 million
transactions/s to ~1.9 million transactions/s with no increase in
CPU usage. We also remove the 32 bit space limitation on the grant
heads, which will allow us to increase the journal size beyond 2GB
in future.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c         | 205 ++++++++++++---------------------------
 fs/xfs/xfs_log_cil.c     |  12 +++
 fs/xfs/xfs_log_priv.h    |  45 +++------
 fs/xfs/xfs_log_recover.c |   4 -
 fs/xfs/xfs_sysfs.c       |  17 ++--
 fs/xfs/xfs_trace.h       |  33 ++++---
 6 files changed, 113 insertions(+), 203 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 677636653d39..8f8cb5153dd4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -53,9 +53,6 @@ xlog_sync(
 	struct xlog_ticket	*ticket);
 #if defined(DEBUG)
 STATIC void
-xlog_verify_grant_tail(
-	struct xlog *log);
-STATIC void
 xlog_verify_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
@@ -65,7 +62,6 @@ xlog_verify_tail_lsn(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog);
 #else
-#define xlog_verify_grant_tail(a)
 #define xlog_verify_iclog(a,b,c)
 #define xlog_verify_tail_lsn(a,b)
 #endif
@@ -133,30 +129,13 @@ xlog_prepare_iovec(
 	return buf;
 }
 
-static void
+void
 xlog_grant_sub_space(
 	struct xlog		*log,
 	struct xlog_grant_head	*head,
 	int			bytes)
 {
-	int64_t	head_val = atomic64_read(&head->grant);
-	int64_t new, old;
-
-	do {
-		int	cycle, space;
-
-		xlog_crack_grant_head_val(head_val, &cycle, &space);
-
-		space -= bytes;
-		if (space < 0) {
-			space += log->l_logsize;
-			cycle--;
-		}
-
-		old = head_val;
-		new = xlog_assign_grant_head_val(cycle, space);
-		head_val = atomic64_cmpxchg(&head->grant, old, new);
-	} while (head_val != old);
+	atomic64_sub(bytes, &head->grant);
 }
 
 static void
@@ -165,93 +144,39 @@ xlog_grant_add_space(
 	struct xlog_grant_head	*head,
 	int			bytes)
 {
-	int64_t	head_val = atomic64_read(&head->grant);
-	int64_t new, old;
-
-	do {
-		int		tmp;
-		int		cycle, space;
-
-		xlog_crack_grant_head_val(head_val, &cycle, &space);
-
-		tmp = log->l_logsize - space;
-		if (tmp > bytes)
-			space += bytes;
-		else {
-			space = bytes - tmp;
-			cycle++;
-		}
-
-		old = head_val;
-		new = xlog_assign_grant_head_val(cycle, space);
-		head_val = atomic64_cmpxchg(&head->grant, old, new);
-	} while (head_val != old);
+	atomic64_add(bytes, &head->grant);
 }
 
-STATIC void
+static void
 xlog_grant_head_init(
 	struct xlog_grant_head	*head)
 {
-	xlog_assign_grant_head(&head->grant, 1, 0);
+	atomic64_set(&head->grant, 0);
 	INIT_LIST_HEAD(&head->waiters);
 	spin_lock_init(&head->lock);
 }
 
 /*
- * Return the space in the log between the tail and the head.  The head
- * is passed in the cycle/bytes formal parms.  In the special case where
- * the reserve head has wrapped passed the tail, this calculation is no
- * longer valid.  In this case, just return 0 which means there is no space
- * in the log.  This works for all places where this function is called
- * with the reserve head.  Of course, if the write head were to ever
- * wrap the tail, we should blow up.  Rather than catch this case here,
- * we depend on other ASSERTions in other parts of the code.   XXXmiken
- *
- * If reservation head is behind the tail, we have a problem. Warn about it,
- * but then treat it as if the log is empty.
- *
- * If the log is shut down, the head and tail may be invalid or out of whack, so
- * shortcut invalidity asserts in this case so that we don't trigger them
- * falsely.
+ * Return the space in the log between the tail and the head.  In the case where
+ * we have overrun available reservation space, return 0. The memory barrier
+ * pairs with the smp_wmb() in xlog_cil_ail_insert() to ensure that grant head
+ * vs tail space updates are seen in the correct order and hence avoid
+ * transients as space is transferred from the grant heads to the AIL on commit
+ * completion.
  */
-static int
+static uint64_t
 xlog_grant_space_left(
 	struct xlog		*log,
 	struct xlog_grant_head	*head)
 {
-	int			tail_bytes;
-	int			tail_cycle;
-	int			head_cycle;
-	int			head_bytes;
-
-	xlog_crack_grant_head(&head->grant, &head_cycle, &head_bytes);
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_bytes);
-	tail_bytes = BBTOB(tail_bytes);
-	if (tail_cycle == head_cycle && head_bytes >= tail_bytes)
-		return log->l_logsize - (head_bytes - tail_bytes);
-	if (tail_cycle + 1 < head_cycle)
-		return 0;
-
-	/* Ignore potential inconsistency when shutdown. */
-	if (xlog_is_shutdown(log))
-		return log->l_logsize;
-
-	if (tail_cycle < head_cycle) {
-		ASSERT(tail_cycle == (head_cycle - 1));
-		return tail_bytes - head_bytes;
-	}
+	int64_t			free_bytes;
 
-	/*
-	 * The reservation head is behind the tail. In this case we just want to
-	 * return the size of the log as the amount of space left.
-	 */
-	xfs_alert(log->l_mp, "xlog_grant_space_left: head behind tail");
-	xfs_alert(log->l_mp, "  tail_cycle = %d, tail_bytes = %d",
-		  tail_cycle, tail_bytes);
-	xfs_alert(log->l_mp, "  GH   cycle = %d, GH   bytes = %d",
-		  head_cycle, head_bytes);
-	ASSERT(0);
-	return log->l_logsize;
+	smp_rmb();	// paired with smp_wmb in xlog_cil_ail_insert()
+	free_bytes = log->l_logsize - READ_ONCE(log->l_tail_space) -
+			atomic64_read(&head->grant);
+	if (free_bytes > 0)
+		return free_bytes;
+	return 0;
 }
 
 STATIC void
@@ -455,7 +380,6 @@ xfs_log_regrant(
 
 	xlog_grant_add_space(log, &log->l_write_head, need_bytes);
 	trace_xfs_log_regrant_exit(log, tic);
-	xlog_verify_grant_tail(log);
 	return 0;
 
 out_error:
@@ -507,7 +431,6 @@ xfs_log_reserve(
 	xlog_grant_add_space(log, &log->l_reserve_head, need_bytes);
 	xlog_grant_add_space(log, &log->l_write_head, need_bytes);
 	trace_xfs_log_reserve_exit(log, tic);
-	xlog_verify_grant_tail(log);
 	return 0;
 
 out_error:
@@ -3367,42 +3290,27 @@ xlog_ticket_alloc(
 }
 
 #if defined(DEBUG)
-/*
- * Check to make sure the grant write head didn't just over lap the tail.  If
- * the cycles are the same, we can't be overlapping.  Otherwise, make sure that
- * the cycles differ by exactly one and check the byte count.
- *
- * This check is run unlocked, so can give false positives. Rather than assert
- * on failures, use a warn-once flag and a panic tag to allow the admin to
- * determine if they want to panic the machine when such an error occurs. For
- * debug kernels this will have the same effect as using an assert but, unlinke
- * an assert, it can be turned off at runtime.
- */
-STATIC void
-xlog_verify_grant_tail(
-	struct xlog	*log)
+static void
+xlog_verify_dump_tail(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog)
 {
-	int		tail_cycle, tail_blocks;
-	int		cycle, space;
-
-	xlog_crack_grant_head(&log->l_write_head.grant, &cycle, &space);
-	xlog_crack_atomic_lsn(&log->l_tail_lsn, &tail_cycle, &tail_blocks);
-	if (tail_cycle != cycle) {
-		if (cycle - 1 != tail_cycle &&
-		    !test_and_set_bit(XLOG_TAIL_WARN, &log->l_opstate)) {
-			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
-				"%s: cycle - 1 != tail_cycle", __func__);
-		}
-
-		if (space > BBTOB(tail_blocks) &&
-		    !test_and_set_bit(XLOG_TAIL_WARN, &log->l_opstate)) {
-			xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
-				"%s: space > BBTOB(tail_blocks)", __func__);
-		}
-	}
-}
-
-/* check if it will fit */
+	xfs_alert(log->l_mp,
+"ran out of log space tail 0x%llx/0x%llx, head lsn 0x%llx, head 0x%x/0x%x, prev head 0x%x/0x%x",
+			iclog ? be64_to_cpu(iclog->ic_header.h_tail_lsn) : -1,
+			atomic64_read(&log->l_tail_lsn),
+			log->l_ailp->ail_head_lsn,
+			log->l_curr_cycle, log->l_curr_block,
+			log->l_prev_cycle, log->l_prev_block);
+	xfs_alert(log->l_mp,
+"write grant 0x%llx, reserve grant 0x%llx, tail_space 0x%llx, size 0x%x, iclog flags 0x%x",
+			atomic64_read(&log->l_write_head.grant),
+			atomic64_read(&log->l_reserve_head.grant),
+			log->l_tail_space, log->l_logsize,
+			iclog ? iclog->ic_flags : -1);
+}
+
+/* Check if the new iclog will fit in the log. */
 STATIC void
 xlog_verify_tail_lsn(
 	struct xlog		*log,
@@ -3411,21 +3319,34 @@ xlog_verify_tail_lsn(
 	xfs_lsn_t	tail_lsn = be64_to_cpu(iclog->ic_header.h_tail_lsn);
 	int		blocks;
 
-    if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
-	blocks =
-	    log->l_logBBsize - (log->l_prev_block - BLOCK_LSN(tail_lsn));
-	if (blocks < BTOBB(iclog->ic_offset)+BTOBB(log->l_iclog_hsize))
-		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
-    } else {
-	ASSERT(CYCLE_LSN(tail_lsn)+1 == log->l_prev_cycle);
+	if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
+		blocks = log->l_logBBsize -
+				(log->l_prev_block - BLOCK_LSN(tail_lsn));
+		if (blocks < BTOBB(iclog->ic_offset) +
+					BTOBB(log->l_iclog_hsize)) {
+			xfs_emerg(log->l_mp,
+					"%s: ran out of log space", __func__);
+			xlog_verify_dump_tail(log, iclog);
+		}
+		return;
+	}
 
-	if (BLOCK_LSN(tail_lsn) == log->l_prev_block)
+	if (CYCLE_LSN(tail_lsn) + 1 != log->l_prev_cycle) {
+		xfs_emerg(log->l_mp, "%s: head has wrapped tail.", __func__);
+		xlog_verify_dump_tail(log, iclog);
+		return;
+	}
+	if (BLOCK_LSN(tail_lsn) == log->l_prev_block) {
 		xfs_emerg(log->l_mp, "%s: tail wrapped", __func__);
+		xlog_verify_dump_tail(log, iclog);
+		return;
+	}
 
 	blocks = BLOCK_LSN(tail_lsn) - log->l_prev_block;
-	if (blocks < BTOBB(iclog->ic_offset) + 1)
-		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
-    }
+	if (blocks < BTOBB(iclog->ic_offset) + 1) {
+		xfs_emerg(log->l_mp, "%s: ran out of iclog space", __func__);
+		xlog_verify_dump_tail(log, iclog);
+	}
 }
 
 /*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b294e349798c..68fcb2a2430d 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -753,6 +753,7 @@ xlog_cil_ail_insert(
 	struct xfs_log_item	*log_items[LOG_ITEM_BATCH_SIZE];
 	struct xfs_log_vec	*lv;
 	struct xfs_ail_cursor	cur;
+	xfs_lsn_t		old_head;
 	int			i = 0;
 
 	/*
@@ -769,10 +770,21 @@ xlog_cil_ail_insert(
 			aborted);
 	spin_lock(&ailp->ail_lock);
 	xfs_trans_ail_cursor_last(ailp, &cur, ctx->start_lsn);
+	old_head = ailp->ail_head_lsn;
 	ailp->ail_head_lsn = ctx->commit_lsn;
 	/* xfs_ail_update_finish() drops the ail_lock */
 	xfs_ail_update_finish(ailp, NULLCOMMITLSN);
 
+	/*
+	 * We move the AIL head forwards to account for the space used in the
+	 * log before we remove that space from the grant heads. This prevents a
+	 * transient condition where reservation space appears to become
+	 * available on return, only for it to disappear again immediately as
+	 * the AIL head update accounts in the log tail space.
+	 */
+	smp_wmb();	// paired with smp_rmb in xlog_grant_space_left
+	xlog_grant_return_space(ailp->ail_log, old_head, ailp->ail_head_lsn);
+
 	/* unpin all the log items */
 	list_for_each_entry(lv, &ctx->lv_chain, lv_list) {
 		struct xfs_log_item	*lip = lv->lv_item;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 86b5959b5ef2..c7ae9172dcd9 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -541,36 +541,6 @@ xlog_assign_atomic_lsn(atomic64_t *lsn, uint cycle, uint block)
 	atomic64_set(lsn, xlog_assign_lsn(cycle, block));
 }
 
-/*
- * When we crack the grant head, we sample it first so that the value will not
- * change while we are cracking it into the component values. This means we
- * will always get consistent component values to work from.
- */
-static inline void
-xlog_crack_grant_head_val(int64_t val, int *cycle, int *space)
-{
-	*cycle = val >> 32;
-	*space = val & 0xffffffff;
-}
-
-static inline void
-xlog_crack_grant_head(atomic64_t *head, int *cycle, int *space)
-{
-	xlog_crack_grant_head_val(atomic64_read(head), cycle, space);
-}
-
-static inline int64_t
-xlog_assign_grant_head_val(int cycle, int space)
-{
-	return ((int64_t)cycle << 32) | space;
-}
-
-static inline void
-xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
-{
-	atomic64_set(head, xlog_assign_grant_head_val(cycle, space));
-}
-
 /*
  * Committed Item List interfaces
  */
@@ -636,6 +606,21 @@ xlog_lsn_sub(
 	return (uint64_t)log->l_logsize - BBTOB(lo_block - hi_block);
 }
 
+void	xlog_grant_sub_space(struct xlog *log, struct xlog_grant_head *head,
+			int bytes);
+
+static inline void
+xlog_grant_return_space(
+	struct xlog	*log,
+	xfs_lsn_t	old_head,
+	xfs_lsn_t	new_head)
+{
+	int64_t		diff = xlog_lsn_sub(log, new_head, old_head);
+
+	xlog_grant_sub_space(log, &log->l_reserve_head, diff);
+	xlog_grant_sub_space(log, &log->l_write_head, diff);
+}
+
 /*
  * The LSN is valid so long as it is behind the current LSN. If it isn't, this
  * means that the next log record that includes this metadata could have a
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e6ec901e7775..d1f15a38940f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1213,10 +1213,6 @@ xlog_set_state(
 		log->l_curr_cycle++;
 	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
 	log->l_ailp->ail_head_lsn = be64_to_cpu(rhead->h_lsn);
-	xlog_assign_grant_head(&log->l_reserve_head.grant, log->l_curr_cycle,
-					BBTOB(log->l_curr_block));
-	xlog_assign_grant_head(&log->l_write_head.grant, log->l_curr_cycle,
-					BBTOB(log->l_curr_block));
 }
 
 /*
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index f7faf6e70d7f..0b19acea28cb 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -376,14 +376,11 @@ STATIC ssize_t
 reserve_grant_head_show(
 	struct kobject	*kobject,
 	char		*buf)
-
 {
-	int cycle;
-	int bytes;
-	struct xlog *log = to_xlog(kobject);
+	struct xlog	*log = to_xlog(kobject);
+	uint64_t	bytes = atomic64_read(&log->l_reserve_head.grant);
 
-	xlog_crack_grant_head(&log->l_reserve_head.grant, &cycle, &bytes);
-	return sysfs_emit(buf, "%d:%d\n", cycle, bytes);
+	return sysfs_emit(buf, "%lld\n", bytes);
 }
 XFS_SYSFS_ATTR_RO(reserve_grant_head);
 
@@ -392,12 +389,10 @@ write_grant_head_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
-	int cycle;
-	int bytes;
-	struct xlog *log = to_xlog(kobject);
+	struct xlog	*log = to_xlog(kobject);
+	uint64_t	bytes = atomic64_read(&log->l_write_head.grant);
 
-	xlog_crack_grant_head(&log->l_write_head.grant, &cycle, &bytes);
-	return sysfs_emit(buf, "%d:%d\n", cycle, bytes);
+	return sysfs_emit(buf, "%lld\n", bytes);
 }
 XFS_SYSFS_ATTR_RO(write_grant_head);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d2f52e370b60..649759602e1f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1209,6 +1209,7 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 	TP_ARGS(log, tic),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(unsigned long, tic)
 		__field(char, ocnt)
 		__field(char, cnt)
 		__field(int, curr_res)
@@ -1216,16 +1217,16 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__field(unsigned int, flags)
 		__field(int, reserveq)
 		__field(int, writeq)
-		__field(int, grant_reserve_cycle)
-		__field(int, grant_reserve_bytes)
-		__field(int, grant_write_cycle)
-		__field(int, grant_write_bytes)
+		__field(uint64_t, grant_reserve_bytes)
+		__field(uint64_t, grant_write_bytes)
+		__field(uint64_t, tail_space)
 		__field(int, curr_cycle)
 		__field(int, curr_block)
 		__field(xfs_lsn_t, tail_lsn)
 	),
 	TP_fast_assign(
 		__entry->dev = log->l_mp->m_super->s_dev;
+		__entry->tic = (unsigned long)tic;
 		__entry->ocnt = tic->t_ocnt;
 		__entry->cnt = tic->t_cnt;
 		__entry->curr_res = tic->t_curr_res;
@@ -1233,23 +1234,23 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		__entry->flags = tic->t_flags;
 		__entry->reserveq = list_empty(&log->l_reserve_head.waiters);
 		__entry->writeq = list_empty(&log->l_write_head.waiters);
-		xlog_crack_grant_head(&log->l_reserve_head.grant,
-				&__entry->grant_reserve_cycle,
-				&__entry->grant_reserve_bytes);
-		xlog_crack_grant_head(&log->l_write_head.grant,
-				&__entry->grant_write_cycle,
-				&__entry->grant_write_bytes);
+		__entry->tail_space = READ_ONCE(log->l_tail_space);
+		__entry->grant_reserve_bytes = __entry->tail_space +
+			atomic64_read(&log->l_reserve_head.grant);
+		__entry->grant_write_bytes = __entry->tail_space +
+			atomic64_read(&log->l_write_head.grant);
 		__entry->curr_cycle = log->l_curr_cycle;
 		__entry->curr_block = log->l_curr_block;
 		__entry->tail_lsn = atomic64_read(&log->l_tail_lsn);
 	),
-	TP_printk("dev %d:%d t_ocnt %u t_cnt %u t_curr_res %u "
+	TP_printk("dev %d:%d tic 0x%lx t_ocnt %u t_cnt %u t_curr_res %u "
 		  "t_unit_res %u t_flags %s reserveq %s "
-		  "writeq %s grant_reserve_cycle %d "
-		  "grant_reserve_bytes %d grant_write_cycle %d "
-		  "grant_write_bytes %d curr_cycle %d curr_block %d "
+		  "writeq %s "
+		  "tail space %llu grant_reserve_bytes %llu "
+		  "grant_write_bytes %llu curr_cycle %d curr_block %d "
 		  "tail_cycle %d tail_block %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->tic,
 		  __entry->ocnt,
 		  __entry->cnt,
 		  __entry->curr_res,
@@ -1257,9 +1258,8 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 		  __print_flags(__entry->flags, "|", XLOG_TIC_FLAGS),
 		  __entry->reserveq ? "empty" : "active",
 		  __entry->writeq ? "empty" : "active",
-		  __entry->grant_reserve_cycle,
+		  __entry->tail_space,
 		  __entry->grant_reserve_bytes,
-		  __entry->grant_write_cycle,
 		  __entry->grant_write_bytes,
 		  __entry->curr_cycle,
 		  __entry->curr_block,
@@ -1287,6 +1287,7 @@ DEFINE_LOGGRANT_EVENT(xfs_log_ticket_ungrant);
 DEFINE_LOGGRANT_EVENT(xfs_log_ticket_ungrant_sub);
 DEFINE_LOGGRANT_EVENT(xfs_log_ticket_ungrant_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_cil_wait);
+DEFINE_LOGGRANT_EVENT(xfs_log_cil_return);
 
 DECLARE_EVENT_CLASS(xfs_log_item_class,
 	TP_PROTO(struct xfs_log_item *lip),
-- 
2.38.1

