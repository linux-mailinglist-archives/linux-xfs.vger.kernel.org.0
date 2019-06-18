Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A18F4AC71
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 23:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbfFRVAN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 17:00:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33268 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730102AbfFRVAN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 17:00:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IKwsCM041021;
        Tue, 18 Jun 2019 20:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=snCLg8HBbCnQQjsPQ163H++E0G3NiYQvWaPrOLWccBo=;
 b=CWf1uDPr2h5jNvwdOEtQd/qPMKiBFNVrNqitPOJel7tejYmaZcnGz8s9xL6dT9/JcuIl
 QXppWCDCXrthbJ+VcJxnTWtO0UiXFAWuis8/zKgvwabJl4Cy+o1sBM380lG1Dkmb27o8
 rvsPT8glxJt9Gj18ZMbBQJUDTW7xaPGlndaFVSzKNZk3hBPWVgafVG8KkHuvaAFH6XxL
 1PinsxM9absRxeTqAMapoCXEC+pbAzxt/yg5CsXh01ke0yB6C+9/UEogFID+xOfRMNxJ
 O5BnQCNqblYJ36HIYdGaqP6hxTCxL92vJAmMYk53rDe3gmYtFS7au+Y5cgnJcFouuOha xA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t4saqeqts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 20:59:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IKx7La107937;
        Tue, 18 Jun 2019 20:59:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2t5h5tykru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 20:59:38 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5IKxbYL027279;
        Tue, 18 Jun 2019 20:59:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 13:59:36 -0700
Date:   Tue, 18 Jun 2019 13:59:36 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: [PATCH] xfs: move xfs_ino_geometry to xfs_mount.h
Message-ID: <20190618205935.GS5387@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180166
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The inode geometry structure isn't related to ondisk format; it's
support for the mount structure.  Move it to xfs_mount.h.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |   41 -----------------------------------------
 fs/xfs/xfs_mount.h         |   42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 41 deletions(-)

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
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 448986d260dd..7591c1b70e84 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -57,6 +57,48 @@ struct xfs_error_cfg {
 	long		retry_timeout;	/* in jiffies, -1 = infinite */
 };
 
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
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
