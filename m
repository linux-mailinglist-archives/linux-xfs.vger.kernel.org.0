Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4268727870C
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Sep 2020 14:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgIYMV6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Sep 2020 08:21:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727290AbgIYMV6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Sep 2020 08:21:58 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601036514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eNSYCHxwr0BuQ4HcmCsV3IXxLR/zTtAC9Ik8U5oj1fA=;
        b=J2/dVEhkClBFWwXdE07oJaUaXJH3m/96obZTt/cn+EICwGPMdqI0Nvbyhp/VTgzz4Sh9MD
        6WWT3Zlo+fLGTekn+1KSCrF5nSsQP3pAC3ITq9cNY4o9fLqu2fVvkiiGz2I6eMiJ1vWSZN
        /PISKLiOIDVQc5Havn8eA8nDAlgsiKs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-mhwkercTO9OSkHQbdn8Fhg-1; Fri, 25 Sep 2020 08:21:50 -0400
X-MC-Unique: mhwkercTO9OSkHQbdn8Fhg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F35C1882FA1;
        Fri, 25 Sep 2020 12:21:49 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C174927BB5;
        Fri, 25 Sep 2020 12:21:48 +0000 (UTC)
Date:   Fri, 25 Sep 2020 08:21:46 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH v2 1/3] xfs: proper replay of deferred ops queued during
 log recovery
Message-ID: <20200925122146.GC2646051@bfoster>
References: <160031334050.3624461.17900718410309670962.stgit@magnolia>
 <160031334683.3624461.7162765986332930241.stgit@magnolia>
 <20200924060206.GA7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924060206.GA7955@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 11:02:06PM -0700, Darrick J. Wong wrote:
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
> v2: rework the api so we pass around the capture list instead of pointer
> pointer weirdness
> ---
>  fs/xfs/libxfs/xfs_defer.c       |   73 ++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_defer.h       |   20 ++++++
>  fs/xfs/libxfs/xfs_log_recover.h |    2 +
>  fs/xfs/xfs_bmap_item.c          |   16 +----
>  fs/xfs/xfs_extfree_item.c       |    7 +-
>  fs/xfs/xfs_log_recover.c        |  131 +++++++++++++++++++++++----------------
>  fs/xfs/xfs_refcount_item.c      |   16 +----
>  fs/xfs/xfs_rmap_item.c          |    7 +-
>  fs/xfs/xfs_trans.h              |    3 +
>  9 files changed, 181 insertions(+), 94 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 29e9762f3b77..0cb4af0c5c10 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -563,14 +563,73 @@ xfs_defer_move(
>   *
>   * Create and log intent items for all the work that we're capturing so that we
>   * can be assured that the items will get replayed if the system goes down
> - * before log recovery gets a chance to finish the work it put off.  Then we
> - * move the chain from stp to dtp.
> + * before log recovery gets a chance to finish the work it put off.  The entire
> + * deferred ops state is transferred to the capture structure and the
> + * transaction is committed.
> + *
> + * Note that the capture state is passed up to the caller and must be freed
> + * even if the transaction commit returns error.
>   */
> -void
> +int
>  xfs_defer_capture(
> -	struct xfs_trans	*dtp,
> -	struct xfs_trans	*stp)
> +	struct xfs_trans		*tp,
> +	struct list_head		*capture_list)
>  {
> -	xfs_defer_create_intents(stp);
> -	xfs_defer_move(dtp, stp);
> +	struct xfs_defer_capture	*dfc;
> +	struct xfs_mount		*mp = tp->t_mountp;
> +	int				error;
> +
> +	if (list_empty(&tp->t_dfops))
> +		return xfs_trans_commit(tp);
> +
> +	/* Create an object to capture the defer ops. */
> +	dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
> +
> +	xfs_defer_create_intents(tp);
> +
> +	INIT_LIST_HEAD(&dfc->dfc_list);
> +	INIT_LIST_HEAD(&dfc->dfc_dfops);

Maybe move this right after the allocation..?

> +
> +	/* Move the dfops chain and transaction state to the freezer. */

"freezer" or "capture?"

> +	list_splice_init(&tp->t_dfops, &dfc->dfc_dfops);
> +	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
> +	xfs_defer_reset(tp);

Seems all this does now is clear the LOWMODE flag. Any real need for
such a helper?

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

This is subjective I suppose, but from an interface standpoint I find it
a little odd that a "defer capture" function commits a transaction. I'd
expect that to be a separate action and for this function just to do
whatever is necessary with the dfops as it relates to the transaction
(particularly since this also appears to end up wrapped in a
'_trans_commit()' helper that could presumably commit the transaction)..

I also just realized the patch from the git repo doesn't match this one
and this one doesn't apply cleanly to for-next. Which is the right
version?

Brian

> +
> +	list_add_tail(&dfc->dfc_list, capture_list);
> +	return 0;
> +}
> +
> +/* Attach a chain of captured deferred ops to a new transaction. */
> +void
> +xfs_defer_continue(
> +	struct xfs_defer_capture	*dfc,
> +	struct xfs_trans		*tp)
> +{
> +	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
> +	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
> +
> +	/* Move captured dfops chain and state to the transaction. */
> +	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
> +	tp->t_flags |= dfc->dfc_tpflags;
> +	dfc->dfc_tpflags = 0;
> +}
> +
> +/* Release all resources that we used to capture deferred ops. */
> +void
> +xfs_defer_capture_free(
> +	struct xfs_mount		*mp,
> +	struct xfs_defer_capture	*dfc)
> +{
> +	xfs_defer_cancel_list(mp, &dfc->dfc_dfops);
> +	kmem_free(dfc);
>  }
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 3164199162b6..366d08d99e11 100644
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
> +struct xfs_defer_capture {
> +	/* List of other freezer heads. */
> +	struct list_head	dfc_list;
> +
> +	/* Deferred ops state saved from the transaction. */
> +	struct list_head	dfc_dfops;
> +	unsigned int		dfc_tpflags;
> +};
> +
>  /*
>   * Functions to capture a chain of deferred operations and continue them later.
>   * This doesn't normally happen except log recovery.
>   */
> -void xfs_defer_capture(struct xfs_trans *dtp, struct xfs_trans *stp);
> +int xfs_defer_capture(struct xfs_trans *tp, struct list_head *capture_list);
> +void xfs_defer_continue(struct xfs_defer_capture *dfc, struct xfs_trans *tp);
> +void xfs_defer_capture_free(struct xfs_mount *mp,
> +		struct xfs_defer_capture *dfc);
>  
>  #endif /* __XFS_DEFER_H__ */
> diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
> index 641132d0e39d..4f752096f7c7 100644
> --- a/fs/xfs/libxfs/xfs_log_recover.h
> +++ b/fs/xfs/libxfs/xfs_log_recover.h
> @@ -125,5 +125,7 @@ void xlog_recover_iodone(struct xfs_buf *bp);
>  
>  void xlog_recover_release_intent(struct xlog *log, unsigned short intent_type,
>  		uint64_t intent_id);
> +int xlog_recover_trans_commit(struct xfs_trans *tp,
> +		struct list_head *capture_list);
>  
>  #endif	/* __XFS_LOG_RECOVER_H__ */
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index b04ebcd78316..b73f0a0890a2 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -424,13 +424,13 @@ const struct xfs_defer_op_type xfs_bmap_update_defer_type = {
>  STATIC int
>  xfs_bui_item_recover(
>  	struct xfs_log_item		*lip,
> -	struct xfs_trans		*parent_tp)
> +	struct list_head		*capture_list)
>  {
>  	struct xfs_bmbt_irec		irec;
>  	struct xfs_bui_log_item		*buip = BUI_ITEM(lip);
>  	struct xfs_trans		*tp;
>  	struct xfs_inode		*ip = NULL;
> -	struct xfs_mount		*mp = parent_tp->t_mountp;
> +	struct xfs_mount		*mp = lip->li_mountp;
>  	struct xfs_map_extent		*bmap;
>  	struct xfs_bud_log_item		*budp;
>  	xfs_fsblock_t			startblock_fsb;
> @@ -478,12 +478,7 @@ xfs_bui_item_recover(
>  			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
>  	if (error)
>  		return error;
> -	/*
> -	 * Recovery stashes all deferred ops during intent processing and
> -	 * finishes them on completion. Transfer current dfops state to this
> -	 * transaction and transfer the result back before we return.
> -	 */
> -	xfs_defer_move(tp, parent_tp);
> +
>  	budp = xfs_trans_get_bud(tp, buip);
>  
>  	/* Grab the inode. */
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
>  
>  err_inode:
> -	xfs_defer_move(parent_tp, tp);
>  	xfs_trans_cancel(tp);
>  	if (ip) {
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 9093d2e7afdf..be0186875566 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -585,10 +585,10 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
>  STATIC int
>  xfs_efi_item_recover(
>  	struct xfs_log_item		*lip,
> -	struct xfs_trans		*parent_tp)
> +	struct list_head		*capture_list)
>  {
>  	struct xfs_efi_log_item		*efip = EFI_ITEM(lip);
> -	struct xfs_mount		*mp = parent_tp->t_mountp;
> +	struct xfs_mount		*mp = lip->li_mountp;
>  	struct xfs_efd_log_item		*efdp;
>  	struct xfs_trans		*tp;
>  	struct xfs_extent		*extp;
> @@ -627,8 +627,7 @@ xfs_efi_item_recover(
>  
>  	}
>  
> -	error = xfs_trans_commit(tp);
> -	return error;
> +	return xlog_recover_trans_commit(tp, capture_list);
>  
>  abort_error:
>  	xfs_trans_cancel(tp);
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e2ec91b2d0f4..79be1f02d1b4 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1791,6 +1791,19 @@ xlog_recover_release_intent(
>  	spin_unlock(&ailp->ail_lock);
>  }
>  
> +/*
> + * Freeze any deferred ops and commit the transaction.  This is the last step
> + * needed to finish a log intent item that we recovered from the log, and will
> + * take care of releasing all the relevant resources.
> + */
> +int
> +xlog_recover_trans_commit(
> +	struct xfs_trans		*tp,
> +	struct list_head		*capture_list)
> +{
> +	return xfs_defer_capture(tp, capture_list);
> +}
> +
>  /******************************************************************************
>   *
>   *		Log recover routines
> @@ -2467,38 +2480,62 @@ xlog_recover_process_data(
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
> +
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
> +		if (error)
> +			return error;
> +	}
> +
> +	return 0;
>  }
>  
>  /* Is this log item a deferred action intent? */
> @@ -2528,35 +2565,23 @@ STATIC int
>  xlog_recover_process_intents(
>  	struct xlog		*log)
>  {
> -	struct xfs_trans	*parent_tp;
> +	LIST_HEAD(capture_list);
>  	struct xfs_ail_cursor	cur;
>  	struct xfs_log_item	*lip;
>  	struct xfs_ail		*ailp;
> -	int			error;
> +	int			error = 0;
>  #if defined(DEBUG) || defined(XFS_WARN)
>  	xfs_lsn_t		last_lsn;
>  #endif
>  
> -	/*
> -	 * The intent recovery handlers commit transactions to complete recovery
> -	 * for individual intents, but any new deferred operations that are
> -	 * queued during that process are held off until the very end. The
> -	 * purpose of this transaction is to serve as a container for deferred
> -	 * operations. Each intent recovery handler must transfer dfops here
> -	 * before its local transaction commits, and we'll finish the entire
> -	 * list below.
> -	 */
> -	error = xfs_trans_alloc_empty(log->l_mp, &parent_tp);
> -	if (error)
> -		return error;
> -
>  	ailp = log->l_ailp;
>  	spin_lock(&ailp->ail_lock);
> -	lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
>  #if defined(DEBUG) || defined(XFS_WARN)
>  	last_lsn = xlog_assign_lsn(log->l_curr_cycle, log->l_curr_block);
>  #endif
> -	while (lip != NULL) {
> +	for (lip = xfs_trans_ail_cursor_first(ailp, &cur, 0);
> +	     lip != NULL;
> +	     lip = xfs_trans_ail_cursor_next(ailp, &cur)) {
>  		/*
>  		 * We're done when we see something other than an intent.
>  		 * There should be no intents left in the AIL now.
> @@ -2576,28 +2601,28 @@ xlog_recover_process_intents(
>  		 */
>  		ASSERT(XFS_LSN_CMP(last_lsn, lip->li_lsn) >= 0);
>  
> +		if (test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags))
> +			continue;
> +
>  		/*
>  		 * NOTE: If your intent processing routine can create more
> -		 * deferred ops, you /must/ attach them to the transaction in
> -		 * this routine or else those subsequent intents will get
> +		 * deferred ops, you /must/ attach them to the capture list in
> +		 * the recover routine or else those subsequent intents will be
>  		 * replayed in the wrong order!
>  		 */
> -		if (!test_and_set_bit(XFS_LI_RECOVERED, &lip->li_flags)) {
> -			spin_unlock(&ailp->ail_lock);
> -			error = lip->li_ops->iop_recover(lip, parent_tp);
> -			spin_lock(&ailp->ail_lock);
> -		}
> +		spin_unlock(&ailp->ail_lock);
> +		error = lip->li_ops->iop_recover(lip, &capture_list);
> +		spin_lock(&ailp->ail_lock);
>  		if (error)
> -			goto out;
> -		lip = xfs_trans_ail_cursor_next(ailp, &cur);
> +			break;
>  	}
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
>  
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 3e34b7662361..7a57b4de9ee7 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -424,7 +424,7 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
>  STATIC int
>  xfs_cui_item_recover(
>  	struct xfs_log_item		*lip,
> -	struct xfs_trans		*parent_tp)
> +	struct list_head		*capture_list)
>  {
>  	struct xfs_bmbt_irec		irec;
>  	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
> @@ -432,7 +432,7 @@ xfs_cui_item_recover(
>  	struct xfs_cud_log_item		*cudp;
>  	struct xfs_trans		*tp;
>  	struct xfs_btree_cur		*rcur = NULL;
> -	struct xfs_mount		*mp = parent_tp->t_mountp;
> +	struct xfs_mount		*mp = lip->li_mountp;
>  	xfs_fsblock_t			startblock_fsb;
>  	xfs_fsblock_t			new_fsb;
>  	xfs_extlen_t			new_len;
> @@ -487,12 +487,7 @@ xfs_cui_item_recover(
>  			mp->m_refc_maxlevels * 2, 0, XFS_TRANS_RESERVE, &tp);
>  	if (error)
>  		return error;
> -	/*
> -	 * Recovery stashes all deferred ops during intent processing and
> -	 * finishes them on completion. Transfer current dfops state to this
> -	 * transaction and transfer the result back before we return.
> -	 */
> -	xfs_defer_move(tp, parent_tp);
> +
>  	cudp = xfs_trans_get_cud(tp, cuip);
>  
>  	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
> @@ -549,13 +544,10 @@ xfs_cui_item_recover(
>  	}
>  
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> -	xfs_defer_capture(parent_tp, tp);
> -	error = xfs_trans_commit(tp);
> -	return error;
> +	return xlog_recover_trans_commit(tp, capture_list);
>  
>  abort_error:
>  	xfs_refcount_finish_one_cleanup(tp, rcur, error);
> -	xfs_defer_move(parent_tp, tp);
>  	xfs_trans_cancel(tp);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index e38ec5d736be..16c7a6385c3f 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -467,14 +467,14 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
>  STATIC int
>  xfs_rui_item_recover(
>  	struct xfs_log_item		*lip,
> -	struct xfs_trans		*parent_tp)
> +	struct list_head		*capture_list)
>  {
>  	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
>  	struct xfs_map_extent		*rmap;
>  	struct xfs_rud_log_item		*rudp;
>  	struct xfs_trans		*tp;
>  	struct xfs_btree_cur		*rcur = NULL;
> -	struct xfs_mount		*mp = parent_tp->t_mountp;
> +	struct xfs_mount		*mp = lip->li_mountp;
>  	xfs_fsblock_t			startblock_fsb;
>  	enum xfs_rmap_intent_type	type;
>  	xfs_exntst_t			state;
> @@ -567,8 +567,7 @@ xfs_rui_item_recover(
>  	}
>  
>  	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> -	error = xfs_trans_commit(tp);
> -	return error;
> +	return xlog_recover_trans_commit(tp, capture_list);
>  
>  abort_error:
>  	xfs_rmap_finish_one_cleanup(tp, rcur, error);
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index b752501818d2..b68272666ce1 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -74,7 +74,8 @@ struct xfs_item_ops {
>  	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
>  	void (*iop_release)(struct xfs_log_item *);
>  	xfs_lsn_t (*iop_committed)(struct xfs_log_item *, xfs_lsn_t);
> -	int (*iop_recover)(struct xfs_log_item *lip, struct xfs_trans *tp);
> +	int (*iop_recover)(struct xfs_log_item *lip,
> +			   struct list_head *capture_list);
>  	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
>  };
>  
> 

