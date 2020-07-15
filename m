Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A7E22020D
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Jul 2020 03:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgGOByE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jul 2020 21:54:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45860 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbgGOByD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 21:54:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1mHeR076142;
        Wed, 15 Jul 2020 01:51:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sujaDZJWILKyCMmm35N2M5RdVLdqWJCshHkotsdbAOY=;
 b=MD+g4M3mRqxDzIRspERcLvI7yDTt9as1H076+gycMdyzbFEOjk5s+ZVvMoGg5V/0irui
 sSNQZ1c0wBVDoHweX+mhnzZduw8FN/XKTiACYepGt0vrAKTKS5uiTSuwPEtZNDiUuAOS
 r75T2G799ehGid/DFwDtOXsnMWXA6IuzRVzCwAZZBYliWgk8Yyi8a0eRLmpL0HTXIad2
 A84srNrDok+kDkkdrs+YpYeE3LuxiMMxue55ZECwZyfeoARQTEIUGMypCiRZb+wKnGTE
 SecJS7lYxDBLigCJ0TnQnieGBQAbLzvUm+NjmuKlsJGxpKNWXvt+7cEXGs4JxiUO/GIm tQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3274ur8q0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 01:51:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06F1mdqt036559;
        Wed, 15 Jul 2020 01:51:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 327qbyu761-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 01:51:56 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06F1pt7x028271;
        Wed, 15 Jul 2020 01:51:55 GMT
Received: from localhost (/10.159.237.234)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 18:51:54 -0700
Subject: [PATCH 12/26] xfs: use a per-resource struct for incore dquot data
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 18:51:53 -0700
Message-ID: <159477791372.3263162.17647805725166274737.stgit@magnolia>
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
 engine=8.12.0-2006250000 definitions=main-2007150013
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

Introduce a new struct xfs_dquot_res that we'll use to track all the
incore data for a particular resource type (block, inode, rt block).
This will help us (once we've eliminated q_core) to declutter quota
functions that currently open-code field access or pass around fields
around explicitly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/xfs_dquot.c       |    6 +++---
 fs/xfs/xfs_dquot.h       |   18 +++++++++++-------
 fs/xfs/xfs_iomap.c       |    6 +++---
 fs/xfs/xfs_qm.c          |    6 +++---
 fs/xfs/xfs_qm_bhv.c      |    8 ++++----
 fs/xfs/xfs_qm_syscalls.c |    6 +++---
 fs/xfs/xfs_trace.h       |    2 +-
 fs/xfs/xfs_trans_dquot.c |   44 ++++++++++++++++++++++----------------------
 8 files changed, 50 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5a7f8e49ec2b..5a13750a705f 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -558,9 +558,9 @@ xfs_dquot_from_disk(
 	 * Reservation counters are defined as reservation plus current usage
 	 * to avoid having to add every time.
 	 */
-	dqp->q_res_bcount = be64_to_cpu(ddqp->d_bcount);
-	dqp->q_res_icount = be64_to_cpu(ddqp->d_icount);
-	dqp->q_res_rtbcount = be64_to_cpu(ddqp->d_rtbcount);
+	dqp->q_blk.reserved = be64_to_cpu(ddqp->d_bcount);
+	dqp->q_ino.reserved = be64_to_cpu(ddqp->d_icount);
+	dqp->q_rtb.reserved = be64_to_cpu(ddqp->d_rtbcount);
 
 	/* initialize the dquot speculative prealloc thresholds */
 	xfs_dquot_set_prealloc_limits(dqp);
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 9da4cb3d752b..95a1a31a6597 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -27,6 +27,11 @@ enum {
 	XFS_QLOWSP_MAX
 };
 
+struct xfs_dquot_res {
+	/* Total resources allocated and reserved. */
+	xfs_qcnt_t		reserved;
+};
+
 /*
  * The incore dquot structure
  */
@@ -41,14 +46,13 @@ struct xfs_dquot {
 	xfs_daddr_t		q_blkno;
 	xfs_fileoff_t		q_fileoffset;
 
+	struct xfs_dquot_res	q_blk;	/* regular blocks */
+	struct xfs_dquot_res	q_ino;	/* inodes */
+	struct xfs_dquot_res	q_rtb;	/* realtime blocks */
+
 	struct xfs_disk_dquot	q_core;
 	struct xfs_dq_logitem	q_logitem;
-	/* total regular nblks used+reserved */
-	xfs_qcnt_t		q_res_bcount;
-	/* total inos allocd+reserved */
-	xfs_qcnt_t		q_res_icount;
-	/* total realtime blks used+reserved */
-	xfs_qcnt_t		q_res_rtbcount;
+
 	xfs_qcnt_t		q_prealloc_lo_wmark;
 	xfs_qcnt_t		q_prealloc_hi_wmark;
 	int64_t			q_low_space[XFS_QLOWSP_MAX];
@@ -145,7 +149,7 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
 {
 	int64_t freesp;
 
-	freesp = be64_to_cpu(dqp->q_core.d_blk_hardlimit) - dqp->q_res_bcount;
+	freesp = be64_to_cpu(dqp->q_core.d_blk_hardlimit) - dqp->q_blk.reserved;
 	if (freesp < dqp->q_low_space[XFS_QLOWSP_1_PCNT])
 		return true;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ac2cc2680d2a..0e3f62cde375 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -307,7 +307,7 @@ xfs_quota_need_throttle(
 		return false;
 
 	/* under the lo watermark, no throttle */
-	if (dq->q_res_bcount + alloc_blocks < dq->q_prealloc_lo_wmark)
+	if (dq->q_blk.reserved + alloc_blocks < dq->q_prealloc_lo_wmark)
 		return false;
 
 	return true;
@@ -326,13 +326,13 @@ xfs_quota_calc_throttle(
 	int			shift = 0;
 
 	/* no dq, or over hi wmark, squash the prealloc completely */
-	if (!dq || dq->q_res_bcount >= dq->q_prealloc_hi_wmark) {
+	if (!dq || dq->q_blk.reserved >= dq->q_prealloc_hi_wmark) {
 		*qblocks = 0;
 		*qfreesp = 0;
 		return;
 	}
 
-	freesp = dq->q_prealloc_hi_wmark - dq->q_res_bcount;
+	freesp = dq->q_prealloc_hi_wmark - dq->q_blk.reserved;
 	if (freesp < dq->q_low_space[XFS_QLOWSP_5_PCNT]) {
 		shift = 2;
 		if (freesp < dq->q_low_space[XFS_QLOWSP_3_PCNT])
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f63922277120..d10eb4828135 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1092,14 +1092,14 @@ xfs_qm_quotacheck_dqadjust(
 	 * resource usage.
 	 */
 	be64_add_cpu(&dqp->q_core.d_icount, 1);
-	dqp->q_res_icount++;
+	dqp->q_ino.reserved++;
 	if (nblks) {
 		be64_add_cpu(&dqp->q_core.d_bcount, nblks);
-		dqp->q_res_bcount += nblks;
+		dqp->q_blk.reserved += nblks;
 	}
 	if (rtblks) {
 		be64_add_cpu(&dqp->q_core.d_rtbcount, rtblks);
-		dqp->q_res_rtbcount += rtblks;
+		dqp->q_rtb.reserved += rtblks;
 	}
 
 	/*
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 72c2c2595132..ca1e502e7075 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -29,8 +29,8 @@ xfs_fill_statvfs_from_dquot(
 	if (limit && statp->f_blocks > limit) {
 		statp->f_blocks = limit;
 		statp->f_bfree = statp->f_bavail =
-			(statp->f_blocks > dqp->q_res_bcount) ?
-			 (statp->f_blocks - dqp->q_res_bcount) : 0;
+			(statp->f_blocks > dqp->q_blk.reserved) ?
+			 (statp->f_blocks - dqp->q_blk.reserved) : 0;
 	}
 
 	limit = dqp->q_core.d_ino_softlimit ?
@@ -39,8 +39,8 @@ xfs_fill_statvfs_from_dquot(
 	if (limit && statp->f_files > limit) {
 		statp->f_files = limit;
 		statp->f_ffree =
-			(statp->f_files > dqp->q_res_icount) ?
-			 (statp->f_files - dqp->q_res_icount) : 0;
+			(statp->f_files > dqp->q_ino.reserved) ?
+			 (statp->f_files - dqp->q_ino.reserved) : 0;
 	}
 }
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 15158e5e07e6..ae22536fa111 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -625,8 +625,8 @@ xfs_qm_scall_getquota_fill_qc(
 		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_blk_softlimit));
 	dst->d_ino_hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
 	dst->d_ino_softlimit = be64_to_cpu(dqp->q_core.d_ino_softlimit);
-	dst->d_space = XFS_FSB_TO_B(mp, dqp->q_res_bcount);
-	dst->d_ino_count = dqp->q_res_icount;
+	dst->d_space = XFS_FSB_TO_B(mp, dqp->q_blk.reserved);
+	dst->d_ino_count = dqp->q_ino.reserved;
 	dst->d_spc_timer = be32_to_cpu(dqp->q_core.d_btimer);
 	dst->d_ino_timer = be32_to_cpu(dqp->q_core.d_itimer);
 	dst->d_ino_warns = be16_to_cpu(dqp->q_core.d_iwarns);
@@ -635,7 +635,7 @@ xfs_qm_scall_getquota_fill_qc(
 		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_rtb_hardlimit));
 	dst->d_rt_spc_softlimit =
 		XFS_FSB_TO_B(mp, be64_to_cpu(dqp->q_core.d_rtb_softlimit));
-	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_res_rtbcount);
+	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_rtb.reserved);
 	dst->d_rt_spc_timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
 	dst->d_rt_spc_warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8a73d30c4a87..92258e6486c9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -881,7 +881,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 		__entry->type = dqp->q_type;
 		__entry->flags = dqp->q_flags;
 		__entry->nrefs = dqp->q_nrefs;
-		__entry->res_bcount = dqp->q_res_bcount;
+		__entry->res_bcount = dqp->q_blk.reserved;
 		__entry->bcount = be64_to_cpu(dqp->q_core.d_bcount);
 		__entry->icount = be64_to_cpu(dqp->q_core.d_icount);
 		__entry->blk_hardlimit =
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 302aee9ccf80..d1448d8d4642 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -409,11 +409,11 @@ xfs_trans_apply_dquot_deltas(
 
 				if (qtrx->qt_blk_res != blk_res_used) {
 					if (qtrx->qt_blk_res > blk_res_used)
-						dqp->q_res_bcount -= (xfs_qcnt_t)
+						dqp->q_blk.reserved -= (xfs_qcnt_t)
 							(qtrx->qt_blk_res -
 							 blk_res_used);
 					else
-						dqp->q_res_bcount -= (xfs_qcnt_t)
+						dqp->q_blk.reserved -= (xfs_qcnt_t)
 							(blk_res_used -
 							 qtrx->qt_blk_res);
 				}
@@ -426,7 +426,7 @@ xfs_trans_apply_dquot_deltas(
 				 * deliberately skip quota reservations.
 				 */
 				if (qtrx->qt_bcount_delta) {
-					dqp->q_res_bcount +=
+					dqp->q_blk.reserved +=
 					      (xfs_qcnt_t)qtrx->qt_bcount_delta;
 				}
 			}
@@ -437,17 +437,17 @@ xfs_trans_apply_dquot_deltas(
 				if (qtrx->qt_rtblk_res != qtrx->qt_rtblk_res_used) {
 					if (qtrx->qt_rtblk_res >
 					    qtrx->qt_rtblk_res_used)
-					       dqp->q_res_rtbcount -= (xfs_qcnt_t)
+					       dqp->q_rtb.reserved -= (xfs_qcnt_t)
 						       (qtrx->qt_rtblk_res -
 							qtrx->qt_rtblk_res_used);
 					else
-					       dqp->q_res_rtbcount -= (xfs_qcnt_t)
+					       dqp->q_rtb.reserved -= (xfs_qcnt_t)
 						       (qtrx->qt_rtblk_res_used -
 							qtrx->qt_rtblk_res);
 				}
 			} else {
 				if (qtrx->qt_rtbcount_delta)
-					dqp->q_res_rtbcount +=
+					dqp->q_rtb.reserved +=
 					    (xfs_qcnt_t)qtrx->qt_rtbcount_delta;
 			}
 
@@ -458,20 +458,20 @@ xfs_trans_apply_dquot_deltas(
 				ASSERT(qtrx->qt_ino_res >=
 				       qtrx->qt_ino_res_used);
 				if (qtrx->qt_ino_res > qtrx->qt_ino_res_used)
-					dqp->q_res_icount -= (xfs_qcnt_t)
+					dqp->q_ino.reserved -= (xfs_qcnt_t)
 						(qtrx->qt_ino_res -
 						 qtrx->qt_ino_res_used);
 			} else {
 				if (qtrx->qt_icount_delta)
-					dqp->q_res_icount +=
+					dqp->q_ino.reserved +=
 					    (xfs_qcnt_t)qtrx->qt_icount_delta;
 			}
 
-			ASSERT(dqp->q_res_bcount >=
+			ASSERT(dqp->q_blk.reserved >=
 				be64_to_cpu(dqp->q_core.d_bcount));
-			ASSERT(dqp->q_res_icount >=
+			ASSERT(dqp->q_ino.reserved >=
 				be64_to_cpu(dqp->q_core.d_icount));
-			ASSERT(dqp->q_res_rtbcount >=
+			ASSERT(dqp->q_rtb.reserved >=
 				be64_to_cpu(dqp->q_core.d_rtbcount));
 		}
 	}
@@ -516,7 +516,7 @@ xfs_trans_unreserve_and_mod_dquots(
 			if (qtrx->qt_blk_res) {
 				xfs_dqlock(dqp);
 				locked = true;
-				dqp->q_res_bcount -=
+				dqp->q_blk.reserved -=
 					(xfs_qcnt_t)qtrx->qt_blk_res;
 			}
 			if (qtrx->qt_ino_res) {
@@ -524,7 +524,7 @@ xfs_trans_unreserve_and_mod_dquots(
 					xfs_dqlock(dqp);
 					locked = true;
 				}
-				dqp->q_res_icount -=
+				dqp->q_ino.reserved -=
 					(xfs_qcnt_t)qtrx->qt_ino_res;
 			}
 
@@ -533,7 +533,7 @@ xfs_trans_unreserve_and_mod_dquots(
 					xfs_dqlock(dqp);
 					locked = true;
 				}
-				dqp->q_res_rtbcount -=
+				dqp->q_rtb.reserved -=
 					(xfs_qcnt_t)qtrx->qt_rtblk_res;
 			}
 			if (locked)
@@ -609,7 +609,7 @@ xfs_trans_dqresv(
 		timer = be32_to_cpu(dqp->q_core.d_btimer);
 		warns = be16_to_cpu(dqp->q_core.d_bwarns);
 		warnlimit = defq->bwarnlimit;
-		resbcountp = &dqp->q_res_bcount;
+		resbcountp = &dqp->q_blk.reserved;
 	} else {
 		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
 		hardlimit = be64_to_cpu(dqp->q_core.d_rtb_hardlimit);
@@ -621,7 +621,7 @@ xfs_trans_dqresv(
 		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
 		warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
 		warnlimit = defq->rtbwarnlimit;
-		resbcountp = &dqp->q_res_rtbcount;
+		resbcountp = &dqp->q_rtb.reserved;
 	}
 
 	if ((flags & XFS_QMOPT_FORCE_RES) == 0 && dqp->q_id &&
@@ -652,7 +652,7 @@ xfs_trans_dqresv(
 			}
 		}
 		if (ninos > 0) {
-			total_count = dqp->q_res_icount + ninos;
+			total_count = dqp->q_ino.reserved + ninos;
 			timer = be32_to_cpu(dqp->q_core.d_itimer);
 			warns = be16_to_cpu(dqp->q_core.d_iwarns);
 			warnlimit = defq->iwarnlimit;
@@ -682,11 +682,11 @@ xfs_trans_dqresv(
 
 	/*
 	 * Change the reservation, but not the actual usage.
-	 * Note that q_res_bcount = q_core.d_bcount + resv
+	 * Note that q_blk.reserved = q_core.d_bcount + resv
 	 */
 	(*resbcountp) += (xfs_qcnt_t)nblks;
 	if (ninos != 0)
-		dqp->q_res_icount += (xfs_qcnt_t)ninos;
+		dqp->q_ino.reserved += (xfs_qcnt_t)ninos;
 
 	/*
 	 * note the reservation amt in the trans struct too,
@@ -707,9 +707,9 @@ xfs_trans_dqresv(
 					    XFS_TRANS_DQ_RES_INOS,
 					    ninos);
 	}
-	ASSERT(dqp->q_res_bcount >= be64_to_cpu(dqp->q_core.d_bcount));
-	ASSERT(dqp->q_res_rtbcount >= be64_to_cpu(dqp->q_core.d_rtbcount));
-	ASSERT(dqp->q_res_icount >= be64_to_cpu(dqp->q_core.d_icount));
+	ASSERT(dqp->q_blk.reserved >= be64_to_cpu(dqp->q_core.d_bcount));
+	ASSERT(dqp->q_rtb.reserved >= be64_to_cpu(dqp->q_core.d_rtbcount));
+	ASSERT(dqp->q_ino.reserved >= be64_to_cpu(dqp->q_core.d_icount));
 
 	xfs_dqunlock(dqp);
 	return 0;

