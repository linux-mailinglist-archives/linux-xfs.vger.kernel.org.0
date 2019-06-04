Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 062BB33EDA
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 08:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfFDGN3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 02:13:29 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59184 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726488AbfFDGN3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 02:13:29 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7E1D8149AD8;
        Tue,  4 Jun 2019 16:13:25 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hY2hG-0004nq-Om; Tue, 04 Jun 2019 16:13:22 +1000
Date:   Tue, 4 Jun 2019 16:13:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/20] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190604061322.GQ29573@dread.disaster.area>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-17-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603172945.13819-17-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=7-415B0cAAAA:8 a=C1koPWwfvqDDSObJx70A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 07:29:41PM +0200, Christoph Hellwig wrote:
> The xfs_buf structure is basically used as a glorified container for
> a memory allocation in the log recovery code.  Replace it with a
> call to kmem_alloc_large and a simple abstraction to read into or
> write from it synchronously using chained bios.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
....
> +int
> +xfs_rw_bdev(
> +	struct block_device	*bdev,
> +	sector_t		sector,
> +	unsigned int		count,
> +	char			*data,
> +	unsigned int		op)
> +
> +{
> +	unsigned int		is_vmalloc = is_vmalloc_addr(data);
> +	unsigned int		left = count;
> +	int			error;
> +	struct bio		*bio;
> +
> +	if (is_vmalloc && op == REQ_OP_READ)
> +		flush_kernel_vmap_range(data, count);

That should be REQ_OP_WRITE. i.e. the data the CPU has written to
the aliased vmap address has to be flushed back to the physical page
before the DMA from the physical page to the storage device occurs.

> +	bio = bio_alloc(GFP_KERNEL, bio_max_vecs(left));
> +	bio_set_dev(bio, bdev);
> +	bio->bi_iter.bi_sector = sector;
> +	bio->bi_opf = op | REQ_META | REQ_SYNC;
> +
> +	do {
> +		struct page	*page = kmem_to_page(data);
> +		unsigned int	off = offset_in_page(data);
> +		unsigned int	len = min_t(unsigned, left, PAGE_SIZE - off);
> +
> +		while (bio_add_page(bio, page, len, off) != len) {
> +			struct bio	*prev = bio;
> +
> +			bio = bio_alloc(GFP_KERNEL, bio_max_vecs(left));
> +			bio_copy_dev(bio, prev);
> +			bio->bi_iter.bi_sector = bio_end_sector(prev);
> +			bio->bi_opf = prev->bi_opf;
> +			bio_chain(bio, prev);
> +
> +			submit_bio(prev);
> +		}
> +
> +		data += len;
> +		left -= len;
> +	} while (left > 0);
> +
> +	error = submit_bio_wait(bio);
> +	bio_put(bio);
> +
> +	if (is_vmalloc && op == REQ_OP_WRITE)
> +		invalidate_kernel_vmap_range(data, count);

And this should be REQ_OP_READ - to invalidate anything aliased in
the CPU cache before the higher layers try to read the new data in
the physical page...

Otherwise looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
