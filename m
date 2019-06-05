Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBA036479
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 21:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfFETQV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 15:16:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59746 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETQV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:16:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sNydzqIIIH2xP4s/1EyEXP4NmzuIwBeCBCMP4bRwByM=; b=Ru3VtJZoUqWvPDXfRJ190AM/3X
        SBIoAybKJzaGDsl0x25ahuGWrEletPV7qpgJEmknp0DLrc2ZEi8q/mCCk8y8bvZ8jsSP8BySPPlYP
        j5FMurTSzrZhqK7fmNnEgX0NOaIjBa7xUuw2nnhUYkrK1j0jTh1b2yQexZ3KuBQXsbCUpa3ZoLL4o
        CNfMm7j6dGLhdu+00BSSbF5zfMH8mre8eOUHBOpyFglucXpTWdYatzEOsQw0gkpO3EDkHcMKKqWxI
        zDy+QRnNszF2HHBTdxkNtMxiK3SU2UdK63l3xYYgaRJ4RLU9jw2+oONdMxZm+p6XCoaq7iNL5OZyI
        xBfPBF7A==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbOW-0002Ez-S3; Wed, 05 Jun 2019 19:16:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 21/24] xfs: remove unused buffer cache APIs
Date:   Wed,  5 Jun 2019 21:15:08 +0200
Message-Id: <20190605191511.32695-22-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190605191511.32695-1-hch@lst.de>
References: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that the log code uses bios directly we can drop various special
cases in the buffer cache code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 83 ++----------------------------------------------
 fs/xfs/xfs_buf.h | 27 ----------------
 2 files changed, 2 insertions(+), 108 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ade6ec28e1c9..68444d20d2ed 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -213,7 +213,7 @@ xfs_buf_free_maps(
 	}
 }
 
-struct xfs_buf *
+static struct xfs_buf *
 _xfs_buf_alloc(
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
@@ -909,72 +909,6 @@ xfs_buf_read_uncached(
 	return 0;
 }
 
-/*
- * Return a buffer allocated as an empty buffer and associated to external
- * memory via xfs_buf_associate_memory() back to it's empty state.
- */
-void
-xfs_buf_set_empty(
-	struct xfs_buf		*bp,
-	size_t			numblks)
-{
-	if (bp->b_pages)
-		_xfs_buf_free_pages(bp);
-
-	bp->b_pages = NULL;
-	bp->b_page_count = 0;
-	bp->b_addr = NULL;
-	bp->b_length = numblks;
-	bp->b_io_length = numblks;
-
-	ASSERT(bp->b_map_count == 1);
-	bp->b_bn = XFS_BUF_DADDR_NULL;
-	bp->b_maps[0].bm_bn = XFS_BUF_DADDR_NULL;
-	bp->b_maps[0].bm_len = bp->b_length;
-}
-
-int
-xfs_buf_associate_memory(
-	xfs_buf_t		*bp,
-	void			*mem,
-	size_t			len)
-{
-	int			rval;
-	int			i = 0;
-	unsigned long		pageaddr;
-	unsigned long		offset;
-	size_t			buflen;
-	int			page_count;
-
-	pageaddr = (unsigned long)mem & PAGE_MASK;
-	offset = (unsigned long)mem - pageaddr;
-	buflen = PAGE_ALIGN(len + offset);
-	page_count = buflen >> PAGE_SHIFT;
-
-	/* Free any previous set of page pointers */
-	if (bp->b_pages)
-		_xfs_buf_free_pages(bp);
-
-	bp->b_pages = NULL;
-	bp->b_addr = mem;
-
-	rval = _xfs_buf_get_pages(bp, page_count);
-	if (rval)
-		return rval;
-
-	bp->b_offset = offset;
-
-	for (i = 0; i < bp->b_page_count; i++) {
-		bp->b_pages[i] = kmem_to_page((void *)pageaddr);
-		pageaddr += PAGE_SIZE;
-	}
-
-	bp->b_io_length = BTOBB(len);
-	bp->b_length = BTOBB(buflen);
-
-	return 0;
-}
-
 xfs_buf_t *
 xfs_buf_get_uncached(
 	struct xfs_buftarg	*target,
@@ -1258,7 +1192,7 @@ xfs_buf_ioend_async(
 	struct xfs_buf	*bp)
 {
 	INIT_WORK(&bp->b_ioend_work, xfs_buf_ioend_work);
-	queue_work(bp->b_ioend_wq, &bp->b_ioend_work);
+	queue_work(bp->b_target->bt_mount->m_buf_workqueue, &bp->b_ioend_work);
 }
 
 void
@@ -1425,21 +1359,8 @@ _xfs_buf_ioapply(
 	 */
 	bp->b_error = 0;
 
-	/*
-	 * Initialize the I/O completion workqueue if we haven't yet or the
-	 * submitter has not opted to specify a custom one.
-	 */
-	if (!bp->b_ioend_wq)
-		bp->b_ioend_wq = bp->b_target->bt_mount->m_buf_workqueue;
-
 	if (bp->b_flags & XBF_WRITE) {
 		op = REQ_OP_WRITE;
-		if (bp->b_flags & XBF_SYNCIO)
-			op_flags = REQ_SYNC;
-		if (bp->b_flags & XBF_FUA)
-			op_flags |= REQ_FUA;
-		if (bp->b_flags & XBF_FLUSH)
-			op_flags |= REQ_PREFLUSH;
 
 		/*
 		 * Run the write verifier callback function if it exists. If
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 15f6ce3974ac..c1965c7e76bb 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -36,11 +36,6 @@ typedef enum {
 #define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
 #define XBF_WRITE_FAIL	 (1 << 7) /* async writes have failed on this buffer */
 
-/* I/O hints for the BIO layer */
-#define XBF_SYNCIO	 (1 << 10)/* treat this buffer as synchronous I/O */
-#define XBF_FUA		 (1 << 11)/* force cache write through mode */
-#define XBF_FLUSH	 (1 << 12)/* flush the disk cache before a write */
-
 /* flags used only as arguments to access routines */
 #define XBF_TRYLOCK	 (1 << 16)/* lock requested, but do not wait */
 #define XBF_UNMAPPED	 (1 << 17)/* do not map the buffer */
@@ -61,9 +56,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_DONE,		"DONE" }, \
 	{ XBF_STALE,		"STALE" }, \
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
-	{ XBF_SYNCIO,		"SYNCIO" }, \
-	{ XBF_FUA,		"FUA" }, \
-	{ XBF_FLUSH,		"FLUSH" }, \
 	{ XBF_TRYLOCK,		"TRYLOCK" },	/* should never be set */\
 	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
 	{ _XBF_PAGES,		"PAGES" }, \
@@ -162,7 +154,6 @@ typedef struct xfs_buf {
 	xfs_buftarg_t		*b_target;	/* buffer target (device) */
 	void			*b_addr;	/* virtual address of buffer */
 	struct work_struct	b_ioend_work;
-	struct workqueue_struct	*b_ioend_wq;	/* I/O completion wq */
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	struct completion	b_iowait;	/* queue for I/O waiters */
 	void			*b_log_item;
@@ -207,21 +198,6 @@ struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
 			   xfs_daddr_t blkno, size_t numblks,
 			   xfs_buf_flags_t flags);
 
-struct xfs_buf *_xfs_buf_alloc(struct xfs_buftarg *target,
-			       struct xfs_buf_map *map, int nmaps,
-			       xfs_buf_flags_t flags);
-
-static inline struct xfs_buf *
-xfs_buf_alloc(
-	struct xfs_buftarg	*target,
-	xfs_daddr_t		blkno,
-	size_t			numblks,
-	xfs_buf_flags_t		flags)
-{
-	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	return _xfs_buf_alloc(target, &map, 1, flags);
-}
-
 struct xfs_buf *xfs_buf_get_map(struct xfs_buftarg *target,
 			       struct xfs_buf_map *map, int nmaps,
 			       xfs_buf_flags_t flags);
@@ -267,9 +243,6 @@ xfs_buf_readahead(
 	return xfs_buf_readahead_map(target, &map, 1, ops);
 }
 
-void xfs_buf_set_empty(struct xfs_buf *bp, size_t numblks);
-int xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t length);
-
 struct xfs_buf *xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
 				int flags);
 int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
-- 
2.20.1

