Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792002FAD21
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Jan 2021 23:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732848AbhARWNI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 18 Jan 2021 17:13:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732689AbhARWMz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:12:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED29122E01;
        Mon, 18 Jan 2021 22:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007924;
        bh=IOZ4V6vGiW0fuAnb7QubKCYaQDmoA5lNXI7o4aHaLqk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kc9pmskcQCu/cp7SPk/YdcTOTy9xdA1O6lBy41uyy7vQsrLMiiQQkKP3NPUImK/F5
         Gd9t1EtBK16dHDWAEjrRpG3Tb9PXzwl6gGZcNbnCnzK3NK4BSmmkgKXcOuHrjtf/zW
         Pl2jusXlhUIHcvzGx3wbX0IA3OCZsVxk5xSG/MwsQ0gTMaKWW3pQJRzupM3HtF3vRd
         ++t2052DqniVllsq0w4oNEl7XtnhcZqdSXppHti8cIM0VoDAnlwYAz3fJQJQeVadQM
         0u0grwWwfuDFX0sZDKdSblGIPwKbUUQP+NdLzeD3wWXS63WWJ6NAgB7K9hJ9WM8BU6
         eodquUQaAwd6Q==
Subject: [PATCH 01/11] xfs: refactor messy xfs_inode_free_quota_* functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:12:03 -0800
Message-ID: <161100792365.88816.5278162286235569414.stgit@magnolia>
In-Reply-To: <161100791789.88816.10902093186807310995.stgit@magnolia>
References: <161100791789.88816.10902093186807310995.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The functions to run an eof/cowblocks scan to try to reduce quota usage
are kind of a mess -- the logic repeatedly initializes an eofb structure
and there are logic bugs in the code that result in the cowblocks scan
never actually happening.

Replace all three functions with a single function that fills out an
eofb if we're low on quota and runs both eof and cowblocks scans.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c   |   15 ++++++---------
 fs/xfs/xfs_icache.c |   46 ++++++++++++++++------------------------------
 fs/xfs/xfs_icache.h |    4 ++--
 3 files changed, 24 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5b0f93f73837..5d5cf25668b5 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -652,7 +652,7 @@ xfs_file_buffered_aio_write(
 	struct inode		*inode = mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 	ssize_t			ret;
-	int			enospc = 0;
+	bool			cleared_space = false;
 	int			iolock;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
@@ -684,19 +684,16 @@ xfs_file_buffered_aio_write(
 	 * also behaves as a filter to prevent too many eofblocks scans from
 	 * running at the same time.
 	 */
-	if (ret == -EDQUOT && !enospc) {
+	if (ret == -EDQUOT && !cleared_space) {
 		xfs_iunlock(ip, iolock);
-		enospc = xfs_inode_free_quota_eofblocks(ip);
-		if (enospc)
-			goto write_retry;
-		enospc = xfs_inode_free_quota_cowblocks(ip);
-		if (enospc)
+		cleared_space = xfs_inode_free_quota_blocks(ip);
+		if (cleared_space)
 			goto write_retry;
 		iolock = 0;
-	} else if (ret == -ENOSPC && !enospc) {
+	} else if (ret == -ENOSPC && !cleared_space) {
 		struct xfs_eofblocks eofb = {0};
 
-		enospc = 1;
+		cleared_space = true;
 		xfs_flush_inodes(ip->i_mount);
 
 		xfs_iunlock(ip, iolock);
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index deb99300d171..c71eb15e3835 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1397,33 +1397,31 @@ xfs_icache_free_eofblocks(
 }
 
 /*
- * Run eofblocks scans on the quotas applicable to the inode. For inodes with
- * multiple quotas, we don't know exactly which quota caused an allocation
+ * Run cow/eofblocks scans on the quotas applicable to the inode. For inodes
+ * with multiple quotas, we don't know exactly which quota caused an allocation
  * failure. We make a best effort by including each quota under low free space
  * conditions (less than 1% free space) in the scan.
  */
-static int
-__xfs_inode_free_quota_eofblocks(
-	struct xfs_inode	*ip,
-	int			(*execute)(struct xfs_mount *mp,
-					   struct xfs_eofblocks	*eofb))
+bool
+xfs_inode_free_quota_blocks(
+	struct xfs_inode	*ip)
 {
-	int scan = 0;
-	struct xfs_eofblocks eofb = {0};
-	struct xfs_dquot *dq;
+	struct xfs_eofblocks	eofb = {0};
+	struct xfs_dquot	*dq;
+	bool			do_work = false;
 
 	/*
 	 * Run a sync scan to increase effectiveness and use the union filter to
 	 * cover all applicable quotas in a single scan.
 	 */
-	eofb.eof_flags = XFS_EOF_FLAGS_UNION|XFS_EOF_FLAGS_SYNC;
+	eofb.eof_flags = XFS_EOF_FLAGS_UNION | XFS_EOF_FLAGS_SYNC;
 
 	if (XFS_IS_UQUOTA_ENFORCED(ip->i_mount)) {
 		dq = xfs_inode_dquot(ip, XFS_DQTYPE_USER);
 		if (dq && xfs_dquot_lowsp(dq)) {
 			eofb.eof_uid = VFS_I(ip)->i_uid;
 			eofb.eof_flags |= XFS_EOF_FLAGS_UID;
-			scan = 1;
+			do_work = true;
 		}
 	}
 
@@ -1432,21 +1430,16 @@ __xfs_inode_free_quota_eofblocks(
 		if (dq && xfs_dquot_lowsp(dq)) {
 			eofb.eof_gid = VFS_I(ip)->i_gid;
 			eofb.eof_flags |= XFS_EOF_FLAGS_GID;
-			scan = 1;
+			do_work = true;
 		}
 	}
 
-	if (scan)
-		execute(ip->i_mount, &eofb);
+	if (!do_work)
+		return false;
 
-	return scan;
-}
-
-int
-xfs_inode_free_quota_eofblocks(
-	struct xfs_inode *ip)
-{
-	return __xfs_inode_free_quota_eofblocks(ip, xfs_icache_free_eofblocks);
+	xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+	xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+	return true;
 }
 
 static inline unsigned long
@@ -1646,13 +1639,6 @@ xfs_icache_free_cowblocks(
 			XFS_ICI_COWBLOCKS_TAG);
 }
 
-int
-xfs_inode_free_quota_cowblocks(
-	struct xfs_inode *ip)
-{
-	return __xfs_inode_free_quota_eofblocks(ip, xfs_icache_free_cowblocks);
-}
-
 void
 xfs_inode_set_cowblocks_tag(
 	xfs_inode_t	*ip)
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 3a4c8b382cd0..3f7ddbca8638 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -54,17 +54,17 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 
+bool xfs_inode_free_quota_blocks(struct xfs_inode *ip);
+
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
-int xfs_inode_free_quota_eofblocks(struct xfs_inode *ip);
 void xfs_eofblocks_worker(struct work_struct *);
 void xfs_queue_eofblocks(struct xfs_mount *);
 
 void xfs_inode_set_cowblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_cowblocks(struct xfs_mount *, struct xfs_eofblocks *);
-int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
 void xfs_cowblocks_worker(struct work_struct *);
 void xfs_queue_cowblocks(struct xfs_mount *);
 

