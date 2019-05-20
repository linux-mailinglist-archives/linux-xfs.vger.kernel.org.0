Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65438237D2
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 15:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731918AbfETNN3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 09:13:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730458AbfETNN2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 09:13:28 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88EDE368FF;
        Mon, 20 May 2019 13:13:28 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32F515DE73;
        Mon, 20 May 2019 13:13:28 +0000 (UTC)
Date:   Mon, 20 May 2019 09:13:26 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/20] xfs: merge xfs_bud_init into xfs_trans_get_bud
Message-ID: <20190520131326.GG31317@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-17-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-17-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 20 May 2019 13:13:28 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:15AM +0200, Christoph Hellwig wrote:
> There is no good reason to keep these two functions separate.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_item.c  | 14 ++++++--------
>  fs/xfs/xfs_bmap_item.h  |  2 --
>  fs/xfs/xfs_trans_bmap.c | 16 ----------------
>  3 files changed, 6 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 46dcadf790c2..40385c8b752a 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -212,22 +212,20 @@ static const struct xfs_item_ops xfs_bud_item_ops = {
>  	.iop_release	= xfs_bud_item_release,
>  };
>  
> -/*
> - * Allocate and initialize an bud item with the given number of extents.
> - */
>  struct xfs_bud_log_item *
> -xfs_bud_init(
> -	struct xfs_mount		*mp,
> +xfs_trans_get_bud(
> +	struct xfs_trans		*tp,
>  	struct xfs_bui_log_item		*buip)
> -
>  {
> -	struct xfs_bud_log_item	*budp;
> +	struct xfs_bud_log_item		*budp;
>  
>  	budp = kmem_zone_zalloc(xfs_bud_zone, KM_SLEEP);
> -	xfs_log_item_init(mp, &budp->bud_item, XFS_LI_BUD, &xfs_bud_item_ops);
> +	xfs_log_item_init(tp->t_mountp, &budp->bud_item, XFS_LI_BUD,
> +			  &xfs_bud_item_ops);
>  	budp->bud_buip = buip;
>  	budp->bud_format.bud_bui_id = buip->bui_format.bui_id;
>  
> +	xfs_trans_add_item(tp, &budp->bud_item);
>  	return budp;
>  }
>  
> diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
> index 89e043a88bb8..ad479cc73de8 100644
> --- a/fs/xfs/xfs_bmap_item.h
> +++ b/fs/xfs/xfs_bmap_item.h
> @@ -75,8 +75,6 @@ extern struct kmem_zone	*xfs_bui_zone;
>  extern struct kmem_zone	*xfs_bud_zone;
>  
>  struct xfs_bui_log_item *xfs_bui_init(struct xfs_mount *);
> -struct xfs_bud_log_item *xfs_bud_init(struct xfs_mount *,
> -		struct xfs_bui_log_item *);
>  void xfs_bui_item_free(struct xfs_bui_log_item *);
>  void xfs_bui_release(struct xfs_bui_log_item *);
>  int xfs_bui_recover(struct xfs_trans *parent_tp, struct xfs_bui_log_item *buip);
> diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
> index e1c7d55b32c3..c6f5b217d17c 100644
> --- a/fs/xfs/xfs_trans_bmap.c
> +++ b/fs/xfs/xfs_trans_bmap.c
> @@ -18,22 +18,6 @@
>  #include "xfs_bmap.h"
>  #include "xfs_inode.h"
>  
> -/*
> - * This routine is called to allocate a "bmap update done"
> - * log item.
> - */
> -struct xfs_bud_log_item *
> -xfs_trans_get_bud(
> -	struct xfs_trans		*tp,
> -	struct xfs_bui_log_item		*buip)
> -{
> -	struct xfs_bud_log_item		*budp;
> -
> -	budp = xfs_bud_init(tp->t_mountp, buip);
> -	xfs_trans_add_item(tp, &budp->bud_item);
> -	return budp;
> -}
> -
>  /*
>   * Finish an bmap update and log it to the BUD. Note that the
>   * transaction is marked dirty regardless of whether the bmap update
> -- 
> 2.20.1
> 
