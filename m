Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF7A35240
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 23:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfFDVvm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 17:51:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59904 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfFDVvm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:51:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LnWYI053067
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:51:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=BZTZ1beOP+Cco50+8aLuOJ3fB92u2oCcyh+kxVA6aco=;
 b=PzytYtWdYHwI7I19s2wagIJFDU2x86EJb0Lr+4LfJwHwNU4VetYMb5708x/ZpgYgwBXT
 3N1HGLQU2A3rlcqFs0xvB1lv2UMFAOa8sXbURVT1FXoidqIv/aIufBeTx38W1B48dUGv
 nmMgP9yOKqDIS0td5a19wIUnplVqgBCMNuqNPpecp0Mxmb2N5vnkKPN9T1zQwVax41Gs
 RxREDfPFrtzcY5DnqBkU93ywU82AufvNge928g8qIY8hvP/+1saUXkU7s2vG93QKIU1w
 7zTHyo47cVBtBEQAPnPXn0TeNSd8imLWLG4oyhwVG9Glso5h+VhDXkJ1WfuKV6nXbwL4 Pw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2sugstfpeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:51:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LmblL009283
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:49:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2swnhbug2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:49:36 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x54LnZ6B008705
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:49:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 14:49:35 -0700
Subject: [PATCH 01/10] xfs: create simplified inode walk function
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 04 Jun 2019 14:49:34 -0700
Message-ID: <155968497450.1657646.15305138327955918345.stgit@magnolia>
In-Reply-To: <155968496814.1657646.13743491598480818627.stgit@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new iterator function to simplify walking inodes in an XFS
filesystem.  This new iterator will replace the existing open-coded
walking that goes on in various places.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/libxfs/xfs_ialloc_btree.c |   31 +++
 fs/xfs/libxfs/xfs_ialloc_btree.h |    3 
 fs/xfs/xfs_itable.c              |    5 
 fs/xfs/xfs_itable.h              |    8 +
 fs/xfs/xfs_iwalk.c               |  400 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iwalk.h               |   18 ++
 fs/xfs/xfs_trace.h               |   40 ++++
 8 files changed, 502 insertions(+), 4 deletions(-)
 create mode 100644 fs/xfs/xfs_iwalk.c
 create mode 100644 fs/xfs/xfs_iwalk.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 91831975363b..74d30ef0dbce 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -80,6 +80,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_iops.o \
 				   xfs_inode.o \
 				   xfs_itable.o \
+				   xfs_iwalk.o \
 				   xfs_message.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index ac4b65da4c2b..cb7eac2f51c0 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -564,6 +564,34 @@ xfs_inobt_max_size(
 					XFS_INODES_PER_CHUNK);
 }
 
+/* Read AGI and create inobt cursor. */
+int
+xfs_inobt_cur(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	struct xfs_btree_cur	**curpp,
+	struct xfs_buf		**agi_bpp)
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	ASSERT(*agi_bpp == NULL);
+
+	error = xfs_ialloc_read_agi(mp, tp, agno, agi_bpp);
+	if (error)
+		return error;
+
+	cur = xfs_inobt_init_cursor(mp, tp, *agi_bpp, agno, XFS_BTNUM_INO);
+	if (!cur) {
+		xfs_trans_brelse(tp, *agi_bpp);
+		*agi_bpp = NULL;
+		return -ENOMEM;
+	}
+	*curpp = cur;
+	return 0;
+}
+
 static int
 xfs_inobt_count_blocks(
 	struct xfs_mount	*mp,
@@ -576,11 +604,10 @@ xfs_inobt_count_blocks(
 	struct xfs_btree_cur	*cur;
 	int			error;
 
-	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
+	error = xfs_inobt_cur(mp, tp, agno, &cur, &agbp);
 	if (error)
 		return error;
 
-	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
 	error = xfs_btree_count_blocks(cur, tree_blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index ebdd0c6b8766..1bc44b4a2b6c 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -64,5 +64,8 @@ int xfs_finobt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, xfs_extlen_t *ask, xfs_extlen_t *used);
 extern xfs_extlen_t xfs_iallocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
+int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
+		xfs_agnumber_t agno, struct xfs_btree_cur **curpp,
+		struct xfs_buf **agi_bpp);
 
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index eef307cf90a7..3ca1c454afe6 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -19,6 +19,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_health.h"
+#include "xfs_iwalk.h"
 
 /*
  * Return stat information for one inode.
@@ -161,7 +162,7 @@ xfs_bulkstat_one(
  * Loop over all clusters in a chunk for a given incore inode allocation btree
  * record.  Do a readahead if there are any allocated inodes in that cluster.
  */
-STATIC void
+void
 xfs_bulkstat_ichunk_ra(
 	struct xfs_mount		*mp,
 	xfs_agnumber_t			agno,
@@ -195,7 +196,7 @@ xfs_bulkstat_ichunk_ra(
  * are some left allocated, update the data for the pointed-to record as well as
  * return the count of grabbed inodes.
  */
-STATIC int
+int
 xfs_bulkstat_grab_ichunk(
 	struct xfs_btree_cur		*cur,	/* btree cursor */
 	xfs_agino_t			agino,	/* starting inode of chunk */
diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
index 8a822285b671..369e3f159d4e 100644
--- a/fs/xfs/xfs_itable.h
+++ b/fs/xfs/xfs_itable.h
@@ -84,4 +84,12 @@ xfs_inumbers(
 	void			__user *buffer, /* buffer with inode info */
 	inumbers_fmt_pf		formatter);
 
+/* Temporarily needed while we refactor functions. */
+struct xfs_btree_cur;
+struct xfs_inobt_rec_incore;
+void xfs_bulkstat_ichunk_ra(struct xfs_mount *mp, xfs_agnumber_t agno,
+		struct xfs_inobt_rec_incore *irec);
+int xfs_bulkstat_grab_ichunk(struct xfs_btree_cur *cur, xfs_agino_t agino,
+		int *icount, struct xfs_inobt_rec_incore *irec);
+
 #endif	/* __XFS_ITABLE_H__ */
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
new file mode 100644
index 000000000000..3e6c06e69c75
--- /dev/null
+++ b/fs/xfs/xfs_iwalk.c
@@ -0,0 +1,400 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_itable.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_icache.h"
+#include "xfs_health.h"
+#include "xfs_trans.h"
+#include "xfs_iwalk.h"
+
+/*
+ * Walking Inodes in the Filesystem
+ * ================================
+ *
+ * This iterator function walks a subset of filesystem inodes in increasing
+ * order from @startino until there are no more inodes.  For each allocated
+ * inode it finds, it calls a walk function with the relevant inode number and
+ * a pointer to caller-provided data.  The walk function can return the usual
+ * negative error code to stop the iteration; 0 to continue the iteration; or
+ * XFS_IWALK_ABORT to stop the iteration.  This return value is returned to the
+ * caller.
+ *
+ * Internally, we allow the walk function to do anything, which means that we
+ * cannot maintain the inobt cursor or our lock on the AGI buffer.  We
+ * therefore cache the inobt records in kernel memory and only call the walk
+ * function when our memory buffer is full.  @nr_recs is the number of records
+ * that we've cached, and @sz_recs is the size of our cache.
+ *
+ * It is the responsibility of the walk function to ensure it accesses
+ * allocated inodes, as the inobt records may be stale by the time they are
+ * acted upon.
+ */
+
+struct xfs_iwalk_ag {
+	struct xfs_mount		*mp;
+	struct xfs_trans		*tp;
+
+	/* Where do we start the traversal? */
+	xfs_ino_t			startino;
+
+	/* Array of inobt records we cache. */
+	struct xfs_inobt_rec_incore	*recs;
+
+	/* Number of entries allocated for the @recs array. */
+	unsigned int			sz_recs;
+
+	/* Number of entries in the @recs array that are in use. */
+	unsigned int			nr_recs;
+
+	/* Inode walk function and data pointer. */
+	xfs_iwalk_fn			iwalk_fn;
+	void				*data;
+};
+
+/* Allocate memory for a walk. */
+STATIC int
+xfs_iwalk_alloc(
+	struct xfs_iwalk_ag	*iwag)
+{
+	size_t			size;
+
+	ASSERT(iwag->recs == NULL);
+	iwag->nr_recs = 0;
+
+	/* Allocate a prefetch buffer for inobt records. */
+	size = iwag->sz_recs * sizeof(struct xfs_inobt_rec_incore);
+	iwag->recs = kmem_alloc(size, KM_MAYFAIL);
+	if (iwag->recs == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/* Free memory we allocated for a walk. */
+STATIC void
+xfs_iwalk_free(
+	struct xfs_iwalk_ag	*iwag)
+{
+	kmem_free(iwag->recs);
+}
+
+/* For each inuse inode in each cached inobt record, call our function. */
+STATIC int
+xfs_iwalk_ag_recs(
+	struct xfs_iwalk_ag		*iwag)
+{
+	struct xfs_mount		*mp = iwag->mp;
+	struct xfs_trans		*tp = iwag->tp;
+	xfs_ino_t			ino;
+	unsigned int			i, j;
+	xfs_agnumber_t			agno;
+	int				error;
+
+	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
+	for (i = 0; i < iwag->nr_recs; i++) {
+		struct xfs_inobt_rec_incore	*irec = &iwag->recs[i];
+
+		trace_xfs_iwalk_ag_rec(mp, agno, irec);
+
+		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
+			/* Skip if this inode is free */
+			if (XFS_INOBT_MASK(j) & irec->ir_free)
+				continue;
+
+			/* Otherwise call our function. */
+			ino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino + j);
+			error = iwag->iwalk_fn(mp, tp, ino, iwag->data);
+			if (error)
+				return error;
+		}
+	}
+
+	return 0;
+}
+
+/* Delete cursor and let go of AGI. */
+static inline void
+xfs_iwalk_del_inobt(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	**curpp,
+	struct xfs_buf		**agi_bpp,
+	int			error)
+{
+	if (*curpp) {
+		xfs_btree_del_cursor(*curpp, error);
+		*curpp = NULL;
+	}
+	if (*agi_bpp) {
+		xfs_trans_brelse(tp, *agi_bpp);
+		*agi_bpp = NULL;
+	}
+}
+
+/*
+ * Set ourselves up for walking inobt records starting from a given point in
+ * the filesystem.
+ *
+ * If caller passed in a nonzero start inode number, load the record from the
+ * inobt and make the record look like all the inodes before agino are free so
+ * that we skip them, and then move the cursor to the next inobt record.  This
+ * is how we support starting an iwalk in the middle of an inode chunk.
+ *
+ * If the caller passed in a start number of zero, move the cursor to the first
+ * inobt record.
+ *
+ * The caller is responsible for cleaning up the cursor and buffer pointer
+ * regardless of the error status.
+ */
+STATIC int
+xfs_iwalk_ag_start(
+	struct xfs_iwalk_ag	*iwag,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino,
+	struct xfs_btree_cur	**curpp,
+	struct xfs_buf		**agi_bpp,
+	int			*has_more)
+{
+	struct xfs_mount	*mp = iwag->mp;
+	struct xfs_trans	*tp = iwag->tp;
+	int			icount;
+	int			error;
+
+	/* Set up a fresh cursor and empty the inobt cache. */
+	iwag->nr_recs = 0;
+	error = xfs_inobt_cur(mp, tp, agno, curpp, agi_bpp);
+	if (error)
+		return error;
+
+	/* Starting at the beginning of the AG?  That's easy! */
+	if (agino == 0)
+		return xfs_inobt_lookup(*curpp, 0, XFS_LOOKUP_GE, has_more);
+
+	/*
+	 * Otherwise, we have to grab the inobt record where we left off, stuff
+	 * the record into our cache, and then see if there are more records.
+	 * We require a lookup cache of at least two elements so that we don't
+	 * have to deal with tearing down the cursor to walk the records.
+	 */
+	error = xfs_bulkstat_grab_ichunk(*curpp, agino - 1, &icount,
+			&iwag->recs[iwag->nr_recs]);
+	if (error)
+		return error;
+	if (icount)
+		iwag->nr_recs++;
+
+	/*
+	 * set_prefetch is supposed to give us a large enough inobt record
+	 * cache that grab_ichunk can stage a partial first record and the loop
+	 * body can cache a record without having to check for cache space
+	 * until after it reads an inobt record.
+	 */
+	ASSERT(iwag->nr_recs < iwag->sz_recs);
+
+	return xfs_btree_increment(*curpp, 0, has_more);
+}
+
+typedef int (*xfs_iwalk_ag_recs_fn)(struct xfs_iwalk_ag *iwag);
+
+/*
+ * The inobt record cache is full, so preserve the inobt cursor state and
+ * run callbacks on the cached inobt records.  When we're done, restore the
+ * cursor state to wherever the cursor would have been had the cache not been
+ * full (and therefore we could've just incremented the cursor).
+ */
+STATIC int
+xfs_iwalk_run_callbacks(
+	struct xfs_iwalk_ag		*iwag,
+	xfs_iwalk_ag_recs_fn		walk_ag_recs_fn,
+	xfs_agnumber_t			agno,
+	struct xfs_btree_cur		**curpp,
+	struct xfs_buf			**agi_bpp,
+	int				*has_more)
+{
+	struct xfs_mount		*mp = iwag->mp;
+	struct xfs_trans		*tp = iwag->tp;
+	struct xfs_inobt_rec_incore	*irec;
+	xfs_agino_t			restart;
+	int				error;
+
+	ASSERT(iwag->nr_recs == iwag->sz_recs);
+
+	/* Delete cursor but remember the last record we cached... */
+	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
+	irec = &iwag->recs[iwag->nr_recs - 1];
+	restart = irec->ir_startino + XFS_INODES_PER_CHUNK - 1;
+
+	error = walk_ag_recs_fn(iwag);
+	if (error)
+		return error;
+
+	/* ...empty the cache... */
+	iwag->nr_recs = 0;
+
+	/* ...and recreate the cursor just past where we left off. */
+	error = xfs_inobt_cur(mp, tp, agno, curpp, agi_bpp);
+	if (error)
+		return error;
+
+	return xfs_inobt_lookup(*curpp, restart, XFS_LOOKUP_GE, has_more);
+}
+
+/* Walk all inodes in a single AG, from @iwag->startino to the end of the AG. */
+STATIC int
+xfs_iwalk_ag(
+	struct xfs_iwalk_ag		*iwag)
+{
+	struct xfs_mount		*mp = iwag->mp;
+	struct xfs_trans		*tp = iwag->tp;
+	struct xfs_buf			*agi_bp = NULL;
+	struct xfs_btree_cur		*cur = NULL;
+	xfs_agnumber_t			agno;
+	xfs_agino_t			agino;
+	int				has_more;
+	int				error = 0;
+
+	/* Set up our cursor at the right place in the inode btree. */
+	agno = XFS_INO_TO_AGNO(mp, iwag->startino);
+	agino = XFS_INO_TO_AGINO(mp, iwag->startino);
+	error = xfs_iwalk_ag_start(iwag, agno, agino, &cur, &agi_bp, &has_more);
+
+	while (!error && has_more) {
+		struct xfs_inobt_rec_incore	*irec;
+
+		cond_resched();
+
+		/* Fetch the inobt record. */
+		irec = &iwag->recs[iwag->nr_recs];
+		error = xfs_inobt_get_rec(cur, irec, &has_more);
+		if (error || !has_more)
+			break;
+
+		/* No allocated inodes in this chunk; skip it. */
+		if (irec->ir_freecount == irec->ir_count) {
+			error = xfs_btree_increment(cur, 0, &has_more);
+			if (error)
+				break;
+			continue;
+		}
+
+		/*
+		 * Start readahead for this inode chunk in anticipation of
+		 * walking the inodes.
+		 */
+		xfs_bulkstat_ichunk_ra(mp, agno, irec);
+
+		/*
+		 * If there's space in the buffer for more records, increment
+		 * the btree cursor and grab more.
+		 */
+		if (++iwag->nr_recs < iwag->sz_recs) {
+			error = xfs_btree_increment(cur, 0, &has_more);
+			if (error || !has_more)
+				break;
+			continue;
+		}
+
+		/*
+		 * Otherwise, we need to save cursor state and run the callback
+		 * function on the cached records.  The run_callbacks function
+		 * is supposed to return a cursor pointing to the record where
+		 * we would be if we had been able to increment like above.
+		 */
+		error = xfs_iwalk_run_callbacks(iwag, xfs_iwalk_ag_recs, agno,
+				&cur, &agi_bp, &has_more);
+	}
+
+	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
+
+	/* Walk any records left behind in the cache. */
+	if (iwag->nr_recs == 0 || error)
+		return error;
+
+	return xfs_iwalk_ag_recs(iwag);
+}
+
+/*
+ * Given the number of inodes to prefetch, set the number of inobt records that
+ * we cache in memory, which controls the number of inodes we try to read
+ * ahead.
+ *
+ * If no max prefetch was given, default to 4096 bytes' worth of inobt records;
+ * this should be plenty of inodes to read ahead.  This number (256 inobt
+ * records) was chosen so that the cache is never more than a single memory
+ * page.
+ */
+static inline void
+xfs_iwalk_set_prefetch(
+	struct xfs_iwalk_ag	*iwag,
+	unsigned int		max_prefetch)
+{
+	if (max_prefetch)
+		iwag->sz_recs = round_up(max_prefetch, XFS_INODES_PER_CHUNK) /
+					XFS_INODES_PER_CHUNK;
+	else
+		iwag->sz_recs = 4096 / sizeof(struct xfs_inobt_rec_incore);
+
+	/*
+	 * Allocate enough space to prefetch at least two records so that we
+	 * can cache both the inobt record where the iwalk started and the next
+	 * record.  This simplifies the AG inode walk loop setup code.
+	 */
+	iwag->sz_recs = max_t(unsigned int, iwag->sz_recs, 2);
+}
+
+/*
+ * Walk all inodes in the filesystem starting from @startino.  The @iwalk_fn
+ * will be called for each allocated inode, being passed the inode's number and
+ * @data.  @max_prefetch controls how many inobt records' worth of inodes we
+ * try to readahead.
+ */
+int
+xfs_iwalk(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_ino_t		startino,
+	xfs_iwalk_fn		iwalk_fn,
+	unsigned int		max_prefetch,
+	void			*data)
+{
+	struct xfs_iwalk_ag	iwag = {
+		.mp		= mp,
+		.tp		= tp,
+		.iwalk_fn	= iwalk_fn,
+		.data		= data,
+		.startino	= startino,
+	};
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
+	int			error;
+
+	ASSERT(agno < mp->m_sb.sb_agcount);
+
+	xfs_iwalk_set_prefetch(&iwag, max_prefetch);
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
new file mode 100644
index 000000000000..45b1baabcd2d
--- /dev/null
+++ b/fs/xfs/xfs_iwalk.h
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_IWALK_H__
+#define __XFS_IWALK_H__
+
+/* Walk all inodes in the filesystem starting from @startino. */
+typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
+			    xfs_ino_t ino, void *data);
+/* Return value (for xfs_iwalk_fn) that aborts the walk immediately. */
+#define XFS_IWALK_ABORT	(1)
+
+int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
+		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
+
+#endif /* __XFS_IWALK_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2464ea351f83..f9bb1d50bc0e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3516,6 +3516,46 @@ DEFINE_EVENT(xfs_inode_corrupt_class, name,	\
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_sick);
 DEFINE_INODE_CORRUPT_EVENT(xfs_inode_mark_healthy);
 
+TRACE_EVENT(xfs_iwalk_ag,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agino_t startino),
+	TP_ARGS(mp, agno, startino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, startino)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->startino = startino;
+	),
+	TP_printk("dev %d:%d agno %d startino %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
+		  __entry->startino)
+)
+
+TRACE_EVENT(xfs_iwalk_ag_rec,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 struct xfs_inobt_rec_incore *irec),
+	TP_ARGS(mp, agno, irec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agino_t, startino)
+		__field(uint64_t, freemask)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->startino = irec->ir_startino;
+		__entry->freemask = irec->ir_free;
+	),
+	TP_printk("dev %d:%d agno %d startino %u freemask 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
+		  __entry->startino, __entry->freemask)
+)
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

