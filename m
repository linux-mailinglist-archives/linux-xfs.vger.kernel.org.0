Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2576F25956D
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Sep 2020 17:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732021AbgIAPvC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Sep 2020 11:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731776AbgIAPuX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:50:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2387DC061245
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 08:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=vI8AQ+/G3srMwtUXSUCaoFXCcQ41VDrH2eFFot8Ycs4=; b=pPmSggt5r/Z8yRtnhSpoeDtTW+
        cqFtDpTjItmfgfqBtp605Wkc9bieSQA+GR6kkDC05PXywwgQguwAkToU5GG1Y1keX89mbpcDYGZPP
        h4NacRiOng1QHzsbGYRu0bgLIVMGtQ025pllEImXrNKKAJZxM6eugvdZdyFJY8kBqwm+pLyoWwgyI
        DKGCLNLjv0o3hLWiRQR+M0MixPcUCcM17u6/yG/qydUoHuqoRl4OxgiFdm3l1xG/XcDcdLM/4q1FX
        UBh6zF6oNCglL7gMiiJDQRoYnLKj3lvD+xKUGrgvJ2RZ8HfR/dFraI0GxPZ91FPqBemktNa6jlEvo
        x9YKroBw==;
Received: from [2001:4bb8:18c:45ba:2f95:e5:ca6b:9b4a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8Y9-0003kz-54; Tue, 01 Sep 2020 15:50:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/15] xfs: refactor the buf ioend disposition code
Date:   Tue,  1 Sep 2020 17:50:04 +0200
Message-Id: <20200901155018.2524-2-hch@lst.de>
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

Handle the no-error case in xfs_buf_iodone_error as well, and to clarify
the code rename the function, use the actual enum type as return value
and then switch on it in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf_item.c | 115 +++++++++++++++++++++++-------------------
 1 file changed, 62 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 408d1b572d3fa3..a9f6699c7b99e8 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1045,24 +1045,27 @@ xfs_buf_ioerror_permanent(
  *
  * Multi-state return value:
  *
- * XBF_IOERROR_FINISH: clear IO error retry state and run callback completions
- * XBF_IOERROR_DONE: resubmitted immediately, do not run any completions
- * XBF_IOERROR_FAIL: transient error, run failure callback completions and then
+ * XBF_IOEND_FINISH: run callback completions
+ * XBF_IOEND_DONE: resubmitted immediately, do not run any completions
+ * XBF_IOEND_FAIL: transient error, run failure callback completions and then
  *    release the buffer
  */
-enum {
-	XBF_IOERROR_FINISH,
-	XBF_IOERROR_DONE,
-	XBF_IOERROR_FAIL,
+enum xfs_buf_ioend_disposition {
+	XBF_IOEND_FINISH,
+	XBF_IOEND_DONE,
+	XBF_IOEND_FAIL,
 };
 
-static int
-xfs_buf_iodone_error(
+static enum xfs_buf_ioend_disposition
+xfs_buf_ioend_disposition(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_error_cfg	*cfg;
 
+	if (likely(!bp->b_error))
+		return XBF_IOEND_FINISH;
+
 	if (xfs_buf_ioerror_fail_without_retry(bp))
 		goto out_stale;
 
@@ -1072,7 +1075,7 @@ xfs_buf_iodone_error(
 	if (xfs_buf_ioerror_retry(bp, cfg)) {
 		xfs_buf_ioerror(bp, 0);
 		xfs_buf_submit(bp);
-		return XBF_IOERROR_DONE;
+		return XBF_IOEND_DONE;
 	}
 
 	/*
@@ -1085,13 +1088,13 @@ xfs_buf_iodone_error(
 	}
 
 	/* Still considered a transient error. Caller will schedule retries. */
-	return XBF_IOERROR_FAIL;
+	return XBF_IOEND_FAIL;
 
 out_stale:
 	xfs_buf_stale(bp);
 	bp->b_flags |= XBF_DONE;
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
-	return XBF_IOERROR_FINISH;
+	return XBF_IOEND_FINISH;
 }
 
 static void
@@ -1127,6 +1130,19 @@ xfs_buf_clear_ioerror_retry_state(
 	bp->b_first_retry_time = 0;
 }
 
+static void
+xfs_buf_inode_io_fail(
+	struct xfs_buf		*bp)
+{
+	struct xfs_log_item	*lip;
+
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
+		set_bit(XFS_LI_FAILED, &lip->li_flags);
+
+	xfs_buf_ioerror(bp, 0);
+	xfs_buf_relse(bp);
+}
+
 /*
  * Inode buffer iodone callback function.
  */
@@ -1134,30 +1150,36 @@ void
 xfs_buf_inode_iodone(
 	struct xfs_buf		*bp)
 {
-	if (bp->b_error) {
-		struct xfs_log_item *lip;
-		int ret = xfs_buf_iodone_error(bp);
-
-		if (ret == XBF_IOERROR_FINISH)
-			goto finish_iodone;
-		if (ret == XBF_IOERROR_DONE)
-			return;
-		ASSERT(ret == XBF_IOERROR_FAIL);
-		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
-			set_bit(XFS_LI_FAILED, &lip->li_flags);
-		}
-		xfs_buf_ioerror(bp, 0);
-		xfs_buf_relse(bp);
+	switch (xfs_buf_ioend_disposition(bp)) {
+	case XBF_IOEND_DONE:
+		return;
+	case XBF_IOEND_FAIL:
+		xfs_buf_inode_io_fail(bp);
 		return;
+	default:
+		break;
 	}
 
-finish_iodone:
 	xfs_buf_clear_ioerror_retry_state(bp);
 	xfs_buf_item_done(bp);
 	xfs_iflush_done(bp);
 	xfs_buf_ioend_finish(bp);
 }
 
+static void
+xfs_buf_dquot_io_fail(
+	struct xfs_buf		*bp)
+{
+	struct xfs_log_item	*lip;
+
+	spin_lock(&bp->b_mount->m_ail->ail_lock);
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
+		xfs_set_li_failed(lip, bp);
+	spin_unlock(&bp->b_mount->m_ail->ail_lock);
+	xfs_buf_ioerror(bp, 0);
+	xfs_buf_relse(bp);
+}
+
 /*
  * Dquot buffer iodone callback function.
  */
@@ -1165,26 +1187,16 @@ void
 xfs_buf_dquot_iodone(
 	struct xfs_buf		*bp)
 {
-	if (bp->b_error) {
-		struct xfs_log_item *lip;
-		int ret = xfs_buf_iodone_error(bp);
-
-		if (ret == XBF_IOERROR_FINISH)
-			goto finish_iodone;
-		if (ret == XBF_IOERROR_DONE)
-			return;
-		ASSERT(ret == XBF_IOERROR_FAIL);
-		spin_lock(&bp->b_mount->m_ail->ail_lock);
-		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
-			xfs_set_li_failed(lip, bp);
-		}
-		spin_unlock(&bp->b_mount->m_ail->ail_lock);
-		xfs_buf_ioerror(bp, 0);
-		xfs_buf_relse(bp);
+	switch (xfs_buf_ioend_disposition(bp)) {
+	case XBF_IOEND_DONE:
+		return;
+	case XBF_IOEND_FAIL:
+		xfs_buf_dquot_io_fail(bp);
 		return;
+	default:
+		break;
 	}
 
-finish_iodone:
 	xfs_buf_clear_ioerror_retry_state(bp);
 	/* a newly allocated dquot buffer might have a log item attached */
 	xfs_buf_item_done(bp);
@@ -1202,21 +1214,18 @@ void
 xfs_buf_iodone(
 	struct xfs_buf		*bp)
 {
-	if (bp->b_error) {
-		int ret = xfs_buf_iodone_error(bp);
-
-		if (ret == XBF_IOERROR_FINISH)
-			goto finish_iodone;
-		if (ret == XBF_IOERROR_DONE)
-			return;
-		ASSERT(ret == XBF_IOERROR_FAIL);
+	switch (xfs_buf_ioend_disposition(bp)) {
+	case XBF_IOEND_DONE:
+		return;
+	case XBF_IOEND_FAIL:
 		ASSERT(list_empty(&bp->b_li_list));
 		xfs_buf_ioerror(bp, 0);
 		xfs_buf_relse(bp);
 		return;
+	default:
+		break;
 	}
 
-finish_iodone:
 	xfs_buf_clear_ioerror_retry_state(bp);
 	xfs_buf_item_done(bp);
 	xfs_buf_ioend_finish(bp);
-- 
2.28.0

