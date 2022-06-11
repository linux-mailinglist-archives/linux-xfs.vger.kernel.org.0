Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815775473A9
	for <lists+linux-xfs@lfdr.de>; Sat, 11 Jun 2022 12:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiFKKTl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 11 Jun 2022 06:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiFKKTk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 06:19:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864BE29378
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 03:19:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F4D660C1B
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 10:19:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86233C341CB
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 10:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654942777;
        bh=KVA+AZfrk099wqxZQ5pbymCHIr9iyfXb+0/5/Ef3t7I=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rAeMaAxqP+9/ZCsw3wPJz09kfpDX4Tnq/U3pxfYWRTTH6pTpPi8wFNV1oaViltObp
         B3tlU3DvXQDO9+BNfoYc8AiICilnBeFRvPTVKulTZSqihi7TZgcKwwRLG9+slyeE36
         JVW175a/fGPBBIvFUNax7MP6JAoJza4rorBRSjBw5xWE9t2dkPbnMyMxT+nOlv3EJd
         r9eQ37+5jlF9Qzs7enWt7u58X5Hbz1OP8ev+hSVrql16dxaeqtdawCCe5RPdu3tyra
         v5fRT/yoBPP2qE598Q5hKng92b852FEu9LbMDDCpeZ4Cx4nhQJeOO+c7xkd8ObPqrk
         szSbzt37NCM9g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 73529CC13B4; Sat, 11 Jun 2022 10:19:37 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Sat, 11 Jun 2022 10:19:36 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: akpm@linux-foundation.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216073-201763-YNjVHRsm4G@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216073-201763@https.bugzilla.kernel.org/>
References: <bug-216073-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216073

--- Comment #8 from Zorro Lang (zlang@redhat.com) ---
It's not a s390x specific bug, I just hit this issue on aarch64 with linux
v5.19.0-rc1:

[  980.200947] usercopy: Kernel memory exposure attempt detected from vmall=
oc
'no area' (offset 0, size 1)!=20
[  980.200968] ------------[ cut here ]------------=20
[  980.200969] kernel BUG at mm/usercopy.c:101!=20
[  980.201081] Internal error: Oops - BUG: 0 [#1] SMP=20
[  980.224192] Modules linked in: rfkill arm_spe_pmu mlx5_ib ast
drm_vram_helper drm_ttm_helper ttm ib_uverbs acpi_ipmi drm_kms_helper ipmi_=
ssif
fb_sys_fops syscopyarea sysfillrect ib_core sysimgblt arm_cmn arm_dmc620_pmu
arm_dsu_pmu cppc_cpufreq sunrpc vfat fat drm fuse xfs libcrc32c mlx5_core
crct10dif_ce ghash_ce sha2_ce sha256_arm64 sha1_ce sbsa_gwdt nvme igb mlxfw
nvme_core tls i2c_algo_bit psample pci_hyperv_intf i2c_designware_platform
i2c_designware_core xgene_hwmon ipmi_devintf ipmi_msghandler=20
[  980.268449] CPU: 42 PID: 121940 Comm: rm Kdump: loaded Not tainted
5.19.0-rc1+ #1=20
[  980.275921] Hardware name: GIGABYTE R272-P30-JG/MP32-AR0-JG, BIOS F16f (=
SCP:
1.06.20210615) 07/01/2021=20
[  980.285214] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)=20
[  980.292165] pc : usercopy_abort+0x78/0x7c=20
[  980.296167] lr : usercopy_abort+0x78/0x7c=20
[  980.300166] sp : ffff80002b007730=20
[  980.303469] x29: ffff80002b007740 x28: ffff80002b007cc0 x27:
ffffdc5683ecc880=20
[  980.310595] x26: 1ffff00005600f9b x25: ffffdc5681c90000 x24:
ffff80002b007cdc=20
[  980.317722] x23: ffff800041a0004a x22: 0000000000000001 x21:
0000000000000001=20
[  980.324848] x20: 0000000000000000 x19: ffff800041a00049 x18:
0000000000000000=20
[  980.331974] x17: 2720636f6c6c616d x16: 76206d6f72662064 x15:
6574636574656420=20
[  980.339101] x14: 74706d6574746120 x13: 21293120657a6973 x12:
ffff6106cbc4c03f=20
[  980.346227] x11: 1fffe106cbc4c03e x10: ffff6106cbc4c03e x9 :
ffffdc5681f36e30=20
[  980.353353] x8 : ffff08365e2601f7 x7 : 0000000000000001 x6 :
ffff6106cbc4c03e=20
[  980.360480] x5 : ffff08365e2601f0 x4 : 1fffe10044b11801 x3 :
0000000000000000=20
[  980.367606] x2 : 0000000000000000 x1 : ffff08022588c000 x0 :
000000000000005c=20
[  980.374733] Call trace:=20
[  980.377167]  usercopy_abort+0x78/0x7c=20
[  980.380819]  check_heap_object+0x3dc/0x3e0=20
[  980.384907]  __check_object_size.part.0+0x6c/0x1f0=20
[  980.389688]  __check_object_size+0x24/0x30=20
[  980.393774]  filldir64+0x548/0x84c=20
[  980.397165]  xfs_dir2_block_getdents+0x404/0x960 [xfs]=20
[  980.402437]  xfs_readdir+0x3c4/0x4b0 [xfs]=20
[  980.406652]  xfs_file_readdir+0x6c/0xa0 [xfs]=20
[  980.411127]  iterate_dir+0x3a4/0x500=20
[  980.414691]  __do_sys_getdents64+0xb0/0x230=20
[  980.418863]  __arm64_sys_getdents64+0x70/0xa0=20
[  980.423209]  invoke_syscall.constprop.0+0xd8/0x1d0=20
[  980.427991]  el0_svc_common.constprop.0+0x224/0x2bc=20
[  980.432858]  do_el0_svc+0x4c/0x90=20
[  980.436163]  el0_svc+0x5c/0x140=20
[  980.439294]  el0t_64_sync_handler+0xb4/0x130=20
[  980.443553]  el0t_64_sync+0x174/0x178=20
[  980.447206] Code: f90003e3 aa0003e3 91098100 97ffe24b (d4210000)=20=20
[  980.453292] SMP: stopping secondary CPUs=20
[  980.458162] Starting crashdump kernel...=20
[  980.462073] Bye!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
