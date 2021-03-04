Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D257D32D369
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Mar 2021 13:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhCDMlx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 4 Mar 2021 07:41:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34336 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231590AbhCDMlj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 07:41:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614861613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U1IbFliZ1x228p4icVRfwPUJg1MEfLO988kjIMzfl84=;
        b=Kfs2dFaSyAvKwYIEObbX2YeYWhX6qgigMrIrSPPxmnh0lDg2OErUNJG2X8fdVvP3T5YM1L
        IkiulGZAgiL7mpdzO8Tprh+emAgI6bUxhnliX/DUsFz1t1Fpyjcjxgi+aSauGPOs+7NuSW
        lBHVezd1s0148ERjWh9XAzH3gMcSfRs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-bdxeQLQ6P9qtYmeqQs5R5Q-1; Thu, 04 Mar 2021 07:40:08 -0500
X-MC-Unique: bdxeQLQ6P9qtYmeqQs5R5Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCAAA101F00B;
        Thu,  4 Mar 2021 12:40:06 +0000 (UTC)
Received: from bfoster (ovpn-112-112.rdu2.redhat.com [10.10.112.112])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 47A2410013D6;
        Thu,  4 Mar 2021 12:40:05 +0000 (UTC)
Date:   Thu, 4 Mar 2021 07:40:03 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        Guy Lowe <gl@mega.co.nz>
Subject: Re: WARNING: CPU: 5 PID: 25802 at fs/xfs/libxfs/xfs_bmap.c:4530
 xfs_bmapi_convert_delalloc+0x434/0x4a0 [xfs]
Message-ID: <YEDVIxkxObgBA4YC@bfoster>
References: <3c58ebc4-ff95-b443-b08d-81f5169d3d01@gmail.com>
 <20191108065627.GA6260@infradead.org>
 <c52e2515-272f-476e-7cfa-a2ef23c66b56@gmail.com>
 <20191127154353.GA9847@infradead.org>
 <7b5db9fd-7f40-bf43-e494-d6d95839c0f1@gmail.com>
 <20191127162646.GA12929@infradead.org>
 <1e301f27-f4d1-3005-c53c-5999dfd13658@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1e301f27-f4d1-3005-c53c-5999dfd13658@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 03, 2021 at 04:47:44PM +0100, Arkadiusz Miśkiewicz wrote:
> W dniu 27.11.2019 o 17:26, Christoph Hellwig pisze:
> > On Wed, Nov 27, 2019 at 05:25:20PM +0100, Arkadiusz Miśkiewicz wrote:
> >> Hm, 5.3 but I saw this on 5.1.15, too. See below. (or did you mean 5.1
> >> was with big changes?)
> > 
> > I meant 5.1, sorry.
> > 
> >> Probably it will be easier to just bisect and I plan to do that after
> >> backup catches up with missing data (and it takes days).
> > 
> > Thanks a lot!
> > 
> 

What kernel does the warning in the subject refer to? If v5.3, that
looks like a delalloc physical allocation failure.

> I didn't went far with this. It's not easy to reproduce and it seems
> that 5 days of waiting for each git bisect step on 3 machines wasn't
> enough to always catch bad state (or conditions that trigger the problem
> didn't happen then). bisect log at the end of this mail.
> 
> 
> 
> I also tested recent 5.11.0 to see if anything has changed but after few
> days:
> 
> > [773626.607012] ------------[ cut here ]------------
> > [773626.607017] WARNING: CPU: 27 PID: 21938 at fs/xfs/libxfs/xfs_bmap.c:4586 xfs_bmapi_convert_delalloc+0x466/0x490 [xfs]

... which looks the same as this one on v5.11.

The high level error scenario is that buffered writes have successfully
performed delayed allocation, thus writes have succeeded ingesting data
into the page cache. Some time later writeback occurs, attempts to
convert delalloc blocks into physical extents and that real allocation
fails. The fallout from this error is that we have to discard dirty
pages (i.e. the page discard errors further down).

This generally should never occur. If it does, something could be
inconsistent with regard to block reservation and physical free space
accounting.

...
> > [773626.607304] Call Trace:
> > [773626.607311]  xfs_map_blocks+0x1ed/0x440 [xfs]
> > [773626.607378]  iomap_do_writepage+0x16d/0x7c0
> > [773626.607382]  ? __mod_memcg_lruvec_state+0x21/0xe0
> > [773626.607389]  write_cache_pages+0x195/0x3e0
> > [773626.607396]  ? iomap_page_mkwrite_actor+0x70/0x70
> > [773626.607403]  iomap_writepages+0x1c/0x40
> > [773626.607406]  xfs_vm_writepages+0x61/0x80 [xfs]
> > [773626.607472]  do_writepages+0x38/0x100
> > [773626.607475]  ? __wb_calc_thresh+0x4b/0x130
> > [773626.607478]  __writeback_single_inode+0x37/0x290
> > [773626.607482]  writeback_sb_inodes+0x1fb/0x450
> > [773626.607485]  wb_writeback+0xe8/0x2c0
> > [773626.607488]  wb_workfn+0xe4/0x570
> > [773626.607492]  process_one_work+0x218/0x3b0
> > [773626.607496]  worker_thread+0x4d/0x3e0
> > [773626.607498]  ? rescuer_thread+0x3c0/0x3c0
> > [773626.607500]  kthread+0x11b/0x140
> > [773626.607506]  ? __kthread_bind_mask+0x60/0x60
> > [773626.607509]  ret_from_fork+0x22/0x30
> > [773626.607517] ---[ end trace a8859bbc44aed5aa ]---
> > [773626.607520] XFS (sdd1): page discard on page 000000003f3bd102, inode 0x34b0d7a87, offset 29847552.
> > [773626.607545] XFS (sdd1): page discard on page 000000000b27cb4f, inode 0x34b0d7a87, offset 29851648.
> > [773626.607564] XFS (sdd1): page discard on page 000000002b6c6656, inode 0x34b0d7a87, offset 29855744.
> > [773626.607584] XFS (sdd1): page discard on page 0000000068fb9613, inode 0x34b0d7a87, offset 29859840.
> > [773626.607603] XFS (sdd1): page discard on page 0000000087899aca, inode 0x34b0d7a87, offset 29863936.
> > [773626.607621] XFS (sdd1): page discard on page 0000000064bfddfe, inode 0x34b0d7a87, offset 29868032.
> > [773626.607640] XFS (sdd1): page discard on page 00000000e78d1795, inode 0x34b0d7a87, offset 29872128.
> > [773626.607658] XFS (sdd1): page discard on page 000000005568f42b, inode 0x34b0d7a87, offset 29876224.
> > [773626.607676] XFS (sdd1): page discard on page 00000000260f7761, inode 0x34b0d7a87, offset 29880320.
> > [773626.607695] XFS (sdd1): page discard on page 00000000de9a8945, inode 0x34b0d7a87, offset 29884416.
> > [773626.870475] sdd1: writeback error on inode 14144076423, offset 29843456, sector 6442630216
> > [773629.283780] XFS (sdd1): Internal error xfs_trans_cancel at line 954 of file fs/xfs/xfs_trans.c.  Caller xfs_link+0x1bd/0x2b0 [xfs]

And then we end up with a dirty transaction cancel, which appears to be
what actually shuts down the filesystem. It's not clear what exactly the
cause of this is from the log output, but the above writeback errors
suggest that perhaps it was a similar allocation failure associated with
creating a directory entry after the transaction was already dirtied.

Can you report xfs_info, 'xfs_repair -n,' and 'xfs_db -c "freesp -s"
...' (or maybe even "freesp -s -d" depending on how much output it
produces...) for this filesystem? Can you also describe the workload
that eventually leads to this problem? I suspect the best next step to
diagnose the problem is either to try and collect a tracepoint capture
when the error occurs and/or if possible, produce a metadump of the fs
for further investigation.

Brian

> > [773629.283920] CPU: 29 PID: 31348 Comm: cp Tainted: G        W   E   T 5.11.0-1 #1
> > [773629.283923] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.0a 02/06/2018
> > [773629.283924] Call Trace:
> > [773629.283929]  dump_stack+0x6b/0x83
> > [773629.283940]  xfs_trans_cancel+0x10d/0x130 [xfs]
> > [773629.284015]  xfs_link+0x1bd/0x2b0 [xfs]
> > [773629.284087]  xfs_vn_link+0x6e/0xc0 [xfs]
> > [773629.284159]  vfs_link+0x28e/0x3c0
> > [773629.284167]  do_linkat+0x24e/0x320
> > [773629.284170]  __x64_sys_linkat+0x21/0x30
> > [773629.284173]  do_syscall_64+0x33/0x80
> > [773629.284179]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [773629.284187] RIP: 0033:0x7fcc5827a37e
> > [773629.284190] Code: 48 8b 0d f5 0a 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 09 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c2 0a 0d 00 f7 d8 64 89 01 48
> > [773629.284193] RSP: 002b:00007ffede14bac8 EFLAGS: 00000286 ORIG_RAX: 0000000000000109
> > [773629.284196] RAX: ffffffffffffffda RBX: 0000000001d61dd0 RCX: 00007fcc5827a37e
> > [773629.284198] RDX: 00000000ffffff9c RSI: 0000000001d61dd0 RDI: 00000000ffffff9c
> > [773629.284200] RBP: 00000000ffffff9c R08: 0000000000000000 R09: 0000000000000000
> > [773629.284202] R10: 0000000001d61930 R11: 0000000000000286 R12: 0000000001d61930
> > [773629.284203] R13: 0000000001d61930 R14: 00000000ffffff9c R15: 0000000000000000
> > [773629.284419] XFS (sdd1): xfs_do_force_shutdown(0x8) called from line 955 of file fs/xfs/xfs_trans.c. Return address = 00000000a8a1eaaa
> > [773629.284425] XFS (sdd1): Corruption of in-memory data detected.  Shutting down filesystem
> > [773629.284426] XFS (sdd1): Please unmount the filesystem and rectify the problem(s)
> 
> 
> 
> 
> 
> Log from bisect:
> 
> > 1fc1cd8399ab5541a488a7e47b2f21537dd76c2d is the first bad commit
> > commit 1fc1cd8399ab5541a488a7e47b2f21537dd76c2d
> > Merge: abf7c3d8ddea 6a613d24effc
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Thu Mar 7 10:11:41 2019 -0800
> > 
> >     Merge branch 'for-5.1' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
> > 
> >     Pull cgroup updates from Tejun Heo:
> > 
> >      - Oleg's pids controller accounting update which gets rid of rcu delay
> >        in pids accounting updates
> > 
> >      - rstat (cgroup hierarchical stat collection mechanism) optimization
> > 
> >      - Doc updates
> > 
> >     * 'for-5.1' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup:
> >       cpuset: remove unused task_has_mempolicy()
> >       cgroup, rstat: Don't flush subtree root unless necessary
> >       cgroup: add documentation for pids.events file
> >       Documentation: cgroup-v2: eliminate markup warnings
> >       MAINTAINERS: Update cgroup entry
> >       cgroup/pids: turn cgroup_subsys->free() into cgroup_subsys->release() to
> > fix the accounting
> > 
> >  Documentation/admin-guide/cgroup-v2.rst |  2 +-
> >  Documentation/cgroup-v1/pids.txt        |  3 +++
> >  MAINTAINERS                             |  5 +++--
> >  include/linux/cgroup-defs.h             |  2 +-
> >  include/linux/cgroup.h                  |  2 ++
> >  kernel/cgroup/cgroup.c                  | 15 +++++++++------
> >  kernel/cgroup/cpuset.c                  | 13 -------------
> >  kernel/cgroup/pids.c                    |  4 ++--
> >  kernel/cgroup/rstat.c                   | 10 ++++++----
> >  kernel/exit.c                           |  1 +
> >  10 files changed, 28 insertions(+), 29 deletions(-)
> > 
> > 
> > 
> > git bisect start
> > # good: [8fe28cb58bcb235034b64cbbb7550a8a43fd88be] Linux 4.20
> > git bisect good 8fe28cb58bcb235034b64cbbb7550a8a43fd88be
> > # bad: [e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd] Linux 5.1
> > git bisect bad e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd
> > # good: [14dbfb417bd80c96ec700c7a8414bb6f5db7ecd2] Merge branch 'spi-5.1' into spi-next
> > git bisect good 14dbfb417bd80c96ec700c7a8414bb6f5db7ecd2
> > # bad: [b5dd0c658c31b469ccff1b637e5124851e7a4a1c] Merge branch 'akpm' (patches from Andrew)
> > git bisect bad b5dd0c658c31b469ccff1b637e5124851e7a4a1c
> > # good: [3478588b5136966c80c571cf0006f08e9e5b8f04] Merge branch 'locking-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> > git bisect good 3478588b5136966c80c571cf0006f08e9e5b8f04
> > # skip: [da2577fe63f865cd9dc785a42c29c0071f567a35] Merge tag 'sound-5.1-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound
> > git bisect skip da2577fe63f865cd9dc785a42c29c0071f567a35
> > # skip: [593db80390cf40f1b9dcc790020d2edae87183fb] vmbus: Switch to use new generic UUID API
> > git bisect skip 593db80390cf40f1b9dcc790020d2edae87183fb
> > # good: [5a170e9e4c74bc7f9aa57861c90e5813d63bfdab] ALSA: i2c: Clean up with new procfs helpers
> > git bisect good 5a170e9e4c74bc7f9aa57861c90e5813d63bfdab
> > # good: [5a170e9e4c74bc7f9aa57861c90e5813d63bfdab] ALSA: i2c: Clean up with new procfs helpers
> > git bisect good 5a170e9e4c74bc7f9aa57861c90e5813d63bfdab
> > # good: [1c3816a194870e7a6622345dab7fb56c7d708613] ASoC: stm32: sai: add missing put_device()
> > git bisect good 1c3816a194870e7a6622345dab7fb56c7d708613
> > # good: [c5ba619247391527248c4a8fb27e68f7cece8d0d] ASoC: samsung: i2s: Change indentation in SAMSUNG_I2S_FMTS definition
> > git bisect good c5ba619247391527248c4a8fb27e68f7cece8d0d
> > # good: [c5ba619247391527248c4a8fb27e68f7cece8d0d] ASoC: samsung: i2s: Change indentation in SAMSUNG_I2S_FMTS definition
> > git bisect good c5ba619247391527248c4a8fb27e68f7cece8d0d
> > # good: [e402d24d884130ed308ff1d04fdababffcf0fa86] ARM: dts: meson8b: add the APB bus
> > git bisect good e402d24d884130ed308ff1d04fdababffcf0fa86
> > # good: [e402d24d884130ed308ff1d04fdababffcf0fa86] ARM: dts: meson8b: add the APB bus
> > git bisect good e402d24d884130ed308ff1d04fdababffcf0fa86
> > # good: [48a254d7ff729c71c06d73eb3c1929536283bb41] staging: rtl8188eu: cleanup comments in mlme_linux.c
> > git bisect good 48a254d7ff729c71c06d73eb3c1929536283bb41
> > # good: [542d0e583b7b366527175b2b5fc0aad262fa33b0] Merge tag 'devprop-5.1-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> > git bisect good 542d0e583b7b366527175b2b5fc0aad262fa33b0
> > # good: [67e79a6dc2664a3ef85113440e60f7aaca3c7815] Merge tag 'tty-5.1-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
> > git bisect good 67e79a6dc2664a3ef85113440e60f7aaca3c7815
> > # bad: [1fc1cd8399ab5541a488a7e47b2f21537dd76c2d] Merge branch 'for-5.1' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
> > git bisect bad 1fc1cd8399ab5541a488a7e47b2f21537dd76c2d
> 
> This last known "bad" is good starting point for bisecting again.
> 
> > # good: [a9913f23f39f4aa74956587a03e78b758a10c314] Merge tag 'fs_for_v5.1-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
> > git bisect good a9913f23f39f4aa74956587a03e78b758a10c314
> > # good: [f65e25e343cfc0e6f4db9a687c4085fad268325d] btrfs: Remove unnecessary casts in btrfs_read_root_item
> > git bisect good f65e25e343cfc0e6f4db9a687c4085fad268325d
> > # good: [16be1433737ee46f88da57d47f594c4fc1376538] xfs: make xfs_bmbt_to_iomap more useful
> > git bisect good 16be1433737ee46f88da57d47f594c4fc1376538
> > # good: [b1e243957e9b3ba8e820fb8583bdf18e7c737aa2] Merge tag 'for-5.1-part1-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux
> > git bisect good b1e243957e9b3ba8e820fb8583bdf18e7c737aa2
> > # good: [9e1fd794cb6bf813a40849a1fc236703bdcbc1a7] Merge tag 'xfs-5.1-merge-4' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux
> > git bisect good 9e1fd794cb6bf813a40849a1fc236703bdcbc1a7
> > # good: [abf7c3d8ddea3b43fe758590791878e1fd88ac47] Merge branch 'for-5.1' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq
> > git bisect good abf7c3d8ddea3b43fe758590791878e1fd88ac47
> > # good: [05b71f6ffd182e3af3ac25ab811675d622d4ac2a] cgroup: add documentation for pids.events file
> > git bisect good 05b71f6ffd182e3af3ac25ab811675d622d4ac2a
> > # good: [6a613d24effcb875271b8a1c510172e2d6eaaee8] cpuset: remove unused task_has_mempolicy()
> > git bisect good 6a613d24effcb875271b8a1c510172e2d6eaaee8
> > # first bad commit: [1fc1cd8399ab5541a488a7e47b2f21537dd76c2d] Merge branch 'for-5.1' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup
> 
> 
> If anyone else is bisecting then
> 
> commit a9a3ed1eff3601b63aea4fb462d8b3b92c7c1e7e
> Author: Borislav Petkov <bp@suse.de>
> Date:   Wed Apr 22 18:11:30 2020 +0200
> 
>     x86: Fix early boot crash on gcc-10, third try
> 
> 
> and
> 
> diff --git a/arch/x86/boot/compressed/kaslr_64.c
> b/arch/x86/boot/compressed/kaslr_64.c
> index 748456c365f4..90efa69132c4 100644
> --- a/arch/x86/boot/compressed/kaslr_64.c
> +++ b/arch/x86/boot/compressed/kaslr_64.c
> @@ -30,7 +30,7 @@
>  #include "../../mm/ident_map.c"
> 
>  /* Used by pgtable.h asm code to force instruction serialization. */
> -unsigned long __force_order;
> +//unsigned long __force_order;
> 
>  /* Used to track our page table allocation area. */
>  struct alloc_pgt_data {
> 
> 
> are needed to get kernel build and boot with modern toolchain.
> 
> -- 
> Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
> 

