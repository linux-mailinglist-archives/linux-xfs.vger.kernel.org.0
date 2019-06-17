Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0005447E0C
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Jun 2019 11:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfFQJO3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Jun 2019 05:14:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40790 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbfFQJO3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jun 2019 05:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hAuHSRMJsHzow4ew5KlsBL2UCoT+AA8w3X8Stil6o1o=; b=jFB56QdrwA0sDBm9JkWZwg6Nd2
        3iggQrym+q6urYWw+LBphIgXNRt8xM4VIhW2YXzVhlb5cC9Givl8O+YWQ0baPy4nthk74VKs1bLM6
        VhxQTi3DA1EdX72I/nhauyTwqg5oLYRK3hRRZFBYL+3OG4RNDCDsU+J23omd4kNBRC1sKXD+3QV6P
        nn9IT9CH34kiQPwzbE4q4NULh+9XYB1VM+zeKvppcS/Emp5E15bBfeGl1iWw2p5i7wTivEv0YiVJL
        zgyH4gq46LpWPxeZw1tuPmkjQWzD6j9CyfowjqheWL6Cbe5KPJcVwcNv2oJeVTzbozHg46zVGfRWt
        mo6uSz7Q==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hcniX-0005EZ-FV; Mon, 17 Jun 2019 09:14:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] block: fix page leak when merging to same page
Date:   Mon, 17 Jun 2019 11:14:12 +0200
Message-Id: <20190617091412.15923-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190617091412.15923-1-hch@lst.de>
References: <20190617091412.15923-1-hch@lst.de>
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
Reviewed-by: Ming Lei <ming.lei@redhat.com>
---
 block/bio.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index daa1c1ae72cd..ce797d73bb43 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -896,6 +896,7 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 	unsigned short entries_left = bio->bi_max_vecs - bio->bi_vcnt;
 	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
 	struct page **pages = (struct page **)bv;
+	bool same_page = false;
 	ssize_t size, left;
 	unsigned len, i;
 	size_t offset;
@@ -916,8 +917,15 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
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

