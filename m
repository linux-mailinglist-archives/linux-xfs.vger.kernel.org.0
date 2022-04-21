Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3845509451
	for <lists+linux-xfs@lfdr.de>; Thu, 21 Apr 2022 02:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiDUAr3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 20 Apr 2022 20:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347647AbiDUAr3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 20:47:29 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4537729813
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 17:44:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 51D705345CF;
        Thu, 21 Apr 2022 10:44:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nhKw1-002aU5-SZ; Thu, 21 Apr 2022 10:44:37 +1000
Date:   Thu, 21 Apr 2022 10:44:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/17 v2] xfs: convert inode lock flags to unsigned.
Message-ID: <20220421004437.GQ1544202@dread.disaster.area>
References: <20220411003147.2104423-1-david@fromorbit.com>
 <20220411003147.2104423-14-david@fromorbit.com>
 <87v8vezrrt.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20220412084305.GE1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412084305.GE1544202@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6260a8f8
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8
        a=TnHyrI8U7X1SERcfbcIA:9 a=CjuIK1q_8ugA:10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
fields to be unsigned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
V2:
- convert the missed ILOCK bit values and masks to unsigned.

 fs/xfs/xfs_file.c  | 12 ++++++------
 fs/xfs/xfs_inode.c | 21 ++++++++++++---------
 fs/xfs/xfs_inode.h | 24 ++++++++++++------------
 3 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5bddb1e9e0b3..f3e878408747 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -310,7 +310,7 @@ STATIC ssize_t
 xfs_file_write_checks(
 	struct kiocb		*iocb,
 	struct iov_iter		*from,
-	int			*iolock)
+	unsigned int		*iolock)
 {
 	struct file		*file = iocb->ki_filp;
 	struct inode		*inode = file->f_mapping->host;
@@ -513,7 +513,7 @@ xfs_file_dio_write_aligned(
 	struct kiocb		*iocb,
 	struct iov_iter		*from)
 {
-	int			iolock = XFS_IOLOCK_SHARED;
+	unsigned int		iolock = XFS_IOLOCK_SHARED;
 	ssize_t			ret;
 
 	ret = xfs_ilock_iocb(iocb, iolock);
@@ -566,7 +566,7 @@ xfs_file_dio_write_unaligned(
 {
 	size_t			isize = i_size_read(VFS_I(ip));
 	size_t			count = iov_iter_count(from);
-	int			iolock = XFS_IOLOCK_SHARED;
+	unsigned int		iolock = XFS_IOLOCK_SHARED;
 	unsigned int		flags = IOMAP_DIO_OVERWRITE_ONLY;
 	ssize_t			ret;
 
@@ -655,7 +655,7 @@ xfs_file_dax_write(
 {
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
-	int			iolock = XFS_IOLOCK_EXCL;
+	unsigned int		iolock = XFS_IOLOCK_EXCL;
 	ssize_t			ret, error = 0;
 	loff_t			pos;
 
@@ -700,7 +700,7 @@ xfs_file_buffered_write(
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
 	bool			cleared_space = false;
-	int			iolock;
+	unsigned int		iolock;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		return -EOPNOTSUPP;
@@ -1181,7 +1181,7 @@ xfs_dir_open(
 	struct file	*file)
 {
 	struct xfs_inode *ip = XFS_I(inode);
-	int		mode;
+	unsigned int	mode;
 	int		error;
 
 	error = xfs_file_open(inode, file);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9de6205fe134..5ea460f62201 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -416,10 +416,12 @@ xfs_lockdep_subclass_ok(
  * parent locking. Care must be taken to ensure we don't overrun the subclass
  * storage fields in the class mask we build.
  */
-static inline int
-xfs_lock_inumorder(int lock_mode, int subclass)
+static inline uint
+xfs_lock_inumorder(
+	uint	lock_mode,
+	uint	subclass)
 {
-	int	class = 0;
+	uint	class = 0;
 
 	ASSERT(!(lock_mode & (XFS_ILOCK_PARENT | XFS_ILOCK_RTBITMAP |
 			      XFS_ILOCK_RTSUM)));
@@ -464,7 +466,10 @@ xfs_lock_inodes(
 	int			inodes,
 	uint			lock_mode)
 {
-	int			attempts = 0, i, j, try_lock;
+	int			attempts = 0;
+	uint			i;
+	int			j;
+	bool			try_lock;
 	struct xfs_log_item	*lp;
 
 	/*
@@ -489,9 +494,9 @@ xfs_lock_inodes(
 	} else if (lock_mode & XFS_MMAPLOCK_EXCL)
 		ASSERT(!(lock_mode & XFS_ILOCK_EXCL));
 
-	try_lock = 0;
-	i = 0;
 again:
+	try_lock = false;
+	i = 0;
 	for (; i < inodes; i++) {
 		ASSERT(ips[i]);
 
@@ -506,7 +511,7 @@ xfs_lock_inodes(
 			for (j = (i - 1); j >= 0 && !try_lock; j--) {
 				lp = &ips[j]->i_itemp->ili_item;
 				if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags))
-					try_lock++;
+					try_lock = true;
 			}
 		}
 
@@ -546,8 +551,6 @@ xfs_lock_inodes(
 		if ((attempts % 5) == 0) {
 			delay(1); /* Don't just spin the CPU */
 		}
-		i = 0;
-		try_lock = 0;
 		goto again;
 	}
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 740ab13d1aa2..b67ab9f10cf9 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -278,12 +278,12 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
  * Bit ranges:	1<<1  - 1<<16-1 -- iolock/ilock modes (bitfield)
  *		1<<16 - 1<<32-1 -- lockdep annotation (integers)
  */
-#define	XFS_IOLOCK_EXCL		(1<<0)
-#define	XFS_IOLOCK_SHARED	(1<<1)
-#define	XFS_ILOCK_EXCL		(1<<2)
-#define	XFS_ILOCK_SHARED	(1<<3)
-#define	XFS_MMAPLOCK_EXCL	(1<<4)
-#define	XFS_MMAPLOCK_SHARED	(1<<5)
+#define	XFS_IOLOCK_EXCL		(1u << 0)
+#define	XFS_IOLOCK_SHARED	(1u << 1)
+#define	XFS_ILOCK_EXCL		(1u << 2)
+#define	XFS_ILOCK_SHARED	(1u << 3)
+#define	XFS_MMAPLOCK_EXCL	(1u << 4)
+#define	XFS_MMAPLOCK_SHARED	(1u << 5)
 
 #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
 				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
@@ -350,19 +350,19 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
  */
 #define XFS_IOLOCK_SHIFT		16
 #define XFS_IOLOCK_MAX_SUBCLASS		3
-#define XFS_IOLOCK_DEP_MASK		0x000f0000
+#define XFS_IOLOCK_DEP_MASK		0x000f0000u
 
 #define XFS_MMAPLOCK_SHIFT		20
 #define XFS_MMAPLOCK_NUMORDER		0
 #define XFS_MMAPLOCK_MAX_SUBCLASS	3
-#define XFS_MMAPLOCK_DEP_MASK		0x00f00000
+#define XFS_MMAPLOCK_DEP_MASK		0x00f00000u
 
 #define XFS_ILOCK_SHIFT			24
-#define XFS_ILOCK_PARENT_VAL		5
+#define XFS_ILOCK_PARENT_VAL		5u
 #define XFS_ILOCK_MAX_SUBCLASS		(XFS_ILOCK_PARENT_VAL - 1)
-#define XFS_ILOCK_RTBITMAP_VAL		6
-#define XFS_ILOCK_RTSUM_VAL		7
-#define XFS_ILOCK_DEP_MASK		0xff000000
+#define XFS_ILOCK_RTBITMAP_VAL		6u
+#define XFS_ILOCK_RTSUM_VAL		7u
+#define XFS_ILOCK_DEP_MASK		0xff000000u
 #define	XFS_ILOCK_PARENT		(XFS_ILOCK_PARENT_VAL << XFS_ILOCK_SHIFT)
 #define	XFS_ILOCK_RTBITMAP		(XFS_ILOCK_RTBITMAP_VAL << XFS_ILOCK_SHIFT)
 #define	XFS_ILOCK_RTSUM			(XFS_ILOCK_RTSUM_VAL << XFS_ILOCK_SHIFT)
