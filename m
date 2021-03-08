Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E442331ADF
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Mar 2021 00:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCHXO6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Mar 2021 18:14:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhCHXOd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 18:14:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3177D651CF;
        Mon,  8 Mar 2021 23:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615245273;
        bh=HoN1p4QreiCGLh7uqwOiW1OeGBopQw6fpW0BjYFkOYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TeFkY9qSWEq16nnRrj8LRSOhHB5RogenZXXqe2utR99jvSjHxuT8jgD4r0fw0/ThD
         uXXM2GQRiWbXj0oC1boLlBe3VQIkXgJVqHZ/50O1RkIbIcFWwlr+cQPcHsuTP4nxs7
         ubIbbBjwmpJ0Jbf627LP4Pyz4bnOxXNTb6Yiqv6D5rzCq46DVLeutut44GuYcQGFSP
         RHXryNpXJoMLNdyJIhsVPxbEdQiJzFMzsJ/CqfL8b4ZHinaHScesT09gQCUoRc3Isi
         DdZNj2+15Od2fWeiKwiPSkHCQsNUBeuxHPkfzWzjR1WFWWQbXMvIm3BrdmKrDxM79o
         wrBoINuCvmTvA==
Date:   Mon, 8 Mar 2021 15:14:32 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/45] xfs: CIL work is serialised, not pipelined
Message-ID: <20210308231432.GD3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-16-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-16-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:13PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because we use a single work structure attached to the CIL rather
> than the CIL context, we can only queue a single work item at a
> time. This results in the CIL being single threaded and limits
> performance when it becomes CPU bound.
> 
> The design of the CIL is that it is pipelined and multiple commits
> can be running concurrently, but the way the work is currently
> implemented means that it is not pipelining as it was intended. The
> critical work to switch the CIL context can take a few milliseconds
> to run, but the rest of the CIL context flush can take hundreds of
> milliseconds to complete. The context switching is the serialisation
> point of the CIL, once the context has been switched the rest of the
> context push can run asynchrnously with all other context pushes.
> 
> Hence we can move the work to the CIL context so that we can run
> multiple CIL pushes at the same time and spread the majority of
> the work out over multiple CPUs. We can keep the per-cpu CIL commit
> state on the CIL rather than the context, because the context is
> pinned to the CIL until the switch is done and we aggregate and
> drain the per-cpu state held on the CIL during the context switch.
> 
> However, because we no longer serialise the CIL work, we can have
> effectively unlimited CIL pushes in progress. We don't want to do
> this - not only does it create contention on the iclogs and the
> state machine locks, we can run the log right out of space with
> outstanding pushes. Instead, limit the work concurrency to 4
> concurrent works being processed at a time. THis is enough

Four?  Was that determined experimentally, or is that a fundamental
limit of how many cil checkpoints we can working on at a time?  The
current one, the previous one, and ... something else that was already
in progress?

I think the rest of the patch looks reasonable, FWIW.

--D

> concurrency to remove the CIL from being a CPU bound bottleneck but
> not enough to create new contention points or unbound concurrency
> issues.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c  | 80 +++++++++++++++++++++++--------------------
>  fs/xfs/xfs_log_priv.h |  2 +-
>  fs/xfs/xfs_super.c    |  2 +-
>  3 files changed, 44 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b101c25cc9a9..dfc9ef692a80 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -47,6 +47,34 @@ xlog_cil_ticket_alloc(
>  	return tic;
>  }
>  
> +/*
> + * Unavoidable forward declaration - xlog_cil_push_work() calls
> + * xlog_cil_ctx_alloc() itself.
> + */
> +static void xlog_cil_push_work(struct work_struct *work);
> +
> +static struct xfs_cil_ctx *
> +xlog_cil_ctx_alloc(void)
> +{
> +	struct xfs_cil_ctx	*ctx;
> +
> +	ctx = kmem_zalloc(sizeof(*ctx), KM_NOFS);
> +	INIT_LIST_HEAD(&ctx->committing);
> +	INIT_LIST_HEAD(&ctx->busy_extents);
> +	INIT_WORK(&ctx->push_work, xlog_cil_push_work);
> +	return ctx;
> +}
> +
> +static void
> +xlog_cil_ctx_switch(
> +	struct xfs_cil		*cil,
> +	struct xfs_cil_ctx	*ctx)
> +{
> +	ctx->sequence = ++cil->xc_current_sequence;
> +	ctx->cil = cil;
> +	cil->xc_ctx = ctx;
> +}
> +
>  /*
>   * After the first stage of log recovery is done, we know where the head and
>   * tail of the log are. We need this log initialisation done before we can
> @@ -641,11 +669,11 @@ static void
>  xlog_cil_push_work(
>  	struct work_struct	*work)
>  {
> -	struct xfs_cil		*cil =
> -		container_of(work, struct xfs_cil, xc_push_work);
> +	struct xfs_cil_ctx	*ctx =
> +		container_of(work, struct xfs_cil_ctx, push_work);
> +	struct xfs_cil		*cil = ctx->cil;
>  	struct xlog		*log = cil->xc_log;
>  	struct xfs_log_vec	*lv;
> -	struct xfs_cil_ctx	*ctx;
>  	struct xfs_cil_ctx	*new_ctx;
>  	struct xlog_in_core	*commit_iclog;
>  	struct xlog_ticket	*tic;
> @@ -660,11 +688,10 @@ xlog_cil_push_work(
>  	DECLARE_COMPLETION_ONSTACK(bdev_flush);
>  	bool			commit_iclog_sync = false;
>  
> -	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
> +	new_ctx = xlog_cil_ctx_alloc();
>  	new_ctx->ticket = xlog_cil_ticket_alloc(log);
>  
>  	down_write(&cil->xc_ctx_lock);
> -	ctx = cil->xc_ctx;
>  
>  	spin_lock(&cil->xc_push_lock);
>  	push_seq = cil->xc_push_seq;
> @@ -696,7 +723,7 @@ xlog_cil_push_work(
>  
>  
>  	/* check for a previously pushed sequence */
> -	if (push_seq < cil->xc_ctx->sequence) {
> +	if (push_seq < ctx->sequence) {
>  		spin_unlock(&cil->xc_push_lock);
>  		goto out_skip;
>  	}
> @@ -767,19 +794,7 @@ xlog_cil_push_work(
>  	}
>  
>  	/*
> -	 * initialise the new context and attach it to the CIL. Then attach
> -	 * the current context to the CIL committing list so it can be found
> -	 * during log forces to extract the commit lsn of the sequence that
> -	 * needs to be forced.
> -	 */
> -	INIT_LIST_HEAD(&new_ctx->committing);
> -	INIT_LIST_HEAD(&new_ctx->busy_extents);
> -	new_ctx->sequence = ctx->sequence + 1;
> -	new_ctx->cil = cil;
> -	cil->xc_ctx = new_ctx;
> -
> -	/*
> -	 * The switch is now done, so we can drop the context lock and move out
> +	 * Switch the contexts so we can drop the context lock and move out
>  	 * of a shared context. We can't just go straight to the commit record,
>  	 * though - we need to synchronise with previous and future commits so
>  	 * that the commit records are correctly ordered in the log to ensure
> @@ -804,7 +819,7 @@ xlog_cil_push_work(
>  	 * deferencing a freed context pointer.
>  	 */
>  	spin_lock(&cil->xc_push_lock);
> -	cil->xc_current_sequence = new_ctx->sequence;
> +	xlog_cil_ctx_switch(cil, new_ctx);
>  	spin_unlock(&cil->xc_push_lock);
>  	up_write(&cil->xc_ctx_lock);
>  
> @@ -968,7 +983,7 @@ xlog_cil_push_background(
>  	spin_lock(&cil->xc_push_lock);
>  	if (cil->xc_push_seq < cil->xc_current_sequence) {
>  		cil->xc_push_seq = cil->xc_current_sequence;
> -		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
> +		queue_work(log->l_mp->m_cil_workqueue, &cil->xc_ctx->push_work);
>  	}
>  
>  	/*
> @@ -1034,7 +1049,7 @@ xlog_cil_push_now(
>  
>  	/* start on any pending background push to minimise wait time on it */
>  	if (sync)
> -		flush_work(&cil->xc_push_work);
> +		flush_workqueue(log->l_mp->m_cil_workqueue);
>  
>  	/*
>  	 * If the CIL is empty or we've already pushed the sequence then
> @@ -1049,7 +1064,7 @@ xlog_cil_push_now(
>  	cil->xc_push_seq = push_seq;
>  	if (!sync)
>  		cil->xc_push_async = true;
> -	queue_work(log->l_mp->m_cil_workqueue, &cil->xc_push_work);
> +	queue_work(log->l_mp->m_cil_workqueue, &cil->xc_ctx->push_work);
>  	spin_unlock(&cil->xc_push_lock);
>  }
>  
> @@ -1286,13 +1301,6 @@ xlog_cil_init(
>  	if (!cil)
>  		return -ENOMEM;
>  
> -	ctx = kmem_zalloc(sizeof(*ctx), KM_MAYFAIL);
> -	if (!ctx) {
> -		kmem_free(cil);
> -		return -ENOMEM;
> -	}
> -
> -	INIT_WORK(&cil->xc_push_work, xlog_cil_push_work);
>  	INIT_LIST_HEAD(&cil->xc_cil);
>  	INIT_LIST_HEAD(&cil->xc_committing);
>  	spin_lock_init(&cil->xc_cil_lock);
> @@ -1300,16 +1308,12 @@ xlog_cil_init(
>  	init_waitqueue_head(&cil->xc_push_wait);
>  	init_rwsem(&cil->xc_ctx_lock);
>  	init_waitqueue_head(&cil->xc_commit_wait);
> -
> -	INIT_LIST_HEAD(&ctx->committing);
> -	INIT_LIST_HEAD(&ctx->busy_extents);
> -	ctx->sequence = 1;
> -	ctx->cil = cil;
> -	cil->xc_ctx = ctx;
> -	cil->xc_current_sequence = ctx->sequence;
> -
>  	cil->xc_log = log;
>  	log->l_cilp = cil;
> +
> +	ctx = xlog_cil_ctx_alloc();
> +	xlog_cil_ctx_switch(cil, ctx);
> +
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index a4e46258b2aa..bb5fa6b71114 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -245,6 +245,7 @@ struct xfs_cil_ctx {
>  	struct list_head	iclog_entry;
>  	struct list_head	committing;	/* ctx committing list */
>  	struct work_struct	discard_endio_work;
> +	struct work_struct	push_work;
>  };
>  
>  /*
> @@ -277,7 +278,6 @@ struct xfs_cil {
>  	struct list_head	xc_committing;
>  	wait_queue_head_t	xc_commit_wait;
>  	xfs_csn_t		xc_current_sequence;
> -	struct work_struct	xc_push_work;
>  	wait_queue_head_t	xc_push_wait;	/* background push throttle */
>  } ____cacheline_aligned_in_smp;
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ca2cb0448b5e..962f03a541e7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -502,7 +502,7 @@ xfs_init_mount_workqueues(
>  
>  	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
>  			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM | WQ_UNBOUND),
> -			0, mp->m_super->s_id);
> +			4, mp->m_super->s_id);
>  	if (!mp->m_cil_workqueue)
>  		goto out_destroy_unwritten;
>  
> -- 
> 2.28.0
> 
