Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7767645FFB
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jun 2019 16:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbfFNOFF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Jun 2019 10:05:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32914 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728239AbfFNOFF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 10:05:05 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 088F2882FB;
        Fri, 14 Jun 2019 14:05:05 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AC867C5D0;
        Fri, 14 Jun 2019 14:05:04 +0000 (UTC)
Date:   Fri, 14 Jun 2019 10:05:02 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/14] xfs: refactor INUMBERS to use iwalk functions
Message-ID: <20190614140502.GD26586@bfoster>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
 <156032212910.3774243.13112993369352430725.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156032212910.3774243.13112993369352430725.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 14 Jun 2019 14:05:05 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 11, 2019 at 11:48:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we have generic functions to walk inode records, refactor the
> INUMBERS implementation to use it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Modulo the error code stuff:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_ioctl.c   |   20 ++++--
>  fs/xfs/xfs_ioctl.h   |    2 +
>  fs/xfs/xfs_ioctl32.c |   35 ++++-------
>  fs/xfs/xfs_itable.c  |  166 +++++++++++++++++++-------------------------------
>  fs/xfs/xfs_itable.h  |   22 +------
>  5 files changed, 95 insertions(+), 150 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 60595e61f2a6..04b661ff0799 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -733,6 +733,16 @@ xfs_bulkstat_one_fmt(
>  	return xfs_ibulk_advance(breq, sizeof(struct xfs_bstat));
>  }
>  
> +int
> +xfs_inumbers_fmt(
> +	struct xfs_ibulk	*breq,
> +	const struct xfs_inogrp	*igrp)
> +{
> +	if (copy_to_user(breq->ubuffer, igrp, sizeof(*igrp)))
> +		return -EFAULT;
> +	return xfs_ibulk_advance(breq, sizeof(struct xfs_inogrp));
> +}
> +
>  STATIC int
>  xfs_ioc_bulkstat(
>  	xfs_mount_t		*mp,
> @@ -783,13 +793,9 @@ xfs_ioc_bulkstat(
>  	 * in filesystem".
>  	 */
>  	if (cmd == XFS_IOC_FSINUMBERS) {
> -		int	count = breq.icount;
> -
> -		breq.startino = lastino;
> -		error = xfs_inumbers(mp, &breq.startino, &count,
> -					bulkreq.ubuffer, xfs_inumbers_fmt);
> -		breq.ocount = count;
> -		lastino = breq.startino;
> +		breq.startino = lastino ? lastino + 1 : 0;
> +		error = xfs_inumbers(&breq, xfs_inumbers_fmt);
> +		lastino = breq.startino - 1;
>  	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
>  		breq.startino = lastino;
>  		breq.icount = 1;
> diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
> index f32c8aadfeba..fb303eaa8863 100644
> --- a/fs/xfs/xfs_ioctl.h
> +++ b/fs/xfs/xfs_ioctl.h
> @@ -79,7 +79,9 @@ xfs_set_dmattrs(
>  
>  struct xfs_ibulk;
>  struct xfs_bstat;
> +struct xfs_inogrp;
>  
>  int xfs_bulkstat_one_fmt(struct xfs_ibulk *breq, const struct xfs_bstat *bstat);
> +int xfs_inumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
>  
>  #endif
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 5d1c143bac18..3ca8ff9d4ac7 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -87,22 +87,17 @@ xfs_compat_growfs_rt_copyin(
>  
>  STATIC int
>  xfs_inumbers_fmt_compat(
> -	void			__user *ubuffer,
> -	const struct xfs_inogrp	*buffer,
> -	long			count,
> -	long			*written)
> +	struct xfs_ibulk	*breq,
> +	const struct xfs_inogrp	*igrp)
>  {
> -	compat_xfs_inogrp_t	__user *p32 = ubuffer;
> -	long			i;
> +	struct compat_xfs_inogrp __user *p32 = breq->ubuffer;
>  
> -	for (i = 0; i < count; i++) {
> -		if (put_user(buffer[i].xi_startino,   &p32[i].xi_startino) ||
> -		    put_user(buffer[i].xi_alloccount, &p32[i].xi_alloccount) ||
> -		    put_user(buffer[i].xi_allocmask,  &p32[i].xi_allocmask))
> -			return -EFAULT;
> -	}
> -	*written = count * sizeof(*p32);
> -	return 0;
> +	if (put_user(igrp->xi_startino,   &p32->xi_startino) ||
> +	    put_user(igrp->xi_alloccount, &p32->xi_alloccount) ||
> +	    put_user(igrp->xi_allocmask,  &p32->xi_allocmask))
> +		return -EFAULT;
> +
> +	return xfs_ibulk_advance(breq, sizeof(struct compat_xfs_inogrp));
>  }
>  
>  #else
> @@ -228,7 +223,7 @@ xfs_compat_ioc_bulkstat(
>  	 * to userpace memory via bulkreq.ubuffer.  Normally the compat
>  	 * functions and structure size are the correct ones to use ...
>  	 */
> -	inumbers_fmt_pf inumbers_func = xfs_inumbers_fmt_compat;
> +	inumbers_fmt_pf		inumbers_func = xfs_inumbers_fmt_compat;
>  	bulkstat_one_fmt_pf	bs_one_func = xfs_bulkstat_one_fmt_compat;
>  
>  #ifdef CONFIG_X86_X32
> @@ -291,13 +286,9 @@ xfs_compat_ioc_bulkstat(
>  	 * in filesystem".
>  	 */
>  	if (cmd == XFS_IOC_FSINUMBERS_32) {
> -		int	count = breq.icount;
> -
> -		breq.startino = lastino;
> -		error = xfs_inumbers(mp, &breq.startino, &count,
> -				bulkreq.ubuffer, inumbers_func);
> -		breq.ocount = count;
> -		lastino = breq.startino;
> +		breq.startino = lastino ? lastino + 1 : 0;
> +		error = xfs_inumbers(&breq, inumbers_func);
> +		lastino = breq.startino - 1;
>  	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE_32) {
>  		breq.startino = lastino;
>  		breq.icount = 1;
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 1b3c9feb5f6f..b2f640ecb507 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -269,121 +269,83 @@ xfs_bulkstat(
>  	return error;
>  }
>  
> -int
> -xfs_inumbers_fmt(
> -	void			__user *ubuffer, /* buffer to write to */
> -	const struct xfs_inogrp	*buffer,	/* buffer to read from */
> -	long			count,		/* # of elements to read */
> -	long			*written)	/* # of bytes written */
> +struct xfs_inumbers_chunk {
> +	inumbers_fmt_pf		formatter;
> +	struct xfs_ibulk	*breq;
> +};
> +
> +/*
> + * INUMBERS
> + * ========
> + * This is how we export inode btree records to userspace, so that XFS tools
> + * can figure out where inodes are allocated.
> + */
> +
> +/*
> + * Format the inode group structure and report it somewhere.
> + *
> + * Similar to xfs_bulkstat_one_int, lastino is the inode cursor as we walk
> + * through the filesystem so we move it forward unless there was a runtime
> + * error.  If the formatter tells us the buffer is now full we also move the
> + * cursor forward and abort the walk.
> + */
> +STATIC int
> +xfs_inumbers_walk(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	const struct xfs_inobt_rec_incore *irec,
> +	void			*data)
>  {
> -	if (copy_to_user(ubuffer, buffer, count * sizeof(*buffer)))
> -		return -EFAULT;
> -	*written = count * sizeof(*buffer);
> -	return 0;
> +	struct xfs_inogrp	inogrp = {
> +		.xi_startino	= XFS_AGINO_TO_INO(mp, agno, irec->ir_startino),
> +		.xi_alloccount	= irec->ir_count - irec->ir_freecount,
> +		.xi_allocmask	= ~irec->ir_free,
> +	};
> +	struct xfs_inumbers_chunk *ic = data;
> +	xfs_agino_t		agino;
> +	int			error;
> +
> +	error = ic->formatter(ic->breq, &inogrp);
> +	if (error && error != XFS_IBULK_BUFFER_FULL)
> +		return error;
> +	if (error == XFS_IBULK_BUFFER_FULL)
> +		error = XFS_INOBT_WALK_ABORT;
> +
> +	agino = irec->ir_startino + XFS_INODES_PER_CHUNK;
> +	ic->breq->startino = XFS_AGINO_TO_INO(mp, agno, agino);
> +	return error;
>  }
>  
>  /*
>   * Return inode number table for the filesystem.
>   */
> -int					/* error status */
> +int
>  xfs_inumbers(
> -	struct xfs_mount	*mp,/* mount point for filesystem */
> -	xfs_ino_t		*lastino,/* last inode returned */
> -	int			*count,/* size of buffer/count returned */
> -	void			__user *ubuffer,/* buffer with inode descriptions */
> +	struct xfs_ibulk	*breq,
>  	inumbers_fmt_pf		formatter)
>  {
> -	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, *lastino);
> -	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, *lastino);
> -	struct xfs_btree_cur	*cur = NULL;
> -	struct xfs_buf		*agbp = NULL;
> -	struct xfs_inogrp	*buffer;
> -	int			bcount;
> -	int			left = *count;
> -	int			bufidx = 0;
> +	struct xfs_inumbers_chunk ic = {
> +		.formatter	= formatter,
> +		.breq		= breq,
> +	};
>  	int			error = 0;
>  
> -	*count = 0;
> -	if (agno >= mp->m_sb.sb_agcount ||
> -	    *lastino != XFS_AGINO_TO_INO(mp, agno, agino))
> -		return error;
> +	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
> +		return 0;
>  
> -	bcount = min(left, (int)(PAGE_SIZE / sizeof(*buffer)));
> -	buffer = kmem_zalloc(bcount * sizeof(*buffer), KM_SLEEP);
> -	do {
> -		struct xfs_inobt_rec_incore	r;
> -		int				stat;
> -
> -		if (!agbp) {
> -			error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
> -			if (error)
> -				break;
> -
> -			cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno,
> -						    XFS_BTNUM_INO);
> -			error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_GE,
> -						 &stat);
> -			if (error)
> -				break;
> -			if (!stat)
> -				goto next_ag;
> -		}
> -
> -		error = xfs_inobt_get_rec(cur, &r, &stat);
> -		if (error)
> -			break;
> -		if (!stat)
> -			goto next_ag;
> -
> -		agino = r.ir_startino + XFS_INODES_PER_CHUNK - 1;
> -		buffer[bufidx].xi_startino =
> -			XFS_AGINO_TO_INO(mp, agno, r.ir_startino);
> -		buffer[bufidx].xi_alloccount = r.ir_count - r.ir_freecount;
> -		buffer[bufidx].xi_allocmask = ~r.ir_free;
> -		if (++bufidx == bcount) {
> -			long	written;
> -
> -			error = formatter(ubuffer, buffer, bufidx, &written);
> -			if (error)
> -				break;
> -			ubuffer += written;
> -			*count += bufidx;
> -			bufidx = 0;
> -		}
> -		if (!--left)
> -			break;
> -
> -		error = xfs_btree_increment(cur, 0, &stat);
> -		if (error)
> -			break;
> -		if (stat)
> -			continue;
> -
> -next_ag:
> -		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> -		cur = NULL;
> -		xfs_buf_relse(agbp);
> -		agbp = NULL;
> -		agino = 0;
> -		agno++;
> -	} while (agno < mp->m_sb.sb_agcount);
> -
> -	if (!error) {
> -		if (bufidx) {
> -			long	written;
> -
> -			error = formatter(ubuffer, buffer, bufidx, &written);
> -			if (!error)
> -				*count += bufidx;
> -		}
> -		*lastino = XFS_AGINO_TO_INO(mp, agno, agino);
> -	}
> +	error = xfs_inobt_walk(breq->mp, NULL, breq->startino,
> +			xfs_inumbers_walk, breq->icount, &ic);
>  
> -	kmem_free(buffer);
> -	if (cur)
> -		xfs_btree_del_cursor(cur, error);
> -	if (agbp)
> -		xfs_buf_relse(agbp);
> +	/*
> +	 * We found some inode groups, so clear the error status and return
> +	 * them.  The lastino pointer will point directly at the inode that
> +	 * triggered any error that occurred, so on the next call the error
> +	 * will be triggered again and propagated to userspace as there will be
> +	 * no formatted inode groups in the buffer.
> +	 */
> +	if (breq->ocount > 0)
> +		error = 0;
>  
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 328a161b8898..1e1a5bb9fd9f 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -46,25 +46,9 @@ typedef int (*bulkstat_one_fmt_pf)(struct xfs_ibulk *breq,
>  int xfs_bulkstat_one(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
>  int xfs_bulkstat(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
>  
> -typedef int (*inumbers_fmt_pf)(
> -	void			__user *ubuffer, /* buffer to write to */
> -	const xfs_inogrp_t	*buffer,	/* buffer to read from */
> -	long			count,		/* # of elements to read */
> -	long			*written);	/* # of bytes written */
> +typedef int (*inumbers_fmt_pf)(struct xfs_ibulk *breq,
> +		const struct xfs_inogrp *igrp);
>  
> -int
> -xfs_inumbers_fmt(
> -	void			__user *ubuffer, /* buffer to write to */
> -	const xfs_inogrp_t	*buffer,	/* buffer to read from */
> -	long			count,		/* # of elements to read */
> -	long			*written);	/* # of bytes written */
> -
> -int					/* error status */
> -xfs_inumbers(
> -	xfs_mount_t		*mp,	/* mount point for filesystem */
> -	xfs_ino_t		*last,	/* last inode returned */
> -	int			*count,	/* size of buffer/count returned */
> -	void			__user *buffer, /* buffer with inode info */
> -	inumbers_fmt_pf		formatter);
> +int xfs_inumbers(struct xfs_ibulk *breq, inumbers_fmt_pf formatter);
>  
>  #endif	/* __XFS_ITABLE_H__ */
> 
