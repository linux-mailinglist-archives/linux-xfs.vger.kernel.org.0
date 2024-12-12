Return-Path: <linux-xfs+bounces-16589-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF529EFEED
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Dec 2024 23:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5837284CD4
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Dec 2024 22:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA2D71925AF;
	Thu, 12 Dec 2024 22:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dImgx39k"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A964815696E
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 22:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734040941; cv=none; b=RSBgkgX+/lL9EKpGOLY+zqybVtLxGIu8OlqO4nCSzlRJ/lSRZZpcSmewItxgeY06+bABRU79KzPn31bZc2t8uC+qpyuoe1XfKVUKiN7kphbNlqtiYm59HuP6BpFE4TC22IpPZjF+nCzzqF6UNinDJSPP2anRvbvTrsYHAFdz8cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734040941; c=relaxed/simple;
	bh=w93TSgqfehTg+rIS3VTyCAwm0C4zldf+T6YdS78d3R4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z0IT4/dwZoAMggrZhccrItL3bq7DT5AyuA/AKiq4e03HFDxlJt1FCwasVwY/kPq2TNAqTZdttuJfe7c56V/+eirgfJ9J1gbBrAVu0vVIpx1rO3WLViaawqEfyzKWIZIiY/aNYKS61hDPcHs3RtBax/6RKFPrsDvYCIhq6/r2dCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dImgx39k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18596C4CED1;
	Thu, 12 Dec 2024 22:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734040941;
	bh=w93TSgqfehTg+rIS3VTyCAwm0C4zldf+T6YdS78d3R4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dImgx39kTTwY+uXvcu10uukkWlTnL+HrCyDH2hFwBMEzGw791KnorZEWi0AuV248F
	 2Fpe5CcpGh4LQEDG/BPF0iMMB998u1FjHLVzNC4OK7b7qPG6CfHO24D3Kzq+ffal2D
	 8GwdQI8PwdDBMBiHVAqhF95TsqAEkDeNr4GAgrsV3fmEbiyWKTAP+A/q9SnpFFLasU
	 rYqzMQ1lyIDW8/0FBWzmMcfvrfBJvR3M/JYYneYMKyFkdwDvT5l7XB9UPcSV3F76ri
	 IOj1Mt+vapS1Ox3/N64zMZ0GhwemxWbURlxTkDHc+hSFLJbtSEt7gBn0kBSHSI8s4R
	 FBPnrBPTceiyQ==
Date: Thu, 12 Dec 2024 14:02:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/43] xfs: define the zoned on-disk format
Message-ID: <20241212220220.GA6653@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-16-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:40AM +0100, Christoph Hellwig wrote:
> Zone file systems reuse the basic RT group enabled XFS file system
> structure to support a mode where each RT group is always written from
> start to end and then reset for reuse (after moving out any remaining
> data).  There are few minor but important changes, which are indicated
> by a new incompat flag:
> 
> 1) there are no bitmap and summary inodes, and thus the sb_rbmblocks
>    superblock field must be cleared to zero

zoned rt requires rt rmap and reflink, and hence metadir.  There is no
such field as sb_rbmblocks anymore.

"...and thus there must not be any /rtgroups/0.{bitmap,summary} files."

> 2) there is a new superblock field that specifies the start of an
>    internal RT section.  This allows supporting SMR HDDs that have random
>    writable space at the beginning which is used for the XFS data device
>    (which really is the metadata device for this configuration), directly
>    followed by a RT device on the same block device.  While something
>    similar could be achieved using dm-linear just having a single device
>    directly consumed by XFS makes handling the file systems a lot easier.
> 
> 3) Another superblock field that tracks the amount of reserved space (or
>    overprovisioning) that is never used for user capacity, but allows GC
>    to run more smoothly.
> 
> 4) an overlay of the cowextsizse field for the rtrmap inode so that we

                       cowextsize

>    can persistently track the total amount of bytes currently used in

Isn't this the total number of *fsblocks* currently used?

>    a RT group.  There is no data structure other than the rmap that
>    tracks used space in an RT group, and this counter is used to decide
>    when a RT group has been entirely emptied, and to select one that
>    is relatively empty if garbage collection needs to be performed.
>    While this counter could be tracked entirely in memory and rebuilt
>    from the rmap at mount time, that would lead to very long mount times
>    with the large number of RT groups implied by the number of hardware
>    zones especially on SMR hard drives with 256MB zone sizes.

Heh, I guess I should go down to my lab and plug in this smr disk and
see how many zones it reports...

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_format.h      | 15 ++++++++++---
>  fs/xfs/libxfs/xfs_inode_buf.c   | 18 +++++++++++-----
>  fs/xfs/libxfs/xfs_inode_util.c  |  1 +
>  fs/xfs/libxfs/xfs_log_format.h  |  7 ++++++-
>  fs/xfs/libxfs/xfs_ondisk.h      |  6 ++++--
>  fs/xfs/libxfs/xfs_rtbitmap.c    | 11 ++++++++++
>  fs/xfs/libxfs/xfs_rtgroup.c     | 37 ++++++++++++++++++++-------------
>  fs/xfs/libxfs/xfs_sb.c          | 35 ++++++++++++++++++++++++++++---
>  fs/xfs/scrub/agheader.c         |  2 ++
>  fs/xfs/scrub/inode.c            |  7 +++++++
>  fs/xfs/scrub/inode_repair.c     |  4 +++-
>  fs/xfs/scrub/scrub.c            |  2 ++
>  fs/xfs/xfs_fsmap.c              |  6 +++++-
>  fs/xfs/xfs_inode.c              |  3 ++-
>  fs/xfs/xfs_inode.h              | 12 ++++++++++-
>  fs/xfs/xfs_inode_item.c         |  1 +
>  fs/xfs/xfs_inode_item_recover.c |  1 +
>  fs/xfs/xfs_iomap.c              |  1 +
>  fs/xfs/xfs_message.c            |  4 ++++
>  fs/xfs/xfs_message.h            |  1 +
>  fs/xfs/xfs_mount.h              | 13 +++++++++++-
>  fs/xfs/xfs_rtalloc.c            |  2 ++
>  fs/xfs/xfs_super.c              | 11 +++++++++-
>  23 files changed, 165 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index b1007fb661ba..12979496f30a 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -178,9 +178,10 @@ typedef struct xfs_sb {
>  
>  	xfs_rgnumber_t	sb_rgcount;	/* number of realtime groups */
>  	xfs_rtxlen_t	sb_rgextents;	/* size of a realtime group in rtx */
> -
>  	uint8_t		sb_rgblklog;    /* rt group number shift */
>  	uint8_t		sb_pad[7];	/* zeroes */
> +	xfs_fsblock_t	sb_rtstart;	/* start of internal RT section (FSB) */
> +	xfs_filblks_t	sb_rtreserved;	/* reserved (zoned) RT blocks */
>  
>  	/* must be padded to 64 bit alignment */
>  } xfs_sb_t;
> @@ -270,9 +271,10 @@ struct xfs_dsb {
>  	__be64		sb_metadirino;	/* metadata directory tree root */
>  	__be32		sb_rgcount;	/* # of realtime groups */
>  	__be32		sb_rgextents;	/* size of rtgroup in rtx */
> -
>  	__u8		sb_rgblklog;    /* rt group number shift */
>  	__u8		sb_pad[7];	/* zeroes */
> +	__be64		sb_rtstart;	/* start of internal RT section (FSB) */
> +	__be64		sb_rtreserved;	/* reserved (zoned) RT blocks */
>  
>  	/*
>  	 * The size of this structure must be padded to 64 bit alignment.
> @@ -395,6 +397,8 @@ xfs_sb_has_ro_compat_feature(
>  #define XFS_SB_FEAT_INCOMPAT_EXCHRANGE	(1 << 6)  /* exchangerange supported */
>  #define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 7)  /* parent pointers */
>  #define XFS_SB_FEAT_INCOMPAT_METADIR	(1 << 8)  /* metadata dir tree */
> +#define XFS_SB_FEAT_INCOMPAT_ZONED	(1U << 31)/* zoned RT allocator */
> +
>  #define XFS_SB_FEAT_INCOMPAT_ALL \
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES | \
> @@ -952,7 +956,12 @@ struct xfs_dinode {
>  	__be64		di_changecount;	/* number of attribute changes */
>  	__be64		di_lsn;		/* flush sequence */
>  	__be64		di_flags2;	/* more random flags */
> -	__be32		di_cowextsize;	/* basic cow extent size for file */
> +	union {
> +		/* basic cow extent size for (regular) file */
> +		__be32		di_cowextsize;
> +		/* used blocks in RTG for (zoned) rtrmap inode */
> +		__be32		di_used_blocks;
> +	};
>  	__u8		di_pad2[12];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index f24fa628fecf..cd38be2a69be 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -252,7 +252,10 @@ xfs_inode_from_disk(
>  					   be64_to_cpu(from->di_changecount));
>  		ip->i_crtime = xfs_inode_from_disk_ts(from, from->di_crtime);
>  		ip->i_diflags2 = be64_to_cpu(from->di_flags2);
> +		/* also covers the di_used_blocks union arm: */
>  		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
> +		BUILD_BUG_ON(sizeof(from->di_cowextsize) !=
> +			     sizeof(from->di_used_blocks));
>  	}
>  
>  	error = xfs_iformat_data_fork(ip, from);
> @@ -349,6 +352,7 @@ xfs_inode_to_disk(
>  		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
>  		to->di_crtime = xfs_inode_to_disk_ts(ip, ip->i_crtime);
>  		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
> +		/* also covers the di_used_blocks union arm: */
>  		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
>  		to->di_ino = cpu_to_be64(ip->i_ino);
>  		to->di_lsn = cpu_to_be64(lsn);
> @@ -752,11 +756,15 @@ xfs_dinode_verify(
>  	    !xfs_has_rtreflink(mp))
>  		return __this_address;
>  
> -	/* COW extent size hint validation */
> -	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
> -			mode, flags, flags2);
> -	if (fa)
> -		return fa;
> +	if (!xfs_has_zoned(mp) ||
> +	    dip->di_metatype != cpu_to_be16(XFS_METAFILE_RTRMAP)) {
> +		/* COW extent size hint validation */
> +		fa = xfs_inode_validate_cowextsize(mp,
> +				be32_to_cpu(dip->di_cowextsize),
> +				mode, flags, flags2);

I think there's *some* validation you could do, such as checking that
i_cowextsize <= the number of blocks in the rtgroup.

I almost wonder if you should add that kind of logic to
xfs_inode_validate_cowextsize but that might be one incoherence too
many.  OTOH it would probably reduce the number of changes in the fsck
code.

--D

> +		if (fa)
> +			return fa;
> +	}
>  
>  	/* bigtime iflag can only happen on bigtime filesystems */
>  	if (xfs_dinode_has_bigtime(dip) &&
> diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
> index deb0b7c00a1f..48fe49a5f050 100644
> --- a/fs/xfs/libxfs/xfs_inode_util.c
> +++ b/fs/xfs/libxfs/xfs_inode_util.c
> @@ -322,6 +322,7 @@ xfs_inode_init(
>  
>  	if (xfs_has_v3inodes(mp)) {
>  		inode_set_iversion(inode, 1);
> +		/* also covers the di_used_blocks union arm: */
>  		ip->i_cowextsize = 0;
>  		times |= XFS_ICHGTIME_CREATE;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index ec7157eaba5f..8f6fd195ce6e 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -481,7 +481,12 @@ struct xfs_log_dinode {
>  	xfs_lsn_t	di_lsn;
>  
>  	uint64_t	di_flags2;	/* more random flags */
> -	uint32_t	di_cowextsize;	/* basic cow extent size for file */
> +	union {
> +		/* basic cow extent size for (regular) file */
> +		uint32_t		di_cowextsize;
> +		/* used blocks in RTG for (zoned) rtrmap inode */
> +		uint32_t		di_used_blocks;
> +	};
>  	uint8_t		di_pad2[12];	/* more padding for future expansion */
>  
>  	/* fields only written to during inode creation */
> diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
> index a85ecddaa48e..5ed44fdf7491 100644
> --- a/fs/xfs/libxfs/xfs_ondisk.h
> +++ b/fs/xfs/libxfs/xfs_ondisk.h
> @@ -233,8 +233,8 @@ xfs_check_ondisk_structs(void)
>  			16299260424LL);
>  
>  	/* superblock field checks we got from xfs/122 */
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,		288);
> -	XFS_CHECK_STRUCT_SIZE(struct xfs_sb,		288);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,		304);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_sb,		304);
>  	XFS_CHECK_SB_OFFSET(sb_magicnum,		0);
>  	XFS_CHECK_SB_OFFSET(sb_blocksize,		4);
>  	XFS_CHECK_SB_OFFSET(sb_dblocks,			8);
> @@ -295,6 +295,8 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_SB_OFFSET(sb_rgextents,		276);
>  	XFS_CHECK_SB_OFFSET(sb_rgblklog,		280);
>  	XFS_CHECK_SB_OFFSET(sb_pad,			281);
> +	XFS_CHECK_SB_OFFSET(sb_rtstart,			288);
> +	XFS_CHECK_SB_OFFSET(sb_rtreserved,		296);
>  }
>  
>  #endif /* __XFS_ONDISK_H */
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index 770adf60dd73..5057536e586c 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -1123,6 +1123,7 @@ xfs_rtfree_blocks(
>  	xfs_extlen_t		mod;
>  	int			error;
>  
> +	ASSERT(!xfs_has_zoned(mp));
>  	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
>  
>  	mod = xfs_blen_to_rtxoff(mp, rtlen);
> @@ -1174,6 +1175,9 @@ xfs_rtalloc_query_range(
>  
>  	end = min(end, rtg->rtg_extents - 1);
>  
> +	if (xfs_has_zoned(mp))
> +		return -EINVAL;
> +
>  	/* Iterate the bitmap, looking for discrepancies. */
>  	while (start <= end) {
>  		struct xfs_rtalloc_rec	rec;
> @@ -1268,6 +1272,8 @@ xfs_rtbitmap_blockcount_len(
>  	struct xfs_mount	*mp,
>  	xfs_rtbxlen_t		rtextents)
>  {
> +	if (xfs_has_zoned(mp))
> +		return 0;
>  	return howmany_64(rtextents, xfs_rtbitmap_rtx_per_rbmblock(mp));
>  }
>  
> @@ -1308,6 +1314,11 @@ xfs_rtsummary_blockcount(
>  	xfs_rtbxlen_t		rextents = xfs_rtbitmap_bitcount(mp);
>  	unsigned long long	rsumwords;
>  
> +	if (xfs_has_zoned(mp)) {
> +		*rsumlevels = 0;
> +		return 0;
> +	}
> +
>  	*rsumlevels = xfs_compute_rextslog(rextents) + 1;
>  	rsumwords = xfs_rtbitmap_blockcount_len(mp, rextents) * (*rsumlevels);
>  	return howmany_64(rsumwords, mp->m_blockwsize);
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> index 97aad8967149..9186c58e83d5 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.c
> +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> @@ -194,15 +194,17 @@ xfs_rtgroup_lock(
>  	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
>  	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
>  
> -	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
> -		/*
> -		 * Lock both realtime free space metadata inodes for a freespace
> -		 * update.
> -		 */
> -		xfs_ilock(rtg_bitmap(rtg), XFS_ILOCK_EXCL);
> -		xfs_ilock(rtg_summary(rtg), XFS_ILOCK_EXCL);
> -	} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
> -		xfs_ilock(rtg_bitmap(rtg), XFS_ILOCK_SHARED);
> +	if (!xfs_has_zoned(rtg_mount(rtg))) {
> +		if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
> +			/*
> +			 * Lock both realtime free space metadata inodes for a
> +			 * freespace update.
> +			 */
> +			xfs_ilock(rtg_bitmap(rtg), XFS_ILOCK_EXCL);
> +			xfs_ilock(rtg_summary(rtg), XFS_ILOCK_EXCL);
> +		} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
> +			xfs_ilock(rtg_bitmap(rtg), XFS_ILOCK_SHARED);
> +		}
>  	}
>  
>  	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
> @@ -228,11 +230,13 @@ xfs_rtgroup_unlock(
>  	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg_rmap(rtg))
>  		xfs_iunlock(rtg_rmap(rtg), XFS_ILOCK_EXCL);
>  
> -	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
> -		xfs_iunlock(rtg_summary(rtg), XFS_ILOCK_EXCL);
> -		xfs_iunlock(rtg_bitmap(rtg), XFS_ILOCK_EXCL);
> -	} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
> -		xfs_iunlock(rtg_bitmap(rtg), XFS_ILOCK_SHARED);
> +	if (!xfs_has_zoned(rtg_mount(rtg))) {
> +		if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
> +			xfs_iunlock(rtg_summary(rtg), XFS_ILOCK_EXCL);
> +			xfs_iunlock(rtg_bitmap(rtg), XFS_ILOCK_EXCL);
> +		} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
> +			xfs_iunlock(rtg_bitmap(rtg), XFS_ILOCK_SHARED);
> +		}
>  	}
>  }
>  
> @@ -249,7 +253,8 @@ xfs_rtgroup_trans_join(
>  	ASSERT(!(rtglock_flags & ~XFS_RTGLOCK_ALL_FLAGS));
>  	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED));
>  
> -	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
> +	if (!xfs_has_zoned(rtg_mount(rtg)) &&
> +	    (rtglock_flags & XFS_RTGLOCK_BITMAP)) {
>  		xfs_trans_ijoin(tp, rtg_bitmap(rtg), XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, rtg_summary(rtg), XFS_ILOCK_EXCL);
>  	}
> @@ -354,6 +359,7 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
>  		.sick		= XFS_SICK_RG_BITMAP,
>  		.fmt_mask	= (1U << XFS_DINODE_FMT_EXTENTS) |
>  				  (1U << XFS_DINODE_FMT_BTREE),
> +		.enabled	= xfs_has_nonzoned,
>  		.create		= xfs_rtbitmap_create,
>  	},
>  	[XFS_RTGI_SUMMARY] = {
> @@ -362,6 +368,7 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
>  		.sick		= XFS_SICK_RG_SUMMARY,
>  		.fmt_mask	= (1U << XFS_DINODE_FMT_EXTENTS) |
>  				  (1U << XFS_DINODE_FMT_BTREE),
> +		.enabled	= xfs_has_nonzoned,
>  		.create		= xfs_rtsummary_create,
>  	},
>  	[XFS_RTGI_RMAP] = {
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 090f133f4da3..0bbe0b87bf04 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -30,6 +30,7 @@
>  #include "xfs_rtgroup.h"
>  #include "xfs_rtrmap_btree.h"
>  #include "xfs_rtrefcount_btree.h"
> +#include "xfs_rtbitmap.h"
>  
>  /*
>   * Physical superblock buffer manipulations. Shared with libxfs in userspace.
> @@ -185,6 +186,8 @@ xfs_sb_version_to_features(
>  		features |= XFS_FEAT_PARENT;
>  	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)
>  		features |= XFS_FEAT_METADIR;
> +	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)
> +		features |= XFS_FEAT_ZONED;
>  
>  	return features;
>  }
> @@ -266,6 +269,9 @@ static uint64_t
>  xfs_expected_rbmblocks(
>  	struct xfs_sb		*sbp)
>  {
> +	if (xfs_sb_is_v5(sbp) &&
> +	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED))
> +		return 0;
>  	return howmany_64(xfs_extents_per_rbm(sbp),
>  			  NBBY * xfs_rtbmblock_size(sbp));
>  }
> @@ -275,9 +281,19 @@ bool
>  xfs_validate_rt_geometry(
>  	struct xfs_sb		*sbp)
>  {
> -	if (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE ||
> -	    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)
> -		return false;
> +	if (xfs_sb_is_v5(sbp) &&
> +	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)) {
> +		if (sbp->sb_rextsize != 1)
> +			return false;
> +		if (sbp->sb_rtstart && sbp->sb_rtstart < sbp->sb_dblocks)
> +			return false;
> +		if (sbp->sb_rtreserved && sbp->sb_rtreserved >= sbp->sb_rblocks)
> +			return false;
> +	} else {
> +		if (sbp->sb_rextsize * sbp->sb_blocksize > XFS_MAX_RTEXTSIZE ||
> +		    sbp->sb_rextsize * sbp->sb_blocksize < XFS_MIN_RTEXTSIZE)
> +			return false;
> +	}
>  
>  	if (sbp->sb_rblocks == 0) {
>  		if (sbp->sb_rextents != 0 || sbp->sb_rbmblocks != 0 ||
> @@ -835,6 +851,14 @@ __xfs_sb_from_disk(
>  		to->sb_rgcount = 1;
>  		to->sb_rgextents = 0;
>  	}
> +
> +	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) {
> +		to->sb_rtstart = be64_to_cpu(from->sb_rtstart);
> +		to->sb_rtreserved = be64_to_cpu(from->sb_rtreserved);
> +	} else {
> +		to->sb_rtstart = 0;
> +		to->sb_rtreserved = 0;
> +	}
>  }
>  
>  void
> @@ -1001,6 +1025,11 @@ xfs_sb_to_disk(
>  		to->sb_rbmino = cpu_to_be64(0);
>  		to->sb_rsumino = cpu_to_be64(0);
>  	}
> +
> +	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED) {
> +		to->sb_rtstart = cpu_to_be64(from->sb_rtstart);
> +		to->sb_rtreserved = cpu_to_be64(from->sb_rtreserved);
> +	}
>  }
>  
>  /*
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 190d56f81344..68de763b2543 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -64,6 +64,8 @@ STATIC size_t
>  xchk_superblock_ondisk_size(
>  	struct xfs_mount	*mp)
>  {
> +	if (xfs_has_zoned(mp))
> +		return offsetofend(struct xfs_dsb, sb_rtreserved);
>  	if (xfs_has_metadir(mp))
>  		return offsetofend(struct xfs_dsb, sb_pad);
>  	if (xfs_has_metauuid(mp))
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index db6edd5a5fe5..bb3f475b6353 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -273,6 +273,13 @@ xchk_inode_cowextsize(
>  	xfs_failaddr_t		fa;
>  	uint32_t		value = be32_to_cpu(dip->di_cowextsize);
>  
> +	/*
> +	 * The used block counter for rtrmap is checked and repaired elsewhere.
> +	 */
> +	if (xfs_has_zoned(sc->mp) &&
> +	    dip->di_metatype == cpu_to_be16(XFS_METAFILE_RTRMAP))
> +		return;
> +
>  	fa = xfs_inode_validate_cowextsize(sc->mp, value, mode, flags, flags2);
>  	if (fa)
>  		xchk_ino_set_corrupt(sc, ino);
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index 2f641b6d663e..c8d17dd4fc32 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c
> @@ -710,7 +710,9 @@ xrep_dinode_extsize_hints(
>  					      XFS_DIFLAG_EXTSZINHERIT);
>  	}
>  
> -	if (dip->di_version < 3)
> +	if (dip->di_version < 3 ||
> +	    (xfs_has_zoned(sc->mp) &&
> +	     dip->di_metatype == cpu_to_be16(XFS_METAFILE_RTRMAP)))
>  		return;
>  
>  	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
> diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
> index 7567dd5cad14..1a05c27ba471 100644
> --- a/fs/xfs/scrub/scrub.c
> +++ b/fs/xfs/scrub/scrub.c
> @@ -387,12 +387,14 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
>  	},
>  	[XFS_SCRUB_TYPE_RTBITMAP] = {	/* realtime bitmap */
>  		.type	= ST_RTGROUP,
> +		.has	= xfs_has_nonzoned,
>  		.setup	= xchk_setup_rtbitmap,
>  		.scrub	= xchk_rtbitmap,
>  		.repair	= xrep_rtbitmap,
>  	},
>  	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
>  		.type	= ST_RTGROUP,
> +		.has	= xfs_has_nonzoned,
>  		.setup	= xchk_setup_rtsummary,
>  		.scrub	= xchk_rtsummary,
>  		.repair	= xrep_rtsummary,
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 1dbd2d75f7ae..917d4d0e51b3 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -1138,7 +1138,11 @@ xfs_getfsmap(
>  		handlers[1].fn = xfs_getfsmap_logdev;
>  	}
>  #ifdef CONFIG_XFS_RT
> -	if (mp->m_rtdev_targp) {
> +	/*
> +	 * For zoned file systems there is no rtbitmap, so only support fsmap
> +	 * if the callers is privileged enough to use the full rmap version.
> +	 */
> +	if (mp->m_rtdev_targp && (use_rmap || !xfs_has_zoned(mp))) {
>  		handlers[2].nr_sectors = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
>  		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
>  		if (use_rmap)
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c95fe1b1de4e..4624d40c664c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3071,5 +3071,6 @@ bool
>  xfs_is_always_cow_inode(
>  	const struct xfs_inode	*ip)
>  {
> -	return ip->i_mount->m_always_cow && xfs_has_reflink(ip->i_mount);
> +	return xfs_is_zoned_inode(ip) ||
> +		(ip->i_mount->m_always_cow && xfs_has_reflink(ip->i_mount));
>  }
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index c08093a65352..10cd8f0c4697 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -69,8 +69,13 @@ typedef struct xfs_inode {
>  	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
>  	prid_t			i_projid;	/* owner's project id */
>  	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
> -	/* cowextsize is only used for v3 inodes, flushiter for v1/2 */
> +	/*
> +	 * i_used_blocks is used for zoned rtrmap inodes,
> +	 * i_cowextsize is used for other v3 inodes,
> +	 * i_flushiter for v1/2 inodes
> +	 */
>  	union {
> +		uint32_t	i_used_blocks;	/* used blocks in RTG */
>  		xfs_extlen_t	i_cowextsize;	/* basic cow extent size */
>  		uint16_t	i_flushiter;	/* incremented on flush */
>  	};
> @@ -309,6 +314,11 @@ static inline bool xfs_is_internal_inode(const struct xfs_inode *ip)
>  	       xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
>  }
>  
> +static inline bool xfs_is_zoned_inode(const struct xfs_inode *ip)
> +{
> +	return xfs_has_zoned(ip->i_mount) && XFS_IS_REALTIME_INODE(ip);
> +}
> +
>  bool xfs_is_always_cow_inode(const struct xfs_inode *ip);
>  
>  static inline bool xfs_is_cow_inode(const struct xfs_inode *ip)
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 70283c6419fd..2f1122e3ab12 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -596,6 +596,7 @@ xfs_inode_to_log_dinode(
>  		to->di_changecount = inode_peek_iversion(inode);
>  		to->di_crtime = xfs_inode_to_log_dinode_ts(ip, ip->i_crtime);
>  		to->di_flags2 = ip->i_diflags2;
> +		/* also covers the di_used_blocks union arm: */
>  		to->di_cowextsize = ip->i_cowextsize;
>  		to->di_ino = ip->i_ino;
>  		to->di_lsn = lsn;
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 4e583bfc5ca8..7b8b8610de35 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -203,6 +203,7 @@ xfs_log_dinode_to_disk(
>  		to->di_crtime = xfs_log_dinode_to_disk_ts(from,
>  							  from->di_crtime);
>  		to->di_flags2 = cpu_to_be64(from->di_flags2);
> +		/* also covers the di_used_blocks union arm: */
>  		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
>  		to->di_ino = cpu_to_be64(from->di_ino);
>  		to->di_lsn = cpu_to_be64(lsn);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index f3f4b5c328c3..aa1db0dc1d98 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1216,6 +1216,7 @@ xfs_bmapi_reserve_delalloc(
>  
>  	fdblocks = indlen;
>  	if (XFS_IS_REALTIME_INODE(ip)) {
> +		ASSERT(!xfs_is_zoned_inode(ip));
>  		error = xfs_dec_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
>  		if (error)
>  			goto out_unreserve_quota;
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index 6ed485ff2756..15d410d16bb2 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -173,6 +173,10 @@ xfs_warn_experimental(
>  			.opstate	= XFS_OPSTATE_WARNED_METADIR,
>  			.name		= "metadata directory tree",
>  		},
> +		[XFS_EXPERIMENTAL_ZONED] = {
> +			.opstate	= XFS_OPSTATE_WARNED_ZONED,
> +			.name		= "zoned RT device",
> +		},
>  	};
>  	ASSERT(feat >= 0 && feat < XFS_EXPERIMENTAL_MAX);
>  	BUILD_BUG_ON(ARRAY_SIZE(features) != XFS_EXPERIMENTAL_MAX);
> diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
> index 7fb36ced9df7..a92a4d09c8e9 100644
> --- a/fs/xfs/xfs_message.h
> +++ b/fs/xfs/xfs_message.h
> @@ -99,6 +99,7 @@ enum xfs_experimental_feat {
>  	XFS_EXPERIMENTAL_EXCHRANGE,
>  	XFS_EXPERIMENTAL_PPTR,
>  	XFS_EXPERIMENTAL_METADIR,
> +	XFS_EXPERIMENTAL_ZONED,
>  
>  	XFS_EXPERIMENTAL_MAX,
>  };
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 73bc053fdd17..72c5389ff78b 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -343,6 +343,7 @@ typedef struct xfs_mount {
>  #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
>  #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
>  #define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
> +#define XFS_FEAT_ZONED		(1ULL << 29)	/* zoned RT device */
>  
>  /* Mount features */
>  #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
> @@ -399,6 +400,7 @@ __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
>  __XFS_HAS_FEAT(large_extent_counts, NREXT64)
>  __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
>  __XFS_HAS_FEAT(metadir, METADIR)
> +__XFS_HAS_FEAT(zoned, ZONED)
>  
>  static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
>  {
> @@ -409,7 +411,9 @@ static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
>  static inline bool xfs_has_rtsb(const struct xfs_mount *mp)
>  {
>  	/* all rtgroups filesystems with an rt section have an rtsb */
> -	return xfs_has_rtgroups(mp) && xfs_has_realtime(mp);
> +	return xfs_has_rtgroups(mp) &&
> +		xfs_has_realtime(mp) &&
> +		!xfs_has_zoned(mp);
>  }
>  
>  static inline bool xfs_has_rtrmapbt(const struct xfs_mount *mp)
> @@ -424,6 +428,11 @@ static inline bool xfs_has_rtreflink(const struct xfs_mount *mp)
>  	       xfs_has_reflink(mp);
>  }
>  
> +static inline bool xfs_has_nonzoned(const struct xfs_mount *mp)
> +{
> +	return !xfs_has_zoned(mp);
> +}
> +
>  /*
>   * Some features are always on for v5 file systems, allow the compiler to
>   * eliminiate dead code when building without v4 support.
> @@ -527,6 +536,8 @@ __XFS_HAS_FEAT(nouuid, NOUUID)
>  #define XFS_OPSTATE_WARNED_METADIR	17
>  /* Filesystem should use qflags to determine quotaon status */
>  #define XFS_OPSTATE_RESUMING_QUOTAON	18
> +/* Kernel has logged a warning about zoned RT device being used on this fs. */
> +#define XFS_OPSTATE_WARNED_ZONED	19
>  
>  #define __XFS_IS_OPSTATE(name, NAME) \
>  static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 8da2498417f5..e457a2c2d561 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -2097,6 +2097,8 @@ xfs_bmap_rtalloc(
>  		ap->datatype & XFS_ALLOC_INITIAL_USER_DATA;
>  	int			error;
>  
> +	ASSERT(!xfs_has_zoned(ap->tp->t_mountp));
> +
>  retry:
>  	error = xfs_rtallocate_align(ap, &ralen, &raminlen, &prod, &noalign);
>  	if (error)
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index f57c27940467..92dd44965943 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1784,8 +1784,17 @@ xfs_fs_fill_super(
>  		mp->m_features &= ~XFS_FEAT_DISCARD;
>  	}
>  
> -	if (xfs_has_metadir(mp))
> +	if (xfs_has_zoned(mp)) {
> +		if (!xfs_has_metadir(mp)) {
> +			xfs_alert(mp,
> +		"metadir feature required for zoned realtime devices.");
> +			error = -EINVAL;
> +			goto out_filestream_unmount;
> +		}
> +		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_ZONED);
> +	} else if (xfs_has_metadir(mp)) {
>  		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_METADIR);
> +	}
>  
>  	if (xfs_has_reflink(mp)) {
>  		if (xfs_has_realtime(mp) &&
> -- 
> 2.45.2
> 
> 

