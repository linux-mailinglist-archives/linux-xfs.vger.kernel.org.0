Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F671EB490
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jun 2020 06:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgFBE3j (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 Jun 2020 00:29:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49290 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgFBE3j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:29:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524Hwgb106540;
        Tue, 2 Jun 2020 04:29:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=926LhRMiwSry7O18qz6kjUlixpGvsarenW7NymtNEWg=;
 b=t1BtW0SCdVF32sRo7BxaTnvaIHw0MXXn8TL9EOoqS6YwcU75ivjL8bEsdSiqCouRjTQ5
 SYVgBd9Ggm3X9qS5K09KYPBrGTawxNVtXZMNYr2VkJl/uV/tlbBvu+PH9R1KLXSCCWw5
 tZkExsCwk9POtEAJIgFKKamEK/x5SmCT1Nj1hsii8ntwbsnStNNCQauOpRKGAo3e+wRq
 68VKvZMPG1ivEhjeh/9bMk2oTw3/Q8pqMAAzrABtWjryfaq6CZrOJ9cvOqnjsOhYoZvF
 20kPvVqscZlZRJlJOta9BuzT1nDRENeWQXSuC4v+Qwp71F2PKoE9wlXrgKlf3j3sqKGn gw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31bewqswqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:29:34 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524JDRh091167;
        Tue, 2 Jun 2020 04:27:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31c1dwgfjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:27:34 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0524RXjI021893;
        Tue, 2 Jun 2020 04:27:33 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:27:32 -0700
Subject: [PATCH 06/12] xfs_repair: create a new class of btree rebuild cursors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 01 Jun 2020 21:27:31 -0700
Message-ID: <159107205193.315004.2458726856192120217.stgit@magnolia>
In-Reply-To: <159107201290.315004.4447998785149331259.stgit@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=2 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=2 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create some new support structures and functions to assist phase5 in
using the btree bulk loader to reconstruct metadata btrees.  This is the
first step in removing the open-coded AG btree rebuilding code.

Note: The code in this patch will not be used anywhere until the next
patch, so warnings about unused symbols are expected.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/Makefile   |    4 +
 repair/agbtree.c  |  152 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/agbtree.h  |   29 ++++++++++
 repair/bulkload.c |   37 +++++++++++++
 repair/bulkload.h |    2 +
 repair/phase5.c   |   41 ++++++++------
 6 files changed, 244 insertions(+), 21 deletions(-)
 create mode 100644 repair/agbtree.c
 create mode 100644 repair/agbtree.h


diff --git a/repair/Makefile b/repair/Makefile
index 62d84bbf..f6a6e3f9 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -9,11 +9,11 @@ LSRCFILES = README
 
 LTCOMMAND = xfs_repair
 
-HFILES = agheader.h attr_repair.h avl.h bulkload.h bmap.h btree.h \
+HFILES = agheader.h agbtree.h attr_repair.h avl.h bulkload.h bmap.h btree.h \
 	da_util.h dinode.h dir2.h err_protos.h globals.h incore.h protos.h \
 	rt.h progress.h scan.h versions.h prefetch.h rmap.h slab.h threads.h
 
-CFILES = agheader.c attr_repair.c avl.c bulkload.c bmap.c btree.c \
+CFILES = agheader.c agbtree.c attr_repair.c avl.c bulkload.c bmap.c btree.c \
 	da_util.c dino_chunks.c dinode.c dir2.c globals.c incore.c \
 	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
 	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
diff --git a/repair/agbtree.c b/repair/agbtree.c
new file mode 100644
index 00000000..e4179a44
--- /dev/null
+++ b/repair/agbtree.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2020 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include <libxfs.h>
+#include "err_protos.h"
+#include "slab.h"
+#include "rmap.h"
+#include "incore.h"
+#include "bulkload.h"
+#include "agbtree.h"
+
+/* Initialize a btree rebuild context. */
+static void
+init_rebuild(
+	struct repair_ctx		*sc,
+	const struct xfs_owner_info	*oinfo,
+	xfs_agblock_t			free_space,
+	struct bt_rebuild		*btr)
+{
+	memset(btr, 0, sizeof(struct bt_rebuild));
+
+	bulkload_init_ag(&btr->newbt, sc, oinfo);
+	bulkload_estimate_ag_slack(sc, &btr->bload, free_space);
+}
+
+/*
+ * Update this free space record to reflect the blocks we stole from the
+ * beginning of the record.
+ */
+static void
+consume_freespace(
+	xfs_agnumber_t		agno,
+	struct extent_tree_node	*ext_ptr,
+	uint32_t		len)
+{
+	struct extent_tree_node	*bno_ext_ptr;
+	xfs_agblock_t		new_start = ext_ptr->ex_startblock + len;
+	xfs_extlen_t		new_len = ext_ptr->ex_blockcount - len;
+
+	/* Delete the used-up extent from both extent trees. */
+#ifdef XR_BLD_FREE_TRACE
+	fprintf(stderr, "releasing extent: %u [%u %u]\n", agno,
+			ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
+#endif
+	bno_ext_ptr = find_bno_extent(agno, ext_ptr->ex_startblock);
+	ASSERT(bno_ext_ptr != NULL);
+	get_bno_extent(agno, bno_ext_ptr);
+	release_extent_tree_node(bno_ext_ptr);
+
+	ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
+			ext_ptr->ex_blockcount);
+	release_extent_tree_node(ext_ptr);
+
+	/*
+	 * If we only used part of this last extent, then we must reinsert the
+	 * extent to maintain proper sorting order.
+	 */
+	if (new_len > 0) {
+		add_bno_extent(agno, new_start, new_len);
+		add_bcnt_extent(agno, new_start, new_len);
+	}
+}
+
+/* Reserve blocks for the new btree. */
+static void
+reserve_btblocks(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr,
+	uint32_t		nr_blocks)
+{
+	struct extent_tree_node	*ext_ptr;
+	uint32_t		blocks_allocated = 0;
+	uint32_t		len;
+	int			error;
+
+	while (blocks_allocated < nr_blocks)  {
+		xfs_fsblock_t	fsbno;
+
+		/*
+		 * Grab the smallest extent and use it up, then get the
+		 * next smallest.  This mimics the init_*_cursor code.
+		 */
+		ext_ptr = findfirst_bcnt_extent(agno);
+		if (!ext_ptr)
+			do_error(
+_("error - not enough free space in filesystem\n"));
+
+		/* Use up the extent we've got. */
+		len = min(ext_ptr->ex_blockcount, nr_blocks - blocks_allocated);
+		fsbno = XFS_AGB_TO_FSB(mp, agno, ext_ptr->ex_startblock);
+		error = bulkload_add_blocks(&btr->newbt, fsbno, len);
+		if (error)
+			do_error(_("could not set up btree reservation: %s\n"),
+				strerror(-error));
+
+		error = rmap_add_ag_rec(mp, agno, ext_ptr->ex_startblock, len,
+				btr->newbt.oinfo.oi_owner);
+		if (error)
+			do_error(_("could not set up btree rmaps: %s\n"),
+				strerror(-error));
+
+		consume_freespace(agno, ext_ptr, len);
+		blocks_allocated += len;
+	}
+#ifdef XR_BLD_FREE_TRACE
+	fprintf(stderr, "blocks_allocated = %d\n",
+		blocks_allocated);
+#endif
+}
+
+/* Feed one of the new btree blocks to the bulk loader. */
+static int
+rebuild_claim_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct bt_rebuild	*btr = priv;
+
+	return bulkload_claim_block(cur, &btr->newbt, ptr);
+}
+
+/*
+ * Scoop up leftovers from a rebuild cursor for later freeing, then free the
+ * rebuild context.
+ */
+void
+finish_rebuild(
+	struct xfs_mount	*mp,
+	struct bt_rebuild	*btr,
+	struct xfs_slab		*lost_fsb)
+{
+	struct bulkload_resv	*resv, *n;
+
+	for_each_bulkload_reservation(&btr->newbt, resv, n) {
+		while (resv->used < resv->len) {
+			xfs_fsblock_t	fsb = resv->fsbno + resv->used;
+			int		error;
+
+			error = slab_add(lost_fsb, &fsb);
+			if (error)
+				do_error(
+_("Insufficient memory saving lost blocks.\n"));
+			resv->used++;
+		}
+	}
+
+	bulkload_destroy(&btr->newbt, 0);
+}
diff --git a/repair/agbtree.h b/repair/agbtree.h
new file mode 100644
index 00000000..50ea3c60
--- /dev/null
+++ b/repair/agbtree.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2020 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_REPAIR_AG_BTREE_H__
+#define __XFS_REPAIR_AG_BTREE_H__
+
+/* Context for rebuilding a per-AG btree. */
+struct bt_rebuild {
+	/* Fake root for staging and space preallocations. */
+	struct bulkload	newbt;
+
+	/* Geometry of the new btree. */
+	struct xfs_btree_bload	bload;
+
+	/* Staging btree cursor for the new tree. */
+	struct xfs_btree_cur	*cur;
+
+	/* Tree-specific data. */
+	union {
+		struct xfs_slab_cursor	*slab_cursor;
+	};
+};
+
+void finish_rebuild(struct xfs_mount *mp, struct bt_rebuild *btr,
+		struct xfs_slab *lost_fsb);
+
+#endif /* __XFS_REPAIR_AG_BTREE_H__ */
diff --git a/repair/bulkload.c b/repair/bulkload.c
index 4c69fe0d..9a6ca0c2 100644
--- a/repair/bulkload.c
+++ b/repair/bulkload.c
@@ -95,3 +95,40 @@ bulkload_claim_block(
 		ptr->s = cpu_to_be32(XFS_FSB_TO_AGBNO(cur->bc_mp, fsb));
 	return 0;
 }
+
+/*
+ * Estimate proper slack values for a btree that's being reloaded.
+ *
+ * Under most circumstances, we'll take whatever default loading value the
+ * btree bulk loading code calculates for us.  However, there are some
+ * exceptions to this rule:
+ *
+ * (1) If someone turned one of the debug knobs.
+ * (2) The AG has less than ~9% space free.
+ *
+ * Note that we actually use 3/32 for the comparison to avoid division.
+ */
+void
+bulkload_estimate_ag_slack(
+	struct repair_ctx	*sc,
+	struct xfs_btree_bload	*bload,
+	unsigned int		free)
+{
+	/*
+	 * The global values are set to -1 (i.e. take the bload defaults)
+	 * unless someone has set them otherwise, so we just pull the values
+	 * here.
+	 */
+	bload->leaf_slack = bload_leaf_slack;
+	bload->node_slack = bload_node_slack;
+
+	/* No further changes if there's more than 3/32ths space left. */
+	if (free >= ((sc->mp->m_sb.sb_agblocks * 3) >> 5))
+		return;
+
+	/* We're low on space; load the btrees as tightly as possible. */
+	if (bload->leaf_slack < 0)
+		bload->leaf_slack = 0;
+	if (bload->node_slack < 0)
+		bload->node_slack = 0;
+}
diff --git a/repair/bulkload.h b/repair/bulkload.h
index 79f81cb0..01f67279 100644
--- a/repair/bulkload.h
+++ b/repair/bulkload.h
@@ -53,5 +53,7 @@ int bulkload_add_blocks(struct bulkload *bkl, xfs_fsblock_t fsbno,
 void bulkload_destroy(struct bulkload *bkl, int error);
 int bulkload_claim_block(struct xfs_btree_cur *cur, struct bulkload *bkl,
 		union xfs_btree_ptr *ptr);
+void bulkload_estimate_ag_slack(struct repair_ctx *sc,
+		struct xfs_btree_bload *bload, unsigned int free);
 
 #endif /* __XFS_REPAIR_BULKLOAD_H__ */
diff --git a/repair/phase5.c b/repair/phase5.c
index 75c480fd..8175aa6f 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -18,6 +18,8 @@
 #include "progress.h"
 #include "slab.h"
 #include "rmap.h"
+#include "bulkload.h"
+#include "agbtree.h"
 
 /*
  * we maintain the current slice (path from root to leaf)
@@ -2288,28 +2290,29 @@ keep_fsinos(xfs_mount_t *mp)
 
 static void
 phase5_func(
-	xfs_mount_t	*mp,
-	xfs_agnumber_t	agno,
-	struct xfs_slab	*lost_fsb)
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct xfs_slab		*lost_fsb)
 {
-	uint64_t	num_inos;
-	uint64_t	num_free_inos;
-	uint64_t	finobt_num_inos;
-	uint64_t	finobt_num_free_inos;
-	bt_status_t	bno_btree_curs;
-	bt_status_t	bcnt_btree_curs;
-	bt_status_t	ino_btree_curs;
-	bt_status_t	fino_btree_curs;
-	bt_status_t	rmap_btree_curs;
-	bt_status_t	refcnt_btree_curs;
-	int		extra_blocks = 0;
-	uint		num_freeblocks;
-	xfs_extlen_t	freeblks1;
+	struct repair_ctx	sc = { .mp = mp, };
+	struct agi_stat		agi_stat = {0,};
+	uint64_t		num_inos;
+	uint64_t		num_free_inos;
+	uint64_t		finobt_num_inos;
+	uint64_t		finobt_num_free_inos;
+	bt_status_t		bno_btree_curs;
+	bt_status_t		bcnt_btree_curs;
+	bt_status_t		ino_btree_curs;
+	bt_status_t		fino_btree_curs;
+	bt_status_t		rmap_btree_curs;
+	bt_status_t		refcnt_btree_curs;
+	int			extra_blocks = 0;
+	uint			num_freeblocks;
+	xfs_extlen_t		freeblks1;
 #ifdef DEBUG
-	xfs_extlen_t	freeblks2;
+	xfs_extlen_t		freeblks2;
 #endif
-	xfs_agblock_t	num_extents;
-	struct agi_stat	agi_stat = {0,};
+	xfs_agblock_t		num_extents;
 
 	if (verbose)
 		do_log(_("        - agno = %d\n"), agno);

