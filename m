Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593721EB119
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jun 2020 23:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgFAVm5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Jun 2020 17:42:57 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51465 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728450AbgFAVm4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 17:42:56 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1D53B8214A6
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 07:42:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-0000WP-3c
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCp-00HU5C-Qm
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/30] xfs: call xfs_buf_iodone directly
Date:   Tue,  2 Jun 2020 07:42:28 +1000
Message-Id: <20200601214251.4167140-8-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200601214251.4167140-1-david@fromorbit.com>
References: <20200601214251.4167140-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=pGLkceISAAAA:8
        a=IyPPYMNQrFCbev4FMNYA:9 a=rY853xTI-k9CyviM:21 a=VlADrz0iGW98S6_V:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

All unmarked dirty buffers should be in the AIL and have log items
attached to them. Hence when they are written, we will run a
callback to remove the item from the AIL if appropriate. Now that
we've handled inode and dquot buffers, all remaining calls are to
xfs_buf_iodone() and so we can hard code this rather than use an
indirect call.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_buf.c       | 24 ++++++++----------------
 fs/xfs/xfs_buf.h       |  6 +-----
 fs/xfs/xfs_buf_item.c  | 40 ++++++++++------------------------------
 fs/xfs/xfs_buf_item.h  |  4 ++--
 fs/xfs/xfs_trans_buf.c | 13 +++----------
 5 files changed, 24 insertions(+), 63 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0a69de674af9d..d7695b638e994 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -658,7 +658,6 @@ xfs_buf_find(
 	 */
 	if (bp->b_flags & XBF_STALE) {
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
-		ASSERT(bp->b_iodone == NULL);
 		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
 		bp->b_ops = NULL;
 	}
@@ -1194,10 +1193,13 @@ xfs_buf_ioend(
 	if (!bp->b_error && bp->b_io_error)
 		xfs_buf_ioerror(bp, bp->b_io_error);
 
-	/* Only validate buffers that were read without errors */
-	if (read && !bp->b_error && bp->b_ops) {
-		ASSERT(!bp->b_iodone);
-		bp->b_ops->verify_read(bp);
+	if (read) {
+		if (!bp->b_error && bp->b_ops)
+			bp->b_ops->verify_read(bp);
+		if (!bp->b_error)
+			bp->b_flags |= XBF_DONE;
+		xfs_buf_ioend_finish(bp);
+		return;
 	}
 
 	if (!bp->b_error) {
@@ -1205,9 +1207,6 @@ xfs_buf_ioend(
 		bp->b_flags |= XBF_DONE;
 	}
 
-	if (read)
-		goto out_finish;
-
 	/*
 	 * If this is a log recovery buffer, we aren't doing transactional IO
 	 * yet so we need to let it handle IO completions.
@@ -1226,14 +1225,7 @@ xfs_buf_ioend(
 		xfs_buf_dquot_iodone(bp);
 		return;
 	}
-
-	if (bp->b_iodone) {
-		(*(bp->b_iodone))(bp);
-		return;
-	}
-
-out_finish:
-	xfs_buf_ioend_finish(bp);
+	xfs_buf_iodone(bp);
 }
 
 static void
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 30dabc5bae96d..755b652e695ac 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -18,6 +18,7 @@
 /*
  *	Base types
  */
+struct xfs_buf;
 
 #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
 
@@ -102,10 +103,6 @@ typedef struct xfs_buftarg {
 	struct ratelimit_state	bt_ioerror_rl;
 } xfs_buftarg_t;
 
-struct xfs_buf;
-typedef void (*xfs_buf_iodone_t)(struct xfs_buf *);
-
-
 #define XB_PAGES	2
 
 struct xfs_buf_map {
@@ -158,7 +155,6 @@ typedef struct xfs_buf {
 	xfs_buftarg_t		*b_target;	/* buffer target (device) */
 	void			*b_addr;	/* virtual address of buffer */
 	struct work_struct	b_ioend_work;
-	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	struct completion	b_iowait;	/* queue for I/O waiters */
 	struct xfs_buf_log_item	*b_log_item;
 	struct list_head	b_li_list;	/* Log items list head */
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a42cdf9ccc47d..d87ae6363a130 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -460,7 +460,6 @@ xfs_buf_item_unpin(
 			xfs_buf_do_callbacks(bp);
 			bp->b_log_item = NULL;
 			list_del_init(&bp->b_li_list);
-			bp->b_iodone = NULL;
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
@@ -936,11 +935,7 @@ xfs_buf_item_free(
 }
 
 /*
- * This is called when the buf log item is no longer needed.  It should
- * free the buf log item associated with the given buffer and clear
- * the buffer's pointer to the buf log item.  If there are no more
- * items in the list, clear the b_iodone field of the buffer (see
- * xfs_buf_attach_iodone() below).
+ * xfs_buf_item_relse() is called when the buf log item is no longer needed.
  */
 void
 xfs_buf_item_relse(
@@ -952,9 +947,6 @@ xfs_buf_item_relse(
 	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
 
 	bp->b_log_item = NULL;
-	if (list_empty(&bp->b_li_list))
-		bp->b_iodone = NULL;
-
 	xfs_buf_rele(bp);
 	xfs_buf_item_free(bip);
 }
@@ -962,10 +954,7 @@ xfs_buf_item_relse(
 
 /*
  * Add the given log item with its callback to the list of callbacks
- * to be called when the buffer's I/O completes.  If it is not set
- * already, set the buffer's b_iodone() routine to be
- * xfs_buf_iodone_callbacks() and link the log item into the list of
- * items rooted at b_li_list.
+ * to be called when the buffer's I/O completes.
  */
 void
 xfs_buf_attach_iodone(
@@ -977,10 +966,6 @@ xfs_buf_attach_iodone(
 
 	lip->li_cb = cb;
 	list_add_tail(&lip->li_bio_list, &bp->b_li_list);
-
-	ASSERT(bp->b_iodone == NULL ||
-	       bp->b_iodone == xfs_buf_iodone_callbacks);
-	bp->b_iodone = xfs_buf_iodone_callbacks;
 }
 
 /*
@@ -1096,7 +1081,6 @@ xfs_buf_iodone_callback_error(
 		goto out_stale;
 
 	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
-	ASSERT(bp->b_iodone != NULL);
 
 	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
 
@@ -1182,28 +1166,24 @@ xfs_buf_run_callbacks(
 	xfs_buf_do_callbacks(bp);
 	bp->b_log_item = NULL;
 	list_del_init(&bp->b_li_list);
-	bp->b_iodone = NULL;
 }
 
 /*
- * This is the iodone() function for buffers which have had callbacks attached
- * to them by xfs_buf_attach_iodone(). We need to iterate the items on the
- * callback list, mark the buffer as having no more callbacks and then push the
- * buffer through IO completion processing.
+ * Inode buffer iodone callback function.
  */
 void
-xfs_buf_iodone_callbacks(
+xfs_buf_inode_iodone(
 	struct xfs_buf		*bp)
 {
 	xfs_buf_run_callbacks(bp);
-	xfs_buf_ioend(bp);
+	xfs_buf_ioend_finish(bp);
 }
 
 /*
- * Inode buffer iodone callback function.
+ * Dquot buffer iodone callback function.
  */
 void
-xfs_buf_inode_iodone(
+xfs_buf_dquot_iodone(
 	struct xfs_buf		*bp)
 {
 	xfs_buf_run_callbacks(bp);
@@ -1211,10 +1191,10 @@ xfs_buf_inode_iodone(
 }
 
 /*
- * Dquot buffer iodone callback function.
+ * Dirty buffer iodone callback function.
  */
 void
-xfs_buf_dquot_iodone(
+xfs_buf_iodone(
 	struct xfs_buf		*bp)
 {
 	xfs_buf_run_callbacks(bp);
@@ -1229,7 +1209,7 @@ xfs_buf_dquot_iodone(
  * care of cleaning up the buffer itself.
  */
 void
-xfs_buf_iodone(
+xfs_buf_item_iodone(
 	struct xfs_buf		*bp,
 	struct xfs_log_item	*lip)
 {
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 27d13d29b5bbb..610cd00193289 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -57,10 +57,10 @@ bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_attach_iodone(struct xfs_buf *,
 			      void(*)(struct xfs_buf *, struct xfs_log_item *),
 			      struct xfs_log_item *);
-void	xfs_buf_iodone_callbacks(struct xfs_buf *);
-void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
+void	xfs_buf_item_iodone(struct xfs_buf *, struct xfs_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
 void	xfs_buf_dquot_iodone(struct xfs_buf *);
+void	xfs_buf_iodone(struct xfs_buf *);
 bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
 
 extern kmem_zone_t	*xfs_buf_item_zone;
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 93d62cb864c15..6752676b94fe7 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -465,24 +465,17 @@ xfs_trans_dirty_buf(
 
 	ASSERT(bp->b_transp == tp);
 	ASSERT(bip != NULL);
-	ASSERT(bp->b_iodone == NULL ||
-	       bp->b_iodone == xfs_buf_iodone_callbacks);
 
 	/*
 	 * Mark the buffer as needing to be written out eventually,
 	 * and set its iodone function to remove the buffer's buf log
 	 * item from the AIL and free it when the buffer is flushed
-	 * to disk.  See xfs_buf_attach_iodone() for more details
-	 * on li_cb and xfs_buf_iodone_callbacks().
-	 * If we end up aborting this transaction, we trap this buffer
-	 * inside the b_bdstrat callback so that this won't get written to
-	 * disk.
+	 * to disk.
 	 */
 	bp->b_flags |= XBF_DONE;
 
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
-	bp->b_iodone = xfs_buf_iodone_callbacks;
-	bip->bli_item.li_cb = xfs_buf_iodone;
+	bip->bli_item.li_cb = xfs_buf_item_iodone;
 
 	/*
 	 * If we invalidated the buffer within this transaction, then
@@ -651,7 +644,7 @@ xfs_trans_stale_inode_buf(
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 
 	bip->bli_flags |= XFS_BLI_STALE_INODE;
-	bip->bli_item.li_cb = xfs_buf_iodone;
+	bip->bli_item.li_cb = xfs_buf_item_iodone;
 	bp->b_flags |= _XBF_INODES;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
 }
-- 
2.26.2.761.g0e0b3e54be

