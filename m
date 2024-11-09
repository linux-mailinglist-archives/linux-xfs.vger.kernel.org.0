Return-Path: <linux-xfs+bounces-15228-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3099D9C2985
	for <lists+linux-xfs@lfdr.de>; Sat,  9 Nov 2024 03:34:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF512283828
	for <lists+linux-xfs@lfdr.de>; Sat,  9 Nov 2024 02:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1EF75A4C1;
	Sat,  9 Nov 2024 02:34:41 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DD12110E;
	Sat,  9 Nov 2024 02:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731119681; cv=none; b=dTN/DzSY15/H2R/h/8zVYHBwxenglj0KrZv+n3bOxjx1P0guyeNYH+EvIQpXLo12sjyxFMFbqiEQWKIdbRb6Em8runEcNSI/akDqu3MitJol6H1WfBcxTDWDK4RbvKJSRUXhU7y/6snHB1TJ7OPaOqF2ohguAuTuvgWPbLQGweE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731119681; c=relaxed/simple;
	bh=uswVlEUZr7uvxmbURgkMM3gl0th0qLi2chpHnjse7FU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ilVzqdKDcejzOFCTPXleR1F8BGYv+NM0ENjpH9PkXed25wfcy9VQDdJIUPvNHw7e6wjoDnOsNVYn/B5oe6ut1vIgh3iv9YDStSAnIPBWWFaowYk2XNL/RjOlxq7rChstgPcNBog+cJgfA4WnEk7lnPfNwC70cZioENWMtUF+hIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XlfwC2Yzlz10Qp4;
	Sat,  9 Nov 2024 10:32:11 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 175EC180106;
	Sat,  9 Nov 2024 10:34:35 +0800 (CST)
Received: from [10.174.176.88] (10.174.176.88) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 9 Nov 2024 10:34:34 +0800
Message-ID: <d22fcc83-9290-4561-acf8-be5741ab94f7@huawei.com>
Date: Sat, 9 Nov 2024 10:34:33 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] xfs: Fix missing block calculations in xfs datadev
 fsmap
To: "Darrick J. Wong" <djwong@kernel.org>
CC: <chandan.babu@oracle.com>, <dchinner@redhat.com>, <osandov@fb.com>,
	<john.g.garry@oracle.com>, <linux-xfs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>
References: <20240826031005.2493150-1-wozizhi@huawei.com>
 <20240826031005.2493150-2-wozizhi@huawei.com>
 <20241107234352.GU2386201@frogsfrogsfrogs>
 <1549f04a-8431-405d-adfc-23e5988abe51@huawei.com>
 <20241108173006.GA168069@frogsfrogsfrogs>
From: Zizhi Wo <wozizhi@huawei.com>
In-Reply-To: <20241108173006.GA168069@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemf100017.china.huawei.com (7.202.181.16)



在 2024/11/9 1:30, Darrick J. Wong 写道:
> On Fri, Nov 08, 2024 at 10:29:08AM +0800, Zizhi Wo wrote:
>>
>>
>> 在 2024/11/8 7:43, Darrick J. Wong 写道:
>>> On Mon, Aug 26, 2024 at 11:10:04AM +0800, Zizhi Wo wrote:
>>>> In xfs datadev fsmap query, I noticed a missing block calculation problem:
>>>> [root@fedora ~]# xfs_db -r -c "sb 0" -c "p" /dev/vdb
>>>> magicnum = 0x58465342
>>>> blocksize = 4096
>>>> dblocks = 5242880
>>>> ......
>>>> [root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
>>>> ...
>>>> 30: 253:16 [31457384..41943031]: free space            3  (104..10485751)    10485648
>>>>
>>>> (41943031 + 1) / 8 = 5242879 != 5242880
>>>> We missed one block in our fsmap calculation!
>>>
>>> Eek.
>>>
>>>> The root cause of the problem lies in __xfs_getfsmap_datadev(), where the
>>>> calculation of "end_fsb" requires a classification discussion. If "end_fsb"
>>>> is calculated based on "eofs", we need to add an extra sentinel node for
>>>> subsequent length calculations. Otherwise, one block will be missed. If
>>>> "end_fsb" is calculated based on "keys[1]", then there is no need to add an
>>>> extra node. Because "keys[1]" itself is unreachable, it cancels out one of
>>>> the additions. The diagram below illustrates this:
>>>>
>>>> |0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|-----eofs
>>>> |---------------|---------------------|
>>>> a       n       b         n+1         c
>>>>
>>>> Assume that eofs is 16, the start address of the previous query is block n,
>>>> sector 0, and the length is 1, so the "info->next" is at point b, sector 8.
>>>> In the last query, suppose the "rm_startblock" calculated based on
>>>> "eofs - 1" is the last block n+1 at point b. All we get is the starting
>>>> address of the block, not the end. Therefore, an additional sentinel node
>>>> needs to be added to move it to point c. After that, subtracting one from
>>>> the other will yield the remaining 1.
>>>>
>>>> Although we can now calculate the exact last query using "info->end_daddr",
>>>> we will still get an incorrect value if the device at this point is not the
>>>> boundary device specified by "keys[1]", as "end_daddr" is still the initial
>>>> value. Therefore, the eofs situation here needs to be corrected. The issue
>>>> is resolved by adding a sentinel node.
>>>
>>> Why don't we set end_daddr unconditionally, then?
>>>
>>> Hmm, looking at the end_daddr usage in fsmap.c, I think it's wrong.  If
>>> end_daddr is set at all, it's set either to the last sector for which
>>> the user wants a mapping; or it's set to the last sector for the device.
>>> But then look at how we use it:
>>>
>>> 	if (info->last...)
>>> 		frec->start_daddr = info->end_daddr;
>>>
>>> 	...
>>>
>>> 	/* "report the gap..."
>>> 	if (frec->start_daddr > info->next_daddr) {
>>> 		fmr.fmr_length = frec->start_daddr - info->next_daddr;
>>> 	}
>>>
>>> This is wrong -- we're using start_daddr to compute the distance from
>>> the last mapping that we output up to the end of the range that we want.
>>> The "end of the range" is modeled with a phony rmap record that starts
>>> at the first fsblock after that range.
>>>
>>
>> In the current code, we set "rec_daddr = end_daddr" only when
>> (info->last && info->end_daddr != NULL), which should ensure that this
>> is the last query?
> 
> Right.
> 
>> Because end_daddr is set to the last device, and
>> info->last is set to the last query. Therefore, assigning it to
>> start_daddr should not cause issues in the next query?
> 
> Right, the code currently sets end_daddr only for the last device, so
> there won't be any issues with the next query.
> 
> That said, we reset the xfs_getfsmap_info state between each device, so
> it's safe to set end_daddr for every device, not just the last time
> through that loop.
> 
>> Did I misunderstand something? Or is it because the latest code
>> constantly updates end_daddr, which is why this issue arises?
> 
> The 6.13 metadir/rtgroups patches didn't change when end_daddr gets set,
> but my fixpatch *does* make it set end_daddr for all devices.  Will send
> a patch + fstests update shortly to demonstrate. :)

OK, I got it. Thank you for your reply.

Thanks,
Zizhi Wo

> 
>>> IOWs, that assignment should have been
>>> frec->start_daddr = info->end_daddr + 1.
>>>
>>> Granted in August the codebase was less clear about the difference
>>> between rec_daddr and rmap->rm_startblock.  For 6.13, hch cleaned all
>>> that up -- rec_daddr is now called start_daddr and the fsmap code passes
>>> rmap records with space numbers in units of daddrs via a new struct
>>> xfs_fsmap_rec.  Unfortunately, that's all buried in the giant pile of
>>> pull requests I sent a couple of days ago which hasn't shown up on
>>> for-next yet.
>>>
>>> https://lore.kernel.org/linux-xfs/173084396955.1871025.18156568347365549855.stgit@frogsfrogsfrogs/
>>>
>>> So I think I know how to fix this against the 6.13 codebase, but I'm
>>> going to take a slightly different approach than yours...
>>>
>>>> Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
>>>> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
>>>> ---
>>>>    fs/xfs/xfs_fsmap.c | 19 +++++++++++++++++--
>>>>    1 file changed, 17 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
>>>> index 85dbb46452ca..8a2dfe96dae7 100644
>>>> --- a/fs/xfs/xfs_fsmap.c
>>>> +++ b/fs/xfs/xfs_fsmap.c
>>>> @@ -596,12 +596,27 @@ __xfs_getfsmap_datadev(
>>>>    	xfs_agnumber_t			end_ag;
>>>>    	uint64_t			eofs;
>>>>    	int				error = 0;
>>>> +	int				sentinel = 0;
>>>>    	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
>>>>    	if (keys[0].fmr_physical >= eofs)
>>>>    		return 0;
>>>>    	start_fsb = XFS_DADDR_TO_FSB(mp, keys[0].fmr_physical);
>>>> -	end_fsb = XFS_DADDR_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
>>>> +	/*
>>>> +	 * For the case of eofs, we need to add a sentinel node;
>>>> +	 * otherwise, one block will be missed when calculating the length
>>>> +	 * in the last query.
>>>> +	 * For the case of key[1], there is no need to add a sentinel node
>>>> +	 * because it already represents a value that cannot be reached.
>>>> +	 * For the case where key[1] after shifting is within the same
>>>> +	 * block as the starting address, it is resolved using end_daddr.
>>>> +	 */
>>>> +	if (keys[1].fmr_physical > eofs - 1) {
>>>> +		sentinel = 1;
>>>> +		end_fsb = XFS_DADDR_TO_FSB(mp, eofs - 1);
>>>> +	} else {
>>>> +		end_fsb = XFS_DADDR_TO_FSB(mp, keys[1].fmr_physical);
>>>> +	}
>>>
>>> ...because running against djwong-wtf, I actually see the same symptoms
>>> for the realtime device.  So I think a better solution is to change
>>> xfs_getfsmap to set end_daddr always, and then fix the off by one error.
>>>
>>
>> Yes, my second patch looks at this rt problem...
>> Thank you for your reply
> 
> <nod>
> 
> --D
> 
>> Thanks,
>> Zizhi Wo
>>
>>
>>> I also don't really like "sentinel" values because they're not
>>> intuitive.
>>>
>>> I will also go update xfs/273 to check that there are no gaps in the
>>> mappings returned, and that they go to where the filesystem thinks is
>>> the end of the device.  Thanks for reporting this, sorry I was too busy
>>> trying to get metadir/rtgroups done to look at this until now. :(
>>>
>>> --D
>>>
>>
>>
>>
>>>>    	/*
>>>>    	 * Convert the fsmap low/high keys to AG based keys.  Initialize
>>>> @@ -649,7 +664,7 @@ __xfs_getfsmap_datadev(
>>>>    		info->pag = pag;
>>>>    		if (pag->pag_agno == end_ag) {
>>>>    			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
>>>> -					end_fsb);
>>>> +					end_fsb) + sentinel;
>>>>    			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
>>>>    					keys[1].fmr_offset);
>>>>    			error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
>>>> -- 
>>>> 2.39.2
>>>>
>>>>
>>
> 

