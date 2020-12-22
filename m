Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279092E0CDC
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Dec 2020 16:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgLVPoi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 22 Dec 2020 10:44:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56282 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgLVPoi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Dec 2020 10:44:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BMFYvV5050612;
        Tue, 22 Dec 2020 15:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=jNrQlBjqQaeyRXXs5X2UH/ONInBPz+9MO7/Yj39saPM=;
 b=Eg8rNrALZ690ZxPEWJPXa13oiW61Mrwje8F2s7TS8DB58z9Ptt/fdSpBVUkVxUrZ6EDN
 AwlcPGrNWFrsTPqjS323BygV0JF4ijoOGBzS6qHRLrZNF7qlDFT6mgFN9CRpwH/mgFU8
 qiVDxcYK8BBB18yQNbLc+QORmKCQu2clsGqJ8j3COYg10VFI/H1inJ6s9lVP8nsyutS5
 MERpTEzJEBTjej1QFvO1I7Wsm0PvyQ2pqryJfuMAA7B7Bu2+Z08pBNdn+MQOs/tDC6vT
 U4G3epdrqz3vBp6V+0gCdJXnid2tdSkWjJxB8rU5GVxGOc55ozXDOi0E7Vwto5x8kVzb EQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35k0d8c16r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Dec 2020 15:43:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BMFfYmY126358;
        Tue, 22 Dec 2020 15:41:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 35k0e1g0gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Dec 2020 15:41:51 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BMFfoID004378;
        Tue, 22 Dec 2020 15:41:50 GMT
Received: from [192.168.1.226] (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Dec 2020 07:41:49 -0800
Subject: Re: [PATCH v14 04/15] xfs: Add delay ready attr remove routines
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-5-allison.henderson@oracle.com>
 <2492487.0L5myOU7vU@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <f43342e3-2839-11e5-daf9-00fc109cfc66@oracle.com>
Date:   Tue, 22 Dec 2020 08:41:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2492487.0L5myOU7vU@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9842 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012220116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9842 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012220115
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/22/20 12:22 AM, Chandan Babu R wrote:
> On Fri, 18 Dec 2020 00:29:06 -0700, Allison Henderson wrote:
>> This patch modifies the attr remove routines to be delay ready. This
>> means they no longer roll or commit transactions, but instead return
>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
>> uses a sort of state machine like switch to keep track of where it was
>> when EAGAIN was returned. xfs_attr_node_removename has also been
>> modified to use the switch, and a new version of xfs_attr_remove_args
>> consists of a simple loop to refresh the transaction until the operation
>> is completed. A new XFS_DAC_DEFER_FINISH flag is used to finish the
>> transaction where ever the existing code used to.
>>
>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>> version __xfs_attr_rmtval_remove. We will rename
>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>> done.
>>
>> xfs_attr_rmtval_remove itself is still in use by the set routines (used
>> during a rename).  For reasons of preserving existing function, we
>> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
>> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
>> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
>> used and will be removed.
>>
>> This patch also adds a new struct xfs_delattr_context, which we will use
>> to keep track of the current state of an attribute operation. The new
>> xfs_delattr_state enum is used to track various operations that are in
>> progress so that we know not to repeat them, and resume where we left
>> off before EAGAIN was returned to cycle out the transaction. Other
>> members take the place of local variables that need to retain their
>> values across multiple function recalls.  See xfs_attr.h for a more
>> detailed diagram of the states.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c        | 218 +++++++++++++++++++++++++++++-----------
>>   fs/xfs/libxfs/xfs_attr.h        | 100 ++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
>>   fs/xfs/libxfs/xfs_attr_remote.c |  48 +++++----
>>   fs/xfs/libxfs/xfs_attr_remote.h |   2 +-
>>   fs/xfs/xfs_attr_inactive.c      |   2 +-
>>   6 files changed, 288 insertions(+), 84 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 1969b88..b6330f9 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -53,7 +53,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>    */
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>> -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>> @@ -264,6 +264,34 @@ xfs_attr_set_shortform(
>>   }
>>   
>>   /*
>> + * Checks to see if a delayed attribute transaction should be rolled.  If so,
>> + * also checks for a defer finish.  Transaction is finished and rolled as
>> + * needed, and returns true of false if the delayed operation should continue.
>> + */
>> +int
>> +xfs_attr_trans_roll(
>> +	struct xfs_delattr_context	*dac)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	int				error;
>> +
>> +	if (dac->flags & XFS_DAC_DEFER_FINISH) {
>> +		/*
>> +		 * The caller wants us to finish all the deferred ops so that we
>> +		 * avoid pinning the log tail with a large number of deferred
>> +		 * ops.
>> +		 */
>> +		dac->flags &= ~XFS_DAC_DEFER_FINISH;
>> +		error = xfs_defer_finish(&args->trans);
>> +		if (error)
>> +			return error;
>> +	} else
>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +
>> +	return error;
>> +}
>> +
>> +/*
>>    * Set the attribute specified in @args.
>>    */
>>   int
>> @@ -364,23 +392,58 @@ xfs_has_attr(
>>    */
>>   int
>>   xfs_attr_remove_args(
>> -	struct xfs_da_args      *args)
>> +	struct xfs_da_args	*args)
>>   {
>> -	struct xfs_inode	*dp = args->dp;
>> -	int			error;
>> +	int				error;
>> +	struct xfs_delattr_context	dac = {
>> +		.da_args	= args,
>> +	};
>> +
>> +	do {
>> +		error = xfs_attr_remove_iter(&dac);
>> +		if (error != -EAGAIN)
>> +			break;
>> +
>> +		error = xfs_attr_trans_roll(&dac);
>> +		if (error)
>> +			return error;
>> +
>> +	} while (true);
>> +
>> +	return error;
>> +}
>>   
>> -	if (!xfs_inode_hasattr(dp)) {
>> -		error = -ENOATTR;
>> -	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
>> +/*
>> + * Remove the attribute specified in @args.
>> + *
>> + * This function may return -EAGAIN to signal that the transaction needs to be
>> + * rolled.  Callers should continue calling this function until they receive a
>> + * return value other than -EAGAIN.
>> + */
>> +int
>> +xfs_attr_remove_iter(
>> +	struct xfs_delattr_context	*dac)
>> +{
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_inode		*dp = args->dp;
>> +
>> +	/* If we are shrinking a node, resume shrink */
>> +	if (dac->dela_state == XFS_DAS_RM_SHRINK)
>> +		goto node;
>> +
>> +	if (!xfs_inode_hasattr(dp))
>> +		return -ENOATTR;
>> +
>> +	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
>>   		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> -		error = xfs_attr_shortform_remove(args);
>> -	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -		error = xfs_attr_leaf_removename(args);
>> -	} else {
>> -		error = xfs_attr_node_removename(args);
>> +		return xfs_attr_shortform_remove(args);
>>   	}
>>   
>> -	return error;
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +		return xfs_attr_leaf_removename(args);
>> +node:
>> +	/* If we are not short form or leaf, then proceed to remove node */
>> +	return  xfs_attr_node_removename_iter(dac);
>>   }
>>   
>>   /*
>> @@ -1178,10 +1241,11 @@ xfs_attr_leaf_mark_incomplete(
>>    */
>>   STATIC
>>   int xfs_attr_node_removename_setup(
>> -	struct xfs_da_args	*args,
>> -	struct xfs_da_state	**state)
>> +	struct xfs_delattr_context	*dac)
>>   {
> 
> In xfs_attr_node_removename_setup(), if either of
> xfs_attr_leaf_mark_incomplete() or xfs_attr_rmtval_invalidate() returns with a
> non-zero value, the memory pointed to by dac->da_state is not freed. This
> happens because the caller (i.e. xfs_attr_node_removename_iter()) checks for
> the non-NULL value of its local variable "state" to actually free the
> corresponding memory.
> 
Ok, for this one it think it makes more sense to put an extra free in 
the helper rather than have the caller handle it.  Will fix.

Do you have a tool thats tracing this out, or is it just by hand? 
Because if it's a tool, I should probably be using it too :-)

Thanks!
Allison


>> -	int			error;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_state		**state = &dac->da_state;
>> +	int				error;
>>   
>>   	error = xfs_attr_node_hasname(args, state);
>>   	if (error != -EEXIST)
>> @@ -1203,13 +1267,16 @@ int xfs_attr_node_removename_setup(
>>   }
>>   
>>   STATIC int
>> -xfs_attr_node_remove_rmt(
>> -	struct xfs_da_args	*args,
>> -	struct xfs_da_state	*state)
>> +xfs_attr_node_remove_rmt (
>> +	struct xfs_delattr_context	*dac,
>> +	struct xfs_da_state		*state)
>>   {
>> -	int			error = 0;
>> +	int				error = 0;
>>   
>> -	error = xfs_attr_rmtval_remove(args);
>> +	/*
>> +	 * May return -EAGAIN to request that the caller recall this function
>> +	 */
>> +	error = __xfs_attr_rmtval_remove(dac);
>>   	if (error)
>>   		return error;
>>   
>> @@ -1240,28 +1307,34 @@ xfs_attr_node_remove_cleanup(
>>   }
>>   
>>   /*
>> - * Remove a name from a B-tree attribute list.
>> + * Step through removeing a name from a B-tree attribute list.
>>    *
>>    * This will involve walking down the Btree, and may involve joining
>>    * leaf nodes and even joining intermediate nodes up to and including
>>    * the root node (a special case of an intermediate node).
>> + *
>> + * This routine is meant to function as either an inline or delayed operation,
>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>> + * functions will need to handle this, and recall the function until a
>> + * successful error code is returned.
>>    */
>>   STATIC int
>>   xfs_attr_node_remove_step(
>> -	struct xfs_da_args	*args,
>> -	struct xfs_da_state	*state)
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	int			error;
>> -	struct xfs_inode	*dp = args->dp;
>> -
>> -
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_state		*state = dac->da_state;
>> +	int				error = 0;
>>   	/*
>>   	 * If there is an out-of-line value, de-allocate the blocks.
>>   	 * This is done before we remove the attribute so that we don't
>>   	 * overflow the maximum size of a transaction and/or hit a deadlock.
>>   	 */
>>   	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_node_remove_rmt(args, state);
>> +		/*
>> +		 * May return -EAGAIN. Remove blocks until args->rmtblkno == 0
>> +		 */
>> +		error = xfs_attr_node_remove_rmt(dac, state);
>>   		if (error)
>>   			return error;
>>   	}
>> @@ -1274,51 +1347,74 @@ xfs_attr_node_remove_step(
>>    *
>>    * This routine will find the blocks of the name to remove, remove them and
>>    * shrink the tree if needed.
>> + *
>> + * This routine is meant to function as either an inline or delayed operation,
>> + * and may return -EAGAIN when the transaction needs to be rolled.  Calling
>> + * functions will need to handle this, and recall the function until a
>> + * successful error code is returned.
>>    */
>>   STATIC int
>> -xfs_attr_node_removename(
>> -	struct xfs_da_args	*args)
>> +xfs_attr_node_removename_iter(
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	struct xfs_da_state	*state = NULL;
>> -	int			retval, error;
>> -	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	struct xfs_da_state		*state = NULL;
>> +	int				retval, error;
>> +	struct xfs_inode		*dp = args->dp;
>>   
>>   	trace_xfs_attr_node_removename(args);
>>   
>> -	error = xfs_attr_node_removename_setup(args, &state);
>> -	if (error)
>> -		goto out;
>> +	if (!dac->da_state) {
>> +		error = xfs_attr_node_removename_setup(dac);
>> +		if (error)
>> +			goto out;
>> +	}
>> +	state = dac->da_state;
>>   
>> -	error = xfs_attr_node_remove_step(args, state);
>> -	if (error)
>> -		goto out;
>> +	switch (dac->dela_state) {
>> +	case XFS_DAS_UNINIT:
>> +		/*
>> +		 * repeatedly remove remote blocks, remove the entry and join.
>> +		 * returns -EAGAIN or 0 for completion of the step.
>> +		 */
>> +		error = xfs_attr_node_remove_step(dac);
>> +		if (error)
>> +			break;
>>   
>> -	retval = xfs_attr_node_remove_cleanup(args, state);
>> +		retval = xfs_attr_node_remove_cleanup(args, state);
>>   
>> -	/*
>> -	 * Check to see if the tree needs to be collapsed.
>> -	 */
>> -	if (retval && (state->path.active > 1)) {
>> -		error = xfs_da3_join(state);
>> -		if (error)
>> -			return error;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			return error;
>>   		/*
>> -		 * Commit the Btree join operation and start a new trans.
>> +		 * Check to see if the tree needs to be collapsed. Set the flag
>> +		 * to indicate that the calling function needs to move the
>> +		 * shrink operation
>>   		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> -		if (error)
>> -			return error;
>> -	}
>> +		if (retval && (state->path.active > 1)) {
>> +			error = xfs_da3_join(state);
>> +			if (error)
>> +				return error;
>>   
>> -	/*
>> -	 * If the result is small enough, push it all into the inode.
>> -	 */
>> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> -		error = xfs_attr_node_shrink(args, state);
>> +			dac->flags |= XFS_DAC_DEFER_FINISH;
>> +			dac->dela_state = XFS_DAS_RM_SHRINK;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		/* fallthrough */
>> +	case XFS_DAS_RM_SHRINK:
>> +		/*
>> +		 * If the result is small enough, push it all into the inode.
>> +		 */
>> +		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> +			error = xfs_attr_node_shrink(args, state);
>> +
>> +		break;
>> +	default:
>> +		ASSERT(0);
>> +		error = -EINVAL;
>> +		goto out;
>> +	}
>>   
>> +	if (error == -EAGAIN)
>> +		return error;
>>   out:
>>   	if (state)
>>   		xfs_da_state_free(state);
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index 3e97a93..3154ef4 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -74,6 +74,102 @@ struct xfs_attr_list_context {
>>   };
>>   
>>   
>> +/*
>> + * ========================================================================
>> + * Structure used to pass context around among the delayed routines.
>> + * ========================================================================
>> + */
>> +
>> +/*
>> + * Below is a state machine diagram for attr remove operations. The  XFS_DAS_*
>> + * states indicate places where the function would return -EAGAIN, and then
>> + * immediately resume from after being recalled by the calling function. States
>> + * marked as a "subroutine state" indicate that they belong to a subroutine, and
>> + * so the calling function needs to pass them back to that subroutine to allow
>> + * it to finish where it left off. But they otherwise do not have a role in the
>> + * calling function other than just passing through.
>> + *
>> + * xfs_attr_remove_iter()
>> + *              │
>> + *              v
>> + *        found attr blks? ───n──┐
>> + *              │                v
>> + *              │         find and invalidate
>> + *              y         the blocks. mark
>> + *              │         attr incomplete
>> + *              ├────────────────┘
>> + *              │
>> + *              v
>> + *      remove a block with
>> + *    xfs_attr_node_remove_step <────┐
>> + *              │                    │
>> + *              v                    │
>> + *      still have blks ──y──> return -EAGAIN.
>> + *        to remove?          re-enter with one
>> + *              │            less blk to remove
>> + *              n
>> + *              │
>> + *              v
>> + *       remove leaf and
>> + *       update hash with
>> + *   xfs_attr_node_remove_cleanup
>> + *              │
>> + *              v
>> + *           need to
>> + *        shrink tree? ─n─┐
>> + *              │         │
>> + *              y         │
>> + *              │         │
>> + *              v         │
>> + *          join leaf     │
>> + *              │         │
>> + *              v         │
>> + *      XFS_DAS_RM_SHRINK │
>> + *              │         │
>> + *              v         │
>> + *       do the shrink    │
>> + *              │         │
>> + *              v         │
>> + *          free state <──┘
>> + *              │
>> + *              v
>> + *            done
>> + *
>> + */
>> +
>> +/*
>> + * Enum values for xfs_delattr_context.da_state
>> + *
>> + * These values are used by delayed attribute operations to keep track  of where
>> + * they were before they returned -EAGAIN.  A return code of -EAGAIN signals the
>> + * calling function to roll the transaction, and then recall the subroutine to
>> + * finish the operation.  The enum is then used by the subroutine to jump back
>> + * to where it was and resume executing where it left off.
>> + */
>> +enum xfs_delattr_state {
>> +	XFS_DAS_UNINIT		= 0,  /* No state has been set yet */
>> +	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
>> +};
>> +
>> +/*
>> + * Defines for xfs_delattr_context.flags
>> + */
>> +#define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
>> +
>> +/*
>> + * Context used for keeping track of delayed attribute operations
>> + */
>> +struct xfs_delattr_context {
>> +	struct xfs_da_args      *da_args;
>> +
>> +	/* Used in xfs_attr_node_removename to roll through removing blocks */
>> +	struct xfs_da_state     *da_state;
>> +
>> +	/* Used to keep track of current state of delayed operation */
>> +	unsigned int            flags;
>> +	enum xfs_delattr_state  dela_state;
>> +};
>> +
>>   /*========================================================================
>>    * Function prototypes for the kernel.
>>    *========================================================================*/
>> @@ -91,6 +187,10 @@ int xfs_attr_set(struct xfs_da_args *args);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>>   int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>> +int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
>> +int xfs_attr_trans_roll(struct xfs_delattr_context *dac);
>>   bool xfs_attr_namecheck(const void *name, size_t length);
>> +void xfs_delattr_context_init(struct xfs_delattr_context *dac,
>> +			      struct xfs_da_args *args);
>>   
>>   #endif	/* __XFS_ATTR_H__ */
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index d6ef69a..3780141 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -19,8 +19,8 @@
>>   #include "xfs_bmap_btree.h"
>>   #include "xfs_bmap.h"
>>   #include "xfs_attr_sf.h"
>> -#include "xfs_attr_remote.h"
>>   #include "xfs_attr.h"
>> +#include "xfs_attr_remote.h"
>>   #include "xfs_attr_leaf.h"
>>   #include "xfs_error.h"
>>   #include "xfs_trace.h"
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 48d8e9c..f09820c 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -674,10 +674,12 @@ xfs_attr_rmtval_invalidate(
>>    */
>>   int
>>   xfs_attr_rmtval_remove(
>> -	struct xfs_da_args      *args)
>> +	struct xfs_da_args		*args)
>>   {
>> -	int			error;
>> -	int			retval;
>> +	int				error;
>> +	struct xfs_delattr_context	dac  = {
>> +		.da_args	= args,
>> +	};
>>   
>>   	trace_xfs_attr_rmtval_remove(args);
>>   
>> @@ -685,31 +687,29 @@ xfs_attr_rmtval_remove(
>>   	 * Keep de-allocating extents until the remote-value region is gone.
>>   	 */
>>   	do {
>> -		retval = __xfs_attr_rmtval_remove(args);
>> -		if (retval && retval != -EAGAIN)
>> -			return retval;
>> +		error = __xfs_attr_rmtval_remove(&dac);
>> +		if (error != -EAGAIN)
>> +			break;
>>   
>> -		/*
>> -		 * Close out trans and start the next one in the chain.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		error = xfs_attr_trans_roll(&dac);
>>   		if (error)
>>   			return error;
>> -	} while (retval == -EAGAIN);
>> +	} while (true);
>>   
>> -	return 0;
>> +	return error;
>>   }
>>   
>>   /*
>>    * Remove the value associated with an attribute by deleting the out-of-line
>> - * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>> + * buffer that it is stored on. Returns -EAGAIN for the caller to refresh the
>>    * transaction and re-call the function
>>    */
>>   int
>>   __xfs_attr_rmtval_remove(
>> -	struct xfs_da_args	*args)
>> +	struct xfs_delattr_context	*dac)
>>   {
>> -	int			error, done;
>> +	struct xfs_da_args		*args = dac->da_args;
>> +	int				error, done;
>>   
>>   	/*
>>   	 * Unmap value blocks for this attr.
>> @@ -719,12 +719,20 @@ __xfs_attr_rmtval_remove(
>>   	if (error)
>>   		return error;
>>   
>> -	error = xfs_defer_finish(&args->trans);
>> -	if (error)
>> -		return error;
>> -
>> -	if (!done)
>> +	/*
>> +	 * We dont need an explicit state here to pick up where we left off.  We
>> +	 * can figure it out using the !done return code.  Calling function only
>> +	 * needs to keep recalling this routine until we indicate to stop by
>> +	 * returning anything other than -EAGAIN. The actual value of
>> +	 * attr->xattri_dela_state may be some value reminicent of the calling
>> +	 * function, but it's value is irrelevant with in the context of this
>> +	 * function.  Once we are done here, the next state is set as needed
>> +	 * by the parent
>> +	 */
>> +	if (!done) {
>> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>>   		return -EAGAIN;
>> +	}
>>   
>>   	return error;
>>   }
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index 9eee615..002fd30 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -14,5 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>   		xfs_buf_flags_t incore_flags);
>>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>> -int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>> +int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
>> index bfad669..aaa7e66 100644
>> --- a/fs/xfs/xfs_attr_inactive.c
>> +++ b/fs/xfs/xfs_attr_inactive.c
>> @@ -15,10 +15,10 @@
>>   #include "xfs_da_format.h"
>>   #include "xfs_da_btree.h"
>>   #include "xfs_inode.h"
>> +#include "xfs_attr.h"
>>   #include "xfs_attr_remote.h"
>>   #include "xfs_trans.h"
>>   #include "xfs_bmap.h"
>> -#include "xfs_attr.h"
>>   #include "xfs_attr_leaf.h"
>>   #include "xfs_quota.h"
>>   #include "xfs_dir2.h"
>>
> 
> 
