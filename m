Return-Path: <linux-xfs+bounces-20245-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC41A465B0
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Feb 2025 16:56:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65E013B117F
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Feb 2025 15:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 879E621CC6B;
	Wed, 26 Feb 2025 15:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aNG4JasE"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D96C21C9EE
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 15:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740585169; cv=none; b=E1FrpzalXqHba884pWQ1U3L8S2JnC49wOwE8pwt5AKIn5ah65yzANzLPqz+lSka3kT74vqrBig92WejYdJ3axkm7fadiG2bcWQBO+Zoqv9AWlraNdh4MU9gTFTMhjMxFnJ7maUUmIjgKywlpsKHINUHTlERAjFGMxNmZzIbl7gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740585169; c=relaxed/simple;
	bh=atgATXpH1lswt9o/sFitM+TJ1XJ7Mo/NHkULWaroqmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMLcOpIJe9uDTeTYf5XE6PrKfFrM1qL5cI8lMaA3D+FPpOVnHQGRcl8iCBpA3lo/S6ovNYzP9F+jfI+yG1Pxhwcl2GiCUIRd81SQx31Ik7Da99FvP+am5b2HfnRM3oDwmzOxNyFE86zMRr29LzvHNH7KQqm2ZRJgce0PB/0CxH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aNG4JasE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=myLPhAFKh3abcIIW+nj6ElRbOG2effVawlV8DvFTunM=; b=aNG4JasEZb9/INnpibdGna451+
	76X9baPCX7f1/h9/da9NxwskPJOU3UoGF4nalJCxdSyhWb6g/dSiq8raSsqFdg6vfaCboaB3C3qx/
	cMfl6OVZ5qG7xERoz31xxqDtefxdLyBuj4tNCf05ui3eU0gpNsgdZFD183J8Nlag135aNGZid4DeF
	1Ja8wp0mYxmZBX10UCXu1KtqxnACjkYymMZ9mCFJI0g2vif/MRMZY4Mw6eAN50wE7zbMX6lXSPnc4
	2JdjglP1kP4CRqU5tkoC9eDanNWzF58Ozau5/+pokue9dcF+XJ9HkQo6umkj7sI+oQs5HdJNpIa3e
	ZZEq3LLw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnJiI-00000004PMR-47q4;
	Wed, 26 Feb 2025 15:52:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/12] xfs: kill XBF_UNMAPPED
Date: Wed, 26 Feb 2025 07:51:36 -0800
Message-ID: <20250226155245.513494-9-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226155245.513494-1-hch@lst.de>
References: <20250226155245.513494-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Unmapped buffer access is a pain, so kill it. The switch to large
folios means we rarely pay a vmap penalty for large buffers,
so this functionality is largely unnecessary now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c    |  2 +-
 fs/xfs/libxfs/xfs_inode_buf.c |  2 +-
 fs/xfs/scrub/inode_repair.c   |  3 +-
 fs/xfs/xfs_buf.c              | 58 +++--------------------------------
 fs/xfs/xfs_buf.h              | 16 +++++++---
 fs/xfs/xfs_buf_item.c         |  2 +-
 fs/xfs/xfs_buf_item_recover.c |  8 +----
 fs/xfs/xfs_inode.c            |  3 +-
 8 files changed, 21 insertions(+), 73 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index f3a840a425f5..24b133930368 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -364,7 +364,7 @@ xfs_ialloc_inode_init(
 				(j * M_IGEO(mp)->blocks_per_cluster));
 		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
 				mp->m_bsize * M_IGEO(mp)->blocks_per_cluster,
-				XBF_UNMAPPED, &fbuf);
+				0, &fbuf);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index f24fa628fecf..2f575b88cd7c 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -137,7 +137,7 @@ xfs_imap_to_bp(
 	int			error;
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, imap->im_blkno,
-			imap->im_len, XBF_UNMAPPED, bpp, &xfs_inode_buf_ops);
+			imap->im_len, 0, bpp, &xfs_inode_buf_ops);
 	if (xfs_metadata_is_sick(error))
 		xfs_agno_mark_sick(mp, xfs_daddr_to_agno(mp, imap->im_blkno),
 				XFS_SICK_AG_INODES);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 13ff1c933cb8..2d2ff07e63e5 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1558,8 +1558,7 @@ xrep_dinode_core(
 
 	/* Read the inode cluster buffer. */
 	error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
-			ri->imap.im_blkno, ri->imap.im_len, XBF_UNMAPPED, &bp,
-			NULL);
+			ri->imap.im_blkno, ri->imap.im_len, 0, &bp, NULL);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 3c582eaa656d..15087f24372f 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -203,7 +203,7 @@ _xfs_buf_alloc(
 	 * We don't want certain flags to appear in b_flags unless they are
 	 * specifically set by later operations on the buffer.
 	 */
-	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
+	flags &= ~(XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
 
 	/*
 	 * A new buffer is held and locked by the owner.  This ensures that the
@@ -349,9 +349,7 @@ xfs_buf_alloc_kmem(
  *
  * The third type of buffer is the multi-page buffer. These are always made
  * up of single pages so that they can be fed to vmap_ram() to return a
- * contiguous memory region we can access the data through, or mark it as
- * XBF_UNMAPPED and access the data directly through individual page_address()
- * calls.
+ * contiguous memory region we can access the data through.
  */
 static int
 xfs_buf_alloc_backing_mem(
@@ -474,8 +472,6 @@ _xfs_buf_map_pages(
 	if (bp->b_page_count == 1) {
 		/* A single page buffer is always mappable */
 		bp->b_addr = page_address(bp->b_pages[0]);
-	} else if (flags & XBF_UNMAPPED) {
-		bp->b_addr = NULL;
 	} else {
 		int retried = 0;
 		unsigned nofs_flag;
@@ -1411,7 +1407,7 @@ xfs_buf_ioend(
 	trace_xfs_buf_iodone(bp, _RET_IP_);
 
 	if (bp->b_flags & XBF_READ) {
-		if (!bp->b_error && bp->b_addr && is_vmalloc_addr(bp->b_addr))
+		if (!bp->b_error && is_vmalloc_addr(bp->b_addr))
 			invalidate_kernel_vmap_range(bp->b_addr,
 					xfs_buf_vmap_len(bp));
 		if (!bp->b_error && bp->b_ops)
@@ -1583,7 +1579,7 @@ xfs_buf_submit_bio(
 			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
 		bio->bi_iter.bi_size = size; /* limit to the actual size used */
 
-		if (bp->b_addr && is_vmalloc_addr(bp->b_addr))
+		if (is_vmalloc_addr(bp->b_addr))
 			flush_kernel_vmap_range(bp->b_addr,
 					xfs_buf_vmap_len(bp));
 	}
@@ -1715,52 +1711,6 @@ xfs_buf_submit(
 	xfs_buf_submit_bio(bp);
 }
 
-void *
-xfs_buf_offset(
-	struct xfs_buf		*bp,
-	size_t			offset)
-{
-	struct page		*page;
-
-	if (bp->b_addr)
-		return bp->b_addr + offset;
-
-	page = bp->b_pages[offset >> PAGE_SHIFT];
-	return page_address(page) + (offset & (PAGE_SIZE-1));
-}
-
-void
-xfs_buf_zero(
-	struct xfs_buf		*bp,
-	size_t			boff,
-	size_t			bsize)
-{
-	size_t			bend;
-
-	if (bp->b_addr) {
-		memset(bp->b_addr + boff, 0, bsize);
-		return;
-	}
-
-	bend = boff + bsize;
-	while (boff < bend) {
-		struct page	*page;
-		int		page_index, page_offset, csize;
-
-		page_index = boff >> PAGE_SHIFT;
-		page_offset = boff & ~PAGE_MASK;
-		page = bp->b_pages[page_index];
-		csize = min_t(size_t, PAGE_SIZE - page_offset,
-				      BBTOB(bp->b_length) - boff);
-
-		ASSERT((csize + page_offset) <= PAGE_SIZE);
-
-		memset(page_address(page) + page_offset, 0, csize);
-
-		boff += csize;
-	}
-}
-
 /*
  * Log a message about and stale a buffer that a caller has decided is corrupt.
  *
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index dc41b617b067..57faed82e93c 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -49,7 +49,6 @@ struct xfs_buf;
 #define XBF_LIVESCAN	 (1u << 28)
 #define XBF_INCORE	 (1u << 29)/* lookup only, return if found in cache */
 #define XBF_TRYLOCK	 (1u << 30)/* lock requested, but do not wait */
-#define XBF_UNMAPPED	 (1u << 31)/* do not map the buffer */
 
 
 typedef unsigned int xfs_buf_flags_t;
@@ -70,8 +69,7 @@ typedef unsigned int xfs_buf_flags_t;
 	/* The following interface flags should never be set */ \
 	{ XBF_LIVESCAN,		"LIVESCAN" }, \
 	{ XBF_INCORE,		"INCORE" }, \
-	{ XBF_TRYLOCK,		"TRYLOCK" }, \
-	{ XBF_UNMAPPED,		"UNMAPPED" }
+	{ XBF_TRYLOCK,		"TRYLOCK" }
 
 /*
  * Internal state flags.
@@ -316,12 +314,20 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
 extern void xfs_buf_ioerror_alert(struct xfs_buf *bp, xfs_failaddr_t fa);
 void xfs_buf_ioend_fail(struct xfs_buf *);
-void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize);
 void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
 
 /* Buffer Utility Routines */
-extern void *xfs_buf_offset(struct xfs_buf *, size_t);
+static inline void *xfs_buf_offset(struct xfs_buf *bp, size_t offset)
+{
+	return bp->b_addr + offset;
+}
+
+static inline void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize)
+{
+	memset(bp->b_addr + boff, 0, bsize);
+}
+
 extern void xfs_buf_stale(struct xfs_buf *bp);
 
 /* Delayed Write Buffer Routines */
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 0ee6fa9efd18..41f0bc9aa5f4 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -70,7 +70,7 @@ xfs_buf_item_straddle(
 {
 	void			*first, *last;
 
-	if (bp->b_page_count == 1 || !(bp->b_flags & XBF_UNMAPPED))
+	if (bp->b_page_count == 1)
 		return false;
 
 	first = xfs_buf_offset(bp, offset + (first_bit << XFS_BLF_SHIFT));
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 05a2f6927c12..d4c5cef5bc43 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1006,7 +1006,6 @@ xlog_recover_buf_commit_pass2(
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_buf			*bp;
 	int				error;
-	uint				buf_flags;
 	xfs_lsn_t			lsn;
 
 	/*
@@ -1025,13 +1024,8 @@ xlog_recover_buf_commit_pass2(
 	}
 
 	trace_xfs_log_recover_buf_recover(log, buf_f);
-
-	buf_flags = 0;
-	if (buf_f->blf_flags & XFS_BLF_INODE_BUF)
-		buf_flags |= XBF_UNMAPPED;
-
 	error = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
-			  buf_flags, &bp, NULL);
+			  0, &bp, NULL);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b1f9f156ec88..36cfd9c457ce 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1721,8 +1721,7 @@ xfs_ifree_cluster(
 		 * to mark all the active inodes on the buffer stale.
 		 */
 		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
-				mp->m_bsize * igeo->blocks_per_cluster,
-				XBF_UNMAPPED, &bp);
+				mp->m_bsize * igeo->blocks_per_cluster, 0, &bp);
 		if (error)
 			return error;
 
-- 
2.45.2


