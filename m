Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 166A63B615
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jun 2019 15:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389951AbfFJNeu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 09:34:50 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36386 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389508AbfFJNeu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 09:34:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VeeFjzU/Z5v0KCw2NR3QMTVCB2dDbxUhNN9wYfHMq5Q=; b=Ky1rHmadlQYh5xR36N1XASmE3
        8sBUO800RN5BnoG8XeJeEWgwGz2uqyqp7kBhL2d4waHxOW+LAT4UrQPgaIrKGRK+fd1yhoLmLDv8i
        rRWzo7z+Kl2H6YA4WZQE/Un02Yo7RVjdUVQpeI0QyImsy4zcwnYOmZw0myvt+WWOYfb6SSEwKX4QF
        lDqalPyDuQOnLKhje8sgillgDijR0Zg/gyYRVDHtLE49sBEjr1vENyEPKBKs85xvIYiZ6q/sScgn7
        3TZbLVtphGhg2dksWTH5bixBqopA5duoF/RlhmlKxY7lxpMsTm778XCd3sVTNm8tmuidb+LQRUGhT
        qPZiy+zAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1haKRi-0007bM-J7; Mon, 10 Jun 2019 13:34:46 +0000
Date:   Mon, 10 Jun 2019 06:34:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2 0/2] block: fix page leak by merging to same page
Message-ID: <20190610133446.GA28712@infradead.org>
References: <20190610041819.11575-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610041819.11575-1-ming.lei@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I don't really like the magic enum types.  I'd rather go back to my
initial idea to turn the same_page argument into an output parameter,
so that the callers can act upon it.  Untested patch below:


diff --git a/block/bio.c b/block/bio.c
index 683cbb40f051..d4999ef3b1fb 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -636,7 +636,7 @@ EXPORT_SYMBOL(bio_clone_fast);
 
 static inline bool page_is_mergeable(const struct bio_vec *bv,
 		struct page *page, unsigned int len, unsigned int off,
-		bool same_page)
+		bool *same_page)
 {
 	phys_addr_t vec_end_addr = page_to_phys(bv->bv_page) +
 		bv->bv_offset + bv->bv_len - 1;
@@ -647,26 +647,17 @@ static inline bool page_is_mergeable(const struct bio_vec *bv,
 	if (xen_domain() && !xen_biovec_phys_mergeable(bv, page))
 		return false;
 
-	if ((vec_end_addr & PAGE_MASK) != page_addr) {
-		if (same_page)
-			return false;
-		if (pfn_to_page(PFN_DOWN(vec_end_addr)) + 1 != page)
-			return false;
-	}
-
-	WARN_ON_ONCE(same_page && (len + off) > PAGE_SIZE);
-
+	*same_page = ((vec_end_addr & PAGE_MASK) == page_addr);
+	if (!*same_page && pfn_to_page(PFN_DOWN(vec_end_addr)) + 1 != page)
+		return false;
 	return true;
 }
 
-/*
- * Check if the @page can be added to the current segment(@bv), and make
- * sure to call it only if page_is_mergeable(@bv, @page) is true
- */
-static bool can_add_page_to_seg(struct request_queue *q,
-		struct bio_vec *bv, struct page *page, unsigned len,
-		unsigned offset)
+static bool bio_try_merge_pc_page(struct request_queue *q, struct bio *bio,
+		struct page *page, unsigned len, unsigned offset,
+		bool *same_page)
 {
+	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 	unsigned long mask = queue_segment_boundary(q);
 	phys_addr_t addr1 = page_to_phys(bv->bv_page) + bv->bv_offset;
 	phys_addr_t addr2 = page_to_phys(page) + offset + len - 1;
@@ -677,7 +668,13 @@ static bool can_add_page_to_seg(struct request_queue *q,
 	if (bv->bv_len + len > queue_max_segment_size(q))
 		return false;
 
-	return true;
+	/*
+	 * If the queue doesn't support SG gaps and adding this
+	 * offset would create a gap, disallow it.
+	 */
+	if (bvec_gap_to_prev(q, bv, offset))
+		return false;
+	return __bio_try_merge_page(bio, page, len, offset, same_page);
 }
 
 /**
@@ -701,6 +698,7 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 		bool put_same_page)
 {
 	struct bio_vec *bvec;
+	bool same_page = false;
 
 	/*
 	 * cloned bio must not modify vec list
@@ -711,29 +709,11 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 	if (((bio->bi_iter.bi_size + len) >> 9) > queue_max_hw_sectors(q))
 		return 0;
 
-	if (bio->bi_vcnt > 0) {
-		bvec = &bio->bi_io_vec[bio->bi_vcnt - 1];
-
-		if (page == bvec->bv_page &&
-		    offset == bvec->bv_offset + bvec->bv_len) {
-			if (put_same_page)
-				put_page(page);
-			bvec->bv_len += len;
-			goto done;
-		}
-
-		/*
-		 * If the queue doesn't support SG gaps and adding this
-		 * offset would create a gap, disallow it.
-		 */
-		if (bvec_gap_to_prev(q, bvec, offset))
-			return 0;
-
-		if (page_is_mergeable(bvec, page, len, offset, false) &&
-		    can_add_page_to_seg(q, bvec, page, len, offset)) {
-			bvec->bv_len += len;
-			goto done;
-		}
+	if (bio->bi_vcnt > 0 &&
+	    bio_try_merge_pc_page(q, bio, page, len, offset, &same_page)) {
+		if (put_same_page && same_page)
+			put_page(page);
+		goto done;
 	}
 
 	if (bio_full(bio))
@@ -747,8 +727,8 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 	bvec->bv_len = len;
 	bvec->bv_offset = offset;
 	bio->bi_vcnt++;
- done:
 	bio->bi_iter.bi_size += len;
+ done:
 	bio->bi_phys_segments = bio->bi_vcnt;
 	bio_set_flag(bio, BIO_SEG_VALID);
 	return len;
@@ -767,8 +747,7 @@ EXPORT_SYMBOL(bio_add_pc_page);
  * @page: start page to add
  * @len: length of the data to add
  * @off: offset of the data relative to @page
- * @same_page: if %true only merge if the new data is in the same physical
- *		page as the last segment of the bio.
+ * @same_page: return if the segment has been merged inside the same page
  *
  * Try to add the data at @page + @off to the last bvec of @bio.  This is a
  * a useful optimisation for file systems with a block size smaller than the
@@ -779,7 +758,7 @@ EXPORT_SYMBOL(bio_add_pc_page);
  * Return %true on success or %false on failure.
  */
 bool __bio_try_merge_page(struct bio *bio, struct page *page,
-		unsigned int len, unsigned int off, bool same_page)
+		unsigned int len, unsigned int off, bool *same_page)
 {
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return false;
@@ -837,7 +816,9 @@ EXPORT_SYMBOL_GPL(__bio_add_page);
 int bio_add_page(struct bio *bio, struct page *page,
 		 unsigned int len, unsigned int offset)
 {
-	if (!__bio_try_merge_page(bio, page, len, offset, false)) {
+	bool same_page = false;
+
+	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
 		if (bio_full(bio))
 			return 0;
 		__bio_add_page(bio, page, len, offset);
@@ -900,6 +881,7 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	unsigned short entries_left = bio->bi_max_vecs - bio->bi_vcnt;
 	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
 	struct page **pages = (struct page **)bv;
+	bool same_page = false;
 	ssize_t size, left;
 	unsigned len, i;
 	size_t offset;
@@ -920,8 +902,15 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 		struct page *page = pages[i];
 
 		len = min_t(size_t, PAGE_SIZE - offset, left);
-		if (WARN_ON_ONCE(bio_add_page(bio, page, len, offset) != len))
-			return -EINVAL;
+
+		if (__bio_try_merge_page(bio, page, len, offset, &same_page)) {
+			if (same_page)
+				put_page(page);
+		} else {
+			if (WARN_ON_ONCE(bio_full(bio)))
+                                return -EINVAL;
+			__bio_add_page(bio, page, len, offset);
+		}
 		offset = 0;
 	}
 
diff --git a/fs/iomap.c b/fs/iomap.c
index 23ef63fd1669..12654c2e78f8 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -287,7 +287,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	struct iomap_readpage_ctx *ctx = data;
 	struct page *page = ctx->cur_page;
 	struct iomap_page *iop = iomap_page_create(inode, page);
-	bool is_contig = false;
+	bool same_page = false, is_contig = false;
 	loff_t orig_pos = pos;
 	unsigned poff, plen;
 	sector_t sector;
@@ -315,10 +315,14 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	 * Try to merge into a previous segment if we can.
 	 */
 	sector = iomap_sector(iomap, pos);
-	if (ctx->bio && bio_end_sector(ctx->bio) == sector) {
-		if (__bio_try_merge_page(ctx->bio, page, plen, poff, true))
-			goto done;
+	if (ctx->bio && bio_end_sector(ctx->bio) == sector)
 		is_contig = true;
+
+	if (is_contig &&
+	    __bio_try_merge_page(ctx->bio, page, plen, poff, &same_page)) {
+		if (!same_page && iop)
+			atomic_inc(&iop->read_count);
+		goto done;
 	}
 
 	/*
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a6f0f4761a37..8da5e6637771 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -758,6 +758,7 @@ xfs_add_to_ioend(
 	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
 	unsigned		len = i_blocksize(inode);
 	unsigned		poff = offset & (PAGE_SIZE - 1);
+	bool			merged, same_page = false;
 	sector_t		sector;
 
 	sector = xfs_fsb_to_db(ip, wpc->imap.br_startblock) +
@@ -774,9 +775,13 @@ xfs_add_to_ioend(
 				wpc->imap.br_state, offset, bdev, sector);
 	}
 
-	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff, true)) {
-		if (iop)
-			atomic_inc(&iop->write_count);
+	merged = __bio_try_merge_page(wpc->ioend->io_bio, page, len, poff,
+			&same_page);
+
+	if (iop && !same_page)
+		atomic_inc(&iop->write_count);
+
+	if (!merged) {
 		if (bio_full(wpc->ioend->io_bio))
 			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
 		bio_add_page(wpc->ioend->io_bio, page, len, poff);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ea73df36529a..3df3b127b394 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -423,7 +423,7 @@ extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 bool __bio_try_merge_page(struct bio *bio, struct page *page,
-		unsigned int len, unsigned int off, bool same_page);
+		unsigned int len, unsigned int off, bool *same_page);
 void __bio_add_page(struct bio *bio, struct page *page,
 		unsigned int len, unsigned int off);
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
