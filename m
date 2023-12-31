Return-Path: <linux-xfs+bounces-1522-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6781820E8D
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 22:20:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D91A71C2191A
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:20:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2167BE4A;
	Sun, 31 Dec 2023 21:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDuCOgYu"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E980BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A32C433C8;
	Sun, 31 Dec 2023 21:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057650;
	bh=3mZoU9XTsVX45m6pqc1e/d18VzDo3r7ZepREwPb1iYk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gDuCOgYu4AadnkEHdVHWaDJ2l1FTesA0tUaP4UHtC4IYG73Dc8OP17S78Imc1BVGS
	 YOvM0WxQbxC0ybDJP7IHMWEVU8zfyvIC856BYBqVp8tNDgtHYUdNkIe9uednvt44n+
	 gCn/OJaVbntQaUufhfEBZszt7mN3hy5tQSRRfVFZU+LGFSgkGLCE8JjzLe971zEIOU
	 NjxWvhXzvkw7bqyvmDTpLN4yhw9ezjaLcCFc8uMcOeLrFERyqfCXWQ8bptoJIPCbyX
	 6r5tV7kQg2xT7XGo43C9Uf7aq1+eVM7GE/7T4xmlFbtV2r0FIprX6i7CKzVm1jo7di
	 NDVi7tazCWsCg==
Date: Sun, 31 Dec 2023 13:20:49 -0800
Subject: [PATCH 20/24] xfs: use an incore rtgroup rotor for rtpick
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846560.1763124.10631906687948394801.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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

During the 6.7 merge window, Linus noticed that the realtime allocator
was doing some sketchy things trying to encode a u64 sequence counter
into the rtbitmap file's atime.  The sketchy casting of a struct pointer
to a u64 pointer has subtly broken several times over the past decade as
the codebase has transitioned to using the VFS i_atime field and that
field has changed in size and layout over time.

Since the goal of the rtpick code is to _suggest_ a starting place for
new rt file allocations, the repeated breakage has not resulted in
inconsistent metadata.  IOWs, it's a hint.

For rtgroups, we don't need this complex code to cut the rtextents space
into fractions.  Add an rtgroup rotor and use that for rtpick, similar
to AG rotoring on the data device.  The new rotor does not persist,
which reduces the logging overhead slightly.

Link: https://lore.kernel.org/linux-xfs/CAHk-=wj3oM3d-Hw2vvxys3KCZ9De+gBN7Gxr2jf96OTisL9udw@mail.gmail.com/
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   12 ++++++++----
 fs/xfs/xfs_mount.h           |    1 +
 fs/xfs/xfs_rtalloc.c         |   11 +++++++++++
 3 files changed, 20 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 3530524b3fc2b..0ef14157e8157 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1064,10 +1064,14 @@ xfs_rtfree_extent(
 		if (!(mp->m_rbmip->i_diflags & XFS_DIFLAG_NEWRTBM))
 			mp->m_rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
 
-		atime = inode_get_atime(VFS_I(mp->m_rbmip));
-		atime.tv_sec = 0;
-		inode_set_atime_to_ts(VFS_I(mp->m_rbmip), atime);
-		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
+		if (xfs_has_rtgroups(mp)) {
+			mp->m_rtgrotor = 0;
+		} else {
+			atime = inode_get_atime(VFS_I(mp->m_rbmip));
+			atime.tv_sec = 0;
+			inode_set_atime_to_ts(VFS_I(mp->m_rbmip), atime);
+			xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
+		}
 	}
 	error = 0;
 out:
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 14094b29ab6fe..a086b96b0a513 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -224,6 +224,7 @@ typedef struct xfs_mount {
 #ifdef CONFIG_XFS_ONLINE_SCRUB_STATS
 	struct xchk_stats	*m_scrub_stats;
 #endif
+	xfs_rgnumber_t		m_rtgrotor;	/* last rtgroup rtpicked */
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
 	atomic_t		m_agirotor;	/* last ag dir inode alloced */
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ff08c1d997fdb..6479bb04657ec 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1688,6 +1688,17 @@ xfs_rtpick_extent(
 
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
+	if (xfs_has_rtgroups(mp)) {
+		xfs_rtblock_t	rtbno;
+
+		/* Pick the first usable rtx of the group. */
+		rtbno = xfs_rgbno_to_rtb(mp, mp->m_rtgrotor, 0);
+		*pick = xfs_rtb_to_rtx(mp, rtbno) + 1;
+
+		mp->m_rtgrotor = (mp->m_rtgrotor + 1) % mp->m_sb.sb_rgcount;
+		return 0;
+	}
+
 	ts = inode_get_atime(VFS_I(mp->m_rbmip));
 	if (!(mp->m_rbmip->i_diflags & XFS_DIFLAG_NEWRTBM)) {
 		mp->m_rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;


