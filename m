Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEB4331B98
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Mar 2021 01:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhCIAVs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Mar 2021 19:21:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231911AbhCIAVg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 19:21:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9787E64FFD;
        Tue,  9 Mar 2021 00:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615249295;
        bh=K3vNZGy59mxmGK+TyFlB+E1ecfC9SIcWUIsMdzmsrGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sS8WSNdKbJtdc3plWQD0J+xmP3fC5CAz/8c3Q7OBLtwqSlm6/7B00biWGfyL2cUY9
         AqtXHCreJu0MMwAQwDKvenM3bQV01y2VN+Agta3q0/IkNdaD8ny3TOEtMUE5rrxjr1
         gXkoj8A8R+FBbySAxK8CphGt2Ra/SfzWTIhBngVeuM63Ndz16+Bu0egkaqsUNILpdY
         mwq4jbnW+vv2165Xvtf0ic+A+GdRqyuiAhqPIfiWlDx9Smhf3zcz5X1fes+Ys191BM
         rneAuG7tpwVUsOiqMuTMyDBs1Y5Vlynl+Qen4YRLV8pbS4+Ue8aKGO3Dsm//9DF+ue
         +IXlzIqxN/wRQ==
Date:   Mon, 8 Mar 2021 16:21:34 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/45] xfs: log tickets don't need log client id
Message-ID: <20210309002134.GJ3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-24-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-24-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:21PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently set the log ticket client ID when we reserve a
> transaction. This client ID is only ever written to the log by
> a CIL checkpoint or unmount records, and so anything using a high
> level transaction allocated through xfs_trans_alloc() does not need
> a log ticket client ID to be set.
> 
> For the CIL checkpoint, the client ID written to the journal is
> always XFS_TRANSACTION, and for the unmount record it is always
> XFS_LOG, and nothing else writes to the log. All of these operations
> tell xlog_write() exactly what they need to write to the log (the
> optype) and build their own opheaders for start, commit and unmount
> records. Hence we no longer need to set the client id in either the
> log ticket or the xfs_trans.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 47 ++++++++-----------------------------------
>  fs/xfs/xfs_log.h      | 16 ++++++---------
>  fs/xfs/xfs_log_cil.c  |  2 +-
>  fs/xfs/xfs_log_priv.h | 10 ++-------
>  fs/xfs/xfs_trans.c    |  6 ++----
>  5 files changed, 19 insertions(+), 62 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c2e69a1f5cad..429cb1e7cc67 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -431,10 +431,9 @@ xfs_log_regrant(
>  int
>  xfs_log_reserve(
>  	struct xfs_mount	*mp,
> -	int		 	unit_bytes,
> -	int		 	cnt,
> +	int			unit_bytes,
> +	int			cnt,
>  	struct xlog_ticket	**ticp,
> -	uint8_t		 	client,
>  	bool			permanent)
>  {
>  	struct xlog		*log = mp->m_log;
> @@ -442,15 +441,13 @@ xfs_log_reserve(
>  	int			need_bytes;
>  	int			error = 0;
>  
> -	ASSERT(client == XFS_TRANSACTION || client == XFS_LOG);
> -
>  	if (XLOG_FORCED_SHUTDOWN(log))
>  		return -EIO;
>  
>  	XFS_STATS_INC(mp, xs_try_logspace);
>  
>  	ASSERT(*ticp == NULL);
> -	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent);
> +	tic = xlog_ticket_alloc(log, unit_bytes, cnt, permanent);
>  	*ticp = tic;
>  
>  	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
> @@ -847,7 +844,7 @@ xlog_unmount_write(
>  	struct xlog_ticket	*tic = NULL;
>  	int			error;
>  
> -	error = xfs_log_reserve(mp, 600, 1, &tic, XFS_LOG, 0);
> +	error = xfs_log_reserve(mp, 600, 1, &tic, 0);
>  	if (error)
>  		goto out_err;
>  
> @@ -2170,35 +2167,13 @@ xlog_write_calc_vec_length(
>  
>  static xlog_op_header_t *
>  xlog_write_setup_ophdr(
> -	struct xlog		*log,
>  	struct xlog_op_header	*ophdr,
> -	struct xlog_ticket	*ticket,
> -	uint			flags)
> +	struct xlog_ticket	*ticket)
>  {
>  	ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> -	ophdr->oh_clientid = ticket->t_clientid;
> +	ophdr->oh_clientid = XFS_TRANSACTION;
>  	ophdr->oh_res2 = 0;
> -
> -	/* are we copying a commit or unmount record? */
> -	ophdr->oh_flags = flags;
> -
> -	/*
> -	 * We've seen logs corrupted with bad transaction client ids.  This
> -	 * makes sure that XFS doesn't generate them on.  Turn this into an EIO
> -	 * and shut down the filesystem.
> -	 */
> -	switch (ophdr->oh_clientid)  {
> -	case XFS_TRANSACTION:
> -	case XFS_VOLUME:

Reading between the lines, I'm guessing this clientid is some
now-vestigial organ from the Irix days, where there was some kind of
volume manager (in addition to the filesystem + log)?  And between the
three, there was a need to dispatch recovered log ops to the correct
subsystem?

> -	case XFS_LOG:
> -		break;
> -	default:
> -		xfs_warn(log->l_mp,
> -			"Bad XFS transaction clientid 0x%x in ticket "PTR_FMT,
> -			ophdr->oh_clientid, ticket);
> -		return NULL;
> -	}
> -
> +	ophdr->oh_flags = 0;
>  	return ophdr;
>  }
>  
> @@ -2439,11 +2414,7 @@ xlog_write(
>  				if (index)
>  					optype &= ~XLOG_START_TRANS;
>  			} else {
> -				ophdr = xlog_write_setup_ophdr(log, ptr,
> -							ticket, optype);
> -				if (!ophdr)
> -					return -EIO;
> -
> +                                ophdr = xlog_write_setup_ophdr(ptr, ticket);

Nit: use tabs, not spaces.

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  				xlog_write_adv_cnt(&ptr, &len, &log_offset,
>  					   sizeof(struct xlog_op_header));
>  				added_ophdr = true;
> @@ -3499,7 +3470,6 @@ xlog_ticket_alloc(
>  	struct xlog		*log,
>  	int			unit_bytes,
>  	int			cnt,
> -	char			client,
>  	bool			permanent)
>  {
>  	struct xlog_ticket	*tic;
> @@ -3517,7 +3487,6 @@ xlog_ticket_alloc(
>  	tic->t_cnt		= cnt;
>  	tic->t_ocnt		= cnt;
>  	tic->t_tid		= prandom_u32();
> -	tic->t_clientid		= client;
>  	if (permanent)
>  		tic->t_flags |= XLOG_TIC_PERM_RESERV;
>  
> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 1bd080ce3a95..c0c3141944ea 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -117,16 +117,12 @@ int	  xfs_log_mount_finish(struct xfs_mount *mp);
>  void	xfs_log_mount_cancel(struct xfs_mount *);
>  xfs_lsn_t xlog_assign_tail_lsn(struct xfs_mount *mp);
>  xfs_lsn_t xlog_assign_tail_lsn_locked(struct xfs_mount *mp);
> -void	  xfs_log_space_wake(struct xfs_mount *mp);
> -int	  xfs_log_reserve(struct xfs_mount *mp,
> -			  int		   length,
> -			  int		   count,
> -			  struct xlog_ticket **ticket,
> -			  uint8_t		   clientid,
> -			  bool		   permanent);
> -int	  xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
> -void      xfs_log_unmount(struct xfs_mount *mp);
> -int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
> +void	xfs_log_space_wake(struct xfs_mount *mp);
> +int	xfs_log_reserve(struct xfs_mount *mp, int length, int count,
> +			struct xlog_ticket **ticket, bool permanent);
> +int	xfs_log_regrant(struct xfs_mount *mp, struct xlog_ticket *tic);
> +void	xfs_log_unmount(struct xfs_mount *mp);
> +int	xfs_log_force_umount(struct xfs_mount *mp, int logerror);
>  bool	xfs_log_writable(struct xfs_mount *mp);
>  
>  struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index e9da074ecd69..0c81c13e2cf6 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -37,7 +37,7 @@ xlog_cil_ticket_alloc(
>  {
>  	struct xlog_ticket *tic;
>  
> -	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0);
> +	tic = xlog_ticket_alloc(log, 0, 1, 0);
>  
>  	/*
>  	 * set the current reservation to zero so we know to steal the basic
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index bb5fa6b71114..7f601c1c9f45 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -158,7 +158,6 @@ typedef struct xlog_ticket {
>  	int		   t_unit_res;	 /* unit reservation in bytes    : 4  */
>  	char		   t_ocnt;	 /* original count		 : 1  */
>  	char		   t_cnt;	 /* current count		 : 1  */
> -	char		   t_clientid;	 /* who does this belong to;	 : 1  */
>  	char		   t_flags;	 /* properties of reservation	 : 1  */
>  
>          /* reservation array fields */
> @@ -465,13 +464,8 @@ extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
>  			    char *dp, int size);
>  
>  extern kmem_zone_t *xfs_log_ticket_zone;
> -struct xlog_ticket *
> -xlog_ticket_alloc(
> -	struct xlog	*log,
> -	int		unit_bytes,
> -	int		count,
> -	char		client,
> -	bool		permanent);
> +struct xlog_ticket *xlog_ticket_alloc(struct xlog *log, int unit_bytes,
> +		int count, bool permanent);
>  
>  static inline void
>  xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 52f3fdf1e0de..83c2b7f22eb7 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -194,11 +194,9 @@ xfs_trans_reserve(
>  			ASSERT(resp->tr_logflags & XFS_TRANS_PERM_LOG_RES);
>  			error = xfs_log_regrant(mp, tp->t_ticket);
>  		} else {
> -			error = xfs_log_reserve(mp,
> -						resp->tr_logres,
> +			error = xfs_log_reserve(mp, resp->tr_logres,
>  						resp->tr_logcount,
> -						&tp->t_ticket, XFS_TRANSACTION,
> -						permanent);
> +						&tp->t_ticket, permanent);
>  		}
>  
>  		if (error)
> -- 
> 2.28.0
> 
