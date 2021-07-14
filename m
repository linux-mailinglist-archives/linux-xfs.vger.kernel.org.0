Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA10F3C7D54
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Jul 2021 06:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237655AbhGNEWS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Jul 2021 00:22:18 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:35276 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237787AbhGNEWK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 00:22:10 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 3A6EF6B7B4
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 14:19:17 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3WMe-006JKE-Fw
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 14:19:16 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m3WMe-00B15P-8E
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 14:19:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/16] xfs: remove unused xfs_sb_version_has wrappers
Date:   Wed, 14 Jul 2021 14:19:10 +1000
Message-Id: <20210714041912.2625692-15-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714041912.2625692-1-david@fromorbit.com>
References: <20210714041912.2625692-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=xUKRZpgT5Toe9Xmcx7oA:9
        a=t8ESkBOVATy2oPz1:21 a=15jB-yk5TJvLmFcB:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The vast majority of these wrappers are now unused. Remove them
leaving just the small subset of wrappers that are used to either
add feature bits or make the mount features field setup code
simpler.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 155 +------------------------------------
 1 file changed, 3 insertions(+), 152 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d1b0933c90eb..0bd44a780937 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -279,11 +279,6 @@ typedef struct xfs_dsb {
 
 #define	XFS_SB_VERSION_NUM(sbp)	((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
 
-static inline bool xfs_sb_version_hasrealtime(struct xfs_sb *sbp)
-{
-	return sbp->sb_rblocks > 0;
-}
-
 /*
  * Detect a mismatched features2 field.  Older kernels read/wrote
  * this into the wrong slot, so to be safe we keep them in sync.
@@ -293,9 +288,10 @@ static inline bool xfs_sb_has_mismatched_features2(struct xfs_sb *sbp)
 	return sbp->sb_bad_features2 != sbp->sb_features2;
 }
 
-static inline bool xfs_sb_version_hasattr(struct xfs_sb *sbp)
+static inline bool xfs_sb_version_hasmorebits(struct xfs_sb *sbp)
 {
-	return (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT);
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
+	       (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
 }
 
 static inline void xfs_sb_version_addattr(struct xfs_sb *sbp)
@@ -303,79 +299,17 @@ static inline void xfs_sb_version_addattr(struct xfs_sb *sbp)
 	sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
 }
 
-static inline bool xfs_sb_version_hasquota(struct xfs_sb *sbp)
-{
-	return (sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT);
-}
-
 static inline void xfs_sb_version_addquota(struct xfs_sb *sbp)
 {
 	sbp->sb_versionnum |= XFS_SB_VERSION_QUOTABIT;
 }
 
-static inline bool xfs_sb_version_hasalign(struct xfs_sb *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
-		(sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT));
-}
-
-static inline bool xfs_sb_version_hasdalign(struct xfs_sb *sbp)
-{
-	return (sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT);
-}
-
-static inline bool xfs_sb_version_haslogv2(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
-	       (sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT);
-}
-
-static inline bool xfs_sb_version_hassector(struct xfs_sb *sbp)
-{
-	return (sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT);
-}
-
-static inline bool xfs_sb_version_hasasciici(struct xfs_sb *sbp)
-{
-	return (sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT);
-}
-
-static inline bool xfs_sb_version_hasmorebits(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 ||
-	       (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT);
-}
-
-/*
- * sb_features2 bit version macros.
- */
-static inline bool xfs_sb_version_haslazysbcount(struct xfs_sb *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (xfs_sb_version_hasmorebits(sbp) &&
-		(sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT));
-}
-
-static inline bool xfs_sb_version_hasattr2(struct xfs_sb *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (xfs_sb_version_hasmorebits(sbp) &&
-		(sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT));
-}
-
 static inline void xfs_sb_version_addattr2(struct xfs_sb *sbp)
 {
 	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
 	sbp->sb_features2 |= XFS_SB_VERSION2_ATTR2BIT;
 }
 
-static inline bool xfs_sb_version_hasprojid32(struct xfs_sb *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) ||
-	       (xfs_sb_version_hasmorebits(sbp) &&
-		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT));
-}
-
 static inline void xfs_sb_version_addprojid32(struct xfs_sb *sbp)
 {
 	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
@@ -459,13 +393,6 @@ xfs_sb_has_incompat_log_feature(
 	return (sbp->sb_features_log_incompat & feature) != 0;
 }
 
-/*
- * V5 superblock specific feature checks
- */
-static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
-}
 
 /*
  * v5 file systems support V3 inodes only, earlier file systems support
@@ -484,82 +411,6 @@ static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
 	return version == 1 || version == 2;
 }
 
-static inline bool xfs_sb_version_haspquotino(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
-}
-
-static inline int xfs_sb_version_hasftype(struct xfs_sb *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_FTYPE)) ||
-	       (xfs_sb_version_hasmorebits(sbp) &&
-		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));
-}
-
-static inline bool xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
-		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
-}
-
-static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_SPINODES);
-}
-
-/*
- * XFS_SB_FEAT_INCOMPAT_META_UUID indicates that the metadata UUID
- * is stored separately from the user-visible UUID; this allows the
- * user-visible UUID to be changed on V5 filesystems which have a
- * filesystem UUID stamped into every piece of metadata.
- */
-static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
-		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
-}
-
-static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
-{
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
-		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
-}
-
-static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
-}
-
-static inline bool xfs_sb_version_hasbigtime(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME);
-}
-
-/*
- * Inode btree block counter.  We record the number of inobt and finobt blocks
- * in the AGI header so that we can skip the finobt walk at mount time when
- * setting up per-AG reservations.
- */
-static inline bool xfs_sb_version_hasinobtcounts(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT);
-}
-
-static inline bool xfs_sb_version_needsrepair(struct xfs_sb *sbp)
-{
-	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
-		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR);
-}
-
-/*
- * end of superblock version macros
- */
-
 static inline bool
 xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
 {
-- 
2.31.1

