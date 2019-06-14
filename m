Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F12E4511E
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jun 2019 03:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbfFNBUB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 21:20:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36428 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfFNBUB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Jun 2019 21:20:01 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2EC8A3082E4D;
        Fri, 14 Jun 2019 01:20:01 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A13A6607B2;
        Fri, 14 Jun 2019 01:19:51 +0000 (UTC)
Date:   Fri, 14 Jun 2019 09:19:47 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: alternative take on the same page merging leak fix v2
Message-ID: <20190614011946.GB14436@ming.t460p>
References: <20190613095529.25005-1-hch@lst.de>
 <00c908ad-ca33-164d-3741-6c67813c1f0d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00c908ad-ca33-164d-3741-6c67813c1f0d@kernel.dk>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 14 Jun 2019 01:20:01 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 13, 2019 at 04:04:03AM -0600, Jens Axboe wrote:
> On 6/13/19 3:55 AM, Christoph Hellwig wrote:
> > Hi Jens, hi Ming,
> > 
> > this is the tested and split version of what I think is the better
> > fix for the get_user_pages page leak, as it leaves the intelligence
> > in the callers instead of in bio_try_to_merge_page.
> > 
> > Changes since v1:
> >   - drop patches not required for 5.2
> >   - added Reviewed-by tags
> 
> Applied for 5.2, thanks.

Hi Jens & Christoph,

Looks the following change is missed in patch 1, otherwise kernel oops
is triggered during kernel booting:

diff --git a/block/bio.c b/block/bio.c
index 35b3c568a48f..9ccf07c666f7 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -706,6 +706,8 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 		return 0;
 
 	if (bio->bi_vcnt > 0) {
+		bool same_page;
+
 		bvec = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
 		if (page == bvec->bv_page &&
@@ -723,7 +725,7 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 		if (bvec_gap_to_prev(q, bvec, offset))
 			return 0;
 
-		if (page_is_mergeable(bvec, page, len, offset, false) &&
+		if (page_is_mergeable(bvec, page, len, offset, &same_page) &&
 		    can_add_page_to_seg(q, bvec, page, len, offset)) {
 			bvec->bv_len += len;
 			goto done;

Thanks,
Ming
