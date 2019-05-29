Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F05842E82B
	for <lists+linux-xfs@lfdr.de>; Thu, 30 May 2019 00:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfE2W05 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 May 2019 18:26:57 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36306 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfE2W05 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 18:26:57 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TM41tb041565
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=12HWU1rjGxZuy7mDK0ePpdp7OpvPjxjlmJtLz4h6HlI=;
 b=qZBCSePx6J+M+HV7+UxWjT+XJC0oVJ5oOgfuAZQeZpCCRISZpEMRje1r5lJkhyZknRQH
 +SHx+JxssHafKLV6xY52qcXfGdywo8O+RvirIYh56GMlZz/vTzJK10CnjjTyToRC3bnl
 sjV3Zq6hp71qSeOW62/n2voptqbxVOs6trCeuDTvSgEr4ufexaLVkU5UjIjslirUeRkC
 1Sn3Y0vqBmm8EdrBExdm+u2acS+HmwYZcofNwzmYxgeXsuIqTplaMYPA1dl2/NIVi6RB
 C9XwjbJmS3XNpKIxyDLvuk3RmGeUQcRYuHiaDiihMZSPOi2XxakzRqX0x6s3J7t20q6A jA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2spu7dn15a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4TMQ2J2164480
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2sr31vh8s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:54 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4TMQrk0021281
        for <linux-xfs@vger.kernel.org>; Wed, 29 May 2019 22:26:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 15:26:53 -0700
Subject: [PATCH 06/11] xfs: move bulkstat ichunk helpers to iwalk code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 May 2019 15:26:52 -0700
Message-ID: <155916881228.757870.16878993812159363561.stgit@magnolia>
In-Reply-To: <155916877311.757870.11060347556535201032.stgit@magnolia>
References: <155916877311.757870.11060347556535201032.stgit@magnolia>
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

Now that we've reworked the bulkstat code to use iwalk, we can move the
old bulkstat ichunk helpers to xfs_iwalk.c.  No functional changes here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_itable.c |   93 --------------------------------------------------
 fs/xfs/xfs_itable.h |    8 ----
 fs/xfs/xfs_iwalk.c  |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 93 insertions(+), 103 deletions(-)


diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 454bc992bf93..06abe5c9c0ee 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -186,99 +186,6 @@ xfs_bulkstat_one(
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
-	struct xfs_ino_geometry		*igeo = &mp->m_ino_geo;
-	xfs_agblock_t			agbno;
-	struct blk_plug			plug;
-	int				i;	/* inode chunk index */
-
-	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
-
-	blk_start_plug(&plug);
-	for (i = 0;
-	     i < XFS_INODES_PER_CHUNK;
-	     i += igeo->ig_inodes_per_cluster,
-			agbno += igeo->ig_blocks_per_cluster) {
-		if (xfs_inobt_maskn(i, igeo->ig_inodes_per_cluster) &
-		    ~irec->ir_free) {
-			xfs_btree_reada_bufs(mp, agno, agbno,
-					igeo->ig_blocks_per_cluster,
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
index 366d391eb11f..a2562fe8d282 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -67,12 +67,4 @@ xfs_inumbers(
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
index 0ce3baa159ba..77320c297284 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -54,6 +54,97 @@ struct xfs_iwalk_ag {
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
+	struct xfs_ino_geometry		*igeo = &mp->m_ino_geo;
+	xfs_agblock_t			agbno;
+	struct blk_plug			plug;
+	int				i;	/* inode chunk index */
+
+	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
+
+	blk_start_plug(&plug);
+	for (i = 0;
+	     i < XFS_INODES_PER_CHUNK;
+	     i += igeo->ig_inodes_per_cluster,
+			agbno += igeo->ig_blocks_per_cluster) {
+		if (xfs_inobt_maskn(i, igeo->ig_inodes_per_cluster) &
+		    ~irec->ir_free) {
+			xfs_btree_reada_bufs(mp, agno, agbno,
+					igeo->ig_blocks_per_cluster,
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
 xfs_iwalk_allocbuf(
@@ -204,7 +295,7 @@ xfs_iwalk_ag_start(
 	 * We require a lookup cache of at least two elements so that we don't
 	 * have to deal with tearing down the cursor to walk the records.
 	 */
-	error = xfs_bulkstat_grab_ichunk(*curpp, agino - 1, &icount,
+	error = xfs_iwalk_grab_ichunk(*curpp, agino - 1, &icount,
 			&iwag->recs[iwag->nr_recs]);
 	if (error)
 		return error;
@@ -305,7 +396,7 @@ xfs_iwalk_ag(
 		 * Start readahead for this inode chunk in anticipation of
 		 * walking the inodes.
 		 */
-		xfs_bulkstat_ichunk_ra(mp, agno, irec);
+		xfs_iwalk_ichunk_ra(mp, agno, irec);
 
 		/*
 		 * Add this inobt record to our cache, flush the cache if

