Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B5E7D9B5
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 12:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfHAK4c (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 06:56:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbfHAK4b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Aug 2019 06:56:31 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9606830C0DDA;
        Thu,  1 Aug 2019 10:56:31 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A7D960BE0;
        Thu,  1 Aug 2019 10:56:31 +0000 (UTC)
Date:   Thu, 1 Aug 2019 06:56:29 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs: xfs: xfs_log: Don't use KM_MAYFAIL at
 xfs_log_reserve().
Message-ID: <20190801105629.GA60054@bfoster>
References: <20190729215657.GI7777@dread.disaster.area>
 <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Thu, 01 Aug 2019 10:56:31 +0000 (UTC)
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
> ---

I assume this survived your test scenario?

If so, the change looks fine to me. Thanks for the patch.

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
