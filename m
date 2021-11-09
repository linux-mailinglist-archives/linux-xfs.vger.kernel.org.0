Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516C244A43B
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Nov 2021 02:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240874AbhKIBxr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Nov 2021 20:53:47 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:36145 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239580AbhKIBxq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Nov 2021 20:53:46 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 183BB105C190
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 12:50:59 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mkGHq-006ZXq-2f
        for linux-xfs@vger.kernel.org; Tue, 09 Nov 2021 12:50:58 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mkGHq-006UcJ-0z
        for linux-xfs@vger.kernel.org;
        Tue, 09 Nov 2021 12:50:58 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/16] xfs: factor out the CIL transaction header building
Date:   Tue,  9 Nov 2021 12:50:40 +1100
Message-Id: <20211109015055.1547604-2-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109015055.1547604-1-david@fromorbit.com>
References: <20211109015055.1547604-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6189d403
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=xMttu46VdFABuZTklvgA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It is static code deep in the middle of the CIL push logic. Factor
it out into a helper so that it is clear and easy to modify
separately.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 61 ++++++++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 6c93c8ada6f3..28f8104fbef1 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -834,6 +834,41 @@ xlog_cil_write_commit_record(
 	return error;
 }
 
+struct xlog_cil_trans_hdr {
+	struct xfs_trans_header	thdr;
+	struct xfs_log_iovec	lhdr;
+};
+
+/*
+ * Build a checkpoint transaction header to begin the journal transaction.  We
+ * need to account for the space used by the transaction header here as it is
+ * not accounted for in xlog_write().
+ */
+static void
+xlog_cil_build_trans_hdr(
+	struct xfs_cil_ctx	*ctx,
+	struct xlog_cil_trans_hdr *hdr,
+	struct xfs_log_vec	*lvhdr,
+	int			num_iovecs)
+{
+	struct xlog_ticket	*tic = ctx->ticket;
+
+	memset(hdr, 0, sizeof(*hdr));
+
+	hdr->thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
+	hdr->thdr.th_type = XFS_TRANS_CHECKPOINT;
+	hdr->thdr.th_tid = tic->t_tid;
+	hdr->thdr.th_num_items = num_iovecs;
+	hdr->lhdr.i_addr = &hdr->thdr;
+	hdr->lhdr.i_len = sizeof(xfs_trans_header_t);
+	hdr->lhdr.i_type = XLOG_REG_TYPE_TRANSHDR;
+	tic->t_curr_res -= hdr->lhdr.i_len + sizeof(struct xlog_op_header);
+
+	lvhdr->lv_niovecs = 1;
+	lvhdr->lv_iovecp = &hdr->lhdr;
+	lvhdr->lv_next = ctx->lv_chain;
+}
+
 /*
  * Push the Committed Item List to the log.
  *
@@ -858,11 +893,9 @@ xlog_cil_push_work(
 	struct xlog		*log = cil->xc_log;
 	struct xfs_log_vec	*lv;
 	struct xfs_cil_ctx	*new_ctx;
-	struct xlog_ticket	*tic;
 	int			num_iovecs;
 	int			error = 0;
-	struct xfs_trans_header thdr;
-	struct xfs_log_iovec	lhdr;
+	struct xlog_cil_trans_hdr thdr;
 	struct xfs_log_vec	lvhdr = { NULL };
 	xfs_lsn_t		preflush_tail_lsn;
 	xfs_csn_t		push_seq;
@@ -1011,24 +1044,8 @@ xlog_cil_push_work(
 	 * Build a checkpoint transaction header and write it to the log to
 	 * begin the transaction. We need to account for the space used by the
 	 * transaction header here as it is not accounted for in xlog_write().
-	 *
-	 * The LSN we need to pass to the log items on transaction commit is
-	 * the LSN reported by the first log vector write. If we use the commit
-	 * record lsn then we can move the tail beyond the grant write head.
 	 */
-	tic = ctx->ticket;
-	thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
-	thdr.th_type = XFS_TRANS_CHECKPOINT;
-	thdr.th_tid = tic->t_tid;
-	thdr.th_num_items = num_iovecs;
-	lhdr.i_addr = &thdr;
-	lhdr.i_len = sizeof(xfs_trans_header_t);
-	lhdr.i_type = XLOG_REG_TYPE_TRANSHDR;
-	tic->t_curr_res -= lhdr.i_len + sizeof(xlog_op_header_t);
-
-	lvhdr.lv_niovecs = 1;
-	lvhdr.lv_iovecp = &lhdr;
-	lvhdr.lv_next = ctx->lv_chain;
+	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
 
 	/*
 	 * Before we format and submit the first iclog, we have to ensure that
@@ -1044,7 +1061,7 @@ xlog_cil_push_work(
 	if (error)
 		goto out_abort_free_ticket;
 
-	xfs_log_ticket_ungrant(log, tic);
+	xfs_log_ticket_ungrant(log, ctx->ticket);
 
 	/*
 	 * If the checkpoint spans multiple iclogs, wait for all previous iclogs
@@ -1108,7 +1125,7 @@ xlog_cil_push_work(
 	return;
 
 out_abort_free_ticket:
-	xfs_log_ticket_ungrant(log, tic);
+	xfs_log_ticket_ungrant(log, ctx->ticket);
 	ASSERT(xlog_is_shutdown(log));
 	if (!ctx->commit_iclog) {
 		xlog_cil_committed(ctx);
-- 
2.33.0

