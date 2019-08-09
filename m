Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0AF884E8
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbfHIVi1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:38:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50496 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfHIVi0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYeLw071951
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=SXsCphdU7fwJh4qDXcu0Lu4A/kGZcPhhMrj9JrKXn/4=;
 b=GycBstdvmZTWX1/ooJEkczNokcqseVysuMxYQiwFYeSt9eSV6rBY1p3B9PimF8ENoH7w
 FnKnCSshs3quty1jwsOsDHljRl+j0ctxx5A6X/C+ajn1idkWpKKuA7RK7GiO2RN0t4Hg
 3vYgM7SDrlJYxnmMd3XtsY347FLLQmYWqOKJ6Os2hDa/LeGdB/8vXoBRALH5KSxgnaLF
 dAMJxzEz3cEe+9tlkDiLzll7afmy2CYc03/VYiBkThWpRjMrhUFlegskngbyR204n34d
 JcEy5rat3ZK6J0K/y5rCVpH+mZOygAvvT+juPEALIWqf+W4DZ33abGimRlDR5U+loBQ8 TQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=SXsCphdU7fwJh4qDXcu0Lu4A/kGZcPhhMrj9JrKXn/4=;
 b=AW3qQ20aFlswSWJWp7zUlkVFAJTtuyv0jdjKNjK5Mvc0YeYfFf2+RsSSyT6pEgQqY2iP
 FBrlOXjpA/kqnVohwfGDqAI+Udp1QTI30japuJcRxewbMG5n5GhGLfcV/6Tm5+c3ludl
 fDhR1Pt6oJM7IynowU91xHmJr3FtXk/D2BrSZfE1llWnKRpUOOXOVzwibNYW2yBQPbYF
 /YUPBalWtrL6twQ5dEmdWNX/CSYm8PDEnKxyrwK6x75+WhKP56yycxsT5E6XpYdLqKBX
 Qc7erJZWzYuVH42f/pgrNOaSc0ibRDWa4Ap+4ttbBPZ2u2Pu0531ZHjZJEdO9WA/Q3cp vA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u8hpsa4ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LcOFa112155
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2u8x9fxkac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:24 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x79LcJs1010605
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:19 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:18 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 08/19] xfsprogs: Factor out xfs_attr_leaf_addname helper
Date:   Fri,  9 Aug 2019 14:37:53 -0700
Message-Id: <20190809213804.32628-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213804.32628-1-allison.henderson@oracle.com>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090208
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

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 8b3d6a3..3b7baba 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -636,19 +636,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
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
+	int			retval, error;
 
 	trace_xfs_attr_leaf_addname(args);
 
@@ -693,13 +686,35 @@ xfs_attr_leaf_addname(
 	retval = xfs_attr3_leaf_add(bp, args);
 	if (retval == -ENOSPC) {
 		/*
-		 * Promote the attribute list to the Btree format, then
-		 * Commit that transaction so that the node_addname() call
-		 * can manage its own transactions.
+		 * Promote the attribute list to the Btree format,
 		 */
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
+	}
+	return retval;
+}
+
+
+/*
+ * Add a name to the leaf attribute list structure
+ *
+ * This leaf block cannot have a "remote" value, we only call this routine
+ * if bmap_one_block() says there is only one block (ie: no remote blks).
+ */
+STATIC int
+xfs_attr_leaf_addname(struct xfs_da_args	*args)
+{
+	int retval, error, forkoff;
+	struct xfs_buf		*bp = NULL;
+	struct xfs_inode	*dp = args->dp;
+
+	retval = xfs_attr_leaf_try_add(args, bp);
+	if (retval == -ENOSPC) {
+		/*
+		 * Commit that transaction so that the node_addname() call
+		 * can manage its own transactions.
+		 */
 		error = xfs_defer_finish(&args->trans);
 		if (error)
 			return error;
-- 
2.7.4

