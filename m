Return-Path: <linux-xfs+bounces-18721-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 872AFA25359
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Feb 2025 08:55:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2259918842BC
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Feb 2025 07:55:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F7E71F55EB;
	Mon,  3 Feb 2025 07:55:05 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234A01F5424
	for <linux-xfs@vger.kernel.org>; Mon,  3 Feb 2025 07:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738569305; cv=none; b=CN4npUU7aV3MXEpTRWtVzsWv95pj5JtETwjllLjcxn1Y0Y8sz9gL1uXDNLWBBdXjZmfQOHOQshJAsYQGys7qco7vPVrk8EDiLknpqi/6M+FF/9eToXd0jWGikueygmFlM4VZmvXKvF28OuJMoGFooitMBh0ump7Dl8SHxO1xJWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738569305; c=relaxed/simple;
	bh=CgpM+Pv1P6UGFPiSar+vhIpGFfnQkj4QIYMAwhCORcI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=o70dstZN7ooRO9qdmSJ32nJv/dJaaZ9trRta0s30VLdotNyGzsySj3khdB4/luwcua8FY2fHPcILcp7ewPqdGwRiNHFyLXL0TRrNFusyxJDt8w32+tKYVVGn1PGhwGyOyYLLwGrv9wRpBVdujWDqGFrW/5ZLFwZa+BG2XeYVx5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3cffc8affa1so25369595ab.3
        for <linux-xfs@vger.kernel.org>; Sun, 02 Feb 2025 23:55:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738569302; x=1739174102;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGxU7LoHEIPDdGdA0p4MVi7JpneITV3ECVtKPhbS+5Y=;
        b=PyUu5Har+LqLX1sdBgX0WOsbm6NJiLkKy5Hg3YWWU8PEHrnfX35Uv2Kz/yFaA93qPC
         Ol4edPhR6mcu0S/TG77zlbaNV8AtGpmobUPyHOUZW7ojyVMCttO5+x2HN1sbq9dkhad7
         CPsu+Pd11/2jYJ4bqlN/iyIUIXLinKRecRugGaU94RyWgNZ1syqjE9b51h85p/N+03Hi
         lDWnprtviDdXQGXPNDTi60K0sgasTd4Ci8TyAtoUzSRtgfYS493fQhEIi0ag11PrQLr9
         Xa+8Bosld5LaZrZMGL0iAJPguPI9suA73LHHu/2oLBq4uU9CyG8R4SL/BL3PjUP+Uc2M
         I08Q==
X-Forwarded-Encrypted: i=1; AJvYcCWRaMXAPey6+a4c1Wf+q3jbX+eeXdLu86MVzrNvANnbVflasMncJstd3FW4Pa69lMs4Ac9qzdOhlhs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1dt8qVu7MfOpQ1W3fXSGSQFCMlr9mTxQ7xxWcQM88k5WMj/Bw
	xWUiVq0ohThdy+DIYv7iAo4jH509lXQzDp0S922yg+0DLGivaXtThqSVVM3yYTC3BiUASWi7rkt
	7nHH5f+VIC6AlTM5ShrCGco1PSBq2WJ+rvSE70hneOd228X0ONeC1DLM=
X-Google-Smtp-Source: AGHT+IHV+68vA6fhXL27WbCEJlVxs9qfc0cz7UJUsmC8Syz4UbegQ8sQH+N9Lx4LZX7f0Y+o4FnKcWcaJbE9rXvUqX9g+yRRKsfM
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a25:b0:3cf:c85c:4f60 with SMTP id
 e9e14a558f8ab-3cffe3ccff2mr153654415ab.11.1738569302189; Sun, 02 Feb 2025
 23:55:02 -0800 (PST)
Date: Sun, 02 Feb 2025 23:55:02 -0800
In-Reply-To: <20250203073038.GA17805@lst.de>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a07656.050a0220.d7c5a.0081.GAE@google.com>
Subject: Re: [syzbot] [xfs?] possible deadlock in xfs_buf_find_insert
From: syzbot <syzbot+acb56162aef712929d3f@syzkaller.appspotmail.com>
To: cem@kernel.org, chandan.babu@oracle.com, djwong@kernel.org, hch@lst.de, 
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

   T0] rcu: Preemptible hierarchical RCU implementation.
[    2.010612][    T0] rcu: 	RCU lockdep checking is enabled.
[    2.011402][    T0] rcu: 	RCU restricting CPUs from NR_CPUS=3D8 to nr_cp=
u_ids=3D2.
[    2.012353][    T0] rcu: 	RCU callback double-/use-after-free debug is e=
nabled.
[    2.013319][    T0] rcu: 	RCU debug extended QS entry/exit.
[    2.014072][    T0] 	All grace periods are expedited (rcu_expedited).
[    2.014984][    T0] 	Trampoline variant of Tasks RCU enabled.
[    2.015740][    T0] 	Tracing variant of Tasks RCU enabled.
[    2.016576][    T0] rcu: RCU calculated value of scheduler-enlistment de=
lay is 10 jiffies.
[    2.017799][    T0] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr=
_cpu_ids=3D2
[    2.019085][    T0] Running RCU synchronous self tests
[    2.020120][    T0] RCU Tasks: Setting shift to 1 and lim to 1 rcu_task_=
cb_adjust=3D1 rcu_task_cpu_ids=3D2.
[    2.021528][    T0] RCU Tasks Trace: Setting shift to 1 and lim to 1 rcu=
_task_cb_adjust=3D1 rcu_task_cpu_ids=3D2.
[    2.128414][    T0] NR_IRQS: 4352, nr_irqs: 440, preallocated irqs: 16
[    2.130465][    T0] rcu: srcu_init: Setting srcu_struct sizes based on c=
ontention.
[    2.131983][    T0] kfence: initialized - using 2097152 bytes for 255 ob=
jects at 0xffff88823be00000-0xffff88823c000000
[    2.134701][    T0] Console: colour VGA+ 80x25
[    2.135499][    T0] printk: legacy console [ttyS0] enabled
[    2.135499][    T0] printk: legacy console [ttyS0] enabled
[    2.137023][    T0] printk: legacy bootconsole [earlyser0] disabled
[    2.137023][    T0] printk: legacy bootconsole [earlyser0] disabled
[    2.138913][    T0] Lock dependency validator: Copyright (c) 2006 Red Ha=
t, Inc., Ingo Molnar
[    2.140082][    T0] ... MAX_LOCKDEP_SUBCLASSES:  8
[    2.140751][    T0] ... MAX_LOCK_DEPTH:          48
[    2.141484][    T0] ... MAX_LOCKDEP_KEYS:        8192
[    2.142184][    T0] ... CLASSHASH_SIZE:          4096
[    2.142884][    T0] ... MAX_LOCKDEP_ENTRIES:     1048576
[    2.143679][    T0] ... MAX_LOCKDEP_CHAINS:      1048576
[    2.144453][    T0] ... CHAINHASH_SIZE:          524288
[    2.145319][    T0]  memory used by lock dependency info: 106625 kB
[    2.146255][    T0]  memory used for stack traces: 8320 kB
[    2.147150][    T0]  per task-struct memory footprint: 1920 bytes
[    2.148349][    T0] mempolicy: Enabling automatic NUMA balancing. Config=
ure with numa_balancing=3D or the kernel.numa_balancing sysctl
[    2.150130][    T0] ACPI: Core revision 20240827
[    2.151799][    T0] APIC: Switch to symmetric I/O mode setup
[    2.153224][    T0] x2apic enabled
[    2.157556][    T0] APIC: Switched APIC routing to: physical x2apic
[    2.164292][    T0] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D0 apic2=3D-1=
 pin2=3D-1
[    2.165656][    T0] clocksource: tsc-early: mask: 0xffffffffffffffff max=
_cycles: 0x1fb6cdb0489, max_idle_ns: 440795236064 ns
[    2.168007][    T0] Calibrating delay loop (skipped) preset value.. 4400=
.32 BogoMIPS (lpj=3D22001640)
[    2.170708][    T0] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    2.178063][    T0] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    2.179278][    T0] Spectre V1 : Mitigation: usercopy/swapgs barriers an=
d __user pointer sanitization
[    2.180882][    T0] Spectre V2 : Spectre BHI mitigation: SW BHB clearing=
 on syscall and VM exit
[    2.182464][    T0] Spectre V2 : Mitigation: IBRS
[    2.183352][    T0] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Fil=
ling RSB on context switch
[    2.185620][    T0] Spectre V2 : Spectre v2 / SpectreRSB : Filling RSB o=
n VMEXIT
[    2.187126][    T0] RETBleed: Mitigation: IBRS
[    2.188042][    T0] Spectre V2 : mitigation: Enabling conditional Indire=
ct Branch Prediction Barrier
[    2.189783][    T0] Spectre V2 : User space: Mitigation: STIBP via prctl
[    2.191308][    T0] Speculative Store Bypass: Mitigation: Speculative St=
ore Bypass disabled via prctl
[    2.192767][    T0] MDS: Mitigation: Clear CPU buffers
[    2.193900][    T0] TAA: Mitigation: Clear CPU buffers
[    2.195007][    T0] MMIO Stale Data: Vulnerable: Clear CPU buffers attem=
pted, no microcode
[    2.196747][    T0] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floati=
ng point registers'
[    2.198001][    T0] x86/fpu: Supporting XSAVE feature 0x002: 'SSE regist=
ers'
[    2.199054][    T0] x86/fpu: Supporting XSAVE feature 0x004: 'AVX regist=
ers'
[    2.200127][    T0] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  2=
56
[    2.201210][    T0] x86/fpu: Enabled xstate features 0x7, context size i=
s 832 bytes, using 'standard' format.
[    2.442880][    T0] Freeing SMP alternatives memory: 128K
[    2.444580][    T0] pid_max: default: 32768 minimum: 301
[    2.446296][    T0] LSM: initializing lsm=3Dlockdown,capability,landlock=
,yama,safesetid,tomoyo,smack,bpf,ima,evm
[    2.448422][    T0] landlock: Up and running.
[    2.449554][    T0] Yama: becoming mindful.
[    2.451102][    T0] TOMOYO Linux initialized
[    2.452555][    T0] Smack:  Initializing.
[    2.453285][    T0] Smack:  Netfilter enabled.
[    2.454251][    T0] Smack:  IPv6 Netfilter enabled.
[    2.457026][    T0] LSM support for eBPF active
[    2.463614][    T0] Dentry cache hash table entries: 1048576 (order: 11,=
 8388608 bytes, vmalloc hugepage)
[    2.468234][    T0] Inode-cache hash table entries: 524288 (order: 10, 4=
194304 bytes, vmalloc hugepage)
[    2.470255][    T0] Mount-cache hash table entries: 16384 (order: 5, 131=
072 bytes, vmalloc)
[    2.472020][    T0] Mountpoint-cache hash table entries: 16384 (order: 5=
, 131072 bytes, vmalloc)
[    2.477781][    T0] Running RCU synchronous self tests
[    2.478011][    T0] Running RCU synchronous self tests
[    2.601188][    T1] smpboot: CPU0: Intel(R) Xeon(R) CPU @ 2.20GHz (famil=
y: 0x6, model: 0x4f, stepping: 0x0)
[    2.607820][    T1] Running RCU Tasks wait API self tests
[    2.708457][    T1] Running RCU Tasks Trace wait API self tests
[    2.709846][    T1] Performance Events: unsupported p6 CPU model 79 no P=
MU driver, software events only.
[    2.712156][    T1] signal: max sigframe size: 1776
[    2.714315][    T1] rcu: Hierarchical SRCU implementation.
[    2.715360][    T1] rcu: 	Max phase no-delay instances is 1000.
[    2.717463][    T1] Timer migration: 1 hierarchy levels; 8 children per =
group; 0 crossnode level
[    2.723005][    T1] NMI watchdog: Perf NMI watchdog permanently disabled
[    2.725256][    T1] smp: Bringing up secondary CPUs ...
[    2.729771][    T1] smpboot: x86: Booting SMP configuration:
[    2.730820][    T1] .... node  #0, CPUs:      #1
[    2.731034][   T15] Callback from call_rcu_tasks_trace() invoked.
[    2.733623][   T22] ------------[ cut here ]------------
[    2.733623][   T22] workqueue: work disable count underflowed
[    2.733623][   T22] WARNING: CPU: 1 PID: 22 at kernel/workqueue.c:4317 e=
nable_work+0x34d/0x360
[    2.733623][   T22] Modules linked in:
[    2.733623][   T22] CPU: 1 UID: 0 PID: 22 Comm: cpuhp/1 Not tainted 6.13=
.0-rc6-syzkaller-00134-ga9ab28b3d21a #0
[    2.735303][   T22] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 12/27/2024
[    2.737287][   T22] RIP: 0010:enable_work+0x34d/0x360
[    2.737989][   T22] Code: d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc c=
c e8 18 82 37 00 c6 05 4c c2 9a 0e 01 90 48 c7 c7 a0 d0 09 8c e8 44 25 f8 f=
f 90 <0f> 0b 90 90 e9 56 ff ff ff e8 e5 76 59 0a 0f 1f 44 00 00 90 90 90
[    2.737989][   T22] RSP: 0000:ffffc900001c7bc0 EFLAGS: 00010046
[    2.737989][   T22] RAX: 6282fd934c3ae400 RBX: 0000000000000000 RCX: fff=
f88801d2cbc00
[    2.737989][   T22] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000=
0000000000000
[    2.737989][   T22] RBP: ffffc900001c7c88 R08: ffffffff815ffac2 R09: 1ff=
ffffff1cfa0f4
[    2.737989][   T22] R10: dffffc0000000000 R11: fffffbfff1cfa0f5 R12: 1ff=
ff92000038f7c
[    2.737989][   T22] R13: 1ffff92000038f84 R14: 001fffffffc00001 R15: fff=
f8880b8738770
[    2.737989][   T22] FS:  0000000000000000(0000) GS:ffff8880b8700000(0000=
) knlGS:0000000000000000
[    2.737989][   T22] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.737989][   T22] CR2: 0000000000000000 CR3: 000000000e736000 CR4: 000=
00000003506f0
[    2.737989][   T22] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
[    2.737989][   T22] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000=
0000000000400
[    2.737989][   T22] Call Trace:
[    2.737989][   T22]  <TASK>
[    2.737989][   T22]  ? __warn+0x165/0x4d0
[    2.737989][   T22]  ? enable_work+0x34d/0x360
[    2.737989][   T22]  ? report_bug+0x2b3/0x500
[    2.737989][   T22]  ? enable_work+0x34d/0x360
[    2.737989][   T22]  ? handle_bug+0x60/0x90
[    2.737989][   T22]  ? exc_invalid_op+0x1a/0x50
[    2.737989][   T22]  ? asm_exc_invalid_op+0x1a/0x20
[    2.737989][   T22]  ? __warn_printk+0x292/0x360
[    2.737989][   T22]  ? enable_work+0x34d/0x360
[    2.737989][   T22]  ? __pfx_enable_work+0x10/0x10
[    2.737989][   T22]  ? __pfx_vmstat_cpu_online+0x10/0x10
[    2.737989][   T22]  ? rcu_is_watching+0x15/0xb0
[    2.737989][   T22]  vmstat_cpu_online+0xbb/0xe0
[    2.737989][   T22]  ? __pfx_vmstat_cpu_online+0x10/0x10
[    2.737989][   T22]  cpuhp_invoke_callback+0x48d/0x830
[    2.737989][   T22]  ? __pfx_vmstat_cpu_online+0x10/0x10
[    2.737989][   T22]  cpuhp_thread_fun+0x41c/0x810
[    2.737989][   T22]  ? cpuhp_thread_fun+0x130/0x810
[    2.737989][   T22]  ? __pfx_cpuhp_thread_fun+0x10/0x10
[    2.737989][   T22]  ? _raw_spin_unlock_irqrestore+0xdd/0x140
[    2.737989][   T22]  ? __pfx_cpuhp_thread_fun+0x10/0x10
[    2.737989][   T22]  smpboot_thread_fn+0x544/0xa30
[    2.737989][   T22]  ? smpboot_thread_fn+0x4e/0xa30
[    2.737989][   T22]  ? __pfx_smpboot_thread_fn+0x10/0x10
[    2.737989][   T22]  kthread+0x2f0/0x390
[    2.737989][   T22]  ? __pfx_smpboot_thread_fn+0x10/0x10
[    2.737989][   T22]  ? __pfx_kthread+0x10/0x10
[    2.737989][   T22]  ret_from_fork+0x4b/0x80
[    2.737989][   T22]  ? __pfx_kthread+0x10/0x10
[    2.737989][   T22]  ret_from_fork_asm+0x1a/0x30
[    2.737989][   T22]  </TASK>
[    2.737989][   T22] Kernel panic - not syncing: kernel: panic_on_warn se=
t ...
[    2.737989][   T22] CPU: 1 UID: 0 PID: 22 Comm: cpuhp/1 Not tainted 6.13=
.0-rc6-syzkaller-00134-ga9ab28b3d21a #0
[    2.737989][   T22] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 12/27/2024
[    2.737989][   T22] Call Trace:
[    2.737989][   T22]  <TASK>
[    2.737989][   T22]  dump_stack_lvl+0x241/0x360
[    2.737989][   T22]  ? __pfx_dump_stack_lvl+0x10/0x10
[    2.737989][   T22]  ? __pfx__printk+0x10/0x10
[    2.737989][   T22]  ? _printk+0xd5/0x120
[    2.737989][   T22]  ? __init_begin+0x41000/0x41000
[    2.737989][   T22]  ? vscnprintf+0x5d/0x90
[    2.737989][   T22]  panic+0x349/0x880
[    2.737989][   T22]  ? __warn+0x174/0x4d0
[    2.737989][   T22]  ? __pfx_panic+0x10/0x10
[    2.737989][   T22]  ? ret_from_fork_asm+0x1a/0x30
[    2.737989][   T22]  __warn+0x344/0x4d0
[    2.737989][   T22]  ? enable_work+0x34d/0x360
[    2.737989][   T22]  report_bug+0x2b3/0x500
[    2.737989][   T22]  ? enable_work+0x34d/0x360
[    2.737989][   T22]  handle_bug+0x60/0x90
[    2.737989][   T22]  exc_invalid_op+0x1a/0x50
[    2.737989][   T22]  asm_exc_invalid_op+0x1a/0x20
[    2.737989][   T22] RIP: 0010:enable_work+0x34d/0x360
[    2.737989][   T22] Code: d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc c=
c e8 18 82 37 00 c6 05 4c c2 9a 0e 01 90 48 c7 c7 a0 d0 09 8c e8 44 25 f8 f=
f 90 <0f> 0b 90 90 e9 56 ff ff ff e8 e5 76 59 0a 0f 1f 44 00 00 90 90 90
[    2.737989][   T22] RSP: 0000:ffffc900001c7bc0 EFLAGS: 00010046
[    2.737989][   T22] RAX: 6282fd934c3ae400 RBX: 0000000000000000 RCX: fff=
f88801d2cbc00
[    2.737989][   T22] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000=
0000000000000
[    2.737989][   T22] RBP: ffffc900001c7c88 R08: ffffffff815ffac2 R09: 1ff=
ffffff1cfa0f4
[    2.737989][   T22] R10: dffffc0000000000 R11: fffffbfff1cfa0f5 R12: 1ff=
ff92000038f7c
[    2.737989][   T22] R13: 1ffff92000038f84 R14: 001fffffffc00001 R15: fff=
f8880b8738770
[    2.737989][   T22]  ? __warn_printk+0x292/0x360
[    2.737989][   T22]  ? __pfx_enable_work+0x10/0x10
[    2.737989][   T22]  ? __pfx_vmstat_cpu_online+0x10/0x10
[    2.737989][   T22]  ? rcu_is_watching+0x15/0xb0
[    2.737989][   T22]  vmstat_cpu_online+0xbb/0xe0
[    2.737989][   T22]  ? __pfx_vmstat_cpu_online+0x10/0x10
[    2.737989][   T22]  cpuhp_invoke_callback+0x48d/0x830
[    2.737989][   T22]  ? __pfx_vmstat_cpu_online+0x10/0x10
[    2.737989][   T22]  cpuhp_thread_fun+0x41c/0x810
[    2.737989][   T22]  ? cpuhp_thread_fun+0x130/0x810
[    2.737989][   T22]  ? __pfx_cpuhp_thread_fun+0x10/0x10
[    2.737989][   T22]  ? _raw_spin_unlock_irqrestore+0xdd/0x140
[    2.737989][   T22]  ? __pfx_cpuhp_thread_fun+0x10/0x10
[    2.737989][   T22]  smpboot_thread_fn+0x544/0xa30
[    2.737989][   T22]  ? smpboot_thread_fn+0x4e/0xa30
[    2.737989][   T22]  ? __pfx_smpboot_thread_fn+0x10/0x10
[    2.737989][   T22]  kthread+0x2f0/0x390
[    2.737989][   T22]  ? __pfx_smpboot_thread_fn+0x10/0x10
[    2.737989][   T22]  ? __pfx_kthread+0x10/0x10
[    2.737989][   T22]  ret_from_fork+0x4b/0x80
[    2.737989][   T22]  ? __pfx_kthread+0x10/0x10
[    2.737989][   T22]  ret_from_fork_asm+0x1a/0x30
[    2.737989][   T22]  </TASK>
[    2.737989][   T22] Rebooting in 86400 seconds..


syzkaller build log:
go env (err=3D<nil>)
GO111MODULE=3D'auto'
GOARCH=3D'amd64'
GOBIN=3D''
GOCACHE=3D'/syzkaller/.cache/go-build'
GOENV=3D'/syzkaller/.config/go/env'
GOEXE=3D''
GOEXPERIMENT=3D''
GOFLAGS=3D''
GOHOSTARCH=3D'amd64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMODCACHE=3D'/syzkaller/jobs-2/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs-2/linux/gopath'
GOPRIVATE=3D''
GOPROXY=3D'https://proxy.golang.org,direct'
GOROOT=3D'/usr/local/go'
GOSUMDB=3D'sum.golang.org'
GOTMPDIR=3D''
GOTOOLCHAIN=3D'auto'
GOTOOLDIR=3D'/usr/local/go/pkg/tool/linux_amd64'
GOVCS=3D''
GOVERSION=3D'go1.22.7'
GCCGO=3D'gccgo'
GOAMD64=3D'v1'
AR=3D'ar'
CC=3D'gcc'
CXX=3D'g++'
CGO_ENABLED=3D'1'
GOMOD=3D'/syzkaller/jobs-2/linux/gopath/src/github.com/google/syzkaller/go.=
mod'
GOWORK=3D''
CGO_CFLAGS=3D'-O2 -g'
CGO_CPPFLAGS=3D''
CGO_CXXFLAGS=3D'-O2 -g'
CGO_FFLAGS=3D'-O2 -g'
CGO_LDFLAGS=3D'-O2 -g'
PKG_CONFIG=3D'pkg-config'
GOGCCFLAGS=3D'-fPIC -m64 -pthread -Wl,--no-gc-sections -fmessage-length=3D0=
 -ffile-prefix-map=3D/tmp/go-build348862417=3D/tmp/go-build -gno-record-gcc=
-switches'

git status (err=3D<nil>)
HEAD detached at 568559e4e6
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go list -f '{{.Stale}}' ./sys/syz-sysgen | grep -q false || go install ./sy=
s/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
touch .descriptions
GOOS=3Dlinux GOARCH=3Damd64 go build "-ldflags=3D-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D568559e4e604140cecd9fc4835eaa0298a1cadcc -X '=
github.com/google/syzkaller/prog.gitRevisionDate=3D20250201-125757'" -o ./b=
in/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
mkdir -p ./bin/linux_amd64
g++ -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wfr=
ame-larger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-forma=
t-overflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -=
static-pie -std=3Dc++17 -I. -Iexecutor/_include   -DGOOS_linux=3D1 -DGOARCH=
_amd64=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"568559e4e604140cecd9fc4835eaa0298a=
1cadcc\"
/usr/bin/ld: /tmp/ccNM92bn.o: in function `Connection::Connect(char const*,=
 char const*)':
executor.cc:(.text._ZN10Connection7ConnectEPKcS1_[_ZN10Connection7ConnectEP=
KcS1_]+0x104): warning: Using 'gethostbyname' in statically linked applicat=
ions requires at runtime the shared libraries from the glibc version used f=
or linking


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=3D13491764580000


Tested on:

commit:         a9ab28b3 xfs: remove xfs_buf_cache.bc_lock
git tree:       https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/ for-ne=
xt
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc8502218c2b0a86=
4
dashboard link: https://syzkaller.appspot.com/bug?extid=3Dacb56162aef712929=
d3f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40

Note: no patches were applied.

