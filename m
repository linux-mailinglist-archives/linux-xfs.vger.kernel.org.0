Return-Path: <linux-xfs+bounces-5046-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 443F287BA6B
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Mar 2024 10:31:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AEFF8B216FD
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Mar 2024 09:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D426CDC1;
	Thu, 14 Mar 2024 09:31:26 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F416CDB3
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 09:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710408686; cv=none; b=pBMOJX+SQZtK4zBX55w7OA3V0FbIALZox0M0A+6HfBUvaFjuIWgAc4QDnWEQCfd/ucBNrQZf8L/PxehdIla1bKdoTmR4P54gPFcIom2R93lllt0m9emNU31UuqqUtYdW472nE9W51mUFSEepXy+RyT/u1SNqGrJ2hseZGK73H6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710408686; c=relaxed/simple;
	bh=tctNCO0iNDPBNbbPZV7XQSOjqTpL4C0GDrvGQioh7WQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=C4zs4Dwpzw8QHpHMEEB36LFxMmbXJdn4etKjJzHcVIt6x496w7WG1cYTl0dgHNVRvcqKSuRfwgX5xHPBQ+dlgLzYC/Q26wmuGgsoLllKp27bhEYDgih0zDdnW1yVAgWvMk1NxYy7B7T9dva4FygeiArtSZmCk66ohBd/+liUGsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7c8a82e5f70so59711439f.0
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 02:31:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710408684; x=1711013484;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UyOGv0mDGqitQD3NP/hm9ku/8l83Ts1p+Vr5MaZs2Ug=;
        b=vi8rzC185P+uNcU0NfWhMCBRSe7W02tILoWYS4IfvXDrMbLiBJQ9uD1Di6CQSfxsU1
         pj1RnJEY4IdiN3Cqg73d1ULfJf3gDvvw9gVXiwmJ7MvXWAAGlMupZq0BgsP60WIZ9kcF
         FvvPiw9i3Z5Gwma9lIRz0f9H6XDa7q5SLLyZzlL3msH11DhlFh3QztLDtWB1Z5GORKs8
         Qazskg3cBGgUg75Yzm4MimPqwMsnne198STiOJjZ1RxGc1GT+B+UbXfcf0o0KBxR6cVi
         bG5mYnbc0gFtGE4uljGSE74AKNzdAAI9x6Sqg9iZmnKLQ53vIYXBjZkSHvRgSIstQhYw
         Nv5w==
X-Forwarded-Encrypted: i=1; AJvYcCXhhsmi7+CS5TIW8/SrjKRdUQwf+RxAwlkRGNK9I2d1dq8hyU9qmYVYRRvinrSQjOzAWCnO/vrMzzpIIIZ8XdgoSks5Bo0AwL7P
X-Gm-Message-State: AOJu0YxQsmRNL9e2CL1unq/fnouAxqiJ/oTFLxOhyXh+AuzYs953c0hR
	D71DrCB+1GHaaxxxa3KlamKI3cHVxHLz2m1p6v9xzBm1wweCTe3vNixAbcWzlVeUR5d6dVWHy9e
	AjSmpTAHv1uhPlV7jBKlfc7ZlWc7nFSGu/50TnufyBCdtzKzrRqNlXIk=
X-Google-Smtp-Source: AGHT+IHy2QCuihHNWNBuP86d2l8YZBecoXPOMm9wJpMo4eFdypfJAcBwptAW+Mba6xUzy4Bq7G6u2+nrZvYNcZDQGr1zMiukokPi
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:272b:b0:476:7265:9bfc with SMTP id
 m43-20020a056638272b00b0047672659bfcmr70416jav.6.1710408684222; Thu, 14 Mar
 2024 02:31:24 -0700 (PDT)
Date: Thu, 14 Mar 2024 02:31:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000b4e8806139b8e72@google.com>
Subject: [syzbot] [xfs?] possible deadlock in xfs_qm_dqget_cache_insert
From: syzbot <syzbot+8fdff861a781522bda4d@syzkaller.appspotmail.com>
To: chandan.babu@oracle.com, djwong@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e5e038b7ae9d Merge tag 'fs_for_v6.9-rc1' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1629d9d1180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6ce8d253b68e67fe
dashboard link: https://syzkaller.appspot.com/bug?extid=8fdff861a781522bda4d
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-e5e038b7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/82ab7eda09bc/vmlinux-e5e038b7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bda17336e65d/bzImage-e5e038b7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8fdff861a781522bda4d@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.8.0-syzkaller-06619-ge5e038b7ae9d #0 Not tainted
------------------------------------------------------
syz-executor.0/10102 is trying to acquire lock:
ffffffff8d92fb40 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:303 [inline]
ffffffff8d92fb40 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:3746 [inline]
ffffffff8d92fb40 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:3827 [inline]
ffffffff8d92fb40 (fs_reclaim){+.+.}-{0:0}, at: kmem_cache_alloc+0x4f/0x320 mm/slub.c:3852

but task is already holding lock:
ffff88802712c958 (&qinf->qi_tree_lock){+.+.}-{3:3}, at: xfs_qm_dqget_cache_insert.constprop.0+0x2a/0x2c0 fs/xfs/xfs_dquot.c:825

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&qinf->qi_tree_lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x175/0x9c0 kernel/locking/mutex.c:752
       xfs_qm_dqfree_one+0x6f/0x1a0 fs/xfs/xfs_qm.c:1654
       xfs_qm_shrink_scan+0x25c/0x3f0 fs/xfs/xfs_qm.c:531
       do_shrink_slab+0x44f/0x1160 mm/shrinker.c:435
       shrink_slab+0x18a/0x1310 mm/shrinker.c:662
       shrink_one+0x493/0x7b0 mm/vmscan.c:4767
       shrink_many mm/vmscan.c:4828 [inline]
       lru_gen_shrink_node mm/vmscan.c:4929 [inline]
       shrink_node+0x2191/0x3770 mm/vmscan.c:5888
       kswapd_shrink_node mm/vmscan.c:6696 [inline]
       balance_pgdat+0x9d0/0x1a90 mm/vmscan.c:6886
       kswapd+0x5c1/0xc10 mm/vmscan.c:7146
       kthread+0x2c1/0x3a0 kernel/kthread.c:388
       ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:243

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3134 [inline]
       check_prevs_add kernel/locking/lockdep.c:3253 [inline]
       validate_chain kernel/locking/lockdep.c:3869 [inline]
       __lock_acquire+0x2478/0x3b30 kernel/locking/lockdep.c:5137
       lock_acquire kernel/locking/lockdep.c:5754 [inline]
       lock_acquire+0x1b1/0x540 kernel/locking/lockdep.c:5719
       __fs_reclaim_acquire mm/page_alloc.c:3692 [inline]
       fs_reclaim_acquire+0x102/0x150 mm/page_alloc.c:3706
       might_alloc include/linux/sched/mm.h:303 [inline]
       slab_pre_alloc_hook mm/slub.c:3746 [inline]
       slab_alloc_node mm/slub.c:3827 [inline]
       kmem_cache_alloc+0x4f/0x320 mm/slub.c:3852
       radix_tree_node_alloc.constprop.0+0x7c/0x350 lib/radix-tree.c:276
       radix_tree_extend+0x1a2/0x4d0 lib/radix-tree.c:425
       __radix_tree_create lib/radix-tree.c:613 [inline]
       radix_tree_insert+0x499/0x630 lib/radix-tree.c:712
       xfs_qm_dqget_cache_insert.constprop.0+0x38/0x2c0 fs/xfs/xfs_dquot.c:826
       xfs_qm_dqget+0x182/0x4a0 fs/xfs/xfs_dquot.c:901
       xfs_qm_vop_dqalloc+0x49a/0xe10 fs/xfs/xfs_qm.c:1755
       xfs_create+0x422/0x1140 fs/xfs/xfs_inode.c:1041
       xfs_generic_create+0x631/0x7c0 fs/xfs/xfs_iops.c:199
       lookup_open.isra.0+0x10a1/0x13c0 fs/namei.c:3497
       open_last_lookups fs/namei.c:3566 [inline]
       path_openat+0x92f/0x2990 fs/namei.c:3796
       do_filp_open+0x1dc/0x430 fs/namei.c:3826
       do_sys_openat2+0x17a/0x1e0 fs/open.c:1406
       do_sys_open fs/open.c:1421 [inline]
       __do_compat_sys_openat fs/open.c:1481 [inline]
       __se_compat_sys_openat fs/open.c:1479 [inline]
       __ia32_compat_sys_openat+0x16e/0x210 fs/open.c:1479
       do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
       __do_fast_syscall_32+0x7a/0x120 arch/x86/entry/common.c:321
       do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:346
       entry_SYSENTER_compat_after_hwframe+0x7a/0x84

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&qinf->qi_tree_lock);
                               lock(fs_reclaim);
                               lock(&qinf->qi_tree_lock);
  lock(fs_reclaim);

 *** DEADLOCK ***

3 locks held by syz-executor.0/10102:
 #0: ffff88801e4f0420 (sb_writers#21){.+.+}-{0:0}, at: open_last_lookups fs/namei.c:3555 [inline]
 #0: ffff88801e4f0420 (sb_writers#21){.+.+}-{0:0}, at: path_openat+0x19a7/0x2990 fs/namei.c:3796
 #1: ffff88804c060338 (&inode->i_sb->s_type->i_mutex_dir_key){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:793 [inline]
 #1: ffff88804c060338 (&inode->i_sb->s_type->i_mutex_dir_key){+.+.}-{3:3}, at: open_last_lookups fs/namei.c:3563 [inline]
 #1: ffff88804c060338 (&inode->i_sb->s_type->i_mutex_dir_key){+.+.}-{3:3}, at: path_openat+0x8c7/0x2990 fs/namei.c:3796
 #2: ffff88802712c958 (&qinf->qi_tree_lock){+.+.}-{3:3}, at: xfs_qm_dqget_cache_insert.constprop.0+0x2a/0x2c0 fs/xfs/xfs_dquot.c:825

stack backtrace:
CPU: 3 PID: 10102 Comm: syz-executor.0 Not tainted 6.8.0-syzkaller-06619-ge5e038b7ae9d #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2187
 check_prev_add kernel/locking/lockdep.c:3134 [inline]
 check_prevs_add kernel/locking/lockdep.c:3253 [inline]
 validate_chain kernel/locking/lockdep.c:3869 [inline]
 __lock_acquire+0x2478/0x3b30 kernel/locking/lockdep.c:5137
 lock_acquire kernel/locking/lockdep.c:5754 [inline]
 lock_acquire+0x1b1/0x540 kernel/locking/lockdep.c:5719
 __fs_reclaim_acquire mm/page_alloc.c:3692 [inline]
 fs_reclaim_acquire+0x102/0x150 mm/page_alloc.c:3706
 might_alloc include/linux/sched/mm.h:303 [inline]
 slab_pre_alloc_hook mm/slub.c:3746 [inline]
 slab_alloc_node mm/slub.c:3827 [inline]
 kmem_cache_alloc+0x4f/0x320 mm/slub.c:3852
 radix_tree_node_alloc.constprop.0+0x7c/0x350 lib/radix-tree.c:276
 radix_tree_extend+0x1a2/0x4d0 lib/radix-tree.c:425
 __radix_tree_create lib/radix-tree.c:613 [inline]
 radix_tree_insert+0x499/0x630 lib/radix-tree.c:712
 xfs_qm_dqget_cache_insert.constprop.0+0x38/0x2c0 fs/xfs/xfs_dquot.c:826
 xfs_qm_dqget+0x182/0x4a0 fs/xfs/xfs_dquot.c:901
 xfs_qm_vop_dqalloc+0x49a/0xe10 fs/xfs/xfs_qm.c:1755
 xfs_create+0x422/0x1140 fs/xfs/xfs_inode.c:1041
 xfs_generic_create+0x631/0x7c0 fs/xfs/xfs_iops.c:199
 lookup_open.isra.0+0x10a1/0x13c0 fs/namei.c:3497
 open_last_lookups fs/namei.c:3566 [inline]
 path_openat+0x92f/0x2990 fs/namei.c:3796
 do_filp_open+0x1dc/0x430 fs/namei.c:3826
 do_sys_openat2+0x17a/0x1e0 fs/open.c:1406
 do_sys_open fs/open.c:1421 [inline]
 __do_compat_sys_openat fs/open.c:1481 [inline]
 __se_compat_sys_openat fs/open.c:1479 [inline]
 __ia32_compat_sys_openat+0x16e/0x210 fs/open.c:1479
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0x7a/0x120 arch/x86/entry/common.c:321
 do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:346
 entry_SYSENTER_compat_after_hwframe+0x7a/0x84
RIP: 0023:0xf7328579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f5f225ac EFLAGS: 00000292 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 00000000ffffff9c RCX: 00000000200002c0
RDX: 000000000000275a RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
syz-executor.0 (10102) used greatest stack depth: 20032 bytes left
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	10 06                	adc    %al,(%rsi)
   2:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
   6:	10 07                	adc    %al,(%rdi)
   8:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
   c:	10 08                	adc    %cl,(%rax)
   e:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
  1e:	00 51 52             	add    %dl,0x52(%rcx)
  21:	55                   	push   %rbp
  22:	89 e5                	mov    %esp,%ebp
  24:	0f 34                	sysenter
  26:	cd 80                	int    $0x80
* 28:	5d                   	pop    %rbp <-- trapping instruction
  29:	5a                   	pop    %rdx
  2a:	59                   	pop    %rcx
  2b:	c3                   	ret
  2c:	90                   	nop
  2d:	90                   	nop
  2e:	90                   	nop
  2f:	90                   	nop
  30:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
  37:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

