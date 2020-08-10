Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C972403D6
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Aug 2020 11:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgHJJJH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Aug 2020 05:09:07 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:54865 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726597AbgHJJJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Aug 2020 05:09:06 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 8F4411A9E0F;
        Mon, 10 Aug 2020 19:09:01 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k53nf-00038D-EF; Mon, 10 Aug 2020 19:08:59 +1000
Date:   Mon, 10 Aug 2020 19:08:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org, axboe@kernel.dk
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
Message-ID: <20200810090859.GK2114@dread.disaster.area>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
 <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
 <20200810070807.GJ2114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810070807.GJ2114@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=NvkeETndsdyT21pYkskA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 10, 2020 at 05:08:07PM +1000, Dave Chinner wrote:
> [cc Jens]
> 
> [Jens, data corruption w/ io_uring and simple fio reproducer. see
> the bz link below.]
> 
> On Mon, Aug 10, 2020 at 01:56:05PM +1000, Dave Chinner wrote:
> > On Mon, Aug 10, 2020 at 10:09:32AM +1000, Dave Chinner wrote:
> > > On Fri, Aug 07, 2020 at 03:12:03AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> > > > --- Comment #1 from Dave Chinner (david@fromorbit.com) ---
> > > > On Thu, Aug 06, 2020 at 04:57:58AM +0000, bugzilla-daemon@bugzilla.kernel.org
> > > > wrote:
> > > > > https://bugzilla.kernel.org/show_bug.cgi?id=208827
> > > > > 
> > > > >             Bug ID: 208827
> > > > >            Summary: [fio io_uring] io_uring write data crc32c verify
> > > > >                     failed
> > > > >            Product: File System
> > > > >            Version: 2.5
> > > > >     Kernel Version: xfs-linux xfs-5.9-merge-7 + v5.8-rc4
> > > 
> > > FWIW, I can reproduce this with a vanilla 5.8 release kernel,
> > > so this isn't related to contents of the XFS dev tree at all...
> > > 
> > > In fact, this bug isn't a recent regression. AFAICT, it was
> > > introduced between in 5.4 and 5.5 - 5.4 did not reproduce, 5.5 did
> > > reproduce. More info once I've finished bisecting it....
> > 
> > f67676d160c6ee2ed82917fadfed6d29cab8237c is the first bad commit
> > commit f67676d160c6ee2ed82917fadfed6d29cab8237c
> > Author: Jens Axboe <axboe@kernel.dk>
> > Date:   Mon Dec 2 11:03:47 2019 -0700
> > 
> >     io_uring: ensure async punted read/write requests copy iovec
> 
> ....
> 
> Ok, I went back to vanilla 5.8 to continue debugging and adding
> tracepoints, and it's proving strangely difficult to reproduce now.

Which turns out to be caused by a tracepoint I inserted to try to
narrow down if this was an invalidation race. I put this in
invalidate_complete_page:


--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -257,8 +257,11 @@ int invalidate_inode_page(struct page *page)
        struct address_space *mapping = page_mapping(page);
        if (!mapping)
                return 0;
-       if (PageDirty(page) || PageWriteback(page))
+       if (PageDirty(page) || PageWriteback(page)) {
+               trace_printk("ino 0x%lx page %p, offset 0x%lx\n",
+                       mapping->host->i_ino, page, page->index * PAGE_SIZE);
                return 0;
+       }
        if (page_mapped(page))
                return 0;
        return invalidate_complete_page(mapping, page);


And that alone, without even enabling tracepoints, made the
corruption go completely away. So I suspect a page state race
condition and look at POSIX_FADV_DONTNEED, which fio is issuing
before running it's verification reads. First thing that does:

	if (!inode_write_congested(mapping->host))
		__filemap_fdatawrite_range(mapping, offset, endbyte,
					   WB_SYNC_NONE);

It starts async writeback of the dirty pages. There's 256MB of dirty
pages on these inodes, and iomap tracing indicates the entire 256MB
immediately runs through the trace_iomap_writepage() tracepoint.
i.e. every page goes Dirty -> Writeback and is submitted for async
IO.

Then the POSIX_FADV_DONTNEED code goes and runs
invalidate_mapping_pages(), which ends up try-locking each page and
then running invalidate_inode_page() on the page, which is where the
trace debug I put in on pages under writeback gets hit. So if
changing the invalidation code for pages under writeback makes the
problem go away, then stopping invalidate_mapping_pages() from
racing with page writeback should make the problem go away, too.

This does indeed make the corruption go away:

--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -109,9 +109,8 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
        case POSIX_FADV_NOREUSE:
                break;
        case POSIX_FADV_DONTNEED:
                if (!inode_write_congested(mapping->host))
-                       __filemap_fdatawrite_range(mapping, offset, endbyte,
-                                                  WB_SYNC_NONE);
+                       filemap_write_and_wait_range(mapping, offset, endbyte);
 
                /*
                 * First and last FULL page! Partial pages are deliberately

by making the invalidation wait for the pages to go fully to the
clean state before starting.

This, however, only fixes the specific symptom being tripped over
here.  To further test this, I removed this writeback from
POSIX_FADV_DONTNEED completely so I could trigger writeback via
controlled background writeback. And, as I expected, whenever
background writeback ran to write back these dirty files, the
verification failures triggered again. It is quite reliable.

So it looks like there is some kind of writeback completion vs page
invalidation race condition occurring, but more work is needed to
isolate it further. I don't know what part the async read plays in
the corruption yet, because I don't know how we are getting pages in
the cache where page->index != the file offset stamped in the data.
That smells of leaking PageUptodate flags...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
