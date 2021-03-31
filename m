Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49130348081
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Mar 2021 19:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbhCXS3j (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Mar 2021 14:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237338AbhCXS3L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:29:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2C42619F8;
        Wed, 24 Mar 2021 18:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616610550;
        bh=9tX1R6muImPKmy+cfRO+XJmLUfHwb1+czt+m4MNrfSo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hin0sbTKsyyTiVYCeTQEzrZo6fGljKqE7oAbVzVX26A86PCCp3A62r0uuAKPB6TVO
         G7bTopJrglmztbASNf3oHv5PkM/gbGDMvDvRReFR2/n/yhs3hczBwzMeojWZXt6MVo
         +bAXVNPLVcFN1a6wgezTHkbItAzoLpxrCjULczNyzouG0nyygZffrfWakmwInAP+xX
         52Hxckk8Ps8GtPR7iHpERJvYbmrZrFQaBqy2ZLZFQSzSzcSJvlaJSGPklPTHiGcIJM
         gGtxJ8iAkLWJgbglZPGs9PzF0zwa2YKMEp9FmXHh0jTX+6Bvdt77jO5vTH5sed/RJ9
         q/KQ7KjWHA6Kg==
Date:   Wed, 24 Mar 2021 11:29:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/18] xfs: move the di_extsize field to struct xfs_inode
Message-ID: <20210324182909.GI22100@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324142129.1011766-11-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:21:21PM +0100, Christoph Hellwig wrote:
> In preparation of removing the historic icinode struct, move the extsize
> field into the containing xfs_inode structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yeah, looks reasonable to me.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c      |  2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c |  4 ++--
>  fs/xfs/libxfs/xfs_inode_buf.h |  1 -
>  fs/xfs/xfs_inode.c            | 10 +++++-----
>  fs/xfs/xfs_inode.h            |  1 +
>  fs/xfs/xfs_inode_item.c       |  2 +-
>  fs/xfs/xfs_ioctl.c            | 10 +++++-----
>  fs/xfs/xfs_itable.c           |  2 +-
>  8 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 20c413a9b22ca9..8d4947ffcd4981 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -2938,7 +2938,7 @@ xfs_bmap_add_extent_hole_real(
>   */
>  
>  /*
> - * Adjust the size of the new extent based on di_extsize and rt extsize.
> + * Adjust the size of the new extent based on i_extsize and rt extsize.
>   */
>  int
>  xfs_bmap_extsize_align(
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index b8c8ebf38d3f46..fa21fb84c2d232 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -228,7 +228,7 @@ xfs_inode_from_disk(
>  
>  	ip->i_disk_size = be64_to_cpu(from->di_size);
>  	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
> -	to->di_extsize = be32_to_cpu(from->di_extsize);
> +	ip->i_extsize = be32_to_cpu(from->di_extsize);
>  	to->di_forkoff = from->di_forkoff;
>  	to->di_flags	= be16_to_cpu(from->di_flags);
>  
> @@ -307,7 +307,7 @@ xfs_inode_to_disk(
>  
>  	to->di_size = cpu_to_be64(ip->i_disk_size);
>  	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
> -	to->di_extsize = cpu_to_be32(from->di_extsize);
> +	to->di_extsize = cpu_to_be32(ip->i_extsize);
>  	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
>  	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
>  	to->di_forkoff = from->di_forkoff;
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index f4e1a9010b0a47..6bc78856373e31 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -17,7 +17,6 @@ struct xfs_dinode;
>   */
>  struct xfs_icdinode {
>  	uint16_t	di_flushiter;	/* incremented on flush */
> -	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
>  	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c478b85a916f7b..ccd179900f21cf 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -60,8 +60,8 @@ xfs_get_extsz_hint(
>  	 */
>  	if (xfs_is_always_cow_inode(ip))
>  		return 0;
> -	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
> -		return ip->i_d.di_extsize;
> +	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
> +		return ip->i_extsize;
>  	if (XFS_IS_REALTIME_INODE(ip))
>  		return ip->i_mount->m_sb.sb_rextsize;
>  	return 0;
> @@ -712,7 +712,7 @@ xfs_inode_inherit_flags(
>  			di_flags |= XFS_DIFLAG_RTINHERIT;
>  		if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
>  			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
> -			ip->i_d.di_extsize = pip->i_d.di_extsize;
> +			ip->i_extsize = pip->i_extsize;
>  		}
>  		if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
>  			di_flags |= XFS_DIFLAG_PROJINHERIT;
> @@ -722,7 +722,7 @@ xfs_inode_inherit_flags(
>  			di_flags |= XFS_DIFLAG_REALTIME;
>  		if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
>  			di_flags |= XFS_DIFLAG_EXTSIZE;
> -			ip->i_d.di_extsize = pip->i_d.di_extsize;
> +			ip->i_extsize = pip->i_extsize;
>  		}
>  	}
>  	if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
> @@ -838,7 +838,7 @@ xfs_init_new_inode(
>  	inode->i_atime = tv;
>  	inode->i_ctime = tv;
>  
> -	ip->i_d.di_extsize = 0;
> +	ip->i_extsize = 0;
>  	ip->i_d.di_flags = 0;
>  
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 4fe208669540fe..84cc2e74ba1961 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -57,6 +57,7 @@ typedef struct xfs_inode {
>  	xfs_fsize_t		i_disk_size;	/* number of bytes in file */
>  	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
>  	uint32_t		i_projid;	/* owner's project id */
> +	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 07b68bd8fbb8da..8a1411effd327d 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -371,7 +371,7 @@ xfs_inode_to_log_dinode(
>  
>  	to->di_size = ip->i_disk_size;
>  	to->di_nblocks = ip->i_nblocks;
> -	to->di_extsize = from->di_extsize;
> +	to->di_extsize = ip->i_extsize;
>  	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
>  	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
>  	to->di_forkoff = from->di_forkoff;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 8d22127284d360..ec769219e435e9 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1120,7 +1120,7 @@ xfs_fill_fsxattr(
>  	struct xfs_ifork	*ifp = attr ? ip->i_afp : &ip->i_df;
>  
>  	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
> -	fa->fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
> +	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
>  	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
>  			ip->i_mount->m_sb.sb_blocklog;
>  	fa->fsx_projid = ip->i_projid;
> @@ -1223,7 +1223,7 @@ xfs_ioctl_setattr_xflags(
>  	/* If realtime flag is set then must have realtime device */
>  	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
>  		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
> -		    (ip->i_d.di_extsize % mp->m_sb.sb_rextsize))
> +		    (ip->i_extsize % mp->m_sb.sb_rextsize))
>  			return -EINVAL;
>  	}
>  
> @@ -1347,7 +1347,7 @@ xfs_ioctl_setattr_check_extsize(
>  	xfs_fsblock_t		extsize_fsb;
>  
>  	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
> -	    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
> +	    ((ip->i_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
>  		return -EINVAL;
>  
>  	if (fa->fsx_extsize == 0)
> @@ -1519,9 +1519,9 @@ xfs_ioctl_setattr(
>  	 * are set on the inode then unconditionally clear the extent size hint.
>  	 */
>  	if (ip->i_d.di_flags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
> -		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
> +		ip->i_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
>  	else
> -		ip->i_d.di_extsize = 0;
> +		ip->i_extsize = 0;
>  	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
>  	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
>  		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index a94289fb5d61ee..ce95cb1a9bc9f5 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -103,7 +103,7 @@ xfs_bulkstat_one_int(
>  	buf->bs_mode = inode->i_mode;
>  
>  	buf->bs_xflags = xfs_ip2xflags(ip);
> -	buf->bs_extsize_blks = dic->di_extsize;
> +	buf->bs_extsize_blks = ip->i_extsize;
>  	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
>  	xfs_bulkstat_health(ip, buf);
>  	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
> -- 
> 2.30.1
> 
