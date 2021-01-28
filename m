Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F975308082
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Jan 2021 22:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhA1V0B (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Jan 2021 16:26:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231416AbhA1VZx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 16:25:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E26FC64DE8;
        Thu, 28 Jan 2021 21:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611869112;
        bh=BhEuGb3gnR9oUuWnYTqs82HyXDc9olwUa9AzoNCrewg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M6Z6/Somd+5LPEiLDwFuzHG7frhufKGE8woAUYcFBS/HnycNcRP90W2lhjVi+1qey
         Pn7Spr0fsws6ci7t7jAKHeXOsJzHKWwJ5tGDcvxbmJx8d5y2ct3Y+bIDpuSj5yQRuZ
         ssR2tbKn6SGMza8wi8W3/P3/f0bTJBVgK5fQ5qDoWkdVgMHsGBjRqbV9BrD28sNDDz
         sbJbKQvoFyKgo0qquOEQs9YZSp9aGqqh4bY6SS4QkUuoy+F3+qMcUcB9/jWI1tiqzo
         2ZztciJXVVZSEKAfsRYg4gdZdIWf3hOSvrteGnzzUCuVQxm3AVIbGJZPjmXvTEI1iw
         Z/e9pmiAIjXag==
Date:   Thu, 28 Jan 2021 13:25:11 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: log stripe roundoff is a property of the log
Message-ID: <20210128212511.GC7698@magnolia>
References: <20210128044154.806715-1-david@fromorbit.com>
 <20210128044154.806715-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128044154.806715-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 03:41:50PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We don't need to look at the xfs_mount and superblock every time we
> need to do an iclog roundoff calculation. The property is fixed for
> the life of the log, so store the roundoff in the log at mount time
> and use that everywhere.
> 
> On a debug build:
> 
> $ size fs/xfs/xfs_log.o.*
>    text	   data	    bss	    dec	    hex	filename
>   27360	    560	      8	  27928	   6d18	fs/xfs/xfs_log.o.orig
>   27219	    560	      8	  27787	   6c8b	fs/xfs/xfs_log.o.patched
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_log_format.h |  3 --
>  fs/xfs/xfs_log.c               | 60 +++++++++++++++-------------------
>  fs/xfs/xfs_log_priv.h          |  2 ++
>  3 files changed, 28 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 8bd00da6d2a4..16587219549c 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -34,9 +34,6 @@ typedef uint32_t xlog_tid_t;
>  #define XLOG_MIN_RECORD_BSHIFT	14		/* 16384 == 1 << 14 */
>  #define XLOG_BIG_RECORD_BSHIFT	15		/* 32k == 1 << 15 */
>  #define XLOG_MAX_RECORD_BSHIFT	18		/* 256k == 1 << 18 */
> -#define XLOG_BTOLSUNIT(log, b)  (((b)+(log)->l_mp->m_sb.sb_logsunit-1) / \
> -                                 (log)->l_mp->m_sb.sb_logsunit)
> -#define XLOG_LSUNITTOB(log, su) ((su) * (log)->l_mp->m_sb.sb_logsunit)
>  
>  #define XLOG_HEADER_SIZE	512
>  
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 58699881c100..c5f507c24577 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1400,6 +1400,12 @@ xlog_alloc_log(
>  	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
>  	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
>  
> +	/* roundoff padding for transaction data and one for commit record */
> +	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1)
> +		log->l_iclog_roundoff = mp->m_sb.sb_logsunit;
> +	else
> +		log->l_iclog_roundoff = BBSIZE;
> +
>  	xlog_grant_head_init(&log->l_reserve_head);
>  	xlog_grant_head_init(&log->l_write_head);
>  
> @@ -1852,29 +1858,15 @@ xlog_calc_iclog_size(
>  	uint32_t		*roundoff)
>  {
>  	uint32_t		count_init, count;
> -	bool			use_lsunit;
> -
> -	use_lsunit = xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
> -			log->l_mp->m_sb.sb_logsunit > 1;
>  
>  	/* Add for LR header */
>  	count_init = log->l_iclog_hsize + iclog->ic_offset;
> +	count = roundup(count_init, log->l_iclog_roundoff);
>  
> -	/* Round out the log write size */
> -	if (use_lsunit) {
> -		/* we have a v2 stripe unit to use */
> -		count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));
> -	} else {
> -		count = BBTOB(BTOBB(count_init));
> -	}
> -
> -	ASSERT(count >= count_init);
>  	*roundoff = count - count_init;
>  
> -	if (use_lsunit)
> -		ASSERT(*roundoff < log->l_mp->m_sb.sb_logsunit);
> -	else
> -		ASSERT(*roundoff < BBTOB(1));
> +	ASSERT(count >= count_init);
> +	ASSERT(*roundoff < log->l_iclog_roundoff);
>  	return count;
>  }
>  
> @@ -3149,10 +3141,9 @@ xlog_state_switch_iclogs(
>  	log->l_curr_block += BTOBB(eventual_size)+BTOBB(log->l_iclog_hsize);
>  
>  	/* Round up to next log-sunit */
> -	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
> -	    log->l_mp->m_sb.sb_logsunit > 1) {
> -		uint32_t sunit_bb = BTOBB(log->l_mp->m_sb.sb_logsunit);
> -		log->l_curr_block = roundup(log->l_curr_block, sunit_bb);
> +	if (log->l_iclog_roundoff > BBSIZE) {
> +		log->l_curr_block = roundup(log->l_curr_block,
> +						BTOBB(log->l_iclog_roundoff));
>  	}
>  
>  	if (log->l_curr_block >= log->l_logBBsize) {
> @@ -3404,12 +3395,11 @@ xfs_log_ticket_get(
>   * Figure out the total log space unit (in bytes) that would be
>   * required for a log ticket.
>   */
> -int
> -xfs_log_calc_unit_res(
> -	struct xfs_mount	*mp,
> +static int
> +xlog_calc_unit_res(
> +	struct xlog		*log,
>  	int			unit_bytes)
>  {
> -	struct xlog		*log = mp->m_log;
>  	int			iclog_space;
>  	uint			num_headers;
>  
> @@ -3485,18 +3475,20 @@ xfs_log_calc_unit_res(
>  	/* for commit-rec LR header - note: padding will subsume the ophdr */
>  	unit_bytes += log->l_iclog_hsize;
>  
> -	/* for roundoff padding for transaction data and one for commit record */
> -	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1) {
> -		/* log su roundoff */
> -		unit_bytes += 2 * mp->m_sb.sb_logsunit;
> -	} else {
> -		/* BB roundoff */
> -		unit_bytes += 2 * BBSIZE;
> -        }
> +	/* roundoff padding for transaction data and one for commit record */
> +	unit_bytes += log->l_iclog_roundoff;

I don't understand why the "2 *" disappears here.  It's not a part of
the roundoff computation when we allocate the log, so AFAICT it's not
just buried elsewhere?

Was the old code saying that it added the roundoff factor twice because
we needed to do so once for the transaction data and the second time for
the commit record?

--D

>  
>  	return unit_bytes;
>  }
>  
> +int
> +xfs_log_calc_unit_res(
> +	struct xfs_mount	*mp,
> +	int			unit_bytes)
> +{
> +	return xlog_calc_unit_res(mp->m_log, unit_bytes);
> +}
> +
>  /*
>   * Allocate and initialise a new log ticket.
>   */
> @@ -3513,7 +3505,7 @@ xlog_ticket_alloc(
>  
>  	tic = kmem_cache_zalloc(xfs_log_ticket_zone, GFP_NOFS | __GFP_NOFAIL);
>  
> -	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
> +	unit_res = xlog_calc_unit_res(log, unit_bytes);
>  
>  	atomic_set(&tic->t_ref, 1);
>  	tic->t_task		= current;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 1c6fdbf3d506..037950cf1061 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -436,6 +436,8 @@ struct xlog {
>  #endif
>  	/* log recovery lsn tracking (for buffer submission */
>  	xfs_lsn_t		l_recovery_lsn;
> +
> +	uint32_t		l_iclog_roundoff;/* padding roundoff */
>  };
>  
>  #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
> -- 
> 2.28.0
> 
