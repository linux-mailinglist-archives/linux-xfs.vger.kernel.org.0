Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE34119E0C1
	for <lists+linux-xfs@lfdr.de>; Sat,  4 Apr 2020 00:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgDCWKT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 3 Apr 2020 18:10:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45572 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgDCWKS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:10:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M9hkC082617
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=18qPaK/I41bdYU32Ah32spUw/hkfTAW5rwSkwW1Mjbk=;
 b=NG0osAV6Wy7igJjULlehifYlJIxaaXJRPxnfKJbXjoza+9esvDHP5FSUE/WY9YXwUcET
 IGWY1RgWdCj0ZEChG2XwykNzTWrm3uA2AnCrdGy8tndx1WM2VL9jJ0dJx09dmvZ9Gdgx
 pCqOOd2bXzAntkKGd4jRDGw6F4+vQNSVD4JtURtvf6QzHL/C0iSUMTKjNXCzBcR0SDVJ
 arFD/+/5oP9sp1DwzQoERs6/CyspKlGOvuuwPcdv3b98biUviuXbPqnPrET/ypdcWkSt
 PoFr9Sz5kpOsDLlvHbRnF4/VO5dTpgrazXbLEpvX99br+yd6QMIz9LOcoiHB7MSclih3 dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 303cevkdhv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M7Kow167892
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 304sju4cg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:16 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033MAFlj028189
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:15 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:14 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 32/39] xfsprogs: Add helpers xfs_attr_is_shortform and xfs_attr_set_shortform
Date:   Fri,  3 Apr 2020 15:09:51 -0700
Message-Id: <20200403220958.4944-33-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In this patch, we hoist code from xfs_attr_set_args into two new helpers
xfs_attr_is_shortform and xfs_attr_set_shortform.  These two will help
to simplify xfs_attr_set_args when we get into delayed attrs later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 107 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 72 insertions(+), 35 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 5cca2c2..4dff0a5 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -205,6 +205,66 @@ xfs_attr_try_sf_addname(
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
+	      (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
+	      ip->i_d.di_anextents == 0);
+}
+
+/*
+ * Attempts to set an attr in shortform, or converts the tree to leaf form if
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
@@ -213,48 +273,25 @@ xfs_attr_set_args(
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
-
-		/*
-		 * Try to add the attr to the attribute list in the inode.
-		 */
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
+	if (xfs_attr_is_shortform(dp)) {
 
 		/*
-		 * Prevent the leaf buffer from being unlocked so that a
-		 * concurrent AIL push cannot grab the half-baked leaf
-		 * buffer and run into problems with the write verifier.
-		 * Once we're done rolling the transaction we can release
-		 * the hold and add the attr to the leaf.
+		 * If the attr was successfully set in shortform, the
+		 * transaction is committed and set to NULL.  Otherwise, is it
+		 * converted from shortform to leaf, and the transaction is
+		 * retained.
 		 */
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

