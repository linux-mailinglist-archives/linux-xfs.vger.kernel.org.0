Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1FB659F55
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 01:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbiLaAP4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 19:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiLaAPz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:15:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16C1D2D7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:15:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69067B81E60
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257F1C433EF;
        Sat, 31 Dec 2022 00:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445751;
        bh=qUhBFRLQI7ipFjhz7pHhYkDvYIOR2FK3pbyhDtYskZY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aflsYfnFVIDrIyuKHXA+T7qq3j8WdtqdUuvGzZ1JEk2KuLYB3rpwIdvr0/o+sSozW
         10cCn8bmlSwDj1yuDzdRUD7SbkAkPdyzNN9pY9hGWGjmB21HIhtQRatmyiO1JyELAb
         szebetmYIB3xqeObHx5q42qnFWOUkI/bAs67/FMgbZbX7eTpgfwon/S7c4x1o2FkKC
         5/5BFULGGtKJIGiZThaJe/TJjoq8zO2w1AXIRh7Am1msFI1OYSmeIlZ6lq9a2uCcmo
         HBjmbiHXeEPqdfsSQeLVowIQNGVlat0xSjdLg8AYt5kCb/7KDOT5w531KO6hMzGguX
         yhvZR1O5mPpqQ==
Subject: [PATCH 4/6] xfs_repair: compute refcount data from in-memory rmap
 btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:49 -0800
Message-ID: <167243866942.712584.13682077144189571752.stgit@magnolia>
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

Use the in-memory rmap btrees to compute the reference count
information.  Convert the bag implementation to hold actual records
instead of pointers to slab objects.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    4 +
 repair/phase4.c          |    2 
 repair/rmap.c            |  230 ++++++++++++++++++++++++++++++++++++----------
 repair/slab.c            |   49 ++++++----
 repair/slab.h            |    2 
 5 files changed, 216 insertions(+), 71 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index ce5eb27c1fd..a03cef515a2 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -55,9 +55,11 @@
 
 #define xfs_btree_bload			libxfs_btree_bload
 #define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
+#define xfs_btree_decrement		libxfs_btree_decrement
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
 #define xfs_btree_get_block		libxfs_btree_get_block
 #define xfs_btree_goto_left_edge	libxfs_btree_goto_left_edge
+#define xfs_btree_has_more_records	libxfs_btree_has_more_records
 #define xfs_btree_increment		libxfs_btree_increment
 #define xfs_btree_init_block		libxfs_btree_init_block
 #define xfs_btree_mem_head_read_buf	libxfs_btree_mem_head_read_buf
@@ -150,6 +152,8 @@
 #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
 #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
 
+#define xfs_internal_inum		libxfs_internal_inum
+
 #define xfs_iread_extents		libxfs_iread_extents
 #define xfs_irele			libxfs_irele
 #define xfs_log_calc_minimum_size	libxfs_log_calc_minimum_size
diff --git a/repair/phase4.c b/repair/phase4.c
index 61e5500631a..b8a6992706a 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -188,7 +188,7 @@ compute_ag_refcounts(
 	if (error)
 		do_error(
 _("%s while computing reference count records.\n"),
-			 strerror(-error));
+			 strerror(error));
 }
 
 static void
diff --git a/repair/rmap.c b/repair/rmap.c
index a8d973ecd2a..0a29a615afa 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -934,66 +934,196 @@ refcount_emit(
 _("Insufficient memory while recreating refcount tree."));
 }
 
+#define RMAP_NEXT(r)	((r)->rm_startblock + (r)->rm_blockcount)
+
+/* Decide if an rmap could describe a shared extent. */
+static inline bool
+rmap_shareable(
+	struct xfs_mount		*mp,
+	const struct xfs_rmap_irec	*rmap)
+{
+	/* AG metadata are never sharable */
+	if (XFS_RMAP_NON_INODE_OWNER(rmap->rm_owner))
+		return false;
+
+	/* Metadata in files are never shareable */
+	if (libxfs_internal_inum(mp, rmap->rm_owner))
+		return false;
+
+	/* Metadata and unwritten file blocks are not shareable. */
+	if (rmap->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			      XFS_RMAP_UNWRITTEN))
+		return false;
+
+	return true;
+}
+
+/* Grab the rmap for the next possible shared extent. */
+STATIC int
+refcount_walk_rmaps(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rmap,
+	bool			*have_rec)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	int			have_gt;
+	int			error = 0;
+
+	*have_rec = false;
+
+	/*
+	 * Loop through the remaining rmaps.  Remember CoW staging
+	 * extents and the refcountbt blocks from the old tree for later
+	 * disposal.  We can only share written data fork extents, so
+	 * keep looping until we find an rmap for one.
+	 */
+	do {
+		error = -libxfs_btree_increment(cur, 0, &have_gt);
+		if (error)
+			return error;
+		if (!have_gt)
+			return 0;
+
+		error = -libxfs_rmap_get_rec(cur, rmap, &have_gt);
+		if (error)
+			return error;
+		if (!have_gt)
+			return EFSCORRUPTED;
+	} while (!rmap_shareable(mp, rmap));
+
+	*have_rec = true;
+	return 0;
+}
+
+/*
+ * Find the next block where the refcount changes, given the next rmap we
+ * looked at and the ones we're already tracking.
+ */
+static inline int
+next_refcount_edge(
+	struct xfs_bag		*stack_top,
+	struct xfs_rmap_irec	*next_rmap,
+	bool			next_valid,
+	xfs_agblock_t		*nbnop)
+{
+	struct xfs_rmap_irec	*rmap;
+	uint64_t		idx;
+	xfs_agblock_t		nbno = NULLAGBLOCK;
+
+	if (next_valid)
+		nbno = next_rmap->rm_startblock;
+
+	foreach_bag_ptr(stack_top, idx, rmap)
+		nbno = min(nbno, RMAP_NEXT(rmap));
+
+	/*
+	 * We should have found /something/ because either next_rrm is the next
+	 * interesting rmap to look at after emitting this refcount extent, or
+	 * there are other rmaps in rmap_bag contributing to the current
+	 * sharing count.  But if something is seriously wrong, bail out.
+	 */
+	if (nbno == NULLAGBLOCK)
+		return EFSCORRUPTED;
+
+	*nbnop = nbno;
+	return 0;
+}
+
+/*
+ * Walk forward through the rmap btree to collect all rmaps starting at
+ * @bno in @rmap_bag.  These represent the file(s) that share ownership of
+ * the current block.  Upon return, the rmap cursor points to the last record
+ * satisfying the startblock constraint.
+ */
+static int
+refcount_push_rmaps_at(
+	struct rmap_mem_cur	*rmcur,
+	xfs_agnumber_t		agno,
+	struct xfs_bag		*stack_top,
+	xfs_agblock_t		bno,
+	struct xfs_rmap_irec	*irec,
+	bool			*have,
+	const char		*tag)
+{
+	int			have_gt;
+	int			error;
+
+	while (*have && irec->rm_startblock == bno) {
+		rmap_dump(tag, agno, irec);
+		error = bag_add(stack_top, irec);
+		if (error)
+			return error;
+		error = refcount_walk_rmaps(rmcur->mcur, irec, have);
+		if (error)
+			return error;
+	}
+
+	error = -libxfs_btree_decrement(rmcur->mcur, 0, &have_gt);
+	if (error)
+		return error;
+	if (!have_gt)
+		return EFSCORRUPTED;
+
+	return 0;
+}
+
 /*
  * Transform a pile of physical block mapping observations into refcount data
  * for eventual rebuilding of the btrees.
  */
-#define RMAP_END(r)	((r)->rm_startblock + (r)->rm_blockcount)
 int
 compute_refcounts(
 	struct xfs_mount		*mp,
 	xfs_agnumber_t		agno)
 {
+	struct rmap_mem_cur	rmcur;
+	struct xfs_rmap_irec	irec;
 	struct xfs_bag		*stack_top = NULL;
-	struct xfs_slab		*rmaps;
-	struct xfs_slab_cursor	*rmaps_cur;
-	struct xfs_rmap_irec	*array_cur;
 	struct xfs_rmap_irec	*rmap;
-	uint64_t		n, idx;
+	uint64_t		idx;
 	uint64_t		old_stack_nr;
 	xfs_agblock_t		sbno;	/* first bno of this rmap set */
 	xfs_agblock_t		cbno;	/* first bno of this refcount set */
 	xfs_agblock_t		nbno;	/* next bno where rmap set changes */
+	bool			have;
 	int			error;
 
 	if (!xfs_has_reflink(mp))
 		return 0;
 
-	rmaps = ag_rmaps[agno].ar_rmaps;
-
-	error = init_slab_cursor(rmaps, rmap_compare, &rmaps_cur);
+	error = rmap_init_mem_cursor(mp, NULL, agno, &rmcur);
 	if (error)
 		return error;
 
-	error = init_bag(&stack_top);
+	error = init_bag(&stack_top, sizeof(struct xfs_rmap_irec));
 	if (error)
-		goto err;
+		goto out_cur;
 
-	/* While there are rmaps to be processed... */
-	n = 0;
-	while (n < slab_count(rmaps)) {
-		array_cur = peek_slab_cursor(rmaps_cur);
-		sbno = cbno = array_cur->rm_startblock;
+	/* Start the rmapbt cursor to the left of all records. */
+	error = -libxfs_btree_goto_left_edge(rmcur.mcur);
+	if (error)
+		goto out_bag;
+
+
+	/* Process reverse mappings into refcount data. */
+	while (libxfs_btree_has_more_records(rmcur.mcur)) {
 		/* Push all rmaps with pblk == sbno onto the stack */
-		for (;
-		     array_cur && array_cur->rm_startblock == sbno;
-		     array_cur = peek_slab_cursor(rmaps_cur)) {
-			advance_slab_cursor(rmaps_cur); n++;
-			rmap_dump("push0", agno, array_cur);
-			error = bag_add(stack_top, array_cur);
-			if (error)
-				goto err;
-		}
+		error = refcount_walk_rmaps(rmcur.mcur, &irec, &have);
+		if (error)
+			goto out_bag;
+		if (!have)
+			break;
+		sbno = cbno = irec.rm_startblock;
+		error = refcount_push_rmaps_at(&rmcur, agno, stack_top, sbno,
+				&irec, &have, "push0");
+		if (error)
+			goto out_bag;
 		mark_inode_rl(mp, stack_top);
 
 		/* Set nbno to the bno of the next refcount change */
-		if (n < slab_count(rmaps) && array_cur)
-			nbno = array_cur->rm_startblock;
-		else
-			nbno = NULLAGBLOCK;
-		foreach_bag_ptr(stack_top, idx, rmap) {
-			nbno = min(nbno, RMAP_END(rmap));
-		}
+		error = next_refcount_edge(stack_top, &irec, have, &nbno);
+		if (error)
+			goto out_bag;
 
 		/* Emit reverse mappings, if needed */
 		ASSERT(nbno > sbno);
@@ -1003,23 +1133,24 @@ compute_refcounts(
 		while (bag_count(stack_top)) {
 			/* Pop all rmaps that end at nbno */
 			foreach_bag_ptr_reverse(stack_top, idx, rmap) {
-				if (RMAP_END(rmap) != nbno)
+				if (RMAP_NEXT(rmap) != nbno)
 					continue;
 				rmap_dump("pop", agno, rmap);
 				error = bag_remove(stack_top, idx);
 				if (error)
-					goto err;
+					goto out_bag;
 			}
 
 			/* Push array items that start at nbno */
-			for (;
-			     array_cur && array_cur->rm_startblock == nbno;
-			     array_cur = peek_slab_cursor(rmaps_cur)) {
-				advance_slab_cursor(rmaps_cur); n++;
-				rmap_dump("push1", agno, array_cur);
-				error = bag_add(stack_top, array_cur);
+			error = refcount_walk_rmaps(rmcur.mcur, &irec, &have);
+			if (error)
+				goto out_bag;
+			if (have) {
+				error = refcount_push_rmaps_at(&rmcur, agno,
+						stack_top, nbno, &irec, &have,
+						"push1");
 				if (error)
-					goto err;
+					goto out_bag;
 			}
 			mark_inode_rl(mp, stack_top);
 
@@ -1041,25 +1172,22 @@ compute_refcounts(
 			sbno = nbno;
 
 			/* Set nbno to the bno of the next refcount change */
-			if (n < slab_count(rmaps))
-				nbno = array_cur->rm_startblock;
-			else
-				nbno = NULLAGBLOCK;
-			foreach_bag_ptr(stack_top, idx, rmap) {
-				nbno = min(nbno, RMAP_END(rmap));
-			}
+			error = next_refcount_edge(stack_top, &irec, have,
+					&nbno);
+			if (error)
+				goto out_bag;
 
 			/* Emit reverse mappings, if needed */
 			ASSERT(nbno > sbno);
 		}
 	}
-err:
+out_bag:
 	free_bag(&stack_top);
-	free_slab_cursor(&rmaps_cur);
-
+out_cur:
+	rmap_free_mem_cursor(NULL, &rmcur, error);
 	return error;
 }
-#undef RMAP_END
+#undef RMAP_NEXT
 
 static int
 count_btree_records(
diff --git a/repair/slab.c b/repair/slab.c
index 01bc4d426fe..44ca0468eda 100644
--- a/repair/slab.c
+++ b/repair/slab.c
@@ -78,16 +78,26 @@ struct xfs_slab_cursor {
 };
 
 /*
- * Bags -- each bag is an array of pointers items; when a bag fills up, we
- * resize it.
+ * Bags -- each bag is an array of record items; when a bag fills up, we resize
+ * it and hope we don't run out of memory.
  */
 #define MIN_BAG_SIZE	4096
 struct xfs_bag {
 	uint64_t		bg_nr;		/* number of pointers */
 	uint64_t		bg_inuse;	/* number of slots in use */
-	void			**bg_ptrs;	/* pointers */
+	char			*bg_items;	/* pointer to block of items */
+	size_t			bg_item_sz;	/* size of each item */
 };
-#define BAG_END(bag)	(&(bag)->bg_ptrs[(bag)->bg_nr])
+
+static inline void *bag_ptr(struct xfs_bag *bag, uint64_t idx)
+{
+	return &bag->bg_items[bag->bg_item_sz * idx];
+}
+
+static inline void *bag_end(struct xfs_bag *bag)
+{
+	return bag_ptr(bag, bag->bg_nr);
+}
 
 /*
  * Create a slab to hold some objects of a particular size.
@@ -382,15 +392,17 @@ slab_count(
  */
 int
 init_bag(
-	struct xfs_bag	**bag)
+	struct xfs_bag	**bag,
+	size_t		item_sz)
 {
 	struct xfs_bag	*ptr;
 
 	ptr = calloc(1, sizeof(struct xfs_bag));
 	if (!ptr)
 		return -ENOMEM;
-	ptr->bg_ptrs = calloc(MIN_BAG_SIZE, sizeof(void *));
-	if (!ptr->bg_ptrs) {
+	ptr->bg_item_sz = item_sz;
+	ptr->bg_items = calloc(MIN_BAG_SIZE, item_sz);
+	if (!ptr->bg_items) {
 		free(ptr);
 		return -ENOMEM;
 	}
@@ -411,7 +423,7 @@ free_bag(
 	ptr = *bag;
 	if (!ptr)
 		return;
-	free(ptr->bg_ptrs);
+	free(ptr->bg_items);
 	free(ptr);
 	*bag = NULL;
 }
@@ -424,22 +436,23 @@ bag_add(
 	struct xfs_bag	*bag,
 	void		*ptr)
 {
-	void		**p, **x;
+	void		*p, *x;
 
-	p = &bag->bg_ptrs[bag->bg_inuse];
-	if (p == BAG_END(bag)) {
+	p = bag_ptr(bag, bag->bg_inuse);
+	if (p == bag_end(bag)) {
 		/* No free space, alloc more pointers */
 		uint64_t	nr;
 
 		nr = bag->bg_nr * 2;
-		x = realloc(bag->bg_ptrs, nr * sizeof(void *));
+		x = realloc(bag->bg_items, nr * bag->bg_item_sz);
 		if (!x)
 			return -ENOMEM;
-		bag->bg_ptrs = x;
-		memset(BAG_END(bag), 0, bag->bg_nr * sizeof(void *));
+		bag->bg_items = x;
+		memset(bag_end(bag), 0, bag->bg_nr * bag->bg_item_sz);
 		bag->bg_nr = nr;
+		p = bag_ptr(bag, bag->bg_inuse);
 	}
-	bag->bg_ptrs[bag->bg_inuse] = ptr;
+	memcpy(p, ptr, bag->bg_item_sz);
 	bag->bg_inuse++;
 	return 0;
 }
@@ -453,8 +466,8 @@ bag_remove(
 	uint64_t	nr)
 {
 	ASSERT(nr < bag->bg_inuse);
-	memmove(&bag->bg_ptrs[nr], &bag->bg_ptrs[nr + 1],
-		(bag->bg_inuse - nr - 1) * sizeof(void *));
+	memmove(bag_ptr(bag, nr), bag_ptr(bag, nr + 1),
+		(bag->bg_inuse - nr - 1) * bag->bg_item_sz);
 	bag->bg_inuse--;
 	return 0;
 }
@@ -479,5 +492,5 @@ bag_item(
 {
 	if (nr >= bag->bg_inuse)
 		return NULL;
-	return bag->bg_ptrs[nr];
+	return bag_ptr(bag, nr);
 }
diff --git a/repair/slab.h b/repair/slab.h
index 077b4582214..019b169024d 100644
--- a/repair/slab.h
+++ b/repair/slab.h
@@ -28,7 +28,7 @@ void *pop_slab_cursor(struct xfs_slab_cursor *cur);
 
 struct xfs_bag;
 
-int init_bag(struct xfs_bag **bagp);
+int init_bag(struct xfs_bag **bagp, size_t itemsz);
 void free_bag(struct xfs_bag **bagp);
 int bag_add(struct xfs_bag *bag, void *item);
 int bag_remove(struct xfs_bag *bag, uint64_t idx);

