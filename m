Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54032AE3E0
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Nov 2020 00:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgKJXK2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 Nov 2020 18:10:28 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55784 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgKJXK2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Nov 2020 18:10:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAN9tc2049143
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 23:10:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=mt1LhqKcfOYN3FdFb7HfTkddk28P4PypOz395Rp9d0A=;
 b=fe0P9JM2dEEXqbPtySmKxM1nZ5SG0Q2/p44/CoNx8WbmvVZXpr2NNhmunmvMAa2LfIVz
 mAmlIWTea/LPmC3Rk1IB7ZG3pEitMYS3vC/cQf2VbWSKpo1jTfryyMpPOEntoqVjInbr
 zk+CkXa+YdE/ZPA4fdFtJs2gf9QnEo8dD0p325usRXTnQD+DoPU3Fkx8dX1IKCYixWVj
 qm5DfsBQhO6zfLX/yqdK36q6hIjuSGgDzkQbZ1yvlcqL7RhHaiXOs+kkX9K6QEmvjdaK
 d270DbjkqPyo95KrxqzgTgGkP5mHsUQ4bFZZFA+Ai0B29FvpopPwRzqsr4+0UFebs+pU xA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72emmac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 23:10:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AAN55R2165826
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 23:10:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34qgp7h6bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 23:10:20 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AANAKGg022830
        for <linux-xfs@vger.kernel.org>; Tue, 10 Nov 2020 23:10:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 15:10:19 -0800
Date:   Tue, 10 Nov 2020 15:10:16 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v13 03/10] xfs: Add delay ready attr set routines
Message-ID: <20201110231016.GI9695@magnolia>
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201023063435.7510-4-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 suspectscore=5 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011100155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=5 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100155
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 11:34:28PM -0700, Allison Henderson wrote:
> This patch modifies the attr set routines to be delay ready. This means
> they no longer roll or commit transactions, but instead return -EAGAIN
> to have the calling routine roll and refresh the transaction.  In this
> series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
> state machine like switch to keep track of where it was when EAGAIN was
> returned. See xfs_attr.h for a more detailed diagram of the states.
> 
> Two new helper functions have been added: xfs_attr_rmtval_set_init and
> xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
> xfs_attr_rmtval_set, but they store the current block in the delay attr
> context to allow the caller to roll the transaction between allocations.
> This helps to simplify and consolidate code used by
> xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
> now become a simple loop to refresh the transaction until the operation
> is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
> removed.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c        | 370 ++++++++++++++++++++++++++--------------
>  fs/xfs/libxfs/xfs_attr.h        | 126 +++++++++++++-
>  fs/xfs/libxfs/xfs_attr_remote.c |  99 +++++++----
>  fs/xfs/libxfs/xfs_attr_remote.h |   4 +
>  fs/xfs/xfs_trace.h              |   1 -
>  5 files changed, 439 insertions(+), 161 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 6ca94cb..95c98d7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -44,7 +44,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>   * Internal routines when attribute list is one block.
>   */
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
> -STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> +STATIC int xfs_attr_leaf_addname(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>  
> @@ -52,12 +52,15 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>   * Internal routines when attribute list is more than one block.
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
> -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> +STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
> +STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
> +			     struct xfs_buf **leaf_bp);
>  
>  int
>  xfs_inode_hasattr(
> @@ -218,8 +221,11 @@ xfs_attr_is_shortform(
>  
>  /*
>   * Attempts to set an attr in shortform, or converts short form to leaf form if
> - * there is not enough room.  If the attr is set, the transaction is committed
> - * and set to NULL.
> + * there is not enough room.  This function is meant to operate as a helper
> + * routine to the delayed attribute functions.  It returns -EAGAIN to indicate
> + * that the calling function should roll the transaction, and then proceed to
> + * add the attr in leaf form.  This subroutine does not expect to be recalled
> + * again like the other delayed attr routines do.
>   */
>  STATIC int
>  xfs_attr_set_shortform(
> @@ -227,16 +233,16 @@ xfs_attr_set_shortform(
>  	struct xfs_buf		**leaf_bp)
>  {
>  	struct xfs_inode	*dp = args->dp;
> -	int			error, error2 = 0;
> +	int			error = 0;
>  
>  	/*
>  	 * Try to add the attr to the attribute list in the inode.
>  	 */
>  	error = xfs_attr_try_sf_addname(dp, args);
> +
> +	/* Should only be 0, -EEXIST or ENOSPC */

Nit: "...or -ENOSPC"

Also, this comment could go a couple of lines up:

	/*
	 * Try to add the attr to the attribute list in the inode.
	 * This should only return 0, -EEXIST, or -ENOSPC.
	 */
	error = xfs_attr_try_sf_addname(dp, args);
	if (error != -ENOSPC)
		return error;


>  	if (error != -ENOSPC) {
> -		error2 = xfs_trans_commit(args->trans);
> -		args->trans = NULL;
> -		return error ? error : error2;
> +		return error;
>  	}
>  	/*
>  	 * It won't fit in the shortform, transform to a leaf block.  GROT:
> @@ -249,18 +255,10 @@ xfs_attr_set_shortform(
>  	/*
>  	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
>  	 * push cannot grab the half-baked leaf buffer and run into problems
> -	 * with the write verifier. Once we're done rolling the transaction we
> -	 * can release the hold and add the attr to the leaf.
> +	 * with the write verifier.
>  	 */
>  	xfs_trans_bhold(args->trans, *leaf_bp);
> -	error = xfs_defer_finish(&args->trans);
> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
> -	if (error) {
> -		xfs_trans_brelse(args->trans, *leaf_bp);
> -		return error;
> -	}
> -
> -	return 0;
> +	return -EAGAIN;

What state are we in when return -EAGAIN here?  Are we still in
XFS_DAS_UNINIT, but with an attr fork that is no longer in local format,
which means that we skip the xfs_attr_is_shortform branch next time
around?

>  }
>  
>  /*
> @@ -268,7 +266,7 @@ xfs_attr_set_shortform(
>   * also checks for a defer finish.  Transaction is finished and rolled as
>   * needed, and returns true of false if the delayed operation should continue.
>   */
> -int
> +STATIC int
>  xfs_attr_trans_roll(
>  	struct xfs_delattr_context	*dac)
>  {
> @@ -297,61 +295,130 @@ int
>  xfs_attr_set_args(
>  	struct xfs_da_args	*args)
>  {
> -	struct xfs_inode	*dp = args->dp;
> -	struct xfs_buf          *leaf_bp = NULL;
> -	int			error = 0;
> +	struct xfs_buf			*leaf_bp = NULL;
> +	int				error = 0;
> +	struct xfs_delattr_context	dac = {
> +		.da_args	= args,
> +	};
> +
> +	do {
> +		error = xfs_attr_set_iter(&dac, &leaf_bp);
> +		if (error != -EAGAIN)
> +			break;
> +
> +		error = xfs_attr_trans_roll(&dac);
> +		if (error)
> +			return error;
> +
> +		if (leaf_bp) {
> +			xfs_trans_bjoin(args->trans, leaf_bp);
> +			xfs_trans_bhold(args->trans, leaf_bp);
> +		}
> +
> +	} while (true);
> +
> +	return error;
> +}
> +
> +/*
> + * Set the attribute specified in @args.
> + * This routine is meant to function as a delayed operation, and may return
> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
> + * to handle this, and recall the function until a successful error code is
> + * returned.
> + */
> +STATIC int
> +xfs_attr_set_iter(
> +	struct xfs_delattr_context	*dac,
> +	struct xfs_buf			**leaf_bp)
> +{
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_inode		*dp = args->dp;
> +	int				error = 0;
> +
> +	/* State machine switch */
> +	switch (dac->dela_state) {
> +	case XFS_DAS_FLIP_LFLAG:
> +	case XFS_DAS_FOUND_LBLK:

Do we need to catch XFS_DAS_RM_LBLK here?

> +		goto das_leaf;
> +	case XFS_DAS_FOUND_NBLK:
> +	case XFS_DAS_FLIP_NFLAG:
> +	case XFS_DAS_ALLOC_NODE:
> +		goto das_node;
> +	default:
> +		break;
> +	}
>  
>  	/*
>  	 * If the attribute list is already in leaf format, jump straight to
>  	 * leaf handling.  Otherwise, try to add the attribute to the shortform
>  	 * list; if there's no room then convert the list to leaf format and try
> -	 * again.
> +	 * again. No need to set state as we will be in leaf form when we come
> +	 * back
>  	 */
>  	if (xfs_attr_is_shortform(dp)) {
>  
>  		/*
> -		 * If the attr was successfully set in shortform, the
> -		 * transaction is committed and set to NULL.  Otherwise, is it
> -		 * converted from shortform to leaf, and the transaction is
> -		 * retained.
> +		 * If the attr was successfully set in shortform, no need to
> +		 * continue.  Otherwise, is it converted from shortform to leaf
> +		 * and -EAGAIN is returned.
>  		 */
> -		error = xfs_attr_set_shortform(args, &leaf_bp);
> -		if (error || !args->trans)
> -			return error;
> +		error = xfs_attr_set_shortform(args, leaf_bp);
> +		if (error == -EAGAIN)
> +			dac->flags |= XFS_DAC_DEFER_FINISH;
> +
> +		return error;
>  	}
>  
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> -		error = xfs_attr_leaf_addname(args);
> -		if (error != -ENOSPC)
> -			return error;
> +	/*
> +	 * After a shortform to leaf conversion, we need to hold the leaf and
> +	 * cycle out the transaction.  When we get back, we need to release
> +	 * the leaf.

"...to release the hold on the leaf buffer."

> +	 */
> +	if (*leaf_bp != NULL) {
> +		xfs_trans_bhold_release(args->trans, *leaf_bp);
> +		*leaf_bp = NULL;
> +	}
>  
> -		/*
> -		 * Promote the attribute list to the Btree format.
> -		 */
> -		error = xfs_attr3_leaf_to_node(args);
> -		if (error)
> -			return error;
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +		error = xfs_attr_leaf_try_add(args, *leaf_bp);
> +		switch (error) {
> +		case -ENOSPC:
> +			/*
> +			 * Promote the attribute list to the Btree format.
> +			 */
> +			error = xfs_attr3_leaf_to_node(args);
> +			if (error)
> +				return error;
>  
> -		/*
> -		 * Finish any deferred work items and roll the transaction once
> -		 * more.  The goal here is to call node_addname with the inode
> -		 * and transaction in the same state (inode locked and joined,
> -		 * transaction clean) no matter how we got to this step.
> -		 */
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> +			/*
> +			 * Finish any deferred work items and roll the
> +			 * transaction once more.  The goal here is to call
> +			 * node_addname with the inode and transaction in the
> +			 * same state (inode locked and joined, transaction
> +			 * clean) no matter how we got to this step.
> +			 */
> +			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			return -EAGAIN;

What state should we be in at this -EAGAIN return?  Is it
XFS_DAS_UNINIT, but with more than one extent in the attr fork?

/me is wishing these would get turned into explicit states, since afaict
we don't unlock the inode and so we should find it in /exactly/ the
state that the delattr_context says it should be in.

> +		case 0:
> +			dac->dela_state = XFS_DAS_FOUND_LBLK;
> +			return -EAGAIN;
> +		default:
>  			return error;
> +		}
> +das_leaf:

The only way to get to this block of code is by jumping to das_leaf,
from the switch statement above, right?  If so, then shouldn't it be up
there in the switch statement?

> +		error = xfs_attr_leaf_addname(dac);
> +		if (error == -ENOSPC)
> +			/*
> +			 * No need to set state.  We will be in node form when
> +			 * we are recalled
> +			 */
> +			return -EAGAIN;

How do we get to node form?

> -		/*
> -		 * Commit the current trans (including the inode) and
> -		 * start a new one.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
> +		return error;
>  	}
> -
> -	error = xfs_attr_node_addname(args);
> +das_node:
> +	error = xfs_attr_node_addname(dac);
>  	return error;

Similarly, I think the only way get to this block of code is if we're in
the initial state (XFS_DAS_UNINIT?) and the inode wasn't in short
format; or if we jumped here via DAS_{FOUND_NBLK,FLIP_NFLAG,ALLOC_NODE},
right?

I think you could straighten this out a bit further (I left out the
comments):

	switch (dac->dela_state) {
	case XFS_DAS_FLIP_LFLAG:
	case XFS_DAS_FOUND_LBLK:
		error = xfs_attr_leaf_addname(dac);
		if (error == -ENOSPC)
			return -EAGAIN;
		return error;
	case XFS_DAS_FOUND_NBLK:
	case XFS_DAS_FLIP_NFLAG:
	case XFS_DAS_ALLOC_NODE:
		return xfs_attr_node_addname(dac);
	case XFS_DAS_UNINIT:
		break;
	default:
		...assert on the XFS_DAS_RM_* flags...
	}

	if (xfs_attr_is_shortform(dp))
		return xfs_attr_set_shortform(args, leaf_bp);

	if (*leaf_bp != NULL) {
		...release bhold...
	}

	if (!xfs_bmap_one_block(...))
		return xfs_attr_node_addname(dac);

	error = xfs_attr_leaf_try_add(args, *leaf_bp);
	switch (error) {
	...handle -ENOSPC and 0...
	}
	return error;

>  }
>  
> @@ -723,28 +790,30 @@ xfs_attr_leaf_try_add(
>   *
>   * This leaf block cannot have a "remote" value, we only call this routine
>   * if bmap_one_block() says there is only one block (ie: no remote blks).
> + *
> + * This routine is meant to function as a delayed operation, and may return
> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
> + * to handle this, and recall the function until a successful error code is
> + * returned.
>   */
>  STATIC int
>  xfs_attr_leaf_addname(
> -	struct xfs_da_args	*args)
> +	struct xfs_delattr_context	*dac)
>  {
> -	int			error, forkoff;
> -	struct xfs_buf		*bp = NULL;
> -	struct xfs_inode	*dp = args->dp;
> -
> -	trace_xfs_attr_leaf_addname(args);
> -
> -	error = xfs_attr_leaf_try_add(args, bp);
> -	if (error)
> -		return error;
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_buf			*bp = NULL;
> +	int				error, forkoff;
> +	struct xfs_inode		*dp = args->dp;
>  
> -	/*
> -	 * Commit the transaction that added the attr name so that
> -	 * later routines can manage their own transactions.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		return error;
> +	/* State machine switch */
> +	switch (dac->dela_state) {
> +	case XFS_DAS_FLIP_LFLAG:
> +		goto das_flip_flag;
> +	case XFS_DAS_RM_LBLK:
> +		goto das_rm_lblk;
> +	default:
> +		break;
> +	}
>  
>  	/*
>  	 * If there was an out-of-line value, allocate the blocks we
> @@ -752,12 +821,34 @@ xfs_attr_leaf_addname(
>  	 * after we create the attribute so that we don't overflow the
>  	 * maximum size of a transaction and/or hit a deadlock.
>  	 */
> -	if (args->rmtblkno > 0) {
> -		error = xfs_attr_rmtval_set(args);
> +
> +	/* Open coded xfs_attr_rmtval_set without trans handling */
> +	if ((dac->flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
> +		dac->flags |= XFS_DAC_LEAF_ADDNAME_INIT;
> +		if (args->rmtblkno > 0) {
> +			error = xfs_attr_rmtval_find_space(dac);
> +			if (error)
> +				return error;
> +		}
> +	}
> +
> +	/*
> +	 * Roll through the "value", allocating blocks on disk as
> +	 * required.
> +	 */
> +	if (dac->blkcnt > 0) {
> +		error = xfs_attr_rmtval_set_blk(dac);
>  		if (error)
>  			return error;
> +
> +		dac->flags |= XFS_DAC_DEFER_FINISH;
> +		return -EAGAIN;

What state are we in here?  FOUND_LBLK, with blkcnt slowly decreasing?

>  	}
>  
> +	error = xfs_attr_rmtval_set_value(args);
> +	if (error)
> +		return error;
> +
>  	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
>  		/*
>  		 * Added a "remote" value, just clear the incomplete flag.
> @@ -777,29 +868,29 @@ xfs_attr_leaf_addname(
>  	 * In a separate transaction, set the incomplete flag on the "old" attr
>  	 * and clear the incomplete flag on the "new" attr.
>  	 */
> -
>  	error = xfs_attr3_leaf_flipflags(args);
>  	if (error)
>  		return error;
>  	/*
>  	 * Commit the flag value change and start the next trans in series.
>  	 */
> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> -	if (error)
> -		return error;
> -
> +	dac->dela_state = XFS_DAS_FLIP_LFLAG;
> +	return -EAGAIN;
> +das_flip_flag:
>  	/*
>  	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>  	 * (if it exists).
>  	 */
>  	xfs_attr_restore_rmt_blk(args);
>  
> +	error = xfs_attr_rmtval_invalidate(args);
> +	if (error)
> +		return error;
> +das_rm_lblk:
>  	if (args->rmtblkno) {
> -		error = xfs_attr_rmtval_invalidate(args);
> -		if (error)
> -			return error;
> -
> -		error = xfs_attr_rmtval_remove(args);
> +		error = __xfs_attr_rmtval_remove(dac);
> +		if (error == -EAGAIN)
> +			dac->dela_state = XFS_DAS_RM_LBLK;
>  		if (error)
>  			return error;
>  	}
> @@ -965,23 +1056,38 @@ xfs_attr_node_hasname(
>   *
>   * "Remote" attribute values confuse the issue and atomic rename operations
>   * add a whole extra layer of confusion on top of that.
> + *
> + * This routine is meant to function as a delayed operation, and may return
> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
> + * to handle this, and recall the function until a successful error code is
> + *returned.
>   */
>  STATIC int
>  xfs_attr_node_addname(
> -	struct xfs_da_args	*args)
> +	struct xfs_delattr_context	*dac)
>  {
> -	struct xfs_da_state	*state;
> -	struct xfs_da_state_blk	*blk;
> -	struct xfs_inode	*dp;
> -	int			retval, error;
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_da_state		*state = NULL;
> +	struct xfs_da_state_blk		*blk;
> +	int				retval = 0;
> +	int				error = 0;
>  
>  	trace_xfs_attr_node_addname(args);
>  
> -	/*
> -	 * Fill in bucket of arguments/results/context to carry around.
> -	 */
> -	dp = args->dp;
> -restart:
> +	/* State machine switch */
> +	switch (dac->dela_state) {
> +	case XFS_DAS_FLIP_NFLAG:
> +		goto das_flip_flag;
> +	case XFS_DAS_FOUND_NBLK:
> +		goto das_found_nblk;
> +	case XFS_DAS_ALLOC_NODE:
> +		goto das_alloc_node;
> +	case XFS_DAS_RM_NBLK:
> +		goto das_rm_nblk;
> +	default:
> +		break;
> +	}
> +
>  	/*
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
> @@ -1027,19 +1133,13 @@ xfs_attr_node_addname(
>  			error = xfs_attr3_leaf_to_node(args);
>  			if (error)
>  				goto out;
> -			error = xfs_defer_finish(&args->trans);
> -			if (error)
> -				goto out;
>  
>  			/*
> -			 * Commit the node conversion and start the next
> -			 * trans in the chain.
> +			 * Restart routine from the top.  No need to set  the
> +			 * state
>  			 */
> -			error = xfs_trans_roll_inode(&args->trans, dp);
> -			if (error)
> -				goto out;
> -
> -			goto restart;
> +			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			return -EAGAIN;

What state are we in here?  Are we still in the same state that we were
at the start of the function, but ready to try xfs_attr3_leaf_add again?

>  		}
>  
>  		/*
> @@ -1051,9 +1151,7 @@ xfs_attr_node_addname(
>  		error = xfs_da3_split(state);
>  		if (error)
>  			goto out;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			goto out;
> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>  	} else {
>  		/*
>  		 * Addition succeeded, update Btree hashvals.
> @@ -1068,13 +1166,9 @@ xfs_attr_node_addname(
>  	xfs_da_state_free(state);
>  	state = NULL;
>  
> -	/*
> -	 * Commit the leaf addition or btree split and start the next
> -	 * trans in the chain.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		goto out;
> +	dac->dela_state = XFS_DAS_FOUND_NBLK;
> +	return -EAGAIN;
> +das_found_nblk:
>  
>  	/*
>  	 * If there was an out-of-line value, allocate the blocks we
> @@ -1083,7 +1177,27 @@ xfs_attr_node_addname(
>  	 * maximum size of a transaction and/or hit a deadlock.
>  	 */
>  	if (args->rmtblkno > 0) {
> -		error = xfs_attr_rmtval_set(args);
> +		/* Open coded xfs_attr_rmtval_set without trans handling */
> +		error = xfs_attr_rmtval_find_space(dac);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Roll through the "value", allocating blocks on disk as
> +		 * required.
> +		 */
> +das_alloc_node:
> +		if (dac->blkcnt > 0) {
> +			error = xfs_attr_rmtval_set_blk(dac);
> +			if (error)
> +				return error;
> +
> +			dac->flags |= XFS_DAC_DEFER_FINISH;
> +			dac->dela_state = XFS_DAS_ALLOC_NODE;
> +			return -EAGAIN;
> +		}
> +
> +		error = xfs_attr_rmtval_set_value(args);
>  		if (error)
>  			return error;
>  	}
> @@ -1113,22 +1227,28 @@ xfs_attr_node_addname(
>  	/*
>  	 * Commit the flag value change and start the next trans in series
>  	 */
> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> -	if (error)
> -		goto out;
> -
> +	dac->dela_state = XFS_DAS_FLIP_NFLAG;
> +	return -EAGAIN;
> +das_flip_flag:
>  	/*
>  	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>  	 * (if it exists).
>  	 */
>  	xfs_attr_restore_rmt_blk(args);
>  
> +	error = xfs_attr_rmtval_invalidate(args);
> +	if (error)
> +		return error;
> +
> +das_rm_nblk:
>  	if (args->rmtblkno) {
> -		error = xfs_attr_rmtval_invalidate(args);
> -		if (error)
> -			return error;
> +		error = __xfs_attr_rmtval_remove(dac);
> +
> +		if (error == -EAGAIN) {
> +			dac->dela_state = XFS_DAS_RM_NBLK;
> +			return -EAGAIN;
> +		}
>  
> -		error = xfs_attr_rmtval_remove(args);
>  		if (error)
>  			return error;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 64dcf0f..501f9df 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -106,6 +106,118 @@ struct xfs_attr_list_context {
>   *	                                      v         │
>   *	                                     done <─────┘
>   *
> + *
> + * Below is a state machine diagram for attr set operations.
> + *
> + *  xfs_attr_set_iter()
> + *             │
> + *             v

I think this diagram is missing the part where we attempt to add a
shortform attr?

--D

> + *   ┌───n── fork has
> + *   │	    only 1 blk?
> + *   │		│
> + *   │		y
> + *   │		│
> + *   │		v
> + *   │	xfs_attr_leaf_try_add()
> + *   │		│
> + *   │		v
> + *   │	     had enough
> + *   ├───n────space?
> + *   │		│
> + *   │		y
> + *   │		│
> + *   │		v
> + *   │	XFS_DAS_FOUND_LBLK ──┐
> + *   │	                     │
> + *   │	XFS_DAS_FLIP_LFLAG ──┤
> + *   │	(subroutine state)   │
> + *   │		             │
> + *   │		             └─>xfs_attr_leaf_addname()
> + *   │		                      │
> + *   │		                      v
> + *   │		                   was this
> + *   │		                   a rename? ──n─┐
> + *   │		                      │          │
> + *   │		                      y          │
> + *   │		                      │          │
> + *   │		                      v          │
> + *   │		                flip incomplete  │
> + *   │		                    flag         │
> + *   │		                      │          │
> + *   │		                      v          │
> + *   │		              XFS_DAS_FLIP_LFLAG │
> + *   │		                      │          │
> + *   │		                      v          │
> + *   │		                    remove       │
> + *   │		XFS_DAS_RM_LBLK ─> old name      │
> + *   │		         ^            │          │
> + *   │		         │            v          │
> + *   │		         └──────y── more to      │
> + *   │		                    remove       │
> + *   │		                      │          │
> + *   │		                      n          │
> + *   │		                      │          │
> + *   │		                      v          │
> + *   │		                     done <──────┘
> + *   └──> XFS_DAS_FOUND_NBLK ──┐
> + *	  (subroutine state)   │
> + *	                       │
> + *	  XFS_DAS_ALLOC_NODE ──┤
> + *	  (subroutine state)   │
> + *	                       │
> + *	  XFS_DAS_FLIP_NFLAG ──┤
> + *	  (subroutine state)   │
> + *	                       │
> + *	                       └─>xfs_attr_node_addname()
> + *	                               │
> + *	                               v
> + *	                       find space to store
> + *	                      attr. Split if needed
> + *	                               │
> + *	                               v
> + *	                       XFS_DAS_FOUND_NBLK
> + *	                               │
> + *	                               v
> + *	                 ┌─────n──  need to
> + *	                 │        alloc blks?
> + *	                 │             │
> + *	                 │             y
> + *	                 │             │
> + *	                 │             v
> + *	                 │  ┌─>XFS_DAS_ALLOC_NODE
> + *	                 │  │          │
> + *	                 │  │          v
> + *	                 │  └──y── need to alloc
> + *	                 │         more blocks?
> + *	                 │             │
> + *	                 │             n
> + *	                 │             │
> + *	                 │             v
> + *	                 │          was this
> + *	                 └────────> a rename? ──n─┐
> + *	                               │          │
> + *	                               y          │
> + *	                               │          │
> + *	                               v          │
> + *	                         flip incomplete  │
> + *	                             flag         │
> + *	                               │          │
> + *	                               v          │
> + *	                       XFS_DAS_FLIP_NFLAG │
> + *	                               │          │
> + *	                               v          │
> + *	                             remove       │
> + *	         XFS_DAS_RM_NBLK ─> old name      │
> + *	                  ^            │          │
> + *	                  │            v          │
> + *	                  └──────y── more to      │
> + *	                             remove       │
> + *	                               │          │
> + *	                               n          │
> + *	                               │          │
> + *	                               v          │
> + *	                              done <──────┘
> + *
>   */
>  
>  /*
> @@ -120,6 +232,13 @@ struct xfs_attr_list_context {
>  enum xfs_delattr_state {
>  	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
>  	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
> +	XFS_DAS_FOUND_LBLK,	      /* We found leaf blk for attr */
> +	XFS_DAS_FOUND_NBLK,	      /* We found node blk for attr */
> +	XFS_DAS_FLIP_LFLAG,	      /* Flipped leaf INCOMPLETE attr flag */
> +	XFS_DAS_RM_LBLK,	      /* A rename is removing leaf blocks */
> +	XFS_DAS_ALLOC_NODE,	      /* We are allocating node blocks */
> +	XFS_DAS_FLIP_NFLAG,	      /* Flipped node INCOMPLETE attr flag */
> +	XFS_DAS_RM_NBLK,	      /* A rename is removing node blocks */
>  };
>  
>  /*
> @@ -127,6 +246,7 @@ enum xfs_delattr_state {
>   */
>  #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>  #define XFS_DAC_NODE_RMVNAME_INIT	0x02 /* xfs_attr_node_removename init */
> +#define XFS_DAC_LEAF_ADDNAME_INIT	0x04 /* xfs_attr_leaf_addname init*/
>  
>  /*
>   * Context used for keeping track of delayed attribute operations
> @@ -134,6 +254,11 @@ enum xfs_delattr_state {
>  struct xfs_delattr_context {
>  	struct xfs_da_args      *da_args;
>  
> +	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
> +	struct xfs_bmbt_irec	map;
> +	xfs_dablk_t		lblkno;
> +	int			blkcnt;
> +
>  	/* Used in xfs_attr_node_removename to roll through removing blocks */
>  	struct xfs_da_state     *da_state;
>  
> @@ -160,7 +285,6 @@ int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
> -int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
>  bool xfs_attr_namecheck(const void *name, size_t length);
>  void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>  			      struct xfs_da_args *args);
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 1426c15..5b445e7 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -441,7 +441,7 @@ xfs_attr_rmtval_get(
>   * Find a "hole" in the attribute address space large enough for us to drop the
>   * new attribute's value into
>   */
> -STATIC int
> +int
>  xfs_attr_rmt_find_hole(
>  	struct xfs_da_args	*args)
>  {
> @@ -468,7 +468,7 @@ xfs_attr_rmt_find_hole(
>  	return 0;
>  }
>  
> -STATIC int
> +int
>  xfs_attr_rmtval_set_value(
>  	struct xfs_da_args	*args)
>  {
> @@ -628,6 +628,69 @@ xfs_attr_rmtval_set(
>  }
>  
>  /*
> + * Find a hole for the attr and store it in the delayed attr context.  This
> + * initializes the context to roll through allocating an attr extent for a
> + * delayed attr operation
> + */
> +int
> +xfs_attr_rmtval_find_space(
> +	struct xfs_delattr_context	*dac)
> +{
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_bmbt_irec		*map = &dac->map;
> +	int				error;
> +
> +	dac->lblkno = 0;
> +	dac->blkcnt = 0;
> +	args->rmtblkcnt = 0;
> +	args->rmtblkno = 0;
> +	memset(map, 0, sizeof(struct xfs_bmbt_irec));
> +
> +	error = xfs_attr_rmt_find_hole(args);
> +	if (error)
> +		return error;
> +
> +	dac->blkcnt = args->rmtblkcnt;
> +	dac->lblkno = args->rmtblkno;
> +
> +	return 0;
> +}
> +
> +/*
> + * Write one block of the value associated with an attribute into the
> + * out-of-line buffer that we have defined for it. This is similar to a subset
> + * of xfs_attr_rmtval_set, but records the current block to the delayed attr
> + * context, and leaves transaction handling to the caller.
> + */
> +int
> +xfs_attr_rmtval_set_blk(
> +	struct xfs_delattr_context	*dac)
> +{
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_inode		*dp = args->dp;
> +	struct xfs_bmbt_irec		*map = &dac->map;
> +	int nmap;
> +	int error;
> +
> +	nmap = 1;
> +	error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)dac->lblkno,
> +				dac->blkcnt, XFS_BMAPI_ATTRFORK, args->total,
> +				map, &nmap);
> +	if (error)
> +		return error;
> +
> +	ASSERT(nmap == 1);
> +	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
> +	       (map->br_startblock != HOLESTARTBLOCK));
> +
> +	/* roll attribute extent map forwards */
> +	dac->lblkno += map->br_blockcount;
> +	dac->blkcnt -= map->br_blockcount;
> +
> +	return 0;
> +}
> +
> +/*
>   * Remove the value associated with an attribute by deleting the
>   * out-of-line buffer that it is stored on.
>   */
> @@ -669,38 +732,6 @@ xfs_attr_rmtval_invalidate(
>  }
>  
>  /*
> - * Remove the value associated with an attribute by deleting the
> - * out-of-line buffer that it is stored on.
> - */
> -int
> -xfs_attr_rmtval_remove(
> -	struct xfs_da_args		*args)
> -{
> -	int				error;
> -	struct xfs_delattr_context	dac  = {
> -		.da_args	= args,
> -	};
> -
> -	trace_xfs_attr_rmtval_remove(args);
> -
> -	/*
> -	 * Keep de-allocating extents until the remote-value region is gone.
> -	 */
> -	do {
> -		error = __xfs_attr_rmtval_remove(&dac);
> -		if (error != -EAGAIN)
> -			break;
> -
> -		error = xfs_attr_trans_roll(&dac);
> -		if (error)
> -			return error;
> -
> -	} while (true);
> -
> -	return error;
> -}
> -
> -/*
>   * Remove the value associated with an attribute by deleting the out-of-line
>   * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>   * transaction and re-call the function
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index 002fd30..84e2700 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -15,4 +15,8 @@ int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>  int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
> +int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
> +int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
> +int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
> +int xfs_attr_rmtval_find_space(struct xfs_delattr_context *dac);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 8695165..e9dde4e 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1925,7 +1925,6 @@ DEFINE_ATTR_EVENT(xfs_attr_refillstate);
>  
>  DEFINE_ATTR_EVENT(xfs_attr_rmtval_get);
>  DEFINE_ATTR_EVENT(xfs_attr_rmtval_set);
> -DEFINE_ATTR_EVENT(xfs_attr_rmtval_remove);
>  
>  #define DEFINE_DA_EVENT(name) \
>  DEFINE_EVENT(xfs_da_class, name, \
> -- 
> 2.7.4
> 
