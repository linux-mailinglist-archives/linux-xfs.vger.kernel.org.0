Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B617572FE
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfFZUqf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:46:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51322 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfFZUqf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:46:35 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKht9m018308
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=l+OUXTuSZYJknKlChKmxP3SrJQwwHHx+UGEz7P1k8j8=;
 b=LspEt3/MVMEm6dkPac8zs7fE6mSt/yWAwqVPcnuSoM/TIeLTEAKdhWaPjjk/sGT/wIih
 cdZ6PeJfVK0mLCwGT4ZJUC+sqn/KtsulQbU7Xss+WTVZWsMhO8NrtiR0SeUImGlNPxah
 BHwjjZBwqPzVgsF3LdIBwu+H3sXCzNQ+5OPyOBsCshJJ3BA+1wXOV2s9LESMfezTYZwY
 K8Z6WoCrJrQ8XSRyJ0olPc7Ob6+qXpjl3RHvNrJOFXpoGkVN9JiD++L9BLfppkS288Mb
 juXYxZYPS7BYlRypK1tQToVf/wTa5n3ZYltGWiA7WOUtkoaqUcnUFh/rCei/gJ4LJSs9 wA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t9cyqmh4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKilWO012087
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2t9p6uyyt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:33 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5QKkWoW017515
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 13:46:32 -0700
Subject: [PATCH 9/9] xfs: allow bulkstat_single of special inodes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Wed, 26 Jun 2019 13:46:31 -0700
Message-ID: <156158199168.495715.1433536766420003523.stgit@magnolia>
In-Reply-To: <156158193320.495715.6675123051075804739.stgit@magnolia>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=954
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260240
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260240
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
 

