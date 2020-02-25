Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0175116EC5F
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2020 18:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgBYRUF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 12:20:05 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34479 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730958AbgBYRUF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 12:20:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582651203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QsRz31c63y3vTEHdwrJb7egqUNa4PvLxo7f2T8OOr7k=;
        b=iHIABa243En+nsJINUvnscNEWtOxCK32mNSn0RGPy4GVDbhm1o724fizJoPpwrnrS9li9x
        fvum4Li/BsVCAmsV5iZuTXIkghsWwmeZb/amPWcbZUFSzKg6EcNx/tFsTxaZ4AkjLsGHe3
        dwZSNuWJ2SK52jRu22jE66nZgrIbFpU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-Hevt07ofN_eW8I3vh9HFWw-1; Tue, 25 Feb 2020 12:19:59 -0500
X-MC-Unique: Hevt07ofN_eW8I3vh9HFWw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 609B71005512;
        Tue, 25 Feb 2020 17:19:57 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B48B60BF7;
        Tue, 25 Feb 2020 17:19:56 +0000 (UTC)
Date:   Tue, 25 Feb 2020 12:19:54 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 7/7] xfs: Fix log reservation calculation for
 xattr insert operation
Message-ID: <20200225171954.GF54181@bfoster>
References: <20200224040044.30923-1-chandanrlinux@gmail.com>
 <20200224040044.30923-8-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224040044.30923-8-chandanrlinux@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 09:30:44AM +0530, Chandan Rajendra wrote:
> Log space reservation for xattr insert operation can be divided into two
> parts,
> 1. Mount time
>    - Inode
>    - Superblock for accounting space allocations
>    - AGF for accounting space used by count, block number, rmap and refcnt
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
> Also, AGF log space reservation isn't accounted for.
> 
> Due to the reasons mentioned above, log reservation calculation for xattr
> insert operation gives an incorrect value.
> 
> Apart from the above, xfs_log_calc_max_attrsetm_res() passes byte count as
> an argument to XFS_NEXTENTADD_SPACE_RES() instead of block count.
> 
> To fix these issues, this commit changes xfs_attr_calc_size() to also
> calculate the number of dabtree blocks that need to be logged.
> 
> xfs_attr_set() uses the following values computed by xfs_attr_calc_size()
> 1. The number of dabtree blocks that need to be logged.
> 2. The number of remote blocks that need to be allocated.
> 3. The number of dabtree blocks that need to be allocated.
> 4. The number of bmbt blocks that need to be allocated.
> 5. The total number of blocks that need to be allocated.
> 
> ... to compute number of bytes that need to be reserved in the log.
> 
> This commit also modifies xfs_log_calc_max_attrsetm_res() to invoke
> xfs_attr_calc_size() to obtain the number of blocks to be logged which it uses
> to figure out the total number of bytes to be logged.
> 
> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c       |  7 +++--
>  fs/xfs/libxfs/xfs_attr.h       |  3 ++
>  fs/xfs/libxfs/xfs_log_rlimit.c | 16 +++++------
>  fs/xfs/libxfs/xfs_trans_resv.c | 50 ++++++++++++++++------------------
>  fs/xfs/libxfs/xfs_trans_resv.h |  2 ++
>  5 files changed, 41 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1d62ce80d7949..f056f8597ee03 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -182,9 +182,12 @@ xfs_attr_calc_size(
>  	size = xfs_attr_leaf_newentsize(mp->m_attr_geo, namelen, valuelen,
>  			local);
>  	resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> +	resv->log_dablks = 2 * resv->total_dablks;
> +
>  	if (*local) {
>  		if (size > (blksize / 2)) {
>  			/* Double split possible */
> +			resv->log_dablks += resv->total_dablks;

I'm not quite clear on why log is double the total above, then we add an
increment of total here. Can you elaborate on this?

>  			resv->total_dablks *= 2;
>  		}
>  		resv->rmt_blks = 0;
> @@ -349,9 +352,7 @@ xfs_attr_set(
>  				return error;
>  		}
>  
> -		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> -				 M_RES(mp)->tr_attrsetrt.tr_logres *
> -					args->total;
> +		tres.tr_logres = xfs_calc_attr_res(mp, &resv);

So instead of using the runtime reservation calculation, we call this
new function that uses the block res structure and calculates log
reservation for us. Seems like a decent cleanup, but I'm still having
some trouble determining what is cleanup vs. what is fixing the res
calculation.

>  		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
>  		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
>  		total = args->total;
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 0e387230744c3..83508148bbd12 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -74,6 +74,9 @@ struct xfs_attr_list_context {
>  };
>  
>  struct xfs_attr_set_resv {
> +	/* Number of blocks in the da btree that we might need to log. */
> +	unsigned int		log_dablks;
> +
>  	/* Number of unlogged blocks needed to store the remote attr value. */
>  	unsigned int		rmt_blks;
>  
> diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> index 7f55eb3f36536..a132ffa7adf32 100644
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
> @@ -21,19 +22,18 @@
>   */
>  STATIC int
>  xfs_log_calc_max_attrsetm_res(
> -	struct xfs_mount	*mp)
> +	struct xfs_mount		*mp)
>  {
> -	int			size;
> -	int			nblks;
> +	struct xfs_attr_set_resv	resv;
> +	int				size;
> +	int				local;
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
> index 7a9c04920505a..c6b8cd56df2d7 100644
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
> @@ -832,6 +811,25 @@ xfs_calc_sb_reservation(
>  	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
>  }
>  
> +uint
> +xfs_calc_attr_res(
> +	struct xfs_mount		*mp,
> +	struct xfs_attr_set_resv	*resv)
> +{
> +	unsigned int			space_blks;
> +	unsigned int			attr_res;
> +
> +	space_blks = xfs_allocfree_log_count(mp,
> +		resv->total_dablks + resv->bmbt_blks);
> +
> +	attr_res = M_RES(mp)->tr_attrsetm.tr_logres +
> +		xfs_calc_buf_res(resv->log_dablks, mp->m_attr_geo->blksize) +
> +		xfs_calc_buf_res(resv->bmbt_blks, mp->m_sb.sb_blocksize) +
> +		xfs_calc_buf_res(space_blks, mp->m_sb.sb_blocksize);
> +
> +	return attr_res;
> +}

This function could use a header comment to explain what the reservation
covers.

> +
>  void
>  xfs_trans_resv_calc(
>  	struct xfs_mount	*mp,
> @@ -942,7 +940,7 @@ xfs_trans_resv_calc(
>  	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
>  	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
>  	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
> -	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
> +	resp->tr_attrsetrt.tr_logres = 0;

Should this go away if it's going to end up as zero?

Brian

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

