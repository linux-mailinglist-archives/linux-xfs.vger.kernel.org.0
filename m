Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0D10572F5
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFZUqE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:46:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49342 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFZUqE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:46:04 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKhw9t012242
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dWuwVG3zaUU+mvlsup2t5P9C5+sKTaHRxUwLg24oBI4=;
 b=PHh0wni9zGsBaCu1J1n1Qr6rpfwKFzsi2nWbXaaPSAgDxs0zS9vKZWKMFK9f0Ed9ca4u
 kePH1uvCHlvMBGSaX4gCgxURLV12cGIAYQnglL3ATIeTQrhOC1vmj5KsOXbnWgvdiPeY
 +zbD+llaxykyUADosNRFoUS4o2mvQi7A+tqSg5J67AWDkH05C2B/dfUf1y1UytF7/AHo
 cYT9k5x9vTvG3qbaCNG7BYBaNJASGLjO+HVfcUZ/R1DMsonKBkODaAzNPKQhj9aHO4/R
 NIkfM2vGXY6cKYWbbHvh0ahp9wv3ucwNzfvk2sSnFIjLRqFPBZLWhYSRptcFHBxkQYeK FA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t9brtcmv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKjt0X016120
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t99f4nw24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:02 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QKk1iv007605
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:46:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 13:46:01 -0700
Subject: [PATCH 4/9] xfs: introduce v5 inode group structure
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Wed, 26 Jun 2019 13:45:58 -0700
Message-ID: <156158195888.495715.17662104546912391174.stgit@magnolia>
In-Reply-To: <156158193320.495715.6675123051075804739.stgit@magnolia>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260240
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260240
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Introduce a new "v5" inode group structure that fixes the alignment
and padding problems of the existing structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   11 +++++++++++
 fs/xfs/xfs_ioctl.c     |    9 ++++++---
 fs/xfs/xfs_ioctl.h     |    2 +-
 fs/xfs/xfs_ioctl32.c   |   10 +++++++---
 fs/xfs/xfs_itable.c    |   14 +++++++++++++-
 fs/xfs/xfs_itable.h    |    4 +++-
 fs/xfs/xfs_ondisk.h    |    1 +
 7 files changed, 42 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 132e364eb141..8b8fe78511fb 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -445,6 +445,17 @@ struct xfs_inogrp {
 	__u64		xi_allocmask;	/* mask of allocated inodes	*/
 };
 
+/* New inumbers structure that reports v5 features and fixes padding issues */
+struct xfs_inumbers {
+	uint64_t	xi_startino;	/* starting inode number	*/
+	uint64_t	xi_allocmask;	/* mask of allocated inodes	*/
+	uint8_t		xi_alloccount;	/* # bits set in allocmask	*/
+	uint8_t		xi_version;	/* version			*/
+	uint8_t		xi_padding[6];	/* zero				*/
+};
+
+#define XFS_INUMBERS_VERSION_V1	(1)
+#define XFS_INUMBERS_VERSION_V5	(5)
 
 /*
  * Error injection.
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0b8c631d53dd..47580762e154 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -738,10 +738,13 @@ xfs_fsbulkstat_one_fmt(
 
 int
 xfs_fsinumbers_fmt(
-	struct xfs_ibulk	*breq,
-	const struct xfs_inogrp	*igrp)
+	struct xfs_ibulk		*breq,
+	const struct xfs_inumbers	*igrp)
 {
-	if (copy_to_user(breq->ubuffer, igrp, sizeof(*igrp)))
+	struct xfs_inogrp		ig1;
+
+	xfs_inumbers_to_inogrp(&ig1, igrp);
+	if (copy_to_user(breq->ubuffer, &ig1, sizeof(struct xfs_inogrp)))
 		return -EFAULT;
 	return xfs_ibulk_advance(breq, sizeof(struct xfs_inogrp));
 }
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 514d3028a134..654c0bb1bcf8 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -83,6 +83,6 @@ struct xfs_inogrp;
 
 int xfs_fsbulkstat_one_fmt(struct xfs_ibulk *breq,
 			   const struct xfs_bulkstat *bstat);
-int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
+int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inumbers *igrp);
 
 #endif
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index a97612927f9e..41485e2ed431 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -87,10 +87,14 @@ xfs_compat_growfs_rt_copyin(
 
 STATIC int
 xfs_fsinumbers_fmt_compat(
-	struct xfs_ibulk	*breq,
-	const struct xfs_inogrp	*igrp)
+	struct xfs_ibulk		*breq,
+	const struct xfs_inumbers	*ig)
 {
-	struct compat_xfs_inogrp __user *p32 = breq->ubuffer;
+	struct compat_xfs_inogrp __user	*p32 = breq->ubuffer;
+	struct xfs_inogrp		ig1;
+	struct xfs_inogrp		*igrp = &ig1;
+
+	xfs_inumbers_to_inogrp(&ig1, ig);
 
 	if (put_user(igrp->xi_startino,   &p32->xi_startino) ||
 	    put_user(igrp->xi_alloccount, &p32->xi_alloccount) ||
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 50c2bb8e13c4..745b04f59132 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -331,10 +331,11 @@ xfs_inumbers_walk(
 	const struct xfs_inobt_rec_incore *irec,
 	void			*data)
 {
-	struct xfs_inogrp	inogrp = {
+	struct xfs_inumbers	inogrp = {
 		.xi_startino	= XFS_AGINO_TO_INO(mp, agno, irec->ir_startino),
 		.xi_alloccount	= irec->ir_count - irec->ir_freecount,
 		.xi_allocmask	= ~irec->ir_free,
+		.xi_version	= XFS_INUMBERS_VERSION_V5,
 	};
 	struct xfs_inumbers_chunk *ic = data;
 	xfs_agino_t		agino;
@@ -381,3 +382,14 @@ xfs_inumbers(
 
 	return error;
 }
+
+/* Convert an inumbers (v5) struct to a inogrp (v1) struct. */
+void
+xfs_inumbers_to_inogrp(
+	struct xfs_inogrp		*ig1,
+	const struct xfs_inumbers	*ig)
+{
+	ig1->xi_startino = ig->xi_startino;
+	ig1->xi_alloccount = ig->xi_alloccount;
+	ig1->xi_allocmask = ig->xi_allocmask;
+}
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 60e259192056..fa9fb9104c7f 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -46,8 +46,10 @@ void xfs_bulkstat_to_bstat(struct xfs_mount *mp, struct xfs_bstat *bs1,
 		const struct xfs_bulkstat *bstat);
 
 typedef int (*inumbers_fmt_pf)(struct xfs_ibulk *breq,
-		const struct xfs_inogrp *igrp);
+		const struct xfs_inumbers *igrp);
 
 int xfs_inumbers(struct xfs_ibulk *breq, inumbers_fmt_pf formatter);
+void xfs_inumbers_to_inogrp(struct xfs_inogrp *ig1,
+		const struct xfs_inumbers *ig);
 
 #endif	/* __XFS_ITABLE_H__ */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 0b4cdda68524..d8f941b4d51c 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -148,6 +148,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
 
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
 }
 
 #endif /* __XFS_ONDISK_H */

