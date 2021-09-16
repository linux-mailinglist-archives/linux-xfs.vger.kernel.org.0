Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B37640CFFB
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Sep 2021 01:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhIOXLj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Sep 2021 19:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231579AbhIOXLi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:11:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8A6F610A6;
        Wed, 15 Sep 2021 23:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747419;
        bh=b5XbusnF515xsoP7rVgQuMaXTPhydaC47BpL0cjku6w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ppQyzc+UDhmgZdx/EJYgnK7B2gR4K9PM0RPh32cVsh3th0PPPRSFUFut/o6OsOOFp
         fYBsKhFgNbcFsGLu/UVMQvVcjEudGHbvyB3NjKUCghtRdwWozOLsU8+zMIugPusym9
         PwPvRduVxzeQiBkgf8fWvKZ75R+7gt2S8SvsuChr2XZ0bVHiAHq9WrN4/1pJV1EeG5
         25Xunsx7xn67KyUkCEmt8rZNZQj05qnE06l+fZnLEp0uxAbH40ClDR1QKqc4heljnE
         7nFPZfB1QWp5ucAfUsq4AwFfGZktb1A7RrySRmFpbCt1/ten6o+ynLGw1tsIrRghgu
         gKCgnReYVA75g==
Subject: [PATCH 41/61] xfs: clean up and simplify xfs_dialloc()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:10:18 -0700
Message-ID: <163174741868.350433.5638525497004266772.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 8237fbf53d6fd2a3a248fc2a8608e047ef22316c

Because it's a mess.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ialloc.c |  271 +++++++++++++++++++++++++++++----------------------
 1 file changed, 153 insertions(+), 118 deletions(-)


diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 60e09a53..a1454908 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -599,9 +599,10 @@ xfs_inobt_insert_sprec(
 }
 
 /*
- * Allocate new inodes in the allocation group specified by agbp.
- * Returns 0 if inodes were allocated in this AG; 1 if there was no space
- * in this AG; or the usual negative error code.
+ * Allocate new inodes in the allocation group specified by agbp.  Returns 0 if
+ * inodes were allocated in this AG; -EAGAIN if there was no space in this AG so
+ * the caller knows it can try another AG, a hard -ENOSPC when over the maximum
+ * inode count threshold, or the usual negative error code for other errors.
  */
 STATIC int
 xfs_ialloc_ag_alloc(
@@ -787,7 +788,7 @@ xfs_ialloc_ag_alloc(
 	}
 
 	if (args.fsbno == NULLFSBLOCK)
-		return 1;
+		return -EAGAIN;
 
 	ASSERT(args.len == args.minlen);
 
@@ -1563,14 +1564,17 @@ xfs_dialloc_roll(
 	/* Re-attach the quota info that we detached from prev trx. */
 	tp->t_dqinfo = dqinfo;
 
-	*tpp = tp;
-	if (error)
-		return error;
+	/*
+	 * Join the buffer even on commit error so that the buffer is released
+	 * when the caller cancels the transaction and doesn't have to handle
+	 * this error case specially.
+	 */
 	xfs_trans_bjoin(tp, agibp);
-	return 0;
+	*tpp = tp;
+	return error;
 }
 
-STATIC xfs_agnumber_t
+static xfs_agnumber_t
 xfs_ialloc_next_ag(
 	xfs_mount_t	*mp)
 {
@@ -1585,16 +1589,136 @@ xfs_ialloc_next_ag(
 	return agno;
 }
 
+static bool
+xfs_dialloc_good_ag(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	umode_t			mode,
+	int			flags,
+	bool			ok_alloc)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_extlen_t		ineed;
+	xfs_extlen_t		longest = 0;
+	int			needspace;
+	int			error;
+
+	if (!pag->pagi_inodeok)
+		return false;
+
+	if (!pag->pagi_init) {
+		error = xfs_ialloc_pagi_init(mp, tp, pag->pag_agno);
+		if (error)
+			return false;
+	}
+
+	if (pag->pagi_freecount)
+		return true;
+	if (!ok_alloc)
+		return false;
+
+	if (!pag->pagf_init) {
+		error = xfs_alloc_pagf_init(mp, tp, pag->pag_agno, flags);
+		if (error)
+			return false;
+	}
+
+	/*
+	 * Check that there is enough free space for the file plus a chunk of
+	 * inodes if we need to allocate some. If this is the first pass across
+	 * the AGs, take into account the potential space needed for alignment
+	 * of inode chunks when checking the longest contiguous free space in
+	 * the AG - this prevents us from getting ENOSPC because we have free
+	 * space larger than ialloc_blks but alignment constraints prevent us
+	 * from using it.
+	 *
+	 * If we can't find an AG with space for full alignment slack to be
+	 * taken into account, we must be near ENOSPC in all AGs.  Hence we
+	 * don't include alignment for the second pass and so if we fail
+	 * allocation due to alignment issues then it is most likely a real
+	 * ENOSPC condition.
+	 *
+	 * XXX(dgc): this calculation is now bogus thanks to the per-ag
+	 * reservations that xfs_alloc_fix_freelist() now does via
+	 * xfs_alloc_space_available(). When the AG fills up, pagf_freeblks will
+	 * be more than large enough for the check below to succeed, but
+	 * xfs_alloc_space_available() will fail because of the non-zero
+	 * metadata reservation and hence we won't actually be able to allocate
+	 * more inodes in this AG. We do soooo much unnecessary work near ENOSPC
+	 * because of this.
+	 */
+	ineed = M_IGEO(mp)->ialloc_min_blks;
+	if (flags && ineed > 1)
+		ineed += M_IGEO(mp)->cluster_align;
+	longest = pag->pagf_longest;
+	if (!longest)
+		longest = pag->pagf_flcount > 0;
+	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
+
+	if (pag->pagf_freeblks < needspace + ineed || longest < ineed)
+		return false;
+	return true;
+}
+
+static int
+xfs_dialloc_try_ag(
+	struct xfs_trans	**tpp,
+	struct xfs_perag	*pag,
+	xfs_ino_t		parent,
+	xfs_ino_t		*new_ino,
+	bool			ok_alloc)
+{
+	struct xfs_buf		*agbp;
+	xfs_ino_t		ino;
+	int			error;
+
+	/*
+	 * Then read in the AGI buffer and recheck with the AGI buffer
+	 * lock held.
+	 */
+	error = xfs_ialloc_read_agi(pag->pag_mount, *tpp, pag->pag_agno, &agbp);
+	if (error)
+		return error;
+
+	if (!pag->pagi_freecount) {
+		if (!ok_alloc) {
+			error = -EAGAIN;
+			goto out_release;
+		}
+
+		error = xfs_ialloc_ag_alloc(*tpp, agbp, pag);
+		if (error < 0)
+			goto out_release;
+
+		/*
+		 * We successfully allocated space for an inode cluster in this
+		 * AG.  Roll the transaction so that we can allocate one of the
+		 * new inodes.
+		 */
+		ASSERT(pag->pagi_freecount > 0);
+		error = xfs_dialloc_roll(tpp, agbp);
+		if (error)
+			goto out_release;
+	}
+
+	/* Allocate an inode in the found AG */
+	error = xfs_dialloc_ag(*tpp, agbp, pag, parent, &ino);
+	if (!error)
+		*new_ino = ino;
+	return error;
+
+out_release:
+	xfs_trans_brelse(*tpp, agbp);
+	return error;
+}
+
 /*
- * Select and prepare an AG for inode allocation.
+ * Allocate an on-disk inode.
  *
  * Mode is used to tell whether the new inode is a directory and hence where to
- * locate it.
- *
- * This function will ensure that the selected AG has free inodes available to
- * allocate from. The selected AGI will be returned locked to the caller, and it
- * will allocate more free inodes if required. If no free inodes are found or
- * can be allocated, -ENOSPC be returned.
+ * locate it. The on-disk inode that is allocated will be returned in @new_ino
+ * on success, otherwise an error will be set to indicate the failure (e.g.
+ * -ENOSPC).
  */
 int
 xfs_dialloc(
@@ -1604,14 +1728,12 @@ xfs_dialloc(
 	xfs_ino_t		*new_ino)
 {
 	struct xfs_mount	*mp = (*tpp)->t_mountp;
-	struct xfs_buf		*agbp;
 	xfs_agnumber_t		agno;
 	int			error = 0;
 	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
-	bool			okalloc = true;
-	int			needspace;
+	bool			ok_alloc = true;
 	int			flags;
 	xfs_ino_t		ino;
 
@@ -1620,7 +1742,6 @@ xfs_dialloc(
 	 * one block, so factor that potential expansion when we examine whether
 	 * an AG has enough space for file creation.
 	 */
-	needspace = S_ISDIR(mode) || S_ISREG(mode) || S_ISLNK(mode);
 	if (S_ISDIR(mode))
 		start_agno = xfs_ialloc_next_ag(mp);
 	else {
@@ -1631,7 +1752,7 @@ xfs_dialloc(
 
 	/*
 	 * If we have already hit the ceiling of inode blocks then clear
-	 * okalloc so we scan all available agi structures for a free
+	 * ok_alloc so we scan all available agi structures for a free
 	 * inode.
 	 *
 	 * Read rough value of mp->m_icount by percpu_counter_read_positive,
@@ -1640,7 +1761,7 @@ xfs_dialloc(
 	if (igeo->maxicount &&
 	    percpu_counter_read_positive(&mp->m_icount) + igeo->ialloc_inos
 							> igeo->maxicount) {
-		okalloc = false;
+		ok_alloc = false;
 	}
 
 	/*
@@ -1651,96 +1772,14 @@ xfs_dialloc(
 	agno = start_agno;
 	flags = XFS_ALLOC_FLAG_TRYLOCK;
 	for (;;) {
-		xfs_extlen_t	ineed;
-		xfs_extlen_t	longest = 0;
-
 		pag = xfs_perag_get(mp, agno);
-		if (!pag->pagi_inodeok)
-			goto nextag;
-
-		if (!pag->pagi_init) {
-			error = xfs_ialloc_pagi_init(mp, *tpp, agno);
-			if (error)
-				break;
-		}
-
-		if (!pag->pagi_freecount && !okalloc)
-			goto nextag;
-
-		if (!pag->pagf_init) {
-			error = xfs_alloc_pagf_init(mp, *tpp, agno, flags);
-			if (error)
-				goto nextag;
-		}
-
-		/*
-		 * Check that there is enough free space for the file plus a
-		 * chunk of inodes if we need to allocate some. If this is the
-		 * first pass across the AGs, take into account the potential
-		 * space needed for alignment of inode chunks when checking the
-		 * longest contiguous free space in the AG - this prevents us
-		 * from getting ENOSPC because we have free space larger than
-		 * ialloc_blks but alignment constraints prevent us from using
-		 * it.
-		 *
-		 * If we can't find an AG with space for full alignment slack to
-		 * be taken into account, we must be near ENOSPC in all AGs.
-		 * Hence we don't include alignment for the second pass and so
-		 * if we fail allocation due to alignment issues then it is most
-		 * likely a real ENOSPC condition.
-		 */
-		if (!pag->pagi_freecount) {
-			ineed = M_IGEO(mp)->ialloc_min_blks;
-			if (flags && ineed > 1)
-				ineed += M_IGEO(mp)->cluster_align;
-			longest = pag->pagf_longest;
-			if (!longest)
-				longest = pag->pagf_flcount > 0;
-
-			if (pag->pagf_freeblks < needspace + ineed ||
-			    longest < ineed)
-				goto nextag;
-		}
-
-		/*
-		 * Then read in the AGI buffer and recheck with the AGI buffer
-		 * lock held.
-		 */
-		error = xfs_ialloc_read_agi(mp, *tpp, agno, &agbp);
-		if (error)
-			break;
-
-		if (pag->pagi_freecount)
-			goto found_ag;
-
-		if (!okalloc)
-			goto nextag_relse_buffer;
-
-		error = xfs_ialloc_ag_alloc(*tpp, agbp, pag);
-		if (error < 0) {
-			xfs_trans_brelse(*tpp, agbp);
-			break;
-		}
-
-		if (error == 0) {
-			/*
-			 * We successfully allocated space for an inode cluster
-			 * in this AG.  Roll the transaction so that we can
-			 * allocate one of the new inodes.
-			 */
-			ASSERT(pag->pagi_freecount > 0);
-
-			error = xfs_dialloc_roll(tpp, agbp);
-			if (error) {
-				xfs_buf_relse(agbp);
+		if (xfs_dialloc_good_ag(*tpp, pag, mode, flags, ok_alloc)) {
+			error = xfs_dialloc_try_ag(tpp, pag, parent,
+					&ino, ok_alloc);
+			if (error != -EAGAIN)
 				break;
-			}
-			goto found_ag;
 		}
 
-nextag_relse_buffer:
-		xfs_trans_brelse(*tpp, agbp);
-nextag:
 		if (XFS_FORCED_SHUTDOWN(mp)) {
 			error = -EFSCORRUPTED;
 			break;
@@ -1748,23 +1787,19 @@ xfs_dialloc(
 		if (++agno == mp->m_maxagi)
 			agno = 0;
 		if (agno == start_agno) {
-			if (!flags)
+			if (!flags) {
+				error = -ENOSPC;
 				break;
+			}
 			flags = 0;
 		}
 		xfs_perag_put(pag);
 	}
 
+	if (!error)
+		*new_ino = ino;
 	xfs_perag_put(pag);
-	return error ? error : -ENOSPC;
-found_ag:
-	/* Allocate an inode in the found AG */
-	error = xfs_dialloc_ag(*tpp, agbp, pag, parent, &ino);
-	xfs_perag_put(pag);
-	if (error)
-		return error;
-	*new_ino = ino;
-	return 0;
+	return error;
 }
 
 /*

