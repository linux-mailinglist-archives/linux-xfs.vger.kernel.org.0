Return-Path: <linux-xfs+bounces-18818-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44F5EA27A96
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Feb 2025 19:52:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B40DB3A23B4
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Feb 2025 18:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 084D721885B;
	Tue,  4 Feb 2025 18:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1pCMWzh"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14BA21639B;
	Tue,  4 Feb 2025 18:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738695160; cv=none; b=PDhwGbBE23Atkaqndj4kuBDziugWNB0L+8BJStJTDN6iBiZs1HO8czty27Hag8PjGj9vkcyKMiIQbO6x2Z2yU1MUx1NZIZB4oTKcdOefmIrHqYTQaNbuESCU98rCBk95jUtpMtfbljDE6yFR6J9DzXt+pSr/4E2dG8aJiwFAPfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738695160; c=relaxed/simple;
	bh=fJE5c2SYDuPSOB4OJM18JTSAVvKSYgWBQdL4wciOW4U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sWLiuJaZRgHgoHvx/zuR2iV7m7A3WKH6kSUXLwXxDsPI9xkRBppigFcAcp6w+/ebmey2q2O7SNXKI/h0VTifzDuhV57LAaPoPKj6a8Zt2mUcYTUEWXwB6rTKQ8ckwffBju0GuDGBtXS7rJGpDWwd29SYgHWFAXUD0R1G4WEgsi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1pCMWzh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22364C4CEDF;
	Tue,  4 Feb 2025 18:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738695160;
	bh=fJE5c2SYDuPSOB4OJM18JTSAVvKSYgWBQdL4wciOW4U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C1pCMWzh6DDxiFJPw/CqAvKHzrrv85VWsIteYTc5E5h3FHLFaLr4qKRpoqtee5BaS
	 DtACdNyvVWWkLlTSw2yDs0s3pw1shycawvnU9mOYbqZDZklfo8DDKcMdBDyxCChIt+
	 46fe7XLGoDfBSHss6y7e5LQvsZqa00HDUrPT+L96eybJJCPv2XlRAESC3zCKwJBJd6
	 82AYEqXdM1eME2rHWcgA9QHr7MCDNJ94OYqXIY7n46tV4hNcxZeXTX1fBXuF+/PrdA
	 xiWKzHVzEvTypeBpGcaFNCJ+bQ8vZ+vBNdn9qfUGgUnpbZorjlyFoWD1nKODPxnCXw
	 BEYSd6kCBBV4g==
Date: Tue, 04 Feb 2025 10:52:39 -0800
Subject: [PATCH 06/10] xfs: attach dquot buffer to dquot log item buffer
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, xfs-stable@lists.linux.dev, linux-xfs@vger.kernel.org
Cc: hch@lst.de, stable@vger.kernel.org
Message-ID: <173869499439.410229.14858014604677260670.stgit@frogsfrogsfrogs>
In-Reply-To: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
References: <173869499323.410229.9898612619797978336.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

commit acc8f8628c3737108f36e5637f4d5daeaf96d90e upstream

Ever since 6.12-rc1, I've observed a pile of warnings from the kernel
when running fstests with quotas enabled:

WARNING: CPU: 1 PID: 458580 at mm/page_alloc.c:4221 __alloc_pages_noprof+0xc9c/0xf18
CPU: 1 UID: 0 PID: 458580 Comm: xfsaild/sda3 Tainted: G        W          6.12.0-rc6-djwa #rc6 6ee3e0e531f6457e2d26aa008a3b65ff184b377c
<snip>
Call trace:
 __alloc_pages_noprof+0xc9c/0xf18
 alloc_pages_mpol_noprof+0x94/0x240
 alloc_pages_noprof+0x68/0xf8
 new_slab+0x3e0/0x568
 ___slab_alloc+0x5a0/0xb88
 __slab_alloc.constprop.0+0x7c/0xf8
 __kmalloc_noprof+0x404/0x4d0
 xfs_buf_get_map+0x594/0xde0 [xfs 384cb02810558b4c490343c164e9407332118f88]
 xfs_buf_read_map+0x64/0x2e0 [xfs 384cb02810558b4c490343c164e9407332118f88]
 xfs_trans_read_buf_map+0x1dc/0x518 [xfs 384cb02810558b4c490343c164e9407332118f88]
 xfs_qm_dqflush+0xac/0x468 [xfs 384cb02810558b4c490343c164e9407332118f88]
 xfs_qm_dquot_logitem_push+0xe4/0x148 [xfs 384cb02810558b4c490343c164e9407332118f88]
 xfsaild+0x3f4/0xde8 [xfs 384cb02810558b4c490343c164e9407332118f88]
 kthread+0x110/0x128
 ret_from_fork+0x10/0x20
---[ end trace 0000000000000000 ]---

This corresponds to the line:

	WARN_ON_ONCE(current->flags & PF_MEMALLOC);

within the NOFAIL checks.  What's happening here is that the XFS AIL is
trying to write a disk quota update back into the filesystem, but for
that it needs to read the ondisk buffer for the dquot.  The buffer is
not in memory anymore, probably because it was evicted.  Regardless, the
buffer cache tries to allocate a new buffer, but those allocations are
NOFAIL.  The AIL thread has marked itself PF_MEMALLOC (aka noreclaim)
since commit 43ff2122e6492b ("xfs: on-stack delayed write buffer lists")
presumably because reclaim can push on XFS to push on the AIL.

An easy way to fix this probably would have been to drop the NOFAIL flag
from the xfs_buf allocation and open code a retry loop, but then there's
still the problem that for bs>ps filesystems, the buffer itself could
require up to 64k worth of pages.

Inode items had similar behavior (multi-page cluster buffers that we
don't want to allocate in the AIL) which we solved by making transaction
precommit attach the inode cluster buffers to the dirty log item.  Let's
solve the dquot problem in the same way.

So: Make a real precommit handler to read the dquot buffer and attach it
to the log item; pass it to dqflush in the push method; and have the
iodone function detach the buffer once we've flushed everything.  Add a
state flag to the log item to track when a thread has entered the
precommit -> push mechanism to skip the detaching if it turns out that
the dquot is very busy, as we don't hold the dquot lock between log item
commit and AIL push).

Reading and attaching the dquot buffer in the precommit hook is inspired
by the work done for inode cluster buffers some time ago.

Cc: <stable@vger.kernel.org> # v6.12
Fixes: 903edea6c53f09 ("mm: warn about illegal __GFP_NOFAIL usage in a more appropriate location and manner")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c      |  129 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_dquot.h      |    6 ++
 fs/xfs/xfs_dquot_item.c |   39 +++++++++-----
 fs/xfs/xfs_dquot_item.h |    7 +++
 fs/xfs/xfs_qm.c         |    9 ++-
 fs/xfs/xfs_trans_ail.c  |    2 -
 6 files changed, 168 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 4f8fd1fa94dae2..bba1387dfa42dc 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -68,6 +68,30 @@ xfs_dquot_mark_sick(
 	}
 }
 
+/*
+ * Detach the dquot buffer if it's still attached, because we can get called
+ * through dqpurge after a log shutdown.  Caller must hold the dqflock or have
+ * otherwise isolated the dquot.
+ */
+void
+xfs_dquot_detach_buf(
+	struct xfs_dquot	*dqp)
+{
+	struct xfs_dq_logitem	*qlip = &dqp->q_logitem;
+	struct xfs_buf		*bp = NULL;
+
+	spin_lock(&qlip->qli_lock);
+	if (qlip->qli_item.li_buf) {
+		bp = qlip->qli_item.li_buf;
+		qlip->qli_item.li_buf = NULL;
+	}
+	spin_unlock(&qlip->qli_lock);
+	if (bp) {
+		list_del_init(&qlip->qli_item.li_bio_list);
+		xfs_buf_rele(bp);
+	}
+}
+
 /*
  * This is called to free all the memory associated with a dquot
  */
@@ -76,6 +100,7 @@ xfs_qm_dqdestroy(
 	struct xfs_dquot	*dqp)
 {
 	ASSERT(list_empty(&dqp->q_lru));
+	ASSERT(dqp->q_logitem.qli_item.li_buf == NULL);
 
 	kvfree(dqp->q_logitem.qli_item.li_lv_shadow);
 	mutex_destroy(&dqp->q_qlock);
@@ -1140,6 +1165,7 @@ xfs_qm_dqflush_done(
 			container_of(lip, struct xfs_dq_logitem, qli_item);
 	struct xfs_dquot	*dqp = qlip->qli_dquot;
 	struct xfs_ail		*ailp = lip->li_ailp;
+	struct xfs_buf		*bp = NULL;
 	xfs_lsn_t		tail_lsn;
 
 	/*
@@ -1169,6 +1195,19 @@ xfs_qm_dqflush_done(
 	 * Release the dq's flush lock since we're done with it.
 	 */
 	xfs_dqfunlock(dqp);
+
+	/*
+	 * If this dquot hasn't been dirtied since initiating the last dqflush,
+	 * release the buffer reference.
+	 */
+	spin_lock(&qlip->qli_lock);
+	if (!qlip->qli_dirty) {
+		bp = lip->li_buf;
+		lip->li_buf = NULL;
+	}
+	spin_unlock(&qlip->qli_lock);
+	if (bp)
+		xfs_buf_rele(bp);
 }
 
 void
@@ -1191,7 +1230,7 @@ xfs_buf_dquot_io_fail(
 
 	spin_lock(&bp->b_mount->m_ail->ail_lock);
 	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
-		xfs_set_li_failed(lip, bp);
+		set_bit(XFS_LI_FAILED, &lip->li_flags);
 	spin_unlock(&bp->b_mount->m_ail->ail_lock);
 }
 
@@ -1243,6 +1282,7 @@ int
 xfs_dquot_read_buf(
 	struct xfs_trans	*tp,
 	struct xfs_dquot	*dqp,
+	xfs_buf_flags_t		xbf_flags,
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = dqp->q_mount;
@@ -1250,7 +1290,7 @@ xfs_dquot_read_buf(
 	int			error;
 
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, dqp->q_blkno,
-				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
+				   mp->m_quotainfo->qi_dqchunklen, xbf_flags,
 				   &bp, &xfs_dquot_buf_ops);
 	if (error == -EAGAIN)
 		return error;
@@ -1269,6 +1309,77 @@ xfs_dquot_read_buf(
 	return error;
 }
 
+/*
+ * Attach a dquot buffer to this dquot to avoid allocating a buffer during a
+ * dqflush, since dqflush can be called from reclaim context.
+ */
+int
+xfs_dquot_attach_buf(
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*dqp)
+{
+	struct xfs_dq_logitem	*qlip = &dqp->q_logitem;
+	struct xfs_log_item	*lip = &qlip->qli_item;
+	int			error;
+
+	spin_lock(&qlip->qli_lock);
+	if (!lip->li_buf) {
+		struct xfs_buf	*bp = NULL;
+
+		spin_unlock(&qlip->qli_lock);
+		error = xfs_dquot_read_buf(tp, dqp, 0, &bp);
+		if (error)
+			return error;
+
+		/*
+		 * Attach the dquot to the buffer so that the AIL does not have
+		 * to read the dquot buffer to push this item.
+		 */
+		xfs_buf_hold(bp);
+		spin_lock(&qlip->qli_lock);
+		lip->li_buf = bp;
+		xfs_trans_brelse(tp, bp);
+	}
+	qlip->qli_dirty = true;
+	spin_unlock(&qlip->qli_lock);
+
+	return 0;
+}
+
+/*
+ * Get a new reference the dquot buffer attached to this dquot for a dqflush
+ * operation.
+ *
+ * Returns 0 and a NULL bp if none was attached to the dquot; 0 and a locked
+ * bp; or -EAGAIN if the buffer could not be locked.
+ */
+int
+xfs_dquot_use_attached_buf(
+	struct xfs_dquot	*dqp,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_buf		*bp = dqp->q_logitem.qli_item.li_buf;
+
+	/*
+	 * A NULL buffer can happen if the dquot dirty flag was set but the
+	 * filesystem shut down before transaction commit happened.  In that
+	 * case we're not going to flush anyway.
+	 */
+	if (!bp) {
+		ASSERT(xfs_is_shutdown(dqp->q_mount));
+
+		*bpp = NULL;
+		return 0;
+	}
+
+	if (!xfs_buf_trylock(bp))
+		return -EAGAIN;
+
+	xfs_buf_hold(bp);
+	*bpp = bp;
+	return 0;
+}
+
 /*
  * Write a modified dquot to disk.
  * The dquot must be locked and the flush lock too taken by caller.
@@ -1283,7 +1394,8 @@ xfs_qm_dqflush(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = dqp->q_mount;
-	struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
+	struct xfs_dq_logitem	*qlip = &dqp->q_logitem;
+	struct xfs_log_item	*lip = &qlip->qli_item;
 	struct xfs_dqblk	*dqblk;
 	xfs_failaddr_t		fa;
 	int			error;
@@ -1313,8 +1425,15 @@ xfs_qm_dqflush(
 	 */
 	dqp->q_flags &= ~XFS_DQFLAG_DIRTY;
 
-	xfs_trans_ail_copy_lsn(mp->m_ail, &dqp->q_logitem.qli_flush_lsn,
-			&lip->li_lsn);
+	/*
+	 * We hold the dquot lock, so nobody can dirty it while we're
+	 * scheduling the write out.  Clear the dirty-since-flush flag.
+	 */
+	spin_lock(&qlip->qli_lock);
+	qlip->qli_dirty = false;
+	spin_unlock(&qlip->qli_lock);
+
+	xfs_trans_ail_copy_lsn(mp->m_ail, &qlip->qli_flush_lsn, &lip->li_lsn);
 
 	/*
 	 * copy the lsn into the on-disk dquot now while we have the in memory
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index fb9995d2f2331a..aad483fc08b8c3 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -205,7 +205,7 @@ void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
 
 void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
 int		xfs_dquot_read_buf(struct xfs_trans *tp, struct xfs_dquot *dqp,
-				struct xfs_buf **bpp);
+				xfs_buf_flags_t flags, struct xfs_buf **bpp);
 int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf *bp);
 void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
 void		xfs_qm_adjust_dqtimers(struct xfs_dquot *d);
@@ -229,6 +229,10 @@ void		xfs_dqlockn(struct xfs_dqtrx *q);
 
 void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
 
+int xfs_dquot_attach_buf(struct xfs_trans *tp, struct xfs_dquot *dqp);
+int xfs_dquot_use_attached_buf(struct xfs_dquot *dqp, struct xfs_buf **bpp);
+void xfs_dquot_detach_buf(struct xfs_dquot *dqp);
+
 static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 {
 	xfs_dqlock(dqp);
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 56ecc5ed01934d..271b195ebb9326 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -123,8 +123,9 @@ xfs_qm_dquot_logitem_push(
 		__releases(&lip->li_ailp->ail_lock)
 		__acquires(&lip->li_ailp->ail_lock)
 {
-	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
-	struct xfs_buf		*bp = lip->li_buf;
+	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
+	struct xfs_dquot	*dqp = qlip->qli_dquot;
+	struct xfs_buf		*bp;
 	uint			rval = XFS_ITEM_SUCCESS;
 	int			error;
 
@@ -155,11 +156,10 @@ xfs_qm_dquot_logitem_push(
 
 	spin_unlock(&lip->li_ailp->ail_lock);
 
-	error = xfs_dquot_read_buf(NULL, dqp, &bp);
-	if (error) {
-		if (error == -EAGAIN)
-			rval = XFS_ITEM_LOCKED;
+	error = xfs_dquot_use_attached_buf(dqp, &bp);
+	if (error == -EAGAIN) {
 		xfs_dqfunlock(dqp);
+		rval = XFS_ITEM_LOCKED;
 		goto out_relock_ail;
 	}
 
@@ -207,12 +207,10 @@ xfs_qm_dquot_logitem_committing(
 }
 
 #ifdef DEBUG_EXPENSIVE
-static int
-xfs_qm_dquot_logitem_precommit(
-	struct xfs_trans	*tp,
-	struct xfs_log_item	*lip)
+static void
+xfs_qm_dquot_logitem_precommit_check(
+	struct xfs_dquot	*dqp)
 {
-	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_disk_dquot	ddq = { };
 	xfs_failaddr_t		fa;
@@ -228,13 +226,24 @@ xfs_qm_dquot_logitem_precommit(
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		ASSERT(fa == NULL);
 	}
-
-	return 0;
 }
 #else
-# define xfs_qm_dquot_logitem_precommit	NULL
+# define xfs_qm_dquot_logitem_precommit_check(...)	((void)0)
 #endif
 
+static int
+xfs_qm_dquot_logitem_precommit(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_dq_logitem	*qlip = DQUOT_ITEM(lip);
+	struct xfs_dquot	*dqp = qlip->qli_dquot;
+
+	xfs_qm_dquot_logitem_precommit_check(dqp);
+
+	return xfs_dquot_attach_buf(tp, dqp);
+}
+
 static const struct xfs_item_ops xfs_dquot_item_ops = {
 	.iop_size	= xfs_qm_dquot_logitem_size,
 	.iop_precommit	= xfs_qm_dquot_logitem_precommit,
@@ -259,5 +268,7 @@ xfs_qm_dquot_logitem_init(
 
 	xfs_log_item_init(dqp->q_mount, &lp->qli_item, XFS_LI_DQUOT,
 					&xfs_dquot_item_ops);
+	spin_lock_init(&lp->qli_lock);
 	lp->qli_dquot = dqp;
+	lp->qli_dirty = false;
 }
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 794710c2447493..d66e52807d76d5 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -14,6 +14,13 @@ struct xfs_dq_logitem {
 	struct xfs_log_item	qli_item;	/* common portion */
 	struct xfs_dquot	*qli_dquot;	/* dquot ptr */
 	xfs_lsn_t		qli_flush_lsn;	/* lsn at last flush */
+
+	/*
+	 * We use this spinlock to coordinate access to the li_buf pointer in
+	 * the log item and the qli_dirty flag.
+	 */
+	spinlock_t		qli_lock;
+	bool			qli_dirty;	/* dirtied since last flush? */
 };
 
 void xfs_qm_dquot_logitem_init(struct xfs_dquot *dqp);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 4f50d8ce125f57..10fa44165ea16d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -146,7 +146,7 @@ xfs_qm_dqpurge(
 		 * We don't care about getting disk errors here. We need
 		 * to purge this dquot anyway, so we go ahead regardless.
 		 */
-		error = xfs_dquot_read_buf(NULL, dqp, &bp);
+		error = xfs_dquot_read_buf(NULL, dqp, XBF_TRYLOCK, &bp);
 		if (error == -EAGAIN) {
 			xfs_dqfunlock(dqp);
 			dqp->q_flags &= ~XFS_DQFLAG_FREEING;
@@ -166,6 +166,7 @@ xfs_qm_dqpurge(
 		}
 		xfs_dqflock(dqp);
 	}
+	xfs_dquot_detach_buf(dqp);
 
 out_funlock:
 	ASSERT(atomic_read(&dqp->q_pincount) == 0);
@@ -473,7 +474,7 @@ xfs_qm_dquot_isolate(
 		/* we have to drop the LRU lock to flush the dquot */
 		spin_unlock(lru_lock);
 
-		error = xfs_dquot_read_buf(NULL, dqp, &bp);
+		error = xfs_dquot_read_buf(NULL, dqp, XBF_TRYLOCK, &bp);
 		if (error) {
 			xfs_dqfunlock(dqp);
 			goto out_unlock_dirty;
@@ -491,6 +492,8 @@ xfs_qm_dquot_isolate(
 		xfs_buf_relse(bp);
 		goto out_unlock_dirty;
 	}
+
+	xfs_dquot_detach_buf(dqp);
 	xfs_dqfunlock(dqp);
 
 	/*
@@ -1308,7 +1311,7 @@ xfs_qm_flush_one(
 		goto out_unlock;
 	}
 
-	error = xfs_dquot_read_buf(NULL, dqp, &bp);
+	error = xfs_dquot_read_buf(NULL, dqp, XBF_TRYLOCK, &bp);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 8ede9d099d1fea..f56d62dced97b1 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -360,7 +360,7 @@ xfsaild_resubmit_item(
 
 	/* protected by ail_lock */
 	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
-		if (bp->b_flags & _XBF_INODES)
+		if (bp->b_flags & (_XBF_INODES | _XBF_DQUOTS))
 			clear_bit(XFS_LI_FAILED, &lip->li_flags);
 		else
 			xfs_clear_li_failed(lip);


