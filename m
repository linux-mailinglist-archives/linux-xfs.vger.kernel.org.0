Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B75C15AEAF
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Feb 2020 18:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgBLR2F (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Feb 2020 12:28:05 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57740 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbgBLR2F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Feb 2020 12:28:05 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01CHOSgO099348;
        Wed, 12 Feb 2020 17:28:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ScAf/rAIUZ7FZgHu71FknCbAqP825W2sFDYvviv0qE4=;
 b=xhbLpfUfH6kqbPC80GBlhk9L/PI1WeeZRuYUfVxSfo275WVPi7GSwEjztUByXftW+gTn
 gxl7dQ5BRXEc72cwabAq7A3Lhr0HBvbtxHil2V2DcQHBDG6s3m3EixITNTMdJabryjtE
 yB1zp86ziMcnnoJXi0m8AfxsuEWkmgXpSG4fktS+/uwZPjY9/297Lm1GHOe9B6FWmmrJ
 TDINt9r7Okt8MKZs/q5n3xYkMP9WFy6tJsu6cLSF1dH/zaj7csI4gZiipMDOZoFnlNS0
 BjfFg0HkYAIAoxgLjpJ3cOOz9Jwj+c5EAi/YK3ZZ8nUBBlLeL8poLLgveprjh74fRQDl 9g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2y2k88chjy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Feb 2020 17:27:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01CHRiSe101623;
        Wed, 12 Feb 2020 17:27:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2y4k7x2gt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Feb 2020 17:27:58 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01CHRwQb031048;
        Wed, 12 Feb 2020 17:27:58 GMT
Received: from localhost (/10.159.151.237)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 09:27:57 -0800
Date:   Wed, 12 Feb 2020 09:27:56 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan@linux.ibm.com
Subject: Re: [PATCH V3 2/2] xfs: Fix log reservation calculation for xattr
 insert operation
Message-ID: <20200212172756.GN6874@magnolia>
References: <20200129045939.10380-1-chandanrlinux@gmail.com>
 <20200129045939.10380-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129045939.10380-2-chandanrlinux@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=2 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002120130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 suspectscore=2 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002120130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 10:29:39AM +0530, Chandan Rajendra wrote:
> Log space reservation for xattr insert operation can be divided into two
> parts,
> 1. Mount time
>    - Inode
>    - Superblock for accounting space allocations
>    - AGF for accounting space used be count, block number, rmapbt and refcnt
>      btrees.
> 
> 2. The remaining log space can only be calculated at run time because,
>    - A local xattr can be large enough to cause a double split of the dabtree.
>    - The value of the xattr can be large enough to be stored in remote
>      blocks. The contents of the remote blocks are not logged.
> 
>    The log space reservation could be,
>    - 2 * XFS_DA_NODE_MAXDEPTH number of blocks. Additional XFS_DA_NODE_MAXDEPTH
>      number of blocks are required if xattr is large enough to cause another
>      split of the dabtree path from root to leaf block.
>    - BMBT blocks for storing (2 * XFS_DA_NODE_MAXDEPTH) record
>      entries. Additional XFS_DA_NODE_MAXDEPTH number of blocks are required in
>      case of a double split of the dabtree path from root to leaf blocks.
>    - Space for logging blocks of count, block number, rmap and refcnt btrees.
> 
> Presently, mount time log reservation includes block count required for a
> single split of the dabtree. The dabtree block count is also taken into
> account by xfs_attr_calc_size().
> 
> Also, AGF log space reservation isn't accounted for. Hence log reservation
> calculation for xattr insert operation gives an incorrect value.
> 
> Apart from the above, xfs_log_calc_max_attrsetm_res() passes byte count as
> an argument to XFS_NEXTENTADD_SPACE_RES() instead of block count.
> 
> To fix these issues, this commit refactors xfs_attr_calc_size() to calculate,
> 1. The number of dabtree blocks that need to be logged.
> 2. The number of remote blocks that need to be allocated.
> 3. The number of dabtree blocks that need to be allocated.
> 4. The number of bmbt blocks that need to be allocated.
> 5. The total number of blocks that need to be allocated.
> 
> xfs_attr_set() uses this information to compute number of bytes that needs to
> be reserved in the log.
> 
> This commit also modifies xfs_log_calc_max_attrsetm_res() to invoke
> xfs_attr_calc_size() to obtain the number of blocks to be logged which it uses
> to figure out the total number of bytes to be logged.
> 
> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
> Changelog:
> V1 -> V2:
> 1. Use convenience variables to reduce indentation of code.
> 
> V2 -> V3:
> 1. Introduce 'struct xfs_attr_set_resv' to be used an as out parameter
>    holding xattr reservation values.
> 2. Calculate number of bmbt blocks and total allocation blocks within
>    xfs_attr_calc_size().
> 
>  fs/xfs/libxfs/xfs_attr.c       | 93 +++++++++++++++++++---------------
>  fs/xfs/libxfs/xfs_attr.h       | 20 +++++++-
>  fs/xfs/libxfs/xfs_log_rlimit.c | 14 ++---
>  fs/xfs/libxfs/xfs_trans_resv.c | 52 +++++++++----------
>  fs/xfs/libxfs/xfs_trans_resv.h |  2 +
>  5 files changed, 107 insertions(+), 74 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1eae1db74f6cd..1f3b001a1092e 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -183,43 +183,6 @@ xfs_attr_get(
>  	return 0;
>  }
>  
> -/*
> - * Calculate how many blocks we need for the new attribute,
> - */
> -STATIC int
> -xfs_attr_calc_size(
> -	struct xfs_da_args	*args,
> -	int			*local)
> -{
> -	struct xfs_mount	*mp = args->dp->i_mount;
> -	int			size;
> -	int			nblks;
> -
> -	/*
> -	 * Determine space new attribute will use, and if it would be
> -	 * "local" or "remote" (note: local != inline).
> -	 */
> -	size = xfs_attr_leaf_newentsize(mp, args->namelen, args->valuelen,
> -					local);
> -	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> -	if (*local) {
> -		if (size > (args->geo->blksize / 2)) {
> -			/* Double split possible */
> -			nblks *= 2;
> -		}
> -	} else {
> -		/*
> -		 * Out of line attribute, cannot double split, but
> -		 * make room for the attribute value itself.
> -		 */
> -		uint	dblocks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> -		nblks += dblocks;
> -		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
> -	}
> -
> -	return nblks;
> -}
> -
>  STATIC int
>  xfs_attr_try_sf_addname(
>  	struct xfs_inode	*dp,
> @@ -248,6 +211,53 @@ xfs_attr_try_sf_addname(
>  	return error ? error : error2;
>  }
>  
> +/*
> + * Calculate how many blocks we need for the new attribute,
> + */
> +void
> +xfs_attr_calc_size(
> +	struct xfs_mount		*mp,
> +	struct xfs_attr_set_resv	*resv,
> +	int				namelen,
> +	int				valuelen,
> +	int				*local)
> +{
> +	unsigned int		blksize;
> +	int			size;
> +
> +	blksize = mp->m_dir_geo->blksize;

This could be streamlined a bit:

	unsigned int			blksize = mp->m_attr_geo->blksize;
	int				size;

and indented to match the argument list.

Also please note that I changed m_dir_geo to m_attr_geo; this is the
attribute fork, not a directory.

> +	/*
> +	 * Determine space new attribute will use, and if it would be
> +	 * "local" or "remote" (note: local != inline).
> +	 */
> +	size = xfs_attr_leaf_newentsize(mp, namelen, valuelen, local);
> +
> +	resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> +	resv->log_dablks = 2 * resv->total_dablks;
> +
> +	if (*local) {
> +		if (size > (blksize / 2)) {
> +			/* Double split possible */
> +			resv->log_dablks += resv->total_dablks;
> +			resv->total_dablks *= 2;
> +		}

I think this code block should set rmt_blks = 0 so that this function
always returns a fully initialized resv structure, and then you can skip
the "= { 0 };" stuff below.

> +	} else {
> +		/*
> +		 * Out of line attribute, cannot double split, but
> +		 * make room for the attribute value itself.
> +		 */
> +		resv->rmt_blks = xfs_attr3_rmt_blocks(mp, valuelen);
> +	}
> +
> +	resv->bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp,
> +					resv->total_dablks + resv->rmt_blks,
> +					XFS_ATTR_FORK);
> +
> +	resv->alloc_blks = resv->total_dablks + resv->rmt_blks +
> +		resv->bmbt_blks;

Please fix the nth-line indentation to be consistent with (most of) the
rest of xfs here:

	resv->bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp,
			resv->total_dablks + resv->rmt_blks,
			XFS_ATTR_FORK);

	resv->alloc_blks = resv->total_dablks + resv->rmt_blks +
			resv->bmbt_blks;


> +}
> +
>  /*
>   * Set the attribute specified in @args.
>   */
> @@ -344,6 +354,7 @@ xfs_attr_set(
>  	int			flags)
>  {
>  	struct xfs_mount	*mp = dp->i_mount;
> +	struct xfs_attr_set_resv resv = { 0 };
>  	struct xfs_da_args	args;
>  	struct xfs_trans_res	tres;
>  	int			rsvd = (flags & ATTR_ROOT) != 0;
> @@ -361,7 +372,10 @@ xfs_attr_set(
>  	args.value = value;
>  	args.valuelen = valuelen;
>  	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
> -	args.total = xfs_attr_calc_size(&args, &local);
> +
> +	xfs_attr_calc_size(mp, &resv, args.namelen, args.valuelen, &local);
> +
> +	args.total = resv.alloc_blks;
>  
>  	error = xfs_qm_dqattach(dp);
>  	if (error)
> @@ -380,8 +394,7 @@ xfs_attr_set(
>  			return error;
>  	}
>  
> -	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> -			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
> +	tres.tr_logres = xfs_calc_attr_res(mp, &resv);
>  	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>  	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>  
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 94badfa1743e3..0b42faf7d6a1f 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -131,6 +131,22 @@ typedef struct xfs_attr_list_context {
>  	int				index;		/* index into output buffer */
>  } xfs_attr_list_context_t;
>  
> +struct xfs_attr_set_resv {
> +	/* Number of blocks in the da btree that we might need to log. */
> +	unsigned int		log_dablks;
> +
> +	/* Number of unlogged blocks needed to store the remote attr value. */
> +	unsigned int		rmt_blks;
> +
> +	/* Number of blocks to allocate for the da btree. */

This comment ought to read "Number of filesystem blocks..." so that
people (er... me) won't mistakenly think that total_dablks is in units
of da blocks.

Granted that might just be me overcomplicating things since da blocks ==
fs blocks for every attr tree ever.

> +	unsigned int		total_dablks;
> +
> +	/* Blocks we might need to create all the new attr fork mappings. */
> +	unsigned int		bmbt_blks;
> +
> +	/* Total number of blocks we might have to allocate. */
> +	unsigned int		alloc_blks;
> +};
>  
>  /*========================================================================
>   * Function prototypes for the kernel.
> @@ -154,5 +170,7 @@ int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
>  bool xfs_attr_namecheck(const void *name, size_t length);
> -
> +void xfs_attr_calc_size(struct xfs_mount *mp,
> +			struct xfs_attr_set_resv *resv,
> +			int namelen, int valuelen, int *local);
>  #endif	/* __XFS_ATTR_H__ */
> diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> index 7f55eb3f36536..26566c25c7e2c 100644
> --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> @@ -10,6 +10,7 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> +#include "xfs_attr.h"
>  #include "xfs_da_format.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_da_btree.h"
> @@ -23,17 +24,16 @@ STATIC int
>  xfs_log_calc_max_attrsetm_res(
>  	struct xfs_mount	*mp)
>  {
> -	int			size;
> -	int			nblks;
> +	struct xfs_attr_set_resv resv = { 0 };
> +	int		size;
> +	int		local;
>  
>  	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
>  	       MAXNAMELEN - 1;
> -	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> -	nblks += XFS_B_TO_FSB(mp, size);
> -	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
> +	xfs_attr_calc_size(mp, &resv, size, 0, &local);
> +	ASSERT(local == 1);
>  
> -	return  M_RES(mp)->tr_attrsetm.tr_logres +
> -		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
> +	return xfs_calc_attr_res(mp, &resv);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index 824073a839acb..867f1954c49bc 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -19,6 +19,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_qm.h"
>  #include "xfs_trans_space.h"
> +#include "xfs_attr.h"
>  
>  #define _ALLOC	true
>  #define _FREE	false
> @@ -701,12 +702,10 @@ xfs_calc_attrinval_reservation(
>   * Setting an attribute at mount time.
>   *	the inode getting the attribute
>   *	the superblock for allocations
> - *	the agfs extents are allocated from
> - *	the attribute btree * max depth
> - *	the inode allocation btree
> + *	the agf extents are allocated from
>   * Since attribute transaction space is dependent on the size of the attribute,
>   * the calculation is done partially at mount time and partially at runtime(see
> - * below).
> + * xfs_attr_calc_size()).
>   */
>  STATIC uint
>  xfs_calc_attrsetm_reservation(
> @@ -714,27 +713,7 @@ xfs_calc_attrsetm_reservation(
>  {
>  	return XFS_DQUOT_LOGRES(mp) +
>  		xfs_calc_inode_res(mp, 1) +
> -		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> -		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
> -}
> -
> -/*
> - * Setting an attribute at runtime, transaction space unit per block.
> - * 	the superblock for allocations: sector size
> - *	the inode bmap btree could join or split: max depth * block size
> - * Since the runtime attribute transaction space is dependent on the total
> - * blocks needed for the 1st bmap, here we calculate out the space unit for
> - * one block so that the caller could figure out the total space according
> - * to the attibute extent length in blocks by:
> - *	ext * M_RES(mp)->tr_attrsetrt.tr_logres
> - */
> -STATIC uint
> -xfs_calc_attrsetrt_reservation(
> -	struct xfs_mount	*mp)
> -{
> -	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
> -		xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
> -				 XFS_FSB_TO_B(mp, 1));
> +		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize);
>  }
>  
>  /*
> @@ -832,6 +811,27 @@ xfs_calc_sb_reservation(
>  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
>  }
>  
> +uint
> +xfs_calc_attr_res(
> +	struct xfs_mount		*mp,
> +	struct xfs_attr_set_resv	*resv)
> +{
> +	unsigned int		space_blks;
> +	unsigned int		attr_res;

Same complaint from above about the names not lining up here...

> +
> +	space_blks = xfs_allocfree_log_count(mp,
> +			resv->total_dablks + resv->bmbt_blks);
> +
> +	attr_res = M_RES(mp)->tr_attrsetm.tr_logres +
> +		xfs_calc_buf_res(resv->log_dablks,
> +				mp->m_attr_geo->blksize) +
> +		xfs_calc_buf_res(resv->bmbt_blks,
> +				mp->m_sb.sb_blocksize) +
> +		xfs_calc_buf_res(space_blks, mp->m_sb.sb_blocksize);

Each of the xfs_calc_buf_res() calls will fit on a single line, right?

--D

> +
> +	return attr_res;
> +}
> +
>  void
>  xfs_trans_resv_calc(
>  	struct xfs_mount	*mp,
> @@ -942,7 +942,7 @@ xfs_trans_resv_calc(
>  	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
>  	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
>  	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
> -	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
> +	resp->tr_attrsetrt.tr_logres = 0;
>  	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
>  	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
>  	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
> index 7241ab28cf84f..3a6a0bf21e9b1 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.h
> +++ b/fs/xfs/libxfs/xfs_trans_resv.h
> @@ -7,6 +7,7 @@
>  #define	__XFS_TRANS_RESV_H__
>  
>  struct xfs_mount;
> +struct xfs_attr_set_resv;
>  
>  /*
>   * structure for maintaining pre-calculated transaction reservations.
> @@ -91,6 +92,7 @@ struct xfs_trans_resv {
>  #define	XFS_ATTRSET_LOG_COUNT		3
>  #define	XFS_ATTRRM_LOG_COUNT		3
>  
> +uint xfs_calc_attr_res(struct xfs_mount *mp, struct xfs_attr_set_resv *resv);
>  void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
>  uint xfs_allocfree_log_count(struct xfs_mount *mp, uint num_ops);
>  
> -- 
> 2.19.1
> 
