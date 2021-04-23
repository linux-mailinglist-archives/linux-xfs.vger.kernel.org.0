Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA2F3697F4
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Apr 2021 19:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhDWRGz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 23 Apr 2021 13:06:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27515 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229691AbhDWRGy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Apr 2021 13:06:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619197577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ep34j8AFlLcHocWgcywDyVXIMd1GPgOOBIztgNhv5WA=;
        b=QLnOK3YLZ9kCSy9BJ0NJ6VzKbiGGH66T5R3baNYGMOXbxlisZpgNO9o8MT9ZWc1AzYzLCt
        e73hbsZu7MkL4XJaCc2yRSYLS6PNwSq4mB6Esy7eRjphj4bY6NFg1TJYg8DAzt5a7bTuCw
        A/iGadxp+ZZV7qsJS+b0jBmQg3Bdtpo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-ZbmdDVXiP_qwveJ0CmlKPA-1; Fri, 23 Apr 2021 13:06:15 -0400
X-MC-Unique: ZbmdDVXiP_qwveJ0CmlKPA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A3E8343A4;
        Fri, 23 Apr 2021 17:06:14 +0000 (UTC)
Received: from bfoster (ovpn-112-25.rdu2.redhat.com [10.10.112.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1705A608BA;
        Fri, 23 Apr 2021 17:06:13 +0000 (UTC)
Date:   Fri, 23 Apr 2021 13:06:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v17 08/11] xfs: Hoist xfs_attr_leaf_addname
Message-ID: <YIL+hEnaC7PG1tri@bfoster>
References: <20210416092045.2215-1-allison.henderson@oracle.com>
 <20210416092045.2215-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416092045.2215-9-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 16, 2021 at 02:20:42AM -0700, Allison Henderson wrote:
> This patch hoists xfs_attr_leaf_addname into the calling function.  The
> goal being to get all the code that will require state management into
> the same scope. This isn't particularly aesthetic right away, but it is a
> preliminary step to merging in the state machine code.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 209 ++++++++++++++++++++++-------------------------
>  fs/xfs/xfs_trace.h       |   1 -
>  2 files changed, 96 insertions(+), 114 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 80212d2..5740127 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -287,10 +288,101 @@ xfs_attr_set_args(
>  	}
>  
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
...
>  			return error;
>  
> +		xfs_attr3_leaf_remove(bp, args);
> +
> +		/*
> +		 * If the result is small enough, shrink it all into the inode.
> +		 */
> +		forkoff = xfs_attr_shortform_allfit(bp, dp);
> +		if (forkoff)
> +			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +			/* bp is gone due to xfs_da_shrink_inode */
> +
> +		return error;
> +node:

With the understanding that this mid function return thing goes away
before the end of the series:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  		/*
>  		 * Promote the attribute list to the Btree format.
>  		 */
> @@ -727,115 +819,6 @@ xfs_attr_leaf_try_add(
>  	return retval;
>  }
>  
> -
> -/*
> - * Add a name to the leaf attribute list structure
> - *
> - * This leaf block cannot have a "remote" value, we only call this routine
> - * if bmap_one_block() says there is only one block (ie: no remote blks).
> - */
> -STATIC int
> -xfs_attr_leaf_addname(
> -	struct xfs_da_args	*args)
> -{
> -	int			error, forkoff;
> -	struct xfs_buf		*bp = NULL;
> -	struct xfs_inode	*dp = args->dp;
> -
> -	trace_xfs_attr_leaf_addname(args);
> -
> -	error = xfs_attr_leaf_try_add(args, bp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Commit the transaction that added the attr name so that
> -	 * later routines can manage their own transactions.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, dp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * If there was an out-of-line value, allocate the blocks we
> -	 * identified for its storage and copy the value.  This is done
> -	 * after we create the attribute so that we don't overflow the
> -	 * maximum size of a transaction and/or hit a deadlock.
> -	 */
> -	if (args->rmtblkno > 0) {
> -		error = xfs_attr_rmtval_set(args);
> -		if (error)
> -			return error;
> -	}
> -
> -	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
> -		/*
> -		 * Added a "remote" value, just clear the incomplete flag.
> -		 */
> -		if (args->rmtblkno > 0)
> -			error = xfs_attr3_leaf_clearflag(args);
> -
> -		return error;
> -	}
> -
> -	/*
> -	 * If this is an atomic rename operation, we must "flip" the incomplete
> -	 * flags on the "new" and "old" attribute/value pairs so that one
> -	 * disappears and one appears atomically.  Then we must remove the "old"
> -	 * attribute/value pair.
> -	 *
> -	 * In a separate transaction, set the incomplete flag on the "old" attr
> -	 * and clear the incomplete flag on the "new" attr.
> -	 */
> -
> -	error = xfs_attr3_leaf_flipflags(args);
> -	if (error)
> -		return error;
> -	/*
> -	 * Commit the flag value change and start the next trans in series.
> -	 */
> -	error = xfs_trans_roll_inode(&args->trans, args->dp);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> -	 * (if it exists).
> -	 */
> -	xfs_attr_restore_rmt_blk(args);
> -
> -	if (args->rmtblkno) {
> -		error = xfs_attr_rmtval_invalidate(args);
> -		if (error)
> -			return error;
> -
> -		error = xfs_attr_rmtval_remove(args);
> -		if (error)
> -			return error;
> -	}
> -
> -	/*
> -	 * Read in the block containing the "old" attr, then remove the "old"
> -	 * attr from that block (neat, huh!)
> -	 */
> -	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> -				   &bp);
> -	if (error)
> -		return error;
> -
> -	xfs_attr3_leaf_remove(bp, args);
> -
> -	/*
> -	 * If the result is small enough, shrink it all into the inode.
> -	 */
> -	forkoff = xfs_attr_shortform_allfit(bp, dp);
> -	if (forkoff)
> -		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -		/* bp is gone due to xfs_da_shrink_inode */
> -
> -	return error;
> -}
> -
>  /*
>   * Return EEXIST if attr is found, or ENOATTR if not
>   */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 808ae33..3c1c830 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1914,7 +1914,6 @@ DEFINE_ATTR_EVENT(xfs_attr_leaf_add);
>  DEFINE_ATTR_EVENT(xfs_attr_leaf_add_old);
>  DEFINE_ATTR_EVENT(xfs_attr_leaf_add_new);
>  DEFINE_ATTR_EVENT(xfs_attr_leaf_add_work);
> -DEFINE_ATTR_EVENT(xfs_attr_leaf_addname);
>  DEFINE_ATTR_EVENT(xfs_attr_leaf_create);
>  DEFINE_ATTR_EVENT(xfs_attr_leaf_compact);
>  DEFINE_ATTR_EVENT(xfs_attr_leaf_get);
> -- 
> 2.7.4
> 

