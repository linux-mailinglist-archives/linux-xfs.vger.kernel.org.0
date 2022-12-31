Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F4D659F57
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 01:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbiLaAQZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 19:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbiLaAQY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:16:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4357CD2FB
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:16:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C634161CEF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EED5C433EF;
        Sat, 31 Dec 2022 00:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445782;
        bh=AQiWqb725irxESDpareK/XGXKCleC6c9urkFzJY0yuM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EkDtV3b7qXuu/IkxRssUMJ3gkXOFnUSttnHphRaOOtGmzNwR+snX22asfFxt6ZRZ8
         5sXDipUwdiU8FjRJqtKAvqmqlqte5zoUHfMNa/lkMk99wB9TD4RYdX0RT32iUOEjjx
         vZ1F6PKt3Caz1E7SMs66wz4NxDJ6f8NXsAWV2MfONJVzXkGx4OJXcG0bFbWNhPpEh5
         CqjK8H0lTs4o/U/PKk9iNZxKijwJ0jtp/XNNBwCMoJ0CATyeQXyIi5JuuL2WmetqsW
         IsANox7xHRn0Vu9tCF/7OuxObWT2x6idsCc/WaowSdg0gZ042tEJfWaH29FiawNfoA
         2qPsvVLG+btbg==
Subject: [PATCH 6/6] xfs_repair: remove the old rmap collection slabs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:49 -0800
Message-ID: <167243866969.712584.3032346338975046576.stgit@magnolia>
In-Reply-To: <167243866890.712584.9795710743681868714.stgit@magnolia>
References: <167243866890.712584.9795710743681868714.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've switched the offline repair code to use an in-memory
rmap btree for everything except recording the rmaps for the newly
generated per-AG btrees, get rid of all the old code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    9 +--
 repair/phase4.c |   23 -------
 repair/rmap.c   |  189 +++++++++----------------------------------------------
 repair/rmap.h   |   16 ++---
 repair/scan.c   |    7 --
 5 files changed, 42 insertions(+), 202 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 5e664eab7ea..ee34a62ae8b 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -625,13 +625,8 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 				break;
 			}
 		}
-		if (collect_rmaps) { /* && !check_dups */
-			error = rmap_add_rec(mp, ino, whichfork, &irec);
-			if (error)
-				do_error(
-_("couldn't add reverse mapping\n")
-					);
-		}
+		if (collect_rmaps) /* && !check_dups */
+			rmap_add_rec(mp, ino, whichfork, &irec);
 		*tot += irec.br_blockcount;
 	}
 	error = 0;
diff --git a/repair/phase4.c b/repair/phase4.c
index b8a6992706a..b5e713aaa82 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -142,17 +142,7 @@ static void
 process_ags(
 	xfs_mount_t		*mp)
 {
-	xfs_agnumber_t		i;
-	int			error;
-
 	do_inode_prefetch(mp, ag_stride, process_ag_func, true, false);
-	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
-		error = rmap_finish_collecting_fork_recs(mp, i);
-		if (error)
-			do_error(
-_("unable to finish adding attr/data fork reverse-mapping data for AG %u.\n"),
-				i);
-	}
 }
 
 static void
@@ -161,18 +151,7 @@ check_rmap_btrees(
 	xfs_agnumber_t	agno,
 	void		*arg)
 {
-	int		error;
-
-	error = rmap_add_fixed_ag_rec(wq->wq_ctx, agno);
-	if (error)
-		do_error(
-_("unable to add AG %u metadata reverse-mapping data.\n"), agno);
-
-	error = rmap_fold_raw_recs(wq->wq_ctx, agno);
-	if (error)
-		do_error(
-_("unable to merge AG %u metadata reverse-mapping data.\n"), agno);
-
+	rmap_add_fixed_ag_rec(wq->wq_ctx, agno);
 	rmaps_verify_btree(wq->wq_ctx, agno);
 }
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 87123f5331d..e598dd9c9b8 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -27,11 +27,9 @@
 /* per-AG rmap object anchor */
 struct xfs_ag_rmap {
 	struct xfbtree	*ar_xfbtree;		/* rmap observations */
-	struct xfs_slab	*ar_rmaps;		/* rmap observations, p4 */
-	struct xfs_slab	*ar_raw_rmaps;		/* unmerged rmaps */
+	struct xfs_slab	*ar_agbtree_rmaps;	/* rmaps for rebuilt ag btrees */
 	int		ar_flcount;		/* agfl entries from leftover */
 						/* agbt allocations */
-	struct xfs_rmap_irec	ar_last_rmap;	/* last rmap seen */
 	struct xfs_slab	*ar_refcount_items;	/* refcount items, p4-5 */
 };
 
@@ -72,6 +70,7 @@ rmaps_destroy(
 	struct xfile		*xfile;
 	struct xfs_buftarg	*target;
 
+	free_slab(&ag_rmap->ar_agbtree_rmaps);
 	free_slab(&ag_rmap->ar_refcount_items);
 
 	if (!ag_rmap->ar_xfbtree)
@@ -116,6 +115,11 @@ rmaps_init_ag(
 	if (error)
 		goto nomem;
 
+	error = init_slab(&ag_rmap->ar_agbtree_rmaps,
+			sizeof(struct xfs_rmap_irec));
+	if (error)
+		goto nomem;
+
 	return;
 nomem:
 	do_error(
@@ -130,7 +134,6 @@ rmaps_init(
 	struct xfs_mount	*mp)
 {
 	xfs_agnumber_t		i;
-	int			error;
 
 	if (!rmap_needs_work(mp))
 		return;
@@ -139,21 +142,8 @@ rmaps_init(
 	if (!ag_rmaps)
 		do_error(_("couldn't allocate per-AG reverse map roots\n"));
 
-	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		rmaps_init_ag(mp, i, &ag_rmaps[i]);
-
-		error = init_slab(&ag_rmaps[i].ar_rmaps,
-				sizeof(struct xfs_rmap_irec));
-		if (error)
-			do_error(
-_("Insufficient memory while allocating reverse mapping slabs."));
-		error = init_slab(&ag_rmaps[i].ar_raw_rmaps,
-				  sizeof(struct xfs_rmap_irec));
-		if (error)
-			do_error(
-_("Insufficient memory while allocating raw metadata reverse mapping slabs."));
-		ag_rmaps[i].ar_last_rmap.rm_owner = XFS_RMAP_OWN_UNKNOWN;
-	}
 }
 
 /*
@@ -168,11 +158,8 @@ rmaps_free(
 	if (!rmap_needs_work(mp))
 		return;
 
-	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
-		free_slab(&ag_rmaps[i].ar_rmaps);
-		free_slab(&ag_rmaps[i].ar_raw_rmaps);
+	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		rmaps_destroy(mp, &ag_rmaps[i]);
-	}
 	free(ag_rmaps);
 	ag_rmaps = NULL;
 }
@@ -303,7 +290,7 @@ rmap_add_mem_rec(
  * Add an observation about a block mapping in an inode's data or attribute
  * fork for later btree reconstruction.
  */
-int
+void
 rmap_add_rec(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
@@ -313,11 +300,9 @@ rmap_add_rec(
 	struct xfs_rmap_irec	rmap;
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
-	struct xfs_rmap_irec	*last_rmap;
-	int			error = 0;
 
 	if (!rmap_needs_work(mp))
-		return 0;
+		return;
 
 	agno = XFS_FSB_TO_AGNO(mp, irec->br_startblock);
 	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
@@ -338,36 +323,10 @@ rmap_add_rec(
 		rmap.rm_flags |= XFS_RMAP_UNWRITTEN;
 
 	rmap_add_mem_rec(mp, agno, &rmap);
-
-	last_rmap = &ag_rmaps[agno].ar_last_rmap;
-	if (last_rmap->rm_owner == XFS_RMAP_OWN_UNKNOWN)
-		*last_rmap = rmap;
-	else if (rmaps_are_mergeable(last_rmap, &rmap))
-		last_rmap->rm_blockcount += rmap.rm_blockcount;
-	else {
-		error = slab_add(ag_rmaps[agno].ar_rmaps, last_rmap);
-		if (error)
-			return error;
-		*last_rmap = rmap;
-	}
-
-	return error;
-}
-
-/* Finish collecting inode data/attr fork rmaps. */
-int
-rmap_finish_collecting_fork_recs(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	if (!rmap_needs_work(mp) ||
-	    ag_rmaps[agno].ar_last_rmap.rm_owner == XFS_RMAP_OWN_UNKNOWN)
-		return 0;
-	return slab_add(ag_rmaps[agno].ar_rmaps, &ag_rmaps[agno].ar_last_rmap);
 }
 
 /* add a raw rmap; these will be merged later */
-static int
+static void
 __rmap_add_raw_rec(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
@@ -391,13 +350,12 @@ __rmap_add_raw_rec(
 	rmap.rm_blockcount = len;
 
 	rmap_add_mem_rec(mp, agno, &rmap);
-	return slab_add(ag_rmaps[agno].ar_raw_rmaps, &rmap);
 }
 
 /*
  * Add a reverse mapping for an inode fork's block mapping btree block.
  */
-int
+void
 rmap_add_bmbt_rec(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
@@ -408,7 +366,7 @@ rmap_add_bmbt_rec(
 	xfs_agblock_t		agbno;
 
 	if (!rmap_needs_work(mp))
-		return 0;
+		return;
 
 	agno = XFS_FSB_TO_AGNO(mp, fsbno);
 	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
@@ -416,14 +374,14 @@ rmap_add_bmbt_rec(
 	ASSERT(agno < mp->m_sb.sb_agcount);
 	ASSERT(agbno + 1 <= mp->m_sb.sb_agblocks);
 
-	return __rmap_add_raw_rec(mp, agno, agbno, 1, ino,
-			whichfork == XFS_ATTR_FORK, true);
+	__rmap_add_raw_rec(mp, agno, agbno, 1, ino, whichfork == XFS_ATTR_FORK,
+			true);
 }
 
 /*
  * Add a reverse mapping for a per-AG fixed metadata extent.
  */
-int
+STATIC void
 rmap_add_ag_rec(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
@@ -432,13 +390,13 @@ rmap_add_ag_rec(
 	uint64_t		owner)
 {
 	if (!rmap_needs_work(mp))
-		return 0;
+		return;
 
 	ASSERT(agno != NULLAGNUMBER);
 	ASSERT(agno < mp->m_sb.sb_agcount);
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 
-	return __rmap_add_raw_rec(mp, agno, agbno, len, owner, false, false);
+	__rmap_add_raw_rec(mp, agno, agbno, len, owner, false, false);
 }
 
 /*
@@ -468,62 +426,7 @@ rmap_add_agbtree_mapping(
 	assert(libxfs_verify_agbext(pag, agbno, len));
 	libxfs_perag_put(pag);
 
-	return slab_add(ag_rmaps[agno].ar_raw_rmaps, &rmap);
-}
-
-/*
- * Merge adjacent raw rmaps and add them to the main rmap list.
- */
-int
-rmap_fold_raw_recs(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	struct xfs_slab_cursor	*cur = NULL;
-	struct xfs_rmap_irec	*prev, *rec;
-	uint64_t		old_sz;
-	int			error = 0;
-
-	old_sz = slab_count(ag_rmaps[agno].ar_rmaps);
-	if (slab_count(ag_rmaps[agno].ar_raw_rmaps) == 0)
-		goto no_raw;
-	qsort_slab(ag_rmaps[agno].ar_raw_rmaps, rmap_compare);
-	error = init_slab_cursor(ag_rmaps[agno].ar_raw_rmaps, rmap_compare,
-			&cur);
-	if (error)
-		goto err;
-
-	prev = pop_slab_cursor(cur);
-	rec = pop_slab_cursor(cur);
-	while (prev && rec) {
-		if (rmaps_are_mergeable(prev, rec)) {
-			prev->rm_blockcount += rec->rm_blockcount;
-			rec = pop_slab_cursor(cur);
-			continue;
-		}
-		error = slab_add(ag_rmaps[agno].ar_rmaps, prev);
-		if (error)
-			goto err;
-		prev = rec;
-		rec = pop_slab_cursor(cur);
-	}
-	if (prev) {
-		error = slab_add(ag_rmaps[agno].ar_rmaps, prev);
-		if (error)
-			goto err;
-	}
-	free_slab(&ag_rmaps[agno].ar_raw_rmaps);
-	error = init_slab(&ag_rmaps[agno].ar_raw_rmaps,
-			sizeof(struct xfs_rmap_irec));
-	if (error)
-		do_error(
-_("Insufficient memory while allocating raw metadata reverse mapping slabs."));
-no_raw:
-	if (old_sz)
-		qsort_slab(ag_rmaps[agno].ar_rmaps, rmap_compare);
-err:
-	free_slab_cursor(&cur);
-	return error;
+	return slab_add(ag_rmaps[agno].ar_agbtree_rmaps, &rmap);
 }
 
 static int
@@ -560,7 +463,7 @@ popcnt(
  * Add an allocation group's fixed metadata to the rmap list.  This includes
  * sb/agi/agf/agfl headers, inode chunks, and the log.
  */
-int
+void
 rmap_add_fixed_ag_rec(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
@@ -569,18 +472,14 @@ rmap_add_fixed_ag_rec(
 	xfs_agblock_t		agbno;
 	ino_tree_node_t		*ino_rec;
 	xfs_agino_t		agino;
-	int			error;
 	int			startidx;
 	int			nr;
 
 	if (!rmap_needs_work(mp))
-		return 0;
+		return;
 
 	/* sb/agi/agf/agfl headers */
-	error = rmap_add_ag_rec(mp, agno, 0, XFS_BNO_BLOCK(mp),
-			XFS_RMAP_OWN_FS);
-	if (error)
-		goto out;
+	rmap_add_ag_rec(mp, agno, 0, XFS_BNO_BLOCK(mp), XFS_RMAP_OWN_FS);
 
 	/* inodes */
 	ino_rec = findfirst_inode_rec(agno);
@@ -598,10 +497,8 @@ rmap_add_fixed_ag_rec(
 		agino = ino_rec->ino_startnum + startidx;
 		agbno = XFS_AGINO_TO_AGBNO(mp, agino);
 		if (XFS_AGINO_TO_OFFSET(mp, agino) == 0) {
-			error = rmap_add_ag_rec(mp, agno, agbno, nr,
+			rmap_add_ag_rec(mp, agno, agbno, nr,
 					XFS_RMAP_OWN_INODES);
-			if (error)
-				goto out;
 		}
 	}
 
@@ -609,13 +506,9 @@ rmap_add_fixed_ag_rec(
 	fsbno = mp->m_sb.sb_logstart;
 	if (fsbno && XFS_FSB_TO_AGNO(mp, fsbno) == agno) {
 		agbno = XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart);
-		error = rmap_add_ag_rec(mp, agno, agbno, mp->m_sb.sb_logblocks,
+		rmap_add_ag_rec(mp, agno, agbno, mp->m_sb.sb_logblocks,
 				XFS_RMAP_OWN_LOG);
-		if (error)
-			goto out;
 	}
-out:
-	return error;
 }
 
 /*
@@ -656,12 +549,6 @@ rmap_commit_agbtree_mappings(
 	if (!xfs_has_rmapbt(mp))
 		return 0;
 
-	/* Release the ar_rmaps; they were put into the rmapbt during p5. */
-	free_slab(&ag_rmap->ar_rmaps);
-	error = init_slab(&ag_rmap->ar_rmaps, sizeof(struct xfs_rmap_irec));
-	if (error)
-		goto err;
-
 	/* Add the AGFL blocks to the rmap list */
 	error = -libxfs_trans_read_buf(
 			mp, NULL, mp->m_ddev_targp,
@@ -685,7 +572,8 @@ rmap_commit_agbtree_mappings(
 	 * space btree blocks, so we must be careful not to create those
 	 * records again.  Create a bitmap of already-recorded OWN_AG rmaps.
 	 */
-	error = init_slab_cursor(ag_rmap->ar_raw_rmaps, rmap_compare, &rm_cur);
+	error = init_slab_cursor(ag_rmap->ar_agbtree_rmaps, rmap_compare,
+			&rm_cur);
 	if (error)
 		goto err;
 	error = -bitmap_alloc(&own_ag_bitmap);
@@ -718,7 +606,7 @@ rmap_commit_agbtree_mappings(
 
 		agbno = be32_to_cpu(*b);
 		if (!bitmap_test(own_ag_bitmap, agbno, 1)) {
-			error = rmap_add_ag_rec(mp, agno, agbno, 1,
+			error = rmap_add_agbtree_mapping(mp, agno, agbno, 1,
 					XFS_RMAP_OWN_AG);
 			if (error)
 				goto err;
@@ -729,13 +617,9 @@ rmap_commit_agbtree_mappings(
 	agflbp = NULL;
 	bitmap_free(&own_ag_bitmap);
 
-	/* Merge all the raw rmaps into the main list */
-	error = rmap_fold_raw_recs(mp, agno);
-	if (error)
-		goto err;
-
 	/* Create cursors to rmap structures */
-	error = init_slab_cursor(ag_rmap->ar_rmaps, rmap_compare, &rm_cur);
+	error = init_slab_cursor(ag_rmap->ar_agbtree_rmaps, rmap_compare,
+			&rm_cur);
 	if (error)
 		goto err;
 
@@ -1104,6 +988,8 @@ compute_refcounts(
 
 	if (!xfs_has_reflink(mp))
 		return 0;
+	if (ag_rmaps[agno].ar_xfbtree == NULL)
+		return 0;
 
 	error = rmap_init_mem_cursor(mp, NULL, agno, &rmcur);
 	if (error)
@@ -1248,17 +1134,6 @@ rmap_record_count(
 	return nr;
 }
 
-/*
- * Return a slab cursor that will return rmap objects in order.
- */
-int
-rmap_init_cursor(
-	xfs_agnumber_t		agno,
-	struct xfs_slab_cursor	**cur)
-{
-	return init_slab_cursor(ag_rmaps[agno].ar_rmaps, rmap_compare, cur);
-}
-
 /*
  * Disable the refcount btree check.
  */
diff --git a/repair/rmap.h b/repair/rmap.h
index d8eec58ab8d..cb6c32af62c 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -14,23 +14,19 @@ extern bool rmap_needs_work(struct xfs_mount *);
 extern void rmaps_init(struct xfs_mount *);
 extern void rmaps_free(struct xfs_mount *);
 
-extern int rmap_add_rec(struct xfs_mount *, xfs_ino_t, int, struct xfs_bmbt_irec *);
-extern int rmap_finish_collecting_fork_recs(struct xfs_mount *mp,
-		xfs_agnumber_t agno);
-extern int rmap_add_ag_rec(struct xfs_mount *, xfs_agnumber_t agno,
-		xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner);
-extern int rmap_add_bmbt_rec(struct xfs_mount *, xfs_ino_t, int, xfs_fsblock_t);
-extern int rmap_fold_raw_recs(struct xfs_mount *mp, xfs_agnumber_t agno);
-extern bool rmaps_are_mergeable(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *r2);
+void rmap_add_rec(struct xfs_mount *mp, xfs_ino_t ino, int whichfork,
+		struct xfs_bmbt_irec *irec);
+void rmap_add_bmbt_rec(struct xfs_mount *mp, xfs_ino_t ino, int whichfork,
+		xfs_fsblock_t fsbno);
+bool rmaps_are_mergeable(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *r2);
 
-extern int rmap_add_fixed_ag_rec(struct xfs_mount *, xfs_agnumber_t);
+void rmap_add_fixed_ag_rec(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 int rmap_add_agbtree_mapping(struct xfs_mount *mp, xfs_agnumber_t agno,
 		xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner);
 int rmap_commit_agbtree_mappings(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 uint64_t rmap_record_count(struct xfs_mount *mp, xfs_agnumber_t agno);
-extern int rmap_init_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
 extern void rmap_avoid_check(void);
 void rmaps_verify_btree(struct xfs_mount *mp, xfs_agnumber_t agno);
 
diff --git a/repair/scan.c b/repair/scan.c
index ac2233b93b7..ff51eb0a602 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -224,7 +224,6 @@ scan_bmapbt(
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	int			state;
-	int			error;
 
 	/*
 	 * unlike the ag freeblock btrees, if anything looks wrong
@@ -413,12 +412,8 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 	if (check_dups && collect_rmaps) {
 		agno = XFS_FSB_TO_AGNO(mp, bno);
 		pthread_mutex_lock(&ag_locks[agno].lock);
-		error = rmap_add_bmbt_rec(mp, ino, whichfork, bno);
+		rmap_add_bmbt_rec(mp, ino, whichfork, bno);
 		pthread_mutex_unlock(&ag_locks[agno].lock);
-		if (error)
-			do_error(
-_("couldn't add inode %"PRIu64" bmbt block %"PRIu64" reverse-mapping data."),
-				ino, bno);
 	}
 
 	if (level == 0) {

