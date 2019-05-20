Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38AF237C5
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 15:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730570AbfETNMf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 09:12:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730513AbfETNMf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 09:12:35 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2B40C1796;
        Mon, 20 May 2019 13:12:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C2BD0704DB;
        Mon, 20 May 2019 13:12:34 +0000 (UTC)
Date:   Mon, 20 May 2019 09:12:33 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/20] xfs: use a list_head for iclog callbacks
Message-ID: <20190520131232.GB31317@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-12-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 20 May 2019 13:12:35 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:10AM +0200, Christoph Hellwig wrote:
> Replace the hand grown linked list handling and cil context attachment
> with the standard list_head structure.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c      | 51 ++++++++-----------------------------------
>  fs/xfs/xfs_log.h      | 15 +++----------
>  fs/xfs/xfs_log_cil.c  | 31 ++++++++++++++++++++------
>  fs/xfs/xfs_log_priv.h | 10 +++------
>  4 files changed, 39 insertions(+), 68 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 1eb0938165fc..0d6fb374dbe8 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
...
> @@ -2828,26 +2801,20 @@ xlog_state_do_callback(
>  			 * callbacks being added.
>  			 */
>  			spin_lock(&iclog->ic_callback_lock);
> -			cb = iclog->ic_callback;
> -			while (cb) {
> -				iclog->ic_callback_tail = &(iclog->ic_callback);
> -				iclog->ic_callback = NULL;
> -				spin_unlock(&iclog->ic_callback_lock);
> +			while (!list_empty(&iclog->ic_callbacks)) {
> +				LIST_HEAD(tmp);
>  
> -				/* perform callbacks in the order given */
> -				for (; cb; cb = cb_next) {
> -					cb_next = cb->cb_next;
> -					cb->cb_func(cb->cb_arg, aborted);
> -				}
> +				list_splice_init(&iclog->ic_callbacks, &tmp);
> +
> +				spin_unlock(&iclog->ic_callback_lock);
> +				xlog_cil_process_commited(&tmp, aborted);

s/commited/committed/ please.

>  				spin_lock(&iclog->ic_callback_lock);
> -				cb = iclog->ic_callback;
>  			}
>  
...
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 4cb459f21ad4..b6b30b8e22af 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
...
> @@ -615,6 +614,20 @@ xlog_cil_committed(
>  		kmem_free(ctx);
>  }
>  
> +void
> +xlog_cil_process_commited(
> +	struct list_head	*list,
> +	bool			aborted)
> +{
> +	struct xfs_cil_ctx	*ctx;
> +
> +	while ((ctx = list_first_entry_or_null(list,

Are double braces necessary here?

> +			struct xfs_cil_ctx, iclog_entry))) {
> +		list_del(&ctx->iclog_entry);
> +		xlog_cil_committed(ctx, aborted);
> +	}
> +}
...
> @@ -837,11 +850,15 @@ xlog_cil_push(
>  		goto out_abort;
>  
>  	/* attach all the transactions w/ busy extents to iclog */

Any idea what this ^ comment means? ISTM it's misplaced or stale. If so,
we might as well toss/replace it.

With those nits fixed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -	ctx->log_cb.cb_func = xlog_cil_committed;
> -	ctx->log_cb.cb_arg = ctx;
> -	error = xfs_log_notify(commit_iclog, &ctx->log_cb);
> -	if (error)
> +	spin_lock(&commit_iclog->ic_callback_lock);
> +	if (commit_iclog->ic_state & XLOG_STATE_IOERROR) {
> +		spin_unlock(&commit_iclog->ic_callback_lock);
>  		goto out_abort;
> +	}
> +	ASSERT_ALWAYS(commit_iclog->ic_state == XLOG_STATE_ACTIVE ||
> +		      commit_iclog->ic_state == XLOG_STATE_WANT_SYNC);
> +	list_add_tail(&ctx->iclog_entry, &commit_iclog->ic_callbacks);
> +	spin_unlock(&commit_iclog->ic_callback_lock);
>  
>  	/*
>  	 * now the checkpoint commit is complete and we've attached the
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b5f82cb36202..5c188ccb8568 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -10,7 +10,6 @@ struct xfs_buf;
>  struct xlog;
>  struct xlog_ticket;
>  struct xfs_mount;
> -struct xfs_log_callback;
>  
>  /*
>   * Flags for log structure
> @@ -181,8 +180,6 @@ typedef struct xlog_ticket {
>   * - ic_next is the pointer to the next iclog in the ring.
>   * - ic_bp is a pointer to the buffer used to write this incore log to disk.
>   * - ic_log is a pointer back to the global log structure.
> - * - ic_callback is a linked list of callback function/argument pairs to be
> - *	called after an iclog finishes writing.
>   * - ic_size is the full size of the header plus data.
>   * - ic_offset is the current number of bytes written to in this iclog.
>   * - ic_refcnt is bumped when someone is writing to the log.
> @@ -193,7 +190,7 @@ typedef struct xlog_ticket {
>   * structure cacheline aligned. The following fields can be contended on
>   * by independent processes:
>   *
> - *	- ic_callback_*
> + *	- ic_callbacks
>   *	- ic_refcnt
>   *	- fields protected by the global l_icloglock
>   *
> @@ -216,8 +213,7 @@ typedef struct xlog_in_core {
>  
>  	/* Callback structures need their own cacheline */
>  	spinlock_t		ic_callback_lock ____cacheline_aligned_in_smp;
> -	struct xfs_log_callback	*ic_callback;
> -	struct xfs_log_callback	**ic_callback_tail;
> +	struct list_head	ic_callbacks;
>  
>  	/* reference counts need their own cacheline */
>  	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
> @@ -243,7 +239,7 @@ struct xfs_cil_ctx {
>  	int			space_used;	/* aggregate size of regions */
>  	struct list_head	busy_extents;	/* busy extents in chkpt */
>  	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
> -	struct xfs_log_callback	log_cb;		/* completion callback hook. */
> +	struct list_head	iclog_entry;
>  	struct list_head	committing;	/* ctx committing list */
>  	struct work_struct	discard_endio_work;
>  };
> -- 
> 2.20.1
> 
