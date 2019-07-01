Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A45F820158
	for <lists+linux-xfs@lfdr.de>; Thu, 16 May 2019 10:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfEPIbi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 May 2019 04:31:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfEPIbi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 May 2019 04:31:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MO8F2PHNAlRoZbrnSCn6kyO7zIln75FBT0/sQMV781c=; b=O4LhomSzUh9EUUHp/Ut2JukIL
        P0pmctO7KFROMUumLXjoxybgkYA2pwJi68XjpdyoNlUtXPIE8T44wHUojt19VBVo//az6bIffvbIc
        6+X5zak9pZdrrUqNyRW/o0fVqQWfO6ZNq8quDi3rNI3DH/OgYnCw+leiqmVZoSDV7/0cpLyna2qhR
        nJM6y5GfxQmsirl8xsxnfWecp7d58YkQucshQw98ixnv2clnrMEuRS04oN9snqA+pvkHBOpWPbmAl
        ob7zCifiT7GjLratOvgDHdHeUHKcSCKDf+Xyy3OeVRiqTA3TRFs2AXm6CygDV36LjeubYFJru+zlm
        WH50+E99Q==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRBnd-0000v0-5c
        for linux-xfs@vger.kernel.org; Thu, 16 May 2019 08:31:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: merge xfs_buf_zero and xfs_buf_iomove
Date:   Thu, 16 May 2019 10:30:50 +0200
Message-Id: <20190516083050.19610-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_buf_zero is the only caller of xfs_buf_iomove.  Remove support
for copying from or to the buffer in xfs_buf_iomove and merge the
two functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 25 +++++--------------------
 fs/xfs/xfs_buf.h | 11 +----------
 2 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 548344e25128..be8afa1673c7 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1613,16 +1613,11 @@ xfs_buf_offset(
 	return page_address(page) + (offset & (PAGE_SIZE-1));
 }
 
-/*
- *	Move data into or out of a buffer.
- */
 void
-xfs_buf_iomove(
-	xfs_buf_t		*bp,	/* buffer to process		*/
-	size_t			boff,	/* starting buffer offset	*/
-	size_t			bsize,	/* length to copy		*/
-	void			*data,	/* data address			*/
-	xfs_buf_rw_t		mode)	/* read/write/zero flag		*/
+xfs_buf_zero(
+	struct xfs_buf		*bp,
+	size_t			boff,
+	size_t			bsize)
 {
 	size_t			bend;
 
@@ -1639,19 +1634,9 @@ xfs_buf_iomove(
 
 		ASSERT((csize + page_offset) <= PAGE_SIZE);
 
-		switch (mode) {
-		case XBRW_ZERO:
-			memset(page_address(page) + page_offset, 0, csize);
-			break;
-		case XBRW_READ:
-			memcpy(data, page_address(page) + page_offset, csize);
-			break;
-		case XBRW_WRITE:
-			memcpy(page_address(page) + page_offset, data, csize);
-		}
+		memset(page_address(page) + page_offset, 0, csize);
 
 		boff += csize;
-		data += csize;
 	}
 }
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index d0b96e071cec..1701efee4fd4 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -21,12 +21,6 @@
 
 #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
 
-typedef enum {
-	XBRW_READ = 1,			/* transfer into target memory */
-	XBRW_WRITE = 2,			/* transfer from target memory */
-	XBRW_ZERO = 3,			/* Zero target memory */
-} xfs_buf_rw_t;
-
 #define XBF_READ	 (1 << 0) /* buffer intended for reading from device */
 #define XBF_WRITE	 (1 << 1) /* buffer intended for writing to device */
 #define XBF_READ_AHEAD	 (1 << 2) /* asynchronous read-ahead */
@@ -305,10 +299,7 @@ static inline int xfs_buf_submit(struct xfs_buf *bp)
 	return __xfs_buf_submit(bp, wait);
 }
 
-extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
-				xfs_buf_rw_t);
-#define xfs_buf_zero(bp, off, len) \
-	    xfs_buf_iomove((bp), (off), (len), NULL, XBRW_ZERO)
+void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize);
 
 /* Buffer Utility Routines */
 extern void *xfs_buf_offset(struct xfs_buf *, size_t);
-- 
2.20.1

