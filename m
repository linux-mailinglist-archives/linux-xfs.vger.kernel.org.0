Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBB320A8EE
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jun 2020 01:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgFYX3q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Jun 2020 19:29:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49486 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731605AbgFYX3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:29:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNT2JU152844
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ZmSqPFhUbcEj35C+rrgr9IXfC7jjv5RfwaZRoDmzwSU=;
 b=usd+NoG5Ue7/djkW3ncFobLP0l3FENKObIqaJN2vZKGq2xj+YPA5uu5AD3mGAW93hXyr
 Aw0LKr+sUugecyoS40KQTWLrhFIVzX+T4T28w8HjO1d91r2QIPl7IR7lz0BAVR95sp0A
 J31nX+eBqAyIvYVjmYfsDfEljPmoJSqlNcPZ+9NaEM2/YXibDL2nKW3PsUJK6eMIuGIX
 g/8tqWZd9KXvq1JUuz1MJAmHk8aKXe12aOdY84GShKLTz5vHEgWJs3w4X9jLN2AZEAjS
 jbfnRqrExjCwTGEwIbq66tZxaENp9zTANxouS/8OuaWy3MTvKjz8UP5bTFXM1XYCsyLJ /A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31uusu3a9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSIhb110930
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31uur9r3e6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:01 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PNT0aV007681
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:00 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:29:00 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 07/26] xfsprogs: Refactor xfs_attr_try_sf_addname
Date:   Thu, 25 Jun 2020 16:28:29 -0700
Message-Id: <20200625232848.14465-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625232848.14465-1-allison.henderson@oracle.com>
References: <20200625232848.14465-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To help pre-simplify xfs_attr_set_args, we need to hoist transaction
handling up, while modularizing the adjacent code down into helpers. In
this patch, hoist the commit in xfs_attr_try_sf_addname up into the
calling function, and also pull the attr list creation down.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index d12cf0c..c1d1bfa 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -178,8 +178,13 @@ xfs_attr_try_sf_addname(
 	struct xfs_da_args	*args)
 {
 
-	struct xfs_mount	*mp = dp->i_mount;
-	int			error, error2;
+	int			error;
+
+	/*
+	 * Build initial attribute list (if required).
+	 */
+	if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
+		xfs_attr_shortform_create(args);
 
 	error = xfs_attr_shortform_addname(args);
 	if (error == -ENOSPC)
@@ -192,12 +197,10 @@ xfs_attr_try_sf_addname(
 	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
 		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args->trans);
 
-	error2 = xfs_trans_commit(args->trans);
-	args->trans = NULL;
-	return error ? error : error2;
+	return error;
 }
 
 /*
@@ -209,7 +212,7 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error;
+	int			error, error2 = 0;
 
 	/*
 	 * If the attribute list is non-existent or a shortform list,
@@ -220,17 +223,14 @@ xfs_attr_set_args(
 	     dp->i_d.di_anextents == 0)) {
 
 		/*
-		 * Build initial attribute list (if required).
-		 */
-		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
-			xfs_attr_shortform_create(args);
-
-		/*
 		 * Try to add the attr to the attribute list in the inode.
 		 */
 		error = xfs_attr_try_sf_addname(dp, args);
-		if (error != -ENOSPC)
-			return error;
+		if (error != -ENOSPC) {
+			error2 = xfs_trans_commit(args->trans);
+			args->trans = NULL;
+			return error ? error : error2;
+		}
 
 		/*
 		 * It won't fit in the shortform, transform to a leaf block.
-- 
2.7.4

