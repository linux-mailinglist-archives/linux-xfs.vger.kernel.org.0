Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F4F31F067
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Feb 2021 20:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhBRTsh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 18 Feb 2021 14:48:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:58230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231341AbhBRTch (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Feb 2021 14:32:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFF7E64DE0;
        Thu, 18 Feb 2021 19:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613676715;
        bh=z0kXaOaOHOzKgPdnlU/4DxsQYD/sdmoVVFlpoNZm0Jc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VXkKngJFcYiEOW0rqRAj8W8VSgqKLNgZHQj5QxWvD8p3OGIjJxFH/tK4HaT0/fYBJ
         7gIY2taPcQBwtn6Hp7Xc62/Z8jA6HIiP3P5mlzHrgbERBQn0iSLkem5DdaAaX66np4
         rXDeacMCccy0vhLHyN7YFe0H5Dqw96VqVQd3EvN6vTt7nI5JkRQh0ZLerltschWxGu
         iLDs/Myscl/I9uRIavIxEQR7Faz/8+QlGnUvyqLP+ovtkeaGL4/nYShxuCIdRyHYco
         zHSo3+zVeGk2zdCrSiBSy6g1anl+HUmPN/N7xyw+Tc0LTeb+QbpU1ZYAb8SYSGYU3W
         eKD/ZM0vYrocQ==
Date:   Thu, 18 Feb 2021 11:31:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: lockdep recursive locking warning on for-next
Message-ID: <20210218193154.GO7190@magnolia>
References: <20210218181450.GA705507@bfoster>
 <20210218184926.GN7190@magnolia>
 <20210218191252.GA709084@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218191252.GA709084@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 02:12:52PM -0500, Brian Foster wrote:
> On Thu, Feb 18, 2021 at 10:49:26AM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 18, 2021 at 01:14:50PM -0500, Brian Foster wrote:
> > > Hi Darrick,
> > > 
> > > I'm seeing the warning below via xfs/167 on a test machine. It looks
> > > like it's just complaining about nested freeze protection between the
> > > scan invocation and an underlying transaction allocation for an inode
> > > eofblocks trim. I suppose we could either refactor xfs_trans_alloc() to
> > > drop and reacquire freeze protection around the scan, or alternatively
> > > call __sb_writers_release() and __sb_writers_acquire() around the scan
> > > to retain freeze protection and quiet lockdep. Hm?
> > 
> > Erk, isn't that a potential log grant livelock too?
> > 
> > Fill up the filesystem with real data and cow blocks until it's full,
> > then spawn exactly enough file writer threads to eat up all the log
> > reservation, then each _reserve() fails, so every thread starts a scan
> > and tries to allocate /another/ transaction ... but there's no space
> > left in the log, so those scans just block indefinitely.
> > 
> > So... I think the solution here is to go back to a previous version of
> > what that patchset did, where we'd drop the whole transaction, run the
> > scan, and jump back to the top of the function to get a fresh
> > transaction.
> > 
> 
> But we don't call into the scan while holding log reservation. We hold
> the transaction memory and freeze protection. It's probably debatable
> whether we'd want to scan with freeze protection held or not, but I
> don't see how dropping either of those changes anything wrt to log
> reservation..?

Right, sorry about the noise.  We could just trick lockdep with
__sb_writers_release like you said.  Though I am a tad bit concerned
about the rwsem behavior -- what happens if:

T1 calls sb_start_intwrite (which is down_read on sb_writers), gets the
lock, and then hits ENOSPC and goes into our scan loop; meanwhile,

T2 calls sb_wait_write (which is down_write on sb_writers), and is
scheduled off because it was a blocking lock attempt; and then,

T1 finds some eofblocks to delete, and now it wants to sb_start_intwrite
again as part of allocating that second nested transaction.  Does that
actually work, or will T1 stall because we don't allow more readers once
something is waiting in down_write()?

> > > BTW, the stack report also had me wondering whether we had or need any
> > > nesting protection in these new scan invocations. For example, if we
> > > have an fs with a bunch of tagged inodes and concurrent allocation
> > > activity, would anything prevent an in-scan transaction allocation from
> > > jumping back into the scan code to complete outstanding work? It looks
> > > like that might not be possible right now because neither scan reserves
> > > blocks, but they do both use transactions and that's quite a subtle
> > > balance..
> > 
> > Yes, that's a subtlety that screams for better documentation.
> > 
> 
> TBH, I'm not sure that's enough. I think we should at least have some
> kind of warning, even if only in DEBUG mode, that explicitly calls out
> if we've become susceptible to this kind of scan reentry. Otherwise I
> suspect that if this problem is ever truly introduced, the person who
> first discovers it will probably be user with a blown stack. :( Could we
> set a flag on the task or something that warns as such (i.e. "WARNING:
> attempted block reservation in block reclaim context") or perhaps just
> prevents scan reentry in the first place?

What if we implemented a XFS_TRANS_TRYRESERVE flag that would skip the
scanning loops?  Then it would be at least a little more obvious when
xfs_free_eofblocks and xfs_reflink_cancel_cow_range kick on.

OTOH that's problematic because both of those functions have other
callers, and "we're already doing a blockgc scan, don't start another"
is part of the thread context.

--D

> 
> Brian
> 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > [  316.631387] ============================================
> > > [  316.636697] WARNING: possible recursive locking detected
> > > [  316.642010] 5.11.0-rc4 #35 Tainted: G        W I      
> > > [  316.647148] --------------------------------------------
> > > [  316.652462] fsstress/17733 is trying to acquire lock:
> > > [  316.657515] ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_free_eofblocks+0x104/0x1d0 [xfs]
> > > [  316.666405] 
> > >                but task is already holding lock:
> > > [  316.672239] ffff8e0fd1d90650 (sb_internal){++++}-{0:0}, at: xfs_trans_alloc_inode+0x5f/0x160 [xfs]
> > > [  316.681269] 
> > > ...
> > >                stack backtrace:
> > > [  316.774735] CPU: 38 PID: 17733 Comm: fsstress Tainted: G        W I       5.11.0-rc4 #35
> > > [  316.782819] Hardware name: Dell Inc. PowerEdge R740/01KPX8, BIOS 1.6.11 11/20/2018
> > > [  316.790386] Call Trace:
> > > [  316.792844]  dump_stack+0x8b/0xb0
> > > [  316.796168]  __lock_acquire.cold+0x159/0x2ab
> > > [  316.800441]  lock_acquire+0x116/0x370
> > > [  316.804106]  ? xfs_free_eofblocks+0x104/0x1d0 [xfs]
> > > [  316.809045]  ? rcu_read_lock_sched_held+0x3f/0x80
> > > [  316.813750]  ? kmem_cache_alloc+0x287/0x2b0
> > > [  316.817937]  xfs_trans_alloc+0x1ad/0x310 [xfs]
> > > [  316.822445]  ? xfs_free_eofblocks+0x104/0x1d0 [xfs]
> > > [  316.827376]  xfs_free_eofblocks+0x104/0x1d0 [xfs]
> > > [  316.832134]  xfs_blockgc_scan_inode+0x24/0x60 [xfs]
> > > [  316.837074]  xfs_inode_walk_ag+0x202/0x4b0 [xfs]
> > > [  316.841754]  ? xfs_inode_free_cowblocks+0xf0/0xf0 [xfs]
> > > [  316.847040]  ? __lock_acquire+0x382/0x1e10
> > > [  316.851142]  ? xfs_inode_free_cowblocks+0xf0/0xf0 [xfs]
> > > [  316.856425]  xfs_inode_walk+0x66/0xc0 [xfs]
> > > [  316.860670]  xfs_trans_alloc+0x160/0x310 [xfs]
> > > [  316.865179]  xfs_trans_alloc_inode+0x5f/0x160 [xfs]
> > > [  316.870119]  xfs_alloc_file_space+0x105/0x300 [xfs]
> > > [  316.875048]  ? down_write_nested+0x30/0x70
> > > [  316.879148]  xfs_file_fallocate+0x270/0x460 [xfs]
> > > [  316.883913]  ? lock_acquire+0x116/0x370
> > > [  316.887752]  ? __x64_sys_fallocate+0x3e/0x70
> > > [  316.892026]  ? selinux_file_permission+0x105/0x140
> > > [  316.896820]  vfs_fallocate+0x14d/0x3d0
> > > [  316.900572]  __x64_sys_fallocate+0x3e/0x70
> > > [  316.904669]  do_syscall_64+0x33/0x40
> > > [  316.908250]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > ...
> > > 
> > 
> 
