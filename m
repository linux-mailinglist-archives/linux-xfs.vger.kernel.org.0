Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3233516B212
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2020 22:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgBXVUm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Feb 2020 16:20:42 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42254 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgBXVUl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 16:20:41 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OLKV12011801;
        Mon, 24 Feb 2020 21:20:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tDRuUBEcGD26g9PHLUChFkzJ6K+gDlIUksVpB86bJn0=;
 b=0CqYjgw2LpI5mEj7g8gZhbLHEmSsP+SM8dRyja3hoQQSNqoHcwHL98flWwyZ7orwbGSk
 kXEyAgFSysoh9qUosF0ij2iL+vrTgpvqcsE/ODThfWmGhY7tdbRN4mky/GtUxW+Y09qw
 TqSsF+fuWiIT9iABB3y8jxUx7Sn02hLtzO3E0jAPJG4VCC7l49PPMQadWi6EV02Gh2h6
 1LAcrTQYOkCMs+BbxuyvJrLZ6ttYbQtChSP+ypdoXhob08AdgmDeAqsrqFZa1igD4bYJ
 VpMX0oF6m/nOWYgRw1PcxJJKwGDGir8hCD2lrOKe9FHDmXMhblVy+glMpOPUEPo4/ujU EQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ybvr4pd2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 21:20:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01OLGYAm170182;
        Mon, 24 Feb 2020 21:18:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ybduv7ffm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 21:18:38 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01OLIanV011875;
        Mon, 24 Feb 2020 21:18:37 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 13:18:36 -0800
Subject: Re: [PATCH v7 03/19] xfs: Add xfs_has_attr and subroutines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-4-allison.henderson@oracle.com>
 <20200224130800.GB15761@bfoster>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <2871cf8f-5bef-7e0a-33d0-c58a14763be8@oracle.com>
Date:   Mon, 24 Feb 2020 14:18:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200224130800.GB15761@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 suspectscore=2 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240157
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2/24/20 6:08 AM, Brian Foster wrote:
> On Sat, Feb 22, 2020 at 07:05:55PM -0700, Allison Collins wrote:
>> From: Allison Henderson <allison.henderson@oracle.com>
>>
>> This patch adds a new functions to check for the existence of an attribute.
>> Subroutines are also added to handle the cases of leaf blocks, nodes or shortform.
>> Common code that appears in existing attr add and remove functions have been
>> factored out to help reduce the appearance of duplicated code.  We will need these
>> routines later for delayed attributes since delayed operations cannot return error
>> codes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c      | 171 ++++++++++++++++++++++++++++--------------
>>   fs/xfs/libxfs/xfs_attr.h      |   1 +
>>   fs/xfs/libxfs/xfs_attr_leaf.c | 111 +++++++++++++++++----------
>>   fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
>>   4 files changed, 188 insertions(+), 98 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 9acdb23..2255060 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
> ...
>> @@ -310,6 +313,37 @@ xfs_attr_set_args(
>>   }
>>   
>>   /*
>> + * Return EEXIST if attr is found, or ENOATTR if not
>> + */
>> +int
>> +xfs_has_attr(
>> +	struct xfs_da_args      *args)
>> +{
>> +	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_buf		*bp = NULL;
>> +	int			error;
>> +
>> +	if (!xfs_inode_hasattr(dp))
>> +		return -ENOATTR;
>> +
>> +	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>> +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> +		return xfs_attr_sf_findname(args, NULL, NULL);
> 
> Nit: any reason we use "findname" here and "hasname" for the other two
> variants?
It was asked for in the v4 review.  Reason being we also return the 
location of the sf entry and byte offset.

> 
> Just a few other nit level things..
> 
>> +	}
>> +
>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> +		error = xfs_attr_leaf_hasname(args, &bp);
>> +
>> +		if (bp)
>> +			xfs_trans_brelse(args->trans, bp);
>> +
>> +		return error;
>> +	}
>> +
>> +	return xfs_attr_node_hasname(args, NULL);
>> +}
>> +
>> +/*
>>    * Remove the attribute specified in @args.
>>    */
>>   int
> ...
>> @@ -773,12 +822,11 @@ xfs_attr_leaf_removename(
>>   	 * Remove the attribute.
>>   	 */
>>   	dp = args->dp;
>> -	args->blkno = 0;
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
>> -	if (error)
>> +
>> +	error = xfs_attr_leaf_hasname(args, &bp);
>> +	if (error != -ENOATTR && error != -EEXIST)
>>   		return error;
>>   
>> -	error = xfs_attr3_leaf_lookup_int(bp, args);
>>   	if (error == -ENOATTR) {
> 
> It looks like some of these error checks could be cleaned up where the
> helper function is used. I.e., something like the following here:
> 
> 	if (error == -ENOATTR) {
> 		xfs_trans_brelse(...);
> 		return error;
> 	} else if (error != -EEXIST)
> 		return error;
Sure, I'm starting to get more pressure in other reviews to change this 
api to a boolean return type though (1: y, 0: no, <0: error).  I think 
we talked about this in v3, but decided to stick with this original api 
for now.  I'm thinking maybe adding a patch at the end to shift the api 
might be a good compromise?  Thoughts?

> 
>>   		xfs_trans_brelse(args->trans, bp);
>>   		return error;
>> @@ -817,12 +865,10 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>>   
>>   	trace_xfs_attr_leaf_get(args);
>>   
>> -	args->blkno = 0;
>> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
>> -	if (error)
>> +	error = xfs_attr_leaf_hasname(args, &bp);
>> +	if (error != -ENOATTR && error != -EEXIST)
>>   		return error;
>>   
>> -	error = xfs_attr3_leaf_lookup_int(bp, args);
>>   	if (error != -EEXIST)  {
>>   		xfs_trans_brelse(args->trans, bp);
>>   		return error;
> 
> Similar thing here, just reordering the checks simplifies the logic.
Sure, will do.

> 
>> @@ -832,6 +878,41 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>>   	return error;
>>   }
>>   
>> +/*
>> + * Return EEXIST if attr is found, or ENOATTR if not
>> + * statep: If not null is set to point at the found state.  Caller will
>> + *         be responsible for freeing the state in this case.
>> + */
>> +STATIC int
>> +xfs_attr_node_hasname(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	**statep)
>> +{
>> +	struct xfs_da_state	*state;
>> +	int			retval, error;
>> +
>> +	state = xfs_da_state_alloc();
>> +	state->args = args;
>> +	state->mp = args->dp->i_mount;
>> +
>> +	if (statep != NULL)
>> +		*statep = NULL;
>> +
>> +	/*
>> +	 * Search to see if name exists, and get back a pointer to it.
>> +	 */
>> +	error = xfs_da3_node_lookup_int(state, &retval);
>> +	if (error == 0) {
>> +		if (statep != NULL)
>> +			*statep = state;
>> +		return retval;
>> +	}
>> +
>> +	xfs_da_state_free(state);
>> +
>> +	return error;
>> +}
>> +
>>   /*========================================================================
>>    * External routines when attribute list size > geo->blksize
>>    *========================================================================*/
> ...
>> @@ -1316,31 +1381,23 @@ xfs_attr_node_get(xfs_da_args_t *args)
>>   {
>>   	xfs_da_state_t *state;
>>   	xfs_da_state_blk_t *blk;
>> -	int error, retval;
>> +	int error;
>>   	int i;
>>   
>>   	trace_xfs_attr_node_get(args);
>>   
>> -	state = xfs_da_state_alloc();
>> -	state->args = args;
>> -	state->mp = args->dp->i_mount;
>> -
>>   	/*
>>   	 * Search to see if name exists, and get back a pointer to it.
>>   	 */
>> -	error = xfs_da3_node_lookup_int(state, &retval);
>> -	if (error) {
>> -		retval = error;
>> -		goto out_release;
>> -	}
>> -	if (retval != -EEXIST)
>> +	error = xfs_attr_node_hasname(args, &state);
>> +	if (error != -EEXIST)
>>   		goto out_release;
>>   
>>   	/*
>>   	 * Get the value, local or "remote"
>>   	 */
>>   	blk = &state->path.blk[state->path.active - 1];
>> -	retval = xfs_attr3_leaf_getvalue(blk->bp, args);
>> +	error = xfs_attr3_leaf_getvalue(blk->bp, args);
>>   
>>   	/*
>>   	 * If not in a transaction, we have to release all the buffers.
>> @@ -1352,7 +1409,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
>>   	}
>>   
>>   	xfs_da_state_free(state);
> 
> Do we need an 'if (state)' check here like the other node funcs?
I think so, because if xfs_attr_node_hasname errors out it releases the 
state.  Will add.

> 
>> -	return retval;
>> +	return error;
>>   }
>>   
>>   /* Returns true if the attribute entry name is valid. */
> ...
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index cb5ef66..9d6b68c 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -654,18 +654,66 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
>>   }
>>   
>>   /*
>> + * Return -EEXIST if attr is found, or -ENOATTR if not
>> + * args:  args containing attribute name and namelen
>> + * sfep:  If not null, pointer will be set to the last attr entry found on
>> +	  -EEXIST.  On -ENOATTR pointer is left at the last entry in the list
>> + * basep: If not null, pointer is set to the byte offset of the entry in the
>> + *	  list on -EEXIST.  On -ENOATTR, pointer is left at the byte offset of
>> + *	  the last entry in the list
>> + */
>> +int
>> +xfs_attr_sf_findname(
>> +	struct xfs_da_args	 *args,
>> +	struct xfs_attr_sf_entry **sfep,
>> +	unsigned int		 *basep)
>> +{
>> +	struct xfs_attr_shortform *sf;
>> +	struct xfs_attr_sf_entry *sfe;
>> +	unsigned int		base = sizeof(struct xfs_attr_sf_hdr);
>> +	int			size = 0;
>> +	int			end;
>> +	int			i;
>> +
>> +	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
>> +	sfe = &sf->list[0];
>> +	end = sf->hdr.count;
>> +	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
>> +			base += size, i++) {
> 
> Slightly more readable to align indendation with the sfe assignment
> above.
Sure, will fix.  Thanks!

Allison

> 
> Brian
> 
>> +		size = XFS_ATTR_SF_ENTSIZE(sfe);
>> +		if (sfe->namelen != args->name.len)
>> +			continue;
>> +		if (memcmp(sfe->nameval, args->name.name, args->name.len) != 0)
>> +			continue;
>> +		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
>> +			continue;
>> +		break;
>> +	}
>> +
>> +	if (sfep != NULL)
>> +		*sfep = sfe;
>> +
>> +	if (basep != NULL)
>> +		*basep = base;
>> +
>> +	if (i == end)
>> +		return -ENOATTR;
>> +	return -EEXIST;
>> +}
>> +
>> +/*
>>    * Add a name/value pair to the shortform attribute list.
>>    * Overflow from the inode has already been checked for.
>>    */
>>   void
>> -xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>> +xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff)
>>   {
>> -	xfs_attr_shortform_t *sf;
>> -	xfs_attr_sf_entry_t *sfe;
>> -	int i, offset, size;
>> -	xfs_mount_t *mp;
>> -	xfs_inode_t *dp;
>> -	struct xfs_ifork *ifp;
>> +	struct xfs_attr_shortform	*sf;
>> +	struct xfs_attr_sf_entry	*sfe;
>> +	int				offset, size, error;
>> +	struct xfs_mount		*mp;
>> +	struct xfs_inode		*dp;
>> +	struct xfs_ifork		*ifp;
>>   
>>   	trace_xfs_attr_sf_add(args);
>>   
>> @@ -676,18 +724,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>>   	ifp = dp->i_afp;
>>   	ASSERT(ifp->if_flags & XFS_IFINLINE);
>>   	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
>> -	sfe = &sf->list[0];
>> -	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
>> -#ifdef DEBUG
>> -		if (sfe->namelen != args->name.len)
>> -			continue;
>> -		if (memcmp(args->name.name, sfe->nameval, args->name.len) != 0)
>> -			continue;
>> -		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
>> -			continue;
>> -		ASSERT(0);
>> -#endif
>> -	}
>> +	error = xfs_attr_sf_findname(args, &sfe, NULL);
>> +	ASSERT(error != -EEXIST);
>>   
>>   	offset = (char *)sfe - (char *)sf;
>>   	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
>> @@ -730,35 +768,26 @@ xfs_attr_fork_remove(
>>    * Remove an attribute from the shortform attribute list structure.
>>    */
>>   int
>> -xfs_attr_shortform_remove(xfs_da_args_t *args)
>> +xfs_attr_shortform_remove(struct xfs_da_args *args)
>>   {
>> -	xfs_attr_shortform_t *sf;
>> -	xfs_attr_sf_entry_t *sfe;
>> -	int base, size=0, end, totsize, i;
>> -	xfs_mount_t *mp;
>> -	xfs_inode_t *dp;
>> +	struct xfs_attr_shortform	*sf;
>> +	struct xfs_attr_sf_entry	*sfe;
>> +	int				size = 0, end, totsize;
>> +	unsigned int			base;
>> +	struct xfs_mount		*mp;
>> +	struct xfs_inode		*dp;
>> +	int				error;
>>   
>>   	trace_xfs_attr_sf_remove(args);
>>   
>>   	dp = args->dp;
>>   	mp = dp->i_mount;
>> -	base = sizeof(xfs_attr_sf_hdr_t);
>>   	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
>> -	sfe = &sf->list[0];
>> -	end = sf->hdr.count;
>> -	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
>> -					base += size, i++) {
>> -		size = XFS_ATTR_SF_ENTSIZE(sfe);
>> -		if (sfe->namelen != args->name.len)
>> -			continue;
>> -		if (memcmp(sfe->nameval, args->name.name, args->name.len) != 0)
>> -			continue;
>> -		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
>> -			continue;
>> -		break;
>> -	}
>> -	if (i == end)
>> -		return -ENOATTR;
>> +
>> +	error = xfs_attr_sf_findname(args, &sfe, &base);
>> +	if (error != -EEXIST)
>> +		return error;
>> +	size = XFS_ATTR_SF_ENTSIZE(sfe);
>>   
>>   	/*
>>   	 * Fix up the attribute fork data, covering the hole
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
>> index 73615b1..0e9c87c 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
>> @@ -53,6 +53,9 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>>   int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>>   			struct xfs_buf **leaf_bp);
>>   int	xfs_attr_shortform_remove(struct xfs_da_args *args);
>> +int	xfs_attr_sf_findname(struct xfs_da_args *args,
>> +			     struct xfs_attr_sf_entry **sfep,
>> +			     unsigned int *basep);
>>   int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>>   int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>>   xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
>> -- 
>> 2.7.4
>>
> 
