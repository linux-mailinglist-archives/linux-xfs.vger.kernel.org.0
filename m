Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9FA1692F6
	for <lists+linux-xfs@lfdr.de>; Sun, 23 Feb 2020 03:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgBWCGH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 22 Feb 2020 21:06:07 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56226 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgBWCGH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N21fNO008663
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version : content-type
 : content-transfer-encoding; s=corp-2020-01-29;
 bh=OfuRHI70NPnjd1bSRCz9hTCKrsgfdB/uRKWCzPVExOE=;
 b=p/H6irH+fjCrzPaC19ghcUkB/g9q4j01JH+FmvaihmfDpPp7x/tbgYpIJ0h3w6P7i24Y
 SGiRiYt+5vuzZ5NpSaJVUHarHPYt3KaZXhkkGZZwlAm2JCg/kVChBUqfbAUzvyjkXsIv
 Ba8SI1rFt1PmDs+6uxC2wUxmz9eCBYggHuTlICzA1b4gkRVsBfXNXBF7ZuKtmJJryzEm
 T19+4MAvEQnCVGJQhxwCinlBFkwJcNNuaAo1e/ogLXxc8ZsHD1E+S1vBUVTsw6bdZ1bO
 hZIA8RSY6U4M5hfrODTbdhAGc7OlLxMjRSmbBtIxK7S2UsBlzJLPTNPvXxESspziEy7s Vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yav8qa0sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N20519056518
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ybe38md39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:04 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01N2640q031346
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:04 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:03 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 15/20] xfsprogs: Add delay ready attr set routines
Date:   Sat, 22 Feb 2020 19:05:49 -0700
Message-Id: <20200223020554.1731-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223020554.1731-1-allison.henderson@oracle.com>
References: <20200223020554.1731-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 impostorscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch modifies the attr set routines to be delay ready. This means they no
longer roll or commit transactions, but instead return -EAGAIN to have the calling
routine roll and refresh the transaction.  In this series, xfs_attr_set_args has
become xfs_attr_set_iter, which uses a state machine like switch to keep track of
where it was when EAGAIN was returned.

Part of xfs_attr_leaf_addname has been factored out into a new helper function
xfs_attr_leaf_try_add to allow transaction cycling between the two routines.

Two new helper functions have been added: xfs_attr_rmtval_set_init and
xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
xfs_attr_rmtval_set, but they store the current block in the delay attr context to
allow the caller to roll the transaction between allocations. This helps to
simplify and consolidate code used by xfs_attr_leaf_addname and
xfs_attr_node_addname. Finally, xfs_attr_set_args has become a simple loop to
refresh the transaction until the operation is completed.

Below is a state machine diagram for attr set operations. The XFS_DAS_* states
indicate places where the function would return - EAGAIN, and then immediately
resume from after being recalled by the calling function.  States marked as a
"subroutine state" indicate that they belong to a subroutine, and so the calling
function needs to pass them back to that subroutine to allow it to finish where it
left off.  But they otherwise do not have a role in the calling function other
than just passing through.

 xfs_attr_set_iter()
                 │
                 v
           need to upgrade
          from sf to leaf? ──n─┐
                 │             │
                 y             │
                 │             │
                 V             │
          XFS_DAS_ADD_LEAF     │
                 │             │
                 v             │
  ┌──────n── fork has   <──────┘
  │         only 1 blk?
  │              │
  │              y
  │              │
  │              v
  │     xfs_attr_leaf_try_add()
  │              │
  │              v
  │          had enough
  ├──────n──   space?
  │              │
  │              y
  │              │
  │              v
  │      XFS_DAS_FOUND_LBLK  ──┐
  │                            │
  │      XFS_DAS_FLIP_LFLAG  ──┤
  │      (subroutine state)    │
  │                            │
  │      XFS_DAS_ALLOC_LEAF  ──┤
  │      (subroutine state)    │
  │                            └─>xfs_attr_leaf_addname()
  │                                              │
  │                                              v
  │                                ┌─────n──  need to
  │                                │        alloc blks?
  │                                │             │
  │                                │             y
  │                                │             │
  │                                │             v
  │                                │  ┌─>XFS_DAS_ALLOC_LEAF
  │                                │  │          │
  │                                │  │          v
  │                                │  └──y── need to alloc
  │                                │         more blocks?
  │                                │             │
  │                                │             n
  │                                │             │
  │                                │             v
  │                                │          was this
  │                                └────────> a rename? ──n─┐
  │                                              │          │
  │                                              y          │
  │                                              │          │
  │                                              v          │
  │                                        flip incomplete  │
  │                                            flag         │
  │                                              │          │
  │                                              v          │
  │                                   ┌─>XFS_DAS_FLIP_LFLAG │
  │                                   │          │          │
  │                                   │          v          │
  │                                   │        remove       │
  │                                   │       old name      │
  │                                   │          │          │
  │                                   │          v          │
  │                                   └────y── more to      │
  │                                            remove       │
  │                                              │          │
  │                                              n          │
  │                                              │          │
  │                                              v          │
  │                                             done <──────┘
  └────> XFS_DAS_LEAF_TO_NODE ─┐
                               │
         XFS_DAS_FOUND_NBLK  ──┤
         (subroutine state)    │
                               │
         XFS_DAS_ALLOC_NODE  ──┤
         (subroutine state)    │
                               │
         XFS_DAS_FLIP_NFLAG  ──┤
         (subroutine state)    │
                               │
                               └─>xfs_attr_node_addname()
                                                 │
                                                 v
                                         find space to store
                                        attr. Split if needed
                                                 │
                                                 v
                                         XFS_DAS_FOUND_NBLK
                                                 │
                                                 v
                                   ┌─────n──  need to
                                   │        alloc blks?
                                   │             │
                                   │             y
                                   │             │
                                   │             v
                                   │  ┌─>XFS_DAS_ALLOC_NODE
                                   │  │          │
                                   │  │          v
                                   │  └──y── need to alloc
                                   │         more blocks?
                                   │             │
                                   │             n
                                   │             │
                                   │             v
                                   │          was this
                                   └────────> a rename? ──n─┐
                                                 │          │
                                                 y          │
                                                 │          │
                                                 v          │
                                           flip incomplete  │
                                               flag         │
                                                 │          │
                                                 v          │
                                      ┌─>XFS_DAS_FLIP_NFLAG │
                                      │          │          │
                                      │          v          │
                                      │        remove       │
                                      │       old name      │
                                      │          │          │
                                      │          v          │
                                      └────y── more to      │
                                               remove       │
                                                 │          │
                                                 n          │
                                                 │          │
                                                 v          │
                                                done <──────┘

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c        | 369 ++++++++++++++++++++++++++++++-----------------
 libxfs/xfs_attr.h        |   1 +
 libxfs/xfs_attr_remote.c |  67 ++++++++-
 libxfs/xfs_attr_remote.h |   4 +
 libxfs/xfs_da_btree.h    |  13 ++
 5 files changed, 319 insertions(+), 135 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 6b6b02b..9d7989c 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -57,6 +57,7 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
+STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
 
 
 STATIC int
@@ -258,9 +259,86 @@ int
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
+		if (args->dac.flags & XFS_DAC_FINISH_TRANS) {
+			args->dac.flags &= ~XFS_DAC_FINISH_TRANS;
+
+			err2 = xfs_defer_finish(&args->trans);
+			if (err2) {
+				error = err2;
+				goto out;
+			}
+		}
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
-	int			error, error2 = 0;
+	int			error = 0;
+	int			sf_size;
+
+	/* State machine switch */
+	switch (args->dac.dela_state) {
+	case XFS_DAS_ADD_LEAF:
+		goto add_leaf;
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
+
+	/*
+	 * New inodes may not have an attribute fork yet. So set the attribute
+	 * fork appropriately
+	 */
+	if (XFS_IFORK_Q((args->dp)) == 0) {
+		sf_size = sizeof(struct xfs_attr_sf_hdr) +
+		     XFS_ATTR_SF_ENTSIZE_BYNAME(args->name.len, args->valuelen);
+		xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
+		args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
+		args->dp->i_afp->if_flags = XFS_IFEXTENTS;
+	}
 
 	/*
 	 * If the attribute list is non-existent or a shortform list,
@@ -269,22 +347,20 @@ xfs_attr_set_args(
 	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
 	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
 	     dp->i_d.di_anextents == 0)) {
-
 		/*
 		 * Try to add the attr to the attribute list in the inode.
 		 */
 		error = xfs_attr_try_sf_addname(dp, args);
-		if (error != -ENOSPC) {
-			error2 = xfs_trans_commit(args->trans);
-			args->trans = NULL;
-			return error ? error : error2;
-		}
+
+		/* Should only be 0, -EEXIST or ENOSPC */
+		if (error != -ENOSPC)
+			return error;
 
 		/*
 		 * It won't fit in the shortform, transform to a leaf block.
 		 * GROT: another possible req'mt for a double-split btree op.
 		 */
-		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
+		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
 		if (error)
 			return error;
 
@@ -292,41 +368,48 @@ xfs_attr_set_args(
 		 * Prevent the leaf buffer from being unlocked so that a
 		 * concurrent AIL push cannot grab the half-baked leaf
 		 * buffer and run into problems with the write verifier.
-		 * Once we're done rolling the transaction we can release
-		 * the hold and add the attr to the leaf.
 		 */
-		xfs_trans_bhold(args->trans, leaf_bp);
-		error = xfs_defer_finish(&args->trans);
-		xfs_trans_bhold_release(args->trans, leaf_bp);
-		if (error) {
-			xfs_trans_brelse(args->trans, leaf_bp);
-			return error;
-		}
+		xfs_trans_bhold(args->trans, *leaf_bp);
+		args->dac.flags |= XFS_DAC_FINISH_TRANS;
+		args->dac.dela_state = XFS_DAS_ADD_LEAF;
+		return -EAGAIN;
 	}
 
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-		error = xfs_attr_leaf_addname(args);
-		if (error != -ENOSPC)
-			return error;
+add_leaf:
 
-		/*
-		 * Commit that transaction so that the node_addname()
-		 * call can manage its own transactions.
-		 */
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
+	/*
+	 * After a shortform to leaf conversion, we need to hold the leaf and
+	 * cylce out the transaction.  When we get back, we need to release
+	 * the leaf.
+	 */
+	if (*leaf_bp != NULL) {
+		xfs_trans_brelse(args->trans, *leaf_bp);
+		*leaf_bp = NULL;
+	}
 
-		/*
-		 * Commit the current trans (including the inode) and
-		 * start a new one.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+		error = xfs_attr_leaf_try_add(args, *leaf_bp);
+		switch (error) {
+		case -ENOSPC:
+			args->dac.flags |= XFS_DAC_FINISH_TRANS;
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
@@ -765,28 +848,29 @@ xfs_attr_leaf_try_add(
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
 xfs_attr_leaf_addname(
 	struct xfs_da_args	*args)
 {
-	int			error, forkoff;
 	struct xfs_buf		*bp = NULL;
+	int			error, forkoff;
 	struct xfs_inode	*dp = args->dp;
 
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
@@ -795,7 +879,28 @@ xfs_attr_leaf_addname(
 	 * maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
+
+		/* Open coded xfs_attr_rmtval_set without trans handling */
+		error = xfs_attr_rmtval_set_init(args);
+		if (error)
+			return error;
+
+		/*
+		 * Roll through the "value", allocating blocks on disk as
+		 * required.
+		 */
+alloc_leaf:
+		while (args->dac.blkcnt > 0) {
+			error = xfs_attr_rmtval_set_blk(args);
+			if (error)
+				return error;
+
+			args->dac.flags |= XFS_DAC_FINISH_TRANS;
+			args->dac.dela_state = XFS_DAS_ALLOC_LEAF;
+			return -EAGAIN;
+		}
+
+		error = xfs_attr_rmtval_set_value(args);
 		if (error)
 			return error;
 	}
@@ -814,13 +919,6 @@ xfs_attr_leaf_addname(
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
 
 		/*
 		 * Dismantle the "old" attribute/value pair by removing
@@ -831,8 +929,17 @@ xfs_attr_leaf_addname(
 		args->rmtblkno = args->rmtblkno2;
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
+
+		args->dac.dela_state = XFS_DAS_FLIP_LFLAG;
+		return -EAGAIN;
+flip_flag:
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(args);
+			error = xfs_attr_rmtval_unmap(args);
+
+			/*
+			 * if (error == -EAGAIN), we will repeat this until
+			 * args->rmtblkno is zero
+			 */
 			if (error)
 				return error;
 		}
@@ -851,34 +958,17 @@ xfs_attr_leaf_addname(
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
 
-		/*
-		 * Commit the remove and start the next trans in series.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
+		args->dac.flags |= XFS_DAC_FINISH_TRANS;
 
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
@@ -1026,16 +1116,22 @@ xfs_attr_node_hasname(
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
 
 	trace_xfs_attr_node_addname(args);
 
@@ -1044,7 +1140,19 @@ xfs_attr_node_addname(
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
@@ -1094,19 +1202,13 @@ restart:
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
+			args->dac.flags |= XFS_DAC_FINISH_TRANS;
+			return -EAGAIN;
 		}
 
 		/*
@@ -1118,9 +1220,7 @@ restart:
 		error = xfs_da3_split(state);
 		if (error)
 			goto out;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			goto out;
+		args->dac.flags |= XFS_DAC_FINISH_TRANS;
 	} else {
 		/*
 		 * Addition succeeded, update Btree hashvals.
@@ -1135,13 +1235,9 @@ restart:
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
@@ -1150,7 +1246,27 @@ restart:
 	 * maximum size of a transaction and/or hit a deadlock.
 	 */
 	if (args->rmtblkno > 0) {
-		error = xfs_attr_rmtval_set(args);
+		/* Open coded xfs_attr_rmtval_set without trans handling */
+		error = xfs_attr_rmtval_set_init(args);
+		if (error)
+			return error;
+
+		/*
+		 * Roll through the "value", allocating blocks on disk as
+		 * required.
+		 */
+alloc_node:
+		while (args->dac.blkcnt > 0) {
+			error = xfs_attr_rmtval_set_blk(args);
+			if (error)
+				return error;
+
+			args->dac.flags |= XFS_DAC_FINISH_TRANS;
+			args->dac.dela_state = XFS_DAS_ALLOC_NODE;
+			return -EAGAIN;
+		}
+
+		error = xfs_attr_rmtval_set_value(args);
 		if (error)
 			return error;
 	}
@@ -1169,13 +1285,6 @@ restart:
 		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			goto out;
-		/*
-		 * Commit the flag value change and start the next trans in
-		 * series
-		 */
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			goto out;
 
 		/*
 		 * Dismantle the "old" attribute/value pair by removing
@@ -1186,8 +1295,21 @@ restart:
 		args->rmtblkno = args->rmtblkno2;
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
+
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series
+		 */
+		args->dac.dela_state = XFS_DAS_FLIP_NFLAG;
+		return -EAGAIN;
+flip_flag:
 		if (args->rmtblkno) {
-			error = xfs_attr_rmtval_remove(args);
+			error = xfs_attr_rmtval_unmap(args);
+
+			/*
+			 * if (error == -EAGAIN), we will repeat this until
+			 * args->rmtblkno is zero
+			 */
 			if (error)
 				return error;
 		}
@@ -1205,7 +1327,6 @@ restart:
 		error = xfs_da3_node_lookup_int(state, &retval);
 		if (error)
 			goto out;
-
 		/*
 		 * Remove the name and update the hashvals in the tree.
 		 */
@@ -1213,7 +1334,6 @@ restart:
 		ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 		error = xfs_attr3_leaf_remove(blk->bp, args);
 		xfs_da3_fixhashpath(state, &state->path);
-
 		/*
 		 * Check to see if the tree needs to be collapsed.
 		 */
@@ -1221,18 +1341,9 @@ restart:
 			error = xfs_da3_join(state);
 			if (error)
 				goto out;
-			error = xfs_defer_finish(&args->trans);
-			if (error)
-				goto out;
-		}
-
-		/*
-		 * Commit and start the next trans in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			goto out;
 
+			args->dac.flags |= XFS_DAC_FINISH_TRANS;
+		}
 	} else if (args->rmtblkno > 0) {
 		/*
 		 * Added a "remote" value, just clear the incomplete flag.
@@ -1240,14 +1351,6 @@ restart:
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
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 5b92f2d..3ed27e0 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -425,7 +425,7 @@ xfs_attr_rmtval_get(
  * Find a "hole" in the attribute address space large enough for us to drop the
  * new attribute's value into
  */
-STATIC int
+int
 xfs_attr_rmt_find_hole(
 	struct xfs_da_args	*args)
 {
@@ -452,7 +452,7 @@ xfs_attr_rmt_find_hole(
 	return 0;
 }
 
-STATIC int
+int
 xfs_attr_rmtval_set_value(
 	struct xfs_da_args	*args)
 {
@@ -585,6 +585,69 @@ xfs_attr_rmtval_set(
 }
 
 /*
+ * Find a hole for the attr and store it in the delayed attr context.  This
+ * initializes the context to roll through allocating an attr extent for a
+ * delayed attr operation
+ */
+int
+xfs_attr_rmtval_set_init(
+	struct xfs_da_args	*args)
+{
+	struct xfs_bmbt_irec	*map = &args->dac.map;
+	int error;
+
+	args->dac.lblkno = 0;
+	args->dac.lfileoff = 0;
+	args->dac.blkcnt = 0;
+	args->rmtblkcnt = 0;
+	args->rmtblkno = 0;
+	memset(map, 0, sizeof(struct xfs_bmbt_irec));
+
+	error = xfs_attr_rmt_find_hole(args);
+	if (error)
+		return error;
+
+	args->dac.blkcnt = args->rmtblkcnt;
+	args->dac.lblkno = args->rmtblkno;
+
+	return error;
+}
+
+/*
+ * Write one block of the value associated with an attribute into the
+ * out-of-line buffer that we have defined for it. This is similar to a subset
+ * of xfs_attr_rmtval_set, but records the current block to the delayed attr
+ * context, and leaves transaction handling to the caller.
+ */
+int
+xfs_attr_rmtval_set_blk(
+	struct xfs_da_args	*args)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_bmbt_irec	*map = &args->dac.map;
+	int nmap;
+	int error;
+
+	nmap = 1;
+	error = xfs_bmapi_write(args->trans, dp,
+		  (xfs_fileoff_t)args->dac.lblkno,
+		  args->dac.blkcnt, XFS_BMAPI_ATTRFORK,
+		  args->total, map, &nmap);
+	if (error)
+		return error;
+
+	ASSERT(nmap == 1);
+	ASSERT((map->br_startblock != DELAYSTARTBLOCK) &&
+	       (map->br_startblock != HOLESTARTBLOCK));
+
+	/* roll attribute extent map forwards */
+	args->dac.lblkno += map->br_blockcount;
+	args->dac.blkcnt -= map->br_blockcount;
+
+	return 0;
+}
+
+/*
  * Remove the value associated with an attribute by deleting the
  * out-of-line buffer that it is stored on.
  */
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 7ab3770..ab03519 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -13,4 +13,8 @@ int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
 int xfs_attr_rmtval_unmap(struct xfs_da_args *args);
+int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
+int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
+int xfs_attr_rmtval_set_blk(struct xfs_da_args *args);
+int xfs_attr_rmtval_set_init(struct xfs_da_args *args);
 #endif /* __XFS_ATTR_REMOTE_H__ */
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 0967564..66ea73c 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -54,6 +54,14 @@ enum xfs_dacmp {
 enum xfs_delattr_state {
 	XFS_DAS_RM_SHRINK,	/* We are shrinking the tree */
 	XFS_DAS_RMTVAL_REMOVE,	/* We are removing remote value blocks */
+	XFS_DAS_ADD_LEAF,	/* We are adding a leaf attr */
+	XFS_DAS_FOUND_LBLK,	/* We found leaf blk for attr */
+	XFS_DAS_LEAF_TO_NODE,	/* Converted leaf to node */
+	XFS_DAS_FOUND_NBLK,	/* We found node blk for attr */
+	XFS_DAS_ALLOC_LEAF,	/* We are allocating leaf blocks */
+	XFS_DAS_FLIP_LFLAG,	/* Flipped leaf INCOMPLETE attr flag */
+	XFS_DAS_ALLOC_NODE,	/* We are allocating node blocks */
+	XFS_DAS_FLIP_NFLAG,	/* Flipped node INCOMPLETE attr flag */
 };
 
 /*
@@ -65,8 +73,13 @@ enum xfs_delattr_state {
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
 	unsigned int		flags;
 	enum xfs_delattr_state	dela_state;
 };
-- 
2.7.4

