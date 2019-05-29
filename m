Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8CCC2E842
	for <lists+linux-xfs@lfdr.de>; Thu, 30 May 2019 00:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfE2W3a (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 May 2019 18:29:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44676 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfE2W33 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:29:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMTR40040715
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=DE7N9tNE281KHouxya99nFV6gH8yJGwmKM8fKyuh4CA=;
 b=ed/antAv181T0xEzUBq66o7flMeMWdKGfYLTFm1tn2o9hPei2eoZgHv6UDHOUTK2S5i0
 4u/hM+yLik89urzOQ82x9ALhyhdvQS+A7P8XZ27k41GMZyDYhdeN2TO9CeZF+DRYr2BC
 oNfhErZ83E2+b5EDH7OV21m8TRiTP8p7Kb5xqW0AeNSccrvYFQj64nJsvAy4Ct38bScH
 wCC5LAubrWR0+GpJBTjJ/HLp4VWPf2vR09i6ie1zQKKVTHbwiLz8HNQmIO05fqMajrt3
 WeprH0Yap+DyF9rFsDBPCcYI8RuzvkW1G7x4a4ayjnrxmQnTcf0CSI9JvHPkSoZAJWm3 5w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2spw4tmtm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:29:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMSx1d168476
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:28:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2sr31vh98s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:28:59 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4TMSaEp004507
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:28:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 15:28:36 -0700
Subject: [PATCH 9/9] xfs: allow bulkstat_single of special inodes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 May 2019 15:28:28 -0700
Message-ID: <155916890871.758159.15869425204728307163.stgit@magnolia>
In-Reply-To: <155916885106.758159.3471602893858635007.stgit@magnolia>
References: <155916885106.758159.3471602893858635007.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=917
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=950 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new ireq flag (for single bulkstats) that enables userspace to
ask us for a special inode number instead of interpreting @ino as a
literal inode number.  This enables us to query the root inode easily.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   11 ++++++++++-
 fs/xfs/xfs_ioctl.c     |   10 ++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 77c06850ac52..1826aa11b585 100644
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
+/* Return the root directory inode. */
+#define XFS_IREQ_SPECIAL_ROOT	(1)
 
 /*
  * ioctl structures for v5 bulkstat and inumbers requests
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index cf48a2bad325..605bfff3011f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -959,6 +959,16 @@ xfs_ireq_setup(
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
 

