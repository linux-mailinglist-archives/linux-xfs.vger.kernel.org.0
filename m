Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C495243FB
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfETXQw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:16:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37968 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfETXQw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:16:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNDdj9148845;
        Mon, 20 May 2019 23:16:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=I7bBs7Pp4CXb4u2L0b2cYmvy0TI1U5RivE+qjJbLuSM=;
 b=g7w50XqQOPobxjlZC+WIYyipkPNNCxaYr8759TTyRGV4zqgyzToZDyQFvx/XH4N9vGat
 ixydRHvx5N+e26jbUucJGfkS6qJE6lrUahoiIVDd8ZmQbpYdfMmNomjezNfxckM6O+lG
 0alClmxL9VWZV+IOZCg0W1MCPEBYmeqGrsK2xnmBx/ZvkKzoX7PzBi9g7tap5W4rPxlZ
 JNAgBdBsh1hsZGnZnQJ0GHrQBrh8uBB9ABBICf+1IdOVDlpnXXCgLNgFHydGdOjYz/dx
 qWvPfwHyWa6PityqxUW8O7XO7wZHrgsTTmRTBi4CjxsVEpAlikEJKI7PzTH4NyH+hhf7 hA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2sjapq9u8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:16:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNFUsM118772;
        Mon, 20 May 2019 23:16:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2sks1xv84j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:16:49 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KNGmNU015206;
        Mon, 20 May 2019 23:16:48 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 23:16:48 +0000
Subject: [PATCH 01/12] libxfs: fix attr include mess
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 May 2019 16:16:47 -0700
Message-ID: <155839420721.68606.5873005194118073203.stgit@magnolia>
In-Reply-To: <155839420081.68606.4573219764134939943.stgit@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200142
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove all the userspace xfs_attr shim cruft so that we have one
definition of ATTR_* macros so that we can actually use xfs_attr.c
routines and include xfs_attr.h without problems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h         |   10 +---------
 libxfs/libxfs_api_defs.h |    5 +++++
 libxfs/libxfs_priv.h     |    8 --------
 libxfs/xfs_attr.c        |    1 +
 libxfs/xfs_attr_leaf.c   |    1 +
 5 files changed, 8 insertions(+), 17 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index 230bc3e8..dd5fe542 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -211,14 +211,6 @@ libxfs_bmbt_disk_get_all(
 int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
 bool libxfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 
-/* XXX: need parts of xfs_attr.h in userspace */
-#define LIBXFS_ATTR_ROOT	0x0002	/* use attrs in root namespace */
-#define LIBXFS_ATTR_SECURE	0x0008	/* use attrs in security namespace */
-#define LIBXFS_ATTR_CREATE	0x0010	/* create, but fail if attr exists */
-#define LIBXFS_ATTR_REPLACE	0x0020	/* set, but fail if attr not exists */
-
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 unsigned char *value, int valuelen, int flags);
+#include "xfs_attr.h"
 
 #endif	/* __LIBXFS_H__ */
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 1150ec93..34bb552d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -144,4 +144,9 @@
 #define xfs_fs_geometry			libxfs_fs_geometry
 #define xfs_init_local_fork		libxfs_init_local_fork
 
+#define LIBXFS_ATTR_ROOT		ATTR_ROOT
+#define LIBXFS_ATTR_SECURE		ATTR_SECURE
+#define LIBXFS_ATTR_CREATE		ATTR_CREATE
+#define LIBXFS_ATTR_REPLACE		ATTR_REPLACE
+
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index d668a157..f60bff06 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -104,14 +104,6 @@ extern char    *progname;
  */
 #define PTR_FMT "%p"
 
-/* XXX: need to push these out to make LIBXFS_ATTR defines */
-#define ATTR_ROOT			0x0002
-#define ATTR_SECURE			0x0008
-#define ATTR_CREATE			0x0010
-#define ATTR_REPLACE			0x0020
-#define ATTR_KERNOTIME			0
-#define ATTR_KERNOVAL			0
-
 #define XFS_IGET_CREATE			0x1
 #define XFS_IGET_UNTRUSTED		0x2
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index b8838302..170e64cf 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -20,6 +20,7 @@
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_remote.h"
 #include "xfs_trans_space.h"
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 679c7d0d..1027ca01 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -21,6 +21,7 @@
 #include "xfs_bmap.h"
 #include "xfs_attr_sf.h"
 #include "xfs_attr_remote.h"
+#include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_trace.h"
 #include "xfs_cksum.h"

