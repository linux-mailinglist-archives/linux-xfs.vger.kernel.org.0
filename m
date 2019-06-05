Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC5E836475
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 21:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfFETQK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 15:16:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59736 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETQK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:16:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=U5AIyn/vkKKWL8GMxDHx4R2cSpgvpvrFLLCYy8Np21o=; b=mBA5TxCrvo/xjjI03G8mamhGx
        HD8DaqJd/ZDyjFDc6YY04v+HMsw51R4O2J97+VL1lDh4du1X1HF0HfPET9AoTtsm5Bwx4DTrsgtLq
        8LaqIjX7oHv6h9s1WWE6aEurDgK817QYI5/maHrW/imVaRW8VNQQ5kap1BYXlUDb+86L9mjUDTy7Y
        hhLIEHhGFQ8EXVvzVa5MAYJ78jGdAnm1u9e9fTt2gGwEh2lTQ97vjXTPFo4Zlf5uYO9FwjG30Mk3x
        gFVIsrBV36kifCq7lHtF/i3SFSKe0D3TQ86Bkhm6vEelHeON2X0RcNlY1w+Nke4O1jKNX5ABkrpnF
        VzVAfIPpg==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbOL-0002Ea-K5
        for linux-xfs@vger.kernel.org; Wed, 05 Jun 2019 19:16:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 17/24] xfs: move the log ioend workqueue to struct xlog
Date:   Wed,  5 Jun 2019 21:15:04 +0200
Message-Id: <20190605191511.32695-18-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190605191511.32695-1-hch@lst.de>
References: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the workqueue used for log I/O completions from struct xfs_mount
to struct xlog to keep it self contained in the log code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 13 +++++++++++--
 fs/xfs/xfs_log_priv.h |  1 +
 fs/xfs/xfs_mount.h    |  1 -
 fs/xfs/xfs_super.c    | 11 +----------
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0a8a43d77385..66b87cce69b9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1490,11 +1490,19 @@ xlog_alloc_log(
 	*iclogp = log->l_iclog;			/* complete ring */
 	log->l_iclog->ic_prev = prev_iclog;	/* re-write 1st prev ptr */
 
+	log->l_ioend_workqueue = alloc_workqueue("xfs-log/%s",
+			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_HIGHPRI, 0,
+			mp->m_fsname);
+	if (!log->l_ioend_workqueue)
+		goto out_free_iclog;
+
 	error = xlog_cil_init(log);
 	if (error)
-		goto out_free_iclog;
+		goto out_destroy_workqueue;
 	return log;
 
+out_destroy_workqueue:
+	destroy_workqueue(log->l_ioend_workqueue);
 out_free_iclog:
 	for (iclog = log->l_iclog; iclog; iclog = prev_iclog) {
 		prev_iclog = iclog->ic_next;
@@ -1691,7 +1699,7 @@ xlog_bio_end_io(
 {
 	struct xlog_in_core	*iclog = bio->bi_private;
 
-	queue_work(iclog->ic_log->l_mp->m_log_workqueue,
+	queue_work(iclog->ic_log->l_ioend_workqueue,
 		   &iclog->ic_end_io_work);
 }
 
@@ -1946,6 +1954,7 @@ xlog_dealloc_log(
 	int		i;
 
 	xlog_cil_destroy(log);
+	destroy_workqueue(log->l_ioend_workqueue);
 
 	/*
 	 * Cycle all the iclogbuf locks to make sure all log IO completion
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b9c90abb09a2..a20f5e919a26 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -357,6 +357,7 @@ struct xlog {
 	struct xfs_ail		*l_ailp;	/* AIL log is working with */
 	struct xfs_cil		*l_cilp;	/* CIL log is working with */
 	struct xfs_buftarg	*l_targ;        /* buftarg of log */
+	struct workqueue_struct	*l_ioend_workqueue; /* for I/O completions */
 	struct delayed_work	l_work;		/* background flush work */
 	uint			l_flags;
 	uint			l_quotaoffs_flag; /* XFS_DQ_*, for QUOTAOFFs */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c81a5cd7c228..8d188155dca3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -198,7 +198,6 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
 	struct workqueue_struct	*m_reclaim_workqueue;
-	struct workqueue_struct	*m_log_workqueue;
 	struct workqueue_struct *m_eofblocks_workqueue;
 	struct workqueue_struct	*m_sync_workqueue;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a14d11d78bd8..7cb0d2a01c41 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -840,16 +840,10 @@ xfs_init_mount_workqueues(
 	if (!mp->m_reclaim_workqueue)
 		goto out_destroy_cil;
 
-	mp->m_log_workqueue = alloc_workqueue("xfs-log/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE|WQ_HIGHPRI, 0,
-			mp->m_fsname);
-	if (!mp->m_log_workqueue)
-		goto out_destroy_reclaim;
-
 	mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
 			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
 	if (!mp->m_eofblocks_workqueue)
-		goto out_destroy_log;
+		goto out_destroy_reclaim;
 
 	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s", WQ_FREEZABLE, 0,
 					       mp->m_fsname);
@@ -860,8 +854,6 @@ xfs_init_mount_workqueues(
 
 out_destroy_eofb:
 	destroy_workqueue(mp->m_eofblocks_workqueue);
-out_destroy_log:
-	destroy_workqueue(mp->m_log_workqueue);
 out_destroy_reclaim:
 	destroy_workqueue(mp->m_reclaim_workqueue);
 out_destroy_cil:
@@ -880,7 +872,6 @@ xfs_destroy_mount_workqueues(
 {
 	destroy_workqueue(mp->m_sync_workqueue);
 	destroy_workqueue(mp->m_eofblocks_workqueue);
-	destroy_workqueue(mp->m_log_workqueue);
 	destroy_workqueue(mp->m_reclaim_workqueue);
 	destroy_workqueue(mp->m_cil_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);
-- 
2.20.1

