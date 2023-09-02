Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F6279054D
	for <lists+linux-xfs@lfdr.de>; Sat,  2 Sep 2023 07:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351578AbjIBFky (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 2 Sep 2023 01:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243380AbjIBFkx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Sep 2023 01:40:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775B3180;
        Fri,  1 Sep 2023 22:40:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 85BF2CE24E2;
        Sat,  2 Sep 2023 05:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5478C433C7;
        Sat,  2 Sep 2023 05:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693633246;
        bh=gI5ivQgFsgfp8tq/ALPxezbERkLw/dWo9Nqs8Tjh7/Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QntVfIMJu5rEOR8U8FCxh92I49kt8WEDOqKuui6MvfMzP45EdjxrqHWHZt+VejVaj
         C2Q3gH58O0QKpdgLTzQx5hy2YV+iEFmOcSnEeyOGTGyBd5T/JBXYvpjQiGzIVSew+N
         JJHib949X+BzpIF9rqXdx5NY+I33xRSKbwgoo7n6cRRrUavhTWMu6Fwjls+JEHhbxz
         n7yJ8QmqUf5j47UtiPdJyw5RwQtFJ340Qp1H2avZwdYT1v2K4e0DUaYUTpmNLwDWiv
         uN64rvbFJ26Sbr0RVQHZDETmAkTJ0f6elcL53+Pw4qLPpOiAnXIwA/6KaW1NlnTGDu
         b2oi51NjBd3IA==
Date:   Fri, 1 Sep 2023 22:40:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] generic/650: race mount and unmount with cpu hotplug
 too
Message-ID: <20230902054046.GB28170@frogsfrogsfrogs>
References: <169335047228.3523635.3342369338633870707.stgit@frogsfrogsfrogs>
 <169335048358.3523635.7191015334485086811.stgit@frogsfrogsfrogs>
 <20230902053358.m7ys4wcfzgqisk6o@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230902053358.m7ys4wcfzgqisk6o@zlang-mailbox>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Sep 02, 2023 at 01:33:58PM +0800, Zorro Lang wrote:
> On Tue, Aug 29, 2023 at 04:08:03PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Ritesh Harjani reported that mount and unmount can race with the xfs cpu
> > hotplug notifier hooks and crash the kernel.  Extend this test to
> > include that.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Oh, it covers a new crash bug, right? I just hit it [1]. Is there a known fix
> which can be specified by _fixed_by....?

https://lore.kernel.org/linux-xfs/ZO6J4W9msOixUk05@dread.disaster.area/T/#t

Not merged yet, will ask Chandan to pull all my pending fixes next
week.

--D

> Thanks,
> Zorro
> 
> [1]
> [12328.869261] run fstests generic/650 at 2023-09-01 21:29:58
> [12330.643585] smpboot: CPU 38 is now offline
> [-- MARK -- Sat Sep  2 01:30:00 2023]
> [12332.435309] smpboot: CPU 164 is now offline
> [12333.137984] smpboot: CPU 94 is now offline
> [12333.818337] smpboot: CPU 63 is now offline
> [12334.959559] smpboot: CPU 127 is now offline
> [12335.631255] smpboot: CPU 160 is now offline
> ....
> ....
> [12555.494184] smpboot: Booting Node 1 Processor 193 APIC 0xb3
> [12556.213072] smpboot: CPU 170 is now offline
> [12557.409451] smpboot: CPU 109 is now offline
> [12558.013384] XFS (pmem1): Unmounting Filesystem 23992a48-9538-4c53-8312-becd4fcf4f0a
> [12558.029879] smpboot: CPU 191 is now offline
> [12558.074326] general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN NOPTI
> [12558.085798] KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> [12558.093415] CPU: 180 PID: 3988051 Comm: 650 Kdump: loaded Not tainted 6.5.0+ #1
> [12558.100768] Hardware name: HPE ProLiant DL380 Gen11/ProLiant DL380 Gen11, BIOS 1.32 03/23/2023
> [12558.109430] RIP: 0010:xlog_cil_pcp_dead+0x2b/0x540 [xfs]
> [12558.115080] Code: 1f 44 00 00 48 b8 00 00 00 00 00 fc ff df 41 57 41 56 41 55 41 54 55 53 48 89 fb 48 83 c7 10 48 89 fa 48 c1 ea 03 48 83 ec 10 <80> 3c 02 00 0f 85 1e 04 00 00 48 b8 00 00
>  00 00 00 fc ff df 48 8b
> [12558.133964] RSP: 0018:ffa000003a0c7988 EFLAGS: 00010286
> [12558.139224] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffffb3aa11c6
> [12558.146402] RDX: 0000000000000002 RSI: 00000000000000bf RDI: 0000000000000010
> [12558.153580] RBP: ff1100062ed14000 R08: 0000000000000000 R09: fffa3bfffef4319f
> [12558.160759] R10: ffd1fffff7a18cff R11: 0000000000000000 R12: ff1100068dc5a180
> [12558.167937] R13: 00000000000000bf R14: dffffc0000000000 R15: ff11003ff6c2f7e0
> [12558.175115] FS:  00007f2fd250b740(0000) GS:ff11003ff4000000(0000) knlGS:0000000000000000
> [12558.183254] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [12558.189035] CR2: 00000000023e1048 CR3: 00000006c7a58002 CR4: 0000000000771ee0
> [12558.196211] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [12558.203388] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
> [12558.210565] PKRU: 55555554
> [12558.213286] Call Trace:
> [12558.215749]  <TASK>
> [12558.217860]  ? die_addr+0x3d/0xa0
> [12558.221202]  ? exc_general_protection+0x150/0x230
> [12558.225943]  ? asm_exc_general_protection+0x22/0x30
> [12558.230859]  ? __cancel_work_timer+0x216/0x460
> [12558.235332]  ? xlog_cil_pcp_dead+0x2b/0x540 [xfs]
> [12558.240221]  ? xfs_inodegc_cpu_dead+0x76/0x380 [xfs]
> [12558.245380]  xfs_cpu_dead+0xab/0x120 [xfs]
> [12558.249661]  ? __pfx_xfs_cpu_dead+0x10/0x10 [xfs]
> [12558.254548]  cpuhp_invoke_callback+0x2f6/0x830
> [12558.259022]  ? __pfx_iova_cpuhp_dead+0x10/0x10
> [12558.263499]  ? __pfx___lock_release+0x10/0x10
> [12558.267886]  __cpuhp_invoke_callback_range+0xcc/0x1c0
> [12558.272970]  ? __pfx___cpuhp_invoke_callback_range+0x10/0x10
> [12558.278661]  ? trace_cpuhp_exit+0x15e/0x1a0
> [12558.282868]  ? cpuhp_kick_ap_work+0x1e6/0x370
> [12558.287252]  _cpu_down+0x352/0x890
> [12558.290678]  cpu_device_down+0x68/0xa0
> [12558.294450]  device_offline+0x243/0x310
> [12558.298311]  ? __pfx_device_offline+0x10/0x10
> [12558.302694]  ? __pfx___mutex_lock+0x10/0x10
> [12558.306904]  ? __pfx_lock_acquire+0x10/0x10
> [12558.311114]  ? __pfx_sysfs_kf_write+0x10/0x10
> [12558.315500]  online_store+0x87/0xf0
> [12558.319009]  ? __pfx_online_store+0x10/0x10
> [12558.323217]  ? __pfx_sysfs_kf_write+0x10/0x10
> [12558.327600]  ? sysfs_file_ops+0xe0/0x170
> [12558.331545]  ? sysfs_kf_write+0x3d/0x170
> [12558.335493]  kernfs_fop_write_iter+0x355/0x530
> [12558.339966]  vfs_write+0x7bd/0xc40
> [12558.343390]  ? __pfx_vfs_write+0x10/0x10
> [12558.347339]  ? local_clock_noinstr+0x9/0xc0
> [12558.351550]  ? __fget_light+0x51/0x220
> [12558.355326]  ksys_write+0xf1/0x1d0
> [12558.358747]  ? __pfx_ksys_write+0x10/0x10
> [12558.362779]  ? ktime_get_coarse_real_ts64+0x130/0x170
> [12558.367866]  do_syscall_64+0x59/0x90
> [12558.371464]  ? exc_page_fault+0xaa/0xe0
> [12558.375323]  ? asm_exc_page_fault+0x22/0x30
> [12558.379533]  ? lockdep_hardirqs_on+0x79/0x100
> [12558.383917]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
> [12558.392600] Code: 0b 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48
>  89 54 24 18 48 89 74 24
> [12558.411482] RSP: 002b:00007fffc4c0d178 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> [12558.419098] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f2fd233eba7
> [12558.426274] RDX: 0000000000000002 RSI: 0000560a773d8000 RDI: 0000000000000001
> [12558.433451] RBP: 0000560a773d8000 R08: 0000000000000000 R09: 00007f2fd23b14e0
> [12558.440630] R10: 00007f2fd23b13e0 R11: 0000000000000246 R12: 0000000000000002
> [12558.447808] R13: 00007f2fd23fb780 R14: 0000000000000002 R15: 00007f2fd23f69e0
> ...
> 
> 
> >  tests/generic/650 |   13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/tests/generic/650 b/tests/generic/650
> > index 05c939b84f..773f93c7cb 100755
> > --- a/tests/generic/650
> > +++ b/tests/generic/650
> > @@ -67,11 +67,18 @@ fsstress_args=(-w -d $stress_dir)
> >  nr_cpus=$((LOAD_FACTOR * nr_hotplug_cpus))
> >  test "$nr_cpus" -gt 1024 && nr_cpus="$nr_hotplug_cpus"
> >  fsstress_args+=(-p $nr_cpus)
> > -test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
> > +if [ -n "$SOAK_DURATION" ]; then
> > +	test "$SOAK_DURATION" -lt 10 && SOAK_DURATION=10
> > +	fsstress_args+=(--duration="$((SOAK_DURATION / 10))")
> > +fi
> >  
> > -nr_ops=$((25000 * TIME_FACTOR))
> > +nr_ops=$((2500 * TIME_FACTOR))
> >  fsstress_args+=(-n $nr_ops)
> > -$FSSTRESS_PROG $FSSTRESS_AVOID -w "${fsstress_args[@]}" >> $seqres.full
> > +for ((i = 0; i < 10; i++)); do
> > +	$FSSTRESS_PROG $FSSTRESS_AVOID -w "${fsstress_args[@]}" >> $seqres.full
> > +	_test_cycle_mount
> > +done
> > +
> >  rm -f $sentinel_file
> >  
> >  # success, all done
> > 
> 
