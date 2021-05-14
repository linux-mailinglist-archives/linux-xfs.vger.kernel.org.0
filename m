Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2FE3800FD
	for <lists+linux-xfs@lfdr.de>; Fri, 14 May 2021 01:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhEMXrQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 May 2021 19:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:59238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhEMXrP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 May 2021 19:47:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 524C261206;
        Thu, 13 May 2021 23:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620949565;
        bh=8lXQ7JT7rWBR0VY9syu4i/YiTpwdtHWBLkzjbYKbCbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B5/6s/pUCLfXMrtt0pBPQiADaYM+DMRpqzADN25ZbtANqT7CIDNMzMVvulOuDwCcw
         1scSpQBjOxPGLNUPal02klqVQ4JFfe21+Me6eNIp5qbKbtoKeU59DywjXy/oAcH6QU
         wGIdmhJXhmoV1RoN2hx0Ql031YKUvVuLWcYl7WbWb2zHYdu5tL4XJeFjPH+Fc/fGKb
         Ut9bTYRxoL99hO+DI/NLeR0+fU2q+EJZokwYHnIxgp/q3YRZdFNQonNnjJDDgJ4f1p
         cdm4CJqmj/uZAPca4rHL87XiHsjKJm71VStZM0tzBAMOBMmZmHAIxUsKf4R7+XPftU
         6aCfHluhGdhlg==
Date:   Thu, 13 May 2021 16:46:04 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v18 04/11] xfs: Add helper xfs_attr_set_fmt
Message-ID: <20210513234604.GD9675@magnolia>
References: <20210512161408.5516-1-allison.henderson@oracle.com>
 <20210512161408.5516-5-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512161408.5516-5-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 09:14:01AM -0700, Allison Henderson wrote:
> This patch adds a helper function xfs_attr_set_fmt.  This will help
> isolate the code that will require state management from the portions
> that do not.  xfs_attr_set_fmt returns 0 when the attr has been set and
> no further action is needed.  It returns -EAGAIN when shortform has been
> transformed to leaf, and the calling function should proceed the set the
> attr in leaf form.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Er... can't you combine patches 3 and 4 into a single patch that
renames xfs_attr_set_shortform -> xfs_attr_set_fmt and drops the
**leafbp parameter?  Smushing the two together it's a bit more obvious
what's really changing here (which really isn't that much!) so:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

(Though I think I would like the two combined for v19.  But let's see
what I think of the whole series by the time I reach the end, eh? :) )

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 79 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 46 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 32133a0..1a618a2 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -236,6 +236,48 @@ xfs_attr_is_shortform(
>  		ip->i_afp->if_nextents == 0);
>  }
>  
> +STATIC int
> +xfs_attr_set_fmt(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_buf          *leaf_bp = NULL;
> +	struct xfs_inode	*dp = args->dp;
> +	int			error2, error = 0;
> +
> +	/*
> +	 * Try to add the attr to the attribute list in the inode.
> +	 */
> +	error = xfs_attr_try_sf_addname(dp, args);
> +	if (error != -ENOSPC) {
> +		error2 = xfs_trans_commit(args->trans);
> +		args->trans = NULL;
> +		return error ? error : error2;
> +	}
> +
> +	/*
> +	 * It won't fit in the shortform, transform to a leaf block.
> +	 * GROT: another possible req'mt for a double-split btree op.
> +	 */
> +	error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Prevent the leaf buffer from being unlocked so that a
> +	 * concurrent AIL push cannot grab the half-baked leaf buffer
> +	 * and run into problems with the write verifier.
> +	 */
> +	xfs_trans_bhold(args->trans, leaf_bp);
> +	error = xfs_defer_finish(&args->trans);
> +	xfs_trans_bhold_release(args->trans, leaf_bp);
> +	if (error) {
> +		xfs_trans_brelse(args->trans, leaf_bp);
> +		return error;
> +	}
> +
> +	return -EAGAIN;
> +}
> +
>  /*
>   * Set the attribute specified in @args.
>   */
> @@ -244,8 +286,7 @@ xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> -	struct xfs_buf          *leaf_bp = NULL;
> -	int			error2, error = 0;
> +	int			error;
>  
>  	/*
>  	 * If the attribute list is already in leaf format, jump straight to
> @@ -254,36 +295,9 @@ xfs_attr_set_args(
>  	 * again.
>  	 */
>  	if (xfs_attr_is_shortform(dp)) {
> -		/*
> -		 * Try to add the attr to the attribute list in the inode.
> -		 */
> -		error = xfs_attr_try_sf_addname(dp, args);
> -		if (error != -ENOSPC) {
> -			error2 = xfs_trans_commit(args->trans);
> -			args->trans = NULL;
> -			return error ? error : error2;
> -		}
> -
> -		/*
> -		 * It won't fit in the shortform, transform to a leaf block.
> -		 * GROT: another possible req'mt for a double-split btree op.
> -		 */
> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
> -		if (error)
> -			return error;
> -
> -		/*
> -		 * Prevent the leaf buffer from being unlocked so that a
> -		 * concurrent AIL push cannot grab the half-baked leaf buffer
> -		 * and run into problems with the write verifier.
> -		 */
> -		xfs_trans_bhold(args->trans, leaf_bp);
> -		error = xfs_defer_finish(&args->trans);
> -		xfs_trans_bhold_release(args->trans, leaf_bp);
> -		if (error) {
> -			xfs_trans_brelse(args->trans, leaf_bp);
> +		error = xfs_attr_set_fmt(args);
> +		if (error != -EAGAIN)
>  			return error;
> -		}
>  	}
>  
>  	if (xfs_attr_is_leaf(dp)) {
> @@ -317,8 +331,7 @@ xfs_attr_set_args(
>  			return error;
>  	}
>  
> -	error = xfs_attr_node_addname(args);
> -	return error;
> +	return xfs_attr_node_addname(args);
>  }
>  
>  /*
> -- 
> 2.7.4
> 
