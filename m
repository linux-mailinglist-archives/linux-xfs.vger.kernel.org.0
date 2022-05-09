Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743A251F24E
	for <lists+linux-xfs@lfdr.de>; Mon,  9 May 2022 03:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbiEIBal (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 8 May 2022 21:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiEIApi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 May 2022 20:45:38 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04DB46430
        for <linux-xfs@vger.kernel.org>; Sun,  8 May 2022 17:41:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2C12F10E6407
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 10:41:42 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nnrT2-009hda-Lk
        for linux-xfs@vger.kernel.org; Mon, 09 May 2022 10:41:40 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nnrT2-003CQH-KY
        for linux-xfs@vger.kernel.org;
        Mon, 09 May 2022 10:41:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 17/18] xfs: ATTR_REPLACE algorithm with LARP enabled needs rework
Date:   Mon,  9 May 2022 10:41:37 +1000
Message-Id: <20220509004138.762556-18-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509004138.762556-1-david@fromorbit.com>
References: <20220509004138.762556-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62786346
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=8u-lSLDIrFwSWhHH7igA:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We can't use the same algorithm for replacing an existing attribute
when logging attributes. The existing algorithm is essentially:

1. create new attr w/ INCOMPLETE
2. atomically flip INCOMPLETE flags between old + new attribute
3. remove old attr which is marked w/ INCOMPLETE

This algorithm guarantees that we see either the old or new
attribute, and if we fail after the atomic flag flip, we don't have
to recover the removal of the old attr because we never see
INCOMPLETE attributes in lookups.

For logged attributes, however, this does not work. The logged
attribute intents do not track the work that has been done as the
transaction rolls, and hence the only recovery mechanism we have is
"run the replace operation from scratch".

This is further exacerbated by the attempt to avoid needing the
INCOMPLETE flag to create an atomic swap. This means we can create
a second active attribute of the same name before we remove the
original. If we fail at any point after the create but before the
removal has completed, we end up with duplicate attributes in
the attr btree and recovery only tries to replace one of them.

There are several other failure modes where we can leave partially
allocated remote attributes that expose stale data, partially free
remote attributes that enable UAF based stale data exposure, etc.

TO fix this, we need a different algorithm for replace operations
when LARP is enabled. Luckily, it's not that complex if we take the
right first step. That is, the first thing we log is the attri
intent with the new name/value pair and mark the old attr as
INCOMPLETE in the same transaction.

From there, we then remove the old attr and keep relogging the
new name/value in the intent, such that we always know that we have
to create the new attr in recovery. Once the old attr is removed,
we then run a normal ATTR_CREATE operation relogging the intent as
we go. If the new attr is local, then it gets created in a single
atomic transaction that also logs the final intent done. If the new
attr is remote, the we set INCOMPLETE on the new attr while we
allocate and set the remote value, and then we clear the INCOMPLETE
flag at in the last transaction taht logs the final intent done.

If we fail at any point in this algorithm, log recovery will always
see the same state on disk: the new name/value in the intent, and
either an INCOMPLETE attr or no attr in the attr btree. If we find
an INCOMPLETE attr, we run the full replace starting with removing
the INCOMPLETE attr. If we don't find it, then we simply create the
new attr.

Notably, recovery of a failed create that has an INCOMPLETE flag set
is now the same - we start with the lookup of the INCOMPLETE attr,
and if that exists then we do the full replace recovery process,
otherwise we just create the new attr.

Hence changing the way we do the replace operation when LARP is
enabled allows us to use the same log recovery algorithm for both
the ATTR_CREATE and ATTR_REPLACE operations. This is also the same
algorithm we use for runtime ATTR_REPLACE operations (except for the
step setting up the initial conditions).

The result is that:

- ATTR_CREATE uses the same algorithm regardless of whether LARP is
  enabled or not
- ATTR_REPLACE with larp=0 is identical to the old algorithm
- ATTR_REPLACE with larp=1 runs an unmodified attr removal algorithm
  from the larp=0 code and then runs the unmodified ATTR_CREATE
  code.
- log recovery when larp=1 runs the same ATTR_REPLACE algorithm as
  it uses at runtime.

Because the state machine is now quite clean, changing the algorithm
is really just a case of changing the initial state and how the
states link together for the ATTR_REPLACE case. Hence it's not a
huge amoutn of code for what is a fairly substantial rework
of the attr logging and recovery algorithm....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 97 +++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_attr.h      | 49 +++++++++++-------
 fs/xfs/libxfs/xfs_attr_leaf.c | 44 +++++++++++++---
 fs/xfs/libxfs/xfs_da_btree.h  |  4 +-
 fs/xfs/xfs_attr_item.c        |  8 ++-
 fs/xfs/xfs_trace.h            |  7 +--
 6 files changed, 137 insertions(+), 72 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 344497e37813..2f6b9bfd7768 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -69,9 +69,12 @@ int
 xfs_inode_hasattr(
 	struct xfs_inode	*ip)
 {
-	if (!XFS_IFORK_Q(ip) ||
-	    (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
-	     ip->i_afp->if_nextents == 0))
+	if (!XFS_IFORK_Q(ip))
+		return 0;
+	if (!ip->i_afp)
+		return 0;
+	if (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
+	    ip->i_afp->if_nextents == 0)
 		return 0;
 	return 1;
 }
@@ -409,23 +412,30 @@ xfs_attr_sf_addname(
 }
 
 /*
- * When we bump the state to REPLACE, we may actually need to skip over the
- * state. When LARP mode is enabled, we don't need to run the atomic flags flip,
- * so we skip straight over the REPLACE state and go on to REMOVE_OLD.
+ * Handle the state change on completion of a multi-state attr operation.
+ *
+ * If the XFS_DA_OP_REPLACE flag is set, this means the operation was the first
+ * modification in a attr replace operation and we still have to do the second
+ * state, indicated by @replace_state.
+ *
+ * We consume the XFS_DA_OP_REPLACE flag so that when we are called again on
+ * completion of the second half of the attr replace operation we correctly
+ * signal that it is done.
  */
-static void
-xfs_attr_dela_state_set_replace(
+static enum xfs_delattr_state
+xfs_attr_complete_op(
 	struct xfs_attr_item	*attr,
-	enum xfs_delattr_state	replace)
+	enum xfs_delattr_state	replace_state)
 {
 	struct xfs_da_args	*args = attr->xattri_da_args;
+	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
-	ASSERT(replace == XFS_DAS_LEAF_REPLACE ||
-			replace == XFS_DAS_NODE_REPLACE);
-
-	attr->xattri_dela_state = replace;
-	if (xfs_has_larp(args->dp->i_mount))
-		attr->xattri_dela_state++;
+	args->op_flags &= ~XFS_DA_OP_REPLACE;
+	if (do_replace) {
+		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+		return replace_state;
+	}
+	return XFS_DAS_DONE;
 }
 
 static int
@@ -467,10 +477,9 @@ xfs_attr_leaf_addname(
 	 */
 	if (args->rmtblkno)
 		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
-	else if (args->op_flags & XFS_DA_OP_REPLACE)
-		xfs_attr_dela_state_set_replace(attr, XFS_DAS_LEAF_REPLACE);
 	else
-		attr->xattri_dela_state = XFS_DAS_DONE;
+		attr->xattri_dela_state = xfs_attr_complete_op(attr,
+							XFS_DAS_LEAF_REPLACE);
 out:
 	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
 	return error;
@@ -512,10 +521,9 @@ xfs_attr_node_addname(
 
 	if (args->rmtblkno)
 		attr->xattri_dela_state = XFS_DAS_NODE_SET_RMT;
-	else if (args->op_flags & XFS_DA_OP_REPLACE)
-		xfs_attr_dela_state_set_replace(attr, XFS_DAS_NODE_REPLACE);
 	else
-		attr->xattri_dela_state = XFS_DAS_DONE;
+		attr->xattri_dela_state = xfs_attr_complete_op(attr,
+							XFS_DAS_NODE_REPLACE);
 out:
 	trace_xfs_attr_node_addname_return(attr->xattri_dela_state, args->dp);
 	return error;
@@ -547,18 +555,15 @@ xfs_attr_rmtval_alloc(
 	if (error)
 		return error;
 
-	/* If this is not a rename, clear the incomplete flag and we're done. */
-	if (!(args->op_flags & XFS_DA_OP_REPLACE)) {
+	attr->xattri_dela_state = xfs_attr_complete_op(attr,
+						++attr->xattri_dela_state);
+	/*
+	 * If we are not doing a rename, we've finished the operation but still
+	 * have to clear the incomplete flag protecting the new attr from
+	 * exposing partially initialised state if we crash during creation.
+	 */
+	if (attr->xattri_dela_state == XFS_DAS_DONE)
 		error = xfs_attr3_leaf_clearflag(args);
-		attr->xattri_dela_state = XFS_DAS_DONE;
-	} else {
-		/*
-		 * We are running a REPLACE operation, so we need to bump the
-		 * state to the step in that operation.
-		 */
-		attr->xattri_dela_state++;
-		xfs_attr_dela_state_set_replace(attr, attr->xattri_dela_state);
-	}
 out:
 	trace_xfs_attr_rmtval_alloc(attr->xattri_dela_state, args->dp);
 	return error;
@@ -715,13 +720,24 @@ xfs_attr_set_iter(
 		return xfs_attr_node_addname(attr);
 
 	case XFS_DAS_SF_REMOVE:
-		attr->xattri_dela_state = XFS_DAS_DONE;
-		return xfs_attr_sf_removename(args);
+		error = xfs_attr_sf_removename(args);
+		attr->xattri_dela_state = xfs_attr_complete_op(attr,
+						xfs_attr_init_add_state(args));
+		break;
 	case XFS_DAS_LEAF_REMOVE:
-		attr->xattri_dela_state = XFS_DAS_DONE;
-		return xfs_attr_leaf_removename(args);
+		error = xfs_attr_leaf_removename(args);
+		attr->xattri_dela_state = xfs_attr_complete_op(attr,
+						xfs_attr_init_add_state(args));
+		break;
 	case XFS_DAS_NODE_REMOVE:
 		error = xfs_attr_node_removename_setup(attr);
+		if (error == -ENOATTR &&
+		    (args->op_flags & XFS_DA_OP_RECOVERY)) {
+			attr->xattri_dela_state = xfs_attr_complete_op(attr,
+						xfs_attr_init_add_state(args));
+			error = 0;
+			break;
+		}
 		if (error)
 			return error;
 		attr->xattri_dela_state = XFS_DAS_NODE_REMOVE_RMT;
@@ -807,14 +823,16 @@ xfs_attr_set_iter(
 
 	case XFS_DAS_LEAF_REMOVE_ATTR:
 		error = xfs_attr_leaf_remove_attr(attr);
-		attr->xattri_dela_state = XFS_DAS_DONE;
+		attr->xattri_dela_state = xfs_attr_complete_op(attr,
+						xfs_attr_init_add_state(args));
 		break;
 
 	case XFS_DAS_NODE_REMOVE_ATTR:
 		error = xfs_attr_node_remove_attr(attr);
 		if (!error)
 			error = xfs_attr_leaf_shrink(args);
-		attr->xattri_dela_state = XFS_DAS_DONE;
+		attr->xattri_dela_state = xfs_attr_complete_op(attr,
+						xfs_attr_init_add_state(args));
 		break;
 	default:
 		ASSERT(0);
@@ -1316,9 +1334,10 @@ xfs_attr_leaf_removename(
 	dp = args->dp;
 
 	error = xfs_attr_leaf_hasname(args, &bp);
-
 	if (error == -ENOATTR) {
 		xfs_trans_brelse(args->trans, bp);
+		if (args->op_flags & XFS_DA_OP_RECOVERY)
+			return 0;
 		return error;
 	} else if (error != -EEXIST)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index e93efc8b11cd..7467d31cb3f1 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -444,18 +444,23 @@ struct xfs_attr_list_context {
  */
 enum xfs_delattr_state {
 	XFS_DAS_UNINIT		= 0,	/* No state has been set yet */
-	XFS_DAS_SF_ADD,			/* Initial shortform set iter state */
-	XFS_DAS_LEAF_ADD,		/* Initial leaf form set iter state */
-	XFS_DAS_NODE_ADD,		/* Initial node form set iter state */
-	XFS_DAS_RMTBLK,			/* Removing remote blks */
-	XFS_DAS_RM_NAME,		/* Remove attr name */
-	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree */
-
-	XFS_DAS_SF_REMOVE,		/* Initial shortform set iter state */
-	XFS_DAS_LEAF_REMOVE,		/* Initial leaf form set iter state */
-	XFS_DAS_NODE_REMOVE,		/* Initial node form set iter state */
-
-	/* Leaf state set/replace sequence */
+
+	/*
+	 * Initial sequence states. The replace setup code relies on the
+	 * ADD and REMOVE states for a specific format to be sequential so
+	 * that we can transform the initial operation to be performed
+	 * according to the xfs_has_larp() state easily.
+	 */
+	XFS_DAS_SF_ADD,			/* Initial sf add state */
+	XFS_DAS_SF_REMOVE,		/* Initial sf replace/remove state */
+
+	XFS_DAS_LEAF_ADD,		/* Initial leaf add state */
+	XFS_DAS_LEAF_REMOVE,		/* Initial leaf replace/remove state */
+
+	XFS_DAS_NODE_ADD,		/* Initial node add state */
+	XFS_DAS_NODE_REMOVE,		/* Initial node replace/remove state */
+
+	/* Leaf state set/replace/remove sequence */
 	XFS_DAS_LEAF_SET_RMT,		/* set a remote xattr from a leaf */
 	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote blocks */
 	XFS_DAS_LEAF_REPLACE,		/* Perform replace ops on a leaf */
@@ -463,7 +468,7 @@ enum xfs_delattr_state {
 	XFS_DAS_LEAF_REMOVE_RMT,	/* A rename is removing remote blocks */
 	XFS_DAS_LEAF_REMOVE_ATTR,	/* Remove the old attr from a leaf */
 
-	/* Node state set/replace sequence, must match leaf state above */
+	/* Node state sequence, must match leaf state above */
 	XFS_DAS_NODE_SET_RMT,		/* set a remote xattr from a node */
 	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote blocks */
 	XFS_DAS_NODE_REPLACE,		/* Perform replace ops on a node */
@@ -477,11 +482,11 @@ enum xfs_delattr_state {
 #define XFS_DAS_STRINGS	\
 	{ XFS_DAS_UNINIT,		"XFS_DAS_UNINIT" }, \
 	{ XFS_DAS_SF_ADD,		"XFS_DAS_SF_ADD" }, \
+	{ XFS_DAS_SF_REMOVE,		"XFS_DAS_SF_REMOVE" }, \
 	{ XFS_DAS_LEAF_ADD,		"XFS_DAS_LEAF_ADD" }, \
+	{ XFS_DAS_LEAF_REMOVE,		"XFS_DAS_LEAF_REMOVE" }, \
 	{ XFS_DAS_NODE_ADD,		"XFS_DAS_NODE_ADD" }, \
-	{ XFS_DAS_RMTBLK,		"XFS_DAS_RMTBLK" }, \
-	{ XFS_DAS_RM_NAME,		"XFS_DAS_RM_NAME" }, \
-	{ XFS_DAS_RM_SHRINK,		"XFS_DAS_RM_SHRINK" }, \
+	{ XFS_DAS_NODE_REMOVE,		"XFS_DAS_NODE_REMOVE" }, \
 	{ XFS_DAS_LEAF_SET_RMT,		"XFS_DAS_LEAF_SET_RMT" }, \
 	{ XFS_DAS_LEAF_ALLOC_RMT,	"XFS_DAS_LEAF_ALLOC_RMT" }, \
 	{ XFS_DAS_LEAF_REPLACE,		"XFS_DAS_LEAF_REPLACE" }, \
@@ -525,8 +530,7 @@ struct xfs_attr_item {
 	enum xfs_delattr_state		xattri_dela_state;
 
 	/*
-	 * Indicates if the attr operation is a set or a remove
-	 * XFS_ATTR_OP_FLAGS_{SET,REMOVE}
+	 * Attr operation being performed - XFS_ATTR_OP_FLAGS_*
 	 */
 	unsigned int			xattri_op_flags;
 
@@ -605,10 +609,19 @@ xfs_attr_init_remove_state(struct xfs_da_args *args)
 	return XFS_DAS_NODE_REMOVE;
 }
 
+/*
+ * If we are logging the attributes, then we have to start with removal of the
+ * old attribute so that there is always consistent state that we can recover
+ * from if the system goes down part way through. We always log the new attr
+ * value, so even when we remove the attr first we still have the information in
+ * the log to finish the replace operation atomically.
+ */
 static inline enum xfs_delattr_state
 xfs_attr_init_replace_state(struct xfs_da_args *args)
 {
 	args->op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
+	if (xfs_has_larp(args->dp->i_mount))
+		return xfs_attr_init_remove_state(args);
 	return xfs_attr_init_add_state(args);
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 53d02ce9ed78..d15e92858bf0 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -446,6 +446,14 @@ xfs_attr3_leaf_read(
  * Namespace helper routines
  *========================================================================*/
 
+/*
+ * If we are in log recovery, then we want the lookup to ignore the INCOMPLETE
+ * flag on disk - if there's an incomplete attr then recovery needs to tear it
+ * down. If there's no incomplete attr, then recovery needs to tear that attr
+ * down to replace it with the attr that has been logged. In this case, the
+ * INCOMPLETE flag will not be set in attr->attr_filter, but rather
+ * XFS_DA_OP_RECOVERY will be set in args->op_flags.
+ */
 static bool
 xfs_attr_match(
 	struct xfs_da_args	*args,
@@ -453,14 +461,18 @@ xfs_attr_match(
 	unsigned char		*name,
 	int			flags)
 {
+
 	if (args->namelen != namelen)
 		return false;
 	if (memcmp(args->name, name, namelen) != 0)
 		return false;
-	/*
-	 * If we are looking for incomplete entries, show only those, else only
-	 * show complete entries.
-	 */
+
+	/* Recovery ignores the INCOMPLETE flag. */
+	if ((args->op_flags & XFS_DA_OP_RECOVERY) &&
+	    args->attr_filter == (flags & XFS_ATTR_NSP_ONDISK_MASK))
+		return true;
+
+	/* All remaining matches need to be filtered by INCOMPLETE state. */
 	if (args->attr_filter !=
 	    (flags & (XFS_ATTR_NSP_ONDISK_MASK | XFS_ATTR_INCOMPLETE)))
 		return false;
@@ -799,6 +811,14 @@ xfs_attr_sf_removename(
 	sf = (struct xfs_attr_shortform *)dp->i_afp->if_u1.if_data;
 
 	error = xfs_attr_sf_findname(args, &sfe, &base);
+
+	/*
+	 * If we are recovering an operation, finding nothing to
+	 * remove is not an error - it just means there was nothing
+	 * to clean up.
+	 */
+	if (error == -ENOATTR && (args->op_flags & XFS_DA_OP_RECOVERY))
+		return 0;
 	if (error != -EEXIST)
 		return error;
 	size = xfs_attr_sf_entsize(sfe);
@@ -819,7 +839,7 @@ xfs_attr_sf_removename(
 	totsize -= size;
 	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
-	    !(args->op_flags & XFS_DA_OP_ADDNAME)) {
+	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
 		xfs_attr_fork_remove(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
@@ -1128,9 +1148,17 @@ xfs_attr3_leaf_to_shortform(
 		goto out;
 
 	if (forkoff == -1) {
-		ASSERT(xfs_has_attr2(dp->i_mount));
-		ASSERT(dp->i_df.if_format != XFS_DINODE_FMT_BTREE);
-		xfs_attr_fork_remove(dp, args->trans);
+		/*
+		 * Don't remove the attr fork if this operation is the first
+		 * part of a attr replace operations. We're going to add a new
+		 * attr immediately, so we need to keep the attr fork around in
+		 * this case.
+		 */
+		if (!(args->op_flags & XFS_DA_OP_REPLACE)) {
+			ASSERT(xfs_has_attr2(dp->i_mount));
+			ASSERT(dp->i_df.if_format != XFS_DINODE_FMT_BTREE);
+			xfs_attr_fork_remove(dp, args->trans);
+		}
 		goto out;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 468ca70cd35d..ed2303e4d46a 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -91,6 +91,7 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if found */
 #define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode timestamps */
 #define XFS_DA_OP_REMOVE	(1u << 6) /* this is a remove operation */
+#define XFS_DA_OP_RECOVERY	(1u << 7) /* Log recovery operation */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -99,7 +100,8 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
 	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
-	{ XFS_DA_OP_REMOVE,	"REMOVE" }
+	{ XFS_DA_OP_REMOVE,	"REMOVE" }, \
+	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }
 
 /*
  * Storage for holding state during Btree searches and split/join ops.
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index fb9549e7ea96..50ad3aa891ee 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -554,6 +554,7 @@ xfs_attri_item_recover(
 	args->namelen = attrp->alfi_name_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	args->attr_filter = attrp->alfi_attr_flags;
+	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT;
 
 	switch (attrp->alfi_op_flags & XFS_ATTR_OP_FLAGS_TYPE_MASK) {
 	case XFS_ATTR_OP_FLAGS_SET:
@@ -561,9 +562,14 @@ xfs_attri_item_recover(
 		args->value = attrip->attri_value;
 		args->valuelen = attrp->alfi_value_len;
 		args->total = xfs_attr_calc_size(args, &local);
-		attr->xattri_dela_state = xfs_attr_init_add_state(args);
+		if (xfs_inode_hasattr(args->dp))
+			attr->xattri_dela_state = xfs_attr_init_replace_state(args);
+		else
+			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
+		if (!xfs_inode_hasattr(args->dp))
+			goto out;
 		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
 	default:
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 01b047d86cd1..d32026585c1b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4131,13 +4131,10 @@ DEFINE_ICLOG_EVENT(xlog_iclog_write);
 
 TRACE_DEFINE_ENUM(XFS_DAS_UNINIT);
 TRACE_DEFINE_ENUM(XFS_DAS_SF_ADD);
-TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ADD);
-TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
-TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
-TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
-TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
 TRACE_DEFINE_ENUM(XFS_DAS_SF_REMOVE);
+TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ADD);
 TRACE_DEFINE_ENUM(XFS_DAS_LEAF_REMOVE);
+TRACE_DEFINE_ENUM(XFS_DAS_NODE_ADD);
 TRACE_DEFINE_ENUM(XFS_DAS_NODE_REMOVE);
 TRACE_DEFINE_ENUM(XFS_DAS_LEAF_SET_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
-- 
2.35.1

