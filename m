Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA8112DD30
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jan 2020 02:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAABWA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 31 Dec 2019 20:22:00 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59862 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABV7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:21:59 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011E5ML112524;
        Wed, 1 Jan 2020 01:21:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=y4j8jtfmiY7Ykm04cPoDFJT+91sz8/i4Tj45z9RcFiI=;
 b=UPgdBYGf4bDvAOZPDenXCtg5IC6g4DgLRv2RrW+OWBzSLWhI7M5YKnSAW8PBF4L3Vki4
 zoUBdL5Wus0HU/4iwEql/0N6CjI7fTPe3rUxXAyGGkeoHi/Bjxg9N7rNbbwVFhUi+rkk
 9RGU/5F1Dl8gOBOaYvZ8gwFx2g67tKuhf0KPF7M9hmcPslqGsQhUFLkoW0gp5aGVhQTW
 t3DUy018LkFkHj5TXDYChswVo5FX6RriOPNzZ98NJsPVPsHJREFzohZkO2AccSeQMflE
 E/7PlS2R+OorjUHBriFkRrF/E/MIVP9sDldbKP4TjmFr/e8+azSDftsKm1Q3R4waeEaS Tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2x5xftk2sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:21:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011I7qT056857;
        Wed, 1 Jan 2020 01:21:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2x7medfjta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jan 2020 01:21:51 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011Lpov031440;
        Wed, 1 Jan 2020 01:21:51 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:21:50 -0800
Subject: [PATCH 4/9] xfs_repair: rebuild free space btrees with bulk loader
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:21:48 -0800
Message-ID: <157784170825.1371226.18361458846968025187.stgit@magnolia>
In-Reply-To: <157784168333.1371226.17162288990534822154.stgit@magnolia>
References: <157784168333.1371226.17162288990534822154.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the btree bulk loading functions to rebuild the free space btrees
and drop the open-coded implementation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    3 
 repair/phase5.c          |  859 ++++++++++++++--------------------------------
 2 files changed, 260 insertions(+), 602 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 6bab5a70..60dc9297 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -178,5 +178,8 @@
 #define xfs_ialloc_calc_rootino		libxfs_ialloc_calc_rootino
 
 #define xfs_sb_read_secondary		libxfs_sb_read_secondary
+#define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
+#define xfs_btree_bload			libxfs_btree_bload
+#define xfs_allocbt_stage_cursor	libxfs_allocbt_stage_cursor
 
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/repair/phase5.c b/repair/phase5.c
index ec236d4c..2421c4bc 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -71,6 +71,10 @@ struct bt_rebuild {
 	struct xfs_btree_bload	bload;
 	union {
 		struct xfs_slab_cursor	*slab_cursor;
+		struct {
+			struct extent_tree_node	*bno_rec;
+			xfs_agblock_t		*freeblks;
+		};
 	};
 };
 
@@ -88,7 +92,10 @@ static uint64_t	*sb_ifree_ag;		/* free inodes per ag */
 static uint64_t	*sb_fdblocks_ag;	/* free data blocks per ag */
 
 static int
-mk_incore_fstree(xfs_mount_t *mp, xfs_agnumber_t agno)
+mk_incore_fstree(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	unsigned int		*num_freeblocks)
 {
 	int			in_extent;
 	int			num_extents;
@@ -100,6 +107,8 @@ mk_incore_fstree(xfs_mount_t *mp, xfs_agnumber_t agno)
 	xfs_extlen_t		blen;
 	int			bstate;
 
+	*num_freeblocks = 0;
+
 	/*
 	 * scan the bitmap for the ag looking for continuous
 	 * extents of free blocks.  At this point, we know
@@ -155,6 +164,7 @@ mk_incore_fstree(xfs_mount_t *mp, xfs_agnumber_t agno)
 #endif
 				add_bno_extent(agno, extent_start, extent_len);
 				add_bcnt_extent(agno, extent_start, extent_len);
+				*num_freeblocks += extent_len;
 			}
 		}
 	}
@@ -168,6 +178,7 @@ mk_incore_fstree(xfs_mount_t *mp, xfs_agnumber_t agno)
 #endif
 		add_bno_extent(agno, extent_start, extent_len);
 		add_bcnt_extent(agno, extent_start, extent_len);
+		*num_freeblocks += extent_len;
 	}
 
 	return(num_extents);
@@ -494,313 +505,32 @@ finish_cursor(bt_status_t *curs)
 	free(curs->btree_blocks);
 }
 
+/*
+ * Scoop up leftovers from a rebuild cursor for later freeing, then free the
+ * rebuild context.
+ */
 static void
 finish_rebuild(
 	struct xfs_mount	*mp,
-	struct bt_rebuild	*btr)
+	struct bt_rebuild	*btr,
+	struct xfs_slab		*lost_fsb)
 {
 	struct xrep_newbt_resv	*resv, *n;
 
 	for_each_xrep_newbt_reservation(&btr->newbt, resv, n) {
-		xfs_agnumber_t	agno;
-		xfs_agblock_t	bno;
-		xfs_extlen_t	len;
-
-		if (resv->used >= resv->len)
-			continue;
-
-		/* XXX: Shouldn't this go on the AGFL? */
-		/* Put back everything we didn't use. */
-		bno = XFS_FSB_TO_AGBNO(mp, resv->fsbno + resv->used);
-		agno = XFS_FSB_TO_AGNO(mp, resv->fsbno + resv->used);
-		len = resv->len - resv->used;
-
-		add_bno_extent(agno, bno, len);
-		add_bcnt_extent(agno, bno, len);
-	}
-
-	xrep_newbt_destroy(&btr->newbt, 0);
-}
-
-/*
- * We need to leave some free records in the tree for the corner case of
- * setting up the AGFL. This may require allocation of blocks, and as
- * such can require insertion of new records into the tree (e.g. moving
- * a record in the by-count tree when a long extent is shortened). If we
- * pack the records into the leaves with no slack space, this requires a
- * leaf split to occur and a block to be allocated from the free list.
- * If we don't have any blocks on the free list (because we are setting
- * it up!), then we fail, and the filesystem will fail with the same
- * failure at runtime. Hence leave a couple of records slack space in
- * each block to allow immediate modification of the tree without
- * requiring splits to be done.
- *
- * XXX(hch): any reason we don't just look at mp->m_alloc_mxr?
- */
-#define XR_ALLOC_BLOCK_MAXRECS(mp, level) \
-	(libxfs_allocbt_maxrecs((mp), (mp)->m_sb.sb_blocksize, (level) == 0) - 2)
-
-/*
- * this calculates a freespace cursor for an ag.
- * btree_curs is an in/out.  returns the number of
- * blocks that will show up in the AGFL.
- */
-static int
-calculate_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
-			xfs_agblock_t *extents, bt_status_t *btree_curs)
-{
-	xfs_extlen_t		blocks_needed;		/* a running count */
-	xfs_extlen_t		blocks_allocated_pt;	/* per tree */
-	xfs_extlen_t		blocks_allocated_total;	/* for both trees */
-	xfs_agblock_t		num_extents;
-	int			i;
-	int			extents_used;
-	int			extra_blocks;
-	bt_stat_level_t		*lptr;
-	bt_stat_level_t		*p_lptr;
-	extent_tree_node_t	*ext_ptr;
-	int			level;
-
-	num_extents = *extents;
-	extents_used = 0;
-
-	ASSERT(num_extents != 0);
-
-	lptr = &btree_curs->level[0];
-	btree_curs->init = 1;
-
-	/*
-	 * figure out how much space we need for the leaf level
-	 * of the tree and set up the cursor for the leaf level
-	 * (note that the same code is duplicated further down)
-	 */
-	lptr->num_blocks = howmany(num_extents, XR_ALLOC_BLOCK_MAXRECS(mp, 0));
-	lptr->num_recs_pb = num_extents / lptr->num_blocks;
-	lptr->modulo = num_extents % lptr->num_blocks;
-	lptr->num_recs_tot = num_extents;
-	level = 1;
-
-#ifdef XR_BLD_FREE_TRACE
-	fprintf(stderr, "%s 0 %d %d %d %d\n", __func__,
-			lptr->num_blocks,
-			lptr->num_recs_pb,
-			lptr->modulo,
-			lptr->num_recs_tot);
-#endif
-	/*
-	 * if we need more levels, set them up.  # of records
-	 * per level is the # of blocks in the level below it
-	 */
-	if (lptr->num_blocks > 1)  {
-		for (; btree_curs->level[level - 1].num_blocks > 1
-				&& level < XFS_BTREE_MAXLEVELS;
-				level++)  {
-			lptr = &btree_curs->level[level];
-			p_lptr = &btree_curs->level[level - 1];
-			lptr->num_blocks = howmany(p_lptr->num_blocks,
-					XR_ALLOC_BLOCK_MAXRECS(mp, level));
-			lptr->modulo = p_lptr->num_blocks
-					% lptr->num_blocks;
-			lptr->num_recs_pb = p_lptr->num_blocks
-					/ lptr->num_blocks;
-			lptr->num_recs_tot = p_lptr->num_blocks;
-#ifdef XR_BLD_FREE_TRACE
-			fprintf(stderr, "%s %d %d %d %d %d\n", __func__,
-					level,
-					lptr->num_blocks,
-					lptr->num_recs_pb,
-					lptr->modulo,
-					lptr->num_recs_tot);
-#endif
-		}
-	}
+		while (resv->used < resv->len) {
+			xfs_fsblock_t	fsb = resv->fsbno + resv->used;
+			int		error;
 
-	ASSERT(lptr->num_blocks == 1);
-	btree_curs->num_levels = level;
-
-	/*
-	 * ok, now we have a hypothetical cursor that
-	 * will work for both the bno and bcnt trees.
-	 * now figure out if using up blocks to set up the
-	 * trees will perturb the shape of the freespace tree.
-	 * if so, we've over-allocated.  the freespace trees
-	 * as they will be *after* accounting for the free space
-	 * we've used up will need fewer blocks to to represent
-	 * than we've allocated.  We can use the AGFL to hold
-	 * xfs_agfl_size (sector/xfs_agfl_t) blocks but that's it.
-	 * Thus we limit things to xfs_agfl_size/2 for each of the 2 btrees.
-	 * if the number of extra blocks is more than that,
-	 * we'll have to be called again.
-	 */
-	for (blocks_needed = 0, i = 0; i < level; i++)  {
-		blocks_needed += btree_curs->level[i].num_blocks;
-	}
-
-	/*
-	 * record the # of blocks we've allocated
-	 */
-	blocks_allocated_pt = blocks_needed;
-	blocks_needed *= 2;
-	blocks_allocated_total = blocks_needed;
-
-	/*
-	 * figure out how many free extents will be used up by
-	 * our space allocation
-	 */
-	if ((ext_ptr = findfirst_bcnt_extent(agno)) == NULL)
-		do_error(_("can't rebuild fs trees -- not enough free space "
-			   "on ag %u\n"), agno);
-
-	while (ext_ptr != NULL && blocks_needed > 0)  {
-		if (ext_ptr->ex_blockcount <= blocks_needed)  {
-			blocks_needed -= ext_ptr->ex_blockcount;
-			extents_used++;
-		} else  {
-			blocks_needed = 0;
-		}
-
-		ext_ptr = findnext_bcnt_extent(agno, ext_ptr);
-
-#ifdef XR_BLD_FREE_TRACE
-		if (ext_ptr != NULL)  {
-			fprintf(stderr, "got next extent [%u %u]\n",
-				ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
-		} else  {
-			fprintf(stderr, "out of extents\n");
-		}
-#endif
-	}
-	if (blocks_needed > 0)
-		do_error(_("ag %u - not enough free space to build freespace "
-			   "btrees\n"), agno);
-
-	ASSERT(num_extents >= extents_used);
-
-	num_extents -= extents_used;
-
-	/*
-	 * see if the number of leaf blocks will change as a result
-	 * of the number of extents changing
-	 */
-	if (howmany(num_extents, XR_ALLOC_BLOCK_MAXRECS(mp, 0))
-			!= btree_curs->level[0].num_blocks)  {
-		/*
-		 * yes -- recalculate the cursor.  If the number of
-		 * excess (overallocated) blocks is < xfs_agfl_size/2, we're ok.
-		 * we can put those into the AGFL.  we don't try
-		 * and get things to converge exactly (reach a
-		 * state with zero excess blocks) because there
-		 * exist pathological cases which will never
-		 * converge.  first, check for the zero-case.
-		 */
-		if (num_extents == 0)  {
-			/*
-			 * ok, we've used up all the free blocks
-			 * trying to lay out the leaf level. go
-			 * to a one block (empty) btree and put the
-			 * already allocated blocks into the AGFL
-			 */
-			if (btree_curs->level[0].num_blocks != 1)  {
-				/*
-				 * we really needed more blocks because
-				 * the old tree had more than one level.
-				 * this is bad.
-				 */
-				 do_warn(_("not enough free blocks left to "
-					   "describe all free blocks in AG "
-					   "%u\n"), agno);
-			}
-#ifdef XR_BLD_FREE_TRACE
-			fprintf(stderr,
-				"ag %u -- no free extents, alloc'ed %d\n",
-				agno, blocks_allocated_pt);
-#endif
-			lptr->num_blocks = 1;
-			lptr->modulo = 0;
-			lptr->num_recs_pb = 0;
-			lptr->num_recs_tot = 0;
-
-			btree_curs->num_levels = 1;
-
-			/*
-			 * don't reset the allocation stats, assume
-			 * they're all extra blocks
-			 * don't forget to return the total block count
-			 * not the per-tree block count.  these are the
-			 * extras that will go into the AGFL.  subtract
-			 * two for the root blocks.
-			 */
-			btree_curs->num_tot_blocks = blocks_allocated_pt;
-			btree_curs->num_free_blocks = blocks_allocated_pt;
-
-			*extents = 0;
-
-			return(blocks_allocated_total - 2);
-		}
-
-		lptr = &btree_curs->level[0];
-		lptr->num_blocks = howmany(num_extents,
-					XR_ALLOC_BLOCK_MAXRECS(mp, 0));
-		lptr->num_recs_pb = num_extents / lptr->num_blocks;
-		lptr->modulo = num_extents % lptr->num_blocks;
-		lptr->num_recs_tot = num_extents;
-		level = 1;
-
-		/*
-		 * if we need more levels, set them up
-		 */
-		if (lptr->num_blocks > 1)  {
-			for (level = 1; btree_curs->level[level-1].num_blocks
-					> 1 && level < XFS_BTREE_MAXLEVELS;
-					level++)  {
-				lptr = &btree_curs->level[level];
-				p_lptr = &btree_curs->level[level-1];
-				lptr->num_blocks = howmany(p_lptr->num_blocks,
-					XR_ALLOC_BLOCK_MAXRECS(mp, level));
-				lptr->modulo = p_lptr->num_blocks
-						% lptr->num_blocks;
-				lptr->num_recs_pb = p_lptr->num_blocks
-						/ lptr->num_blocks;
-				lptr->num_recs_tot = p_lptr->num_blocks;
-			}
-		}
-		ASSERT(lptr->num_blocks == 1);
-		btree_curs->num_levels = level;
-
-		/*
-		 * now figure out the number of excess blocks
-		 */
-		for (blocks_needed = 0, i = 0; i < level; i++)  {
-			blocks_needed += btree_curs->level[i].num_blocks;
-		}
-		blocks_needed *= 2;
-
-		ASSERT(blocks_allocated_total >= blocks_needed);
-		extra_blocks = blocks_allocated_total - blocks_needed;
-	} else  {
-		if (extents_used > 0) {
-			/*
-			 * reset the leaf level geometry to account
-			 * for consumed extents.  we can leave the
-			 * rest of the cursor alone since the number
-			 * of leaf blocks hasn't changed.
-			 */
-			lptr = &btree_curs->level[0];
-
-			lptr->num_recs_pb = num_extents / lptr->num_blocks;
-			lptr->modulo = num_extents % lptr->num_blocks;
-			lptr->num_recs_tot = num_extents;
+			error = slab_add(lost_fsb, &fsb);
+			if (error)
+				do_error(
+_("Insufficient memory saving lost blocks.\n"));
+			resv->used++;
 		}
-
-		extra_blocks = 0;
 	}
 
-	btree_curs->num_tot_blocks = blocks_allocated_pt;
-	btree_curs->num_free_blocks = blocks_allocated_pt;
-
-	*extents = num_extents;
-
-	return(extra_blocks);
+	xrep_newbt_destroy(&btr->newbt, 0);
 }
 
 /* Map btnum to buffer ops for the types that need it. */
@@ -827,251 +557,211 @@ btnum_to_ops(
 	}
 }
 
+/*
+ * Free Space Btrees
+ *
+ * We need to leave some free records in the tree for the corner case of
+ * setting up the AGFL. This may require allocation of blocks, and as
+ * such can require insertion of new records into the tree (e.g. moving
+ * a record in the by-count tree when a long extent is shortened). If we
+ * pack the records into the leaves with no slack space, this requires a
+ * leaf split to occur and a block to be allocated from the free list.
+ * If we don't have any blocks on the free list (because we are setting
+ * it up!), then we fail, and the filesystem will fail with the same
+ * failure at runtime. Hence leave a couple of records slack space in
+ * each block to allow immediate modification of the tree without
+ * requiring splits to be done.
+ */
+
 static void
-prop_freespace_cursor(xfs_mount_t *mp, xfs_agnumber_t agno,
-		bt_status_t *btree_curs, xfs_agblock_t startblock,
-		xfs_extlen_t blockcount, int level, xfs_btnum_t btnum)
+init_freespace_cursors(
+	struct repair_ctx	*sc,
+	xfs_agnumber_t		agno,
+	unsigned int		free_space,
+	unsigned int		*nr_extents,
+	int			*extra_blocks,
+	struct bt_rebuild	*btr_bno,
+	struct bt_rebuild	*btr_cnt)
 {
-	struct xfs_btree_block	*bt_hdr;
-	xfs_alloc_key_t		*bt_key;
-	xfs_alloc_ptr_t		*bt_ptr;
-	xfs_agblock_t		agbno;
-	bt_stat_level_t		*lptr;
-	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
-
-	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
-
-	level++;
-
-	if (level >= btree_curs->num_levels)
-		return;
-
-	lptr = &btree_curs->level[level];
-	bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-
-	if (be16_to_cpu(bt_hdr->bb_numrecs) == 0)  {
-		/*
-		 * only happens once when initializing the
-		 * left-hand side of the tree.
-		 */
-		prop_freespace_cursor(mp, agno, btree_curs, startblock,
-				blockcount, level, btnum);
-	}
-
-	if (be16_to_cpu(bt_hdr->bb_numrecs) ==
-				lptr->num_recs_pb + (lptr->modulo > 0))  {
-		/*
-		 * write out current prev block, grab us a new block,
-		 * and set the rightsib pointer of current block
-		 */
-#ifdef XR_BLD_FREE_TRACE
-		fprintf(stderr, " %d ", lptr->prev_agbno);
-#endif
-		if (lptr->prev_agbno != NULLAGBLOCK) {
-			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_writebuf(lptr->prev_buf_p, 0);
-		}
-		lptr->prev_agbno = lptr->agbno;;
-		lptr->prev_buf_p = lptr->buf_p;
-		agbno = get_next_blockaddr(agno, level, btree_curs);
+	struct xfs_btree_cur	*cur;
+	unsigned int		bno_blocks;
+	unsigned int		cnt_blocks;
+	int			error;
 
-		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
+	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_bno);
+	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr_cnt);
 
-		lptr->buf_p = libxfs_getbuf(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, 1));
-		lptr->agbno = agbno;
+	/*
+	 * Now we need to allocate blocks for the free space btrees using the
+	 * free space records we're about to put in them.  Every record we use
+	 * can change the shape of the free space trees, so we recompute the
+	 * btree shape until we stop needing /more/ blocks.  If we have any
+	 * left over we'll stash them in the AGFL when we're done.
+	 */
+	do {
+		unsigned int	num_freeblocks;
 
-		if (lptr->modulo)
-			lptr->modulo--;
+		bno_blocks = btr_bno->bload.nr_blocks;
+		cnt_blocks = btr_cnt->bload.nr_blocks;
 
-		/*
-		 * initialize block header
-		 */
-		lptr->buf_p->b_ops = ops;
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		libxfs_btree_init_block(mp, lptr->buf_p, btnum, level,
-					0, agno);
+		/* Compute how many bnobt blocks we'll need. */
+		cur = libxfs_allocbt_stage_cursor(sc->mp, sc->tp,
+				&btr_bno->newbt.afake, agno, XFS_BTNUM_BNO);
+		error = -libxfs_btree_bload_compute_geometry(cur,
+				&btr_bno->bload, *nr_extents);
+		if (error)
+			do_error(
+_("Unable to compute free space by block btree geometry, error %d.\n"), -error);
+		libxfs_btree_del_cursor(cur, error);
+
+		/* Compute how many cntbt blocks we'll need. */
+		cur = libxfs_allocbt_stage_cursor(sc->mp, sc->tp,
+				&btr_cnt->newbt.afake, agno, XFS_BTNUM_CNT);
+		error = -libxfs_btree_bload_compute_geometry(cur,
+				&btr_cnt->bload, *nr_extents);
+		if (error)
+			do_error(
+_("Unable to compute free space by length btree geometry, error %d.\n"), -error);
+		libxfs_btree_del_cursor(cur, error);
 
-		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
+		/* We don't need any more blocks, so we're done. */
+		if (bno_blocks >= btr_bno->bload.nr_blocks &&
+		    cnt_blocks >= btr_cnt->bload.nr_blocks)
+			break;
 
-		/*
-		 * propagate extent record for first extent in new block up
-		 */
-		prop_freespace_cursor(mp, agno, btree_curs, startblock,
-				blockcount, level, btnum);
-	}
-	/*
-	 * add extent info to current block
-	 */
-	be16_add_cpu(&bt_hdr->bb_numrecs, 1);
+		/* Allocate however many more blocks we need this time. */
+		if (bno_blocks < btr_bno->bload.nr_blocks)
+			setup_rebuild(sc->mp, agno, btr_bno,
+					btr_bno->bload.nr_blocks - bno_blocks);
+		if (cnt_blocks < btr_cnt->bload.nr_blocks)
+			setup_rebuild(sc->mp, agno, btr_cnt,
+					btr_cnt->bload.nr_blocks - cnt_blocks);
 
-	bt_key = XFS_ALLOC_KEY_ADDR(mp, bt_hdr,
-				be16_to_cpu(bt_hdr->bb_numrecs));
-	bt_ptr = XFS_ALLOC_PTR_ADDR(mp, bt_hdr,
-				be16_to_cpu(bt_hdr->bb_numrecs),
-				mp->m_alloc_mxr[1]);
+		/* Ok, now how many free space records do we have? */
+		*nr_extents = count_bno_extents_blocks(agno, &num_freeblocks);
+	} while (1);
 
-	bt_key->ar_startblock = cpu_to_be32(startblock);
-	bt_key->ar_blockcount = cpu_to_be32(blockcount);
-	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
+	*extra_blocks = (bno_blocks - btr_bno->bload.nr_blocks) +
+			(cnt_blocks - btr_cnt->bload.nr_blocks);
 }
 
-/*
- * rebuilds a freespace tree given a cursor and type
- * of tree to build (bno or bcnt).  returns the number of free blocks
- * represented by the tree.
- */
-static xfs_extlen_t
-build_freespace_tree(xfs_mount_t *mp, xfs_agnumber_t agno,
-		bt_status_t *btree_curs, xfs_btnum_t btnum)
+static void
+get_freesp_data(
+	struct xfs_btree_cur		*cur,
+	struct extent_tree_node		*bno_rec,
+	xfs_agblock_t			*freeblks)
 {
-	xfs_agnumber_t		i;
-	xfs_agblock_t		j;
-	struct xfs_btree_block	*bt_hdr;
-	xfs_alloc_rec_t		*bt_rec;
-	int			level;
-	xfs_agblock_t		agbno;
-	extent_tree_node_t	*ext_ptr;
-	bt_stat_level_t		*lptr;
-	xfs_extlen_t		freeblks;
-	const struct xfs_buf_ops *ops = btnum_to_ops(btnum);
-
-	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
+	struct xfs_alloc_rec_incore	*arec = &cur->bc_rec.a;
 
-#ifdef XR_BLD_FREE_TRACE
-	fprintf(stderr, "in build_freespace_tree, agno = %d\n", agno);
-#endif
-	level = btree_curs->num_levels;
-	freeblks = 0;
+	arec->ar_startblock = bno_rec->ex_startblock;
+	arec->ar_blockcount = bno_rec->ex_blockcount;
+	if (freeblks)
+		*freeblks += bno_rec->ex_blockcount;
+}
 
-	ASSERT(level > 0);
+/* Grab one bnobt record. */
+static int
+get_bnobt_data(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
+{
+	struct bt_rebuild		*btr = priv;
 
-	/*
-	 * initialize the first block on each btree level
-	 */
-	for (i = 0; i < level; i++)  {
-		lptr = &btree_curs->level[i];
+	get_freesp_data(cur, btr->bno_rec, btr->freeblks);
+	btr->bno_rec = findnext_bno_extent(btr->bno_rec);
+	return 0;
+}
 
-		agbno = get_next_blockaddr(agno, i, btree_curs);
-		lptr->buf_p = libxfs_getbuf(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, agbno),
-					XFS_FSB_TO_BB(mp, 1));
+/* Rebuild a free space by block number btree. */
+static void
+build_bnobt(
+	struct repair_ctx	*sc,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr_bno,
+	xfs_agblock_t		*freeblks)
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
 
-		if (i == btree_curs->num_levels - 1)
-			btree_curs->root = agbno;
+	*freeblks = 0;
+	btr_bno->bload.get_data = get_bnobt_data;
+	btr_bno->bload.alloc_block = rebuild_alloc_block;
+	btr_bno->bno_rec = findfirst_bno_extent(agno);
+	btr_bno->freeblks = freeblks;
 
-		lptr->agbno = agbno;
-		lptr->prev_agbno = NULLAGBLOCK;
-		lptr->prev_buf_p = NULL;
-		/*
-		 * initialize block header
-		 */
-		lptr->buf_p->b_ops = ops;
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		libxfs_btree_init_block(mp, lptr->buf_p, btnum, i, 0, agno);
-	}
-	/*
-	 * run along leaf, setting up records.  as we have to switch
-	 * blocks, call the prop_freespace_cursor routine to set up the new
-	 * pointers for the parent.  that can recurse up to the root
-	 * if required.  set the sibling pointers for leaf level here.
-	 */
-	if (btnum == XFS_BTNUM_BNO)
-		ext_ptr = findfirst_bno_extent(agno);
-	else
-		ext_ptr = findfirst_bcnt_extent(agno);
+	error = -libxfs_trans_alloc_empty(sc->mp, &sc->tp);
+	if (error)
+		do_error(
+_("Insufficient memory to construct bnobt rebuild transaction.\n"));
 
-#ifdef XR_BLD_FREE_TRACE
-	fprintf(stderr, "bft, agno = %d, start = %u, count = %u\n",
-		agno, ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
-#endif
+	/* Add all observed bnobt records. */
+	cur = libxfs_allocbt_stage_cursor(sc->mp, sc->tp,
+			&btr_bno->newbt.afake, agno, XFS_BTNUM_BNO);
+	error = -libxfs_btree_bload(cur, &btr_bno->bload, btr_bno);
+	if (error)
+		do_error(
+_("Error %d while creating bnobt btree for AG %u.\n"), error, agno);
 
-	lptr = &btree_curs->level[0];
+	/* Since we're not writing the AGF yet, no need to commit the cursor */
+	libxfs_btree_del_cursor(cur, 0);
+	error = -libxfs_trans_commit(sc->tp);
+	if (error)
+		do_error(
+_("Error %d while writing bnobt btree for AG %u.\n"), error, agno);
+	sc->tp = NULL;
+}
 
-	for (i = 0; i < btree_curs->level[0].num_blocks; i++)  {
-		/*
-		 * block initialization, lay in block header
-		 */
-		lptr->buf_p->b_ops = ops;
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		libxfs_btree_init_block(mp, lptr->buf_p, btnum, 0, 0, agno);
+/* Grab one cntbt record. */
+static int
+get_cntbt_data(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
+{
+	struct bt_rebuild		*btr = priv;
 
-		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-		bt_hdr->bb_numrecs = cpu_to_be16(lptr->num_recs_pb +
-							(lptr->modulo > 0));
-#ifdef XR_BLD_FREE_TRACE
-		fprintf(stderr, "bft, bb_numrecs = %d\n",
-				be16_to_cpu(bt_hdr->bb_numrecs));
-#endif
+	get_freesp_data(cur, btr->bno_rec, btr->freeblks);
+	btr->bno_rec = findnext_bcnt_extent(cur->bc_private.a.agno,
+			btr->bno_rec);
+	return 0;
+}
 
-		if (lptr->modulo > 0)
-			lptr->modulo--;
+/* Rebuild a freespace by count btree. */
+static void
+build_cntbt(
+	struct repair_ctx	*sc,
+	xfs_agnumber_t		agno,
+	struct bt_rebuild	*btr_cnt,
+	xfs_agblock_t		*freeblks)
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
 
-		/*
-		 * initialize values in the path up to the root if
-		 * this is a multi-level btree
-		 */
-		if (btree_curs->num_levels > 1)
-			prop_freespace_cursor(mp, agno, btree_curs,
-					ext_ptr->ex_startblock,
-					ext_ptr->ex_blockcount,
-					0, btnum);
-
-		bt_rec = (xfs_alloc_rec_t *)
-			  ((char *)bt_hdr + XFS_ALLOC_BLOCK_LEN(mp));
-		for (j = 0; j < be16_to_cpu(bt_hdr->bb_numrecs); j++) {
-			ASSERT(ext_ptr != NULL);
-			bt_rec[j].ar_startblock = cpu_to_be32(
-							ext_ptr->ex_startblock);
-			bt_rec[j].ar_blockcount = cpu_to_be32(
-							ext_ptr->ex_blockcount);
-			freeblks += ext_ptr->ex_blockcount;
-			if (btnum == XFS_BTNUM_BNO)
-				ext_ptr = findnext_bno_extent(ext_ptr);
-			else
-				ext_ptr = findnext_bcnt_extent(agno, ext_ptr);
-#if 0
-#ifdef XR_BLD_FREE_TRACE
-			if (ext_ptr == NULL)
-				fprintf(stderr, "null extent pointer, j = %d\n",
-					j);
-			else
-				fprintf(stderr,
-				"bft, agno = %d, start = %u, count = %u\n",
-					agno, ext_ptr->ex_startblock,
-					ext_ptr->ex_blockcount);
-#endif
-#endif
-		}
+	*freeblks = 0;
+	btr_cnt->bload.get_data = get_cntbt_data;
+	btr_cnt->bload.alloc_block = rebuild_alloc_block;
+	btr_cnt->bno_rec = findfirst_bcnt_extent(agno);
+	btr_cnt->freeblks = freeblks;
 
-		if (ext_ptr != NULL)  {
-			/*
-			 * get next leaf level block
-			 */
-			if (lptr->prev_buf_p != NULL)  {
-#ifdef XR_BLD_FREE_TRACE
-				fprintf(stderr, " writing fst agbno %u\n",
-					lptr->prev_agbno);
-#endif
-				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_writebuf(lptr->prev_buf_p, 0);
-			}
-			lptr->prev_buf_p = lptr->buf_p;
-			lptr->prev_agbno = lptr->agbno;
-			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
-			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
+	error = -libxfs_trans_alloc_empty(sc->mp, &sc->tp);
+	if (error)
+		do_error(
+_("Insufficient memory to construct cntbt rebuild transaction.\n"));
 
-			lptr->buf_p = libxfs_getbuf(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
-					XFS_FSB_TO_BB(mp, 1));
-		}
-	}
+	/* Add all observed cntbt records. */
+	cur = libxfs_allocbt_stage_cursor(sc->mp, sc->tp,
+			&btr_cnt->newbt.afake, agno, XFS_BTNUM_CNT);
+	error = -libxfs_btree_bload(cur, &btr_cnt->bload, btr_cnt);
+	if (error)
+		do_error(
+_("Error %d while creating cntbt btree for AG %u.\n"), error, agno);
 
-	return(freeblks);
+	/* Since we're not writing the AGF yet, no need to commit the cursor */
+	libxfs_btree_del_cursor(cur, 0);
+	error = -libxfs_trans_commit(sc->tp);
+	if (error)
+		do_error(
+_("Error %d while writing cntbt btree for AG %u.\n"), error, agno);
+	sc->tp = NULL;
 }
 
 /*
@@ -2157,6 +1847,27 @@ _("Insufficient memory to construct refcount cursor."));
 	free_slab_cursor(&refc_cur);
 }
 
+/* Fill the AGFL with any leftover bnobt rebuilder blocks. */
+static void
+fill_agfl(
+	struct bt_rebuild	*btr,
+	__be32			*agfl_bnos,
+	int			*i)
+{
+	struct xrep_newbt_resv	*resv, *n;
+	struct xfs_mount	*mp = btr->newbt.sc->mp;
+
+	for_each_xrep_newbt_reservation(&btr->newbt, resv, n) {
+		xfs_agblock_t	bno;
+
+		bno = XFS_FSB_TO_AGBNO(mp, resv->fsbno + resv->used);
+		while (resv->used < resv->len && (*i) < libxfs_agfl_size(mp)) {
+			agfl_bnos[(*i)++] = cpu_to_be32(bno++);
+			resv->used++;
+		}
+	}
+}
+
 /*
  * build both the agf and the agfl for an agno given both
  * btree cursors.
@@ -2167,8 +1878,8 @@ static void
 build_agf_agfl(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
-	struct bt_status	*bno_bt,
-	struct bt_status	*bcnt_bt,
+	struct bt_rebuild	*btr_bno,
+	struct bt_rebuild	*btr_cnt,
 	xfs_extlen_t		freeblks,	/* # free blocks in tree */
 	int			lostblocks,	/* # blocks that will be lost */
 	struct bt_status	*rmap_bt,
@@ -2180,9 +1891,7 @@ build_agf_agfl(
 	int			i;
 	struct xfs_agfl		*agfl;
 	struct xfs_agf		*agf;
-	xfs_fsblock_t		fsb;
 	__be32			*freelist;
-	int			error;
 
 	agf_buf = libxfs_getbuf(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
@@ -2209,10 +1918,14 @@ build_agf_agfl(
 		agf->agf_length = cpu_to_be32(mp->m_sb.sb_dblocks -
 			(xfs_rfsblock_t) mp->m_sb.sb_agblocks * agno);
 
-	agf->agf_roots[XFS_BTNUM_BNO] = cpu_to_be32(bno_bt->root);
-	agf->agf_levels[XFS_BTNUM_BNO] = cpu_to_be32(bno_bt->num_levels);
-	agf->agf_roots[XFS_BTNUM_CNT] = cpu_to_be32(bcnt_bt->root);
-	agf->agf_levels[XFS_BTNUM_CNT] = cpu_to_be32(bcnt_bt->num_levels);
+	agf->agf_roots[XFS_BTNUM_BNO] =
+			cpu_to_be32(btr_bno->newbt.afake.af_root);
+	agf->agf_levels[XFS_BTNUM_BNO] =
+			cpu_to_be32(btr_bno->newbt.afake.af_levels);
+	agf->agf_roots[XFS_BTNUM_CNT] =
+			cpu_to_be32(btr_cnt->newbt.afake.af_root);
+	agf->agf_levels[XFS_BTNUM_CNT] =
+			cpu_to_be32(btr_cnt->newbt.afake.af_levels);
 	agf->agf_roots[XFS_BTNUM_RMAP] = cpu_to_be32(rmap_bt->root);
 	agf->agf_levels[XFS_BTNUM_RMAP] = cpu_to_be32(rmap_bt->num_levels);
 	agf->agf_freeblks = cpu_to_be32(freeblks);
@@ -2232,9 +1945,8 @@ build_agf_agfl(
 		 * Don't count the root blocks as they are already
 		 * accounted for.
 		 */
-		blks = (bno_bt->num_tot_blocks - bno_bt->num_free_blocks) +
-			(bcnt_bt->num_tot_blocks - bcnt_bt->num_free_blocks) -
-			2;
+		blks = btr_bno->newbt.afake.af_blocks +
+			btr_cnt->newbt.afake.af_blocks - 2;
 		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 			blks += rmap_bt->num_tot_blocks - rmap_bt->num_free_blocks - 1;
 		agf->agf_btreeblks = cpu_to_be32(blks);
@@ -2272,49 +1984,14 @@ build_agf_agfl(
 			agfl->agfl_bno[i] = cpu_to_be32(NULLAGBLOCK);
 	}
 	freelist = XFS_BUF_TO_AGFL_BNO(mp, agfl_buf);
+	i = 0;
 
-	/*
-	 * do we have left-over blocks in the btree cursors that should
-	 * be used to fill the AGFL?
-	 */
-	if (bno_bt->num_free_blocks > 0 || bcnt_bt->num_free_blocks > 0)  {
-		/*
-		 * yes, now grab as many blocks as we can
-		 */
-		i = 0;
-		while (bno_bt->num_free_blocks > 0 && i < libxfs_agfl_size(mp))
-		{
-			freelist[i] = cpu_to_be32(
-					get_next_blockaddr(agno, 0, bno_bt));
-			i++;
-		}
-
-		while (bcnt_bt->num_free_blocks > 0 && i < libxfs_agfl_size(mp))
-		{
-			freelist[i] = cpu_to_be32(
-					get_next_blockaddr(agno, 0, bcnt_bt));
-			i++;
-		}
-		/*
-		 * now throw the rest of the blocks away and complain
-		 */
-		while (bno_bt->num_free_blocks > 0) {
-			fsb = XFS_AGB_TO_FSB(mp, agno,
-					get_next_blockaddr(agno, 0, bno_bt));
-			error = slab_add(lost_fsb, &fsb);
-			if (error)
-				do_error(
-_("Insufficient memory saving lost blocks.\n"));
-		}
-		while (bcnt_bt->num_free_blocks > 0) {
-			fsb = XFS_AGB_TO_FSB(mp, agno,
-					get_next_blockaddr(agno, 0, bcnt_bt));
-			error = slab_add(lost_fsb, &fsb);
-			if (error)
-				do_error(
-_("Insufficient memory saving lost blocks.\n"));
-		}
+	/* Fill the AGFL with leftover blocks or save them for later. */
+	fill_agfl(btr_bno, freelist, &i);
+	fill_agfl(btr_cnt, freelist, &i);
 
+	/* Set the AGF counters for the AGFL. */
+	if (i > 0) {
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(i - 1);
 		agf->agf_flcount = cpu_to_be32(i);
@@ -2409,8 +2086,8 @@ phase5_func(
 	uint64_t		num_free_inos;
 	uint64_t		finobt_num_inos;
 	uint64_t		finobt_num_free_inos;
-	bt_status_t		bno_btree_curs;
-	bt_status_t		bcnt_btree_curs;
+	struct bt_rebuild	btr_bno;
+	struct bt_rebuild	btr_cnt;
 	bt_status_t		ino_btree_curs;
 	bt_status_t		fino_btree_curs;
 	bt_status_t		rmap_btree_curs;
@@ -2418,9 +2095,7 @@ phase5_func(
 	int			extra_blocks = 0;
 	uint			num_freeblocks;
 	xfs_extlen_t		freeblks1;
-#ifdef DEBUG
 	xfs_extlen_t		freeblks2;
-#endif
 	xfs_agblock_t		num_extents;
 
 	if (verbose)
@@ -2429,7 +2104,7 @@ phase5_func(
 	/*
 	 * build up incore bno and bcnt extent btrees
 	 */
-	num_extents = mk_incore_fstree(mp, agno);
+	num_extents = mk_incore_fstree(mp, agno, &num_freeblocks);
 
 #ifdef XR_BLD_FREE_TRACE
 	fprintf(stderr, "# of bno extents is %d\n",
@@ -2508,8 +2183,8 @@ phase5_func(
 	/*
 	 * track blocks that we might really lose
 	 */
-	extra_blocks = calculate_freespace_cursor(mp, agno,
-				&num_extents, &bno_btree_curs);
+	init_freespace_cursors(&sc, agno, num_freeblocks, &num_extents,
+			&extra_blocks, &btr_bno, &btr_cnt);
 
 	/*
 	 * freespace btrees live in the "free space" but
@@ -2527,13 +2202,6 @@ phase5_func(
 	if (extra_blocks > 0)
 		sb_fdblocks_ag[agno] -= extra_blocks;
 
-	bcnt_btree_curs = bno_btree_curs;
-
-	bno_btree_curs.owner = XFS_RMAP_OWN_AG;
-	bcnt_btree_curs.owner = XFS_RMAP_OWN_AG;
-	setup_cursor(mp, agno, &bno_btree_curs);
-	setup_cursor(mp, agno, &bcnt_btree_curs);
-
 #ifdef XR_BLD_FREE_TRACE
 	fprintf(stderr, "# of bno extents is %d\n",
 			count_bno_extents(agno));
@@ -2541,25 +2209,13 @@ phase5_func(
 			count_bcnt_extents(agno));
 #endif
 
-	/*
-	 * now rebuild the freespace trees
-	 */
-	freeblks1 = build_freespace_tree(mp, agno,
-				&bno_btree_curs, XFS_BTNUM_BNO);
+	/* Rebuild the freespace btrees. */
+	build_bnobt(&sc, agno, &btr_bno, &freeblks1);
+	build_cntbt(&sc, agno, &btr_cnt, &freeblks2);
+
 #ifdef XR_BLD_FREE_TRACE
-	fprintf(stderr, "# of free blocks == %d\n", freeblks1);
-#endif
-	write_cursor(&bno_btree_curs);
-
-#ifdef DEBUG
-	freeblks2 = build_freespace_tree(mp, agno,
-				&bcnt_btree_curs, XFS_BTNUM_CNT);
-#else
-	(void) build_freespace_tree(mp, agno,
-				&bcnt_btree_curs, XFS_BTNUM_CNT);
+	fprintf(stderr, "# of free blocks == %d/%d\n", freeblks1, freeblks2);
 #endif
-	write_cursor(&bcnt_btree_curs);
-
 	ASSERT(freeblks1 == freeblks2);
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
@@ -2577,9 +2233,9 @@ phase5_func(
 	/*
 	 * set up agf and agfl
 	 */
-	build_agf_agfl(mp, agno, &bno_btree_curs,
-			&bcnt_btree_curs, freeblks1, extra_blocks,
+	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, freeblks1, extra_blocks,
 			&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
+
 	/*
 	 * build inode allocation tree.
 	 */
@@ -2603,15 +2259,14 @@ phase5_func(
 	/*
 	 * tear down cursors
 	 */
-	finish_cursor(&bno_btree_curs);
-	finish_cursor(&ino_btree_curs);
+	finish_rebuild(mp, &btr_bno, lost_fsb);
+	finish_rebuild(mp, &btr_cnt, lost_fsb);
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		finish_cursor(&rmap_btree_curs);
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
 		finish_cursor(&refcnt_btree_curs);
 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
 		finish_cursor(&fino_btree_curs);
-	finish_cursor(&bcnt_btree_curs);
 
 	/*
 	 * release the incore per-AG bno/bcnt trees so

