Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8EA1877CB
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Mar 2020 03:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgCQCZc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Mar 2020 22:25:32 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11703 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726024AbgCQCZc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Mar 2020 22:25:32 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D90AC62159BFE652FCEF;
        Tue, 17 Mar 2020 10:22:42 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Tue, 17 Mar 2020
 10:22:34 +0800
Subject: Re: [PATCH 1/2] xfs: always init fdblocks in mount
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     <bfoster@redhat.com>, <dchinner@redhat.com>, <sandeen@sandeen.net>,
        <linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>
References: <1584364028-122886-1-git-send-email-zhengbin13@huawei.com>
 <1584364028-122886-2-git-send-email-zhengbin13@huawei.com>
 <20200316151311.GD256767@magnolia>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <5a5c7fc4-eb67-0b0f-44d3-8ea3a7554c8e@huawei.com>
Date:   Tue, 17 Mar 2020 10:22:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20200316151311.GD256767@magnolia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2020/3/16 23:13, Darrick J. Wong wrote:
> On Mon, Mar 16, 2020 at 09:07:07PM +0800, Zheng Bin wrote:
>> Use fuzz(hydra) to test XFS and automatically generate
>> tmp.img(XFS v5 format, but some metadata is wrong)
>>
>> xfs_repair information(just one AG):
>> agf_freeblks 0, counted 3224 in ag 0
>> agf_longest 0, counted 3224 in ag 0
>> sb_fdblocks 3228, counted 3224
>>
>> Test as follows:
>> mount tmp.img tmpdir
>> cp file1M tmpdir
>> sync
>>
>> In 4.19-stable, sync will stuck, while in linux-next, sync not stuck.
>> The reason is same to commit d0c7feaf8767
>> ("xfs: add agf freeblocks verify in xfs_agf_verify"), cause agf_longest
>> is 0, we can not block this in xfs_agf_verify.
> Uh.... what are you saying here?  That the allocator misbehaves and
> loops forever if sb_fdblocks > sum(agf_freeblks) after mount?
>
> Also, uh, what do you mean by "sync not stuck"?  Writeback will fail on
> allocation error, right...?  So I think the problem with incorrect AGF
> contents (on upstream) is that writeback will fail due to ENOSPC, which
> should never happen under normal circumstance?
>
>> Make sure fdblocks is always inited in mount(also init ifree, icount).
>>
>> xfs_mountfs
>>   xfs_check_summary_counts
>>     xfs_initialize_perag_data
>>
>> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
>> ---
>>  fs/xfs/xfs_mount.c | 33 ---------------------------------
>>  1 file changed, 33 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
>> index c5513e5..dc41801 100644
>> --- a/fs/xfs/xfs_mount.c
>> +++ b/fs/xfs/xfs_mount.c
>> @@ -594,39 +594,6 @@ xfs_check_summary_counts(
>>  		return -EFSCORRUPTED;
>>  	}
>>
>> -	/*
>> -	 * Now the log is mounted, we know if it was an unclean shutdown or
>> -	 * not. If it was, with the first phase of recovery has completed, we
>> -	 * have consistent AG blocks on disk. We have not recovered EFIs yet,
>> -	 * but they are recovered transactionally in the second recovery phase
>> -	 * later.
>> -	 *
>> -	 * If the log was clean when we mounted, we can check the summary
>> -	 * counters.  If any of them are obviously incorrect, we can recompute
>> -	 * them from the AGF headers in the next step.
>> -	 */
>> -	if (XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
>> -	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
>> -	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
>> -	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
>> -		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
>> -
>> -	/*
>> -	 * We can safely re-initialise incore superblock counters from the
>> -	 * per-ag data. These may not be correct if the filesystem was not
>> -	 * cleanly unmounted, so we waited for recovery to finish before doing
>> -	 * this.
>> -	 *
>> -	 * If the filesystem was cleanly unmounted or the previous check did
>> -	 * not flag anything weird, then we can trust the values in the
>> -	 * superblock to be correct and we don't need to do anything here.
>> -	 * Otherwise, recalculate the summary counters.
>> -	 */
>> -	if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
>> -	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
>> -	    !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
>> -		return 0;
>> -
>>  	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
> The downside of this is that now we /always/ have to make two trips
> around all of the AGs at mount time.  If you're proposing to require a
> fresh fdblocks recomputation at mount, could you please refactor all of
> the mount-time AG walks into a single loop?  And perhaps use xfs_pwork
> so that we don't have to do it serially?
xfs_mountfs
  xfs_initialize_perag         -->just alloc memory
  xfs_check_summary_counts
    xfs_initialize_perag_data  -->read agf,agi from disk
      for (index = 0; index < agcount; index++)
        error = xfs_alloc_pagf_init(mp, NULL, index, 0)
        error = xfs_ialloc_pagi_init(mp, NULL, index)
  xfs_fs_reserve_ag_blocks
    for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
      xfs_ag_resv_init
        #ifdef DEBUG  -->read agf
          error = xfs_alloc_pagf_init(pag->pag_mount, tp, pag->pag_agno, 0)
        #endif

Is this? if enable XFS_DEBUG, xfs_initialize_perag_data read agf, xfs_ag_resv_init

also read agf?

>
> --D
>
>>  }
>>
>> --
>> 2.7.4
>>
> .
>

