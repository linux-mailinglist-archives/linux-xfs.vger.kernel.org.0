Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF1F1A39BC
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Apr 2020 20:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgDISTa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 9 Apr 2020 14:19:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42628 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDISTa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 14:19:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039IJ3MY068882;
        Thu, 9 Apr 2020 18:19:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pblGzCM8OAkDx+MyQ1rOj02k2PGXWZsPfccya5kKgYY=;
 b=TZejn6WGpusnz03icUNjud6WR5Ykn7fMCrZyo5pGZAxrGqrPyQIkyEpNtcT+WYF6DHdh
 BxlWtAByZIRkA/X14IvU6ythGUBFUHadz/RjBhshscZMRzuNNFRWbUSjq8ycusARhMbE
 yMSMlDSR1QfYaVgqwXcHnED0Kpq0vkUMu1Ukmg3DoRs3q2nqpMU3hPSeqGikQCzUTAWz
 CIe3G33U+uUYo/EiQVJmffzVF8Ws5o7Tyyfsr4Mab1nBUSJHTaYhonTX4AmqUmhuT6nr
 Q70ZMK6j0pdBO6GuWZDNTikUWi7LROERD48Uz7NZLYiEvQXpreE+1QeJQfl/Q0pCjvpa YA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 309gw4f03p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 18:19:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039IHdY6182221;
        Thu, 9 Apr 2020 18:19:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3091m90pm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 18:19:23 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 039IJMIN021251;
        Thu, 9 Apr 2020 18:19:22 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Apr 2020 11:19:22 -0700
Subject: Re: [PATCH] xfs: acquire superblock freeze protection on eofblocks
 scans
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
References: <20200408122119.33869-1-bfoster@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <bf922cf4-5745-cc8d-886b-183c151424ce@oracle.com>
Date:   Thu, 9 Apr 2020 11:19:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200408122119.33869-1-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004090133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 4/8/20 5:21 AM, Brian Foster wrote:
> The filesystem freeze sequence in XFS waits on any background
> eofblocks or cowblocks scans to complete before the filesystem is
> quiesced. At this point, the freezer has already stopped the
> transaction subsystem, however, which means a truncate or cowblock
> cancellation in progress is likely blocked in transaction
> allocation. This results in a deadlock between freeze and the
> associated scanner.
> 
> Fix this problem by holding superblock write protection across calls
> into the block reapers. Since protection for background scans is
> acquired from the workqueue task context, trylock to avoid a similar
> deadlock between freeze and blocking on the write lock.
> 
> Fixes: d6b636ebb1c9f ("xfs: halt auto-reclamation activities while rebuilding rmap")
> Reported-by: Paul Furtado <paulfurtado91@gmail.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
OK, looks good:
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> ---
> 
> Note that this has the opposite tradeoff as the approach I originally
> posited [1], specifically that the eofblocks ioctl() now always blocks
> on a frozen fs rather than return -EAGAIN. It's worth pointing out that
> the eofb control structure has a sync flag (that is not used for
> background scans), so yet another approach could be to tie the trylock
> to that.
> 
> Brian
> 
> [1] https://urldefense.com/v3/__https://lore.kernel.org/linux-xfs/20200407163739.GG28936@bfoster/__;!!GqivPVa7Brio!NNOb1nQFma-Q2kltH-cEBh_IdUSxLRairJB0HGGs9YaY9qh9sdcPm4SUCnMXoxe1mkGk$
> 
>   fs/xfs/xfs_icache.c | 10 ++++++++++
>   fs/xfs/xfs_ioctl.c  |  5 ++++-
>   2 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a7be7a9e5c1a..8bf1d15be3f6 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -911,7 +911,12 @@ xfs_eofblocks_worker(
>   {
>   	struct xfs_mount *mp = container_of(to_delayed_work(work),
>   				struct xfs_mount, m_eofblocks_work);
> +
> +	if (!sb_start_write_trylock(mp->m_super))
> +		return;
>   	xfs_icache_free_eofblocks(mp, NULL);
> +	sb_end_write(mp->m_super);
> +
>   	xfs_queue_eofblocks(mp);
>   }
>   
> @@ -938,7 +943,12 @@ xfs_cowblocks_worker(
>   {
>   	struct xfs_mount *mp = container_of(to_delayed_work(work),
>   				struct xfs_mount, m_cowblocks_work);
> +
> +	if (!sb_start_write_trylock(mp->m_super))
> +		return;
>   	xfs_icache_free_cowblocks(mp, NULL);
> +	sb_end_write(mp->m_super);
> +
>   	xfs_queue_cowblocks(mp);
>   }
>   
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index cdfb3cd9a25b..309958186d33 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -2363,7 +2363,10 @@ xfs_file_ioctl(
>   		if (error)
>   			return error;
>   
> -		return xfs_icache_free_eofblocks(mp, &keofb);
> +		sb_start_write(mp->m_super);
> +		error = xfs_icache_free_eofblocks(mp, &keofb);
> +		sb_end_write(mp->m_super);
> +		return error;
>   	}
>   
>   	default:
> 
