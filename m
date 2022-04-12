Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640C04FCDCE
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Apr 2022 06:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345806AbiDLE2R (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 Apr 2022 00:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345813AbiDLE2K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 00:28:10 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C95A329A0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 21:25:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 70D8E10C7C14;
        Tue, 12 Apr 2022 14:25:47 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ne865-00Gh2K-So; Tue, 12 Apr 2022 14:25:45 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ne865-009NrI-Rg;
        Tue, 12 Apr 2022 14:25:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     allison.henderson@oracle.com
Subject: [PATCH 01/10] xfs: avoid empty xattr transaction when attrs are inline
Date:   Tue, 12 Apr 2022 14:25:34 +1000
Message-Id: <20220412042543.2234866-2-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412042543.2234866-1-david@fromorbit.com>
References: <20220412042543.2234866-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6254ff4b
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=z6sQ9X07RN1rA8HuyEwA:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

generic/642 triggered a reproducable assert failure in
xlog_cil_commit() that resulted from a xfs_attr_set() committing
an empty but dirty transaction. When the CIL is empty and this
occurs, xlog_cil_commit() tries a background push and this triggers
a "pushing an empty CIL" assert.

XFS: Assertion failed: !list_empty(&cil->xc_cil), file: fs/xfs/xfs_log_cil.c, line: 1274
Call Trace:
 <TASK>
 xlog_cil_commit+0xa5a/0xad0
 __xfs_trans_commit+0xb8/0x330
 xfs_trans_commit+0x10/0x20
 xfs_attr_set+0x3e2/0x4c0
 xfs_xattr_set+0x8d/0xe0
 __vfs_setxattr+0x6b/0x90
 __vfs_setxattr_noperm+0x76/0x220
 __vfs_setxattr_locked+0xdf/0x100
 vfs_setxattr+0x94/0x170
 setxattr+0x110/0x200
 path_setxattr+0xbf/0xe0
 __x64_sys_setxattr+0x2b/0x30
 do_syscall_64+0x35/0x80

The problem is related to the breakdown of attribute addition in
xfs_attr_set_iter() and how it is called from deferred operations.
When we have a pure leaf xattr insert, we add the xattr to the leaf
and set the next state to XFS_DAS_FOUND_LBLK and return -EAGAIN.
This requeues the xattr defered work, rolls the transaction and
runs xfs_attr_set_iter() again. This then checks the xattr for
being remote (it's not) and whether a replace op is being done (this
is a create op) and if neither are true it returns without having
done anything.

xfs_xattri_finish_update() then unconditionally sets the transaction
dirty, and the deferops finishes and returns to __xfs_trans_commit()
which sees the transaction dirty and tries to commit it by calling
xlog_cil_commit(). The transaction is empty, and then the assert
fires if this happens when the CIL is empty.

This patch addresses the structure of xfs_attr_set_iter() that
requires re-entry on leaf add even when nothing will be done. This
gets rid of the trailing empty transaction and so doesn't trigger
the XFS_TRANS_DIRTY assignment in xfs_xattri_finish_update()
incorrectly. Addressing that is for a different patch.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 48b7e7efbb30..b3d918195160 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -315,6 +315,7 @@ xfs_attr_leaf_addname(
 {
 	struct xfs_da_args	*args = attr->xattri_da_args;
 	struct xfs_inode	*dp = args->dp;
+	enum xfs_delattr_state	next_state = XFS_DAS_UNINIT;
 	int			error;
 
 	if (xfs_attr_is_leaf(dp)) {
@@ -335,37 +336,35 @@ xfs_attr_leaf_addname(
 			 * when we come back, we'll be a node, so we'll fall
 			 * down into the node handling code below
 			 */
-			trace_xfs_attr_set_iter_return(
-				attr->xattri_dela_state, args->dp);
-			return -EAGAIN;
+			error = -EAGAIN;
+			goto out;
 		}
-
-		if (error)
-			return error;
-
-		attr->xattri_dela_state = XFS_DAS_FOUND_LBLK;
+		next_state = XFS_DAS_FOUND_LBLK;
 	} else {
 		error = xfs_attr_node_addname_find_attr(attr);
 		if (error)
 			return error;
 
+		next_state = XFS_DAS_FOUND_NBLK;
 		error = xfs_attr_node_addname(attr);
-		if (error)
-			return error;
-
-		/*
-		 * If addname was successful, and we dont need to alloc or
-		 * remove anymore blks, we're done.
-		 */
-		if (!args->rmtblkno &&
-		    !(args->op_flags & XFS_DA_OP_RENAME))
-			return 0;
+	}
+	if (error)
+		return error;
 
-		attr->xattri_dela_state = XFS_DAS_FOUND_NBLK;
+	/*
+	 * We need to commit and roll if we need to allocate remote xattr blocks
+	 * or perform more xattr manipulations. Otherwise there is nothing more
+	 * to do and we can return success.
+	 */
+	if (args->rmtblkno ||
+	    (args->op_flags & XFS_DA_OP_RENAME)) {
+		attr->xattri_dela_state = next_state;
+		error = -EAGAIN;
 	}
 
+out:
 	trace_xfs_attr_leaf_addname_return(attr->xattri_dela_state, args->dp);
-	return -EAGAIN;
+	return error;
 }
 
 /*
-- 
2.35.1

