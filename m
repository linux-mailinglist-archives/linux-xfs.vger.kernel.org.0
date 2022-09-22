Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C2E5E7026
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Sep 2022 01:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiIVXRD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Sep 2022 19:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiIVXRB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Sep 2022 19:17:01 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7071310AB03;
        Thu, 22 Sep 2022 16:16:59 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CA1B11100C5F;
        Fri, 23 Sep 2022 09:16:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1obVR9-00AyHW-EI; Fri, 23 Sep 2022 09:16:55 +1000
Date:   Fri, 23 Sep 2022 09:16:55 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: write iomap validity checks
Message-ID: <20220922231655.GV3600936@dread.disaster.area>
References: <20220921082959.1411675-1-david@fromorbit.com>
 <20220921082959.1411675-2-david@fromorbit.com>
 <YyvZLTvayJT0xAPr@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyvZLTvayJT0xAPr@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=632cece8
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=xOM3xZuef0cA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=SdPgHarvsISlgMxqJ-cA:9 a=CjuIK1q_8ugA:10
        a=DiKeHqHhRZ4A:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 21, 2022 at 08:40:29PM -0700, Darrick J. Wong wrote:
> On Wed, Sep 21, 2022 at 06:29:58PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > A recent multithreaded write data corruption has been uncovered in
> > the iomap write code. The core of the problem is partial folio
> > writes can be flushed to disk while a new racing write can map it
> > and fill the rest of the page:
> > 
> > writeback			new write
> > 
> > allocate blocks
> >   blocks are unwritten
> > submit IO
> > .....
> > 				map blocks
> > 				iomap indicates UNWRITTEN range
> > 				loop {
> > 				  lock folio
> > 				  copyin data
> > .....
> > IO completes
> >   runs unwritten extent conv
> >     blocks are marked written
> > 				  <iomap now stale>
> > 				  get next folio
> > 				}
> > 
> > Now add memory pressure such that memory reclaim evicts the
> > partially written folio that has already been written to disk.
> > 
> > When the new write finally gets to the last partial page of the new
> > write, it does not find it in cache, so it instantiates a new page,
> > sees the iomap is unwritten, and zeros the part of the page that
> > it does not have data from. This overwrites the data on disk that
> > was originally written.
> > 
> > The full description of the corruption mechanism can be found here:
> > 
> > https://lore.kernel.org/linux-xfs/20220817093627.GZ3600936@dread.disaster.area/
> > 
> > To solve this problem, we need to check whether the iomap is still
> > valid after we lock each folio during the write. We have to do it
> > after we lock the page so that we don't end up with state changes
> > occurring while we wait for the folio to be locked.
> > 
> > Hence we need a mechanism to be able to check that the cached iomap
> > is still valid (similar to what we already do in buffered
> > writeback), and we need a way for ->begin_write to back out and
> > tell the high level iomap iterator that we need to remap the
> > remaining write range.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/iomap/buffered-io.c | 53 +++++++++++++++++++++++++++++++++---------
> >  fs/iomap/iter.c        | 33 ++++++++++++++++++++++++--
> >  include/linux/iomap.h  | 17 ++++++++++++++
> >  3 files changed, 90 insertions(+), 13 deletions(-)
> > 
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index ca5c62901541..44c806d46be4 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -584,8 +584,9 @@ static int iomap_write_begin_inline(const struct iomap_iter *iter,
> >  	return iomap_read_inline_data(iter, folio);
> >  }
> >  
> > -static int iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
> > -		size_t len, struct folio **foliop)
> > +static int iomap_write_begin(struct iomap_iter *iter,
> > +		const struct iomap_ops *ops, loff_t pos, size_t len,
> > +		struct folio **foliop)
> >  {
> >  	const struct iomap_page_ops *page_ops = iter->iomap.page_ops;
> >  	const struct iomap *srcmap = iomap_iter_srcmap(iter);
> > @@ -618,6 +619,27 @@ static int iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
> >  		status = (iter->flags & IOMAP_NOWAIT) ? -EAGAIN : -ENOMEM;
> >  		goto out_no_page;
> >  	}
> > +
> > +	/*
> > +	 * Now we have a locked folio, before we do anything with it we need to
> > +	 * check that the iomap we have cached is not stale. The inode extent
> > +	 * mapping can change due to concurrent IO in flight (e.g.
> > +	 * IOMAP_UNWRITTEN state can change and memory reclaim could have
> 
> Earlier, we were talking this specific problem involves zeroing folio
> areas around a folio-unaligned write to a !uptodate folio backed by an
> unwritten extent.  Is the scope of this corruption still limited to
> *just* that case?  Or does it affect any write to a new mapping or
> beyond EOF?  Can it affect a write to an extent that somehow gets
> switched to unwritten or a hole after the mapping has been sampled?

We only hold the IOLOCK while we are iterating the cached mapping.
Hence anything that can modify the extent tree without holding the
IOLOCK in a way that would exclude iomap iteration can trigger stale
mappings.

AFAICT, the ways this can happen right now are:

1. page fault path takes mapping->invalidate_lock, not IOLOCK
2. writeback allocating delalloc regions as unwritten
3. IO completion converting unwritten regions to written.
4. DIO writes doing extent allocation under IOLOCK_SHARED while
   other iomap iterators are holding IOLOCK_SHARED, too. (i.e. hole
   -> unwritten).

Note that this affects my recent suggestion about using
IOLOCK_SHARED for buffered writes, too - that would be case #5,
similar to #4.

Stuff that takes the IOLOCK_EXCL, such as truncate, fallocate, etc
for direct extent manipulation cannot trigger stale cached iomaps in
the IO path because they wait for all IO path operations to drain
and for dirty data to flush across the range they are operating on.

> > +	 * reclaimed a previously partially written page at this index after IO
> > +	 * completion before this write reaches this file offset) and hence we
> > +	 * could do the wrong thing here (zero a page range incorrectly or fail
> > +	 * to zero) and corrupt data.
> > +	 */
> > +	if (ops->iomap_valid) {
> > +		bool iomap_valid = ops->iomap_valid(iter->inode, &iter->iomap);
> 
> At this point in the (xfs) buffered write cycle, we've taken the IOLOCK
> and folio lock.  Is it possible for ->iomap_valid to detect that the
> mapping is no longer valid, trylock the ILOCK, and update the mapping so
> that we don't have to drop the folio lock and go all the way back to
> ->iomap_begin?

Possibly. But we can fail to get the ILOCK, and that means we still
have to fall back all to being outside the page lock before we can
try again.

The other issue is that the iomap iter still currently points to the
offset at the start of the write, so we aren't guaranteed that the
refetched iomap even covers the range of the page we currently have
locked. IOWs, we have to advance the iterator before we remap the
range to guarantee that the new iomap covers the range of the file
that we are currently operating on....

> If we have to pay the cost of an indirect call, we could try to update
> the mapping if one's available, right?  Obviously, if we don't find a
> mapping we're probably going to have to drop the folio lock and allocate
> more space.

I'd prefer that we get the slow, fall-back-all-the-way path correct
first. We are always going to need this slow path, so let's focus on
making it correct and robust rather than trying to prematurely
optimise it....

> > --- a/fs/iomap/iter.c
> > +++ b/fs/iomap/iter.c
> > @@ -7,12 +7,36 @@
> >  #include <linux/iomap.h>
> >  #include "trace.h"
> >  
> > +/*
> > + * Advance to the next range we need to map.
> > + *
> > + * If the iomap is marked IOMAP_F_STALE, it means the existing map was not fully
> > + * processed - it was aborted because the extent the iomap spanned may have been
> > + * changed during the operation. In this case, the iteration behaviour is to
> > + * remap the unprocessed range of the iter, and that means we may need to remap
> > + * even when we've made no progress (i.e. iter->processed = 0). Hence the
> > + * "finished iterating" case needs to distinguish between
> > + * (processed = 0) meaning we are done and (processed = 0 && stale) meaning we
> > + * need to remap the entire remaining range.
> > + *
> > + * We also need to preserve IOMAP_F_STALE on the iomap so that the next call
> > + * to iomap_begin() knows that it is reprocessing a stale map. Similarly, we
> > + * need to preserve IOMAP_F_NEW as the filesystem may not realise that it
> > + * is remapping a region that it allocated in the previous cycle and we still
> > + * need to initialise partially filled pages within the remapped range.
> 
> Must the ->iomap_begin implementation also take care to carry-over the
> IOMAP_F_NEW to the mapping if IOMAP_F_STALE is set?  Is it responsible
> for dropping IOMAP_F_STALE, or will iomap_iter* do that?

iomap_iter() carries STALE and NEW over to the the next
->iomap_begin() call, which is then responsible for clearing STALE
and propagating NEW if required.


> > diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> > index 238a03087e17..308931f0840a 100644
> > --- a/include/linux/iomap.h
> > +++ b/include/linux/iomap.h
> > @@ -62,8 +62,13 @@ struct vm_fault;
> >   *
> >   * IOMAP_F_SIZE_CHANGED indicates to the iomap_end method that the file size
> >   * has changed as the result of this write operation.
> > + *
> > + * IOMAP_F_STALE indicates that the iomap is not valid any longer and the file
> > + * range it covers needs to be remapped by the high level before the operation
> > + * can proceed.
> 
> I think it might be worth mentioning that /any/ iomap_iter caller can
> set this flag in the loop body and kick things back to ->iomap_begin.

*nod*

-Dave.
-- 
Dave Chinner
david@fromorbit.com
