Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540174612E
	for <lists+linux-xfs@lfdr.de>; Fri, 14 Jun 2019 16:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfFNOn7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 14 Jun 2019 10:43:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59894 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727560AbfFNOn6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Jun 2019 10:43:58 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1622C81F18;
        Fri, 14 Jun 2019 14:43:58 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FDDE2D26D;
        Fri, 14 Jun 2019 14:43:57 +0000 (UTC)
Date:   Fri, 14 Jun 2019 10:43:55 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/20] xfs: add a flag to release log items on commit
Message-ID: <20190614144355.GJ26586@bfoster>
References: <20190613180300.30447-1-hch@lst.de>
 <20190613180300.30447-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613180300.30447-9-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 14 Jun 2019 14:43:58 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 13, 2019 at 08:02:48PM +0200, Christoph Hellwig wrote:
> We have various items that are released from ->iop_comitting.  Add a
> flag to just call ->iop_release from the commit path to avoid tons
> of boilerplate code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

FYI the commit log still refers to ->iop_committing() instead of
->iop_committed(). With that fixed up:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_item.c     | 27 +--------------------------
>  fs/xfs/xfs_extfree_item.c  | 27 +--------------------------
>  fs/xfs/xfs_icreate_item.c  | 18 +-----------------
>  fs/xfs/xfs_refcount_item.c | 27 +--------------------------
>  fs/xfs/xfs_rmap_item.c     | 27 +--------------------------
>  fs/xfs/xfs_trans.c         |  6 ++++++
>  fs/xfs/xfs_trans.h         |  7 +++++++
>  7 files changed, 18 insertions(+), 121 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 56c1ab161f3b..6fb5263cb61d 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -208,39 +208,14 @@ xfs_bud_item_release(
>  	kmem_zone_free(xfs_bud_zone, budp);
>  }
>  
> -/*
> - * When the bud item is committed to disk, all we need to do is delete our
> - * reference to our partner bui item and then free ourselves. Since we're
> - * freeing ourselves we must return -1 to keep the transaction code from
> - * further referencing this item.
> - */
> -STATIC xfs_lsn_t
> -xfs_bud_item_committed(
> -	struct xfs_log_item	*lip,
> -	xfs_lsn_t		lsn)
> -{
> -	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
> -
> -	/*
> -	 * Drop the BUI reference regardless of whether the BUD has been
> -	 * aborted. Once the BUD transaction is constructed, it is the sole
> -	 * responsibility of the BUD to release the BUI (even if the BUI is
> -	 * aborted due to log I/O error).
> -	 */
> -	xfs_bui_release(budp->bud_buip);
> -	kmem_zone_free(xfs_bud_zone, budp);
> -
> -	return (xfs_lsn_t)-1;
> -}
> -
>  /*
>   * This is the ops vector shared by all bud log items.
>   */
>  static const struct xfs_item_ops xfs_bud_item_ops = {
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>  	.iop_size	= xfs_bud_item_size,
>  	.iop_format	= xfs_bud_item_format,
>  	.iop_release	= xfs_bud_item_release,
> -	.iop_committed	= xfs_bud_item_committed,
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index a73a3cff8502..92e182493000 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -307,39 +307,14 @@ xfs_efd_item_release(
>  	xfs_efd_item_free(efdp);
>  }
>  
> -/*
> - * When the efd item is committed to disk, all we need to do is delete our
> - * reference to our partner efi item and then free ourselves. Since we're
> - * freeing ourselves we must return -1 to keep the transaction code from further
> - * referencing this item.
> - */
> -STATIC xfs_lsn_t
> -xfs_efd_item_committed(
> -	struct xfs_log_item	*lip,
> -	xfs_lsn_t		lsn)
> -{
> -	struct xfs_efd_log_item	*efdp = EFD_ITEM(lip);
> -
> -	/*
> -	 * Drop the EFI reference regardless of whether the EFD has been
> -	 * aborted. Once the EFD transaction is constructed, it is the sole
> -	 * responsibility of the EFD to release the EFI (even if the EFI is
> -	 * aborted due to log I/O error).
> -	 */
> -	xfs_efi_release(efdp->efd_efip);
> -	xfs_efd_item_free(efdp);
> -
> -	return (xfs_lsn_t)-1;
> -}
> -
>  /*
>   * This is the ops vector shared by all efd log items.
>   */
>  static const struct xfs_item_ops xfs_efd_item_ops = {
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>  	.iop_size	= xfs_efd_item_size,
>  	.iop_format	= xfs_efd_item_format,
>  	.iop_release	= xfs_efd_item_release,
> -	.iop_committed	= xfs_efd_item_committed,
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
> index 9aceb35dce24..ac9918da5f4a 100644
> --- a/fs/xfs/xfs_icreate_item.c
> +++ b/fs/xfs/xfs_icreate_item.c
> @@ -63,30 +63,14 @@ xfs_icreate_item_release(
>  	kmem_zone_free(xfs_icreate_zone, ICR_ITEM(lip));
>  }
>  
> -/*
> - * Because we have ordered buffers being tracked in the AIL for the inode
> - * creation, we don't need the create item after this. Hence we can free
> - * the log item and return -1 to tell the caller we're done with the item.
> - */
> -STATIC xfs_lsn_t
> -xfs_icreate_item_committed(
> -	struct xfs_log_item	*lip,
> -	xfs_lsn_t		lsn)
> -{
> -	struct xfs_icreate_item	*icp = ICR_ITEM(lip);
> -
> -	kmem_zone_free(xfs_icreate_zone, icp);
> -	return (xfs_lsn_t)-1;
> -}
> -
>  /*
>   * This is the ops vector shared by all buf log items.
>   */
>  static const struct xfs_item_ops xfs_icreate_item_ops = {
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>  	.iop_size	= xfs_icreate_item_size,
>  	.iop_format	= xfs_icreate_item_format,
>  	.iop_release	= xfs_icreate_item_release,
> -	.iop_committed	= xfs_icreate_item_committed,
>  };
>  
>  
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 9f8fb23dcc81..5b03478c5d1f 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -213,39 +213,14 @@ xfs_cud_item_release(
>  	kmem_zone_free(xfs_cud_zone, cudp);
>  }
>  
> -/*
> - * When the cud item is committed to disk, all we need to do is delete our
> - * reference to our partner cui item and then free ourselves. Since we're
> - * freeing ourselves we must return -1 to keep the transaction code from
> - * further referencing this item.
> - */
> -STATIC xfs_lsn_t
> -xfs_cud_item_committed(
> -	struct xfs_log_item	*lip,
> -	xfs_lsn_t		lsn)
> -{
> -	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
> -
> -	/*
> -	 * Drop the CUI reference regardless of whether the CUD has been
> -	 * aborted. Once the CUD transaction is constructed, it is the sole
> -	 * responsibility of the CUD to release the CUI (even if the CUI is
> -	 * aborted due to log I/O error).
> -	 */
> -	xfs_cui_release(cudp->cud_cuip);
> -	kmem_zone_free(xfs_cud_zone, cudp);
> -
> -	return (xfs_lsn_t)-1;
> -}
> -
>  /*
>   * This is the ops vector shared by all cud log items.
>   */
>  static const struct xfs_item_ops xfs_cud_item_ops = {
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>  	.iop_size	= xfs_cud_item_size,
>  	.iop_format	= xfs_cud_item_format,
>  	.iop_release	= xfs_cud_item_release,
> -	.iop_committed	= xfs_cud_item_committed,
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index e907bd169de5..3fbc7c5ffa96 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -234,39 +234,14 @@ xfs_rud_item_release(
>  	kmem_zone_free(xfs_rud_zone, rudp);
>  }
>  
> -/*
> - * When the rud item is committed to disk, all we need to do is delete our
> - * reference to our partner rui item and then free ourselves. Since we're
> - * freeing ourselves we must return -1 to keep the transaction code from
> - * further referencing this item.
> - */
> -STATIC xfs_lsn_t
> -xfs_rud_item_committed(
> -	struct xfs_log_item	*lip,
> -	xfs_lsn_t		lsn)
> -{
> -	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
> -
> -	/*
> -	 * Drop the RUI reference regardless of whether the RUD has been
> -	 * aborted. Once the RUD transaction is constructed, it is the sole
> -	 * responsibility of the RUD to release the RUI (even if the RUI is
> -	 * aborted due to log I/O error).
> -	 */
> -	xfs_rui_release(rudp->rud_ruip);
> -	kmem_zone_free(xfs_rud_zone, rudp);
> -
> -	return (xfs_lsn_t)-1;
> -}
> -
>  /*
>   * This is the ops vector shared by all rud log items.
>   */
>  static const struct xfs_item_ops xfs_rud_item_ops = {
> +	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>  	.iop_size	= xfs_rud_item_size,
>  	.iop_format	= xfs_rud_item_format,
>  	.iop_release	= xfs_rud_item_release,
> -	.iop_committed	= xfs_rud_item_committed,
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 5fe69ea07367..942de9bd9f59 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -851,6 +851,12 @@ xfs_trans_committed_bulk(
>  
>  		if (aborted)
>  			set_bit(XFS_LI_ABORTED, &lip->li_flags);
> +
> +		if (lip->li_ops->flags & XFS_ITEM_RELEASE_WHEN_COMMITTED) {
> +			lip->li_ops->iop_release(lip);
> +			continue;
> +		}
> +
>  		if (lip->li_ops->iop_committed)
>  			item_lsn = lip->li_ops->iop_committed(lip, commit_lsn);
>  		else
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 7bd1867613c2..1eeaefd3c65d 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -67,6 +67,7 @@ typedef struct xfs_log_item {
>  	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
>  
>  struct xfs_item_ops {
> +	unsigned flags;
>  	void (*iop_size)(xfs_log_item_t *, int *, int *);
>  	void (*iop_format)(xfs_log_item_t *, struct xfs_log_vec *);
>  	void (*iop_pin)(xfs_log_item_t *);
> @@ -78,6 +79,12 @@ struct xfs_item_ops {
>  	void (*iop_error)(xfs_log_item_t *, xfs_buf_t *);
>  };
>  
> +/*
> + * Release the log item as soon as committed.  This is for items just logging
> + * intents that never need to be written back in place.
> + */
> +#define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
> +
>  void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
>  			  int type, const struct xfs_item_ops *ops);
>  
> -- 
> 2.20.1
> 
