Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62133805D
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 00:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfFFWOD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Jun 2019 18:14:03 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43162 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726837AbfFFWOC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jun 2019 18:14:02 -0400
Received: from dread.disaster.area (pa49-195-189-25.pa.nsw.optusnet.com.au [49.195.189.25])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1703F7E2CC3;
        Fri,  7 Jun 2019 08:13:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hZ0d3-0000W5-MZ; Fri, 07 Jun 2019 08:13:01 +1000
Date:   Fri, 7 Jun 2019 08:13:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/11] xfs: rework extent allocation
Message-ID: <20190606221301.GC14308@dread.disaster.area>
References: <20190522180546.17063-1-bfoster@redhat.com>
 <20190523015659.GL29573@dread.disaster.area>
 <20190523125535.GA20099@bfoster>
 <20190523221552.GM29573@dread.disaster.area>
 <20190524120015.GA32730@bfoster>
 <20190525224317.GZ29573@dread.disaster.area>
 <20190531171136.GA26315@bfoster>
 <20190606152101.GA2791@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606152101.GA2791@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=K5LJ/TdJMXINHCwnwvH1bQ==:117 a=K5LJ/TdJMXINHCwnwvH1bQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=7-415B0cAAAA:8 a=sLE1n750BRiLyhwtwDAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 06, 2019 at 11:21:04AM -0400, Brian Foster wrote:
> On Fri, May 31, 2019 at 01:11:36PM -0400, Brian Foster wrote:
> > On Sun, May 26, 2019 at 08:43:17AM +1000, Dave Chinner wrote:
> > > On Fri, May 24, 2019 at 08:00:18AM -0400, Brian Foster wrote:
> > > > On Fri, May 24, 2019 at 08:15:52AM +1000, Dave Chinner wrote:
> > > > > On Thu, May 23, 2019 at 08:55:35AM -0400, Brian Foster wrote:
> > > > > > Hmmm.. I suppose if I had a script that
> > > > > > just dumped every applicable stride/delta value for an inode, I could
> > > > > > dump all of those numbers into a file and we can process it from there..
> > > > > 
> > > > > See how the freesp commands work in xfs_db - they just generate a
> > > > > set of {offset, size} tuples that are then bucketted appropriately.
> > > > > This is probably the best way to do this at the moment - have xfs_db
> > > > > walk the inode BMBTs outputting something like {extent size,
> > > > > distance to next extent} tuples and everything else falls out from
> > > > > how we bucket that information.
> > > > > 
> > > > 
> > > > That sounds plausible. A bit more involved than what I'm currently
> > > > working with, but we do already have a blueprint for the scanning
> > > > implementation required to collect this data via the frag command.
> > > > Perhaps some of this code between the frag/freesp can be generalized and
> > > > reused. I'll take a closer look at it.
> > > > 
> > > > My only concern is I'd prefer to only go down this path as long as we
> > > > plan to land the associated command in xfs_db. So this approach suggests
> > > > to me that we add a "locality" command similar to frag/freesp that
> > > > presents the locality state of the fs. For now I'm only really concerned
> > > > with the data associated with known near mode allocations (i.e., such as
> > > > the extent size:distance relationship you've outlined above) so we can
> > > > evaluate these algorithmic changes, but this would be for fs devs only
> > > > so we could always expand on it down the road if we want to assess
> > > > different allocations. Hm?
> > > 
> > > Yup, I'm needing to do similar analysis myself to determine how
> > > quickly I'm aging the filesystem, so having the tool in xfs_db or
> > > xfs_spaceman would be very useful.
> > > 
> > > FWIW, the tool I've just started writing will just use fallocate and
> > > truncate to hammer the allocation code as hard and as quickly as
> > > possible - I want to do accelerated aging of the filesystem, and so
> > > being able to run tens to hundreds of thousands of free space
> > > manipulations a second is the goal here....
> > > 
> > 
> > Ok. FWIW, from playing with this so far (before getting distracted for
> > much of this week) the most straightforward place to add this kind of
> > functionality turns out to be the frag command itself. It does 99% of
> > the work required to process data extents already, including pulling the
> > on-disk records of each inode in-core for processing. I basically just
> > had to update that code to include all of the record data and add the
> > locality tracking logic (I haven't got to actually presenting it yet..).
> > 
> 
> I managed to collect some preliminary data based on this strategy. I
....
> 
> Comparison of the baseline and test data shows a generally similar
> breakdown between the two.

Which is the result I wanted to see :)

> Thoughts on any of this data or presentation?

I think it's useful for comparing whether an allocator change has
affected the overall locality of allocation. If it's working as we
expect, you should get vastly different results for inode32 vs
inode64 mount options, with inode32 showing much, much higher
distances for most allocations, so it might be worth running a quick
test to confirm that it does, indeed, demonstrate the results we'd
expect from such a change.

> I could dig further into
> details or alternatively base the histogram on something like extent
> size and show the average delta for each extent size bucket, but I'm not
> sure that will tell us anything profound with respect to this patchset.

*nod*

> One thing I noticed while processing this data is that the current
> dataset skews heavily towards smaller allocations. I still think it's a
> useful comparison because smaller allocations are more likely to stress
> either algorithm via a larger locality search space, but I may try to
> repeat this test with a workload with fewer files and larger allocations
> and see how that changes things.

From the testing I've been doing, I think the file count of around
10k isn't sufficient to really cause severe allocation issues.
Directory and inodes metadata are great for fragmenting free space,
so dramtically increasing the number of smaller files might actually
produce worse behaviour....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
