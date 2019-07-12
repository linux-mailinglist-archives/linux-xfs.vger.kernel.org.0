Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD6D667642
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jul 2019 23:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbfGLVio (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 12 Jul 2019 17:38:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbfGLVin (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jul 2019 17:38:43 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 320D1308FC4E
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 21:38:43 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 020305D739
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 21:38:42 +0000 (UTC)
Subject: [PATCH 3/4] xfsprogs: trivial changes to libxfs/trans.c
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <a40115ca-93e2-6dd2-7940-5911988f8fe4@redhat.com>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <614554f7-2e1a-775e-0828-50b1307f1f09@redhat.com>
Date:   Fri, 12 Jul 2019 16:38:42 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a40115ca-93e2-6dd2-7940-5911988f8fe4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 12 Jul 2019 21:38:43 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make some mostly trivial changes to libxfs/trans.c to more
closely match kernelspace xfs_trans.c, including:

- add tracepoint calls
- add comments
- add braces
- change tests for null
- reorder some tests and initializations

This /should/ be no functional changes.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 43720040..71a7466e 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -168,6 +168,8 @@
 #define trace_xfs_trans_bjoin(a)		((void) 0)
 #define trace_xfs_trans_bhold(a)		((void) 0)
 #define trace_xfs_trans_get_buf(a)		((void) 0)
+#define trace_xfs_trans_get_buf_recur(a)	((void) 0)
+#define trace_xfs_trans_log_buf(a)		((void) 0)
 #define trace_xfs_trans_getsb_recur(a)		((void) 0)
 #define trace_xfs_trans_getsb(a)		((void) 0)
 #define trace_xfs_trans_read_buf_recur(a)	((void) 0)
diff --git a/libxfs/trans.c b/libxfs/trans.c
index fecefc7a..453e5476 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -389,6 +389,15 @@ libxfs_trans_bjoin(
 	trace_xfs_trans_bjoin(bp->b_log_item);
 }
 
+/*
+ * Get and lock the buffer for the caller if it is not already
+ * locked within the given transaction.  If it is already locked
+ * within the transaction, just increment its lock recursion count
+ * and return a pointer to it.
+ *
+ * If the transaction pointer is NULL, make this just a normal
+ * get_buf() call.
+ */
 struct xfs_buf *
 libxfs_trans_get_buf_map(
 	struct xfs_trans	*tp,
@@ -400,21 +409,31 @@ libxfs_trans_get_buf_map(
 	xfs_buf_t		*bp;
 	struct xfs_buf_log_item	*bip;
 
-	if (tp == NULL)
+	if (!tp)
 		return libxfs_getbuf_map(target, map, nmaps, 0);
 
+	/*
+	 * If we find the buffer in the cache with this transaction
+	 * pointer in its b_fsprivate2 field, then we know we already
+	 * have it locked.  In this case we just increment the lock
+	 * recursion count and return the buffer to the caller.
+	 */
 	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
 	if (bp != NULL) {
 		ASSERT(bp->b_transp == tp);
 		bip = bp->b_log_item;
 		ASSERT(bip != NULL);
 		bip->bli_recur++;
+		trace_xfs_trans_get_buf_recur(bip);
 		return bp;
 	}
 
 	bp = libxfs_getbuf_map(target, map, nmaps, 0);
-	if (bp == NULL)
+	if (bp == NULL) {
 		return NULL;
+	}
+
+	ASSERT(!bp->b_error);
 
 	_libxfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_get_buf(bp->b_log_item);
@@ -446,6 +465,8 @@ libxfs_trans_getsb(
 	}
 
 	bp = libxfs_getsb(mp, flags);
+	if (bp == NULL)
+		return NULL;
 
 	_libxfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_getsb(bp->b_log_item);
@@ -480,7 +501,7 @@ libxfs_trans_read_buf_map(
 	}
 
 	bp = xfs_trans_buf_item_match(tp, target, map, nmaps);
-	if (bp != NULL) {
+	if (bp) {
 		ASSERT(bp->b_transp == tp);
 		ASSERT(bp->b_log_item != NULL);
 		bip = bp->b_log_item;
@@ -507,38 +528,61 @@ out_relse:
 	return error;
 }
 
+/*
+ * Release a buffer previously joined to the transaction. If the buffer is
+ * modified within this transaction, decrement the recursion count but do not
+ * release the buffer even if the count goes to 0. If the buffer is not modified
+ * within the transaction, decrement the recursion count and release the buffer
+ * if the recursion count goes to 0.
+ *
+ * If the buffer is to be released and it was not already dirty before this
+ * transaction began, then also free the buf_log_item associated with it.
+ *
+ * If the transaction pointer is NULL, this is a normal xfs_buf_relse() call.
+ */
 void
 libxfs_trans_brelse(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*bp)
 {
-	struct xfs_buf_log_item	*bip;
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	if (tp == NULL) {
-		ASSERT(bp->b_transp == NULL);
+	ASSERT(bp->b_transp == tp);
+
+	if (!tp) {
 		libxfs_putbuf(bp);
 		return;
 	}
 
 	trace_xfs_trans_brelse(bip);
-	ASSERT(bp->b_transp == tp);
-	bip = bp->b_log_item;
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
 
+	/*
+	 * If the release is for a recursive lookup, then decrement the count
+	 * and return.
+	 */
 	if (bip->bli_recur > 0) {
 		bip->bli_recur--;
 		return;
 	}
 
-	/* If dirty/stale, can't release till transaction committed */
-	if (bip->bli_flags & XFS_BLI_STALE)
-		return;
+	/*
+	 * If the buffer is invalidated or dirty in this transaction, we can't
+	 * release it until we commit.
+	 */
 	if (test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags))
 		return;
+	if (bip->bli_flags & XFS_BLI_STALE)
+		return;
 
+	/*
+	 * Unlink the log item from the transaction and clear the hold flag, if
+	 * set. We wouldn't want the next user of the buffer to get confused.
+	 */
 	xfs_trans_del_item(&bip->bli_item);
-	if (bip->bli_flags & XFS_BLI_HOLD)
-		bip->bli_flags &= ~XFS_BLI_HOLD;
+	bip->bli_flags &= ~XFS_BLI_HOLD;
+
+	/* drop the reference to the bli */
 	xfs_buf_item_put(bip);
 
 	bp->b_transp = NULL;
@@ -600,10 +644,11 @@ libxfs_trans_log_buf(
 {
 	struct xfs_buf_log_item	*bip = bp->b_log_item;
 
-	ASSERT((first <= last) && (last < bp->b_bcount));
+	ASSERT(first <= last && last < BBTOB(bp->b_length));
 
 	xfs_trans_dirty_buf(tp, bp);
 
+	trace_xfs_trans_log_buf(bip);
 	xfs_buf_item_log(bip, first, last);
 }
 
@@ -632,6 +677,15 @@ libxfs_trans_binval(
 	tp->t_flags |= XFS_TRANS_DIRTY;
 }
 
+/*
+ * Mark the buffer as being one which contains newly allocated
+ * inodes.  We need to make sure that even if this buffer is
+ * relogged as an 'inode buf' we still recover all of the inode
+ * images in the face of a crash.  This works in coordination with
+ * xfs_buf_item_committed() to ensure that the buffer remains in the
+ * AIL at its original location even after it has been relogged.
+ */
+/* ARGSUSED */
 void
 libxfs_trans_inode_alloc_buf(
 	xfs_trans_t		*tp,

