Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE471EDED4
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jun 2020 09:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgFDHqZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 4 Jun 2020 03:46:25 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41764 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728035AbgFDHqX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 03:46:23 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 910753A4510
        for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2020 17:46:13 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgkZj-0004A3-TZ
        for linux-xfs@vger.kernel.org; Thu, 04 Jun 2020 17:46:07 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jgkZj-0017HQ-KO
        for linux-xfs@vger.kernel.org; Thu, 04 Jun 2020 17:46:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/30] xfs: get rid of log item callbacks
Date:   Thu,  4 Jun 2020 17:45:48 +1000
Message-Id: <20200604074606.266213-13-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200604074606.266213-1-david@fromorbit.com>
References: <20200604074606.266213-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=IxSPRu1M28NFb9wgbagA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

They are not used anymore, so remove them from the log item and the
buffer iodone attachment interfaces.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 17 -----------------
 fs/xfs/xfs_buf_item.h |  3 ---
 fs/xfs/xfs_dquot.c    |  6 +++---
 fs/xfs/xfs_inode.c    |  5 +++--
 fs/xfs/xfs_trans.h    |  4 ----
 5 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 0ece5de9dd711..09bfe9c52dbdb 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -955,23 +955,6 @@ xfs_buf_item_relse(
 	xfs_buf_item_free(bip);
 }
 
-
-/*
- * Add the given log item with its callback to the list of callbacks
- * to be called when the buffer's I/O completes.
- */
-void
-xfs_buf_attach_iodone(
-	struct xfs_buf		*bp,
-	void			(*cb)(struct xfs_buf *, struct xfs_log_item *),
-	struct xfs_log_item	*lip)
-{
-	ASSERT(xfs_buf_islocked(bp));
-
-	lip->li_cb = cb;
-	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
-}
-
 /*
  * Invoke the error state callback for each log item affected by the failed I/O.
  *
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 7c0bd2a210aff..23507cbb4c413 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -54,9 +54,6 @@ void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
-void	xfs_buf_attach_iodone(struct xfs_buf *,
-			      void(*)(struct xfs_buf *, struct xfs_log_item *),
-			      struct xfs_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
 void	xfs_buf_dquot_iodone(struct xfs_buf *);
 void	xfs_buf_iodone(struct xfs_buf *);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 403bc4e9f21ff..d5984a926d1d0 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1187,11 +1187,11 @@ xfs_qm_dqflush(
 	}
 
 	/*
-	 * Attach an iodone routine so that we can remove this dquot from the
-	 * AIL and release the flush lock once the dquot is synced to disk.
+	 * Attach the dquot to the buffer so that we can remove this dquot from
+	 * the AIL and release the flush lock once the dquot is synced to disk.
 	 */
 	bp->b_flags |= _XBF_DQUOTS;
-	xfs_buf_attach_iodone(bp, NULL, &dqp->q_logitem.qli_item);
+	list_add_tail(&dqp->q_logitem.qli_item.li_bio_list, &bp->b_li_list);
 
 	/*
 	 * If the buffer is pinned then push on the log so we won't
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1b4e8e0bb0cf0..272b54cf97000 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2709,7 +2709,8 @@ xfs_ifree_cluster(
 			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 						&iip->ili_item.li_lsn);
 
-			xfs_buf_attach_iodone(bp, NULL, &iip->ili_item);
+			list_add_tail(&iip->ili_item.li_bio_list,
+						&bp->b_li_list);
 
 			if (ip != free_ip)
 				xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -3859,7 +3860,7 @@ xfs_iflush_int(
 	 * the flush lock.
 	 */
 	bp->b_flags |= _XBF_INODES;
-	xfs_buf_attach_iodone(bp, NULL, &iip->ili_item);
+	list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
 
 	/* generate the checksum. */
 	xfs_dinode_calc_crc(mp, dip);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 8308bf6d7e404..99a9ab9cab25b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -37,10 +37,6 @@ struct xfs_log_item {
 	unsigned long			li_flags;	/* misc flags */
 	struct xfs_buf			*li_buf;	/* real buffer pointer */
 	struct list_head		li_bio_list;	/* buffer item list */
-	void				(*li_cb)(struct xfs_buf *,
-						 struct xfs_log_item *);
-							/* buffer item iodone */
-							/* callback func */
 	const struct xfs_item_ops	*li_ops;	/* function list */
 
 	/* delayed logging */
-- 
2.26.2.761.g0e0b3e54be

