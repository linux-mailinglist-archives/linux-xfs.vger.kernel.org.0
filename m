Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE433995E3
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Jun 2021 00:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbhFBW05 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 2 Jun 2021 18:26:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFBW05 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:26:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9C766138C;
        Wed,  2 Jun 2021 22:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672714;
        bh=dWI4MhfzZ5sofkcby10aIDrma64E7V4PndDpBhsWfcQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=H2cb6yqI+ZShmGl3bEH0v89ruXc2wKSJx/WL27xz0fn+ehN3dl6K16eJ84ek88hZe
         PJQQsUysG37KVLBz2pmMepbs0zfoS5Mce5R4znE45xpmJgNmifGU/tPcnIzf72B7z2
         GszNtkSITSEoOvcHmO5fW+FyfAwfYQbUxoByLWxw7JLNlpFOeVWnzaOzySWAx7Ks99
         ef0aSVrksN9ohST7DaEIDJz4emBL378MrB+ei1rfkhJNJQYusPPMk7aH5J8FZevNJI
         ZQ2mWYdYbmll2t6/Ft5cctSTxSCUE+foeP01r6wLm6qEds5JndDEyWlHPiLqaxWmRy
         ONTDQhJiwie3g==
Subject: [PATCH 03/15] xfs: move the inode walk functions further down
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Date:   Wed, 02 Jun 2021 15:25:13 -0700
Message-ID: <162267271362.2375284.6369986652230578143.stgit@locust>
In-Reply-To: <162267269663.2375284.15885514656776142361.stgit@locust>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the inode walk functions further down in the file to limit the
forward declarations to the two walk functions as we add new code that
uses the inode walks.  We'll clean them out later (i.e. after the
deferred inode inactivation series).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c |  401 ++++++++++++++++++++++++++-------------------------
 1 file changed, 206 insertions(+), 195 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index dfa0ec7d02b8..55c55e449cab 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -26,6 +26,13 @@
 
 #include <linux/iversion.h>
 
+static int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
+		int (*execute)(struct xfs_inode *ip, void *args),
+		void *args, int tag);
+static int xfs_inode_walk_ag(struct xfs_perag *pag, int iter_flags,
+		int (*execute)(struct xfs_inode *ip, void *args),
+		void *args, int tag);
+
 /*
  * Private inode cache walk flags for struct xfs_eofblocks.  Must not coincide
  * with XFS_EOF_FLAGS_*.
@@ -732,204 +739,12 @@ xfs_icache_inode_is_allocated(
  * radix tree lookups to a minimum. The batch size is a trade off between
  * lookup reduction and stack usage. This is in the reclaim path, so we can't
  * be too greedy.
+ *
+ * XXX: This will be moved closer to xfs_inode_walk* once we get rid of the
+ * separate reclaim walk functions.
  */
 #define XFS_LOOKUP_BATCH	32
 
-/*
- * Decide if the given @ip is eligible to be a part of the inode walk, and
- * grab it if so.  Returns true if it's ready to go or false if we should just
- * ignore it.
- */
-STATIC bool
-xfs_inode_walk_ag_grab(
-	struct xfs_inode	*ip,
-	int			flags)
-{
-	struct inode		*inode = VFS_I(ip);
-	bool			newinos = !!(flags & XFS_INODE_WALK_INEW_WAIT);
-
-	ASSERT(rcu_read_lock_held());
-
-	/* Check for stale RCU freed inode */
-	spin_lock(&ip->i_flags_lock);
-	if (!ip->i_ino)
-		goto out_unlock_noent;
-
-	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
-	if ((!newinos && __xfs_iflags_test(ip, XFS_INEW)) ||
-	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
-		goto out_unlock_noent;
-	spin_unlock(&ip->i_flags_lock);
-
-	/* nothing to sync during shutdown */
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return false;
-
-	/* If we can't grab the inode, it must on it's way to reclaim. */
-	if (!igrab(inode))
-		return false;
-
-	/* inode is valid */
-	return true;
-
-out_unlock_noent:
-	spin_unlock(&ip->i_flags_lock);
-	return false;
-}
-
-/*
- * For a given per-AG structure @pag, grab, @execute, and rele all incore
- * inodes with the given radix tree @tag.
- */
-STATIC int
-xfs_inode_walk_ag(
-	struct xfs_perag	*pag,
-	int			iter_flags,
-	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	int			tag)
-{
-	struct xfs_mount	*mp = pag->pag_mount;
-	uint32_t		first_index;
-	int			last_error = 0;
-	int			skipped;
-	bool			done;
-	int			nr_found;
-
-restart:
-	done = false;
-	skipped = 0;
-	first_index = 0;
-	nr_found = 0;
-	do {
-		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
-		int		error = 0;
-		int		i;
-
-		rcu_read_lock();
-
-		if (tag == XFS_ICI_NO_TAG)
-			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
-					(void **)batch, first_index,
-					XFS_LOOKUP_BATCH);
-		else
-			nr_found = radix_tree_gang_lookup_tag(
-					&pag->pag_ici_root,
-					(void **) batch, first_index,
-					XFS_LOOKUP_BATCH, tag);
-
-		if (!nr_found) {
-			rcu_read_unlock();
-			break;
-		}
-
-		/*
-		 * Grab the inodes before we drop the lock. if we found
-		 * nothing, nr == 0 and the loop will be skipped.
-		 */
-		for (i = 0; i < nr_found; i++) {
-			struct xfs_inode *ip = batch[i];
-
-			if (done || !xfs_inode_walk_ag_grab(ip, iter_flags))
-				batch[i] = NULL;
-
-			/*
-			 * Update the index for the next lookup. Catch
-			 * overflows into the next AG range which can occur if
-			 * we have inodes in the last block of the AG and we
-			 * are currently pointing to the last inode.
-			 *
-			 * Because we may see inodes that are from the wrong AG
-			 * due to RCU freeing and reallocation, only update the
-			 * index if it lies in this AG. It was a race that lead
-			 * us to see this inode, so another lookup from the
-			 * same index will not find it again.
-			 */
-			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
-				continue;
-			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
-				done = true;
-		}
-
-		/* unlock now we've grabbed the inodes. */
-		rcu_read_unlock();
-
-		for (i = 0; i < nr_found; i++) {
-			if (!batch[i])
-				continue;
-			if ((iter_flags & XFS_INODE_WALK_INEW_WAIT) &&
-			    xfs_iflags_test(batch[i], XFS_INEW))
-				xfs_inew_wait(batch[i]);
-			error = execute(batch[i], args);
-			xfs_irele(batch[i]);
-			if (error == -EAGAIN) {
-				skipped++;
-				continue;
-			}
-			if (error && last_error != -EFSCORRUPTED)
-				last_error = error;
-		}
-
-		/* bail out if the filesystem is corrupted.  */
-		if (error == -EFSCORRUPTED)
-			break;
-
-		cond_resched();
-
-	} while (nr_found && !done);
-
-	if (skipped) {
-		delay(1);
-		goto restart;
-	}
-	return last_error;
-}
-
-/* Fetch the next (possibly tagged) per-AG structure. */
-static inline struct xfs_perag *
-xfs_inode_walk_get_perag(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	int			tag)
-{
-	if (tag == XFS_ICI_NO_TAG)
-		return xfs_perag_get(mp, agno);
-	return xfs_perag_get_tag(mp, agno, tag);
-}
-
-/*
- * Call the @execute function on all incore inodes matching the radix tree
- * @tag.
- */
-static int
-xfs_inode_walk(
-	struct xfs_mount	*mp,
-	int			iter_flags,
-	int			(*execute)(struct xfs_inode *ip, void *args),
-	void			*args,
-	int			tag)
-{
-	struct xfs_perag	*pag;
-	int			error = 0;
-	int			last_error = 0;
-	xfs_agnumber_t		ag;
-
-	ag = 0;
-	while ((pag = xfs_inode_walk_get_perag(mp, ag, tag))) {
-		ag = pag->pag_agno + 1;
-		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, tag);
-		xfs_perag_put(pag);
-		if (error) {
-			last_error = error;
-			if (error == -EFSCORRUPTED)
-				break;
-		}
-	}
-	return last_error;
-	BUILD_BUG_ON(XFS_ICWALK_PRIVATE_FLAGS & XFS_EOF_FLAGS_VALID);
-}
-
 #ifdef CONFIG_XFS_QUOTA
 /* Drop this inode's dquots. */
 static int
@@ -1649,6 +1464,48 @@ xfs_blockgc_start(
 		xfs_blockgc_queue(pag);
 }
 
+/*
+ * Decide if the given @ip is eligible to be a part of the inode walk, and
+ * grab it if so.  Returns true if it's ready to go or false if we should just
+ * ignore it.
+ */
+static bool
+xfs_inode_walk_ag_grab(
+	struct xfs_inode	*ip,
+	int			flags)
+{
+	struct inode		*inode = VFS_I(ip);
+	bool			newinos = !!(flags & XFS_INODE_WALK_INEW_WAIT);
+
+	ASSERT(rcu_read_lock_held());
+
+	/* Check for stale RCU freed inode */
+	spin_lock(&ip->i_flags_lock);
+	if (!ip->i_ino)
+		goto out_unlock_noent;
+
+	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
+	if ((!newinos && __xfs_iflags_test(ip, XFS_INEW)) ||
+	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
+		goto out_unlock_noent;
+	spin_unlock(&ip->i_flags_lock);
+
+	/* nothing to sync during shutdown */
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return false;
+
+	/* If we can't grab the inode, it must on it's way to reclaim. */
+	if (!igrab(inode))
+		return false;
+
+	/* inode is valid */
+	return true;
+
+out_unlock_noent:
+	spin_unlock(&ip->i_flags_lock);
+	return false;
+}
+
 /* Scan one incore inode for block preallocations that we can remove. */
 static int
 xfs_blockgc_scan_inode(
@@ -1769,3 +1626,157 @@ xfs_blockgc_free_quota(
 			xfs_inode_dquot(ip, XFS_DQTYPE_GROUP),
 			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), eof_flags);
 }
+
+/* XFS Inode Cache Walking Code */
+
+/*
+ * For a given per-AG structure @pag, grab, @execute, and rele all incore
+ * inodes with the given radix tree @tag.
+ */
+static int
+xfs_inode_walk_ag(
+	struct xfs_perag	*pag,
+	int			iter_flags,
+	int			(*execute)(struct xfs_inode *ip, void *args),
+	void			*args,
+	int			tag)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	uint32_t		first_index;
+	int			last_error = 0;
+	int			skipped;
+	bool			done;
+	int			nr_found;
+
+restart:
+	done = false;
+	skipped = 0;
+	first_index = 0;
+	nr_found = 0;
+	do {
+		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
+		int		error = 0;
+		int		i;
+
+		rcu_read_lock();
+
+		if (tag == XFS_ICI_NO_TAG)
+			nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
+					(void **)batch, first_index,
+					XFS_LOOKUP_BATCH);
+		else
+			nr_found = radix_tree_gang_lookup_tag(
+					&pag->pag_ici_root,
+					(void **) batch, first_index,
+					XFS_LOOKUP_BATCH, tag);
+
+		if (!nr_found) {
+			rcu_read_unlock();
+			break;
+		}
+
+		/*
+		 * Grab the inodes before we drop the lock. if we found
+		 * nothing, nr == 0 and the loop will be skipped.
+		 */
+		for (i = 0; i < nr_found; i++) {
+			struct xfs_inode *ip = batch[i];
+
+			if (done || !xfs_inode_walk_ag_grab(ip, iter_flags))
+				batch[i] = NULL;
+
+			/*
+			 * Update the index for the next lookup. Catch
+			 * overflows into the next AG range which can occur if
+			 * we have inodes in the last block of the AG and we
+			 * are currently pointing to the last inode.
+			 *
+			 * Because we may see inodes that are from the wrong AG
+			 * due to RCU freeing and reallocation, only update the
+			 * index if it lies in this AG. It was a race that lead
+			 * us to see this inode, so another lookup from the
+			 * same index will not find it again.
+			 */
+			if (XFS_INO_TO_AGNO(mp, ip->i_ino) != pag->pag_agno)
+				continue;
+			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
+				done = true;
+		}
+
+		/* unlock now we've grabbed the inodes. */
+		rcu_read_unlock();
+
+		for (i = 0; i < nr_found; i++) {
+			if (!batch[i])
+				continue;
+			if ((iter_flags & XFS_INODE_WALK_INEW_WAIT) &&
+			    xfs_iflags_test(batch[i], XFS_INEW))
+				xfs_inew_wait(batch[i]);
+			error = execute(batch[i], args);
+			xfs_irele(batch[i]);
+			if (error == -EAGAIN) {
+				skipped++;
+				continue;
+			}
+			if (error && last_error != -EFSCORRUPTED)
+				last_error = error;
+		}
+
+		/* bail out if the filesystem is corrupted.  */
+		if (error == -EFSCORRUPTED)
+			break;
+
+		cond_resched();
+
+	} while (nr_found && !done);
+
+	if (skipped) {
+		delay(1);
+		goto restart;
+	}
+	return last_error;
+}
+
+/* Fetch the next (possibly tagged) per-AG structure. */
+static inline struct xfs_perag *
+xfs_inode_walk_get_perag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	int			tag)
+{
+	if (tag == XFS_ICI_NO_TAG)
+		return xfs_perag_get(mp, agno);
+	return xfs_perag_get_tag(mp, agno, tag);
+}
+
+/*
+ * Call the @execute function on all incore inodes matching the radix tree
+ * @tag.
+ */
+static int
+xfs_inode_walk(
+	struct xfs_mount	*mp,
+	int			iter_flags,
+	int			(*execute)(struct xfs_inode *ip, void *args),
+	void			*args,
+	int			tag)
+{
+	struct xfs_perag	*pag;
+	int			error = 0;
+	int			last_error = 0;
+	xfs_agnumber_t		agno = 0;
+
+	while ((pag = xfs_inode_walk_get_perag(mp, agno, tag))) {
+		agno = pag->pag_agno + 1;
+		error = xfs_inode_walk_ag(pag, iter_flags, execute, args, tag);
+		xfs_perag_put(pag);
+		if (error) {
+			last_error = error;
+			if (error == -EFSCORRUPTED)
+				break;
+		}
+	}
+	return last_error;
+	BUILD_BUG_ON(XFS_ICWALK_PRIVATE_FLAGS & XFS_EOF_FLAGS_VALID);
+}

