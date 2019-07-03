Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B82B5E7EF
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jul 2019 17:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfGCPf0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Jul 2019 11:35:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47560 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfGCPf0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jul 2019 11:35:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x63FZ6Ou098239;
        Wed, 3 Jul 2019 15:35:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=+Duofk2LaQgf43e5fWyHB434Tzi9tgcRmG1NYsj0G/Y=;
 b=og1XjIufqXaTifIdYwf+uLNjiSUgDa3otNgykRtcT+e+6vj/wNbUOPrBU2XOofSZ39op
 K2cNGtcMUsmTkn8X6690+6NNCim0HrHQYHlQt95sFdVKaAPY/+Eg3hzf7C5eKhcmOrdN
 KfSZYJ2a+ufxryRLY9sTAAwyxpnfj6xcogkRQvRyjgpGpCosNKrFsQVd3rBmZ9YK+h5g
 SNjbfOznDuj3K+JUX92mshQjx+/ZzZQZgcZ2aSpFaO6vWJCoSbl4HGXjAbE5yvk8OV68
 rm//K48v91A6oFOrflrsrvFOL3mCamQD32S836xifc0YjJlO+TaD6bEMr4EDgjBzvEtp ZA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2te5tbt95g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jul 2019 15:35:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x63FXVQs102290;
        Wed, 3 Jul 2019 15:34:56 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tebbkejg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jul 2019 15:34:56 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x63FYtEw027636;
        Wed, 3 Jul 2019 15:34:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jul 2019 08:34:55 -0700
Date:   Wed, 3 Jul 2019 08:34:54 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 9/9] xfs: allow bulkstat_single of special inodes
Message-ID: <20190703153454.GX1404256@magnolia>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158199168.495715.1433536766420003523.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158199168.495715.1433536766420003523.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907030188
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907030189
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new ireq flag (for single bulkstats) that enables userspace to
ask us for a special inode number instead of interpreting @ino as a
literal inode number.  This enables us to query the root inode easily.

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
---
v2: elaborate on why we are adding this new ireq flag
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
index ba9a99b7860f..11ccfc5611bf 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -952,6 +952,16 @@ xfs_ireq_setup(
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
 
