Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2A3D41C9D
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 08:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391476AbfFLGuG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 02:50:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34898 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390376AbfFLGuG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:50:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6n0Gd055467
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:50:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=l+OUXTuSZYJknKlChKmxP3SrJQwwHHx+UGEz7P1k8j8=;
 b=Jvp6JzLJNGF/MWcEqiFUwBK4ChFU008pvbjAJe2Y8NQGVEEeXY2juD62IMwoPJ2l+VPW
 rTYpOG3sPRmvkycRqovvYyTAdg5JQ+KblR3gmtDKw5psgx/eYZdTqTXfC0bL5MuLR6de
 CK3PmcH77iug03pPL/u4gS+zBOz98SyKCLalHNI+gYzyN5LZyZ2C2JOHMBFdPuBWTVn/
 dTXNVRVq2JWnoUbRGMJdLM533BMArFJSBpTfSJBz1voKPiA4qJNTyuCgEGbvUpk/KRAL
 rdjsQlviVfp14d6tleUBA/o/ZCGz8iYfmuZNDvt2N371XyU0GZajOMNEFVzithdegpoK 8Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t05nqsby8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:50:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6mdHu099116
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:50:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2t0p9rq3a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:50:04 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5C6o3D9007490
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jun 2019 06:50:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Jun 2019 23:50:02 -0700
Subject: [PATCH 9/9] xfs: allow bulkstat_single of special inodes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Tue, 11 Jun 2019 23:50:01 -0700
Message-ID: <156032220182.3774581.1524699549367116132.stgit@magnolia>
In-Reply-To: <156032214432.3774581.1304900948974476604.stgit@magnolia>
References: <156032214432.3774581.1304900948974476604.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=949
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906120047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=988 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906120047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new ireq flag (for single bulkstats) that enables userspace to
ask us for a special inode number instead of interpreting @ino as a
literal inode number.  This enables us to query the root inode easily.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   11 ++++++++++-
 fs/xfs/xfs_ioctl.c     |   10 ++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 77c06850ac52..1489bce07d66 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -482,7 +482,16 @@ struct xfs_ireq {
 	uint64_t	reserved[2];	/* must be zero			*/
 };
 
-#define XFS_IREQ_FLAGS_ALL	(0)
+/*
+ * The @ino value is a special value, not a literal inode number.  See the
+ * XFS_IREQ_SPECIAL_* values below.
+ */
+#define XFS_IREQ_SPECIAL	(1 << 0)
+
+#define XFS_IREQ_FLAGS_ALL	(XFS_IREQ_SPECIAL)
+
+/* Operate on the root directory inode. */
+#define XFS_IREQ_SPECIAL_ROOT	(1)
 
 /*
  * ioctl structures for v5 bulkstat and inumbers requests
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f71341cd8340..3bb5f980fabf 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -961,6 +961,16 @@ xfs_ireq_setup(
 	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
 		return -EINVAL;
 
+	if (hdr->flags & XFS_IREQ_SPECIAL) {
+		switch (hdr->ino) {
+		case XFS_IREQ_SPECIAL_ROOT:
+			hdr->ino = mp->m_sb.sb_rootino;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
 	if (XFS_INO_TO_AGNO(mp, hdr->ino) >= mp->m_sb.sb_agcount)
 		return -EINVAL;
 

