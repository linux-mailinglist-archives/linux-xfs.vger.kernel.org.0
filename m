Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 693D05E560
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jul 2019 15:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfGCNZG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Jul 2019 09:25:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbfGCNZF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jul 2019 09:25:05 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0D2DF30BB523;
        Wed,  3 Jul 2019 13:25:05 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BD6A6013C;
        Wed,  3 Jul 2019 13:25:04 +0000 (UTC)
Date:   Wed, 3 Jul 2019 09:25:02 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 8/9] xfs: specify AG in bulk req
Message-ID: <20190703132502.GH26057@bfoster>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158198545.495715.13588754159200411056.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158198545.495715.13588754159200411056.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 03 Jul 2019 13:25:05 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 01:46:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new xfs_bulk_ireq flag to constrain the iteration to a single AG.
> If the passed-in startino value is zero then we start with the first
> inode in the AG that the user passes in; otherwise, we iterate only
> within the same AG as the passed-in inode.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_fs.h |   10 ++++++++--
>  fs/xfs/xfs_ioctl.c     |   25 ++++++++++++++++++++++++-
>  fs/xfs/xfs_itable.c    |    6 +++---
>  fs/xfs/xfs_itable.h    |    4 ++++
>  fs/xfs/xfs_iwalk.c     |   12 ++++++++++++
>  fs/xfs/xfs_iwalk.h     |   22 +++++++++++++++++-----
>  fs/xfs/xfs_qm.c        |    3 ++-
>  7 files changed, 70 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index f9f35139d4b7..77c06850ac52 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -462,11 +462,17 @@ struct xfs_bulk_ireq {
>  	uint32_t	flags;		/* I/O: operation flags		*/
>  	uint32_t	icount;		/* I: count of entries in buffer */
>  	uint32_t	ocount;		/* O: count of entries filled out */
> -	uint32_t	reserved32;	/* must be zero			*/
> +	uint32_t	agno;		/* I: see comment for IREQ_AGNO	*/
>  	uint64_t	reserved[5];	/* must be zero			*/
>  };
>  
> -#define XFS_BULK_IREQ_FLAGS_ALL	(0)
> +/*
> + * Only return results from the specified @agno.  If @ino is zero, start
> + * with the first inode of @agno.
> + */
> +#define XFS_BULK_IREQ_AGNO	(1 << 0)
> +
> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO)
>  
>  /* Header for a single inode request. */
>  struct xfs_ireq {
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 2ac5e100b147..f71341cd8340 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -853,7 +853,6 @@ xfs_bulk_ireq_setup(
>  {
>  	if (hdr->icount == 0 ||
>  	    (hdr->flags & ~XFS_BULK_IREQ_FLAGS_ALL) ||
> -	    hdr->reserved32 ||
>  	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
>  		return -EINVAL;
>  
> @@ -861,6 +860,29 @@ xfs_bulk_ireq_setup(
>  	breq->ubuffer = ubuffer;
>  	breq->icount = hdr->icount;
>  	breq->ocount = 0;
> +	breq->flags = 0;
> +
> +	/*
> +	 * The IREQ_AGNO flag means that we only want results from a given AG.
> +	 * If @hdr->ino is zero, we start iterating in that AG.  If @hdr->ino is
> +	 * beyond the specified AG then we return no results.
> +	 */
> +	if (hdr->flags & XFS_BULK_IREQ_AGNO) {
> +		if (hdr->agno >= mp->m_sb.sb_agcount)
> +			return -EINVAL;
> +
> +		if (breq->startino == 0)
> +			breq->startino = XFS_AGINO_TO_INO(mp, hdr->agno, 0);
> +		else if (XFS_INO_TO_AGNO(mp, breq->startino) < hdr->agno)
> +			return -EINVAL;
> +
> +		breq->flags |= XFS_IBULK_SAME_AG;
> +
> +		/* Asking for an inode past the end of the AG?  We're done! */
> +		if (XFS_INO_TO_AGNO(mp, breq->startino) > hdr->agno)
> +			return XFS_ITER_ABORT;
> +	} else if (hdr->agno)
> +		return -EINVAL;
>  
>  	/* Asking for an inode past the end of the FS?  We're done! */
>  	if (XFS_INO_TO_AGNO(mp, breq->startino) >= mp->m_sb.sb_agcount)
> @@ -945,6 +967,7 @@ xfs_ireq_setup(
>  	breq->ubuffer = ubuffer;
>  	breq->icount = 1;
>  	breq->startino = hdr->ino;
> +	breq->flags = 0;
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 745b04f59132..f92a1508a2bd 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -248,8 +248,8 @@ xfs_bulkstat(
>  	if (!bc.buf)
>  		return -ENOMEM;
>  
> -	error = xfs_iwalk(breq->mp, NULL, breq->startino, xfs_bulkstat_iwalk,
> -			breq->icount, &bc);
> +	error = xfs_iwalk(breq->mp, NULL, breq->startino, breq->flags,
> +			xfs_bulkstat_iwalk, breq->icount, &bc);
>  
>  	kmem_free(bc.buf);
>  
> @@ -367,7 +367,7 @@ xfs_inumbers(
>  	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
>  		return 0;
>  
> -	error = xfs_inobt_walk(breq->mp, NULL, breq->startino,
> +	error = xfs_inobt_walk(breq->mp, NULL, breq->startino, breq->flags,
>  			xfs_inumbers_walk, breq->icount, &ic);
>  
>  	/*
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index fa9fb9104c7f..e90c1fc5b981 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -12,8 +12,12 @@ struct xfs_ibulk {
>  	xfs_ino_t		startino; /* start with this inode */
>  	unsigned int		icount;   /* number of elements in ubuffer */
>  	unsigned int		ocount;   /* number of records returned */
> +	unsigned int		flags;    /* see XFS_IBULK_FLAG_* */
>  };
>  
> +/* Only iterate within the same AG as startino */
> +#define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
> +
>  /* Return value that means we want to abort the walk. */
>  #define XFS_IBULK_ABORT		(XFS_IWALK_ABORT)
>  
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index 80c139aed264..d21d9fe71f3d 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -519,6 +519,7 @@ xfs_iwalk(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
>  	xfs_ino_t		startino,
> +	unsigned int		flags,
>  	xfs_iwalk_fn		iwalk_fn,
>  	unsigned int		inode_records,
>  	void			*data)
> @@ -538,6 +539,7 @@ xfs_iwalk(
>  	int			error;
>  
>  	ASSERT(agno < mp->m_sb.sb_agcount);
> +	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
>  
>  	error = xfs_iwalk_alloc(&iwag);
>  	if (error)
> @@ -548,6 +550,8 @@ xfs_iwalk(
>  		if (error)
>  			break;
>  		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
> +		if (flags & XFS_INOBT_WALK_SAME_AG)
> +			break;
>  	}
>  
>  	xfs_iwalk_free(&iwag);
> @@ -586,6 +590,7 @@ int
>  xfs_iwalk_threaded(
>  	struct xfs_mount	*mp,
>  	xfs_ino_t		startino,
> +	unsigned int		flags,
>  	xfs_iwalk_fn		iwalk_fn,
>  	unsigned int		inode_records,
>  	bool			polled,
> @@ -597,6 +602,7 @@ xfs_iwalk_threaded(
>  	int			error;
>  
>  	ASSERT(agno < mp->m_sb.sb_agcount);
> +	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
>  
>  	nr_threads = xfs_pwork_guess_datadev_parallelism(mp);
>  	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk",
> @@ -618,6 +624,8 @@ xfs_iwalk_threaded(
>  		iwag->sz_recs = xfs_iwalk_prefetch(inode_records);
>  		xfs_pwork_queue(&pctl, &iwag->pwork);
>  		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
> +		if (flags & XFS_INOBT_WALK_SAME_AG)
> +			break;
>  	}
>  
>  	if (polled)
> @@ -674,6 +682,7 @@ xfs_inobt_walk(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
>  	xfs_ino_t		startino,
> +	unsigned int		flags,
>  	xfs_inobt_walk_fn	inobt_walk_fn,
>  	unsigned int		inobt_records,
>  	void			*data)
> @@ -691,6 +700,7 @@ xfs_inobt_walk(
>  	int			error;
>  
>  	ASSERT(agno < mp->m_sb.sb_agcount);
> +	ASSERT(!(flags & ~XFS_INOBT_WALK_FLAGS_ALL));
>  
>  	error = xfs_iwalk_alloc(&iwag);
>  	if (error)
> @@ -701,6 +711,8 @@ xfs_inobt_walk(
>  		if (error)
>  			break;
>  		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
> +		if (flags & XFS_INOBT_WALK_SAME_AG)
> +			break;
>  	}
>  
>  	xfs_iwalk_free(&iwag);
> diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
> index 67462861680c..6c960e10ed4d 100644
> --- a/fs/xfs/xfs_iwalk.h
> +++ b/fs/xfs/xfs_iwalk.h
> @@ -14,10 +14,16 @@ typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
>  #define XFS_IWALK_ABORT		(XFS_ITER_ABORT)
>  
>  int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
> -		xfs_iwalk_fn iwalk_fn, unsigned int inode_records, void *data);
> +		unsigned int flags, xfs_iwalk_fn iwalk_fn,
> +		unsigned int inode_records, void *data);
>  int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
> -		xfs_iwalk_fn iwalk_fn, unsigned int inode_records, bool poll,
> -		void *data);
> +		unsigned int flags, xfs_iwalk_fn iwalk_fn,
> +		unsigned int inode_records, bool poll, void *data);
> +
> +/* Only iterate inodes within the same AG as @startino. */
> +#define XFS_IWALK_SAME_AG	(0x1)
> +
> +#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
>  
>  /* Walk all inode btree records in the filesystem starting from @startino. */
>  typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
> @@ -28,7 +34,13 @@ typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
>  #define XFS_INOBT_WALK_ABORT	(XFS_IWALK_ABORT)
>  
>  int xfs_inobt_walk(struct xfs_mount *mp, struct xfs_trans *tp,
> -		xfs_ino_t startino, xfs_inobt_walk_fn inobt_walk_fn,
> -		unsigned int inobt_records, void *data);
> +		xfs_ino_t startino, unsigned int flags,
> +		xfs_inobt_walk_fn inobt_walk_fn, unsigned int inobt_records,
> +		void *data);
> +
> +/* Only iterate inobt records within the same AG as @startino. */
> +#define XFS_INOBT_WALK_SAME_AG	(XFS_IWALK_SAME_AG)
> +
> +#define XFS_INOBT_WALK_FLAGS_ALL (XFS_INOBT_WALK_SAME_AG)
>  
>  #endif /* __XFS_IWALK_H__ */
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 8bb902125403..a526c28662ae 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1304,7 +1304,8 @@ xfs_qm_quotacheck(
>  		flags |= XFS_PQUOTA_CHKD;
>  	}
>  
> -	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, true, NULL);
> +	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
> +			NULL);
>  	if (error)
>  		goto error_return;
>  
> 
