Return-Path: <linux-xfs+bounces-1249-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F12820D57
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:10:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 235DAB20DEF
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 20:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 187DBBA30;
	Sun, 31 Dec 2023 20:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZrFYqTcQ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9807BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7315C433C8;
	Sun, 31 Dec 2023 20:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053395;
	bh=uLcmeqgkDjYRpYVKWxn8acrV+rxjmx12OSSUBLRVMVI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZrFYqTcQoObhfNp1pT2F8WOhEHqLegKQUcBOPwGncqAVzg5p7vcxgXF3nQpifUgit
	 zCQmT79yhnfF4yBgESqyc/eQJ5ziCMG2+bOQTCuyOX03Fp4PYwszeBSbf2465+8L8M
	 QzBi4vrWPAhIhZgc6ybwBgdTl2vVy7nkYfU02Yh6V73xfixl0UfFZOQ4af1c71PKiJ
	 9I6hmteNsERqt6sBCWwIxzNnx9fiAQhDTgotul1hGCj5Nchgya/aLVc4LZ77wrDlSO
	 4eleIC2OwVreMRKY1qcobZ2eKUrPoM89n6nf+IKJM4XvTdOiqMh+ZQ+FBSL2VrBA8b
	 YYdi1E6uA9qPQ==
Date: Sun, 31 Dec 2023 12:09:55 -0800
Subject: [PATCH 01/11] xfs: separate the marking of sick and checked metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404828297.1748329.1404672108438664305.stgit@frogsfrogsfrogs>
In-Reply-To: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
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

Split the setting of the sick and checked masks into separate functions
as part of preparing to add the ability for regular runtime fs code
(i.e. not scrub) to mark metadata structures sick when corruptions are
found.  Improve the documentation of libxfs' requirements for helper
behavior.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_health.h |   16 +++++++++++++-
 fs/xfs/scrub/health.c      |   20 ++++++++++-------
 fs/xfs/xfs_health.c        |   51 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_mount.c         |    5 +++-
 4 files changed, 81 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 2bfe2dc404a19..2b40fe8165702 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -111,24 +111,38 @@ struct xfs_fsop_geom;
 				 XFS_SICK_INO_DIR_ZAPPED | \
 				 XFS_SICK_INO_SYMLINK_ZAPPED)
 
-/* These functions must be provided by the xfs implementation. */
+/*
+ * These functions must be provided by the xfs implementation.  Function
+ * behavior with respect to the first argument should be as follows:
+ *
+ * xfs_*_mark_sick:    set the sick flags and do not set checked flags.
+ * xfs_*_mark_checked: set the checked flags.
+ * xfs_*_mark_healthy: clear the sick flags and set the checked flags.
+ *
+ * xfs_*_measure_sickness: return the sick and check status in the provided
+ * out parameters.
+ */
 
 void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask);
+void xfs_fs_mark_checked(struct xfs_mount *mp, unsigned int mask);
 void xfs_fs_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_fs_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_rt_mark_sick(struct xfs_mount *mp, unsigned int mask);
+void xfs_rt_mark_checked(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
+void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_measure_sickness(struct xfs_perag *pag, unsigned int *sick,
 		unsigned int *checked);
 
 void xfs_inode_mark_sick(struct xfs_inode *ip, unsigned int mask);
+void xfs_inode_mark_checked(struct xfs_inode *ip, unsigned int mask);
 void xfs_inode_mark_healthy(struct xfs_inode *ip, unsigned int mask);
 void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 		unsigned int *checked);
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 42be435227794..0f235501ed8a5 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -176,30 +176,34 @@ xchk_update_health(
 	switch (type_to_health_flag[sc->sm->sm_type].group) {
 	case XHG_AG:
 		pag = xfs_perag_get(sc->mp, sc->sm->sm_agno);
-		if (bad)
+		if (bad) {
 			xfs_ag_mark_sick(pag, sc->sick_mask);
-		else
+			xfs_ag_mark_checked(pag, sc->sick_mask);
+		} else
 			xfs_ag_mark_healthy(pag, sc->sick_mask);
 		xfs_perag_put(pag);
 		break;
 	case XHG_INO:
 		if (!sc->ip)
 			return;
-		if (bad)
+		if (bad) {
 			xfs_inode_mark_sick(sc->ip, sc->sick_mask);
-		else
+			xfs_inode_mark_checked(sc->ip, sc->sick_mask);
+		} else
 			xfs_inode_mark_healthy(sc->ip, sc->sick_mask);
 		break;
 	case XHG_FS:
-		if (bad)
+		if (bad) {
 			xfs_fs_mark_sick(sc->mp, sc->sick_mask);
-		else
+			xfs_fs_mark_checked(sc->mp, sc->sick_mask);
+		} else
 			xfs_fs_mark_healthy(sc->mp, sc->sick_mask);
 		break;
 	case XHG_RT:
-		if (bad)
+		if (bad) {
 			xfs_rt_mark_sick(sc->mp, sc->sick_mask);
-		else
+			xfs_rt_mark_checked(sc->mp, sc->sick_mask);
+		} else
 			xfs_rt_mark_healthy(sc->mp, sc->sick_mask);
 		break;
 	default:
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 111c27a6b1079..f79c332aaa076 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -98,6 +98,18 @@ xfs_fs_mark_sick(
 
 	spin_lock(&mp->m_sb_lock);
 	mp->m_fs_sick |= mask;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Mark per-fs metadata as having been checked. */
+void
+xfs_fs_mark_checked(
+	struct xfs_mount	*mp,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_FS_PRIMARY));
+
+	spin_lock(&mp->m_sb_lock);
 	mp->m_fs_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
 }
@@ -141,6 +153,19 @@ xfs_rt_mark_sick(
 
 	spin_lock(&mp->m_sb_lock);
 	mp->m_rt_sick |= mask;
+	spin_unlock(&mp->m_sb_lock);
+}
+
+/* Mark realtime metadata as having been checked. */
+void
+xfs_rt_mark_checked(
+	struct xfs_mount	*mp,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_RT_PRIMARY));
+	trace_xfs_rt_mark_sick(mp, mask);
+
+	spin_lock(&mp->m_sb_lock);
 	mp->m_rt_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
 }
@@ -184,6 +209,18 @@ xfs_ag_mark_sick(
 
 	spin_lock(&pag->pag_state_lock);
 	pag->pag_sick |= mask;
+	spin_unlock(&pag->pag_state_lock);
+}
+
+/* Mark per-ag metadata as having been checked. */
+void
+xfs_ag_mark_checked(
+	struct xfs_perag	*pag,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~XFS_SICK_AG_PRIMARY));
+
+	spin_lock(&pag->pag_state_lock);
 	pag->pag_checked |= mask;
 	spin_unlock(&pag->pag_state_lock);
 }
@@ -227,7 +264,6 @@ xfs_inode_mark_sick(
 
 	spin_lock(&ip->i_flags_lock);
 	ip->i_sick |= mask;
-	ip->i_checked |= mask;
 	spin_unlock(&ip->i_flags_lock);
 
 	/*
@@ -240,6 +276,19 @@ xfs_inode_mark_sick(
 	spin_unlock(&VFS_I(ip)->i_lock);
 }
 
+/* Mark inode metadata as having been checked. */
+void
+xfs_inode_mark_checked(
+	struct xfs_inode	*ip,
+	unsigned int		mask)
+{
+	ASSERT(!(mask & ~(XFS_SICK_INO_PRIMARY | XFS_SICK_INO_ZAPPED)));
+
+	spin_lock(&ip->i_flags_lock);
+	ip->i_checked |= mask;
+	spin_unlock(&ip->i_flags_lock);
+}
+
 /* Mark parts of an inode healed. */
 void
 xfs_inode_mark_healthy(
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index aed5be5508fe5..469eeab347518 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -497,8 +497,10 @@ xfs_check_summary_counts(
 	if (xfs_is_clean(mp) &&
 	    (mp->m_sb.sb_fdblocks > mp->m_sb.sb_dblocks ||
 	     !xfs_verify_icount(mp, mp->m_sb.sb_icount) ||
-	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount))
+	     mp->m_sb.sb_ifree > mp->m_sb.sb_icount)) {
 		xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
+		xfs_fs_mark_checked(mp, XFS_SICK_FS_COUNTERS);
+	}
 
 	/*
 	 * We can safely re-initialise incore superblock counters from the
@@ -1276,6 +1278,7 @@ xfs_force_summary_recalc(
 		return;
 
 	xfs_fs_mark_sick(mp, XFS_SICK_FS_COUNTERS);
+	xfs_fs_mark_checked(mp, XFS_SICK_FS_COUNTERS);
 }
 
 /*


