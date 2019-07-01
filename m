Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D78332E836
	for <lists+linux-xfs@lfdr.de>; Thu, 30 May 2019 00:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfE2W1z (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 May 2019 18:27:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37200 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfE2W1y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:27:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TM3g2G041457
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Y9HrEw9kAWOrAFUrISU8FTitY/4VE1s0BwKItKvPQRk=;
 b=2OGqOEoydKoerZLRuU14sLBwyXJu4DstMYBNj3yeVDFiy/Ns8nTK0J5HuStHoMbBWgJA
 JV1l5rk0xnSaweGfQmBxylmZCFxa9HPLnPcdcTo1mwEWkTNtTnubRtpAFAqqLWuCr6wl
 jSSi6cU2Q6iPYze+8X4ZRqkxxQtBule+PT1a2Q+I19cchBPA6NUVhz1xQ02u4YyWkTsS
 XyMrL894Hw+Z8uWH8ScIzmuB5Hv0CYsmZbRZV29sl56niAbeL3VS0gkVqYsW6IEKi2RY
 bbpz/a5aesU0eYmKc4V+rsoUOvlrVOUXtVb4bPKStUixoPicn0HweiOEx3eUv6EKMA7N sQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 2spu7dn19t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMQOL6172692
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2sqh73ym4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:51 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4TMRoof004062
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:51 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 15:27:50 -0700
Subject: [PATCH 3/9] xfs: introduce new v5 bulkstat structure
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 May 2019 15:27:49 -0700
Message-ID: <155916886943.758159.11587690616263098061.stgit@magnolia>
In-Reply-To: <155916885106.758159.3471602893858635007.stgit@magnolia>
References: <155916885106.758159.3471602893858635007.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Introduce a new version of the in-core bulkstat structure that supports
our new v5 format features.  This structure also fills the gaps in the
previous structure.  We leave wiring up the ioctls for the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h     |   48 +++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_health.h |    2 +
 fs/xfs/xfs_health.c        |    2 +
 fs/xfs/xfs_ioctl.c         |    9 ++++--
 fs/xfs/xfs_ioctl.h         |    2 +
 fs/xfs/xfs_ioctl32.c       |   10 +++++--
 fs/xfs/xfs_itable.c        |   67 +++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_itable.h        |    4 ++-
 fs/xfs/xfs_ondisk.h        |    2 +
 9 files changed, 119 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index ef0dce229fa4..132e364eb141 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -358,6 +358,52 @@ struct xfs_bstat {
 	__u16		bs_aextents;	/* attribute number of extents	*/
 };
 
+/* New bulkstat structure that reports v5 features and fixes padding issues */
+struct xfs_bulkstat {
+	uint64_t	bs_ino;		/* inode number			*/
+	uint64_t	bs_size;	/* file size			*/
+
+	uint64_t	bs_blocks;	/* number of blocks		*/
+	uint64_t	bs_xflags;	/* extended flags		*/
+
+	uint64_t	bs_atime;	/* access time, seconds		*/
+	uint64_t	bs_mtime;	/* modify time, seconds		*/
+
+	uint64_t	bs_ctime;	/* inode change time, seconds	*/
+	uint64_t	bs_btime;	/* creation time, seconds	*/
+
+	uint32_t	bs_gen;		/* generation count		*/
+	uint32_t	bs_uid;		/* user id			*/
+	uint32_t	bs_gid;		/* group id			*/
+	uint32_t	bs_projectid;	/* project id			*/
+
+	uint32_t	bs_atime_nsec;	/* access time, nanoseconds	*/
+	uint32_t	bs_mtime_nsec;	/* modify time, nanoseconds	*/
+	uint32_t	bs_ctime_nsec;	/* inode change time, nanoseconds */
+	uint32_t	bs_btime_nsec;	/* creation time, nanoseconds	*/
+
+	uint32_t	bs_blksize;	/* block size			*/
+	uint32_t	bs_rdev;	/* device value			*/
+	uint32_t	bs_cowextsize_blks; /* cow extent size hint, blocks */
+	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
+
+	uint32_t	bs_nlink;	/* number of links		*/
+	uint32_t	bs_extents;	/* number of extents		*/
+	uint32_t	bs_aextents;	/* attribute number of extents	*/
+	uint16_t	bs_version;	/* structure version		*/
+	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
+
+	uint16_t	bs_sick;	/* sick inode metadata		*/
+	uint16_t	bs_checked;	/* checked inode metadata	*/
+	uint16_t	bs_mode;	/* type and mode		*/
+	uint16_t	bs_pad2;	/* zeroed			*/
+
+	uint64_t	bs_pad[7];	/* zeroed			*/
+};
+
+#define XFS_BULKSTAT_VERSION_V1	(1)
+#define XFS_BULKSTAT_VERSION_V5	(5)
+
 /* bs_sick flags */
 #define XFS_BS_SICK_INODE	(1 << 0)  /* inode core */
 #define XFS_BS_SICK_BMBTD	(1 << 1)  /* data fork */
@@ -374,7 +420,7 @@ struct xfs_bstat {
  * to retain compatibility with "old" filesystems).
  */
 static inline uint32_t
-bstat_get_projid(struct xfs_bstat *bs)
+bstat_get_projid(const struct xfs_bstat *bs)
 {
 	return (uint32_t)bs->bs_projid_hi << 16 | bs->bs_projid_lo;
 }
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 49ddfeac19f2..272005ac8c88 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -185,6 +185,6 @@ xfs_inode_is_healthy(struct xfs_inode *ip)
 
 void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
-void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bstat *bs);
+void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 4c4929f9e7bf..e8ba6034b0db 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -373,7 +373,7 @@ static const struct ioctl_sick_map ino_map[] = {
 void
 xfs_bulkstat_health(
 	struct xfs_inode		*ip,
-	struct xfs_bstat		*bs)
+	struct xfs_bulkstat		*bs)
 {
 	const struct ioctl_sick_map	*m;
 	unsigned int			sick;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f02a9bd757ad..0f70005cbe61 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -724,10 +724,13 @@ xfs_ioc_space(
 /* Return 0 on success or positive error */
 int
 xfs_fsbulkstat_one_fmt(
-	struct xfs_ibulk	*breq,
-	const struct xfs_bstat	*bstat)
+	struct xfs_ibulk		*breq,
+	const struct xfs_bulkstat	*bstat)
 {
-	if (copy_to_user(breq->ubuffer, bstat, sizeof(*bstat)))
+	struct xfs_bstat		bs1;
+
+	xfs_bulkstat_to_bstat(breq->mp, &bs1, bstat);
+	if (copy_to_user(breq->ubuffer, &bs1, sizeof(bs1)))
 		return -EFAULT;
 	return xfs_ibulk_advance(breq, sizeof(struct xfs_bstat));
 }
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index cb34bc821201..514d3028a134 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -82,7 +82,7 @@ struct xfs_bstat;
 struct xfs_inogrp;
 
 int xfs_fsbulkstat_one_fmt(struct xfs_ibulk *breq,
-			   const struct xfs_bstat *bstat);
+			   const struct xfs_bulkstat *bstat);
 int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inogrp *igrp);
 
 #endif
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index af753f2708e8..9806d27892df 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -170,10 +170,14 @@ xfs_bstime_store_compat(
 /* Return 0 on success or positive error (to xfs_bulkstat()) */
 STATIC int
 xfs_fsbulkstat_one_fmt_compat(
-	struct xfs_ibulk	*breq,
-	const struct xfs_bstat	*buffer)
+	struct xfs_ibulk		*breq,
+	const struct xfs_bulkstat	*bstat)
 {
-	struct compat_xfs_bstat	__user *p32 = breq->ubuffer;
+	struct compat_xfs_bstat	__user	*p32 = breq->ubuffer;
+	struct xfs_bstat		bs1;
+	struct xfs_bstat		*buffer = &bs1;
+
+	xfs_bulkstat_to_bstat(breq->mp, &bs1, bstat);
 
 	if (put_user(buffer->bs_ino,	  &p32->bs_ino)		||
 	    put_user(buffer->bs_mode,	  &p32->bs_mode)	||
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index bade54d6ac64..764b7f98fd5b 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -25,7 +25,7 @@
  * Bulk Stat
  * =========
  *
- * Use the inode walking functions to fill out struct xfs_bstat for every
+ * Use the inode walking functions to fill out struct xfs_bulkstat for every
  * allocated inode, then pass the stat information to some externally provided
  * iteration function.
  */
@@ -62,7 +62,7 @@ xfs_bulkstat_one_int(
 	struct xfs_icdinode	*dic;		/* dinode core info pointer */
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct inode		*inode;
-	struct xfs_bstat	*buf;		/* return buffer */
+	struct xfs_bulkstat	*buf;		/* return buffer */
 	int			error = 0;	/* error value */
 
 	if (xfs_internal_inum(mp, ino)) {
@@ -91,37 +91,35 @@ xfs_bulkstat_one_int(
 	/* xfs_iget returns the following without needing
 	 * further change.
 	 */
-	buf->bs_projid_lo = dic->di_projid_lo;
-	buf->bs_projid_hi = dic->di_projid_hi;
+	buf->bs_projectid = xfs_get_projid(ip);
 	buf->bs_ino = ino;
 	buf->bs_uid = dic->di_uid;
 	buf->bs_gid = dic->di_gid;
 	buf->bs_size = dic->di_size;
 
 	buf->bs_nlink = inode->i_nlink;
-	buf->bs_atime.tv_sec = inode->i_atime.tv_sec;
-	buf->bs_atime.tv_nsec = inode->i_atime.tv_nsec;
-	buf->bs_mtime.tv_sec = inode->i_mtime.tv_sec;
-	buf->bs_mtime.tv_nsec = inode->i_mtime.tv_nsec;
-	buf->bs_ctime.tv_sec = inode->i_ctime.tv_sec;
-	buf->bs_ctime.tv_nsec = inode->i_ctime.tv_nsec;
+	buf->bs_atime = inode->i_atime.tv_sec;
+	buf->bs_atime_nsec = inode->i_atime.tv_nsec;
+	buf->bs_mtime = inode->i_mtime.tv_sec;
+	buf->bs_mtime_nsec = inode->i_mtime.tv_nsec;
+	buf->bs_ctime = inode->i_ctime.tv_sec;
+	buf->bs_ctime_nsec = inode->i_ctime.tv_nsec;
+	buf->bs_btime = dic->di_crtime.t_sec;
+	buf->bs_btime_nsec = dic->di_crtime.t_nsec;
 	buf->bs_gen = inode->i_generation;
 	buf->bs_mode = inode->i_mode;
 
 	buf->bs_xflags = xfs_ip2xflags(ip);
-	buf->bs_extsize = dic->di_extsize << mp->m_sb.sb_blocklog;
+	buf->bs_extsize_blks = dic->di_extsize;
 	buf->bs_extents = dic->di_nextents;
-	memset(buf->bs_pad, 0, sizeof(buf->bs_pad));
 	xfs_bulkstat_health(ip, buf);
-	buf->bs_dmevmask = dic->di_dmevmask;
-	buf->bs_dmstate = dic->di_dmstate;
 	buf->bs_aextents = dic->di_anextents;
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
+	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
 
 	if (dic->di_version == 3) {
 		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
-			buf->bs_cowextsize = dic->di_cowextsize <<
-					mp->m_sb.sb_blocklog;
+			buf->bs_cowextsize_blks = dic->di_cowextsize;
 	}
 
 	switch (dic->di_format) {
@@ -259,6 +257,43 @@ xfs_bulkstat(
 	return error;
 }
 
+/* Convert bulkstat (v5) to bstat (v1). */
+void
+xfs_bulkstat_to_bstat(
+	struct xfs_mount		*mp,
+	struct xfs_bstat		*bs1,
+	const struct xfs_bulkstat	*bstat)
+{
+	bs1->bs_ino = bstat->bs_ino;
+	bs1->bs_mode = bstat->bs_mode;
+	bs1->bs_nlink = bstat->bs_nlink;
+	bs1->bs_uid = bstat->bs_uid;
+	bs1->bs_gid = bstat->bs_gid;
+	bs1->bs_rdev = bstat->bs_rdev;
+	bs1->bs_blksize = bstat->bs_blksize;
+	bs1->bs_size = bstat->bs_size;
+	bs1->bs_atime.tv_sec = bstat->bs_atime;
+	bs1->bs_mtime.tv_sec = bstat->bs_mtime;
+	bs1->bs_ctime.tv_sec = bstat->bs_ctime;
+	bs1->bs_atime.tv_nsec = bstat->bs_atime_nsec;
+	bs1->bs_mtime.tv_nsec = bstat->bs_mtime_nsec;
+	bs1->bs_ctime.tv_nsec = bstat->bs_ctime_nsec;
+	bs1->bs_blocks = bstat->bs_blocks;
+	bs1->bs_xflags = bstat->bs_xflags;
+	bs1->bs_extsize = bstat->bs_extsize_blks << mp->m_sb.sb_blocklog;
+	bs1->bs_extents = bstat->bs_extents;
+	bs1->bs_gen = bstat->bs_gen;
+	bs1->bs_projid_lo = bstat->bs_projectid & 0xFFFF;
+	bs1->bs_forkoff = bstat->bs_forkoff;
+	bs1->bs_projid_hi = bstat->bs_projectid >> 16;
+	bs1->bs_sick = bstat->bs_sick;
+	bs1->bs_checked = bstat->bs_checked;
+	bs1->bs_cowextsize = bstat->bs_cowextsize_blks << mp->m_sb.sb_blocklog;
+	bs1->bs_dmevmask = 0;
+	bs1->bs_dmstate = 0;
+	bs1->bs_aextents = bstat->bs_aextents;
+}
+
 struct xfs_inumbers_chunk {
 	inumbers_fmt_pf		formatter;
 	struct xfs_ibulk	*breq;
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index b4c89454e27a..806069c9838c 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -41,10 +41,12 @@ xfs_ibulk_advance(
  */
 
 typedef int (*bulkstat_one_fmt_pf)(struct xfs_ibulk *breq,
-		const struct xfs_bstat *bstat);
+		const struct xfs_bulkstat *bstat);
 
 int xfs_bulkstat_one(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
 int xfs_bulkstat(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
+void xfs_bulkstat_to_bstat(struct xfs_mount *mp, struct xfs_bstat *bs1,
+		const struct xfs_bulkstat *bstat);
 
 typedef int (*inumbers_fmt_pf)(struct xfs_ibulk *breq,
 		const struct xfs_inogrp *igrp);
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index c8ba98fae30a..0b4cdda68524 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -146,6 +146,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_dir3_data_hdr, hdr.magic,	0);
 	XFS_CHECK_OFFSET(struct xfs_dir3_free, hdr.hdr.magic,	0);
 	XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
+
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
 }
 
 #endif /* __XFS_ONDISK_H */

