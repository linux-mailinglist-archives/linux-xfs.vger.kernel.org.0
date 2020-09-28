Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FA727A6F2
	for <lists+linux-xfs@lfdr.de>; Mon, 28 Sep 2020 07:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725290AbgI1F03 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 28 Sep 2020 01:26:29 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51984 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725287AbgI1F02 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Sep 2020 01:26:28 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 74F86826BD5;
        Mon, 28 Sep 2020 15:26:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kMlg2-0004ic-Vs; Mon, 28 Sep 2020 15:26:18 +1000
Date:   Mon, 28 Sep 2020 15:26:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de, bfoster@redhat.com
Subject: Re: [PATCH 2/4] xfs: proper replay of deferred ops queued during log
 recovery
Message-ID: <20200928052618.GD14422@dread.disaster.area>
References: <160125006793.174438.10683462598722457550.stgit@magnolia>
 <160125008079.174438.4841984502957067911.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160125008079.174438.4841984502957067911.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=WbUGnFyrwLijZbKEiX8A:9 a=Il7P6XIP0bjsHgdT:21 a=yDjO1jZgF0UQL6Gl:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 27, 2020 at 04:41:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we replay unfinished intent items that have been recovered from the
> log, it's possible that the replay will cause the creation of more
> deferred work items.  As outlined in commit 509955823cc9c ("xfs: log
> recovery should replay deferred ops in order"), later work items have an
> implicit ordering dependency on earlier work items.  Therefore, recovery
> must replay the items (both recovered and created) in the same order
> that they would have been during normal operation.
> 
> For log recovery, we enforce this ordering by using an empty transaction
> to collect deferred ops that get created in the process of recovering a
> log intent item to prevent them from being committed before the rest of
> the recovered intent items.  After we finish committing all the
> recovered log items, we allocate a transaction with an enormous block
> reservation, splice our huge list of created deferred ops into that
> transaction, and commit it, thereby finishing all those ops.
> 
> This is /really/ hokey -- it's the one place in XFS where we allow
> nested transactions; the splicing of the defer ops list is is inelegant
> and has to be done twice per recovery function; and the broken way we
> handle inode pointers and block reservations cause subtle use-after-free
> and allocator problems that will be fixed by this patch and the two
> patches after it.
> 
> Therefore, replace the hokey empty transaction with a structure designed
> to capture each chain of deferred ops that are created as part of
> recovering a single unfinished log intent.  Finally, refactor the loop
> that replays those chains to do so using one transaction per chain.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c       |   56 +++++++++++++--
>  fs/xfs/libxfs/xfs_defer.h       |   20 +++++
>  fs/xfs/libxfs/xfs_log_recover.h |    2 +
>  fs/xfs/xfs_bmap_item.c          |   16 +---
>  fs/xfs/xfs_extfree_item.c       |    7 +-
>  fs/xfs/xfs_log_recover.c        |  150 +++++++++++++++++++++++++--------------
>  fs/xfs/xfs_refcount_item.c      |   16 +---
>  fs/xfs/xfs_rmap_item.c          |    7 +-
>  fs/xfs/xfs_trans.h              |    3 +
>  9 files changed, 183 insertions(+), 94 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 36c103c14bc9..0de7672fe63d 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -549,14 +549,56 @@ xfs_defer_move(
>   *
>   * Create and log intent items for all the work that we're capturing so that we
>   * can be assured that the items will get replayed if the system goes down
> - * before log recovery gets a chance to finish the work it put off.  Then we
> - * move the chain from stp to dtp.
> + * before log recovery gets a chance to finish the work it put off.  The entire
> + * deferred ops state is transferred to the capture structure and the
> + * transaction is then ready for the caller to commit it.  If there are no
> + * intent items to capture, this function returns NULL.
>   */
> -void
> +struct xfs_defer_capture *
>  xfs_defer_capture(
> -	struct xfs_trans	*dtp,
> -	struct xfs_trans	*stp)
> +	struct xfs_trans		*tp)

"capture" what?

Perhaps this whole API reads better as:

xfs_defer_ops_capture()
xfs_defer_ops_continue()
xfs_defer_ops_release()

because what it is doing is moving deferops from a transaction to a
capture structure and back again...

.....

> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 3164199162b6..bc7493bf4542 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -8,6 +8,7 @@
>  
>  struct xfs_btree_cur;
>  struct xfs_defer_op_type;
> +struct xfs_defer_capture;
>  
>  /*
>   * Header for deferred operation list.
> @@ -63,10 +64,27 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
>  extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
>  extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
>  
> +/*
> + * Deferred operation freezer.  This structure enables a dfops user to detach
> + * the chain of deferred operations from a transaction so that they can be
> + * continued later.
> + */

"freezer"?

Stale comment?

.....

> @@ -531,15 +526,12 @@ xfs_bui_item_recover(
>  		xfs_bmap_unmap_extent(tp, ip, &irec);
>  	}
>  
> -	xfs_defer_capture(parent_tp, tp);
> -	error = xfs_trans_commit(tp);
> +	error = xlog_recover_trans_commit(tp, capture_list);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	xfs_irele(ip);
> -
>  	return error;

hmmmm.

> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e0675071b39e..107965acc57e 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1755,6 +1755,38 @@ xlog_recover_release_intent(
>  	spin_unlock(&ailp->ail_lock);
>  }
>  
> +/*
> + * Capture any deferred ops and commit the transaction.  This is the last step
> + * needed to finish a log intent item that we recovered from the log, and will
> + * take care of releasing all the relevant resources.

What does "take care of releasing all the relevant resources"
mean? 

> + */
> +int
> +xlog_recover_trans_commit(
> +	struct xfs_trans		*tp,
> +	struct list_head		*capture_list)
> +{
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	struct xfs_defer_capture	*dfc = xfs_defer_capture(tp);
> +	int				error;
> +
> +	/* If we don't capture anything, commit tp and exit. */
> +	if (!dfc)
> +		return xfs_trans_commit(tp);
> +
> +	/*
> +	 * Commit the transaction.  If that fails, clean up the defer ops and
> +	 * the dfc that we just created.  Otherwise, add the dfc to the list.
> +	 */
> +	error = xfs_trans_commit(tp);
> +	if (error) {
> +		xfs_defer_capture_free(mp, dfc);
> +		return error;
> +	}
> +
> +	list_add_tail(&dfc->dfc_list, capture_list);
> +	return 0;
> +}

And, really, this is more than a "transaction commit" operation; it
doesn't have anything recovery specific to it, so if the
xfs_defer_capture() API is "generic xfs_defer" functionality, why
isn't this placed next to it and nameed
xfs_defer_capture_and_commit()?

> @@ -2431,38 +2463,62 @@ xlog_recover_process_data(
>  	return 0;
>  }
>  
> +static void
> +xlog_cancel_defer_ops(
> +	struct xfs_mount	*mp,
> +	struct list_head	*capture_list)
> +{
> +	struct xfs_defer_capture *dfc, *next;
> +
> +	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
> +		list_del_init(&dfc->dfc_list);
> +		xfs_defer_capture_free(mp, dfc);
> +	}
> +}

Same - there is nothing log recovery specific here.

>  /* Take all the collected deferred ops and finish them in order. */
>  static int
>  xlog_finish_defer_ops(
> -	struct xfs_trans	*parent_tp)
> +	struct xfs_mount	*mp,
> +	struct list_head	*capture_list)
>  {
> -	struct xfs_mount	*mp = parent_tp->t_mountp;
> +	struct xfs_defer_capture *dfc, *next;
>  	struct xfs_trans	*tp;
>  	int64_t			freeblks;
> -	uint			resblks;
> -	int			error;
> +	uint64_t		resblks;
> +	int			error = 0;
>  
> -	/*
> -	 * We're finishing the defer_ops that accumulated as a result of
> -	 * recovering unfinished intent items during log recovery.  We
> -	 * reserve an itruncate transaction because it is the largest
> -	 * permanent transaction type.  Since we're the only user of the fs
> -	 * right now, take 93% (15/16) of the available free blocks.  Use
> -	 * weird math to avoid a 64-bit division.
> -	 */
> -	freeblks = percpu_counter_sum(&mp->m_fdblocks);
> -	if (freeblks <= 0)
> -		return -ENOSPC;
> -	resblks = min_t(int64_t, UINT_MAX, freeblks);
> -	resblks = (resblks * 15) >> 4;
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
> -			0, XFS_TRANS_RESERVE, &tp);
> -	if (error)
> -		return error;
> -	/* transfer all collected dfops to this transaction */
> -	xfs_defer_move(tp, parent_tp);
> +	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
> +		/*
> +		 * We're finishing the defer_ops that accumulated as a result
> +		 * of recovering unfinished intent items during log recovery.
> +		 * We reserve an itruncate transaction because it is the
> +		 * largest permanent transaction type.  Since we're the only
> +		 * user of the fs right now, take 93% (15/16) of the available
> +		 * free blocks.  Use weird math to avoid a 64-bit division.
> +		 */
> +		freeblks = percpu_counter_sum(&mp->m_fdblocks);
> +		if (freeblks <= 0)
> +			return -ENOSPC;
>  
> -	return xfs_trans_commit(tp);
> +		resblks = min_t(uint64_t, UINT_MAX, freeblks);
> +		resblks = (resblks * 15) >> 4;
> +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
> +				0, XFS_TRANS_RESERVE, &tp);
> +		if (error)
> +			return error;
> +
> +		/* transfer all collected dfops to this transaction */
> +		list_del_init(&dfc->dfc_list);
> +		xfs_defer_continue(dfc, tp);
> +
> +		error = xfs_trans_commit(tp);
> +		xfs_defer_capture_free(mp, dfc);

Why does this need to call xfs_defer_cancel_list() here? Shouldn't
dfc->dfc_dfops already be empty here? And if it isn't, shouldn't
that throw an error rather than silently cancle work that hasn't be
done that should have been?


>  #endif
> -	while (lip != NULL) {
> +	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> +	     lip != NULL;
> +	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
>  		/*
>  		 * We're done when we see something other than an intent.
>  		 * There should be no intents left in the AIL now.
> @@ -2533,28 +2577,28 @@ xlog_recover_process_intents(
>  		 */
>  		ASSERT(XFS_LSN_CMP(last_lsn, lip->li_lsn) >= 0);
>  
> +		if (test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags))
> +			continue;
> +

Why do we still need XFS_LI_RECOVERED here? This log item is going to get
removed from the AIL by the committing of the first transaction
in the ->iop_recover() sequence we are running, so we'll never find
it again in the AIL. Nothing else checks for XFS_LI_RECOVERED
anymore, so this seems unnecessary now...


> -out:
> +
>  	xfs_trans_ail_cursor_done(&cur);
>  	spin_unlock(&ailp->ail_lock);
>  	if (!error)
> -		error = xlog_finish_defer_ops(parent_tp);
> -	xfs_trans_cancel(parent_tp);
> +		error = xlog_finish_defer_ops(log->l_mp, &capture_list);
>  
> +	xlog_cancel_defer_ops(log->l_mp, &capture_list);
>  	return error;
>  }

Again, why are we cancelling the capture list if we just
successfully processed the defer ops on the capture list?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
