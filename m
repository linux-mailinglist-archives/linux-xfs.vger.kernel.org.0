Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7D0560BA9
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jun 2022 23:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiF2VVf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jun 2022 17:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiF2VVe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 17:21:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E79B1582C
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 14:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29FECB8275A
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 21:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAADAC34114;
        Wed, 29 Jun 2022 21:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656537690;
        bh=YApp01kNf+sXQ8ZsqSPvLqxMbkN8YcdnricciTHLuQM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hJB8Ulhuwq9soduIP3ZCjG4eZm2U4he+Ybblofxyk3Sxzj4sx1gHmHKaccgiUb3Ob
         1CKq5Y+VWBXtnKqdsD29HtlSnUgoX5qIGyCwgy784G72JILH9JQ53I5DGqN0fmj6fZ
         H/XRvFu1MkUhpNnfD1USdtA8gx3ghbKKFgFXyVYH6jipP/x4paPAReUPQV4lKRXVMf
         ILFE0OEjohvf6U+g4FEdRlnKs2F0cjgS6ARqEJhjQMxtey00+R5mg8Cs/Qnn9C32jU
         A3V6FFR2mEut/fsdpeDMlQJ1m+1+zGeWI4TzONFEhedakM4wgAvH/S3yDQKS3KmqVb
         3CEDV8dWynfhw==
Date:   Wed, 29 Jun 2022 14:21:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: add in-memory iunlink log item
Message-ID: <YrzCWswNIPu0jmrG@magnolia>
References: <20220627004336.217366-1-david@fromorbit.com>
 <20220627004336.217366-10-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627004336.217366-10-david@fromorbit.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 10:43:36AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have a clean operation to update the di_next_unlinked
> field of inode cluster buffers, we can easily defer this operation
> to transaction commit time so we can order the inode cluster buffer
> locking consistently.
> 
> TO do this, we introduce a new in-memory log item to track the
> unlinked list item modification that we are going to make. This
> follows the same observations as the in-memory double linked list
> used to track unlinked inodes in that the inodes on the list are
> pinned in memory and cannot go away, and hence we can simply
> reference them for the duration of the transaction without needing
> to take active references or pin them or look them up.
> 
> This allows us to pass the xfs_inode to the transaction commit code
> along with the modification to be made, and then order the logged
> modifications via the ->iop_sort and ->iop_precommit operations
> for the new log item type. As this is an in-memory log item, it
> doesn't have formatting, CIL or AIL operational hooks - it exists
> purely to run the inode unlink modifications and is then removed
> from the transaction item list and freed once the precommit
> operation has run.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/Makefile           |   1 +
>  fs/xfs/xfs_inode.c        |  64 +-------------
>  fs/xfs/xfs_iunlink_item.c | 180 ++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iunlink_item.h |  27 ++++++
>  fs/xfs/xfs_super.c        |  10 +++
>  5 files changed, 219 insertions(+), 63 deletions(-)
>  create mode 100644 fs/xfs/xfs_iunlink_item.c
>  create mode 100644 fs/xfs/xfs_iunlink_item.h
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index b056cfc6398e..1131dd01e4fe 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -106,6 +106,7 @@ xfs-y				+= xfs_log.o \
>  				   xfs_icreate_item.o \
>  				   xfs_inode_item.o \
>  				   xfs_inode_item_recover.o \
> +				   xfs_iunlink_item.o \
>  				   xfs_refcount_item.o \
>  				   xfs_rmap_item.o \
>  				   xfs_log_recover.o \
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index d6c88a27f29d..ef1dae9dbaa4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -20,6 +20,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_inode_item.h"
> +#include "xfs_iunlink_item.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_bmap_util.h"
> @@ -1923,69 +1924,6 @@ xfs_iunlink_update_bucket(
>  	return 0;
>  }
>  
> -/* Set an in-core inode's unlinked pointer and return the old value. */
> -static int
> -xfs_iunlink_log_inode(
> -	struct xfs_trans	*tp,
> -	struct xfs_inode	*ip,
> -	struct xfs_perag	*pag,
> -	xfs_agino_t		next_agino)
> -{
> -	struct xfs_mount	*mp = tp->t_mountp;
> -	struct xfs_dinode	*dip;
> -	struct xfs_buf		*ibp;
> -	xfs_agino_t		old_value;
> -	int			offset;
> -	int			error;
> -
> -	ASSERT(xfs_verify_agino_or_null(mp, pag->pag_agno, next_agino));
> -
> -	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
> -	if (error)
> -		return error;
> -	dip = xfs_buf_offset(ibp, ip->i_imap.im_boffset);
> -
> -	/* Make sure the old pointer isn't garbage. */
> -	old_value = be32_to_cpu(dip->di_next_unlinked);
> -	if (old_value != ip->i_next_unlinked ||
> -	    !xfs_verify_agino_or_null(mp, pag->pag_agno, old_value)) {
> -		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> -				sizeof(*dip), __this_address);
> -		error = -EFSCORRUPTED;
> -		goto out;
> -	}
> -
> -	/*
> -	 * Since we're updating a linked list, we should never find that the
> -	 * current pointer is the same as the new value, unless we're
> -	 * terminating the list.
> -	 */
> -	if (old_value == next_agino) {
> -		if (next_agino != NULLAGINO) {
> -			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
> -					dip, sizeof(*dip), __this_address);
> -			error = -EFSCORRUPTED;
> -		}
> -		goto out;
> -	}
> -
> -	trace_xfs_iunlink_update_dinode(mp, pag->pag_agno,
> -			XFS_INO_TO_AGINO(mp, ip->i_ino),
> -			be32_to_cpu(dip->di_next_unlinked), next_agino);
> -
> -	dip->di_next_unlinked = cpu_to_be32(next_agino);
> -	offset = ip->i_imap.im_boffset +
> -			offsetof(struct xfs_dinode, di_next_unlinked);
> -
> -	xfs_dinode_calc_crc(mp, dip);
> -	xfs_trans_inode_buf(tp, ibp);
> -	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
> -	return 0;
> -out:
> -	xfs_trans_brelse(tp, ibp);
> -	return error;
> -}
> -
>  static int
>  xfs_iunlink_insert_inode(
>  	struct xfs_trans	*tp,
> diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
> new file mode 100644
> index 000000000000..fe38fc61f79e
> --- /dev/null
> +++ b/fs/xfs/xfs_iunlink_item.c
> @@ -0,0 +1,180 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2020, Red Hat, Inc.

2022?

> + * All Rights Reserved.
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_trans.h"
> +#include "xfs_trans_priv.h"
> +#include "xfs_ag.h"
> +#include "xfs_iunlink_item.h"
> +#include "xfs_trace.h"
> +#include "xfs_error.h"
> +
> +struct kmem_cache	*xfs_iunlink_cache;
> +
> +static inline struct xfs_iunlink_item *IUL_ITEM(struct xfs_log_item *lip)
> +{
> +	return container_of(lip, struct xfs_iunlink_item, item);
> +}
> +
> +static void
> +xfs_iunlink_item_release(
> +	struct xfs_log_item	*lip)
> +{
> +	struct xfs_iunlink_item	*iup = IUL_ITEM(lip);
> +
> +	xfs_perag_put(iup->pag);
> +	kmem_cache_free(xfs_iunlink_cache, IUL_ITEM(lip));
> +}
> +
> +
> +static uint64_t
> +xfs_iunlink_item_sort(
> +	struct xfs_log_item	*lip)
> +{
> +	return IUL_ITEM(lip)->ip->i_ino;
> +}

Since you mentioned in-memory log items for dquots -- how should
iunlinks and dquot log items be sorted?

(On the off chance the dquot comment was made off the cuff and you don't
have a patchset ready to go in your dev tree -- I probably wouldn't have
said anything if this looked like the usual comparator function.)

> +
> +/*
> + * Look up the inode cluster buffer and log the on-disk unlinked inode change
> + * we need to make.
> + */
> +static int
> +xfs_iunlink_log_dinode(
> +	struct xfs_trans	*tp,
> +	struct xfs_iunlink_item	*iup)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_inode	*ip = iup->ip;
> +	struct xfs_dinode	*dip;
> +	struct xfs_buf		*ibp;
> +	int			offset;
> +	int			error;
> +
> +	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
> +	if (error)
> +		return error;
> +	/*
> +	 * Don't log the unlinked field on stale buffers as this may be the
> +	 * transaction that frees the inode cluster and relogging the buffer
> +	 * here will incorrectly remove the stale state.
> +	 */
> +	if (ibp->b_flags & XBF_STALE)
> +		goto out;
> +
> +	dip = xfs_buf_offset(ibp, ip->i_imap.im_boffset);
> +
> +	/* Make sure the old pointer isn't garbage. */
> +	if (be32_to_cpu(dip->di_next_unlinked) != iup->old_agino) {
> +		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
> +				sizeof(*dip), __this_address);
> +		error = -EFSCORRUPTED;
> +		goto out;
> +	}
> +
> +	trace_xfs_iunlink_update_dinode(mp, iup->pag->pag_agno,
> +			XFS_INO_TO_AGINO(mp, ip->i_ino),
> +			be32_to_cpu(dip->di_next_unlinked), iup->next_agino);
> +
> +	dip->di_next_unlinked = cpu_to_be32(iup->next_agino);
> +	offset = ip->i_imap.im_boffset +
> +			offsetof(struct xfs_dinode, di_next_unlinked);
> +
> +	xfs_dinode_calc_crc(mp, dip);
> +	xfs_trans_inode_buf(tp, ibp);
> +	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
> +	return 0;
> +out:
> +	xfs_trans_brelse(tp, ibp);
> +	return error;
> +}
> +
> +/*
> + * On precommit, we grab the inode cluster buffer for the inode number we were
> + * passed, then update the next unlinked field for that inode in the buffer and
> + * log the buffer. This ensures that the inode cluster buffer was logged in the
> + * correct order w.r.t. other inode cluster buffers. We can then remove the
> + * iunlink item from the transaction and release it as it is has now served it's
> + * purpose.
> + */
> +static int
> +xfs_iunlink_item_precommit(
> +	struct xfs_trans	*tp,
> +	struct xfs_log_item	*lip)
> +{
> +	struct xfs_iunlink_item	*iup = IUL_ITEM(lip);
> +	int			error;
> +
> +	error = xfs_iunlink_log_dinode(tp, iup);

Hmm, so does this imply that log items can create new log items now?

(I /think/ this all looks ok.)

--D

> +	list_del(&lip->li_trans);
> +	xfs_iunlink_item_release(lip);
> +	return error;
> +}
> +
> +static const struct xfs_item_ops xfs_iunlink_item_ops = {
> +	.iop_release	= xfs_iunlink_item_release,
> +	.iop_sort	= xfs_iunlink_item_sort,
> +	.iop_precommit	= xfs_iunlink_item_precommit,
> +};
> +
> +
> +/*
> + * Initialize the inode log item for a newly allocated (in-core) inode.
> + *
> + * Inode extents can only reside within an AG. Hence specify the starting
> + * block for the inode chunk by offset within an AG as well as the
> + * length of the allocated extent.
> + *
> + * This joins the item to the transaction and marks it dirty so
> + * that we don't need a separate call to do this, nor does the
> + * caller need to know anything about the iunlink item.
> + */
> +int
> +xfs_iunlink_log_inode(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	struct xfs_perag	*pag,
> +	xfs_agino_t		next_agino)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_iunlink_item	*iup;
> +
> +	ASSERT(xfs_verify_agino_or_null(mp, pag->pag_agno, next_agino));
> +	ASSERT(xfs_verify_agino_or_null(mp, pag->pag_agno, ip->i_next_unlinked));
> +
> +	/*
> +	 * Since we're updating a linked list, we should never find that the
> +	 * current pointer is the same as the new value, unless we're
> +	 * terminating the list.
> +	 */
> +	if (ip->i_next_unlinked == next_agino) {
> +		if (next_agino != NULLAGINO)
> +			return -EFSCORRUPTED;
> +		return 0;
> +	}
> +
> +	iup = kmem_cache_zalloc(xfs_iunlink_cache, GFP_KERNEL | __GFP_NOFAIL);
> +	xfs_log_item_init(mp, &iup->item, XFS_LI_IUNLINK,
> +			  &xfs_iunlink_item_ops);
> +
> +	iup->ip = ip;
> +	iup->next_agino = next_agino;
> +	iup->old_agino = ip->i_next_unlinked;
> +
> +	atomic_inc(&pag->pag_ref);
> +	iup->pag = pag;
> +
> +	xfs_trans_add_item(tp, &iup->item);
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &iup->item.li_flags);
> +	return 0;
> +}
> +
> diff --git a/fs/xfs/xfs_iunlink_item.h b/fs/xfs/xfs_iunlink_item.h
> new file mode 100644
> index 000000000000..280dbf533989
> --- /dev/null
> +++ b/fs/xfs/xfs_iunlink_item.h
> @@ -0,0 +1,27 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2020, Red Hat, Inc.
> + * All Rights Reserved.
> + */
> +#ifndef XFS_IUNLINK_ITEM_H
> +#define XFS_IUNLINK_ITEM_H	1
> +
> +struct xfs_trans;
> +struct xfs_inode;
> +struct xfs_perag;
> +
> +/* in memory log item structure */
> +struct xfs_iunlink_item {
> +	struct xfs_log_item	item;
> +	struct xfs_inode	*ip;
> +	struct xfs_perag	*pag;
> +	xfs_agino_t		next_agino;
> +	xfs_agino_t		old_agino;
> +};
> +
> +extern struct kmem_cache *xfs_iunlink_cache;
> +
> +int xfs_iunlink_log_inode(struct xfs_trans *tp, struct xfs_inode *ip,
> +			struct xfs_perag *pag, xfs_agino_t next_agino);
> +
> +#endif	/* XFS_IUNLINK_ITEM_H */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ed18160e6181..a7e6b2d7686b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -40,6 +40,7 @@
>  #include "xfs_defer.h"
>  #include "xfs_attr_item.h"
>  #include "xfs_xattr.h"
> +#include "xfs_iunlink_item.h"
>  
>  #include <linux/magic.h>
>  #include <linux/fs_context.h>
> @@ -2093,8 +2094,16 @@ xfs_init_caches(void)
>  	if (!xfs_attri_cache)
>  		goto out_destroy_attrd_cache;
>  
> +	xfs_iunlink_cache = kmem_cache_create("xfs_iul_item",
> +					     sizeof(struct xfs_iunlink_item),
> +					     0, 0, NULL);
> +	if (!xfs_iunlink_cache)
> +		goto out_destroy_attri_cache;
> +
>  	return 0;
>  
> + out_destroy_attri_cache:
> +	kmem_cache_destroy(xfs_attri_cache);
>   out_destroy_attrd_cache:
>  	kmem_cache_destroy(xfs_attrd_cache);
>   out_destroy_bui_cache:
> @@ -2145,6 +2154,7 @@ xfs_destroy_caches(void)
>  	 * destroy caches.
>  	 */
>  	rcu_barrier();
> +	kmem_cache_destroy(xfs_iunlink_cache);
>  	kmem_cache_destroy(xfs_attri_cache);
>  	kmem_cache_destroy(xfs_attrd_cache);
>  	kmem_cache_destroy(xfs_bui_cache);
> -- 
> 2.36.1
> 
