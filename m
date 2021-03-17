Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BA533E89F
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Mar 2021 05:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhCQE5p (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 17 Mar 2021 00:57:45 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53704 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229761AbhCQE5M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Mar 2021 00:57:12 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AAFEB8282E9
        for <linux-xfs@vger.kernel.org>; Wed, 17 Mar 2021 15:57:10 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lMOF3-003R8G-3D
        for linux-xfs@vger.kernel.org; Wed, 17 Mar 2021 15:57:09 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lMOF2-002ja0-Rr
        for linux-xfs@vger.kernel.org; Wed, 17 Mar 2021 15:57:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: xfs_buf_item_size_segment() needs to pass segment offset
Date:   Wed, 17 Mar 2021 15:57:01 +1100
Message-Id: <20210317045706.651306-4-david@fromorbit.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317045706.651306-1-david@fromorbit.com>
References: <20210317045706.651306-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=kme4I8nbBunu55xL2I8A:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Otherwise it doesn't correctly calculate the number of vectors
in a logged buffer that has a contiguous map that gets split into
multiple regions because the range spans discontigous memory.

Probably never been hit in practice - we don't log contiguous ranges
on unmapped buffers (inode clusters).

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index cb8fd8afd140..189a4534e0b2 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -55,6 +55,18 @@ xfs_buf_log_format_size(
 			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
 }
 
+static inline bool
+xfs_buf_item_straddle(
+	struct xfs_buf		*bp,
+	uint			offset,
+	int			next_bit,
+	int			last_bit)
+{
+	return xfs_buf_offset(bp, offset + (next_bit << XFS_BLF_SHIFT)) !=
+		(xfs_buf_offset(bp, offset + (last_bit << XFS_BLF_SHIFT)) +
+		 XFS_BLF_CHUNK);
+}
+
 /*
  * This returns the number of log iovecs needed to log the
  * given buf log item.
@@ -69,6 +81,7 @@ STATIC void
 xfs_buf_item_size_segment(
 	struct xfs_buf_log_item		*bip,
 	struct xfs_buf_log_format	*blfp,
+	uint				offset,
 	int				*nvecs,
 	int				*nbytes)
 {
@@ -103,12 +116,8 @@ xfs_buf_item_size_segment(
 		 */
 		if (next_bit == -1) {
 			break;
-		} else if (next_bit != last_bit + 1) {
-			last_bit = next_bit;
-			(*nvecs)++;
-		} else if (xfs_buf_offset(bp, next_bit * XFS_BLF_CHUNK) !=
-			   (xfs_buf_offset(bp, last_bit * XFS_BLF_CHUNK) +
-			    XFS_BLF_CHUNK)) {
+		} else if (next_bit != last_bit + 1 ||
+		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {
 			last_bit = next_bit;
 			(*nvecs)++;
 		} else {
@@ -142,8 +151,10 @@ xfs_buf_item_size(
 	int			*nbytes)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	struct xfs_buf		*bp = bip->bli_buf;
 	int			i;
 	int			bytes;
+	uint			offset = 0;
 
 	ASSERT(atomic_read(&bip->bli_refcount) > 0);
 	if (bip->bli_flags & XFS_BLI_STALE) {
@@ -185,8 +196,9 @@ xfs_buf_item_size(
 	 */
 	bytes = 0;
 	for (i = 0; i < bip->bli_format_count; i++) {
-		xfs_buf_item_size_segment(bip, &bip->bli_formats[i],
+		xfs_buf_item_size_segment(bip, &bip->bli_formats[i], offset,
 					  nvecs, &bytes);
+		offset += BBTOB(bp->b_maps[i].bm_len);
 	}
 
 	/*
@@ -213,18 +225,6 @@ xfs_buf_item_copy_iovec(
 			nbits * XFS_BLF_CHUNK);
 }
 
-static inline bool
-xfs_buf_item_straddle(
-	struct xfs_buf		*bp,
-	uint			offset,
-	int			next_bit,
-	int			last_bit)
-{
-	return xfs_buf_offset(bp, offset + (next_bit << XFS_BLF_SHIFT)) !=
-		(xfs_buf_offset(bp, offset + (last_bit << XFS_BLF_SHIFT)) +
-		 XFS_BLF_CHUNK);
-}
-
 static void
 xfs_buf_item_format_segment(
 	struct xfs_buf_log_item	*bip,
-- 
2.30.1

