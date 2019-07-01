Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4BE20D91
	for <lists+linux-xfs@lfdr.de>; Thu, 16 May 2019 18:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfEPQ76 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 May 2019 12:59:58 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44010 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbfEPQ76 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 May 2019 12:59:58 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4GGsiQZ079375;
        Thu, 16 May 2019 16:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=cnuDv3B2oi2jJuBReL+8AblJ3blNy/S0fX3pm8lJ5g8=;
 b=RMjdR9Rg1ScOmNqSeAAyaFsYx1KDp+8Zohp7+2Z+yBXFHMsUyZ/RY3AQstDLuIRpB0Xy
 zkrraM69Bqa977tw34vaI6Eupsadi40k2eoELx/SVQ4HQoopfPYrOei9iVvD5nwGJBmb
 DABPbKdTtADzaAPzY/mYupqiHaHG1aIJWArLX9JX9TV0dy1s5RTNcViHk37WJXgZEFnl
 O+YbB1uOV5dn2CsCQn0b2z9wI4/0pGkehOMgpAEnKXyI/LVpWpvGknWOdnKtxrM5P6mu
 TxrxKStCK1eyfFmO6jzi1zDuoK3125Gu5s9BDrTet+EJJdNCCaOiz0GnhDWq2c1HsJfh Rw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2sdkwe51qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 May 2019 16:59:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4GGxPYi047304;
        Thu, 16 May 2019 16:59:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2sgp3348kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 May 2019 16:59:43 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4GGxfJm008603;
        Thu, 16 May 2019 16:59:42 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 May 2019 09:59:41 -0700
Subject: Re: [PATCH] xfs: remove unused flag arguments
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <ed89244f-cc3a-6bcf-316c-68edc8aee4cc@redhat.com>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <2c38528b-98e6-d1c7-7b26-cdcf65370442@oracle.com>
Date:   Thu, 16 May 2019 09:59:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ed89244f-cc3a-6bcf-316c-68edc8aee4cc@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9259 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905160107
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9259 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905160107
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Look ok to me.  You can add my review:

Reviewed-by: Allison Collins <allison.henderson@oracle.com>

On 5/15/19 11:37 AM, Eric Sandeen wrote:
> There are several functions which take a flag argument that is
> only ever passed as "0," so remove these arguments.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> (motivated by simplifying userspace libxfs, TBH)
> 
>   libxfs/xfs_ag.c          |    8 ++++----
>   libxfs/xfs_alloc.c       |    4 ++--
>   libxfs/xfs_attr_remote.c |    2 +-
>   libxfs/xfs_bmap.c        |   14 +++++++-------
>   libxfs/xfs_btree.c       |   30 +++++++++++-------------------
>   libxfs/xfs_btree.h       |   10 +++-------
>   libxfs/xfs_sb.c          |    2 +-
>   scrub/repair.c           |    2 +-
>   xfs_bmap_util.c          |    6 +++---
>   xfs_buf.h                |    5 ++---
>   10 files changed, 35 insertions(+), 48 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index b0c89f5..5efb827 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -53,7 +53,7 @@
>   	struct xfs_buf		*bp,
>   	struct aghdr_init_data	*id)
>   {
> -	xfs_btree_init_block(mp, bp, id->type, 0, 0, id->agno, 0);
> +	xfs_btree_init_block(mp, bp, id->type, 0, 0, id->agno);
>   }
>   
>   /*
> @@ -67,7 +67,7 @@
>   {
>   	struct xfs_alloc_rec	*arec;
>   
> -	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, id->agno, 0);
> +	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, id->agno);
>   	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
>   	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
>   	arec->ar_blockcount = cpu_to_be32(id->agsize -
> @@ -82,7 +82,7 @@
>   {
>   	struct xfs_alloc_rec	*arec;
>   
> -	xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 1, id->agno, 0);
> +	xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 1, id->agno);
>   	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
>   	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
>   	arec->ar_blockcount = cpu_to_be32(id->agsize -
> @@ -101,7 +101,7 @@
>   	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
>   	struct xfs_rmap_rec	*rrec;
>   
> -	xfs_btree_init_block(mp, bp, XFS_BTNUM_RMAP, 0, 4, id->agno, 0);
> +	xfs_btree_init_block(mp, bp, XFS_BTNUM_RMAP, 0, 4, id->agno);
>   
>   	/*
>   	 * mark the AG header regions as static metadata The BNO
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index a9ff3cf..dbbff82 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1627,7 +1627,7 @@ STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
>   				xfs_buf_t	*bp;
>   
>   				bp = xfs_btree_get_bufs(args->mp, args->tp,
> -					args->agno, fbno, 0);
> +					args->agno, fbno);
>   				if (!bp) {
>   					error = -EFSCORRUPTED;
>   					goto error0;
> @@ -2095,7 +2095,7 @@ STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
>   	if (error)
>   		return error;
>   
> -	bp = xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno, 0);
> +	bp = xfs_btree_get_bufs(tp->t_mountp, tp, agno, agbno);
>   	if (!bp)
>   		return -EFSCORRUPTED;
>   	xfs_trans_binval(tp, bp);
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 65ff600..8b47f91 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -535,7 +535,7 @@
>   		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
>   		dblkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
>   
> -		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt, 0);
> +		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, dblkcnt);
>   		if (!bp)
>   			return -ENOMEM;
>   		bp->b_ops = &xfs_attr3_rmt_buf_ops;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 356ebd1..4133bc46 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -370,7 +370,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>   		bp = xfs_bmap_get_bp(cur, XFS_FSB_TO_DADDR(mp, bno));
>   		if (!bp) {
>   			bp_release = 1;
> -			error = xfs_btree_read_bufl(mp, NULL, bno, 0, &bp,
> +			error = xfs_btree_read_bufl(mp, NULL, bno, &bp,
>   						XFS_BMAP_BTREE_REF,
>   						&xfs_bmbt_buf_ops);
>   			if (error)
> @@ -454,7 +454,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>   		bp = xfs_bmap_get_bp(cur, XFS_FSB_TO_DADDR(mp, bno));
>   		if (!bp) {
>   			bp_release = 1;
> -			error = xfs_btree_read_bufl(mp, NULL, bno, 0, &bp,
> +			error = xfs_btree_read_bufl(mp, NULL, bno, &bp,
>   						XFS_BMAP_BTREE_REF,
>   						&xfs_bmbt_buf_ops);
>   			if (error)
> @@ -619,7 +619,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>   	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp,
>   			xfs_btree_check_lptr(cur, cbno, 1));
>   #endif
> -	error = xfs_btree_read_bufl(mp, tp, cbno, 0, &cbp, XFS_BMAP_BTREE_REF,
> +	error = xfs_btree_read_bufl(mp, tp, cbno, &cbp, XFS_BMAP_BTREE_REF,
>   				&xfs_bmbt_buf_ops);
>   	if (error)
>   		return error;
> @@ -732,7 +732,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>   	cur->bc_private.b.allocated++;
>   	ip->i_d.di_nblocks++;
>   	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
> -	abp = xfs_btree_get_bufl(mp, tp, args.fsbno, 0);
> +	abp = xfs_btree_get_bufl(mp, tp, args.fsbno);
>   	if (!abp) {
>   		error = -EFSCORRUPTED;
>   		goto out_unreserve_dquot;
> @@ -878,7 +878,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>   	ASSERT(args.fsbno != NULLFSBLOCK);
>   	ASSERT(args.len == 1);
>   	tp->t_firstblock = args.fsbno;
> -	bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno, 0);
> +	bp = xfs_btree_get_bufl(args.mp, tp, args.fsbno);
>   
>   	/*
>   	 * Initialize the block, copy the data and log the remote buffer.
> @@ -1203,7 +1203,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>   	 * pointer (leftmost) at each level.
>   	 */
>   	while (level-- > 0) {
> -		error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
> +		error = xfs_btree_read_bufl(mp, tp, bno, &bp,
>   				XFS_BMAP_BTREE_REF, &xfs_bmbt_buf_ops);
>   		if (error)
>   			goto out;
> @@ -1276,7 +1276,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
>   		 */
>   		if (bno == NULLFSBLOCK)
>   			break;
> -		error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
> +		error = xfs_btree_read_bufl(mp, tp, bno, &bp,
>   				XFS_BMAP_BTREE_REF, &xfs_bmbt_buf_ops);
>   		if (error)
>   			goto out;
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index bbdae2b..7d3d7c4 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -691,14 +691,13 @@ struct xfs_btree_block *		/* generic btree block pointer */
>   xfs_btree_get_bufl(
>   	xfs_mount_t	*mp,		/* file system mount point */
>   	xfs_trans_t	*tp,		/* transaction pointer */
> -	xfs_fsblock_t	fsbno,		/* file system block number */
> -	uint		lock)		/* lock flags for get_buf */
> +	xfs_fsblock_t	fsbno)		/* file system block number */
>   {
>   	xfs_daddr_t		d;		/* real disk block address */
>   
>   	ASSERT(fsbno != NULLFSBLOCK);
>   	d = XFS_FSB_TO_DADDR(mp, fsbno);
> -	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, lock);
> +	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0);
>   }
>   
>   /*
> @@ -710,15 +709,14 @@ struct xfs_btree_block *		/* generic btree block pointer */
>   	xfs_mount_t	*mp,		/* file system mount point */
>   	xfs_trans_t	*tp,		/* transaction pointer */
>   	xfs_agnumber_t	agno,		/* allocation group number */
> -	xfs_agblock_t	agbno,		/* allocation group block number */
> -	uint		lock)		/* lock flags for get_buf */
> +	xfs_agblock_t	agbno)		/* allocation group block number */
>   {
>   	xfs_daddr_t		d;		/* real disk block address */
>   
>   	ASSERT(agno != NULLAGNUMBER);
>   	ASSERT(agbno != NULLAGBLOCK);
>   	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
> -	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, lock);
> +	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0);
>   }
>   
>   /*
> @@ -845,7 +843,6 @@ struct xfs_btree_block *		/* generic btree block pointer */
>   	struct xfs_mount	*mp,		/* file system mount point */
>   	struct xfs_trans	*tp,		/* transaction pointer */
>   	xfs_fsblock_t		fsbno,		/* file system block number */
> -	uint			lock,		/* lock flags for read_buf */
>   	struct xfs_buf		**bpp,		/* buffer for fsbno */
>   	int			refval,		/* ref count value for buffer */
>   	const struct xfs_buf_ops *ops)
> @@ -858,7 +855,7 @@ struct xfs_btree_block *		/* generic btree block pointer */
>   		return -EFSCORRUPTED;
>   	d = XFS_FSB_TO_DADDR(mp, fsbno);
>   	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, d,
> -				   mp->m_bsize, lock, &bp, ops);
> +				   mp->m_bsize, 0, &bp, ops);
>   	if (error)
>   		return error;
>   	if (bp)
> @@ -1185,11 +1182,10 @@ struct xfs_btree_block *		/* generic btree block pointer */
>   	xfs_btnum_t	btnum,
>   	__u16		level,
>   	__u16		numrecs,
> -	__u64		owner,
> -	unsigned int	flags)
> +	__u64		owner)
>   {
>   	xfs_btree_init_block_int(mp, XFS_BUF_TO_BLOCK(bp), bp->b_bn,
> -				 btnum, level, numrecs, owner, flags);
> +				 btnum, level, numrecs, owner, 0);
>   }
>   
>   STATIC void
> @@ -1288,7 +1284,6 @@ struct xfs_btree_block *		/* generic btree block pointer */
>   xfs_btree_get_buf_block(
>   	struct xfs_btree_cur	*cur,
>   	union xfs_btree_ptr	*ptr,
> -	int			flags,
>   	struct xfs_btree_block	**block,
>   	struct xfs_buf		**bpp)
>   {
> @@ -1296,14 +1291,11 @@ struct xfs_btree_block *		/* generic btree block pointer */
>   	xfs_daddr_t		d;
>   	int			error;
>   
> -	/* need to sort out how callers deal with failures first */
> -	ASSERT(!(flags & XBF_TRYLOCK));
> -
>   	error = xfs_btree_ptr_to_daddr(cur, ptr, &d);
>   	if (error)
>   		return error;
>   	*bpp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
> -				 mp->m_bsize, flags);
> +				 mp->m_bsize, 0);
>   
>   	if (!*bpp)
>   		return -ENOMEM;
> @@ -2706,7 +2698,7 @@ struct xfs_btree_block *		/* generic btree block pointer */
>   	XFS_BTREE_STATS_INC(cur, alloc);
>   
>   	/* Set up the new block as "right". */
> -	error = xfs_btree_get_buf_block(cur, &rptr, 0, &right, &rbp);
> +	error = xfs_btree_get_buf_block(cur, &rptr, &right, &rbp);
>   	if (error)
>   		goto error0;
>   
> @@ -2961,7 +2953,7 @@ struct xfs_btree_split_args {
>   	XFS_BTREE_STATS_INC(cur, alloc);
>   
>   	/* Copy the root into a real block. */
> -	error = xfs_btree_get_buf_block(cur, &nptr, 0, &cblock, &cbp);
> +	error = xfs_btree_get_buf_block(cur, &nptr, &cblock, &cbp);
>   	if (error)
>   		goto error0;
>   
> @@ -3058,7 +3050,7 @@ struct xfs_btree_split_args {
>   	XFS_BTREE_STATS_INC(cur, alloc);
>   
>   	/* Set up the new block. */
> -	error = xfs_btree_get_buf_block(cur, &lptr, 0, &new, &nbp);
> +	error = xfs_btree_get_buf_block(cur, &lptr, &new, &nbp);
>   	if (error)
>   		goto error0;
>   
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index e3b3e9d..8d2b250 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -301,8 +301,7 @@ struct xfs_buf *				/* buffer for fsbno */
>   xfs_btree_get_bufl(
>   	struct xfs_mount	*mp,	/* file system mount point */
>   	struct xfs_trans	*tp,	/* transaction pointer */
> -	xfs_fsblock_t		fsbno,	/* file system block number */
> -	uint			lock);	/* lock flags for get_buf */
> +	xfs_fsblock_t		fsbno);	/* file system block number */
>   
>   /*
>    * Get a buffer for the block, return it with no data read.
> @@ -313,8 +312,7 @@ struct xfs_buf *				/* buffer for agno/agbno */
>   	struct xfs_mount	*mp,	/* file system mount point */
>   	struct xfs_trans	*tp,	/* transaction pointer */
>   	xfs_agnumber_t		agno,	/* allocation group number */
> -	xfs_agblock_t		agbno,	/* allocation group block number */
> -	uint			lock);	/* lock flags for get_buf */
> +	xfs_agblock_t		agbno);	/* allocation group block number */
>   
>   /*
>    * Check for the cursor referring to the last block at the given level.
> @@ -345,7 +343,6 @@ struct xfs_buf *				/* buffer for agno/agbno */
>   	struct xfs_mount	*mp,	/* file system mount point */
>   	struct xfs_trans	*tp,	/* transaction pointer */
>   	xfs_fsblock_t		fsbno,	/* file system block number */
> -	uint			lock,	/* lock flags for read_buf */
>   	struct xfs_buf		**bpp,	/* buffer for fsbno */
>   	int			refval,	/* ref count value for buffer */
>   	const struct xfs_buf_ops *ops);
> @@ -383,8 +380,7 @@ struct xfs_buf *				/* buffer for agno/agbno */
>   	xfs_btnum_t	btnum,
>   	__u16		level,
>   	__u16		numrecs,
> -	__u64		owner,
> -	unsigned int	flags);
> +	__u64		owner);
>   
>   void
>   xfs_btree_init_block_int(
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index e76a3e5..8bca140 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1005,7 +1005,7 @@ struct xfs_perag *
>   
>   		bp = xfs_buf_get(mp->m_ddev_targp,
>   				 XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
> -				 XFS_FSS_TO_BB(mp, 1), 0);
> +				 XFS_FSS_TO_BB(mp, 1));
>   		/*
>   		 * If we get an error reading or writing alternate superblocks,
>   		 * continue.  xfs_repair chooses the "best" superblock based
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index eb358f0..e710005 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -357,7 +357,7 @@
>   	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, XFS_FSB_TO_DADDR(mp, fsb),
>   			XFS_FSB_TO_BB(mp, 1), 0);
>   	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
> -	xfs_btree_init_block(mp, bp, btnum, 0, 0, sc->sa.agno, 0);
> +	xfs_btree_init_block(mp, bp, btnum, 0, 0, sc->sa.agno);
>   	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
>   	xfs_trans_log_buf(tp, bp, 0, bp->b_length);
>   	bp->b_ops = ops;
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 06d07f1..b8fa6d3 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -276,7 +276,7 @@
>   	struct xfs_btree_block	*block, *nextblock;
>   	int			numrecs;
>   
> -	error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp, XFS_BMAP_BTREE_REF,
> +	error = xfs_btree_read_bufl(mp, tp, bno, &bp, XFS_BMAP_BTREE_REF,
>   						&xfs_bmbt_buf_ops);
>   	if (error)
>   		return error;
> @@ -287,7 +287,7 @@
>   		/* Not at node above leaves, count this level of nodes */
>   		nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
>   		while (nextbno != NULLFSBLOCK) {
> -			error = xfs_btree_read_bufl(mp, tp, nextbno, 0, &nbp,
> +			error = xfs_btree_read_bufl(mp, tp, nextbno, &nbp,
>   						XFS_BMAP_BTREE_REF,
>   						&xfs_bmbt_buf_ops);
>   			if (error)
> @@ -321,7 +321,7 @@
>   			if (nextbno == NULLFSBLOCK)
>   				break;
>   			bno = nextbno;
> -			error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
> +			error = xfs_btree_read_bufl(mp, tp, bno, &bp,
>   						XFS_BMAP_BTREE_REF,
>   						&xfs_bmbt_buf_ops);
>   			if (error)
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index d0b96e0..f13c018 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -239,11 +239,10 @@ void xfs_buf_readahead_map(struct xfs_buftarg *target,
>   xfs_buf_get(
>   	struct xfs_buftarg	*target,
>   	xfs_daddr_t		blkno,
> -	size_t			numblks,
> -	xfs_buf_flags_t		flags)
> +	size_t			numblks)
>   {
>   	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
> -	return xfs_buf_get_map(target, &map, 1, flags);
> +	return xfs_buf_get_map(target, &map, 1, 0);
>   }
>   
>   static inline struct xfs_buf *
> 
