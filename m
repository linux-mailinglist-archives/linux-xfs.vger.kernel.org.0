Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19372237CF
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 15:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731746AbfETNNK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 09:13:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730458AbfETNNJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 09:13:09 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C68C4627A;
        Mon, 20 May 2019 13:13:09 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 42DFA100203C;
        Mon, 20 May 2019 13:13:09 +0000 (UTC)
Date:   Mon, 20 May 2019 09:13:07 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/20] xfs: merge xfs_cud_init into xfs_trans_get_cud
Message-ID: <20190520131307.GE31317@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-15-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-15-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 20 May 2019 13:13:09 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:13AM +0200, Christoph Hellwig wrote:
> There is no good reason to keep these two functions separate.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_refcount_item.c  | 14 ++++++--------
>  fs/xfs/xfs_refcount_item.h  |  2 --
>  fs/xfs/xfs_trans_refcount.c | 16 ----------------
>  3 files changed, 6 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index 2b2f6e7ad867..70dcdf40ac92 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -217,22 +217,20 @@ static const struct xfs_item_ops xfs_cud_item_ops = {
>  	.iop_release	= xfs_cud_item_release,
>  };
>  
> -/*
> - * Allocate and initialize an cud item with the given number of extents.
> - */
>  struct xfs_cud_log_item *
> -xfs_cud_init(
> -	struct xfs_mount		*mp,
> +xfs_trans_get_cud(
> +	struct xfs_trans		*tp,
>  	struct xfs_cui_log_item		*cuip)
> -
>  {
> -	struct xfs_cud_log_item	*cudp;
> +	struct xfs_cud_log_item		*cudp;
>  
>  	cudp = kmem_zone_zalloc(xfs_cud_zone, KM_SLEEP);
> -	xfs_log_item_init(mp, &cudp->cud_item, XFS_LI_CUD, &xfs_cud_item_ops);
> +	xfs_log_item_init(tp->t_mountp, &cudp->cud_item, XFS_LI_CUD,
> +			  &xfs_cud_item_ops);
>  	cudp->cud_cuip = cuip;
>  	cudp->cud_format.cud_cui_id = cuip->cui_format.cui_id;
>  
> +	xfs_trans_add_item(tp, &cudp->cud_item);
>  	return cudp;
>  }
>  
> diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
> index 3896dcc2368f..e47530f30489 100644
> --- a/fs/xfs/xfs_refcount_item.h
> +++ b/fs/xfs/xfs_refcount_item.h
> @@ -78,8 +78,6 @@ extern struct kmem_zone	*xfs_cui_zone;
>  extern struct kmem_zone	*xfs_cud_zone;
>  
>  struct xfs_cui_log_item *xfs_cui_init(struct xfs_mount *, uint);
> -struct xfs_cud_log_item *xfs_cud_init(struct xfs_mount *,
> -		struct xfs_cui_log_item *);
>  void xfs_cui_item_free(struct xfs_cui_log_item *);
>  void xfs_cui_release(struct xfs_cui_log_item *);
>  int xfs_cui_recover(struct xfs_trans *parent_tp, struct xfs_cui_log_item *cuip);
> diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
> index 8d734728dd1b..d793fb500378 100644
> --- a/fs/xfs/xfs_trans_refcount.c
> +++ b/fs/xfs/xfs_trans_refcount.c
> @@ -17,22 +17,6 @@
>  #include "xfs_alloc.h"
>  #include "xfs_refcount.h"
>  
> -/*
> - * This routine is called to allocate a "refcount update done"
> - * log item.
> - */
> -struct xfs_cud_log_item *
> -xfs_trans_get_cud(
> -	struct xfs_trans		*tp,
> -	struct xfs_cui_log_item		*cuip)
> -{
> -	struct xfs_cud_log_item		*cudp;
> -
> -	cudp = xfs_cud_init(tp->t_mountp, cuip);
> -	xfs_trans_add_item(tp, &cudp->cud_item);
> -	return cudp;
> -}
> -
>  /*
>   * Finish an refcount update and log it to the CUD. Note that the
>   * transaction is marked dirty regardless of whether the refcount
> -- 
> 2.20.1
> 
