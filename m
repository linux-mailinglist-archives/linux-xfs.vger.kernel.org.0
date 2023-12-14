Return-Path: <linux-xfs+bounces-820-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 759EA813CE1
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Dec 2023 22:47:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A75DB1C21D03
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Dec 2023 21:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C00A966AAB;
	Thu, 14 Dec 2023 21:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TrxMfLch"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99832C68F
	for <linux-xfs@vger.kernel.org>; Thu, 14 Dec 2023 21:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00475C433C7;
	Thu, 14 Dec 2023 21:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702590439;
	bh=OFZq9V5evQrLoAyJmnP2ICoXthLfQ/O3qWQla0An58E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TrxMfLchui/C25bIAE15tOA0zBwDUJbIXpiH4GMLbkd0HMpYaqtdJnN5bnwhRxL6y
	 mdw1vKX1fLBmZ28OF8izMrwqpnjp2dGR4q5zYZivAXgNL8kh8W7+fHjFXpnraSbe3D
	 4885nwJlBfBFcGXBZv1KaQZZf05tWGj/afW0LE+gTPhVxFSauJc91r0ljLCT6teIRc
	 ucnmRA/P3a+Ry5+8+xTolGD0empw8NG5iN1wxQokWdACh2TaDAA/Rty82jAT23Jbnu
	 ZnuEbcLTZUE7cAk9krX1UVaI3FjbfFPK78ID/IRBAeNFhSnLGN3u9IBOs8oHzv2zI8
	 jl7fccz6NbJfg==
Date: Thu, 14 Dec 2023 13:47:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: initialise di_crc in xfs_log_dinode
Message-ID: <20231214214718.GL361584@frogsfrogsfrogs>
References: <20231214214035.3795665-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231214214035.3795665-1-david@fromorbit.com>

On Fri, Dec 15, 2023 at 08:40:35AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Alexander Potapenko report that KMSAN was issuing these warnings:
> 
> kmalloc-ed xlog buffer of size 512 : ffff88802fc26200
> kmalloc-ed xlog buffer of size 368 : ffff88802fc24a00
> kmalloc-ed xlog buffer of size 648 : ffff88802b631000
> kmalloc-ed xlog buffer of size 648 : ffff88802b632800
> kmalloc-ed xlog buffer of size 648 : ffff88802b631c00
> xlog_write_iovec: copying 12 bytes from ffff888017ddbbd8 to ffff88802c300400
> xlog_write_iovec: copying 28 bytes from ffff888017ddbbe4 to ffff88802c30040c
> xlog_write_iovec: copying 68 bytes from ffff88802fc26274 to ffff88802c300428
> xlog_write_iovec: copying 188 bytes from ffff88802fc262bc to ffff88802c30046c
> =====================================================
> BUG: KMSAN: uninit-value in xlog_write_iovec fs/xfs/xfs_log.c:2227
> BUG: KMSAN: uninit-value in xlog_write_full fs/xfs/xfs_log.c:2263
> BUG: KMSAN: uninit-value in xlog_write+0x1fac/0x2600 fs/xfs/xfs_log.c:2532
>  xlog_write_iovec fs/xfs/xfs_log.c:2227
>  xlog_write_full fs/xfs/xfs_log.c:2263
>  xlog_write+0x1fac/0x2600 fs/xfs/xfs_log.c:2532
>  xlog_cil_write_chain fs/xfs/xfs_log_cil.c:918
>  xlog_cil_push_work+0x30f2/0x44e0 fs/xfs/xfs_log_cil.c:1263
>  process_one_work kernel/workqueue.c:2630
>  process_scheduled_works+0x1188/0x1e30 kernel/workqueue.c:2703
>  worker_thread+0xee5/0x14f0 kernel/workqueue.c:2784
>  kthread+0x391/0x500 kernel/kthread.c:388
>  ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:242
> 
> Uninit was created at:
>  slab_post_alloc_hook+0x101/0xac0 mm/slab.h:768
>  slab_alloc_node mm/slub.c:3482
>  __kmem_cache_alloc_node+0x612/0xae0 mm/slub.c:3521
>  __do_kmalloc_node mm/slab_common.c:1006
>  __kmalloc+0x11a/0x410 mm/slab_common.c:1020
>  kmalloc ./include/linux/slab.h:604
>  xlog_kvmalloc fs/xfs/xfs_log_priv.h:704
>  xlog_cil_alloc_shadow_bufs fs/xfs/xfs_log_cil.c:343
>  xlog_cil_commit+0x487/0x4dc0 fs/xfs/xfs_log_cil.c:1574
>  __xfs_trans_commit+0x8df/0x1930 fs/xfs/xfs_trans.c:1017
>  xfs_trans_commit+0x30/0x40 fs/xfs/xfs_trans.c:1061
>  xfs_create+0x15af/0x2150 fs/xfs/xfs_inode.c:1076
>  xfs_generic_create+0x4cd/0x1550 fs/xfs/xfs_iops.c:199
>  xfs_vn_create+0x4a/0x60 fs/xfs/xfs_iops.c:275
>  lookup_open fs/namei.c:3477
>  open_last_lookups fs/namei.c:3546
>  path_openat+0x29ac/0x6180 fs/namei.c:3776
>  do_filp_open+0x24d/0x680 fs/namei.c:3809
>  do_sys_openat2+0x1bc/0x330 fs/open.c:1440
>  do_sys_open fs/open.c:1455
>  __do_sys_openat fs/open.c:1471
>  __se_sys_openat fs/open.c:1466
>  __x64_sys_openat+0x253/0x330 fs/open.c:1466
>  do_syscall_x64 arch/x86/entry/common.c:51
>  do_syscall_64+0x4f/0x140 arch/x86/entry/common.c:82
>  entry_SYSCALL_64_after_hwframe+0x63/0x6b arch/x86/entry/entry_64.S:120
> 
> Bytes 112-115 of 188 are uninitialized
> Memory access of size 188 starts at ffff88802fc262bc
> 
> This is caused by the struct xfs_log_dinode not having the di_crc
> field initialised. Log recovery never uses this field (it is only
> present these days for on-disk format compatibility reasons) and so
> it's value is never checked so nothing in XFS has caught this.
> 
> Further, none of the uninitialised memory access warning tools have
> caught this (despite catching other uninit memory accesses in the
> struct xfs_log_dinode back in 2017!) until recently. Alexander
> annotated the XFS code to get the dump of the actual bytes that were
> detected as uninitialised, and from that report it took me about 30s
> to realise what the issue was.
> 
> The issue was introduced back in 2016 and every inode that is logged
> fails to initialise this field. This is no actual bad behaviour
> caused by this issue - I find it hard to even classify it as a
> bug...
> 
> Reported-and-tested-by: Alexander Potapenko <glider@google.com>
> Fixes: f8d55aa0523a ("xfs: introduce inode log format object")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode_item.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 157ae90d3d52..0287918c03dc 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -557,6 +557,9 @@ xfs_inode_to_log_dinode(
>  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
>  		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
>  		to->di_v3_pad = 0;
> +
> +		/* dummy value for initialisation */
> +		to->di_crc = 0;

I wonder if the log should be using kzalloc instead of kmalloc for
buffers that will end up on disk?  Kind of a nasty performance hit
just for the sake of paranoia, though.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	} else {
>  		to->di_version = 2;
>  		to->di_flushiter = ip->i_flushiter;
> -- 
> 2.42.0
> 
> 

