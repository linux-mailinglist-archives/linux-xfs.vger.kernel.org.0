Return-Path: <linux-xfs+bounces-19974-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD03CA3CC1C
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 23:12:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C937F3AEA2D
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 22:11:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96BA72586C3;
	Wed, 19 Feb 2025 22:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N0xGk0F7"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477652580ED
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 22:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740003111; cv=none; b=jAuJP//IJOqIHKMYWKDSuRHxNQ+LM7FU4FYWN7YP/CgzyZov9dN/m3XZKYK+cu7M3mEZ5HDhHI1K/MKIk72hR1ZmndroOzTJ23fA/4N+MW3/q28UzbWk8//EglnheHxOn4ahTbnTUsI7r9FA8jc/wLguX3YcdKkrY2tcrazEL3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740003111; c=relaxed/simple;
	bh=Ln2+lLXNX2zs8H3CSVIyiFcEzx8YhwPNrUBmJQUdYWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SEgShq+z2McKb3Tc9qx8RkAG9bZPszNAmEUtrogyBWOfbbqTB69SEmtsGb4I4zcuE+JSChPpwiNqgMonzy3oqdg0tfPvUmTX3W99vzYrN5KIra9rseZm8eh8Wouxzcb/3MCFxdMW1lOTsz+vmi6cBX2eocTo/jpwBkr4lSewKBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N0xGk0F7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B13C4CED1;
	Wed, 19 Feb 2025 22:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740003110;
	bh=Ln2+lLXNX2zs8H3CSVIyiFcEzx8YhwPNrUBmJQUdYWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N0xGk0F7sGWMmxHozGva4FFb9ycEMXtC5S9Yi0l0tH9JBtAFxOzkXvsiwHg8yRkHC
	 RZAiBY3sWY1+k+3Zbl4ZovozECY6rP+suuGSOpD+dZyfHFBmwq+crU7RR4cnPIj/Y2
	 9hVSvo+4jp+t0XDOjtNERLNSoer8+PeBf1STQNmJcWNjbVYkDXfODo+cvhxTLjmh5/
	 f1fhb+r07wuEbykytQvblrQ4ZdFPK4R8QTdWxGD5vvOw2hc8vmPWSQBuuKfDhcRTTD
	 0xWA0s69+Rr02EXOEpkBFBTq5JGWwoOPodqSo1f21Ix8XpkkB2D0URqLXsxBe8UyyG
	 EzNNmlJHIQz4g==
Date: Wed, 19 Feb 2025 14:11:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/45] xfs: generalize the freespace and reserved blocks
 handling
Message-ID: <20250219221150.GA21808@frogsfrogsfrogs>
References: <20250218081153.3889537-1-hch@lst.de>
 <20250218081153.3889537-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218081153.3889537-3-hch@lst.de>

On Tue, Feb 18, 2025 at 09:10:05AM +0100, Christoph Hellwig wrote:
> xfs_{add,dec}_freecounter already handles the block and RT extent
> percpu counters, but it currently hardcodes the passed in counter.
> 
> Add a freecounter abstraction that uses an enum to designate the counter
> and add wrappers that hide the actual percpu_counters.  This will allow
> expanding the reserved block handling to the RT extent counter in the
> next step, and also prepares for adding yet another such counter that
> can share the code.  Both these additions will be needed for the zoned
> allocator.
> 
> Also switch the flooring of the frextents counter to 0 in statfs for the
> rthinherit case to a manual min_t call to match the handling of the
> fdblocks counter for normal file systems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I've combed over /this/ file like 15 times now and ... I don't see
anything wrong with it.  To me it looks like a pretty straightforward
conversion to use an enum and an array of percpu counter wrappers.

But then I've been trying to QA this, and I keep seeing regressions in
xfs/565 where repair says:

_check_xfs_filesystem: filesystem on /dev/sda4 is inconsistent (r)
*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 2
        - agno = 1
        - agno = 3
        - generate realtime summary info and bitmap...
sb_frextents 8739748, counted 8747940

There's something clearly wrong here, but after a couple of months I
haven't succeeded in bisecting this to a particular commit, let alone a
specific code change.  Right now I've diverted the entire test fleet to
running xfs/565 on each of the 45 patches in this series to see if I can
come up with anything.

So far, "xfs: support reserved blocks for the rt extent counter" and
"xfs: trace in memory freecounter reservations" tripped it, and
everything else is still running.

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c       |  2 +-
>  fs/xfs/libxfs/xfs_metafile.c     |  2 +-
>  fs/xfs/libxfs/xfs_sb.c           |  8 ++--
>  fs/xfs/libxfs/xfs_types.h        | 17 ++++++++
>  fs/xfs/scrub/fscounters.c        | 11 ++---
>  fs/xfs/scrub/fscounters_repair.c |  4 +-
>  fs/xfs/scrub/newbt.c             |  2 +-
>  fs/xfs/xfs_fsops.c               |  6 +--
>  fs/xfs/xfs_icache.c              |  4 +-
>  fs/xfs/xfs_ioctl.c               |  6 +--
>  fs/xfs/xfs_iomap.c               |  9 ++--
>  fs/xfs/xfs_mount.c               | 37 +++++++++++++----
>  fs/xfs/xfs_mount.h               | 70 ++++++++++++++++++++++++--------
>  fs/xfs/xfs_rtalloc.c             |  2 +-
>  fs/xfs/xfs_super.c               | 42 ++++++++++---------
>  fs/xfs/xfs_trace.h               |  2 +-
>  16 files changed, 151 insertions(+), 73 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index f3a840a425f5..57513ba19d6a 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1927,7 +1927,7 @@ xfs_dialloc(
>  	 * that we can immediately allocate, but then we allow allocation on the
>  	 * second pass if we fail to find an AG with free inodes in it.
>  	 */
> -	if (percpu_counter_read_positive(&mp->m_fdblocks) <
> +	if (xfs_estimate_freecounter(mp, XC_FREE_BLOCKS) <
>  			mp->m_low_space[XFS_LOWSP_1_PCNT]) {
>  		ok_alloc = false;
>  		low_space = true;
> diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
> index 2f5f554a36d4..7625e694eb8d 100644
> --- a/fs/xfs/libxfs/xfs_metafile.c
> +++ b/fs/xfs/libxfs/xfs_metafile.c
> @@ -95,7 +95,7 @@ xfs_metafile_resv_can_cover(
>  	 * There aren't enough blocks left in the inode's reservation, but it
>  	 * isn't critical unless there also isn't enough free space.
>  	 */
> -	return __percpu_counter_compare(&ip->i_mount->m_fdblocks,
> +	return xfs_compare_freecounter(ip->i_mount, XC_FREE_BLOCKS,
>  			rhs - ip->i_delayed_blks, 2048) >= 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 3dc5f5dba162..3fdd20df961c 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1265,8 +1265,7 @@ xfs_log_sb(
>  		mp->m_sb.sb_ifree = min_t(uint64_t,
>  				percpu_counter_sum_positive(&mp->m_ifree),
>  				mp->m_sb.sb_icount);
> -		mp->m_sb.sb_fdblocks =
> -				percpu_counter_sum_positive(&mp->m_fdblocks);
> +		mp->m_sb.sb_fdblocks = xfs_sum_freecounter(mp, XC_FREE_BLOCKS);
>  	}
>  
>  	/*
> @@ -1275,9 +1274,10 @@ xfs_log_sb(
>  	 * we handle nearly-lockless reservations, so we must use the _positive
>  	 * variant here to avoid writing out nonsense frextents.
>  	 */
> -	if (xfs_has_rtgroups(mp))
> +	if (xfs_has_rtgroups(mp)) {
>  		mp->m_sb.sb_frextents =
> -				percpu_counter_sum_positive(&mp->m_frextents);
> +				xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS);
> +	}
>  
>  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index ca2401c1facd..76f3c31573ec 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -233,6 +233,23 @@ enum xfs_group_type {
>  	{ XG_TYPE_AG,	"ag" }, \
>  	{ XG_TYPE_RTG,	"rtg" }
>  
> +enum xfs_free_counter {
> +	/*
> +	 * Number of free blocks on the data device.
> +	 */
> +	XC_FREE_BLOCKS,
> +
> +	/*
> +	 * Number of free RT extents on the RT device.
> +	 */
> +	XC_FREE_RTEXTENTS,
> +	XC_FREE_NR,
> +};
> +
> +#define XFS_FREECOUNTER_STR \
> +	{ XC_FREE_BLOCKS,		"blocks" }, \
> +	{ XC_FREE_RTEXTENTS,		"rtextents" }
> +
>  /*
>   * Type verifier functions
>   */
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index ca23cf4db6c5..207a238de429 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -513,8 +513,8 @@ xchk_fscounters(
>  	/* Snapshot the percpu counters. */
>  	icount = percpu_counter_sum(&mp->m_icount);
>  	ifree = percpu_counter_sum(&mp->m_ifree);
> -	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> -	frextents = percpu_counter_sum(&mp->m_frextents);
> +	fdblocks = xfs_sum_freecounter_raw(mp, XC_FREE_BLOCKS);
> +	frextents = xfs_sum_freecounter_raw(mp, XC_FREE_RTEXTENTS);
>  
>  	/* No negative values, please! */
>  	if (icount < 0 || ifree < 0)
> @@ -589,15 +589,16 @@ xchk_fscounters(
>  			try_again = true;
>  	}
>  
> -	if (!xchk_fscount_within_range(sc, fdblocks, &mp->m_fdblocks,
> -			fsc->fdblocks)) {
> +	if (!xchk_fscount_within_range(sc, fdblocks,
> +			&mp->m_free[XC_FREE_BLOCKS].count, fsc->fdblocks)) {
>  		if (fsc->frozen)
>  			xchk_set_corrupt(sc);
>  		else
>  			try_again = true;
>  	}
>  
> -	if (!xchk_fscount_within_range(sc, frextents, &mp->m_frextents,
> +	if (!xchk_fscount_within_range(sc, frextents,
> +			&mp->m_free[XC_FREE_RTEXTENTS].count,
>  			fsc->frextents - fsc->frextents_delayed)) {
>  		if (fsc->frozen)
>  			xchk_set_corrupt(sc);
> diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
> index cda13447a373..8fb0db78489e 100644
> --- a/fs/xfs/scrub/fscounters_repair.c
> +++ b/fs/xfs/scrub/fscounters_repair.c
> @@ -64,7 +64,7 @@ xrep_fscounters(
>  
>  	percpu_counter_set(&mp->m_icount, fsc->icount);
>  	percpu_counter_set(&mp->m_ifree, fsc->ifree);
> -	percpu_counter_set(&mp->m_fdblocks, fsc->fdblocks);
> +	xfs_set_freecounter(mp, XC_FREE_BLOCKS, fsc->fdblocks);
>  
>  	/*
>  	 * Online repair is only supported on v5 file systems, which require
> @@ -74,7 +74,7 @@ xrep_fscounters(
>  	 * track of the delalloc reservations separately, as they are are
>  	 * subtracted from m_frextents, but not included in sb_frextents.
>  	 */
> -	percpu_counter_set(&mp->m_frextents,
> +	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
>  		fsc->frextents - fsc->frextents_delayed);
>  	if (!xfs_has_rtgroups(mp))
>  		mp->m_sb.sb_frextents = fsc->frextents;
> diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
> index ac38f5843090..1588ce971cb8 100644
> --- a/fs/xfs/scrub/newbt.c
> +++ b/fs/xfs/scrub/newbt.c
> @@ -62,7 +62,7 @@ xrep_newbt_estimate_slack(
>  		free = sc->sa.pag->pagf_freeblks;
>  		sz = xfs_ag_block_count(sc->mp, pag_agno(sc->sa.pag));
>  	} else {
> -		free = percpu_counter_sum(&sc->mp->m_fdblocks);
> +		free = xfs_sum_freecounter_raw(sc->mp, XC_FREE_BLOCKS);
>  		sz = sc->mp->m_sb.sb_dblocks;
>  	}
>  
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 455298503d01..58249f37a7ad 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -409,7 +409,7 @@ xfs_reserve_blocks(
>  
>  	/*
>  	 * If the request is larger than the current reservation, reserve the
> -	 * blocks before we update the reserve counters. Sample m_fdblocks and
> +	 * blocks before we update the reserve counters. Sample m_free and
>  	 * perform a partial reservation if the request exceeds free space.
>  	 *
>  	 * The code below estimates how many blocks it can request from
> @@ -419,8 +419,8 @@ xfs_reserve_blocks(
>  	 * space to fill it because mod_fdblocks will refill an undersized
>  	 * reserve when it can.
>  	 */
> -	free = percpu_counter_sum(&mp->m_fdblocks) -
> -						xfs_fdblocks_unavailable(mp);
> +	free = xfs_sum_freecounter_raw(mp, XC_FREE_BLOCKS) -
> +		xfs_freecounter_unavailable(mp, XC_FREE_BLOCKS);
>  	delta = request - mp->m_resblks;
>  	mp->m_resblks = request;
>  	if (delta > 0 && free > 0) {
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 7b6c026d01a1..c9ded501e89b 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -2076,7 +2076,7 @@ xfs_inodegc_want_queue_rt_file(
>  	if (!XFS_IS_REALTIME_INODE(ip))
>  		return false;
>  
> -	if (__percpu_counter_compare(&mp->m_frextents,
> +	if (xfs_compare_freecounter(mp, XC_FREE_RTEXTENTS,
>  				mp->m_low_rtexts[XFS_LOWSP_5_PCNT],
>  				XFS_FDBLOCKS_BATCH) < 0)
>  		return true;
> @@ -2104,7 +2104,7 @@ xfs_inodegc_want_queue_work(
>  	if (items > mp->m_ino_geo.inodes_per_cluster)
>  		return true;
>  
> -	if (__percpu_counter_compare(&mp->m_fdblocks,
> +	if (xfs_compare_freecounter(mp, XC_FREE_BLOCKS,
>  				mp->m_low_space[XFS_LOWSP_5_PCNT],
>  				XFS_FDBLOCKS_BATCH) < 0)
>  		return true;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index ed85322507dd..0418aad2db91 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1155,9 +1155,9 @@ xfs_ioctl_fs_counts(
>  	struct xfs_fsop_counts	out = {
>  		.allocino = percpu_counter_read_positive(&mp->m_icount),
>  		.freeino  = percpu_counter_read_positive(&mp->m_ifree),
> -		.freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
> -				xfs_fdblocks_unavailable(mp),
> -		.freertx  = percpu_counter_read_positive(&mp->m_frextents),
> +		.freedata = xfs_estimate_freecounter(mp, XC_FREE_BLOCKS) -
> +				xfs_freecounter_unavailable(mp, XC_FREE_BLOCKS),
> +		.freertx  = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS),
>  	};
>  
>  	if (copy_to_user(uarg, &out, sizeof(out)))
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 46acf727cbe7..c669b93bb2d1 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -431,13 +431,14 @@ xfs_quota_calc_throttle(
>  
>  static int64_t
>  xfs_iomap_freesp(
> -	struct percpu_counter	*counter,
> +	struct xfs_mount	*mp,
> +	unsigned int		idx,
>  	uint64_t		low_space[XFS_LOWSP_MAX],
>  	int			*shift)
>  {
>  	int64_t			freesp;
>  
> -	freesp = percpu_counter_read_positive(counter);
> +	freesp = xfs_estimate_freecounter(mp, idx);
>  	if (freesp < low_space[XFS_LOWSP_5_PCNT]) {
>  		*shift = 2;
>  		if (freesp < low_space[XFS_LOWSP_4_PCNT])
> @@ -536,10 +537,10 @@ xfs_iomap_prealloc_size(
>  
>  	if (unlikely(XFS_IS_REALTIME_INODE(ip)))
>  		freesp = xfs_rtbxlen_to_blen(mp,
> -				xfs_iomap_freesp(&mp->m_frextents,
> +				xfs_iomap_freesp(mp, XC_FREE_RTEXTENTS,
>  					mp->m_low_rtexts, &shift));
>  	else
> -		freesp = xfs_iomap_freesp(&mp->m_fdblocks, mp->m_low_space,
> +		freesp = xfs_iomap_freesp(mp, XC_FREE_BLOCKS, mp->m_low_space,
>  				&shift);
>  
>  	/*
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 0598e9db488c..ee97a927bc3b 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1223,13 +1223,31 @@ xfs_fs_writable(
>  	return true;
>  }
>  
> +/*
> + * Estimate the amount of free space that is not available to userspace and is
> + * not explicitly reserved from the incore fdblocks.  This includes:
> + *
> + * - The minimum number of blocks needed to support splitting a bmap btree
> + * - The blocks currently in use by the freespace btrees because they record
> + *   the actual blocks that will fill per-AG metadata space reservations
> + */
> +uint64_t
> +xfs_freecounter_unavailable(
> +	struct xfs_mount	*mp,
> +	enum xfs_free_counter	ctr)
> +{
> +	if (ctr != XC_FREE_BLOCKS)
> +		return 0;
> +	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
> +}
> +
>  void
>  xfs_add_freecounter(
>  	struct xfs_mount	*mp,
> -	struct percpu_counter	*counter,
> +	enum xfs_free_counter	ctr,
>  	uint64_t		delta)
>  {
> -	bool			has_resv_pool = (counter == &mp->m_fdblocks);
> +	bool			has_resv_pool = (ctr == XC_FREE_BLOCKS);
>  	uint64_t		res_used;
>  
>  	/*
> @@ -1237,7 +1255,7 @@ xfs_add_freecounter(
>  	 * Most of the time the pool is full.
>  	 */
>  	if (!has_resv_pool || mp->m_resblks == mp->m_resblks_avail) {
> -		percpu_counter_add(counter, delta);
> +		percpu_counter_add(&mp->m_free[ctr].count, delta);
>  		return;
>  	}
>  
> @@ -1248,24 +1266,27 @@ xfs_add_freecounter(
>  	} else {
>  		delta -= res_used;
>  		mp->m_resblks_avail = mp->m_resblks;
> -		percpu_counter_add(counter, delta);
> +		percpu_counter_add(&mp->m_free[ctr].count, delta);
>  	}
>  	spin_unlock(&mp->m_sb_lock);
>  }
>  
> +
> +/* Adjust in-core free blocks or RT extents. */
>  int
>  xfs_dec_freecounter(
>  	struct xfs_mount	*mp,
> -	struct percpu_counter	*counter,
> +	enum xfs_free_counter	ctr,
>  	uint64_t		delta,
>  	bool			rsvd)
>  {
> +	struct percpu_counter	*counter = &mp->m_free[ctr].count;
>  	uint64_t		set_aside = 0;
>  	s32			batch;
>  	bool			has_resv_pool;
>  
> -	ASSERT(counter == &mp->m_fdblocks || counter == &mp->m_frextents);
> -	has_resv_pool = (counter == &mp->m_fdblocks);
> +	ASSERT(ctr < XC_FREE_NR);
> +	has_resv_pool = (ctr == XC_FREE_BLOCKS);
>  	if (rsvd)
>  		ASSERT(has_resv_pool);
>  
> @@ -1295,7 +1316,7 @@ xfs_dec_freecounter(
>  	 * slightly premature -ENOSPC.
>  	 */
>  	if (has_resv_pool)
> -		set_aside = xfs_fdblocks_unavailable(mp);
> +		set_aside = xfs_freecounter_unavailable(mp, ctr);
>  	percpu_counter_add_batch(counter, -((int64_t)delta), batch);
>  	if (__percpu_counter_compare(counter, set_aside,
>  			XFS_FDBLOCKS_BATCH) < 0) {
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index fbed172d6770..7f3265d669bc 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -105,6 +105,11 @@ struct xfs_groups {
>  	uint64_t		blkmask;
>  };
>  
> +struct xfs_freecounter {
> +	/* free blocks for general use: */
> +	struct percpu_counter	count;
> +};
> +
>  /*
>   * The struct xfsmount layout is optimised to separate read-mostly variables
>   * from variables that are frequently modified. We put the read-mostly variables
> @@ -222,8 +227,8 @@ typedef struct xfs_mount {
>  	spinlock_t ____cacheline_aligned m_sb_lock; /* sb counter lock */
>  	struct percpu_counter	m_icount;	/* allocated inodes counter */
>  	struct percpu_counter	m_ifree;	/* free inodes counter */
> -	struct percpu_counter	m_fdblocks;	/* free block counter */
> -	struct percpu_counter	m_frextents;	/* free rt extent counter */
> +
> +	struct xfs_freecounter	m_free[XC_FREE_NR];
>  
>  	/*
>  	 * Count of data device blocks reserved for delayed allocations,
> @@ -646,45 +651,74 @@ extern void	xfs_unmountfs(xfs_mount_t *);
>   */
>  #define XFS_FDBLOCKS_BATCH	1024
>  
> +uint64_t xfs_freecounter_unavailable(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr);
> +
>  /*
> - * Estimate the amount of free space that is not available to userspace and is
> - * not explicitly reserved from the incore fdblocks.  This includes:
> - *
> - * - The minimum number of blocks needed to support splitting a bmap btree
> - * - The blocks currently in use by the freespace btrees because they record
> - *   the actual blocks that will fill per-AG metadata space reservations
> + * Sum up the freecount, but never return negative values.
>   */
> -static inline uint64_t
> -xfs_fdblocks_unavailable(
> -	struct xfs_mount	*mp)
> +static inline s64 xfs_sum_freecounter(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr)
> +{
> +	return percpu_counter_sum_positive(&mp->m_free[ctr].count);
> +}
> +
> +/*
> + * Same as above, but does return negative values.  Mostly useful for
> + * special cases like repair and tracing.
> + */
> +static inline s64 xfs_sum_freecounter_raw(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr)
> +{
> +	return percpu_counter_sum(&mp->m_free[ctr].count);
> +}
> +
> +/*
> + * This just provides and estimate without the cpu-local updates, use
> + * xfs_sum_freecounter for the exact value.
> + */
> +static inline s64 xfs_estimate_freecounter(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr)
> +{
> +	return percpu_counter_read_positive(&mp->m_free[ctr].count);
> +}
> +
> +static inline int xfs_compare_freecounter(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr, s64 rhs, s32 batch)
> +{
> +	return __percpu_counter_compare(&mp->m_free[ctr].count, rhs, batch);
> +}
> +
> +static inline void xfs_set_freecounter(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr, uint64_t val)
>  {
> -	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
> +	percpu_counter_set(&mp->m_free[ctr].count, val);
>  }
>  
> -int xfs_dec_freecounter(struct xfs_mount *mp, struct percpu_counter *counter,
> +int xfs_dec_freecounter(struct xfs_mount *mp, enum xfs_free_counter ctr,
>  		uint64_t delta, bool rsvd);
> -void xfs_add_freecounter(struct xfs_mount *mp, struct percpu_counter *counter,
> +void xfs_add_freecounter(struct xfs_mount *mp, enum xfs_free_counter ctr,
>  		uint64_t delta);
>  
>  static inline int xfs_dec_fdblocks(struct xfs_mount *mp, uint64_t delta,
>  		bool reserved)
>  {
> -	return xfs_dec_freecounter(mp, &mp->m_fdblocks, delta, reserved);
> +	return xfs_dec_freecounter(mp, XC_FREE_BLOCKS, delta, reserved);
>  }
>  
>  static inline void xfs_add_fdblocks(struct xfs_mount *mp, uint64_t delta)
>  {
> -	xfs_add_freecounter(mp, &mp->m_fdblocks, delta);
> +	xfs_add_freecounter(mp, XC_FREE_BLOCKS, delta);
>  }
>  
>  static inline int xfs_dec_frextents(struct xfs_mount *mp, uint64_t delta)
>  {
> -	return xfs_dec_freecounter(mp, &mp->m_frextents, delta, false);
> +	return xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, delta, false);
>  }
>  
>  static inline void xfs_add_frextents(struct xfs_mount *mp, uint64_t delta)
>  {
> -	xfs_add_freecounter(mp, &mp->m_frextents, delta);
> +	xfs_add_freecounter(mp, XC_FREE_RTEXTENTS, delta);
>  }
>  
>  extern int	xfs_readsb(xfs_mount_t *, int);
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index d8e6d073d64d..489aab923c9b 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1519,7 +1519,7 @@ xfs_rtalloc_reinit_frextents(
>  	spin_lock(&mp->m_sb_lock);
>  	mp->m_sb.sb_frextents = val;
>  	spin_unlock(&mp->m_sb_lock);
> -	percpu_counter_set(&mp->m_frextents, mp->m_sb.sb_frextents);
> +	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS, mp->m_sb.sb_frextents);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 0055066fb1d9..b08d28a895cb 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -834,10 +834,12 @@ xfs_statfs_data(
>  	struct kstatfs		*st)
>  {
>  	int64_t			fdblocks =
> -		percpu_counter_sum(&mp->m_fdblocks);
> +		xfs_sum_freecounter(mp, XC_FREE_BLOCKS);
>  
>  	/* make sure st->f_bfree does not underflow */
> -	st->f_bfree = max(0LL, fdblocks - xfs_fdblocks_unavailable(mp));
> +	st->f_bfree = max(0LL,
> +		fdblocks - xfs_freecounter_unavailable(mp, XC_FREE_BLOCKS));
> +
>  	/*
>  	 * sb_dblocks can change during growfs, but nothing cares about reporting
>  	 * the old or new value during growfs.
> @@ -856,7 +858,7 @@ xfs_statfs_rt(
>  	struct kstatfs		*st)
>  {
>  	st->f_bfree = xfs_rtbxlen_to_blen(mp,
> -			percpu_counter_sum_positive(&mp->m_frextents));
> +			xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
>  	st->f_blocks = mp->m_sb.sb_rblocks;
>  }
>  
> @@ -1065,7 +1067,8 @@ static int
>  xfs_init_percpu_counters(
>  	struct xfs_mount	*mp)
>  {
> -	int		error;
> +	int			error;
> +	int			i;
>  
>  	error = percpu_counter_init(&mp->m_icount, 0, GFP_KERNEL);
>  	if (error)
> @@ -1075,30 +1078,29 @@ xfs_init_percpu_counters(
>  	if (error)
>  		goto free_icount;
>  
> -	error = percpu_counter_init(&mp->m_fdblocks, 0, GFP_KERNEL);
> -	if (error)
> -		goto free_ifree;
> -
>  	error = percpu_counter_init(&mp->m_delalloc_blks, 0, GFP_KERNEL);
>  	if (error)
> -		goto free_fdblocks;
> +		goto free_ifree;
>  
>  	error = percpu_counter_init(&mp->m_delalloc_rtextents, 0, GFP_KERNEL);
>  	if (error)
>  		goto free_delalloc;
>  
> -	error = percpu_counter_init(&mp->m_frextents, 0, GFP_KERNEL);
> -	if (error)
> -		goto free_delalloc_rt;
> +	for (i = 0; i < XC_FREE_NR; i++) {
> +		error = percpu_counter_init(&mp->m_free[i].count, 0,
> +				GFP_KERNEL);
> +		if (error)
> +			goto free_freecounters;
> +	}
>  
>  	return 0;
>  
> -free_delalloc_rt:
> +free_freecounters:
> +	while (--i > 0)
> +		percpu_counter_destroy(&mp->m_free[i].count);
>  	percpu_counter_destroy(&mp->m_delalloc_rtextents);
>  free_delalloc:
>  	percpu_counter_destroy(&mp->m_delalloc_blks);
> -free_fdblocks:
> -	percpu_counter_destroy(&mp->m_fdblocks);
>  free_ifree:
>  	percpu_counter_destroy(&mp->m_ifree);
>  free_icount:
> @@ -1112,24 +1114,26 @@ xfs_reinit_percpu_counters(
>  {
>  	percpu_counter_set(&mp->m_icount, mp->m_sb.sb_icount);
>  	percpu_counter_set(&mp->m_ifree, mp->m_sb.sb_ifree);
> -	percpu_counter_set(&mp->m_fdblocks, mp->m_sb.sb_fdblocks);
> -	percpu_counter_set(&mp->m_frextents, mp->m_sb.sb_frextents);
> +	xfs_set_freecounter(mp, XC_FREE_BLOCKS, mp->m_sb.sb_fdblocks);
> +	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS, mp->m_sb.sb_frextents);
>  }
>  
>  static void
>  xfs_destroy_percpu_counters(
>  	struct xfs_mount	*mp)
>  {
> +	enum xfs_free_counter	i;
> +
> +	for (i = 0; i < XC_FREE_NR; i++)
> +		percpu_counter_destroy(&mp->m_free[i].count);
>  	percpu_counter_destroy(&mp->m_icount);
>  	percpu_counter_destroy(&mp->m_ifree);
> -	percpu_counter_destroy(&mp->m_fdblocks);
>  	ASSERT(xfs_is_shutdown(mp) ||
>  	       percpu_counter_sum(&mp->m_delalloc_rtextents) == 0);
>  	percpu_counter_destroy(&mp->m_delalloc_rtextents);
>  	ASSERT(xfs_is_shutdown(mp) ||
>  	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
>  	percpu_counter_destroy(&mp->m_delalloc_blks);
> -	percpu_counter_destroy(&mp->m_frextents);
>  }
>  
>  static int
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index b29462363b81..7fdcb519cf2f 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -5621,7 +5621,7 @@ DECLARE_EVENT_CLASS(xfs_metafile_resv_class,
>  
>  		__entry->dev = mp->m_super->s_dev;
>  		__entry->ino = ip->i_ino;
> -		__entry->freeblks = percpu_counter_sum(&mp->m_fdblocks);
> +		__entry->freeblks = xfs_sum_freecounter_raw(mp, XC_FREE_BLOCKS);
>  		__entry->reserved = ip->i_delayed_blks;
>  		__entry->asked = ip->i_meta_resv_asked;
>  		__entry->used = ip->i_nblocks;
> -- 
> 2.45.2
> 
> 

