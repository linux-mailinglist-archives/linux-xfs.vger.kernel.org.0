Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA3925630
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 18:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfEUQyU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 12:54:20 -0400
Received: from sandeen.net ([63.231.237.45]:60628 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728998AbfEUQyU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 12:54:20 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D1798325F;
        Tue, 21 May 2019 11:54:15 -0500 (CDT)
Subject: Re: [PATCH 07/12] libfrog: fix bitmap return values
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839424514.68606.14562327454853103352.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <5caa6c9e-3a42-6c8e-101b-c198af77e765@sandeen.net>
Date:   Tue, 21 May 2019 11:54:18 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <155839424514.68606.14562327454853103352.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/20/19 6:17 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix the return types of non-predicate bitmap functions to return the
> usual negative error codes instead of the "moveon" boolean.

This seems much better, though how did you decide on negative
error codes?  They are usual for the kernel, but in userspace
we have kind of a mishmash, even in libfrog.

  File                 Function                 Line
0 libfrog/paths.c      fs_table_insert          176 error = ENOMEM;
1 libfrog/paths.c      fs_extract_mount_options 354 return ENOMEM;
2 libfrog/radix-tree.c radix_tree_extend        135 return -ENOMEM;
3 libfrog/radix-tree.c radix_tree_insert        188 return -ENOMEM;
4 libfrog/workqueue.c  workqueue_add            110 return ENOMEM;

3 libfrog/paths.c         fs_table_initialise_mounts         384 return ENOENT;
4 libfrog/paths.c         fs_table_initialise_projects       489 error = ENOENT;
5 libfrog/paths.c         fs_table_insert_project_path       560 error = ENOENT;



> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/bitmap.h |    8 +++--
>  libfrog/bitmap.c |   86 ++++++++++++++++++++++++++----------------------------
>  repair/rmap.c    |   18 ++++++++---
>  scrub/phase6.c   |   18 ++++-------
>  4 files changed, 65 insertions(+), 65 deletions(-)
> 
> 
> diff --git a/include/bitmap.h b/include/bitmap.h
> index e29a4335..99a2fb23 100644
> --- a/include/bitmap.h
> +++ b/include/bitmap.h
> @@ -11,11 +11,11 @@ struct bitmap {
>  	struct avl64tree_desc	*bt_tree;
>  };
>  
> -bool bitmap_init(struct bitmap **bmap);
> +int bitmap_init(struct bitmap **bmap);
>  void bitmap_free(struct bitmap **bmap);
> -bool bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
> -bool bitmap_iterate(struct bitmap *bmap,
> -		bool (*fn)(uint64_t, uint64_t, void *), void *arg);
> +int bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
> +int bitmap_iterate(struct bitmap *bmap, int (*fn)(uint64_t, uint64_t, void *),
> +		void *arg);
>  bool bitmap_test(struct bitmap *bmap, uint64_t start,
>  		uint64_t len);
>  bool bitmap_empty(struct bitmap *bmap);
> diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
> index 450ebe0a..4dafc4c9 100644
> --- a/libfrog/bitmap.c
> +++ b/libfrog/bitmap.c
> @@ -66,7 +66,7 @@ static struct avl64ops bitmap_ops = {
>  };
>  
>  /* Initialize a bitmap. */
> -bool
> +int
>  bitmap_init(
>  	struct bitmap		**bmapp)
>  {
> @@ -74,18 +74,18 @@ bitmap_init(
>  
>  	bmap = calloc(1, sizeof(struct bitmap));
>  	if (!bmap)
> -		return false;
> +		return -ENOMEM;
>  	bmap->bt_tree = malloc(sizeof(struct avl64tree_desc));
>  	if (!bmap->bt_tree) {
>  		free(bmap);
> -		return false;
> +		return -ENOMEM;
>  	}
>  
>  	pthread_mutex_init(&bmap->bt_lock, NULL);
>  	avl64_init_tree(bmap->bt_tree, &bitmap_ops);
>  	*bmapp = bmap;
>  
> -	return true;
> +	return 0;
>  }
>  
>  /* Free a bitmap. */
> @@ -127,8 +127,31 @@ bitmap_node_init(
>  	return ext;
>  }
>  
> +/* Create a new bitmap node and insert it. */
> +static inline int
> +__bitmap_insert(
> +	struct bitmap		*bmap,
> +	uint64_t		start,
> +	uint64_t		length)
> +{
> +	struct bitmap_node	*ext;
> +	struct avl64node	*node;
> +
> +	ext = bitmap_node_init(start, length);
> +	if (!ext)
> +		return -ENOMEM;
> +
> +	node = avl64_insert(bmap->bt_tree, &ext->btn_node);
> +	if (node == NULL) {
> +		free(ext);
> +		return -EEXIST;
> +	}
> +
> +	return 0;
> +}
> +
>  /* Set a region of bits (locked). */
> -static bool
> +static int
>  __bitmap_set(
>  	struct bitmap		*bmap,
>  	uint64_t		start,
> @@ -142,28 +165,14 @@ __bitmap_set(
>  	struct bitmap_node	*ext;
>  	uint64_t		new_start;
>  	uint64_t		new_length;
> -	struct avl64node	*node;
> -	bool			res = true;
>  
>  	/* Find any existing nodes adjacent or within that range. */
>  	avl64_findranges(bmap->bt_tree, start - 1, start + length + 1,
>  			&firstn, &lastn);
>  
>  	/* Nothing, just insert a new extent. */
> -	if (firstn == NULL && lastn == NULL) {
> -		ext = bitmap_node_init(start, length);
> -		if (!ext)
> -			return false;
> -
> -		node = avl64_insert(bmap->bt_tree, &ext->btn_node);
> -		if (node == NULL) {
> -			free(ext);
> -			errno = EEXIST;
> -			return false;
> -		}
> -
> -		return true;
> -	}
> +	if (firstn == NULL && lastn == NULL)
> +		return __bitmap_insert(bmap, start, length);
>  
>  	assert(firstn != NULL && lastn != NULL);
>  	new_start = start;
> @@ -175,7 +184,7 @@ __bitmap_set(
>  		/* Bail if the new extent is contained within an old one. */
>  		if (ext->btn_start <= start &&
>  		    ext->btn_start + ext->btn_length >= start + length)
> -			return res;
> +			return 0;
>  
>  		/* Check for overlapping and adjacent extents. */
>  		if (ext->btn_start + ext->btn_length >= start ||
> @@ -195,28 +204,17 @@ __bitmap_set(
>  		}
>  	}
>  
> -	ext = bitmap_node_init(new_start, new_length);
> -	if (!ext)
> -		return false;
> -
> -	node = avl64_insert(bmap->bt_tree, &ext->btn_node);
> -	if (node == NULL) {
> -		free(ext);
> -		errno = EEXIST;
> -		return false;
> -	}
> -
> -	return res;
> +	return __bitmap_insert(bmap, new_start, new_length);
>  }
>  
>  /* Set a region of bits. */
> -bool
> +int
>  bitmap_set(
>  	struct bitmap		*bmap,
>  	uint64_t		start,
>  	uint64_t		length)
>  {
> -	bool			res;
> +	int			res;
>  
>  	pthread_mutex_lock(&bmap->bt_lock);
>  	res = __bitmap_set(bmap, start, length);
> @@ -308,26 +306,26 @@ bitmap_clear(
>  
>  #ifdef DEBUG
>  /* Iterate the set regions of this bitmap. */
> -bool
> +int
>  bitmap_iterate(
>  	struct bitmap		*bmap,
> -	bool			(*fn)(uint64_t, uint64_t, void *),
> +	int			(*fn)(uint64_t, uint64_t, void *),
>  	void			*arg)
>  {
>  	struct avl64node	*node;
>  	struct bitmap_node	*ext;
> -	bool			moveon = true;
> +	int			error = 0;
>  
>  	pthread_mutex_lock(&bmap->bt_lock);
>  	avl_for_each(bmap->bt_tree, node) {
>  		ext = container_of(node, struct bitmap_node, btn_node);
> -		moveon = fn(ext->btn_start, ext->btn_length, arg);
> -		if (!moveon)
> +		error = fn(ext->btn_start, ext->btn_length, arg);
> +		if (error)
>  			break;
>  	}
>  	pthread_mutex_unlock(&bmap->bt_lock);
>  
> -	return moveon;
> +	return error;
>  }
>  #endif
>  
> @@ -372,14 +370,14 @@ bitmap_empty(
>  }
>  
>  #ifdef DEBUG
> -static bool
> +static int
>  bitmap_dump_fn(
>  	uint64_t		startblock,
>  	uint64_t		blockcount,
>  	void			*arg)
>  {
>  	printf("%"PRIu64":%"PRIu64"\n", startblock, blockcount);
> -	return true;
> +	return 0;
>  }
>  
>  /* Dump bitmap. */
> diff --git a/repair/rmap.c b/repair/rmap.c
> index 19cceca3..47828a06 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -490,16 +490,22 @@ rmap_store_ag_btree_rec(
>  	error = init_slab_cursor(ag_rmap->ar_raw_rmaps, rmap_compare, &rm_cur);
>  	if (error)
>  		goto err;
> -	if (!bitmap_init(&own_ag_bitmap)) {
> -		error = -ENOMEM;
> +	error = -bitmap_init(&own_ag_bitmap);
> +	if (error)
>  		goto err_slab;
> -	}
>  	while ((rm_rec = pop_slab_cursor(rm_cur)) != NULL) {
>  		if (rm_rec->rm_owner != XFS_RMAP_OWN_AG)
>  			continue;
> -		if (!bitmap_set(own_ag_bitmap, rm_rec->rm_startblock,
> -					rm_rec->rm_blockcount)) {
> -			error = EFSCORRUPTED;
> +		error = -bitmap_set(own_ag_bitmap, rm_rec->rm_startblock,
> +					rm_rec->rm_blockcount);
> +		if (error) {
> +			/*
> +			 * If this range is already set, then the incore rmap
> +			 * records for the AG free space btrees overlap and
> +			 * we're toast because that is not allowed.
> +			 */
> +			if (error == EEXIST)
> +				error = EFSCORRUPTED;
>  			goto err_slab;
>  		}
>  	}
> diff --git a/scrub/phase6.c b/scrub/phase6.c
> index 4b25f3bb..66e6451c 100644
> --- a/scrub/phase6.c
> +++ b/scrub/phase6.c
> @@ -341,7 +341,6 @@ xfs_check_rmap_ioerr(
>  	struct media_verify_state	*vs = arg;
>  	struct bitmap			*tree;
>  	dev_t				dev;
> -	bool				moveon;
>  
>  	dev = xfs_disk_to_dev(ctx, disk);
>  
> @@ -356,8 +355,8 @@ xfs_check_rmap_ioerr(
>  	else
>  		tree = NULL;
>  	if (tree) {
> -		moveon = bitmap_set(tree, start, length);
> -		if (!moveon)
> +		errno = -bitmap_set(tree, start, length);
> +		if (errno)
>  			str_errno(ctx, ctx->mntpoint);
>  	}
>  
> @@ -454,16 +453,16 @@ xfs_scan_blocks(
>  	struct scrub_ctx		*ctx)
>  {
>  	struct media_verify_state	vs = { NULL };
> -	bool				moveon;
> +	bool				moveon = false;
>  
> -	moveon = bitmap_init(&vs.d_bad);
> -	if (!moveon) {
> +	errno = -bitmap_init(&vs.d_bad);
> +	if (errno) {
>  		str_errno(ctx, ctx->mntpoint);
>  		goto out;
>  	}
>  
> -	moveon = bitmap_init(&vs.r_bad);
> -	if (!moveon) {
> +	errno = -bitmap_init(&vs.r_bad);
> +	if (errno) {
>  		str_errno(ctx, ctx->mntpoint);
>  		goto out_dbad;
>  	}
> @@ -472,7 +471,6 @@ xfs_scan_blocks(
>  			ctx->geo.blocksize, xfs_check_rmap_ioerr,
>  			scrub_nproc(ctx));
>  	if (!vs.rvp_data) {
> -		moveon = false;
>  		str_info(ctx, ctx->mntpoint,
>  _("Could not create data device media verifier."));
>  		goto out_rbad;
> @@ -482,7 +480,6 @@ _("Could not create data device media verifier."));
>  				ctx->geo.blocksize, xfs_check_rmap_ioerr,
>  				scrub_nproc(ctx));
>  		if (!vs.rvp_log) {
> -			moveon = false;
>  			str_info(ctx, ctx->mntpoint,
>  	_("Could not create log device media verifier."));
>  			goto out_datapool;
> @@ -493,7 +490,6 @@ _("Could not create data device media verifier."));
>  				ctx->geo.blocksize, xfs_check_rmap_ioerr,
>  				scrub_nproc(ctx));
>  		if (!vs.rvp_realtime) {
> -			moveon = false;
>  			str_info(ctx, ctx->mntpoint,
>  	_("Could not create realtime device media verifier."));
>  			goto out_logpool;
> 
