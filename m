Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB729426560
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Oct 2021 09:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbhJHHuj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Oct 2021 03:50:39 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:43608 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhJHHuh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Oct 2021 03:50:37 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0BB751FD70;
        Fri,  8 Oct 2021 07:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633679321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZelD4w9CDZNOGwHQrpHZ9Ow+bu3ULaS3im3bY0kWS+Y=;
        b=LOEmWf21Avco99a6kn/i9X+G9LI0yHaGGx7uXZgqQ0JWZ5cwogYhWkG1VS2c0mN/9U4m1v
        BPuFaqnQvJSdwH5lxe0uHuZIqcXMd+ng0EfdoP/67WyjQs7UCqGqCesSj92C7alF7+wzZ+
        0qEeyR1N9aO7eVwbG+9jtQO6mv2YyjE=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AFD3DA3B89;
        Fri,  8 Oct 2021 07:48:40 +0000 (UTC)
Date:   Fri, 8 Oct 2021 09:48:39 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     NeilBrown <neilb@suse.de>
Cc:     Dave Chinner <david@fromorbit.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/6] MM: improve documentation for __GFP_NOFAIL
Message-ID: <YV/31+qXwqEgaxJL@dhcp22.suse.cz>
References: <163184698512.29351.4735492251524335974.stgit@noble.brown>
 <163184741778.29351.16920832234899124642.stgit@noble.brown>
 <b680fb87-439b-0ba4-cf9f-33d729f27941@suse.cz>
 <YVwyhDnE/HEnoLAi@dhcp22.suse.cz>
 <eba04a07-99da-771a-ab6b-36de41f9f120@suse.cz>
 <20211006231452.GF54211@dread.disaster.area>
 <YV7G7gyfZkmw7/Ae@dhcp22.suse.cz>
 <163364854551.31063.4377741712039731672@noble.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163364854551.31063.4377741712039731672@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri 08-10-21 10:15:45, Neil Brown wrote:
> On Thu, 07 Oct 2021, Michal Hocko wrote:
> > On Thu 07-10-21 10:14:52, Dave Chinner wrote:
> > > On Tue, Oct 05, 2021 at 02:27:45PM +0200, Vlastimil Babka wrote:
> > > > On 10/5/21 13:09, Michal Hocko wrote:
> > > > > On Tue 05-10-21 11:20:51, Vlastimil Babka wrote:
> > > > > [...]
> > > > >> > --- a/include/linux/gfp.h
> > > > >> > +++ b/include/linux/gfp.h
> > > > >> > @@ -209,7 +209,11 @@ struct vm_area_struct;
> > > > >> >   * used only when there is no reasonable failure policy) but it is
> > > > >> >   * definitely preferable to use the flag rather than opencode endless
> > > > >> >   * loop around allocator.
> > > > >> > - * Using this flag for costly allocations is _highly_ discouraged.
> > > > >> > + * Use of this flag may lead to deadlocks if locks are held which would
> > > > >> > + * be needed for memory reclaim, write-back, or the timely exit of a
> > > > >> > + * process killed by the OOM-killer.  Dropping any locks not absolutely
> > > > >> > + * needed is advisable before requesting a %__GFP_NOFAIL allocate.
> > > > >> > + * Using this flag for costly allocations (order>1) is _highly_ discouraged.
> > > > >> 
> > > > >> We define costly as 3, not 1. But sure it's best to avoid even order>0 for
> > > > >> __GFP_NOFAIL. Advising order>1 seems arbitrary though?
> > > > > 
> > > > > This is not completely arbitrary. We have a warning for any higher order
> > > > > allocation.
> > > > > rmqueue:
> > > > > 	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
> > > > 
> > > > Oh, I missed that.
> > > > 
> > > > > I do agree that "Using this flag for higher order allocations is
> > > > > _highly_ discouraged.
> > > > 
> > > > Well, with the warning in place this is effectively forbidden, not just
> > > > discouraged.
> > > 
> > > Yup, especially as it doesn't obey __GFP_NOWARN.
> > > 
> > > See commit de2860f46362 ("mm: Add kvrealloc()") as a direct result
> > > of unwittingly tripping over this warning when adding __GFP_NOFAIL
> > > annotations to replace open coded high-order kmalloc loops that have
> > > been in place for a couple of decades without issues.
> > > 
> > > Personally I think that the way __GFP_NOFAIL is first of all
> > > recommended over open coded loops and then only later found to be
> > > effectively forbidden and needing to be replaced with open coded
> > > loops to be a complete mess.
> > 
> > Well, there are two things. Opencoding something that _can_ be replaced
> > by __GFP_NOFAIL and those that cannot because the respective allocator
> > doesn't really support that semantic. kvmalloc is explicit about that
> > IIRC. If you have a better way to consolidate the documentation then I
> > am all for it.
> 
> I think one thing that might help make the documentation better is to
> explicitly state *why* __GFP_NOFAIL is better than a loop.
> 
> It occurs to me that
>   while (!(p = kmalloc(sizeof(*p), GFP_KERNEL));
> 
> would behave much the same as adding __GFP_NOFAIL and dropping the
> 'while'.  So why not? I certainly cannot see the need to add any delay
> to this loop as kmalloc does a fair bit of sleeping when permitted.
> 
> I understand that __GFP_NOFAIL allows page_alloc to dip into reserves,
> but Mel holds that up as a reason *not* to use __GFP_NOFAIL as it can
> impact on other subsystems.

__GFP_NOFAIL usage is a risk on its own. It is a hard requirement that
the allocator cannot back off. So it has to absolutely everything to
suceed. Whether it cheats and dips into reserves or not is a mere
implementation detail and a subject to the specific implementation.

> Why not just let the caller decide if they
> deserve the boost, but oring in __GFP_ATOMIC or __GFP_MEMALLOC as
> appropriate.

They can do that. Explicit access to memory reserves is allowed unless
it is explicitly forbidden by NOMEMALLOC flag.

> I assume there is a good reason.  I vaguely remember the conversation
> that lead to __GFP_NOFAIL being introduced.  I just cannot remember or
> deduce what the reason is.  So it would be great to have it documented.

The basic reason is that if the allocator knows this is must suceed
allocation request then it can prioritize it in some way. A dumb kmalloc
loop as you pictured it is likely much less optimal in that sense, isn't
it? Compare that to mempool allocator which is non failing as well but
it has some involved handling and that is certainly not a good fit for
__GFP_NOFAIL in the page allocator.
 
> > > Not to mention on the impossibility of using __GFP_NOFAIL with
> > > kvmalloc() calls. Just what do we expect kmalloc_node(__GFP_NORETRY
> > > | __GFP_NOFAIL) to do, exactly?
> > 
> > This combination doesn't make any sense. Like others. Do you want us to
> > list all combinations that make sense?
> 
> I've been wondering about that.  There seem to be sets of flags that are
> mutually exclusive.  It is as though gfp_t is a struct of a few enums.
> 
> 0, DMA32, DMA, HIGHMEM
> 0, FS, IO
> 0, ATOMIC, MEMALLOC, NOMEMALLOC, HIGH
> NORETRY, RETRY_MAYFAIL, 0, NOFAIL
> 0, KSWAPD_RECLAIM, DIRECT_RECLAIM
> 0, THISNODE, HARDWALL
> 
> In a few cases there seem to be 3 bits where there are only 4 possibly
> combinations, so 2 bits would be enough.  There is probably no real
> value is squeezing these into 2 bits, but clearly documenting the groups
> surely wouldn't hurt.  Particularly highlighting the difference between
> related bits would help.

Don't we have that already? We have them grouped by placement,
watermarks, reclaim and action modifiers. Then we have useful
combinations. I believe we can always improve on that and I am always
ready to listen here.

> The set with  'ATOMIC' is hard to wrap my mind around.
> They relate to ALLOC_HIGH and ALLOC_HARDER, but also to WMARK_NIN,
> WMARK_LOW, WMARK_HIGH ... I think.

ALLOC* and WMARK* is an internal allocator concept and I believe users
of gfp flags shouldn't really care or even know those exist.

> I wonder if FS,IO is really in the same set as DIRECT_RECLAIM as they
> all affect reclaim.  Maybe FS and IO are only relevan if DIRECT_RECLAIM
> is set?

yes, this indeed the case. Page allocator doesn't go outside of its
proper without the direct reclaim.

> I'd love to know that to expect if neither RETRY_MAYFAIL or NOFAIL is
> set.  I guess it can fail, but it still tries harder than if
> RETRY_MAYFAIL is set....
> Ahhhh...  I found some documentation which mentions

The reclaim behavior is described along with the respective modifiers. I
believe we can thank you for this structure as you were the primary
driving force to clarify the behavior.

> that RETRY_MAYFAIL
> doesn't trigger the oom killer.  Is that it? So RETRY_NOKILLOOM might be
> a better name?

Again the those are implementation details and I am not sure we really
want to bother users with all of them. This wold quickly become hairy
and likely even outdated after some time. The documentation tries to
describe different levels of involvement. NOWAIT - no direct reclaim,
NORETRY - only a light attempt to reclaim, RETRY_MAYFAIL - try as hard
as feasible, NOFAIL - cannot really fail.

If we can improve the wording I am all for it.
 
> > > So, effectively, we have to open-code around kvmalloc() in
> > > situations where failure is not an option. Even if we pass
> > > __GFP_NOFAIL to __vmalloc(), it isn't guaranteed to succeed because
> > > of the "we won't honor gfp flags passed to __vmalloc" semantics it
> > > has.
> > 
> > yes vmalloc doesn't support nofail semantic and it is not really trivial
> > to craft it there.
> > 
> > > Even the API constaints of kvmalloc() w.r.t. only doing the vmalloc
> > > fallback if the gfp context is GFP_KERNEL - we already do GFP_NOFS
> > > kvmalloc via memalloc_nofs_save/restore(), so this behavioural
> > > restriction w.r.t. gfp flags just makes no sense at all.
> > 
> > GFP_NOFS (without using the scope API) has the same problem as NOFAIL in
> > the vmalloc. Hence it is not supported. If you use the scope API then
> > you can GFP_KERNEL for kvmalloc. This is clumsy but I am not sure how to
> > define these conditions in a more sensible way. Special case NOFS if the
> > scope api is in use? Why do you want an explicit NOFS then?
> 
> It would seem to make sense for kvmalloc to WARN_ON if it is passed
> flags that does not allow it to use vmalloc.

vmalloc is certainly not the hottest path in the kernel so I wouldn't be
opposed. One should be careful that WARN_ON is effectively BUG_ON in
some configurations but we are sinners from that perspective all over
the place...

Thanks!
-- 
Michal Hocko
SUSE Labs
