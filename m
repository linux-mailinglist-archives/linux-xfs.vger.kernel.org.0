Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A83FC4EFB4
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 21:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfFUT5X (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 15:57:23 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57654 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfFUT5X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 15:57:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LJsHRv100765;
        Fri, 21 Jun 2019 19:57:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=S/9Q7wfk82K25ujRHsHpIwm0KOmA1T8WDm1O2QVuMlA=;
 b=CcgqtI9dAoAJ6Pr0D0L9sER835L9SXT8dO99zTEvydMh6oQM3HGcpt8RX0ULEq4s/phO
 8Imq1VT/vQ4XLpwsSqWwnP2BYXX7+KCBD/7tJ1IamweVWPeAms042OfCLm89V+WoFYLq
 T+Mc8oBvSnCu2Rjt6rs946tz+yMx/iGx/ycQs6Hmu8oozJl4/qT1VfmhQsSiENgWa0Z4
 lSpe8FCsx3bIaQVoXs78MQJMpCK7zpz5bBBhSorUTF/TfKLzhX8sboN3iSIAJccBvzBK
 i2zPZTs17y+RVui/fFc4Weqi3pjcKeP2vwxMbx/m7sncIOMvSR0GOG0J02leoFBkda3c JQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t7809r6kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:57:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LJvFcc049513;
        Fri, 21 Jun 2019 19:57:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t77ypcesn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:57:20 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5LJvJmI013653;
        Fri, 21 Jun 2019 19:57:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 12:57:19 -0700
Subject: [PATCH 3/6] libxfs: fix uncached buffer refcounting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 21 Jun 2019 12:57:12 -0700
Message-ID: <156114703289.1643538.16263048212251920271.stgit@magnolia>
In-Reply-To: <156114701371.1643538.316410894576032261.stgit@magnolia>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Currently, uncached buffers in userspace are created with zero refcount
and are fed to cache_node_put when they're released.  This is totally
broken -- the refcount should be 1 (because the caller now holds a
reference) and we should never be dumping uncached buffers into the
cache.  Fix both of these problems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_io.h   |   18 ++++++++++++++++++
 libxfs/libxfs_priv.h |    2 --
 libxfs/rdwr.c        |    5 ++++-
 3 files changed, 22 insertions(+), 3 deletions(-)


diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 94261270..b6f8756a 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -225,4 +225,22 @@ xfs_buf_associate_memory(struct xfs_buf *bp, void *mem, size_t len)
 	return 0;
 }
 
+/*
+ * Allocate an uncached buffer that points nowhere.  The refcount will be 1,
+ * and the cache node hash list will be empty to indicate that it's uncached.
+ */
+static inline struct xfs_buf *
+xfs_buf_get_uncached(struct xfs_buftarg *targ, size_t bblen, int flags)
+{
+	struct xfs_buf	*bp;
+
+	bp = libxfs_getbufr(targ, XFS_BUF_DADDR_NULL, bblen);
+	if (!bp)
+		return NULL;
+
+	INIT_LIST_HEAD(&bp->b_node.cn_hash);
+	bp->b_node.cn_count = 1;
+	return bp;
+}
+
 #endif	/* __LIBXFS_IO_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 9004ff0c..eb92942a 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -378,8 +378,6 @@ roundup_64(uint64_t x, uint32_t y)
 	(len) = __bar; /* no set-but-unused warning */	\
 	NULL;						\
 })
-#define xfs_buf_get_uncached(t,n,f)     \
-	libxfs_getbufr((t), XFS_BUF_DADDR_NULL, (n));
 #define xfs_buf_relse(bp)		libxfs_putbuf(bp)
 #define xfs_buf_get(devp,blkno,len)	(libxfs_getbuf((devp), (blkno), (len)))
 #define xfs_bwrite(bp)			libxfs_writebuf((bp), 0)
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 998862af..9c6c93a7 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -866,7 +866,10 @@ libxfs_putbuf(xfs_buf_t *bp)
 		}
 	}
 
-	cache_node_put(libxfs_bcache, (struct cache_node *)bp);
+	if (!list_empty(&bp->b_node.cn_hash))
+		cache_node_put(libxfs_bcache, (struct cache_node *)bp);
+	else if (--bp->b_node.cn_count == 0)
+		libxfs_putbufr(bp);
 }
 
 void

