Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5979533B97
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 00:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfFCWvY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 18:51:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48134 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfFCWvY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 18:51:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53MnOTt162199
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=pNFfEp0mJweWoWleC1XzVx0JIeza5LucdRz+VJEVgVc=;
 b=5jXZEwwI3RuirosJYG1tXZpH2UvTsKKbnpxLCmJV32vh26ZWyl0zHUCJuZLMNHb+pv4n
 PHE7IkiAAVJMXt/TiwxQSnlFLps/GoBoljtuvCW8w+Nx8r+472tAC3hGVYLJbUtfYyQ6
 nvWNIstHJfEJLwTnXJiLA1lmKfGhn4sSqqS9aHMQYq/SGcbbIv1YPXRdXQ/F4OL39jId
 MFmWI4E27IzGBTAwyNT70XKfta4HtFQvpcHhiy4ueLm9eEkXZX+U4xg0UldAgGr2S296
 xPMMkgDtVwBrcBiuC4r0xMwHo48OId9ZOyCBE0q4/gmQ8/POyTXas9y6dwV2ZM5N+hNQ Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sugst9sek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2019 22:51:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x53Mobmk032132
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2sv36sfgqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 03 Jun 2019 22:51:21 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x53MpK8d023679
        for <linux-xfs@vger.kernel.org>; Mon, 3 Jun 2019 22:51:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Jun 2019 15:51:20 -0700
Subject: [PATCH 3/5] xfs: hide inode geometry calculation helpers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 03 Jun 2019 15:51:18 -0700
Message-ID: <155960227849.1194435.1190279904778498264.stgit@magnolia>
In-Reply-To: <155960225918.1194435.11314723160642989835.stgit@magnolia>
References: <155960225918.1194435.11314723160642989835.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9277 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906030153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9277 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906030153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Hide all the inode geometry calculation helper functions since we now
cache all that in memory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ialloc.c |   23 +++++++++++++----------
 fs/xfs/libxfs/xfs_ialloc.h |   11 -----------
 2 files changed, 13 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 81d33ba10619..cff202d0ee4a 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -31,16 +31,23 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 
+/* Calculate and return the number of filesystem blocks per inode cluster */
+static inline int
+xfs_icluster_size_fsb(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_sb.sb_blocksize >= M_IGEO(mp)->inode_cluster_size)
+		return 1;
+	return M_IGEO(mp)->inode_cluster_size >> mp->m_sb.sb_blocklog;
+}
 
-/*
- * Allocation group level functions.
- */
-int
+/* Compute the required inode cluster alignment. */
+static inline int
 xfs_ialloc_cluster_alignment(
 	struct xfs_mount	*mp)
 {
 	if (xfs_sb_version_hasalign(&mp->m_sb) &&
-	    mp->m_sb.sb_inoalignmt >= xfs_icluster_size_fsb(mp))
+	    mp->m_sb.sb_inoalignmt >= M_IGEO(mp)->blocks_per_cluster)
 		return mp->m_sb.sb_inoalignmt;
 	return 1;
 }
@@ -2819,11 +2826,7 @@ xfs_ialloc_setup_geometry(
 			igeo->cluster_align);
 
 	/* Set whether we're using inode alignment. */
-	if (xfs_sb_version_hasalign(&mp->m_sb) &&
-		mp->m_sb.sb_inoalignmt >= xfs_icluster_size_fsb(mp))
-		igeo->inoalign_mask = mp->m_sb.sb_inoalignmt - 1;
-	else
-		igeo->inoalign_mask = 0;
+	igeo->inoalign_mask = igeo->cluster_align - 1;
 
 	/*
 	 * If we are using stripe alignment, check whether
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 455f65a2f1dd..2d61e0842f89 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -23,16 +23,6 @@ struct xfs_icluster {
 					 * sparse chunks */
 };
 
-/* Calculate and return the number of filesystem blocks per inode cluster */
-static inline int
-xfs_icluster_size_fsb(
-	struct xfs_mount	*mp)
-{
-	if (mp->m_sb.sb_blocksize >= M_IGEO(mp)->inode_cluster_size)
-		return 1;
-	return M_IGEO(mp)->inode_cluster_size >> mp->m_sb.sb_blocklog;
-}
-
 /*
  * Make an inode pointer out of the buffer/offset.
  */
@@ -160,7 +150,6 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
 		uint8_t count, int32_t freecount, xfs_inofree_t free,
 		int *stat);
 
-int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
 
 #endif	/* __XFS_IALLOC_H__ */

