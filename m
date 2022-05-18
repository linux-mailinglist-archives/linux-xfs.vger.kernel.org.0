Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3DA52B2F3
	for <lists+linux-xfs@lfdr.de>; Wed, 18 May 2022 09:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiERG7z (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 May 2022 02:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiERG7y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 02:59:54 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E65617AA7
        for <linux-xfs@vger.kernel.org>; Tue, 17 May 2022 23:59:51 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 7FCB660F66
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 16:59:49 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id Clyw5OT-WroL for <linux-xfs@vger.kernel.org>;
        Wed, 18 May 2022 16:59:49 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 50FBC60EE7
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 16:59:49 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 3B16A6801BC; Wed, 18 May 2022 16:59:49 +1000 (AEST)
Date:   Wed, 18 May 2022 16:59:49 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     linux-xfs@vger.kernel.org
Subject: fstrim and strace considered harmful?
Message-ID: <20220518065949.GA1237408@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I have an fstrim that's been running for over 48 hours on a 256T thin 
provisioned XFS fs containing around 55T of actual data on a slow 
subsystem (ceph 8,3 erasure-encoded rbd). I don't think there would be an 
an enourmous amount of data to trim, maybe a few T, but I've no idea how 
long how long it might be expected to take. In an attempt to see what the 
what the fstrim was doing, I ran an strace on it. The strace has been 
sitting there without output and unkillable since then, now 5+ hours ago.  
Since the strace, on that same filesystem I now have 123 df processes and 
615 rm processes -- and growing -- that are blocked in xfs_inodegc_flush, 
e.g.:

May 18 15:31:52 d5 kernel: task:df              state:D stack:    0 pid:31741 ppid:     1 flags:0x00004004
May 18 15:31:52 d5 kernel: Call Trace:
May 18 15:31:52 d5 kernel:  <TASK>
May 18 15:31:52 d5 kernel:  __schedule+0x241/0x740
May 18 15:31:52 d5 kernel:  ? lock_is_held_type+0x97/0x100
May 18 15:31:52 d5 kernel:  schedule+0x3a/0xa0
May 18 15:31:52 d5 kernel:  schedule_timeout+0x271/0x310
May 18 15:31:52 d5 kernel:  ? find_held_lock+0x2d/0x90
May 18 15:31:52 d5 kernel:  ? sched_clock_cpu+0x9/0xa0
May 18 15:31:52 d5 kernel:  ? lock_release+0x214/0x350
May 18 15:31:52 d5 kernel:  wait_for_completion+0x7b/0xc0
May 18 15:31:52 d5 kernel:  __flush_work+0x217/0x350
May 18 15:31:52 d5 kernel:  ? flush_workqueue_prep_pwqs+0x120/0x120
May 18 15:31:52 d5 kernel:  ? wait_for_completion+0x1c/0xc0
May 18 15:31:52 d5 kernel:  xfs_inodegc_flush.part.24+0x62/0xc0 [xfs]
May 18 15:31:52 d5 kernel:  xfs_fs_statfs+0x37/0x1a0 [xfs]
May 18 15:31:52 d5 kernel:  statfs_by_dentry+0x3c/0x60
May 18 15:31:52 d5 kernel:  vfs_statfs+0x16/0xd0
May 18 15:31:52 d5 kernel:  user_statfs+0x44/0x80
May 18 15:31:52 d5 kernel:  __do_sys_statfs+0x10/0x30
May 18 15:31:52 d5 kernel:  do_syscall_64+0x34/0x80
May 18 15:31:52 d5 kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
May 18 15:31:52 d5 kernel: RIP: 0033:0x7fe9e9db3c07
May 18 15:31:52 d5 kernel: RSP: 002b:00007ffe08f50178 EFLAGS: 00000246 ORIG_RAX: 0000000000000089
May 18 15:31:52 d5 kernel: RAX: ffffffffffffffda RBX: 0000555963fcae40 RCX: 00007fe9e9db3c07
May 18 15:31:52 d5 kernel: RDX: 00007ffe08f50400 RSI: 00007ffe08f50180 RDI: 0000555963fcae40
May 18 15:31:52 d5 kernel: RBP: 00007ffe08f50180 R08: 0000555963fcae80 R09: 0000000000000000
May 18 15:31:52 d5 kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe08f50220
May 18 15:31:52 d5 kernel: R13: 0000000000000000 R14: 0000555963fcae80 R15: 0000555963fcae40
May 18 15:31:52 d5 kernel:  </TASK>

Full 1.5M sysrq output at: https://file.io/bWOL8F7mzKI6

That stack trace is uncomfortably familiar:

Subject: Highly reflinked and fragmented considered harmful?
https://lore.kernel.org/linux-xfs/20220509024659.GA62606@onthe.net.au/

FYI:

# xfs_info /vol
meta-data=/dev/vg01/vol          isize=512    agcount=257, agsize=268434432 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=1
          =                       reflink=1    bigtime=1 inobtcount=1
data     =                       bsize=4096   blocks=68719475712, imaxpct=1
          =                       sunit=1024   swidth=8192 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Is there something I can do to "unstick" things, or is it time to hit the 
reset, and hope the recovery on mount isn't onerous?

Aside from that immediate issue, what has gone wrong here?

Cheers,

Chris
