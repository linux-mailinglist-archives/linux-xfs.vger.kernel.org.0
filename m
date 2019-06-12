Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5097C41CA0
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 08:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404483AbfFLGu4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Jun 2019 02:50:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403835AbfFLGu4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:50:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6mmnW055352;
        Wed, 12 Jun 2019 06:50:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=0DgBx8jmgh6VkSnpDaYFTbYuT5fF6E9lrm/OXIatpqA=;
 b=IPMGcQrt7Lxiw3jTQihiSdJhSpsGeGZS+CO8gdx0vVbzMWXtMuUrNaZELtIbXqZh4wqH
 TbEvRKSmG23jXoCyS9mPR9e/unAezFuEVt7ED/Gqkso+W0m1oYmIOVpG3N+zH0nNV1PA
 iqoNELOFLjViAmqvA44xcVyxuAzR4olibdCw8CoADWpaLj9av84OE5nXEg+s13m8b26Z
 iDHjLXP1F0LixFtRstIMmz9vSrtEqhF6S9BiJZ8plGyH+I2X0un7YL+Mivqh2UrzFEjk
 T3HRwExMFNy3xqHVMZmepxPLMdNgiApjog1KRgE0H+vtHbo+UUzYgbRQ3eQQq91AWmX/ MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2t05nqsc1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 06:50:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C6mIVE176926;
        Wed, 12 Jun 2019 06:48:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2t1jphuvq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 06:48:44 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5C6mi8x030651;
        Wed, 12 Jun 2019 06:48:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Jun 2019 23:48:43 -0700
Subject: [PATCH 11/14] xfs: refactor iwalk code to handle walking inobt
 records
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Tue, 11 Jun 2019 23:48:42 -0700
Message-ID: <156032212280.3774243.2412398404922269104.stgit@magnolia>
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
 engine=8.0.1-1810050000 definitions=main-1906120047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906120047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor xfs_iwalk_ag_start and xfs_iwalk_ag so that the bits that are
particular to bulkstat (trimming the start irec, starting inode
readahead, and skipping empty groups) can be controlled via flags in the
iwag structure.

This enables us to add a new function to walk all inobt records which
will be used for the new INUMBERS implementation in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iwalk.c |   75 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_iwalk.h |   12 ++++++++
 2 files changed, 84 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 8c4d7e59f86a..def37347a362 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -62,7 +62,18 @@ struct xfs_iwalk_ag {
 
 	/* Inode walk function and data pointer. */
 	xfs_iwalk_fn			iwalk_fn;
+	xfs_inobt_walk_fn		inobt_walk_fn;
 	void				*data;
+
+	/*
+	 * Make it look like the inodes up to startino are free so that
+	 * bulkstat can start its inode iteration at the correct place without
+	 * needing to special case everywhere.
+	 */
+	unsigned int			trim_start:1;
+
+	/* Skip empty inobt records? */
+	unsigned int			skip_empty:1;
 };
 
 /*
@@ -170,6 +181,16 @@ xfs_iwalk_ag_recs(
 
 		trace_xfs_iwalk_ag_rec(mp, agno, irec);
 
+		if (iwag->inobt_walk_fn) {
+			error = iwag->inobt_walk_fn(mp, tp, agno, irec,
+					iwag->data);
+			if (error)
+				return error;
+		}
+
+		if (!iwag->iwalk_fn)
+			continue;
+
 		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
 			/* Skip if this inode is free */
 			if (XFS_INOBT_MASK(j) & irec->ir_free)
@@ -279,7 +300,8 @@ xfs_iwalk_ag_start(
 	 * If agino fell in the middle of the inode record, make it look like
 	 * the inodes up to agino are free so that we don't return them again.
 	 */
-	xfs_iwalk_adjust_start(agino, irec);
+	if (iwag->trim_start)
+		xfs_iwalk_adjust_start(agino, irec);
 
 	/*
 	 * set_prefetch is supposed to give us a large enough inobt record
@@ -372,7 +394,7 @@ xfs_iwalk_ag(
 			break;
 
 		/* No allocated inodes in this chunk; skip it. */
-		if (irec->ir_freecount == irec->ir_count) {
+		if (iwag->skip_empty && irec->ir_freecount == irec->ir_count) {
 			error = xfs_btree_increment(cur, 0, &has_more);
 			if (error)
 				break;
@@ -383,7 +405,8 @@ xfs_iwalk_ag(
 		 * Start readahead for this inode chunk in anticipation of
 		 * walking the inodes.
 		 */
-		xfs_iwalk_ichunk_ra(mp, agno, irec);
+		if (iwag->iwalk_fn)
+			xfs_iwalk_ichunk_ra(mp, agno, irec);
 
 		/*
 		 * If there's space in the buffer for more records, increment
@@ -481,6 +504,8 @@ xfs_iwalk(
 		.iwalk_fn	= iwalk_fn,
 		.data		= data,
 		.startino	= startino,
+		.trim_start	= 1,
+		.skip_empty	= 1,
 	};
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;
@@ -502,3 +527,47 @@ xfs_iwalk(
 	xfs_iwalk_free(&iwag);
 	return error;
 }
+
+/*
+ * Walk all inode btree records in the filesystem starting from @startino.  The
+ * @inobt_walk_fn will be called for each btree record, being passed the incore
+ * record and @data.  @max_prefetch controls how many inobt records we try to
+ * cache ahead of time.
+ */
+int
+xfs_inobt_walk(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_ino_t		startino,
+	xfs_inobt_walk_fn	inobt_walk_fn,
+	unsigned int		max_prefetch,
+	void			*data)
+{
+	struct xfs_iwalk_ag	iwag = {
+		.mp		= mp,
+		.tp		= tp,
+		.inobt_walk_fn	= inobt_walk_fn,
+		.data		= data,
+		.startino	= startino,
+	};
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
+	int			error;
+
+	ASSERT(agno < mp->m_sb.sb_agcount);
+
+	/* Translate inumbers record count to inode count. */
+	xfs_iwalk_set_prefetch(&iwag, max_prefetch * XFS_INODES_PER_CHUNK);
+	error = xfs_iwalk_alloc(&iwag);
+	if (error)
+		return error;
+
+	for (; agno < mp->m_sb.sb_agcount; agno++) {
+		error = xfs_iwalk_ag(&iwag);
+		if (error)
+			break;
+		iwag.startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+	}
+
+	xfs_iwalk_free(&iwag);
+	return error;
+}
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 9e762e31dadc..97c1120d4237 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -16,4 +16,16 @@ typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
 		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
 
+/* Walk all inode btree records in the filesystem starting from @startino. */
+typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
+				 xfs_agnumber_t agno,
+				 const struct xfs_inobt_rec_incore *irec,
+				 void *data);
+/* Return value (for xfs_inobt_walk_fn) that aborts the walk immediately. */
+#define XFS_INOBT_WALK_ABORT	(XFS_IWALK_ABORT)
+
+int xfs_inobt_walk(struct xfs_mount *mp, struct xfs_trans *tp,
+		xfs_ino_t startino, xfs_inobt_walk_fn inobt_walk_fn,
+		unsigned int max_prefetch, void *data);
+
 #endif /* __XFS_IWALK_H__ */

