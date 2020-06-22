Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472302031D0
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Jun 2020 10:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgFVIQV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Jun 2020 04:16:21 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:53609 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725907AbgFVIQT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 04:16:19 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 629341A8B4F
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 18:16:13 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jnHcc-00046L-Qa
        for linux-xfs@vger.kernel.org; Mon, 22 Jun 2020 18:16:06 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jnHcc-007d6N-Hi
        for linux-xfs@vger.kernel.org; Mon, 22 Jun 2020 18:16:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 26/30] xfs: xfs_iflush() is no longer necessary
Date:   Mon, 22 Jun 2020 18:16:01 +1000
Message-Id: <20200622081605.1818434-27-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200622081605.1818434-1-david@fromorbit.com>
References: <20200622081605.1818434-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=FPQKXuVpiB5N0kaoULwA:9 a=R5Pht39AzYrijRAV:21 a=OvMOwc2Nx63xUJDp:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now we have a cached buffer on inode log items, we don't need
to do buffer lookups when flushing inodes anymore - all we need
to do is lock the buffer and we are ready to go.

This largely gets rid of the need for xfs_iflush(), which is
essentially just a mechanism to look up the buffer and flush the
inode to it. Instead, we can just call xfs_iflush_cluster() with a
few modifications to ensure it also flushes the inode we already
hold locked.

This allows the AIL inode item pushing to be almost entirely
non-blocking in XFS - we won't block unless memory allocation
for the cluster inode lookup blocks or the block device queues are
full.

Writeback during inode reclaim becomes a little more complex because
we now have to lock the buffer ourselves, but otherwise this change
is largely a functional no-op that removes a whole lot of code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c      | 107 ++++++----------------------------------
 fs/xfs/xfs_inode.h      |   2 +-
 fs/xfs/xfs_inode_item.c |  51 +++++++------------
 3 files changed, 33 insertions(+), 127 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 382e9a8bbfbf..74d09487f702 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3450,7 +3450,18 @@ xfs_rename(
 	return error;
 }
 
-STATIC int
+/*
+ * Non-blocking flush of dirty inode metadata into the backing buffer.
+ *
+ * The caller must have a reference to the inode and hold the cluster buffer
+ * locked. The function will walk across all the inodes on the cluster buffer it
+ * can find and lock without blocking, and flush them to the cluster buffer.
+ *
+ * On success, the caller must write out the buffer returned in *bp and
+ * release it. On failure, the filesystem will be shut down, the buffer will
+ * have been unlocked and released, and EFSCORRUPTED will be returned.
+ */
+int
 xfs_iflush_cluster(
 	struct xfs_inode	*ip,
 	struct xfs_buf		*bp)
@@ -3485,8 +3496,6 @@ xfs_iflush_cluster(
 
 	for (i = 0; i < nr_found; i++) {
 		cip = cilist[i];
-		if (cip == ip)
-			continue;
 
 		/*
 		 * because this is an RCU protected lookup, we could find a
@@ -3577,99 +3586,11 @@ xfs_iflush_cluster(
 	kmem_free(cilist);
 out_put:
 	xfs_perag_put(pag);
-	return error;
-}
-
-/*
- * Flush dirty inode metadata into the backing buffer.
- *
- * The caller must have the inode lock and the inode flush lock held.  The
- * inode lock will still be held upon return to the caller, and the inode
- * flush lock will be released after the inode has reached the disk.
- *
- * The caller must write out the buffer returned in *bpp and release it.
- */
-int
-xfs_iflush(
-	struct xfs_inode	*ip,
-	struct xfs_buf		**bpp)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_buf		*bp = NULL;
-	struct xfs_dinode	*dip;
-	int			error;
-
-	XFS_STATS_INC(mp, xs_iflush_count);
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
-	ASSERT(xfs_isiflocked(ip));
-	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
-	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
-
-	*bpp = NULL;
-
-	xfs_iunpin_wait(ip);
-
-	/*
-	 * For stale inodes we cannot rely on the backing buffer remaining
-	 * stale in cache for the remaining life of the stale inode and so
-	 * xfs_imap_to_bp() below may give us a buffer that no longer contains
-	 * inodes below. We have to check this after ensuring the inode is
-	 * unpinned so that it is safe to reclaim the stale inode after the
-	 * flush call.
-	 */
-	if (xfs_iflags_test(ip, XFS_ISTALE)) {
-		xfs_ifunlock(ip);
-		return 0;
-	}
-
-	/*
-	 * Get the buffer containing the on-disk inode. We are doing a try-lock
-	 * operation here, so we may get an EAGAIN error. In that case, return
-	 * leaving the inode dirty.
-	 *
-	 * If we get any other error, we effectively have a corruption situation
-	 * and we cannot flush the inode. Abort the flush and shut down.
-	 */
-	error = xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK);
-	if (error == -EAGAIN) {
-		xfs_ifunlock(ip);
-		return error;
-	}
-	if (error)
-		goto abort;
-
-	/*
-	 * If the buffer is pinned then push on the log now so we won't
-	 * get stuck waiting in the write for too long.
-	 */
-	if (xfs_buf_ispinned(bp))
-		xfs_log_force(mp, 0);
-
-	/*
-	 * Flush the provided inode then attempt to gather others from the
-	 * cluster into the write.
-	 *
-	 * Note: Once we attempt to flush an inode, we must run buffer
-	 * completion callbacks on any failure. If this fails, simulate an I/O
-	 * failure on the buffer and shut down.
-	 */
-	error = xfs_iflush_int(ip, bp);
-	if (!error)
-		error = xfs_iflush_cluster(ip, bp);
 	if (error) {
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
-		goto shutdown;
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	}
-
-	*bpp = bp;
-	return 0;
-
-abort:
-	xfs_iflush_abort(ip);
-shutdown:
-	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	return error;
 }
 
@@ -3687,7 +3608,7 @@ xfs_iflush_int(
 	ASSERT(xfs_isiflocked(ip));
 	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
-	ASSERT(iip != NULL && iip->ili_fields != 0);
+	ASSERT(iip->ili_item.li_buf == bp);
 
 	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 47d3b391030d..9ae1b6a830e1 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -426,7 +426,7 @@ int		xfs_log_force_inode(struct xfs_inode *ip);
 void		xfs_iunpin_wait(xfs_inode_t *);
 #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
 
-int		xfs_iflush(struct xfs_inode *, struct xfs_buf **);
+int		xfs_iflush_cluster(struct xfs_inode *, struct xfs_buf *);
 void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 				struct xfs_inode *ip1, uint ip1_mode);
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 697248b7eb2b..e8eda2ac25fb 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -485,53 +485,38 @@ xfs_inode_item_push(
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
-	if (xfs_ipincount(ip) > 0)
+	ASSERT(iip->ili_item.li_buf);
+
+	if (xfs_ipincount(ip) > 0 || xfs_buf_ispinned(bp) ||
+	    (ip->i_flags & XFS_ISTALE))
 		return XFS_ITEM_PINNED;
 
-	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
-		return XFS_ITEM_LOCKED;
+	/* If the inode is already flush locked, we're already flushing. */
+	if (xfs_isiflocked(ip))
+		return XFS_ITEM_FLUSHING;
 
-	/*
-	 * Re-check the pincount now that we stabilized the value by
-	 * taking the ilock.
-	 */
-	if (xfs_ipincount(ip) > 0) {
-		rval = XFS_ITEM_PINNED;
-		goto out_unlock;
-	}
+	if (!xfs_buf_trylock(bp))
+		return XFS_ITEM_LOCKED;
 
-	/*
-	 * Stale inode items should force out the iclog.
-	 */
-	if (ip->i_flags & XFS_ISTALE) {
-		rval = XFS_ITEM_PINNED;
-		goto out_unlock;
-	}
+	spin_unlock(&lip->li_ailp->ail_lock);
 
 	/*
-	 * Someone else is already flushing the inode.  Nothing we can do
-	 * here but wait for the flush to finish and remove the item from
-	 * the AIL.
+	 * We need to hold a reference for flushing the cluster buffer as it may
+	 * fail the buffer without IO submission. In which case, we better get a
+	 * reference for that completion because otherwise we don't get a
+	 * reference for IO until we queue the buffer for delwri submission.
 	 */
-	if (!xfs_iflock_nowait(ip)) {
-		rval = XFS_ITEM_FLUSHING;
-		goto out_unlock;
-	}
-
-	ASSERT(iip->ili_fields != 0 || XFS_FORCED_SHUTDOWN(ip->i_mount));
-	spin_unlock(&lip->li_ailp->ail_lock);
-
-	error = xfs_iflush(ip, &bp);
+	xfs_buf_hold(bp);
+	error = xfs_iflush_cluster(ip, bp);
 	if (!error) {
 		if (!xfs_buf_delwri_queue(bp, buffer_list))
 			rval = XFS_ITEM_FLUSHING;
 		xfs_buf_relse(bp);
-	} else if (error == -EAGAIN)
+	} else {
 		rval = XFS_ITEM_LOCKED;
+	}
 
 	spin_lock(&lip->li_ailp->ail_lock);
-out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	return rval;
 }
 
-- 
2.26.2.761.g0e0b3e54be

