Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6150721CEF
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 19:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbfEQR62 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 13:58:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728225AbfEQR61 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 13:58:27 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8D2FC9D406;
        Fri, 17 May 2019 17:49:18 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FFFF1001E73;
        Fri, 17 May 2019 17:49:17 +0000 (UTC)
Date:   Fri, 17 May 2019 13:49:16 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/20] xfs: split iop_unlock
Message-ID: <20190517174915.GG7888@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-8-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 17 May 2019 17:49:18 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:06AM +0200, Christoph Hellwig wrote:
> The iop_unlock is not only misnamed, but also causes deeper problems.
> We call the method when either comitting a transaction, or when freeing
> items on a cancelled transaction.  Various item implementations try
> to distinguish the cases by checking the XFS_LI_ABORTED flag, but that
> is only set if the cancelled transaction was dirty.  That leads to
> possible leaks of items when cancelling a clean transaction.  The only
> thing saving us there is that cancelling clean transactions with
> attached items is incredibly rare, if we do it at all.
> 

Refactoring aside, I see that the majority of this patch is focused on
intent log item implementations. I don't think an item leak is possible
here because we intentionally dirty transactions when either an intent
or done item is logged. See xfs_extent_free_log_item() and
xfs_trans_free_extent() for examples associated with the EFI/EFD items.

On one hand this logic supports the current item reference counting
logic (for example, so we know whether to drop the log's reference to an
EFI on transaction abort or wait until physical log commit time). On the
other hand, the items themselves must be logged to disk so we have to
mark them dirty (along with the transaction on behalf of the item) for
that reason as well. FWIW, I do think the current approach of adding the
intent item and dirtying it separately is slightly confusing,
particularly since I'm not sure we have any valid use case to have a
clean intent/done item in a transaction.

I suppose this kind of refactoring might still make sense on its own if
the resulting code is more clear or streamlined. I.e., perhaps there's
no need for the separate ->iop_committing() and ->iop_unlock() callbacks
invoked one after the other. That said, I think the commit log should
probably be updated to focus on that (unless I'm missing something about
the potential leak). Hm?

Brian

> This patch replaces iop_unlock with a new iop_release method just for
> releasing items on a transaction cancellation, and overloads the
> existing iop_committing method with the commit path behavior that only
> a few item implementations need to start with.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_bmap_item.c     | 17 +++++++----------
>  fs/xfs/xfs_buf_item.c      | 15 ++++++++++++---
>  fs/xfs/xfs_dquot_item.c    | 19 +++++++++++--------
>  fs/xfs/xfs_extfree_item.c  | 17 +++++++----------
>  fs/xfs/xfs_icreate_item.c  | 10 +++-------
>  fs/xfs/xfs_inode_item.c    | 11 ++++++-----
>  fs/xfs/xfs_log_cil.c       |  2 --
>  fs/xfs/xfs_refcount_item.c | 17 +++++++----------
>  fs/xfs/xfs_rmap_item.c     | 17 +++++++----------
>  fs/xfs/xfs_trace.h         |  2 +-
>  fs/xfs/xfs_trans.c         |  7 +++----
>  fs/xfs/xfs_trans.h         |  4 ++--
>  fs/xfs/xfs_trans_buf.c     |  2 +-
>  13 files changed, 67 insertions(+), 73 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 8e57df6d5581..56c1ab161f3b 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -119,11 +119,10 @@ xfs_bui_item_unpin(
>   * constructed and thus we free the BUI here directly.
>   */
>  STATIC void
> -xfs_bui_item_unlock(
> +xfs_bui_item_release(
>  	struct xfs_log_item	*lip)
>  {
> -	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
> -		xfs_bui_release(BUI_ITEM(lip));
> +	xfs_bui_release(BUI_ITEM(lip));
>  }
>  
>  /*
> @@ -133,7 +132,7 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
>  	.iop_size	= xfs_bui_item_size,
>  	.iop_format	= xfs_bui_item_format,
>  	.iop_unpin	= xfs_bui_item_unpin,
> -	.iop_unlock	= xfs_bui_item_unlock,
> +	.iop_release	= xfs_bui_item_release,
>  };
>  
>  /*
> @@ -200,15 +199,13 @@ xfs_bud_item_format(
>   * BUD.
>   */
>  STATIC void
> -xfs_bud_item_unlock(
> +xfs_bud_item_release(
>  	struct xfs_log_item	*lip)
>  {
>  	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
>  
> -	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
> -		xfs_bui_release(budp->bud_buip);
> -		kmem_zone_free(xfs_bud_zone, budp);
> -	}
> +	xfs_bui_release(budp->bud_buip);
> +	kmem_zone_free(xfs_bud_zone, budp);
>  }
>  
>  /*
> @@ -242,7 +239,7 @@ xfs_bud_item_committed(
>  static const struct xfs_item_ops xfs_bud_item_ops = {
>  	.iop_size	= xfs_bud_item_size,
>  	.iop_format	= xfs_bud_item_format,
> -	.iop_unlock	= xfs_bud_item_unlock,
> +	.iop_release	= xfs_bud_item_release,
>  	.iop_committed	= xfs_bud_item_committed,
>  };
>  
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 3e0d5845e47b..7193ee9ca5b8 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -594,7 +594,7 @@ xfs_buf_item_put(
>   * free the item.
>   */
>  STATIC void
> -xfs_buf_item_unlock(
> +xfs_buf_item_release(
>  	struct xfs_log_item	*lip)
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
> @@ -609,7 +609,7 @@ xfs_buf_item_unlock(
>  						   &lip->li_flags);
>  #endif
>  
> -	trace_xfs_buf_item_unlock(bip);
> +	trace_xfs_buf_item_release(bip);
>  
>  	/*
>  	 * The bli dirty state should match whether the blf has logged segments
> @@ -639,6 +639,14 @@ xfs_buf_item_unlock(
>  	xfs_buf_relse(bp);
>  }
>  
> +STATIC void
> +xfs_buf_item_committing(
> +	struct xfs_log_item	*lip,
> +	xfs_lsn_t		commit_lsn)
> +{
> +	return xfs_buf_item_release(lip);
> +}
> +
>  /*
>   * This is called to find out where the oldest active copy of the
>   * buf log item in the on disk log resides now that the last log
> @@ -679,7 +687,8 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
>  	.iop_format	= xfs_buf_item_format,
>  	.iop_pin	= xfs_buf_item_pin,
>  	.iop_unpin	= xfs_buf_item_unpin,
> -	.iop_unlock	= xfs_buf_item_unlock,
> +	.iop_release	= xfs_buf_item_release,
> +	.iop_committing	= xfs_buf_item_committing,
>  	.iop_committed	= xfs_buf_item_committed,
>  	.iop_push	= xfs_buf_item_push,
>  };
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index a61a8a770d7f..b8fd81641dfc 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -197,14 +197,8 @@ xfs_qm_dquot_logitem_push(
>  	return rval;
>  }
>  
> -/*
> - * Unlock the dquot associated with the log item.
> - * Clear the fields of the dquot and dquot log item that
> - * are specific to the current transaction.  If the
> - * hold flags is set, do not unlock the dquot.
> - */
>  STATIC void
> -xfs_qm_dquot_logitem_unlock(
> +xfs_qm_dquot_logitem_release(
>  	struct xfs_log_item	*lip)
>  {
>  	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
> @@ -220,6 +214,14 @@ xfs_qm_dquot_logitem_unlock(
>  	xfs_dqunlock(dqp);
>  }
>  
> +STATIC void
> +xfs_qm_dquot_logitem_committing(
> +	struct xfs_log_item	*lip,
> +	xfs_lsn_t		commit_lsn)
> +{
> +	return xfs_qm_dquot_logitem_release(lip);
> +}
> +
>  /*
>   * This is the ops vector for dquots
>   */
> @@ -228,7 +230,8 @@ static const struct xfs_item_ops xfs_dquot_item_ops = {
>  	.iop_format	= xfs_qm_dquot_logitem_format,
>  	.iop_pin	= xfs_qm_dquot_logitem_pin,
>  	.iop_unpin	= xfs_qm_dquot_logitem_unpin,
> -	.iop_unlock	= xfs_qm_dquot_logitem_unlock,
> +	.iop_release	= xfs_qm_dquot_logitem_release,
> +	.iop_committing	= xfs_qm_dquot_logitem_committing,
>  	.iop_push	= xfs_qm_dquot_logitem_push,
>  	.iop_error	= xfs_dquot_item_error
>  };
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 655ed0445750..a73a3cff8502 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -129,11 +129,10 @@ xfs_efi_item_unpin(
>   * constructed and thus we free the EFI here directly.
>   */
>  STATIC void
> -xfs_efi_item_unlock(
> +xfs_efi_item_release(
>  	struct xfs_log_item	*lip)
>  {
> -	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
> -		xfs_efi_release(EFI_ITEM(lip));
> +	xfs_efi_release(EFI_ITEM(lip));
>  }
>  
>  /*
> @@ -143,7 +142,7 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
>  	.iop_size	= xfs_efi_item_size,
>  	.iop_format	= xfs_efi_item_format,
>  	.iop_unpin	= xfs_efi_item_unpin,
> -	.iop_unlock	= xfs_efi_item_unlock,
> +	.iop_release	= xfs_efi_item_release,
>  };
>  
>  
> @@ -299,15 +298,13 @@ xfs_efd_item_format(
>   * the transaction is cancelled, drop our reference to the EFI and free the EFD.
>   */
>  STATIC void
> -xfs_efd_item_unlock(
> +xfs_efd_item_release(
>  	struct xfs_log_item	*lip)
>  {
>  	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
>  
> -	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
> -		xfs_efi_release(efdp->efd_efip);
> -		xfs_efd_item_free(efdp);
> -	}
> +	xfs_efi_release(efdp->efd_efip);
> +	xfs_efd_item_free(efdp);
>  }
>  
>  /*
> @@ -341,7 +338,7 @@ xfs_efd_item_committed(
>  static const struct xfs_item_ops xfs_efd_item_ops = {
>  	.iop_size	= xfs_efd_item_size,
>  	.iop_format	= xfs_efd_item_format,
> -	.iop_unlock	= xfs_efd_item_unlock,
> +	.iop_release	= xfs_efd_item_release,
>  	.iop_committed	= xfs_efd_item_committed,
>  };
>  
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index cbaabc55f0c9..9aceb35dce24 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -57,14 +57,10 @@ xfs_icreate_item_format(
>  }
>  
>  STATIC void
> -xfs_icreate_item_unlock(
> +xfs_icreate_item_release(
>  	struct xfs_log_item	*lip)
>  {
> -	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
> -
> -	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
> -		kmem_zone_free(xfs_icreate_zone, icp);
> -	return;
> +	kmem_zone_free(xfs_icreate_zone, ICR_ITEM(lip));
>  }
>  
>  /*
> @@ -89,7 +85,7 @@ xfs_icreate_item_committed(
>  static const struct xfs_item_ops xfs_icreate_item_ops = {
>  	.iop_size	= xfs_icreate_item_size,
>  	.iop_format	= xfs_icreate_item_format,
> -	.iop_unlock	= xfs_icreate_item_unlock,
> +	.iop_release	= xfs_icreate_item_release,
>  	.iop_committed	= xfs_icreate_item_committed,
>  };
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index fa1c4fe2ffbf..a00f0b6aecc7 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -565,7 +565,7 @@ xfs_inode_item_push(
>   * Unlock the inode associated with the inode log item.
>   */
>  STATIC void
> -xfs_inode_item_unlock(
> +xfs_inode_item_release(
>  	struct xfs_log_item	*lip)
>  {
>  	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> @@ -621,9 +621,10 @@ xfs_inode_item_committed(
>  STATIC void
>  xfs_inode_item_committing(
>  	struct xfs_log_item	*lip,
> -	xfs_lsn_t		lsn)
> +	xfs_lsn_t		commit_lsn)
>  {
> -	INODE_ITEM(lip)->ili_last_lsn = lsn;
> +	INODE_ITEM(lip)->ili_last_lsn = commit_lsn;
> +	return xfs_inode_item_release(lip);
>  }
>  
>  /*
> @@ -634,10 +635,10 @@ static const struct xfs_item_ops xfs_inode_item_ops = {
>  	.iop_format	= xfs_inode_item_format,
>  	.iop_pin	= xfs_inode_item_pin,
>  	.iop_unpin	= xfs_inode_item_unpin,
> -	.iop_unlock	= xfs_inode_item_unlock,
> +	.iop_release	= xfs_inode_item_release,
>  	.iop_committed	= xfs_inode_item_committed,
>  	.iop_push	= xfs_inode_item_push,
> -	.iop_committing = xfs_inode_item_committing,
> +	.iop_committing	= xfs_inode_item_committing,
>  	.iop_error	= xfs_inode_item_error
>  };
>  
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index c856bfce5bf2..4cb459f21ad4 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1024,8 +1024,6 @@ xfs_log_commit_cil(
>  		xfs_trans_del_item(lip);
>  		if (lip->li_ops->iop_committing)
>  			lip->li_ops->iop_committing(lip, xc_commit_lsn);
> -		if (lip->li_ops->iop_unlock)
> -			lip->li_ops->iop_unlock(lip);
>  	}
>  	xlog_cil_push_background(log);
>  
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 03a61886fe2a..9f8fb23dcc81 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -118,11 +118,10 @@ xfs_cui_item_unpin(
>   * constructed and thus we free the CUI here directly.
>   */
>  STATIC void
> -xfs_cui_item_unlock(
> +xfs_cui_item_release(
>  	struct xfs_log_item	*lip)
>  {
> -	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
> -		xfs_cui_release(CUI_ITEM(lip));
> +	xfs_cui_release(CUI_ITEM(lip));
>  }
>  
>  /*
> @@ -132,7 +131,7 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
>  	.iop_size	= xfs_cui_item_size,
>  	.iop_format	= xfs_cui_item_format,
>  	.iop_unpin	= xfs_cui_item_unpin,
> -	.iop_unlock	= xfs_cui_item_unlock,
> +	.iop_release	= xfs_cui_item_release,
>  };
>  
>  /*
> @@ -205,15 +204,13 @@ xfs_cud_item_format(
>   * CUD.
>   */
>  STATIC void
> -xfs_cud_item_unlock(
> +xfs_cud_item_release(
>  	struct xfs_log_item	*lip)
>  {
>  	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
>  
> -	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
> -		xfs_cui_release(cudp->cud_cuip);
> -		kmem_zone_free(xfs_cud_zone, cudp);
> -	}
> +	xfs_cui_release(cudp->cud_cuip);
> +	kmem_zone_free(xfs_cud_zone, cudp);
>  }
>  
>  /*
> @@ -247,7 +244,7 @@ xfs_cud_item_committed(
>  static const struct xfs_item_ops xfs_cud_item_ops = {
>  	.iop_size	= xfs_cud_item_size,
>  	.iop_format	= xfs_cud_item_format,
> -	.iop_unlock	= xfs_cud_item_unlock,
> +	.iop_release	= xfs_cud_item_release,
>  	.iop_committed	= xfs_cud_item_committed,
>  };
>  
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index df9f2505c5f3..e907bd169de5 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -117,11 +117,10 @@ xfs_rui_item_unpin(
>   * constructed and thus we free the RUI here directly.
>   */
>  STATIC void
> -xfs_rui_item_unlock(
> +xfs_rui_item_release(
>  	struct xfs_log_item	*lip)
>  {
> -	if (test_bit(XFS_LI_ABORTED, &lip->li_flags))
> -		xfs_rui_release(RUI_ITEM(lip));
> +	xfs_rui_release(RUI_ITEM(lip));
>  }
>  
>  /*
> @@ -131,7 +130,7 @@ static const struct xfs_item_ops xfs_rui_item_ops = {
>  	.iop_size	= xfs_rui_item_size,
>  	.iop_format	= xfs_rui_item_format,
>  	.iop_unpin	= xfs_rui_item_unpin,
> -	.iop_unlock	= xfs_rui_item_unlock,
> +	.iop_release	= xfs_rui_item_release,
>  };
>  
>  /*
> @@ -226,15 +225,13 @@ xfs_rud_item_format(
>   * RUD.
>   */
>  STATIC void
> -xfs_rud_item_unlock(
> +xfs_rud_item_release(
>  	struct xfs_log_item	*lip)
>  {
>  	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
>  
> -	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
> -		xfs_rui_release(rudp->rud_ruip);
> -		kmem_zone_free(xfs_rud_zone, rudp);
> -	}
> +	xfs_rui_release(rudp->rud_ruip);
> +	kmem_zone_free(xfs_rud_zone, rudp);
>  }
>  
>  /*
> @@ -268,7 +265,7 @@ xfs_rud_item_committed(
>  static const struct xfs_item_ops xfs_rud_item_ops = {
>  	.iop_size	= xfs_rud_item_size,
>  	.iop_format	= xfs_rud_item_format,
> -	.iop_unlock	= xfs_rud_item_unlock,
> +	.iop_release	= xfs_rud_item_release,
>  	.iop_committed	= xfs_rud_item_committed,
>  };
>  
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 195a9cdb954e..65c920554b96 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -475,7 +475,7 @@ DEFINE_BUF_ITEM_EVENT(xfs_buf_item_ordered);
>  DEFINE_BUF_ITEM_EVENT(xfs_buf_item_pin);
>  DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin);
>  DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unpin_stale);
> -DEFINE_BUF_ITEM_EVENT(xfs_buf_item_unlock);
> +DEFINE_BUF_ITEM_EVENT(xfs_buf_item_release);
>  DEFINE_BUF_ITEM_EVENT(xfs_buf_item_committed);
>  DEFINE_BUF_ITEM_EVENT(xfs_buf_item_push);
>  DEFINE_BUF_ITEM_EVENT(xfs_trans_get_buf);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 4ed5d032b26f..45a39de65997 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -780,9 +780,8 @@ xfs_trans_free_items(
>  		xfs_trans_del_item(lip);
>  		if (abort)
>  			set_bit(XFS_LI_ABORTED, &lip->li_flags);
> -
> -		if (lip->li_ops->iop_unlock)
> -			lip->li_ops->iop_unlock(lip);
> +		if (lip->li_ops->iop_release)
> +			lip->li_ops->iop_release(lip);
>  	}
>  }
>  
> @@ -815,7 +814,7 @@ xfs_log_item_batch_insert(
>   *
>   * If we are called with the aborted flag set, it is because a log write during
>   * a CIL checkpoint commit has failed. In this case, all the items in the
> - * checkpoint have already gone through iop_committed and iop_unlock, which
> + * checkpoint have already gone through iop_committed and iop_committing, which
>   * means that checkpoint commit abort handling is treated exactly the same
>   * as an iclog write error even though we haven't started any IO yet. Hence in
>   * this case all we need to do is iop_committed processing, followed by an
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index c6e1c5704a8c..7bd1867613c2 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -72,9 +72,9 @@ struct xfs_item_ops {
>  	void (*iop_pin)(xfs_log_item_t *);
>  	void (*iop_unpin)(xfs_log_item_t *, int remove);
>  	uint (*iop_push)(struct xfs_log_item *, struct list_head *);
> -	void (*iop_unlock)(xfs_log_item_t *);
> +	void (*iop_committing)(struct xfs_log_item *, xfs_lsn_t commit_lsn);
> +	void (*iop_release)(struct xfs_log_item *);
>  	xfs_lsn_t (*iop_committed)(xfs_log_item_t *, xfs_lsn_t);
> -	void (*iop_committing)(xfs_log_item_t *, xfs_lsn_t);
>  	void (*iop_error)(xfs_log_item_t *, xfs_buf_t *);
>  };
>  
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 7d65ebf1e847..3dca9cf40a9f 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -428,7 +428,7 @@ xfs_trans_brelse(
>  
>  /*
>   * Mark the buffer as not needing to be unlocked when the buf item's
> - * iop_unlock() routine is called.  The buffer must already be locked
> + * iop_committing() routine is called.  The buffer must already be locked
>   * and associated with the given transaction.
>   */
>  /* ARGSUSED */
> -- 
> 2.20.1
> 
