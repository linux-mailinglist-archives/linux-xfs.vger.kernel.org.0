Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6613C9407
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Jul 2021 00:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbhGNWx4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Jul 2021 18:53:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230495AbhGNWx4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 18:53:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F083060232;
        Wed, 14 Jul 2021 22:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626303064;
        bh=kwiMC09PXWW5CZypt4OOJGIkLwTPOdTxeaQMvLPIjQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H4sHLlurfGXrr76EH7BluF9YzAec8hbs0KSKfBhDA5/8HebS8X0rxVJI+LOiB5lPI
         3G0PJDCCKAPqJ4CSLpmc04HRs1jS2CrFy6UxNlgOiSBPY+qEgdueZbiu5NvQriHxQs
         /pYvnfgjD3jOWE9Ixhyql9qQzcef0l137+gvrLmSvXpahFYauWP0k8Kfd9r3NRh6VH
         o2wiBu7pNz4rqbBvK9F1OW+stRwtz/Ip7VrtaYQq/7WCvdMP80VIJ/PZ6CmyolwVWK
         gctgzJsVbrEAJAVNKmbS+R2OUML7qKb3wLXLL/HQq5RJ+436ERXkqxqoVsM2ZWmjFE
         7TX4+p2NCAMJg==
Date:   Wed, 14 Jul 2021 15:51:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/16] xfs: rework attr2 feature and mount options
Message-ID: <20210714225103.GV22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:18:59PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The attr2 feature is someone unique in that it has both a superblock

s/someone/somewhat/

> feature bit to enable it and mount options to enable and disable it.
> 
> Back when it was first introduced in 2005, attr2 was disabled unless
> either the attr2 superblock feature bit was set, or the attr2 mount
> option was set. If the superblock feature bit was not set but the
> mount option was set, then when the first attr2 format inode fork
> was created, it would set the superblock feature bit. This is as it
> should be - the superblock feature bit indicated the presence of the
> attr2 on disk format.
> 
> The noattr2 mount option, however, did not affect the superblock
> feature bit. If noattr2 was specified, the on-disk superblock
> feature bit was ignored and the code always just created attr1
> format inode forks.  If neither of the attr2 or noattr2 mounts
> option were specified, then the behaviour was determined by the
> superblock feature bit.
> 
> This was all pretty sane.
> 
> Fast foward 3 years, and we are dealing with fallout from the
> botched sb_features2 addition and having to deal with feature
> mismatches between the sb_features2 and sb_bad_features2 fields. The
> attr2 feature bit was one of these flags. The reconciliation was
> done well after mount option parsing and, unfortunately, the feature
> reconcilliation had a bug where it ignored the noattr2 mount option.

"reconciliation.."

> For reasons lost to the mists of time, it was decided that resolving
> this issue in commit 7c12f296500e ("[XFS] Fix up noattr2 so that it
> will properly update the versionnum and features2 fields.") required
> noattr2 to clear the superblock attr2 feature bit.  This greatly
> complicated the attr2 behaviour and broke rules about feature bits
> needing to be set when those specific features are present in the
> filesystem.

Yikes, WTH.

> By complicated, I mean that it introduced problems due to feature
> bit interactions with log recovery. All of the superblock feature
> bit checks are done prior to log recovery, but if we crash after
> removing a feature bit, then on the next mount we see the feature
> bit in the unrecovered superblock, only to have it go away after the
> log has been replayed.  This means our mount time feature processing
> could be all wrong.
> 
> Hence you can mount with noattr2, crash shortly afterwards, and
> mount again without attr2 or noattr2 and still have attr2 enabled
> because the second mount sees attr2 still enabled in the superblock
> before recovery runs and removes the feature bit. It's just a mess.
> 
> Further, this is all legacy code as the v5 format requires attr2 to
> be enabled at al times and it cannot be disabled.  i.e. the noattr2

"..at all times..."

> mount option returns an error when used on v5 format filesystems.
> 
> To straighten this all out, this patch reverts the attr2/noattr2
> mount option behaviour back to the original behaviour. There is no
> reason for disabling attr2 these days, so we will only do this when
> the noattr2 mount option is set. This will not remove the superblock
> feature bit. The superblock bit will provide the default behaviour
> and only track whether attr2 is present on disk or not. The attr2
> mount option will enable the creation of attr2 format inode forks,
> and if the superblock feature bit is not set it will be added when
> the first attr2 inode fork is created.

...and the whole V4 format is clanking towards deprecation anyway. :)

> Signed-off-by: Dave Chinner <dchinner@redhat.com>

With the commit message fixed up and Christoph's other suggestions
resolved,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_format.h |  7 -------
>  fs/xfs/xfs_mount.c         | 27 ++++++++++-----------------
>  fs/xfs/xfs_super.c         | 16 +++++++---------
>  3 files changed, 17 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 76e2461b9e66..a8215bf478b2 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -398,13 +398,6 @@ static inline void xfs_sb_version_addattr2(struct xfs_sb *sbp)
>  	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
>  }
>  
> -static inline void xfs_sb_version_removeattr2(struct xfs_sb *sbp)
> -{
> -	sbp->sb_features2 &= ~XFS_SB_VERSION2_ATTR2BIT;
> -	if (!sbp->sb_features2)
> -		sbp->sb_versionnum &= ~XFS_SB_VERSION_MOREBITSBIT;
> -}
> -
>  static inline bool xfs_sb_version_hasprojid32bit(struct xfs_sb *sbp)
>  {
>  	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index d0755494597f..6be2a1c5b0f4 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -607,25 +607,8 @@ xfs_mountfs(
>  		xfs_warn(mp, "correcting sb_features alignment problem");
>  		sbp->sb_features2 |= sbp->sb_bad_features2;
>  		mp->m_update_sb = true;
> -
> -		/*
> -		 * Re-check for ATTR2 in case it was found in bad_features2
> -		 * slot.
> -		 */
> -		if (xfs_sb_version_hasattr2(&mp->m_sb) &&
> -		   !(mp->m_flags & XFS_MOUNT_NOATTR2))
> -			mp->m_flags |= XFS_MOUNT_ATTR2;
>  	}
>  
> -	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
> -	   (mp->m_flags & XFS_MOUNT_NOATTR2)) {
> -		xfs_sb_version_removeattr2(&mp->m_sb);
> -		mp->m_update_sb = true;
> -
> -		/* update sb_versionnum for the clearing of the morebits */
> -		if (!sbp->sb_features2)
> -			mp->m_update_sb = true;
> -	}
>  
>  	/* always use v2 inodes by default now */
>  	if (!(mp->m_sb.sb_versionnum & XFS_SB_VERSION_NLINKBIT)) {
> @@ -782,6 +765,16 @@ xfs_mountfs(
>  	if (error)
>  		goto out_log_dealloc;
>  
> +	/*
> +	 * Now that we've recovered any pending superblock feature bit
> +	 * additions, we can finish setting up the attr2 behaviour for the
> +	 * mount. If no attr2 mount options were specified, the we use the
> +	 * behaviour specified by the superblock feature bit.
> +	 */
> +	if (!(mp->m_flags & (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) &&
> +	    xfs_sb_version_hasattr2(&mp->m_sb))
> +		mp->m_flags |= XFS_MOUNT_ATTR2;
> +
>  	/*
>  	 * Get and sanity-check the root inode.
>  	 * Save the pointer to it in the mount structure.
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 29bec1f6476e..eba25dd4bdb7 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -945,14 +945,6 @@ xfs_finish_flags(
>  		return -EINVAL;
>  	}
>  
> -	/*
> -	 * mkfs'ed attr2 will turn on attr2 mount unless explicitly
> -	 * told by noattr2 to turn it off
> -	 */
> -	if (xfs_sb_version_hasattr2(&mp->m_sb) &&
> -	    !(mp->m_flags & XFS_MOUNT_NOATTR2))
> -		mp->m_flags |= XFS_MOUNT_ATTR2;
> -
>  	/*
>  	 * prohibit r/w mounts of read-only filesystems
>  	 */
> @@ -1288,7 +1280,6 @@ xfs_fs_parse_param(
>  		return 0;
>  	case Opt_noattr2:
>  		xfs_fs_warn_deprecated(fc, param, XFS_MOUNT_NOATTR2, true);
> -		parsing_mp->m_flags &= ~XFS_MOUNT_ATTR2;
>  		parsing_mp->m_flags |= XFS_MOUNT_NOATTR2;
>  		return 0;
>  	default:
> @@ -1312,6 +1303,13 @@ xfs_fs_validate_params(
>  		return -EINVAL;
>  	}
>  
> +	if ((mp->m_flags & (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) ==
> +			  (XFS_MOUNT_ATTR2|XFS_MOUNT_NOATTR2)) {
> +		xfs_warn(mp, "attr2 and noattr2 cannot both be specified.");
> +		return -EINVAL;
> +	}
> +
> +
>  	if ((mp->m_flags & XFS_MOUNT_NOALIGN) &&
>  	    (mp->m_dalign || mp->m_swidth)) {
>  		xfs_warn(mp,
> -- 
> 2.31.1
> 
