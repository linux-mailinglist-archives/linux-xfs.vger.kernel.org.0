Return-Path: <linux-xfs+bounces-312-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF49E7FFAA7
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 20:01:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85FA3281880
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 19:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560A45FEF5;
	Thu, 30 Nov 2023 19:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LtpRvOLb"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178315FEE1
	for <linux-xfs@vger.kernel.org>; Thu, 30 Nov 2023 19:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D1ACC433C7;
	Thu, 30 Nov 2023 19:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701370883;
	bh=mrQTm2/X3bNSt7Um/8oj1SlRbeIm1qp56xkDGGk6vZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LtpRvOLbxzuM9+T7wChsLRxkoWLmlRHSuhamm/cm+uImj8aiTKd1mbpS1L6+hinSF
	 +iNyCj1PClAmM/v1fVCmJGkHI3rli9TB+OtV3+FCVBYYXE9gL4zo/IQ//emX0sij+S
	 K/tTriiGbay61VRch0RwgO9G3tkh6TVGhnvEXTTsaVwrM5JjK+qWj/g/JC4c1L63cb
	 Zd1JifYSTxgm4n5tulghabJ0TMoO7WtOxkpfpT2m+iNx8gGiKtXI0ECmYudI4FmbBC
	 XxUI9xCnBj8d0ZgZTDlpn/OXYXYXhIRUzEwbWDgxVt5IbJh8pBvdTtVtHLeavN51Wp
	 tJNBPStIGf9jg==
Date: Thu, 30 Nov 2023 11:01:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, xieyongji@bytedance.com, me@jcix.top,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 1/3] xfs: ensure logflagsp is initialized in
 xfs_bmap_del_extent_real
Message-ID: <20231130190120.GM361584@frogsfrogsfrogs>
References: <20231130040516.35677-1-zhangjiachen.jaycee@bytedance.com>
 <20231130040516.35677-2-zhangjiachen.jaycee@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130040516.35677-2-zhangjiachen.jaycee@bytedance.com>

On Thu, Nov 30, 2023 at 12:05:14PM +0800, Jiachen Zhang wrote:
> In the case of returning -ENOSPC, ensure logflagsp is initialized by 0.
> Otherwise the caller __xfs_bunmapi will set uninitialized illegal
> tmp_logflags value into xfs log, which might cause unpredictable error
> in the log recovery procedure.
> 
> Also, remove the flags variable and set the *logflagsp directly, so that
> the code should be more robust in the long run.
> 
> Fixes: 1b24b633aafe ("xfs: move some more code into xfs_bmap_del_extent_real")
> Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 73 +++++++++++++++++-----------------------
>  1 file changed, 31 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index be62acffad6c..eacd7f43c952 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5010,7 +5010,6 @@ xfs_bmap_del_extent_real(
>  	xfs_fileoff_t		del_endoff;	/* first offset past del */
>  	int			do_fx;	/* free extent at end of routine */
>  	int			error;	/* error return value */
> -	int			flags = 0;/* inode logging flags */
>  	struct xfs_bmbt_irec	got;	/* current extent entry */
>  	xfs_fileoff_t		got_endoff;	/* first offset past got */
>  	int			i;	/* temp state */
> @@ -5023,6 +5022,8 @@ xfs_bmap_del_extent_real(
>  	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
>  	struct xfs_bmbt_irec	old;
>  
> +	*logflagsp = 0;
> +
>  	mp = ip->i_mount;
>  	XFS_STATS_INC(mp, xs_del_exlist);
>  
> @@ -5035,7 +5036,6 @@ xfs_bmap_del_extent_real(
>  	ASSERT(got_endoff >= del_endoff);
>  	ASSERT(!isnullstartblock(got.br_startblock));
>  	qfield = 0;
> -	error = 0;
>  
>  	/*
>  	 * If it's the case where the directory code is running with no block
> @@ -5051,13 +5051,13 @@ xfs_bmap_del_extent_real(
>  	    del->br_startoff > got.br_startoff && del_endoff < got_endoff)
>  		return -ENOSPC;
>  
> -	flags = XFS_ILOG_CORE;
> +	*logflagsp = XFS_ILOG_CORE;
>  	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
>  		if (!(bflags & XFS_BMAPI_REMAP)) {
>  			error = xfs_rtfree_blocks(tp, del->br_startblock,
>  					del->br_blockcount);
>  			if (error)
> -				goto done;
> +				return error;
>  		}
>  
>  		do_fx = 0;
> @@ -5072,11 +5072,9 @@ xfs_bmap_del_extent_real(
>  	if (cur) {
>  		error = xfs_bmbt_lookup_eq(cur, &got, &i);
>  		if (error)
> -			goto done;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			error = -EFSCORRUPTED;
> -			goto done;
> -		}
> +			return error;
> +		if (XFS_IS_CORRUPT(mp, i != 1))
> +			return -EFSCORRUPTED;
>  	}
>  
>  	if (got.br_startoff == del->br_startoff)
> @@ -5093,17 +5091,15 @@ xfs_bmap_del_extent_real(
>  		xfs_iext_prev(ifp, icur);
>  		ifp->if_nextents--;
>  
> -		flags |= XFS_ILOG_CORE;
> +		*logflagsp |= XFS_ILOG_CORE;
>  		if (!cur) {
> -			flags |= xfs_ilog_fext(whichfork);
> +			*logflagsp |= xfs_ilog_fext(whichfork);
>  			break;
>  		}
>  		if ((error = xfs_btree_delete(cur, &i)))
> -			goto done;
> -		if (XFS_IS_CORRUPT(mp, i != 1)) {
> -			error = -EFSCORRUPTED;
> -			goto done;
> -		}
> +			return error;
> +		if (XFS_IS_CORRUPT(mp, i != 1))
> +			return -EFSCORRUPTED;
>  		break;
>  	case BMAP_LEFT_FILLING:
>  		/*
> @@ -5114,12 +5110,12 @@ xfs_bmap_del_extent_real(
>  		got.br_blockcount -= del->br_blockcount;
>  		xfs_iext_update_extent(ip, state, icur, &got);
>  		if (!cur) {
> -			flags |= xfs_ilog_fext(whichfork);
> +			*logflagsp |= xfs_ilog_fext(whichfork);
>  			break;
>  		}
>  		error = xfs_bmbt_update(cur, &got);
>  		if (error)
> -			goto done;
> +			return error;
>  		break;
>  	case BMAP_RIGHT_FILLING:
>  		/*
> @@ -5128,12 +5124,12 @@ xfs_bmap_del_extent_real(
>  		got.br_blockcount -= del->br_blockcount;
>  		xfs_iext_update_extent(ip, state, icur, &got);
>  		if (!cur) {
> -			flags |= xfs_ilog_fext(whichfork);
> +			*logflagsp |= xfs_ilog_fext(whichfork);
>  			break;
>  		}
>  		error = xfs_bmbt_update(cur, &got);
>  		if (error)
> -			goto done;
> +			return error;
>  		break;
>  	case 0:
>  		/*
> @@ -5150,18 +5146,18 @@ xfs_bmap_del_extent_real(
>  		new.br_state = got.br_state;
>  		new.br_startblock = del_endblock;
>  
> -		flags |= XFS_ILOG_CORE;
> +		*logflagsp |= XFS_ILOG_CORE;
>  		if (cur) {
>  			error = xfs_bmbt_update(cur, &got);
>  			if (error)
> -				goto done;
> +				return error;
>  			error = xfs_btree_increment(cur, 0, &i);
>  			if (error)
> -				goto done;
> +				return error;
>  			cur->bc_rec.b = new;
>  			error = xfs_btree_insert(cur, &i);
>  			if (error && error != -ENOSPC)
> -				goto done;
> +				return error;
>  			/*
>  			 * If get no-space back from btree insert, it tried a
>  			 * split, and we have a zero block reservation.  Fix up
> @@ -5174,33 +5170,28 @@ xfs_bmap_del_extent_real(
>  				 */
>  				error = xfs_bmbt_lookup_eq(cur, &got, &i);
>  				if (error)
> -					goto done;
> -				if (XFS_IS_CORRUPT(mp, i != 1)) {
> -					error = -EFSCORRUPTED;
> -					goto done;
> -				}
> +					return error;
> +				if (XFS_IS_CORRUPT(mp, i != 1))
> +					return -EFSCORRUPTED;
>  				/*
>  				 * Update the btree record back
>  				 * to the original value.
>  				 */
>  				error = xfs_bmbt_update(cur, &old);
>  				if (error)
> -					goto done;
> +					return error;
>  				/*
>  				 * Reset the extent record back
>  				 * to the original value.
>  				 */
>  				xfs_iext_update_extent(ip, state, icur, &old);
> -				flags = 0;
> -				error = -ENOSPC;
> -				goto done;
> -			}
> -			if (XFS_IS_CORRUPT(mp, i != 1)) {
> -				error = -EFSCORRUPTED;
> -				goto done;
> +				*logflagsp = 0;
> +				return -ENOSPC;
>  			}
> +			if (XFS_IS_CORRUPT(mp, i != 1))
> +				return -EFSCORRUPTED;
>  		} else
> -			flags |= xfs_ilog_fext(whichfork);
> +			*logflagsp |= xfs_ilog_fext(whichfork);
>  
>  		ifp->if_nextents++;
>  		xfs_iext_next(ifp, icur);
> @@ -5224,7 +5215,7 @@ xfs_bmap_del_extent_real(
>  					((bflags & XFS_BMAPI_NODISCARD) ||
>  					del->br_state == XFS_EXT_UNWRITTEN));
>  			if (error)
> -				goto done;
> +				return error;
>  		}
>  	}
>  
> @@ -5239,9 +5230,7 @@ xfs_bmap_del_extent_real(
>  	if (qfield && !(bflags & XFS_BMAPI_REMAP))
>  		xfs_trans_mod_dquot_byino(tp, ip, qfield, (long)-nblks);
>  
> -done:
> -	*logflagsp = flags;
> -	return error;
> +	return 0;
>  }
>  
>  /*
> -- 
> 2.20.1
> 
> 

