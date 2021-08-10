Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4615F3E0C43
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Aug 2021 04:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238128AbhHECGx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Aug 2021 22:06:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238126AbhHECGx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 22:06:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2C9C6105A;
        Thu,  5 Aug 2021 02:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628129199;
        bh=lbMM39HqcVF3LwMDAxD4zYbAgwErU5qsXFmUfYTrO3s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k9g36ljs3yIsmDs4mMCCyKgYWRUJx+rg59KKT+D1GAemorxD3SXU1VdwLKYtYqL2t
         lVFFtizKOwPpthO97NxG6DzbAlhuQQfU8L4J6NVN1tJZxBlMLpoC05XzpdzIzlI/vZ
         PMMK68eSZ3Ct45BAGbzNov2r4CmnU38q5tbYhGwbjc47pF1D00iy9IqmWX/YP7/yu1
         25WsnCY/1YLYr5lK2SpE88v0PG/84I/aMsmhnjZ+tIKPomfsqfst/uVHtzC44Qn/7R
         Athg2BNPT63+QYYFcFOzKQjLdNLNgKoTshfmRfVWTry7oUM/25AuyUPiCwC2tApFP/
         8+SSdWFRrh9Yg==
Subject: [PATCH 03/14] xfs: move xfs_inactive call to
 xfs_inode_mark_reclaimable
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 04 Aug 2021 19:06:39 -0700
Message-ID: <162812919945.2589546.4625391576029057535.stgit@magnolia>
In-Reply-To: <162812918259.2589546.16599271324044986858.stgit@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the xfs_inactive call and all the other debugging checks and stats
updates into xfs_inode_mark_reclaimable because most of that are
implementation details about the inode cache.  This is preparation for
deferred inactivation that is coming up.  We also move it around
xfs_icache.c in preparation for deferred inactivation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   99 ++++++++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_super.c  |   50 --------------------------
 2 files changed, 74 insertions(+), 75 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 086a88b8dfdb..f0e77ed0b8bb 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -292,31 +292,6 @@ xfs_perag_clear_inode_tag(
 	trace_xfs_perag_clear_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
 }
 
-/*
- * We set the inode flag atomically with the radix tree tag.
- * Once we get tag lookups on the radix tree, this inode flag
- * can go away.
- */
-void
-xfs_inode_mark_reclaimable(
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_perag	*pag;
-
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-	spin_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
-
-	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			XFS_ICI_RECLAIM_TAG);
-	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
-
-	spin_unlock(&ip->i_flags_lock);
-	spin_unlock(&pag->pag_ici_lock);
-	xfs_perag_put(pag);
-}
-
 static inline void
 xfs_inew_wait(
 	struct xfs_inode	*ip)
@@ -1739,3 +1714,77 @@ xfs_icwalk(
 	return last_error;
 	BUILD_BUG_ON(XFS_ICWALK_PRIVATE_FLAGS & XFS_ICWALK_FLAGS_VALID);
 }
+
+#ifdef DEBUG
+static void
+xfs_check_delalloc(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_bmbt_irec	got;
+	struct xfs_iext_cursor	icur;
+
+	if (!ifp || !xfs_iext_lookup_extent(ip, ifp, 0, &icur, &got))
+		return;
+	do {
+		if (isnullstartblock(got.br_startblock)) {
+			xfs_warn(ip->i_mount,
+	"ino %llx %s fork has delalloc extent at [0x%llx:0x%llx]",
+				ip->i_ino,
+				whichfork == XFS_DATA_FORK ? "data" : "cow",
+				got.br_startoff, got.br_blockcount);
+		}
+	} while (xfs_iext_next_extent(ifp, &icur, &got));
+}
+#else
+#define xfs_check_delalloc(ip, whichfork)	do { } while (0)
+#endif
+
+/*
+ * We set the inode flag atomically with the radix tree tag.
+ * Once we get tag lookups on the radix tree, this inode flag
+ * can go away.
+ */
+void
+xfs_inode_mark_reclaimable(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+
+	xfs_inactive(ip);
+
+	if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
+		xfs_check_delalloc(ip, XFS_DATA_FORK);
+		xfs_check_delalloc(ip, XFS_COW_FORK);
+		ASSERT(0);
+	}
+
+	XFS_STATS_INC(mp, vn_reclaim);
+
+	/*
+	 * We should never get here with one of the reclaim flags already set.
+	 */
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
+
+	/*
+	 * We always use background reclaim here because even if the inode is
+	 * clean, it still may be under IO and hence we have wait for IO
+	 * completion to occur before we can reclaim the inode. The background
+	 * reclaim path handles this more efficiently than we can here, so
+	 * simply let background reclaim tear down all inodes.
+	 */
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	spin_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+
+	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
+			XFS_ICI_RECLAIM_TAG);
+	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
+
+	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&pag->pag_ici_lock);
+	xfs_perag_put(pag);
+}
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c2c9c02b9d62..e0b97e4c8e16 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -613,32 +613,6 @@ xfs_fs_alloc_inode(
 	return NULL;
 }
 
-#ifdef DEBUG
-static void
-xfs_check_delalloc(
-	struct xfs_inode	*ip,
-	int			whichfork)
-{
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
-	struct xfs_bmbt_irec	got;
-	struct xfs_iext_cursor	icur;
-
-	if (!ifp || !xfs_iext_lookup_extent(ip, ifp, 0, &icur, &got))
-		return;
-	do {
-		if (isnullstartblock(got.br_startblock)) {
-			xfs_warn(ip->i_mount,
-	"ino %llx %s fork has delalloc extent at [0x%llx:0x%llx]",
-				ip->i_ino,
-				whichfork == XFS_DATA_FORK ? "data" : "cow",
-				got.br_startoff, got.br_blockcount);
-		}
-	} while (xfs_iext_next_extent(ifp, &icur, &got));
-}
-#else
-#define xfs_check_delalloc(ip, whichfork)	do { } while (0)
-#endif
-
 /*
  * Now that the generic code is guaranteed not to be accessing
  * the linux inode, we can inactivate and reclaim the inode.
@@ -654,30 +628,6 @@ xfs_fs_destroy_inode(
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	XFS_STATS_INC(ip->i_mount, vn_rele);
 	XFS_STATS_INC(ip->i_mount, vn_remove);
-
-	xfs_inactive(ip);
-
-	if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
-		xfs_check_delalloc(ip, XFS_DATA_FORK);
-		xfs_check_delalloc(ip, XFS_COW_FORK);
-		ASSERT(0);
-	}
-
-	XFS_STATS_INC(ip->i_mount, vn_reclaim);
-
-	/*
-	 * We should never get here with one of the reclaim flags already set.
-	 */
-	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
-	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
-
-	/*
-	 * We always use background reclaim here because even if the inode is
-	 * clean, it still may be under IO and hence we have wait for IO
-	 * completion to occur before we can reclaim the inode. The background
-	 * reclaim path handles this more efficiently than we can here, so
-	 * simply let background reclaim tear down all inodes.
-	 */
 	xfs_inode_mark_reclaimable(ip);
 }
 

