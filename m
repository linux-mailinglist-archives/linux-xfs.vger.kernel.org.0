Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 330A621D48
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 20:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfEQS1B (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 14:27:01 -0400
Received: from sandeen.net ([63.231.237.45]:33412 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbfEQS1B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 14:27:01 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9C10C116F9;
        Fri, 17 May 2019 13:26:40 -0500 (CDT)
Subject: Re: [PATCH 13/20] xfs: merge xfs_efd_init into xfs_trans_get_efd
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
References: <20190517073119.30178-1-hch@lst.de>
 <20190517073119.30178-14-hch@lst.de>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <842291d4-74b5-71bd-5d61-ea513614a9cf@sandeen.net>
Date:   Fri, 17 May 2019 13:26:59 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517073119.30178-14-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 5/17/19 2:31 AM, Christoph Hellwig wrote:
> There is no good reason to keep these two functions separate.

hm, do the thin ->create_done() wrappers make sense either?

/* Get an EFD so we can process all the free extents. */
STATIC void *
xfs_extent_free_create_done(
        struct xfs_trans                *tp,
        void                            *intent,
        unsigned int                    count)
{
        return xfs_trans_get_efd(tp, intent, count);
}

should we just hook xfs_trans_get_FOO() directly to ->create_done?

 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_extfree_item.c  | 27 +++++++++++++++------------
>  fs/xfs/xfs_extfree_item.h  |  2 --
>  fs/xfs/xfs_trans_extfree.c | 26 --------------------------
>  3 files changed, 15 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index bb0b1e942d00..ccf95cb8234c 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -312,32 +312,35 @@ static const struct xfs_item_ops xfs_efd_item_ops = {
>  };
>  
>  /*
> - * Allocate and initialize an efd item with the given number of extents.
> + * Allocate an "extent free done" log item that will hold nextents worth of
> + * extents.  The caller must use all nextents extents, because we are not
> + * flexible about this at all.
>   */
>  struct xfs_efd_log_item *
> -xfs_efd_init(
> -	struct xfs_mount	*mp,
> -	struct xfs_efi_log_item	*efip,
> -	uint			nextents)
> -
> +xfs_trans_get_efd(
> +	struct xfs_trans		*tp,
> +	struct xfs_efi_log_item		*efip,
> +	unsigned int			nextents)
>  {
> -	struct xfs_efd_log_item	*efdp;
> -	uint			size;
> +	struct xfs_efd_log_item		*efdp;
>  
>  	ASSERT(nextents > 0);
> +
>  	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
> -		size = (uint)(sizeof(xfs_efd_log_item_t) +
> -			((nextents - 1) * sizeof(xfs_extent_t)));
> -		efdp = kmem_zalloc(size, KM_SLEEP);
> +		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
> +				(nextents - 1) * sizeof(struct xfs_extent),
> +				KM_SLEEP);
>  	} else {
>  		efdp = kmem_zone_zalloc(xfs_efd_zone, KM_SLEEP);
>  	}
>  
> -	xfs_log_item_init(mp, &efdp->efd_item, XFS_LI_EFD, &xfs_efd_item_ops);
> +	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
> +			  &xfs_efd_item_ops);
>  	efdp->efd_efip = efip;
>  	efdp->efd_format.efd_nextents = nextents;
>  	efdp->efd_format.efd_efi_id = efip->efi_format.efi_id;
>  
> +	xfs_trans_add_item(tp, &efdp->efd_item);
>  	return efdp;
>  }
>  
> diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
> index b0dc4ebe8892..16aaab06d4ec 100644
> --- a/fs/xfs/xfs_extfree_item.h
> +++ b/fs/xfs/xfs_extfree_item.h
> @@ -79,8 +79,6 @@ extern struct kmem_zone	*xfs_efi_zone;
>  extern struct kmem_zone	*xfs_efd_zone;
>  
>  xfs_efi_log_item_t	*xfs_efi_init(struct xfs_mount *, uint);
> -xfs_efd_log_item_t	*xfs_efd_init(struct xfs_mount *, xfs_efi_log_item_t *,
> -				      uint);
>  int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
>  					    xfs_efi_log_format_t *dst_efi_fmt);
>  void			xfs_efi_item_free(xfs_efi_log_item_t *);
> diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
> index 8ee7a3f8bb20..20ab1c9d758f 100644
> --- a/fs/xfs/xfs_trans_extfree.c
> +++ b/fs/xfs/xfs_trans_extfree.c
> @@ -19,32 +19,6 @@
>  #include "xfs_bmap.h"
>  #include "xfs_trace.h"
>  
> -/*
> - * This routine is called to allocate an "extent free done"
> - * log item that will hold nextents worth of extents.  The
> - * caller must use all nextents extents, because we are not
> - * flexible about this at all.
> - */
> -struct xfs_efd_log_item *
> -xfs_trans_get_efd(struct xfs_trans		*tp,
> -		  struct xfs_efi_log_item	*efip,
> -		  uint				nextents)
> -{
> -	struct xfs_efd_log_item			*efdp;
> -
> -	ASSERT(tp != NULL);
> -	ASSERT(nextents > 0);
> -
> -	efdp = xfs_efd_init(tp->t_mountp, efip, nextents);
> -	ASSERT(efdp != NULL);
> -
> -	/*
> -	 * Get a log_item_desc to point at the new item.
> -	 */
> -	xfs_trans_add_item(tp, &efdp->efd_item);
> -	return efdp;
> -}
> -
>  /*
>   * Free an extent and log it to the EFD. Note that the transaction is marked
>   * dirty regardless of whether the extent free succeeds or fails to support the
> 
