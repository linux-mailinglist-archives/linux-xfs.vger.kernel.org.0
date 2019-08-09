Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694AA884D4
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbfHIVhv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:37:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55558 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbfHIVhq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:37:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYahq092804
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=n/msSzhoQ9YeKf8Kpp6flbSvK9G/RrORdJKUAfa9zQo=;
 b=QvxMsoRd8yU0dPz0p7IyaGg4DfjoUDHWTmZkfQwhApQrWePhKPIcW0Eqt40IJdPfwGLW
 +X2FuGx3Tk2NVdOxpDSfkYb0wFRbFJX41dU01oAOYBSEKihlyqkXT6FX2zt2LNYw4v3B
 I7xjo5NnlKvcsjUDH1jpFulJhpQM1AabF0OI37MxivG+Q/+1e1uLMQ4km/Eu8XO6lPpl
 y7MZMIxfXnJ2iaQgLU4Y/uGTGkPQ4g2oExkjqk65MbAiK6aHYvzV4niY5EaybtkyW+cM
 CDz2yEib5HcbZGVNrI4C/ATgnnfNycF6V4A/xocus5qVk+zFovf4hzUQeFHEHx0BNh2J LA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=n/msSzhoQ9YeKf8Kpp6flbSvK9G/RrORdJKUAfa9zQo=;
 b=CfN53/liF7N+lQ8vWdq2qa/ps4+dLrJwIRJQmUzyd9JUJ4uMVx1mbBbF+ELY+pLAE02k
 xEEssoFaWW1ooo+rw/ZqjmASlmsS9oyDzB8u67ZLc8iBYc/C1hOYDyi/yd5oej/rVrgs
 /MLV8gwGr3/EZxHscJBr2v+5Sh05SSKHZ5CEq8Htfj2CfQWIPhNvEOKo4eIxkJixWeC7
 129LicQp2MX428LLGc5IKF4NPGxszhnHMQq7PnHLrfVW2NhisBpXA4yVXXb1V0eHbwyn
 JhMDtEsU94ttUCzeEGHA2ghrQ1bNGePrPdErDN2Cd5afgU2XRlAYl2jJw73Ze26QcOvQ Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u8hasj980-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNLFR071981
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2u8x9fxjwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79Lbhkr001881
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:37:36 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 11/18] xfs: Add xfs_attr3_leaf helper functions
Date:   Fri,  9 Aug 2019 14:37:19 -0700
Message-Id: <20190809213726.32336-12-allison.henderson@oracle.com>
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

And new helper functions xfs_attr3_leaf_flag_is_set and
xfs_attr3_leaf_flagsflipped.  These routines check to see
if xfs_attr3_leaf_setflag or xfs_attr3_leaf_flipflags have
already been run.  We will need this later for delayed
attributes since routines may be recalled several times
when -EAGAIN is returned.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 78 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |  2 ++
 2 files changed, 80 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 4a22ced..b2d5f62 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2729,6 +2729,34 @@ xfs_attr3_leaf_clearflag(
 }
 
 /*
+ * Check if the INCOMPLETE flag on an entry in a leaf block is set.
+ */
+int
+xfs_attr3_leaf_flag_is_set(
+	struct xfs_da_args		*args)
+{
+	struct xfs_attr_leafblock	*leaf;
+	struct xfs_attr_leaf_entry	*entry;
+	struct xfs_buf			*bp;
+	struct xfs_inode		*dp = args->dp;
+	int				error = 0;
+
+	trace_xfs_attr_leaf_setflag(args);
+
+	/*
+	 * Set up the operation.
+	 */
+	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno, -1, &bp);
+	if (error)
+		return error;
+
+	leaf = bp->b_addr;
+	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
+
+	return ((entry->flags & XFS_ATTR_INCOMPLETE) != 0);
+}
+
+/*
  * Set the INCOMPLETE flag on an entry in a leaf block.
  */
 int
@@ -2890,3 +2918,53 @@ xfs_attr3_leaf_flipflags(
 
 	return error;
 }
+
+/*
+ * On a leaf entry, check to see if the INCOMPLETE flag is cleared
+ * in args->blkno/index and set in args->blkno2/index2.
+ *
+ * Note that they could be in different blocks, or in the same block.
+ */
+int
+xfs_attr3_leaf_flagsflipped(
+	struct xfs_da_args		*args)
+{
+	struct xfs_attr_leafblock	*leaf1;
+	struct xfs_attr_leafblock	*leaf2;
+	struct xfs_attr_leaf_entry	*entry1;
+	struct xfs_attr_leaf_entry	*entry2;
+	struct xfs_buf			*bp1;
+	struct xfs_buf			*bp2;
+	struct xfs_inode		*dp = args->dp;
+	int				error = 0;
+
+	trace_xfs_attr_leaf_flipflags(args);
+
+	/*
+	 * Read the block containing the "old" attr
+	 */
+	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno, -1, &bp1);
+	if (error)
+		return error;
+
+	/*
+	 * Read the block containing the "new" attr, if it is different
+	 */
+	if (args->blkno2 != args->blkno) {
+		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno2,
+					   -1, &bp2);
+		if (error)
+			return error;
+	} else {
+		bp2 = bp1;
+	}
+
+	leaf1 = bp1->b_addr;
+	entry1 = &xfs_attr3_leaf_entryp(leaf1)[args->index];
+
+	leaf2 = bp2->b_addr;
+	entry2 = &xfs_attr3_leaf_entryp(leaf2)[args->index2];
+
+	return (((entry1->flags & XFS_ATTR_INCOMPLETE) == 0) &&
+		 (entry2->flags & XFS_ATTR_INCOMPLETE));
+}
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index be1f636..d6afe23 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -54,7 +54,9 @@ int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
 				   struct xfs_da_args *args, int forkoff);
 int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
 int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
+int	xfs_attr3_leaf_flag_is_set(struct xfs_da_args *args);
 int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
+int	xfs_attr3_leaf_flagsflipped(struct xfs_da_args *args);
 
 /*
  * Routines used for growing the Btree.
-- 
2.7.4

