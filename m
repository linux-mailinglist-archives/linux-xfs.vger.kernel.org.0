Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA8E55F0B
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 04:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfFZCh4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 22:37:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55216 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfFZCh4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 22:37:56 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q2YDJw030118;
        Wed, 26 Jun 2019 02:37:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=+vI36jMV6KI6wFDlqeGFdZtO1Y+Mm/yuNb4xLP7i4hQ=;
 b=sG/nOI7Z0ug/7+/3DP5o6LSxpumP8+fjGUymPOwzD5MWCz4RaAk9D295g5AhSwEBYxAT
 A4IeYK1Pl+WyRLhiCBRau7Ia/MJaW/7QibFtAwXegxdoU50zOViKTKqB0crLxKO2J59L
 U1IsBy9vb3fP4u29nZWB2Y7kG0YeP+7MVb7pK6SLVbJbh/a3bcWUZeSyP3mHvMrs/zFr
 SHcP17RQqUIGmWtLtsS6fHj8Tl4X5cJCziXlAT+nf2X7jVezYd0J27ikdZBXXzeNZNAU
 loPAbGKC643NFU6YepzF7HsBZr2ofUTp3eTDCK2vFB1OyWPNxFC/p1C4ghHAB6svK/T6 dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2t9c9pqjww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 02:37:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q2bb75088795;
        Wed, 26 Jun 2019 02:37:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tat7cjq8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 02:37:53 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5Q2brTG014211;
        Wed, 26 Jun 2019 02:37:53 GMT
Received: from localhost (/10.159.230.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Jun 2019 19:37:53 -0700
Subject: [PATCH 10/10] libxfs: move topology declarations into separate
 header
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 25 Jun 2019 19:37:52 -0700
Message-ID: <156151667233.2286979.9157937825247227178.stgit@magnolia>
In-Reply-To: <156151660523.2286979.13694849827562044045.stgit@magnolia>
References: <156151660523.2286979.13694849827562044045.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260028
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The topology functions live in libfrog now, which means their
declarations don't belong in libxcmd.h.  Create new header file for
them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxcmd.h  |   31 -------------------------------
 include/topology.h |   39 +++++++++++++++++++++++++++++++++++++++
 libfrog/topology.c |    1 +
 mkfs/xfs_mkfs.c    |    2 +-
 repair/sb.c        |    1 +
 5 files changed, 42 insertions(+), 32 deletions(-)
 create mode 100644 include/topology.h


diff --git a/include/libxcmd.h b/include/libxcmd.h
index 20e5d834..7b889b0a 100644
--- a/include/libxcmd.h
+++ b/include/libxcmd.h
@@ -10,35 +10,4 @@
 #include "libxfs.h"
 #include <sys/time.h>
 
-/*
- * Device topology information.
- */
-typedef struct fs_topology {
-	int	dsunit;		/* stripe unit - data subvolume */
-	int	dswidth;	/* stripe width - data subvolume */
-	int	rtswidth;	/* stripe width - rt subvolume */
-	int	lsectorsize;	/* logical sector size &*/
-	int	psectorsize;	/* physical sector size */
-} fs_topology_t;
-
-extern void
-get_topology(
-	libxfs_init_t		*xi,
-	struct fs_topology	*ft,
-	int			force_overwrite);
-
-extern void
-calc_default_ag_geometry(
-	int		blocklog,
-	uint64_t	dblocks,
-	int		multidisk,
-	uint64_t	*agsize,
-	uint64_t	*agcount);
-
-extern int
-check_overwrite(
-	const char	*device);
-
-
-
 #endif	/* __LIBXCMD_H__ */
diff --git a/include/topology.h b/include/topology.h
new file mode 100644
index 00000000..61ede23a
--- /dev/null
+++ b/include/topology.h
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+
+#ifndef __TOPOLOGY_H__
+#define __TOPOLOGY_H__
+
+/*
+ * Device topology information.
+ */
+typedef struct fs_topology {
+	int	dsunit;		/* stripe unit - data subvolume */
+	int	dswidth;	/* stripe width - data subvolume */
+	int	rtswidth;	/* stripe width - rt subvolume */
+	int	lsectorsize;	/* logical sector size &*/
+	int	psectorsize;	/* physical sector size */
+} fs_topology_t;
+
+extern void
+get_topology(
+	libxfs_init_t		*xi,
+	struct fs_topology	*ft,
+	int			force_overwrite);
+
+extern void
+calc_default_ag_geometry(
+	int		blocklog,
+	uint64_t	dblocks,
+	int		multidisk,
+	uint64_t	*agsize,
+	uint64_t	*agcount);
+
+extern int
+check_overwrite(
+	const char	*device);
+
+#endif	/* __TOPOLOGY_H__ */
diff --git a/libfrog/topology.c b/libfrog/topology.c
index cac164f3..e2f87415 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -10,6 +10,7 @@
 #  include <blkid/blkid.h>
 #endif /* ENABLE_BLKID */
 #include "xfs_multidisk.h"
+#include "topology.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 468b8fde..ade06bf6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -9,7 +9,7 @@
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
 #include "fsgeom.h"
-
+#include "topology.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
diff --git a/repair/sb.c b/repair/sb.c
index 119bf219..547969f7 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -12,6 +12,7 @@
 #include "protos.h"
 #include "err_protos.h"
 #include "xfs_multidisk.h"
+#include "topology.h"
 
 #define BSIZE	(1024 * 1024)
 

