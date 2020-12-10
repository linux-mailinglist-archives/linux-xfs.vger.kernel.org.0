Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067232D5E6B
	for <lists+linux-xfs@lfdr.de>; Thu, 10 Dec 2020 15:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389571AbgLJOru (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 10 Dec 2020 09:47:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391661AbgLJOrn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Dec 2020 09:47:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607611576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HEbJBrzCLJ0gwC8ya5yChC9F2Jtk/4QoE40fjbAsGM0=;
        b=Jmi0z2hV22+qLW52mc25xTrVQ7UsXL6C7xG82Bu7xy5MiqnEcta5uLSDMmfElKZlUwow0F
        luOx+Y9CxetW+hRGDn7uPOykOjDUKJM8Y5KoHOM5ltI+oVKY1cZYpmFx2Z2tvXwSHvhmUQ
        5Ek0HsrDpYiLdyYaaQLgR00gGx+fTCg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-NWKWKKShOxOap-MxbHFTNg-1; Thu, 10 Dec 2020 09:46:13 -0500
X-MC-Unique: NWKWKKShOxOap-MxbHFTNg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6E61800D55
        for <linux-xfs@vger.kernel.org>; Thu, 10 Dec 2020 14:46:11 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 917F819713
        for <linux-xfs@vger.kernel.org>; Thu, 10 Dec 2020 14:46:11 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: don't drain buffer lru on freeze and read-only remount
Date:   Thu, 10 Dec 2020 09:46:07 -0500
Message-Id: <20201210144607.1922026-3-bfoster@redhat.com>
In-Reply-To: <20201210144607.1922026-1-bfoster@redhat.com>
References: <20201210144607.1922026-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_buftarg_drain() is called from xfs_log_quiesce() to ensure the
buffer cache is reclaimed during unmount. xfs_log_quiesce() is also
called from xfs_quiesce_attr(), however, which means that cache
state is completely drained for filesystem freeze and read-only
remount. While technically harmless, this is unnecessarily
heavyweight. Both freeze and read-only mounts allow reads and thus
allow population of the buffer cache. Therefore, the transitional
sequence in either case really only needs to quiesce outstanding
writes to return the filesystem in a generally read-only state.

Additionally, some users have reported that attempts to freeze a
filesystem concurrent with a read-heavy workload causes the freeze
process to stall for a significant amount of time. This occurs
because, as mentioned above, the read workload repopulates the
buffer LRU while the freeze task attempts to drain it.

To improve this situation, replace the drain in xfs_log_quiesce()
with a buffer I/O quiesce and lift the drain into the unmount path.
This removes buffer LRU reclaim from freeze and read-only [re]mount,
but ensures the LRU is still drained before the filesystem unmounts.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c | 20 +++++++++++++++-----
 fs/xfs/xfs_buf.h |  1 +
 fs/xfs/xfs_log.c |  6 ++++--
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index db918ed20c40..d3fce3129f6e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1815,14 +1815,13 @@ xfs_buftarg_drain_rele(
 	return LRU_REMOVED;
 }
 
+/*
+ * Wait for outstanding I/O on the buftarg to complete.
+ */
 void
-xfs_buftarg_drain(
+xfs_buftarg_wait(
 	struct xfs_buftarg	*btp)
 {
-	LIST_HEAD(dispose);
-	int			loop = 0;
-	bool			write_fail = false;
-
 	/*
 	 * First wait on the buftarg I/O count for all in-flight buffers to be
 	 * released. This is critical as new buffers do not make the LRU until
@@ -1838,6 +1837,17 @@ xfs_buftarg_drain(
 	while (percpu_counter_sum(&btp->bt_io_count))
 		delay(100);
 	flush_workqueue(btp->bt_mount->m_buf_workqueue);
+}
+
+void
+xfs_buftarg_drain(
+	struct xfs_buftarg	*btp)
+{
+	LIST_HEAD(dispose);
+	int			loop = 0;
+	bool			write_fail = false;
+
+	xfs_buftarg_wait(btp);
 
 	/* loop until there is nothing left on the lru list. */
 	while (list_lru_count(&btp->bt_lru)) {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index ea32369f8f77..96c6b478e26e 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -347,6 +347,7 @@ xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
 extern struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *,
 		struct block_device *, struct dax_device *);
 extern void xfs_free_buftarg(struct xfs_buftarg *);
+extern void xfs_buftarg_wait(struct xfs_buftarg *);
 extern void xfs_buftarg_drain(struct xfs_buftarg *);
 extern int xfs_setsize_buftarg(struct xfs_buftarg *, unsigned int);
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5ad4d5e78019..46ea4017fcec 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -936,13 +936,13 @@ xfs_log_quiesce(
 
 	/*
 	 * The superblock buffer is uncached and while xfs_ail_push_all_sync()
-	 * will push it, xfs_buftarg_drain() will not wait for it. Further,
+	 * will push it, xfs_buftarg_wait() will not wait for it. Further,
 	 * xfs_buf_iowait() cannot be used because it was pushed with the
 	 * XBF_ASYNC flag set, so we need to use a lock/unlock pair to wait for
 	 * the IO to complete.
 	 */
 	xfs_ail_push_all_sync(mp->m_ail);
-	xfs_buftarg_drain(mp->m_ddev_targp);
+	xfs_buftarg_wait(mp->m_ddev_targp);
 	xfs_buf_lock(mp->m_sb_bp);
 	xfs_buf_unlock(mp->m_sb_bp);
 
@@ -962,6 +962,8 @@ xfs_log_unmount(
 {
 	xfs_log_quiesce(mp);
 
+	xfs_buftarg_drain(mp->m_ddev_targp);
+
 	xfs_trans_ail_destroy(mp);
 
 	xfs_sysfs_del(&mp->m_log->l_kobj);
-- 
2.26.2

