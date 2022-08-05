Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB32B58A5B8
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Aug 2022 07:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiHEFqL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Aug 2022 01:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiHEFqK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Aug 2022 01:46:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8064412A99
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 22:46:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05595611F0
        for <linux-xfs@vger.kernel.org>; Fri,  5 Aug 2022 05:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5016FC433D6;
        Fri,  5 Aug 2022 05:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659678367;
        bh=zrmR7+cQnH263Tf0dUDE1qXNKc/quzRVP+a5XW37Oqk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sGfMGYq9ti8BIfi9WwFV//WzIWAjmSe2ovxKjX8Ein0fSEmpz7UBBOflDLKK2zlLz
         hei9jLrcOkhP0RYsuKxeW73efOeCRJ+ZL87BpV53RKO/RQAN6P0+nrzJPHyvcZ1Aa1
         H2+R6T009yoopaR+mlh6m5ZmK0ZCbQQB2CUSV77k22Yd7CxnmZH6MZdesSpjrG/6rH
         urpi+3vHR4xJql+PzAzolBa3P7dtWIql42NwQbTFIb84mYT5ezDqQL2YJ+biWQPLxu
         KDtk+UJ4ayUaP3MDhJUVD8CR19UlYe5LUm9hIDXYmjTjP+C1C9WqsGca0ZWEOxx7Mk
         tir2PkDd+FSfg==
Date:   Thu, 4 Aug 2022 22:46:06 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix intermittent hang during quotacheck
Message-ID: <YuyunqW74KBGAu+i@magnolia>
References: <165963638241.1272632.9852314965190809423.stgit@magnolia>
 <165963639392.1272632.16910716528071046151.stgit@magnolia>
 <20220805015752.GF3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805015752.GF3600936@dread.disaster.area>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 05, 2022 at 11:57:52AM +1000, Dave Chinner wrote:
> On Thu, Aug 04, 2022 at 11:06:33AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Every now and then, I see the following hang during mount time
> > quotacheck when running fstests.  Turning on KASAN seems to make it
> > happen somewhat more frequently.  I've edited the backtrace for brevity.
> > 
> > XFS (sdd): Quotacheck needed: Please wait.
> > XFS: Assertion failed: bp->b_flags & _XBF_DELWRI_Q, file: fs/xfs/xfs_buf.c, line: 2411
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 1831409 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
> > CPU: 0 PID: 1831409 Comm: mount Tainted: G        W         5.19.0-rc6-xfsx #rc6 09911566947b9f737b036b4af85e399e4b9aef64
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
> > RIP: 0010:assfail+0x46/0x4a [xfs]
> > Code: a0 8f 41 a0 e8 45 fe ff ff 8a 1d 2c 36 10 00 80 fb 01 76 0f 0f b6 f3 48 c7 c7 c0 f0 4f a0 e8 10 f0 02 e1 80 e3 01 74 02 0f 0b <0f> 0b 5b c3 48 8d 45 10 48 89 e2 4c 89 e6 48 89 1c 24 48 89 44 24
> > RSP: 0018:ffffc900078c7b30 EFLAGS: 00010246
> > RAX: 0000000000000000 RBX: ffff8880099ac000 RCX: 000000007fffffff
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffa0418fa0
> > RBP: ffff8880197bc1c0 R08: 0000000000000000 R09: 000000000000000a
> > R10: 000000000000000a R11: f000000000000000 R12: ffffc900078c7d20
> > R13: 00000000fffffff5 R14: ffffc900078c7d20 R15: 0000000000000000
> > FS:  00007f0449903800(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00005610ada631f0 CR3: 0000000014dd8002 CR4: 00000000001706f0
> > Call Trace:
> >  <TASK>
> >  xfs_buf_delwri_pushbuf+0x150/0x160 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
> >  xfs_qm_flush_one+0xd6/0x130 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
> >  xfs_qm_dquot_walk.isra.0+0x109/0x1e0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
> >  xfs_qm_quotacheck+0x319/0x490 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
> >  xfs_qm_mount_quotas+0x65/0x2c0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
> >  xfs_mountfs+0x6b5/0xab0 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
> >  xfs_fs_fill_super+0x781/0x990 [xfs 4561f5b32c9bfb874ec98d58d0719464e1f87368]
> >  get_tree_bdev+0x175/0x280
> >  vfs_get_tree+0x1a/0x80
> >  path_mount+0x6f5/0xaa0
> >  __x64_sys_mount+0x103/0x140
> >  do_syscall_64+0x2b/0x80
> >  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > 
> > I /think/ this can happen if xfs_qm_flush_one is racing with
> > xfs_qm_dquot_isolate (i.e. dquot reclaim) when the second function has
> > taken the dquot flush lock but xfs_qm_dqflush hasn't yet locked the
> > dquot buffer, let alone queued it to the delwri list.  In this case,
> > flush_one will fail to get the dquot flush lock, but it can lock the
> > incore buffer, but xfs_buf_delwri_pushbuf will then trip over this
> > ASSERT, which checks that the buffer isn't on a delwri list.  The hang
> > results because the _delwri_submit_buffers ignores non DELWRI_Q buffers,
> > which means that xfs_buf_iowait waits forever for an IO that has not yet
> > been scheduled.
> 
> So gnarly.

Much hack.

> > AFAICT, a reasonable solution here is to detect a dquot buffer that is
> > not on a DELWRI list, drop it, and return -EAGAIN to try the flush
> > again.  It's not /that/ big of a deal if quotacheck writes the dquot
> > buffer repeatedly before we even set QUOTA_CHKD.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_qm.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index 57dd3b722265..95ea99070377 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -1234,6 +1234,11 @@ xfs_qm_flush_one(
> >  		if (error)
> >  			goto out_unlock;
> >  
> > +		if (!(bp->b_flags & _XBF_DELWRI_Q)) {
> > +			error = -EAGAIN;
> > +			xfs_buf_relse(bp);
> > +			goto out_unlock;
> > +		}
> >  		xfs_buf_unlock(bp);
> 
> Ugh. That's awful. It probably fixes the issue you see, but it
> doesn't fix the problems this code has. So from that perspective,
> consider this band-aid:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Heh, thanks for that, now I can let xfs-6.0-merge roll forward while we
figure out a better fix. :)

> Now, onto the real problem:
> 
> >  		xfs_buf_delwri_pushbuf(bp, buffer_list);
> 
> I don't think what xfs_buf_delwri_pushbuf() is doing is safe, It's
> removing the buffer from whatever dewlri list it is already on,
> whilst only holding the buffer lock. That's *not safe* as it's
> accessing and modifying buffers on the list that has a local stack
> context. It's modifying that local stack delwri list context from
> another task, and holding the buffer locked does not make that safe.
> 
> i.e. the only reason local stack contexts work without list locking
> or having to worry about whether the objects on the list are locked
> is that they are local and no other thread can access or modify
> objects them.

Hmmm.  I think you're right -- although we hold the buffer lock when
setting or clearing DELWRI_Q and updating b_list, there isn't any lock
on the two list heads that point at b_list.

Not to go too far down the rabbithole, but there's a related topic on
the horizon -- online repair uses delwri lists to write new btree
buffers to disk.  A few months ago I noticed that once in a while, the
new btree blocks didn't all get written before the new root was
committed via transaction.

It turned out that the new btree blocks were actually recently freed
metadata blocks.  The buffers were marked stale (DELWRI_Q was clear) but
were still sitting in the AIL's buffer list.  The btree bulk loading
code would try to xfs_buf_delwri_queue, which would re-set DELWRI_Q, but
because b_list was still linked into the AIL's list, the buffer would
not actually be put on xfs_btree_bload's buffer list.  Hence the
writeout would not be complete.

I fixed this (for now) by detecting this buffer state (no DELWRI_Q but
b_list points elsehwere) and cycling the buffer lock until that state
clears.  After that, we're free to set DELWRI_Q and put the buffer on
the bulk loader's list.  Does that sound like a reasonable use?

Hm, now that I think about xfs_btree_bload, I realize that it also pins
all the btree buffers in memory while it's loading the tree.  Maybe it
also needs to be able to dump buffers to disk in smaller batches?  Once
it puts a buffer on the delwri list, I don't think it ever dirties the
buffer again.

> IOWs, xfs_buf_delwri_pushbuf() can violate delwri list modification
> rules and holding the buffer lock does not actually make it safe. It
> relies on the caller to guarantee that the buffer is on a local
> list. I *think* the use in quotacheck only manipulates buffers on a
> local list, but the implementation of xfs_buf_delwri_pushbuf and at
> the caller do nothing to verify that it is safe.

I think so too.

> Regardless, this whole fragile construct looks completely
> unnecessary.  Consider the flush lock deadlock that
> xfs_buf_delwri_pushbuf() is avoiding:
> 
> commit 7912e7fef2aebe577f0b46d3cba261f2783c5695
> Author: Brian Foster <bfoster@redhat.com>
> Date:   Wed Jun 14 21:21:45 2017 -0700
> 
>     xfs: push buffer of flush locked dquot to avoid quotacheck deadlock
>     
>     Reclaim during quotacheck can lead to deadlocks on the dquot flush
>     lock:
>     
>      - Quotacheck populates a local delwri queue with the physical dquot
>        buffers.
>      - Quotacheck performs the xfs_qm_dqusage_adjust() bulkstat and
>        dirties all of the dquots.
>      - Reclaim kicks in and attempts to flush a dquot whose buffer is
>        already queud on the quotacheck queue. The flush succeeds but
>        queueing to the reclaim delwri queue fails as the backing buffer is
>        already queued. The flush unlock is now deferred to I/O completion
>        of the buffer from the quotacheck queue.
>      - The dqadjust bulkstat continues and dirties the recently flushed
>        dquot once again.
>      - Quotacheck proceeds to the xfs_qm_flush_one() walk which requires
>        the flush lock to update the backing buffers with the in-core
>        recalculated values. It deadlocks on the redirtied dquot as the
>        flush lock was already acquired by reclaim, but the buffer resides
>        on the local delwri queue which isn't submitted until the end of
>        quotacheck.
> 
> 
> Basically, the deadlock is:
> 
> quotacheck		 reclaim		bulkstat
> 
> zero dquots
>   lock buffer 1
>   zero dquots 1-32
>   delwri queue buffer 1
>     sets DELWRI_Q
>   unlock buffer 1
>   ....
>   			flush dquot 2
> 			  lock dquot 2
> 			  flush lock dquot 2
> 			  lock buffer 1
> 			  write dquot 2
> 			  delwri queue buffer 1
> 			    no-op as DELWRI_Q already set
> 			  unlock buffer 1
> 			  unlock dquot 2
> 			....
> 			<does not submit buffer 1>
> 							.....
> 							<dquot 2 is dirtied again>
> 							.....
> .....
> flush dquot 2
>   lock dquot 2
>   flush lock dquot 2
>   <blocks>
> 
> And this deadlocks because the only way to release the flush lock on
> dquot 2 is to write the buffer on the local buffer list already head
> by the quotacheck thread.
> 
> The fix that was made - xfs_buf_delwri_pushbuf() - adresses the fact
> that the queue is local to the current task, but the flush lock was
> set by a different task. The only way to address this is to submit
> the buffer list to clear the flush lock by IO completion before
> retrying the dquot flush from scratch.
> 
> However, this does not need to be done inside xfs_qm_flush_one() -
> it only needs to return -EAGAIN and have the high level walk code do
> the flush once per cache pass that sees an EAGAIN error. Hence
> xfs_buf_delwri_pushbuf() is not necessary at all.
> 
> However, even doing this doesn't address the root cause of the
> problem - it ignores why the race condition exists in the first
> place.
> 
> That is, quotacheck tries to optimise the dquot buffer writing code
> down to a single disk write for every dquot. It first zeros all the
> dquots by accessing the buffers directly, pinning them in memory via
> the delwri list. It then runs a bulkstat of the filesystem runs to
> updates the in-memory dquots (not the on disk dquots that are
> pinning in memory).  Then once that is done, it
> flushes the in memory dquots to the buffers via a dquot cache walk
> and writes them back.
> 
> Which seems like a decent enough optimisation, but it ignores the
> fact that when we have millions of inodes, the bulkstat to update
> the in memory dquots can do millions of IO and generate many
> gigabytes of memory pressure. dquot buffer writeback is essentially
> sequential IO due to delwri list sorting and block layer bio
> merging, so even with tens of thousands of dquots, the amount of IO
> to write these back multiple times is miniscule compared to the
> amount of IO the bulkstat to update the dquots has generated.

[At this point I wondered if we could perhaps just use online fsck's
version of quotacheck, which runs concurrently with the system and is
not so resource intensive.  But it's less efficient because it deals
only with xfs_dquots, not the dquot buffers.  One potential advantage is
that it doesn't need to block mount() from finishing, but then that
could expose wrong quota counts to users.]

> IOWs, it's an optimisation that might save a few IOs and be
> measurable on small filesystems, but when we scale up the IO
> optimisation is completely lost in the noise of walking the inodes.
> 
> Given that this IO optimisation is the root of the race condition
> that causes the delwri queue writeback deadlocks and problems, let's
> just get rid of it. Submit the buffer list once all the dquots are
> zeroed, and that unpins them all and clears all the existing dquot
> state on disk. Now the inode walk can run and dirty dquots can be
> flushed and reclaimed by memory reclaimed as per normal runtime
> behaviour, and the final writeback of all the dirty dquots doesn't
> need to care that memory reclaim might have flush locked some of the
> dquots and not been able to write them back....

Aha, and now I remembered something -- at one point I enabled the online
fsck stress tests to set random [ugp]ids without restricting the range
of quota ids.  It proceeded with the entire 32-bit id space, and a
quotacheck running after the test would OOM the box.  This might help
with that, if I can remember the magic incantation to reproduce that.

> Untested patch below that does this....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> 
> xfs: xfs_buf_delwri_pushbuf is unnecessary
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> The deadlock it attempts to work around is avoided simply by not
> attempting to pin dquot buffers in a delwri queue to prevent them
> from being written back for the entire quotacheck process. This
> allows memory reclaim to write back dirty dquots and reclaim them if
> we run low on memory during quotacheck, and it greatly reduces the
> minimum amount of memory needed to run a quotacheck.
> 
> Further, by removing the dquot flush race conditions with memory
> reclaim, we no longer need to use xfs_dqflock_nowait() in
> xfs_qm_flush_one() and flush the delwri queue to avoid deadlocks.
> Instead, just convert xfs_qm_dquot_walk() to submit the buffer list
> if any attempt to flush a buffer failed with EAGAIN before it tries
> to flush the dirty dquots again.
> 
> Fixes: 7912e7fef2ae ("xfs: push buffer of flush locked dquot to avoid quotacheck deadlock")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 55 --------------------------------------------------
>  fs/xfs/xfs_buf.h |  1 -
>  fs/xfs/xfs_qm.c  | 61 +++++++++++++++++++++++++++-----------------------------
>  3 files changed, 29 insertions(+), 88 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 56b3e9607b17..9822b92c13fc 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -2251,61 +2251,6 @@ xfs_buf_delwri_submit(
>  	return error;
>  }
>  
> -/*
> - * Push a single buffer on a delwri queue.
> - *
> - * The purpose of this function is to submit a single buffer of a delwri queue
> - * and return with the buffer still on the original queue. The waiting delwri
> - * buffer submission infrastructure guarantees transfer of the delwri queue
> - * buffer reference to a temporary wait list. We reuse this infrastructure to
> - * transfer the buffer back to the original queue.
> - *
> - * Note the buffer transitions from the queued state, to the submitted and wait
> - * listed state and back to the queued state during this call. The buffer
> - * locking and queue management logic between _delwri_pushbuf() and
> - * _delwri_queue() guarantee that the buffer cannot be queued to another list
> - * before returning.
> - */
> -int
> -xfs_buf_delwri_pushbuf(
> -	struct xfs_buf		*bp,
> -	struct list_head	*buffer_list)
> -{
> -	LIST_HEAD		(submit_list);
> -	int			error;
> -
> -	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
> -
> -	trace_xfs_buf_delwri_pushbuf(bp, _RET_IP_);
> -
> -	/*
> -	 * Isolate the buffer to a new local list so we can submit it for I/O
> -	 * independently from the rest of the original list.
> -	 */
> -	xfs_buf_lock(bp);
> -	list_move(&bp->b_list, &submit_list);
> -	xfs_buf_unlock(bp);
> -
> -	/*
> -	 * Delwri submission clears the DELWRI_Q buffer flag and returns with
> -	 * the buffer on the wait list with the original reference. Rather than
> -	 * bounce the buffer from a local wait list back to the original list
> -	 * after I/O completion, reuse the original list as the wait list.
> -	 */
> -	xfs_buf_delwri_submit_buffers(&submit_list, buffer_list);
> -
> -	/*
> -	 * The buffer is now locked, under I/O and wait listed on the original
> -	 * delwri queue. Wait for I/O completion, restore the DELWRI_Q flag and
> -	 * return with the buffer unlocked and on the original queue.
> -	 */
> -	error = xfs_buf_iowait(bp);
> -	bp->b_flags |= _XBF_DELWRI_Q;
> -	xfs_buf_unlock(bp);
> -
> -	return error;
> -}
> -
>  void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
>  {
>  	/*
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 0989dc9ebe7e..a3762ec4acfc 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -308,7 +308,6 @@ extern void xfs_buf_delwri_cancel(struct list_head *);
>  extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
>  extern int xfs_buf_delwri_submit(struct list_head *);
>  extern int xfs_buf_delwri_submit_nowait(struct list_head *);
> -extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);
>  
>  static inline xfs_daddr_t xfs_buf_daddr(struct xfs_buf *bp)
>  {
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 57dd3b722265..7e7465bb867e 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -51,13 +51,15 @@ STATIC int
>  xfs_qm_dquot_walk(
>  	struct xfs_mount	*mp,
>  	xfs_dqtype_t		type,
> -	int			(*execute)(struct xfs_dquot *dqp, void *data),
> -	void			*data)
> +	int			(*execute)(struct xfs_dquot *dqp,
> +					struct list_head *buffer_list),
> +	struct list_head	*buffer_list)
>  {
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
>  	struct radix_tree_root	*tree = xfs_dquot_tree(qi, type);
>  	uint32_t		next_index;
>  	int			last_error = 0;
> +	int			error;
>  	int			skipped;
>  	int			nr_found;
>  
> @@ -68,7 +70,6 @@ xfs_qm_dquot_walk(
>  
>  	while (1) {
>  		struct xfs_dquot *batch[XFS_DQ_LOOKUP_BATCH];
> -		int		error = 0;
>  		int		i;
>  
>  		mutex_lock(&qi->qi_tree_lock);
> @@ -84,7 +85,7 @@ xfs_qm_dquot_walk(
>  
>  			next_index = dqp->q_id + 1;
>  
> -			error = execute(batch[i], data);
> +			error = execute(batch[i], buffer_list);
>  			if (error == -EAGAIN) {
>  				skipped++;
>  				continue;
> @@ -106,6 +107,16 @@ xfs_qm_dquot_walk(
>  	}
>  
>  	if (skipped) {
> +		/*
> +		 * If there were dquots we couldn't flush because we couldn't
> +		 * lock the dquot buffer, submit all the buffers we were able to
> +		 * flush dquots to and then try again.
> +		 */
> +		if (buffer_list) {
> +			error = xfs_buf_delwri_submit(buffer_list);
> +			if (error)
> +				return error;
> +		}

This looks pretty reasonable to me.

>  		delay(1);
>  		goto restart;
>  	}
> @@ -120,7 +131,7 @@ xfs_qm_dquot_walk(
>  STATIC int
>  xfs_qm_dqpurge(
>  	struct xfs_dquot	*dqp,
> -	void			*data)
> +	struct list_head	*unused)
>  {
>  	struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
>  	int			error = -EAGAIN;
> @@ -1206,10 +1217,8 @@ xfs_qm_dqusage_adjust(
>  STATIC int
>  xfs_qm_flush_one(
>  	struct xfs_dquot	*dqp,
> -	void			*data)
> +	struct list_head	*buffer_list)
>  {
> -	struct xfs_mount	*mp = dqp->q_mount;
> -	struct list_head	*buffer_list = data;
>  	struct xfs_buf		*bp = NULL;
>  	int			error = 0;
>  
> @@ -1219,30 +1228,7 @@ xfs_qm_flush_one(
>  	if (!XFS_DQ_IS_DIRTY(dqp))
>  		goto out_unlock;
>  
> -	/*
> -	 * The only way the dquot is already flush locked by the time quotacheck
> -	 * gets here is if reclaim flushed it before the dqadjust walk dirtied
> -	 * it for the final time. Quotacheck collects all dquot bufs in the
> -	 * local delwri queue before dquots are dirtied, so reclaim can't have
> -	 * possibly queued it for I/O. The only way out is to push the buffer to
> -	 * cycle the flush lock.
> -	 */
> -	if (!xfs_dqflock_nowait(dqp)) {
> -		/* buf is pinned in-core by delwri list */
> -		error = xfs_buf_incore(mp->m_ddev_targp, dqp->q_blkno,
> -				mp->m_quotainfo->qi_dqchunklen, 0, &bp);
> -		if (error)
> -			goto out_unlock;
> -
> -		xfs_buf_unlock(bp);
> -
> -		xfs_buf_delwri_pushbuf(bp, buffer_list);
> -		xfs_buf_rele(bp);
> -
> -		error = -EAGAIN;
> -		goto out_unlock;
> -	}
-
> +	xfs_dqflock(dqp);
>  	error = xfs_qm_dqflush(dqp, &bp);
>  	if (error)
>  		goto out_unlock;
> @@ -1305,6 +1291,17 @@ xfs_qm_quotacheck(
>  		flags |= XFS_PQUOTA_CHKD;
>  	}
>  
> +	/*
> +	 * Write back all the zeroed buffers now so that they aren't pinned in
> +	 * memory by the delwri list. Holding them pinned while walking the
> +	 * inodes to update in memory dquots opens us up to races with memory
> +	 * reclaim attempting to flush dirty dquots, and actually prevents
> +	 * memory reclaim from bein able to reclaim dirty dquots at all.
> +	 */
> +	error = xfs_buf_delwri_submit(&buffer_list);

Summarizing what we chatted about on IRC:

Why do we wait until after all three xfs_qm_reset_dqcounts_buf calls to
submit the delwri list?  Doesn't that pin /every/ dquot buffer in
memory?  If the system actually has all 4.3 billion dquots defined, then
we can end up pinning ~570MB of memory per quota type, or ~1800M of
buffers in memory.

Maybe we ought to promote delwri lists to an explicit type instead of
passing around list_heads?

struct xfs_buf_delwri_list {
	struct list_head	list;
	unsigned int		nr_bufs;
};

So that we can submit the list (and unpin the buffers) every 10000 items
or so?

Maybe the quot flush locking ought to be straightened out a bit like we
did for inodes?  i.e. pin the dquot buffer when the dquot gets dirtied,
and then flushing will lock the buffer, the dquot, and finally the
dqf(lush)?

--D

> +	if (error)
> +		goto error_return;
> +
>  	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
>  			NULL);
>  	if (error) {
