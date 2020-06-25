Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F30320A8FF
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Jun 2020 01:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgFYXat (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Jun 2020 19:30:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52238 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbgFYXar (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:30:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSKLb012393
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=JucYqFuD2tv4WLGI9aFLvbjtivGt2zPX+aIgztbDtqM=;
 b=ObESL6A49J1FpQOVzYcHKa1tcnTChvmqwCbbWUk0UtTW5Fyl3NH3G8wqHFDE6zRQ2jw3
 0qalJXV/zsAdND0UkF7U2I2Lo89v/gIL4X8aKi+hNGcw0gS+4s9u6vgWG9EMR+aJIL7m
 ai9wSB2OA5tZ9rR48bKMN5UeXrzl9dCFXS7gDriifhGdV3hz8PnFm6NO3ozCEgBNp20n
 WAWl6xTUCwr7LIoCzfao5Kavc8FPQocUUmPI6X+ijH0S7Pf1ETNTS+tvs8vol3lTOIZh
 gjuOIUgNwjclWdEO9vlNrXvlTSBVBeOkK+MTqeIKZX2Gpm5FzFmh5N7QTFKAt49eGlvE fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31uustu9a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNS2Wj141104
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31uur1wctp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:45 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05PNUiUe017512
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:30:44 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:30:44 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 06/25] xfs: Refactor xfs_attr_try_sf_addname
Date:   Thu, 25 Jun 2020 16:29:59 -0700
Message-Id: <20200625233018.14585-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625233018.14585-1-allison.henderson@oracle.com>
References: <20200625233018.14585-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=1 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=1 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250136
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
 fs/xfs/libxfs/xfs_attr.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 6fc6dc6..9e1d389 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
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
+	if (dp->i_afp->if_format == XFS_DINODE_FMT_EXTENTS)
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
 	     dp->i_afp->if_nextents == 0)) {
 
 		/*
-		 * Build initial attribute list (if required).
-		 */
-		if (dp->i_afp->if_format == XFS_DINODE_FMT_EXTENTS)
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

