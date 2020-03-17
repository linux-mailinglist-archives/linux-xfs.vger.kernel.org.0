Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1754018784D
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Mar 2020 04:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgCQDzY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Mar 2020 23:55:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48256 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgCQDzY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Mar 2020 23:55:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02H3sMbQ043976;
        Tue, 17 Mar 2020 03:55:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=mDCr+f+tw+qSN1FgV3uj2lM6U1KTTdzEQDmeY8gjqPc=;
 b=NnTK8Zzv5P+Beykh4cTKpQHmGRPACPuIiEFoNJrSjjV4/Vdyc9f09e11sfXxEl4fH2Vu
 ++hlNCFjMuFelFG0KNxdaSZ/JY6fSDRnoV5UDqy4XZm26x5vOTAm6jP0tOs+EUh24CYG
 e6jU7FbpUhbPKx+j/ukC46hObI1BQCNZqFByjce8iQ3k5gVZPF2E9IhM/tJINLk67Rgx
 y1lyh4c5i7dIUG9rLD69c/9ukuHbwh0CpQmoi71LllLGQrFJWidOKQGV66XdSR+EViV1
 X7Q/tOD80aoconB8mzCPWZxNuvGH+lk+QxjJFFrUBk6snz/EOndz8wZ/DXIJOCMnpBrx dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yrq7ktb53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 03:55:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02H3qMbT167269;
        Tue, 17 Mar 2020 03:55:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ys8yx7dg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 03:55:12 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02H3tA9m025115;
        Tue, 17 Mar 2020 03:55:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 20:55:09 -0700
Date:   Mon, 16 Mar 2020 20:55:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     "zhengbin (A)" <zhengbin13@huawei.com>
Cc:     bfoster@redhat.com, dchinner@redhat.com, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com
Subject: Re: [PATCH 1/2] xfs: always init fdblocks in mount
Message-ID: <20200317035507.GW256767@magnolia>
References: <1584364028-122886-1-git-send-email-zhengbin13@huawei.com>
 <1584364028-122886-2-git-send-email-zhengbin13@huawei.com>
 <20200316151311.GD256767@magnolia>
 <5a5c7fc4-eb67-0b0f-44d3-8ea3a7554c8e@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5a5c7fc4-eb67-0b0f-44d3-8ea3a7554c8e@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 17, 2020 at 10:22:33AM +0800, zhengbin (A) wrote:
> 
> On 2020/3/16 23:13, Darrick J. Wong wrote:
> > On Mon, Mar 16, 2020 at 09:07:07PM +0800, Zheng Bin wrote:
> >> Use fuzz(hydra) to test XFS and automatically generate
> >> tmp.img(XFS v5 format, but some metadata is wrong)
> >>
> >> xfs_repair information(just one AG):
> >> agf_freeblks 0, counted 3224 in ag 0
> >> agf_longest 0, counted 3224 in ag 0
> >> sb_fdblocks 3228, counted 3224
> >>
> >> Test as follows:
> >> mount tmp.img tmpdir
> >> cp file1M tmpdir
> >> sync
> >>
> >> In 4.19-stable, sync will stuck, while in linux-next, sync not stuck.
> >> The reason is same to commit d0c7feaf8767
> >> ("xfs: add agf freeblocks verify in xfs_agf_verify"), cause agf_longest
> >> is 0, we can not block this in xfs_agf_verify.
> > Uh.... what are you saying here?  That the allocator misbehaves and
> > loops forever if sb_fdblocks > sum(agf_freeblks) after mount?
> >
> > Also, uh, what do you mean by "sync not stuck"?  Writeback will fail on
> > allocation error, right...?  So I think the problem with incorrect AGF
> > contents (on upstream) is that writeback will fail due to ENOSPC, which
> > should never happen under normal circumstance?
> >
> >> Make sure fdblocks is always inited in mount(also init ifree, icount).
> >>
> >> xfs_mountfs
> >>   xfs_check_summary_counts
> >>     xfs_initialize_perag_data
> >>
> >> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> >> ---
> >>  fs/xfs/xfs_mount.c | 33 ---------------------------------
> >>  1 file changed, 33 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> >> index c5513e5..dc41801 100644
> >> --- a/fs/xfs/xfs_mount.c
> >> +++ b/fs/xfs/xfs_mount.c
> >> @@ -594,39 +594,6 @@ xfs_check_summary_counts(
> >>  		return -EFSCORRUPTED;
> >>  	}
> >>
> >> -	/*
> >> -	 * Now the log is mounted, we know if it was an unclean shutdown or
> >> -	 * not. If it was, with the first phase of recovery has completed, we
> >> -	 * have consistent AG blocks on disk. We have not recovered EFIs yet,
> >> -	 * but they are recovered transactionally in the second recovery phase
> >> -	 * later.
> >> -	 *
> >> -	 * If the log was clean when we mounted, we can check the summary
> >> -	 * counters.  If any of them are obviously incorrect, we can recompute
> >> -	 * them from the AGF headers in the next step.
> >> -	 */
> >> -	if (XFS_LAST_UNMOUNT_WAS_CLEAN(mp) &&
> >> -	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
> >> -	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
> >> -	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
> >> -		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
> >> -
> >> -	/*
> >> -	 * We can safely re-initialise incore superblock counters from the
> >> -	 * per-ag data. These may not be correct if the filesystem was not
> >> -	 * cleanly unmounted, so we waited for recovery to finish before doing
> >> -	 * this.
> >> -	 *
> >> -	 * If the filesystem was cleanly unmounted or the previous check did
> >> -	 * not flag anything weird, then we can trust the values in the
> >> -	 * superblock to be correct and we don't need to do anything here.
> >> -	 * Otherwise, recalculate the summary counters.
> >> -	 */
> >> -	if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
> >> -	     XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
> >> -	    !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
> >> -		return 0;
> >> -
> >>  	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
> > The downside of this is that now we /always/ have to make two trips
> > around all of the AGs at mount time.  If you're proposing to require a
> > fresh fdblocks recomputation at mount, could you please refactor all of
> > the mount-time AG walks into a single loop?  And perhaps use xfs_pwork
> > so that we don't have to do it serially?
> xfs_mountfs
> � xfs_initialize_perag�������� -->just alloc memory
> � xfs_check_summary_counts
> ��� xfs_initialize_perag_data� -->read agf,agi from disk
> ��� � for (index = 0; index < agcount; index++)
> ��� ��� error = xfs_alloc_pagf_init(mp, NULL, index, 0)
> ��� ��� error = xfs_ialloc_pagi_init(mp, NULL, index)
> � xfs_fs_reserve_ag_blocks
> ��� for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
> ��� � xfs_ag_resv_init
> ��� ��� #ifdef DEBUG� -->read agf
> ��� ��� � error = xfs_alloc_pagf_init(pag->pag_mount, tp, pag->pag_agno, 0)
> ��� ��� #endif
> 
> Is this? if enable XFS_DEBUG, xfs_initialize_perag_data read agf, xfs_ag_resv_init
> 
> also read agf?

Yes, that's the other AG-walker that I was referring to.

--D

> 
> >
> > --D
> >
> >>  }
> >>
> >> --
> >> 2.7.4
> >>
> > .
> >
> 
