Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD73421996
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 16:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfEQOI4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 10:08:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59828 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729043AbfEQOI4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 10:08:56 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A3F1B75733;
        Fri, 17 May 2019 14:08:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BB4810027C2;
        Fri, 17 May 2019 14:08:55 +0000 (UTC)
Date:   Fri, 17 May 2019 10:08:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/20] xfs: don't use xfs_trans_free_items in the commit
 path
Message-ID: <20190517140853.GF7888@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-7-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 17 May 2019 14:08:55 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:05AM +0200, Christoph Hellwig wrote:
> While commiting items looks very similar to freeing them on error it is
> a different operation, and they will diverge a bit soon.
> 
> Split out the commit case from xfs_trans_free_items, inline it into
> xfs_log_commit_cil and give it a separate trace point.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_cil.c    | 13 ++++++++++---
>  fs/xfs/xfs_trace.h      |  1 +
>  fs/xfs/xfs_trans.c      | 10 +++-------
>  fs/xfs/xfs_trans_priv.h |  2 --
>  4 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 49f37905c7a7..c856bfce5bf2 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -985,6 +985,7 @@ xfs_log_commit_cil(
>  {
>  	struct xlog		*log = mp->m_log;
>  	struct xfs_cil		*cil = log->l_cilp;
> +	struct xfs_log_item	*lip, *next;
>  	xfs_lsn_t		xc_commit_lsn;
>  
>  	/*
> @@ -1009,7 +1010,7 @@ xfs_log_commit_cil(
>  
>  	/*
>  	 * Once all the items of the transaction have been copied to the CIL,
> -	 * the items can be unlocked and freed.
> +	 * the items can be unlocked and possibly freed.
>  	 *
>  	 * This needs to be done before we drop the CIL context lock because we
>  	 * have to update state in the log items and unlock them before they go
> @@ -1018,8 +1019,14 @@ xfs_log_commit_cil(
>  	 * the log items. This affects (at least) processing of stale buffers,
>  	 * inodes and EFIs.
>  	 */
> -	xfs_trans_free_items(tp, xc_commit_lsn, false);
> -
> +	trace_xfs_trans_commit_items(tp, _RET_IP_);
> +	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
> +		xfs_trans_del_item(lip);
> +		if (lip->li_ops->iop_committing)
> +			lip->li_ops->iop_committing(lip, xc_commit_lsn);
> +		if (lip->li_ops->iop_unlock)
> +			lip->li_ops->iop_unlock(lip);
> +	}
>  	xlog_cil_push_background(log);
>  
>  	up_read(&cil->xc_ctx_lock);
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 2464ea351f83..195a9cdb954e 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3360,6 +3360,7 @@ DEFINE_TRANS_EVENT(xfs_trans_dup);
>  DEFINE_TRANS_EVENT(xfs_trans_free);
>  DEFINE_TRANS_EVENT(xfs_trans_roll);
>  DEFINE_TRANS_EVENT(xfs_trans_add_item);
> +DEFINE_TRANS_EVENT(xfs_trans_commit_items);
>  DEFINE_TRANS_EVENT(xfs_trans_free_items);
>  
>  TRACE_EVENT(xfs_iunlink_update_bucket,
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index ed7547b9f66b..4ed5d032b26f 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -767,10 +767,9 @@ xfs_trans_del_item(
>  }
>  
>  /* Detach and unlock all of the items in a transaction */
> -void
> +static void
>  xfs_trans_free_items(
>  	struct xfs_trans	*tp,
> -	xfs_lsn_t		commit_lsn,
>  	bool			abort)
>  {
>  	struct xfs_log_item	*lip, *next;
> @@ -779,9 +778,6 @@ xfs_trans_free_items(
>  
>  	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
>  		xfs_trans_del_item(lip);
> -		if (commit_lsn != NULLCOMMITLSN &&
> -		    lip->li_ops->iop_committing)
> -			lip->li_ops->iop_committing(lip, commit_lsn);
>  		if (abort)
>  			set_bit(XFS_LI_ABORTED, &lip->li_flags);
>  
> @@ -1007,7 +1003,7 @@ __xfs_trans_commit(
>  		tp->t_ticket = NULL;
>  	}
>  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
> -	xfs_trans_free_items(tp, NULLCOMMITLSN, !!error);
> +	xfs_trans_free_items(tp, !!error);
>  	xfs_trans_free(tp);
>  
>  	XFS_STATS_INC(mp, xs_trans_empty);
> @@ -1069,7 +1065,7 @@ xfs_trans_cancel(
>  	/* mark this thread as no longer being in a transaction */
>  	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
>  
> -	xfs_trans_free_items(tp, NULLCOMMITLSN, dirty);
> +	xfs_trans_free_items(tp, dirty);
>  	xfs_trans_free(tp);
>  }
>  
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 091eae9f4e74..bef1ebf933ed 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -16,8 +16,6 @@ struct xfs_log_vec;
>  void	xfs_trans_init(struct xfs_mount *);
>  void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
>  void	xfs_trans_del_item(struct xfs_log_item *);
> -void	xfs_trans_free_items(struct xfs_trans *tp, xfs_lsn_t commit_lsn,
> -				bool abort);
>  void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
>  
>  void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *lv,
> -- 
> 2.20.1
> 
