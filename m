Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E877211C4DB
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Dec 2019 05:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfLLESN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Dec 2019 23:18:13 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:50564 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbfLLESM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Dec 2019 23:18:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4EL4G144674
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=viQfTUyV8B97uQAEJoplxIXI3431uz8SiKBbhA/04UI=;
 b=pnnH4792Jl/Dgdj6qfGVuT0Quwk97wXL4D4ixraJypWTB9vzDxEcQzfVYYEw1qOK+HuX
 ZOu8yOsV9cuyvciQsneT8Rk40SAB5UmVJIhe6j0xwDp3WScFrkGWJmWPMIL7lb7YKFDW
 N1tVDFawGXXNa6/LTTwfho5AAOntovVAuk+s3JsmpOMWVrqFuWlz1DO6CKU+ZQdQBTa3
 oE/T3/zoHLbS4uyqRlgfzaA70mXm+2CC/xkD7v1x+J13uekwK8u57Cvmi7nrZn6DUPRG
 iMYL0JLaQ7wiqq7m6Yv3VDQMH44Sm78qE2aHFLaSeCnQDwbOT8gF2Wkk1yRFj0SB8Dao aQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wrw4ndbkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBC4E7S3128130
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2wu5cs3h2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:09 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xBC4I9C6016275
        for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2019 04:18:09 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Dec 2019 20:18:09 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 07/14] xfsprogs: Factor out xfs_attr_leaf_addname helper
Date:   Wed, 11 Dec 2019 21:17:56 -0700
Message-Id: <20191212041803.14018-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212041803.14018-1-allison.henderson@oracle.com>
References: <20191212041803.14018-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912120022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9468 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912120022
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Factor out new helper function xfs_attr_leaf_try_add.
Because new delayed attribute routines cannot roll
transactions, we carve off the parts of
xfs_attr_leaf_addname that we can use.  This will help
to reduce repetitive code later when we introduce
delayed attributes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 83 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 49 insertions(+), 34 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 32f6d8c..eb078e8 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -304,10 +304,30 @@ xfs_attr_set_args(
 		}
 	}
 
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_addname(args);
-	else
-		error = xfs_attr_node_addname(args);
+		if (error == 0 || error != -ENOSPC)
+			return 0;
+
+		/*
+		 * Commit that transaction so that the node_addname()
+		 * call can manage its own transactions.
+		 */
+		error = xfs_defer_finish(&args->trans);
+		if (error)
+			return error;
+
+		/*
+		 * Commit the current trans (including the inode) and
+		 * start a new one.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (error)
+			return error;
+
+	}
+
+	error = xfs_attr_node_addname(args);
 	return error;
 }
 
@@ -605,21 +625,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
  * External routines when attribute list is one block
  *========================================================================*/
 
-/*
- * Add a name to the leaf attribute list structure
- *
- * This leaf block cannot have a "remote" value, we only call this routine
- * if bmap_one_block() says there is only one block (ie: no remote blks).
- */
 STATIC int
-xfs_attr_leaf_addname(
-	struct xfs_da_args	*args)
+xfs_attr_leaf_try_add(
+	struct xfs_da_args	*args,
+	struct xfs_buf		*bp)
 {
-	struct xfs_buf		*bp;
-	int			retval, error, forkoff;
-	struct xfs_inode	*dp = args->dp;
-
-	trace_xfs_attr_leaf_addname(args);
+	int			retval, error;
 
 	/*
 	 * Look up the given attribute in the leaf block.  Figure out if
@@ -665,31 +676,35 @@ xfs_attr_leaf_addname(
 	retval = xfs_attr3_leaf_add(bp, args);
 	if (retval == -ENOSPC) {
 		/*
-		 * Promote the attribute list to the Btree format, then
-		 * Commit that transaction so that the node_addname() call
-		 * can manage its own transactions.
+		 * Promote the attribute list to the Btree format.
+		 * Unless an error occurs, retain the -ENOSPC retval
 		 */
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
+	}
+	return retval;
+}
 
-		/*
-		 * Commit the current trans (including the inode) and start
-		 * a new one.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
 
-		/*
-		 * Fob the whole rest of the problem off on the Btree code.
-		 */
-		error = xfs_attr_node_addname(args);
+/*
+ * Add a name to the leaf attribute list structure
+ *
+ * This leaf block cannot have a "remote" value, we only call this routine
+ * if bmap_one_block() says there is only one block (ie: no remote blks).
+ */
+STATIC int
+xfs_attr_leaf_addname(struct xfs_da_args	*args)
+{
+	int			error, forkoff;
+	struct xfs_buf		*bp = NULL;
+	struct xfs_inode	*dp = args->dp;
+
+	trace_xfs_attr_leaf_addname(args);
+
+	error = xfs_attr_leaf_try_add(args, bp);
+	if (error)
 		return error;
-	}
 
 	/*
 	 * Commit the transaction that added the attr name so that
-- 
2.7.4

