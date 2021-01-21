Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7702FEF7E
	for <lists+linux-xfs@lfdr.de>; Thu, 21 Jan 2021 16:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387729AbhAUPus (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 21 Jan 2021 10:50:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387544AbhAUPrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jan 2021 10:47:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611243935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gZOPIy4NoLdaosGY/uG6mZS+F/JYaLQeQFoQ6DNQ4sI=;
        b=LwjIPkh2DxY0sZ6jQMRNo//CvWDd2dJS8KVaLIF48R0Y//K7swbQHAdCba1K9mJdpnkLuk
        KW8PHh9jTLCAV20duIfxjaZcOIJJ874cDQOknZhMJcI9Sr42//q2KVJ7Vuz2DClGC3e9pp
        FDpiC8ts9SoeX0SfY2BDc8g087nNOo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-aPD5Tn1iPG-uU4WLyXBGVQ-1; Thu, 21 Jan 2021 10:45:31 -0500
X-MC-Unique: aPD5Tn1iPG-uU4WLyXBGVQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BA3B51E4
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:45:30 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DC1B46
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jan 2021 15:45:30 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 8/9] xfs: remove xfs_quiesce_attr()
Date:   Thu, 21 Jan 2021 10:45:25 -0500
Message-Id: <20210121154526.1852176-9-bfoster@redhat.com>
In-Reply-To: <20210121154526.1852176-1-bfoster@redhat.com>
References: <20210121154526.1852176-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_quiesce_attr() is now a wrapper for xfs_log_clean(). Remove it
and call xfs_log_clean() directly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.c |  2 +-
 fs/xfs/xfs_super.c | 24 ++----------------------
 2 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index f97b82d0e30f..4a26b48b18e4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -946,7 +946,7 @@ xfs_mountfs(
 	 */
 	if ((mp->m_flags & (XFS_MOUNT_RDONLY|XFS_MOUNT_NORECOVERY)) ==
 							XFS_MOUNT_RDONLY) {
-		xfs_quiesce_attr(mp);
+		xfs_log_clean(mp);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8fc9044131fc..aedf622d221b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -867,26 +867,6 @@ xfs_restore_resvblks(struct xfs_mount *mp)
 	xfs_reserve_blocks(mp, &resblks, NULL);
 }
 
-/*
- * Trigger writeback of all the dirty metadata in the file system.
- *
- * This ensures that the metadata is written to their location on disk rather
- * than just existing in transactions in the log. This means after a quiesce
- * there is no log replay required to write the inodes to disk - this is the
- * primary difference between a sync and a quiesce.
- *
- * We cancel log work early here to ensure all transactions the log worker may
- * run have finished before we clean up and log the superblock and write an
- * unmount record. The unfreeze process is responsible for restarting the log
- * worker correctly.
- */
-void
-xfs_quiesce_attr(
-	struct xfs_mount	*mp)
-{
-	xfs_log_clean(mp);
-}
-
 /*
  * Second stage of a freeze. The data is already frozen so we only
  * need to take care of the metadata. Once that's done sync the superblock
@@ -909,7 +889,7 @@ xfs_fs_freeze(
 	flags = memalloc_nofs_save();
 	xfs_stop_block_reaping(mp);
 	xfs_save_resvblks(mp);
-	xfs_quiesce_attr(mp);
+	xfs_log_clean(mp);
 	ret = xfs_sync_sb(mp, true);
 	memalloc_nofs_restore(flags);
 	return ret;
@@ -1752,7 +1732,7 @@ xfs_remount_ro(
 	 */
 	xfs_save_resvblks(mp);
 
-	xfs_quiesce_attr(mp);
+	xfs_log_clean(mp);
 	mp->m_flags |= XFS_MOUNT_RDONLY;
 
 	return 0;
-- 
2.26.2

