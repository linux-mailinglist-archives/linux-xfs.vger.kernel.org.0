Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1A6516A6E0
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2020 14:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgBXNIM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Feb 2020 08:08:12 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35570 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727393AbgBXNIM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 08:08:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582549690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=POQSphizpwtp11R4rGUj2zhUVExgPByErFVD5r8pKlI=;
        b=VpOem90oSHmRTCDnoxgA5xddedcpQmNni2QFUY8oWP2OvgKiQChPIv2h40bCcNVgT5NtRT
        00h1e9hHM/M9kQ6prlQWMX2oO8havPjvbsjlLvrT2xEx7u+gu78T3R6bXGTA6Y+ENC9+IL
        wshxfYDTTrgMXiqhZcPivzLmKXHnPqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-5bTo1YGHOYGpBwEQccJbiA-1; Mon, 24 Feb 2020 08:08:04 -0500
X-MC-Unique: 5bTo1YGHOYGpBwEQccJbiA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44E9D13F5;
        Mon, 24 Feb 2020 13:08:03 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AD7471001B28;
        Mon, 24 Feb 2020 13:08:02 +0000 (UTC)
Date:   Mon, 24 Feb 2020 08:08:00 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 03/19] xfs: Add xfs_has_attr and subroutines
Message-ID: <20200224130800.GB15761@bfoster>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223020611.1802-4-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 22, 2020 at 07:05:55PM -0700, Allison Collins wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> This patch adds a new functions to check for the existence of an attribute.
> Subroutines are also added to handle the cases of leaf blocks, nodes or shortform.
> Common code that appears in existing attr add and remove functions have been
> factored out to help reduce the appearance of duplicated code.  We will need these
> routines later for delayed attributes since delayed operations cannot return error
> codes.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c      | 171 ++++++++++++++++++++++++++++--------------
>  fs/xfs/libxfs/xfs_attr.h      |   1 +
>  fs/xfs/libxfs/xfs_attr_leaf.c | 111 +++++++++++++++++----------
>  fs/xfs/libxfs/xfs_attr_leaf.h |   3 +
>  4 files changed, 188 insertions(+), 98 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 9acdb23..2255060 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -310,6 +313,37 @@ xfs_attr_set_args(
>  }
>  
>  /*
> + * Return EEXIST if attr is found, or ENOATTR if not
> + */
> +int
> +xfs_has_attr(
> +	struct xfs_da_args      *args)
> +{
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_buf		*bp = NULL;
> +	int			error;
> +
> +	if (!xfs_inode_hasattr(dp))
> +		return -ENOATTR;
> +
> +	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> +		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> +		return xfs_attr_sf_findname(args, NULL, NULL);

Nit: any reason we use "findname" here and "hasname" for the other two
variants?

Just a few other nit level things..

> +	}
> +
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
> +		error = xfs_attr_leaf_hasname(args, &bp);
> +
> +		if (bp)
> +			xfs_trans_brelse(args->trans, bp);
> +
> +		return error;
> +	}
> +
> +	return xfs_attr_node_hasname(args, NULL);
> +}
> +
> +/*
>   * Remove the attribute specified in @args.
>   */
>  int
...
> @@ -773,12 +822,11 @@ xfs_attr_leaf_removename(
>  	 * Remove the attribute.
>  	 */
>  	dp = args->dp;
> -	args->blkno = 0;
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
> -	if (error)
> +
> +	error = xfs_attr_leaf_hasname(args, &bp);
> +	if (error != -ENOATTR && error != -EEXIST)
>  		return error;
>  
> -	error = xfs_attr3_leaf_lookup_int(bp, args);
>  	if (error == -ENOATTR) {

It looks like some of these error checks could be cleaned up where the
helper function is used. I.e., something like the following here:

	if (error == -ENOATTR) {
		xfs_trans_brelse(...);
		return error;
	} else if (error != -EEXIST)
		return error;

>  		xfs_trans_brelse(args->trans, bp);
>  		return error;
> @@ -817,12 +865,10 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>  
>  	trace_xfs_attr_leaf_get(args);
>  
> -	args->blkno = 0;
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno, &bp);
> -	if (error)
> +	error = xfs_attr_leaf_hasname(args, &bp);
> +	if (error != -ENOATTR && error != -EEXIST)
>  		return error;
>  
> -	error = xfs_attr3_leaf_lookup_int(bp, args);
>  	if (error != -EEXIST)  {
>  		xfs_trans_brelse(args->trans, bp);
>  		return error;

Similar thing here, just reordering the checks simplifies the logic.

> @@ -832,6 +878,41 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>  	return error;
>  }
>  
> +/*
> + * Return EEXIST if attr is found, or ENOATTR if not
> + * statep: If not null is set to point at the found state.  Caller will
> + *         be responsible for freeing the state in this case.
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
> +	if (statep != NULL)
> +		*statep = NULL;
> +
> +	/*
> +	 * Search to see if name exists, and get back a pointer to it.
> +	 */
> +	error = xfs_da3_node_lookup_int(state, &retval);
> +	if (error == 0) {
> +		if (statep != NULL)
> +			*statep = state;
> +		return retval;
> +	}
> +
> +	xfs_da_state_free(state);
> +
> +	return error;
> +}
> +
>  /*========================================================================
>   * External routines when attribute list size > geo->blksize
>   *========================================================================*/
...
> @@ -1316,31 +1381,23 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  {
>  	xfs_da_state_t *state;
>  	xfs_da_state_blk_t *blk;
> -	int error, retval;
> +	int error;
>  	int i;
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
> -		retval = error;
> -		goto out_release;
> -	}
> -	if (retval != -EEXIST)
> +	error = xfs_attr_node_hasname(args, &state);
> +	if (error != -EEXIST)
>  		goto out_release;
>  
>  	/*
>  	 * Get the value, local or "remote"
>  	 */
>  	blk = &state->path.blk[state->path.active - 1];
> -	retval = xfs_attr3_leaf_getvalue(blk->bp, args);
> +	error = xfs_attr3_leaf_getvalue(blk->bp, args);
>  
>  	/*
>  	 * If not in a transaction, we have to release all the buffers.
> @@ -1352,7 +1409,7 @@ xfs_attr_node_get(xfs_da_args_t *args)
>  	}
>  
>  	xfs_da_state_free(state);

Do we need an 'if (state)' check here like the other node funcs?

> -	return retval;
> +	return error;
>  }
>  
>  /* Returns true if the attribute entry name is valid. */
...
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index cb5ef66..9d6b68c 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -654,18 +654,66 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
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
> +xfs_attr_sf_findname(
> +	struct xfs_da_args	 *args,
> +	struct xfs_attr_sf_entry **sfep,
> +	unsigned int		 *basep)
> +{
> +	struct xfs_attr_shortform *sf;
> +	struct xfs_attr_sf_entry *sfe;
> +	unsigned int		base = sizeof(struct xfs_attr_sf_hdr);
> +	int			size = 0;
> +	int			end;
> +	int			i;
> +
> +	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
> +	sfe = &sf->list[0];
> +	end = sf->hdr.count;
> +	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
> +			base += size, i++) {

Slightly more readable to align indendation with the sfe assignment
above.

Brian

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
> -xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
> +xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff)
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
> @@ -676,18 +724,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
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
> +	error = xfs_attr_sf_findname(args, &sfe, NULL);
> +	ASSERT(error != -EEXIST);
>  
>  	offset = (char *)sfe - (char *)sf;
>  	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
> @@ -730,35 +768,26 @@ xfs_attr_fork_remove(
>   * Remove an attribute from the shortform attribute list structure.
>   */
>  int
> -xfs_attr_shortform_remove(xfs_da_args_t *args)
> +xfs_attr_shortform_remove(struct xfs_da_args *args)
>  {
> -	xfs_attr_shortform_t *sf;
> -	xfs_attr_sf_entry_t *sfe;
> -	int base, size=0, end, totsize, i;
> -	xfs_mount_t *mp;
> -	xfs_inode_t *dp;
> +	struct xfs_attr_shortform	*sf;
> +	struct xfs_attr_sf_entry	*sfe;
> +	int				size = 0, end, totsize;
> +	unsigned int			base;
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
> +	error = xfs_attr_sf_findname(args, &sfe, &base);
> +	if (error != -EEXIST)
> +		return error;
> +	size = XFS_ATTR_SF_ENTSIZE(sfe);
>  
>  	/*
>  	 * Fix up the attribute fork data, covering the hole
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 73615b1..0e9c87c 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -53,6 +53,9 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>  int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>  			struct xfs_buf **leaf_bp);
>  int	xfs_attr_shortform_remove(struct xfs_da_args *args);
> +int	xfs_attr_sf_findname(struct xfs_da_args *args,
> +			     struct xfs_attr_sf_entry **sfep,
> +			     unsigned int *basep);
>  int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>  int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>  xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
> -- 
> 2.7.4
> 

