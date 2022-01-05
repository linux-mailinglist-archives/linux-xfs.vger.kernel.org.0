Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FC3484BFC
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jan 2022 02:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236780AbiAEBNl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jan 2022 20:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235704AbiAEBNk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 20:13:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10B5C061761
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 17:13:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF786B81846
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 01:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83385C36AEF;
        Wed,  5 Jan 2022 01:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641345217;
        bh=1Et046Q49cDvzkLuQQp1oewEVhDUvSPsvZ2g50imYFE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=siCeO4UsSL9In2GxTcmtvk2YCAKRQeDrOXSAzY3lBylXEP3Dg3CzBMIu80sCwk6Vm
         SGKlzCFsMIuRddtxtiHEVPCpZiq2L2d4b/5xwmkQgCXyuRQ8tJd0ovfjlL77nq1hvK
         mkj/Yyx009KS9DZntjR4INxmO8Dqd+S8bPiWWxcngS6aiGdYdVTatME0EO+uYP4dZc
         MBmdmP1dEeuhvTtiRahEdSmcmN9EYatRSMToXnNdhoqWyjyi3JDjT7PqoItnhE1f5F
         Z0R9IRqF0xiSlQWEuH+/S/VQNMnbzGn6tzJXvKMG3XPJrRAWZEEXnzmQZzdGlNPxn5
         kjXw3PQG0ufIQ==
Date:   Tue, 4 Jan 2022 17:13:37 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 15/20] xfsprogs: Enable bulkstat ioctl to support
 64-bit extent counters
Message-ID: <20220105011337.GC656707@magnolia>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
 <20211214084811.764481-16-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084811.764481-16-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:18:06PM +0530, Chandan Babu R wrote:
> This commit adds support to libfrog to enable reporting 64-bit extent counters
> to its users. In order to do so, bulkstat ioctl is now invoked with the newly
> introduced XFS_BULK_IREQ_NREXT64 flag if the underlying filesystem's geometry
> supports 64-bit extent counters.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

For all the non libxfs/ changes,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fsr/xfs_fsr.c      |  4 ++--
>  io/bulkstat.c      |  1 +
>  libfrog/bulkstat.c | 29 +++++++++++++++++++++++++++--
>  libxfs/xfs_fs.h    | 12 ++++++++----
>  4 files changed, 38 insertions(+), 8 deletions(-)
> 
> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> index 6cf8bfb7..ba02506d 100644
> --- a/fsr/xfs_fsr.c
> +++ b/fsr/xfs_fsr.c
> @@ -590,7 +590,7 @@ cmp(const void *s1, const void *s2)
>  		(bs1->bs_version == XFS_BULKSTAT_VERSION_V5 &&
>  		bs2->bs_version == XFS_BULKSTAT_VERSION_V5));
>  
> -	return (bs2->bs_extents - bs1->bs_extents);
> +	return (bs2->bs_extents64 - bs1->bs_extents64);
>  }
>  
>  /*
> @@ -655,7 +655,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
>  		for (p = buf, endp = (buf + buflenout); p < endp ; p++) {
>  			/* Do some obvious checks now */
>  			if (((p->bs_mode & S_IFMT) != S_IFREG) ||
> -			     (p->bs_extents < 2))
> +			     (p->bs_extents64 < 2))
>  				continue;
>  
>  			ret = -xfrog_bulkstat_v5_to_v1(&fsxfd, &bs1, p);
> diff --git a/io/bulkstat.c b/io/bulkstat.c
> index 201470b2..0c9a2b02 100644
> --- a/io/bulkstat.c
> +++ b/io/bulkstat.c
> @@ -57,6 +57,7 @@ dump_bulkstat(
>  	printf("\tbs_sick = 0x%"PRIx16"\n", bstat->bs_sick);
>  	printf("\tbs_checked = 0x%"PRIx16"\n", bstat->bs_checked);
>  	printf("\tbs_mode = 0%"PRIo16"\n", bstat->bs_mode);
> +	printf("\tbs_extents64 = %"PRIu64"\n", bstat->bs_extents64);
>  };
>  
>  static void
> diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
> index 195f6ea0..0a90947f 100644
> --- a/libfrog/bulkstat.c
> +++ b/libfrog/bulkstat.c
> @@ -56,6 +56,9 @@ xfrog_bulkstat_single5(
>  	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
>  		return -EINVAL;
>  
> +	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
> +		flags |= XFS_BULK_IREQ_NREXT64;
> +
>  	ret = xfrog_bulkstat_alloc_req(1, ino, &req);
>  	if (ret)
>  		return ret;
> @@ -73,6 +76,12 @@ xfrog_bulkstat_single5(
>  	}
>  
>  	memcpy(bulkstat, req->bulkstat, sizeof(struct xfs_bulkstat));
> +
> +	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)) {
> +		bulkstat->bs_extents64 = bulkstat->bs_extents;
> +		bulkstat->bs_extents = 0;
> +	}
> +
>  free:
>  	free(req);
>  	return ret;
> @@ -129,6 +138,7 @@ xfrog_bulkstat_single(
>  	switch (error) {
>  	case -EOPNOTSUPP:
>  	case -ENOTTY:
> +		assert(!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64));
>  		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
>  		break;
>  	}
> @@ -259,10 +269,23 @@ xfrog_bulkstat5(
>  	struct xfs_bulkstat_req	*req)
>  {
>  	int			ret;
> +	int			i;
> +
> +	if (xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)
> +		req->hdr.flags |= XFS_BULK_IREQ_NREXT64;
>  
>  	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT, req);
>  	if (ret)
>  		return -errno;
> +
> +	if (!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64)) {
> +		for (i = 0; i < req->hdr.ocount; i++) {
> +			req->bulkstat[i].bs_extents64 =
> +				req->bulkstat[i].bs_extents;
> +			req->bulkstat[i].bs_extents = 0;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> @@ -316,6 +339,7 @@ xfrog_bulkstat(
>  	switch (error) {
>  	case -EOPNOTSUPP:
>  	case -ENOTTY:
> +		assert(!(xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_NREXT64));
>  		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
>  		break;
>  	}
> @@ -342,6 +366,7 @@ xfrog_bulkstat_v5_to_v1(
>  	const struct xfs_bulkstat	*bs5)
>  {
>  	if (bs5->bs_aextents > UINT16_MAX ||
> +	    bs5->bs_extents64 > INT32_MAX ||
>  	    cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks) > UINT32_MAX ||
>  	    cvt_off_fsb_to_b(xfd, bs5->bs_cowextsize_blks) > UINT32_MAX ||
>  	    time_too_big(bs5->bs_atime) ||
> @@ -366,7 +391,7 @@ xfrog_bulkstat_v5_to_v1(
>  	bs1->bs_blocks = bs5->bs_blocks;
>  	bs1->bs_xflags = bs5->bs_xflags;
>  	bs1->bs_extsize = cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks);
> -	bs1->bs_extents = bs5->bs_extents;
> +	bs1->bs_extents = bs5->bs_extents64;
>  	bs1->bs_gen = bs5->bs_gen;
>  	bs1->bs_projid_lo = bs5->bs_projectid & 0xFFFF;
>  	bs1->bs_forkoff = bs5->bs_forkoff;
> @@ -407,7 +432,6 @@ xfrog_bulkstat_v1_to_v5(
>  	bs5->bs_blocks = bs1->bs_blocks;
>  	bs5->bs_xflags = bs1->bs_xflags;
>  	bs5->bs_extsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_extsize);
> -	bs5->bs_extents = bs1->bs_extents;
>  	bs5->bs_gen = bs1->bs_gen;
>  	bs5->bs_projectid = bstat_get_projid(bs1);
>  	bs5->bs_forkoff = bs1->bs_forkoff;
> @@ -415,6 +439,7 @@ xfrog_bulkstat_v1_to_v5(
>  	bs5->bs_checked = bs1->bs_checked;
>  	bs5->bs_cowextsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_cowextsize);
>  	bs5->bs_aextents = bs1->bs_aextents;
> +	bs5->bs_extents64 = bs1->bs_extents;
>  }
>  
>  /* Allocate a bulkstat request.  Returns zero or a negative error code. */
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index 7260b140..6a9e51ac 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -391,7 +391,7 @@ struct xfs_bulkstat {
>  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>  
>  	uint32_t	bs_nlink;	/* number of links		*/
> -	uint32_t	bs_extents;	/* number of extents		*/
> +	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
>  	uint32_t	bs_aextents;	/* attribute number of extents	*/
>  	uint16_t	bs_version;	/* structure version		*/
>  	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
> @@ -400,8 +400,9 @@ struct xfs_bulkstat {
>  	uint16_t	bs_checked;	/* checked inode metadata	*/
>  	uint16_t	bs_mode;	/* type and mode		*/
>  	uint16_t	bs_pad2;	/* zeroed			*/
> +	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
>  
> -	uint64_t	bs_pad[7];	/* zeroed			*/
> +	uint64_t	bs_pad[6];	/* zeroed			*/
>  };
>  
>  #define XFS_BULKSTAT_VERSION_V1	(1)
> @@ -482,8 +483,11 @@ struct xfs_bulk_ireq {
>   */
>  #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
>  
> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
> -				 XFS_BULK_IREQ_SPECIAL)
> +#define XFS_BULK_IREQ_NREXT64	(1 << 3)
> +
> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
> +				 XFS_BULK_IREQ_SPECIAL | \
> +				 XFS_BULK_IREQ_NREXT64)
>  
>  /* Operate on the root directory inode. */
>  #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
> -- 
> 2.30.2
> 
