Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35DC741C87
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 08:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfFLGsG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 02:48:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33156 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbfFLGsG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:48:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6hZbL051361;
        Wed, 12 Jun 2019 06:47:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=1OAg7O0kmIiIsWYqmwPwsKVwtQHSaCNHUBgu3dSKOXk=;
 b=1cjOzhrkWnlISo088LuDd75XLfXfYY5Ri2OrEpxthG2kFjfuxdkYoVzq9avobZ3EjitL
 bL5S29ggfhSAMUbJ0JF09egnBqk9IZalI1A1IupN2FV5XmwyODByMjWg/cq4GPrQWmPf
 Q1Dmt2B+ozhaG7L9Z793EwDuoRlprN/nv48K80NMQRG9eS4eQGrmFOCy9EgYSzqYqb3f
 zXmzX8BZtKDcxjxyJvdx3iyA4ptjyoWJ3v151DVfSP5k95ydXo8wiOAA9K/YmG7YpS2x
 kbweramh5iN5YR4QLhK/Vt9ztK2nJSwPjgzcBrfsTQ5fHuVT/5W13M+9+2Tn4MHzJjUq lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2t05nqsbp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 06:47:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6kCS8094630;
        Wed, 12 Jun 2019 06:47:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2t0p9rq2fk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 06:47:40 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5C6ldA8005700;
        Wed, 12 Jun 2019 06:47:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Jun 2019 23:47:39 -0700
Subject: [PATCH 01/14] xfs: create iterator error codes
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Tue, 11 Jun 2019 23:47:37 -0700
Message-ID: <156032205794.3774243.2000474980369140298.stgit@magnolia>
In-Reply-To: <156032205136.3774243.15725828509940520561.stgit@magnolia>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906120046
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906120046
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Currently, xfs doesn't have generic error codes defined for "stop
iterating"; we just reuse the XFS_BTREE_QUERY_* return values.  This
looks a little weird if we're not actually iterating a btree index.
Before we start adding more iterators, we should create general
XFS_ITER_{CONTINUE,ABORT} return values and define the XFS_BTREE_QUERY_*
ones from that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  |    2 +-
 fs/xfs/libxfs/xfs_btree.h  |    4 ++--
 fs/xfs/libxfs/xfs_shared.h |    6 ++++++
 fs/xfs/scrub/agheader.c    |    4 ++--
 fs/xfs/scrub/repair.c      |    4 ++--
 fs/xfs/xfs_dquot.c         |    2 +-
 6 files changed, 14 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a9ff3cf82cce..b9eb3a8aeaf9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3146,7 +3146,7 @@ xfs_alloc_has_record(
 
 /*
  * Walk all the blocks in the AGFL.  The @walk_fn can return any negative
- * error code or XFS_BTREE_QUERY_RANGE_ABORT.
+ * error code or XFS_ITER_*.
  */
 int
 xfs_agfl_walk(
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index e3b3e9dce5da..94530766dd30 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -469,8 +469,8 @@ uint xfs_btree_compute_maxlevels(uint *limits, unsigned long len);
 unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
 
 /* return codes */
-#define XFS_BTREE_QUERY_RANGE_CONTINUE	0	/* keep iterating */
-#define XFS_BTREE_QUERY_RANGE_ABORT	1	/* stop iterating */
+#define XFS_BTREE_QUERY_RANGE_CONTINUE	(XFS_ITER_CONTINUE) /* keep iterating */
+#define XFS_BTREE_QUERY_RANGE_ABORT	(XFS_ITER_ABORT)    /* stop iterating */
 typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
 		union xfs_btree_rec *rec, void *priv);
 
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 4e909791aeac..fa788139dfe3 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -136,4 +136,10 @@ void xfs_symlink_local_to_remote(struct xfs_trans *tp, struct xfs_buf *bp,
 				 struct xfs_inode *ip, struct xfs_ifork *ifp);
 xfs_failaddr_t xfs_symlink_shortform_verify(struct xfs_inode *ip);
 
+/* Keep iterating the data structure. */
+#define XFS_ITER_CONTINUE	(0)
+
+/* Stop iterating the data structure. */
+#define XFS_ITER_ABORT		(1)
+
 #endif /* __XFS_SHARED_H__ */
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index adaeabdefdd3..1d5361f9ebfc 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -646,7 +646,7 @@ xchk_agfl_block(
 	xchk_agfl_block_xref(sc, agbno);
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		return XFS_BTREE_QUERY_RANGE_ABORT;
+		return XFS_ITER_ABORT;
 
 	return 0;
 }
@@ -737,7 +737,7 @@ xchk_agfl(
 	/* Check the blocks in the AGFL. */
 	error = xfs_agfl_walk(sc->mp, XFS_BUF_TO_AGF(sc->sa.agf_bp),
 			sc->sa.agfl_bp, xchk_agfl_block, &sai);
-	if (error == XFS_BTREE_QUERY_RANGE_ABORT) {
+	if (error == XFS_ITER_ABORT) {
 		error = 0;
 		goto out_free;
 	}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index eb358f0f5e0a..e2a352c1bad7 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -672,7 +672,7 @@ xrep_findroot_agfl_walk(
 {
 	xfs_agblock_t		*agbno = priv;
 
-	return (*agbno == bno) ? XFS_BTREE_QUERY_RANGE_ABORT : 0;
+	return (*agbno == bno) ? XFS_ITER_ABORT : 0;
 }
 
 /* Does this block match the btree information passed in? */
@@ -702,7 +702,7 @@ xrep_findroot_block(
 	if (owner == XFS_RMAP_OWN_AG) {
 		error = xfs_agfl_walk(mp, ri->agf, ri->agfl_bp,
 				xrep_findroot_agfl_walk, &agbno);
-		if (error == XFS_BTREE_QUERY_RANGE_ABORT)
+		if (error == XFS_ITER_ABORT)
 			return 0;
 		if (error)
 			return error;
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a1af984e4913..8674551c5e98 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1243,7 +1243,7 @@ xfs_qm_exit(void)
 /*
  * Iterate every dquot of a particular type.  The caller must ensure that the
  * particular quota type is active.  iter_fn can return negative error codes,
- * or XFS_BTREE_QUERY_RANGE_ABORT to indicate that it wants to stop iterating.
+ * or XFS_ITER_ABORT to indicate that it wants to stop iterating.
  */
 int
 xfs_qm_dqiterate(

