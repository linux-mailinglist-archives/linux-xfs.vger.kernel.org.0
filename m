Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D90CD290D9
	for <lists+linux-xfs@lfdr.de>; Fri, 24 May 2019 08:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388051AbfEXGRN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 24 May 2019 02:17:13 -0400
Received: from verein.lst.de ([213.95.11.211]:51565 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387936AbfEXGRN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 May 2019 02:17:13 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 85B9868AFE; Fri, 24 May 2019 08:16:50 +0200 (CEST)
Date:   Fri, 24 May 2019 08:16:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/20] xfs: factor out splitting of an iclog from
 xlog_sync
Message-ID: <20190524061650.GB2235@lst.de>
References: <20190523173742.15551-1-hch@lst.de> <20190523173742.15551-9-hch@lst.de> <20190523231726.GU29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523231726.GU29573@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 24, 2019 at 09:17:26AM +1000, Dave Chinner wrote:
> > +/*
> > + * Bump the cycle numbers at the start of each block in the part of the iclog
> > + * that ends up in the buffer that gets written to the start of the log.
> > + *
> > + * Watch out for the header magic number case, though.
> 
> Can we update this comment to be easier to parse?
> 
> /*
>  * We need to bump cycle number for the part of the iclog that is
>  * written to the start of the log. Watch out for the header magic
>  * number case, though.
>  */

Sure.

> > +	for (i = split_offset; i < count; i += BBSIZE) {
> > +		uint32_t cycle = get_unaligned_be32(data + i);
> > +
> > +		if (++cycle == XLOG_HEADER_MAGIC_NUM)
> > +			cycle++;
> > +		put_unaligned_be32(cycle, data + i);
> 
> Is the location we read from/write to ever unaligned? The cycle
> should always be 512 byte aligned to the start of the iclog data
> buffer, which should always be at least 4 byte aligned in memory...

I don't think it is unaligned, but the get_unaligned_* and
put_unaligned_* helpers are just really nice ways to read big/little
endian fields from arbitrary char pointers, which is what we do here.

