Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A87F2FAD31
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Jan 2021 23:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388051AbhARWOF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 18 Jan 2021 17:14:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388385AbhARWOE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:14:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 999CC22DD3;
        Mon, 18 Jan 2021 22:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611008003;
        bh=GYndIRUE5HUNFstT9X5Mojm5wZ7DhH8MoiiK10bvbMM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e2p6yVl6gSop3IrZ6yTgteaT7J7hQq8LDZR6iL24LHmxx4g0ObcNBis9ZGLjlUPUn
         mfrcZ277tCEwUJe4yx0jf63LrLv5/nxZGRf3MqucwAhfcqC6tCZHdNTwgOkNIpML6s
         5ka4tRbFruN4EsDF5r01MqfpKIP6tMSE0K/Ay6rJ67LF31kY4d5NPw3pxI3h9/6qzm
         gtLmgNwEmzC//UjCezhRqWLvir895Zy6c04MwfwGroxrQCOnYTiwBoe7kLT7J1NOK7
         05em8KR/zHNw9HTe4ZUJuCKJlW8kNMQ81f4s14xZccHRLVo7FEGbhlbM2HsD/uDsCu
         ya32QX7K//uhQ==
Subject: [PATCH 04/10] xfs: remove trivial eof/cowblocks functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:13:23 -0800
Message-ID: <161100800330.90204.7868136774892860968.stgit@magnolia>
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

Get rid of these trivial helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 097dd979e182..1d06dcc4339e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1324,15 +1324,6 @@ xfs_inode_free_eofblocks(
 	return ret;
 }
 
-static int
-xfs_icache_free_eofblocks(
-	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
-{
-	return xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, eofb,
-			XFS_ICI_EOFBLOCKS_TAG);
-}
-
 /*
  * Background scanning to trim post-EOF preallocated space. This is queued
  * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
@@ -1358,7 +1349,8 @@ xfs_eofblocks_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	xfs_icache_free_eofblocks(mp, NULL);
+	xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, NULL,
+			XFS_ICI_EOFBLOCKS_TAG);
 	sb_end_write(mp->m_super);
 
 	xfs_queue_eofblocks(mp);
@@ -1567,15 +1559,6 @@ xfs_inode_free_cowblocks(
 	return ret;
 }
 
-static int
-xfs_icache_free_cowblocks(
-	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
-{
-	return xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, eofb,
-			XFS_ICI_COWBLOCKS_TAG);
-}
-
 /*
  * Background scanning to trim preallocated CoW space. This is queued
  * based on the 'speculative_cow_prealloc_lifetime' tunable (5m by default).
@@ -1602,7 +1585,8 @@ xfs_cowblocks_worker(
 
 	if (!sb_start_write_trylock(mp->m_super))
 		return;
-	xfs_icache_free_cowblocks(mp, NULL);
+	xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, NULL,
+			XFS_ICI_COWBLOCKS_TAG);
 	sb_end_write(mp->m_super);
 
 	xfs_queue_cowblocks(mp);
@@ -1653,11 +1637,13 @@ xfs_blockgc_scan(
 {
 	int			error;
 
-	error = xfs_icache_free_eofblocks(mp, eofb);
+	error = xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, eofb,
+			XFS_ICI_EOFBLOCKS_TAG);
 	if (error)
 		return error;
 
-	error = xfs_icache_free_cowblocks(mp, eofb);
+	error = xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, eofb,
+			XFS_ICI_COWBLOCKS_TAG);
 	if (error)
 		return error;
 

