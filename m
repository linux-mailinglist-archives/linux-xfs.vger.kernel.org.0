Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D6032E131
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Mar 2021 06:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhCEFMR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Mar 2021 00:12:17 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57739 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229578AbhCEFMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:12:00 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1871B828018
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:51 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kg-00Fbnu-6W
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kf-000lZ1-V7
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/45] xfs: CIL checkpoint flushes caches unconditionally
Date:   Fri,  5 Mar 2021 16:11:04 +1100
Message-Id: <20210305051143.182133-7-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210305051143.182133-1-david@fromorbit.com>
References: <20210305051143.182133-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
        a=gwj23wwd_E3P4KkB8XMA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Currently every journal IO is issued as REQ_PREFLUSH | REQ_FUA to
guarantee the ordering requirements the journal has w.r.t. metadata
writeback. THe two ordering constraints are:

1. we cannot overwrite metadata in the journal until we guarantee
that the dirty metadata has been written back in place and is
stable.

2. we cannot write back dirty metadata until it has been written to
the journal and guaranteed to be stable (and hence recoverable) in
the journal.

These rules apply to the atomic transactions recorded in the
journal, not to the journal IO itself. Hence we need to ensure
metadata is stable before we start writing a new transaction to the
journal (guarantee #1), and we need to ensure the entire transaction
is stable in the journal before we start metadata writeback
(guarantee #2).

The ordering guarantees of #1 are currently provided by REQ_PREFLUSH
being added to every iclog IO. This causes the journal IO to issue a
cache flush and wait for it to complete before issuing the write IO
to the journal. Hence all completed metadata IO is guaranteed to be
stable before the journal overwrites the old metadata.

However, for long running CIL checkpoints that might do a thousand
journal IOs, we don't need every single one of these iclog IOs to
issue a cache flush - the cache flush done before the first iclog is
submitted is sufficient to cover the entire range in the log that
the checkpoint will overwrite because the CIL space reservation
guarantees the tail of the log (completed metadata) is already
beyond the range of the checkpoint write.

Hence we only need a full cache flush between closing off the CIL
checkpoint context (i.e. when the push switches it out) and issuing
the first journal IO. Rather than plumbing this through to the
journal IO, we can start this cache flush the moment the CIL context
is owned exclusively by the push worker. The cache flush can be in
progress while we process the CIL ready for writing, hence
reducing the latency of the initial iclog write. This is especially
true for large checkpoints, where we might have to process hundreds
of thousands of log vectors before we issue the first iclog write.
In these cases, it is likely the cache flush has already been
completed by the time we have built the CIL log vector chain.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 1e5fd6f268c2..b4cdb8b6c4c3 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -656,6 +656,8 @@ xlog_cil_push_work(
 	struct xfs_log_vec	lvhdr = { NULL };
 	xfs_lsn_t		commit_lsn;
 	xfs_lsn_t		push_seq;
+	struct bio		bio;
+	DECLARE_COMPLETION_ONSTACK(bdev_flush);
 
 	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
@@ -719,10 +721,25 @@ xlog_cil_push_work(
 	spin_unlock(&cil->xc_push_lock);
 
 	/*
-	 * pull all the log vectors off the items in the CIL, and
-	 * remove the items from the CIL. We don't need the CIL lock
-	 * here because it's only needed on the transaction commit
-	 * side which is currently locked out by the flush lock.
+	 * The CIL is stable at this point - nothing new will be added to it
+	 * because we hold the flush lock exclusively. Hence we can now issue
+	 * a cache flush to ensure all the completed metadata in the journal we
+	 * are about to overwrite is on stable storage.
+	 *
+	 * This avoids the need to have the iclogs issue REQ_PREFLUSH based
+	 * cache flushes to provide this ordering guarantee, and hence for CIL
+	 * checkpoints that require hundreds or thousands of log writes no
+	 * longer need to issue device cache flushes to provide metadata
+	 * writeback ordering.
+	 */
+	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
+				&bdev_flush);
+
+	/*
+	 * Pull all the log vectors off the items in the CIL, and remove the
+	 * items from the CIL. We don't need the CIL lock here because it's only
+	 * needed on the transaction commit side which is currently locked out
+	 * by the flush lock.
 	 */
 	lv = NULL;
 	num_iovecs = 0;
@@ -806,6 +823,12 @@ xlog_cil_push_work(
 	lvhdr.lv_iovecp = &lhdr;
 	lvhdr.lv_next = ctx->lv_chain;
 
+	/*
+	 * Before we format and submit the first iclog, we have to ensure that
+	 * the metadata writeback ordering cache flush is complete.
+	 */
+	wait_for_completion(&bdev_flush);
+
 	error = xlog_write(log, &lvhdr, tic, &ctx->start_lsn, NULL, 0, true);
 	if (error)
 		goto out_abort_free_ticket;
-- 
2.28.0

