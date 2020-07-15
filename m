Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCBA220219
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Jul 2020 03:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgGOBzF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jul 2020 21:55:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46508 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbgGOBzF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:55:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1mo6f076262;
        Wed, 15 Jul 2020 01:53:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=lPgt3Cz0auzx9SgcFKcv97qVN9EUum2dDS82EPWX9eI=;
 b=VOB8tFg4OpORO2NdgOwwbRJWbbPxk9X1I2jgC9pi4+F+hKH2SQKklWnh+brCwdy5EoLB
 OFYtFhIRIhE4PsMf2yJL3XXfc4t3+xHd6dXe/UHj5Ar/g8Fi7C7oY2dU0yufCj4iVYKh
 sjTKkoa0oa/JZJmH47vHXp04R64XRlXmf2d8qdRwDxVi0wWso2bJcP7ZKflHMN5MzwEf
 dkiTZbI3KquQ2z96InkLpeWKujG0luVaR2clo+wjuxQ2C9Ru4TJY4WyA25vuLUJbDOPy
 yC3TNCOQgsozf1J4u0Py8/rnTLZ0MZGl5epVF9YR3/G67gOnLO0lp01MO3P7iOHbi9cT KA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274ur8q3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 01:53:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1qeTB043943;
        Wed, 15 Jul 2020 01:53:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 327qbyu8rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 01:53:00 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06F1qxbb026976;
        Wed, 15 Jul 2020 01:53:00 GMT
Received: from localhost (/10.159.237.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 18:52:59 -0700
Subject: [PATCH 22/26] xfs: refactor xfs_trans_dqresv
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 18:52:58 -0700
Message-ID: <159477797841.3263162.18245916784030863518.stgit@magnolia>
In-Reply-To: <159477783164.3263162.2564345443708779029.stgit@magnolia>
References: <159477783164.3263162.2564345443708779029.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007150014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=1 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150013
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

