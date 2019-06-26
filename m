Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE477572ED
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfFZUpu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:45:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49186 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFZUpu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:45:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKi9Mv012384
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:45:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=rp36Puutb3fhLrFWGaj+CVuw/SbpkOr5Zq2DNt7uLuo=;
 b=I/3mnpugAnz36/nllzzZshcXjkETL9BM3XU9tSyhWXpCRCtqHw2Hco88Ym74I53Jwzml
 nqDXtyhiJUzLFa7cGKJcHab8JWSCrPB2ZZgNmRUP++Crzyrd4CXoaLUDEmouh7DdZsBD
 5+3e0Vu0Xm2Ma3hpHX56Ivxh9ThYRmTjivqnFXzaC1+ZdjqnJpgVBy8QKwY9/jSpbHyl
 3E9oS9/V53jRJpZpGFvQ4MzIejI1b0PKE6c26ApL95c55DBcf0L0BrCeU52rGc3ayn5W
 b/Sam5G9rdLMk3MKNu0BqncKhpJLoCqxDQTZ/IsVzVKiuPO+0ZOAAH5Uu6oAYOUbSnM3 ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t9brtcmty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:45:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKjSw6069370
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:45:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tat7d1gph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:45:48 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QKjlVc004623
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 20:45:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 13:45:47 -0700
Subject: [PATCH 2/9] xfs: rename bulkstat functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Wed, 26 Jun 2019 13:45:45 -0700
Message-ID: <156158194549.495715.11820133364251169894.stgit@magnolia>
In-Reply-To: <156158193320.495715.6675123051075804739.stgit@magnolia>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
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

Rename the bulkstat functions to 'fsbulkstat' so that they match the
ioctl names.  We will be introducing a new set of bulkstat/inumbers
ioctls soon, and it will be important to keep the names straight.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/xfs_ioctl.c   |   14 +++++++-------
 fs/xfs/xfs_ioctl.h   |    5 +++--
 fs/xfs/xfs_ioctl32.c |   18 +++++++++---------
 3 files changed, 19 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 34b38d8e8dc9..5e0476003763 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -724,7 +724,7 @@ xfs_ioc_space(
 
 /* Return 0 on success or positive error */
 int
-xfs_bulkstat_one_fmt(
+xfs_fsbulkstat_one_fmt(
 	struct xfs_ibulk	*breq,
 	const struct xfs_bstat	*bstat)
 {
@@ -734,7 +734,7 @@ xfs_bulkstat_one_fmt(
 }
 
 int
-xfs_inumbers_fmt(
+xfs_fsinumbers_fmt(
 	struct xfs_ibulk	*breq,
 	const struct xfs_inogrp	*igrp)
 {
@@ -744,7 +744,7 @@ xfs_inumbers_fmt(
 }
 
 STATIC int
-xfs_ioc_bulkstat(
+xfs_ioc_fsbulkstat(
 	xfs_mount_t		*mp,
 	unsigned int		cmd,
 	void			__user *arg)
@@ -794,16 +794,16 @@ xfs_ioc_bulkstat(
 	 */
 	if (cmd == XFS_IOC_FSINUMBERS) {
 		breq.startino = lastino ? lastino + 1 : 0;
-		error = xfs_inumbers(&breq, xfs_inumbers_fmt);
+		error = xfs_inumbers(&breq, xfs_fsinumbers_fmt);
 		lastino = breq.startino - 1;
 	} else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE) {
 		breq.startino = lastino;
 		breq.icount = 1;
-		error = xfs_bulkstat_one(&breq, xfs_bulkstat_one_fmt);
+		error = xfs_bulkstat_one(&breq, xfs_fsbulkstat_one_fmt);
 		lastino = breq.startino;
 	} else {	/* XFS_IOC_FSBULKSTAT */
 		breq.startino = lastino ? lastino + 1 : 0;
-		error = xfs_bulkstat(&breq, xfs_bulkstat_one_fmt);
+		error = xfs_bulkstat(&breq, xfs_fsbulkstat_one_fmt);
 		lastino = breq.startino - 1;
 	}
 
@@ -1983,7 +1983,7 @@ xfs_file_ioctl(
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
index d7c5153e1b61..9e5cf3988d3e 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -86,7 +86,7 @@ xfs_compat_growfs_rt_copyin(
 }
 
 STATIC int
-xfs_inumbers_fmt_compat(
+xfs_fsinumbers_fmt_compat(
 	struct xfs_ibulk	*breq,
 	const struct xfs_inogrp	*igrp)
 {
@@ -101,7 +101,7 @@ xfs_inumbers_fmt_compat(
 }
 
 #else
-#define xfs_inumbers_fmt_compat xfs_inumbers_fmt
+#define xfs_fsinumbers_fmt_compat xfs_fsinumbers_fmt
 #endif	/* BROKEN_X86_ALIGNMENT */
 
 STATIC int
@@ -171,7 +171,7 @@ xfs_bstime_store_compat(
 
 /* Return 0 on success or positive error (to xfs_bulkstat()) */
 STATIC int
-xfs_bulkstat_one_fmt_compat(
+xfs_fsbulkstat_one_fmt_compat(
 	struct xfs_ibulk	*breq,
 	const struct xfs_bstat	*buffer)
 {
@@ -206,7 +206,7 @@ xfs_bulkstat_one_fmt_compat(
 
 /* copied from xfs_ioctl.c */
 STATIC int
-xfs_compat_ioc_bulkstat(
+xfs_compat_ioc_fsbulkstat(
 	xfs_mount_t		  *mp,
 	unsigned int		  cmd,
 	struct compat_xfs_fsop_bulkreq __user *p32)
@@ -226,8 +226,8 @@ xfs_compat_ioc_bulkstat(
 	 * to userpace memory via bulkreq.ubuffer.  Normally the compat
 	 * functions and structure size are the correct ones to use ...
 	 */
-	inumbers_fmt_pf		inumbers_func = xfs_inumbers_fmt_compat;
-	bulkstat_one_fmt_pf	bs_one_func = xfs_bulkstat_one_fmt_compat;
+	inumbers_fmt_pf		inumbers_func = xfs_fsinumbers_fmt_compat;
+	bulkstat_one_fmt_pf	bs_one_func = xfs_fsbulkstat_one_fmt_compat;
 
 #ifdef CONFIG_X86_X32
 	if (in_x32_syscall()) {
@@ -239,8 +239,8 @@ xfs_compat_ioc_bulkstat(
 		 * the data written out in compat layout will not match what
 		 * x32 userspace expects.
 		 */
-		inumbers_func = xfs_inumbers_fmt;
-		bs_one_func = xfs_bulkstat_one_fmt;
+		inumbers_func = xfs_fsinumbers_fmt;
+		bs_one_func = xfs_fsbulkstat_one_fmt;
 	}
 #endif
 
@@ -669,7 +669,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_FSBULKSTAT_32:
 	case XFS_IOC_FSBULKSTAT_SINGLE_32:
 	case XFS_IOC_FSINUMBERS_32:
-		return xfs_compat_ioc_bulkstat(mp, cmd, arg);
+		return xfs_compat_ioc_fsbulkstat(mp, cmd, arg);
 	case XFS_IOC_FD_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_HANDLE_32:
 	case XFS_IOC_PATH_TO_FSHANDLE_32: {

