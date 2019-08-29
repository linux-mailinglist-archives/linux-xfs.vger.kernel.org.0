Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 223B9A11CD
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Aug 2019 08:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfH2Gaz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Aug 2019 02:30:55 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53768 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727385AbfH2Gaz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 02:30:55 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 668AB43D7FC
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 16:30:48 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3DxG-0000xZ-IF
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 16:30:46 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3DxG-0006BN-GN
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 16:30:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] xfs: move xfs_dir2_addname()
Date:   Thu, 29 Aug 2019 16:30:38 +1000
Message-Id: <20190829063042.22902-2-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190829063042.22902-1-david@fromorbit.com>
References: <20190829063042.22902-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=FmdZ9Uzk2mMA:10 a=20KFwNOVAAAA:8
        a=xTgIVNI2wHdG23_4b9gA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This gets rid of the need for a forward  declaration of the static
function xfs_dir2_addname_int() and readies the code for factoring
of xfs_dir2_addname_int().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 140 +++++++++++++++++-----------------
 1 file changed, 69 insertions(+), 71 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 1fc44efc344d..e40986cc0759 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -32,8 +32,6 @@ static void xfs_dir2_leafn_rebalance(xfs_da_state_t *state,
 static int xfs_dir2_leafn_remove(xfs_da_args_t *args, struct xfs_buf *bp,
 				 int index, xfs_da_state_blk_t *dblk,
 				 int *rval);
-static int xfs_dir2_node_addname_int(xfs_da_args_t *args,
-				     xfs_da_state_blk_t *fblk);
 
 /*
  * Check internal consistency of a leafn block.
@@ -1610,75 +1608,6 @@ xfs_dir2_leafn_unbalance(
 	xfs_dir3_leaf_check(dp, drop_blk->bp);
 }
 
-/*
- * Top-level node form directory addname routine.
- */
-int						/* error */
-xfs_dir2_node_addname(
-	xfs_da_args_t		*args)		/* operation arguments */
-{
-	xfs_da_state_blk_t	*blk;		/* leaf block for insert */
-	int			error;		/* error return value */
-	int			rval;		/* sub-return value */
-	xfs_da_state_t		*state;		/* btree cursor */
-
-	trace_xfs_dir2_node_addname(args);
-
-	/*
-	 * Allocate and initialize the state (btree cursor).
-	 */
-	state = xfs_da_state_alloc();
-	state->args = args;
-	state->mp = args->dp->i_mount;
-	/*
-	 * Look up the name.  We're not supposed to find it, but
-	 * this gives us the insertion point.
-	 */
-	error = xfs_da3_node_lookup_int(state, &rval);
-	if (error)
-		rval = error;
-	if (rval != -ENOENT) {
-		goto done;
-	}
-	/*
-	 * Add the data entry to a data block.
-	 * Extravalid is set to a freeblock found by lookup.
-	 */
-	rval = xfs_dir2_node_addname_int(args,
-		state->extravalid ? &state->extrablk : NULL);
-	if (rval) {
-		goto done;
-	}
-	blk = &state->path.blk[state->path.active - 1];
-	ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
-	/*
-	 * Add the new leaf entry.
-	 */
-	rval = xfs_dir2_leafn_add(blk->bp, args, blk->index);
-	if (rval == 0) {
-		/*
-		 * It worked, fix the hash values up the btree.
-		 */
-		if (!(args->op_flags & XFS_DA_OP_JUSTCHECK))
-			xfs_da3_fixhashpath(state, &state->path);
-	} else {
-		/*
-		 * It didn't work, we need to split the leaf block.
-		 */
-		if (args->total == 0) {
-			ASSERT(rval == -ENOSPC);
-			goto done;
-		}
-		/*
-		 * Split the leaf block and insert the new entry.
-		 */
-		rval = xfs_da3_split(state);
-	}
-done:
-	xfs_da_state_free(state);
-	return rval;
-}
-
 /*
  * Add the data entry for a node-format directory name addition.
  * The leaf entry is added in xfs_dir2_leafn_add.
@@ -2056,6 +1985,75 @@ xfs_dir2_node_addname_int(
 	return 0;
 }
 
+/*
+ * Top-level node form directory addname routine.
+ */
+int						/* error */
+xfs_dir2_node_addname(
+	xfs_da_args_t		*args)		/* operation arguments */
+{
+	xfs_da_state_blk_t	*blk;		/* leaf block for insert */
+	int			error;		/* error return value */
+	int			rval;		/* sub-return value */
+	xfs_da_state_t		*state;		/* btree cursor */
+
+	trace_xfs_dir2_node_addname(args);
+
+	/*
+	 * Allocate and initialize the state (btree cursor).
+	 */
+	state = xfs_da_state_alloc();
+	state->args = args;
+	state->mp = args->dp->i_mount;
+	/*
+	 * Look up the name.  We're not supposed to find it, but
+	 * this gives us the insertion point.
+	 */
+	error = xfs_da3_node_lookup_int(state, &rval);
+	if (error)
+		rval = error;
+	if (rval != -ENOENT) {
+		goto done;
+	}
+	/*
+	 * Add the data entry to a data block.
+	 * Extravalid is set to a freeblock found by lookup.
+	 */
+	rval = xfs_dir2_node_addname_int(args,
+		state->extravalid ? &state->extrablk : NULL);
+	if (rval) {
+		goto done;
+	}
+	blk = &state->path.blk[state->path.active - 1];
+	ASSERT(blk->magic == XFS_DIR2_LEAFN_MAGIC);
+	/*
+	 * Add the new leaf entry.
+	 */
+	rval = xfs_dir2_leafn_add(blk->bp, args, blk->index);
+	if (rval == 0) {
+		/*
+		 * It worked, fix the hash values up the btree.
+		 */
+		if (!(args->op_flags & XFS_DA_OP_JUSTCHECK))
+			xfs_da3_fixhashpath(state, &state->path);
+	} else {
+		/*
+		 * It didn't work, we need to split the leaf block.
+		 */
+		if (args->total == 0) {
+			ASSERT(rval == -ENOSPC);
+			goto done;
+		}
+		/*
+		 * Split the leaf block and insert the new entry.
+		 */
+		rval = xfs_da3_split(state);
+	}
+done:
+	xfs_da_state_free(state);
+	return rval;
+}
+
 /*
  * Lookup an entry in a node-format directory.
  * All the real work happens in xfs_da3_node_lookup_int.
-- 
2.23.0.rc1

