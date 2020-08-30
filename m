Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2D8256BF1
	for <lists+linux-xfs@lfdr.de>; Sun, 30 Aug 2020 08:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgH3GP0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 30 Aug 2020 02:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgH3GP0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Aug 2020 02:15:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FB7C061573
        for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2020 23:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=Xh2yiZ0iVg2jxQ9d6IFEI9xN8Zte1ZxLUmMPfs9v5X0=; b=lXDDzuvtk/TaiCbyQI9DhD40CA
        WM3kJ2G6Ik9p9WFmj2o6TqwB4UghqG4OBoXbV8otnoncOtGzuRnOVnX5vwpTY8QQoUUkAlEeu5h9s
        I0c/FbwcHrOa6TToett+LFO1kTvccQNRJPOpmY/yxFmb81SwssZIIDQdSSlanqyWzUGe6uiwv+7UJ
        KcNYxRqjb8YJIat2J7bhyUFYucCiRLT5EwMSKxDPdeavOdyq1FOYfz3YRGxMMGMxPKvWb48Eq5dru
        cffsi8IzVuDBKkwO8j+WQV9Rhly+DvPxW3k1NGkNxtfb6YtZEkTrJHOA185mBvmjC8tQIpM6FxDyH
        uf8NkrWQ==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGce-0001yj-No
        for linux-xfs@vger.kernel.org; Sun, 30 Aug 2020 06:15:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/13] xfs: simplify the xfs_buf_ioend_disposition calling convention
Date:   Sun, 30 Aug 2020 08:15:08 +0200
Message-Id: <20200830061512.1148591-10-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200830061512.1148591-1-hch@lst.de>
References: <20200830061512.1148591-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that all the actual error handling is in a single place,
xfs_buf_ioend_disposition just needs to return true if took ownership of
the buffer, or false if not instead of the tristate.  Also move the
error check back in the caller to optimize for the fast path, and give
the function a better fitting name.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 36 +++++++++---------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 951d9c35b3170c..13435cce2699e4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1223,29 +1223,17 @@ xfs_buf_ioerror_permanent(
  * If we get repeated async write failures, then we take action according to the
  * error configuration we have been set up to use.
  *
- * Multi-state return value:
- *
- * XBF_IOEND_FINISH: run callback completions
- * XBF_IOEND_DONE: resubmitted immediately, do not run any completions
- * XBF_IOEND_FAIL: transient error, run failure callback completions and then
- *    release the buffer
+ * Returns true if this function took care of error handling and the caller must
+ * not touch the buffer again.  Return false if the caller should proceed with
+ * normal I/O completion handling.
  */
-enum xfs_buf_ioend_disposition {
-	XBF_IOEND_FINISH,
-	XBF_IOEND_DONE,
-	XBF_IOEND_FAIL,
-};
-
-static enum xfs_buf_ioend_disposition
-xfs_buf_ioend_disposition(
+static bool
+xfs_buf_ioend_handle_error(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_error_cfg	*cfg;
 
-	if (likely(!bp->b_error))
-		return XBF_IOEND_FINISH;
-
 	/*
 	 * If we've already decided to shutdown the filesystem because of I/O
 	 * errors, there's no point in giving this a retry.
@@ -1291,18 +1279,18 @@ xfs_buf_ioend_disposition(
 		ASSERT(list_empty(&bp->b_li_list));
 	xfs_buf_ioerror(bp, 0);
 	xfs_buf_relse(bp);
-	return XBF_IOEND_FAIL;
+	return true;
 
 resubmit:
 	xfs_buf_ioerror(bp, 0);
 	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
 	xfs_buf_submit(bp);
-	return XBF_IOEND_DONE;
+	return true;
 out_stale:
 	xfs_buf_stale(bp);
 	bp->b_flags |= XBF_DONE;
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
-	return XBF_IOEND_FINISH;
+	return false;
 }
 
 static void
@@ -1340,14 +1328,8 @@ xfs_buf_ioend(
 			bp->b_flags |= XBF_DONE;
 		}
 
-		switch (xfs_buf_ioend_disposition(bp)) {
-		case XBF_IOEND_DONE:
-			return;
-		case XBF_IOEND_FAIL:
+		if (unlikely(bp->b_error) && xfs_buf_ioend_handle_error(bp))
 			return;
-		default:
-			break;
-		}
 
 		/* clear the retry state */
 		bp->b_last_error = 0;
-- 
2.28.0

