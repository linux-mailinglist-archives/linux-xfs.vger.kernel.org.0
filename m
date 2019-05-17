Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 755F82145E
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 09:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfEQHcY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 03:32:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44068 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbfEQHcY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=BROi0x+VNYKr4oHwe2OU4wQ7iZDHWQPH2ggEFWstO84=; b=jj+y9L4jNhpVaP2qnCO+DEkaI
        wtB8AkKaHdSvNcjV7k2UQvDWgmV+IMrb+mkTGvJQD8/tsBpTlvvScMeBHNA7YpZZroozjJvSGuJ8A
        7+RxkZJzHKwJowgs0D6Xxg3k2UKWplsaeFxnmZrupExnNGlNqPGcMh5VS9geHsGvRH8jJMQXlqkRJ
        i6PGUAKaV0P87hu5BhpkK+X2wdu37hOB0LbF4sBijamffJqAo0FJvyqapNKLHYEhmNK3MspOCVdqh
        akH/HNBCad2xeTQ0Rkm8lrOqr/8XjG6IygBW+yCzdjv6zN5UMqvmHhXh6EOmmyrD+CtDLq5KwEXKR
        R9GIFWkEA==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXLr-0000k3-MA
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/20] xfs: don't use xfs_trans_free_items in the commit path
Date:   Fri, 17 May 2019 09:31:05 +0200
Message-Id: <20190517073119.30178-7-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190517073119.30178-1-hch@lst.de>
References: <20190517073119.30178-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

While commiting items looks very similar to freeing them on error it is
a different operation, and they will diverge a bit soon.

Split out the commit case from xfs_trans_free_items, inline it into
xfs_log_commit_cil and give it a separate trace point.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_cil.c    | 13 ++++++++++---
 fs/xfs/xfs_trace.h      |  1 +
 fs/xfs/xfs_trans.c      | 10 +++-------
 fs/xfs/xfs_trans_priv.h |  2 --
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 49f37905c7a7..c856bfce5bf2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -985,6 +985,7 @@ xfs_log_commit_cil(
 {
 	struct xlog		*log = mp->m_log;
 	struct xfs_cil		*cil = log->l_cilp;
+	struct xfs_log_item	*lip, *next;
 	xfs_lsn_t		xc_commit_lsn;
 
 	/*
@@ -1009,7 +1010,7 @@ xfs_log_commit_cil(
 
 	/*
 	 * Once all the items of the transaction have been copied to the CIL,
-	 * the items can be unlocked and freed.
+	 * the items can be unlocked and possibly freed.
 	 *
 	 * This needs to be done before we drop the CIL context lock because we
 	 * have to update state in the log items and unlock them before they go
@@ -1018,8 +1019,14 @@ xfs_log_commit_cil(
 	 * the log items. This affects (at least) processing of stale buffers,
 	 * inodes and EFIs.
 	 */
-	xfs_trans_free_items(tp, xc_commit_lsn, false);
-
+	trace_xfs_trans_commit_items(tp, _RET_IP_);
+	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
+		xfs_trans_del_item(lip);
+		if (lip->li_ops->iop_committing)
+			lip->li_ops->iop_committing(lip, xc_commit_lsn);
+		if (lip->li_ops->iop_unlock)
+			lip->li_ops->iop_unlock(lip);
+	}
 	xlog_cil_push_background(log);
 
 	up_read(&cil->xc_ctx_lock);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2464ea351f83..195a9cdb954e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3360,6 +3360,7 @@ DEFINE_TRANS_EVENT(xfs_trans_dup);
 DEFINE_TRANS_EVENT(xfs_trans_free);
 DEFINE_TRANS_EVENT(xfs_trans_roll);
 DEFINE_TRANS_EVENT(xfs_trans_add_item);
+DEFINE_TRANS_EVENT(xfs_trans_commit_items);
 DEFINE_TRANS_EVENT(xfs_trans_free_items);
 
 TRACE_EVENT(xfs_iunlink_update_bucket,
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index ed7547b9f66b..4ed5d032b26f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -767,10 +767,9 @@ xfs_trans_del_item(
 }
 
 /* Detach and unlock all of the items in a transaction */
-void
+static void
 xfs_trans_free_items(
 	struct xfs_trans	*tp,
-	xfs_lsn_t		commit_lsn,
 	bool			abort)
 {
 	struct xfs_log_item	*lip, *next;
@@ -779,9 +778,6 @@ xfs_trans_free_items(
 
 	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
 		xfs_trans_del_item(lip);
-		if (commit_lsn != NULLCOMMITLSN &&
-		    lip->li_ops->iop_committing)
-			lip->li_ops->iop_committing(lip, commit_lsn);
 		if (abort)
 			set_bit(XFS_LI_ABORTED, &lip->li_flags);
 
@@ -1007,7 +1003,7 @@ __xfs_trans_commit(
 		tp->t_ticket = NULL;
 	}
 	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
-	xfs_trans_free_items(tp, NULLCOMMITLSN, !!error);
+	xfs_trans_free_items(tp, !!error);
 	xfs_trans_free(tp);
 
 	XFS_STATS_INC(mp, xs_trans_empty);
@@ -1069,7 +1065,7 @@ xfs_trans_cancel(
 	/* mark this thread as no longer being in a transaction */
 	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 
-	xfs_trans_free_items(tp, NULLCOMMITLSN, dirty);
+	xfs_trans_free_items(tp, dirty);
 	xfs_trans_free(tp);
 }
 
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 091eae9f4e74..bef1ebf933ed 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -16,8 +16,6 @@ struct xfs_log_vec;
 void	xfs_trans_init(struct xfs_mount *);
 void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
-void	xfs_trans_free_items(struct xfs_trans *tp, xfs_lsn_t commit_lsn,
-				bool abort);
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
 
 void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *lv,
-- 
2.20.1

