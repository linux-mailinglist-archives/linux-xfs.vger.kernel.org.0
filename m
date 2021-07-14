Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB8E3C93EA
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Jul 2021 00:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbhGNWjP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Jul 2021 18:39:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236993AbhGNWjO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 18:39:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3B5D610D1;
        Wed, 14 Jul 2021 22:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626302181;
        bh=wpedTWUldtVZ1lZzPl7WH7LN7slvGcqlwtZ9ekPheYk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EXrbIPF21Jjc+Qf56hJz41lGzhXzFbXr8OvC0tELtwsKX61WxxQZ5B+3uu9yyOVLP
         c0en0DYM++Wy27NIoQm8aR3a3BbvgNqKZKMF5xx1zswf23e1Ngd6rx4qSygrNyTqOC
         RSmAR+CEN8aJb/B/NCvm5Y+9yCRJkuW+nO84c7snsKTFOsLLKeX+1KAqKjgka88q0T
         xcCZFz3TjdZGMut1RbvvFiOq1Ra6AoCso0k0rC7bsbJXo6rNRVh4ktCyW/iRhpoD+Q
         ptmClhmRM/f2NssPsh9vUmq6TpJFyXaoFHaie4TmkUmKH3omjYmd0R03H1IxCeHAMm
         s5E+IrTa2MEKw==
Date:   Wed, 14 Jul 2021 15:36:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: attached iclog callbacks in
 xlog_cil_set_ctx_write_state()
Message-ID: <20210714223621.GF23236@magnolia>
References: <20210714033656.2621741-1-david@fromorbit.com>
 <20210714033656.2621741-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714033656.2621741-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 01:36:55PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have a mechanism to guarantee that the callbacks
> attached to an iclog are owned by the context that attaches them
> until they drop their reference to the iclog via
> xlog_state_release_iclog(), we can attach callbacks to the iclog at
> any time we have an active reference to the iclog.
> 
> xlog_state_get_iclog_space() always guarantees that the commit
> record will fit in the iclog it returns, so we can move this IO
> callback setting to xlog_cil_set_ctx_write_state(), record the
> commit iclog in the context and remove the need for the commit iclog
> to be returned by xlog_write() altogether.
> 
> This, in turn, allows us to move the wakeup for ordered commit
> record writes up into xlog_cil_set_ctx_write_state(), too, because
> we have been guaranteed that this commit record will be physically
> located in the iclog before any waiting commit record at a higher
> sequence number will be granted iclog space.
> 
> This further cleans up the post commit record write processing in
> the CIL push code, especially as xlog_state_release_iclog() will now
> clean up the context when shutdown errors occur.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Modulo the typo in the subject, I think I figured this out to my
satisfaction.  The addition of the ic_refcnt increment when we're
committing the transaction exists to balance out the now unconditional
release_iclog call.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c      | 47 ++++++++--------------
>  fs/xfs/xfs_log_cil.c  | 94 ++++++++++++++++++++++++-------------------
>  fs/xfs/xfs_log_priv.h |  3 +-
>  3 files changed, 70 insertions(+), 74 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a190efbbe451..f41c6f388456 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -901,7 +901,7 @@ xlog_write_unmount_record(
>  	 */
>  	if (log->l_targ != log->l_mp->m_ddev_targp)
>  		blkdev_issue_flush(log->l_targ->bt_bdev);
> -	return xlog_write(log, NULL, &vec, ticket, NULL, XLOG_UNMOUNT_TRANS);
> +	return xlog_write(log, NULL, &vec, ticket, XLOG_UNMOUNT_TRANS);
>  }
>  
>  /*
> @@ -2307,8 +2307,7 @@ xlog_write_copy_finish(
>  	int			*data_cnt,
>  	int			*partial_copy,
>  	int			*partial_copy_len,
> -	int			log_offset,
> -	struct xlog_in_core	**commit_iclog)
> +	int			log_offset)
>  {
>  	int			error;
>  
> @@ -2327,27 +2326,20 @@ xlog_write_copy_finish(
>  	*partial_copy = 0;
>  	*partial_copy_len = 0;
>  
> -	if (iclog->ic_size - log_offset <= sizeof(xlog_op_header_t)) {
> -		/* no more space in this iclog - push it. */
> -		spin_lock(&log->l_icloglock);
> -		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
> -		*record_cnt = 0;
> -		*data_cnt = 0;
> -
> -		if (iclog->ic_state == XLOG_STATE_ACTIVE)
> -			xlog_state_switch_iclogs(log, iclog, 0);
> -		else
> -			ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -				xlog_is_shutdown(log));
> -		if (!commit_iclog)
> -			goto release_iclog;
> -		spin_unlock(&log->l_icloglock);
> -		ASSERT(flags & XLOG_COMMIT_TRANS);
> -		*commit_iclog = iclog;
> -	}
> +	if (iclog->ic_size - log_offset > sizeof(xlog_op_header_t))
> +		return 0;
>  
> -	return 0;
> +	/* no more space in this iclog - push it. */
> +	spin_lock(&log->l_icloglock);
> +	xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
> +	*record_cnt = 0;
> +	*data_cnt = 0;
>  
> +	if (iclog->ic_state == XLOG_STATE_ACTIVE)
> +		xlog_state_switch_iclogs(log, iclog, 0);
> +	else
> +		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> +			xlog_is_shutdown(log));
>  release_iclog:
>  	error = xlog_state_release_iclog(log, iclog);
>  	spin_unlock(&log->l_icloglock);
> @@ -2400,7 +2392,6 @@ xlog_write(
>  	struct xfs_cil_ctx	*ctx,
>  	struct xfs_log_vec	*log_vector,
>  	struct xlog_ticket	*ticket,
> -	struct xlog_in_core	**commit_iclog,
>  	uint			optype)
>  {
>  	struct xlog_in_core	*iclog = NULL;
> @@ -2529,8 +2520,7 @@ xlog_write(
>  						       &record_cnt, &data_cnt,
>  						       &partial_copy,
>  						       &partial_copy_len,
> -						       log_offset,
> -						       commit_iclog);
> +						       log_offset);
>  			if (error)
>  				return error;
>  
> @@ -2568,12 +2558,7 @@ xlog_write(
>  
>  	spin_lock(&log->l_icloglock);
>  	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
> -	if (commit_iclog) {
> -		ASSERT(optype & XLOG_COMMIT_TRANS);
> -		*commit_iclog = iclog;
> -	} else {
> -		error = xlog_state_release_iclog(log, iclog);
> -	}
> +	error = xlog_state_release_iclog(log, iclog);
>  	spin_unlock(&log->l_icloglock);
>  
>  	return error;
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index cac3c9c894e5..18a2d6a9f26e 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -638,11 +638,41 @@ xlog_cil_set_ctx_write_state(
>  	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  
>  	ASSERT(!ctx->commit_lsn);
> -	spin_lock(&cil->xc_push_lock);
> -	if (!ctx->start_lsn)
> +	if (!ctx->start_lsn) {
> +		spin_lock(&cil->xc_push_lock);
>  		ctx->start_lsn = lsn;
> -	else
> -		ctx->commit_lsn = lsn;
> +		spin_unlock(&cil->xc_push_lock);
> +		return;
> +	}
> +
> +	/*
> +	 * Take a reference to the iclog for the context so that we still hold
> +	 * it when xlog_write is done and has released it. This means the
> +	 * context controls when the iclog is released for IO.
> +	 */
> +	atomic_inc(&iclog->ic_refcnt);
> +
> +	/*
> +	 * xlog_state_get_iclog_space() guarantees there is enough space in the
> +	 * iclog for an entire commit record, so we can attach the context
> +	 * callbacks now.  This needs to be done before we make the commit_lsn
> +	 * visible to waiters so that checkpoints with commit records in the
> +	 * same iclog order their IO completion callbacks in the same order that
> +	 * the commit records appear in the iclog.
> +	 */
> +	spin_lock(&cil->xc_log->l_icloglock);
> +	list_add_tail(&ctx->iclog_entry, &iclog->ic_callbacks);
> +	spin_unlock(&cil->xc_log->l_icloglock);
> +
> +	/*
> +	 * Now we can record the commit LSN and wake anyone waiting for this
> +	 * sequence to have the ordered commit record assigned to a physical
> +	 * location in the log.
> +	 */
> +	spin_lock(&cil->xc_push_lock);
> +	ctx->commit_iclog = iclog;
> +	ctx->commit_lsn = lsn;
> +	wake_up_all(&cil->xc_commit_wait);
>  	spin_unlock(&cil->xc_push_lock);
>  }
>  
> @@ -699,8 +729,7 @@ xlog_cil_order_write(
>   */
>  static int
>  xlog_cil_write_commit_record(
> -	struct xfs_cil_ctx	*ctx,
> -	struct xlog_in_core	**iclog)
> +	struct xfs_cil_ctx	*ctx)
>  {
>  	struct xlog		*log = ctx->cil->xc_log;
>  	struct xfs_log_iovec	reg = {
> @@ -717,8 +746,7 @@ xlog_cil_write_commit_record(
>  	if (xlog_is_shutdown(log))
>  		return -EIO;
>  
> -	error = xlog_write(log, ctx, &vec, ctx->ticket, iclog,
> -			XLOG_COMMIT_TRANS);
> +	error = xlog_write(log, ctx, &vec, ctx->ticket, XLOG_COMMIT_TRANS);
>  	if (error)
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	return error;
> @@ -748,7 +776,6 @@ xlog_cil_push_work(
>  	struct xfs_log_vec	*lv;
>  	struct xfs_cil_ctx	*ctx;
>  	struct xfs_cil_ctx	*new_ctx;
> -	struct xlog_in_core	*commit_iclog;
>  	struct xlog_ticket	*tic;
>  	int			num_iovecs;
>  	int			error = 0;
> @@ -928,7 +955,7 @@ xlog_cil_push_work(
>  	 */
>  	wait_for_completion(&bdev_flush);
>  
> -	error = xlog_write(log, ctx, &lvhdr, tic, NULL, XLOG_START_TRANS);
> +	error = xlog_write(log, ctx, &lvhdr, tic, XLOG_START_TRANS);
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> @@ -936,36 +963,12 @@ xlog_cil_push_work(
>  	if (error)
>  		goto out_abort_free_ticket;
>  
> -	error = xlog_cil_write_commit_record(ctx, &commit_iclog);
> +	error = xlog_cil_write_commit_record(ctx);
>  	if (error)
>  		goto out_abort_free_ticket;
>  
>  	xfs_log_ticket_ungrant(log, tic);
>  
> -	/*
> -	 * Once we attach the ctx to the iclog, it is effectively owned by the
> -	 * iclog and we can only use it while we still have an active reference
> -	 * to the iclog. i.e. once we call xlog_state_release_iclog() we can no
> -	 * longer safely reference the ctx.
> -	 */
> -	spin_lock(&log->l_icloglock);
> -	if (xlog_is_shutdown(log)) {
> -		spin_unlock(&log->l_icloglock);
> -		goto out_abort;
> -	}
> -	ASSERT_ALWAYS(commit_iclog->ic_state == XLOG_STATE_ACTIVE ||
> -		      commit_iclog->ic_state == XLOG_STATE_WANT_SYNC);
> -	list_add_tail(&ctx->iclog_entry, &commit_iclog->ic_callbacks);
> -
> -	/*
> -	 * now the checkpoint commit is complete and we've attached the
> -	 * callbacks to the iclog we can assign the commit LSN to the context
> -	 * and wake up anyone who is waiting for the commit to complete.
> -	 */
> -	spin_lock(&cil->xc_push_lock);
> -	wake_up_all(&cil->xc_commit_wait);
> -	spin_unlock(&cil->xc_push_lock);
> -
>  	/*
>  	 * If the checkpoint spans multiple iclogs, wait for all previous iclogs
>  	 * to complete before we submit the commit_iclog. We can't use state
> @@ -978,17 +981,18 @@ xlog_cil_push_work(
>  	 * iclog header lsn and compare it to the commit lsn to determine if we
>  	 * need to wait on iclogs or not.
>  	 */
> +	spin_lock(&log->l_icloglock);
>  	if (ctx->start_lsn != ctx->commit_lsn) {
>  		xfs_lsn_t	plsn;
>  
> -		plsn = be64_to_cpu(commit_iclog->ic_prev->ic_header.h_lsn);
> +		plsn = be64_to_cpu(ctx->commit_iclog->ic_prev->ic_header.h_lsn);
>  		if (plsn && XFS_LSN_CMP(plsn, ctx->commit_lsn) < 0) {
>  			/*
>  			 * Waiting on ic_force_wait orders the completion of
>  			 * iclogs older than ic_prev. Hence we only need to wait
>  			 * on the most recent older iclog here.
>  			 */
> -			xlog_wait_on_iclog(commit_iclog->ic_prev);
> +			xlog_wait_on_iclog(ctx->commit_iclog->ic_prev);
>  			spin_lock(&log->l_icloglock);
>  		}
>  
> @@ -996,7 +1000,7 @@ xlog_cil_push_work(
>  		 * We need to issue a pre-flush so that the ordering for this
>  		 * checkpoint is correctly preserved down to stable storage.
>  		 */
> -		commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
> +		ctx->commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
>  	}
>  
>  	/*
> @@ -1004,8 +1008,8 @@ xlog_cil_push_work(
>  	 * journal IO vs metadata writeback IO is correctly ordered on stable
>  	 * storage.
>  	 */
> -	commit_iclog->ic_flags |= XLOG_ICL_NEED_FUA;
> -	xlog_state_release_iclog(log, commit_iclog);
> +	ctx->commit_iclog->ic_flags |= XLOG_ICL_NEED_FUA;
> +	xlog_state_release_iclog(log, ctx->commit_iclog);
>  
>  	/* Not safe to reference ctx now! */
>  
> @@ -1020,9 +1024,15 @@ xlog_cil_push_work(
>  
>  out_abort_free_ticket:
>  	xfs_log_ticket_ungrant(log, tic);
> -out_abort:
>  	ASSERT(xlog_is_shutdown(log));
> -	xlog_cil_committed(ctx);
> +	if (!ctx->commit_iclog) {
> +		xlog_cil_committed(ctx);
> +		return;
> +	}
> +	spin_lock(&log->l_icloglock);
> +	xlog_state_release_iclog(log, ctx->commit_iclog);
> +	/* Not safe to reference ctx now! */
> +	spin_unlock(&log->l_icloglock);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 2a02ce05b649..f74e3968bb84 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -232,6 +232,7 @@ struct xfs_cil_ctx {
>  	xfs_csn_t		sequence;	/* chkpt sequence # */
>  	xfs_lsn_t		start_lsn;	/* first LSN of chkpt commit */
>  	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
> +	struct xlog_in_core	*commit_iclog;
>  	struct xlog_ticket	*ticket;	/* chkpt ticket */
>  	int			nvecs;		/* number of regions */
>  	int			space_used;	/* aggregate size of regions */
> @@ -503,7 +504,7 @@ void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
>  void	xlog_print_trans(struct xfs_trans *);
>  int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
>  		struct xfs_log_vec *log_vector, struct xlog_ticket *tic,
> -		struct xlog_in_core **commit_iclog, uint optype);
> +		uint optype);
>  void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
>  void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
>  
> -- 
> 2.31.1
> 
