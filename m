Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B85237D0
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 15:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731719AbfETNNT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 09:13:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731752AbfETNNT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 09:13:19 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A2F94E90E;
        Mon, 20 May 2019 13:13:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 21ADF75261;
        Mon, 20 May 2019 13:13:19 +0000 (UTC)
Date:   Mon, 20 May 2019 09:13:17 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/20] xfs: merge xfs_rud_init into xfs_trans_get_rud
Message-ID: <20190520131317.GF31317@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-16-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-16-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 20 May 2019 13:13:19 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:14AM +0200, Christoph Hellwig wrote:
> There is no good reason to keep these two functions separate.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_rmap_item.c  | 14 ++++++--------
>  fs/xfs/xfs_rmap_item.h  |  2 --
>  fs/xfs/xfs_trans_rmap.c | 12 ------------
>  3 files changed, 6 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index dce1357aef88..5f11e6d43484 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -238,22 +238,20 @@ static const struct xfs_item_ops xfs_rud_item_ops = {
>  	.iop_release	= xfs_rud_item_release,
>  };
>  
> -/*
> - * Allocate and initialize an rud item with the given number of extents.
> - */
>  struct xfs_rud_log_item *
> -xfs_rud_init(
> -	struct xfs_mount		*mp,
> +xfs_trans_get_rud(
> +	struct xfs_trans		*tp,
>  	struct xfs_rui_log_item		*ruip)
> -
>  {
> -	struct xfs_rud_log_item	*rudp;
> +	struct xfs_rud_log_item		*rudp;
>  
>  	rudp = kmem_zone_zalloc(xfs_rud_zone, KM_SLEEP);
> -	xfs_log_item_init(mp, &rudp->rud_item, XFS_LI_RUD, &xfs_rud_item_ops);
> +	xfs_log_item_init(tp->t_mountp, &rudp->rud_item, XFS_LI_RUD,
> +			  &xfs_rud_item_ops);
>  	rudp->rud_ruip = ruip;
>  	rudp->rud_format.rud_rui_id = ruip->rui_format.rui_id;
>  
> +	xfs_trans_add_item(tp, &rudp->rud_item);
>  	return rudp;
>  }
>  
> diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
> index 7e482baa27f5..8708e4a5aa5c 100644
> --- a/fs/xfs/xfs_rmap_item.h
> +++ b/fs/xfs/xfs_rmap_item.h
> @@ -78,8 +78,6 @@ extern struct kmem_zone	*xfs_rui_zone;
>  extern struct kmem_zone	*xfs_rud_zone;
>  
>  struct xfs_rui_log_item *xfs_rui_init(struct xfs_mount *, uint);
> -struct xfs_rud_log_item *xfs_rud_init(struct xfs_mount *,
> -		struct xfs_rui_log_item *);
>  int xfs_rui_copy_format(struct xfs_log_iovec *buf,
>  		struct xfs_rui_log_format *dst_rui_fmt);
>  void xfs_rui_item_free(struct xfs_rui_log_item *);
> diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
> index 5c7936b1be13..863e3281daaa 100644
> --- a/fs/xfs/xfs_trans_rmap.c
> +++ b/fs/xfs/xfs_trans_rmap.c
> @@ -60,18 +60,6 @@ xfs_trans_set_rmap_flags(
>  	}
>  }
>  
> -struct xfs_rud_log_item *
> -xfs_trans_get_rud(
> -	struct xfs_trans		*tp,
> -	struct xfs_rui_log_item		*ruip)
> -{
> -	struct xfs_rud_log_item		*rudp;
> -
> -	rudp = xfs_rud_init(tp->t_mountp, ruip);
> -	xfs_trans_add_item(tp, &rudp->rud_item);
> -	return rudp;
> -}
> -
>  /*
>   * Finish an rmap update and log it to the RUD. Note that the transaction is
>   * marked dirty regardless of whether the rmap update succeeds or fails to
> -- 
> 2.20.1
> 
