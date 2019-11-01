Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98DD6ECAC6
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Nov 2019 23:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfKAWIG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 Nov 2019 18:08:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53664 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWIG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Nov 2019 18:08:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aK5obYExMhxMaobJy1o1glpnyuRHPNTRTVuzgapvSW0=; b=d9egofB4mQdQHEF+94iVpWNZD
        JDdXm9VafpYicB4KkRoUt+uGPC4dcX7VKFnGqTCwiqCC4tpCwKtsAamiqXNbR6AUBH66/e3I1r6Dl
        6rvxxn3qj6DPgBKqqCQyqhcw+S1rvRCh3KSUtMcf7VoKCgz1cjBqtdZs2Vst4VW/6Tr4wqJNPfoK0
        IJSrdecqS3rCIcSLO/P9q0/w2MSGgKhGGFPc9QylhX3ArRpuiWNYzcwzG9vM/sgwE4xhydZ7idJoM
        c9xRmnPjt7NWknlNp4snPsvNDCLA93Br4oJA2yUDOkRoE5rEDjaCUZ0cdbLghH2YSHzd9Tf4NZO3B
        kGaV3198w==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQf5S-0005uZ-3V
        for linux-xfs@vger.kernel.org; Fri, 01 Nov 2019 22:08:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/34] xfs: devirtualize ->leaf_hdr_from_disk
Date:   Fri,  1 Nov 2019 15:06:52 -0700
Message-Id: <20191101220719.29100-8-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101220719.29100-1-hch@lst.de>
References: <20191101220719.29100-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the ->leaf_hdr_from_disk dir ops method with a directly called
xfs_dir2_leaf_hdr_from_disk helper that takes care of the differences
between the v4 and v5 on-disk format.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.c   |  5 ++--
 fs/xfs/libxfs/xfs_da_format.c  | 35 --------------------------
 fs/xfs/libxfs/xfs_dir2.h       |  2 --
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c  | 45 ++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_dir2_node.c  | 28 ++++++++++-----------
 fs/xfs/libxfs/xfs_dir2_priv.h  |  2 ++
 fs/xfs/scrub/dir.c             |  2 +-
 8 files changed, 58 insertions(+), 63 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 26ad79d96205..aeb1884fd8c7 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -641,7 +641,7 @@ xfs_da3_root_split(
 		struct xfs_dir2_leaf_entry *ents;
 
 		leaf = (xfs_dir2_leaf_t *)oldroot;
-		dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+		xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 		ents = dp->d_ops->leaf_ents_p(leaf);
 
 		ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
@@ -2283,7 +2283,8 @@ xfs_da3_swap_lastblock(
 		struct xfs_dir2_leaf_entry *ents;
 
 		dead_leaf2 = (xfs_dir2_leaf_t *)dead_info;
-		dp->d_ops->leaf_hdr_from_disk(&leafhdr, dead_leaf2);
+		xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr,
+					    dead_leaf2);
 		ents = dp->d_ops->leaf_ents_p(dead_leaf2);
 		dead_level = 0;
 		dead_hash = be32_to_cpu(ents[leafhdr.count - 1].hashval);
diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index 68dff1de61e9..c848cab41be5 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -430,21 +430,6 @@ xfs_dir3_leaf_ents_p(struct xfs_dir2_leaf *lp)
 	return ((struct xfs_dir3_leaf *)lp)->__ents;
 }
 
-static void
-xfs_dir2_leaf_hdr_from_disk(
-	struct xfs_dir3_icleaf_hdr	*to,
-	struct xfs_dir2_leaf		*from)
-{
-	to->forw = be32_to_cpu(from->hdr.info.forw);
-	to->back = be32_to_cpu(from->hdr.info.back);
-	to->magic = be16_to_cpu(from->hdr.info.magic);
-	to->count = be16_to_cpu(from->hdr.count);
-	to->stale = be16_to_cpu(from->hdr.stale);
-
-	ASSERT(to->magic == XFS_DIR2_LEAF1_MAGIC ||
-	       to->magic == XFS_DIR2_LEAFN_MAGIC);
-}
-
 static void
 xfs_dir2_leaf_hdr_to_disk(
 	struct xfs_dir2_leaf		*to,
@@ -460,23 +445,6 @@ xfs_dir2_leaf_hdr_to_disk(
 	to->hdr.stale = cpu_to_be16(from->stale);
 }
 
-static void
-xfs_dir3_leaf_hdr_from_disk(
-	struct xfs_dir3_icleaf_hdr	*to,
-	struct xfs_dir2_leaf		*from)
-{
-	struct xfs_dir3_leaf_hdr *hdr3 = (struct xfs_dir3_leaf_hdr *)from;
-
-	to->forw = be32_to_cpu(hdr3->info.hdr.forw);
-	to->back = be32_to_cpu(hdr3->info.hdr.back);
-	to->magic = be16_to_cpu(hdr3->info.hdr.magic);
-	to->count = be16_to_cpu(hdr3->count);
-	to->stale = be16_to_cpu(hdr3->stale);
-
-	ASSERT(to->magic == XFS_DIR3_LEAF1_MAGIC ||
-	       to->magic == XFS_DIR3_LEAFN_MAGIC);
-}
-
 static void
 xfs_dir3_leaf_hdr_to_disk(
 	struct xfs_dir2_leaf		*to,
@@ -648,7 +616,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 
 	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
 	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
-	.leaf_hdr_from_disk = xfs_dir2_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
@@ -693,7 +660,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 
 	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
 	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
-	.leaf_hdr_from_disk = xfs_dir2_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
@@ -738,7 +704,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 
 	.leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr),
 	.leaf_hdr_to_disk = xfs_dir3_leaf_hdr_to_disk,
-	.leaf_hdr_from_disk = xfs_dir3_leaf_hdr_from_disk,
 	.leaf_max_ents = xfs_dir3_max_leaf_ents,
 	.leaf_ents_p = xfs_dir3_leaf_ents_p,
 
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 87fe876e90ed..74c592496bf0 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -75,8 +75,6 @@ struct xfs_dir_ops {
 	int	leaf_hdr_size;
 	void	(*leaf_hdr_to_disk)(struct xfs_dir2_leaf *to,
 				    struct xfs_dir3_icleaf_hdr *from);
-	void	(*leaf_hdr_from_disk)(struct xfs_dir3_icleaf_hdr *to,
-				      struct xfs_dir2_leaf *from);
 	int	(*leaf_max_ents)(struct xfs_da_geometry *geo);
 	struct xfs_dir2_leaf_entry *
 		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 49e4bc39e7bb..e6ed90a6f19b 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -923,7 +923,7 @@ xfs_dir2_leaf_to_block(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = lbp->b_addr;
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index a53e4585a2f3..137ffd0a538b 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -30,6 +30,35 @@ static void xfs_dir3_leaf_log_bests(struct xfs_da_args *args,
 static void xfs_dir3_leaf_log_tail(struct xfs_da_args *args,
 				   struct xfs_buf *bp);
 
+void
+xfs_dir2_leaf_hdr_from_disk(
+	struct xfs_mount		*mp,
+	struct xfs_dir3_icleaf_hdr	*to,
+	struct xfs_dir2_leaf		*from)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_leaf *from3 = (struct xfs_dir3_leaf *)from;
+
+		to->forw = be32_to_cpu(from3->hdr.info.hdr.forw);
+		to->back = be32_to_cpu(from3->hdr.info.hdr.back);
+		to->magic = be16_to_cpu(from3->hdr.info.hdr.magic);
+		to->count = be16_to_cpu(from3->hdr.count);
+		to->stale = be16_to_cpu(from3->hdr.stale);
+
+		ASSERT(to->magic == XFS_DIR3_LEAF1_MAGIC ||
+		       to->magic == XFS_DIR3_LEAFN_MAGIC);
+	} else {
+		to->forw = be32_to_cpu(from->hdr.info.forw);
+		to->back = be32_to_cpu(from->hdr.info.back);
+		to->magic = be16_to_cpu(from->hdr.info.magic);
+		to->count = be16_to_cpu(from->hdr.count);
+		to->stale = be16_to_cpu(from->hdr.stale);
+
+		ASSERT(to->magic == XFS_DIR2_LEAF1_MAGIC ||
+		       to->magic == XFS_DIR2_LEAFN_MAGIC);
+	}
+}
+
 /*
  * Check the internal consistency of a leaf1 block.
  * Pop an assert if something is wrong.
@@ -43,7 +72,7 @@ xfs_dir3_leaf1_check(
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 
 	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
@@ -96,7 +125,7 @@ xfs_dir3_leaf_check_int(
 	ops = xfs_dir_get_ops(mp, dp);
 
 	if (!hdr) {
-		ops->leaf_hdr_from_disk(&leafhdr, leaf);
+		xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 		hdr = &leafhdr;
 	}
 
@@ -381,7 +410,7 @@ xfs_dir2_block_to_leaf(
 	/*
 	 * Set the counts in the leaf header.
 	 */
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 	leafhdr.count = be32_to_cpu(btp->count);
 	leafhdr.stale = be32_to_cpu(btp->stale);
 	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
@@ -608,7 +637,7 @@ xfs_dir2_leaf_addname(
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	length = dp->d_ops->data_entsize(args->namelen);
 
@@ -1197,7 +1226,7 @@ xfs_dir2_leaf_lookup_int(
 	leaf = lbp->b_addr;
 	xfs_dir3_leaf_check(dp, lbp);
 	ents = dp->d_ops->leaf_ents_p(leaf);
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 
 	/*
 	 * Look for the first leaf entry with our hash value.
@@ -1330,7 +1359,7 @@ xfs_dir2_leaf_removename(
 	hdr = dbp->b_addr;
 	xfs_dir3_data_check(dp, dbp);
 	bf = dp->d_ops->data_bestfree_p(hdr);
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 	/*
 	 * Point to the leaf entry, use that to point to the data entry.
@@ -1509,7 +1538,7 @@ xfs_dir2_leaf_search_hash(
 
 	leaf = lbp->b_addr;
 	ents = args->dp->d_ops->leaf_ents_p(leaf);
-	args->dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(args->dp->i_mount, &leafhdr, leaf);
 
 	/*
 	 * Note, the table cannot be empty, so we have to go through the loop.
@@ -1697,7 +1726,7 @@ xfs_dir2_node_to_leaf(
 		return 0;
 	lbp = state->path.blk[0].bp;
 	leaf = lbp->b_addr;
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 
 	ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
 	       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 705c4f562758..736a3ea2b92c 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -45,7 +45,7 @@ xfs_dir3_leafn_check(
 	struct xfs_dir2_leaf	*leaf = bp->b_addr;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 
 	if (leafhdr.magic == XFS_DIR3_LEAFN_MAGIC) {
 		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
@@ -438,7 +438,7 @@ xfs_dir2_leafn_add(
 
 	trace_xfs_dir2_leafn_add(args, index);
 
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	/*
@@ -534,7 +534,7 @@ xfs_dir2_leaf_lasthash(
 	struct xfs_dir2_leaf_entry *ents;
 	struct xfs_dir3_icleaf_hdr leafhdr;
 
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 
 	ASSERT(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
 	       leafhdr.magic == XFS_DIR3_LEAFN_MAGIC ||
@@ -583,7 +583,7 @@ xfs_dir2_leafn_lookup_for_addname(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	xfs_dir3_leaf_check(dp, bp);
@@ -735,7 +735,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	tp = args->trans;
 	mp = dp->i_mount;
 	leaf = bp->b_addr;
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(mp, &leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	xfs_dir3_leaf_check(dp, bp);
@@ -971,8 +971,8 @@ xfs_dir2_leafn_order(
 	struct xfs_dir3_icleaf_hdr hdr1;
 	struct xfs_dir3_icleaf_hdr hdr2;
 
-	dp->d_ops->leaf_hdr_from_disk(&hdr1, leaf1);
-	dp->d_ops->leaf_hdr_from_disk(&hdr2, leaf2);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr1, leaf1);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr2, leaf2);
 	ents1 = dp->d_ops->leaf_ents_p(leaf1);
 	ents2 = dp->d_ops->leaf_ents_p(leaf2);
 
@@ -1024,8 +1024,8 @@ xfs_dir2_leafn_rebalance(
 
 	leaf1 = blk1->bp->b_addr;
 	leaf2 = blk2->bp->b_addr;
-	dp->d_ops->leaf_hdr_from_disk(&hdr1, leaf1);
-	dp->d_ops->leaf_hdr_from_disk(&hdr2, leaf2);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr1, leaf1);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr2, leaf2);
 	ents1 = dp->d_ops->leaf_ents_p(leaf1);
 	ents2 = dp->d_ops->leaf_ents_p(leaf2);
 
@@ -1222,7 +1222,7 @@ xfs_dir2_leafn_remove(
 	dp = args->dp;
 	tp = args->trans;
 	leaf = bp->b_addr;
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	/*
@@ -1444,7 +1444,7 @@ xfs_dir2_leafn_toosmall(
 	 */
 	blk = &state->path.blk[state->path.active - 1];
 	leaf = blk->bp->b_addr;
-	dp->d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 	ents = dp->d_ops->leaf_ents_p(leaf);
 	xfs_dir3_leaf_check(dp, blk->bp);
 
@@ -1507,7 +1507,7 @@ xfs_dir2_leafn_toosmall(
 			(state->args->geo->blksize >> 2);
 
 		leaf = bp->b_addr;
-		dp->d_ops->leaf_hdr_from_disk(&hdr2, leaf);
+		xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &hdr2, leaf);
 		ents = dp->d_ops->leaf_ents_p(leaf);
 		count += hdr2.count - hdr2.stale;
 		bytes -= count * sizeof(ents[0]);
@@ -1570,8 +1570,8 @@ xfs_dir2_leafn_unbalance(
 	drop_leaf = drop_blk->bp->b_addr;
 	save_leaf = save_blk->bp->b_addr;
 
-	dp->d_ops->leaf_hdr_from_disk(&savehdr, save_leaf);
-	dp->d_ops->leaf_hdr_from_disk(&drophdr, drop_leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &savehdr, save_leaf);
+	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &drophdr, drop_leaf);
 	sents = dp->d_ops->leaf_ents_p(save_leaf);
 	dents = dp->d_ops->leaf_ents_p(drop_leaf);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 973b1527b7ba..434bb60c718c 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -67,6 +67,8 @@ extern int xfs_dir3_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
 		struct xfs_buf **bpp);
 
 /* xfs_dir2_leaf.c */
+void xfs_dir2_leaf_hdr_from_disk(struct xfs_mount *mp,
+		struct xfs_dir3_icleaf_hdr *to, struct xfs_dir2_leaf *from);
 extern int xfs_dir3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
 extern int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 97f274f7cd38..5b004d1f6bef 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -504,7 +504,7 @@ xchk_directory_leaf1_bestfree(
 	xchk_buffer_recheck(sc, bp);
 
 	leaf = bp->b_addr;
-	d_ops->leaf_hdr_from_disk(&leafhdr, leaf);
+	xfs_dir2_leaf_hdr_from_disk(sc->ip->i_mount, &leafhdr, leaf);
 	ents = d_ops->leaf_ents_p(leaf);
 	ltp = xfs_dir2_leaf_tail_p(geo, leaf);
 	bestcount = be32_to_cpu(ltp->bestcount);
-- 
2.20.1

