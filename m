Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E07371477F0
	for <lists+linux-xfs@lfdr.de>; Fri, 24 Jan 2020 06:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbgAXFU3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 24 Jan 2020 00:20:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39920 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbgAXFU3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 00:20:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5ILiU033714;
        Fri, 24 Jan 2020 05:20:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=16rUcHlnWMA/ftOAT05f+J5OfHY9F6iDK6UEhttI2+0=;
 b=mpQSyWsEzHj1cLzm8wPaCdWD+EQ2r2PbmYXUNCf2XEGJ6kkpdTb0c9wnGSdr25cni8zr
 d6PS7+drT3zl0glIcgr+ff7HmqgXEAnSRwvHfq9Jx/+vrz/GDLhlJdAJzEwbJbN+C+9n
 OQUi1U5lj6OYK0inHim22BRRrvl/ahWhHCJu8nDvO/1v5WO0C3tn+AU7lwXYmGszSvbu
 MaLUd3akWrPH4wVAcSdkVVZBmcsqQcOoJIIPygKSJxXmHpBpSB2jqbyaa9hDDAWScdTn
 hnwg4qGXSjKXok9PDPvPqeIrPto0FnfSShRXnnx3oFBV+Cy53tVMfSWWJGRQfjHr2/we aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnrps5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:20:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O5IInp031242;
        Fri, 24 Jan 2020 05:20:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2xqmwckuvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 05:20:18 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00O5KHbn004601;
        Fri, 24 Jan 2020 05:20:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 21:20:17 -0800
Subject: [PATCH 12/12] xfs: fix xfs_buf_ioerror_alert location reporting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Date:   Thu, 23 Jan 2020 21:20:16 -0800
Message-ID: <157984321599.3139258.18182616196423217091.stgit@magnolia>
In-Reply-To: <157984313582.3139258.1136501362141645797.stgit@magnolia>
References: <157984313582.3139258.1136501362141645797.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240042
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Instead of passing __func__ to the error reporting function, let's use
the return address builtins so that the messages actually tell you which
higher level function called the buffer functions.  This was previously
true for the xfs_buf_read callers, but not for the xfs_trans_read_buf
callers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c         |   12 +++++++-----
 fs/xfs/xfs_buf.h         |    7 ++++---
 fs/xfs/xfs_buf_item.c    |    2 +-
 fs/xfs/xfs_log_recover.c |    4 ++--
 fs/xfs/xfs_trans_buf.c   |    5 +++--
 5 files changed, 17 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b420e865b32e..217e4f82a44a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -803,7 +803,8 @@ xfs_buf_read_map(
 	int			nmaps,
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp,
-	const struct xfs_buf_ops *ops)
+	const struct xfs_buf_ops *ops,
+	xfs_failaddr_t		fa)
 {
 	struct xfs_buf		*bp;
 	int			error;
@@ -852,7 +853,7 @@ xfs_buf_read_map(
 	 */
 	if (error) {
 		if (!XFS_FORCED_SHUTDOWN(target->bt_mount))
-			xfs_buf_ioerror_alert(bp, __func__);
+			xfs_buf_ioerror_alert(bp, fa);
 
 		bp->b_flags &= ~XBF_DONE;
 		xfs_buf_stale(bp);
@@ -885,7 +886,8 @@ xfs_buf_readahead_map(
 		return;
 
 	xfs_buf_read_map(target, map, nmaps,
-		     XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops);
+		     XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD, &bp, ops,
+		     __this_address);
 }
 
 /*
@@ -1234,10 +1236,10 @@ __xfs_buf_ioerror(
 void
 xfs_buf_ioerror_alert(
 	struct xfs_buf		*bp,
-	const char		*func)
+	xfs_failaddr_t		func)
 {
 	xfs_alert(bp->b_mount,
-"metadata I/O error in \"%s\" at daddr 0x%llx len %d error %d",
+"metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
 			func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
 			-bp->b_error);
 }
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index aa145ad25e9a..d79a1fe5d738 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -196,7 +196,7 @@ int xfs_buf_get_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
 		int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp);
 int xfs_buf_read_map(struct xfs_buftarg *target, struct xfs_buf_map *map,
 		int nmaps, xfs_buf_flags_t flags, struct xfs_buf **bpp,
-		const struct xfs_buf_ops *ops);
+		const struct xfs_buf_ops *ops, xfs_failaddr_t fa);
 void xfs_buf_readahead_map(struct xfs_buftarg *target,
 			       struct xfs_buf_map *map, int nmaps,
 			       const struct xfs_buf_ops *ops);
@@ -224,7 +224,8 @@ xfs_buf_read(
 {
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-	return xfs_buf_read_map(target, &map, 1, flags, bpp, ops);
+	return xfs_buf_read_map(target, &map, 1, flags, bpp, ops,
+			__builtin_return_address(0));
 }
 
 static inline void
@@ -261,7 +262,7 @@ extern void xfs_buf_ioend(struct xfs_buf *bp);
 extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
 		xfs_failaddr_t failaddr);
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
-extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
+extern void xfs_buf_ioerror_alert(struct xfs_buf *bp, xfs_failaddr_t fa);
 
 extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
 static inline int xfs_buf_submit(struct xfs_buf *bp)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 5be8973a452c..663810e6cd59 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1113,7 +1113,7 @@ xfs_buf_iodone_callback_error(
 	if (bp->b_target != lasttarg ||
 	    time_after(jiffies, (lasttime + 5*HZ))) {
 		lasttime = jiffies;
-		xfs_buf_ioerror_alert(bp, __func__);
+		xfs_buf_ioerror_alert(bp, __this_address);
 	}
 	lasttarg = bp->b_target;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ac79537d3275..25cfc85dbaa7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -294,7 +294,7 @@ xlog_recover_iodone(
 		 * this during recovery. One strike!
 		 */
 		if (!XFS_FORCED_SHUTDOWN(bp->b_mount)) {
-			xfs_buf_ioerror_alert(bp, __func__);
+			xfs_buf_ioerror_alert(bp, __this_address);
 			xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
 		}
 	}
@@ -5627,7 +5627,7 @@ xlog_do_recover(
 	error = xfs_buf_submit(bp);
 	if (error) {
 		if (!XFS_FORCED_SHUTDOWN(mp)) {
-			xfs_buf_ioerror_alert(bp, __func__);
+			xfs_buf_ioerror_alert(bp, __this_address);
 			ASSERT(0);
 		}
 		xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 83470998f87b..08174ffa2118 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -280,7 +280,7 @@ xfs_trans_read_buf_map(
 		ASSERT(bp->b_ops != NULL);
 		error = xfs_buf_reverify(bp, ops);
 		if (error) {
-			xfs_buf_ioerror_alert(bp, __func__);
+			xfs_buf_ioerror_alert(bp, __return_address);
 
 			if (tp->t_flags & XFS_TRANS_DIRTY)
 				xfs_force_shutdown(tp->t_mountp,
@@ -302,7 +302,8 @@ xfs_trans_read_buf_map(
 		return 0;
 	}
 
-	error = xfs_buf_read_map(target, map, nmaps, flags, &bp, ops);
+	error = xfs_buf_read_map(target, map, nmaps, flags, &bp, ops,
+			__return_address);
 	switch (error) {
 	case 0:
 		break;

