Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F3958E3AA
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Aug 2022 01:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiHIXWH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Aug 2022 19:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiHIXWG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 19:22:06 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 96B9A6C11C
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 16:22:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-193-158.pa.nsw.optusnet.com.au [49.181.193.158])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 2F22B62D55D
        for <linux-xfs@vger.kernel.org>; Wed, 10 Aug 2022 09:22:03 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oLYGR-00BDIB-F9
        for linux-xfs@vger.kernel.org; Wed, 10 Aug 2022 09:03:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1oLYGR-00E4WY-E3
        for linux-xfs@vger.kernel.org;
        Wed, 10 Aug 2022 09:03:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/9] xfs: track log space pinned by the AIL
Date:   Wed, 10 Aug 2022 09:03:51 +1000
Message-Id: <20220809230353.3353059-8-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220809230353.3353059-1-david@fromorbit.com>
References: <20220809230353.3353059-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62f2ec1b
        a=SeswVvpAPK2RnNNwqI8AaA==:117 a=SeswVvpAPK2RnNNwqI8AaA==:17
        a=biHskzXt2R4A:10 a=20KFwNOVAAAA:8 a=AiggxmNAUnl-ojpyyKIA:9
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Currently we track space used in the log by grant heads.
These store the reserved space as a physical log location and
combine both space reserved for future use with space already used in
the log in a single variable. The amount of space consumed in the
log is then calculated as the  distance between the log tail and
the grant head.

The problem with tracking the grant head as a physical location
comes from the fact that it tracks both log cycle count and offset
into the log in bytes in a single 64 bit variable. because the cycle
count on disk is a 32 bit number, this also limits the offset into
the log to 32 bits. ANd because that is in bytes, we are limited to
being able to track only 2GB of log space in the grant head.

Hence to support larger physical logs, we need to track used space
differently in the grant head. We no longer use the grant head for
guiding AIL pushing, so the only thing it is now used for is
determining if we've run out of reservation space via the
calculation in xlog_space_left().

What we really need to do is move the grant heads away from tracking
physical space in the log. The issue here is that space consumed in
the log is not directly tracked by the current mechanism - the
space consumed in the log by grant head reservations gets returned
to the free pool by the tail of the log moving forward. i.e. the
space isn't directly tracked or calculated, but the used grant space
gets "freed" as the physical limits of the log are updated without
actually needing to update the grant heads.

Hence to move away from implicit, zero-update log space tracking we
need to explicitly track the amount of physical space the log
actually consumes separately to the in-memory reservations for
operations that will be committed to the journal. Luckily, we
already track the information we need to calculate this in the AIL
itself.

That is, the space currently consumed by the journal is the maximum
LSN that the AIL has seen minus the current log tail. As we update
both of these items dynamically as the head and tail of the log
moves, we always know exactly how much space the journal consumes.

This means that we also know exactly how much space the currently
active reservations require, and exactly how much free space we have
remaining for new reservations to be made. Most importantly, we know
what these spaces are indepedently of the physical locations of
the head and tail of the log.

Hence by separating out the physical space consumed by the journal,
we can now track reservations in the grant heads purely as a byte
count, and the log can be considered full when the tail space +
reservation space exceeds the size of the log. This means we can use
the full 64 bits of grant head space for reservation space,
completely removing the 32 bit byte count limitation on log size
that they impose.

Hence the first step in this conversion is to track and update the
"log tail space" every time the AIL tail or maximum seen LSN
changes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c   | 9 ++++++---
 fs/xfs/xfs_log_priv.h  | 1 +
 fs/xfs/xfs_trans_ail.c | 9 ++++++---
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 843764d40232..e482ae9fc01c 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -761,14 +761,17 @@ xlog_cil_ail_insert(
 	 * always be the same (as iclogs can contain multiple commit records) or
 	 * higher LSN than the current head. We do this before insertion of the
 	 * items so that log space checks during insertion will reflect the
-	 * space that this checkpoint has already consumed.
+	 * space that this checkpoint has already consumed.  We call
+	 * xfs_ail_update_finish() so that tail space and space-based wakeups
+	 * will be recalculated appropriately.
 	 */
 	ASSERT(XFS_LSN_CMP(ctx->commit_lsn, ailp->ail_head_lsn) >= 0 ||
 			aborted);
 	spin_lock(&ailp->ail_lock);
-	ailp->ail_head_lsn = ctx->commit_lsn;
 	xfs_trans_ail_cursor_last(ailp, &cur, ctx->start_lsn);
-	spin_unlock(&ailp->ail_lock);
+	ailp->ail_head_lsn = ctx->commit_lsn;
+	/* xfs_ail_update_finish() drops the ail_lock */
+	xfs_ail_update_finish(ailp, NULLCOMMITLSN);
 
 	/* unpin all the log items */
 	list_for_each_entry(lv, &ctx->lv_chain, lv_list) {
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 5f4358f18224..8a005cb08a02 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -435,6 +435,7 @@ struct xlog {
 
 	struct xlog_grant_head	l_reserve_head;
 	struct xlog_grant_head	l_write_head;
+	uint64_t		l_tail_space;
 
 	struct xfs_kobj		l_kobj;
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index fe3f8b80e687..5d0ddd6d68e9 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -731,6 +731,8 @@ __xfs_ail_assign_tail_lsn(
 	if (!tail_lsn)
 		tail_lsn = ailp->ail_head_lsn;
 
+	WRITE_ONCE(log->l_tail_space,
+			xlog_lsn_sub(log, ailp->ail_head_lsn, tail_lsn));
 	trace_xfs_log_assign_tail_lsn(log, tail_lsn);
 	atomic64_set(&log->l_tail_lsn, tail_lsn);
 }
@@ -738,9 +740,10 @@ __xfs_ail_assign_tail_lsn(
 /*
  * Callers should pass the the original tail lsn so that we can detect if the
  * tail has moved as a result of the operation that was performed. If the caller
- * needs to force a tail LSN update, it should pass NULLCOMMITLSN to bypass the
- * "did the tail LSN change?" checks. If the caller wants to avoid a tail update
- * (e.g. it knows the tail did not change) it should pass an @old_lsn of 0.
+ * needs to force a tail space update, it should pass NULLCOMMITLSN to bypass
+ * the "did the tail LSN change?" checks. If the caller wants to avoid a tail
+ * update (e.g. it knows the tail did not change) it should pass an @old_lsn of
+ * 0.
  */
 void
 xfs_ail_update_finish(
-- 
2.36.1

