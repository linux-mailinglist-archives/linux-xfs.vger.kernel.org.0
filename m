Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B205E93EC
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Oct 2019 00:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbfJ2XsW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Oct 2019 19:48:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35214 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfJ2XsW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:48:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNdfNZ017359;
        Tue, 29 Oct 2019 23:48:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=NTUUjxhUrmj+Ji2X468fqImTPyRY71WYAD7Eaf7mNf4=;
 b=IJQY6cT9X1FsEfNCppAHucPnZ2RSsV5mzXrXs8zgdXho6H4TEuNn2JMTUi5hrdTclbc0
 Yf2EtuML/7LaZKFG/hB8n/CGhOSK9JFwz4RMXwzwTY7YvqXClwrGgK8KM5izTh5VPi8C
 B093Q/ICxiqdyv5f4Rw+Lgup6MaY1Qhtes05Fc0jV8rNz7XwvX8OzcC0gl0x/rWGrRbm
 HsMIHtCdi8JWGyNH/8ULwHWGrlEf0KtnmOd9mpKVE6cM3/CaEy+NCg7ZZ8zEX+W+jZYS
 glVb9dDQI58JefONZXPJvBbmkYUoAg86AXl55jCCqB/X5VwtgBRqFCdVNkW/Q/tjVnzE MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vxwhfgc56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 23:48:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNhsrk097955;
        Tue, 29 Oct 2019 23:46:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vxwhuw0ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 23:46:19 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9TNkIFQ013850;
        Tue, 29 Oct 2019 23:46:18 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:46:18 -0700
Subject: [PATCH 8/9] xfs_repair: remove old btree rebuild support code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:46:17 -0700
Message-ID: <157239277750.1277435.16947904966484666791.stgit@magnolia>
In-Reply-To: <157239272641.1277435.17698788915454836309.stgit@magnolia>
References: <157239272641.1277435.17698788915454836309.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290208
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This code isn't needed anymore, so get rid of it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |  240 -------------------------------------------------------
 1 file changed, 240 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index ee4a4563..94fc17d8 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -20,52 +20,6 @@
 #include "rmap.h"
 #include "bload.h"
 
-/*
- * we maintain the current slice (path from root to leaf)
- * of the btree incore.  when we need a new block, we ask
- * the block allocator for the address of a block on that
- * level, map the block in, and set up the appropriate
- * pointers (child, silbing, etc.) and keys that should
- * point to the new block.
- */
-typedef struct bt_stat_level  {
-	/*
-	 * set in setup_cursor routine and maintained in the tree-building
-	 * routines
-	 */
-	xfs_buf_t		*buf_p;		/* 2 buffer pointers to ... */
-	xfs_buf_t		*prev_buf_p;
-	xfs_agblock_t		agbno;		/* current block being filled */
-	xfs_agblock_t		prev_agbno;	/* previous block */
-	/*
-	 * set in calculate/init cursor routines for each btree level
-	 */
-	int			num_recs_tot;	/* # tree recs in level */
-	int			num_blocks;	/* # tree blocks in level */
-	int			num_recs_pb;	/* num_recs_tot / num_blocks */
-	int			modulo;		/* num_recs_tot % num_blocks */
-} bt_stat_level_t;
-
-typedef struct bt_status  {
-	int			init;		/* cursor set up once? */
-	int			num_levels;	/* # of levels in btree */
-	xfs_extlen_t		num_tot_blocks;	/* # blocks alloc'ed for tree */
-	xfs_extlen_t		num_free_blocks;/* # blocks currently unused */
-
-	xfs_agblock_t		root;		/* root block */
-	/*
-	 * list of blocks to be used to set up this tree
-	 * and pointer to the first unused block on the list
-	 */
-	xfs_agblock_t		*btree_blocks;		/* block list */
-	xfs_agblock_t		*free_btree_blocks;	/* first unused block */
-	/*
-	 * per-level status info
-	 */
-	bt_stat_level_t		level[XFS_BTREE_MAXLEVELS];
-	uint64_t		owner;		/* owner */
-} bt_status_t;
-
 struct bt_rebuild {
 	struct xrep_newbt	newbt;
 	struct xfs_btree_bload	bload;
@@ -188,148 +142,6 @@ mk_incore_fstree(
 	return(num_extents);
 }
 
-static xfs_agblock_t
-get_next_blockaddr(xfs_agnumber_t agno, int level, bt_status_t *curs)
-{
-	ASSERT(curs->free_btree_blocks < curs->btree_blocks +
-						curs->num_tot_blocks);
-	ASSERT(curs->num_free_blocks > 0);
-
-	curs->num_free_blocks--;
-	return(*curs->free_btree_blocks++);
-}
-
-/*
- * set up the dynamically allocated block allocation data in the btree
- * cursor that depends on the info in the static portion of the cursor.
- * allocates space from the incore bno/bcnt extent trees and sets up
- * the first path up the left side of the tree.  Also sets up the
- * cursor pointer to the btree root.   called by init_freespace_cursor()
- * and init_ino_cursor()
- */
-static void
-setup_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *curs)
-{
-	int			j;
-	unsigned int		u;
-	xfs_extlen_t		big_extent_len;
-	xfs_agblock_t		big_extent_start;
-	extent_tree_node_t	*ext_ptr;
-	extent_tree_node_t	*bno_ext_ptr;
-	xfs_extlen_t		blocks_allocated;
-	xfs_agblock_t		*agb_ptr;
-	int			error;
-
-	/*
-	 * get the number of blocks we need to allocate, then
-	 * set up block number array, set the free block pointer
-	 * to the first block in the array, and null the array
-	 */
-	big_extent_len = curs->num_tot_blocks;
-	blocks_allocated = 0;
-
-	ASSERT(big_extent_len > 0);
-
-	if ((curs->btree_blocks = malloc(sizeof(xfs_agblock_t)
-					* big_extent_len)) == NULL)
-		do_error(_("could not set up btree block array\n"));
-
-	agb_ptr = curs->free_btree_blocks = curs->btree_blocks;
-
-	for (j = 0; j < curs->num_free_blocks; j++, agb_ptr++)
-		*agb_ptr = NULLAGBLOCK;
-
-	/*
-	 * grab the smallest extent and use it up, then get the
-	 * next smallest.  This mimics the init_*_cursor code.
-	 */
-	ext_ptr =  findfirst_bcnt_extent(agno);
-
-	agb_ptr = curs->btree_blocks;
-
-	/*
-	 * set up the free block array
-	 */
-	while (blocks_allocated < big_extent_len)  {
-		if (!ext_ptr)
-			do_error(
-_("error - not enough free space in filesystem\n"));
-		/*
-		 * use up the extent we've got
-		 */
-		for (u = 0; u < ext_ptr->ex_blockcount &&
-				blocks_allocated < big_extent_len; u++)  {
-			ASSERT(agb_ptr < curs->btree_blocks
-					+ curs->num_tot_blocks);
-			*agb_ptr++ = ext_ptr->ex_startblock + u;
-			blocks_allocated++;
-		}
-
-		error = rmap_add_ag_rec(mp, agno, ext_ptr->ex_startblock, u,
-				curs->owner);
-		if (error)
-			do_error(_("could not set up btree rmaps: %s\n"),
-				strerror(-error));
-
-		/*
-		 * if we only used part of this last extent, then we
-		 * need only to reset the extent in the extent
-		 * trees and we're done
-		 */
-		if (u < ext_ptr->ex_blockcount)  {
-			big_extent_start = ext_ptr->ex_startblock + u;
-			big_extent_len = ext_ptr->ex_blockcount - u;
-
-			ASSERT(big_extent_len > 0);
-
-			bno_ext_ptr = find_bno_extent(agno,
-						ext_ptr->ex_startblock);
-			ASSERT(bno_ext_ptr != NULL);
-			get_bno_extent(agno, bno_ext_ptr);
-			release_extent_tree_node(bno_ext_ptr);
-
-			ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
-					ext_ptr->ex_blockcount);
-			release_extent_tree_node(ext_ptr);
-#ifdef XR_BLD_FREE_TRACE
-			fprintf(stderr, "releasing extent: %u [%u %u]\n",
-				agno, ext_ptr->ex_startblock,
-				ext_ptr->ex_blockcount);
-			fprintf(stderr, "blocks_allocated = %d\n",
-				blocks_allocated);
-#endif
-
-			add_bno_extent(agno, big_extent_start, big_extent_len);
-			add_bcnt_extent(agno, big_extent_start, big_extent_len);
-
-			return;
-		}
-		/*
-		 * delete the used-up extent from both extent trees and
-		 * find next biggest extent
-		 */
-#ifdef XR_BLD_FREE_TRACE
-		fprintf(stderr, "releasing extent: %u [%u %u]\n",
-			agno, ext_ptr->ex_startblock, ext_ptr->ex_blockcount);
-#endif
-		bno_ext_ptr = find_bno_extent(agno, ext_ptr->ex_startblock);
-		ASSERT(bno_ext_ptr != NULL);
-		get_bno_extent(agno, bno_ext_ptr);
-		release_extent_tree_node(bno_ext_ptr);
-
-		ext_ptr = get_bcnt_extent(agno, ext_ptr->ex_startblock,
-				ext_ptr->ex_blockcount);
-		ASSERT(ext_ptr != NULL);
-		release_extent_tree_node(ext_ptr);
-
-		ext_ptr = findfirst_bcnt_extent(agno);
-	}
-#ifdef XR_BLD_FREE_TRACE
-	fprintf(stderr, "blocks_allocated = %d\n",
-		blocks_allocated);
-#endif
-}
-
 /*
  * Estimate proper slack values for a btree that's being reloaded.
  *
@@ -481,34 +293,6 @@ rebuild_alloc_block(
 	return xrep_newbt_alloc_block(cur, &btr->newbt, ptr);
 }
 
-static void
-write_cursor(bt_status_t *curs)
-{
-	int i;
-
-	for (i = 0; i < curs->num_levels; i++)  {
-#if defined(XR_BLD_FREE_TRACE) || defined(XR_BLD_INO_TRACE)
-		fprintf(stderr, "writing bt block %u\n", curs->level[i].agbno);
-#endif
-		if (curs->level[i].prev_buf_p != NULL)  {
-			ASSERT(curs->level[i].prev_agbno != NULLAGBLOCK);
-#if defined(XR_BLD_FREE_TRACE) || defined(XR_BLD_INO_TRACE)
-			fprintf(stderr, "writing bt prev block %u\n",
-						curs->level[i].prev_agbno);
-#endif
-			libxfs_writebuf(curs->level[i].prev_buf_p, 0);
-		}
-		libxfs_writebuf(curs->level[i].buf_p, 0);
-	}
-}
-
-static void
-finish_cursor(bt_status_t *curs)
-{
-	ASSERT(curs->num_free_blocks == 0);
-	free(curs->btree_blocks);
-}
-
 /*
  * Scoop up leftovers from a rebuild cursor for later freeing, then free the
  * rebuild context.
@@ -537,30 +321,6 @@ _("Insufficient memory saving lost blocks.\n"));
 	xrep_newbt_destroy(&btr->newbt, 0);
 }
 
-/* Map btnum to buffer ops for the types that need it. */
-static const struct xfs_buf_ops *
-btnum_to_ops(
-	xfs_btnum_t	btnum)
-{
-	switch (btnum) {
-	case XFS_BTNUM_BNO:
-		return &xfs_bnobt_buf_ops;
-	case XFS_BTNUM_CNT:
-		return &xfs_cntbt_buf_ops;
-	case XFS_BTNUM_INO:
-		return &xfs_inobt_buf_ops;
-	case XFS_BTNUM_FINO:
-		return &xfs_finobt_buf_ops;
-	case XFS_BTNUM_RMAP:
-		return &xfs_rmapbt_buf_ops;
-	case XFS_BTNUM_REFC:
-		return &xfs_refcountbt_buf_ops;
-	default:
-		ASSERT(0);
-		return NULL;
-	}
-}
-
 /*
  * Free Space Btrees
  *

