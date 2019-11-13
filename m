Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2CFFA94C
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Nov 2019 05:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfKME7E (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Nov 2019 23:59:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37058 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfKME7D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Nov 2019 23:59:03 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4rxRr180872;
        Wed, 13 Nov 2019 04:58:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=BkdT0WjDyjwiLhnMWPGOcjpehKW29XTjVg4lYqPwLb4=;
 b=k+Oq9fvh3GcVSYvbF2Q1i+tEMqUNVZoWsXAanlevOcejFtHXaxp342hV+BMXNjbfhfIK
 Ab0Bp89Z3qJXNuH7i5amhzXAP+wx50Mzh0eKlvdfMUIsE2yQrkKd6bkbZlGE/YFFPUNS
 V1HFBJqaRTDnX5LBJRTUhCDKGnH3t+IeFo8qTwhCgYMMeV5efbf05e9SFRlzQXxgdUgJ
 D2ihik7a6OJ1whPvCYyMBucu4uaRlBxyWAJPURowYCHMQ9/qYUVSSjAfskC06qsCLJEu
 PXu1gkI4I5fR3SOfTcmNcLjUYDWyifeI/aVIB3ltUg4C5hdbci5b2TiWOIpSUqep+X5D Eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w5ndq9n97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:58:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAD4wthh003887;
        Wed, 13 Nov 2019 04:58:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w7vpnkhvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 04:58:57 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAD4wGfc030862;
        Wed, 13 Nov 2019 04:58:24 GMT
Received: from [192.168.1.9] (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Nov 2019 20:58:09 -0800
Subject: Re: [PATCH v4 17/17] xfs: Add delay ready attr set routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-18-allison.henderson@oracle.com>
 <20191112133730.GB46980@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <ebc9bdf3-981b-41a3-a6ae-ebacd338f4a7@oracle.com>
Date:   Tue, 12 Nov 2019 21:57:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191112133730.GB46980@bfoster>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130043
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130043
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/12/19 6:37 AM, Brian Foster wrote:
> On Wed, Nov 06, 2019 at 06:28:01PM -0700, Allison Collins wrote:
>> This patch modifies the attr set routines to be delay ready.
>> This means they no longer roll or commit transactions, but instead
>> return -EAGAIN to have the calling routine roll and refresh the
>> transaction.  In this series, xfs_attr_set_args has become
>> xfs_attr_set_later, which uses a state machine to keep track
>> of where it was when EAGAIN was returned.  Part of
>> xfs_attr_leaf_addname has been factored out into a new helper
>> function xfs_attr_leaf_try_add to allow transaction cycling between
>> the two routines, and the flipflags logic has been removed since we
>> can simply cancel the transaction upon error.  xfs_attr_set_args
>> consists of a simple loop to refresh the transaction until the
>> operation is completed.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
> 
> Pretty much the same fundamental comments here as for the remove patch.
> Can we break things down further to avoid much of the jumping into if
> branch behavior and such? I also wonder if it might be possible to split
> this one up into smaller patches to fix up the leaf/node paths
> separately, but additional prep refactoring might simplify things enough
> on its own to make that unnecessary..
> 
> Brian

Sure, I'll see if I can get the branching out of the if statements. 
Maybe I can break this up into smaller patches too.  Thanks again for 
the reviews!

Allison

> 
>>   fs/xfs/libxfs/xfs_attr.c | 435 +++++++++++++++++++++++------------------------
>>   fs/xfs/libxfs/xfs_attr.h |   1 +
>>   2 files changed, 211 insertions(+), 225 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 38d5c5c..97e5ae0 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -58,6 +58,7 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
>>   
>>   
>>   STATIC int
>> @@ -250,9 +251,79 @@ int
>>   xfs_attr_set_args(
>>   	struct xfs_da_args	*args)
>>   {
>> +	int			error = 0;
>> +	int			err2 = 0;
>> +	struct xfs_buf		*leaf_bp = NULL;
>> +
>> +	do {
>> +		error = xfs_attr_set_later(args, &leaf_bp);
>> +		if (error && error != -EAGAIN)
>> +			goto out;
>> +
>> +		xfs_trans_log_inode(args->trans, args->dp,
>> +				    XFS_ILOG_CORE | XFS_ILOG_ADATA);
>> +
>> +		err2 = xfs_trans_roll(&args->trans);
>> +		if (err2) {
>> +			error = err2;
>> +			goto out;
>> +		}
>> +
>> +		/* Rejoin inode and leaf if needed */
>> +		xfs_trans_ijoin(args->trans, args->dp, 0);
>> +		if (leaf_bp) {
>> +			xfs_trans_bjoin(args->trans, leaf_bp);
>> +			xfs_trans_bhold(args->trans, leaf_bp);
>> +		}
>> +
>> +	} while (error == -EAGAIN);
>> +
>> +out:
>> +	return error;
>> +}
>> +
>> +/*
>> + * Set the attribute specified in @args.
>> + * This routine is meant to function as a delayed operation, and may return
>> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
>> + * to handle this, and recall the function until a successful error code is
>> + * returned.
>> + */
>> +int
>> +xfs_attr_set_later(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_buf          **leaf_bp)
>> +{
>>   	struct xfs_inode	*dp = args->dp;
>> -	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error, error2 = 0;;
>> +	int			error = 0;
>> +	int			sf_size;
>> +
>> +	/* State machine switch */
>> +	switch (args->dc.dc_state) {
>> +	case XFS_DC_SF_TO_LEAF:
>> +		goto sf_to_leaf;
>> +	case XFS_DC_ALLOC_LEAF:
>> +	case XFS_DC_FOUND_LBLK:
>> +		goto leaf;
>> +	case XFS_DC_FOUND_NBLK:
>> +	case XFS_DC_ALLOC_NODE:
>> +	case XFS_DC_LEAF_TO_NODE:
>> +		goto node;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	/*
>> +	 * New inodes may not have an attribute fork yet. So set the attribute
>> +	 * fork appropriately
>> +	 */
>> +	if (XFS_IFORK_Q((args->dp)) == 0) {
>> +		sf_size = sizeof(struct xfs_attr_sf_hdr) +
>> +		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
>> +		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
>> +		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
>> +		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
>> +	}
>>   
>>   	/*
>>   	 * If the attribute list is non-existent or a shortform list,
>> @@ -272,21 +343,14 @@ xfs_attr_set_args(
>>   		 * Try to add the attr to the attribute list in the inode.
>>   		 */
>>   		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC) {
>> -			if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
>> -				xfs_trans_set_sync(args->trans);
>> -
>> -			error2 = xfs_trans_commit(args->trans);
>> -			args->trans = NULL;
>> -			return error ? error : error2;
>> -		}
>> -
>> +		if (error != -ENOSPC)
>> +			return error;
>>   
>>   		/*
>>   		 * It won't fit in the shortform, transform to a leaf block.
>>   		 * GROT: another possible req'mt for a double-split btree op.
>>   		 */
>> -		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>> +		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>>   		if (error)
>>   			return error;
>>   
>> @@ -294,43 +358,42 @@ xfs_attr_set_args(
>>   		 * Prevent the leaf buffer from being unlocked so that a
>>   		 * concurrent AIL push cannot grab the half-baked leaf
>>   		 * buffer and run into problems with the write verifier.
>> -		 * Once we're done rolling the transaction we can release
>> -		 * the hold and add the attr to the leaf.
>>   		 */
>> -		xfs_trans_bhold(args->trans, leaf_bp);
>> -		error = xfs_defer_finish(&args->trans);
>> -		xfs_trans_bhold_release(args->trans, leaf_bp);
>> -		if (error) {
>> -			xfs_trans_brelse(args->trans, leaf_bp);
>> -			return error;
>> -		}
>> +
>> +		xfs_trans_bhold(args->trans, *leaf_bp);
>> +		args->dc.dc_state = XFS_DC_SF_TO_LEAF;
>> +		return -EAGAIN;
>> +	}
>> +sf_to_leaf:
>> +
>> +	/*
>> +	 * After a shortform to leaf conversion, we need to hold the leaf and
>> +	 * cylce out the transaction.  When we get back, we need to release
>> +	 * the leaf.
>> +	 */
>> +	if (*leaf_bp != NULL) {
>> +		xfs_trans_brelse(args->trans, *leaf_bp);
>> +		*leaf_bp = NULL;
>>   	}
>>   
>>   	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> +		error = xfs_attr_leaf_try_add(args, *leaf_bp);
>> +		if (error == -ENOSPC)
>> +			args->dc.dc_state = XFS_DC_LEAF_TO_NODE;
>> +		else if (error)
>> +			return error;
>> +		else
>> +			args->dc.dc_state = XFS_DC_FOUND_LBLK;
>> +		return -EAGAIN;
>> +leaf:
>>   		error = xfs_attr_leaf_addname(args);
>>   		if (error == -ENOSPC) {
>> -			/*
>> -			 * Commit that transaction so that the node_addname()
>> -			 * call can manage its own transactions.
>> -			 */
>> -			error = xfs_defer_finish(&args->trans);
>> -			if (error)
>> -				return error;
>> -
>> -			/*
>> -			 * Commit the current trans (including the inode) and
>> -			 * start a new one.
>> -			 */
>> -			error = xfs_trans_roll_inode(&args->trans, dp);
>> -			if (error)
>> -				return error;
>> -
>> -			/*
>> -			 * Fob the rest of the problem off on the Btree code.
>> -			 */
>> -			error = xfs_attr_node_addname(args);
>> +			args->dc.dc_state = XFS_DC_LEAF_TO_NODE;
>> +			return -EAGAIN;
>>   		}
>>   	} else {
>> +		args->dc.dc_state = XFS_DC_LEAF_TO_NODE;
>> +node:
>>   		error = xfs_attr_node_addname(args);
>>   	}
>>   	return error;
>> @@ -764,27 +827,26 @@ xfs_attr_leaf_try_add(
>>    *
>>    * This leaf block cannot have a "remote" value, we only call this routine
>>    * if bmap_one_block() says there is only one block (ie: no remote blks).
>> + *
>> + * This routine is meant to function as a delayed operation, and may return
>> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
>> + * to handle this, and recall the function until a successful error code is
>> + * returned.
>>    */
>>   STATIC int
>>   xfs_attr_leaf_addname(struct xfs_da_args	*args)
>>   {
>> -	int			error, forkoff;
>> -	struct xfs_buf		*bp = NULL;
>> +	int			error, nmap;
>>   	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_bmbt_irec	*map = &args->dc.map;
>>   
>> -	trace_xfs_attr_leaf_addname(args);
>> -
>> -	error = xfs_attr_leaf_try_add(args, bp);
>> -	if (error)
>> -		return error;
>> -
>> -	/*
>> -	 * Commit the transaction that added the attr name so that
>> -	 * later routines can manage their own transactions.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>> -	if (error)
>> -		return error;
>> +	/* State machine switch */
>> +	switch (args->dc.dc_state) {
>> +	case XFS_DC_ALLOC_LEAF:
>> +		goto alloc_leaf;
>> +	default:
>> +		break;
>> +	}
>>   
>>   	/*
>>   	 * If there was an out-of-line value, allocate the blocks we
>> @@ -793,90 +855,58 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
>>   	 * maximum size of a transaction and/or hit a deadlock.
>>   	 */
>>   	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_rmtval_set(args);
>> -		if (error)
>> -			return error;
>> -	}
>>   
>> -	/*
>> -	 * If this is an atomic rename operation, we must "flip" the
>> -	 * incomplete flags on the "new" and "old" attribute/value pairs
>> -	 * so that one disappears and one appears atomically.  Then we
>> -	 * must remove the "old" attribute/value pair.
>> -	 */
>> -	if (args->op_flags & XFS_DA_OP_RENAME) {
>> -		/*
>> -		 * In a separate transaction, set the incomplete flag on the
>> -		 * "old" attr and clear the incomplete flag on the "new" attr.
>> -		 */
>> -		error = xfs_attr3_leaf_flipflags(args);
>> -		if (error)
>> -			return error;
>> -		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -		if (error)
>> -			return error;
>> +		/* Open coded xfs_attr_rmtval_set without trans handling */
>>   
>> -		/*
>> -		 * Dismantle the "old" attribute/value pair by removing
>> -		 * a "remote" value (if it exists).
>> -		 */
>> -		args->index = args->index2;
>> -		args->blkno = args->blkno2;
>> -		args->rmtblkno = args->rmtblkno2;
>> -		args->rmtblkcnt = args->rmtblkcnt2;
>> -		args->rmtvaluelen = args->rmtvaluelen2;
>> -		if (args->rmtblkno) {
>> -			error = xfs_attr_rmtval_remove(args);
>> -			if (error)
>> -				return error;
>> -		}
>> +		args->dc.lfileoff = 0;
>> +		args->dc.lblkno = 0;
>> +		args->dc.blkcnt = 0;
>> +		args->rmtblkcnt = 0;
>> +		args->rmtblkno = 0;
>> +		memset(map, 0, sizeof(struct xfs_bmbt_irec));
>>   
>> -		/*
>> -		 * Read in the block containing the "old" attr, then
>> -		 * remove the "old" attr from that block (neat, huh!)
>> -		 */
>> -		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> -					   XFS_DABUF_MAP_NOMAPPING, &bp);
>> +		error = xfs_attr_rmt_find_hole(args);
>>   		if (error)
>>   			return error;
>>   
>> -		xfs_attr3_leaf_remove(bp, args);
>> +		args->dc.blkcnt = args->rmtblkcnt;
>> +		args->dc.lblkno = args->rmtblkno;
>>   
>>   		/*
>> -		 * If the result is small enough, shrink it all into the inode.
>> +		 * Roll through the "value", allocating blocks on disk as
>> +		 * required.
>>   		 */
>> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
>> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> -			/* bp is gone due to xfs_da_shrink_inode */
>> -			if (error)
>> -				return error;
>> -			error = xfs_defer_finish(&args->trans);
>> +alloc_leaf:
>> +		while (args->dc.blkcnt > 0) {
>> +			nmap = 1;
>> +			error = xfs_bmapi_write(args->trans, dp,
>> +				  (xfs_fileoff_t)args->dc.lblkno,
>> +				  args->dc.blkcnt, XFS_BMAPI_ATTRFORK,
>> +				  args->total, map, &nmap);
>>   			if (error)
>>   				return error;
>> -		}
>> +			ASSERT(nmap == 1);
>> +			ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
>> +			       (map->br_startblock != HOLESTARTBLOCK));
>>   
>> -		/*
>> -		 * Commit the remove and start the next trans in series.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> +			/* roll attribute extent map forwards */
>> +			args->dc.lblkno += map->br_blockcount;
>> +			args->dc.blkcnt -= map->br_blockcount;
>>   
>> -	} else if (args->rmtblkno > 0) {
>> -		/*
>> -		 * Added a "remote" value, just clear the incomplete flag.
>> -		 */
>> -		error = xfs_attr3_leaf_clearflag(args);
>> +			args->dc.dc_state = XFS_DC_ALLOC_LEAF;
>> +			return -EAGAIN;
>> +		}
>> +
>> +		error = xfs_attr_rmtval_set_value(args);
>>   		if (error)
>>   			return error;
>> +	}
>>   
>> +	if (args->rmtblkno > 0) {
>>   		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series.
>> +		 * Added a "remote" value, just clear the incomplete flag.
>>   		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		error = xfs_attr3_leaf_clearflag(args);
>>   	}
>>   	return error;
>>   }
>> @@ -1017,16 +1047,23 @@ xfs_attr_node_hasname(
>>    *
>>    * "Remote" attribute values confuse the issue and atomic rename operations
>>    * add a whole extra layer of confusion on top of that.
>> + *
>> + * This routine is meant to function as a delayed operation, and may return
>> + * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
>> + * to handle this, and recall the function until a successful error code is
>> + *returned.
>>    */
>>   STATIC int
>>   xfs_attr_node_addname(
>>   	struct xfs_da_args	*args)
>>   {
>> -	struct xfs_da_state	*state;
>> +	struct xfs_da_state	*state = NULL;
>>   	struct xfs_da_state_blk	*blk;
>>   	struct xfs_inode	*dp;
>> -	struct xfs_mount	*mp;
>> -	int			retval, error;
>> +	int			retval = 0;
>> +	int			error = 0;
>> +	int			nmap;
>> +	struct xfs_bmbt_irec    *map = &args->dc.map;
>>   
>>   	trace_xfs_attr_node_addname(args);
>>   
>> @@ -1034,8 +1071,17 @@ xfs_attr_node_addname(
>>   	 * Fill in bucket of arguments/results/context to carry around.
>>   	 */
>>   	dp = args->dp;
>> -	mp = dp->i_mount;
>> -restart:
>> +
>> +	/* State machine switch */
>> +	switch (args->dc.dc_state) {
>> +	case XFS_DC_FOUND_NBLK:
>> +		goto found_nblk;
>> +	case XFS_DC_ALLOC_NODE:
>> +		goto alloc_node;
>> +	default:
>> +		break;
>> +	}
>> +
>>   	/*
>>   	 * Search to see if name already exists, and get back a pointer
>>   	 * to where it should go.
>> @@ -1085,19 +1131,12 @@ xfs_attr_node_addname(
>>   			error = xfs_attr3_leaf_to_node(args);
>>   			if (error)
>>   				goto out;
>> -			error = xfs_defer_finish(&args->trans);
>> -			if (error)
>> -				goto out;
>>   
>>   			/*
>> -			 * Commit the node conversion and start the next
>> -			 * trans in the chain.
>> +			 * Restart routine from the top.  No need to set  the
>> +			 * state
>>   			 */
>> -			error = xfs_trans_roll_inode(&args->trans, dp);
>> -			if (error)
>> -				goto out;
>> -
>> -			goto restart;
>> +			return -EAGAIN;
>>   		}
>>   
>>   		/*
>> @@ -1109,9 +1148,6 @@ xfs_attr_node_addname(
>>   		error = xfs_da3_split(state);
>>   		if (error)
>>   			goto out;
>> -		error = xfs_defer_finish(&args->trans);
>> -		if (error)
>> -			goto out;
>>   	} else {
>>   		/*
>>   		 * Addition succeeded, update Btree hashvals.
>> @@ -1126,13 +1162,9 @@ xfs_attr_node_addname(
>>   	xfs_da_state_free(state);
>>   	state = NULL;
>>   
>> -	/*
>> -	 * Commit the leaf addition or btree split and start the next
>> -	 * trans in the chain.
>> -	 */
>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>> -	if (error)
>> -		goto out;
>> +	args->dc.dc_state = XFS_DC_FOUND_NBLK;
>> +	return -EAGAIN;
>> +found_nblk:
>>   
>>   	/*
>>   	 * If there was an out-of-line value, allocate the blocks we
>> @@ -1141,104 +1173,57 @@ xfs_attr_node_addname(
>>   	 * maximum size of a transaction and/or hit a deadlock.
>>   	 */
>>   	if (args->rmtblkno > 0) {
>> -		error = xfs_attr_rmtval_set(args);
>> -		if (error)
>> -			return error;
>> -	}
>> +		/* Open coded xfs_attr_rmtval_set without trans handling */
>> +		args->dc.lblkno = 0;
>> +		args->dc.lfileoff = 0;
>> +		args->dc.blkcnt = 0;
>> +		args->rmtblkcnt = 0;
>> +		args->rmtblkno = 0;
>> +		memset(map, 0, sizeof(struct xfs_bmbt_irec));
>>   
>> -	/*
>> -	 * If this is an atomic rename operation, we must "flip" the
>> -	 * incomplete flags on the "new" and "old" attribute/value pairs
>> -	 * so that one disappears and one appears atomically.  Then we
>> -	 * must remove the "old" attribute/value pair.
>> -	 */
>> -	if (args->op_flags & XFS_DA_OP_RENAME) {
>> -		/*
>> -		 * In a separate transaction, set the incomplete flag on the
>> -		 * "old" attr and clear the incomplete flag on the "new" attr.
>> -		 */
>> -		error = xfs_attr3_leaf_flipflags(args);
>> -		if (error)
>> -			goto out;
>> -		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +		error = xfs_attr_rmt_find_hole(args);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   
>> +		args->dc.blkcnt = args->rmtblkcnt;
>> +		args->dc.lblkno = args->rmtblkno;
>>   		/*
>> -		 * Dismantle the "old" attribute/value pair by removing
>> -		 * a "remote" value (if it exists).
>> +		 * Roll through the "value", allocating blocks on disk as
>> +		 * required.
>>   		 */
>> -		args->index = args->index2;
>> -		args->blkno = args->blkno2;
>> -		args->rmtblkno = args->rmtblkno2;
>> -		args->rmtblkcnt = args->rmtblkcnt2;
>> -		args->rmtvaluelen = args->rmtvaluelen2;
>> -		if (args->rmtblkno) {
>> -			error = xfs_attr_rmtval_remove(args);
>> +alloc_node:
>> +		while (args->dc.blkcnt > 0) {
>> +			nmap = 1;
>> +			error = xfs_bmapi_write(args->trans, dp,
>> +				(xfs_fileoff_t)args->dc.lblkno, args->dc.blkcnt,
>> +				XFS_BMAPI_ATTRFORK, args->total, map, &nmap);
>>   			if (error)
>>   				return error;
>> -		}
>>   
>> -		/*
>> -		 * Re-find the "old" attribute entry after any split ops.
>> -		 * The INCOMPLETE flag means that we will find the "old"
>> -		 * attr, not the "new" one.
>> -		 */
>> -		args->name.type |= XFS_ATTR_INCOMPLETE;
>> -		state = xfs_da_state_alloc();
>> -		state->args = args;
>> -		state->mp = mp;
>> -		state->inleaf = 0;
>> -		error = xfs_da3_node_lookup_int(state, &retval);
>> -		if (error)
>> -			goto out;
>> +			ASSERT(nmap == 1);
>> +			ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
>> +			       (map->br_startblock != HOLESTARTBLOCK));
>>   
>> -		/*
>> -		 * Remove the name and update the hashvals in the tree.
>> -		 */
>> -		blk = &state->path.blk[ state->path.active-1 ];
>> -		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>> -		error = xfs_attr3_leaf_remove(blk->bp, args);
>> -		xfs_da3_fixhashpath(state, &state->path);
>> +			/* roll attribute extent map forwards */
>> +			args->dc.lblkno += map->br_blockcount;
>> +			args->dc.blkcnt -= map->br_blockcount;
>>   
>> -		/*
>> -		 * Check to see if the tree needs to be collapsed.
>> -		 */
>> -		if (retval && (state->path.active > 1)) {
>> -			error = xfs_da3_join(state);
>> -			if (error)
>> -				goto out;
>> -			error = xfs_defer_finish(&args->trans);
>> -			if (error)
>> -				goto out;
>> +			args->dc.dc_state = XFS_DC_ALLOC_NODE;
>> +			return -EAGAIN;
>>   		}
>>   
>> -		/*
>> -		 * Commit and start the next trans in the chain.
>> -		 */
>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>> +		error = xfs_attr_rmtval_set_value(args);
>>   		if (error)
>> -			goto out;
>> +			return error;
>> +	}
>>   
>> -	} else if (args->rmtblkno > 0) {
>> +	if (args->rmtblkno > 0) {
>>   		/*
>>   		 * Added a "remote" value, just clear the incomplete flag.
>>   		 */
>>   		error = xfs_attr3_leaf_clearflag(args);
>>   		if (error)
>>   			goto out;
>> -
>> -		 /*
>> -		  * Commit the flag value change and start the next trans in
>> -		  * series.
>> -		  */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -		if (error)
>> -			goto out;
>>   	}
>>   	retval = error = 0;
>>   
>> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
>> index fb8bf5b..c710387 100644
>> --- a/fs/xfs/libxfs/xfs_attr.h
>> +++ b/fs/xfs/libxfs/xfs_attr.h
>> @@ -149,6 +149,7 @@ int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
>>   int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
>>   		 unsigned char *value, int valuelen, int flags);
>>   int xfs_attr_set_args(struct xfs_da_args *args);
>> +int xfs_attr_set_later(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
>>   int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
>>   int xfs_has_attr(struct xfs_da_args *args);
>>   int xfs_attr_remove_args(struct xfs_da_args *args);
>> -- 
>> 2.7.4
>>
> 
