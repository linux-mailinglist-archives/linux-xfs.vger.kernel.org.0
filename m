Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78127362C6B
	for <lists+linux-xfs@lfdr.de>; Sat, 17 Apr 2021 02:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbhDQA1D (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 16 Apr 2021 20:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhDQA1D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Apr 2021 20:27:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85480611AB;
        Sat, 17 Apr 2021 00:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618619197;
        bh=hibD6YqkAqGTjl+2rNIN3vwLcF/Palb9nRd6Soeu7UA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tBoIFwKKPtjQFMyFa2rauMTws8hRlTvTUy78gQJvAd2ViQZzwuoCR6ve3WJBe50hm
         5SXLFZ/4DoyPeBICKua0ucF5xR68WSHeD7byFb9+0QOfEvYjtOWJoSjQjV1VOjCQhJ
         ikELSmzWc1AH8ba4mWrrDY1PwTiOJlC5ljtrWiYwVARXsl0msGnSa5j25bBb+PTiRm
         6BFSauMDwJOr0islw8nhgDgH43RjXk2BG+CyaGO9XoKOSuVpE7IngvImErDqD9bjH5
         mBIAP8TtZwb15lNSthaZ7f3uzOXmMsNxBgwtnwfTwPLT4TuT3KCm6BWCDP6XaDRqIq
         OXFEQI1VB3XXw==
Date:   Fri, 16 Apr 2021 17:26:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V6 13/13] xfs: Stress test with bmap_alloc_minlen_extent
 error tag enabled
Message-ID: <20210417002635.GD3122276@magnolia>
References: <20210309050124.23797-1-chandanrlinux@gmail.com>
 <20210309050124.23797-14-chandanrlinux@gmail.com>
 <20210322185413.GH1670408@magnolia>
 <87lf9j6gec.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lf9j6gec.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 15, 2021 at 03:03:47PM +0530, Chandan Babu R wrote:
> On 23 Mar 2021 at 00:24, Darrick J. Wong wrote:
> > On Tue, Mar 09, 2021 at 10:31:24AM +0530, Chandan Babu R wrote:
> >> This commit adds a stress test that executes fsstress with
> >> bmap_alloc_minlen_extent error tag enabled.
> >
> > Continuing along the theme of watching the magic smoke come out when dir
> > block size > fs block size, I also observed the following assertion when
> > running this test:
> >
> >  XFS: Assertion failed: done, file: fs/xfs/libxfs/xfs_dir2.c, line: 687
> >  ------------[ cut here ]------------
> >  WARNING: CPU: 0 PID: 3892 at fs/xfs/xfs_message.c:112 assfail+0x3c/0x40 [xfs]
> >  Modules linked in: xfs(O) libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip ip_set_hash_net xt_tcpudp xt_set ip_set_hash_mac ip_set nfnetlink ip6table_filter ip6_tables iptable_filter bfq sch_fq_codel ip_tables x_tables overlay nfsv4 af_packet
> >  CPU: 0 PID: 3892 Comm: fsstress Tainted: G           O      5.12.0-rc4-xfsx #rc4
> >  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> >  RIP: 0010:assfail+0x3c/0x40 [xfs]
> >  Code: d0 d5 41 a0 e8 81 f9 ff ff 8a 1d 5b 44 0e 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 b0 d5 4d a0 e8 93 dc fc e0 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
> >  RSP: 0018:ffffc900035bba38 EFLAGS: 00010246
> >  RAX: 0000000000000000 RBX: ffff88804f204100 RCX: 0000000000000000
> >  RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffffa040c157
> >  RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000000000a
> >  R10: 000000000000000a R11: f000000000000000 R12: ffff88805920b880
> >  R13: ffff888003778bb0 R14: 0000000000000000 R15: ffff88800f0f63c0
> >  FS:  00007fe7b5e2f740(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
> >  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >  CR2: 00007fe7b6055000 CR3: 0000000053094005 CR4: 00000000001706b0
> >  Call Trace:
> >   xfs_dir2_shrink_inode+0x22f/0x270 [xfs]
> >   xfs_dir2_block_to_sf+0x29a/0x420 [xfs]
> >   xfs_dir2_block_removename+0x221/0x290 [xfs]
> >   xfs_dir_removename+0x1a0/0x220 [xfs]
> >   xfs_dir_rename+0x343/0x3b0 [xfs]
> >   xfs_rename+0x79e/0xae0 [xfs]
> >   xfs_vn_rename+0xdb/0x150 [xfs]
> >   vfs_rename+0x4e2/0x8e0
> >   do_renameat2+0x393/0x550
> >   __x64_sys_rename+0x40/0x50
> >   do_syscall_64+0x2d/0x40
> >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> >  RIP: 0033:0x7fe7b5e9800b
> >  Code: e8 aa ce 0a 00 85 c0 0f 95 c0 0f b6 c0 f7 d8 5d c3 66 0f 1f 44 00 00 b8 ff ff ff ff 5d c3 90 f3 0f 1e fa b8 52 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 51 4e 18 00 f7 d8
> >  RSP: 002b:00007ffeb526c698 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
> >  RAX: ffffffffffffffda RBX: 00007ffeb526c970 RCX: 00007fe7b5e9800b
> >  RDX: 0000000000000000 RSI: 000055d6ccdb9250 RDI: 000055d6ccdb9270
> >  RBP: 00007ffeb526c980 R08: 0000000000000001 R09: 0000000000000003
> >  R10: 000055d6cc3b20dc R11: 0000000000000246 R12: 0000000000000000
> >  R13: 0000000000000040 R14: 00007ffeb526c970 R15: 00007ffeb526c980
> >  ---[ end trace 98f99784621d65fe ]---
> >
> > It looks to me as though we return from xfs_bunmapi having not completed
> > all the unmapping work, though I can't tell if that's because bunmapi
> > returned early because it thought it would overflow the extent count; or
> > some other reason.
> >
> > OH CRAP, I just realized that xfs_dir2_shrink_inode only calls
> > xfs_bunmapi once, which means that if the directory block it's removing
> > is a multi-fsb block, it will remove the last extent map.  It then trips
> > the assertion, having left the rest of the directory block still mapped.
> >
> > This is also what's going on when xfs_inactive_symlink_rmt trips the
> > same ASSERT(done), because the symlink remote block can span multiple
> > (two?) fs blocks but we only ever call xfs_bunmapi once.
> >
> > So, no, there's nothing wrong with this test, but it _did_ shake loose
> > a couple of XFS bugs.  Congratulations!
> >
> > So... who wants to tackle this one?  This isn't trivial to clean up
> > because you'll have to clean up all callers of xfs_dir2_shrink_inode to
> > handle rolling of the transaction, and I bet the only way to fix this is
> > to use deferred bunmap items to make sure the unmap always completes.
> >
> 
> I was wondering as to why the above described bug does not occur when
> allocating blocks via xfs_bmap_btalloc(). This led me to the following,
> 
> 1. When using xfs_bmap_btalloc() to allocate a directory block,
>    xfs_bmalloca->total is set to total number of fs blocks required for the
>    transaction to complete successfully. This includes blocks required to
>    allocate
>    - Data block
>    - Free index block
>    - Dabtree blocks and
>    - Bmbt blocks.
> 
> 2. Most of the time (please refer to step #5 for a description of the
>    exceptional case), xfs_bmap_btalloc() chooses an AG for space allocation
>    only when the AG has atleast xfs_bmalloca->total number of free blocks. On
>    finding such an AG, the corresponding AGF buffer is locked by the
>    transaction and this guarantees that the fs blocks that make up a directory
>    block are allocated from within the same AG. This is probably the reason
>    for xfs_dir2_shrink_inode() to assume that __xfs_bunmapi() will be able to
>    unmap all the constituent fs blocks.

That sounds right to me...

> 
> 3. The call trace posted above occurs when __xfs_bunmapi() starts unmapping
>    the fs blocks of a directory block and one of the fs blocks happens to be
>    from an AG whose AG number is less than that of fs block that was unmapped
>    earlier.
> 
> 4. The xfs_bmap_exact_minlen_extent_alloc() allocator can cause allocation of
>    a directory block whose constituent fs blocks are from different AGs. This
>    occurs because,
>    - xfs_bmap_exact_minlen_extent_alloc() gets an AG which has atleast
>      xfs_bmalloca->total free fs blocks.
>    - However some of those free fs blocks do not correspond to one-block sized
>      extents (NOTE: xfs/538 test fragments 90% of the fs free space).
>    - Once the current AG runs out of one-block sized extents, we move onto the
>      next AG. This happens because xfs_bmap_exact_minlen_extent_alloc() uses
>      XFS_ALLOCTYPE_FIRST_AG as the allocation type and this in turn causes the
>      allocator code to iterate across AGs to get free blocks.

...and the effect of your minlen debug knob is that we will pound on the
lowmode allocator much more frequently.  Multi-fsb directories are
already kind of rare, which means there probably aren't a lot of people
dealing with this combination.

IIRC the /only/ way you can have a multiblock symlink is on a v5
filesystem with 1k blocks, since the max symlink target length is 1024
bytes.

> 5. From code reading, I noticed that the scenario described in step #4 could
>    also occur when using xfs_bmap_btalloc(). This happens when the filesystem
>    is highly fragmented and is also running low on free space. In such a
>    scenario, XFS_TRANS_LOWMODE is enabled causing xfs_bmap_btalloc() to
>    execute the same sequence of steps described in step #4. This scenario
>    (i.e. fragmented fs and running low on free space) is probably quite rare
>    to occur in practice and hence this may be the reason as to why this
>    problem was not observed earlier.

Yes, I think this is accurate.

--D

> 
> --
> chandan
