Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CD14A02FA
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Jan 2022 22:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350650AbiA1VhT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Jan 2022 16:37:19 -0500
Received: from sandeen.net ([63.231.237.45]:42166 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351570AbiA1VhS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Jan 2022 16:37:18 -0500
Received: from [10.0.0.147] (liberator.sandeen.net [10.0.0.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 00D0A78FC;
        Fri, 28 Jan 2022 15:37:04 -0600 (CST)
Message-ID: <8054cc29-9c05-ebc0-7279-8cc694302509@sandeen.net>
Date:   Fri, 28 Jan 2022 15:37:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263809120.860211.17519273310381663828.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 45/45] libxfs: rename buffer cache index variable b_bn
In-Reply-To: <164263809120.860211.17519273310381663828.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/19/22 6:21 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> To stop external users from using b_bn as the disk address of the
> buffer, rename it to b_rhash_key to indicate that it is the buffer
> cache index, not the block number of the buffer. Code that needs the
> disk address should use xfs_buf_daddr() to obtain it.
> 
> Do the rename and clean up any of the remaining internal b_bn users.

Is there a reason this wasn't done in the prior patch? If not, I'm happy
to move them for consistency as noted below.

> Also clean up any remaining b_bn cruft that is now unused.
> 
> Inspired-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   libxfs/libxfs_io.h |    4 ++--
>   libxfs/rdwr.c      |   16 ++++++++--------
>   2 files changed, 10 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index a4d0a913..8a42f500 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -79,7 +79,7 @@ struct xfs_buf_ops {
>   struct xfs_buf {
>   	struct cache_node	b_node;
>   	unsigned int		b_flags;
> -	xfs_daddr_t		b_bn;
> +	xfs_daddr_t		b_cache_key;	/* buffer cache index */
>   	unsigned int		b_length;
>   	struct xfs_buftarg	*b_target;
>   	pthread_mutex_t		b_lock;
> @@ -122,7 +122,7 @@ static inline xfs_daddr_t xfs_buf_daddr(struct xfs_buf *bp)
>   
>   static inline void xfs_buf_set_daddr(struct xfs_buf *bp, xfs_daddr_t blkno)
>   {
> -	assert(bp->b_bn == XFS_BUF_DADDR_NULL);
> +	assert(bp->b_cache_key == XFS_BUF_DADDR_NULL);
>   	bp->b_maps[0].bm_bn = blkno;
>   }
>   
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index a55e3a79..2a9e8c98 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -205,7 +205,7 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
>   	struct xfs_bufkey	*bkey = (struct xfs_bufkey *)key;
>   
>   	if (bp->b_target->bt_bdev == bkey->buftarg->bt_bdev &&
> -	    bp->b_bn == bkey->blkno) {
> +	    bp->b_cache_key == bkey->blkno) {
>   		if (bp->b_length == bkey->bblen)
>   			return CACHE_HIT;
>   #ifdef IO_BCOMPARE_CHECK
> @@ -214,7 +214,7 @@ libxfs_bcompare(struct cache_node *node, cache_key_t key)
>   	"%lx: Badness in key lookup (length)\n"
>   	"bp=(bno 0x%llx, len %u bytes) key=(bno 0x%llx, len %u bytes)\n",
>   				pthread_self(),
> -				(unsigned long long)bp->b_bn,
> +				(unsigned long long)xfs_buf_daddr(bp),

here

>   				BBTOB(bp->b_length),
>   				(unsigned long long)bkey->blkno,
>   				BBTOB(bkey->bblen));
> @@ -230,7 +230,7 @@ __initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
>   		unsigned int bytes)
>   {
>   	bp->b_flags = 0;
> -	bp->b_bn = bno;
> +	bp->b_cache_key = bno;
>   	bp->b_length = BTOBB(bytes);
>   	bp->b_target = btp;
>   	bp->b_mount = btp->bt_mount;
> @@ -256,7 +256,7 @@ __initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
>   
>   	if (bp->b_maps == &bp->__b_map) {
>   		bp->b_nmaps = 1;
> -		bp->b_maps[0].bm_bn = bp->b_bn;
> +		bp->b_maps[0].bm_bn = bno;
>   		bp->b_maps[0].bm_len = bp->b_length;
>   	}
>   }
> @@ -591,7 +591,7 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, struct xfs_buf *bp,
>   	error = __read_buf(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno), flags);
>   	if (!error &&
>   	    bp->b_target->bt_bdev == btp->bt_bdev &&
> -	    bp->b_bn == blkno &&
> +	    bp->b_cache_key == blkno &&
>   	    bp->b_length == len)
>   		bp->b_flags |= LIBXFS_B_UPTODATE;
>   	bp->b_error = error;
> @@ -833,14 +833,14 @@ libxfs_bwrite(
>   			fprintf(stderr,
>   	_("%s: write verifier failed on %s bno 0x%llx/0x%x\n"),
>   				__func__, bp->b_ops->name,
> -				(long long)bp->b_bn, bp->b_length);
> +				(long long)xfs_buf_daddr(bp), bp->b_length);

here

>   			return bp->b_error;
>   		}
>   	}
>   
>   	if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
>   		bp->b_error = __write_buf(fd, bp->b_addr, BBTOB(bp->b_length),
> -				    LIBXFS_BBTOOFF64(bp->b_bn), bp->b_flags);
> +				    LIBXFS_BBTOOFF64(xfs_buf_daddr(bp)), bp->b_flags);

here

>   	} else {
>   		int	i;
>   		void	*buf = bp->b_addr;
> @@ -861,7 +861,7 @@ libxfs_bwrite(
>   		fprintf(stderr,
>   	_("%s: write failed on %s bno 0x%llx/0x%x, err=%d\n"),
>   			__func__, bp->b_ops ? bp->b_ops->name : "(unknown)",
> -			(long long)bp->b_bn, bp->b_length, -bp->b_error);
> +			(long long)xfs_buf_daddr(bp), bp->b_length, -bp->b_error);

and here

>   	} else {
>   		bp->b_flags |= LIBXFS_B_UPTODATE;
>   		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
> 
