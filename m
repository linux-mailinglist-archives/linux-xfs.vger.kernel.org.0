Return-Path: <linux-xfs+bounces-6114-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC648931C4
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Mar 2024 15:48:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DE351C210B2
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Mar 2024 13:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3F6144D19;
	Sun, 31 Mar 2024 13:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fa6abe1Q"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E390144D1B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Mar 2024 13:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711892879; cv=none; b=AwgTod/UriVAmu5ppKbLhRT86uc1rIelO0spyFDRccyCOs+uvb2/ryP0kqx/sh+ibcRiMmGPp7jnCJx0NQITZwfi0EQjJKphfsvh0D5d67gq2RzJY1iWrrLsqDzapyu4/q5qus0DLMyAiHrQCHnq81gYU/3xqpgmEdWU/vCym8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711892879; c=relaxed/simple;
	bh=pwuXmO4ia4N2YnB17KxQvScvgBJdoWtyhfvng0j0bZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwS8Yd00YnFj8RWx0/dL5JXizOGks22NlyRyzu4sMt5EZtmvt4kQr/l+MYx104YpNLBxzmlhBqlQ+LU0iycocaLdvAHvCzFb/gVd0LG8sfmfBcnIXatSzPtxpkP8KQ5EnMpPlt0tnZNSUQjCX0jxDg150RK7alk6cpCs5SNVifI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fa6abe1Q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711892875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OVpWpiJ3Lr2bdir73Tl+2ikmjgMYhUj/FC5dKBUS7hE=;
	b=fa6abe1QIIQNoQ3mDjs+TSjvw3l0CP6CXYalmH9F4dZuJLh9H7cY9F8TPEVH/udxhPIiIe
	H/MNYHJGQqSYFsYH967fjT5F7DUVVhS8rmEHG6XT/OvstjNR4K0agytJ4OOAbInzlywEns
	iEo1f2MrE/dVJvF5nOxAz/mcbjjqRJA=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-D9eTsxy_OEebr6krdAediQ-1; Sun, 31 Mar 2024 09:47:53 -0400
X-MC-Unique: D9eTsxy_OEebr6krdAediQ-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6eab623fdadso3178700b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 31 Mar 2024 06:47:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711892872; x=1712497672;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OVpWpiJ3Lr2bdir73Tl+2ikmjgMYhUj/FC5dKBUS7hE=;
        b=A0RYhiYiUY9MbH9xIG81YxyVUvG4jtFRE3OoOEv/j+pIus9empZtN58qFYzgW1Cycq
         zb1CVdr4kx8BBHcUvjNDadzLWKY7+k5GaytLwFmbeIeMY8U+p/7x+tSZ1z3TjTtEDvFt
         azHtGIZm6xof5wEkfYoUiTQZFeE9OhajmNPft4QIr3daQIQsfsCR8IkWVYsv0/nuPoIi
         a/yuWEegmIxFandMZ7EHJUsEUbka3n+/XIb6D1/7WVPwcM2tSy04AhUaUwfpBb+ycH8W
         EGUX7IJ1Mtf7PgBNn5M7S/fVrO8YR4x+6WvaYwFO3LmsRLug+3cvehyuO5M6zKfmr+m1
         BcGg==
X-Gm-Message-State: AOJu0Yw9yiRHzfF+h5gKjzA/A80KNGTOlK5WgHr1Sr0hhBD8J2s7diQF
	KddZYLu+m9bWJwAslNKDtJPISZg5iyIFN87u73V59FjCcZ7JtxWyCJwTL162Q8171QorTjCZFDp
	DM4aRykGytz5Ha4s8XpKrjjOCnvlmmO4EJkZ2m8+9XKDEjSVlkPpgJN4A7Z59jgXkpq+a
X-Received: by 2002:a05:6a21:194:b0:1a3:c4ea:f528 with SMTP id le20-20020a056a21019400b001a3c4eaf528mr7140696pzb.43.1711892871991;
        Sun, 31 Mar 2024 06:47:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH49THihiOimtRIpVipkzqCp9finM9MzzCulzn4svM4qLigUNUY3MDdCXk6y1lkWBva9YyUCQ==
X-Received: by 2002:a05:6a21:194:b0:1a3:c4ea:f528 with SMTP id le20-20020a056a21019400b001a3c4eaf528mr7140673pzb.43.1711892871312;
        Sun, 31 Mar 2024 06:47:51 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 13-20020a630b0d000000b005e840ad9aaesm6034409pgl.30.2024.03.31.06.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 06:47:50 -0700 (PDT)
Date: Sun, 31 Mar 2024 21:47:47 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: Re: asserts triggered on 6.9-rc1?
Message-ID: <20240331134747.sr5yuncgg7v3bvpg@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240329231807.GS6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240329231807.GS6390@frogsfrogsfrogs>

On Fri, Mar 29, 2024 at 04:18:07PM -0700, Darrick J. Wong wrote:
> Hrmm.  Has anyone else seen a crash like this on 6.9-rc1?  Particularly
> with arm64?  I know Chandan was reporting that something in this week's
> for-next branches have been causing different problems.

I didn't hit hit assertion by running fstests (include x/559) on aarch64,
x86_64, s390x and ppc64le with some different mkfs options this weeked.
Maybe my testing env. isn't able to trigger it?

About xfs, I just hit a small warnning as [1], but the test wasn't blocked.

Thanks,
Zorro

[1]
[ 3032.280610] run fstests generic/048 at 2024-03-30 06:33:07
[ 3035.954986] XFS (sda3): Mounting V5 Filesystem 4f561151-a8b0-4be0-8ba4-95ff611b072b
[ 3036.105248] XFS (sda3): Ending clean mount
[ 3036.112786] XFS (sda3): User initiated shutdown received.
[ 3036.112859] XFS (sda3): Metadata I/O Error (0x4) detected at xfs_fs_goingdown+0x70/0x160 [xfs] (fs/xfs/xfs_fsops.c:455).  Shutting down filesystem.
[ 3036.112959] XFS (sda3): Please unmount the filesystem and rectify the problem(s)
[ 3036.117280] XFS (sda3): Unmounting Filesystem 4f561151-a8b0-4be0-8ba4-95ff611b072b
[ 3039.032295] XFS (sda3): Mounting V5 Filesystem 21e84352-bca0-44b5-9a8a-aa6469c8e2f9
[ 3039.368803] XFS (sda3): Ending clean mount

[ 3055.417773] ======================================================
[ 3055.417777] WARNING: possible circular locking dependency detected
[ 3055.417781] 6.9.0-rc1+ #1 Not tainted
[ 3055.417785] ------------------------------------------------------
[ 3055.417788] kswapd1/83 is trying to acquire lock:
[ 3055.417792] c00000003bbc3d20 (&xfs_nondir_ilock_class#3){++++}-{3:3}, at: xfs_ilock+0x164/0x3b8 [xfs]
[ 3055.417892] 
               but task is already holding lock:
[ 3055.417895] c000000002dbe5b0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x10/0x8d8
[ 3055.417908] 
               which lock already depends on the new lock.

[ 3055.417912] 
               the existing dependency chain (in reverse order) is:
[ 3055.417915] 
               -> #1 (fs_reclaim){+.+.}-{0:0}:
[ 3055.417922]        __lock_acquire+0x5c8/0xf60
[ 3055.417928]        lock_acquire.part.0+0xd0/0x280
[ 3055.417934]        fs_reclaim_acquire+0xe0/0x140
[ 3055.417940]        __kmalloc+0xd0/0x598
[ 3055.417944]        xfs_attr_shortform_list+0x228/0x7c0 [xfs]
[ 3055.418032]        xfs_attr_list+0xac/0xec [xfs]
[ 3055.418119]        xfs_vn_listxattr+0xa4/0x10c [xfs]
[ 3055.418202]        vfs_listxattr+0x74/0xc8
[ 3055.418208]        listxattr+0x7c/0x178
[ 3055.418213]        sys_flistxattr+0x7c/0xf4
[ 3055.418218]        system_call_exception+0x134/0x390
[ 3055.418224]        system_call_vectored_common+0x15c/0x2ec
[ 3055.418229] 
               -> #0 (&xfs_nondir_ilock_class#3){++++}-{3:3}:
[ 3055.418237]        check_prev_add+0x170/0x113c
[ 3055.418243]        validate_chain+0x77c/0x8f0
[ 3055.418248]        __lock_acquire+0x5c8/0xf60
[ 3055.418253]        lock_acquire.part.0+0xd0/0x280
[ 3055.418259]        down_read_nested+0x78/0x2c0
[ 3055.418264]        xfs_ilock+0x164/0x3b8 [xfs]
[ 3055.418348]        xfs_can_free_eofblocks+0x13c/0x288 [xfs]
[ 3055.418435]        xfs_inode_needs_inactive+0xcc/0x11c [xfs]
[ 3055.418519]        xfs_inode_mark_reclaimable+0xb0/0x13c [xfs]
[ 3055.418604]        xfs_fs_destroy_inode+0x11c/0x264 [xfs]
[ 3055.418687]        destroy_inode+0x68/0xb4
[ 3055.418692]        dispose_list+0x88/0xe4
[ 3055.418696]        prune_icache_sb+0x70/0xa4
[ 3055.418702]        super_cache_scan+0x1cc/0x248
[ 3055.418707]        do_shrink_slab+0x1d0/0x948
[ 3055.418711]        shrink_slab_memcg+0x1e4/0x854
[ 3055.418715]        shrink_one+0x188/0x310
[ 3055.418720]        shrink_many+0x508/0xb88
[ 3055.418725]        lru_gen_shrink_node+0x1b8/0x21c
[ 3055.418731]        balance_pgdat+0x310/0x8d8
[ 3055.418736]        kswapd+0x1a8/0x3ac
[ 3055.418741]        kthread+0x15c/0x164
[ 3055.418746]        start_kernel_thread+0x14/0x18
[ 3055.418750] 
               other info that might help us debug this:

[ 3055.418754]  Possible unsafe locking scenario:

[ 3055.418757]        CPU0                    CPU1
[ 3055.418760]        ----                    ----
[ 3055.418763]   lock(fs_reclaim);
[ 3055.418767]                                lock(&xfs_nondir_ilock_class#3);
[ 3055.418773]                                lock(fs_reclaim);
[ 3055.418777]   rlock(&xfs_nondir_ilock_class#3);
[ 3055.418782] 
                *** DEADLOCK ***

[ 3055.418786] 2 locks held by kswapd1/83:
[ 3055.418789]  #0: c000000002dbe5b0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0x10/0x8d8
[ 3055.418800]  #1: c0000000511ae0e8 (&type->s_umount_key#54){++++}-{3:3}, at: super_cache_scan+0x48/0x248
[ 3055.418812] 
               stack backtrace:
[ 3055.418815] CPU: 5 PID: 83 Comm: kswapd1 Kdump: loaded Not tainted 6.9.0-rc1+ #1
[ 3055.418821] Hardware name: IBM,8375-42A POWER9 (raw) 0x4e0202 0xf000005 of:IBM,FW940.02 (VL940_041) hv:phyp pSeries
[ 3055.418826] Call Trace:
[ 3055.418828] [c00000000e32f070] [c00000000123cc98] dump_stack_lvl+0x100/0x184 (unreliable)
[ 3055.418837] [c00000000e32f0a0] [c00000000022fed8] print_circular_bug+0x248/0x2d8
[ 3055.418845] [c00000000e32f140] [c000000000230134] check_noncircular+0x1cc/0x1ec
[ 3055.418851] [c00000000e32f210] [c000000000231e3c] check_prev_add+0x170/0x113c
[ 3055.418858] [c00000000e32f2d0] [c000000000233584] validate_chain+0x77c/0x8f0
[ 3055.418865] [c00000000e32f3d0] [c0000000002359b4] __lock_acquire+0x5c8/0xf60
[ 3055.418872] [c00000000e32f4d0] [c0000000002372bc] lock_acquire.part.0+0xd0/0x280
[ 3055.418879] [c00000000e32f5d0] [c000000000226d14] down_read_nested+0x78/0x2c0
[ 3055.418885] [c00000000e32f650] [c008000005042e2c] xfs_ilock+0x164/0x3b8 [xfs]
[ 3055.418972] [c00000000e32f6f0] [c0080000050119cc] xfs_can_free_eofblocks+0x13c/0x288 [xfs]
[ 3055.419060] [c00000000e32f760] [c008000005046220] xfs_inode_needs_inactive+0xcc/0x11c [xfs]
[ 3055.419146] [c00000000e32f780] [c008000005034910] xfs_inode_mark_reclaimable+0xb0/0x13c [xfs]
[ 3055.419232] [c00000000e32f7c0] [c0080000050597d8] xfs_fs_destroy_inode+0x11c/0x264 [xfs]
[ 3055.419316] [c00000000e32f850] [c0000000006f914c] destroy_inode+0x68/0xb4
[ 3055.419323] [c00000000e32f880] [c0000000006fa610] dispose_list+0x88/0xe4
[ 3055.419329] [c00000000e32f8c0] [c0000000006fc334] prune_icache_sb+0x70/0xa4
[ 3055.419335] [c00000000e32f910] [c0000000006c7024] super_cache_scan+0x1cc/0x248
[ 3055.419342] [c00000000e32f980] [c000000000548558] do_shrink_slab+0x1d0/0x948
[ 3055.419347] [c00000000e32fa60] [c000000000548eb4] shrink_slab_memcg+0x1e4/0x854
[ 3055.419353] [c00000000e32fb90] [c00000000053e960] shrink_one+0x188/0x310
[ 3055.419360] [c00000000e32fbf0] [c0000000005438ac] shrink_many+0x508/0xb88
[ 3055.419366] [c00000000e32fcd0] [c0000000005440e4] lru_gen_shrink_node+0x1b8/0x21c
[ 3055.419373] [c00000000e32fd50] [c000000000544930] balance_pgdat+0x310/0x8d8
[ 3055.419380] [c00000000e32fea0] [c0000000005450a0] kswapd+0x1a8/0x3ac
[ 3055.419387] [c00000000e32ff90] [c0000000001a62c0] kthread+0x15c/0x164
[ 3055.419393] [c00000000e32ffe0] [c00000000000dd68] start_kernel_thread+0x14/0x18
[ 3099.348358] XFS (sda3): User initiated shutdown received.
[ 3099.348381] XFS (sda3): Log I/O Error (0x6) detected at xfs_fs_goingdown+0x100/0x160 [xfs] (fs/xfs/xfs_fsops.c:458).  Shutting down filesystem.
[ 3099.348479] XFS (sda3): Please unmount the filesystem and rectify the problem(s)
[ 3099.462800] XFS (sda3): Unmounting Filesystem 21e84352-bca0-44b5-9a8a-aa6469c8e2f9
[ 3099.490382] XFS (sda3): Mounting V5 Filesystem 21e84352-bca0-44b5-9a8a-aa6469c8e2f9
[ 3099.765778] XFS (sda3): Starting recovery (logdev: internal)
[ 3100.035961] XFS (sda3): Ending recovery (logdev: internal)
[ 3100.118818] XFS (sda3): Unmounting Filesystem 21e84352-bca0-44b5-9a8a-aa6469c8e2f9

> 
> <shrug> /me runs away for the weekend
> 
> run fstests xfs/559 at 2024-03-28 19:41:51
> spectre-v4 mitigation disabled by command-line option
> XFS (sda2): Mounting V5 Filesystem e9713a0b-c124-47b0-a1dd-b45dded16592
> XFS (sda2): Ending clean mount
> XFS (sda3): Mounting V5 Filesystem 3eb29dfb-da2b-4f90-82f2-1f1b12fac345
> XFS (sda3): Ending clean mount
> XFS (sda3): Quotacheck needed: Please wait.
> XFS (sda3): Quotacheck: Done.
> XFS (sda3): Unmounting Filesystem 3eb29dfb-da2b-4f90-82f2-1f1b12fac345
> XFS (sda3): Mounting V5 Filesystem 3eb29dfb-da2b-4f90-82f2-1f1b12fac345
> XFS (sda3): Ending clean mount
> XFS (sda3): Injecting 500ms delay at file fs/xfs/xfs_iomap.c, line 84, on filesystem "sda3"
> XFS (sda3): Injecting 500ms delay at file fs/xfs/xfs_iomap.c, line 84, on filesystem "sda3"
> XFS (sda3): Injecting 500ms delay at file fs/xfs/xfs_iomap.c, line 84, on filesystem "sda3"
> XFS (sda3): Injecting 500ms delay at file fs/xfs/xfs_iomap.c, line 84, on filesystem "sda3"
> page: refcount:3 mapcount:0 mapping:fffffc018fc5b718 index:0x3001 pfn:0x8001
> memcg:fffffc00f23c1000
> aops:xfs_address_space_operations [xfs] ino:107
> flags: 0xfff600000008029(locked|uptodate|lru|private|node=0|zone=0|lastcpupid=0xfff)
> page_type: 0xffffffff()
> raw: 0fff600000008029 ffffffff40100088 ffffffff40100008 fffffc018fc5b718
> raw: 0000000000003001 fffffc0108404d40 00000003ffffffff fffffc00f23c1000
> page dumped because: VM_BUG_ON_FOLIO(!folio_contains(folio, xas.xa_index))
> ------------[ cut here ]------------
> kernel BUG at mm/filemap.c:2078!
> Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in: dm_delay dm_flakey xfs nft_chain_nat xt_REDIRECT nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rpcs
> use efivarfs ip_tables x_tables overlay nfsv4 [last unloaded: scsi_debug]
> CPU: 0 PID: 3949199 Comm: umount Tainted: G        W          6.9.0-rc1-djwa #rc1 016eb5755235bfdc60adce068d3fc4d2a3c06376
> Hardware name: QEMU KVM Virtual Machine, BIOS 1.6.6 08/22/2023
> pstate: 60401005 (nZCv daif +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
> pc : find_lock_entries+0x478/0x518
> lr : find_lock_entries+0x478/0x518
> sp : fffffe00893cf9f0
> x29: fffffe00893cf9f0 x28: 0000000000000006 x27: fffffc018f6d7fc0
> x26: fffffc018fc5b718 x25: fffffe00893cfb10 x24: 0000000000000003
> x23: fffffe00893cfb08 x22: fffffe00893cfb88 x21: fffffffffffffffe
> x20: ffffffff40100040 x19: ffffffffffffffff x18: 0000000000000000
> x17: 2e736178202c6f69 x16: 6c6f6628736e6961 x15: 746e6f635f6f696c
> x14: 6f6621284f494c4f x13: 29297865646e695f x12: 61782e736178202c
> x11: 6f696c6f6628736e x10: 6961746e6f635f6f x9 : fffffe00800e26c4
> x8 : fffffe00893cf6f0 x7 : 0000000000000000 x6 : fffffe00814639a8
> x5 : 00000000000017d0 x4 : 0000000000000002 x3 : 0000000000000000
> x2 : 0000000000000000 x1 : fffffc00e65421c0 x0 : 000000000000004a
> Call trace:
>  find_lock_entries+0x478/0x518
>  truncate_inode_pages_range+0xc8/0x650
>  truncate_inode_pages_final+0x58/0x90
>  evict+0x188/0x1a8
>  dispose_list+0x6c/0xa8
>  evict_inodes+0x138/0x1b0
>  generic_shutdown_super+0x4c/0x100
>  kill_block_super+0x24/0x50
>  xfs_kill_sb+0x20/0x40 [xfs 6fb2b419729f76f7aa4b144d75af2e13a7e35081]
>  deactivate_locked_super+0x58/0x140
>  deactivate_super+0x8c/0xb0
>  cleanup_mnt+0xa4/0x140
>  __cleanup_mnt+0x1c/0x30
>  task_work_run+0x88/0xf8
>  do_notify_resume+0x114/0x138
>  el0_svc+0x180/0x218
>  el0t_64_sync_handler+0x100/0x130
>  el0t_64_sync+0x190/0x198
> Code: aa1403e0 f00053a1 910c8021 94015f6f (d4210000) 
> ---[ end trace 0000000000000000 ]---
> 
> Or on my dev tree:
> 
> run fstests xfs/559 at 2024-03-28 20:52:41
> spectre-v4 mitigation disabled by command-line option
> XFS (sda2): EXPERIMENTAL metadata directory feature in use. Use at your own risk!
> XFS (sda2): EXPERIMENTAL realtime allocation group feature in use. Use at your own risk!
> XFS (sda2): EXPERIMENTAL parent pointer feature enabled. Use at your own risk!
> XFS (sda2): EXPERIMENTAL fsverity feature in use. Use at your own risk!
> XFS (sda2): Mounting V5 Filesystem c9424439-7289-4703-bf73-d66814432ac7
> XFS (sda2): Ending clean mount
> XFS (sda3): EXPERIMENTAL metadata directory feature in use. Use at your own risk!
> XFS (sda3): EXPERIMENTAL realtime allocation group feature in use. Use at your own risk!
> XFS (sda3): EXPERIMENTAL parent pointer feature enabled. Use at your own risk!
> XFS (sda3): EXPERIMENTAL fsverity feature in use. Use at your own risk!
> XFS (sda3): Mounting V5 Filesystem 5882e817-a05b-417c-9e8f-3a4f7b019fb0
> XFS (sda3): Ending clean mount
> XFS (sda3): Quotacheck needed: Please wait.
> XFS (sda3): Quotacheck: Done.
> XFS (sda3): Unmounting Filesystem 5882e817-a05b-417c-9e8f-3a4f7b019fb0
> XFS (sda3): EXPERIMENTAL metadata directory feature in use. Use at your own risk!
> XFS (sda3): EXPERIMENTAL realtime allocation group feature in use. Use at your own risk!
> XFS (sda3): EXPERIMENTAL parent pointer feature enabled. Use at your own risk!
> XFS (sda3): EXPERIMENTAL fsverity feature in use. Use at your own risk!
> XFS (sda3): Mounting V5 Filesystem 5882e817-a05b-417c-9e8f-3a4f7b019fb0
> XFS (sda3): Ending clean mount
> XFS (sda3): Injecting 500ms delay at file fs/xfs/xfs_iomap.c, line 84, on filesystem "sda3"
> XFS (sda3): Injecting 500ms delay at file fs/xfs/xfs_iomap.c, line 84, on filesystem "sda3"
> XFS (sda3): Injecting 500ms delay at file fs/xfs/xfs_iomap.c, line 84, on filesystem "sda3"
> ------------[ cut here ]------------
> kernel BUG at fs/inode.c:614!
> Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in: ext2 xfs thread_with_file time_stats dm_thin_pool dm_persistent_data dm_
>  nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_
> CPU: 1 PID: 2180105 Comm: umount Tainted: G        W          6.9.0-rc1-xfsa #rc1 4137f913a
> Hardware name: QEMU KVM Virtual Machine, BIOS 1.6.6 08/22/2023
> pstate: a04010c5 (NzCv daIF +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
> pc : clear_inode+0x80/0xa0
> lr : clear_inode+0x28/0xa0
> sp : fffffe0085c6fc10
> x29: fffffe0085c6fc10 x28: fffffc00eb8a0000 x27: fffffc00ce7aa2b0
> x26: fffffe0085c6fcf8 x25: fffffc01861dee40 x24: fffffc01861de800
> x23: fffffc00eb8a0000 x22: fffffe007b3c9358 x21: fffffc00ce7aa378
> x20: fffffc00ce7aa328 x19: fffffc00ce7aa178 x18: 0000000000000014
> x17: 0a01000000000000 x16: fffffc00e49edae8 x15: 0000000000000040
> x14: 0000000000000000 x13: 0000000000000020 x12: 0101010101010101
> x11: 7f7f7f7f7f7f7f7f x10: 0000000000000000 x9 : fffffe00809c9320
> x8 : fffffe0085c6fa60 x7 : 0000000000000000 x6 : fffffe0085c6fa60
> x5 : 0000000000000000 x4 : fffffe0085c6fb58 x3 : 0000000000000000
> x2 : fffffe017e700000 x1 : fffffe017e700000 x0 : 0000000000003f00
> Call trace:
>  clear_inode+0x80/0xa0
>  evict+0x190/0x1a8
>  dispose_list+0x6c/0xa8
>  evict_inodes+0x138/0x1b0
>  generic_shutdown_super+0x4c/0x110
>  kill_block_super+0x24/0x50
>  xfs_kill_sb+0x20/0x40 [xfs b096c248217f70a3dcd07b920f66f8452d01eb1f]
>  deactivate_locked_super+0x58/0x140
>  deactivate_super+0x8c/0xb0
>  cleanup_mnt+0xa4/0x140
>  __cleanup_mnt+0x1c/0x30
>  task_work_run+0x88/0xf8
>  do_notify_resume+0x114/0x138
>  el0_svc+0x180/0x1f0
>  el0t_64_sync_handler+0x100/0x130
>  el0t_64_sync+0x190/0x198
> Code: a94153f3 a8c27bfd d50323bf d65f03c0 (d4210000) 
> ---[ end trace 0000000000000000 ]---
> note: umount[2180105] exited with irqs disabled
> note: umount[2180105] exited with preempt_count 2
> ------------[ cut here ]------------
> 
> --D
> 


