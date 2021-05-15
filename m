Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C73338198D
	for <lists+linux-xfs@lfdr.de>; Sat, 15 May 2021 17:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhEOPaA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 15 May 2021 11:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:32810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232442AbhEOP34 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 15 May 2021 11:29:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFB73611C9;
        Sat, 15 May 2021 15:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621092523;
        bh=qp11/hLo+skBqsOAlygFybfro7Mc7C+tDkUhJqt5SAM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m3A3Oxbf6rIiDp9gkh0gIO9THY6AlfMXQdQYgO0PY6K6kai78F0Dvgz60QelLEAzh
         p/5H89Kvnb8ynrW58LkS/6KGiXd2UAetKIfcq+vTZhVv47KJuUao0wcABFqVbGcksk
         BPZ9mQkKOyxz1tv1j2emZRWBN17qksEVuFdIUtfa91mh6FGUGj4p/4eqOgK3nh4cfT
         +VtB5GD5RPIoos1c11S1CRuElhs6FzwR881Zu3Xov1JvkNNkBX8MDgneMD3tZUcMpy
         6R/ChFW3lNyfrPADu/ij3zNw7Rq6iPOTJwbk0zrrhKpEF9hy1sPkbFlYU3iGZV9DIi
         HMfX5FLQA84yg==
Date:   Sat, 15 May 2021 08:28:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RESEND v18 10/11] xfs: Add delay ready attr remove
 routines
Message-ID: <20210515152842.GP9675@magnolia>
References: <20210512161408.5516-1-allison.henderson@oracle.com>
 <20210512161408.5516-11-allison.henderson@oracle.com>
 <20210514004602.GG9675@magnolia>
 <1e100eee-3136-8de6-6699-d0b4df1da7d4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1e100eee-3136-8de6-6699-d0b4df1da7d4@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 14, 2021 at 10:41:44PM -0700, Allison Henderson wrote:
> 
> 
> On 5/13/21 5:46 PM, Darrick J. Wong wrote:
> > On Wed, May 12, 2021 at 09:14:07AM -0700, Allison Henderson wrote:
> > > This patch modifies the attr remove routines to be delay ready. This
> > > means they no longer roll or commit transactions, but instead return
> > > -EAGAIN to have the calling routine roll and refresh the transaction. In
> > > this series, xfs_attr_remove_args is merged with
> > > xfs_attr_node_removename become a new function, xfs_attr_remove_iter.
> > > This new version uses a sort of state machine like switch to keep track
> > > of where it was when EAGAIN was returned. A new version of
> > > xfs_attr_remove_args consists of a simple loop to refresh the
> > > transaction until the operation is completed. A new XFS_DAC_DEFER_FINISH
> > > flag is used to finish the transaction where ever the existing code used
> > > to.
> > > 
> > > Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> > > version __xfs_attr_rmtval_remove. We will rename
> > > __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> > > done.
> > > 
> > > xfs_attr_rmtval_remove itself is still in use by the set routines (used
> > > during a rename).  For reasons of preserving existing function, we
> > > modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
> > > set.  Similar to how xfs_attr_remove_args does here.  Once we transition
> > > the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
> > > used and will be removed.
> > > 
> > > This patch also adds a new struct xfs_delattr_context, which we will use
> > > to keep track of the current state of an attribute operation. The new
> > > xfs_delattr_state enum is used to track various operations that are in
> > > progress so that we know not to repeat them, and resume where we left
> > > off before EAGAIN was returned to cycle out the transaction. Other
> > > members take the place of local variables that need to retain their
> > > values across multiple function recalls.  See xfs_attr.h for a more
> > > detailed diagram of the states.
> > > 
> > > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > > Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >   fs/xfs/libxfs/xfs_attr.c        | 213 ++++++++++++++++++++++++++++------------
> > >   fs/xfs/libxfs/xfs_attr.h        | 131 ++++++++++++++++++++++++
> > >   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
> > >   fs/xfs/libxfs/xfs_attr_remote.c |  48 +++++----
> > >   fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
> > >   fs/xfs/xfs_attr_inactive.c      |   2 +-
> > >   6 files changed, 314 insertions(+), 84 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index 21f862e..a91fff6 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
> > > @@ -57,7 +57,6 @@ STATIC int xfs_attr_node_addname(struct xfs_da_args *args,
> > >   				 struct xfs_da_state *state);
> > >   STATIC int xfs_attr_node_addname_find_attr(struct xfs_da_args *args,
> > >   				 struct xfs_da_state **state);
> > > -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> > >   STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
> > >   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> > >   				 struct xfs_da_state **state);
> > > @@ -241,6 +240,31 @@ xfs_attr_is_shortform(
> > >   		ip->i_afp->if_nextents == 0);
> > >   }
> > > +/*
> > > + * Checks to see if a delayed attribute transaction should be rolled.  If so,
> > > + * transaction is finished or rolled as needed.
> > > + */
> > > +int
> > > +xfs_attr_trans_roll(
> > > +	struct xfs_delattr_context	*dac)
> > > +{
> > > +	struct xfs_da_args		*args = dac->da_args;
> > > +	int				error;
> > > +
> > > +	if (dac->flags & XFS_DAC_DEFER_FINISH) {
> > > +		/*
> > > +		 * The caller wants us to finish all the deferred ops so that we
> > > +		 * avoid pinning the log tail with a large number of deferred
> > > +		 * ops.
> > > +		 */
> > > +		dac->flags &= ~XFS_DAC_DEFER_FINISH;
> > > +		error = xfs_defer_finish(&args->trans);
> > > +	} else
> > > +		error = xfs_trans_roll_inode(&args->trans, args->dp);
> > > +
> > > +	return error;
> > > +}
> > > +
> > >   STATIC int
> > >   xfs_attr_set_fmt(
> > >   	struct xfs_da_args	*args)
> > > @@ -544,16 +568,25 @@ xfs_has_attr(
> > >    */
> > >   int
> > >   xfs_attr_remove_args(
> > > -	struct xfs_da_args      *args)
> > > +	struct xfs_da_args	*args)
> > >   {
> > > -	if (!xfs_inode_hasattr(args->dp))
> > > -		return -ENOATTR;
> > > +	int				error;
> > > +	struct xfs_delattr_context	dac = {
> > > +		.da_args	= args,
> > > +	};
> > > -	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
> > > -		return xfs_attr_shortform_remove(args);
> > > -	if (xfs_attr_is_leaf(args->dp))
> > > -		return xfs_attr_leaf_removename(args);
> > > -	return xfs_attr_node_removename(args);
> > > +	do {
> > > +		error = xfs_attr_remove_iter(&dac);
> > > +		if (error != -EAGAIN)
> > > +			break;
> > > +
> > > +		error = xfs_attr_trans_roll(&dac);
> > > +		if (error)
> > > +			return error;
> > > +
> > > +	} while (true);
> > > +
> > > +	return error;
> > >   }
> > >   /*
> > > @@ -1197,14 +1230,16 @@ xfs_attr_leaf_mark_incomplete(
> > >    */
> > >   STATIC
> > >   int xfs_attr_node_removename_setup(
> > > -	struct xfs_da_args	*args,
> > > -	struct xfs_da_state	**state)
> > > +	struct xfs_delattr_context	*dac)
> > >   {
> > > -	int			error;
> > > +	struct xfs_da_args		*args = dac->da_args;
> > > +	struct xfs_da_state		**state = &dac->da_state;
> > > +	int				error;
> > >   	error = xfs_attr_node_hasname(args, state);
> > >   	if (error != -EEXIST)
> > >   		return error;
> > > +	error = 0;
> > >   	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
> > >   	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
> > > @@ -1213,12 +1248,15 @@ int xfs_attr_node_removename_setup(
> > >   	if (args->rmtblkno > 0) {
> > >   		error = xfs_attr_leaf_mark_incomplete(args, *state);
> > >   		if (error)
> > > -			return error;
> > > +			goto out;
> > > -		return xfs_attr_rmtval_invalidate(args);
> > > +		error = xfs_attr_rmtval_invalidate(args);
> > >   	}
> > > +out:
> > > +	if (error)
> > > +		xfs_da_state_free(*state);
> > > -	return 0;
> > > +	return error;
> > >   }
> > >   STATIC int
> > > @@ -1241,70 +1279,123 @@ xfs_attr_node_remove_name(
> > >   }
> > >   /*
> > > - * Remove a name from a B-tree attribute list.
> > > + * Remove the attribute specified in @args.
> > >    *
> > >    * This will involve walking down the Btree, and may involve joining
> > >    * leaf nodes and even joining intermediate nodes up to and including
> > >    * the root node (a special case of an intermediate node).
> > > + *
> > > + * This routine is meant to function as either an in-line or delayed operation,
> > > + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
> > > + * functions will need to handle this, and recall the function until a
> > > + * successful error code is returned.
> > >    */
> > > -STATIC int
> > > -xfs_attr_node_removename(
> > > -	struct xfs_da_args	*args)
> > > +int
> > > +xfs_attr_remove_iter(
> > > +	struct xfs_delattr_context	*dac)
> > >   {
> > > -	struct xfs_da_state	*state;
> > > -	int			retval, error;
> > > -	struct xfs_inode	*dp = args->dp;
> > > +	struct xfs_da_args		*args = dac->da_args;
> > > +	struct xfs_da_state		*state = dac->da_state;
> > > +	int				retval, error;
> > > +	struct xfs_inode		*dp = args->dp;
> > >   	trace_xfs_attr_node_removename(args);
> > > -	error = xfs_attr_node_removename_setup(args, &state);
> > > -	if (error)
> > > -		goto out;
> > > +	switch (dac->dela_state) {
> > > +	case XFS_DAS_UNINIT:
> > > +		if (!xfs_inode_hasattr(dp))
> > > +			return -ENOATTR;
> > > -	/*
> > > -	 * If there is an out-of-line value, de-allocate the blocks.
> > > -	 * This is done before we remove the attribute so that we don't
> > > -	 * overflow the maximum size of a transaction and/or hit a deadlock.
> > > -	 */
> > > -	if (args->rmtblkno > 0) {
> > > -		error = xfs_attr_rmtval_remove(args);
> > > -		if (error)
> > > -			goto out;
> > > +		/*
> > > +		 * Shortform or leaf formats don't require transaction rolls and
> > > +		 * thus state transitions. Call the right helper and return.
> > > +		 */
> > > +		if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
> > > +			return xfs_attr_shortform_remove(args);
> > > +
> > > +		if (xfs_attr_is_leaf(dp))
> > > +			return xfs_attr_leaf_removename(args);
> > >   		/*
> > > -		 * Refill the state structure with buffers, the prior calls
> > > -		 * released our buffers.
> > > +		 * Node format may require transaction rolls. Set up the
> > > +		 * state context and fall into the state machine.
> > >   		 */
> > > -		error = xfs_attr_refillstate(state);
> > > -		if (error)
> > > -			goto out;
> > > -	}
> > > -	retval = xfs_attr_node_remove_name(args, state);
> > > +		if (!dac->da_state) {
> > > +			error = xfs_attr_node_removename_setup(dac);
> > > +			if (error)
> > > +				return error;
> > > +			state = dac->da_state;
> > > +		}
> > > +
> > > +		/* fallthrough */
> > > +	case XFS_DAS_RMTBLK:
> > > +		dac->dela_state = XFS_DAS_RMTBLK;
> > > -	/*
> > > -	 * Check to see if the tree needs to be collapsed.
> > > -	 */
> > > -	if (retval && (state->path.active > 1)) {
> > > -		error = xfs_da3_join(state);
> > > -		if (error)
> > > -			goto out;
> > > -		error = xfs_defer_finish(&args->trans);
> > > -		if (error)
> > > -			goto out;
> > >   		/*
> > > -		 * Commit the Btree join operation and start a new trans.
> > > +		 * If there is an out-of-line value, de-allocate the blocks.
> > > +		 * This is done before we remove the attribute so that we don't
> > > +		 * overflow the maximum size of a transaction and/or hit a
> > > +		 * deadlock.
> > >   		 */
> > > -		error = xfs_trans_roll_inode(&args->trans, dp);
> > > -		if (error)
> > > -			goto out;
> > > -	}
> > > +		if (args->rmtblkno > 0) {
> > > +			/*
> > > +			 * May return -EAGAIN. Roll and repeat until all remote
> > > +			 * blocks are removed.
> > > +			 */
> > > +			error = __xfs_attr_rmtval_remove(dac);
> > > +			if (error == -EAGAIN)
> > > +				return error;
> > > +			else if (error)
> > > +				goto out;
> > > -	/*
> > > -	 * If the result is small enough, push it all into the inode.
> > > -	 */
> > > -	if (xfs_attr_is_leaf(dp))
> > > -		error = xfs_attr_node_shrink(args, state);
> > > +			/*
> > > +			 * Refill the state structure with buffers (the prior
> > > +			 * calls released our buffers) and close out this
> > > +			 * transaction before proceeding.
> > > +			 */
> > > +			ASSERT(args->rmtblkno == 0);
> > > +			error = xfs_attr_refillstate(state);
> > > +			if (error)
> > > +				goto out;
> > > +			dac->dela_state = XFS_DAS_RM_NAME;
> > > +			dac->flags |= XFS_DAC_DEFER_FINISH;
> > > +			return -EAGAIN;
> > > +		}
> > > +
> > > +		/* fallthrough */
> > > +	case XFS_DAS_RM_NAME:
> > > +		retval = xfs_attr_node_remove_name(args, state);
> > 
> > Hm.  I see a bunch of cleanup possibilities for after this series...
> > 
> > xfs_attr_shortform_remove
> > xfs_attr_leaf_removename
> > xfs_attr_node_remove_name
> > 
> > Can you add a patch to the end of the series renaming these to
> > xfs_attr_{sf,leaf,node}_removename or something?
> > 
> > Also, can you refactor the chunk of code under "Remove the name and
> > update the hashvals in the tree" in
> > xfs_attr_node_addname_clear_incomplete to use xfs_attr_node_remove_name?
> > 
> > (Separate cleanup patches at the end of the series would be appreciated.)
> Sure, that should be fine.  Do you want a patch for each?  Or just one clean
> up patch?

One for all the function renaming, another for the quick hoist.

--D

> > 
> > > +		/*
> > > +		 * Check to see if the tree needs to be collapsed. If so, roll
> > > +		 * the transacton and fall into the shrink state.
> > > +		 */
> > > +		if (retval && (state->path.active > 1)) {
> > > +			error = xfs_da3_join(state);
> > > +			if (error)
> > > +				goto out;
> > > +
> > > +			dac->flags |= XFS_DAC_DEFER_FINISH;
> > > +			dac->dela_state = XFS_DAS_RM_SHRINK;
> > > +			return -EAGAIN;
> > > +		}
> > > +
> > > +		/* fallthrough */
> > > +	case XFS_DAS_RM_SHRINK:
> > > +		/*
> > > +		 * If the result is small enough, push it all into the inode.
> > > +		 * This is our final state so it's safe to return a dirty
> > > +		 * transaction.
> > > +		 */
> > > +		if (xfs_attr_is_leaf(dp))
> > > +			error = xfs_attr_node_shrink(args, state);
> > > +		ASSERT(error != -EAGAIN);
> > > +		break;
> > > +	default:
> > > +		ASSERT(0);
> > > +		error = -EINVAL;
> > > +		goto out;
> > > +	}
> > >   out:
> > >   	if (state)
> > >   		xfs_da_state_free(state);
> > > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > > index 2b1f619..32736d9 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.h
> > > +++ b/fs/xfs/libxfs/xfs_attr.h
> > > @@ -74,6 +74,133 @@ struct xfs_attr_list_context {
> > >   };
> > > +/*
> > > + * ========================================================================
> > > + * Structure used to pass context around among the delayed routines.
> > > + * ========================================================================
> > > + */
> > > +
> > > +/*
> > > + * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
> > > + * states indicate places where the function would return -EAGAIN, and then
> > > + * immediately resume from after being recalled by the calling function. States
> > > + * marked as a "subroutine state" indicate that they belong to a subroutine, and
> > > + * so the calling function needs to pass them back to that subroutine to allow
> > > + * it to finish where it left off. But they otherwise do not have a role in the
> > > + * calling function other than just passing through.
> > > + *
> > > + * xfs_attr_remove_iter()
> > > + *              │
> > > + *              v
> > > + *        have attr to remove? ──n──> done
> > > + *              │
> > > + *              y
> > > + *              │
> > > + *              v
> > > + *        are we short form? ──y──> xfs_attr_shortform_remove ──> done
> > > + *              │
> > > + *              n
> > > + *              │
> > > + *              V
> > > + *        are we leaf form? ──y──> xfs_attr_leaf_removename ──> done
> > > + *              │
> > > + *              n
> > > + *              │
> > > + *              V
> > > + *   ┌── need to setup state?
> > > + *   │          │
> > > + *   n          y
> > > + *   │          │
> > > + *   │          v
> > > + *   │ find attr and get state
> > > + *   │    attr has blks? ───n────┐
> > 
> > Nit: This should be "attr has remote blks?" since everywhere else in the
> > code we call them remote value blocks.
> Ok, will fix
> > 
> > > + *   │          │                v
> > > + *   │          │         find and invalidate
> > > + *   │          y         the blocks. mark
> > 
> > remote blocks...
> will fix
> 
> > 
> > > + *   │          │         attr incomplete
> > > + *   │          ├────────────────┘
> > > + *   └──────────┤
> > > + *              │
> > > + *              v
> > > + *      Have blks to remove? ───y─────────┐
> > > + *              │        ^          remove the blks
> > 
> > remote blocks...
> will fix
> 
> > 
> > > + *              │        │                │
> > > + *              │        │                v
> > > + *              │  XFS_DAS_RMTBLK <─n── done?
> > > + *              │  re-enter with          │
> > > + *              │  one less blk to        y
> > > + *              │      remove             │
> > > + *              │                         V
> > > + *              │                  refill the state
> > > + *              n                         │
> > > + *              │                         v
> > > + *              │                   XFS_DAS_RM_NAME
> > > + *              │                         │
> > > + *              ├─────────────────────────┘
> > > + *              │
> > > + *              v
> > > + *       remove leaf and
> > > + *       update hash with
> > > + *   xfs_attr_node_remove_cleanup
> > > + *              │
> > > + *              v
> > > + *           need to
> > > + *        shrink tree? ─n─┐
> > > + *              │         │
> > > + *              y         │
> > > + *              │         │
> > > + *              v         │
> > > + *          join leaf     │
> > > + *              │         │
> > > + *              v         │
> > > + *      XFS_DAS_RM_SHRINK │
> > > + *              │         │
> > > + *              v         │
> > > + *       do the shrink    │
> > > + *              │         │
> > > + *              v         │
> > > + *          free state <──┘
> > > + *              │
> > > + *              v
> > > + *            done
> > > + *
> > > + */
> > > +
> > > +/*
> > > + * Enum values for xfs_delattr_context.da_state
> > > + *
> > > + * These values are used by delayed attribute operations to keep track  of where
> > > + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
> > > + * calling function to roll the transaction, and then recall the subroutine to
> > 
> > nit: s/recall/call the subroutine again/
> Sure, will update
> 
> > 
> > > + * finish the operation.  The enum is then used by the subroutine to jump back
> > > + * to where it was and resume executing where it left off.
> > > + */
> > > +enum xfs_delattr_state {
> > > +	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
> > > +	XFS_DAS_RMTBLK,		      /* Removing remote blks */
> > > +	XFS_DAS_RM_NAME,	      /* Remove attr name */
> > > +	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
> > > +};
> > > +
> > > +/*
> > > + * Defines for xfs_delattr_context.flags
> > > + */
> > > +#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
> > > +
> > > +/*
> > > + * Context used for keeping track of delayed attribute operations
> > > + */
> > > +struct xfs_delattr_context {
> > > +	struct xfs_da_args      *da_args;
> > > +
> > > +	/* Used in xfs_attr_node_removename to roll through removing blocks */
> > > +	struct xfs_da_state     *da_state;
> > > +
> > > +	/* Used to keep track of current state of delayed operation */
> > > +	unsigned int            flags;
> > > +	enum xfs_delattr_state  dela_state;
> > > +};
> > > +
> > >   /*========================================================================
> > >    * Function prototypes for the kernel.
> > >    *========================================================================*/
> > > @@ -92,6 +219,10 @@ int xfs_attr_set(struct xfs_da_args *args);
> > >   int xfs_attr_set_args(struct xfs_da_args *args);
> > >   int xfs_has_attr(struct xfs_da_args *args);
> > >   int xfs_attr_remove_args(struct xfs_da_args *args);
> > > +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
> > > +int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
> > >   bool xfs_attr_namecheck(const void *name, size_t length);
> > > +void xfs_delattr_context_init(struct xfs_delattr_context *dac,
> > > +			      struct xfs_da_args *args);
> > >   #endif	/* __XFS_ATTR_H__ */
> > > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > index 556184b..d97de20 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > @@ -19,8 +19,8 @@
> > >   #include "xfs_bmap_btree.h"
> > >   #include "xfs_bmap.h"
> > >   #include "xfs_attr_sf.h"
> > > -#include "xfs_attr_remote.h"
> > >   #include "xfs_attr.h"
> > > +#include "xfs_attr_remote.h"
> > >   #include "xfs_attr_leaf.h"
> > >   #include "xfs_error.h"
> > >   #include "xfs_trace.h"
> > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > > index 48d8e9c..2f3c4cc 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > > @@ -674,10 +674,12 @@ xfs_attr_rmtval_invalidate(
> > >    */
> > >   int
> > >   xfs_attr_rmtval_remove(
> > > -	struct xfs_da_args      *args)
> > > +	struct xfs_da_args		*args)
> > >   {
> > > -	int			error;
> > > -	int			retval;
> > > +	int				error;
> > > +	struct xfs_delattr_context	dac  = {
> > > +		.da_args	= args,
> > > +	};
> > >   	trace_xfs_attr_rmtval_remove(args);
> > > @@ -685,31 +687,29 @@ xfs_attr_rmtval_remove(
> > >   	 * Keep de-allocating extents until the remote-value region is gone.
> > >   	 */
> > >   	do {
> > > -		retval = __xfs_attr_rmtval_remove(args);
> > > -		if (retval && retval != -EAGAIN)
> > > -			return retval;
> > > +		error = __xfs_attr_rmtval_remove(&dac);
> > > +		if (error && error != -EAGAIN)
> > > +			break;
> > > -		/*
> > > -		 * Close out trans and start the next one in the chain.
> > > -		 */
> > > -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> > > +		error = xfs_attr_trans_roll(&dac);
> > >   		if (error)
> > >   			return error;
> > > -	} while (retval == -EAGAIN);
> > > +	} while (true);
> > > -	return 0;
> > > +	return error;
> > >   }
> > >   /*
> > >    * Remove the value associated with an attribute by deleting the out-of-line
> > > - * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
> > > + * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
> > >    * transaction and re-call the function
> > >    */
> > >   int
> > >   __xfs_attr_rmtval_remove(
> > > -	struct xfs_da_args	*args)
> > > +	struct xfs_delattr_context	*dac)
> > >   {
> > > -	int			error, done;
> > > +	struct xfs_da_args		*args = dac->da_args;
> > > +	int				error, done;
> > >   	/*
> > >   	 * Unmap value blocks for this attr.
> > > @@ -719,12 +719,20 @@ __xfs_attr_rmtval_remove(
> > >   	if (error)
> > >   		return error;
> > > -	error = xfs_defer_finish(&args->trans);
> > > -	if (error)
> > > -		return error;
> > > -
> > > -	if (!done)
> > > +	/*
> > > +	 * We don't need an explicit state here to pick up where we left off. We
> > > +	 * can figure it out using the !done return code. Calling function only
> > > +	 * needs to keep recalling this routine until we indicate to stop by
> > 
> > "Callers should keep calling this routine until it returns something
> > other than -EAGAIN."
> > 
> > Also, that should go in the comment above the function.
> Alrighty, will update
> > 
> > With all those fairly minor things fixed,
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> Thanks!
> Allison
> 
> > --D
> > 
> > > +	 * returning anything other than -EAGAIN. The actual value of
> > > +	 * attr->xattri_dela_state may be some value reminiscent of the calling
> > > +	 * function, but it's value is irrelevant with in the context of this
> > > +	 * function. Once we are done here, the next state is set as needed
> > > +	 * by the parent
> > > +	 */
> > > +	if (!done) {
> > > +		dac->flags |= XFS_DAC_DEFER_FINISH;
> > >   		return -EAGAIN;
> > > +	}
> > >   	return error;
> > >   }
> > > diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> > > index 9eee615..002fd30 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_remote.h
> > > +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> > > @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> > >   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
> > >   		xfs_buf_flags_t incore_flags);
> > >   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> > > -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
> > > +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
> > >   #endif /* __XFS_ATTR_REMOTE_H__ */
> > > diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> > > index bfad669..aaa7e66 100644
> > > --- a/fs/xfs/xfs_attr_inactive.c
> > > +++ b/fs/xfs/xfs_attr_inactive.c
> > > @@ -15,10 +15,10 @@
> > >   #include "xfs_da_format.h"
> > >   #include "xfs_da_btree.h"
> > >   #include "xfs_inode.h"
> > > +#include "xfs_attr.h"
> > >   #include "xfs_attr_remote.h"
> > >   #include "xfs_trans.h"
> > >   #include "xfs_bmap.h"
> > > -#include "xfs_attr.h"
> > >   #include "xfs_attr_leaf.h"
> > >   #include "xfs_quota.h"
> > >   #include "xfs_dir2.h"
> > > -- 
> > > 2.7.4
> > > 
