Return-Path: <linux-xfs+bounces-13067-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E1E697DBCB
	for <lists+linux-xfs@lfdr.de>; Sat, 21 Sep 2024 07:58:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4219A1C21026
	for <lists+linux-xfs@lfdr.de>; Sat, 21 Sep 2024 05:58:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF876143C6C;
	Sat, 21 Sep 2024 05:58:19 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055E938F9C
	for <linux-xfs@vger.kernel.org>; Sat, 21 Sep 2024 05:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726898299; cv=none; b=Yv2ks0viJf/yCzFtwMsVy1e5FZrmVoZ6D/97F6kpRfOuuFBIXX5auX+v30fFYIIlRgQKCZ/osHDNABfmV/fkiniwuPHXkBHlDtNnhe+8/kGUkwx79eFOIGYQG3+a3+pYI2KGOFevHxIs1aanV1YqK80ONEmtLmqNf4pELRlehmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726898299; c=relaxed/simple;
	bh=86qU5s11Le9z+vb06V7coZ8F5yhVflyiOUM1lsqn3vg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=M/t/WVtJEndFTPs+oh+W9EW7tJb9OnXH9ondVNuJA+HK2h9UyGjkXLlWrHVSIpQCW91nL3uLOJ/6wyEFNCGmjDFv7PQ+HumccZgTkwQtGBBPXA69LcsLYmkUf8ugRksc7AWBatutPIz9zS/biSMZ4QoGO4R8XXmU6/km78GbdjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a0ce3a623eso8442985ab.0
        for <linux-xfs@vger.kernel.org>; Fri, 20 Sep 2024 22:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726898297; x=1727503097;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6R2pDHrN+1kPPmnJ+AIa2cyQgyUQGogeqcdverPzUbU=;
        b=ai51COTEN6b6YacQx3XdrU5WqkwY0P14AkqIdVlEXEsvIGOQkFyoB/AM6p5d8b/zfB
         ftQS8QV7IzTiWQidmWeyJqe3c+GSPyCqUNvlc+b1CoLIfUKs82vv1kbxTfvbPTdalWNg
         FjkqWYX9Oi8n/P6n5FEN7Cn7nyw03hpLvFQNI7WmZIw11kVJH8aLp2Y93XbKgWiDFqN3
         CuzgNWxzBEktlilod4WdVSsnqTcyIXb9Uf1kxDiP3BOnVjQdznbapO4YJq6scfvhb15h
         lI2SaryIg8Gax49dnLLuzZuOnPpotliuvWlkf5a2xbNJh48xPiO89UkimM16Z4VFLG4L
         DOTA==
X-Forwarded-Encrypted: i=1; AJvYcCWR0MTkZjyryNUtKXZpr2I97XXSQ5bn44+9JyzDUoReESggyTYa71cpCycdzi5VkeGH/oboyBPLBPs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI2iQUWx/xKLAm7vevvyloGRuO8hxvTG9njTt4L2xJtOOKrNhj
	8Ay4gr3qxeV7Ap85jZXi/Or4PYKFbh4Kl2qEqyPkDn4pshql4iM3kSLtNYUEy0ve7cDtRGbEmOA
	RdXVaQW2MHR/ngyl+0nVE431CDdT49welOf4UMuMGie+wQVe+bnaGYYw=
X-Google-Smtp-Source: AGHT+IE/elQLXw51P2cbk21wAPxxpU4wEdqccrA8oEZh3yefhxYCOghiJBN521eO6Hlx9wvlHQ+HK3iBB0dVnirPIK04mGWV0TWE
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1e08:b0:39b:640e:c5e6 with SMTP id
 e9e14a558f8ab-3a0c9d77cf6mr54200135ab.17.1726898297174; Fri, 20 Sep 2024
 22:58:17 -0700 (PDT)
Date: Fri, 20 Sep 2024 22:58:17 -0700
In-Reply-To: <000000000000e6432a06046c96a5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66ee6079.050a0220.3195df.0034.GAE@google.com>
Subject: Re: [syzbot] [fs] INFO: task hung in __fdget_pos (4)
From: syzbot <syzbot+e245f0516ee625aaa412@syzkaller.appspotmail.com>
To: brauner@kernel.org, david@fromorbit.com, djwong@kernel.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, llvm@lists.linux.dev, mjguzik@gmail.com, 
	nathan@kernel.org, ndesaulniers@google.com, nogikh@google.com, 
	syzkaller-bugs@googlegroups.com, trix@redhat.com, tytso@mit.edu, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    5f5673607153 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=11c1ee9f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dedbcb1ff4387972
dashboard link: https://syzkaller.appspot.com/bug?extid=e245f0516ee625aaa412
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15f86427980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1169ff00580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/40172aed5414/disk-5f567360.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/58372f305e9d/vmlinux-5f567360.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d2aae6fa798f/Image-5f567360.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/68d8cbbc10b8/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e245f0516ee625aaa412@syzkaller.appspotmail.com

INFO: task syz-executor273:6489 blocked for more than 143 seconds.
      Not tainted 6.11.0-rc7-syzkaller-g5f5673607153 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor273 state:D stack:0     pid:6489  tgid:6484  ppid:6438   flags:0x00000005
Call trace:
 __switch_to+0x420/0x6dc arch/arm64/kernel/process.c:603
 context_switch kernel/sched/core.c:5188 [inline]
 __schedule+0x13d4/0x2418 kernel/sched/core.c:6529
 __schedule_loop kernel/sched/core.c:6606 [inline]
 schedule+0xbc/0x238 kernel/sched/core.c:6621
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:6678
 __mutex_lock_common+0xbd8/0x21a0 kernel/locking/mutex.c:684
 __mutex_lock kernel/locking/mutex.c:752 [inline]
 mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
 __fdget_pos+0x218/0x2a4 fs/file.c:1187
 fdget_pos include/linux/file.h:76 [inline]
 ksys_read+0x8c/0x26c fs/read_write.c:610
 __do_sys_read fs/read_write.c:629 [inline]
 __se_sys_read fs/read_write.c:627 [inline]
 __arm64_sys_read+0x7c/0x90 fs/read_write.c:627
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
INFO: task syz-executor273:6492 blocked for more than 143 seconds.
      Not tainted 6.11.0-rc7-syzkaller-g5f5673607153 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor273 state:D stack:0     pid:6492  tgid:6490  ppid:6439   flags:0x0000000d
Call trace:
 __switch_to+0x420/0x6dc arch/arm64/kernel/process.c:603
 context_switch kernel/sched/core.c:5188 [inline]
 __schedule+0x13d4/0x2418 kernel/sched/core.c:6529
 __schedule_loop kernel/sched/core.c:6606 [inline]
 schedule+0xbc/0x238 kernel/sched/core.c:6621
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:6678
 __mutex_lock_common+0xbd8/0x21a0 kernel/locking/mutex.c:684
 __mutex_lock kernel/locking/mutex.c:752 [inline]
 mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
 __fdget_pos+0x218/0x2a4 fs/file.c:1187
 fdget_pos include/linux/file.h:76 [inline]
 ksys_read+0x8c/0x26c fs/read_write.c:610
 __do_sys_read fs/read_write.c:629 [inline]
 __se_sys_read fs/read_write.c:627 [inline]
 __arm64_sys_read+0x7c/0x90 fs/read_write.c:627
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
INFO: task syz-executor273:6495 blocked for more than 143 seconds.
      Not tainted 6.11.0-rc7-syzkaller-g5f5673607153 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor273 state:D stack:0     pid:6495  tgid:6493  ppid:6440   flags:0x00000005
Call trace:
 __switch_to+0x420/0x6dc arch/arm64/kernel/process.c:603
 context_switch kernel/sched/core.c:5188 [inline]
 __schedule+0x13d4/0x2418 kernel/sched/core.c:6529
 __schedule_loop kernel/sched/core.c:6606 [inline]
 schedule+0xbc/0x238 kernel/sched/core.c:6621
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:6678
 __mutex_lock_common+0xbd8/0x21a0 kernel/locking/mutex.c:684
 __mutex_lock kernel/locking/mutex.c:752 [inline]
 mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
 __fdget_pos+0x218/0x2a4 fs/file.c:1187
 fdget_pos include/linux/file.h:76 [inline]
 ksys_read+0x8c/0x26c fs/read_write.c:610
 __do_sys_read fs/read_write.c:629 [inline]
 __se_sys_read fs/read_write.c:627 [inline]
 __arm64_sys_read+0x7c/0x90 fs/read_write.c:627
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
INFO: task syz-executor273:6498 blocked for more than 143 seconds.
      Not tainted 6.11.0-rc7-syzkaller-g5f5673607153 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor273 state:D stack:0     pid:6498  tgid:6496  ppid:6443   flags:0x00000005
Call trace:
 __switch_to+0x420/0x6dc arch/arm64/kernel/process.c:603
 context_switch kernel/sched/core.c:5188 [inline]
 __schedule+0x13d4/0x2418 kernel/sched/core.c:6529
 __schedule_loop kernel/sched/core.c:6606 [inline]
 schedule+0xbc/0x238 kernel/sched/core.c:6621
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:6678
 __mutex_lock_common+0xbd8/0x21a0 kernel/locking/mutex.c:684
 __mutex_lock kernel/locking/mutex.c:752 [inline]
 mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
 __fdget_pos+0x218/0x2a4 fs/file.c:1187
 fdget_pos include/linux/file.h:76 [inline]
 ksys_read+0x8c/0x26c fs/read_write.c:610
 __do_sys_read fs/read_write.c:629 [inline]
 __se_sys_read fs/read_write.c:627 [inline]
 __arm64_sys_read+0x7c/0x90 fs/read_write.c:627
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
INFO: task syz-executor273:6502 blocked for more than 143 seconds.
      Not tainted 6.11.0-rc7-syzkaller-g5f5673607153 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor273 state:D stack:0     pid:6502  tgid:6500  ppid:6444   flags:0x00000005
Call trace:
 __switch_to+0x420/0x6dc arch/arm64/kernel/process.c:603
 context_switch kernel/sched/core.c:5188 [inline]
 __schedule+0x13d4/0x2418 kernel/sched/core.c:6529
 __schedule_loop kernel/sched/core.c:6606 [inline]
 schedule+0xbc/0x238 kernel/sched/core.c:6621
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:6678
 __mutex_lock_common+0xbd8/0x21a0 kernel/locking/mutex.c:684
 __mutex_lock kernel/locking/mutex.c:752 [inline]
 mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
 __fdget_pos+0x218/0x2a4 fs/file.c:1187
 fdget_pos include/linux/file.h:76 [inline]
 ksys_read+0x8c/0x26c fs/read_write.c:610
 __do_sys_read fs/read_write.c:629 [inline]
 __se_sys_read fs/read_write.c:627 [inline]
 __arm64_sys_read+0x7c/0x90 fs/read_write.c:627
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffff80008f74dfa0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0xc/0x44 include/linux/rcupdate.h:325
2 locks held by getty/6174:
 #0: ffff0000d24390a0 (&tty->ldisc_sem){++++}-{0:0}, at: ldsem_down_read+0x3c/0x4c drivers/tty/tty_ldsem.c:340
 #1: ffff80009b50e2f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x41c/0x1228 drivers/tty/n_tty.c:2211
2 locks held by syz-executor273/6485:
1 lock held by syz-executor273/6489:
 #0: ffff0000c8fd14c8 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x218/0x2a4 fs/file.c:1187
2 locks held by syz-executor273/6491:
1 lock held by syz-executor273/6492:
 #0: ffff0000d6134d48 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x218/0x2a4 fs/file.c:1187
2 locks held by syz-executor273/6494:
1 lock held by syz-executor273/6495:
 #0: ffff0000cd021c48 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x218/0x2a4 fs/file.c:1187
3 locks held by syz-executor273/6497:
1 lock held by syz-executor273/6498:
 #0: ffff0000cebe9748 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x218/0x2a4 fs/file.c:1187
2 locks held by syz-executor273/6501:
1 lock held by syz-executor273/6502:
 #0: ffff0000d01660c8 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x218/0x2a4 fs/file.c:1187

=============================================



---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

