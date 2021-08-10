Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8F53D8232
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jul 2021 23:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhG0V4N (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Jul 2021 17:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232022AbhG0V4M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 17:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3198360E78;
        Tue, 27 Jul 2021 21:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627422972;
        bh=muytySc6rL35qm4Ob1t2SONKYh0eAQ2oYOHmd83ZBvY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jisuDCiGJq2SLkCGKvLE3hD/u0n8W+BZifo6eyKfoMOR6z6caKNKrKfhLP5kS9FNe
         6QimEgl4YU3M3X6yLTzh0NpV8mtuAZ2DVIYFJjIh6SdCQSwcB7fzNUjmDpyeDSKTlQ
         hMwYhICdJ1tOUt+nryVrbuzWW0focfFyGgeYfCSWBkM7wwTLAqrPWHBzRl+egaJnYs
         N6Q2Ip1zx1VfZdmP+ELN6pmCyjNvrSr1k52ACw8wg8KTdoNoUBpHXxjeM98MNTj8Y6
         4dLn2UCUT7GU7cR0TEpZnIisuygelb3vKfkVkjNUkW2YKogQuezyPc5SyqbiJkkswf
         xMhqkxEzEeU3g==
Date:   Tue, 27 Jul 2021 14:56:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 02/12] xfs: Rename MAXEXTNUM, MAXAEXTNUM to
 XFS_IFORK_EXTCNT_MAXS32, XFS_IFORK_EXTCNT_MAXS16
Message-ID: <20210727215611.GK559212@magnolia>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726114541.24898-3-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 26, 2021 at 05:15:31PM +0530, Chandan Babu R wrote:
> In preparation for introducing larger extent count limits, this commit renames
> existing extent count limits based on their signedness and width.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 4 ++--
>  fs/xfs/libxfs/xfs_format.h     | 8 ++++----
>  fs/xfs/libxfs/xfs_inode_buf.c  | 4 ++--
>  fs/xfs/libxfs/xfs_inode_fork.c | 3 ++-
>  fs/xfs/scrub/inode_repair.c    | 2 +-
>  5 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index f3c9a0ebb0a5..8f262405a5b5 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -76,10 +76,10 @@ xfs_bmap_compute_maxlevels(
>  	 * available.
>  	 */
>  	if (whichfork == XFS_DATA_FORK) {
> -		maxleafents = MAXEXTNUM;
> +		maxleafents = XFS_IFORK_EXTCNT_MAXS32;

I'm not in love with these names, since they tell me roughly about the
size of the constant (which I could glean from the definition) but less
about when I would expect to find them.  How about:

#define XFS_MAX_DFORK_NEXTENTS    ((xfs_extnum_t) 0x7FFFFFFF)
#define XFS_MAX_AFORK_NEXTENTS    ((xfs_aextnum_t)0x00007FFF)

and when we get to the iext64 feature (or whatever we end up calling it)
then we can define new ones:

#define XFS_MAX_DFORK_NEXTENTS64  ((xfs_extnum_t) 0xFFFFFFFFFFFF)
#define XFS_MAX_AFORK_NEXTENTS64  ((xfs_aextnum_t)0x0000FFFFFFFF)

or something like that.

>  		sz = xfs_bmdr_space_calc(MINDBTPTRS);
>  	} else {
> -		maxleafents = MAXAEXTNUM;
> +		maxleafents = XFS_IFORK_EXTCNT_MAXS16;
>  		sz = xfs_bmdr_space_calc(MINABTPTRS);
>  	}
>  	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 37cca918d2ba..920e3f9c418f 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1110,11 +1110,11 @@ enum xfs_dinode_fmt {
>  	{ XFS_DINODE_FMT_UUID,		"uuid" }
>  
>  /*
> - * Max values for extlen, extnum, aextnum.
> + * Max values for extlen and disk inode's extent counters.
>   */
> -#define	MAXEXTLEN	((uint32_t)0x001fffff)	/* 21 bits */

As for MAXEXTLEN... would you mind tacking a new patch on the end to fix
its definition as well?  It /really/ ought to be based on the disk
format definitions and not open-coded.

#define XFS_MAX_EXTLEN		((xfs_extlen_t)(1 << BMBT_BLOCKCOUNT_BITLEN) - 1)

--D

> -#define	MAXEXTNUM	((int32_t)0x7fffffff)	/* signed int */
> -#define	MAXAEXTNUM	((int16_t)0x7fff)	/* signed short */
> +#define	MAXEXTLEN		((uint32_t)0x1fffff) /* 21 bits */
> +#define XFS_IFORK_EXTCNT_MAXS32 ((int32_t)0x7fffffff)  /* Signed 32-bits */
> +#define XFS_IFORK_EXTCNT_MAXS16 ((int16_t)0x7fff)      /* Signed 16-bits */
>  
>  /*
>   * Inode minimum and maximum sizes.
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 5625df1ddd95..66d13e8fa420 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -365,9 +365,9 @@ xfs_dinode_verify_fork(
>  		break;
>  	case XFS_DINODE_FMT_BTREE:
>  		if (whichfork == XFS_ATTR_FORK) {
> -			if (di_nextents > MAXAEXTNUM)
> +			if (di_nextents > XFS_IFORK_EXTCNT_MAXS16)
>  				return __this_address;
> -		} else if (di_nextents > MAXEXTNUM) {
> +		} else if (di_nextents > XFS_IFORK_EXTCNT_MAXS32) {
>  			return __this_address;
>  		}
>  		break;
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 801a6f7dbd0c..6f4b14d3d381 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -736,7 +736,8 @@ xfs_iext_count_may_overflow(
>  	if (whichfork == XFS_COW_FORK)
>  		return 0;
>  
> -	max_exts = (whichfork == XFS_ATTR_FORK) ? MAXAEXTNUM : MAXEXTNUM;
> +	max_exts = (whichfork == XFS_ATTR_FORK) ?
> +		XFS_IFORK_EXTCNT_MAXS16 : XFS_IFORK_EXTCNT_MAXS32;
>  
>  	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
>  		max_exts = 10;
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index a80cd633fe59..c44f8d06939b 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c
> @@ -1198,7 +1198,7 @@ xrep_inode_blockcounts(
>  			return error;
>  		if (count >= sc->mp->m_sb.sb_dblocks)
>  			return -EFSCORRUPTED;
> -		if (nextents >= MAXAEXTNUM)
> +		if (nextents >= XFS_IFORK_EXTCNT_MAXS16)
>  			return -EFSCORRUPTED;
>  		ifp->if_nextents = nextents;
>  	} else {
> -- 
> 2.30.2
> 
