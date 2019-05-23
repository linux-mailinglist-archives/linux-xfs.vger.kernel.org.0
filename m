Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A09A28DB0
	for <lists+linux-xfs@lfdr.de>; Fri, 24 May 2019 01:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387981AbfEWXRc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 19:17:32 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:46223 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387693AbfEWXRc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 19:17:32 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 79E7BD554;
        Fri, 24 May 2019 09:17:28 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hTwxi-0005Bi-LX; Fri, 24 May 2019 09:17:26 +1000
Date:   Fri, 24 May 2019 09:17:26 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/20] xfs: factor out splitting of an iclog from
 xlog_sync
Message-ID: <20190523231726.GU29573@dread.disaster.area>
References: <20190523173742.15551-1-hch@lst.de>
 <20190523173742.15551-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523173742.15551-9-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=7-415B0cAAAA:8 a=IXBlXQAgr-DHHYtUCwoA:9 a=zBXP8bqN_KqG4-m1:21
        a=n6dnrRr3RRne5PMI:21 a=CjuIK1q_8ugA:10 a=R76ju1TwCYIA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 07:37:30PM +0200, Christoph Hellwig wrote:
> Split out a self-contained chunk of code from xlog_sync that calculates
> the split offset for an iclog that wraps the log end and bumps the
> cycles for the second half.
> 
> Use the chance to bring some sanity to the variables used to track the
> split in xlog_sync by not changing the count variable, and instead use
> split as the offset for the split and use those to calculate the
> sizes and offsets for the two write buffers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 63 +++++++++++++++++++++++++-----------------------
>  1 file changed, 33 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 9a81d2d32ad9..885470f08554 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1804,6 +1804,32 @@ xlog_write_iclog(
>  	xfs_buf_submit(bp);
>  }
>  
> +/*
> + * Bump the cycle numbers at the start of each block in the part of the iclog
> + * that ends up in the buffer that gets written to the start of the log.
> + *
> + * Watch out for the header magic number case, though.

Can we update this comment to be easier to parse?

/*
 * We need to bump cycle number for the part of the iclog that is
 * written to the start of the log. Watch out for the header magic
 * number case, though.
 */

> + */
> +static unsigned int
> +xlog_split_iclog(
> +	struct xlog		*log,
> +	void			*data,
> +	uint64_t		bno,
> +	unsigned int		count)
> +{
> +	unsigned int		split_offset = BBTOB(log->l_logBBsize - bno), i;

You can lose a tab from all these indents. Also, can you declare
i as a separate statement - I'd prefer we don't mix multiple
declarations with initialisations on the one line - it just makes
the code harder to read. (i.e. I had to specifically look to find
where i was declared...)

> +	for (i = split_offset; i < count; i += BBSIZE) {
> +		uint32_t cycle = get_unaligned_be32(data + i);
> +
> +		if (++cycle == XLOG_HEADER_MAGIC_NUM)
> +			cycle++;
> +		put_unaligned_be32(cycle, data + i);

Is the location we read from/write to ever unaligned? The cycle
should always be 512 byte aligned to the start of the iclog data
buffer, which should always be at least 4 byte aligned in memory...

Otherwise the patch is fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
