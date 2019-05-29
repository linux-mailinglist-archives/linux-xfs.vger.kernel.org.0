Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1E52E83A
	for <lists+linux-xfs@lfdr.de>; Thu, 30 May 2019 00:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfE2W2U (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 May 2019 18:28:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56510 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbfE2W2U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:28:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TM3h6I030343
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:28:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=3YI2POuhiI8u91Iw8jqy21cP5O83l9qIRWWrvWzvzP8=;
 b=3d0Ri59UOESS75xIcKYh1sr/4tuVcA545fMKUhPCVge/YSAohWIcVkTPP5n/NeF5viMM
 O54odAi7YsNE36mL0rGQuh+atCRESrv/IoueLWsDEPyxKIotgymWN1Gw11m+0ctJS4zO
 wy+eLEoowjVzLIOXk1C0Vq1zlSYQQWxxg/z5XjjFt1/oQ1TVCvtmkj3zQ/bjW0q5Ebg7
 ZzoIhTNBlK9OHicAUVqcMo79gu/W+G+ygM8N3+Fy2ZKL1vNdyG3INSZJjEhtNA6aaxk5
 fIN/mmop2lUhTqXIPb9NGSHD2yMzEJUUVo0wgWm2ptDhhMcfLylk1AZja74p4nPP0KJw jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2spxbqcpaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:28:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMQOSC172659
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:28:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2sqh73ym88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:28:17 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4TMSHos023545
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:28:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 15:28:17 -0700
Subject: [PATCH 7/9] xfs: wire up the v5 INUMBERS ioctl
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 May 2019 15:28:15 -0700
Message-ID: <155916889587.758159.4685292951595604048.stgit@magnolia>
In-Reply-To: <155916885106.758159.3471602893858635007.stgit@magnolia>
References: <155916885106.758159.3471602893858635007.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Wire up the v5 INUMBERS ioctl and rename the old one to v1.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |    8 ++++++++
 fs/xfs/xfs_ioctl.c     |   51 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl32.c   |    1 +
 fs/xfs/xfs_ondisk.h    |    1 +
 4 files changed, 61 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 95d0411dae9b..f9f35139d4b7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -493,6 +493,13 @@ struct xfs_bulkstat_single_req {
 	struct xfs_bulkstat	bulkstat;
 };
 
+struct xfs_inumbers_req {
+	struct xfs_bulk_ireq	hdr;
+	struct xfs_inumbers	inumbers[];
+};
+#define XFS_INUMBERS_REQ_SIZE(nr)	(sizeof(struct xfs_inumbers_req) + \
+					 (nr) * sizeof(struct xfs_inumbers))
+
 /*
  * Error injection.
  */
@@ -796,6 +803,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_BULKSTAT_SINGLE	     _IOR ('X', 128, struct xfs_bulkstat_single_req)
+#define XFS_IOC_INUMBERS	     _IOR ('X', 129, struct xfs_inumbers_req)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f6971eb9561e..294039c2ea75 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1006,6 +1006,55 @@ xfs_ioc_bulkstat_single(
 	return 0;
 }
 
+STATIC int
+xfs_inumbers_fmt(
+	struct xfs_ibulk		*breq,
+	const struct xfs_inumbers	*igrp)
+{
+	if (copy_to_user(breq->ubuffer, igrp, sizeof(struct xfs_inumbers)))
+		return -EFAULT;
+	return xfs_ibulk_advance(breq, sizeof(struct xfs_inumbers));
+}
+
+/* Handle the v5 inumbers ioctl. */
+STATIC int
+xfs_ioc_inumbers(
+	struct xfs_mount		*mp,
+	unsigned int			cmd,
+	struct xfs_inumbers_req __user	*arg)
+{
+	struct xfs_bulk_ireq		hdr;
+	struct xfs_ibulk		breq = {
+		.mp			= mp,
+	};
+	int				error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	if (copy_from_user(&hdr, &arg->hdr, sizeof(hdr)))
+		return -EFAULT;
+
+	error = xfs_bulk_ireq_setup(mp, &hdr, &breq, arg->inumbers);
+	if (error < 0)
+		return error;
+
+	if (!error)
+		error = xfs_inumbers(&breq, xfs_inumbers_fmt);
+
+	error = xfs_bulk_ireq_teardown(&hdr, &breq, error);
+	if (error)
+		return error;
+
+	if (copy_to_user(&arg->hdr, &hdr, sizeof(hdr)))
+		return -EFAULT;
+
+	return 0;
+}
+
 STATIC int
 xfs_ioc_fsgeometry(
 	struct xfs_mount	*mp,
@@ -2174,6 +2223,8 @@ xfs_file_ioctl(
 		return xfs_ioc_bulkstat(mp, cmd, arg);
 	case XFS_IOC_BULKSTAT_SINGLE:
 		return xfs_ioc_bulkstat_single(mp, cmd, arg);
+	case XFS_IOC_INUMBERS:
+		return xfs_ioc_inumbers(mp, cmd, arg);
 
 	case XFS_IOC_FSGEOMETRY_V1:
 		return xfs_ioc_fsgeometry(mp, arg, 3);
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 08a90e3459d1..772086998ab3 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -578,6 +578,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_SCRUB_METADATA:
 	case XFS_IOC_BULKSTAT:
 	case XFS_IOC_BULKSTAT_SINGLE:
+	case XFS_IOC_INUMBERS:
 		return xfs_file_ioctl(filp, cmd, p);
 #if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
 	/*
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index fa1252657b08..e390e65d2438 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -151,6 +151,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_single_req,	224);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers_req,		64);
 }
 
 #endif /* __XFS_ONDISK_H */

