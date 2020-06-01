Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A761EB132
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jun 2020 23:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgFAVnF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jun 2020 17:43:05 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:40430 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728829AbgFAVnD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 17:43:03 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 6FE555AABF6
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 07:42:55 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-0000Wm-Cz
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-00HU5l-46
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/30] xfs: unwind log item error flagging
Date:   Tue,  2 Jun 2020 07:42:35 +1000
Message-Id: <20200601214251.4167140-15-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200601214251.4167140-1-david@fromorbit.com>
References: <20200601214251.4167140-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=T7xEnian507jIie1A9MA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When an buffer IO error occurs, we want to mark all
the log items attached to the buffer as failed. Open code
the error handling loop so that we can modify the flagging for the
different types of objects directly and independently of each other.

This also allows us to remove the ->iop_error method from the log
item operations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c   | 48 ++++++++++++-----------------------------
 fs/xfs/xfs_dquot_item.c | 18 ----------------
 fs/xfs/xfs_inode_item.c | 18 ----------------
 fs/xfs/xfs_trans.h      |  1 -
 4 files changed, 14 insertions(+), 71 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index b6995719e877b..2364a9aa2d71a 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -12,6 +12,7 @@
 #include "xfs_bit.h"
 #include "xfs_mount.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
@@ -955,37 +956,6 @@ xfs_buf_item_relse(
 	xfs_buf_item_free(bip);
 }
 
-/*
- * Invoke the error state callback for each log item affected by the failed I/O.
- *
- * If a metadata buffer write fails with a non-permanent error, the buffer is
- * eventually resubmitted and so the completion callbacks are not run. The error
- * state may need to be propagated to the log items attached to the buffer,
- * however, so the next AIL push of the item knows hot to handle it correctly.
- */
-STATIC void
-xfs_buf_do_callbacks_fail(
-	struct xfs_buf		*bp)
-{
-	struct xfs_ail		*ailp = bp->b_mount->m_ail;
-	struct xfs_log_item	*lip;
-
-	/*
-	 * Buffer log item errors are handled directly by xfs_buf_item_push()
-	 * and xfs_buf_iodone_callback_error, and they have no IO error
-	 * callbacks. Check only for items in b_li_list.
-	 */
-	if (list_empty(&bp->b_li_list))
-		return;
-
-	spin_lock(&ailp->ail_lock);
-	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
-		if (lip->li_ops->iop_error)
-			lip->li_ops->iop_error(lip, bp);
-	}
-	spin_unlock(&ailp->ail_lock);
-}
-
 static bool
 xfs_buf_ioerror_sync(
 	struct xfs_buf		*bp)
@@ -1154,13 +1124,18 @@ xfs_buf_inode_iodone(
 	struct xfs_buf		*bp)
 {
 	if (bp->b_error) {
+		struct xfs_log_item *lip;
 		int ret = xfs_buf_iodone_error(bp);
 		if (!ret)
 			goto finish_iodone;
 		if (ret == 1)
 			return;
 		ASSERT(ret == 2);
-		xfs_buf_do_callbacks_fail(bp);
+		spin_lock(&bp->b_mount->m_ail->ail_lock);
+		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
+			xfs_set_li_failed(lip, bp);
+		}
+		spin_unlock(&bp->b_mount->m_ail->ail_lock);
 		xfs_buf_relse(bp);
 		return;
 	}
@@ -1180,13 +1155,18 @@ xfs_buf_dquot_iodone(
 	struct xfs_buf		*bp)
 {
 	if (bp->b_error) {
+		struct xfs_log_item *lip;
 		int ret = xfs_buf_iodone_error(bp);
 		if (!ret)
 			goto finish_iodone;
 		if (ret == 1)
 			return;
 		ASSERT(ret == 2);
-		xfs_buf_do_callbacks_fail(bp);
+		spin_lock(&bp->b_mount->m_ail->ail_lock);
+		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
+			xfs_set_li_failed(lip, bp);
+		}
+		spin_unlock(&bp->b_mount->m_ail->ail_lock);
 		xfs_buf_relse(bp);
 		return;
 	}
@@ -1216,7 +1196,7 @@ xfs_buf_iodone(
 		if (ret == 1)
 			return;
 		ASSERT(ret == 2);
-		xfs_buf_do_callbacks_fail(bp);
+		ASSERT(list_empty(&bp->b_li_list));
 		xfs_buf_relse(bp);
 		return;
 	}
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 349c92d26570c..d7e4de7151d7f 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -113,23 +113,6 @@ xfs_qm_dqunpin_wait(
 	wait_event(dqp->q_pinwait, (atomic_read(&dqp->q_pincount) == 0));
 }
 
-/*
- * Callback used to mark a buffer with XFS_LI_FAILED when items in the buffer
- * have been failed during writeback
- *
- * this informs the AIL that the dquot is already flush locked on the next push,
- * and acquires a hold on the buffer to ensure that it isn't reclaimed before
- * dirty data makes it to disk.
- */
-STATIC void
-xfs_dquot_item_error(
-	struct xfs_log_item	*lip,
-	struct xfs_buf		*bp)
-{
-	ASSERT(!completion_done(&DQUOT_ITEM(lip)->qli_dquot->q_flush));
-	xfs_set_li_failed(lip, bp);
-}
-
 STATIC uint
 xfs_qm_dquot_logitem_push(
 	struct xfs_log_item	*lip,
@@ -216,7 +199,6 @@ static const struct xfs_item_ops xfs_dquot_item_ops = {
 	.iop_release	= xfs_qm_dquot_logitem_release,
 	.iop_committing	= xfs_qm_dquot_logitem_committing,
 	.iop_push	= xfs_qm_dquot_logitem_push,
-	.iop_error	= xfs_dquot_item_error
 };
 
 /*
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 7049f2ae8d186..86c783dec2bac 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -464,23 +464,6 @@ xfs_inode_item_unpin(
 		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
 }
 
-/*
- * Callback used to mark a buffer with XFS_LI_FAILED when items in the buffer
- * have been failed during writeback
- *
- * This informs the AIL that the inode is already flush locked on the next push,
- * and acquires a hold on the buffer to ensure that it isn't reclaimed before
- * dirty data makes it to disk.
- */
-STATIC void
-xfs_inode_item_error(
-	struct xfs_log_item	*lip,
-	struct xfs_buf		*bp)
-{
-	ASSERT(xfs_isiflocked(INODE_ITEM(lip)->ili_inode));
-	xfs_set_li_failed(lip, bp);
-}
-
 STATIC uint
 xfs_inode_item_push(
 	struct xfs_log_item	*lip,
@@ -619,7 +602,6 @@ static const struct xfs_item_ops xfs_inode_item_ops = {
 	.iop_committed	= xfs_inode_item_committed,
 	.iop_push	= xfs_inode_item_push,
 	.iop_committing	= xfs_inode_item_committing,
-	.iop_error	= xfs_inode_item_error
 };
 
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 99a9ab9cab25b..b752501818d25 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -74,7 +74,6 @@ struct xfs_item_ops {
 	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
 	void (*iop_release)(struct xfs_log_item *);
 	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
-	void (*iop_error)(struct xfs_log_item *, xfs_buf_t *);
 	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
 	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
 };
-- 
2.26.2.761.g0e0b3e54be

