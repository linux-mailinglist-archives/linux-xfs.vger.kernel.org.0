Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6DBB3A1F
	for <lists+linux-xfs@lfdr.de>; Mon, 16 Sep 2019 14:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732409AbfIPMQm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 16 Sep 2019 08:16:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732417AbfIPMQl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 08:16:41 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BEEB211A2A
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 12:16:40 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CECE5C28F
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 12:16:40 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 11/11] xfs: optimize near mode bnobt scans with concurrent cntbt lookups
Date:   Mon, 16 Sep 2019 08:16:35 -0400
Message-Id: <20190916121635.43148-12-bfoster@redhat.com>
In-Reply-To: <20190916121635.43148-1-bfoster@redhat.com>
References: <20190916121635.43148-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 16 Sep 2019 12:16:40 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The near mode fallback algorithm consists of a left/right scan of
the bnobt. This algorithm has very poor breakdown characteristics
under worst case free space fragmentation conditions. If a suitable
extent is far enough from the locality hint, each allocation may
scan most or all of the bnobt before it completes. This causes
pathological behavior and extremely high allocation latencies.

While locality is important to near mode allocations, it is not so
important as to incur pathological allocation latency to provide the
asolute best available locality for every allocation. If the
allocation is large enough or far enough away, there is a point of
diminishing returns. As such, we can bound the overall operation by
including an iterative cntbt lookup in the broader search. The cntbt
lookup is optimized to immediately find the extent with best
locality for the given size on each iteration. Since the cntbt is
indexed by extent size, the lookup repeats with a variably
aggressive increasing search key size until it runs off the edge of
the tree.

This approach provides a natural balance between the two algorithms
for various situations. For example, the bnobt scan is able to
satisfy smaller allocations such as for inode chunks or btree blocks
more quickly where the cntbt search may have to search through a
large set of extent sizes when the search key starts off small
relative to the largest extent in the tree. On the other hand, the
cntbt search more deterministically covers the set of suitable
extents for larger data extent allocation requests that the bnobt
scan may have to search the entire tree to locate.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 153 +++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_trace.h        |   2 +
 2 files changed, 143 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 381a08257aaf..4ec22040e516 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -716,6 +716,7 @@ struct xfs_alloc_cur {
 	struct xfs_btree_cur		*cnt;	/* btree cursors */
 	struct xfs_btree_cur		*bnolt;
 	struct xfs_btree_cur		*bnogt;
+	xfs_extlen_t			cur_len;/* current search length */
 	xfs_agblock_t			rec_bno;/* extent startblock */
 	xfs_extlen_t			rec_len;/* extent length */
 	xfs_agblock_t			bno;	/* alloc bno */
@@ -740,6 +741,7 @@ xfs_alloc_cur_setup(
 
 	ASSERT(args->alignment == 1 || args->type != XFS_ALLOCTYPE_THIS_BNO);
 
+	acur->cur_len = args->maxlen;
 	acur->rec_bno = 0;
 	acur->rec_len = 0;
 	acur->bno = 0;
@@ -913,6 +915,76 @@ xfs_alloc_cur_finish(
 	return 0;
 }
 
+/*
+ * Locality allocation lookup algorithm. This expects a cntbt cursor and uses
+ * bno optimized lookup to search for extents with ideal size and locality.
+ */
+STATIC int
+xfs_alloc_cntbt_iter(
+	struct xfs_alloc_arg		*args,
+	struct xfs_alloc_cur		*acur)
+{
+	struct xfs_btree_cur	*cur = acur->cnt;
+	xfs_agblock_t		bno;
+	xfs_extlen_t		len, cur_len;
+	int			error;
+	int			i;
+
+	if (!xfs_alloc_cur_active(cur))
+		return 0;
+
+	/* locality optimized lookup */
+	cur_len = acur->cur_len;
+	error = xfs_alloc_lookup_ge(cur, args->agbno, cur_len, &i);
+	if (error)
+		return error;
+	if (i == 0)
+		return 0;
+	error = xfs_alloc_get_rec(cur, &bno, &len, &i);
+	if (error)
+		return error;
+
+	/* check the current record and update search length from it */
+	error = xfs_alloc_cur_check(args, acur, cur, &i);
+	if (error)
+		return error;
+	ASSERT(len >= acur->cur_len);
+	acur->cur_len = len;
+
+	/*
+	 * We looked up the first record >= [agbno, len] above. The agbno is a
+	 * secondary key and so the current record may lie just before or after
+	 * agbno. If it is past agbno, check the previous record too so long as
+	 * the length matches as it may be closer. Don't check a smaller record
+	 * because that could deactivate our cursor.
+	 */
+	if (bno > args->agbno) {
+		error = xfs_btree_decrement(cur, 0, &i);
+		if (!error && i) {
+			error = xfs_alloc_get_rec(cur, &bno, &len, &i);
+			if (!error && i && len == acur->cur_len)
+				error = xfs_alloc_cur_check(args, acur, cur,
+							    &i);
+		}
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Increment the search key until we find at least one allocation
+	 * candidate or if the extent we found was larger. Otherwise, double the
+	 * search key to optimize the search. Efficiency is more important here
+	 * than absolute best locality.
+	 */
+	cur_len <<= 1;
+	if (!acur->len || acur->cur_len >= cur_len)
+		acur->cur_len++;
+	else
+		acur->cur_len = cur_len;
+
+	return error;
+}
+
 /*
  * Deal with the case where only small freespaces remain. Either return the
  * contents of the last freespace record, or allocate space from the freelist if
@@ -1254,12 +1326,11 @@ xfs_alloc_walk_iter(
 }
 
 /*
- * Search in the by-bno btree to the left and to the right simultaneously until
- * in each case we find a large enough free extent or run into the edge of the
- * tree. When we run into the edge of the tree, we deactivate that cursor.
+ * Search the by-bno and by-size btrees in parallel in search of an extent with
+ * ideal locality based on the NEAR mode ->agbno locality hint.
  */
 STATIC int
-xfs_alloc_ag_vextent_bnobt(
+xfs_alloc_ag_vextent_locality(
 	struct xfs_alloc_arg	*args,
 	struct xfs_alloc_cur	*acur,
 	int			*stat)
@@ -1274,6 +1345,9 @@ xfs_alloc_ag_vextent_bnobt(
 
 	*stat = 0;
 
+	error = xfs_alloc_lookup_ge(acur->cnt, args->agbno, acur->cur_len, &i);
+	if (error)
+		return error;
 	error = xfs_alloc_lookup_le(acur->bnolt, args->agbno, 0, &i);
 	if (error)
 		return error;
@@ -1282,12 +1356,37 @@ xfs_alloc_ag_vextent_bnobt(
 		return error;
 
 	/*
-	 * Loop going left with the leftward cursor, right with the rightward
-	 * cursor, until either both directions give up or we find an entry at
-	 * least as big as minlen.
+	 * Search the bnobt and cntbt in parallel. Search the bnobt left and
+	 * right and lookup the closest extent to the locality hint for each
+	 * extent size key in the cntbt. The entire search terminates
+	 * immediately on a bnobt hit because that means we've found best case
+	 * locality. Otherwise the search continues until the cntbt cursor runs
+	 * off the end of the tree. If no allocation candidate is found at this
+	 * point, give up on locality, walk backwards from the end of the cntbt
+	 * and take the first available extent.
+	 *
+	 * The parallel tree searches balance each other out to provide fairly
+	 * consistent performance for various situations. The bnobt search can
+	 * have pathological behavior in the worst case scenario of larger
+	 * allocation requests and fragmented free space. On the other hand, the
+	 * bnobt is able to satisfy most smaller allocation requests much more
+	 * quickly than the cntbt. The cntbt search can sift through fragmented
+	 * free space and sets of free extents for larger allocation requests
+	 * more quickly than the bnobt. Since the locality hint is just a hint
+	 * and we don't want to scan the entire bnobt for perfect locality, the
+	 * cntbt search essentially bounds the bnobt search such that we can
+	 * find good enough locality at reasonable performance in most cases.
 	 */
 	while (xfs_alloc_cur_active(acur->bnolt) ||
-	       xfs_alloc_cur_active(acur->bnogt)) {
+	       xfs_alloc_cur_active(acur->bnogt) ||
+	       xfs_alloc_cur_active(acur->cnt)) {
+
+		trace_xfs_alloc_cur_lookup(args);
+
+		/*
+		 * Search the bnobt left and right. In the case of a hit, finish
+		 * the search in the opposite direction and we're done.
+		 */
 		error = xfs_alloc_walk_iter(args, acur, acur->bnolt, false,
 					    true, 1, &i);
 		if (error)
@@ -1298,7 +1397,6 @@ xfs_alloc_ag_vextent_bnobt(
 			fbinc = true;
 			break;
 		}
-
 		error = xfs_alloc_walk_iter(args, acur, acur->bnogt, true, true,
 					    1, &i);
 		if (error)
@@ -1309,9 +1407,39 @@ xfs_alloc_ag_vextent_bnobt(
 			fbinc = false;
 			break;
 		}
+
+		/*
+		 * Check the extent with best locality based on the current
+		 * extent size search key and keep track of the best candidate.
+		 * If we fail to find anything due to busy extents, return
+		 * empty handed so the caller can flush and retry the search. If
+		 * no busy extents were found, walk backwards from the end of
+		 * the cntbt as a last resort.
+		 */
+		error = xfs_alloc_cntbt_iter(args, acur);
+		if (error)
+			return error;
+		if (!xfs_alloc_cur_active(acur->cnt)) {
+			trace_xfs_alloc_cur_lookup_done(args);
+			if (!acur->len && !acur->busy) {
+				error = xfs_btree_decrement(acur->cnt, 0, &i);
+				if (error)
+					return error;
+				if (i) {
+					acur->cnt->bc_private.a.priv.abt.active = true;
+					fbcur = acur->cnt;
+					fbinc = false;
+				}
+			}
+			break;
+		}
+
 	}
 
-	/* search the opposite direction for a better entry */
+	/*
+	 * Search in the opposite direction for a better entry in the case of
+	 * a bnobt hit or walk backwards from the end of the cntbt.
+	 */
 	if (fbcur) {
 		error = xfs_alloc_walk_iter(args, acur, fbcur, fbinc, true, -1,
 					    &i);
@@ -1440,9 +1568,10 @@ xfs_alloc_ag_vextent_near(
 	}
 
 	/*
-	 * Second algorithm. Search the bnobt left and right.
+	 * Second algorithm. Combined cntbt and bnobt search to find ideal
+	 * locality.
 	 */
-	error = xfs_alloc_ag_vextent_bnobt(args, &acur, &i);
+	error = xfs_alloc_ag_vextent_locality(args, &acur, &i);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b8b93068efe7..0c9dfeac4e75 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1645,6 +1645,8 @@ DEFINE_ALLOC_EVENT(xfs_alloc_near_first);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur_right);
 DEFINE_ALLOC_EVENT(xfs_alloc_cur_left);
+DEFINE_ALLOC_EVENT(xfs_alloc_cur_lookup);
+DEFINE_ALLOC_EVENT(xfs_alloc_cur_lookup_done);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_error);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_noentry);
 DEFINE_ALLOC_EVENT(xfs_alloc_near_busy);
-- 
2.20.1

