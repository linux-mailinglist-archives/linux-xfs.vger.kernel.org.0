Return-Path: <linux-xfs+bounces-1273-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12E14820D70
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:16:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6DDC1F21CE0
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 20:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0315EBA2E;
	Sun, 31 Dec 2023 20:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lv2e8J2v"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A3ABA31
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B13C433C8;
	Sun, 31 Dec 2023 20:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053770;
	bh=MbSESyS53oJ6v3h8vgUYADjii9tMi98fssfDykqTviM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lv2e8J2vT3+eCKaKSdbLOR/wVRTf4UvvuSckExTMYy9VgSajAsFHbQnm3haTTcvqp
	 Mj9YQo3j06E06so6fe73wuzUI/iVDIA0JBvNmDRMf1/oTD85fNfiLynxOtefZDbT2n
	 lw6oldCZYuwOqY66lZBY3rzZiojKW7b9jUOuhpyanAIgfV1I4lFZxfEb4pKDeE4PDT
	 wSdmYRocfYK1OVnNsIqAf66VatsiuL2ymZreah4/qFpQspNbcL5xmpUePdbS2hh+uD
	 ymP/LcWz6YIk/lSBfcF7gVh+hcBeqoCpZ+7jdRSubfInVLx9HrEbk0NOVzSRbaDQ4l
	 e3xe01Aaa8KIA==
Date: Sun, 31 Dec 2023 12:16:10 -0800
Subject: [PATCH 1/4] xfs: create a helper to decide if a file mapping targets
 the rt volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404830098.1749125.5760205126330237337.stgit@frogsfrogsfrogs>
In-Reply-To: <170404830071.1749125.16096260756312609957.stgit@frogsfrogsfrogs>
References: <170404830071.1749125.16096260756312609957.stgit@frogsfrogsfrogs>
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

Create a helper so that we can stop open-coding this decision
everywhere.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c       |    6 +++---
 fs/xfs/libxfs/xfs_inode_fork.c |    9 +++++++++
 fs/xfs/libxfs/xfs_inode_fork.h |    1 +
 fs/xfs/scrub/bmap.c            |    2 +-
 4 files changed, 14 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f815e8b2809bc..e03754826db56 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4889,7 +4889,7 @@ xfs_bmap_del_extent_delay(
 
 	XFS_STATS_INC(mp, xs_del_exlist);
 
-	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isrt = xfs_ifork_is_realtime(ip, whichfork);
 	del_endoff = del->br_startoff + del->br_blockcount;
 	got_endoff = got->br_startoff + got->br_blockcount;
 	da_old = startblockval(got->br_startblock);
@@ -5125,7 +5125,7 @@ xfs_bmap_del_extent_real(
 		return -ENOSPC;
 
 	*logflagsp = XFS_ILOG_CORE;
-	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
+	if (xfs_ifork_is_realtime(ip, whichfork)) {
 		if (!(bflags & XFS_BMAPI_REMAP)) {
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
@@ -5372,7 +5372,7 @@ __xfs_bunmapi(
 		return 0;
 	}
 	XFS_STATS_INC(mp, xs_blk_unmap);
-	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+	isrt = xfs_ifork_is_realtime(ip, whichfork);
 	end = start + len;
 
 	if (!xfs_iext_lookup_extent_before(ip, ifp, &end, &icur, &got)) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 88aff6b0bda02..bce36df4402a3 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -820,3 +820,12 @@ xfs_iext_count_upgrade(
 
 	return 0;
 }
+
+/* Decide if a file mapping is on the realtime device or not. */
+bool
+xfs_ifork_is_realtime(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	return XFS_IS_REALTIME_INODE(ip) && whichfork != XFS_ATTR_FORK;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 535be5c036899..ebeb925be09d9 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -262,6 +262,7 @@ int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
 		int nr_to_add);
 int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
 		uint nr_to_add);
+bool xfs_ifork_is_realtime(struct xfs_inode *ip, int whichfork);
 
 /* returns true if the fork has extents but they are not read in yet. */
 static inline bool xfs_need_iread_extents(const struct xfs_ifork *ifp)
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index b169cddde6da4..24a15bf784f11 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -924,7 +924,7 @@ xchk_bmap(
 	if (!ifp)
 		return -ENOENT;
 
-	info.is_rt = whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip);
+	info.is_rt = xfs_ifork_is_realtime(ip, whichfork);
 	info.whichfork = whichfork;
 	info.is_shared = whichfork == XFS_DATA_FORK && xfs_is_reflink_inode(ip);
 	info.sc = sc;


