Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2EFAAE53
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Sep 2019 00:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391133AbfIEWTO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Sep 2019 18:19:14 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58948 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391136AbfIEWTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:10 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ8ED049681
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=ibQn4FKM9LWoLP/zNCWW17MZHZ0LHoBacBvjrPhxrc0=;
 b=QgJY4gQKSGEEWti2EMbu/HRlHKr9KdOIGyZGxqy/oThLl793+qBdxjEY/Bbxc8AuVFts
 ms3zdEHGHvEGLRyZfY0UU+mH4hcA6m6vhgq2x5sfrsnlDU8vYV5w84IeeIAtEsN8iP+l
 N6Inuu+FIdqBFKuDu716moxYC9X67FVNwt/gb87FYmLtDvUG0z5ES4Bgtbbs6SRhtpxz
 MOfSFKVQ3GpcWwXtM+epui743sFSHoYbzSABKi8N+ffaaiV0vwRls0VsO3EQdsnf+1cv
 pAJoCZUxyh69YDUc38zt9Br6qSDYZtuAM0xFdIQCsvbJfQdVn9FmfRFzX92fs0CX4kpg ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2uuarc81yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIe7b123340
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:18:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2uthq27uw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:18:47 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MIlNa001627
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:18:47 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:18:46 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 10/19] xfs: Add xfs_attr3_leaf helper functions
Date:   Thu,  5 Sep 2019 15:18:28 -0700
Message-Id: <20190905221837.17388-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221837.17388-1-allison.henderson@oracle.com>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
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
 fs/xfs/libxfs/xfs_attr_leaf.c | 84 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |  2 ++
 2 files changed, 86 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index bcd86c3..79650c9 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2757,6 +2757,36 @@ xfs_attr3_leaf_clearflag(
 }
 
 /*
+ * Check if the INCOMPLETE flag on an entry in a leaf block is set.
+ */
+int
+xfs_attr3_leaf_flag_is_set(
+	struct xfs_da_args		*args,
+	bool				*isset)
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
+	*isset = ((entry->flags & XFS_ATTR_INCOMPLETE) != 0);
+	return 0;
+}
+
+/*
  * Set the INCOMPLETE flag on an entry in a leaf block.
  */
 int
@@ -2918,3 +2948,57 @@ xfs_attr3_leaf_flipflags(
 
 	return error;
 }
+
+/*
+ * On a leaf entry, check to see if the INCOMPLETE flag is cleared
+ * in args->blkno/index and set in args->blkno2/index2.
+ * Note that they could be in different blocks, or in the same block.
+ *
+ * isflipped is set to true if flags are flipped or false otherwise
+ */
+int
+xfs_attr3_leaf_flagsflipped(
+	struct xfs_da_args		*args,
+	bool				*isflipped)
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
+	*isflipped = (((entry1->flags & XFS_ATTR_INCOMPLETE) == 0) &&
+		      (entry2->flags & XFS_ATTR_INCOMPLETE));
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 58e9327..d82229b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -57,7 +57,9 @@ int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
 				   struct xfs_da_args *args, int forkoff);
 int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
 int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
+int	xfs_attr3_leaf_flag_is_set(struct xfs_da_args *args, bool *isset);
 int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
+int	xfs_attr3_leaf_flagsflipped(struct xfs_da_args *args, bool *isflipped);
 
 /*
  * Routines used for growing the Btree.
-- 
2.7.4

