Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896D521E532
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jul 2020 03:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgGNBfK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Jul 2020 21:35:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39896 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgGNBfK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 21:35:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1WATO096166;
        Tue, 14 Jul 2020 01:35:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=FY6n7o/VwDNuTkYjRmsKJHl9hpqUOWzCYohOt4DVFs8=;
 b=tPthFCMQNYuxQZx6Q0z95nMnx9UYO4ehp+JYfpjAFHngvND2IwkKJGWMvHZ1wEoeXcwH
 4p9mNORTx9eUKycs7tX2UO9I3g69tO2zCImwT2zXq2LB9JJTTPYpfMsE+rvlTPxWLZAe
 M9Sgrctj0iw6wfv5gpjS/ebbpOkNUJ9CB58IoLWe8NysRumrK38ySX05r/3jN0X+oXKd
 od9AyZTobTKm/CTuf0eodVTN6ZMRi3raD52M3XGPYfApSM/KeauS5loul6aoYVh3Ctkr
 x9/w5j97edhFuegSyh+tC6mf/61vR2zrP9KBwVKbMPaVkIKcNnOKOLzGbjiIF4QSMbsz zw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3274ur2f5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 01:35:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E1TXY7107101;
        Tue, 14 Jul 2020 01:33:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 327q6r5apu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 01:33:05 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06E1X4gS012614;
        Tue, 14 Jul 2020 01:33:05 GMT
Received: from localhost (/10.159.128.100)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 18:33:04 -0700
Subject: [PATCH 15/26] xfs: stop using q_core warning counters in the quota
 code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Mon, 13 Jul 2020 18:33:04 -0700
Message-ID: <159469038408.2914673.1587745334091299301.stgit@magnolia>
In-Reply-To: <159469028734.2914673.17856142063205791176.stgit@magnolia>
References: <159469028734.2914673.17856142063205791176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140008
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

Add warning counter fields to the incore dquot, and use that instead of
the ones in qcore.  This eliminates a bunch of endian conversions and
will eventually allow us to remove qcore entirely.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/xfs_dquot.c       |   14 +++++++++++---
 fs/xfs/xfs_dquot.h       |    8 ++++++++
 fs/xfs/xfs_qm.c          |   12 ++++++------
 fs/xfs/xfs_qm_syscalls.c |   12 ++++++------
 fs/xfs/xfs_trans_dquot.c |    6 +++---
 5 files changed, 34 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 2de6ce12d690..44a082cb6b87 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -140,7 +140,7 @@ xfs_qm_adjust_dqtimers(
 			d->d_btimer = cpu_to_be32(ktime_get_real_seconds() +
 					defq->btimelimit);
 		} else {
-			d->d_bwarns = 0;
+			dq->q_blk.warnings = 0;
 		}
 	} else {
 		if ((!dq->q_blk.softlimit ||
@@ -159,7 +159,7 @@ xfs_qm_adjust_dqtimers(
 			d->d_itimer = cpu_to_be32(ktime_get_real_seconds() +
 					defq->itimelimit);
 		} else {
-			d->d_iwarns = 0;
+			dq->q_ino.warnings = 0;
 		}
 	} else {
 		if ((!dq->q_ino.softlimit ||
@@ -178,7 +178,7 @@ xfs_qm_adjust_dqtimers(
 			d->d_rtbtimer = cpu_to_be32(ktime_get_real_seconds() +
 					defq->rtbtimelimit);
 		} else {
-			d->d_rtbwarns = 0;
+			dq->q_rtb.warnings = 0;
 		}
 	} else {
 		if ((!dq->q_rtb.softlimit ||
@@ -549,6 +549,10 @@ xfs_dquot_from_disk(
 	dqp->q_ino.count = be64_to_cpu(ddqp->d_icount);
 	dqp->q_rtb.count = be64_to_cpu(ddqp->d_rtbcount);
 
+	dqp->q_blk.warnings = be16_to_cpu(ddqp->d_bwarns);
+	dqp->q_ino.warnings = be16_to_cpu(ddqp->d_iwarns);
+	dqp->q_rtb.warnings = be16_to_cpu(ddqp->d_rtbwarns);
+
 	/*
 	 * Reservation counters are defined as reservation plus current usage
 	 * to avoid having to add every time.
@@ -580,6 +584,10 @@ xfs_dquot_to_disk(
 	ddqp->d_bcount = cpu_to_be64(dqp->q_blk.count);
 	ddqp->d_icount = cpu_to_be64(dqp->q_ino.count);
 	ddqp->d_rtbcount = cpu_to_be64(dqp->q_rtb.count);
+
+	ddqp->d_bwarns = cpu_to_be16(dqp->q_blk.warnings);
+	ddqp->d_iwarns = cpu_to_be16(dqp->q_ino.warnings);
+	ddqp->d_rtbwarns = cpu_to_be16(dqp->q_rtb.warnings);
 }
 
 /* Allocate and initialize the dquot buffer for this in-core dquot. */
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index f470731d3cfd..4c6460637e55 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -37,6 +37,14 @@ struct xfs_dquot_res {
 	/* Absolute and preferred limits. */
 	xfs_qcnt_t		hardlimit;
 	xfs_qcnt_t		softlimit;
+
+	/*
+	 * For root dquots, this is the maximum number of warnings that will
+	 * be issued for this quota type.  Otherwise, this is the number of
+	 * warnings issued against this quota.  Note that none of this is
+	 * implemented.
+	 */
+	xfs_qwarncnt_t		warnings;
 };
 
 /*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b7b1049640d8..5633c03109c0 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -614,12 +614,12 @@ xfs_qm_init_timelimits(
 		defq->itimelimit = be32_to_cpu(ddqp->d_itimer);
 	if (ddqp->d_rtbtimer)
 		defq->rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
-	if (ddqp->d_bwarns)
-		defq->bwarnlimit = be16_to_cpu(ddqp->d_bwarns);
-	if (ddqp->d_iwarns)
-		defq->iwarnlimit = be16_to_cpu(ddqp->d_iwarns);
-	if (ddqp->d_rtbwarns)
-		defq->rtbwarnlimit = be16_to_cpu(ddqp->d_rtbwarns);
+	if (dqp->q_blk.warnings)
+		defq->bwarnlimit = dqp->q_blk.warnings;
+	if (dqp->q_ino.warnings)
+		defq->iwarnlimit = dqp->q_ino.warnings;
+	if (dqp->q_rtb.warnings)
+		defq->rtbwarnlimit = dqp->q_rtb.warnings;
 
 	xfs_qm_dqdestroy(dqp);
 }
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 7aebd588bdf7..4352169b644c 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -548,11 +548,11 @@ xfs_qm_scall_setqlim(
 	 * Update warnings counter(s) if requested
 	 */
 	if (newlim->d_fieldmask & QC_SPC_WARNS)
-		ddq->d_bwarns = cpu_to_be16(newlim->d_spc_warns);
+		dqp->q_blk.warnings = newlim->d_spc_warns;
 	if (newlim->d_fieldmask & QC_INO_WARNS)
-		ddq->d_iwarns = cpu_to_be16(newlim->d_ino_warns);
+		dqp->q_ino.warnings = newlim->d_ino_warns;
 	if (newlim->d_fieldmask & QC_RT_SPC_WARNS)
-		ddq->d_rtbwarns = cpu_to_be16(newlim->d_rt_spc_warns);
+		dqp->q_rtb.warnings = newlim->d_rt_spc_warns;
 
 	if (id == 0) {
 		if (newlim->d_fieldmask & QC_SPC_WARNS)
@@ -627,13 +627,13 @@ xfs_qm_scall_getquota_fill_qc(
 	dst->d_ino_count = dqp->q_ino.reserved;
 	dst->d_spc_timer = be32_to_cpu(dqp->q_core.d_btimer);
 	dst->d_ino_timer = be32_to_cpu(dqp->q_core.d_itimer);
-	dst->d_ino_warns = be16_to_cpu(dqp->q_core.d_iwarns);
-	dst->d_spc_warns = be16_to_cpu(dqp->q_core.d_bwarns);
+	dst->d_ino_warns = dqp->q_ino.warnings;
+	dst->d_spc_warns = dqp->q_blk.warnings;
 	dst->d_rt_spc_hardlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.hardlimit);
 	dst->d_rt_spc_softlimit = XFS_FSB_TO_B(mp, dqp->q_rtb.softlimit);
 	dst->d_rt_space = XFS_FSB_TO_B(mp, dqp->q_rtb.reserved);
 	dst->d_rt_spc_timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
-	dst->d_rt_spc_warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
+	dst->d_rt_spc_warns = dqp->q_rtb.warnings;
 
 	/*
 	 * Internally, we don't reset all the timers when quota enforcement
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 96d4691df26e..995636a63685 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -599,7 +599,7 @@ xfs_trans_dqresv(
 		if (!softlimit)
 			softlimit = defq->bsoftlimit;
 		timer = be32_to_cpu(dqp->q_core.d_btimer);
-		warns = be16_to_cpu(dqp->q_core.d_bwarns);
+		warns = dqp->q_blk.warnings;
 		warnlimit = defq->bwarnlimit;
 		resbcountp = &dqp->q_blk.reserved;
 	} else {
@@ -611,7 +611,7 @@ xfs_trans_dqresv(
 		if (!softlimit)
 			softlimit = defq->rtbsoftlimit;
 		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
-		warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
+		warns = dqp->q_rtb.warnings;
 		warnlimit = defq->rtbwarnlimit;
 		resbcountp = &dqp->q_rtb.reserved;
 	}
@@ -646,7 +646,7 @@ xfs_trans_dqresv(
 		if (ninos > 0) {
 			total_count = dqp->q_ino.reserved + ninos;
 			timer = be32_to_cpu(dqp->q_core.d_itimer);
-			warns = be16_to_cpu(dqp->q_core.d_iwarns);
+			warns = dqp->q_ino.warnings;
 			warnlimit = defq->iwarnlimit;
 			hardlimit = dqp->q_ino.hardlimit;
 			if (!hardlimit)

