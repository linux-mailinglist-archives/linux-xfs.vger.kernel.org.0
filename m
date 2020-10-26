Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC8629A07C
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Oct 2020 01:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439445AbgJ0A3j (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Oct 2020 20:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409772AbgJZXwd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Oct 2020 19:52:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FA2422202;
        Mon, 26 Oct 2020 23:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756353;
        bh=w5ZJi5QGxS2+TMZ1CAzT1UNEjZtDnZzcqneDZhF1uDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=De1LQ7eEKjwFJNOqTFfqSPfHkTnTqKUJRkIKc34crsYk/ETvE4FXjaR9WrPLF3AYK
         x4vvRoB8476EprM1BZR+73OjuAaRNEH40cJYAA5v1//OD/KuyQ1CINCzTOhMJdo636
         HNUxXTeqM3fKgznwDm9nWxCo+Y3oHTjySH5b5yyA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 023/132] xfs: log new intent items created as part of finishing recovered intent items
Date:   Mon, 26 Oct 2020 19:50:15 -0400
Message-Id: <20201026235205.1023962-23-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit 93293bcbde93567efaf4e6bcd58cad270e1fcbf5 ]

During a code inspection, I found a serious bug in the log intent item
recovery code when an intent item cannot complete all the work and
decides to requeue itself to get that done.  When this happens, the
item recovery creates a new incore deferred op representing the
remaining work and attaches it to the transaction that it allocated.  At
the end of _item_recover, it moves the entire chain of deferred ops to
the dummy parent_tp that xlog_recover_process_intents passed to it, but
fail to log a new intent item for the remaining work before committing
the transaction for the single unit of work.

xlog_finish_defer_ops logs those new intent items once recovery has
finished dealing with the intent items that it recovered, but this isn't
sufficient.  If the log is forced to disk after a recovered log item
decides to requeue itself and the system goes down before we call
xlog_finish_defer_ops, the second log recovery will never see the new
intent item and therefore has no idea that there was more work to do.
It will finish recovery leaving the filesystem in a corrupted state.

The same logic applies to /any/ deferred ops added during intent item
recovery, not just the one handling the remaining work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c  | 26 ++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_defer.h  |  6 ++++++
 fs/xfs/xfs_bmap_item.c     |  2 +-
 fs/xfs/xfs_refcount_item.c |  2 +-
 4 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index d8f586256add7..29e9762f3b77c 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -186,8 +186,9 @@ xfs_defer_create_intent(
 {
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
 
-	dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
-			dfp->dfp_count, sort);
+	if (!dfp->dfp_intent)
+		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
+						     dfp->dfp_count, sort);
 }
 
 /*
@@ -390,6 +391,7 @@ xfs_defer_finish_one(
 			list_add(li, &dfp->dfp_work);
 			dfp->dfp_count++;
 			dfp->dfp_done = NULL;
+			dfp->dfp_intent = NULL;
 			xfs_defer_create_intent(tp, dfp, false);
 		}
 
@@ -552,3 +554,23 @@ xfs_defer_move(
 
 	xfs_defer_reset(stp);
 }
+
+/*
+ * Prepare a chain of fresh deferred ops work items to be completed later.  Log
+ * recovery requires the ability to put off until later the actual finishing
+ * work so that it can process unfinished items recovered from the log in
+ * correct order.
+ *
+ * Create and log intent items for all the work that we're capturing so that we
+ * can be assured that the items will get replayed if the system goes down
+ * before log recovery gets a chance to finish the work it put off.  Then we
+ * move the chain from stp to dtp.
+ */
+void
+xfs_defer_capture(
+	struct xfs_trans	*dtp,
+	struct xfs_trans	*stp)
+{
+	xfs_defer_create_intents(stp);
+	xfs_defer_move(dtp, stp);
+}
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 6b2ca580f2b06..3164199162b61 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -63,4 +63,10 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 
+/*
+ * Functions to capture a chain of deferred operations and continue them later.
+ * This doesn't normally happen except log recovery.
+ */
+void xfs_defer_capture(struct xfs_trans *dtp, struct xfs_trans *stp);
+
 #endif /* __XFS_DEFER_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 6736c5ab188f2..98e18472e28e6 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -534,7 +534,7 @@ xfs_bui_item_recover(
 		xfs_bmap_unmap_extent(tp, ip, &irec);
 	}
 
-	xfs_defer_move(parent_tp, tp);
+	xfs_defer_capture(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index c81639891e298..1b2a58b305f25 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -554,7 +554,7 @@ xfs_cui_item_recover(
 	}
 
 	xfs_refcount_finish_one_cleanup(tp, rcur, error);
-	xfs_defer_move(parent_tp, tp);
+	xfs_defer_capture(parent_tp, tp);
 	error = xfs_trans_commit(tp);
 	return error;
 
-- 
2.25.1

