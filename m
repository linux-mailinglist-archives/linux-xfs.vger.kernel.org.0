Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D64442B9D4
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Oct 2021 10:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238889AbhJMIDu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Oct 2021 04:03:50 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:48520 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238687AbhJMIDc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Oct 2021 04:03:32 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 9C7F61068137;
        Wed, 13 Oct 2021 19:01:14 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1maZCM-005hF8-1F; Wed, 13 Oct 2021 19:01:14 +1100
Date:   Wed, 13 Oct 2021 19:01:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 15/15] xfs: use separate btree cursor cache for each
 btree type
Message-ID: <20211013080114.GH2361455@dread.disaster.area>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408163634.4151249.5333674876821248862.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163408163634.4151249.5333674876821248862.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6166924a
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=QymBwCBhnDG8gAwAQhAA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 04:33:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we have the infrastructure to track the max possible height of
> each btree type, we can create a separate slab cache for cursors of each
> type of btree.  For smaller indices like the free space btrees, this
> means that we can pack more cursors into a slab page, improving slab
> utilization.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc_btree.c    |   21 ++++++++++++++
>  fs/xfs/libxfs/xfs_alloc_btree.h    |    3 ++
>  fs/xfs/libxfs/xfs_bmap_btree.c     |   21 ++++++++++++++
>  fs/xfs/libxfs/xfs_bmap_btree.h     |    3 ++
>  fs/xfs/libxfs/xfs_btree.c          |    7 +----
>  fs/xfs/libxfs/xfs_btree.h          |   17 +++---------
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |   21 ++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc_btree.h   |    3 ++
>  fs/xfs/libxfs/xfs_refcount_btree.c |   21 ++++++++++++++
>  fs/xfs/libxfs/xfs_refcount_btree.h |    3 ++
>  fs/xfs/libxfs/xfs_rmap_btree.c     |   21 ++++++++++++++
>  fs/xfs/libxfs/xfs_rmap_btree.h     |    3 ++
>  fs/xfs/xfs_super.c                 |   53 ++++++++++++++++++++++++++++++++----
>  13 files changed, 168 insertions(+), 29 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 61f6d266b822..4c5942146b05 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -20,6 +20,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_ag.h"
>  
> +static kmem_zone_t	*xfs_allocbt_cur_cache;
>  
>  STATIC struct xfs_btree_cur *
>  xfs_allocbt_dup_cursor(
> @@ -477,7 +478,8 @@ xfs_allocbt_init_common(
>  
>  	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
>  
> -	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_ag_maxlevels);
> +	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_ag_maxlevels,
> +			xfs_allocbt_cur_cache);
>  	cur->bc_ag.abt.active = false;
>  
>  	if (btnum == XFS_BTNUM_CNT) {
> @@ -603,3 +605,20 @@ xfs_allocbt_calc_size(
>  {
>  	return xfs_btree_calc_size(mp->m_alloc_mnr, len);
>  }
> +
> +int __init
> +xfs_allocbt_init_cur_cache(void)
> +{
> +	xfs_allocbt_cur_cache = kmem_cache_create("xfs_bnobt_cur",
> +			xfs_btree_cur_sizeof(xfs_allocbt_absolute_maxlevels()),
> +			0, 0, NULL);
> +
> +	return xfs_allocbt_cur_cache != NULL ? 0 : -ENOMEM;

	if (!xfs_allocbt_cur_cache)
		return -ENOMEM;
	return 0;

(and the others :)

> +}
> +
> +void
> +xfs_allocbt_destroy_cur_cache(void)
> +{
> +	kmem_cache_destroy(xfs_allocbt_cur_cache);
> +	xfs_allocbt_cur_cache = NULL;
> +}
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
> index c47d0e285435..82a9b3201f91 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.h
> @@ -62,4 +62,7 @@ void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
>  
>  unsigned int xfs_allocbt_absolute_maxlevels(void);
>  
> +int __init xfs_allocbt_init_cur_cache(void);
> +void xfs_allocbt_destroy_cur_cache(void);
> +
>  #endif	/* __XFS_ALLOC_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 7001aff639d2..99261d51d2c3 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -22,6 +22,8 @@
>  #include "xfs_trace.h"
>  #include "xfs_rmap.h"
>  
> +static kmem_zone_t	*xfs_bmbt_cur_cache;
> +
>  /*
>   * Convert on-disk form of btree root to in-memory form.
>   */
> @@ -553,7 +555,7 @@ xfs_bmbt_init_cursor(
>  	ASSERT(whichfork != XFS_COW_FORK);
>  
>  	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP,
> -			mp->m_bm_maxlevels[whichfork]);
> +			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
>  	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
>  	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
>  
> @@ -664,3 +666,20 @@ xfs_bmbt_calc_size(
>  {
>  	return xfs_btree_calc_size(mp->m_bmap_dmnr, len);
>  }
> +
> +int __init
> +xfs_bmbt_init_cur_cache(void)
> +{
> +	xfs_bmbt_cur_cache = kmem_cache_create("xfs_bmbt_cur",
> +			xfs_btree_cur_sizeof(xfs_bmbt_absolute_maxlevels()),
> +			0, 0, NULL);
> +
> +	return xfs_bmbt_cur_cache != NULL ? 0 : -ENOMEM;
> +}
> +
> +void
> +xfs_bmbt_destroy_cur_cache(void)
> +{
> +	kmem_cache_destroy(xfs_bmbt_cur_cache);
> +	xfs_bmbt_cur_cache = NULL;
> +}
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
> index e9218e92526b..4c752f7341df 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.h
> @@ -112,4 +112,7 @@ extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
>  
>  unsigned int xfs_bmbt_absolute_maxlevels(void);
>  
> +int __init xfs_bmbt_init_cur_cache(void);
> +void xfs_bmbt_destroy_cur_cache(void);
> +
>  #endif	/* __XFS_BMAP_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index bea1bdf9b8b9..11ff814996a1 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -23,11 +23,6 @@
>  #include "xfs_btree_staging.h"
>  #include "xfs_ag.h"
>  
> -/*
> - * Cursor allocation zone.
> - */
> -kmem_zone_t	*xfs_btree_cur_zone;
> -
>  /*
>   * Btree magic numbers.
>   */
> @@ -379,7 +374,7 @@ xfs_btree_del_cursor(
>  		kmem_free(cur->bc_ops);
>  	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
>  		xfs_perag_put(cur->bc_ag.pag);
> -	kmem_cache_free(xfs_btree_cur_zone, cur);
> +	kmem_cache_free(cur->bc_cache, cur);
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index acb202839afd..6d61ce1559e2 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -13,8 +13,6 @@ struct xfs_trans;
>  struct xfs_ifork;
>  struct xfs_perag;
>  
> -extern kmem_zone_t	*xfs_btree_cur_zone;
> -
>  /*
>   * Generic key, ptr and record wrapper structures.
>   *
> @@ -92,12 +90,6 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
>  #define XFS_BTREE_STATS_ADD(cur, stat, val)	\
>  	XFS_STATS_ADD_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat, val)
>  
> -/*
> - * The btree cursor zone hands out cursors that can handle up to this many
> - * levels.  This is the known maximum for all btree types.
> - */
> -#define XFS_BTREE_CUR_ZONE_MAXLEVELS	(9)
> -
>  struct xfs_btree_ops {
>  	/* size of the key and record structures */
>  	size_t	key_len;
> @@ -238,6 +230,7 @@ struct xfs_btree_cur
>  	struct xfs_trans	*bc_tp;	/* transaction we're in, if any */
>  	struct xfs_mount	*bc_mp;	/* file system mount struct */
>  	const struct xfs_btree_ops *bc_ops;
> +	kmem_zone_t		*bc_cache; /* cursor cache */
>  	unsigned int		bc_flags; /* btree features - below */
>  	xfs_btnum_t		bc_btnum; /* identifies which btree type */
>  	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
> @@ -586,17 +579,17 @@ xfs_btree_alloc_cursor(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp,
>  	xfs_btnum_t		btnum,
> -	uint8_t			maxlevels)
> +	uint8_t			maxlevels,
> +	kmem_zone_t		*cache)
>  {
>  	struct xfs_btree_cur	*cur;
>  
> -	ASSERT(maxlevels <= XFS_BTREE_CUR_ZONE_MAXLEVELS);
> -
> -	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
> +	cur = kmem_cache_zalloc(cache, GFP_NOFS | __GFP_NOFAIL);
>  	cur->bc_tp = tp;
>  	cur->bc_mp = mp;
>  	cur->bc_btnum = btnum;
>  	cur->bc_maxlevels = maxlevels;
> +	cur->bc_cache = cache;
>  
>  	return cur;
>  }
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index 2e3dd1d798bd..2502085d476c 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -22,6 +22,8 @@
>  #include "xfs_rmap.h"
>  #include "xfs_ag.h"
>  
> +static kmem_zone_t	*xfs_inobt_cur_cache;
> +
>  STATIC int
>  xfs_inobt_get_minrecs(
>  	struct xfs_btree_cur	*cur,
> @@ -433,7 +435,7 @@ xfs_inobt_init_common(
>  	struct xfs_btree_cur	*cur;
>  
>  	cur = xfs_btree_alloc_cursor(mp, tp, btnum,
> -			M_IGEO(mp)->inobt_maxlevels);
> +			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
>  	if (btnum == XFS_BTNUM_INO) {
>  		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
>  		cur->bc_ops = &xfs_inobt_ops;
> @@ -776,3 +778,20 @@ xfs_iallocbt_calc_size(
>  {
>  	return xfs_btree_calc_size(M_IGEO(mp)->inobt_mnr, len);
>  }
> +
> +int __init
> +xfs_inobt_init_cur_cache(void)
> +{
> +	xfs_inobt_cur_cache = kmem_cache_create("xfs_inobt_cur",
> +			xfs_btree_cur_sizeof(xfs_inobt_absolute_maxlevels()),
> +			0, 0, NULL);
> +
> +	return xfs_inobt_cur_cache != NULL ? 0 : -ENOMEM;
> +}
> +
> +void
> +xfs_inobt_destroy_cur_cache(void)
> +{
> +	kmem_cache_destroy(xfs_inobt_cur_cache);
> +	xfs_inobt_cur_cache = NULL;
> +}
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
> index 1f09530bf856..b384733d5e0f 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
> @@ -77,4 +77,7 @@ void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
>  
>  unsigned int xfs_inobt_absolute_maxlevels(void);
>  
> +int __init xfs_inobt_init_cur_cache(void);
> +void xfs_inobt_destroy_cur_cache(void);
> +
>  #endif	/* __XFS_IALLOC_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index bacd1b442b09..ba27a3ea2ce2 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -21,6 +21,8 @@
>  #include "xfs_rmap.h"
>  #include "xfs_ag.h"
>  
> +static kmem_zone_t	*xfs_refcountbt_cur_cache;
> +
>  static struct xfs_btree_cur *
>  xfs_refcountbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
> @@ -323,7 +325,7 @@ xfs_refcountbt_init_common(
>  	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
>  
>  	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC,
> -			mp->m_refc_maxlevels);
> +			mp->m_refc_maxlevels, xfs_refcountbt_cur_cache);
>  	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
>  
>  	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
> @@ -505,3 +507,20 @@ xfs_refcountbt_calc_reserves(
>  
>  	return error;
>  }
> +
> +int __init
> +xfs_refcountbt_init_cur_cache(void)
> +{
> +	xfs_refcountbt_cur_cache = kmem_cache_create("xfs_refcbt_cur",
> +			xfs_btree_cur_sizeof(xfs_refcountbt_absolute_maxlevels()),
> +			0, 0, NULL);
> +
> +	return xfs_refcountbt_cur_cache != NULL ? 0 : -ENOMEM;
> +}
> +
> +void
> +xfs_refcountbt_destroy_cur_cache(void)
> +{
> +	kmem_cache_destroy(xfs_refcountbt_cur_cache);
> +	xfs_refcountbt_cur_cache = NULL;
> +}
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
> index 2625b08f50a8..a1437d0a5717 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.h
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.h
> @@ -67,4 +67,7 @@ void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
>  
>  unsigned int xfs_refcountbt_absolute_maxlevels(void);
>  
> +int __init xfs_refcountbt_init_cur_cache(void);
> +void xfs_refcountbt_destroy_cur_cache(void);
> +
>  #endif	/* __XFS_REFCOUNT_BTREE_H__ */
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 860627b5ec08..0a9bc37c01d0 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -22,6 +22,8 @@
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  
> +static kmem_zone_t	*xfs_rmapbt_cur_cache;
> +
>  /*
>   * Reverse map btree.
>   *
> @@ -453,7 +455,7 @@ xfs_rmapbt_init_common(
>  
>  	/* Overlapping btree; 2 keys per pointer. */
>  	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP,
> -			mp->m_rmap_maxlevels);
> +			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
>  	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
>  	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
>  	cur->bc_ops = &xfs_rmapbt_ops;
> @@ -670,3 +672,20 @@ xfs_rmapbt_calc_reserves(
>  
>  	return error;
>  }
> +
> +int __init
> +xfs_rmapbt_init_cur_cache(void)
> +{
> +	xfs_rmapbt_cur_cache = kmem_cache_create("xfs_rmapbt_cur",
> +			xfs_btree_cur_sizeof(xfs_rmapbt_absolute_maxlevels()),
> +			0, 0, NULL);
> +
> +	return xfs_rmapbt_cur_cache != NULL ? 0 : -ENOMEM;
> +}
> +
> +void
> +xfs_rmapbt_destroy_cur_cache(void)
> +{
> +	kmem_cache_destroy(xfs_rmapbt_cur_cache);
> +	xfs_rmapbt_cur_cache = NULL;
> +}
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
> index 84fe74de923f..dd5422850656 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.h
> @@ -61,4 +61,7 @@ extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
>  
>  unsigned int xfs_rmapbt_absolute_maxlevels(void);
>  
> +int __init xfs_rmapbt_init_cur_cache(void);
> +void xfs_rmapbt_destroy_cur_cache(void);
> +
>  #endif /* __XFS_RMAP_BTREE_H__ */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 90c92a6a49e0..399d7cfc7d4b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -37,6 +37,13 @@
>  #include "xfs_reflink.h"
>  #include "xfs_pwork.h"
>  #include "xfs_ag.h"
> +#include "xfs_btree.h"
> +#include "xfs_alloc_btree.h"
> +#include "xfs_ialloc_btree.h"
> +#include "xfs_bmap_btree.h"
> +#include "xfs_rmap_btree.h"
> +#include "xfs_refcount_btree.h"
> +
>  
>  #include <linux/magic.h>
>  #include <linux/fs_context.h>
> @@ -1950,9 +1957,45 @@ static struct file_system_type xfs_fs_type = {
>  };
>  MODULE_ALIAS_FS("xfs");
>  
> +STATIC int __init
> +xfs_init_btree_cur_caches(void)
> +{
> +	int				error;
> +
> +	error = xfs_allocbt_init_cur_cache();
> +	if (error)
> +		return error;
> +	error = xfs_inobt_init_cur_cache();
> +	if (error)
> +		return error;
> +	error = xfs_bmbt_init_cur_cache();
> +	if (error)
> +		return error;
> +	error = xfs_rmapbt_init_cur_cache();
> +	if (error)
> +		return error;
> +	error = xfs_refcountbt_init_cur_cache();
> +	if (error)
> +		return error;
> +
> +	return 0;
> +}
> +
> +STATIC void
> +xfs_destroy_btree_cur_caches(void)
> +{
> +	xfs_allocbt_destroy_cur_cache();
> +	xfs_inobt_destroy_cur_cache();
> +	xfs_bmbt_destroy_cur_cache();
> +	xfs_rmapbt_destroy_cur_cache();
> +	xfs_refcountbt_destroy_cur_cache();
> +}

MOve these to libxfs/xfs_btree.c and then it minimises the custom
init code for userspace. Also means you don't need to include
all the individual btree headers in xfs-super.c...

Otherwise it all looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
