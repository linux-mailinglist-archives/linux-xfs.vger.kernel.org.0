Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2A8AB0C6
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Sep 2019 05:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389424AbfIFDBm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Sep 2019 23:01:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43938 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731491AbfIFDBm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:01:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8630ubw086925;
        Fri, 6 Sep 2019 03:01:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=Ysh6zeGVoskBNQpeiqFHRIbIOIWBXBDy6jaFThdBEUQ=;
 b=UM3cWCBZzUkgtK9LYTSulOJMdDk0DhiDc+vnR3KsDK6eyoVfBMBcZLlWUkUy/wByiGzK
 7dbAkY/SAMUbo0sd5kNrMp9s94KFjqo2ABXLDiq1o/3MZCYYuUzKpHzxFGnxyiBZJFQv
 LNBihNFl7dDatETjX+cEg57dDYYkcgFB4yK0Pb1ntNC9QeC8FV+eTdmW4cdEYEpYmS4c
 7ZXvKMa/m+MbHc10AI7ULGWq12hOI09Ts0b0BPagmzMj0qEksLzKYDkMv++A8cMyEBDs
 SJN+O4ZB3ArS00M+PynYn1/Wrf9bi3OO9DXlG4o49ENfo3l77sl7AibFK+b3NifkDhNk EA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uuf4n00jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:01:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x862r7GR021945;
        Fri, 6 Sep 2019 03:01:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uu1b996qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:01:38 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8631b7L000829;
        Fri, 6 Sep 2019 03:01:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:01:36 -0700
Date:   Thu, 5 Sep 2019 20:01:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8 v2] xfs: prevent CIL push holdoff in log recovery
Message-ID: <20190906030136.GR2229799@magnolia>
References: <20190906000553.6740-1-david@fromorbit.com>
 <20190906000553.6740-4-david@fromorbit.com>
 <20190906001550.GM2229799@magnolia>
 <20190906020132.GM1119@dread.disaster.area>
 <20190906020813.GN1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906020813.GN1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 06, 2019 at 12:08:13PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> generic/530 on a machine with enough ram and a non-preemptible
> kernel can run the AGI processing phase of log recovery enitrely out
> of cache. This means it never blocks on locks, never waits for IO
> and runs entirely through the unlinked lists until it either
> completes or blocks and hangs because it has run out of log space.
> 
> It runs out of log space because the background CIL push is
> scheduled but never runs. queue_work() queues the CIL work on the
> current CPU that is busy, and the workqueue code will not run it on
> any other CPU. Hence if the unlinked list processing never yields
> the CPU voluntarily, the push work is delayed indefinitely. This
> results in the CIL aggregating changes until all the log space is
> consumed.
> 
> When the log recoveyr processing evenutally blocks, the CIL flushes
> but because the last iclog isn't submitted for IO because it isn't
> full, the CIL flush never completes and nothing ever moves the log
> head forwards, or indeed inserts anything into the tail of the log,
> and hence nothing is able to get the log moving again and recovery
> hangs.
> 
> There are several problems here, but the two obvious ones from
> the trace are that:
> 	a) log recovery does not yield the CPU for over 4 seconds,
> 	b) binding CIL pushes to a single CPU is a really bad idea.
> 
> This patch addresses just these two aspects of the problem, and are
> suitable for backporting to work around any issues in older kernels.
> The more fundamental problem of preventing the CIL from consuming
> more than 50% of the log without committing will take more invasive
> and complex work, so will be done as followup work.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_log_recover.c | 30 +++++++++++++++++++++---------
>  fs/xfs/xfs_super.c       |  3 ++-
>  2 files changed, 23 insertions(+), 10 deletions(-)
> 
> V2: big comment update
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index f05c6c99c4f3..508319039dce 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -5024,16 +5024,27 @@ xlog_recover_process_one_iunlink(
>  }
>  
>  /*
> - * xlog_iunlink_recover
> + * Recover AGI unlinked lists
>   *
> - * This is called during recovery to process any inodes which
> - * we unlinked but not freed when the system crashed.  These
> - * inodes will be on the lists in the AGI blocks.  What we do
> - * here is scan all the AGIs and fully truncate and free any
> - * inodes found on the lists.  Each inode is removed from the
> - * lists when it has been fully truncated and is freed.  The
> - * freeing of the inode and its removal from the list must be
> - * atomic.
> + * This is called during recovery to process any inodes which we unlinked but
> + * not freed when the system crashed.  These inodes will be on the lists in the
> + * AGI blocks. What we do here is scan all the AGIs and fully truncate and free
> + * any inodes found on the lists. Each inode is removed from the lists when it
> + * has been fully truncated and is freed. The freeing of the inode and its
> + * removal from the list must be atomic.
> + *
> + * If everything we touch in the agi processing loop is already in memory, this
> + * loop can hold the cpu for a long time. It runs without lock contention,
> + * memory allocation contention, the need wait for IO, etc, and so will run
> + * until we either run out of inodes to process, run low on memory or we run out
> + * of log space.
> + *
> + * This behaviour is bad for latency on single CPU and non-preemptible kernels,
> + * and can prevent other filesytem work (such as CIL pushes) from running. This
> + * can lead to deadlocks if the recovery process runs out of log reservation
> + * space. Hence we need to yield the CPU when there is other kernel work
> + * scheduled on this CPU to ensure other scheduled work can run without undue
> + * latency.

I agree that this is a much better comment for the function.  Thanks for
writing this. :)

--D

>   */
>  STATIC void
>  xlog_recover_process_iunlinks(
> @@ -5080,6 +5091,7 @@ xlog_recover_process_iunlinks(
>  			while (agino != NULLAGINO) {
>  				agino = xlog_recover_process_one_iunlink(mp,
>  							agno, agino, bucket);
> +				cond_resched();
>  			}
>  		}
>  		xfs_buf_rele(agibp);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f9450235533c..391b4748cae3 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -818,7 +818,8 @@ xfs_init_mount_workqueues(
>  		goto out_destroy_buf;
>  
>  	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
> -			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
> +			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND,
> +			0, mp->m_fsname);
>  	if (!mp->m_cil_workqueue)
>  		goto out_destroy_unwritten;
>  
