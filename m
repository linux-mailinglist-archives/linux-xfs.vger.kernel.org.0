Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 476411403EB
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Jan 2020 07:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgAQGY2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 Jan 2020 01:24:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34362 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgAQGY2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jan 2020 01:24:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H693Hl187220;
        Fri, 17 Jan 2020 06:24:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=E8Gg10+HPx4jxBI66rU1fjng72LfjWG3FqXh7jjx/Ig=;
 b=CqtbzAYYNEUSrr/Ukdrhmb63sZ8CG38dLxM7KUJw/gIUhTJIajt/fEPR1IrdTw1FJcrz
 zf7HujWo/t9mKFCgd8PkWuZF3GsH0zqNcfVwEuAuo0Yr53CT40q5jxPgkg60Jx26o9nR
 L9iHC8i0JyU+8l89Srn7oNlULW5mns8vJrBAp9kGwdHHHmcp1NMhWGCd2SuAxoIkvzgs
 /YOTvoo/b2Z4J1soK1tWhibrvBN/5pzUNNhKYU0XKE0T1apztXopk6EUuRTPBO1IdDlx
 pYITpGxOkxQRweKY3H8d8vMKtqyrIXyS56cvYpaBdsd3g0YD2Fwa6Q3KmHmuqBxoAFvz aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xf74spt6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:24:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00H69HA6076176;
        Fri, 17 Jan 2020 06:24:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xk230b1c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 06:24:19 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00H6OIko002689;
        Fri, 17 Jan 2020 06:24:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 16 Jan 2020 22:24:18 -0800
Subject: [PATCH 06/11] xfs: make xfs_buf_get_map return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Date:   Thu, 16 Jan 2020 22:24:16 -0800
Message-ID: <157924225602.3029431.5608767851313628302.stgit@magnolia>
In-Reply-To: <157924221149.3029431.1461924548648810370.stgit@magnolia>
References: <157924221149.3029431.1461924548648810370.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001170048
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9502 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001170048
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert xfs_buf_get_map() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c       |   46 +++++++++++++++++-----------------------------
 fs/xfs/xfs_buf.h       |   14 +++-----------
 fs/xfs/xfs_trans_buf.c |   14 +++++++++-----
 3 files changed, 29 insertions(+), 45 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f95c999b3343..34b0783587f4 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -685,53 +685,39 @@ xfs_buf_incore(
  * cache hits, as metadata intensive workloads will see 3 orders of magnitude
  * more hits than misses.
  */
-struct xfs_buf *
+int
 xfs_buf_get_map(
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
-	xfs_buf_flags_t		flags)
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp)
 {
 	struct xfs_buf		*bp;
 	struct xfs_buf		*new_bp;
 	int			error = 0;
 
+	*bpp = NULL;
 	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
-
-	switch (error) {
-	case 0:
-		/* cache hit */
+	if (!error)
 		goto found;
-	case -EAGAIN:
-		/* cache hit, trylock failure, caller handles failure */
-		ASSERT(flags & XBF_TRYLOCK);
-		return NULL;
-	case -ENOENT:
-		/* cache miss, go for insert */
-		break;
-	case -EFSCORRUPTED:
-	default:
-		/*
-		 * None of the higher layers understand failure types
-		 * yet, so return NULL to signal a fatal lookup error.
-		 */
-		return NULL;
-	}
+	if (error != -ENOENT)
+		return error;
 
 	error = _xfs_buf_alloc(target, map, nmaps, flags, &new_bp);
 	if (unlikely(error))
-		return NULL;
+		return error;
 
 	error = xfs_buf_allocate_memory(new_bp, flags);
 	if (error) {
 		xfs_buf_free(new_bp);
-		return NULL;
+		return error;
 	}
 
 	error = xfs_buf_find(target, map, nmaps, flags, new_bp, &bp);
 	if (error) {
 		xfs_buf_free(new_bp);
-		return NULL;
+		return error;
 	}
 
 	if (bp != new_bp)
@@ -744,7 +730,7 @@ xfs_buf_get_map(
 			xfs_warn(target->bt_mount,
 				"%s: failed to map pagesn", __func__);
 			xfs_buf_relse(bp);
-			return NULL;
+			return error;
 		}
 	}
 
@@ -757,7 +743,8 @@ xfs_buf_get_map(
 
 	XFS_STATS_INC(target->bt_mount, xb_get);
 	trace_xfs_buf_get(bp, flags, _RET_IP_);
-	return bp;
+	*bpp = bp;
+	return 0;
 }
 
 STATIC int
@@ -819,13 +806,14 @@ xfs_buf_read_map(
 	const struct xfs_buf_ops *ops)
 {
 	struct xfs_buf		*bp;
+	int			error;
 
 	flags |= XBF_READ;
 	*bpp = NULL;
 
-	bp = xfs_buf_get_map(target, map, nmaps, flags);
-	if (!bp)
-		return -ENOMEM;
+	error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
+	if (error)
+		return error;
 
 	trace_xfs_buf_read(bp, flags, _RET_IP_);
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 36d43bead158..8e7c1238ddf0 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -192,9 +192,8 @@ struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
 			   xfs_daddr_t blkno, size_t numblks,
 			   xfs_buf_flags_t flags);
 
-struct xfs_buf *xfs_buf_get_map(struct xfs_buftarg *target,
-			       struct xfs_buf_map *map, int nmaps,
-			       xfs_buf_flags_t flags);
+int xfs_buf_get_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
+		int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp);
 int xfs_buf_read_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
 		int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp,
 		const struct xfs_buf_ops *ops);
@@ -208,16 +207,9 @@ xfs_buf_get(
 	size_t			numblks,
 	struct xfs_buf		**bpp)
 {
-	struct xfs_buf		*bp;
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	*bpp = NULL;
-	bp = xfs_buf_get_map(target, &map, 1, 0);
-	if (!bp)
-		return -ENOMEM;
-
-	*bpp = bp;
-	return 0;
+	return xfs_buf_get_map(target, &map, 1, 0, bpp);
 }
 
 int xfs_buf_read(struct xfs_buftarg *target, xfs_daddr_t blkno, size_t numblks,
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index a2af6dec310d..bf61e61b38c7 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -122,9 +122,14 @@ xfs_trans_get_buf_map(
 {
 	xfs_buf_t		*bp;
 	struct xfs_buf_log_item	*bip;
+	int			error;
 
-	if (!tp)
-		return xfs_buf_get_map(target, map, nmaps, flags);
+	if (!tp) {
+		error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
+		if (error)
+			return NULL;
+		return bp;
+	}
 
 	/*
 	 * If we find the buffer in the cache with this transaction
@@ -149,10 +154,9 @@ xfs_trans_get_buf_map(
 		return bp;
 	}
 
-	bp = xfs_buf_get_map(target, map, nmaps, flags);
-	if (bp == NULL) {
+	error = xfs_buf_get_map(target, map, nmaps, flags, &bp);
+	if (error)
 		return NULL;
-	}
 
 	ASSERT(!bp->b_error);
 

