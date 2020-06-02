Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5371EC53B
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jun 2020 00:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgFBWn2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 Jun 2020 18:43:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35700 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbgFBWn2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 18:43:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052MfuX6035690;
        Tue, 2 Jun 2020 22:43:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=HLx4b5wle3zhq1D2oH8J9wjfNoAsxLx1jSerSA20Kp8=;
 b=HzLpQ4LFuBi+UL2II2jPe+JDA7IayWHq8L6a0CjK0QrjA/4RTrx0GddGgkaRuZwQQK6I
 6yGCJv5xxdbeatnjrLAVZFqHxWwJXlHa1CDFxAYEJz+5gjJKjOUaL4jvzG2Spyz0BGlx
 xlq8btoxc7hav+HFZeA+Pxl4bc961I6MIUFINLic6JAjIG2fjUSVLuEp4/kpkS0aMvOw
 6MXtWlmtoT9f+ac/X+0QE7XhnMfJl9cQAY+sTrekLBfmbIw2Hd7qhGZm1NgVUr6FMiQG
 ZoLmWPPXZrRdnGJ1GrVpbTeWycpnIZSzsrhI0C0ZY7P3ssaZmCylCofcwSZ3MlsUHxYw IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31bewqxeu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 22:43:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052MhHQE167132;
        Tue, 2 Jun 2020 22:43:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31c1dy0g5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 22:43:25 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 052MhOnC028645;
        Tue, 2 Jun 2020 22:43:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 15:43:24 -0700
Date:   Tue, 2 Jun 2020 15:43:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/30] xfs: remove SYNC_WAIT from xfs_reclaim_inodes()
Message-ID: <20200602224322.GO8230@magnolia>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-23-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-23-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=5 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=5 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020158
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:43AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Clean up xfs_reclaim_inodes() callers. Most callers want blocking
> behaviour, so just make the existing SYNC_WAIT behaviour the
> default.
> 
> For the xfs_reclaim_worker(), just call xfs_reclaim_inodes_ag()
> directly because we just want optimistic clean inode reclaim to be
> done in the background.
> 
> For xfs_quiesce_attr() we can just remove the inode reclaim calls as
> they are a historic relic that was required to flush dirty inodes
> that contained unlogged changes. We now log all changes to the
> inodes, so the sync AIL push from xfs_log_quiesce() called by
> xfs_quiesce_attr() will do all the required inode writeback for
> freeze.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Heh, neat,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_icache.c | 48 ++++++++++++++++++++-------------------------
>  fs/xfs/xfs_icache.h |  2 +-
>  fs/xfs/xfs_mount.c  | 11 +++++------
>  fs/xfs/xfs_super.c  |  3 ---
>  4 files changed, 27 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index ebe55124d6cb8..a27470fc201ff 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -160,24 +160,6 @@ xfs_reclaim_work_queue(
>  	rcu_read_unlock();
>  }
>  
> -/*
> - * This is a fast pass over the inode cache to try to get reclaim moving on as
> - * many inodes as possible in a short period of time. It kicks itself every few
> - * seconds, as well as being kicked by the inode cache shrinker when memory
> - * goes low. It scans as quickly as possible avoiding locked inodes or those
> - * already being flushed, and once done schedules a future pass.
> - */
> -void
> -xfs_reclaim_worker(
> -	struct work_struct *work)
> -{
> -	struct xfs_mount *mp = container_of(to_delayed_work(work),
> -					struct xfs_mount, m_reclaim_work);
> -
> -	xfs_reclaim_inodes(mp, 0);
> -	xfs_reclaim_work_queue(mp);
> -}
> -
>  static void
>  xfs_perag_set_reclaim_tag(
>  	struct xfs_perag	*pag)
> @@ -1298,24 +1280,17 @@ xfs_reclaim_inodes_ag(
>  	return skipped;
>  }
>  
> -int
> +void
>  xfs_reclaim_inodes(
> -	xfs_mount_t	*mp,
> -	int		mode)
> +	struct xfs_mount	*mp)
>  {
>  	int		nr_to_scan = INT_MAX;
>  	int		skipped;
>  
> -	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
> -	if (!(mode & SYNC_WAIT))
> -		return 0;
> -
>  	do {
>  		xfs_ail_push_all_sync(mp->m_ail);
>  		skipped = xfs_reclaim_inodes_ag(mp, &nr_to_scan);
>  	} while (skipped > 0);
> -
> -	return 0;
>  }
>  
>  /*
> @@ -1434,6 +1409,25 @@ xfs_inode_matches_eofb(
>  	return true;
>  }
>  
> +/*
> + * This is a fast pass over the inode cache to try to get reclaim moving on as
> + * many inodes as possible in a short period of time. It kicks itself every few
> + * seconds, as well as being kicked by the inode cache shrinker when memory
> + * goes low. It scans as quickly as possible avoiding locked inodes or those
> + * already being flushed, and once done schedules a future pass.
> + */
> +void
> +xfs_reclaim_worker(
> +	struct work_struct *work)
> +{
> +	struct xfs_mount *mp = container_of(to_delayed_work(work),
> +					struct xfs_mount, m_reclaim_work);
> +	int		nr_to_scan = INT_MAX;
> +
> +	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
> +	xfs_reclaim_work_queue(mp);
> +}
> +
>  STATIC int
>  xfs_inode_free_eofblocks(
>  	struct xfs_inode	*ip,
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index 93b54e7d55f0d..ae92ca53de423 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -51,7 +51,7 @@ void xfs_inode_free(struct xfs_inode *ip);
>  
>  void xfs_reclaim_worker(struct work_struct *work);
>  
> -int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
> +void xfs_reclaim_inodes(struct xfs_mount *mp);
>  int xfs_reclaim_inodes_count(struct xfs_mount *mp);
>  long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 03158b42a1943..c8ae49a1e99c3 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1011,7 +1011,7 @@ xfs_mountfs(
>  	 * quota inodes.
>  	 */
>  	cancel_delayed_work_sync(&mp->m_reclaim_work);
> -	xfs_reclaim_inodes(mp, SYNC_WAIT);
> +	xfs_reclaim_inodes(mp);
>  	xfs_health_unmount(mp);
>   out_log_dealloc:
>  	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
> @@ -1088,13 +1088,12 @@ xfs_unmountfs(
>  	xfs_ail_push_all_sync(mp->m_ail);
>  
>  	/*
> -	 * And reclaim all inodes.  At this point there should be no dirty
> -	 * inodes and none should be pinned or locked, but use synchronous
> -	 * reclaim just to be sure. We can stop background inode reclaim
> -	 * here as well if it is still running.
> +	 * Reclaim all inodes. At this point there should be no dirty inodes and
> +	 * none should be pinned or locked. Stop background inode reclaim here
> +	 * if it is still running.
>  	 */
>  	cancel_delayed_work_sync(&mp->m_reclaim_work);
> -	xfs_reclaim_inodes(mp, SYNC_WAIT);
> +	xfs_reclaim_inodes(mp);
>  	xfs_health_unmount(mp);
>  
>  	xfs_qm_unmount(mp);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index fa58cb07c8fdf..9b03ea43f4fe7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -890,9 +890,6 @@ xfs_quiesce_attr(
>  	/* force the log to unpin objects from the now complete transactions */
>  	xfs_log_force(mp, XFS_LOG_SYNC);
>  
> -	/* reclaim inodes to do any IO before the freeze completes */
> -	xfs_reclaim_inodes(mp, 0);
> -	xfs_reclaim_inodes(mp, SYNC_WAIT);
>  
>  	/* Push the superblock and write an unmount record */
>  	error = xfs_log_sbcount(mp);
> -- 
> 2.26.2.761.g0e0b3e54be
> 
