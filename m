Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC6A3B49E6
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Jun 2021 23:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhFYVFN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Jun 2021 17:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhFYVFL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 Jun 2021 17:05:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBF1461952;
        Fri, 25 Jun 2021 21:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624654970;
        bh=TX55pgx16kXHPQyJsJd773GYrTxqJ7UdC1GptbEPcuc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=njzOCPQhYgRrLejLqYjd3sOmoyZwXA2bOxp9vgQaTZTvGg5CVNVNo772gzkg5Gsb+
         2rgep86AWCZwcJaQBdKz+tPDNVVR7I3ITglAhpVh0I9rPjPFMWAWmSVWSbdZS+OPWy
         /8mYkUSqyl6zaIPmvIKxdR3WJAKciLiTqpQuXAu5h1EA3yWFpQlGlrDE7lT3efMczP
         TsY6U8z1BidVo9VW86pjiG0eQ28QyarFi4AKxKAaPs5RM71wXAfAt+qWvgzZwIWh/t
         LgHldCn/CKfD6u1fHEdIpqFXTP6B0IbW/flRFsdiK0ZqanNuCw0zOjf8HLVybApJ/8
         zDgsiMxNblL1w==
Date:   Fri, 25 Jun 2021 14:02:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: don't wait on future iclogs when pushing the CIL
Message-ID: <20210625210249.GE13784@locust>
References: <20210622040604.1290539-1-david@fromorbit.com>
 <20210622040604.1290539-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622040604.1290539-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 22, 2021 at 02:06:04PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The iclogbuf ring attached to the struct xlog is circular, hence the
> first and last iclogs in the ring can only be determined by
> comparing them against the log->l_iclog pointer.
> 
> In xfs_cil_push_work(), we want to wait on previous iclogs that were
> issued so that we can flush them to stable storage with the commit
> record write, and it simply waits on the previous iclog in the ring.
> This, however, leads to CIL push hangs in generic/019 like so:
> 
> task:kworker/u33:0   state:D stack:12680 pid:    7 ppid:     2 flags:0x00004000
> Workqueue: xfs-cil/pmem1 xlog_cil_push_work
> Call Trace:
>  __schedule+0x30b/0x9f0
>  schedule+0x68/0xe0
>  xlog_wait_on_iclog+0x121/0x190
>  ? wake_up_q+0xa0/0xa0
>  xlog_cil_push_work+0x994/0xa10
>  ? _raw_spin_lock+0x15/0x20
>  ? xfs_swap_extents+0x920/0x920
>  process_one_work+0x1ab/0x390
>  worker_thread+0x56/0x3d0
>  ? rescuer_thread+0x3c0/0x3c0
>  kthread+0x14d/0x170
>  ? __kthread_bind_mask+0x70/0x70
>  ret_from_fork+0x1f/0x30
> 
> With other threads blocking in either xlog_state_get_iclog_space()
> waiting for iclog space or xlog_grant_head_wait() waiting for log
> reservation space.
> 
> The problem here is that the previous iclog on the ring might
> actually be a future iclog. That is, if log->l_iclog points at
> commit_iclog, commit_iclog is the first (oldest) iclog in the ring
> and there are no previous iclogs pending as they have all completed
> their IO and been activated again. IOWs, commit_iclog->ic_prev
> points to an iclog that will be written in the future, not one that
> has been written in the past.
> 
> Hence, in this case, waiting on the ->ic_prev iclog is incorrect
> behaviour, and depending on the state of the future iclog, we can
> end up with a circular ABA wait cycle and we hang.
> 
> The fix is made more complex by the fact that many iclogs states
> cannot be used to determine if the iclog is a past or future iclog.
> Hence we have to determine past iclogs by checking the LSN of the
> iclog rather than their state. A past ACTIVE iclog will have a LSN
> of zero, while a future ACTIVE iclog will have a LSN greater than
> the current iclog. We don't wait on either of these cases.
> 
> Similarly, a future iclog that hasn't completed IO will have an LSN
> greater than the current iclog and so we don't wait on them. A past
> iclog that is still undergoing IO completion will have a LSN less
> than the current iclog and those are the only iclogs that we need to
> wait on.
> 
> Hence we can use the iclog LSN to determine what iclogs we need to
> wait on here.
> 
> Fixes: 5fd9256ce156 ("xfs: separate CIL commit record IO")
> Reported-by: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Ok, looks good to me.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_cil.c | 35 ++++++++++++++++++++++++++++-------
>  1 file changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 27bed1d9cf29..83a932878177 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -877,7 +877,7 @@ xlog_cil_push_work(
>  	 * Once we attach the ctx to the iclog, a shutdown can process the
>  	 * iclog, run the callbacks and free the ctx. The only thing preventing
>  	 * this potential UAF situation here is that we are holding the
> -	 * icloglock. Hence we cannot access the ctx after we have attached the
> +	 * icloglock. Hence we cannot access the ctx once we have attached the
>  	 * callbacks and dropped the icloglock.
>  	 */
>  	spin_lock(&log->l_icloglock);
> @@ -900,17 +900,38 @@ xlog_cil_push_work(
>  	spin_unlock(&cil->xc_push_lock);
>  
>  	/*
> -	 * If the checkpoint spans multiple iclogs, wait for all previous
> -	 * iclogs to complete before we submit the commit_iclog. In this case,
> -	 * the commit_iclog write needs to issue a pre-flush so that the
> -	 * ordering is correctly preserved down to stable storage.
> +	 * If the checkpoint spans multiple iclogs, wait for all previous iclogs
> +	 * to complete before we submit the commit_iclog. We can't use state
> +	 * checks for this - ACTIVE can be either a past completed iclog or a
> +	 * future iclog being filled, while WANT_SYNC through SYNC_DONE can be a
> +	 * past or future iclog awaiting IO or ordered IO completion to be run.
> +	 * In the latter case, if it's a future iclog and we wait on it, the we
> +	 * will hang because it won't get processed through to ic_force_wait
> +	 * wakeup until this commit_iclog is written to disk.  Hence we use the
> +	 * iclog header lsn and compare it to the commit lsn to determine if we
> +	 * need to wait on iclogs or not.
>  	 *
>  	 * NOTE: It is not safe reference the ctx after this check as we drop
>  	 * the icloglock if we have to wait for completion of other iclogs.
>  	 */
>  	if (ctx->start_lsn != commit_lsn) {
> -		xlog_wait_on_iclog(commit_iclog->ic_prev);
> -		spin_lock(&log->l_icloglock);
> +		xfs_lsn_t	plsn;
> +
> +		plsn = be64_to_cpu(commit_iclog->ic_prev->ic_header.h_lsn);
> +		if (plsn && XFS_LSN_CMP(plsn, commit_lsn) < 0) {
> +			/*
> +			 * Waiting on ic_force_wait orders the completion of
> +			 * iclogs older than ic_prev. Hence we only need to wait
> +			 * on the most recent older iclog here.
> +			 */
> +			xlog_wait_on_iclog(commit_iclog->ic_prev);
> +			spin_lock(&log->l_icloglock);
> +		}
> +
> +		/*
> +		 * We need to issue a pre-flush so that the ordering for this
> +		 * checkpoint is correctly preserved down to stable storage.
> +		 */
>  		commit_iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
>  	}
>  
> -- 
> 2.31.1
> 
