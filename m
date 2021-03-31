Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF3D349DAE
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Mar 2021 01:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhCZAWN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Mar 2021 20:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230013AbhCZAVr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE9CD619F3;
        Fri, 26 Mar 2021 00:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718106;
        bh=TtIV9zfltyjI46cZ9DXdSU5VY5/ylTT8elRgQUKG2wM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=j1xVZfo2sgh4EUNn4ADpLWFoF0JZRu20eZ2bw1aqzZ59JpwRkZbSxzZNGKTmZ7fc0
         zFDz9XwTaJno5Tv2p2Jn7wcU5sATb+aMjbzfvNWmClcnBn6/6e1DK7a0rLCsSe6rgO
         FSwXayL2r2gNZEvj8UqWpz019mVMl0QlD+bu2Pc6C4Xa3mkiFnpH1AYhkeZaZiL/Mp
         5/efR21UAzTgKYaptPt/Bb+OlGhtDtnJWiBqCpY8CQ9PMwk2clRQsdacYY7mNb9iuz
         gU4YO74ECwnzf00RsOIvqciU/D6eCLWxADXPSsEEB4l1opAVRf/COCTSuuo71nlhb9
         qoCTheai+MLPg==
Subject: [PATCH 6/6] xfs: refactor per-AG inode tagging functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:21:46 -0700
Message-ID: <161671810634.621936.14531357513724748267.stgit@magnolia>
In-Reply-To: <161671807287.621936.13471099564526590235.stgit@magnolia>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In preparation for adding another incore inode tree tag, refactor the
code that sets and clears tags from the per-AG inode tree and the tree
of per-AG structures, and remove the open-coded versions used by the
blockgc code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |  127 ++++++++++++++++++++++++---------------------------
 fs/xfs/xfs_icache.h |    2 -
 fs/xfs/xfs_super.c  |    2 -
 fs/xfs/xfs_trace.h  |    6 +-
 4 files changed, 65 insertions(+), 72 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 2b25fe679b0e..4c124bc98f39 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -29,6 +29,7 @@
 /* Forward declarations to reduce indirect calls */
 static int xfs_blockgc_scan_inode(struct xfs_inode *ip,
 		struct xfs_eofblocks *eofb);
+static inline void xfs_blockgc_queue(struct xfs_perag *pag);
 static bool xfs_reclaim_inode_grab(struct xfs_inode *ip);
 static void xfs_reclaim_inode(struct xfs_inode *ip, struct xfs_perag *pag);
 
@@ -163,46 +164,78 @@ xfs_reclaim_work_queue(
 	rcu_read_unlock();
 }
 
+/* Set a tag on both the AG incore inode tree and the AG radix tree. */
 static void
-xfs_perag_set_reclaim_tag(
-	struct xfs_perag	*pag)
+xfs_perag_set_ici_tag(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino,
+	unsigned int		tag)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
+	bool			was_tagged;
 
 	lockdep_assert_held(&pag->pag_ici_lock);
-	if (pag->pag_ici_reclaimable++)
+
+	was_tagged = radix_tree_tagged(&pag->pag_ici_root, tag);
+	radix_tree_tag_set(&pag->pag_ici_root, agino, tag);
+
+	if (tag == XFS_ICI_RECLAIM_TAG)
+		pag->pag_ici_reclaimable++;
+
+	if (was_tagged)
 		return;
 
-	/* propagate the reclaim tag up into the perag radix tree */
+	/* propagate the tag up into the perag radix tree */
 	spin_lock(&mp->m_perag_lock);
-	radix_tree_tag_set(&mp->m_perag_tree, pag->pag_agno,
-			   XFS_ICI_RECLAIM_TAG);
+	radix_tree_tag_set(&mp->m_perag_tree, pag->pag_agno, tag);
 	spin_unlock(&mp->m_perag_lock);
 
-	/* schedule periodic background inode reclaim */
-	xfs_reclaim_work_queue(mp);
+	/* start background work */
+	switch (tag) {
+	case XFS_ICI_RECLAIM_TAG:
+		xfs_reclaim_work_queue(mp);
+		break;
+	case XFS_ICI_BLOCKGC_TAG:
+		xfs_blockgc_queue(pag);
+		break;
+	}
 
-	trace_xfs_perag_set_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
+	trace_xfs_perag_set_ici_tag(mp, pag->pag_agno, tag, _RET_IP_);
 }
 
+/* Clear a tag on both the AG incore inode tree and the AG radix tree. */
 static void
-xfs_perag_clear_reclaim_tag(
-	struct xfs_perag	*pag)
+xfs_perag_clear_ici_tag(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino,
+	unsigned int		tag)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
 	lockdep_assert_held(&pag->pag_ici_lock);
-	if (--pag->pag_ici_reclaimable)
+
+	/*
+	 * Reclaim can signal (with a null agino) that it cleared its own tag
+	 * by removing the inode from the radix tree.
+	 */
+	if (agino != NULLAGINO)
+		radix_tree_tag_clear(&pag->pag_ici_root, agino, tag);
+	else
+		ASSERT(tag == XFS_ICI_RECLAIM_TAG);
+
+	if (tag == XFS_ICI_RECLAIM_TAG)
+		pag->pag_ici_reclaimable--;
+
+	if (radix_tree_tagged(&pag->pag_ici_root, tag))
 		return;
 
-	/* clear the reclaim tag from the perag radix tree */
+	/* clear the tag from the perag radix tree */
 	spin_lock(&mp->m_perag_lock);
-	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno,
-			     XFS_ICI_RECLAIM_TAG);
+	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno, tag);
 	spin_unlock(&mp->m_perag_lock);
-	trace_xfs_perag_clear_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
-}
 
+	trace_xfs_perag_clear_ici_tag(mp, pag->pag_agno, tag, _RET_IP_);
+}
 
 /*
  * We set the inode flag atomically with the radix tree tag.
@@ -210,7 +243,7 @@ xfs_perag_clear_reclaim_tag(
  * can go away.
  */
 void
-xfs_inode_set_reclaim_tag(
+xfs_inode_destroy(
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -220,9 +253,8 @@ xfs_inode_set_reclaim_tag(
 	spin_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 
-	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			   XFS_ICI_RECLAIM_TAG);
-	xfs_perag_set_reclaim_tag(pag);
+	xfs_perag_set_ici_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
+			XFS_ICI_RECLAIM_TAG);
 	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
 
 	spin_unlock(&ip->i_flags_lock);
@@ -230,17 +262,6 @@ xfs_inode_set_reclaim_tag(
 	xfs_perag_put(pag);
 }
 
-STATIC void
-xfs_inode_clear_reclaim_tag(
-	struct xfs_perag	*pag,
-	xfs_ino_t		ino)
-{
-	radix_tree_tag_clear(&pag->pag_ici_root,
-			     XFS_INO_TO_AGINO(pag->pag_mount, ino),
-			     XFS_ICI_RECLAIM_TAG);
-	xfs_perag_clear_reclaim_tag(pag);
-}
-
 void
 xfs_inew_wait(
 	struct xfs_inode	*ip)
@@ -439,7 +460,9 @@ xfs_iget_cache_hit(
 		 */
 		ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
 		ip->i_flags |= XFS_INEW;
-		xfs_inode_clear_reclaim_tag(pag, ip->i_ino);
+		xfs_perag_clear_ici_tag(pag,
+				XFS_INO_TO_AGINO(pag->pag_mount, ino),
+				XFS_ICI_RECLAIM_TAG);
 		inode->i_state = I_NEW;
 		ip->i_sick = 0;
 		ip->i_checked = 0;
@@ -1038,7 +1061,7 @@ xfs_reclaim_inode(
 	if (!radix_tree_delete(&pag->pag_ici_root,
 				XFS_INO_TO_AGINO(ip->i_mount, ino)))
 		ASSERT(0);
-	xfs_perag_clear_reclaim_tag(pag);
+	xfs_perag_clear_ici_tag(pag, NULLAGINO, XFS_ICI_RECLAIM_TAG);
 	spin_unlock(&pag->pag_ici_lock);
 
 	/*
@@ -1274,7 +1297,6 @@ xfs_blockgc_set_iflag(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
-	int			tagged;
 
 	ASSERT((iflag & ~(XFS_IEOFBLOCKS | XFS_ICOWBLOCKS)) == 0);
 
@@ -1291,24 +1313,8 @@ xfs_blockgc_set_iflag(
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 
-	tagged = radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG);
-	radix_tree_tag_set(&pag->pag_ici_root,
-			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
-			   XFS_ICI_BLOCKGC_TAG);
-	if (!tagged) {
-		/* propagate the blockgc tag up into the perag radix tree */
-		spin_lock(&ip->i_mount->m_perag_lock);
-		radix_tree_tag_set(&ip->i_mount->m_perag_tree,
-				   XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				   XFS_ICI_BLOCKGC_TAG);
-		spin_unlock(&ip->i_mount->m_perag_lock);
-
-		/* kick off background trimming */
-		xfs_blockgc_queue(pag);
-
-		trace_xfs_perag_set_blockgc(ip->i_mount, pag->pag_agno, -1,
-				_RET_IP_);
-	}
+	xfs_perag_set_ici_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
+			XFS_ICI_BLOCKGC_TAG);
 
 	spin_unlock(&pag->pag_ici_lock);
 	xfs_perag_put(pag);
@@ -1344,19 +1350,8 @@ xfs_blockgc_clear_iflag(
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
 
-	radix_tree_tag_clear(&pag->pag_ici_root,
-			     XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
-			     XFS_ICI_BLOCKGC_TAG);
-	if (!radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG)) {
-		/* clear the blockgc tag from the perag radix tree */
-		spin_lock(&ip->i_mount->m_perag_lock);
-		radix_tree_tag_clear(&ip->i_mount->m_perag_tree,
-				     XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				     XFS_ICI_BLOCKGC_TAG);
-		spin_unlock(&ip->i_mount->m_perag_lock);
-		trace_xfs_perag_clear_blockgc(ip->i_mount, pag->pag_agno, -1,
-				_RET_IP_);
-	}
+	xfs_perag_clear_ici_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
+			XFS_ICI_BLOCKGC_TAG);
 
 	spin_unlock(&pag->pag_ici_lock);
 	xfs_perag_put(pag);
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index bde7bab84230..987267797fc4 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -48,7 +48,7 @@ void xfs_reclaim_inodes(struct xfs_mount *mp);
 int xfs_reclaim_inodes_count(struct xfs_mount *mp);
 long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
-void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
+void xfs_inode_destroy(struct xfs_inode *ip);
 
 int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a2dab05332ac..f5bbfd13a956 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -667,7 +667,7 @@ xfs_fs_destroy_inode(
 	 * reclaim path handles this more efficiently than we can here, so
 	 * simply let background reclaim tear down all inodes.
 	 */
-	xfs_inode_set_reclaim_tag(ip);
+	xfs_inode_destroy(ip);
 }
 
 static void
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 808ae337b222..a929ebef89ec 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -153,10 +153,8 @@ DEFINE_EVENT(xfs_perag_class, name,	\
 DEFINE_PERAG_REF_EVENT(xfs_perag_get);
 DEFINE_PERAG_REF_EVENT(xfs_perag_get_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_put);
-DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim);
-DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
-DEFINE_PERAG_REF_EVENT(xfs_perag_set_blockgc);
-DEFINE_PERAG_REF_EVENT(xfs_perag_clear_blockgc);
+DEFINE_PERAG_REF_EVENT(xfs_perag_set_ici_tag);
+DEFINE_PERAG_REF_EVENT(xfs_perag_clear_ici_tag);
 
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),

