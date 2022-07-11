Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FD156AF2B
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Jul 2022 02:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236721AbiGGXxG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Jul 2022 19:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbiGGXxF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 19:53:05 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BC7D6D563
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 16:53:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4D56410E7D66
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 09:53:03 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9bIs-00FoXf-0x
        for linux-xfs@vger.kernel.org; Fri, 08 Jul 2022 09:53:02 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o9bIr-004bWy-Vx
        for linux-xfs@vger.kernel.org;
        Fri, 08 Jul 2022 09:53:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] xfs: merge xfs_buf_find() and xfs_buf_get_map()
Date:   Fri,  8 Jul 2022 09:52:56 +1000
Message-Id: <20220707235259.1097443-4-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707235259.1097443-1-david@fromorbit.com>
References: <20220707235259.1097443-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62c771df
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=RgO8CyIxsXoA:10 a=20KFwNOVAAAA:8 a=rcHKDKxyraPjwIYgH84A:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that we factored xfs_buf_find(), we can start separating into
distinct fast and slow paths from xfs_buf_get_map(). We start by
moving the lookup map and perag setup to _get_map(), and then move
all the specifics of the fast path lookup into xfs_buf_lookup()
and call it directly from _get_map(). We the move all the slow path
code to xfs_buf_find_insert(), which is now also called directly
from _get_map(). As such, xfs_buf_find() now goes away.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 207 ++++++++++++++++++++++-------------------------
 1 file changed, 95 insertions(+), 112 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 91dc691f40a8..81ca951b451a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -531,18 +531,16 @@ xfs_buf_map_verify(
 
 static int
 xfs_buf_find_lock(
-	struct xfs_buftarg	*btp,
 	struct xfs_buf          *bp,
 	xfs_buf_flags_t		flags)
 {
 	if (!xfs_buf_trylock(bp)) {
 		if (flags & XBF_TRYLOCK) {
-			xfs_buf_rele(bp);
-			XFS_STATS_INC(btp->bt_mount, xb_busy_locked);
+			XFS_STATS_INC(bp->b_mount, xb_busy_locked);
 			return -EAGAIN;
 		}
 		xfs_buf_lock(bp);
-		XFS_STATS_INC(btp->bt_mount, xb_get_locked_waited);
+		XFS_STATS_INC(bp->b_mount, xb_get_locked_waited);
 	}
 
 	/*
@@ -558,113 +556,97 @@ xfs_buf_find_lock(
 	return 0;
 }
 
-static inline struct xfs_buf *
+static inline int
 xfs_buf_lookup(
 	struct xfs_perag	*pag,
-	struct xfs_buf_map	*map)
+	struct xfs_buf_map	*map,
+	xfs_buf_flags_t		flags,
+	struct xfs_buf		**bpp)
 {
 	struct xfs_buf          *bp;
+	int			error;
 
+	spin_lock(&pag->pag_buf_lock);
 	bp = rhashtable_lookup(&pag->pag_buf_hash, map, xfs_buf_hash_params);
-	if (!bp)
-		return NULL;
+	if (!bp) {
+		spin_unlock(&pag->pag_buf_lock);
+		return -ENOENT;
+	}
 	atomic_inc(&bp->b_hold);
-	return bp;
-}
+	spin_unlock(&pag->pag_buf_lock);
 
-/*
- * Insert the new_bp into the hash table. This consumes the perag reference
- * taken for the lookup.
- */
-static int
-xfs_buf_find_insert(
-	struct xfs_buftarg	*btp,
-	struct xfs_perag	*pag,
-	struct xfs_buf		*new_bp)
-{
-	/* No match found */
-	if (!new_bp) {
-		xfs_perag_put(pag);
-		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
-		return -ENOENT;
+	error = xfs_buf_find_lock(bp, flags);
+	if (error) {
+		xfs_buf_rele(bp);
+		return error;
 	}
 
-	/* the buffer keeps the perag reference until it is freed */
-	new_bp->b_pag = pag;
-	rhashtable_insert_fast(&pag->pag_buf_hash, &new_bp->b_rhash_head,
-			       xfs_buf_hash_params);
+	trace_xfs_buf_find(bp, flags, _RET_IP_);
+	*bpp = bp;
 	return 0;
 }
 
 /*
- * Look up a buffer in the buffer cache and return it referenced and locked
- * in @found_bp.
- *
- * If @new_bp is supplied and we have a lookup miss, insert @new_bp into the
- * cache.
- *
- * If XBF_TRYLOCK is set in @flags, only try to lock the buffer and return
- * -EAGAIN if we fail to lock it.
- *
- * Return values are:
- *	-EFSCORRUPTED if have been supplied with an invalid address
- *	-EAGAIN on trylock failure
- *	-ENOENT if we fail to find a match and @new_bp was NULL
- *	0, with @found_bp:
- *		- @new_bp if we inserted it into the cache
- *		- the buffer we found and locked.
+ * Insert the new_bp into the hash table. This consumes the perag reference
+ * taken for the lookup regardless of the result of the insert.
  */
 static int
-xfs_buf_find(
+xfs_buf_find_insert(
 	struct xfs_buftarg	*btp,
+	struct xfs_perag	*pag,
+	struct xfs_buf_map	*cmap,
 	struct xfs_buf_map	*map,
 	int			nmaps,
 	xfs_buf_flags_t		flags,
-	struct xfs_buf		*new_bp,
-	struct xfs_buf		**found_bp)
+	struct xfs_buf		**bpp)
 {
-	struct xfs_perag	*pag;
+	struct xfs_buf		*new_bp;
 	struct xfs_buf		*bp;
-	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
 	int			error;
-	int			i;
-
-	*found_bp = NULL;
-
-	for (i = 0; i < nmaps; i++)
-		cmap.bm_len += map[i].bm_len;
 
-	error = xfs_buf_map_verify(btp, &cmap);
+	error = _xfs_buf_alloc(btp, map, nmaps, flags, &new_bp);
 	if (error)
-		return error;
+		goto out_drop_pag;
 
-	pag = xfs_perag_get(btp->bt_mount,
-			    xfs_daddr_to_agno(btp->bt_mount, cmap.bm_bn));
+	/*
+	 * For buffers that fit entirely within a single page, first attempt to
+	 * allocate the memory from the heap to minimise memory usage. If we
+	 * can't get heap memory for these small buffers, we fall back to using
+	 * the page allocator.
+	 */
+	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
+	    xfs_buf_alloc_kmem(new_bp, flags) < 0) {
+		error = xfs_buf_alloc_pages(new_bp, flags);
+		if (error)
+			goto out_free_buf;
+	}
 
 	spin_lock(&pag->pag_buf_lock);
-	bp = xfs_buf_lookup(pag, &cmap);
-	if (bp)
-		goto found;
+	bp = rhashtable_lookup(&pag->pag_buf_hash, cmap, xfs_buf_hash_params);
+	if (bp) {
+		atomic_inc(&bp->b_hold);
+		spin_unlock(&pag->pag_buf_lock);
+		error = xfs_buf_find_lock(bp, flags);
+		if (error)
+			xfs_buf_rele(bp);
+		else
+			*bpp = bp;
+		goto out_free_buf;
+	}
 
-	error = xfs_buf_find_insert(btp, pag, new_bp);
+	/* The buffer keeps the perag reference until it is freed. */
+	new_bp->b_pag = pag;
+	rhashtable_insert_fast(&pag->pag_buf_hash, &new_bp->b_rhash_head,
+			       xfs_buf_hash_params);
 	spin_unlock(&pag->pag_buf_lock);
-	if (error)
-		return error;
-	*found_bp = new_bp;
+	*bpp = new_bp;
 	return 0;
 
-found:
-	spin_unlock(&pag->pag_buf_lock);
+out_free_buf:
+	xfs_buf_free(new_bp);
+out_drop_pag:
 	xfs_perag_put(pag);
-
-	error = xfs_buf_find_lock(btp, bp, flags);
-	if (error)
-		return error;
-
-	trace_xfs_buf_find(bp, flags, _RET_IP_);
-	XFS_STATS_INC(btp->bt_mount, xb_get_locked);
-	*found_bp = bp;
-	return 0;
+	return error;
 }
 
 /*
@@ -674,54 +656,54 @@ xfs_buf_find(
  */
 int
 xfs_buf_get_map(
-	struct xfs_buftarg	*target,
+	struct xfs_buftarg	*btp,
 	struct xfs_buf_map	*map,
 	int			nmaps,
 	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp)
 {
-	struct xfs_buf		*bp;
-	struct xfs_buf		*new_bp;
+	struct xfs_perag	*pag;
+	struct xfs_buf		*bp = NULL;
+	struct xfs_buf_map	cmap = { .bm_bn = map[0].bm_bn };
 	int			error;
+	int			i;
 
-	*bpp = NULL;
-	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
-	if (!error)
-		goto found;
-	if (error != -ENOENT)
-		return error;
-	if (flags & XBF_INCORE)
-		return -ENOENT;
+	for (i = 0; i < nmaps; i++)
+		cmap.bm_len += map[i].bm_len;
 
-	error = _xfs_buf_alloc(target, map, nmaps, flags, &new_bp);
+	error = xfs_buf_map_verify(btp, &cmap);
 	if (error)
 		return error;
 
-	/*
-	 * For buffers that fit entirely within a single page, first attempt to
-	 * allocate the memory from the heap to minimise memory usage. If we
-	 * can't get heap memory for these small buffers, we fall back to using
-	 * the page allocator.
-	 */
-	if (BBTOB(new_bp->b_length) >= PAGE_SIZE ||
-	    xfs_buf_alloc_kmem(new_bp, flags) < 0) {
-		error = xfs_buf_alloc_pages(new_bp, flags);
-		if (error)
-			goto out_free_buf;
-	}
+	pag = xfs_perag_get(btp->bt_mount,
+			    xfs_daddr_to_agno(btp->bt_mount, cmap.bm_bn));
 
-	error = xfs_buf_find(target, map, nmaps, flags, new_bp, &bp);
-	if (error)
-		goto out_free_buf;
+	error = xfs_buf_lookup(pag, &cmap, flags, &bp);
+	if (error && error != -ENOENT)
+		goto out_put_perag;
+
+	/* cache hits always outnumber misses by at least 10:1 */
+	if (unlikely(!bp)) {
+		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
 
-	if (bp != new_bp)
-		xfs_buf_free(new_bp);
+		if (flags & XBF_INCORE)
+			goto out_put_perag;
 
-found:
+		/* xfs_buf_find_insert() consumes the perag reference. */
+		error = xfs_buf_find_insert(btp, pag, &cmap, map, nmaps,
+				flags, &bp);
+		if (error)
+			return error;
+	} else {
+		XFS_STATS_INC(btp->bt_mount, xb_get_locked);
+		xfs_perag_put(pag);
+	}
+
+	/* We do not hold a perag reference anymore. */
 	if (!bp->b_addr) {
 		error = _xfs_buf_map_pages(bp, flags);
 		if (unlikely(error)) {
-			xfs_warn_ratelimited(target->bt_mount,
+			xfs_warn_ratelimited(btp->bt_mount,
 				"%s: failed to map %u pages", __func__,
 				bp->b_page_count);
 			xfs_buf_relse(bp);
@@ -736,12 +718,13 @@ xfs_buf_get_map(
 	if (!(flags & XBF_READ))
 		xfs_buf_ioerror(bp, 0);
 
-	XFS_STATS_INC(target->bt_mount, xb_get);
+	XFS_STATS_INC(btp->bt_mount, xb_get);
 	trace_xfs_buf_get(bp, flags, _RET_IP_);
 	*bpp = bp;
 	return 0;
-out_free_buf:
-	xfs_buf_free(new_bp);
+
+out_put_perag:
+	xfs_perag_put(pag);
 	return error;
 }
 
-- 
2.36.1

