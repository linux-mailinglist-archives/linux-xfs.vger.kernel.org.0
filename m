Return-Path: <linux-xfs+bounces-19971-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC12AA3CBE3
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 22:58:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85C00189C8CA
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 21:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A13EC2580DC;
	Wed, 19 Feb 2025 21:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MwLj7aif"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BF3257438
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 21:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740002296; cv=none; b=rZZzVPWHgL8s6xEQCy2sH1H6iCu7bOI9U+4bMYAmF7ivp813BW0aA6o2x77YHHsM4IPpIZL/hNWeYZb5tIogUmIDIcH0oDmfaJ0IHSbh2fnt9GolyglypQBr6pSmc5AQ6ALE57j8u14A6GhTpP5vxu8KqjqEcOW3Wes/FWgGgeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740002296; c=relaxed/simple;
	bh=Im8WINeXXAa9gmbfnQyLaUzthpix0eh3drOx+6OE8eI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jbd66PB4y2cp3MkmxKEJKENttVR3qq27q+TFmivy9R6Il3yeSN2W9N+JlNddA9DpDbpWxIetsT+CxFAfjLnxFEluo8QAIteFRI3/AXKt1BdGdghpNmc0FQxSy70Oq0tk7b50ol456KufRwEz8EQ98gvkyE2mUFP11h6PRH8Gugk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MwLj7aif; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18B7C4CED1;
	Wed, 19 Feb 2025 21:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740002295;
	bh=Im8WINeXXAa9gmbfnQyLaUzthpix0eh3drOx+6OE8eI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MwLj7aifUJMnTDjYb73weEnCMlI7Sltg/advambBAvrEiay/EzJZDCB4ZsRjs06t4
	 Rrjl7vSZqcyZfcD0kBqRM9bcw8FRzthVs45jNMM8D6sUMRJMTdM8/MwLDX3pyGzUUQ
	 IgHwiChOLQiLygRw2BR4kLlXf417uAFWP8LTwj8G81hxX5JSFZ/yH3//sCCRkngfOV
	 c18leKyZ4teupz1RsOaA0K9x71pF4USvSEBxlgY9o9OXj8FPfZKDAs5wKc6ZrUBUIk
	 t+FPJsxqUwwEZlnEnxYjuKVjxYv/1+XXNQaNC8NYH7/5sR/Ln1HsViwWprR/9T48yJ
	 NrltaDotWw2Ng==
Date: Wed, 19 Feb 2025 13:58:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/45] xfs: add the zoned space allocator
Message-ID: <20250219215815.GX21808@frogsfrogsfrogs>
References: <20250218081153.3889537-1-hch@lst.de>
 <20250218081153.3889537-25-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218081153.3889537-25-hch@lst.de>

On Tue, Feb 18, 2025 at 09:10:27AM +0100, Christoph Hellwig wrote:
> For zoned RT devices space is always allocated at the write pointer, that
> is right after the last written block and only recorded on I/O completion.
> 
> Because the actual allocation algorithm is very simple and just involves
> picking a good zone - preferably the one used for the last write to the
> inode.  As the number of zones that can written at the same time is
> usually limited by the hardware, selecting a zone is done as late as
> possible from the iomap dio and buffered writeback bio submissions
> helpers just before submitting the bio.
> 
> Given that the writers already took a reservation before acquiring the
> iolock, space will always be readily available if an open zone slot is
> available.  A new structure is used to track these open zones, and
> pointed to by the xfs_rtgroup.  Because zoned file systems don't have
> a rsum cache the space for that pointer can be reused.
> 
> Allocations are only recorded at I/O completion time.  The scheme used
> for that is very similar to the reflink COW end I/O path.
> 
> Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/Makefile             |   3 +-
>  fs/xfs/libxfs/xfs_rtgroup.h |  22 +-
>  fs/xfs/libxfs/xfs_types.h   |   1 +
>  fs/xfs/xfs_log.c            |   4 +
>  fs/xfs/xfs_mount.c          |  11 +
>  fs/xfs/xfs_mount.h          |   2 +
>  fs/xfs/xfs_rtalloc.c        |   6 +-
>  fs/xfs/xfs_trace.c          |   2 +
>  fs/xfs/xfs_trace.h          | 101 ++++
>  fs/xfs/xfs_zone_alloc.c     | 955 ++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_zone_alloc.h     |  34 ++
>  fs/xfs/xfs_zone_priv.h      |  89 ++++
>  12 files changed, 1223 insertions(+), 7 deletions(-)
>  create mode 100644 fs/xfs/xfs_zone_alloc.c
>  create mode 100644 fs/xfs/xfs_zone_alloc.h
>  create mode 100644 fs/xfs/xfs_zone_priv.h
> 

<snip>

> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> new file mode 100644
> index 000000000000..0e03b4d35979
> --- /dev/null
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -0,0 +1,955 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2023-2025 Christoph Hellwig.
> + * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
> + */
> +#include "xfs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_error.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_iomap.h"
> +#include "xfs_trans.h"
> +#include "xfs_alloc.h"
> +#include "xfs_bmap.h"
> +#include "xfs_bmap_btree.h"
> +#include "xfs_trans_space.h"
> +#include "xfs_refcount.h"
> +#include "xfs_rtbitmap.h"
> +#include "xfs_rtrmap_btree.h"
> +#include "xfs_zone_alloc.h"
> +#include "xfs_zone_priv.h"
> +#include "xfs_zones.h"
> +#include "xfs_trace.h"
> +
> +void
> +xfs_open_zone_put(
> +	struct xfs_open_zone	*oz)
> +{
> +	if (atomic_dec_and_test(&oz->oz_ref)) {
> +		xfs_rtgroup_rele(oz->oz_rtg);
> +		kfree(oz);
> +	}
> +}
> +
> +static void
> +xfs_open_zone_mark_full(
> +	struct xfs_open_zone	*oz)
> +{
> +	struct xfs_rtgroup	*rtg = oz->oz_rtg;
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +
> +	trace_xfs_zone_full(rtg);
> +
> +	WRITE_ONCE(rtg->rtg_open_zone, NULL);
> +
> +	spin_lock(&zi->zi_open_zones_lock);
> +	if (oz->oz_is_gc) {
> +		ASSERT(current == zi->zi_gc_thread);
> +		zi->zi_open_gc_zone = NULL;
> +	} else {
> +		zi->zi_nr_open_zones--;
> +		list_del_init(&oz->oz_entry);
> +	}
> +	spin_unlock(&zi->zi_open_zones_lock);
> +	xfs_open_zone_put(oz);
> +
> +	wake_up_all(&zi->zi_zone_wait);
> +}
> +
> +static void
> +xfs_zone_record_blocks(
> +	struct xfs_trans	*tp,
> +	xfs_fsblock_t		fsbno,
> +	xfs_filblks_t		len,
> +	struct xfs_open_zone	*oz,
> +	bool			used)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_rtgroup	*rtg = oz->oz_rtg;
> +	struct xfs_inode	*rmapip = rtg_rmap(rtg);
> +
> +	trace_xfs_zone_record_blocks(oz, xfs_rtb_to_rgbno(mp, fsbno), len);
> +
> +	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> +	xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_RMAP);
> +	if (used) {
> +		rmapip->i_used_blocks += len;
> +		ASSERT(rmapip->i_used_blocks <= rtg_blocks(rtg));
> +	} else {
> +		xfs_add_frextents(mp, len);
> +	}
> +	oz->oz_written += len;
> +	if (oz->oz_written == rtg_blocks(rtg))
> +		xfs_open_zone_mark_full(oz);
> +	xfs_trans_log_inode(tp, rmapip, XFS_ILOG_CORE);
> +}
> +
> +static int
> +xfs_zoned_map_extent(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	struct xfs_bmbt_irec	*new,
> +	struct xfs_open_zone	*oz,
> +	xfs_fsblock_t		old_startblock)
> +{
> +	struct xfs_bmbt_irec	data;
> +	int			nmaps = 1;
> +	int			error;
> +
> +	/* Grab the corresponding mapping in the data fork. */
> +	error = xfs_bmapi_read(ip, new->br_startoff, new->br_blockcount, &data,
> +			       &nmaps, 0);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Cap the update to the existing extent in the data fork because we can
> +	 * only overwrite one extent at a time.
> +	 */
> +	ASSERT(new->br_blockcount >= data.br_blockcount);
> +	new->br_blockcount = data.br_blockcount;
> +
> +	/*
> +	 * If a data write raced with this GC write, keep the existing data in
> +	 * the data fork, mark our newly written GC extent as reclaimable, then
> +	 * move on to the next extent.
> +	 */
> +	if (old_startblock != NULLFSBLOCK &&
> +	    old_startblock != data.br_startblock)
> +		goto skip;
> +
> +	trace_xfs_reflink_cow_remap_from(ip, new);
> +	trace_xfs_reflink_cow_remap_to(ip, &data);
> +
> +	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
> +			XFS_IEXT_REFLINK_END_COW_CNT);
> +	if (error)
> +		return error;
> +
> +	if (data.br_startblock != HOLESTARTBLOCK) {
> +		ASSERT(data.br_startblock != DELAYSTARTBLOCK);
> +		ASSERT(!isnullstartblock(data.br_startblock));
> +
> +		xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &data);
> +		if (xfs_is_reflink_inode(ip)) {
> +			xfs_refcount_decrease_extent(tp, true, &data);
> +		} else {
> +			error = xfs_free_extent_later(tp, data.br_startblock,
> +					data.br_blockcount, NULL,
> +					XFS_AG_RESV_NONE,
> +					XFS_FREE_EXTENT_REALTIME);
> +			if (error)
> +				return error;
> +		}
> +	}
> +
> +	xfs_zone_record_blocks(tp, new->br_startblock, new->br_blockcount, oz,
> +			true);
> +
> +	/* Map the new blocks into the data fork. */
> +	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, new);
> +	return 0;
> +
> +skip:
> +	trace_xfs_reflink_cow_remap_skip(ip, new);
> +	xfs_zone_record_blocks(tp, new->br_startblock, new->br_blockcount, oz,
> +			false);
> +	return 0;
> +}
> +
> +int
> +xfs_zoned_end_io(
> +	struct xfs_inode	*ip,
> +	xfs_off_t		offset,
> +	xfs_off_t		count,
> +	xfs_daddr_t		daddr,
> +	struct xfs_open_zone	*oz,
> +	xfs_fsblock_t		old_startblock)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
> +	struct xfs_bmbt_irec	new = {
> +		.br_startoff	= XFS_B_TO_FSBT(mp, offset),
> +		.br_startblock	= xfs_daddr_to_rtb(mp, daddr),
> +		.br_state	= XFS_EXT_NORM,
> +	};
> +	unsigned int		resblks =
> +		XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> +	struct xfs_trans	*tp;
> +	int			error;
> +
> +	if (xfs_is_shutdown(mp))
> +		return -EIO;
> +
> +	while (new.br_startoff < end_fsb) {
> +		new.br_blockcount = end_fsb - new.br_startoff;
> +
> +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
> +				XFS_TRANS_RESERVE | XFS_TRANS_RES_FDBLKS, &tp);
> +		if (error)
> +			return error;
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, ip, 0);
> +
> +		error = xfs_zoned_map_extent(tp, ip, &new, oz, old_startblock);
> +		if (error)
> +			xfs_trans_cancel(tp);
> +		else
> +			error = xfs_trans_commit(tp);
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +		if (error)
> +			return error;
> +
> +		new.br_startoff += new.br_blockcount;
> +		new.br_startblock += new.br_blockcount;
> +		if (old_startblock != NULLFSBLOCK)
> +			old_startblock += new.br_blockcount;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * "Free" blocks allocated in a zone.
> + *
> + * Just decrement the used blocks counter and report the space as freed.
> + */
> +int
> +xfs_zone_free_blocks(
> +	struct xfs_trans	*tp,
> +	struct xfs_rtgroup	*rtg,
> +	xfs_fsblock_t		fsbno,
> +	xfs_filblks_t		len)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_inode	*rmapip = rtg_rmap(rtg);
> +
> +	xfs_assert_ilocked(rmapip, XFS_ILOCK_EXCL);
> +
> +	if (len > rmapip->i_used_blocks) {
> +		xfs_err(mp,
> +"trying to free more blocks (%lld) than used counter (%u).",
> +			len, rmapip->i_used_blocks);
> +		ASSERT(len <= rmapip->i_used_blocks);
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		return -EFSCORRUPTED;

Nit: This should probably be marking the rtrmap inode corrupt any time
we decide to return EFSCORRUPTED, even if all we do is shut down the
filesystem:

		xfs_rtginode_mark_sick(rtg, XFS_RTGI_RMAP);

The other place we need it is xfs_zoned_buffered_write_iomap_begin.

(Sorry, reading patches in reverse order...)

Everything else in this patch looks ready though.

--D

> +	}
> +
> +	trace_xfs_zone_free_blocks(rtg, xfs_rtb_to_rgbno(mp, fsbno), len);
> +
> +	rmapip->i_used_blocks -= len;
> +	xfs_add_frextents(mp, len);
> +	xfs_trans_log_inode(tp, rmapip, XFS_ILOG_CORE);
> +	return 0;
> +}
> +
> +/*
> + * Check if the zone containing the data just before the offset we are
> + * writing to is still open and has space.
> + */
> +static struct xfs_open_zone *
> +xfs_last_used_zone(
> +	struct iomap_ioend	*ioend)
> +{
> +	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSB(mp, ioend->io_offset);
> +	struct xfs_rtgroup	*rtg = NULL;
> +	struct xfs_open_zone	*oz = NULL;
> +	struct xfs_iext_cursor	icur;
> +	struct xfs_bmbt_irec	got;
> +
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	if (!xfs_iext_lookup_extent_before(ip, &ip->i_df, &offset_fsb,
> +				&icur, &got)) {
> +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +		return NULL;
> +	}
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +
> +	rtg = xfs_rtgroup_grab(mp, xfs_rtb_to_rgno(mp, got.br_startblock));
> +	if (!rtg)
> +		return NULL;
> +
> +	xfs_ilock(rtg_rmap(rtg), XFS_ILOCK_SHARED);
> +	oz = READ_ONCE(rtg->rtg_open_zone);
> +	if (oz && (oz->oz_is_gc || !atomic_inc_not_zero(&oz->oz_ref)))
> +		oz = NULL;
> +	xfs_iunlock(rtg_rmap(rtg), XFS_ILOCK_SHARED);
> +
> +	xfs_rtgroup_rele(rtg);
> +	return oz;
> +}
> +
> +static struct xfs_group *
> +xfs_find_free_zone(
> +	struct xfs_mount	*mp,
> +	unsigned long		start,
> +	unsigned long		end)
> +{
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	XA_STATE		(xas, &mp->m_groups[XG_TYPE_RTG].xa, start);
> +	struct xfs_group	*xg;
> +
> +	xas_lock(&xas);
> +	xas_for_each_marked(&xas, xg, end, XFS_RTG_FREE)
> +		if (atomic_inc_not_zero(&xg->xg_active_ref))
> +			goto found;
> +	xas_unlock(&xas);
> +	return NULL;
> +
> +found:
> +	xas_clear_mark(&xas, XFS_RTG_FREE);
> +	atomic_dec(&zi->zi_nr_free_zones);
> +	zi->zi_free_zone_cursor = xg->xg_gno;
> +	xas_unlock(&xas);
> +	return xg;
> +}
> +
> +static struct xfs_open_zone *
> +xfs_init_open_zone(
> +	struct xfs_rtgroup	*rtg,
> +	xfs_rgblock_t		write_pointer,
> +	bool			is_gc)
> +{
> +	struct xfs_open_zone	*oz;
> +
> +	oz = kzalloc(sizeof(*oz), GFP_NOFS | __GFP_NOFAIL);
> +	spin_lock_init(&oz->oz_alloc_lock);
> +	atomic_set(&oz->oz_ref, 1);
> +	oz->oz_rtg = rtg;
> +	oz->oz_write_pointer = write_pointer;
> +	oz->oz_written = write_pointer;
> +	oz->oz_is_gc = is_gc;
> +
> +	/*
> +	 * All dereferences of rtg->rtg_open_zone hold the ILOCK for the rmap
> +	 * inode, but we don't really want to take that here because we are
> +	 * under the zone_list_lock.  Ensure the pointer is only set for a fully
> +	 * initialized open zone structure so that a racy lookup finding it is
> +	 * fine.
> +	 */
> +	WRITE_ONCE(rtg->rtg_open_zone, oz);
> +	return oz;
> +}
> +
> +/*
> + * Find a completely free zone, open it, and return a reference.
> + */
> +struct xfs_open_zone *
> +xfs_open_zone(
> +	struct xfs_mount	*mp,
> +	bool			is_gc)
> +{
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	struct xfs_group	*xg;
> +
> +	xg = xfs_find_free_zone(mp, zi->zi_free_zone_cursor, ULONG_MAX);
> +	if (!xg)
> +		xg = xfs_find_free_zone(mp, 0, zi->zi_free_zone_cursor);
> +	if (!xg)
> +		return NULL;
> +
> +	set_current_state(TASK_RUNNING);
> +	return xfs_init_open_zone(to_rtg(xg), 0, is_gc);
> +}
> +
> +static struct xfs_open_zone *
> +xfs_try_open_zone(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	struct xfs_open_zone	*oz;
> +
> +	if (zi->zi_nr_open_zones >= mp->m_max_open_zones - XFS_OPEN_GC_ZONES)
> +		return NULL;
> +	if (atomic_read(&zi->zi_nr_free_zones) <
> +	    XFS_GC_ZONES - XFS_OPEN_GC_ZONES)
> +		return NULL;
> +
> +	/*
> +	 * Increment the open zone count to reserve our slot before dropping
> +	 * zi_open_zones_lock.
> +	 */
> +	zi->zi_nr_open_zones++;
> +	spin_unlock(&zi->zi_open_zones_lock);
> +	oz = xfs_open_zone(mp, false);
> +	spin_lock(&zi->zi_open_zones_lock);
> +	if (!oz) {
> +		zi->zi_nr_open_zones--;
> +		return NULL;
> +	}
> +
> +	atomic_inc(&oz->oz_ref);
> +	list_add_tail(&oz->oz_entry, &zi->zi_open_zones);
> +
> +	/*
> +	 * If this was the last free zone, other waiters might be waiting
> +	 * on us to write to it as well.
> +	 */
> +	wake_up_all(&zi->zi_zone_wait);
> +
> +	trace_xfs_zone_opened(oz->oz_rtg);
> +	return oz;
> +}
> +
> +static bool
> +xfs_try_use_zone(
> +	struct xfs_zone_info	*zi,
> +	struct xfs_open_zone	*oz)
> +{
> +	if (oz->oz_write_pointer == rtg_blocks(oz->oz_rtg))
> +		return false;
> +	if (!atomic_inc_not_zero(&oz->oz_ref))
> +		return false;
> +
> +	/*
> +	 * If we couldn't match by inode or life time we just pick the first
> +	 * zone with enough space above.  For that we want the least busy zone
> +	 * for some definition of "least" busy.  For now this simple LRU
> +	 * algorithm that rotates every zone to the end of the list will do it,
> +	 * even if it isn't exactly cache friendly.
> +	 */
> +	if (!list_is_last(&oz->oz_entry, &zi->zi_open_zones))
> +		list_move_tail(&oz->oz_entry, &zi->zi_open_zones);
> +	return true;
> +}
> +
> +static struct xfs_open_zone *
> +xfs_select_open_zone_lru(
> +	struct xfs_zone_info	*zi)
> +{
> +	struct xfs_open_zone	*oz;
> +
> +	lockdep_assert_held(&zi->zi_open_zones_lock);
> +
> +	list_for_each_entry(oz, &zi->zi_open_zones, oz_entry)
> +		if (xfs_try_use_zone(zi, oz))
> +			return oz;
> +
> +	cond_resched_lock(&zi->zi_open_zones_lock);
> +	return NULL;
> +}
> +
> +static struct xfs_open_zone *
> +xfs_select_open_zone_mru(
> +	struct xfs_zone_info	*zi)
> +{
> +	struct xfs_open_zone	*oz;
> +
> +	lockdep_assert_held(&zi->zi_open_zones_lock);
> +
> +	list_for_each_entry_reverse(oz, &zi->zi_open_zones, oz_entry)
> +		if (xfs_try_use_zone(zi, oz))
> +			return oz;
> +
> +	cond_resched_lock(&zi->zi_open_zones_lock);
> +	return NULL;
> +}
> +
> +/*
> + * Try to pack inodes that are written back after they were closed tight instead
> + * of trying to open new zones for them or spread them to the least recently
> + * used zone.  This optimizes the data layout for workloads that untar or copy
> + * a lot of small files.  Right now this does not separate multiple such
> + * streams.
> + */
> +static inline bool xfs_zoned_pack_tight(struct xfs_inode *ip)
> +{
> +	return !inode_is_open_for_write(VFS_I(ip)) &&
> +		!(ip->i_diflags & XFS_DIFLAG_APPEND);
> +}
> +
> +/*
> + * Pick a new zone for writes.
> + *
> + * If we aren't using up our budget of open zones just open a new one from the
> + * freelist.  Else try to find one that matches the expected data lifetime.  If
> + * we don't find one that is good pick any zone that is available.
> + */
> +static struct xfs_open_zone *
> +xfs_select_zone_nowait(
> +	struct xfs_mount	*mp,
> +	bool			pack_tight)
> +{
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	struct xfs_open_zone	*oz = NULL;
> +
> +	if (xfs_is_shutdown(mp))
> +		return NULL;
> +
> +	spin_lock(&zi->zi_open_zones_lock);
> +	if (pack_tight)
> +		oz = xfs_select_open_zone_mru(zi);
> +	if (oz)
> +		goto out_unlock;
> +
> +	/*
> +	 * See if we can open a new zone and use that.
> +	 */
> +	oz = xfs_try_open_zone(mp);
> +	if (oz)
> +		goto out_unlock;
> +
> +	oz = xfs_select_open_zone_lru(zi);
> +out_unlock:
> +	spin_unlock(&zi->zi_open_zones_lock);
> +	return oz;
> +}
> +
> +static struct xfs_open_zone *
> +xfs_select_zone(
> +	struct xfs_mount	*mp,
> +	bool			pack_tight)
> +{
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	DEFINE_WAIT		(wait);
> +	struct xfs_open_zone	*oz;
> +
> +	oz = xfs_select_zone_nowait(mp, pack_tight);
> +	if (oz)
> +		return oz;
> +
> +	for (;;) {
> +		prepare_to_wait(&zi->zi_zone_wait, &wait, TASK_UNINTERRUPTIBLE);
> +		oz = xfs_select_zone_nowait(mp, pack_tight);
> +		if (oz)
> +			break;
> +		schedule();
> +	}
> +	finish_wait(&zi->zi_zone_wait, &wait);
> +	return oz;
> +}
> +
> +static unsigned int
> +xfs_zone_alloc_blocks(
> +	struct xfs_open_zone	*oz,
> +	xfs_filblks_t		count_fsb,
> +	sector_t		*sector,
> +	bool			*is_seq)
> +{
> +	struct xfs_rtgroup	*rtg = oz->oz_rtg;
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	xfs_rgblock_t		rgbno;
> +
> +	spin_lock(&oz->oz_alloc_lock);
> +	count_fsb = min3(count_fsb, XFS_MAX_BMBT_EXTLEN,
> +		(xfs_filblks_t)rtg_blocks(rtg) - oz->oz_write_pointer);
> +	if (!count_fsb) {
> +		spin_unlock(&oz->oz_alloc_lock);
> +		return 0;
> +	}
> +	rgbno = oz->oz_write_pointer;
> +	oz->oz_write_pointer += count_fsb;
> +	spin_unlock(&oz->oz_alloc_lock);
> +
> +	trace_xfs_zone_alloc_blocks(oz, rgbno, count_fsb);
> +
> +	*sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
> +	*is_seq = bdev_zone_is_seq(mp->m_rtdev_targp->bt_bdev, *sector);
> +	if (!*is_seq)
> +		*sector += XFS_FSB_TO_BB(mp, rgbno);
> +	return XFS_FSB_TO_B(mp, count_fsb);
> +}
> +
> +void
> +xfs_mark_rtg_boundary(
> +	struct iomap_ioend	*ioend)
> +{
> +	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
> +	sector_t		sector = ioend->io_bio.bi_iter.bi_sector;
> +
> +	if (xfs_rtb_to_rgbno(mp, xfs_daddr_to_rtb(mp, sector)) == 0)
> +		ioend->io_flags |= IOMAP_IOEND_BOUNDARY;
> +}
> +
> +static void
> +xfs_submit_zoned_bio(
> +	struct iomap_ioend	*ioend,
> +	struct xfs_open_zone	*oz,
> +	bool			is_seq)
> +{
> +	ioend->io_bio.bi_iter.bi_sector = ioend->io_sector;
> +	ioend->io_private = oz;
> +	atomic_inc(&oz->oz_ref); /* for xfs_zoned_end_io */
> +
> +	if (is_seq) {
> +		ioend->io_bio.bi_opf &= ~REQ_OP_WRITE;
> +		ioend->io_bio.bi_opf |= REQ_OP_ZONE_APPEND;
> +	} else {
> +		xfs_mark_rtg_boundary(ioend);
> +	}
> +
> +	submit_bio(&ioend->io_bio);
> +}
> +
> +void
> +xfs_zone_alloc_and_submit(
> +	struct iomap_ioend	*ioend,
> +	struct xfs_open_zone	**oz)
> +{
> +	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	bool			pack_tight = xfs_zoned_pack_tight(ip);
> +	unsigned int		alloc_len;
> +	struct iomap_ioend	*split;
> +	bool			is_seq;
> +
> +	if (xfs_is_shutdown(mp))
> +		goto out_error;
> +
> +	/*
> +	 * If we don't have a cached zone in this write context, see if the
> +	 * last extent before the one we are writing to points to an active
> +	 * zone.  If so, just continue writing to it.
> +	 */
> +	if (!*oz && ioend->io_offset)
> +		*oz = xfs_last_used_zone(ioend);
> +	if (!*oz) {
> +select_zone:
> +		*oz = xfs_select_zone(mp, pack_tight);
> +		if (!*oz)
> +			goto out_error;
> +	}
> +
> +	alloc_len = xfs_zone_alloc_blocks(*oz, XFS_B_TO_FSB(mp, ioend->io_size),
> +			&ioend->io_sector, &is_seq);
> +	if (!alloc_len) {
> +		xfs_open_zone_put(*oz);
> +		goto select_zone;
> +	}
> +
> +	while ((split = iomap_split_ioend(ioend, alloc_len, is_seq))) {
> +		if (IS_ERR(split))
> +			goto out_split_error;
> +		alloc_len -= split->io_bio.bi_iter.bi_size;
> +		xfs_submit_zoned_bio(split, *oz, is_seq);
> +		if (!alloc_len) {
> +			xfs_open_zone_put(*oz);
> +			goto select_zone;
> +		}
> +	}
> +
> +	xfs_submit_zoned_bio(ioend, *oz, is_seq);
> +	return;
> +
> +out_split_error:
> +	ioend->io_bio.bi_status = errno_to_blk_status(PTR_ERR(split));
> +out_error:
> +	bio_io_error(&ioend->io_bio);
> +}
> +
> +void
> +xfs_zoned_wake_all(
> +	struct xfs_mount	*mp)
> +{
> +	if (!(mp->m_super->s_flags & SB_ACTIVE))
> +		return; /* can happen during log recovery */
> +	wake_up_all(&mp->m_zone_info->zi_zone_wait);
> +}
> +
> +/*
> + * Check if @rgbno in @rgb is a potentially valid block.  It might still be
> + * unused, but that information is only found in the rmap.
> + */
> +bool
> +xfs_zone_rgbno_is_valid(
> +	struct xfs_rtgroup	*rtg,
> +	xfs_rgnumber_t		rgbno)
> +{
> +	lockdep_assert_held(&rtg_rmap(rtg)->i_lock);
> +
> +	if (rtg->rtg_open_zone)
> +		return rgbno < rtg->rtg_open_zone->oz_write_pointer;
> +	return !xa_get_mark(&rtg_mount(rtg)->m_groups[XG_TYPE_RTG].xa,
> +			rtg_rgno(rtg), XFS_RTG_FREE);
> +}
> +
> +static void
> +xfs_free_open_zones(
> +	struct xfs_zone_info	*zi)
> +{
> +	struct xfs_open_zone	*oz;
> +
> +	spin_lock(&zi->zi_open_zones_lock);
> +	while ((oz = list_first_entry_or_null(&zi->zi_open_zones,
> +			struct xfs_open_zone, oz_entry))) {
> +		list_del(&oz->oz_entry);
> +		xfs_open_zone_put(oz);
> +	}
> +	spin_unlock(&zi->zi_open_zones_lock);
> +}
> +
> +struct xfs_init_zones {
> +	struct xfs_mount	*mp;
> +	uint64_t		available;
> +	uint64_t		reclaimable;
> +};
> +
> +static int
> +xfs_init_zone(
> +	struct xfs_init_zones	*iz,
> +	struct xfs_rtgroup	*rtg,
> +	struct blk_zone		*zone)
> +{
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	struct xfs_zone_info	*zi = mp->m_zone_info;
> +	uint64_t		used = rtg_rmap(rtg)->i_used_blocks;
> +	xfs_rgblock_t		write_pointer, highest_rgbno;
> +
> +	if (zone && !xfs_zone_validate(zone, rtg, &write_pointer))
> +		return -EFSCORRUPTED;
> +
> +	/*
> +	 * For sequential write required zones we retrieved the hardware write
> +	 * pointer above.
> +	 *
> +	 * For conventional zones or conventional devices we don't have that
> +	 * luxury.  Instead query the rmap to find the highest recorded block
> +	 * and set the write pointer to the block after that.  In case of a
> +	 * power loss this misses blocks where the data I/O has completed but
> +	 * not recorded in the rmap yet, and it also rewrites blocks if the most
> +	 * recently written ones got deleted again before unmount, but this is
> +	 * the best we can do without hardware support.
> +	 */
> +	if (!zone || zone->cond == BLK_ZONE_COND_NOT_WP) {
> +		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
> +		highest_rgbno = xfs_rtrmap_highest_rgbno(rtg);
> +		if (highest_rgbno == NULLRGBLOCK)
> +			write_pointer = 0;
> +		else
> +			write_pointer = highest_rgbno + 1;
> +		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
> +	}
> +
> +	if (write_pointer == 0) {
> +		/* zone is empty */
> +		atomic_inc(&zi->zi_nr_free_zones);
> +		xfs_group_set_mark(&rtg->rtg_group, XFS_RTG_FREE);
> +		iz->available += rtg_blocks(rtg);
> +	} else if (write_pointer < rtg_blocks(rtg)) {
> +		/* zone is open */
> +		struct xfs_open_zone *oz;
> +
> +		atomic_inc(&rtg_group(rtg)->xg_active_ref);
> +		oz = xfs_init_open_zone(rtg, write_pointer, false);
> +		list_add_tail(&oz->oz_entry, &zi->zi_open_zones);
> +		zi->zi_nr_open_zones++;
> +
> +		iz->available += (rtg_blocks(rtg) - write_pointer);
> +		iz->reclaimable += write_pointer - used;
> +	} else if (used < rtg_blocks(rtg)) {
> +		/* zone fully written, but has freed blocks */
> +		iz->reclaimable += (rtg_blocks(rtg) - used);
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +xfs_get_zone_info_cb(
> +	struct blk_zone		*zone,
> +	unsigned int		idx,
> +	void			*data)
> +{
> +	struct xfs_init_zones	*iz = data;
> +	struct xfs_mount	*mp = iz->mp;
> +	xfs_fsblock_t		zsbno = xfs_daddr_to_rtb(mp, zone->start);
> +	xfs_rgnumber_t		rgno;
> +	struct xfs_rtgroup	*rtg;
> +	int			error;
> +
> +	if (xfs_rtb_to_rgbno(mp, zsbno) != 0) {
> +		xfs_warn(mp, "mismatched zone start 0x%llx.", zsbno);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	rgno = xfs_rtb_to_rgno(mp, zsbno);
> +	rtg = xfs_rtgroup_grab(mp, rgno);
> +	if (!rtg) {
> +		xfs_warn(mp, "realtime group not found for zone %u.", rgno);
> +		return -EFSCORRUPTED;
> +	}
> +	error = xfs_init_zone(iz, rtg, zone);
> +	xfs_rtgroup_rele(rtg);
> +	return error;
> +}
> +
> +/*
> + * Calculate the max open zone limit based on the of number of
> + * backing zones available
> + */
> +static inline uint32_t
> +xfs_max_open_zones(
> +	struct xfs_mount	*mp)
> +{
> +	unsigned int		max_open, max_open_data_zones;
> +	/*
> +	 * We need two zones for every open data zone,
> +	 * one in reserve as we don't reclaim open zones. One data zone
> +	 * and its spare is included in XFS_MIN_ZONES.
> +	 */
> +	max_open_data_zones = (mp->m_sb.sb_rgcount - XFS_MIN_ZONES) / 2 + 1;
> +	max_open = max_open_data_zones + XFS_OPEN_GC_ZONES;
> +
> +	/*
> +	 * Cap the max open limit to 1/4 of available space
> +	 */
> +	max_open = min(max_open, mp->m_sb.sb_rgcount / 4);
> +
> +	return max(XFS_MIN_OPEN_ZONES, max_open);
> +}
> +
> +/*
> + * Normally we use the open zone limit that the device reports.  If there is
> + * none let the user pick one from the command line.
> + *
> + * If the device doesn't report an open zone limit and there is no override,
> + * allow to hold about a quarter of the zones open.  In theory we could allow
> + * all to be open, but at that point we run into GC deadlocks because we can't
> + * reclaim open zones.
> + *
> + * When used on conventional SSDs a lower open limit is advisable as we'll
> + * otherwise overwhelm the FTL just as much as a conventional block allocator.
> + *
> + * Note: To debug the open zone management code, force max_open to 1 here.
> + */
> +static int
> +xfs_calc_open_zones(
> +	struct xfs_mount	*mp)
> +{
> +	struct block_device	*bdev = mp->m_rtdev_targp->bt_bdev;
> +	unsigned int		bdev_open_zones = bdev_max_open_zones(bdev);
> +
> +	if (!mp->m_max_open_zones) {
> +		if (bdev_open_zones)
> +			mp->m_max_open_zones = bdev_open_zones;
> +		else
> +			mp->m_max_open_zones = xfs_max_open_zones(mp);
> +	}
> +
> +	if (mp->m_max_open_zones < XFS_MIN_OPEN_ZONES) {
> +		xfs_notice(mp, "need at least %u open zones.",
> +			XFS_MIN_OPEN_ZONES);
> +		return -EIO;
> +	}
> +
> +	if (bdev_open_zones && bdev_open_zones < mp->m_max_open_zones) {
> +		mp->m_max_open_zones = bdev_open_zones;
> +		xfs_info(mp, "limiting open zones to %u due to hardware limit.\n",
> +			bdev_open_zones);
> +	}
> +
> +	if (mp->m_max_open_zones > xfs_max_open_zones(mp)) {
> +		mp->m_max_open_zones = xfs_max_open_zones(mp);
> +		xfs_info(mp,
> +"limiting open zones to %u due to total zone count (%u)",
> +			mp->m_max_open_zones, mp->m_sb.sb_rgcount);
> +	}
> +
> +	return 0;
> +}
> +
> +static struct xfs_zone_info *
> +xfs_alloc_zone_info(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_zone_info	*zi;
> +
> +	zi = kzalloc(sizeof(*zi), GFP_KERNEL);
> +	if (!zi)
> +		return NULL;
> +	INIT_LIST_HEAD(&zi->zi_open_zones);
> +	INIT_LIST_HEAD(&zi->zi_reclaim_reservations);
> +	spin_lock_init(&zi->zi_reset_list_lock);
> +	spin_lock_init(&zi->zi_open_zones_lock);
> +	spin_lock_init(&zi->zi_reservation_lock);
> +	init_waitqueue_head(&zi->zi_zone_wait);
> +	return zi;
> +}
> +
> +static void
> +xfs_free_zone_info(
> +	struct xfs_zone_info	*zi)
> +{
> +	xfs_free_open_zones(zi);
> +	kfree(zi);
> +}
> +
> +int
> +xfs_mount_zones(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_init_zones	iz = {
> +		.mp		= mp,
> +	};
> +	struct xfs_buftarg	*bt = mp->m_rtdev_targp;
> +	int			error;
> +
> +	if (!bt) {
> +		xfs_notice(mp, "RT device missing.");
> +		return -EINVAL;
> +	}
> +
> +	if (!xfs_has_rtgroups(mp) || !xfs_has_rmapbt(mp)) {
> +		xfs_notice(mp, "invalid flag combination.");
> +		return -EFSCORRUPTED;
> +	}
> +	if (mp->m_sb.sb_rextsize != 1) {
> +		xfs_notice(mp, "zoned file systems do not support rextsize.");
> +		return -EFSCORRUPTED;
> +	}
> +	if (mp->m_sb.sb_rgcount < XFS_MIN_ZONES) {
> +		xfs_notice(mp,
> +"zoned file systems need to have at least %u zones.", XFS_MIN_ZONES);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	error = xfs_calc_open_zones(mp);
> +	if (error)
> +		return error;
> +
> +	mp->m_zone_info = xfs_alloc_zone_info(mp);
> +	if (!mp->m_zone_info)
> +		return -ENOMEM;
> +
> +	xfs_info(mp, "%u zones of %u blocks size (%u max open)",
> +		 mp->m_sb.sb_rgcount, mp->m_groups[XG_TYPE_RTG].blocks,
> +		 mp->m_max_open_zones);
> +
> +	if (bdev_is_zoned(bt->bt_bdev)) {
> +		error = blkdev_report_zones(bt->bt_bdev,
> +				XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart),
> +				mp->m_sb.sb_rgcount, xfs_get_zone_info_cb, &iz);
> +		if (error < 0)
> +			goto out_free_zone_info;
> +	} else {
> +		struct xfs_rtgroup	*rtg = NULL;
> +
> +		while ((rtg = xfs_rtgroup_next(mp, rtg))) {
> +			error = xfs_init_zone(&iz, rtg, NULL);
> +			if (error)
> +				goto out_free_zone_info;
> +		}
> +	}
> +
> +	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
> +			iz.available + iz.reclaimable);
> +	return 0;
> +
> +out_free_zone_info:
> +	xfs_free_zone_info(mp->m_zone_info);
> +	return error;
> +}
> +
> +void
> +xfs_unmount_zones(
> +	struct xfs_mount	*mp)
> +{
> +	xfs_free_zone_info(mp->m_zone_info);
> +}
> diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
> new file mode 100644
> index 000000000000..78cd7bfc6ac8
> --- /dev/null
> +++ b/fs/xfs/xfs_zone_alloc.h
> @@ -0,0 +1,34 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _XFS_ZONE_ALLOC_H
> +#define _XFS_ZONE_ALLOC_H
> +
> +struct iomap_ioend;
> +struct xfs_open_zone;
> +
> +void xfs_zone_alloc_and_submit(struct iomap_ioend *ioend,
> +		struct xfs_open_zone **oz);
> +int xfs_zone_free_blocks(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
> +		xfs_fsblock_t fsbno, xfs_filblks_t len);
> +int xfs_zoned_end_io(struct xfs_inode *ip, xfs_off_t offset, xfs_off_t count,
> +		xfs_daddr_t daddr, struct xfs_open_zone *oz,
> +		xfs_fsblock_t old_startblock);
> +void xfs_open_zone_put(struct xfs_open_zone *oz);
> +
> +void xfs_zoned_wake_all(struct xfs_mount *mp);
> +bool xfs_zone_rgbno_is_valid(struct xfs_rtgroup *rtg, xfs_rgnumber_t rgbno);
> +void xfs_mark_rtg_boundary(struct iomap_ioend *ioend);
> +
> +#ifdef CONFIG_XFS_RT
> +int xfs_mount_zones(struct xfs_mount *mp);
> +void xfs_unmount_zones(struct xfs_mount *mp);
> +#else
> +static inline int xfs_mount_zones(struct xfs_mount *mp)
> +{
> +	return -EIO;
> +}
> +static inline void xfs_unmount_zones(struct xfs_mount *mp)
> +{
> +}
> +#endif /* CONFIG_XFS_RT */
> +
> +#endif /* _XFS_ZONE_ALLOC_H */
> diff --git a/fs/xfs/xfs_zone_priv.h b/fs/xfs/xfs_zone_priv.h
> new file mode 100644
> index 000000000000..23d2fd6088ae
> --- /dev/null
> +++ b/fs/xfs/xfs_zone_priv.h
> @@ -0,0 +1,89 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _XFS_ZONE_PRIV_H
> +#define _XFS_ZONE_PRIV_H
> +
> +struct xfs_open_zone {
> +	/*
> +	 * Entry in the open zone list and refcount.  Protected by
> +	 * zi_open_zones_lock in struct xfs_zone_info.
> +	 */
> +	struct list_head	oz_entry;
> +	atomic_t		oz_ref;
> +
> +	/*
> +	 * oz_write_pointer is the write pointer at which space is handed out
> +	 * for conventional zones, or simple the count of blocks handed out
> +	 * so far for sequential write required zones and is protected by
> +	 * oz_alloc_lock/
> +	 */
> +	spinlock_t		oz_alloc_lock;
> +	xfs_rgblock_t		oz_write_pointer;
> +
> +	/*
> +	 * oz_written is the number of blocks for which we've received a
> +	 * write completion.  oz_written must always be <= oz_write_pointer
> +	 * and is protected by the ILOCK of the rmap inode.
> +	 */
> +	xfs_rgblock_t		oz_written;
> +
> +	/*
> +	 * Is this open zone used for garbage collection?  There can only be a
> +	 * single open GC zone, which is pointed to by zi_open_gc_zone in
> +	 * struct xfs_zone_info.  Constant over the life time of an open zone.
> +	 */
> +	bool			oz_is_gc;
> +
> +	/*
> +	 * Pointer to the RT groups structure for this open zone.  Constant over
> +	 * the life time of an open zone.
> +	 */
> +	struct xfs_rtgroup	*oz_rtg;
> +};
> +
> +struct xfs_zone_info {
> +	/*
> +	 * List of pending space reservations:
> +	 */
> +	spinlock_t		zi_reservation_lock;
> +	struct list_head	zi_reclaim_reservations;
> +
> +	/*
> +	 * List and number of open zones:
> +	 */
> +	spinlock_t		zi_open_zones_lock;
> +	struct list_head	zi_open_zones;
> +	unsigned int		zi_nr_open_zones;
> +
> +	/*
> +	 * Free zone search cursor and number of free zones:
> +	 */
> +	unsigned long		zi_free_zone_cursor;
> +	atomic_t		zi_nr_free_zones;
> +
> +	/*
> +	 * Wait queue to wait for free zones or open zone resources to become
> +	 * available:
> +	 */
> +	wait_queue_head_t	zi_zone_wait;
> +
> +	/*
> +	 * Pointer to the GC thread, and the current open zone used by GC
> +	 * (if any).
> +	 *
> +	 * zi_open_gc_zone is mostly private to the GC thread, but can be read
> +	 * for debugging from other threads, in which case zi_open_zones_lock
> +	 * must be taken to access it.
> +	 */
> +	struct task_struct      *zi_gc_thread;
> +	struct xfs_open_zone	*zi_open_gc_zone;
> +
> +	/*
> +	 * List of zones that need a reset:
> +	 */
> +	spinlock_t		zi_reset_list_lock;
> +	struct xfs_group	*zi_reset_list;
> +};
> +
> +struct xfs_open_zone *xfs_open_zone(struct xfs_mount *mp, bool is_gc);
> +
> +#endif /* _XFS_ZONE_PRIV_H */
> -- 
> 2.45.2
> 
> 

