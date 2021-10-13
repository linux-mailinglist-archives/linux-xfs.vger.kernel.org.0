Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F44542B038
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Oct 2021 01:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbhJLXfV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Oct 2021 19:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234129AbhJLXfU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:35:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 239D760ED4;
        Tue, 12 Oct 2021 23:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081598;
        bh=Zvk7U/b35ya2g/SZFSUqx9RGV0HxoSvhrDfx119UcQI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TyLL5wstManFvOwxk5fQitchOXcYe0iasdUzPcb5iFOHNuaI/ZxnapAKaEYyhTAVr
         2drk3qL32uusWXjj2FL+YSlDe/EgYFaEEZeqyMAkHzbjNYY0yNr/6Lgk2jxWgC8Hgk
         Yf//DouoCDhqAPXRZt8AihT3jkx+f4JXg/K5Z8Y/aSkepJMYHPR9OuWxQfn+fSAbNr
         SDDc8IUfEBiIFCxKHOggue/Xmw2KAkH7ZnhklF+BxatIji7qE2tsWUTC7cZQK9GD4U
         EFEyAVQpfbS1lpRHq5stBjvZIVs/sd9wdQPRHN8MQFyIj/CiWUu+0umAepqMvH3oyO
         kYkFnfV5RGwRA==
Subject: [PATCH 08/15] xfs: encode the max btree height in the cursor
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Tue, 12 Oct 2021 16:33:17 -0700
Message-ID: <163408159784.4151249.6976364349258667730.stgit@magnolia>
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

Encode the maximum btree height in the cursor, since we're soon going to
allow smaller cursors for AG btrees and larger cursors for file btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c          |    2 +-
 fs/xfs/libxfs/xfs_btree.c         |    4 ++--
 fs/xfs/libxfs/xfs_btree.h         |    2 ++
 fs/xfs/libxfs/xfs_btree_staging.c |   10 +++++-----
 4 files changed, 10 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 644b956301b6..2ae5bf9a74e7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -239,7 +239,7 @@ xfs_bmap_get_bp(
 	if (!cur)
 		return NULL;
 
-	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++) {
+	for (i = 0; i < cur->bc_maxlevels; i++) {
 		if (!cur->bc_levels[i].bp)
 			break;
 		if (xfs_buf_daddr(cur->bc_levels[i].bp) == bno)
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 25dfab81025f..6ced8f028d47 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2933,7 +2933,7 @@ xfs_btree_new_iroot(
 	be16_add_cpu(&block->bb_level, 1);
 	xfs_btree_set_numrecs(block, 1);
 	cur->bc_nlevels++;
-	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
+	ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
 	cur->bc_levels[level + 1].ptr = 1;
 
 	kp = xfs_btree_key_addr(cur, 1, block);
@@ -3097,7 +3097,7 @@ xfs_btree_new_root(
 	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
 	cur->bc_levels[cur->bc_nlevels].ptr = nptr;
 	cur->bc_nlevels++;
-	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
+	ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
 	*stat = 1;
 	return 0;
 error0:
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 76509e819d60..43766e5b680f 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -238,6 +238,7 @@ struct xfs_btree_cur
 	xfs_btnum_t		bc_btnum; /* identifies which btree type */
 	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
 	uint8_t			bc_nlevels; /* number of levels in the tree */
+	uint8_t			bc_maxlevels; /* maximum levels for this btree type */
 	int			bc_statoff; /* offset of btree stats array */
 
 	/*
@@ -585,6 +586,7 @@ xfs_btree_alloc_cursor(
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
+	cur->bc_maxlevels = XFS_BTREE_MAXLEVELS;
 
 	return cur;
 }
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index cc56efc2b90a..dd75e208b543 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -657,12 +657,12 @@ xfs_btree_bload_compute_geometry(
 	 * checking levels 0 and 1 here, so set bc_nlevels such that the btree
 	 * code doesn't interpret either as the root level.
 	 */
-	cur->bc_nlevels = XFS_BTREE_MAXLEVELS - 1;
+	cur->bc_nlevels = cur->bc_maxlevels - 1;
 	xfs_btree_bload_ensure_slack(cur, &bbl->leaf_slack, 0);
 	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
 
 	bbl->nr_records = nr_this_level = nr_records;
-	for (cur->bc_nlevels = 1; cur->bc_nlevels <= XFS_BTREE_MAXLEVELS;) {
+	for (cur->bc_nlevels = 1; cur->bc_nlevels <= cur->bc_maxlevels;) {
 		uint64_t	level_blocks;
 		uint64_t	dontcare64;
 		unsigned int	level = cur->bc_nlevels - 1;
@@ -703,7 +703,7 @@ xfs_btree_bload_compute_geometry(
 			 * block-based btree level.
 			 */
 			cur->bc_nlevels++;
-			ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
+			ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
 			xfs_btree_bload_level_geometry(cur, bbl, level,
 					nr_this_level, &avg_per_block,
 					&level_blocks, &dontcare64);
@@ -719,14 +719,14 @@ xfs_btree_bload_compute_geometry(
 
 			/* Otherwise, we need another level of btree. */
 			cur->bc_nlevels++;
-			ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
+			ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
 		}
 
 		nr_blocks += level_blocks;
 		nr_this_level = level_blocks;
 	}
 
-	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS)
+	if (cur->bc_nlevels > cur->bc_maxlevels)
 		return -EOVERFLOW;
 
 	bbl->btree_height = cur->bc_nlevels;

