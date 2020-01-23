Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 395FC1462C8
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Jan 2020 08:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbgAWHmw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 Jan 2020 02:42:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57004 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgAWHmw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 02:42:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7cBKW170830;
        Thu, 23 Jan 2020 07:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=AnS+A7SyinTOn3nMQ2TZNHrarQ8+T1Gtx30ZOK7i4Rs=;
 b=OLBxOnQejjupak1C2aXb3PSQwF6t4EO+XZwKEcNkUb0dhY4wURMPHzC9lpfscnEC28Gu
 +GHt1fP1vWvamN4ZUXsSLYXlDkLN8x6twPVSODuRdecCYqDghSUvuSmQV5ubXbqgUnVh
 IqogDYQkCv5ohO2kots10R2blAIyp6FWo2H7NHLOEnMLFZnnWLx3pK93Z+Gkzvz/JIhG
 I7iAkGiyEoHSQSAPliU3ZIU8oZ7e7Se8Cre74Q7mAXJUWAMmLRJAS7b3auv3yV+mndoh
 SmiqfMhbwiDYc9tyYMFPAbJolT0GfNyFcZ26xmlxoN+Gx42SA97UKkP6sr44UEgq4lp0 Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2xkseurkvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:42:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00N7d89U036041;
        Thu, 23 Jan 2020 07:42:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xpq0vv1xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 07:42:43 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00N7ggQR017955;
        Thu, 23 Jan 2020 07:42:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Jan 2020 23:42:42 -0800
Subject: [PATCH 08/12] xfs: make xfs_trans_get_buf return an error code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Christoph Hellwig <hch@lst.de>
Date:   Wed, 22 Jan 2020 23:42:41 -0800
Message-ID: <157976536183.2388944.13477041963340008102.stgit@magnolia>
In-Reply-To: <157976531016.2388944.3654360225810285604.stgit@magnolia>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230065
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9508 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230065
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert xfs_trans_get_buf() to return numeric error codes like most
everywhere else in xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree.c  |   23 ++++++++++++++++-------
 fs/xfs/libxfs/xfs_ialloc.c |   12 ++++++------
 fs/xfs/libxfs/xfs_sb.c     |    9 +++++----
 fs/xfs/scrub/repair.c      |    8 ++++++--
 fs/xfs/xfs_attr_inactive.c |   17 +++++++++--------
 fs/xfs/xfs_dquot.c         |    8 ++++----
 fs/xfs/xfs_inode.c         |   12 ++++++------
 fs/xfs/xfs_rtalloc.c       |    8 +++-----
 fs/xfs/xfs_symlink.c       |   19 ++++++++-----------
 fs/xfs/xfs_trans.h         |   13 ++++---------
 10 files changed, 67 insertions(+), 62 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index b22c7e928eb1..2d53e5fdff70 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -688,11 +688,16 @@ xfs_btree_get_bufl(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_fsblock_t	fsbno)		/* file system block number */
 {
+	struct xfs_buf		*bp;
 	xfs_daddr_t		d;		/* real disk block address */
+	int			error;
 
 	ASSERT(fsbno != NULLFSBLOCK);
 	d = XFS_FSB_TO_DADDR(mp, fsbno);
-	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0);
+	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, &bp);
+	if (error)
+		return NULL;
+	return bp;
 }
 
 /*
@@ -706,12 +711,17 @@ xfs_btree_get_bufs(
 	xfs_agnumber_t	agno,		/* allocation group number */
 	xfs_agblock_t	agbno)		/* allocation group block number */
 {
+	struct xfs_buf		*bp;
 	xfs_daddr_t		d;		/* real disk block address */
+	int			error;
 
 	ASSERT(agno != NULLAGNUMBER);
 	ASSERT(agbno != NULLAGBLOCK);
 	d = XFS_AGB_TO_DADDR(mp, agno, agbno);
-	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0);
+	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0, &bp);
+	if (error)
+		return NULL;
+	return bp;
 }
 
 /*
@@ -1270,11 +1280,10 @@ xfs_btree_get_buf_block(
 	error = xfs_btree_ptr_to_daddr(cur, ptr, &d);
 	if (error)
 		return error;
-	*bpp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
-				 mp->m_bsize, 0);
-
-	if (!*bpp)
-		return -ENOMEM;
+	error = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d, mp->m_bsize,
+			0, bpp);
+	if (error)
+		return error;
 
 	(*bpp)->b_ops = cur->bc_ops->buf_ops;
 	*block = XFS_BUF_TO_BLOCK(*bpp);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 5b759af4d165..bf161e930f1d 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -276,6 +276,7 @@ xfs_ialloc_inode_init(
 	int			i, j;
 	xfs_daddr_t		d;
 	xfs_ino_t		ino = 0;
+	int			error;
 
 	/*
 	 * Loop over the new block(s), filling in the inodes.  For small block
@@ -327,12 +328,11 @@ xfs_ialloc_inode_init(
 		 */
 		d = XFS_AGB_TO_DADDR(mp, agno, agbno +
 				(j * M_IGEO(mp)->blocks_per_cluster));
-		fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
-					 mp->m_bsize *
-					 M_IGEO(mp)->blocks_per_cluster,
-					 XBF_UNMAPPED);
-		if (!fbuf)
-			return -ENOMEM;
+		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
+				mp->m_bsize * M_IGEO(mp)->blocks_per_cluster,
+				XBF_UNMAPPED, &fbuf);
+		if (error)
+			return error;
 
 		/* Initialize the inode buffers and log them appropriately. */
 		fbuf->b_ops = &xfs_inode_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 6fdd007f81ab..2f60fc3c99a0 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1185,13 +1185,14 @@ xfs_sb_get_secondary(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_buf		*bp;
+	int			error;
 
 	ASSERT(agno != 0 && agno != NULLAGNUMBER);
-	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp,
+	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
-			XFS_FSS_TO_BB(mp, 1), 0);
-	if (!bp)
-		return -ENOMEM;
+			XFS_FSS_TO_BB(mp, 1), 0, &bp);
+	if (error)
+		return error;
 	bp->b_ops = &xfs_sb_buf_ops;
 	xfs_buf_oneshot(bp);
 	*bpp = bp;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index b70a88bc975e..3df49d487940 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -341,13 +341,17 @@ xrep_init_btblock(
 	struct xfs_trans		*tp = sc->tp;
 	struct xfs_mount		*mp = sc->mp;
 	struct xfs_buf			*bp;
+	int				error;
 
 	trace_xrep_init_btblock(mp, XFS_FSB_TO_AGNO(mp, fsb),
 			XFS_FSB_TO_AGBNO(mp, fsb), btnum);
 
 	ASSERT(XFS_FSB_TO_AGNO(mp, fsb) == sc->sa.agno);
-	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, XFS_FSB_TO_DADDR(mp, fsb),
-			XFS_FSB_TO_BB(mp, 1), 0);
+	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(mp, fsb), XFS_FSB_TO_BB(mp, 1), 0,
+			&bp);
+	if (error)
+		return error;
 	xfs_buf_zero(bp, 0, BBTOB(bp->b_length));
 	xfs_btree_init_block(mp, bp, btnum, 0, 0, sc->sa.agno);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_BTREE_BUF);
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index c75840a9e478..eddd5d311b0c 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -205,11 +205,12 @@ xfs_attr3_node_inactive(
 		/*
 		 * Remove the subsidiary block from the cache and from the log.
 		 */
-		child_bp = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
+		error = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
 				child_blkno,
-				XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0);
-		if (!child_bp)
-			return -EIO;
+				XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0,
+				&child_bp);
+		if (error)
+			return error;
 		error = bp->b_error;
 		if (error) {
 			xfs_trans_brelse(*trans, child_bp);
@@ -298,10 +299,10 @@ xfs_attr3_root_inactive(
 	/*
 	 * Invalidate the incore copy of the root block.
 	 */
-	bp = xfs_trans_get_buf(*trans, mp->m_ddev_targp, blkno,
-			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0);
-	if (!bp)
-		return -EIO;
+	error = xfs_trans_get_buf(*trans, mp->m_ddev_targp, blkno,
+			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0, &bp);
+	if (error)
+		return error;
 	error = bp->b_error;
 	if (error) {
 		xfs_trans_brelse(*trans, bp);
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 9cfd3209f52b..d223e1ae90a6 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -320,10 +320,10 @@ xfs_dquot_disk_alloc(
 	dqp->q_blkno = XFS_FSB_TO_DADDR(mp, map.br_startblock);
 
 	/* now we can just get the buffer (there's nothing to read yet) */
-	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, dqp->q_blkno,
-			mp->m_quotainfo->qi_dqchunklen, 0);
-	if (!bp)
-		return -ENOMEM;
+	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, dqp->q_blkno,
+			mp->m_quotainfo->qi_dqchunklen, 0, &bp);
+	if (error)
+		return error;
 	bp->b_ops = &xfs_dquot_buf_ops;
 
 	/*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1979a0055763..c5077e6326c7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2546,6 +2546,7 @@ xfs_ifree_cluster(
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	xfs_ino_t		inum;
+	int			error;
 
 	inum = xic->first_ino;
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
@@ -2574,12 +2575,11 @@ xfs_ifree_cluster(
 		 * complete before we get a lock on it, and hence we may fail
 		 * to mark all the active inodes on the buffer stale.
 		 */
-		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
-					mp->m_bsize * igeo->blocks_per_cluster,
-					XBF_UNMAPPED);
-
-		if (!bp)
-			return -ENOMEM;
+		error = xfs_trans_get_buf(tp, mp->m_ddev_targp, blkno,
+				mp->m_bsize * igeo->blocks_per_cluster,
+				XBF_UNMAPPED, &bp);
+		if (error)
+			return error;
 
 		/*
 		 * This buffer may not have been correctly initialised as we
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d42b5a2047e0..6209e7b6b895 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -826,12 +826,10 @@ xfs_growfs_rt_alloc(
 			 * Get a buffer for the block.
 			 */
 			d = XFS_FSB_TO_DADDR(mp, fsbno);
-			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
-				mp->m_bsize, 0);
-			if (bp == NULL) {
-				error = -EIO;
+			error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
+					mp->m_bsize, 0, &bp);
+			if (error)
 				goto out_trans_cancel;
-			}
 			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
 			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 			/*
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index b94d7b9b55d0..d762d42ed0ff 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -280,12 +280,10 @@ xfs_symlink(
 
 			d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
 			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
-			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
-					       BTOBB(byte_cnt), 0);
-			if (!bp) {
-				error = -ENOMEM;
+			error = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
+					       BTOBB(byte_cnt), 0, &bp);
+			if (error)
 				goto out_trans_cancel;
-			}
 			bp->b_ops = &xfs_symlink_buf_ops;
 
 			byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
@@ -423,13 +421,12 @@ xfs_inactive_symlink_rmt(
 	 * Invalidate the block(s). No validation is done.
 	 */
 	for (i = 0; i < nmaps; i++) {
-		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp,
-			XFS_FSB_TO_DADDR(mp, mval[i].br_startblock),
-			XFS_FSB_TO_BB(mp, mval[i].br_blockcount), 0);
-		if (!bp) {
-			error = -ENOMEM;
+		error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
+				XFS_FSB_TO_DADDR(mp, mval[i].br_startblock),
+				XFS_FSB_TO_BB(mp, mval[i].br_blockcount), 0,
+				&bp);
+		if (error)
 			goto error_trans_cancel;
-		}
 		xfs_trans_binval(tp, bp);
 	}
 	/*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a0be934ec811..752c7fef9de7 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -173,22 +173,17 @@ int xfs_trans_get_buf_map(struct xfs_trans *tp, struct xfs_buftarg *target,
 		struct xfs_buf_map *map, int nmaps, xfs_buf_flags_t flags,
 		struct xfs_buf **bpp);
 
-static inline struct xfs_buf *
+static inline int
 xfs_trans_get_buf(
 	struct xfs_trans	*tp,
 	struct xfs_buftarg	*target,
 	xfs_daddr_t		blkno,
 	int			numblks,
-	uint			flags)
+	uint			flags,
+	struct xfs_buf		**bpp)
 {
-	struct xfs_buf		*bp;
-	int			error;
-
 	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
-	error = xfs_trans_get_buf_map(tp, target, &map, 1, flags, &bp);
-	if (error)
-		return NULL;
-	return bp;
+	return xfs_trans_get_buf_map(tp, target, &map, 1, flags, bpp);
 }
 
 int		xfs_trans_read_buf_map(struct xfs_mount *mp,

