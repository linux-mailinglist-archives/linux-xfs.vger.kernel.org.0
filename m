Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B4544A25
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 20:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfFMSDI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 14:03:08 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57418 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFMSDH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ErsuXGshf7ugC0lDg3CWOKEw/PdnULg5qDCEqmu7FP0=; b=SH8fk+0RfAg9qm3ltEWJ5jqS4b
        plerwuSSKihyvZbLKa5zDDTDvUuIhCz9AwCuupU29D9ChxfbK8ntRUmuZYVOLKLJL+zMU0gBDIkDI
        wVU0e4xPTpjS3kNFFEMsqzEf/d9f+Pj2LKxZ7T7v1cFbGOkHpTgJfId0eEf3gfwwrZNCYVq9RP2tJ
        FtshQRKHQs3cK7PvklRd3hGPuVSGwaPMSf+znMnF2JApP/xJ5jx5g/UZP4Jr2NjDqwWbd52vGw+hK
        SgzZrywUdwAhvpNMzaWW8NMdruOMpFVqmiitaE2GxwQMrYvavgirOP5RjEJLS/ab5PDWLZh/3qwKN
        y0pqThIQ==;
Received: from [213.208.157.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbU43-0002fl-CA; Thu, 13 Jun 2019 18:03:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 02/20] xfs: stop using XFS_LI_ABORTED as a parameter flag
Date:   Thu, 13 Jun 2019 20:02:42 +0200
Message-Id: <20190613180300.30447-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just pass a straight bool aborted instead of abusing XFS_LI_ABORTED as a
flag in function parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c        | 25 +++++++++++--------------
 fs/xfs/xfs_log.h        |  2 +-
 fs/xfs/xfs_log_cil.c    |  4 ++--
 fs/xfs/xfs_trans.c      |  2 +-
 fs/xfs/xfs_trans_priv.h |  2 +-
 5 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 66b87cce69b9..488a47d7b6a6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -50,12 +50,9 @@ xlog_dealloc_log(
 	struct xlog		*log);
 
 /* local state machine functions */
-STATIC void xlog_state_done_syncing(xlog_in_core_t *iclog, int);
-STATIC void
-xlog_state_do_callback(
-	struct xlog		*log,
-	int			aborted,
-	struct xlog_in_core	*iclog);
+STATIC void xlog_state_done_syncing(
+	struct xlog_in_core	*iclog,
+	bool			aborted);
 STATIC int
 xlog_state_get_iclog_space(
 	struct xlog		*log,
@@ -1246,7 +1243,7 @@ xlog_ioend_work(
 	struct xlog_in_core     *iclog =
 		container_of(work, struct xlog_in_core, ic_end_io_work);
 	struct xlog		*log = iclog->ic_log;
-	int			aborted = 0;
+	bool			aborted = false;
 	int			error;
 
 #ifdef DEBUG
@@ -1268,9 +1265,9 @@ xlog_ioend_work(
 		 * callback routines to let them know that the log-commit
 		 * didn't succeed.
 		 */
-		aborted = XFS_LI_ABORTED;
+		aborted = true;
 	} else if (iclog->ic_state & XLOG_STATE_IOERROR) {
-		aborted = XFS_LI_ABORTED;
+		aborted = true;
 	}
 
 	xlog_state_done_syncing(iclog, aborted);
@@ -2639,7 +2636,7 @@ xlog_get_lowest_lsn(
 STATIC void
 xlog_state_do_callback(
 	struct xlog		*log,
-	int			aborted,
+	bool			aborted,
 	struct xlog_in_core	*ciclog)
 {
 	xlog_in_core_t	   *iclog;
@@ -2878,10 +2875,10 @@ xlog_state_do_callback(
  */
 STATIC void
 xlog_state_done_syncing(
-	xlog_in_core_t	*iclog,
-	int		aborted)
+	struct xlog_in_core	*iclog,
+	bool			aborted)
 {
-	struct xlog	   *log = iclog->ic_log;
+	struct xlog		*log = iclog->ic_log;
 
 	spin_lock(&log->l_icloglock);
 
@@ -3960,7 +3957,7 @@ xfs_log_force_umount(
 	 * avoid races.
 	 */
 	wake_up_all(&log->l_cilp->xc_commit_wait);
-	xlog_state_do_callback(log, XFS_LI_ABORTED, NULL);
+	xlog_state_do_callback(log, true, NULL);
 
 #ifdef XFSERRORDEBUG
 	{
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 73a64bf32f6f..4450a2a26a1a 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -77,7 +77,7 @@ xlog_copy_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
  */
 typedef struct xfs_log_callback {
 	struct xfs_log_callback	*cb_next;
-	void			(*cb_func)(void *, int);
+	void			(*cb_func)(void *, bool);
 	void			*cb_arg;
 } xfs_log_callback_t;
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 5e595948bc5a..1b54002d3874 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -577,7 +577,7 @@ xlog_discard_busy_extents(
 static void
 xlog_cil_committed(
 	void	*args,
-	int	abort)
+	bool	abort)
 {
 	struct xfs_cil_ctx	*ctx = args;
 	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
@@ -864,7 +864,7 @@ xlog_cil_push(
 out_abort_free_ticket:
 	xfs_log_ticket_put(tic);
 out_abort:
-	xlog_cil_committed(ctx, XFS_LI_ABORTED);
+	xlog_cil_committed(ctx, true);
 	return -EIO;
 }
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 19f91312561a..fa62d40d7ad9 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -833,7 +833,7 @@ xfs_trans_committed_bulk(
 	struct xfs_ail		*ailp,
 	struct xfs_log_vec	*log_vector,
 	xfs_lsn_t		commit_lsn,
-	int			aborted)
+	bool			aborted)
 {
 #define LOG_ITEM_BATCH_SIZE	32
 	struct xfs_log_item	*log_items[LOG_ITEM_BATCH_SIZE];
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 091eae9f4e74..571c065cf416 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -21,7 +21,7 @@ void	xfs_trans_free_items(struct xfs_trans *tp, xfs_lsn_t commit_lsn,
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
 
 void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *lv,
-				xfs_lsn_t commit_lsn, int aborted);
+				xfs_lsn_t commit_lsn, bool aborted);
 /*
  * AIL traversal cursor.
  *
-- 
2.20.1

