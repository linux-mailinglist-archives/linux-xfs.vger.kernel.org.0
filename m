Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46CCD9967A
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Aug 2019 16:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731764AbfHVO0o (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Aug 2019 10:26:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:50412 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731709AbfHVO0o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Aug 2019 10:26:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 03D13AC47;
        Thu, 22 Aug 2019 14:26:42 +0000 (UTC)
Subject: Re: [PATCH 2/3] xfs: add kmem_alloc_io()
To:     Dave Chinner <david@fromorbit.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, penguin-kernel@I-love.SAKURA.ne.jp
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
 <20190822131739.GB1119@dread.disaster.area>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <db4a1dae-d69a-0df4-4a71-02c2954ecd75@suse.cz>
Date:   Thu, 22 Aug 2019 16:26:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822131739.GB1119@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/22/19 3:17 PM, Dave Chinner wrote:
> On Thu, Aug 22, 2019 at 02:19:04PM +0200, Vlastimil Babka wrote:
>> On 8/22/19 2:07 PM, Dave Chinner wrote:
>> > On Thu, Aug 22, 2019 at 01:14:30PM +0200, Vlastimil Babka wrote:
>> > 
>> > No, the problem is this (using kmalloc as a general term for
>> > allocation, whether it be kmalloc, kmem_cache_alloc, alloc_page, etc)
>> > 
>> >    some random kernel code
>> >     kmalloc(GFP_KERNEL)
>> >      reclaim
>> >      PF_MEMALLOC
>> >      shrink_slab
>> >       xfs_inode_shrink
>> >        XFS_ILOCK
>> >         xfs_buf_allocate_memory()
>> >          kmalloc(GFP_KERNEL)
>> > 
>> > And so locks on inodes in reclaim are seen below reclaim. Then
>> > somewhere else we have:
>> > 
>> >    some high level read-only xfs code like readdir
>> >     XFS_ILOCK
>> >      xfs_buf_allocate_memory()
>> >       kmalloc(GFP_KERNEL)
>> >        reclaim
>> > 
>> > And this one throws false positive lockdep warnings because we
>> > called into reclaim with XFS_ILOCK held and GFP_KERNEL alloc
>> 
>> OK, and what exactly makes this positive a false one? Why can't it continue like
>> the first example where reclaim leads to another XFS_ILOCK, thus deadlock?
> 
> Because above reclaim we only have operations being done on
> referenced inodes, and below reclaim we only have unreferenced
> inodes. We never lock the same inode both above and below reclaim
> at the same time.
> 
> IOWs, an operation above reclaim cannot see, access or lock
> unreferenced inodes, except in inode write clustering, and that uses
> trylocks so cannot deadlock with reclaim.
> 
> An operation below reclaim cannot see, access or lock referenced
> inodes except during inode write clustering, and that uses trylocks
> so cannot deadlock with code above reclaim.

Thanks for elaborating. Perhaps lockdep experts (not me) would know how to
express that. If not possible, then replacing GFP_NOFS with __GFP_NOLOCKDEP
should indeed suppress the warning, while allowing FS reclaim.

> FWIW, I'm trying to make the inode writeback clustering go away from
> reclaim at the moment, so even that possibility is going away soon.
> That will change everything to trylocks in reclaim context, so
> lockdep is going to stop tracking it entirely.

That's also a nice solution :)

> Hmmm - maybe we're getting to the point where we actually
> don't need GFP_NOFS/PF_MEMALLOC_NOFS at all in XFS anymore.....
> 
> Cheers,
> 
> Dave.
> 

