Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7971DA46F
	for <lists+linux-xfs@lfdr.de>; Wed, 20 May 2020 00:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgESWXW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 May 2020 18:23:22 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:51197 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgESWXW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 18:23:22 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id AFBB410848E
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2020 08:23:17 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbAdm-0000Od-ID
        for linux-xfs@vger.kernel.org; Wed, 20 May 2020 08:23:14 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbAdm-00AoIn-8u
        for linux-xfs@vger.kernel.org; Wed, 20 May 2020 08:23:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: remove the m_active_trans counter
Date:   Wed, 20 May 2020 08:23:10 +1000
Message-Id: <20200519222310.2576434-3-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200519222310.2576434-1-david@fromorbit.com>
References: <20200519222310.2576434-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=SEixpNHg4T1Qy58cauEA:9
        a=8iiMAYdi-KwaQynK:21 a=10PMRWca_MO5bq_X:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It's a global atomic counter, and we are hitting it at a rate of
half a million transactions a second, so it's bouncing the counter
cacheline all over the place on large machines. We don't actually
need it anymore - it used to be required because the VFS freeze code
could not track/prevent filesystem transactions that were running,
but that problem no longer exists.

Hence to remove the counter, we simply have to ensure that nothing
calls xfs_sync_sb() while we are trying to quiesce the filesytem.
That only happens if the log worker is still running when we call
xfs_quiesce_attr(). The log worker is cancelled at the end of
xfs_quiesce_attr() by calling xfs_log_quiesce(), so just call it
early here and then we can remove the counter altogether.

Concurrent create, 50 million inodes, identical 16p/16GB virtual
machines on different physical hosts. Machine A has twice the CPU
cores per socket of machine B:

		unpatched	patched
machine A:	3m16s		2m00s
machine B:	4m04s		4m05s

Create rates:
		unpatched	patched
machine A:	282k+/-31k	468k+/-21k
machine B:	231k+/-8k	233k+/-11k

Concurrent rm of same 50 million inodes:

		unpatched	patched
machine A:	6m42s		2m33s
machine B:	4m47s		4m47s

The transaction rate on the fast machine went from just under
300k/sec to 700k/sec, which indicates just how much of a bottleneck
this atomic counter was.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h |  1 -
 fs/xfs/xfs_super.c | 17 +++++------------
 fs/xfs/xfs_trans.c | 27 +++++++++++----------------
 3 files changed, 16 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c1f92c1847bb2..3725d25ad97e8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -176,7 +176,6 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks;	/* total reserved blocks */
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
-	atomic_t		m_active_trans;	/* number trans frozen */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
 	struct delayed_work	m_eofblocks_work; /* background eof blocks
 						     trimming */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index aae469f73efeb..fa58cb07c8fdf 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -874,8 +874,10 @@ xfs_restore_resvblks(struct xfs_mount *mp)
  * there is no log replay required to write the inodes to disk - this is the
  * primary difference between a sync and a quiesce.
  *
- * Note: xfs_log_quiesce() stops background log work - the callers must ensure
- * it is started again when appropriate.
+ * We cancel log work early here to ensure all transactions the log worker may
+ * run have finished before we clean up and log the superblock and write an
+ * unmount record. The unfreeze process is responsible for restarting the log
+ * worker correctly.
  */
 void
 xfs_quiesce_attr(
@@ -883,9 +885,7 @@ xfs_quiesce_attr(
 {
 	int	error = 0;
 
-	/* wait for all modifications to complete */
-	while (atomic_read(&mp->m_active_trans) > 0)
-		delay(100);
+	cancel_delayed_work_sync(&mp->m_log->l_work);
 
 	/* force the log to unpin objects from the now complete transactions */
 	xfs_log_force(mp, XFS_LOG_SYNC);
@@ -899,12 +899,6 @@ xfs_quiesce_attr(
 	if (error)
 		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
 				"Frozen image may not be consistent.");
-	/*
-	 * Just warn here till VFS can correctly support
-	 * read-only remount without racing.
-	 */
-	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
-
 	xfs_log_quiesce(mp);
 }
 
@@ -1793,7 +1787,6 @@ static int xfs_init_fs_context(
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
 	spin_lock_init(&mp->m_perag_lock);
 	mutex_init(&mp->m_growlock);
-	atomic_set(&mp->m_active_trans, 0);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index b055a5ab53465..217937d743dbb 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -68,7 +68,6 @@ xfs_trans_free(
 	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
 
 	trace_xfs_trans_free(tp, _RET_IP_);
-	atomic_dec(&tp->t_mountp->m_active_trans);
 	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_end_intwrite(tp->t_mountp->m_super);
 	xfs_trans_free_dqinfo(tp);
@@ -125,8 +124,6 @@ xfs_trans_dup(
 	xfs_defer_move(ntp, tp);
 
 	xfs_trans_dup_dqinfo(tp, ntp);
-
-	atomic_inc(&tp->t_mountp->m_active_trans);
 	return ntp;
 }
 
@@ -275,7 +272,6 @@ xfs_trans_alloc(
 	 */
 	WARN_ON(resp->tr_logres > 0 &&
 		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
-	atomic_inc(&mp->m_active_trans);
 
 	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
 	tp->t_flags = flags;
@@ -299,20 +295,19 @@ xfs_trans_alloc(
 
 /*
  * Create an empty transaction with no reservation.  This is a defensive
- * mechanism for routines that query metadata without actually modifying
- * them -- if the metadata being queried is somehow cross-linked (think a
- * btree block pointer that points higher in the tree), we risk deadlock.
- * However, blocks grabbed as part of a transaction can be re-grabbed.
- * The verifiers will notice the corrupt block and the operation will fail
- * back to userspace without deadlocking.
+ * mechanism for routines that query metadata without actually modifying them --
+ * if the metadata being queried is somehow cross-linked (think a btree block
+ * pointer that points higher in the tree), we risk deadlock.  However, blocks
+ * grabbed as part of a transaction can be re-grabbed.  The verifiers will
+ * notice the corrupt block and the operation will fail back to userspace
+ * without deadlocking.
  *
- * Note the zero-length reservation; this transaction MUST be cancelled
- * without any dirty data.
+ * Note the zero-length reservation; this transaction MUST be cancelled without
+ * any dirty data.
  *
- * Callers should obtain freeze protection to avoid two conflicts with fs
- * freezing: (1) having active transactions trip the m_active_trans ASSERTs;
- * and (2) grabbing buffers at the same time that freeze is trying to drain
- * the buffer LRU list.
+ * Callers should obtain freeze protection to avoid a conflict with fs freezing
+ * where we can be grabbing buffers at the same time that freeze is trying to
+ * drain the buffer LRU list.
  */
 int
 xfs_trans_alloc_empty(
-- 
2.26.2.761.g0e0b3e54be

