Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA8687E47B
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 22:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbfHAUsc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 16:48:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42360 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbfHAUsb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 16:48:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x71KhvE8065804;
        Thu, 1 Aug 2019 20:48:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=W0RNYs3oTpNuA8Irdq4SSYzGqxO/zyqVUu8ynDlhMFk=;
 b=en9Wby9zwpD0WIzUUzgEdgjEh/yFjOasbu+ZnQ8R4wS+R5n01Om0DKyLJwmO0fAPNkU4
 Ld8DHIhuMW0TxgJJkZqeCm8+Zs2QKZ/4kN0ecEOr6DxFBYmrwV1H6jp6+fVkvpxUdx4N
 rZATRx+nFKH/EVcJ6hlWXGL45wbrgesJgrb19qIFIsG7s2V0BkCy0RJlIvIMp9/J5spU
 IHGaExXBZUcNW00sPnm/kvinXF/e9yGYrJQ/7HZsTMmXizRVeK8XkibgI9N2tA4fz7vn
 0omOOBmq0IYYwCyqCS99vkeqG8BpTbfTYNlmsJRwH1cydJcY77iQ+YFDyxhdUIJqW93t yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2u0e1u6duh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 20:48:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x71KgtOI103784;
        Thu, 1 Aug 2019 20:46:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2u3mbura66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 20:46:20 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x71KkIUC018174;
        Thu, 1 Aug 2019 20:46:18 GMT
Received: from localhost (/10.145.178.162)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Aug 2019 13:46:18 -0700
Date:   Thu, 1 Aug 2019 13:46:14 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] fs: xfs: xfs_log: Don't use KM_MAYFAIL at
 xfs_log_reserve().
Message-ID: <20190801204614.GD7138@magnolia>
References: <20190729215657.GI7777@dread.disaster.area>
 <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801185057.GT30113@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801185057.GT30113@42.do-not-panic.com>
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

On Thu, Aug 01, 2019 at 06:50:57PM +0000, Luis Chamberlain wrote:
> On Thu, Aug 01, 2019 at 07:06:35PM +0900, Tetsuo Handa wrote:
> > When the system is close-to-OOM, fsync() may fail due to -ENOMEM because
> > xfs_log_reserve() is using KM_MAYFAIL. It is a bad thing to fail writeback
> > operation due to user-triggerable OOM condition. Since we are not using
> > KM_MAYFAIL at xfs_trans_alloc() before calling xfs_log_reserve(), let's
> > use the same flags at xfs_log_reserve().
> > 
> >   oom-torture: page allocation failure: order:0, mode:0x46c40(GFP_NOFS|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_COMP), nodemask=(null)
> >   CPU: 7 PID: 1662 Comm: oom-torture Kdump: loaded Not tainted 5.3.0-rc2+ #925
> >   Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00
> >   Call Trace:
> >    dump_stack+0x67/0x95
> >    warn_alloc+0xa9/0x140
> >    __alloc_pages_slowpath+0x9a8/0xbce
> >    __alloc_pages_nodemask+0x372/0x3b0
> >    alloc_slab_page+0x3a/0x8d0
> >    new_slab+0x330/0x420
> >    ___slab_alloc.constprop.94+0x879/0xb00
> >    __slab_alloc.isra.89.constprop.93+0x43/0x6f
> >    kmem_cache_alloc+0x331/0x390
> >    kmem_zone_alloc+0x9f/0x110 [xfs]
> >    kmem_zone_alloc+0x9f/0x110 [xfs]
> >    xlog_ticket_alloc+0x33/0xd0 [xfs]
> >    xfs_log_reserve+0xb4/0x410 [xfs]
> >    xfs_trans_reserve+0x1d1/0x2b0 [xfs]
> >    xfs_trans_alloc+0xc9/0x250 [xfs]
> >    xfs_setfilesize_trans_alloc.isra.27+0x44/0xc0 [xfs]
> >    xfs_submit_ioend.isra.28+0xa5/0x180 [xfs]
> >    xfs_vm_writepages+0x76/0xa0 [xfs]
> >    do_writepages+0x17/0x80
> >    __filemap_fdatawrite_range+0xc1/0xf0
> >    file_write_and_wait_range+0x53/0xa0
> >    xfs_file_fsync+0x87/0x290 [xfs]
> >    vfs_fsync_range+0x37/0x80
> >    do_fsync+0x38/0x60
> >    __x64_sys_fsync+0xf/0x20
> >    do_syscall_64+0x4a/0x1c0
> >    entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > 
> > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> That's quite an opaque commit log for what started off as a severe email
> thread of potential leak of information. As such, can you expand on this
> commit log considerably to explain the situation a bit better?

I'm pretty sure this didn't solve the underlying stale data exposure
problem, which might be why you think this is "opaque".  It fixes a bug
that causes data writeback failure (which was the exposure vector this
time) but I think the ultimate fix for the exposure problem are the two
patches I linked to quite a ways back in this discussion....

--D

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=bd012b434a56d9fac3cbc33062b8e2cd6e1ad0a0
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?id=adcf7c0c87191fd3616813c8ce9790f89a9a8eba


> Your
> initial thread here provided much clearer evidence of the issue. As-is
> this commit log tells the reader *nothing* about the potential harm in
> not applying this patch.
> 
> You had mentioned you identified this issue present on at least
> 4.18 till 5.3-rc1. So, I'm at least inclined to consider this for
> stable for at least v4.19.
> 
> However, what about older kernels? Now that you have identified
> a fix, were the flag changed in prior commits, is it a regression
> that perhaps added KM_MAYFAIL at some point?
> 
>   Luis
