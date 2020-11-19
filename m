Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8A32B8C65
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Nov 2020 08:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgKSHbu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 19 Nov 2020 02:31:50 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:53635 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726269AbgKSHbu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Nov 2020 02:31:50 -0500
Received: from theinternet.molgen.mpg.de (theinternet.molgen.mpg.de [141.14.31.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 8CBE82064785A;
        Thu, 19 Nov 2020 08:31:46 +0100 (CET)
Subject: Re: xfs_reclaim_inodes_ag taking several seconds
From:   Donald Buczek <buczek@molgen.mpg.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     darrick.wong@oracle.com, linux-xfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <8284912e-b99a-31af-1901-a38ea03b8648@molgen.mpg.de>
 <20200731223255.GG2005@dread.disaster.area>
 <d515fa07-5198-fc3c-24ac-d35aa4e08668@molgen.mpg.de>
 <20200803221111.GC2114@dread.disaster.area>
 <590739ea-1d92-4aa9-3b49-3717d512ac88@molgen.mpg.de>
Message-ID: <c3dd6768-c02b-2cb4-ed06-83478da01cc9@molgen.mpg.de>
Date:   Thu, 19 Nov 2020 08:31:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <590739ea-1d92-4aa9-3b49-3717d512ac88@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/12/20 8:49 AM, Donald Buczek wrote:
> On 8/4/20 12:11 AM, Dave Chinner wrote:
>> On Sat, Aug 01, 2020 at 12:25:40PM +0200, Donald Buczek wrote:
>>> On 01.08.20 00:32, Dave Chinner wrote:
>>>> On Fri, Jul 31, 2020 at 01:27:31PM +0200, Donald Buczek wrote:
>>>>> Dear Linux people,
>>>>>
>>>>> we have a backup server with two xfs filesystems on 101.9TB md-raid6 devices (16 * 7.3 T disks) each, Current Linux version is 5.4.54.
>>>> .....
>>>>> root:done:/home/buczek/linux_problems/shrinker_semaphore/# cat /proc/meminfo
>>>>> MemTotal:       263572332 kB
>>>>
>>>> 256GB of RAM.
>>>>
>>>>> MemFree:         2872368 kB
>>>>> MemAvailable:   204193824 kB
>>>>
>>>> 200GB "available"
>>>>
>>>>> Buffers:            2568 kB
>>>>> Cached:         164931356 kB
>>>>
>>>> 160GB in page cache
>>>>
>>>>> KReclaimable:   40079660 kB
>>>>> Slab:           49988268 kB
>>>>> SReclaimable:   40079660 kB
>>>>
>>>> 40GB in reclaimable slab objects.
>>>>
>>>> IOWs, you have no free memory in the machine and so allocation
>>>> will frequently be dipping into memory reclaim to free up page cache
>>>> and slab caches to make memory available.
>>>>
>>>>> xfs_inode         30978282 31196832    960    4    1 : tunables   54   27    8 : slabdata 7799208 7799208    434
>>>>
>>>> Yes, 30 million cached inodes.
>>>>
>>>>> bio_integrity_payload 29644966 30203481    192   21    1 : tunables  120   60    8 : slabdata 1438261 1438261    480
>>>>
>>>> Either there is a memory leak in this slab, or it is shared with
>>>> something like the xfs_ili slab, which would indicate that most
>>>> of the cached inodes have been dirtied in memory at some point in
>>>> time.
>>>
>>> I think you are right here:
>>>
>>>      crash> p $s->name
>>>      $84 = 0xffffffff82259401 "bio_integrity_payload"
>>>      crash> p $s->refcount
>>>      $88 = 8
>>>      crash> p $s
>>>      $92 = (struct kmem_cache *) 0xffff88bff92d2bc0
>>>      crash> p sizeof(xfs_inode_log_item_t)
>>>      $93 = 192
>>>      crash> p $s->object_size
>>>      $94 = 192
>>>
>>> So if I understand you correctly, this is expected behavior with
>>> this kind of load and conceptual changes are already scheduled for
>>> kernel 5.9. I don't understand most of it, but isn't it true that
>>> with that planned changes the impact might be better limited to
>>> the filesystem, so that the performance of other areas of the
>>> system might improve?
>>
>> What the changes in 5.9 will do is remove the direct memory reclaim
>> latency that comes from waiting on IO in the shrinker. Hence you
>> will no longer see this problem from applications doing memory
>> allocation. i.e. they'll get some other memory reclaimed without
>> blocking (e.g. page cache or clean inodes) and so the specific
>> symptom of having large numbers of dirty inodes in memory that you
>> are seeing will go away.
>>
>> Which means that dirty inodes in memory will continue to build up
>> until the next constraint is hit, and then it will go back to having
>> unpredictable large latencies while waiting for inodes to be written
>> back to free up whatever resource the filesystem has run out of.
>>
>> That resource will, most likely, be filesystem journal space. Every
>> fs modification needs to reserve sufficient journal to complete
>> before the modification starts. Hence if the journal fills, any
>> modification to the fs will block waiting on dirty inode writeback
>> to release space in the journal....
>>
>> You might be lucky and the backup process is slow enough that the
>> disk subsystem can keep up with the rate of ingest of new data and
>> so you never hit this limitation. However, the reported state of the
>> machine and the amount of RAM it has for caching says to me that the
>> underlying problem is that ingest is far faster than the filesystem
>> and disk subsystem can sink...
>>
>> A solution to this problem might be to spread out the backups being
>> done over a wider timeframe, such that there isn't a sustained heavy
>> load at 3am in the morning when every machine is scheduled to be
>> backed up at the same time...
> 
> It is already running round the clock. We have two of these servers, doing daily backups for 1374 file spaces (= directory trees below 1 TB) on 392 clients. The servers are doing daily mirrors of these file spaces, creating hard links for existing files and keeping these daily trees for 4 month. The schedule is free from fixed wall clock times. A backup is due when the last iteration is older than 24 hours, and will be done as time, threads and some locking constrains allow. Under normal circumstances the servers keep up, but are nearly continuously busy. The excess capacity is spread all over the day (sometimes there is no work to do for some minutes).
> 
> I monitor, how long a local mount takes (usually 0.03-0.04 seconds) and the worst time seen so far is over 16 minutes! Because we rely on autofs mounts for logins and some other things, the system kind of appears to be dead during that time.
> 
> I've limited the inode caches by running the backup jobs in memory control groups, but, as expected, this didn't really bring down the delays. I've also added a cond_resched() to mm/vmscan.c:shrink_slab_memcg(), which seems to be missing after the up_read(), but this didn't help either.
> 
>  From a user perspective it is hard to understand, that a saturated block device delays unrelated functions that much. Functions, which don't have any business with that block device.
> 
> Maybe our usage of the filesystem is just bad design and we should move the housekeeping and the metadata of the backup application from the filesystem into a database. But our applications is just an unprivileged user on a multiuser system, so it would be nice if the impact could be limited.
> 
> Is it acceptable that a shrinker blocks for minutes? If not, this would be a problem specific to xfs, which might already be addressed by the scheduled changes. Can it be tamed by other means somehow? Would it make sense to limit the xfs log size? You've mentioned the full size journal log in a previous mail. I could also split the big filesystems into multiple smaller filesystems. But I guess, this is not the idea of xfs, which internally kind of consists of multiple filesystems anyway? Pick another filesystem?
> 
> On the other hand, if it is acceptable for a shrinker to block for minutes, I wonder if the registration/deregistration of shrinkers could be made lockfree in regard to the current shrinker activity. It would need to be considered, that maybe subsystems currently reply on the implied serialization.
> 
> Best
>    Donald
> 
>>> I'd love to test that with our load, but I
>>> don't want to risk our backup data and it would be difficult to
>>> produce the same load on a toy system. The patch set is not yet
>>> ready to be tested on production data, is it?
>>
>> Not unless you like testing -rc1 kernels in production :)

I just want to give a short update:

When 5.9 was released, I was eager to test that, but this has been delayed by the fact, that the two Adaptec 1100-8e HBAs of the system failed to operate with Linux  5.9 [1].

But by now we've got a (unreleased) version 2.1.8-005 smartpqi driver from Adaptec, which is working with Linux 5.9.8 on out system.

 From this test I can acknowledge, that the problem reported in this thread is in fact no longer visible in Linux 5.9, as you expeced. :-)

So far, no other negative effects of the high file system load have been observed.

Best

   Donald

[1] https://lore.kernel.org/linux-scsi/7d22510c-da28-ea2d-a1b1-fc9e126879d1@molgen.mpg.de/

>>
>> Cheers,
>>
>> Dave.
>>
> 


-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
