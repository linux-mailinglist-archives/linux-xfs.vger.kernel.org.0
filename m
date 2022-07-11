Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088E056AF1C
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Jul 2022 01:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236588AbiGGXnw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Jul 2022 19:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236766AbiGGXnw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 19:43:52 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1DBDD6B250
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 16:43:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6814A62C8D9
        for <linux-xfs@vger.kernel.org>; Fri,  8 Jul 2022 09:43:49 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9b9w-00FoQU-Jk
        for linux-xfs@vger.kernel.org; Fri, 08 Jul 2022 09:43:48 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o9b9w-004bQR-IU
        for linux-xfs@vger.kernel.org;
        Fri, 08 Jul 2022 09:43:48 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/9] xfs: clean up xfs_iunlink_update_inode()
Date:   Fri,  8 Jul 2022 09:43:42 +1000
Message-Id: <20220707234345.1097095-7-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707234345.1097095-1-david@fromorbit.com>
References: <20220707234345.1097095-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62c76fb5
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=RgO8CyIxsXoA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=lcWF9bCBezxXo5iAazoA:9 a=AjGcO6oz07-iQ99wixmX:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We no longer need to have this function return the previous next
agino value from the on-disk inode as we have it in the in-core
inode now.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 55fe1321160a..208f71240173 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1935,13 +1935,12 @@ xfs_iunlink_update_dinode(
 }
 
 /* Set an in-core inode's unlinked pointer and return the old value. */
-STATIC int
+static int
 xfs_iunlink_update_inode(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
-	xfs_agino_t		next_agino,
-	xfs_agino_t		*old_next_agino)
+	xfs_agino_t		next_agino)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_dinode	*dip;
@@ -1971,8 +1970,6 @@ xfs_iunlink_update_inode(
 	 * current pointer is the same as the new value, unless we're
 	 * terminating the list.
 	 */
-	if (old_next_agino)
-		*old_next_agino = old_value;
 	if (old_value == next_agino) {
 		if (next_agino != NULLAGINO) {
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
@@ -2026,17 +2023,13 @@ xfs_iunlink_insert_inode(
 		return error;
 
 	if (next_agino != NULLAGINO) {
-		xfs_agino_t		old_agino;
-
 		/*
 		 * There is already another inode in the bucket, so point this
 		 * inode to the current head of the list.
 		 */
-		error = xfs_iunlink_update_inode(tp, ip, pag, next_agino,
-				&old_agino);
+		error = xfs_iunlink_update_inode(tp, ip, pag, next_agino);
 		if (error)
 			return error;
-		ASSERT(old_agino == NULLAGINO);
 		ip->i_next_unlinked = next_agino;
 	}
 
@@ -2088,7 +2081,6 @@ xfs_iunlink_remove_inode(
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agi		*agi = agibp->b_addr;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	xfs_agino_t		next_agino;
 	xfs_agino_t		head_agino;
 	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
 	int			error;
@@ -2111,7 +2103,7 @@ xfs_iunlink_remove_inode(
 	 * the old pointer value so that we can update whatever was previous
 	 * to us in the list to point to whatever was next in the list.
 	 */
-	error = xfs_iunlink_update_inode(tp, ip, pag, NULLAGINO, &next_agino);
+	error = xfs_iunlink_update_inode(tp, ip, pag, NULLAGINO);
 	if (error)
 		return error;
 
@@ -2132,7 +2124,7 @@ xfs_iunlink_remove_inode(
 			return -EFSCORRUPTED;
 
 		error = xfs_iunlink_update_inode(tp, prev_ip, pag,
-				ip->i_next_unlinked, NULL);
+				ip->i_next_unlinked);
 		prev_ip->i_next_unlinked = ip->i_next_unlinked;
 	} else {
 		/* Point the head of the list to the next unlinked inode. */
-- 
2.36.1

