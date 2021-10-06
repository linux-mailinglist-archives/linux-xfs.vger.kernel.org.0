Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE93424187
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Oct 2021 17:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhJFPpU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 Oct 2021 11:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230014AbhJFPpU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Oct 2021 11:45:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01968610A3;
        Wed,  6 Oct 2021 15:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633535008;
        bh=zWnL9twWsIqYKy9gtnL/WvZ4r8lMHO0PHEaiqZncMDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SRg7qaDA9OZhAqaEFcU7OKFV7YjB8VALAnMgLnZs5r2Ko8Fsb2xzGqDlnHZ4jhBhQ
         n3LSfGnH+TQI33HEFt/uaR7cFOrnrKvbe2pNDEA6vJHcyJP0w+oi/Elm52Mpbeq1Vw
         W9LD1XVJDmUeXLhT9ZrT2Y85AEhhYc3eZiLAfbR0UrRwWZdeIww5qqiDLHM4dvkvOs
         A7Jf3NxFSHJQmkw3YLrztkOba+U2wFoGwEFqkYi7vjw0kTU5sak8dLf4j917rVFZ2B
         Ixd+2IAxlWTgqX7S1dHk+nCcX7xrKHATrvWcyhA8vjJ+aKjv4GeUFHsX+xvenWImrl
         KCxcP48o9HrNQ==
Date:   Wed, 6 Oct 2021 08:43:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Hao Sun <sunhao.th@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-xfs@vger.kernel.org
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 xlog_cil_commit
Message-ID: <20211006154327.GH24307@magnolia>
References: <CACkBjsbaCmZK2wUExMqu_KKBr2jnEi-T6iEr=vzw4YS5g5DOOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACkBjsbaCmZK2wUExMqu_KKBr2jnEi-T6iEr=vzw4YS5g5DOOQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 06, 2021 at 04:14:43PM +0800, Hao Sun wrote:
> Hello,
> 
> When using Healer to fuzz the latest Linux kernel, the following crash
> was triggered.
> 
> HEAD commit: 0513e464f900 Merge tag 'perf-tools-fixes-for-v5.15-2021-09-27'
> git tree: upstream
> console output:
> https://drive.google.com/file/d/1vm5fDM220kkghoiGa3Aw_Prl4O_pqAXF/view?usp=sharing
> kernel config: https://drive.google.com/file/d/1Jqhc4DpCVE8X7d-XBdQnrMoQzifTG5ho/view?usp=sharing
> 
> Sorry, I don't have a reproducer for this crash, hope the symbolized
> report can help.
> If you fix this issue, please add the following tag to the commit:
> Reported-by: Hao Sun <sunhao.th@gmail.com>

So figure out how to fix the problem and send a patch.  You don't get to
hand out fixit tasks like you're some kind of manager for people you
don't employ.

--D

> 
> FAULT_INJECTION: forcing a failure.
> name failslab, interval 1, probability 0, space 0, times 0
> CPU: 1 PID: 28965 Comm: syz-executor Not tainted 5.15.0-rc3+ #21
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> Call Trace:
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x8d/0xcf lib/dump_stack.c:106
>  fail_dump lib/fault-inject.c:52 [inline]
>  should_fail+0x13c/0x160 lib/fault-inject.c:146
>  should_failslab+0x5/0x10 mm/slab_common.c:1328
>  slab_pre_alloc_hook.constprop.99+0x4e/0xc0 mm/slab.h:494
>  slab_alloc_node mm/slub.c:3120 [inline]
>  __kmalloc_node+0x6b/0x240 mm/slub.c:4435
>  kmalloc_node include/linux/slab.h:614 [inline]
>  kvmalloc_node+0x33/0xe0 mm/util.c:587
>  kvmalloc include/linux/mm.h:805 [inline]
>  xlog_cil_alloc_shadow_bufs fs/xfs/xfs_log_cil.c:224 [inline]
>  xlog_cil_commit+0x181/0xe20 fs/xfs/xfs_log_cil.c:1280
>  __xfs_trans_commit+0x239/0x5a0 fs/xfs/xfs_trans.c:881
>  xfs_create+0x80b/0x900 fs/xfs/xfs_inode.c:1091
>  xfs_generic_create+0x16c/0x470 fs/xfs/xfs_iops.c:197
>  lookup_open+0x660/0x780 fs/namei.c:3282
>  open_last_lookups fs/namei.c:3352 [inline]
>  path_openat+0x465/0xe20 fs/namei.c:3557
>  do_filp_open+0xe3/0x170 fs/namei.c:3588
>  do_sys_openat2+0x357/0x4a0 fs/open.c:1200
>  do_sys_open+0x87/0xd0 fs/open.c:1216
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x34/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x46ae99
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f847c2eec48 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
> RAX: ffffffffffffffda RBX: 000000000078c158 RCX: 000000000046ae99
> RDX: 0000000000000000 RSI: 0000000000000021 RDI: 00000000200b5040
> RBP: 00007f847c2eec80 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000c
> R13: 0000000000000000 R14: 000000000078c158 R15: 00007ffd4ca99420
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0002) - not-present page
> PGD 10a56e067 P4D 10a56e067 PUD 10e1e3067 PMD 0
> Oops: 0002 [#1] PREEMPT SMP
> CPU: 0 PID: 28965 Comm: syz-executor Not tainted 5.15.0-rc3+ #21
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> RIP: 0010:memset_erms+0x9/0x10 arch/x86/lib/memset_64.S:64
> Code: c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6
> f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa
> 4c 89 c8 c3 90 49 89 fa 40 0f b6 ce 48 b8 01 01 01 01 01 01
> RSP: 0018:ffffc9000efab998 EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffff88810fa73198 RCX: 0000000000000058
> RDX: 0000000000000058 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff888110c00108 R08: 0000000000000cc0 R09: 0000000000000000
> R10: ffffffff81499943 R11: 0000000000000005 R12: 0000000000000210
> R13: 0000000000000000 R14: 0000000000000268 R15: 0000000000000000
> FS:  00007f847c2ef700(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000010c42b000 CR4: 0000000000750ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> PKRU: 55555554
> Call Trace:
>  memset include/linux/fortify-string.h:175 [inline]
>  xlog_cil_alloc_shadow_bufs fs/xfs/xfs_log_cil.c:225 [inline]
>  xlog_cil_commit+0x1a1/0xe20 fs/xfs/xfs_log_cil.c:1280
>  __xfs_trans_commit+0x239/0x5a0 fs/xfs/xfs_trans.c:881
>  xfs_create+0x80b/0x900 fs/xfs/xfs_inode.c:1091
>  xfs_generic_create+0x16c/0x470 fs/xfs/xfs_iops.c:197
>  lookup_open+0x660/0x780 fs/namei.c:3282
>  open_last_lookups fs/namei.c:3352 [inline]
>  path_openat+0x465/0xe20 fs/namei.c:3557
>  do_filp_open+0xe3/0x170 fs/namei.c:3588
>  do_sys_openat2+0x357/0x4a0 fs/open.c:1200
>  do_sys_open+0x87/0xd0 fs/open.c:1216
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x34/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x46ae99
> Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f847c2eec48 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
> RAX: ffffffffffffffda RBX: 000000000078c158 RCX: 000000000046ae99
> RDX: 0000000000000000 RSI: 0000000000000021 RDI: 00000000200b5040
> RBP: 00007f847c2eec80 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000000c
> R13: 0000000000000000 R14: 000000000078c158 R15: 00007ffd4ca99420
> Modules linked in:
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> CR2: 0000000000000000
> ---[ end trace 1d10d5c699ef1895 ]---
> RIP: 0010:memset_erms+0x9/0x10 arch/x86/lib/memset_64.S:64
> Code: c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6
> f3 48 ab 89 d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 <f3> aa
> 4c 89 c8 c3 90 49 89 fa 40 0f b6 ce 48 b8 01 01 01 01 01 01
> RSP: 0018:ffffc9000efab998 EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffff88810fa73198 RCX: 0000000000000058
> RDX: 0000000000000058 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff888110c00108 R08: 0000000000000cc0 R09: 0000000000000000
> R10: ffffffff81499943 R11: 0000000000000005 R12: 0000000000000210
> R13: 0000000000000000 R14: 0000000000000268 R15: 0000000000000000
> FS:  00007f847c2ef700(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000010c42b000 CR4: 0000000000750ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
> PKRU: 55555554
> ----------------
> Code disassembly (best guess):
>    0: c1 e9 03              shr    $0x3,%ecx
>    3: 40 0f b6 f6          movzbl %sil,%esi
>    7: 48 b8 01 01 01 01 01 movabs $0x101010101010101,%rax
>    e: 01 01 01
>   11: 48 0f af c6          imul   %rsi,%rax
>   15: f3 48 ab              rep stos %rax,%es:(%rdi)
>   18: 89 d1                mov    %edx,%ecx
>   1a: f3 aa                rep stos %al,%es:(%rdi)
>   1c: 4c 89 c8              mov    %r9,%rax
>   1f: c3                    retq
>   20: 90                    nop
>   21: 49 89 f9              mov    %rdi,%r9
>   24: 40 88 f0              mov    %sil,%al
>   27: 48 89 d1              mov    %rdx,%rcx
> * 2a: f3 aa                rep stos %al,%es:(%rdi) <-- trapping instruction
>   2c: 4c 89 c8              mov    %r9,%rax
>   2f: c3                    retq
>   30: 90                    nop
>   31: 49 89 fa              mov    %rdi,%r10
>   34: 40 0f b6 ce          movzbl %sil,%ecx
>   38: 48                    rex.W
>   39: b8 01 01 01 01        mov    $0x1010101,%eax
>   3e: 01 01                add    %eax,(%rcx)
