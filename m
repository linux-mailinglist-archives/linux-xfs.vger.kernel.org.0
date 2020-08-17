Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BA0247ACA
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Aug 2020 00:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbgHQW5g (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Aug 2020 18:57:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51184 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbgHQW5e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Aug 2020 18:57:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMvPki050024;
        Mon, 17 Aug 2020 22:57:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Fso0je9W/5R+a0uAxRBY414MvTjMCO2D6FlWBa/wOOM=;
 b=L1S8J0vqqgHbheqUf8lyAhZHxQQTUQaRnlmvfdFcQy6lueDzmskshGp+N4ifiWutFari
 W9S//+Q6H5oBdQ04DyCoXYRVKP0YT7nzvDDFVV5tX7bPjmkINm4cr7wOsl0nzE5nsVtI
 XK3Wl1ZBhuhTyf1b5XBRwCR4amq3PRciBwmoTtb+qkvMsVeZIRKxFejBivfLSRFRc6zH
 Szej77N72839XWVZ2lJ/qMCUd/hzE7ZyqZbrvJCqoEZ6vfEzUwFITl69gPSXjBRtnCXg
 KjLsj/BsEosp6trt5o2urDWAcc9JDuWtTTx4V4Wi85mqrkIwTrTzpxDsOfH6wX/uq/ZP pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32x7nm9jm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Aug 2020 22:57:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07HMljbY075675;
        Mon, 17 Aug 2020 22:57:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32xsm18mf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Aug 2020 22:57:28 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07HMvRPb017235;
        Mon, 17 Aug 2020 22:57:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Aug 2020 15:57:27 -0700
Subject: [PATCH 06/11] xfs: refactor inode timestamp coding
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Mon, 17 Aug 2020 15:57:26 -0700
Message-ID: <159770504627.3956827.1457402206153045570.stgit@magnolia>
In-Reply-To: <159770500809.3956827.8869892960975362931.stgit@magnolia>
References: <159770500809.3956827.8869892960975362931.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=1
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008170152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9716 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008170153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor inode timestamp encoding and decoding into helper functions so
that we can add extra behaviors in subsequent patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   42 +++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_inode_buf.h |    5 +++++
 fs/xfs/scrub/inode.c          |   25 +++++++++++++++++-------
 fs/xfs/xfs_inode_item.c       |   42 +++++++++++++++++++++++++----------------
 4 files changed, 74 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index fa83591ca89b..4930eabed6d8 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -157,6 +157,15 @@ xfs_imap_to_bp(
 	return 0;
 }
 
+void
+xfs_inode_from_disk_timestamp(
+	struct timespec64		*tv,
+	const struct xfs_timestamp	*ts)
+{
+	tv->tv_sec = (int)be32_to_cpu(ts->t_sec);
+	tv->tv_nsec = (int)be32_to_cpu(ts->t_nsec);
+}
+
 int
 xfs_inode_from_disk(
 	struct xfs_inode	*ip,
@@ -211,12 +220,9 @@ xfs_inode_from_disk(
 	 * a time before epoch is converted to a time long after epoch
 	 * on 64 bit systems.
 	 */
-	inode->i_atime.tv_sec = (int)be32_to_cpu(from->di_atime.t_sec);
-	inode->i_atime.tv_nsec = (int)be32_to_cpu(from->di_atime.t_nsec);
-	inode->i_mtime.tv_sec = (int)be32_to_cpu(from->di_mtime.t_sec);
-	inode->i_mtime.tv_nsec = (int)be32_to_cpu(from->di_mtime.t_nsec);
-	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
-	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
+	xfs_inode_from_disk_timestamp(&inode->i_atime, &from->di_atime);
+	xfs_inode_from_disk_timestamp(&inode->i_mtime, &from->di_mtime);
+	xfs_inode_from_disk_timestamp(&inode->i_ctime, &from->di_ctime);
 
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
@@ -229,8 +235,7 @@ xfs_inode_from_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
-		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
-		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
+		xfs_inode_from_disk_timestamp(&to->di_crtime, &from->di_crtime);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
@@ -252,6 +257,15 @@ xfs_inode_from_disk(
 	return error;
 }
 
+void
+xfs_inode_to_disk_timestamp(
+	struct xfs_timestamp		*ts,
+	const struct timespec64		*tv)
+{
+	ts->t_sec = cpu_to_be32(tv->tv_sec);
+	ts->t_nsec = cpu_to_be32(tv->tv_nsec);
+}
+
 void
 xfs_inode_to_disk(
 	struct xfs_inode	*ip,
@@ -271,12 +285,9 @@ xfs_inode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
-	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
-	to->di_atime.t_nsec = cpu_to_be32(inode->i_atime.tv_nsec);
-	to->di_mtime.t_sec = cpu_to_be32(inode->i_mtime.tv_sec);
-	to->di_mtime.t_nsec = cpu_to_be32(inode->i_mtime.tv_nsec);
-	to->di_ctime.t_sec = cpu_to_be32(inode->i_ctime.tv_sec);
-	to->di_ctime.t_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
+	xfs_inode_to_disk_timestamp(&to->di_atime, &inode->i_atime);
+	xfs_inode_to_disk_timestamp(&to->di_mtime, &inode->i_mtime);
+	xfs_inode_to_disk_timestamp(&to->di_ctime, &inode->i_ctime);
 	to->di_nlink = cpu_to_be32(inode->i_nlink);
 	to->di_gen = cpu_to_be32(inode->i_generation);
 	to->di_mode = cpu_to_be16(inode->i_mode);
@@ -295,8 +306,7 @@ xfs_inode_to_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
+		xfs_inode_to_disk_timestamp(&to->di_crtime, &from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 89f7bea8efd6..9c63f3f932d7 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -58,4 +58,9 @@ xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint32_t cowextsize, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
 
+void xfs_inode_from_disk_timestamp(struct timespec64 *tv,
+		const struct xfs_timestamp *ts);
+void xfs_inode_to_disk_timestamp(struct xfs_timestamp *ts,
+		const struct timespec64 *tv);
+
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 6d483ab29e63..ccb5c217c0ee 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -195,6 +195,19 @@ xchk_inode_flags2(
 	xchk_ino_set_corrupt(sc, ino);
 }
 
+static inline void
+xchk_dinode_nsec(
+	struct xfs_scrub		*sc,
+	xfs_ino_t			ino,
+	const struct xfs_timestamp	*ts)
+{
+	struct timespec64		tv;
+
+	xfs_inode_from_disk_timestamp(&tv, ts);
+	if (tv.tv_nsec < 0 || tv.tv_nsec >= NSEC_PER_SEC)
+		xchk_ino_set_corrupt(sc, ino);
+}
+
 /* Scrub all the ondisk inode fields. */
 STATIC void
 xchk_dinode(
@@ -293,12 +306,9 @@ xchk_dinode(
 	}
 
 	/* di_[amc]time.nsec */
-	if (be32_to_cpu(dip->di_atime.t_nsec) >= NSEC_PER_SEC)
-		xchk_ino_set_corrupt(sc, ino);
-	if (be32_to_cpu(dip->di_mtime.t_nsec) >= NSEC_PER_SEC)
-		xchk_ino_set_corrupt(sc, ino);
-	if (be32_to_cpu(dip->di_ctime.t_nsec) >= NSEC_PER_SEC)
-		xchk_ino_set_corrupt(sc, ino);
+	xchk_dinode_nsec(sc, ino, &dip->di_atime);
+	xchk_dinode_nsec(sc, ino, &dip->di_mtime);
+	xchk_dinode_nsec(sc, ino, &dip->di_ctime);
 
 	/*
 	 * di_size.  xfs_dinode_verify checks for things that screw up
@@ -403,8 +413,7 @@ xchk_dinode(
 	}
 
 	if (dip->di_version >= 3) {
-		if (be32_to_cpu(dip->di_crtime.t_nsec) >= NSEC_PER_SEC)
-			xchk_ino_set_corrupt(sc, ino);
+		xchk_dinode_nsec(sc, ino, &dip->di_crtime);
 		xchk_inode_flags2(sc, dip, ino, mode, flags, flags2);
 		xchk_inode_cowextsize(sc, dip, ino, mode, flags,
 				flags2);
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index d95a00376fad..c2f9a0adeed2 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -295,6 +295,15 @@ xfs_inode_item_format_attr_fork(
 	}
 }
 
+static inline void
+xfs_from_log_timestamp(
+	struct xfs_timestamp		*ts,
+	const struct xfs_ictimestamp	*its)
+{
+	ts->t_sec = cpu_to_be32(its->t_sec);
+	ts->t_nsec = cpu_to_be32(its->t_nsec);
+}
+
 void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
@@ -312,12 +321,9 @@ xfs_log_dinode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
-	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
-	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
-	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
-	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
-	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
-	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
+	xfs_from_log_timestamp(&to->di_atime, &from->di_atime);
+	xfs_from_log_timestamp(&to->di_mtime, &from->di_mtime);
+	xfs_from_log_timestamp(&to->di_ctime, &from->di_ctime);
 
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
@@ -333,8 +339,7 @@ xfs_log_dinode_to_disk(
 
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(from->di_changecount);
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
+		xfs_from_log_timestamp(&to->di_crtime, &from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(from->di_ino);
@@ -347,6 +352,15 @@ xfs_log_dinode_to_disk(
 	}
 }
 
+static inline void
+xfs_to_log_timestamp(
+	struct xfs_ictimestamp		*its,
+	const struct timespec64		*ts)
+{
+	its->t_sec = ts->tv_sec;
+	its->t_nsec = ts->tv_nsec;
+}
+
 static void
 xfs_inode_to_log_dinode(
 	struct xfs_inode	*ip,
@@ -365,12 +379,9 @@ xfs_inode_to_log_dinode(
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
-	to->di_atime.t_sec = inode->i_atime.tv_sec;
-	to->di_atime.t_nsec = inode->i_atime.tv_nsec;
-	to->di_mtime.t_sec = inode->i_mtime.tv_sec;
-	to->di_mtime.t_nsec = inode->i_mtime.tv_nsec;
-	to->di_ctime.t_sec = inode->i_ctime.tv_sec;
-	to->di_ctime.t_nsec = inode->i_ctime.tv_nsec;
+	xfs_to_log_timestamp(&to->di_atime, &inode->i_atime);
+	xfs_to_log_timestamp(&to->di_mtime, &inode->i_mtime);
+	xfs_to_log_timestamp(&to->di_ctime, &inode->i_ctime);
 	to->di_nlink = inode->i_nlink;
 	to->di_gen = inode->i_generation;
 	to->di_mode = inode->i_mode;
@@ -392,8 +403,7 @@ xfs_inode_to_log_dinode(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = inode_peek_iversion(inode);
-		to->di_crtime.t_sec = from->di_crtime.tv_sec;
-		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
+		xfs_to_log_timestamp(&to->di_crtime, &from->di_crtime);
 		to->di_flags2 = from->di_flags2;
 		to->di_cowextsize = from->di_cowextsize;
 		to->di_ino = ip->i_ino;

