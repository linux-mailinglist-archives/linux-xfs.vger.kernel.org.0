Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC0A9572E1
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfFZUpG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:45:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48636 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfFZUpG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:45:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKhw8P012251;
        Wed, 26 Jun 2019 20:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=4i5sCTzUz4PZfWVEaRY/V8lA0g3Vm5WZ02AoBOQYL+0=;
 b=QRLrRYppfqzyLEyNvNKO0bwojcT6VBb4e5maxq2D6YH6yZu7j98IWcSYhyMstzMf1hWD
 B2SLiDFxZeiJQpS0hBdhS/gCTPGHse0NIniObX2T5hTVBcd12CL+ZkU5lqfEaS7Ut0NS
 1rkutBahimrhyJ0RSuMN2iDcJ5LdznraKBmHsWx3esYSo+EsQ//W+r5ZF4BMpX9mXJVS
 1Avbhmd7Moxf6dCXU0so20NS0Y9qOla252HdiU8Z+3yCvUr6Fj6glqWIRwp+v/93xJs9
 x7c7PIV5Q5Hai4NN1Dhl36DbjMGLUVLrSXUGv8n+R1uyHDM5RT9X+c+ikASmoImgSStu iA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t9brtcmnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 20:44:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKhu9h010833;
        Wed, 26 Jun 2019 20:44:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t99f4nvea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 20:44:49 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5QKimMI003982;
        Wed, 26 Jun 2019 20:44:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 13:44:47 -0700
Subject: [PATCH 08/15] xfs: move bulkstat ichunk helpers to iwalk code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 26 Jun 2019 13:44:47 -0700
Message-ID: <156158188703.495087.3342103458889325673.stgit@magnolia>
In-Reply-To: <156158183697.495087.5371839759804528321.stgit@magnolia>
References: <156158183697.495087.5371839759804528321.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260240
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260240
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've reworked the bulkstat code to use iwalk, we can move the
old bulkstat ichunk helpers to xfs_iwalk.c.  No functional changes here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_itable.c |   93 -------------------------------------------------
 fs/xfs/xfs_itable.h |    8 ----
 fs/xfs/xfs_iwalk.c  |   96 +++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 93 insertions(+), 104 deletions(-)


diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 09ae33a88766..a0603e7ed5dd 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -189,99 +189,6 @@ xfs_bulkstat_one(
 	return error;
 }
 
-/*
- * Loop over all clusters in a chunk for a given incore inode allocation btree
- * record.  Do a readahead if there are any allocated inodes in that cluster.
- */
-void
-xfs_bulkstat_ichunk_ra(
-	struct xfs_mount		*mp,
-	xfs_agnumber_t			agno,
-	struct xfs_inobt_rec_incore	*irec)
-{
-	struct xfs_ino_geometry		*igeo = M_IGEO(mp);
-	xfs_agblock_t			agbno;
-	struct blk_plug			plug;
-	int				i;	/* inode chunk index */
-
-	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
-
-	blk_start_plug(&plug);
-	for (i = 0;
-	     i < XFS_INODES_PER_CHUNK;
-	     i += igeo->inodes_per_cluster,
-			agbno += igeo->blocks_per_cluster) {
-		if (xfs_inobt_maskn(i, igeo->inodes_per_cluster) &
-		    ~irec->ir_free) {
-			xfs_btree_reada_bufs(mp, agno, agbno,
-					igeo->blocks_per_cluster,
-					&xfs_inode_buf_ops);
-		}
-	}
-	blk_finish_plug(&plug);
-}
-
-/*
- * Lookup the inode chunk that the given inode lives in and then get the record
- * if we found the chunk.  If the inode was not the last in the chunk and there
- * are some left allocated, update the data for the pointed-to record as well as
- * return the count of grabbed inodes.
- */
-int
-xfs_bulkstat_grab_ichunk(
-	struct xfs_btree_cur		*cur,	/* btree cursor */
-	xfs_agino_t			agino,	/* starting inode of chunk */
-	int				*icount,/* return # of inodes grabbed */
-	struct xfs_inobt_rec_incore	*irec)	/* btree record */
-{
-	int				idx;	/* index into inode chunk */
-	int				stat;
-	int				error = 0;
-
-	/* Lookup the inode chunk that this inode lives in */
-	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &stat);
-	if (error)
-		return error;
-	if (!stat) {
-		*icount = 0;
-		return error;
-	}
-
-	/* Get the record, should always work */
-	error = xfs_inobt_get_rec(cur, irec, &stat);
-	if (error)
-		return error;
-	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, stat == 1);
-
-	/* Check if the record contains the inode in request */
-	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino) {
-		*icount = 0;
-		return 0;
-	}
-
-	idx = agino - irec->ir_startino + 1;
-	if (idx < XFS_INODES_PER_CHUNK &&
-	    (xfs_inobt_maskn(idx, XFS_INODES_PER_CHUNK - idx) & ~irec->ir_free)) {
-		int	i;
-
-		/* We got a right chunk with some left inodes allocated at it.
-		 * Grab the chunk record.  Mark all the uninteresting inodes
-		 * free -- because they're before our start point.
-		 */
-		for (i = 0; i < idx; i++) {
-			if (XFS_INOBT_MASK(i) & ~irec->ir_free)
-				irec->ir_freecount++;
-		}
-
-		irec->ir_free |= xfs_inobt_maskn(0, idx);
-		*icount = irec->ir_count - irec->ir_freecount;
-	}
-
-	return 0;
-}
-
-#define XFS_BULKSTAT_UBLEFT(ubleft)	((ubleft) >= statstruct_size)
-
 static int
 xfs_bulkstat_iwalk(
 	struct xfs_mount	*mp,
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 624ffbf8cd85..1db1cd30aa29 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -64,12 +64,4 @@ xfs_inumbers(
 	void			__user *buffer, /* buffer with inode info */
 	inumbers_fmt_pf		formatter);
 
-/* Temporarily needed while we refactor functions. */
-struct xfs_btree_cur;
-struct xfs_inobt_rec_incore;
-void xfs_bulkstat_ichunk_ra(struct xfs_mount *mp, xfs_agnumber_t agno,
-		struct xfs_inobt_rec_incore *irec);
-int xfs_bulkstat_grab_ichunk(struct xfs_btree_cur *cur, xfs_agino_t agino,
-		int *icount, struct xfs_inobt_rec_incore *irec);
-
 #endif	/* __XFS_ITABLE_H__ */
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 3e67d7702e16..99539421ee57 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -15,7 +15,6 @@
 #include "xfs_ialloc.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_iwalk.h"
-#include "xfs_itable.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_icache.h"
@@ -66,6 +65,97 @@ struct xfs_iwalk_ag {
 	void				*data;
 };
 
+/*
+ * Loop over all clusters in a chunk for a given incore inode allocation btree
+ * record.  Do a readahead if there are any allocated inodes in that cluster.
+ */
+STATIC void
+xfs_iwalk_ichunk_ra(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno,
+	struct xfs_inobt_rec_incore	*irec)
+{
+	struct xfs_ino_geometry		*igeo = M_IGEO(mp);
+	xfs_agblock_t			agbno;
+	struct blk_plug			plug;
+	int				i;	/* inode chunk index */
+
+	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
+
+	blk_start_plug(&plug);
+	for (i = 0;
+	     i < XFS_INODES_PER_CHUNK;
+	     i += igeo->inodes_per_cluster,
+			agbno += igeo->blocks_per_cluster) {
+		if (xfs_inobt_maskn(i, igeo->inodes_per_cluster) &
+		    ~irec->ir_free) {
+			xfs_btree_reada_bufs(mp, agno, agbno,
+					igeo->blocks_per_cluster,
+					&xfs_inode_buf_ops);
+		}
+	}
+	blk_finish_plug(&plug);
+}
+
+/*
+ * Lookup the inode chunk that the given inode lives in and then get the record
+ * if we found the chunk.  If the inode was not the last in the chunk and there
+ * are some left allocated, update the data for the pointed-to record as well as
+ * return the count of grabbed inodes.
+ */
+STATIC int
+xfs_iwalk_grab_ichunk(
+	struct xfs_btree_cur		*cur,	/* btree cursor */
+	xfs_agino_t			agino,	/* starting inode of chunk */
+	int				*icount,/* return # of inodes grabbed */
+	struct xfs_inobt_rec_incore	*irec)	/* btree record */
+{
+	int				idx;	/* index into inode chunk */
+	int				stat;
+	int				error = 0;
+
+	/* Lookup the inode chunk that this inode lives in */
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &stat);
+	if (error)
+		return error;
+	if (!stat) {
+		*icount = 0;
+		return error;
+	}
+
+	/* Get the record, should always work */
+	error = xfs_inobt_get_rec(cur, irec, &stat);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, stat == 1);
+
+	/* Check if the record contains the inode in request */
+	if (irec->ir_startino + XFS_INODES_PER_CHUNK <= agino) {
+		*icount = 0;
+		return 0;
+	}
+
+	idx = agino - irec->ir_startino + 1;
+	if (idx < XFS_INODES_PER_CHUNK &&
+	    (xfs_inobt_maskn(idx, XFS_INODES_PER_CHUNK - idx) & ~irec->ir_free)) {
+		int	i;
+
+		/* We got a right chunk with some left inodes allocated at it.
+		 * Grab the chunk record.  Mark all the uninteresting inodes
+		 * free -- because they're before our start point.
+		 */
+		for (i = 0; i < idx; i++) {
+			if (XFS_INOBT_MASK(i) & ~irec->ir_free)
+				irec->ir_freecount++;
+		}
+
+		irec->ir_free |= xfs_inobt_maskn(0, idx);
+		*icount = irec->ir_count - irec->ir_freecount;
+	}
+
+	return 0;
+}
+
 /* Allocate memory for a walk. */
 STATIC int
 xfs_iwalk_alloc(
@@ -191,7 +281,7 @@ xfs_iwalk_ag_start(
 	 * We require a lookup cache of at least two elements so that we don't
 	 * have to deal with tearing down the cursor to walk the records.
 	 */
-	error = xfs_bulkstat_grab_ichunk(*curpp, agino - 1, &icount,
+	error = xfs_iwalk_grab_ichunk(*curpp, agino - 1, &icount,
 			&iwag->recs[iwag->nr_recs]);
 	if (error)
 		return error;
@@ -298,7 +388,7 @@ xfs_iwalk_ag(
 		 * Start readahead for this inode chunk in anticipation of
 		 * walking the inodes.
 		 */
-		xfs_bulkstat_ichunk_ra(mp, agno, irec);
+		xfs_iwalk_ichunk_ra(mp, agno, irec);
 
 		/*
 		 * If there's space in the buffer for more records, increment

