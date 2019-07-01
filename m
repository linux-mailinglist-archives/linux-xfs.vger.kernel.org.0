Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C65F2E830
	for <lists+linux-xfs@lfdr.de>; Thu, 30 May 2019 00:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfE2W11 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 May 2019 18:27:27 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36778 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfE2W11 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:27:27 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TM40xl041560
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=WT5mPB5sA+jN/tShEd3fbnENro/+Z0INNHigYlan4d4=;
 b=renavZMIQfht9xlk8v6zwI3VICK/bpFHuLWXXmGl4i0NK3POwPLpBCVbp6ZjQkJW8n+j
 z6BdO0PCrSaSCSDeOgmi+tuTugonsqYhkhW5L9t3BQ0a2txaB0g18FMBpqcMVqFNtDxl
 lK/pqWvMu45j8OFMl87L8kkGjh1iX+unuaSi7aNpbcCiYTJ5bUDwP038usYvpoteNgpF
 YeFFZu6OdDkOFZ+0ViCSzB8oqda2lWJn04iWxT4s40YR1O4NPnhGpZ83a9ahZfD87voH
 0rup/I2SL1iK/0gKqg2t2uiJgM7KDfpJHFBkM3KrVRkgQWN0GvW3fEPFh6Ry/yslxVyC Qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2spu7dn182-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMPtm6142042
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2srbdxne6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:24 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4TMRNJF003829
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 15:27:23 -0700
Subject: [PATCH 10/11] xfs: poll waiting for quotacheck
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 May 2019 15:27:22 -0700
Message-ID: <155916884274.757870.3080038991334062615.stgit@magnolia>
In-Reply-To: <155916877311.757870.11060347556535201032.stgit@magnolia>
References: <155916877311.757870.11060347556535201032.stgit@magnolia>
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

Create a pwork destroy function that uses polling instead of
uninterruptible sleep to wait for work items to finish so that we can
touch the softlockup watchdog.  IOWs, gross hack.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iwalk.c |    3 +++
 fs/xfs/xfs_iwalk.h |    3 ++-
 fs/xfs/xfs_pwork.c |   21 +++++++++++++++++++++
 fs/xfs/xfs_pwork.h |    2 ++
 fs/xfs/xfs_qm.c    |    2 +-
 5 files changed, 29 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 453790bae194..7f40d0633651 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -530,6 +530,7 @@ xfs_iwalk_threaded(
 	xfs_ino_t		startino,
 	xfs_iwalk_fn		iwalk_fn,
 	unsigned int		max_prefetch,
+	bool			polled,
 	void			*data)
 {
 	struct xfs_pwork_ctl	pctl;
@@ -560,5 +561,7 @@ xfs_iwalk_threaded(
 		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
 	}
 
+	if (polled)
+		return xfs_pwork_destroy_poll(&pctl);
 	return xfs_pwork_destroy(&pctl);
 }
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 40233a05a766..76d8f87a39ef 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -15,6 +15,7 @@ typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
 		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
 int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
-		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
+		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, bool poll,
+		void *data);
 
 #endif /* __XFS_IWALK_H__ */
diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
index c1419558b089..a9c39615233a 100644
--- a/fs/xfs/xfs_pwork.c
+++ b/fs/xfs/xfs_pwork.c
@@ -13,6 +13,7 @@
 #include "xfs_trace.h"
 #include "xfs_sysctl.h"
 #include "xfs_pwork.h"
+#include <linux/nmi.h>
 
 /*
  * Parallel Work Queue
@@ -40,6 +41,7 @@ xfs_pwork_work(
 	error = pctl->work_fn(pctl->mp, pwork);
 	if (error && !pctl->error)
 		pctl->error = error;
+	atomic_dec(&pctl->nr_work);
 }
 
 /*
@@ -68,6 +70,7 @@ xfs_pwork_init(
 	pctl->work_fn = work_fn;
 	pctl->error = 0;
 	pctl->mp = mp;
+	atomic_set(&pctl->nr_work, 0);
 
 	return 0;
 }
@@ -80,6 +83,7 @@ xfs_pwork_queue(
 {
 	INIT_WORK(&pwork->work, xfs_pwork_work);
 	pwork->pctl = pctl;
+	atomic_inc(&pctl->nr_work);
 	queue_work(pctl->wq, &pwork->work);
 }
 
@@ -93,6 +97,23 @@ xfs_pwork_destroy(
 	return pctl->error;
 }
 
+/*
+ * Wait for the work to finish and tear down the control structure.
+ * Continually poll completion status and touch the soft lockup watchdog.
+ * This is for things like mount that hold locks.
+ */
+int
+xfs_pwork_destroy_poll(
+	struct xfs_pwork_ctl	*pctl)
+{
+	while (atomic_read(&pctl->nr_work) > 0) {
+		msleep(1);
+		touch_softlockup_watchdog();
+	}
+
+	return xfs_pwork_destroy(pctl);
+}
+
 /*
  * Return the amount of parallelism that the data device can handle, or 0 for
  * no limit.
diff --git a/fs/xfs/xfs_pwork.h b/fs/xfs/xfs_pwork.h
index e0c1354a2d8c..08da723a8dc9 100644
--- a/fs/xfs/xfs_pwork.h
+++ b/fs/xfs/xfs_pwork.h
@@ -18,6 +18,7 @@ struct xfs_pwork_ctl {
 	struct workqueue_struct	*wq;
 	struct xfs_mount	*mp;
 	xfs_pwork_work_fn	work_fn;
+	atomic_t		nr_work;
 	int			error;
 };
 
@@ -45,6 +46,7 @@ int xfs_pwork_init(struct xfs_mount *mp, struct xfs_pwork_ctl *pctl,
 		unsigned int nr_threads);
 void xfs_pwork_queue(struct xfs_pwork_ctl *pctl, struct xfs_pwork *pwork);
 int xfs_pwork_destroy(struct xfs_pwork_ctl *pctl);
+int xfs_pwork_destroy_poll(struct xfs_pwork_ctl *pctl);
 unsigned int xfs_pwork_guess_datadev_parallelism(struct xfs_mount *mp);
 
 #endif /* __XFS_PWORK_H__ */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index e4f3785f7a64..de6a623ada02 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1305,7 +1305,7 @@ xfs_qm_quotacheck(
 		flags |= XFS_PQUOTA_CHKD;
 	}
 
-	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, NULL);
+	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, true, NULL);
 	if (error)
 		goto error_return;
 

