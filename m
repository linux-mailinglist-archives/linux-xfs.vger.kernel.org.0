Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 134C038ABE
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 14:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbfFGM5n (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 08:57:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbfFGM5n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jun 2019 08:57:43 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A62B213A4D;
        Fri,  7 Jun 2019 12:57:42 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 507DE7FD5F;
        Fri,  7 Jun 2019 12:57:42 +0000 (UTC)
Date:   Fri, 7 Jun 2019 08:57:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/11] xfs: rework extent allocation
Message-ID: <20190607125740.GC57123@bfoster>
References: <20190522180546.17063-1-bfoster@redhat.com>
 <20190523015659.GL29573@dread.disaster.area>
 <20190523125535.GA20099@bfoster>
 <20190523221552.GM29573@dread.disaster.area>
 <20190524120015.GA32730@bfoster>
 <20190525224317.GZ29573@dread.disaster.area>
 <20190531171136.GA26315@bfoster>
 <20190606152101.GA2791@bfoster>
 <20190606221301.GC14308@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606221301.GC14308@dread.disaster.area>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 07 Jun 2019 12:57:42 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 07, 2019 at 08:13:01AM +1000, Dave Chinner wrote:
> On Thu, Jun 06, 2019 at 11:21:04AM -0400, Brian Foster wrote:
> > On Fri, May 31, 2019 at 01:11:36PM -0400, Brian Foster wrote:
> > > On Sun, May 26, 2019 at 08:43:17AM +1000, Dave Chinner wrote:
> > > > On Fri, May 24, 2019 at 08:00:18AM -0400, Brian Foster wrote:
> > > > > On Fri, May 24, 2019 at 08:15:52AM +1000, Dave Chinner wrote:
> > > > > > On Thu, May 23, 2019 at 08:55:35AM -0400, Brian Foster wrote:
> > > > > > > Hmmm.. I suppose if I had a script that
> > > > > > > just dumped every applicable stride/delta value for an inode, I could
> > > > > > > dump all of those numbers into a file and we can process it from there..
> > > > > > 
> > > > > > See how the freesp commands work in xfs_db - they just generate a
> > > > > > set of {offset, size} tuples that are then bucketted appropriately.
> > > > > > This is probably the best way to do this at the moment - have xfs_db
> > > > > > walk the inode BMBTs outputting something like {extent size,
> > > > > > distance to next extent} tuples and everything else falls out from
> > > > > > how we bucket that information.
> > > > > > 
> > > > > 
> > > > > That sounds plausible. A bit more involved than what I'm currently
> > > > > working with, but we do already have a blueprint for the scanning
> > > > > implementation required to collect this data via the frag command.
> > > > > Perhaps some of this code between the frag/freesp can be generalized and
> > > > > reused. I'll take a closer look at it.
> > > > > 
> > > > > My only concern is I'd prefer to only go down this path as long as we
> > > > > plan to land the associated command in xfs_db. So this approach suggests
> > > > > to me that we add a "locality" command similar to frag/freesp that
> > > > > presents the locality state of the fs. For now I'm only really concerned
> > > > > with the data associated with known near mode allocations (i.e., such as
> > > > > the extent size:distance relationship you've outlined above) so we can
> > > > > evaluate these algorithmic changes, but this would be for fs devs only
> > > > > so we could always expand on it down the road if we want to assess
> > > > > different allocations. Hm?
> > > > 
> > > > Yup, I'm needing to do similar analysis myself to determine how
> > > > quickly I'm aging the filesystem, so having the tool in xfs_db or
> > > > xfs_spaceman would be very useful.
> > > > 
> > > > FWIW, the tool I've just started writing will just use fallocate and
> > > > truncate to hammer the allocation code as hard and as quickly as
> > > > possible - I want to do accelerated aging of the filesystem, and so
> > > > being able to run tens to hundreds of thousands of free space
> > > > manipulations a second is the goal here....
> > > > 
> > > 
> > > Ok. FWIW, from playing with this so far (before getting distracted for
> > > much of this week) the most straightforward place to add this kind of
> > > functionality turns out to be the frag command itself. It does 99% of
> > > the work required to process data extents already, including pulling the
> > > on-disk records of each inode in-core for processing. I basically just
> > > had to update that code to include all of the record data and add the
> > > locality tracking logic (I haven't got to actually presenting it yet..).
> > > 
> > 
> > I managed to collect some preliminary data based on this strategy. I
> ....
> > 
> > Comparison of the baseline and test data shows a generally similar
> > breakdown between the two.
> 
> Which is the result I wanted to see :)
> 

Indeed. ;)

> > Thoughts on any of this data or presentation?
> 
> I think it's useful for comparing whether an allocator change has
> affected the overall locality of allocation. If it's working as we
> expect, you should get vastly different results for inode32 vs
> inode64 mount options, with inode32 showing much, much higher
> distances for most allocations, so it might be worth running a quick
> test to confirm that it does, indeed, demonstrate the results we'd
> expect from such a change.
> 

Ok, I can add inode32 into the mix as a sanity check. I'm guessing this
will result in an increase in AG skips. I also think that once we have
that first data allocation, the existing heuristics may apply similarly
since we're only concerned about contiguity with the previous extent at
that point. Perhaps I'll reserve this for a test with an even higher
inode count so there are more first data extent allocations (where the
inode is the locality target, but sits in a metadata preferred AG) to
measure.

> > I could dig further into
> > details or alternatively base the histogram on something like extent
> > size and show the average delta for each extent size bucket, but I'm not
> > sure that will tell us anything profound with respect to this patchset.
> 
> *nod*
> 
> > One thing I noticed while processing this data is that the current
> > dataset skews heavily towards smaller allocations. I still think it's a
> > useful comparison because smaller allocations are more likely to stress
> > either algorithm via a larger locality search space, but I may try to
> > repeat this test with a workload with fewer files and larger allocations
> > and see how that changes things.
> 
> From the testing I've been doing, I think the file count of around
> 10k isn't sufficient to really cause severe allocation issues.
> Directory and inodes metadata are great for fragmenting free space,
> so dramtically increasing the number of smaller files might actually
> produce worse behaviour....
> 

I'd still like to see the results for larger allocations if for nothing
else that I was hoping for more coverage from the most recent test. Once
I get through that, I'll move back in the smaller file direction and
increase the file count as well as the span of the directory tree.

Hmm, random file sizes between 4k and say 96k or so should allow me to
at least create tens of millions of files/dirs (I'd like to get above
64k for some of these allocations to cover post-eof prealloc). That
should stress the allocator as noted with the additional inode/dir
metadata allocations as well as facilitate inode32 experiments.

Thanks for the feedback..

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
