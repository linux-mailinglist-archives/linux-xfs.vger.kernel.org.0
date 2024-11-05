Return-Path: <linux-xfs+bounces-15082-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 851A89BD883
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2024 23:25:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A82CB1C220AB
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2024 22:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 257A121730D;
	Tue,  5 Nov 2024 22:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hCP5/Sn+"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88AE216A30
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845451; cv=none; b=CL8QadvIpcGLyK1O+8Ae08ELmVDkchDnl+T8rabx3PcNtXOCs81vTtrXuCR7xSY7Sl8DXveFKYKPfBu8B0zDn94L1gLvgmIwrstGMJfz9b06TbABxoGpqsZq4RGUkWjGz0Lpdv3zSdv+0k24fPvYf6h/cY0qXsJUqPz+C/TyFnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845451; c=relaxed/simple;
	bh=PKZC3v2WTr0R/n4728nzPeccUKqU4HU5spGtdEPAaCs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OM7SWtkrDCAYYvY1BgEPd+f60/sbdRZjEYD05S0oKqR2CPFNfo/z8lDzkoTApoOnHOgV4KYlXGIWa/snRVookaiBFmg+3obh75Vkfi3ianFfBzJi6OFpLAPh1O6NMFITMjp+cTqjQExeAr5+t7nTlKmTUU4Gsy2gW5fR4Gzjk34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hCP5/Sn+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A3EC4CED4;
	Tue,  5 Nov 2024 22:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845451;
	bh=PKZC3v2WTr0R/n4728nzPeccUKqU4HU5spGtdEPAaCs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hCP5/Sn+lgDEWlBX5xVYRWMKEcbfZgjLJ+8Ea2Dddx8qbdbjBG6KsgUEXdgykW+VJ
	 tGxkEQCKB0wMIj6sh0qWJaBfP4agi2bQbOA+eQXCAB6I/D90CmHe+uQSx9b9FOLtZ+
	 NnTOrXJtiX77SWcsGNGh5mJ4z8BwA7Rv4H7cTgfbW4ZDvvvLgpiPHbaN2RX+d4gv6v
	 tIUni1IzIFJVI9oDhfh01cBVU/GNnRh/eLbbHd7zIa1gQ1duUBjd0ajmufp1+zF2la
	 psCYwjrvTXRyZHBTWp9iTFlVFL6f/us87VMZjiQk+7IxUazYT7/8YRjDDuIJmNMItl
	 mvbqdosLewiuQ==
Date: Tue, 05 Nov 2024 14:24:10 -0800
Subject: [PATCH 01/21] xfs: clean up xfs_getfsmap_helper arguments
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396955.1871025.18156568347365549855.stgit@frogsfrogsfrogs>
In-Reply-To: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

The calling conventions for xfs_getfsmap_helper are confusing -- callers
pass in an rmap record, but they must also supply startblock and
blockcount in daddr units.  This was bolted onto the original fsmap
implementation so that we could report *something* for realtime
volumes, which do not support rmap and hence can draw only from the rt
free space bitmap.  Free space on the rt volume can be more than 2^32
fsblocks long, which means that we can't use the rmap startblock or
blockcount fields.

This is confusing for callers, because they must supplying redundant
data, but not all of it is used.  Streamline this by creating a separate
fsmap irec structure that contains exactly the data we need, once.

Note that we actually do need rm_startblock for rmap key comparisons
when we're actually querying an rmap btree, so leave that field but
document why it's there.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |  225 +++++++++++++++++++++++++++-------------------------
 fs/xfs/xfs_fsmap.h |   15 +++
 fs/xfs/xfs_trace.h |   73 ++++++++++++-----
 3 files changed, 187 insertions(+), 126 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index a91677ac54e7e3..6cf4f00636a2d6 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -110,18 +110,18 @@ xfs_fsmap_owner_to_rmap(
 
 /* Convert an rmapbt owner into an fsmap owner. */
 static int
-xfs_fsmap_owner_from_rmap(
+xfs_fsmap_owner_from_frec(
 	struct xfs_fsmap		*dest,
-	const struct xfs_rmap_irec	*src)
+	const struct xfs_fsmap_irec	*frec)
 {
 	dest->fmr_flags = 0;
-	if (!XFS_RMAP_NON_INODE_OWNER(src->rm_owner)) {
-		dest->fmr_owner = src->rm_owner;
+	if (!XFS_RMAP_NON_INODE_OWNER(frec->owner)) {
+		dest->fmr_owner = frec->owner;
 		return 0;
 	}
 	dest->fmr_flags |= FMR_OF_SPECIAL_OWNER;
 
-	switch (src->rm_owner) {
+	switch (frec->owner) {
 	case XFS_RMAP_OWN_FS:
 		dest->fmr_owner = XFS_FMR_OWN_FS;
 		break;
@@ -203,7 +203,7 @@ STATIC int
 xfs_getfsmap_is_shared(
 	struct xfs_trans		*tp,
 	struct xfs_getfsmap_info	*info,
-	const struct xfs_rmap_irec	*rec,
+	const struct xfs_fsmap_irec	*frec,
 	bool				*stat)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
@@ -224,8 +224,9 @@ xfs_getfsmap_is_shared(
 	cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
 			to_perag(info->group));
 
-	error = xfs_refcount_find_shared(cur, rec->rm_startblock,
-			rec->rm_blockcount, &fbno, &flen, false);
+	error = xfs_refcount_find_shared(cur, frec->rec_key,
+			XFS_BB_TO_FSBT(mp, frec->len_daddr), &fbno, &flen,
+			false);
 
 	xfs_btree_del_cursor(cur, error);
 	if (error)
@@ -250,15 +251,22 @@ xfs_getfsmap_format(
 }
 
 static inline bool
-xfs_getfsmap_rec_before_start(
+xfs_getfsmap_frec_before_start(
 	struct xfs_getfsmap_info	*info,
-	const struct xfs_rmap_irec	*rec,
-	xfs_daddr_t			rec_daddr)
+	const struct xfs_fsmap_irec	*frec)
 {
 	if (info->low_daddr != XFS_BUF_DADDR_NULL)
-		return rec_daddr < info->low_daddr;
-	if (info->low.rm_blockcount)
-		return xfs_rmap_compare(rec, &info->low) < 0;
+		return frec->start_daddr < info->low_daddr;
+	if (info->low.rm_blockcount) {
+		struct xfs_rmap_irec	rec = {
+			.rm_startblock	= frec->rec_key,
+			.rm_owner	= frec->owner,
+			.rm_flags	= frec->rm_flags,
+		};
+
+		return xfs_rmap_compare(&rec, &info->low) < 0;
+	}
+
 	return false;
 }
 
@@ -271,61 +279,36 @@ STATIC int
 xfs_getfsmap_helper(
 	struct xfs_trans		*tp,
 	struct xfs_getfsmap_info	*info,
-	const struct xfs_rmap_irec	*rec,
-	xfs_daddr_t			rec_daddr,
-	xfs_daddr_t			len_daddr)
+	const struct xfs_fsmap_irec	*frec)
 {
 	struct xfs_fsmap		fmr;
 	struct xfs_mount		*mp = tp->t_mountp;
 	bool				shared;
-	int				error;
+	int				error = 0;
 
 	if (fatal_signal_pending(current))
 		return -EINTR;
 
-	if (len_daddr == 0)
-		len_daddr = XFS_FSB_TO_BB(mp, rec->rm_blockcount);
-
 	/*
 	 * Filter out records that start before our startpoint, if the
 	 * caller requested that.
 	 */
-	if (xfs_getfsmap_rec_before_start(info, rec, rec_daddr)) {
-		rec_daddr += len_daddr;
-		if (info->next_daddr < rec_daddr)
-			info->next_daddr = rec_daddr;
-		return 0;
-	}
-
-	/*
-	 * For an info->last query, we're looking for a gap between the last
-	 * mapping emitted and the high key specified by userspace.  If the
-	 * user's query spans less than 1 fsblock, then info->high and
-	 * info->low will have the same rm_startblock, which causes rec_daddr
-	 * and next_daddr to be the same.  Therefore, use the end_daddr that
-	 * we calculated from userspace's high key to synthesize the record.
-	 * Note that if the btree query found a mapping, there won't be a gap.
-	 */
-	if (info->last && info->end_daddr != XFS_BUF_DADDR_NULL)
-		rec_daddr = info->end_daddr;
+	if (xfs_getfsmap_frec_before_start(info, frec))
+		goto out;
 
 	/* Are we just counting mappings? */
 	if (info->head->fmh_count == 0) {
 		if (info->head->fmh_entries == UINT_MAX)
 			return -ECANCELED;
 
-		if (rec_daddr > info->next_daddr)
+		if (frec->start_daddr > info->next_daddr)
 			info->head->fmh_entries++;
 
 		if (info->last)
 			return 0;
 
 		info->head->fmh_entries++;
-
-		rec_daddr += len_daddr;
-		if (info->next_daddr < rec_daddr)
-			info->next_daddr = rec_daddr;
-		return 0;
+		goto out;
 	}
 
 	/*
@@ -333,7 +316,7 @@ xfs_getfsmap_helper(
 	 * then we've found a gap.  Report the gap as being owned by
 	 * whatever the caller specified is the missing owner.
 	 */
-	if (rec_daddr > info->next_daddr) {
+	if (frec->start_daddr > info->next_daddr) {
 		if (info->head->fmh_entries >= info->head->fmh_count)
 			return -ECANCELED;
 
@@ -341,7 +324,7 @@ xfs_getfsmap_helper(
 		fmr.fmr_physical = info->next_daddr;
 		fmr.fmr_owner = info->missing_owner;
 		fmr.fmr_offset = 0;
-		fmr.fmr_length = rec_daddr - info->next_daddr;
+		fmr.fmr_length = frec->start_daddr - info->next_daddr;
 		fmr.fmr_flags = FMR_OF_SPECIAL_OWNER;
 		xfs_getfsmap_format(mp, &fmr, info);
 	}
@@ -355,23 +338,23 @@ xfs_getfsmap_helper(
 
 	trace_xfs_fsmap_mapping(mp, info->dev,
 			info->group ? info->group->xg_gno : NULLAGNUMBER,
-			rec);
+			frec);
 
 	fmr.fmr_device = info->dev;
-	fmr.fmr_physical = rec_daddr;
-	error = xfs_fsmap_owner_from_rmap(&fmr, rec);
+	fmr.fmr_physical = frec->start_daddr;
+	error = xfs_fsmap_owner_from_frec(&fmr, frec);
 	if (error)
 		return error;
-	fmr.fmr_offset = XFS_FSB_TO_BB(mp, rec->rm_offset);
-	fmr.fmr_length = len_daddr;
-	if (rec->rm_flags & XFS_RMAP_UNWRITTEN)
+	fmr.fmr_offset = XFS_FSB_TO_BB(mp, frec->offset);
+	fmr.fmr_length = frec->len_daddr;
+	if (frec->rm_flags & XFS_RMAP_UNWRITTEN)
 		fmr.fmr_flags |= FMR_OF_PREALLOC;
-	if (rec->rm_flags & XFS_RMAP_ATTR_FORK)
+	if (frec->rm_flags & XFS_RMAP_ATTR_FORK)
 		fmr.fmr_flags |= FMR_OF_ATTR_FORK;
-	if (rec->rm_flags & XFS_RMAP_BMBT_BLOCK)
+	if (frec->rm_flags & XFS_RMAP_BMBT_BLOCK)
 		fmr.fmr_flags |= FMR_OF_EXTENT_MAP;
 	if (fmr.fmr_flags == 0) {
-		error = xfs_getfsmap_is_shared(tp, info, rec, &shared);
+		error = xfs_getfsmap_is_shared(tp, info, frec, &shared);
 		if (error)
 			return error;
 		if (shared)
@@ -380,25 +363,55 @@ xfs_getfsmap_helper(
 
 	xfs_getfsmap_format(mp, &fmr, info);
 out:
-	rec_daddr += len_daddr;
-	if (info->next_daddr < rec_daddr)
-		info->next_daddr = rec_daddr;
+	info->next_daddr = max(info->next_daddr,
+			       frec->start_daddr + frec->len_daddr);
 	return 0;
 }
 
+static inline int
+xfs_getfsmap_group_helper(
+	struct xfs_getfsmap_info	*info,
+	struct xfs_trans		*tp,
+	struct xfs_group		*xg,
+	xfs_agblock_t			startblock,
+	xfs_extlen_t			blockcount,
+	struct xfs_fsmap_irec		*frec)
+{
+	/*
+	 * For an info->last query, we're looking for a gap between the last
+	 * mapping emitted and the high key specified by userspace.  If the
+	 * user's query spans less than 1 fsblock, then info->high and
+	 * info->low will have the same rm_startblock, which causes rec_daddr
+	 * and next_daddr to be the same.  Therefore, use the end_daddr that
+	 * we calculated from userspace's high key to synthesize the record.
+	 * Note that if the btree query found a mapping, there won't be a gap.
+	 */
+	if (info->last && info->end_daddr != XFS_BUF_DADDR_NULL)
+		frec->start_daddr = info->end_daddr;
+	else
+		frec->start_daddr = xfs_gbno_to_daddr(xg, startblock);
+
+	frec->len_daddr = XFS_FSB_TO_BB(xg->xg_mount, blockcount);
+	return xfs_getfsmap_helper(tp, info, frec);
+}
+
 /* Transform a rmapbt irec into a fsmap */
 STATIC int
-xfs_getfsmap_datadev_helper(
+xfs_getfsmap_rmapbt_helper(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*rec,
 	void				*priv)
 {
+	struct xfs_fsmap_irec		frec = {
+		.owner			= rec->rm_owner,
+		.offset			= rec->rm_offset,
+		.rm_flags		= rec->rm_flags,
+		.rec_key		= rec->rm_startblock,
+	};
 	struct xfs_getfsmap_info	*info = priv;
 
-	return xfs_getfsmap_helper(cur->bc_tp, info, rec,
-			xfs_agbno_to_daddr(to_perag(cur->bc_group),
-				rec->rm_startblock),
-			0);
+	return xfs_getfsmap_group_helper(info, cur->bc_tp, cur->bc_group,
+			rec->rm_startblock, rec->rm_blockcount, &frec);
 }
 
 /* Transform a bnobt irec into a fsmap */
@@ -408,19 +421,14 @@ xfs_getfsmap_datadev_bnobt_helper(
 	const struct xfs_alloc_rec_incore *rec,
 	void				*priv)
 {
+	struct xfs_fsmap_irec		frec = {
+		.owner			= XFS_RMAP_OWN_NULL, /* "free" */
+		.rec_key		= rec->ar_startblock,
+	};
 	struct xfs_getfsmap_info	*info = priv;
-	struct xfs_rmap_irec		irec;
 
-	irec.rm_startblock = rec->ar_startblock;
-	irec.rm_blockcount = rec->ar_blockcount;
-	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
-	irec.rm_offset = 0;
-	irec.rm_flags = 0;
-
-	return xfs_getfsmap_helper(cur->bc_tp, info, &irec,
-			xfs_agbno_to_daddr(to_perag(cur->bc_group),
-				rec->ar_startblock),
-			0);
+	return xfs_getfsmap_group_helper(info, cur->bc_tp, cur->bc_group,
+			rec->ar_startblock, rec->ar_blockcount, &frec);
 }
 
 /* Set rmap flags based on the getfsmap flags */
@@ -544,9 +552,9 @@ __xfs_getfsmap_datadev(
 		if (error)
 			break;
 
-		trace_xfs_fsmap_low_key(mp, info->dev, pag_agno(pag),
+		trace_xfs_fsmap_low_group_key(mp, info->dev, pag_agno(pag),
 				&info->low);
-		trace_xfs_fsmap_high_key(mp, info->dev, pag_agno(pag),
+		trace_xfs_fsmap_high_group_key(mp, info->dev, pag_agno(pag),
 				&info->high);
 
 		error = query_fn(tp, info, &bt_cur, priv);
@@ -602,13 +610,13 @@ xfs_getfsmap_datadev_rmapbt_query(
 {
 	/* Report any gap at the end of the last AG. */
 	if (info->last)
-		return xfs_getfsmap_datadev_helper(*curpp, &info->high, info);
+		return xfs_getfsmap_rmapbt_helper(*curpp, &info->high, info);
 
 	/* Allocate cursor for this AG and query_range it. */
 	*curpp = xfs_rmapbt_init_cursor(tp->t_mountp, tp, info->agf_bp,
 			to_perag(info->group));
 	return xfs_rmap_query_range(*curpp, &info->low, &info->high,
-			xfs_getfsmap_datadev_helper, info);
+			xfs_getfsmap_rmapbt_helper, info);
 }
 
 /* Execute a getfsmap query against the regular data device rmapbt. */
@@ -668,9 +676,12 @@ xfs_getfsmap_logdev(
 	const struct xfs_fsmap		*keys,
 	struct xfs_getfsmap_info	*info)
 {
+	struct xfs_fsmap_irec		frec = {
+		.start_daddr		= 0,
+		.rec_key		= 0,
+		.owner			= XFS_RMAP_OWN_LOG,
+	};
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_rmap_irec		rmap;
-	xfs_daddr_t			rec_daddr, len_daddr;
 	xfs_fsblock_t			start_fsb, end_fsb;
 	uint64_t			eofs;
 
@@ -685,22 +696,15 @@ xfs_getfsmap_logdev(
 	if (keys[0].fmr_length > 0)
 		info->low_daddr = XFS_FSB_TO_BB(mp, start_fsb);
 
-	trace_xfs_fsmap_low_key_linear(mp, info->dev, start_fsb);
-	trace_xfs_fsmap_high_key_linear(mp, info->dev, end_fsb);
+	trace_xfs_fsmap_low_linear_key(mp, info->dev, start_fsb);
+	trace_xfs_fsmap_high_linear_key(mp, info->dev, end_fsb);
 
 	if (start_fsb > 0)
 		return 0;
 
 	/* Fabricate an rmap entry for the external log device. */
-	rmap.rm_startblock = 0;
-	rmap.rm_blockcount = mp->m_sb.sb_logblocks;
-	rmap.rm_owner = XFS_RMAP_OWN_LOG;
-	rmap.rm_offset = 0;
-	rmap.rm_flags = 0;
-
-	rec_daddr = XFS_FSB_TO_BB(mp, rmap.rm_startblock);
-	len_daddr = XFS_FSB_TO_BB(mp, rmap.rm_blockcount);
-	return xfs_getfsmap_helper(tp, info, &rmap, rec_daddr, len_daddr);
+	frec.len_daddr = XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
+	return xfs_getfsmap_helper(tp, info, &frec);
 }
 
 #ifdef CONFIG_XFS_RT
@@ -712,24 +716,31 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 	const struct xfs_rtalloc_rec	*rec,
 	void				*priv)
 {
+	struct xfs_fsmap_irec		frec = {
+		.owner			= XFS_RMAP_OWN_NULL, /* "free" */
+	};
 	struct xfs_getfsmap_info	*info = priv;
-	struct xfs_rmap_irec		irec;
 	xfs_rtblock_t			rtbno;
-	xfs_daddr_t			rec_daddr, len_daddr;
 
-	rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
-	rec_daddr = XFS_FSB_TO_BB(mp, rtbno);
-	irec.rm_startblock = rtbno;
+	/*
+	 * For an info->last query, we're looking for a gap between the last
+	 * mapping emitted and the high key specified by userspace.  If the
+	 * user's query spans less than 1 fsblock, then info->high and
+	 * info->low will have the same rm_startblock, which causes rec_daddr
+	 * and next_daddr to be the same.  Therefore, use the end_daddr that
+	 * we calculated from userspace's high key to synthesize the record.
+	 * Note that if the btree query found a mapping, there won't be a gap.
+	 */
+	if (info->last && info->end_daddr != XFS_BUF_DADDR_NULL) {
+		frec.start_daddr = info->end_daddr;
+	} else {
+		rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
+		frec.start_daddr = XFS_FSB_TO_BB(mp, rtbno);
+	}
 
 	rtbno = xfs_rtx_to_rtb(mp, rec->ar_extcount);
-	len_daddr = XFS_FSB_TO_BB(mp, rtbno);
-	irec.rm_blockcount = rtbno;
-
-	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
-	irec.rm_offset = 0;
-	irec.rm_flags = 0;
-
-	return xfs_getfsmap_helper(tp, info, &irec, rec_daddr, len_daddr);
+	frec.len_daddr = XFS_FSB_TO_BB(mp, rtbno);
+	return xfs_getfsmap_helper(tp, info, &frec);
 }
 
 /* Execute a getfsmap query against the realtime device rtbitmap. */
@@ -764,8 +775,8 @@ xfs_getfsmap_rtdev_rtbitmap(
 			return 0;
 	}
 
-	trace_xfs_fsmap_low_key_linear(mp, info->dev, start_rtb);
-	trace_xfs_fsmap_high_key_linear(mp, info->dev, end_rtb);
+	trace_xfs_fsmap_low_linear_key(mp, info->dev, start_rtb);
+	trace_xfs_fsmap_high_linear_key(mp, info->dev, end_rtb);
 
 	xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
 
diff --git a/fs/xfs/xfs_fsmap.h b/fs/xfs/xfs_fsmap.h
index a0bcc38486a569..06e492fd479de6 100644
--- a/fs/xfs/xfs_fsmap.h
+++ b/fs/xfs/xfs_fsmap.h
@@ -28,6 +28,21 @@ struct xfs_fsmap_head {
 	struct xfs_fsmap fmh_keys[2];	/* low and high keys */
 };
 
+/* internal fsmap record format */
+struct xfs_fsmap_irec {
+	xfs_daddr_t	start_daddr;
+	xfs_daddr_t	len_daddr;
+	uint64_t	owner;		/* extent owner */
+	uint64_t	offset;		/* offset within the owner */
+	unsigned int	rm_flags;	/* rmap state flags */
+
+	/*
+	 * rmapbt startblock corresponding to start_daddr, if the record came
+	 * from an rmap btree.
+	 */
+	xfs_agblock_t	rec_key;
+};
+
 int xfs_ioc_getfsmap(struct xfs_inode *ip, struct fsmap_head __user *arg);
 
 #endif /* __XFS_FSMAP_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index e2db13ed08b59c..0f3704f3c2e4e3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -72,6 +72,7 @@ struct xfs_btree_cur;
 struct xfs_defer_op_type;
 struct xfs_refcount_irec;
 struct xfs_fsmap;
+struct xfs_fsmap_irec;
 struct xfs_group;
 struct xfs_rmap_irec;
 struct xfs_icreate_log;
@@ -3877,7 +3878,45 @@ DEFINE_INODE_IREC_EVENT(xfs_swap_extent_rmap_remap_piece);
 DEFINE_INODE_ERROR_EVENT(xfs_swap_extent_rmap_error);
 
 /* fsmap traces */
-DECLARE_EVENT_CLASS(xfs_fsmap_class,
+TRACE_EVENT(xfs_fsmap_mapping,
+	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_agnumber_t agno,
+		 const struct xfs_fsmap_irec *frec),
+	TP_ARGS(mp, keydev, agno, frec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(dev_t, keydev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_daddr_t, start_daddr)
+		__field(xfs_daddr_t, len_daddr)
+		__field(uint64_t, owner)
+		__field(uint64_t, offset)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->keydev = new_decode_dev(keydev);
+		__entry->agno = agno;
+		__entry->agbno = frec->rec_key;
+		__entry->start_daddr = frec->start_daddr;
+		__entry->len_daddr = frec->len_daddr;
+		__entry->owner = frec->owner;
+		__entry->offset = frec->offset;
+		__entry->flags = frec->rm_flags;
+	),
+	TP_printk("dev %d:%d keydev %d:%d agno 0x%x rmapbno 0x%x start_daddr 0x%llx len_daddr 0x%llx owner 0x%llx fileoff 0x%llx flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->start_daddr,
+		  __entry->len_daddr,
+		  __entry->owner,
+		  __entry->offset,
+		  __entry->flags)
+);
+
+DECLARE_EVENT_CLASS(xfs_fsmap_group_key_class,
 	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_agnumber_t agno,
 		 const struct xfs_rmap_irec *rmap),
 	TP_ARGS(mp, keydev, agno, rmap),
@@ -3885,8 +3924,7 @@ DECLARE_EVENT_CLASS(xfs_fsmap_class,
 		__field(dev_t, dev)
 		__field(dev_t, keydev)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_fsblock_t, bno)
-		__field(xfs_filblks_t, len)
+		__field(xfs_agblock_t, agbno)
 		__field(uint64_t, owner)
 		__field(uint64_t, offset)
 		__field(unsigned int, flags)
@@ -3895,33 +3933,30 @@ DECLARE_EVENT_CLASS(xfs_fsmap_class,
 		__entry->dev = mp->m_super->s_dev;
 		__entry->keydev = new_decode_dev(keydev);
 		__entry->agno = agno;
-		__entry->bno = rmap->rm_startblock;
-		__entry->len = rmap->rm_blockcount;
+		__entry->agbno = rmap->rm_startblock;
 		__entry->owner = rmap->rm_owner;
 		__entry->offset = rmap->rm_offset;
 		__entry->flags = rmap->rm_flags;
 	),
-	TP_printk("dev %d:%d keydev %d:%d agno 0x%x startblock 0x%llx fsbcount 0x%llx owner 0x%llx fileoff 0x%llx flags 0x%x",
+	TP_printk("dev %d:%d keydev %d:%d agno 0x%x startblock 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
 		  __entry->agno,
-		  __entry->bno,
-		  __entry->len,
+		  __entry->agbno,
 		  __entry->owner,
 		  __entry->offset,
 		  __entry->flags)
 )
-#define DEFINE_FSMAP_EVENT(name) \
-DEFINE_EVENT(xfs_fsmap_class, name, \
+#define DEFINE_FSMAP_GROUP_KEY_EVENT(name) \
+DEFINE_EVENT(xfs_fsmap_group_key_class, name, \
 	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_agnumber_t agno, \
 		 const struct xfs_rmap_irec *rmap), \
 	TP_ARGS(mp, keydev, agno, rmap))
-DEFINE_FSMAP_EVENT(xfs_fsmap_low_key);
-DEFINE_FSMAP_EVENT(xfs_fsmap_high_key);
-DEFINE_FSMAP_EVENT(xfs_fsmap_mapping);
+DEFINE_FSMAP_GROUP_KEY_EVENT(xfs_fsmap_low_group_key);
+DEFINE_FSMAP_GROUP_KEY_EVENT(xfs_fsmap_high_group_key);
 
-DECLARE_EVENT_CLASS(xfs_fsmap_linear_class,
-	TP_PROTO(struct xfs_mount *mp, u32 keydev, uint64_t bno),
+DECLARE_EVENT_CLASS(xfs_fsmap_linear_key_class,
+	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_fsblock_t bno),
 	TP_ARGS(mp, keydev, bno),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -3938,12 +3973,12 @@ DECLARE_EVENT_CLASS(xfs_fsmap_linear_class,
 		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
 		  __entry->bno)
 )
-#define DEFINE_FSMAP_LINEAR_EVENT(name) \
-DEFINE_EVENT(xfs_fsmap_linear_class, name, \
+#define DEFINE_FSMAP_LINEAR_KEY_EVENT(name) \
+DEFINE_EVENT(xfs_fsmap_linear_key_class, name, \
 	TP_PROTO(struct xfs_mount *mp, u32 keydev, uint64_t bno), \
 	TP_ARGS(mp, keydev, bno))
-DEFINE_FSMAP_LINEAR_EVENT(xfs_fsmap_low_key_linear);
-DEFINE_FSMAP_LINEAR_EVENT(xfs_fsmap_high_key_linear);
+DEFINE_FSMAP_LINEAR_KEY_EVENT(xfs_fsmap_low_linear_key);
+DEFINE_FSMAP_LINEAR_KEY_EVENT(xfs_fsmap_high_linear_key);
 
 DECLARE_EVENT_CLASS(xfs_getfsmap_class,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_fsmap *fsmap),


