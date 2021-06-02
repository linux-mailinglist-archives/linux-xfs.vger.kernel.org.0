Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A533995EE
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Jun 2021 00:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhFBW16 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 2 Jun 2021 18:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhFBW16 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:27:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97822613AC;
        Wed,  2 Jun 2021 22:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672774;
        bh=Vwac39+XKvEh3cxQPvQbb9odFPjQUOePlzoJYQ1c1Pg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MmJNz3AUyAa6wtPfroK3ordVYLt1K90XAZ1fMYlsdR8//f5U73NNpGrZKyg9gyZge
         LvpZ+E5zQMX2WdtnSuN3rGbFTiTyfi+2W0sz0xTCwQAtYqRZOb5xps8AU5hyoqKXUL
         198fqUfVxYTP2StmZtr038GWg7SFZ3rp+V9NUTlxmAYaKrWRY1L5j+ic58uaF9R5in
         FXfSwUHl+kucMqtrYvQD3xg8WXO7thWa2c/UmRAksy6HmGKaobqYDOEljwCpRzcWCp
         3XBgg0s4aRN1NRSyuK8Zzu8NfIWT0p6Wz0q6pzusIM68c8q+UNSysJtETwtbiz+aa5
         EQqe/NqS/VbYQ==
Subject: [PATCH 14/15] xfs: merge xfs_reclaim_inodes_ag into xfs_inode_walk_ag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Date:   Wed, 02 Jun 2021 15:26:14 -0700
Message-ID: <162267277428.2375284.12041128696726728176.stgit@locust>
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

Merge these two inode walk loops together, since they're pretty similar
now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c |  162 +++++++++++++++------------------------------------
 fs/xfs/xfs_icache.h |    3 +
 fs/xfs/xfs_trace.h  |    5 +-
 3 files changed, 55 insertions(+), 115 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0c40c39a5f9f..1223921fb01c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -43,6 +43,7 @@ enum xfs_icwalk_goal {
 
 	/* Goals directly associated with tagged inodes. */
 	XFS_ICWALK_BLOCKGC	= XFS_ICI_BLOCKGC_TAG,
+	XFS_ICWALK_RECLAIM	= XFS_ICI_RECLAIM_TAG,
 };
 
 #define XFS_ICWALK_NULL_TAG	(-1U)
@@ -67,9 +68,13 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
 #define XFS_ICWALK_FLAG_DROP_GDQUOT	(1U << 30)
 #define XFS_ICWALK_FLAG_DROP_PDQUOT	(1U << 29)
 
+/* Stop scanning after icw_scan_limit inodes. */
+#define XFS_ICWALK_FLAG_SCAN_LIMIT	(1U << 28)
+
 #define XFS_ICWALK_PRIVATE_FLAGS	(XFS_ICWALK_FLAG_DROP_UDQUOT | \
 					 XFS_ICWALK_FLAG_DROP_GDQUOT | \
-					 XFS_ICWALK_FLAG_DROP_PDQUOT)
+					 XFS_ICWALK_FLAG_DROP_PDQUOT | \
+					 XFS_ICWALK_FLAG_SCAN_LIMIT)
 
 /*
  * Allocate and initialise an xfs_inode.
@@ -760,17 +765,6 @@ xfs_icache_inode_is_allocated(
 	return 0;
 }
 
-/*
- * The inode lookup is done in batches to keep the amount of lock traffic and
- * radix tree lookups to a minimum. The batch size is a trade off between
- * lookup reduction and stack usage. This is in the reclaim path, so we can't
- * be too greedy.
- *
- * XXX: This will be moved closer to xfs_icwalk* once we get rid of the
- * separate reclaim walk functions.
- */
-#define XFS_LOOKUP_BATCH	32
-
 #ifdef CONFIG_XFS_QUOTA
 /* Decide if we want to grab this inode to drop its dquots. */
 static bool
@@ -880,7 +874,7 @@ xfs_dqrele_all_inodes(
  * Return true if we grabbed it, false otherwise.
  */
 static bool
-xfs_reclaim_inode_grab(
+xfs_reclaim_igrab(
 	struct xfs_inode	*ip)
 {
 	ASSERT(rcu_read_lock_held());
@@ -990,108 +984,13 @@ xfs_reclaim_inode(
 	xfs_iflags_clear(ip, XFS_IRECLAIM);
 }
 
-/*
- * Walk the AGs and reclaim the inodes in them. Even if the filesystem is
- * corrupted, we still want to try to reclaim all the inodes. If we don't,
- * then a shut down during filesystem unmount reclaim walk leak all the
- * unreclaimed inodes.
- *
- * Returns non-zero if any AGs or inodes were skipped in the reclaim pass
- * so that callers that want to block until all dirty inodes are written back
- * and reclaimed can sanely loop.
- */
-static void
-xfs_reclaim_inodes_ag(
-	struct xfs_mount	*mp,
-	int			*nr_to_scan)
-{
-	struct xfs_perag	*pag;
-	xfs_agnumber_t		ag = 0;
-
-	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
-		unsigned long	first_index = 0;
-		int		done = 0;
-		int		nr_found = 0;
-
-		ag = pag->pag_agno + 1;
-
-		first_index = READ_ONCE(pag->pag_ici_reclaim_cursor);
-		do {
-			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
-			int	i;
-
-			rcu_read_lock();
-			nr_found = radix_tree_gang_lookup_tag(
-					&pag->pag_ici_root,
-					(void **)batch, first_index,
-					XFS_LOOKUP_BATCH,
-					XFS_ICI_RECLAIM_TAG);
-			if (!nr_found) {
-				done = 1;
-				rcu_read_unlock();
-				break;
-			}
-
-			/*
-			 * Grab the inodes before we drop the lock. if we found
-			 * nothing, nr == 0 and the loop will be skipped.
-			 */
-			for (i = 0; i < nr_found; i++) {
-				struct xfs_inode *ip = batch[i];
-
-				if (done || !xfs_reclaim_inode_grab(ip))
-					batch[i] = NULL;
-
-				/*
-				 * Update the index for the next lookup. Catch
-				 * overflows into the next AG range which can
-				 * occur if we have inodes in the last block of
-				 * the AG and we are currently pointing to the
-				 * last inode.
-				 *
-				 * Because we may see inodes that are from the
-				 * wrong AG due to RCU freeing and
-				 * reallocation, only update the index if it
-				 * lies in this AG. It was a race that lead us
-				 * to see this inode, so another lookup from
-				 * the same index will not find it again.
-				 */
-				if (XFS_INO_TO_AGNO(mp, ip->i_ino) !=
-								pag->pag_agno)
-					continue;
-				first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
-				if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
-					done = 1;
-			}
-
-			/* unlock now we've grabbed the inodes. */
-			rcu_read_unlock();
-
-			for (i = 0; i < nr_found; i++) {
-				if (batch[i])
-					xfs_reclaim_inode(batch[i], pag);
-			}
-
-			*nr_to_scan -= XFS_LOOKUP_BATCH;
-			cond_resched();
-		} while (nr_found && !done && *nr_to_scan > 0);
-
-		if (done)
-			first_index = 0;
-		WRITE_ONCE(pag->pag_ici_reclaim_cursor, first_index);
-		xfs_perag_put(pag);
-	}
-}
-
 void
 xfs_reclaim_inodes(
 	struct xfs_mount	*mp)
 {
-	int		nr_to_scan = INT_MAX;
-
 	while (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
 		xfs_ail_push_all_sync(mp->m_ail);
-		xfs_reclaim_inodes_ag(mp, &nr_to_scan);
+		xfs_icwalk(mp, XFS_ICWALK_RECLAIM, NULL);
 	}
 }
 
@@ -1107,11 +1006,16 @@ xfs_reclaim_inodes_nr(
 	struct xfs_mount	*mp,
 	int			nr_to_scan)
 {
+	struct xfs_eofblocks	eofb = {
+		.eof_flags	= XFS_ICWALK_FLAG_SCAN_LIMIT,
+		.icw_scan_limit	= nr_to_scan,
+	};
+
 	/* kick background reclaimer and push the AIL */
 	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
 
-	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
+	xfs_icwalk(mp, XFS_ICWALK_RECLAIM, &eofb);
 	return 0;
 }
 
@@ -1221,9 +1125,8 @@ xfs_reclaim_worker(
 {
 	struct xfs_mount *mp = container_of(to_delayed_work(work),
 					struct xfs_mount, m_reclaim_work);
-	int		nr_to_scan = INT_MAX;
 
-	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
+	xfs_icwalk(mp, XFS_ICWALK_RECLAIM, NULL);
 	xfs_reclaim_work_queue(mp);
 }
 
@@ -1693,6 +1596,15 @@ xfs_blockgc_free_quota(
 
 /* XFS Inode Cache Walking Code */
 
+/*
+ * The inode lookup is done in batches to keep the amount of lock traffic and
+ * radix tree lookups to a minimum. The batch size is a trade off between
+ * lookup reduction and stack usage. This is in the reclaim path, so we can't
+ * be too greedy.
+ */
+#define XFS_LOOKUP_BATCH	32
+
+
 /*
  * Decide if we want to grab this inode in anticipation of doing work towards
  * the goal.
@@ -1707,6 +1619,8 @@ xfs_icwalk_igrab(
 		return xfs_dqrele_igrab(ip);
 	case XFS_ICWALK_BLOCKGC:
 		return xfs_blockgc_igrab(ip);
+	case XFS_ICWALK_RECLAIM:
+		return xfs_reclaim_igrab(ip);
 	default:
 		return false;
 	}
@@ -1720,6 +1634,7 @@ static inline int
 xfs_icwalk_process_inode(
 	enum xfs_icwalk_goal	goal,
 	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
 	struct xfs_eofblocks	*eofb)
 {
 	int			error = 0;
@@ -1731,6 +1646,9 @@ xfs_icwalk_process_inode(
 	case XFS_ICWALK_BLOCKGC:
 		error = xfs_blockgc_scan_inode(ip, eofb);
 		break;
+	case XFS_ICWALK_RECLAIM:
+		xfs_reclaim_inode(ip, pag);
+		break;
 	}
 	return error;
 }
@@ -1755,7 +1673,10 @@ xfs_icwalk_ag(
 restart:
 	done = false;
 	skipped = 0;
-	first_index = 0;
+	if (goal == XFS_ICWALK_RECLAIM)
+		first_index = READ_ONCE(pag->pag_ici_reclaim_cursor);
+	else
+		first_index = 0;
 	nr_found = 0;
 	do {
 		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
@@ -1776,6 +1697,7 @@ xfs_icwalk_ag(
 					XFS_LOOKUP_BATCH, tag);
 
 		if (!nr_found) {
+			done = true;
 			rcu_read_unlock();
 			break;
 		}
@@ -1815,7 +1737,8 @@ xfs_icwalk_ag(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			error = xfs_icwalk_process_inode(goal, batch[i], eofb);
+			error = xfs_icwalk_process_inode(goal, batch[i], pag,
+					eofb);
 			if (error == -EAGAIN) {
 				skipped++;
 				continue;
@@ -1830,8 +1753,19 @@ xfs_icwalk_ag(
 
 		cond_resched();
 
+		if (eofb && (eofb->eof_flags & XFS_ICWALK_FLAG_SCAN_LIMIT)) {
+			eofb->icw_scan_limit -= XFS_LOOKUP_BATCH;
+			if (eofb->icw_scan_limit <= 0)
+				break;
+		}
 	} while (nr_found && !done);
 
+	if (goal == XFS_ICWALK_RECLAIM) {
+		if (done)
+			first_index = 0;
+		WRITE_ONCE(pag->pag_ici_reclaim_cursor, first_index);
+	}
+
 	if (skipped) {
 		delay(1);
 		goto restart;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 3ec00f1fea86..2d86fdbd08a2 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -15,6 +15,9 @@ struct xfs_eofblocks {
 	kgid_t		eof_gid;
 	prid_t		eof_prid;
 	__u64		eof_min_file_size;
+
+	/* Stop after scanning this number of inodes. */
+	int		icw_scan_limit;
 };
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 808ae337b222..1377b1e24e1d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3898,6 +3898,7 @@ DECLARE_EVENT_CLASS(xfs_eofblocks_class,
 		__field(uint32_t, gid)
 		__field(prid_t, prid)
 		__field(__u64, min_file_size)
+		__field(int, scan_limit)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
@@ -3909,15 +3910,17 @@ DECLARE_EVENT_CLASS(xfs_eofblocks_class,
 						eofb->eof_gid) : 0;
 		__entry->prid = eofb ? eofb->eof_prid : 0;
 		__entry->min_file_size = eofb ? eofb->eof_min_file_size : 0;
+		__entry->scan_limit = eofb ? eofb->icw_scan_limit : 0;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d flags 0x%x uid %u gid %u prid %u minsize %llu caller %pS",
+	TP_printk("dev %d:%d flags 0x%x uid %u gid %u prid %u minsize %llu scan_limit %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->flags,
 		  __entry->uid,
 		  __entry->gid,
 		  __entry->prid,
 		  __entry->min_file_size,
+		  __entry->scan_limit,
 		  (char *)__entry->caller_ip)
 );
 #define DEFINE_EOFBLOCKS_EVENT(name)	\

