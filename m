Return-Path: <linux-xfs+bounces-479-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B0C807E5D
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 03:24:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00C9A2825F7
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 02:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B6231FBA;
	Thu,  7 Dec 2023 02:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W/XqjTKl"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14871C3C
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7401C433CA;
	Thu,  7 Dec 2023 02:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701915847;
	bh=wGYVwT2MMSiXPlVdVhDOXx5zNH7GfLsL7z/fFj9d0Qs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=W/XqjTKlfXbPsGcoZdofc2OKnQhgVHRycopnHKQp3sPOCKUyb+mzx/KSd5OD/57Py
	 inbhoPRa5ja6D6jZOrjlMsqS8LgQ1iWBTLIzQXmDKDEcU+0ptCPt0YAfGQF/N3AYxr
	 FK8S+c2dd5qj5Sqe9evAxZsFF6jmkfgoW9Lv1ZQrVEpno2Uv7Prc+BBQhHyQ98kg2Y
	 FuPKE4iRRYRFKL0/eU8e6V7zj/NP5UC/Mik0oYi/WlVSXvl7c+vx4FwaA8eOpLEDe4
	 Tz1CcwWbo6D54HR1XwXEZLyem62NiFBuszoE/gpqeF3W8L3o2iYkeHLjy/pJHQavnn
	 J/f1OH4C6XHtg==
Date: Wed, 06 Dec 2023 18:24:07 -0800
Subject: [PATCH 4/8] xfs: transfer recovered intent item ownership in
 ->iop_recover
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, leo.lilong@huawei.com, hch@lst.de,
 djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191561955.1133151.6481557252973662769.stgit@frogsfrogsfrogs>
In-Reply-To: <170191561877.1133151.2814117942066315211.stgit@frogsfrogsfrogs>
References: <170191561877.1133151.2814117942066315211.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we pass the xfs_defer_pending object into the intent item
recovery functions, we know exactly when ownership of the sole refcount
passes from the recovery context to the intent done item.  At that
point, we need to null out dfp_intent so that the recovery mechanism
won't release it.  This should fix the UAF problem reported by Long Li.

Note that we still want to recreate the full deferred work state.  That
will be addressed in the next patches.

Fixes: 2e76f188fd90 ("xfs: cancel intents immediately if process_intents fails")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_recover.h |    2 ++
 fs/xfs/xfs_attr_item.c          |    1 +
 fs/xfs/xfs_bmap_item.c          |    2 ++
 fs/xfs/xfs_extfree_item.c       |    2 ++
 fs/xfs/xfs_log_recover.c        |   19 ++++++++++++-------
 fs/xfs/xfs_refcount_item.c      |    1 +
 fs/xfs/xfs_rmap_item.c          |    2 ++
 7 files changed, 22 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 271a4ce7375c..13583df9f239 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -155,5 +155,7 @@ xlog_recover_resv(const struct xfs_trans_res *r)
 
 void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
 		xfs_lsn_t lsn, unsigned int dfp_type);
+void xlog_recover_transfer_intent(struct xfs_trans *tp,
+		struct xfs_defer_pending *dfp);
 
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 6119a7a480a0..82775e9537df 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -632,6 +632,7 @@ xfs_attri_item_recover(
 
 	args->trans = tp;
 	done_item = xfs_trans_get_attrd(tp, attrip);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 3ef55de370b5..b6d63b8bdad5 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -524,6 +524,8 @@ xfs_bui_item_recover(
 		goto err_rele;
 
 	budp = xfs_trans_get_bud(tp, buip);
+	xlog_recover_transfer_intent(tp, dfp);
+
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a8245c5ffe49..c9908fb33765 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -689,7 +689,9 @@ xfs_efi_item_recover(
 	error = xfs_trans_alloc(mp, &resv, 0, 0, 0, &tp);
 	if (error)
 		return error;
+
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
 		struct xfs_extent_free_item	fake = {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ff768217f2c7..cc14cd1c2282 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2590,13 +2590,6 @@ xlog_recover_process_intents(
 			break;
 		}
 
-		/*
-		 * XXX: @lip could have been freed, so detach the log item from
-		 * the pending item before freeing the pending item.  This does
-		 * not fix the existing UAF bug that occurs if ->iop_recover
-		 * fails after creating the intent done item.
-		 */
-		dfp->dfp_intent = NULL;
 		xfs_defer_cancel_recovery(log->l_mp, dfp);
 	}
 	if (error)
@@ -2630,6 +2623,18 @@ xlog_recover_cancel_intents(
 	}
 }
 
+/*
+ * Transfer ownership of the recovered log intent item to the recovery
+ * transaction.
+ */
+void
+xlog_recover_transfer_intent(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	dfp->dfp_intent = NULL;
+}
+
 /*
  * This routine performs a transaction to null out a bad inode pointer
  * in an agi unlinked inode hash bucket.
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 3456201aa3e6..f1b259223802 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -523,6 +523,7 @@ xfs_cui_item_recover(
 		return error;
 
 	cudp = xfs_trans_get_cud(tp, cuip);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
 		struct xfs_refcount_intent	fake = { };
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index dfd5a3e4b1fb..5e8a02d2b045 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -537,7 +537,9 @@ xfs_rui_item_recover(
 			XFS_TRANS_RESERVE, &tp);
 	if (error)
 		return error;
+
 	rudp = xfs_trans_get_rud(tp, ruip);
+	xlog_recover_transfer_intent(tp, dfp);
 
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
 		struct xfs_rmap_intent	fake = { };


