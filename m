Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 377DD1930A3
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Mar 2020 19:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbgCYStv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Mar 2020 14:49:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55096 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgCYStv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Mar 2020 14:49:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JnfI/14Vms85g767vI/3i/f1YZ/jwl9z9uYxDuTufCo=; b=KlU4HlCFH3dY4iZfVM0YDaa4My
        jKxSyCqAqJ70fUWphgy8vdV//S+ZyA125u4WCMiyo5VXllAb3V2nWGpoh4uQt/gW4ZIECwxZl84F7
        VJ0ujvxe61IAsRMG+rx6GSmru6lMyZ5Nqn0xz/68UT6htmgnSRj0+nNu9VLyk5T4J6Maaw/WRqPzt
        9cCH1yUxBsO+SGbhK2bb2SOc+UNkubRKzgfChfxmfLn+S5b2i8iaWcHsUGOBGJhx390ecfbgOApAK
        u0puelcEpDkkqFYxElkRovOUebbCanKxQZubVRJZ/70K0KqhsUgqAurPIqddo2SYWTElLXq5AiMl6
        KvxHr63w==;
Received: from [2001:4bb8:18c:2a9e:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHB66-00036H-U0; Wed, 25 Mar 2020 18:49:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5/8] xfs: split xlog_ticket_done
Date:   Wed, 25 Mar 2020 19:43:02 +0100
Message-Id: <20200325184305.1361872-6-hch@lst.de>
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

Remove xlog_ticket_done and just call the renamed low-level helpers for
ungranting or regranting log space directly.  To make that a little
the reference put on the ticket and all tracing is moved into the actual
helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c      | 84 ++++++++++++++-----------------------------
 fs/xfs/xfs_log_cil.c  |  9 +++--
 fs/xfs/xfs_log_priv.h |  4 +--
 fs/xfs/xfs_trace.h    | 14 ++++----
 fs/xfs/xfs_trans.c    |  9 +++--
 5 files changed, 47 insertions(+), 73 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7ce551502a47..227a8e49e540 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -66,14 +66,6 @@ xlog_grant_push_ail(
 	struct xlog		*log,
 	int			need_bytes);
 STATIC void
-xlog_regrant_reserve_log_space(
-	struct xlog		*log,
-	struct xlog_ticket	*ticket);
-STATIC void
-xlog_ungrant_log_space(
-	struct xlog		*log,
-	struct xlog_ticket	*ticket);
-STATIC void
 xlog_sync(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog);
@@ -502,27 +494,6 @@ xlog_write_done(
 	return xlog_commit_record(log, ticket, iclog, lsn);
 }
 
-/*
- * Release or regrant the ticket reservation now the transaction is done with
- * it depending on caller context. Rolling transactions need the ticket
- * regranted, otherwise we release it completely.
- */
-void
-xlog_ticket_done(
-	struct xlog		*log,
-	struct xlog_ticket	*ticket,
-	bool			regrant)
-{
-	if (!regrant || XLOG_FORCED_SHUTDOWN(log)) {
-		trace_xfs_log_done_nonperm(log, ticket);
-		xlog_ungrant_log_space(log, ticket);
-	} else {
-		trace_xfs_log_done_perm(log, ticket);
-		xlog_regrant_reserve_log_space(log, ticket);
-	}
-	xfs_log_ticket_put(ticket);
-}
-
 static bool
 __xlog_state_release_iclog(
 	struct xlog		*log,
@@ -921,8 +892,7 @@ xfs_log_write_unmount_record(
 
 	if (tic) {
 		trace_xfs_log_umount_write(log, tic);
-		xlog_ungrant_log_space(log, tic);
-		xfs_log_ticket_put(tic);
+		xfs_log_ticket_ungrant(log, tic);
 	}
 }
 
@@ -2986,19 +2956,18 @@ xlog_state_get_iclog_space(
 	return 0;
 }	/* xlog_state_get_iclog_space */
 
-/* The first cnt-1 times through here we don't need to
- * move the grant write head because the permanent
- * reservation has reserved cnt times the unit amount.
- * Release part of current permanent unit reservation and
- * reset current reservation to be one units worth.  Also
- * move grant reservation head forward.
+/*
+ * The first cnt-1 times through here we don't need to move the grant write head
+ * because the permanent reservation has reserved cnt times the unit amount.
+ * Release part of current permanent unit reservation and reset current
+ * reservation to be one units worth.  Also move grant reservation head forward.
  */
-STATIC void
-xlog_regrant_reserve_log_space(
+void
+xfs_log_ticket_regrant(
 	struct xlog		*log,
 	struct xlog_ticket	*ticket)
 {
-	trace_xfs_log_regrant_reserve_enter(log, ticket);
+	trace_xfs_log_ticket_regrant(log, ticket);
 
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
@@ -3010,21 +2979,20 @@ xlog_regrant_reserve_log_space(
 	ticket->t_curr_res = ticket->t_unit_res;
 	xlog_tic_reset_res(ticket);
 
-	trace_xfs_log_regrant_reserve_sub(log, ticket);
+	trace_xfs_log_ticket_regrant_sub(log, ticket);
 
 	/* just return if we still have some of the pre-reserved space */
-	if (ticket->t_cnt > 0)
-		return;
+	if (!ticket->t_cnt) {
+		xlog_grant_add_space(log, &log->l_reserve_head.grant,
+				     ticket->t_unit_res);
+		trace_xfs_log_ticket_regrant_exit(log, ticket);
 
-	xlog_grant_add_space(log, &log->l_reserve_head.grant,
-					ticket->t_unit_res);
-
-	trace_xfs_log_regrant_reserve_exit(log, ticket);
-
-	ticket->t_curr_res = ticket->t_unit_res;
-	xlog_tic_reset_res(ticket);
-}	/* xlog_regrant_reserve_log_space */
+		ticket->t_curr_res = ticket->t_unit_res;
+		xlog_tic_reset_res(ticket);
+	}
 
+	xfs_log_ticket_put(ticket);
+}
 
 /*
  * Give back the space left from a reservation.
@@ -3040,18 +3008,19 @@ xlog_regrant_reserve_log_space(
  * space, the count will stay at zero and the only space remaining will be
  * in the current reservation field.
  */
-STATIC void
-xlog_ungrant_log_space(
+void
+xfs_log_ticket_ungrant(
 	struct xlog		*log,
 	struct xlog_ticket	*ticket)
 {
-	int	bytes;
+	int			bytes;
+
+	trace_xfs_log_ticket_ungrant(log, ticket);
 
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
-	trace_xfs_log_ungrant_enter(log, ticket);
-	trace_xfs_log_ungrant_sub(log, ticket);
+	trace_xfs_log_ticket_ungrant_sub(log, ticket);
 
 	/*
 	 * If this is a permanent reservation ticket, we may be able to free
@@ -3066,9 +3035,10 @@ xlog_ungrant_log_space(
 	xlog_grant_sub_space(log, &log->l_reserve_head.grant, bytes);
 	xlog_grant_sub_space(log, &log->l_write_head.grant, bytes);
 
-	trace_xfs_log_ungrant_exit(log, ticket);
+	trace_xfs_log_ticket_ungrant_exit(log, ticket);
 
 	xfs_log_space_wake(log->l_mp);
+	xfs_log_ticket_put(ticket);
 }
 
 /*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 666041ef058f..0ae187fa9af2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -843,7 +843,7 @@ xlog_cil_push_work(
 	if (error)
 		goto out_abort_free_ticket;
 
-	xlog_ticket_done(log, tic, false);
+	xfs_log_ticket_ungrant(log, tic);
 
 	spin_lock(&commit_iclog->ic_callback_lock);
 	if (commit_iclog->ic_state == XLOG_STATE_IOERROR) {
@@ -876,7 +876,7 @@ xlog_cil_push_work(
 	return;
 
 out_abort_free_ticket:
-	xlog_ticket_done(log, tic, false);
+	xfs_log_ticket_ungrant(log, tic);
 out_abort:
 	ASSERT(XLOG_FORCED_SHUTDOWN(log));
 	xlog_cil_committed(ctx);
@@ -1008,7 +1008,10 @@ xfs_log_commit_cil(
 	if (commit_lsn)
 		*commit_lsn = xc_commit_lsn;
 
-	xlog_ticket_done(log, tp->t_ticket, regrant);
+	if (regrant && !XLOG_FORCED_SHUTDOWN(log))
+		xfs_log_ticket_regrant(log, tp->t_ticket);
+	else
+		xfs_log_ticket_ungrant(log, tp->t_ticket);
 	tp->t_ticket = NULL;
 	xfs_trans_unreserve_and_mod_sb(tp);
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index fd63400fff6d..0941b465de9e 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -443,8 +443,8 @@ int	xlog_write(struct xlog *log, struct xfs_log_vec *log_vector,
 		bool need_start_rec);
 int	xlog_write_done(struct xlog *log, struct xlog_ticket *ticket,
 		struct xlog_in_core **iclog, xfs_lsn_t *lsn);
-void	xlog_ticket_done(struct xlog *log, struct xlog_ticket *ticket,
-		bool regrant);
+void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
+void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
 
 /*
  * When we crack an atomic LSN, we sample it first so that the value will not
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index efc7751550d9..f7f12d312fd3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1001,8 +1001,6 @@ DECLARE_EVENT_CLASS(xfs_loggrant_class,
 DEFINE_EVENT(xfs_loggrant_class, name, \
 	TP_PROTO(struct xlog *log, struct xlog_ticket *tic), \
 	TP_ARGS(log, tic))
-DEFINE_LOGGRANT_EVENT(xfs_log_done_nonperm);
-DEFINE_LOGGRANT_EVENT(xfs_log_done_perm);
 DEFINE_LOGGRANT_EVENT(xfs_log_umount_write);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_sleep);
 DEFINE_LOGGRANT_EVENT(xfs_log_grant_wake);
@@ -1011,12 +1009,12 @@ DEFINE_LOGGRANT_EVENT(xfs_log_reserve);
 DEFINE_LOGGRANT_EVENT(xfs_log_reserve_exit);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant);
 DEFINE_LOGGRANT_EVENT(xfs_log_regrant_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_regrant_reserve_sub);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_enter);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_exit);
-DEFINE_LOGGRANT_EVENT(xfs_log_ungrant_sub);
+DEFINE_LOGGRANT_EVENT(xfs_log_ticket_regrant);
+DEFINE_LOGGRANT_EVENT(xfs_log_ticket_regrant_exit);
+DEFINE_LOGGRANT_EVENT(xfs_log_ticket_regrant_sub);
+DEFINE_LOGGRANT_EVENT(xfs_log_ticket_ungrant);
+DEFINE_LOGGRANT_EVENT(xfs_log_ticket_ungrant_sub);
+DEFINE_LOGGRANT_EVENT(xfs_log_ticket_ungrant_exit);
 
 DECLARE_EVENT_CLASS(xfs_log_item_class,
 	TP_PROTO(struct xfs_log_item *lip),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 123ecc8435f6..430b9f9dceee 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -231,7 +231,7 @@ xfs_trans_reserve(
 	 */
 undo_log:
 	if (resp->tr_logres > 0) {
-		xlog_ticket_done(mp->m_log, tp->t_ticket, false);
+		xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
 		tp->t_ticket = NULL;
 		tp->t_log_res = 0;
 		tp->t_flags &= ~XFS_TRANS_PERM_LOG_RES;
@@ -1001,7 +1001,10 @@ __xfs_trans_commit(
 	 */
 	xfs_trans_unreserve_and_mod_dquots(tp);
 	if (tp->t_ticket) {
-		xlog_ticket_done(mp->m_log, tp->t_ticket, regrant);
+		if (regrant && !XLOG_FORCED_SHUTDOWN(mp->m_log))
+			xfs_log_ticket_regrant(mp->m_log, tp->t_ticket);
+		else
+			xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
 		tp->t_ticket = NULL;
 	}
 	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
@@ -1060,7 +1063,7 @@ xfs_trans_cancel(
 	xfs_trans_unreserve_and_mod_dquots(tp);
 
 	if (tp->t_ticket) {
-		xlog_ticket_done(mp->m_log, tp->t_ticket, false);
+		xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
 		tp->t_ticket = NULL;
 	}
 
-- 
2.25.1

