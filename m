Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C2059C4AD
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Aug 2022 19:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbiHVRJD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Aug 2022 13:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235947AbiHVRIm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 13:08:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1753443E65
        for <linux-xfs@vger.kernel.org>; Mon, 22 Aug 2022 10:08:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CA7861229
        for <linux-xfs@vger.kernel.org>; Mon, 22 Aug 2022 17:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687A9C433C1;
        Mon, 22 Aug 2022 17:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661188085;
        bh=ETpUm2nIGTBqCZMsuYV879/iifadXGlFU7vK5ZZbt8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bjxCliWEovV2ny49OkhKFWCQlbQPhaGlD749qXUgPrgohmjcPkVWKAOR1iv2rOWLx
         Dij4PwiH/KyjeF8S69RB6XfJc/v1SMV2O+CL1EeTdvtWKsDvHjYCJhuO2w9d9Vl1c4
         Hpu9yrbcBC2HZhs5QBorM81YIhXOn8ygsmpgL4HawKmI9j0KvI0H4SnRobe20KOOAr
         uiiDLhCkppcKhg0Joiwxtvtqc0W9bHnHebL0Hg4YLUsNYrdUyoAT3F5o9qEYcucwO0
         t36P3F+GrCgPfPfMuFW0N7iUquT3JVAczqZtH0+wtZZtFviNGIRPyt5/sTZXMrlfAZ
         LxMKaEKVK8raQ==
Date:   Mon, 22 Aug 2022 10:08:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: AIL doesn't need manual pushing
Message-ID: <YwO39Kp9QUBBoeaF@magnolia>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809230353.3353059-3-david@fromorbit.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 10, 2022 at 09:03:46AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We have a mechanism that checks the amount of log space remaining
> available every time we make a transaction reservation. If the
> amount of space is below a threshold (25% free) we push on the AIL
> to tell it to do more work. To do this, we end up calculating the
> LSN that the AIL needs to push to on every reservation and updating
> the push target for the AIL with that new target LSN.
> 
> This is silly and expensive. The AIL is perfectly capable of
> calculating the push target itself, and it will always be running
> when the AIL contains objects.
> 
> Modify the AIL to calculate it's 25% push target before it starts a
> push using the same reserve grant head based calculation as is
> currently used, and remove all the places where we ask the AIL to
> push to a new 25% free target.
> 
> This does still require a manual push in certain circumstances.
> These circumstances arise when the AIL is not full, but the
> reservation grants consume the entire of the free space in the log.
> In this case, we still need to push on the AIL to free up space, so
> when we hit this condition (i.e. reservation going to sleep to wait
> on log space) we do a single push to tell the AIL it should empty
> itself. This will keep the AIL moving as new reservations come in
> and want more space, rather than keep queuing them and having to
> push the AIL repeatedly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c |   4 +-
>  fs/xfs/xfs_log.c          | 135 ++-----------------------------
>  fs/xfs/xfs_log.h          |   1 -
>  fs/xfs/xfs_log_priv.h     |   2 +
>  fs/xfs/xfs_trans_ail.c    | 165 +++++++++++++++++---------------------
>  fs/xfs/xfs_trans_priv.h   |  33 ++++++--
>  6 files changed, 110 insertions(+), 230 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 5a321b783398..79c077078785 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -12,12 +12,14 @@
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
>  #include "xfs_trans.h"
> +#include "xfs_trans_priv.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_inode.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
>  #include "xfs_log.h"
> +#include "xfs_log_priv.h"
>  #include "xfs_rmap.h"
>  #include "xfs_refcount.h"
>  #include "xfs_bmap.h"
> @@ -439,7 +441,7 @@ xfs_defer_relog(
>  		 * the log threshold once per call.
>  		 */
>  		if (threshold_lsn == NULLCOMMITLSN) {
> -			threshold_lsn = xlog_grant_push_threshold(log, 0);
> +			threshold_lsn = xfs_ail_push_target(log->l_ailp);
>  			if (threshold_lsn == NULLCOMMITLSN)
>  				break;
>  		}
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 4b1c0a9c6368..c609c188bd8a 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -30,10 +30,6 @@ xlog_alloc_log(
>  	struct xfs_buftarg	*log_target,
>  	xfs_daddr_t		blk_offset,
>  	int			num_bblks);
> -STATIC int
> -xlog_space_left(
> -	struct xlog		*log,
> -	atomic64_t		*head);
>  STATIC void
>  xlog_dealloc_log(
>  	struct xlog		*log);
> @@ -51,10 +47,6 @@ xlog_state_get_iclog_space(
>  	struct xlog_ticket	*ticket,
>  	int			*logoffsetp);
>  STATIC void
> -xlog_grant_push_ail(
> -	struct xlog		*log,
> -	int			need_bytes);
> -STATIC void
>  xlog_sync(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog,
> @@ -242,42 +234,15 @@ xlog_grant_head_wake(
>  {
>  	struct xlog_ticket	*tic;
>  	int			need_bytes;
> -	bool			woken_task = false;
>  
>  	list_for_each_entry(tic, &head->waiters, t_queue) {
> -
> -		/*
> -		 * There is a chance that the size of the CIL checkpoints in
> -		 * progress at the last AIL push target calculation resulted in
> -		 * limiting the target to the log head (l_last_sync_lsn) at the
> -		 * time. This may not reflect where the log head is now as the
> -		 * CIL checkpoints may have completed.
> -		 *
> -		 * Hence when we are woken here, it may be that the head of the
> -		 * log that has moved rather than the tail. As the tail didn't
> -		 * move, there still won't be space available for the
> -		 * reservation we require.  However, if the AIL has already
> -		 * pushed to the target defined by the old log head location, we
> -		 * will hang here waiting for something else to update the AIL
> -		 * push target.
> -		 *
> -		 * Therefore, if there isn't space to wake the first waiter on
> -		 * the grant head, we need to push the AIL again to ensure the
> -		 * target reflects both the current log tail and log head
> -		 * position before we wait for the tail to move again.
> -		 */
> -
>  		need_bytes = xlog_ticket_reservation(log, head, tic);
> -		if (*free_bytes < need_bytes) {
> -			if (!woken_task)
> -				xlog_grant_push_ail(log, need_bytes);
> +		if (*free_bytes < need_bytes)
>  			return false;
> -		}
>  
>  		*free_bytes -= need_bytes;
>  		trace_xfs_log_grant_wake_up(log, tic);
>  		wake_up_process(tic->t_task);
> -		woken_task = true;
>  	}
>  
>  	return true;
> @@ -296,13 +261,15 @@ xlog_grant_head_wait(
>  	do {
>  		if (xlog_is_shutdown(log))
>  			goto shutdown;
> -		xlog_grant_push_ail(log, need_bytes);
>  
>  		__set_current_state(TASK_UNINTERRUPTIBLE);
>  		spin_unlock(&head->lock);
>  
>  		XFS_STATS_INC(log->l_mp, xs_sleep_logspace);
>  
> +		/* Push on the AIL to free up all the log space. */
> +		xfs_ail_push_all(log->l_ailp);
> +
>  		trace_xfs_log_grant_sleep(log, tic);
>  		schedule();
>  		trace_xfs_log_grant_wake(log, tic);
> @@ -418,9 +385,6 @@ xfs_log_regrant(
>  	 * of rolling transactions in the log easily.
>  	 */
>  	tic->t_tid++;
> -
> -	xlog_grant_push_ail(log, tic->t_unit_res);
> -
>  	tic->t_curr_res = tic->t_unit_res;
>  	if (tic->t_cnt > 0)
>  		return 0;
> @@ -477,12 +441,7 @@ xfs_log_reserve(
>  	ASSERT(*ticp == NULL);
>  	tic = xlog_ticket_alloc(log, unit_bytes, cnt, permanent);
>  	*ticp = tic;
> -
> -	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
> -					    : tic->t_unit_res);
> -
>  	trace_xfs_log_reserve(log, tic);
> -
>  	error = xlog_grant_head_check(log, &log->l_reserve_head, tic,
>  				      &need_bytes);
>  	if (error)
> @@ -1337,7 +1296,7 @@ xlog_assign_tail_lsn(
>   * shortcut invalidity asserts in this case so that we don't trigger them
>   * falsely.
>   */
> -STATIC int
> +int
>  xlog_space_left(
>  	struct xlog	*log,
>  	atomic64_t	*head)
> @@ -1678,89 +1637,6 @@ xlog_alloc_log(
>  	return ERR_PTR(error);
>  }	/* xlog_alloc_log */
>  
> -/*
> - * Compute the LSN that we'd need to push the log tail towards in order to have
> - * (a) enough on-disk log space to log the number of bytes specified, (b) at
> - * least 25% of the log space free, and (c) at least 256 blocks free.  If the
> - * log free space already meets all three thresholds, this function returns
> - * NULLCOMMITLSN.
> - */
> -xfs_lsn_t
> -xlog_grant_push_threshold(
> -	struct xlog	*log,
> -	int		need_bytes)
> -{
> -	xfs_lsn_t	threshold_lsn = 0;
> -	xfs_lsn_t	last_sync_lsn;
> -	int		free_blocks;
> -	int		free_bytes;
> -	int		threshold_block;
> -	int		threshold_cycle;
> -	int		free_threshold;
> -
> -	ASSERT(BTOBB(need_bytes) < log->l_logBBsize);
> -
> -	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
> -	free_blocks = BTOBBT(free_bytes);
> -
> -	/*
> -	 * Set the threshold for the minimum number of free blocks in the
> -	 * log to the maximum of what the caller needs, one quarter of the
> -	 * log, and 256 blocks.
> -	 */
> -	free_threshold = BTOBB(need_bytes);
> -	free_threshold = max(free_threshold, (log->l_logBBsize >> 2));
> -	free_threshold = max(free_threshold, 256);
> -	if (free_blocks >= free_threshold)
> -		return NULLCOMMITLSN;
> -
> -	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
> -						&threshold_block);
> -	threshold_block += free_threshold;
> -	if (threshold_block >= log->l_logBBsize) {
> -		threshold_block -= log->l_logBBsize;
> -		threshold_cycle += 1;
> -	}
> -	threshold_lsn = xlog_assign_lsn(threshold_cycle,
> -					threshold_block);
> -	/*
> -	 * Don't pass in an lsn greater than the lsn of the last
> -	 * log record known to be on disk. Use a snapshot of the last sync lsn
> -	 * so that it doesn't change between the compare and the set.
> -	 */
> -	last_sync_lsn = atomic64_read(&log->l_last_sync_lsn);
> -	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
> -		threshold_lsn = last_sync_lsn;
> -
> -	return threshold_lsn;
> -}
> -
> -/*
> - * Push the tail of the log if we need to do so to maintain the free log space
> - * thresholds set out by xlog_grant_push_threshold.  We may need to adopt a
> - * policy which pushes on an lsn which is further along in the log once we
> - * reach the high water mark.  In this manner, we would be creating a low water
> - * mark.
> - */
> -STATIC void
> -xlog_grant_push_ail(
> -	struct xlog	*log,
> -	int		need_bytes)
> -{
> -	xfs_lsn_t	threshold_lsn;
> -
> -	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
> -	if (threshold_lsn == NULLCOMMITLSN || xlog_is_shutdown(log))
> -		return;
> -
> -	/*
> -	 * Get the transaction layer to kick the dirty buffers out to
> -	 * disk asynchronously. No point in trying to do this if
> -	 * the filesystem is shutting down.
> -	 */
> -	xfs_ail_push(log->l_ailp, threshold_lsn);
> -}
> -
>  /*
>   * Stamp cycle number in every block
>   */
> @@ -2725,7 +2601,6 @@ xlog_state_set_callback(
>  		return;
>  
>  	atomic64_set(&log->l_last_sync_lsn, header_lsn);
> -	xlog_grant_push_ail(log, 0);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 2728886c2963..6b6ee35b3885 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -156,7 +156,6 @@ int	xfs_log_quiesce(struct xfs_mount *mp);
>  void	xfs_log_clean(struct xfs_mount *mp);
>  bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
>  
> -xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
>  bool	  xlog_force_shutdown(struct xlog *log, uint32_t shutdown_flags);
>  
>  void xlog_use_incompat_feat(struct xlog *log);
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 1bd2963e8fbd..91a8c74f4626 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -573,6 +573,8 @@ xlog_assign_grant_head(atomic64_t *head, int cycle, int space)
>  	atomic64_set(head, xlog_assign_grant_head_val(cycle, space));
>  }
>  
> +int xlog_space_left(struct xlog	 *log, atomic64_t *head);
> +
>  /*
>   * Committed Item List interfaces
>   */
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index d3a97a028560..243d6b05e5a9 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -134,25 +134,6 @@ xfs_ail_min_lsn(
>  	return lsn;
>  }
>  
> -/*
> - * Return the maximum lsn held in the AIL, or zero if the AIL is empty.
> - */
> -static xfs_lsn_t
> -xfs_ail_max_lsn(
> -	struct xfs_ail		*ailp)
> -{
> -	xfs_lsn_t       	lsn = 0;
> -	struct xfs_log_item	*lip;
> -
> -	spin_lock(&ailp->ail_lock);
> -	lip = xfs_ail_max(ailp);
> -	if (lip)
> -		lsn = lip->li_lsn;
> -	spin_unlock(&ailp->ail_lock);
> -
> -	return lsn;
> -}
> -
>  /*
>   * The cursor keeps track of where our current traversal is up to by tracking
>   * the next item in the list for us. However, for this to be safe, removing an
> @@ -414,6 +395,57 @@ xfsaild_push_item(
>  	return lip->li_ops->iop_push(lip, &ailp->ail_buf_list);
>  }
>  
> +/*
> + * Compute the LSN that we'd need to push the log tail towards in order to have
> + * at least 25% of the log space free.  If the log free space already meets this
> + * threshold, this function returns NULLCOMMITLSN.
> + */
> +xfs_lsn_t
> +__xfs_ail_push_target(
> +	struct xfs_ail		*ailp)
> +{
> +	struct xlog	*log = ailp->ail_log;
> +	xfs_lsn_t	threshold_lsn = 0;
> +	xfs_lsn_t	last_sync_lsn;
> +	int		free_blocks;
> +	int		free_bytes;
> +	int		threshold_block;
> +	int		threshold_cycle;
> +	int		free_threshold;
> +
> +	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
> +	free_blocks = BTOBBT(free_bytes);
> +
> +	/*
> +	 * Set the threshold for the minimum number of free blocks in the
> +	 * log to the maximum of what the caller needs, one quarter of the
> +	 * log, and 256 blocks.
> +	 */
> +	free_threshold = log->l_logBBsize >> 2;
> +	if (free_blocks >= free_threshold)

What happened to the "free_threshold = max(free_threshold, 256);" from
the old code?  Or is the documented 256 block minimum no longer
necessary?

> +		return NULLCOMMITLSN;
> +
> +	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
> +						&threshold_block);
> +	threshold_block += free_threshold;
> +	if (threshold_block >= log->l_logBBsize) {
> +		threshold_block -= log->l_logBBsize;
> +		threshold_cycle += 1;
> +	}
> +	threshold_lsn = xlog_assign_lsn(threshold_cycle,
> +					threshold_block);
> +	/*
> +	 * Don't pass in an lsn greater than the lsn of the last
> +	 * log record known to be on disk. Use a snapshot of the last sync lsn
> +	 * so that it doesn't change between the compare and the set.
> +	 */
> +	last_sync_lsn = atomic64_read(&log->l_last_sync_lsn);
> +	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
> +		threshold_lsn = last_sync_lsn;
> +
> +	return threshold_lsn;
> +}
> +
>  static long
>  xfsaild_push(
>  	struct xfs_ail		*ailp)
> @@ -422,7 +454,7 @@ xfsaild_push(
>  	struct xfs_ail_cursor	cur;
>  	struct xfs_log_item	*lip;
>  	xfs_lsn_t		lsn;
> -	xfs_lsn_t		target;
> +	xfs_lsn_t		target = NULLCOMMITLSN;
>  	long			tout;
>  	int			stuck = 0;
>  	int			flushing = 0;
> @@ -454,21 +486,24 @@ xfsaild_push(
>  	 * capture updates that occur after the sync push waiter has gone to
>  	 * sleep.
>  	 */
> -	if (waitqueue_active(&ailp->ail_empty)) {
> +	if (test_bit(XFS_AIL_OPSTATE_PUSH_ALL, &ailp->ail_opstate) ||
> +	    waitqueue_active(&ailp->ail_empty)) {
>  		lip = xfs_ail_max(ailp);
>  		if (lip)
>  			target = lip->li_lsn;
> +		else
> +			clear_bit(XFS_AIL_OPSTATE_PUSH_ALL, &ailp->ail_opstate);
>  	} else {
> -		/* barrier matches the ail_target update in xfs_ail_push() */
> -		smp_rmb();
> -		target = ailp->ail_target;
> -		ailp->ail_target_prev = target;
> +		target = __xfs_ail_push_target(ailp);

Hmm.  So now the AIL decides how far it ought to push itself: until 25%
of the log is free if nobody's watching, or all the way to the end if
there are xfs_ail_push_all_sync waiters or OPSTATE_PUSH_ALL is set
because someone needs grant space?

So the xlog*grant* callers now merely wake up the AIL and let push
whatever it will, instead of telling the AIL how far to push itself?
Does that mean that those grant callers might have to wait until the AIL
empties itself?

--D

>  	}
>  
> +	if (target == NULLCOMMITLSN)
> +		goto out_done;
> +
>  	/* we're done if the AIL is empty or our push has reached the end */
>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->ail_last_pushed_lsn);
>  	if (!lip)
> -		goto out_done;
> +		goto out_done_cursor;
>  
>  	XFS_STATS_INC(mp, xs_push_ail);
>  
> @@ -551,8 +586,9 @@ xfsaild_push(
>  		lsn = lip->li_lsn;
>  	}
>  
> -out_done:
> +out_done_cursor:
>  	xfs_trans_ail_cursor_done(&cur);
> +out_done:
>  	spin_unlock(&ailp->ail_lock);
>  
>  	if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
> @@ -601,7 +637,7 @@ xfsaild(
>  	set_freezable();
>  
>  	while (1) {
> -		if (tout && tout <= 20)
> +		if (tout)
>  			set_current_state(TASK_KILLABLE);
>  		else
>  			set_current_state(TASK_INTERRUPTIBLE);
> @@ -637,21 +673,9 @@ xfsaild(
>  			break;
>  		}
>  
> +		/* Idle if the AIL is empty. */
>  		spin_lock(&ailp->ail_lock);
> -
> -		/*
> -		 * Idle if the AIL is empty and we are not racing with a target
> -		 * update. We check the AIL after we set the task to a sleep
> -		 * state to guarantee that we either catch an ail_target update
> -		 * or that a wake_up resets the state to TASK_RUNNING.
> -		 * Otherwise, we run the risk of sleeping indefinitely.
> -		 *
> -		 * The barrier matches the ail_target update in xfs_ail_push().
> -		 */
> -		smp_rmb();
> -		if (!xfs_ail_min(ailp) &&
> -		    ailp->ail_target == ailp->ail_target_prev &&
> -		    list_empty(&ailp->ail_buf_list)) {
> +		if (!xfs_ail_min(ailp) && list_empty(&ailp->ail_buf_list)) {
>  			spin_unlock(&ailp->ail_lock);
>  			freezable_schedule();
>  			tout = 0;
> @@ -673,56 +697,6 @@ xfsaild(
>  	return 0;
>  }
>  
> -/*
> - * This routine is called to move the tail of the AIL forward.  It does this by
> - * trying to flush items in the AIL whose lsns are below the given
> - * threshold_lsn.
> - *
> - * The push is run asynchronously in a workqueue, which means the caller needs
> - * to handle waiting on the async flush for space to become available.
> - * We don't want to interrupt any push that is in progress, hence we only queue
> - * work if we set the pushing bit appropriately.
> - *
> - * We do this unlocked - we only need to know whether there is anything in the
> - * AIL at the time we are called. We don't need to access the contents of
> - * any of the objects, so the lock is not needed.
> - */
> -void
> -xfs_ail_push(
> -	struct xfs_ail		*ailp,
> -	xfs_lsn_t		threshold_lsn)
> -{
> -	struct xfs_log_item	*lip;
> -
> -	lip = xfs_ail_min(ailp);
> -	if (!lip || xlog_is_shutdown(ailp->ail_log) ||
> -	    XFS_LSN_CMP(threshold_lsn, ailp->ail_target) <= 0)
> -		return;
> -
> -	/*
> -	 * Ensure that the new target is noticed in push code before it clears
> -	 * the XFS_AIL_PUSHING_BIT.
> -	 */
> -	smp_wmb();
> -	xfs_trans_ail_copy_lsn(ailp, &ailp->ail_target, &threshold_lsn);
> -	smp_wmb();
> -
> -	wake_up_process(ailp->ail_task);
> -}
> -
> -/*
> - * Push out all items in the AIL immediately
> - */
> -void
> -xfs_ail_push_all(
> -	struct xfs_ail  *ailp)
> -{
> -	xfs_lsn_t       threshold_lsn = xfs_ail_max_lsn(ailp);
> -
> -	if (threshold_lsn)
> -		xfs_ail_push(ailp, threshold_lsn);
> -}
> -
>  /*
>   * Push out all items in the AIL immediately and wait until the AIL is empty.
>   */
> @@ -828,6 +802,13 @@ xfs_trans_ail_update_bulk(
>  	if (!list_empty(&tmp))
>  		xfs_ail_splice(ailp, cur, &tmp, lsn);
>  
> +	/*
> +	 * If this is the first insert, wake up the push daemon so it can
> +	 * actively scan for items to push.
> +	 */
> +	if (!mlip)
> +		wake_up_process(ailp->ail_task);
> +
>  	xfs_ail_update_finish(ailp, tail_lsn);
>  }
>  
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 52a45f0a5ef1..9a131e7fae94 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -52,16 +52,18 @@ struct xfs_ail {
>  	struct xlog		*ail_log;
>  	struct task_struct	*ail_task;
>  	struct list_head	ail_head;
> -	xfs_lsn_t		ail_target;
> -	xfs_lsn_t		ail_target_prev;
>  	struct list_head	ail_cursors;
>  	spinlock_t		ail_lock;
>  	xfs_lsn_t		ail_last_pushed_lsn;
>  	int			ail_log_flush;
> +	unsigned long		ail_opstate;
>  	struct list_head	ail_buf_list;
>  	wait_queue_head_t	ail_empty;
>  };
>  
> +/* Push all items out of the AIL immediately. */
> +#define XFS_AIL_OPSTATE_PUSH_ALL	0u
> +
>  /*
>   * From xfs_trans_ail.c
>   */
> @@ -98,10 +100,29 @@ void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
>  			__releases(ailp->ail_lock);
>  void xfs_trans_ail_delete(struct xfs_log_item *lip, int shutdown_type);
>  
> -void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);
> -void			xfs_ail_push_all(struct xfs_ail *);
> -void			xfs_ail_push_all_sync(struct xfs_ail *);
> -struct xfs_log_item	*xfs_ail_min(struct xfs_ail  *ailp);
> +static inline void xfs_ail_push(struct xfs_ail *ailp)
> +{
> +	wake_up_process(ailp->ail_task);
> +}
> +
> +static inline void xfs_ail_push_all(struct xfs_ail *ailp)
> +{
> +	if (!test_and_set_bit(XFS_AIL_OPSTATE_PUSH_ALL, &ailp->ail_opstate))
> +		xfs_ail_push(ailp);
> +}
> +
> +xfs_lsn_t		__xfs_ail_push_target(struct xfs_ail *ailp);
> +static inline xfs_lsn_t xfs_ail_push_target(struct xfs_ail *ailp)
> +{
> +	xfs_lsn_t	lsn;
> +
> +	spin_lock(&ailp->ail_lock);
> +	lsn = __xfs_ail_push_target(ailp);
> +	spin_unlock(&ailp->ail_lock);
> +	return lsn;
> +}
> +
> +void			xfs_ail_push_all_sync(struct xfs_ail *ailp);
>  xfs_lsn_t		xfs_ail_min_lsn(struct xfs_ail *ailp);
>  
>  struct xfs_log_item *	xfs_trans_ail_cursor_first(struct xfs_ail *ailp,
> -- 
> 2.36.1
> 
