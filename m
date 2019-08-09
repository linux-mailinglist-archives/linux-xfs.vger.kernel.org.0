Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD530884C7
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbfHIVhp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:37:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58640 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbfHIVhp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:37:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYaqu084547
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=ePm1Za06ahq72J5ysnp102j3nMj03S+PjUjAvFT8Dro=;
 b=F5AMupE0Ea4pthgBBv0yfibIkYHLc/Jsaw4lqflHMsSDDKqPAANnfLWhBcCNAAWHXizh
 aJMm7xpQvoM6VQIvmjky09qZXGRAk4pkfaL0k6LSEncBKrgSEiZOekijXyzI7dRSPX/l
 QEZ2Z21SOsZHvbCp3qY08EpLTz8aUNbUoy8y2gRzi1xtY6LBBwEL68DtegnbGHJPlEIl
 t3nGaLl4MUBOSDVGZnk/4SWLaIB7gtdYMWQlOorQS35WbNX/RUEFi5Atik+usobJRCm2
 ifIi1tnOeuLMPIg/M2ewMfaCnO5Qy2ZSch3DRJLo2NX8KaUmgo8PSMPRGRbo08qIX+rh qQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=ePm1Za06ahq72J5ysnp102j3nMj03S+PjUjAvFT8Dro=;
 b=HulKORgYPSmbbRPX9BuVu0pTH2518XiNGjTLKHPSKaKtsuxcSZLd34wAdCn9iL7s7+9z
 f1l7O8anOCcfiM7/n6+Oj6aS1a1bUbyQiexkJCn6hga/SwO6WzoZdHXuWD2QIdrn/2JI
 pyxSLuVSrqchW+dgB4oV9E9R/0q3zk9QU+fwqHBS4kmh/xM7QweoNVSnZ1H9bXzX1G4k
 GW7pfiqvXKyRO+n1y+hTzhvKSfQGA9nhcZ1SO7WLlsCf4JaM3D2QFK7LlctHDsHtBih2
 XaBRbGq9wuL8Qo3sa6uVqRHt9zeYS3ORzaMx8JZzYDTzIxBs+mLjI4c4nAyDm6c1h2FQ cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u8hgpa7wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNbvY067904
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2u90t813x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79Lbhjs018991
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:37:35 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 08/18] xfs: Factor out xfs_attr_leaf_addname helper
Date:   Fri,  9 Aug 2019 14:37:16 -0700
Message-Id: <20190809213726.32336-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213726.32336-1-allison.henderson@oracle.com>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090207
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

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f36c792..f9d5e28 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -635,19 +635,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
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
 
@@ -692,13 +685,35 @@ xfs_attr_leaf_addname(
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

