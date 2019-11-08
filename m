Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B2EF57A6
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Nov 2019 21:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387870AbfKHTdL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Nov 2019 14:33:11 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55800 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387798AbfKHTdK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 14:33:10 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8JT75m098061
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:33:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=jGj8IUYi7/CkvGGHk1RKPHCb6LCyNLTt4pFHPB0hsDQ=;
 b=Cdlchey064tfPKktLpUr+erG5ORwBlQeFGcFcTD/zKEm8oqg24g7355DHqMIE3qwjJ1c
 GUFgtPexZfiBz4sa5AfJPAe2VX1+12HGqgVqJ1KYqCz3gv/02eptKSZufg39OE05N93g
 V6TdPK6O4mwVmCDA6eBewqtrXbQVduH9DkAzcrS4cA0KkedVftnqd9M+3XXhK+7DvdTu
 fvFCn9sX5mKXEsBNklDDCN/yhQZ5JnRIF4Vpz2+WcWffee2RcgH59NDT2qss/Xtb6ejd
 RjyHdYFjyD8QF8hjxO8lVJPTPJZuML1WBKPgJJkzMT/BXDKf88DyaYU55KI829b1o/6f bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w41w179cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 19:33:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA8JSoqZ142715
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:33:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2w5bmq780m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 19:33:05 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA8JX4ju025129
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 19:33:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 11:32:47 -0800
Date:   Fri, 8 Nov 2019 11:32:46 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 05/17] xfs: Add xfs_has_attr and subroutines
Message-ID: <20191108193246.GW6219@magnolia>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
 <20191107012801.22863-6-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107012801.22863-6-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080189
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9435 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080189
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 06:27:49PM -0700, Allison Collins wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch adds a new functions to check for the existence of
> an attribute.  Subroutines are also added to handle the cases
> of leaf blocks, nodes or shortform.  Common code that appears
> in existing attr add and remove functions have been factored
> out to help reduce the appearence of duplicated code.  We will
> need these routines later for delayed attributes since delayed
> operations cannot return error codes.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 154 +++++++++++++++++++++++++++---------------
>  fs/xfs/libxfs/xfs_attr.h      |   1 +
>  fs/xfs/libxfs/xfs_attr_leaf.c | 107 ++++++++++++++++++-----------
>  fs/xfs/libxfs/xfs_attr_leaf.h |   2 +
>  4 files changed, 171 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 5cb83a8..c8a3273 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -46,6 +46,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>  
>  /*
>   * Internal routines when attribute list is more than one block.
> @@ -53,6 +54,8 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
> +				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>  
> @@ -310,6 +313,34 @@ xfs_attr_set_args(
>  }
>  
>  /*
> + * Return EEXIST if attr is found, or ENOATTR if not
> + */
> +int
> +xfs_has_attr(
> +	struct xfs_da_args      *args)

I was really hoping for a "replace ENOATTR/EEXIST with a boolean"
cleanup at the end of this series, though as a straight hoisting and
refactoring, this patch is ok for leaving the existing error code
overloading. :)

> +{
> +	struct xfs_inode        *dp = args->dp;
> +	struct xfs_buf		*bp;
> +	int                     error;
> +
> +	if (!xfs_inode_hasattr(dp)) {
> +		error = -ENOATTR;
> +	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> +		error = xfs_attr_shortform_hasname(args, NULL, NULL);
> +	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +		error = xfs_attr_leaf_hasname(args, &bp);
> +		if (error != -ENOATTR && error != -EEXIST)
> +			goto out;
> +		xfs_trans_brelse(args->trans, bp);
> +	} else {
> +		error = xfs_attr_node_hasname(args, NULL);
> +	}
> +out:
> +	return error;
> +}
> +
> +/*
>   * Remove the attribute specified in @args.
>   */
>  int
> @@ -580,27 +611,20 @@ STATIC int
>  xfs_attr_leaf_addname(
>  	struct xfs_da_args	*args)
>  {
> -	struct xfs_inode	*dp;
>  	struct xfs_buf		*bp;
>  	int			retval, error, forkoff;
> +	struct xfs_inode	*dp = args->dp;
>  
>  	trace_xfs_attr_leaf_addname(args);
>  
>  	/*
> -	 * Read the (only) block in the attribute list in.
> -	 */
> -	dp = args->dp;
> -	args->blkno = 0;
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> -				    XFS_DABUF_MAP_NOMAPPING, &bp);
> -	if (error)
> -		return error;
> -
> -	/*
>  	 * Look up the given attribute in the leaf block.  Figure out if
>  	 * the given flags produce an error or call for an atomic rename.
>  	 */
> -	retval = xfs_attr3_leaf_lookup_int(bp, args);
> +	retval = xfs_attr_leaf_hasname(args, &bp);
> +	if (retval != -ENOATTR && retval != -EEXIST)
> +		return retval;
> +
>  	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
>  		xfs_trans_brelse(args->trans, bp);
>  		return retval;
> @@ -752,6 +776,24 @@ xfs_attr_leaf_addname(
>  }
>  
>  /*
> + * Return EEXIST if attr is found, or ENOATTR if not
> + */
> +STATIC int
> +xfs_attr_leaf_hasname(
> +	struct xfs_da_args      *args,
> +	struct xfs_buf		**bp)
> +{
> +	int                     error = 0;
> +
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, 0,
> +				    XFS_DABUF_MAP_NOMAPPING, bp);
> +	if (error)
> +		return error;
> +
> +	return xfs_attr3_leaf_lookup_int(*bp, args);
> +}
> +
> +/*
>   * Remove a name from the leaf attribute list structure
>   *
>   * This leaf block cannot have a "remote" value, we only call this routine
> @@ -771,13 +813,11 @@ xfs_attr_leaf_removename(
>  	 * Remove the attribute.
>  	 */
>  	dp = args->dp;
> -	args->blkno = 0;
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> -				    XFS_DABUF_MAP_NOMAPPING, &bp);
> -	if (error)
> +
> +	error = xfs_attr_leaf_hasname(args, &bp);
> +	if (error != -ENOATTR && error != -EEXIST)
>  		return error;
>  
> -	error = xfs_attr3_leaf_lookup_int(bp, args);
>  	if (error == -ENOATTR) {
>  		xfs_trans_brelse(args->trans, bp);
>  		return error;
> @@ -816,13 +856,10 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>  
>  	trace_xfs_attr_leaf_get(args);
>  
> -	args->blkno = 0;
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> -				    XFS_DABUF_MAP_NOMAPPING, &bp);
> -	if (error)
> +	error = xfs_attr_leaf_hasname(args, &bp);
> +	if (error != -ENOATTR && error != -EEXIST)
>  		return error;
>  
> -	error = xfs_attr3_leaf_lookup_int(bp, args);
>  	if (error != -EEXIST)  {
>  		xfs_trans_brelse(args->trans, bp);
>  		return error;
> @@ -832,6 +869,38 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>  	return error;
>  }
>  
> +/*
> + * Return EEXIST if attr is found, or ENOATTR if not
> + * statep: If not null is set to point at the found state.  Caller will
> + * 	   be responsible for freeing the state in this case.
> + */
> +STATIC int
> +xfs_attr_node_hasname(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	**statep)
> +{
> +	struct xfs_da_state	*state;
> +	int			retval, error;
> +
> +	state = xfs_da_state_alloc();
> +	state->args = args;
> +	state->mp = args->dp->i_mount;
> +
> +	/*
> +	 * Search to see if name exists, and get back a pointer to it.
> +	 */
> +	error = xfs_da3_node_lookup_int(state, &retval);
> +	if (error == 0)
> +		error = retval;
> +
> +	if (statep != NULL)
> +		*statep = state;
> +	else
> +		xfs_da_state_free(state);
> +
> +	return error;
> +}
> +
>  /*========================================================================
>   * External routines when attribute list size > geo->blksize
>   *========================================================================*/
> @@ -864,20 +933,17 @@ xfs_attr_node_addname(
>  	dp = args->dp;
>  	mp = dp->i_mount;
>  restart:
> -	state = xfs_da_state_alloc();
> -	state->args = args;
> -	state->mp = mp;
> -
>  	/*
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
>  	 */
> -	error = xfs_da3_node_lookup_int(state, &retval);
> -	if (error)
> +	retval = xfs_attr_node_hasname(args, &state);
> +	if (retval != -ENOATTR)
>  		goto out;
> +
>  	blk = &state->path.blk[ state->path.active-1 ];
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> -	if ((args->name.type & ATTR_REPLACE) && (retval == -ENOATTR)) {
> +	if (args->name.type & ATTR_REPLACE) {
>  		goto out;
>  	} else if (retval == -EEXIST) {
>  		if (args->name.type & ATTR_CREATE)
> @@ -1079,29 +1145,15 @@ xfs_attr_node_removename(
>  {
>  	struct xfs_da_state	*state;
>  	struct xfs_da_state_blk	*blk;
> -	struct xfs_inode	*dp;
>  	struct xfs_buf		*bp;
>  	int			retval, error, forkoff;
> +	struct xfs_inode	*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
>  
> -	/*
> -	 * Tie a string around our finger to remind us where we are.
> -	 */
> -	dp = args->dp;
> -	state = xfs_da_state_alloc();
> -	state->args = args;
> -	state->mp = dp->i_mount;
> -
> -	/*
> -	 * Search to see if name exists, and get back a pointer to it.
> -	 */
> -	error = xfs_da3_node_lookup_int(state, &retval);
> -	if (error || (retval != -EEXIST)) {
> -		if (error == 0)
> -			error = retval;
> +	error = xfs_attr_node_hasname(args, &state);
> +	if (error != -EEXIST)
>  		goto out;
> -	}
>  
>  	/*
>  	 * If there is an out-of-line value, de-allocate the blocks.
> @@ -1324,20 +1376,14 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  
>  	trace_xfs_attr_node_get(args);
>  
> -	state = xfs_da_state_alloc();
> -	state->args = args;
> -	state->mp = args->dp->i_mount;
> -
>  	/*
>  	 * Search to see if name exists, and get back a pointer to it.
>  	 */
> -	error = xfs_da3_node_lookup_int(state, &retval);
> -	if (error) {
> +	error = xfs_attr_node_hasname(args, &state);
> +	if (error != -EEXIST) {
>  		retval = error;
>  		goto out_release;
>  	}
> -	if (retval != -EEXIST)
> -		goto out_release;
>  
>  	/*
>  	 * Get the value, local or "remote"
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 44dd07a..3b5dad4 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -150,6 +150,7 @@ int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
>  		 unsigned char *value, int valuelen, int flags);
>  int xfs_attr_set_args(struct xfs_da_args *args);
>  int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
> +int xfs_has_attr(struct xfs_da_args *args);
>  int xfs_attr_remove_args(struct xfs_da_args *args);
>  int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
>  		  int flags, struct attrlist_cursor_kern *cursor);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 93c3496..d06cfd6 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -655,18 +655,67 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
>  }
>  
>  /*
> + * Return -EEXIST if attr is found, or -ENOATTR if not
> + * args:  args containing attribute name and namelen
> + * sfep:  If not null, pointer will be set to the last attr entry found on
> +	  -EEXIST.  On -ENOATTR pointer is left at the last entry in the list
> + * basep: If not null, pointer is set to the byte offset of the entry in the
> + *	  list on -EEXIST.  On -ENOATTR, pointer is left at the byte offset of
> + *	  the last entry in the list
> + */
> +int
> +xfs_attr_shortform_hasname(
> +	struct xfs_da_args	 *args,
> +	struct xfs_attr_sf_entry **sfep,
> +	int			 *basep)

Byte offsets can't be negative, so this should be unsigned int.

Seeing as we also return the location of the sf entry and byte offset,
maybe this ought to be called xfs_attr_sf_findname ?

> +{
> +	struct xfs_attr_shortform *sf;
> +	struct xfs_attr_sf_entry *sfe;
> +	int			base = sizeof(struct xfs_attr_sf_hdr);
> +	int			size = 0;
> +	int			end;
> +	int			i;
> +
> +	base = sizeof(struct xfs_attr_sf_hdr);
> +	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
> +	sfe = &sf->list[0];
> +	end = sf->hdr.count;
> +	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
> +			base += size, i++) {
> +		size = XFS_ATTR_SF_ENTSIZE(sfe);
> +		if (sfe->namelen != args->name.len)
> +			continue;
> +		if (memcmp(sfe->nameval, args->name.name, args->name.len) != 0)
> +			continue;
> +		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
> +			continue;
> +		break;
> +	}
> +
> +	if (sfep != NULL)
> +		*sfep = sfe;
> +
> +	if (basep != NULL)
> +		*basep = base;
> +
> +	if (i == end)
> +		return -ENOATTR;
> +	return -EEXIST;
> +}
> +
> +/*
>   * Add a name/value pair to the shortform attribute list.
>   * Overflow from the inode has already been checked for.
>   */
>  void
>  xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>  {
> -	xfs_attr_shortform_t *sf;
> -	xfs_attr_sf_entry_t *sfe;
> -	int i, offset, size;
> -	xfs_mount_t *mp;
> -	xfs_inode_t *dp;
> -	struct xfs_ifork *ifp;
> +	struct xfs_attr_shortform	*sf;
> +	struct xfs_attr_sf_entry	*sfe;
> +	int				offset, size, error;
> +	struct xfs_mount		*mp;
> +	struct xfs_inode		*dp;
> +	struct xfs_ifork		*ifp;
>  
>  	trace_xfs_attr_sf_add(args);
>  
> @@ -677,18 +726,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>  	ifp = dp->i_afp;
>  	ASSERT(ifp->if_flags & XFS_IFINLINE);
>  	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
> -	sfe = &sf->list[0];
> -	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
> -#ifdef DEBUG
> -		if (sfe->namelen != args->name.len)
> -			continue;
> -		if (memcmp(args->name.name, sfe->nameval, args->name.len) != 0)
> -			continue;
> -		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
> -			continue;
> -		ASSERT(0);
> -#endif
> -	}
> +	error = xfs_attr_shortform_hasname(args, &sfe, NULL);
> +	ASSERT(error != -EEXIST);

If this assertion triggers, the fs is corrupt and we need to log
something and bail out.  5.5 for-next will soon have a new
XFS_IS_CORRUPT macro that takes care of this, so you can do:

	error = xfs_attr_shortform_hasname(args, &sfe, NULL);
	if (XFS_IS_CORRUPT(mp, error != -EEXIST))
		return -EFSCORRUPTED;

--D


>  
>  	offset = (char *)sfe - (char *)sf;
>  	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
> @@ -733,33 +772,23 @@ xfs_attr_fork_remove(
>  int
>  xfs_attr_shortform_remove(xfs_da_args_t *args)
>  {
> -	xfs_attr_shortform_t *sf;
> -	xfs_attr_sf_entry_t *sfe;
> -	int base, size=0, end, totsize, i;
> -	xfs_mount_t *mp;
> -	xfs_inode_t *dp;
> +	struct xfs_attr_shortform	*sf;
> +	struct xfs_attr_sf_entry	*sfe;
> +	int				base, size = 0, end, totsize;
> +	struct xfs_mount		*mp;
> +	struct xfs_inode		*dp;
> +	int				error;
>  
>  	trace_xfs_attr_sf_remove(args);
>  
>  	dp = args->dp;
>  	mp = dp->i_mount;
> -	base = sizeof(xfs_attr_sf_hdr_t);
>  	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
> -	sfe = &sf->list[0];
> -	end = sf->hdr.count;
> -	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
> -					base += size, i++) {
> -		size = XFS_ATTR_SF_ENTSIZE(sfe);
> -		if (sfe->namelen != args->name.len)
> -			continue;
> -		if (memcmp(sfe->nameval, args->name.name, args->name.len) != 0)
> -			continue;
> -		if (!xfs_attr_namesp_match(args->name.type, sfe->flags))
> -			continue;
> -		break;
> -	}
> -	if (i == end)
> -		return -ENOATTR;
> +
> +	error = xfs_attr_shortform_hasname(args, &sfe, &base);
> +	if (error != -EEXIST)
> +		return error;
> +	size = XFS_ATTR_SF_ENTSIZE(sfe);
>  
>  	/*
>  	 * Fix up the attribute fork data, covering the hole
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 017480e..e108b37 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -42,6 +42,8 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>  int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>  			struct xfs_buf **leaf_bp);
>  int	xfs_attr_shortform_remove(struct xfs_da_args *args);
> +int	xfs_attr_shortform_hasname(struct xfs_da_args *args,
> +			       struct xfs_attr_sf_entry **sfep, int *basep);
>  int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>  int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>  xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
> -- 
> 2.7.4
> 
