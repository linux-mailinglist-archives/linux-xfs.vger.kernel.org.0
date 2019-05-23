Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 004BF2742D
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2019 03:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfEWB5E (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 May 2019 21:57:04 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:45219 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728050AbfEWB5E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 May 2019 21:57:04 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id F31793DC479;
        Thu, 23 May 2019 11:57:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hTcyZ-0005Ym-Dv; Thu, 23 May 2019 11:56:59 +1000
Date:   Thu, 23 May 2019 11:56:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/11] xfs: rework extent allocation
Message-ID: <20190523015659.GL29573@dread.disaster.area>
References: <20190522180546.17063-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522180546.17063-1-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=7-415B0cAAAA:8 a=eE-nRBHBM5CuMY_OslEA:9 a=CjuIK1q_8ugA:10
        a=igBNqPyMv6gA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 22, 2019 at 02:05:35PM -0400, Brian Foster wrote:
> Hi all,
> 
> This is v2 of the extent allocation rework series. The changes in this
> version are mostly associated with code factoring, based on feedback to
> v1. The small mode helper refactoring has been isolated and pulled to
> the start of the series. The active flag that necessitated the btree
> cursor container structure has been pushed into the xfs_btree_cur
> private area. The resulting high level allocation code in
> xfs_ag_alloc_vextent() has been cleaned up to remove an unnecessary
> level of abstraction. Finally, there are various minor cleanups and
> fixes.
> 
> On the testing front, I've run a couple more filebench oriented tests
> since v1. The first is a high load, large filesystem, parallel file
> write+fsync test to try and determine whether the modified near mode
> allocation algorithm resulted in larger latencies in the common
> (non-fragmented) case. The results show comparable latencies, though the
> updated algorithm has a slightly faster overall runtime for whatever
> reason.

Probably indicative that over so many allocations, saving a few
microseconds of CPU time here and there adds up. That's also a fairly
good indication that the IO behaviour hasn't dramatically changed
between algorithms - we're not adding or removing a huge number of
seeks to the workload....

> The second is another filebench test (but with a smaller fileset against
> a smaller filesystem), but with the purpose of measuring "locality
> effectiveness" of the updated algorithm via post-test analysis of the
> resulting/populated filesystem. I've been thinking a bit about how to
> test for locality since starting on this series and ultimately came up
> with the following, fairly crude heuristic: track and compare the worst
> locality allocation for each regular file inode in the fs.

OK, that's pretty crude :P

> This
> essentially locates the most distant extent for each inode, tracks the
> delta from that extent to the inode location on disk and calculates the
> average worst case delta across the entire set of regular files. The
> results show that the updated algorithm provides a comparable level of
> locality to the existing algorithm.

The problem with this is that worse case locality isn't a
particularly useful measure. In general, when you have allocator
contention it occurs on the AGF locks and so the allocator skips to
the next AG it can lock. That means if we have 32 AGs and 33
allocations in progress at once, the AG that it chosen for
allocation is going to be essentially random. This means worst case
allocation locality is always going to be "ag skip" distances and so
the jumps between AGs are going to largely dominate the measured
locality distances.

In this case, 7TB, 32AGs = ~220GB per AG, so an AG skip will be
around 220 * 2^30 / 2^9 = ~460m sectors and:

> - baseline	- min: 8  max: 568752250 median: 434794.5 mean: 11446328
> - test		- min: 33 max: 568402234 median: 437405.5 mean: 11752963
> - by-size only	- min: 33 max: 568593146 median: 784805   mean: 11912300

max are all >460m sectors and so are AG skip distances.

However, the changes you've made affect locality for allocations
_within_ an AG, not across the filesystem, and so anything that
skips to another AG really needs to be measured differently.

i.e. what we really need to measure here is "how close to target did
we get?" and for extending writes the target is always the AGBNO of
the end of the last extent.

The inode itself is only used as the target for the first extent, so
using it as the only distance comparison ignores the fact we try to
allocate as close to the end of the last extent as possible, not as
close to the inode as possible. Hence once a file has jumped AG, it
will stay in the new AG and not return to the original AG the inode
is in. This means that once the file data changes locality, it tries
to keep that same locality for the next data that is written, not
force another seek back to the original location.

So, AFAICT, the measure of locality we should be using to evaluate
the impact to locality of the new algorithm is the distance between
sequential extents in a file allocated within the same AG, not the
worst case distance from the inode....

Cheers,

Dave.

(*) Which, in reality, we really should reset because once we jump
AG we have no locality target and so should allow the full AG to be
considered. This "didn't reset target" issue is something I suspect
leads to the infamous "backwards allocation for sequential writes"
problems...

-- 
Dave Chinner
david@fromorbit.com
