Return-Path: <linux-xfs+bounces-8561-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE6B18CB975
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 05:08:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A57DA282E11
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 03:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E51B28371;
	Wed, 22 May 2024 03:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jYiBavRm"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5524C89
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347285; cv=none; b=usIxcT8+2h2BgqqJMaL0/Psvh0404xby4Cps8JietGVdStvWWylr1OLUbAP5PG35CcoqlKlYgvgz6KAs1gs+tZx8ZdyYlRw7cXgD8w4Hq3ii9CWQjjNHlN/zpfTsEIMdyPUQehK8/WdJpF2LDBCx674N+4ZIDyLB27W6rACS+Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347285; c=relaxed/simple;
	bh=qPKgiLMBJU4KHAred8/YTptbPne+MZLy3npokzwKG4g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ojf8IQwbILt7Cr/ubaQdWzB3w7aRTREC46Ouj6aMHwvr0zwZ/aiiZEmwWFjcy+u9HMkgfDMI76VLaNuJMk8wVUQ9TktI3bExNPSBZuhu1EoNGvSs4MZQ3TE2WtUwtw8amu5rLqCKL3BpQYrcIT6jaS59epyzoZcCO0GRnnC7QzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jYiBavRm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09E8C2BD11;
	Wed, 22 May 2024 03:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347284;
	bh=qPKgiLMBJU4KHAred8/YTptbPne+MZLy3npokzwKG4g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jYiBavRm5y4mqAb+XKJvrLZG4U4icRr0nLtc0gEE/mficrepTUtnbcTu6N6F49FRl
	 +LEZw1XrIesN2L2cmZ+QWcpSpqDRTMymr2/ZEUsQO/pRw5mG46sD4Ghi0sSkP8i1Eh
	 a5d8ffyUZUP7iIb8h/BnrMDsIBEZyXClGdfXEV6QUVjknbD195BOu/hbyfKwDwh9P5
	 Dm8JrfsdiVxbLZt/bqQw9Zwy1I9GI9w2yUIVzwijSwiWjEqKly5i4Eden409+mzj86
	 lv4mVQyn/T6RzAJ8AURHrfyB847oxFptuHwfqrNS7dfjAqtZHc54vicw0nWml95TVS
	 1IZYl6Aue+xng==
Date: Tue, 21 May 2024 20:08:04 -0700
Subject: [PATCH 074/111] xfs: remove xfs_btnum_t
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532808.2478931.16850399594004598898.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: ec793e690f801d97a7ae2a0d429fea1fee4d44aa

The last checks for bc_btnum can be replaced with helpers that check
the btree ops.  This allows adding new btrees to XFS without having
to update a global enum.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: complete the ops predicates]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc.c          |    6 +++---
 libxfs/xfs_alloc_btree.c    |   12 ++++++------
 libxfs/xfs_bmap_btree.c     |    4 ++--
 libxfs/xfs_btree.c          |    4 ++--
 libxfs/xfs_btree.h          |   11 -----------
 libxfs/xfs_ialloc.c         |    2 +-
 libxfs/xfs_ialloc_btree.c   |   10 +++++-----
 libxfs/xfs_refcount_btree.c |    5 ++---
 libxfs/xfs_rmap_btree.c     |    2 +-
 libxfs/xfs_shared.h         |   35 +++++++++++++++++++++++++++++++++++
 libxfs/xfs_types.h          |    9 ---------
 repair/agbtree.c            |    4 ++--
 repair/phase5.c             |    6 ++----
 13 files changed, 61 insertions(+), 49 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 599271e5c..0eefb16cc 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -914,7 +914,7 @@ xfs_alloc_cur_check(
 	bool			busy;
 	unsigned		busy_gen = 0;
 	bool			deactivate = false;
-	bool			isbnobt = cur->bc_btnum == XFS_BTNUM_BNO;
+	bool			isbnobt = xfs_btree_is_bno(cur->bc_ops);
 
 	*new = 0;
 
@@ -4022,7 +4022,7 @@ xfs_alloc_query_range(
 	union xfs_btree_irec			high_brec = { .a = *high_rec };
 	struct xfs_alloc_query_range_info	query = { .priv = priv, .fn = fn };
 
-	ASSERT(cur->bc_btnum == XFS_BTNUM_BNO);
+	ASSERT(xfs_btree_is_bno(cur->bc_ops));
 	return xfs_btree_query_range(cur, &low_brec, &high_brec,
 			xfs_alloc_query_range_helper, &query);
 }
@@ -4036,7 +4036,7 @@ xfs_alloc_query_all(
 {
 	struct xfs_alloc_query_range_info	query;
 
-	ASSERT(cur->bc_btnum == XFS_BTNUM_BNO);
+	ASSERT(xfs_btree_is_bno(cur->bc_ops));
 	query.priv = priv;
 	query.fn = fn;
 	return xfs_btree_query_all(cur, xfs_alloc_query_range_helper, &query);
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index b219dc6ac..35d3dde42 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -49,7 +49,7 @@ xfs_allocbt_set_root(
 
 	ASSERT(ptr->s != 0);
 
-	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+	if (xfs_btree_is_bno(cur->bc_ops)) {
 		agf->agf_bno_root = ptr->s;
 		be32_add_cpu(&agf->agf_bno_level, inc);
 		cur->bc_ag.pag->pagf_bno_level += inc;
@@ -129,7 +129,7 @@ xfs_allocbt_update_lastrec(
 	__be32			len;
 	int			numrecs;
 
-	ASSERT(cur->bc_btnum == XFS_BTNUM_CNT);
+	ASSERT(!xfs_btree_is_bno(cur->bc_ops));
 
 	switch (reason) {
 	case LASTREC_UPDATE:
@@ -239,7 +239,7 @@ xfs_allocbt_init_ptr_from_cur(
 
 	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
-	if (cur->bc_btnum == XFS_BTNUM_BNO)
+	if (xfs_btree_is_bno(cur->bc_ops))
 		ptr->s = agf->agf_bno_root;
 	else
 		ptr->s = agf->agf_cnt_root;
@@ -552,7 +552,7 @@ xfs_bnobt_init_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BNO, &xfs_bnobt_ops,
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_bnobt_ops,
 			mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.agbp = agbp;
@@ -578,7 +578,7 @@ xfs_cntbt_init_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_CNT, &xfs_cntbt_ops,
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_cntbt_ops,
 			mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.agbp = agbp;
@@ -605,7 +605,7 @@ xfs_allocbt_commit_staged_btree(
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
 
-	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+	if (xfs_btree_is_bno(cur->bc_ops)) {
 		agf->agf_bno_root = cpu_to_be32(afake->af_root);
 		agf->agf_bno_level = cpu_to_be32(afake->af_levels);
 	} else {
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 12b94c74e..eede6ffd6 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -573,8 +573,8 @@ xfs_bmbt_init_cursor(
 		maxlevels = mp->m_bm_maxlevels[whichfork];
 		break;
 	}
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP, &xfs_bmbt_ops,
-			maxlevels, xfs_bmbt_cur_cache);
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_bmbt_ops, maxlevels,
+			xfs_bmbt_cur_cache);
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.whichfork = whichfork;
 	cur->bc_bmap.allocated = 0;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 95f77fbe7..0b6d8d6f1 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -451,7 +451,7 @@ xfs_btree_del_cursor(
 	 * zero, then we should be shut down or on our way to shutdown due to
 	 * cancelling a dirty transaction on error.
 	 */
-	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_bmap.allocated == 0 ||
+	ASSERT(!xfs_btree_is_bmap(cur->bc_ops) || cur->bc_bmap.allocated == 0 ||
 	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 
 	switch (cur->bc_ops->type) {
@@ -3013,7 +3013,7 @@ xfs_btree_split(
 	struct xfs_btree_split_args	args;
 	DECLARE_COMPLETION_ONSTACK(done);
 
-	if (cur->bc_btnum != XFS_BTNUM_BMAP ||
+	if (!xfs_btree_is_bmap(cur->bc_ops) ||
 	    cur->bc_tp->t_highest_agno == NULLAGNUMBER)
 		return __xfs_btree_split(cur, level, ptrp, key, curp, stat);
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 6e5fd0c06..9a264ffee 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -55,14 +55,6 @@ union xfs_btree_rec {
 #define	XFS_LOOKUP_LE	((xfs_lookup_t)XFS_LOOKUP_LEi)
 #define	XFS_LOOKUP_GE	((xfs_lookup_t)XFS_LOOKUP_GEi)
 
-#define	XFS_BTNUM_BNO	((xfs_btnum_t)XFS_BTNUM_BNOi)
-#define	XFS_BTNUM_CNT	((xfs_btnum_t)XFS_BTNUM_CNTi)
-#define	XFS_BTNUM_BMAP	((xfs_btnum_t)XFS_BTNUM_BMAPi)
-#define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
-#define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
-#define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
-#define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
-
 struct xfs_btree_ops;
 uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
 
@@ -272,7 +264,6 @@ struct xfs_btree_cur
 	const struct xfs_btree_ops *bc_ops;
 	struct kmem_cache	*bc_cache; /* cursor cache */
 	unsigned int		bc_flags; /* btree features - below */
-	xfs_btnum_t		bc_btnum; /* identifies which btree type */
 	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
 	uint8_t			bc_nlevels; /* number of levels in the tree */
 	uint8_t			bc_maxlevels; /* maximum levels for this btree type */
@@ -726,7 +717,6 @@ static inline struct xfs_btree_cur *
 xfs_btree_alloc_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_btnum_t		btnum,
 	const struct xfs_btree_ops *ops,
 	uint8_t			maxlevels,
 	struct kmem_cache	*cache)
@@ -742,7 +732,6 @@ xfs_btree_alloc_cursor(
 	cur->bc_ops = ops;
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
-	cur->bc_btnum = btnum;
 	cur->bc_maxlevels = maxlevels;
 	cur->bc_cache = cache;
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 296548bc1..c30e76830 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2843,7 +2843,7 @@ xfs_ialloc_count_inodes(
 	struct xfs_ialloc_count_inodes	ci = {0};
 	int				error;
 
-	ASSERT(cur->bc_btnum == XFS_BTNUM_INO);
+	ASSERT(xfs_btree_is_ino(cur->bc_ops));
 	error = xfs_btree_query_all(cur, xfs_ialloc_count_inodes_rec, &ci);
 	if (error)
 		return error;
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 2f095862e..cb0a7c779 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -89,9 +89,9 @@ xfs_inobt_mod_blockcount(
 	if (!xfs_has_inobtcounts(cur->bc_mp))
 		return;
 
-	if (cur->bc_btnum == XFS_BTNUM_FINO)
+	if (xfs_btree_is_fino(cur->bc_ops))
 		be32_add_cpu(&agi->agi_fblocks, howmuch);
-	else if (cur->bc_btnum == XFS_BTNUM_INO)
+	else
 		be32_add_cpu(&agi->agi_iblocks, howmuch);
 	xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_IBLOCKS);
 }
@@ -480,7 +480,7 @@ xfs_inobt_init_cursor(
 	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_INO, &xfs_inobt_ops,
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_inobt_ops,
 			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.agbp = agbp;
@@ -506,7 +506,7 @@ xfs_finobt_init_cursor(
 	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_FINO, &xfs_finobt_ops,
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_finobt_ops,
 			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.agbp = agbp;
@@ -534,7 +534,7 @@ xfs_inobt_commit_staged_btree(
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
 
-	if (cur->bc_btnum == XFS_BTNUM_INO) {
+	if (xfs_btree_is_ino(cur->bc_ops)) {
 		fields = XFS_AGI_ROOT | XFS_AGI_LEVEL;
 		agi->agi_root = cpu_to_be32(afake->af_root);
 		agi->agi_level = cpu_to_be32(afake->af_levels);
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 31ef879ba..6ec0e36e5 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -363,9 +363,8 @@ xfs_refcountbt_init_cursor(
 
 	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC,
-			&xfs_refcountbt_ops, mp->m_refc_maxlevels,
-			xfs_refcountbt_cur_cache);
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_refcountbt_ops,
+			mp->m_refc_maxlevels, xfs_refcountbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_refc.nr_ops = 0;
 	cur->bc_refc.shape_changes = 0;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index c7ca20043..18168db6e 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -516,7 +516,7 @@ xfs_rmapbt_init_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
+	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.agbp = agbp;
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 518ea9456..6b8bc276d 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -52,6 +52,41 @@ extern const struct xfs_btree_ops xfs_bmbt_ops;
 extern const struct xfs_btree_ops xfs_refcountbt_ops;
 extern const struct xfs_btree_ops xfs_rmapbt_ops;
 
+static inline bool xfs_btree_is_bno(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_bnobt_ops;
+}
+
+static inline bool xfs_btree_is_cnt(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_cntbt_ops;
+}
+
+static inline bool xfs_btree_is_bmap(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_bmbt_ops;
+}
+
+static inline bool xfs_btree_is_ino(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_inobt_ops;
+}
+
+static inline bool xfs_btree_is_fino(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_finobt_ops;
+}
+
+static inline bool xfs_btree_is_refcount(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_refcountbt_ops;
+}
+
+static inline bool xfs_btree_is_rmap(const struct xfs_btree_ops *ops)
+{
+	return ops == &xfs_rmapbt_ops;
+}
+
 /* log size calculation functions */
 int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
 int	xfs_log_calc_minimum_size(struct xfs_mount *);
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index f577247b7..76eb9e328 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -116,15 +116,6 @@ typedef enum {
 	{ XFS_LOOKUP_LEi,	"le" }, \
 	{ XFS_LOOKUP_GEi,	"ge" }
 
-/*
- * This enum is used in string mapping in xfs_trace.h and scrub/trace.h;
- * please keep the TRACE_DEFINE_ENUMs for it up to date.
- */
-typedef enum {
-	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
-	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
-} xfs_btnum_t;
-
 struct xfs_name {
 	const unsigned char	*name;
 	int			len;
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 7d7727151..1a3e40cca 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -204,7 +204,7 @@ get_bno_rec(
 {
 	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
 
-	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+	if (xfs_btree_is_bno(cur->bc_ops)) {
 		if (!prev_value)
 			return findfirst_bno_extent(agno);
 		return findnext_bno_extent(prev_value);
@@ -378,7 +378,7 @@ get_ino_rec(
 {
 	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
 
-	if (cur->bc_btnum == XFS_BTNUM_INO) {
+	if (xfs_btree_is_ino(cur->bc_ops)) {
 		if (!prev_value)
 			return findfirst_inode_rec(agno);
 		return next_ino_rec(prev_value);
diff --git a/repair/phase5.c b/repair/phase5.c
index 6ae2ea575..b689a4234 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -304,11 +304,9 @@ build_agf_agfl(
 	}
 
 #ifdef XR_BLD_FREE_TRACE
-	fprintf(stderr, "bno root = %u, bcnt root = %u, indices = %u %u\n",
+	fprintf(stderr, "bno root = %u, bcnt root = %u\n",
 			be32_to_cpu(agf->agf_bno_root),
-			be32_to_cpu(agf->agf_cnt_root),
-			XFS_BTNUM_BNO,
-			XFS_BTNUM_CNT);
+			be32_to_cpu(agf->agf_cnt_root));
 #endif
 
 	if (xfs_has_crc(mp))


