Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AFB62E53B
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Nov 2022 20:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbiKQT2c (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Nov 2022 14:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239647AbiKQT2a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Nov 2022 14:28:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12FA9FE3
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 11:28:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5505362236
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 19:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D35DC433D6;
        Thu, 17 Nov 2022 19:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668713306;
        bh=cwacZPi1+0oGD8BBiUOKrHGTrq72XuWcYNWQ6qvkvCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PkAxTSqwweXKXzl8RTncOOUIgqt8U3FbE4cEwP7ZV10X+ZD8B2T74WGWi+oRZytSN
         3rVlDRAX+DM2EoV8xrt83IR9p+oSRqQI1/vuAenvwlwnOTsdJ1G/HpiXvHEU5ALRmv
         JTm9MsaJYPOrHnB3Ys0Tl0znaKtLae4S3RRlokNS2H09IqsWz6ssu02lYkByWhPXFb
         0XPB4nQE/+b9Dt2qjrgv8uZ/mgH2Uy/GrNYea/agbqoEVGtUEzUOTujkhL1id6f63F
         W0TMMqRhTCtigSGWZDa7erUcQyGpPkPrzIDBZMbh6uGtQbEsREwADpTlkfPAlJ5FP3
         gh3rHqvoq/L9w==
Date:   Thu, 17 Nov 2022 11:28:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Guo Xuenan <guoxuenan@huawei.com>
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        jack.qiu@huawei.com, fangwei1@huawei.com, yi.zhang@huawei.com,
        zhengbin13@huawei.com, leo.lilong@huawei.com, zengheng4@huawei.com
Subject: Re: [PATCH v4 2/2] xfs: fix super block buf log item UAF during
 force shutdown
Message-ID: <Y3aLWgGStNPEo2z4@magnolia>
References: <20221117145030.5089-1-guoxuenan@huawei.com>
 <20221117145030.5089-3-guoxuenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117145030.5089-3-guoxuenan@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 17, 2022 at 10:50:30PM +0800, Guo Xuenan wrote:
> xfs log io error will trigger xlog shut down, and end_io worker call
> xlog_state_shutdown_callbacks to unpin and release the buf log item.
> The race condition is that when there are some thread doing transaction
> commit and happened not to be intercepted by xlog_is_shutdown, then,
> these log item will be insert into CIL, when unpin and release these
> buf log item, UAF will occur. BTW, add delay before `xlog_cil_commit`
> can increase recurrence probability.
> 
> The following call graph actually encountered this bad situation.
> fsstress                    io end worker kworker/0:1H-216
> 		             xlog_ioend_work
> 		               ->xlog_force_shutdown
> 		                 ->xlog_state_shutdown_callbacks
> 		             	 ->xlog_cil_process_committed
> 		             	   ->xlog_cil_committed
> 		             	     ->xfs_trans_committed_bulk

Odd switch from ^^^^^^^^^^^^^ spaces to tabs here.

> ->xfs_trans_apply_sb_deltas               ->li_ops->iop_unpin(lip, 1);
>   ->xfs_trans_getsb
>     ->_xfs_trans_bjoin
>       ->xfs_buf_item_init
>         ->if (bip) { return 0;} //relog
> ->xlog_cil_commit
>   ->xlog_cil_insert_items //insert into CIL

Why are we still inserting things into the CIL of a dead log?

>                                             ->xfs_buf_ioend_fail(bp);
>                                               ->xfs_buf_ioend
>                                                 ->xfs_buf_item_done
>                                                   ->xfs_buf_item_relse
>                                                     ->xfs_buf_item_free
> 
> when cil push worker gather percpu cil and insert super block buf log item
> into ctx->log_items then uaf occurs.
> 
> ==================================================================
> BUG: KASAN: use-after-free in xlog_cil_push_work+0x1c8f/0x22f0
> Write of size 8 at addr ffff88801800f3f0 by task kworker/u4:4/105
> 
> CPU: 0 PID: 105 Comm: kworker/u4:4 Tainted: G W
> 6.1.0-rc1-00001-g274115149b42 #136
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> Workqueue: xfs-cil/sda xlog_cil_push_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x4d/0x66
>  print_report+0x171/0x4a6
>  kasan_report+0xb3/0x130
>  xlog_cil_push_work+0x1c8f/0x22f0
>  process_one_work+0x6f9/0xf70
>  worker_thread+0x578/0xf30
>  kthread+0x28c/0x330
>  ret_from_fork+0x1f/0x30
>  </TASK>
> 
> Allocated by task 2145:
>  kasan_save_stack+0x1e/0x40
>  kasan_set_track+0x21/0x30
>  __kasan_slab_alloc+0x54/0x60
>  kmem_cache_alloc+0x14a/0x510
>  xfs_buf_item_init+0x160/0x6d0
>  _xfs_trans_bjoin+0x7f/0x2e0
>  xfs_trans_getsb+0xb6/0x3f0
>  xfs_trans_apply_sb_deltas+0x1f/0x8c0
>  __xfs_trans_commit+0xa25/0xe10
>  xfs_symlink+0xe23/0x1660
>  xfs_vn_symlink+0x157/0x280
>  vfs_symlink+0x491/0x790
>  do_symlinkat+0x128/0x220
>  __x64_sys_symlink+0x7a/0x90
>  do_syscall_64+0x35/0x80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Freed by task 216:
>  kasan_save_stack+0x1e/0x40
>  kasan_set_track+0x21/0x30
>  kasan_save_free_info+0x2a/0x40
>  __kasan_slab_free+0x105/0x1a0
>  kmem_cache_free+0xb6/0x460
>  xfs_buf_ioend+0x1e9/0x11f0
>  xfs_buf_item_unpin+0x3d6/0x840
>  xfs_trans_committed_bulk+0x4c2/0x7c0
>  xlog_cil_committed+0xab6/0xfb0
>  xlog_cil_process_committed+0x117/0x1e0
>  xlog_state_shutdown_callbacks+0x208/0x440
>  xlog_force_shutdown+0x1b3/0x3a0
>  xlog_ioend_work+0xef/0x1d0
>  process_one_work+0x6f9/0xf70
>  worker_thread+0x578/0xf30
>  kthread+0x28c/0x330
>  ret_from_fork+0x1f/0x30
> 
> The buggy address belongs to the object at ffff88801800f388
>  which belongs to the cache xfs_buf_item of size 272
> The buggy address is located 104 bytes inside of
>  272-byte region [ffff88801800f388, ffff88801800f498)
> 
> The buggy address belongs to the physical page:
> page:ffffea0000600380 refcount:1 mapcount:0 mapping:0000000000000000
> index:0xffff88801800f208 pfn:0x1800e
> head:ffffea0000600380 order:1 compound_mapcount:0 compound_pincount:0
> flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
> raw: 001fffff80010200 ffffea0000699788 ffff88801319db50 ffff88800fb50640
> raw: ffff88801800f208 000000000015000a 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff88801800f280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88801800f300: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff88801800f380: fc fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                              ^
>  ffff88801800f400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88801800f480: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
> Disabling lock debugging due to kernel taint
> 
> Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
> ---
>  fs/xfs/xfs_buf_item.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 522d450a94b1..df7322ed73fa 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1018,6 +1018,8 @@ xfs_buf_item_relse(
>  	trace_xfs_buf_item_relse(bp, _RET_IP_);
>  	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
>  
> +	if (atomic_read(&bip->bli_refcount))
> +		return;

If we're releasing the buf item, shouldn't this be an
atomic_dec_and_test or something?

--D

>  	bp->b_log_item = NULL;
>  	xfs_buf_rele(bp);
>  	xfs_buf_item_free(bip);
> -- 
> 2.31.1
> 
