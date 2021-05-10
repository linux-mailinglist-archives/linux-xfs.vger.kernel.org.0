Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61A3379A11
	for <lists+linux-xfs@lfdr.de>; Tue, 11 May 2021 00:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhEJWaD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 May 2021 18:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231193AbhEJWaB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 May 2021 18:30:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A36F615FF;
        Mon, 10 May 2021 22:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620685735;
        bh=P6VDHGoe7x5Ejej296gkE2FjxKsyKi1DXYLK2QdaN7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C0WZHhR/9LvD4GyTmHVsf0thzbTv6UsR7KBWSz5rM2vqggldpgU++7hEiFHyAqqfx
         kaWqcD6AQCG77OyLzJfExpkhFO7wH0OE8BxkhAzM1ykIJtHRPbrgQbdoJg9i+0rKMc
         pd+U1/aVJPwtOSv7cmjQCi4BHbYnQlB/c4sC8BVhHrdjIQ5br6BRvQEA0wlkd0bH53
         QRLZ8/mpIHv+pDdsiVV/BCUuQi3/SdH/9Zb7Ou+QjrmHw1V0Jxw7CEvjEsnjFFviZE
         mmOnhEsUDjVZ5LKLfYRhnDfkqJWoE6RpeISQMvKg2+3JQzW/Rwe4Of6D7vN+uZxzWy
         QxNodD3CsDKQg==
Date:   Mon, 10 May 2021 15:28:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/22] xfs: move xfs_perag_get/put to xfs_ag.[ch]
Message-ID: <20210510222854.GJ8582@magnolia>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:33PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> They are AG functions, not superblock functions, so move them to the
> appropriate location.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks decent to me, so long as this doesn't make a porting mess in
userspace...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.c             | 135 +++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h             |  10 +++
>  fs/xfs/libxfs/xfs_ag_resv.c        |   2 +-
>  fs/xfs/libxfs/xfs_alloc.c          |   2 +-
>  fs/xfs/libxfs/xfs_alloc_btree.c    |   2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.c      |   1 +
>  fs/xfs/libxfs/xfs_bmap.c           |   1 +
>  fs/xfs/libxfs/xfs_ialloc.c         |   2 +-
>  fs/xfs/libxfs/xfs_refcount_btree.c |   2 +-
>  fs/xfs/libxfs/xfs_rmap.c           |   1 +
>  fs/xfs/libxfs/xfs_rmap_btree.c     |   2 +-
>  fs/xfs/libxfs/xfs_sb.c             | 133 ----------------------------
>  fs/xfs/libxfs/xfs_sb.h             |   9 --
>  fs/xfs/scrub/agheader.c            |   1 +
>  fs/xfs/scrub/agheader_repair.c     |   1 +
>  fs/xfs/scrub/common.c              |   2 +-
>  fs/xfs/scrub/fscounters.c          |   2 +-
>  fs/xfs/scrub/health.c              |   2 +-
>  fs/xfs/scrub/repair.c              |   1 +
>  fs/xfs/xfs_buf.c                   |   2 +-
>  fs/xfs/xfs_discard.c               |   2 +-
>  fs/xfs/xfs_extent_busy.c           |   2 +-
>  fs/xfs/xfs_filestream.c            |   2 +-
>  fs/xfs/xfs_health.c                |   2 +-
>  fs/xfs/xfs_icache.c                |   2 +-
>  fs/xfs/xfs_inode.c                 |   2 +-
>  fs/xfs/xfs_log_recover.c           |   1 +
>  fs/xfs/xfs_mount.c                 |   1 +
>  fs/xfs/xfs_qm.c                    |   1 +
>  fs/xfs/xfs_reflink.c               |   2 +-
>  fs/xfs/xfs_super.c                 |   1 +
>  31 files changed, 172 insertions(+), 159 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index c68a36688474..2ca31dc46fe8 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -27,6 +27,141 @@
>  #include "xfs_defer.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
> +#include "xfs_trace.h"
> +
> +/*
> + * Passive reference counting access wrappers to the perag structures.  If the
> + * per-ag structure is to be freed, the freeing code is responsible for cleaning
> + * up objects with passive references before freeing the structure. This is
> + * things like cached buffers.
> + */
> +struct xfs_perag *
> +xfs_perag_get(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agno)
> +{
> +	struct xfs_perag	*pag;
> +	int			ref = 0;
> +
> +	rcu_read_lock();
> +	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
> +	if (pag) {
> +		ASSERT(atomic_read(&pag->pag_ref) >= 0);
> +		ref = atomic_inc_return(&pag->pag_ref);
> +	}
> +	rcu_read_unlock();
> +	trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
> +	return pag;
> +}
> +
> +/*
> + * search from @first to find the next perag with the given tag set.
> + */
> +struct xfs_perag *
> +xfs_perag_get_tag(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		first,
> +	int			tag)
> +{
> +	struct xfs_perag	*pag;
> +	int			found;
> +	int			ref;
> +
> +	rcu_read_lock();
> +	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
> +					(void **)&pag, first, 1, tag);
> +	if (found <= 0) {
> +		rcu_read_unlock();
> +		return NULL;
> +	}
> +	ref = atomic_inc_return(&pag->pag_ref);
> +	rcu_read_unlock();
> +	trace_xfs_perag_get_tag(mp, pag->pag_agno, ref, _RET_IP_);
> +	return pag;
> +}
> +
> +void
> +xfs_perag_put(
> +	struct xfs_perag	*pag)
> +{
> +	int	ref;
> +
> +	ASSERT(atomic_read(&pag->pag_ref) > 0);
> +	ref = atomic_dec_return(&pag->pag_ref);
> +	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
> +}
> +
> +/*
> + * xfs_initialize_perag_data
> + *
> + * Read in each per-ag structure so we can count up the number of
> + * allocated inodes, free inodes and used filesystem blocks as this
> + * information is no longer persistent in the superblock. Once we have
> + * this information, write it into the in-core superblock structure.
> + */
> +int
> +xfs_initialize_perag_data(
> +	struct xfs_mount *mp,
> +	xfs_agnumber_t	agcount)
> +{
> +	xfs_agnumber_t	index;
> +	xfs_perag_t	*pag;
> +	xfs_sb_t	*sbp = &mp->m_sb;
> +	uint64_t	ifree = 0;
> +	uint64_t	ialloc = 0;
> +	uint64_t	bfree = 0;
> +	uint64_t	bfreelst = 0;
> +	uint64_t	btree = 0;
> +	uint64_t	fdblocks;
> +	int		error = 0;
> +
> +	for (index = 0; index < agcount; index++) {
> +		/*
> +		 * read the agf, then the agi. This gets us
> +		 * all the information we need and populates the
> +		 * per-ag structures for us.
> +		 */
> +		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
> +		if (error)
> +			return error;
> +
> +		error = xfs_ialloc_pagi_init(mp, NULL, index);
> +		if (error)
> +			return error;
> +		pag = xfs_perag_get(mp, index);
> +		ifree += pag->pagi_freecount;
> +		ialloc += pag->pagi_count;
> +		bfree += pag->pagf_freeblks;
> +		bfreelst += pag->pagf_flcount;
> +		btree += pag->pagf_btreeblks;
> +		xfs_perag_put(pag);
> +	}
> +	fdblocks = bfree + bfreelst + btree;
> +
> +	/*
> +	 * If the new summary counts are obviously incorrect, fail the
> +	 * mount operation because that implies the AGFs are also corrupt.
> +	 * Clear FS_COUNTERS so that we don't unmount with a dirty log, which
> +	 * will prevent xfs_repair from fixing anything.
> +	 */
> +	if (fdblocks > sbp->sb_dblocks || ifree > ialloc) {
> +		xfs_alert(mp, "AGF corruption. Please run xfs_repair.");
> +		error = -EFSCORRUPTED;
> +		goto out;
> +	}
> +
> +	/* Overwrite incore superblock counters with just-read data */
> +	spin_lock(&mp->m_sb_lock);
> +	sbp->sb_ifree = ifree;
> +	sbp->sb_icount = ialloc;
> +	sbp->sb_fdblocks = fdblocks;
> +	spin_unlock(&mp->m_sb_lock);
> +
> +	xfs_reinit_percpu_counters(mp);
> +out:
> +	xfs_fs_mark_healthy(mp, XFS_SICK_FS_COUNTERS);
> +	return error;
> +}
>  
>  static int
>  xfs_get_aghdr_buf(
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 4535de1d88ea..cb1bd1c03cd7 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -9,6 +9,16 @@
>  
>  struct xfs_mount;
>  struct xfs_trans;
> +struct xfs_perag;
> +
> +/*
> + * perag get/put wrappers for ref counting
> + */
> +int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
> +struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
> +struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
> +				   int tag);
> +void	xfs_perag_put(struct xfs_perag *pag);
>  
>  struct aghdr_init_data {
>  	/* per ag data */
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index e32a1833d523..2e3dcdfd4984 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -19,7 +19,7 @@
>  #include "xfs_btree.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_ialloc_btree.h"
> -#include "xfs_sb.h"
> +#include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 82b7cbb1f24f..dc2b77829915 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -10,7 +10,6 @@
>  #include "xfs_shared.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
>  #include "xfs_btree.h"
> @@ -24,6 +23,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
> +#include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_bmap.h"
>  
> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index a43e4c50e69b..a540b6e799e0 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -9,7 +9,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
>  #include "xfs_btree_staging.h"
> @@ -19,6 +18,7 @@
>  #include "xfs_error.h"
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
> +#include "xfs_ag.h"
>  
>  
>  STATIC struct xfs_btree_cur *
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 556184b63061..aa371d005131 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -27,6 +27,7 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_dir2.h"
>  #include "xfs_log.h"
> +#include "xfs_ag.h"
>  
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 7e3b9b01431e..2086c55b67bd 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -31,6 +31,7 @@
>  #include "xfs_attr_leaf.h"
>  #include "xfs_filestream.h"
>  #include "xfs_rmap.h"
> +#include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_refcount.h"
>  #include "xfs_icache.h"
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index eefdb518fe64..8dc9225a5353 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -10,7 +10,6 @@
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_bit.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_btree.h"
> @@ -27,6 +26,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
>  #include "xfs_rmap.h"
> +#include "xfs_ag.h"
>  
>  /*
>   * Lookup a record by ino in the btree given by cur.
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index a6ac60ae9421..b281f0c674f5 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -9,7 +9,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
>  #include "xfs_btree_staging.h"
> @@ -20,6 +19,7 @@
>  #include "xfs_trans.h"
>  #include "xfs_bit.h"
>  #include "xfs_rmap.h"
> +#include "xfs_ag.h"
>  
>  static struct xfs_btree_cur *
>  xfs_refcountbt_dup_cursor(
> diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> index 10e0cf9949a2..61e8f10436ac 100644
> --- a/fs/xfs/libxfs/xfs_rmap.c
> +++ b/fs/xfs/libxfs/xfs_rmap.c
> @@ -21,6 +21,7 @@
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
>  #include "xfs_inode.h"
> +#include "xfs_ag.h"
>  
>  /*
>   * Lookup the first record less than or equal to [bno, len, owner, offset]
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 9f5bcbd834c3..f1fee42dda2d 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -9,7 +9,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_trans.h"
>  #include "xfs_alloc.h"
> @@ -20,6 +19,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_error.h"
>  #include "xfs_extent_busy.h"
> +#include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index dfbbcbd448c1..cbcfce8cebf1 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -30,67 +30,6 @@
>   * Physical superblock buffer manipulations. Shared with libxfs in userspace.
>   */
>  
> -/*
> - * Reference counting access wrappers to the perag structures.
> - * Because we never free per-ag structures, the only thing we
> - * have to protect against changes is the tree structure itself.
> - */
> -struct xfs_perag *
> -xfs_perag_get(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		agno)
> -{
> -	struct xfs_perag	*pag;
> -	int			ref = 0;
> -
> -	rcu_read_lock();
> -	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
> -	if (pag) {
> -		ASSERT(atomic_read(&pag->pag_ref) >= 0);
> -		ref = atomic_inc_return(&pag->pag_ref);
> -	}
> -	rcu_read_unlock();
> -	trace_xfs_perag_get(mp, agno, ref, _RET_IP_);
> -	return pag;
> -}
> -
> -/*
> - * search from @first to find the next perag with the given tag set.
> - */
> -struct xfs_perag *
> -xfs_perag_get_tag(
> -	struct xfs_mount	*mp,
> -	xfs_agnumber_t		first,
> -	int			tag)
> -{
> -	struct xfs_perag	*pag;
> -	int			found;
> -	int			ref;
> -
> -	rcu_read_lock();
> -	found = radix_tree_gang_lookup_tag(&mp->m_perag_tree,
> -					(void **)&pag, first, 1, tag);
> -	if (found <= 0) {
> -		rcu_read_unlock();
> -		return NULL;
> -	}
> -	ref = atomic_inc_return(&pag->pag_ref);
> -	rcu_read_unlock();
> -	trace_xfs_perag_get_tag(mp, pag->pag_agno, ref, _RET_IP_);
> -	return pag;
> -}
> -
> -void
> -xfs_perag_put(
> -	struct xfs_perag	*pag)
> -{
> -	int	ref;
> -
> -	ASSERT(atomic_read(&pag->pag_ref) > 0);
> -	ref = atomic_dec_return(&pag->pag_ref);
> -	trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
> -}
> -
>  /* Check all the superblock fields we care about when reading one in. */
>  STATIC int
>  xfs_validate_sb_read(
> @@ -841,78 +780,6 @@ xfs_sb_mount_common(
>  	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
>  }
>  
> -/*
> - * xfs_initialize_perag_data
> - *
> - * Read in each per-ag structure so we can count up the number of
> - * allocated inodes, free inodes and used filesystem blocks as this
> - * information is no longer persistent in the superblock. Once we have
> - * this information, write it into the in-core superblock structure.
> - */
> -int
> -xfs_initialize_perag_data(
> -	struct xfs_mount *mp,
> -	xfs_agnumber_t	agcount)
> -{
> -	xfs_agnumber_t	index;
> -	xfs_perag_t	*pag;
> -	xfs_sb_t	*sbp = &mp->m_sb;
> -	uint64_t	ifree = 0;
> -	uint64_t	ialloc = 0;
> -	uint64_t	bfree = 0;
> -	uint64_t	bfreelst = 0;
> -	uint64_t	btree = 0;
> -	uint64_t	fdblocks;
> -	int		error = 0;
> -
> -	for (index = 0; index < agcount; index++) {
> -		/*
> -		 * read the agf, then the agi. This gets us
> -		 * all the information we need and populates the
> -		 * per-ag structures for us.
> -		 */
> -		error = xfs_alloc_pagf_init(mp, NULL, index, 0);
> -		if (error)
> -			return error;
> -
> -		error = xfs_ialloc_pagi_init(mp, NULL, index);
> -		if (error)
> -			return error;
> -		pag = xfs_perag_get(mp, index);
> -		ifree += pag->pagi_freecount;
> -		ialloc += pag->pagi_count;
> -		bfree += pag->pagf_freeblks;
> -		bfreelst += pag->pagf_flcount;
> -		btree += pag->pagf_btreeblks;
> -		xfs_perag_put(pag);
> -	}
> -	fdblocks = bfree + bfreelst + btree;
> -
> -	/*
> -	 * If the new summary counts are obviously incorrect, fail the
> -	 * mount operation because that implies the AGFs are also corrupt.
> -	 * Clear FS_COUNTERS so that we don't unmount with a dirty log, which
> -	 * will prevent xfs_repair from fixing anything.
> -	 */
> -	if (fdblocks > sbp->sb_dblocks || ifree > ialloc) {
> -		xfs_alert(mp, "AGF corruption. Please run xfs_repair.");
> -		error = -EFSCORRUPTED;
> -		goto out;
> -	}
> -
> -	/* Overwrite incore superblock counters with just-read data */
> -	spin_lock(&mp->m_sb_lock);
> -	sbp->sb_ifree = ifree;
> -	sbp->sb_icount = ialloc;
> -	sbp->sb_fdblocks = fdblocks;
> -	spin_unlock(&mp->m_sb_lock);
> -
> -	xfs_reinit_percpu_counters(mp);
> -out:
> -	xfs_fs_mark_healthy(mp, XFS_SICK_FS_COUNTERS);
> -	return error;
> -}
> -
>  /*
>   * xfs_log_sb() can be used to copy arbitrary changes to the in-core superblock
>   * into the superblock buffer to be logged.  It does not provide the higher
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index f79f9dc632b6..0c1602d9b53d 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -13,15 +13,6 @@ struct xfs_trans;
>  struct xfs_fsop_geom;
>  struct xfs_perag;
>  
> -/*
> - * perag get/put wrappers for ref counting
> - */
> -extern struct xfs_perag *xfs_perag_get(struct xfs_mount *, xfs_agnumber_t);
> -extern struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
> -					   int tag);
> -extern void	xfs_perag_put(struct xfs_perag *pag);
> -extern int	xfs_initialize_perag_data(struct xfs_mount *, xfs_agnumber_t);
> -
>  extern void	xfs_log_sb(struct xfs_trans *tp);
>  extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
>  extern int	xfs_sync_sb_buf(struct xfs_mount *mp);
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 7a2f9b5f2db5..64a7a30f4ac0 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -14,6 +14,7 @@
>  #include "xfs_alloc.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_rmap.h"
> +#include "xfs_ag.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index 23690f824ffa..1cdfbd57f36b 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -20,6 +20,7 @@
>  #include "xfs_rmap.h"
>  #include "xfs_rmap_btree.h"
>  #include "xfs_refcount_btree.h"
> +#include "xfs_ag.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index aa874607618a..c8da976b50fc 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -12,7 +12,6 @@
>  #include "xfs_btree.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans.h"
> -#include "xfs_sb.h"
>  #include "xfs_inode.h"
>  #include "xfs_icache.h"
>  #include "xfs_alloc.h"
> @@ -26,6 +25,7 @@
>  #include "xfs_trans_priv.h"
>  #include "xfs_attr.h"
>  #include "xfs_reflink.h"
> +#include "xfs_ag.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index f1d1a8c58853..453ae9adf94c 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -9,11 +9,11 @@
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
>  #include "xfs_mount.h"
> -#include "xfs_sb.h"
>  #include "xfs_alloc.h"
>  #include "xfs_ialloc.h"
>  #include "xfs_health.h"
>  #include "xfs_btree.h"
> +#include "xfs_ag.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  #include "scrub/trace.h"
> diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
> index 3de59b5c2ce6..2e61df3bca83 100644
> --- a/fs/xfs/scrub/health.c
> +++ b/fs/xfs/scrub/health.c
> @@ -8,7 +8,7 @@
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_btree.h"
> -#include "xfs_sb.h"
> +#include "xfs_ag.h"
>  #include "xfs_health.h"
>  #include "scrub/scrub.h"
>  #include "scrub/health.h"
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index c2857d854c83..1308b62a8170 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -22,6 +22,7 @@
>  #include "xfs_rmap_btree.h"
>  #include "xfs_refcount_btree.h"
>  #include "xfs_extent_busy.h"
> +#include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_quota.h"
>  #include "scrub/scrub.h"
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 37a1d12762d8..38245c49b1b6 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -10,7 +10,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> @@ -19,6 +18,7 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_errortag.h"
>  #include "xfs_error.h"
> +#include "xfs_ag.h"
>  
>  static kmem_zone_t *xfs_buf_zone;
>  
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index f979d0d7e6cd..3bf6dba1a040 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -8,7 +8,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
>  #include "xfs_alloc_btree.h"
> @@ -18,6 +17,7 @@
>  #include "xfs_extent_busy.h"
>  #include "xfs_trace.h"
>  #include "xfs_log.h"
> +#include "xfs_ag.h"
>  
>  STATIC int
>  xfs_trim_extents(
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index ef17c1f6db32..184732aa8674 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -11,13 +11,13 @@
>  #include "xfs_log_format.h"
>  #include "xfs_shared.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_alloc.h"
>  #include "xfs_extent_busy.h"
>  #include "xfs_trace.h"
>  #include "xfs_trans.h"
>  #include "xfs_log.h"
> +#include "xfs_ag.h"
>  
>  void
>  xfs_extent_busy_insert(
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index db23e455eb91..eed6ca5f8f91 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -9,13 +9,13 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_bmap.h"
>  #include "xfs_alloc.h"
>  #include "xfs_mru_cache.h"
>  #include "xfs_trace.h"
> +#include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_trans.h"
>  #include "xfs_filestream.h"
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index 8e0cb05a7142..b79475ea3dbd 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -9,11 +9,11 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_trace.h"
>  #include "xfs_health.h"
> +#include "xfs_ag.h"
>  
>  /*
>   * Warn about metadata corruption that we detected but haven't fixed, and
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 3c81daca0e9a..588ea2bf88bb 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -9,7 +9,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> @@ -23,6 +22,7 @@
>  #include "xfs_dquot.h"
>  #include "xfs_reflink.h"
>  #include "xfs_ialloc.h"
> +#include "xfs_ag.h"
>  
>  #include <linux/iversion.h>
>  
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 17c2d8b18283..25910b145d70 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -11,7 +11,6 @@
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> -#include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_defer.h"
>  #include "xfs_inode.h"
> @@ -35,6 +34,7 @@
>  #include "xfs_log.h"
>  #include "xfs_bmap_btree.h"
>  #include "xfs_reflink.h"
> +#include "xfs_ag.h"
>  
>  kmem_zone_t *xfs_inode_zone;
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index e5dd1c0c2f03..fee2a4e80241 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -25,6 +25,7 @@
>  #include "xfs_icache.h"
>  #include "xfs_error.h"
>  #include "xfs_buf_item.h"
> +#include "xfs_ag.h"
>  
>  #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index bdfee1943796..21c630dde476 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -32,6 +32,7 @@
>  #include "xfs_extent_busy.h"
>  #include "xfs_health.h"
>  #include "xfs_trace.h"
> +#include "xfs_ag.h"
>  
>  static DEFINE_MUTEX(xfs_uuid_table_mutex);
>  static int xfs_uuid_table_size;
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 4bf949a89d0d..f7baf4dc2554 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -23,6 +23,7 @@
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
>  #include "xfs_error.h"
> +#include "xfs_ag.h"
>  
>  /*
>   * The global quota manager. There is only one of these for the entire
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 060695d6d56a..f297d68a931b 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -27,7 +27,7 @@
>  #include "xfs_quota.h"
>  #include "xfs_reflink.h"
>  #include "xfs_iomap.h"
> -#include "xfs_sb.h"
> +#include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  
>  /*
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index a2dab05332ac..688309dbe18b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -36,6 +36,7 @@
>  #include "xfs_bmap_item.h"
>  #include "xfs_reflink.h"
>  #include "xfs_pwork.h"
> +#include "xfs_ag.h"
>  
>  #include <linux/magic.h>
>  #include <linux/fs_context.h>
> -- 
> 2.31.1
> 
