Return-Path: <linux-xfs+bounces-19432-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0602A31A76
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Feb 2025 01:27:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BF033A6DEF
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Feb 2025 00:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A887259C;
	Wed, 12 Feb 2025 00:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kn+Jaj3X"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E76184F
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 00:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739320048; cv=none; b=feCd37ackX1J/lUSYrIcQvrw0KlIEhl6QYNKIm67pdXYJi+eiMpaQMNPT0utgeG0VfIUB8ciNei+m9XxyV/Jm/53pBIGRDz3zKTwjenZlKQaehqnYmZepEgPOs58olW91VpS8G7muTtxnlw1/43ztCrg9qeqZC6oXTpDgHPeQBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739320048; c=relaxed/simple;
	bh=peQRwF2TX0w3DuzLWH7mgf54Eo5XApcZgFBxxE7u0B0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mYmHeMlLPH1qi7558PZ1YLUl9vlPCWUDVQBwwg5yICH9/kKeZJ2akZriCWwuaCMrsjCsChJkhExwUNyAMIpl2fcrW6j5TwD6mYG06e/S+3WHuIeH0un9mQXxUCBpyEurmURdSMvx6nz+JYOudhXvyagiQcC8p5c1ENfc5vpsTqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kn+Jaj3X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740EAC4CEDD;
	Wed, 12 Feb 2025 00:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739320047;
	bh=peQRwF2TX0w3DuzLWH7mgf54Eo5XApcZgFBxxE7u0B0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kn+Jaj3XTtR8TUsw3EtXej5qwtsAdtVzCxcMs0sI1Gi22OBvsAZdcHkLIy+W0qSox
	 GUAdxCEGYvWbrZX0Iz4rsly9N0VQ84ffizkMbcd/o3Ab6YVvQ00NBlwRYqCpvtLO6Y
	 3xKvBsZ4NJc5VIQ006gWTuhS7FxxmFnMWwyIONnKIBVeD+6iIJCTZRxx8A16whkDU6
	 O0NXSUIFHAPd6qgqQX6e+fcjN6YO+KbRX/GznKFs4eKSolYzgU95/FEITqqU00TUE0
	 qQT8Gbg3gcPbR8ACG5a4XwZojvqhTnlU90K+6+jHvyet9e9U/vfwjt9L2lKnfWc6m7
	 0Ef3Lpn/OQZLg==
Date: Tue, 11 Feb 2025 16:27:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 39/43] xfs: support write life time based data placement
Message-ID: <20250212002726.GG21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-40-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-40-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:55AM +0100, Christoph Hellwig wrote:
> From: Hans Holmberg <hans.holmberg@wdc.com>
> 
> Add a file write life time data placement allocation scheme that aims to
> minimize fragmentation and thereby to do two things:
> 
>  a) separate file data to different zones when possible.
>  b) colocate file data of similar life times when feasible.
> 
> To get best results, average file sizes should align with the zone
> capacity that is reported through the XFS_IOC_FSGEOMETRY ioctl.
> 
> For RocksDB using leveled compaction, the lifetime hints can improve
> throughput for overwrite workloads at 80% file system utilization by
> ~10%.

The code changes look mostly ok, but how does it do at 40% utilization?
99%?  Does it reduce the amount of relocation work that the gc must do?

--D

> Lifetime hints can be disabled using the nolifetime mount option.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_mount.h      |   2 +
>  fs/xfs/xfs_super.c      |  15 +++++
>  fs/xfs/xfs_zone_alloc.c | 130 +++++++++++++++++++++++++++++++++++-----
>  fs/xfs/xfs_zone_gc.c    |   4 +-
>  fs/xfs/xfs_zone_priv.h  |   9 ++-
>  5 files changed, 141 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 6c5757f6e4ef..7c7fd94375c1 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -363,6 +363,7 @@ typedef struct xfs_mount {
>  #define XFS_FEAT_ZONED		(1ULL << 29)	/* zoned RT device */
>  
>  /* Mount features */
> +#define XFS_FEAT_NOLIFETIME	(1ULL << 47)	/* disable lifetime hints */
>  #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
>  #define XFS_FEAT_NOALIGN	(1ULL << 49)	/* ignore alignment */
>  #define XFS_FEAT_ALLOCSIZE	(1ULL << 50)	/* user specified allocation size */
> @@ -418,6 +419,7 @@ __XFS_HAS_FEAT(large_extent_counts, NREXT64)
>  __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
>  __XFS_HAS_FEAT(metadir, METADIR)
>  __XFS_HAS_FEAT(zoned, ZONED)
> +__XFS_HAS_FEAT(nolifetime, NOLIFETIME)
>  
>  static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
>  {
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b59d7349dbd2..01166e519413 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -111,6 +111,7 @@ enum {
>  	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
>  	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
>  	Opt_discard, Opt_nodiscard, Opt_dax, Opt_dax_enum, Opt_max_open_zones,
> +	Opt_lifetime, Opt_nolifetime,
>  };
>  
>  static const struct fs_parameter_spec xfs_fs_parameters[] = {
> @@ -156,6 +157,8 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
>  	fsparam_flag("dax",		Opt_dax),
>  	fsparam_enum("dax",		Opt_dax_enum, dax_param_enums),
>  	fsparam_u32("max_open_zones",	Opt_max_open_zones),
> +	fsparam_flag("lifetime",	Opt_lifetime),
> +	fsparam_flag("nolifetime",	Opt_nolifetime),
>  	{}
>  };
>  
> @@ -184,6 +187,7 @@ xfs_fs_show_options(
>  		{ XFS_FEAT_LARGE_IOSIZE,	",largeio" },
>  		{ XFS_FEAT_DAX_ALWAYS,		",dax=always" },
>  		{ XFS_FEAT_DAX_NEVER,		",dax=never" },
> +		{ XFS_FEAT_NOLIFETIME,		",nolifetime" },
>  		{ 0, NULL }
>  	};
>  	struct xfs_mount	*mp = XFS_M(root->d_sb);
> @@ -1091,6 +1095,11 @@ xfs_finish_flags(
>  "max_open_zones mount option only supported on zoned file systems.");
>  			return -EINVAL;
>  		}
> +		if (mp->m_features & XFS_FEAT_NOLIFETIME) {
> +			xfs_warn(mp,
> +"nolifetime mount option only supported on zoned file systems.");
> +			return -EINVAL;
> +		}
>  	}
>  
>  	return 0;
> @@ -1477,6 +1486,12 @@ xfs_fs_parse_param(
>  	case Opt_max_open_zones:
>  		parsing_mp->m_max_open_zones = result.uint_32;
>  		return 0;
> +	case Opt_lifetime:
> +		parsing_mp->m_features &= ~XFS_FEAT_NOLIFETIME;
> +		return 0;
> +	case Opt_nolifetime:
> +		parsing_mp->m_features |= XFS_FEAT_NOLIFETIME;
> +		return 0;
>  	default:
>  		xfs_warn(parsing_mp, "unknown mount option [%s].", param->key);
>  		return -EINVAL;
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index ab3f46dbbc01..e8ff9788036e 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -423,6 +423,7 @@ static struct xfs_open_zone *
>  xfs_init_open_zone(
>  	struct xfs_rtgroup	*rtg,
>  	xfs_rgblock_t		write_pointer,
> +	enum rw_hint		write_hint,
>  	bool			is_gc)
>  {
>  	struct xfs_open_zone	*oz;
> @@ -433,6 +434,7 @@ xfs_init_open_zone(
>  	oz->oz_rtg = rtg;
>  	oz->oz_write_pointer = write_pointer;
>  	oz->oz_written = write_pointer;
> +	oz->oz_write_hint = write_hint;
>  	oz->oz_is_gc = is_gc;
>  
>  	/*
> @@ -452,6 +454,7 @@ xfs_init_open_zone(
>  struct xfs_open_zone *
>  xfs_open_zone(
>  	struct xfs_mount	*mp,
> +	enum rw_hint		write_hint,
>  	bool			is_gc)
>  {
>  	struct xfs_zone_info	*zi = mp->m_zone_info;
> @@ -464,12 +467,13 @@ xfs_open_zone(
>  		return NULL;
>  
>  	set_current_state(TASK_RUNNING);
> -	return xfs_init_open_zone(to_rtg(xg), 0, is_gc);
> +	return xfs_init_open_zone(to_rtg(xg), 0, write_hint, is_gc);
>  }
>  
>  static struct xfs_open_zone *
>  xfs_try_open_zone(
> -	struct xfs_mount	*mp)
> +	struct xfs_mount	*mp,
> +	enum rw_hint		write_hint)
>  {
>  	struct xfs_zone_info	*zi = mp->m_zone_info;
>  	struct xfs_open_zone	*oz;
> @@ -486,7 +490,7 @@ xfs_try_open_zone(
>  	 */
>  	zi->zi_nr_open_zones++;
>  	spin_unlock(&zi->zi_open_zones_lock);
> -	oz = xfs_open_zone(mp, false);
> +	oz = xfs_open_zone(mp, write_hint, false);
>  	spin_lock(&zi->zi_open_zones_lock);
>  	if (!oz) {
>  		zi->zi_nr_open_zones--;
> @@ -512,16 +516,78 @@ xfs_try_open_zone(
>  	return oz;
>  }
>  
> +/*
> + * For data with short or medium lifetime, try to colocated it into an
> + * already open zone with a matching temperature.
> + */
> +static bool
> +xfs_colocate_eagerly(
> +	enum rw_hint		file_hint)
> +{
> +	switch (file_hint) {
> +	case WRITE_LIFE_MEDIUM:
> +	case WRITE_LIFE_SHORT:
> +	case WRITE_LIFE_NONE:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static bool
> +xfs_good_hint_match(
> +	struct xfs_open_zone	*oz,
> +	enum rw_hint		file_hint)
> +{
> +	switch (oz->oz_write_hint) {
> +	case WRITE_LIFE_LONG:
> +	case WRITE_LIFE_EXTREME:
> +		/* colocate long and extreme */
> +		if (file_hint == WRITE_LIFE_LONG ||
> +		    file_hint == WRITE_LIFE_EXTREME)
> +			return true;
> +		break;
> +	case WRITE_LIFE_MEDIUM:
> +		/* colocate medium with medium */
> +		if (file_hint == WRITE_LIFE_MEDIUM)
> +			return true;
> +		break;
> +	case WRITE_LIFE_SHORT:
> +	case WRITE_LIFE_NONE:
> +	case WRITE_LIFE_NOT_SET:
> +		/* colocate short and none */
> +		if (file_hint <= WRITE_LIFE_SHORT)
> +			return true;
> +		break;
> +	}
> +	return false;
> +}
> +
>  static bool
>  xfs_try_use_zone(
>  	struct xfs_zone_info	*zi,
> -	struct xfs_open_zone	*oz)
> +	enum rw_hint		file_hint,
> +	struct xfs_open_zone	*oz,
> +	bool			lowspace)
>  {
>  	if (oz->oz_write_pointer == rtg_blocks(oz->oz_rtg))
>  		return false;
> +	if (!lowspace && !xfs_good_hint_match(oz, file_hint))
> +		return false;
>  	if (!atomic_inc_not_zero(&oz->oz_ref))
>  		return false;
>  
> +	/*
> +	 * If we have a hint set for the data, use that for the zone even if
> +	 * some data was written already without any hint set, but don't change
> +	 * the temperature after that as that would make little sense without
> +	 * tracking per-temperature class written block counts, which is
> +	 * probably overkill anyway.
> +	 */
> +	if (file_hint != WRITE_LIFE_NOT_SET &&
> +	    oz->oz_write_hint == WRITE_LIFE_NOT_SET)
> +		oz->oz_write_hint = file_hint;
> +
>  	/*
>  	 * If we couldn't match by inode or life time we just pick the first
>  	 * zone with enough space above.  For that we want the least busy zone
> @@ -536,14 +602,16 @@ xfs_try_use_zone(
>  
>  static struct xfs_open_zone *
>  xfs_select_open_zone_lru(
> -	struct xfs_zone_info	*zi)
> +	struct xfs_zone_info	*zi,
> +	enum rw_hint		file_hint,
> +	bool			lowspace)
>  {
>  	struct xfs_open_zone	*oz;
>  
>  	lockdep_assert_held(&zi->zi_open_zones_lock);
>  
>  	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry)
> -		if (xfs_try_use_zone(zi, oz))
> +		if (xfs_try_use_zone(zi, file_hint, oz, lowspace))
>  			return oz;
>  
>  	cond_resched_lock(&zi->zi_open_zones_lock);
> @@ -552,20 +620,28 @@ xfs_select_open_zone_lru(
>  
>  static struct xfs_open_zone *
>  xfs_select_open_zone_mru(
> -	struct xfs_zone_info	*zi)
> +	struct xfs_zone_info	*zi,
> +	enum rw_hint		file_hint)
>  {
>  	struct xfs_open_zone	*oz;
>  
>  	lockdep_assert_held(&zi->zi_open_zones_lock);
>  
>  	list_for_each_entry_reverse(oz, &zi->zi_open_zones, oz_entry)
> -		if (xfs_try_use_zone(zi, oz))
> +		if (xfs_try_use_zone(zi, file_hint, oz, false))
>  			return oz;
>  
>  	cond_resched_lock(&zi->zi_open_zones_lock);
>  	return NULL;
>  }
>  
> +static inline enum rw_hint xfs_inode_write_hint(struct xfs_inode *ip)
> +{
> +	if (xfs_has_nolifetime(ip->i_mount))
> +		return WRITE_LIFE_NOT_SET;
> +	return VFS_I(ip)->i_write_hint;
> +}
> +
>  /*
>   * Try to pack inodes that are written back after they were closed tight instead
>   * of trying to open new zones for them or spread them to the least recently
> @@ -589,6 +665,7 @@ static inline bool xfs_zoned_pack_tight(struct xfs_inode *ip)
>  static struct xfs_open_zone *
>  xfs_select_zone_nowait(
>  	struct xfs_mount	*mp,
> +	enum rw_hint		write_hint,
>  	bool			pack_tight)
>  {
>  	struct xfs_zone_info	*zi = mp->m_zone_info;
> @@ -597,20 +674,38 @@ xfs_select_zone_nowait(
>  	if (xfs_is_shutdown(mp))
>  		return NULL;
>  
> +	/*
> +	 * Try to fill up open zones with matching temperature if available.  It
> +	 * is better to try to co-locate data when this is favorable, so we can
> +	 * activate empty zones when it is statistically better to separate
> +	 * data.
> +	 */
>  	spin_lock(&zi->zi_open_zones_lock);
> -	if (pack_tight)
> -		oz = xfs_select_open_zone_mru(zi);
> +	if (xfs_colocate_eagerly(write_hint))
> +		oz = xfs_select_open_zone_lru(zi, write_hint, false);
> +	else if (pack_tight)
> +		oz = xfs_select_open_zone_mru(zi, write_hint);
>  	if (oz)
>  		goto out_unlock;
>  
>  	/*
>  	 * See if we can open a new zone and use that.
>  	 */
> -	oz = xfs_try_open_zone(mp);
> +	oz = xfs_try_open_zone(mp, write_hint);
>  	if (oz)
>  		goto out_unlock;
>  
> -	oz = xfs_select_open_zone_lru(zi);
> +	/*
> +	 * Try to colocate cold data with other cold data if we failed to open a
> +	 * new zone for it.
> +	 */
> +	if (write_hint != WRITE_LIFE_NOT_SET &&
> +	    !xfs_colocate_eagerly(write_hint))
> +		oz = xfs_select_open_zone_lru(zi, write_hint, false);
> +	if (!oz)
> +		oz = xfs_select_open_zone_lru(zi, WRITE_LIFE_NOT_SET, false);
> +	if (!oz)
> +		oz = xfs_select_open_zone_lru(zi, WRITE_LIFE_NOT_SET, true);
>  out_unlock:
>  	spin_unlock(&zi->zi_open_zones_lock);
>  	return oz;
> @@ -619,19 +714,20 @@ xfs_select_zone_nowait(
>  static struct xfs_open_zone *
>  xfs_select_zone(
>  	struct xfs_mount	*mp,
> +	enum rw_hint		write_hint,
>  	bool			pack_tight)
>  {
>  	struct xfs_zone_info	*zi = mp->m_zone_info;
>  	DEFINE_WAIT		(wait);
>  	struct xfs_open_zone	*oz;
>  
> -	oz = xfs_select_zone_nowait(mp, pack_tight);
> +	oz = xfs_select_zone_nowait(mp, write_hint, pack_tight);
>  	if (oz)
>  		return oz;
>  
>  	for (;;) {
>  		prepare_to_wait(&zi->zi_zone_wait, &wait, TASK_UNINTERRUPTIBLE);
> -		oz = xfs_select_zone_nowait(mp, pack_tight);
> +		oz = xfs_select_zone_nowait(mp, write_hint, pack_tight);
>  		if (oz)
>  			break;
>  		schedule();
> @@ -709,6 +805,7 @@ xfs_zone_alloc_and_submit(
>  {
>  	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> +	enum rw_hint		write_hint = xfs_inode_write_hint(ip);
>  	bool			pack_tight = xfs_zoned_pack_tight(ip);
>  	unsigned int		alloc_len;
>  	struct iomap_ioend	*split;
> @@ -726,7 +823,7 @@ xfs_zone_alloc_and_submit(
>  		*oz = xfs_last_used_zone(ioend);
>  	if (!*oz) {
>  select_zone:
> -		*oz = xfs_select_zone(mp, pack_tight);
> +		*oz = xfs_select_zone(mp, write_hint, pack_tight);
>  		if (!*oz)
>  			goto out_error;
>  	}
> @@ -864,7 +961,8 @@ xfs_init_zone(
>  		struct xfs_open_zone *oz;
>  
>  		atomic_inc(&rtg_group(rtg)->xg_active_ref);
> -		oz = xfs_init_open_zone(rtg, write_pointer, false);
> +		oz = xfs_init_open_zone(rtg, write_pointer, WRITE_LIFE_NOT_SET,
> +				false);
>  		list_add_tail(&oz->oz_entry, &zi->zi_open_zones);
>  		zi->zi_nr_open_zones++;
>  
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 133a83b97f5f..18675466cc97 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -550,7 +550,7 @@ xfs_zone_gc_select_target(
>  
>  	ASSERT(zi->zi_nr_open_zones <=
>  		mp->m_max_open_zones - XFS_OPEN_GC_ZONES);
> -	oz = xfs_open_zone(mp, true);
> +	oz = xfs_open_zone(mp, WRITE_LIFE_NOT_SET, true);
>  	if (oz)
>  		trace_xfs_gc_zone_activate(oz->oz_rtg);
>  	spin_lock(&zi->zi_open_zones_lock);
> @@ -1120,7 +1120,7 @@ xfs_zone_gc_mount(
>  	    zi->zi_nr_open_zones == mp->m_max_open_zones)
>  		oz = xfs_zone_gc_steal_open(zi);
>  	else
> -		oz = xfs_open_zone(mp, true);
> +		oz = xfs_open_zone(mp, WRITE_LIFE_NOT_SET, true);
>  	if (!oz) {
>  		xfs_warn(mp, "unable to allocate a zone for gc");
>  		error = -EIO;
> diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
> index f6c76d751a49..ab696975a993 100644
> --- a/fs/xfs/xfs_zone_priv.h
> +++ b/fs/xfs/xfs_zone_priv.h
> @@ -26,6 +26,12 @@ struct xfs_open_zone {
>  	 */
>  	xfs_rgblock_t		oz_written;
>  
> +	/*
> +	 * Write hint (data temperature) assigned to this zone, or
> +	 * WRITE_LIFE_NOT_SET if none was set.
> +	 */
> +	enum rw_hint		oz_write_hint;
> +
>  	/*
>  	 * Is this open zone used for garbage collection?  There can only be a
>  	 * single open GC zone, which is pointed to by zi_open_gc_zone in
> @@ -100,7 +106,8 @@ struct xfs_zone_info {
>  
>  };
>  
> -struct xfs_open_zone *xfs_open_zone(struct xfs_mount *mp, bool is_gc);
> +struct xfs_open_zone *xfs_open_zone(struct xfs_mount *mp,
> +		enum rw_hint write_hint, bool is_gc);
>  
>  int xfs_zone_gc_reset_sync(struct xfs_rtgroup *rtg);
>  bool xfs_zoned_need_gc(struct xfs_mount *mp);
> -- 
> 2.45.2
> 
> 

