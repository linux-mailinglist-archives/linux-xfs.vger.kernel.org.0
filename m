Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9D13AB9DE
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Jun 2021 18:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhFQQrq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Jun 2021 12:47:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230343AbhFQQrq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jun 2021 12:47:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55EE5613F3;
        Thu, 17 Jun 2021 16:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623948338;
        bh=8PxD6F55kPmoMWZ3tI8DgrfHZsMx3GoADqe8B4Kvznk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QStkQKbITxKd573seUGCEcfwBwSyBUe0CvvGOsLMkvXrbz3iUv9RBxwdXQZlVrAbr
         eKd0JZnwcz/i2hjugGFglAn7lVibACJ4IdO4n6Lwp1KI50IE+oMfoeu3AdAwLK7ALX
         spVk172UZorVEyF0OeD/B+mQP/oERnLen4NS2+1Ve4aq+0eiJEfADXfPL2g+E/XzsO
         rps6wUthLG7ryMNGekyrNf+WjrNRlzyXWZnk2qVdDm04X9hndNgz8+vLSGNI45XBV6
         7Bn932VY/QvD0qp8Dzty5OpJZ8y00m04pcypaRCvQxc4vXs7saTtpcxrvdHK6O3NSi
         uotSLrLEwa2ug==
Date:   Thu, 17 Jun 2021 09:45:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] xfs: add iclog state trace events
Message-ID: <20210617164537.GS158209@locust>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617082617.971602-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 06:26:10PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> For the DEBUGS!
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Still looks fine to me.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c      | 18 +++++++++++++
>  fs/xfs/xfs_log_priv.h | 10 ++++++++
>  fs/xfs/xfs_trace.h    | 60 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 88 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index e921b554b683..54fd6a695bb5 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -524,6 +524,7 @@ __xlog_state_release_iclog(
>  		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
>  		xlog_verify_tail_lsn(log, iclog, tail_lsn);
>  		/* cycle incremented when incrementing curr_block */
> +		trace_xlog_iclog_syncing(iclog, _RET_IP_);
>  		return true;
>  	}
>  
> @@ -543,6 +544,7 @@ xlog_state_release_iclog(
>  {
>  	lockdep_assert_held(&log->l_icloglock);
>  
> +	trace_xlog_iclog_release(iclog, _RET_IP_);
>  	if (iclog->ic_state == XLOG_STATE_IOERROR)
>  		return -EIO;
>  
> @@ -804,6 +806,7 @@ xlog_wait_on_iclog(
>  {
>  	struct xlog		*log = iclog->ic_log;
>  
> +	trace_xlog_iclog_wait_on(iclog, _RET_IP_);
>  	if (!XLOG_FORCED_SHUTDOWN(log) &&
>  	    iclog->ic_state != XLOG_STATE_ACTIVE &&
>  	    iclog->ic_state != XLOG_STATE_DIRTY) {
> @@ -1804,6 +1807,7 @@ xlog_write_iclog(
>  	unsigned int		count)
>  {
>  	ASSERT(bno < log->l_logBBsize);
> +	trace_xlog_iclog_write(iclog, _RET_IP_);
>  
>  	/*
>  	 * We lock the iclogbufs here so that we can serialise against I/O
> @@ -1950,6 +1954,7 @@ xlog_sync(
>  	unsigned int		size;
>  
>  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
> +	trace_xlog_iclog_sync(iclog, _RET_IP_);
>  
>  	count = xlog_calc_iclog_size(log, iclog, &roundoff);
>  
> @@ -2488,6 +2493,7 @@ xlog_state_activate_iclog(
>  	int			*iclogs_changed)
>  {
>  	ASSERT(list_empty_careful(&iclog->ic_callbacks));
> +	trace_xlog_iclog_activate(iclog, _RET_IP_);
>  
>  	/*
>  	 * If the number of ops in this iclog indicate it just contains the
> @@ -2577,6 +2583,8 @@ xlog_state_clean_iclog(
>  {
>  	int			iclogs_changed = 0;
>  
> +	trace_xlog_iclog_clean(dirty_iclog, _RET_IP_);
> +
>  	dirty_iclog->ic_state = XLOG_STATE_DIRTY;
>  
>  	xlog_state_activate_iclogs(log, &iclogs_changed);
> @@ -2636,6 +2644,7 @@ xlog_state_set_callback(
>  	struct xlog_in_core	*iclog,
>  	xfs_lsn_t		header_lsn)
>  {
> +	trace_xlog_iclog_callback(iclog, _RET_IP_);
>  	iclog->ic_state = XLOG_STATE_CALLBACK;
>  
>  	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
> @@ -2717,6 +2726,7 @@ xlog_state_do_iclog_callbacks(
>  		__releases(&log->l_icloglock)
>  		__acquires(&log->l_icloglock)
>  {
> +	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
>  	spin_unlock(&log->l_icloglock);
>  	spin_lock(&iclog->ic_callback_lock);
>  	while (!list_empty(&iclog->ic_callbacks)) {
> @@ -2736,6 +2746,7 @@ xlog_state_do_iclog_callbacks(
>  	 */
>  	spin_lock(&log->l_icloglock);
>  	spin_unlock(&iclog->ic_callback_lock);
> +	trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
>  }
>  
>  STATIC void
> @@ -2827,6 +2838,7 @@ xlog_state_done_syncing(
>  
>  	spin_lock(&log->l_icloglock);
>  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
> +	trace_xlog_iclog_sync_done(iclog, _RET_IP_);
>  
>  	/*
>  	 * If we got an error, either on the first buffer, or in the case of
> @@ -2899,6 +2911,8 @@ xlog_state_get_iclog_space(
>  	atomic_inc(&iclog->ic_refcnt);	/* prevents sync */
>  	log_offset = iclog->ic_offset;
>  
> +	trace_xlog_iclog_get_space(iclog, _RET_IP_);
> +
>  	/* On the 1st write to an iclog, figure out lsn.  This works
>  	 * if iclogs marked XLOG_STATE_WANT_SYNC always write out what they are
>  	 * committing to.  If the offset is set, that's how many blocks
> @@ -3056,6 +3070,7 @@ xlog_state_switch_iclogs(
>  {
>  	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
>  	assert_spin_locked(&log->l_icloglock);
> +	trace_xlog_iclog_switch(iclog, _RET_IP_);
>  
>  	if (!eventual_size)
>  		eventual_size = iclog->ic_offset;
> @@ -3138,6 +3153,8 @@ xfs_log_force(
>  	if (iclog->ic_state == XLOG_STATE_IOERROR)
>  		goto out_error;
>  
> +	trace_xlog_iclog_force(iclog, _RET_IP_);
> +
>  	if (iclog->ic_state == XLOG_STATE_DIRTY ||
>  	    (iclog->ic_state == XLOG_STATE_ACTIVE &&
>  	     atomic_read(&iclog->ic_refcnt) == 0 && iclog->ic_offset == 0)) {
> @@ -3225,6 +3242,7 @@ xlog_force_lsn(
>  		goto out_error;
>  
>  	while (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
> +		trace_xlog_iclog_force_lsn(iclog, _RET_IP_);
>  		iclog = iclog->ic_next;
>  		if (iclog == log->l_iclog)
>  			goto out_unlock;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index e4e421a70335..330befd9f6be 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -50,6 +50,16 @@ enum xlog_iclog_state {
>  	XLOG_STATE_IOERROR,	/* IO error happened in sync'ing log */
>  };
>  
> +#define XLOG_STATE_STRINGS \
> +	{ XLOG_STATE_ACTIVE,	"XLOG_STATE_ACTIVE" }, \
> +	{ XLOG_STATE_WANT_SYNC,	"XLOG_STATE_WANT_SYNC" }, \
> +	{ XLOG_STATE_SYNCING,	"XLOG_STATE_SYNCING" }, \
> +	{ XLOG_STATE_DONE_SYNC,	"XLOG_STATE_DONE_SYNC" }, \
> +	{ XLOG_STATE_CALLBACK,	"XLOG_STATE_CALLBACK" }, \
> +	{ XLOG_STATE_DIRTY,	"XLOG_STATE_DIRTY" }, \
> +	{ XLOG_STATE_IOERROR,	"XLOG_STATE_IOERROR" }
> +
> +
>  /*
>   * Log ticket flags
>   */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 71dca776c110..28d570742000 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -24,6 +24,7 @@ struct xlog_ticket;
>  struct xlog_recover;
>  struct xlog_recover_item;
>  struct xlog_rec_header;
> +struct xlog_in_core;
>  struct xfs_buf_log_format;
>  struct xfs_inode_log_format;
>  struct xfs_bmbt_irec;
> @@ -3927,6 +3928,65 @@ DEFINE_EVENT(xfs_icwalk_class, name,	\
>  DEFINE_ICWALK_EVENT(xfs_ioc_free_eofblocks);
>  DEFINE_ICWALK_EVENT(xfs_blockgc_free_space);
>  
> +TRACE_DEFINE_ENUM(XLOG_STATE_ACTIVE);
> +TRACE_DEFINE_ENUM(XLOG_STATE_WANT_SYNC);
> +TRACE_DEFINE_ENUM(XLOG_STATE_SYNCING);
> +TRACE_DEFINE_ENUM(XLOG_STATE_DONE_SYNC);
> +TRACE_DEFINE_ENUM(XLOG_STATE_CALLBACK);
> +TRACE_DEFINE_ENUM(XLOG_STATE_DIRTY);
> +TRACE_DEFINE_ENUM(XLOG_STATE_IOERROR);
> +
> +DECLARE_EVENT_CLASS(xlog_iclog_class,
> +	TP_PROTO(struct xlog_in_core *iclog, unsigned long caller_ip),
> +	TP_ARGS(iclog, caller_ip),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(uint32_t, state)
> +		__field(int32_t, refcount)
> +		__field(uint32_t, offset)
> +		__field(unsigned long long, lsn)
> +		__field(unsigned long, caller_ip)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = iclog->ic_log->l_mp->m_super->s_dev;
> +		__entry->state = iclog->ic_state;
> +		__entry->refcount = atomic_read(&iclog->ic_refcnt);
> +		__entry->offset = iclog->ic_offset;
> +		__entry->lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> +		__entry->caller_ip = caller_ip;
> +	),
> +	TP_printk("dev %d:%d state %s refcnt %d offset %u lsn 0x%llx caller %pS",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __print_symbolic(__entry->state, XLOG_STATE_STRINGS),
> +		  __entry->refcount,
> +		  __entry->offset,
> +		  __entry->lsn,
> +		  (char *)__entry->caller_ip)
> +
> +);
> +
> +#define DEFINE_ICLOG_EVENT(name)	\
> +DEFINE_EVENT(xlog_iclog_class, name,	\
> +	TP_PROTO(struct xlog_in_core *iclog, unsigned long caller_ip), \
> +	TP_ARGS(iclog, caller_ip))
> +
> +DEFINE_ICLOG_EVENT(xlog_iclog_activate);
> +DEFINE_ICLOG_EVENT(xlog_iclog_clean);
> +DEFINE_ICLOG_EVENT(xlog_iclog_callback);
> +DEFINE_ICLOG_EVENT(xlog_iclog_callbacks_start);
> +DEFINE_ICLOG_EVENT(xlog_iclog_callbacks_done);
> +DEFINE_ICLOG_EVENT(xlog_iclog_force);
> +DEFINE_ICLOG_EVENT(xlog_iclog_force_lsn);
> +DEFINE_ICLOG_EVENT(xlog_iclog_get_space);
> +DEFINE_ICLOG_EVENT(xlog_iclog_release);
> +DEFINE_ICLOG_EVENT(xlog_iclog_switch);
> +DEFINE_ICLOG_EVENT(xlog_iclog_sync);
> +DEFINE_ICLOG_EVENT(xlog_iclog_syncing);
> +DEFINE_ICLOG_EVENT(xlog_iclog_sync_done);
> +DEFINE_ICLOG_EVENT(xlog_iclog_want_sync);
> +DEFINE_ICLOG_EVENT(xlog_iclog_wait_on);
> +DEFINE_ICLOG_EVENT(xlog_iclog_write);
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> -- 
> 2.31.1
> 
