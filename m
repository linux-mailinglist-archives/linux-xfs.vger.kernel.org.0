Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EF525A359
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Sep 2020 04:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgIBC53 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Sep 2020 22:57:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51268 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgIBC5Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 22:57:25 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822tMNl003524;
        Wed, 2 Sep 2020 02:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=3ijgbC7yyzxeVVKnPPSUlfoqZZI7aDD32UupKMKfSLw=;
 b=glEuB3jgu73UsyPmsFFtd1nuBGR7Pv4oMMOmaQVc/y/4iWpFLGbyhVMJWgm1igKMLg5r
 oh4fT39lErz37MDDKGAOgZ5UK8HWqti34GwNmuHBRTPDijK8d8fngfYXTZK0HJMOBZ0y
 t05xR40deui49Z84M2zDbt5+f74tiFmCv8SzSTlmEgfgHlwFiYAylb1OMKdoSCuzHtDd
 V+S1RAU+RcNEx61J6TNtDJDHNeedjKlhV3RuMrLoo63ATJcp+/MmklqYdqX/0bd6kw9o
 a9AcfVFlhDtJjXocD7jGjTBzXHySJw8mI7kwvEOtcvA+WWFwBtdT2/IVjfkqWm3xDTkn +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 337eeqyvma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 02:57:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0822t1Dq186050;
        Wed, 2 Sep 2020 02:57:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3380st0wxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 02:57:12 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0822vBsp028499;
        Wed, 2 Sep 2020 02:57:11 GMT
Received: from localhost (/10.159.133.7)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Sep 2020 19:57:11 -0700
Subject: [PATCH 06/11] xfs: redefine xfs_timestamp_t
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     Christoph Hellwig <hch@lst.de>, Gao Xiang <hsiangkao@redhat.com>,
        linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Tue, 01 Sep 2020 19:57:09 -0700
Message-ID: <159901542934.548109.4659766297335710004.stgit@magnolia>
In-Reply-To: <159901538766.548109.8040337941204954344.stgit@magnolia>
References: <159901538766.548109.8040337941204954344.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9731 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020026
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Redefine xfs_timestamp_t as a __be64 typedef in preparation for the
bigtime functionality.  Preserve the legacy structure format so that we
can let the compiler take care of masking and shifting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h      |   10 +++++--
 fs/xfs/libxfs/xfs_inode_buf.c   |   54 +++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_inode_buf.h   |    2 +
 fs/xfs/scrub/inode.c            |   25 ++++++++++++------
 fs/xfs/xfs_inode_item_recover.c |   27 ++++++++++++++------
 fs/xfs/xfs_ondisk.h             |    3 +-
 6 files changed, 85 insertions(+), 36 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 4b68a473b090..d9b629f12c00 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -856,12 +856,16 @@ struct xfs_agfl {
  * seconds and nanoseconds; time zero is the Unix epoch, Jan  1 00:00:00 UTC
  * 1970, which means that the timestamp epoch is the same as the Unix epoch.
  * Therefore, the ondisk min and max defined here can be used directly to
- * constrain the incore timestamps on a Unix system.
+ * constrain the incore timestamps on a Unix system.  Note that we actually
+ * encode a __be64 value on disk.
  */
-typedef struct xfs_timestamp {
+typedef __be64 xfs_timestamp_t;
+
+/* Legacy timestamp encoding format. */
+struct xfs_legacy_timestamp {
 	__be32		t_sec;		/* timestamp seconds */
 	__be32		t_nsec;		/* timestamp nanoseconds */
-} xfs_timestamp_t;
+};
 
 /*
  * Smallest possible ondisk seconds value with traditional timestamps.  This
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index fa83591ca89b..4dc43be9ad96 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -157,6 +157,21 @@ xfs_imap_to_bp(
 	return 0;
 }
 
+/* Convert an ondisk timestamp to an incore timestamp. */
+struct timespec64
+xfs_inode_from_disk_ts(
+	const xfs_timestamp_t		ts)
+{
+	struct timespec64		tv;
+	struct xfs_legacy_timestamp	*lts;
+
+	lts = (struct xfs_legacy_timestamp *)&ts;
+	tv.tv_sec = (int)be32_to_cpu(lts->t_sec);
+	tv.tv_nsec = (int)be32_to_cpu(lts->t_nsec);
+
+	return tv;
+}
+
 int
 xfs_inode_from_disk(
 	struct xfs_inode	*ip,
@@ -211,12 +226,9 @@ xfs_inode_from_disk(
 	 * a time before epoch is converted to a time long after epoch
 	 * on 64 bit systems.
 	 */
-	inode->i_atime.tv_sec = (int)be32_to_cpu(from->di_atime.t_sec);
-	inode->i_atime.tv_nsec = (int)be32_to_cpu(from->di_atime.t_nsec);
-	inode->i_mtime.tv_sec = (int)be32_to_cpu(from->di_mtime.t_sec);
-	inode->i_mtime.tv_nsec = (int)be32_to_cpu(from->di_mtime.t_nsec);
-	inode->i_ctime.tv_sec = (int)be32_to_cpu(from->di_ctime.t_sec);
-	inode->i_ctime.tv_nsec = (int)be32_to_cpu(from->di_ctime.t_nsec);
+	inode->i_atime = xfs_inode_from_disk_ts(from->di_atime);
+	inode->i_mtime = xfs_inode_from_disk_ts(from->di_mtime);
+	inode->i_ctime = xfs_inode_from_disk_ts(from->di_ctime);
 
 	to->di_size = be64_to_cpu(from->di_size);
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
@@ -229,8 +241,7 @@ xfs_inode_from_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
-		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
-		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
+		to->di_crtime = xfs_inode_from_disk_ts(from->di_crtime);
 		to->di_flags2 = be64_to_cpu(from->di_flags2);
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
@@ -252,6 +263,21 @@ xfs_inode_from_disk(
 	return error;
 }
 
+/* Convert an incore timestamp to an ondisk timestamp. */
+static inline xfs_timestamp_t
+xfs_inode_to_disk_ts(
+	const struct timespec64		tv)
+{
+	struct xfs_legacy_timestamp	*lts;
+	xfs_timestamp_t			ts;
+
+	lts = (struct xfs_legacy_timestamp *)&ts;
+	lts->t_sec = cpu_to_be32(tv.tv_sec);
+	lts->t_nsec = cpu_to_be32(tv.tv_nsec);
+
+	return ts;
+}
+
 void
 xfs_inode_to_disk(
 	struct xfs_inode	*ip,
@@ -271,12 +297,9 @@ xfs_inode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
-	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
-	to->di_atime.t_nsec = cpu_to_be32(inode->i_atime.tv_nsec);
-	to->di_mtime.t_sec = cpu_to_be32(inode->i_mtime.tv_sec);
-	to->di_mtime.t_nsec = cpu_to_be32(inode->i_mtime.tv_nsec);
-	to->di_ctime.t_sec = cpu_to_be32(inode->i_ctime.tv_sec);
-	to->di_ctime.t_nsec = cpu_to_be32(inode->i_ctime.tv_nsec);
+	to->di_atime = xfs_inode_to_disk_ts(inode->i_atime);
+	to->di_mtime = xfs_inode_to_disk_ts(inode->i_mtime);
+	to->di_ctime = xfs_inode_to_disk_ts(inode->i_ctime);
 	to->di_nlink = cpu_to_be32(inode->i_nlink);
 	to->di_gen = cpu_to_be32(inode->i_generation);
 	to->di_mode = cpu_to_be16(inode->i_mode);
@@ -295,8 +318,7 @@ xfs_inode_to_disk(
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
 		to->di_version = 3;
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
+		to->di_crtime = xfs_inode_to_disk_ts(from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 89f7bea8efd6..3060ecd24a2e 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -58,4 +58,6 @@ xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
 		uint32_t cowextsize, uint16_t mode, uint16_t flags,
 		uint64_t flags2);
 
+struct timespec64 xfs_inode_from_disk_ts(const xfs_timestamp_t ts);
+
 #endif	/* __XFS_INODE_BUF_H__ */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 6d483ab29e63..eb1cc013d4ca 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -195,6 +195,19 @@ xchk_inode_flags2(
 	xchk_ino_set_corrupt(sc, ino);
 }
 
+static inline void
+xchk_dinode_nsec(
+	struct xfs_scrub	*sc,
+	xfs_ino_t		ino,
+	const xfs_timestamp_t	ts)
+{
+	struct timespec64	tv;
+
+	tv = xfs_inode_from_disk_ts(ts);
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
+	xchk_dinode_nsec(sc, ino, dip->di_atime);
+	xchk_dinode_nsec(sc, ino, dip->di_mtime);
+	xchk_dinode_nsec(sc, ino, dip->di_ctime);
 
 	/*
 	 * di_size.  xfs_dinode_verify checks for things that screw up
@@ -403,8 +413,7 @@ xchk_dinode(
 	}
 
 	if (dip->di_version >= 3) {
-		if (be32_to_cpu(dip->di_crtime.t_nsec) >= NSEC_PER_SEC)
-			xchk_ino_set_corrupt(sc, ino);
+		xchk_dinode_nsec(sc, ino, dip->di_crtime);
 		xchk_inode_flags2(sc, dip, ino, mode, flags, flags2);
 		xchk_inode_cowextsize(sc, dip, ino, mode, flags,
 				flags2);
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 1e417ace2912..03fab432df38 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -115,6 +115,21 @@ xfs_recover_inode_owner_change(
 	return error;
 }
 
+/* Convert a log timestamp to an ondisk timestamp. */
+static inline xfs_timestamp_t
+xfs_log_dinode_to_disk_ts(
+	const xfs_ictimestamp_t		its)
+{
+	struct xfs_legacy_timestamp	*lts;
+	xfs_timestamp_t			ts;
+
+	lts = (struct xfs_legacy_timestamp *)&ts;
+	lts->t_sec = cpu_to_be32(its.t_sec);
+	lts->t_nsec = cpu_to_be32(its.t_nsec);
+
+	return ts;
+}
+
 STATIC void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
@@ -132,12 +147,9 @@ xfs_log_dinode_to_disk(
 	to->di_projid_hi = cpu_to_be16(from->di_projid_hi);
 	memcpy(to->di_pad, from->di_pad, sizeof(to->di_pad));
 
-	to->di_atime.t_sec = cpu_to_be32(from->di_atime.t_sec);
-	to->di_atime.t_nsec = cpu_to_be32(from->di_atime.t_nsec);
-	to->di_mtime.t_sec = cpu_to_be32(from->di_mtime.t_sec);
-	to->di_mtime.t_nsec = cpu_to_be32(from->di_mtime.t_nsec);
-	to->di_ctime.t_sec = cpu_to_be32(from->di_ctime.t_sec);
-	to->di_ctime.t_nsec = cpu_to_be32(from->di_ctime.t_nsec);
+	to->di_atime = xfs_log_dinode_to_disk_ts(from->di_atime);
+	to->di_mtime = xfs_log_dinode_to_disk_ts(from->di_mtime);
+	to->di_ctime = xfs_log_dinode_to_disk_ts(from->di_ctime);
 
 	to->di_size = cpu_to_be64(from->di_size);
 	to->di_nblocks = cpu_to_be64(from->di_nblocks);
@@ -153,8 +165,7 @@ xfs_log_dinode_to_disk(
 
 	if (from->di_version == 3) {
 		to->di_changecount = cpu_to_be64(from->di_changecount);
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.t_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.t_nsec);
+		to->di_crtime = xfs_log_dinode_to_disk_ts(from->di_crtime);
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(from->di_ino);
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index acb9b737fe6b..4e5f51d07d8d 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -41,7 +41,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_rec,		12);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_timestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(xfs_timestamp_t,			8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_legacy_timestamp,	8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);

