Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13C85572E6
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 22:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfFZUp1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Jun 2019 16:45:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48916 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUp1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jun 2019 16:45:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKi5Ha012345;
        Wed, 26 Jun 2019 20:45:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=JYdVpUGk7wFZDyp4Zp1slJcnA6I9GFvi13HquxiQDDc=;
 b=xBb+PAzqrSem66xBR3swWvjOj+CA7MPW7Kafgcw8L0NDOMUme/dCAs3AnyI5aRNbuPEN
 ltcycyehhKaFfHBCXrgQZvyjIhrSnKfiwsa8gSE2nH+3iYgJHtFCFRKJd7wRfn20Hk5i
 UJ3QuD5rjGq3xiEH66Gihb3+v+cuBIsLpnqGhLY8o+fhh9VC4QBZ3uuGXKux9Dm1K5Zy
 8KW41F6svqK1FRr23FWqlWotwkxB/PlAqyBgyulFbXaG5yWM33/6B/Kb5xQPavIlFYnH
 bndDjiABwlo0I/OZYv+hboeaL3Avl8xjpULJReH/Fge77asFIyt+VhTPFEqWPDpLHxhw ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t9brtcmre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 20:45:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QKhVxu063857;
        Wed, 26 Jun 2019 20:45:16 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tat7d1gdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 20:45:16 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5QKjDNY016783;
        Wed, 26 Jun 2019 20:45:13 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 13:45:12 -0700
Subject: [PATCH 12/15] xfs: refactor iwalk code to handle walking inobt
 records
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 26 Jun 2019 13:45:11 -0700
Message-ID: <156158191149.495087.698588357855856352.stgit@magnolia>
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

Refactor xfs_iwalk_ag_start and xfs_iwalk_ag so that the bits that are
particular to bulkstat (trimming the start irec, starting inode
readahead, and skipping empty groups) can be controlled via flags in the
iwag structure.

This enables us to add a new function to walk all inobt records which
will be used for the new INUMBERS implementation in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iwalk.c |  112 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_iwalk.h |   12 ++++++
 2 files changed, 121 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 6d0fb11f84de..0cd4885c8780 100644
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
@@ -171,6 +182,16 @@ xfs_iwalk_ag_recs(
 
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
@@ -280,7 +301,8 @@ xfs_iwalk_ag_start(
 	 * If agino fell in the middle of the inode record, make it look like
 	 * the inodes up to agino are free so that we don't return them again.
 	 */
-	xfs_iwalk_adjust_start(agino, irec);
+	if (iwag->trim_start)
+		xfs_iwalk_adjust_start(agino, irec);
 
 	/*
 	 * The prefetch calculation is supposed to give us a large enough inobt
@@ -373,7 +395,7 @@ xfs_iwalk_ag(
 			break;
 
 		/* No allocated inodes in this chunk; skip it. */
-		if (irec->ir_freecount == irec->ir_count) {
+		if (iwag->skip_empty && irec->ir_freecount == irec->ir_count) {
 			error = xfs_btree_increment(cur, 0, &has_more);
 			if (error)
 				break;
@@ -384,7 +406,8 @@ xfs_iwalk_ag(
 		 * Start readahead for this inode chunk in anticipation of
 		 * walking the inodes.
 		 */
-		xfs_iwalk_ichunk_ra(mp, agno, irec);
+		if (iwag->iwalk_fn)
+			xfs_iwalk_ichunk_ra(mp, agno, irec);
 
 		/*
 		 * If there's space in the buffer for more records, increment
@@ -495,6 +518,89 @@ xfs_iwalk(
 		.data		= data,
 		.startino	= startino,
 		.sz_recs	= xfs_iwalk_prefetch(inode_records),
+		.trim_start	= 1,
+		.skip_empty	= 1,
+	};
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
+	int			error;
+
+	ASSERT(agno < mp->m_sb.sb_agcount);
+
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
+
+/*
+ * Allow callers to cache up to a page's worth of inobt records.  This reflects
+ * the existing inumbers prefetching behavior.  Since the inobt walk does not
+ * itself do anything with the inobt records, we can set a fairly high limit
+ * here.
+ */
+#define MAX_INOBT_WALK_PREFETCH	\
+	(PAGE_SIZE / sizeof(struct xfs_inobt_rec_incore))
+
+/*
+ * Given the number of records that the user wanted, set the number of inobt
+ * records that we buffer in memory.  Set the maximum if @inobt_records == 0.
+ */
+static inline unsigned int
+xfs_inobt_walk_prefetch(
+	unsigned int		inobt_records)
+{
+	/*
+	 * If the caller didn't tell us the number of inobt records they
+	 * wanted, assume the maximum prefetch possible for best performance.
+	 */
+	if (inobt_records == 0)
+		inobt_records = MAX_INOBT_WALK_PREFETCH;
+
+	/*
+	 * Allocate enough space to prefetch at least two inobt records so that
+	 * we can cache both the record where the iwalk started and the next
+	 * record.  This simplifies the AG inode walk loop setup code.
+	 */
+	inobt_records = max(inobt_records, 2U);
+
+	/*
+	 * Cap prefetch at that maximum so that we don't use an absurd amount
+	 * of memory.
+	 */
+	return min_t(unsigned int, inobt_records, MAX_INOBT_WALK_PREFETCH);
+}
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
+	unsigned int		inobt_records,
+	void			*data)
+{
+	struct xfs_iwalk_ag	iwag = {
+		.mp		= mp,
+		.tp		= tp,
+		.inobt_walk_fn	= inobt_walk_fn,
+		.data		= data,
+		.startino	= startino,
+		.sz_recs	= xfs_inobt_walk_prefetch(inobt_records),
 	};
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 7728dfd618a4..94fad060b3e9 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -16,4 +16,16 @@ typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
 		xfs_iwalk_fn iwalk_fn, unsigned int inode_records, void *data);
 
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
+		unsigned int inobt_records, void *data);
+
 #endif /* __XFS_IWALK_H__ */

