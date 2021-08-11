Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A05A3E876C
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Aug 2021 02:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235756AbhHKAqz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 Aug 2021 20:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235724AbhHKAqz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Aug 2021 20:46:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74BF960C40;
        Wed, 11 Aug 2021 00:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628642792;
        bh=BvzJvDAinxqfsFp/fQBkEGlMWOq7NVt+PNSTKanqS08=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nHyGEI8qpofQlbYKcTS+WYjxMFGWpJ+xYzbUt++HRzoGMQr3QDvhm/+kjGJRcDj3Y
         Hg5IiNrwQYQUpo7KM5GF/MkXZK0AF8OhEABlrS8Qxci+EFvitPie4rpS8gPRph7YgK
         vVeSyvYvrSuIBa+vDy5QEZdnV+eWeaACaMJ6jmNlmULKBVAfEcW2muL3cOpUI/kiaS
         v+sNaVDHZWVhPz/dEK6+NcjEKPGm1e5anaHGKYM7IrP8xd88G6ZVhNHJlzXrawvCzi
         ZCjvFHNthO/7CWubUfUmYS1Mu42tSxFGfQt2T3RKCPIa595PurIDQo9KzJoX5NHTqH
         AvbF1/5kU/vLg==
Date:   Tue, 10 Aug 2021 17:46:32 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: rename buffer cache index variable b_bn
Message-ID: <20210811004632.GA3601443@magnolia>
References: <20210810052851.42312-1-david@fromorbit.com>
 <20210810052851.42312-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810052851.42312-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 10, 2021 at 03:28:51PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> TO stop external users from using b_bn as the disk address of the
> buffer, rename it to b_index to indicate that it is the buffer cache
> index, not the block number of the buffer. Code that needs the disk
> address should use xfs_buf_daddr() to obtain it.
> 
> Do the rename and clean up any of the remaining b_bn cruft that is
> left over and is now unused.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 19 +++++++++++--------
>  fs/xfs/xfs_buf.h | 18 +-----------------
>  2 files changed, 12 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index c1bb6e41595b..6f6c6937baaa 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -251,7 +251,7 @@ _xfs_buf_alloc(
>  		return error;
>  	}
>  
> -	bp->b_bn = map[0].bm_bn;
> +	bp->b_index = map[0].bm_bn;
>  	bp->b_length = 0;
>  	for (i = 0; i < nmaps; i++) {
>  		bp->b_maps[i].bm_bn = map[i].bm_bn;
> @@ -459,7 +459,7 @@ _xfs_buf_obj_cmp(
>  	 */
>  	BUILD_BUG_ON(offsetof(struct xfs_buf_map, bm_bn) != 0);
>  
> -	if (bp->b_bn != map->bm_bn)
> +	if (bp->b_index != map->bm_bn)
>  		return 1;
>  
>  	if (unlikely(bp->b_length != map->bm_len)) {
> @@ -481,7 +481,7 @@ static const struct rhashtable_params xfs_buf_hash_params = {
>  	.min_size		= 32,	/* empty AGs have minimal footprint */
>  	.nelem_hint		= 16,
>  	.key_len		= sizeof(xfs_daddr_t),
> -	.key_offset		= offsetof(struct xfs_buf, b_bn),
> +	.key_offset		= offsetof(struct xfs_buf, b_index),

I would've called this field b_rhash_key, since "index" is a kind of
vague.

>  	.head_offset		= offsetof(struct xfs_buf, b_rhash_head),
>  	.automatic_shrinking	= true,
>  	.obj_cmpfn		= _xfs_buf_obj_cmp,
> @@ -853,7 +853,9 @@ xfs_buf_readahead_map(
>  
>  /*
>   * Read an uncached buffer from disk. Allocates and returns a locked
> - * buffer containing the disk contents or nothing.
> + * buffer containing the disk contents or nothing. Uncached buffers always have
> + * a cache index of XFS_BUF_DADDR_NULL so we can easily determine if the buffer
> + * is cached or uncached during fault diagnosis.
>   */
>  int
>  xfs_buf_read_uncached(
> @@ -875,7 +877,7 @@ xfs_buf_read_uncached(
>  
>  	/* set up the buffer for a read IO */
>  	ASSERT(bp->b_map_count == 1);
> -	bp->b_bn = XFS_BUF_DADDR_NULL;  /* always null for uncached buffers */
> +	bp->b_index = XFS_BUF_DADDR_NULL;
>  	bp->b_maps[0].bm_bn = daddr;
>  	bp->b_flags |= XBF_READ;
>  	bp->b_ops = ops;
> @@ -1513,7 +1515,7 @@ _xfs_buf_ioapply(
>  						   SHUTDOWN_CORRUPT_INCORE);
>  				return;
>  			}
> -		} else if (bp->b_bn != XFS_BUF_DADDR_NULL) {
> +		} else if (bp->b_index != XFS_BUF_DADDR_NULL) {
>  			struct xfs_mount *mp = bp->b_mount;
>  
>  			/*
> @@ -1523,7 +1525,8 @@ _xfs_buf_ioapply(
>  			if (xfs_has_crc(mp)) {
>  				xfs_warn(mp,
>  					"%s: no buf ops on daddr 0x%llx len %d",
> -					__func__, bp->b_bn, bp->b_length);
> +					__func__, xfs_buf_daddr(bp),
> +					bp->b_length);
>  				xfs_hex_dump(bp->b_addr,
>  						XFS_CORRUPTION_DUMP_LEN);
>  				dump_stack();
> @@ -1793,7 +1796,7 @@ xfs_buftarg_drain(
>  				xfs_buf_alert_ratelimited(bp,
>  					"XFS: Corruption Alert",
>  "Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!",
> -					(long long)bp->b_bn);
> +					(long long)xfs_buf_daddr(bp));

These belong in the previous patch, right?

Aside from those two things, the rest of the patch looks ready to go.

--D

>  			}
>  			xfs_buf_rele(bp);
>  		}
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 6db2fba44b46..7e408c416607 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -134,11 +134,7 @@ struct xfs_buf {
>  	 */
>  	struct rhash_head	b_rhash_head;	/* pag buffer hash node */
>  
> -	/*
> -	 * b_bn is the cache index. Do not use directly, use b_maps[0].bm_bn
> -	 * for the buffer disk address instead.
> -	 */
> -	xfs_daddr_t		b_bn;
> +	xfs_daddr_t		b_index;	/* buffer cache index */
>  	int			b_length;	/* size of buffer in BBs */
>  	atomic_t		b_hold;		/* reference count */
>  	atomic_t		b_lru_ref;	/* lru reclaim ref count */
> @@ -301,18 +297,6 @@ extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);
>  extern int xfs_buf_init(void);
>  extern void xfs_buf_terminate(void);
>  
> -/*
> - * These macros use the IO block map rather than b_bn. b_bn is now really
> - * just for the buffer cache index for cached buffers. As IO does not use b_bn
> - * anymore, uncached buffers do not use b_bn at all and hence must modify the IO
> - * map directly. Uncached buffers are not allowed to be discontiguous, so this
> - * is safe to do.
> - *
> - * In future, uncached buffers will pass the block number directly to the io
> - * request function and hence these macros will go away at that point.
> - */
> -#define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_maps[0].bm_bn = (xfs_daddr_t)(bno))
> -
>  static inline xfs_daddr_t xfs_buf_daddr(struct xfs_buf *bp)
>  {
>  	return bp->b_maps[0].bm_bn;
> -- 
> 2.31.1
> 
