Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 506E562615
	for <lists+linux-xfs@lfdr.de>; Mon,  8 Jul 2019 18:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732715AbfGHQV2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Jul 2019 12:21:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34760 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728118AbfGHQV1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jul 2019 12:21:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x68GE08J114985;
        Mon, 8 Jul 2019 16:21:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=3BPxkhLXN3NkfN3Xd9QgReKfIBYvbtPvsmAFrUJB0yY=;
 b=n+l5OEwHB2JMQN9N+9oRAc0W4MZM7jhsRvHMrOcKnYkw6fRteyEIWz4So8N3puWi5Vhy
 ep/pZtlQ8PLny1EAeVGQfP8g/CNJslHbcsAtyVlgmzc2Q4lWWxRgqg0b8uSG6fWKuYco
 jQHLP7E0v1/8GqQ7yOuXGRR4vr4Hb2jsw48+mfHc55aRDFTZDBBG33EUKy72RAsQZCOi
 83uXoFkDaXYRi4U97SiUZZEw4C0R5XvrXD48wF5i1qS5+spYZL4Q6P06d2nLCGSLp+cD
 JXEH+yFExvGpxRjgiT1nN5vRVkZfwje2legiRD9e0h/jFi/f31R7Za7obymFftFhJ5j9 FQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tjm9qfcvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jul 2019 16:21:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x68GD77L088184;
        Mon, 8 Jul 2019 16:19:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tjkf29jmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jul 2019 16:19:20 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x68GJI8x000910;
        Mon, 8 Jul 2019 16:19:19 GMT
Received: from localhost (/10.159.152.157)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jul 2019 09:19:18 -0700
Date:   Mon, 8 Jul 2019 09:19:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/24] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190708161919.GN1404256@magnolia>
References: <20190605191511.32695-1-hch@lst.de>
 <20190605191511.32695-20-hch@lst.de>
 <20190708073740.GI7689@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708073740.GI7689@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907080202
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907080202
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 08, 2019 at 05:37:40PM +1000, Dave Chinner wrote:
> On Wed, Jun 05, 2019 at 09:15:06PM +0200, Christoph Hellwig wrote:
> > The xfs_buf structure is basically used as a glorified container for
> > a memory allocation in the log recovery code.  Replace it with a
> > call to kmem_alloc_large and a simple abstraction to read into or
> > write from it synchronously using chained bios.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I've bisected a generic/006 failure w/ 5.2 + linux-xfs/for-next down
> to this patch. The failure takes several forms:
> 
> 	a) slab page list corruption and endless console spew
> 	b) failure to verify log record headers finding the header
> 	  and asserting:
> 
> [  607.977165] XFS (sdf): Mounting V5 Filesystem
> [  608.014844] XFS (sdf): Log inconsistent (didn't find previous header)
> [  608.016296] XFS: Assertion failed: 0, file: fs/xfs/xfs_log_recover.c, line: 471
> 
> 	c) record corruption being found when trying to verify
> 	headers.
> 
> It's a completely repeatable failure, running on iscsi block device
> with a 4k sector size. Change the sector size to 512 bytes, the
> issue _appears_ to go away, probably because the different log
> sector sizes result in different IO sizes and shapes and so avoid
> the issue I think is occuring....
> 
> > diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> > new file mode 100644
> > index 000000000000..757c1d9293eb
> > --- /dev/null
> > +++ b/fs/xfs/xfs_bio_io.c
> > @@ -0,0 +1,61 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (c) 2019 Christoph Hellwig.
> > + */
> > +#include "xfs.h"
> > +
> > +static inline unsigned int bio_max_vecs(unsigned int count)
> > +{
> > +	return min_t(unsigned, howmany(count, PAGE_SIZE), BIO_MAX_PAGES);
> > +}
> > +
> > +int
> > +xfs_rw_bdev(
> > +	struct block_device	*bdev,
> > +	sector_t		sector,
> > +	unsigned int		count,
> > +	char			*data,
> > +	unsigned int		op)
> > +
> > +{
> > +	unsigned int		is_vmalloc = is_vmalloc_addr(data);
> > +	unsigned int		left = count;
> > +	int			error;
> > +	struct bio		*bio;
> > +
> > +	if (is_vmalloc && op == REQ_OP_WRITE)
> > +		flush_kernel_vmap_range(data, count);
> > +
> > +	bio = bio_alloc(GFP_KERNEL, bio_max_vecs(left));
> > +	bio_set_dev(bio, bdev);
> > +	bio->bi_iter.bi_sector = sector;
> > +	bio->bi_opf = op | REQ_META | REQ_SYNC;
> > +
> > +	do {
> > +		struct page	*page = kmem_to_page(data);
> > +		unsigned int	off = offset_in_page(data);
> > +		unsigned int	len = min_t(unsigned, left, PAGE_SIZE - off);
> > +
> > +		while (bio_add_page(bio, page, len, off) != len) {
> > +			struct bio	*prev = bio;
> > +
> > +			bio = bio_alloc(GFP_KERNEL, bio_max_vecs(left));
> > +			bio_copy_dev(bio, prev);
> > +			bio->bi_iter.bi_sector = bio_end_sector(prev);
> > +			bio->bi_opf = prev->bi_opf;
> > +			bio_chain(bio, prev);
> > +
> > +			submit_bio(prev);
> > +		}
> 
> I suspect the problem is here. This chains bios in a different order
> to xfs_chain_bio() in the data writeback path, and it looks to be
> mis-behaving.

DOH.  Yes, it is.

bio_chain(a, b) sets up @a and @b such that when @a completes it'll
decrement @b's remaining count and if that hits zero it also calls @b's
endio function.

So for xfs_rw_bdev, we allocate a bio bio0, point the local variable
*bio at bio0, and enter the outer do-while loop.  The outer loop body
adds pages to bio0.  At some point the inner while loop conditional
becomes true (i.e. we failed to add the page) so we enter the inner loop
body.  The inner loop body creates bio1, chains bio1 to bio0, and
submits bio0.  Now bio1->bi_end_io == bio_chain_endio and
bio0->bi_end_io == NULL.  The local variable *bio now points to bio1.

Presumably we run through the outer loop at least one more time, adding
more pages to *bio (which points to bio1).  When we exit the outer loop,
we then call submit_bio_wait(bio), which actually calls submit_bio_wait
on bio1.

submit_bio_wait(b) sets @b->bi_end_io to submit_bio_wait_endio, submits
@b, and waits for it to complete.

OOOPS.

The submit_bio_wait blows away our old assignment of bio1->bi_end_io ==
bio_chain_endio and replaces it with submit_bio_wait_endio.  So
xfs_rw_bdev waits /only/ for bio1 to finish and exits without waiting
for bio0, and if you're lucky bio0 completes soon enough that the caller
doesn't notice.  AFAICT, I think bio0 just leaks.

So I think the solution is that we have to call submit_bio_wait on that
very first bio (bio0) since the bios created in the inner loop will be
chained to it... ?  Thoughts/flames/"go finish your morning coffee"?

--D

> The tracing I have shows this interesting case right before we hit
> the bad state:
> 
>     53.622521: bprint:               xlog_find_zeroed: first_cycle 0x1
>     53.623277: bprint:               xlog_find_zeroed: last_cycle 0x0
>     53.633060: bprint:               xlog_find_zeroed: start_blk 0xf0, last_blk 0x10f0
>     53.633320: bprint:               xlog_find_verify_cycle: bufblks 0x2000
> 
> And the I/O that is now issued by xlog_find_verify_cycle() is:
> 
>     53.633321: bprint:               xfs_rw_bdev: s 0xa00140, c 0x200000, op 0
> 
> for 2MB of log space to see if there's any holes in the iclog range
> prior to the last cycle change. THis is issued as two bios:
> 
>     53.633340: bprint:               xfs_rw_bdev: sb prev s 0xa00140 0xa00d10
>     53.633340: block_bio_queue:      8,80 RSM 10486080 + 3024 [mount]
> 
> The first is 3024 sectors in length
> 
>     53.633350: block_split:          8,80 RSM 10486080 / 10488640 [mount]
> 
> which we chain to our next bio and submit it. It is then split
> and chained in the block layer
> 
>     53.633352: block_getrq:          8,80 RSM 10486080 + 2560 [mount]
>     53.633353: block_rq_insert:      8,80 RSM 1310720 () 10486080 + 2560 [mount]
>     53.633362: block_rq_issue:       8,80 RSM 1310720 () 10486080 + 2560 [kworker/3:1H]
>     53.633418: block_getrq:          8,80 RSM 10488640 + 464 [mount]
>     53.633420: block_rq_insert:      8,80 RSM 237568 () 10488640 + 464 [mount]
>     53.633426: block_rq_issue:       8,80 RSM 237568 () 10488640 + 464 [kworker/3:1H]
> 
> and both bios are issued, and then:
> 
> > +
> > +		data += len;
> > +		left -= len;
> > +	} while (left > 0);
> > +
> > +	error = submit_bio_wait(bio);
> > +	bio_put(bio);
> 
>     53.633465: bprint:               xfs_rw_bdev: sbw s 0xa00d10 0xa01140
>     53.633466: block_bio_queue:      8,80 RSM 10489104 + 1072 [mount]
> 
> we submit our second bio and wait on it to complete.
> 
>     53.633471: block_getrq:          8,80 RSM 10489104 + 1072 [mount]
>     53.633472: block_rq_insert:      8,80 RSM 548864 () 10489104 + 1072 [mount]
>     53.633478: block_rq_issue:       8,80 RSM 548864 () 10489104 + 1072 [kworker/3:1H]
>     53.636267: block_rq_complete:    8,80 RSM () 10488640 + 464 [0]
>     53.640807: block_rq_complete:    8,80 RSM () 10489104 + 1072 [0]
> 
> So at this point the smaller split bio has completed, as has the second
> bio we called submit_bio_wait() on, but the next trace:
> 
>     53.640987: bprint:               xlog_find_zeroed: new_blk 0x10c, last_blk 0x10c
> 
> Indicates that submit_bio_wait has completed. The first part of the
> split bio hasn't completed yet, so we have undefined contents in the
> buffer and it finds a zero cycle in the range we were searching. So,
> we call into xlog_find_verify_log_record() which issues new IO at
> the start of the range:
> 
>     53.640990: bprint:               xfs_rw_bdev: s 0xa00140, c 0x4000, op 0
>     53.640992: bprint:               xfs_rw_bdev: sbw s 0xa00140 0xa00160
>     53.640993: block_bio_queue:      8,80 RSM 10486080 + 32 [mount]
>     53.640997: block_getrq:          8,80 RSM 10486080 + 32 [mount]
>     53.640998: block_rq_insert:      8,80 RSM 16384 () 10486080 + 32 [mount]
>     53.641010: block_rq_issue:       8,80 RSM 16384 () 10486080 + 32 [kworker/3:1H]
> 
> And then we see this happen:
> 
>     53.651936: block_rq_complete:    8,80 RSM () 10486080 + 2560 [0]
>     53.652033: block_rq_complete:    8,80 RSM () 10486080 + 32 [0]
> 
> There's two completions for overlapping IOs, and one of them is the
> remaining bio that was split in the block layer. And because when we
> actually read that record, we don't find a cycle number change in it
> or even a complete log record, we get this:
> 
>     53.652058: console:              [   53.491104] XFS (sdf): Log inconsistent (didn't find previous header)
>     53.653500: console:              [   53.492547] XFS: Assertion failed: 0, file: fs/xfs/xfs_log_recover.c, line: 474
> 
> The assert fires.
> 
> It looks like blk_split_request() has corrupted out bio chain by
> splitting a bio in the chain and not linking it back together
> correctly.
> 
> It's not exactly clear to me how nested bio chaining like this is
> supposed to work, but it looks to me like it is the source of the
> log recovery corruption I'm seeing here...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
