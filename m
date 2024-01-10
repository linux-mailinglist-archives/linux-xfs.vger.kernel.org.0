Return-Path: <linux-xfs+bounces-2187-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C4A88211D9
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 01:14:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E23E72829C2
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4891438B;
	Mon,  1 Jan 2024 00:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YtyOyLvE"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1554A384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA59DC433C7;
	Mon,  1 Jan 2024 00:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068034;
	bh=Lf79KrF0veZivVgluOkRTexqazsrNCKF7qD1nF6vIVc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YtyOyLvEQNgDIAIGI8jHu6QqzmWGyvMypCW8sKMi07TlulsPnAgqUECijUq1QFx2y
	 5oMdmuNbJ4TTwszMD7uQfrFW7Lrj5x9Wl6uBSsIezoM35FXmkn9w9+Hkz/Tu5FgGF1
	 yOIT+ONINMVc6Ly8qZ6eHNXPBCdCbU8zHa8Hfca5UtQaqLdGNWpRUIQPFFM1Bk1J1X
	 QtGg3Q34dw9beWuH49QHxU8OpDTe9DV9qPTsLV3JBXUSEWXEY+z4BPjcNW/RzsKeg0
	 xnm5JQWiyLmMWXOGyA6Kd9cGWXdK2PAXnwSPCjfH/1gQnkcaatoc2vmoiri3mi/C0v
	 NOcFQa+IGHjCw==
Date: Sun, 31 Dec 2023 16:13:54 +9900
Subject: [PATCH 13/47] xfs: wire up rmap map and unmap to the realtime rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015486.1815505.12292666543253691172.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Connect the map and unmap reverse-mapping operations to the realtime
rmapbt via the deferred operation callbacks.  This enables us to
perform rmap operations against the correct btree.

[Contains a minor bugfix from hch]

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap.c    |   37 ++++++++++++++++++++++++++++++++++---
 libxfs/xfs_rtgroup.c |    9 +++++++++
 libxfs/xfs_rtgroup.h |    5 ++++-
 3 files changed, 47 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 00544d6a20f..cf2968cbd7f 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -25,6 +25,7 @@
 #include "xfs_health.h"
 #include "defer_item.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -2691,9 +2692,39 @@ xfs_rtrmap_finish_one(
 	struct xfs_rmap_intent		*ri,
 	struct xfs_btree_cur		**pcur)
 {
-	/* coming in a subsequent patch */
-	ASSERT(0);
-	return -EFSCORRUPTED;
+	struct xfs_owner_info		oinfo;
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_btree_cur		*rcur = *pcur;
+	xfs_rgnumber_t			rgno;
+	xfs_rgblock_t			bno;
+	bool				unwritten;
+
+	trace_xfs_rmap_deferred(mp, ri);
+
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RMAP_FINISH_ONE))
+		return -EIO;
+
+	/*
+	 * If we haven't gotten a cursor or the cursor rtgroup doesn't match
+	 * the startblock, get one now.
+	 */
+	if (rcur != NULL && rcur->bc_ino.rtg != ri->ri_rtg) {
+		xfs_btree_del_cursor(rcur, 0);
+		rcur = NULL;
+	}
+	if (rcur == NULL) {
+		xfs_rtgroup_lock(tp, ri->ri_rtg, XFS_RTGLOCK_RMAP);
+		*pcur = rcur = xfs_rtrmapbt_init_cursor(mp, tp, ri->ri_rtg,
+				ri->ri_rtg->rtg_rmapip);
+	}
+
+	xfs_rmap_ino_owner(&oinfo, ri->ri_owner, ri->ri_whichfork,
+			ri->ri_bmap.br_startoff);
+	unwritten = ri->ri_bmap.br_state == XFS_EXT_UNWRITTEN;
+	bno = xfs_rtb_to_rgbno(mp, ri->ri_bmap.br_startblock, &rgno);
+
+	return __xfs_rmap_finish_intent(rcur, ri->ri_type, bno,
+			ri->ri_bmap.br_blockcount, &oinfo, unwritten);
 }
 
 /*
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 4ef6b9e9094..449cd57cf9e 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -549,6 +549,12 @@ xfs_rtgroup_lock(
 		xfs_rtbitmap_lock(tp, rtg->rtg_mount);
 	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
 		xfs_rtbitmap_lock_shared(rtg->rtg_mount, XFS_RBMLOCK_BITMAP);
+
+	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg->rtg_rmapip) {
+		xfs_ilock(rtg->rtg_rmapip, XFS_ILOCK_EXCL);
+		if (tp)
+			xfs_trans_ijoin(tp, rtg->rtg_rmapip, XFS_ILOCK_EXCL);
+	}
 }
 
 /* Unlock metadata inodes associated with this rt group. */
@@ -561,6 +567,9 @@ xfs_rtgroup_unlock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
+	if ((rtglock_flags & XFS_RTGLOCK_RMAP) && rtg->rtg_rmapip)
+		xfs_iunlock(rtg->rtg_rmapip, XFS_ILOCK_EXCL);
+
 	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
 		xfs_rtbitmap_unlock(rtg->rtg_mount);
 	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 77503bda355..559a5135820 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -231,9 +231,12 @@ int xfs_rtgroup_init_secondary_super(struct xfs_mount *mp, xfs_rgnumber_t rgno,
 #define XFS_RTGLOCK_BITMAP		(1U << 0)
 /* Lock the rt bitmap inode in shared mode */
 #define XFS_RTGLOCK_BITMAP_SHARED	(1U << 1)
+/* Lock the rt rmap inode in exclusive mode */
+#define XFS_RTGLOCK_RMAP		(1U << 2)
 
 #define XFS_RTGLOCK_ALL_FLAGS	(XFS_RTGLOCK_BITMAP | \
-				 XFS_RTGLOCK_BITMAP_SHARED)
+				 XFS_RTGLOCK_BITMAP_SHARED | \
+				 XFS_RTGLOCK_RMAP)
 
 void xfs_rtgroup_lock(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		unsigned int rtglock_flags);


