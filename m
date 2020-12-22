Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3D22E0E61
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Dec 2020 19:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgLVSq2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 22 Dec 2020 13:46:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726039AbgLVSq1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Dec 2020 13:46:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608662700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Aws+pE0uair5NYKDh/vtGmXlfWAVx9+DSfKyBI2Sy6E=;
        b=Omsm1F+3NBXfEagqoe+wGqUxzuhf5/ZW1NbniSm+TgR8ON0jO5XrJXobuvEHSYPFQsCw7j
        +4rCbY4Fdfp/D3gReui2zzUjc71qInmdELfdfBDltZ5xTfjPJeQeOm0uXbwQxPD777Vcb5
        4wVrbr1oPv/EH4qKyqWMESzAMvoCSiA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-4S1R3uiCM_Csr6Fgwk-iRA-1; Tue, 22 Dec 2020 13:44:55 -0500
X-MC-Unique: 4S1R3uiCM_Csr6Fgwk-iRA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29B13107ACF9;
        Tue, 22 Dec 2020 18:44:54 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B0CF06F445;
        Tue, 22 Dec 2020 18:44:53 +0000 (UTC)
Date:   Tue, 22 Dec 2020 13:44:51 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v14 04/15] xfs: Add delay ready attr remove routines
Message-ID: <20201222184451.GE2808393@bfoster>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-5-allison.henderson@oracle.com>
 <20201222171148.GC2808393@bfoster>
 <20201222172020.GD2808393@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222172020.GD2808393@bfoster>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 22, 2020 at 12:20:20PM -0500, Brian Foster wrote:
> On Tue, Dec 22, 2020 at 12:11:48PM -0500, Brian Foster wrote:
> > On Fri, Dec 18, 2020 at 12:29:06AM -0700, Allison Henderson wrote:
> > > This patch modifies the attr remove routines to be delay ready. This
> > > means they no longer roll or commit transactions, but instead return
> > > -EAGAIN to have the calling routine roll and refresh the transaction. In
> > > this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
> > > uses a sort of state machine like switch to keep track of where it was
> > > when EAGAIN was returned. xfs_attr_node_removename has also been
> > > modified to use the switch, and a new version of xfs_attr_remove_args
> > > consists of a simple loop to refresh the transaction until the operation
> > > is completed. A new XFS_DAC_DEFER_FINISH flag is used to finish the
> > > transaction where ever the existing code used to.
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
> > > ---
> > 
> > I started with a couple small comments on this patch but inevitably
> > started thinking more about the factoring again and ended up with a
> > couple patches on top. The first is more of some small tweaks and
> > open-coding that IMO makes this patch a bit easier to follow. The
> > second is more of an RFC so I'll follow up with that in a second email.
> > I'm curious what folks' thoughts might be on either. Also note that I'm
> > primarily focusing on code structure and whatnot here, so these are fast
> > and loose, compile tested only and likely to be broken.
> > 
> 
> ... and here's the second diff (applies on top of the first).
> 
> This one popped up after staring at the previous changes for a bit and
> wondering whether using "done flags" might make the whole thing easier
> to follow than incremental state transitions. I think the attr remove
> path is easy enough to follow with either method, but the attr set path
> is a beast and so this is more with that in mind. Initial thoughts?
> 

Eh, the more I stare at the attr set code I'm not sure this by itself is
much of an improvement. It helps in some areas, but there are so many
transaction rolls embedded throughout at different levels that a larger
rework of the code is probably still necessary. Anyways, this was just a
random thought for now..

Brian

> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 2e466c4ac283..106e3c070131 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1271,14 +1271,12 @@ int xfs_attr_node_removename_setup(
>   * successful error code is returned.
>   */
>  STATIC int
> -xfs_attr_node_remove_step(
> -	struct xfs_delattr_context	*dac,
> -	bool				*joined)
> +xfs_attr_node_remove_rmt_step(
> +	struct xfs_delattr_context	*dac)
>  {
>  	struct xfs_da_args		*args = dac->da_args;
>  	struct xfs_da_state		*state = dac->da_state;
> -	struct xfs_da_state_blk		*blk;
> -	int				error = 0, retval, done;
> +	int				error, done;
>  
>  	/*
>  	 * If there is an out-of-line value, de-allocate the blocks.  This is
> @@ -1300,6 +1298,19 @@ xfs_attr_node_remove_step(
>  			return error;
>  	}
>  
> +	dac->dela_state |= XFS_DAS_RMT_DONE;
> +	return error;
> +}
> +
> +STATIC int
> +xfs_attr_node_remove_join_step(
> +	struct xfs_delattr_context	*dac)
> +{
> +	struct xfs_da_args		*args = dac->da_args;
> +	struct xfs_da_state		*state = dac->da_state;
> +	struct xfs_da_state_blk		*blk;
> +	int				error, retval;
> +
>  	/*
>  	 * Remove the name and update the hashvals in the tree.
>  	 */
> @@ -1317,9 +1328,12 @@ xfs_attr_node_remove_step(
>  		error = xfs_da3_join(state);
>  		if (error)
>  			return error;
> -		*joined = true;
> +
> +		error = -EAGAIN;
> +		dac->flags |= XFS_DAC_DEFER_FINISH;
>  	}
>  
> +	dac->dela_state |= XFS_DAS_JOIN_DONE;
>  	return error;
>  }
>  
> @@ -1342,36 +1356,23 @@ xfs_attr_node_removename_iter(
>  	struct xfs_da_state		*state = dac->da_state;
>  	int				error;
>  	struct xfs_inode		*dp = args->dp;
> -	bool				joined = false;
>  
> -	switch (dac->dela_state) {
> -	case XFS_DAS_UNINIT:
> -		/*
> -		 * repeatedly remove remote blocks, remove the entry and join.
> -		 * returns -EAGAIN or 0 for completion of the step.
> -		 */
> -		error = xfs_attr_node_remove_step(dac, &joined);
> +	if (!(dac->dela_state & XFS_DAS_RMT_DONE)) {
> +		error = xfs_attr_node_remove_rmt_step(dac);
>  		if (error)
>  			goto out;
> -		if (joined) {
> -			dac->flags |= XFS_DAC_DEFER_FINISH;
> -			dac->dela_state = XFS_DAS_RM_SHRINK;
> -			return -EAGAIN;
> -		}
> -		/* fallthrough */
> -	case XFS_DAS_RM_SHRINK:
> -		/*
> -		 * If the result is small enough, push it all into the inode.
> -		 */
> -		if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> -			error = xfs_attr_node_shrink(args, state);
> -		break;
> -	default:
> -		ASSERT(0);
> -		error = -EINVAL;
> -		goto out;
>  	}
>  
> +	if (!(dac->dela_state & XFS_DAS_JOIN_DONE)) {
> +		error = xfs_attr_node_remove_join_step(dac);
> +		if (error)
> +			goto out;
> +	}
> +
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +		error = xfs_attr_node_shrink(args, state);
> +	ASSERT(error != -EAGAIN);
> +
>  out:
>  	if (state && error != -EAGAIN)
>  		xfs_da_state_free(state);
> diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
> index 3154ef4b7833..67e730cd3267 100644
> --- a/fs/xfs/libxfs/xfs_attr.h
> +++ b/fs/xfs/libxfs/xfs_attr.h
> @@ -151,6 +151,9 @@ enum xfs_delattr_state {
>  	XFS_DAS_RM_SHRINK,	      /* We are shrinking the tree */
>  };
>  
> +#define XFS_DAS_RMT_DONE	0x1
> +#define XFS_DAS_JOIN_DONE	0x2
> +
>  /*
>   * Defines for xfs_delattr_context.flags
>   */
> 

