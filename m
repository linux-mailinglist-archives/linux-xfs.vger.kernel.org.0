Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 170924EFB6
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 21:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfFUT5h (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 15:57:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43600 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfFUT5h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 15:57:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LJsbQ4094327;
        Fri, 21 Jun 2019 19:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=T6sH6V912fGnTsT5up0BwTbGPhKQqhBi1VHF54DLeOg=;
 b=e6GNKRjPOGquMQGhdLVAKdKutRsjtuEbMVwx3E9pbRpEEWtIEoi7VQsbzyyCXyqcqxMt
 7SKTh5jxB70tOBIEiAi2v5JiZjjZl22djQy3y7sUjxNyt+dMDFWD3xu/cLV/ueVqACZM
 4/9ZULzqTyhZXU5htEf7ib9MPUUg1noYrYkYw1DRz0Ua0aPg1uRQd/92n/QhQizqsiAh
 DNiXrzujtnAo0MOflVTQ8ctOq5zllqcRCXF4crygXSnSYlbxuvB5349z+OBq8NiA1ARV
 zEx+KP+C+2YT/62HqkTPmxGsWZrnPlAVKRGdU8yoCsvm8O+zG+kSVpGN9NCw14qmNPay 5w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t7809r8gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:57:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LJthgv178328;
        Fri, 21 Jun 2019 19:57:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t77ypce5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:57:34 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5LJvYN0014870;
        Fri, 21 Jun 2019 19:57:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 12:57:34 -0700
Subject: [PATCH 5/6] libxfs: make xfs_buf_delwri_submit actually do something
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 21 Jun 2019 12:57:33 -0700
Message-ID: <156114705295.1643538.4760286307932278728.stgit@magnolia>
In-Reply-To: <156114701371.1643538.316410894576032261.stgit@magnolia>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_buf_delwri_queue doesn't report errors, which means that if the
buffer write fails we have no way of knowing that something bad
happened.  In the kernel we queue and then submit buffers, and the
submit call communicates errors to callers.  Do the same here since
we're going to start using the AG header initialization functions, which
use delwri_{queue,submit} heavily.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h   |    6 +++++-
 libxfs/libxfs_priv.h |    1 -
 libxfs/rdwr.c        |   25 +++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index c47a435d..d033faad 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -70,6 +70,7 @@ typedef struct xfs_buf {
 	struct xfs_buf_map	*b_maps;
 	struct xfs_buf_map	__b_map;
 	int			b_nmaps;
+	struct list_head	b_list;
 #ifdef XFS_BUF_TRACING
 	struct list_head	b_lock_list;
 	const char		*b_func;
@@ -243,11 +244,14 @@ xfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags)
 	return bp;
 }
 
+/* Push a single buffer on a delwri queue. */
 static inline void
 xfs_buf_delwri_queue(struct xfs_buf *bp, struct list_head *buffer_list)
 {
 	bp->b_node.cn_count++;
-	libxfs_writebuf(bp, 0);
+	list_add_tail(&bp->b_list, buffer_list);
 }
 
+int xfs_buf_delwri_submit(struct list_head *buffer_list);
+
 #endif	/* __LIBXFS_IO_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index fd420f4f..0233393d 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -381,7 +381,6 @@ roundup_64(uint64_t x, uint32_t y)
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
-#define xfs_buf_delwri_submit(bl)	(0)
 #define xfs_buf_oneshot(bp)		((void) 0)
 
 #define XBRW_READ			LIBXFS_BREAD
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 9c6c93a7..dd582a4e 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1472,3 +1472,28 @@ libxfs_irele(
 	libxfs_idestroy(ip);
 	kmem_zone_free(xfs_inode_zone, ip);
 }
+
+/*
+ * Write out a buffer list synchronously.
+ *
+ * This will take the @buffer_list, write all buffers out and wait for I/O
+ * completion on all of the buffers. @buffer_list is consumed by the function,
+ * so callers must have some other way of tracking buffers if they require such
+ * functionality.
+ */
+int
+xfs_buf_delwri_submit(
+	struct list_head	*buffer_list)
+{
+	struct xfs_buf		*bp, *n;
+	int			error = 0, error2;
+
+	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
+		list_del_init(&bp->b_list);
+		error2 = libxfs_writebuf(bp, 0);
+		if (!error)
+			error = error2;
+	}
+
+	return error;
+}

