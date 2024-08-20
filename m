Return-Path: <linux-xfs+bounces-11791-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 443B8958046
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Aug 2024 09:51:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE41BB20E58
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Aug 2024 07:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49398189902;
	Tue, 20 Aug 2024 07:51:31 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A86172BB9;
	Tue, 20 Aug 2024 07:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724140291; cv=none; b=h1pAcwMNzh9bHDj2yhQs1eAfnpQGIiVDvXId4fM0kbldLejzD4tYDwLNotsHnaGv2BCmz/2DjtxC08QR4bvuSO9QFCsE843l2/NnNlgaKzSIOl3Pl8CKB94rjFieaMxK6c/OjkMsJtrtiZnL8kYQBaZqR5j7IChVsiio6qK7MXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724140291; c=relaxed/simple;
	bh=s4ECx9eCCtxtO8R680f3ZjpHoPDMSMlHP8buCCcZDAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=L0/szFNe0VQ7o0zXrGKlkHgztSdjcCDJQ2lJ8kmnr1FZ7CL5d0OOOp/E7DRhBrLMGTRYpD2uSsnNwCNH9VjwcUskV++Cj/6KXFe/8crhsSUSOUJX5Ob59AhFkho1wmzBvFYaGK0kqztOrNqciKJRrsbQM2xXAtZxIH8ERxZOV28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Wp1kB13WHz2Cmsh;
	Tue, 20 Aug 2024 15:46:26 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id AF2211A0190;
	Tue, 20 Aug 2024 15:51:25 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Aug 2024 15:51:24 +0800
Message-ID: <04118984-4c10-4d25-9547-0e3cd5d9fb03@huawei.com>
Date: Tue, 20 Aug 2024 15:51:23 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 0/2] Some bugfix for xfs fsmap
To: Chandan Babu R <chandanbabu@kernel.org>
CC: <djwong@kernel.org>, <dchinner@redhat.com>, <osandov@fb.com>,
	<john.g.garry@oracle.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>
References: <20240819005320.304211-1-wozizhi@huawei.com>
 <875xrvenzf.fsf@debian-BULLSEYE-live-builder-AMD64>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <875xrvenzf.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemf100017.china.huawei.com (7.202.181.16)



在 2024/8/20 13:53, Chandan Babu R 写道:
> On Mon, Aug 19, 2024 at 08:53:18 AM +0800, Zizhi Wo wrote:
>> Changes since V3[1]:
>>   - For the first patch, simply place the modification logic in the
>>     xfs_fsmap_owner_to_rmap() function.
>>   - For the second patch, more detailed comments were added and related
>>     changes were made to the initialization of the end_daddr field.
>>
>> This patch set contains two patches to repair fsmap. Although they are both
>> problems of missing query intervals, the root causes of the two are
>> inconsistent, so two patches are proposed.
>>
>> Patch 1: The fix addresses the interval omission issue caused by the
>> incorrect setting of "rm_owner" in the high_key during rmap queries. In
>> this scenario, fsmap finds the record on the rmapbt, but due to the
>> incorrect setting of the "rm_owner", the key of the record is larger than
>> the high_key, causing the query result to be incorrect. This issue is
>> resolved by fixing the "rm_owner" setup logic.
>>
>> Patch 2: The fix addresses the interval omission issue caused by bit
>> shifting during gap queries in fsmap. In this scenario, fsmap does not
>> find the record on the rmapbt, so it needs to locate it by the gap of the
>> info->next_daddr and high_key address. However, due to the shift, the two
>> are reduced to 0, so the query error is caused. The issue is resolved by
>> introducing the "end_daddr" field in the xfs_getfsmap_info structure to
>> store the high_key at the sector granularity.
>>
>> [1] https://lore.kernel.org/all/20240812011505.1414130-1-wozizhi@huawei.com/
>>
> 
> The two patches in this series cause xfs_scrub to execute indefinitely
> immediately after xfs/556 is executed.
> 
> The fstest configuration used is provided below,
> 
> FSTYP=xfs
> TEST_DIR=/media/test
> SCRATCH_MNT=/media/scratch
> TEST_DEV=/dev/loop16
> TEST_LOGDEV=/dev/loop13
> TEST_RTDEV=/dev/loop12
> TEST_FS_MOUNT_OPTS="-o rtdev=/dev/loop12 -o logdev=/dev/loop13"
> SCRATCH_DEV_POOL="/dev/loop5 /dev/loop6 /dev/loop7 /dev/loop8 /dev/loop9 /dev/loop10 /dev/loop11"
> MKFS_OPTIONS="-f -m reflink=0,rmapbt=0, -d rtinherit=1 -lsize=1g"
> SCRATCH_LOGDEV=/dev/loop15
> SCRATCH_RTDEV=/dev/loop14
> USE_EXTERNAL=yes
> 

Sorry, running xfs/556 with this configuration was successful in my
environment, and my mkfs.xfs version is 6.8.0:

xfs/556
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 fedora 6.11.0-rc3-00015-g1a9f212eb19f #42
SMP PREEMPT_DYNAMIC Fri Aug 16 10:19:47 CST 2024
VMIP          -- 192.168.240.11
MKFS_OPTIONS  -- -f -f -m reflink=0,rmapbt=0 -d rtinherit=1 -l size=1g
/dev/vde
MOUNT_OPTIONS -- /dev/vde /tmp/scratch

xfs/556 4s ...  5s
Ran: xfs/556
Passed all 1 tests

I am not sure if it is because of the specific user mode tools or other
environment configuration differences caused?

Thanks,
Zizhi Wo

