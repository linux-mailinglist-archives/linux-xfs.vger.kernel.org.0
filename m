Return-Path: <linux-xfs+bounces-21445-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA16FA87748
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Apr 2025 07:37:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5EF316ED2A
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Apr 2025 05:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3259F19ABC2;
	Mon, 14 Apr 2025 05:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yUiN6q2r"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D3D1862
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609016; cv=none; b=bsGJpogh384mLnGY/aij+StEHQKjWDLN9ggJGqcGiChUaLKlE7qSxgwuMtftsG1UlHE/xllsbEZvL03oFpCdMOTNg6wxUMroTbpKMrk+bCkWGaMOn3ChE+3JLmKGnPX+FrLo8FPF2tbqBd+yLy3C0lsTmYECDPHLO7UnFH5M5OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609016; c=relaxed/simple;
	bh=+6iTfM1yDnRroutxDghQ0YD6+eplM8V7vb60dMQKmGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQU/elsscJ2CH4Pz/ZkmbkNH9aPWHe+1WHkMMpcVEUtuhmjYj9+ZoxFEvxDatFTqfEOX12Xb3XKWS/TEifoLyiosN+uixVBpvgfoLNf1yQuTrK7Hp6Sw7f0LkMy+Su/40fsU9jsNJKBSNBuUsjjSCyq/1RVwnBoDRVwq7S60j28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yUiN6q2r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NPZZgFqCD4s8FgM802A04fT1ADrFf4O+yevTyDzCehc=; b=yUiN6q2rTczb+szddZd2XYp0v1
	UMFjM7EIpSALpeoM+XVDNxlPKFFAUdrvAYdAmv3GEpFuaoywS2apHQOwTb38DjARegRyq5c/ZtF84
	DdQPbbFHOxylh4Jeai58/8HqU0xZCZWY0OVQyywE9cXobYv56I6M/hTAoJiEreTlJ2Qw3Dcpz41SF
	pahZVbhmJDHnFlh550tH+oqPNjhb5bKmL0sjDIg8QAHPR89JNabfKtwLZNhhPE4cgsn8qtntHXnFr
	ucal4mbeRFPkhwZ5imjD7x0W6qDWZprrZe66t2egT7j61+NeFjnsRiC2qUdo7AHzn/9qzSKWdl8Eq
	VRtz7k3Q==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CV2-00000000i9p-48HQ;
	Mon, 14 Apr 2025 05:36:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/43] xfs: move xfs_bmapi_reserve_delalloc to xfs_iomap.c
Date: Mon, 14 Apr 2025 07:35:50 +0200
Message-ID: <20250414053629.360672-8-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 7c879c8275c0505c551f0fc6c152299c8d11f756

Delalloc reservations are not supported in userspace, and thus it doesn't
make sense to share this helper with xfsprogs.c.  Move it to xfs_iomap.c
toward the two callers.

Note that there rest of the delalloc handling should probably eventually
also move out of xfs_bmap.c, but that will require a bit more surgery.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c | 294 ++--------------------------------------------
 libxfs/xfs_bmap.h |   5 +-
 2 files changed, 8 insertions(+), 291 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 07c553d92423..4dc66e77744f 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -165,18 +165,16 @@ xfs_bmbt_update(
  * Compute the worst-case number of indirect blocks that will be used
  * for ip's delayed extent of length "len".
  */
-STATIC xfs_filblks_t
+xfs_filblks_t
 xfs_bmap_worst_indlen(
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_filblks_t	len)		/* delayed extent length */
+	struct xfs_inode	*ip,		/* incore inode pointer */
+	xfs_filblks_t		len)		/* delayed extent length */
 {
-	int		level;		/* btree level number */
-	int		maxrecs;	/* maximum record count at this level */
-	xfs_mount_t	*mp;		/* mount structure */
-	xfs_filblks_t	rval;		/* return value */
+	struct xfs_mount	*mp = ip->i_mount;
+	int			maxrecs = mp->m_bmap_dmxr[0];
+	int			level;
+	xfs_filblks_t		rval;
 
-	mp = ip->i_mount;
-	maxrecs = mp->m_bmap_dmxr[0];
 	for (level = 0, rval = 0;
 	     level < XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK);
 	     level++) {
@@ -2565,146 +2563,6 @@ done:
 #undef	PREV
 }
 
-/*
- * Convert a hole to a delayed allocation.
- */
-STATIC void
-xfs_bmap_add_extent_hole_delay(
-	xfs_inode_t		*ip,	/* incore inode pointer */
-	int			whichfork,
-	struct xfs_iext_cursor	*icur,
-	xfs_bmbt_irec_t		*new)	/* new data to add to file extents */
-{
-	struct xfs_ifork	*ifp;	/* inode fork pointer */
-	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
-	xfs_filblks_t		newlen=0;	/* new indirect size */
-	xfs_filblks_t		oldlen=0;	/* old indirect size */
-	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
-	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
-	xfs_filblks_t		temp;	 /* temp for indirect calculations */
-
-	ifp = xfs_ifork_ptr(ip, whichfork);
-	ASSERT(isnullstartblock(new->br_startblock));
-
-	/*
-	 * Check and set flags if this segment has a left neighbor
-	 */
-	if (xfs_iext_peek_prev_extent(ifp, icur, &left)) {
-		state |= BMAP_LEFT_VALID;
-		if (isnullstartblock(left.br_startblock))
-			state |= BMAP_LEFT_DELAY;
-	}
-
-	/*
-	 * Check and set flags if the current (right) segment exists.
-	 * If it doesn't exist, we're converting the hole at end-of-file.
-	 */
-	if (xfs_iext_get_extent(ifp, icur, &right)) {
-		state |= BMAP_RIGHT_VALID;
-		if (isnullstartblock(right.br_startblock))
-			state |= BMAP_RIGHT_DELAY;
-	}
-
-	/*
-	 * Set contiguity flags on the left and right neighbors.
-	 * Don't let extents get too large, even if the pieces are contiguous.
-	 */
-	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
-	    left.br_startoff + left.br_blockcount == new->br_startoff &&
-	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
-		state |= BMAP_LEFT_CONTIG;
-
-	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
-	    new->br_startoff + new->br_blockcount == right.br_startoff &&
-	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
-	    (!(state & BMAP_LEFT_CONTIG) ||
-	     (left.br_blockcount + new->br_blockcount +
-	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
-		state |= BMAP_RIGHT_CONTIG;
-
-	/*
-	 * Switch out based on the contiguity flags.
-	 */
-	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
-	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
-		/*
-		 * New allocation is contiguous with delayed allocations
-		 * on the left and on the right.
-		 * Merge all three into a single extent record.
-		 */
-		temp = left.br_blockcount + new->br_blockcount +
-			right.br_blockcount;
-
-		oldlen = startblockval(left.br_startblock) +
-			startblockval(new->br_startblock) +
-			startblockval(right.br_startblock);
-		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-					 oldlen);
-		left.br_startblock = nullstartblock(newlen);
-		left.br_blockcount = temp;
-
-		xfs_iext_remove(ip, icur, state);
-		xfs_iext_prev(ifp, icur);
-		xfs_iext_update_extent(ip, state, icur, &left);
-		break;
-
-	case BMAP_LEFT_CONTIG:
-		/*
-		 * New allocation is contiguous with a delayed allocation
-		 * on the left.
-		 * Merge the new allocation with the left neighbor.
-		 */
-		temp = left.br_blockcount + new->br_blockcount;
-
-		oldlen = startblockval(left.br_startblock) +
-			startblockval(new->br_startblock);
-		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-					 oldlen);
-		left.br_blockcount = temp;
-		left.br_startblock = nullstartblock(newlen);
-
-		xfs_iext_prev(ifp, icur);
-		xfs_iext_update_extent(ip, state, icur, &left);
-		break;
-
-	case BMAP_RIGHT_CONTIG:
-		/*
-		 * New allocation is contiguous with a delayed allocation
-		 * on the right.
-		 * Merge the new allocation with the right neighbor.
-		 */
-		temp = new->br_blockcount + right.br_blockcount;
-		oldlen = startblockval(new->br_startblock) +
-			startblockval(right.br_startblock);
-		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-					 oldlen);
-		right.br_startoff = new->br_startoff;
-		right.br_startblock = nullstartblock(newlen);
-		right.br_blockcount = temp;
-		xfs_iext_update_extent(ip, state, icur, &right);
-		break;
-
-	case 0:
-		/*
-		 * New allocation is not contiguous with another
-		 * delayed allocation.
-		 * Insert a new entry.
-		 */
-		oldlen = newlen = 0;
-		xfs_iext_insert(ip, icur, new, state);
-		break;
-	}
-	if (oldlen != newlen) {
-		ASSERT(oldlen > newlen);
-		xfs_add_fdblocks(ip->i_mount, oldlen - newlen);
-
-		/*
-		 * Nothing to do for disk quota accounting here.
-		 */
-		xfs_mod_delalloc(ip, 0, (int64_t)newlen - oldlen);
-	}
-}
-
 /*
  * Convert a hole to a real allocation.
  */
@@ -4033,144 +3891,6 @@ xfs_bmapi_read(
 	return 0;
 }
 
-/*
- * Add a delayed allocation extent to an inode. Blocks are reserved from the
- * global pool and the extent inserted into the inode in-core extent tree.
- *
- * On entry, got refers to the first extent beyond the offset of the extent to
- * allocate or eof is specified if no such extent exists. On return, got refers
- * to the extent record that was inserted to the inode fork.
- *
- * Note that the allocated extent may have been merged with contiguous extents
- * during insertion into the inode fork. Thus, got does not reflect the current
- * state of the inode fork on return. If necessary, the caller can use lastx to
- * look up the updated record in the inode fork.
- */
-int
-xfs_bmapi_reserve_delalloc(
-	struct xfs_inode	*ip,
-	int			whichfork,
-	xfs_fileoff_t		off,
-	xfs_filblks_t		len,
-	xfs_filblks_t		prealloc,
-	struct xfs_bmbt_irec	*got,
-	struct xfs_iext_cursor	*icur,
-	int			eof)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
-	xfs_extlen_t		alen;
-	xfs_extlen_t		indlen;
-	uint64_t		fdblocks;
-	int			error;
-	xfs_fileoff_t		aoff;
-	bool			use_cowextszhint =
-					whichfork == XFS_COW_FORK && !prealloc;
-
-retry:
-	/*
-	 * Cap the alloc length. Keep track of prealloc so we know whether to
-	 * tag the inode before we return.
-	 */
-	aoff = off;
-	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
-	if (!eof)
-		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
-	if (prealloc && alen >= len)
-		prealloc = alen - len;
-
-	/*
-	 * If we're targetting the COW fork but aren't creating a speculative
-	 * posteof preallocation, try to expand the reservation to align with
-	 * the COW extent size hint if there's sufficient free space.
-	 *
-	 * Unlike the data fork, the CoW cancellation functions will free all
-	 * the reservations at inactivation, so we don't require that every
-	 * delalloc reservation have a dirty pagecache.
-	 */
-	if (use_cowextszhint) {
-		struct xfs_bmbt_irec	prev;
-		xfs_extlen_t		extsz = xfs_get_cowextsz_hint(ip);
-
-		if (!xfs_iext_peek_prev_extent(ifp, icur, &prev))
-			prev.br_startoff = NULLFILEOFF;
-
-		error = xfs_bmap_extsize_align(mp, got, &prev, extsz, 0, eof,
-					       1, 0, &aoff, &alen);
-		ASSERT(!error);
-	}
-
-	/*
-	 * Make a transaction-less quota reservation for delayed allocation
-	 * blocks.  This number gets adjusted later.  We return if we haven't
-	 * allocated blocks already inside this loop.
-	 */
-	error = xfs_quota_reserve_blkres(ip, alen);
-	if (error)
-		goto out;
-
-	/*
-	 * Split changing sb for alen and indlen since they could be coming
-	 * from different places.
-	 */
-	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
-	ASSERT(indlen > 0);
-
-	fdblocks = indlen;
-	if (XFS_IS_REALTIME_INODE(ip)) {
-		error = xfs_dec_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
-		if (error)
-			goto out_unreserve_quota;
-	} else {
-		fdblocks += alen;
-	}
-
-	error = xfs_dec_fdblocks(mp, fdblocks, false);
-	if (error)
-		goto out_unreserve_frextents;
-
-	ip->i_delayed_blks += alen;
-	xfs_mod_delalloc(ip, alen, indlen);
-
-	got->br_startoff = aoff;
-	got->br_startblock = nullstartblock(indlen);
-	got->br_blockcount = alen;
-	got->br_state = XFS_EXT_NORM;
-
-	xfs_bmap_add_extent_hole_delay(ip, whichfork, icur, got);
-
-	/*
-	 * Tag the inode if blocks were preallocated. Note that COW fork
-	 * preallocation can occur at the start or end of the extent, even when
-	 * prealloc == 0, so we must also check the aligned offset and length.
-	 */
-	if (whichfork == XFS_DATA_FORK && prealloc)
-		xfs_inode_set_eofblocks_tag(ip);
-	if (whichfork == XFS_COW_FORK && (prealloc || aoff < off || alen > len))
-		xfs_inode_set_cowblocks_tag(ip);
-
-	return 0;
-
-out_unreserve_frextents:
-	if (XFS_IS_REALTIME_INODE(ip))
-		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
-out_unreserve_quota:
-	if (XFS_IS_QUOTA_ON(mp))
-		xfs_quota_unreserve_blkres(ip, alen);
-out:
-	if (error == -ENOSPC || error == -EDQUOT) {
-		trace_xfs_delalloc_enospc(ip, off, len);
-
-		if (prealloc || use_cowextszhint) {
-			/* retry without any preallocation */
-			use_cowextszhint = false;
-			prealloc = 0;
-			goto retry;
-		}
-	}
-	return error;
-}
-
 static int
 xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 4b721d935994..4d48087fd3a8 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -219,10 +219,6 @@ int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		bool *done, xfs_fileoff_t stop_fsb);
 int	xfs_bmap_split_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t split_offset);
-int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
-		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
-		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
-		int eof);
 int	xfs_bmapi_convert_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_off_t offset, struct iomap *iomap, unsigned int *seq);
 int	xfs_bmap_add_extent_unwritten_real(struct xfs_trans *tp,
@@ -233,6 +229,7 @@ xfs_extlen_t xfs_bmapi_minleft(struct xfs_trans *tp, struct xfs_inode *ip,
 		int fork);
 int	xfs_bmap_btalloc_low_space(struct xfs_bmalloca *ap,
 		struct xfs_alloc_arg *args);
+xfs_filblks_t xfs_bmap_worst_indlen(struct xfs_inode *ip, xfs_filblks_t len);
 
 enum xfs_bmap_intent_type {
 	XFS_BMAP_MAP = 1,
-- 
2.47.2


