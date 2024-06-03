Return-Path: <linux-xfs+bounces-8876-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E65A8D88FD
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 20:53:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4978E281398
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 18:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B85713A3F0;
	Mon,  3 Jun 2024 18:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vqb1cOp4"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB4D1386CF
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440802; cv=none; b=Hp6btjhwDK40SiDMNejL797RvXIgR/sEcghzkUPicCrdgqLw118SxbDlBBa2GoTQVQBzbtYYMapS7bidCW+rrcc3M32+2EhSqU1Wp9xab6FKkvn0OnKXLW0xavkvQY0MK+y3nZm2fHcodL+T1A0d0K+A8PHiPZ3yoRwTFW7T0MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440802; c=relaxed/simple;
	bh=yDcarutkqK15VOCg0pAXoIoXs03/Up2ynvzvySuKw7k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cfJJ/+sqx7MSDBT6d86VvLwHZEeDn+PGrBAxPIaAczquxo75hEDUNu5YsqPdhEl+6Th+Pd3+ac/9BgheTcf2OHMP3VjhAFTMRUL1nbVA5UzmFdh55NCJwuc8cVsC357Y2enmBj4Lk48Tkp3jKZQs+0/EkwcWvwQM0/Xieq6ngJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vqb1cOp4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83C8C2BD10;
	Mon,  3 Jun 2024 18:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440801;
	bh=yDcarutkqK15VOCg0pAXoIoXs03/Up2ynvzvySuKw7k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vqb1cOp43/m3JUcQdymqQ1WInTuPTg4B09DhjdmmCiJH/z7HAvYQK1LNIN03MOfLi
	 gKKNiOALgpJLbG8euKR+CjrE399tBqVLNag2gq/3GMnY/pC6qU6XznSXNqaFXWOKlR
	 Q9o2GdjIreZGhEBKYDJ5SSB1E5cDr53Ij3oUb1Drn/Y7BBbCYu3k9Z1XtIkiysnllD
	 P+/5TGqBQ/kjMs494IZnXl5yrMGyos+7Fotn1n3jyFJk93/tjvuLqUKSLwPPaSwwxI
	 zQ+vP78QX7EOJUR/QJd0StnB0SxlHvNdPJkWRr67gDDxkYPYjQGZOg+iFChWB3BxHQ
	 ooykjI2Z0bN/A==
Date: Mon, 03 Jun 2024 11:53:21 -0700
Subject: [PATCH 005/111] xfs: use GFP_KERNEL in pure transaction contexts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171744039441.1443973.9051387087395769758.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 0b3a76e955ebe3d71a2bcd5990404ed522b40e17

When running in a transaction context, memory allocations are scoped
to GFP_NOFS. Hence we don't need to use GFP_NOFS contexts in pure
transaction context allocations - GFP_KERNEL will automatically get
converted to GFP_NOFS as appropriate.

Go through the code and convert all the obvious GFP_NOFS allocations
in transaction context to use GFP_KERNEL. This further reduces the
explicit use of GFP_NOFS in XFS.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_attr.c       |    3 ++-
 libxfs/xfs_bmap.c       |    2 +-
 libxfs/xfs_defer.c      |    6 +++---
 libxfs/xfs_dir2.c       |    8 ++++----
 libxfs/xfs_inode_fork.c |    8 ++++----
 libxfs/xfs_refcount.c   |    2 +-
 libxfs/xfs_rmap.c       |    2 +-
 7 files changed, 16 insertions(+), 15 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 630065f1a..8356d4a3c 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -889,7 +889,8 @@ xfs_attr_defer_add(
 
 	struct xfs_attr_intent	*new;
 
-	new = kmem_cache_zalloc(xfs_attr_intent_cache, GFP_NOFS | __GFP_NOFAIL);
+	new = kmem_cache_zalloc(xfs_attr_intent_cache,
+			GFP_KERNEL | __GFP_NOFAIL);
 	new->xattri_op_flags = op_flags;
 	new->xattri_da_args = args;
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 494994d36..ee4e6c766 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6092,7 +6092,7 @@ __xfs_bmap_add(
 			bmap->br_blockcount,
 			bmap->br_state);
 
-	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
+	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&bi->bi_list);
 	bi->bi_type = type;
 	bi->bi_owner = ip;
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 1de3faf5e..dae9ad57f 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -819,7 +819,7 @@ xfs_defer_alloc(
 	struct xfs_defer_pending	*dfp;
 
 	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
-			GFP_NOFS | __GFP_NOFAIL);
+			GFP_KERNEL | __GFP_NOFAIL);
 	dfp->dfp_ops = ops;
 	INIT_LIST_HEAD(&dfp->dfp_work);
 	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
@@ -882,7 +882,7 @@ xfs_defer_start_recovery(
 	struct xfs_defer_pending	*dfp;
 
 	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
-			GFP_NOFS | __GFP_NOFAIL);
+			GFP_KERNEL | __GFP_NOFAIL);
 	dfp->dfp_ops = ops;
 	dfp->dfp_intent = lip;
 	INIT_LIST_HEAD(&dfp->dfp_work);
@@ -973,7 +973,7 @@ xfs_defer_ops_capture(
 		return ERR_PTR(error);
 
 	/* Create an object to capture the defer ops. */
-	dfc = kzalloc(sizeof(*dfc), GFP_NOFS | __GFP_NOFAIL);
+	dfc = kzalloc(sizeof(*dfc), GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&dfc->dfc_list);
 	INIT_LIST_HEAD(&dfc->dfc_dfops);
 
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 1a2fb999a..914c75107 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -235,7 +235,7 @@ xfs_dir_init(
 	if (error)
 		return error;
 
-	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
+	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -272,7 +272,7 @@ xfs_dir_createname(
 		XFS_STATS_INC(dp->i_mount, xs_dir_create);
 	}
 
-	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
+	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -434,7 +434,7 @@ xfs_dir_removename(
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_remove);
 
-	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
+	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
@@ -495,7 +495,7 @@ xfs_dir_replace(
 	if (rval)
 		return rval;
 
-	args = kzalloc(sizeof(*args), GFP_NOFS | __GFP_NOFAIL);
+	args = kzalloc(sizeof(*args), GFP_KERNEL | __GFP_NOFAIL);
 	if (!args)
 		return -ENOMEM;
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index cb1964189..f8f6a7364 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -400,7 +400,7 @@ xfs_iroot_realloc(
 		if (ifp->if_broot_bytes == 0) {
 			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
 			ifp->if_broot = kmalloc(new_size,
-						GFP_NOFS | __GFP_NOFAIL);
+						GFP_KERNEL | __GFP_NOFAIL);
 			ifp->if_broot_bytes = (int)new_size;
 			return;
 		}
@@ -415,7 +415,7 @@ xfs_iroot_realloc(
 		new_max = cur_max + rec_diff;
 		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
 		ifp->if_broot = krealloc(ifp->if_broot, new_size,
-					 GFP_NOFS | __GFP_NOFAIL);
+					 GFP_KERNEL | __GFP_NOFAIL);
 		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
 						     ifp->if_broot_bytes);
 		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
@@ -441,7 +441,7 @@ xfs_iroot_realloc(
 	else
 		new_size = 0;
 	if (new_size > 0) {
-		new_broot = kmalloc(new_size, GFP_NOFS | __GFP_NOFAIL);
+		new_broot = kmalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
 		/*
 		 * First copy over the btree block header.
 		 */
@@ -510,7 +510,7 @@ xfs_idata_realloc(
 
 	if (byte_diff) {
 		ifp->if_data = krealloc(ifp->if_data, new_size,
-					GFP_NOFS | __GFP_NOFAIL);
+					GFP_KERNEL | __GFP_NOFAIL);
 		if (new_size == 0)
 			ifp->if_data = NULL;
 		ifp->if_bytes = new_size;
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index de321ab9d..36dd06e63 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1448,7 +1448,7 @@ __xfs_refcount_add(
 			blockcount);
 
 	ri = kmem_cache_alloc(xfs_refcount_intent_cache,
-			GFP_NOFS | __GFP_NOFAIL);
+			GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
 	ri->ri_type = type;
 	ri->ri_startblock = startblock;
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 4731e10d2..e7681c7c8 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2558,7 +2558,7 @@ __xfs_rmap_add(
 			bmap->br_blockcount,
 			bmap->br_state);
 
-	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
+	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
 	ri->ri_type = type;
 	ri->ri_owner = owner;


