Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0274042B039
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Oct 2021 01:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234129AbhJLXf0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Oct 2021 19:35:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235972AbhJLXfZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:35:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97B0460EBB;
        Tue, 12 Oct 2021 23:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081603;
        bh=70RmJRLQAep4+0HUwvQeagPTpCQgjNe6TK/+LnXTpuA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fE8OIwwNbhpjD00FKEhCjAjatLvPn64md6u4MMeuiXNSZZ3KiW8tl+u5tjuAWpFKx
         Lxy6jtkQ6JC2qK9PKz86oxVWa7ephlhbVHLB5WDyvsycLZNrgNGF4peeNMpzILCvb0
         g3iSjHH7jlLcuH67mekXsFi8YFQ7tqN5bq1mpjzspMbMfoVxKnWCsScNCm+h/0A8Qz
         ziIQhyGZYoxNd+0Xbu9CAItl1OE8pPCmBbH3dN4km3zO5h/2+2cID5yVk9RohDkmGd
         CbjQQSvrq8cp0p5y7Xer1e3MfLBytJqqqVmG1hGFSnz5GZxz+C7yRSKUbixJhCOeX5
         BGJqU/yUyF/8g==
Subject: [PATCH 09/15] xfs: dynamically allocate cursors based on maxlevels
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Tue, 12 Oct 2021 16:33:23 -0700
Message-ID: <163408160334.4151249.13708314780740357223.stgit@magnolia>
In-Reply-To: <163408155346.4151249.8364703447365270670.stgit@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

To support future btree code, we need to be able to size btree cursors
dynamically for very large btrees.  Switch the maxlevels computation to
use the precomputed values in the superblock, and create cursors that
can handle a certain height.  For now, we retain the btree cursor zone
that can handle up to 9-level btrees, and create larger cursors (which
shouldn't happen currently) from the heap as a failsafe.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |    3 ++-
 fs/xfs/libxfs/xfs_btree.h          |   13 +++++++++++--
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    3 ++-
 fs/xfs/libxfs/xfs_refcount_btree.c |    3 ++-
 fs/xfs/libxfs/xfs_rmap_btree.c     |    3 ++-
 fs/xfs/xfs_super.c                 |    4 ++--
 7 files changed, 22 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index c644b11132f6..f14bad21503f 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -477,7 +477,7 @@ xfs_allocbt_init_common(
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum);
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_ag_maxlevels);
 	cur->bc_ag.abt.active = false;
 
 	if (btnum == XFS_BTNUM_CNT) {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index a06987e36db5..b90122de0df0 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -552,7 +552,8 @@ xfs_bmbt_init_cursor(
 	struct xfs_btree_cur	*cur;
 	ASSERT(whichfork != XFS_COW_FORK);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP);
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP,
+			mp->m_bm_maxlevels[whichfork]);
 	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 43766e5b680f..b8761a2fc24b 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -94,6 +94,12 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
 
 #define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
 
+/*
+ * The btree cursor zone hands out cursors that can handle up to this many
+ * levels.  This is the known maximum for all btree types.
+ */
+#define XFS_BTREE_CUR_ZONE_MAXLEVELS	(9)
+
 struct xfs_btree_ops {
 	/* size of the key and record structures */
 	size_t	key_len;
@@ -578,15 +584,18 @@ static inline struct xfs_btree_cur *
 xfs_btree_alloc_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_btnum_t		btnum)
+	xfs_btnum_t		btnum,
+	uint8_t			maxlevels)
 {
 	struct xfs_btree_cur	*cur;
 
+	ASSERT(maxlevels <= XFS_BTREE_CUR_ZONE_MAXLEVELS);
+
 	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
-	cur->bc_maxlevels = XFS_BTREE_MAXLEVELS;
+	cur->bc_maxlevels = maxlevels;
 
 	return cur;
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index c8fea6a464d5..3a5a24648b87 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -432,7 +432,8 @@ xfs_inobt_init_common(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum);
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum,
+			M_IGEO(mp)->inobt_maxlevels);
 	if (btnum == XFS_BTNUM_INO) {
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
 		cur->bc_ops = &xfs_inobt_ops;
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 48c45e31d897..995b0d86ddc0 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -322,7 +322,8 @@ xfs_refcountbt_init_common(
 
 	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC);
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC,
+			mp->m_refc_maxlevels);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index f3c4d0965cc9..1b48b7b3ee30 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -452,7 +452,8 @@ xfs_rmapbt_init_common(
 	struct xfs_btree_cur	*cur;
 
 	/* Overlapping btree; 2 keys per pointer. */
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP);
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP,
+			mp->m_rmap_maxlevels);
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_ops = &xfs_rmapbt_ops;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 30bae0657343..90c92a6a49e0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1966,8 +1966,8 @@ xfs_init_zones(void)
 		goto out_destroy_log_ticket_zone;
 
 	xfs_btree_cur_zone = kmem_cache_create("xfs_btree_cur",
-				xfs_btree_cur_sizeof(XFS_BTREE_MAXLEVELS),
-					       0, 0, NULL);
+			xfs_btree_cur_sizeof(XFS_BTREE_CUR_ZONE_MAXLEVELS),
+			0, 0, NULL);
 	if (!xfs_btree_cur_zone)
 		goto out_destroy_bmap_free_item_zone;
 

