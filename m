Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D141A1930A0
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Mar 2020 19:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgCYStq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Mar 2020 14:49:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55070 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgCYStq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 14:49:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=apdyOee5dxr2O1+YUEEBCr+zjq5nYLYX55Sy6csjp1k=; b=s74mtVbhV/r4Bdjz+Xfn3qAPMY
        Wt8B8nhZUqIHc2KXKT8JczbkYl0EAFQkKxPk7vCbpMisaQdJT0i//no1pT3tBDgvkCJPJl096tX/t
        d/jU0tDNyFE70KdZKn0N4Hz/3SrvKGaoeVz+oLawJyichobARjYNFkBXePHZw7F0vBswEiiefn+Et
        S+VPPK4m5ztGoqrpvIBQIArArYA1pHZW1BDxjfQPVAjKOXxkWVd/nfkxJIvW+3f7ri/nD+02hl08L
        ecbBJATSjQb8icijIrZ12qYdRpUyCtdgcKA75Hkr3vberwj2YlDM8yItAf71WlRaWn+oP5oVeuuMb
        7obRvb5w==;
Received: from [2001:4bb8:18c:2a9e:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHB61-00035L-Je; Wed, 25 Mar 2020 18:49:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 3/8] xfs: refactor and split xfs_log_done()
Date:   Wed, 25 Mar 2020 19:43:00 +0100
Message-Id: <20200325184305.1361872-4-hch@lst.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200325184305.1361872-1-hch@lst.de>
References: <20200325184305.1361872-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_log_done() does two separate things. Firstly, it triggers commit
records to be written for permanent transactions, and secondly it
releases or regrants transaction reservation space.

Since delayed logging was introduced, transactions no longer write
directly to the log, hence they never have the XLOG_TIC_INITED flag
cleared on them. Hence transactions never write commit records to
the log and only need to modify reservation space.

Split up xfs_log_done into two parts, and only call the parts of the
operation needed for the context xfs_log_done() is currently being
called from.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c      | 64 ++++++++++++++-----------------------------
 fs/xfs/xfs_log.h      |  4 ---
 fs/xfs/xfs_log_cil.c  | 13 +++++----
 fs/xfs/xfs_log_priv.h |  4 +++
 fs/xfs/xfs_trans.c    | 24 ++++++++--------
 5 files changed, 44 insertions(+), 65 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c14f8f14a381..f1a8f303722f 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -487,62 +487,40 @@ xfs_log_reserve(
  */
 
 /*
- * This routine is called when a user of a log manager ticket is done with
- * the reservation.  If the ticket was ever used, then a commit record for
- * the associated transaction is written out as a log operation header with
- * no data.  The flag XLOG_TIC_INITED is set when the first write occurs with
- * a given ticket.  If the ticket was one with a permanent reservation, then
- * a few operations are done differently.  Permanent reservation tickets by
- * default don't release the reservation.  They just commit the current
- * transaction with the belief that the reservation is still needed.  A flag
- * must be passed in before permanent reservations are actually released.
- * When these type of tickets are not released, they need to be set into
- * the inited state again.  By doing this, a start record will be written
- * out when the next write occurs.
+ * Write a commit record to the log to close off a running log write.
  */
-xfs_lsn_t
-xfs_log_done(
-	struct xfs_mount	*mp,
+int
+xlog_write_done(
+	struct xlog		*log,
 	struct xlog_ticket	*ticket,
 	struct xlog_in_core	**iclog,
-	bool			regrant)
+	xfs_lsn_t		*lsn)
 {
-	struct xlog		*log = mp->m_log;
-	xfs_lsn_t		lsn = 0;
-
-	if (XLOG_FORCED_SHUTDOWN(log) ||
-	    /*
-	     * If nothing was ever written, don't write out commit record.
-	     * If we get an error, just continue and give back the log ticket.
-	     */
-	    (((ticket->t_flags & XLOG_TIC_INITED) == 0) &&
-	     (xlog_commit_record(log, ticket, iclog, &lsn)))) {
-		lsn = (xfs_lsn_t) -1;
-		regrant = false;
-	}
+	if (XLOG_FORCED_SHUTDOWN(log))
+		return -EIO;
 
+	return xlog_commit_record(log, ticket, iclog, lsn);
+}
 
-	if (!regrant) {
+/*
+ * Release or regrant the ticket reservation now the transaction is done with
+ * it depending on caller context. Rolling transactions need the ticket
+ * regranted, otherwise we release it completely.
+ */
+void
+xlog_ticket_done(
+	struct xlog		*log,
+	struct xlog_ticket	*ticket,
+	bool			regrant)
+{
+	if (!regrant || XLOG_FORCED_SHUTDOWN(log)) {
 		trace_xfs_log_done_nonperm(log, ticket);
-
-		/*
-		 * Release ticket if not permanent reservation or a specific
-		 * request has been made to release a permanent reservation.
-		 */
 		xlog_ungrant_log_space(log, ticket);
 	} else {
 		trace_xfs_log_done_perm(log, ticket);
-
 		xlog_regrant_reserve_log_space(log, ticket);
-		/* If this ticket was a permanent reservation and we aren't
-		 * trying to release it, reset the inited flags; so next time
-		 * we write, a start record will be written out.
-		 */
-		ticket->t_flags |= XLOG_TIC_INITED;
 	}
-
 	xfs_log_ticket_put(ticket);
-	return lsn;
 }
 
 static bool
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index cc77cc36560a..1412d6993f1e 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -105,10 +105,6 @@ struct xfs_log_item;
 struct xfs_item_ops;
 struct xfs_trans;
 
-xfs_lsn_t xfs_log_done(struct xfs_mount *mp,
-		       struct xlog_ticket *ticket,
-		       struct xlog_in_core **iclog,
-		       bool regrant);
 int	  xfs_log_force(struct xfs_mount *mp, uint flags);
 int	  xfs_log_force_lsn(struct xfs_mount *mp, xfs_lsn_t lsn, uint flags,
 		int *log_forced);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index e0aeb316ce6c..666041ef058f 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -839,10 +839,11 @@ xlog_cil_push_work(
 	}
 	spin_unlock(&cil->xc_push_lock);
 
-	/* xfs_log_done always frees the ticket on error. */
-	commit_lsn = xfs_log_done(log->l_mp, tic, &commit_iclog, false);
-	if (commit_lsn == -1)
-		goto out_abort;
+	error = xlog_write_done(log, tic, &commit_iclog, &commit_lsn);
+	if (error)
+		goto out_abort_free_ticket;
+
+	xlog_ticket_done(log, tic, false);
 
 	spin_lock(&commit_iclog->ic_callback_lock);
 	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
@@ -875,7 +876,7 @@ xlog_cil_push_work(
 	return;
 
 out_abort_free_ticket:
-	xfs_log_ticket_put(tic);
+	xlog_ticket_done(log, tic, false);
 out_abort:
 	ASSERT(XLOG_FORCED_SHUTDOWN(log));
 	xlog_cil_committed(ctx);
@@ -1007,7 +1008,7 @@ xfs_log_commit_cil(
 	if (commit_lsn)
 		*commit_lsn = xc_commit_lsn;
 
-	xfs_log_done(mp, tp->t_ticket, NULL, regrant);
+	xlog_ticket_done(log, tp->t_ticket, regrant);
 	tp->t_ticket = NULL;
 	xfs_trans_unreserve_and_mod_sb(tp);
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b895e16460ee..1f450ea6192c 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -443,6 +443,10 @@ int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
 		struct xlog_ticket *tic, xfs_lsn_t *start_lsn,
 		struct xlog_in_core **commit_iclog, uint flags,
 		bool need_start_rec);
+int	xlog_write_done(struct xlog *log, struct xlog_ticket *ticket,
+		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
+void	xlog_ticket_done(struct xlog *log, struct xlog_ticket *ticket,
+		bool regrant);
 
 /*
  * When we crack an atomic LSN, we sample it first so that the value will not
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 73c534093f09..123ecc8435f6 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -9,6 +9,7 @@
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
+#include "xfs_log_priv.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_extent_busy.h"
@@ -150,8 +151,9 @@ xfs_trans_reserve(
 	uint			blocks,
 	uint			rtextents)
 {
-	int		error = 0;
-	bool		rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error = 0;
+	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 
 	/* Mark this thread as being in a transaction */
 	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
@@ -162,7 +164,7 @@ xfs_trans_reserve(
 	 * fail if the count would go below zero.
 	 */
 	if (blocks > 0) {
-		error = xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks), rsvd);
+		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
 		if (error != 0) {
 			current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 			return -ENOSPC;
@@ -191,9 +193,9 @@ xfs_trans_reserve(
 
 		if (tp->t_ticket != NULL) {
 			ASSERT(resp->tr_logflags & XFS_TRANS_PERM_LOG_RES);
-			error = xfs_log_regrant(tp->t_mountp, tp->t_ticket);
+			error = xfs_log_regrant(mp, tp->t_ticket);
 		} else {
-			error = xfs_log_reserve(tp->t_mountp,
+			error = xfs_log_reserve(mp,
 						resp->tr_logres,
 						resp->tr_logcount,
 						&tp->t_ticket, XFS_TRANSACTION,
@@ -213,7 +215,7 @@ xfs_trans_reserve(
 	 * fail if the count would go below zero.
 	 */
 	if (rtextents > 0) {
-		error = xfs_mod_frextents(tp->t_mountp, -((int64_t)rtextents));
+		error = xfs_mod_frextents(mp, -((int64_t)rtextents));
 		if (error) {
 			error = -ENOSPC;
 			goto undo_log;
@@ -229,7 +231,7 @@ xfs_trans_reserve(
 	 */
 undo_log:
 	if (resp->tr_logres > 0) {
-		xfs_log_done(tp->t_mountp, tp->t_ticket, NULL, false);
+		xlog_ticket_done(mp->m_log, tp->t_ticket, false);
 		tp->t_ticket = NULL;
 		tp->t_log_res = 0;
 		tp->t_flags &= ~XFS_TRANS_PERM_LOG_RES;
@@ -237,7 +239,7 @@ xfs_trans_reserve(
 
 undo_blocks:
 	if (blocks > 0) {
-		xfs_mod_fdblocks(tp->t_mountp, (int64_t)blocks, rsvd);
+		xfs_mod_fdblocks(mp, (int64_t)blocks, rsvd);
 		tp->t_blk_res = 0;
 	}
 
@@ -999,9 +1001,7 @@ __xfs_trans_commit(
 	 */
 	xfs_trans_unreserve_and_mod_dquots(tp);
 	if (tp->t_ticket) {
-		commit_lsn = xfs_log_done(mp, tp->t_ticket, NULL, regrant);
-		if (commit_lsn == -1 && !error)
-			error = -EIO;
+		xlog_ticket_done(mp->m_log, tp->t_ticket, regrant);
 		tp->t_ticket = NULL;
 	}
 	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
@@ -1060,7 +1060,7 @@ xfs_trans_cancel(
 	xfs_trans_unreserve_and_mod_dquots(tp);
 
 	if (tp->t_ticket) {
-		xfs_log_done(mp, tp->t_ticket, NULL, false);
+		xlog_ticket_done(mp->m_log, tp->t_ticket, false);
 		tp->t_ticket = NULL;
 	}
 
-- 
2.25.1

