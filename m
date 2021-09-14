Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191EA40A3A8
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Sep 2021 04:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237802AbhINCmR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Sep 2021 22:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236953AbhINCmR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:42:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64B57610FB;
        Tue, 14 Sep 2021 02:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587260;
        bh=ZRhwPzvhKHsEztN6T4pz+LDqEhLn78iJQRbshI7/beo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MsVEwU0ij5ASwQe2/z1gDt2RJx61xAjrXu8N/IMXBJqVwcuBahor3yIg2azEHGoNW
         3UXibczwfAaY6JgR03CAyBeIqAH3ZADt+YfYM4hDjFWUvqX0U04BocrHDLZj5lZLGu
         8sH7SoGm2eK+TJnfUIgra59MSuxvcNlV3VwWmnUoa/e5uumF9tZuummB8evU5SaZJ/
         8rH1GYFFKn/VccrrnAvoDDaqXBmktQu5VTFd9NqDR/V39NpFB5chYqWfbwSZUbCflk
         3NwlOxLgEAcGTvTVIxCNFj3WHNqyIqc7BN3sdTtPNfi+SxkZIc0cuiBcGXzgKoV8cs
         L1D20Sahm3Anw==
Subject: [PATCH 11/43] xfs: make the record pointer passed to query_range
 functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:41:00 -0700
Message-ID: <163158726014.1604118.12939351209058354006.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 159eb69dba8baf6d5b58b69936920fb311324c82

The query_range functions are supposed to call a caller-supplied
function on each record found in the dataset.  These functions don't
own the memory storing the record, so don't let them change the record.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/fsmap.c            |    8 ++++----
 libxfs/xfs_alloc.c    |    2 +-
 libxfs/xfs_alloc.h    |    6 +++---
 libxfs/xfs_btree.c    |    2 +-
 libxfs/xfs_btree.h    |    2 +-
 libxfs/xfs_ialloc.c   |    4 ++--
 libxfs/xfs_ialloc.h   |    3 ++-
 libxfs/xfs_refcount.c |    4 ++--
 libxfs/xfs_refcount.h |    2 +-
 libxfs/xfs_rmap.c     |   24 ++++++++++++------------
 libxfs/xfs_rmap.h     |    8 ++++----
 11 files changed, 33 insertions(+), 32 deletions(-)


diff --git a/db/fsmap.c b/db/fsmap.c
index 65e9f1ba..d30b832c 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -16,11 +16,11 @@ struct fsmap_info {
 
 static int
 fsmap_fn(
-	struct xfs_btree_cur	*cur,
-	struct xfs_rmap_irec	*rec,
-	void			*priv)
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
 {
-	struct fsmap_info	*info = priv;
+	struct fsmap_info		*info = priv;
 
 	dbprintf(_("%llu: %u/%u len %u owner %lld offset %llu bmbt %d attrfork %d extflag %d\n"),
 		info->nr, info->agno, rec->rm_startblock,
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 105c90b0..a7c3b079 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3388,7 +3388,7 @@ struct xfs_alloc_query_range_info {
 STATIC int
 xfs_alloc_query_range_helper(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	void				*priv)
 {
 	struct xfs_alloc_query_range_info	*query = priv;
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 3554b7d4..e14c5693 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -220,9 +220,9 @@ int xfs_free_extent_fix_freelist(struct xfs_trans *tp, struct xfs_perag *pag,
 xfs_extlen_t xfs_prealloc_blocks(struct xfs_mount *mp);
 
 typedef int (*xfs_alloc_query_range_fn)(
-	struct xfs_btree_cur		*cur,
-	struct xfs_alloc_rec_incore	*rec,
-	void				*priv);
+	struct xfs_btree_cur			*cur,
+	const struct xfs_alloc_rec_incore	*rec,
+	void					*priv);
 
 int xfs_alloc_query_range(struct xfs_btree_cur *cur,
 		const struct xfs_alloc_rec_incore *low_rec,
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 16347ff5..fa3ba314 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4878,7 +4878,7 @@ xfs_btree_diff_two_ptrs(
 STATIC int
 xfs_btree_has_record_helper(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	void				*priv)
 {
 	return -ECANCELED;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 462c2585..e83836a9 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -471,7 +471,7 @@ unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
  * code on its own.
  */
 typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
-		union xfs_btree_rec *rec, void *priv);
+		const union xfs_btree_rec *rec, void *priv);
 
 int xfs_btree_query_range(struct xfs_btree_cur *cur,
 		const union xfs_btree_irec *low_rec,
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 570349b8..c1f3d28a 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -69,7 +69,7 @@ xfs_inobt_update(
 void
 xfs_inobt_btrec_to_irec(
 	struct xfs_mount		*mp,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	struct xfs_inobt_rec_incore	*irec)
 {
 	irec->ir_startino = be32_to_cpu(rec->inobt.ir_startino);
@@ -2711,7 +2711,7 @@ struct xfs_ialloc_count_inodes {
 STATIC int
 xfs_ialloc_count_inodes_rec(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	void				*priv)
 {
 	struct xfs_inobt_rec_incore	irec;
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index 9a2112b4..8b5c2b70 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -106,7 +106,8 @@ int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, struct xfs_buf **bpp);
 
 union xfs_btree_rec;
-void xfs_inobt_btrec_to_irec(struct xfs_mount *mp, union xfs_btree_rec *rec,
+void xfs_inobt_btrec_to_irec(struct xfs_mount *mp,
+		const union xfs_btree_rec *rec,
 		struct xfs_inobt_rec_incore *irec);
 int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 2ef00c64..1c9e7722 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -90,7 +90,7 @@ xfs_refcount_lookup_eq(
 /* Convert on-disk record to in-core format. */
 void
 xfs_refcount_btrec_to_irec(
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	struct xfs_refcount_irec	*irec)
 {
 	irec->rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
@@ -1653,7 +1653,7 @@ struct xfs_refcount_recovery {
 STATIC int
 xfs_refcount_recover_extent(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	void				*priv)
 {
 	struct list_head		*debris = priv;
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 9f6e9aae..02cb3aa4 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -78,7 +78,7 @@ static inline xfs_fileoff_t xfs_refcount_max_unmap(int log_res)
 extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
 union xfs_btree_rec;
-extern void xfs_refcount_btrec_to_irec(union xfs_btree_rec *rec,
+extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
 extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 100e904d..ed7db353 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -178,8 +178,8 @@ xfs_rmap_delete(
 /* Convert an internal btree record to an rmap record. */
 int
 xfs_rmap_btrec_to_irec(
-	union xfs_btree_rec	*rec,
-	struct xfs_rmap_irec	*irec)
+	const union xfs_btree_rec	*rec,
+	struct xfs_rmap_irec		*irec)
 {
 	irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
 	irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
@@ -254,9 +254,9 @@ struct xfs_find_left_neighbor_info {
 /* For each rmap given, figure out if it matches the key we want. */
 STATIC int
 xfs_rmap_find_left_neighbor_helper(
-	struct xfs_btree_cur	*cur,
-	struct xfs_rmap_irec	*rec,
-	void			*priv)
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
 {
 	struct xfs_find_left_neighbor_info	*info = priv;
 
@@ -330,9 +330,9 @@ xfs_rmap_find_left_neighbor(
 /* For each rmap given, figure out if it matches the key we want. */
 STATIC int
 xfs_rmap_lookup_le_range_helper(
-	struct xfs_btree_cur	*cur,
-	struct xfs_rmap_irec	*rec,
-	void			*priv)
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
 {
 	struct xfs_find_left_neighbor_info	*info = priv;
 
@@ -2277,9 +2277,9 @@ struct xfs_rmap_query_range_info {
 /* Format btree record and pass to our callback. */
 STATIC int
 xfs_rmap_query_range_helper(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*rec,
-	void			*priv)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*rec,
+	void				*priv)
 {
 	struct xfs_rmap_query_range_info	*query = priv;
 	struct xfs_rmap_irec			irec;
@@ -2706,7 +2706,7 @@ struct xfs_rmap_key_state {
 STATIC int
 xfs_rmap_has_other_keys_helper(
 	struct xfs_btree_cur		*cur,
-	struct xfs_rmap_irec		*rec,
+	const struct xfs_rmap_irec	*rec,
 	void				*priv)
 {
 	struct xfs_rmap_key_state	*rks = priv;
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 1354efc4..fd67904e 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -134,9 +134,9 @@ int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
 		int *stat);
 
 typedef int (*xfs_rmap_query_range_fn)(
-	struct xfs_btree_cur	*cur,
-	struct xfs_rmap_irec	*rec,
-	void			*priv);
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv);
 
 int xfs_rmap_query_range(struct xfs_btree_cur *cur,
 		const struct xfs_rmap_irec *low_rec,
@@ -193,7 +193,7 @@ int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 		const struct xfs_rmap_irec *b);
 union xfs_btree_rec;
-int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
+int xfs_rmap_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
 int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, bool *exists);

