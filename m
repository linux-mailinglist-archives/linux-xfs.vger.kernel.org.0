Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6424E1EDED0
	for <lists+linux-xfs@lfdr.de>; Thu,  4 Jun 2020 09:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgFDHqX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 4 Jun 2020 03:46:23 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:49320 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728021AbgFDHqV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 03:46:21 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 57EE8D5995F
        for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2020 17:46:13 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgkZk-0004Ak-9Q
        for linux-xfs@vger.kernel.org; Thu, 04 Jun 2020 17:46:08 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jgkZk-0017I9-16
        for linux-xfs@vger.kernel.org; Thu, 04 Jun 2020 17:46:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 21/30] xfs: remove SYNC_TRYLOCK from inode reclaim
Date:   Thu,  4 Jun 2020 17:45:57 +1000
Message-Id: <20200604074606.266213-22-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200604074606.266213-1-david@fromorbit.com>
References: <20200604074606.266213-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=wwBL6EluFSDcluHKyHoA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

All background reclaim is SYNC_TRYLOCK already, and even blocking
reclaim (SYNC_WAIT) can use trylock mechanisms as
xfs_reclaim_inodes_ag() will keep cycling until there are no more
reclaimable inodes. Hence we can kill SYNC_TRYLOCK from inode
reclaim and make everything unconditionally non-blocking.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d1c47a0e0b0ec..ebe55124d6cb8 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -174,7 +174,7 @@ xfs_reclaim_worker(
 	struct xfs_mount *mp = container_of(to_delayed_work(work),
 					struct xfs_mount, m_reclaim_work);
 
-	xfs_reclaim_inodes(mp, SYNC_TRYLOCK);
+	xfs_reclaim_inodes(mp, 0);
 	xfs_reclaim_work_queue(mp);
 }
 
@@ -1030,10 +1030,9 @@ xfs_cowblocks_worker(
  * Grab the inode for reclaim exclusively.
  * Return 0 if we grabbed it, non-zero otherwise.
  */
-STATIC int
+static int
 xfs_reclaim_inode_grab(
-	struct xfs_inode	*ip,
-	int			flags)
+	struct xfs_inode	*ip)
 {
 	ASSERT(rcu_read_lock_held());
 
@@ -1042,12 +1041,10 @@ xfs_reclaim_inode_grab(
 		return 1;
 
 	/*
-	 * If we are asked for non-blocking operation, do unlocked checks to
-	 * see if the inode already is being flushed or in reclaim to avoid
-	 * lock traffic.
+	 * Do unlocked checks to see if the inode already is being flushed or in
+	 * reclaim to avoid lock traffic.
 	 */
-	if ((flags & SYNC_TRYLOCK) &&
-	    __xfs_iflags_test(ip, XFS_IFLOCK | XFS_IRECLAIM))
+	if (__xfs_iflags_test(ip, XFS_IFLOCK | XFS_IRECLAIM))
 		return 1;
 
 	/*
@@ -1114,8 +1111,7 @@ xfs_reclaim_inode_grab(
 static bool
 xfs_reclaim_inode(
 	struct xfs_inode	*ip,
-	struct xfs_perag	*pag,
-	int			sync_mode)
+	struct xfs_perag	*pag)
 {
 	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
 
@@ -1209,7 +1205,6 @@ xfs_reclaim_inode(
 static int
 xfs_reclaim_inodes_ag(
 	struct xfs_mount	*mp,
-	int			flags,
 	int			*nr_to_scan)
 {
 	struct xfs_perag	*pag;
@@ -1254,7 +1249,7 @@ xfs_reclaim_inodes_ag(
 			for (i = 0; i < nr_found; i++) {
 				struct xfs_inode *ip = batch[i];
 
-				if (done || xfs_reclaim_inode_grab(ip, flags))
+				if (done || xfs_reclaim_inode_grab(ip))
 					batch[i] = NULL;
 
 				/*
@@ -1285,7 +1280,7 @@ xfs_reclaim_inodes_ag(
 			for (i = 0; i < nr_found; i++) {
 				if (!batch[i])
 					continue;
-				if (!xfs_reclaim_inode(batch[i], pag, flags))
+				if (!xfs_reclaim_inode(batch[i], pag))
 					skipped++;
 			}
 
@@ -1311,13 +1306,13 @@ xfs_reclaim_inodes(
 	int		nr_to_scan = INT_MAX;
 	int		skipped;
 
-	xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
+	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
 	if (!(mode & SYNC_WAIT))
 		return 0;
 
 	do {
 		xfs_ail_push_all_sync(mp->m_ail);
-		skipped = xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
+		skipped = xfs_reclaim_inodes_ag(mp, &nr_to_scan);
 	} while (skipped > 0);
 
 	return 0;
@@ -1341,7 +1336,7 @@ xfs_reclaim_inodes_nr(
 	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
 
-	xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
+	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
 	return 0;
 }
 
-- 
2.26.2.761.g0e0b3e54be

