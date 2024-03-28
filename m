Return-Path: <linux-xfs+bounces-5483-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F3E888B573
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Mar 2024 00:42:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE3151F39F40
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Mar 2024 23:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CEF583CA7;
	Mon, 25 Mar 2024 23:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXnPlyM1"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0033883CBC
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 23:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711410115; cv=none; b=ErojuDwdKXIYWywjE5DaG+wVIAoPn2FrgNXAZgwaivnSV61DcMz17p5ujJZ0csFiEcz4ZlodN0PQrYTEZHP7pRVav7SfbJr+hxi+302JzjuRtm6GLVsSTLghbrYLBQNiwlg40bfcQR0+50arNIm/QXiRWZ1XA4WMO8uggkVq8kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711410115; c=relaxed/simple;
	bh=Uldleu7PvEX83DWFumYHhOp6gQXq1o4KcdI4IhOpW5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KcUhFeXWK2LU0KH8Hhe0lz6cUerWVcBvQWY+4xvDH84eVdRURTqMuBDyEQCEfp68GYDkdOvmPdz/tz8b6nOihOMHrPeeQkTx63LBhWfDz2M+tI1zRglKcby17Z80avK/ra8Sp1liLy8EAPm9zgGuAa4igBErFh//0ZtIOVlZXyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXnPlyM1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836D4C43394;
	Mon, 25 Mar 2024 23:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711410114;
	bh=Uldleu7PvEX83DWFumYHhOp6gQXq1o4KcdI4IhOpW5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eXnPlyM172qwMCGY06OrInMKbZpi28QkKFa5JvskcmUDJEnyu0LO6lMXS8EXS9A0p
	 FKrM1zq5pxLKeWO7xMOiuq5Gl7R/HDJ4k9auIEXetWfjNsrnqvp9fUv8MVHkV9a0Wh
	 h7CGN7sPRHlXXn3QIxjq0irg0IVz069yBW4v5VmtMc87wLz4BL0p3exGhRcxi8Edhk
	 rz3TP65OGa+7pkguvTrlo0CpD6tR5i69qcTFL+6gL+XgYEy28w3cslDl/FxULhPmqT
	 VqX98UJa+G+IhoaMAXesYWuJr086qzVuMLDXOBhyfmtmqmYstYih3skbvz4fqY+XPJ
	 NFQ7CS39KvHFw==
Date: Mon, 25 Mar 2024 16:41:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/11] xfs: split xfs_mod_freecounter
Message-ID: <20240325234153.GD6414@frogsfrogsfrogs>
References: <20240325022411.2045794-1-hch@lst.de>
 <20240325022411.2045794-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325022411.2045794-5-hch@lst.de>

On Mon, Mar 25, 2024 at 10:24:04AM +0800, Christoph Hellwig wrote:
> xfs_mod_freecounter has two entirely separate code paths for adding or
> subtracting from the free counters.  Only the subtract case looks at the
> rsvd flag and can return an error.
> 
> Split xfs_mod_freecounter into separate helpers for subtracting or
> adding the freecounter, and remove all the impossible to reach error
> handling for the addition case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I'm guessing that the difference between v3 and v4 is that you can more
easily integrate a freertx reserve pool now?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.c      |  4 +--
>  fs/xfs/libxfs/xfs_ag_resv.c | 24 ++++---------
>  fs/xfs/libxfs/xfs_ag_resv.h |  2 +-
>  fs/xfs/libxfs/xfs_alloc.c   |  4 +--
>  fs/xfs/libxfs/xfs_bmap.c    | 23 +++++++------
>  fs/xfs/scrub/fscounters.c   |  2 +-
>  fs/xfs/scrub/repair.c       |  5 +--
>  fs/xfs/xfs_fsops.c          | 29 +++++-----------
>  fs/xfs/xfs_fsops.h          |  2 +-
>  fs/xfs/xfs_mount.c          | 67 +++++++++++++++++++------------------
>  fs/xfs/xfs_mount.h          | 27 ++++++++++-----
>  fs/xfs/xfs_super.c          |  6 +---
>  fs/xfs/xfs_trace.h          |  1 -
>  fs/xfs/xfs_trans.c          | 25 +++++---------
>  14 files changed, 97 insertions(+), 124 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index dc1873f76bffd5..189e3296fef6de 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -963,9 +963,7 @@ xfs_ag_shrink_space(
>  	 * Disable perag reservations so it doesn't cause the allocation request
>  	 * to fail. We'll reestablish reservation before we return.
>  	 */
> -	error = xfs_ag_resv_free(pag);
> -	if (error)
> -		return error;
> +	xfs_ag_resv_free(pag);
>  
>  	/* internal log shouldn't also show up in the free space btrees */
>  	error = xfs_alloc_vextent_exact_bno(&args,
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index da1057bd0e6067..216423df939e5c 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -126,14 +126,13 @@ xfs_ag_resv_needed(
>  }
>  
>  /* Clean out a reservation */
> -static int
> +static void
>  __xfs_ag_resv_free(
>  	struct xfs_perag		*pag,
>  	enum xfs_ag_resv_type		type)
>  {
>  	struct xfs_ag_resv		*resv;
>  	xfs_extlen_t			oldresv;
> -	int				error;
>  
>  	trace_xfs_ag_resv_free(pag, type, 0);
>  
> @@ -149,30 +148,19 @@ __xfs_ag_resv_free(
>  		oldresv = resv->ar_orig_reserved;
>  	else
>  		oldresv = resv->ar_reserved;
> -	error = xfs_mod_fdblocks(pag->pag_mount, oldresv, true);
> +	xfs_add_fdblocks(pag->pag_mount, oldresv);
>  	resv->ar_reserved = 0;
>  	resv->ar_asked = 0;
>  	resv->ar_orig_reserved = 0;
> -
> -	if (error)
> -		trace_xfs_ag_resv_free_error(pag->pag_mount, pag->pag_agno,
> -				error, _RET_IP_);
> -	return error;
>  }
>  
>  /* Free a per-AG reservation. */
> -int
> +void
>  xfs_ag_resv_free(
>  	struct xfs_perag		*pag)
>  {
> -	int				error;
> -	int				err2;
> -
> -	error = __xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
> -	err2 = __xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
> -	if (err2 && !error)
> -		error = err2;
> -	return error;
> +	__xfs_ag_resv_free(pag, XFS_AG_RESV_RMAPBT);
> +	__xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
>  }
>  
>  static int
> @@ -216,7 +204,7 @@ __xfs_ag_resv_init(
>  	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_AG_RESV_FAIL))
>  		error = -ENOSPC;
>  	else
> -		error = xfs_mod_fdblocks(mp, -(int64_t)hidden_space, true);
> +		error = xfs_dec_fdblocks(mp, hidden_space, true);
>  	if (error) {
>  		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
>  				error, _RET_IP_);
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
> index b74b210008ea7e..ff20ed93de7724 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.h
> +++ b/fs/xfs/libxfs/xfs_ag_resv.h
> @@ -6,7 +6,7 @@
>  #ifndef __XFS_AG_RESV_H__
>  #define	__XFS_AG_RESV_H__
>  
> -int xfs_ag_resv_free(struct xfs_perag *pag);
> +void xfs_ag_resv_free(struct xfs_perag *pag);
>  int xfs_ag_resv_init(struct xfs_perag *pag, struct xfs_trans *tp);
>  
>  bool xfs_ag_resv_critical(struct xfs_perag *pag, enum xfs_ag_resv_type type);
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 9da52e92172aba..6cb8b2ddc541b4 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -79,7 +79,7 @@ xfs_prealloc_blocks(
>  }
>  
>  /*
> - * The number of blocks per AG that we withhold from xfs_mod_fdblocks to
> + * The number of blocks per AG that we withhold from xfs_dec_fdblocks to
>   * guarantee that we can refill the AGFL prior to allocating space in a nearly
>   * full AG.  Although the space described by the free space btrees, the
>   * blocks used by the freesp btrees themselves, and the blocks owned by the
> @@ -89,7 +89,7 @@ xfs_prealloc_blocks(
>   * until the fs goes down, we subtract this many AG blocks from the incore
>   * fdblocks to ensure user allocation does not overcommit the space the
>   * filesystem needs for the AGFLs.  The rmap btree uses a per-AG reservation to
> - * withhold space from xfs_mod_fdblocks, so we do not account for that here.
> + * withhold space from xfs_dec_fdblocks, so we do not account for that here.
>   */
>  #define XFS_ALLOCBT_AGFL_RESERVE	4
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 5fb7b38921c9a3..240507cbe4db3e 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1983,10 +1983,11 @@ xfs_bmap_add_extent_delay_real(
>  	}
>  
>  	/* adjust for changes in reserved delayed indirect blocks */
> -	if (da_new != da_old) {
> -		ASSERT(state == 0 || da_new < da_old);
> -		error = xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new),
> -				false);
> +	if (da_new < da_old) {
> +		xfs_add_fdblocks(mp, da_old - da_new);
> +	} else if (da_new > da_old) {
> +		ASSERT(state == 0);
> +		error = xfs_dec_fdblocks(mp, da_new - da_old, false);
>  	}
>  
>  	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
> @@ -2688,8 +2689,8 @@ xfs_bmap_add_extent_hole_delay(
>  	}
>  	if (oldlen != newlen) {
>  		ASSERT(oldlen > newlen);
> -		xfs_mod_fdblocks(ip->i_mount, (int64_t)(oldlen - newlen),
> -				 false);
> +		xfs_add_fdblocks(ip->i_mount, oldlen - newlen);
> +
>  		/*
>  		 * Nothing to do for disk quota accounting here.
>  		 */
> @@ -4108,11 +4109,11 @@ xfs_bmapi_reserve_delalloc(
>  	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
>  	ASSERT(indlen > 0);
>  
> -	error = xfs_mod_fdblocks(mp, -((int64_t)alen), false);
> +	error = xfs_dec_fdblocks(mp, alen, false);
>  	if (error)
>  		goto out_unreserve_quota;
>  
> -	error = xfs_mod_fdblocks(mp, -((int64_t)indlen), false);
> +	error = xfs_dec_fdblocks(mp, indlen, false);
>  	if (error)
>  		goto out_unreserve_blocks;
>  
> @@ -4140,7 +4141,7 @@ xfs_bmapi_reserve_delalloc(
>  	return 0;
>  
>  out_unreserve_blocks:
> -	xfs_mod_fdblocks(mp, alen, false);
> +	xfs_add_fdblocks(mp, alen);
>  out_unreserve_quota:
>  	if (XFS_IS_QUOTA_ON(mp))
>  		xfs_quota_unreserve_blkres(ip, alen);
> @@ -4926,7 +4927,7 @@ xfs_bmap_del_extent_delay(
>  	ASSERT(got_endoff >= del_endoff);
>  
>  	if (isrt)
> -		xfs_mod_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
> +		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, del->br_blockcount));
>  
>  	/*
>  	 * Update the inode delalloc counter now and wait to update the
> @@ -5013,7 +5014,7 @@ xfs_bmap_del_extent_delay(
>  	if (!isrt)
>  		da_diff += del->br_blockcount;
>  	if (da_diff) {
> -		xfs_mod_fdblocks(mp, da_diff, false);
> +		xfs_add_fdblocks(mp, da_diff);
>  		xfs_mod_delalloc(mp, -da_diff);
>  	}
>  	return error;
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index d310737c882367..6f465373aa2027 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -517,7 +517,7 @@ xchk_fscounters(
>  
>  	/*
>  	 * If the filesystem is not frozen, the counter summation calls above
> -	 * can race with xfs_mod_freecounter, which subtracts a requested space
> +	 * can race with xfs_dec_freecounter, which subtracts a requested space
>  	 * reservation from the counter and undoes the subtraction if that made
>  	 * the counter go negative.  Therefore, it's possible to see negative
>  	 * values here, and we should only flag that as a corruption if we
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index f43dce771cdd26..6123e6c7ac7d67 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -963,9 +963,7 @@ xrep_reset_perag_resv(
>  	ASSERT(sc->tp);
>  
>  	sc->flags &= ~XREP_RESET_PERAG_RESV;
> -	error = xfs_ag_resv_free(sc->sa.pag);
> -	if (error)
> -		goto out;
> +	xfs_ag_resv_free(sc->sa.pag);
>  	error = xfs_ag_resv_init(sc->sa.pag, sc->tp);
>  	if (error == -ENOSPC) {
>  		xfs_err(sc->mp,
> @@ -974,7 +972,6 @@ xrep_reset_perag_resv(
>  		error = 0;
>  	}
>  
> -out:
>  	return error;
>  }
>  
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 83f708f62ed9f2..c211ea2b63c4dd 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -213,10 +213,8 @@ xfs_growfs_data_private(
>  			struct xfs_perag	*pag;
>  
>  			pag = xfs_perag_get(mp, id.agno);
> -			error = xfs_ag_resv_free(pag);
> +			xfs_ag_resv_free(pag);
>  			xfs_perag_put(pag);
> -			if (error)
> -				return error;
>  		}
>  		/*
>  		 * Reserve AG metadata blocks. ENOSPC here does not mean there
> @@ -385,14 +383,14 @@ xfs_reserve_blocks(
>  	 */
>  	if (mp->m_resblks > request) {
>  		lcounter = mp->m_resblks_avail - request;
> -		if (lcounter  > 0) {		/* release unused blocks */
> +		if (lcounter > 0) {		/* release unused blocks */
>  			fdblks_delta = lcounter;
>  			mp->m_resblks_avail -= lcounter;
>  		}
>  		mp->m_resblks = request;
>  		if (fdblks_delta) {
>  			spin_unlock(&mp->m_sb_lock);
> -			error = xfs_mod_fdblocks(mp, fdblks_delta, 0);
> +			xfs_add_fdblocks(mp, fdblks_delta);
>  			spin_lock(&mp->m_sb_lock);
>  		}
>  
> @@ -428,9 +426,9 @@ xfs_reserve_blocks(
>  		 */
>  		fdblks_delta = min(free, delta);
>  		spin_unlock(&mp->m_sb_lock);
> -		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
> +		error = xfs_dec_fdblocks(mp, fdblks_delta, 0);
>  		if (!error)
> -			xfs_mod_fdblocks(mp, fdblks_delta, 0);
> +			xfs_add_fdblocks(mp, fdblks_delta);
>  		spin_lock(&mp->m_sb_lock);
>  	}
>  out:
> @@ -556,24 +554,13 @@ xfs_fs_reserve_ag_blocks(
>  /*
>   * Free space reserved for per-AG metadata.
>   */
> -int
> +void
>  xfs_fs_unreserve_ag_blocks(
>  	struct xfs_mount	*mp)
>  {
>  	xfs_agnumber_t		agno;
>  	struct xfs_perag	*pag;
> -	int			error = 0;
> -	int			err2;
>  
> -	for_each_perag(mp, agno, pag) {
> -		err2 = xfs_ag_resv_free(pag);
> -		if (err2 && !error)
> -			error = err2;
> -	}
> -
> -	if (error)
> -		xfs_warn(mp,
> -	"Error %d freeing per-AG metadata reserve pool.", error);
> -
> -	return error;
> +	for_each_perag(mp, agno, pag)
> +		xfs_ag_resv_free(pag);
>  }
> diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
> index 44457b0a059376..3e2f73bcf8314b 100644
> --- a/fs/xfs/xfs_fsops.h
> +++ b/fs/xfs/xfs_fsops.h
> @@ -12,6 +12,6 @@ int xfs_reserve_blocks(struct xfs_mount *mp, uint64_t request);
>  int xfs_fs_goingdown(struct xfs_mount *mp, uint32_t inflags);
>  
>  int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
> -int xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
> +void xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
>  
>  #endif	/* __XFS_FSOPS_H__ */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 7328034d42ed8d..575a3b98cdb514 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1129,16 +1129,44 @@ xfs_fs_writable(
>  	return true;
>  }
>  
> -/* Adjust m_fdblocks or m_frextents. */
> +void
> +xfs_add_freecounter(
> +	struct xfs_mount	*mp,
> +	struct percpu_counter	*counter,
> +	uint64_t		delta)
> +{
> +	bool			has_resv_pool = (counter == &mp->m_fdblocks);
> +	uint64_t		res_used;
> +
> +	/*
> +	 * If the reserve pool is depleted, put blocks back into it first.
> +	 * Most of the time the pool is full.
> +	 */
> +	if (!has_resv_pool || mp->m_resblks == mp->m_resblks_avail) {
> +		percpu_counter_add(counter, delta);
> +		return;
> +	}
> +
> +	spin_lock(&mp->m_sb_lock);
> +	res_used = mp->m_resblks - mp->m_resblks_avail;
> +	if (res_used > delta) {
> +		mp->m_resblks_avail += delta;
> +	} else {
> +		delta -= res_used;
> +		mp->m_resblks_avail = mp->m_resblks;
> +		percpu_counter_add(counter, delta);
> +	}
> +	spin_unlock(&mp->m_sb_lock);
> +}
> +
>  int
> -xfs_mod_freecounter(
> +xfs_dec_freecounter(
>  	struct xfs_mount	*mp,
>  	struct percpu_counter	*counter,
> -	int64_t			delta,
> +	uint64_t		delta,
>  	bool			rsvd)
>  {
>  	int64_t			lcounter;
> -	long long		res_used;
>  	uint64_t		set_aside = 0;
>  	s32			batch;
>  	bool			has_resv_pool;
> @@ -1148,31 +1176,6 @@ xfs_mod_freecounter(
>  	if (rsvd)
>  		ASSERT(has_resv_pool);
>  
> -	if (delta > 0) {
> -		/*
> -		 * If the reserve pool is depleted, put blocks back into it
> -		 * first. Most of the time the pool is full.
> -		 */
> -		if (likely(!has_resv_pool ||
> -			   mp->m_resblks == mp->m_resblks_avail)) {
> -			percpu_counter_add(counter, delta);
> -			return 0;
> -		}
> -
> -		spin_lock(&mp->m_sb_lock);
> -		res_used = (long long)(mp->m_resblks - mp->m_resblks_avail);
> -
> -		if (res_used > delta) {
> -			mp->m_resblks_avail += delta;
> -		} else {
> -			delta -= res_used;
> -			mp->m_resblks_avail = mp->m_resblks;
> -			percpu_counter_add(counter, delta);
> -		}
> -		spin_unlock(&mp->m_sb_lock);
> -		return 0;
> -	}
> -
>  	/*
>  	 * Taking blocks away, need to be more accurate the closer we
>  	 * are to zero.
> @@ -1200,7 +1203,7 @@ xfs_mod_freecounter(
>  	 */
>  	if (has_resv_pool)
>  		set_aside = xfs_fdblocks_unavailable(mp);
> -	percpu_counter_add_batch(counter, delta, batch);
> +	percpu_counter_add_batch(counter, -((int64_t)delta), batch);
>  	if (__percpu_counter_compare(counter, set_aside,
>  				     XFS_FDBLOCKS_BATCH) >= 0) {
>  		/* we had space! */
> @@ -1212,11 +1215,11 @@ xfs_mod_freecounter(
>  	 * that took us to ENOSPC.
>  	 */
>  	spin_lock(&mp->m_sb_lock);
> -	percpu_counter_add(counter, -delta);
> +	percpu_counter_add(counter, delta);
>  	if (!has_resv_pool || !rsvd)
>  		goto fdblocks_enospc;
>  
> -	lcounter = (long long)mp->m_resblks_avail + delta;
> +	lcounter = (long long)mp->m_resblks_avail - delta;
>  	if (lcounter >= 0) {
>  		mp->m_resblks_avail = lcounter;
>  		spin_unlock(&mp->m_sb_lock);
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index e880aa48de68bb..d941437a0c7369 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -534,19 +534,30 @@ xfs_fdblocks_unavailable(
>  	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
>  }
>  
> -int xfs_mod_freecounter(struct xfs_mount *mp, struct percpu_counter *counter,
> -		int64_t delta, bool rsvd);
> +int xfs_dec_freecounter(struct xfs_mount *mp, struct percpu_counter *counter,
> +		uint64_t delta, bool rsvd);
> +void xfs_add_freecounter(struct xfs_mount *mp, struct percpu_counter *counter,
> +		uint64_t delta);
>  
> -static inline int
> -xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta, bool reserved)
> +static inline int xfs_dec_fdblocks(struct xfs_mount *mp, uint64_t delta,
> +		bool reserved)
>  {
> -	return xfs_mod_freecounter(mp, &mp->m_fdblocks, delta, reserved);
> +	return xfs_dec_freecounter(mp, &mp->m_fdblocks, delta, reserved);
>  }
>  
> -static inline int
> -xfs_mod_frextents(struct xfs_mount *mp, int64_t delta)
> +static inline void xfs_add_fdblocks(struct xfs_mount *mp, uint64_t delta)
>  {
> -	return xfs_mod_freecounter(mp, &mp->m_frextents, delta, false);
> +	xfs_add_freecounter(mp, &mp->m_fdblocks, delta);
> +}
> +
> +static inline int xfs_dec_frextents(struct xfs_mount *mp, uint64_t delta)
> +{
> +	return xfs_dec_freecounter(mp, &mp->m_frextents, delta, false);
> +}
> +
> +static inline void xfs_add_frextents(struct xfs_mount *mp, uint64_t delta)
> +{
> +	xfs_add_freecounter(mp, &mp->m_frextents, delta);
>  }
>  
>  extern int	xfs_readsb(xfs_mount_t *, int);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 6828c48b15e9bd..0afcb005a28fc1 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1874,11 +1874,7 @@ xfs_remount_ro(
>  	xfs_inodegc_stop(mp);
>  
>  	/* Free the per-AG metadata reservation pool. */
> -	error = xfs_fs_unreserve_ag_blocks(mp);
> -	if (error) {
> -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -		return error;
> -	}
> +	xfs_fs_unreserve_ag_blocks(mp);
>  
>  	/*
>  	 * Before we sync the metadata, we need to free up the reserve block
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index aea97fc074f8de..1c5753f91c388e 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3062,7 +3062,6 @@ DEFINE_AG_RESV_EVENT(xfs_ag_resv_free_extent);
>  DEFINE_AG_RESV_EVENT(xfs_ag_resv_critical);
>  DEFINE_AG_RESV_EVENT(xfs_ag_resv_needed);
>  
> -DEFINE_AG_ERROR_EVENT(xfs_ag_resv_free_error);
>  DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
>  
>  /* refcount tracepoint classes */
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 924b460229e951..b18d478e2c9e85 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -163,7 +163,7 @@ xfs_trans_reserve(
>  	 * fail if the count would go below zero.
>  	 */
>  	if (blocks > 0) {
> -		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
> +		error = xfs_dec_fdblocks(mp, blocks, rsvd);
>  		if (error != 0)
>  			return -ENOSPC;
>  		tp->t_blk_res += blocks;
> @@ -210,7 +210,7 @@ xfs_trans_reserve(
>  	 * fail if the count would go below zero.
>  	 */
>  	if (rtextents > 0) {
> -		error = xfs_mod_frextents(mp, -((int64_t)rtextents));
> +		error = xfs_dec_frextents(mp, rtextents);
>  		if (error) {
>  			error = -ENOSPC;
>  			goto undo_log;
> @@ -234,7 +234,7 @@ xfs_trans_reserve(
>  
>  undo_blocks:
>  	if (blocks > 0) {
> -		xfs_mod_fdblocks(mp, (int64_t)blocks, rsvd);
> +		xfs_add_fdblocks(mp, blocks);
>  		tp->t_blk_res = 0;
>  	}
>  	return error;
> @@ -593,12 +593,10 @@ xfs_trans_unreserve_and_mod_sb(
>  	struct xfs_trans	*tp)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
>  	int64_t			blkdelta = tp->t_blk_res;
>  	int64_t			rtxdelta = tp->t_rtx_res;
>  	int64_t			idelta = 0;
>  	int64_t			ifreedelta = 0;
> -	int			error;
>  
>  	/*
>  	 * Calculate the deltas.
> @@ -631,10 +629,8 @@ xfs_trans_unreserve_and_mod_sb(
>  	}
>  
>  	/* apply the per-cpu counters */
> -	if (blkdelta) {
> -		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
> -		ASSERT(!error);
> -	}
> +	if (blkdelta)
> +		xfs_add_fdblocks(mp, blkdelta);
>  
>  	if (idelta)
>  		percpu_counter_add_batch(&mp->m_icount, idelta,
> @@ -643,10 +639,8 @@ xfs_trans_unreserve_and_mod_sb(
>  	if (ifreedelta)
>  		percpu_counter_add(&mp->m_ifree, ifreedelta);
>  
> -	if (rtxdelta) {
> -		error = xfs_mod_frextents(mp, rtxdelta);
> -		ASSERT(!error);
> -	}
> +	if (rtxdelta)
> +		xfs_add_frextents(mp, rtxdelta);
>  
>  	if (!(tp->t_flags & XFS_TRANS_SB_DIRTY))
>  		return;
> @@ -682,7 +676,6 @@ xfs_trans_unreserve_and_mod_sb(
>  	 */
>  	ASSERT(mp->m_sb.sb_imax_pct >= 0);
>  	ASSERT(mp->m_sb.sb_rextslog >= 0);
> -	return;
>  }
>  
>  /* Add the given log item to the transaction's list of log items. */
> @@ -1301,9 +1294,9 @@ xfs_trans_reserve_more_inode(
>  		return 0;
>  
>  	/* Quota failed, give back the new reservation. */
> -	xfs_mod_fdblocks(mp, dblocks, tp->t_flags & XFS_TRANS_RESERVE);
> +	xfs_add_fdblocks(mp, dblocks);
>  	tp->t_blk_res -= dblocks;
> -	xfs_mod_frextents(mp, rtx);
> +	xfs_add_frextents(mp, rtx);
>  	tp->t_rtx_res -= rtx;
>  	return error;
>  }
> -- 
> 2.39.2
> 

