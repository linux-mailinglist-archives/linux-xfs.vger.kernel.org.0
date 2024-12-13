Return-Path: <linux-xfs+bounces-16635-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01C809F0187
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 02:05:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACBE5281ABD
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 01:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 210CF1759F;
	Fri, 13 Dec 2024 01:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vDfe+e0S"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BE353BE
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051932; cv=none; b=fhoI8EKE/KaaCQKwSVoC1QjjARlaXuJlNFxVVijFQcCzMwAV0xYoc0ezU/nqOpgxwOQdciip9cnt76drXiRoCKVqQLwIzyFFrsudyYJZrAa4efo7rIYbx69V47qCqouxiQEMna6RANceJ4rfwFDs3Q/WlWjaES+NTgF4rvR5NKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051932; c=relaxed/simple;
	bh=ej7SpNnQCxrpTsx4Z7nfWCq7PENLh92BrP7YKc2ylzM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KcE84T+dnFduPAChmm0TNSi19EppZHtq92c26/ENLI9pB2plOSMmbM9T+UX50jW1BAG35dHx4q6HXJ4RWDLEw0L375UJr0dxpznATB8KQofBCCImPbEVvjamm03SUrU/Nz1gU9/6i9QQ11qMt/Oa5SHBtLezCewoKkgze/HZ99s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vDfe+e0S; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9643C4CECE;
	Fri, 13 Dec 2024 01:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051932;
	bh=ej7SpNnQCxrpTsx4Z7nfWCq7PENLh92BrP7YKc2ylzM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vDfe+e0SYGen7VzH0kkpaFn/hGhncw3C27u9zasswl05Th9hGNjE72DIlNt+hx3wV
	 NRq5sG+EKT0qLc01wfdLErzYdZS3bq6uRzAHnjSly/3OIG3QaXTMekj8u3q18aItq+
	 n4BntixyYMrRtx02GlUSk7xMugehSk/Wqyi/reJArVA4DMChto6I6zLvRumklKRJX8
	 Gz184rMnhYRKkIdIBldJhvwQpO6OV84nu8Dx9hMb2s+EKEAod3MjuCo38ZKaGOhLHb
	 Zu9MfdOaC3fOT6YbLSMpXV/cKkg6GFkKbb3HJaLWvB2wr74iPUY9vLrxXyfJTH52sU
	 /7G9EUAUFGvHA==
Date: Thu, 12 Dec 2024 17:05:32 -0800
Subject: [PATCH 19/37] xfs: report realtime rmap btree corruption errors to
 the health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123640.1181370.2788362731455898690.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Whenever we encounter corrupt realtime rmap btree blocks, we should
report that to the health monitoring system for later reporting.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.h        |    2 +-
 fs/xfs/libxfs/xfs_fs.h           |    1 +
 fs/xfs/libxfs/xfs_health.h       |    4 +++-
 fs/xfs/libxfs/xfs_rtgroup.c      |    1 +
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   10 ++++++++--
 fs/xfs/xfs_health.c              |    1 +
 6 files changed, 15 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index ee82dc777d6d5b..dbc047b2fb2cf5 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -135,7 +135,7 @@ struct xfs_btree_ops {
 	/* offset of btree stats array */
 	unsigned int		statoff;
 
-	/* sick mask for health reporting (only for XFS_BTREE_TYPE_AG) */
+	/* sick mask for health reporting (not for bmap btrees) */
 	unsigned int		sick_mask;
 
 	/* cursor operations */
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 41ce4d3d650ec7..7cca458ff81245 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -993,6 +993,7 @@ struct xfs_rtgroup_geometry {
 #define XFS_RTGROUP_GEOM_SICK_SUPER	(1U << 0)  /* superblock */
 #define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
 #define XFS_RTGROUP_GEOM_SICK_SUMMARY	(1U << 2)  /* rtsummary */
+#define XFS_RTGROUP_GEOM_SICK_RMAPBT	(1U << 3)  /* reverse mappings */
 
 /*
  * ioctl commands that are used by Linux filesystems
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index d34986ac18c3fa..5c8a0aff6ba6e9 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -70,6 +70,7 @@ struct xfs_rtgroup;
 #define XFS_SICK_RG_SUPER	(1 << 0)  /* rt group superblock */
 #define XFS_SICK_RG_BITMAP	(1 << 1)  /* rt group bitmap */
 #define XFS_SICK_RG_SUMMARY	(1 << 2)  /* rt groups summary */
+#define XFS_SICK_RG_RMAPBT	(1 << 3)  /* reverse mappings */
 
 /* Observable health issues for AG metadata. */
 #define XFS_SICK_AG_SB		(1 << 0)  /* superblock */
@@ -115,7 +116,8 @@ struct xfs_rtgroup;
 
 #define XFS_SICK_RG_PRIMARY	(XFS_SICK_RG_SUPER | \
 				 XFS_SICK_RG_BITMAP | \
-				 XFS_SICK_RG_SUMMARY)
+				 XFS_SICK_RG_SUMMARY | \
+				 XFS_SICK_RG_RMAPBT)
 
 #define XFS_SICK_AG_PRIMARY	(XFS_SICK_AG_SB | \
 				 XFS_SICK_AG_AGF | \
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 5f31b6e65d5d17..b7ed2d27d54553 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -357,6 +357,7 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 	[XFS_RTGI_RMAP] = {
 		.name		= "rmap",
 		.metafile_type	= XFS_METAFILE_RTRMAP,
+		.sick		= XFS_SICK_RG_RMAPBT,
 		.fmt_mask	= 1U << XFS_DINODE_FMT_META_BTREE,
 		/*
 		 * growfs must create the rtrmap inodes before adding a
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 7654661f4f5823..0a78dee01b1b2e 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -27,6 +27,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_rtgroup.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 static struct kmem_cache	*xfs_rtrmapbt_cur_cache;
 
@@ -496,6 +497,7 @@ const struct xfs_btree_ops xfs_rtrmapbt_ops = {
 
 	.lru_refs		= XFS_RMAP_BTREE_REF,
 	.statoff		= XFS_STATS_CALC_INDEX(xs_rtrmap_2),
+	.sick_mask		= XFS_SICK_RG_RMAPBT,
 
 	.dup_cursor		= xfs_rtrmapbt_dup_cursor,
 	.alloc_block		= xfs_btree_alloc_metafile_block,
@@ -755,16 +757,20 @@ xfs_iformat_rtrmap(
 	 * growfs must create the rtrmap inodes before adding a realtime volume
 	 * to the filesystem, so we cannot use the rtrmapbt predicate here.
 	 */
-	if (!xfs_has_rmapbt(ip->i_mount))
+	if (!xfs_has_rmapbt(ip->i_mount)) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
+	}
 
 	dsize = XFS_DFORK_SIZE(dip, mp, XFS_DATA_FORK);
 	numrecs = be16_to_cpu(dfp->bb_numrecs);
 	level = be16_to_cpu(dfp->bb_level);
 
 	if (level > mp->m_rtrmap_maxlevels ||
-	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize)
+	    xfs_rtrmap_droot_space_calc(level, numrecs) > dsize) {
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;
+	}
 
 	broot = xfs_broot_alloc(xfs_ifork_ptr(ip, XFS_DATA_FORK),
 			xfs_rtrmap_broot_space_calc(mp, level, numrecs));
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index c7c2e656199862..d438c3c001c829 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -447,6 +447,7 @@ static const struct ioctl_sick_map rtgroup_map[] = {
 	{ XFS_SICK_RG_SUPER,	XFS_RTGROUP_GEOM_SICK_SUPER },
 	{ XFS_SICK_RG_BITMAP,	XFS_RTGROUP_GEOM_SICK_BITMAP },
 	{ XFS_SICK_RG_SUMMARY,	XFS_RTGROUP_GEOM_SICK_SUMMARY },
+	{ XFS_SICK_RG_RMAPBT,	XFS_RTGROUP_GEOM_SICK_RMAPBT },
 };
 
 /* Fill out rtgroup geometry health info. */


