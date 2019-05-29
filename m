Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4834A2E833
	for <lists+linux-xfs@lfdr.de>; Thu, 30 May 2019 00:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfE2W1l (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 May 2019 18:27:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43196 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfE2W1l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:27:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TM54w6024216
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=6wdQPQ3p+/KuxiPkcnhpwy1vg4UFUMyiyILMzrozpvI=;
 b=i6nJzTIOBZhDHFHP6cbl1uej/o2xt/SU4wa5rTFGJS5YGVwDFwBFRDHO8kpMbwl6Blsf
 9IzDLpta/8gOqiUtzPYZ7MMMUg4ZIvWGP01mH+7+7yuyeNWEx65eIxJmZiZdUI7qMPIy
 WuzJS4s7D519ewJWeFi7l7qUKiJF3p1ObFUsa2LTOw8Q/bRvgXJi3HGnXeLNpeOGXq6F
 rdOzTS0MxnGmCq3L07J4c6mqUqXO8ti8Uq3F/3GCB77TwJ58IC37Nf/tN8JozzHK+hQV
 oWf0/FHv0DBVTerONkULL6KzFXu0+FccJPYMgeXhXWCY5lRp4YyKStwg0U+BlRzwkP+u /A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2spw4tmtfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMRNXZ099494
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ss1fnqr17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:39 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4TMRcke023261
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:27:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 15:27:38 -0700
Subject: [PATCH 1/9] xfs: remove various bulk request typedef usage
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 May 2019 15:27:37 -0700
Message-ID: <155916885724.758159.12960870951306142249.stgit@magnolia>
In-Reply-To: <155916885106.758159.3471602893858635007.stgit@magnolia>
References: <155916885106.758159.3471602893858635007.stgit@magnolia>
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

Remove xfs_bstat_t, xfs_fsop_bulkreq_t, xfs_inogrp_t, and similarly
named compat typedefs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h |   16 ++++++++--------
 fs/xfs/xfs_ioctl.c     |    2 +-
 fs/xfs/xfs_ioctl32.c   |   11 +++++++----
 fs/xfs/xfs_ioctl32.h   |   14 +++++++-------
 4 files changed, 23 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index e7382c780ed7..ef0dce229fa4 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -97,7 +97,7 @@ struct getbmapx {
  * For use by backup and restore programs to set the XFS on-disk inode
  * fields di_dmevmask and di_dmstate.  These must be set to exactly and
  * only values previously obtained via xfs_bulkstat!  (Specifically the
- * xfs_bstat_t fields bs_dmevmask and bs_dmstate.)
+ * struct xfs_bstat fields bs_dmevmask and bs_dmstate.)
  */
 #ifndef HAVE_FSDMIDATA
 struct fsdmidata {
@@ -328,7 +328,7 @@ typedef struct xfs_bstime {
 	__s32		tv_nsec;	/* and nanoseconds	*/
 } xfs_bstime_t;
 
-typedef struct xfs_bstat {
+struct xfs_bstat {
 	__u64		bs_ino;		/* inode number			*/
 	__u16		bs_mode;	/* type and mode		*/
 	__u16		bs_nlink;	/* number of links		*/
@@ -356,7 +356,7 @@ typedef struct xfs_bstat {
 	__u32		bs_dmevmask;	/* DMIG event mask		*/
 	__u16		bs_dmstate;	/* DMIG state info		*/
 	__u16		bs_aextents;	/* attribute number of extents	*/
-} xfs_bstat_t;
+};
 
 /* bs_sick flags */
 #define XFS_BS_SICK_INODE	(1 << 0)  /* inode core */
@@ -382,22 +382,22 @@ bstat_get_projid(struct xfs_bstat *bs)
 /*
  * The user-level BulkStat Request interface structure.
  */
-typedef struct xfs_fsop_bulkreq {
+struct xfs_fsop_bulkreq {
 	__u64		__user *lastip;	/* last inode # pointer		*/
 	__s32		icount;		/* count of entries in buffer	*/
 	void		__user *ubuffer;/* user buffer for inode desc.	*/
 	__s32		__user *ocount;	/* output count pointer		*/
-} xfs_fsop_bulkreq_t;
+};
 
 
 /*
  * Structures returned from xfs_inumbers routine (XFS_IOC_FSINUMBERS).
  */
-typedef struct xfs_inogrp {
+struct xfs_inogrp {
 	__u64		xi_startino;	/* starting inode number	*/
 	__s32		xi_alloccount;	/* # bits set in allocmask	*/
 	__u64		xi_allocmask;	/* mask of allocated inodes	*/
-} xfs_inogrp_t;
+};
 
 
 /*
@@ -529,7 +529,7 @@ typedef struct xfs_swapext
 	xfs_off_t	sx_offset;	/* offset into file */
 	xfs_off_t	sx_length;	/* leng from offset */
 	char		sx_pad[16];	/* pad space, unused */
-	xfs_bstat_t	sx_stat;	/* stat of target b4 copy */
+	struct xfs_bstat sx_stat;	/* stat of target b4 copy */
 } xfs_swapext_t;
 
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4fa9a2c8b029..456a0e132d6d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -764,7 +764,7 @@ xfs_ioc_bulkstat(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if (copy_from_user(&bulkreq, arg, sizeof(xfs_fsop_bulkreq_t)))
+	if (copy_from_user(&bulkreq, arg, sizeof(struct xfs_fsop_bulkreq)))
 		return -EFAULT;
 
 	if (copy_from_user(&lastino, bulkreq.lastip, sizeof(__s64)))
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index dd53a9692e68..8dcb7046ed15 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -116,11 +116,14 @@ xfs_ioctl32_bstime_copyin(
 	return 0;
 }
 
-/* xfs_bstat_t has differing alignment on intel, & bstime_t sizes everywhere */
+/*
+ * struct xfs_bstat has differing alignment on intel, & bstime_t sizes
+ * everywhere
+ */
 STATIC int
 xfs_ioctl32_bstat_copyin(
-	xfs_bstat_t		*bstat,
-	compat_xfs_bstat_t	__user *bstat32)
+	struct xfs_bstat		*bstat,
+	struct compat_xfs_bstat	__user	*bstat32)
 {
 	if (get_user(bstat->bs_ino,	&bstat32->bs_ino)	||
 	    get_user(bstat->bs_mode,	&bstat32->bs_mode)	||
@@ -204,7 +207,7 @@ STATIC int
 xfs_compat_ioc_bulkstat(
 	xfs_mount_t		  *mp,
 	unsigned int		  cmd,
-	compat_xfs_fsop_bulkreq_t __user *p32)
+	struct compat_xfs_fsop_bulkreq __user *p32)
 {
 	u32			addr;
 	struct xfs_fsop_bulkreq	bulkreq;
diff --git a/fs/xfs/xfs_ioctl32.h b/fs/xfs/xfs_ioctl32.h
index d28fa824284a..7985344d3aa6 100644
--- a/fs/xfs/xfs_ioctl32.h
+++ b/fs/xfs/xfs_ioctl32.h
@@ -36,7 +36,7 @@ typedef struct compat_xfs_bstime {
 	__s32		tv_nsec;	/* and nanoseconds	*/
 } compat_xfs_bstime_t;
 
-typedef struct compat_xfs_bstat {
+struct compat_xfs_bstat {
 	__u64		bs_ino;		/* inode number			*/
 	__u16		bs_mode;	/* type and mode		*/
 	__u16		bs_nlink;	/* number of links		*/
@@ -61,14 +61,14 @@ typedef struct compat_xfs_bstat {
 	__u32		bs_dmevmask;	/* DMIG event mask		*/
 	__u16		bs_dmstate;	/* DMIG state info		*/
 	__u16		bs_aextents;	/* attribute number of extents	*/
-} __compat_packed compat_xfs_bstat_t;
+} __compat_packed;
 
-typedef struct compat_xfs_fsop_bulkreq {
+struct compat_xfs_fsop_bulkreq {
 	compat_uptr_t	lastip;		/* last inode # pointer		*/
 	__s32		icount;		/* count of entries in buffer	*/
 	compat_uptr_t	ubuffer;	/* user buffer for inode desc.	*/
 	compat_uptr_t	ocount;		/* output count pointer		*/
-} compat_xfs_fsop_bulkreq_t;
+};
 
 #define XFS_IOC_FSBULKSTAT_32 \
 	_IOWR('X', 101, struct compat_xfs_fsop_bulkreq)
@@ -106,7 +106,7 @@ typedef struct compat_xfs_swapext {
 	xfs_off_t		sx_offset;	/* offset into file */
 	xfs_off_t		sx_length;	/* leng from offset */
 	char			sx_pad[16];	/* pad space, unused */
-	compat_xfs_bstat_t	sx_stat;	/* stat of target b4 copy */
+	struct compat_xfs_bstat	sx_stat;	/* stat of target b4 copy */
 } __compat_packed compat_xfs_swapext_t;
 
 #define XFS_IOC_SWAPEXT_32	_IOWR('X', 109, struct compat_xfs_swapext)
@@ -201,11 +201,11 @@ typedef struct compat_xfs_fsop_geom_v1 {
 #define XFS_IOC_FSGEOMETRY_V1_32  \
 	_IOR('X', 100, struct compat_xfs_fsop_geom_v1)
 
-typedef struct compat_xfs_inogrp {
+struct compat_xfs_inogrp {
 	__u64		xi_startino;	/* starting inode number	*/
 	__s32		xi_alloccount;	/* # bits set in allocmask	*/
 	__u64		xi_allocmask;	/* mask of allocated inodes	*/
-} __attribute__((packed)) compat_xfs_inogrp_t;
+} __attribute__((packed));
 
 /* These growfs input structures have padding on the end, so must translate */
 typedef struct compat_xfs_growfs_data {

