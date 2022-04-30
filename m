Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991765160A9
	for <lists+linux-xfs@lfdr.de>; Sat, 30 Apr 2022 23:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245567AbiD3VoB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 30 Apr 2022 17:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245651AbiD3VoA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Apr 2022 17:44:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ACEB1C6;
        Sat, 30 Apr 2022 14:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m+46ifgzSQGKmNYd/J0pGOxSj2CQrYuL8G0ttBaB3sA=; b=hHKdxRVOWwmh/tNS3AohcfRwcB
        fqcVNHNb3HCS+FaPM+EmZBWYz9evSvJ4cRcxziAGMqH8RLQ/B1fxHp2LFwYbpw5jFH+1beRucyFaC
        idz6Q7VmLsrht8jY3P/HnimISfwlXfg7/XO/E8G95UwjrDf2R9Sq+iRZmNnCwT5utGOVitbb3VliA
        nfGi6Psqfhkp4OHYnDCp41+h+nz8Wgvm5k8hM61VfILmIJZS7SwDi6ljF52KmJ9pp1g33IiLeA3Zo
        iJ0zcF0IAOqKKtOXTkCkXHoKMVQq9Dtnk6NlAb9MD10+lcFNvJmRb2VSHFmZGD5JXi4FPj7iFU1sF
        cAVF30Qw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nkupL-00Dbva-Lo; Sat, 30 Apr 2022 21:40:31 +0000
Date:   Sat, 30 Apr 2022 22:40:31 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: generic/068 crash on 5.18-rc2?
Message-ID: <Ym2szx2S3ontYsBf@casper.infradead.org>
References: <20220413033425.GM16799@magnolia>
 <YlbjOPEQP66gc1WQ@casper.infradead.org>
 <20220418174747.GF17025@magnolia>
 <20220422215943.GC17025@magnolia>
 <Ymq4brjhBcBvcfIs@bfoster>
 <Ymywh003c+Hd4Zu9@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ymywh003c+Hd4Zu9@casper.infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 30, 2022 at 04:44:07AM +0100, Matthew Wilcox wrote:
> (I do not love this, have not even compiled it; it's late.  We may be
> better off just storing next_folio inside the folio_iter).

Does anyone have a preference for fixing this between Option A:

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 49eff01fb829..55e2499beff6 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -269,6 +269,7 @@ struct folio_iter {
        size_t offset;
        size_t length;
        /* private: for use by the iterator */
+       struct folio *_next;
        size_t _seg_count;
        int _i;
 };
@@ -280,19 +281,23 @@ static inline void bio_first_folio(struct folio_iter *fi,
struct bio *bio,

        fi->folio = page_folio(bvec->bv_page);
        fi->offset = bvec->bv_offset +
-                       PAGE_SIZE * (bvec->bv_page - &fi->folio->page);
+                       PAGE_SIZE * folio_page_idx(fi->folio, bvec->bv_page);
        fi->_seg_count = bvec->bv_len;
        fi->length = min(folio_size(fi->folio) - fi->offset, fi->_seg_count);
        fi->_i = i;
+       if (fi->_seg_count > fi->length)
+               fi->_next = folio_next(fi->folio);
 }

 static inline void bio_next_folio(struct folio_iter *fi, struct bio *bio)
 {
        fi->_seg_count -= fi->length;
        if (fi->_seg_count) {
-               fi->folio = folio_next(fi->folio);
+               fi->folio = fi->_next;
                fi->offset = 0;
                fi->length = min(folio_size(fi->folio), fi->_seg_count);
+               if (fi->_seg_count > fi->length)
+                       fi->_next = folio_next(fi->folio);
        } else if (fi->_i + 1 < bio->bi_vcnt) {
                bio_first_folio(fi, bio, fi->_i + 1);
        } else {


and Option B:

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 49eff01fb829..554f5fce060c 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -290,7 +290,8 @@ static inline void bio_next_folio(struct folio_iter *fi, struct bio *bio)
 {
        fi->_seg_count -= fi->length;
        if (fi->_seg_count) {
-               fi->folio = folio_next(fi->folio);
+               fi->folio = __folio_next(fi->folio,
+                               (fi->offset + fi->length) / PAGE_SIZE);
                fi->offset = 0;
                fi->length = min(folio_size(fi->folio), fi->_seg_count);
        } else if (fi->_i + 1 < bio->bi_vcnt) {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index de32c0383387..9c5547af8d0e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1642,6 +1642,12 @@ static inline long folio_nr_pages(struct folio *folio)
        return compound_nr(&folio->page);
 }

+static inline struct folio *__folio_next(struct folio *folio,
+               unsigned long nr_pages)
+{
+       return (struct folio *)folio_page(folio, nr_pages);
+}
+
 /**
  * folio_next - Move to the next physical folio.
  * @folio: The folio we're currently operating on.
@@ -1658,7 +1664,7 @@ static inline long folio_nr_pages(struct folio *folio)
  */
 static inline struct folio *folio_next(struct folio *folio)
 {
-       return (struct folio *)folio_page(folio, folio_nr_pages(folio));
+       return __folio_next(folio, folio_nr_pages(folio));
 }

 /**


Currently running Option A through its paces.
