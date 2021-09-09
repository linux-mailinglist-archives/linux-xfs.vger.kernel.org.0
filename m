Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D48E4058FA
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Sep 2021 16:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348374AbhIIO1O (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 9 Sep 2021 10:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348198AbhIIO1K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Sep 2021 10:27:10 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7228EC03BFEA
        for <linux-xfs@vger.kernel.org>; Thu,  9 Sep 2021 06:03:59 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id n7-20020a05600c3b8700b002f8ca941d89so1347020wms.2
        for <linux-xfs@vger.kernel.org>; Thu, 09 Sep 2021 06:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=momtchev.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=hL+XMszFpxzTIgWpy6rvhybTqrsOkgUyL+g2kQzc8MQ=;
        b=hrHWkh+TR8o0ZNMJCjwvuyWbt920dLRMOPo1uEy1dZvBrsu8w1Itvxu9nLQYChL/Zn
         Drr+8D8W/ZtGGm9oORCUql26hGWRfGCo572KCiVT67hc1uVXcB/nInZE8C+Ttsx0RnEv
         F0nsKfzsjjnbYU2AHLmp/KJCaaDjJM+z29aCk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hL+XMszFpxzTIgWpy6rvhybTqrsOkgUyL+g2kQzc8MQ=;
        b=fXTx0/IA/L4Iotdsfiype3DabszZ8cebC6umve1hI4ChKZqpbrhMnGxlltJUDFwl24
         s/6MdyZSquQyXnU3/GV+mvw5YFysPJu6RkEK3yhaqWv+9Zv/vhlxHh50kC3Rm4dNvf3p
         AO0GMwZpj78ErfiwyTyKC5ONi7FnXk2BSKnNS+0+z9Wzq7GsnHTEdN30ZSKBXHIQUQ3J
         cXMdORc5eeQ15tSpNsCj2EhFHGtmMKzwq0aUFMqsLMpSOQFHbNZszy8nsX+zlsK2XH4w
         o4LdcWYXsg1zcImUt2GP/XyTSMoHhTspgzM1GA/NbhHb++pd0As53dki1GH6Euum7HQn
         kcaw==
X-Gm-Message-State: AOAM532Hic6MEbWIdq/a10HN6lCrNRsg0zMF2paVxzeqgFiyu7n1McmA
        cpScWllx057o9hPj9gG9JjNw08Zdj0bIMQ==
X-Google-Smtp-Source: ABdhPJzsBS7iPkVmL+DiVAVFLwkr0DaQV0PkAz7xTO3i+CbJ6VZTA+cNqka2lqLhdHTisgkTmLXjag==
X-Received: by 2002:a1c:158:: with SMTP id 85mr2848421wmb.187.1631192637386;
        Thu, 09 Sep 2021 06:03:57 -0700 (PDT)
Received: from [192.168.0.132] ([156.146.63.141])
        by smtp.gmail.com with ESMTPSA id x11sm1600456wmk.21.2021.09.09.06.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 06:03:56 -0700 (PDT)
Subject: Re: heavy xfsaild I/O blocking process exit
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <b0537b9a-d2f8-9288-b631-5bf67488d930@momtchev.com>
 <20210908212733.GA2361455@dread.disaster.area>
From:   Momtchil Momtchev <momtchil@momtchev.com>
Message-ID: <737f183b-173c-3763-e986-2fe49f62e8f1@momtchev.com>
Date:   Thu, 9 Sep 2021 10:25:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210908212733.GA2361455@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


Thank you for your reply and your time. Your assumptions are correct. 
The process is killed by systemd.

I can't use perf -p on it since it has freed all of its memory.

Metadata writeback is a very good explanation that is consistent with 
everything I have seen - as the process writes lots of files and then 
deletes them at some later point.

Why does this writeback happens in the process context? Why isn't it in 
a kworker?

What really surprises me is that this happens even if the process has 
been idle for half an hour or so (it produces its files in bursts then 
idles a little bit) - this rules out speculative preallocation since it 
is freed on file close?

Does xfssyncd_centisecs influence metadata writeback? I am currently 
trying this.

Maybe I will reduce the journal size as a last resort.

Anyway, this is more of an annoyance, than a real problem.


On 08/09/2021 23:27, Dave Chinner wrote:
> On Wed, Sep 08, 2021 at 10:15:59AM +0200, Momtchil Momtchev wrote:
>> Hello,
>>
>>
>> I have a puzzling problem with XFS on Debian 10. I am running
>> number-crunching driven by Node.js - I have a process that creates about 2
>> million 1MB to 5MB files per day with an about 24h lifespan (weather
>> forecasting). The file system is obviously heavily fragmented. I have
>> absolutely no problems when running this in cruise mode, but every time I
>> decide to stop that process, especially when it has been running for a few
> What does "stop that process" mean? You kill it, or do you run a
> stop command that tells the process to do a controlled shutdown?
>
>> weeks or months, the process will become a zombie (freeing all its user
>> memory and file descriptors) and then xfsaild/kworker will continue flushing
>> the log for about 30-45 minutes before the process really quits.
> The xfsaild is not flushing the log. It's doing metadata writeback.
> If it is constantly busy, it means the log has run out of space and
> something else wants log space. That something else will block until
> the log space has been freed up by metadata writeback....
>
>> It will
>> keep its binds to network ports (which is my main problem) but the system
>> will remain responsive and usable. The I/O pattern is several seconds of
>> random reading then a second or two of sequential writing.
> That would be expected from final close on lots of dirty inodes or
> finalising unlinks on final close. But that won't stop anything else
> from functioning.
>
>> The kernel functions that are running in the zombie process context are
>> mainly xfs_btree_lookup, xfs_log_commit_cil, xfs_next_bit,
>> xfs_buf_find_isra.26
> Full profiles (e.g. from perf top -U -p <pid>) would be useful here,
> but this sounds very much like extent removal on final close. This
> will be removing either speculative preallocation beyond EOF or the
> workload has open but unlinked files and the unlink is being done at
> process exit.
>
> Either way, if the files are fragmented into millions of extents,
> this could take minutes per file being closed. But with only 1-5MB
> files, that shouldn't be occurring...
>
>> xfsaild is spending time in radix_tree_next_chunk, xfs_inode_buf_verify
> xfsaild should never be doing radix tree lookups - it only works on
> internal in-memory filessytem objects that it has direct references
> to. IOWs, I really need to see the actual profile outputs to
> determine what it is doing...
>
> xfs_inode_buf_verify() is expected if it is writing back dirty inode
> clusters. Which it will be, but at only 2 million files a day I
> wouldn't expect that to show up in profiles at all. It doesn't
> really even show up in profiles even at half a million inodes per
> _second_
>
>> kworker is in xfs_reclaim_inode, radix_tree_next_chunk
> Which kworker is that? Likely background inode reclaim, but that
> doesn't limit anything - it just indicates there are inodes
> available to be reclaimed.
>
>> This is on (standard up-to date Debian 10):
>>
>> Linux version 4.19.0-16-amd64 (debian-kernel@lists.debian.org) (gcc version
>> 8.3.0 (Debian 8.3.0-6)) #1 SMP Debian 4.19.181-1 (2021-03-19)
>>
>> xfs_progs 4.20.0-1
>>
>>
>>
>> File system is RAID-0, 2x2TB disks with LVM over md (512k chunks)
> Are these SSDs or HDDs? I'll assume HDD at this point.
>
>> meta-data=/dev/mapper/vg0-home   isize=512    agcount=32, agsize=29849728
>> blks
>>           =                       sectsz=4096  attr=2, projid32bit=1
>>           =                       crc=1        finobt=1, sparse=1, rmapbt=0
>>           =                       reflink=0
>> data     =                       bsize=4096   blocks=955191296, imaxpct=5
>>           =                       sunit=128    swidth=256 blks
>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>> log      =internal log           bsize=4096   blocks=466402, version=2
>>           =                       sectsz=4096  sunit=1 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
> Ok, so you have a 1.7GB log. If those are HDDs, then you could have
> hundreds of thousands of dirty inodes tracked in the log, and
> metadata writeback has been falling behind for days because the log
> can be filled much faster than it can be drained.
>
> Assuming 200 write IOPS, 30 minutes would be 360,000 writes, which
> pretty much matches up with having half a million dirty inodes in
> the log and the process exiting needing to run a bunch of
> transactions that need a chunk of log space to make progress and
> having to wait on inode writeback to free up log space...
>
>> MemTotal:       32800968 kB
>> MemFree:          759308 kB
>> MemAvailable:   27941208 kB
>> Buffers:           43900 kB
>> Cached:         26504332 kB
>> SwapCached:         7560 kB
>> Active:         16101380 kB
>> Inactive:       11488252 kB
>> Active(anon):     813424 kB
>> Inactive(anon):   228180 kB
>> Active(file):   15287956 kB
>> Inactive(file): 11260072 kB
> So all your memory is in the page cache.
>
>> Unevictable:           0 kB
>> Mlocked:               0 kB
>> SwapTotal:      16777212 kB
>> SwapFree:       16715524 kB
>> Dirty:              2228 kB
> And almost all the page cache is clean.
>
>> Writeback:             0 kB
>> AnonPages:       1034280 kB
>> Mapped:            89660 kB
>> Shmem:               188 kB
>> Slab:            1508868 kB
>> SReclaimable:    1097804 kB
>> SUnreclaim:       411064 kB
> And that's enough slab cache to hold half a million cached, dirty
> inodes...
>
> More information required.
>
> Cheers,
>
> Dave.

-- 
Momtchil Momtchev <momtchil@momtchev.com>

