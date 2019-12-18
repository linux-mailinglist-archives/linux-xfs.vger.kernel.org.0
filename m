Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 240EC124733
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Dec 2019 13:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfLRMro (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Dec 2019 07:47:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27558 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726545AbfLRMro (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Dec 2019 07:47:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576673262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZEu66F6w5dpXGSL0BZQSdRp14dCfPN3gdYpiq7Ts2k8=;
        b=WCzx2luY3seLuYEZw51YZQFk1L/hA+3oyF1o4QwT3kQv8ixR5VzSTe73OOSBYj4FlPdxOA
        2zxPKouLhW5zh+18E7pDVKKorOE6uWg4rlu2iVyDNehLQH6Z+ZoVtWdETKsHp9y3C2FZFB
        fv+rmfq+wmag0vb39rl2EV6S5X7XMMY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-8FnC1d7BO1Weldry2LrBMw-1; Wed, 18 Dec 2019 07:47:38 -0500
X-MC-Unique: 8FnC1d7BO1Weldry2LrBMw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6C63DB6B;
        Wed, 18 Dec 2019 12:47:36 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32EDF26DE0;
        Wed, 18 Dec 2019 12:47:36 +0000 (UTC)
Date:   Wed, 18 Dec 2019 07:47:34 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Alex Lyakas <alex@zadara.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4] xfs: don't commit sunit/swidth updates to disk if
 that would cause repair failures
Message-ID: <20191218124734.GC63809@bfoster>
References: <20191218041729.GJ12765@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218041729.GJ12765@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 17, 2019 at 08:17:29PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Alex Lyakas reported[1] that mounting an xfs filesystem with new sunit
> and swidth values could cause xfs_repair to fail loudly.  The problem
> here is that repair calculates the where mkfs should have allocated the
> root inode, based on the superblock geometry.  The allocation decisions
> depend on sunit, which means that we really can't go updating sunit if
> it would lead to a subsequent repair failure on an otherwise correct
> filesystem.
> 
> Port from xfs_repair some code that computes the location of the root
> inode and teach mount to skip the ondisk update if it would cause
> problems for repair.  Along the way we'll update the documentation,
> provide a function for computing the minimum AGFL size instead of
> open-coding it, and cut down some indenting in the mount code.
> 
> Note that we allow the mount to proceed (and new allocations will
> reflect this new geometry) because we've never screened this kind of
> thing before.  We'll have to wait for a new future incompat feature to
> enforce correct behavior, alas.
> 
> Note that the geometry reporting always uses the superblock values, not
> the incore ones, so that is what xfs_info and xfs_growfs will report.
> 
> [1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/T/#m00f9594b511e076e2fcdd489d78bc30216d72a7d
> 
> Reported-by: Alex Lyakas <alex@zadara.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v4: fix unit conversion bug that bfoster pointed out
> v3: actually check the alignment check function return value
> v2: v2: refactor the agfl length calculations, clarify the fsgeometry ioctl
> behavior, fix a bunch of the comments and make it clearer how we compute
> the rootino location
> ---

Looks reasonable at a glance, but this patch is growing more and more
refactoring it seems. Can we split out the refactoring bits into
independent patches? I think the xfs_alloc_min_freelist() fixup, split
out of the new dalign validation and move of the update_alignment() call
could all be independent patches with independent explanation, for
example.

Brian

>  fs/xfs/libxfs/xfs_alloc.c  |   18 +++--
>  fs/xfs/libxfs/xfs_ialloc.c |   70 ++++++++++++++++++
>  fs/xfs/libxfs/xfs_ialloc.h |    1 
>  fs/xfs/xfs_mount.c         |  171 +++++++++++++++++++++++++++++++-------------
>  fs/xfs/xfs_trace.h         |   21 +++++
>  5 files changed, 224 insertions(+), 57 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index c284e10af491..fc93fd88ec89 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2248,24 +2248,32 @@ xfs_alloc_longest_free_extent(
>  	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
>  }
>  
> +/*
> + * Compute the minimum length of the AGFL in the given AG.  If @pag is NULL,
> + * return the largest possible minimum length.
> + */
>  unsigned int
>  xfs_alloc_min_freelist(
>  	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag)
>  {
> +	/* AG btrees have at least 1 level. */
> +	static const uint8_t	fake_levels[XFS_BTNUM_AGF] = {1, 1, 1};
> +	const uint8_t		*levels = pag ? pag->pagf_levels : fake_levels;
>  	unsigned int		min_free;
>  
> +	ASSERT(mp->m_ag_maxlevels > 0);
> +
>  	/* space needed by-bno freespace btree */
> -	min_free = min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_BNOi] + 1,
> +	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
>  				       mp->m_ag_maxlevels);
>  	/* space needed by-size freespace btree */
> -	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_CNTi] + 1,
> +	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
>  				       mp->m_ag_maxlevels);
>  	/* space needed reverse mapping used space btree */
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> -		min_free += min_t(unsigned int,
> -				  pag->pagf_levels[XFS_BTNUM_RMAPi] + 1,
> -				  mp->m_rmap_maxlevels);
> +		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
> +						mp->m_rmap_maxlevels);
>  
>  	return min_free;
>  }
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 988cde7744e6..eeec7c8d93fd 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2909,3 +2909,73 @@ xfs_ialloc_setup_geometry(
>  	else
>  		igeo->ialloc_align = 0;
>  }
> +
> +/*
> + * Compute the location of the root directory inode that is laid out by mkfs.
> + * The @sunit parameter will be copied from the superblock if it is negative.
> + */
> +xfs_ino_t
> +xfs_ialloc_calc_rootino(
> +	struct xfs_mount	*mp,
> +	int			sunit)
> +{
> +	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> +	xfs_agblock_t		first_bno;
> +
> +	if (sunit < 0)
> +		sunit = mp->m_sb.sb_unit;
> +
> +	/*
> +	 * Pre-calculate the geometry of AG 0.  We know what it looks like
> +	 * because libxfs knows how to create allocation groups now.
> +	 *
> +	 * first_bno is the first block in which mkfs could possibly have
> +	 * allocated the root directory inode, once we factor in the metadata
> +	 * that mkfs formats before it.  Namely, the four AG headers...
> +	 */
> +	first_bno = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
> +
> +	/* ...the two free space btree roots... */
> +	first_bno += 2;
> +
> +	/* ...the inode btree root... */
> +	first_bno += 1;
> +
> +	/* ...the initial AGFL... */
> +	first_bno += xfs_alloc_min_freelist(mp, NULL);
> +
> +	/* ...the free inode btree root... */
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> +		first_bno++;
> +
> +	/* ...the reverse mapping btree root... */
> +	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		first_bno++;
> +
> +	/* ...the reference count btree... */
> +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> +		first_bno++;
> +
> +	/*
> +	 * ...and the log, if it is allocated in the first allocation group.
> +	 *
> +	 * This can happen with filesystems that only have a single
> +	 * allocation group, or very odd geometries created by old mkfs
> +	 * versions on very small filesystems.
> +	 */
> +	if (mp->m_sb.sb_logstart &&
> +	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0)
> +		 first_bno += mp->m_sb.sb_logblocks;
> +
> +	/*
> +	 * Now round first_bno up to whatever allocation alignment is given
> +	 * by the filesystem or was passed in.
> +	 */
> +	if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0)
> +		first_bno = roundup(first_bno, sunit);
> +	else if (xfs_sb_version_hasalign(&mp->m_sb) &&
> +			mp->m_sb.sb_inoalignmt > 1)
> +		first_bno = roundup(first_bno, mp->m_sb.sb_inoalignmt);
> +
> +	return XFS_AGINO_TO_INO(mp, 0, XFS_AGB_TO_AGINO(mp, first_bno));
> +}
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 323592d563d5..72b3468b97b1 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -152,5 +152,6 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
>  
>  int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
>  void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
> +xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, int sunit);
>  
>  #endif	/* __XFS_IALLOC_H__ */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index fca65109cf24..7f94c6b20920 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -31,7 +31,7 @@
>  #include "xfs_reflink.h"
>  #include "xfs_extent_busy.h"
>  #include "xfs_health.h"
> -
> +#include "xfs_trace.h"
>  
>  static DEFINE_MUTEX(xfs_uuid_table_mutex);
>  static int xfs_uuid_table_size;
> @@ -360,66 +360,122 @@ xfs_readsb(
>  }
>  
>  /*
> - * Update alignment values based on mount options and sb values
> + * If the sunit/swidth change would move the precomputed root inode value, we
> + * must reject the ondisk change because repair will stumble over that.
> + * However, we allow the mount to proceed because we never rejected this
> + * combination before.  Returns true to update the sb, false otherwise.
> + */
> +static inline int
> +xfs_check_new_dalign(
> +	struct xfs_mount	*mp,
> +	int			new_dalign,
> +	bool			*update_sb)
> +{
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +	xfs_ino_t		calc_ino;
> +
> +	calc_ino = xfs_ialloc_calc_rootino(mp, new_dalign);
> +	trace_xfs_check_new_dalign(mp, new_dalign, calc_ino);
> +
> +	if (sbp->sb_rootino == calc_ino) {
> +		*update_sb = true;
> +		return 0;
> +	}
> +
> +	xfs_warn(mp,
> +"Cannot change stripe alignment; would require moving root inode.");
> +
> +	/*
> +	 * XXX: Next time we add a new incompat feature, this should start
> +	 * returning -EINVAL to fail the mount.  Until then, spit out a warning
> +	 * that we're ignoring the administrator's instructions.
> +	 */
> +	xfs_warn(mp, "Skipping superblock stripe alignment update.");
> +	*update_sb = false;
> +	return 0;
> +}
> +
> +/*
> + * If we were provided with new sunit/swidth values as mount options, make sure
> + * that they pass basic alignment and superblock feature checks, and convert
> + * them into the same units (FSB) that everything else expects.  This step
> + * /must/ be done before computing the inode geometry.
>   */
>  STATIC int
> -xfs_update_alignment(xfs_mount_t *mp)
> +xfs_validate_new_dalign(
> +	struct xfs_mount	*mp)
>  {
> -	xfs_sb_t	*sbp = &(mp->m_sb);
> +	if (mp->m_dalign == 0)
> +		return 0;
>  
> -	if (mp->m_dalign) {
> +	/*
> +	 * If stripe unit and stripe width are not multiples
> +	 * of the fs blocksize turn off alignment.
> +	 */
> +	if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
> +	    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
> +		xfs_warn(mp,
> +	"alignment check failed: sunit/swidth vs. blocksize(%d)",
> +			mp->m_sb.sb_blocksize);
> +		return -EINVAL;
> +	} else {
>  		/*
> -		 * If stripe unit and stripe width are not multiples
> -		 * of the fs blocksize turn off alignment.
> +		 * Convert the stripe unit and width to FSBs.
>  		 */
> -		if ((BBTOB(mp->m_dalign) & mp->m_blockmask) ||
> -		    (BBTOB(mp->m_swidth) & mp->m_blockmask)) {
> +		mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
> +		if (mp->m_dalign && (mp->m_sb.sb_agblocks % mp->m_dalign)) {
>  			xfs_warn(mp,
> -		"alignment check failed: sunit/swidth vs. blocksize(%d)",
> -				sbp->sb_blocksize);
> +		"alignment check failed: sunit/swidth vs. agsize(%d)",
> +				 mp->m_sb.sb_agblocks);
>  			return -EINVAL;
> -		} else {
> -			/*
> -			 * Convert the stripe unit and width to FSBs.
> -			 */
> -			mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
> -			if (mp->m_dalign && (sbp->sb_agblocks % mp->m_dalign)) {
> -				xfs_warn(mp,
> -			"alignment check failed: sunit/swidth vs. agsize(%d)",
> -					 sbp->sb_agblocks);
> -				return -EINVAL;
> -			} else if (mp->m_dalign) {
> -				mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
> -			} else {
> -				xfs_warn(mp,
> -			"alignment check failed: sunit(%d) less than bsize(%d)",
> -					 mp->m_dalign, sbp->sb_blocksize);
> -				return -EINVAL;
> -			}
> -		}
> -
> -		/*
> -		 * Update superblock with new values
> -		 * and log changes
> -		 */
> -		if (xfs_sb_version_hasdalign(sbp)) {
> -			if (sbp->sb_unit != mp->m_dalign) {
> -				sbp->sb_unit = mp->m_dalign;
> -				mp->m_update_sb = true;
> -			}
> -			if (sbp->sb_width != mp->m_swidth) {
> -				sbp->sb_width = mp->m_swidth;
> -				mp->m_update_sb = true;
> -			}
> +		} else if (mp->m_dalign) {
> +			mp->m_swidth = XFS_BB_TO_FSBT(mp, mp->m_swidth);
>  		} else {
>  			xfs_warn(mp,
> -	"cannot change alignment: superblock does not support data alignment");
> +		"alignment check failed: sunit(%d) less than bsize(%d)",
> +				 mp->m_dalign, mp->m_sb.sb_blocksize);
>  			return -EINVAL;
>  		}
> +	}
> +
> +	/* Update superblock with new values and log changes. */
> +	if (!xfs_sb_version_hasdalign(&mp->m_sb)) {
> +		xfs_warn(mp,
> +"cannot change alignment: superblock does not support data alignment");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Update alignment values based on mount options and sb values
> + */
> +STATIC int
> +xfs_update_alignment(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +
> +	if (mp->m_dalign) {
> +		bool		update_sb;
> +		int		error;
> +
> +		if (sbp->sb_unit == mp->m_dalign &&
> +		    sbp->sb_width == mp->m_swidth)
> +			return 0;
> +
> +		error = xfs_check_new_dalign(mp, mp->m_dalign, &update_sb);
> +		if (error || !update_sb)
> +			return error;
> +
> +		sbp->sb_unit = mp->m_dalign;
> +		sbp->sb_width = mp->m_swidth;
> +		mp->m_update_sb = true;
>  	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
>  		    xfs_sb_version_hasdalign(&mp->m_sb)) {
> -			mp->m_dalign = sbp->sb_unit;
> -			mp->m_swidth = sbp->sb_width;
> +		mp->m_dalign = sbp->sb_unit;
> +		mp->m_swidth = sbp->sb_width;
>  	}
>  
>  	return 0;
> @@ -648,12 +704,12 @@ xfs_mountfs(
>  	}
>  
>  	/*
> -	 * Check if sb_agblocks is aligned at stripe boundary
> -	 * If sb_agblocks is NOT aligned turn off m_dalign since
> -	 * allocator alignment is within an ag, therefore ag has
> -	 * to be aligned at stripe boundary.
> +	 * If we were given new sunit/swidth options, do some basic validation
> +	 * checks and convert the incore dalign and swidth values to the
> +	 * same units (FSB) that everything else uses.  This /must/ happen
> +	 * before computing the inode geometry.
>  	 */
> -	error = xfs_update_alignment(mp);
> +	error = xfs_validate_new_dalign(mp);
>  	if (error)
>  		goto out;
>  
> @@ -664,6 +720,17 @@ xfs_mountfs(
>  	xfs_rmapbt_compute_maxlevels(mp);
>  	xfs_refcountbt_compute_maxlevels(mp);
>  
> +	/*
> +	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
> +	 * is NOT aligned turn off m_dalign since allocator alignment is within
> +	 * an ag, therefore ag has to be aligned at stripe boundary.  Note that
> +	 * we must compute the free space and rmap btree geometry before doing
> +	 * this.
> +	 */
> +	error = xfs_update_alignment(mp);
> +	if (error)
> +		goto out;
> +
>  	/* enable fail_at_unmount as default */
>  	mp->m_fail_unmount = true;
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index c13bb3655e48..a86be7f807ee 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3573,6 +3573,27 @@ DEFINE_KMEM_EVENT(kmem_alloc_large);
>  DEFINE_KMEM_EVENT(kmem_realloc);
>  DEFINE_KMEM_EVENT(kmem_zone_alloc);
>  
> +TRACE_EVENT(xfs_check_new_dalign,
> +	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
> +	TP_ARGS(mp, new_dalign, calc_rootino),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(int, new_dalign)
> +		__field(xfs_ino_t, sb_rootino)
> +		__field(xfs_ino_t, calc_rootino)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->new_dalign = new_dalign;
> +		__entry->sb_rootino = mp->m_sb.sb_rootino;
> +		__entry->calc_rootino = calc_rootino;
> +	),
> +	TP_printk("dev %d:%d new_dalign %d sb_rootino %llu calc_rootino %llu",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->new_dalign, __entry->sb_rootino,
> +		  __entry->calc_rootino)
> +)
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 

