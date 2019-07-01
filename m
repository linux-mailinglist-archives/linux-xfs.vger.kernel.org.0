Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F337C3ADD9
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jun 2019 06:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbfFJESr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 00:18:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfFJESq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jun 2019 00:18:46 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 912D781DF5;
        Mon, 10 Jun 2019 04:18:46 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 631DB5B685;
        Mon, 10 Jun 2019 04:18:42 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH V2 2/2] block: fix page leak in case of merging to same page
Date:   Mon, 10 Jun 2019 12:18:19 +0800
Message-Id: <20190610041819.11575-3-ming.lei@redhat.com>
In-Reply-To: <20190610041819.11575-1-ming.lei@redhat.com>
References: <20190610041819.11575-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 10 Jun 2019 04:18:46 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Different iovec may use one same page, then 'pages' array filled
by iov_iter_get_pages() may get reference of the same page several
times. If some elements in 'pages' can be merged to same page in
one bvec by bio_add_page(), bio_release_pages() only drops the
page's reference once.

This way causes page leak reported by David Gibson.

This issue can be triggered since 576ed913 ("block: use bio_add_page in
bio_iov_iter_get_pages").

Fixes the issue by putting the page's ref if it is merged to same page.

Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Link: https://lkml.org/lkml/2019/4/23/64
Fixes: 576ed913 ("block: use bio_add_page in bio_iov_iter_get_pages")
Reported-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/bio.c         | 12 ++++++++++--
 include/linux/bio.h |  1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 39e3b931dc3b..07a15abc3d11 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -652,6 +652,9 @@ static inline bool page_is_mergeable(const struct bio_vec *bv,
 			return false;
 		if (pfn_to_page(PFN_DOWN(vec_end_addr)) + 1 != page)
 			return false;
+	/* drop page ref if the page has been added and user asks to do that */
+	} else if (flags & BVEC_MERGE_PUT_SAME_PAGE) {
+		put_page(page);
 	}
 
 	WARN_ON_ONCE((flags & BVEC_MERGE_TO_SAME_PAGE) &&
@@ -924,8 +927,13 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 		struct page *page = pages[i];
 
 		len = min_t(size_t, PAGE_SIZE - offset, left);
-		if (WARN_ON_ONCE(bio_add_page(bio, page, len, offset) != len))
-			return -EINVAL;
+
+		if (!__bio_try_merge_page(bio, page, len, offset,
+					BVEC_MERGE_PUT_SAME_PAGE)) {
+			if (WARN_ON_ONCE(bio_add_page(bio, page, len, offset)
+						!= len))
+				return -EINVAL;
+		}
 		offset = 0;
 	}
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 48a95bca1703..dec6cf683d8e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -422,6 +422,7 @@ void bio_chain(struct bio *, struct bio *);
 enum bvec_merge_flags {
 	BVEC_MERGE_DEFAULT,
 	BVEC_MERGE_TO_SAME_PAGE = BIT(0),
+	BVEC_MERGE_PUT_SAME_PAGE = BIT(1),
 };
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
-- 
2.20.1

