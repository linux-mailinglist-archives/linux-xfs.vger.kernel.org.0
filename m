Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A41841A1005
	for <lists+linux-xfs@lfdr.de>; Tue,  7 Apr 2020 17:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgDGPRo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-xfs@lfdr.de>); Tue, 7 Apr 2020 11:17:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:43172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbgDGPRo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Apr 2020 11:17:44 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 207053] fsfreeze deadlock on XFS (the FIFREEZE ioctl and
 subsequent FITHAW hang indefinitely)
Date:   Tue, 07 Apr 2020 15:17:42 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: darrick.wong@oracle.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-207053-201763-LAUNdWJ8bC@https.bugzilla.kernel.org/>
In-Reply-To: <bug-207053-201763@https.bugzilla.kernel.org/>
References: <bug-207053-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207053

--- Comment #4 from darrick.wong@oracle.com ---
On Tue, Apr 07, 2020 at 09:18:12AM -0400, Brian Foster wrote:
> On Tue, Apr 07, 2020 at 06:41:31AM +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=207053
> > 
> > --- Comment #2 from Paul Furtado (paulfurtado91@gmail.com) ---
> > Hi Dave,
> > 
> > Just had another case of this crop up and I was able to get the blocked
> tasks
> > output before automation killed the server. Because the log was too large
> to
> > attach, I've pasted the output into a github gist here:
> >
> https://gist.githubusercontent.com/PaulFurtado/c9bade038b8a5c7ddb53a6e10def058f/raw/ee43926c96c0d6a9ec81a648754c1af599ef0bdd/sysrq_w.log
> > 
> 
> Hm, so it looks like this is stuck between freeze:
> 
> [377279.630957] fsfreeze        D    0 46819  46337 0x00004084
> [377279.634910] Call Trace:
> [377279.637594]  ? __schedule+0x292/0x6f0
> [377279.640833]  ? xfs_xattr_get+0x51/0x80 [xfs]
> [377279.644287]  schedule+0x2f/0xa0
> [377279.647286]  schedule_timeout+0x1dd/0x300
> [377279.650661]  wait_for_completion+0x126/0x190
> [377279.654154]  ? wake_up_q+0x80/0x80
> [377279.657277]  ? work_busy+0x80/0x80
> [377279.660375]  __flush_work+0x177/0x1b0
> [377279.663604]  ? worker_attach_to_pool+0x90/0x90
> [377279.667121]  __cancel_work_timer+0x12b/0x1b0
> [377279.670571]  ? rcu_sync_enter+0x8b/0xd0
> [377279.673864]  xfs_stop_block_reaping+0x15/0x30 [xfs]
> [377279.677585]  xfs_fs_freeze+0x15/0x40 [xfs]
> [377279.680950]  freeze_super+0xc8/0x190
> [377279.684086]  do_vfs_ioctl+0x510/0x630
> ...
> 
> ... and the eofblocks scanner:
> 
> [377279.422496] Workqueue: xfs-eofblocks/nvme13n1 xfs_eofblocks_worker [xfs]
> [377279.426971] Call Trace:
> [377279.429662]  ? __schedule+0x292/0x6f0
> [377279.432839]  schedule+0x2f/0xa0
> [377279.435794]  rwsem_down_read_slowpath+0x196/0x530
> [377279.439435]  ? kmem_cache_alloc+0x152/0x1f0
> [377279.442834]  ? __percpu_down_read+0x49/0x60
> [377279.446242]  __percpu_down_read+0x49/0x60
> [377279.449586]  __sb_start_write+0x5b/0x60
> [377279.452869]  xfs_trans_alloc+0x152/0x160 [xfs]
> [377279.456372]  xfs_free_eofblocks+0x12d/0x1f0 [xfs]
> [377279.460014]  xfs_inode_free_eofblocks+0x128/0x1a0 [xfs]
> [377279.463903]  ? xfs_inode_ag_walk_grab+0x5f/0x90 [xfs]
> [377279.467680]  xfs_inode_ag_walk.isra.17+0x1a7/0x410 [xfs]
> [377279.471567]  ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
> [377279.475620]  ? kvm_sched_clock_read+0xd/0x20
> [377279.479059]  ? sched_clock+0x5/0x10
> [377279.482184]  ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
> [377279.486234]  ? radix_tree_gang_lookup_tag+0xa8/0x100
> [377279.489974]  ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
> [377279.494041]  xfs_inode_ag_iterator_tag+0x73/0xb0 [xfs]
> [377279.497859]  xfs_eofblocks_worker+0x29/0x40 [xfs]
> [377279.501484]  process_one_work+0x195/0x380
> ...
> 
> The immediate issue is likely that the eofblocks transaction is not
> NOWRITECOUNT (same for the cowblocks scanner, btw), but the problem with
> doing that is these helpers are called from other contexts outside of
> the background scanners.
> 
> Perhaps what we need to do here is let these background scanners acquire
> a superblock write reference, similar to what Darrick recently added to
> scrub..? We'd have to do that from the scanner workqueue task, so it
> would probably need to be a trylock so we don't end up in a similar
> situation as above. I.e., we'd either get the reference and cause freeze
> to wait until it's dropped or bail out if freeze has already stopped the
> transaction subsystem. Thoughts?

Hmm, I had a whole gigantic series to refactor all the speculative
preallocation gc work into a single thread + radix tree tag; I'll see if
that series actually fixed this problem too.

But yes, all background threads that run transactions need to have
freezer protection.

--D

> Brian
> 
> > 
> > Thanks,
> > Paul
> > 
> > -- 
> > You are receiving this mail because:
> > You are watching the assignee of the bug.
> > 
>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
