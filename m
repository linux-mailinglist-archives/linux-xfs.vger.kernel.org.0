Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7FF6336B2
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2019 19:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbfFCRaT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 13:30:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53638 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbfFCRaT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:30:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qcFwvnE158xf43As0jSR7ukUZPriDun8erH//EVOYwM=; b=SQkG0Ns4i4Mz8AXD0/W/XIE3qx
        MLqbqUudx1yiQnJj61Q97f1+I3JnZVQcKNVuUIso/TlYXWGzGjPCsuH7sf9rSmCXqjztVb99p5Pr+
        mRHrua5A3DxT7Y4KGcs+8GAXe/dI1RAvOWP3P0fvztZiNyFtTcgmMhVptZzxddh/FJbbsrRKjXLPg
        vSy+FoqnWo9nhO6e1amAKbqMRtQZgmwTiaQhp37pRHkLsXKColVBmB9V+GhXSW5/NkPvWlQF91FSg
        azOTedZdEqs9GSD5ZB674B5h0IrvLS7Sq7k6D5iQq+D0AvJS6tAmExJaEkHU0Hs3AcwWz+TN22Y/S
        M37H3LLg==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hXqmo-0003he-FO; Mon, 03 Jun 2019 17:30:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 12/20] xfs: make use of the l_targ field in struct xlog
Date:   Mon,  3 Jun 2019 19:29:37 +0200
Message-Id: <20190603172945.13819-13-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190603172945.13819-1-hch@lst.de>
References: <20190603172945.13819-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use the slightly shorter way to get at the buftarg for the log device
wherever we can in the log and log recovery code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c         | 6 +++---
 fs/xfs/xfs_log_recover.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 70627debb954..358a19789402 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -927,7 +927,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	 * Or, if we are doing a forced umount (typically because of IO errors).
 	 */
 	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
-	    xfs_readonly_buftarg(log->l_mp->m_logdev_targp)) {
+	    xfs_readonly_buftarg(log->l_targ)) {
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 		return 0;
 	}
@@ -1481,7 +1481,7 @@ xlog_alloc_log(
 	 * having set it up properly.
 	 */
 	error = -ENOMEM;
-	bp = xfs_buf_alloc(mp->m_logdev_targp, XFS_BUF_DADDR_NULL,
+	bp = xfs_buf_alloc(log->l_targ, XFS_BUF_DADDR_NULL,
 			   BTOBB(log->l_iclog_size), XBF_NO_IOACCT);
 	if (!bp)
 		goto out_free_log;
@@ -1949,7 +1949,7 @@ xlog_sync(
 	 * synchronously here; for an internal log we can simply use the block
 	 * layer state machine for preflushes.
 	 */
-	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp || split) {
+	if (log->l_targ != log->l_mp->m_ddev_targp || split) {
 		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
 		need_flush = false;
 	}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9329f5adbfbe..4139b907e9cd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -134,7 +134,7 @@ xlog_get_bp(
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
 
-	bp = xfs_buf_get_uncached(log->l_mp->m_logdev_targp, nbblks, 0);
+	bp = xfs_buf_get_uncached(log->l_targ, nbblks, 0);
 	if (bp)
 		xfs_buf_unlock(bp);
 	return bp;
@@ -1505,7 +1505,7 @@ xlog_find_tail(
 	 * But... if the -device- itself is readonly, just skip this.
 	 * We can't recover this device anyway, so it won't matter.
 	 */
-	if (!xfs_readonly_buftarg(log->l_mp->m_logdev_targp))
+	if (!xfs_readonly_buftarg(log->l_targ))
 		error = xlog_clear_stale_blocks(log, tail_lsn);
 
 done:
-- 
2.20.1

