Return-Path: <linux-xfs+bounces-2851-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2217F832253
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Jan 2024 00:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 342221C22709
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Jan 2024 23:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C5191E526;
	Thu, 18 Jan 2024 23:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OiLGE3Me"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22B21DDF6
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 23:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705621102; cv=none; b=Ndk+yTrDWxqZG/WGHj+KElFXfvzfvRHayXe8r4R98fQlFnN92zITLW7vxo9aQvUWX906GEgzGHq6G+CwB0EzKnKUH6EQsPU3v6S0XZMD/6I4JpvlO9Qm4O4k44DdTrWbUL90Q+n2Wbhz5DBWZKC4gyeaazXL3wa8bGHd7Q9VlVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705621102; c=relaxed/simple;
	bh=xWFSlb7ZMy+dvnLjA2zyB4Yuz639X4LzJAlJcYrV7y0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZUeyAGmstdklA3RwbRmay5mmX01/60aPsc9iZ3Xl06k08udeI+zxt+qF/aj3A2+xPy8J6WkF8bmrf6WxuXAXKc/SSnQlq7S9mXbJQEpN8i4cg+evSBypcUT8IwB8PNgufq3nxWx6cgdZmxNokYi5QxF0JWoobyxaHzkN67ghSRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OiLGE3Me; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3126FC433F1;
	Thu, 18 Jan 2024 23:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705621102;
	bh=xWFSlb7ZMy+dvnLjA2zyB4Yuz639X4LzJAlJcYrV7y0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OiLGE3MeBxqHkUHTLDxE+tgTy9B3kesjuMdz8vDgEuQLnv8A+IxvIpJZaSmjdjgTe
	 xGVaSJsM4qorulTSRZPFsZsFCTaCKAqQWiUZ6tfkAwMbm9+Dk3+CAKSsC4HxzuOaJj
	 y4uOV4FEw+IaRClGBb1WLRPBAosDvPduk24aveKdlHpu/MhmEeslk4JaXDeMzkik0E
	 vUBKbODqDeH2Y3qdh63gw1OKN0FE0O+gytwefVo45vo7hH33nsYOTBE6OCxJcf/kSm
	 ThJIIq+mNAYJfMkrUBRoIap1G19CQntgnJtATDBDwWpo8G80y+vr2J7TC5WKEk5WTp
	 sBEOr8C/AOEqw==
Date: Thu, 18 Jan 2024 15:38:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 08/12] xfs: use GFP_KERNEL in pure transaction contexts
Message-ID: <20240118233821.GK674499@frogsfrogsfrogs>
References: <20240115230113.4080105-1-david@fromorbit.com>
 <20240115230113.4080105-9-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115230113.4080105-9-david@fromorbit.com>

On Tue, Jan 16, 2024 at 09:59:46AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When running in a transaction context, memory allocations are scoped
> to GFP_NOFS. Hence we don't need to use GFP_NOFS contexts in pure
> transaction context allocations - GFP_KERNEL will automatically get
> converted to GFP_NOFS as appropriate.
> 
> Go through the code and convert all the obvious GFP_NOFS allocations
> in transaction context to use GFP_KERNEL. This further reduces the
> explicit use of GFP_NOFS in XFS.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c       |  3 ++-
>  fs/xfs/libxfs/xfs_bmap.c       |  2 +-
>  fs/xfs/libxfs/xfs_defer.c      |  6 +++---
>  fs/xfs/libxfs/xfs_dir2.c       |  8 ++++----
>  fs/xfs/libxfs/xfs_inode_fork.c |  8 ++++----
>  fs/xfs/libxfs/xfs_refcount.c   |  2 +-
>  fs/xfs/libxfs/xfs_rmap.c       |  2 +-
>  fs/xfs/xfs_attr_item.c         |  4 ++--
>  fs/xfs/xfs_bmap_util.c         |  2 +-
>  fs/xfs/xfs_buf.c               | 28 +++++++++++++++++-----------
>  fs/xfs/xfs_log.c               |  3 ++-
>  fs/xfs/xfs_mru_cache.c         |  2 +-
>  12 files changed, 39 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 9976a00a73f9..269a57420859 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -891,7 +891,8 @@ xfs_attr_defer_add(
>  
>  	struct xfs_attr_intent	*new;
>  
> -	new = kmem_cache_zalloc(xfs_attr_intent_cache, GFP_NOFS | __GFP_NOFAIL);
> +	new = kmem_cache_zalloc(xfs_attr_intent_cache,
> +			GFP_KERNEL | __GFP_NOFAIL);
>  	new->xattri_op_flags = op_flags;
>  	new->xattri_da_args = args;
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 98aaca933bdd..fbdaa53deecd 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6098,7 +6098,7 @@ __xfs_bmap_add(
>  			bmap->br_blockcount,
>  			bmap->br_state);
>  
> -	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
> +	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&bi->bi_list);
>  	bi->bi_type = type;
>  	bi->bi_owner = ip;
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 75689c151a54..8ae4401f6810 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -825,7 +825,7 @@ xfs_defer_alloc(
>  	struct xfs_defer_pending	*dfp;
>  
>  	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
> -			GFP_NOFS | __GFP_NOFAIL);
> +			GFP_KERNEL | __GFP_NOFAIL);
>  	dfp->dfp_ops = ops;
>  	INIT_LIST_HEAD(&dfp->dfp_work);
>  	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
> @@ -888,7 +888,7 @@ xfs_defer_start_recovery(
>  	struct xfs_defer_pending	*dfp;
>  
>  	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
> -			GFP_NOFS | __GFP_NOFAIL);
> +			GFP_KERNEL | __GFP_NOFAIL);
>  	dfp->dfp_ops = ops;
>  	dfp->dfp_intent = lip;
>  	INIT_LIST_HEAD(&dfp->dfp_work);
> @@ -979,7 +979,7 @@ xfs_defer_ops_capture(
>  		return ERR_PTR(error);
>  
>  	/* Create an object to capture the defer ops. */
> -	dfc = kzalloc(sizeof(*dfc), GFP_NOFS | __GFP_NOFAIL);
> +	dfc = kzalloc(sizeof(*dfc), GFP_KERNEL | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&dfc->dfc_list);
>  	INIT_LIST_HEAD(&dfc->dfc_dfops);
>  
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index 728f72f0d078..8c9403b33191 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -236,7 +236,7 @@ xfs_dir_init(
>  	if (error)
>  		return error;
>  
> -	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
> +	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
>  	if (!args)
>  		return -ENOMEM;
>  
> @@ -273,7 +273,7 @@ xfs_dir_createname(
>  		XFS_STATS_INC(dp->i_mount, xs_dir_create);
>  	}
>  
> -	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
> +	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
>  	if (!args)
>  		return -ENOMEM;
>  
> @@ -435,7 +435,7 @@ xfs_dir_removename(
>  	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
>  	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
>  
> -	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
> +	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
>  	if (!args)
>  		return -ENOMEM;
>  
> @@ -496,7 +496,7 @@ xfs_dir_replace(
>  	if (rval)
>  		return rval;
>  
> -	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
> +	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
>  	if (!args)
>  		return -ENOMEM;
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 709fda3d742f..136d5d7b9de9 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -402,7 +402,7 @@ xfs_iroot_realloc(
>  		if (ifp->if_broot_bytes == 0) {
>  			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
>  			ifp->if_broot = kmalloc(new_size,
> -						GFP_NOFS | __GFP_NOFAIL);
> +						GFP_KERNEL | __GFP_NOFAIL);
>  			ifp->if_broot_bytes = (int)new_size;
>  			return;
>  		}
> @@ -417,7 +417,7 @@ xfs_iroot_realloc(
>  		new_max = cur_max + rec_diff;
>  		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
>  		ifp->if_broot = krealloc(ifp->if_broot, new_size,
> -					 GFP_NOFS | __GFP_NOFAIL);
> +					 GFP_KERNEL | __GFP_NOFAIL);
>  		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
>  						     ifp->if_broot_bytes);
>  		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
> @@ -443,7 +443,7 @@ xfs_iroot_realloc(
>  	else
>  		new_size = 0;
>  	if (new_size > 0) {
> -		new_broot = kmalloc(new_size, GFP_NOFS | __GFP_NOFAIL);
> +		new_broot = kmalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
>  		/*
>  		 * First copy over the btree block header.
>  		 */
> @@ -512,7 +512,7 @@ xfs_idata_realloc(
>  
>  	if (byte_diff) {
>  		ifp->if_data = krealloc(ifp->if_data, new_size,
> -					GFP_NOFS | __GFP_NOFAIL);
> +					GFP_KERNEL | __GFP_NOFAIL);
>  		if (new_size == 0)
>  			ifp->if_data = NULL;
>  		ifp->if_bytes = new_size;
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 6709a7f8bad5..7df52daa22cf 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1449,7 +1449,7 @@ __xfs_refcount_add(
>  			blockcount);
>  
>  	ri = kmem_cache_alloc(xfs_refcount_intent_cache,
> -			GFP_NOFS | __GFP_NOFAIL);
> +			GFP_KERNEL | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&ri->ri_list);
>  	ri->ri_type = type;
>  	ri->ri_startblock = startblock;
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 76bf7f48cb5a..0bd1f47b2c2b 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -2559,7 +2559,7 @@ __xfs_rmap_add(
>  			bmap->br_blockcount,
>  			bmap->br_state);
>  
> -	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
> +	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
>  	INIT_LIST_HEAD(&ri->ri_list);
>  	ri->ri_type = type;
>  	ri->ri_owner = owner;
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 2a142cefdc3d..0bf25a2ba3b6 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -226,7 +226,7 @@ xfs_attri_init(
>  {
>  	struct xfs_attri_log_item	*attrip;
>  
> -	attrip = kmem_cache_zalloc(xfs_attri_cache, GFP_NOFS | __GFP_NOFAIL);
> +	attrip = kmem_cache_zalloc(xfs_attri_cache, GFP_KERNEL | __GFP_NOFAIL);
>  
>  	/*
>  	 * Grab an extra reference to the name/value buffer for this log item.
> @@ -666,7 +666,7 @@ xfs_attr_create_done(
>  
>  	attrip = ATTRI_ITEM(intent);
>  
> -	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_NOFS | __GFP_NOFAIL);
> +	attrdp = kmem_cache_zalloc(xfs_attrd_cache, GFP_KERNEL | __GFP_NOFAIL);
>  
>  	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
>  			  &xfs_attrd_item_ops);
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index c2531c28905c..cb2a4b940292 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -66,7 +66,7 @@ xfs_zero_extent(
>  	return blkdev_issue_zeroout(target->bt_bdev,
>  		block << (mp->m_super->s_blocksize_bits - 9),
>  		count_fsb << (mp->m_super->s_blocksize_bits - 9),
> -		GFP_NOFS, 0);
> +		GFP_KERNEL, 0);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a09ffbbb0dda..de99368000b4 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -190,7 +190,7 @@ xfs_buf_get_maps(
>  	}
>  
>  	bp->b_maps = kzalloc(map_count * sizeof(struct xfs_buf_map),
> -				GFP_NOFS | __GFP_NOFAIL);
> +			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
>  	if (!bp->b_maps)
>  		return -ENOMEM;
>  	return 0;
> @@ -222,7 +222,8 @@ _xfs_buf_alloc(
>  	int			i;
>  
>  	*bpp = NULL;
> -	bp = kmem_cache_zalloc(xfs_buf_cache, GFP_NOFS | __GFP_NOFAIL);
> +	bp = kmem_cache_zalloc(xfs_buf_cache,
> +			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
>  
>  	/*
>  	 * We don't want certain flags to appear in b_flags unless they are
> @@ -325,7 +326,7 @@ xfs_buf_alloc_kmem(
>  	struct xfs_buf	*bp,
>  	xfs_buf_flags_t	flags)
>  {
> -	gfp_t		gfp_mask = GFP_NOFS | __GFP_NOFAIL;
> +	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL;
>  	size_t		size = BBTOB(bp->b_length);
>  
>  	/* Assure zeroed buffer for non-read cases. */
> @@ -356,13 +357,11 @@ xfs_buf_alloc_pages(
>  	struct xfs_buf	*bp,
>  	xfs_buf_flags_t	flags)
>  {
> -	gfp_t		gfp_mask = __GFP_NOWARN;
> +	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
>  	long		filled = 0;
>  
>  	if (flags & XBF_READ_AHEAD)
>  		gfp_mask |= __GFP_NORETRY;
> -	else
> -		gfp_mask |= GFP_NOFS;
>  
>  	/* Make sure that we have a page list */
>  	bp->b_page_count = DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE);
> @@ -429,11 +428,18 @@ _xfs_buf_map_pages(
>  
>  		/*
>  		 * vm_map_ram() will allocate auxiliary structures (e.g.
> -		 * pagetables) with GFP_KERNEL, yet we are likely to be under
> -		 * GFP_NOFS context here. Hence we need to tell memory reclaim
> -		 * that we are in such a context via PF_MEMALLOC_NOFS to prevent
> -		 * memory reclaim re-entering the filesystem here and
> -		 * potentially deadlocking.
> +		 * pagetables) with GFP_KERNEL, yet we often under a scoped nofs
> +		 * context here. Mixing GFP_KERNEL with GFP_NOFS allocations
> +		 * from the same call site that can be run from both above and
> +		 * below memory reclaim causes lockdep false positives. Hence we
> +		 * always need to force this allocation to nofs context because
> +		 * we can't pass __GFP_NOLOCKDEP down to auxillary structures to
> +		 * prevent false positive lockdep reports.
> +		 *
> +		 * XXX(dgc): I think dquot reclaim is the only place we can get
> +		 * to this function from memory reclaim context now. If we fix
> +		 * that like we've fixed inode reclaim to avoid writeback from
> +		 * reclaim, this nofs wrapping can go away.
>  		 */
>  		nofs_flag = memalloc_nofs_save();
>  		do {
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index ee39639bb92b..1f68569e62ca 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3518,7 +3518,8 @@ xlog_ticket_alloc(
>  	struct xlog_ticket	*tic;
>  	int			unit_res;
>  
> -	tic = kmem_cache_zalloc(xfs_log_ticket_cache, GFP_NOFS | __GFP_NOFAIL);
> +	tic = kmem_cache_zalloc(xfs_log_ticket_cache,
> +			GFP_KERNEL | __GFP_NOFAIL);
>  
>  	unit_res = xlog_calc_unit_res(log, unit_bytes, &tic->t_iclog_hdrs);
>  
> diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
> index ce496704748d..7443debaffd6 100644
> --- a/fs/xfs/xfs_mru_cache.c
> +++ b/fs/xfs/xfs_mru_cache.c
> @@ -428,7 +428,7 @@ xfs_mru_cache_insert(
>  	if (!mru || !mru->lists)
>  		return -EINVAL;
>  
> -	if (radix_tree_preload(GFP_NOFS))
> +	if (radix_tree_preload(GFP_KERNEL))
>  		return -ENOMEM;
>  
>  	INIT_LIST_HEAD(&elem->list_node);
> -- 
> 2.43.0
> 
> 

