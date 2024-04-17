Return-Path: <linux-xfs+bounces-7104-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5656D8A8DEA
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 23:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AB18283D95
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 21:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5DA9651A1;
	Wed, 17 Apr 2024 21:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yt+L7omJ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BA518C19
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389267; cv=none; b=AQlj4qdqXSkRI2xg9w4s5zR/YQiUEowGecDAIgEVE9EKKWEu19ohDsLvjyqrDXwbsiAAMzQV1C5kJwo7atryOSYtSlpb3OWbh1s6mWiA1WR29ILWQoXSoD7k/Rmw270fbzlvnceD/JYjRSJA6rhLlcS0LhY+sykPBeuXmNHZmT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389267; c=relaxed/simple;
	bh=pLLQmgtensVUH3dDDhRJsajt2w5svyuHW26XBGdt0x8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lJlR5vPGO8TdGOxVAvevtkvZ+mxdqXoR6ea4A9+AWb07wcqAZwqcd6EyJdVRW6dw8gnmAbm+yk//Eh/KO72dBm+HnU2t20r40xK9zLkITkWV5aYQRm2Gt7MCYCHRoJDcyY6Tkvw3R0Z0WJAHCmWVo8y8GV8PVSgZ3Ld8rGW4Fv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yt+L7omJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8461C072AA;
	Wed, 17 Apr 2024 21:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389266;
	bh=pLLQmgtensVUH3dDDhRJsajt2w5svyuHW26XBGdt0x8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Yt+L7omJbqG+BVdNPKvN7HRdZJszkhio3WQyg4YwmtUOpifEhTyvLClDAjci2bAmv
	 P8UynGabdJBn2/LbHAW6FIcDwg+D/VtV9PD+xAoa/pOuldRJm0YgYvGT9kkhF5q7zn
	 1xE0QB1DsqYeTMsWDIjeLnkjwteEAzSpIg3PFvKmpfJPkUStWho5QqgKo1uxyCui7D
	 XaMJl1LyobX4Aq5ECHPmfccsARyUYLqhaomhjnjvaNWfXibAdbDS/fjb2bgsN3G7Jf
	 nelgogq1udNBFCUheO0I81kR2fzeXRURQijMiB2SzwK8IBwSE60L93mD77drzoxll+
	 fZYWV0DzY89AA==
Date: Wed, 17 Apr 2024 14:27:46 -0700
Subject: [PATCH 23/67] xfs: extract xfs_da_buf_copy() helper function
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Zhang Tianci <zhangtianci.1997@bytedance.com>,
 Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338842685.1853449.60809084737845813.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

Source kernel commit: fd45ddb9dd606b3eaddf26e13f64340636955986

This patch does not modify logic.

xfs_da_buf_copy() will copy one block from src xfs_buf to
dst xfs_buf, and update the block metadata in dst directly.

Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_attr_leaf.c |   12 +++-----
 libxfs/xfs_da_btree.c  |   74 +++++++++++++++++++-----------------------------
 libxfs/xfs_da_btree.h  |    2 +
 3 files changed, 36 insertions(+), 52 deletions(-)


diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index ed81471ce..baa168318 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1241,14 +1241,10 @@ xfs_attr3_leaf_to_node(
 	if (error)
 		goto out;
 
-	/* copy leaf to new buffer, update identifiers */
-	xfs_trans_buf_set_type(args->trans, bp2, XFS_BLFT_ATTR_LEAF_BUF);
-	bp2->b_ops = bp1->b_ops;
-	memcpy(bp2->b_addr, bp1->b_addr, args->geo->blksize);
-	if (xfs_has_crc(mp)) {
-		struct xfs_da3_blkinfo *hdr3 = bp2->b_addr;
-		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp2));
-	}
+	/*
+	 * Copy leaf to new buffer and log it.
+	 */
+	xfs_da_buf_copy(bp2, bp1, args->geo->blksize);
 	xfs_trans_log_buf(args->trans, bp2, 0, args->geo->blksize - 1);
 
 	/*
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 3903486d1..0779bb624 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -417,6 +417,25 @@ xfs_da3_node_read_mapped(
 	return xfs_da3_node_set_type(tp, *bpp);
 }
 
+/*
+ * Copy src directory/attr leaf/node buffer to the dst.
+ * For v5 file systems make sure the right blkno is stamped in.
+ */
+void
+xfs_da_buf_copy(
+	struct xfs_buf *dst,
+	struct xfs_buf *src,
+	size_t size)
+{
+	struct xfs_da3_blkinfo *da3 = dst->b_addr;
+
+	memcpy(dst->b_addr, src->b_addr, size);
+	dst->b_ops = src->b_ops;
+	xfs_trans_buf_copy_type(dst, src);
+	if (xfs_has_crc(dst->b_mount))
+		da3->blkno = cpu_to_be64(xfs_buf_daddr(dst));
+}
+
 /*========================================================================
  * Routines used for growing the Btree.
  *========================================================================*/
@@ -686,12 +705,6 @@ xfs_da3_root_split(
 		btree = icnodehdr.btree;
 		size = (int)((char *)&btree[icnodehdr.count] - (char *)oldroot);
 		level = icnodehdr.level;
-
-		/*
-		 * we are about to copy oldroot to bp, so set up the type
-		 * of bp while we know exactly what it will be.
-		 */
-		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
 	} else {
 		struct xfs_dir3_icleaf_hdr leafhdr;
 
@@ -703,31 +716,17 @@ xfs_da3_root_split(
 		size = (int)((char *)&leafhdr.ents[leafhdr.count] -
 			(char *)leaf);
 		level = 0;
-
-		/*
-		 * we are about to copy oldroot to bp, so set up the type
-		 * of bp while we know exactly what it will be.
-		 */
-		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_LEAFN_BUF);
 	}
 
 	/*
-	 * we can copy most of the information in the node from one block to
-	 * another, but for CRC enabled headers we have to make sure that the
-	 * block specific identifiers are kept intact. We update the buffer
-	 * directly for this.
+	 * Copy old root to new buffer and log it.
 	 */
-	memcpy(node, oldroot, size);
-	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC) ||
-	    oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC)) {
-		struct xfs_da3_intnode *node3 = (struct xfs_da3_intnode *)node;
-
-		node3->hdr.info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
-	}
+	xfs_da_buf_copy(bp, blk1->bp, size);
 	xfs_trans_log_buf(tp, bp, 0, size - 1);
 
-	bp->b_ops = blk1->bp->b_ops;
-	xfs_trans_buf_copy_type(bp, blk1->bp);
+	/*
+	 * Update blk1 to point to new buffer.
+	 */
 	blk1->bp = bp;
 	blk1->blkno = blkno;
 
@@ -1216,21 +1215,14 @@ xfs_da3_root_join(
 	xfs_da_blkinfo_onlychild_validate(bp->b_addr, oldroothdr.level);
 
 	/*
-	 * This could be copying a leaf back into the root block in the case of
-	 * there only being a single leaf block left in the tree. Hence we have
-	 * to update the b_ops pointer as well to match the buffer type change
-	 * that could occur. For dir3 blocks we also need to update the block
-	 * number in the buffer header.
+	 * Copy child to root buffer and log it.
 	 */
-	memcpy(root_blk->bp->b_addr, bp->b_addr, args->geo->blksize);
-	root_blk->bp->b_ops = bp->b_ops;
-	xfs_trans_buf_copy_type(root_blk->bp, bp);
-	if (oldroothdr.magic == XFS_DA3_NODE_MAGIC) {
-		struct xfs_da3_blkinfo *da3 = root_blk->bp->b_addr;
-		da3->blkno = cpu_to_be64(xfs_buf_daddr(root_blk->bp));
-	}
+	xfs_da_buf_copy(root_blk->bp, bp, args->geo->blksize);
 	xfs_trans_log_buf(args->trans, root_blk->bp, 0,
 			  args->geo->blksize - 1);
+	/*
+	 * Now we can drop the child buffer.
+	 */
 	error = xfs_da_shrink_inode(args, child, bp);
 	return error;
 }
@@ -2312,14 +2304,8 @@ xfs_da3_swap_lastblock(
 		return error;
 	/*
 	 * Copy the last block into the dead buffer and log it.
-	 * On CRC-enabled file systems, also update the stamped in blkno.
 	 */
-	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
-	if (xfs_has_crc(mp)) {
-		struct xfs_da3_blkinfo *da3 = dead_buf->b_addr;
-
-		da3->blkno = cpu_to_be64(xfs_buf_daddr(dead_buf));
-	}
+	xfs_da_buf_copy(dead_buf, last_buf, args->geo->blksize);
 	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
 	dead_info = dead_buf->b_addr;
 
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index ffa3df5b2..706baf36e 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -219,6 +219,8 @@ int	xfs_da_reada_buf(struct xfs_inode *dp, xfs_dablk_t bno,
 		const struct xfs_buf_ops *ops);
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 					  struct xfs_buf *dead_buf);
+void	xfs_da_buf_copy(struct xfs_buf *dst, struct xfs_buf *src,
+			size_t size);
 
 uint xfs_da_hashname(const uint8_t *name_string, int name_length);
 enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,


