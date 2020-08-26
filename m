Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E675F253A11
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Aug 2020 00:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgHZWGH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Aug 2020 18:06:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53030 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgHZWGG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 18:06:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QM02ag028603;
        Wed, 26 Aug 2020 22:06:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=61EDm7JsBXgiaLgemeUd9W7fv6w+FDc77McATZF6iuE=;
 b=gQDthkU+Cz6SE7y4znBNd89ENmK4ziDnLLRV3uhoUw5y9uAd2DqWHhgW15nFIY8dqVgN
 CYzie1D+GgCvQVwowP8k0LrvBSN66p5q8auOxkYSVNvgb+QlPkwHYQxmWJmgedLFLFox
 K5y1YTu5XxJlHzLHEPuz3NSAtoSOwct7MFXKjaXdy5fPQiEj6FiUqLCmIKmqTYbBWxL4
 QFKrtQ9TwbaMUGEAP6hgwQbb9T9dTGAcTAEhx95SXFOykmg6SLSHz2OZn0DQIPYigYlU
 6bDsKpk9sM8UPSm3XqS/OqqhbycEX+WUfkOm82ZPaf7Vztv+DMeOU0KtKH5raXHlzvDb vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 333dbs31n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 22:05:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QM0JU9004051;
        Wed, 26 Aug 2020 22:05:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 333rubbfkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 22:05:59 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07QM5wRo002116;
        Wed, 26 Aug 2020 22:05:58 GMT
Received: from localhost (/10.159.146.4)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 15:05:57 -0700
Subject: [PATCH 09/11] xfs: widen ondisk quota expiration timestamps to handle
 y2038+
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, david@fromorbit.com, hch@infradead.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Date:   Wed, 26 Aug 2020 15:05:56 -0700
Message-ID: <159847955663.2601708.15732334977032233773.stgit@magnolia>
In-Reply-To: <159847949739.2601708.16579235017313836378.stgit@magnolia>
References: <159847949739.2601708.16579235017313836378.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260169
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260169
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Enable the bigtime feature for quota timers.  We decrease the accuracy
of the timers to ~4s in exchange for being able to set timers up to the
bigtime maximum.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |   21 +++++++++++++++--
 fs/xfs/libxfs/xfs_format.h     |   50 +++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_quota_defs.h |    3 ++
 fs/xfs/xfs_dquot.c             |   10 ++++++++
 fs/xfs/xfs_ondisk.h            |    5 ++++
 fs/xfs/xfs_qm.c                |   13 +++++++++-
 fs/xfs/xfs_trans_dquot.c       |    6 +++++
 7 files changed, 102 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index cf85bad8a894..6766417d5ba4 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -69,6 +69,13 @@ xfs_dquot_verify(
 	    ddq_type != XFS_DQTYPE_GROUP)
 		return __this_address;
 
+	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) &&
+	    !xfs_sb_version_hasbigtime(&mp->m_sb))
+		return __this_address;
+
+	if ((ddq->d_type & XFS_DQTYPE_BIGTIME) && !ddq->d_id)
+		return __this_address;
+
 	if (id != -1 && id != be32_to_cpu(ddq->d_id))
 		return __this_address;
 
@@ -295,7 +302,12 @@ xfs_dquot_from_disk_ts(
 	struct xfs_disk_dquot	*ddq,
 	__be32			dtimer)
 {
-	return be32_to_cpu(dtimer);
+	uint32_t		t = be32_to_cpu(dtimer);
+
+	if (t != 0 && (ddq->d_type & XFS_DQTYPE_BIGTIME))
+		return xfs_dq_bigtime_to_unix(t);
+
+	return t;
 }
 
 /* Convert an incore timer value into an on-disk timer value. */
@@ -304,5 +316,10 @@ xfs_dquot_to_disk_ts(
 	struct xfs_dquot	*dqp,
 	time64_t		timer)
 {
-	return cpu_to_be32(timer);
+	uint32_t		t = timer;
+
+	if (timer != 0 && (dqp->q_type & XFS_DQTYPE_BIGTIME))
+		t = xfs_dq_unix_to_bigtime(timer);
+
+	return cpu_to_be32(t);
 }
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 972c740aaf7b..9cf84b57e2ce 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1257,13 +1257,15 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 #define XFS_DQTYPE_USER		0x01		/* user dquot record */
 #define XFS_DQTYPE_PROJ		0x02		/* project dquot record */
 #define XFS_DQTYPE_GROUP	0x04		/* group dquot record */
+#define XFS_DQTYPE_BIGTIME	0x08		/* large expiry timestamps */
 
 /* bitmask to determine if this is a user/group/project dquot */
 #define XFS_DQTYPE_REC_MASK	(XFS_DQTYPE_USER | \
 				 XFS_DQTYPE_PROJ | \
 				 XFS_DQTYPE_GROUP)
 
-#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
+#define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK | \
+				 XFS_DQTYPE_BIGTIME)
 
 /*
  * XFS Quota Timers
@@ -1276,6 +1278,10 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
  * ondisk min and max defined here can be used directly to constrain the incore
  * quota expiration timestamps on a Unix system.
  *
+ * When bigtime is enabled, we trade two bits of precision to expand the
+ * expiration timeout range to match that of big inode timestamps.  The min and
+ * max recorded here are the on-disk limits, not a Unix timestamp.
+ *
  * The grace period for each quota type is stored in the root dquot (id = 0)
  * and is applied to a non-root dquot when it exceeds the soft or hard limits.
  * The length of quota grace periods are unsigned 32-bit quantities measured in
@@ -1294,6 +1300,48 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
  */
 #define XFS_DQ_LEGACY_EXPIRY_MAX	((int64_t)U32_MAX)
 
+/*
+ * Smallest possible ondisk quota expiration value with bigtime timestamps.
+ * This corresponds (after conversion to a Unix timestamp) with the incore
+ * expiration of Jan  1 00:00:04 UTC 1970.
+ */
+#define XFS_DQ_BIGTIME_EXPIRY_MIN	(XFS_DQ_LEGACY_EXPIRY_MIN)
+
+/*
+ * Largest supported ondisk quota expiration value with bigtime timestamps.
+ * This corresponds (after conversion to a Unix timestamp) with an incore
+ * expiration of Jul  2 20:20:24 UTC 2486.
+ *
+ * The ondisk field supports values up to -1U, which corresponds to an incore
+ * expiration in 2514.  This is beyond the maximum the bigtime inode timestamp,
+ * so we cap the maximum bigtime quota expiration to the max inode timestamp.
+ */
+#define XFS_DQ_BIGTIME_EXPIRY_MAX	((int64_t)4074815106U)
+
+/*
+ * The following conversion factors assist in converting a quota expiration
+ * timestamp between the incore and ondisk formats.
+ */
+#define XFS_DQ_BIGTIME_SHIFT	(2)
+#define XFS_DQ_BIGTIME_SLACK	((int64_t)(1ULL << XFS_DQ_BIGTIME_SHIFT) - 1)
+
+/* Convert an incore quota expiration timestamp to an ondisk bigtime value. */
+static inline uint32_t xfs_dq_unix_to_bigtime(time64_t unix_seconds)
+{
+	/*
+	 * Round the expiration timestamp up to the nearest bigtime timestamp
+	 * that we can store, to give users the most time to fix problems.
+	 */
+	return ((uint64_t)unix_seconds + XFS_DQ_BIGTIME_SLACK) >>
+			XFS_DQ_BIGTIME_SHIFT;
+}
+
+/* Convert an ondisk bigtime quota expiration value to an incore timestamp. */
+static inline time64_t xfs_dq_bigtime_to_unix(uint32_t ondisk_seconds)
+{
+	return (time64_t)ondisk_seconds << XFS_DQ_BIGTIME_SHIFT;
+}
+
 /*
  * Default quota grace periods, ranging from zero (use the compiled defaults)
  * to ~136 years.  These are applied to a non-root dquot that has exceeded
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 9a99910d857e..0f0af4e35032 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -23,7 +23,8 @@ typedef uint8_t		xfs_dqtype_t;
 #define XFS_DQTYPE_STRINGS \
 	{ XFS_DQTYPE_USER,	"USER" }, \
 	{ XFS_DQTYPE_PROJ,	"PROJ" }, \
-	{ XFS_DQTYPE_GROUP,	"GROUP" }
+	{ XFS_DQTYPE_GROUP,	"GROUP" }, \
+	{ XFS_DQTYPE_BIGTIME,	"BIGTIME" }
 
 /*
  * flags for q_flags field in the dquot.
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 59c03e973741..3f9e11c3df1e 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -223,6 +223,8 @@ xfs_qm_init_dquot_blk(
 		d->dd_diskdq.d_version = XFS_DQUOT_VERSION;
 		d->dd_diskdq.d_id = cpu_to_be32(curid);
 		d->dd_diskdq.d_type = type;
+		if (curid > 0 && xfs_sb_version_hasbigtime(&mp->m_sb))
+			d->dd_diskdq.d_type |= XFS_DQTYPE_BIGTIME;
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
 			uuid_copy(&d->dd_uuid, &mp->m_sb.sb_meta_uuid);
 			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
@@ -1167,6 +1169,14 @@ xfs_qm_dqflush_check(
 	    !dqp->q_rtb.timer)
 		return __this_address;
 
+	/* bigtime flag should never be set on root dquots */
+	if (dqp->q_type & XFS_DQTYPE_BIGTIME) {
+		if (!xfs_sb_version_hasbigtime(&dqp->q_mount->m_sb))
+			return __this_address;
+		if (dqp->q_id == 0)
+			return __this_address;
+	}
+
 	return NULL;
 }
 
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 52db8743def1..a13686ce0626 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -165,6 +165,11 @@ xfs_check_ondisk_structs(void)
 			XFS_LEGACY_TIME_MIN);
 	XFS_CHECK_VALUE(XFS_BIGTIME_TIME_MAX - XFS_BIGTIME_EPOCH_OFFSET,
 			16299260424LL);
+
+	/* Do the same with the incore quota expiration range. */
+	XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MIN << XFS_DQ_BIGTIME_SHIFT, 4);
+	XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MAX << XFS_DQ_BIGTIME_SHIFT,
+			16299260424LL);
 }
 
 #endif /* __XFS_ONDISK_H */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b83a12ecfc35..259588a4227d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -661,8 +661,15 @@ xfs_qm_init_quotainfo(
 	/* Precalc some constants */
 	qinf->qi_dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
 	qinf->qi_dqperchunk = xfs_calc_dquots_per_chunk(qinf->qi_dqchunklen);
-	qinf->qi_expiry_min = XFS_DQ_LEGACY_EXPIRY_MIN;
-	qinf->qi_expiry_max = XFS_DQ_LEGACY_EXPIRY_MAX;
+	if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
+		qinf->qi_expiry_min =
+			xfs_dq_bigtime_to_unix(XFS_DQ_BIGTIME_EXPIRY_MIN);
+		qinf->qi_expiry_max =
+			xfs_dq_bigtime_to_unix(XFS_DQ_BIGTIME_EXPIRY_MAX);
+	} else {
+		qinf->qi_expiry_min = XFS_DQ_LEGACY_EXPIRY_MIN;
+		qinf->qi_expiry_max = XFS_DQ_LEGACY_EXPIRY_MAX;
+	}
 
 	mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
 
@@ -881,6 +888,8 @@ xfs_qm_reset_dqcounts(
 			ddq->d_bwarns = 0;
 			ddq->d_iwarns = 0;
 			ddq->d_rtbwarns = 0;
+			if (xfs_sb_version_hasbigtime(&mp->m_sb))
+				ddq->d_type |= XFS_DQTYPE_BIGTIME;
 		}
 
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index c6ba7ef18e06..133fc6fc3edd 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -55,6 +55,12 @@ xfs_trans_log_dquot(
 {
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
+	/* Upgrade the dquot to bigtime format if possible. */
+	if (dqp->q_id != 0 &&
+	    xfs_sb_version_hasbigtime(&tp->t_mountp->m_sb) &&
+	    !(dqp->q_type & XFS_DQTYPE_BIGTIME))
+		dqp->q_type |= XFS_DQTYPE_BIGTIME;
+
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &dqp->q_logitem.qli_item.li_flags);
 }

