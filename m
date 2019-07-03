Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 418F05D1A6
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2019 16:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfGBOXs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 Jul 2019 10:23:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbfGBOXs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Jul 2019 10:23:48 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B4D6A307D860;
        Tue,  2 Jul 2019 14:23:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 337BF1713D;
        Tue,  2 Jul 2019 14:23:45 +0000 (UTC)
Date:   Tue, 2 Jul 2019 10:23:43 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/15] xfs: create simplified inode walk function
Message-ID: <20190702142343.GC2866@bfoster>
References: <156158183697.495087.5371839759804528321.stgit@magnolia>
 <156158184956.495087.12203869782949324427.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158184956.495087.12203869782949324427.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 02 Jul 2019 14:23:47 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 01:44:09PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a new iterator function to simplify walking inodes in an XFS
> filesystem.  This new iterator will replace the existing open-coded
> walking that goes on in various places.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/Makefile                  |    1 
>  fs/xfs/libxfs/xfs_ialloc_btree.c |   37 +++-
>  fs/xfs/libxfs/xfs_ialloc_btree.h |    3 
>  fs/xfs/xfs_itable.c              |    5 
>  fs/xfs/xfs_itable.h              |    8 +
>  fs/xfs/xfs_iwalk.c               |  389 ++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_iwalk.h               |   19 ++
>  fs/xfs/xfs_trace.h               |   40 ++++
>  8 files changed, 496 insertions(+), 6 deletions(-)
>  create mode 100644 fs/xfs/xfs_iwalk.c
>  create mode 100644 fs/xfs/xfs_iwalk.h
> 
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 91831975363b..74d30ef0dbce 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -80,6 +80,7 @@ xfs-y				+= xfs_aops.o \
>  				   xfs_iops.o \
>  				   xfs_inode.o \
>  				   xfs_itable.o \
> +				   xfs_iwalk.o \
>  				   xfs_message.o \
>  				   xfs_mount.o \
>  				   xfs_mru_cache.o \
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index ac4b65da4c2b..9f416ae08d73 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -564,6 +564,36 @@ xfs_inobt_max_size(
>  					XFS_INODES_PER_CHUNK);
>  }
>  
> +/* Read AGI and create inobt cursor. */
> +int
> +xfs_inobt_cur(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	xfs_btnum_t		which,
> +	struct xfs_btree_cur	**curpp,
> +	struct xfs_buf		**agi_bpp)
> +{
> +	struct xfs_btree_cur	*cur;
> +	int			error;
> +
> +	ASSERT(*agi_bpp == NULL);
> +	ASSERT(*curpp == NULL);
> +
> +	error = xfs_ialloc_read_agi(mp, tp, agno, agi_bpp);
> +	if (error)
> +		return error;
> +
> +	cur = xfs_inobt_init_cursor(mp, tp, *agi_bpp, agno, which);
> +	if (!cur) {
> +		xfs_trans_brelse(tp, *agi_bpp);
> +		*agi_bpp = NULL;
> +		return -ENOMEM;
> +	}
> +	*curpp = cur;
> +	return 0;
> +}
> +
>  static int
>  xfs_inobt_count_blocks(
>  	struct xfs_mount	*mp,
> @@ -572,15 +602,14 @@ xfs_inobt_count_blocks(
>  	xfs_btnum_t		btnum,
>  	xfs_extlen_t		*tree_blocks)
>  {
> -	struct xfs_buf		*agbp;
> -	struct xfs_btree_cur	*cur;
> +	struct xfs_buf		*agbp = NULL;
> +	struct xfs_btree_cur	*cur = NULL;
>  	int			error;
>  
> -	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
> +	error = xfs_inobt_cur(mp, tp, agno, btnum, &cur, &agbp);
>  	if (error)
>  		return error;
>  
> -	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
>  	error = xfs_btree_count_blocks(cur, tree_blocks);
>  	xfs_btree_del_cursor(cur, error);
>  	xfs_trans_brelse(tp, agbp);
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
> index ebdd0c6b8766..951305ecaae1 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.h
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
> @@ -64,5 +64,8 @@ int xfs_finobt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
>  		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
>  extern xfs_extlen_t xfs_iallocbt_calc_size(struct xfs_mount *mp,
>  		unsigned long long len);
> +int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
> +		xfs_agnumber_t agno, xfs_btnum_t btnum,
> +		struct xfs_btree_cur **curpp, struct xfs_buf **agi_bpp);
>  
>  #endif	/* __XFS_IALLOC_BTREE_H__ */
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index eef307cf90a7..3ca1c454afe6 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -19,6 +19,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
>  #include "xfs_health.h"
> +#include "xfs_iwalk.h"
>  
>  /*
>   * Return stat information for one inode.
> @@ -161,7 +162,7 @@ xfs_bulkstat_one(
>   * Loop over all clusters in a chunk for a given incore inode allocation btree
>   * record.  Do a readahead if there are any allocated inodes in that cluster.
>   */
> -STATIC void
> +void
>  xfs_bulkstat_ichunk_ra(
>  	struct xfs_mount		*mp,
>  	xfs_agnumber_t			agno,
> @@ -195,7 +196,7 @@ xfs_bulkstat_ichunk_ra(
>   * are some left allocated, update the data for the pointed-to record as well as
>   * return the count of grabbed inodes.
>   */
> -STATIC int
> +int
>  xfs_bulkstat_grab_ichunk(
>  	struct xfs_btree_cur		*cur,	/* btree cursor */
>  	xfs_agino_t			agino,	/* starting inode of chunk */
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 8a822285b671..369e3f159d4e 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -84,4 +84,12 @@ xfs_inumbers(
>  	void			__user *buffer, /* buffer with inode info */
>  	inumbers_fmt_pf		formatter);
>  
> +/* Temporarily needed while we refactor functions. */
> +struct xfs_btree_cur;
> +struct xfs_inobt_rec_incore;
> +void xfs_bulkstat_ichunk_ra(struct xfs_mount *mp, xfs_agnumber_t agno,
> +		struct xfs_inobt_rec_incore *irec);
> +int xfs_bulkstat_grab_ichunk(struct xfs_btree_cur *cur, xfs_agino_t agino,
> +		int *icount, struct xfs_inobt_rec_incore *irec);
> +
>  #endif	/* __XFS_ITABLE_H__ */
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> new file mode 100644
> index 000000000000..304c41e6ed1d
> --- /dev/null
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -0,0 +1,389 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_btree.h"
> +#include "xfs_ialloc.h"
> +#include "xfs_ialloc_btree.h"
> +#include "xfs_iwalk.h"
> +#include "xfs_itable.h"
> +#include "xfs_error.h"
> +#include "xfs_trace.h"
> +#include "xfs_icache.h"
> +#include "xfs_health.h"
> +#include "xfs_trans.h"
> +
> +/*
> + * Walking Inodes in the Filesystem
> + * ================================
> + *
> + * This iterator function walks a subset of filesystem inodes in increasing
> + * order from @startino until there are no more inodes.  For each allocated
> + * inode it finds, it calls a walk function with the relevant inode number and
> + * a pointer to caller-provided data.  The walk function can return the usual
> + * negative error code to stop the iteration; 0 to continue the iteration; or
> + * XFS_IWALK_ABORT to stop the iteration.  This return value is returned to the
> + * caller.
> + *
> + * Internally, we allow the walk function to do anything, which means that we
> + * cannot maintain the inobt cursor or our lock on the AGI buffer.  We
> + * therefore cache the inobt records in kernel memory and only call the walk
> + * function when our memory buffer is full.  @nr_recs is the number of records
> + * that we've cached, and @sz_recs is the size of our cache.
> + *
> + * It is the responsibility of the walk function to ensure it accesses
> + * allocated inodes, as the inobt records may be stale by the time they are
> + * acted upon.
> + */
> +
> +struct xfs_iwalk_ag {
> +	struct xfs_mount		*mp;
> +	struct xfs_trans		*tp;
> +
> +	/* Where do we start the traversal? */
> +	xfs_ino_t			startino;
> +
> +	/* Array of inobt records we cache. */
> +	struct xfs_inobt_rec_incore	*recs;
> +
> +	/* Number of entries allocated for the @recs array. */
> +	unsigned int			sz_recs;
> +
> +	/* Number of entries in the @recs array that are in use. */
> +	unsigned int			nr_recs;
> +
> +	/* Inode walk function and data pointer. */
> +	xfs_iwalk_fn			iwalk_fn;
> +	void				*data;
> +};
> +
> +/* Allocate memory for a walk. */
> +STATIC int
> +xfs_iwalk_alloc(
> +	struct xfs_iwalk_ag	*iwag)
> +{
> +	size_t			size;
> +
> +	ASSERT(iwag->recs == NULL);
> +	iwag->nr_recs = 0;
> +
> +	/* Allocate a prefetch buffer for inobt records. */
> +	size = iwag->sz_recs * sizeof(struct xfs_inobt_rec_incore);
> +	iwag->recs = kmem_alloc(size, KM_MAYFAIL);
> +	if (iwag->recs == NULL)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +/* Free memory we allocated for a walk. */
> +STATIC void
> +xfs_iwalk_free(
> +	struct xfs_iwalk_ag	*iwag)
> +{
> +	kmem_free(iwag->recs);
> +	iwag->recs = NULL;
> +}
> +
> +/* For each inuse inode in each cached inobt record, call our function. */
> +STATIC int
> +xfs_iwalk_ag_recs(
> +	struct xfs_iwalk_ag		*iwag)
> +{
> +	struct xfs_mount		*mp = iwag->mp;
> +	struct xfs_trans		*tp = iwag->tp;
> +	xfs_ino_t			ino;
> +	unsigned int			i, j;
> +	xfs_agnumber_t			agno;
> +	int				error;
> +
> +	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
> +	for (i = 0; i < iwag->nr_recs; i++) {
> +		struct xfs_inobt_rec_incore	*irec = &iwag->recs[i];
> +
> +		trace_xfs_iwalk_ag_rec(mp, agno, irec);
> +
> +		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
> +			/* Skip if this inode is free */
> +			if (XFS_INOBT_MASK(j) & irec->ir_free)
> +				continue;
> +
> +			/* Otherwise call our function. */
> +			ino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino + j);
> +			error = iwag->iwalk_fn(mp, tp, ino, iwag->data);
> +			if (error)
> +				return error;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/* Delete cursor and let go of AGI. */
> +static inline void
> +xfs_iwalk_del_inobt(
> +	struct xfs_trans	*tp,
> +	struct xfs_btree_cur	**curpp,
> +	struct xfs_buf		**agi_bpp,
> +	int			error)
> +{
> +	if (*curpp) {
> +		xfs_btree_del_cursor(*curpp, error);
> +		*curpp = NULL;
> +	}
> +	if (*agi_bpp) {
> +		xfs_trans_brelse(tp, *agi_bpp);
> +		*agi_bpp = NULL;
> +	}
> +}
> +
> +/*
> + * Set ourselves up for walking inobt records starting from a given point in
> + * the filesystem.
> + *
> + * If caller passed in a nonzero start inode number, load the record from the
> + * inobt and make the record look like all the inodes before agino are free so
> + * that we skip them, and then move the cursor to the next inobt record.  This
> + * is how we support starting an iwalk in the middle of an inode chunk.
> + *
> + * If the caller passed in a start number of zero, move the cursor to the first
> + * inobt record.
> + *
> + * The caller is responsible for cleaning up the cursor and buffer pointer
> + * regardless of the error status.
> + */
> +STATIC int
> +xfs_iwalk_ag_start(
> +	struct xfs_iwalk_ag	*iwag,
> +	xfs_agnumber_t		agno,
> +	xfs_agino_t		agino,
> +	struct xfs_btree_cur	**curpp,
> +	struct xfs_buf		**agi_bpp,
> +	int			*has_more)
> +{
> +	struct xfs_mount	*mp = iwag->mp;
> +	struct xfs_trans	*tp = iwag->tp;
> +	int			icount;
> +	int			error;
> +
> +	/* Set up a fresh cursor and empty the inobt cache. */
> +	iwag->nr_recs = 0;
> +	error = xfs_inobt_cur(mp, tp, agno, XFS_BTNUM_INO, curpp, agi_bpp);
> +	if (error)
> +		return error;
> +
> +	/* Starting at the beginning of the AG?  That's easy! */
> +	if (agino == 0)
> +		return xfs_inobt_lookup(*curpp, 0, XFS_LOOKUP_GE, has_more);
> +
> +	/*
> +	 * Otherwise, we have to grab the inobt record where we left off, stuff
> +	 * the record into our cache, and then see if there are more records.
> +	 * We require a lookup cache of at least two elements so that we don't
> +	 * have to deal with tearing down the cursor to walk the records.
> +	 */
> +	error = xfs_bulkstat_grab_ichunk(*curpp, agino - 1, &icount,
> +			&iwag->recs[iwag->nr_recs]);
> +	if (error)
> +		return error;
> +	if (icount)
> +		iwag->nr_recs++;
> +
> +	/*
> +	 * The prefetch calculation is supposed to give us a large enough inobt
> +	 * record cache that grab_ichunk can stage a partial first record and
> +	 * the loop body can cache a record without having to check for cache
> +	 * space until after it reads an inobt record.
> +	 */
> +	ASSERT(iwag->nr_recs < iwag->sz_recs);
> +
> +	return xfs_btree_increment(*curpp, 0, has_more);
> +}
> +
> +/*
> + * The inobt record cache is full, so preserve the inobt cursor state and
> + * run callbacks on the cached inobt records.  When we're done, restore the
> + * cursor state to wherever the cursor would have been had the cache not been
> + * full (and therefore we could've just incremented the cursor) if *@has_more
> + * is true.  On exit, *@has_more will indicate whether or not the caller should
> + * try for more inode records.
> + */
> +STATIC int
> +xfs_iwalk_run_callbacks(
> +	struct xfs_iwalk_ag		*iwag,
> +	xfs_agnumber_t			agno,
> +	struct xfs_btree_cur		**curpp,
> +	struct xfs_buf			**agi_bpp,
> +	int				*has_more)
> +{
> +	struct xfs_mount		*mp = iwag->mp;
> +	struct xfs_trans		*tp = iwag->tp;
> +	struct xfs_inobt_rec_incore	*irec;
> +	xfs_agino_t			restart;
> +	int				error;
> +
> +	ASSERT(iwag->nr_recs > 0);
> +
> +	/* Delete cursor but remember the last record we cached... */
> +	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
> +	irec = &iwag->recs[iwag->nr_recs - 1];
> +	restart = irec->ir_startino + XFS_INODES_PER_CHUNK - 1;
> +
> +	error = xfs_iwalk_ag_recs(iwag);
> +	if (error)
> +		return error;
> +
> +	/* ...empty the cache... */
> +	iwag->nr_recs = 0;
> +
> +	if (!has_more)
> +		return 0;
> +
> +	/* ...and recreate the cursor just past where we left off. */
> +	error = xfs_inobt_cur(mp, tp, agno, XFS_BTNUM_INO, curpp, agi_bpp);
> +	if (error)
> +		return error;
> +
> +	return xfs_inobt_lookup(*curpp, restart, XFS_LOOKUP_GE, has_more);
> +}
> +
> +/* Walk all inodes in a single AG, from @iwag->startino to the end of the AG. */
> +STATIC int
> +xfs_iwalk_ag(
> +	struct xfs_iwalk_ag		*iwag)
> +{
> +	struct xfs_mount		*mp = iwag->mp;
> +	struct xfs_trans		*tp = iwag->tp;
> +	struct xfs_buf			*agi_bp = NULL;
> +	struct xfs_btree_cur		*cur = NULL;
> +	xfs_agnumber_t			agno;
> +	xfs_agino_t			agino;
> +	int				has_more;
> +	int				error = 0;
> +
> +	/* Set up our cursor at the right place in the inode btree. */
> +	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
> +	agino = XFS_INO_TO_AGINO(mp, iwag->startino);
> +	error = xfs_iwalk_ag_start(iwag, agno, agino, &cur, &agi_bp, &has_more);
> +
> +	while (!error && has_more) {
> +		struct xfs_inobt_rec_incore	*irec;
> +
> +		cond_resched();
> +
> +		/* Fetch the inobt record. */
> +		irec = &iwag->recs[iwag->nr_recs];
> +		error = xfs_inobt_get_rec(cur, irec, &has_more);
> +		if (error || !has_more)
> +			break;
> +
> +		/* No allocated inodes in this chunk; skip it. */
> +		if (irec->ir_freecount == irec->ir_count) {
> +			error = xfs_btree_increment(cur, 0, &has_more);
> +			if (error)
> +				break;
> +			continue;
> +		}
> +
> +		/*
> +		 * Start readahead for this inode chunk in anticipation of
> +		 * walking the inodes.
> +		 */
> +		xfs_bulkstat_ichunk_ra(mp, agno, irec);
> +
> +		/*
> +		 * If there's space in the buffer for more records, increment
> +		 * the btree cursor and grab more.
> +		 */
> +		if (++iwag->nr_recs < iwag->sz_recs) {
> +			error = xfs_btree_increment(cur, 0, &has_more);
> +			if (error || !has_more)
> +				break;
> +			continue;
> +		}
> +
> +		/*
> +		 * Otherwise, we need to save cursor state and run the callback
> +		 * function on the cached records.  The run_callbacks function
> +		 * is supposed to return a cursor pointing to the record where
> +		 * we would be if we had been able to increment like above.
> +		 */
> +		ASSERT(has_more);
> +		error = xfs_iwalk_run_callbacks(iwag, agno, &cur, &agi_bp,
> +				&has_more);
> +	}
> +
> +	if (iwag->nr_recs == 0 || error)
> +		goto out;
> +
> +	/* Walk the unprocessed records in the cache. */
> +	error = xfs_iwalk_run_callbacks(iwag, agno, &cur, &agi_bp, &has_more);
> +
> +out:
> +	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
> +	return error;
> +}
> +
> +/*
> + * Given the number of inodes to prefetch, set the number of inobt records that
> + * we cache in memory, which controls the number of inodes we try to read
> + * ahead.
> + */
> +static inline unsigned int
> +xfs_iwalk_prefetch(
> +	unsigned int		inode_records)
> +{
> +	return PAGE_SIZE * 4 / sizeof(struct xfs_inobt_rec_incore);
> +}
> +
> +/*
> + * Walk all inodes in the filesystem starting from @startino.  The @iwalk_fn
> + * will be called for each allocated inode, being passed the inode's number and
> + * @data.  @max_prefetch controls how many inobt records' worth of inodes we
> + * try to readahead.
> + */
> +int
> +xfs_iwalk(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_ino_t		startino,
> +	xfs_iwalk_fn		iwalk_fn,
> +	unsigned int		inode_records,
> +	void			*data)
> +{
> +	struct xfs_iwalk_ag	iwag = {
> +		.mp		= mp,
> +		.tp		= tp,
> +		.iwalk_fn	= iwalk_fn,
> +		.data		= data,
> +		.startino	= startino,
> +		.sz_recs	= xfs_iwalk_prefetch(inode_records),
> +	};
> +	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
> +	int			error;
> +
> +	ASSERT(agno < mp->m_sb.sb_agcount);
> +
> +	error = xfs_iwalk_alloc(&iwag);
> +	if (error)
> +		return error;
> +
> +	for (; agno < mp->m_sb.sb_agcount; agno++) {
> +		error = xfs_iwalk_ag(&iwag);
> +		if (error)
> +			break;
> +		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
> +	}
> +
> +	xfs_iwalk_free(&iwag);
> +	return error;
> +}
> diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
> new file mode 100644
> index 000000000000..7728dfd618a4
> --- /dev/null
> +++ b/fs/xfs/xfs_iwalk.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Copyright (C) 2019 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> + */
> +#ifndef __XFS_IWALK_H__
> +#define __XFS_IWALK_H__
> +
> +/* Walk all inodes in the filesystem starting from @startino. */
> +typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
> +			    xfs_ino_t ino, void *data);
> +/* Return values for xfs_iwalk_fn. */
> +#define XFS_IWALK_CONTINUE	(XFS_ITER_CONTINUE)
> +#define XFS_IWALK_ABORT		(XFS_ITER_ABORT)
> +
> +int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
> +		xfs_iwalk_fn iwalk_fn, unsigned int inode_records, void *data);
> +
> +#endif /* __XFS_IWALK_H__ */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 2464ea351f83..f9bb1d50bc0e 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -3516,6 +3516,46 @@ DEFINE_EVENT(xfs_inode_corrupt_class, name,	\
>  DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_sick);
>  DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
>  
> +TRACE_EVENT(xfs_iwalk_ag,
> +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> +		 xfs_agino_t startino),
> +	TP_ARGS(mp, agno, startino),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agino_t, startino)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->agno = agno;
> +		__entry->startino = startino;
> +	),
> +	TP_printk("dev %d:%d agno %d startino %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
> +		  __entry->startino)
> +)
> +
> +TRACE_EVENT(xfs_iwalk_ag_rec,
> +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
> +		 struct xfs_inobt_rec_incore *irec),
> +	TP_ARGS(mp, agno, irec),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agino_t, startino)
> +		__field(uint64_t, freemask)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->agno = agno;
> +		__entry->startino = irec->ir_startino;
> +		__entry->freemask = irec->ir_free;
> +	),
> +	TP_printk("dev %d:%d agno %d startino %u freemask 0x%llx",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
> +		  __entry->startino, __entry->freemask)
> +)
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> 
