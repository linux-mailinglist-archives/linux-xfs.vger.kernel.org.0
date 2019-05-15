Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 846BD1F498
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 14:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfEOMkI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 08:40:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26209 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfEOMkH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 08:40:07 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A11758110C;
        Wed, 15 May 2019 12:40:07 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 482855C542;
        Wed, 15 May 2019 12:40:07 +0000 (UTC)
Date:   Wed, 15 May 2019 08:40:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: merge xfs_buf_zero and xfs_buf_iomove
Message-ID: <20190515124005.GB2898@bfoster>
References: <20190515081020.3293-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515081020.3293-1-hch@lst.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 15 May 2019 12:40:07 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 15, 2019 at 10:10:20AM +0200, Christoph Hellwig wrote:
> xfs_buf_zero is the only caller of xfs_buf_iomove.  Remove support
> for copying from or to the buffer in xfs_buf_iomove and merge the
> two functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c | 18 +++---------------
>  fs/xfs/xfs_buf.h | 11 +----------
>  2 files changed, 4 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 548344e25128..c66788dbaaba 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1617,12 +1617,10 @@ xfs_buf_offset(
>   *	Move data into or out of a buffer.
>   */

This comment is now stale.

>  void
> -xfs_buf_iomove(
> +xfs_buf_zero(
>  	xfs_buf_t		*bp,	/* buffer to process		*/

Can we kill off this typedef too? Nits aside:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	size_t			boff,	/* starting buffer offset	*/
> -	size_t			bsize,	/* length to copy		*/
> -	void			*data,	/* data address			*/
> -	xfs_buf_rw_t		mode)	/* read/write/zero flag		*/
> +	size_t			bsize)	/* length to copy		*/
>  {
>  	size_t			bend;
>  
> @@ -1639,19 +1637,9 @@ xfs_buf_iomove(
>  
>  		ASSERT((csize + page_offset) <= PAGE_SIZE);
>  
> -		switch (mode) {
> -		case XBRW_ZERO:
> -			memset(page_address(page) + page_offset, 0, csize);
> -			break;
> -		case XBRW_READ:
> -			memcpy(data, page_address(page) + page_offset, csize);
> -			break;
> -		case XBRW_WRITE:
> -			memcpy(page_address(page) + page_offset, data, csize);
> -		}
> +		memset(page_address(page) + page_offset, 0, csize);
>  
>  		boff += csize;
> -		data += csize;
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index d0b96e071cec..1701efee4fd4 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -21,12 +21,6 @@
>  
>  #define XFS_BUF_DADDR_NULL	((xfs_daddr_t) (-1LL))
>  
> -typedef enum {
> -	XBRW_READ = 1,			/* transfer into target memory */
> -	XBRW_WRITE = 2,			/* transfer from target memory */
> -	XBRW_ZERO = 3,			/* Zero target memory */
> -} xfs_buf_rw_t;
> -
>  #define XBF_READ	 (1 << 0) /* buffer intended for reading from device */
>  #define XBF_WRITE	 (1 << 1) /* buffer intended for writing to device */
>  #define XBF_READ_AHEAD	 (1 << 2) /* asynchronous read-ahead */
> @@ -305,10 +299,7 @@ static inline int xfs_buf_submit(struct xfs_buf *bp)
>  	return __xfs_buf_submit(bp, wait);
>  }
>  
> -extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
> -				xfs_buf_rw_t);
> -#define xfs_buf_zero(bp, off, len) \
> -	    xfs_buf_iomove((bp), (off), (len), NULL, XBRW_ZERO)
> +void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize);
>  
>  /* Buffer Utility Routines */
>  extern void *xfs_buf_offset(struct xfs_buf *, size_t);
> -- 
> 2.20.1
> 
