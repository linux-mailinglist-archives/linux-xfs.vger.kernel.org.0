Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044FD5227C1
	for <lists+linux-xfs@lfdr.de>; Wed, 11 May 2022 01:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbiEJXmx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 May 2022 19:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiEJXmw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 19:42:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C733E522CC
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 16:42:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A9EB1CE21A5
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 23:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1B2C385CC;
        Tue, 10 May 2022 23:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652226167;
        bh=H6ERSdgZ/QqVgS8hE1Njm4T3bhYuW1PFH5cH0fu7QUg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pHh1QLkExFt685OAvuTYtmoLJ0ClMJC0u3mPmYYg+7w0PJF/2OuntskrGphiekzaW
         hQ/Gd/kbZ6TeAw2yiqSRGR/MV96Cr0RW0li7PC5pwrdHBSnj6AYgUWI0ITqcP0Wea+
         ntFh2sLeHC+Ciuzt1MAe1FLh1O6+YYkaaspVMAHJr7PMxvoD2IPLaVLkYPtdJc4K8m
         4gpJCajVXMQXhO6d5HHgocSsT60YF2hc7AN44shHUERNpF4KNVExjqP9tBwUlltC5X
         MfzFTYoEVojtMxPEqrI+QfSMUJMNBRxWGZz8+Sobos/9Fkf/PYPXJZJe0rMRuVVYCl
         A2vIf2nMMzqxw==
Date:   Tue, 10 May 2022 16:42:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/18] xfs: remove xfs_attri_remove_iter
Message-ID: <20220510234246.GT27195@magnolia>
References: <20220509004138.762556-1-david@fromorbit.com>
 <20220509004138.762556-16-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509004138.762556-16-david@fromorbit.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 09, 2022 at 10:41:35AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_attri_remove_iter is not used anymore, so remove it and all the
> infrastructure it uses and is needed to drive it. THe
> xfs_attr_refillstate() function now throws an unused warning, so
> isolate the xfs_attr_fillstate()/xfs_attr_refillstate() code pair
> with an #if 0 and a comment explaining why we want to keep this code
> and restore the optimisation it provides in the near future.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Allison Henderson<allison.henderson@oracle.com>

Heh.  The state machine traversal is muuuch easier to read now...
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 418 +++++++++++++--------------------------
>  1 file changed, 139 insertions(+), 279 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b935727cf517..8be76f8d11c5 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -64,10 +64,6 @@ STATIC int xfs_attr_node_addname_find_attr(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_node_remove_attr(struct xfs_attr_item *attr);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
> -STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
> -STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> -STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
> -				    struct xfs_da_state *state);
>  
>  int
>  xfs_inode_hasattr(
> @@ -100,6 +96,123 @@ xfs_attr_is_leaf(
>  	return imap.br_startoff == 0 && imap.br_blockcount == 1;
>  }
>  
> +/*
> + * XXX (dchinner): name path state saving and refilling is an optimisation to
> + * avoid needing to look up name entries after rolling transactions removing
> + * remote xattr blocks between the name entry lookup and name entry removal.
> + * This optimisation got sidelined when combining the set and remove state
> + * machines, but the code has been left in place because it is worthwhile to
> + * restore the optimisation once the combined state machine paths have settled.
> + *
> + * This comment is a public service announcement to remind Future Dave that he
> + * still needs to restore this code to working order.
> + */
> +#if 0
> +/*
> + * Fill in the disk block numbers in the state structure for the buffers
> + * that are attached to the state structure.
> + * This is done so that we can quickly reattach ourselves to those buffers
> + * after some set of transaction commits have released these buffers.
> + */
> +static int
> +xfs_attr_fillstate(xfs_da_state_t *state)
> +{
> +	xfs_da_state_path_t *path;
> +	xfs_da_state_blk_t *blk;
> +	int level;
> +
> +	trace_xfs_attr_fillstate(state->args);
> +
> +	/*
> +	 * Roll down the "path" in the state structure, storing the on-disk
> +	 * block number for those buffers in the "path".
> +	 */
> +	path = &state->path;
> +	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
> +	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
> +		if (blk->bp) {
> +			blk->disk_blkno = xfs_buf_daddr(blk->bp);
> +			blk->bp = NULL;
> +		} else {
> +			blk->disk_blkno = 0;
> +		}
> +	}
> +
> +	/*
> +	 * Roll down the "altpath" in the state structure, storing the on-disk
> +	 * block number for those buffers in the "altpath".
> +	 */
> +	path = &state->altpath;
> +	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
> +	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
> +		if (blk->bp) {
> +			blk->disk_blkno = xfs_buf_daddr(blk->bp);
> +			blk->bp = NULL;
> +		} else {
> +			blk->disk_blkno = 0;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Reattach the buffers to the state structure based on the disk block
> + * numbers stored in the state structure.
> + * This is done after some set of transaction commits have released those
> + * buffers from our grip.
> + */
> +static int
> +xfs_attr_refillstate(xfs_da_state_t *state)
> +{
> +	xfs_da_state_path_t *path;
> +	xfs_da_state_blk_t *blk;
> +	int level, error;
> +
> +	trace_xfs_attr_refillstate(state->args);
> +
> +	/*
> +	 * Roll down the "path" in the state structure, storing the on-disk
> +	 * block number for those buffers in the "path".
> +	 */
> +	path = &state->path;
> +	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
> +	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
> +		if (blk->disk_blkno) {
> +			error = xfs_da3_node_read_mapped(state->args->trans,
> +					state->args->dp, blk->disk_blkno,
> +					&blk->bp, XFS_ATTR_FORK);
> +			if (error)
> +				return error;
> +		} else {
> +			blk->bp = NULL;
> +		}
> +	}
> +
> +	/*
> +	 * Roll down the "altpath" in the state structure, storing the on-disk
> +	 * block number for those buffers in the "altpath".
> +	 */
> +	path = &state->altpath;
> +	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
> +	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
> +		if (blk->disk_blkno) {
> +			error = xfs_da3_node_read_mapped(state->args->trans,
> +					state->args->dp, blk->disk_blkno,
> +					&blk->bp, XFS_ATTR_FORK);
> +			if (error)
> +				return error;
> +		} else {
> +			blk->bp = NULL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +#else
> +static int xfs_attr_fillstate(xfs_da_state_t *state) { return 0; }
> +#endif
> +
>  /*========================================================================
>   * Overall external interface routines.
>   *========================================================================*/
> @@ -548,25 +661,16 @@ xfs_attr_leaf_remove_attr(
>   */
>  static int
>  xfs_attr_leaf_shrink(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state     *state)
> +	struct xfs_da_args	*args)
>  {
>  	struct xfs_inode	*dp = args->dp;
> -	int			error, forkoff;
>  	struct xfs_buf		*bp;
> +	int			forkoff;
> +	int			error;
>  
>  	if (!xfs_attr_is_leaf(dp))
>  		return 0;
>  
> -	/*
> -	 * Have to get rid of the copy of this dabuf in the state.
> -	 */
> -	if (state) {
> -		ASSERT(state->path.active == 1);
> -		ASSERT(state->path.blk[0].bp);
> -		state->path.blk[0].bp = NULL;
> -	}
> -
>  	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
>  	if (error)
>  		return error;
> @@ -709,7 +813,7 @@ xfs_attr_set_iter(
>  	case XFS_DAS_NODE_REMOVE_ATTR:
>  		error = xfs_attr_node_remove_attr(attr);
>  		if (!error)
> -			error = xfs_attr_leaf_shrink(args, NULL);
> +			error = xfs_attr_leaf_shrink(args);
>  		attr->xattri_dela_state = XFS_DAS_DONE;
>  		break;
>  	default:
> @@ -1382,6 +1486,24 @@ xfs_attr_node_try_addname(
>  	return error;
>  }
>  
> +static int
> +xfs_attr_node_removename(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	struct xfs_da_state_blk	*blk;
> +	int			retval;
> +
> +	/*
> +	 * Remove the name and update the hashvals in the tree.
> +	 */
> +	blk = &state->path.blk[state->path.active-1];
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +	retval = xfs_attr3_leaf_remove(blk->bp, args);
> +	xfs_da3_fixhashpath(state, &state->path);
> +
> +	return retval;
> +}
>  
>  static int
>  xfs_attr_node_remove_attr(
> @@ -1424,268 +1546,6 @@ xfs_attr_node_remove_attr(
>  	return retval;
>  }
>  
> -
> -STATIC int
> -xfs_attr_node_removename(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state	*state)
> -{
> -	struct xfs_da_state_blk	*blk;
> -	int			retval;
> -
> -	/*
> -	 * Remove the name and update the hashvals in the tree.
> -	 */
> -	blk = &state->path.blk[state->path.active-1];
> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -	retval = xfs_attr3_leaf_remove(blk->bp, args);
> -	xfs_da3_fixhashpath(state, &state->path);
> -
> -	return retval;
> -}
> -
> -/*
> - * Remove the attribute specified in @args.
> - *
> - * This will involve walking down the Btree, and may involve joining
> - * leaf nodes and even joining intermediate nodes up to and including
> - * the root node (a special case of an intermediate node).
> - *
> - * This routine is meant to function as either an in-line or delayed operation,
> - * and may return -EAGAIN when the transaction needs to be rolled.  Calling
> - * functions will need to handle this, and call the function until a
> - * successful error code is returned.
> - */
> -int
> -xfs_attr_remove_iter(
> -	struct xfs_attr_item		*attr)
> -{
> -	struct xfs_da_args		*args = attr->xattri_da_args;
> -	struct xfs_da_state		*state = attr->xattri_da_state;
> -	int				retval, error = 0;
> -	struct xfs_inode		*dp = args->dp;
> -
> -	trace_xfs_attr_node_removename(args);
> -
> -	switch (attr->xattri_dela_state) {
> -	case XFS_DAS_UNINIT:
> -		if (!xfs_inode_hasattr(dp))
> -			return -ENOATTR;
> -
> -		/*
> -		 * Shortform or leaf formats don't require transaction rolls and
> -		 * thus state transitions. Call the right helper and return.
> -		 */
> -		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
> -			return xfs_attr_sf_removename(args);
> -
> -		if (xfs_attr_is_leaf(dp))
> -			return xfs_attr_leaf_removename(args);
> -
> -		/*
> -		 * Node format may require transaction rolls. Set up the
> -		 * state context and fall into the state machine.
> -		 */
> -		if (!attr->xattri_da_state) {
> -			error = xfs_attr_node_removename_setup(attr);
> -			if (error)
> -				return error;
> -			state = attr->xattri_da_state;
> -		}
> -
> -		fallthrough;
> -	case XFS_DAS_RMTBLK:
> -		attr->xattri_dela_state = XFS_DAS_RMTBLK;
> -
> -		/*
> -		 * If there is an out-of-line value, de-allocate the blocks.
> -		 * This is done before we remove the attribute so that we don't
> -		 * overflow the maximum size of a transaction and/or hit a
> -		 * deadlock.
> -		 */
> -		if (args->rmtblkno > 0) {
> -			/*
> -			 * May return -EAGAIN. Roll and repeat until all remote
> -			 * blocks are removed.
> -			 */
> -			error = xfs_attr_rmtval_remove(attr);
> -			if (error == -EAGAIN) {
> -				trace_xfs_attr_remove_iter_return(
> -					attr->xattri_dela_state, args->dp);
> -				return error;
> -			} else if (error) {
> -				goto out;
> -			}
> -
> -			/*
> -			 * Refill the state structure with buffers (the prior
> -			 * calls released our buffers) and close out this
> -			 * transaction before proceeding.
> -			 */
> -			ASSERT(args->rmtblkno == 0);
> -			error = xfs_attr_refillstate(state);
> -			if (error)
> -				goto out;
> -
> -			attr->xattri_dela_state = XFS_DAS_RM_NAME;
> -			trace_xfs_attr_remove_iter_return(
> -					attr->xattri_dela_state, args->dp);
> -			return -EAGAIN;
> -		}
> -
> -		fallthrough;
> -	case XFS_DAS_RM_NAME:
> -		/*
> -		 * If we came here fresh from a transaction roll, reattach all
> -		 * the buffers to the current transaction.
> -		 */
> -		if (attr->xattri_dela_state == XFS_DAS_RM_NAME) {
> -			error = xfs_attr_refillstate(state);
> -			if (error)
> -				goto out;
> -		}
> -
> -		retval = xfs_attr_node_removename(args, state);
> -
> -		/*
> -		 * Check to see if the tree needs to be collapsed. If so, roll
> -		 * the transacton and fall into the shrink state.
> -		 */
> -		if (retval && (state->path.active > 1)) {
> -			error = xfs_da3_join(state);
> -			if (error)
> -				goto out;
> -
> -			attr->xattri_dela_state = XFS_DAS_RM_SHRINK;
> -			trace_xfs_attr_remove_iter_return(
> -					attr->xattri_dela_state, args->dp);
> -			return -EAGAIN;
> -		}
> -
> -		fallthrough;
> -	case XFS_DAS_RM_SHRINK:
> -		/*
> -		 * If the result is small enough, push it all into the inode.
> -		 * This is our final state so it's safe to return a dirty
> -		 * transaction.
> -		 */
> -		if (xfs_attr_is_leaf(dp))
> -			error = xfs_attr_leaf_shrink(args, state);
> -		ASSERT(error != -EAGAIN);
> -		break;
> -	default:
> -		ASSERT(0);
> -		error = -EINVAL;
> -		goto out;
> -	}
> -out:
> -	if (state)
> -		xfs_da_state_free(state);
> -	return error;
> -}
> -
> -/*
> - * Fill in the disk block numbers in the state structure for the buffers
> - * that are attached to the state structure.
> - * This is done so that we can quickly reattach ourselves to those buffers
> - * after some set of transaction commits have released these buffers.
> - */
> -STATIC int
> -xfs_attr_fillstate(xfs_da_state_t *state)
> -{
> -	xfs_da_state_path_t *path;
> -	xfs_da_state_blk_t *blk;
> -	int level;
> -
> -	trace_xfs_attr_fillstate(state->args);
> -
> -	/*
> -	 * Roll down the "path" in the state structure, storing the on-disk
> -	 * block number for those buffers in the "path".
> -	 */
> -	path = &state->path;
> -	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
> -	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
> -		if (blk->bp) {
> -			blk->disk_blkno = xfs_buf_daddr(blk->bp);
> -			blk->bp = NULL;
> -		} else {
> -			blk->disk_blkno = 0;
> -		}
> -	}
> -
> -	/*
> -	 * Roll down the "altpath" in the state structure, storing the on-disk
> -	 * block number for those buffers in the "altpath".
> -	 */
> -	path = &state->altpath;
> -	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
> -	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
> -		if (blk->bp) {
> -			blk->disk_blkno = xfs_buf_daddr(blk->bp);
> -			blk->bp = NULL;
> -		} else {
> -			blk->disk_blkno = 0;
> -		}
> -	}
> -
> -	return 0;
> -}
> -
> -/*
> - * Reattach the buffers to the state structure based on the disk block
> - * numbers stored in the state structure.
> - * This is done after some set of transaction commits have released those
> - * buffers from our grip.
> - */
> -STATIC int
> -xfs_attr_refillstate(xfs_da_state_t *state)
> -{
> -	xfs_da_state_path_t *path;
> -	xfs_da_state_blk_t *blk;
> -	int level, error;
> -
> -	trace_xfs_attr_refillstate(state->args);
> -
> -	/*
> -	 * Roll down the "path" in the state structure, storing the on-disk
> -	 * block number for those buffers in the "path".
> -	 */
> -	path = &state->path;
> -	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
> -	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
> -		if (blk->disk_blkno) {
> -			error = xfs_da3_node_read_mapped(state->args->trans,
> -					state->args->dp, blk->disk_blkno,
> -					&blk->bp, XFS_ATTR_FORK);
> -			if (error)
> -				return error;
> -		} else {
> -			blk->bp = NULL;
> -		}
> -	}
> -
> -	/*
> -	 * Roll down the "altpath" in the state structure, storing the on-disk
> -	 * block number for those buffers in the "altpath".
> -	 */
> -	path = &state->altpath;
> -	ASSERT((path->active >= 0) && (path->active < XFS_DA_NODE_MAXDEPTH));
> -	for (blk = path->blk, level = 0; level < path->active; blk++, level++) {
> -		if (blk->disk_blkno) {
> -			error = xfs_da3_node_read_mapped(state->args->trans,
> -					state->args->dp, blk->disk_blkno,
> -					&blk->bp, XFS_ATTR_FORK);
> -			if (error)
> -				return error;
> -		} else {
> -			blk->bp = NULL;
> -		}
> -	}
> -
> -	return 0;
> -}
> -
>  /*
>   * Retrieve the attribute data from a node attribute list.
>   *
> -- 
> 2.35.1
> 
