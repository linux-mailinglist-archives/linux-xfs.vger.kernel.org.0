Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE1A256BED
	for <lists+linux-xfs@lfdr.de>; Sun, 30 Aug 2020 08:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgH3GPW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 30 Aug 2020 02:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgH3GPW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Aug 2020 02:15:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DD5C061573
        for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2020 23:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=PPCvJmUAwHhHiLUMWS0+T1vrF/uuwXtFbGwE0YRmTrc=; b=iH7agswcVDXPOP0Gvq1xmOkp3k
        F0SgeiBdnfIZ7KB2tMc50p071vBAWYC6AiFIEKW9rU0tgaGYzXKvVJxx/4Gq8wuVDz0W/+V6ytGTR
        cyvsqp7tOQglBxTveX9+nmmouNOIwUM+IQ7A09csfYLKj5aKExi+yr21ocnFIv6IzkM+W09/Q+s9s
        9nHIYjO/y5am2Rx2g6x8LPhhXooDE0lcHxFhzSnSxzsvw7W21Ipfm4pTkZkuJjXxJTOjmnuYUEfY5
        WZdyKnE/USpBCLwKzgx0R8ON7Ot0jbwf0eJYJlP2RHLiRIg79NRIbspCQHJJta1lBU47Xc4sYE9iD
        V+DOB5Vg==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGca-0001xV-T5; Sun, 30 Aug 2020 06:15:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/13] xfs: fold xfs_buf_ioend_finish into xfs_ioend
Date:   Sun, 30 Aug 2020 08:15:04 +0200
Message-Id: <20200830061512.1148591-6-hch@lst.de>
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

No need to keep a separate helper for this logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c         | 8 +++++---
 fs/xfs/xfs_buf.h         | 7 -------
 fs/xfs/xfs_log_recover.c | 1 -
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 16a325d6e21f82..19a49969431b8c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1333,7 +1333,6 @@ xfs_buf_ioend(
 			bp->b_ops->verify_read(bp);
 		if (!bp->b_error)
 			bp->b_flags |= XBF_DONE;
-		xfs_buf_ioend_finish(bp);
 	} else if (bp->b_flags & _XBF_LOGRECOVERY) {
 		/*
 		 * If this is a log recovery buffer, we aren't doing
@@ -1381,9 +1380,12 @@ xfs_buf_ioend(
 			xfs_buf_inode_iodone(bp);
 		else if (bp->b_flags & _XBF_DQUOTS)
 			xfs_buf_dquot_iodone(bp);
-
-		xfs_buf_ioend_finish(bp);
 	}
+
+	if (bp->b_flags & XBF_ASYNC)
+		xfs_buf_relse(bp);
+	else
+		complete(&bp->b_iowait);
 }
 
 static void
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index bea20d43a38191..9eb4044597c985 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -269,13 +269,6 @@ static inline void xfs_buf_relse(xfs_buf_t *bp)
 
 /* Buffer Read and Write Routines */
 extern int xfs_bwrite(struct xfs_buf *bp);
-static inline void xfs_buf_ioend_finish(struct xfs_buf *bp)
-{
-	if (bp->b_flags & XBF_ASYNC)
-		xfs_buf_relse(bp);
-	else
-		complete(&bp->b_iowait);
-}
 
 extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
 		xfs_failaddr_t failaddr);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7d744df7076274..7e75c79dc31138 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -288,7 +288,6 @@ xlog_recover_iodone(
 		xfs_buf_item_relse(bp);
 	ASSERT(bp->b_log_item == NULL);
 	bp->b_flags &= ~_XBF_LOGRECOVERY;
-	xfs_buf_ioend_finish(bp);
 }
 
 /*
-- 
2.28.0

