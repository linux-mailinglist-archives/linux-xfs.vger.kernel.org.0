Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0163D22157
	for <lists+linux-xfs@lfdr.de>; Sat, 18 May 2019 05:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfERDKk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 23:10:40 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:36210 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727260AbfERDKj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 23:10:39 -0400
Received: from dread.disaster.area (pa49-181-171-240.pa.nsw.optusnet.com.au [49.181.171.240])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 3997E3DC169;
        Sat, 18 May 2019 13:10:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hRpk2-0003KW-BS; Sat, 18 May 2019 13:10:34 +1000
Date:   Sat, 18 May 2019 13:10:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Hou Tao <houtao1@huawei.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Question about commit b450672fb66b ("iomap: sub-block dio needs
 to zeroout beyond EOF")
Message-ID: <20190518031034.GD29573@dread.disaster.area>
References: <8b1ba3a1-7ecc-6e1f-c944-26a51baa9747@huawei.com>
 <20190517065943.GC29573@dread.disaster.area>
 <e754939d-5ed7-b7b8-e3b7-c34b80f64b60@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e754939d-5ed7-b7b8-e3b7-c34b80f64b60@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=LhzQONXuMOhFZtk4TmSJIw==:117 a=LhzQONXuMOhFZtk4TmSJIw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=7-415B0cAAAA:8 a=dDXTAslRDiOJwitiIdoA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 08:56:35PM +0800, Hou Tao wrote:
> Hi,
> 
> On 2019/5/17 14:59, Dave Chinner wrote:
> > On Fri, May 17, 2019 at 10:41:44AM +0800, Hou Tao wrote:
> >> Hi,
> >>
> >> I don't understand why the commit b450672fb66b ("iomap: sub-block dio needs to zeroout beyond EOF") is needed here:
> >>
> >> diff --git a/fs/iomap.c b/fs/iomap.c
> >> index 72f3864a2e6b..77c214194edf 100644
> >> --- a/fs/iomap.c
> >> +++ b/fs/iomap.c
> >> @@ -1677,7 +1677,14 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
> >>                 dio->submit.cookie = submit_bio(bio);
> >>         } while (nr_pages);
> >>
> >> -       if (need_zeroout) {
> >> +       /*
> >> +        * We need to zeroout the tail of a sub-block write if the extent type
> >> +        * requires zeroing or the write extends beyond EOF. If we don't zero
> >> +        * the block tail in the latter case, we can expose stale data via mmap
> >> +        * reads of the EOF block.
> >> +        */
> >> +       if (need_zeroout ||
> >> +           ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
> >>                 /* zero out from the end of the write to the end of the block */
> >>                 pad = pos & (fs_block_size - 1);
> >>                 if (pad)
> >>
> >> If need_zeroout is false, it means the block neither is a unwritten block nor
> >> a newly-mapped block, but that also means the block must had been a unwritten block
> >> or a newly-mapped block before this write, so the block must have been zeroed, correct ?
> > 
> > No. One the contrary, it's a direct IO write to beyond the end of
> > the file which means the block has not been zeroed at all. If it is
> > an unwritten extent, it most definitely does not contain zeroes
> > (unwritten extents are a flag in the extent metadata, not zeroed
> > disk space) and so it doesn't matter it is written or unwritten we
> > must zero it before we update the file size.
> > 
> Ah, I still can not understand the reason why "the block has not been zeroed at all".
> Do you mean the scenario in which the past-EOF write tries to write an already mapped
> block and the past-EOF part of this block has not been zeroed ?

Yup. Speculative delayed allocation beyond EOF triggered by mmap()
or buffered writes() that has then been allocated by writeback, then
we do a dio that extends EOF into that space.

> Because if the past-EOF write tries to write to a new allocated block, then IOMAP_F_NEW
> must have been set in iomap->flags and need_zeroout will be true. If it tries to write
> to an unwritten block, need_zeroout will also be true.

But if it tries to write to an already allocated, written block,
need_zeroout is not true and it will need to zero.
> 
> If it tries to write a block in which the past-EOF part has not been zeroed, even without
> the past-EOF direct write, the data exposure is still possible, right ?

Not if we zero both sides of the dio correctly before we extend the
file size on disk.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
