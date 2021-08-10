Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D2E3D7003
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jul 2021 09:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbhG0HKV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Jul 2021 03:10:21 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:60122 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235742AbhG0HKU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 03:10:20 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id CC540691F1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 17:10:17 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00BI3p-T4
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00E5ay-L7
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/11] xfs: log forces imply data device cache flushes
Date:   Tue, 27 Jul 2021 17:10:07 +1000
Message-Id: <20210727071012.3358033-7-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727071012.3358033-1-david@fromorbit.com>
References: <20210727071012.3358033-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=ogJaZpAc27e5p_mnMSAA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

After fixing the tail_lsn vs cache flush race, generic/482 continued
to fail in a similar way where cache flushes were missing before
iclog FUA writes. Tracing of iclog state changes during the fsstress
workload portion of the test (via xlog_iclog* events) indicated that
iclog writes were coming from two sources - CIL pushes and log
forces (due to fsync/O_SYNC operations). All of the cases where a
recovery problem was triggered indicated that the log force was the
source of the iclog write that was not preceeded by a cache flush.

This was an oversight in the modifications made in commit
eef983ffeae7 ("xfs: journal IO cache flush reductions"). Log forces
for fsync imply a data device cache flush has been issued if an
iclog was flushed to disk and is indicated to the caller via the
log_flushed parameter so they can elide the device cache flush if
the journal issued one.

The change in eef983ffeae7 results in iclogs only issuing a cache
flush if XLOG_ICL_NEED_FLUSH is set on the iclog, but this was not
added to the iclogs that the log force code flushes to disk. Hence
log forces are no longer guaranteeing that a cache flush is issued,
hence opening up a potential on-disk ordering failure.

Log forces should also set XLOG_ICL_NEED_FUA as well to ensure that
the actual iclogs it forces to the journal are also on stable
storage before it returns to the caller.

This patch introduces the xlog_force_iclog() helper function to
encapsulate the process of taking a reference to an iclog, switching
its state if WANT_SYNC and flushing it to stable storage correctly.

Both xfs_log_force() and xfs_log_force_lsn() are converted to use
it, as is xlog_unmount_write() which has an elaborate method of
doing exactly the same "write this iclog to stable storage"
operation.

Further, if the log force code needs to wait on a iclog in the
WANT_SYNC state, it needs to ensure that iclog also results in a
cache flush being issued. This covers the case where the iclog
contains the commit record of the CIL flush that the log force
triggered, but it hasn't been written yet because there is still an
active reference to the iclog.

Note: this whole cache flush whack-a-mole patch is a result of log
forces still being iclog state centric rather than being CIL
sequence centric. Most of this nasty code will go away in future
when log forces are converted to wait on CIL sequence push
completion rather than iclog completion. With the CIL push algorithm
guaranteeing that the CIL checkpoint is fully on stable storage when
it completes, we no longer need to iterate iclogs and push them to
ensure a CIL sequence push has completed and so all this nasty iclog
iteration and flushing code will go away.

Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c | 47 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 184c68ea62bb..160b8bb7ee60 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -787,6 +787,7 @@ xlog_force_iclog(
 	struct xlog_in_core	*iclog)
 {
 	atomic_inc(&iclog->ic_refcnt);
+	iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
 	if (iclog->ic_state == XLOG_STATE_ACTIVE)
 		xlog_state_switch_iclogs(iclog->ic_log, iclog, 0);
 	return xlog_state_release_iclog(iclog->ic_log, iclog, 0);
@@ -877,7 +878,6 @@ xlog_unmount_write(
 
 	spin_lock(&log->l_icloglock);
 	iclog = log->l_iclog;
-	iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
 	error = xlog_force_iclog(iclog);
 	xlog_wait_on_iclog(iclog);
 
@@ -3214,22 +3214,23 @@ xfs_log_force(
 				goto out_unlock;
 		} else {
 			/*
-			 * Someone else is writing to this iclog.
-			 *
-			 * Use its call to flush out the data.  However, the
-			 * other thread may not force out this LR, so we mark
-			 * it WANT_SYNC.
+			 * Someone else is still writing to this iclog, so we
+			 * need to ensure that when they release the iclog it
+			 * gets synced immediately as we may be waiting on it.
 			 */
 			xlog_state_switch_iclogs(log, iclog, 0);
 		}
-	} else {
-		/*
-		 * If the head iclog is not active nor dirty, we just attach
-		 * ourselves to the head and go to sleep if necessary.
-		 */
-		;
 	}
 
+	/*
+	 * The iclog we are about to wait on may contain the checkpoint pushed
+	 * by the above xlog_cil_force() call, but it may not have been pushed
+	 * to disk yet. Like the ACTIVE case above, we need to make sure caches
+	 * are flushed when this iclog is written.
+	 */
+	if (iclog->ic_state == XLOG_STATE_WANT_SYNC)
+		iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
+
 	if (flags & XFS_LOG_SYNC)
 		return xlog_wait_on_iclog(iclog);
 out_unlock:
@@ -3262,7 +3263,8 @@ xlog_force_lsn(
 			goto out_unlock;
 	}
 
-	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
+	switch (iclog->ic_state) {
+	case XLOG_STATE_ACTIVE:
 		/*
 		 * We sleep here if we haven't already slept (e.g. this is the
 		 * first time we've looked at the correct iclog buf) and the
@@ -3289,6 +3291,25 @@ xlog_force_lsn(
 			goto out_error;
 		if (log_flushed)
 			*log_flushed = 1;
+		break;
+	case XLOG_STATE_WANT_SYNC:
+		/*
+		 * This iclog may contain the checkpoint pushed by the
+		 * xlog_cil_force_seq() call, but there are other writers still
+		 * accessing it so it hasn't been pushed to disk yet. Like the
+		 * ACTIVE case above, we need to make sure caches are flushed
+		 * when this iclog is written.
+		 */
+		iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
+		break;
+	default:
+		/*
+		 * The entire checkpoint was written by the CIL force and is on
+		 * its way to disk already. It will be stable when it
+		 * completes, so we don't need to manipulate caches here at all.
+		 * We just need to wait for completion if necessary.
+		 */
+		break;
 	}
 
 	if (flags & XFS_LOG_SYNC)
-- 
2.31.1

