Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E342E1C0AB4
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 00:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgD3Wuj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 30 Apr 2020 18:50:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33062 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgD3Wui (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:50:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMlZkW067016
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=bMTa+pI2EYoAhu2AFpJwO+6/D7VilvLkCnONurWnGIc=;
 b=rPwxppL7R1JxjBm0FKJn7pWDchs/gWFd5mL7CKR9QTkNFbY0/+BKaWy9WUa2fRvU6QdX
 Xf+glHmRQ28QGSLxJdcIIDiiFsyjDHRBQSAvApo/CPWt2grWJ1Os3ppJrHDizOXDIHIb
 Alor6wzpwvXrCyn/yD614a+qH7TwiVlA+NQKpbhNwjPklLB9vA5/lxXrtNYZ97H6YwCo
 1IpTh4ivgzoCGw1m8DaT7bUrPxNcCPsR0+S2NASYB3kthpaK/RCxpoEeK8Qv3OTOkFyQ
 Xp2c1h2k+vjCUfMBQAZGOMU8ww+VOj9zWKYQ3rX1E7QtpnFgNZcmWRJQKx86zWL4fMm0 XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30r7f802jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgKl2141696
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30qtg23n55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:36 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMoa2W013833
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:36 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:50:35 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 14/24] xfs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
Date:   Thu, 30 Apr 2020 15:50:06 -0700
Message-Id: <20200430225016.4287-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430225016.4287-1-allison.henderson@oracle.com>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=1 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In this patch, we hoist code from xfs_attr_set_args into two new helpers
xfs_attr_is_shortform and xfs_attr_set_shortform.  These two will help
to simplify xfs_attr_set_args when we get into delayed attrs later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 107 +++++++++++++++++++++++++++++++----------------
 1 file changed, 72 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index af47566..d112910 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -204,6 +204,66 @@ xfs_attr_try_sf_addname(
 }
 
 /*
+ * Check to see if the attr should be upgraded from non-existent or shortform to
+ * single-leaf-block attribute list.
+ */
+static inline bool
+xfs_attr_is_shortform(
+	struct xfs_inode    *ip)
+{
+	return ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
+	       (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
+	        ip->i_d.di_anextents == 0);
+}
+
+/*
+ * Attempts to set an attr in shortform, or converts short form to leaf form if
+ * there is not enough room.  If the attr is set, the transaction is committed
+ * and set to NULL.
+ */
+STATIC int
+xfs_attr_set_shortform(
+	struct xfs_da_args	*args,
+	struct xfs_buf		**leaf_bp)
+{
+	struct xfs_inode	*dp = args->dp;
+	int			error, error2 = 0;
+
+	/*
+	 * Try to add the attr to the attribute list in the inode.
+	 */
+	error = xfs_attr_try_sf_addname(dp, args);
+	if (error != -ENOSPC) {
+		error2 = xfs_trans_commit(args->trans);
+		args->trans = NULL;
+		return error ? error : error2;
+	}
+	/*
+	 * It won't fit in the shortform, transform to a leaf block.  GROT:
+	 * another possible req'mt for a double-split btree op.
+	 */
+	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	if (error)
+		return error;
+
+	/*
+	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
+	 * push cannot grab the half-baked leaf buffer and run into problems
+	 * with the write verifier. Once we're done rolling the transaction we
+	 * can release the hold and add the attr to the leaf.
+	 */
+	xfs_trans_bhold(args->trans, *leaf_bp);
+	error = xfs_defer_finish(&args->trans);
+	xfs_trans_bhold_release(args->trans, *leaf_bp);
+	if (error) {
+		xfs_trans_brelse(args->trans, *leaf_bp);
+		return error;
+	}
+
+	return 0;
+}
+
+/*
  * Set the attribute specified in @args.
  */
 int
@@ -212,48 +272,25 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error, error2 = 0;
+	int			error = 0;
 
 	/*
-	 * If the attribute list is non-existent or a shortform list,
-	 * upgrade it to a single-leaf-block attribute list.
+	 * If the attribute list is already in leaf format, jump straight to
+	 * leaf handling.  Otherwise, try to add the attribute to the shortform
+	 * list; if there's no room then convert the list to leaf format and try
+	 * again.
 	 */
-	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
-	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     dp->i_d.di_anextents == 0)) {
+	if (xfs_attr_is_shortform(dp)) {
 
 		/*
-		 * Try to add the attr to the attribute list in the inode.
+		 * If the attr was successfully set in shortform, the
+		 * transaction is committed and set to NULL.  Otherwise, is it
+		 * converted from shortform to leaf, and the transaction is
+		 * retained.
 		 */
-		error = xfs_attr_try_sf_addname(dp, args);
-		if (error != -ENOSPC) {
-			error2 = xfs_trans_commit(args->trans);
-			args->trans = NULL;
-			return error ? error : error2;
-		}
-
-		/*
-		 * It won't fit in the shortform, transform to a leaf block.
-		 * GROT: another possible req'mt for a double-split btree op.
-		 */
-		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
-		if (error)
-			return error;
-
-		/*
-		 * Prevent the leaf buffer from being unlocked so that a
-		 * concurrent AIL push cannot grab the half-baked leaf
-		 * buffer and run into problems with the write verifier.
-		 * Once we're done rolling the transaction we can release
-		 * the hold and add the attr to the leaf.
-		 */
-		xfs_trans_bhold(args->trans, leaf_bp);
-		error = xfs_defer_finish(&args->trans);
-		xfs_trans_bhold_release(args->trans, leaf_bp);
-		if (error) {
-			xfs_trans_brelse(args->trans, leaf_bp);
+		error = xfs_attr_set_shortform(args, &leaf_bp);
+		if (error || !args->trans)
 			return error;
-		}
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
-- 
2.7.4

