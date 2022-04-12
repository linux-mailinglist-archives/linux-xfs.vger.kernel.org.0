Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43524FCDC9
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Apr 2022 06:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345794AbiDLE2P (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Apr 2022 00:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345816AbiDLE2K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 00:28:10 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44B2C329A2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 21:25:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 69F6A53469E;
        Tue, 12 Apr 2022 14:25:47 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ne865-00Gh2R-W9; Tue, 12 Apr 2022 14:25:46 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ne865-009NrV-V0;
        Tue, 12 Apr 2022 14:25:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH 04/10] xfs: kill XFS_DAC_LEAF_ADDNAME_INIT
Date:   Tue, 12 Apr 2022 14:25:37 +1000
Message-Id: <20220412042543.2234866-5-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412042543.2234866-1-david@fromorbit.com>
References: <20220412042543.2234866-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6254ff4b
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=-5dJtcHi5CXNrSph2GIA:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We re-enter the XFS_DAS_FOUND_LBLK state when we have to allocate
multiple extents for a remote xattr. We currently have a flag
called XFS_DAC_LEAF_ADDNAME_INIT to avoid running the remote attr
hole finding code more than once.

However, for the node format tree, we have a separate state for this
so we never reenter the state machine at XFS_DAS_FOUND_NBLK and so
it does not need a special flag to skip over the remote attr hold
finding code.

Convert the leaf block code to use the same state machine as the
node blocks and kill the  XFS_DAC_LEAF_ADDNAME_INIT flag.

This further points out that this "ALLOC" state is only traversed
if we have remote xattrs or we are doing a rename operation. Rename
both the leaf and node alloc states to _ALLOC_RMT to indicate they
are iterating to do allocation of remote xattr blocks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 45 ++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_attr.h |  6 ++++--
 fs/xfs/xfs_trace.h       |  3 ++-
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b0bbf827fbca..fed476bd048e 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -419,40 +419,41 @@ xfs_attr_set_iter(
 		return xfs_attr_node_addname(attr);
 
 	case XFS_DAS_FOUND_LBLK:
+		/*
+		 * Find space for remote blocks and fall into the allocation
+		 * state.
+		 */
+		if (args->rmtblkno > 0) {
+			error = xfs_attr_rmtval_find_space(attr);
+			if (error)
+				return error;
+		}
+		attr->xattri_dela_state = XFS_DAS_LEAF_ALLOC_RMT;
+		fallthrough;
+	case XFS_DAS_LEAF_ALLOC_RMT:
+
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
 		 * identified for its storage and copy the value.  This is done
 		 * after we create the attribute so that we don't overflow the
 		 * maximum size of a transaction and/or hit a deadlock.
 		 */
-
-		/* Open coded xfs_attr_rmtval_set without trans handling */
-		if ((attr->xattri_flags & XFS_DAC_LEAF_ADDNAME_INIT) == 0) {
-			attr->xattri_flags |= XFS_DAC_LEAF_ADDNAME_INIT;
-			if (args->rmtblkno > 0) {
-				error = xfs_attr_rmtval_find_space(attr);
+		if (args->rmtblkno > 0) {
+			if (attr->xattri_blkcnt > 0) {
+				error = xfs_attr_rmtval_set_blk(attr);
 				if (error)
 					return error;
+				trace_xfs_attr_set_iter_return(
+						attr->xattri_dela_state,
+						args->dp);
+				return -EAGAIN;
 			}
-		}
 
-		/*
-		 * Repeat allocating remote blocks for the attr value until
-		 * blkcnt drops to zero.
-		 */
-		if (attr->xattri_blkcnt > 0) {
-			error = xfs_attr_rmtval_set_blk(attr);
+			error = xfs_attr_rmtval_set_value(args);
 			if (error)
 				return error;
-			trace_xfs_attr_set_iter_return(attr->xattri_dela_state,
-						       args->dp);
-			return -EAGAIN;
 		}
 
-		error = xfs_attr_rmtval_set_value(args);
-		if (error)
-			return error;
-
 		/*
 		 * If this is not a rename, clear the incomplete flag and we're
 		 * done.
@@ -547,15 +548,15 @@ xfs_attr_set_iter(
 				return error;
 		}
 
+		attr->xattri_dela_state = XFS_DAS_NODE_ALLOC_RMT;
 		fallthrough;
-	case XFS_DAS_ALLOC_NODE:
+	case XFS_DAS_NODE_ALLOC_RMT:
 		/*
 		 * If there was an out-of-line value, allocate the blocks we
 		 * identified for its storage and copy the value.  This is done
 		 * after we create the attribute so that we don't overflow the
 		 * maximum size of a transaction and/or hit a deadlock.
 		 */
-		attr->xattri_dela_state = XFS_DAS_ALLOC_NODE;
 		if (args->rmtblkno > 0) {
 			if (attr->xattri_blkcnt > 0) {
 				error = xfs_attr_rmtval_set_blk(attr);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index fc2a177f6994..184dca735cf3 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -451,11 +451,12 @@ enum xfs_delattr_state {
 	XFS_DAS_RM_NAME,		/* Remove attr name */
 	XFS_DAS_RM_SHRINK,		/* We are shrinking the tree */
 	XFS_DAS_FOUND_LBLK,		/* We found leaf blk for attr */
+	XFS_DAS_LEAF_ALLOC_RMT,		/* We are allocating remote blocks */
 	XFS_DAS_FOUND_NBLK,		/* We found node blk for attr */
+	XFS_DAS_NODE_ALLOC_RMT,		/* We are allocating remote blocks */
 	XFS_DAS_FLIP_LFLAG,		/* Flipped leaf INCOMPLETE attr flag */
 	XFS_DAS_RM_LBLK,		/* A rename is removing leaf blocks */
 	XFS_DAS_RD_LEAF,		/* Read in the new leaf */
-	XFS_DAS_ALLOC_NODE,		/* We are allocating node blocks */
 	XFS_DAS_FLIP_NFLAG,		/* Flipped node INCOMPLETE attr flag */
 	XFS_DAS_RM_NBLK,		/* A rename is removing node blocks */
 	XFS_DAS_CLR_FLAG,		/* Clear incomplete flag */
@@ -471,11 +472,12 @@ enum xfs_delattr_state {
 	{ XFS_DAS_RM_NAME,	"XFS_DAS_RM_NAME" }, \
 	{ XFS_DAS_RM_SHRINK,	"XFS_DAS_RM_SHRINK" }, \
 	{ XFS_DAS_FOUND_LBLK,	"XFS_DAS_FOUND_LBLK" }, \
+	{ XFS_DAS_LEAF_ALLOC_RMT, "XFS_DAS_LEAF_ALLOC_RMT" }, \
 	{ XFS_DAS_FOUND_NBLK,	"XFS_DAS_FOUND_NBLK" }, \
+	{ XFS_DAS_NODE_ALLOC_RMT, "XFS_DAS_NODE_ALLOC_RMT" },  \
 	{ XFS_DAS_FLIP_LFLAG,	"XFS_DAS_FLIP_LFLAG" }, \
 	{ XFS_DAS_RM_LBLK,	"XFS_DAS_RM_LBLK" }, \
 	{ XFS_DAS_RD_LEAF,	"XFS_DAS_RD_LEAF" }, \
-	{ XFS_DAS_ALLOC_NODE,	"XFS_DAS_ALLOC_NODE" }, \
 	{ XFS_DAS_FLIP_NFLAG,	"XFS_DAS_FLIP_NFLAG" }, \
 	{ XFS_DAS_RM_NBLK,	"XFS_DAS_RM_NBLK" }, \
 	{ XFS_DAS_CLR_FLAG,	"XFS_DAS_CLR_FLAG" }, \
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 9fc3fe334b5f..8739cc1e0561 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4106,11 +4106,12 @@ TRACE_DEFINE_ENUM(XFS_DAS_RMTBLK);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_NAME);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_SHRINK);
 TRACE_DEFINE_ENUM(XFS_DAS_FOUND_LBLK);
+TRACE_DEFINE_ENUM(XFS_DAS_LEAF_ALLOC_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_FOUND_NBLK);
+TRACE_DEFINE_ENUM(XFS_DAS_NODE_ALLOC_RMT);
 TRACE_DEFINE_ENUM(XFS_DAS_FLIP_LFLAG);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_LBLK);
 TRACE_DEFINE_ENUM(XFS_DAS_RD_LEAF);
-TRACE_DEFINE_ENUM(XFS_DAS_ALLOC_NODE);
 TRACE_DEFINE_ENUM(XFS_DAS_FLIP_NFLAG);
 TRACE_DEFINE_ENUM(XFS_DAS_RM_NBLK);
 TRACE_DEFINE_ENUM(XFS_DAS_CLR_FLAG);
-- 
2.35.1

