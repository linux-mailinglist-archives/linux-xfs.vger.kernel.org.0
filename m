Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D826BA79AA
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Sep 2019 06:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbfIDEY4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Sep 2019 00:24:56 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41185 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbfIDEY4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:24:56 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 84C5543E35B
        for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2019 14:24:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Mqj-0007Oc-3l
        for linux-xfs@vger.kernel.org; Wed, 04 Sep 2019 14:24:53 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Mqj-0002Ud-2R
        for linux-xfs@vger.kernel.org; Wed, 04 Sep 2019 14:24:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/7] xfs: push the grant head when the log head moves forward
Date:   Wed,  4 Sep 2019 14:24:51 +1000
Message-Id: <20190904042451.9314-8-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190904042451.9314-1-david@fromorbit.com>
References: <20190904042451.9314-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=J70Eh1EUuV4A:10 a=20KFwNOVAAAA:8
        a=7Q2-SO56R8pWWUt_uDsA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When the log fills up, we can get into the state where the
outstanding items in the CIL being committed and aggregated are
larger than the range that the reservation grant head tail pushing
will attempt to clean. This can result in the tail pushing range
being trimmed back to the the log head (l_last_sync_lsn) and so
may not actually move the push target at all.

When the iclogs associated with the CIL commit finally land, the
log head moves forward, and this removes the restriction on the AIL
push target. However, if we already have transactions sleeping on
the grant head, and there's nothing in the AIL still to flush from
the current push target, then nothing will move the tail of the log
and trigger a log reservation wakeup.

Hence the there is nothing that will trigger xlog_grant_push_ail()
to recalculate the AIL push target and start pushing on the AIL
again to write back the metadata objects that pin the tail of the
log and hence free up space and allow the transaction reservations
to be woken and make progress.

Hence we need to push on the grant head when we move the log head
forward, as this may be the only trigger we have that can move the
AIL push target forwards in this situation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 72 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6a59d71d4c60..733693e1ac9f 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2632,6 +2632,46 @@ xlog_get_lowest_lsn(
 	return lowest_lsn;
 }
 
+/*
+ * Completion of a iclog IO does not imply that a transaction has completed, as
+ * transactions can be large enough to span many iclogs. We cannot change the
+ * tail of the log half way through a transaction as this may be the only
+ * transaction in the log and moving the tail to point to the middle of it
+ * will prevent recovery from finding the start of the transaction. Hence we
+ * should only update the last_sync_lsn if this iclog contains transaction
+ * completion callbacks on it.
+ *
+ * We have to do this before we drop the icloglock to ensure we are the only one
+ * that can update it.
+ *
+ * If we are moving the last_sync_lsn forwards, we also need to ensure we kick
+ * the reservation grant head pushing. This is due to the fact that the push
+ * target is bound by the current last_sync_lsn value. Hence if we have a large
+ * amount of log space bound up in this committing transaction then the
+ * last_sync_lsn value may be the limiting factor preventing tail pushing from
+ * freeing space in the log. Hence once we've updated the last_sync_lsn we
+ * should push the AIL to ensure the push target (and hence the grant head) is
+ * no longer bound by the old log head location and can move forwards and make
+ * progress again.
+ */
+static void
+xlog_state_set_callback(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	xfs_lsn_t		header_lsn)
+{
+	iclog->ic_state = XLOG_STATE_CALLBACK;
+
+	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn), header_lsn) <= 0);
+
+	if (list_empty_careful(&iclog->ic_callbacks))
+		return;
+
+	atomic64_set(&log->l_last_sync_lsn, header_lsn);
+	xlog_grant_push_ail(log, 0);
+
+}
+
 /*
  * Return true if we need to stop processing, false to continue to the next
  * iclog. The caller will need to run callbacks if the iclog is returned in the
@@ -2644,6 +2684,7 @@ xlog_state_iodone_process_iclog(
 	struct xlog_in_core	*completed_iclog)
 {
 	xfs_lsn_t		lowest_lsn;
+	xfs_lsn_t		header_lsn;
 
 	/* Skip all iclogs in the ACTIVE & DIRTY states */
 	if (iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_DIRTY))
@@ -2681,34 +2722,15 @@ xlog_state_iodone_process_iclog(
 	 * callbacks) see the above if.
 	 *
 	 * We will do one more check here to see if we have chased our tail
-	 * around.
+	 * around. If this is not the lowest lsn iclog, then we will leave it
+	 * for another completion to process.
 	 */
+	header_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
 	lowest_lsn = xlog_get_lowest_lsn(log);
-	if (lowest_lsn &&
-	    XFS_LSN_CMP(lowest_lsn, be64_to_cpu(iclog->ic_header.h_lsn)) < 0)
-		return false; /* Leave this iclog for another thread */
-
-	iclog->ic_state = XLOG_STATE_CALLBACK;
-
-	/*
-	 * Completion of a iclog IO does not imply that a transaction has
-	 * completed, as transactions can be large enough to span many iclogs.
-	 * We cannot change the tail of the log half way through a transaction
-	 * as this may be the only transaction in the log and moving th etail to
-	 * point to the middle of it will prevent recovery from finding the
-	 * start of the transaction.  Hence we should only update the
-	 * last_sync_lsn if this iclog contains transaction completion callbacks
-	 * on it.
-	 *
-	 * We have to do this before we drop the icloglock to ensure we are the
-	 * only one that can update it.
-	 */
-	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
-			be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
-	if (!list_empty_careful(&iclog->ic_callbacks))
-		atomic64_set(&log->l_last_sync_lsn,
-			be64_to_cpu(iclog->ic_header.h_lsn));
+	if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
+		return false;
 
+	xlog_state_set_callback(log, iclog, header_lsn);
 	return false;
 
 }
-- 
2.23.0.rc1

