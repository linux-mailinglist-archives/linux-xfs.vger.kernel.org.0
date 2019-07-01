Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8BB244A26
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 20:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbfFMSDL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 14:03:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57426 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfFMSDL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=eeHexHTa4TG1rq0njSDgTY+OVLmET0A6OEDjsmxpnvg=; b=d3uXt5+hzkbn6RCe3D1j0Um/+
        Z+KC80ER14MsZjnVWP1YDage6oEuIldTCFbhN9GcZ9etTPvEeK74ysTV5SKCAxArD+OEAWY/U2oJ4
        ASGNd+3BB1xoEpeWVP0N3eODZIblrPKMOr8pS2a82rVsZe9UIemnzmXfzozkuVM0FC+AixDeFwL4Y
        9Nvq+3PYoLCuU4bkrMX0CAwnpGtpJwX9SPG068ypRDtmmg75dll6Kt3R6B2ik5Rp+VRYTEhErPSM9
        NooMKT4gJ+6MVtxvMGpRW5ZKRlEoNd89OQcKmz0Oo4QJFUPnno6NY1Pj3WoBXpE3UYR3W7zUUgcab
        LUpvx9taA==;
Received: from [213.208.157.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbU46-0002gI-Go
        for linux-xfs@vger.kernel.org; Thu, 13 Jun 2019 18:03:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/20] xfs: don't require log items to implement optional methods
Date:   Thu, 13 Jun 2019 20:02:43 +0200
Message-Id: <20190613180300.30447-4-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just check if they are present first.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_item.c     | 104 -------------------------------------
 fs/xfs/xfs_buf_item.c      |   8 ---
 fs/xfs/xfs_dquot_item.c    |  98 ----------------------------------
 fs/xfs/xfs_extfree_item.c  | 104 -------------------------------------
 fs/xfs/xfs_icreate_item.c  |  28 ----------
 fs/xfs/xfs_log_cil.c       |   3 +-
 fs/xfs/xfs_refcount_item.c | 104 -------------------------------------
 fs/xfs/xfs_rmap_item.c     | 104 -------------------------------------
 fs/xfs/xfs_trans.c         |  21 +++++---
 fs/xfs/xfs_trans_ail.c     |   8 +++
 10 files changed, 25 insertions(+), 557 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ce45f066995e..8e57df6d5581 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -95,15 +95,6 @@ xfs_bui_item_format(
 			xfs_bui_log_format_sizeof(buip->bui_format.bui_nextents));
 }
 
-/*
- * Pinning has no meaning for an bui item, so just return.
- */
-STATIC void
-xfs_bui_item_pin(
-	struct xfs_log_item	*lip)
-{
-}
-
 /*
  * The unpin operation is the last place an BUI is manipulated in the log. It is
  * either inserted in the AIL or aborted in the event of a log I/O error. In
@@ -122,21 +113,6 @@ xfs_bui_item_unpin(
 	xfs_bui_release(buip);
 }
 
-/*
- * BUI items have no locking or pushing.  However, since BUIs are pulled from
- * the AIL when their corresponding BUDs are committed to disk, their situation
- * is very similar to being pinned.  Return XFS_ITEM_PINNED so that the caller
- * will eventually flush the log.  This should help in getting the BUI out of
- * the AIL.
- */
-STATIC uint
-xfs_bui_item_push(
-	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
-{
-	return XFS_ITEM_PINNED;
-}
-
 /*
  * The BUI has been either committed or aborted if the transaction has been
  * cancelled. If the transaction was cancelled, an BUD isn't going to be
@@ -150,44 +126,14 @@ xfs_bui_item_unlock(
 		xfs_bui_release(BUI_ITEM(lip));
 }
 
-/*
- * The BUI is logged only once and cannot be moved in the log, so simply return
- * the lsn at which it's been logged.
- */
-STATIC xfs_lsn_t
-xfs_bui_item_committed(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-	return lsn;
-}
-
-/*
- * The BUI dependency tracking op doesn't do squat.  It can't because
- * it doesn't know where the free extent is coming from.  The dependency
- * tracking has to be handled by the "enclosing" metadata object.  For
- * example, for inodes, the inode is locked throughout the extent freeing
- * so the dependency should be recorded there.
- */
-STATIC void
-xfs_bui_item_committing(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-}
-
 /*
  * This is the ops vector shared by all bui log items.
  */
 static const struct xfs_item_ops xfs_bui_item_ops = {
 	.iop_size	= xfs_bui_item_size,
 	.iop_format	= xfs_bui_item_format,
-	.iop_pin	= xfs_bui_item_pin,
 	.iop_unpin	= xfs_bui_item_unpin,
 	.iop_unlock	= xfs_bui_item_unlock,
-	.iop_committed	= xfs_bui_item_committed,
-	.iop_push	= xfs_bui_item_push,
-	.iop_committing = xfs_bui_item_committing,
 };
 
 /*
@@ -248,38 +194,6 @@ xfs_bud_item_format(
 			sizeof(struct xfs_bud_log_format));
 }
 
-/*
- * Pinning has no meaning for an bud item, so just return.
- */
-STATIC void
-xfs_bud_item_pin(
-	struct xfs_log_item	*lip)
-{
-}
-
-/*
- * Since pinning has no meaning for an bud item, unpinning does
- * not either.
- */
-STATIC void
-xfs_bud_item_unpin(
-	struct xfs_log_item	*lip,
-	int			remove)
-{
-}
-
-/*
- * There isn't much you can do to push on an bud item.  It is simply stuck
- * waiting for the log to be flushed to disk.
- */
-STATIC uint
-xfs_bud_item_push(
-	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
-{
-	return XFS_ITEM_PINNED;
-}
-
 /*
  * The BUD is either committed or aborted if the transaction is cancelled. If
  * the transaction is cancelled, drop our reference to the BUI and free the
@@ -322,32 +236,14 @@ xfs_bud_item_committed(
 	return (xfs_lsn_t)-1;
 }
 
-/*
- * The BUD dependency tracking op doesn't do squat.  It can't because
- * it doesn't know where the free extent is coming from.  The dependency
- * tracking has to be handled by the "enclosing" metadata object.  For
- * example, for inodes, the inode is locked throughout the extent freeing
- * so the dependency should be recorded there.
- */
-STATIC void
-xfs_bud_item_committing(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-}
-
 /*
  * This is the ops vector shared by all bud log items.
  */
 static const struct xfs_item_ops xfs_bud_item_ops = {
 	.iop_size	= xfs_bud_item_size,
 	.iop_format	= xfs_bud_item_format,
-	.iop_pin	= xfs_bud_item_pin,
-	.iop_unpin	= xfs_bud_item_unpin,
 	.iop_unlock	= xfs_bud_item_unlock,
 	.iop_committed	= xfs_bud_item_committed,
-	.iop_push	= xfs_bud_item_push,
-	.iop_committing = xfs_bud_item_committing,
 };
 
 /*
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index f3d814dc7518..423f1a042ed8 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -671,13 +671,6 @@ xfs_buf_item_committed(
 	return lsn;
 }
 
-STATIC void
-xfs_buf_item_committing(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		commit_lsn)
-{
-}
-
 /*
  * This is the ops vector shared by all buf log items.
  */
@@ -689,7 +682,6 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_unlock	= xfs_buf_item_unlock,
 	.iop_committed	= xfs_buf_item_committed,
 	.iop_push	= xfs_buf_item_push,
-	.iop_committing = xfs_buf_item_committing
 };
 
 STATIC int
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 87b23ae44397..486eea151fdb 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -94,18 +94,6 @@ xfs_qm_dquot_logitem_unpin(
 		wake_up(&dqp->q_pinwait);
 }
 
-STATIC xfs_lsn_t
-xfs_qm_dquot_logitem_committed(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-	/*
-	 * We always re-log the entire dquot when it becomes dirty,
-	 * so, the latest copy _is_ the only one that matters.
-	 */
-	return lsn;
-}
-
 /*
  * This is called to wait for the given dquot to be unpinned.
  * Most of these pin/unpin routines are plagiarized from inode code.
@@ -232,18 +220,6 @@ xfs_qm_dquot_logitem_unlock(
 	xfs_dqunlock(dqp);
 }
 
-/*
- * this needs to stamp an lsn into the dquot, I think.
- * rpc's that look at user dquot's would then have to
- * push on the dependency recorded in the dquot
- */
-STATIC void
-xfs_qm_dquot_logitem_committing(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-}
-
 /*
  * This is the ops vector for dquots
  */
@@ -253,9 +229,7 @@ static const struct xfs_item_ops xfs_dquot_item_ops = {
 	.iop_pin	= xfs_qm_dquot_logitem_pin,
 	.iop_unpin	= xfs_qm_dquot_logitem_unpin,
 	.iop_unlock	= xfs_qm_dquot_logitem_unlock,
-	.iop_committed	= xfs_qm_dquot_logitem_committed,
 	.iop_push	= xfs_qm_dquot_logitem_push,
-	.iop_committing = xfs_qm_dquot_logitem_committing,
 	.iop_error	= xfs_dquot_item_error
 };
 
@@ -314,26 +288,6 @@ xfs_qm_qoff_logitem_format(
 	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_qoff_logitem));
 }
 
-/*
- * Pinning has no meaning for an quotaoff item, so just return.
- */
-STATIC void
-xfs_qm_qoff_logitem_pin(
-	struct xfs_log_item	*lip)
-{
-}
-
-/*
- * Since pinning has no meaning for an quotaoff item, unpinning does
- * not either.
- */
-STATIC void
-xfs_qm_qoff_logitem_unpin(
-	struct xfs_log_item	*lip,
-	int			remove)
-{
-}
-
 /*
  * There isn't much you can do to push a quotaoff item.  It is simply
  * stuck waiting for the log to be flushed to disk.
@@ -346,28 +300,6 @@ xfs_qm_qoff_logitem_push(
 	return XFS_ITEM_LOCKED;
 }
 
-/*
- * Quotaoff items have no locking or pushing, so return failure
- * so that the caller doesn't bother with us.
- */
-STATIC void
-xfs_qm_qoff_logitem_unlock(
-	struct xfs_log_item	*lip)
-{
-}
-
-/*
- * The quotaoff-start-item is logged only once and cannot be moved in the log,
- * so simply return the lsn at which it's been logged.
- */
-STATIC xfs_lsn_t
-xfs_qm_qoff_logitem_committed(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-	return lsn;
-}
-
 STATIC xfs_lsn_t
 xfs_qm_qoffend_logitem_committed(
 	struct xfs_log_item	*lip,
@@ -391,36 +323,11 @@ xfs_qm_qoffend_logitem_committed(
 	return (xfs_lsn_t)-1;
 }
 
-/*
- * XXX rcc - don't know quite what to do with this.  I think we can
- * just ignore it.  The only time that isn't the case is if we allow
- * the client to somehow see that quotas have been turned off in which
- * we can't allow that to get back until the quotaoff hits the disk.
- * So how would that happen?  Also, do we need different routines for
- * quotaoff start and quotaoff end?  I suspect the answer is yes but
- * to be sure, I need to look at the recovery code and see how quota off
- * recovery is handled (do we roll forward or back or do something else).
- * If we roll forwards or backwards, then we need two separate routines,
- * one that does nothing and one that stamps in the lsn that matters
- * (truly makes the quotaoff irrevocable).  If we do something else,
- * then maybe we don't need two.
- */
-STATIC void
-xfs_qm_qoff_logitem_committing(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		commit_lsn)
-{
-}
-
 static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
-	.iop_pin	= xfs_qm_qoff_logitem_pin,
-	.iop_unpin	= xfs_qm_qoff_logitem_unpin,
-	.iop_unlock	= xfs_qm_qoff_logitem_unlock,
 	.iop_committed	= xfs_qm_qoffend_logitem_committed,
 	.iop_push	= xfs_qm_qoff_logitem_push,
-	.iop_committing = xfs_qm_qoff_logitem_committing
 };
 
 /*
@@ -429,12 +336,7 @@ static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
 static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
-	.iop_pin	= xfs_qm_qoff_logitem_pin,
-	.iop_unpin	= xfs_qm_qoff_logitem_unpin,
-	.iop_unlock	= xfs_qm_qoff_logitem_unlock,
-	.iop_committed	= xfs_qm_qoff_logitem_committed,
 	.iop_push	= xfs_qm_qoff_logitem_push,
-	.iop_committing = xfs_qm_qoff_logitem_committing
 };
 
 /*
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 74ddf66f4cfe..655ed0445750 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -106,15 +106,6 @@ xfs_efi_item_format(
 }
 
 
-/*
- * Pinning has no meaning for an efi item, so just return.
- */
-STATIC void
-xfs_efi_item_pin(
-	struct xfs_log_item	*lip)
-{
-}
-
 /*
  * The unpin operation is the last place an EFI is manipulated in the log. It is
  * either inserted in the AIL or aborted in the event of a log I/O error. In
@@ -132,21 +123,6 @@ xfs_efi_item_unpin(
 	xfs_efi_release(efip);
 }
 
-/*
- * Efi items have no locking or pushing.  However, since EFIs are pulled from
- * the AIL when their corresponding EFDs are committed to disk, their situation
- * is very similar to being pinned.  Return XFS_ITEM_PINNED so that the caller
- * will eventually flush the log.  This should help in getting the EFI out of
- * the AIL.
- */
-STATIC uint
-xfs_efi_item_push(
-	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
-{
-	return XFS_ITEM_PINNED;
-}
-
 /*
  * The EFI has been either committed or aborted if the transaction has been
  * cancelled. If the transaction was cancelled, an EFD isn't going to be
@@ -160,44 +136,14 @@ xfs_efi_item_unlock(
 		xfs_efi_release(EFI_ITEM(lip));
 }
 
-/*
- * The EFI is logged only once and cannot be moved in the log, so simply return
- * the lsn at which it's been logged.
- */
-STATIC xfs_lsn_t
-xfs_efi_item_committed(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-	return lsn;
-}
-
-/*
- * The EFI dependency tracking op doesn't do squat.  It can't because
- * it doesn't know where the free extent is coming from.  The dependency
- * tracking has to be handled by the "enclosing" metadata object.  For
- * example, for inodes, the inode is locked throughout the extent freeing
- * so the dependency should be recorded there.
- */
-STATIC void
-xfs_efi_item_committing(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-}
-
 /*
  * This is the ops vector shared by all efi log items.
  */
 static const struct xfs_item_ops xfs_efi_item_ops = {
 	.iop_size	= xfs_efi_item_size,
 	.iop_format	= xfs_efi_item_format,
-	.iop_pin	= xfs_efi_item_pin,
 	.iop_unpin	= xfs_efi_item_unpin,
 	.iop_unlock	= xfs_efi_item_unlock,
-	.iop_committed	= xfs_efi_item_committed,
-	.iop_push	= xfs_efi_item_push,
-	.iop_committing = xfs_efi_item_committing
 };
 
 
@@ -348,38 +294,6 @@ xfs_efd_item_format(
 			xfs_efd_item_sizeof(efdp));
 }
 
-/*
- * Pinning has no meaning for an efd item, so just return.
- */
-STATIC void
-xfs_efd_item_pin(
-	struct xfs_log_item	*lip)
-{
-}
-
-/*
- * Since pinning has no meaning for an efd item, unpinning does
- * not either.
- */
-STATIC void
-xfs_efd_item_unpin(
-	struct xfs_log_item	*lip,
-	int			remove)
-{
-}
-
-/*
- * There isn't much you can do to push on an efd item.  It is simply stuck
- * waiting for the log to be flushed to disk.
- */
-STATIC uint
-xfs_efd_item_push(
-	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
-{
-	return XFS_ITEM_PINNED;
-}
-
 /*
  * The EFD is either committed or aborted if the transaction is cancelled. If
  * the transaction is cancelled, drop our reference to the EFI and free the EFD.
@@ -421,32 +335,14 @@ xfs_efd_item_committed(
 	return (xfs_lsn_t)-1;
 }
 
-/*
- * The EFD dependency tracking op doesn't do squat.  It can't because
- * it doesn't know where the free extent is coming from.  The dependency
- * tracking has to be handled by the "enclosing" metadata object.  For
- * example, for inodes, the inode is locked throughout the extent freeing
- * so the dependency should be recorded there.
- */
-STATIC void
-xfs_efd_item_committing(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-}
-
 /*
  * This is the ops vector shared by all efd log items.
  */
 static const struct xfs_item_ops xfs_efd_item_ops = {
 	.iop_size	= xfs_efd_item_size,
 	.iop_format	= xfs_efd_item_format,
-	.iop_pin	= xfs_efd_item_pin,
-	.iop_unpin	= xfs_efd_item_unpin,
 	.iop_unlock	= xfs_efd_item_unlock,
 	.iop_committed	= xfs_efd_item_committed,
-	.iop_push	= xfs_efd_item_push,
-	.iop_committing = xfs_efd_item_committing
 };
 
 /*
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 8381d34cb102..03c174ff1ab3 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -56,23 +56,6 @@ xfs_icreate_item_format(
 			sizeof(struct xfs_icreate_log));
 }
 
-
-/* Pinning has no meaning for the create item, so just return. */
-STATIC void
-xfs_icreate_item_pin(
-	struct xfs_log_item	*lip)
-{
-}
-
-
-/* pinning has no meaning for the create item, so just return. */
-STATIC void
-xfs_icreate_item_unpin(
-	struct xfs_log_item	*lip,
-	int			remove)
-{
-}
-
 STATIC void
 xfs_icreate_item_unlock(
 	struct xfs_log_item	*lip)
@@ -110,26 +93,15 @@ xfs_icreate_item_push(
 	return XFS_ITEM_SUCCESS;
 }
 
-/* Ordered buffers do the dependency tracking here, so this does nothing. */
-STATIC void
-xfs_icreate_item_committing(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-}
-
 /*
  * This is the ops vector shared by all buf log items.
  */
 static const struct xfs_item_ops xfs_icreate_item_ops = {
 	.iop_size	= xfs_icreate_item_size,
 	.iop_format	= xfs_icreate_item_format,
-	.iop_pin	= xfs_icreate_item_pin,
-	.iop_unpin	= xfs_icreate_item_unpin,
 	.iop_push	= xfs_icreate_item_push,
 	.iop_unlock	= xfs_icreate_item_unlock,
 	.iop_committed	= xfs_icreate_item_committed,
-	.iop_committing = xfs_icreate_item_committing,
 };
 
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 1b54002d3874..49f37905c7a7 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -246,7 +246,8 @@ xfs_cil_prepare_item(
 	 * shadow buffer, so update the the pointer to it appropriately.
 	 */
 	if (!old_lv) {
-		lv->lv_item->li_ops->iop_pin(lv->lv_item);
+		if (lv->lv_item->li_ops->iop_pin)
+			lv->lv_item->li_ops->iop_pin(lv->lv_item);
 		lv->lv_item->li_lv_shadow = NULL;
 	} else if (old_lv != lv) {
 		ASSERT(lv->lv_buf_len != XFS_LOG_VEC_ORDERED);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index fce38b56b962..03a61886fe2a 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -94,15 +94,6 @@ xfs_cui_item_format(
 			xfs_cui_log_format_sizeof(cuip->cui_format.cui_nextents));
 }
 
-/*
- * Pinning has no meaning for an cui item, so just return.
- */
-STATIC void
-xfs_cui_item_pin(
-	struct xfs_log_item	*lip)
-{
-}
-
 /*
  * The unpin operation is the last place an CUI is manipulated in the log. It is
  * either inserted in the AIL or aborted in the event of a log I/O error. In
@@ -121,21 +112,6 @@ xfs_cui_item_unpin(
 	xfs_cui_release(cuip);
 }
 
-/*
- * CUI items have no locking or pushing.  However, since CUIs are pulled from
- * the AIL when their corresponding CUDs are committed to disk, their situation
- * is very similar to being pinned.  Return XFS_ITEM_PINNED so that the caller
- * will eventually flush the log.  This should help in getting the CUI out of
- * the AIL.
- */
-STATIC uint
-xfs_cui_item_push(
-	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
-{
-	return XFS_ITEM_PINNED;
-}
-
 /*
  * The CUI has been either committed or aborted if the transaction has been
  * cancelled. If the transaction was cancelled, an CUD isn't going to be
@@ -149,44 +125,14 @@ xfs_cui_item_unlock(
 		xfs_cui_release(CUI_ITEM(lip));
 }
 
-/*
- * The CUI is logged only once and cannot be moved in the log, so simply return
- * the lsn at which it's been logged.
- */
-STATIC xfs_lsn_t
-xfs_cui_item_committed(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-	return lsn;
-}
-
-/*
- * The CUI dependency tracking op doesn't do squat.  It can't because
- * it doesn't know where the free extent is coming from.  The dependency
- * tracking has to be handled by the "enclosing" metadata object.  For
- * example, for inodes, the inode is locked throughout the extent freeing
- * so the dependency should be recorded there.
- */
-STATIC void
-xfs_cui_item_committing(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-}
-
 /*
  * This is the ops vector shared by all cui log items.
  */
 static const struct xfs_item_ops xfs_cui_item_ops = {
 	.iop_size	= xfs_cui_item_size,
 	.iop_format	= xfs_cui_item_format,
-	.iop_pin	= xfs_cui_item_pin,
 	.iop_unpin	= xfs_cui_item_unpin,
 	.iop_unlock	= xfs_cui_item_unlock,
-	.iop_committed	= xfs_cui_item_committed,
-	.iop_push	= xfs_cui_item_push,
-	.iop_committing = xfs_cui_item_committing,
 };
 
 /*
@@ -253,38 +199,6 @@ xfs_cud_item_format(
 			sizeof(struct xfs_cud_log_format));
 }
 
-/*
- * Pinning has no meaning for an cud item, so just return.
- */
-STATIC void
-xfs_cud_item_pin(
-	struct xfs_log_item	*lip)
-{
-}
-
-/*
- * Since pinning has no meaning for an cud item, unpinning does
- * not either.
- */
-STATIC void
-xfs_cud_item_unpin(
-	struct xfs_log_item	*lip,
-	int			remove)
-{
-}
-
-/*
- * There isn't much you can do to push on an cud item.  It is simply stuck
- * waiting for the log to be flushed to disk.
- */
-STATIC uint
-xfs_cud_item_push(
-	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
-{
-	return XFS_ITEM_PINNED;
-}
-
 /*
  * The CUD is either committed or aborted if the transaction is cancelled. If
  * the transaction is cancelled, drop our reference to the CUI and free the
@@ -327,32 +241,14 @@ xfs_cud_item_committed(
 	return (xfs_lsn_t)-1;
 }
 
-/*
- * The CUD dependency tracking op doesn't do squat.  It can't because
- * it doesn't know where the free extent is coming from.  The dependency
- * tracking has to be handled by the "enclosing" metadata object.  For
- * example, for inodes, the inode is locked throughout the extent freeing
- * so the dependency should be recorded there.
- */
-STATIC void
-xfs_cud_item_committing(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-}
-
 /*
  * This is the ops vector shared by all cud log items.
  */
 static const struct xfs_item_ops xfs_cud_item_ops = {
 	.iop_size	= xfs_cud_item_size,
 	.iop_format	= xfs_cud_item_format,
-	.iop_pin	= xfs_cud_item_pin,
-	.iop_unpin	= xfs_cud_item_unpin,
 	.iop_unlock	= xfs_cud_item_unlock,
 	.iop_committed	= xfs_cud_item_committed,
-	.iop_push	= xfs_cud_item_push,
-	.iop_committing = xfs_cud_item_committing,
 };
 
 /*
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 127dc9c32a54..df9f2505c5f3 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -93,15 +93,6 @@ xfs_rui_item_format(
 			xfs_rui_log_format_sizeof(ruip->rui_format.rui_nextents));
 }
 
-/*
- * Pinning has no meaning for an rui item, so just return.
- */
-STATIC void
-xfs_rui_item_pin(
-	struct xfs_log_item	*lip)
-{
-}
-
 /*
  * The unpin operation is the last place an RUI is manipulated in the log. It is
  * either inserted in the AIL or aborted in the event of a log I/O error. In
@@ -120,21 +111,6 @@ xfs_rui_item_unpin(
 	xfs_rui_release(ruip);
 }
 
-/*
- * RUI items have no locking or pushing.  However, since RUIs are pulled from
- * the AIL when their corresponding RUDs are committed to disk, their situation
- * is very similar to being pinned.  Return XFS_ITEM_PINNED so that the caller
- * will eventually flush the log.  This should help in getting the RUI out of
- * the AIL.
- */
-STATIC uint
-xfs_rui_item_push(
-	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
-{
-	return XFS_ITEM_PINNED;
-}
-
 /*
  * The RUI has been either committed or aborted if the transaction has been
  * cancelled. If the transaction was cancelled, an RUD isn't going to be
@@ -148,44 +124,14 @@ xfs_rui_item_unlock(
 		xfs_rui_release(RUI_ITEM(lip));
 }
 
-/*
- * The RUI is logged only once and cannot be moved in the log, so simply return
- * the lsn at which it's been logged.
- */
-STATIC xfs_lsn_t
-xfs_rui_item_committed(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-	return lsn;
-}
-
-/*
- * The RUI dependency tracking op doesn't do squat.  It can't because
- * it doesn't know where the free extent is coming from.  The dependency
- * tracking has to be handled by the "enclosing" metadata object.  For
- * example, for inodes, the inode is locked throughout the extent freeing
- * so the dependency should be recorded there.
- */
-STATIC void
-xfs_rui_item_committing(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-}
-
 /*
  * This is the ops vector shared by all rui log items.
  */
 static const struct xfs_item_ops xfs_rui_item_ops = {
 	.iop_size	= xfs_rui_item_size,
 	.iop_format	= xfs_rui_item_format,
-	.iop_pin	= xfs_rui_item_pin,
 	.iop_unpin	= xfs_rui_item_unpin,
 	.iop_unlock	= xfs_rui_item_unlock,
-	.iop_committed	= xfs_rui_item_committed,
-	.iop_push	= xfs_rui_item_push,
-	.iop_committing = xfs_rui_item_committing,
 };
 
 /*
@@ -274,38 +220,6 @@ xfs_rud_item_format(
 			sizeof(struct xfs_rud_log_format));
 }
 
-/*
- * Pinning has no meaning for an rud item, so just return.
- */
-STATIC void
-xfs_rud_item_pin(
-	struct xfs_log_item	*lip)
-{
-}
-
-/*
- * Since pinning has no meaning for an rud item, unpinning does
- * not either.
- */
-STATIC void
-xfs_rud_item_unpin(
-	struct xfs_log_item	*lip,
-	int			remove)
-{
-}
-
-/*
- * There isn't much you can do to push on an rud item.  It is simply stuck
- * waiting for the log to be flushed to disk.
- */
-STATIC uint
-xfs_rud_item_push(
-	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
-{
-	return XFS_ITEM_PINNED;
-}
-
 /*
  * The RUD is either committed or aborted if the transaction is cancelled. If
  * the transaction is cancelled, drop our reference to the RUI and free the
@@ -348,32 +262,14 @@ xfs_rud_item_committed(
 	return (xfs_lsn_t)-1;
 }
 
-/*
- * The RUD dependency tracking op doesn't do squat.  It can't because
- * it doesn't know where the free extent is coming from.  The dependency
- * tracking has to be handled by the "enclosing" metadata object.  For
- * example, for inodes, the inode is locked throughout the extent freeing
- * so the dependency should be recorded there.
- */
-STATIC void
-xfs_rud_item_committing(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-}
-
 /*
  * This is the ops vector shared by all rud log items.
  */
 static const struct xfs_item_ops xfs_rud_item_ops = {
 	.iop_size	= xfs_rud_item_size,
 	.iop_format	= xfs_rud_item_format,
-	.iop_pin	= xfs_rud_item_pin,
-	.iop_unpin	= xfs_rud_item_unpin,
 	.iop_unlock	= xfs_rud_item_unlock,
 	.iop_committed	= xfs_rud_item_committed,
-	.iop_push	= xfs_rud_item_push,
-	.iop_committing = xfs_rud_item_committing,
 };
 
 /*
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index fa62d40d7ad9..d4fbde493de8 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -779,11 +779,14 @@ xfs_trans_free_items(
 
 	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
 		xfs_trans_del_item(lip);
-		if (commit_lsn != NULLCOMMITLSN)
+		if (commit_lsn != NULLCOMMITLSN &&
+		    lip->li_ops->iop_committing)
 			lip->li_ops->iop_committing(lip, commit_lsn);
 		if (abort)
 			set_bit(XFS_LI_ABORTED, &lip->li_flags);
-		lip->li_ops->iop_unlock(lip);
+
+		if (lip->li_ops->iop_unlock)
+			lip->li_ops->iop_unlock(lip);
 	}
 }
 
@@ -804,7 +807,8 @@ xfs_log_item_batch_insert(
 	for (i = 0; i < nr_items; i++) {
 		struct xfs_log_item *lip = log_items[i];
 
-		lip->li_ops->iop_unpin(lip, 0);
+		if (lip->li_ops->iop_unpin)
+			lip->li_ops->iop_unpin(lip, 0);
 	}
 }
 
@@ -852,7 +856,10 @@ xfs_trans_committed_bulk(
 
 		if (aborted)
 			set_bit(XFS_LI_ABORTED, &lip->li_flags);
-		item_lsn = lip->li_ops->iop_committed(lip, commit_lsn);
+		if (lip->li_ops->iop_committed)
+			item_lsn = lip->li_ops->iop_committed(lip, commit_lsn);
+		else
+			item_lsn = commit_lsn;
 
 		/* item_lsn of -1 means the item needs no further processing */
 		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
@@ -864,7 +871,8 @@ xfs_trans_committed_bulk(
 		 */
 		if (aborted) {
 			ASSERT(XFS_FORCED_SHUTDOWN(ailp->ail_mount));
-			lip->li_ops->iop_unpin(lip, 1);
+			if (lip->li_ops->iop_unpin)
+				lip->li_ops->iop_unpin(lip, 1);
 			continue;
 		}
 
@@ -882,7 +890,8 @@ xfs_trans_committed_bulk(
 				xfs_trans_ail_update(ailp, lip, item_lsn);
 			else
 				spin_unlock(&ailp->ail_lock);
-			lip->li_ops->iop_unpin(lip, 0);
+			if (lip->li_ops->iop_unpin)
+				lip->li_ops->iop_unpin(lip, 0);
 			continue;
 		}
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index d3a4e89bf4a0..a3ea5d25b0f9 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -347,6 +347,14 @@ xfsaild_push_item(
 	if (XFS_TEST_ERROR(false, ailp->ail_mount, XFS_ERRTAG_LOG_ITEM_PIN))
 		return XFS_ITEM_PINNED;
 
+	/*
+	 * Consider the item pinned if a push callback is not defined so the
+	 * caller will force the log. This should only happen for intent items
+	 * as they are unpinned once the associated done item is committed to
+	 * the on-disk log.
+	 */
+	if (!lip->li_ops->iop_push)
+		return XFS_ITEM_PINNED;
 	return lip->li_ops->iop_push(lip, &ailp->ail_buf_list);
 }
 
-- 
2.20.1

