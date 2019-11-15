Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E72FD892
	for <lists+linux-xfs@lfdr.de>; Fri, 15 Nov 2019 10:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfKOJQa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 15 Nov 2019 04:16:30 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6678 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726567AbfKOJQa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Nov 2019 04:16:30 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EA4E9542940C91A49CA8;
        Fri, 15 Nov 2019 17:16:27 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Fri, 15 Nov 2019
 17:16:21 +0800
Subject: Re: [PATCH] xfs: optimise xfs_mod_icount/ifree when delta < 0
To:     Dave Chinner <david@fromorbit.com>
References: <1572866980-13001-1-git-send-email-zhangshaokun@hisilicon.com>
 <20191104204909.GB4614@dread.disaster.area>
 <dc7456d6-616d-78c5-0ac6-c5ffaf721e41@hisilicon.com>
 <20191105040325.GC4614@dread.disaster.area>
 <675693c2-8600-1cbd-ce50-5696c45c6cd9@hisilicon.com>
 <20191106212041.GF4614@dread.disaster.area>
 <d627883a-850c-1ec4-e057-cf9e9b47c50e@hisilicon.com>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yang Guo <guoyang2@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Christoph Hellwig" <hch@infradead.org>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <724125af-dfff-c0e0-93f2-2da7a2fe19cb@hisilicon.com>
Date:   Fri, 15 Nov 2019 17:16:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <d627883a-850c-1ec4-e057-cf9e9b47c50e@hisilicon.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

With configuration "-d agcount=32", it also enters slow path frequently
when there are 128 cpu cores, any thoughts about this issue?
Can we remove debug check entirely as Christoph's suggestion?

Thanks,
Shaokun

On 2019/11/8 13:58, Shaokun Zhang wrote:
> Hi Dave,
> 
> On 2019/11/7 5:20, Dave Chinner wrote:
>> On Wed, Nov 06, 2019 at 02:00:58PM +0800, Shaokun Zhang wrote:
>>> Hi Dave,
>>>
>>> On 2019/11/5 12:03, Dave Chinner wrote:
>>>> On Tue, Nov 05, 2019 at 11:26:32AM +0800, Shaokun Zhang wrote:
>>>>> Hi Dave,
>>>>>
>>>>> On 2019/11/5 4:49, Dave Chinner wrote:
>>>>>> On Mon, Nov 04, 2019 at 07:29:40PM +0800, Shaokun Zhang wrote:
>>>>>>> From: Yang Guo <guoyang2@huawei.com>
>>>>>>>
>>>>>>> percpu_counter_compare will be called by xfs_mod_icount/ifree to check
>>>>>>> whether the counter less than 0 and it is a expensive function.
>>>>>>> let's check it only when delta < 0, it will be good for xfs's performance.
>>>>>>
>>>>>> Hmmm. I don't recall this as being expensive.
>>>>>>
>>>>>
>>>>> Sorry about the misunderstanding information in commit message.
>>>>>
>>>>>> How did you find this? Can you please always document how you found
>>>>>
>>>>> If user creates million of files and the delete them, We found that the
>>>>> __percpu_counter_compare costed 5.78% CPU usage, you are right that itself
>>>>> is not expensive, but it calls __percpu_counter_sum which will use
>>>>> spin_lock and read other cpu's count. perf record -g is used to profile it:
>>>>>
>>>>> - 5.88%     0.02%  rm  [kernel.vmlinux]  [k] xfs_mod_ifree
>>>>>    - 5.86% xfs_mod_ifree
>>>>>       - 5.78% __percpu_counter_compare
>>>>>            5.61% __percpu_counter_sum
>>>>
>>>> Interesting. Your workload is hitting the slow path, which I most
>>>> certainly do no see when creating lots of files. What's your
>>>> workload?
>>>>
>>>
>>> The hardware has 128 cpu cores, and the xfs filesystem format config is default,
>>> while the test is a single thread, as follow:
>>> ./mdtest -I 10  -z 6 -b 8 -d /mnt/ -t -c 2
>>
>> What version and where do I get it?
> 
> You can get the mdtest from github: https://github.com/LLNL/mdtest.
> 
>>
>> Hmmm - isn't mdtest a MPI benchmark intended for highly concurrent
>> metadata workload testing? How representative is it of your actual
>> production workload? Is that single threaded?
>>
> 
> We just use mdtest to test the performance of a file system, it can't representative
> the actual workload and it's single threaded. But we also find that it goes to slow
> path when we remove a dir with many files. The cmd is below:
> rm -rf xxx.
> 
>>> xfs info:
>>> meta-data=/dev/bcache2           isize=512    agcount=4, agsize=244188661 blks
>>
>> only 4 AGs, which explains the lack of free inodes - there isn't
>> enough concurrency in the filesystem layout to push the free inode
>> count in all AGs beyond the batchsize * num_online_cpus().
>>
>> i.e. single threaded workloads typically drain the free inode count
>> all the way down to zero before new inodes are allocated. Workloads
>> that are highly concurrent allocate from lots of AGs at once,
>> leaving free inodes in every AG that is not current being actively
>> allocated out of.
>>
>> As a test, can you remake that test filesystem with "-d agcount=32"
>> and see if the overhead you are seeing disappears?
>>
> 
> We try to remake the filesystem with "-d agcount=32" and it also enters slow path
> mostly. Print the batch * num_online_cpus() and find that it's 32768.
> Because percpu_counter_batch was initialized to 256 when there are 128 cpu cores.
> Then we change the agcount=1024, and it also goes to slow path frequently because
> mostly there are no 32768 free inodes.
> 
>>>> files and you have lots of idle CPU and hence the inode allocation
>>>> is not clearing the fast path batch threshold on the ifree counter.
>>>> And because you have lots of CPUs, the cost of a sum is very
>>>> expensive compared to running single threaded creates. That's my
>>>> current hypothesis based what I see on my workloads that
>>>> xfs_mod_ifree overhead goes down as concurrency goes up....
>>>>
>>>
>>> Agree, we add some debug info in xfs_mod_ifree and found most times
>>> m_ifree.count < batch * num_online_cpus(),  because we have 128 online
>>> cpus and m_ifree.count around 999.
>>
>> Ok, the threshold is 32 * 128 = ~4000 to get out of the slow
>> path. 32 AGs may well push the count over this threshold, so it's
>> definitely worth trying....
>>
> 
> Yes, we tried it and found that threshold was 32768, because percpu_counter_batch
> was initialized to 2 * num_online_cpus().
> 
>>>> FWIW, the profiles I took came from running this on 16 and 32p
>>>> machines:
>>>>
>>>> --
>>>> dirs=""
>>>> for i in `seq 1 $THREADS`; do
>>>>         dirs="$dirs -d /mnt/scratch/$i"
>>>> done
>>>>
>>>> cycles=$((512 / $THREADS))
>>>>
>>>> time ./fs_mark $XATTR -D 10000 -S0 -n $NFILES -s 0 -L $cycles $dirs
>>>> --
>>>>
>>>> With THREADS=16 or 32 and NFILES=100000 on a big sparse filesystem
>>>> image:
>>>>
>>>> meta-data=/dev/vdc               isize=512    agcount=500, agsize=268435455 blks
>>>>          =                       sectsz=512   attr=2, projid32bit=1
>>>>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>>>>          =                       reflink=1
>>>> data     =                       bsize=4096   blocks=134217727500, imaxpct=1
>>>>          =                       sunit=0      swidth=0 blks
>>>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>>>> log      =internal log           bsize=4096   blocks=521728, version=2
>>>>          =                       sectsz=512   sunit=0 blks, lazy-count=1
>>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>>>
>>>> That's allocating enough inodes to keep the free inode counter
>>>> entirely out of the slow path...
>>>
>>> percpu_counter_read that reads the count will cause cache synchronization
>>> cost if other cpu changes the count, Maybe it's better not to call
>>> percpu_counter_compare if possible.
>>
>> Depends.  Sometimes we trade off ultimate single threaded
>> performance and efficiency for substantially better scalability.
>> i.e. if we lose 5% on single threaded performance but gain 10x on
>> concurrent workloads, then that is a good tradeoff to make.
>>
> 
> Agree, I mean that when delta > 0, there is no need to call percpu_counter_compare in
> xfs_mod_ifree/icount.
> 
> Thanks,
> Shaokun
> 
>> Cheers,
>>
>> Dave.
>>

