Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09AA3257381
	for <lists+linux-xfs@lfdr.de>; Mon, 31 Aug 2020 08:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgHaGHP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 31 Aug 2020 02:07:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48002 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgHaGHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 02:07:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07V5rVUi018865;
        Mon, 31 Aug 2020 06:07:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ie2NgonRa/1Ead82nki8V6q2/q8cqwrg6edjcPx8Es8=;
 b=SozLfpmgPgOEcXJlpf/IW+COXnVAuAa8UxwTFmjQzz8ASyvGa9kwyKUc81BjFUOyOFr+
 85Dq+57LnYYTFMxmZ5KTHK4us6EPaSQHFBpr8szuBShmOMFC2Cwc8zEY4QbGeRfYsd6M
 fsZtYDHUVxKiMilyyD6G5JoVr7zeIyd6PFTDq1yOAYlnuFQAv7HlWeOe4Ix4vtf/c4yZ
 aV4srgm0rYGKi2Aed0DUXjKRp8H1OWXLfEVNxBQ59/RWfz+D8IfUlCFX0uo3fOpm/0Gx
 ppwyo7fej2fMaziJfCTRTxeMWvYl5UrUl2aFspTGNhY4RMp57LJbwWHFizF8zyozi+TA Vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 337qrhbd7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 06:07:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07V5uWvi096803;
        Mon, 31 Aug 2020 06:07:03 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3380wybg4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 06:07:03 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07V673VB028499;
        Mon, 31 Aug 2020 06:07:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 30 Aug 2020 23:07:02 -0700
Subject: [PATCH 03/11] xfs: refactor default quota grace period setting code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Sun, 30 Aug 2020 23:07:06 -0700
Message-ID: <159885402592.3608006.10830807263487637818.stgit@magnolia>
In-Reply-To: <159885400575.3608006.17716724192510967135.stgit@magnolia>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9729 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9729 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the code that sets the default quota grace period into a helper
function so that we can override the ondisk behavior later.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |   13 +++++++++++++
 fs/xfs/xfs_dquot.c         |    8 ++++++++
 fs/xfs/xfs_dquot.h         |    1 +
 fs/xfs/xfs_qm_syscalls.c   |    4 ++--
 4 files changed, 24 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index cb316053d3db..4b68a473b090 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1209,6 +1209,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  * been reached, and therefore no expiration has been set.  Therefore, the
  * ondisk min and max defined here can be used directly to constrain the incore
  * quota expiration timestamps on a Unix system.
+ *
+ * The grace period for each quota type is stored in the root dquot (id = 0)
+ * and is applied to a non-root dquot when it exceeds the soft or hard limits.
+ * The length of quota grace periods are unsigned 32-bit quantities measured in
+ * units of seconds.  A value of zero means to use the default period.
  */
 
 /*
@@ -1223,6 +1228,14 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  */
 #define XFS_DQ_LEGACY_EXPIRY_MAX	((int64_t)U32_MAX)
 
+/*
+ * Default quota grace periods, ranging from zero (use the compiled defaults)
+ * to ~136 years.  These are applied to a non-root dquot that has exceeded
+ * either limit.
+ */
+#define XFS_DQ_GRACE_MIN		((int64_t)0)
+#define XFS_DQ_GRACE_MAX		((int64_t)U32_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index f34841f98d44..e63a933413a3 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -110,6 +110,14 @@ xfs_dquot_set_timeout(
 					  qi->qi_expiry_max);
 }
 
+/* Set the length of the default grace period. */
+time64_t
+xfs_dquot_set_grace_period(
+	time64_t		grace)
+{
+	return clamp_t(time64_t, grace, XFS_DQ_GRACE_MIN, XFS_DQ_GRACE_MAX);
+}
+
 /*
  * Determine if this quota counter is over either limit and set the quota
  * timers as appropriate.
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 0e449101c861..f642884a6834 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -238,5 +238,6 @@ int xfs_qm_dqiterate(struct xfs_mount *mp, xfs_dqtype_t type,
 		xfs_qm_dqiterate_fn iter_fn, void *priv);
 
 time64_t xfs_dquot_set_timeout(struct xfs_mount *mp, time64_t timeout);
+time64_t xfs_dquot_set_grace_period(time64_t grace);
 
 #endif /* __XFS_DQUOT_H__ */
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 750f775ae915..ca1b57d291dc 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -486,8 +486,8 @@ xfs_setqlim_timer(
 {
 	if (qlim) {
 		/* Set the length of the default grace period. */
-		res->timer = timer;
-		qlim->time = timer;
+		res->timer = xfs_dquot_set_grace_period(timer);
+		qlim->time = res->timer;
 	} else {
 		/* Set the grace period expiration on a quota. */
 		res->timer = xfs_dquot_set_timeout(mp, timer);

