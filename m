Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594656B26DC
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Mar 2023 15:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjCIO0o (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 9 Mar 2023 09:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjCIO0n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Mar 2023 09:26:43 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CDF1FD1
        for <linux-xfs@vger.kernel.org>; Thu,  9 Mar 2023 06:26:38 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id bo22so2263636pjb.4
        for <linux-xfs@vger.kernel.org>; Thu, 09 Mar 2023 06:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678371998;
        h=content-transfer-encoding:mime-version:in-reply-to:subject:cc:to
         :from:message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F6qSBLDdTfLhNAr+gb8rwr8v5iDZPydn3J1MHgHr/R4=;
        b=orBznC0jAbv8v+BdY7/ApQ6+mIuv2Uc7cp8rTCrflNG8hrZTlUQDdVmEd/eMHIjGaj
         cPAT5ewGzv1V2GtAtUm5H6aMMQcdFZN0yylru1UEM73Y0fD/W2izd/S/1bGyYkPEbMPb
         vsz5+0DX/pmWGZRqjM/nKjbpteBqwWpLjjHBGgJk+1LPT0fSPl0JGrtxr3YZpZUIMYfi
         b80auQHv/IN72tRHFeskJbFYd7PlrbXCTw4S8mVY015361gtaLRB1Tp8ebBmfLRRwT8a
         qYpiP8n9FY1oNYVA8RloQHYM+2OTRWN6Rn1AnIplL+q9ZDY5S2bN3I4cQXezGunLLef2
         BVdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678371998;
        h=content-transfer-encoding:mime-version:in-reply-to:subject:cc:to
         :from:message-id:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6qSBLDdTfLhNAr+gb8rwr8v5iDZPydn3J1MHgHr/R4=;
        b=jeIz0mVcBOgl8HzMCytE+ljtvXDPPg2kWtqOe/k/+8sbOVsDsHl4jxgfnHVCO+ye88
         OlKmSnBFKWjAnuq5CoCtQoOnItoUs3afJrJ7VPdPu8r2c938FZWv8329bdBx+N+ydWh5
         7u3UANZW4OpSJ53Z14CE8VjPlaNZiF+I/M2rSlpYtVv6y0pmTJnGlPGY+XzkdqR9nx52
         +JxzkVtGenGPKRs6jOrr4XAa+NI923X7ciFucmkGoJOUZXGjzhiJHFl6nXyjhfKMeBIe
         BsTyXsMOUN+xX9P5hPMMtozhpdFuWXwAKS6nnaHKwc+qCq/nriRRUjm6S0LirrGvVO4E
         wb1Q==
X-Gm-Message-State: AO0yUKWHrVwdRZKjjPZrvs5VPeR5Ofoo5CYOb4gdiB4L/4Nyw5nbtFTb
        ufdCaav5hxA6ArrquPT85h4=
X-Google-Smtp-Source: AK7set8xJy1g9K05Au3sGrOGMweJFi60hFqCZ9R/RHzyK3/yo0TL+pl1rD3J5E92Wh5yBmIFimzc5g==
X-Received: by 2002:a17:902:fe82:b0:19e:21d2:ecee with SMTP id x2-20020a170902fe8200b0019e21d2eceemr20477419plm.31.1678371997503;
        Thu, 09 Mar 2023 06:26:37 -0800 (PST)
Received: from rh-tp ([2401:4900:16ee:2754:2118:c0b0:2222:4bbc])
        by smtp.gmail.com with ESMTPSA id jx18-20020a170903139200b0019e6e044a90sm11697660plb.226.2023.03.09.06.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 06:26:37 -0800 (PST)
Date:   Thu, 09 Mar 2023 19:56:06 +0530
Message-Id: <87356eknlt.fsf@doe.com>
From:   Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com
Subject: Re: xfs: system fails to boot up due to Internal error xfs_trans_cancel
In-Reply-To: <Y/ZFtEbLTX38pReY@magnolia>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

"Darrick J. Wong" <djwong@kernel.org> writes:

> On Sat, Feb 18, 2023 at 12:47:48PM +0530, shrikanth hegde wrote:
>>
>>
>> On 2/17/23 10:23 PM, Darrick J. Wong wrote:
>> > On Fri, Feb 17, 2023 at 04:45:12PM +0530, shrikanth hegde wrote:
>> >> We are observing panic on boot upon loading the latest stable tree(v6.2-rc4) in
>> >> one of our systems. System fails to come up. System was booting well
>> >> with v5.17, v5.19 kernel. We started seeing this issue when loading v6.0 kernel.
>> >>
>> >> Panic Log is below.
>> >> [  333.390539] ------------[ cut here ]------------
>> >> [  333.390552] WARNING: CPU: 56 PID: 12450 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
>> >
>> > Hmm, ok, so this is the same if (WARN_ON_ONCE(!ip || !ip->i_ino)) line
>> > in xfs_iunlink_lookup that I've been bonking my head on the past
>> > several days.  333 seconds uptime, so I guess this is a pretty recent
>> > mount.  You didn't post a full dmesg, so I can only assume there weren't
>> > any *other* obvious complaints from XFS when the fs was mounted...
>> >
>>
>> Darrick, Dave. Thank you for taking a look at this. sorry i didnt paste the full log.
>> Please find the full dmesg below. it was kexec from 5.17-rc2 to 6.2-rc8
>>
>>
>>          Starting Reboot via kexec...
>> [   71.134231] printk: systemd-shutdow: 37 output lines suppressed due to ratelimiting
>> [   71.158255] systemd-shutdown[1]: Syncing filesystems and block devices.
>> [   71.160419] systemd-shutdown[1]: Sending SIGTERM to remaining processes...
>> [   71.214007] systemd-shutdown[1]: Sending SIGKILL to remaining processes...
>> [   71.233182] systemd-shutdown[1]: Unmounting file systems.
>> [   71.233845] [2287]: Remounting '/home' read-only in with options 'attr2,inode64,logbufs=8,logbsize=32k,noquota'.
>> [   71.234873] [2288]: Unmounting '/home'.
>> [   71.237859] XFS (nvme0n1p1): Unmounting Filesystem
>> [   71.524111] [2289]: Remounting '/' read-only in with options 'attr2,inode64,logbufs=8,logbsize=32k,noquota'.
>> [   71.810094] systemd-shutdown[1]: All filesystems unmounted.
>> [   71.810103] systemd-shutdown[1]: Deactivating swaps.
>> [   71.810121] systemd-shutdown[1]: All swaps deactivated. pid=1 uid=0 auid=4294967295 ses=4294967295 msg='unit=systemd-remount-fs comm="systemd" exe="/usr/li[   71.810126] systemd-shutdown[1]: Detaching loop devices.'
>> [   71.810227] systemd-shutdown[1]: All loop devices detached.
>> [   71.810232] systemd-shutdown[1]: Detaching DM devices.
>> [   71.932097] printk: shutdown: 8 output lines suppressed due to ratelimiting
>> [   71.954484] dracut Warning: Killing all remaining processes
>> dracut Warning: Killing all remaining processes
>> [   72.001360] XFS (dm-0): Unmounting Filesystem
>> [   72.393816] dracut Warning: Unmounted /oldroot.
>> [   72.409893] dracut: Disassembling device-mapper devices
>> [   72.527853] Removing IBM Power 842 compression device
>> [   78.084038] kexec_core: Starting new kernel
>> [   78.104094] kexec: waiting for cpu 26 (physical 26) to enter 1 state
>> [   78.104102] kexec: waiting for cpu 87 (physical 87) to enter 1 state
>> [   78.104109] kexec: waiting for cpu 1 (physical 1) to enter 2 state
>> [   78.104248] kexec: waiting for cpu 2 (physical 2) to enter 2 state
>> [   78.104275] kexec: waiting for cpu 3 (physical 3) to enter 2 state
>> [   78.104289] kexec: waiting for cpu 4 (physical 4) to enter 2 state
>> [   78.104303] kexec: waiting for cpu 5 (physical 5) to enter 2 state
>> [   78.104315] kexec: waiting for cpu 8 (physical 8) to enter 2 state
>> [   78.104352] kexec: waiting for cpu 48 (physical 48) to enter 2 state
>> [   78.104357] kexec: waiting for cpu 49 (physical 49) to enter 2 state
>> [   78.278072] kexec: Starting switchover sequence.
>> I'm in purgatory
>> [    0.000000] radix-mmu: Page sizes from device-tree:
>> [    0.000000] radix-mmu: Page size shift = 12 AP=0x0
>> [    0.000000] radix-mmu: Page size shift = 16 AP=0x5
>> [    0.000000] radix-mmu: Page size shift = 21 AP=0x1
>> [    0.000000] radix-mmu: Page size shift = 30 AP=0x2
>> [    0.000000] Activating Kernel Userspace Access Prevention
>> [    0.000000] Activating Kernel Userspace Execution Prevention
>> [    0.000000] radix-mmu: Mapped 0x0000000000000000-0x0000000002600000 with 2.00 MiB pages (exec)
>> [    0.000000] radix-mmu: Mapped 0x0000000002600000-0x0000004b00000000 with 2.00 MiB pages
>> [    0.000000] lpar: Using radix MMU under hypervisor
>> [    0.000000] Linux version 6.2.0-rc8ssh (root@ltcden3-lp1.aus.stglabs.ibm.com) (gcc (GCC) 8.5.0 20210514 (Red Hat 8.5.0-10), GNU ld version 2.30-113.el8) #35 SMP Sat Feb 18 00:41:56 EST 2023
>> [    0.000000] Found initrd at 0xc0000000061d0000:0xc00000000ac38d3b
>> [    0.000000] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
>> [    0.000000] printk: bootconsole [udbg0] enabled
>> [    0.000000] Partition configured for 96 cpus.
>> [    0.000000] CPU maps initialized for 8 threads per core
>> [    0.000000] numa: Partition configured for 32 NUMA nodes.
>> [    0.000000] -----------------------------------------------------
>> [    0.000000] phys_mem_size     = 0x4b00000000
>> [    0.000000] dcache_bsize      = 0x80
>> [    0.000000] icache_bsize      = 0x80
>> [    0.000000] cpu_features      = 0x000c00eb8f5f9187
>> [    0.000000]   possible        = 0x000ffbfbcf5fb187
>> [    0.000000]   always          = 0x0000000380008181
>> [    0.000000] cpu_user_features = 0xdc0065c2 0xaef60000
>> [    0.000000] mmu_features      = 0xbc007641
>> [    0.000000] firmware_features = 0x000005bfc55bfc57
>> [    0.000000] vmalloc start     = 0xc008000000000000
>> [    0.000000] IO start          = 0xc00a000000000000
>> [    0.000000] vmemmap start     = 0xc00c000000000000
>> [    0.000000] -----------------------------------------------------
>> [    0.000000] numa:   NODE_DATA [mem 0x4afe663780-0x4afe66aeff]
>> [    0.000000] rfi-flush: fallback displacement flush available
>> [    0.000000] count-cache-flush: hardware flush enabled.
>> [    0.000000] link-stack-flush: software flush enabled.
>> [    0.000000] stf-barrier: eieio barrier available
>> [    0.000000] PPC64 nvram contains 15360 bytes
>> [    0.000000] barrier-nospec: using ORI speculation barrier
>> [    0.000000] Zone ranges:
>> [    0.000000]   Normal   [mem 0x0000000000000000-0x0000004affffffff]
>> [    0.000000]   Device   empty
>> [    0.000000] Movable zone start for each node
>> [    0.000000] Early memory node ranges
>> [    0.000000]   node   2: [mem 0x0000000000000000-0x0000004affffffff]
>> [    0.000000] Initializing node 0 as memoryless
>> [    0.000000] Initmem setup node 0 as memoryless
>> [    0.000000] Initializing node 1 as memoryless
>> [    0.000000] Initmem setup node 1 as memoryless
>> [    0.000000] Initmem setup node 2 [mem 0x0000000000000000-0x0000004affffffff]
>> [    0.000000] Initializing node 3 as memoryless
>> [    0.000000] Initmem setup node 3 as memoryless
>> [    0.000000] Initializing node 4 as memoryless
>> [    0.000000] Initmem setup node 4 as memoryless
>> [    0.000000] Initializing node 5 as memoryless
>> [    0.000000] Initmem setup node 5 as memoryless
>> [    0.000000] Initializing node 6 as memoryless
>> [    0.000000] Initmem setup node 6 as memoryless
>> [    0.000000] Initializing node 7 as memoryless
>> [    0.000000] Initmem setup node 7 as memoryless
>> [    0.000000] Initializing node 8 as memoryless
>> [    0.000000] Initmem setup node 8 as memoryless
>> [    0.000000] Initializing node 9 as memoryless
>> [    0.000000] Initmem setup node 9 as memoryless
>> [    0.000000] Initializing node 10 as memoryless
>> [    0.000000] Initmem setup node 10 as memoryless
>> [    0.000000] Initializing node 11 as memoryless
>> [    0.000000] Initmem setup node 11 as memoryless
>> [    0.000000] Initializing node 12 as memoryless
>> [    0.000000] Initmem setup node 12 as memoryless
>> [    0.000000] Initializing node 13 as memoryless
>> [    0.000000] Initmem setup node 13 as memoryless
>> [    0.000000] Initializing node 14 as memoryless
>> [    0.000000] Initmem setup node 14 as memoryless
>> [    0.000000] Initializing node 15 as memoryless
>> [    0.000000] Initmem setup node 15 as memoryless
>> [    0.000000] Initializing node 16 as memoryless
>> [    0.000000] Initmem setup node 16 as memoryless
>> [    0.000000] Initializing node 17 as memoryless
>> [    0.000000] Initmem setup node 17 as memoryless
>> [    0.000000] Initializing node 18 as memoryless
>> [    0.000000] Initmem setup node 18 as memoryless
>> [    0.000000] Initializing node 19 as memoryless
>> [    0.000000] Initmem setup node 19 as memoryless
>> [    0.000000] Initializing node 20 as memoryless
>> [    0.000000] Initmem setup node 20 as memoryless
>> [    0.000000] Initializing node 21 as memoryless
>> [    0.000000] Initmem setup node 21 as memoryless
>> [    0.000000] Initializing node 22 as memoryless
>> [    0.000000] Initmem setup node 22 as memoryless
>> [    0.000000] Initializing node 23 as memoryless
>> [    0.000000] Initmem setup node 23 as memoryless
>> [    0.000000] Initializing node 24 as memoryless
>> [    0.000000] Initmem setup node 24 as memoryless
>> [    0.000000] Initializing node 25 as memoryless
>> [    0.000000] Initmem setup node 25 as memoryless
>> [    0.000000] Initializing node 26 as memoryless
>> [    0.000000] Initmem setup node 26 as memoryless
>> [    0.000000] Initializing node 27 as memoryless
>> [    0.000000] Initmem setup node 27 as memoryless
>> [    0.000000] Initializing node 28 as memoryless
>> [    0.000000] Initmem setup node 28 as memoryless
>> [    0.000000] Initializing node 29 as memoryless
>> [    0.000000] Initmem setup node 29 as memoryless
>> [    0.000000] Initializing node 30 as memoryless
>> [    0.000000] Initmem setup node 30 as memoryless
>> [    0.000000] Initializing node 31 as memoryless
>> [    0.000000] Initmem setup node 31 as memoryless
>> [    0.000000] percpu: Embedded 10 pages/cpu s601512 r0 d53848 u655360
>> [    0.000000] Fallback order for Node 0: 0 2
>> [    0.000000] Fallback order for Node 1: 1 2
>> [    0.000000] Fallback order for Node 2: 2
>> [    0.000000] Fallback order for Node 3: 3 2
>> [    0.000000] Fallback order for Node 4: 4 2
>> [    0.000000] Fallback order for Node 5: 5 2
>> [    0.000000] Fallback order for Node 6: 6 2
>> [    0.000000] Fallback order for Node 7: 7 2
>> [    0.000000] Fallback order for Node 8: 8 2
>> [    0.000000] Fallback order for Node 9: 9 2
>> [    0.000000] Fallback order for Node 10: 10 2
>> [    0.000000] Fallback order for Node 11: 11 2
>> [    0.000000] Fallback order for Node 12: 12 2
>> [    0.000000] Fallback order for Node 13: 13 2
>> [    0.000000] Fallback order for Node 14: 14 2
>> [    0.000000] Fallback order for Node 15: 15 2
>> [    0.000000] Fallback order for Node 16: 16 2
>> [    0.000000] Fallback order for Node 17: 17 2
>> [    0.000000] Fallback order for Node 18: 18 2
>> [    0.000000] Fallback order for Node 19: 19 2
>> [    0.000000] Fallback order for Node 20: 20 2
>> [    0.000000] Fallback order for Node 21: 21 2
>> [    0.000000] Fallback order for Node 22: 22 2
>> [    0.000000] Fallback order for Node 23: 23 2
>> [    0.000000] Fallback order for Node 24: 24 2
>> [    0.000000] Fallback order for Node 25: 25 2
>> [    0.000000] Fallback order for Node 26: 26 2
>> [    0.000000] Fallback order for Node 27: 27 2
>> [    0.000000] Fallback order for Node 28: 28 2
>> [    0.000000] Fallback order for Node 29: 29 2
>> [    0.000000] Fallback order for Node 30: 30 2
>> [    0.000000] Fallback order for Node 31: 31 2
>> [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 4910400
>> [    0.000000] Policy zone: Normal
>> [    0.000000] Kernel command line: root=/dev/mapper/rhel_ltcden3--lp1-root
>> [    0.000000] random: crng init done
>> [    0.000000] Dentry cache hash table entries: 16777216 (order: 11, 134217728 bytes, linear)
>> [    0.000000] Inode-cache hash table entries: 8388608 (order: 10, 67108864 bytes, linear)
>> [    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
>> [    0.000000] Memory: 313817216K/314572800K available (15168K kernel code, 5632K rwdata, 17600K rodata, 5440K init, 2721K bss, 755584K reserved, 0K cma-reserved)
>> [    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=96, Nodes=32
>> [    0.000000] ftrace: allocating 38156 entries in 14 pages
>> [    0.000000] ftrace: allocated 14 pages with 3 groups
>> [    0.000000] trace event string verifier disabled
>> [    0.000000] rcu: Hierarchical RCU implementation.
>> [    0.000000] rcu: 	RCU restricting CPUs from NR_CPUS=2048 to nr_cpu_ids=96.
>> [    0.000000] 	Rude variant of Tasks RCU enabled.
>> [    0.000000] 	Tracing variant of Tasks RCU enabled.
>> [    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 10 jiffies.
>> [    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=96
>> [    0.000000] NR_IRQS: 512, nr_irqs: 512, preallocated irqs: 16
>> [    0.000000] xive: Using IRQ range [400000-40005f]
>> [    0.000000] xive: Interrupt handling initialized with spapr backend
>> [    0.000000] xive: Using priority 7 for all interrupts
>> [    0.000000] xive: Using 64kB queues
>> [    0.000000] rcu: srcu_init: Setting srcu_struct sizes based on contention.
>> [    0.000001] time_init: 56 bit decrementer (max: 7fffffffffffff)
>> [    0.000021] clocksource: timebase: mask: 0xffffffffffffffff max_cycles: 0x761537d007, max_idle_ns: 440795202126 ns
>> [    0.000055] clocksource: timebase mult[1f40000] shift[24] registered
>> [    0.000233] Console: colour dummy device 80x25
>> [    0.000252] printk: console [hvc0] enabled
>> [    0.000252] printk: console [hvc0] enabled
>> [    0.000269] printk: bootconsole [udbg0] disabled
>> [    0.000269] printk: bootconsole [udbg0] disabled
>> [    0.000360] pid_max: default: 98304 minimum: 768
>> [    0.000481] LSM: initializing lsm=capability,yama,integrity,selinux,bpf
>> [    0.000550] Yama: becoming mindful.
>> [    0.000565] SELinux:  Initializing.
>> [    0.000568] SELinux: CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE is non-zero.  This is deprecated and will be rejected in a future kernel release.
>> [    0.000573] SELinux: https://github.com/SELinuxProject/selinux-kernel/wiki/DEPRECATE-checkreqprot
>> [    0.000747] LSM support for eBPF active
>> [    0.000929] Mount-cache hash table entries: 262144 (order: 5, 2097152 bytes, linear)
>> [    0.001056] Mountpoint-cache hash table entries: 262144 (order: 5, 2097152 bytes, linear)
>> [    0.003430] cblist_init_generic: Setting adjustable number of callback queues.
>> [    0.003454] cblist_init_generic: Setting shift to 7 and lim to 1.
>> [    0.003486] cblist_init_generic: Setting shift to 7 and lim to 1.
>> [    0.003507] POWER10 performance monitor hardware support registered
>> [    0.003537] rcu: Hierarchical SRCU implementation.
>> [    0.003540] rcu: 	Max phase no-delay instances is 1000.
>> [    0.004445] smp: Bringing up secondary CPUs ...
>> [    0.022208] smp: Brought up 1 node, 96 CPUs
>> [    0.022218] numa: Node 2 CPUs: 0-95
>> [    0.022222] Big cores detected but using small core scheduling
>> [    0.033289] devtmpfs: initialized
>> [    0.042965] PCI host bridge /pci@800000020000019  ranges:
>> [    0.042984]  MEM 0x0000040080000000..0x00000400feffffff -> 0x0000000080000000
>> [    0.042988]  MEM 0x0000044000000000..0x0000047fffffffff -> 0x0006204000000000
>> [    0.043060] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
>> [    0.043066] futex hash table entries: 32768 (order: 6, 4194304 bytes, linear)
>> [    0.043643] NET: Registered PF_NETLINK/PF_ROUTE protocol family
>> [    0.043801] audit: initializing netlink subsys (disabled)
>> [    0.043903] audit: type=2000 audit(1676701683.040:1): state=initialized audit_enabled=0 res=1
>> [    0.043954] thermal_sys: Registered thermal governor 'fair_share'
>> [    0.043955] thermal_sys: Registered thermal governor 'step_wise'
>> [    0.044007] cpuidle: using governor menu
>> [    0.044306] pstore: Registered nvram as persistent store backend
>> [    0.044682] EEH: pSeries platform initialized
>> [    0.055324] PCI: Probing PCI hardware
>> [    0.055372] PCI host bridge to bus 0019:01
>> [    0.055376] pci_bus 0019:01: root bus resource [mem 0x40080000000-0x400feffffff] (bus address [0x80000000-0xfeffffff])
>> [    0.055381] pci_bus 0019:01: root bus resource [mem 0x44000000000-0x47fffffffff 64bit] (bus address [0x6204000000000-0x6207fffffffff])
>> [    0.055386] pci_bus 0019:01: root bus resource [bus 01-ff]
>> [    0.056001] pci 0019:01:00.0: No hypervisor support for SR-IOV on this device, IOV BARs disabled.
>> [    0.064978] IOMMU table initialized, virtual merging enabled
>> [    0.065086] pci 0019:01:00.0: Adding to iommu group 0
>> [    0.066308] EEH: Capable adapter found: recovery enabled.
>> [    0.066550] kprobes: kprobe jump-optimization is enabled. All kprobes are optimized if possible.
>> [    0.066812] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
>> [    0.066817] HugeTLB: 0 KiB vmemmap can be freed for a 2.00 MiB page
>> [    0.066821] HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
>> [    0.066824] HugeTLB: 0 KiB vmemmap can be freed for a 1.00 GiB page
>> [    0.085068] cryptd: max_cpu_qlen set to 1000
>> [    0.085368] iommu: Default domain type: Translated
>> [    0.085371] iommu: DMA domain TLB invalidation policy: strict mode
>> [    0.085491] SCSI subsystem initialized
>> [    0.085517] usbcore: registered new interface driver usbfs
>> [    0.085523] usbcore: registered new interface driver hub
>> [    0.085542] usbcore: registered new device driver usb
>> [    0.085563] pps_core: LinuxPPS API ver. 1 registered
>> [    0.085565] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
>> [    0.085569] PTP clock support registered
>> [    0.085628] EDAC MC: Ver: 3.0.0
>> [    0.085885] NetLabel: Initializing
>> [    0.085887] NetLabel:  domain hash size = 128
>> [    0.085889] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
>> [    0.085903] NetLabel:  unlabeled traffic allowed by default
>> [    0.085956] vgaarb: loaded
>> [    0.086157] clocksource: Switched to clocksource timebase
>> [    0.086451] VFS: Disk quotas dquot_6.6.0
>> [    0.086480] VFS: Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
>> [    0.088080] NET: Registered PF_INET protocol family
>> [    0.088237] IP idents hash table entries: 262144 (order: 5, 2097152 bytes, linear)
>> [    0.091345] tcp_listen_portaddr_hash hash table entries: 65536 (order: 4, 1048576 bytes, linear)
>> [    0.091454] Table-perturb hash table entries: 65536 (order: 2, 262144 bytes, linear)
>> [    0.091480] TCP established hash table entries: 524288 (order: 6, 4194304 bytes, linear)
>> [    0.092201] TCP bind hash table entries: 65536 (order: 5, 2097152 bytes, linear)
>> [    0.092386] TCP: Hash tables configured (established 524288 bind 65536)
>> [    0.092708] MPTCP token hash table entries: 65536 (order: 4, 1572864 bytes, linear)
>> [    0.092826] UDP hash table entries: 65536 (order: 5, 2097152 bytes, linear)
>> [    0.093046] UDP-Lite hash table entries: 65536 (order: 5, 2097152 bytes, linear)
>> [    0.093402] NET: Registered PF_UNIX/PF_LOCAL protocol family
>> [    0.093413] NET: Registered PF_XDP protocol family
>> [    0.093509] PCI: CLS 128 bytes, default 128
>> [    0.093638] Unpacking initramfs...
>> [    0.094862] vio_register_device_node: node lid missing 'reg'
>> [    0.103665] vas: GZIP feature is available
>> [    0.104512] hv-24x7: read 548 catalog entries, created 387 event attrs (0 failures), 387 descs
>> [    0.108478] Initialise system trusted keyrings
>> [    0.108493] Key type blacklist registered
>> [    0.108560] workingset: timestamp_bits=38 max_order=23 bucket_order=0
>> [    0.108587] zbud: loaded
>> [    0.108988] integrity: Platform Keyring initialized
>> [    0.119068] NET: Registered PF_ALG protocol family
>> [    0.119083] Key type asymmetric registered
>> [    0.119086] Asymmetric key parser 'x509' registered
>> [    0.119120] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 247)
>> [    0.119182] io scheduler mq-deadline registered
>> [    0.119185] io scheduler kyber registered
>> [    0.119198] io scheduler bfq registered
>> [    0.120970] atomic64_test: passed
>> [    0.121210] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
>> [    0.121214] PowerPC PowerNV PCI Hotplug Driver version: 0.1
>> [    0.121532] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>> [    0.121728] Non-volatile memory driver v1.3
>> [    0.122174] rdac: device handler registered
>> [    0.122215] hp_sw: device handler registered
>> [    0.122218] emc: device handler registered
>> [    0.122260] alua: device handler registered
>> [    0.122450] usbcore: registered new interface driver usbserial_generic
>> [    0.122457] usbserial: USB Serial support registered for generic
>> [    0.122529] mousedev: PS/2 mouse device common for all mice
>> [    0.122644] rtc-generic rtc-generic: registered as rtc0
>> [    0.122676] rtc-generic rtc-generic: setting system clock to 2023-02-18T06:28:03 UTC (1676701683)
>> [    0.122755] xcede: xcede_record_size = 10
>> [    0.122758] xcede: Record 0 : hint = 1, latency = 0x1800 tb ticks, Wake-on-irq = 1
>> [    0.122765] xcede: Record 1 : hint = 2, latency = 0x3c00 tb ticks, Wake-on-irq = 0
>> [    0.122769] cpuidle: Skipping the 2 Extended CEDE idle states
>> [    0.122771] cpuidle: Fixed up CEDE exit latency to 12 us
>> [    0.123865] nx_compress_pseries ibm,compression-v1: nx842_OF_upd: max_sync_size new:65536 old:0
>> [    0.123871] nx_compress_pseries ibm,compression-v1: nx842_OF_upd: max_sync_sg new:510 old:0
>> [    0.123875] nx_compress_pseries ibm,compression-v1: nx842_OF_upd: max_sg_len new:4080 old:0
>> [    0.124018] hid: raw HID events driver (C) Jiri Kosina
>> [    0.124042] usbcore: registered new interface driver usbhid
>> [    0.124048] usbhid: USB HID core driver
>> [    0.124069] drop_monitor: Initializing network drop monitor service
>> [    0.134168] Initializing XFRM netlink socket
>> [    0.134234] NET: Registered PF_INET6 protocol family
>> [    0.134747] Segment Routing with IPv6
>> [    0.134756] In-situ OAM (IOAM) with IPv6
>> [    0.134776] NET: Registered PF_PACKET protocol family
>> [    0.134817] mpls_gso: MPLS GSO support
>> [    0.134836] secvar-sysfs: secvar: failed to retrieve secvar operations.
>> [    0.139134] registered taskstats version 1
>> [    0.140964] Loading compiled-in X.509 certificates
>> [    0.156881] Loaded X.509 cert 'Build time autogenerated kernel key: 7b04a1cdeda81c05f7a701657946db5548da6201'
>> [    0.157494] zswap: loaded using pool lzo/zbud
>> [    0.160050] page_owner is disabled
>> [    0.160226] pstore: Using crash dump compression: deflate
>> [    0.972073] Freeing initrd memory: 76160K
>> [    0.974020] Key type encrypted registered
>> [    0.974056] Secure boot mode disabled
>> [    0.974060] ima: No TPM chip found, activating TPM-bypass!
>> [    0.974067] Loading compiled-in module X.509 certificates
>> [    0.974567] Loaded X.509 cert 'Build time autogenerated kernel key: 7b04a1cdeda81c05f7a701657946db5548da6201'
>> [    0.974571] ima: Allocated hash algorithm: sha256
>> [    0.974598] Secure boot mode disabled
>> [    0.974615] Trusted boot mode disabled
>> [    0.974617] ima: No architecture policies found
>> [    0.974629] evm: Initialising EVM extended attributes:
>> [    0.974631] evm: security.selinux
>> [    0.974633] evm: security.SMACK64 (disabled)
>> [    0.974635] evm: security.SMACK64EXEC (disabled)
>> [    0.974637] evm: security.SMACK64TRANSMUTE (disabled)
>> [    0.974639] evm: security.SMACK64MMAP (disabled)
>> [    0.974641] evm: security.apparmor (disabled)
>> [    0.974642] evm: security.ima
>> [    0.974644] evm: security.capability
>> [    0.974646] evm: HMAC attrs: 0x1
>> [    0.974676] alg: No test for 842 (842-nx)
>> [    0.982519] Freeing unused kernel image (initmem) memory: 5440K
>> [    1.086157] Run /init as init process
>> [    1.092664] systemd[1]: systemd 239 (239-58.el8) running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=legacy)
>> [    1.092708] systemd[1]: Detected virtualization powervm.
>> [    1.092714] systemd[1]: Detected architecture ppc64-le.
>> [    1.092718] systemd[1]: Running in initial RAM disk.
>>
>> Welcome to Red Hat Enterprise Linux 8.6 (Ootpa) dracut-049-201.git20220131.el8 (Initramfs)!
>>
>> [    1.246394] systemd[1]: Set hostname to <ltcden3-lp1.aus.stglabs.ibm.com>.
>> [    1.321102] systemd[1]: Listening on Journal Socket.
>> [  OK  ] Listening on Journal Socket.
>> [    1.322421] systemd[1]: Started Hardware RNG Entropy Gatherer Daemon.
>> [  OK  ] Started Hardware RNG Entropy Gatherer Daemon.
>> [    1.323252] systemd[1]: Starting Create list of required static device nodes for the current kernel...
>>          Starting Create list of required st…ce nodes for the current kernel...
>> [    1.323333] systemd[1]: Reached target Local File Systems.
>> [  OK  ] Reached target Local File Systems.
>> [    1.324085] systemd[1]: Started Memstrack Anylazing Service.
>> [  OK  ] Started Memstrack Anylazing Service.
>> [  OK  ] Reached target Slices.
>> [  OK  ] Listening on udev Kernel Socket.
>> [  OK  ] Listening on Journal Socket (/dev/log).
>>          Starting Journal Service...
>>          Starting Create Volatile Files and Directories...
>> [  OK  ] Reached target Swap.
>> [  OK  ] Reached target Timers.
>>          Starting Setup Virtual Console...
>>          Starting Load Kernel Modules...
>> [  OK  ] Listening on udev Control Socket.
>> [  OK  ] Reached target Sockets.
>> [  OK  ] Started Create list of required sta…vice nodes for the current kernel.
>> [  OK  ] Started Create Volatile Files and Directories.
>>          Starting Create Static Device Nodes in /dev...
>> [FAILED] Failed to start Load Kernel Modules.
>> See 'systemctl status systemd-modules-load.service' for details.
>>          Starting Apply Kernel Variables...
>> [  OK  ] Started Create Static Device Nodes in /dev.
>> [  OK  ] Started Apply Kernel Variables.
>> [  OK  ] Started Journal Service.
>> [  OK  ] Started Setup Virtual Console.
>>          Starting dracut cmdline hook...
>> [  OK  ] Started dracut cmdline hook.
>>          Starting dracut pre-udev hook...
>> [    1.477216] device-mapper: core: CONFIG_IMA_DISABLE_HTABLE is disabled. Duplicate IMA measurements will not be recorded in the IMA log.
>> [    1.477252] device-mapper: uevent: version 1.0.3
>> [    1.477339] device-mapper: ioctl: 4.47.0-ioctl (2022-07-28) initialised: dm-devel@redhat.com
>> [  OK  ] Started dracut pre-udev hook.
>>          Starting udev Kernel Device Manager...
>> [  OK  ] Started udev Kernel Device Manager.
>>          Starting udev Coldplug all Devices...
>>          Mounting Kernel Configuration File System...
>> [  OK  ] Mounted Kernel Configuration File System.
>> [    1.651355] synth uevent: /devices/vio: failed to send uevent
>> [    1.651365] vio vio: uevent: failed to send synthetic uevent: -19
>> [    1.651402] synth uevent: /devices/vio/4000: failed to send uevent
>> [    1.651406] vio 4000: uevent: failed to send synthetic uevent: -19
>> [    1.651415] synth uevent: /devices/vio/4001: failed to send uevent
>> [    1.651418] vio 4001: uevent: failed to send synthetic uevent: -19
>> [    1.651428] synth uevent: /devices/vio/4002: failed to send uevent
>> [    1.651431] vio 4002: uevent: failed to send synthetic uevent: -19
>> [    1.651441] synth uevent: /devices/vio/4004: failed to send uevent
>> [    1.651444] vio 4004: uevent: failed to send synthetic uevent: -19
>> [  OK  ] Started udev Coldplug all Devices.
>> [  OK  ] Reached target System Initialization.
>>          Starting Show Plymouth Boot Screen...
>>          Starting dracut initqueue hook...
>> [  OK  ] Started Show Plymouth Boot Screen.
>> [  OK  ] Started Forward Password Requests to Plymouth Directory Watch.
>> [  OK  ] Reached target Paths.
>> [  OK  ] Reached target Basic System.
>> [    1.709851] ibmveth 30000002 net0: renamed from eth0
>> [    1.712196] nvme nvme0: pci function 0019:01:00.0
>> [    1.714161] ibmvscsi 30000065: SRP_VERSION: 16.a
>> [    1.714223] ibmvscsi 30000065: Maximum ID: 64 Maximum LUN: 32 Maximum Channel: 3
>> [    1.714227] scsi host0: IBM POWER Virtual SCSI Adapter 1.5.9
>> [    1.714365] ibmvscsi 30000065: partner initialization complete
>> [    1.714391] ibmvscsi 30000065: host srp version: 16.a, host partition ltcden3-vios1 (100), OS 3, max io 524288
>> [    1.714421] ibmvscsi 30000065: Client reserve enabled
>> [    1.714426] ibmvscsi 30000065: sent SRP login
>> [    1.714448] ibmvscsi 30000065: SRP_LOGIN succeeded
>> [    1.721611] nvme nvme0: Shutdown timeout set to 8 seconds
>> [    1.737117] scsi 0:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
>> [    1.738038] scsi 0:0:2:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
>> [    1.738364] scsi 0:0:3:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
>> [    1.750754] nvme nvme0: 32/0/0 default/read/poll queues
>> [    1.754482]  nvme0n1: p1 p2 p3
>> [    1.772868] scsi 0:0:1:0: Attached scsi generic sg0 type 0
>> [    1.772898] scsi 0:0:2:0: Attached scsi generic sg1 type 0
>> [    1.772920] scsi 0:0:3:0: Attached scsi generic sg2 type 0
>> [    1.794722] sd 0:0:2:0: [sda] 629145600 512-byte logical blocks: (322 GB/300 GiB)
>> [    1.794757] sd 0:0:2:0: [sda] Write Protect is off
>> [    1.794758] sd 0:0:1:0: [sdb] 209715200 512-byte logical blocks: (107 GB/100 GiB)
>> [    1.794790] sd 0:0:2:0: [sda] Cache data unavailable
>> [    1.794792] sd 0:0:1:0: [sdb] Write Protect is off
>> [    1.794796] sd 0:0:2:0: [sda] Assuming drive cache: write through
>> [    1.794826] sd 0:0:1:0: [sdb] Cache data unavailable
>> [    1.794829] sd 0:0:1:0: [sdb] Assuming drive cache: write through
>> [    1.794943] sd 0:0:3:0: [sdc] 91750400 4096-byte logical blocks: (376 GB/350 GiB)
>> [    1.794979] sd 0:0:3:0: [sdc] Write Protect is off
>> [    1.795008] sd 0:0:3:0: [sdc] Cache data unavailable
>> [    1.795011] sd 0:0:3:0: [sdc] Assuming drive cache: write through
>> [    1.796625]  sdb: sdb1 sdb2 sdb3
>> [    1.796717]  sdc: sdc1
>> [    1.796720]  sda: sda1 sda2
>> [    1.796752] sd 0:0:1:0: [sdb] Attached SCSI disk
>> [    1.796820] sd 0:0:3:0: [sdc] Attached SCSI disk
>> [    1.796841] sd 0:0:2:0: [sda] Attached SCSI disk
>> [  OK  ] Found device /dev/mapper/rhel_ltcden3--lp1-root.
>> [  OK  ] Reached target Initrd Root Device.
>> [  OK  ] Started dracut initqueue hook.
>>          Starting File System Check on /dev/mapper/rhel_ltcden3--lp1-root...
>> [  OK  ] Reached target Remote File Systems (Pre).
>> [  OK  ] Reached target Remote File Systems.
>> [  OK  ] Started File System Check on /dev/mapper/rhel_ltcden3--lp1-root.
>>          Mounting /sysroot...
>> [    3.060638] SGI XFS with ACLs, security attributes, quota, no debug enabled
>> [    3.062369] XFS (dm-0): Mounting V5 Filesystem 7b801289-75a7-4d39-8cd3-24526e9e9da7
>> [    3.109076] XFS (dm-0): Ending clean mount
>> [  OK  ] Mounted /sysroot.
>> [  OK  ] Reached target Initrd Root File System.
>>          Starting Reload Configuration from the Real Root...
>> [  OK  ] Started Reload Configuration from the Real Root.
>> [  OK  ] Reached target Initrd File Systems.
>> [  OK  ] Reached target Initrd Default Target.
>>          Starting dracut pre-pivot and cleanup hook...
>> [  OK  ] Started dracut pre-pivot and cleanup hook.
>>          Starting Cleaning Up and Shutting Down Daemons...
>> [  OK  ] Stopped dracut pre-pivot and cleanup hook.
>> [  OK  ] Stopped target Remote File Systems.
>> [  OK  ] Stopped target Initrd Default Target.
>> [  OK  ] Stopped target Timers.
>> [  OK  ] Stopped target Initrd Root Device.
>> [  OK  ] Stopped target Remote File Systems (Pre).
>> [  OK  ] Stopped dracut initqueue hook.
>>          Starting Setup Virtual Console...
>> [  OK  ] Stopped target Basic System.
>> [  OK  ] Stopped target System Initialization.
>> [  OK  ] Stopped Create Volatile Files and Directories.
>> [  OK  ] Stopped Apply Kernel Variables.
>> [  OK  ] Stopped udev Coldplug all Devices.
>>          Stopping udev Kernel Device Manager...
>> [  OK  ] Stopped target Swap.
>> [  OK  ] Stopped target Paths.
>> [  OK  ] Stopped target Sockets.
>> [  OK  ] Stopped target Slices.
>>          Starting Plymouth switch root service...
>> [  OK  ] Stopped target Local File Systems.
>> [  OK  ] Started Cleaning Up and Shutting Down Daemons.
>> [  OK  ] Started Plymouth switch root service.
>> [  OK  ] Started Setup Virtual Console.
>> [  OK  ] Stopped udev Kernel Device Manager.
>> [  OK  ] Stopped Create Static Device Nodes in /dev.
>> [  OK  ] Stopped Create list of required sta…vice nodes for the current kernel.
>>          Stopping Hardware RNG Entropy Gatherer Daemon...
>> [  OK  ] Stopped dracut pre-udev hook.
>> [  OK  ] Stopped dracut cmdline hook.
>> [  OK  ] Closed udev Control Socket.
>> [  OK  ] Closed udev Kernel Socket.
>>          Starting Cleanup udevd DB...
>> [  OK  ] Stopped Hardware RNG Entropy Gatherer Daemon.
>> [  OK  ] Started Cleanup udevd DB.
>> [  OK  ] Reached target Switch Root.
>>          Starting Switch Root...
>> [    3.449370] printk: systemd: 22 output lines suppressed due to ratelimiting
>> [    3.593463] SELinux:  Runtime disable is deprecated, use selinux=0 on the kernel cmdline.
>> [    3.593471] SELinux:  https://github.com/SELinuxProject/selinux-kernel/wiki/DEPRECATE-runtime-disable
>> [   19.036134] SELinux:  Disabled at runtime.
>> [   19.196154] audit: type=1404 audit(1676701702.570:2): enforcing=0 old_enforcing=0 auid=4294967295 ses=4294967295 enabled=0 old-enabled=1 lsm=selinux res=1
>> [   19.201608] systemd[1]: systemd 239 (239-58.el8) running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=legacy)
>> [   19.201637] systemd[1]: Detected virtualization powervm.
>> [   19.201642] systemd[1]: Detected architecture ppc64-le.
>>
>> Welcome to Red Hat Enterprise Linux 8.6 (Ootpa)!
>>
>> [   19.202637] systemd[1]: Set hostname to <ltcden3-lp1.aus.stglabs.ibm.com>.
>> [   21.777702] systemd[1]: systemd-journald.service: Succeeded.
>> [   21.778191] systemd[1]: initrd-switch-root.service: Succeeded.
>> [   21.778387] systemd[1]: Stopped Switch Root.
>> [  OK  ] Stopped Switch Root.
>> [   21.778748] systemd[1]: systemd-journald.service: Service has no hold-off time (RestartSec=0), scheduling restart.
>> [   21.778795] systemd[1]: systemd-journald.service: Scheduled restart job, restart counter is at 1.
>> [   21.778847] systemd[1]: Stopped Journal Service.
>> [  OK  ] Stopped Journal Service.
>>          Starting Journal Service...
>> [  OK  ] Stopped Plymouth switch root service.
>> [  OK  ] Stopped target Switch Root.
>> [  OK  ] Listening on udev Kernel Socket.
>> [  OK  ] Listening on initctl Compatibility Named Pipe.
>> [  OK  ] Listening on Process Core Dump Socket.
>>          Mounting Huge Pages File System...
>>          Starting Load Kernel Modules...
>>          Starting Read and set NIS domainname from /etc/sysconfig/network...
>>          Activating swap /dev/mapper/rhel_ltcden3--lp1-swap...
>> [  OK  ] Created slice system-serial\x2dgetty.slice.
>> [  OK  ] Created slice system-getty.slice.
>>          Starting Create list of required st…ce nodes for the current kernel...
>> [  OK  ] Created slice User and Session Slice.
>> [  OK  ] Reached target Slices.
>> [  OK  ] Listening on RPCbind Server Activation Socket.
>> [  OK  ] Reached target RPC Port Mapper.
>>          Mounting POSIX Message Queue File System...
>> [  OK  ] Stopped File System Check on Root Device.
>>          Starting Remount Root and Kernel File Systems...
>> [  OK  ] Started Forward Password Requests to Wall Directory Watch.
>> [  OK  ] Reached target Local Encrypted Volumes.
>> [   21.912238] Adding 4194240k swap on /dev/mapper/rhel_ltcden3--lp1-swap.  Priority:-2 extents:1 across:4194240k FS
>> [  OK  ] Listening on Device-mapper event daemon FIFOs.
>>          Starting Monitoring of LVM2 mirrors…ng dmeventd or progress polling...
>>          Starting Setup Virtual Console...
>> [  OK  ] Stopped target Initrd Root File System.
>>          Mounting Kernel Debug File System...
>> [  OK  ] Listening on udev Control Socket.
>>          Starting udev Coldplug all Devices...
>> [  OK  ] Created slice system-sshd\x2dkeygen.slice.
>> [  OK  ] Stopped target Initrd File Systems.
>> [  OK  ] Listening on LVM2 poll daemon socket.
>> [  OK  ] Activated swap /dev/mapper/rhel_ltcden3--lp1-swap.
>> [  OK  ] Mounted Huge Pages File System.
>> [  OK  ] Started Read and set NIS domainname from /etc/sysconfig/network.
>> [  OK  ] Started Create list of required sta…vice nodes for the current kernel.
>> [  OK  ] Started Journal Service.
>> [  OK  ] Mounted POSIX Message Queue File System.
>> [  OK  ] Mounted Kernel Debug File System.
>> [  OK  ] Reached target Swap.
>> [   22.217261] xfs filesystem being remounted at / supports timestamps until 2038 (0x7fffffff)
>> [  OK  ] Started Remount Root and Kernel File Systems.
>> [  OK  ] Started Monitoring of LVM2 mirrors,…sing dmeventd or progress polling.
>>          Starting Create Static Device Nodes in /dev...
>>          Starting Load/Save Random Seed...
>>          Starting Flush Journal to Persistent Storage...
>> [FAILED] Failed to start Load Kernel Modules.
>> See 'systemctl status systemd-modules-load.service' for details.
>>          Starting Apply Kernel Variables...
>> [   22.341308] synth uevent: /devices/vio: failed to send uevent
>> [   22.341317] vio vio: uevent: failed to send synthetic uevent: -19
>> [   22.341597] synth uevent: /devices/vio/4000: failed to send uevent
>> [   22.341600] vio 4000: uevent: failed to send synthetic uevent: -19
>> [   22.341610] synth uevent: /devices/vio/4001: failed to send uevent
>> [   22.341613] vio 4001: uevent: failed to send synthetic uevent: -19
>> [   22.341622] synth uevent: /devices/vio/4002: failed to send uevent
>> [   22.341625] vio 4002: uevent: failed to send synthetic uevent: -19
>> [   22.341633] synth uevent: /devices/vio/4004: failed to send uevent
>> [   22.341636] vio 4004: uevent: failed to send synthetic uevent: -19
>> [  OK  ] Started udev Coldplug all Devices.
>>          Starting udev Wait for Complete Device Initialization...
>> [  OK  ] Started Load/Save Random Seed.
>> [  OK  ] Started Flush Journal to Persistent Storage.
>> [  OK  ] Started Setup Virtual Console.
>> [  OK  ] Started Apply Kernel Variables.
>> [  OK  ] Started Create Static Device Nodes in /dev.
>>          Starting udev Kernel Device Manager...
>> [  OK  ] Started udev Kernel Device Manager.
>> [   24.100485] pseries_rng: Registering IBM pSeries RNG driver
>> [  OK  ] Created slice system-lvm2\x2dpvscan.slice.
>>          Starting LVM event activation on device 8:19...
>> [  OK  ] Started LVM event activation on device 8:19.
>> [  OK  ] Started udev Wait for Complete Device Initialization.
>> [  OK  ] Reached target Local File Systems (Pre).
>>          Mounting /home...
>>          Mounting /home2...
>>          Mounting /boot...
>> [   25.049055] XFS (nvme0n1p1): Mounting V5 Filesystem 31458cd5-8eb4-48b4-8f5a-112217ef59df
>> [   25.049822] XFS (dm-1): Mounting V5 Filesystem 0ac3d742-375d-4cd7-bdd2-72b0559b1957
>> [   25.050953] XFS (sdb2): Mounting V5 Filesystem c72725b8-35e3-42b4-b5cb-f8435cada964
>> [   25.055813] XFS (nvme0n1p1): Ending clean mount
>> [   25.056844] xfs filesystem being mounted at /home supports timestamps until 2038 (0x7fffffff)
>> [  OK  ] Mounted /home.
>> [   25.389921] XFS (dm-1): Ending clean mount
>> [   25.513566] xfs filesystem being mounted at /home2 supports timestamps until 2038 (0x7fffffff)
>> [  OK  ] Mounted /home2.
>> [   26.797307] XFS (sdb2): Ending clean mount
>> [   26.857340] xfs filesystem being mounted at /boot supports timestamps until 2038 (0x7fffffff)
>> [  OK  ] Mounted /boot.
>> [  OK  ] Reached target Local File Systems.
>>          Starting Tell Plymouth To Write Out Runtime Data...
>>          Starting Restore /run/initramfs on shutdown...
>>          Starting Import network configuration from initramfs...
>> [  OK  ] Started Restore /run/initramfs on shutdown.
>> [  OK  ] Started Import network configuration from initramfs.
>>          Starting Create Volatile Files and Directories...
>> [  OK  ] Started Tell Plymouth To Write Out Runtime Data.
>> [  OK  ] Started Create Volatile Files and Directories.
>>          Mounting RPC Pipe File System...
>>          Starting Security Auditing Service...
>>          Starting RPC Bind...
>> [  OK  ] Started RPC Bind.
>> [   27.888702] RPC: Registered named UNIX socket transport module.
>> [   27.888714] RPC: Registered udp transport module.
>> [   27.888717] RPC: Registered tcp transport module.
>> [   27.888719] RPC: Registered tcp NFSv4.1 backchannel transport module.
>> [  OK  ] Mounted RPC Pipe File System.
>> [  OK  ] Reached target rpc_pipefs.target.
>> [  OK  ] Started Security Auditing Service.
>>          Starting Update UTMP about System Boot/Shutdown...
>> [  OK  ] Started Update UTMP about System Boot/Shutdown.
>> [  OK  ] Reached target System Initialization.
>> [  OK  ] Listening on Open-iSCSI iscsid Socket.
>> [  OK  ] Listening on CUPS Scheduler.
>> [  OK  ] Started Run system activity accounting tool every 10 minutes.
>> [  OK  ] Started CUPS Scheduler.
>> [  OK  ] Reached target Paths.
>> [  OK  ] Listening on SSSD Kerberos Cache Manager responder socket.
>> [  OK  ] Listening on D-Bus System Message Bus Socket.
>> [  OK  ] Started Generate summary of yesterday's process accounting.
>> [  OK  ] Started daily update of the root trust anchor for DNSSEC.
>> [  OK  ] Started Daily Cleanup of Temporary Directories.
>> [  OK  ] Started dnf makecache --timer.
>> [  OK  ] Reached target Timers.
>> [  OK  ] Listening on Open-iSCSI iscsiuio Socket.
>> [  OK  ] Listening on Avahi mDNS/DNS-SD Stack Activation Socket.
>> [  OK  ] Reached target Sockets.
>> [  OK  ] Reached target Basic System.
>>          Starting NTP client/server...
>>          Starting Hardware RNG Entropy Gatherer Wake threshold service...
>> [  OK  ] Started libstoragemgmt plug-in server daemon.
>> [  OK  ] Started irqbalance daemon.
>>          Starting Resets System Activity Logs...
>>          Starting ppc64-diag rtas_errd (platform error handling) Service...
>>          Starting Self Monitoring and Reporting Technology (SMART) Daemon...
>> [  OK  ] Reached target sshd-keygen.target.
>>          Starting ABRT Automated Bug Reporting Tool...
>>          Starting System Security Services Daemon...
>>          Starting Authorization Manager...
>> [  OK  ] Started D-Bus System Message Bus.
>>          Starting Avahi mDNS/DNS-SD Stack...
>> [  OK  ] Started Hardware RNG Entropy Gatherer Wake threshold service.
>> [  OK  ] Started Hardware RNG Entropy Gatherer Daemon.
>> [  OK  ] Started Self Monitoring and Reporting Technology (SMART) Daemon.
>> [  OK  ] Started Resets System Activity Logs.
>> [  OK  ] Started ppc64-diag rtas_errd (platform error handling) Service.
>> [  OK  ] Started Avahi mDNS/DNS-SD Stack.
>> [  OK  ] Started NTP client/server.
>> [  OK  ] Started System Security Services Daemon.
>> [  OK  ] Reached target User and Group Name Lookups.
>>          Starting Login Service...
>> [  OK  ] Started Login Service.
>> [  OK  ] Started Authorization Manager.
>>          Starting firewalld - dynamic firewall daemon...
>>          Starting Modem Manager...
>> [  OK  ] Started Modem Manager.
>> [  OK  ] Started firewalld - dynamic firewall daemon.
>> [  OK  ] Reached target Network (Pre).
>>          Starting Network Manager...
>> [  OK  ] Started Network Manager.
>>          Starting hybrid virtual network scan and config...
>>          Starting Network Manager Wait Online...
>> [  OK  ] Reached target Network.
>>          Starting Enable periodic update of entitlement certificates....
>>          Starting CUPS Scheduler...
>>          Starting GSSAPI Proxy Daemon...
>>          Starting OpenSSH server daemon...
>>          Starting Logout off all iSCSI sessions on shutdown...
>> [  OK  ] Started Logout off all iSCSI sessions on shutdown.
>> [  OK  ] Started Enable periodic update of entitlement certificates..
>>          Starting Hostname Service...
>> [  OK  ] Started ABRT Automated Bug Reporting Tool.
>> [  OK  ] Started ABRT kernel log watcher.
>> [  OK  ] Started ABRT Xorg log watcher.
>> [  OK  ] Started Creates ABRT problems from coredumpctl messages.
>> [  OK  ] Started Hostname Service.
>> [  OK  ] Listening on Load/Save RF Kill Switch Status /dev/rfkill Watch.
>> [FAILED] Failed to start hybrid virtual network scan and config.
>> See 'systemctl status hcn-init.service' for details.
>> [  OK  ] Started OpenSSH server daemon.
>> [  OK  ] Started GSSAPI Proxy Daemon.
>> [  OK  ] Reached target NFS client services.
>>          Starting Network Manager Script Dispatcher Service...
>> [  OK  ] Started CUPS Scheduler.
>> [  OK  ] Started Network Manager Script Dispatcher Service.
>> [  OK  ] Started Network Manager Wait Online.
>> [  OK  ] Reached target Network is Online.
>>          Starting Notify NFS peers of a restart...
>> [  OK  ] Reached target Remote File Systems (Pre).
>> [  OK  ] Reached target Remote File Systems.
>>          Starting Harvest vmcores for ABRT...
>>          Starting Permit User Sessions...
>>          Starting System Logging Service...
>> [  OK  ] Started Notify NFS peers of a restart.
>> [  OK  ] Started Permit User Sessions.
>> [  OK  ] Started Job spooling tools.
>>          Starting Terminate Plymouth Boot Screen...
>> [  OK  ] Started Command Scheduler.
>>          Starting Hold until boot process finishes up...
>> [  OK  ] Started System Logging Service.
>> [   44.801795] ------------[ cut here ]------------
>> [   44.801810] WARNING: CPU: 24 PID: 1906 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
>> [   44.801895] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set rfkill nf_tables nfnetlink sunrpc pseries_rng xts vmx_crypto xfs libcrc32c sd_mod sg ibmvscsi nvme ibmveth scsi_transport_srp nvme_core t10_pi crc64_rocksoft crc64 dm_mirror dm_region_hash dm_log dm_mod
>> [   44.801926] CPU: 24 PID: 1906 Comm: in:imjournal Not tainted 6.2.0-rc8ssh #35
>> [   44.801930] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
>> [   44.801933] NIP:  c00800000062fa80 LR: c00800000062fa4c CTR: c000000000ea4d40
>> [   44.801936] REGS: c00000001984b690 TRAP: 0700   Not tainted  (6.2.0-rc8ssh)
>> [   44.801939] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24224842  XER: 00000000
>> [   44.801947] CFAR: c00800000062fa54 IRQMASK: 0
>> [   44.801947] GPR00: c0000000091cbec8 c00000001984b930 c0080000006d8300 0000000000000000
>> [   44.801947] GPR04: 00000000002ec44d 0000000000000000 0000000000000000 c000000051aa4d90
>> [   44.801947] GPR08: 0000000000000000 c000000051aa4e40 0000000000000000 fffffffffffffffd
>> [   44.801947] GPR12: 0000000000000040 c000004afece5880 0000000000000000 0000000004000000
>> [   44.801947] GPR16: c00000001984bb38 c00000001984ba38 c00000001984ba68 c00000002c323c00
>> [   44.801947] GPR20: c0000000091cbe00 0000000000008000 c0000000516e5800 00000000002ec44d
>> [   44.801947] GPR24: 000000000030af4d 000000000000000d c000000008d71680 00000000002ec44d
>> [   44.801947] GPR28: c00000002c322400 c0000000091cbe00 c000000054c05618 000000000030af4d
>> [   44.801983] NIP [c00800000062fa80] xfs_iunlink_lookup+0x58/0x80 [xfs]
>> [   44.802037] LR [c00800000062fa4c] xfs_iunlink_lookup+0x24/0x80 [xfs]
>> [   44.802090] Call Trace:
>> [   44.802091] [c00000001984b930] [c000000054c05618] 0xc000000054c05618 (unreliable)
>> [   44.802096] [c00000001984b950] [c008000000630094] xfs_iunlink+0x1bc/0x280 [xfs]
>> [   44.802149] [c00000001984b9d0] [c008000000634754] xfs_rename+0x69c/0xd10 [xfs]
>> [   44.802202] [c00000001984bb10] [c00800000062e020] xfs_vn_rename+0xf8/0x1f0 [xfs]
>> [   44.802255] [c00000001984bba0] [c000000000579efc] vfs_rename+0x9bc/0xdf0
>> [   44.802261] [c00000001984bc90] [c00000000058018c] do_renameat2+0x3dc/0x5c0
>> [   44.802265] [c00000001984bde0] [c000000000580520] sys_rename+0x60/0x80
>> [   44.802269] [c00000001984be10] [c000000000033630] system_call_exception+0x150/0x3b0
>> [   44.802274] [c00000001984be50] [c00000000000c554] system_call_common+0xf4/0x258
>> [   44.802280] --- interrupt: c00 at 0x7fffa6482e20
>> [   44.802282] NIP:  00007fffa6482e20 LR: 00007fffa6055e24 CTR: 0000000000000000
>> [   44.802285] REGS: c00000001984be80 TRAP: 0c00   Not tainted  (6.2.0-rc8ssh)
>> [   44.802288] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 2a082202  XER: 00000000
>> [   44.802297] IRQMASK: 0
>> [   44.802297] GPR00: 0000000000000026 00007fffa536d220 00007fffa6607300 00007fffa536d288
>> [   44.802297] GPR04: 000000014f7a6b70 0000000000000000 0700000000000000 0000000000000002
>> [   44.802297] GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>> [   44.802297] GPR12: 0000000000000000 00007fffa53766e0 000000014f795930 0000000000000000
>> [   44.802297] GPR16: 0000000126b67648 00007fffa6057ce0 0000000000000003 000000000000002b
>> [   44.802297] GPR20: 0000000000000212 00007fffa536e3a0 00007fffa536e398 00007fff98008690
>> [   44.802297] GPR24: 0000000000000000 00007fffa536e388 00007fffa536e378 00007fffa536e3b0
>> [   44.802297] GPR28: 00007fffa6070000 00007fffa60705e0 00007fff98000c10 00007fffa536d288
>> [   44.802331] NIP [00007fffa6482e20] 0x7fffa6482e20
>> [   44.802334] LR [00007fffa6055e24] 0x7fffa6055e24
>> [   44.802336] --- interrupt: c00
>> [   44.802338] Code: 2c230000 4182002c e9230020 2fa90000 419e0020 38210020 e8010010 7c0803a6 4e800020 60000000 60000000 60000000 <0fe00000> 60000000 60000000 60000000
>> [   44.802352] ---[ end trace 0000000000000000 ]---
>> [   44.802356] XFS (dm-0): Internal error xfs_trans_cancel at line 1097 of file fs/xfs/xfs_trans.c.  Caller xfs_rename+0x9cc/0xd10 [xfs]
>> [   44.802412] CPU: 24 PID: 1906 Comm: in:imjournal Tainted: G        W          6.2.0-rc8ssh #35
>> [   44.802415] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
>> [   44.802418] Call Trace:
>> [   44.802420] [c00000001984b8f0] [c000000000e87328] dump_stack_lvl+0x6c/0x9c (unreliable)
>> [   44.802425] [c00000001984b920] [c008000000616a84] xfs_error_report+0x5c/0x80 [xfs]
>> [   44.802478] [c00000001984b980] [c0080000006467b0] xfs_trans_cancel+0x178/0x1b0 [xfs]
>> [   44.802533] [c00000001984b9d0] [c008000000634a84] xfs_rename+0x9cc/0xd10 [xfs]
>> [   44.802586] [c00000001984bb10] [c00800000062e020] xfs_vn_rename+0xf8/0x1f0 [xfs]
>> [   44.802641] [c00000001984bba0] [c000000000579efc] vfs_rename+0x9bc/0xdf0
>> [   44.802644] [c00000001984bc90] [c00000000058018c] do_renameat2+0x3dc/0x5c0
>> [   44.802648] [c00000001984bde0] [c000000000580520] sys_rename+0x60/0x80
>> [   44.802652] [c00000001984be10] [c000000000033630] system_call_exception+0x150/0x3b0
>> [   44.802657] [c00000001984be50] [c00000000000c554] system_call_common+0xf4/0x258
>> [   44.802661] --- interrupt: c00 at 0x7fffa6482e20
>> [   44.802664] NIP:  00007fffa6482e20 LR: 00007fffa6055e24 CTR: 0000000000000000
>> [   44.802667] REGS: c00000001984be80 TRAP: 0c00   Tainted: G        W           (6.2.0-rc8ssh)
>> [   44.802670] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 2a082202  XER: 00000000
>> [   44.802678] IRQMASK: 0
>> [   44.802678] GPR00: 0000000000000026 00007fffa536d220 00007fffa6607300 00007fffa536d288
>> [   44.802678] GPR04: 000000014f7a6b70 0000000000000000 0700000000000000 0000000000000002
>> [   44.802678] GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>> [   44.802678] GPR12: 0000000000000000 00007fffa53766e0 000000014f795930 0000000000000000
>> [   44.802678] GPR16: 0000000126b67648 00007fffa6057ce0 0000000000000003 000000000000002b
>> [   44.802678] GPR20: 0000000000000212 00007fffa536e3a0 00007fffa536e398 00007fff98008690
>> [   44.802678] GPR24: 0000000000000000 00007fffa536e388 00007fffa536e378 00007fffa536e3b0
>> [   44.802678] GPR28: 00007fffa6070000 00007fffa60705e0 00007fff98000c10 00007fffa536d288
>> [   44.802712] NIP [00007fffa6482e20] 0x7fffa6482e20
>> [   44.802715] LR [00007fffa6055e24] 0x7fffa6055e24
>> [   44.802717] --- interrupt: c00
>> [   44.804354] XFS (dm-0): Corruption of in-memory data (0x8) detected at xfs_trans_cancel+0x190/0x1b0 [xfs] (fs/xfs/xfs_trans.c:1098).  Shutting down filesystem.
>> [   44.804413] XFS (dm-0): Please unmount the filesystem and rectify the problem(s)
>>
>>
>>
>> >> [  333.390615] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink rfkill sunrpc pseries_rng xts vmx_crypto xfs libcrc32c sd_mod sg ibmvscsi ibmveth scsi_transport_srp nvme nvme_core t10_pi crc64_rocksoft crc64 dm_mirror dm_region_hash dm_log dm_mod
>> >> [  333.390645] CPU: 56 PID: 12450 Comm: rm Not tainted 6.2.0-rc4ssh+ #4
>> >> [  333.390649] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
>> >> [  333.390652] NIP:  c0080000004bfa80 LR: c0080000004bfa4c CTR: c000000000ea28d0
>> >> [  333.390655] REGS: c0000000442bb8c0 TRAP: 0700   Not tainted  (6.2.0-rc4ssh+)
>> >> [  333.390658] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24002842  XER: 00000000
>> >> [  333.390666] CFAR: c0080000004bfa54 IRQMASK: 0
>> >> [  333.390666] GPR00: c00000003b69c0c8 c0000000442bbb60 c008000000568300 0000000000000000
>> >> [  333.390666] GPR04: 00000000002ec44d 0000000000000000 0000000000000000 c000000004b27d78
>> >> [  333.390666] GPR08: 0000000000000000 c000000004b27e28 0000000000000000 fffffffffffffffd
>> >> [  333.390666] GPR12: 0000000000000040 c000004afecc5880 0000000106620918 0000000000000001
>> >> [  333.390666] GPR16: 000000010bd36e10 0000000106620dc8 0000000106620e58 0000000106620e90
>> >> [  333.390666] GPR20: 0000000106620e30 c0000000880ba938 0000000000200000 00000000002ec44d
>> >> [  333.390666] GPR24: 000000000008170d 000000000000000d c0000000519f4800 00000000002ec44d
>> >> [  333.390666] GPR28: c0000000880ba800 c00000003b69c000 c0000000833edd20 000000000008170d
>> >> [  333.390702] NIP [c0080000004bfa80] xfs_iunlink_lookup+0x58/0x80 [xfs]
>> >> [  333.390756] LR [c0080000004bfa4c] xfs_iunlink_lookup+0x24/0x80 [xfs]
>> >> [  333.390810] Call Trace:
>> >> [  333.390811] [c0000000442bbb60] [c0000000833edd20] 0xc0000000833edd20 (unreliable)
>> >> [  333.390816] [c0000000442bbb80] [c0080000004c0094] xfs_iunlink+0x1bc/0x280 [xfs]
>> >> [  333.390869] [c0000000442bbc00] [c0080000004c3f84] xfs_remove+0x1dc/0x310 [xfs]
>> >> [  333.390922] [c0000000442bbc70] [c0080000004be180] xfs_vn_unlink+0x68/0xf0 [xfs]
>> >> [  333.390975] [c0000000442bbcd0] [c000000000576b24] vfs_unlink+0x1b4/0x3d0
>> >
>> > ...that trips when rm tries to remove a file, which means that the call
>> > stack is
>> >
>> > xfs_remove -> xfs_iunlink -> xfs_iunlink_insert_inode ->
>> > xfs_iunlink_update_backref -> xfs_iunlink_lookup <kaboom>
>> >
>> > It looks as though "rm foo" unlinked foo from the directory and was
>> > trying to insert it at the head of one of the unlinked lists in the AGI
>> > buffer.  The AGI claims that the list points to an ondisk inode, so the
>> > iunlink code tries to find the incore inode to update the incore list,
>> > fails to find an incore inode, and this is the result...
>>
>> This seems to happen for rename as well. i.e xfs_rename.
>> Does  rename path calls rm first, and then create?
>
> Effectively, yes.  A "mv a b" will unlink b, and that calls the same
> internal unlink code as an unlink syscall.
>
>> >>
>> >>
>> >> we did a git bisect between 5.17 and 6.0. Bisect points to commit 04755d2e5821
>> >> as the bad commit.
>> >> Short description of commit:
>> >> commit 04755d2e5821b3afbaadd09fe5df58d04de36484 (refs/bisect/bad)
>> >> Author: Dave Chinner <dchinner@redhat.com>
>> >> Date:   Thu Jul 14 11:42:39 2022 +1000
>> >>
>> >>     xfs: refactor xlog_recover_process_iunlinks()
>> >
>> > ...which was in the middle of the series that reworked thev mount time
>> > iunlink clearing.  Oddly, I don't spot any obvious errors in /that/
>> > patch that didn't already exist.  But this does make me wonder, does
>> > xfs_repair -n have anything to say about unlinked or orphaned inodes?
>> >
>> > The runtime code expects that every ondisk inode in an iunlink chain has
>> > an incore inode that is linked (via i_{next,prev}_unlinked) to the other
>> > incore inodes in that same chain.  If this requirement is not met, then
>> > the WARNings you see will trip, and the fs shuts down.
>> >
>> > My hypothesis here is that one of the AGs has an unprocessed unlinked
>> > list.  At mount time, the ondisk log was clean, so mount time log
>> > recovery didn't invoke xlog_recover_process_iunlinks, and the list was
>> > not cleared.  The mount code does not construct the incore unlinked list
>> > from an existing ondisk iunlink list, hence the WARNing.  Prior to 5.17,
>> > we only manipulated the ondisk unlink list, and the code never noticed
>> > or cared if there were mystery inodes in the list that never went away.
>> >
>> > (Obviously, if something blew up earlier in dmesg, that would be
>> > relevant here.)
>> >
>> > It's possible that we could end up in this situation (clean log,
>> > unlinked inodes) if a previous log recovery was only partially
>> > successful at clearing the unlinked list, since all that code ignores
>> > errors.  If that happens, we ... succeed at mounting and clean the log.
>> >
>> > If you're willing to patch your kernels, it would be interesting
>> > to printk if the xfs_read_agi or the xlog_recover_iunlink_bucket calls
>> > in xlog_recover_iunlink_ag returns an error code.  It might be too late
>>
>> We can try. Please provide the Patch.
>>
>> > to capture that, hence my suggestion of seeing if xfs_repair -n will
>> > tell us anything else.
>> >
>>
>> Could you please clarify? We should run xfs_repair -n from 5.17-rc2 kernel?
>
> Whatever xfs_repair is installed on the system should suffice to report
> an unlinked inode list and any other errors on the filesystem.
>

Hi Darrick,

Please find the information collected from the system. We added some
debug logs and looks like it is exactly what is happening which you
pointed out.

We added a debug kernel patch to get more info from the system which
you had requested [1]

1. We first breaked into emergency shell where root fs is first getting
mounted on /sysroot as "ro" filesystem. Here are the logs.

[  OK  ] Started File System Check on /dev/mapper/rhel_ltcden3--lp1-root.
         Mounting /sysroot...
[    7.203990] SGI XFS with ACLs, security attributes, quota, no debug enabled
[    7.205835] XFS (dm-0): Mounting V5 Filesystem 7b801289-75a7-4d39-8cd3-24526e9e9da7
[   ***] A start job is running for /sysroot (15s / 1min 35s)[   17.439377] XFS (dm-0): Starting recovery (logdev: internal)
[  *** ] A start job is running for /sysroot (16s / 1min 35s)[   17.771158] xfs_log_mount_finish: Recovery needed is set
[   17.771172] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:0
[   17.771179] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:1
[   17.771184] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:2
[   17.771190] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:3
[   17.771196] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:4
[   17.771201] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:5
[   17.801033] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:6
[   17.801041] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:7
[   17.801046] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:8
[   17.801052] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:9
[   17.801057] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:10
[   17.801063] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:11
[   17.801068] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:12
[   17.801272] xlog_recover_iunlink_bucket: bucket: 13, agino: 3064909, ino: 3064909, iget ret: 0, previno:18446744073709551615, prev_agino:4294967295

<previno, prev_agino> is just <-1 %ull and -1 %u> in above. That's why
the huge value.

[   17.801281] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:13
[   17.801287] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:14
[   17.801292] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:15
[   17.801298] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:16
[   17.801303] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:17
[   17.801309] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:18
[   17.801315] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:19
[   17.801320] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:20
[   17.801325] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:21
[   17.801331] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:22
[   17.811059] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:23
[   17.811276] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:24
[   17.811282] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:25
[   17.811288] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:26
[   17.811293] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:27
[   17.811299] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:28
[   17.811304] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:29
[   17.811310] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:30
[   17.811315] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:31
[   17.811320] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:32
[   17.811326] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:33
[   17.811331] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:34
[   17.811337] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:35
[   17.811342] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:36
[   17.811347] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:37
[   17.811353] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:38
[   17.811358] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:39
[   17.811364] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:40
[   17.811369] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:41
[   17.811375] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:42
[   17.811380] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:43
[   17.811386] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:44
[   17.811391] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:45
[   17.811397] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:46
[   17.811402] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:47
[   17.811408] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:48
[   17.811413] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:49
[   17.811419] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:50
[   17.811424] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:51
[   17.811430] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:52
[   17.811435] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:53
[   17.811441] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:54
[   17.811446] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:55
[   17.811452] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:56
[   17.811457] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:57
[   17.811462] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:58
[   17.811468] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:59
[   17.811474] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:60
[   17.811480] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:61
[   17.811485] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:62
[   17.811491] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:63
[   17.811496] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:0
[   17.811502] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:1
[   17.811507] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:2
[   17.811513] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:3
[   17.811518] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:4
[   17.811524] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:5
[   17.811529] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:6
[   17.811535] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:7
[   17.811540] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:8
[   17.811546] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:9
[   17.811551] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:10
[   17.811557] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:11
[   17.811562] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:12
[   17.811568] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:13
[   17.811573] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:14
[   17.811578] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:15
[   17.811584] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:16
[   17.811589] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:17
[   17.811595] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:18
[   17.811600] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:19
[   17.811605] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:20
[   17.811611] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:21
[   17.811616] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:22
[   17.811621] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:23
[   17.811627] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:24
[   17.811632] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:25
[   17.811638] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:26
[   17.811643] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:27
[   17.811649] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:28
[   17.811654] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:29
[   17.811660] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:30
[   17.811665] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:31
[   17.811671] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:32
[   17.811676] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:33
[   17.811682] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:34
[   17.811687] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:35
[   17.811693] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:36
[   17.811698] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:37
[   17.811704] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:38
[   17.811709] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:39
[   17.811715] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:40
[   17.811720] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:41
[   17.811726] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:42
[   17.811731] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:43
[   17.811737] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:44
[   17.811742] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:45
[   17.811748] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:46
[   17.811753] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:47
[   17.811759] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:48
[   17.811764] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:49
[   17.811770] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:50
[   17.811775] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:51
[   17.811780] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:52
[   17.811786] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:53
[   17.811791] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:54
[   17.811797] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:55
[   17.811802] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:56
[   17.811807] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:57
[   17.811812] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:58
[   17.811818] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:59
[   17.811824] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:60
[   17.811829] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:61
[   17.811835] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:62
[   17.811840] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:1, bucket:63
[   17.811846] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:0
[   17.811851] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:1
[   17.811857] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:2
[   17.811862] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:3
[   17.811868] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:4
[   17.811873] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:5
[   17.811879] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:6
[   17.811884] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:7
[   17.811890] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:8
[   17.811895] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:9
[   17.811900] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:10
[   17.811906] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:11
[   17.811912] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:12
[   17.811917] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:13
[   17.811922] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:14
[   17.811928] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:15
[   17.811933] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:16
[   17.811939] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:17
[   17.811944] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:18
[   17.811950] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:19
[   17.811955] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:20
[   17.811960] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:21
[   17.811966] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:22
[   17.811971] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:23
[   17.811977] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:24
[   17.811982] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:25
[   17.811988] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:26
[   17.811993] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:27
[   17.811999] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:28
[   17.812004] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:29
[   17.812010] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:30
[   17.812015] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:31
[   17.812021] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:32
[   17.812026] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:33
[   17.812031] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:34
[   17.812037] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:35
[   17.812042] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:36
[   17.812048] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:37
[   17.812053] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:38
[   17.812058] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:39
[   17.812064] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:40
[   17.812070] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:41
[   17.812075] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:42
[   17.812080] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:43
[   17.812086] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:44
[   17.812091] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:45
[   17.812097] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:46
[   17.812102] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:47
[   17.812107] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:48
[   17.812113] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:49
[   17.812118] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:50
[   17.812123] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:51
[   17.812129] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:52
[   17.812134] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:53
[   17.812139] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:54
[   17.812145] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:55
[   17.812150] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:56
[   17.812156] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:57
[   17.812161] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:58
[   17.812166] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:59
[   17.812172] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:60
[   17.812177] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:61
[   17.813165] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:62
[   17.813170] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:2, bucket:63
[   17.813176] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:0
[   17.813181] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:1
[   17.813186] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:2
[   17.813192] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:3
[   17.813197] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:4
[   17.813202] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:5
[   17.819070] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:6
[   17.819076] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:7
[   17.819082] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:8
[   17.819087] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:9
[   17.819093] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:10
[   17.819099] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:11
[   17.819104] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:12
[   17.819110] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:13
[   17.819115] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:14
[   17.819121] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:15
[   17.824214] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:16
[   17.824220] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:17
[   17.824226] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:18
[   17.824231] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:19
[   17.824236] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:20
[   17.824242] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:21
[   17.824247] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:22
[   17.824253] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:23
[   17.824258] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:24
[   17.824264] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:25
[   17.824269] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:26
[   17.829372] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:27
[   17.829378] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:28
[   17.829384] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:29
[   17.829390] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:30
[   17.829395] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:31
[   17.829401] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:32
[   17.829406] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:33
[   17.829412] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:34
[   17.829418] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:35
[   17.829423] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:36
[   17.834523] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:37
[   17.834529] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:38
[   17.834534] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:39
[   17.834540] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:40
[   17.834545] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:41
[   17.834550] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:42
[   17.834556] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:43
[   17.834561] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:44
[   17.834567] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:45
[   17.834572] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:46
[   17.834577] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:47
[   17.839752] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:48
[   17.839758] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:49
[   17.839764] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:50
[   17.839769] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:51
[   17.839775] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:52
[   17.839781] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:53
[   17.839786] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:54
[   17.839792] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:55
[   17.839797] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:56
[   17.839803] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:57
[   17.844888] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:58
[   17.844894] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:59
[   17.844900] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:60
[   17.844905] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:61
[   17.844910] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:62
[   17.844916] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:63
[   17.886079] XFS (dm-0): Ending recovery (logdev: internal)
[  OK  ] Mounted /sysroot.
[  OK  ] Reached target Initrd Root File System.


2. Then these are the logs from xfs_repair -n /dev/dm-0
Here you will notice the same agi 3064909 in bucket 13 (from phase-2) which got also
printed in above xlog_recover_iunlink_ag() function.

switch_root:/# xfs_repair -n /dev/dm-0
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
agi unlinked bucket 13 is 3064909 in ag 0 (inode=3064909)
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 2
        - agno = 1
        - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
would have reset inode 3064909 nlinks from 4294967291 to 2
No modify flag set, skipping filesystem flush and exiting.


3. Then we exit from the shell for the system to continue booting.
Here it will continue.. Just pasting the logs where the warning gets
generated and some extra logs are getting printed for the same inode
with our patch.


it continues
================
[  587.999113] ------------[ cut here ]------------
[  587.999121] WARNING: CPU: 48 PID: 2026 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x58/0x80 [xfs]
[  587.999185] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink rfkill sunrpc xts pseries_rng vmx_crypto xfs libcrc32c sd_mod sg ibmvscsi ibmveth scsi_transport_srp nvme nvme_core t10_pi crc64_rocksoft crc64 dm_mirror dm_region_hash dm_log dm_mod
[  587.999215] CPU: 48 PID: 2026 Comm: in:imjournal Not tainted 6.2.0-rc8ssh+ #38
[  587.999219] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
[  587.999222] NIP:  c00800000065fa80 LR: c00800000065fa4c CTR: c000000000ea4d40
[  587.999226] REGS: c00000001aa83650 TRAP: 0700   Not tainted  (6.2.0-rc8ssh+)
[  587.999228] MSR:  8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 24224842  XER: 00000000
[  587.999236] CFAR: c00800000065fa54 IRQMASK: 0
[  587.999236] GPR00: c00000004570b2c8 c00000001aa838f0 c008000000708300 0000000000000000
[  587.999236] GPR04: 00000000002ec44d 0000000000000000 0000000000000000 c00000000413faf0
[  587.999236] GPR08: 0000000000000000 c00000000413fba0 0000000000000000 fffffffffffffffd
[  587.999236] GPR12: 0000000000000040 c000004afeccd880 0000000000000000 0000000004000000
[  587.999236] GPR16: c00000001aa83b38 c00000001aa83a38 c00000001aa83a68 c000000035264c00
[  587.999236] GPR20: c00000004570b200 0000000000008000 c00000000886c400 00000000002ec44d
[  587.999236] GPR24: 000000000014040d 000000000000000d c000000051875400 00000000002ec44d
[  587.999236] GPR28: c000000035262c00 c00000004570b200 c00000008f2d8b90 000000000014040d
[  587.999272] NIP [c00800000065fa80] xfs_iunlink_lookup+0x58/0x80 [xfs]
[  587.999327] LR [c00800000065fa4c] xfs_iunlink_lookup+0x24/0x80 [xfs]
[  587.999379] Call Trace:
[  587.999381] [c00000001aa838f0] [c00000008f2d8b90] 0xc00000008f2d8b90 (unreliable)
[  587.999385] [c00000001aa83910] [c008000000660094] xfs_iunlink+0x1bc/0x2c0 [xfs]
[  587.999438] [c00000001aa839d0] [c008000000664804] xfs_rename+0x69c/0xd10 [xfs]
[  587.999491] [c00000001aa83b10] [c00800000065e020] xfs_vn_rename+0xf8/0x1f0 [xfs]
[  587.999544] [c00000001aa83ba0] [c000000000579efc] vfs_rename+0x9bc/0xdf0
[  587.999549] [c00000001aa83c90] [c00000000058018c] do_renameat2+0x3dc/0x5c0
[  587.999553] [c00000001aa83de0] [c000000000580520] sys_rename+0x60/0x80
[  587.999557] [c00000001aa83e10] [c000000000033630] system_call_exception+0x150/0x3b0
[  587.999562] [c00000001aa83e50] [c00000000000c554] system_call_common+0xf4/0x258
[  587.999567] --- interrupt: c00 at 0x7fff96082e20
[  587.999569] NIP:  00007fff96082e20 LR: 00007fff95c45e24 CTR: 0000000000000000
[  587.999572] REGS: c00000001aa83e80 TRAP: 0c00   Not tainted  (6.2.0-rc8ssh+)
[  587.999575] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 2a082202  XER: 00000000
[  587.999584] IRQMASK: 0
[  587.999584] GPR00: 0000000000000026 00007fff94f5d220 00007fff96207300 00007fff94f5d288
[  587.999584] GPR04: 0000000172b76b70 0000000000000000 0600000000000000 0000000000000002
[  587.999584] GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  587.999584] GPR12: 0000000000000000 00007fff94f666e0 0000000172b65930 0000000000000000
[  587.999584] GPR16: 0000000132fe7648 00007fff95c47ce0 0000000000000000 000000000000004c
[  587.999584] GPR20: 0000000000000082 00007fff94f5e3a0 00007fff94f5e398 00007fff880029b0
[  587.999584] GPR24: 0000000000000000 00007fff94f5e388 00007fff94f5e378 00007fff94f5e3b0
[  587.999584] GPR28: 00007fff95c60000 00007fff95c605e0 00007fff88000c10 00007fff94f5d288
[  587.999618] NIP [00007fff96082e20] 0x7fff96082e20
[  587.999620] LR [00007fff95c45e24] 0x7fff95c45e24
[  587.999622] --- interrupt: c00
[  587.999624] Code: 2c230000 4182002c e9230020 2fa90000 419e0020 38210020 e8010010 7c0803a6 4e800020 60000000 60000000 60000000 <0fe00000> 60000000 60000000 60000000
[  587.999637] ---[ end trace 0000000000000000 ]---
[  587.999640] xfs_iunlink_update_backref: next_agino: 3064909 cannot be found
[  587.999643] xfs_iunlink_insert_inode: Cannot find backref for agino:1311757, ip->i_ino:1311757, next_agino: 3064909 agno:0
[  587.999646] XFS (dm-0): Internal error xfs_trans_cancel at line 1097 of file fs/xfs/xfs_trans.c.  Caller xfs_rename+0x9cc/0xd10 [xfs]

^^^ There are the extra info printing the next_agino to be the same
agino 3064909 for xfs_iunlink_lookup has failed.


[  587.999701] CPU: 48 PID: 2026 Comm: in:imjournal Tainted: G        W          6.2.0-rc8ssh+ #38
[  587.999705] Hardware name: IBM,9080-HEX POWER10 (raw) 0x800200 0xf000006 of:IBM,FW1010.22 (NH1010_122) hv:phyp pSeries
[  587.999708] Call Trace:
[  587.999709] [c00000001aa838f0] [c000000000e87328] dump_stack_lvl+0x6c/0x9c (unreliable)
[  587.999715] [c00000001aa83920] [c008000000646a84] xfs_error_report+0x5c/0x80 [xfs]
[  587.999767] [c00000001aa83980] [c008000000676860] xfs_trans_cancel+0x178/0x1b0 [xfs]
[  587.999823] [c00000001aa839d0] [c008000000664b34] xfs_rename+0x9cc/0xd10 [xfs]
[  587.999876] [c00000001aa83b10] [c00800000065e020] xfs_vn_rename+0xf8/0x1f0 [xfs]
[  587.999929] [c00000001aa83ba0] [c000000000579efc] vfs_rename+0x9bc/0xdf0
[  587.999933] [c00000001aa83c90] [c00000000058018c] do_renameat2+0x3dc/0x5c0
[  587.999937] [c00000001aa83de0] [c000000000580520] sys_rename+0x60/0x80
[  587.999941] [c00000001aa83e10] [c000000000033630] system_call_exception+0x150/0x3b0
[  587.999945] [c00000001aa83e50] [c00000000000c554] system_call_common+0xf4/0x258
[  587.999950] --- interrupt: c00 at 0x7fff96082e20
[  587.999952] NIP:  00007fff96082e20 LR: 00007fff95c45e24 CTR: 0000000000000000
[  587.999955] REGS: c00000001aa83e80 TRAP: 0c00   Tainted: G        W           (6.2.0-rc8ssh+)
[  587.999958] MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 2a082202  XER: 00000000
[  587.999967] IRQMASK: 0
[  587.999967] GPR00: 0000000000000026 00007fff94f5d220 00007fff96207300 00007fff94f5d288
[  587.999967] GPR04: 0000000172b76b70 0000000000000000 0600000000000000 0000000000000002
[  587.999967] GPR08: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[  587.999967] GPR12: 0000000000000000 00007fff94f666e0 0000000172b65930 0000000000000000
[  587.999967] GPR16: 0000000132fe7648 00007fff95c47ce0 0000000000000000 000000000000004c
[  587.999967] GPR20: 0000000000000082 00007fff94f5e3a0 00007fff94f5e398 00007fff880029b0
[  587.999967] GPR24: 0000000000000000 00007fff94f5e388 00007fff94f5e378 00007fff94f5e3b0
[  587.999967] GPR28: 00007fff95c60000 00007fff95c605e0 00007fff88000c10 00007fff94f5d288
[  588.000000] NIP [00007fff96082e20] 0x7fff96082e20
[  588.000002] LR [00007fff95c45e24] 0x7fff95c45e24
[  588.000004] --- interrupt: c00
[  588.012398] Core dump to |/usr/lib/systemd/systemd-coredump pipe failed
[  588.020328] XFS (dm-0): Corruption of in-memory data (0x8) detected at xfs_trans_cancel+0x190/0x1b0 [xfs] (fs/xfs/xfs_trans.c:1098).  Shutting down filesystem.
[  588.020388] XFS (dm-0): Please unmount the filesystem and rectify the problem(s)


4. Here is the patch diff which we used to collect the info.

<patch>
=============

root-> git diff
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5808abab786c..86b8cab7f759 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1859,8 +1859,10 @@ xfs_iunlink_update_backref(
                return 0;

        ip = xfs_iunlink_lookup(pag, next_agino);
-       if (!ip)
+       if (!ip) {
+               pr_err("%s: next_agino: %u cannot be found\n", __func__, next_agino);
                return -EFSCORRUPTED;
+       }
        ip->i_prev_unlinked = prev_agino;
        return 0;
 }
@@ -1935,8 +1937,11 @@ xfs_iunlink_insert_inode(
         * inode.
         */
        error = xfs_iunlink_update_backref(pag, agino, next_agino);
-       if (error)
+       if (error) {
+               pr_crit("%s: Cannot find backref for agino:%u, ip->i_ino:%llu, next_agino: %u agno:%u\n",
+                       __func__, agino, ip->i_ino, next_agino, pag->pag_agno);
                return error;
+       }

        if (next_agino != NULLAGINO) {
                /*
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fc61cc024023..035fc1eba871 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -825,6 +825,10 @@ xfs_log_mount_finish(
         */
        mp->m_super->s_flags |= SB_ACTIVE;
        xfs_log_work_queue(mp);
+       if (xlog_recovery_needed(log))
+               pr_crit("%s: Recovery needed is set\n", __func__);
+       else
+               pr_crit("%s: Recovery needed not set\n", __func__);
        if (xlog_recovery_needed(log))
                error = xlog_recover_finish(log);
        mp->m_super->s_flags &= ~SB_ACTIVE;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 322eb2ee6c55..6caa8147b443 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2696,8 +2696,13 @@ xlog_recover_iunlink_bucket(
                ASSERT(VFS_I(ip)->i_nlink == 0);
                ASSERT(VFS_I(ip)->i_mode != 0);
                xfs_iflags_clear(ip, XFS_IRECOVERY);
-               agino = ip->i_next_unlinked;

+               if (bucket == 13) {
+                       pr_crit("%s: bucket: %d, agino: %u, ino: %llu, iget ret: %d, previno:%llu, prev_agino:%u\n",
+                               __func__, bucket, agino, ip->i_ino, error, prev_ip ? prev_ip->i_ino : -1, prev_ip ? XFS_INO_TO_AGINO(mp, prev_ip->i_ino) : -1);
+               }
+
+               agino = ip->i_next_unlinked;
                if (prev_ip) {
                        ip->i_prev_unlinked = prev_agino;
                        xfs_irele(prev_ip);
@@ -2789,8 +2794,11 @@ xlog_recover_iunlink_ag(
                         * bucket and remaining inodes on it unreferenced and
                         * unfreeable.
                         */
+                       pr_crit("%s: Failed in xlog_recover_iunlink_bucket %d\n", __func__, error);
                        xfs_inodegc_flush(pag->pag_mount);
                        xlog_recover_clear_agi_bucket(pag, bucket);
+               } else {
+                       pr_crit("%s: ran xlog_recover_iunlink_bucket for agi:%u, bucket:%d\n", __func__, pag->pag_agno, bucket);
                }
        }


> That evidence will guide us towards a kernel patch.

I can spend some more time to debug and understand on how to fix this.
But thought of sharing this info meanwhile and see if there are any
pointers on how to fix this in kernel.

Let me know if any other info is needed. We haven't yet run xfs_repair
on the device w/o -n option.

-ritesh
