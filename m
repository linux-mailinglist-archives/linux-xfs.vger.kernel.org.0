Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386CF7AA4DE
	for <lists+linux-xfs@lfdr.de>; Fri, 22 Sep 2023 00:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbjIUWXH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 21 Sep 2023 18:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbjIUWWy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 18:22:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D67188
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 15:22:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91151C433C7;
        Thu, 21 Sep 2023 22:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695334962;
        bh=rKVCQgr4R3OY6NOYF97eeai3brfJ8Uj1rs9BGQFxaQA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mhsFUnVPqEshwMMynz6lUayZ639XgG+zPoKdxEBQYN0j/7PijgYJPqTLluVEF1q/R
         CW5wSgnugerfkHCnlnAYH6eTfeL6xHaT8uzPq3oH6PV2WbdE+heTBjumM5x7yr+MQq
         7QV5CUHfZ38dTeVlg7/6CY/phRuWcsQYZP+EUETtmLLtoaO0JW3MgEs6LwhAtB4azg
         8kJSNqBGFE1GM95RIb8fowEkT2zw652MRZ6KrZp07y/nO7tTxQ+Vve4KUgK6syeqWx
         b4cQDBj9oL3G+Ft/V25g2TnUl6/MTmyUcnV3SIIkXZW1dhhf8FaVN17qXyvuYWkYfA
         SdwUDiSnanUhQ==
Date:   Thu, 21 Sep 2023 15:22:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: l_last_sync_lsn is really AIL state
Message-ID: <20230921222242.GE11391@frogsfrogsfrogs>
References: <20230921014844.582667-1-david@fromorbit.com>
 <20230921014844.582667-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921014844.582667-6-david@fromorbit.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2023 at 11:48:40AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The current implementation of xlog_assign_tail_lsn() assumes that
> when the AIL is empty, the log tail matches the LSN of the last
> written commit record. This is recorded in xlog_state_set_callback()
> as log->l_last_sync_lsn when the iclog state changes to
> XLOG_STATE_CALLBACK. This change is then immediately followed by
> running the callbacks on the iclog which then insert the log items
> into the AIL at the "commit lsn" of that checkpoint.
> 
> The AIL tracks log items via the start record LSN of the checkpoint,
> not the commit record LSN. THis is because we can pipeline multiple
> checkpoints, and so the start record of checkpoint N+1 can be
> written before the commit record of checkpoint N. i.e:
> 
>      start N			commit N
> 	+-------------+------------+----------------+
> 		  start N+1			commit N+1
> 
> The tail of the log cannot be moved to the LSN of commit N when all
> the items of that checkpoint are written back, because then the
> start record for N+1 is no longer in the active portion of the log
> and recovery will fail/corrupt the filesystem.
> 
> Hence when all the log items in checkpoint N are written back, the
> tail of the log most now only move as far forwards as the start LSN
> of checkpoint N+1.
> 
> Hence we cannot use the maximum start record LSN the AIL sees as a
> replacement the pointer to the current head of the on-disk log
> records. However, we currently only use the l_last_sync_lsn when the
> AIL is empty - when there is no start LSN remaining, the tail of the
> log moves to the LSN of the last commit record as this is where
> recovery needs to start searching for recoverable records. THe next
> checkpoint will have a start record LSN that is higher than
> l_last_sync_lsn, and so everything still works correctly when new
> checkpoints are written to an otherwise empty log.
> 
> l_last_sync_lsn is an atomic variable because it is currently
> updated when an iclog with callbacks attached moves to the CALLBACK
> state. While we hold the icloglock at this point, we don't hold the
> AIL lock. When we assign the log tail, we hold the AIL lock, not the
> icloglock because we have to look up the AIL. Hence it is an atomic
> variable so it's not bound to a specific lock context.
> 
> However, the iclog callbacks are only used for CIL checkpoints. We
> don't use callbacks with unmount record writes, so the
> l_last_sync_lsn variable only gets updated when we are processing
> CIL checkpoint callbacks. And those callbacks run under AIL lock
> contexts, not icloglock context. The CIL checkpoint already knows
> what the LSN of the iclog the commit record was written to (obtained
> when written into the iclog before submission) and so we can update
> the l_last_sync_lsn under the AIL lock in this callback. No other
> iclog callbacks will run until the currently executing one
> completes, and hence we can update the l_last_sync_lsn under the AIL
> lock safely.
> 
> This means l_last_sync_lsn can move to the AIL as the "ail_head_lsn"
> and it can be used to replace the atomic l_last_sync_lsn in the
> iclog code. This makes tracking the log tail belong entirely to the
> AIL, rather than being smeared across log, iclog and AIL state and
> locking.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Same dumb complaint about "THis is because we can pipeline..." as last
time:

https://lore.kernel.org/linux-xfs/YwlG7tLjgq3hdogK@magnolia/ 

With that typo fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log.c         | 81 +++++-----------------------------------
>  fs/xfs/xfs_log_cil.c     | 54 ++++++++++++++++++++-------
>  fs/xfs/xfs_log_priv.h    |  9 ++---
>  fs/xfs/xfs_log_recover.c | 19 +++++-----
>  fs/xfs/xfs_trace.c       |  1 +
>  fs/xfs/xfs_trace.h       |  8 ++--
>  fs/xfs/xfs_trans_ail.c   | 26 +++++++++++--
>  fs/xfs/xfs_trans_priv.h  | 13 +++++++
>  8 files changed, 102 insertions(+), 109 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index b6db74de02e1..2ceadee276e2 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1230,47 +1230,6 @@ xfs_log_cover(
>  	return error;
>  }
>  
> -/*
> - * We may be holding the log iclog lock upon entering this routine.
> - */
> -xfs_lsn_t
> -xlog_assign_tail_lsn_locked(
> -	struct xfs_mount	*mp)
> -{
> -	struct xlog		*log = mp->m_log;
> -	struct xfs_log_item	*lip;
> -	xfs_lsn_t		tail_lsn;
> -
> -	assert_spin_locked(&mp->m_ail->ail_lock);
> -
> -	/*
> -	 * To make sure we always have a valid LSN for the log tail we keep
> -	 * track of the last LSN which was committed in log->l_last_sync_lsn,
> -	 * and use that when the AIL was empty.
> -	 */
> -	lip = xfs_ail_min(mp->m_ail);
> -	if (lip)
> -		tail_lsn = lip->li_lsn;
> -	else
> -		tail_lsn = atomic64_read(&log->l_last_sync_lsn);
> -	trace_xfs_log_assign_tail_lsn(log, tail_lsn);
> -	atomic64_set(&log->l_tail_lsn, tail_lsn);
> -	return tail_lsn;
> -}
> -
> -xfs_lsn_t
> -xlog_assign_tail_lsn(
> -	struct xfs_mount	*mp)
> -{
> -	xfs_lsn_t		tail_lsn;
> -
> -	spin_lock(&mp->m_ail->ail_lock);
> -	tail_lsn = xlog_assign_tail_lsn_locked(mp);
> -	spin_unlock(&mp->m_ail->ail_lock);
> -
> -	return tail_lsn;
> -}
> -
>  /*
>   * Return the space in the log between the tail and the head.  The head
>   * is passed in the cycle/bytes formal parms.  In the special case where
> @@ -1504,7 +1463,6 @@ xlog_alloc_log(
>  	log->l_prev_block  = -1;
>  	/* log->l_tail_lsn = 0x100000000LL; cycle = 1; current block = 0 */
>  	xlog_assign_atomic_lsn(&log->l_tail_lsn, 1, 0);
> -	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
>  	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
>  
>  	if (xfs_has_logv2(mp) && mp->m_sb.sb_logsunit > 1)
> @@ -2552,44 +2510,23 @@ xlog_get_lowest_lsn(
>  	return lowest_lsn;
>  }
>  
> -/*
> - * Completion of a iclog IO does not imply that a transaction has completed, as
> - * transactions can be large enough to span many iclogs. We cannot change the
> - * tail of the log half way through a transaction as this may be the only
> - * transaction in the log and moving the tail to point to the middle of it
> - * will prevent recovery from finding the start of the transaction. Hence we
> - * should only update the last_sync_lsn if this iclog contains transaction
> - * completion callbacks on it.
> - *
> - * We have to do this before we drop the icloglock to ensure we are the only one
> - * that can update it.
> - *
> - * If we are moving the last_sync_lsn forwards, we also need to ensure we kick
> - * the reservation grant head pushing. This is due to the fact that the push
> - * target is bound by the current last_sync_lsn value. Hence if we have a large
> - * amount of log space bound up in this committing transaction then the
> - * last_sync_lsn value may be the limiting factor preventing tail pushing from
> - * freeing space in the log. Hence once we've updated the last_sync_lsn we
> - * should push the AIL to ensure the push target (and hence the grant head) is
> - * no longer bound by the old log head location and can move forwards and make
> - * progress again.
> - */
>  static void
>  xlog_state_set_callback(
>  	struct xlog		*log,
>  	struct xlog_in_core	*iclog,
>  	xfs_lsn_t		header_lsn)
>  {
> +	/*
> +	 * If there are no callbacks on this iclog, we can mark it clean
> +	 * immediately and return. Otherwise we need to run the
> +	 * callbacks.
> +	 */
> +	if (list_empty(&iclog->ic_callbacks)) {
> +		xlog_state_clean_iclog(log, iclog);
> +		return;
> +	}
>  	trace_xlog_iclog_callback(iclog, _RET_IP_);
>  	iclog->ic_state = XLOG_STATE_CALLBACK;
> -
> -	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
> -			   header_lsn) <= 0);
> -
> -	if (list_empty_careful(&iclog->ic_callbacks))
> -		return;
> -
> -	atomic64_set(&log->l_last_sync_lsn, header_lsn);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index c1fee14be5c2..1bedf03d863c 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -722,6 +722,24 @@ xlog_cil_ail_insert_batch(
>   * items into the the AIL. This uses bulk insertion techniques to minimise AIL
>   * lock traffic.
>   *
> + * The AIL tracks log items via the start record LSN of the checkpoint,
> + * not the commit record LSN. This is because we can pipeline multiple
> + * checkpoints, and so the start record of checkpoint N+1 can be
> + * written before the commit record of checkpoint N. i.e:
> + *
> + *   start N			commit N
> + *	+-------------+------------+----------------+
> + *		  start N+1			commit N+1
> + *
> + * The tail of the log cannot be moved to the LSN of commit N when all
> + * the items of that checkpoint are written back, because then the
> + * start record for N+1 is no longer in the active portion of the log
> + * and recovery will fail/corrupt the filesystem.
> + *
> + * Hence when all the log items in checkpoint N are written back, the
> + * tail of the log most now only move as far forwards as the start LSN
> + * of checkpoint N+1.
> + *
>   * If we are called with the aborted flag set, it is because a log write during
>   * a CIL checkpoint commit has failed. In this case, all the items in the
>   * checkpoint have already gone through iop_committed and iop_committing, which
> @@ -739,24 +757,33 @@ xlog_cil_ail_insert_batch(
>   */
>  static void
>  xlog_cil_ail_insert(
> -	struct xlog		*log,
> -	struct list_head	*lv_chain,
> -	xfs_lsn_t		commit_lsn,
> +	struct xfs_cil_ctx	*ctx,
>  	bool			aborted)
>  {
>  #define LOG_ITEM_BATCH_SIZE	32
> -	struct xfs_ail		*ailp = log->l_ailp;
> +	struct xfs_ail		*ailp = ctx->cil->xc_log->l_ailp;
>  	struct xfs_log_item	*log_items[LOG_ITEM_BATCH_SIZE];
>  	struct xfs_log_vec	*lv;
>  	struct xfs_ail_cursor	cur;
>  	int			i = 0;
>  
> +	/*
> +	 * Update the AIL head LSN with the commit record LSN of this
> +	 * checkpoint. As iclogs are always completed in order, this should
> +	 * always be the same (as iclogs can contain multiple commit records) or
> +	 * higher LSN than the current head. We do this before insertion of the
> +	 * items so that log space checks during insertion will reflect the
> +	 * space that this checkpoint has already consumed.
> +	 */
> +	ASSERT(XFS_LSN_CMP(ctx->commit_lsn, ailp->ail_head_lsn) >= 0 ||
> +			aborted);
>  	spin_lock(&ailp->ail_lock);
> -	xfs_trans_ail_cursor_last(ailp, &cur, commit_lsn);
> +	ailp->ail_head_lsn = ctx->commit_lsn;
> +	xfs_trans_ail_cursor_last(ailp, &cur, ctx->start_lsn);
>  	spin_unlock(&ailp->ail_lock);
>  
>  	/* unpin all the log items */
> -	list_for_each_entry(lv, lv_chain, lv_list) {
> +	list_for_each_entry(lv, &ctx->lv_chain, lv_list) {
>  		struct xfs_log_item	*lip = lv->lv_item;
>  		xfs_lsn_t		item_lsn;
>  
> @@ -769,9 +796,10 @@ xlog_cil_ail_insert(
>  		}
>  
>  		if (lip->li_ops->iop_committed)
> -			item_lsn = lip->li_ops->iop_committed(lip, commit_lsn);
> +			item_lsn = lip->li_ops->iop_committed(lip,
> +					ctx->start_lsn);
>  		else
> -			item_lsn = commit_lsn;
> +			item_lsn = ctx->start_lsn;
>  
>  		/* item_lsn of -1 means the item needs no further processing */
>  		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
> @@ -788,7 +816,7 @@ xlog_cil_ail_insert(
>  			continue;
>  		}
>  
> -		if (item_lsn != commit_lsn) {
> +		if (item_lsn != ctx->start_lsn) {
>  
>  			/*
>  			 * Not a bulk update option due to unusual item_lsn.
> @@ -811,14 +839,15 @@ xlog_cil_ail_insert(
>  		log_items[i++] = lv->lv_item;
>  		if (i >= LOG_ITEM_BATCH_SIZE) {
>  			xlog_cil_ail_insert_batch(ailp, &cur, log_items,
> -					LOG_ITEM_BATCH_SIZE, commit_lsn);
> +					LOG_ITEM_BATCH_SIZE, ctx->start_lsn);
>  			i = 0;
>  		}
>  	}
>  
>  	/* make sure we insert the remainder! */
>  	if (i)
> -		xlog_cil_ail_insert_batch(ailp, &cur, log_items, i, commit_lsn);
> +		xlog_cil_ail_insert_batch(ailp, &cur, log_items, i,
> +				ctx->start_lsn);
>  
>  	spin_lock(&ailp->ail_lock);
>  	xfs_trans_ail_cursor_done(&cur);
> @@ -934,8 +963,7 @@ xlog_cil_committed(
>  		spin_unlock(&ctx->cil->xc_push_lock);
>  	}
>  
> -	xlog_cil_ail_insert(ctx->cil->xc_log, &ctx->lv_chain,
> -					ctx->start_lsn, abort);
> +	xlog_cil_ail_insert(ctx, abort);
>  
>  	xfs_extent_busy_sort(&ctx->busy_extents);
>  	xfs_extent_busy_clear(mp, &ctx->busy_extents,
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 01c333f712ae..106483cf1fb6 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -429,13 +429,10 @@ struct xlog {
>  	int			l_prev_block;   /* previous logical log block */
>  
>  	/*
> -	 * l_last_sync_lsn and l_tail_lsn are atomics so they can be set and
> -	 * read without needing to hold specific locks. To avoid operations
> -	 * contending with other hot objects, place each of them on a separate
> -	 * cacheline.
> +	 * l_tail_lsn is atomic so it can be set and read without needing to
> +	 * hold specific locks. To avoid operations contending with other hot
> +	 * objects, it on a separate cacheline.
>  	 */
> -	/* lsn of last LR on disk */
> -	atomic64_t		l_last_sync_lsn ____cacheline_aligned_in_smp;
>  	/* lsn of 1st LR with unflushed * buffers */
>  	atomic64_t		l_tail_lsn ____cacheline_aligned_in_smp;
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 13b94d2e605b..8d963c3db4f3 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -1177,8 +1177,8 @@ xlog_check_unmount_rec(
>  			 */
>  			xlog_assign_atomic_lsn(&log->l_tail_lsn,
>  					log->l_curr_cycle, after_umount_blk);
> -			xlog_assign_atomic_lsn(&log->l_last_sync_lsn,
> -					log->l_curr_cycle, after_umount_blk);
> +			log->l_ailp->ail_head_lsn =
> +					atomic64_read(&log->l_tail_lsn);
>  			*tail_blk = after_umount_blk;
>  
>  			*clean = true;
> @@ -1212,7 +1212,7 @@ xlog_set_state(
>  	if (bump_cycle)
>  		log->l_curr_cycle++;
>  	atomic64_set(&log->l_tail_lsn, be64_to_cpu(rhead->h_tail_lsn));
> -	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(rhead->h_lsn));
> +	log->l_ailp->ail_head_lsn = be64_to_cpu(rhead->h_lsn);
>  	xlog_assign_grant_head(&log->l_reserve_head.grant, log->l_curr_cycle,
>  					BBTOB(log->l_curr_block));
>  	xlog_assign_grant_head(&log->l_write_head.grant, log->l_curr_cycle,
> @@ -3299,14 +3299,13 @@ xlog_do_recover(
>  
>  	/*
>  	 * We now update the tail_lsn since much of the recovery has completed
> -	 * and there may be space available to use.  If there were no extent
> -	 * or iunlinks, we can free up the entire log and set the tail_lsn to
> -	 * be the last_sync_lsn.  This was set in xlog_find_tail to be the
> -	 * lsn of the last known good LR on disk.  If there are extent frees
> -	 * or iunlinks they will have some entries in the AIL; so we look at
> -	 * the AIL to determine how to set the tail_lsn.
> +	 * and there may be space available to use.  If there were no extent or
> +	 * iunlinks, we can free up the entire log.  This was set in
> +	 * xlog_find_tail to be the lsn of the last known good LR on disk.  If
> +	 * there are extent frees or iunlinks they will have some entries in the
> +	 * AIL; so we look at the AIL to determine how to set the tail_lsn.
>  	 */
> -	xlog_assign_tail_lsn(mp);
> +	xfs_ail_assign_tail_lsn(log->l_ailp);
>  
>  	/*
>  	 * Now that we've finished replaying all buffer and inode updates,
> diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
> index 8a5dc1538aa8..2bf489b445ee 100644
> --- a/fs/xfs/xfs_trace.c
> +++ b/fs/xfs/xfs_trace.c
> @@ -22,6 +22,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_log.h"
>  #include "xfs_log_priv.h"
> +#include "xfs_trans_priv.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_quota.h"
>  #include "xfs_dquot_item.h"
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 3926cf7f2a6e..784c6d63daa9 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -1388,19 +1388,19 @@ TRACE_EVENT(xfs_log_assign_tail_lsn,
>  		__field(dev_t, dev)
>  		__field(xfs_lsn_t, new_lsn)
>  		__field(xfs_lsn_t, old_lsn)
> -		__field(xfs_lsn_t, last_sync_lsn)
> +		__field(xfs_lsn_t, head_lsn)
>  	),
>  	TP_fast_assign(
>  		__entry->dev = log->l_mp->m_super->s_dev;
>  		__entry->new_lsn = new_lsn;
>  		__entry->old_lsn = atomic64_read(&log->l_tail_lsn);
> -		__entry->last_sync_lsn = atomic64_read(&log->l_last_sync_lsn);
> +		__entry->head_lsn = log->l_ailp->ail_head_lsn;
>  	),
> -	TP_printk("dev %d:%d new tail lsn %d/%d, old lsn %d/%d, last sync %d/%d",
> +	TP_printk("dev %d:%d new tail lsn %d/%d, old lsn %d/%d, head lsn %d/%d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  CYCLE_LSN(__entry->new_lsn), BLOCK_LSN(__entry->new_lsn),
>  		  CYCLE_LSN(__entry->old_lsn), BLOCK_LSN(__entry->old_lsn),
> -		  CYCLE_LSN(__entry->last_sync_lsn), BLOCK_LSN(__entry->last_sync_lsn))
> +		  CYCLE_LSN(__entry->head_lsn), BLOCK_LSN(__entry->head_lsn))
>  )
>  
>  DECLARE_EVENT_CLASS(xfs_file_class,
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index e31bfeb01375..4fa7f2f77563 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -715,6 +715,26 @@ xfs_ail_push_all_sync(
>  	finish_wait(&ailp->ail_empty, &wait);
>  }
>  
> +void
> +__xfs_ail_assign_tail_lsn(
> +	struct xfs_ail		*ailp)
> +{
> +	struct xlog		*log = ailp->ail_log;
> +	xfs_lsn_t		tail_lsn;
> +
> +	assert_spin_locked(&ailp->ail_lock);
> +
> +	if (xlog_is_shutdown(log))
> +		return;
> +
> +	tail_lsn = __xfs_ail_min_lsn(ailp);
> +	if (!tail_lsn)
> +		tail_lsn = ailp->ail_head_lsn;
> +
> +	trace_xfs_log_assign_tail_lsn(log, tail_lsn);
> +	atomic64_set(&log->l_tail_lsn, tail_lsn);
> +}
> +
>  /*
>   * Callers should pass the the original tail lsn so that we can detect if the
>   * tail has moved as a result of the operation that was performed. If the caller
> @@ -729,15 +749,13 @@ xfs_ail_update_finish(
>  {
>  	struct xlog		*log = ailp->ail_log;
>  
> -	/* if the tail lsn hasn't changed, don't do updates or wakeups. */
> +	/* If the tail lsn hasn't changed, don't do updates or wakeups. */
>  	if (!old_lsn || old_lsn == __xfs_ail_min_lsn(ailp)) {
>  		spin_unlock(&ailp->ail_lock);
>  		return;
>  	}
>  
> -	if (!xlog_is_shutdown(log))
> -		xlog_assign_tail_lsn_locked(log->l_mp);
> -
> +	__xfs_ail_assign_tail_lsn(ailp);
>  	if (list_empty(&ailp->ail_head))
>  		wake_up_all(&ailp->ail_empty);
>  	spin_unlock(&ailp->ail_lock);
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 9a131e7fae94..6541a6c3ea22 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -55,6 +55,7 @@ struct xfs_ail {
>  	struct list_head	ail_cursors;
>  	spinlock_t		ail_lock;
>  	xfs_lsn_t		ail_last_pushed_lsn;
> +	xfs_lsn_t		ail_head_lsn;
>  	int			ail_log_flush;
>  	unsigned long		ail_opstate;
>  	struct list_head	ail_buf_list;
> @@ -135,6 +136,18 @@ struct xfs_log_item *	xfs_trans_ail_cursor_next(struct xfs_ail *ailp,
>  					struct xfs_ail_cursor *cur);
>  void			xfs_trans_ail_cursor_done(struct xfs_ail_cursor *cur);
>  
> +void			__xfs_ail_assign_tail_lsn(struct xfs_ail *ailp);
> +
> +static inline void
> +xfs_ail_assign_tail_lsn(
> +	struct xfs_ail		*ailp)
> +{
> +
> +	spin_lock(&ailp->ail_lock);
> +	__xfs_ail_assign_tail_lsn(ailp);
> +	spin_unlock(&ailp->ail_lock);
> +}
> +
>  #if BITS_PER_LONG != 64
>  static inline void
>  xfs_trans_ail_copy_lsn(
> -- 
> 2.40.1
> 
