Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62127573BA7
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Jul 2022 19:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiGMRBS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Jul 2022 13:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiGMRBR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jul 2022 13:01:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D265424BF4
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 10:01:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 674E661CC4
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jul 2022 17:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95E9C3411E;
        Wed, 13 Jul 2022 17:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657731675;
        bh=Pet1b66jZa2/dh6/eFOVjznlgDg/wbBN42tyeLGpgIs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ClL8jXDRo1p50R21I7k0SsuXvWXpx2ugHrPwpw65fMQQrVyF4FsJpE8RAgmQpO+ud
         yZ2pl30mWMVZ9+MeJcHz18ZYF/BYqSnlmxZ+Ev0BcVU0tyhTG/a0TFlMazyd7z0iAI
         mjTLuuRN8kLgrCCc6zhYUIPU9wXf3rdqVj45t//iOqPnm/9W+WLG4sR2FDz9sog6R3
         Uhs4Wg4v9EorM+Dj8I41rGdNDn/coYVS4hWYfw0jx3idd6QP9hZML68ZHA+CU3cPgY
         FmQHk0sAHKMk7okGHqxHQsh3iH1e+6lGCLQ61QYe3ih9CfSaBG0d2zJCkeuDXv3NMy
         hmaJbDSw/XpXQ==
Date:   Wed, 13 Jul 2022 10:01:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/6 v3] xfs: lockless buffer lookups
Message-ID: <Ys76W8V72KJmXN+B@magnolia>
References: <20220707235259.1097443-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707235259.1097443-1-david@fromorbit.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 09:52:53AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> Current work to merge the XFS inode life cycle with the VFS indoe
> life cycle is finding some interesting issues. If we have a path
> that hits buffer trylocks fairly hard (e.g. a non-blocking
> background inode freeing function), we end up hitting massive
> contention on the buffer cache hash locks:

Hmm.  I applied this to a test branch and this fell out of xfs/436 when
it runs rmmod xfs.  I'll see if I can reproduce it more regularly, but
thought I'd put this out there early...

XFS (sda3): Unmounting Filesystem
=============================================================================
BUG xfs_buf (Not tainted): Objects remaining in xfs_buf on __kmem_cache_shutdown()
-----------------------------------------------------------------------------

Slab 0xffffea000443b780 objects=18 used=4 fp=0xffff888110edf340 flags=0x17ff80000010200(slab|head|node=0|zone=2|lastcpupid=0xfff)
CPU: 3 PID: 30378 Comm: modprobe Not tainted 5.19.0-rc5-djwx #rc5 bebda13a030d0898279476b6652ddea67c2060cc
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20171121_152543-x86-ol7-builder-01.us.oracle.com-4.el7.1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 slab_err+0x95/0xc9
 __kmem_cache_shutdown.cold+0x39/0x1e9
 kmem_cache_destroy+0x49/0x130
 exit_xfs_fs+0x50/0xc57 [xfs 370e1c994a59de083c05cd4df389f629878b8122]
 __do_sys_delete_module.constprop.0+0x145/0x220
 ? exit_to_user_mode_prepare+0x6c/0x100
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fe7d7877c9b
Code: 73 01 c3 48 8b 0d 95 21 0f 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 65 21 0f 00 f7 d8 64 89 01 48
RSP: 002b:00007fffb911cab8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
RAX: ffffffffffffffda RBX: 0000555a217adcc0 RCX: 00007fe7d7877c9b
RDX: 0000000000000000 RSI: 0000000000000800 RDI: 0000555a217add28
RBP: 0000555a217adcc0 R08: 0000000000000000 R09: 0000000000000000
R10: 00007fe7d790fac0 R11: 0000000000000206 R12: 0000555a217add28
R13: 0000000000000000 R14: 0000555a217add28 R15: 00007fffb911ede8
 </TASK>
Disabling lock debugging due to kernel taint
Object 0xffff888110ede000 @offset=0
Object 0xffff888110ede1c0 @offset=448
Object 0xffff888110edefc0 @offset=4032
Object 0xffff888110edf6c0 @offset=5824

--D

> -   92.71%     0.05%  [kernel]                  [k] xfs_inodegc_worker
>    - 92.67% xfs_inodegc_worker
>       - 92.13% xfs_inode_unlink
>          - 91.52% xfs_inactive_ifree
>             - 85.63% xfs_read_agi
>                - 85.61% xfs_trans_read_buf_map
>                   - 85.59% xfs_buf_read_map
>                      - xfs_buf_get_map
>                         - 85.55% xfs_buf_find
>                            - 72.87% _raw_spin_lock
>                               - do_raw_spin_lock
>                                    71.86% __pv_queued_spin_lock_slowpath
>                            - 8.74% xfs_buf_rele
>                               - 7.88% _raw_spin_lock
>                                  - 7.88% do_raw_spin_lock
>                                       7.63% __pv_queued_spin_lock_slowpath
>                            - 1.70% xfs_buf_trylock
>                               - 1.68% down_trylock
>                                  - 1.41% _raw_spin_lock_irqsave
>                                     - 1.39% do_raw_spin_lock
>                                          __pv_queued_spin_lock_slowpath
>                            - 0.76% _raw_spin_unlock
>                                 0.75% do_raw_spin_unlock
> 
> This is basically hammering the pag->pag_buf_lock from lots of CPUs
> doing trylocks at the same time. Most of the buffer trylock
> operations ultimately fail after we've done the lookup, so we're
> really hammering the buf hash lock whilst making no progress.
> 
> We can also see significant spinlock traffic on the same lock just
> under normal operation when lots of tasks are accessing metadata
> from the same AG, so let's avoid all this by creating a lookup fast
> path which leverages the rhashtable's ability to do rcu protected
> lookups.
> 
> This is a rework of the initial lockless buffer lookup patch I sent
> here:
> 
> https://lore.kernel.org/linux-xfs/20220328213810.1174688-1-david@fromorbit.com/
> 
> And the alternative cleanup sent by Christoph here:
> 
> https://lore.kernel.org/linux-xfs/20220403120119.235457-1-hch@lst.de/
> 
> This version isn't quite a short as Christophs, but it does roughly
> the same thing in killing the two-phase _xfs_buf_find() call
> mechanism. It separates the fast and slow paths a little more
> cleanly and doesn't have context dependent buffer return state from
> the slow path that the caller needs to handle. It also picks up the
> rhashtable insert optimisation that Christoph added.
> 
> This series passes fstests under several different configs and does
> not cause any obvious regressions in scalability testing that has
> been performed. Hence I'm proposing this as potential 5.20 cycle
> material.
> 
> Thoughts, comments?
> 
> Version 3:
> - rebased onto linux-xfs/for-next
> - rearranged some of the changes to avoid repeated shuffling of code
>   to different locations
> - fixed typos in commits
> - s/xfs_buf_find_verify/xfs_buf_map_verify/
> - s/xfs_buf_find_fast/xfs_buf_lookup/
> 
> Version 2:
> - https://lore.kernel.org/linux-xfs/20220627060841.244226-1-david@fromorbit.com/
> - based on 5.19-rc2
> - high speed collision of original proposals.
> 
> Initial versions:
> - https://lore.kernel.org/linux-xfs/20220403120119.235457-1-hch@lst.de/
> - https://lore.kernel.org/linux-xfs/20220328213810.1174688-1-david@fromorbit.com/
> 
> 
