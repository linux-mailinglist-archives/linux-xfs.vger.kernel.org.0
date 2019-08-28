Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 349369F927
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Aug 2019 06:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbfH1EX6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Aug 2019 00:23:58 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:40582 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725845AbfH1EX6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Aug 2019 00:23:58 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B21EF360F61
        for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2019 14:23:54 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2pUu-0004w3-Ey
        for linux-xfs@vger.kernel.org; Wed, 28 Aug 2019 14:23:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i2pUu-0001hB-D3
        for linux-xfs@vger.kernel.org; Wed, 28 Aug 2019 14:23:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: make attr lookup returns consistent
Date:   Wed, 28 Aug 2019 14:23:48 +1000
Message-Id: <20190828042350.6062-2-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190828042350.6062-1-david@fromorbit.com>
References: <20190828042350.6062-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=FmdZ9Uzk2mMA:10 a=20KFwNOVAAAA:8
        a=2rkUnB5OLu6SpcLelQQA:9 a=1lUyxkfduuxLte-5:21 a=hfN7gNNjMeXmDZ5u:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Shortform, leaf and remote value attr value retrieval return
different values for success. This makes it more complex to handle
actual errors xfs_attr_get() as some errors mean success and some
mean failure. Make the return values consistent for success and
failure consistent for all attribute formats.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 57 +++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_attr_leaf.c   | 15 ++++++---
 fs/xfs/libxfs/xfs_attr_remote.c |  2 ++
 fs/xfs/scrub/attr.c             |  2 --
 4 files changed, 49 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d48fcf11cc35..776343c4f22b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -97,7 +97,10 @@ xfs_inode_hasattr(
  * Overall external interface routines.
  *========================================================================*/
 
-/* Retrieve an extended attribute and its value.  Must have ilock. */
+/*
+ * Retrieve an extended attribute and its value.  Must have ilock.
+ * Returns 0 on successful retrieval, otherwise an error.
+ */
 int
 xfs_attr_get_ilocked(
 	struct xfs_inode	*ip,
@@ -147,7 +150,7 @@ xfs_attr_get(
 	xfs_iunlock(ip, lock_mode);
 
 	*valuelenp = args.valuelen;
-	return error == -EEXIST ? 0 : error;
+	return error;
 }
 
 /*
@@ -768,6 +771,8 @@ xfs_attr_leaf_removename(
  *
  * This leaf block cannot have a "remote" value, we only call this routine
  * if bmap_one_block() says there is only one block (ie: no remote blks).
+ *
+ * Returns 0 on successful retrieval, otherwise an error.
  */
 STATIC int
 xfs_attr_leaf_get(xfs_da_args_t *args)
@@ -789,10 +794,15 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
 	}
 	error = xfs_attr3_leaf_getvalue(bp, args);
 	xfs_trans_brelse(args->trans, bp);
-	if (!error && (args->rmtblkno > 0) && !(args->flags & ATTR_KERNOVAL)) {
-		error = xfs_attr_rmtval_get(args);
-	}
-	return error;
+	if (error)
+		return error;
+
+	/* check if we have to retrieve a remote attribute to get the value */
+	if (args->flags & ATTR_KERNOVAL)
+		return 0;
+	if (!args->rmtblkno)
+		return 0;
+	return xfs_attr_rmtval_get(args);
 }
 
 /*========================================================================
@@ -1268,11 +1278,13 @@ xfs_attr_refillstate(xfs_da_state_t *state)
 }
 
 /*
- * Look up a filename in a node attribute list.
+ * Retreive the attribute data from a node attribute list.
  *
  * This routine gets called for any attribute fork that has more than one
  * block, ie: both true Btree attr lists and for single-leaf-blocks with
  * "remote" values taking up more blocks.
+ *
+ * Returns 0 on successful retrieval, otherwise an error.
  */
 STATIC int
 xfs_attr_node_get(xfs_da_args_t *args)
@@ -1289,29 +1301,32 @@ xfs_attr_node_get(xfs_da_args_t *args)
 	state->mp = args->dp->i_mount;
 
 	/*
-	 * Search to see if name exists, and get back a pointer to it.
+	  Search to see if name exists, and get back a pointer to it.
 	 */
 	error = xfs_da3_node_lookup_int(state, &retval);
 	if (error) {
 		retval = error;
-	} else if (retval == -EEXIST) {
-		blk = &state->path.blk[ state->path.active-1 ];
-		ASSERT(blk->bp != NULL);
-		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-
-		/*
-		 * Get the value, local or "remote"
-		 */
-		retval = xfs_attr3_leaf_getvalue(blk->bp, args);
-		if (!retval && (args->rmtblkno > 0)
-		    && !(args->flags & ATTR_KERNOVAL)) {
-			retval = xfs_attr_rmtval_get(args);
-		}
+		goto out_release;
 	}
+	if (retval != -EEXIST)
+		goto out_release;
+
+	/*
+	 * Get the value, local or "remote"
+	 */
+	blk = &state->path.blk[state->path.active - 1];
+	retval = xfs_attr3_leaf_getvalue(blk->bp, args);
+	if (retval)
+		goto out_release;
+	if (args->flags & ATTR_KERNOVAL)
+		goto out_release;
+	if (args->rmtblkno > 0)
+		retval = xfs_attr_rmtval_get(args);
 
 	/*
 	 * If not in a transaction, we have to release all the buffers.
 	 */
+out_release:
 	for (i = 0; i < state->path.active; i++) {
 		xfs_trans_brelse(args->trans, state->path.blk[i].bp);
 		state->path.blk[i].bp = NULL;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 70eb941d02e4..d056767b5c53 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -720,9 +720,12 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 }
 
 /*
- * Look up a name in a shortform attribute list structure.
+ * Retreive the attribute value and length.
+ *
+ * If ATTR_KERNOVAL is specified, only the length needs to be returned.
+ * Unlike a lookup, we only return an error if the attribute does not
+ * exist or we can't retrieve the value.
  */
-/*ARGSUSED*/
 int
 xfs_attr_shortform_getvalue(xfs_da_args_t *args)
 {
@@ -743,7 +746,7 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
 			continue;
 		if (args->flags & ATTR_KERNOVAL) {
 			args->valuelen = sfe->valuelen;
-			return -EEXIST;
+			return 0;
 		}
 		if (args->valuelen < sfe->valuelen) {
 			args->valuelen = sfe->valuelen;
@@ -752,7 +755,7 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
 		args->valuelen = sfe->valuelen;
 		memcpy(args->value, &sfe->nameval[args->namelen],
 						    args->valuelen);
-		return -EEXIST;
+		return 0;
 	}
 	return -ENOATTR;
 }
@@ -2350,6 +2353,10 @@ xfs_attr3_leaf_lookup_int(
 /*
  * Get the value associated with an attribute name from a leaf attribute
  * list structure.
+ *
+ * If ATTR_KERNOVAL is specified, only the length needs to be returned.
+ * Unlike a lookup, we only return an error if the attribute does not
+ * exist or we can't retrieve the value.
  */
 int
 xfs_attr3_leaf_getvalue(
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 4eb30d357045..3e39b7d40f25 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -358,6 +358,8 @@ xfs_attr_rmtval_copyin(
 /*
  * Read the value associated with an attribute from the out-of-line buffer
  * that we stored it in.
+ *
+ * Returns 0 on successful retrieval, otherwise an error.
  */
 int
 xfs_attr_rmtval_get(
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 1afc58bf71dd..e9248ad4f842 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -163,8 +163,6 @@ xchk_xattr_listent(
 	args.valuelen = valuelen;
 
 	error = xfs_attr_get_ilocked(context->dp, &args);
-	if (error == -EEXIST)
-		error = 0;
 	if (!xchk_fblock_process_error(sx->sc, XFS_ATTR_FORK, args.blkno,
 			&error))
 		goto fail_xref;
-- 
2.23.0.rc1

