Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBB74EA45E
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Mar 2022 03:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbiC2Ava (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 28 Mar 2022 20:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiC2Av3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 20:51:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45B560D9D
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 17:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C18E61164
        for <linux-xfs@vger.kernel.org>; Tue, 29 Mar 2022 00:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8D2C340ED;
        Tue, 29 Mar 2022 00:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648514986;
        bh=WfwcZ9We5mFOlPAuIZTLzbquBZ3BeE0aJoWPI5Y7S5U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NjcfzhJrNeXLquAorTSK6Cif0mpsqUmTNF2fWq9hxFhxJzZs7tFuWouXVGVgkHxDS
         g0isGbwCSQzjs2rCAQJvVJM1BucIiAjC69k/TH4AdeOPA3eQQkYEI/BOqwCaCMTCj7
         FMLTf1xMLbZadIzNt59FhvEfKIctcmT3vTT8cYedmlIny7d0cANYPPpqpljm+KsKIo
         zgBFchDiJRIe9Mpm8s/FnlxY0yEJUVgCFxnpJ8jxmdGCy/uww0gk5L2AbIa6QlZfmK
         7rxDjrHZA6eHAzfXPoHm0ju00f5FtrtXiw/2ZXScHGZGISVYcMhjeckJ+BuGSSZQtG
         LUIhAJ2JL7qGg==
Date:   Mon, 28 Mar 2022 17:49:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org
Subject: Re: [PATCHi v2] xfs: drop async cache flushes from CIL commits.
Message-ID: <20220329004946.GE27713@magnolia>
References: <20220317051219.137547-1-david@fromorbit.com>
 <20220317091247.ajk3astyxmmghrsf@quack3.lan>
 <20220318010339.GD1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318010339.GD1544202@dread.disaster.area>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 18, 2022 at 12:03:39PM +1100, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Jan Kara reported a performance regression in dbench that he
> bisected down to commit bad77c375e8d ("xfs: CIL checkpoint
> flushes caches unconditionally").
> 
> Whilst developing the journal flush/fua optimisations this cache was
> part of, it appeared to made a significant difference to
> performance. However, now that this patchset has settled and all the
> correctness issues fixed, there does not appear to be any
> significant performance benefit to asynchronous cache flushes.
> 
> In fact, the opposite is true on some storage types and workloads,
> where additional cache flushes that can occur from fsync heavy
> workloads have measurable and significant impact on overall
> throughput.
> 
> Local dbench testing shows little difference on dbench runs with
> sync vs async cache flushes on either fast or slow SSD storage, and
> no difference in streaming concurrent async transaction workloads
> like fs-mark.
> 
> Fast NVME storage.
> 
> From `dbench -t 30`, CIL scale:
> 
> clients		async			sync
> 		BW	Latency		BW	Latency
> 1		 935.18   0.855		 915.64   0.903
> 8		2404.51   6.873		2341.77   6.511
> 16		3003.42   6.460		2931.57   6.529
> 32		3697.23   7.939		3596.28   7.894
> 128		7237.43  15.495		7217.74  11.588
> 512		5079.24  90.587		5167.08  95.822
> 
> fsmark, 32 threads, create w/ 64 byte xattr w/32k logbsize
> 
> 	create		chown		unlink
> async   1m41s		1m16s		2m03s
> sync	1m40s		1m19s		1m54s
> 
> Slower SATA SSD storage:
> 
> From `dbench -t 30`, CIL scale:
> 
> clients		async			sync
> 		BW	Latency		BW	Latency
> 1		  78.59  15.792		  83.78  10.729
> 8		 367.88  92.067		 404.63  59.943
> 16		 564.51  72.524		 602.71  76.089
> 32		 831.66 105.984		 870.26 110.482
> 128		1659.76 102.969		1624.73  91.356
> 512		2135.91 223.054		2603.07 161.160
> 
> fsmark, 16 threads, create w/32k logbsize
> 
> 	create		unlink
> async   5m06s		4m15s
> sync	5m00s		4m22s
> 
> And on Jan's test machine:
> 
>                    5.18-rc8-vanilla       5.18-rc8-patched
> Amean     1        71.22 (   0.00%)       64.94 *   8.81%*
> Amean     2        93.03 (   0.00%)       84.80 *   8.85%*
> Amean     4       150.54 (   0.00%)      137.51 *   8.66%*
> Amean     8       252.53 (   0.00%)      242.24 *   4.08%*
> Amean     16      454.13 (   0.00%)      439.08 *   3.31%*
> Amean     32      835.24 (   0.00%)      829.74 *   0.66%*
> Amean     64     1740.59 (   0.00%)     1686.73 *   3.09%*
> 
> Performance and cache flush behaviour is restored to pre-regression
> levels.
> 
> As such, we can now consider the async cache flush mechanism an
> unnecessary exercise in premature optimisation and hence we can
> now remove it and the infrastructure it requires completely.
> 
> Fixes: bad77c375e8d ("xfs: CIL checkpoint flushes caches unconditionally")
> Reported-and-tested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

When I reviwed bad77, I'd hoped that we'd gotten past the point where
various storage hardware would stall on any cache flush, even if there
wasn't anything dirty in those caches, which made asynchronous flushes
counterproductive.

(This is dredging up memories of the Wall of Disks at IBM...)

Ah well, async preflushes was a fun experiment.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> Version 2:
> - really get rid of all the commented out code. (Thanks Jan!)
> 
>  fs/xfs/xfs_bio_io.c   | 35 -----------------------------------
>  fs/xfs/xfs_linux.h    |  2 --
>  fs/xfs/xfs_log.c      | 36 +++++++++++-------------------------
>  fs/xfs/xfs_log_cil.c  | 42 +++++++++++++-----------------------------
>  fs/xfs/xfs_log_priv.h |  3 +--
>  5 files changed, 25 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> index 667e297f59b1..17f36db2f792 100644
> --- a/fs/xfs/xfs_bio_io.c
> +++ b/fs/xfs/xfs_bio_io.c
> @@ -9,41 +9,6 @@ static inline unsigned int bio_max_vecs(unsigned int count)
>  	return bio_max_segs(howmany(count, PAGE_SIZE));
>  }
>  
> -static void
> -xfs_flush_bdev_async_endio(
> -	struct bio	*bio)
> -{
> -	complete(bio->bi_private);
> -}
> -
> -/*
> - * Submit a request for an async cache flush to run. If the request queue does
> - * not require flush operations, just skip it altogether. If the caller needs
> - * to wait for the flush completion at a later point in time, they must supply a
> - * valid completion. This will be signalled when the flush completes.  The
> - * caller never sees the bio that is issued here.
> - */
> -void
> -xfs_flush_bdev_async(
> -	struct bio		*bio,
> -	struct block_device	*bdev,
> -	struct completion	*done)
> -{
> -	struct request_queue	*q = bdev->bd_disk->queue;
> -
> -	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
> -		complete(done);
> -		return;
> -	}
> -
> -	bio_init(bio, NULL, 0);
> -	bio_set_dev(bio, bdev);
> -	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
> -	bio->bi_private = done;
> -	bio->bi_end_io = xfs_flush_bdev_async_endio;
> -
> -	submit_bio(bio);
> -}
>  int
>  xfs_rw_bdev(
>  	struct block_device	*bdev,
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 09a8fba84ff9..cb9105d667db 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -197,8 +197,6 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
>  
>  int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
>  		char *data, unsigned int op);
> -void xfs_flush_bdev_async(struct bio *bio, struct block_device *bdev,
> -		struct completion *done);
>  
>  #define ASSERT_ALWAYS(expr)	\
>  	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 89fec9a18c34..40419e8fedad 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -523,12 +523,6 @@ xlog_state_shutdown_callbacks(
>   * Flush iclog to disk if this is the last reference to the given iclog and the
>   * it is in the WANT_SYNC state.
>   *
> - * If the caller passes in a non-zero @old_tail_lsn and the current log tail
> - * does not match, there may be metadata on disk that must be persisted before
> - * this iclog is written.  To satisfy that requirement, set the
> - * XLOG_ICL_NEED_FLUSH flag as a condition for writing this iclog with the new
> - * log tail value.
> - *
>   * If XLOG_ICL_NEED_FUA is already set on the iclog, we need to ensure that the
>   * log tail is updated correctly. NEED_FUA indicates that the iclog will be
>   * written to stable storage, and implies that a commit record is contained
> @@ -545,12 +539,10 @@ xlog_state_shutdown_callbacks(
>   * always capture the tail lsn on the iclog on the first NEED_FUA release
>   * regardless of the number of active reference counts on this iclog.
>   */
> -
>  int
>  xlog_state_release_iclog(
>  	struct xlog		*log,
> -	struct xlog_in_core	*iclog,
> -	xfs_lsn_t		old_tail_lsn)
> +	struct xlog_in_core	*iclog)
>  {
>  	xfs_lsn_t		tail_lsn;
>  	bool			last_ref;
> @@ -561,18 +553,14 @@ xlog_state_release_iclog(
>  	/*
>  	 * Grabbing the current log tail needs to be atomic w.r.t. the writing
>  	 * of the tail LSN into the iclog so we guarantee that the log tail does
> -	 * not move between deciding if a cache flush is required and writing
> -	 * the LSN into the iclog below.
> +	 * not move between the first time we know that the iclog needs to be
> +	 * made stable and when we eventually submit it.
>  	 */
> -	if (old_tail_lsn || iclog->ic_state == XLOG_STATE_WANT_SYNC) {
> +	if ((iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> +	     (iclog->ic_flags & XLOG_ICL_NEED_FUA)) &&
> +	    !iclog->ic_header.h_tail_lsn) {
>  		tail_lsn = xlog_assign_tail_lsn(log->l_mp);
> -
> -		if (old_tail_lsn && tail_lsn != old_tail_lsn)
> -			iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
> -
> -		if ((iclog->ic_flags & XLOG_ICL_NEED_FUA) &&
> -		    !iclog->ic_header.h_tail_lsn)
> -			iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> +		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
>  	}
>  
>  	last_ref = atomic_dec_and_test(&iclog->ic_refcnt);
> @@ -600,8 +588,6 @@ xlog_state_release_iclog(
>  	}
>  
>  	iclog->ic_state = XLOG_STATE_SYNCING;
> -	if (!iclog->ic_header.h_tail_lsn)
> -		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
>  	xlog_verify_tail_lsn(log, iclog);
>  	trace_xlog_iclog_syncing(iclog, _RET_IP_);
>  
> @@ -874,7 +860,7 @@ xlog_force_iclog(
>  	iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
>  	if (iclog->ic_state == XLOG_STATE_ACTIVE)
>  		xlog_state_switch_iclogs(iclog->ic_log, iclog, 0);
> -	return xlog_state_release_iclog(iclog->ic_log, iclog, 0);
> +	return xlog_state_release_iclog(iclog->ic_log, iclog);
>  }
>  
>  /*
> @@ -2412,7 +2398,7 @@ xlog_write_copy_finish(
>  		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
>  			xlog_is_shutdown(log));
>  release_iclog:
> -	error = xlog_state_release_iclog(log, iclog, 0);
> +	error = xlog_state_release_iclog(log, iclog);
>  	spin_unlock(&log->l_icloglock);
>  	return error;
>  }
> @@ -2629,7 +2615,7 @@ xlog_write(
>  
>  	spin_lock(&log->l_icloglock);
>  	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
> -	error = xlog_state_release_iclog(log, iclog, 0);
> +	error = xlog_state_release_iclog(log, iclog);
>  	spin_unlock(&log->l_icloglock);
>  
>  	return error;
> @@ -3053,7 +3039,7 @@ xlog_state_get_iclog_space(
>  		 * reference to the iclog.
>  		 */
>  		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1))
> -			error = xlog_state_release_iclog(log, iclog, 0);
> +			error = xlog_state_release_iclog(log, iclog);
>  		spin_unlock(&log->l_icloglock);
>  		if (error)
>  			return error;
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 83a039762b81..148ccd145916 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -705,11 +705,21 @@ xlog_cil_set_ctx_write_state(
>  		 * The LSN we need to pass to the log items on transaction
>  		 * commit is the LSN reported by the first log vector write, not
>  		 * the commit lsn. If we use the commit record lsn then we can
> -		 * move the tail beyond the grant write head.
> +		 * move the grant write head beyond the tail LSN and overwrite
> +		 * it.
>  		 */
>  		ctx->start_lsn = lsn;
>  		wake_up_all(&cil->xc_start_wait);
>  		spin_unlock(&cil->xc_push_lock);
> +
> +		/*
> +		 * Make sure the metadata we are about to overwrite in the log
> +		 * has been flushed to stable storage before this iclog is
> +		 * issued.
> +		 */
> +		spin_lock(&cil->xc_log->l_icloglock);
> +		iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
> +		spin_unlock(&cil->xc_log->l_icloglock);
>  		return;
>  	}
>  
> @@ -888,10 +898,7 @@ xlog_cil_push_work(
>  	struct xfs_trans_header thdr;
>  	struct xfs_log_iovec	lhdr;
>  	struct xfs_log_vec	lvhdr = { NULL };
> -	xfs_lsn_t		preflush_tail_lsn;
>  	xfs_csn_t		push_seq;
> -	struct bio		bio;
> -	DECLARE_COMPLETION_ONSTACK(bdev_flush);
>  	bool			push_commit_stable;
>  
>  	new_ctx = xlog_cil_ctx_alloc();
> @@ -961,23 +968,6 @@ xlog_cil_push_work(
>  	list_add(&ctx->committing, &cil->xc_committing);
>  	spin_unlock(&cil->xc_push_lock);
>  
> -	/*
> -	 * The CIL is stable at this point - nothing new will be added to it
> -	 * because we hold the flush lock exclusively. Hence we can now issue
> -	 * a cache flush to ensure all the completed metadata in the journal we
> -	 * are about to overwrite is on stable storage.
> -	 *
> -	 * Because we are issuing this cache flush before we've written the
> -	 * tail lsn to the iclog, we can have metadata IO completions move the
> -	 * tail forwards between the completion of this flush and the iclog
> -	 * being written. In this case, we need to re-issue the cache flush
> -	 * before the iclog write. To detect whether the log tail moves, sample
> -	 * the tail LSN *before* we issue the flush.
> -	 */
> -	preflush_tail_lsn = atomic64_read(&log->l_tail_lsn);
> -	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
> -				&bdev_flush);
> -
>  	/*
>  	 * Pull all the log vectors off the items in the CIL, and remove the
>  	 * items from the CIL. We don't need the CIL lock here because it's only
> @@ -1054,12 +1044,6 @@ xlog_cil_push_work(
>  	lvhdr.lv_iovecp = &lhdr;
>  	lvhdr.lv_next = ctx->lv_chain;
>  
> -	/*
> -	 * Before we format and submit the first iclog, we have to ensure that
> -	 * the metadata writeback ordering cache flush is complete.
> -	 */
> -	wait_for_completion(&bdev_flush);
> -
>  	error = xlog_cil_write_chain(ctx, &lvhdr);
>  	if (error)
>  		goto out_abort_free_ticket;
> @@ -1118,7 +1102,7 @@ xlog_cil_push_work(
>  	if (push_commit_stable &&
>  	    ctx->commit_iclog->ic_state == XLOG_STATE_ACTIVE)
>  		xlog_state_switch_iclogs(log, ctx->commit_iclog, 0);
> -	xlog_state_release_iclog(log, ctx->commit_iclog, preflush_tail_lsn);
> +	xlog_state_release_iclog(log, ctx->commit_iclog);
>  
>  	/* Not safe to reference ctx now! */
>  
> @@ -1139,7 +1123,7 @@ xlog_cil_push_work(
>  		return;
>  	}
>  	spin_lock(&log->l_icloglock);
> -	xlog_state_release_iclog(log, ctx->commit_iclog, 0);
> +	xlog_state_release_iclog(log, ctx->commit_iclog);
>  	/* Not safe to reference ctx now! */
>  	spin_unlock(&log->l_icloglock);
>  }
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 23103d68423c..80d77aac6fe4 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -524,8 +524,7 @@ void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
>  
>  void xlog_state_switch_iclogs(struct xlog *log, struct xlog_in_core *iclog,
>  		int eventual_size);
> -int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog,
> -		xfs_lsn_t log_tail_lsn);
> +int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog);
>  
>  /*
>   * When we crack an atomic LSN, we sample it first so that the value will not
