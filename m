Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE232E834
	for <lists+linux-xfs@lfdr.de>; Thu, 30 May 2019 00:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfE2W1q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 May 2019 18:27:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43290 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfE2W1q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:27:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TM4cnk023996
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=yz/dSM0M0J+fTgB7yw7RYOrA2Ajnc6/6ZPUizbXz39w=;
 b=hQKRcPAH9IlQCGvnc3+RA5Saa90p0cwr18eVv9QhMtKJ6t3d1jvSrldZ6bllF1W+Hm++
 jsV1eQKO/PppSDD9qfVvQyeUkFBvUEhGg3qm4S+fsCKa4cgmH5M2A9R9rRDB99crV3oC
 2+atXIBmF/Ft+vlKY4M58dO8Ogk1GtAYgoZC7QbrRqS9/aWKJHL1wcYmCPfvX4IXK4id
 hPOPrIxSBQ9VEzdGhnxHeLTzSghq1E/kRqgK3c4ZXBVeTTcGVjilQXvmdZzm+lkjZ1WV
 EKVBo38mFRRdk+IvCmtnclU9jE14KH8FczvmiWho2CpSujRVEmbhAmfU90LAmQ7EMCTL 4g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2spw4tmtg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMQEf2164682
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2sr31vh911-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:45 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4TMRiFS014239
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 15:27:44 -0700
Subject: [PATCH 2/9] xfs: rename bulkstat functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 May 2019 15:27:43 -0700
Message-ID: <155916886337.758159.1536999475082923389.stgit@magnolia>
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

Rename the bulkstat functions to 'fsbulkstat' so that they match the
ioctl names.  We will be introducing a new set of bulkstat/inumbers
ioctls soon, and it will be important to keep the names straight.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   |   14 +++++++-------
 fs/xfs/xfs_ioctl.h   |    5 +++--
 fs/xfs/xfs_ioctl32.c |   18 +++++++++---------
 3 files changed, 19 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 456a0e132d6d..f02a9bd757ad 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -723,7 +723,7 @@ xfs_ioc_space(
 
 /* Return 0 on success or positive error */
 int
-xfs_bulkstat_one_fmt(
+xfs_fsbulkstat_one_fmt(
 	struct xfs_ibulk	*breq,
 	const struct xfs_bstat	*bstat)
 {
@@ -733,7 +733,7 @@ xfs_bulkstat_one_fmt(
 }
 
 int
-xfs_inumbers_fmt(
+xfs_fsinumbers_fmt(
 	struct xfs_ibulk	*breq,
 	const struct xfs_inogrp	*igrp)
 {
@@ -743,7 +743,7 @@ xfs_inumbers_fmt(
 }
 
 STATIC int
-xfs_ioc_bulkstat(
+xfs_ioc_fsbulkstat(
 	xfs_mount_t		*mp,
 	unsigned int		cmd,
 	void			__user *arg)
@@ -790,15 +790,15 @@ xfs_ioc_bulkstat(
 	 */
 	if (cmd == XFS_IOC_FSINUMBERS) {
 		breq.startino = lastino + 1;
-		error = xfs_inumbers(&breq, xfs_inumbers_fmt);
+		error = xfs_inumbers(&breq, xfs_fsinumbers_fmt);
 		lastino = breq.startino - 1;
 	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
 		breq.startino = lastino;
-		error = xfs_bulkstat_one(&breq, xfs_bulkstat_one_fmt);
+		error = xfs_bulkstat_one(&breq, xfs_fsbulkstat_one_fmt);
 		lastino = breq.startino;
 	} else {	/* XFS_IOC_FSBULKSTAT */
 		breq.startino = lastino + 1;
-		error = xfs_bulkstat(&breq, xfs_bulkstat_one_fmt);
+		error = xfs_bulkstat(&breq, xfs_fsbulkstat_one_fmt);
 		lastino = breq.startino - 1;
 	}
 
@@ -1978,7 +1978,7 @@ xfs_file_ioctl(
 	case XFS_IOC_FSBULKSTAT_SINGLE:
 	case XFS_IOC_FSBULKSTAT:
 	case XFS_IOC_FSINUMBERS:
-		return xfs_ioc_bulkstat(mp, cmd, arg);
+		return xfs_ioc_fsbulkstat(mp, cmd, arg);
 
 	case XFS_IOC_FSGEOMETRY_V1:
 		return xfs_ioc_fsgeometry(mp, arg, 3);
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index fb303eaa8863..cb34bc821201 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -81,7 +81,8 @@ struct xfs_ibulk;
 struct xfs_bstat;
 struct xfs_inogrp;
 
-int xfs_bulkstat_one_fmt(struct xfs_ibulk *breq, const struct xfs_bstat *bstat);
-int xfs_inumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
+int xfs_fsbulkstat_one_fmt(struct xfs_ibulk *breq,
+			   const struct xfs_bstat *bstat);
+int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
 
 #endif
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 8dcb7046ed15..af753f2708e8 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -84,7 +84,7 @@ xfs_compat_growfs_rt_copyin(
 }
 
 STATIC int
-xfs_inumbers_fmt_compat(
+xfs_fsinumbers_fmt_compat(
 	struct xfs_ibulk	*breq,
 	const struct xfs_inogrp	*igrp)
 {
@@ -99,7 +99,7 @@ xfs_inumbers_fmt_compat(
 }
 
 #else
-#define xfs_inumbers_fmt_compat xfs_inumbers_fmt
+#define xfs_fsinumbers_fmt_compat xfs_fsinumbers_fmt
 #endif	/* BROKEN_X86_ALIGNMENT */
 
 STATIC int
@@ -169,7 +169,7 @@ xfs_bstime_store_compat(
 
 /* Return 0 on success or positive error (to xfs_bulkstat()) */
 STATIC int
-xfs_bulkstat_one_fmt_compat(
+xfs_fsbulkstat_one_fmt_compat(
 	struct xfs_ibulk	*breq,
 	const struct xfs_bstat	*buffer)
 {
@@ -204,7 +204,7 @@ xfs_bulkstat_one_fmt_compat(
 
 /* copied from xfs_ioctl.c */
 STATIC int
-xfs_compat_ioc_bulkstat(
+xfs_compat_ioc_fsbulkstat(
 	xfs_mount_t		  *mp,
 	unsigned int		  cmd,
 	struct compat_xfs_fsop_bulkreq __user *p32)
@@ -223,8 +223,8 @@ xfs_compat_ioc_bulkstat(
 	 * to userpace memory via bulkreq.ubuffer.  Normally the compat
 	 * functions and structure size are the correct ones to use ...
 	 */
-	inumbers_fmt_pf		inumbers_func = xfs_inumbers_fmt_compat;
-	bulkstat_one_fmt_pf	bs_one_func = xfs_bulkstat_one_fmt_compat;
+	inumbers_fmt_pf		inumbers_func = xfs_fsinumbers_fmt_compat;
+	bulkstat_one_fmt_pf	bs_one_func = xfs_fsbulkstat_one_fmt_compat;
 
 #ifdef CONFIG_X86_X32
 	if (in_x32_syscall()) {
@@ -236,8 +236,8 @@ xfs_compat_ioc_bulkstat(
 		 * the data written out in compat layout will not match what
 		 * x32 userspace expects.
 		 */
-		inumbers_func = xfs_inumbers_fmt;
-		bs_one_func = xfs_bulkstat_one_fmt;
+		inumbers_func = xfs_fsinumbers_fmt;
+		bs_one_func = xfs_fsbulkstat_one_fmt;
 	}
 #endif
 
@@ -665,7 +665,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_FSBULKSTAT_32:
 	case XFS_IOC_FSBULKSTAT_SINGLE_32:
 	case XFS_IOC_FSINUMBERS_32:
-		return xfs_compat_ioc_bulkstat(mp, cmd, arg);
+		return xfs_compat_ioc_fsbulkstat(mp, cmd, arg);
 	case XFS_IOC_FD_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_FSHANDLE_32: {

