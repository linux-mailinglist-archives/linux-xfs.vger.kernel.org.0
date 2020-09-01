Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC22259CD1
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Sep 2020 19:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732644AbgIARUj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Sep 2020 13:20:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44562 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730120AbgIARUb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 13:20:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081HIs0b061361;
        Tue, 1 Sep 2020 17:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=XL7FXq57N/a7z8C33oyuc+Tt2cL+5F+xCgk9+V6tLpQ=;
 b=o/VkBy9J0IBiNalWoHounV30RBBrVSAOrOm41VPVfQFU/3AJGk2147w9vIkBbujnEPdW
 qur+QoDHRte9bCZq9uIkrt6cX3Yzrlnivcq5ajPDk8BMpoAgatuGWEOqQg+nrz8xQV4u
 Qc9+vCbzkvSY7RayOms5Hma/Z0MVrTjQx/qlmGQNIt4Sns6BHJ4CHLKYJ+TTtEmJW/HS
 borNGLgTY48kdn2o13ZGV8gWhkVEd8aaW+VTIDOkWSL6ii0U2mE+5KMeymE89PQ8zzl+
 0CHJnj5hvaWXPaMHaa1hYGu8wYSVrvg3KpVvx5U9uaV1KoA5aiT0sL4SkJvBUlVq+8GE lA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 337eeqwuk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Sep 2020 17:20:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 081HFDqL017987;
        Tue, 1 Sep 2020 17:20:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3380knka7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Sep 2020 17:20:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 081HKNkG008345;
        Tue, 1 Sep 2020 17:20:23 GMT
Received: from localhost (/10.159.133.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 10:20:22 -0700
Date:   Tue, 1 Sep 2020 10:20:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v12 1/8] xfs: Add delay ready attr remove routines
Message-ID: <20200901172021.GI6096@magnolia>
References: <20200827003518.1231-1-allison.henderson@oracle.com>
 <20200827003518.1231-2-allison.henderson@oracle.com>
 <20200901170020.GC174813@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200901170020.GC174813@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=1 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010145
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 01, 2020 at 01:00:20PM -0400, Brian Foster wrote:
> On Wed, Aug 26, 2020 at 05:35:11PM -0700, Allison Collins wrote:
> > This patch modifies the attr remove routines to be delay ready. This
> > means they no longer roll or commit transactions, but instead return
> > -EAGAIN to have the calling routine roll and refresh the transaction. In
> > this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
> > uses a sort of state machine like switch to keep track of where it was
> > when EAGAIN was returned. xfs_attr_node_removename has also been
> > modified to use the switch, and a new version of xfs_attr_remove_args
> > consists of a simple loop to refresh the transaction until the operation
> > is completed.  A new XFS_DAC_DEFER_FINISH flag is used to finish the
> > transaction where ever the existing code used to.
> > 
> > Calls to xfs_attr_rmtval_remove are replaced with the delay ready
> > version __xfs_attr_rmtval_remove. We will rename
> > __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
> > done.
> > 
> > xfs_attr_rmtval_remove itself is still in use by the set routines (used
> > during a rename).  For reasons of perserving existing function, we
> 
> Nit:				preserving
> 
> > modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
> > set.  Similar to how xfs_attr_remove_args does here.  Once we transition
> > the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
> > used and will be removed.
> > 
> > This patch also adds a new struct xfs_delattr_context, which we will use
> > to keep track of the current state of an attribute operation. The new
> > xfs_delattr_state enum is used to track various operations that are in
> > progress so that we know not to repeat them, and resume where we left
> > off before EAGAIN was returned to cycle out the transaction. Other
> > members take the place of local variables that need to retain their
> > values across multiple function recalls.  See xfs_attr.h for a more
> > detailed diagram of the states.
> > 
> > Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_attr.c        | 162 ++++++++++++++++++++++++++++++----------
> >  fs/xfs/libxfs/xfs_attr.h        |  73 ++++++++++++++++++
> >  fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
> >  fs/xfs/libxfs/xfs_attr_remote.c |  39 +++++-----
> >  fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
> >  fs/xfs/xfs_attr_inactive.c      |   2 +-
> >  6 files changed, 220 insertions(+), 60 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > index 2e055c0..ea50fc3 100644
> > --- a/fs/xfs/libxfs/xfs_attr.c
> > +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
> > @@ -264,6 +264,33 @@ xfs_attr_set_shortform(
> >  }
> >  
> >  /*
> > + * Checks to see if a delayed attribute transaction should be rolled.  If so,
> > + * also checks for a defer finish.  Transaction is finished and rolled as
> > + * needed, and returns true of false if the delayed operation should continue.
> > + */
> > +int
> > +xfs_attr_trans_roll(
> > +	struct xfs_delattr_context	*dac)
> > +{
> > +	struct xfs_da_args              *args = dac->da_args;
> > +	int				error = 0;
> > +
> > +	if (dac->flags & XFS_DAC_DEFER_FINISH) {
> > +		/*
> > +		 * The caller wants us to finish all the deferred ops so that we
> > +		 * avoid pinning the log tail with a large number of deferred
> > +		 * ops.
> > +		 */
> > +		dac->flags &= ~XFS_DAC_DEFER_FINISH;
> > +		error = xfs_defer_finish(&args->trans);
> > +		if (error)
> > +			return error;
> > +	}
> > +
> > +	return xfs_trans_roll_inode(&args->trans, args->dp);
> 
> I'm not sure there's a need to roll the transaction again if the
> defer path above executes. xfs_defer_finish() completes the dfops and
> always returns a clean transaction.

I'm not sure we even really need a DEFER_FINISH flag if (a) xfs_defer.c
gets patched to finish all the other defer items before coming back to
the next step of the delattr state machine and (b) Allison removes the
_iter functions in favor of using the defer op mechanism even when we're
not pushing the state changes through the log.

(I'm working on (a) still, will have something in a few days...)

> > +}
> > +
> > +/*
> >   * Set the attribute specified in @args.
> >   */
> >  int
> ...
> > @@ -1218,21 +1288,35 @@ xfs_attr_node_remove_rmt(
> >   * This will involve walking down the Btree, and may involve joining
> >   * leaf nodes and even joining intermediate nodes up to and including
> >   * the root node (a special case of an intermediate node).
> > + *
> > + * This routine is meant to function as either an inline or delayed operation,
> > + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
> > + * functions will need to handle this, and recall the function until a
> > + * successful error code is returned.
> >   */
> >  STATIC int
> >  xfs_attr_node_removename(
> > -	struct xfs_da_args	*args)
> > +	struct xfs_delattr_context	*dac)
> >  {
> > -	struct xfs_da_state	*state;
> > -	struct xfs_da_state_blk	*blk;
> > -	int			retval, error;
> > -	struct xfs_inode	*dp = args->dp;
> > +	struct xfs_da_args		*args = dac->da_args;
> > +	struct xfs_da_state		*state;
> > +	struct xfs_da_state_blk		*blk;
> > +	int				retval, error;
> > +	struct xfs_inode		*dp = args->dp;
> >  
> >  	trace_xfs_attr_node_removename(args);
> > +	state = dac->da_state;
> > +	blk = dac->blk;
> >  
> > -	error = xfs_attr_node_removename_setup(args, &state);
> > -	if (error)
> > -		goto out;
> > +	if (dac->dela_state == XFS_DAS_RM_SHRINK)
> > +		goto das_rm_shrink;
> > +
> > +	if ((dac->flags & XFS_DAC_NODE_RMVNAME_INIT) == 0) {
> > +		dac->flags |= XFS_DAC_NODE_RMVNAME_INIT;
> > +		error = xfs_attr_node_removename_setup(dac, &state);
> > +		if (error)
> > +			goto out;
> > +	}
> >  
> >  	/*
> >  	 * If there is an out-of-line value, de-allocate the blocks.
> > @@ -1240,8 +1324,13 @@ xfs_attr_node_removename(
> >  	 * overflow the maximum size of a transaction and/or hit a deadlock.
> >  	 */
> >  	if (args->rmtblkno > 0) {
> > -		error = xfs_attr_node_remove_rmt(args, state);
> > -		if (error)
> > +		/*
> > +		 * May return -EAGAIN. Remove blocks until args->rmtblkno == 0
> > +		 */
> > +		error = xfs_attr_node_remove_rmt(dac, state);
> > +		if (error == -EAGAIN)
> > +			return error;
> > +		else if (error)
> >  			goto out;
> >  	}
> >  
> > @@ -1260,17 +1349,14 @@ xfs_attr_node_removename(
> >  		error = xfs_da3_join(state);
> >  		if (error)
> >  			goto out;
> > -		error = xfs_defer_finish(&args->trans);
> > -		if (error)
> > -			goto out;
> > -		/*
> > -		 * Commit the Btree join operation and start a new trans.
> > -		 */
> > -		error = xfs_trans_roll_inode(&args->trans, dp);
> > -		if (error)
> > -			goto out;
> > +
> > +		dac->flags |= XFS_DAC_DEFER_FINISH;
> > +		dac->dela_state = XFS_DAS_RM_SHRINK;
> > +		return -EAGAIN;
> >  	}
> >  
> > +das_rm_shrink:
> > +
> >  	/*
> >  	 * If the result is small enough, push it all into the inode.
> >  	 */
> 
> ISTR that Dave or Darrick previously suggested that we should try to
> isolate the state transition code as much as possible to a single
> location. That basically means we should look at any place a particular
> state check travels through multiple functions and see if we can
> refactor things to flatten the state processing code. I tend to agree
> that is the ideal approach given how difficult it can be to track state
> changes through multiple functions.

Yes. :)

> In light of that (and as an example), I think the whole
> xfs_attr_node_removename() path should be refactored so it looks
> something like the following (with obvious error
> handling/comment/aesthetic cleanups etc.):
> 
> xfs_attr_node_removename_iter()
> {
> 	...
> 
> 	if ((dac->flags & XFS_DAC_NODE_RMVNAME_INIT) == 0) {
> 		<do init stuff>
> 	}
> 
> 	switch (dac->dela_state) {
> 	case 0:

I kinda wish "0" had its own name, but I don't also want to start
another round of naming bikeshed. :)

> 		/* 
> 		 * repeatedly remove remote blocks, remove the entry and
> 		 * join. returns -EAGAIN or 0 for completion of the step.
> 		 */
> 		error = xfs_attr_node_remove_step(dac, state);
> 		if (error)
> 			break;
> 
> 		/* check whether to shrink or return success */
> 		if (!error && xfs_bmap_one_block(...)) {
> 			dac->dela_state = XFS_DAS_RM_SHRINK;
> 			error = -EAGAIN;
> 		}
> 		break;
> 	case XFS_DAS_RM_SHRINK:
> 		/* shrink the fork, no reentry, no next step */
> 		error = xfs_attr_node_shrink_step(args, state);	
> 		break;

<nod> The ASCII art diagrams help assuage my nerves about the fact that
we branch based on dela_state but not all the branches actually show us
moving to the next state.

I've gotten the distinct sense, though, that throwing the new state all
the way back up to _iter() to set it is probably a lot more fuss than
it's worth for the attr set case, though...

> 	default:
> 		ASSERT(0);
> 		return -EINVAL;
> 	}
> 
> 	if (error == -EAGAIN)
> 		return error;
> 
> 	<do cleanup stuff>
> 	...
> 	return error;
> }
> 
> The idea here is that we have one _iter() function that does all the
> state management for a particular operation and has minimal other logic.
> That way we can see the states that repeat, transition, etc. all in one
> place. The _step() functions implement the functional components of each
> state and do no state management whatsoever beyond return -EAGAIN to
> request reentry or return 0 for completion. In the case of the latter,
> the _iter() function decides whether to transition to another state
> (returning -EAGAIN itself) or complete the operation. If a _step()
> function ever needs to set or check ->dela_state, then that is clear
> indication it must be broken up into multiple _step() functions.

...because I've frequently had the same thought that the state machine
handling ought to be in the same place.  But then I start reading
through the xattr code to figure out how that would be done, and get
trapped by the fact that some of the decisions about the next state have
to happen pretty deep in the xattr code-- stuff like allocating an
extent for a remote value, where depending on whether or not we got enough
blocks to satisfy the space requirements, either we can move on to the
next state and return EAGAIN, or we have to save the current state and
EAGAIN to try to get more blocks.

Maybe it would help a little if the setting of DEFER_FINISH and changing
of dela_state could be put into a little helper with a tracepoint so
that future us can ftrace the state machine to make sure it's working
correctly?

> I think this implements the separation of state and functionality model
> we're after without introduction of crazy state processing frameworks,

"crazy state processing frameworks"... like xfs_defer.c? :)

> etc., but I admit I've so far only thought about it wrt the remove case
> (which is more simple than the set case). Also note that as usual, any
> associated refactoring of the functional components should come as
> preliminary patches such that this patch only introduces state bits.
> Thoughts?

(I thought/hoped we'd done all the refactoring in the 23-patch megalith
that I tossed into 5.9... :))

--D

> Brian
> 
> > diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> > index 3e97a93..9573949 100644
> > --- a/fs/xfs/libxfs/xfs_attr.h
> > +++ b/fs/xfs/libxfs/xfs_attr.h
> > @@ -74,6 +74,75 @@ struct xfs_attr_list_context {
> >  };
> >  
> >  
> > +/*
> > + * ========================================================================
> > + * Structure used to pass context around among the delayed routines.
> > + * ========================================================================
> > + */
> > +
> > +/*
> > + * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
> > + * states indicate places where the function would return -EAGAIN, and then
> > + * immediately resume from after being recalled by the calling function. States
> > + * marked as a "subroutine state" indicate that they belong to a subroutine, and
> > + * so the calling function needs to pass them back to that subroutine to allow
> > + * it to finish where it left off. But they otherwise do not have a role in the
> > + * calling function other than just passing through.
> > + *
> > + * xfs_attr_remove_iter()
> > + *	  XFS_DAS_RM_SHRINK â”€â”�
> > + *	  (subroutine state) â”‚
> > + *	                     â””â”€>xfs_attr_node_removename()
> > + *	                                      â”‚
> > + *	                                      v
> > + *	                                   need to
> > + *	                                shrink tree? â”€nâ”€â”�
> > + *	                                      â”‚         â”‚
> > + *	                                      y         â”‚
> > + *	                                      â”‚         â”‚
> > + *	                                      v         â”‚
> > + *	                              XFS_DAS_RM_SHRINK â”‚
> > + *	                                      â”‚         â”‚
> > + *	                                      v         â”‚
> > + *	                                     done <â”€â”€â”€â”€â”€â”˜
> > + *
> > + */
> > +
> > +/*
> > + * Enum values for xfs_delattr_context.da_state
> > + *
> > + * These values are used by delayed attribute operations to keep track  of where
> > + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
> > + * calling function to roll the transaction, and then recall the subroutine to
> > + * finish the operation.  The enum is then used by the subroutine to jump back
> > + * to where it was and resume executing where it left off.
> > + */
> > +enum xfs_delattr_state {
> > +				      /* Zero is uninitalized */
> > +	XFS_DAS_RM_SHRINK	= 1,  /* We are shrinking the tree */
> > +};
> > +
> > +/*
> > + * Defines for xfs_delattr_context.flags
> > + */
> > +#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
> > +#define XFS_DAC_NODE_RMVNAME_INIT	0x02 /* xfs_attr_node_removename init */
> > +
> > +/*
> > + * Context used for keeping track of delayed attribute operations
> > + */
> > +struct xfs_delattr_context {
> > +	struct xfs_da_args      *da_args;
> > +
> > +	/* Used in xfs_attr_node_removename to roll through removing blocks */
> > +	struct xfs_da_state     *da_state;
> > +	struct xfs_da_state_blk *blk;
> > +
> > +	/* Used to keep track of current state of delayed operation */
> > +	unsigned int            flags;
> > +	enum xfs_delattr_state  dela_state;
> > +};
> > +
> >  /*========================================================================
> >   * Function prototypes for the kernel.
> >   *========================================================================*/
> > @@ -91,6 +160,10 @@ int xfs_attr_set(struct xfs_da_args *args);
> >  int xfs_attr_set_args(struct xfs_da_args *args);
> >  int xfs_has_attr(struct xfs_da_args *args);
> >  int xfs_attr_remove_args(struct xfs_da_args *args);
> > +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
> > +int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
> >  bool xfs_attr_namecheck(const void *name, size_t length);
> > +void xfs_delattr_context_init(struct xfs_delattr_context *dac,
> > +			      struct xfs_da_args *args);
> >  
> >  #endif	/* __XFS_ATTR_H__ */
> > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > index 8623c81..4ed7b31 100644
> > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> > @@ -19,8 +19,8 @@
> >  #include "xfs_bmap_btree.h"
> >  #include "xfs_bmap.h"
> >  #include "xfs_attr_sf.h"
> > -#include "xfs_attr_remote.h"
> >  #include "xfs_attr.h"
> > +#include "xfs_attr_remote.h"
> >  #include "xfs_attr_leaf.h"
> >  #include "xfs_error.h"
> >  #include "xfs_trace.h"
> > diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> > index 3f80ced..7f81b48 100644
> > --- a/fs/xfs/libxfs/xfs_attr_remote.c
> > +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> > @@ -676,10 +676,14 @@ xfs_attr_rmtval_invalidate(
> >   */
> >  int
> >  xfs_attr_rmtval_remove(
> > -	struct xfs_da_args      *args)
> > +	struct xfs_da_args		*args)
> >  {
> > -	int			error;
> > -	int			retval;
> > +	xfs_dablk_t			lblkno;
> > +	int				blkcnt;
> > +	int				error;
> > +	struct xfs_delattr_context	dac  = {
> > +		.da_args	= args,
> > +	};
> >  
> >  	trace_xfs_attr_rmtval_remove(args);
> >  
> > @@ -687,19 +691,17 @@ xfs_attr_rmtval_remove(
> >  	 * Keep de-allocating extents until the remote-value region is gone.
> >  	 */
> >  	do {
> > -		retval = __xfs_attr_rmtval_remove(args);
> > -		if (retval && retval != -EAGAIN)
> > -			return retval;
> > +		error = __xfs_attr_rmtval_remove(&dac);
> > +		if (error != -EAGAIN)
> > +			break;
> >  
> > -		/*
> > -		 * Close out trans and start the next one in the chain.
> > -		 */
> > -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> > +		error = xfs_attr_trans_roll(&dac);
> >  		if (error)
> >  			return error;
> > -	} while (retval == -EAGAIN);
> >  
> > -	return 0;
> > +	} while (true);
> > +
> > +	return error;
> >  }
> >  
> >  /*
> > @@ -709,9 +711,10 @@ xfs_attr_rmtval_remove(
> >   */
> >  int
> >  __xfs_attr_rmtval_remove(
> > -	struct xfs_da_args	*args)
> > +	struct xfs_delattr_context	*dac)
> >  {
> > -	int			error, done;
> > +	struct xfs_da_args		*args = dac->da_args;
> > +	int				error, done;
> >  
> >  	/*
> >  	 * Unmap value blocks for this attr.
> > @@ -721,12 +724,10 @@ __xfs_attr_rmtval_remove(
> >  	if (error)
> >  		return error;
> >  
> > -	error = xfs_defer_finish(&args->trans);
> > -	if (error)
> > -		return error;
> > -
> > -	if (!done)
> > +	if (!done) {
> > +		dac->flags |= XFS_DAC_DEFER_FINISH;
> >  		return -EAGAIN;
> > +	}
> >  
> >  	return error;
> >  }
> > diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> > index 9eee615..002fd30 100644
> > --- a/fs/xfs/libxfs/xfs_attr_remote.h
> > +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> > @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
> >  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
> >  		xfs_buf_flags_t incore_flags);
> >  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> > -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
> > +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
> >  #endif /* __XFS_ATTR_REMOTE_H__ */
> > diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> > index bfad669..aaa7e66 100644
> > --- a/fs/xfs/xfs_attr_inactive.c
> > +++ b/fs/xfs/xfs_attr_inactive.c
> > @@ -15,10 +15,10 @@
> >  #include "xfs_da_format.h"
> >  #include "xfs_da_btree.h"
> >  #include "xfs_inode.h"
> > +#include "xfs_attr.h"
> >  #include "xfs_attr_remote.h"
> >  #include "xfs_trans.h"
> >  #include "xfs_bmap.h"
> > -#include "xfs_attr.h"
> >  #include "xfs_attr_leaf.h"
> >  #include "xfs_quota.h"
> >  #include "xfs_dir2.h"
> > -- 
> > 2.7.4
> > 
> 
