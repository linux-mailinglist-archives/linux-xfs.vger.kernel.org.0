Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12E7560B57
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jun 2022 23:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiF2VBy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jun 2022 17:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiF2VBx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 17:01:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827BB3E0FB
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 14:01:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12C34B82615
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 21:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C88C34114;
        Wed, 29 Jun 2022 21:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656536509;
        bh=anhLEJi7rjd1+SEfyUmn2WcyYolwTUKS81u1HC5rphU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kbMyRaB4iUTR0VZrzTY8m4G6E31uTNsxlVvBTYHgmF50ErtIcgRzt3RQ0kVij+Jx2
         urA37zIGumN2xwARAgm5BuLVikXBEE8/VFyaqDEIy7ThQQMXQmFKC9U/vaRVkhUnuX
         J6IfxBHpjY7/DymJ8uVA2JASwcglLYOcEiuJ7kV4s52Y7dqSfDUjOGZR2c3GSuAZw7
         oKBZiTmphX+fZYjsskcK3KnGCepF8Y+uIQaTAWcFctPDsmUTCfG2Y2DYhlRCh3ZCfP
         ohQSC3Th78xHBzx2cV5RNeHk97xK00vb/PKOkmKJ1VraZEkIuVCJiX0boe3j878DUP
         tVI/HP9GcHpNQ==
Date:   Wed, 29 Jun 2022 14:01:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: introduce xfs_iunlink_lookup
Message-ID: <Yry9vXHILs3LPl/u@magnolia>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627004336.217366-5-david@fromorbit.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 10:43:31AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When an inode is on an unlinked list during normal operation, it is
> guaranteed to be pinned in memory as it is either referenced by the
> current unlink operation or it has a open file descriptor that
> references it and has it pinned in memory. Hence to look up an inode
> on the unlinked list, we can do a direct inode cache lookup and
> always expect the lookup to succeed.
> 
> Add a function to do this lookup based on the agino that we use to
> link the chain of unlinked inodes together so we can begin the
> conversion the unlinked list manipulations to use in-memory inodes
> rather than inode cluster buffers and remove the backref cache.
> 
> Use this lookup function to replace the on-disk inode buffer walk
> when removing inodes from the unlinked list with an in-core inode
> unlinked list walk.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 165 +++++++++++++++++++--------------------------
>  1 file changed, 71 insertions(+), 94 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c507370bd885..e6ac13174062 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2006,6 +2006,39 @@ xfs_iunlink_destroy(
>  	ASSERT(freed_anything == false || xfs_is_shutdown(pag->pag_mount));
>  }
>  
> +/*
> + * Find an inode on the unlinked list. This does not take references to the
> + * inode, we have existence guarantees by holding the AGI buffer lock and that
> + * only unlinked, referenced inodes can be on the unlinked inode list.  If we
> + * don't find the inode in cache, then let the caller handle the situation.
> + */
> +static struct xfs_inode *
> +xfs_iunlink_lookup(
> +	struct xfs_perag	*pag,
> +	xfs_agino_t		agino)
> +{
> +	struct xfs_mount	*mp = pag->pag_mount;
> +	struct xfs_inode	*ip;
> +
> +	rcu_read_lock();
> +	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
> +
> +	/* Inode not in memory, nothing to do */
> +	if (!ip) {
> +		rcu_read_unlock();
> +		return NULL;

Does this mean that someone else already removed the inode from the
unlink list?  Which I guess happens if ... what?  We're slowly
processing the unlinked list and someone else reclaims something that we
thought was on that list?

(Oh, I see hch already asked about this.)

> +	}
> +	spin_lock(&ip->i_flags_lock);
> +	if (ip->i_ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino) ||
> +	    (ip->i_flags & (XFS_IRECLAIMABLE | XFS_IRECLAIM))) {
> +		/* Uh-oh! */
> +		ip = NULL;
> +	}
> +	spin_unlock(&ip->i_flags_lock);
> +	rcu_read_unlock();
> +	return ip;
> +}
> +
>  /*
>   * Point the AGI unlinked bucket at an inode and log the results.  The caller
>   * is responsible for validating the old value.
> @@ -2111,7 +2144,8 @@ xfs_iunlink_update_inode(
>  	 * current pointer is the same as the new value, unless we're
>  	 * terminating the list.
>  	 */
> -	*old_next_agino = old_value;
> +	if (old_next_agino)
> +		*old_next_agino = old_value;
>  	if (old_value == next_agino) {
>  		if (next_agino != NULLAGINO) {
>  			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> @@ -2217,38 +2251,6 @@ xfs_iunlink(
>  	return error;
>  }
>  
> -/* Return the imap, dinode pointer, and buffer for an inode. */
> -STATIC int
> -xfs_iunlink_map_ino(
> -	struct xfs_trans	*tp,
> -	xfs_agnumber_t		agno,
> -	xfs_agino_t		agino,
> -	struct xfs_imap		*imap,
> -	struct xfs_dinode	**dipp,
> -	struct xfs_buf		**bpp)
> -{
> -	struct xfs_mount	*mp = tp->t_mountp;
> -	int			error;
> -
> -	imap->im_blkno = 0;
> -	error = xfs_imap(mp, tp, XFS_AGINO_TO_INO(mp, agno, agino), imap, 0);
> -	if (error) {
> -		xfs_warn(mp, "%s: xfs_imap returned error %d.",
> -				__func__, error);
> -		return error;
> -	}
> -
> -	error = xfs_imap_to_bp(mp, tp, imap, bpp);
> -	if (error) {
> -		xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
> -				__func__, error);
> -		return error;
> -	}
> -
> -	*dipp = xfs_buf_offset(*bpp, imap->im_boffset);
> -	return 0;
> -}
> -
>  /*
>   * Walk the unlinked chain from @head_agino until we find the inode that
>   * points to @target_agino.  Return the inode number, map, dinode pointer,
> @@ -2259,77 +2261,51 @@ xfs_iunlink_map_ino(
>   *
>   * Do not call this function if @target_agino is the head of the list.
>   */
> -STATIC int
> -xfs_iunlink_map_prev(
> -	struct xfs_trans	*tp,
> +static int
> +xfs_iunlink_lookup_prev(
>  	struct xfs_perag	*pag,
>  	xfs_agino_t		head_agino,
>  	xfs_agino_t		target_agino,
> -	xfs_agino_t		*agino,
> -	struct xfs_imap		*imap,
> -	struct xfs_dinode	**dipp,
> -	struct xfs_buf		**bpp)
> +	struct xfs_inode	**ipp)
>  {
> -	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_mount	*mp = pag->pag_mount;
> +	struct xfs_inode	*ip;
>  	xfs_agino_t		next_agino;
> -	int			error;
>  
> -	ASSERT(head_agino != target_agino);
> -	*bpp = NULL;
> +	*ipp = NULL;
>  
>  	/* See if our backref cache can find it faster. */
> -	*agino = xfs_iunlink_lookup_backref(pag, target_agino);
> -	if (*agino != NULLAGINO) {
> -		error = xfs_iunlink_map_ino(tp, pag->pag_agno, *agino, imap,
> -				dipp, bpp);
> -		if (error)
> -			return error;
> -
> -		if (be32_to_cpu((*dipp)->di_next_unlinked) == target_agino)
> +	next_agino = xfs_iunlink_lookup_backref(pag, target_agino);
> +	if (next_agino != NULLAGINO) {
> +		ip = xfs_iunlink_lookup(pag, next_agino);
> +		if (ip && ip->i_next_unlinked == target_agino) {
> +			*ipp = ip;
>  			return 0;
> -
> -		/*
> -		 * If we get here the cache contents were corrupt, so drop the
> -		 * buffer and fall back to walking the bucket list.
> -		 */
> -		xfs_trans_brelse(tp, *bpp);
> -		*bpp = NULL;
> -		WARN_ON_ONCE(1);
> +		}
>  	}
>  
> -	trace_xfs_iunlink_map_prev_fallback(mp, pag->pag_agno);

Might want to remove this tracepoint from xfs_trace.h.  The rest looks
ok though.

--D

> -
>  	/* Otherwise, walk the entire bucket until we find it. */
>  	next_agino = head_agino;
> -	while (next_agino != target_agino) {
> -		xfs_agino_t	unlinked_agino;
> +	while (next_agino != NULLAGINO) {
> +		ip = xfs_iunlink_lookup(pag, next_agino);
> +		if (!ip)
> +			return -EFSCORRUPTED;
>  
> -		if (*bpp)
> -			xfs_trans_brelse(tp, *bpp);
> -
> -		*agino = next_agino;
> -		error = xfs_iunlink_map_ino(tp, pag->pag_agno, next_agino, imap,
> -				dipp, bpp);
> -		if (error)
> -			return error;
> -
> -		unlinked_agino = be32_to_cpu((*dipp)->di_next_unlinked);
>  		/*
>  		 * Make sure this pointer is valid and isn't an obvious
>  		 * infinite loop.
>  		 */
> -		if (!xfs_verify_agino(mp, pag->pag_agno, unlinked_agino) ||
> -		    next_agino == unlinked_agino) {
> -			XFS_CORRUPTION_ERROR(__func__,
> -					XFS_ERRLEVEL_LOW, mp,
> -					*dipp, sizeof(**dipp));
> -			error = -EFSCORRUPTED;
> -			return error;
> +		if (!xfs_verify_agino(mp, pag->pag_agno, ip->i_next_unlinked) ||
> +		    next_agino == ip->i_next_unlinked)
> +			return -EFSCORRUPTED;
> +
> +		if (ip->i_next_unlinked == target_agino) {
> +			*ipp = ip;
> +			return 0;
>  		}
> -		next_agino = unlinked_agino;
> +		next_agino = ip->i_next_unlinked;
>  	}
> -
> -	return 0;
> +	return -EFSCORRUPTED;
>  }
>  
>  static int
> @@ -2341,8 +2317,6 @@ xfs_iunlink_remove_inode(
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_agi		*agi = agibp->b_addr;
> -	struct xfs_buf		*last_ibp;
> -	struct xfs_dinode	*last_dip = NULL;
>  	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
>  	xfs_agino_t		next_agino;
>  	xfs_agino_t		head_agino;
> @@ -2368,7 +2342,6 @@ xfs_iunlink_remove_inode(
>  	error = xfs_iunlink_update_inode(tp, ip, pag, NULLAGINO, &next_agino);
>  	if (error)
>  		return error;
> -	ip->i_next_unlinked = NULLAGINO;
>  
>  	/*
>  	 * If there was a backref pointing from the next inode back to this
> @@ -2384,18 +2357,21 @@ xfs_iunlink_remove_inode(
>  	}
>  
>  	if (head_agino != agino) {
> -		struct xfs_imap	imap;
> -		xfs_agino_t	prev_agino;
> +		struct xfs_inode	*prev_ip;
>  
> -		/* We need to search the list for the inode being freed. */
> -		error = xfs_iunlink_map_prev(tp, pag, head_agino, agino,
> -				&prev_agino, &imap, &last_dip, &last_ibp);
> +		error = xfs_iunlink_lookup_prev(pag, head_agino, agino,
> +				&prev_ip);
>  		if (error)
>  			return error;
>  
>  		/* Point the previous inode on the list to the next inode. */
> -		xfs_iunlink_update_dinode(tp, pag, prev_agino, last_ibp,
> -				last_dip, &imap, next_agino);
> +		error = xfs_iunlink_update_inode(tp, prev_ip, pag, next_agino,
> +				NULL);
> +		if (error)
> +			return error;
> +
> +		prev_ip->i_next_unlinked = ip->i_next_unlinked;
> +		ip->i_next_unlinked = NULLAGINO;
>  
>  		/*
>  		 * Now we deal with the backref for this inode.  If this inode
> @@ -2410,6 +2386,7 @@ xfs_iunlink_remove_inode(
>  	}
>  
>  	/* Point the head of the list to the next unlinked inode. */
> +	ip->i_next_unlinked = NULLAGINO;
>  	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index,
>  			next_agino);
>  }
> -- 
> 2.36.1
> 
