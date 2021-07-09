Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF843C1E89
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Jul 2021 06:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhGIEnD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Jul 2021 00:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhGIEnD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Jul 2021 00:43:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 663A961448;
        Fri,  9 Jul 2021 04:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625805620;
        bh=a3cfjnL8s49rfmCP6y9O3/YfYows0HFvHtDhVNbZzMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BywpIVR9umXCfPiNbcFrLxXmWPuqTNFIhEeihxGWxeVcks1EnVlMowUEXKtDiC61b
         Ji6p8Tb+EP2hpOImZpf3arZM/TVLiAWmNvcFqQTwqQQjCfIUXDOUhy9lMnj8+qRN8l
         St5hy2/tEumSvYPs1jWXAM/3fVE7dExpO5EUCCJli39C0m38ve52jXfW7eE7GHgUnR
         IKpqY5rUtp3JNX9ONKzRKMF6R6c7cAOdl8Uu3MdtLThjKmIYxglgxDsrWRhLalairE
         cvRTV16GXcSfL08LI5TMXnR0DRUmX5usmLPWpPAtPHANeSi98Zb6Bg/bZmHntP5XYU
         jBR20mV1TIRtA==
Date:   Thu, 8 Jul 2021 21:40:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: make forced shutdown processing atomic
Message-ID: <20210709044020.GX11588@locust>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630063813.1751007-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 30, 2021 at 04:38:09PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The running of a forced shutdown is a bit of a mess. It does racy
> checks for XFS_MOUNT_SHUTDOWN in xfs_do_force_shutdown(), then
> does more racy checks in xfs_log_force_unmount() before finally
> setting XFS_MOUNT_SHUTDOWN and XLOG_IO_ERROR under the
> log->icloglock.
> 
> Move the checking and setting of XFS_MOUNT_SHUTDOWN into
> xfs_do_force_shutdown() so we only process a shutdown once and once
> only. Serialise this with the mp->m_sb_lock spinlock so that the
> state change is atomic and won't race. Move all the mount specific

Assuming you're working on cleaning /that/ up too, I'll let that go...

> shutdown state changes from xfs_log_force_unmount() to
> xfs_do_force_shutdown() so they are done atomically with setting
> XFS_MOUNT_SHUTDOWN.
> 
> Then get rid of the racy xlog_is_shutdown() check from
> xlog_force_shutdown(), and gate the log shutdown on the
> test_and_set_bit(XLOG_IO_ERROR) test under the icloglock. This
> means that the log is shutdown once and once only, and code that
> needs to prevent races with shutdown can do so by holding the
> icloglock and checking the return value of xlog_is_shutdown().
> 
> This results in a predicable shutdown execution process - we set the

s/predicable/predictable/

> shutdown flags once and process the shutdown once rather than the
> current "as many concurrent shutdowns as can race to the flag
> setting" situation we have now.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c |  64 ++++++++++++++---------------
>  fs/xfs/xfs_log.c   | 100 ++++++++++++++++++++-------------------------
>  fs/xfs/xfs_log.h   |   2 +-
>  3 files changed, 77 insertions(+), 89 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 6ed29b158312..caca391ce1a9 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -511,6 +511,11 @@ xfs_fs_goingdown(
>   * consistent. We don't do an unmount here; just shutdown the shop, make sure
>   * that absolutely nothing persistent happens to this filesystem after this
>   * point.
> + *
> + * The shutdown state change is atomic, resulting in the first and only the
> + * first shutdown call processing the shutdown. This means we only shutdown the
> + * log once as it requires, and we don't spam the logs when multiple concurrent
> + * shutdowns race to set the shutdown flags.
>   */
>  void
>  xfs_do_force_shutdown(
> @@ -519,48 +524,41 @@ xfs_do_force_shutdown(
>  	char		*fname,
>  	int		lnnum)
>  {
> -	bool		logerror = flags & SHUTDOWN_LOG_IO_ERROR;
> -
> -	/*
> -	 * No need to duplicate efforts.
> -	 */
> -	if (XFS_FORCED_SHUTDOWN(mp) && !logerror)
> -		return;
> -
> -	/*
> -	 * This flags XFS_MOUNT_FS_SHUTDOWN, makes sure that we don't
> -	 * queue up anybody new on the log reservations, and wakes up
> -	 * everybody who's sleeping on log reservations to tell them
> -	 * the bad news.
> -	 */
> -	if (xfs_log_force_umount(mp, logerror))
> -		return;
> +	int		tag;
> +	const char	*why;
>  
> -	if (flags & SHUTDOWN_FORCE_UMOUNT) {
> -		xfs_alert(mp,
> -"User initiated shutdown (0x%x) received. Shutting down filesystem",
> -				flags);
> +	spin_lock(&mp->m_sb_lock);
> +	if (XFS_FORCED_SHUTDOWN(mp)) {
> +		spin_unlock(&mp->m_sb_lock);
>  		return;
>  	}
> +	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
> +	if (mp->m_sb_bp)
> +		mp->m_sb_bp->b_flags |= XBF_DONE;
> +	spin_unlock(&mp->m_sb_lock);
> +
> +	if (flags & SHUTDOWN_FORCE_UMOUNT)
> +		xfs_alert(mp, "User initiated shutdown received.");
>  
> -	if (flags & SHUTDOWN_CORRUPT_INCORE) {
> -		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
> -"Corruption of in-memory data (0x%x) detected at %pS (%s:%d).  Shutting down filesystem",
> -				flags, __return_address, fname, lnnum);
> -		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
> -			xfs_stack_trace();
> -	} else if (logerror) {
> -		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
> -"Log I/O error (0x%x) detected at %pS (%s:%d). Shutting down filesystem",
> -				flags, __return_address, fname, lnnum);
> +	if (xlog_force_shutdown(mp->m_log, flags)) {
> +		tag = XFS_PTAG_SHUTDOWN_LOGERROR;
> +		why = "Log I/O Error";
> +	} else if (flags & SHUTDOWN_CORRUPT_INCORE) {
> +		tag = XFS_PTAG_SHUTDOWN_CORRUPT;
> +		why = "Corruption of in-memory data";
>  	} else {
> -		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
> -"I/O error (0x%x) detected at %pS (%s:%d). Shutting down filesystem",
> -				flags, __return_address, fname, lnnum);
> +		tag = XFS_PTAG_SHUTDOWN_IOERROR;
> +		why = "Metadata I/O Error";
>  	}
>  
> +	xfs_alert_tag(mp, tag,
> +"%s (0x%x) detected at %pS (%s:%d).  Shutting down filesystem.",
> +			why, flags, __return_address, fname, lnnum);
>  	xfs_alert(mp,
>  		"Please unmount the filesystem and rectify the problem(s)");
> +	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
> +		xfs_stack_trace();

Doesn't xfs_alert already drop a stack trace for xfs_error_level >=
XFS_ERRLEVEL_HIGH ?

--D

> +
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 049d6ac9cb4d..6c7cfc052135 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3673,76 +3673,66 @@ xlog_verify_iclog(
>  #endif
>  
>  /*
> - * This is called from xfs_force_shutdown, when we're forcibly
> - * shutting down the filesystem, typically because of an IO error.
> - * Our main objectives here are to make sure that:
> - *	a. if !logerror, flush the logs to disk. Anything modified
> - *	   after this is ignored.
> - *	b. the filesystem gets marked 'SHUTDOWN' for all interested
> - *	   parties to find out, 'atomically'.
> - *	c. those who're sleeping on log reservations, pinned objects and
> - *	    other resources get woken up, and be told the bad news.
> - *	d. nothing new gets queued up after (b) and (c) are done.
> + * Perform a forced shutdown on the log. This should be called once and once
> + * only by the high level filesystem shutdown code to shut the log subsystem
> + * down cleanly.
>   *
> - * Note: for the !logerror case we need to flush the regions held in memory out
> - * to disk first. This needs to be done before the log is marked as shutdown,
> - * otherwise the iclog writes will fail.
> + * Our main objectives here are to make sure that:
> + *	a. if the shutdown was not due to a log IO error, flush the logs to
> + *	   disk. Anything modified after this is ignored.
> + *	b. the log gets atomically marked 'XLOG_IO_ERROR' for all interested
> + *	   parties to find out. Nothing new gets queued after this is done.
> + *	c. Tasks sleeping on log reservations, pinned objects and
> + *	   other resources get woken up.
>   *
> - * Return non-zero if log shutdown transition had already happened.
> + * Return true if the shutdown cause was a log IO error and we actually shut the
> + * log down.
>   */
> -int
> -xfs_log_force_umount(
> -	struct xfs_mount	*mp,
> -	int			logerror)
> +bool
> +xlog_force_shutdown(
> +	struct xlog	*log,
> +	int		shutdown_flags)
>  {
> -	struct xlog	*log;
> -	int		retval = 0;
> -
> -	log = mp->m_log;
> +	bool		log_error = (shutdown_flags & SHUTDOWN_LOG_IO_ERROR);
>  
>  	/*
> -	 * If this happens during log recovery, don't worry about
> -	 * locking; the log isn't open for business yet.
> +	 * If this happens during log recovery then we aren't using the runtime
> +	 * log mechanisms yet so there's nothing to shut down.
>  	 */
> -	if (!log || xlog_in_recovery(log)) {
> -		mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
> -		if (mp->m_sb_bp)
> -			mp->m_sb_bp->b_flags |= XBF_DONE;
> -		return 0;
> -	}
> +	if (!log || xlog_in_recovery(log))
> +		return false;
>  
> -	/*
> -	 * Somebody could've already done the hard work for us.
> -	 * No need to get locks for this.
> -	 */
> -	if (logerror && xlog_is_shutdown(log))
> -		return 1;
> +	ASSERT(!xlog_is_shutdown(log));
>  
>  	/*
>  	 * Flush all the completed transactions to disk before marking the log
> -	 * being shut down. We need to do it in this order to ensure that
> -	 * completed operations are safely on disk before we shut down, and that
> -	 * we don't have to issue any buffer IO after the shutdown flags are set
> -	 * to guarantee this.
> +	 * being shut down. We need to do this first as shutting down the log
> +	 * before the force will prevent the log force from flushing the iclogs
> +	 * to disk.
> +	 *
> +	 * Re-entry due to a log IO error shutdown during the log force is
> +	 * prevented by the atomicity of higher level shutdown code.
>  	 */
> -	if (!logerror)
> -		xfs_log_force(mp, XFS_LOG_SYNC);
> +	if (!log_error)
> +		xfs_log_force(log->l_mp, XFS_LOG_SYNC);
>  
>  	/*
> -	 * mark the filesystem and the as in a shutdown state and wake
> -	 * everybody up to tell them the bad news.
> +	 * Atomically set the shutdown state. If the shutdown state is already
> +	 * set, there someone else is performing the shutdown and so we are done
> +	 * here. This should never happen because we should only ever get called
> +	 * once by the first shutdown caller.
> +	 *
> +	 * Much of the log state machine transitions assume that shutdown state
> +	 * cannot change once they hold the log->l_icloglock. Hence we need to
> +	 * hold that lock here, even though we use the atomic test_and_set_bit()
> +	 * operation to set the shutdown state.
>  	 */
>  	spin_lock(&log->l_icloglock);
> -	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
> -	if (mp->m_sb_bp)
> -		mp->m_sb_bp->b_flags |= XBF_DONE;
> -
> -	/*
> -	 * Mark the log and the iclogs with IO error flags to prevent any
> -	 * further log IO from being issued or completed.
> -	 */
> -	if (!test_and_set_bit(XLOG_IO_ERROR, &log->l_opstate))
> -		retval = 1;
> +	if (test_and_set_bit(XLOG_IO_ERROR, &log->l_opstate)) {
> +		spin_unlock(&log->l_icloglock);
> +		ASSERT(0);
> +		return false;
> +	}
>  	spin_unlock(&log->l_icloglock);
>  
>  	/*
> @@ -3766,7 +3756,7 @@ xfs_log_force_umount(
>  	spin_unlock(&log->l_cilp->xc_push_lock);
>  	xlog_state_do_callback(log);
>  
> -	return retval;
> +	return log_error;
>  }
>  
>  STATIC int
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 4c5c8a7db1d9..3f680f0c9744 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -125,7 +125,6 @@ int	  xfs_log_reserve(struct xfs_mount *mp,
>  			  bool		   permanent);
>  int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
>  void      xfs_log_unmount(struct xfs_mount *mp);
> -int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
>  bool	xfs_log_writable(struct xfs_mount *mp);
>  
>  struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
> @@ -140,5 +139,6 @@ void	xfs_log_clean(struct xfs_mount *mp);
>  bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
>  
>  xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
> +bool	  xlog_force_shutdown(struct xlog *log, int shutdown_flags);
>  
>  #endif	/* __XFS_LOG_H__ */
> -- 
> 2.31.1
> 
