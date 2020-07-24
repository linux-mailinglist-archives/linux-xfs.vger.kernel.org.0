Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D77F22BDA3
	for <lists+linux-xfs@lfdr.de>; Fri, 24 Jul 2020 07:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgGXFnE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 24 Jul 2020 01:43:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33672 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgGXFnE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 01:43:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06O5buuJ065306;
        Fri, 24 Jul 2020 05:43:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=YcSVzetQQTxB8rVxr9QdLVRNTtuGe8+NFnAssboH4SU=;
 b=Ytts44gDoQj3pjkckslkMFk65WyR2NSmAHjZ94TeMuAV9v2StTivwhOP9kRv7xuQ7GpZ
 sfjKks1ePPFbFhT+p5eK1LtvnQtgUR2w28HvLLqrF0t3RCMusLsHxNyasvIyt2yvMMxN
 7wy8ueEB+fPbXtA+IOg/xwaSlGdekJ4Z6IscYE68AgIvghO3fa7q8bjKw/x9QRLWBLST
 Eo8wiKNmTPJigyKCh0k9/s0UYY4faW0gpZ3HHwEiaDm/u1FR3Lh9/QfCKpFVU2a4ersP
 nQjJtSN6dXKjBKOB0wrQH0kctSA6jgbvEARGV9udWdEpQHt0x5bF4nYiqijlc13EKjKb hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32bs1mw70r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 Jul 2020 05:43:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06O5gqah113370;
        Fri, 24 Jul 2020 05:42:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32fp773bp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jul 2020 05:42:52 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06O5dXLg008779;
        Fri, 24 Jul 2020 05:39:33 GMT
Received: from localhost (/10.159.156.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jul 2020 22:39:33 -0700
Date:   Thu, 23 Jul 2020 22:39:32 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: Remove kmem_zone_zalloc() usage
Message-ID: <20200724053932.GR3151642@magnolia>
References: <20200722090518.214624-1-cmaiolino@redhat.com>
 <20200722090518.214624-3-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722090518.214624-3-cmaiolino@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=1 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240043
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9691 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 22, 2020 at 11:05:15AM +0200, Carlos Maiolino wrote:
> Use kmem_cache_zalloc() directly.
> 
> With the exception of xlog_ticket_alloc() which will be dealt on the
> next patch for readability.
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Changelog:
> 	V2:
> 		- Remove comment left by mistake on previous patch
> 		- Keep the same logic in _xfs_buf_alloc, not allowing
> 		  its allocation to fail
> 		- Fix some line breaks keeping them inside the 80char
> 		  rule.
> 
>  fs/xfs/libxfs/xfs_alloc_btree.c    | 2 +-
>  fs/xfs/libxfs/xfs_bmap.c           | 5 ++++-
>  fs/xfs/libxfs/xfs_bmap_btree.c     | 2 +-
>  fs/xfs/libxfs/xfs_da_btree.c       | 2 +-
>  fs/xfs/libxfs/xfs_ialloc_btree.c   | 2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c     | 6 +++---
>  fs/xfs/libxfs/xfs_refcount_btree.c | 2 +-
>  fs/xfs/libxfs/xfs_rmap_btree.c     | 2 +-
>  fs/xfs/xfs_bmap_item.c             | 4 ++--
>  fs/xfs/xfs_buf.c                   | 4 +---
>  fs/xfs/xfs_buf_item.c              | 2 +-
>  fs/xfs/xfs_dquot.c                 | 2 +-
>  fs/xfs/xfs_extfree_item.c          | 6 ++++--
>  fs/xfs/xfs_icreate_item.c          | 2 +-
>  fs/xfs/xfs_inode_item.c            | 3 ++-
>  fs/xfs/xfs_refcount_item.c         | 5 +++--
>  fs/xfs/xfs_rmap_item.c             | 5 +++--
>  fs/xfs/xfs_trans.c                 | 4 ++--
>  fs/xfs/xfs_trans_dquot.c           | 3 ++-
>  19 files changed, 35 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 60c453cb3ee37..57f8b16a6ea44 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -484,7 +484,7 @@ xfs_allocbt_init_common(
>  
>  	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
>  
> -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> +	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index fd5c0d669d0d7..9c40d59710357 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1099,7 +1099,10 @@ xfs_bmap_add_attrfork(
>  	if (error)
>  		goto trans_cancel;
>  	ASSERT(ip->i_afp == NULL);
> -	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
> +
> +	ip->i_afp = kmem_cache_zalloc(xfs_ifork_zone,
> +				      GFP_KERNEL | __GFP_NOFAIL);
> +
>  	ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
>  	ip->i_afp->if_flags = XFS_IFEXTENTS;
>  	logflags = 0;
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index d9c63f17d2dec..ecec604e6e4d7 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -552,7 +552,7 @@ xfs_bmbt_init_cursor(
>  	struct xfs_btree_cur	*cur;
>  	ASSERT(whichfork != XFS_COW_FORK);
>  
> -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> +	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 897749c41f36e..a4e1f01daf3d8 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -81,7 +81,7 @@ kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
>  xfs_da_state_t *
>  xfs_da_state_alloc(void)
>  {
> -	return kmem_zone_zalloc(xfs_da_state_zone, KM_NOFS);
> +	return kmem_cache_zalloc(xfs_da_state_zone, GFP_NOFS | __GFP_NOFAIL);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index b2c122ad8f0e9..3c8aebc36e643 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -411,7 +411,7 @@ xfs_inobt_init_common(
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> +	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
>  	cur->bc_btnum = btnum;
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 28b366275ae0e..0cf853d42d622 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -291,7 +291,7 @@ xfs_iformat_attr_fork(
>  	 * Initialize the extent count early, as the per-format routines may
>  	 * depend on it.
>  	 */
> -	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
> +	ip->i_afp = kmem_cache_zalloc(xfs_ifork_zone, GFP_NOFS | __GFP_NOFAIL);
>  	ip->i_afp->if_format = dip->di_aformat;
>  	if (unlikely(ip->i_afp->if_format == 0)) /* pre IRIX 6.2 file system */
>  		ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
> @@ -673,8 +673,8 @@ xfs_ifork_init_cow(
>  	if (ip->i_cowfp)
>  		return;
>  
> -	ip->i_cowfp = kmem_zone_zalloc(xfs_ifork_zone,
> -				       KM_NOFS);
> +	ip->i_cowfp = kmem_cache_zalloc(xfs_ifork_zone,
> +				       GFP_NOFS | __GFP_NOFAIL);
>  	ip->i_cowfp->if_flags = XFS_IFEXTENTS;
>  	ip->i_cowfp->if_format = XFS_DINODE_FMT_EXTENTS;
>  }
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 7fd6044a4f780..fde21b5e82ed0 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -325,7 +325,7 @@ xfs_refcountbt_init_common(
>  	ASSERT(agno != NULLAGNUMBER);
>  	ASSERT(agno < mp->m_sb.sb_agcount);
>  
> -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> +	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
>  	cur->bc_btnum = XFS_BTNUM_REFC;
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index b7c05314d07c9..caf0d799c1f42 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -457,7 +457,7 @@ xfs_rmapbt_init_common(
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
> +	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
>  	/* Overlapping btree; 2 keys per pointer. */
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 6736c5ab188f2..ec3691372e7c0 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -138,7 +138,7 @@ xfs_bui_init(
>  {
>  	struct xfs_bui_log_item		*buip;
>  
> -	buip = kmem_zone_zalloc(xfs_bui_zone, 0);
> +	buip = kmem_cache_zalloc(xfs_bui_zone, GFP_KERNEL | __GFP_NOFAIL);
>  
>  	xfs_log_item_init(mp, &buip->bui_item, XFS_LI_BUI, &xfs_bui_item_ops);
>  	buip->bui_format.bui_nextents = XFS_BUI_MAX_FAST_EXTENTS;
> @@ -215,7 +215,7 @@ xfs_trans_get_bud(
>  {
>  	struct xfs_bud_log_item		*budp;
>  
> -	budp = kmem_zone_zalloc(xfs_bud_zone, 0);
> +	budp = kmem_cache_zalloc(xfs_bud_zone, GFP_KERNEL | __GFP_NOFAIL);
>  	xfs_log_item_init(tp->t_mountp, &budp->bud_item, XFS_LI_BUD,
>  			  &xfs_bud_item_ops);
>  	budp->bud_buip = buip;
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index dda0c94458797..d4cdcb6fb2fe1 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -214,9 +214,7 @@ _xfs_buf_alloc(
>  	int			i;
>  
>  	*bpp = NULL;
> -	bp = kmem_zone_zalloc(xfs_buf_zone, KM_NOFS);
> -	if (unlikely(!bp))
> -		return -ENOMEM;
> +	bp = kmem_cache_zalloc(xfs_buf_zone, GFP_NOFS | __GFP_NOFAIL);
>  
>  	/*
>  	 * We don't want certain flags to appear in b_flags unless they are
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index e9428c30862a9..3eb45782cf923 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -739,7 +739,7 @@ xfs_buf_item_init(
>  		return 0;
>  	}
>  
> -	bip = kmem_zone_zalloc(xfs_buf_item_zone, 0);
> +	bip = kmem_cache_zalloc(xfs_buf_item_zone, GFP_KERNEL | __GFP_NOFAIL);
>  	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
>  	bip->bli_buf = bp;
>  
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 76353c9a723ee..0f1a0de761787 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -475,7 +475,7 @@ xfs_dquot_alloc(
>  {
>  	struct xfs_dquot	*dqp;
>  
> -	dqp = kmem_zone_zalloc(xfs_qm_dqzone, 0);
> +	dqp = kmem_cache_zalloc(xfs_qm_dqzone, GFP_KERNEL | __GFP_NOFAIL);
>  
>  	dqp->dq_flags = type;
>  	dqp->q_core.d_id = cpu_to_be32(id);
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index b9c333bae0a12..6cb8cd11072a3 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -161,7 +161,8 @@ xfs_efi_init(
>  			((nextents - 1) * sizeof(xfs_extent_t)));
>  		efip = kmem_zalloc(size, 0);
>  	} else {
> -		efip = kmem_zone_zalloc(xfs_efi_zone, 0);
> +		efip = kmem_cache_zalloc(xfs_efi_zone,
> +					 GFP_KERNEL | __GFP_NOFAIL);
>  	}
>  
>  	xfs_log_item_init(mp, &efip->efi_item, XFS_LI_EFI, &xfs_efi_item_ops);
> @@ -332,7 +333,8 @@ xfs_trans_get_efd(
>  				(nextents - 1) * sizeof(struct xfs_extent),
>  				0);
>  	} else {
> -		efdp = kmem_zone_zalloc(xfs_efd_zone, 0);
> +		efdp = kmem_cache_zalloc(xfs_efd_zone,
> +					GFP_KERNEL | __GFP_NOFAIL);
>  	}
>  
>  	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 287a9e5c7d758..9b3994b9c716d 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -97,7 +97,7 @@ xfs_icreate_log(
>  {
>  	struct xfs_icreate_item	*icp;
>  
> -	icp = kmem_zone_zalloc(xfs_icreate_zone, 0);
> +	icp = kmem_cache_zalloc(xfs_icreate_zone, GFP_KERNEL | __GFP_NOFAIL);
>  
>  	xfs_log_item_init(tp->t_mountp, &icp->ic_item, XFS_LI_ICREATE,
>  			  &xfs_icreate_item_ops);
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 3840117f8a5e2..895f61b2b4f01 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -615,7 +615,8 @@ xfs_inode_item_init(
>  	struct xfs_inode_log_item *iip;
>  
>  	ASSERT(ip->i_itemp == NULL);
> -	iip = ip->i_itemp = kmem_zone_zalloc(xfs_ili_zone, 0);
> +	iip = ip->i_itemp = kmem_cache_zalloc(xfs_ili_zone,
> +					      GFP_KERNEL | __GFP_NOFAIL);
>  
>  	iip->ili_inode = ip;
>  	spin_lock_init(&iip->ili_lock);
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index c81639891e298..7b2c72bc28582 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -143,7 +143,8 @@ xfs_cui_init(
>  		cuip = kmem_zalloc(xfs_cui_log_item_sizeof(nextents),
>  				0);
>  	else
> -		cuip = kmem_zone_zalloc(xfs_cui_zone, 0);
> +		cuip = kmem_cache_zalloc(xfs_cui_zone,
> +					 GFP_KERNEL | __GFP_NOFAIL);
>  
>  	xfs_log_item_init(mp, &cuip->cui_item, XFS_LI_CUI, &xfs_cui_item_ops);
>  	cuip->cui_format.cui_nextents = nextents;
> @@ -220,7 +221,7 @@ xfs_trans_get_cud(
>  {
>  	struct xfs_cud_log_item		*cudp;
>  
> -	cudp = kmem_zone_zalloc(xfs_cud_zone, 0);
> +	cudp = kmem_cache_zalloc(xfs_cud_zone, GFP_KERNEL | __GFP_NOFAIL);
>  	xfs_log_item_init(tp->t_mountp, &cudp->cud_item, XFS_LI_CUD,
>  			  &xfs_cud_item_ops);
>  	cudp->cud_cuip = cuip;
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index a86599db20a6f..dc5b0753cd519 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -141,7 +141,8 @@ xfs_rui_init(
>  	if (nextents > XFS_RUI_MAX_FAST_EXTENTS)
>  		ruip = kmem_zalloc(xfs_rui_log_item_sizeof(nextents), 0);
>  	else
> -		ruip = kmem_zone_zalloc(xfs_rui_zone, 0);
> +		ruip = kmem_cache_zalloc(xfs_rui_zone,
> +					 GFP_KERNEL | __GFP_NOFAIL);
>  
>  	xfs_log_item_init(mp, &ruip->rui_item, XFS_LI_RUI, &xfs_rui_item_ops);
>  	ruip->rui_format.rui_nextents = nextents;
> @@ -243,7 +244,7 @@ xfs_trans_get_rud(
>  {
>  	struct xfs_rud_log_item		*rudp;
>  
> -	rudp = kmem_zone_zalloc(xfs_rud_zone, 0);
> +	rudp = kmem_cache_zalloc(xfs_rud_zone, GFP_KERNEL | __GFP_NOFAIL);
>  	xfs_log_item_init(tp->t_mountp, &rudp->rud_item, XFS_LI_RUD,
>  			  &xfs_rud_item_ops);
>  	rudp->rud_ruip = ruip;
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 0ad72a83edac4..ed72867b1a193 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -90,7 +90,7 @@ xfs_trans_dup(
>  
>  	trace_xfs_trans_dup(tp, _RET_IP_);
>  
> -	ntp = kmem_zone_zalloc(xfs_trans_zone, 0);
> +	ntp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
>  
>  	/*
>  	 * Initialize the new transaction structure.
> @@ -263,7 +263,7 @@ xfs_trans_alloc(
>  	 * GFP_NOFS allocation context so that we avoid lockdep false positives
>  	 * by doing GFP_KERNEL allocations inside sb_start_intwrite().
>  	 */
> -	tp = kmem_zone_zalloc(xfs_trans_zone, 0);
> +	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
>  	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
>  		sb_start_intwrite(mp->m_super);
>  
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index c0f73b82c0551..394d6a0aa18dc 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -860,7 +860,8 @@ STATIC void
>  xfs_trans_alloc_dqinfo(
>  	xfs_trans_t	*tp)
>  {
> -	tp->t_dqinfo = kmem_zone_zalloc(xfs_qm_dqtrxzone, 0);
> +	tp->t_dqinfo = kmem_cache_zalloc(xfs_qm_dqtrxzone,
> +					 GFP_KERNEL | __GFP_NOFAIL);
>  }
>  
>  void
> -- 
> 2.26.2
> 
