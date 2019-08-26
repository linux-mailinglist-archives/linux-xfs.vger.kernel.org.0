Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE339D817
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Aug 2019 23:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfHZVWI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Aug 2019 17:22:08 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43266 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfHZVWH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:22:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDmbt188915;
        Mon, 26 Aug 2019 21:22:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=b3RIoz22s2HF7JLkRZMr4Z6ZpgKHq7DQKsWqVBwQTjQ=;
 b=Rr6bR0CDyxrhWwmE8YJJMdgEyYev3KLUbvXPvXjpTW4r0+4XVAuoiVgzo9YvzMHTO5WL
 i6EgKXMJtrrWIBHUJw2zOAzWbn9NV8gVEtLc3Y45zcbq7YQCBe21c6/MddMUZE7jqRVN
 s8R6jkSAzT4HZYUUktvdhCMeGh99HIMzh3ChPlYrcBy6mz5dZl7H50IjpAY9xq9cShsF
 TgDnl05IT/edJ3rkNnlSSSlsKEpxe4d2UcoJ+l13rBkgz2PRPj+wfqM4vS4/kkN6Mx30
 aHToojaEkQBdFZaJ+x5oazt9qNBTijsbY9aWLvFiwTMi+r/a5YMpnA8wxuteih1uvH8s KA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ujwvqc4k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:22:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIRXr025006;
        Mon, 26 Aug 2019 21:22:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2umj1tjxeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:22:02 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLM0fr002118;
        Mon, 26 Aug 2019 21:22:00 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:22:00 -0700
Subject: [PATCH 3/4] libxfs: make xfs_buf_delwri_submit actually do something
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Mon, 26 Aug 2019 14:21:59 -0700
Message-ID: <156685451938.2840210.9803368907815793327.stgit@magnolia>
In-Reply-To: <156685449440.2840210.11908449959921635294.stgit@magnolia>
References: <156685449440.2840210.11908449959921635294.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_io.h   |    6 +++++-
 libxfs/libxfs_priv.h |    1 -
 libxfs/rdwr.c        |   25 +++++++++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 09ed043b..579df52b 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -71,6 +71,7 @@ typedef struct xfs_buf {
 	struct xfs_buf_map	*b_maps;
 	struct xfs_buf_map	__b_map;
 	int			b_nmaps;
+	struct list_head	b_list;
 #ifdef XFS_BUF_TRACING
 	struct list_head	b_lock_list;
 	const char		*b_func;
@@ -245,11 +246,14 @@ xfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags)
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
index ed2d665a..57b58642 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -382,7 +382,6 @@ roundup_64(uint64_t x, uint32_t y)
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
-#define xfs_buf_delwri_submit(bl)	(0)
 #define xfs_buf_oneshot(bp)		((void) 0)
 
 #define XBRW_READ			LIBXFS_BREAD
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 3282f6de..0d3e6089 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1473,3 +1473,28 @@ libxfs_irele(
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

