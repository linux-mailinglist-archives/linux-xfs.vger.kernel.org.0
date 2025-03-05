Return-Path: <linux-xfs+bounces-20511-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A59B3A50166
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Mar 2025 15:07:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B744E3AF73F
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Mar 2025 14:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E310E24E4AD;
	Wed,  5 Mar 2025 14:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V/23KEnd"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B758524C691
	for <linux-xfs@vger.kernel.org>; Wed,  5 Mar 2025 14:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741183539; cv=none; b=g4U7u/h0f4Rd5LVP+0mSxLLlny7zPE73GrZxE7kdyPc6oy4gWp0PDZ8qvYsnlqBw90sHGq1e9/R7mPYqxqvTnrz5z7ZYWddP0w/vOz1SguKq+aUqM3A+1JIz1VRlc1wvyPLr3IZUnfX7ARxv1QxaIWNQbMBYV0PXWIski3XzFBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741183539; c=relaxed/simple;
	bh=/6j0Xsf1UgvlXG3mOB/gcGQmbPvmYAE+AKRHrhvGHpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNb14MTMt4eAmp/AmFwvZ9mT+jVkesZA3M4wPJ0kUzPvLsKHx2+StUMBM6/iLEFtMoAvMZxkSyMdhTkBlaQHAKat6mapzRquE+We9doEkjdoySWtFugQVBp852q1+J0A+TUqm43QNh2MxTKH+w+DnAMjQE39/SxR6Zup6dW9UPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V/23KEnd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zP2+H4TeoKpdN8YcZNjPUzwq3WrFLmPpYzo1W26Gllk=; b=V/23KEnd0JfEHKLSFsVavVnOrH
	d3fxjux0CxQsJvzlvyXZNCp35jNfJ/8+a9sabgMSpYNxWMRMqQh9SamOjI5HwRxb7J3SOGOhbzS9k
	Uo3tMn4v/hzYZCUtSB00amfF4sdzpLUi5/XiiJB/eC8S6yowCIqcup1idGNBgnLxid6EOADW2L60F
	C1rwsl8xVOJAhYfQuzgNuovBeTaYdzdah6CWhZG+LHXh0xBmXPALZjHuKXXPxcx77Smj8rLAilcD2
	+K5DlBMx+ZJ5K0KwyWLWVz3l+EYM6mVfYFSk5tb60+MzThRtuxzWlt5l3Vd1raK6ejYJahnFQ3Qig
	fSEO9ZLA==;
Received: from [199.117.230.82] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tppNR-00000008Hpv-1HDD;
	Wed, 05 Mar 2025 14:05:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/12] xfs: use vmalloc instead of vm_map_area for buffer backing memory
Date: Wed,  5 Mar 2025 07:05:27 -0700
Message-ID: <20250305140532.158563-11-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250305140532.158563-1-hch@lst.de>
References: <20250305140532.158563-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The fallback buffer allocation path currently open codes a suboptimal
version of vmalloc to allocate pages that are then mapped into
vmalloc space.  Switch to using vmalloc instead, which uses all the
optimizations in the common vmalloc code, and removes the need to
track the backing pages in the xfs_buf structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c     | 207 ++++++++++---------------------------------
 fs/xfs/xfs_buf.h     |   7 --
 fs/xfs/xfs_buf_mem.c |  11 +--
 3 files changed, 48 insertions(+), 177 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2b4b8c104b0c..f28ca5cb5bd8 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -55,13 +55,6 @@ static inline bool xfs_buf_is_uncached(struct xfs_buf *bp)
 	return bp->b_rhash_key == XFS_BUF_DADDR_NULL;
 }
 
-static inline int
-xfs_buf_vmap_len(
-	struct xfs_buf	*bp)
-{
-	return (bp->b_page_count * PAGE_SIZE);
-}
-
 /*
  * When we mark a buffer stale, we remove the buffer from the LRU and clear the
  * b_lru_ref count so that the buffer is freed immediately when the buffer
@@ -190,29 +183,6 @@ _xfs_buf_alloc(
 	return 0;
 }
 
-static void
-xfs_buf_free_pages(
-	struct xfs_buf	*bp)
-{
-	uint		i;
-
-	ASSERT(bp->b_flags & _XBF_PAGES);
-
-	if (is_vmalloc_addr(bp->b_addr))
-		vm_unmap_ram(bp->b_addr, bp->b_page_count);
-
-	for (i = 0; i < bp->b_page_count; i++) {
-		if (bp->b_pages[i])
-			folio_put(page_folio(bp->b_pages[i]));
-	}
-	mm_account_reclaimed_pages(howmany(BBTOB(bp->b_length), PAGE_SIZE));
-
-	if (bp->b_pages != bp->b_page_array)
-		kfree(bp->b_pages);
-	bp->b_pages = NULL;
-	bp->b_flags &= ~_XBF_PAGES;
-}
-
 static void
 xfs_buf_free_callback(
 	struct callback_head	*cb)
@@ -227,16 +197,23 @@ static void
 xfs_buf_free(
 	struct xfs_buf		*bp)
 {
+	unsigned int		size = BBTOB(bp->b_length);
+
 	trace_xfs_buf_free(bp, _RET_IP_);
 
 	ASSERT(list_empty(&bp->b_lru));
 
+	if (!xfs_buftarg_is_mem(bp->b_target) && size >= PAGE_SIZE)
+		mm_account_reclaimed_pages(howmany(size, PAGE_SHIFT));
+
 	if (xfs_buftarg_is_mem(bp->b_target))
 		xmbuf_unmap_page(bp);
-	else if (bp->b_flags & _XBF_PAGES)
-		xfs_buf_free_pages(bp);
+	else if (is_vmalloc_addr(bp->b_addr))
+		vfree(bp->b_addr);
 	else if (bp->b_flags & _XBF_KMEM)
 		kfree(bp->b_addr);
+	else
+		folio_put(virt_to_folio(bp->b_addr));
 
 	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
 }
@@ -264,9 +241,6 @@ xfs_buf_alloc_kmem(
 		bp->b_addr = NULL;
 		return -ENOMEM;
 	}
-	bp->b_pages = bp->b_page_array;
-	bp->b_pages[0] = kmem_to_page(bp->b_addr);
-	bp->b_page_count = 1;
 	bp->b_flags |= _XBF_KMEM;
 	return 0;
 }
@@ -287,9 +261,9 @@ xfs_buf_alloc_kmem(
  * by the rest of the code - the buffer memory spans a single contiguous memory
  * region that we don't have to map and unmap to access the data directly.
  *
- * The third type of buffer is the multi-page buffer. These are always made
- * up of single pages so that they can be fed to vmap_ram() to return a
- * contiguous memory region we can access the data through.
+ * The third type of buffer is the vmalloc()d buffer. This provides the buffer
+ * with the required contiguous memory region but backed by discontiguous
+ * physical pages.
  */
 static int
 xfs_buf_alloc_backing_mem(
@@ -299,7 +273,6 @@ xfs_buf_alloc_backing_mem(
 	size_t		size = BBTOB(bp->b_length);
 	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
 	struct folio	*folio;
-	long		filled = 0;
 
 	if (xfs_buftarg_is_mem(bp->b_target))
 		return xmbuf_map_page(bp);
@@ -347,98 +320,18 @@ xfs_buf_alloc_backing_mem(
 		goto fallback;
 	}
 	bp->b_addr = folio_address(folio);
-	bp->b_page_array[0] = &folio->page;
-	bp->b_pages = bp->b_page_array;
-	bp->b_page_count = 1;
-	bp->b_flags |= _XBF_PAGES;
 	return 0;
 
 fallback:
-	/* Fall back to allocating an array of single page folios. */
-	bp->b_page_count = DIV_ROUND_UP(size, PAGE_SIZE);
-	if (bp->b_page_count <= XB_PAGES) {
-		bp->b_pages = bp->b_page_array;
-	} else {
-		bp->b_pages = kzalloc(sizeof(struct page *) * bp->b_page_count,
-					gfp_mask);
-		if (!bp->b_pages)
-			return -ENOMEM;
-	}
-	bp->b_flags |= _XBF_PAGES;
-
-	/*
-	 * Bulk filling of pages can take multiple calls. Not filling the entire
-	 * array is not an allocation failure, so don't back off if we get at
-	 * least one extra page.
-	 */
 	for (;;) {
-		long	last = filled;
-
-		filled = alloc_pages_bulk(gfp_mask, bp->b_page_count,
-					  bp->b_pages);
-		if (filled == bp->b_page_count) {
-			XFS_STATS_INC(bp->b_mount, xb_page_found);
+		bp->b_addr = __vmalloc(size, gfp_mask);
+		if (bp->b_addr)
 			break;
-		}
-
-		if (filled != last)
-			continue;
-
-		if (flags & XBF_READ_AHEAD) {
-			xfs_buf_free_pages(bp);
+		if (flags & XBF_READ_AHEAD)
 			return -ENOMEM;
-		}
-
 		XFS_STATS_INC(bp->b_mount, xb_page_retries);
 		memalloc_retry_wait(gfp_mask);
 	}
-	return 0;
-}
-
-/*
- *	Map buffer into kernel address-space if necessary.
- */
-STATIC int
-_xfs_buf_map_pages(
-	struct xfs_buf		*bp,
-	xfs_buf_flags_t		flags)
-{
-	ASSERT(bp->b_flags & _XBF_PAGES);
-	if (bp->b_page_count == 1) {
-		/* A single page buffer is always mappable */
-		bp->b_addr = page_address(bp->b_pages[0]);
-	} else {
-		int retried = 0;
-		unsigned nofs_flag;
-
-		/*
-		 * vm_map_ram() will allocate auxiliary structures (e.g.
-		 * pagetables) with GFP_KERNEL, yet we often under a scoped nofs
-		 * context here. Mixing GFP_KERNEL with GFP_NOFS allocations
-		 * from the same call site that can be run from both above and
-		 * below memory reclaim causes lockdep false positives. Hence we
-		 * always need to force this allocation to nofs context because
-		 * we can't pass __GFP_NOLOCKDEP down to auxillary structures to
-		 * prevent false positive lockdep reports.
-		 *
-		 * XXX(dgc): I think dquot reclaim is the only place we can get
-		 * to this function from memory reclaim context now. If we fix
-		 * that like we've fixed inode reclaim to avoid writeback from
-		 * reclaim, this nofs wrapping can go away.
-		 */
-		nofs_flag = memalloc_nofs_save();
-		do {
-			bp->b_addr = vm_map_ram(bp->b_pages, bp->b_page_count,
-						-1);
-			if (bp->b_addr)
-				break;
-			vm_unmap_aliases();
-		} while (retried++ <= 1);
-		memalloc_nofs_restore(nofs_flag);
-
-		if (!bp->b_addr)
-			return -ENOMEM;
-	}
 
 	return 0;
 }
@@ -558,7 +451,7 @@ xfs_buf_find_lock(
 			return -ENOENT;
 		}
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
-		bp->b_flags &= _XBF_KMEM | _XBF_PAGES;
+		bp->b_flags &= _XBF_KMEM;
 		bp->b_ops = NULL;
 	}
 	return 0;
@@ -744,18 +637,6 @@ xfs_buf_get_map(
 			xfs_perag_put(pag);
 	}
 
-	/* We do not hold a perag reference anymore. */
-	if (!bp->b_addr) {
-		error = _xfs_buf_map_pages(bp, flags);
-		if (unlikely(error)) {
-			xfs_warn_ratelimited(btp->bt_mount,
-				"%s: failed to map %u pages", __func__,
-				bp->b_page_count);
-			xfs_buf_relse(bp);
-			return error;
-		}
-	}
-
 	/*
 	 * Clear b_error if this is a lookup from a caller that doesn't expect
 	 * valid data to be found in the buffer.
@@ -998,14 +879,6 @@ xfs_buf_get_uncached(
 	if (error)
 		goto fail_free_buf;
 
-	if (!bp->b_addr)
-		error = _xfs_buf_map_pages(bp, 0);
-	if (unlikely(error)) {
-		xfs_warn(target->bt_mount,
-			"%s: failed to map pages", __func__);
-		goto fail_free_buf;
-	}
-
 	trace_xfs_buf_get_uncached(bp, _RET_IP_);
 	*bpp = bp;
 	return 0;
@@ -1339,7 +1212,7 @@ __xfs_buf_ioend(
 	if (bp->b_flags & XBF_READ) {
 		if (!bp->b_error && is_vmalloc_addr(bp->b_addr))
 			invalidate_kernel_vmap_range(bp->b_addr,
-					xfs_buf_vmap_len(bp));
+				roundup(BBTOB(bp->b_length), PAGE_SIZE));
 		if (!bp->b_error && bp->b_ops)
 			bp->b_ops->verify_read(bp);
 		if (!bp->b_error)
@@ -1500,29 +1373,43 @@ static void
 xfs_buf_submit_bio(
 	struct xfs_buf		*bp)
 {
-	unsigned int		size = BBTOB(bp->b_length);
-	unsigned int		map = 0, p;
+	unsigned int		map = 0;
 	struct blk_plug		plug;
 	struct bio		*bio;
 
-	bio = bio_alloc(bp->b_target->bt_bdev, bp->b_page_count,
-			xfs_buf_bio_op(bp), GFP_NOIO);
-	bio->bi_private = bp;
-	bio->bi_end_io = xfs_buf_bio_end_io;
+	if (is_vmalloc_addr(bp->b_addr)) {
+		unsigned int	size = BBTOB(bp->b_length);
+		unsigned int	alloc_size = roundup(size, PAGE_SIZE);
+		void		*data = bp->b_addr;
 
-	if (bp->b_page_count == 1) {
-		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
-				offset_in_page(bp->b_addr));
-	} else {
-		for (p = 0; p < bp->b_page_count; p++)
-			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
-		bio->bi_iter.bi_size = size; /* limit to the actual size used */
+		bio = bio_alloc(bp->b_target->bt_bdev, alloc_size >> PAGE_SHIFT,
+				xfs_buf_bio_op(bp), GFP_NOIO);
+
+		do {
+			unsigned int	len = min(size, PAGE_SIZE);
 
-		if (is_vmalloc_addr(bp->b_addr))
-			flush_kernel_vmap_range(bp->b_addr,
-					xfs_buf_vmap_len(bp));
+			ASSERT(offset_in_page(data) == 0);
+			__bio_add_page(bio, vmalloc_to_page(data), len, 0);
+			data += len;
+			size -= len;
+		} while (size);
+
+		flush_kernel_vmap_range(bp->b_addr, alloc_size);
+	} else {
+		/*
+		 * Single folio or slab allocation.  Must be contiguous and thus
+		 * only a single bvec is needed.
+		 */
+		bio = bio_alloc(bp->b_target->bt_bdev, 1, xfs_buf_bio_op(bp),
+				GFP_NOIO);
+		__bio_add_page(bio, virt_to_page(bp->b_addr),
+				BBTOB(bp->b_length),
+				offset_in_page(bp->b_addr));
 	}
 
+	bio->bi_private = bp;
+	bio->bi_end_io = xfs_buf_bio_end_io;
+
 	/*
 	 * If there is more than one map segment, split out a new bio for each
 	 * map except of the last one.  The last map is handled by the
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 8db522f19b0c..db43bdc17f55 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -36,7 +36,6 @@ struct xfs_buf;
 #define _XBF_LOGRECOVERY (1u << 18)/* log recovery buffer */
 
 /* flags used only internally */
-#define _XBF_PAGES	 (1u << 20)/* backed by refcounted pages */
 #define _XBF_KMEM	 (1u << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1u << 22)/* buffer on a delwri queue */
 
@@ -61,7 +60,6 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_STALE,		"STALE" }, \
 	{ XBF_WRITE_FAIL,	"WRITE_FAIL" }, \
 	{ _XBF_LOGRECOVERY,	"LOG_RECOVERY" }, \
-	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
 	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
 	/* The following interface flags should never be set */ \
@@ -122,8 +120,6 @@ struct xfs_buftarg {
 	struct xfs_buf_cache	bt_cache[];
 };
 
-#define XB_PAGES	2
-
 struct xfs_buf_map {
 	xfs_daddr_t		bm_bn;	/* block number for I/O */
 	int			bm_len;	/* size of I/O */
@@ -185,13 +181,10 @@ struct xfs_buf {
 	struct xfs_buf_log_item	*b_log_item;
 	struct list_head	b_li_list;	/* Log items list head */
 	struct xfs_trans	*b_transp;
-	struct page		**b_pages;	/* array of page pointers */
-	struct page		*b_page_array[XB_PAGES]; /* inline pages */
 	struct xfs_buf_map	*b_maps;	/* compound buffer map */
 	struct xfs_buf_map	__b_map;	/* inline compound buffer map */
 	int			b_map_count;
 	atomic_t		b_pin_count;	/* pin count */
-	unsigned int		b_page_count;	/* size of page array */
 	int			b_error;	/* error code on I/O */
 	void			(*b_iodone)(struct xfs_buf *bp);
 
diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
index 5b64a2b3b113..b207754d2ee0 100644
--- a/fs/xfs/xfs_buf_mem.c
+++ b/fs/xfs/xfs_buf_mem.c
@@ -169,9 +169,6 @@ xmbuf_map_page(
 	unlock_page(page);
 
 	bp->b_addr = page_address(page);
-	bp->b_pages = bp->b_page_array;
-	bp->b_pages[0] = page;
-	bp->b_page_count = 1;
 	return 0;
 }
 
@@ -180,16 +177,10 @@ void
 xmbuf_unmap_page(
 	struct xfs_buf		*bp)
 {
-	struct page		*page = bp->b_pages[0];
-
 	ASSERT(xfs_buftarg_is_mem(bp->b_target));
 
-	put_page(page);
-
+	put_page(virt_to_page(bp->b_addr));
 	bp->b_addr = NULL;
-	bp->b_pages[0] = NULL;
-	bp->b_pages = NULL;
-	bp->b_page_count = 0;
 }
 
 /* Is this a valid daddr within the buftarg? */
-- 
2.45.2


