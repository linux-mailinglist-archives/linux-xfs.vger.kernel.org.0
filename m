Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C39019E0D4
	for <lists+linux-xfs@lfdr.de>; Sat,  4 Apr 2020 00:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgDCWMl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 3 Apr 2020 18:12:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40532 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbgDCWMl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:12:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M9EBo019243
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=JBFLaDrSzT1iMqclHKl7ioL+fUH0QjMb/wXneEUj9L0=;
 b=PS3Mk5w6J4H4O3gh1RVSKmPgBYStXUU0zA4McfzHgvV8MunRDtMBflKkwxrCyYW187xI
 Z9zUMdUPY3zjo/xanoQoVnuhpG44kT3jp2QrTe7BzXm/wWZESbGVAlef0NbBTJCSEReh
 Gt9E3te3lB4m0gfMiOfB4P8Il1wjbcpSx1+u6FV6X91jThbjgU+RpnkVUtDble373OIf
 00Le1UD4GfDHQxKQhyySU5U1AHcgwantsSnTx5Y4a6SGP1I5rpJvUwA65B0J7YnPIsvB
 HF1/xtSA/IYWAa9sbbI/cEbvq3m1doEV5reYsi0jgarE3EMIUwKTPtPwWThRQmyZENIK UA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 303aqj3wbu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:12:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M7Bpf171152
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 302g2p2ej4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:12:40 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033MCd0X010798
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:39 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:12:39 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 05/20] xfs: Split apart xfs_attr_leaf_addname
Date:   Fri,  3 Apr 2020 15:12:14 -0700
Message-Id: <20200403221229.4995-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403221229.4995-1-allison.henderson@oracle.com>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
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
 fs/xfs/libxfs/xfs_attr.c | 94 ++++++++++++++++++++++++++++++------------------
 1 file changed, 60 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index d9a4dc8..45e6251 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -256,10 +256,30 @@ xfs_attr_set_args(
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
 
@@ -509,20 +529,21 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
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
@@ -564,31 +585,39 @@ xfs_attr_leaf_addname(
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
@@ -683,9 +712,6 @@ xfs_attr_leaf_addname(
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

