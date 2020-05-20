Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5441DA789
	for <lists+linux-xfs@lfdr.de>; Wed, 20 May 2020 03:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgETBxb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 May 2020 21:53:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43756 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgETBxb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 21:53:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1pl3Z180767;
        Wed, 20 May 2020 01:53:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=QNm+/+VL8MRPzp2LiVTkFF66ywkdUn7c/mGYJz9K4bA=;
 b=BgRAfRy/b6VC8aFIZ9iD1QhbzZEwb8N/9CojBigeJP9ciRYxKbrHphMMdjsuO8lEKe81
 IWZrywIe4LYc13p9/agd1JYwrzIEFVJG+3sZh6ftXd3UI97ZRUPwp7NTrMazHs2UMoVy
 07hoD3rYDvHfmWxhURWNcWUuApfQla+uJdxjeYP+bvQzx+Ejn1NtVUoMCD7B8PN6GFM1
 J7As83Q2Ztft4qw81PQEUtzL4hwF46vSvjsryWhZV9vgCkPXd/IQsQJFiGYvrD/lYmXC
 QTY4nN6yP6sVEXiyY7UfIGYJh60TTeuZJqkQGXwyzOkJqK5T7KgZOgZd+F846Z/YnTzI fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31284m0huc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 01:53:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04K1n8i8041887;
        Wed, 20 May 2020 01:51:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 312sxtuhx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 May 2020 01:51:24 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04K1pMxI006456;
        Wed, 20 May 2020 01:51:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 18:51:22 -0700
Subject: [PATCH 6/9] xfs_repair: rebuild reverse mapping btrees with bulk
 loader
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Tue, 19 May 2020 18:51:21 -0700
Message-ID: <158993948149.983175.3544814137217516176.stgit@magnolia>
In-Reply-To: <158993944270.983175.4120094597556662259.stgit@magnolia>
References: <158993944270.983175.4120094597556662259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=2 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005200012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005200013
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the btree bulk loading functions to rebuild the reverse mapping
btrees and drop the open-coded implementation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    1 
 repair/phase5.c          |  425 +++++++---------------------------------------
 2 files changed, 70 insertions(+), 356 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 5d0868c2..0026ca45 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -142,6 +142,7 @@
 #define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
 #define xfs_rmapbt_init_cursor		libxfs_rmapbt_init_cursor
 #define xfs_rmapbt_maxrecs		libxfs_rmapbt_maxrecs
+#define xfs_rmapbt_stage_cursor		libxfs_rmapbt_stage_cursor
 #define xfs_rmap_compare		libxfs_rmap_compare
 #define xfs_rmap_get_rec		libxfs_rmap_get_rec
 #define xfs_rmap_irec_offset_pack	libxfs_rmap_irec_offset_pack
diff --git a/repair/phase5.c b/repair/phase5.c
index 38f30753..bb32fd4f 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -1078,373 +1078,84 @@ build_agi(
 
 /* rebuild the rmap tree */
 
-/*
- * we don't have to worry here about how chewing up free extents
- * may perturb things because rmap tree building happens before
- * freespace tree building.
- */
+/* Set up the rmap rebuild parameters. */
 static void
 init_rmapbt_cursor(
-	struct xfs_mount	*mp,
+	struct repair_ctx	*sc,
 	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs)
+	unsigned int		free_space,
+	struct bt_rebuild	*btr)
 {
-	size_t			num_recs;
-	int			level;
-	struct bt_stat_level	*lptr;
-	struct bt_stat_level	*p_lptr;
-	xfs_extlen_t		blocks_allocated;
-	int			maxrecs;
-
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-		memset(btree_curs, 0, sizeof(struct bt_status));
-		return;
-	}
-
-	lptr = &btree_curs->level[0];
-	btree_curs->init = 1;
-	btree_curs->owner = XFS_RMAP_OWN_AG;
-
-	/*
-	 * build up statistics
-	 */
-	num_recs = rmap_record_count(mp, agno);
-	if (num_recs == 0) {
-		/*
-		 * easy corner-case -- no rmap records
-		 */
-		lptr->num_blocks = 1;
-		lptr->modulo = 0;
-		lptr->num_recs_pb = 0;
-		lptr->num_recs_tot = 0;
-
-		btree_curs->num_levels = 1;
-		btree_curs->num_tot_blocks = btree_curs->num_free_blocks = 1;
-
-		setup_cursor(mp, agno, btree_curs);
-
-		return;
-	}
-
-	/*
-	 * Leave enough slack in the rmapbt that we can insert the
-	 * metadata AG entries without too many splits.
-	 */
-	maxrecs = mp->m_rmap_mxr[0];
-	if (num_recs > maxrecs)
-		maxrecs -= 10;
-	blocks_allocated = lptr->num_blocks = howmany(num_recs, maxrecs);
-
-	lptr->modulo = num_recs % lptr->num_blocks;
-	lptr->num_recs_pb = num_recs / lptr->num_blocks;
-	lptr->num_recs_tot = num_recs;
-	level = 1;
-
-	if (lptr->num_blocks > 1)  {
-		for (; btree_curs->level[level-1].num_blocks > 1
-				&& level < XFS_BTREE_MAXLEVELS;
-				level++)  {
-			lptr = &btree_curs->level[level];
-			p_lptr = &btree_curs->level[level - 1];
-			lptr->num_blocks = howmany(p_lptr->num_blocks,
-				mp->m_rmap_mxr[1]);
-			lptr->modulo = p_lptr->num_blocks % lptr->num_blocks;
-			lptr->num_recs_pb = p_lptr->num_blocks
-					/ lptr->num_blocks;
-			lptr->num_recs_tot = p_lptr->num_blocks;
-
-			blocks_allocated += lptr->num_blocks;
-		}
-	}
-	ASSERT(lptr->num_blocks == 1);
-	btree_curs->num_levels = level;
-
-	btree_curs->num_tot_blocks = btree_curs->num_free_blocks
-			= blocks_allocated;
-
-	setup_cursor(mp, agno, btree_curs);
-}
-
-static void
-prop_rmap_cursor(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs,
-	struct xfs_rmap_irec	*rm_rec,
-	int			level)
-{
-	struct xfs_btree_block	*bt_hdr;
-	struct xfs_rmap_key	*bt_key;
-	xfs_rmap_ptr_t		*bt_ptr;
-	xfs_agblock_t		agbno;
-	struct bt_stat_level	*lptr;
-	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_RMAP);
 	int			error;
 
-	level++;
-
-	if (level >= btree_curs->num_levels)
+	if (!xfs_sb_version_hasrmapbt(&sc->mp->m_sb)) {
+		skip_rebuild(btr);
 		return;
-
-	lptr = &btree_curs->level[level];
-	bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-
-	if (be16_to_cpu(bt_hdr->bb_numrecs) == 0)  {
-		/*
-		 * this only happens once to initialize the
-		 * first path up the left side of the tree
-		 * where the agbno's are already set up
-		 */
-		prop_rmap_cursor(mp, agno, btree_curs, rm_rec, level);
-	}
-
-	if (be16_to_cpu(bt_hdr->bb_numrecs) ==
-				lptr->num_recs_pb + (lptr->modulo > 0))  {
-		/*
-		 * write out current prev block, grab us a new block,
-		 * and set the rightsib pointer of current block
-		 */
-#ifdef XR_BLD_INO_TRACE
-		fprintf(stderr, " rmap prop agbno %d ", lptr->prev_agbno);
-#endif
-		if (lptr->prev_agbno != NULLAGBLOCK)  {
-			ASSERT(lptr->prev_buf_p != NULL);
-			libxfs_buf_mark_dirty(lptr->prev_buf_p);
-			libxfs_buf_relse(lptr->prev_buf_p);
-		}
-		lptr->prev_agbno = lptr->agbno;
-		lptr->prev_buf_p = lptr->buf_p;
-		agbno = get_next_blockaddr(agno, level, btree_curs);
-
-		bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(agbno);
-
-		error = -libxfs_buf_get(mp->m_dev,
-				XFS_AGB_TO_DADDR(mp, agno, agbno),
-				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
-		if (error)
-			do_error(_("Cannot grab rmapbt buffer, err=%d"),
-					error);
-		lptr->agbno = agbno;
-
-		if (lptr->modulo)
-			lptr->modulo--;
-
-		/*
-		 * initialize block header
-		 */
-		lptr->buf_p->b_ops = ops;
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
-					level, 0, agno);
-
-		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-
-		/*
-		 * propagate extent record for first extent in new block up
-		 */
-		prop_rmap_cursor(mp, agno, btree_curs, rm_rec, level);
 	}
-	/*
-	 * add rmap info to current block
-	 */
-	be16_add_cpu(&bt_hdr->bb_numrecs, 1);
 
-	bt_key = XFS_RMAP_KEY_ADDR(bt_hdr,
-				    be16_to_cpu(bt_hdr->bb_numrecs));
-	bt_ptr = XFS_RMAP_PTR_ADDR(bt_hdr,
-				    be16_to_cpu(bt_hdr->bb_numrecs),
-				    mp->m_rmap_mxr[1]);
+	init_rebuild(sc, &XFS_RMAP_OINFO_AG, free_space, btr);
+	btr->cur = libxfs_rmapbt_stage_cursor(sc->mp, &btr->newbt.afake, agno);
 
-	bt_key->rm_startblock = cpu_to_be32(rm_rec->rm_startblock);
-	bt_key->rm_owner = cpu_to_be64(rm_rec->rm_owner);
-	bt_key->rm_offset = cpu_to_be64(rm_rec->rm_offset);
+	/* Compute how many blocks we'll need. */
+	error = -libxfs_btree_bload_compute_geometry(btr->cur, &btr->bload,
+			rmap_record_count(sc->mp, agno));
+	if (error)
+		do_error(
+_("Unable to compute rmap btree geometry, error %d.\n"), error);
 
-	*bt_ptr = cpu_to_be32(btree_curs->level[level-1].agbno);
+	setup_rebuild(sc->mp, agno, btr, btr->bload.nr_blocks);
 }
 
-static void
-prop_rmap_highkey(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs,
-	struct xfs_rmap_irec	*rm_highkey)
+/* Grab one rmap record. */
+static int
+get_rmapbt_record(
+	struct xfs_btree_cur		*cur,
+	void				*priv)
 {
-	struct xfs_btree_block	*bt_hdr;
-	struct xfs_rmap_key	*bt_key;
-	struct bt_stat_level	*lptr;
-	struct xfs_rmap_irec	key = {0};
-	struct xfs_rmap_irec	high_key;
-	int			level;
-	int			i;
-	int			numrecs;
+	struct xfs_rmap_irec		*rec;
+	struct bt_rebuild		*btr = priv;
 
-	high_key = *rm_highkey;
-	for (level = 1; level < btree_curs->num_levels; level++) {
-		lptr = &btree_curs->level[level];
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		numrecs = be16_to_cpu(bt_hdr->bb_numrecs);
-		bt_key = XFS_RMAP_HIGH_KEY_ADDR(bt_hdr, numrecs);
-
-		bt_key->rm_startblock = cpu_to_be32(high_key.rm_startblock);
-		bt_key->rm_owner = cpu_to_be64(high_key.rm_owner);
-		bt_key->rm_offset = cpu_to_be64(
-				libxfs_rmap_irec_offset_pack(&high_key));
-
-		for (i = 1; i <= numrecs; i++) {
-			bt_key = XFS_RMAP_HIGH_KEY_ADDR(bt_hdr, i);
-			key.rm_startblock = be32_to_cpu(bt_key->rm_startblock);
-			key.rm_owner = be64_to_cpu(bt_key->rm_owner);
-			key.rm_offset = be64_to_cpu(bt_key->rm_offset);
-			if (rmap_diffkeys(&key, &high_key) > 0)
-				high_key = key;
-		}
-	}
+	rec = pop_slab_cursor(btr->slab_cursor);
+	memcpy(&cur->bc_rec.r, rec, sizeof(struct xfs_rmap_irec));
+	return 0;
 }
 
-/*
- * rebuilds a rmap btree given a cursor.
- */
+/* Rebuild a rmap btree. */
 static void
 build_rmap_tree(
-	struct xfs_mount	*mp,
+	struct repair_ctx	*sc,
 	xfs_agnumber_t		agno,
-	struct bt_status	*btree_curs)
+	struct bt_rebuild	*btr)
 {
-	xfs_agnumber_t		i;
-	xfs_agblock_t		j;
-	xfs_agblock_t		agbno;
-	struct xfs_btree_block	*bt_hdr;
-	struct xfs_rmap_irec	*rm_rec;
-	struct xfs_slab_cursor	*rmap_cur;
-	struct xfs_rmap_rec	*bt_rec;
-	struct xfs_rmap_irec	highest_key = {0};
-	struct xfs_rmap_irec	hi_key = {0};
-	struct bt_stat_level	*lptr;
-	const struct xfs_buf_ops *ops = btnum_to_ops(XFS_BTNUM_RMAP);
-	int			numrecs;
-	int			level = btree_curs->num_levels;
 	int			error;
 
-	highest_key.rm_flags = 0;
-	for (i = 0; i < level; i++)  {
-		lptr = &btree_curs->level[i];
+	btr->bload.get_record = get_rmapbt_record;
+	btr->bload.claim_block = rebuild_claim_block;
 
-		agbno = get_next_blockaddr(agno, i, btree_curs);
-		error = -libxfs_buf_get(mp->m_dev,
-				XFS_AGB_TO_DADDR(mp, agno, agbno),
-				XFS_FSB_TO_BB(mp, 1), &lptr->buf_p);
-		if (error)
-			do_error(_("Cannot grab rmapbt buffer, err=%d"),
-					error);
-
-		if (i == btree_curs->num_levels - 1)
-			btree_curs->root = agbno;
-
-		lptr->agbno = agbno;
-		lptr->prev_agbno = NULLAGBLOCK;
-		lptr->prev_buf_p = NULL;
-		/*
-		 * initialize block header
-		 */
-
-		lptr->buf_p->b_ops = ops;
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
-					i, 0, agno);
-	}
-
-	/*
-	 * run along leaf, setting up records.  as we have to switch
-	 * blocks, call the prop_rmap_cursor routine to set up the new
-	 * pointers for the parent.  that can recurse up to the root
-	 * if required.  set the sibling pointers for leaf level here.
-	 */
-	error = rmap_init_cursor(agno, &rmap_cur);
+	error = -libxfs_trans_alloc_empty(sc->mp, &sc->tp);
 	if (error)
 		do_error(
-_("Insufficient memory to construct reverse-map cursor."));
-	rm_rec = pop_slab_cursor(rmap_cur);
-	lptr = &btree_curs->level[0];
-
-	for (i = 0; i < lptr->num_blocks; i++)  {
-		numrecs = lptr->num_recs_pb + (lptr->modulo > 0);
-		ASSERT(rm_rec != NULL || numrecs == 0);
-
-		/*
-		 * block initialization, lay in block header
-		 */
-		lptr->buf_p->b_ops = ops;
-		bt_hdr = XFS_BUF_TO_BLOCK(lptr->buf_p);
-		memset(bt_hdr, 0, mp->m_sb.sb_blocksize);
-		libxfs_btree_init_block(mp, lptr->buf_p, XFS_BTNUM_RMAP,
-					0, 0, agno);
-
-		bt_hdr->bb_u.s.bb_leftsib = cpu_to_be32(lptr->prev_agbno);
-		bt_hdr->bb_numrecs = cpu_to_be16(numrecs);
-
-		if (lptr->modulo > 0)
-			lptr->modulo--;
-
-		if (lptr->num_recs_pb > 0) {
-			ASSERT(rm_rec != NULL);
-			prop_rmap_cursor(mp, agno, btree_curs, rm_rec, 0);
-		}
+_("Insufficient memory to construct rmap rebuild transaction.\n"));
 
-		bt_rec = (struct xfs_rmap_rec *)
-			  ((char *)bt_hdr + XFS_RMAP_BLOCK_LEN);
-		highest_key.rm_startblock = 0;
-		highest_key.rm_owner = 0;
-		highest_key.rm_offset = 0;
-		for (j = 0; j < be16_to_cpu(bt_hdr->bb_numrecs); j++) {
-			ASSERT(rm_rec != NULL);
-			bt_rec[j].rm_startblock =
-					cpu_to_be32(rm_rec->rm_startblock);
-			bt_rec[j].rm_blockcount =
-					cpu_to_be32(rm_rec->rm_blockcount);
-			bt_rec[j].rm_owner = cpu_to_be64(rm_rec->rm_owner);
-			bt_rec[j].rm_offset = cpu_to_be64(
-					libxfs_rmap_irec_offset_pack(rm_rec));
-			rmap_high_key_from_rec(rm_rec, &hi_key);
-			if (rmap_diffkeys(&hi_key, &highest_key) > 0)
-				highest_key = hi_key;
-
-			rm_rec = pop_slab_cursor(rmap_cur);
-		}
-
-		/* Now go set the parent key */
-		prop_rmap_highkey(mp, agno, btree_curs, &highest_key);
+	error = rmap_init_cursor(agno, &btr->slab_cursor);
+	if (error)
+		do_error(
+_("Insufficient memory to construct rmap cursor.\n"));
 
-		if (rm_rec != NULL)  {
-			/*
-			 * get next leaf level block
-			 */
-			if (lptr->prev_buf_p != NULL)  {
-#ifdef XR_BLD_RL_TRACE
-				fprintf(stderr, "writing rmapbt agbno %u\n",
-					lptr->prev_agbno);
-#endif
-				ASSERT(lptr->prev_agbno != NULLAGBLOCK);
-				libxfs_buf_mark_dirty(lptr->prev_buf_p);
-				libxfs_buf_relse(lptr->prev_buf_p);
-			}
-			lptr->prev_buf_p = lptr->buf_p;
-			lptr->prev_agbno = lptr->agbno;
-			lptr->agbno = get_next_blockaddr(agno, 0, btree_curs);
-			bt_hdr->bb_u.s.bb_rightsib = cpu_to_be32(lptr->agbno);
+	/* Add all observed rmap records. */
+	error = -libxfs_btree_bload(btr->cur, &btr->bload, btr);
+	if (error)
+		do_error(
+_("Error %d while creating rmap btree for AG %u.\n"), error, agno);
 
-			error = -libxfs_buf_get(mp->m_dev,
-					XFS_AGB_TO_DADDR(mp, agno, lptr->agbno),
-					XFS_FSB_TO_BB(mp, 1),
-					&lptr->buf_p);
-			if (error)
-				do_error(
-	_("Cannot grab rmapbt buffer, err=%d"),
-						error);
-		}
-	}
-	free_slab_cursor(&rmap_cur);
+	/* Since we're not writing the AGF yet, no need to commit the cursor */
+	libxfs_btree_del_cursor(btr->cur, 0);
+	free_slab_cursor(&btr->slab_cursor);
+	error = -libxfs_trans_commit(sc->tp);
+	if (error)
+		do_error(
+_("Error %d while writing rmap btree for AG %u.\n"), error, agno);
+	sc->tp = NULL;
 }
 
 /* rebuild the refcount tree */
@@ -1789,7 +1500,7 @@ build_agf_agfl(
 	struct bt_rebuild	*btr_cnt,
 	xfs_extlen_t		freeblks,	/* # free blocks in tree */
 	int			lostblocks,	/* # blocks that will be lost */
-	struct bt_status	*rmap_bt,
+	struct bt_rebuild	*btr_rmap,
 	struct bt_status	*refcnt_bt,
 	struct xfs_slab		*lost_fsb)
 {
@@ -1837,11 +1548,17 @@ build_agf_agfl(
 			cpu_to_be32(btr_cnt->newbt.afake.af_root);
 	agf->agf_levels[XFS_BTNUM_CNT] =
 			cpu_to_be32(btr_cnt->newbt.afake.af_levels);
-	agf->agf_roots[XFS_BTNUM_RMAP] = cpu_to_be32(rmap_bt->root);
-	agf->agf_levels[XFS_BTNUM_RMAP] = cpu_to_be32(rmap_bt->num_levels);
 	agf->agf_freeblks = cpu_to_be32(freeblks);
-	agf->agf_rmap_blocks = cpu_to_be32(rmap_bt->num_tot_blocks -
-			rmap_bt->num_free_blocks);
+
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		agf->agf_roots[XFS_BTNUM_RMAP] =
+				cpu_to_be32(btr_rmap->newbt.afake.af_root);
+		agf->agf_levels[XFS_BTNUM_RMAP] =
+				cpu_to_be32(btr_rmap->newbt.afake.af_levels);
+		agf->agf_rmap_blocks =
+				cpu_to_be32(btr_rmap->newbt.afake.af_blocks);
+	}
+
 	agf->agf_refcount_root = cpu_to_be32(refcnt_bt->root);
 	agf->agf_refcount_level = cpu_to_be32(refcnt_bt->num_levels);
 	agf->agf_refcount_blocks = cpu_to_be32(refcnt_bt->num_tot_blocks -
@@ -1859,7 +1576,7 @@ build_agf_agfl(
 		blks = btr_bno->newbt.afake.af_blocks +
 			btr_cnt->newbt.afake.af_blocks - 2;
 		if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-			blks += rmap_bt->num_tot_blocks - rmap_bt->num_free_blocks - 1;
+			blks += btr_rmap->newbt.afake.af_blocks - 1;
 		agf->agf_btreeblks = cpu_to_be32(blks);
 #ifdef XR_BLD_FREE_TRACE
 		fprintf(stderr, "agf->agf_btreeblks = %u\n",
@@ -1904,6 +1621,8 @@ build_agf_agfl(
 	freelist = xfs_buf_to_agfl_bno(agfl_buf);
 	fill_agfl(btr_bno, freelist, &i);
 	fill_agfl(btr_cnt, freelist, &i);
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		fill_agfl(btr_rmap, freelist, &i);
 
 	/* Set the AGF counters for the AGFL. */
 	if (i > 0) {
@@ -2004,7 +1723,7 @@ phase5_func(
 	struct bt_rebuild	btr_cnt;
 	struct bt_rebuild	btr_ino;
 	struct bt_rebuild	btr_fino;
-	bt_status_t		rmap_btree_curs;
+	struct bt_rebuild	btr_rmap;
 	bt_status_t		refcnt_btree_curs;
 	int			extra_blocks = 0;
 	uint			num_freeblocks;
@@ -2041,11 +1760,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	init_ino_cursors(&sc, agno, num_freeblocks, &sb_icount_ag[agno],
 			&sb_ifree_ag[agno], &btr_ino, &btr_fino);
 
-	/*
-	 * Set up the btree cursors for the on-disk rmap btrees, which includes
-	 * pre-allocating all required blocks.
-	 */
-	init_rmapbt_cursor(mp, agno, &rmap_btree_curs);
+	init_rmapbt_cursor(&sc, agno, num_freeblocks, &btr_rmap);
 
 	/*
 	 * Set up the btree cursors for the on-disk refcount btrees,
@@ -2112,10 +1827,8 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	ASSERT(freeblks1 == freeblks2);
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-		build_rmap_tree(mp, agno, &rmap_btree_curs);
-		write_cursor(&rmap_btree_curs);
-		sb_fdblocks_ag[agno] += (rmap_btree_curs.num_tot_blocks -
-				rmap_btree_curs.num_free_blocks) - 1;
+		build_rmap_tree(&sc, agno, &btr_rmap);
+		sb_fdblocks_ag[agno] += btr_rmap.newbt.afake.af_blocks - 1;
 	}
 
 	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
@@ -2127,7 +1840,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	 * set up agf and agfl
 	 */
 	build_agf_agfl(mp, agno, &btr_bno, &btr_cnt, freeblks1, extra_blocks,
-			&rmap_btree_curs, &refcnt_btree_curs, lost_fsb);
+			&btr_rmap, &refcnt_btree_curs, lost_fsb);
 
 	/*
 	 * build inode allocation trees.
@@ -2148,7 +1861,7 @@ _("unable to rebuild AG %u.  Not enough free space in on-disk AG.\n"),
 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
 		finish_rebuild(mp, &btr_fino, lost_fsb);
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		finish_cursor(&rmap_btree_curs);
+		finish_rebuild(mp, &btr_rmap, lost_fsb);
 	if (xfs_sb_version_hasreflink(&mp->m_sb))
 		finish_cursor(&refcnt_btree_curs);
 

