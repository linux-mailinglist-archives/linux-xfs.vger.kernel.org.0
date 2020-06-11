Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782011F5FC8
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Jun 2020 03:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgFKB6x (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Jun 2020 21:58:53 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:51487 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbgFKB6v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jun 2020 21:58:51 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 903CC104024
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2020 11:58:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jjCUL-0002Fm-QQ
        for linux-xfs@vger.kernel.org; Thu, 11 Jun 2020 11:58:41 +1000
Date:   Thu, 11 Jun 2020 11:58:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 29/30 V2] xfs: factor xfs_iflush_done
Message-ID: <20200611015841.GP2040@dread.disaster.area>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-30-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604074606.266213-30-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=5dYq1025zWcnlPueRbEA:9 a=CjuIK1q_8ugA:10
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


From: Dave Chinner <dchinner@redhat.com>

xfs_iflush_done() does 3 distinct operations to the inodes attached
to the buffer. Separate these operations out into functions so that
it is easier to modify these operations independently in future.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
V2:
- always clear XFS_LI_FAILED for items requiring AIL processing

 fs/xfs/xfs_inode_item.c | 155 +++++++++++++++++++++++++-----------------------
 1 file changed, 81 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 4e7fce8d4f7cb..90a386dc09655 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -641,101 +641,63 @@ xfs_inode_item_destroy(
 
 
 /*
- * This is the inode flushing I/O completion routine.  It is called
- * from interrupt level when the buffer containing the inode is
- * flushed to disk.  It is responsible for removing the inode item
- * from the AIL if it has not been re-logged, and unlocking the inode's
- * flush lock.
- *
- * To reduce AIL lock traffic as much as possible, we scan the buffer log item
- * list for other inodes that will run this function. We remove them from the
- * buffer list so we can process all the inode IO completions in one AIL lock
- * traversal.
- *
- * Note: Now that we attach the log item to the buffer when we first log the
- * inode in memory, we can have unflushed inodes on the buffer list here. These
- * inodes will have a zero ili_last_fields, so skip over them here.
+ * We only want to pull the item from the AIL if it is actually there
+ * and its location in the log has not changed since we started the
+ * flush.  Thus, we only bother if the inode's lsn has not changed.
  */
 void
-xfs_iflush_done(
-	struct xfs_buf		*bp)
+xfs_iflush_ail_updates(
+	struct xfs_ail		*ailp,
+	struct list_head	*list)
 {
-	struct xfs_inode_log_item *iip;
-	struct xfs_log_item	*lip, *n;
-	struct xfs_ail		*ailp = bp->b_mount->m_ail;
-	int			need_ail = 0;
-	LIST_HEAD(tmp);
+	struct xfs_log_item	*lip;
+	xfs_lsn_t		tail_lsn = 0;
 
-	/*
-	 * Pull the attached inodes from the buffer one at a time and take the
-	 * appropriate action on them.
-	 */
-	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
-		iip = INODE_ITEM(lip);
-
-		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
-			xfs_iflush_abort(iip->ili_inode);
-			continue;
-		}
+	/* this is an opencoded batch version of xfs_trans_ail_delete */
+	spin_lock(&ailp->ail_lock);
+	list_for_each_entry(lip, list, li_bio_list) {
+		xfs_lsn_t	lsn;
 
-		if (!iip->ili_last_fields)
+		clear_bit(XFS_LI_FAILED, &lip->li_flags);
+		if (INODE_ITEM(lip)->ili_flush_lsn != lip->li_lsn)
 			continue;
 
-		list_move_tail(&lip->li_bio_list, &tmp);
-
-		/* Do an unlocked check for needing the AIL lock. */
-		if (iip->ili_flush_lsn == lip->li_lsn ||
-		    test_bit(XFS_LI_FAILED, &lip->li_flags))
-			need_ail++;
+		lsn = xfs_ail_delete_one(ailp, lip);
+		if (!tail_lsn && lsn)
+			tail_lsn = lsn;
 	}
+	xfs_ail_update_finish(ailp, tail_lsn);
+}
 
-	/*
-	 * We only want to pull the item from the AIL if it is actually there
-	 * and its location in the log has not changed since we started the
-	 * flush.  Thus, we only bother if the inode's lsn has not changed.
-	 */
-	if (need_ail) {
-		xfs_lsn_t	tail_lsn = 0;
-
-		/* this is an opencoded batch version of xfs_trans_ail_delete */
-		spin_lock(&ailp->ail_lock);
-		list_for_each_entry(lip, &tmp, li_bio_list) {
-			clear_bit(XFS_LI_FAILED, &lip->li_flags);
-			if (lip->li_lsn == INODE_ITEM(lip)->ili_flush_lsn) {
-				xfs_lsn_t lsn = xfs_ail_delete_one(ailp, lip);
-				if (!tail_lsn && lsn)
-					tail_lsn = lsn;
-			}
-		}
-		xfs_ail_update_finish(ailp, tail_lsn);
-	}
+/*
+ * Walk the list of inodes that have completed their IOs. If they are clean
+ * remove them from the list and dissociate them from the buffer. Buffers that
+ * are still dirty remain linked to the buffer and on the list. Caller must
+ * handle them appropriately.
+ */
+void
+xfs_iflush_finish(
+	struct xfs_buf		*bp,
+	struct list_head	*list)
+{
+	struct xfs_log_item	*lip, *n;
 
-	/*
-	 * Clean up and unlock the flush lock now we are done. We can clear the
-	 * ili_last_fields bits now that we know that the data corresponding to
-	 * them is safely on disk.
-	 */
-	list_for_each_entry_safe(lip, n, &tmp, li_bio_list) {
+	list_for_each_entry_safe(lip, n, list, li_bio_list) {
+		struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 		bool	drop_buffer = false;
 
-		list_del_init(&lip->li_bio_list);
-		iip = INODE_ITEM(lip);
-
 		spin_lock(&iip->ili_lock);
 
 		/*
 		 * Remove the reference to the cluster buffer if the inode is
-		 * clean in memory. Drop the buffer reference once we've dropped
-		 * the locks we hold. If the inode is dirty in memory, we need
-		 * to put the inode item back on the buffer list for another
-		 * pass through the flush machinery.
+		 * clean in memory and drop the buffer reference once we've
+		 * dropped the locks we hold.
 		 */
 		ASSERT(iip->ili_item.li_buf == bp);
 		if (!iip->ili_fields) {
 			iip->ili_item.li_buf = NULL;
+			list_del_init(&lip->li_bio_list);
 			drop_buffer = true;
-		} else {
-			list_add(&lip->li_bio_list, &bp->b_li_list);
 		}
 		iip->ili_last_fields = 0;
 		iip->ili_flush_lsn = 0;
@@ -746,6 +708,51 @@ xfs_iflush_done(
 	}
 }
 
+/*
+ * Inode buffer IO completion routine.  It is responsible for removing inodes
+ * attached to the buffer from the AIL if they have not been re-logged, as well
+ * as completing the flush and unlocking the inode.
+ */
+void
+xfs_iflush_done(
+	struct xfs_buf		*bp)
+{
+	struct xfs_log_item	*lip, *n;
+	LIST_HEAD(flushed_inodes);
+	LIST_HEAD(ail_updates);
+
+	/*
+	 * Pull the attached inodes from the buffer one at a time and take the
+	 * appropriate action on them.
+	 */
+	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
+		struct xfs_inode_log_item *iip = INODE_ITEM(lip);
+
+		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
+			xfs_iflush_abort(iip->ili_inode);
+			continue;
+		}
+		if (!iip->ili_last_fields)
+			continue;
+
+		/* Do an unlocked check for needing the AIL lock. */
+		if (iip->ili_flush_lsn == lip->li_lsn ||
+		    test_bit(XFS_LI_FAILED, &lip->li_flags))
+			list_move_tail(&lip->li_bio_list, &ail_updates);
+		else
+			list_move_tail(&lip->li_bio_list, &flushed_inodes);
+	}
+
+	if (!list_empty(&ail_updates)) {
+		xfs_iflush_ail_updates(bp->b_mount->m_ail, &ail_updates);
+		list_splice_tail(&ail_updates, &flushed_inodes);
+	}
+
+	xfs_iflush_finish(bp, &flushed_inodes);
+	if (!list_empty(&flushed_inodes))
+		list_splice_tail(&flushed_inodes, &bp->b_li_list);
+}
+
 /*
  * This is the inode flushing abort routine.  It is called from xfs_iflush when
  * the filesystem is shutting down to clean up the inode state.  It is
