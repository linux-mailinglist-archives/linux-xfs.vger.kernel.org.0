Return-Path: <linux-xfs+bounces-24367-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E555B16454
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Jul 2025 18:14:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9735E188C1F7
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Jul 2025 16:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F0D52E6139;
	Wed, 30 Jul 2025 16:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ywz0kAsZ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04AB2E62B2
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 16:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753891731; cv=none; b=hisrVSOJy88OyrJXJrtNI61sA3oW7Lrk9fKTSLBr6k8KuBLoNBsN2ex67EEDpcYY9TkCT1L9yf3ALeYZazp0/rx9WDHiArs0oq1SoYZFp2f9c4+SDJTJDyOUgrP9N84NSCY/OlvvgvojSB+zKW5hzRgUkT41UQKZIYvVipSPwaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753891731; c=relaxed/simple;
	bh=bNJ4x0kSumzK+8tuBp2GL8zIovSwzz6Vl9n48wq2ztc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BvB08xHwRmtngiwkfLP0bML+TKe5SdXrqb4WZ8L7NhXVNVBd8cc8nwqCtATfLt2SPEZxMP9TUzB3Uqra340jc0jl4sL36EvDOPLsr/5ZRXQyS8ZlF5MVrBqUs5vwxCtvsCLdyXjTDEzOH36bp61CB+d6qMFgXcf4uFgUEpUXrpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ywz0kAsZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69986C4CEE7;
	Wed, 30 Jul 2025 16:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753891730;
	bh=bNJ4x0kSumzK+8tuBp2GL8zIovSwzz6Vl9n48wq2ztc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ywz0kAsZKylI+t8dh3tfYslbW3y+Yrf3mT1TSPgSJaMG6yleWG8g8pv6iC0cpHyxu
	 MjuLab2MK6KD8Z+QnwfTapYSigwlZYFK3QrSxEJ4BdYu1S9VktuA6wZ2HjbMtYSL03
	 85VzPbxrsCQa37HPIP092TBt5Stl2aNn+goVw784t9FbcIiG5ywwrB9GX/geBdzg3x
	 G3KTjHS4UiaGnwc8lDf4oniWRGsADnYCkpPmuO4TaO2rRWNq594DolgsCqDtzu9U4w
	 GiKRQvCfXuF+umEjf8eox9iTDim4PcemDEOVijxqlMD6ytsDbbAxlNHy2Bz97Ri2m9
	 rC8Z6bbv2bscg==
Date: Wed, 30 Jul 2025 09:08:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [ regression] WARNING: CPU: 15 PID: 321705 at
 fs/xfs/xfs_trans.c:256 xfs_trans_alloc+0x19b/0x280
Message-ID: <20250730160849.GH2672070@frogsfrogsfrogs>
References: <4Pdlams-6A6GKExDCiB0UCMs05wgppYESFHPkiWWLomRD-zUJABHPKzUijI8wpMOGqJUEgmdH-CGMHWXzl-2Lg==@protonmail.internalid>
 <aImAfw5TLefSY9Ha@dread.disaster.area>
 <5buaxegd7ojyrovcuk5bke4re3stb5d6lpfpeog2t7zy6ggrxj@gyacvoh26bqv>
 <S4Pnp-OInGCJ6Wsj2N0ck5DC4sxWx8I1JV6F_hRk7vmL05Z3WVohFtywBfqy5Os3Znolf79WU2xc5MCT938NfA==@protonmail.internalid>
 <20250730152409.GR2672049@frogsfrogsfrogs>
 <wde2dc5xiukoglhrymvho7wn7z7aq6opqh3uao7o7kp43jtsrv@fe2vfb7ve664>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wde2dc5xiukoglhrymvho7wn7z7aq6opqh3uao7o7kp43jtsrv@fe2vfb7ve664>

On Wed, Jul 30, 2025 at 05:35:45PM +0200, Carlos Maiolino wrote:
> On Wed, Jul 30, 2025 at 08:24:09AM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 30, 2025 at 05:16:22PM +0200, Carlos Maiolino wrote:
> > > On Wed, Jul 30, 2025 at 12:16:31PM +1000, Dave Chinner wrote:
> > > > Hi folks,
> > > >
> > > > Just pulled the latest Linus kernel and running it through
> > > > check-parallel on a 1kB block size filesystem throws a lots of these
> > > > warnings:
> > > >
> > > >  ------------[ cut here ]------------
> > > >  WARNING: CPU: 15 PID: 321705 at fs/xfs/xfs_trans.c:256 xfs_trans_alloc+0x19b/0x280
> > > >  Modules linked in:
> > > >  CPU: 15 UID: 0 PID: 321705 Comm: kworker/15:9 Tainted: G        W           6.16.0-dgc+ #349 PREEMPT(full)
> > > >  Tainted: G   WARN
> > >
> > > FWIW, I *just* hit the assertion below on generic/475 running with 1k
> > > blocks:
> > >
> > > My apologies for not having much more information, I didn't have time to debug
> > > it yet. I'm posting it here for broader audience by now as I haven't seen this
> > > before, I'll try to find some time to look more into it.
> > 
> > Can you post the ~20 or so lines before timestamp 6690.585792?  That'll
> > tell us where the actual validation failure came from.
> 
> Woops, sorry, my bad
> 
> /me recovers from journalctl...
> 
> Jul 30 05:09:44 kvm-03-guest-02 Buffer I/O error on dev dm-0, logical block 41942914, async page read
> Jul 30 05:09:44 kvm-03-guest-02 Buffer I/O error on dev dm-0, logical block 41942915, async page read
> Jul 30 05:09:44 kvm-03-guest-02 Buffer I/O error on dev dm-0, logical block 41942916, async page read
> Jul 30 05:09:44 kvm-03-guest-02 Buffer I/O error on dev dm-0, logical block 41942917, async page read
> Jul 30 05:09:44 kvm-03-guest-02 Buffer I/O error on dev dm-0, logical block 41942918, async page read
> Jul 30 05:09:44 kvm-03-guest-02 Buffer I/O error on dev dm-0, logical block 41942919, async page read
> Jul 30 05:09:44 kvm-03-guest-02 XFS (dm-0): Unmounting Filesystem 1ea140bb-1c75-4cbf-b223-fbc920d915dc
> Jul 30 05:09:44 kvm-03-guest-02 XFS (dm-0): Mounting V5 Filesystem 1ea140bb-1c75-4cbf-b223-fbc920d915dc
> Jul 30 05:09:44 kvm-03-guest-02 XFS (dm-0): Starting recovery (logdev: /dev/mapper/error-logtest.475)
> Jul 30 05:09:45 kvm-03-guest-02 XFS (dm-0): Ending recovery (logdev: /dev/mapper/error-logtest.475)
> Jul 30 05:09:46 kvm-03-guest-02 Buffer I/O error on dev dm-1, logical block 243952, async page read
> Jul 30 05:09:46 kvm-03-guest-02 iomap_finish_ioend_buffered: 13 callbacks suppressed
> Jul 30 05:09:46 kvm-03-guest-02 dm-0: writeback error on inode 34139758, offset 937984, sector 21556064
> Jul 30 05:09:46 kvm-03-guest-02 dm-0: writeback error on inode 2291073, offset 983040, sector 2775570
> Jul 30 05:09:46 kvm-03-guest-02 dm-0: writeback error on inode 36255614, offset 6242304, sector 23842146
> Jul 30 05:09:46 kvm-03-guest-02 dm-0: writeback error on inode 51105153, offset 105472, sector 33829804
> Jul 30 05:09:46 kvm-03-guest-02 dm-0: writeback error on inode 2291073, offset 949248, sector 2775504
> Jul 30 05:09:46 kvm-03-guest-02 XFS (dm-0): metadata I/O error in "xfs_btree_read_buf_block+0xb7/0x170 [xfs]" at daddr 0x1c06e len 2 error 5
> Jul 30 05:09:46 kvm-03-guest-02 XFS (dm-0): log I/O error -5
> Jul 30 05:09:46 kvm-03-guest-02 XFS (dm-0): log I/O error -5
> Jul 30 05:09:46 kvm-03-guest-02 dm-0: writeback error on inode 34294626, offset 617472, sector 23879134
> Jul 30 05:09:46 kvm-03-guest-02 dm-0: writeback error on inode 651041, offset 7212032, sector 13289178
> Jul 30 05:09:46 kvm-03-guest-02 dm-0: writeback error on inode 651041, offset 7569408, sector 13301400
> Jul 30 05:09:46 kvm-03-guest-02 XFS (dm-0): log I/O error -5
> Jul 30 05:09:46 kvm-03-guest-02 dm-0: writeback error on inode 2028146, offset 184320, sector 2789202
> Jul 30 05:09:46 kvm-03-guest-02 dm-0: writeback error on inode 17609905, offset 2296832, sector 12848410
> Jul 30 05:09:46 kvm-03-guest-02 XFS (dm-0): log I/O error -5
> Jul 30 05:09:46 kvm-03-guest-02 XFS (dm-0): log I/O error -5
> Jul 30 05:09:46 kvm-03-guest-02 XFS (dm-0): Metadata I/O Error (0x1) detected at xfs_trans_read_buf_map+0x1fe/0x4c0 [xfs] (fs/xfs/xfs_trans_buf.c:311).  Shutting down filesystem.
> Jul 30 05:09:46 kvm-03-guest-02 XFS (dm-0): Please unmount the filesystem and rectify the problem(s)
> Jul 30 05:09:46 kvm-03-guest-02 XFS (dm-0): Unmounting Filesystem 1ea140bb-1c75-4cbf-b223-fbc920d915dc
> Jul 30 05:09:47 kvm-03-guest-02 XFS (dm-0): Mounting V5 Filesystem 1ea140bb-1c75-4cbf-b223-fbc920d915dc
> Jul 30 05:09:47 kvm-03-guest-02 XFS (dm-0): Starting recovery (logdev: /dev/mapper/error-logtest.475)
> Jul 30 05:09:47 kvm-03-guest-02 XFS (dm-0): Ending recovery (logdev: /dev/mapper/error-logtest.475)
> Jul 30 05:09:49 kvm-03-guest-02 buffer_io_error: 8 callbacks suppressed
> Jul 30 05:09:49 kvm-03-guest-02 Buffer I/O error on dev dm-1, logical block 243952, async page read
> Jul 30 05:09:49 kvm-03-guest-02 XFS (dm-0): metadata I/O error in "xfs_btree_read_buf_block+0xb7/0x170 [xfs]" at daddr 0x14669bc len 2 error 5
> Jul 30 05:09:49 kvm-03-guest-02 XFS (dm-0): metadata I/O error in "xfs_btree_read_buf_block+0xb7/0x170 [xfs]" at daddr 0xa02598 len 2 error 5
> Jul 30 05:09:49 kvm-03-guest-02 XFS (dm-0): log I/O error -5
> Jul 30 05:09:49 kvm-03-guest-02 XFS (dm-0): log I/O error -5
> Jul 30 05:09:49 kvm-03-guest-02 Buffer I/O error on dev dm-0, logical block 41942912, async page read
> Jul 30 05:09:49 kvm-03-guest-02 Buffer I/O error on dev dm-0, logical block 41942913, async page read
> Jul 30 05:09:49 kvm-03-guest-02 Buffer I/O error on dev dm-0, logical block 41942914, async page read
> Jul 30 05:09:49 kvm-03-guest-02 Buffer I/O error on dev dm-0, logical block 41942915, async page read
> Jul 30 05:09:49 kvm-03-guest-02 Buffer I/O error on dev dm-0, logical block 41942916, async page read
> Jul 30 05:09:49 kvm-03-guest-02 Buffer I/O error on dev dm-0, logical block 41942917, async page read
> Jul 30 05:09:49 kvm-03-guest-02 Buffer I/O error on dev dm-0, logical block 41942918, async page read
> Jul 30 05:09:49 kvm-03-guest-02 Buffer I/O error on dev dm-0, logical block 41942919, async page read
> Jul 30 05:09:49 kvm-03-guest-02 XFS (dm-0): log I/O error -5
> Jul 30 05:09:49 kvm-03-guest-02 XFS (dm-0): log I/O error -5
> Jul 30 05:09:49 kvm-03-guest-02 XFS (dm-0): log I/O error -5
> Jul 30 05:09:49 kvm-03-guest-02 XFS (dm-0): log I/O error -5
> Jul 30 05:09:49 kvm-03-guest-02 XFS (dm-0): log I/O error -5
> Jul 30 05:09:49 kvm-03-guest-02 XFS (dm-0): Metadata I/O Error (0x1) detected at xfs_trans_read_buf_map+0x1fe/0x4c0 [xfs] (fs/xfs/xfs_trans_buf.c:311).  Shutting down filesystem.
> Jul 30 05:09:49 kvm-03-guest-02 XFS (dm-0): Please unmount the filesystem and rectify the problem(s)
> Jul 30 05:09:49 kvm-03-guest-02 XFS (dm-0): Metadata corruption detected at xfs_dinode_verify.part.0+0x434/0xcb0 [xfs], inode 0x11cfdad xfs_inode_item_precommit_check

Could you addr2line xfs_dinode_verify.part.0+0x434/0xcb0, please?

--D

> Jul 30 05:09:49 kvm-03-guest-02 XFS (dm-0): Unmount and run xfs_repair
> 
> > 
> > > [ 6690.585792] XFS (dm-0): First 128 bytes of corrupted metadata buffer:
> > > [ 6690.587280] 00000000: 49 4e 81 b6 03 02 00 00 00 00 00 00 00 00 00 00  IN..............
> > > [ 6690.588985] 00000010: 00 00 00 03 00 00 00 00 00 00 00 00 00 00 00 0d  ................
> > > [ 6690.590491] 00000020: 36 24 61 5e d4 57 d4 cc 36 24 61 5e e7 1e 59 8c  6$a^.W..6$a^..Y.
> > > [ 6690.592160] 00000030: 36 24 61 5e e7 1e 59 8c 00 00 00 00 00 52 8a 13  6$a^..Y......R..
> > > [ 6690.593338] 00000040: 00 00 00 00 00 00 02 ce 00 00 00 00 00 00 00 00  ................
> > > [ 6690.594100] 00000050: 00 00 18 01 00 00 00 00 00 00 00 02 3e 8f 13 e2  ............>...
> > > [ 6690.594878] 00000060: 00 00 00 00 e6 2b 99 8d 00 00 00 00 00 00 00 26  .....+.........&
> > > [ 6690.595686] 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1a  ................
> > > [ 6690.596431] XFS: Assertion failed: fa == NULL, file: fs/xfs/xfs_inode_item.c, line: 62
> > > [ 6690.597549] ------------[ cut here ]------------
> > > [ 6690.597983] kernel BUG at fs/xfs/xfs_message.c:102!
> > > [ 6690.598529] Oops: invalid opcode: 0000 [#1] SMP NOPTI
> > > [ 6690.599185] CPU: 15 UID: 0 PID: 3235576 Comm: fsstress Not tainted 6.16.0+ #2 PREEMPT(voluntary)
> > > [ 6690.600061] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
> > > [ 6690.601054] RIP: 0010:assfail+0x35/0x3f [xfs]
> > > [ 6690.601725] Code: 89 d0 41 89 c9 48 c7 c2 b0 96 3b c0 48 89 f1 48 89 fe 48 c7 c7 03 67 3a c0
> > > 		     48 89 e5 e8 a4 fd ff ff 80 3d 35 98 26 00 00 74 02 <0f> 0b 0f 0b 5d c3 cc
> > > 		     cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
> > > [ 6690.603330] RSP: 0018:ffffb6e0619078a0 EFLAGS: 00010202
> > > [ 6690.603985] RAX: 0000000000000000 RBX: ffff9de24ebff6a8 RCX: 000000007fffffff
> > > [ 6690.604648] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffc03a6703
> > > [ 6690.605481] RBP: ffffb6e0619078a0 R08: 0000000000000000 R09: 000000000000000a
> > > [ 6690.606122] R10: 000000000000000a R11: 0fffffffffffffff R12: ffff9de25040e400
> > > [ 6690.606727] R13: ffff9de2415d9e00 R14: ffff9de24fd66000 R15: ffff9de29126d6a8
> > > [ 6690.607590] FS:  00007fc229e6c740(0000) GS:ffff9de61b969000(0000) knlGS:0000000000000000
> > > [ 6690.608241] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [ 6690.608781] CR2: 00007fc229e6b000 CR3: 000000035eab0004 CR4: 0000000000772ef0
> > > [ 6690.609381] PKRU: 55555554
> > > [ 6690.609606] Call Trace:
> > > [ 6690.609923]  <TASK>
> > > [ 6690.610276]  xfs_inode_item_precommit+0x18d/0x390 [xfs]
> > > [ 6690.611061]  __xfs_trans_commit+0xba/0x410 [xfs]
> > > [ 6690.611898]  xfs_trans_commit+0x3b/0x70 [xfs]
> > > [ 6690.612514]  xfs_vn_update_time+0xee/0x1a0 [xfs]
> > > [ 6690.613164]  file_modified+0x80/0xb0
> > > [ 6690.613477]  __xfs_file_fallocate+0xaf/0x4d0 [xfs]
> > > [ 6690.614262]  xfs_file_fallocate+0x76/0x140 [xfs]
> > > [ 6690.615163]  vfs_fallocate+0x16e/0x3a0
> > > [ 6690.615504]  __x64_sys_fallocate+0x4e/0xb0
> > > [ 6690.615852]  x64_sys_call+0xf55/0x1d80
> > > [ 6690.616170]  do_syscall_64+0x7f/0x2c0
> > > [ 6690.616478]  ? security_inode_permission+0x51/0xd0
> > > [ 6690.616871]  ? __legitimize_path+0x30/0x70
> > > [ 6690.617203]  ? try_to_unlazy+0x63/0xe0
> > > [ 6690.617518]  ? avc_has_perm_noaudit+0x6e/0xf0
> > > [ 6690.617879]  ? avc_has_perm+0x5b/0xf0
> > > [ 6690.618178]  ? _copy_to_user+0x35/0x50
> > > [ 6690.618492]  ? cp_new_stat+0x141/0x180
> > > [ 6690.618799]  ? __do_sys_newfstat+0x4c/0x80
> > > [ 6690.619138]  ? __x64_sys_newfstat+0x19/0x20
> > > [ 6690.619486]  ? x64_sys_call+0x1b97/0x1d80
> > > [ 6690.619810]  ? do_syscall_64+0x7f/0x2c0
> > > [ 6690.620206]  ? __x64_sys_newfstatat+0x20/0x30
> > > [ 6690.620566]  ? x64_sys_call+0x10bc/0x1d80
> > > [ 6690.620897]  ? do_syscall_64+0x7f/0x2c0
> > > [ 6690.621213]  ? clear_bhb_loop+0x50/0xa0
> > > [ 6690.621533]  ? clear_bhb_loop+0x50/0xa0
> > > [ 6690.621843]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > > [ 6690.622257] RIP: 0033:0x7fc229f57457
> > > [ 6690.622580] Code: 10 00 f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 80
> > > 		     3d 75 8c 10 00 00 49 89 ca 74 10 b8 1d 01 00 00 0f 05 <48> 3d 00 f0 ff
> > > 		     ff 77 51 c3 55 48 89 e5 48 83 ec 20 48 89 55 f0 89
> > > [ 6690.624055] RSP: 002b:00007fffec23e628 EFLAGS: 00000202 ORIG_RAX: 000000000000011d
> > > [ 6690.624661] RAX: ffffffffffffffda RBX: 0000000000000e2b RCX: 00007fc229f57457
> > > [ 6690.625233] RDX: 0000000000452000 RSI: 0000000000000008 RDI: 0000000000000003
> > > [ 6690.625803] RBP: 0000000000000008 R08: 0000000000000051 R09: 00007fffec23e64c
> > > [ 6690.626496] R10: 0000000000018000 R11: 0000000000000202 R12: 00007fffec23e6f0
> > > [ 6690.627070] R13: 0000000000000003 R14: 0000000000018000 R15: 0000000000000000
> > > [ 6690.627650]  </TASK>
> > > [ 6690.627841] Modules linked in: dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot
> > > 				  dm_bufio dm_flakey ip_set nf_tables sunrpc intel_rapl_msr
> > > 				  intel_rapl_common intel_uncore_frequency_common kvm_intel
> > > 				  kvm iTCO_wdt intel_pmc_bxt iTCO_vendor_support
> > > 				  irqbypass i2c_i801 rapl i2c_smbus lpc_ich virtio_balloon
> > > 				  joydev loop dm_mod nfnetlink zram xfs polyval_clmulni
> > > 				  ghash_clmulni_intel serio_raw fuse qemu_fw_cfg
> > > 				  [last unloaded: scsi_debug]
> > > [ 6690.631650] ---[ end trace 0000000000000000 ]---
> > > [ 6690.632043] RIP: 0010:assfail+0x35/0x3f [xfs]
> > > [ 6690.632656] Code: 89 d0 41 89 c9 48 c7 c2 b0 96 3b c0 48 89 f1 48 89 fe 48 c7 c7 03 67 3a
> > > 		     c0 48 89 e5 e8 a4 fd ff ff 80 3d 35 98 26 00 00 74 02 <0f> 0b 0f 0b 5d
> > > 		     c3 cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
> > > [ 6690.634150] RSP: 0018:ffffb6e0619078a0 EFLAGS: 00010202
> > > [ 6690.634571] RAX: 0000000000000000 RBX: ffff9de24ebff6a8 RCX: 000000007fffffff
> > > [ 6690.635370] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffc03a6703
> > > [ 6690.636276] RBP: ffffb6e0619078a0 R08: 0000000000000000 R09: 000000000000000a
> > > [ 6690.637083] R10: 000000000000000a R11: 0fffffffffffffff R12: ffff9de25040e400
> > > [ 6690.637656] R13: ffff9de2415d9e00 R14: ffff9de24fd66000 R15: ffff9de29126d6a8
> > > [ 6690.638236] FS:  00007fc229e6c740(0000) GS:ffff9de61b969000(0000) knlGS:0000000000000000
> > > [ 6690.638884] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [ 6690.639352] CR2: 00007fc229e6b000 CR3: 000000035eab0004 CR4: 0000000000772ef0
> > > [ 6690.639922] PKRU: 55555554
> > > [ 6690.773340] XFS: Assertion failed: !rwsem_is_locked(&inode->i_rwsem), file: fs/xfs/xfs_super.c, line: 699
> > 
> > Ohhh that's bad, whatever went wrong we also fail to inode_unlock.
> > 
> > --D
> > 
> > > [ 6690.774539] ------------[ cut here ]------------
> > > [ 6690.775033] kernel BUG at fs/xfs/xfs_message.c:102!
> > > [ 6690.775504] Oops: invalid opcode: 0000 [#2] SMP NOPTI
> > > [ 6690.776058] CPU: 3 UID: 0 PID: 3235665 Comm: umount Tainted: G      D             6.16.0+ #2 PREEMPT(voluntary)
> > > [ 6690.776925] Tainted: [D]=DIE
> > > [ 6690.777165] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
> > > [ 6690.777835] RIP: 0010:assfail+0x35/0x3f [xfs]
> > > [ 6690.778463] Code: 89 d0 41 89 c9 48 c7 c2 b0 96 3b c0 48 89 f1 48 89 fe 48 c7 c7 03 67 3a
> > > 		     c0 48 89 e5 e8 a4 fd ff ff 80 3d 35 98 26 00 00 74 02 <0f> 0b 0f 0b 5d
> > > 		     c3 cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
> > > [ 6690.779917] RSP: 0018:ffffb6e061247c98 EFLAGS: 00010202
> > > [ 6690.780338] RAX: 0000000000000000 RBX: ffff9de25040e538 RCX: 000000007fffffff
> > > [ 6690.780902] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffc03a6703
> > > [ 6690.781468] RBP: ffffb6e061247c98 R08: 0000000000000000 R09: 000000000000000a
> > > [ 6690.782288] R10: 000000000000000a R11: 0fffffffffffffff R12: ffffffffc038c360
> > > [ 6690.782878] R13: ffff9de25040e400 R14: ffff9de25040e538 R15: ffff9de24eb0ad38
> > > [ 6690.783446] FS:  00007f48df3e9800(0000) GS:ffff9de61b369000(0000) knlGS:0000000000000000
> > > [ 6690.784092] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [ 6690.784555] CR2: 00007ffe61fe3d6c CR3: 000000010e717002 CR4: 0000000000772ef0
> > > [ 6690.785127] PKRU: 55555554
> > > [ 6690.785360] Call Trace:
> > > [ 6690.785566]  <TASK>
> > > [ 6690.785748]  xfs_fs_destroy_inode+0x16b/0x1c0 [xfs]
> > > [ 6690.786445]  destroy_inode+0x41/0x80
> > > [ 6690.786747]  evict+0x1b9/0x290
> > > [ 6690.787006]  evict_inodes+0x1fe/0x220
> > > [ 6690.787302]  generic_shutdown_super+0x47/0x110
> > > [ 6690.787677]  kill_block_super+0x1f/0x50
> > > [ 6690.787997]  xfs_kill_sb+0x16/0x30 [xfs]
> > > [ 6690.788593]  deactivate_locked_super+0x39/0xb0
> > > [ 6690.788959]  deactivate_super+0x44/0x50
> > > [ 6690.789269]  cleanup_mnt+0xc3/0x160
> > > [ 6690.789566]  __cleanup_mnt+0x16/0x20
> > > [ 6690.789870]  task_work_run+0x64/0xa0
> > > [ 6690.790160]  exit_to_user_mode_loop+0x132/0x160
> > > [ 6690.790554]  do_syscall_64+0x193/0x2c0
> > > [ 6690.790884]  ? irqentry_exit+0x3f/0x50
> > > [ 6690.791350]  ? clear_bhb_loop+0x50/0xa0
> > > [ 6690.791684]  ? clear_bhb_loop+0x50/0xa0
> > > [ 6690.792005]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > > [ 6690.792420] RIP: 0033:0x7f48df5ecd6b
> > > [ 6690.792737] Code: c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 f3 0f 1e fa 31 f6 e9 05 00
> > > 		     00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff
> > > 		     ff 77 05 c3 0f 1f 40 00 48 8b 15 71 30 0f 00 f7 d8
> > > [ 6690.794204] RSP: 002b:00007ffe61fe5508 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> > > [ 6690.794820] RAX: 0000000000000000 RBX: 000055cacecb1420 RCX: 00007f48df5ecd6b
> > > [ 6690.795552] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000055cacecb74d0
> > > [ 6690.796400] RBP: 00007ffe61fe55e0 R08: 000055cacecb1010 R09: 0000000000000007
> > > [ 6690.797255] R10: 0000000000000000 R11: 0000000000000246 R12: 000055cacecb1528
> > > [ 6690.797825] R13: 0000000000000000 R14: 000055cacecb74d0 R15: 000055cacecb74a0
> > > [ 6690.798399]  </TASK>
> > > [ 6690.798590] Modules linked in: dm_thin_pool dm_persistent_data dm_bio_prison dm_snapshot
> > > 				  dm_bufio dm_flakey ip_set nf_tables sunrpc intel_rapl_msr
> > > 				  intel_rapl_common intel_uncore_frequency_common kvm_intel
> > > 				  kvm iTCO_wdt intel_pmc_bxt iTCO_vendor_support irqbypass
> > > 				  i2c_i801 rapl i2c_smbus lpc_ich virtio_balloon joydev
> > > 				  loop dm_mod nfnetlink zram xfs polyval_clmulni
> > > 				  ghash_clmulni_intel serio_raw fuse qemu_fw_cfg
> > > 				  [last unloaded: scsi_debug]
> > > [ 6690.802742] ---[ end trace 0000000000000000 ]---
> > > [ 6690.803147] RIP: 0010:assfail+0x35/0x3f [xfs]
> > > [ 6690.803726] Code: 89 d0 41 89 c9 48 c7 c2 b0 96 3b c0 48 89 f1 48 89 fe 48 c7 c7 03 67 3a
> > > 		     c0 48 89 e5 e8 a4 fd ff ff 80 3d 35 98 26 00 00 74 02 <0f> 0b 0f 0b 5d c3
> > > 		     cc cc cc cc 48 8d 45 10 4c 8d 6c 24 10 48 89 e2
> > > [ 6690.805205] RSP: 0018:ffffb6e0619078a0 EFLAGS: 00010202
> > > [ 6690.805629] RAX: 0000000000000000 RBX: ffff9de24ebff6a8 RCX: 000000007fffffff
> > > [ 6690.806252] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffc03a6703
> > > [ 6690.806818] RBP: ffffb6e0619078a0 R08: 0000000000000000 R09: 000000000000000a
> > > [ 6690.807392] R10: 000000000000000a R11: 0fffffffffffffff R12: ffff9de25040e400
> > > [ 6690.807964] R13: ffff9de2415d9e00 R14: ffff9de24fd66000 R15: ffff9de29126d6a8
> > > [ 6690.808530] FS:  00007f48df3e9800(0000) GS:ffff9de61b369000(0000) knlGS:0000000000000000
> > > [ 6690.809189] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [ 6690.809650] CR2: 00007ffe61fe3d6c CR3: 000000010e717002 CR4: 0000000000772ef0
> > > [ 6690.810226] PKRU: 55555554
> > > [27605.136424] XFS (vdb1): Unmounting Filesystem 83bac02f-3cc7-4758-aaaa-7021c100acb1
> > > [27606.335870] run fstests generic/475 at 2025-07-30 10:58:25
> > >
> > >

