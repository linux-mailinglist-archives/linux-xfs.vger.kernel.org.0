Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F344D856B2
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Aug 2019 02:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbfHHADI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Aug 2019 20:03:08 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:48947 "EHLO
        outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730045AbfHHADH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Aug 2019 20:03:07 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Aug 2019 20:03:06 EDT
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
        by outbound-smtp05.blacknight.com (Postfix) with ESMTPS id 3197698960
        for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2019 00:55:36 +0100 (IST)
Received: (qmail 16038 invoked from network); 7 Aug 2019 23:55:36 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.18.93])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 7 Aug 2019 23:55:35 -0000
Date:   Thu, 8 Aug 2019 00:55:34 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] [Regression, v5.0] mm: boosted kswapd reclaim b0rks
 system cache balance
Message-ID: <20190807235534.GK2739@techsingularity.net>
References: <20190807091858.2857-1-david@fromorbit.com>
 <20190807093056.GS11812@dhcp22.suse.cz>
 <20190807150316.GL2708@suse.de>
 <20190807220817.GN7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20190807220817.GN7777@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 08, 2019 at 08:08:17AM +1000, Dave Chinner wrote:
> On Wed, Aug 07, 2019 at 04:03:16PM +0100, Mel Gorman wrote:
> > On Wed, Aug 07, 2019 at 11:30:56AM +0200, Michal Hocko wrote:
> > > [Cc Mel and Vlastimil as it seems like fallout from 1c30844d2dfe2]
> > > 
> > 
> > More than likely.
> > 
> > > On Wed 07-08-19 19:18:58, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > When running a simple, steady state 4kB file creation test to
> > > > simulate extracting tarballs larger than memory full of small files
> > > > into the filesystem, I noticed that once memory fills up the cache
> > > > balance goes to hell.
> > > > 
> > 
> > Ok, I'm assuming you are using fsmark with -k to keep files around,
> > and -S0 to leave cleaning to the background flush, a number of files per
> > iteration to get regular reporting and a total number of iterations to
> > fill memory to hit what you're seeing. I've created a configuration that
> > should do this but it'll take a long time to run on a local test machine.
> 
> ./fs_mark  -D  10000  -S0  -n  10000  -s  4096  -L  60 \
> -d /mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2 \
> -d /mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5 \
> -d /mnt/scratch/6  -d  /mnt/scratch/7  -d  /mnt/scratch/8 \
> -d /mnt/scratch/9  -d  /mnt/scratch/10  -d  /mnt/scratch/11 \
> -d /mnt/scratch/12  -d  /mnt/scratch/13  -d  /mnt/scratch/14 \
> -d /mnt/scratch/15
> 

Ok, I can replicate that. From a previous discussion my fs_mark setup is
able to replicate this sort of thing relatively easily. I'll tweak the
configuration. 

> This doesn't delete files at all, creates 160,000 files per
> iteration in directories of 10,000 files at a time, and runs 60
> iterations. It leaves all writeback (data and metadata) to
> background kernel mechanisms.
> 

Both our configurations left writeback to the background but I took a
different approach to get more reported results from fsmark.

> > I'm not 100% certain I guessed right as to get fsmark reports while memory
> > fills, it would have to be fewer files so each iteration would have to
> > preserve files. If the number of files per iteration is large enough to
> > fill memory then the drop in files/sec is not visible from the fs_mark
> > output (or we are using different versions). I guess you could just be
> > calculating average files/sec over the entire run based on elapsed time.
> 
> The files/s average is the average of the fsmark iteration output.
> (i.e. the rate at which it creates each group of 160k files).
> 

Good to confirm for sure.

> > 
> > > > The workload is creating one dirty cached inode for every dirty
> > > > page, both of which should require a single IO each to clean and
> > > > reclaim, and creation of inodes is throttled by the rate at which
> > > > dirty writeback runs at (via balance dirty pages). Hence the ingest
> > > > rate of new cached inodes and page cache pages is identical and
> > > > steady. As a result, memory reclaim should quickly find a steady
> > > > balance between page cache and inode caches.
> > > > 
> > > > It doesn't.
> > > > 
> > > > The moment memory fills, the page cache is reclaimed at a much
> > > > faster rate than the inode cache, and evidence suggests taht the
> > > > inode cache shrinker is not being called when large batches of pages
> > > > are being reclaimed. In roughly the same time period that it takes
> > > > to fill memory with 50% pages and 50% slab caches, memory reclaim
> > > > reduces the page cache down to just dirty pages and slab caches fill
> > > > the entirity of memory.
> > > > 
> > > > At the point where the page cache is reduced to just the dirty
> > > > pages, there is a clear change in write IO patterns. Up to this
> > > > point it has been running at a steady 1500 write IOPS for ~200MB/s
> > > > of write throughtput (data, journal and metadata).
> > 
> > As observed by iostat -x or something else? Sum of r/s and w/s would
> 
> PCP + live pmcharts. Same as I've done for 15+ years :)
> 

Yep. This is not the first time I thought I should wire PCP into
mmtests. There are historical reasons why it didn't happen but they are
getting less and less relevant.

> I could look at iostat, but it's much easier to watch graphs run
> and then be able to double click on any point and get the actual
> value.
> 

Can't argue with the logic.

> I've attached a screen shot of the test machine overview while the
> vanilla kernel runs the fsmark test (cpu, iops, IO bandwidth, XFS
> create/remove/lookup ops, context switch rate and memory usage) at a
> 1 second sample rate. You can see the IO patterns change, the
> context switch rate go nuts and the CPU usage pattern change when
> the page cache hits empty.
> 

Indeed.

> > approximate iops but not the breakdown of whether it is data, journal
> > or metadata writes.
> 
> I have that in other charts - the log chart tells me how many log
> IOs are being done (constant 30MB/s in ~150 IOs/sec). And the >1GB/s
> IO spike every 30s is the metadata writeback being aggregated into
> large IOs by metadata writeback. That doesn't change, either...
> 

Understood.

> > The rest can be inferred from a blktrace but I would
> > prefer to replicate your setup as close as possible. If you're not using
> > fs_mark to report Files/sec, are you simply monitoring df -i over time?
> 
> The way I run fsmark is iterative - the count field tells you how
> many inodes it has created...
> 

Understood, I'll update tests accordingly.

> > > > So I went looking at the code, trying to find places where pages got
> > > > reclaimed and the shrinkers weren't called. There's only one -
> > > > kswapd doing boosted reclaim as per commit 1c30844d2dfe ("mm: reclaim
> > > > small amounts of memory when an external fragmentation event
> > > > occurs"). I'm not even using THP or allocating huge pages, so this
> > > > code should not be active or having any effect onmemory reclaim at
> > > > all, yet the majority of reclaim is being done with "boost" and so
> > > > it's not reclaiming slab caches at all. It will only free clean
> > > > pages from the LRU.
> > > > 
> > > > And so when we do run out memory, it switches to normal reclaim,
> > > > which hits dirty pages on the LRU and does some shrinker work, too,
> > > > but then appears to switch back to boosted reclaim one watermarks
> > > > are reached.
> > > > 
> > > > The patch below restores page cache vs inode cache balance for this
> > > > steady state workload. It balances out at about 40% page cache, 60%
> > > > slab cache, and sustained performance is 10-15% higher than without
> > > > this patch because the IO patterns remain in control of dirty
> > > > writeback and the filesystem, not kswapd.
> > > > 
> > > > Performance with boosted reclaim also running shrinkers over the
> > > > same steady state portion of the test as above.
> > > > 
> > 
> > The boosting was not intended to target THP specifically -- it was meant
> > to help recover early from any fragmentation-related event for any user
> > that might need it. Hence, it's not tied to THP but even with THP
> > disabled, the boosting will still take effect.
> > 
> > One band-aid would be to disable watermark boosting entirely when THP is
> > disabled but that feels wrong. However, I would be interested in hearing
> > if sysctl vm.watermark_boost_factor=0 has the same effect as your patch.
> 
> <runs test>
> 
> Ok, it still runs it out of page cache, but it doesn't drive page
> cache reclaim as hard once there's none left. The IO patterns are
> less peaky, context switch rates are increased from ~3k/s to 15k/s
> but remain pretty steady.
> 
> Test ran 5s faster and  file rate improved by ~2%. So it's better
> once the page cache is largerly fully reclaimed, but it doesn't
> prevent the page cache from being reclaimed instead of inodes....
> 

Ok. Ideally you would also confirm the patch itself works as you want.
It *should* but an actual confirmation would be nice.

> 
> > On that basis, it may justify ripping out the may_shrinkslab logic
> > everywhere. The downside is that some microbenchmarks will notice.
> > Specifically IO benchmarks that fill memory and reread (particularly
> > rereading the metadata via any inode operation) may show reduced
> > results.
> 
> Sure, but right now benchmarks that rely on page cache being
> retained are being screwed over :)
> 

Yeah. This is a perfect example of a change that will help some workloads
and hurt others. However, as mentioned elsewhere, predictable behaviour
is far easier to work with and it's closer to the historical behaviour.

> > Such benchmarks can be strongly affected by whether the inode
> > information is still memory resident and watermark boosting reduces
> > the changes the data is still resident in memory. Technically still a
> > regression but a tunable one.
> 
> /proc/sys/vm/vfs_cache_pressure is for tuning page cache/inode cache
> balance. It should not occur as a side effect of watermark boosting.
> Everyone knows about vfs_cache_pressure. Lots of people complain
> when it doesn't work, and that's something watermark boosting to
> change cache balance does.
> 

And this -- the fact that there is actually a tuning knob to deal with
the tradeoffs is better than the current vanilla boost behaviour which
has side-effects that cannot be tuned against. I'll update the changelog
and resend the patch tomorrow assuming that it actually fixes your
problem.

Thanks Dave (for both the report and the analysis that made this a
no-brainer)

-- 
Mel Gorman
SUSE Labs
