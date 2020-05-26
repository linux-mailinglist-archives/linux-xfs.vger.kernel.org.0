Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAB01C3C79
	for <lists+linux-xfs@lfdr.de>; Mon,  4 May 2020 16:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgEDOMA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 May 2020 10:12:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56959 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726404AbgEDOL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 10:11:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588601517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ywaUyu1lftTJV7mCpoBt8sbpdAQrNOOSycGeb8d7+M=;
        b=GLUomVpfbDwkMN3zNAKwCJtyD3FjHEAquhBlerD5swCkW1WKSyDRIr/oiZwH/RQ3dXW8Cw
        fJsfCKyCyIjtSTUdjffxeOk8gUyeI+gJl5qFDmMcQRlYpD/9/7cs2lb/KTPfNYZE46YL+X
        IwLJki+iA9sivJRK51Y4wH95nhqo05E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-4E6Cxe3LMS6SSYiKoZiEsg-1; Mon, 04 May 2020 10:11:56 -0400
X-MC-Unique: 4E6Cxe3LMS6SSYiKoZiEsg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C46DEC1BB
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:11:55 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16E781C92D
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:11:55 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 01/17] xfs: refactor failed buffer resubmission into xfsaild
Date:   Mon,  4 May 2020 10:11:38 -0400
Message-Id: <20200504141154.55887-2-bfoster@redhat.com>
In-Reply-To: <20200504141154.55887-1-bfoster@redhat.com>
References: <20200504141154.55887-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Flush locked log items whose underlying buffers fail metadata
writeback are tagged with a special flag to indicate that the flush
lock is already held. This is currently implemented in the type
specific ->iop_push() callback, but the processing required for such
items is not type specific because we're only doing basic state
management on the underlying buffer.

Factor the failed log item handling out of the inode and dquot
->iop_push() callbacks and open code the buffer resubmit helper into
a single helper called from xfsaild_push_item(). This provides a
generic mechanism for handling failed metadata buffer writeback with
a bit less code.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf_item.c   | 39 ---------------------------------------
 fs/xfs/xfs_buf_item.h   |  2 --
 fs/xfs/xfs_dquot_item.c | 15 ---------------
 fs/xfs/xfs_inode_item.c | 15 ---------------
 fs/xfs/xfs_trans_ail.c  | 41 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 41 insertions(+), 71 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1545657c3ca0..8796adde2d12 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1248,42 +1248,3 @@ xfs_buf_iodone(
 	xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
 	xfs_buf_item_free(BUF_ITEM(lip));
 }
-
-/*
- * Requeue a failed buffer for writeback.
- *
- * We clear the log item failed state here as well, but we have to be ca=
reful
- * about reference counts because the only active reference counts on th=
e buffer
- * may be the failed log items. Hence if we clear the log item failed st=
ate
- * before queuing the buffer for IO we can release all active references=
 to
- * the buffer and free it, leading to use after free problems in
- * xfs_buf_delwri_queue. It makes no difference to the buffer or log ite=
ms which
- * order we process them in - the buffer is locked, and we own the buffe=
r list
- * so nothing on them is going to change while we are performing this ac=
tion.
- *
- * Hence we can safely queue the buffer for IO before we clear the faile=
d log
- * item state, therefore  always having an active reference to the buffe=
r and
- * avoiding the transient zero-reference state that leads to use-after-f=
ree.
- *
- * Return true if the buffer was added to the buffer list, false if it w=
as
- * already on the buffer list.
- */
-bool
-xfs_buf_resubmit_failed_buffers(
-	struct xfs_buf		*bp,
-	struct list_head	*buffer_list)
-{
-	struct xfs_log_item	*lip;
-	bool			ret;
-
-	ret =3D xfs_buf_delwri_queue(bp, buffer_list);
-
-	/*
-	 * XFS_LI_FAILED set/clear is protected by ail_lock, caller of this
-	 * function already have it acquired
-	 */
-	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
-		xfs_clear_li_failed(lip);
-
-	return ret;
-}
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 30114b510332..c9c57e2da932 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -59,8 +59,6 @@ void	xfs_buf_attach_iodone(struct xfs_buf *,
 			      struct xfs_log_item *);
 void	xfs_buf_iodone_callbacks(struct xfs_buf *);
 void	xfs_buf_iodone(struct xfs_buf *, struct xfs_log_item *);
-bool	xfs_buf_resubmit_failed_buffers(struct xfs_buf *,
-					struct list_head *);
 bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
=20
 extern kmem_zone_t	*xfs_buf_item_zone;
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index baad1748d0d1..5a7808299a32 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -145,21 +145,6 @@ xfs_qm_dquot_logitem_push(
 	if (atomic_read(&dqp->q_pincount) > 0)
 		return XFS_ITEM_PINNED;
=20
-	/*
-	 * The buffer containing this item failed to be written back
-	 * previously. Resubmit the buffer for IO
-	 */
-	if (test_bit(XFS_LI_FAILED, &lip->li_flags)) {
-		if (!xfs_buf_trylock(bp))
-			return XFS_ITEM_LOCKED;
-
-		if (!xfs_buf_resubmit_failed_buffers(bp, buffer_list))
-			rval =3D XFS_ITEM_FLUSHING;
-
-		xfs_buf_unlock(bp);
-		return rval;
-	}
-
 	if (!xfs_dqlock_nowait(dqp))
 		return XFS_ITEM_LOCKED;
=20
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index f779cca2346f..1d4d256a2e96 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -497,21 +497,6 @@ xfs_inode_item_push(
 	if (xfs_ipincount(ip) > 0)
 		return XFS_ITEM_PINNED;
=20
-	/*
-	 * The buffer containing this item failed to be written back
-	 * previously. Resubmit the buffer for IO.
-	 */
-	if (test_bit(XFS_LI_FAILED, &lip->li_flags)) {
-		if (!xfs_buf_trylock(bp))
-			return XFS_ITEM_LOCKED;
-
-		if (!xfs_buf_resubmit_failed_buffers(bp, buffer_list))
-			rval =3D XFS_ITEM_FLUSHING;
-
-		xfs_buf_unlock(bp);
-		return rval;
-	}
-
 	if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
 		return XFS_ITEM_LOCKED;
=20
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 564253550b75..2574d01e4a83 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -345,6 +345,45 @@ xfs_ail_delete(
 	xfs_trans_ail_cursor_clear(ailp, lip);
 }
=20
+/*
+ * Requeue a failed buffer for writeback.
+ *
+ * We clear the log item failed state here as well, but we have to be ca=
reful
+ * about reference counts because the only active reference counts on th=
e buffer
+ * may be the failed log items. Hence if we clear the log item failed st=
ate
+ * before queuing the buffer for IO we can release all active references=
 to
+ * the buffer and free it, leading to use after free problems in
+ * xfs_buf_delwri_queue. It makes no difference to the buffer or log ite=
ms which
+ * order we process them in - the buffer is locked, and we own the buffe=
r list
+ * so nothing on them is going to change while we are performing this ac=
tion.
+ *
+ * Hence we can safely queue the buffer for IO before we clear the faile=
d log
+ * item state, therefore  always having an active reference to the buffe=
r and
+ * avoiding the transient zero-reference state that leads to use-after-f=
ree.
+ */
+static inline int
+xfsaild_resubmit_item(
+	struct xfs_log_item	*lip,
+	struct list_head	*buffer_list)
+{
+	struct xfs_buf		*bp =3D lip->li_buf;
+
+	if (!xfs_buf_trylock(bp))
+		return XFS_ITEM_LOCKED;
+
+	if (!xfs_buf_delwri_queue(bp, buffer_list)) {
+		xfs_buf_unlock(bp);
+		return XFS_ITEM_FLUSHING;
+	}
+
+	/* protected by ail_lock */
+	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
+		xfs_clear_li_failed(lip);
+
+	xfs_buf_unlock(bp);
+	return XFS_ITEM_SUCCESS;
+}
+
 static inline uint
 xfsaild_push_item(
 	struct xfs_ail		*ailp,
@@ -365,6 +404,8 @@ xfsaild_push_item(
 	 */
 	if (!lip->li_ops->iop_push)
 		return XFS_ITEM_PINNED;
+	if (test_bit(XFS_LI_FAILED, &lip->li_flags))
+		return xfsaild_resubmit_item(lip, &ailp->ail_buf_list);
 	return lip->li_ops->iop_push(lip, &ailp->ail_buf_list);
 }
=20
--=20
2.21.1

