Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B46F390C80
	for <lists+linux-xfs@lfdr.de>; Wed, 26 May 2021 00:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhEYW51 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 May 2021 18:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229610AbhEYW51 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 May 2021 18:57:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5BE4610A8;
        Tue, 25 May 2021 22:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621983357;
        bh=mtqGOMCxOIjyFGfaNmkUGazGE6S8Ri6OwZgtJDOGLEU=;
        h=Date:From:To:Cc:Subject:From;
        b=ANiUDi2mZTPFcWpy+lHdr9UOxzWEOXPLhygnjPBUqIfJc1t7A6ODlddD5Tic0PyqK
         jdHB5IU8FUGE3voUyHfRCYmALixQ7zaoe4t8K6reWiumBvkZbSUqnzK2mtTZhbt4j3
         YocybeZVXu2mB5+dmrhBKu2ZZVYr+lXHT+pAobgPLACuHCHEZNVI9lsAYmIybXLqRD
         1m0xKeQjYV+KIJDRbEDa1lEqdwTgkRrmbcsGyHjit7q5qkxKVWe1cCTbpnCwjPurE/
         f6IaLkSAdi9F2I3E3ZcAXtX/OkCjkChpFVg2GkBH2mVzPw8dwvm3/giJdqQCADwYPF
         w7lJjlPLloJBQ==
Date:   Tue, 25 May 2021 15:55:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, hsiangkao@aol.com,
        hsiangkao@linux.alibaba.com
Subject: more regressions in xfs/168?
Message-ID: <20210525225556.GR202121@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi again,

Even with the fix to the per-AG reservation code applied, I still see
periodic failures in xfs/168 if I run with ./check -I 60.  This is
what's at the bottom of 168.full:

[EXPERIMENTAL] try to shrink unused space 131446, old size is 131532
meta-data=/dev/sdf               isize=512    agcount=2, agsize=129280 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0    bigtime=1 inobtcount=1
data     =                       bsize=4096   blocks=131532, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=1344, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =/dev/sdd               extsz=4096   blocks=2579968, rtextents=2579968
data blocks changed from 131532 to 131446
Phase 1 - find and verify superblock...
Only two AGs detected and they do not match - cannot validate filesystem geometry.
Use the -o force_geometry option to proceed.
xfs_repair failed with shrinking 131446

The kernel log contains this:

[ 2017.388598] XFS (sdf): Internal error !ino_ok at line 205 of file fs/xfs/libxfs/xfs_dir2.c.  Caller xfs_dir_ino_validate+0x4b/0xa0 [xfs]
[ 2017.392045] CPU: 3 PID: 49956 Comm: xfsaild/sdf Tainted: G           O      5.13.0-rc3-xfsx #rc3
[ 2017.393165] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[ 2017.394166] Call Trace:
[ 2017.394488]  dump_stack+0x64/0x7c
[ 2017.395117]  xfs_corruption_error+0x85/0x90 [xfs]
[ 2017.396362]  ? xfs_dir_ino_validate+0x4b/0xa0 [xfs]
[ 2017.397599]  xfs_dir_ino_validate+0x75/0xa0 [xfs]
[ 2017.398506]  ? xfs_dir_ino_validate+0x4b/0xa0 [xfs]
[ 2017.399655]  xfs_dir2_sf_verify+0x16d/0x2d0 [xfs]
[ 2017.400731]  xfs_ifork_verify_local_data+0x33/0x60 [xfs]
[ 2017.402019]  xfs_iflush_cluster+0x67f/0x8f0 [xfs]
[ 2017.403163]  xfs_inode_item_push+0xa8/0x140 [xfs]
[ 2017.404203]  xfsaild+0x42c/0xc50 [xfs]
[ 2017.405106]  ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
[ 2017.406306]  kthread+0x14b/0x170
[ 2017.406929]  ? __kthread_bind_mask+0x60/0x60
[ 2017.407638]  ret_from_fork+0x1f/0x30
[ 2017.408323] XFS (sdf): Corruption detected. Unmount and run xfs_repair
[ 2017.409467] XFS (sdf): Invalid inode number 0x104380
[ 2017.410301] XFS (sdf): Metadata corruption detected at xfs_dir2_sf_verify+0x268/0x2d0 [xfs], inode 0x4fb6 data fork
[ 2017.412095] XFS (sdf): Unmount and run xfs_repair
[ 2017.412675] XFS (sdf): First 72 bytes of corrupted metadata buffer:
[ 2017.413393] 00000000: 06 00 00 10 42 60 03 00 60 63 37 61 03 00 10 43  ....B`..`c7a...C
[ 2017.414286] 00000010: 80 03 00 70 64 38 39 02 00 00 4f bd 03 00 80 72  ...pd89...O....r
[ 2017.415390] 00000020: 38 65 01 00 10 43 32 03 00 90 72 61 62 01 00 00  8e...C2...rab...
[ 2017.416633] 00000030: 4e 3f 03 00 a0 66 62 34 01 00 00 51 1e 03 00 b0  N?...fb4...Q....
[ 2017.417733] 00000040: 63 66 61 03 00 00 50 9e                          cfa...P.
[ 2017.418810] XFS (sdf): metadata I/O error in "xfs_buf_ioend+0x219/0x520 [xfs]" at daddr 0x4fa0 len 32 error 5
[ 2017.420397] XFS (sdf): xfs_do_force_shutdown(0x8) called from line 2798 of file fs/xfs/xfs_inode.c. Return address = ffffffffa03a6018
[ 2017.422171] XFS (sdf): Corruption of in-memory data detected.  Shutting down filesystem
[ 2017.423348] XFS (sdf): Please unmount the filesystem and rectify the problem(s)
[ 2017.631561] XFS (sda): Unmounting Filesystem

At first glance this /looks/ like we might have shrunk the filesystem
too far, after which the shortform directory verifier tripped, which
caused a shutdown.  Inode 0x104380 is very close to the end of the
filesystem.

I altered xfs/168 to spit out metadumps and captured one here:
https://djwong.org/docs/168.iloop.131446.md.xz

I'll keep looking, but on the off chance this rings a bell for anyone.

Wait, something just rang a bell for me.  I was looking through
Allison's xattrs patchset and read the comment in xfs_attr_rmtval_set
about how it has to perform a "user data" allocation for the remote
value blocks because we don't log attr value blocks and therefore cannot
overwrite blocks which have recently been freed but their transactions
are not yet committed to disk.

Doesn't shrink have to ensure that the log cannot contain any further
updates for the blocks it wants to remove from the filesystem?  In other
words, should xfs_ag_shrink_space be setting XFS_ALLOC_USERDATA so that
the allocator will make us wait for the EOFS blocks to free up if
they're busy?

--D
