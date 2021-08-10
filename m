Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11113D65DA
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Jul 2021 19:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbhGZQyz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Jul 2021 12:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234786AbhGZQyx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jul 2021 12:54:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 711E660F6B;
        Mon, 26 Jul 2021 17:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627320921;
        bh=zb7qD6xEXe5VuqSW9/1ne66lAXw1uX8ZE5WKjzO1U6k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fN9VbsnUhjk/lMzjjcnNysO+QJXamuATTcND1Ke41R6xYIwFvW16J0L1iVNxIi4Nv
         YFuW3xJlTYUH19EiMFYOG6TKzLRkiYbcEw1HK6Dw89ng8o5OFQ60/1jtxUrYBKjrdG
         phZFBScs7j+JK+3biA5musosK5mVBsKqa4xgHE9FPsvua4C7L+9ASCpIEHYVkLw5RK
         UjhCvHNYNdk7BPZcRlU/9P3drSTi8ZzjmcTVSkewOKIedwl8TuPQic04xp9pORKFaL
         gsenPoflF4SRyH/vD65kzcBvi2NkhoidETVG45rM8kadZhVJHAT+twDOdIH1ysTXFJ
         GvAKIPyaQAX7g==
Date:   Mon, 26 Jul 2021 10:35:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: fix ordering violation between cache flushes
 and tail updates
Message-ID: <20210726173521.GB559142@magnolia>
References: <20210726060716.3295008-1-david@fromorbit.com>
 <20210726060716.3295008-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726060716.3295008-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 04:07:10PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There is a race between the new CIL async data device metadata IO
> completion cache flush and the log tail in the iclog the flush
> covers being updated. This can be seen by repeating generic/482 in a
> loop and eventually log recovery fails with a failures such as this:
> 
> XFS (dm-3): Starting recovery (logdev: internal)
> XFS (dm-3): bad inode magic/vsn daddr 228352 #0 (magic=0)
> XFS (dm-3): Metadata corruption detected at xfs_inode_buf_verify+0x180/0x190, xfs_inode block 0x37c00 xfs_inode_buf_verify
> XFS (dm-3): Unmount and run xfs_repair
> XFS (dm-3): First 128 bytes of corrupted metadata buffer:
> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> XFS (dm-3): metadata I/O error in "xlog_recover_items_pass2+0x55/0xc0" at daddr 0x37c00 len 32 error 117
> 
> Analysis of the logwrite replay shows that there were no writes to
> the data device between the FUA @ write 124 and the FUA at write @
> 125, but log recovery @ 125 failed. The difference was the one log
> write @ 125 moved the tail of the log forwards from (1,8) to (1,32)
> and so the inode create intent in (1,8) was not replayed and so the
> inode cluster was zero on disk when replay of the first inode item
> in (1,32) was attempted.
> 
> What this meant was that the journal write that occurred at @ 125
> did not ensure that metadata completed before the iclog was written
> was correctly on stable storage. The tail of the log moved forward,
> so IO must have been completed between the two iclog writes. This
> means that there is a race condition between the unconditional async
> cache flush in the CIL push work and the tail LSN that is written to
> the iclog. This happens like so:
> 
> CIL push work				AIL push work
> -------------				-------------
> Add to committing list
> start async data dev cache flush
> .....
> <flush completes>
> <all writes to old tail lsn are stable>
> xlog_write
>   ....					push inode create buffer
> 					<start IO>
> 					.....
> xlog_write(commit record)
>   ....					<IO completes>
>   					log tail moves
>   					  xlog_assign_tail_lsn()
> start_lsn == commit_lsn
>   <no iclog preflush!>
> xlog_state_release_iclog
>   __xlog_state_release_iclog()
>     <writes *new* tail_lsn into iclog>
>   xlog_sync()
>     ....
>     submit_bio()
> <tail in log moves forward without flushing written metadata>
> 
> Essentially, this can only occur if the commit iclog is issued
> without a cache flush. If the iclog bio is submitted with
> REQ_PREFLUSH, then it will guarantee that all the completed IO is
> one stable storage before the iclog bio with the new tail LSN in it
> is written to the log.
> 
> IOWs, the tail lsn that is written to the iclog needs to be sampled
> *before* we issue the cache flush that guarantees all IO up to that
> LSN has been completed.
> 
> To fix this without giving up the performance advantage of the
> flush/FUA optimisations (e.g. g/482 runtime halves with 5.14-rc1
> compared to 5.13), we need to ensure that we always issue a cache
> flush if the tail LSN changes between the initial async flush and
> the commit record being written. THis requires sampling the tail_lsn
> before we start the flush, and then passing the sampled tail LSN to
> xlog_state_release_iclog() so it can determine if the the tail LSN
> has changed while writing the checkpoint. If the tail LSN has
> changed, then it needs to set the NEED_FLUSH flag on the iclog and
> we'll issue another cache flush before writing the iclog.
> 
> Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 39 +++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_log_cil.c  | 13 +++++++++++--
>  fs/xfs/xfs_log_priv.h |  3 ++-
>  3 files changed, 42 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 82f5996d3889..1f8c00e40c53 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -489,12 +489,20 @@ xfs_log_reserve(
>  
>  /*
>   * Flush iclog to disk if this is the last reference to the given iclog and the
> - * it is in the WANT_SYNC state.
> + * it is in the WANT_SYNC state. If the caller passes in a non-zero

I've noticed that the log code isn't always consistent about special
looking LSNs -- some places use NULLCOMMITLSN, some places opencode
(xfs_lsn_t)-1, and other code uses zero.  Is there some historical
reason for having these distinct values?  Or do they actually mean
separate things?

> + * @old_tail_lsn, then we need to check if the log tail is different to the
> + * caller's value. If it is different, this indicates that the log tail has
> + * moved since the caller sampled the log tail and issued a cache flush and so
> + * there may be metadata on disk that we need to flush before this iclog is

"If the caller passes in a non-zero @old_tail_lsn and the current log
tail does not match, there may be metadata on disk that must be
persisted before this iclog is written.  To satisfy that requirement,
set the XLOG_ICL_NEED_FLUSH flag as a condition for writing this iclog
with the new log tail value." ?

Those were the only quibbles I had; the logic looks good to me.

--D

> + * written. In that case, set the XLOG_ICL_NEED_FLUSH flag so that when the
> + * iclog is synced we correctly issue a cache flush before the iclog is
> + * submitted.
>   */
>  int
>  xlog_state_release_iclog(
>  	struct xlog		*log,
> -	struct xlog_in_core	*iclog)
> +	struct xlog_in_core	*iclog,
> +	xfs_lsn_t		old_tail_lsn)
>  {
>  	xfs_lsn_t		tail_lsn;
>  	lockdep_assert_held(&log->l_icloglock);
> @@ -503,6 +511,19 @@ xlog_state_release_iclog(
>  	if (iclog->ic_state == XLOG_STATE_IOERROR)
>  		return -EIO;
>  
> +	/*
> +	 * Grabbing the current log tail needs to be atomic w.r.t. the writing
> +	 * of the tail LSN into the iclog so we guarantee that the log tail does
> +	 * not move between deciding if a cache flush is required and writing
> +	 * the LSN into the iclog below.
> +	 */
> +	if (old_tail_lsn || iclog->ic_state == XLOG_STATE_WANT_SYNC) {
> +		tail_lsn = xlog_assign_tail_lsn(log->l_mp);
> +
> +		if (old_tail_lsn && tail_lsn != old_tail_lsn)
> +			iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
> +	}
> +
>  	if (!atomic_dec_and_test(&iclog->ic_refcnt))
>  		return 0;
>  
> @@ -511,8 +532,6 @@ xlog_state_release_iclog(
>  		return 0;
>  	}
>  
> -	/* update tail before writing to iclog */
> -	tail_lsn = xlog_assign_tail_lsn(log->l_mp);
>  	iclog->ic_state = XLOG_STATE_SYNCING;
>  	iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
>  	xlog_verify_tail_lsn(log, iclog, tail_lsn);
> @@ -858,7 +877,7 @@ xlog_unmount_write(
>  	 * iclog containing the unmount record is written.
>  	 */
>  	iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
> -	error = xlog_state_release_iclog(log, iclog);
> +	error = xlog_state_release_iclog(log, iclog, 0);
>  	xlog_wait_on_iclog(iclog);
>  
>  	if (tic) {
> @@ -2302,7 +2321,7 @@ xlog_write_copy_finish(
>  	return 0;
>  
>  release_iclog:
> -	error = xlog_state_release_iclog(log, iclog);
> +	error = xlog_state_release_iclog(log, iclog, 0);
>  	spin_unlock(&log->l_icloglock);
>  	return error;
>  }
> @@ -2521,7 +2540,7 @@ xlog_write(
>  		ASSERT(optype & XLOG_COMMIT_TRANS);
>  		*commit_iclog = iclog;
>  	} else {
> -		error = xlog_state_release_iclog(log, iclog);
> +		error = xlog_state_release_iclog(log, iclog, 0);
>  	}
>  	spin_unlock(&log->l_icloglock);
>  
> @@ -2959,7 +2978,7 @@ xlog_state_get_iclog_space(
>  		 * reference to the iclog.
>  		 */
>  		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1))
> -			error = xlog_state_release_iclog(log, iclog);
> +			error = xlog_state_release_iclog(log, iclog, 0);
>  		spin_unlock(&log->l_icloglock);
>  		if (error)
>  			return error;
> @@ -3195,7 +3214,7 @@ xfs_log_force(
>  			atomic_inc(&iclog->ic_refcnt);
>  			lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  			xlog_state_switch_iclogs(log, iclog, 0);
> -			if (xlog_state_release_iclog(log, iclog))
> +			if (xlog_state_release_iclog(log, iclog, 0))
>  				goto out_error;
>  
>  			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
> @@ -3275,7 +3294,7 @@ xlog_force_lsn(
>  		}
>  		atomic_inc(&iclog->ic_refcnt);
>  		xlog_state_switch_iclogs(log, iclog, 0);
> -		if (xlog_state_release_iclog(log, iclog))
> +		if (xlog_state_release_iclog(log, iclog, 0))
>  			goto out_error;
>  		if (log_flushed)
>  			*log_flushed = 1;
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index b128aaa9b870..4c44bc3786c0 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -654,8 +654,9 @@ xlog_cil_push_work(
>  	struct xfs_trans_header thdr;
>  	struct xfs_log_iovec	lhdr;
>  	struct xfs_log_vec	lvhdr = { NULL };
> +	xfs_lsn_t		preflush_tail_lsn;
>  	xfs_lsn_t		commit_lsn;
> -	xfs_lsn_t		push_seq;
> +	xfs_csn_t		push_seq;
>  	struct bio		bio;
>  	DECLARE_COMPLETION_ONSTACK(bdev_flush);
>  
> @@ -730,7 +731,15 @@ xlog_cil_push_work(
>  	 * because we hold the flush lock exclusively. Hence we can now issue
>  	 * a cache flush to ensure all the completed metadata in the journal we
>  	 * are about to overwrite is on stable storage.
> +	 *
> +	 * Because we are issuing this cache flush before we've written the
> +	 * tail lsn to the iclog, we can have metadata IO completions move the
> +	 * tail forwards between the completion of this flush and the iclog
> +	 * being written. In this case, we need to re-issue the cache flush
> +	 * before the iclog write. To detect whether the log tail moves, sample
> +	 * the tail LSN *before* we issue the flush.
>  	 */
> +	preflush_tail_lsn = atomic64_read(&log->l_tail_lsn);
>  	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
>  				&bdev_flush);
>  
> @@ -941,7 +950,7 @@ xlog_cil_push_work(
>  	 * storage.
>  	 */
>  	commit_iclog->ic_flags |= XLOG_ICL_NEED_FUA;
> -	xlog_state_release_iclog(log, commit_iclog);
> +	xlog_state_release_iclog(log, commit_iclog, preflush_tail_lsn);
>  	spin_unlock(&log->l_icloglock);
>  	return;
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 4c41bbfa33b0..7cbde0b4f990 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -497,7 +497,8 @@ int	xlog_commit_record(struct xlog *log, struct xlog_ticket *ticket,
>  void	xfs_log_ticket_ungrant(struct xlog *log, struct xlog_ticket *ticket);
>  void	xfs_log_ticket_regrant(struct xlog *log, struct xlog_ticket *ticket);
>  
> -int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog);
> +int xlog_state_release_iclog(struct xlog *log, struct xlog_in_core *iclog,
> +		xfs_lsn_t log_tail_lsn);
>  
>  /*
>   * When we crack an atomic LSN, we sample it first so that the value will not
> -- 
> 2.31.1
> 
