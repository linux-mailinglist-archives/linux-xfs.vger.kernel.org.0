Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3024AF60
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Jun 2019 03:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbfFSBNm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 21:13:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38994 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfFSBNm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 21:13:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5J14d0R192566;
        Wed, 19 Jun 2019 01:13:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Bx+P4mPuckqGg/eICPiddy0USLqW5O7zq2CDqL/SmmQ=;
 b=CZw/cFQ5uzpzmbzkzcBf3ndCsQRNY6uvky7bzFkTsMCKdQ9ORDnVWzMs41Lug1osJex0
 yZRES65HteVur/X8+pWPGv0CQ3tWLIt1QNCsgLeEJ/10ELyJTkLOeDNmCC8K6jFkjZEe
 d7D4GdL7honbZe7iuxWI+QJaZ/m7JbUP4YiYmMQlDSN2sZ8JEMaxGDmZNo5KjlcW8dR1
 08RJ6Ff3rtk6qZW8M5WqYw0Bs0k7fVNezY7mw2BOZ/blEONZhWaUaB5oJLmlA4r2mWAO
 4pHM7f7H4KHPTQyT8pn7tF3PswuaETKG4rsLmdSoxAf3vFmpBhEex5WtPtWDpOvxY4qI Dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t78098g7p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 01:13:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5J1D7N0188175;
        Wed, 19 Jun 2019 01:13:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2t77ymt0kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jun 2019 01:13:11 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5J1DAq5022968;
        Wed, 19 Jun 2019 01:13:10 GMT
Received: from localhost (/10.159.145.69)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 18:13:10 -0700
Date:   Tue, 18 Jun 2019 18:13:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <dchinner@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2] xfs: move xfs_ino_geometry to xfs_shared.h
Message-ID: <20190619011309.GT5387@magnolia>
References: <20190618205935.GS5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618205935.GS5387@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906190007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906190007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The inode geometry structure isn't related to ondisk format; it's
support for the mount structure.  Move it to xfs_shared.h.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: move it to xfs_shared.h, which now every file has to include
---
 fs/xfs/libxfs/xfs_dir2.c       |    1 +
 fs/xfs/libxfs/xfs_dir2_block.c |    1 +
 fs/xfs/libxfs/xfs_dir2_data.c  |    1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c  |    1 +
 fs/xfs/libxfs/xfs_dir2_node.c  |    1 +
 fs/xfs/libxfs/xfs_dir2_sf.c    |    1 +
 fs/xfs/libxfs/xfs_format.h     |   41 ---------------------------------------
 fs/xfs/libxfs/xfs_iext_tree.c  |    1 +
 fs/xfs/libxfs/xfs_inode_fork.c |    1 +
 fs/xfs/libxfs/xfs_shared.h     |   42 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_acl.c               |    1 +
 fs/xfs/xfs_attr_list.c         |    1 +
 fs/xfs/xfs_buf.c               |    1 +
 fs/xfs/xfs_buf_item.c          |    1 +
 fs/xfs/xfs_dir2_readdir.c      |    1 +
 fs/xfs/xfs_discard.c           |    1 +
 fs/xfs/xfs_dquot_item.c        |    1 +
 fs/xfs/xfs_error.c             |    1 +
 fs/xfs/xfs_export.c            |    1 +
 fs/xfs/xfs_filestream.c        |    1 +
 fs/xfs/xfs_icache.c            |    1 +
 fs/xfs/xfs_inode_item.c        |    1 +
 fs/xfs/xfs_ioctl32.c           |    1 +
 fs/xfs/xfs_message.c           |    1 +
 fs/xfs/xfs_pnfs.c              |    1 +
 fs/xfs/xfs_qm_bhv.c            |    1 +
 fs/xfs/xfs_quotaops.c          |    1 +
 fs/xfs/xfs_trans_ail.c         |    1 +
 fs/xfs/xfs_xattr.c             |    1 +
 29 files changed, 69 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 156ce95c9c45..b25f75032baa 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -5,6 +5,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index b7d6d78f4ce2..c73183373dd1 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -6,6 +6,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index b7b9ce002cb9..efbb009d3d65 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -6,6 +6,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 9c2a0a13ed61..ce75313d7ed6 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -6,6 +6,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 16731d2d684b..0a8fa453a7c6 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -6,6 +6,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 585dfdb7b6b6..57911731c516 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -5,6 +5,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 5729474e362f..c968b60cee15 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1694,45 +1694,4 @@ struct xfs_acl {
 #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
 #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
 
-struct xfs_ino_geometry {
-	/* Maximum inode count in this filesystem. */
-	uint64_t	maxicount;
-
-	/* Actual inode cluster buffer size, in bytes. */
-	unsigned int	inode_cluster_size;
-
-	/*
-	 * Desired inode cluster buffer size, in bytes.  This value is not
-	 * rounded up to at least one filesystem block, which is necessary for
-	 * the sole purpose of validating sb_spino_align.  Runtime code must
-	 * only ever use inode_cluster_size.
-	 */
-	unsigned int	inode_cluster_size_raw;
-
-	/* Inode cluster sizes, adjusted to be at least 1 fsb. */
-	unsigned int	inodes_per_cluster;
-	unsigned int	blocks_per_cluster;
-
-	/* Inode cluster alignment. */
-	unsigned int	cluster_align;
-	unsigned int	cluster_align_inodes;
-	unsigned int	inoalign_mask;	/* mask sb_inoalignmt if used */
-
-	unsigned int	inobt_mxr[2]; /* max inobt btree records */
-	unsigned int	inobt_mnr[2]; /* min inobt btree records */
-	unsigned int	inobt_maxlevels; /* max inobt btree levels. */
-
-	/* Size of inode allocations under normal operation. */
-	unsigned int	ialloc_inos;
-	unsigned int	ialloc_blks;
-
-	/* Minimum inode blocks for a sparse allocation. */
-	unsigned int	ialloc_min_blks;
-
-	/* stripe unit inode alignment */
-	unsigned int	ialloc_align;
-
-	unsigned int	agino_log;	/* #bits for agino in inum */
-};
-
 #endif /* __XFS_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
index bc690f2409fa..a2beca47eead 100644
--- a/fs/xfs/libxfs/xfs_iext_tree.c
+++ b/fs/xfs/libxfs/xfs_iext_tree.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include "xfs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_bit.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index f9acf1d436f6..642ef9ed5f57 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -7,6 +7,7 @@
 
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 4e909791aeac..b9094709bc79 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -136,4 +136,46 @@ void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
 xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
 
+/* Computed inode geometry for the filesystem. */
+struct xfs_ino_geometry {
+	/* Maximum inode count in this filesystem. */
+	uint64_t	maxicount;
+
+	/* Actual inode cluster buffer size, in bytes. */
+	unsigned int	inode_cluster_size;
+
+	/*
+	 * Desired inode cluster buffer size, in bytes.  This value is not
+	 * rounded up to at least one filesystem block, which is necessary for
+	 * the sole purpose of validating sb_spino_align.  Runtime code must
+	 * only ever use inode_cluster_size.
+	 */
+	unsigned int	inode_cluster_size_raw;
+
+	/* Inode cluster sizes, adjusted to be at least 1 fsb. */
+	unsigned int	inodes_per_cluster;
+	unsigned int	blocks_per_cluster;
+
+	/* Inode cluster alignment. */
+	unsigned int	cluster_align;
+	unsigned int	cluster_align_inodes;
+	unsigned int	inoalign_mask;	/* mask sb_inoalignmt if used */
+
+	unsigned int	inobt_mxr[2]; /* max inobt btree records */
+	unsigned int	inobt_mnr[2]; /* min inobt btree records */
+	unsigned int	inobt_maxlevels; /* max inobt btree levels. */
+
+	/* Size of inode allocations under normal operation. */
+	unsigned int	ialloc_inos;
+	unsigned int	ialloc_blks;
+
+	/* Minimum inode blocks for a sparse allocation. */
+	unsigned int	ialloc_min_blks;
+
+	/* stripe unit inode alignment */
+	unsigned int	ialloc_align;
+
+	unsigned int	agino_log;	/* #bits for agino in inum */
+};
+
 #endif /* __XFS_SHARED_H__ */
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 8039e35147dd..f6af069d4270 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -4,6 +4,7 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 3d213a7394c5..7ffee91a9fdb 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -6,6 +6,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index be8afa1673c7..e860114e8c9b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -22,6 +22,7 @@
 #include <linux/backing-dev.h>
 #include <linux/freezer.h>
 
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 65b32acfa0f6..3823f3f5bde9 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -5,6 +5,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 5142e64e2345..ea7b9d35d30b 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -6,6 +6,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index d0df0ed50f4b..4f5460be4357 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -4,6 +4,7 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 87b23ae44397..cd7142df596c 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -5,6 +5,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index a1e177f66404..7cc799b67232 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -4,6 +4,7 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_fs.h"
 #include "xfs_log_format.h"
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index f2284ceb129f..e179bea0474d 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -4,6 +4,7 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 182501373af2..b1869aebb263 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -5,6 +5,7 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index a76b27565a18..336501694443 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -5,6 +5,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index fa1c4fe2ffbf..957f3dca0d7a 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -5,6 +5,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 614fc6886d24..0f20385ec3c6 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -11,6 +11,7 @@
 #include <linux/fsmap.h>
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 6b736ea58d35..6cb1f2468dd0 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -6,6 +6,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_error.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index bde2c9f56a46..2d95355a8a0a 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -4,6 +4,7 @@
  */
 #include <linux/iomap.h>
 #include "xfs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 3091e4bc04ef..8f03478dabea 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -5,6 +5,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index a7c0c657dfaf..d453c2c32e04 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -4,6 +4,7 @@
  * All Rights Reserved.
  */
 #include "xfs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index d3a4e89bf4a0..58013696778d 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -6,6 +6,7 @@
  */
 #include "xfs.h"
 #include "xfs_fs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 9a63016009a1..3bf275fd7487 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -5,6 +5,7 @@
  */
 
 #include "xfs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
