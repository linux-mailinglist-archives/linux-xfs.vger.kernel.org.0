Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB85B33E8A6
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Mar 2021 05:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhCQE5q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 17 Mar 2021 00:57:46 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:50844 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhCQE5X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Mar 2021 00:57:23 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id A9BD678B3A3
        for <linux-xfs@vger.kernel.org>; Wed, 17 Mar 2021 15:57:10 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lMOF3-003R8M-4K
        for linux-xfs@vger.kernel.org; Wed, 17 Mar 2021 15:57:09 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lMOF2-002ja3-Ss
        for linux-xfs@vger.kernel.org; Wed, 17 Mar 2021 15:57:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfs: optimise xfs_buf_item_size/format for contiguous regions
Date:   Wed, 17 Mar 2021 15:57:02 +1100
Message-Id: <20210317045706.651306-5-david@fromorbit.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317045706.651306-1-david@fromorbit.com>
References: <20210317045706.651306-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=VGz6NFykJe5wMMP_S7kA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We process the buf_log_item bitmap one set bit at a time with
xfs_next_bit() so we can detect if a region crosses a memcpy
discontinuity in the buffer data address. This has massive overhead
on large buffers (e.g. 64k directory blocks) because we do a lot of
unnecessary checks and xfs_buf_offset() calls.

For example, 16-way concurrent create workload on debug kernel
running CPU bound has this at the top of the profile at ~120k
create/s on 64kb directory block size:

  20.66%  [kernel]  [k] xfs_dir3_leaf_check_int
   7.10%  [kernel]  [k] memcpy
   6.22%  [kernel]  [k] xfs_next_bit
   3.55%  [kernel]  [k] xfs_buf_offset
   3.53%  [kernel]  [k] xfs_buf_item_format
   3.34%  [kernel]  [k] __pv_queued_spin_lock_slowpath
   3.04%  [kernel]  [k] do_raw_spin_lock
   2.84%  [kernel]  [k] xfs_buf_item_size_segment.isra.0
   2.31%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
   1.36%  [kernel]  [k] xfs_log_commit_cil

(debug checks hurt large blocks)

The only buffers with discontinuities in the data address are
unmapped buffers, and they are only used for inode cluster buffers
and only for logging unlinked pointers. IOWs, it is -rare- that we
even need to detect a discontinuity in the buffer item formatting
code.

Optimise all this by using xfs_contig_bits() to find the size of
the contiguous regions, then test for a discontiunity inside it. If
we find one, do the slow "bit at a time" method we do now. If we
don't, then just copy the entire contiguous range in one go.

Profile now looks like:

  25.26%  [kernel]  [k] xfs_dir3_leaf_check_int
   9.25%  [kernel]  [k] memcpy
   5.01%  [kernel]  [k] __pv_queued_spin_lock_slowpath
   2.84%  [kernel]  [k] do_raw_spin_lock
   2.22%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock
   1.88%  [kernel]  [k] xfs_buf_find
   1.53%  [kernel]  [k] memmove
   1.47%  [kernel]  [k] xfs_log_commit_cil
....
   0.34%  [kernel]  [k] xfs_buf_item_format
....
   0.21%  [kernel]  [k] xfs_buf_offset
....
   0.16%  [kernel]  [k] xfs_contig_bits
....
   0.13%  [kernel]  [k] xfs_buf_item_size_segment.isra.0

So the bit scanning over for the dirty region tracking for the
buffer log items is basically gone. Debug overhead hurts even more
now...

Perf comparison

		dir block	 creates		unlink
		size (kb)	time	rate		time

Original	 4		4m08s	220k		 5m13s
Original	64		7m21s	115k		13m25s
Patched		 4		3m59s	230k		 5m03s
Patched		64		6m23s	143k		12m33s

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c | 102 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 87 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 189a4534e0b2..fb69879e4b2b 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -59,12 +59,18 @@ static inline bool
 xfs_buf_item_straddle(
 	struct xfs_buf		*bp,
 	uint			offset,
-	int			next_bit,
-	int			last_bit)
+	int			first_bit,
+	int			nbits)
 {
-	return xfs_buf_offset(bp, offset + (next_bit << XFS_BLF_SHIFT)) !=
-		(xfs_buf_offset(bp, offset + (last_bit << XFS_BLF_SHIFT)) +
-		 XFS_BLF_CHUNK);
+	void			*first, *last;
+
+	first = xfs_buf_offset(bp, offset + (first_bit << XFS_BLF_SHIFT));
+	last = xfs_buf_offset(bp,
+			offset + ((first_bit + nbits) << XFS_BLF_SHIFT));
+
+	if (last - first != nbits * XFS_BLF_CHUNK)
+		return true;
+	return false;
 }
 
 /*
@@ -86,20 +92,51 @@ xfs_buf_item_size_segment(
 	int				*nbytes)
 {
 	struct xfs_buf			*bp = bip->bli_buf;
+	int				first_bit;
+	int				nbits;
 	int				next_bit;
 	int				last_bit;
 
-	last_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
-	if (last_bit == -1)
+	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
+	if (first_bit == -1)
 		return;
 
-	/*
-	 * initial count for a dirty buffer is 2 vectors - the format structure
-	 * and the first dirty region.
-	 */
-	*nvecs += 2;
-	*nbytes += xfs_buf_log_format_size(blfp) + XFS_BLF_CHUNK;
+	(*nvecs)++;
+	*nbytes += xfs_buf_log_format_size(blfp);
+
+	do {
+		nbits = xfs_contig_bits(blfp->blf_data_map,
+					blfp->blf_map_size, first_bit);
+		ASSERT(nbits > 0);
+
+		/*
+		 * Straddling a page is rare because we don't log contiguous
+		 * chunks of unmapped buffers anywhere.
+		 */
+		if (nbits > 1 &&
+		    xfs_buf_item_straddle(bp, offset, first_bit, nbits))
+			goto slow_scan;
+
+		(*nvecs)++;
+		*nbytes += nbits * XFS_BLF_CHUNK;
+
+		/*
+		 * This takes the bit number to start looking from and
+		 * returns the next set bit from there.  It returns -1
+		 * if there are no more bits set or the start bit is
+		 * beyond the end of the bitmap.
+		 */
+		first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
+					(uint)first_bit + nbits + 1);
+	} while (first_bit != -1);
 
+	return;
+
+slow_scan:
+	/* Count the first bit we jumped out of the above loop from */
+	(*nvecs)++;
+	*nbytes += XFS_BLF_CHUNK;
+	last_bit = first_bit;
 	while (last_bit != -1) {
 		/*
 		 * This takes the bit number to start looking from and
@@ -117,11 +154,14 @@ xfs_buf_item_size_segment(
 		if (next_bit == -1) {
 			break;
 		} else if (next_bit != last_bit + 1 ||
-		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {
+		           xfs_buf_item_straddle(bp, offset, first_bit, nbits)) {
 			last_bit = next_bit;
+			first_bit = next_bit;
 			(*nvecs)++;
+			nbits = 1;
 		} else {
 			last_bit++;
+			nbits++;
 		}
 		*nbytes += XFS_BLF_CHUNK;
 	}
@@ -277,6 +317,38 @@ xfs_buf_item_format_segment(
 	/*
 	 * Fill in an iovec for each set of contiguous chunks.
 	 */
+	do {
+		ASSERT(first_bit >= 0);
+		nbits = xfs_contig_bits(blfp->blf_data_map,
+					blfp->blf_map_size, first_bit);
+		ASSERT(nbits > 0);
+
+		/*
+		 * Straddling a page is rare because we don't log contiguous
+		 * chunks of unmapped buffers anywhere.
+		 */
+		if (nbits > 1 &&
+		    xfs_buf_item_straddle(bp, offset, first_bit, nbits))
+			goto slow_scan;
+
+		xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
+					first_bit, nbits);
+		blfp->blf_size++;
+
+		/*
+		 * This takes the bit number to start looking from and
+		 * returns the next set bit from there.  It returns -1
+		 * if there are no more bits set or the start bit is
+		 * beyond the end of the bitmap.
+		 */
+		first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
+					(uint)first_bit + nbits + 1);
+	} while (first_bit != -1);
+
+	return;
+
+slow_scan:
+	ASSERT(bp->b_addr == NULL);
 	last_bit = first_bit;
 	nbits = 1;
 	for (;;) {
@@ -301,7 +373,7 @@ xfs_buf_item_format_segment(
 			blfp->blf_size++;
 			break;
 		} else if (next_bit != last_bit + 1 ||
-		           xfs_buf_item_straddle(bp, offset, next_bit, last_bit)) {
+		           xfs_buf_item_straddle(bp, offset, first_bit, nbits)) {
 			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
 						first_bit, nbits);
 			blfp->blf_size++;
-- 
2.30.1

