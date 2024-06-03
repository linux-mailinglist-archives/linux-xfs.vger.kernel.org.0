Return-Path: <linux-xfs+bounces-8902-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D54838D8936
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 21:00:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89ADA1F21822
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 19:00:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C8EE137923;
	Mon,  3 Jun 2024 19:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yk4Bc6DJ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D505259C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441210; cv=none; b=ThJE97j1smzK/PJ2ASDNU72+DgKngl9C/B9Cp5nRaDkoEq+utGXY+FRWMnX+30Qyk008DB5VEpyTIzDsVzda+rDl5dpDuNAqypQQFHkfVYRDSJgR+2VsyUNHedN5PxXkjM+wgPzZ75Otdi4MScKyN4ekBtO217/KapkGM/nRL2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441210; c=relaxed/simple;
	bh=jMfShxtwH/TSPr+8JbGOenOGDVc0mjSL5S/5p1rX2n8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VRfpGuTp81AH5R2rW+5X5nvuZm1vy3PYH1qWv0DYHx3ANHUkuAkKEw22IAYQWG/7o0AICas5/8SuJL8X0s1od2cjge2G6HCQlMA53EXtK2FOorjFrmg0rA5KGw603puEvXJ1N7i2AC1VVSc4/ZbplTrxFapcl0Ii5at43EVv5gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yk4Bc6DJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0152C2BD10;
	Mon,  3 Jun 2024 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441208;
	bh=jMfShxtwH/TSPr+8JbGOenOGDVc0mjSL5S/5p1rX2n8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Yk4Bc6DJGz4olu5XjBOF32GedqN+4JGVQrl/QLrdyFQxnr7hsp3WdYZADUBVkuf8c
	 oGUStSwmH7WFZ/eAZbbYeH1zjzNgRXSLgxfJALGIVB+1Rxj6Bwq0P4GBG8HLJNK498
	 Ths1odjyy/wTUNt/xzhPT2S1h94GIr9fhrmkQCBX2wjZYISa9S13OmsQYNGgUE+rOG
	 HLRO274DqOL4IG+lnz+Bz2NJ6N8tuNaY6ZdjDUJKwhGyXA28k8GqeKLnCQJqur9x4P
	 X1M0UOF0Np7uI44XHmLlPDTU0cNJf+8iyTASjalwR50vvC6SouX9F7BMFmvAS3tQwU
	 xlGaclo0tdIvg==
Date: Mon, 03 Jun 2024 12:00:08 -0700
Subject: [PATCH 031/111] xfs: drop XFS_BTREE_CRC_BLOCKS
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039837.1443973.17188629041655386113.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: f9e325bf61d1fb3ef5f705268a22de95809db9fa

All existing btree types set XFS_BTREE_CRC_BLOCKS when running against a
V5 filesystem.  All currently proposed btree types are V5 only and use
the richer XFS_BTREE_CRC_BLOCKS format.  Therefore, we can drop this
flag and change the conditional to xfs_has_crc.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_alloc_btree.c    |    3 ---
 libxfs/xfs_bmap_btree.c     |    2 --
 libxfs/xfs_btree.c          |    8 ++++----
 libxfs/xfs_btree.h          |    1 -
 libxfs/xfs_ialloc_btree.c   |    3 ---
 libxfs/xfs_refcount_btree.c |    2 --
 libxfs/xfs_rmap_btree.c     |    2 +-
 7 files changed, 5 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 16f683e1d..626d8e4b8 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -524,9 +524,6 @@ xfs_allocbt_init_common(
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	return cur;
 }
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 751ae73c5..8ffef40ba 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -553,8 +553,6 @@ xfs_bmbt_init_common(
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
 	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.allocated = 0;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 3a2b627fd..38d82c03a 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -595,11 +595,11 @@ xfs_btree_dup_cursor(
 static inline size_t xfs_btree_block_len(struct xfs_btree_cur *cur)
 {
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
-		if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS)
+		if (xfs_has_crc(cur->bc_mp))
 			return XFS_BTREE_LBLOCK_CRC_LEN;
 		return XFS_BTREE_LBLOCK_LEN;
 	}
-	if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS)
+	if (xfs_has_crc(cur->bc_mp))
 		return XFS_BTREE_SBLOCK_CRC_LEN;
 	return XFS_BTREE_SBLOCK_LEN;
 }
@@ -1573,7 +1573,7 @@ xfs_btree_log_block(
 	if (bp) {
 		int nbits;
 
-		if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+		if (xfs_has_crc(cur->bc_mp)) {
 			/*
 			 * We don't log the CRC when updating a btree
 			 * block but instead recreate it during log
@@ -3045,7 +3045,7 @@ xfs_btree_new_iroot(
 	 * In that case have to also ensure the blkno remains correct
 	 */
 	memcpy(cblock, block, xfs_btree_block_len(cur));
-	if (cur->bc_flags & XFS_BTREE_CRC_BLOCKS) {
+	if (xfs_has_crc(cur->bc_mp)) {
 		__be64 bno = cpu_to_be64(xfs_buf_daddr(cbp));
 		if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 			cblock->bb_u.l.bb_blkno = bno;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index c053fb934..36fd07b32 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -308,7 +308,6 @@ xfs_btree_cur_sizeof(unsigned int nlevels)
 #define XFS_BTREE_LONG_PTRS		(1<<0)	/* pointers are 64bits long */
 #define XFS_BTREE_ROOT_IN_INODE		(1<<1)	/* root may be variable size */
 #define XFS_BTREE_LASTREC_UPDATE	(1<<2)	/* track last rec externally */
-#define XFS_BTREE_CRC_BLOCKS		(1<<3)	/* uses extended btree blocks */
 #define XFS_BTREE_OVERLAPPING		(1<<4)	/* overlapping intervals */
 /*
  * The root of this btree is a fakeroot structure so that we can stage a btree
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 5ea08cca2..dea661afc 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -465,9 +465,6 @@ xfs_inobt_init_common(
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
 	}
 
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	return cur;
 }
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 561b732b4..1ecd670a9 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -356,8 +356,6 @@ xfs_refcountbt_init_common(
 			xfs_refcountbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
-	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 362312729..da6bfb901 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -503,7 +503,7 @@ xfs_rmapbt_init_common(
 	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
-	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
+	cur->bc_flags = XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);


