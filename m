Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DE41BE50E
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Apr 2020 19:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgD2RWE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Apr 2020 13:22:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49796 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726456AbgD2RWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 13:22:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588180922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oCxjBj96845DkaYkBIJRts5NXAfj1deKThE599XrFQU=;
        b=LXrVaFHz6EIRl7gMBX9fBxX5+f+1CrT/e4q/zHcPoIG9rfcq4UPlS4jWT7MJZJpAAliOFV
        tD1S63HN2cDX9eAVPdo5IjmKzbNH8VOh2w0pDHHp9WwKKaOxowBpuwLhlzwz8TnNRYVDXt
        M2nC3e+B7aqhdJmOwcIYrknzY3hyg6k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-BsUbrApjNwK50-r_qi690g-1; Wed, 29 Apr 2020 13:22:00 -0400
X-MC-Unique: BsUbrApjNwK50-r_qi690g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC733800C78
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:21:59 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98F1B5C1BE
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:21:59 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 10/17] xfs: acquire ->ail_lock from xfs_trans_ail_delete()
Date:   Wed, 29 Apr 2020 13:21:46 -0400
Message-Id: <20200429172153.41680-11-bfoster@redhat.com>
In-Reply-To: <20200429172153.41680-1-bfoster@redhat.com>
References: <20200429172153.41680-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Several callers acquire the lock just prior to the call. Callers
that require ->ail_lock for other purposes already check IN_AIL
state and thus don't require the additional shutdown check in the
helper. Push the lock down into xfs_trans_ail_delete(), open code
the instances that still acquire it, and remove the unnecessary ailp
parameter.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c   | 27 +++++++++++----------------
 fs/xfs/xfs_dquot.c      |  6 ++++--
 fs/xfs/xfs_trans_ail.c  |  3 ++-
 fs/xfs/xfs_trans_priv.h | 14 ++++++++------
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1f7acffc99ba..06e306b49283 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -410,7 +410,6 @@ xfs_buf_item_unpin(
 {
 	struct xfs_buf_log_item	*bip =3D BUF_ITEM(lip);
 	xfs_buf_t		*bp =3D bip->bli_buf;
-	struct xfs_ail		*ailp =3D lip->li_ailp;
 	int			stale =3D bip->bli_flags & XFS_BLI_STALE;
 	int			freed;
=20
@@ -452,10 +451,10 @@ xfs_buf_item_unpin(
 		}
=20
 		/*
-		 * If we get called here because of an IO error, we may
-		 * or may not have the item on the AIL. xfs_trans_ail_delete()
-		 * will take care of that situation.
-		 * xfs_trans_ail_delete() drops the AIL lock.
+		 * If we get called here because of an IO error, we may or may
+		 * not have the item on the AIL. xfs_trans_ail_delete() will
+		 * take care of that situation. xfs_trans_ail_delete() drops
+		 * the AIL lock.
 		 */
 		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
 			xfs_buf_do_callbacks(bp);
@@ -463,8 +462,7 @@ xfs_buf_item_unpin(
 			list_del_init(&bp->b_li_list);
 			bp->b_iodone =3D NULL;
 		} else {
-			spin_lock(&ailp->ail_lock);
-			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_LOG_IO_ERROR);
+			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
 			ASSERT(bp->b_log_item =3D=3D NULL);
 		}
@@ -1205,22 +1203,19 @@ xfs_buf_iodone(
 	struct xfs_buf		*bp,
 	struct xfs_log_item	*lip)
 {
-	struct xfs_ail		*ailp =3D lip->li_ailp;
-
 	ASSERT(BUF_ITEM(lip)->bli_buf =3D=3D bp);
=20
 	xfs_buf_rele(bp);
=20
 	/*
-	 * If we are forcibly shutting down, this may well be
-	 * off the AIL already. That's because we simulate the
-	 * log-committed callbacks to unpin these buffers. Or we may never
-	 * have put this item on AIL because of the transaction was
-	 * aborted forcibly. xfs_trans_ail_delete() takes care of these.
+	 * If we are forcibly shutting down, this may well be off the AIL
+	 * already. That's because we simulate the log-committed callbacks to
+	 * unpin these buffers. Or we may never have put this item on AIL
+	 * because of the transaction was aborted forcibly.
+	 * xfs_trans_ail_delete() takes care of these.
 	 *
 	 * Either way, AIL is useless if we're forcing a shutdown.
 	 */
-	spin_lock(&ailp->ail_lock);
-	xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
+	xfs_trans_ail_delete(lip, SHUTDOWN_CORRUPT_INCORE);
 	xfs_buf_item_free(BUF_ITEM(lip));
 }
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ffe607733c50..5fb65f43b980 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1021,6 +1021,7 @@ xfs_qm_dqflush_done(
 	struct xfs_dq_logitem	*qip =3D (struct xfs_dq_logitem *)lip;
 	struct xfs_dquot	*dqp =3D qip->qli_dquot;
 	struct xfs_ail		*ailp =3D lip->li_ailp;
+	xfs_lsn_t		tail_lsn;
=20
 	/*
 	 * We only want to pull the item from the AIL if its
@@ -1034,10 +1035,11 @@ xfs_qm_dqflush_done(
 	    ((lip->li_lsn =3D=3D qip->qli_flush_lsn) ||
 	     test_bit(XFS_LI_FAILED, &lip->li_flags))) {
=20
-		/* xfs_trans_ail_delete() drops the AIL lock. */
 		spin_lock(&ailp->ail_lock);
 		if (lip->li_lsn =3D=3D qip->qli_flush_lsn) {
-			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
+			/* xfs_ail_update_finish() drops the AIL lock */
+			tail_lsn =3D xfs_ail_delete_one(ailp, lip);
+			xfs_ail_update_finish(ailp, tail_lsn);
 		} else {
 			/*
 			 * Clear the failed state since we are about to drop the
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 2574d01e4a83..cfba691664c7 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -864,13 +864,14 @@ xfs_ail_delete_one(
  */
 void
 xfs_trans_ail_delete(
-	struct xfs_ail		*ailp,
 	struct xfs_log_item	*lip,
 	int			shutdown_type)
 {
+	struct xfs_ail		*ailp =3D lip->li_ailp;
 	struct xfs_mount	*mp =3D ailp->ail_mount;
 	xfs_lsn_t		tail_lsn;
=20
+	spin_lock(&ailp->ail_lock);
 	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 		spin_unlock(&ailp->ail_lock);
 		if (!XFS_FORCED_SHUTDOWN(mp)) {
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 35655eac01a6..e4362fb8d483 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -94,8 +94,7 @@ xfs_trans_ail_update(
 xfs_lsn_t xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *=
lip);
 void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
 			__releases(ailp->ail_lock);
-void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip=
,
-		int shutdown_type);
+void xfs_trans_ail_delete(struct xfs_log_item *lip, int shutdown_type);
=20
 static inline void
 xfs_trans_ail_remove(
@@ -103,13 +102,16 @@ xfs_trans_ail_remove(
 	int			shutdown_type)
 {
 	struct xfs_ail		*ailp =3D lip->li_ailp;
+	xfs_lsn_t		tail_lsn;
=20
 	spin_lock(&ailp->ail_lock);
-	/* xfs_trans_ail_delete() drops the AIL lock */
-	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags))
-		xfs_trans_ail_delete(ailp, lip, shutdown_type);
-	else
+	/* xfs_ail_update_finish() drops the AIL lock */
+	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
+		tail_lsn =3D xfs_ail_delete_one(ailp, lip);
+		xfs_ail_update_finish(ailp, tail_lsn);
+	} else {
 		spin_unlock(&ailp->ail_lock);
+	}
 }
=20
 void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);
--=20
2.21.1

