Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D10695F31C
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jul 2019 08:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbfGDGvb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 4 Jul 2019 02:51:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58610 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfGDGvb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jul 2019 02:51:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x646mja0153935
        for <linux-xfs@vger.kernel.org>; Thu, 4 Jul 2019 06:51:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=fxZjwaTpsFZK+7uK2e2tkWjhmy4u6cBBolcbQDQ+LDk=;
 b=faRRzrvebTV2G3IQw9rknP8hIGkpzDexgfhbecDV1sKGlfaRRkGOWw50TUHpa6+A60tV
 TQG8Qc7Q80U3uGybINOnEmVkQMp0ri0tMGzL0ATIE8EgPogw1DnV6O0ajtw5muuVh3rn
 0tZmNiFyW3rMQwoDLXjxcxnV9MRf29+BrOv9StV1yaZsS6ND1EDsRlH9GNRcT8xC9AH2
 TnwHuXkOB8O2hhqXI6BT33wOkXP7/7Q5QFjzbyevusCKDUvDI7Rtg/V7BxEjyu9uDu8O
 bMnobIeK/erM1k0FhDjEnHoMX6ink/PHu0SMKclgmgCqSRSxF1c6ZgBhz4JQZUEqhyye cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2te5tbw4c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Jul 2019 06:51:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x646m43l118858
        for <linux-xfs@vger.kernel.org>; Thu, 4 Jul 2019 06:51:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2tebbks85c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 04 Jul 2019 06:51:28 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x646pR8e027039
        for <linux-xfs@vger.kernel.org>; Thu, 4 Jul 2019 06:51:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jul 2019 23:51:27 -0700
Date:   Wed, 3 Jul 2019 23:51:24 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: [PATCH v3 9/9] xfs: allow bulkstat_single of special inodes
Message-ID: <20190704065124.GZ1404256@magnolia>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158199168.495715.1433536766420003523.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158199168.495715.1433536766420003523.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907040088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907040088
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new bulk ireq flag that enables userspace to ask us for a
special inode number instead of interpreting @ino as a literal inode
number.  This enables us to query the root inode easily.

The reason for adding the ability to query specifically the root
directory inode is that certain programs (xfsdump and xfsrestore) want
to confirm when they've been pointed to the root directory.  The
userspace code assumes the root directory is always the first result
from calling bulkstat with lastino == 0, but this isn't true if the
(initial btree roots + initial AGFL + inode alignment padding) is itself
long enough to be allocated to new inodes if all of those blocks should
happen to be free at the same time.  Rather than make userspace guess
at internal filesystem state, we provide a direct query.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
v3: attach to the bulkstat ioctl having dropped bulkstat_single
v2: elaborate on why we are adding this new ireq flag
---
 fs/xfs/libxfs/xfs_fs.h |   13 ++++++++++++-
 fs/xfs/xfs_ioctl.c     |   19 +++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d7b3b712b279..52d03a3a02a4 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -472,7 +472,18 @@ struct xfs_bulk_ireq {
  */
 #define XFS_BULK_IREQ_AGNO	(1 << 0)
 
-#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO)
+/*
+ * Return bulkstat information for a single inode, where @ino value is a
+ * special value, not a literal inode number.  See the XFS_BULK_IREQ_SPECIAL_*
+ * values below.  Not compatible with XFS_BULK_IREQ_AGNO.
+ */
+#define XFS_BULK_IREQ_SPECIAL	(1 << 1)
+
+#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
+				 XFS_BULK_IREQ_SPECIAL)
+
+/* Operate on the root directory inode. */
+#define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
 
 /*
  * ioctl structures for v5 bulkstat and inumbers requests
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e1e1d9d6c16d..6bf04e71325b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -853,6 +853,25 @@ xfs_bulk_ireq_setup(
 	breq->ocount = 0;
 	breq->flags = 0;
 
+	/*
+	 * The @ino parameter is a special value, so we must look it up here.
+	 * We're not allowed to have IREQ_AGNO, and we only return one inode
+	 * worth of data.
+	 */
+	if (hdr->flags & XFS_BULK_IREQ_SPECIAL) {
+		if (hdr->flags & XFS_BULK_IREQ_AGNO)
+			return -EINVAL;
+
+		switch (hdr->ino) {
+		case XFS_BULK_IREQ_SPECIAL_ROOT:
+			hdr->ino = mp->m_sb.sb_rootino;
+			break;
+		default:
+			return -EINVAL;
+		}
+		breq->icount = 1;
+	}
+
 	/*
 	 * The IREQ_AGNO flag means that we only want results from a given AG.
 	 * If @hdr->ino is zero, we start iterating in that AG.  If @hdr->ino is
