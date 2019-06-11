Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9B63D07A
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 17:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404506AbfFKPKv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 11:10:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44802 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404494AbfFKPKv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:10:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JRePIxhIBKIYU5r/SmxJouq0GO/d1zeJKYfLAmd06XU=; b=Wjoi2YZ8+qKs2rr01aziZzm5dp
        N4gkYKqUl4FluIobWKppUOk1FO7DB/ROTaN93h/REw3v/UbQxErrGDf4O1ZyOhhkEmA8T7a87I/W6
        S6LFGsemrUy1gbroEc3HWkmV5xCUhvWLK/WhGyPhgMRW13KjjMCWsg8/y3lFZsb1FR2uqFxZDGYkZ
        8GAZOT5z54dHGngNWrlKrjWBMvSr6H3fVAPItKMKTZsNz5wHHLz8PmEwcwtinIZ7Zu+vlti8OBIGU
        OiI6eeZ+wyjESA6vhggNgqL2dTtcekd/4/IbVvoDkVJ9I94LK0++HGUEWpGkbQUVkC4cAWHkEYmAT
        rFYHUGhg==;
Received: from mpp-cp1-natpool-1-037.ethz.ch ([82.130.71.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1haiQ7-0000rH-83; Tue, 11 Jun 2019 15:10:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] block: use __bio_try_merge_page in __bio_try_merge_pc_page
Date:   Tue, 11 Jun 2019 17:10:07 +0200
Message-Id: <20190611151007.13625-6-hch@lst.de>
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

Passsthrough bio handling should be the same as normal bio handling,
except that we need to take hardware limitations into account.  Thus
use the common try_merge implementation after checking the hardware
limits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 0d841ba4373a..7db7186eab1c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -661,20 +661,11 @@ static bool bio_try_merge_pc_page(struct request_queue *q, struct bio *bio,
 	phys_addr_t addr1 = page_to_phys(bv->bv_page) + bv->bv_offset;
 	phys_addr_t addr2 = page_to_phys(page) + off + len - 1;
 
-	if (page == bv->bv_page && off == bv->bv_offset + bv->bv_len) {
-		*same_page = true;
-		goto done;
-	}
-
 	if ((addr1 | mask) != (addr2 | mask))
 		return false;
 	if (bv->bv_len + len > queue_max_segment_size(q))
 		return false;
-	if (!page_is_mergeable(bv, page, len, off, false))
-		return false;
-done:
-	bv->bv_len += len;
-	return true;
+	return __bio_try_merge_page(bio, page, len, off, same_page);
 }
 
 /**
@@ -737,8 +728,8 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 	bvec->bv_len = len;
 	bvec->bv_offset = offset;
 	bio->bi_vcnt++;
- done:
 	bio->bi_iter.bi_size += len;
+ done:
 	bio->bi_phys_segments = bio->bi_vcnt;
 	bio_set_flag(bio, BIO_SEG_VALID);
 	return len;
-- 
2.20.1

