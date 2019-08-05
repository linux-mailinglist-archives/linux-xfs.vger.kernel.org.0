Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7604780FC6
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Aug 2019 02:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfHEAgU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 4 Aug 2019 20:36:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44444 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfHEAgT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 20:36:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750O2VF098591
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=3vFdrTJlF/aYCUaBOMmtYG6PjGMhDiOPj9O0i4creGs=;
 b=NM30ihazh7T9YCzkiBDDUJHqqG31BvSSnhaVLk/PhmMXLI6Db7laOChQtzRS4FrbglIn
 yFVcGnOg2NeUBNAeHTY86rmTd+nMMpWQBpXnMt62ZH3oZ/WISCVa+4qRjQKD6vBJRcJL
 6GgY19Ap+MOB5OwvEfyqJMMJIQo3+zSUmRQ/qAyBGG/c52g/DLWFjKzCl/mAz1yAwx0p
 93KvurgLvwKGoQoxeKFoRd/WPkegW5ZMMi/u4R8fsYPUiMd3J4u0LwMnPHGHM1E3W9OC
 WhQP8SiTMrAlG2qVFOlJlfizFVLfA6AwVrCjvwcXYA/OOd/VDi6rdjwQRWzixhHBUZjP wQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2u527pc79m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:36:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x750MxwI195534
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2u4ycttw47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 05 Aug 2019 00:36:17 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x750aGGh032590
        for <linux-xfs@vger.kernel.org>; Mon, 5 Aug 2019 00:36:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 04 Aug 2019 17:36:16 -0700
Subject: [PATCH 14/18] xfs: create a new inode fork block unmap helper
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 04 Aug 2019 17:36:15 -0700
Message-ID: <156496537574.804304.2999472347978574569.stgit@magnolia>
In-Reply-To: <156496528310.804304.8105015456378794397.stgit@magnolia>
References: <156496528310.804304.8105015456378794397.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9339 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9339 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new helper to unmap blocks from an inode's fork.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h |    3 +++
 fs/xfs/xfs_inode.c       |   29 ++++-------------------------
 3 files changed, 50 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 39dbc93374dc..5be389bfaf3f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6227,3 +6227,46 @@ xfs_bmap_validate_extent(
 	return xfs_bmap_validate_extent_raw(ip->i_mount,
 			XFS_IS_REALTIME_INODE(ip), whichfork, irec);
 }
+
+/*
+ * Used in xfs_itruncate_extents().  This is the maximum number of extents
+ * freed from a file in a single transaction.
+ */
+#define	XFS_ITRUNC_MAX_EXTENTS	2
+
+/*
+ * Unmap every extent in part of an inode's fork.  We don't do any higher level
+ * invalidation work at all.
+ */
+int
+xfs_bunmapi_range(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip,
+	int			whichfork,
+	xfs_fileoff_t		startoff,
+	xfs_filblks_t		unmap_len,
+	int			bunmapi_flags)
+{
+	int			error = 0;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	bunmapi_flags |= xfs_bmapi_aflag(whichfork);
+	while (unmap_len > 0) {
+		ASSERT((*tpp)->t_firstblock == NULLFSBLOCK);
+		error = __xfs_bunmapi(*tpp, ip, startoff, &unmap_len,
+				bunmapi_flags, XFS_ITRUNC_MAX_EXTENTS);
+		if (error)
+			goto out;
+
+		/*
+		 * Duplicate the transaction that has the permanent
+		 * reservation and commit the old transaction.
+		 */
+		error = xfs_defer_finish(tpp);
+		if (error)
+			goto out;
+	}
+out:
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b857762fac55..cf460d3654b5 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -279,5 +279,8 @@ xfs_failaddr_t xfs_bmap_validate_extent(struct xfs_inode *ip, int whichfork,
 int	xfs_bmapi_remap(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, xfs_fsblock_t startblock,
 		int flags);
+int	xfs_bunmapi_range(struct xfs_trans **tpp, struct xfs_inode *ip,
+		int whichfork, xfs_fileoff_t startoff, xfs_filblks_t unmap_len,
+		int bunmapi_flags);
 
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index acb9335e6306..4a7b0ea22fa3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -38,12 +38,6 @@
 
 kmem_zone_t *xfs_inode_zone;
 
-/*
- * Used in xfs_itruncate_extents().  This is the maximum number of extents
- * freed from a file in a single transaction.
- */
-#define	XFS_ITRUNC_MAX_EXTENTS	2
-
 STATIC int xfs_iflush_int(struct xfs_inode *, struct xfs_buf *);
 STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
 STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
@@ -1514,7 +1508,6 @@ xfs_itruncate_extents_flags(
 	struct xfs_trans	*tp = *tpp;
 	xfs_fileoff_t		first_unmap_block;
 	xfs_fileoff_t		last_block;
-	xfs_filblks_t		unmap_len;
 	int			error = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -1528,8 +1521,6 @@ xfs_itruncate_extents_flags(
 
 	trace_xfs_itruncate_extents_start(ip, new_size);
 
-	flags |= xfs_bmapi_aflag(whichfork);
-
 	/*
 	 * Since it is possible for space to become allocated beyond
 	 * the end of the file (in a crash where the space is allocated
@@ -1545,22 +1536,10 @@ xfs_itruncate_extents_flags(
 		return 0;
 
 	ASSERT(first_unmap_block < last_block);
-	unmap_len = last_block - first_unmap_block + 1;
-	while (unmap_len > 0) {
-		ASSERT(tp->t_firstblock == NULLFSBLOCK);
-		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
-				flags, XFS_ITRUNC_MAX_EXTENTS);
-		if (error)
-			goto out;
-
-		/*
-		 * Duplicate the transaction that has the permanent
-		 * reservation and commit the old transaction.
-		 */
-		error = xfs_defer_finish(&tp);
-		if (error)
-			goto out;
-	}
+	error = xfs_bunmapi_range(&tp, ip, whichfork, first_unmap_block,
+			last_block - first_unmap_block + 1, flags);
+	if (error)
+		goto out;
 
 	if (whichfork == XFS_DATA_FORK) {
 		/* Remove all pending CoW reservations. */

