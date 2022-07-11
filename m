Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C50562409
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Jun 2022 22:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237235AbiF3USP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 30 Jun 2022 16:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiF3USO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jun 2022 16:18:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFA32B5
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 13:18:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6E1FB82B5B
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 20:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D61BC341D0
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 20:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656620290;
        bh=qL4BAMvQnscJx2HVyJSCbyQnp/5G4JIBClzgUwH7/JM=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=ukdtY8rNKWzsELAgB4CZitwGtIDOAv1GXF/O4lqoeUTpI/OE/gGL2KDyiafzCgG4Z
         r6IDA4ekLg4XwA4RXc+XEjSCGahmQDpsi/pHdvwDd0MUdXWBTxHVe4D5W0ivALFyG0
         RsiipaK/f5f7oygNoapxqRYI59dx4V1EAJJmFccsXP0RnjYsW0pZj5zEsVTk8pQSMZ
         SjrMm992zsm/WdngeyTa5MXXJ3gA9VQzXfaKQVSMqc2hR7C+JilL1wJKpNQeGbO63t
         f205fzyUyIS3U7eroQHhofY3OhTKZ/MhnLqAhrB6Uot6OT8fUutNKl7ICa4Zs7C/UG
         VbDNL79kW1nwg==
Date:   Thu, 30 Jun 2022 13:18:10 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: KASAN report while running generic/475?
Message-ID: <Yr4FAt6oJfrdsMBQ@magnolia>
References: <YrzyfMZg4UcIACC8@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrzyfMZg4UcIACC8@magnolia>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 05:46:52PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> I turned on KASAN and my test rig tripped over generic/475.  I've not
> added Dave's log scalability patchset to my test systems yet, so I know
> that's /not/ to blame.  I'll take a further look in the morning, but if
> this looks familiar to anyone, let me know?
> 
> (Yes, this is djwong-dev, but I don't have any log changes in my
> development tree right now...)

Aha, I think there's a race between the ioend worker shutting down the
log, and log unmount freeing the CIL.  Patches soon.

--D

> --D
> 
>  XFS (dm-0): Mounting V5 Filesystem
>  XFS (dm-0): Starting recovery (logdev: internal)
>  XFS (dm-0): Ending recovery (logdev: internal)
>  Buffer I/O error on dev dm-0, logical block 20639616, async page read
>  Buffer I/O error on dev dm-0, logical block 20639617, async page read
>  XFS (dm-0): log I/O error -5
>  XFS (dm-0): Filesystem has been shut down due to log error (0x2).
>  XFS (dm-0): Unmounting Filesystem
>  XFS (dm-0): Please unmount the filesystem and rectify the problem(s).
>  ==================================================================
>  BUG: KASAN: use-after-free in do_raw_spin_lock+0x246/0x270
>  Read of size 4 at addr ffff888109dd84c4 by task 3:1H/136
>  
>  CPU: 3 PID: 136 Comm: 3:1H Not tainted 5.19.0-rc4-xfsx #rc4 8e53ab5ad0fddeb31cee5e7063ff9c361915a9c4
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
>  Workqueue: xfs-log/dm-0 xlog_ioend_work [xfs]
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x34/0x44
>   print_report.cold+0x2b8/0x661
>   ? do_raw_spin_lock+0x246/0x270
>   kasan_report+0xab/0x120
>   ? do_raw_spin_lock+0x246/0x270
>   do_raw_spin_lock+0x246/0x270
>   ? rwlock_bug.part.0+0x90/0x90
>   xlog_force_shutdown+0xf6/0x370 [xfs 4ad76ae0d6add7e8183a553e624c31e9ed567318]
>   xlog_ioend_work+0x100/0x190 [xfs 4ad76ae0d6add7e8183a553e624c31e9ed567318]
>   process_one_work+0x672/0x1040
>   worker_thread+0x59b/0xec0
>   ? __kthread_parkme+0xc6/0x1f0
>   ? process_one_work+0x1040/0x1040
>   ? process_one_work+0x1040/0x1040
>   kthread+0x29e/0x340
>   ? kthread_complete_and_exit+0x20/0x20
>   ret_from_fork+0x1f/0x30
>   </TASK>
>  
>  Allocated by task 154099:
>   kasan_save_stack+0x1e/0x40
>   __kasan_kmalloc+0x81/0xa0
>   kmem_alloc+0x8d/0x2e0 [xfs]
>   xlog_cil_init+0x1f/0x540 [xfs]
>   xlog_alloc_log+0xd1e/0x1260 [xfs]
>   xfs_log_mount+0xba/0x640 [xfs]
>   xfs_mountfs+0xf2b/0x1d00 [xfs]
>   xfs_fs_fill_super+0x10af/0x1910 [xfs]
>   get_tree_bdev+0x383/0x670
>   vfs_get_tree+0x7d/0x240
>   path_mount+0xdb7/0x1890
>   __x64_sys_mount+0x1fa/0x270
>   do_syscall_64+0x2b/0x80
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
>  
>  Freed by task 154151:
>   kasan_save_stack+0x1e/0x40
>   kasan_set_track+0x21/0x30
>   kasan_set_free_info+0x20/0x30
>   ____kasan_slab_free+0x110/0x190
>   slab_free_freelist_hook+0xab/0x180
>   kfree+0xbc/0x310
>   xlog_dealloc_log+0x1b/0x2b0 [xfs]
>   xfs_unmountfs+0x119/0x200 [xfs]
>   xfs_fs_put_super+0x6e/0x2e0 [xfs]
>   generic_shutdown_super+0x12b/0x3a0
>   kill_block_super+0x95/0xd0
>   deactivate_locked_super+0x80/0x130
>   cleanup_mnt+0x329/0x4d0
>   task_work_run+0xc5/0x160
>   exit_to_user_mode_prepare+0xd4/0xe0
>   syscall_exit_to_user_mode+0x1d/0x40
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
>  
>  Last potentially related work creation:
>   kasan_save_stack+0x1e/0x40
>   __kasan_record_aux_stack+0x9f/0xb0
>   call_rcu+0x6f/0x700
>   xfs_destroy_mount_workqueues+0x37/0x150 [xfs]
>   xfs_fs_put_super+0x201/0x2e0 [xfs]
>   generic_shutdown_super+0x12b/0x3a0
>   kill_block_super+0x95/0xd0
>   deactivate_locked_super+0x80/0x130
>   cleanup_mnt+0x329/0x4d0
>   task_work_run+0xc5/0x160
>   exit_to_user_mode_prepare+0xd4/0xe0
>   syscall_exit_to_user_mode+0x1d/0x40
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
>  
>  Second to last potentially related work creation:
>   kasan_save_stack+0x1e/0x40
>   __kasan_record_aux_stack+0x9f/0xb0
>   call_rcu+0x6f/0x700
>   xfs_destroy_mount_workqueues+0x93/0x150 [xfs]
>   xfs_fs_put_super+0x201/0x2e0 [xfs]
>   generic_shutdown_super+0x12b/0x3a0
>   kill_block_super+0x95/0xd0
>   deactivate_locked_super+0x80/0x130
>   cleanup_mnt+0x329/0x4d0
>   task_work_run+0xc5/0x160
>   exit_to_user_mode_prepare+0xd4/0xe0
>   syscall_exit_to_user_mode+0x1d/0x40
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
>  
>  The buggy address belongs to the object at ffff888109dd8400
>   which belongs to the cache kmalloc-512 of size 512
>  The buggy address is located 196 bytes inside of
>   512-byte region [ffff888109dd8400, ffff888109dd8600)
>  
>  The buggy address belongs to the physical page:
>  page:ffffea0004277600 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x109dd8
>  head:ffffea0004277600 order:2 compound_mapcount:0 compound_pincount:0
>  flags: 0x17ff80000010200(slab|head|node=0|zone=2|lastcpupid=0xfff)
>  raw: 017ff80000010200 ffffea00043cba00 dead000000000002 ffff888100042c80
>  raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
>  page dumped because: kasan: bad access detected
>  
>  Memory state around the buggy address:
>   ffff888109dd8380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff888109dd8400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  >ffff888109dd8480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                             ^
>   ffff888109dd8500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff888109dd8580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ==================================================================
>  Disabling lock debugging due to kernel taint
