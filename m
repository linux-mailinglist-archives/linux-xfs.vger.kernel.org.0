Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C41511C4E4
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Dec 2019 05:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbfLLESQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Dec 2019 23:18:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50614 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbfLLESP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 23:18:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4EIaC144613
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=xWVnt+RpZtEMoN6E2EWVkkPOsI2JveGGWQ1845WbtfM=;
 b=LRxKDmVQt5b7Xot9vtPfMNFhuP+1rPAtSZ7k0YOf7dBXjFbGUFvOTSUFEq0enIhP0JmA
 9uyERKvCMRHkkSQiUO8+iWetJlT7rvkF/jkjRw0KNI80vvczMAQK6ojiee3qxYPd12zh
 OhwSgtDTmm0mTRfWc1M5a9dCPoGNqqLE82tSehdQZWHo46rafPQBaTG8wHqv00UvBY6P
 s1C1ZLi9LhKQLrJ0nVIIvm6VB8BzNieug+BoUHG2dpNW3tKTm1qTuMql2QLFwkVxR+/F
 RZtPj3O3XraLAe7F2y2NKvrVzAdxtp3LYQuvRSROB0D0RsD5nnihWBuGtHtxuDmceB2G Xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wrw4ndbkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4E40o127161
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wu2fvep7y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:11 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBC4IBBG026329
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:11 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Dec 2019 20:18:11 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 14/14] xfsprogs: Add delay ready attr set routines
Date:   Wed, 11 Dec 2019 21:18:03 -0700
Message-Id: <20191212041803.14018-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212041803.14018-1-allison.henderson@oracle.com>
References: <20191212041803.14018-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies the attr set routines to be delay ready.
This means they no longer roll or commit transactions, but instead
return -EAGAIN to have the calling routine roll and refresh the
transaction.  In this series, xfs_attr_set_args has become
xfs_attr_set_iter, which uses a state machine like switch to keep
track of where it was when EAGAIN was returned.  Part of
xfs_attr_leaf_addname has been factored out into a new helper
function xfs_attr_leaf_try_add to allow transaction cycling between
the two routines.  xfs_attr_set_args consists of a simple loop to
refresh the transaction until the operation is completed.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c     | 440 ++++++++++++++++++++++++++++++++------------------
 libxfs/xfs_attr.h     |   1 +
 libxfs/xfs_da_btree.h |  13 ++
 3 files changed, 293 insertions(+), 161 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 579afed..440daa3 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -57,6 +57,7 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
+STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
 
 
 STATIC int
@@ -227,96 +228,166 @@ int
 xfs_attr_set_args(
 	struct xfs_da_args	*args)
 {
+	int			error = 0;
+	int			err2 = 0;
+	struct xfs_buf		*leaf_bp = NULL;
+
+	do {
+		error = xfs_attr_set_iter(args, &leaf_bp);
+		if (error && error != -EAGAIN)
+			goto out;
+
+		err2 = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (err2) {
+			error = err2;
+			goto out;
+		}
+
+		if (leaf_bp) {
+			xfs_trans_bjoin(args->trans, leaf_bp);
+			xfs_trans_bhold(args->trans, leaf_bp);
+		}
+
+	} while (error == -EAGAIN);
+
+out:
+	return error;
+}
+
+/*
+ * Set the attribute specified in @args.
+ * This routine is meant to function as a delayed operation, and may return
+ * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ * returned.
+ */
+int
+xfs_attr_set_iter(
+	struct xfs_da_args	*args,
+	struct xfs_buf          **leaf_bp)
+{
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_buf          *leaf_bp = NULL;
-	int			error, error2 = 0;;
+	int			error = 0;
+	int			sf_size;
+
+	/* State machine switch */
+	switch (args->dac.dela_state) {
+	case XFS_DAS_SF_TO_LEAF:
+		goto sf_to_leaf;
+	case XFS_DAS_ALLOC_LEAF:
+	case XFS_DAS_FLIP_LFLAG:
+	case XFS_DAS_FOUND_LBLK:
+		goto leaf;
+	case XFS_DAS_FOUND_NBLK:
+	case XFS_DAS_FLIP_NFLAG:
+	case XFS_DAS_ALLOC_NODE:
+	case XFS_DAS_LEAF_TO_NODE:
+		goto node;
+	default:
+		break;
+	}
 
 	/*
-	 * If the attribute list is non-existent or a shortform list,
-	 * upgrade it to a single-leaf-block attribute list.
+	 * New inodes may not have an attribute fork yet. So set the attribute
+	 * fork appropriately
 	 */
-	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
+	if (XFS_IFORK_Q((args->dp)) == 0) {
+		sf_size = sizeof(struct xfs_attr_sf_hdr) +
+		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
+		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
+		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
+		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
+	}
+
+	/*
+	 * If the attribute list is non-existent or a shortform list, proceed to
+	 * upgrade it to a single-leaf-block attribute list.  Otherwise jump
+	 * straight to leaf handling
+	 */
+	if (!(dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
 	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     dp->i_d.di_anextents == 0)) {
+	     dp->i_d.di_anextents == 0)))
+		goto sf_to_leaf;
 
-		/*
-		 * Build initial attribute list (if required).
-		 */
-		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
-			xfs_attr_shortform_create(args);
+	/*
+	 * Build initial attribute list (if required).
+	 */
+	if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
+		xfs_attr_shortform_create(args);
+
+	/*
+	 * Try to add the attr to the attribute list in the inode.
+	 */
+	error = xfs_attr_shortform_addname(args);
 
+	/* Should only be 0, -EEXIST or ENOSPC */
+	if (error != -ENOSPC) {
 		/*
-		 * Try to add the attr to the attribute list in the inode.
+		 * Commit the shortform mods, and we're done.
+		 * NOTE: this is also the error path (EEXIST, etc).
 		 */
+		if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
+			xfs_trans_ichgtime(args->trans, dp,
+					   XFS_ICHGTIME_CHG);
 
-		error = xfs_attr_shortform_addname(args);
+		if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
+			xfs_trans_set_sync(args->trans);
 
-		/* Should only be 0, -EEXIST or ENOSPC */
-		if (error != -ENOSPC) {
-			/*
-			 * Commit the shortform mods, and we're done.
-			 * NOTE: this is also the error path (EEXIST, etc).
-			 */
-			if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
-				xfs_trans_ichgtime(args->trans, dp,
-						   XFS_ICHGTIME_CHG);
+		return error;
+	}
 
-			if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
-				xfs_trans_set_sync(args->trans);
+	/*
+	 * It won't fit in the shortform, transform to a leaf block.
+	 * GROT: another possible req'mt for a double-split btree op.
+	 */
+	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	if (error)
+		return error;
 
-			error2 = xfs_trans_commit(args->trans);
-			args->trans = NULL;
-			return error ? error : error2;
-		}
+	/*
+	 * Prevent the leaf buffer from being unlocked so that a
+	 * concurrent AIL push cannot grab the half-baked leaf
+	 * buffer and run into problems with the write verifier.
+	 */
 
+	xfs_trans_bhold(args->trans, *leaf_bp);
+	args->dac.dela_state = XFS_DAS_SF_TO_LEAF;
+	return -EAGAIN;
 
-		/*
-		 * It won't fit in the shortform, transform to a leaf block.
-		 * GROT: another possible req'mt for a double-split btree op.
-		 */
-		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
-		if (error)
-			return error;
+sf_to_leaf:
 
-		/*
-		 * Prevent the leaf buffer from being unlocked so that a
-		 * concurrent AIL push cannot grab the half-baked leaf
-		 * buffer and run into problems with the write verifier.
-		 * Once we're done rolling the transaction we can release
-		 * the hold and add the attr to the leaf.
-		 */
-		xfs_trans_bhold(args->trans, leaf_bp);
-		error = xfs_defer_finish(&args->trans);
-		xfs_trans_bhold_release(args->trans, leaf_bp);
-		if (error) {
-			xfs_trans_brelse(args->trans, leaf_bp);
-			return error;
-		}
+	/*
+	 * After a shortform to leaf conversion, we need to hold the leaf and
+	 * cylce out the transaction.  When we get back, we need to release
+	 * the leaf.
+	 */
+	if (*leaf_bp != NULL) {
+		xfs_trans_brelse(args->trans, *leaf_bp);
+		*leaf_bp = NULL;
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_addname(args);
-		if (error == 0 || error != -ENOSPC)
-			return 0;
-
-		/*
-		 * Commit that transaction so that the node_addname()
-		 * call can manage its own transactions.
-		 */
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-
-		/*
-		 * Commit the current trans (including the inode) and
-		 * start a new one.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
+		error = xfs_attr_leaf_try_add(args, *leaf_bp);
+		switch (error) {
+		case -ENOSPC:
+			args->dac.dela_state = XFS_DAS_LEAF_TO_NODE;
+			return -EAGAIN;
+		case 0:
+			args->dac.dela_state = XFS_DAS_FOUND_LBLK;
+			return -EAGAIN;
+		default:
 			return error;
-
+		}
+leaf:
+		error = xfs_attr_leaf_addname(args);
+		if (error == -ENOSPC) {
+			args->dac.dela_state = XFS_DAS_LEAF_TO_NODE;
+			return -EAGAIN;
+		}
+		return error;
 	}
-
+	args->dac.dela_state = XFS_DAS_LEAF_TO_NODE;
+node:
 	error = xfs_attr_node_addname(args);
 	return error;
 }
@@ -739,27 +810,29 @@ xfs_attr_leaf_try_add(
  *
  * This leaf block cannot have a "remote" value, we only call this routine
  * if bmap_one_block() says there is only one block (ie: no remote blks).
+ *
+ * This routine is meant to function as a delayed operation, and may return
+ * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ * returned.
  */
 STATIC int
 xfs_attr_leaf_addname(struct xfs_da_args	*args)
 {
-	int			error, forkoff;
 	struct xfs_buf		*bp = NULL;
+	int			error, forkoff, nmap;
 	struct xfs_inode	*dp = args->dp;
+	struct xfs_bmbt_irec	*map = &args->dac.map;
 
-	trace_xfs_attr_leaf_addname(args);
-
-	error = xfs_attr_leaf_try_add(args, bp);
-	if (error)
-		return error;
-
-	/*
-	 * Commit the transaction that added the attr name so that
-	 * later routines can manage their own transactions.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		return error;
+	/* State machine switch */
+	switch (args->dac.dela_state) {
+	case XFS_DAS_FLIP_LFLAG:
+		goto flip_flag;
+	case XFS_DAS_ALLOC_LEAF:
+		goto alloc_leaf;
+	default:
+		break;
+	}
 
 	/*
 	 * If there was an out-of-line value, allocate the blocks we
@@ -768,7 +841,49 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
 	 * maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
+
+		/* Open coded xfs_attr_rmtval_set without trans handling */
+
+		args->dac.lfileoff = 0;
+		args->dac.lblkno = 0;
+		args->dac.blkcnt = 0;
+		args->rmtblkcnt = 0;
+		args->rmtblkno = 0;
+		memset(map, 0, sizeof(struct xfs_bmbt_irec));
+
+		error = xfs_attr_rmt_find_hole(args);
+		if (error)
+			return error;
+
+		args->dac.blkcnt = args->rmtblkcnt;
+		args->dac.lblkno = args->rmtblkno;
+
+		/*
+		 * Roll through the "value", allocating blocks on disk as
+		 * required.
+		 */
+alloc_leaf:
+		while (args->dac.blkcnt > 0) {
+			nmap = 1;
+			error = xfs_bmapi_write(args->trans, dp,
+				  (xfs_fileoff_t)args->dac.lblkno,
+				  args->dac.blkcnt, XFS_BMAPI_ATTRFORK,
+				  args->total, map, &nmap);
+			if (error)
+				return error;
+			ASSERT(nmap == 1);
+			ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
+			       (map->br_startblock != HOLESTARTBLOCK));
+
+			/* roll attribute extent map forwards */
+			args->dac.lblkno += map->br_blockcount;
+			args->dac.blkcnt -= map->br_blockcount;
+
+			args->dac.dela_state = XFS_DAS_ALLOC_LEAF;
+			return -EAGAIN;
+		}
+
+		error = xfs_attr_rmtval_set_value(args);
 		if (error)
 			return error;
 	}
@@ -787,13 +902,10 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
 		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			return error;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			return error;
+
+		args->dac.dela_state = XFS_DAS_FLIP_LFLAG;
+		return -EAGAIN;
+flip_flag:
 
 		/*
 		 * Dismantle the "old" attribute/value pair by removing
@@ -824,34 +936,15 @@ xfs_attr_leaf_addname(struct xfs_da_args	*args)
 		/*
 		 * If the result is small enough, shrink it all into the inode.
 		 */
-		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
+		forkoff = xfs_attr_shortform_allfit(bp, dp);
+		if (forkoff)
 			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
-			/* bp is gone due to xfs_da_shrink_inode */
-			if (error)
-				return error;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				return error;
-		}
-
-		/*
-		 * Commit the remove and start the next trans in series.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
 
 	} else if (args->rmtblkno > 0) {
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
 		 */
 		error = xfs_attr3_leaf_clearflag(args);
-		if (error)
-			return error;
-
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
 	}
 	return error;
 }
@@ -994,16 +1087,24 @@ xfs_attr_node_hasname(
  *
  * "Remote" attribute values confuse the issue and atomic rename operations
  * add a whole extra layer of confusion on top of that.
+ *
+ * This routine is meant to function as a delayed operation, and may return
+ * -EAGAIN when the transaction needs to be rolled.  Calling functions will need
+ * to handle this, and recall the function until a successful error code is
+ *returned.
  */
 STATIC int
 xfs_attr_node_addname(
 	struct xfs_da_args	*args)
 {
-	struct xfs_da_state	*state;
+	struct xfs_da_state	*state = NULL;
 	struct xfs_da_state_blk	*blk;
 	struct xfs_inode	*dp;
 	struct xfs_mount	*mp;
-	int			retval, error;
+	int			retval = 0;
+	int			error = 0;
+	int			nmap;
+	struct xfs_bmbt_irec    *map = &args->dac.map;
 
 	trace_xfs_attr_node_addname(args);
 
@@ -1012,7 +1113,19 @@ xfs_attr_node_addname(
 	 */
 	dp = args->dp;
 	mp = dp->i_mount;
-restart:
+
+	/* State machine switch */
+	switch (args->dac.dela_state) {
+	case XFS_DAS_FLIP_NFLAG:
+		goto flip_flag;
+	case XFS_DAS_FOUND_NBLK:
+		goto found_nblk;
+	case XFS_DAS_ALLOC_NODE:
+		goto alloc_node;
+	default:
+		break;
+	}
+
 	/*
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
@@ -1062,19 +1175,12 @@ restart:
 			error = xfs_attr3_leaf_to_node(args);
 			if (error)
 				goto out;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
 
 			/*
-			 * Commit the node conversion and start the next
-			 * trans in the chain.
+			 * Restart routine from the top.  No need to set  the
+			 * state
 			 */
-			error = xfs_trans_roll_inode(&args->trans, dp);
-			if (error)
-				goto out;
-
-			goto restart;
+			return -EAGAIN;
 		}
 
 		/*
@@ -1086,9 +1192,6 @@ restart:
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1103,13 +1206,9 @@ restart:
 	xfs_da_state_free(state);
 	state = NULL;
 
-	/*
-	 * Commit the leaf addition or btree split and start the next
-	 * trans in the chain.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, dp);
-	if (error)
-		goto out;
+	args->dac.dela_state = XFS_DAS_FOUND_NBLK;
+	return -EAGAIN;
+found_nblk:
 
 	/*
 	 * If there was an out-of-line value, allocate the blocks we
@@ -1118,7 +1217,48 @@ restart:
 	 * maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
+		/* Open coded xfs_attr_rmtval_set without trans handling */
+		args->dac.lblkno = 0;
+		args->dac.lfileoff = 0;
+		args->dac.blkcnt = 0;
+		args->rmtblkcnt = 0;
+		args->rmtblkno = 0;
+		memset(map, 0, sizeof(struct xfs_bmbt_irec));
+
+		error = xfs_attr_rmt_find_hole(args);
+		if (error)
+			return error;
+
+		args->dac.blkcnt = args->rmtblkcnt;
+		args->dac.lblkno = args->rmtblkno;
+		/*
+		 * Roll through the "value", allocating blocks on disk as
+		 * required.
+		 */
+alloc_node:
+		while (args->dac.blkcnt > 0) {
+			nmap = 1;
+			error = xfs_bmapi_write(args->trans, dp,
+						(xfs_fileoff_t)args->dac.lblkno,
+						args->dac.blkcnt,
+						XFS_BMAPI_ATTRFORK,
+						args->total, map, &nmap);
+			if (error)
+				return error;
+
+			ASSERT(nmap == 1);
+			ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
+			       (map->br_startblock != HOLESTARTBLOCK));
+
+			/* roll attribute extent map forwards */
+			args->dac.lblkno += map->br_blockcount;
+			args->dac.blkcnt -= map->br_blockcount;
+
+			args->dac.dela_state = XFS_DAS_ALLOC_NODE;
+			return -EAGAIN;
+		}
+
+		error = xfs_attr_rmtval_set_value(args);
 		if (error)
 			return error;
 	}
@@ -1141,10 +1281,9 @@ restart:
 		 * Commit the flag value change and start the next trans in
 		 * series
 		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			goto out;
-
+		args->dac.dela_state = XFS_DAS_FLIP_NFLAG;
+		return -EAGAIN;
+flip_flag:
 		/*
 		 * Dismantle the "old" attribute/value pair by removing
 		 * a "remote" value (if it exists).
@@ -1173,7 +1312,6 @@ restart:
 		error = xfs_da3_node_lookup_int(state, &retval);
 		if (error)
 			goto out;
-
 		/*
 		 * Remove the name and update the hashvals in the tree.
 		 */
@@ -1181,7 +1319,6 @@ restart:
 		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 		error = xfs_attr3_leaf_remove(blk->bp, args);
 		xfs_da3_fixhashpath(state, &state->path);
-
 		/*
 		 * Check to see if the tree needs to be collapsed.
 		 */
@@ -1189,18 +1326,7 @@ restart:
 			error = xfs_da3_join(state);
 			if (error)
 				goto out;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
 		}
-
-		/*
-		 * Commit and start the next trans in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			goto out;
-
 	} else if (args->rmtblkno > 0) {
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
@@ -1208,14 +1334,6 @@ restart:
 		error = xfs_attr3_leaf_clearflag(args);
 		if (error)
 			goto out;
-
-		 /*
-		  * Commit the flag value change and start the next trans in
-		  * series.
-		  */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			goto out;
 	}
 	retval = error = 0;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index f6ac571..0ba80c9 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -149,6 +149,7 @@ int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
 int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
 		 unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args);
+int xfs_attr_set_iter(struct xfs_da_args *args, struct xfs_buf **leaf_bp);
 int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 1cec0a5c..8b6cd3e 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -46,14 +46,27 @@ enum xfs_delattr_state {
 	XFS_DAS_RM_INVALIDATE	= 1, /* We are invalidating blocks */
 	XFS_DAS_RM_SHRINK	= 2, /* We are shrinking the tree */
 	XFS_DAS_RM_NODE_BLKS	= 3,/* We are removing node blocks */
+	XFS_DAS_SF_TO_LEAF	= 4, /* Converted short form to leaf */
+	XFS_DAS_FOUND_LBLK	= 5, /* We found leaf blk for attr */
+	XFS_DAS_LEAF_TO_NODE	= 6, /* Converted leaf to node */
+	XFS_DAS_FOUND_NBLK	= 7, /* We found node blk for attr */
+	XFS_DAS_ALLOC_LEAF	= 8, /* We are allocating leaf blocks */
+	XFS_DAS_FLIP_LFLAG	= 9, /* Flipped leaf INCOMPLETE attr flag */
+	XFS_DAS_ALLOC_NODE	= 10,/* We are allocating node blocks */
+	XFS_DAS_FLIP_NFLAG	= 11,/* Flipped node INCOMPLETE attr flag */
 };
 
 /*
  * Context used for keeping track of delayed attribute operations
  */
 struct xfs_delattr_context {
+	struct xfs_bmbt_irec	map;
+	struct xfs_buf		*leaf_bp;
+	xfs_fileoff_t		lfileoff;
 	struct xfs_da_state	*da_state;
 	struct xfs_da_state_blk *blk;
+	xfs_dablk_t		lblkno;
+	int			blkcnt;
 	enum xfs_delattr_state	dela_state;
 };
 
-- 
2.7.4

