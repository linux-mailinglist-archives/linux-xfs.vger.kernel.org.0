Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0A02DDF25
	for <lists+linux-xfs@lfdr.de>; Fri, 18 Dec 2020 08:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731526AbgLRHcE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 18 Dec 2020 02:32:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59876 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730054AbgLRHcE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:32:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7Tswe129632
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:31:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=bFOtxMHu1f1ryfu+v1VaVvk/RUNKG8fKqCjhEx5FsEs=;
 b=Jh2QoY5aY55TVG05XZX/ZToX+5swY1bigGH/fOPvuyMOCTJJTv74qpva/IYX7aHnbiGR
 529atkqByScmiDvMDbQGsyZQwspSgi5OjytIhGxoJwgWpbLQzUogXiFvkQMXpo3JlPqU
 93h78z0eiVUrFxk9nXLgEBni+HPd9mkP0V6DJURqlHX1hN+FDrN5hhh2CmGjVN1XfDuX
 +RqtrvQf9fSJVVR0OrhF4JcbjTWyFUkxszFr7IjbK9Osajg3qaB8kH9g0ozeybt6MtwC
 3HWqV1KJ5aM0GtBjhatjPGe5Utj6Gt6P41pplU1UUxu2u9CDbOLuuQf7hlVnggo+ztW/ zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35cntmgyf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:31:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7LK6B120978
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35e6eud9r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:23 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BI7TMY3004216
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:29:22 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:29:22 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 01/15] xfs: Add helper xfs_attr_node_remove_step
Date:   Fri, 18 Dec 2020 00:29:03 -0700
Message-Id: <20201218072917.16805-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218072917.16805-1-allison.henderson@oracle.com>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180053
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

This patch as a new helper function xfs_attr_node_remove_step.  This
will help simplify and modularize the calling function
xfs_attr_node_remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fd8e641..8b55a8d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1228,19 +1228,14 @@ xfs_attr_node_remove_rmt(
  * the root node (a special case of an intermediate node).
  */
 STATIC int
-xfs_attr_node_removename(
-	struct xfs_da_args	*args)
+xfs_attr_node_remove_step(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
 {
-	struct xfs_da_state	*state;
 	struct xfs_da_state_blk	*blk;
 	int			retval, error;
 	struct xfs_inode	*dp = args->dp;
 
-	trace_xfs_attr_node_removename(args);
-
-	error = xfs_attr_node_removename_setup(args, &state);
-	if (error)
-		goto out;
 
 	/*
 	 * If there is an out-of-line value, de-allocate the blocks.
@@ -1250,7 +1245,7 @@ xfs_attr_node_removename(
 	if (args->rmtblkno > 0) {
 		error = xfs_attr_node_remove_rmt(args, state);
 		if (error)
-			goto out;
+			return error;
 	}
 
 	/*
@@ -1267,18 +1262,45 @@ xfs_attr_node_removename(
 	if (retval && (state->path.active > 1)) {
 		error = xfs_da3_join(state);
 		if (error)
-			goto out;
+			return error;
 		error = xfs_defer_finish(&args->trans);
 		if (error)
-			goto out;
+			return error;
 		/*
 		 * Commit the Btree join operation and start a new trans.
 		 */
 		error = xfs_trans_roll_inode(&args->trans, dp);
 		if (error)
-			goto out;
+			return error;
 	}
 
+	return error;
+}
+
+/*
+ * Remove a name from a B-tree attribute list.
+ *
+ * This routine will find the blocks of the name to remove, remove them and
+ * shrink the tree if needed.
+ */
+STATIC int
+xfs_attr_node_removename(
+	struct xfs_da_args	*args)
+{
+	struct xfs_da_state	*state = NULL;
+	int			error;
+	struct xfs_inode	*dp = args->dp;
+
+	trace_xfs_attr_node_removename(args);
+
+	error = xfs_attr_node_removename_setup(args, &state);
+	if (error)
+		goto out;
+
+	error = xfs_attr_node_remove_step(args, state);
+	if (error)
+		goto out;
+
 	/*
 	 * If the result is small enough, push it all into the inode.
 	 */
-- 
2.7.4

