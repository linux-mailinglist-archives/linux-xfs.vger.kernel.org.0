Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5390247ACD
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Aug 2020 00:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgHQW5v (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Aug 2020 18:57:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40138 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbgHQW5u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:57:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMuvnS136121;
        Mon, 17 Aug 2020 22:57:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=VPL2stAZzkqUeNUynAqLBOBcbnRhPuWVmzE1Ql+0t7E=;
 b=PLe0CDJ7oKt7DytsLUS9Bn0ZgYKn4EpqWPcymtmwTdQqvp6+j5njGEm4zQF/Thh+p9im
 675VF1/YZWlvcxo0uPd56L6ZnHf48Tx/bIwBSOPcCWM/UH6obWOAn+G4bgkMzHBga38K
 4US9Ulx8otFlNyWy4NG7O8Dz2LdT3ZNeX9IzUQwQ6XWulVJE011/MAgqYZVrYo8Clrbw
 R6UJU13zvphLUGUdSfhc/oxYmXf4RVomFmhtidFhx29PVzy80D5409AVr0nqAiYyXVVG
 uI5yywoOgpvMsaLjgfsPAA3Xj6fshPDCmuaUZT6h6G3p5rNw80sg1iG27lZoEL79m5TN zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32x8bn1fux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:57:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMmsYk074618;
        Mon, 17 Aug 2020 22:57:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32xsmwgfyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:57:47 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HMvkoZ017308;
        Mon, 17 Aug 2020 22:57:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:57:46 -0700
Subject: [PATCH 09/11] xfs: refactor quota timestamp coding
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Mon, 17 Aug 2020 15:57:45 -0700
Message-ID: <159770506536.3956827.8490982017014132952.stgit@magnolia>
In-Reply-To: <159770500809.3956827.8869892960975362931.stgit@magnolia>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=1 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor quota timestamp encoding and decoding into helper functions so
that we can add extra behavior in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |   20 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_quota_defs.h |    6 ++++++
 fs/xfs/xfs_dquot.c             |   12 ++++++------
 3 files changed, 32 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 5a2db00b9d5f..7f5291022b11 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -288,3 +288,23 @@ const struct xfs_buf_ops xfs_dquot_buf_ra_ops = {
 	.verify_read = xfs_dquot_buf_readahead_verify,
 	.verify_write = xfs_dquot_buf_write_verify,
 };
+
+/* Convert an on-disk timer value into an incore timer value. */
+void
+xfs_dquot_from_disk_timestamp(
+	struct xfs_disk_dquot	*ddq,
+	time64_t		*timer,
+	__be32			dtimer)
+{
+	*timer = be32_to_cpu(dtimer);
+}
+
+/* Convert an incore timer value into an on-disk timer value. */
+void
+xfs_dquot_to_disk_timestamp(
+	struct xfs_dquot	*dqp,
+	__be32			*dtimer,
+	time64_t		timer)
+{
+	*dtimer = cpu_to_be32(timer);
+}
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 076bdc7037ee..b524059faab5 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -143,4 +143,10 @@ extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
 extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
 		xfs_dqid_t id, xfs_dqtype_t type);
 
+struct xfs_dquot;
+void xfs_dquot_from_disk_timestamp(struct xfs_disk_dquot *ddq,
+		time64_t *timer, __be32 dtimer);
+void xfs_dquot_to_disk_timestamp(struct xfs_dquot *ddq,
+		__be32 *dtimer, time64_t timer);
+
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ed3fa6ada0d3..08d497d413b9 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -534,9 +534,9 @@ xfs_dquot_from_disk(
 	dqp->q_ino.warnings = be16_to_cpu(ddqp->d_iwarns);
 	dqp->q_rtb.warnings = be16_to_cpu(ddqp->d_rtbwarns);
 
-	dqp->q_blk.timer = be32_to_cpu(ddqp->d_btimer);
-	dqp->q_ino.timer = be32_to_cpu(ddqp->d_itimer);
-	dqp->q_rtb.timer = be32_to_cpu(ddqp->d_rtbtimer);
+	xfs_dquot_from_disk_timestamp(ddqp, &dqp->q_blk.timer, ddqp->d_btimer);
+	xfs_dquot_from_disk_timestamp(ddqp, &dqp->q_ino.timer, ddqp->d_itimer);
+	xfs_dquot_from_disk_timestamp(ddqp, &dqp->q_rtb.timer, ddqp->d_rtbtimer);
 
 	/*
 	 * Reservation counters are defined as reservation plus current usage
@@ -579,9 +579,9 @@ xfs_dquot_to_disk(
 	ddqp->d_iwarns = cpu_to_be16(dqp->q_ino.warnings);
 	ddqp->d_rtbwarns = cpu_to_be16(dqp->q_rtb.warnings);
 
-	ddqp->d_btimer = cpu_to_be32(dqp->q_blk.timer);
-	ddqp->d_itimer = cpu_to_be32(dqp->q_ino.timer);
-	ddqp->d_rtbtimer = cpu_to_be32(dqp->q_rtb.timer);
+	xfs_dquot_to_disk_timestamp(dqp, &ddqp->d_btimer, dqp->q_blk.timer);
+	xfs_dquot_to_disk_timestamp(dqp, &ddqp->d_itimer, dqp->q_ino.timer);
+	xfs_dquot_to_disk_timestamp(dqp, &ddqp->d_rtbtimer, dqp->q_rtb.timer);
 }
 
 /* Allocate and initialize the dquot buffer for this in-core dquot. */

