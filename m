Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D53C4F2038
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Apr 2022 01:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiDDXYH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 Apr 2022 19:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240960AbiDDXYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Apr 2022 19:24:05 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7D19211A0A
        for <linux-xfs@vger.kernel.org>; Mon,  4 Apr 2022 16:22:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EFEB0534429;
        Tue,  5 Apr 2022 09:22:06 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nbW1M-00DqDK-U2; Tue, 05 Apr 2022 09:22:04 +1000
Date:   Tue, 5 Apr 2022 09:22:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Frank Hofmann <fhofmann@cloudflare.com>
Cc:     linux-xfs@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>
Subject: Re: Self-deadlock (?) in xfs_inodegc_worker / xfs_inactive ?
Message-ID: <20220404232204.GT1544202@dread.disaster.area>
References: <CABEBQikRSCuJumOYmgzNLN6dOZ+YUvOQMFby7WJGSwGoFM3YMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABEBQikRSCuJumOYmgzNLN6dOZ+YUvOQMFby7WJGSwGoFM3YMg@mail.gmail.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=624b7d9f
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=20KFwNOVAAAA:8 a=FI5acT2o5D41UJrUL44A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 04, 2022 at 02:16:23PM +0100, Frank Hofmann wrote:
> Hi,
> 
> we see machines getting stuck with a large number of backed-up
> processes that invoke statfs() (monitoring stuff), like:
>
> [Sat Apr  2 09:54:32 2022] INFO: task node_exporter:244222 blocked for
> more than 10 seconds.
> [Sat Apr  2 09:54:32 2022]       Tainted: G           O
> 5.15.26-cloudflare-2022.3.4 #1

Is this a vanilla kernel, or one that has been patched extensively
by cloudfare?

> [Sat Apr  2 09:54:32 2022] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Sat Apr  2 09:54:32 2022] task:node_exporter   state:D stack:    0
> pid:244222 ppid:     1 flags:0x00004000
> [Sat Apr  2 09:54:32 2022] Call Trace:
> [Sat Apr  2 09:54:32 2022]  <TASK>
> [Sat Apr  2 09:54:32 2022]  __schedule+0x2cd/0x950
> [Sat Apr  2 09:54:32 2022]  schedule+0x44/0xa0
> [Sat Apr  2 09:54:32 2022]  schedule_timeout+0xfc/0x140
> [Sat Apr  2 09:54:32 2022]  ? try_to_wake_up+0x338/0x4e0
> [Sat Apr  2 09:54:32 2022]  ? __prepare_to_swait+0x4b/0x70
> [Sat Apr  2 09:54:32 2022]  wait_for_completion+0x86/0xe0
> [Sat Apr  2 09:54:32 2022]  flush_work+0x5c/0x80
> [Sat Apr  2 09:54:32 2022]  ? flush_workqueue_prep_pwqs+0x110/0x110
> [Sat Apr  2 09:54:32 2022]  xfs_inodegc_flush.part.0+0x3b/0x90
> [Sat Apr  2 09:54:32 2022]  xfs_fs_statfs+0x29/0x1c0
> [Sat Apr  2 09:54:32 2022]  statfs_by_dentry+0x4d/0x70
> [Sat Apr  2 09:54:32 2022]  user_statfs+0x57/0xc0
> [Sat Apr  2 09:54:32 2022]  __do_sys_statfs+0x20/0x50
> [Sat Apr  2 09:54:32 2022]  do_syscall_64+0x3b/0x90
> [Sat Apr  2 09:54:32 2022]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [Sat Apr  2 09:54:32 2022] RIP: 0033:0x4ac9db

Waiting for background inode gc to complete.

> A linear-over-time increasing number of 'D' state processes is usually
> what alerts us to this.
> 
> The oldest thread found waiting appears always to be the inode gc
> worker doing deferred inactivation:

OK.

> This is a histogram (first column: number of proceses 'D'-ed on that
> call trace) of `/proc/<PID>/stack`:

It helps greatly if you reformat the stacks back to a readable stack
(s/=>/\r/g, s/^\n//, s/^ //) so the output is easily readable.

> 1 stuck on AGF, holding AGI, inode and inode buffer locks
> 
> down+0x43/0x60 
> xfs_buf_lock+0x29/0xa0 
> xfs_buf_find+0x2c4/0x590
> xfs_buf_get_map+0x46/0x390 
> xfs_buf_read_map+0x52/0x270 
> xfs_trans_read_buf_map+0x128/0x2a0 
> xfs_read_agf+0x87/0x110 
> xfs_alloc_read_agf+0x34/0x1a0 
> xfs_alloc_fix_freelist+0x3d7/0x4f0 
> xfs_alloc_vextent+0x22b/0x440 
> __xfs_inobt_alloc_block.isra.0+0xc5/0x1a0 
> __xfs_btree_split+0xf2/0x610 
> xfs_btree_split+0x4b/0x100 
> xfs_btree_make_block_unfull+0x193/0x1c0 
> xfs_btree_insrec+0x4a9/0x5a0 
> xfs_btree_insert+0xa8/0x1f0 
> xfs_difree_finobt+0xa4/0x240 
> xfs_difree+0x126/0x1a0 
> xfs_ifree+0xca/0x4a0 
> xfs_inactive_ifree.isra.0+0x9e/0x1a0 
> xfs_inactive+0xf8/0x170 
> xfs_inodegc_worker+0x73/0xf0 
> process_one_work+0x1e6/0x380 
> worker_thread+0x50/0x3a0 
> kthread+0x127/0x150 
> ret_from_fork+0x22/0x30
> 
> 1	stuck on inode buffer, holding inode lock, holding AGF
> 
> down+0x43/0x60 
> xfs_buf_lock+0x29/0xa0 
> xfs_buf_find+0x2c4/0x590
> xfs_buf_get_map+0x46/0x390 
> xfs_buf_read_map+0x52/0x270 
> xfs_trans_read_buf_map+0x128/0x2a0 
> xfs_imap_to_bp+0x4e/0x70 
> xfs_trans_log_inode+0x1d0/0x280 
> xfs_bmap_btalloc+0x75f/0x820 
> xfs_bmapi_allocate+0xe4/0x310 
> xfs_bmapi_convert_delalloc+0x273/0x490 
> xfs_map_blocks+0x1b5/0x400
> iomap_do_writepage+0x11d/0x820 
> write_cache_pages+0x189/0x3e0 
> iomap_writepages+0x1c/0x40 
> xfs_vm_writepages+0x71/0xa0 
> do_writepages+0xc3/0x1e0 
> __writeback_single_inode+0x37/0x270 
> writeback_sb_inodes+0x1ed/0x420 
> __writeback_inodes_wb+0x4c/0xd0 
> wb_writeback+0x1ba/0x270 
> wb_workfn+0x292/0x4d0 
> process_one_work+0x1e6/0x380 
> worker_thread+0x50/0x3a0 
> kthread+0x127/0x150 
> ret_from_fork+0x22/0x30

That's the deadlock right there.

task 1				task 2
lock inode A			lock inode A+1
lock AGF B for allocation	lock inode cluster
				remove inode from unlinked list
				free inode
				mark inode free in finobt
				  insert new rec
				    split tree
				      lock AGF B for allocation
				      <blocks waiting for task 1>
<allocate blocks>

xfs_bmap_finish
  log inode
    lock inode cluster buffer
    <blocks waiting for task 2>

So this has nothing to do with background inode inactivation. It may
have made it easier to hit, but it's definitely not *caused* by
background inodegc as these two operations have always been able to
run concurrently.

The likely cause is going to be the async memory reclaim work from
late June 2020. Commit 298f7bec503f ("xfs: pin inode backing buffer
to the inode log item") added the xfs_imap_to_bp() call to
xfs_trans_log_inode() to pin the inode cluster buffer in memory when
the inode was first dirtied.

Essentially, the problem is that inode unlink list manipulations are
not consistently ordered with inode allocation/freeing, hence not
consistently ordered against AGI and AGF locking. I didn't realise
that there was an AGF component to this problem, otherwise I would
have sent this patch upstream much sooner:

https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git/commit/?h=xfs-iunlink-item-2&id=17b71a2fba3549ea55e8bef764532fd42be1213a

That commit is dated August 2020 - about the same time that the
async memory reclaim stuff was merged. What this will do is:

task 1				task 2
lock inode A			lock inode A+1
lock AGF B for allocation
				free inode
				mark inode free in finobt
				  insert new rec
				    split tree
				      lock AGF B for allocation
				      <blocks waiting for task 1>
<allocate blocks>

xfs_bmap_finish
  log inode
    lock inode cluster buffer
    attach inode
    unlock inode cluster buffer
xfs_trans_commit
  ...
  unlock AGF B
				      <unblocks, holds AGF B>
				      <allocate blocks>
				    <completes split>
				  <completes insert>
				<completes ifree>
				lock inode cluster buffer
				remove inode from unlinked list
				xfs_trans_commit
				  ...
				  unlock AGF B
				  unlock inode cluster buffer

And so the deadlock should go away.

I've attached the current patch from my local dev tree below. Can
you try it and see if the problem goes away?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: reorder iunlink remove operation in xfs_ifree

From: Dave Chinner <dchinner@redhat.com>

The O_TMPFILE creation implementation creates a specific order of
operations for inode allocation/freeing and unlinked list
modification. Currently both are serialised by the AGI, so the order
doesn't strictly matter as long as the are both in the same
transaction.

However, if we want to move the unlinked list insertions largely
out from under the AGI lock, then we have to be concerned about the
order in which we do unlinked list modification operations.
O_TMPFILE creation tells us this order is inode allocation/free,
then unlinked list modification.

Change xfs_ifree() to use this same ordering on unlinked list
removal. THis way we always guarantee that when we enter the
iunlinked list removal code from this path, we have the already
locked and we don't have to worry about lock nesting AGI reads
inside unlink list locks because it's already locked and attached to
the transaction.

We can do this safely as the inode freeing and unlinked list removal
are done in the same transaction and hence are atomic operations
with resepect to log recovery.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_inode.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c66c9585f1ba..f8eaeb83d05e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2277,14 +2277,13 @@ xfs_ifree_cluster(
 }
 
 /*
- * This is called to return an inode to the inode free list.
- * The inode should already be truncated to 0 length and have
- * no pages associated with it.  This routine also assumes that
- * the inode is already a part of the transaction.
+ * This is called to return an inode to the inode free list.  The inode should
+ * already be truncated to 0 length and have no pages associated with it.  This
+ * routine also assumes that the inode is already a part of the transaction.
  *
- * The on-disk copy of the inode will have been added to the list
- * of unlinked inodes in the AGI. We need to remove the inode from
- * that list atomically with respect to freeing it here.
+ * The on-disk copy of the inode will have been added to the list of unlinked
+ * inodes in the AGI. We need to remove the inode from that list atomically with
+ * respect to freeing it here.
  */
 int
 xfs_ifree(
@@ -2306,13 +2305,16 @@ xfs_ifree(
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
 	/*
-	 * Pull the on-disk inode from the AGI unlinked list.
+	 * Free the inode first so that we guarantee that the AGI lock is going
+	 * to be taken before we remove the inode from the unlinked list. This
+	 * makes the AGI lock -> unlinked list modification order the same as
+	 * used in O_TMPFILE creation.
 	 */
-	error = xfs_iunlink_remove(tp, pag, ip);
+	error = xfs_difree(tp, pag, ip->i_ino, &xic);
 	if (error)
-		goto out;
+		return error;
 
-	error = xfs_difree(tp, pag, ip->i_ino, &xic);
+	error = xfs_iunlink_remove(tp, pag, ip);
 	if (error)
 		goto out;
 
