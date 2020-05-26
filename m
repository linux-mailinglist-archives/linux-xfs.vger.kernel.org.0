Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7F01BE509
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Apr 2020 19:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgD2RWA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Apr 2020 13:22:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41671 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726511AbgD2RWA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 13:22:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588180918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/P2FE7Eo5bNL37LUOEZTLinJI7tq71qF8PWi2+7nknw=;
        b=VpZH1yU72LyHVJtelXx6vmH57dqEVa6Usi17NNHSkMfQCFqJxu3nY0ofTNhVKRRZJTeZCb
        OErje8AT6ejShIAEjURVfbBOkOh1vzmHC4+ewewO8g5GsBhFxTd9KN6EmjqDd+UQHaODua
        90yCQBQEOQyGjrr+1UB1YeEeAjMhxEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-R-HesBmzM1OvSILEEXuCXg-1; Wed, 29 Apr 2020 13:21:56 -0400
X-MC-Unique: R-HesBmzM1OvSILEEXuCXg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E5DD1005510
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:21:55 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49BD95C1BE
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:21:55 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 02/17] xfs: factor out buffer I/O failure code
Date:   Wed, 29 Apr 2020 13:21:38 -0400
Message-Id: <20200429172153.41680-3-bfoster@redhat.com>
In-Reply-To: <20200429172153.41680-1-bfoster@redhat.com>
References: <20200429172153.41680-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We use the same buffer I/O failure code in a few different places.
It's not much code, but it's not necessarily self-explanatory.
Factor it into a helper and document it in one place.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c      | 21 +++++++++++++++++----
 fs/xfs/xfs_buf.h      |  1 +
 fs/xfs/xfs_buf_item.c | 21 +++------------------
 fs/xfs/xfs_inode.c    |  6 +-----
 4 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9ec3eaf1c618..d5d6a68bb1e6 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1248,6 +1248,22 @@ xfs_buf_ioerror_alert(
 			-bp->b_error);
 }
=20
+/*
+ * To simulate an I/O failure, the buffer must be locked and held with a=
t least
+ * three references. The LRU reference is dropped by the stale call. The=
 buf
+ * item reference is dropped via ioend processing. The third reference i=
s owned
+ * by the caller and is dropped on I/O completion if the buffer is XBF_A=
SYNC.
+ */
+void
+xfs_buf_ioend_fail(
+	struct xfs_buf	*bp)
+{
+	bp->b_flags &=3D ~XBF_DONE;
+	xfs_buf_stale(bp);
+	xfs_buf_ioerror(bp, -EIO);
+	xfs_buf_ioend(bp);
+}
+
 int
 xfs_bwrite(
 	struct xfs_buf		*bp)
@@ -1480,10 +1496,7 @@ __xfs_buf_submit(
=20
 	/* on shutdown we stale and complete the buffer immediately */
 	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
-		xfs_buf_ioerror(bp, -EIO);
-		bp->b_flags &=3D ~XBF_DONE;
-		xfs_buf_stale(bp);
-		xfs_buf_ioend(bp);
+		xfs_buf_ioend_fail(bp);
 		return -EIO;
 	}
=20
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 9a04c53c2488..06ea3eef866e 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -263,6 +263,7 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int=
 error,
 		xfs_failaddr_t failaddr);
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_a=
ddress)
 extern void xfs_buf_ioerror_alert(struct xfs_buf *bp, xfs_failaddr_t fa)=
;
+void xfs_buf_ioend_fail(struct xfs_buf *);
=20
 extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
 static inline int xfs_buf_submit(struct xfs_buf *bp)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 8796adde2d12..b452a399a441 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -471,28 +471,13 @@ xfs_buf_item_unpin(
 		xfs_buf_relse(bp);
 	} else if (freed && remove) {
 		/*
-		 * There are currently two references to the buffer - the active
-		 * LRU reference and the buf log item. What we are about to do
-		 * here - simulate a failed IO completion - requires 3
-		 * references.
-		 *
-		 * The LRU reference is removed by the xfs_buf_stale() call. The
-		 * buf item reference is removed by the xfs_buf_iodone()
-		 * callback that is run by xfs_buf_do_callbacks() during ioend
-		 * processing (via the bp->b_iodone callback), and then finally
-		 * the ioend processing will drop the IO reference if the buffer
-		 * is marked XBF_ASYNC.
-		 *
-		 * Hence we need to take an additional reference here so that IO
-		 * completion processing doesn't free the buffer prematurely.
+		 * The buffer must be locked and held by the caller to simulate
+		 * an async I/O failure.
 		 */
 		xfs_buf_lock(bp);
 		xfs_buf_hold(bp);
 		bp->b_flags |=3D XBF_ASYNC;
-		xfs_buf_ioerror(bp, -EIO);
-		bp->b_flags &=3D ~XBF_DONE;
-		xfs_buf_stale(bp);
-		xfs_buf_ioend(bp);
+		xfs_buf_ioend_fail(bp);
 	}
 }
=20
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d1772786af29..909ca7c0bac4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3630,11 +3630,7 @@ xfs_iflush_cluster(
 	 */
 	ASSERT(bp->b_iodone);
 	bp->b_flags |=3D XBF_ASYNC;
-	bp->b_flags &=3D ~XBF_DONE;
-	xfs_buf_stale(bp);
-	xfs_buf_ioerror(bp, -EIO);
-	xfs_buf_ioend(bp);
-
+	xfs_buf_ioend_fail(bp);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
=20
 	/* abort the corrupt inode, as it was not attached to the buffer */
--=20
2.21.1

