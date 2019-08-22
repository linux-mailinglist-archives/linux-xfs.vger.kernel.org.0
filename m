Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 880D499321
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Aug 2019 14:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbfHVMTG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Aug 2019 08:19:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:33234 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727874AbfHVMTG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Aug 2019 08:19:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39D9CAFBE;
        Thu, 22 Aug 2019 12:19:05 +0000 (UTC)
Subject: Re: [PATCH 2/3] xfs: add kmem_alloc_io()
To:     Dave Chinner <david@fromorbit.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, penguin-kernel@I-love.SAKURA.ne.jp
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-3-david@fromorbit.com>
 <20190821232440.GB24904@infradead.org>
 <20190822003131.GR1119@dread.disaster.area>
 <20190822075948.GA31346@infradead.org>
 <20190822085130.GI2349@hirez.programming.kicks-ass.net>
 <20190822091057.GK2386@hirez.programming.kicks-ass.net>
 <20190822101441.GY1119@dread.disaster.area>
 <ddcdc274-be61-6e40-5a14-a4faa954f090@suse.cz>
 <20190822120725.GA1119@dread.disaster.area>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <ad8037c8-d1af-fb4f-1226-af585df492d3@suse.cz>
Date:   Thu, 22 Aug 2019 14:19:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822120725.GA1119@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/22/19 2:07 PM, Dave Chinner wrote:
> On Thu, Aug 22, 2019 at 01:14:30PM +0200, Vlastimil Babka wrote:
> 
> No, the problem is this (using kmalloc as a general term for
> allocation, whether it be kmalloc, kmem_cache_alloc, alloc_page, etc)
> 
>    some random kernel code
>     kmalloc(GFP_KERNEL)
>      reclaim
>      PF_MEMALLOC
>      shrink_slab
>       xfs_inode_shrink
>        XFS_ILOCK
>         xfs_buf_allocate_memory()
>          kmalloc(GFP_KERNEL)
> 
> And so locks on inodes in reclaim are seen below reclaim. Then
> somewhere else we have:
> 
>    some high level read-only xfs code like readdir
>     XFS_ILOCK
>      xfs_buf_allocate_memory()
>       kmalloc(GFP_KERNEL)
>        reclaim
> 
> And this one throws false positive lockdep warnings because we
> called into reclaim with XFS_ILOCK held and GFP_KERNEL alloc

OK, and what exactly makes this positive a false one? Why can't it continue like
the first example where reclaim leads to another XFS_ILOCK, thus deadlock?

> context. So the only solution we had at the tiem to shut it up was:
> 
>    some high level read-only xfs code like readdir
>     XFS_ILOCK
>      xfs_buf_allocate_memory()
>       kmalloc(GFP_NOFS)
> 
> So that lockdep sees it's not going to recurse into reclaim and
> doesn't throw a warning...

AFAICS that GFP_NOFS would fix not only a warning but also a real deadlock
(depending on the answer to my previous question).

> Cheers,
> 
> Dave.
> 

