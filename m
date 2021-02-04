Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA6A30A02F
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Feb 2021 03:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhBACGC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 31 Jan 2021 21:06:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231136AbhBACFb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:05:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1B7264E27;
        Mon,  1 Feb 2021 02:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145090;
        bh=6v55uQWPTQC02oTme5KVU0wF3uwR5YVG+4fgR9PN4f8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nuUX2GjNRNIaTMK09rFCh7fyvqy7Nt1T7nzFzQSY0u275hd3aJ9dqVdYoZkBI8nUn
         qeB2GU5lKoSNLGn0l3wROS3NiulzkmpagPoimnCReLazLZi46ZD8JGcU9htuAJVYp8
         hCqt+AyY4OGLumBAe5EmHotCPeZwYwBHp8dOtCK8KKBrXpS6AeiRmDkn/6eYDVIWLc
         +vGG0tCUNX/nP0BdZfYGqJ0ZuN6GeCJfEGfTKAc04vkNX1E/zg+OCiL5JcraRbReVJ
         UZPCUPSjUjID/VogTkd0iuJ2t7v4Sz6/pquaKRYPrWqch0UvVKgu50dB3OVjBsesZA
         XJvc4pi0hrNGQ==
Subject: [PATCH 11/17] xfs: refactor reflink functions to use
 xfs_trans_alloc_inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:04:50 -0800
Message-ID: <161214509047.139387.9228372636185546363.stgit@magnolia>
In-Reply-To: <161214502818.139387.7678025647736002500.stgit@magnolia>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The two remaining callers of xfs_trans_reserve_quota_nblks are in the
reflink code.  These conversions aren't as uniform as the previous
conversions, so call that out in a separate patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c   |    3 ++-
 fs/xfs/xfs_reflink.c |   59 ++++++++++++++++++++------------------------------
 2 files changed, 26 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f34a76529602..174e297ae62c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -844,7 +844,8 @@ xfs_direct_write_iomap_begin(
 	return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
 
 out_unlock:
-	xfs_iunlock(ip, lockmode);
+	if (lockmode)
+		xfs_iunlock(ip, lockmode);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0778b5810c26..27f875fa7a0d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -376,16 +376,14 @@ xfs_reflink_allocate_cow(
 	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
 
 	xfs_iunlock(ip, *lockmode);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	*lockmode = 0;
+
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
+			false, &tp);
+	if (error)
+		return error;
+
 	*lockmode = XFS_ILOCK_EXCL;
-	xfs_ilock(ip, *lockmode);
-
-	if (error)
-		return error;
-
-	error = xfs_qm_dqattach_locked(ip, false);
-	if (error)
-		goto out_trans_cancel;
 
 	/*
 	 * Check for an overlapping extent again now that we dropped the ilock.
@@ -398,12 +396,6 @@ xfs_reflink_allocate_cow(
 		goto convert;
 	}
 
-	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0, false);
-	if (error)
-		goto out_trans_cancel;
-
-	xfs_trans_ijoin(tp, ip, 0);
-
 	/* Allocate the entire reservation as unwritten blocks. */
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
@@ -997,7 +989,7 @@ xfs_reflink_remap_extent(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	xfs_off_t		newlen;
-	int64_t			qres, qdelta;
+	int64_t			qdelta = 0;
 	unsigned int		resblks;
 	bool			smap_real;
 	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
@@ -1005,15 +997,22 @@ xfs_reflink_remap_extent(
 	int			nimaps;
 	int			error;
 
-	/* Start a rolling transaction to switch the mappings */
+	/*
+	 * Start a rolling transaction to switch the mappings.
+	 *
+	 * Adding a written extent to the extent map can cause a bmbt split,
+	 * and removing a mapped extent from the extent can cause a bmbt split.
+	 * The two operations cannot both cause a split since they operate on
+	 * the same index in the bmap btree, so we only need a reservation for
+	 * one bmbt split if either thing is happening.  However, we haven't
+	 * locked the inode yet, so we reserve assuming this is the case.
+	 */
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
+			false, &tp);
 	if (error)
 		goto out;
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, 0);
-
 	/*
 	 * Read what's currently mapped in the destination file into smap.
 	 * If smap isn't a hole, we will have to remove it before we can add
@@ -1061,15 +1060,9 @@ xfs_reflink_remap_extent(
 	}
 
 	/*
-	 * Compute quota reservation if we think the quota block counter for
+	 * Increase quota reservation if we think the quota block counter for
 	 * this file could increase.
 	 *
-	 * Adding a written extent to the extent map can cause a bmbt split,
-	 * and removing a mapped extent from the extent can cause a bmbt split.
-	 * The two operations cannot both cause a split since they operate on
-	 * the same index in the bmap btree, so we only need a reservation for
-	 * one bmbt split if either thing is happening.
-	 *
 	 * If we are mapping a written extent into the file, we need to have
 	 * enough quota block count reservation to handle the blocks in that
 	 * extent.  We log only the delta to the quota block counts, so if the
@@ -1083,13 +1076,9 @@ xfs_reflink_remap_extent(
 	 * before we started.  That should have removed all the delalloc
 	 * reservations, but we code defensively.
 	 */
-	qres = qdelta = 0;
-	if (smap_real || dmap_written)
-		qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-	if (!smap_real && dmap_written)
-		qres += dmap->br_blockcount;
-	if (qres > 0) {
-		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0, false);
+	if (!smap_real && dmap_written) {
+		error = xfs_trans_reserve_quota_nblks(tp, ip,
+				dmap->br_blockcount, 0, false);
 		if (error)
 			goto out_cancel;
 	}

