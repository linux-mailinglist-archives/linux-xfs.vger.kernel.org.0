Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEBD1AE094
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Apr 2020 17:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgDQPJG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 Apr 2020 11:09:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43900 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728852AbgDQPJF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Apr 2020 11:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587136144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ekRja/0uHuj4J/sQPDKwWUNvXZRNoP5ryd+VAnwLquc=;
        b=UmLo+r4Zz7GOq3YWNxPpRIASrsdEXQxZwzYJMolG9/Ekxfu+Oz+OA2X6vbfPo57Qmr5XfP
        Ie5xSLspvO/8ST2mA7AykFuWDJdsO9zPqLl7kYuvm5IBO5ZOD1pkstPkOpdyMEunDEGHPQ
        CP2cBpg/VYk7PFhmXeFtBNmgdi9bDiM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-GydnFOsFOAaOM8sapZ0ovw-1; Fri, 17 Apr 2020 11:09:01 -0400
X-MC-Unique: GydnFOsFOAaOM8sapZ0ovw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0919E18C43C3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:01 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B558D60BE0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:00 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/12] xfs: factor out buffer I/O failure simulation code
Date:   Fri, 17 Apr 2020 11:08:49 -0400
Message-Id: <20200417150859.14734-3-bfoster@redhat.com>
In-Reply-To: <20200417150859.14734-1-bfoster@redhat.com>
References: <20200417150859.14734-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We use the same buffer I/O failure simulation code in a few
different places. It's not much code, but it's not necessarily
self-explanatory. Factor it into a helper and document it in one
place.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c      | 23 +++++++++++++++++++----
 fs/xfs/xfs_buf.h      |  1 +
 fs/xfs/xfs_buf_item.c | 22 +++-------------------
 fs/xfs/xfs_inode.c    |  7 +------
 4 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9ec3eaf1c618..93942d8e35dd 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1248,6 +1248,24 @@ xfs_buf_ioerror_alert(
 			-bp->b_error);
 }
=20
+/*
+  * To simulate an I/O failure, the buffer must be locked and held with =
at least
+ * three references. The LRU reference is dropped by the stale call. The=
 buf
+ * item reference is dropped via ioend processing. The third reference i=
s owned
+ * by the caller and is dropped on I/O completion if the buffer is XBF_A=
SYNC.
+ */
+void
+xfs_buf_iofail(
+	struct xfs_buf	*bp,
+	int		flags)
+{
+	bp->b_flags |=3D flags;
+	bp->b_flags &=3D ~XBF_DONE;
+	xfs_buf_stale(bp);
+	xfs_buf_ioerror(bp, -EIO);
+	xfs_buf_ioend(bp);
+}
+
 int
 xfs_bwrite(
 	struct xfs_buf		*bp)
@@ -1480,10 +1498,7 @@ __xfs_buf_submit(
=20
 	/* on shutdown we stale and complete the buffer immediately */
 	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
-		xfs_buf_ioerror(bp, -EIO);
-		bp->b_flags &=3D ~XBF_DONE;
-		xfs_buf_stale(bp);
-		xfs_buf_ioend(bp);
+		xfs_buf_iofail(bp, 0);
 		return -EIO;
 	}
=20
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 9a04c53c2488..a6bce4702b2e 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -263,6 +263,7 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int=
 error,
 		xfs_failaddr_t failaddr);
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_a=
ddress)
 extern void xfs_buf_ioerror_alert(struct xfs_buf *bp, xfs_failaddr_t fa)=
;
+void xfs_buf_iofail(struct xfs_buf *, int);
=20
 extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
 static inline int xfs_buf_submit(struct xfs_buf *bp)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 8796adde2d12..72d37a4609d8 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -471,28 +471,12 @@ xfs_buf_item_unpin(
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
-		bp->b_flags |=3D XBF_ASYNC;
-		xfs_buf_ioerror(bp, -EIO);
-		bp->b_flags &=3D ~XBF_DONE;
-		xfs_buf_stale(bp);
-		xfs_buf_ioend(bp);
+		xfs_buf_iofail(bp, XBF_ASYNC);
 	}
 }
=20
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d1772786af29..b539ee221ce5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3629,12 +3629,7 @@ xfs_iflush_cluster(
 	 * xfs_buf_submit().
 	 */
 	ASSERT(bp->b_iodone);
-	bp->b_flags |=3D XBF_ASYNC;
-	bp->b_flags &=3D ~XBF_DONE;
-	xfs_buf_stale(bp);
-	xfs_buf_ioerror(bp, -EIO);
-	xfs_buf_ioend(bp);
-
+	xfs_buf_iofail(bp, XBF_ASYNC);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
=20
 	/* abort the corrupt inode, as it was not attached to the buffer */
--=20
2.21.1

