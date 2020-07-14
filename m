Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D131422003E
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jul 2020 23:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgGNVqg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jul 2020 17:46:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37402 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgGNVqg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jul 2020 17:46:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELc5oK065583;
        Tue, 14 Jul 2020 21:46:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=T/X3K8gjQOAoCpgvxxRjww0paV3dsrnraq1oLWZ31Ww=;
 b=TA1xtzwVsHkUHZrmFRMWDI4DDK1NV12sVrxeKLpuW0fOUI0aCUSFQVvsfS8rUSz6i4xx
 4vp/uAWM148SLOTTVn/nnQMtx9f0dGyd8I8N6DzkVNs3VaicP3ExKYwYV/rYunnjAiD2
 nLlDODR9F8BQb4/XHOqA9Z2579T3XWQm/BYcB2YGEfCQ25b0h1NBMAQF/JlldGf7NpIX
 Or6JLAxIY3fkuTV5J30LfqyKXkTc9iPMTjRfvoPUqBHYukPP9nmy/aSCdTbkxUGWfpsa
 3bmFHD7LKVbilYimZIAjPDrtdDUvdNAT3LU64Dcr/KJdcTVf9P72ZZ7lvpVlhHzf2hd0 ZQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3274ur82u9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 21:46:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ELhaFc051497;
        Tue, 14 Jul 2020 21:46:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 327qb5bd6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 21:46:31 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06ELkTGv023238;
        Tue, 14 Jul 2020 21:46:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jul 2020 14:46:29 -0700
Subject: [PATCH 3/4] xfs_repair: check quota values if quota was loaded
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 14 Jul 2020 14:46:25 -0700
Message-ID: <159476318590.3156699.15126640025600603984.stgit@magnolia>
In-Reply-To: <159476316511.3156699.17998319555266568403.stgit@magnolia>
References: <159476316511.3156699.17998319555266568403.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=2 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9682 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=2 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140148
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the filesystem looks like it had up to date quota information, check
it against what's in the filesystem and report if we find discrepancies.
This closes one of the major gaps in corruptions that are detected by
xfs_check vs. xfs_repair.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_repair.8 |    4 
 repair/Makefile       |    2 
 repair/phase7.c       |   21 ++
 repair/quotacheck.c   |  542 +++++++++++++++++++++++++++++++++++++++++++++++++
 repair/quotacheck.h   |   15 +
 repair/xfs_repair.c   |    6 +
 6 files changed, 586 insertions(+), 4 deletions(-)
 create mode 100644 repair/quotacheck.c
 create mode 100644 repair/quotacheck.h


diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index 75d36e62..cc6a2be8 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -155,6 +155,10 @@ if there are two allocation groups and the two superblocks do not
 agree on the filesystem geometry.  Only use this option if you validated
 the geometry yourself and know what you are doing.  If In doubt run
 in no modify mode first.
+.TP
+.BI noquota
+Don't validate quota counters at all.
+Quotacheck will be run during the next mount to recalculate all values.
 .RE
 .TP
 .B \-t " interval"
diff --git a/repair/Makefile b/repair/Makefile
index e9f93202..5f0764d1 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -26,6 +26,7 @@ HFILES = \
 	prefetch.h \
 	progress.h \
 	protos.h \
+	quotacheck.h \
 	rmap.h \
 	rt.h \
 	scan.h \
@@ -60,6 +61,7 @@ CFILES = \
 	phase7.c \
 	prefetch.c \
 	progress.c \
+	quotacheck.c \
 	rmap.c \
 	rt.c \
 	sb.c \
diff --git a/repair/phase7.c b/repair/phase7.c
index c2996470..47e76b56 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -15,6 +15,7 @@
 #include "versions.h"
 #include "progress.h"
 #include "threads.h"
+#include "quotacheck.h"
 
 static void
 update_inode_nlinks(
@@ -97,6 +98,10 @@ do_link_updates(
 
 	for (irec = findfirst_inode_rec(agno); irec;
 	     irec = next_ino_rec(irec)) {
+		xfs_ino_t	ino;
+
+		ino = XFS_AGINO_TO_INO(mp, agno, irec->ino_startnum);
+
 		for (j = 0; j < XFS_INODES_PER_CHUNK; j++)  {
 			ASSERT(is_inode_confirmed(irec, j));
 
@@ -109,10 +114,8 @@ do_link_updates(
 			ASSERT(no_modify || nrefs > 0);
 
 			if (get_inode_disk_nlinks(irec, j) != nrefs)
-				update_inode_nlinks(wq->wq_ctx,
-					XFS_AGINO_TO_INO(mp, agno,
-						irec->ino_startnum + j),
-					nrefs);
+				update_inode_nlinks(wq->wq_ctx, ino + j, nrefs);
+			quotacheck_adjust(mp, ino + j);
 		}
 	}
 
@@ -126,6 +129,7 @@ phase7(
 {
 	struct workqueue	wq;
 	int			agno;
+	int			ret;
 
 	if (!no_modify)
 		do_log(_("Phase 7 - verify and correct link counts...\n"));
@@ -134,6 +138,9 @@ phase7(
 
 	set_progress_msg(PROGRESS_FMT_CORR_LINK, (uint64_t) glob_agcount);
 
+	ret = quotacheck_setup(mp);
+	if (ret)
+		do_error(_("unable to set up quotacheck, err=%d\n"), ret);
 	create_work_queue(&wq, mp, scan_threads);
 
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
@@ -141,5 +148,11 @@ phase7(
 
 	destroy_work_queue(&wq);
 
+	quotacheck_verify(mp, XFS_DQ_USER);
+	quotacheck_verify(mp, XFS_DQ_GROUP);
+	quotacheck_verify(mp, XFS_DQ_PROJ);
+
+	quotacheck_teardown();
+
 	print_final_rpt();
 }
diff --git a/repair/quotacheck.c b/repair/quotacheck.c
new file mode 100644
index 00000000..481a1289
--- /dev/null
+++ b/repair/quotacheck.c
@@ -0,0 +1,542 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2020 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include <libxfs.h>
+#include "globals.h"
+#include "versions.h"
+#include "err_protos.h"
+#include "libfrog/avl64.h"
+#include "quotacheck.h"
+
+/* Allow the xfs_repair caller to skip quotacheck entirely. */
+static bool noquota;
+
+void quotacheck_skip(void)
+{
+	noquota = true;
+}
+
+/*
+ * XFS_*QUOTA_CHKD flags for all the quota types that we verified.  This field
+ * will be cleared if we encounter any problems (runtime errors, mismatches).
+ */
+static uint16_t chkd_flags;
+
+/* Global incore dquot tree */
+struct qc_dquots {
+	pthread_mutex_t		lock;
+	struct avl64tree_desc	tree;
+
+	/* One of XFS_DQ_{USER,GROUP,PROJ} */
+	uint16_t		type;
+};
+
+#define qc_dquots_foreach(dquots, pos, n) \
+	for (pos = (dquots)->tree.avl_firstino, n = pos ? pos->avl_nextino : NULL; \
+			pos != NULL; \
+			pos = n, n = pos ? pos->avl_nextino : NULL)
+
+static struct qc_dquots *user_dquots;
+static struct qc_dquots *group_dquots;
+static struct qc_dquots *proj_dquots;
+
+/* This record was found in the on-disk dquot information. */
+#define QC_REC_ONDISK		(1U << 31)
+
+struct qc_rec {
+	struct avl64node	node;
+	pthread_mutex_t		lock;
+
+	xfs_dqid_t		id;
+	uint32_t		flags;
+	uint64_t		bcount;
+	uint64_t		rtbcount;
+	uint64_t		icount;
+};
+
+static const char *
+qflags_typestr(
+	unsigned int		type)
+{
+	if (type & XFS_DQ_USER)
+		return _("user quota");
+	else if (type & XFS_DQ_GROUP)
+		return _("group quota");
+	else if (type & XFS_DQ_PROJ)
+		return _("project quota");
+	return NULL;
+}
+
+/* Operations for the avl64 tree. */
+
+static uint64_t
+qc_avl_start(
+	struct avl64node	*node)
+{
+	struct qc_rec		*qrec;
+
+	qrec = container_of(node, struct qc_rec, node);
+	return qrec->id;
+}
+
+static uint64_t
+qc_avl_end(
+	struct avl64node	*node)
+{
+	return qc_avl_start(node) + 1;
+}
+
+static struct avl64ops qc_cache_ops = {
+	.avl_start		= qc_avl_start,
+	.avl_end		= qc_avl_end,
+};
+
+/* Find a qc_rec in the incore cache, or allocate one if need be. */
+static struct qc_rec *
+qc_rec_get(
+	struct qc_dquots	*dquots,
+	xfs_dqid_t		id,
+	bool			can_alloc)
+{
+	struct qc_rec		*qrec;
+	struct avl64node	*node;
+
+	pthread_mutex_lock(&dquots->lock);
+	node = avl64_find(&dquots->tree, id);
+	if (!node && can_alloc) {
+		qrec = calloc(sizeof(struct qc_rec), 1);
+		if (qrec) {
+			qrec->id = id;
+			node = avl64_insert(&dquots->tree, &qrec->node);
+			if (!node)
+				free(qrec);
+			else
+				pthread_mutex_init(&qrec->lock, NULL);
+		}
+	}
+	pthread_mutex_unlock(&dquots->lock);
+
+	return node ? container_of(node, struct qc_rec, node) : NULL;
+}
+
+/* Bump up an incore dquot's counters. */
+static void
+qc_adjust(
+	struct qc_dquots	*dquots,
+	xfs_dqid_t		id,
+	uint64_t		bcount,
+	uint64_t		rtbcount)
+{
+	struct qc_rec		*qrec = qc_rec_get(dquots, id, true);
+
+	if (!qrec) {
+		do_warn(_("Ran out of memory while running quotacheck!\n"));
+		chkd_flags = 0;
+		return;
+	}
+
+	pthread_mutex_lock(&qrec->lock);
+	qrec->bcount += bcount;
+	qrec->rtbcount += rtbcount;
+	qrec->icount++;
+	pthread_mutex_unlock(&qrec->lock);
+}
+
+/* Count the realtime blocks allocated to a file. */
+static xfs_filblks_t
+qc_count_rtblocks(
+	struct xfs_inode	*ip)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	xfs_filblks_t		count = 0;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	int			error;
+
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = -libxfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+		if (error) {
+			do_warn(
+_("could not read ino %"PRIu64" extents, err=%d\n"),
+				ip->i_ino, error);
+			chkd_flags = 0;
+			return 0;
+		}
+	}
+
+	for_each_xfs_iext(ifp, &icur, &got)
+		if (!isnullstartblock(got.br_startblock))
+			count += got.br_blockcount;
+	return count;
+}
+
+/* Add this inode's information to the quota counts. */
+void
+quotacheck_adjust(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	struct xfs_inode	*ip;
+	uint64_t		blocks;
+	uint64_t		rtblks = 0;
+	int			error;
+
+	/*
+	 * If the fs doesn't have any quota files to check against, skip this
+	 * step.
+	 */
+	if (!user_dquots && !group_dquots && !proj_dquots)
+		return;
+
+	/* Skip if a previous quotacheck adjustment failed. */
+	if (chkd_flags == 0)
+		return;
+
+	/* Quota files are not included in quota counts. */
+	if (ino == mp->m_sb.sb_uquotino ||
+	    ino == mp->m_sb.sb_gquotino ||
+	    ino == mp->m_sb.sb_pquotino)
+		return;
+
+	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &xfs_default_ifork_ops);
+	if (error) {
+		do_warn(
+	_("could not open file %"PRIu64" for quotacheck, err=%d\n"),
+				ino, error);
+		chkd_flags = 0;
+		return;
+	}
+
+	/* Count the file's blocks. */
+	if (XFS_IS_REALTIME_INODE(ip))
+		rtblks = qc_count_rtblocks(ip);
+	blocks = ip->i_d.di_nblocks - rtblks;
+
+	if (user_dquots)
+		qc_adjust(user_dquots, i_uid_read(VFS_I(ip)), blocks, rtblks);
+	if (group_dquots)
+		qc_adjust(group_dquots, i_gid_read(VFS_I(ip)), blocks, rtblks);
+	if (proj_dquots)
+		qc_adjust(proj_dquots, ip->i_d.di_projid, blocks, rtblks);
+
+	libxfs_irele(ip);
+}
+
+/* Compare this on-disk dquot against whatever we observed. */
+static void
+qc_check_dquot(
+	struct xfs_disk_dquot	*ddq,
+	struct qc_dquots	*dquots)
+{
+	struct qc_rec		*qrec;
+	struct qc_rec		empty = {
+		.bcount		= 0,
+		.rtbcount	= 0,
+		.icount		= 0,
+	};
+	xfs_dqid_t		id = be32_to_cpu(ddq->d_id);
+
+	qrec = qc_rec_get(dquots, id, false);
+	if (!qrec)
+		qrec = &empty;
+
+	if (be64_to_cpu(ddq->d_bcount) != qrec->bcount) {
+		do_warn(_("%s id %u has bcount %llu, expected %"PRIu64"\n"),
+				qflags_typestr(dquots->type), id,
+				be64_to_cpu(ddq->d_bcount), qrec->bcount);
+		chkd_flags = 0;
+	}
+
+	if (be64_to_cpu(ddq->d_rtbcount) != qrec->rtbcount) {
+		do_warn(_("%s id %u has rtbcount %llu, expected %"PRIu64"\n"),
+				qflags_typestr(dquots->type), id,
+				be64_to_cpu(ddq->d_rtbcount), qrec->rtbcount);
+		chkd_flags = 0;
+	}
+
+	if (be64_to_cpu(ddq->d_icount) != qrec->icount) {
+		do_warn(_("%s id %u has icount %llu, expected %"PRIu64"\n"),
+				qflags_typestr(dquots->type), id,
+				be64_to_cpu(ddq->d_icount), qrec->icount);
+		chkd_flags = 0;
+	}
+
+	/*
+	 * Mark that we found the record on disk.  Skip locking here because
+	 * we're checking the dquots serially.
+	 */
+	qrec->flags |= QC_REC_ONDISK;
+}
+
+/* Walk every dquot in every block in this quota inode extent and compare. */
+static int
+qc_walk_dquot_extent(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*map,
+	struct qc_dquots	*dquots)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_buf		*bp;
+	struct xfs_dqblk	*dqb;
+	xfs_filblks_t		dqchunklen;
+	xfs_filblks_t		bno;
+	unsigned int		dqperchunk;
+	int			error = 0;
+
+	dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
+	dqperchunk = libxfs_calc_dquots_per_chunk(dqchunklen);
+
+	for (bno = 0;
+	     bno < map->br_blockcount;
+	     bno += XFS_DQUOT_CLUSTER_SIZE_FSB) {
+		unsigned int	dqnr;
+		uint64_t	dqid;
+
+		error = -libxfs_buf_read(mp->m_dev,
+				XFS_FSB_TO_DADDR(mp, map->br_startblock + bno),
+				dqchunklen, 0, &bp, &xfs_dquot_buf_ops);
+		if (error) {
+			do_warn(
+_("cannot read %s inode %"PRIu64", block %"PRIu64", disk block %"PRIu64", err=%d\n"),
+				qflags_typestr(dquots->type), ip->i_ino,
+				map->br_startoff + bno,
+				map->br_startblock + bno, error);
+			chkd_flags = 0;
+			return error;
+		}
+
+		dqb = bp->b_addr;
+		dqid = map->br_startoff * dqperchunk;
+		for (dqnr = 0;
+		     dqnr < dqperchunk && dqid <= UINT_MAX;
+		     dqnr++, dqb++, dqid++)
+			qc_check_dquot(&dqb->dd_diskdq, dquots);
+		libxfs_buf_relse(bp);
+	}
+
+	return error;
+}
+
+/* Check the incore quota counts with what's on disk. */
+void
+quotacheck_verify(
+	struct xfs_mount	*mp,
+	unsigned int		type)
+{
+	struct xfs_bmbt_irec	map;
+	struct xfs_iext_cursor	icur;
+	struct xfs_inode	*ip;
+	struct xfs_ifork	*ifp;
+	struct qc_dquots	*dquots = NULL;
+	struct avl64node	*node, *n;
+	xfs_ino_t		ino = NULLFSINO;
+	int			error;
+
+	switch (type) {
+	case XFS_DQ_USER:
+		ino = mp->m_sb.sb_uquotino;
+		dquots = user_dquots;
+		break;
+	case XFS_DQ_GROUP:
+		ino = mp->m_sb.sb_gquotino;
+		dquots = group_dquots;
+		break;
+	case XFS_DQ_PROJ:
+		ino = mp->m_sb.sb_pquotino;
+		dquots = proj_dquots;
+		break;
+	}
+
+	/*
+	 * If we decided not to build incore records or there were errors in
+	 * collecting them that caused us to clear chkd_flags, bail out early.
+	 * No sense in complaining more about garbage.
+	 */
+	if (!dquots || !chkd_flags)
+		return;
+
+	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &xfs_default_ifork_ops);
+	if (error) {
+		do_warn(
+	_("could not open %s inode %"PRIu64" for quotacheck, err=%d\n"),
+			qflags_typestr(type), ino, error);
+		chkd_flags = 0;
+		return;
+	}
+
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = -libxfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+		if (error) {
+			do_warn(
+	_("could not read %s inode %"PRIu64" extents, err=%d\n"),
+				qflags_typestr(type), ip->i_ino, error);
+			chkd_flags = 0;
+			goto err;
+		}
+	}
+
+	/* Walk each extent of the quota inode and compare counters. */
+	for_each_xfs_iext(ifp, &icur, &map) {
+		if (map.br_startblock != HOLESTARTBLOCK) {
+			error = qc_walk_dquot_extent(ip, &map, dquots);
+			if (error)
+				goto err;
+		}
+	}
+
+	/*
+	 * We constructed incore dquots to account for every file we saw on
+	 * disk, and then walked all on-disk dquots to compare.  Complain about
+	 * incore dquots that weren't touched during the comparison, because
+	 * that means something is missing from the dquot file.
+	 */
+	qc_dquots_foreach(dquots, node, n) {
+		struct qc_rec	*qrec;
+
+		qrec = container_of(node, struct qc_rec, node);
+		if (!(qrec->flags & QC_REC_ONDISK)) {
+			do_warn(
+_("%s record for id %u not found on disk (bcount %"PRIu64" rtbcount %"PRIu64" icount %"PRIu64")\n"),
+				qflags_typestr(type), qrec->id,
+				qrec->bcount, qrec->rtbcount, qrec->icount);
+			chkd_flags = 0;
+		}
+	}
+err:
+	libxfs_irele(ip);
+}
+
+/*
+ * Decide if we want to run quotacheck on a particular quota type.  Returns
+ * true only if the inode isn't lost, the fs says quotacheck ran, and the
+ * ondisk pointer to the quota inode isn't "unset" (e.g. NULL or zero).
+ */
+static inline bool
+qc_has_quotafile(
+	struct xfs_mount	*mp,
+	unsigned int		type)
+{
+	bool			lost;
+	xfs_ino_t		ino;
+	unsigned int		qflag;
+
+	switch (type) {
+	case XFS_DQ_USER:
+		lost = lost_uquotino;
+		ino = mp->m_sb.sb_uquotino;
+		qflag = XFS_UQUOTA_CHKD;
+		break;
+	case XFS_DQ_GROUP:
+		lost = lost_gquotino;
+		ino = mp->m_sb.sb_gquotino;
+		qflag = XFS_GQUOTA_CHKD;
+		break;
+	case XFS_DQ_PROJ:
+		lost = lost_pquotino;
+		ino = mp->m_sb.sb_pquotino;
+		qflag = XFS_PQUOTA_CHKD;
+		break;
+	default:
+		return false;
+	}
+
+	if (lost)
+		return false;
+	if (!(mp->m_sb.sb_qflags & qflag))
+		return false;
+	if (ino == NULLFSINO || ino == 0)
+		return false;
+	return true;
+}
+
+/* Initialize an incore dquot tree. */
+static struct qc_dquots *
+qc_dquots_init(
+	uint16_t		type)
+{
+	struct qc_dquots	*dquots;
+
+	dquots = calloc(1, sizeof(struct qc_dquots));
+	if (!dquots)
+		return NULL;
+
+	dquots->type = type;
+	pthread_mutex_init(&dquots->lock, NULL);
+	avl64_init_tree(&dquots->tree, &qc_cache_ops);
+	return dquots;
+}
+
+/* Set up incore context for quota checks. */
+int
+quotacheck_setup(
+	struct xfs_mount	*mp)
+{
+	chkd_flags = 0;
+
+	/*
+	 * If the superblock said quotas are disabled or was missing pointers
+	 * to any quota inodes, don't bother checking.
+	 */
+	if (!fs_quotas || lost_quotas || noquota)
+		return 0;
+
+	if (qc_has_quotafile(mp, XFS_DQ_USER)) {
+		user_dquots = qc_dquots_init(XFS_DQ_USER);
+		if (!user_dquots)
+			goto err;
+		chkd_flags |= XFS_UQUOTA_CHKD;
+	}
+
+	if (qc_has_quotafile(mp, XFS_DQ_GROUP)) {
+		group_dquots = qc_dquots_init(XFS_DQ_GROUP);
+		if (!group_dquots)
+			goto err;
+		chkd_flags |= XFS_GQUOTA_CHKD;
+	}
+
+	if (qc_has_quotafile(mp, XFS_DQ_PROJ)) {
+		proj_dquots = qc_dquots_init(XFS_DQ_PROJ);
+		if (!proj_dquots)
+			goto err;
+		chkd_flags |= XFS_PQUOTA_CHKD;
+	}
+
+	return 0;
+err:
+	chkd_flags = 0;
+	quotacheck_teardown();
+	return ENOMEM;
+}
+
+/* Purge all quotacheck records in a given cache. */
+static void
+qc_purge(
+	struct qc_dquots	**dquotsp)
+{
+	struct qc_dquots	*dquots = *dquotsp;
+	struct qc_rec		*qrec;
+	struct avl64node	*node;
+	struct avl64node	*n;
+
+	if (!dquots)
+		return;
+
+	qc_dquots_foreach(dquots, node, n) {
+		qrec = container_of(node, struct qc_rec, node);
+		free(qrec);
+	}
+	free(dquots);
+	*dquotsp = NULL;
+}
+
+/* Tear down all the incore context from quotacheck. */
+void
+quotacheck_teardown(void)
+{
+	qc_purge(&user_dquots);
+	qc_purge(&group_dquots);
+	qc_purge(&proj_dquots);
+}
diff --git a/repair/quotacheck.h b/repair/quotacheck.h
new file mode 100644
index 00000000..08e11d17
--- /dev/null
+++ b/repair/quotacheck.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2020 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_REPAIR_QUOTACHECK_H__
+#define __XFS_REPAIR_QUOTACHECK_H__
+
+void quotacheck_skip(void);
+void quotacheck_adjust(struct xfs_mount *mp, xfs_ino_t ino);
+void quotacheck_verify(struct xfs_mount *mp, unsigned int type);
+int quotacheck_setup(struct xfs_mount *mp);
+void quotacheck_teardown(void);
+
+#endif /* __XFS_REPAIR_QUOTACHECK_H__ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 1a51abd1..a787da4c 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -25,6 +25,7 @@
 #include "libfrog/fsgeom.h"
 #include "libfrog/platform.h"
 #include "bulkload.h"
+#include "quotacheck.h"
 
 /*
  * option tables for getsubopt calls
@@ -42,6 +43,7 @@ enum o_opt_nums {
 	PHASE2_THREADS,
 	BLOAD_LEAF_SLACK,
 	BLOAD_NODE_SLACK,
+	NOQUOTA,
 	O_MAX_OPTS,
 };
 
@@ -54,6 +56,7 @@ static char *o_opts[] = {
 	[PHASE2_THREADS]	= "phase2_threads",
 	[BLOAD_LEAF_SLACK]	= "debug_bload_leaf_slack",
 	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
+	[NOQUOTA]		= "noquota",
 	[O_MAX_OPTS]		= NULL,
 };
 
@@ -277,6 +280,9 @@ process_args(int argc, char **argv)
 		_("-o debug_bload_node_slack requires a parameter\n"));
 					bload_node_slack = (int)strtol(val, NULL, 0);
 					break;
+				case NOQUOTA:
+					quotacheck_skip();
+					break;
 				default:
 					unknown('o', val);
 					break;

