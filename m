Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0198E3222AC
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Feb 2021 00:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhBVXbv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Feb 2021 18:31:51 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:33619 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230057AbhBVXbv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Feb 2021 18:31:51 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 8F1B9FA768A
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 10:31:08 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEKfT-00HMfc-Ec
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 10:31:07 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lEKfT-00DZGi-6j
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 10:31:07 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: use current->journal_info for detecting transaction recursion
Date:   Tue, 23 Feb 2021 10:31:07 +1100
Message-Id: <20210222233107.3233795-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=OloAxu19YPiXiwF6eC8A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because the iomap code using PF_MEMALLOC_NOFS to detect transaction
recursion in XFS is just wrong. Remove it from the iomap code and
replace it with XFS specific internal checks using
current->journal_info instead.

Fixes: 9070733b4efa ("xfs: abstract PF_FSTRANS to PF_MEMALLOC_NOFS")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap/buffered-io.c    |  7 -------
 fs/xfs/libxfs/xfs_btree.c |  4 +++-
 fs/xfs/xfs_aops.c         | 17 +++++++++++++++--
 fs/xfs/xfs_trans.c        | 20 +++++---------------
 fs/xfs/xfs_trans.h        | 30 ++++++++++++++++++++++++++++++
 5 files changed, 53 insertions(+), 25 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 16a1e82e3aeb..fcd4a0d71fc1 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1458,13 +1458,6 @@ iomap_do_writepage(struct page *page, struct writeback_control *wbc, void *data)
 			PF_MEMALLOC))
 		goto redirty;
 
-	/*
-	 * Given that we do not allow direct reclaim to call us, we should
-	 * never be called in a recursive filesystem reclaim context.
-	 */
-	if (WARN_ON_ONCE(current->flags & PF_MEMALLOC_NOFS))
-		goto redirty;
-
 	/*
 	 * Is this page beyond the end of the file?
 	 *
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index b56ff451adce..e6a15b920034 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2805,7 +2805,7 @@ xfs_btree_split_worker(
 	struct xfs_btree_split_args	*args = container_of(work,
 						struct xfs_btree_split_args, work);
 	unsigned long		pflags;
-	unsigned long		new_pflags = PF_MEMALLOC_NOFS;
+	unsigned long		new_pflags = 0;
 
 	/*
 	 * we are in a transaction context here, but may also be doing work
@@ -2817,11 +2817,13 @@ xfs_btree_split_worker(
 		new_pflags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
 
 	current_set_flags_nested(&pflags, new_pflags);
+	xfs_trans_set_context(args->cur->bc_tp);
 
 	args->result = __xfs_btree_split(args->cur, args->level, args->ptrp,
 					 args->key, args->curp, args->stat);
 	complete(args->done);
 
+	xfs_trans_clear_context(args->cur->bc_tp);
 	current_restore_flags_nested(&pflags, new_pflags);
 }
 
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4304c6416fbb..b4186d666157 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -62,7 +62,7 @@ xfs_setfilesize_trans_alloc(
 	 * We hand off the transaction to the completion thread now, so
 	 * clear the flag here.
 	 */
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	xfs_trans_clear_context(tp);
 	return 0;
 }
 
@@ -125,7 +125,7 @@ xfs_setfilesize_ioend(
 	 * thus we need to mark ourselves as being in a transaction manually.
 	 * Similarly for freeze protection.
 	 */
-	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+	xfs_trans_set_context(tp);
 	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
 
 	/* we abort the update if there was an IO error */
@@ -568,6 +568,12 @@ xfs_vm_writepage(
 {
 	struct xfs_writepage_ctx wpc = { };
 
+	if (WARN_ON_ONCE(current->journal_info)) {
+		redirty_page_for_writepage(wbc, page);
+		unlock_page(page);
+		return 0;
+	}
+
 	return iomap_writepage(page, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
 
@@ -578,6 +584,13 @@ xfs_vm_writepages(
 {
 	struct xfs_writepage_ctx wpc = { };
 
+	/*
+	 * Writing back data in a transaction context can result in recursive
+	 * transactions. This is bad, so issue a warning and get out of here.
+	 */
+	if (WARN_ON_ONCE(current->journal_info))
+		return 0;
+
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 44f72c09c203..e2a922f061c7 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -72,6 +72,7 @@ xfs_trans_free(
 	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
 
 	trace_xfs_trans_free(tp, _RET_IP_);
+	xfs_trans_clear_context(tp);
 	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_end_intwrite(tp->t_mountp->m_super);
 	xfs_trans_free_dqinfo(tp);
@@ -123,7 +124,8 @@ xfs_trans_dup(
 
 	ntp->t_rtx_res = tp->t_rtx_res - tp->t_rtx_res_used;
 	tp->t_rtx_res = tp->t_rtx_res_used;
-	ntp->t_pflags = tp->t_pflags;
+
+	xfs_trans_switch_context(tp, ntp);
 
 	/* move deferred ops over to the new tp */
 	xfs_defer_move(ntp, tp);
@@ -157,9 +159,6 @@ xfs_trans_reserve(
 	int			error = 0;
 	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
 
-	/* Mark this thread as being in a transaction */
-	current_set_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
-
 	/*
 	 * Attempt to reserve the needed disk blocks by decrementing
 	 * the number needed from the number available.  This will
@@ -167,10 +166,8 @@ xfs_trans_reserve(
 	 */
 	if (blocks > 0) {
 		error = xfs_mod_fdblocks(mp, -((int64_t)blocks), rsvd);
-		if (error != 0) {
-			current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
+		if (error != 0)
 			return -ENOSPC;
-		}
 		tp->t_blk_res += blocks;
 	}
 
@@ -244,9 +241,6 @@ xfs_trans_reserve(
 		xfs_mod_fdblocks(mp, (int64_t)blocks, rsvd);
 		tp->t_blk_res = 0;
 	}
-
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
-
 	return error;
 }
 
@@ -270,6 +264,7 @@ xfs_trans_alloc(
 	tp = kmem_cache_zalloc(xfs_trans_zone, GFP_KERNEL | __GFP_NOFAIL);
 	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_start_intwrite(mp->m_super);
+	xfs_trans_set_context(tp);
 
 	/*
 	 * Zero-reservation ("empty") transactions can't modify anything, so
@@ -893,7 +888,6 @@ __xfs_trans_commit(
 
 	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
 
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	xfs_trans_free(tp);
 
 	/*
@@ -925,7 +919,6 @@ __xfs_trans_commit(
 			xfs_log_ticket_ungrant(mp->m_log, tp->t_ticket);
 		tp->t_ticket = NULL;
 	}
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	xfs_trans_free_items(tp, !!error);
 	xfs_trans_free(tp);
 
@@ -985,9 +978,6 @@ xfs_trans_cancel(
 		tp->t_ticket = NULL;
 	}
 
-	/* mark this thread as no longer being in a transaction */
-	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
-
 	xfs_trans_free_items(tp, dirty);
 	xfs_trans_free(tp);
 }
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 8b03fbfe9a1b..9dd745cf77c9 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -281,4 +281,34 @@ int xfs_trans_alloc_ichange(struct xfs_inode *ip, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, bool force,
 		struct xfs_trans **tpp);
 
+static inline void
+xfs_trans_set_context(
+	struct xfs_trans	*tp)
+{
+	ASSERT(current->journal_info == NULL);
+	tp->t_pflags = memalloc_nofs_save();
+	current->journal_info = tp;
+}
+
+static inline void
+xfs_trans_clear_context(
+	struct xfs_trans	*tp)
+{
+	if (current->journal_info == tp) {
+		memalloc_nofs_restore(tp->t_pflags);
+		current->journal_info = NULL;
+	}
+}
+
+static inline void
+xfs_trans_switch_context(
+	struct xfs_trans	*old_tp,
+	struct xfs_trans	*new_tp)
+{
+	ASSERT(current->journal_info == old_tp);
+	new_tp->t_pflags = old_tp->t_pflags;
+	old_tp->t_pflags = 0;
+	current->journal_info = new_tp;
+}
+
 #endif	/* __XFS_TRANS_H__ */
-- 
2.28.0

