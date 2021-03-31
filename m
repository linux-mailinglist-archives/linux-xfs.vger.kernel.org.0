Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F6734F090
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Mar 2021 20:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhC3SK3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Mar 2021 14:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232658AbhC3SKD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 14:10:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55FFB619BD;
        Tue, 30 Mar 2021 18:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617127803;
        bh=yjbpuWFfPTDRdeEnoNZoJitNQIyApcyILXQ3vvNc1DI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DAZoyfi0EPHjC5wE6pKi5OZHNLbNrSeWM50gZA5HDcTDBek74old14hslKbqW5NMA
         iEpNtQHqIT5LrQg2JzYG40COUTLkMZlEIO5UZc/1u8+UPV+nADla7YWXIhxVywe48s
         iAnExDVHmLq8OKtmmuqq/e4zAVuuBPWzeJG3Vy74pE4/0jtGYxDR+yUsx8j4RlqsyS
         XNbYIxRtcH5RKxJHXk/raA7Jlb71Cjpzz7VbThqtnTA3B7BUc6ucMYKPq0uKmO71AK
         Hh+CigHbhbU5LZT1MIo/HD8sAEyKlBuFAvOSSol0fnsRFcHgxTuRico8szjnX+/nH+
         j/J522ptwzA4Q==
Date:   Tue, 30 Mar 2021 11:10:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: precalculate default inode attribute offset
Message-ID: <20210330181002.GT4090233@magnolia>
References: <20210330053059.1339949-1-david@fromorbit.com>
 <20210330053059.1339949-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330053059.1339949-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 30, 2021 at 04:30:59PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Default attr fork offset is based on inode size, so is a fixed
> geometry parameter of the inode. Move it to the xfs_ino_geometry
> structure and stop calculating it on every call to
> xfs_default_attroffset().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c   | 21 ++++++++++-----------
>  fs/xfs/libxfs/xfs_bmap.h   |  1 +
>  fs/xfs/libxfs/xfs_shared.h |  4 ++++
>  fs/xfs/xfs_mount.c         | 14 +++++++++++++-
>  4 files changed, 28 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 16c8730c140f..7930f11e4c54 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -94,6 +94,15 @@ xfs_bmap_compute_maxlevels(
>  	mp->m_bm_maxlevels[whichfork] = level;
>  }
>  
> +unsigned int
> +xfs_bmap_compute_attr_offset(
> +	struct xfs_mount	*mp)
> +{
> +	if (mp->m_sb.sb_inodesize == 256)
> +		return XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
> +	return XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
> +}
> +
>  STATIC int				/* error */
>  xfs_bmbt_lookup_eq(
>  	struct xfs_btree_cur	*cur,
> @@ -192,19 +201,9 @@ uint
>  xfs_default_attroffset(
>  	struct xfs_inode	*ip)
>  {
> -	struct xfs_mount	*mp = ip->i_mount;
> -	uint			offset;
> -
>  	if (ip->i_df.if_format == XFS_DINODE_FMT_DEV)
>  		return roundup(sizeof(xfs_dev_t), 8);
> -
> -	if (mp->m_sb.sb_inodesize == 256)
> -		offset = XFS_LITINO(mp) - XFS_BMDR_SPACE_CALC(MINABTPTRS);
> -	else
> -		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
> -
> -	ASSERT(offset < XFS_LITINO(mp));
> -	return offset;
> +	return M_IGEO(ip->i_mount)->attr_fork_offset;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index 6747e97a7949..a49df4092c30 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -185,6 +185,7 @@ static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
>  
>  void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
>  		xfs_filblks_t len);
> +unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
>  int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
>  int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
>  void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 8c61a461bf7b..782fdd08f759 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -176,8 +176,12 @@ struct xfs_ino_geometry {
>  
>  	unsigned int	agino_log;	/* #bits for agino in inum */
>  
> +	/* precomputed default inode attribute fork offset */
> +	unsigned int	attr_fork_offset;
> +
>  	/* precomputed value for di_flags2 */
>  	uint64_t	new_diflags2;
> +
>  };
>  
>  #endif /* __XFS_SHARED_H__ */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 1c97b155a8ee..cb1e2c4702c3 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -675,6 +675,18 @@ xfs_unmount_flush_inodes(
>  	xfs_health_unmount(mp);
>  }
>  
> +static void
> +xfs_mount_setup_inode_geom(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_ino_geometry *igeo = M_IGEO(mp);
> +
> +	igeo->attr_fork_offset = xfs_bmap_compute_attr_offset(mp);
> +	ASSERT(igeo->attr_fork_offset < XFS_LITINO(mp));

Why not put these statements at the bottom of xfs_ialloc_setup_geometry
and avoid creating an extra function?

--D

> +
> +	xfs_ialloc_setup_geometry(mp);
> +}
> +
>  /*
>   * This function does the following on an initial mount of a file system:
>   *	- reads the superblock from disk and init the mount struct
> @@ -758,7 +770,7 @@ xfs_mountfs(
>  	xfs_alloc_compute_maxlevels(mp);
>  	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
>  	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
> -	xfs_ialloc_setup_geometry(mp);
> +	xfs_mount_setup_inode_geom(mp);
>  	xfs_rmapbt_compute_maxlevels(mp);
>  	xfs_refcountbt_compute_maxlevels(mp);
>  
> -- 
> 2.31.0
> 
