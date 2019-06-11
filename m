Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9203D078
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 17:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404496AbfFKPKq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 11:10:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44790 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404494AbfFKPKq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:10:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tT3EiyEovucz2Neriu7X1SBEsLlrNP6yFwU1+X0b/Io=; b=oBqOylG8OOuiRtpK1ydtcGmku3
        2n3an7bcuFw1vP9qL3cFdzMvFKn8Hje8YOV7Bu0ArBFgerLpxHXrDwa4nPuIErD/O323MKg9YNZAy
        EX2+BuTETAAiIeOW4z0zfpd7j1pFG2t5E1ygUrv65ZYW6enAORBKPdrExHAmLd4pn5lTe+C2yg+6q
        GiBfQRxC9jPVwLChVmNUpsdj5DowT26nwxxZSrBQHiUKT+N7DzuyZ2RK0TEjD1M4bRkOxDSOBQygK
        37L6TRevhcpcHuUPjrLSvMG1aZUL8arGsICp6UY8Mw0Ym1JhwbX567tFCVgOB0p6snCAt9svkN7qr
        VQP8f3gA==;
Received: from mpp-cp1-natpool-1-037.ethz.ch ([82.130.71.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1haiQ1-0000qQ-Sw; Tue, 11 Jun 2019 15:10:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] block: fix page leak when merging to same page
Date:   Tue, 11 Jun 2019 17:10:06 +0200
Message-Id: <20190611151007.13625-5-hch@lst.de>
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

When multiple iovecs reference the same page, each get_user_page call
will add a reference to the page.  But once we've created the bio that
information gets lost and only a single reference will be dropped after
I/O completion.  Use the same_page information returned from
__bio_try_merge_page to drop additional references to pages that were
already present in the bio.

Based on a patch from Ming Lei.

Link: https://lkml.org/lkml/2019/4/23/64
Fixes: 576ed913 ("block: use bio_add_page in bio_iov_iter_get_pages")
Reported-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index c34327aa9216..0d841ba4373a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -891,6 +891,7 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	unsigned short entries_left = bio->bi_max_vecs - bio->bi_vcnt;
 	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
 	struct page **pages = (struct page **)bv;
+	bool same_page = false;
 	ssize_t size, left;
 	unsigned len, i;
 	size_t offset;
@@ -911,8 +912,15 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
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
 
-- 
2.20.1

