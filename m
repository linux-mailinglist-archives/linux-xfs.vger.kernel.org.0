Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D537D3E0C4E
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Aug 2021 04:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbhHECHs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Aug 2021 22:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238146AbhHECHs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 22:07:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3C7661073;
        Thu,  5 Aug 2021 02:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628129254;
        bh=1dux238x4nCpTc/Ks1zNtPWbwcksk/ApfN3YPgywvcA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UHByeaaEf9Rg2/AmbThiqKM7V6/M6EPpB0wsk7gMprHw5DKnx9jcyCPjdBbI7S/57
         Zb6vCiykLw1w2D3pVFC14z1NfEg26rXRHW6MXpG8EOCLklcZNF48gN+WtHcbpDW61B
         j3IXISx6Y4KQyXRi1e5KhQFil0OOrXvDg8G6JGRGwdBo7Qa8jok9yz7Wiu8WzFrugA
         wAygiP/KZEYRNnVEO22a5K7lJP6IBt5/zONq9js+f8sPHN+kDIX/bN4VTvo/2Rqx4t
         dgvByU2Dy+OuKjB2MfRH9ziIb8xVl0oRago7Y72n/HsaNT3ghBv76ByTxSWwudzcdt
         r2ctJN8f1CVKA==
Subject: [PATCH 13/14] xfs: avoid buffer deadlocks when walking fs inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 04 Aug 2021 19:07:34 -0700
Message-ID: <162812925438.2589546.14046198555202903406.stgit@magnolia>
In-Reply-To: <162812918259.2589546.16599271324044986858.stgit@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're servicing an INUMBERS or BULKSTAT request or running
quotacheck, grab an empty transaction so that we can use its inherent
recursive buffer locking abilities to detect inode btree cycles without
hitting ABBA buffer deadlocks.  This patch requires the deferred inode
inactivation patchset because xfs_irele cannot directly call
xfs_inactive when the iwalk itself has an (empty) transaction.

Found by fuzzing an inode btree pointer to introduce a cycle into the
tree (xfs/365).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_itable.c |   42 +++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_iwalk.c  |   33 ++++++++++++++++++++++++++++-----
 2 files changed, 65 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f331975a16de..84c17a9f9869 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -19,6 +19,7 @@
 #include "xfs_error.h"
 #include "xfs_icache.h"
 #include "xfs_health.h"
+#include "xfs_trans.h"
 
 /*
  * Bulk Stat
@@ -163,6 +164,7 @@ xfs_bulkstat_one(
 		.formatter	= formatter,
 		.breq		= breq,
 	};
+	struct xfs_trans	*tp;
 	int			error;
 
 	if (breq->mnt_userns != &init_user_ns) {
@@ -178,9 +180,18 @@ xfs_bulkstat_one(
 	if (!bc.buf)
 		return -ENOMEM;
 
-	error = xfs_bulkstat_one_int(breq->mp, breq->mnt_userns, NULL,
-				     breq->startino, &bc);
+	/*
+	 * Grab an empty transaction so that we can use its recursive buffer
+	 * locking abilities to detect cycles in the inobt without deadlocking.
+	 */
+	error = xfs_trans_alloc_empty(breq->mp, &tp);
+	if (error)
+		goto out;
 
+	error = xfs_bulkstat_one_int(breq->mp, breq->mnt_userns, tp,
+			breq->startino, &bc);
+	xfs_trans_cancel(tp);
+out:
 	kmem_free(bc.buf);
 
 	/*
@@ -244,6 +255,7 @@ xfs_bulkstat(
 		.formatter	= formatter,
 		.breq		= breq,
 	};
+	struct xfs_trans	*tp;
 	int			error;
 
 	if (breq->mnt_userns != &init_user_ns) {
@@ -259,9 +271,18 @@ xfs_bulkstat(
 	if (!bc.buf)
 		return -ENOMEM;
 
-	error = xfs_iwalk(breq->mp, NULL, breq->startino, breq->flags,
+	/*
+	 * Grab an empty transaction so that we can use its recursive buffer
+	 * locking abilities to detect cycles in the inobt without deadlocking.
+	 */
+	error = xfs_trans_alloc_empty(breq->mp, &tp);
+	if (error)
+		goto out;
+
+	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->flags,
 			xfs_bulkstat_iwalk, breq->icount, &bc);
-
+	xfs_trans_cancel(tp);
+out:
 	kmem_free(bc.buf);
 
 	/*
@@ -374,13 +395,24 @@ xfs_inumbers(
 		.formatter	= formatter,
 		.breq		= breq,
 	};
+	struct xfs_trans	*tp;
 	int			error = 0;
 
 	if (xfs_bulkstat_already_done(breq->mp, breq->startino))
 		return 0;
 
-	error = xfs_inobt_walk(breq->mp, NULL, breq->startino, breq->flags,
+	/*
+	 * Grab an empty transaction so that we can use its recursive buffer
+	 * locking abilities to detect cycles in the inobt without deadlocking.
+	 */
+	error = xfs_trans_alloc_empty(breq->mp, &tp);
+	if (error)
+		goto out;
+
+	error = xfs_inobt_walk(breq->mp, tp, breq->startino, breq->flags,
 			xfs_inumbers_walk, breq->icount, &ic);
+	xfs_trans_cancel(tp);
+out:
 
 	/*
 	 * We found some inode groups, so clear the error status and return
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 917d51eefee3..7558486f4937 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -83,6 +83,9 @@ struct xfs_iwalk_ag {
 
 	/* Skip empty inobt records? */
 	unsigned int			skip_empty:1;
+
+	/* Drop the (hopefully empty) transaction when calling iwalk_fn. */
+	unsigned int			drop_trans:1;
 };
 
 /*
@@ -352,7 +355,6 @@ xfs_iwalk_run_callbacks(
 	int				*has_more)
 {
 	struct xfs_mount		*mp = iwag->mp;
-	struct xfs_trans		*tp = iwag->tp;
 	struct xfs_inobt_rec_incore	*irec;
 	xfs_agino_t			next_agino;
 	int				error;
@@ -362,10 +364,15 @@ xfs_iwalk_run_callbacks(
 	ASSERT(iwag->nr_recs > 0);
 
 	/* Delete cursor but remember the last record we cached... */
-	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
+	xfs_iwalk_del_inobt(iwag->tp, curpp, agi_bpp, 0);
 	irec = &iwag->recs[iwag->nr_recs - 1];
 	ASSERT(next_agino >= irec->ir_startino + XFS_INODES_PER_CHUNK);
 
+	if (iwag->drop_trans) {
+		xfs_trans_cancel(iwag->tp);
+		iwag->tp = NULL;
+	}
+
 	error = xfs_iwalk_ag_recs(iwag);
 	if (error)
 		return error;
@@ -376,8 +383,15 @@ xfs_iwalk_run_callbacks(
 	if (!has_more)
 		return 0;
 
+	if (iwag->drop_trans) {
+		error = xfs_trans_alloc_empty(mp, &iwag->tp);
+		if (error)
+			return error;
+	}
+
 	/* ...and recreate the cursor just past where we left off. */
-	error = xfs_inobt_cur(mp, tp, iwag->pag, XFS_BTNUM_INO, curpp, agi_bpp);
+	error = xfs_inobt_cur(mp, iwag->tp, iwag->pag, XFS_BTNUM_INO, curpp,
+			agi_bpp);
 	if (error)
 		return error;
 
@@ -390,7 +404,6 @@ xfs_iwalk_ag(
 	struct xfs_iwalk_ag		*iwag)
 {
 	struct xfs_mount		*mp = iwag->mp;
-	struct xfs_trans		*tp = iwag->tp;
 	struct xfs_perag		*pag = iwag->pag;
 	struct xfs_buf			*agi_bp = NULL;
 	struct xfs_btree_cur		*cur = NULL;
@@ -469,7 +482,7 @@ xfs_iwalk_ag(
 	error = xfs_iwalk_run_callbacks(iwag, &cur, &agi_bp, &has_more);
 
 out:
-	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
+	xfs_iwalk_del_inobt(iwag->tp, &cur, &agi_bp, error);
 	return error;
 }
 
@@ -599,8 +612,18 @@ xfs_iwalk_ag_work(
 	error = xfs_iwalk_alloc(iwag);
 	if (error)
 		goto out;
+	/*
+	 * Grab an empty transaction so that we can use its recursive buffer
+	 * locking abilities to detect cycles in the inobt without deadlocking.
+	 */
+	error = xfs_trans_alloc_empty(mp, &iwag->tp);
+	if (error)
+		goto out;
+	iwag->drop_trans = 1;
 
 	error = xfs_iwalk_ag(iwag);
+	if (iwag->tp)
+		xfs_trans_cancel(iwag->tp);
 	xfs_iwalk_free(iwag);
 out:
 	xfs_perag_put(iwag->pag);

