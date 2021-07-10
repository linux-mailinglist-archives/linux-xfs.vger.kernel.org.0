Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441243C2C49
	for <lists+linux-xfs@lfdr.de>; Sat, 10 Jul 2021 03:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhGJBLe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Jul 2021 21:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhGJBLe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Jul 2021 21:11:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E31FD613BF;
        Sat, 10 Jul 2021 01:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625879330;
        bh=xz9cQPMAJmCvbN0Iq7v1jF9chiaEQLsXMOODAY1INBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uj5LTQ3dbXROnpMRMykTCr3e3uNV32FYGXvnlMdVlXjPeCuZO6mSVwwV94XTqvzj7
         fljbpKl02SSRMWtw546XTAr4e+Jqg06ANNa+3BdTpeH77P99oeWYhWNfK1xVFrIMsK
         JdgM95ZsWvm/Nle8MKWJGAnuyEY07IcFf45P9eh0++MG+ez8GiYdjzUQB/aqgVAqII
         evhqz/1XDOvxcx720W0k9fD1tSSFF2Wh2u+xuQ5oi2tLPPuzK5IKxCvRG4jteDaGaD
         988FcvXNng3UZKJ8tWjpbzQ2YkUrqzW3nHh/lluKm/4uKEFgmeOHbks6r8bMSB0f0T
         /C2QYmIx4Ds4Q==
Date:   Fri, 9 Jul 2021 18:08:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v21 06/13] xfs: Implement attr logging and replay
Message-ID: <20210710010849.GF11634@locust>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
 <20210707222111.16339-7-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707222111.16339-7-allison.henderson@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 07, 2021 at 03:21:04PM -0700, Allison Henderson wrote:
> This patch adds the needed routines to create, log and replay attr
> intents

I might call that last part "...and recover logged extended attribute
intents."

> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c  |   1 +
>  fs/xfs/libxfs/xfs_defer.h  |   1 +
>  fs/xfs/libxfs/xfs_format.h |   4 +-
>  fs/xfs/xfs_attr_item.c     | 394 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 399 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index eff4a12..e9caff7 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -178,6 +178,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
>  	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
>  	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
>  	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
> +	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
>  };
>  
>  static void
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 0ed9dfa..72a5789 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -19,6 +19,7 @@ enum xfs_defer_ops_type {
>  	XFS_DEFER_OPS_TYPE_RMAP,
>  	XFS_DEFER_OPS_TYPE_FREE,
>  	XFS_DEFER_OPS_TYPE_AGFL_FREE,
> +	XFS_DEFER_OPS_TYPE_ATTR,
>  	XFS_DEFER_OPS_TYPE_MAX,
>  };
>  
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 3a4da111..477e815 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -485,7 +485,9 @@ xfs_sb_has_incompat_feature(
>  	return (sbp->sb_features_incompat & feature) != 0;
>  }
>  
> -#define XFS_SB_FEAT_INCOMPAT_LOG_ALL 0
> +#define XFS_SB_FEAT_INCOMPAT_LOG_DELATTR   (1 << 0)	/* Delayed Attributes */
> +#define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
> +	(XFS_SB_FEAT_INCOMPAT_LOG_DELATTR)
>  #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
>  static inline bool
>  xfs_sb_has_incompat_log_feature(
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index c9033e2..eda6ae3 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -282,6 +282,183 @@ xfs_attrd_item_release(
>  	xfs_attrd_item_free(attrdp);
>  }
>  
> +/*
> + * Performs one step of an attribute update intent and marks the attrd item
> + * dirty..  An attr operation may be a set or a remove.  Note that the
> + * transaction is marked dirty regardless of whether the operation succeeds or
> + * fails to support the ATTRI/ATTRD lifecycle rules.
> + */
> +int
> +xfs_trans_attr_finish_update(
> +	struct xfs_delattr_context	*dac,
> +	struct xfs_attrd_log_item	*attrdp,
> +	struct xfs_buf			**leaf_bp,
> +	uint32_t			op_flags)
> +{
> +	struct xfs_da_args		*args = dac->da_args;
> +	int				error;
> +
> +	error = xfs_qm_dqattach_locked(args->dp, 0);

Hmm, this function is called at runtime and recovery time.  It's
/really/ late to be attaching dquots.

OH, this is for the recovery case, isn't it?

Hmm, xfs_attri_item_recover really ought to share the same
iget/dqattach/set-irecovery thing that bmap and swapext use.  I should
really post that cleanup as a patch.

> +	if (error)
> +		return error;
> +
> +	switch (op_flags) {

op_flags ought to be masked with XFS_ATTR_OP_FLAGS_TYPE_MASK.

> +	case XFS_ATTR_OP_FLAGS_SET:
> +		args->op_flags |= XFS_DA_OP_ADDNAME;
> +		error = xfs_attr_set_iter(dac, leaf_bp);
> +		break;
> +	case XFS_ATTR_OP_FLAGS_REMOVE:
> +		ASSERT(XFS_IFORK_Q(args->dp));
> +		error = xfs_attr_remove_iter(dac);
> +		break;
> +	default:
> +		error = -EFSCORRUPTED;
> +		break;
> +	}
> +
> +	/*
> +	 * Mark the transaction dirty, even on error. This ensures the
> +	 * transaction is aborted, which:
> +	 *
> +	 * 1.) releases the ATTRI and frees the ATTRD
> +	 * 2.) shuts down the filesystem
> +	 */
> +	args->trans->t_flags |= XFS_TRANS_DIRTY;
> +
> +	/*
> +	 * attr intent/done items are null when delayed attributes are disabled
> +	 */
> +	if (attrdp)
> +		set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
> +
> +	return error;
> +}
> +
> +/* Log an attr to the intent item. */
> +STATIC void
> +xfs_attr_log_item(
> +	struct xfs_trans		*tp,
> +	struct xfs_attri_log_item	*attrip,
> +	struct xfs_attr_item		*attr)
> +{
> +	struct xfs_attri_log_format	*attrp;
> +
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	set_bit(XFS_LI_DIRTY, &attrip->attri_item.li_flags);
> +
> +	/*
> +	 * At this point the xfs_attr_item has been constructed, and we've
> +	 * created the log intent. Fill in the attri log item and log format
> +	 * structure with fields from this xfs_attr_item
> +	 */
> +	attrp = &attrip->attri_format;
> +	attrp->alfi_ino = attr->xattri_dac.da_args->dp->i_ino;
> +	attrp->alfi_op_flags = attr->xattri_op_flags;
> +	attrp->alfi_value_len = attr->xattri_dac.da_args->valuelen;
> +	attrp->alfi_name_len = attr->xattri_dac.da_args->namelen;
> +	attrp->alfi_attr_flags = attr->xattri_dac.da_args->attr_filter;
> +
> +	attrip->attri_name = (void *)attr->xattri_dac.da_args->name;
> +	attrip->attri_value = attr->xattri_dac.da_args->value;
> +	attrip->attri_name_len = attr->xattri_dac.da_args->namelen;
> +	attrip->attri_value_len = attr->xattri_dac.da_args->valuelen;
> +}
> +
> +/* Get an ATTRI. */
> +static struct xfs_log_item *
> +xfs_attr_create_intent(
> +	struct xfs_trans		*tp,
> +	struct list_head		*items,
> +	unsigned int			count,
> +	bool				sort)
> +{
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	struct xfs_attri_log_item	*attrip;
> +	struct xfs_attr_item		*attr;
> +
> +	ASSERT(count == 1);
> +
> +	if (!xfs_hasdelattr(mp))
> +		return NULL;
> +
> +	xfs_sb_add_incompat_log_features(&mp->m_sb,
> +					 XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);

Um, I think I see a bug here--

I don't see anything in this series that calls xfs_add_incompat_log_feature.

Adding a log incompat feature on a filesystem is a tricky dance, because
one has to write the primary superblock (which means logging the sb
change, forcing the log, and pushing the AIL) /before/ logging the intent.

All this is to prevent an old kernel from tripping over a logged item
that it doesn't understand, because an earlier recovered transaction
contained the bit it needed to conclude that it shouldn't have tried to
recover.


/*
 * Get permission to use log-assisted atomic exchange of file extents.
 *
 * Callers must not be running any transactions or hold any inode locks, and
 * they must release the permission by calling xlog_drop_incompat_feat
 * when they're done.
 */
int
xfs_attr_use_log_assist(
	struct xfs_mount	*mp)
{
	int			error = 0;

	/*
	 * Protect ourselves from an idle log clearing the logged xattrs
	 * log incompat feature bit.
	 */
	xlog_use_incompat_feat(mp->m_log);

	/*
	 * If log-assisted xattrs are already enabled, the caller can use the
	 * log assisted swap functions with the log-incompat reference we got.
	 */
	if (xfs_sb_version_hasdelattr(&mp->m_sb))
		return 0;

	/* Enable log-assisted xattrs. */
	xfs_warn_once(mp,
 "EXPERIMENTAL logged extended attributes feature added. Use at your own risk!");
	error = xfs_add_incompat_log_feature(mp,
			XFS_SB_FEAT_INCOMPAT_LOG_DELATTR);
	if (error)
		goto drop_incompat;

	return 0;
drop_incompat:
	xlog_drop_incompat_feat(mp->m_log);
	return error;
}

...and then in xfs_attr_set, you need something like:

	/* Signal the log that we want to use logged xattrs. */
	use_log_items = xfs_hasdelattr(mp);
	if (use_log_items) {
		error = xfs_attr_use_log_assist(mp);
		if (error)
			goto barf;
	}

	error = xfs_trans_alloc(..., &tp);

	if (valuelen > 0)
		error = xfs_attr_set_args(...);
	else
		error = xfs_attr_remove_args(...);

	error = xfs_trans_commit(...);

	/* Signal the log that we're done with using logged xattrs. */
	if (use_log_items)
		xlog_drop_incompat_feat(mp->m_log);

The xfs_add_incompat_log_feature function ensures that the log has been
pushed out to disk and that the ondisk primary superblock has been
written (manually!) with the new incompat feature set.  The
xlog_use_incompat_feat prevents the log from clearing the feature bit
until we're done using it.

Once xfs_attr_use_log_assist completes, we know that it is safe to begin
using deferred xattrs, because there's no possible way that an old
kernel can screw things up.

> +
> +	attrip = xfs_attri_init(mp, 0);
> +	if (attrip == NULL)
> +		return NULL;
> +
> +	xfs_trans_add_item(tp, &attrip->attri_item);
> +	list_for_each_entry(attr, items, xattri_list)
> +		xfs_attr_log_item(tp, attrip, attr);
> +	return &attrip->attri_item;
> +}
> +
> +/* Process an attr. */
> +STATIC int
> +xfs_attr_finish_item(
> +	struct xfs_trans		*tp,
> +	struct xfs_log_item		*done,
> +	struct list_head		*item,
> +	struct xfs_btree_cur		**state)
> +{
> +	struct xfs_attr_item		*attr;
> +	struct xfs_attrd_log_item	*done_item = NULL;
> +	int				error;
> +	struct xfs_delattr_context	*dac;
> +
> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
> +	dac = &attr->xattri_dac;
> +	if (done)
> +		done_item = ATTRD_ITEM(done);
> +
> +	/*
> +	 * Corner case that can happen during a recovery.  Because the first
> +	 * iteration of a multi part delay op happens in xfs_attri_item_recover
> +	 * to maintain the order of the log replay items.  But the new
> +	 * transactions do not automatically rejoin during a recovery as they do
> +	 * in a standard delay op, so we need to catch this here and rejoin the
> +	 * leaf to the new transaction
> +	 */
> +	if (attr->xattri_dac.leaf_bp &&
> +	    attr->xattri_dac.leaf_bp->b_transp != tp) {
> +		xfs_trans_bjoin(tp, attr->xattri_dac.leaf_bp);
> +		xfs_trans_bhold(tp, attr->xattri_dac.leaf_bp);
> +	}
> +
> +	/*
> +	 * Always reset trans after EAGAIN cycle
> +	 * since the transaction is new
> +	 */
> +	dac->da_args->trans = tp;
> +
> +	error = xfs_trans_attr_finish_update(dac, done_item, &dac->leaf_bp,
> +					     attr->xattri_op_flags);
> +	if (error != -EAGAIN)
> +		kmem_free(attr);
> +
> +	return error;
> +}
> +
> +/* Abort all pending ATTRs. */
> +STATIC void
> +xfs_attr_abort_intent(
> +	struct xfs_log_item		*intent)
> +{
> +	xfs_attri_release(ATTRI_ITEM(intent));
> +}
> +
> +/* Cancel an attr */
> +STATIC void
> +xfs_attr_cancel_item(
> +	struct list_head		*item)
> +{
> +	struct xfs_attr_item		*attr;
> +
> +	attr = container_of(item, struct xfs_attr_item, xattri_list);
> +	kmem_free(attr);
> +}
> +
>  STATIC xfs_lsn_t
>  xfs_attri_item_committed(
>  	struct xfs_log_item		*lip,
> @@ -313,6 +490,30 @@ xfs_attri_item_match(
>  	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
>  }
>  
> +/*
> + * This routine is called to allocate an "attr free done" log item.
> + */
> +struct xfs_attrd_log_item *
> +xfs_trans_get_attrd(struct xfs_trans		*tp,
> +		  struct xfs_attri_log_item	*attrip)
> +{
> +	struct xfs_attrd_log_item		*attrdp;
> +	uint					size;
> +
> +	ASSERT(tp != NULL);
> +
> +	size = sizeof(struct xfs_attrd_log_item);
> +	attrdp = kmem_zalloc(size, 0);
> +
> +	xfs_log_item_init(tp->t_mountp, &attrdp->attrd_item, XFS_LI_ATTRD,
> +			  &xfs_attrd_item_ops);
> +	attrdp->attrd_attrip = attrip;
> +	attrdp->attrd_format.alfd_alf_id = attrip->attri_format.alfi_id;
> +
> +	xfs_trans_add_item(tp, &attrdp->attrd_item);
> +	return attrdp;
> +}
> +
>  static const struct xfs_item_ops xfs_attrd_item_ops = {
>  	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>  	.iop_size	= xfs_attrd_item_size,
> @@ -320,6 +521,29 @@ static const struct xfs_item_ops xfs_attrd_item_ops = {
>  	.iop_release    = xfs_attrd_item_release,
>  };
>  
> +
> +/* Get an ATTRD so we can process all the attrs. */
> +static struct xfs_log_item *
> +xfs_attr_create_done(
> +	struct xfs_trans		*tp,
> +	struct xfs_log_item		*intent,
> +	unsigned int			count)
> +{
> +	if (!intent)
> +		return NULL;
> +
> +	return &xfs_trans_get_attrd(tp, ATTRI_ITEM(intent))->attrd_item;
> +}
> +
> +const struct xfs_defer_op_type xfs_attr_defer_type = {
> +	.max_items	= 1,
> +	.create_intent	= xfs_attr_create_intent,
> +	.abort_intent	= xfs_attr_abort_intent,
> +	.create_done	= xfs_attr_create_done,
> +	.finish_item	= xfs_attr_finish_item,
> +	.cancel_item	= xfs_attr_cancel_item,
> +};
> +
>  /* Is this recovered ATTRI ok? */
>  static inline bool
>  xfs_attri_validate(
> @@ -346,13 +570,183 @@ xfs_attri_validate(
>  	return xfs_hasdelattr(mp);
>  }
>  
> +/*
> + * Process an attr intent item that was recovered from the log.  We need to
> + * delete the attr that it describes.
> + */
> +STATIC int
> +xfs_attri_item_recover(
> +	struct xfs_log_item		*lip,
> +	struct list_head		*capture_list)
> +{
> +	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
> +	struct xfs_attr_item		*new_attr;
> +	struct xfs_mount		*mp = lip->li_mountp;
> +	struct xfs_inode		*ip;
> +	struct xfs_da_args		args;
> +	struct xfs_da_args		*new_args;
> +	struct xfs_trans_res		tres;
> +	bool				rsvd;
> +	struct xfs_attri_log_format	*attrp;
> +	int				error;
> +	int				total;
> +	int				local;
> +	struct xfs_attrd_log_item	*done_item = NULL;
> +	struct xfs_attr_item		attr = {
> +		.xattri_op_flags	= attrip->attri_format.alfi_op_flags,
> +		.xattri_dac.da_args	= &args,
> +	};
> +
> +	/*
> +	 * First check the validity of the attr described by the ATTRI.  If any
> +	 * are bad, then assume that all are bad and just toss the ATTRI.
> +	 */
> +	attrp = &attrip->attri_format;
> +	if (!xfs_attri_validate(mp, attrip))
> +		return -EFSCORRUPTED;
> +

Everything from here...

> +	error = xfs_iget(mp, 0, attrp->alfi_ino, 0, 0, &ip);
> +	if (error)
> +		return error;
> +
> +	if (VFS_I(ip)->i_nlink == 0)
> +		xfs_iflags_set(ip, XFS_IRECOVERY);

...to here should be a call to xlog_recover_iget(), which is in this
patch:

https://djwong.org/docs/kernel/171-xfs-log-recovery-refactor-iget.patch

> +
> +	memset(&args, 0, sizeof(struct xfs_da_args));
> +	args.dp = ip;
> +	args.geo = mp->m_attr_geo;
> +	args.op_flags = attrp->alfi_op_flags;
> +	args.whichfork = XFS_ATTR_FORK;
> +	args.name = attrip->attri_name;
> +	args.namelen = attrp->alfi_name_len;
> +	args.hashval = xfs_da_hashname(args.name, args.namelen);
> +	args.attr_filter = attrp->alfi_attr_flags;
> +
> +	if (attrp->alfi_op_flags == XFS_ATTR_OP_FLAGS_SET) {
> +		args.value = attrip->attri_value;
> +		args.valuelen = attrp->alfi_value_len;
> +		args.total = xfs_attr_calc_size(&args, &local);
> +
> +		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
> +				 M_RES(mp)->tr_attrsetrt.tr_logres *
> +					args.total;
> +		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
> +		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> +		total = args.total;
> +	} else {
> +		tres = M_RES(mp)->tr_attrrm;
> +		total = XFS_ATTRRM_SPACE_RES(mp);
> +	}
> +	error = xfs_trans_alloc(mp, &tres, total, 0,
> +				rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
> +	if (error)
> +		return error;
> +
> +	done_item = xfs_trans_get_attrd(args.trans, attrip);
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(args.trans, ip, 0);
> +
> +	error = xfs_trans_attr_finish_update(&attr.xattri_dac, done_item,
> +					     &attr.xattri_dac.leaf_bp,
> +					     attrp->alfi_op_flags);
> +	if (error == -EAGAIN) {
> +		/*
> +		 * There's more work to do, so make a new xfs_attr_item and add
> +		 * it to this transaction.  We don't use xfs_attr_item_init here
> +		 * because we need the info stored in the current attr to
> +		 * continue with this multi-part operation.  So, alloc space
> +		 * for it and the args and copy everything there.
> +		 */
> +		new_attr = kmem_zalloc(sizeof(struct xfs_attr_item) +
> +				       sizeof(struct xfs_da_args), KM_NOFS);
> +		new_args = (struct xfs_da_args *)((char *)new_attr +
> +			   sizeof(struct xfs_attr_item));
> +
> +		memcpy(new_args, &args, sizeof(struct xfs_da_args));
> +		memcpy(new_attr, &attr, sizeof(struct xfs_attr_item));
> +
> +		new_attr->xattri_dac.da_args = new_args;
> +		memset(&new_attr->xattri_list, 0, sizeof(struct list_head));
> +
> +		xfs_defer_add(args.trans, XFS_DEFER_OPS_TYPE_ATTR,
> +			      &new_attr->xattri_list);

Rather than allocating a huge struct xfs_attr_item (aka the incore state
tracking mechanism) on the stack, filling it out, and copying it if
there's more work to do, why not kmem_zalloc it from the start, and
either attach it to the transaction if there's more work to do, or free
it if (unlikely) we actually finished the xattr update?

> +
> +		/* Do not send -EAGAIN back to caller */
> +		error = 0;
> +	} else if (error) {
> +		xfs_trans_cancel(args.trans);
> +		goto out;
> +	}
> +
> +	xfs_defer_ops_capture_and_commit(args.trans, ip, capture_list);

No error checking here?

--D

> +
> +out:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	xfs_irele(ip);
> +	return error;
> +}
> +
> +/* Re-log an intent item to push the log tail forward. */
> +static struct xfs_log_item *
> +xfs_attri_item_relog(
> +	struct xfs_log_item		*intent,
> +	struct xfs_trans		*tp)
> +{
> +	struct xfs_attrd_log_item	*attrdp;
> +	struct xfs_attri_log_item	*old_attrip;
> +	struct xfs_attri_log_item	*new_attrip;
> +	struct xfs_attri_log_format	*new_attrp;
> +	struct xfs_attri_log_format	*old_attrp;
> +	int				buffer_size;
> +
> +	old_attrip = ATTRI_ITEM(intent);
> +	old_attrp = &old_attrip->attri_format;
> +	buffer_size = old_attrp->alfi_value_len + old_attrp->alfi_name_len;
> +
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	attrdp = xfs_trans_get_attrd(tp, old_attrip);
> +	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
> +
> +	new_attrip = xfs_attri_init(tp->t_mountp, buffer_size);
> +	new_attrp = &new_attrip->attri_format;
> +
> +	new_attrp->alfi_ino = old_attrp->alfi_ino;
> +	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
> +	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
> +	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
> +	new_attrp->alfi_attr_flags = old_attrp->alfi_attr_flags;
> +
> +	new_attrip->attri_name_len = old_attrip->attri_name_len;
> +	new_attrip->attri_name = ((char *)new_attrip) +
> +				 sizeof(struct xfs_attri_log_item);
> +	memcpy(new_attrip->attri_name, old_attrip->attri_name,
> +		new_attrip->attri_name_len);
> +
> +	new_attrip->attri_value_len = old_attrip->attri_value_len;
> +	if (new_attrip->attri_value_len > 0) {
> +		new_attrip->attri_value = new_attrip->attri_name +
> +					  new_attrip->attri_name_len;
> +
> +		memcpy(new_attrip->attri_value, old_attrip->attri_value,
> +		       new_attrip->attri_value_len);
> +	}
> +
> +	xfs_trans_add_item(tp, &new_attrip->attri_item);
> +	set_bit(XFS_LI_DIRTY, &new_attrip->attri_item.li_flags);
> +
> +	return &new_attrip->attri_item;
> +}
> +
>  static const struct xfs_item_ops xfs_attri_item_ops = {
>  	.iop_size	= xfs_attri_item_size,
>  	.iop_format	= xfs_attri_item_format,
>  	.iop_unpin	= xfs_attri_item_unpin,
>  	.iop_committed	= xfs_attri_item_committed,
>  	.iop_release    = xfs_attri_item_release,
> +	.iop_recover	= xfs_attri_item_recover,
>  	.iop_match	= xfs_attri_item_match,
> +	.iop_relog	= xfs_attri_item_relog,
>  };
>  
>  
> -- 
> 2.7.4
> 
