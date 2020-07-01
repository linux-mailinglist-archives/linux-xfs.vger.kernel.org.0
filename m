Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0BB2102A5
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jul 2020 06:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgGAEMG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Jul 2020 00:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbgGAEMG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 00:12:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD8CC061755;
        Tue, 30 Jun 2020 21:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cxS26j1kqb/npKNutTlSyM7+/KYZexcgqH00K0WcRKE=; b=LHVWr8fCHMQRh0I7lznNiZygOE
        H0xyr9K+doOszin3HKJLMAWX2ybRAnkNu8ctZRUlzMubMCf0HJV4/cRJmy/2K2TQ0Tu6oE4J9Zl7o
        Q79uR27aWh/aUtwege3ZI7nedkSmptSvqIyBu1ZqcS7QMX+iQbFInLf7PRpbDxsRfnc07oaJtPIIx
        yT8drQRhIo9a83DbUddoeseLWSBIxJa33PECmIVxV7TMjhGDsH3ZlObP0ugZexU6DX6Px7j3ZH3KR
        0KxNRlT/lNQjFYIaBm069nx3xKkxWotlnXPrHDMiP6lLjU2sgQIekuNhQ6nrKlAFIqKuFisW8tEjs
        x1S89aXg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqU6N-0001r3-5N; Wed, 01 Jul 2020 04:12:03 +0000
Date:   Wed, 1 Jul 2020 05:12:03 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Mikulas Patocka <mpatocka@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] mm: Add memalloc_nowait
Message-ID: <20200701041203.GQ25523@casper.infradead.org>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-7-willy@infradead.org>
 <20200629050851.GC1492837@kernel.org>
 <20200629121816.GC25523@casper.infradead.org>
 <20200629125231.GJ32461@dhcp22.suse.cz>
 <6421BC93-CF2F-4697-B5CB-5ECDAA9FCB37@kernel.org>
 <20200629212830.GJ25523@casper.infradead.org>
 <20200630063436.GA2369@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630063436.GA2369@dhcp22.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:34:36AM +0200, Michal Hocko wrote:
> On Mon 29-06-20 22:28:30, Matthew Wilcox wrote:
> [...]
> > The documentation is hard to add a new case to, so I rewrote it.  What
> > do you think?  (Obviously I'll split this out differently for submission;
> > this is just what I have in my tree right now).
> 
> I am fine with your changes. Few notes below.

Thanks!

> > -It turned out though that above approach has led to
> > -abuses when the restricted gfp mask is used "just in case" without a
> > -deeper consideration which leads to problems because an excessive use
> > -of GFP_NOFS/GFP_NOIO can lead to memory over-reclaim or other memory
> > -reclaim issues.
> 
> I believe this is an important part because it shows that new people
> coming to the existing code shouldn't take it as correct and rather
> question it. Also having a clear indication that overuse is causing real
> problems that might be not immediately visible to subsystems outside of
> MM.

It seemed to say a lot of the same things as this paragraph:

+You may notice that quite a few allocations in the existing code specify
+``GFP_NOIO`` or ``GFP_NOFS``. Historically, they were used to prevent
+recursion deadlocks caused by direct memory reclaim calling back into
+the FS or IO paths and blocking on already held resources. Since 4.12
+the preferred way to address this issue is to use the new scope APIs
+described below.

Since this is in core-api/ rather than vm/, I felt that discussion of
the problems that it causes to the mm was a bit too much detail for the
people who would be reading this document.  Maybe I could move that
information into a new Documentation/vm/reclaim.rst file?

Let's see if Our Grumpy Editor has time to give us his advice on this.

> > -FS/IO code then simply calls the appropriate save function before
> > -any critical section with respect to the reclaim is started - e.g.
> > -lock shared with the reclaim context or when a transaction context
> > -nesting would be possible via reclaim.  
> 
> [...]
> 
> > +These functions should be called at the point where any memory allocation
> > +would start to cause problems.  That is, do not simply wrap individual
> > +memory allocation calls which currently use ``GFP_NOFS`` with a pair
> > +of calls to memalloc_nofs_save() and memalloc_nofs_restore().  Instead,
> > +find the lock which is taken that would cause problems if memory reclaim
> > +reentered the filesystem, place a call to memalloc_nofs_save() before it
> > +is acquired and a call to memalloc_nofs_restore() after it is released.
> > +Ideally also add a comment explaining why this lock will be problematic.
> 
> The above text has mentioned the transaction context nesting as well and
> that was a hint by Dave IIRC. It is imho good to have an example of
> other reentrant points than just locks. I believe another useful example
> would be something like loop device which is mixing IO and FS layers but
> I am not familiar with all the details to give you an useful text.

I'll let Mikulas & Dave finish fighting about that before I write any
text mentioning the loop driver.  How about this for mentioning the
filesystem transaction possibility?

@@ -103,12 +103,16 @@ flags specified by any particular call to allocate memory.
 
 These functions should be called at the point where any memory allocation
 would start to cause problems.  That is, do not simply wrap individual
-memory allocation calls which currently use ``GFP_NOFS`` with a pair
-of calls to memalloc_nofs_save() and memalloc_nofs_restore().  Instead,
-find the lock which is taken that would cause problems if memory reclaim
+memory allocation calls which currently use ``GFP_NOFS`` with a pair of
+calls to memalloc_nofs_save() and memalloc_nofs_restore().  Instead, find
+the resource which is acquired that would cause problems if memory reclaim
 reentered the filesystem, place a call to memalloc_nofs_save() before it
 is acquired and a call to memalloc_nofs_restore() after it is released.
 Ideally also add a comment explaining why this lock will be problematic.
+A resource might be a lock which would need to be acquired by an attempt
+to reclaim memory, or it might be starting a transaction that should not
+nest over a memory reclaim transaction.  Deep knowledge of the filesystem
+or driver is often needed to place memory scoping calls correctly.
 
 Please note that the proper pairing of save/restore functions
 allows nesting so it is safe to call memalloc_noio_save() and

> > @@ -104,16 +134,19 @@ ARCH_KMALLOC_MINALIGN bytes.  For sizes which are a power of two, the
> >  alignment is also guaranteed to be at least the respective size.
> >  
> >  For large allocations you can use vmalloc() and vzalloc(), or directly
> > -request pages from the page allocator. The memory allocated by `vmalloc`
> > -and related functions is not physically contiguous.
> > +request pages from the page allocator.  The memory allocated by `vmalloc`
> > +and related functions is not physically contiguous.  The `vmalloc`
> > +family of functions don't support the old ``GFP_NOFS`` or ``GFP_NOIO``
> > +flags because there are hardcoded ``GFP_KERNEL`` allocations deep inside
> > +the allocator which are hard to remove.  However, the scope APIs described
> > +above can be used to limit the `vmalloc` functions.
> 
> I would reiterate "Do not just wrap vmalloc by the scope api but rather
> rely on the real scope for the NOFS/NOIO context". Maybe we want to
> stress out that once a scope is defined it is sticky to _all_
> allocations and all allocators within that scope. The text is already
> saying that but maybe we want to make it explicit and make it stand out.

yes.  I went with:

@@ -139,7 +143,10 @@ and related functions is not physically contiguous.  The `vmalloc`
 family of functions don't support the old ``GFP_NOFS`` or ``GFP_NOIO``
 flags because there are hardcoded ``GFP_KERNEL`` allocations deep inside
 the allocator which are hard to remove.  However, the scope APIs described
-above can be used to limit the `vmalloc` functions.
+above can be used to limit the `vmalloc` functions.  As described above,
+do not simply wrap individual calls in the scope APIs, but look for the
+underlying reason why the memory allocation may not call into filesystems
+or block devices.
 
 If you are not sure whether the allocation size is too large for
 `kmalloc`, it is possible to use kvmalloc() and its derivatives. It will


> [...]
> > diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> > index 6484569f50df..9fc091274d1d 100644
> > --- a/include/linux/sched/mm.h
> > +++ b/include/linux/sched/mm.h
> > @@ -186,9 +186,10 @@ static inline gfp_t current_gfp_context(gfp_t flags)
> >  		 * them.  noio implies neither IO nor FS and it is a weaker
> >  		 * context so always make sure it takes precedence.
> >  		 */
> > -		if (current->memalloc_nowait)
> > +		if (current->memalloc_nowait) {
> >  			flags &= ~__GFP_DIRECT_RECLAIM;
> > -		else if (current->memalloc_noio)
> > +			flags |= __GFP_NOWARN;
> 
> I dunno. I wouldn't make nowait implicitly NOWARN as well. At least not
> with the initial implementation. Maybe we will learn later that there is
> just too much unhelpful noise in the kernel log and will reconsider but
> I wouldn't just start with that. Also we might learn that there will be
> other modifiers for atomic (or should I say non-sleeping) scopes to be
> defined. E.g. access to memory reserves but let's just wait for real
> usecases.

Fair enough.  I'll drop that part.  Thanks!
