Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7B733C63
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 02:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFDAZO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 20:25:14 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:32942 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbfFDAZO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 20:25:14 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 008053DAD8E;
        Tue,  4 Jun 2019 10:25:09 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hXxGF-0002le-IJ; Tue, 04 Jun 2019 10:25:07 +1000
Date:   Tue, 4 Jun 2019 10:25:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: fix inode_cluster_size rounding mayhem
Message-ID: <20190604002507.GK29573@dread.disaster.area>
References: <155960225918.1194435.11314723160642989835.stgit@magnolia>
 <155960228579.1194435.18215658650812508577.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155960228579.1194435.18215658650812508577.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=_Orx-3SRycpsedLycywA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 03:51:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> inode_cluster_size is supposed to represent the size (in bytes) of an
> inode cluster buffer.  We avoid having to handle multiple clusters per
> filesystem block on filesystems with large blocks by openly rounding
> this value up to 1 FSB when necessary.  However, we never reset
> inode_cluster_size to reflect this new rounded value, which adds to the
> potential for mistakes in calculating geometries.
> 
> Fix this by setting inode_cluster_size to reflect the rounded-up size if
> needed, and special-case the few places in the sparse inodes code where
> we actually need the smaller value to validate on-disk metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good - really helps simplify what some of the code does.

A few minor things below.

> ---
>  fs/xfs/libxfs/xfs_format.h     |    8 ++++++--
>  fs/xfs/libxfs/xfs_ialloc.c     |   19 +++++++++++++++++++
>  fs/xfs/libxfs/xfs_trans_resv.c |    6 ++----
>  fs/xfs/xfs_log_recover.c       |    3 +--
>  fs/xfs/xfs_mount.c             |    4 ++--
>  5 files changed, 30 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 0e831f04725c..1d3e1e66baf5 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1698,11 +1698,15 @@ struct xfs_ino_geometry {
>  	/* Maximum inode count in this filesystem. */
>  	uint64_t	maxicount;
>  
> +	/* Actual inode cluster buffer size, in bytes. */
> +	unsigned int	inode_cluster_size;
> +
>  	/*
>  	 * Desired inode cluster buffer size, in bytes.  This value is not
> -	 * rounded up to at least one filesystem block.
> +	 * rounded up to at least one filesystem block, which is necessary for
> +	 * validating sb_spino_align.
>  	 */
> -	unsigned int	inode_cluster_size;
> +	unsigned int	inode_cluster_size_raw;

Can you mention in the comment that this should never be used
outside of validating sb_spino_align and that inode_cluster_size is
the value that should be used by all runtime code?

>  	/* Inode cluster sizes, adjusted to be at least 1 fsb. */
>  	unsigned int	inodes_per_cluster;
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index cff202d0ee4a..976860673b6c 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2810,6 +2810,16 @@ xfs_ialloc_setup_geometry(
>  		igeo->maxicount = 0;
>  	}
>  
> +	/*
> +	 * Compute the desired size of an inode cluster buffer size, which
> +	 * starts at 8K and (on v5 filesystems) scales up with larger inode
> +	 * sizes.
> +	 *
> +	 * Preserve the desired inode cluster size because the sparse inodes
> +	 * feature uses that desired size (not the actual size) to compute the
> +	 * sparse inode alignment.  The mount code validates this value, so we
> +	 * cannot change the behavior.
> +	 */
>  	igeo->inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		int	new_size = igeo->inode_cluster_size;
> @@ -2818,12 +2828,21 @@ xfs_ialloc_setup_geometry(
>  		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
>  			igeo->inode_cluster_size = new_size;
>  	}
> +	igeo->inode_cluster_size_raw = igeo->inode_cluster_size;

I think I'd prefer to see the calculation use
igeo->inode_cluster_size_raw, and then that gets used to calculate
igeo->blocks_per_cluster, then igeo->inode_cluster_size is
calculated from blocks_per_cluster like you've done below. That way
there is an obvious logic flow to the variable derivation. i.e.
"this is how we calculate the raw cluster size and this is how we
calculate the actual runtime cluster size"...

> +
> +	/*
> +	 * Compute the inode cluster buffer size ratios.  We avoid needing to
> +	 * handle multiple clusters per filesystem block by rounding up
> +	 * blocks_per_cluster to 1 if necessary.  Set the inode cluster size
> +	 * to the actual value.
> +	 */
>  	igeo->blocks_per_cluster = xfs_icluster_size_fsb(mp);
>  	igeo->inodes_per_cluster = XFS_FSB_TO_INO(mp,
>  			igeo->blocks_per_cluster);
>  	igeo->cluster_align = xfs_ialloc_cluster_alignment(mp);
>  	igeo->cluster_align_inodes = XFS_FSB_TO_INO(mp,
>  			igeo->cluster_align);
> +	igeo->inode_cluster_size = XFS_FSB_TO_B(mp, igeo->blocks_per_cluster);

I'd put this immediately after we calculate blocks_per_cluster...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
