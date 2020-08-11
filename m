Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1BB2414E4
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Aug 2020 04:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgHKCUB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Aug 2020 22:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgHKCUA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Aug 2020 22:20:00 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47427C06174A
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2020 19:20:00 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f10so6067026plj.8
        for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2020 19:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jrFfesT/cYaceoAfvk/kxzpcTRhDYri6Aqfwc0qg1jE=;
        b=L31HnGDFMzEOfQtt75b5LNenq+sbq5UQ+AjVAcguxNjzkyBQVM8R8+TXV6gbxVzRG7
         OlafRht73XbjMjGx5eTk2lrRsdm7hEuADGSHuD+CLXygVQo2neb2l/E+YMnoNPcm4DL+
         fjndJt8F46VOhGX3MV/L+exa8w4ZsMr09SOtwc353HQgAQ/vxDzJB/BuX+u34YFXFhnp
         GU6fDlpzN0UOUWrP/00L83u0lhqkmN95kbJf8QjLOccKGFq2tdqyIUIMzyu3hSL1Tkpd
         ujVakJKjUKLWHfCLBEckvDSd5KDL6NEApQxXjIzqMTLEmpZZqaW1f5NmXaoXvBVD9c2D
         yrKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jrFfesT/cYaceoAfvk/kxzpcTRhDYri6Aqfwc0qg1jE=;
        b=Y6oQyo3HGf3gH2ZZhEpAiXWkiSnSFjB3pY1LwdlODH1K7Hu5N2bBfRmjAbUqrQ0h+5
         qWHCK9EEdbuLataGAdpIgVWdDomdiYprmJqCE1xe6Y+bZrh7YXvV0hUsh5kTH+nVP597
         v6INc1DhCRPmDJDxE5UOrcZy8nCD37aF2EKb/WaSbNE1elsL0k2Vnog3Pu967IHys10D
         U8O6G4tEEU/DxfA+UXY9XAPf9xeBdOUDWw8Am3bSdbbcpVQWGqrWqsi5iYIwCwFiq8+X
         PHrRFU2o05vasrd30qZzGNY34gLsTYTuoUh8p74A74Kb6tSxVJ4JvFvB3t0D2Bhywpg0
         bDnQ==
X-Gm-Message-State: AOAM532rBoboznPGn1s4i0fGsPh+0vaXqBxjVpz8D8hsThZ0NpQ2M6Q4
        8H9aEy03Xje5nx4wLJ+GXSkcUryL2h0=
X-Google-Smtp-Source: ABdhPJwg7SzGVS7JnMCuy9qKK0aS+PWyv54I31kCR5heaWHFnyzG02TcnpQa5LQbbWF5Btl80K8BWA==
X-Received: by 2002:a17:90b:1b45:: with SMTP id nv5mr2347613pjb.35.1597112399272;
        Mon, 10 Aug 2020 19:19:59 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q12sm25643601pfg.135.2020.08.10.19.19.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 19:19:58 -0700 (PDT)
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
To:     Dave Chinner <david@fromorbit.com>,
        bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org
References: <bug-208827-201763@https.bugzilla.kernel.org/>
 <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
 <20200810070807.GJ2114@dread.disaster.area>
 <20200810090859.GK2114@dread.disaster.area>
 <20200811020052.GM2114@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d7c9ea39-136d-bc1b-7282-097a784e336b@kernel.dk>
Date:   Mon, 10 Aug 2020 20:19:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200811020052.GM2114@dread.disaster.area>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/10/20 8:00 PM, Dave Chinner wrote:
> On Mon, Aug 10, 2020 at 07:08:59PM +1000, Dave Chinner wrote:
>> On Mon, Aug 10, 2020 at 05:08:07PM +1000, Dave Chinner wrote:
>>> [cc Jens]
>>>
>>> [Jens, data corruption w/ io_uring and simple fio reproducer. see
>>> the bz link below.]
> 
> Looks like a io_uring/fio bugs at this point, Jens. All your go fast
> bits turns the buffered read into a short read, and neither fio nor
> io_uring async buffered read path handle short reads. Details below.

It's a fio issue. The io_uring engine uses a different path for short
IO completions, and that's being ignored by the backend... Hence the
IO just gets completed and not retried for this case, and that'll then
trigger verification as if it did complete. I'm fixing it up.

> Also, the block_rq_* trace points appear to emit corrupt trace
> records that crash trace-cmd. That probably needs to be looked into
> as well:
> 
> $ sudo trace-cmd record -e xfs_file\* -e iomap\* -e block_bio\* -e block_rq_complete -e printk fio tests/io_uring_corruption.fio
> .....
> $ trace-cmd report > s.t
> ug! no event found for type 4228
> ug! no event found for type 32
> ug! negative record size -4
> ug! no event found for type 16722
> ug! no event found for type 0
> ug! no event found for type 4228
> ug! no event found for type 32
> ug! negative record size -4
> ug! no event found for type 16722
> ug! no event found for type 4228
> ug! no event found for type 4230
> ug! no event found for type 32
> ug! no event found for type 0
> ug! no event found for type 4230
> ug! no event found for type 32
> ug! no event found for type 0
> ug! no event found for type 32
> ug! negative record size -4
> Segmentation fault
> $

No idea what that is, I regularly use "normal" blktrace and it works just
fine for me.

>>> On Mon, Aug 10, 2020 at 01:56:05PM +1000, Dave Chinner wrote:
>>>> On Mon, Aug 10, 2020 at 10:09:32AM +1000, Dave Chinner wrote:
>>>>> On Fri, Aug 07, 2020 at 03:12:03AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
>>>>>> --- Comment #1 from Dave Chinner (david@fromorbit.com) ---
>>>>>> On Thu, Aug 06, 2020 at 04:57:58AM +0000, bugzilla-daemon@bugzilla.kernel.org
>>>>>> wrote:
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=208827
>>>>>>>
>>>>>>>             Bug ID: 208827
>>>>>>>            Summary: [fio io_uring] io_uring write data crc32c verify
>>>>>>>                     failed
>>>>>>>            Product: File System
>>>>>>>            Version: 2.5
>>>>>>>     Kernel Version: xfs-linux xfs-5.9-merge-7 + v5.8-rc4
>>>>>
>>>>> FWIW, I can reproduce this with a vanilla 5.8 release kernel,
>>>>> so this isn't related to contents of the XFS dev tree at all...
>>>>>
>>>>> In fact, this bug isn't a recent regression. AFAICT, it was
>>>>> introduced between in 5.4 and 5.5 - 5.4 did not reproduce, 5.5 did
>>>>> reproduce. More info once I've finished bisecting it....
>>>>
>>>> f67676d160c6ee2ed82917fadfed6d29cab8237c is the first bad commit
>>>> commit f67676d160c6ee2ed82917fadfed6d29cab8237c
>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>> Date:   Mon Dec 2 11:03:47 2019 -0700
>>>>
>>>>     io_uring: ensure async punted read/write requests copy iovec
>>>
>>> ....
>>>
>>> Ok, I went back to vanilla 5.8 to continue debugging and adding
>>> tracepoints, and it's proving strangely difficult to reproduce now.
>>
>> Which turns out to be caused by a tracepoint I inserted to try to
>> narrow down if this was an invalidation race. I put this in
>> invalidate_complete_page:
>>
>>
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -257,8 +257,11 @@ int invalidate_inode_page(struct page *page)
>>         struct address_space *mapping = page_mapping(page);
>>         if (!mapping)
>>                 return 0;
>> -       if (PageDirty(page) || PageWriteback(page))
>> +       if (PageDirty(page) || PageWriteback(page)) {
>> +               trace_printk("ino 0x%lx page %p, offset 0x%lx\n",
>> +                       mapping->host->i_ino, page, page->index * PAGE_SIZE);
>>                 return 0;
>> +       }
>>         if (page_mapped(page))
>>                 return 0;
>>         return invalidate_complete_page(mapping, page);
> 
> So I updated to the current 5.9 whcih has all the new async buffered
> read stuff in it to see if that fixed the problem, but it didn't.
> Instead, it actually made this problem occur almost instantenously.
> 
> I could put the above trace code back in and it didn't purturb the
> situation, either. Neither did writeback, which I was now able to
> confirm didn't actually impact on this problem at all.
> 
> The problem is, instead, reads racing with readahead completion.
> There is no page cache corruption at all, just fio is reusing
> buffers that contain stale data from previous read IO and hence any
> part of the buffer that doesn't get updated by the read IO ends up
> being detected as "corrupt" because they already contain stale data.
> 
> The problem is clear from this sequence trace:
> 
>      io_uring-sq-4518  [012]    52.806976: xfs_file_buffered_read: dev 253:32 ino 0x86 size 0x10000000 offset 0x6f40000 count 0x10000
>      io_uring-sq-4518  [012]    52.806987: iomap_readahead:      dev 253:32 ino 0x86 nr_pages 16
>      io_uring-sq-4518  [012]    52.806987: iomap_apply:          dev 253:32 ino 0x86 pos 116654080 length 65536 flags  (0x0) ops xfs_read_iomap_ops caller iomap_readahead actor iomap_readahead_actor
>      io_uring-sq-4518  [012]    52.806988: iomap_apply_dstmap:   dev 253:32 ino 0x86 bdev 253:32 addr 922058752 offset 116654080 length 65536 type MAPPED flags 
>      io_uring-sq-4518  [012]    52.806990: block_bio_queue:      253,32 RA 1800896 + 128 [io_uring-sq]
> ....
>      io_uring-sq-4518  [012]    52.806992: xfs_file_buffered_read: dev 253:32 ino 0x86 size 0x10000000 offset 0x6f40000 count 0xfffffffffffffff5
>      io_uring-sq-4518  [012]    52.806993: xfs_file_buffered_read: dev 253:32 ino 0x86 size 0x10000000 offset 0x6f40000 count 0x10000
>      io_uring-sq-4518  [012]    52.806994: xfs_file_buffered_read: dev 253:32 ino 0x86 size 0x10000000 offset 0x6f40000 count 0xfffffffffffffdef
>      io_uring-sq-4518  [012]    52.806995: xfs_file_buffered_read: dev 253:32 ino 0x86 size 0x10000000 offset 0x6bf0000 count 0x10000
> ....
>              fio-4515  [013]    52.807855: block_rq_complete:    253,32 RA () 1800896 + 128 [0]
>      io_uring-sq-4518  [012]    52.807863: xfs_file_buffered_read: dev 253:32 ino 0x86 size 0x10000000 offset 0x6f40000 count 0x10000
>      io_uring-sq-4518  [012]    52.807866: xfs_file_buffered_read: dev 253:32 ino 0x86 size 0x10000000 offset 0x6f41000 count 0x1000
> ....
>              fio-4515  [013]    52.807871: block_rq_complete:    253,32 RA () 1752640 + 128 [0]
>              fio-4515  [013]    52.807876: block_rq_complete:    253,32 RA () 1675200 + 128 [0]
>              fio-4515  [013]    52.807880: block_rq_complete:    253,32 RA () 1652672 + 128 [0]
> 
> What we see is -3- calls to do the buffered read. The first call
> triggers readahead and we can see iomap map the file offset and
> issue the bio. This is IOCB_NOWAIT context, so this is actually
> broken as we can block for a long time in this path (e.g. on
> inode locks).
> 
> Once the IO is issued, we see a second xfs_file_buffered_read trace
> with the return value in the count - that's -EAGAIN because
> IOCB_NOWAIT is set and now we are going to block waiting for IO.
> 
> Immediately after this, the io_uring code issues the buffered read
> again, only this time with IOCB_WAITQ|IOCB_NOWAIT set and it hits
> the "page not up to date" path. This then hits
> __wait_on_page_locked_async() which sets the PageWaiter bit and
> returns -EIOCBQUEUED to tell the caller that it has been queued.
> 
> About a millisecond later, the readahead IO completes, and the block
> layer logs it. This ends up calling iomap_read_end_io() which walks
> each page(bvec) in the bio, marks them uptodate and unlocks them.
> The first page unlock sees the PageWaiter bit, which then does a
> 
> 	wake_up_page_bit(page, PG_locked);
> 
> because the PageWaiter bit is set. We see the same io_uring worker
> thread then immmediately re-issue the buffered read and it does it
> with IOCB_WAITQ|IOCB_NOWAIT context. This gets the first page, then
> finds the second page not up to date or has to block trying to lock
> it. It aborts the read at that point, and because we've already read
> a page it returns 4096 bytes read.
> 
> I left the post-buffered read IO completions that were being run by
> the block layer to show that the buffered read was issued and
> completed while the block layer was still processing the readahead
> bio completion.
> 
> At this point (a positive byte count being returned) the io_uring
> layer considers the IO done and returns the result to the userspace
> app. Fio then completely fails to check for a short read despite
> being in "verify" mode and instead yells about corruption due to
> stale data that it had left in the buffer that it passed the
> kernel....
> 
> IOWs, there does not appear to be a filesystem or page cache issue
> here at all - it's just an unhandled short read.

Right, the page cache is consistent, nothing wrong on that side. This is
purely a fio issue with messing up the short read.

It'd be nice to do better on the short reads, maybe wait for the entire
range to be ready instead of just triggering on the first page.
Something to look into.

> Jens, if strace worked on io_uring, I wouldn't have wasted 2 and
> half days tracking this down. It would have taken 5 minutes with
> strace and it would have been totally obvious. I'd suggest this
> needs addressing as a matter of priority over everything else for
> io_uring....

Sorry, you should have pinged me earlier. In lieu of strace, we could
expand the io_uring issue event to include a bigger dump of exactly what
is in the command being issued instead of just the opcode. There's
already info in there enabling someone to tie the complete and submit
events together, so it could have been deduced that we never retried a
short IO on the application side. But it should not be that hard to dig
out, I agree we need to make it easier to debug these kinds of things.
Definitely on the list!

-- 
Jens Axboe

