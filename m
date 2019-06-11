Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFBC3D073
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 17:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404471AbfFKPKc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 11:10:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44734 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404429AbfFKPKc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:10:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KtT427HTZklBFwvdKvmmBAmh+gVIpodh018L4Fqwbkk=; b=ms17YFEOp7ikn9RhQia0APIMT2
        xuDgR8buqss9GQ1A2plPvUS1PKLTzbfGXzH9sDa4Xwpy5gvlXOiiXd+05spi+H2UjqWKsK8j5XnDH
        KVXfC5//dflhJbWZbuk5mP/gTytDY6ZtNp8hMtbNqDEu5UZZEfCX3LDaBRryxwfMq2tRpKDPxW2ej
        OtN0NEUGxpR9g961AhJVTMdM8LKt5hUAn0bOIvWAQdWHM4SXJB2qZREp2Re4m/nzjbpPjKOnwq31o
        svS1o/m26IS0VbB3DKrL1XDFEtEt2o35GE5tHwu4+zjwjWBzxkdwEdZVm18C+Zg0KEeHYLQNffGrq
        Ix+8YTAA==;
Received: from mpp-cp1-natpool-1-037.ethz.ch ([82.130.71.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1haiPq-0000o9-Fi; Tue, 11 Jun 2019 15:10:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] block: factor out a bio_try_merge_pc_page helper
Date:   Tue, 11 Jun 2019 17:10:04 +0200
Message-Id: <20190611151007.13625-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611151007.13625-1-hch@lst.de>
References: <20190611151007.13625-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Factor the case of trying to add to an existing segment in
__bio_add_pc_page into a new helper that is similar to the regular
bio case.  Subsume the existing can_add_page_to_seg helper into this new
one.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 6db39699aab9..85e243ea6a0e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -659,24 +659,27 @@ static inline bool page_is_mergeable(const struct bio_vec *bv,
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
+		struct page *page, unsigned len, unsigned off, bool *same_page)
 {
+	struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 	unsigned long mask = queue_segment_boundary(q);
 	phys_addr_t addr1 = page_to_phys(bv->bv_page) + bv->bv_offset;
-	phys_addr_t addr2 = page_to_phys(page) + offset + len - 1;
+	phys_addr_t addr2 = page_to_phys(page) + off + len - 1;
+
+	if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
+		*same_page = true;
+		goto done;
+	}
 
 	if ((addr1 | mask) != (addr2 | mask))
 		return false;
-
 	if (bv->bv_len + len > queue_max_segment_size(q))
 		return false;
-
+	if (!page_is_mergeable(bv, page, len, off, false))
+		return false;
+done:
+	bv->bv_len += len;
 	return true;
 }
 
@@ -701,6 +704,7 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 		bool put_same_page)
 {
 	struct bio_vec *bvec;
+	bool same_page = false;
 
 	/*
 	 * cloned bio must not modify vec list
@@ -712,26 +716,18 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 		return 0;
 
 	if (bio->bi_vcnt > 0) {
-		bvec = &bio->bi_io_vec[bio->bi_vcnt - 1];
-
-		if (page == bvec->bv_page &&
-		    offset == bvec->bv_offset + bvec->bv_len) {
-			if (put_same_page)
+		if (bio_try_merge_pc_page(q, bio, page, len, offset,
+				&same_page)) {
+			if (put_same_page && same_page)
 				put_page(page);
-			bvec->bv_len += len;
-			goto done;
-		}
-
-		if (page_is_mergeable(bvec, page, len, offset, false) &&
-		    can_add_page_to_seg(q, bvec, page, len, offset)) {
-			bvec->bv_len += len;
 			goto done;
 		}
 
 		/*
-		 * If the queue doesn't support SG gaps and adding this
-		 * offset would create a gap, disallow it.
+		 * If the queue doesn't support SG gaps and adding this offset
+		 * would create a gap, disallow it.
 		 */
+		bvec = &bio->bi_io_vec[bio->bi_vcnt - 1];
 		if (bvec_gap_to_prev(q, bvec, offset))
 			return 0;
 	}
-- 
2.20.1

