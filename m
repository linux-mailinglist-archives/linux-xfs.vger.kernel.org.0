Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDE7659E6B
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 00:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235530AbiL3XiT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 18:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235398AbiL3XiS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:38:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3336B1DF1A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:38:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 450AECE19D4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFB6C433EF;
        Fri, 30 Dec 2022 23:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443493;
        bh=td0v8e45rs0YQ5by97fooLAvBsNIqNbyakTse8nI3iw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JntyKvT0on7vYi+i4CbbMGI4xbVoQvZWIIjTFiBDUDYaY2fD35ZuBvR1JO5W/jCeI
         UA0tYBn8Dy2/DGZVfj1Ur/cN4f7Ddv8w0dYJU2DP4VYxMzEsTk5oXC76QNAEgU9Mlv
         Uj2CIIoCalz6ZPuXd7MsoS+Kf07wHjKzebiEH7neJ47wNDhrtMVzqQi1II22Gt5ADc
         D4fVb0vQsAXX78jDui4BQEqnVz8d2QOC1rffmji/oghePC+kJL1M6RJ1Qlxsnv3en/
         vicLv0kYntqcWsVdBNFNaki5zA2n9PS3CYpDH32fIC+IvA0pxwlSrI+ET1KXqc/mko
         J7LgqzN3cHqLg==
Subject: [PATCH 06/11] xfs: report dir/attr block corruption errors to the
 health system
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:15 -0800
Message-ID: <167243839546.695999.18091314194827192312.stgit@magnolia>
In-Reply-To: <167243839445.695999.12861421643354894719.stgit@magnolia>
References: <167243839445.695999.12861421643354894719.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Whenever we encounter corrupt directory or extended attribute blocks, we
should report that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c   |    4 ++++
 fs/xfs/libxfs/xfs_attr_remote.c |   27 ++++++++++++++++-----------
 fs/xfs/libxfs/xfs_da_btree.c    |   37 ++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_dir2.c        |    5 ++++-
 fs/xfs/libxfs/xfs_dir2_block.c  |    2 ++
 fs/xfs/libxfs/xfs_dir2_data.c   |    3 +++
 fs/xfs/libxfs/xfs_dir2_leaf.c   |    3 +++
 fs/xfs/libxfs/xfs_dir2_node.c   |    7 +++++++
 fs/xfs/libxfs/xfs_health.h      |    3 +++
 fs/xfs/xfs_attr_inactive.c      |    4 ++++
 fs/xfs/xfs_attr_list.c          |    9 ++++++++-
 fs/xfs/xfs_health.c             |   39 +++++++++++++++++++++++++++++++++++++++
 12 files changed, 125 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 40aba0a9d339..1ba16c369f26 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -29,6 +29,7 @@
 #include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_errortag.h"
+#include "xfs_health.h"
 
 
 /*
@@ -2437,6 +2438,7 @@ xfs_attr3_leaf_lookup_int(
 	entries = xfs_attr3_leaf_entryp(leaf);
 	if (ichdr.count >= args->geo->blksize / 8) {
 		xfs_buf_mark_corrupt(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -2456,10 +2458,12 @@ xfs_attr3_leaf_lookup_int(
 	}
 	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count))) {
 		xfs_buf_mark_corrupt(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval)) {
 		xfs_buf_mark_corrupt(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d440393b40eb..b18a3cf44192 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -22,6 +22,7 @@
 #include "xfs_attr_remote.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
@@ -276,17 +277,18 @@ xfs_attr3_rmt_hdr_set(
  */
 STATIC int
 xfs_attr_rmtval_copyout(
-	struct xfs_mount *mp,
-	struct xfs_buf	*bp,
-	xfs_ino_t	ino,
-	int		*offset,
-	int		*valuelen,
-	uint8_t		**dst)
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	struct xfs_inode	*dp,
+	int			*offset,
+	int			*valuelen,
+	uint8_t			**dst)
 {
-	char		*src = bp->b_addr;
-	xfs_daddr_t	bno = xfs_buf_daddr(bp);
-	int		len = BBTOB(bp->b_length);
-	int		blksize = mp->m_attr_geo->blksize;
+	char			*src = bp->b_addr;
+	xfs_ino_t		ino = dp->i_ino;
+	xfs_daddr_t		bno = xfs_buf_daddr(bp);
+	int			len = BBTOB(bp->b_length);
+	int			blksize = mp->m_attr_geo->blksize;
 
 	ASSERT(len >= blksize);
 
@@ -302,6 +304,7 @@ xfs_attr_rmtval_copyout(
 				xfs_alert(mp,
 "remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)",
 					bno, *offset, byte_cnt, ino);
+				xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 				return -EFSCORRUPTED;
 			}
 			hdr_size = sizeof(struct xfs_attr3_rmt_hdr);
@@ -418,10 +421,12 @@ xfs_attr_rmtval_get(
 			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_buf_read(mp->m_ddev_targp, dblkno, dblkcnt,
 					0, &bp, &xfs_attr3_rmt_buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_dirattr_mark_sick(args->dp, XFS_ATTR_FORK);
 			if (error)
 				return error;
 
-			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
+			error = xfs_attr_rmtval_copyout(mp, bp, args->dp,
 							&offset, &valuelen,
 							&dst);
 			xfs_buf_relse(bp);
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e576560b46e9..8d2992413047 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -23,6 +23,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
 #include "xfs_errortag.h"
+#include "xfs_health.h"
 
 /*
  * xfs_da_btree.c
@@ -352,6 +353,8 @@ const struct xfs_buf_ops xfs_da3_node_buf_ops = {
 static int
 xfs_da3_node_set_type(
 	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	int			whichfork,
 	struct xfs_buf		*bp)
 {
 	struct xfs_da_blkinfo	*info = bp->b_addr;
@@ -373,6 +376,7 @@ xfs_da3_node_set_type(
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, tp->t_mountp,
 				info, sizeof(*info));
 		xfs_trans_brelse(tp, bp);
+		xfs_dirattr_mark_sick(dp, whichfork);
 		return -EFSCORRUPTED;
 	}
 }
@@ -391,7 +395,7 @@ xfs_da3_node_read(
 			&xfs_da3_node_buf_ops);
 	if (error || !*bpp || !tp)
 		return error;
-	return xfs_da3_node_set_type(tp, *bpp);
+	return xfs_da3_node_set_type(tp, dp, whichfork, *bpp);
 }
 
 int
@@ -408,6 +412,8 @@ xfs_da3_node_read_mapped(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, mappedbno,
 			XFS_FSB_TO_BB(mp, xfs_dabuf_nfsb(mp, whichfork)), 0,
 			bpp, &xfs_da3_node_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_dirattr_mark_sick(dp, whichfork);
 	if (error || !*bpp)
 		return error;
 
@@ -418,7 +424,7 @@ xfs_da3_node_read_mapped(
 
 	if (!tp)
 		return 0;
-	return xfs_da3_node_set_type(tp, *bpp);
+	return xfs_da3_node_set_type(tp, dp, whichfork, *bpp);
 }
 
 /*========================================================================
@@ -612,6 +618,7 @@ xfs_da3_split(
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
 			xfs_buf_mark_corrupt(oldblk->bp);
+			xfs_da_mark_sick(state->args);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -625,6 +632,7 @@ xfs_da3_split(
 	if (node->hdr.info.back) {
 		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
 			xfs_buf_mark_corrupt(oldblk->bp);
+			xfs_da_mark_sick(state->args);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -1643,6 +1651,7 @@ xfs_da3_node_lookup_int(
 
 		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC) {
 			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 
@@ -1658,6 +1667,7 @@ xfs_da3_node_lookup_int(
 		/* Tree taller than we can handle; bail out! */
 		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
 			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 
@@ -1666,6 +1676,7 @@ xfs_da3_node_lookup_int(
 			expected_level = nodehdr.level - 1;
 		else if (expected_level != nodehdr.level) {
 			xfs_buf_mark_corrupt(blk->bp);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		} else
 			expected_level--;
@@ -1717,12 +1728,16 @@ xfs_da3_node_lookup_int(
 		}
 
 		/* We can't point back to the root. */
-		if (XFS_IS_CORRUPT(dp->i_mount, blkno == args->geo->leafblk))
+		if (XFS_IS_CORRUPT(dp->i_mount, blkno == args->geo->leafblk)) {
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
+		}
 	}
 
-	if (XFS_IS_CORRUPT(dp->i_mount, expected_level != 0))
+	if (XFS_IS_CORRUPT(dp->i_mount, expected_level != 0)) {
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * A leaf block that ends in the hashval that we are interested in
@@ -1740,6 +1755,7 @@ xfs_da3_node_lookup_int(
 			args->blkno = blk->blkno;
 		} else {
 			ASSERT(0);
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 		if (((retval == -ENOENT) || (retval == -ENOATTR)) &&
@@ -2305,8 +2321,10 @@ xfs_da3_swap_lastblock(
 	error = xfs_bmap_last_before(tp, dp, &lastoff, w);
 	if (error)
 		return error;
-	if (XFS_IS_CORRUPT(mp, lastoff == 0))
+	if (XFS_IS_CORRUPT(mp, lastoff == 0)) {
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
+	}
 	/*
 	 * Read the last block in the btree space.
 	 */
@@ -2355,6 +2373,7 @@ xfs_da3_swap_lastblock(
 		if (XFS_IS_CORRUPT(mp,
 				   be32_to_cpu(sib_info->forw) != last_blkno ||
 				   sib_info->magic != dead_info->magic)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2375,6 +2394,7 @@ xfs_da3_swap_lastblock(
 		if (XFS_IS_CORRUPT(mp,
 				   be32_to_cpu(sib_info->back) != last_blkno ||
 				   sib_info->magic != dead_info->magic)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2397,6 +2417,7 @@ xfs_da3_swap_lastblock(
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
 		if (XFS_IS_CORRUPT(mp,
 				   level >= 0 && level != par_hdr.level + 1)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2408,6 +2429,7 @@ xfs_da3_swap_lastblock(
 		     entno++)
 			continue;
 		if (XFS_IS_CORRUPT(mp, entno == par_hdr.count)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2433,6 +2455,7 @@ xfs_da3_swap_lastblock(
 		xfs_trans_brelse(tp, par_buf);
 		par_buf = NULL;
 		if (XFS_IS_CORRUPT(mp, par_blkno == 0)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2442,6 +2465,7 @@ xfs_da3_swap_lastblock(
 		par_node = par_buf->b_addr;
 		xfs_da3_node_hdr_from_disk(dp->i_mount, &par_hdr, par_node);
 		if (XFS_IS_CORRUPT(mp, par_hdr.level != level)) {
+			xfs_da_mark_sick(args);
 			error = -EFSCORRUPTED;
 			goto done;
 		}
@@ -2570,6 +2594,7 @@ xfs_dabuf_map(
 invalid_mapping:
 	/* Caller ok with no mapping. */
 	if (XFS_IS_CORRUPT(mp, !(flags & XFS_DABUF_MAP_HOLE_OK))) {
+		xfs_dirattr_mark_sick(dp, whichfork);
 		error = -EFSCORRUPTED;
 		if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
 			xfs_alert(mp, "%s: bno %u inode %llu",
@@ -2651,6 +2676,8 @@ xfs_da_read_buf(
 
 	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
 			&bp, ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_dirattr_mark_sick(dp, whichfork);
 	if (error)
 		goto out_free;
 
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index ee30044af39d..f56710005f43 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -18,6 +18,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
+#include "xfs_health.h"
 
 const struct xfs_name xfs_name_dotdot = {
 	.name	= (const unsigned char *)"..",
@@ -631,8 +632,10 @@ xfs_dir2_isblock(
 		return 0;
 
 	*isblock = true;
-	if (XFS_IS_CORRUPT(mp, args->dp->i_disk_size != args->geo->blksize))
+	if (XFS_IS_CORRUPT(mp, args->dp->i_disk_size != args->geo->blksize)) {
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
+	}
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 00f960a703b2..6b3ca2b384cf 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -20,6 +20,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 /*
  * Local function prototypes.
@@ -152,6 +153,7 @@ xfs_dir3_block_read(
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		*bpp = NULL;
+		xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index dbcf58979a59..7a6d965bea71 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 static xfs_failaddr_t xfs_dir2_data_freefind_verify(
 		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_free *bf,
@@ -433,6 +434,7 @@ xfs_dir3_data_read(
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		*bpp = NULL;
+		xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 		return -EFSCORRUPTED;
 	}
 
@@ -1198,6 +1200,7 @@ xfs_dir2_data_use_free(
 corrupt:
 	xfs_corruption_error(__func__, XFS_ERRLEVEL_LOW, args->dp->i_mount,
 			hdr, sizeof(*hdr), __FILE__, __LINE__, fa);
+	xfs_da_mark_sick(args);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index cb9e950a911d..08dda5ce9d91 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -19,6 +19,7 @@
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
+#include "xfs_health.h"
 
 /*
  * Local function declarations.
@@ -1393,8 +1394,10 @@ xfs_dir2_leaf_removename(
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	if (be16_to_cpu(bestsp[db]) != oldbest) {
 		xfs_buf_mark_corrupt(lbp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
+
 	/*
 	 * Mark the former data entry unused.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 7a03aeb9f4c9..be0b8834028c 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -20,6 +20,7 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
+#include "xfs_health.h"
 
 /*
  * Function declarations.
@@ -231,6 +232,7 @@ __xfs_dir3_free_read(
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		*bpp = NULL;
+		xfs_dirattr_mark_sick(dp, XFS_DATA_FORK);
 		return -EFSCORRUPTED;
 	}
 
@@ -443,6 +445,7 @@ xfs_dir2_leaf_to_node(
 	if (be32_to_cpu(ltp->bestcount) >
 				(uint)dp->i_disk_size / args->geo->blksize) {
 		xfs_buf_mark_corrupt(lbp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -517,6 +520,7 @@ xfs_dir2_leafn_add(
 	 */
 	if (index < 0) {
 		xfs_buf_mark_corrupt(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -736,6 +740,7 @@ xfs_dir2_leafn_lookup_for_addname(
 					   cpu_to_be16(NULLDATAOFF))) {
 				if (curfdb != newfdb)
 					xfs_trans_brelse(tp, curbp);
+				xfs_da_mark_sick(args);
 				return -EFSCORRUPTED;
 			}
 			curfdb = newfdb;
@@ -804,6 +809,7 @@ xfs_dir2_leafn_lookup_for_entry(
 	xfs_dir3_leaf_check(dp, bp);
 	if (leafhdr.count <= 0) {
 		xfs_buf_mark_corrupt(bp);
+		xfs_da_mark_sick(args);
 		return -EFSCORRUPTED;
 	}
 
@@ -1739,6 +1745,7 @@ xfs_dir2_node_add_datablk(
 			} else {
 				xfs_alert(mp, " ... fblk is NULL");
 			}
+			xfs_da_mark_sick(args);
 			return -EFSCORRUPTED;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 2ee06af82c5a..e2e1b95ddfb9 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -38,6 +38,7 @@ struct xfs_perag;
 struct xfs_inode;
 struct xfs_fsop_geom;
 struct xfs_btree_cur;
+struct xfs_da_args;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -145,6 +146,8 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 void xfs_health_unmount(struct xfs_mount *mp);
 void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
 void xfs_btree_mark_sick(struct xfs_btree_cur *cur);
+void xfs_dirattr_mark_sick(struct xfs_inode *ip, int whichfork);
+void xfs_da_mark_sick(struct xfs_da_args *args);
 
 /* Now some helpers. */
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 5db87b34fb6e..6ced1a657b1b 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -23,6 +23,7 @@
 #include "xfs_quota.h"
 #include "xfs_dir2.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
 
 /*
  * Invalidate any incore buffers associated with this remote attribute value
@@ -147,6 +148,7 @@ xfs_attr3_node_inactive(
 	if (level > XFS_DA_NODE_MAXDEPTH) {
 		xfs_buf_mark_corrupt(bp);
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
+		xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 		return -EFSCORRUPTED;
 	}
 
@@ -197,6 +199,7 @@ xfs_attr3_node_inactive(
 		default:
 			xfs_buf_mark_corrupt(child_bp);
 			xfs_trans_brelse(*trans, child_bp);
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 			error = -EFSCORRUPTED;
 			break;
 		}
@@ -286,6 +289,7 @@ xfs_attr3_root_inactive(
 		error = xfs_attr3_leaf_inactive(trans, dp, bp);
 		break;
 	default:
+		xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 		error = -EFSCORRUPTED;
 		xfs_buf_mark_corrupt(bp);
 		xfs_trans_brelse(*trans, bp);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 99bbbe1a0e44..305559bfe2a1 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -22,6 +22,7 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_dir2.h"
+#include "xfs_health.h"
 
 STATIC int
 xfs_attr_shortform_compare(const void *a, const void *b)
@@ -126,6 +127,7 @@ xfs_attr_shortform_list(
 					     context->dp->i_mount, sfe,
 					     sizeof(*sfe));
 			kmem_free(sbuf);
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 			return -EFSCORRUPTED;
 		}
 
@@ -263,8 +265,10 @@ xfs_attr_node_list_lookup(
 			return 0;
 
 		/* We can't point back to the root. */
-		if (XFS_IS_CORRUPT(mp, cursor->blkno == 0))
+		if (XFS_IS_CORRUPT(mp, cursor->blkno == 0)) {
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 			return -EFSCORRUPTED;
+		}
 	}
 
 	if (expected_level != 0)
@@ -276,6 +280,7 @@ xfs_attr_node_list_lookup(
 out_corruptbuf:
 	xfs_buf_mark_corrupt(bp);
 	xfs_trans_brelse(tp, bp);
+	xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 	return -EFSCORRUPTED;
 }
 
@@ -305,6 +310,8 @@ xfs_attr_node_list(
 	if (cursor->blkno > 0) {
 		error = xfs_da3_node_read(context->tp, dp, cursor->blkno, &bp,
 				XFS_ATTR_FORK);
+		if (xfs_metadata_is_sick(error))
+			xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
 		if ((error != 0) && (error != -EFSCORRUPTED))
 			return error;
 		if (bp) {
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 89cd4d21065e..50b054e4751b 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -15,6 +15,8 @@
 #include "xfs_health.h"
 #include "xfs_ag.h"
 #include "xfs_btree.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 
 /*
  * Warn about metadata corruption that we detected but haven't fixed, and
@@ -525,3 +527,40 @@ xfs_btree_mark_sick(
 
 	xfs_ag_mark_sick(cur->bc_ag.pag, mask);
 }
+
+/*
+ * Record observations of dir/attr btree corruption with the health tracking
+ * system.
+ */
+void
+xfs_dirattr_mark_sick(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	unsigned int		mask;
+
+	switch (whichfork) {
+	case XFS_DATA_FORK:
+		mask = XFS_SICK_INO_DIR;
+		break;
+	case XFS_ATTR_FORK:
+		mask = XFS_SICK_INO_XATTR;
+		break;
+	default:
+		ASSERT(0);
+		return;
+	}
+
+	xfs_inode_mark_sick(ip, mask);
+}
+
+/*
+ * Record observations of dir/attr btree corruption with the health tracking
+ * system.
+ */
+void
+xfs_da_mark_sick(
+	struct xfs_da_args	*args)
+{
+	xfs_dirattr_mark_sick(args->dp, args->whichfork);
+}

