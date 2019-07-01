Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4A22647C
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2019 15:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbfEVNTj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 May 2019 09:19:39 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:53039 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728912AbfEVNTj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 May 2019 09:19:39 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E13D110D02D;
        Wed, 22 May 2019 16:19:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hTKat-0006Wy-7D; Wed, 22 May 2019 16:19:19 +1000
Date:   Wed, 22 May 2019 16:19:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/17] xfs: use bios directly to read and write the log
 recovery buffers
Message-ID: <20190522061919.GJ29573@dread.disaster.area>
References: <20190520161347.3044-1-hch@lst.de>
 <20190520161347.3044-15-hch@lst.de>
 <20190520233233.GF29573@dread.disaster.area>
 <20190521050943.GA29120@lst.de>
 <20190521222434.GH29573@dread.disaster.area>
 <20190522051214.GA19467@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522051214.GA19467@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=7-415B0cAAAA:8 a=UvsWPCcAFKgxLkx58OAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 22, 2019 at 07:12:14AM +0200, Christoph Hellwig wrote:
> On Wed, May 22, 2019 at 08:24:34AM +1000, Dave Chinner wrote:
> > Yeah, the log recovery code should probably be split in three - the
> > kernel specific IO code/API, the log parsing code (the bit that
> > finds head/tail and parses it into transactions for recovery) and
> > then the bit that actually does the recovery. THe logprint code in
> > userspace uses the parsing code, so that's the bit we need to share
> > with userspace...
> 
> Actually one thing I have on my TODO list is to move the log item type
> specific recovery code first into an ops vector, and then out to the
> xfs_*_item.c together with the code creating those items.  That isn't
> really all of the recovery code, but it seems like a useful split.

Sounds like the right place to me - it's roughly where I had in mind
to split the code as it's not until logprint decodes the
transactions and needs to parse the individual log items that it
diverges from the kernel code. So just having a set of op vectors
that we can supply from userspace to implement logprint would make
it much simpler....

> Note that the I/O code isn't really very log specific, it basically
> just is trivial I/O to a vmalloc buffer code.  In fact I wonder if
> I could just generalize it a little more and move it to the block layer.

Yeah, it's not complex, just different to userspace. Which is why
I thought just having a simple API to between it and the kernel log
code would make it easy to port...

> > I've got a rough AIO implementation backing the xfs_buf.c code in
> > userspace already. It works just fine and is massively faster than
> > the existing code on SSDs, so I don't see a problem with porting IO
> > code that assumes an AIO model anymore. i.e. Re-using the kernel AIO
> > model for all the buffer code in userspace is one of the reasons I'm
> > porting xfs-buf.c to userspace.
> 
> Given that we:
> 
>  a) do direct I/O everywhere
>  b) tend to do it on either a block device, or a file where we don't
>     need to allocate over holes
> 
> aio should be a win everywhere.

So far it is, but I haven't tested on spinning disks so I can't say
for certain that it is a win there. The biggest difference for SSDs
is that we completely bypass the prefetching code and so the
buffer cache memory footprint goes way down. Hence we save huge
amounts of CPU by avoiding allocating, freeing and faulting in
memory so we essentially stop bashing on and being limited by
mmap_sem contention.

> The only caveat is that CONFG_AIO
> is kernel option and could be turned off in some low end configs.

Should be trivial to add a configure option to turn it off and
have the IO code just call pread/pwrite directly and run the
completions synchronously. That's kind of how I'm building up the
patchset, anyway - AIO doesn't come along until after the xfs_buf.c
infrastructure is in place doing sync IO. I'll make a note to add a
--disable-aio config option when I get there....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
