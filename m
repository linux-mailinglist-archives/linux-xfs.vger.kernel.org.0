Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C06E7E476
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 22:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfHAUrK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 16:47:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57842 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbfHAUrK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 16:47:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x71KiJxY146259;
        Thu, 1 Aug 2019 20:46:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=7m5T/vLB1t+aNHQFeBY/f36pyHJQv0hCL2GJUcBjvOA=;
 b=lw2xDy8lfUDHo3C4v8bo1nQzCGlNfQnnbnIWcNUfUwoGvLOP7Mfx74fZNmCuO9/pYa+Q
 a2aIpsdnofNXI4ZSIjddebsfkWZgI4R1gYxRJWKCZe23F2tgxLAx5nfC+pr6CF/+ZlDe
 Tyv0WLCnsjXFUOJQqxhUDTSZQ7sEugDrkVodjZ7U/XD5nItnUG7TGSaJrNd/Qx9jOqCt
 ABNHQ+wBNOCgFbfWzkYRI/XhbmIPoiejWLQLY2/YdFNVkEFWXCOnZm24FbiReV/rirGw
 Gd5zm1/TsJ0B0d7cYj8CWxgRJUs5ZTDKKcutKuRm5iget98YaLjQLRpBvUk7A+Z7d22F rQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u0ejpx6px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 20:46:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x71Kgtgo075323;
        Thu, 1 Aug 2019 20:46:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2u2jp6jrw9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 20:46:55 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x71Kksiq009182;
        Thu, 1 Aug 2019 20:46:54 GMT
Received: from localhost (/10.145.178.162)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Aug 2019 13:46:54 -0700
Date:   Thu, 1 Aug 2019 13:46:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] fs: xfs: xfs_log: Don't use KM_MAYFAIL at
 xfs_log_reserve().
Message-ID: <20190801204651.GE7138@magnolia>
References: <20190729215657.GI7777@dread.disaster.area>
 <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9336 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908010218
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9336 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908010218
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 01, 2019 at 07:06:35PM +0900, Tetsuo Handa wrote:
> When the system is close-to-OOM, fsync() may fail due to -ENOMEM because
> xfs_log_reserve() is using KM_MAYFAIL. It is a bad thing to fail writeback
> operation due to user-triggerable OOM condition. Since we are not using
> KM_MAYFAIL at xfs_trans_alloc() before calling xfs_log_reserve(), let's
> use the same flags at xfs_log_reserve().
> 
>   oom-torture: page allocation failure: order:0, mode:0x46c40(GFP_NOFS|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_COMP), nodemask=(null)
>   CPU: 7 PID: 1662 Comm: oom-torture Kdump: loaded Not tainted 5.3.0-rc2+ #925
>   Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00
>   Call Trace:
>    dump_stack+0x67/0x95
>    warn_alloc+0xa9/0x140
>    __alloc_pages_slowpath+0x9a8/0xbce
>    __alloc_pages_nodemask+0x372/0x3b0
>    alloc_slab_page+0x3a/0x8d0
>    new_slab+0x330/0x420
>    ___slab_alloc.constprop.94+0x879/0xb00
>    __slab_alloc.isra.89.constprop.93+0x43/0x6f
>    kmem_cache_alloc+0x331/0x390
>    kmem_zone_alloc+0x9f/0x110 [xfs]
>    kmem_zone_alloc+0x9f/0x110 [xfs]
>    xlog_ticket_alloc+0x33/0xd0 [xfs]
>    xfs_log_reserve+0xb4/0x410 [xfs]
>    xfs_trans_reserve+0x1d1/0x2b0 [xfs]
>    xfs_trans_alloc+0xc9/0x250 [xfs]
>    xfs_setfilesize_trans_alloc.isra.27+0x44/0xc0 [xfs]
>    xfs_submit_ioend.isra.28+0xa5/0x180 [xfs]
>    xfs_vm_writepages+0x76/0xa0 [xfs]
>    do_writepages+0x17/0x80
>    __filemap_fdatawrite_range+0xc1/0xf0
>    file_write_and_wait_range+0x53/0xa0
>    xfs_file_fsync+0x87/0x290 [xfs]
>    vfs_fsync_range+0x37/0x80
>    do_fsync+0x38/0x60
>    __x64_sys_fsync+0xf/0x20
>    do_syscall_64+0x4a/0x1c0
>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Looks ok...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 00e9f5c388d3..7fc3c1ad36bc 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -429,10 +429,7 @@ xfs_log_reserve(
>  
>  	ASSERT(*ticp == NULL);
>  	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent,
> -				KM_SLEEP | KM_MAYFAIL);
> -	if (!tic)
> -		return -ENOMEM;
> -
> +				KM_SLEEP);
>  	*ticp = tic;
>  
>  	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
> -- 
> 2.16.5
> 
