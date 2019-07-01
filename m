Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAF820FAE
	for <lists+linux-xfs@lfdr.de>; Thu, 16 May 2019 22:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfEPUjv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 May 2019 16:39:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52848 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbfEPUjv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 May 2019 16:39:51 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F34D230832DE
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 20:39:50 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C72CB79411
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 20:39:50 +0000 (UTC)
Subject: [PATCH 6/3] libxfs: factor common xfs_trans_bjoin code
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <3a54f934-5651-d709-1503-b583f9e044e9@redhat.com>
Date:   Thu, 16 May 2019 15:39:49 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 16 May 2019 20:39:51 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Most of xfs_trans_bjoin is duplicated in xfs_trans_get_buf_map,
xfs_trans_getsb and xfs_trans_read_buf_map.  Add a new
_xfs_trans_bjoin which can be called by all three functions.

Source kernel commit: d7e84f413726876c0ec66bbf90770f69841f7663

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/trans.c | 53 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 14 deletions(-)

diff --git a/libxfs/trans.c b/libxfs/trans.c
index f3c28fa7..f78222fd 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -537,19 +537,50 @@ xfs_trans_binval(
 	tp->t_flags |= XFS_TRANS_DIRTY;
 }
 
-void
-xfs_trans_bjoin(
-	xfs_trans_t		*tp,
-	xfs_buf_t		*bp)
+/*
+ * Add the locked buffer to the transaction.
+ *
+ * The buffer must be locked, and it cannot be associated with any
+ * transaction.
+ *
+ * If the buffer does not yet have a buf log item associated with it,
+ * then allocate one for it.  Then add the buf item to the transaction.
+ */
+STATIC void
+_xfs_trans_bjoin(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	int			reset_recur)
 {
-	xfs_buf_log_item_t	*bip;
+	struct xfs_buf_log_item	*bip;
 
 	ASSERT(bp->b_transp == NULL);
 
+        /*
+	 * The xfs_buf_log_item pointer is stored in b_log_item.  If
+	 * it doesn't have one yet, then allocate one and initialize it.
+	 * The checks to see if one is there are in xfs_buf_item_init().
+	 */
 	xfs_buf_item_init(bp, tp->t_mountp);
 	bip = bp->b_log_item;
+	if (reset_recur)
+		bip->bli_recur = 0;
+
+	/*
+	 * Attach the item to the transaction so we can find it in
+	 * xfs_trans_get_buf() and friends.
+	 */
 	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
 	bp->b_transp = tp;
+
+}
+
+void
+xfs_trans_bjoin(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	_xfs_trans_bjoin(tp, bp, 0);
 	trace_xfs_trans_bjoin(bp->b_log_item);
 }
 
@@ -594,9 +625,7 @@ xfs_trans_get_buf_map(
 	if (bp == NULL)
 		return NULL;
 
-	xfs_trans_bjoin(tp, bp);
-	bip = bp->b_log_item;
-	bip->bli_recur = 0;
+	_xfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_get_buf(bp->b_log_item);
 	return bp;
 }
@@ -626,9 +655,7 @@ xfs_trans_getsb(
 
 	bp = xfs_getsb(mp);
 
-	xfs_trans_bjoin(tp, bp);
-	bip = bp->b_log_item;
-	bip->bli_recur = 0;
+	_xfs_trans_bjoin(tp, bp, 1);
 	trace_xfs_trans_getsb(bp->b_log_item);
 	return bp;
 }
@@ -677,9 +704,7 @@ xfs_trans_read_buf_map(
 	if (bp->b_error)
 		goto out_relse;
 
-	xfs_trans_bjoin(tp, bp);
-	bip = bp->b_log_item;
-	bip->bli_recur = 0;
+	_xfs_trans_bjoin(tp, bp, 1);
 done:
 	trace_xfs_trans_read_buf(bp->b_log_item);
 	*bpp = bp;
-- 
2.17.0

