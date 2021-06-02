Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9263439961E
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Jun 2021 00:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhFBW7r (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 2 Jun 2021 18:59:47 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:36877 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229667AbhFBW7q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 18:59:46 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 92976861C4B;
        Thu,  3 Jun 2021 08:58:01 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1loZoG-008Gc4-J4; Thu, 03 Jun 2021 08:58:00 +1000
Date:   Thu, 3 Jun 2021 08:58:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 20/39 V2] xfs: pass lv chain length into xlog_write()
Message-ID: <20210602225800.GX664593@dread.disaster.area>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-21-david@fromorbit.com>
 <20210527172027.GL202144@locust>
 <20210602221852.GV664593@dread.disaster.area>
 <20210602222427.GN26380@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602222427.GN26380@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=hIND3nFijBJh5Kz5_mcA:9 a=FMiOMcta5Tn0IKGb:21 a=rjwymzV7ixGYVZBQ:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The caller of xlog_write() usually has a close accounting of the
aggregated vector length contained in the log vector chain passed to
xlog_write(). There is no need to iterate the chain to calculate he
length of the data in xlog_write_calculate_len() if the caller is
already iterating that chain to build it.

Passing in the vector length avoids doing an extra chain iteration,
which can be a significant amount of work given that large CIL
commits can have hundreds of thousands of vectors attached to the
chain.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
V2: removed unnecessary update of num_iovecs.

 fs/xfs/xfs_log.c      | 37 ++++++-------------------------------
 fs/xfs/xfs_log_cil.c  | 16 +++++++++++-----
 fs/xfs/xfs_log_priv.h |  2 +-
 3 files changed, 18 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e849f15e9e04..58f9aafce29e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -864,7 +864,8 @@ xlog_write_unmount_record(
 	 */
 	if (log->l_targ != log->l_mp->m_ddev_targp)
 		blkdev_issue_flush(log->l_targ->bt_bdev);
-	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
+	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS,
+				reg.i_len);
 }
 
 /*
@@ -1588,7 +1589,8 @@ xlog_commit_record(
 
 	/* account for space used by record data */
 	ticket->t_curr_res -= reg.i_len;
-	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS);
+	error = xlog_write(log, &vec, ticket, lsn, iclog, XLOG_COMMIT_TRANS,
+				reg.i_len);
 	if (error)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	return error;
@@ -2108,32 +2110,6 @@ xlog_print_trans(
 	}
 }
 
-/*
- * Calculate the potential space needed by the log vector. All regions contain
- * their own opheaders and they are accounted for in region space so we don't
- * need to add them to the vector length here.
- */
-static int
-xlog_write_calc_vec_length(
-	struct xlog_ticket	*ticket,
-	struct xfs_log_vec	*log_vector,
-	uint			optype)
-{
-	struct xfs_log_vec	*lv;
-	int			len = 0;
-	int			i;
-
-	for (lv = log_vector; lv; lv = lv->lv_next) {
-		/* we don't write ordered log vectors */
-		if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED)
-			continue;
-
-		for (i = 0; i < lv->lv_niovecs; i++)
-			len += lv->lv_iovecp[i].i_len;
-	}
-	return len;
-}
-
 static xlog_op_header_t *
 xlog_write_setup_ophdr(
 	struct xlog_op_header	*ophdr,
@@ -2296,13 +2272,13 @@ xlog_write(
 	struct xlog_ticket	*ticket,
 	xfs_lsn_t		*start_lsn,
 	struct xlog_in_core	**commit_iclog,
-	uint			optype)
+	uint			optype,
+	uint32_t		len)
 {
 	struct xlog_in_core	*iclog = NULL;
 	struct xfs_log_vec	*lv = log_vector;
 	struct xfs_log_iovec	*vecp = lv->lv_iovecp;
 	int			index = 0;
-	int			len;
 	int			partial_copy = 0;
 	int			partial_copy_len = 0;
 	int			contwr = 0;
@@ -2317,7 +2293,6 @@ xlog_write(
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 	}
 
-	len = xlog_write_calc_vec_length(ticket, log_vector, optype);
 	if (start_lsn)
 		*start_lsn = 0;
 	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 58900171de09..68bec4b81052 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -710,11 +710,12 @@ xlog_cil_build_trans_hdr(
 				sizeof(struct xfs_trans_header);
 	hdr->lhdr[1].i_type = XLOG_REG_TYPE_TRANSHDR;
 
-	tic->t_curr_res -= hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
-
 	lvhdr->lv_niovecs = 2;
 	lvhdr->lv_iovecp = &hdr->lhdr[0];
+	lvhdr->lv_bytes = hdr->lhdr[0].i_len + hdr->lhdr[1].i_len;
 	lvhdr->lv_next = ctx->lv_chain;
+
+	tic->t_curr_res -= lvhdr->lv_bytes;
 }
 
 /*
@@ -742,7 +743,8 @@ xlog_cil_push_work(
 	struct xfs_log_vec	*lv;
 	struct xfs_cil_ctx	*new_ctx;
 	struct xlog_in_core	*commit_iclog;
-	int			num_iovecs;
+	int			num_iovecs = 0;
+	int			num_bytes = 0;
 	int			error = 0;
 	struct xlog_cil_trans_hdr thdr;
 	struct xfs_log_vec	lvhdr = { NULL };
@@ -835,7 +837,6 @@ xlog_cil_push_work(
 	 * by the flush lock.
 	 */
 	lv = NULL;
-	num_iovecs = 0;
 	while (!list_empty(&cil->xc_cil)) {
 		struct xfs_log_item	*item;
 
@@ -849,6 +850,10 @@ xlog_cil_push_work(
 		lv = item->li_lv;
 		item->li_lv = NULL;
 		num_iovecs += lv->lv_niovecs;
+
+		/* we don't write ordered log vectors */
+		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
+			num_bytes += lv->lv_bytes;
 	}
 
 	/*
@@ -887,6 +892,7 @@ xlog_cil_push_work(
 	 * transaction header here as it is not accounted for in xlog_write().
 	 */
 	xlog_cil_build_trans_hdr(ctx, &thdr, &lvhdr, num_iovecs);
+	num_bytes += lvhdr.lv_bytes;
 
 	/*
 	 * Before we format and submit the first iclog, we have to ensure that
@@ -901,7 +907,7 @@ xlog_cil_push_work(
 	 * write head.
 	 */
 	error = xlog_write(log, &lvhdr, ctx->ticket, &ctx->start_lsn, NULL,
-				XLOG_START_TRANS);
+				XLOG_START_TRANS, num_bytes);
 	if (error)
 		goto out_abort_free_ticket;
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 301c36165974..eba905c273b0 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -459,7 +459,7 @@ void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
 void	xlog_print_trans(struct xfs_trans *);
 int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
 		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
-		struct xlog_in_core **commit_iclog, uint optype);
+		struct xlog_in_core **commit_iclog, uint optype, uint32_t len);
 int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
 		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
 
-- 
Dave Chinner
david@fromorbit.com
