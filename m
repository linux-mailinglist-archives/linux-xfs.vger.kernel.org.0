Return-Path: <linux-xfs+bounces-14430-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 333C19A2D59
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Oct 2024 21:09:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 574C01C22BA8
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Oct 2024 19:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E36072204D0;
	Thu, 17 Oct 2024 19:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X7qGC1mw"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39D92204CB
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192138; cv=none; b=IWjAiES2KdlsAvYzlGLP3zbymyToTPBiNDlwMhQ+rEDL1hCL/QW+l/fsn2hwKWlAyqvFpF4RRpLfYw4z6xVJrVkel9xYRLLK9BptF0447Ulr2ZmYG5nDu1ltdcTUSvITWZEwQhU5yONLp3MlE4CdqpAHpOAcvHKz0rT9X/NXo5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192138; c=relaxed/simple;
	bh=i44pbRq9rGUCHtcZWa18Z9F7LHAZm/koPgD9OYlyqe8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EHmISvLd9S+STG7fEoWUXnXh2gcag/N1hKUE2M6loJuj6hhx0qY3gr7DKnbVFWB9Vo4tkvzeFdVikpSUe8XPMF+6510Q4c+gKrouAScVsAvITPTmIZmPUvechNJBr/cTS7Ug7rvrmqDPGBOmiBRFZSAsYqL+AGZpmN65Ne6EJZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X7qGC1mw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA7FC4AF09;
	Thu, 17 Oct 2024 19:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192138;
	bh=i44pbRq9rGUCHtcZWa18Z9F7LHAZm/koPgD9OYlyqe8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X7qGC1mwaWphHvJnYg64qgEwvaT3iBSUP2fWDpsYl/B+TaAZRwV15rTy/RE5oDIMF
	 fyG40oIlQ4NW3+MHrrwbA9DNZOcDb8z/GqOvLdh4AbnxBfKIXRlQyraYOqtjGYFrlP
	 JFCVZ6F6n8NUOfB6UXfiH/UTfnE3wpJLio626WcwIBTicHvOnZ36yxBnJoSd+ulLgC
	 otYO0pfcdMDnx0bArS+gN7ycinU2YRTHlofeMO6lT846SOLtYoKN+UcnK0x0JoSns8
	 Gha17jRJVSy+bAhA/ralds/jiTVJpEojxBUOiMp6tVOJy3qm5pbrr8L83+GtWYqMdX
	 2z/Feca1GkTyA==
Date: Thu, 17 Oct 2024 12:08:57 -0700
Subject: [PATCH 29/34] xfs: make xfs_rtblock_t a segmented address like
 xfs_fsblock_t
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919072169.3453179.4216171622252724671.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we've finished adding allocation groups to the realtime volume,
let's make the file block mapping address (xfs_rtblock_t) a segmented
value just like we do on the data device.  This means that group number
and block number conversions can be done with shifting and masking
instead of integer division.

While in theory we could continue caching the rgno shift value in
m_rgblklog, the fact that we now always use the shift value means that
we have an opportunity to increase the redundancy of the rt geometry by
storing it in the ondisk superblock and adding more sb verifier code.
Extend the sueprblock to store the rgblklog value.

Now that we have segmented addresses, set the correct values in
m_groups[XG_TYPE_RTG] so that the xfs_group helpers work correctly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c     |    4 +-
 fs/xfs/libxfs/xfs_format.h   |    6 ++++
 fs/xfs/libxfs/xfs_ondisk.h   |    2 +
 fs/xfs/libxfs/xfs_rtbitmap.h |   13 ++++----
 fs/xfs/libxfs/xfs_rtgroup.h  |   69 +++++++++++++-----------------------------
 fs/xfs/libxfs/xfs_sb.c       |   65 +++++++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_sb.h       |    4 ++
 fs/xfs/libxfs/xfs_types.c    |    7 ++--
 fs/xfs/scrub/agheader.c      |   11 +++++--
 fs/xfs/xfs_mount.h           |    4 +-
 fs/xfs/xfs_rtalloc.c         |    4 +-
 fs/xfs/xfs_trans.c           |   21 ++++++++++---
 12 files changed, 126 insertions(+), 84 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3498d7b4fbc54e..9052839305e2ca 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3152,10 +3152,8 @@ xfs_bmap_adjacent_valid(
 
 	if (XFS_IS_REALTIME_INODE(ap->ip) &&
 	    (ap->datatype & XFS_ALLOC_USERDATA)) {
-		if (x >= mp->m_sb.sb_rblocks)
-			return false;
 		if (!xfs_has_rtgroups(mp))
-			return true;
+			return x < mp->m_sb.sb_rblocks;
 
 		return xfs_rtb_to_rgno(mp, x) == xfs_rtb_to_rgno(mp, y) &&
 			xfs_rtb_to_rgno(mp, x) < mp->m_sb.sb_rgcount &&
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index f56ff9f43c218f..d6c10855ab023b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -179,6 +179,9 @@ typedef struct xfs_sb {
 	xfs_rgnumber_t	sb_rgcount;	/* number of realtime groups */
 	xfs_rtxlen_t	sb_rgextents;	/* size of a realtime group in rtx */
 
+	uint8_t		sb_rgblklog;    /* rt group number shift */
+	uint8_t		sb_pad[7];	/* zeroes */
+
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
@@ -268,6 +271,9 @@ struct xfs_dsb {
 	__be32		sb_rgcount;	/* # of realtime groups */
 	__be32		sb_rgextents;	/* size of rtgroup in rtx */
 
+	__u8		sb_rgblklog;    /* rt group number shift */
+	__u8		sb_pad[7];	/* zeroes */
+
 	/*
 	 * The size of this structure must be padded to 64 bit alignment.
 	 *
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 6a2bcbc392842c..99eae7f67e961b 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -37,7 +37,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			280);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			288);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index e0fb36f181cc9e..16563a44bd138a 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -26,7 +26,7 @@ xfs_rtx_to_rtb(
 	xfs_rtxnum_t		rtx)
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
-	xfs_rtblock_t		start = xfs_rgno_start_rtb(mp, rtg_rgno(rtg));
+	xfs_rtblock_t		start = xfs_group_start_fsb(rtg_group(rtg));
 
 	if (mp->m_rtxblklog >= 0)
 		return start + (rtx << mp->m_rtxblklog);
@@ -128,11 +128,11 @@ xfs_rtb_to_rtx(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	uint64_t		__rgbno = __xfs_rtb_to_rgbno(mp, rtbno);
-
+	/* open-coded 64-bit masking operation */
+	rtbno &= mp->m_groups[XG_TYPE_RTG].blkmask;
 	if (likely(mp->m_rtxblklog >= 0))
-		return __rgbno >> mp->m_rtxblklog;
-	return div_u64(__rgbno, mp->m_sb.sb_rextsize);
+		return rtbno >> mp->m_rtxblklog;
+	return div_u64(rtbno, mp->m_sb.sb_rextsize);
 }
 
 /* Return the offset of an rt block number within an rt extent. */
@@ -141,9 +141,10 @@ xfs_rtb_to_rtxoff(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
+	/* open-coded 64-bit masking operation */
+	rtbno &= mp->m_groups[XG_TYPE_RTG].blkmask;
 	if (likely(mp->m_rtxblklog >= 0))
 		return rtbno & mp->m_rtxblkmask;
-
 	return do_div(rtbno, mp->m_sb.sb_rextsize);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 2ddfac9a0182f9..c15b232e1f8e77 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -122,31 +122,12 @@ xfs_rtgroup_next(
 	return xfs_rtgroup_next_range(mp, rtg, 0, mp->m_sb.sb_rgcount - 1);
 }
 
-static inline xfs_rtblock_t
-xfs_rgno_start_rtb(
-	struct xfs_mount	*mp,
-	xfs_rgnumber_t		rgno)
-{
-	if (mp->m_rgblklog >= 0)
-		return ((xfs_rtblock_t)rgno << mp->m_rgblklog);
-	return ((xfs_rtblock_t)rgno * mp->m_rgblocks);
-}
-
-static inline xfs_rtblock_t
-__xfs_rgbno_to_rtb(
-	struct xfs_mount	*mp,
-	xfs_rgnumber_t		rgno,
-	xfs_rgblock_t		rgbno)
-{
-	return xfs_rgno_start_rtb(mp, rgno) + rgbno;
-}
-
 static inline xfs_rtblock_t
 xfs_rgbno_to_rtb(
 	struct xfs_rtgroup	*rtg,
 	xfs_rgblock_t		rgbno)
 {
-	return __xfs_rgbno_to_rtb(rtg_mount(rtg), rtg_rgno(rtg), rgbno);
+	return xfs_gbno_to_fsb(rtg_group(rtg), rgbno);
 }
 
 static inline xfs_rgnumber_t
@@ -154,30 +135,7 @@ xfs_rtb_to_rgno(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	if (!xfs_has_rtgroups(mp))
-		return 0;
-
-	if (mp->m_rgblklog >= 0)
-		return rtbno >> mp->m_rgblklog;
-
-	return div_u64(rtbno, mp->m_rgblocks);
-}
-
-static inline uint64_t
-__xfs_rtb_to_rgbno(
-	struct xfs_mount	*mp,
-	xfs_rtblock_t		rtbno)
-{
-	uint32_t		rem;
-
-	if (!xfs_has_rtgroups(mp))
-		return rtbno;
-
-	if (mp->m_rgblklog >= 0)
-		return rtbno & mp->m_rgblkmask;
-
-	div_u64_rem(rtbno, mp->m_rgblocks, &rem);
-	return rem;
+	return xfs_fsb_to_gno(mp, rtbno, XG_TYPE_RTG);
 }
 
 static inline xfs_rgblock_t
@@ -185,7 +143,7 @@ xfs_rtb_to_rgbno(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	return __xfs_rtb_to_rgbno(mp, rtbno);
+	return xfs_fsb_to_gbno(mp, rtbno, XG_TYPE_RTG);
 }
 
 /* Is rtbno the start of a RT group? */
@@ -194,7 +152,7 @@ xfs_rtbno_is_group_start(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	return (rtbno & mp->m_rgblkmask) == 0;
+	return (rtbno & mp->m_groups[XG_TYPE_RTG].blkmask) == 0;
 }
 
 static inline xfs_daddr_t
@@ -202,7 +160,11 @@ xfs_rtb_to_daddr(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	return rtbno << mp->m_blkbb_log;
+	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+	xfs_rgnumber_t		rgno = xfs_rtb_to_rgno(mp, rtbno);
+	uint64_t		start_bno = (xfs_rtblock_t)rgno * g->blocks;
+
+	return XFS_FSB_TO_BB(mp, start_bno + (rtbno & g->blkmask));
 }
 
 static inline xfs_rtblock_t
@@ -210,7 +172,18 @@ xfs_daddr_to_rtb(
 	struct xfs_mount	*mp,
 	xfs_daddr_t		daddr)
 {
-	return daddr >> mp->m_blkbb_log;
+	xfs_rfsblock_t		bno = XFS_BB_TO_FSBT(mp, daddr);
+
+	if (xfs_has_rtgroups(mp)) {
+		struct xfs_groups *g = &mp->m_groups[XG_TYPE_RTG];
+		xfs_rgnumber_t	rgno;
+		uint32_t	rgbno;
+
+		rgno = div_u64_rem(bno, g->blocks, &rgbno);
+		return ((xfs_rtblock_t)rgno << g->blklog) + rgbno;
+	}
+
+	return bno;
 }
 
 #ifdef CONFIG_XFS_RT
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 1af7029753ea15..6a31f48a2c5424 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -368,12 +368,23 @@ xfs_validate_sb_write(
 	return 0;
 }
 
+int
+xfs_compute_rgblklog(
+	xfs_rtxlen_t	rgextents,
+	xfs_rgblock_t	rextsize)
+{
+	uint64_t	rgblocks = (uint64_t)rgextents * rextsize;
+
+	return xfs_highbit64(rgblocks - 1) + 1;
+}
+
 static int
 xfs_validate_sb_rtgroups(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
 	uint64_t		groups;
+	int			rgblklog;
 
 	if (sbp->sb_rextsize == 0) {
 		xfs_warn(mp,
@@ -418,6 +429,14 @@ xfs_validate_sb_rtgroups(
 		return -EINVAL;
 	}
 
+	rgblklog = xfs_compute_rgblklog(sbp->sb_rgextents, sbp->sb_rextsize);
+	if (sbp->sb_rgblklog != rgblklog) {
+		xfs_warn(mp,
+"Realtime group log (%d) does not match expected value (%d).",
+				sbp->sb_rgblklog, rgblklog);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -484,6 +503,12 @@ xfs_validate_sb_common(
 		}
 
 		if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
+			if (memchr_inv(sbp->sb_pad, 0, sizeof(sbp->sb_pad))) {
+				xfs_warn(mp,
+"Metadir superblock padding fields must be zero.");
+				return -EINVAL;
+			}
+
 			error = xfs_validate_sb_rtgroups(mp, sbp);
 			if (error)
 				return error;
@@ -789,6 +814,8 @@ __xfs_sb_from_disk(
 
 	if (to->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
 		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
+		to->sb_rgblklog = from->sb_rgblklog;
+		memcpy(to->sb_pad, from->sb_pad, sizeof(to->sb_pad));
 		to->sb_rgcount = be32_to_cpu(from->sb_rgcount);
 		to->sb_rgextents = be32_to_cpu(from->sb_rgextents);
 		to->sb_rbmino = NULLFSINO;
@@ -956,6 +983,8 @@ xfs_sb_to_disk(
 
 	if (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR) {
 		to->sb_metadirino = cpu_to_be64(from->sb_metadirino);
+		to->sb_rgblklog = from->sb_rgblklog;
+		memset(to->sb_pad, 0, sizeof(to->sb_pad));
 		to->sb_rgcount = cpu_to_be32(from->sb_rgcount);
 		to->sb_rgextents = cpu_to_be32(from->sb_rgextents);
 		to->sb_rbmino = cpu_to_be64(0);
@@ -1090,8 +1119,9 @@ const struct xfs_buf_ops xfs_sb_quiet_buf_ops = {
 	.verify_write = xfs_sb_write_verify,
 };
 
+/* Compute cached rt geometry from the incore sb. */
 void
-xfs_mount_sb_set_rextsize(
+xfs_sb_mount_rextsize(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
@@ -1100,13 +1130,32 @@ xfs_mount_sb_set_rextsize(
 	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
 	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
 
-	mp->m_rgblocks = sbp->sb_rgextents * sbp->sb_rextsize;
-	mp->m_rgblklog = log2_if_power2(mp->m_rgblocks);
-	mp->m_rgblkmask = mask64_if_power2(mp->m_rgblocks);
+	if (xfs_sb_is_v5(sbp) &&
+	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)) {
+		rgs->blocks = sbp->sb_rgextents * sbp->sb_rextsize;
+		rgs->blklog = mp->m_sb.sb_rgblklog;
+		rgs->blkmask = xfs_mask32lo(mp->m_sb.sb_rgblklog);
+	} else {
+		rgs->blocks = 0;
+		rgs->blklog = 0;
+		rgs->blkmask = (uint64_t)-1;
+	}
+}
 
-	rgs->blocks = 0;
-	rgs->blklog = 0;
-	rgs->blkmask = (uint64_t)-1;
+/* Update incore sb rt extent size, then recompute the cached rt geometry. */
+void
+xfs_mount_sb_set_rextsize(
+	struct xfs_mount	*mp,
+	struct xfs_sb		*sbp,
+	xfs_agblock_t		rextsize)
+{
+	sbp->sb_rextsize = rextsize;
+	if (xfs_sb_is_v5(sbp) &&
+	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR))
+		sbp->sb_rgblklog = xfs_compute_rgblklog(sbp->sb_rgextents,
+							rextsize);
+
+	xfs_sb_mount_rextsize(mp, sbp);
 }
 
 /*
@@ -1140,7 +1189,7 @@ xfs_sb_mount_common(
 	ags->blklog = mp->m_sb.sb_agblklog;
 	ags->blkmask = xfs_mask32lo(mp->m_sb.sb_agblklog);
 
-	xfs_mount_sb_set_rextsize(mp, sbp);
+	xfs_sb_mount_rextsize(mp, sbp);
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, true);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, false);
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 999dcfccdaf960..34d0dd374e9b0b 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -17,8 +17,9 @@ extern void	xfs_log_sb(struct xfs_trans *tp);
 extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
 extern int	xfs_sync_sb_buf(struct xfs_mount *mp, bool update_rtsb);
 extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
+void		xfs_sb_mount_rextsize(struct xfs_mount *mp, struct xfs_sb *sbp);
 void		xfs_mount_sb_set_rextsize(struct xfs_mount *mp,
-			struct xfs_sb *sbp);
+			struct xfs_sb *sbp, xfs_agblock_t rextsize);
 extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
 extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
@@ -43,5 +44,6 @@ bool	xfs_validate_stripe_geometry(struct xfs_mount *mp,
 bool	xfs_validate_rt_geometry(struct xfs_sb *sbp);
 
 uint8_t xfs_compute_rextslog(xfs_rtbxlen_t rtextents);
+int xfs_compute_rgblklog(xfs_rtxlen_t rgextents, xfs_rgblock_t rextsize);
 
 #endif	/* __XFS_SB_H__ */
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index a4c30844d42be1..1faf04204c5ddc 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -146,9 +146,6 @@ xfs_verify_rtbno(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno)
 {
-	if (rtbno >= mp->m_sb.sb_rblocks)
-		return false;
-
 	if (xfs_has_rtgroups(mp)) {
 		xfs_rgnumber_t	rgno = xfs_rtb_to_rgno(mp, rtbno);
 		xfs_rtxnum_t	rtx = xfs_rtb_to_rtx(mp, rtbno);
@@ -159,8 +156,10 @@ xfs_verify_rtbno(
 			return false;
 		if (xfs_has_rtsb(mp) && rgno == 0 && rtx == 0)
 			return false;
+		return true;
 	}
-	return true;
+
+	return rtbno < mp->m_sb.sb_rblocks;
 }
 
 /*
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index cad997f38a424c..05f5e94b99382b 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -279,8 +279,15 @@ xchk_superblock(
 		if (!!(sb->sb_features2 & cpu_to_be32(~v2_ok)))
 			xchk_block_set_corrupt(sc, bp);
 
-		if (sb->sb_features2 != sb->sb_bad_features2)
-			xchk_block_set_preen(sc, bp);
+		if (xfs_has_metadir(mp)) {
+			if (sb->sb_rgblklog != mp->m_sb.sb_rgblklog)
+				xchk_block_set_corrupt(sc, bp);
+			if (memchr_inv(sb->sb_pad, 0, sizeof(sb->sb_pad)))
+				xchk_block_set_preen(sc, bp);
+		} else {
+			if (sb->sb_features2 != sb->sb_bad_features2)
+				xchk_block_set_preen(sc, bp);
+		}
 	}
 
 	/* Check sb_features2 flags that are set at mkfs time. */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7b6902c21d50c9..ba3dc583b68687 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -147,7 +147,7 @@ typedef struct xfs_mount {
 	uint8_t			m_agno_log;	/* log #ag's */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
-	int8_t			m_rgblklog;	/* log2 of rt group sz if possible */
+
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	/* number of rt extents per rt bitmap block if rtgroups enabled */
@@ -177,14 +177,12 @@ typedef struct xfs_mount {
 	int			m_logbsize;	/* size of each log buffer */
 	unsigned int		m_rsumlevels;	/* rt summary levels */
 	xfs_filblks_t		m_rsumblocks;	/* size of rt summary, FSBs */
-	uint32_t		m_rgblocks;	/* size of rtgroup in rtblocks */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint			m_qflags;	/* quota status flags */
 	uint64_t		m_features;	/* active filesystem features */
 	uint64_t		m_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_low_rtexts[XFS_LOWSP_MAX];
 	uint64_t		m_rtxblkmask;	/* rt extent block mask */
-	uint64_t		m_rgblkmask;	/* rt group block mask */
 	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
 						/* low free space thresholds */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 783674fd42ead1..db09c086ff1c01 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -745,8 +745,7 @@ xfs_growfs_rt_alloc_fake_mount(
 	nmp = kmemdup(mp, sizeof(*mp), GFP_KERNEL);
 	if (!nmp)
 		return NULL;
-	nmp->m_sb.sb_rextsize = rextsize;
-	xfs_mount_sb_set_rextsize(nmp, &nmp->m_sb);
+	xfs_mount_sb_set_rextsize(nmp, &nmp->m_sb, rextsize);
 	nmp->m_sb.sb_rblocks = rblocks;
 	nmp->m_sb.sb_rextents = xfs_blen_to_rtbxlen(nmp, nmp->m_sb.sb_rblocks);
 	nmp->m_sb.sb_rbmblocks = xfs_rtbitmap_blockcount(nmp);
@@ -968,7 +967,6 @@ xfs_growfs_rt_bmblock(
 	 */
 	mp->m_rsumlevels = nmp->m_rsumlevels;
 	mp->m_rsumblocks = nmp->m_rsumblocks;
-	xfs_mount_sb_set_rextsize(mp, &mp->m_sb);
 
 	/*
 	 * Recompute the growfsrt reservation from the new rsumsize.
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index a29a181e684041..4db022c189e134 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -26,6 +26,7 @@
 #include "xfs_icache.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_sb.h"
 
 struct kmem_cache	*xfs_trans_cache;
 
@@ -547,6 +548,18 @@ xfs_trans_apply_sb_deltas(
 	}
 	if (tp->t_rextsize_delta) {
 		be32_add_cpu(&sbp->sb_rextsize, tp->t_rextsize_delta);
+
+		/*
+		 * Because the ondisk sb records rtgroup size in units of rt
+		 * extents, any time we update the rt extent size we have to
+		 * recompute the ondisk rtgroup block log.  The incore values
+		 * will be recomputed in xfs_trans_unreserve_and_mod_sb.
+		 */
+		if (xfs_has_rtgroups(tp->t_mountp)) {
+			sbp->sb_rgblklog = xfs_compute_rgblklog(
+						be32_to_cpu(sbp->sb_rgextents),
+						be32_to_cpu(sbp->sb_rextsize));
+		}
 		whole = 1;
 	}
 	if (tp->t_rbmblocks_delta) {
@@ -673,11 +686,9 @@ xfs_trans_unreserve_and_mod_sb(
 	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
 	mp->m_sb.sb_agcount += tp->t_agcount_delta;
 	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;
-	mp->m_sb.sb_rextsize += tp->t_rextsize_delta;
-	if (tp->t_rextsize_delta) {
-		mp->m_rtxblklog = log2_if_power2(mp->m_sb.sb_rextsize);
-		mp->m_rtxblkmask = mask64_if_power2(mp->m_sb.sb_rextsize);
-	}
+	if (tp->t_rextsize_delta)
+		xfs_mount_sb_set_rextsize(mp, &mp->m_sb,
+				mp->m_sb.sb_rextsize + tp->t_rextsize_delta);
 	mp->m_sb.sb_rbmblocks += tp->t_rbmblocks_delta;
 	mp->m_sb.sb_rblocks += tp->t_rblocks_delta;
 	mp->m_sb.sb_rextents += tp->t_rextents_delta;


