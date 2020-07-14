Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BBF21E52A
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jul 2020 03:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgGNBdz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Jul 2020 21:33:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39146 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgGNBdy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 21:33:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1WDpA096174;
        Tue, 14 Jul 2020 01:33:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=BHGEryKChcFNPkC5p3uJPVFRl27dkaDkkzsBccowKV8=;
 b=yPkWSIceDYxd8tN3aWjbUklq+JowzynHv+2b1sBu2UZMH9Swdi/vVc/Lp4mC4zIBQshK
 ettVah8JrSLWXBtqCzxMQ9hzbBTLQmjIPRv/T+KZAkxUQQfXyc6pw/sQypo0xo6XpL8M
 RWtqDsMym4Glv80GVLTIx9bYhop+IVmBim3rWYma0B8SLwHKI55Y3YKyM92dtUxXBSPE
 qGvJP+Gtd9EMyXs06Hgmf0t+dYp59oGqgrMlWNCjjyyub9+RZXbSLZfYlirBKJUwbHBA
 Ck06tyvq26xZjP6MXAX4tgv2KTjL30+iaF4H0fPSaRzwi1+HmDAXW4I8RPHldHf97MQ1 ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3274ur2f28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 01:33:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1XYxv175776;
        Tue, 14 Jul 2020 01:33:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 327q0n6mej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 01:33:51 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06E1XoHW010607;
        Tue, 14 Jul 2020 01:33:50 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 18:33:50 -0700
Subject: [PATCH 22/26] xfs: refactor xfs_trans_dqresv
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 13 Jul 2020 18:33:49 -0700
Message-ID: <159469042968.2914673.12190449838909912585.stgit@magnolia>
In-Reply-To: <159469028734.2914673.17856142063205791176.stgit@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've refactored the resource usage and limits into
per-resource structures, we can refactor some of the open-coded
reservation limit checking in xfs_trans_dqresv.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/xfs_trans_dquot.c |  153 +++++++++++++++++++++++-----------------------
 1 file changed, 78 insertions(+), 75 deletions(-)


diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 53c133fd4f18..cce457ad220b 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -561,6 +561,58 @@ xfs_quota_warn(
 			   mp->m_super->s_dev, type);
 }
 
+/*
+ * Decide if we can make an additional reservation against a quota resource.
+ * Returns an inode QUOTA_NL_ warning code and whether or not it's fatal.
+ *
+ * Note that we assume that the numeric difference between the inode and block
+ * warning codes will always be 3 since it's userspace ABI now, and will never
+ * decrease the quota reservation, so the *BELOW messages are irrelevant.
+ */
+static inline int
+xfs_dqresv_check(
+	struct xfs_dquot_res	*res,
+	struct xfs_quota_limits	*qlim,
+	int64_t			delta,
+	bool			*fatal)
+{
+	xfs_qcnt_t		hardlimit = res->hardlimit;
+	xfs_qcnt_t		softlimit = res->softlimit;
+	xfs_qcnt_t		total_count = res->reserved + delta;
+
+	BUILD_BUG_ON(QUOTA_NL_BHARDWARN     != QUOTA_NL_IHARDWARN + 3);
+	BUILD_BUG_ON(QUOTA_NL_BSOFTLONGWARN != QUOTA_NL_ISOFTLONGWARN + 3);
+	BUILD_BUG_ON(QUOTA_NL_BSOFTWARN     != QUOTA_NL_ISOFTWARN + 3);
+
+	*fatal = false;
+	if (delta <= 0)
+		return QUOTA_NL_NOWARN;
+
+	if (!hardlimit)
+		hardlimit = qlim->hard;
+	if (!softlimit)
+		softlimit = qlim->soft;
+
+	if (hardlimit && total_count > hardlimit) {
+		*fatal = true;
+		return QUOTA_NL_IHARDWARN;
+	}
+
+	if (softlimit && total_count > softlimit) {
+		time64_t	now = ktime_get_real_seconds();
+
+		if ((res->timer != 0 && now > res->timer) ||
+		    (res->warnings != 0 && res->warnings >= qlim->warn)) {
+			*fatal = true;
+			return QUOTA_NL_ISOFTLONGWARN;
+		}
+
+		return QUOTA_NL_ISOFTWARN;
+	}
+
+	return QUOTA_NL_NOWARN;
+}
+
 /*
  * This reserves disk blocks and inodes against a dquot.
  * Flags indicate if the dquot is to be locked here and also
@@ -576,99 +628,51 @@ xfs_trans_dqresv(
 	long			ninos,
 	uint			flags)
 {
-	xfs_qcnt_t		hardlimit;
-	xfs_qcnt_t		softlimit;
-	time64_t		timer;
-	xfs_qwarncnt_t		warns;
-	xfs_qwarncnt_t		warnlimit;
-	xfs_qcnt_t		total_count;
-	xfs_qcnt_t		*resbcountp;
 	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	struct xfs_def_quota	*defq;
-
+	struct xfs_dquot_res	*blkres;
+	struct xfs_quota_limits	*qlim;
 
 	xfs_dqlock(dqp);
 
 	defq = xfs_get_defquota(q, dqp->q_type);
 
 	if (flags & XFS_TRANS_DQ_RES_BLKS) {
-		hardlimit = dqp->q_blk.hardlimit;
-		if (!hardlimit)
-			hardlimit = defq->blk.hard;
-		softlimit = dqp->q_blk.softlimit;
-		if (!softlimit)
-			softlimit = defq->blk.soft;
-		timer = dqp->q_blk.timer;
-		warns = dqp->q_blk.warnings;
-		warnlimit = defq->blk.warn;
-		resbcountp = &dqp->q_blk.reserved;
+		blkres = &dqp->q_blk;
+		qlim = &defq->blk;
 	} else {
-		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
-		hardlimit = dqp->q_rtb.hardlimit;
-		if (!hardlimit)
-			hardlimit = defq->rtb.hard;
-		softlimit = dqp->q_rtb.softlimit;
-		if (!softlimit)
-			softlimit = defq->rtb.soft;
-		timer = dqp->q_rtb.timer;
-		warns = dqp->q_rtb.warnings;
-		warnlimit = defq->rtb.warn;
-		resbcountp = &dqp->q_rtb.reserved;
+		blkres = &dqp->q_rtb;
+		qlim = &defq->rtb;
 	}
 
 	if ((flags & XFS_QMOPT_FORCE_RES) == 0 && dqp->q_id &&
 	    ((XFS_IS_UQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISUDQ(dqp)) ||
 	     (XFS_IS_GQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISGDQ(dqp)) ||
 	     (XFS_IS_PQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISPDQ(dqp)))) {
-		if (nblks > 0) {
+		int		quota_nl;
+		bool		fatal;
+
+		/*
+		 * dquot is locked already. See if we'd go over the hardlimit
+		 * or exceed the timelimit if we'd reserve resources.
+		 */
+		quota_nl = xfs_dqresv_check(blkres, qlim, nblks, &fatal);
+		if (quota_nl != QUOTA_NL_NOWARN) {
 			/*
-			 * dquot is locked already. See if we'd go over the
-			 * hardlimit or exceed the timelimit if we allocate
-			 * nblks.
+			 * Quota block warning codes are 3 more than the inode
+			 * codes, which we check above.
 			 */
-			total_count = *resbcountp + nblks;
-			if (hardlimit && total_count > hardlimit) {
-				xfs_quota_warn(mp, dqp, QUOTA_NL_BHARDWARN);
+			xfs_quota_warn(mp, dqp, quota_nl + 3);
+			if (fatal)
 				goto error_return;
-			}
-			if (softlimit && total_count > softlimit) {
-				if ((timer != 0 &&
-				     ktime_get_real_seconds() > timer) ||
-				    (warns != 0 && warns >= warnlimit)) {
-					xfs_quota_warn(mp, dqp,
-						       QUOTA_NL_BSOFTLONGWARN);
-					goto error_return;
-				}
-
-				xfs_quota_warn(mp, dqp, QUOTA_NL_BSOFTWARN);
-			}
 		}
-		if (ninos > 0) {
-			total_count = dqp->q_ino.reserved + ninos;
-			timer = dqp->q_ino.timer;
-			warns = dqp->q_ino.warnings;
-			warnlimit = defq->ino.warn;
-			hardlimit = dqp->q_ino.hardlimit;
-			if (!hardlimit)
-				hardlimit = defq->ino.hard;
-			softlimit = dqp->q_ino.softlimit;
-			if (!softlimit)
-				softlimit = defq->ino.soft;
 
-			if (hardlimit && total_count > hardlimit) {
-				xfs_quota_warn(mp, dqp, QUOTA_NL_IHARDWARN);
+		quota_nl = xfs_dqresv_check(&dqp->q_ino, &defq->ino, ninos,
+				&fatal);
+		if (quota_nl != QUOTA_NL_NOWARN) {
+			xfs_quota_warn(mp, dqp, quota_nl);
+			if (fatal)
 				goto error_return;
-			}
-			if (softlimit && total_count > softlimit) {
-				if  ((timer != 0 &&
-				      ktime_get_real_seconds() > timer) ||
-				     (warns != 0 && warns >= warnlimit)) {
-					xfs_quota_warn(mp, dqp,
-						       QUOTA_NL_ISOFTLONGWARN);
-					goto error_return;
-				}
-				xfs_quota_warn(mp, dqp, QUOTA_NL_ISOFTWARN);
-			}
 		}
 	}
 
@@ -676,9 +680,8 @@ xfs_trans_dqresv(
 	 * Change the reservation, but not the actual usage.
 	 * Note that q_blk.reserved = q_blk.count + resv
 	 */
-	(*resbcountp) += (xfs_qcnt_t)nblks;
-	if (ninos != 0)
-		dqp->q_ino.reserved += (xfs_qcnt_t)ninos;
+	blkres->reserved += (xfs_qcnt_t)nblks;
+	dqp->q_ino.reserved += (xfs_qcnt_t)ninos;
 
 	/*
 	 * note the reservation amt in the trans struct too,

