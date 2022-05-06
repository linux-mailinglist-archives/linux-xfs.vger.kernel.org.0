Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCDE51D4F3
	for <lists+linux-xfs@lfdr.de>; Fri,  6 May 2022 11:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390693AbiEFJty (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 6 May 2022 05:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390705AbiEFJtp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 05:49:45 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D5A866F93
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 02:46:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AC4E6534628
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 19:45:58 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nmuX7-008fMw-2H
        for linux-xfs@vger.kernel.org; Fri, 06 May 2022 19:45:57 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nmuX7-0029U1-1R
        for linux-xfs@vger.kernel.org;
        Fri, 06 May 2022 19:45:57 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 16/17] xfs: use XFS_DA_OP flags in deferred attr ops
Date:   Fri,  6 May 2022 19:45:52 +1000
Message-Id: <20220506094553.512973-17-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506094553.512973-1-david@fromorbit.com>
References: <20220506094553.512973-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6274ee56
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=HRovyBK22kfqqKvAjg4A:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We currently store the high level attr operation in
args->attr_flags. This falgs are what the VFS is telling us to do,
but don't necessarily match what we are doing in the low level
modification state machine. e.g. XATTR_REPLACE implies both
XFS_DA_OP_ADDNAME and XFS_DA_OP_RENAME because it is doing both a
remove and adding a new attr.

However, deep in the individual state machine operations, we check
errors against this high level VFS op flags, not the low level
XFS_DA_OP flags. Indeed, we don't even have a low level flag for
a REMOVE operation, so the only way we know we are doing a remove
is the complete absence of XATTR_REPLACE, XATTR_CREATE,
XFS_DA_OP_ADDNAME and XFS_DA_OP_RENAME. And because there are other
flags in these fields, this is a pain to check if we need to.

As the XFS_DA_OP flags are only needed once the deferred operations
are set up, set these flags appropriately when we set the initial
operation state. We also introduce a XFS_DA_OP_REMOVE flag to make
it easy to know that we are doing a remove operation.

With these, we can remove the use of XATTR_REPLACE and XATTR_CREATE
in low level lookup operations, and manipulate the low level flags
according to the low level context that is operating. e.g. log
recovery does not have a VFS xattr operation state to copy into
args->attr_flags, and the low level state machine ops we do for
recovery do not match the high level VFS operations that were in
progress when the system failed...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 124 +++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr.h      |   3 +
 fs/xfs/libxfs/xfs_attr_leaf.c |   2 +-
 fs/xfs/libxfs/xfs_da_btree.h  |   9 ++-
 4 files changed, 78 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index c326fb2f5417..546e17574488 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -469,7 +469,7 @@ xfs_attr_leaf_addname(
 	 */
 	if (args->rmtblkno)
 		attr->xattri_dela_state = XFS_DAS_LEAF_SET_RMT;
-	else if (args->op_flags & XFS_DA_OP_RENAME)
+	else if (args->op_flags & XFS_DA_OP_REPLACE)
 		xfs_attr_dela_state_set_replace(attr, XFS_DAS_LEAF_REPLACE);
 	else
 		attr->xattri_dela_state = XFS_DAS_DONE;
@@ -514,7 +514,7 @@ xfs_attr_node_addname(
 
 	if (args->rmtblkno)
 		attr->xattri_dela_state = XFS_DAS_NODE_SET_RMT;
-	else if (args->op_flags & XFS_DA_OP_RENAME)
+	else if (args->op_flags & XFS_DA_OP_REPLACE)
 		xfs_attr_dela_state_set_replace(attr, XFS_DAS_NODE_REPLACE);
 	else
 		attr->xattri_dela_state = XFS_DAS_DONE;
@@ -550,7 +550,7 @@ xfs_attr_rmtval_alloc(
 		return error;
 
 	/* If this is not a rename, clear the incomplete flag and we're done. */
-	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
+	if (!(args->op_flags & XFS_DA_OP_REPLACE)) {
 		error = xfs_attr3_leaf_clearflag(args);
 		attr->xattri_dela_state = XFS_DAS_DONE;
 	} else {
@@ -935,8 +935,6 @@ xfs_attr_set(
 
 	if (args->value) {
 		XFS_STATS_INC(mp, xs_attr_set);
-
-		args->op_flags |= XFS_DA_OP_ADDNAME;
 		args->total = xfs_attr_calc_size(args, &local);
 
 		/*
@@ -1094,28 +1092,41 @@ static inline int xfs_attr_sf_totsize(struct xfs_inode *dp)
  * Add a name to the shortform attribute list structure
  * This is the external routine.
  */
-STATIC int
-xfs_attr_shortform_addname(xfs_da_args_t *args)
+static int
+xfs_attr_shortform_addname(
+	struct xfs_da_args	*args)
 {
-	int newsize, forkoff, retval;
+	int			newsize, forkoff;
+	int			error;
 
 	trace_xfs_attr_sf_addname(args);
 
-	retval = xfs_attr_shortform_lookup(args);
-	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
-		return retval;
-	if (retval == -EEXIST) {
-		if (args->attr_flags & XATTR_CREATE)
-			return retval;
-		retval = xfs_attr_sf_removename(args);
-		if (retval)
-			return retval;
+	error = xfs_attr_shortform_lookup(args);
+	switch (error) {
+	case -ENOATTR:
+		if (args->op_flags & XFS_DA_OP_REPLACE)
+			return error;
+		break;
+	case -EEXIST:
+		if (!(args->op_flags & XFS_DA_OP_REPLACE))
+			return error;
+
+		error = xfs_attr_sf_removename(args);
+		if (error)
+			return error;
+
 		/*
-		 * Since we have removed the old attr, clear ATTR_REPLACE so
-		 * that the leaf format add routine won't trip over the attr
-		 * not being around.
+		 * Since we have removed the old attr, clear XFS_DA_OP_REPLACE
+		 * so that the new attr doesn't fit in shortform format, the
+		 * leaf format add routine won't trip over the attr not being
+		 * around.
 		 */
-		args->attr_flags &= ~XATTR_REPLACE;
+		args->op_flags &= ~XFS_DA_OP_REPLACE;
+		break;
+	case 0:
+		break;
+	default:
+		return error;
 	}
 
 	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
@@ -1197,28 +1208,30 @@ xfs_attr_leaf_try_add(
 	 * Look up the xattr name to set the insertion point for the new xattr.
 	 */
 	error = xfs_attr3_leaf_lookup_int(bp, args);
-	if (error != -ENOATTR && error != -EEXIST)
-		goto out_brelse;
-	if (error == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
-		goto out_brelse;
-	if (error == -EEXIST) {
-		if (args->attr_flags & XATTR_CREATE)
+	switch (error) {
+	case -ENOATTR:
+		if (args->op_flags & XFS_DA_OP_REPLACE)
+			goto out_brelse;
+		break;
+	case -EEXIST:
+		if (!(args->op_flags & XFS_DA_OP_REPLACE))
 			goto out_brelse;
 
 		trace_xfs_attr_leaf_replace(args);
-
-		/* save the attribute state for later removal*/
-		args->op_flags |= XFS_DA_OP_RENAME;	/* an atomic rename */
-		xfs_attr_save_rmt_blk(args);
-
 		/*
-		 * clear the remote attr state now that it is saved so that the
-		 * values reflect the state of the attribute we are about to
+		 * Save the existing remote attr state so that the current
+		 * values reflect the state of the new attribute we are about to
 		 * add, not the attribute we just found and will remove later.
 		 */
+		xfs_attr_save_rmt_blk(args);
 		args->rmtblkno = 0;
 		args->rmtblkcnt = 0;
 		args->rmtvaluelen = 0;
+		break;
+	case 0:
+		break;
+	default:
+		goto out_brelse;
 	}
 
 	return xfs_attr3_leaf_add(bp, args);
@@ -1357,46 +1370,45 @@ xfs_attr_node_hasname(
 
 STATIC int
 xfs_attr_node_addname_find_attr(
-	 struct xfs_attr_item		*attr)
+	 struct xfs_attr_item	*attr)
 {
-	struct xfs_da_args		*args = attr->xattri_da_args;
-	int				retval;
+	struct xfs_da_args	*args = attr->xattri_da_args;
+	int			error;
 
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
-	retval = xfs_attr_node_hasname(args, &attr->xattri_da_state);
-	if (retval != -ENOATTR && retval != -EEXIST)
-		goto error;
-
-	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
-		goto error;
-	if (retval == -EEXIST) {
-		if (args->attr_flags & XATTR_CREATE)
+	error = xfs_attr_node_hasname(args, &attr->xattri_da_state);
+	switch (error) {
+	case -ENOATTR:
+		if (args->op_flags & XFS_DA_OP_REPLACE)
+			goto error;
+		break;
+	case -EEXIST:
+		if (!(args->op_flags & XFS_DA_OP_REPLACE))
 			goto error;
 
-		trace_xfs_attr_node_replace(args);
-
-		/* save the attribute state for later removal*/
-		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
-		xfs_attr_save_rmt_blk(args);
 
+		trace_xfs_attr_node_replace(args);
 		/*
-		 * clear the remote attr state now that it is saved so that the
-		 * values reflect the state of the attribute we are about to
+		 * Save the existing remote attr state so that the current
+		 * values reflect the state of the new attribute we are about to
 		 * add, not the attribute we just found and will remove later.
 		 */
-		args->rmtblkno = 0;
-		args->rmtblkcnt = 0;
-		args->rmtvaluelen = 0;
+		xfs_attr_save_rmt_blk(args);
+		break;
+	case 0:
+		break;
+	default:
+		goto error;
 	}
 
 	return 0;
 error:
 	if (attr->xattri_da_state)
 		xfs_da_state_free(attr->xattri_da_state);
-	return retval;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 6bef522533a4..e93efc8b11cd 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -584,6 +584,7 @@ xfs_attr_is_shortform(
 static inline enum xfs_delattr_state
 xfs_attr_init_add_state(struct xfs_da_args *args)
 {
+	args->op_flags |= XFS_DA_OP_ADDNAME;
 	if (!args->dp->i_afp)
 		return XFS_DAS_DONE;
 	if (xfs_attr_is_shortform(args->dp))
@@ -596,6 +597,7 @@ xfs_attr_init_add_state(struct xfs_da_args *args)
 static inline enum xfs_delattr_state
 xfs_attr_init_remove_state(struct xfs_da_args *args)
 {
+	args->op_flags |= XFS_DA_OP_REMOVE;
 	if (xfs_attr_is_shortform(args->dp))
 		return XFS_DAS_SF_REMOVE;
 	if (xfs_attr_is_leaf(args->dp))
@@ -606,6 +608,7 @@ xfs_attr_init_remove_state(struct xfs_da_args *args)
 static inline enum xfs_delattr_state
 xfs_attr_init_replace_state(struct xfs_da_args *args)
 {
+	args->op_flags |= XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE;
 	return xfs_attr_init_add_state(args);
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index e90bfd9d7551..53d02ce9ed78 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1492,7 +1492,7 @@ xfs_attr3_leaf_add_work(
 	entry->flags = args->attr_filter;
 	if (tmp)
 		entry->flags |= XFS_ATTR_LOCAL;
-	if (args->op_flags & XFS_DA_OP_RENAME) {
+	if (args->op_flags & XFS_DA_OP_REPLACE) {
 		if (!xfs_has_larp(mp))
 			entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index deb368d041e3..13ee2e34f92f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -85,19 +85,22 @@ typedef struct xfs_da_args {
  * Operation flags:
  */
 #define XFS_DA_OP_JUSTCHECK	(1u << 0) /* check for ok with no space */
-#define XFS_DA_OP_RENAME	(1u << 1) /* this is an atomic rename op */
+#define XFS_DA_OP_REPLACE	(1u << 1) /* this is an atomic replace op */
 #define XFS_DA_OP_ADDNAME	(1u << 2) /* this is an add operation */
 #define XFS_DA_OP_OKNOENT	(1u << 3) /* lookup op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if found */
 #define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode timestamps */
+#define XFS_DA_OP_REMOVE	(1u << 6) /* this is a remove operation */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
-	{ XFS_DA_OP_RENAME,	"RENAME" }, \
+	{ XFS_DA_OP_REPLACE,	"REPLACE" }, \
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_NOTIME,	"NOTIME" }
+	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
+	{ XFS_DA_OP_REMOVE,	"REMOVE" }
+
 
 /*
  * Storage for holding state during Btree searches and split/join ops.
-- 
2.35.1

