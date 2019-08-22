Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F600994B6
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Aug 2019 15:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732276AbfHVNSw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Aug 2019 09:18:52 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40689 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732271AbfHVNSw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 09:18:52 -0400
Received: from dread.disaster.area (pa49-181-142-13.pa.nsw.optusnet.com.au [49.181.142.13])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2D8DF361886;
        Thu, 22 Aug 2019 23:18:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i0myB-0002Bq-P1; Thu, 22 Aug 2019 23:17:39 +1000
Date:   Thu, 22 Aug 2019 23:17:39 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [PATCH 2/3] xfs: add kmem_alloc_io()
Message-ID: <20190822131739.GB1119@dread.disaster.area>
References: <20190821083820.11725-3-david@fromorbit.com>
 <20190821232440.GB24904@infradead.org>
 <20190822003131.GR1119@dread.disaster.area>
 <20190822075948.GA31346@infradead.org>
 <20190822085130.GI2349@hirez.programming.kicks-ass.net>
 <20190822091057.GK2386@hirez.programming.kicks-ass.net>
 <20190822101441.GY1119@dread.disaster.area>
 <ddcdc274-be61-6e40-5a14-a4faa954f090@suse.cz>
 <20190822120725.GA1119@dread.disaster.area>
 <ad8037c8-d1af-fb4f-1226-af585df492d3@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad8037c8-d1af-fb4f-1226-af585df492d3@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=pdRIKMFd4+xhzJrg6WzXNA==:117 a=pdRIKMFd4+xhzJrg6WzXNA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=0gar0xGGpDVc-5Bg6r8A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 22, 2019 at 02:19:04PM +0200, Vlastimil Babka wrote:
> On 8/22/19 2:07 PM, Dave Chinner wrote:
> > On Thu, Aug 22, 2019 at 01:14:30PM +0200, Vlastimil Babka wrote:
> > 
> > No, the problem is this (using kmalloc as a general term for
> > allocation, whether it be kmalloc, kmem_cache_alloc, alloc_page, etc)
> > 
> >    some random kernel code
> >     kmalloc(GFP_KERNEL)
> >      reclaim
> >      PF_MEMALLOC
> >      shrink_slab
> >       xfs_inode_shrink
> >        XFS_ILOCK
> >         xfs_buf_allocate_memory()
> >          kmalloc(GFP_KERNEL)
> > 
> > And so locks on inodes in reclaim are seen below reclaim. Then
> > somewhere else we have:
> > 
> >    some high level read-only xfs code like readdir
> >     XFS_ILOCK
> >      xfs_buf_allocate_memory()
> >       kmalloc(GFP_KERNEL)
> >        reclaim
> > 
> > And this one throws false positive lockdep warnings because we
> > called into reclaim with XFS_ILOCK held and GFP_KERNEL alloc
> 
> OK, and what exactly makes this positive a false one? Why can't it continue like
> the first example where reclaim leads to another XFS_ILOCK, thus deadlock?

Because above reclaim we only have operations being done on
referenced inodes, and below reclaim we only have unreferenced
inodes. We never lock the same inode both above and below reclaim
at the same time.

IOWs, an operation above reclaim cannot see, access or lock
unreferenced inodes, except in inode write clustering, and that uses
trylocks so cannot deadlock with reclaim.

An operation below reclaim cannot see, access or lock referenced
inodes except during inode write clustering, and that uses trylocks
so cannot deadlock with code above reclaim.

FWIW, I'm trying to make the inode writeback clustering go away from
reclaim at the moment, so even that possibility is going away soon.
That will change everything to trylocks in reclaim context, so
lockdep is going to stop tracking it entirely.

Hmmm - maybe we're getting to the point where we actually
don't need GFP_NOFS/PF_MEMALLOC_NOFS at all in XFS anymore.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
