Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6ACB3938DD
	for <lists+linux-xfs@lfdr.de>; Fri, 28 May 2021 00:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbhE0XB0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 May 2021 19:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233203AbhE0XB0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 19:01:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6039D6139A;
        Thu, 27 May 2021 22:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622156392;
        bh=XRRR3sB+pSDn36xcaMZ0Kzo9dqZi0nGFscaRB03eUOA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=imA0FsAbBCSGdknV8WKTZ3ZP3L3zQVKW1sjX8lk1N5vZQGk5X/DUbci9O6f0uIVNB
         O3jU8P72MtqGvu/bIRT69qVuiYOg0LRQSULmN0RDxSczy9+8ez8TPfCxsbupwyOrwb
         KotS4VQ7QwdlVwT80ajNj5uc2lCg/Io0eBz7XwOZ7Wp2HPsrtabHzdngtj4O8QckzD
         lz01K9CTblS6T6P+Hc31GZ0MIPl7padTeaWWCgRDgHn2dBUxXhTeMeT/D531JMwHcT
         A2qKF52Blx63lOIH+SqtaC8DxZB2lXIf7MfONYVq2FZZA6nqlO2qtmLuWCsgz+yb6y
         mBlo6p3aLkDIw==
Date:   Thu, 27 May 2021 15:59:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/10] xfs: use alloc_pages_bulk_array() for buffers
Message-ID: <20210527225951.GC2402049@locust>
References: <20210526224722.1111377-1-david@fromorbit.com>
 <20210526224722.1111377-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526224722.1111377-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 27, 2021 at 08:47:15AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because it's more efficient than allocating pages one at a time in a
> loop.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 62 +++++++++++++++++++-----------------------------
>  1 file changed, 24 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index b1610115d401..8ca4add138c5 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -386,10 +386,7 @@ xfs_buf_alloc_pages(
>  	xfs_buf_flags_t	flags)
>  {
>  	gfp_t		gfp_mask = xb_to_gfp(flags);
> -	size_t		size;
> -	size_t		offset;
> -	size_t		nbytes;
> -	int		i;
> +	long		filled = 0;
>  	int		error;
>  
>  	/* Assure zeroed buffer for non-read cases. */
> @@ -400,50 +397,39 @@ xfs_buf_alloc_pages(
>  	if (unlikely(error))
>  		return error;
>  
> -	offset = bp->b_offset;
>  	bp->b_flags |= _XBF_PAGES;
>  
> -	for (i = 0; i < bp->b_page_count; i++) {
> -		struct page	*page;
> -		uint		retries = 0;
> -retry:
> -		page = alloc_page(gfp_mask);
> -		if (unlikely(page == NULL)) {
> -			if (flags & XBF_READ_AHEAD) {
> -				bp->b_page_count = i;
> -				error = -ENOMEM;
> -				goto out_free_pages;
> -			}
> +	/*
> +	 * Bulk filling of pages can take multiple calls. Not filling the entire
> +	 * array is not an allocation failure, so don't back off if we get at
> +	 * least one extra page.
> +	 */
> +	for (;;) {
> +		long	last = filled;
>  
> -			/*
> -			 * This could deadlock.
> -			 *
> -			 * But until all the XFS lowlevel code is revamped to
> -			 * handle buffer allocation failures we can't do much.
> -			 */
> -			if (!(++retries % 100))
> -				xfs_err(NULL,
> -		"%s(%u) possible memory allocation deadlock in %s (mode:0x%x)",
> -					current->comm, current->pid,
> -					__func__, gfp_mask);
> -
> -			XFS_STATS_INC(bp->b_mount, xb_page_retries);
> -			congestion_wait(BLK_RW_ASYNC, HZ/50);
> -			goto retry;
> +		filled = alloc_pages_bulk_array(gfp_mask, bp->b_page_count,
> +						bp->b_pages);
> +		if (filled == bp->b_page_count) {
> +			XFS_STATS_INC(bp->b_mount, xb_page_found);
> +			break;
>  		}
>  
> -		XFS_STATS_INC(bp->b_mount, xb_page_found);
> +		if (filled != last)
> +			continue;
>  
> -		nbytes = min_t(size_t, size, PAGE_SIZE - offset);
> -		size -= nbytes;
> -		bp->b_pages[i] = page;
> -		offset = 0;
> +		if (flags & XBF_READ_AHEAD) {
> +			error = -ENOMEM;
> +			goto out_free_pages;
> +		}
> +
> +		XFS_STATS_INC(bp->b_mount, xb_page_retries);
> +		congestion_wait(BLK_RW_ASYNC, HZ/50);

Nit: spaces around operators ("HZ / 50").

With that fixed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

I have a question about _xfs_buf_get_pages:

STATIC int
_xfs_buf_get_pages(
	struct xfs_buf		*bp,
	int			page_count)
{
	/* Make sure that we have a page list */
	if (bp->b_pages == NULL) {
		bp->b_page_count = page_count;
		if (page_count <= XB_PAGES) {
			bp->b_pages = bp->b_page_array;
		} else {
			bp->b_pages = kmem_alloc(sizeof(struct page *) *
						 page_count, KM_NOFS);
			if (bp->b_pages == NULL)
				return -ENOMEM;
		}
		memset(bp->b_pages, 0, sizeof(struct page *) * page_count);
	}
	return 0;
}

xfs_bufs are kmem_cache_zalloc'd, which means that b_page_array should
be zeroed, right?

And we could use kmem_zalloc for the pagecount > XB_PAGES case, which
would make the memset necessary, wouldn't it?

OFC that only holds if a buffer that fails the memory allocation is
immediately fed to _xfs_buf_free_pages to null out b_pages, which I
think is true...?

--D

>  	}
>  	return 0;
>  
>  out_free_pages:
> -	for (i = 0; i < bp->b_page_count; i++)
> -		__free_page(bp->b_pages[i]);
> +	while (--filled >= 0)
> +		__free_page(bp->b_pages[filled]);
>  	bp->b_flags &= ~_XBF_PAGES;
>  	return error;
>  }
> -- 
> 2.31.1
> 
