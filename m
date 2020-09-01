Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF72259567
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Sep 2020 17:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgIAPux (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Sep 2020 11:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729406AbgIAPuh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:50:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B64C061260
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 08:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ww2JewZ6Z/+0nwkN0l8Lax8sigJyMnuk6WlATsDrGcU=; b=uqLcEZas/TFZ0eudQo/7Zp2ovn
        o6J3Kchh5SgbQasJofMLsxIAhx8Kt/7m8rERuSRMDUJfzNzUDvqJ+NNi/I7GWnrtDTSH6cfiGuU7u
        PTQDwXrR5FLlH2mwOIv1OUt3CMdFYcwU25SDxyE6ZfZkMYsawAjm7KjkDMpdDeOq/PRszGA9eG9os
        CXJGSUi5G0GREWN5eh3+HuyGj0xxTltl3nJiL9lWUFKif2a+apxaHdLoRNmKRs9kuaRaVo30l4icT
        GLWeM0SFCmgEla+ho8nvYBGfasgsFmXoIfkObamg4nYUS39p2aH8RzXJ4J6wHR65RDkyu1p4fahZu
        U2dN/r0w==;
Received: from [2001:4bb8:18c:45ba:2f95:e5:ca6b:9b4a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8YJ-0003mU-Gg; Tue, 01 Sep 2020 15:50:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/15] xfs: remove xfs_buf_ioerror_retry
Date:   Tue,  1 Sep 2020 17:50:10 +0200
Message-Id: <20200901155018.2524-8-hch@lst.de>
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

Merge xfs_buf_ioerror_retry into its only caller to make the resubmission
flow a little easier to follow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4e1adbb02737ec..0d4eb06826f5e7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1185,23 +1185,6 @@ xfs_buf_ioerror_alert_ratelimited(
 	lasttarg = bp->b_target;
 }
 
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
 /*
  * Account for this latest trip around the retry handler, and decide if
  * we've failed enough times to constitute a permanent failure.
@@ -1281,10 +1264,13 @@ xfs_buf_ioend_disposition(
 	trace_xfs_buf_iodone_async(bp, _RET_IP_);
 
 	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
-	if (xfs_buf_ioerror_retry(bp, cfg)) {
-		xfs_buf_ioerror(bp, 0);
-		xfs_buf_submit(bp);
-		return XBF_IOEND_DONE;
+	if (bp->b_last_error != bp->b_error ||
+	    !(bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL))) {
+		bp->b_last_error = bp->b_error;
+		if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
+		    !bp->b_first_retry_time)
+			bp->b_first_retry_time = jiffies;
+		goto resubmit;
 	}
 
 	/*
@@ -1299,6 +1285,11 @@ xfs_buf_ioend_disposition(
 	/* Still considered a transient error. Caller will schedule retries. */
 	return XBF_IOEND_FAIL;
 
+resubmit:
+	xfs_buf_ioerror(bp, 0);
+	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
+	xfs_buf_submit(bp);
+	return XBF_IOEND_DONE;
 out_stale:
 	xfs_buf_stale(bp);
 	bp->b_flags |= XBF_DONE;
-- 
2.28.0

