Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CED73938C3
	for <lists+linux-xfs@lfdr.de>; Fri, 28 May 2021 00:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbhE0Wkx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 May 2021 18:40:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233203AbhE0Wkx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 18:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC646610C9;
        Thu, 27 May 2021 22:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622155159;
        bh=QgpjdwKT7TBjVp4Cs3yjBh5guHzr4nZyNMxDIw4K+J0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=frhTNI2rzylDYDIYR8P1k6l+q1t1J0DzhMs9sUtGp3P4Bil4igX6sjBPHzmeBThex
         8yL9oLZUqZ7vsijsK01wwY/2A8gF5UoaKhD4/MSXIgMzPKJyiVXLNiD6WPNQoDqekd
         qylY6JMbnzTGTZMjXSoJzQ/dQz5UdkBHsX6RX6RPGKu6qXwgd2zdTGXFX91G04HBPN
         S78hRQc6vc0yW4sXY87Y3cOsV1GuepSnLI5fe9CItYdQa/xbi5ga+V2w5ZESFMcitf
         f4e58qPKZxft3ORkO607rIuyj0gs2oqi6R5CCNungPakQIwzA5noSReoU5RoTdSe4l
         qR11AQ4YP/7Eg==
Date:   Thu, 27 May 2021 15:39:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/23] xfs: clean up and simplify xfs_dialloc()
Message-ID: <20210527223919.GZ2402049@locust>
References: <20210519012102.450926-1-david@fromorbit.com>
 <20210519012102.450926-22-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519012102.450926-22-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 11:21:00AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because it's a mess.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks much cleaner now!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 268 +++++++++++++++++++++----------------
>  1 file changed, 153 insertions(+), 115 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 88c15d8bd6e4..63a1b6d422cc 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -604,9 +604,10 @@ xfs_inobt_insert_sprec(
>  }
>  
>  /*
> - * Allocate new inodes in the allocation group specified by agbp.
> - * Returns 0 if inodes were allocated in this AG; 1 if there was no space
> - * in this AG; or the usual negative error code.
> + * Allocate new inodes in the allocation group specified by agbp.  Returns 0 if
> + * inodes were allocated in this AG; -EAGAIN if there was no space in this AG so
> + * the caller knows it can try another AG, a hard -ENOSPC when over the maximum
> + * inode count threshold, or the usual negative error code for other errors.
>   */
>  STATIC int
>  xfs_ialloc_ag_alloc(
> @@ -792,7 +793,7 @@ xfs_ialloc_ag_alloc(
>  	}
>  
>  	if (args.fsbno == NULLFSBLOCK)
> -		return 1;
> +		return -EAGAIN;
>  
>  	ASSERT(args.len == args.minlen);
>  
> @@ -1568,14 +1569,17 @@ xfs_dialloc_roll(
>  	/* Re-attach the quota info that we detached from prev trx. */
>  	tp->t_dqinfo = dqinfo;
>  
> -	*tpp = tp;
> -	if (error)
> -		return error;
> +	/*
> +	 * Join the buffer even on commit error so that the buffer is released
> +	 * when the caller cancels the transaction and doesn't have to handle
> +	 * this error case specially.
> +	 */
>  	xfs_trans_bjoin(tp, agibp);
> -	return 0;
> +	*tpp = tp;
> +	return error;
>  }
>  
> -STATIC xfs_agnumber_t
> +static xfs_agnumber_t
>  xfs_ialloc_next_ag(
>  	xfs_mount_t	*mp)
>  {
> @@ -1590,16 +1594,136 @@ xfs_ialloc_next_ag(
>  	return agno;
>  }
>  
> +static bool
> +xfs_dialloc_good_ag(
> +	struct xfs_trans	*tp,
> +	struct xfs_perag	*pag,
> +	umode_t			mode,
> +	int			flags,
> +	bool			ok_alloc)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	xfs_extlen_t		ineed;
> +	xfs_extlen_t		longest = 0;
> +	int			needspace;
> +	int			error;
> +
> +	if (!pag->pagi_inodeok)
> +		return false;
> +
> +	if (!pag->pagi_init) {
> +		error = xfs_ialloc_pagi_init(mp, tp, pag->pag_agno);
> +		if (error)
> +			return false;
> +	}
> +
> +	if (pag->pagi_freecount)
> +		return true;
> +	if (!ok_alloc)
> +		return false;
> +
> +	if (!pag->pagf_init) {
> +		error = xfs_alloc_pagf_init(mp, tp, pag->pag_agno, flags);
> +		if (error)
> +			return false;
> +	}
> +
> +	/*
> +	 * Check that there is enough free space for the file plus a chunk of
> +	 * inodes if we need to allocate some. If this is the first pass across
> +	 * the AGs, take into account the potential space needed for alignment
> +	 * of inode chunks when checking the longest contiguous free space in
> +	 * the AG - this prevents us from getting ENOSPC because we have free
> +	 * space larger than ialloc_blks but alignment constraints prevent us
> +	 * from using it.
> +	 *
> +	 * If we can't find an AG with space for full alignment slack to be
> +	 * taken into account, we must be near ENOSPC in all AGs.  Hence we
> +	 * don't include alignment for the second pass and so if we fail
> +	 * allocation due to alignment issues then it is most likely a real
> +	 * ENOSPC condition.
> +	 *
> +	 * XXX(dgc): this calculation is now bogus thanks to the per-ag
> +	 * reservations that xfs_alloc_fix_freelist() now does via
> +	 * xfs_alloc_space_available(). When the AG fills up, pagf_freeblks will
> +	 * be more than large enough for the check below to succeed, but
> +	 * xfs_alloc_space_available() will fail because of the non-zero
> +	 * metadata reservation and hence we won't actually be able to allocate
> +	 * more inodes in this AG. We do soooo much unnecessary work near ENOSPC
> +	 * because of this.
> +	 */
> +	ineed = M_IGEO(mp)->ialloc_min_blks;
> +	if (flags && ineed > 1)
> +		ineed += M_IGEO(mp)->cluster_align;
> +	longest = pag->pagf_longest;
> +	if (!longest)
> +		longest = pag->pagf_flcount > 0;
> +	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
> +
> +	if (pag->pagf_freeblks < needspace + ineed || longest < ineed)
> +		return false;
> +	return true;
> +}
> +
> +static int
> +xfs_dialloc_try_ag(
> +	struct xfs_trans	**tpp,
> +	struct xfs_perag	*pag,
> +	xfs_ino_t		parent,
> +	xfs_ino_t		*new_ino,
> +	bool			ok_alloc)
> +{
> +	struct xfs_buf		*agbp;
> +	xfs_ino_t		ino;
> +	int			error;
> +
> +	/*
> +	 * Then read in the AGI buffer and recheck with the AGI buffer
> +	 * lock held.
> +	 */
> +	error = xfs_ialloc_read_agi(pag->pag_mount, *tpp, pag->pag_agno, &agbp);
> +	if (error)
> +		return error;
> +
> +	if (!pag->pagi_freecount) {
> +		if (!ok_alloc) {
> +			error = -EAGAIN;
> +			goto out_release;
> +		}
> +
> +		error = xfs_ialloc_ag_alloc(*tpp, agbp, pag);
> +		if (error < 0)
> +			goto out_release;
> +
> +		/*
> +		 * We successfully allocated space for an inode cluster in this
> +		 * AG.  Roll the transaction so that we can allocate one of the
> +		 * new inodes.
> +		 */
> +		ASSERT(pag->pagi_freecount > 0);
> +		error = xfs_dialloc_roll(tpp, agbp);
> +		if (error)
> +			goto out_release;
> +	}
> +
> +	/* Allocate an inode in the found AG */
> +	error = xfs_dialloc_ag(*tpp, agbp, pag, parent, &ino);
> +	if (!error)
> +		*new_ino = ino;
> +	return error;
> +
> +out_release:
> +	xfs_trans_brelse(*tpp, agbp);
> +	return error;
> +}
> +
>  /*
> - * Select and prepare an AG for inode allocation.
> + * Allocate an on-disk inode.
>   *
>   * Mode is used to tell whether the new inode is a directory and hence where to
> - * locate it.
> - *
> - * This function will ensure that the selected AG has free inodes available to
> - * allocate from. The selected AGI will be returned locked to the caller, and it
> - * will allocate more free inodes if required. If no free inodes are found or
> - * can be allocated, -ENOSPC be returned.
> + * locate it. The on-disk inode that is allocated will be returned in @new_ino
> + * on success, otherwise an error will be set to indicate the failure (e.g.
> + * -ENOSPC).
>   */
>  int
>  xfs_dialloc(
> @@ -1609,14 +1733,12 @@ xfs_dialloc(
>  	xfs_ino_t		*new_ino)
>  {
>  	struct xfs_mount	*mp = (*tpp)->t_mountp;
> -	struct xfs_buf		*agbp;
>  	xfs_agnumber_t		agno;
>  	int			error = 0;
>  	xfs_agnumber_t		start_agno;
>  	struct xfs_perag	*pag;
>  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> -	bool			okalloc = true;
> -	int			needspace;
> +	bool			ok_alloc = true;
>  	int			flags;
>  	xfs_ino_t		ino;
>  
> @@ -1625,7 +1747,6 @@ xfs_dialloc(
>  	 * one block, so factor that potential expansion when we examine whether
>  	 * an AG has enough space for file creation.
>  	 */
> -	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
>  	if (S_ISDIR(mode))
>  		start_agno = xfs_ialloc_next_ag(mp);
>  	else {
> @@ -1636,7 +1757,7 @@ xfs_dialloc(
>  
>  	/*
>  	 * If we have already hit the ceiling of inode blocks then clear
> -	 * okalloc so we scan all available agi structures for a free
> +	 * ok_alloc so we scan all available agi structures for a free
>  	 * inode.
>  	 *
>  	 * Read rough value of mp->m_icount by percpu_counter_read_positive,
> @@ -1645,7 +1766,7 @@ xfs_dialloc(
>  	if (igeo->maxicount &&
>  	    percpu_counter_read_positive(&mp->m_icount) + igeo->ialloc_inos
>  							> igeo->maxicount) {
> -		okalloc = false;
> +		ok_alloc = false;
>  	}
>  
>  	/*
> @@ -1656,93 +1777,14 @@ xfs_dialloc(
>  	agno = start_agno;
>  	flags = XFS_ALLOC_FLAG_TRYLOCK;
>  	for (;;) {
> -		xfs_extlen_t	ineed;
> -		xfs_extlen_t	longest = 0;
> -
>  		pag = xfs_perag_get(mp, agno);
> -		if (!pag->pagi_inodeok)
> -			goto nextag;
> -
> -		if (!pag->pagi_init) {
> -			error = xfs_ialloc_pagi_init(mp, *tpp, agno);
> -			if (error)
> -				break;
> -		}
> -
> -		if (!pag->pagi_freecount && !okalloc)
> -			goto nextag;
> -
> -		if (!pag->pagf_init) {
> -			error = xfs_alloc_pagf_init(mp, *tpp, agno, flags);
> -			if (error)
> -				goto nextag;
> -		}
> -
> -		/*
> -		 * Check that there is enough free space for the file plus a
> -		 * chunk of inodes if we need to allocate some. If this is the
> -		 * first pass across the AGs, take into account the potential
> -		 * space needed for alignment of inode chunks when checking the
> -		 * longest contiguous free space in the AG - this prevents us
> -		 * from getting ENOSPC because we have free space larger than
> -		 * ialloc_blks but alignment constraints prevent us from using
> -		 * it.
> -		 *
> -		 * If we can't find an AG with space for full alignment slack to
> -		 * be taken into account, we must be near ENOSPC in all AGs.
> -		 * Hence we don't include alignment for the second pass and so
> -		 * if we fail allocation due to alignment issues then it is most
> -		 * likely a real ENOSPC condition.
> -		 */
> -		ineed = M_IGEO(mp)->ialloc_min_blks;
> -		if (flags && ineed > 1)
> -			ineed += M_IGEO(mp)->cluster_align;
> -		longest = pag->pagf_longest;
> -		if (!longest)
> -			longest = pag->pagf_flcount > 0;
> -
> -		if (pag->pagf_freeblks < needspace + ineed || longest < ineed)
> -			goto nextag;
> -
> -		/*
> -		 * Then read in the AGI buffer and recheck with the AGI buffer
> -		 * lock held.
> -		 */
> -		error = xfs_ialloc_read_agi(mp, *tpp, agno, &agbp);
> -		if (error)
> -			break;
> -
> -		if (pag->pagi_freecount)
> -			goto found_ag;
> -
> -		if (!okalloc)
> -			goto nextag_relse_buffer;
> -
> -		error = xfs_ialloc_ag_alloc(*tpp, agbp, pag);
> -		if (error < 0) {
> -			xfs_trans_brelse(*tpp, agbp);
> -			break;
> -		}
> -
> -		if (error == 0) {
> -			/*
> -			 * We successfully allocated space for an inode cluster
> -			 * in this AG.  Roll the transaction so that we can
> -			 * allocate one of the new inodes.
> -			 */
> -			ASSERT(pag->pagi_freecount > 0);
> -
> -			error = xfs_dialloc_roll(tpp, agbp);
> -			if (error) {
> -				xfs_buf_relse(agbp);
> +		if (xfs_dialloc_good_ag(*tpp, pag, mode, flags, ok_alloc)) {
> +			error = xfs_dialloc_try_ag(tpp, pag, parent,
> +					&ino, ok_alloc);
> +			if (error != -EAGAIN)
>  				break;
> -			}
> -			goto found_ag;
>  		}
>  
> -nextag_relse_buffer:
> -		xfs_trans_brelse(*tpp, agbp);
> -nextag:
>  		if (XFS_FORCED_SHUTDOWN(mp)) {
>  			error = -EFSCORRUPTED;
>  			break;
> @@ -1750,23 +1792,19 @@ xfs_dialloc(
>  		if (++agno == mp->m_maxagi)
>  			agno = 0;
>  		if (agno == start_agno) {
> -			if (!flags)
> +			if (!flags) {
> +				error = -ENOSPC;
>  				break;
> +			}
>  			flags = 0;
>  		}
>  		xfs_perag_put(pag);
>  	}
>  
> +	if (!error)
> +		*new_ino = ino;
>  	xfs_perag_put(pag);
> -	return error ? error : -ENOSPC;
> -found_ag:
> -	/* Allocate an inode in the found AG */
> -	error = xfs_dialloc_ag(*tpp, agbp, pag, parent, &ino);
> -	xfs_perag_put(pag);
> -	if (error)
> -		return error;
> -	*new_ino = ino;
> -	return 0;
> +	return error;
>  }
>  
>  /*
> -- 
> 2.31.1
> 
