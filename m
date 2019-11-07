Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37CA8F3705
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2019 19:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbfKGSYj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Nov 2019 13:24:39 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43990 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbfKGSYj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 13:24:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=r0l/IE8vs+ox0ywuU2wIz7dVQa4qzlr5GKW4kFbfoRk=; b=UDOBcRzobYKJTPkXl70edJQUVB
        aoXqGsDxSJYAurVEbrpqujNUBxr6dUFSgRmfzji+a7NMpCKJc19yLs2IE5NoReebv7h1WUPG+oqIw
        KjlWDuJALUUiJpJXW9w47nmGRn1BscZTH+uw4iwnHSPkMcdIqsWoeG/z22KJ6F2guJztfv3Ml130l
        4u3fTiUeqf8f7kNTOhF3fHBBb0OFzJ/f2kKDPhAze0nU6t3zNupmD6uK5Oo0kJIgLkEfgud39J6BJ
        ocU+cWU36C9r2OwdkFQd3WIlRvSDvu3p7RyaW4Za55DEicvGwCsoda6N5CePrrrr80M8gqbZhH1xE
        GKTTIQJw==;
Received: from [2001:4bb8:184:e48:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSmSU-00031y-Nv; Thu, 07 Nov 2019 18:24:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/46] xfs: devirtualize ->leaf_hdr_to_disk
Date:   Thu,  7 Nov 2019 19:23:33 +0100
Message-Id: <20191107182410.12660-10-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191107182410.12660-1-hch@lst.de>
References: <20191107182410.12660-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the ->leaf_hdr_to_disk dir ops method with a directly called
xfs_dir_leaf_hdr_to_disk helper that takes care of the differences
between the v4 and v5 on-disk format.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_format.c | 35 -------------------------------
 fs/xfs/libxfs/xfs_dir2.h      |  2 --
 fs/xfs/libxfs/xfs_dir2_leaf.c | 39 ++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_dir2_node.c | 12 +++++------
 fs/xfs/libxfs/xfs_dir2_priv.h |  2 ++
 5 files changed, 42 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.c b/fs/xfs/libxfs/xfs_da_format.c
index c848cab41be5..193708d12459 100644
--- a/fs/xfs/libxfs/xfs_da_format.c
+++ b/fs/xfs/libxfs/xfs_da_format.c
@@ -430,38 +430,6 @@ xfs_dir3_leaf_ents_p(struct xfs_dir2_leaf *lp)
 	return ((struct xfs_dir3_leaf *)lp)->__ents;
 }
 
-static void
-xfs_dir2_leaf_hdr_to_disk(
-	struct xfs_dir2_leaf		*to,
-	struct xfs_dir3_icleaf_hdr	*from)
-{
-	ASSERT(from->magic == XFS_DIR2_LEAF1_MAGIC ||
-	       from->magic == XFS_DIR2_LEAFN_MAGIC);
-
-	to->hdr.info.forw = cpu_to_be32(from->forw);
-	to->hdr.info.back = cpu_to_be32(from->back);
-	to->hdr.info.magic = cpu_to_be16(from->magic);
-	to->hdr.count = cpu_to_be16(from->count);
-	to->hdr.stale = cpu_to_be16(from->stale);
-}
-
-static void
-xfs_dir3_leaf_hdr_to_disk(
-	struct xfs_dir2_leaf		*to,
-	struct xfs_dir3_icleaf_hdr	*from)
-{
-	struct xfs_dir3_leaf_hdr *hdr3 = (struct xfs_dir3_leaf_hdr *)to;
-
-	ASSERT(from->magic == XFS_DIR3_LEAF1_MAGIC ||
-	       from->magic == XFS_DIR3_LEAFN_MAGIC);
-
-	hdr3->info.hdr.forw = cpu_to_be32(from->forw);
-	hdr3->info.hdr.back = cpu_to_be32(from->back);
-	hdr3->info.hdr.magic = cpu_to_be16(from->magic);
-	hdr3->count = cpu_to_be16(from->count);
-	hdr3->stale = cpu_to_be16(from->stale);
-}
-
 /*
  * Directory free space block operations
  */
@@ -615,7 +583,6 @@ static const struct xfs_dir_ops xfs_dir2_ops = {
 	.data_unused_p = xfs_dir2_data_unused_p,
 
 	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
-	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
@@ -659,7 +626,6 @@ static const struct xfs_dir_ops xfs_dir2_ftype_ops = {
 	.data_unused_p = xfs_dir2_data_unused_p,
 
 	.leaf_hdr_size = sizeof(struct xfs_dir2_leaf_hdr),
-	.leaf_hdr_to_disk = xfs_dir2_leaf_hdr_to_disk,
 	.leaf_max_ents = xfs_dir2_max_leaf_ents,
 	.leaf_ents_p = xfs_dir2_leaf_ents_p,
 
@@ -703,7 +669,6 @@ static const struct xfs_dir_ops xfs_dir3_ops = {
 	.data_unused_p = xfs_dir3_data_unused_p,
 
 	.leaf_hdr_size = sizeof(struct xfs_dir3_leaf_hdr),
-	.leaf_hdr_to_disk = xfs_dir3_leaf_hdr_to_disk,
 	.leaf_max_ents = xfs_dir3_max_leaf_ents,
 	.leaf_ents_p = xfs_dir3_leaf_ents_p,
 
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 74c592496bf0..15a1a72dc126 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -73,8 +73,6 @@ struct xfs_dir_ops {
 		(*data_unused_p)(struct xfs_dir2_data_hdr *hdr);
 
 	int	leaf_hdr_size;
-	void	(*leaf_hdr_to_disk)(struct xfs_dir2_leaf *to,
-				    struct xfs_dir3_icleaf_hdr *from);
 	int	(*leaf_max_ents)(struct xfs_da_geometry *geo);
 	struct xfs_dir2_leaf_entry *
 		(*leaf_ents_p)(struct xfs_dir2_leaf *lp);
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index b27609c852c5..07734c0fe8a7 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -59,6 +59,35 @@ xfs_dir2_leaf_hdr_from_disk(
 	}
 }
 
+void
+xfs_dir2_leaf_hdr_to_disk(
+	struct xfs_mount		*mp,
+	struct xfs_dir2_leaf		*to,
+	struct xfs_dir3_icleaf_hdr	*from)
+{
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_leaf *to3 = (struct xfs_dir3_leaf *)to;
+
+		ASSERT(from->magic == XFS_DIR3_LEAF1_MAGIC ||
+		       from->magic == XFS_DIR3_LEAFN_MAGIC);
+
+		to3->hdr.info.hdr.forw = cpu_to_be32(from->forw);
+		to3->hdr.info.hdr.back = cpu_to_be32(from->back);
+		to3->hdr.info.hdr.magic = cpu_to_be16(from->magic);
+		to3->hdr.count = cpu_to_be16(from->count);
+		to3->hdr.stale = cpu_to_be16(from->stale);
+	} else {
+		ASSERT(from->magic == XFS_DIR2_LEAF1_MAGIC ||
+		       from->magic == XFS_DIR2_LEAFN_MAGIC);
+
+		to->hdr.info.forw = cpu_to_be32(from->forw);
+		to->hdr.info.back = cpu_to_be32(from->back);
+		to->hdr.info.magic = cpu_to_be16(from->magic);
+		to->hdr.count = cpu_to_be16(from->count);
+		to->hdr.stale = cpu_to_be16(from->stale);
+	}
+}
+
 /*
  * Check the internal consistency of a leaf1 block.
  * Pop an assert if something is wrong.
@@ -413,7 +442,7 @@ xfs_dir2_block_to_leaf(
 	xfs_dir2_leaf_hdr_from_disk(dp->i_mount, &leafhdr, leaf);
 	leafhdr.count = be32_to_cpu(btp->count);
 	leafhdr.stale = be32_to_cpu(btp->stale);
-	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
+	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
 	xfs_dir3_leaf_log_header(args, lbp);
 
 	/*
@@ -881,7 +910,7 @@ xfs_dir2_leaf_addname(
 	/*
 	 * Log the leaf fields and give up the buffers.
 	 */
-	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
+	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
 	xfs_dir3_leaf_log_header(args, lbp);
 	xfs_dir3_leaf_log_ents(args, lbp, lfloglow, lfloghigh);
 	xfs_dir3_leaf_check(dp, lbp);
@@ -934,7 +963,7 @@ xfs_dir3_leaf_compact(
 	leafhdr->count -= leafhdr->stale;
 	leafhdr->stale = 0;
 
-	dp->d_ops->leaf_hdr_to_disk(leaf, leafhdr);
+	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, leafhdr);
 	xfs_dir3_leaf_log_header(args, bp);
 	if (loglow != -1)
 		xfs_dir3_leaf_log_ents(args, bp, loglow, to - 1);
@@ -1386,7 +1415,7 @@ xfs_dir2_leaf_removename(
 	 * We just mark the leaf entry stale by putting a null in it.
 	 */
 	leafhdr.stale++;
-	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
+	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
 	xfs_dir3_leaf_log_header(args, lbp);
 
 	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
@@ -1777,7 +1806,7 @@ xfs_dir2_node_to_leaf(
 	memcpy(xfs_dir2_leaf_bests_p(ltp), dp->d_ops->free_bests_p(free),
 		freehdr.nvalid * sizeof(xfs_dir2_data_off_t));
 
-	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
+	xfs_dir2_leaf_hdr_to_disk(mp, leaf, &leafhdr);
 	xfs_dir3_leaf_log_header(args, lbp);
 	xfs_dir3_leaf_log_bests(args, lbp, 0, be32_to_cpu(ltp->bestcount) - 1);
 	xfs_dir3_leaf_log_tail(args, lbp);
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index d4402b491a41..98cd645a8c99 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -497,7 +497,7 @@ xfs_dir2_leafn_add(
 	lep->address = cpu_to_be32(xfs_dir2_db_off_to_dataptr(args->geo,
 				args->blkno, args->index));
 
-	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
+	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
 	xfs_dir3_leaf_log_header(args, bp);
 	xfs_dir3_leaf_log_ents(args, bp, lfloglow, lfloghigh);
 	xfs_dir3_leaf_check(dp, bp);
@@ -1079,8 +1079,8 @@ xfs_dir2_leafn_rebalance(
 	ASSERT(hdr1.stale + hdr2.stale == oldstale);
 
 	/* log the changes made when moving the entries */
-	dp->d_ops->leaf_hdr_to_disk(leaf1, &hdr1);
-	dp->d_ops->leaf_hdr_to_disk(leaf2, &hdr2);
+	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf1, &hdr1);
+	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf2, &hdr2);
 	xfs_dir3_leaf_log_header(args, blk1->bp);
 	xfs_dir3_leaf_log_header(args, blk2->bp);
 
@@ -1249,7 +1249,7 @@ xfs_dir2_leafn_remove(
 	 * Log the leaf block changes.
 	 */
 	leafhdr.stale++;
-	dp->d_ops->leaf_hdr_to_disk(leaf, &leafhdr);
+	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, leaf, &leafhdr);
 	xfs_dir3_leaf_log_header(args, bp);
 
 	lep->address = cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
@@ -1605,8 +1605,8 @@ xfs_dir2_leafn_unbalance(
 	save_blk->hashval = be32_to_cpu(sents[savehdr.count - 1].hashval);
 
 	/* log the changes made when moving the entries */
-	dp->d_ops->leaf_hdr_to_disk(save_leaf, &savehdr);
-	dp->d_ops->leaf_hdr_to_disk(drop_leaf, &drophdr);
+	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, save_leaf, &savehdr);
+	xfs_dir2_leaf_hdr_to_disk(dp->i_mount, drop_leaf, &drophdr);
 	xfs_dir3_leaf_log_header(args, save_blk->bp);
 	xfs_dir3_leaf_log_header(args, drop_blk->bp);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 5f42f2c81869..af96e3faefaf 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -68,6 +68,8 @@ extern int xfs_dir3_data_init(struct xfs_da_args *args, xfs_dir2_db_t blkno,
 /* xfs_dir2_leaf.c */
 void xfs_dir2_leaf_hdr_from_disk(struct xfs_mount *mp,
 		struct xfs_dir3_icleaf_hdr *to, struct xfs_dir2_leaf *from);
+void xfs_dir2_leaf_hdr_to_disk(struct xfs_mount *mp, struct xfs_dir2_leaf *to,
+		struct xfs_dir3_icleaf_hdr *from);
 extern int xfs_dir3_leaf_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t fbno, xfs_daddr_t mappedbno, struct xfs_buf **bpp);
 extern int xfs_dir3_leafn_read(struct xfs_trans *tp, struct xfs_inode *dp,
-- 
2.20.1

