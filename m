Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED5E7C5B72
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Oct 2023 20:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbjJKSjG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Oct 2023 14:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbjJKSjF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 14:39:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752A39D
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 11:39:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086F2C433C7;
        Wed, 11 Oct 2023 18:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697049543;
        bh=UbCn6O9YBidpTzFapwKPo7S7+nmU1avIXG3WnLaUUMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=siKd/d+xer9U0ZdlCwLhn/JBgvlQ8vYQhXu4bBTftSajGrYgjmOwp1hQ6LMq9ScuH
         eH7XMhkKwMSHpgFS/D+/RN8lniEQhh3z5UBldpEUsry9QqsdSa0Pk5bhoZLlRIRc0P
         QEZH8vaJYjY17vu45XBPtRrX2llyx4uXr+SsYkgP+2ZCSgykYu5fzlblYWTgDPpp+o
         jGMWw1cgC54w+pnKFg3w0jlYmxvqL7Z8JE7hn8ZfsBJl22mv4gErXp/lYciGXaMVLj
         Ald8j4SwqsuFmvegq6oOxP3+AKzFJQCIl4pz0jU4e/A1OZkUH+W+1HcLlaveCTvZzR
         DgE4swulMf8rg==
Date:   Wed, 11 Oct 2023 11:39:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fsverity@lists.linux.dev, ebiggers@kernel.org, david@fromorbit.com,
        dchinner@redhat.com
Subject: Re: [PATCH v3 12/28] iomap: allow filesystem to implement read path
 verification
Message-ID: <20231011183902.GO21298@frogsfrogsfrogs>
References: <20231006184922.252188-1-aalbersh@redhat.com>
 <20231006184922.252188-13-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006184922.252188-13-aalbersh@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 06, 2023 at 08:49:06PM +0200, Andrey Albershteyn wrote:
> Currently, there is no interface to let filesystem do
> post-processing of completed BIO (ioend) in read path. This can be
> very handy for fs-verity verification. This patch add a callout to
> filesystem provided ->submit_bio to configure BIO completion callout.
> 
> The read path ioend iomap_read_ioend are stored side by side with
> BIOs allocated from filesystem provided bio_set.
> 
> Add IOMAP_F_READ_VERITY which indicates that iomap need to
> verify BIO (e.g. fs-verity) after I/O is completed.
> 
> Any verification itself happens on filesystem side. The verification
> is done when the BIO is processed by calling out ->bi_end_io().
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  fs/iomap/buffered-io.c | 40 +++++++++++++++++++++++++++++++++-------
>  include/linux/iomap.h  | 15 +++++++++++++++
>  2 files changed, 48 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index ca78c7f62527..0a1bec91fdf6 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -332,6 +332,19 @@ static inline bool iomap_block_needs_zeroing(const struct iomap_iter *iter,
>  		pos >= i_size_read(iter->inode);
>  }
>  
> +static void
> +iomap_submit_read_io(const struct iomap_iter *iter,
> +		struct iomap_readpage_ctx *ctx)
> +{
> +	if (!ctx->bio)
> +		return;
> +
> +	if (ctx->ops && ctx->ops->submit_io)
> +		ctx->ops->submit_io(iter, ctx->bio, iter->pos);
> +	else
> +		submit_bio(ctx->bio);
> +}
> +
>  static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
>  		struct iomap_readpage_ctx *ctx, loff_t offset)
>  {
> @@ -355,6 +368,13 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
>  
>  	if (iomap_block_needs_zeroing(iter, pos)) {
>  		folio_zero_range(folio, poff, plen);
> +		if (iomap->flags & IOMAP_F_READ_VERITY) {
> +			if (ctx->ops->verify_folio(folio, poff, plen)) {

What validation does fsverity need to do for zeroed folios that aren't
read from disk?  Does that imply that holes and unwritten extents are
allowed in fsverity files, and that the merkle tree will actually
contain an entry for them?

> +				folio_set_error(folio);
> +				goto done;
> +			}
> +		}
> +
>  		iomap_set_range_uptodate(folio, poff, plen);
>  		goto done;
>  	}
> @@ -371,13 +391,20 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
>  		gfp_t orig_gfp = gfp;
>  		unsigned int nr_vecs = DIV_ROUND_UP(length, PAGE_SIZE);
>  
> -		if (ctx->bio)
> -			submit_bio(ctx->bio);
> +		iomap_submit_read_io(iter, ctx);
>  
>  		if (ctx->rac) /* same as readahead_gfp_mask */
>  			gfp |= __GFP_NORETRY | __GFP_NOWARN;
> -		ctx->bio = bio_alloc(iomap->bdev, bio_max_segs(nr_vecs),
> -				     REQ_OP_READ, gfp);
> +
> +		if (ctx->ops && ctx->ops->bio_set)
> +			ctx->bio = bio_alloc_bioset(iomap->bdev,
> +						    bio_max_segs(nr_vecs),
> +						    REQ_OP_READ, GFP_NOFS,
> +						    ctx->ops->bio_set);
> +		else
> +			ctx->bio = bio_alloc(iomap->bdev, bio_max_segs(nr_vecs),
> +				REQ_OP_READ, gfp);

/methinks this should be in the previous patch, and without the
indenting damage.

--D

> +
>  		/*
>  		 * If the bio_alloc fails, try it again for a single page to
>  		 * avoid having to deal with partial page reads.  This emulates
> @@ -427,7 +454,7 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops,
>  		folio_set_error(folio);
>  
>  	if (ctx.bio) {
> -		submit_bio(ctx.bio);
> +		iomap_submit_read_io(&iter, &ctx);
>  		WARN_ON_ONCE(!ctx.cur_folio_in_bio);
>  	} else {
>  		WARN_ON_ONCE(ctx.cur_folio_in_bio);
> @@ -502,8 +529,7 @@ void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops,
>  	while (iomap_iter(&iter, ops) > 0)
>  		iter.processed = iomap_readahead_iter(&iter, &ctx);
>  
> -	if (ctx.bio)
> -		submit_bio(ctx.bio);
> +	iomap_submit_read_io(&iter, &ctx);
>  	if (ctx.cur_folio) {
>  		if (!ctx.cur_folio_in_bio)
>  			folio_unlock(ctx.cur_folio);
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 3565c449f3c9..8d7206cd2f0f 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -53,6 +53,9 @@ struct vm_fault;
>   *
>   * IOMAP_F_XATTR indicates that the iomap is for an extended attribute extent
>   * rather than a file data extent.
> + *
> + * IOMAP_F_READ_VERITY indicates that the iomap needs verification of read
> + * folios
>   */
>  #define IOMAP_F_NEW		(1U << 0)
>  #define IOMAP_F_DIRTY		(1U << 1)
> @@ -64,6 +67,7 @@ struct vm_fault;
>  #define IOMAP_F_BUFFER_HEAD	0
>  #endif /* CONFIG_BUFFER_HEAD */
>  #define IOMAP_F_XATTR		(1U << 5)
> +#define IOMAP_F_READ_VERITY	(1U << 6)
>  
>  /*
>   * Flags set by the core iomap code during operations:
> @@ -262,7 +266,18 @@ int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
>  		struct iomap *iomap, loff_t pos, loff_t length, ssize_t written,
>  		int (*punch)(struct inode *inode, loff_t pos, loff_t length));
>  
> +struct iomap_read_ioend {
> +	struct inode		*io_inode;	/* file being read from */
> +	struct work_struct	work;		/* post read work (e.g. fs-verity) */
> +	struct bio		read_inline_bio;/* MUST BE LAST! */
> +};
> +
>  struct iomap_readpage_ops {
> +	/*
> +	 * Optional, verify folio when successfully read
> +	 */
> +	int (*verify_folio)(struct folio *folio, loff_t pos, unsigned int len);
> +
>  	/*
>  	 * Filesystems wishing to attach private information to a direct io bio
>  	 * must provide a ->submit_io method that attaches the additional
> -- 
> 2.40.1
> 
