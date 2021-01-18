Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2E12FAD3B
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Jan 2021 23:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388461AbhARWOf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 18 Jan 2021 17:14:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387793AbhARWOc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:14:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3433922E02;
        Mon, 18 Jan 2021 22:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611008031;
        bh=/SW4JpMkC7bKXebA5Dm1IvQjijPi9Jt9uGsQL1Bx7o8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XAKUAy1lq4vTdugZ6MORdlEcT11MqmjvPg4/gT2SiaKX0DRYX12IU4LeDIU1gKhR6
         ikE7Hde8Z6opVjNVnjBUh/mV8HygnUEdq1SycL297Mpr+bWpEFEWWi+wDBIXLBqSb4
         +sRo7G6Db3GNBVxUbpWKEUPff3oXhTI6IDxKR+34ilExDpoFbQ2FamieTcVYFSnkHH
         1YI6kM6QQQoYUF7cjqWvDEVgdvnUwC8B3NNJXouRflNs3ZEf7bXwUR5FR5uDy6Wr4l
         cCElrHcuRImtsc6jeEynO26tumGKb7FKdrCFPb+DS7Gxe4/OC4CyIbrnGBdek/Sft2
         9EWQBb+oH6EVw==
Subject: [PATCH 09/10] xfs: rename block gc start and stop functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:13:50 -0800
Message-ID: <161100803088.90204.8044732475042908474.stgit@magnolia>
In-Reply-To: <161100798100.90204.7839064495063223590.stgit@magnolia>
References: <161100798100.90204.7839064495063223590.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Shorten the names of the two functions that start and stop block
preallocation garbage collection and move them up to the other blockgc
functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c |    4 ++--
 fs/xfs/xfs_icache.c   |    4 ++--
 fs/xfs/xfs_icache.h   |    4 ++--
 fs/xfs/xfs_mount.c    |    2 +-
 fs/xfs/xfs_super.c    |    8 ++++----
 5 files changed, 11 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 8ea6d4aa3f55..53456f3de881 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -888,7 +888,7 @@ xchk_stop_reaping(
 	struct xfs_scrub	*sc)
 {
 	sc->flags |= XCHK_REAPING_DISABLED;
-	xfs_stop_block_reaping(sc->mp);
+	xfs_blockgc_stop(sc->mp);
 }
 
 /* Restart background reaping of resources. */
@@ -896,6 +896,6 @@ void
 xchk_start_reaping(
 	struct xfs_scrub	*sc)
 {
-	xfs_start_block_reaping(sc->mp);
+	xfs_blockgc_start(sc->mp);
 	sc->flags &= ~XCHK_REAPING_DISABLED;
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c02627be7c74..8ef90091ed7d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1557,7 +1557,7 @@ xfs_inode_clear_cowblocks_tag(
 
 /* Disable post-EOF and CoW block auto-reclamation. */
 void
-xfs_stop_block_reaping(
+xfs_blockgc_stop(
 	struct xfs_mount	*mp)
 {
 	cancel_delayed_work_sync(&mp->m_blockgc_work);
@@ -1565,7 +1565,7 @@ xfs_stop_block_reaping(
 
 /* Enable post-EOF and CoW block auto-reclamation. */
 void
-xfs_start_block_reaping(
+xfs_blockgc_start(
 	struct xfs_mount	*mp)
 {
 	xfs_blockgc_queue(mp);
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index e5c3306da05b..a4795c882586 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -76,7 +76,7 @@ int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
 
-void xfs_stop_block_reaping(struct xfs_mount *mp);
-void xfs_start_block_reaping(struct xfs_mount *mp);
+void xfs_blockgc_stop(struct xfs_mount *mp);
+void xfs_blockgc_start(struct xfs_mount *mp);
 
 #endif
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7110507a2b6b..ffafe7f4acaf 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1054,7 +1054,7 @@ xfs_unmountfs(
 	uint64_t		resblks;
 	int			error;
 
-	xfs_stop_block_reaping(mp);
+	xfs_blockgc_stop(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
 	xfs_rtunmount_inodes(mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 89a6c9bf6ae9..83f79ff41114 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -920,7 +920,7 @@ xfs_fs_freeze(
 	 * set a GFP_NOFS context here to avoid recursion deadlocks.
 	 */
 	flags = memalloc_nofs_save();
-	xfs_stop_block_reaping(mp);
+	xfs_blockgc_stop(mp);
 	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
 	ret = xfs_sync_sb(mp, true);
@@ -936,7 +936,7 @@ xfs_fs_unfreeze(
 
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
-	xfs_start_block_reaping(mp);
+	xfs_blockgc_start(mp);
 	return 0;
 }
 
@@ -1720,7 +1720,7 @@ xfs_remount_rw(
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return error;
 	}
-	xfs_start_block_reaping(mp);
+	xfs_blockgc_start(mp);
 
 	/* Create the per-AG metadata reservation pool .*/
 	error = xfs_fs_reserve_ag_blocks(mp);
@@ -1740,7 +1740,7 @@ xfs_remount_ro(
 	 * Cancel background eofb scanning so it cannot race with the final
 	 * log force+buftarg wait and deadlock the remount.
 	 */
-	xfs_stop_block_reaping(mp);
+	xfs_blockgc_stop(mp);
 
 	/* Get rid of any leftover CoW reservations... */
 	error = xfs_blockgc_free_space(mp, NULL);

