Return-Path: <linux-xfs+bounces-9277-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6A2990760F
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2024 17:07:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BED428607B
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2024 15:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE7C2148302;
	Thu, 13 Jun 2024 15:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lwVWroXp"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDDC13D524
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 15:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718291262; cv=none; b=r2DMzhBSCy1iOnke+DiH0AYZ2Ow53vuKjWsdHZFTk1/lNtbAwg9plEJH6Zf4hLfceBVLlQAeFyhozi5gsPk1OuRe/XPEZe9e8jRXafyDT8j0oEpokMQe1j4u9+ON13lmkDsfbumGu1E7zV/n5O1WPKA8j9J/epXPO3KIty/h+/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718291262; c=relaxed/simple;
	bh=sQFzINZ7ONjwc5OauLLm37pkI+eugm1m8be6FY8WyCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOu9Y9k/yswNc7lErzG0aXJ94USePSBw818A+92VXToTVWuMbupoga5QFN1/VfS2MwUgTrqSmjIunTGuwoBssYvbrq6Ctc+bkj0axcJNogyY7Hl/cENlB2SCE+iH+QQzfoCKF9IOU4UGFKuHVL7TwUJkKqI79+k8yC0VR9KVuC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lwVWroXp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE0DC2BBFC;
	Thu, 13 Jun 2024 15:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718291262;
	bh=sQFzINZ7ONjwc5OauLLm37pkI+eugm1m8be6FY8WyCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lwVWroXp6s9ODwKDMOUESFSdGsEO1Cte3egkFTzGPSB7ZoUzsbmulNxLVXDTcpVlg
	 5W6N3c5PoBlKslkmNezRyF4Fn+pjbNnbjLOipuzun/0dEPj2LD0XYXEWMhlkzKgQLw
	 IWCSSHzOHEthxQ2D2p27CaluQeBBpx/vZ8hiWWyYFCwe3ejBmBMG37WRtcZsMkF6x4
	 YcW6jV3iCiYfs5o731aJPkP2540Ax97M4a4BtzvbH2eIHQ+YCuO7kKSHzgaWOjeL3C
	 D74Qz88+SFIUcQTcsHX0QfYs94nCAPrDkdfvG9pRSvJTWBBp6+TpMprAs2KvLbk+Hc
	 Z/nBUpq6/CBgA==
Date: Thu, 13 Jun 2024 08:07:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix unlink vs cluster buffer instantiation race
Message-ID: <20240613150741.GN2764752@frogsfrogsfrogs>
References: <20240612225148.3989713-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612225148.3989713-1-david@fromorbit.com>

On Thu, Jun 13, 2024 at 08:51:48AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Luis has been reporting an assert failure when freeing an inode
> cluster during inode inactivation for a while. The assert looks
> like:
> 
>  XFS: Assertion failed: bp->b_flags & XBF_DONE, file: fs/xfs/xfs_trans_buf.c, line: 241
>  ------------[ cut here ]------------
>  kernel BUG at fs/xfs/xfs_message.c:102!
>  Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
>  CPU: 4 PID: 73 Comm: kworker/4:1 Not tainted 6.10.0-rc1 #4
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>  Workqueue: xfs-inodegc/loop5 xfs_inodegc_worker [xfs]
>  RIP: 0010:assfail (fs/xfs/xfs_message.c:102) xfs
>  RSP: 0018:ffff88810188f7f0 EFLAGS: 00010202
>  RAX: 0000000000000000 RBX: ffff88816e748250 RCX: 1ffffffff844b0e7
>  RDX: 0000000000000004 RSI: ffff88810188f558 RDI: ffffffffc2431fa0
>  RBP: 1ffff11020311f01 R08: 0000000042431f9f R09: ffffed1020311e9b
>  R10: ffff88810188f4df R11: ffffffffac725d70 R12: ffff88817a3f4000
>  R13: ffff88812182f000 R14: ffff88810188f998 R15: ffffffffc2423f80
>  FS:  0000000000000000(0000) GS:ffff8881c8400000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 000055fe9d0f109c CR3: 000000014426c002 CR4: 0000000000770ef0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
>  PKRU: 55555554
>  Call Trace:
>   <TASK>
>  xfs_trans_read_buf_map (fs/xfs/xfs_trans_buf.c:241 (discriminator 1)) xfs
>  xfs_imap_to_bp (fs/xfs/xfs_trans.h:210 fs/xfs/libxfs/xfs_inode_buf.c:138) xfs
>  xfs_inode_item_precommit (fs/xfs/xfs_inode_item.c:145) xfs
>  xfs_trans_run_precommits (fs/xfs/xfs_trans.c:931) xfs
>  __xfs_trans_commit (fs/xfs/xfs_trans.c:966) xfs
>  xfs_inactive_ifree (fs/xfs/xfs_inode.c:1811) xfs
>  xfs_inactive (fs/xfs/xfs_inode.c:2013) xfs
>  xfs_inodegc_worker (fs/xfs/xfs_icache.c:1841 fs/xfs/xfs_icache.c:1886) xfs
>  process_one_work (kernel/workqueue.c:3231)
>  worker_thread (kernel/workqueue.c:3306 (discriminator 2) kernel/workqueue.c:3393 (discriminator 2))
>  kthread (kernel/kthread.c:389)
>  ret_from_fork (arch/x86/kernel/process.c:147)
>  ret_from_fork_asm (arch/x86/entry/entry_64.S:257)
>   </TASK>
> 
> And occurs when the the inode precommit handlers is attempt to look
> up the inode cluster buffer to attach the inode for writeback.
> 
> The trail of logic that I can reconstruct is as follows.
> 
> 	1. the inode is clean when inodegc runs, so it is not
> 	   attached to a cluster buffer when precommit runs.
> 
> 	2. #1 implies the inode cluster buffer may be clean and not
> 	   pinned by dirty inodes when inodegc runs.
> 
> 	3. #2 implies that the inode cluster buffer can be reclaimed
> 	   by memory pressure at any time.
> 
> 	4. The assert failure implies that the cluster buffer was
> 	   attached to the transaction, but not marked done. It had
> 	   been accessed earlier in the transaction, but not marked
> 	   done.
> 
> 	5. #4 implies the cluster buffer has been invalidated (i.e.
> 	   marked stale).
> 
> 	6. #5 implies that the inode cluster buffer was instantiated
> 	   uninitialised in the transaction in xfs_ifree_cluster(),
> 	   which only instantiates the buffers to invalidate them
> 	   and never marks them as done.
> 
> Given factors 1-3, this issue is highly dependent on timing and
> environmental factors. Hence the issue can be very difficult to
> reproduce in some situations, but highly reliable in others. Luis
> has an environment where it can be reproduced easily by g/531 but,
> OTOH, I've reproduced it only once in ~2000 cycles of g/531.
> 
> I think the fix is to have xfs_ifree_cluster() set the XBF_DONE flag
> on the cluster buffers, even though they may not be initialised. The
> reasons why I think this is safe are:
> 
> 	1. A buffer cache lookup hit on a XBF_STALE buffer will
> 	   clear the XBF_DONE flag. Hence all future users of the
> 	   buffer know they have to re-initialise the contents
> 	   before use and mark it done themselves.
> 
> 	2. xfs_trans_binval() sets the XFS_BLI_STALE flag, which
> 	   means the buffer remains locked until the journal commit
> 	   completes and the buffer is unpinned. Hence once marked
> 	   XBF_STALE/XFS_BLI_STALE by xfs_ifree_cluster(), the only
> 	   context that can access the freed buffer is the currently
> 	   running transaction.
> 
> 	3. #2 implies that future buffer lookups in the currently
> 	   running transaction will hit the transaction match code
> 	   and not the buffer cache. Hence XBF_STALE and
> 	   XFS_BLI_STALE will not be cleared unless the transaction
> 	   initialises and logs the buffer with valid contents
> 	   again. At which point, the buffer will be marked marked
> 	   XBF_DONE again, so having XBF_DONE already set on the
> 	   stale buffer is a moot point.
> 
> 	4. #2 also implies that any concurrent access to that
> 	   cluster buffer will block waiting on the buffer lock
> 	   until the inode cluster has been fully freed and is no
> 	   longer an active inode cluster buffer.
> 
> 	5. #4 + #1 means that any future user of the disk range of
> 	   that buffer will always see the range of disk blocks
> 	   covered by the cluster buffer as not done, and hence must
> 	   initialise the contents themselves.
> 
> 	6. Setting XBF_DONE in xfs_ifree_cluster() then means the
> 	   unlinked inode precommit code will see a XBF_DONE buffer
> 	   from the transaction match as it expects. It can then
> 	   attach the stale but newly dirtied inode to the stale
> 	   but newly dirtied cluster buffer without unexpected
> 	   failures. The stale buffer will then sail through the
> 	   journal and do the right thing with the attached stale
> 	   inode during unpin.
> 
> Hence the fix is just one line of extra code. The explanation of
> why we have to set XBF_DONE in xfs_ifree_cluster, OTOH, is long and
> complex....
> 
> Fixes: 82842fee6e59 ("xfs: fix AGF vs inode cluster buffer deadlock")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Tested-by: Luis Chamberlain <mcgrof@kernel.org>

I'm pretty sure this also fixes the same symptoms that I can (very very
occasionally) reproduce.  Though, I haven't seen it in a while.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_inode.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 58fb7a5062e1..f36091e1e7f5 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2548,11 +2548,26 @@ xfs_ifree_cluster(
>  		 * This buffer may not have been correctly initialised as we
>  		 * didn't read it from disk. That's not important because we are
>  		 * only using to mark the buffer as stale in the log, and to
> -		 * attach stale cached inodes on it. That means it will never be
> -		 * dispatched for IO. If it is, we want to know about it, and we
> -		 * want it to fail. We can acheive this by adding a write
> -		 * verifier to the buffer.
> +		 * attach stale cached inodes on it.
> +		 *
> +		 * For the inode that triggered the cluster freeing, this
> +		 * attachment may occur in xfs_inode_item_precommit() after we
> +		 * have marked this buffer stale.  If this buffer was not in
> +		 * memory before xfs_ifree_cluster() started, it will not be
> +		 * marked XBF_DONE and this will cause problems later in
> +		 * xfs_inode_item_precommit() when we trip over a (stale, !done)
> +		 * buffer to attached to the transaction.
> +		 *
> +		 * Hence we have to mark the buffer as XFS_DONE here. This is
> +		 * safe because we are also marking the buffer as XBF_STALE and
> +		 * XFS_BLI_STALE. That means it will never be dispatched for
> +		 * IO and it won't be unlocked until the cluster freeing has
> +		 * been committed to the journal and the buffer unpinned. If it
> +		 * is written, we want to know about it, and we want it to
> +		 * fail. We can acheive this by adding a write verifier to the
> +		 * buffer.
>  		 */
> +		bp->b_flags |= XBF_DONE;
>  		bp->b_ops = &xfs_inode_buf_ops;
>  
>  		/*
> -- 
> 2.45.1
> 
> 

