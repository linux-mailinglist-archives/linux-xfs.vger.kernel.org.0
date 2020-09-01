Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B7025956A
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Sep 2020 17:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgIAPuz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Sep 2020 11:50:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbgIAPug (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:50:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95112C06124F
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 08:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=t2IxOfNdC5E8zpwUwaxr6LXALDMAguSt1kWRkuujjm8=; b=l2LUQl1WZ4F1wdHLAXxbvJNnMT
        FeNvx3VZhbwb0CDduyhI7huIdFIhnWfjGyMQ1BFR2OOMuc3InFWloS6R1CPLTqfD1v2mSAIkX7JvO
        ix7gRjyjAXRQOicwWWfK/S0VS7k5gJeI6lbIbl3e6E1mNM4H9Tg6GAOqOD+sN09zrcT4rZu2wBt1F
        hwqeF83BUdJrfKzrXyHv3HfqN9qgbj+zLF90JMUYAH2TjUBOA1QV8QgLpxRKdPvTWDwvLaShEw/Jl
        gCjJEPiP/RpGVjM7Six2x5FhdoZoiqEhrWL3/AWdJJS2zMGDNEEi11TmJiCB97lLocEkVxpnsFejg
        JDwaWdbg==;
Received: from [2001:4bb8:18c:45ba:2f95:e5:ca6b:9b4a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8YF-0003mD-7z; Tue, 01 Sep 2020 15:50:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/15] xfs: move the buffer retry logic to xfs_buf.c
Date:   Tue,  1 Sep 2020 17:50:07 +0200
Message-Id: <20200901155018.2524-5-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901155018.2524-1-hch@lst.de>
References: <20200901155018.2524-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the buffer retry state machine logic to xfs_buf.c and call it once
from xfs_ioend instead of duplicating it three times for the three kinds
of buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_inode.c |   6 +-
 fs/xfs/xfs_buf.c                | 173 ++++++++++++++++++++-
 fs/xfs/xfs_buf_item.c           | 260 +-------------------------------
 fs/xfs/xfs_buf_item.h           |  12 ++
 fs/xfs/xfs_dquot.c              |  14 +-
 fs/xfs/xfs_inode.c              |   6 +-
 fs/xfs/xfs_inode_item.c         |  12 +-
 fs/xfs/xfs_inode_item.h         |   1 -
 fs/xfs/xfs_quota.h              |   8 -
 fs/xfs/xfs_trace.h              |   2 +-
 10 files changed, 215 insertions(+), 279 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index b7e222befb085f..18c391d35a3be5 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -177,9 +177,9 @@ xfs_trans_log_inode(
 
 	/*
 	 * Always OR in the bits from the ili_last_fields field.  This is to
-	 * coordinate with the xfs_iflush() and xfs_iflush_done() routines in
-	 * the eventual clearing of the ili_fields bits.  See the big comment in
-	 * xfs_iflush() for an explanation of this coordination mechanism.
+	 * coordinate with the xfs_iflush() and xfs_buf_inode_iodone() routines
+	 * in the eventual clearing of the ili_fields bits.  See the big comment
+	 * in xfs_iflush() for an explanation of this coordination mechanism.
 	 */
 	iip->ili_fields |= (flags | iip->ili_last_fields | iversion_flags);
 	spin_unlock(&iip->ili_lock);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6447cf051e08c9..16a325d6e21f82 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1171,8 +1171,145 @@ xfs_buf_wait_unpin(
 }
 
 /*
- *	Buffer Utility Routines
+ * Decide if we're going to retry the write after a failure, and prepare
+ * the buffer for retrying the write.
  */
+static bool
+xfs_buf_ioerror_fail_without_retry(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+	static unsigned long	lasttime;
+	static struct xfs_buftarg *lasttarg;
+
+	/*
+	 * If we've already decided to shutdown the filesystem because of
+	 * I/O errors, there's no point in giving this a retry.
+	 */
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return true;
+
+	if (bp->b_target != lasttarg ||
+	    time_after(jiffies, (lasttime + 5*HZ))) {
+		lasttime = jiffies;
+		xfs_buf_ioerror_alert(bp, __this_address);
+	}
+	lasttarg = bp->b_target;
+
+	/* synchronous writes will have callers process the error */
+	if (!(bp->b_flags & XBF_ASYNC))
+		return true;
+	return false;
+}
+
+static bool
+xfs_buf_ioerror_retry(
+	struct xfs_buf		*bp,
+	struct xfs_error_cfg	*cfg)
+{
+	if ((bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) &&
+	    bp->b_last_error == bp->b_error)
+		return false;
+
+	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
+	bp->b_last_error = bp->b_error;
+	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
+	    !bp->b_first_retry_time)
+		bp->b_first_retry_time = jiffies;
+	return true;
+}
+
+/*
+ * Account for this latest trip around the retry handler, and decide if
+ * we've failed enough times to constitute a permanent failure.
+ */
+static bool
+xfs_buf_ioerror_permanent(
+	struct xfs_buf		*bp,
+	struct xfs_error_cfg	*cfg)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+
+	if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
+	    ++bp->b_retries > cfg->max_retries)
+		return true;
+	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
+	    time_after(jiffies, cfg->retry_timeout + bp->b_first_retry_time))
+		return true;
+
+	/* At unmount we may treat errors differently */
+	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
+		return true;
+
+	return false;
+}
+
+/*
+ * On a sync write or shutdown we just want to stale the buffer and let the
+ * caller handle the error in bp->b_error appropriately.
+ *
+ * If the write was asynchronous then no one will be looking for the error.  If
+ * this is the first failure of this type, clear the error state and write the
+ * buffer out again. This means we always retry an async write failure at least
+ * once, but we also need to set the buffer up to behave correctly now for
+ * repeated failures.
+ *
+ * If we get repeated async write failures, then we take action according to the
+ * error configuration we have been set up to use.
+ *
+ * Multi-state return value:
+ *
+ * XBF_IOEND_FINISH: run callback completions
+ * XBF_IOEND_DONE: resubmitted immediately, do not run any completions
+ * XBF_IOEND_FAIL: transient error, run failure callback completions and then
+ *    release the buffer
+ */
+enum xfs_buf_ioend_disposition {
+	XBF_IOEND_FINISH,
+	XBF_IOEND_DONE,
+	XBF_IOEND_FAIL,
+};
+
+static enum xfs_buf_ioend_disposition
+xfs_buf_ioend_disposition(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_error_cfg	*cfg;
+
+	if (likely(!bp->b_error))
+		return XBF_IOEND_FINISH;
+
+	if (xfs_buf_ioerror_fail_without_retry(bp))
+		goto out_stale;
+
+	trace_xfs_buf_iodone_async(bp, _RET_IP_);
+
+	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
+	if (xfs_buf_ioerror_retry(bp, cfg)) {
+		xfs_buf_ioerror(bp, 0);
+		xfs_buf_submit(bp);
+		return XBF_IOEND_DONE;
+	}
+
+	/*
+	 * Permanent error - we need to trigger a shutdown if we haven't already
+	 * to indicate that inconsistency will result from this action.
+	 */
+	if (xfs_buf_ioerror_permanent(bp, cfg)) {
+		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+		goto out_stale;
+	}
+
+	/* Still considered a transient error. Caller will schedule retries. */
+	return XBF_IOEND_FAIL;
+
+out_stale:
+	xfs_buf_stale(bp);
+	bp->b_flags |= XBF_DONE;
+	trace_xfs_buf_error_relse(bp, _RET_IP_);
+	return XBF_IOEND_FINISH;
+}
 
 static void
 xfs_buf_ioend(
@@ -1210,12 +1347,42 @@ xfs_buf_ioend(
 			bp->b_flags |= XBF_DONE;
 		}
 
+		switch (xfs_buf_ioend_disposition(bp)) {
+		case XBF_IOEND_DONE:
+			return;
+		case XBF_IOEND_FAIL:
+			if (bp->b_flags & _XBF_INODES)
+				xfs_buf_inode_io_fail(bp);
+			else if (bp->b_flags & _XBF_DQUOTS)
+				xfs_buf_dquot_io_fail(bp);
+			else
+				ASSERT(list_empty(&bp->b_li_list));
+			xfs_buf_ioerror(bp, 0);
+			xfs_buf_relse(bp);
+			return;
+		default:
+			break;
+		}
+
+		/* clear the retry state */
+		bp->b_last_error = 0;
+		bp->b_retries = 0;
+		bp->b_first_retry_time = 0;
+
+		/*
+		 * Note that for things like remote attribute buffers, there may
+		 * not be a buffer log item here, so processing the buffer log
+		 * item must remain optional.
+		 */
+		if (bp->b_log_item)
+			xfs_buf_item_done(bp);
+
 		if (bp->b_flags & _XBF_INODES)
 			xfs_buf_inode_iodone(bp);
 		else if (bp->b_flags & _XBF_DQUOTS)
 			xfs_buf_dquot_iodone(bp);
-		else
-			xfs_buf_iodone(bp);
+
+		xfs_buf_ioend_finish(bp);
 	}
 }
 
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a9f6699c7b99e8..9245c62b48f9f3 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -30,8 +30,6 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
-static void xfs_buf_item_done(struct xfs_buf *bp);
-
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
 xfs_buf_log_check_iovec(
@@ -463,7 +461,7 @@ xfs_buf_item_unpin(
 		 */
 		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
 			xfs_buf_item_done(bp);
-			xfs_iflush_done(bp);
+			xfs_buf_inode_iodone(bp);
 			ASSERT(list_empty(&bp->b_li_list));
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
@@ -956,156 +954,12 @@ xfs_buf_item_relse(
 	xfs_buf_item_free(bip);
 }
 
-/*
- * Decide if we're going to retry the write after a failure, and prepare
- * the buffer for retrying the write.
- */
-static bool
-xfs_buf_ioerror_fail_without_retry(
-	struct xfs_buf		*bp)
-{
-	struct xfs_mount	*mp = bp->b_mount;
-	static ulong		lasttime;
-	static xfs_buftarg_t	*lasttarg;
-
-	/*
-	 * If we've already decided to shutdown the filesystem because of
-	 * I/O errors, there's no point in giving this a retry.
-	 */
-	if (XFS_FORCED_SHUTDOWN(mp))
-		return true;
-
-	if (bp->b_target != lasttarg ||
-	    time_after(jiffies, (lasttime + 5*HZ))) {
-		lasttime = jiffies;
-		xfs_buf_ioerror_alert(bp, __this_address);
-	}
-	lasttarg = bp->b_target;
-
-	/* synchronous writes will have callers process the error */
-	if (!(bp->b_flags & XBF_ASYNC))
-		return true;
-	return false;
-}
-
-static bool
-xfs_buf_ioerror_retry(
-	struct xfs_buf		*bp,
-	struct xfs_error_cfg	*cfg)
-{
-	if ((bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) &&
-	    bp->b_last_error == bp->b_error)
-		return false;
-
-	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
-	bp->b_last_error = bp->b_error;
-	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
-	    !bp->b_first_retry_time)
-		bp->b_first_retry_time = jiffies;
-	return true;
-}
-
-/*
- * Account for this latest trip around the retry handler, and decide if
- * we've failed enough times to constitute a permanent failure.
- */
-static bool
-xfs_buf_ioerror_permanent(
-	struct xfs_buf		*bp,
-	struct xfs_error_cfg	*cfg)
-{
-	struct xfs_mount	*mp = bp->b_mount;
-
-	if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
-	    ++bp->b_retries > cfg->max_retries)
-		return true;
-	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
-	    time_after(jiffies, cfg->retry_timeout + bp->b_first_retry_time))
-		return true;
-
-	/* At unmount we may treat errors differently */
-	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
-		return true;
-
-	return false;
-}
-
-/*
- * On a sync write or shutdown we just want to stale the buffer and let the
- * caller handle the error in bp->b_error appropriately.
- *
- * If the write was asynchronous then no one will be looking for the error.  If
- * this is the first failure of this type, clear the error state and write the
- * buffer out again. This means we always retry an async write failure at least
- * once, but we also need to set the buffer up to behave correctly now for
- * repeated failures.
- *
- * If we get repeated async write failures, then we take action according to the
- * error configuration we have been set up to use.
- *
- * Multi-state return value:
- *
- * XBF_IOEND_FINISH: run callback completions
- * XBF_IOEND_DONE: resubmitted immediately, do not run any completions
- * XBF_IOEND_FAIL: transient error, run failure callback completions and then
- *    release the buffer
- */
-enum xfs_buf_ioend_disposition {
-	XBF_IOEND_FINISH,
-	XBF_IOEND_DONE,
-	XBF_IOEND_FAIL,
-};
-
-static enum xfs_buf_ioend_disposition
-xfs_buf_ioend_disposition(
-	struct xfs_buf		*bp)
-{
-	struct xfs_mount	*mp = bp->b_mount;
-	struct xfs_error_cfg	*cfg;
-
-	if (likely(!bp->b_error))
-		return XBF_IOEND_FINISH;
-
-	if (xfs_buf_ioerror_fail_without_retry(bp))
-		goto out_stale;
-
-	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
-
-	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
-	if (xfs_buf_ioerror_retry(bp, cfg)) {
-		xfs_buf_ioerror(bp, 0);
-		xfs_buf_submit(bp);
-		return XBF_IOEND_DONE;
-	}
-
-	/*
-	 * Permanent error - we need to trigger a shutdown if we haven't already
-	 * to indicate that inconsistency will result from this action.
-	 */
-	if (xfs_buf_ioerror_permanent(bp, cfg)) {
-		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
-		goto out_stale;
-	}
-
-	/* Still considered a transient error. Caller will schedule retries. */
-	return XBF_IOEND_FAIL;
-
-out_stale:
-	xfs_buf_stale(bp);
-	bp->b_flags |= XBF_DONE;
-	trace_xfs_buf_error_relse(bp, _RET_IP_);
-	return XBF_IOEND_FINISH;
-}
-
-static void
+void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	if (!bip)
-		return;
-
 	/*
 	 * If we are forcibly shutting down, this may well be off the AIL
 	 * already. That's because we simulate the log-committed callbacks to
@@ -1120,113 +974,3 @@ xfs_buf_item_done(
 	xfs_buf_item_free(bip);
 	xfs_buf_rele(bp);
 }
-
-static inline void
-xfs_buf_clear_ioerror_retry_state(
-	struct xfs_buf		*bp)
-{
-	bp->b_last_error = 0;
-	bp->b_retries = 0;
-	bp->b_first_retry_time = 0;
-}
-
-static void
-xfs_buf_inode_io_fail(
-	struct xfs_buf		*bp)
-{
-	struct xfs_log_item	*lip;
-
-	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
-		set_bit(XFS_LI_FAILED, &lip->li_flags);
-
-	xfs_buf_ioerror(bp, 0);
-	xfs_buf_relse(bp);
-}
-
-/*
- * Inode buffer iodone callback function.
- */
-void
-xfs_buf_inode_iodone(
-	struct xfs_buf		*bp)
-{
-	switch (xfs_buf_ioend_disposition(bp)) {
-	case XBF_IOEND_DONE:
-		return;
-	case XBF_IOEND_FAIL:
-		xfs_buf_inode_io_fail(bp);
-		return;
-	default:
-		break;
-	}
-
-	xfs_buf_clear_ioerror_retry_state(bp);
-	xfs_buf_item_done(bp);
-	xfs_iflush_done(bp);
-	xfs_buf_ioend_finish(bp);
-}
-
-static void
-xfs_buf_dquot_io_fail(
-	struct xfs_buf		*bp)
-{
-	struct xfs_log_item	*lip;
-
-	spin_lock(&bp->b_mount->m_ail->ail_lock);
-	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
-		xfs_set_li_failed(lip, bp);
-	spin_unlock(&bp->b_mount->m_ail->ail_lock);
-	xfs_buf_ioerror(bp, 0);
-	xfs_buf_relse(bp);
-}
-
-/*
- * Dquot buffer iodone callback function.
- */
-void
-xfs_buf_dquot_iodone(
-	struct xfs_buf		*bp)
-{
-	switch (xfs_buf_ioend_disposition(bp)) {
-	case XBF_IOEND_DONE:
-		return;
-	case XBF_IOEND_FAIL:
-		xfs_buf_dquot_io_fail(bp);
-		return;
-	default:
-		break;
-	}
-
-	xfs_buf_clear_ioerror_retry_state(bp);
-	/* a newly allocated dquot buffer might have a log item attached */
-	xfs_buf_item_done(bp);
-	xfs_dquot_done(bp);
-	xfs_buf_ioend_finish(bp);
-}
-
-/*
- * Dirty buffer iodone callback function.
- *
- * Note that for things like remote attribute buffers, there may not be a buffer
- * log item here, so processing the buffer log item must remain be optional.
- */
-void
-xfs_buf_iodone(
-	struct xfs_buf		*bp)
-{
-	switch (xfs_buf_ioend_disposition(bp)) {
-	case XBF_IOEND_DONE:
-		return;
-	case XBF_IOEND_FAIL:
-		ASSERT(list_empty(&bp->b_li_list));
-		xfs_buf_ioerror(bp, 0);
-		xfs_buf_relse(bp);
-		return;
-	default:
-		break;
-	}
-
-	xfs_buf_clear_ioerror_retry_state(bp);
-	xfs_buf_item_done(bp);
-	xfs_buf_ioend_finish(bp);
-}
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 23507cbb4c4132..50aa0f5ef95903 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -50,12 +50,24 @@ struct xfs_buf_log_item {
 };
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
+void	xfs_buf_item_done(struct xfs_buf *bp);
 void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
 void	xfs_buf_inode_iodone(struct xfs_buf *);
+void	xfs_buf_inode_io_fail(struct xfs_buf *bp);
+#ifdef CONFIG_XFS_QUOTA
 void	xfs_buf_dquot_iodone(struct xfs_buf *);
+void	xfs_buf_dquot_io_fail(struct xfs_buf *bp);
+#else
+static inline void xfs_buf_dquot_iodone(struct xfs_buf *bp)
+{
+}
+static inline void xfs_buf_dquot_io_fail(struct xfs_buf *bp)
+{
+}
+#endif /* CONFIG_XFS_QUOTA */
 void	xfs_buf_iodone(struct xfs_buf *);
 bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index bcd73b9c29944c..0dcd912befb199 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1107,7 +1107,7 @@ xfs_qm_dqflush_done(
 }
 
 void
-xfs_dquot_done(
+xfs_buf_dquot_iodone(
 	struct xfs_buf		*bp)
 {
 	struct xfs_log_item	*lip, *n;
@@ -1118,6 +1118,18 @@ xfs_dquot_done(
 	}
 }
 
+void
+xfs_buf_dquot_io_fail(
+	struct xfs_buf		*bp)
+{
+	struct xfs_log_item	*lip;
+
+	spin_lock(&bp->b_mount->m_ail->ail_lock);
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
+		xfs_set_li_failed(lip, bp);
+	spin_unlock(&bp->b_mount->m_ail->ail_lock);
+}
+
 /* Check incore dquot for errors before we flush. */
 static xfs_failaddr_t
 xfs_qm_dqflush_check(
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c06129cffba990..41eefde762daa2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3553,8 +3553,8 @@ xfs_iflush(
 	 *
 	 * What we do is move the bits to the ili_last_fields field.  When
 	 * logging the inode, these bits are moved back to the ili_fields field.
-	 * In the xfs_iflush_done() routine we clear ili_last_fields, since we
-	 * know that the information those bits represent is permanently on
+	 * In the xfs_buf_inode_iodone() routine we clear ili_last_fields, since
+	 * we know that the information those bits represent is permanently on
 	 * disk.  As long as the flush completes before the inode is logged
 	 * again, then both ili_fields and ili_last_fields will be cleared.
 	 */
@@ -3568,7 +3568,7 @@ xfs_iflush(
 
 	/*
 	 * Store the current LSN of the inode so that we can tell whether the
-	 * item has moved in the AIL from xfs_iflush_done().
+	 * item has moved in the AIL from xfs_buf_inode_iodone().
 	 */
 	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 				&iip->ili_item.li_lsn);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 6c65938cee1ce8..6952f8d55ea5d6 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -715,7 +715,7 @@ xfs_iflush_finish(
  * as completing the flush and unlocking the inode.
  */
 void
-xfs_iflush_done(
+xfs_buf_inode_iodone(
 	struct xfs_buf		*bp)
 {
 	struct xfs_log_item	*lip, *n;
@@ -754,6 +754,16 @@ xfs_iflush_done(
 		list_splice_tail(&flushed_inodes, &bp->b_li_list);
 }
 
+void
+xfs_buf_inode_io_fail(
+	struct xfs_buf		*bp)
+{
+	struct xfs_log_item	*lip;
+
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
+		set_bit(XFS_LI_FAILED, &lip->li_flags);
+}
+
 /*
  * This is the inode flushing abort routine.  It is called from xfs_iflush when
  * the filesystem is shutting down to clean up the inode state.  It is
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 048b5e7dee901f..7154d92338a393 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -43,7 +43,6 @@ static inline int xfs_inode_clean(struct xfs_inode *ip)
 
 extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
 extern void xfs_inode_item_destroy(struct xfs_inode *);
-extern void xfs_iflush_done(struct xfs_buf *);
 extern void xfs_iflush_abort(struct xfs_inode *);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 struct xfs_inode_log_format *);
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 06b22e35fc9021..5a62398940d022 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -108,8 +108,6 @@ extern void xfs_qm_mount_quotas(struct xfs_mount *);
 extern void xfs_qm_unmount(struct xfs_mount *);
 extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 
-void		xfs_dquot_done(struct xfs_buf *);
-
 #else
 static inline int
 xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
@@ -151,12 +149,6 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 #define xfs_qm_mount_quotas(mp)
 #define xfs_qm_unmount(mp)
 #define xfs_qm_unmount_quotas(mp)
-
-static inline void xfs_dquot_done(struct xfs_buf *bp)
-{
-	return;
-}
-
 #endif /* CONFIG_XFS_QUOTA */
 
 #define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index abb1d859f226a2..bfbb26721d5436 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -338,7 +338,7 @@ DEFINE_BUF_EVENT(xfs_buf_delwri_split);
 DEFINE_BUF_EVENT(xfs_buf_delwri_pushbuf);
 DEFINE_BUF_EVENT(xfs_buf_get_uncached);
 DEFINE_BUF_EVENT(xfs_buf_item_relse);
-DEFINE_BUF_EVENT(xfs_buf_item_iodone_async);
+DEFINE_BUF_EVENT(xfs_buf_iodone_async);
 DEFINE_BUF_EVENT(xfs_buf_error_relse);
 DEFINE_BUF_EVENT(xfs_buf_wait_buftarg);
 DEFINE_BUF_EVENT(xfs_trans_read_buf_shut);
-- 
2.28.0

