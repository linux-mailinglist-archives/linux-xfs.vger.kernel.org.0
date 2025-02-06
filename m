Return-Path: <linux-xfs+bounces-19155-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BB87A2B53C
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Feb 2025 23:37:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 286D21888834
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Feb 2025 22:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0813D1DDA2D;
	Thu,  6 Feb 2025 22:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uqOcOJli"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFAB23C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881416; cv=none; b=IntIl74sn3Fz3vXhtF2Xa5yke9Co2+00O7AEEyUQp3lNepkPuc4fEm8vJZVyuWufRki/WuGeI+kZGYXvKG/L8+46nAZEjUmyC29vB/oZGy0/2/PvgjUnj4PxbTG0c6s++tksLuQg5xcJ2fLekBuEMw0/+C4LRYeYAcvFm9Se3Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881416; c=relaxed/simple;
	bh=eDDW89B5yZOHjaxft97iqzjRNWLI0xdKVncBVG9p+i0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fRC4CZz4KIjQy4cSc39CxhT3fYS0BIgEA9Uat8aaPbUmpjYPqPFwt85glyoqd+ZPtmfxciwXcp0wRcAA8FrW8boCgfExpYzZADr6N8/uiWUmBTMdduAXU6W1C6ghY8V4iw0LSThVN01f725GsFmLynrqkyV+EwVhwFKmJp6x4Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uqOcOJli; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B22C4CEDD;
	Thu,  6 Feb 2025 22:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881416;
	bh=eDDW89B5yZOHjaxft97iqzjRNWLI0xdKVncBVG9p+i0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uqOcOJli6vixBPE6mJ6vAKsromzuVWuSAjx7BcyWzQutz/DE0tuZlZbZmbCFzcpVO
	 YFqU898k0c/BlrTEPY8Z0BFalZOYQb8UCk9yfsnmQXhYlJtxr07dkJ7VHCLjLNBEsm
	 /Xlj/8+K884HTjSYdcusxUz7ki+NJtws4m84gQJbspbfiUTwcdnJndwub/UxM82EHM
	 kfxbxVhbhI4YFtRZUdvK3EK1ReB5+GB45kYdjb/NXlVxMQC3kFZd6uM1/MzIeCzvXZ
	 p5XJF8z8EEIW38fFJS5utIeCHwAHrSHtgYwWlmM9tX+gXwhyCRbeFMDS/KpZcrs1Mh
	 lO6Yp757TSfJQ==
Date: Thu, 06 Feb 2025 14:36:56 -0800
Subject: [PATCH 07/56] xfs: hoist the node iroot update code out of
 xfs_btree_kill_iroot
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086898.2739176.16949257047259822288.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 505248719fcbf2c76594fe2ef293680d97fe426c

In preparation for allowing records in an inode btree root, hoist the
code that copies keyptrs from an existing node child into the root block
to a separate function.  Remove some unnecessary conditionals and clean
up a few function calls in the new function.  Note that this change
reorders the ->free_block call with respect to the change in bc_nlevels
to make it easier to support inode root leaf blocks in the next patch.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree.c |   84 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 57 insertions(+), 27 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 87a3ed5fc7517c..2d1b42d5270db8 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -3724,6 +3724,60 @@ xfs_btree_insert(
 	return error;
 }
 
+/*
+ * Move the keyptrs from a child node block to the root block.
+ *
+ * Since the keyptr size does not change, all we have to do is increase the
+ * tree height, copy the keyptrs to the new internal node (cblock), shrink
+ * the root, and copy the pointers there.
+ */
+STATIC int
+xfs_btree_demote_node_child(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*cblock,
+	int			level,
+	int			numrecs)
+{
+	struct xfs_btree_block	*block;
+	union xfs_btree_key	*ckp;
+	union xfs_btree_key	*kp;
+	union xfs_btree_ptr	*cpp;
+	union xfs_btree_ptr	*pp;
+	int			i;
+	int			error;
+
+	/*
+	 * Adjust the root btree node size and the record count to match the
+	 * doomed child so that we can copy the keyptrs ahead of changing the
+	 * tree shape.
+	 */
+	block = cur->bc_ops->broot_realloc(cur, numrecs);
+
+	xfs_btree_set_numrecs(block, numrecs);
+	ASSERT(block->bb_numrecs == cblock->bb_numrecs);
+
+	/* Copy keys from the doomed block. */
+	kp = xfs_btree_key_addr(cur, 1, block);
+	ckp = xfs_btree_key_addr(cur, 1, cblock);
+	xfs_btree_copy_keys(cur, kp, ckp, numrecs);
+
+	/* Copy pointers from the doomed block. */
+	pp = xfs_btree_ptr_addr(cur, 1, block);
+	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
+	for (i = 0; i < numrecs; i++) {
+		error = xfs_btree_debug_check_ptr(cur, cpp, i, level - 1);
+		if (error)
+			return error;
+	}
+	xfs_btree_copy_ptrs(cur, pp, cpp, numrecs);
+
+	/* Decrease tree height, adjusting the root block level to match. */
+	cur->bc_levels[level - 1].bp = NULL;
+	be16_add_cpu(&block->bb_level, -1);
+	cur->bc_nlevels--;
+	return 0;
+}
+
 /*
  * Try to merge a non-leaf block back into the inode root.
  *
@@ -3739,10 +3793,6 @@ xfs_btree_kill_iroot(
 	struct xfs_inode	*ip = cur->bc_ino.ip;
 	struct xfs_btree_block	*block;
 	struct xfs_btree_block	*cblock;
-	union xfs_btree_key	*kp;
-	union xfs_btree_key	*ckp;
-	union xfs_btree_ptr	*pp;
-	union xfs_btree_ptr	*cpp;
 	struct xfs_buf		*cbp;
 	int			level;
 	int			numrecs;
@@ -3750,7 +3800,6 @@ xfs_btree_kill_iroot(
 #ifdef DEBUG
 	union xfs_btree_ptr	ptr;
 #endif
-	int			i;
 
 	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_INODE);
 	ASSERT(cur->bc_nlevels > 1);
@@ -3790,35 +3839,16 @@ xfs_btree_kill_iroot(
 	ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
 #endif
 
-	block = cur->bc_ops->broot_realloc(cur, numrecs);
-
-	block->bb_numrecs = be16_to_cpu(numrecs);
-	ASSERT(block->bb_numrecs == cblock->bb_numrecs);
-
-	kp = xfs_btree_key_addr(cur, 1, block);
-	ckp = xfs_btree_key_addr(cur, 1, cblock);
-	xfs_btree_copy_keys(cur, kp, ckp, numrecs);
-
-	pp = xfs_btree_ptr_addr(cur, 1, block);
-	cpp = xfs_btree_ptr_addr(cur, 1, cblock);
-
-	for (i = 0; i < numrecs; i++) {
-		error = xfs_btree_debug_check_ptr(cur, cpp, i, level - 1);
-		if (error)
-			return error;
-	}
-
-	xfs_btree_copy_ptrs(cur, pp, cpp, numrecs);
+	error = xfs_btree_demote_node_child(cur, cblock, level, numrecs);
+	if (error)
+		return error;
 
 	error = xfs_btree_free_block(cur, cbp);
 	if (error)
 		return error;
 
-	cur->bc_levels[level - 1].bp = NULL;
-	be16_add_cpu(&block->bb_level, -1);
 	xfs_trans_log_inode(cur->bc_tp, ip,
 		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_ino.whichfork));
-	cur->bc_nlevels--;
 out0:
 	return 0;
 }


