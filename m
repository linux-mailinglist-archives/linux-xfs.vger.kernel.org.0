Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEF382198C
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 16:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbfEQOG4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 10:06:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31525 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728402AbfEQOG4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 10:06:56 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 78E052F366A;
        Fri, 17 May 2019 14:06:56 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2238478D85;
        Fri, 17 May 2019 14:06:56 +0000 (UTC)
Date:   Fri, 17 May 2019 10:06:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/20] xfs: don't require log items to implement optional
 methods
Message-ID: <20190517140654.GC7888@bfoster>
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517073119.30178-4-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 17 May 2019 14:06:56 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 17, 2019 at 09:31:02AM +0200, Christoph Hellwig wrote:
> Just check if they are present first.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_bmap_item.c     | 104 -------------------------------------
>  fs/xfs/xfs_buf_item.c      |   8 ---
>  fs/xfs/xfs_dquot_item.c    |  98 ----------------------------------
>  fs/xfs/xfs_extfree_item.c  | 104 -------------------------------------
>  fs/xfs/xfs_icreate_item.c  |  28 ----------
>  fs/xfs/xfs_log_cil.c       |   3 +-
>  fs/xfs/xfs_refcount_item.c | 104 -------------------------------------
>  fs/xfs/xfs_rmap_item.c     | 104 -------------------------------------
>  fs/xfs/xfs_trans.c         |  21 +++++---
>  fs/xfs/xfs_trans_ail.c     |   2 +
>  10 files changed, 19 insertions(+), 557 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index ce45f066995e..8e57df6d5581 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
...
> @@ -122,21 +113,6 @@ xfs_bui_item_unpin(
>  	xfs_bui_release(buip);
>  }
>  
> -/*
> - * BUI items have no locking or pushing.  However, since BUIs are pulled from
> - * the AIL when their corresponding BUDs are committed to disk, their situation
> - * is very similar to being pinned.  Return XFS_ITEM_PINNED so that the caller
> - * will eventually flush the log.  This should help in getting the BUI out of
> - * the AIL.
> - */
> -STATIC uint
> -xfs_bui_item_push(
> -	struct xfs_log_item	*lip,
> -	struct list_head	*buffer_list)
> -{
> -	return XFS_ITEM_PINNED;
> -}
> -

Nice cleanup overall. This removes a ton of duplicated and boilerplate
code. One thing I don't like is the loss of information around the use
of XFS_ITEM_PINNED in all these ->iop_push() calls associated with
intents. I'd almost rather see a generic xfs_intent_item_push() defined
somewhere and wire that up to these various calls. Short of that, could
we at least move some of the information from these comments to the push
call in xfsaild_push_item()? For example....

>  /*
>   * The BUI has been either committed or aborted if the transaction has been
>   * cancelled. If the transaction was cancelled, an BUD isn't going to be
...
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index d3a4e89bf4a0..8509c4b59760 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -347,6 +347,8 @@ xfsaild_push_item(
>  	if (XFS_TEST_ERROR(false, ailp->ail_mount, XFS_ERRTAG_LOG_ITEM_PIN))
>  		return XFS_ITEM_PINNED;
>  

/*
 * Consider the item pinned if a push callback is not defined so the
 * caller will force the log. This should only happen for intent items
 * as they are unpinned once the associated done item is committed to
 * the on-disk log.
 */

Otherwise this looks fine.

Brian

> +	if (!lip->li_ops->iop_push)
> +		return XFS_ITEM_PINNED;
>  	return lip->li_ops->iop_push(lip, &ailp->ail_buf_list);
>  }
>  
> -- 
> 2.20.1
> 
