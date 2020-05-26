Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB74A1CC2B7
	for <lists+linux-xfs@lfdr.de>; Sat,  9 May 2020 18:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgEIQcJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 9 May 2020 12:32:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50392 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbgEIQcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 12:32:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GMg9O072311;
        Sat, 9 May 2020 16:32:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=wm/P4ICwh4G93SZWpQI+IO0pRk6NT+Qa6sUuSgfpIeU=;
 b=yoEwrahnTsEZz0s+qeF3vKh+TfpPAAaJfIJFnbT8rZ1FZ9GPeN6I5hlMs45Lxv1lyzs0
 IUw2FZQd5S/C/sHbOkFtIBRKluczO/BlERLwDKJyESnqY4k4+1kSElpuyVk6QKiM5K/V
 oY+19z5gR6Veg0/mfszpblQzMN+krdiM+9GDkwkv+jtPtwL/xvNKKlV79Sm9lefTcYLS
 9Sshd792KaCrAqP27iKtePI0tQEmRZ6qUJhCd/DUxfW6+Jppsw4s9NoM/DslE7WcfD0B
 VKOalJXhjmb3oNUCB1SPzf2GQEZZjeDM4Nhn2ite0l0YrXe7rsz7+V7Ru9ynnCTG3Jih CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30wkxqs6gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 049GRb3O132458;
        Sat, 9 May 2020 16:32:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30wwxb5jd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 16:32:03 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 049GW2ZQ020923;
        Sat, 9 May 2020 16:32:02 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 May 2020 09:32:01 -0700
Subject: [PATCH 3/9] xfs_repair: create a new class of btree rebuild cursors
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Sat, 09 May 2020 09:31:59 -0700
Message-ID: <158904191982.984305.12997847094211521747.stgit@magnolia>
In-Reply-To: <158904190079.984305.707785748675261111.stgit@magnolia>
References: <158904190079.984305.707785748675261111.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=2 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9616 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 suspectscore=2 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005090139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create some new support structures and functions to assist phase5 in
using the btree bulk loader to reconstruct metadata btrees.  This is the
first step in removing the open-coded rebuilding code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |  240 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 219 insertions(+), 21 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index f3be15de..7eb24519 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -18,6 +18,7 @@
 #include "progress.h"
 #include "slab.h"
 #include "rmap.h"
+#include "bload.h"
 
 /*
  * we maintain the current slice (path from root to leaf)
@@ -65,6 +66,23 @@ typedef struct bt_status  {
 	uint64_t		owner;		/* owner */
 } bt_status_t;
 
+/* Context for rebuilding a per-AG btree. */
+struct bt_rebuild {
+	/* Fake root for staging and space preallocations. */
+	struct xrep_newbt	newbt;
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
 /*
  * extra metadata for the agi
  */
@@ -306,6 +324,157 @@ _("error - not enough free space in filesystem\n"));
 #endif
 }
 
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
+static void
+estimate_ag_bload_slack(
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
+	xrep_newbt_init_bare(&btr->newbt, sc);
+	btr->newbt.oinfo = *oinfo; /* struct copy */
+	estimate_ag_bload_slack(sc, &btr->bload, free_space);
+}
+
+/* Reserve blocks for the new btree. */
+static void
+setup_rebuild(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr,
+	uint32_t		nr_blocks)
+{
+	struct extent_tree_node	*ext_ptr;
+	struct extent_tree_node	*bno_ext_ptr;
+	uint32_t		blocks_allocated = 0;
+	int			error;
+
+	/*
+	 * grab the smallest extent and use it up, then get the
+	 * next smallest.  This mimics the init_*_cursor code.
+	 */
+	ext_ptr =  findfirst_bcnt_extent(agno);
+
+	/*
+	 * set up the free block array
+	 */
+	while (blocks_allocated < nr_blocks)  {
+		uint64_t	len;
+		xfs_agblock_t	new_start;
+		xfs_extlen_t	new_len;
+
+		if (!ext_ptr)
+			do_error(
+_("error - not enough free space in filesystem\n"));
+
+		/* Use up the extent we've got. */
+		len = min(ext_ptr->ex_blockcount,
+				btr->bload.nr_blocks - blocks_allocated);
+		error = xrep_newbt_add_reservation(&btr->newbt,
+				XFS_AGB_TO_FSB(mp, agno,
+					       ext_ptr->ex_startblock),
+				len, NULL);
+		if (error)
+			do_error(_("could not set up btree reservation: %s\n"),
+				strerror(-error));
+		blocks_allocated += len;
+
+		error = rmap_add_ag_rec(mp, agno, ext_ptr->ex_startblock, len,
+				btr->newbt.oinfo.oi_owner);
+		if (error)
+			do_error(_("could not set up btree rmaps: %s\n"),
+				strerror(-error));
+
+		/* Figure out if we're putting anything back. */
+		new_start = ext_ptr->ex_startblock + len;
+		new_len = ext_ptr->ex_blockcount - len;
+
+		/* Delete the used-up extent from both extent trees. */
+#ifdef XR_BLD_FREE_TRACE
+		fprintf(stderr, "releasing extent: %u [%u %u]\n",
+			agno, ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
+#endif
+		bno_ext_ptr = find_bno_extent(agno, ext_ptr->ex_startblock);
+		ASSERT(bno_ext_ptr != NULL);
+		get_bno_extent(agno, bno_ext_ptr);
+		release_extent_tree_node(bno_ext_ptr);
+
+		ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
+				ext_ptr->ex_blockcount);
+		ASSERT(ext_ptr != NULL);
+		release_extent_tree_node(ext_ptr);
+
+		/*
+		 * If we only used part of this last extent, then we need only
+		 * to reinsert the extent in the extent trees and we're done.
+		 */
+		if (new_len > 0) {
+			add_bno_extent(agno, new_start, new_len);
+			add_bcnt_extent(agno, new_start, new_len);
+			break;
+		}
+
+		/* Otherwise, find the next biggest extent. */
+		ext_ptr = findfirst_bcnt_extent(agno);
+	}
+#ifdef XR_BLD_FREE_TRACE
+	fprintf(stderr, "blocks_allocated = %d\n",
+		blocks_allocated);
+#endif
+}
+
+/* Feed one of the new btree blocks to the bulk loader. */
+static int
+rebuild_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	void			*priv)
+{
+	struct bt_rebuild	*btr = priv;
+
+	return xrep_newbt_claim_block(cur, &btr->newbt, ptr);
+}
+
 static void
 write_cursor(bt_status_t *curs)
 {
@@ -336,6 +505,34 @@ finish_cursor(bt_status_t *curs)
 	free(curs->btree_blocks);
 }
 
+static void
+finish_rebuild(
+	struct xfs_mount	*mp,
+	struct bt_rebuild	*btr)
+{
+	struct xrep_newbt_resv	*resv, *n;
+
+	for_each_xrep_newbt_reservation(&btr->newbt, resv, n) {
+		xfs_agnumber_t	agno;
+		xfs_agblock_t	bno;
+		xfs_extlen_t	len;
+
+		if (resv->used >= resv->len)
+			continue;
+
+		/* XXX: Shouldn't this go on the AGFL? */
+		/* Put back everything we didn't use. */
+		bno = XFS_FSB_TO_AGBNO(mp, resv->fsbno + resv->used);
+		agno = XFS_FSB_TO_AGNO(mp, resv->fsbno + resv->used);
+		len = resv->len - resv->used;
+
+		add_bno_extent(agno, bno, len);
+		add_bcnt_extent(agno, bno, len);
+	}
+
+	xrep_newbt_destroy(&btr->newbt, 0);
+}
+
 /*
  * We need to leave some free records in the tree for the corner case of
  * setting up the AGFL. This may require allocation of blocks, and as
@@ -2290,28 +2487,29 @@ keep_fsinos(xfs_mount_t *mp)
 
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
@@ -2533,8 +2731,8 @@ inject_lost_blocks(
 		if (error)
 			goto out_cancel;
 
-		error = -libxfs_free_extent(tp, *fsb, 1, &XFS_RMAP_OINFO_AG,
-					    XFS_AG_RESV_NONE);
+		error = -libxfs_free_extent(tp, *fsb, 1,
+				&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
 		if (error)
 			goto out_cancel;
 

