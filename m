Return-Path: <linux-xfs+bounces-14533-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5D6A9A92DD
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Oct 2024 00:04:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E41F41C2208D
	for <lists+linux-xfs@lfdr.de>; Mon, 21 Oct 2024 22:04:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2C01E25F3;
	Mon, 21 Oct 2024 22:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bom1kNBY"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AB01C461F
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548218; cv=none; b=GRM7Ul5RzNi748Olfcm3X2QzzLmAZ8PXB/xXMBEfe5Z0gnT9Ex+wd/Ezyi4/PZ+j4YlupCwJGGsMs9CaSzqydjkp0LphQfHe25b2WuuvfhMEsm63ilz3Qlq6+SV0DaDbywPVpfjAjzzxROJsBj62mjIyfCo9l2xxJvohDF1KWWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548218; c=relaxed/simple;
	bh=oG+f4AX5lGEUmIbRkYV4kNB8pd7rIdbFVAcjbDq1x/A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rqg0EoCVQTx7ESNNEVO9RJqSS8qD3uAxGTd9FxE+emcqWhOIiq2Y6dxBxfr/eX31yZf11Ojf9ufYNO655SCd3VWZfghPqzYIm//PIB+VKT/q5yrPgfmzuHO/KTE67BpBoRfprr4JIHV0rtI/brHBafPCQ22P8z+9LpYB18+DQNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bom1kNBY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE479C4CEC3;
	Mon, 21 Oct 2024 22:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548217;
	bh=oG+f4AX5lGEUmIbRkYV4kNB8pd7rIdbFVAcjbDq1x/A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Bom1kNBYIUM/W60mFXTuVjxowSPZN9fp5owuxAE912L0Ul0aNSLaFjIY0yhCo4J3P
	 ScHGpcPa+9IIgmEEH5tzIeBCOdpGsxE8ZuRMrWcayb78zjFdw2sx7ys49rbDLtPYlK
	 XTiS0YKl2kzY46ZxSt/9fMV2Ge4jXe7S/g5p7Qa+d/hW3lRwMljItCYjsNK4AZGnuA
	 Z0HpRNaDQIkHo6IqnYJOfmi/nSoJUVJSjUfZcccnq8c/xLgR/zwqP0AooupfTzB2Z3
	 uPpaI08hkoYtwuiu+JpbmKlrJfRfL3y0v5QT1wrvjYx862r9r/69m86odB/WkDIgtM
	 rSpdrbYU6ix+w==
Date: Mon, 21 Oct 2024 15:03:37 -0700
Subject: [PATCH 18/37] xfs: remove xfs_{rtbitmap,rtsummary}_wordcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783743.34558.2324020419510529947.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 1fc51cf11dd8b26856ae1c4111e402caec73019c

xfs_rtbitmap_wordcount and xfs_rtsummary_wordcount are currently unused,
so remove them to simplify refactoring other rtbitmap helpers.  They
can be added back or simply open coded when actually needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c            |    3 +--
 libxfs/xfs_rtbitmap.c |   31 -------------------------------
 libxfs/xfs_rtbitmap.h |    7 -------
 repair/rt.c           |    5 ++---
 4 files changed, 3 insertions(+), 43 deletions(-)


diff --git a/db/check.c b/db/check.c
index bceaf318d75ed8..00ef3c1d4b508c 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1958,8 +1958,7 @@ init(
 
 		dbmap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**dbmap));
 		inomap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**inomap));
-		words = libxfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
-				mp->m_sb.sb_rbmblocks);
+		words = mp->m_rsumsize >> XFS_WORDLOG;
 		sumfile = xcalloc(words, sizeof(union xfs_suminfo_raw));
 		sumcompute = xcalloc(words, sizeof(union xfs_suminfo_raw));
 	}
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 3f534a4724a26b..1c657da907132e 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1146,21 +1146,6 @@ xfs_rtbitmap_blockcount(
 	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
 }
 
-/*
- * Compute the number of rtbitmap words needed to populate every block of a
- * bitmap that is large enough to track the given number of rt extents.
- */
-unsigned long long
-xfs_rtbitmap_wordcount(
-	struct xfs_mount	*mp,
-	xfs_rtbxlen_t		rtextents)
-{
-	xfs_filblks_t		blocks;
-
-	blocks = xfs_rtbitmap_blockcount(mp, rtextents);
-	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
-}
-
 /* Compute the number of rtsummary blocks needed to track the given rt space. */
 xfs_filblks_t
 xfs_rtsummary_blockcount(
@@ -1174,22 +1159,6 @@ xfs_rtsummary_blockcount(
 	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
 }
 
-/*
- * Compute the number of rtsummary info words needed to populate every block of
- * a summary file that is large enough to track the given rt space.
- */
-unsigned long long
-xfs_rtsummary_wordcount(
-	struct xfs_mount	*mp,
-	unsigned int		rsumlevels,
-	xfs_extlen_t		rbmblocks)
-{
-	xfs_filblks_t		blocks;
-
-	blocks = xfs_rtsummary_blockcount(mp, rsumlevels, rbmblocks);
-	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
-}
-
 /* Lock both realtime free space metadata inodes for a freespace update. */
 void
 xfs_rtbitmap_lock(
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 0dbc9bb40668a2..140513d1d6bcf1 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -316,13 +316,8 @@ int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 
 xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
-unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
-		xfs_rtbxlen_t rtextents);
-
 xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
-unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
-		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 
 int xfs_rtfile_initialize_blocks(struct xfs_inode *ip,
 		xfs_fileoff_t offset_fsb, xfs_fileoff_t end_fsb, void *data);
@@ -355,9 +350,7 @@ xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 	/* shut up gcc */
 	return 0;
 }
-# define xfs_rtbitmap_wordcount(mp, r)			(0)
 # define xfs_rtsummary_blockcount(mp, l, b)		(0)
-# define xfs_rtsummary_wordcount(mp, l, b)		(0)
 # define xfs_rtbitmap_lock(mp)			do { } while (0)
 # define xfs_rtbitmap_trans_join(tp)		do { } while (0)
 # define xfs_rtbitmap_unlock(mp)		do { } while (0)
diff --git a/repair/rt.c b/repair/rt.c
index 4c81e2114c7735..879946ab0b154e 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -27,14 +27,13 @@ rtinit(xfs_mount_t *mp)
 	 * information.  The rtbitmap buffer must be large enough to compare
 	 * against any unused bytes in the last block of the file.
 	 */
-	wordcnt = libxfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
+	wordcnt = XFS_FSB_TO_B(mp, mp->m_sb.sb_rbmblocks) >> XFS_WORDLOG;
 	btmcompute = calloc(wordcnt, sizeof(union xfs_rtword_raw));
 	if (!btmcompute)
 		do_error(
 	_("couldn't allocate memory for incore realtime bitmap.\n"));
 
-	wordcnt = libxfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
-			mp->m_sb.sb_rbmblocks);
+	wordcnt = mp->m_rsumsize >> XFS_WORDLOG;
 	sumcompute = calloc(wordcnt, sizeof(union xfs_suminfo_raw));
 	if (!sumcompute)
 		do_error(


