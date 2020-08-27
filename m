Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68466253AFD
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Aug 2020 02:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgH0A3O (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Aug 2020 20:29:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37656 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgH0A3N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:29:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0FgBd144946
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=/jamhobgKOZi/JwzvHuUc0/M1nZmo6I0Yweljtr20uY=;
 b=SxMKa3qnaclOQICeATKM5JoAWU7ZpprkYv35az/8Vx6AaSKAntimHCxoMcrk5DF62GDS
 ACnSxR8cCx2lNzaGxnxIHPASD0HkMF/uXT96XizByw9nQhP1rU41dGjKJwuELXWCu0Vv
 HFFSSjDu1quoWE7KPgkOml8i2XMGVYRq+OSi44HrYcnlAETTt4ttGCI/2qzT0VoVDq5e
 usoD4+c9ALX07rHajpAB/hDApldyY04CfYjUt1rYPSAWZVNLW4K2AzCcJTumpDtC/PD7
 Vj/LE3mWPG0AsP3/L7Wc+RlMm9sQxKKmkIMSd3Y3if0ZetJWgnuq+Aeyq+EQJOoWVfZP qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 333w6u1yvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0BMmQ038067
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 333r9mk52d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:11 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07R0TAIn016879
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:10 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:29:09 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 05/32] xfsprogs: Split apart xfs_attr_leaf_addname
Date:   Wed, 26 Aug 2020 17:28:29 -0700
Message-Id: <20200827002856.1131-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827002856.1131-1-allison.henderson@oracle.com>
References: <20200827002856.1131-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=1 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Split out new helper function xfs_attr_leaf_try_add from
xfs_attr_leaf_addname. Because new delayed attribute routines cannot
roll transactions, we split off the parts of xfs_attr_leaf_addname that
we can use, and move the commit into the calling function.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 95 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 34 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 1b65ad3..4f362b4 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -256,10 +256,31 @@ xfs_attr_set_args(
 		}
 	}
 
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_addname(args);
-	else
-		error = xfs_attr_node_addname(args);
+		if (error != -ENOSPC)
+			return error;
+
+		/*
+		 * Finish any deferred work items and roll the transaction once
+		 * more.  The goal here is to call node_addname with the inode
+		 * and transaction in the same state (inode locked and joined,
+		 * transaction clean) no matter how we got to this step.
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
+	}
+
+	error = xfs_attr_node_addname(args);
 	return error;
 }
 
@@ -507,20 +528,21 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
  *========================================================================*/
 
 /*
- * Add a name to the leaf attribute list structure
+ * Tries to add an attribute to an inode in leaf form
  *
- * This leaf block cannot have a "remote" value, we only call this routine
- * if bmap_one_block() says there is only one block (ie: no remote blks).
+ * This function is meant to execute as part of a delayed operation and leaves
+ * the transaction handling to the caller.  On success the attribute is added
+ * and the inode and transaction are left dirty.  If there is not enough space,
+ * the attr data is converted to node format and -ENOSPC is returned. Caller is
+ * responsible for handling the dirty inode and transaction or adding the attr
+ * in node format.
  */
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
@@ -562,31 +584,39 @@ xfs_attr_leaf_addname(
 	retval = xfs_attr3_leaf_add(bp, args);
 	if (retval == -ENOSPC) {
 		/*
-		 * Promote the attribute list to the Btree format, then
-		 * Commit that transaction so that the node_addname() call
-		 * can manage its own transactions.
+		 * Promote the attribute list to the Btree format. Unless an
+		 * error occurs, retain the -ENOSPC retval
 		 */
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
+	}
+	return retval;
+out_brelse:
+	xfs_trans_brelse(args->trans, bp);
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
+xfs_attr_leaf_addname(
+	struct xfs_da_args	*args)
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
@@ -681,9 +711,6 @@ xfs_attr_leaf_addname(
 		error = xfs_attr3_leaf_clearflag(args);
 	}
 	return error;
-out_brelse:
-	xfs_trans_brelse(args->trans, bp);
-	return retval;
 }
 
 /*
-- 
2.7.4

