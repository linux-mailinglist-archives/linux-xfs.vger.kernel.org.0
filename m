Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC27759C20E
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Aug 2022 17:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbiHVPEG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Aug 2022 11:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235955AbiHVPDx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 11:03:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B32B2C
        for <linux-xfs@vger.kernel.org>; Mon, 22 Aug 2022 08:03:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 025E1B81247
        for <linux-xfs@vger.kernel.org>; Mon, 22 Aug 2022 15:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39F1C433D6;
        Mon, 22 Aug 2022 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661180622;
        bh=6Wo25ea5rWGzQs70XxtfT17OomGFkT4jSS5Qrlvlyz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fKRF8RAiOxKzMJizCcYTw978zzhYxv7C8kcAYiGQxiKyLydyIKMSeJMMDyoiC7ORb
         n9BUviwRoMcQUgM+aeUnb16kawBMZ7WPbvgjFbx3jrIQ+OYbh6bRb+pptdMER2L2yz
         WW9BQo8GO7PdVNGFoBd9siN/U2AGgHPjBZH2iPysDF35tEmQbOhcJBaM3QPb5nYZjk
         6R8HnZMZduMpAxuoF66RMaZ/s97hu8/vAr6Zwr+QlumT2gbdAVI5U+ehNHR2L9WCzx
         79h1XANUviUtJXK6ogG+uo0n7CsRGWTRAhhSPKJrFbgkBMqCi0NPEEw1EsJ04HQTvE
         ZKlQmsyK0j0qg==
Date:   Mon, 22 Aug 2022 08:03:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/9] xfs: move and xfs_trans_committed_bulk
Message-ID: <YwOazokP/MTcK4ay@magnolia>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809230353.3353059-2-david@fromorbit.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 10, 2022 at 09:03:45AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Ever since the CIL and delayed logging was introduced,
> xfs_trans_committed_bulk() has been a purely CIL checkpoint
> completion function and not a transaction commit completion
> function. Now that we are adding log specific updates to this
> function, it really does not have anything to do with the
> transaction subsystem - it is really log and log item level
> functionality.
> 
> This should be part of the CIL code as it is the callback
> that moves log items from the CIL checkpoint to the AIL. Move it
> and rename it to xlog_cil_ail_insert().
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

/me has been wondering why these two functions weren't lumped into the
rest of the cil code for quite sometime, so thx for clarifying. :)

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_cil.c    | 132 +++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_trans.c      | 129 ---------------------------------------
>  fs/xfs/xfs_trans_priv.h |   3 -
>  3 files changed, 131 insertions(+), 133 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index eccbfb99e894..475a18493c37 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -683,6 +683,136 @@ xlog_cil_insert_items(
>  	}
>  }
>  
> +static inline void
> +xlog_cil_ail_insert_batch(
> +	struct xfs_ail		*ailp,
> +	struct xfs_ail_cursor	*cur,
> +	struct xfs_log_item	**log_items,
> +	int			nr_items,
> +	xfs_lsn_t		commit_lsn)
> +{
> +	int	i;
> +
> +	spin_lock(&ailp->ail_lock);
> +	/* xfs_trans_ail_update_bulk drops ailp->ail_lock */
> +	xfs_trans_ail_update_bulk(ailp, cur, log_items, nr_items, commit_lsn);
> +
> +	for (i = 0; i < nr_items; i++) {
> +		struct xfs_log_item *lip = log_items[i];
> +
> +		if (lip->li_ops->iop_unpin)
> +			lip->li_ops->iop_unpin(lip, 0);
> +	}
> +}
> +
> +/*
> + * Take the checkpoint's log vector chain of items and insert the attached log
> + * items into the the AIL. This uses bulk insertion techniques to minimise AIL
> + * lock traffic.
> + *
> + * If we are called with the aborted flag set, it is because a log write during
> + * a CIL checkpoint commit has failed. In this case, all the items in the
> + * checkpoint have already gone through iop_committed and iop_committing, which
> + * means that checkpoint commit abort handling is treated exactly the same as an
> + * iclog write error even though we haven't started any IO yet. Hence in this
> + * case all we need to do is iop_committed processing, followed by an
> + * iop_unpin(aborted) call.
> + *
> + * The AIL cursor is used to optimise the insert process. If commit_lsn is not
> + * at the end of the AIL, the insert cursor avoids the need to walk the AIL to
> + * find the insertion point on every xfs_log_item_batch_insert() call. This
> + * saves a lot of needless list walking and is a net win, even though it
> + * slightly increases that amount of AIL lock traffic to set it up and tear it
> + * down.
> + */
> +void
> +xlog_cil_ail_insert(
> +	struct xlog		*log,
> +	struct list_head	*lv_chain,
> +	xfs_lsn_t		commit_lsn,
> +	bool			aborted)
> +{
> +#define LOG_ITEM_BATCH_SIZE	32
> +	struct xfs_ail		*ailp = log->l_ailp;
> +	struct xfs_log_item	*log_items[LOG_ITEM_BATCH_SIZE];
> +	struct xfs_log_vec	*lv;
> +	struct xfs_ail_cursor	cur;
> +	int			i = 0;
> +
> +	spin_lock(&ailp->ail_lock);
> +	xfs_trans_ail_cursor_last(ailp, &cur, commit_lsn);
> +	spin_unlock(&ailp->ail_lock);
> +
> +	/* unpin all the log items */
> +	list_for_each_entry(lv, lv_chain, lv_list) {
> +		struct xfs_log_item	*lip = lv->lv_item;
> +		xfs_lsn_t		item_lsn;
> +
> +		if (aborted)
> +			set_bit(XFS_LI_ABORTED, &lip->li_flags);
> +
> +		if (lip->li_ops->flags & XFS_ITEM_RELEASE_WHEN_COMMITTED) {
> +			lip->li_ops->iop_release(lip);
> +			continue;
> +		}
> +
> +		if (lip->li_ops->iop_committed)
> +			item_lsn = lip->li_ops->iop_committed(lip, commit_lsn);
> +		else
> +			item_lsn = commit_lsn;
> +
> +		/* item_lsn of -1 means the item needs no further processing */
> +		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
> +			continue;
> +
> +		/*
> +		 * if we are aborting the operation, no point in inserting the
> +		 * object into the AIL as we are in a shutdown situation.
> +		 */
> +		if (aborted) {
> +			ASSERT(xlog_is_shutdown(ailp->ail_log));
> +			if (lip->li_ops->iop_unpin)
> +				lip->li_ops->iop_unpin(lip, 1);
> +			continue;
> +		}
> +
> +		if (item_lsn != commit_lsn) {
> +
> +			/*
> +			 * Not a bulk update option due to unusual item_lsn.
> +			 * Push into AIL immediately, rechecking the lsn once
> +			 * we have the ail lock. Then unpin the item. This does
> +			 * not affect the AIL cursor the bulk insert path is
> +			 * using.
> +			 */
> +			spin_lock(&ailp->ail_lock);
> +			if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0)
> +				xfs_trans_ail_update(ailp, lip, item_lsn);
> +			else
> +				spin_unlock(&ailp->ail_lock);
> +			if (lip->li_ops->iop_unpin)
> +				lip->li_ops->iop_unpin(lip, 0);
> +			continue;
> +		}
> +
> +		/* Item is a candidate for bulk AIL insert.  */
> +		log_items[i++] = lv->lv_item;
> +		if (i >= LOG_ITEM_BATCH_SIZE) {
> +			xlog_cil_ail_insert_batch(ailp, &cur, log_items,
> +					LOG_ITEM_BATCH_SIZE, commit_lsn);
> +			i = 0;
> +		}
> +	}
> +
> +	/* make sure we insert the remainder! */
> +	if (i)
> +		xlog_cil_ail_insert_batch(ailp, &cur, log_items, i, commit_lsn);
> +
> +	spin_lock(&ailp->ail_lock);
> +	xfs_trans_ail_cursor_done(&cur);
> +	spin_unlock(&ailp->ail_lock);
> +}
> +
>  static void
>  xlog_cil_free_logvec(
>  	struct list_head	*lv_chain)
> @@ -792,7 +922,7 @@ xlog_cil_committed(
>  		spin_unlock(&ctx->cil->xc_push_lock);
>  	}
>  
> -	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, &ctx->lv_chain,
> +	xlog_cil_ail_insert(ctx->cil->xc_log, &ctx->lv_chain,
>  					ctx->start_lsn, abort);
>  
>  	xfs_extent_busy_sort(&ctx->busy_extents);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 7bd16fbff534..58c4e875eb12 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -715,135 +715,6 @@ xfs_trans_free_items(
>  	}
>  }
>  
> -static inline void
> -xfs_log_item_batch_insert(
> -	struct xfs_ail		*ailp,
> -	struct xfs_ail_cursor	*cur,
> -	struct xfs_log_item	**log_items,
> -	int			nr_items,
> -	xfs_lsn_t		commit_lsn)
> -{
> -	int	i;
> -
> -	spin_lock(&ailp->ail_lock);
> -	/* xfs_trans_ail_update_bulk drops ailp->ail_lock */
> -	xfs_trans_ail_update_bulk(ailp, cur, log_items, nr_items, commit_lsn);
> -
> -	for (i = 0; i < nr_items; i++) {
> -		struct xfs_log_item *lip = log_items[i];
> -
> -		if (lip->li_ops->iop_unpin)
> -			lip->li_ops->iop_unpin(lip, 0);
> -	}
> -}
> -
> -/*
> - * Bulk operation version of xfs_trans_committed that takes a log vector of
> - * items to insert into the AIL. This uses bulk AIL insertion techniques to
> - * minimise lock traffic.
> - *
> - * If we are called with the aborted flag set, it is because a log write during
> - * a CIL checkpoint commit has failed. In this case, all the items in the
> - * checkpoint have already gone through iop_committed and iop_committing, which
> - * means that checkpoint commit abort handling is treated exactly the same
> - * as an iclog write error even though we haven't started any IO yet. Hence in
> - * this case all we need to do is iop_committed processing, followed by an
> - * iop_unpin(aborted) call.
> - *
> - * The AIL cursor is used to optimise the insert process. If commit_lsn is not
> - * at the end of the AIL, the insert cursor avoids the need to walk
> - * the AIL to find the insertion point on every xfs_log_item_batch_insert()
> - * call. This saves a lot of needless list walking and is a net win, even
> - * though it slightly increases that amount of AIL lock traffic to set it up
> - * and tear it down.
> - */
> -void
> -xfs_trans_committed_bulk(
> -	struct xfs_ail		*ailp,
> -	struct list_head	*lv_chain,
> -	xfs_lsn_t		commit_lsn,
> -	bool			aborted)
> -{
> -#define LOG_ITEM_BATCH_SIZE	32
> -	struct xfs_log_item	*log_items[LOG_ITEM_BATCH_SIZE];
> -	struct xfs_log_vec	*lv;
> -	struct xfs_ail_cursor	cur;
> -	int			i = 0;
> -
> -	spin_lock(&ailp->ail_lock);
> -	xfs_trans_ail_cursor_last(ailp, &cur, commit_lsn);
> -	spin_unlock(&ailp->ail_lock);
> -
> -	/* unpin all the log items */
> -	list_for_each_entry(lv, lv_chain, lv_list) {
> -		struct xfs_log_item	*lip = lv->lv_item;
> -		xfs_lsn_t		item_lsn;
> -
> -		if (aborted)
> -			set_bit(XFS_LI_ABORTED, &lip->li_flags);
> -
> -		if (lip->li_ops->flags & XFS_ITEM_RELEASE_WHEN_COMMITTED) {
> -			lip->li_ops->iop_release(lip);
> -			continue;
> -		}
> -
> -		if (lip->li_ops->iop_committed)
> -			item_lsn = lip->li_ops->iop_committed(lip, commit_lsn);
> -		else
> -			item_lsn = commit_lsn;
> -
> -		/* item_lsn of -1 means the item needs no further processing */
> -		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
> -			continue;
> -
> -		/*
> -		 * if we are aborting the operation, no point in inserting the
> -		 * object into the AIL as we are in a shutdown situation.
> -		 */
> -		if (aborted) {
> -			ASSERT(xlog_is_shutdown(ailp->ail_log));
> -			if (lip->li_ops->iop_unpin)
> -				lip->li_ops->iop_unpin(lip, 1);
> -			continue;
> -		}
> -
> -		if (item_lsn != commit_lsn) {
> -
> -			/*
> -			 * Not a bulk update option due to unusual item_lsn.
> -			 * Push into AIL immediately, rechecking the lsn once
> -			 * we have the ail lock. Then unpin the item. This does
> -			 * not affect the AIL cursor the bulk insert path is
> -			 * using.
> -			 */
> -			spin_lock(&ailp->ail_lock);
> -			if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0)
> -				xfs_trans_ail_update(ailp, lip, item_lsn);
> -			else
> -				spin_unlock(&ailp->ail_lock);
> -			if (lip->li_ops->iop_unpin)
> -				lip->li_ops->iop_unpin(lip, 0);
> -			continue;
> -		}
> -
> -		/* Item is a candidate for bulk AIL insert.  */
> -		log_items[i++] = lv->lv_item;
> -		if (i >= LOG_ITEM_BATCH_SIZE) {
> -			xfs_log_item_batch_insert(ailp, &cur, log_items,
> -					LOG_ITEM_BATCH_SIZE, commit_lsn);
> -			i = 0;
> -		}
> -	}
> -
> -	/* make sure we insert the remainder! */
> -	if (i)
> -		xfs_log_item_batch_insert(ailp, &cur, log_items, i, commit_lsn);
> -
> -	spin_lock(&ailp->ail_lock);
> -	xfs_trans_ail_cursor_done(&cur);
> -	spin_unlock(&ailp->ail_lock);
> -}
> -
>  /*
>   * Sort transaction items prior to running precommit operations. This will
>   * attempt to order the items such that they will always be locked in the same
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index d5400150358e..52a45f0a5ef1 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -19,9 +19,6 @@ void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
>  void	xfs_trans_del_item(struct xfs_log_item *);
>  void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
>  
> -void	xfs_trans_committed_bulk(struct xfs_ail *ailp,
> -				struct list_head *lv_chain,
> -				xfs_lsn_t commit_lsn, bool aborted);
>  /*
>   * AIL traversal cursor.
>   *
> -- 
> 2.36.1
> 
