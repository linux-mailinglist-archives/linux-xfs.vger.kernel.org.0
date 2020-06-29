Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F247620E905
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jun 2020 01:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgF2XBj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 29 Jun 2020 19:01:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54788 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbgF2XBj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jun 2020 19:01:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05TMwGNB118973;
        Mon, 29 Jun 2020 23:01:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zabfzxWNg2ZL7UrR1kUQwajZ3s37NfP29xWQ4SGFb2o=;
 b=mwOxaxHAgS/l+7HnGmFGOzuqBX3F7BMdm4+ie54e5OTTW3rasA4/bxQmCEZVoin4eBcL
 /G5p70dAjr2clUhMz5Z30G5kUj1b4FdY3jC8wtU9kB5kcGIksdr+Ru5iomTsG1MB7nGQ
 5oqpjH43qoPHQst/crV6VtjDqZt5+XKSe0CvPYBxO1KSfvhCzucDS2bl7OYGu62VBis7
 tU31WHSDWjQOgANPMY9i8il1GOex9Jy62fG0C+0bEzh3PlrUEapO5a9MZlEb75Lal/Zk
 X+Dc6PuzubrkyCE7UNsqgIrf4DdGVafQT4vEFKuh/xmz/YIFPh2w4donLdBNRoyz2mvF mQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31xx1dnytt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 29 Jun 2020 23:01:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05TMweuu175820;
        Mon, 29 Jun 2020 23:01:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31xg11kywb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Jun 2020 23:01:32 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05TN1V5I031886;
        Mon, 29 Jun 2020 23:01:31 GMT
Received: from localhost (/10.159.231.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Jun 2020 23:01:30 +0000
Date:   Mon, 29 Jun 2020 16:01:30 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/30] xfs: rework inode flushing to make inode reclaim
 fully asynchronous
Message-ID: <20200629230130.GS7606@magnolia>
References: <20200622081605.1818434-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622081605.1818434-1-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=7 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006290146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9667 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=7 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006290146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 22, 2020 at 06:15:35PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> Inode flushing requires that we first lock an inode, then check it,
> then lock the underlying buffer, flush the inode to the buffer and
> finally add the inode to the buffer to be unlocked on IO completion.
> We then walk all the other cached inodes in the buffer range and
> optimistically lock and flush them to the buffer without blocking.

Well, I've been banging my head against this patchset for the past
couple of weeks now, and I still can't get it to finish fstests
reliably.

Last week, Dave and I were stymied by a bug in the scheduler that was
fixed in -rc3, but even with that applied I still see weird failures.  I
/think/ there are only two now:

1) If I run xfs/305 (with all three quotas enabled) in a tight loop (and
rmmod xfs after each run), after 20-30 minutes I will start to see the
slub cache start complaining about leftovers in the xfs_ili (inode log
item) and xfs_inode caches.

Unfortunately, due to the kernel's new security posture of never
allowing kernel pointer values to be logged, the slub complaints are
mostly useless because it no longer prints anything that would enable me
to figure out /which/ inodes are being left behind:

 =============================================================================
 BUG xfs_ili (Tainted: G    B            ): Objects remaining in xfs_ili on __kmem_cache_shutdown()
 -----------------------------------------------------------------------------
 
 INFO: Slab 0x000000007e8837cf objects=31 used=9 fp=0x000000007017e948 flags=0x000000000010200
 CPU: 1 PID: 80614 Comm: rmmod Tainted: G    B             5.8.0-rc3-djw #rc3
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1 04/01/2014
 Call Trace:
  dump_stack+0x78/0xa0
  slab_err+0xb7/0xdc
  ? trace_hardirqs_on+0x1c/0xf0
  __kmem_cache_shutdown.cold+0x3a/0x163
  ? __mutex_unlock_slowpath+0x45/0x2a0
  kmem_cache_destroy+0x55/0x110
  xfs_destroy_zones+0x6a/0xe2 [xfs]
  exit_xfs_fs+0x5f/0xb7b [xfs]
  __x64_sys_delete_module+0x120/0x210
  ? __prepare_exit_to_usermode+0xe4/0x170
  do_syscall_64+0x56/0xa0
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7ff204672a3b
 Code: Bad RIP value.
 RSP: 002b:00007ffe60155378 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
 RAX: ffffffffffffffda RBX: 0000558f2bfa2780 RCX: 00007ff204672a3b
 RDX: 000000000000000a RSI: 0000000000000800 RDI: 0000558f2bfa27e8
 RBP: 00007ffe601553d8 R08: 0000000000000000 R09: 0000000000000000
 R10: 00007ff2046eeac0 R11: 0000000000000206 R12: 00007ffe601555b0
 R13: 00007ffe6015703d R14: 0000558f2bfa12a0 R15: 0000558f2bfa2780
 INFO: Object 0x00000000a92e3c34 @offset=0
 INFO: Object 0x00000000650eb3bf @offset=792
 INFO: Object 0x00000000eabfef0f @offset=1320
 INFO: Object 0x00000000cdaae406 @offset=4224
 INFO: Object 0x000000007d9bbde1 @offset=4488
 INFO: Object 0x00000000e35f4716 @offset=5016
 INFO: Object 0x0000000008e636d2 @offset=5280
 INFO: Object 0x00000000170762ee @offset=5808
 INFO: Object 0x0000000046425f04 @offset=7920

Note all the 64-bit values that have the 32 upper bits set to 0; this
is the pointer hashing safety algorithm at work.  I've patched around
that bit of training-wheels drain bamage, but now I get to wait until it
happens again.

2) If /that/ doesn't happen, a regular fstests run (again with all three
quotas enabled) will (usually very quickly) wedge in unmount:

[<0>] xfs_qm_dquot_walk+0x19c/0x2b0 [xfs]
[<0>] xfs_qm_dqpurge_all+0x31/0x70 [xfs]
[<0>] xfs_qm_unmount+0x1d/0x30 [xfs]
[<0>] xfs_unmountfs+0xa0/0x1a0 [xfs]
[<0>] xfs_fs_put_super+0x35/0x80 [xfs]
[<0>] generic_shutdown_super+0x67/0x100
[<0>] kill_block_super+0x21/0x50
[<0>] deactivate_locked_super+0x31/0x70
[<0>] cleanup_mnt+0x100/0x160
[<0>] task_work_run+0x5f/0xa0
[<0>] __prepare_exit_to_usermode+0x13d/0x170
[<0>] do_syscall_64+0x62/0xa0
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

AFAICT it's usually the root dquot and dqpurge won't touch it because
the quota nrefs > 0.  Poking around in gdb, I find that whichever
xfs_mount is stalled does not seem to have any vfs inodes attached to
it, so it's clear that we flushed and freed all the incore inode state,
which means that all the dquots should be unreferenced.

Both of these failure cases have been difficult to reproduce, which is
to say that I can't get them to repro reliably.  Turning PREEMPT on
seems to make it reproduce faster, which makes me wonder if something in
this patchset is screwing up concurrency handling or something?  KASAN
and kmemleak have nothing to say.  I've also noticed that the less
heavily loaded the underlying VM host's storage system, the less likely
it is to happen, though that could be a coincidence.

Anyway, if I figure something out I'll holler, but I thought it was past
time to braindump on the mailing list.

--D

> This cluster write effectively repeats the same code we do with the
> initial inode, except now it has to special case that initial inode
> that is already locked. Hence we have multiple copies of very
> similar code, and it is a result of inode cluster flushing being
> based on a specific inode rather than grabbing the buffer and
> flushing all available inodes to it.
> 
> The problem with this at the moment is that we we can't look up the
> buffer until we have guaranteed that an inode is held exclusively
> and it's not going away while we get the buffer through an imap
> lookup. Hence we are kinda stuck locking an inode before we can look
> up the buffer.
> 
> This is also a result of inodes being detached from the cluster
> buffer except when IO is being done. This has the further problem
> that the cluster buffer can be reclaimed from memory and then the
> inode can be dirtied. At this point cleaning the inode requires a
> read-modify-write cycle on the cluster buffer. If we then are put
> under memory pressure, cleaning that dirty inode to reclaim it
> requires allocating memory for the cluster buffer and this leads to
> all sorts of problems.
> 
> We used synchronous inode writeback in reclaim as a throttle that
> provided a forwards progress mechanism when RMW cycles were required
> to clean inodes. Async writeback of inodes (e.g. via the AIL) would
> immediately exhaust remaining memory reserves trying to allocate
> inode cluster after inode cluster. The synchronous writeback of an
> inode cluster allowed reclaim to release the inode cluster and have
> it freed almost immediately which could then be used to allocate the
> next inode cluster buffer. Hence the IO based throttling mechanism
> largely guaranteed forwards progress in inode reclaim. By removing
> the requirement for require memory allocation for inode writeback
> filesystem level, we can issue writeback asynchrnously and not have
> to worry about the memory exhaustion anymore.
> 
> Another issue is that if we have slow disks, we can build up dirty
> inodes in memory that can then take hours for an operation like
> unmount to flush. A RMW cycle per inode on a slow RAID6 device can
> mean we only clean 50 inodes a second, and when there are hundreds
> of thousands of dirty inodes that need to be cleaned this can take a
> long time. PInning the cluster buffers will greatly speed up inode
> writeback on slow storage systems like this.
> 
> These limitations all stem from the same source: inode writeback is
> inode centric, And they are largely solved by the same architectural
> change: make inode writeback cluster buffer centric.  This series is
> makes that architectural change.
> 
> Firstly, we start by pinning the inode backing buffer in memory
> when an inode is marked dirty (i.e. when it is logged). By tracking
> the number of dirty inodes on a buffer as a counter rather than a
> flag, we avoid the problem of overlapping inode dirtying and buffer
> flushing racing to set/clear the dirty flag. Hence as long as there
> is a dirty inode in memory, the buffer will not be able to be
> reclaimed. We can safely do this inode cluster buffer lookup when we
> dirty an inode as we do not hold the buffer locked - we merely take
> a reference to it and then release it - and hence we don't cause any
> new lock order issues.
> 
> When the inode is finally cleaned, the reference to the buffer can
> be removed from the inode log item and the buffer released. This is
> done from the inode completion callbacks that are attached to the
> buffer when the inode is flushed.
> 
> Pinning the cluster buffer in this way immediately avoids the RMW
> problem in inode writeback and reclaim contexts by moving the memory
> allocation and the blocking buffer read into the transaction context
> that dirties the inode.  This inverts our dirty inode throttling
> mechanism - we now throttle the rate at which we can dirty inodes to
> rate at which we can allocate memory and read inode cluster buffers
> into memory rather than via throttling reclaim to rate at which we
> can clean dirty inodes.
> 
> Hence if we are under memory pressure, we'll block on memory
> allocation when trying to dirty the referenced inode, rather than in
> the memory reclaim path where we are trying to clean unreferenced
> inodes to free memory.  Hence we no longer have to guarantee
> forwards progress in inode reclaim as we aren't doing memory
> allocation, and that means we can remove inode writeback from the
> XFS inode shrinker completely without changing the system tolerance
> for low memory operation.
> 
> Tracking the buffers via the inode log item also allows us to
> completely rework the inode flushing mechanism. While the inode log
> item is in the AIL, it is safe for the AIL to access any member of
> the log item. Hence the AIL push mechanisms can access the buffer
> attached to the inode without first having to lock the inode.
> 
> This means we can essentially lock the buffer directly and then
> call xfs_iflush_cluster() without first going through xfs_iflush()
> to find the buffer. Hence we can remove xfs_iflush() altogether,
> because the two places that call it - the inode item push code and
> inode reclaim - no longer need to flush inodes directly.
> 
> This can be further optimised by attaching the inode to the cluster
> buffer when the inode is dirtied. i.e. when we add the buffer
> reference to the inode log item, we also attach the inode to the
> buffer for IO processing. This leads to the dirty inodes always
> being attached to the buffer and hence we no longer need to add them
> when we flush the inode and remove them when IO completes. Instead
> the inodes are attached when the node log item is dirtied, and
> removed when the inode log item is cleaned.
> 
> With this structure in place, we no longer need to do
> lookups to find the dirty inodes in the cache to attach to the
> buffer in xfs_iflush_cluster() - they are already attached to the
> buffer. Hence when the AIL pushes an inode, we just grab the buffer
> from the log item, and then walk the buffer log item list to lock
> and flush the dirty inodes attached to the buffer.
> 
> This greatly simplifies inode writeback, and removes another memory
> allocation from the inode writeback path (the array used for the
> radix tree gang lookup). And while the radix tree lookups are fast,
> walking the linked list of dirty inodes is faster.
> 
> There is followup work I am doing that uses the inode cluster buffer
> as a replacement in the AIL for tracking dirty inodes. This part of
> the series is not ready yet as it has some intricate locking
> requirements. That is an optimisation, so I've left that out because
> solving the inode reclaim blocking problems is the important part of
> this work.
> 
> In short, this series simplifies inode writeback and fixes the long
> standing inode reclaim blocking issues without requiring any changes
> to the memory reclaim infrastructure.
> 
> Note: dquots should probably be converted to cluster flushing in a
> similar way, as they have many of the same issues as inode flushing.
> 
> Thoughts, comments and improvemnts welcome.
> 
> -Dave.
> 
> Version 4:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-async-inode-reclaim-4
> 
> - rebase on 5.8-rc2 + for-next
> - fix buffer retry logic braino (p13)
> - removed unnecessary asserts (p24)
> - removed unnecessary delwri queue checks from
>   xfs_inode_item_push (p24)
> - rework return value from xfs_iflush_cluster to indicate -EAGAIN if
>   no inodes were flushed and handle that case in the caller. (p28)
> - rewrite comment about shutdown case in xfs_iflush_cluster (p28)
> - always clear XFS_LI_FAILED for items requiring AIL processing
>   (p29)
> 
> 
> Version 3
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-async-inode-reclaim-3
> 
> - rebase on 5.7 + for-next
> - update comments (p3)
> - update commit message (p4)
> - renamed xfs_buf_ioerror_sync() (p13)
> - added enum for return value from xfs_buf_iodone_error() (p13)
> - moved clearing of buffer error to iodone functions (p13)
> - whitespace (p13)
> - rebase p14 (p13 conflicts)
> - rebase p16 (p13 conflicts)
> - removed a superfluous assert (p16)
> - moved comment and check in xfs_iflush_done() from p16 to p25
> - rebase p25 (p16 conflicts)
> 
> 
> 
> Version 2
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-async-inode-reclaim-2
> 
> - describe ili_lock better (p2)
> - clean up inode logging code some more (p2)
> - move "early read completion" for xfs_buf_ioend() up into p3 from
>   p4.
> - fixed conflicts in p4 due to p3 changes.
> - fixed conflicts in p5 due to p4 changes.
> - s/_XBF_LOGRCVY/_XBF_LOG_RECOVERY/ (p5)
> - renamed the buf log item iodone callback to xfs_buf_item_iodone and
>   reused the xfs_buf_iodone() name for the catch-all buffer write
>   iodone completion. (p6)
> - history update for commit message (p7)
> - subject update for p8
> - rework loop in xfs_dquot_done() (p9)
> - Fixed conflicts in p10 due to p6 changes
> - got rid of entire comments around li_cb (p11)
> - new patch to rework buffer io error callbacks
> - new patch to unwind ->iop_error calls and remove ->iop_error
> - new patch to lift xfs_clear_li_failed() out of
>   xfs_ail_delete_one()
> - rebased p12 on all the prior changes
> - reworked LI_FAILED handling when pinning inodes to the cluster
>   buffer (p12) 
> - fixed comment about holding buffer references in
>   xfs_trans_log_inode() (p12)
> - fixed indenting of xfs_iflush_abort() (p12)
> - added comments explaining "skipped" indoe reclaim return value
>   (p14)
> - cleaned up error return stack in xfs_reclaim_inode() (p14)
> - cleaned up skipped return in xfs_reclaim_inodes() (p14)
> - fixed bug where skipped wasn't incremented if reclaim cursor was
>   not zero. This could leave inodes between the start of the AG and
>   the cursor unreclaimed (p15)
> - reinstate the patch removing SYNC_WAIT from xfs_reclaim_inodes().
>   Exposed "skipped" bug in p15.
> - cleaned up inode reclaim comments (p18)
> - split p19 into two - one to change xfs_ifree_cluster(), one
>   for the buffer pinning.
> - xfs_ifree_mark_inode_stale() now takes the cluster buffer and we
>   get the perag from that rather than having to do a lookup in
>   xfs_ifree_cluster().
> - moved extra IO reference for xfs_iflush_cluster() from AIL pushing
>   to initial xfs_iflush_cluster rework (p22 -> p20)
> - fixed static declaration on xfs_iflush() (p22)
> - fixed incorrect EIO return from xfs_iflush_cluster()
> - rebase p23 because it all rejects now.
> - fix INODE_ITEM() usage in p23
> - removed long lines from commit message in p24
> - new patch to fix logging of XFS_ISTALE inodes which pushes dirty
>   inodes through reclaim.
> 
> 
> 
> Dave Chinner (30):
>   xfs: Don't allow logging of XFS_ISTALE inodes
>   xfs: remove logged flag from inode log item
>   xfs: add an inode item lock
>   xfs: mark inode buffers in cache
>   xfs: mark dquot buffers in cache
>   xfs: mark log recovery buffers for completion
>   xfs: call xfs_buf_iodone directly
>   xfs: clean up whacky buffer log item list reinit
>   xfs: make inode IO completion buffer centric
>   xfs: use direct calls for dquot IO completion
>   xfs: clean up the buffer iodone callback functions
>   xfs: get rid of log item callbacks
>   xfs: handle buffer log item IO errors directly
>   xfs: unwind log item error flagging
>   xfs: move xfs_clear_li_failed out of xfs_ail_delete_one()
>   xfs: pin inode backing buffer to the inode log item
>   xfs: make inode reclaim almost non-blocking
>   xfs: remove IO submission from xfs_reclaim_inode()
>   xfs: allow multiple reclaimers per AG
>   xfs: don't block inode reclaim on the ILOCK
>   xfs: remove SYNC_TRYLOCK from inode reclaim
>   xfs: remove SYNC_WAIT from xfs_reclaim_inodes()
>   xfs: clean up inode reclaim comments
>   xfs: rework stale inodes in xfs_ifree_cluster
>   xfs: attach inodes to the cluster buffer when dirtied
>   xfs: xfs_iflush() is no longer necessary
>   xfs: rename xfs_iflush_int()
>   xfs: rework xfs_iflush_cluster() dirty inode iteration
>   xfs: factor xfs_iflush_done
>   xfs: remove xfs_inobp_check()
> 
>  fs/xfs/libxfs/xfs_inode_buf.c   |  27 +-
>  fs/xfs/libxfs/xfs_inode_buf.h   |   6 -
>  fs/xfs/libxfs/xfs_trans_inode.c | 110 +++++--
>  fs/xfs/xfs_buf.c                |  40 ++-
>  fs/xfs/xfs_buf.h                |  48 ++-
>  fs/xfs/xfs_buf_item.c           | 419 +++++++++++------------
>  fs/xfs/xfs_buf_item.h           |   8 +-
>  fs/xfs/xfs_buf_item_recover.c   |   5 +-
>  fs/xfs/xfs_dquot.c              |  29 +-
>  fs/xfs/xfs_dquot.h              |   1 +
>  fs/xfs/xfs_dquot_item.c         |  18 -
>  fs/xfs/xfs_dquot_item_recover.c |   2 +-
>  fs/xfs/xfs_file.c               |   9 +-
>  fs/xfs/xfs_icache.c             | 333 ++++++-------------
>  fs/xfs/xfs_icache.h             |   2 +-
>  fs/xfs/xfs_inode.c              | 567 ++++++++++++--------------------
>  fs/xfs/xfs_inode.h              |   2 +-
>  fs/xfs/xfs_inode_item.c         | 303 +++++++++--------
>  fs/xfs/xfs_inode_item.h         |  24 +-
>  fs/xfs/xfs_inode_item_recover.c |   2 +-
>  fs/xfs/xfs_log_recover.c        |   5 +-
>  fs/xfs/xfs_mount.c              |  15 +-
>  fs/xfs/xfs_mount.h              |   1 -
>  fs/xfs/xfs_super.c              |   3 -
>  fs/xfs/xfs_trans.h              |   5 -
>  fs/xfs/xfs_trans_ail.c          |  10 +-
>  fs/xfs/xfs_trans_buf.c          |  15 +-
>  27 files changed, 889 insertions(+), 1120 deletions(-)
> 
> -- 
> 2.26.2.761.g0e0b3e54be
> 
