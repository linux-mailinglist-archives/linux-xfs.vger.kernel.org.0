Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B685F5ABCA8
	for <lists+linux-xfs@lfdr.de>; Sat,  3 Sep 2022 05:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiICDvW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Sep 2022 23:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiICDvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Sep 2022 23:51:21 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82D4CE9920;
        Fri,  2 Sep 2022 20:51:16 -0700 (PDT)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MKLPc4dMnzrS2y;
        Sat,  3 Sep 2022 11:49:24 +0800 (CST)
Received: from [10.174.177.238] (10.174.177.238) by
 kwepemi500019.china.huawei.com (7.221.188.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 3 Sep 2022 11:51:14 +0800
Message-ID: <e51811d6-be83-47ee-c4bb-7dc18f97df97@huawei.com>
Date:   Sat, 3 Sep 2022 11:51:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.2
Subject: Re: [PATCH fstests] xfs/554: xfs add illegal bestfree array size
 inject for leaf dir
To:     Zorro Lang <zlang@redhat.com>
CC:     <fstests@vger.kernel.org>, <djwong@kernel.org>,
        <dchinner@redhat.com>, <linux-xfs@vger.kernel.org>,
        <yi.zhang@huawei.com>, <houtao1@huawei.com>,
        <zhengbin13@huawei.com>, <jack.qiu@huawei.com>
References: <20220902094046.3891252-1-guoxuenan@huawei.com>
 <20220903013921.wbmwkf6rs2iknqn6@zlang-mailbox>
From:   Guo Xuenan <guoxuenan@huawei.com>
In-Reply-To: <20220903013921.wbmwkf6rs2iknqn6@zlang-mailbox>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.238]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500019.china.huawei.com (7.221.188.117)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Zorro：

On 2022/9/3 9:39, Zorro Lang wrote:
> On Fri, Sep 02, 2022 at 05:40:46PM +0800, Guo Xuenan wrote:
>> Test leaf dir allocting new block when bestfree array size
>> less than data blocks count, which may lead to UAF.
>>
>> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
>> ---
>>   tests/xfs/554     | 48 +++++++++++++++++++++++++++++++++++++++++++++++
>>   tests/xfs/554.out |  6 ++++++
>>   2 files changed, 54 insertions(+)
>>   create mode 100755 tests/xfs/554
>>   create mode 100644 tests/xfs/554.out
>>
>> diff --git a/tests/xfs/554 b/tests/xfs/554
>> new file mode 100755
>> index 00000000..fcf45731
>> --- /dev/null
>> +++ b/tests/xfs/554
>> @@ -0,0 +1,48 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2022 Huawei Limited.  All Rights Reserved.
>> +#
>> +# FS QA Test No. 554
>> +#
>> +# Test leaf dir bestfree array size match with dir disk size
> Is it for a known bug? known commit id?
The bug is being solved and waitting to be reviewed here[v1/v2].
[v1] 
https://lore.kernel.org/all/20220902094046.3891252-1-guoxuenan@huawei.com/
[v2] 
https://lore.kernel.org/all/20220831121639.3060527-1-guoxuenan@huawei.com/
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick
>> +
>> +# Import common functions.
>> +. ./common/populate
>> +
>> +# real QA test starts here
>> +_supported_fs xfs
>> +_require_scratch
> Do you need V5 xfs? Or v4 is fine?
> _require_scratch_xfs_crc ??

>> +_require_check_dmesg
>> +
>> +echo "Format and mount"
>> +_scratch_mkfs > $seqres.full 2>&1
>> +_scratch_mount  >> $seqres.full 2>&1
>> +
>> +echo "Create and check leaf dir"
>> +blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
>> +dblksz="$($XFS_INFO_PROG "${SCRATCH_DEV}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> Why do you need these two kinds of block size for xfs? And you sometimes
> use the former, sometimes use the later? If you'd like to get the xfs data
> block size, you can:
>
>    _scratch_mkfs | _filter_mkfs >>$seqres.full 2>$tmp.mkfs
>    . $tmp.mkfs
>
> Then "dbsize" is what you want.
>
>> +leaf_lblk="$((32 * 1073741824 / blksz))"
>> +node_lblk="$((64 * 1073741824 / blksz))"
> I didn't see the "node_lblk" is used in this case, looks like you don't want to
> get directory node blocks in this case.
It's really needed here, must define leaf_lblk and node_lblk before 
calling __populate_check_xfs_dir
or an waring will be printed by the function.
>> +__populate_create_dir "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF" "$((dblksz / 12))"
>> +leaf_dir="$(__populate_find_inode "${SCRATCH_MNT}/S_IFDIR.FMT_LEAF")"
>> +_scratch_unmount
>> +__populate_check_xfs_dir "${leaf_dir}" "leaf"
>> +
>> +echo "Inject bad bestfress array size"
>> +_scratch_xfs_db -x -c "inode ${leaf_dir}" -c "dblock 8388608" -c "write ltail.bestcount 0"
> As you tried to detect xfs block size above, so it might not 4k block size, so
> 8388608 is not fixed.
>
> According to the kernel definition:
>    #define XFS_DIR2_DATA_ALIGN_LOG 3
>    #define XFS_DIR2_SPACE_SIZE     (1ULL << (32 + XFS_DIR2_DATA_ALIGN_LOG))
>    #define XFS_DIR2_LEAF_SPACE     1
>    #define XFS_DIR2_LEAF_OFFSET    (XFS_DIR2_LEAF_SPACE * XFS_DIR2_SPACE_SIZE)
>
> The XFS_DIR2_LEAF_OFFSET = 1 * (1 << (32 + 3)) = 1<<35 = 34359738368 = 32GB, so
> the fixed logical offset of leaf extent is 34359738368 bytes, then the offset
> block number should be "34359738368 / dbsize". 8388608 is only for 4k block
> size.
Sorry, you are totally right! it should be "dblock ${leaf_lblk}"
>> +
>> +echo "Test add entry to dir"
>> +_scratch_mount
>> +touch ${SCRATCH_MNT}/S_IFDIR.FMT_LEAF/{1..100}.txt > /dev/null 2>&1
>> +_scratch_unmount 2>&1
>> +_repair_scratch_fs >> $seqres.full 2>&1
> Can you explain more about this testing steps? The xfs has been corrupted, then
> we expect is can be mounted. And create 100 new files on that corrupted dir,
> do you expect the 100 files can be created successfully? Or what ever, even
> nothing be created?
since we have create an leaf dir,and set bestfree count to 0; then, need 
to touch some files to
trigger the problem, the action will be failed as expected.
> What's the xfs_repair expect? Fix all curruption and left a clean xfs?
Adding repair is really not necessary, only toavoid 
_check_xfs_filesystem warning
" _check_xfs_filesystem: filesystem on /dev/sdb is inconsistent (r)"
>> +
>> +# check demsg error
>> +_check_dmesg
> Which above step will trigger a dmesg you want to check? What kind of dmesg do
dmesg eg:
[   80.543884] XFS (sdb): Internal error xfs_dir2_data_use_free at line 
1200 of file fs/xfs/libxfs/xfs_dir2_data.c.  Caller 
xfs_dir2_data_use_free+0xb3/0xeb0
[   80.545141] CPU: 2 PID: 2978 Comm: touch Not tainted 6.0.0-rc3+ #115
[   80.545715] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.13.0-1ubuntu1.1 04/01/2014
[   80.546546] Call Trace:
[   80.546785]  <TASK>
[   80.546985]  dump_stack_lvl+0x4d/0x66
[   80.547335] xfs_corruption_error+0x132/0x150
[   80.548391]  ? xfs_dir2_data_use_free+0xb3/0xeb0
[   80.548901]  ? xfs_dir2_data_use_free+0xb3/0xeb0
[   80.549319]  ? xfs_dir2_data_use_free+0xb3/0xeb0
[   80.550190] xfs_dir2_data_use_free+0x198/0xeb0
[   80.550718]  ? xfs_dir2_data_use_free+0xb3/0xeb0
[   80.551140] xfs_dir2_leaf_addname+0xa59/0x1ac0
[   80.551881]  ? _raw_spin_unlock_irqrestore+0x42/0x80
[   80.552403]  ? xfs_dir2_leaf_search_hash+0x300/0x300
or
[  201.405239] BUG: KASAN: slab-out-of-bounds in 
xfs_dir2_leaf_addname+0x1995/0x1ac0
[  201.406179] Write of size 2 at addr ffff888078c33000 by task touch/7433
[  201.407010]
[  201.407217] CPU: 6 PID: 7433 Comm: touch Not tainted 6.0.0-rc3+ #115
[  201.408016] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.13.0-1ubuntu1.1 04/01/2014
[  201.409143] Call Trace:
[  201.409461]  <TASK>
[  201.409740]  dump_stack_lvl+0x4d/0x66
[  201.410214]  print_report.cold+0xf6/0x691
[  201.410730]  ? xfs_dir3_data_init+0x18e/0x960

UAF/slab-out-of bound etc...

> you want to check? I think xfstests checks dmesg at the end of each test case,
> except you need to check some special one, or need a special filter?
check demsg without filter seems enough, so i did not add special filter.
> Thanks,
> Zorro
>
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/xfs/554.out b/tests/xfs/554.out
>> new file mode 100644
>> index 00000000..ea1f30cc
>> --- /dev/null
>> +++ b/tests/xfs/554.out
>> @@ -0,0 +1,6 @@
>> +QA output created by 554
>> +Format and mount
>> +Create and check leaf dir
>> +Inject bad bestfress array size
>> +ltail.bestcount = 0
>> +Test add entry to dir
>> -- 
>> 2.25.1
>>
> .
