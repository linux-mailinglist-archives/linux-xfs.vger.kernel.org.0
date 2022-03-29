Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8CF4EA334
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Mar 2022 00:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiC1Wqj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 28 Mar 2022 18:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiC1Wqi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 18:46:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E3C126FAF
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 15:44:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B8B62CE103C
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 22:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277F1C340EC;
        Mon, 28 Mar 2022 22:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648507493;
        bh=HUKJyKfyYFGDSWzSBe1IIdmLjuK0GJPxHUCQCGkcJzo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PK8P5ndvO3Gye8PpQlHlIyZD/XWVMXWuFXdZhKMLV4YRpq2iveQIw6Sydph6D0s7L
         ZeywOSmm/XX8jWlFg+ECcnque+ucSMbEHwKNIDuvWfRXRRd/H3PFynZE59+kOuNJ+c
         7bM/EHFXfDQv6cD9GjoQ5ELYOu/Ppu0Vt+ZPZDO9ij1mvBxlKtoprrIq9KWMdD0jej
         1F9PYIST3bvmnx8SBvHVYT2bPlhLM+tzHJDPEYFaEY9jCR8XO6cNbmDzG1dM0BAU8x
         SlAWWgxb6ShgLusTP5HhPI/SgXgs9Y99/nvFZjc1dKoXTJiTigdKRgnRIbGvvV3Nxr
         avZGFUNUYobsg==
Date:   Mon, 28 Mar 2022 15:44:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: aborting inodes on shutdown may need buffer lock
Message-ID: <20220328224452.GA27690@magnolia>
References: <20220324002103.710477-1-david@fromorbit.com>
 <20220324002103.710477-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324002103.710477-2-david@fromorbit.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 24, 2022 at 11:20:58AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Most buffer io list operations are run with the bp->b_lock held, but
> xfs_iflush_abort() can be called without the buffer lock being held
> resulting in inodes being removed from the buffer list while other
> list operations are occurring. This causes problems with corrupted
> bp->b_io_list inode lists during filesystem shutdown, leading to
> traversals that never end, double removals from the AIL, etc.
> 
> Fix this by passing the buffer to xfs_iflush_abort() if we have
> it locked. If the inode is attached to the buffer, we're going to
> have to remove it from the buffer list and we'd have to get the
> buffer off the inode log item to do that anyway.
> 
> If we don't have a buffer passed in (e.g. from xfs_reclaim_inode())
> then we can determine if the inode has a log item and if it is
> attached to a buffer before we do anything else. If it does have an
> attached buffer, we can lock it safely (because the inode has a
> reference to it) and then perform the inode abort.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c     |   2 +-
>  fs/xfs/xfs_inode.c      |   2 +-
>  fs/xfs/xfs_inode_item.c | 165 +++++++++++++++++++++++++++++++++-------
>  fs/xfs/xfs_inode_item.h |   1 +
>  4 files changed, 139 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 4148cdf7ce4a..6c7267451b82 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -883,7 +883,7 @@ xfs_reclaim_inode(
>  	 */
>  	if (xlog_is_shutdown(ip->i_mount->m_log)) {
>  		xfs_iunpin_wait(ip);
> -		xfs_iflush_abort(ip);
> +		xfs_iflush_shutdown_abort(ip);
>  		goto reclaim;
>  	}
>  	if (xfs_ipincount(ip))
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index aab55a06ece7..07be0992321c 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3612,7 +3612,7 @@ xfs_iflush_cluster(
>  
>  	/*
>  	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
> -	 * can remove itself from the list.
> +	 * will remove itself from the list.
>  	 */
>  	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
>  		iip = (struct xfs_inode_log_item *)lip;
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 11158fa81a09..28f92382a1d2 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -544,10 +544,17 @@ xfs_inode_item_push(
>  	uint			rval = XFS_ITEM_SUCCESS;
>  	int			error;
>  
> -	ASSERT(iip->ili_item.li_buf);
> +	if (!bp || (ip->i_flags & XFS_ISTALE)) {
> +		/*
> +		 * Inode item/buffer is being being aborted due to cluster
> +		 * buffer deletion. Trigger a log force to have that operation
> +		 * completed and items removed from the AIL before the next push
> +		 * attempt.
> +		 */
> +		return XFS_ITEM_PINNED;
> +	}
>  
> -	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp) ||
> -	    (ip->i_flags & XFS_ISTALE))
> +	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp))
>  		return XFS_ITEM_PINNED;
>  
>  	if (xfs_iflags_test(ip, XFS_IFLUSHING))
> @@ -834,46 +841,146 @@ xfs_buf_inode_io_fail(
>  }
>  
>  /*
> - * This is the inode flushing abort routine.  It is called when
> - * the filesystem is shutting down to clean up the inode state.  It is
> - * responsible for removing the inode item from the AIL if it has not been
> - * re-logged and clearing the inode's flush state.
> + * Clear the inode logging fields so no more flushes are attempted.  If we are
> + * on a buffer list, it is now safe to remove it because the buffer is
> + * guaranteed to be locked. The caller will drop the reference to the buffer
> + * the log item held.
> + */
> +static void
> +xfs_iflush_abort_clean(
> +	struct xfs_inode_log_item *iip)
> +{
> +	iip->ili_last_fields = 0;
> +	iip->ili_fields = 0;
> +	iip->ili_fsync_fields = 0;
> +	iip->ili_flush_lsn = 0;
> +	iip->ili_item.li_buf = NULL;
> +	list_del_init(&iip->ili_item.li_bio_list);
> +}
> +
> +/*
> + * Abort flushing the inode from a context holding the cluster buffer locked.
> + *
> + * This is the normal runtime method of aborting writeback of an inode that is
> + * attached to a cluster buffer. It occurs when the inode and the backing
> + * cluster buffer have been freed (i.e. inode is XFS_ISTALE), or when cluster
> + * flushing or buffer IO completion encounters a log shutdown situation.
> + *
> + * If we need to abort inode writeback and we don't already hold the buffer
> + * locked, call xfs_iflush_shutdown_abort() instead as this should only ever be
> + * necessary in a shutdown situation.
>   */
>  void
>  xfs_iflush_abort(
>  	struct xfs_inode	*ip)
>  {
>  	struct xfs_inode_log_item *iip = ip->i_itemp;
> -	struct xfs_buf		*bp = NULL;
> +	struct xfs_buf		*bp;
>  
> -	if (iip) {
> -		/*
> -		 * Clear the failed bit before removing the item from the AIL so
> -		 * xfs_trans_ail_delete() doesn't try to clear and release the
> -		 * buffer attached to the log item before we are done with it.
> -		 */
> -		clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
> -		xfs_trans_ail_delete(&iip->ili_item, 0);
> +	if (!iip) {
> +		/* clean inode, nothing to do */
> +		xfs_iflags_clear(ip, XFS_IFLUSHING);
> +		return;
> +	}
> +
> +	/*
> +	 * Remove the inode item from the AIL before we clear it's internal

Nit: "it's" is a contraction, "its" is possessive.

> +	 * state. Whilst the inode is in the AIL, it should have a valid buffer
> +	 * pointer for push operations to access - it is only safe to remove the
> +	 * inode from the buffer once it has been removed from the AIL.
> +	 *
> +	 * We also clear the failed bit before removing the item from the AIL
> +	 * as xfs_trans_ail_delete()->xfs_clear_li_failed() will release buffer
> +	 * references the inode item owns and needs to hold until we've fully
> +	 * aborted the inode log item and detatched it from the buffer.

Nit: detached

> +	 */
> +	clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);

I wonder, is there any chance the AIL will stumble onto the inode item
right here?

> +	xfs_trans_ail_delete(&iip->ili_item, 0);
> +
> +	/*
> +	 * Capture the associated buffer and lock it if the caller didn't
> +	 * pass us the locked buffer to begin with.

I agree that we're capturing the buffer here, but this function is not
locking the buffer since the comment says that the caller has to hold
the buffer lock already, correct?  And AFAICT from looking at all the
callers, they all hold the buffer locked, like the comment requires.

--D

> +	 */
> +	spin_lock(&iip->ili_lock);
> +	bp = iip->ili_item.li_buf;
> +	xfs_iflush_abort_clean(iip);
> +	spin_unlock(&iip->ili_lock);
> +
> +
> +	xfs_iflags_clear(ip, XFS_IFLUSHING);
> +
> +	/* we can now release the buffer reference the inode log item held. */
> +	if (bp)
> +		xfs_buf_rele(bp);
> +}
>  
> +/*
> + * Abort an inode flush in the case of a shutdown filesystem. This can be called
> + * from anywhere with just an inode reference and does not require holding the
> + * inode cluster buffer locked. If the inode is attached to a cluster buffer,
> + * it will grab and lock it safely, then abort the inode flush.
> + */
> +void
> +xfs_iflush_shutdown_abort(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
> +	struct xfs_buf		*bp;
> +
> +	if (!iip) {
> +		/* clean inode, nothing to do */
> +		xfs_iflags_clear(ip, XFS_IFLUSHING);
> +		return;
> +	}
> +
> +	spin_lock(&iip->ili_lock);
> +	bp = iip->ili_item.li_buf;
> +	if (!bp) {
> +		spin_unlock(&iip->ili_lock);
> +		xfs_iflush_abort(ip);
> +		return;
> +	}
> +
> +	/*
> +	 * We have to take a reference to the buffer so that it doesn't get
> +	 * freed when we drop the ili_lock and then wait to lock the buffer.
> +	 * We'll clean up the extra reference after we pick up the ili_lock
> +	 * again.
> +	 */
> +	xfs_buf_hold(bp);
> +	spin_unlock(&iip->ili_lock);
> +	xfs_buf_lock(bp);
> +
> +	spin_lock(&iip->ili_lock);
> +	if (!iip->ili_item.li_buf) {
>  		/*
> -		 * Clear the inode logging fields so no more flushes are
> -		 * attempted.
> +		 * Raced with another removal, hold the only reference
> +		 * to bp now. Inode should not be in the AIL now, so just clean
> +		 * up and return;
>  		 */
> -		spin_lock(&iip->ili_lock);
> -		iip->ili_last_fields = 0;
> -		iip->ili_fields = 0;
> -		iip->ili_fsync_fields = 0;
> -		iip->ili_flush_lsn = 0;
> -		bp = iip->ili_item.li_buf;
> -		iip->ili_item.li_buf = NULL;
> -		list_del_init(&iip->ili_item.li_bio_list);
> +		ASSERT(list_empty(&iip->ili_item.li_bio_list));
> +		ASSERT(!test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags));
> +		xfs_iflush_abort_clean(iip);
>  		spin_unlock(&iip->ili_lock);
> +		xfs_iflags_clear(ip, XFS_IFLUSHING);
> +		xfs_buf_relse(bp);
> +		return;
>  	}
> -	xfs_iflags_clear(ip, XFS_IFLUSHING);
> -	if (bp)
> -		xfs_buf_rele(bp);
> +
> +	/*
> +	 * Got two references to bp. The first will get dropped by
> +	 * xfs_iflush_abort() when the item is removed from the buffer list, but
> +	 * we can't drop our reference until _abort() returns because we have to
> +	 * unlock the buffer as well. Hence we abort and then unlock and release
> +	 * our reference to the buffer.
> +	 */
> +	ASSERT(iip->ili_item.li_buf == bp);
> +	spin_unlock(&iip->ili_lock);
> +	xfs_iflush_abort(ip);
> +	xfs_buf_relse(bp);
>  }
>  
> +
>  /*
>   * convert an xfs_inode_log_format struct from the old 32 bit version
>   * (which can have different field alignments) to the native 64 bit version
> diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> index 1a302000d604..bbd836a44ff0 100644
> --- a/fs/xfs/xfs_inode_item.h
> +++ b/fs/xfs/xfs_inode_item.h
> @@ -44,6 +44,7 @@ static inline int xfs_inode_clean(struct xfs_inode *ip)
>  extern void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
>  extern void xfs_inode_item_destroy(struct xfs_inode *);
>  extern void xfs_iflush_abort(struct xfs_inode *);
> +extern void xfs_iflush_shutdown_abort(struct xfs_inode *);
>  extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
>  					 struct xfs_inode_log_format *);
>  
> -- 
> 2.35.1
> 
