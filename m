Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9994616F00F
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2020 21:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731763AbgBYU2g (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 15:28:36 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48392 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731753AbgBYU2g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 15:28:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PKRdNu067852;
        Tue, 25 Feb 2020 20:28:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=yjNUY6JNmqI/pXqRDfsd3xZwpU1/jOskG2o2uGjgE5I=;
 b=dfCk58MJh9vaAPQP5W43zpbeNQKctpTJC6YD1tOGeXAAivXMFYr8JAjF54sH5yLpsM2Y
 hDLB6gp2/fhMCUv9JCQwCOz0rUTJk9IoNqRc3FFrU7sNzv0JRAA06fXyr7BQcsj5lLyL
 kJ0U8nRhm7rd8LYetkU+CyX9ZQGzeQ+mPXHFQTIc7my3LmAR9J2MOPPImMnI3sMB9qn2
 dNQ9WhL2OGTB5e5h9WFau/+7vofebpgT89oCvmDWsdS6hcjBwOrAciPKx3UQOk8ptUmX
 RDNtcpmf1PI84LnT7Kgse59nwBLqzV62W9RBjuvzdFyQNAppK54ACQX4DMh2Gvkoyg+0 JQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yd093m2cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 20:28:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01PKS0xR062956;
        Tue, 25 Feb 2020 20:28:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2yd17qs40w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 20:28:31 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01PKSU3B027037;
        Tue, 25 Feb 2020 20:28:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Feb 2020 12:28:30 -0800
Date:   Tue, 25 Feb 2020 12:28:29 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Qian Cai <cai@lca.pw>
Cc:     elver@google.com, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: fix data races in inode->i_*time
Message-ID: <20200225202829.GV6740@magnolia>
References: <1582661385-30210-1-git-send-email-cai@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582661385-30210-1-git-send-email-cai@lca.pw>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=27 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002250143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9542 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 suspectscore=27 priorityscore=1501
 phishscore=0 clxscore=1011 mlxlogscore=999 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250143
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 25, 2020 at 03:09:45PM -0500, Qian Cai wrote:
> inode->i_*time could be accessed concurrently. The plain reads in
> xfs_vn_getattr() is lockless which result in data races. To avoid bad
> compiler optimizations like load tearing, adding pairs of
> READ|WRITE_ONCE(). While at it, also take care of xfs_setattr_time()
> which presumably could run concurrently with xfs_vn_getattr() as well.
> The data races were reported by KCSAN,
> 
>  write to 0xffff9275a1920ad8 of 16 bytes by task 47311 on cpu 46:
>   xfs_vn_update_time+0x1b0/0x400 [xfs]
>   xfs_vn_update_time at fs/xfs/xfs_iops.c:1122
>   update_time+0x57/0x80
>   file_update_time+0x143/0x1f0
>   __xfs_filemap_fault+0x1be/0x3d0 [xfs]
>   xfs_filemap_page_mkwrite+0x25/0x40 [xfs]
>   do_page_mkwrite+0xf7/0x250
>   do_fault+0x679/0x920
>   __handle_mm_fault+0xc9f/0xd40
>   handle_mm_fault+0xfc/0x2f0
>   do_page_fault+0x263/0x6f9
>   page_fault+0x34/0x40
> 
>  4 locks held by doio/47311:
>   #0: ffff9275e7d70808 (&mm->mmap_sem#2){++++}, at: do_page_fault+0x143/0x6f9
>   #1: ffff9274864394d8 (sb_pagefaults){.+.+}, at: __xfs_filemap_fault+0x19b/0x3d0 [xfs]
>   #2: ffff9274864395b8 (sb_internal){.+.+}, at: xfs_trans_alloc+0x2af/0x3c0 [xfs]
>   #3: ffff9275a1920920 (&xfs_nondir_ilock_class){++++}, at: xfs_ilock+0x116/0x2c0 [xfs]
>  irq event stamp: 42649
>  hardirqs last  enabled at (42649): [<ffffffffb22dcdb3>] _raw_spin_unlock_irqrestore+0x53/0x60
>  hardirqs last disabled at (42648): [<ffffffffb22dcad1>] _raw_spin_lock_irqsave+0x21/0x60
>  softirqs last  enabled at (42306): [<ffffffffb260034c>] __do_softirq+0x34c/0x57c
>  softirqs last disabled at (42299): [<ffffffffb18c6762>] irq_exit+0xa2/0xc0
> 
>  read to 0xffff9275a1920ad8 of 16 bytes by task 47312 on cpu 40:
>   xfs_vn_getattr+0x20c/0x6a0 [xfs]
>   xfs_vn_getattr at fs/xfs/xfs_iops.c:551
>   vfs_getattr_nosec+0x11a/0x170
>   vfs_statx_fd+0x54/0x90
>   __do_sys_newfstat+0x40/0x90
>   __x64_sys_newfstat+0x3a/0x50
>   do_syscall_64+0x91/0xb05
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
>  no locks held by doio/47312.
>  irq event stamp: 43883
>  hardirqs last  enabled at (43883): [<ffffffffb1805119>] do_syscall_64+0x39/0xb05
>  hardirqs last disabled at (43882): [<ffffffffb1803ede>] trace_hardirqs_off_thunk+0x1a/0x1c
>  softirqs last  enabled at (43844): [<ffffffffb260034c>] __do_softirq+0x34c/0x57c
>  softirqs last disabled at (43141): [<ffffffffb18c6762>] irq_exit+0xa2/0xc0
> 
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  fs/xfs/xfs_iops.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 81f2f93caec0..2d5ca13ee9da 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -547,9 +547,9 @@
>  	stat->uid = inode->i_uid;
>  	stat->gid = inode->i_gid;
>  	stat->ino = ip->i_ino;
> -	stat->atime = inode->i_atime;
> -	stat->mtime = inode->i_mtime;
> -	stat->ctime = inode->i_ctime;
> +	stat->atime = READ_ONCE(inode->i_atime);
> +	stat->mtime = READ_ONCE(inode->i_mtime);
> +	stat->ctime = READ_ONCE(inode->i_ctime);

Seeing as one is supposed to take ILOCK_SHARED before reading inode core
information, why don't we do that here?  Is there some huge performance
benefit to be realized from READ_ONCE vs. waiting for the lock that
protects all the writes from each other?

--D

>  	stat->blocks =
>  		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
>  
> @@ -614,11 +614,11 @@
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  
>  	if (iattr->ia_valid & ATTR_ATIME)
> -		inode->i_atime = iattr->ia_atime;
> +		WRITE_ONCE(inode->i_atime, iattr->ia_atime);
>  	if (iattr->ia_valid & ATTR_CTIME)
> -		inode->i_ctime = iattr->ia_ctime;
> +		WRITE_ONCE(inode->i_ctime, iattr->ia_ctime);
>  	if (iattr->ia_valid & ATTR_MTIME)
> -		inode->i_mtime = iattr->ia_mtime;
> +		WRITE_ONCE(inode->i_mtime, iattr->ia_mtime);
>  }
>  
>  static int
> @@ -1117,11 +1117,11 @@
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	if (flags & S_CTIME)
> -		inode->i_ctime = *now;
> +		WRITE_ONCE(inode->i_ctime, *now);
>  	if (flags & S_MTIME)
> -		inode->i_mtime = *now;
> +		WRITE_ONCE(inode->i_mtime, *now);
>  	if (flags & S_ATIME)
> -		inode->i_atime = *now;
> +		WRITE_ONCE(inode->i_atime, *now);
>  
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  	xfs_trans_log_inode(tp, ip, log_flags);
> -- 
> 1.8.3.1
> 
