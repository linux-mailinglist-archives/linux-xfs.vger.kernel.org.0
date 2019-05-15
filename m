Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3DDA1E9E0
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 10:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfEOILa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 04:11:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56796 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfEOILa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 04:11:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nKTSKxsMkrxejfdmSaxvg9FViuSocI7cNNDXh/D82jo=; b=GSCggvH76R11CLIoLjtxf/v+w
        5HxzfgbafnWTWcno+rnPHbHbK4XtdhkFQUoKsPslgEdtsdbqjK1q8R5SNmkIzT+w5zx/aNVyVVfYs
        g8NaAx7FF1QJJ88jzMVlS2q348Cg2VZSCGpdJRd1oa2urVu+Vg+7jZN0KEFgPdW0Cre6UWCmSPNeK
        7jnmNG2AkeRzqbY44qDMfVaXVCDDYVR5izWW83nt3wwle9Rbzi91h9sXuxw2ZsCWBcL4IojhoTiS1
        5GehbHVVCYa5KU6ORz6metcB4rfA4oXG+1UMVXzLbOMxMbewnUkseSZeo7SV2ndn87aYYTj6mJWbb
        xGZrjyYdA==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQp0c-0004y9-0D
        for linux-xfs@vger.kernel.org; Wed, 15 May 2019 08:11:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: remove the debug-only q_transp field from struct xfs_dquot
Date:   Wed, 15 May 2019 10:10:45 +0200
Message-Id: <20190515081045.3343-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The field is only used for a few assertations.  Shrink the dqout
structure instead, similarly to what commit f3ca87389dbf
("xfs: remove i_transp") did for the xfs_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.h       |  1 -
 fs/xfs/xfs_dquot_item.c  |  5 -----
 fs/xfs/xfs_trans_dquot.c | 10 ----------
 3 files changed, 16 deletions(-)

diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 64bd8640f6e8..4fe85709d55d 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -34,7 +34,6 @@ typedef struct xfs_dquot {
 	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
 	struct list_head q_lru;		/* global free list of dquots */
 	struct xfs_mount*q_mount;	/* filesystem this relates to */
-	struct xfs_trans*q_transp;	/* trans this belongs to currently */
 	uint		 q_nrefs;	/* # active refs from inodes */
 	xfs_daddr_t	 q_blkno;	/* blkno of dquot buffer */
 	int		 q_bufoffset;	/* off of dq in buffer (# dquots) */
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 7dedd17c4813..87b23ae44397 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -223,11 +223,6 @@ xfs_qm_dquot_logitem_unlock(
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
-	/*
-	 * Clear the transaction pointer in the dquot
-	 */
-	dqp->q_transp = NULL;
-
 	/*
 	 * dquots are never 'held' from getting unlocked at the end of
 	 * a transaction.  Their locking and unlocking is hidden inside the
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index cd664a03613f..ba3de1f03b98 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -29,7 +29,6 @@ xfs_trans_dqjoin(
 	xfs_trans_t	*tp,
 	xfs_dquot_t	*dqp)
 {
-	ASSERT(dqp->q_transp != tp);
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 	ASSERT(dqp->q_logitem.qli_dquot == dqp);
 
@@ -37,15 +36,8 @@ xfs_trans_dqjoin(
 	 * Get a log_item_desc to point at the new item.
 	 */
 	xfs_trans_add_item(tp, &dqp->q_logitem.qli_item);
-
-	/*
-	 * Initialize d_transp so we can later determine if this dquot is
-	 * associated with this transaction.
-	 */
-	dqp->q_transp = tp;
 }
 
-
 /*
  * This is called to mark the dquot as needing
  * to be logged when the transaction is committed.  The dquot must
@@ -61,7 +53,6 @@ xfs_trans_log_dquot(
 	xfs_trans_t	*tp,
 	xfs_dquot_t	*dqp)
 {
-	ASSERT(dqp->q_transp == tp);
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
 	tp->t_flags |= XFS_TRANS_DIRTY;
@@ -347,7 +338,6 @@ xfs_trans_apply_dquot_deltas(
 				break;
 
 			ASSERT(XFS_DQ_IS_LOCKED(dqp));
-			ASSERT(dqp->q_transp == tp);
 
 			/*
 			 * adjust the actual number of blocks used
-- 
2.20.1

