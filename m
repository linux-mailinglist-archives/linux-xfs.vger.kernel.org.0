Return-Path: <linux-xfs+bounces-23497-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C12AE9C83
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Jun 2025 13:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 536BC3A8CAD
	for <lists+linux-xfs@lfdr.de>; Thu, 26 Jun 2025 11:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0022262D14;
	Thu, 26 Jun 2025 11:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b5NkXjYM"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9B51F2BAD
	for <linux-xfs@vger.kernel.org>; Thu, 26 Jun 2025 11:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750937366; cv=none; b=cxpYQjXqBcBSVbS+KX/Hh14tf5q1vpAA+bGW1yaSEOOXBdnlVKewvF0PhfOxwtJs8g07oRTAMRovacPNavj+JcUAhTtlvAuw1MtAaxwyvHNaxHtinN7cr4TpQKJq27af5XY+B4ckI7cpFrPhNGIKiNzsYusBOadHVKx1XVf1qgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750937366; c=relaxed/simple;
	bh=bqyFCyajd4uJ0iA93MG1VG+gRypDP1NR7CFH7eKeQoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WEtWeFB2CHrxQdk04Q1qAkD873PW1NbHSLpQNbv7k/yrmOS3gxH6rwdYwOAGt3URedYtti/mYxTLrP3UL9xx1IA+modAf2Ijaxxs3ok4ckxCvhHPLYsVwjQrpIwyJHJpqBz3vxoV+lYQSCCoo/9v4XoDeyv+OkzyNEGo/7GOJqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b5NkXjYM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F842C4CEEB;
	Thu, 26 Jun 2025 11:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750937366;
	bh=bqyFCyajd4uJ0iA93MG1VG+gRypDP1NR7CFH7eKeQoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b5NkXjYMioFfk6UpWX18o4VN4ayQsCmjYyl1I1JJfjkszBHPgU/YvlQ1G9T4r1Tk4
	 chKQRDKSAfsVfkPuYZTwlDKE7iuBiNBdaI2irr4Z5YyUmaeD08cV4Qe6AjY4T4XqIP
	 ZMp20GfVkDPssuiMPbtJq+DycSnWy/SYTzuaRYiLnSNWJSQhoby70UGG7JLws5rAUg
	 ncDtF5NTOUhFXyb3d/A2sBkqmkEtsBJryHjY1lmrtUFfcOdjLEyaK1MZbR2TmtXHAS
	 U+P0nQTowSZlFsFF7NuZEH1jZUl5rodD/+eXaAIZn5VS/iJXuyYxW8kNdu+uDCk5ZB
	 S7cAXJQWUu6JA==
Date: Thu, 26 Jun 2025 13:29:22 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: avoid dquot buffer pin deadlock
Message-ID: <v55dhlk4eqlidzakmswvkawbashajq5c44p5jwnqilzlu4pk23@sf25o33mmhfr>
References: <20250625224957.1436116-1-david@fromorbit.com>
 <faC6k50YYTe5R7SprSEy_w17O9hiMJNQex54OZi9G2MGKhdpEZKQBVigiwYL6dV0Kuy2Xhc5pyf4AVpbSglZGw==@protonmail.internalid>
 <20250625224957.1436116-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625224957.1436116-4-david@fromorbit.com>

On Thu, Jun 26, 2025 at 08:48:56AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On shutdown when quotas are enabled, the shutdown can deadlock
> trying to unpin the dquot buffer buf_log_item like so:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> [ 3319.483590] task:kworker/20:0H   state:D stack:14360 pid:1962230 tgid:1962230 ppid:2      task_flags:0x4208060 flags:0x00004000
> [ 3319.493966] Workqueue: xfs-log/dm-6 xlog_ioend_work
> [ 3319.498458] Call Trace:
> [ 3319.500800]  <TASK>
> [ 3319.502809]  __schedule+0x699/0xb70
> [ 3319.512672]  schedule+0x64/0xd0
> [ 3319.515573]  schedule_timeout+0x30/0xf0
> [ 3319.528125]  __down_common+0xc3/0x200
> [ 3319.531488]  __down+0x1d/0x30
> [ 3319.534186]  down+0x48/0x50
> [ 3319.540501]  xfs_buf_lock+0x3d/0xe0
> [ 3319.543609]  xfs_buf_item_unpin+0x85/0x1b0
> [ 3319.547248]  xlog_cil_committed+0x289/0x570
> [ 3319.571411]  xlog_cil_process_committed+0x6d/0x90
> [ 3319.575590]  xlog_state_shutdown_callbacks+0x52/0x110
> [ 3319.580017]  xlog_force_shutdown+0x169/0x1a0
> [ 3319.583780]  xlog_ioend_work+0x7c/0xb0
> [ 3319.587049]  process_scheduled_works+0x1d6/0x400
> [ 3319.591127]  worker_thread+0x202/0x2e0
> [ 3319.594452]  kthread+0x20c/0x240
> 
> The CIL push has seen the deadlock, so it has aborted the push and
> is running CIL checkpoint completion to abort all the items in the
> checkpoint. This calls ->iop_unpin(remove = true) to clean up the
> log items in the checkpoint.
> 
> When a buffer log item is unpined like this, it needs to lock the
> buffer to run io completion to correctly fail the buffer and run all
> the required completions to fail attached log items as well. In this
> case, the attempt to lock the buffer on unpin is hanging because the
> buffer is already locked.
> 
> I suspected a leaked XFS_BLI_HOLD state because of XFS_BLI_STALE
> handling changes I was testing, so I went looking for
> pin events on HOLD buffers and unpin events on locked buffer. That
> isolated this one buffer with these two events:
> 
> xfs_buf_item_pin:     dev 251:6 daddr 0xa910 bbcount 0x2 hold 2 pincount 0 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags HOLD|DIRTY|LOGGED liflags DIRTY
> ....
> xfs_buf_item_unpin:   dev 251:6 daddr 0xa910 bbcount 0x2 hold 4 pincount 1 lock 0 flags DONE|KMEM recur 0 refcount 1 bliflags DIRTY liflags ABORTED
> 
> Firstly, bbcount = 0x2, which means it is not a single sector
> structure. That rules out every xfs_trans_bhold() case except one:
> dquot buffers.
> 
> Then hung task dumping gave this trace:
> 
> [ 3197.312078] task:fsync-tester    state:D stack:12080 pid:2051125 tgid:2051125 ppid:1643233 task_flags:0x400000 flags:0x00004002
> [ 3197.323007] Call Trace:
> [ 3197.325581]  <TASK>
> [ 3197.327727]  __schedule+0x699/0xb70
> [ 3197.334582]  schedule+0x64/0xd0
> [ 3197.337672]  schedule_timeout+0x30/0xf0
> [ 3197.350139]  wait_for_completion+0xbd/0x180
> [ 3197.354235]  __flush_workqueue+0xef/0x4e0
> [ 3197.362229]  xlog_cil_force_seq+0xa0/0x300
> [ 3197.374447]  xfs_log_force+0x77/0x230
> [ 3197.378015]  xfs_qm_dqunpin_wait+0x49/0xf0
> [ 3197.382010]  xfs_qm_dqflush+0x55/0x460
> [ 3197.385663]  xfs_qm_dquot_isolate+0x29e/0x4d0
> [ 3197.389977]  __list_lru_walk_one+0x141/0x220
> [ 3197.398867]  list_lru_walk_one+0x10/0x20
> [ 3197.402713]  xfs_qm_shrink_scan+0x6a/0x100
> [ 3197.406699]  do_shrink_slab+0x18a/0x350
> [ 3197.410512]  shrink_slab+0xf7/0x430
> [ 3197.413967]  drop_slab+0x97/0xf0
> [ 3197.417121]  drop_caches_sysctl_handler+0x59/0xc0
> [ 3197.421654]  proc_sys_call_handler+0x18b/0x280
> [ 3197.426050]  proc_sys_write+0x13/0x20
> [ 3197.429750]  vfs_write+0x2b8/0x3e0
> [ 3197.438532]  ksys_write+0x7e/0xf0
> [ 3197.441742]  __x64_sys_write+0x1b/0x30
> [ 3197.445363]  x64_sys_call+0x2c72/0x2f60
> [ 3197.449044]  do_syscall_64+0x6c/0x140
> [ 3197.456341]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Yup, another test run by check-parallel is running drop_caches
> concurrently and the dquot shrinker for the hung filesystem is
> running. That's trying to flush a dirty dquot from reclaim context,
> and it waiting on a log force to complete. xfs_qm_dqflush is called
> with the dquot buffer held locked, and so we've called
> xfs_log_force() with that buffer locked.
> 
> Now the log force is waiting for a workqueue flush to complete, and
> that workqueue flush is waiting of CIL checkpoint processing to
> finish.
> 
> The CIL checkpoint processing is aborting all the log items it has,
> and that requires locking aborted buffers to cancel them.
> 
> Now, normally this isn't a problem if we are issuing a log force
> to unpin an object, because the ->iop_unpin() method wakes pin
> waiters first. That results in the pin waiter finishing off whatever
> it was doing, dropping the lock and then xfs_buf_item_unpin() can
> lock the buffer and fail it.
> 
> However, xfs_qm_dqflush() is waiting on the -dquot- unpin event, not
> the dquot buffer unpin event, and so it never gets woken and so does
> not drop the buffer lock.
> 
> Inodes do not have this problem, as they can only be written from
> one spot (->iop_push) whilst dquots can be written from multiple
> places (memory reclaim, ->iop_push, xfs_dq_dqpurge, and quotacheck).
> 
> The reason that the dquot buffer has an attached buffer log item is
> that it has been recently allocated. Initialisation of the dquot
> buffer logs the buffer directly, thereby pinning it in memory. We
> then modify the dquot in a separate operation, and have memory
> reclaim racing with a shutdown and we trigger this deadlock.
> 
> check-parallel reproduces this reliably on 1kB FSB filesystems with
> quota enabled because it does all of these things concurrently
> without having to explicitly write tests to exercise these corner
> case conditions.
> 
> xfs_qm_dquot_logitem_push() doesn't have this deadlock because it
> checks if the dquot is pinned before locking the dquot buffer and
> skipping it if it is pinned. This means the xfs_qm_dqunpin_wait()
> log force in xfs_qm_dqflush() never triggers and we unlock the
> buffer safely allowing a concurrent shutdown to fail the buffer
> appropriately.
> 
> xfs_qm_dqpurge() could have this problem as it is called from
> quotacheck and we might have allocated dquot buffers when recording
> the quota updates. This can be fixed by calling
> xfs_qm_dqunpin_wait() before we lock the dquot buffer. Because we
> hold the dquot locked, nothing will be able to add to the pin count
> between the unpin_wait and the dqflush callout, so this now makes
> xfs_qm_dqpurge() safe against this race.
> 
> xfs_qm_dquot_isolate() can also be fixed this same way but, quite
> frankly, we shouldn't be doing IO in memory reclaim context. If the
> dquot is pinned or dirty, simply rotate it and let memory reclaim
> come back to it later, same as we do for inodes.
> 
> This then gets rid of the nasty issue in xfs_qm_flush_one() where
> quotacheck writeback races with memory reclaim flushing the dquots.
> We can lift xfs_qm_dqunpin_wait() up into this code, then get rid of
> the "can't get the dqflush lock" buffer write to cycle the dqlfush
> lock and enable it to be flushed again.  checking if the dquot is
> pinned and returning -EAGAIN so that the dquot walk will revisit the
> dquot again later.
> 
> Finally, with xfs_qm_dqunpin_wait() lifted into all the callers,
> we can remove it from the xfs_qm_dqflush() code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c   | 38 --------------------
>  fs/xfs/xfs_buf.h   |  1 -
>  fs/xfs/xfs_dquot.c |  4 +--
>  fs/xfs/xfs_qm.c    | 86 ++++++++++------------------------------------
>  fs/xfs/xfs_trace.h |  1 -
>  5 files changed, 20 insertions(+), 110 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 8af83bd161f9..ba5bd6031ece 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -2082,44 +2082,6 @@ xfs_buf_delwri_submit(
>  	return error;
>  }
> 
> -/*
> - * Push a single buffer on a delwri queue.
> - *
> - * The purpose of this function is to submit a single buffer of a delwri queue
> - * and return with the buffer still on the original queue.
> - *
> - * The buffer locking and queue management logic between _delwri_pushbuf() and
> - * _delwri_queue() guarantee that the buffer cannot be queued to another list
> - * before returning.
> - */
> -int
> -xfs_buf_delwri_pushbuf(
> -	struct xfs_buf		*bp,
> -	struct list_head	*buffer_list)
> -{
> -	int			error;
> -
> -	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
> -
> -	trace_xfs_buf_delwri_pushbuf(bp, _RET_IP_);
> -
> -	xfs_buf_lock(bp);
> -	bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_ASYNC);
> -	bp->b_flags |= XBF_WRITE;
> -	xfs_buf_submit(bp);
> -
> -	/*
> -	 * The buffer is now locked, under I/O but still on the original delwri
> -	 * queue. Wait for I/O completion, restore the DELWRI_Q flag and
> -	 * return with the buffer unlocked and still on the original queue.
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
> index 9d2ab567cf81..15fc56948346 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -326,7 +326,6 @@ extern bool xfs_buf_delwri_queue(struct xfs_buf *, struct list_head *);
>  void xfs_buf_delwri_queue_here(struct xfs_buf *bp, struct list_head *bl);
>  extern int xfs_buf_delwri_submit(struct list_head *);
>  extern int xfs_buf_delwri_submit_nowait(struct list_head *);
> -extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);
> 
>  static inline xfs_daddr_t xfs_buf_daddr(struct xfs_buf *bp)
>  {
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index b4e32f0860b7..0bd8022e47b4 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1398,11 +1398,9 @@ xfs_qm_dqflush(
> 
>  	ASSERT(XFS_DQ_IS_LOCKED(dqp));
>  	ASSERT(!completion_done(&dqp->q_flush));
> +	ASSERT(atomic_read(&dqp->q_pincount) == 0);
> 
>  	trace_xfs_dqflush(dqp);
> -
> -	xfs_qm_dqunpin_wait(dqp);
> -
>  	fa = xfs_qm_dqflush_check(dqp);
>  	if (fa) {
>  		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 417439b58785..fa135ac26471 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -134,6 +134,7 @@ xfs_qm_dqpurge(
> 
>  	dqp->q_flags |= XFS_DQFLAG_FREEING;
> 
> +	xfs_qm_dqunpin_wait(dqp);
>  	xfs_dqflock(dqp);
> 
>  	/*
> @@ -465,6 +466,7 @@ xfs_qm_dquot_isolate(
>  	struct xfs_dquot	*dqp = container_of(item,
>  						struct xfs_dquot, q_lru);
>  	struct xfs_qm_isolate	*isol = arg;
> +	enum lru_status		ret = LRU_SKIP;
> 
>  	if (!xfs_dqlock_nowait(dqp))
>  		goto out_miss_busy;
> @@ -477,6 +479,16 @@ xfs_qm_dquot_isolate(
>  	if (dqp->q_flags & XFS_DQFLAG_FREEING)
>  		goto out_miss_unlock;
> 
> +	/*
> +	 * If the dquot is pinned or dirty, rotate it to the end of the LRU to
> +	 * give some time for it to be cleaned before we try to isolate it
> +	 * again.
> +	 */
> +	ret = LRU_ROTATE;
> +	if (XFS_DQ_IS_DIRTY(dqp) || atomic_read(&dqp->q_pincount) > 0) {
> +		goto out_miss_unlock;
> +	}
> +
>  	/*
>  	 * This dquot has acquired a reference in the meantime remove it from
>  	 * the freelist and try again.
> @@ -492,41 +504,14 @@ xfs_qm_dquot_isolate(
>  	}
> 
>  	/*
> -	 * If the dquot is dirty, flush it. If it's already being flushed, just
> -	 * skip it so there is time for the IO to complete before we try to
> -	 * reclaim it again on the next LRU pass.
> +	 * The dquot may still be under IO, in which case the flush lock will be
> +	 * held. If we can't get the flush lock now, just skip over the dquot as
> +	 * if it was dirty.
>  	 */
>  	if (!xfs_dqflock_nowait(dqp))
>  		goto out_miss_unlock;
> 
> -	if (XFS_DQ_IS_DIRTY(dqp)) {
> -		struct xfs_buf	*bp = NULL;
> -		int		error;
> -
> -		trace_xfs_dqreclaim_dirty(dqp);
> -
> -		/* we have to drop the LRU lock to flush the dquot */
> -		spin_unlock(&lru->lock);
> -
> -		error = xfs_dquot_use_attached_buf(dqp, &bp);
> -		if (!bp || error == -EAGAIN) {
> -			xfs_dqfunlock(dqp);
> -			goto out_unlock_dirty;
> -		}
> -
> -		/*
> -		 * dqflush completes dqflock on error, and the delwri ioend
> -		 * does it on success.
> -		 */
> -		error = xfs_qm_dqflush(dqp, bp);
> -		if (error)
> -			goto out_unlock_dirty;
> -
> -		xfs_buf_delwri_queue(bp, &isol->buffers);
> -		xfs_buf_relse(bp);
> -		goto out_unlock_dirty;
> -	}
> -
> +	ASSERT(!XFS_DQ_IS_DIRTY(dqp));
>  	xfs_dquot_detach_buf(dqp);
>  	xfs_dqfunlock(dqp);
> 
> @@ -548,13 +533,7 @@ xfs_qm_dquot_isolate(
>  out_miss_busy:
>  	trace_xfs_dqreclaim_busy(dqp);
>  	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
> -	return LRU_SKIP;
> -
> -out_unlock_dirty:
> -	trace_xfs_dqreclaim_busy(dqp);
> -	XFS_STATS_INC(dqp->q_mount, xs_qm_dqreclaim_misses);
> -	xfs_dqunlock(dqp);
> -	return LRU_RETRY;
> +	return ret;
>  }
> 
>  static unsigned long
> @@ -1486,7 +1465,6 @@ xfs_qm_flush_one(
>  	struct xfs_dquot	*dqp,
>  	void			*data)
>  {
> -	struct xfs_mount	*mp = dqp->q_mount;
>  	struct list_head	*buffer_list = data;
>  	struct xfs_buf		*bp = NULL;
>  	int			error = 0;
> @@ -1497,34 +1475,8 @@ xfs_qm_flush_one(
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
> -		if (!(bp->b_flags & _XBF_DELWRI_Q)) {
> -			error = -EAGAIN;
> -			xfs_buf_relse(bp);
> -			goto out_unlock;
> -		}
> -		xfs_buf_unlock(bp);
> -
> -		xfs_buf_delwri_pushbuf(bp, buffer_list);
> -		xfs_buf_rele(bp);
> -
> -		error = -EAGAIN;
> -		goto out_unlock;
> -	}
> +	xfs_qm_dqunpin_wait(dqp);
> +	xfs_dqflock(dqp);
> 
>  	error = xfs_dquot_use_attached_buf(dqp, &bp);
>  	if (error)
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 01d284a1c759..9f0d6bc966b7 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -778,7 +778,6 @@ DEFINE_BUF_EVENT(xfs_buf_iowait_done);
>  DEFINE_BUF_EVENT(xfs_buf_delwri_queue);
>  DEFINE_BUF_EVENT(xfs_buf_delwri_queued);
>  DEFINE_BUF_EVENT(xfs_buf_delwri_split);
> -DEFINE_BUF_EVENT(xfs_buf_delwri_pushbuf);
>  DEFINE_BUF_EVENT(xfs_buf_get_uncached);
>  DEFINE_BUF_EVENT(xfs_buf_item_relse);
>  DEFINE_BUF_EVENT(xfs_buf_iodone_async);
> --
> 2.45.2


