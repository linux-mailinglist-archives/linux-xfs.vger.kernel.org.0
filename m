Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99745D7CEA
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Oct 2019 19:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfJORHW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Oct 2019 13:07:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfJORHW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Oct 2019 13:07:22 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 276A8693F3;
        Tue, 15 Oct 2019 17:07:22 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B04AB5D6A9;
        Tue, 15 Oct 2019 17:07:21 +0000 (UTC)
Date:   Tue, 15 Oct 2019 13:07:19 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] xfs: call xlog_state_release_iclog with l_icloglock
 held
Message-ID: <20191015170719.GF36108@bfoster>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009142748.18005-5-hch@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 15 Oct 2019 17:07:22 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:27:44PM +0200, Christoph Hellwig wrote:
> All but one caller of xlog_state_release_iclog hold l_icloglock and need
> to drop and reacquire it to call xlog_state_release_iclog.  Switch the
> xlog_state_release_iclog calling conventions to expect the lock to be
> held, and open code the logic (using a shared helper) in the only
> remaining caller that does not have the lock (and where not holding it
> is a nice performance optimization).  Also move the refactored code to
> require the least amount of forward declarations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Modulo the whitespace thing:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 188 +++++++++++++++++++++++------------------------
>  1 file changed, 90 insertions(+), 98 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 860a555772fe..67a767d90ebf 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -57,10 +57,6 @@ xlog_state_get_iclog_space(
>  	struct xlog_ticket	*ticket,
>  	int			*continued_write,
>  	int			*logoffsetp);
> -STATIC int
> -xlog_state_release_iclog(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog);
>  STATIC void
>  xlog_state_switch_iclogs(
>  	struct xlog		*log,
> @@ -83,7 +79,10 @@ STATIC void
>  xlog_ungrant_log_space(
>  	struct xlog		*log,
>  	struct xlog_ticket	*ticket);
> -
> +STATIC void
> +xlog_sync(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog);
>  #if defined(DEBUG)
>  STATIC void
>  xlog_verify_dest_ptr(
> @@ -552,16 +551,71 @@ xfs_log_done(
>  	return lsn;
>  }
>  
> +static bool
> +__xlog_state_release_iclog(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog)
> +{
> +	lockdep_assert_held(&log->l_icloglock);
> +
> +	if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
> +		/* update tail before writing to iclog */
> +		xfs_lsn_t tail_lsn = xlog_assign_tail_lsn(log->l_mp);
> +
> +		iclog->ic_state = XLOG_STATE_SYNCING;
> +		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> +		xlog_verify_tail_lsn(log, iclog, tail_lsn);
> +		/* cycle incremented when incrementing curr_block */
> +		return true;
> +	}
> +
> +	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
> +	return false;
> +}
> +
> +/*
> + * Flush iclog to disk if this is the last reference to the given iclog and the
> + * it is in the WANT_SYNC state.
> + */
> +static int
> +xlog_state_release_iclog(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog)
> +{
> +	lockdep_assert_held(&log->l_icloglock);
> +
> +	if (iclog->ic_state & XLOG_STATE_IOERROR)
> +		return -EIO;
> +
> +	if (atomic_dec_and_test(&iclog->ic_refcnt) &&
> +	    __xlog_state_release_iclog(log, iclog)) {
> +		spin_unlock(&log->l_icloglock);
> +		xlog_sync(log, iclog);
> +		spin_lock(&log->l_icloglock);
> +	}
> +
> +	return 0;
> +}
> +
>  int
>  xfs_log_release_iclog(
> -	struct xfs_mount	*mp,
> +	struct xfs_mount        *mp,
>  	struct xlog_in_core	*iclog)
>  {
> -	if (xlog_state_release_iclog(mp->m_log, iclog)) {
> +	struct xlog		*log = mp->m_log;
> +	bool			sync;
> +
> +	if (iclog->ic_state & XLOG_STATE_IOERROR) {
>  		xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
>  		return -EIO;
>  	}
>  
> +	if (atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock)) {
> +		sync = __xlog_state_release_iclog(log, iclog);
> +		spin_unlock(&log->l_icloglock);
> +		if (sync)
> +			xlog_sync(log, iclog);
> +	}
>  	return 0;
>  }
>  
> @@ -866,10 +920,7 @@ xfs_log_write_unmount_record(
>  	iclog = log->l_iclog;
>  	atomic_inc(&iclog->ic_refcnt);
>  	xlog_state_want_sync(log, iclog);
> -	spin_unlock(&log->l_icloglock);
>  	error = xlog_state_release_iclog(log, iclog);
> -
> -	spin_lock(&log->l_icloglock);
>  	switch (iclog->ic_state) {
>  	default:
>  		if (!XLOG_FORCED_SHUTDOWN(log)) {
> @@ -950,13 +1001,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  		spin_lock(&log->l_icloglock);
>  		iclog = log->l_iclog;
>  		atomic_inc(&iclog->ic_refcnt);
> -
>  		xlog_state_want_sync(log, iclog);
> -		spin_unlock(&log->l_icloglock);
>  		error =  xlog_state_release_iclog(log, iclog);
>  
> -		spin_lock(&log->l_icloglock);
> -
>  		if ( ! (   iclog->ic_state == XLOG_STATE_ACTIVE
>  			|| iclog->ic_state == XLOG_STATE_DIRTY
>  			|| iclog->ic_state == XLOG_STATE_IOERROR) ) {
> @@ -2255,6 +2302,8 @@ xlog_write_copy_finish(
>  	int			log_offset,
>  	struct xlog_in_core	**commit_iclog)
>  {
> +	int			error;
> +
>  	if (*partial_copy) {
>  		/*
>  		 * This iclog has already been marked WANT_SYNC by
> @@ -2262,10 +2311,9 @@ xlog_write_copy_finish(
>  		 */
>  		spin_lock(&log->l_icloglock);
>  		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
> -		spin_unlock(&log->l_icloglock);
>  		*record_cnt = 0;
>  		*data_cnt = 0;
> -		return xlog_state_release_iclog(log, iclog);
> +		goto release_iclog;
>  	}
>  
>  	*partial_copy = 0;
> @@ -2279,15 +2327,19 @@ xlog_write_copy_finish(
>  		*data_cnt = 0;
>  
>  		xlog_state_want_sync(log, iclog);
> -		spin_unlock(&log->l_icloglock);
> -
>  		if (!commit_iclog)
> -			return xlog_state_release_iclog(log, iclog);
> +			goto release_iclog;
> +		spin_unlock(&log->l_icloglock);
>  		ASSERT(flags & XLOG_COMMIT_TRANS);
>  		*commit_iclog = iclog;
>  	}
>  
>  	return 0;
> +
> +release_iclog:
> +	error = xlog_state_release_iclog(log, iclog);
> +	spin_unlock(&log->l_icloglock);
> +	return error;
>  }
>  
>  /*
> @@ -2349,7 +2401,7 @@ xlog_write(
>  	int			contwr = 0;
>  	int			record_cnt = 0;
>  	int			data_cnt = 0;
> -	int			error;
> +	int			error = 0;
>  
>  	*start_lsn = 0;
>  
> @@ -2502,13 +2554,15 @@ xlog_write(
>  
>  	spin_lock(&log->l_icloglock);
>  	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
> +	if (commit_iclog) {
> +		ASSERT(flags & XLOG_COMMIT_TRANS);
> +		*commit_iclog = iclog;
> +	} else {
> +		error = xlog_state_release_iclog(log, iclog);
> +	}
>  	spin_unlock(&log->l_icloglock);
> -	if (!commit_iclog)
> -		return xlog_state_release_iclog(log, iclog);
>  
> -	ASSERT(flags & XLOG_COMMIT_TRANS);
> -	*commit_iclog = iclog;
> -	return 0;
> +	return error;
>  }
>  
>  
> @@ -2979,7 +3033,6 @@ xlog_state_get_iclog_space(
>  	int		  log_offset;
>  	xlog_rec_header_t *head;
>  	xlog_in_core_t	  *iclog;
> -	int		  error;
>  
>  restart:
>  	spin_lock(&log->l_icloglock);
> @@ -3028,24 +3081,22 @@ xlog_state_get_iclog_space(
>  	 * can fit into remaining data section.
>  	 */
>  	if (iclog->ic_size - iclog->ic_offset < 2*sizeof(xlog_op_header_t)) {
> +		int		error = 0;
> +
>  		xlog_state_switch_iclogs(log, iclog, iclog->ic_size);
>  
>  		/*
> -		 * If I'm the only one writing to this iclog, sync it to disk.
> -		 * We need to do an atomic compare and decrement here to avoid
> -		 * racing with concurrent atomic_dec_and_lock() calls in
> +		 * If we are the only one writing to this iclog, sync it to
> +		 * disk.  We need to do an atomic compare and decrement here to
> +		 * avoid racing with concurrent atomic_dec_and_lock() calls in
>  		 * xlog_state_release_iclog() when there is more than one
>  		 * reference to the iclog.
>  		 */
> -		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1)) {
> -			/* we are the only one */
> -			spin_unlock(&log->l_icloglock);
> +		if (!atomic_add_unless(&iclog->ic_refcnt, -1, 1))
>  			error = xlog_state_release_iclog(log, iclog);
> -			if (error)
> -				return error;
> -		} else {
> -			spin_unlock(&log->l_icloglock);
> -		}
> +		spin_unlock(&log->l_icloglock);
> +		if (error)
> +			return error;
>  		goto restart;
>  	}
>  
> @@ -3156,60 +3207,6 @@ xlog_ungrant_log_space(
>  	xfs_log_space_wake(log->l_mp);
>  }
>  
> -/*
> - * Flush iclog to disk if this is the last reference to the given iclog and
> - * the WANT_SYNC bit is set.
> - *
> - * When this function is entered, the iclog is not necessarily in the
> - * WANT_SYNC state.  It may be sitting around waiting to get filled.
> - *
> - *
> - */
> -STATIC int
> -xlog_state_release_iclog(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog)
> -{
> -	int		sync = 0;	/* do we sync? */
> -
> -	if (iclog->ic_state & XLOG_STATE_IOERROR)
> -		return -EIO;
> -
> -	ASSERT(atomic_read(&iclog->ic_refcnt) > 0);
> -	if (!atomic_dec_and_lock(&iclog->ic_refcnt, &log->l_icloglock))
> -		return 0;
> -
> -	if (iclog->ic_state & XLOG_STATE_IOERROR) {
> -		spin_unlock(&log->l_icloglock);
> -		return -EIO;
> -	}
> -	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE ||
> -	       iclog->ic_state == XLOG_STATE_WANT_SYNC);
> -
> -	if (iclog->ic_state == XLOG_STATE_WANT_SYNC) {
> -		/* update tail before writing to iclog */
> -		xfs_lsn_t tail_lsn = xlog_assign_tail_lsn(log->l_mp);
> -		sync++;
> -		iclog->ic_state = XLOG_STATE_SYNCING;
> -		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> -		xlog_verify_tail_lsn(log, iclog, tail_lsn);
> -		/* cycle incremented when incrementing curr_block */
> -	}
> -	spin_unlock(&log->l_icloglock);
> -
> -	/*
> -	 * We let the log lock go, so it's possible that we hit a log I/O
> -	 * error or some other SHUTDOWN condition that marks the iclog
> -	 * as XLOG_STATE_IOERROR before the bwrite. However, we know that
> -	 * this iclog has consistent data, so we ignore IOERROR
> -	 * flags after this point.
> -	 */
> -	if (sync)
> -		xlog_sync(log, iclog);
> -	return 0;
> -}	/* xlog_state_release_iclog */
> -
> -
>  /*
>   * This routine will mark the current iclog in the ring as WANT_SYNC
>   * and move the current iclog pointer to the next iclog in the ring.
> @@ -3333,12 +3330,9 @@ xfs_log_force(
>  			atomic_inc(&iclog->ic_refcnt);
>  			lsn = be64_to_cpu(iclog->ic_header.h_lsn);
>  			xlog_state_switch_iclogs(log, iclog, 0);
> -			spin_unlock(&log->l_icloglock);
> -
>  			if (xlog_state_release_iclog(log, iclog))
> -				return -EIO;
> +				goto out_error;	
>  
> -			spin_lock(&log->l_icloglock);
>  			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn ||
>  			    iclog->ic_state == XLOG_STATE_DIRTY)
>  				goto out_unlock;
> @@ -3433,12 +3427,10 @@ __xfs_log_force_lsn(
>  		}
>  		atomic_inc(&iclog->ic_refcnt);
>  		xlog_state_switch_iclogs(log, iclog, 0);
> -		spin_unlock(&log->l_icloglock);
>  		if (xlog_state_release_iclog(log, iclog))
> -			return -EIO;
> +			goto out_error;
>  		if (log_flushed)
>  			*log_flushed = 1;
> -		spin_lock(&log->l_icloglock);
>  	}
>  
>  	if (!(flags & XFS_LOG_SYNC) ||
> -- 
> 2.20.1
> 
