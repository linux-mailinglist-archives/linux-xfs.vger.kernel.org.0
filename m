Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F3058A4DB
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Aug 2022 04:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbiHECwT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 4 Aug 2022 22:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiHECwR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 22:52:17 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63E7114025
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 19:52:16 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 5335E4C1502;
        Thu,  4 Aug 2022 21:51:16 -0500 (CDT)
Message-ID: <14a18b31-2a05-9290-9b8f-26ca3eb52c38@sandeen.net>
Date:   Thu, 4 Aug 2022 21:52:14 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <165767460292.892222.8527830050022729631.stgit@magnolia>
 <165767460847.892222.16685823109350212328.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/2] xfs_repair: check filesystem geometry before allowing
 upgrades
In-Reply-To: <165767460847.892222.16685823109350212328.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/12/22 8:10 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Currently, the two V5 feature upgrades permitted by xfs_repair do not
> affect filesystem space usage, so we haven't needed to verify the
> geometry.
> 
> However, this will change once we start to allow the sysadmin to add the
> large extent count feature to existing filesystems.  Add all the
> infrastructure we need to ensure that the log will still be large
> enough, and the root inode will still be where we expect it to be after
> the upgrade.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> [david: Recompute transaction reservation values; Exit with error if upgrade fails]
> Signed-off-by: Dave Chinner <david@fromorbit.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  include/xfs_mount.h      |    1 
>  libxfs/init.c            |   24 +++++++---
>  libxfs/libxfs_api_defs.h |    3 +
>  repair/phase2.c          |  113 ++++++++++++++++++++++++++++++++++++++++++----
>  4 files changed, 124 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index ba80aa79..24b1d873 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -259,6 +259,7 @@ __XFS_UNSUPP_OPSTATE(shutdown)
>  
>  #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
>  
> +void libxfs_compute_all_maxlevels(struct xfs_mount *mp);
>  struct xfs_mount *libxfs_mount(struct xfs_mount *mp, struct xfs_sb *sb,
>  		dev_t dev, dev_t logdev, dev_t rtdev, unsigned int flags);
>  int libxfs_flush_mount(struct xfs_mount *mp);
> diff --git a/libxfs/init.c b/libxfs/init.c
> index a01a41b2..15052696 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -728,6 +728,21 @@ xfs_agbtree_compute_maxlevels(
>  	mp->m_agbtree_maxlevels = max(levels, mp->m_refc_maxlevels);
>  }
>  
> +/* Compute maximum possible height of all btrees. */
> +void
> +libxfs_compute_all_maxlevels(
> +	struct xfs_mount	*mp)
> +{
> +	xfs_alloc_compute_maxlevels(mp);
> +	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
> +	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
> +	xfs_ialloc_setup_geometry(mp);
> +	xfs_rmapbt_compute_maxlevels(mp);
> +	xfs_refcountbt_compute_maxlevels(mp);
> +
> +	xfs_agbtree_compute_maxlevels(mp);
> +}
> +
>  /*
>   * Mount structure initialization, provides a filled-in xfs_mount_t
>   * such that the numerous XFS_* macros can be used.  If dev is zero,
> @@ -772,14 +787,7 @@ libxfs_mount(
>  		mp->m_swidth = sbp->sb_width;
>  	}
>  
> -	xfs_alloc_compute_maxlevels(mp);
> -	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
> -	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
> -	xfs_ialloc_setup_geometry(mp);
> -	xfs_rmapbt_compute_maxlevels(mp);
> -	xfs_refcountbt_compute_maxlevels(mp);
> -
> -	xfs_agbtree_compute_maxlevels(mp);
> +	libxfs_compute_all_maxlevels(mp);
>  
>  	/*
>  	 * Check that the data (and log if separate) are an ok size.
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index 370ad8b3..824f2c4d 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -21,6 +21,8 @@
>  
>  #define xfs_ag_init_headers		libxfs_ag_init_headers
>  #define xfs_ag_block_count		libxfs_ag_block_count
> +#define xfs_ag_resv_init		libxfs_ag_resv_init
> +#define xfs_ag_resv_free		libxfs_ag_resv_free
>  
>  #define xfs_alloc_ag_max_usable		libxfs_alloc_ag_max_usable
>  #define xfs_allocbt_maxlevels_ondisk	libxfs_allocbt_maxlevels_ondisk
> @@ -112,6 +114,7 @@
>  #define xfs_highbit64			libxfs_highbit64
>  #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
>  #define xfs_iallocbt_maxlevels_ondisk	libxfs_iallocbt_maxlevels_ondisk
> +#define xfs_ialloc_read_agi		libxfs_ialloc_read_agi
>  #define xfs_idata_realloc		libxfs_idata_realloc
>  #define xfs_idestroy_fork		libxfs_idestroy_fork
>  #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
> diff --git a/repair/phase2.c b/repair/phase2.c
> index 13832701..70365620 100644
> --- a/repair/phase2.c
> +++ b/repair/phase2.c
> @@ -133,7 +133,8 @@ zero_log(
>  
>  static bool
>  set_inobtcount(
> -	struct xfs_mount	*mp)
> +	struct xfs_mount	*mp,
> +	struct xfs_sb		*new_sb)
>  {
>  	if (!xfs_has_crc(mp)) {
>  		printf(
> @@ -153,14 +154,15 @@ set_inobtcount(
>  	}
>  
>  	printf(_("Adding inode btree counts to filesystem.\n"));
> -	mp->m_sb.sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
> -	mp->m_sb.sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> +	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_INOBTCNT;
> +	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
>  	return true;
>  }
>  
>  static bool
>  set_bigtime(
> -	struct xfs_mount	*mp)
> +	struct xfs_mount	*mp,
> +	struct xfs_sb		*new_sb)
>  {
>  	if (!xfs_has_crc(mp)) {
>  		printf(
> @@ -174,28 +176,121 @@ set_bigtime(
>  	}
>  
>  	printf(_("Adding large timestamp support to filesystem.\n"));
> -	mp->m_sb.sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
> -					  XFS_SB_FEAT_INCOMPAT_BIGTIME);
> +	new_sb->sb_features_incompat |= (XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR |
> +					 XFS_SB_FEAT_INCOMPAT_BIGTIME);
>  	return true;
>  }
>  
> +struct check_state {
> +	struct xfs_sb		sb;
> +	uint64_t		features;
> +	bool			finobt_nores;
> +};
> +
> +static inline void
> +capture_old_state(
> +	struct check_state	*old_state,
> +	const struct xfs_mount	*mp)
> +{
> +	memcpy(&old_state->sb, &mp->m_sb, sizeof(struct xfs_sb));
> +	old_state->finobt_nores = mp->m_finobt_nores;
> +	old_state->features = mp->m_features;
> +}
> +
> +static inline void
> +restore_old_state(
> +	struct xfs_mount		*mp,
> +	const struct check_state	*old_state)
> +{
> +	memcpy(&mp->m_sb, &old_state->sb, sizeof(struct xfs_sb));
> +	mp->m_finobt_nores = old_state->finobt_nores;
> +	mp->m_features = old_state->features;
> +	libxfs_compute_all_maxlevels(mp);
> +	libxfs_trans_init(mp);
> +}
> +
> +static inline void
> +install_new_state(
> +	struct xfs_mount	*mp,
> +	struct xfs_sb		*new_sb)
> +{
> +	memcpy(&mp->m_sb, new_sb, sizeof(struct xfs_sb));
> +	mp->m_features |= libxfs_sb_version_to_features(new_sb);
> +	libxfs_compute_all_maxlevels(mp);
> +	libxfs_trans_init(mp);
> +}
> +
> +/*
> + * Make sure we can actually upgrade this (v5) filesystem without running afoul
> + * of root inode or log size requirements that would prevent us from mounting
> + * the filesystem.  If everything checks out, commit the new geometry.
> + */
> +static void
> +install_new_geometry(
> +	struct xfs_mount	*mp,
> +	struct xfs_sb		*new_sb)
> +{
> +	struct check_state	old;
> +	xfs_ino_t		rootino;
> +	int			min_logblocks;
> +
> +	capture_old_state(&old, mp);
> +	install_new_state(mp, new_sb);
> +
> +	/*
> +	 * The existing log must be large enough to satisfy the new minimum log
> +	 * size requirements.
> +	 */
> +	min_logblocks = libxfs_log_calc_minimum_size(mp);
> +	if (old.sb.sb_logblocks < min_logblocks) {
> +		printf(
> +	_("Filesystem log too small to upgrade filesystem; need %u blocks, have %u.\n"),
> +				min_logblocks, old.sb.sb_logblocks);
> +		exit(1);
> +	}
> +
> +	/*
> +	 * The root inode must be where xfs_repair will expect it to be with
> +	 * the new geometry.
> +	 */
> +	rootino = libxfs_ialloc_calc_rootino(mp, new_sb->sb_unit);
> +	if (old.sb.sb_rootino != rootino) {
> +		printf(
> +	_("Cannot upgrade filesystem, root inode (%llu) cannot be moved to %llu.\n"),
> +				(unsigned long long)old.sb.sb_rootino,
> +				(unsigned long long)rootino);
> +		exit(1);
> +	}
> +
> +	/*
> +	 * Restore the old state to get everything back to a clean state,
> +	 * upgrade the featureset one more time, and recompute the btree max
> +	 * levels for this filesystem.
> +	 */
> +	restore_old_state(mp, &old);
> +	install_new_state(mp, new_sb);
> +}
> +
>  /* Perform the user's requested upgrades on filesystem. */
>  static void
>  upgrade_filesystem(
>  	struct xfs_mount	*mp)
>  {
> +	struct xfs_sb		new_sb;
>  	struct xfs_buf		*bp;
>  	bool			dirty = false;
>  	int			error;
>  
> +	memcpy(&new_sb, &mp->m_sb, sizeof(struct xfs_sb));
> +
>  	if (add_inobtcount)
> -		dirty |= set_inobtcount(mp);
> +		dirty |= set_inobtcount(mp, &new_sb);
>  	if (add_bigtime)
> -		dirty |= set_bigtime(mp);
> +		dirty |= set_bigtime(mp, &new_sb);
>  	if (!dirty)
>  		return;
>  
> -	mp->m_features |= libxfs_sb_version_to_features(&mp->m_sb);
> +	install_new_geometry(mp, &new_sb);
>  	if (no_modify)
>  		return;
>  
> 
