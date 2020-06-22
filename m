Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330022031C1
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Jun 2020 10:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgFVIQQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Jun 2020 04:16:16 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:59419 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725966AbgFVIQO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 04:16:14 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id AB422102BEB
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 18:16:10 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jnHcc-00045r-Bg
        for linux-xfs@vger.kernel.org; Mon, 22 Jun 2020 18:16:06 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jnHcc-007d5Z-2l
        for linux-xfs@vger.kernel.org; Mon, 22 Jun 2020 18:16:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 16/30] xfs: pin inode backing buffer to the inode log item
Date:   Mon, 22 Jun 2020 18:15:51 +1000
Message-Id: <20200622081605.1818434-17-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200622081605.1818434-1-david@fromorbit.com>
References: <20200622081605.1818434-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=BWTjdfWTP5q8G_7E9WIA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we dirty an inode, we are going to have to write it disk at
some point in the near future. This requires the inode cluster
backing buffer to be present in memory. Unfortunately, under severe
memory pressure we can reclaim the inode backing buffer while the
inode is dirty in memory, resulting in stalling the AIL pushing
because it has to do a read-modify-write cycle on the cluster
buffer.

When we have no memory available, the read of the cluster buffer
blocks the AIL pushing process, and this causes all sorts of issues
for memory reclaim as it requires inode writeback to make forwards
progress. Allocating a cluster buffer causes more memory pressure,
and results in more cluster buffers to be reclaimed, resulting in
more RMW cycles to be done in the AIL context and everything then
backs up on AIL progress. Only the synchronous inode cluster
writeback in the the inode reclaim code provides some level of
forwards progress guarantees that prevent OOM-killer rampages in
this situation.

Fix this by pinning the inode backing buffer to the inode log item
when the inode is first dirtied (i.e. in xfs_trans_log_inode()).
This may mean the first modification of an inode that has been held
in cache for a long time may block on a cluster buffer read, but
we can do that in transaction context and block safely until the
buffer has been allocated and read.

Once we have the cluster buffer, the inode log item takes a
reference to it, pinning it in memory, and attaches it to the log
item for future reference. This means we can always grab the cluster
buffer from the inode log item when we need it.

When the inode is finally cleaned and removed from the AIL, we can
drop the reference the inode log item holds on the cluster buffer.
Once all inodes on the cluster buffer are clean, the cluster buffer
will be unpinned and it will be available for memory reclaim to
reclaim again.

This avoids the issues with needing to do RMW cycles in the AIL
pushing context, and hence allows complete non-blocking inode
flushing to be performed by the AIL pushing context.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c   |  3 +-
 fs/xfs/libxfs/xfs_trans_inode.c | 53 ++++++++++++++++++++++++----
 fs/xfs/xfs_buf_item.c           |  4 +--
 fs/xfs/xfs_inode_item.c         | 61 ++++++++++++++++++++++++++-------
 fs/xfs/xfs_trans_ail.c          |  8 +++--
 5 files changed, 105 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 6f84ea85fdd8..1af97235785c 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -176,7 +176,8 @@ xfs_imap_to_bp(
 	}
 
 	*bpp = bp;
-	*dipp = xfs_buf_offset(bp, imap->im_boffset);
+	if (dipp)
+		*dipp = xfs_buf_offset(bp, imap->im_boffset);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index c66d9d1dd58b..ad5974365c58 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -8,6 +8,8 @@
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
@@ -72,13 +74,19 @@ xfs_trans_ichgtime(
 }
 
 /*
- * This is called to mark the fields indicated in fieldmask as needing
- * to be logged when the transaction is committed.  The inode must
- * already be associated with the given transaction.
+ * This is called to mark the fields indicated in fieldmask as needing to be
+ * logged when the transaction is committed.  The inode must already be
+ * associated with the given transaction.
  *
- * The values for fieldmask are defined in xfs_inode_item.h.  We always
- * log all of the core inode if any of it has changed, and we always log
- * all of the inline data/extents/b-tree root if any of them has changed.
+ * The values for fieldmask are defined in xfs_inode_item.h.  We always log all
+ * of the core inode if any of it has changed, and we always log all of the
+ * inline data/extents/b-tree root if any of them has changed.
+ *
+ * Grab and pin the cluster buffer associated with this inode to avoid RMW
+ * cycles at inode writeback time. Avoid the need to add error handling to every
+ * xfs_trans_log_inode() call by shutting down on read error.  This will cause
+ * transactions to fail and everything to error out, just like if we return a
+ * read error in a dirty transaction and cancel it.
  */
 void
 xfs_trans_log_inode(
@@ -131,6 +139,39 @@ xfs_trans_log_inode(
 	spin_lock(&iip->ili_lock);
 	iip->ili_fsync_fields |= flags;
 
+	if (!iip->ili_item.li_buf) {
+		struct xfs_buf	*bp;
+		int		error;
+
+		/*
+		 * We hold the ILOCK here, so this inode is not going to be
+		 * flushed while we are here. Further, because there is no
+		 * buffer attached to the item, we know that there is no IO in
+		 * progress, so nothing will clear the ili_fields while we read
+		 * in the buffer. Hence we can safely drop the spin lock and
+		 * read the buffer knowing that the state will not change from
+		 * here.
+		 */
+		spin_unlock(&iip->ili_lock);
+		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, NULL,
+					&bp, 0);
+		if (error) {
+			xfs_force_shutdown(ip->i_mount, SHUTDOWN_META_IO_ERROR);
+			return;
+		}
+
+		/*
+		 * We need an explicit buffer reference for the log item but
+		 * don't want the buffer to remain attached to the transaction.
+		 * Hold the buffer but release the transaction reference.
+		 */
+		xfs_buf_hold(bp);
+		xfs_trans_brelse(tp, bp);
+
+		spin_lock(&iip->ili_lock);
+		iip->ili_item.li_buf = bp;
+	}
+
 	/*
 	 * Always OR in the bits from the ili_last_fields field.  This is to
 	 * coordinate with the xfs_iflush() and xfs_iflush_done() routines in
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index d61f20b989cd..ecb3362395af 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1143,11 +1143,9 @@ xfs_buf_inode_iodone(
 		if (ret == XBF_IOERROR_DONE)
 			return;
 		ASSERT(ret == XBF_IOERROR_FAIL);
-		spin_lock(&bp->b_mount->m_ail->ail_lock);
 		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
-			xfs_set_li_failed(lip, bp);
+			set_bit(XFS_LI_FAILED, &lip->li_flags);
 		}
-		spin_unlock(&bp->b_mount->m_ail->ail_lock);
 		xfs_buf_ioerror(bp, 0);
 		xfs_buf_relse(bp);
 		return;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 0ba75764a8dc..64bdda72f7b2 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -439,6 +439,7 @@ xfs_inode_item_pin(
 	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	ASSERT(lip->li_buf);
 
 	trace_xfs_inode_pin(ip, _RET_IP_);
 	atomic_inc(&ip->i_pincount);
@@ -450,6 +451,12 @@ xfs_inode_item_pin(
  * item which was previously pinned with a call to xfs_inode_item_pin().
  *
  * Also wake up anyone in xfs_iunpin_wait() if the count goes to 0.
+ *
+ * Note that unpin can race with inode cluster buffer freeing marking the buffer
+ * stale. In that case, flush completions are run from the buffer unpin call,
+ * which may happen before the inode is unpinned. If we lose the race, there
+ * will be no buffer attached to the log item, but the inode will be marked
+ * XFS_ISTALE.
  */
 STATIC void
 xfs_inode_item_unpin(
@@ -459,6 +466,7 @@ xfs_inode_item_unpin(
 	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
 
 	trace_xfs_inode_unpin(ip, _RET_IP_);
+	ASSERT(lip->li_buf || xfs_iflags_test(ip, XFS_ISTALE));
 	ASSERT(atomic_read(&ip->i_pincount) > 0);
 	if (atomic_dec_and_test(&ip->i_pincount))
 		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
@@ -629,10 +637,15 @@ xfs_inode_item_init(
  */
 void
 xfs_inode_item_destroy(
-	xfs_inode_t	*ip)
+	struct xfs_inode	*ip)
 {
-	kmem_free(ip->i_itemp->ili_item.li_lv_shadow);
-	kmem_cache_free(xfs_ili_zone, ip->i_itemp);
+	struct xfs_inode_log_item *iip = ip->i_itemp;
+
+	ASSERT(iip->ili_item.li_buf == NULL);
+
+	ip->i_itemp = NULL;
+	kmem_free(iip->ili_item.li_lv_shadow);
+	kmem_cache_free(xfs_ili_zone, iip);
 }
 
 
@@ -673,11 +686,10 @@ xfs_iflush_done(
 		list_move_tail(&lip->li_bio_list, &tmp);
 
 		/* Do an unlocked check for needing the AIL lock. */
-		if (lip->li_lsn == iip->ili_flush_lsn ||
+		if (iip->ili_flush_lsn == lip->li_lsn ||
 		    test_bit(XFS_LI_FAILED, &lip->li_flags))
 			need_ail++;
 	}
-	ASSERT(list_empty(&bp->b_li_list));
 
 	/*
 	 * We only want to pull the item from the AIL if it is actually there
@@ -690,7 +702,7 @@ xfs_iflush_done(
 		/* this is an opencoded batch version of xfs_trans_ail_delete */
 		spin_lock(&ailp->ail_lock);
 		list_for_each_entry(lip, &tmp, li_bio_list) {
-			xfs_clear_li_failed(lip);
+			clear_bit(XFS_LI_FAILED, &lip->li_flags);
 			if (lip->li_lsn == INODE_ITEM(lip)->ili_flush_lsn) {
 				xfs_lsn_t lsn = xfs_ail_delete_one(ailp, lip);
 				if (!tail_lsn && lsn)
@@ -706,14 +718,29 @@ xfs_iflush_done(
 	 * them is safely on disk.
 	 */
 	list_for_each_entry_safe(lip, n, &tmp, li_bio_list) {
+		bool	drop_buffer = false;
+
 		list_del_init(&lip->li_bio_list);
 		iip = INODE_ITEM(lip);
 
 		spin_lock(&iip->ili_lock);
+
+		/*
+		 * Remove the reference to the cluster buffer if the inode is
+		 * clean in memory. Drop the buffer reference once we've dropped
+		 * the locks we hold.
+		 */
+		ASSERT(iip->ili_item.li_buf == bp);
+		if (!iip->ili_fields) {
+			iip->ili_item.li_buf = NULL;
+			drop_buffer = true;
+		}
 		iip->ili_last_fields = 0;
+		iip->ili_flush_lsn = 0;
 		spin_unlock(&iip->ili_lock);
-
 		xfs_ifunlock(iip->ili_inode);
+		if (drop_buffer)
+			xfs_buf_rele(bp);
 	}
 }
 
@@ -725,12 +752,20 @@ xfs_iflush_done(
  */
 void
 xfs_iflush_abort(
-	struct xfs_inode		*ip)
+	struct xfs_inode	*ip)
 {
-	struct xfs_inode_log_item	*iip = ip->i_itemp;
+	struct xfs_inode_log_item *iip = ip->i_itemp;
+	struct xfs_buf		*bp = NULL;
 
 	if (iip) {
+		/*
+		 * Clear the failed bit before removing the item from the AIL so
+		 * xfs_trans_ail_delete() doesn't try to clear and release the
+		 * buffer attached to the log item before we are done with it.
+		 */
+		clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
 		xfs_trans_ail_delete(&iip->ili_item, 0);
+
 		/*
 		 * Clear the inode logging fields so no more flushes are
 		 * attempted.
@@ -739,12 +774,14 @@ xfs_iflush_abort(
 		iip->ili_last_fields = 0;
 		iip->ili_fields = 0;
 		iip->ili_fsync_fields = 0;
+		iip->ili_flush_lsn = 0;
+		bp = iip->ili_item.li_buf;
+		iip->ili_item.li_buf = NULL;
 		spin_unlock(&iip->ili_lock);
 	}
-	/*
-	 * Release the inode's flush lock since we're done with it.
-	 */
 	xfs_ifunlock(ip);
+	if (bp)
+		xfs_buf_rele(bp);
 }
 
 /*
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index ac33f6393f99..c3be6e440134 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -377,8 +377,12 @@ xfsaild_resubmit_item(
 	}
 
 	/* protected by ail_lock */
-	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
-		xfs_clear_li_failed(lip);
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
+		if (bp->b_flags & _XBF_INODES)
+			clear_bit(XFS_LI_FAILED, &lip->li_flags);
+		else
+			xfs_clear_li_failed(lip);
+	}
 
 	xfs_buf_unlock(bp);
 	return XFS_ITEM_SUCCESS;
-- 
2.26.2.761.g0e0b3e54be

