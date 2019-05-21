Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6796E25646
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 19:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfEURBI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 May 2019 13:01:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44416 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbfEURBI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 May 2019 13:01:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LGxctn002283;
        Tue, 21 May 2019 17:01:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=/psuSVBv2W8mcDBxQoTI+L9el9caAelJki06+TfXZ0E=;
 b=gw9IwWocfzN+HMMur6xBGdFOEDHjHIC4nzGt6pC9vl40ldEr0BXI2UigPcYn4N52azV7
 jYE3qveO1HBcBQvPQ0ZZ/bnKQK1fPa599TqxH9qhqpIP0+kDyg3aIE/ceJtrVS9j5YAk
 FXQgdtSWyYK56LUdTIlGrZZ6AnPtZjdH8Fwm+h+XZAyp+DbaimnRisjUiu4QIA9SstcS
 p+Qye0LVgFy7Z06qKQrJv//I4N5Am9ID9VnQMChHK55c2ToxesaMJp7JP4fNujT6iqeE
 o8/QhXdhnaZWUrVaQMiSlUZYbEopBDxMQVQTXDeK3V7k7MzO9xzc5959RANt0s5tR+Uz RQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2sj9ftevb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 17:01:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LGxWOC191734;
        Tue, 21 May 2019 17:01:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2sks1yahyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 17:01:05 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4LH14rS013325;
        Tue, 21 May 2019 17:01:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 May 2019 17:01:04 +0000
Date:   Tue, 21 May 2019 10:01:03 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] libfrog: fix bitmap return values
Message-ID: <20190521170103.GD5141@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839424514.68606.14562327454853103352.stgit@magnolia>
 <5caa6c9e-3a42-6c8e-101b-c198af77e765@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5caa6c9e-3a42-6c8e-101b-c198af77e765@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905210104
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210104
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 21, 2019 at 11:54:18AM -0500, Eric Sandeen wrote:
> On 5/20/19 6:17 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fix the return types of non-predicate bitmap functions to return the
> > usual negative error codes instead of the "moveon" boolean.
> 
> This seems much better, though how did you decide on negative
> error codes?  They are usual for the kernel, but in userspace
> we have kind of a mishmash, even in libfrog.
> 
>   File                 Function                 Line
> 0 libfrog/paths.c      fs_table_insert          176 error = ENOMEM;
> 1 libfrog/paths.c      fs_extract_mount_options 354 return ENOMEM;
> 2 libfrog/radix-tree.c radix_tree_extend        135 return -ENOMEM;
> 3 libfrog/radix-tree.c radix_tree_insert        188 return -ENOMEM;
> 4 libfrog/workqueue.c  workqueue_add            110 return ENOMEM;
> 
> 3 libfrog/paths.c         fs_table_initialise_mounts         384 return ENOENT;
> 4 libfrog/paths.c         fs_table_initialise_projects       489 error = ENOENT;
> 5 libfrog/paths.c         fs_table_insert_project_path       560 error = ENOENT;

Blindly copying libxfs style. :)

I see your point about being consistent within libfrog but OTOH it's
messy that we're not consistent across the various xfsprogs libraries.

Uhm.... I'll change it if you want.

--D

> 
> 
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  include/bitmap.h |    8 +++--
> >  libfrog/bitmap.c |   86 ++++++++++++++++++++++++++----------------------------
> >  repair/rmap.c    |   18 ++++++++---
> >  scrub/phase6.c   |   18 ++++-------
> >  4 files changed, 65 insertions(+), 65 deletions(-)
> > 
> > 
> > diff --git a/include/bitmap.h b/include/bitmap.h
> > index e29a4335..99a2fb23 100644
> > --- a/include/bitmap.h
> > +++ b/include/bitmap.h
> > @@ -11,11 +11,11 @@ struct bitmap {
> >  	struct avl64tree_desc	*bt_tree;
> >  };
> >  
> > -bool bitmap_init(struct bitmap **bmap);
> > +int bitmap_init(struct bitmap **bmap);
> >  void bitmap_free(struct bitmap **bmap);
> > -bool bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
> > -bool bitmap_iterate(struct bitmap *bmap,
> > -		bool (*fn)(uint64_t, uint64_t, void *), void *arg);
> > +int bitmap_set(struct bitmap *bmap, uint64_t start, uint64_t length);
> > +int bitmap_iterate(struct bitmap *bmap, int (*fn)(uint64_t, uint64_t, void *),
> > +		void *arg);
> >  bool bitmap_test(struct bitmap *bmap, uint64_t start,
> >  		uint64_t len);
> >  bool bitmap_empty(struct bitmap *bmap);
> > diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
> > index 450ebe0a..4dafc4c9 100644
> > --- a/libfrog/bitmap.c
> > +++ b/libfrog/bitmap.c
> > @@ -66,7 +66,7 @@ static struct avl64ops bitmap_ops = {
> >  };
> >  
> >  /* Initialize a bitmap. */
> > -bool
> > +int
> >  bitmap_init(
> >  	struct bitmap		**bmapp)
> >  {
> > @@ -74,18 +74,18 @@ bitmap_init(
> >  
> >  	bmap = calloc(1, sizeof(struct bitmap));
> >  	if (!bmap)
> > -		return false;
> > +		return -ENOMEM;
> >  	bmap->bt_tree = malloc(sizeof(struct avl64tree_desc));
> >  	if (!bmap->bt_tree) {
> >  		free(bmap);
> > -		return false;
> > +		return -ENOMEM;
> >  	}
> >  
> >  	pthread_mutex_init(&bmap->bt_lock, NULL);
> >  	avl64_init_tree(bmap->bt_tree, &bitmap_ops);
> >  	*bmapp = bmap;
> >  
> > -	return true;
> > +	return 0;
> >  }
> >  
> >  /* Free a bitmap. */
> > @@ -127,8 +127,31 @@ bitmap_node_init(
> >  	return ext;
> >  }
> >  
> > +/* Create a new bitmap node and insert it. */
> > +static inline int
> > +__bitmap_insert(
> > +	struct bitmap		*bmap,
> > +	uint64_t		start,
> > +	uint64_t		length)
> > +{
> > +	struct bitmap_node	*ext;
> > +	struct avl64node	*node;
> > +
> > +	ext = bitmap_node_init(start, length);
> > +	if (!ext)
> > +		return -ENOMEM;
> > +
> > +	node = avl64_insert(bmap->bt_tree, &ext->btn_node);
> > +	if (node == NULL) {
> > +		free(ext);
> > +		return -EEXIST;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /* Set a region of bits (locked). */
> > -static bool
> > +static int
> >  __bitmap_set(
> >  	struct bitmap		*bmap,
> >  	uint64_t		start,
> > @@ -142,28 +165,14 @@ __bitmap_set(
> >  	struct bitmap_node	*ext;
> >  	uint64_t		new_start;
> >  	uint64_t		new_length;
> > -	struct avl64node	*node;
> > -	bool			res = true;
> >  
> >  	/* Find any existing nodes adjacent or within that range. */
> >  	avl64_findranges(bmap->bt_tree, start - 1, start + length + 1,
> >  			&firstn, &lastn);
> >  
> >  	/* Nothing, just insert a new extent. */
> > -	if (firstn == NULL && lastn == NULL) {
> > -		ext = bitmap_node_init(start, length);
> > -		if (!ext)
> > -			return false;
> > -
> > -		node = avl64_insert(bmap->bt_tree, &ext->btn_node);
> > -		if (node == NULL) {
> > -			free(ext);
> > -			errno = EEXIST;
> > -			return false;
> > -		}
> > -
> > -		return true;
> > -	}
> > +	if (firstn == NULL && lastn == NULL)
> > +		return __bitmap_insert(bmap, start, length);
> >  
> >  	assert(firstn != NULL && lastn != NULL);
> >  	new_start = start;
> > @@ -175,7 +184,7 @@ __bitmap_set(
> >  		/* Bail if the new extent is contained within an old one. */
> >  		if (ext->btn_start <= start &&
> >  		    ext->btn_start + ext->btn_length >= start + length)
> > -			return res;
> > +			return 0;
> >  
> >  		/* Check for overlapping and adjacent extents. */
> >  		if (ext->btn_start + ext->btn_length >= start ||
> > @@ -195,28 +204,17 @@ __bitmap_set(
> >  		}
> >  	}
> >  
> > -	ext = bitmap_node_init(new_start, new_length);
> > -	if (!ext)
> > -		return false;
> > -
> > -	node = avl64_insert(bmap->bt_tree, &ext->btn_node);
> > -	if (node == NULL) {
> > -		free(ext);
> > -		errno = EEXIST;
> > -		return false;
> > -	}
> > -
> > -	return res;
> > +	return __bitmap_insert(bmap, new_start, new_length);
> >  }
> >  
> >  /* Set a region of bits. */
> > -bool
> > +int
> >  bitmap_set(
> >  	struct bitmap		*bmap,
> >  	uint64_t		start,
> >  	uint64_t		length)
> >  {
> > -	bool			res;
> > +	int			res;
> >  
> >  	pthread_mutex_lock(&bmap->bt_lock);
> >  	res = __bitmap_set(bmap, start, length);
> > @@ -308,26 +306,26 @@ bitmap_clear(
> >  
> >  #ifdef DEBUG
> >  /* Iterate the set regions of this bitmap. */
> > -bool
> > +int
> >  bitmap_iterate(
> >  	struct bitmap		*bmap,
> > -	bool			(*fn)(uint64_t, uint64_t, void *),
> > +	int			(*fn)(uint64_t, uint64_t, void *),
> >  	void			*arg)
> >  {
> >  	struct avl64node	*node;
> >  	struct bitmap_node	*ext;
> > -	bool			moveon = true;
> > +	int			error = 0;
> >  
> >  	pthread_mutex_lock(&bmap->bt_lock);
> >  	avl_for_each(bmap->bt_tree, node) {
> >  		ext = container_of(node, struct bitmap_node, btn_node);
> > -		moveon = fn(ext->btn_start, ext->btn_length, arg);
> > -		if (!moveon)
> > +		error = fn(ext->btn_start, ext->btn_length, arg);
> > +		if (error)
> >  			break;
> >  	}
> >  	pthread_mutex_unlock(&bmap->bt_lock);
> >  
> > -	return moveon;
> > +	return error;
> >  }
> >  #endif
> >  
> > @@ -372,14 +370,14 @@ bitmap_empty(
> >  }
> >  
> >  #ifdef DEBUG
> > -static bool
> > +static int
> >  bitmap_dump_fn(
> >  	uint64_t		startblock,
> >  	uint64_t		blockcount,
> >  	void			*arg)
> >  {
> >  	printf("%"PRIu64":%"PRIu64"\n", startblock, blockcount);
> > -	return true;
> > +	return 0;
> >  }
> >  
> >  /* Dump bitmap. */
> > diff --git a/repair/rmap.c b/repair/rmap.c
> > index 19cceca3..47828a06 100644
> > --- a/repair/rmap.c
> > +++ b/repair/rmap.c
> > @@ -490,16 +490,22 @@ rmap_store_ag_btree_rec(
> >  	error = init_slab_cursor(ag_rmap->ar_raw_rmaps, rmap_compare, &rm_cur);
> >  	if (error)
> >  		goto err;
> > -	if (!bitmap_init(&own_ag_bitmap)) {
> > -		error = -ENOMEM;
> > +	error = -bitmap_init(&own_ag_bitmap);
> > +	if (error)
> >  		goto err_slab;
> > -	}
> >  	while ((rm_rec = pop_slab_cursor(rm_cur)) != NULL) {
> >  		if (rm_rec->rm_owner != XFS_RMAP_OWN_AG)
> >  			continue;
> > -		if (!bitmap_set(own_ag_bitmap, rm_rec->rm_startblock,
> > -					rm_rec->rm_blockcount)) {
> > -			error = EFSCORRUPTED;
> > +		error = -bitmap_set(own_ag_bitmap, rm_rec->rm_startblock,
> > +					rm_rec->rm_blockcount);
> > +		if (error) {
> > +			/*
> > +			 * If this range is already set, then the incore rmap
> > +			 * records for the AG free space btrees overlap and
> > +			 * we're toast because that is not allowed.
> > +			 */
> > +			if (error == EEXIST)
> > +				error = EFSCORRUPTED;
> >  			goto err_slab;
> >  		}
> >  	}
> > diff --git a/scrub/phase6.c b/scrub/phase6.c
> > index 4b25f3bb..66e6451c 100644
> > --- a/scrub/phase6.c
> > +++ b/scrub/phase6.c
> > @@ -341,7 +341,6 @@ xfs_check_rmap_ioerr(
> >  	struct media_verify_state	*vs = arg;
> >  	struct bitmap			*tree;
> >  	dev_t				dev;
> > -	bool				moveon;
> >  
> >  	dev = xfs_disk_to_dev(ctx, disk);
> >  
> > @@ -356,8 +355,8 @@ xfs_check_rmap_ioerr(
> >  	else
> >  		tree = NULL;
> >  	if (tree) {
> > -		moveon = bitmap_set(tree, start, length);
> > -		if (!moveon)
> > +		errno = -bitmap_set(tree, start, length);
> > +		if (errno)
> >  			str_errno(ctx, ctx->mntpoint);
> >  	}
> >  
> > @@ -454,16 +453,16 @@ xfs_scan_blocks(
> >  	struct scrub_ctx		*ctx)
> >  {
> >  	struct media_verify_state	vs = { NULL };
> > -	bool				moveon;
> > +	bool				moveon = false;
> >  
> > -	moveon = bitmap_init(&vs.d_bad);
> > -	if (!moveon) {
> > +	errno = -bitmap_init(&vs.d_bad);
> > +	if (errno) {
> >  		str_errno(ctx, ctx->mntpoint);
> >  		goto out;
> >  	}
> >  
> > -	moveon = bitmap_init(&vs.r_bad);
> > -	if (!moveon) {
> > +	errno = -bitmap_init(&vs.r_bad);
> > +	if (errno) {
> >  		str_errno(ctx, ctx->mntpoint);
> >  		goto out_dbad;
> >  	}
> > @@ -472,7 +471,6 @@ xfs_scan_blocks(
> >  			ctx->geo.blocksize, xfs_check_rmap_ioerr,
> >  			scrub_nproc(ctx));
> >  	if (!vs.rvp_data) {
> > -		moveon = false;
> >  		str_info(ctx, ctx->mntpoint,
> >  _("Could not create data device media verifier."));
> >  		goto out_rbad;
> > @@ -482,7 +480,6 @@ _("Could not create data device media verifier."));
> >  				ctx->geo.blocksize, xfs_check_rmap_ioerr,
> >  				scrub_nproc(ctx));
> >  		if (!vs.rvp_log) {
> > -			moveon = false;
> >  			str_info(ctx, ctx->mntpoint,
> >  	_("Could not create log device media verifier."));
> >  			goto out_datapool;
> > @@ -493,7 +490,6 @@ _("Could not create data device media verifier."));
> >  				ctx->geo.blocksize, xfs_check_rmap_ioerr,
> >  				scrub_nproc(ctx));
> >  		if (!vs.rvp_realtime) {
> > -			moveon = false;
> >  			str_info(ctx, ctx->mntpoint,
> >  	_("Could not create realtime device media verifier."));
> >  			goto out_logpool;
> > 
