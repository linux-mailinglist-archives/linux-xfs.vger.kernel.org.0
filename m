Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A1D237D4
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 15:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731800AbfETNOI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 09:14:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37452 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730458AbfETNOI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 09:14:08 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9F8F930842B5;
        Mon, 20 May 2019 13:14:07 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 33D6560F8D;
        Mon, 20 May 2019 13:14:07 +0000 (UTC)
Date:   Mon, 20 May 2019 09:14:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/20] xfs: merge xfs_trans_refcount.c into
 xfs_refcount_item.c
Message-ID: <20190520131405.GI31317@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-19-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-19-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 20 May 2019 13:14:07 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:17AM +0200, Christoph Hellwig wrote:
> Keep all the refcount item related code together in one file.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/Makefile             |   1 -
>  fs/xfs/xfs_refcount_item.c  | 208 ++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_trans.h          |  11 --
>  fs/xfs/xfs_trans_refcount.c | 224 ------------------------------------
>  4 files changed, 207 insertions(+), 237 deletions(-)
>  delete mode 100644 fs/xfs/xfs_trans_refcount.c
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 771a4738abd2..26f8c51d8803 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -107,7 +107,6 @@ xfs-y				+= xfs_log.o \
>  				   xfs_trans_bmap.o \
>  				   xfs_trans_buf.o \
>  				   xfs_trans_inode.o \
> -				   xfs_trans_refcount.o \
>  				   xfs_trans_rmap.o \
>  
>  # optional features
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 70dcdf40ac92..7bcc49ee5885 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -217,7 +217,7 @@ static const struct xfs_item_ops xfs_cud_item_ops = {
>  	.iop_release	= xfs_cud_item_release,
>  };
>  
> -struct xfs_cud_log_item *
> +static struct xfs_cud_log_item *
>  xfs_trans_get_cud(
>  	struct xfs_trans		*tp,
>  	struct xfs_cui_log_item		*cuip)
> @@ -234,6 +234,212 @@ xfs_trans_get_cud(
>  	return cudp;
>  }
>  
> +/*
> + * Finish an refcount update and log it to the CUD. Note that the
> + * transaction is marked dirty regardless of whether the refcount
> + * update succeeds or fails to support the CUI/CUD lifecycle rules.
> + */
> +static int
> +xfs_trans_log_finish_refcount_update(
> +	struct xfs_trans		*tp,
> +	struct xfs_cud_log_item		*cudp,
> +	enum xfs_refcount_intent_type	type,
> +	xfs_fsblock_t			startblock,
> +	xfs_extlen_t			blockcount,
> +	xfs_fsblock_t			*new_fsb,
> +	xfs_extlen_t			*new_len,
> +	struct xfs_btree_cur		**pcur)
> +{
> +	int				error;
> +
> +	error = xfs_refcount_finish_one(tp, type, startblock,
> +			blockcount, new_fsb, new_len, pcur);
> +
> +	/*
> +	 * Mark the transaction dirty, even on error. This ensures the
> +	 * transaction is aborted, which:
> +	 *
> +	 * 1.) releases the CUI and frees the CUD
> +	 * 2.) shuts down the filesystem
> +	 */
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
> +
> +	return error;
> +}
> +
> +/* Sort refcount intents by AG. */
> +static int
> +xfs_refcount_update_diff_items(
> +	void				*priv,
> +	struct list_head		*a,
> +	struct list_head		*b)
> +{
> +	struct xfs_mount		*mp = priv;
> +	struct xfs_refcount_intent	*ra;
> +	struct xfs_refcount_intent	*rb;
> +
> +	ra = container_of(a, struct xfs_refcount_intent, ri_list);
> +	rb = container_of(b, struct xfs_refcount_intent, ri_list);
> +	return  XFS_FSB_TO_AGNO(mp, ra->ri_startblock) -
> +		XFS_FSB_TO_AGNO(mp, rb->ri_startblock);
> +}
> +
> +/* Get an CUI. */
> +STATIC void *
> +xfs_refcount_update_create_intent(
> +	struct xfs_trans		*tp,
> +	unsigned int			count)
> +{
> +	struct xfs_cui_log_item		*cuip;
> +
> +	ASSERT(tp != NULL);
> +	ASSERT(count > 0);
> +
> +	cuip = xfs_cui_init(tp->t_mountp, count);
> +	ASSERT(cuip != NULL);
> +
> +	/*
> +	 * Get a log_item_desc to point at the new item.
> +	 */
> +	xfs_trans_add_item(tp, &cuip->cui_item);
> +	return cuip;
> +}
> +
> +/* Set the phys extent flags for this reverse mapping. */
> +static void
> +xfs_trans_set_refcount_flags(
> +	struct xfs_phys_extent		*refc,
> +	enum xfs_refcount_intent_type	type)
> +{
> +	refc->pe_flags = 0;
> +	switch (type) {
> +	case XFS_REFCOUNT_INCREASE:
> +	case XFS_REFCOUNT_DECREASE:
> +	case XFS_REFCOUNT_ALLOC_COW:
> +	case XFS_REFCOUNT_FREE_COW:
> +		refc->pe_flags |= type;
> +		break;
> +	default:
> +		ASSERT(0);
> +	}
> +}
> +
> +/* Log refcount updates in the intent item. */
> +STATIC void
> +xfs_refcount_update_log_item(
> +	struct xfs_trans		*tp,
> +	void				*intent,
> +	struct list_head		*item)
> +{
> +	struct xfs_cui_log_item		*cuip = intent;
> +	struct xfs_refcount_intent	*refc;
> +	uint				next_extent;
> +	struct xfs_phys_extent		*ext;
> +
> +	refc = container_of(item, struct xfs_refcount_intent, ri_list);
> +
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
> +
> +	/*
> +	 * atomic_inc_return gives us the value after the increment;
> +	 * we want to use it as an array index so we need to subtract 1 from
> +	 * it.
> +	 */
> +	next_extent = atomic_inc_return(&cuip->cui_next_extent) - 1;
> +	ASSERT(next_extent < cuip->cui_format.cui_nextents);
> +	ext = &cuip->cui_format.cui_extents[next_extent];
> +	ext->pe_startblock = refc->ri_startblock;
> +	ext->pe_len = refc->ri_blockcount;
> +	xfs_trans_set_refcount_flags(ext, refc->ri_type);
> +}
> +
> +/* Get an CUD so we can process all the deferred refcount updates. */
> +STATIC void *
> +xfs_refcount_update_create_done(
> +	struct xfs_trans		*tp,
> +	void				*intent,
> +	unsigned int			count)
> +{
> +	return xfs_trans_get_cud(tp, intent);
> +}
> +
> +/* Process a deferred refcount update. */
> +STATIC int
> +xfs_refcount_update_finish_item(
> +	struct xfs_trans		*tp,
> +	struct list_head		*item,
> +	void				*done_item,
> +	void				**state)
> +{
> +	struct xfs_refcount_intent	*refc;
> +	xfs_fsblock_t			new_fsb;
> +	xfs_extlen_t			new_aglen;
> +	int				error;
> +
> +	refc = container_of(item, struct xfs_refcount_intent, ri_list);
> +	error = xfs_trans_log_finish_refcount_update(tp, done_item,
> +			refc->ri_type,
> +			refc->ri_startblock,
> +			refc->ri_blockcount,
> +			&new_fsb, &new_aglen,
> +			(struct xfs_btree_cur **)state);
> +	/* Did we run out of reservation?  Requeue what we didn't finish. */
> +	if (!error && new_aglen > 0) {
> +		ASSERT(refc->ri_type == XFS_REFCOUNT_INCREASE ||
> +		       refc->ri_type == XFS_REFCOUNT_DECREASE);
> +		refc->ri_startblock = new_fsb;
> +		refc->ri_blockcount = new_aglen;
> +		return -EAGAIN;
> +	}
> +	kmem_free(refc);
> +	return error;
> +}
> +
> +/* Clean up after processing deferred refcounts. */
> +STATIC void
> +xfs_refcount_update_finish_cleanup(
> +	struct xfs_trans	*tp,
> +	void			*state,
> +	int			error)
> +{
> +	struct xfs_btree_cur	*rcur = state;
> +
> +	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> +}
> +
> +/* Abort all pending CUIs. */
> +STATIC void
> +xfs_refcount_update_abort_intent(
> +	void				*intent)
> +{
> +	xfs_cui_release(intent);
> +}
> +
> +/* Cancel a deferred refcount update. */
> +STATIC void
> +xfs_refcount_update_cancel_item(
> +	struct list_head		*item)
> +{
> +	struct xfs_refcount_intent	*refc;
> +
> +	refc = container_of(item, struct xfs_refcount_intent, ri_list);
> +	kmem_free(refc);
> +}
> +
> +const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
> +	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
> +	.diff_items	= xfs_refcount_update_diff_items,
> +	.create_intent	= xfs_refcount_update_create_intent,
> +	.abort_intent	= xfs_refcount_update_abort_intent,
> +	.log_item	= xfs_refcount_update_log_item,
> +	.create_done	= xfs_refcount_update_create_done,
> +	.finish_item	= xfs_refcount_update_finish_item,
> +	.finish_cleanup = xfs_refcount_update_finish_cleanup,
> +	.cancel_item	= xfs_refcount_update_cancel_item,
> +};
> +
>  /*
>   * Process a refcount update intent item that was recovered from the log.
>   * We need to update the refcountbt.
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index cc6549100176..1fe910d6da82 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -255,17 +255,6 @@ int xfs_trans_log_finish_rmap_update(struct xfs_trans *tp,
>  		xfs_fsblock_t startblock, xfs_filblks_t blockcount,
>  		xfs_exntst_t state, struct xfs_btree_cur **pcur);
>  
> -/* refcount updates */
> -enum xfs_refcount_intent_type;
> -
> -struct xfs_cud_log_item *xfs_trans_get_cud(struct xfs_trans *tp,
> -		struct xfs_cui_log_item *cuip);
> -int xfs_trans_log_finish_refcount_update(struct xfs_trans *tp,
> -		struct xfs_cud_log_item *cudp,
> -		enum xfs_refcount_intent_type type, xfs_fsblock_t startblock,
> -		xfs_extlen_t blockcount, xfs_fsblock_t *new_fsb,
> -		xfs_extlen_t *new_len, struct xfs_btree_cur **pcur);
> -
>  /* mapping updates */
>  enum xfs_bmap_intent_type;
>  
> diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
> deleted file mode 100644
> index d793fb500378..000000000000
> --- a/fs/xfs/xfs_trans_refcount.c
> +++ /dev/null
> @@ -1,224 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0+
> -/*
> - * Copyright (C) 2016 Oracle.  All Rights Reserved.
> - * Author: Darrick J. Wong <darrick.wong@oracle.com>
> - */
> -#include "xfs.h"
> -#include "xfs_fs.h"
> -#include "xfs_shared.h"
> -#include "xfs_format.h"
> -#include "xfs_log_format.h"
> -#include "xfs_trans_resv.h"
> -#include "xfs_mount.h"
> -#include "xfs_defer.h"
> -#include "xfs_trans.h"
> -#include "xfs_trans_priv.h"
> -#include "xfs_refcount_item.h"
> -#include "xfs_alloc.h"
> -#include "xfs_refcount.h"
> -
> -/*
> - * Finish an refcount update and log it to the CUD. Note that the
> - * transaction is marked dirty regardless of whether the refcount
> - * update succeeds or fails to support the CUI/CUD lifecycle rules.
> - */
> -int
> -xfs_trans_log_finish_refcount_update(
> -	struct xfs_trans		*tp,
> -	struct xfs_cud_log_item		*cudp,
> -	enum xfs_refcount_intent_type	type,
> -	xfs_fsblock_t			startblock,
> -	xfs_extlen_t			blockcount,
> -	xfs_fsblock_t			*new_fsb,
> -	xfs_extlen_t			*new_len,
> -	struct xfs_btree_cur		**pcur)
> -{
> -	int				error;
> -
> -	error = xfs_refcount_finish_one(tp, type, startblock,
> -			blockcount, new_fsb, new_len, pcur);
> -
> -	/*
> -	 * Mark the transaction dirty, even on error. This ensures the
> -	 * transaction is aborted, which:
> -	 *
> -	 * 1.) releases the CUI and frees the CUD
> -	 * 2.) shuts down the filesystem
> -	 */
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> -	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
> -
> -	return error;
> -}
> -
> -/* Sort refcount intents by AG. */
> -static int
> -xfs_refcount_update_diff_items(
> -	void				*priv,
> -	struct list_head		*a,
> -	struct list_head		*b)
> -{
> -	struct xfs_mount		*mp = priv;
> -	struct xfs_refcount_intent	*ra;
> -	struct xfs_refcount_intent	*rb;
> -
> -	ra = container_of(a, struct xfs_refcount_intent, ri_list);
> -	rb = container_of(b, struct xfs_refcount_intent, ri_list);
> -	return  XFS_FSB_TO_AGNO(mp, ra->ri_startblock) -
> -		XFS_FSB_TO_AGNO(mp, rb->ri_startblock);
> -}
> -
> -/* Get an CUI. */
> -STATIC void *
> -xfs_refcount_update_create_intent(
> -	struct xfs_trans		*tp,
> -	unsigned int			count)
> -{
> -	struct xfs_cui_log_item		*cuip;
> -
> -	ASSERT(tp != NULL);
> -	ASSERT(count > 0);
> -
> -	cuip = xfs_cui_init(tp->t_mountp, count);
> -	ASSERT(cuip != NULL);
> -
> -	/*
> -	 * Get a log_item_desc to point at the new item.
> -	 */
> -	xfs_trans_add_item(tp, &cuip->cui_item);
> -	return cuip;
> -}
> -
> -/* Set the phys extent flags for this reverse mapping. */
> -static void
> -xfs_trans_set_refcount_flags(
> -	struct xfs_phys_extent		*refc,
> -	enum xfs_refcount_intent_type	type)
> -{
> -	refc->pe_flags = 0;
> -	switch (type) {
> -	case XFS_REFCOUNT_INCREASE:
> -	case XFS_REFCOUNT_DECREASE:
> -	case XFS_REFCOUNT_ALLOC_COW:
> -	case XFS_REFCOUNT_FREE_COW:
> -		refc->pe_flags |= type;
> -		break;
> -	default:
> -		ASSERT(0);
> -	}
> -}
> -
> -/* Log refcount updates in the intent item. */
> -STATIC void
> -xfs_refcount_update_log_item(
> -	struct xfs_trans		*tp,
> -	void				*intent,
> -	struct list_head		*item)
> -{
> -	struct xfs_cui_log_item		*cuip = intent;
> -	struct xfs_refcount_intent	*refc;
> -	uint				next_extent;
> -	struct xfs_phys_extent		*ext;
> -
> -	refc = container_of(item, struct xfs_refcount_intent, ri_list);
> -
> -	tp->t_flags |= XFS_TRANS_DIRTY;
> -	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
> -
> -	/*
> -	 * atomic_inc_return gives us the value after the increment;
> -	 * we want to use it as an array index so we need to subtract 1 from
> -	 * it.
> -	 */
> -	next_extent = atomic_inc_return(&cuip->cui_next_extent) - 1;
> -	ASSERT(next_extent < cuip->cui_format.cui_nextents);
> -	ext = &cuip->cui_format.cui_extents[next_extent];
> -	ext->pe_startblock = refc->ri_startblock;
> -	ext->pe_len = refc->ri_blockcount;
> -	xfs_trans_set_refcount_flags(ext, refc->ri_type);
> -}
> -
> -/* Get an CUD so we can process all the deferred refcount updates. */
> -STATIC void *
> -xfs_refcount_update_create_done(
> -	struct xfs_trans		*tp,
> -	void				*intent,
> -	unsigned int			count)
> -{
> -	return xfs_trans_get_cud(tp, intent);
> -}
> -
> -/* Process a deferred refcount update. */
> -STATIC int
> -xfs_refcount_update_finish_item(
> -	struct xfs_trans		*tp,
> -	struct list_head		*item,
> -	void				*done_item,
> -	void				**state)
> -{
> -	struct xfs_refcount_intent	*refc;
> -	xfs_fsblock_t			new_fsb;
> -	xfs_extlen_t			new_aglen;
> -	int				error;
> -
> -	refc = container_of(item, struct xfs_refcount_intent, ri_list);
> -	error = xfs_trans_log_finish_refcount_update(tp, done_item,
> -			refc->ri_type,
> -			refc->ri_startblock,
> -			refc->ri_blockcount,
> -			&new_fsb, &new_aglen,
> -			(struct xfs_btree_cur **)state);
> -	/* Did we run out of reservation?  Requeue what we didn't finish. */
> -	if (!error && new_aglen > 0) {
> -		ASSERT(refc->ri_type == XFS_REFCOUNT_INCREASE ||
> -		       refc->ri_type == XFS_REFCOUNT_DECREASE);
> -		refc->ri_startblock = new_fsb;
> -		refc->ri_blockcount = new_aglen;
> -		return -EAGAIN;
> -	}
> -	kmem_free(refc);
> -	return error;
> -}
> -
> -/* Clean up after processing deferred refcounts. */
> -STATIC void
> -xfs_refcount_update_finish_cleanup(
> -	struct xfs_trans	*tp,
> -	void			*state,
> -	int			error)
> -{
> -	struct xfs_btree_cur	*rcur = state;
> -
> -	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> -}
> -
> -/* Abort all pending CUIs. */
> -STATIC void
> -xfs_refcount_update_abort_intent(
> -	void				*intent)
> -{
> -	xfs_cui_release(intent);
> -}
> -
> -/* Cancel a deferred refcount update. */
> -STATIC void
> -xfs_refcount_update_cancel_item(
> -	struct list_head		*item)
> -{
> -	struct xfs_refcount_intent	*refc;
> -
> -	refc = container_of(item, struct xfs_refcount_intent, ri_list);
> -	kmem_free(refc);
> -}
> -
> -const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
> -	.max_items	= XFS_CUI_MAX_FAST_EXTENTS,
> -	.diff_items	= xfs_refcount_update_diff_items,
> -	.create_intent	= xfs_refcount_update_create_intent,
> -	.abort_intent	= xfs_refcount_update_abort_intent,
> -	.log_item	= xfs_refcount_update_log_item,
> -	.create_done	= xfs_refcount_update_create_done,
> -	.finish_item	= xfs_refcount_update_finish_item,
> -	.finish_cleanup = xfs_refcount_update_finish_cleanup,
> -	.cancel_item	= xfs_refcount_update_cancel_item,
> -};
> -- 
> 2.20.1
> 
