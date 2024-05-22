Return-Path: <linux-xfs+bounces-8490-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E0018CB91F
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 04:49:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D09F5B21007
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 02:49:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CDF21DFD0;
	Wed, 22 May 2024 02:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODeCKAHs"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE275234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346189; cv=none; b=QreKccCLH88Usjt0LCn5G9EUDsYlJBf5S0FO+TetVkxwTGxSu1Y69FbWe4mbh9w6mnmFwsjXIrl4I6WD2Y0l4FpxMZ/wghKnhV+UEsf5270g/BC947H+KgXpERPiwPp8hLzS15Zhhe7wd5ZJ5Mr2FI7ABgmejnVa6DUT2MSPIIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346189; c=relaxed/simple;
	bh=Zd+fGZ/8rMfek1iL09uwkPHmXsnEsCiY43Gkuvx2/GY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WFAc9DKIqEnJYZaSBfjTXJBLCZ48LXyCDbUppUQ4FqjJuEShkdGICZfCiiFUW9XJjtGhkb/dOsqN2TvXXjfFilEtusfK3GV1z7FWydMdUUrzgswRriqRslyyVAhSk/qR7MkRiF9dDeWNpmtu/YzsZS9fD6084/rHOUQLzkECF60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODeCKAHs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86A1C32789;
	Wed, 22 May 2024 02:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346189;
	bh=Zd+fGZ/8rMfek1iL09uwkPHmXsnEsCiY43Gkuvx2/GY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ODeCKAHsJhMXKe66dFQSph2buwcMihxUA0SkmsnyHiil1L8gsb3MsyZ8BUGitKsId
	 hUQCo6hF1VBeNsgGU+dX8nwbGabnTQ8IPVNGCa9cKnnFunkM8aBjFkP8x3pPhV3OYv
	 x0WrLmV/M8vfWAapUBwxd3j1NiV67qtTjynQ+hI9YXdqv6tXoVDEzo64RcfP1BRCH8
	 NQPI3x5TNSlL+Kw51BKVFAxE5Mg7AQVEhsLmr9MqJ36YriW9kQlKdmQ7W/SUDqMA+x
	 OEkC//kzdHArQHDDO1lGaALA2N2o6TokFOz7C9CdOTo5BN1Dl+8i04vDdLoHIw0iXA
	 3O0nBEnIU7lrA==
Date: Tue, 21 May 2024 19:49:48 -0700
Subject: [PATCH 004/111] xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171634531770.2478931.12138232214599307461.stgit@frogsfrogsfrogs>
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

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 94a69db2367efcd7e0eeb5d4603340aff1d3c340

In the past we've had problems with lockdep false positives stemming
from inode locking occurring in memory reclaim contexts (e.g. from
superblock shrinkers). Lockdep doesn't know that inodes access from
above memory reclaim cannot be accessed from below memory reclaim
(and vice versa) but there has never been a good solution to solving
this problem with lockdep annotations.

This situation isn't unique to inode locks - buffers are also locked
above and below memory reclaim, and we have to maintain lock
ordering for them - and against inodes - appropriately. IOWs, the
same code paths and locks are taken both above and below memory
reclaim and so we always need to make sure the lock orders are
consistent. We are spared the lockdep problems this might cause
by the fact that semaphores and bit locks aren't covered by lockdep.

In general, this sort of lockdep false positive detection is cause
by code that runs GFP_KERNEL memory allocation with an actively
referenced inode locked. When it is run from a transaction, memory
allocation is automatically GFP_NOFS, so we don't have reclaim
recursion issues. So in the places where we do memory allocation
with inodes locked outside of a transaction, we have explicitly set
them to use GFP_NOFS allocations to prevent lockdep false positives
from being reported if the allocation dips into direct memory
reclaim.

More recently, __GFP_NOLOCKDEP was added to the memory allocation
flags to tell lockdep not to track that particular allocation for
the purposes of reclaim recursion detection. This is a much better
way of preventing false positives - it allows us to use GFP_KERNEL
context outside of transactions, and allows direct memory reclaim to
proceed normally without throwing out false positive deadlock
warnings.

The obvious places that lock inodes and do memory allocation are the
lookup paths and inode extent list initialisation. These occur in
non-transactional GFP_KERNEL contexts, and so can run direct reclaim
and lock inodes.

This patch makes a first path through all the explicit GFP_NOFS
allocations in XFS and converts the obvious ones to GFP_KERNEL |
__GFP_NOLOCKDEP as a first step towards removing explicit GFP_NOFS
allocations from the XFS code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_ag.c         |    2 +-
 libxfs/xfs_btree.h      |    4 +++-
 libxfs/xfs_da_btree.c   |    8 +++++---
 libxfs/xfs_dir2.c       |   14 ++++----------
 libxfs/xfs_iext_tree.c  |   22 +++++++++++++---------
 libxfs/xfs_inode_fork.c |    8 +++++---
 6 files changed, 31 insertions(+), 27 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 2ea8d06ca..86024ddfd 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -387,7 +387,7 @@ xfs_initialize_perag(
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
 
-		error = radix_tree_preload(GFP_NOFS);
+		error = radix_tree_preload(GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 		if (error)
 			goto out_free_pag;
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index d906324e2..75a0e2c8e 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -725,7 +725,9 @@ xfs_btree_alloc_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = kmem_cache_zalloc(cache, GFP_NOFS | __GFP_NOFAIL);
+	/* BMBT allocations can come through from non-transactional context. */
+	cur = kmem_cache_zalloc(cache,
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 910099449..0fea72f33 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -81,7 +81,8 @@ xfs_da_state_alloc(
 {
 	struct xfs_da_state	*state;
 
-	state = kmem_cache_zalloc(xfs_da_state_cache, GFP_NOFS | __GFP_NOFAIL);
+	state = kmem_cache_zalloc(xfs_da_state_cache,
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	state->args = args;
 	state->mp = args->dp->i_mount;
 	return state;
@@ -2515,7 +2516,8 @@ xfs_dabuf_map(
 	int			error = 0, nirecs, i;
 
 	if (nfsb > 1)
-		irecs = kzalloc(sizeof(irec) * nfsb, GFP_NOFS | __GFP_NOFAIL);
+		irecs = kzalloc(sizeof(irec) * nfsb,
+				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 
 	nirecs = nfsb;
 	error = xfs_bmapi_read(dp, bno, nfsb, irecs, &nirecs,
@@ -2529,7 +2531,7 @@ xfs_dabuf_map(
 	 */
 	if (nirecs > 1) {
 		map = kzalloc(nirecs * sizeof(struct xfs_buf_map),
-				GFP_NOFS | __GFP_NOFAIL);
+				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 		if (!map) {
 			error = -ENOMEM;
 			goto out_free_irecs;
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index c2f0efa06..1a2fb999a 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -332,7 +332,8 @@ xfs_dir_cilookup_result(
 					!(args->op_flags & XFS_DA_OP_CILOOKUP))
 		return -EEXIST;
 
-	args->value = kmalloc(len, GFP_NOFS | __GFP_RETRY_MAYFAIL);
+	args->value = kmalloc(len,
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
 	if (!args->value)
 		return -ENOMEM;
 
@@ -363,15 +364,8 @@ xfs_dir_lookup(
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_lookup);
 
-	/*
-	 * We need to use KM_NOFS here so that lockdep will not throw false
-	 * positive deadlock warnings on a non-transactional lookup path. It is
-	 * safe to recurse into inode recalim in that case, but lockdep can't
-	 * easily be taught about it. Hence KM_NOFS avoids having to add more
-	 * lockdep Doing this avoids having to add a bunch of lockdep class
-	 * annotations into the reclaim path for the ilock.
-	 */
-	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
+	args = kzalloc(sizeof(*args),
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	args->geo = dp->i_mount->m_dir_geo;
 	args->name = name->name;
 	args->namelen = name->len;
diff --git a/libxfs/xfs_iext_tree.c b/libxfs/xfs_iext_tree.c
index a3bbd9157..cdbb72d63 100644
--- a/libxfs/xfs_iext_tree.c
+++ b/libxfs/xfs_iext_tree.c
@@ -394,12 +394,18 @@ xfs_iext_leaf_key(
 	return leaf->recs[n].lo & XFS_IEXT_STARTOFF_MASK;
 }
 
+static inline void *
+xfs_iext_alloc_node(
+	int	size)
+{
+	return kzalloc(size, GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
+}
+
 static void
 xfs_iext_grow(
 	struct xfs_ifork	*ifp)
 {
-	struct xfs_iext_node	*node = kzalloc(NODE_SIZE,
-						GFP_NOFS | __GFP_NOFAIL);
+	struct xfs_iext_node	*node = xfs_iext_alloc_node(NODE_SIZE);
 	int			i;
 
 	if (ifp->if_height == 1) {
@@ -455,8 +461,7 @@ xfs_iext_split_node(
 	int			*nr_entries)
 {
 	struct xfs_iext_node	*node = *nodep;
-	struct xfs_iext_node	*new = kzalloc(NODE_SIZE,
-						GFP_NOFS | __GFP_NOFAIL);
+	struct xfs_iext_node	*new = xfs_iext_alloc_node(NODE_SIZE);
 	const int		nr_move = KEYS_PER_NODE / 2;
 	int			nr_keep = nr_move + (KEYS_PER_NODE & 1);
 	int			i = 0;
@@ -544,8 +549,7 @@ xfs_iext_split_leaf(
 	int			*nr_entries)
 {
 	struct xfs_iext_leaf	*leaf = cur->leaf;
-	struct xfs_iext_leaf	*new = kzalloc(NODE_SIZE,
-						GFP_NOFS | __GFP_NOFAIL);
+	struct xfs_iext_leaf	*new = xfs_iext_alloc_node(NODE_SIZE);
 	const int		nr_move = RECS_PER_LEAF / 2;
 	int			nr_keep = nr_move + (RECS_PER_LEAF & 1);
 	int			i;
@@ -586,8 +590,7 @@ xfs_iext_alloc_root(
 {
 	ASSERT(ifp->if_bytes == 0);
 
-	ifp->if_data = kzalloc(sizeof(struct xfs_iext_rec),
-					GFP_NOFS | __GFP_NOFAIL);
+	ifp->if_data = xfs_iext_alloc_node(sizeof(struct xfs_iext_rec));
 	ifp->if_height = 1;
 
 	/* now that we have a node step into it */
@@ -607,7 +610,8 @@ xfs_iext_realloc_root(
 	if (new_size / sizeof(struct xfs_iext_rec) == RECS_PER_LEAF)
 		new_size = NODE_SIZE;
 
-	new = krealloc(ifp->if_data, new_size, GFP_NOFS | __GFP_NOFAIL);
+	new = krealloc(ifp->if_data, new_size,
+			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	memset(new + ifp->if_bytes, 0, new_size - ifp->if_bytes);
 	ifp->if_data = new;
 	cur->leaf = new;
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 5e0cb4886..cb1964189 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -48,7 +48,8 @@ xfs_init_local_fork(
 		mem_size++;
 
 	if (size) {
-		char *new_data = kmalloc(mem_size, GFP_NOFS | __GFP_NOFAIL);
+		char *new_data = kmalloc(mem_size,
+				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 
 		memcpy(new_data, data, size);
 		if (zero_terminate)
@@ -203,7 +204,8 @@ xfs_iformat_btree(
 	}
 
 	ifp->if_broot_bytes = size;
-	ifp->if_broot = kmalloc(size, GFP_NOFS | __GFP_NOFAIL);
+	ifp->if_broot = kmalloc(size,
+				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	ASSERT(ifp->if_broot != NULL);
 	/*
 	 * Copy and convert from the on-disk structure
@@ -688,7 +690,7 @@ xfs_ifork_init_cow(
 		return;
 
 	ip->i_cowfp = kmem_cache_zalloc(xfs_ifork_cache,
-				       GFP_NOFS | __GFP_NOFAIL);
+				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
 	ip->i_cowfp->if_format = XFS_DINODE_FMT_EXTENTS;
 }
 


