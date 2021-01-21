Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969A02FEF75
	for <lists+linux-xfs@lfdr.de>; Thu, 21 Jan 2021 16:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387477AbhAUPt5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 21 Jan 2021 10:49:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387471AbhAUPq7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 10:46:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611243932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYfb3oX400Lvimhi0BKcvhvL9BIoCPhb1FUgb2DsgmU=;
        b=VQrZebE5zgVCgEaaxr/KBj+3PYiMp08gN+k6ve5LyPydm40V19UE0s2B4KPSpRSekPw0kP
        QnA3n451U7KlEpq2WLlb5gK3GIxGHE88d6LDqIAsN1shzR3VgZ6QkFQawloHXu/cojz/tC
        ZXP3Iw2rEKRtOseww956fpUWL8saLV0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-lJCE9lnlPwSFRJIk1oop3Q-1; Thu, 21 Jan 2021 10:45:30 -0500
X-MC-Unique: lJCE9lnlPwSFRJIk1oop3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF8EF51E1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:45:29 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9175A3AE1
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:45:29 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 6/9] xfs: fold sbcount quiesce logging into log covering
Date:   Thu, 21 Jan 2021 10:45:23 -0500
Message-Id: <20210121154526.1852176-7-bfoster@redhat.com>
In-Reply-To: <20210121154526.1852176-1-bfoster@redhat.com>
References: <20210121154526.1852176-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_log_sbcount() calls xfs_sync_sb() to sync superblock counters to
disk when lazy superblock accounting is enabled. This occurs on
unmount, freeze, and read-only (re)mount and ensures the final
values are calculated and persisted to disk before each form of
quiesce completes.

Now that log covering occurs in all of these contexts and uses the
same xfs_sync_sb() mechanism to update log state, there is no need
to log the superblock separately for any reason. Update the log
quiesce path to sync the superblock at least once for any mount
where lazy superblock accounting is enabled. If the log is already
covered, it will remain in the covered state. Otherwise, the next
sync as part of the normal covering sequence will carry the
associated superblock update with it. Remove xfs_log_sbcount() now
that it is no longer needed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c   | 20 ++++++++++++++++++--
 fs/xfs/xfs_mount.c | 31 -------------------------------
 fs/xfs/xfs_mount.h |  1 -
 fs/xfs/xfs_super.c |  8 --------
 4 files changed, 18 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6db65a4513a6..9479a5d0d785 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1108,6 +1108,7 @@ xfs_log_cover(
 {
 	struct xlog		*log = mp->m_log;
 	int			error = 0;
+	bool			need_covered;
 
 	ASSERT((xlog_cil_empty(log) && xlog_iclogs_empty(log) &&
 	        !xfs_ail_min_lsn(log->l_ailp)) ||
@@ -1116,6 +1117,21 @@ xfs_log_cover(
 	if (!xfs_log_writable(mp))
 		return 0;
 
+	/*
+	 * xfs_log_need_covered() is not idempotent because it progresses the
+	 * state machine if the log requires covering. Therefore, we must call
+	 * this function once and use the result until we've issued an sb sync.
+	 * Do so first to make that abundantly clear.
+	 *
+	 * Fall into the covering sequence if the log needs covering or the
+	 * mount has lazy superblock accounting to sync to disk. The sb sync
+	 * used for covering accumulates the in-core counters, so covering
+	 * handles this for us.
+	 */
+	need_covered = xfs_log_need_covered(mp);
+	if (!need_covered && !xfs_sb_version_haslazysbcount(&mp->m_sb))
+		return 0;
+
 	/*
 	 * To cover the log, commit the superblock twice (at most) in
 	 * independent checkpoints. The first serves as a reference for the
@@ -1125,12 +1141,12 @@ xfs_log_cover(
 	 * covering the log. Push the AIL one more time to leave it empty, as
 	 * we found it.
 	 */
-	while (xfs_log_need_covered(mp)) {
+	do {
 		error = xfs_sync_sb(mp, true);
 		if (error)
 			break;
 		xfs_ail_push_all_sync(mp->m_ail);
-	}
+	} while (xfs_log_need_covered(mp));
 
 	return error;
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index a62b8a574409..f97b82d0e30f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1124,12 +1124,6 @@ xfs_unmountfs(
 		xfs_warn(mp, "Unable to free reserved block pool. "
 				"Freespace may not be correct on next mount.");
 
-	error = xfs_log_sbcount(mp);
-	if (error)
-		xfs_warn(mp, "Unable to update superblock counters. "
-				"Freespace may not be correct on next mount.");
-
-
 	xfs_log_unmount(mp);
 	xfs_da_unmount(mp);
 	xfs_uuid_unmount(mp);
@@ -1164,31 +1158,6 @@ xfs_fs_writable(
 	return true;
 }
 
-/*
- * xfs_log_sbcount
- *
- * Sync the superblock counters to disk.
- *
- * Note this code can be called during the process of freezing, so we use the
- * transaction allocator that does not block when the transaction subsystem is
- * in its frozen state.
- */
-int
-xfs_log_sbcount(xfs_mount_t *mp)
-{
-	if (!xfs_log_writable(mp))
-		return 0;
-
-	/*
-	 * we don't need to do this if we are updating the superblock
-	 * counters on every modification.
-	 */
-	if (!xfs_sb_version_haslazysbcount(&mp->m_sb))
-		return 0;
-
-	return xfs_sync_sb(mp, true);
-}
-
 /*
  * Deltas for the block count can vary from 1 to very large, but lock contention
  * only occurs on frequent small block count updates such as in the delayed
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index dfa429b77ee2..452ca7654dc5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -399,7 +399,6 @@ int xfs_buf_hash_init(xfs_perag_t *pag);
 void xfs_buf_hash_destroy(xfs_perag_t *pag);
 
 extern void	xfs_uuid_table_free(void);
-extern int	xfs_log_sbcount(xfs_mount_t *);
 extern uint64_t xfs_default_resblks(xfs_mount_t *mp);
 extern int	xfs_mountfs(xfs_mount_t *mp);
 extern int	xfs_initialize_perag(xfs_mount_t *mp, xfs_agnumber_t agcount,
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 09d956e30fd8..75ada867c665 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -884,19 +884,11 @@ void
 xfs_quiesce_attr(
 	struct xfs_mount	*mp)
 {
-	int	error = 0;
-
 	cancel_delayed_work_sync(&mp->m_log->l_work);
 
 	/* force the log to unpin objects from the now complete transactions */
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
-
-	/* Push the superblock and write an unmount record */
-	error = xfs_log_sbcount(mp);
-	if (error)
-		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
-				"Frozen image may not be consistent.");
 	xfs_log_clean(mp);
 }
 
-- 
2.26.2

