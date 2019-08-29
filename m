Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0B1A1688
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Aug 2019 12:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfH2KrR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Aug 2019 06:47:17 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58234 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726416AbfH2KrR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 06:47:17 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 154BA43D74E
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 20:47:14 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3HxQ-00032c-K5
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 20:47:12 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3HxQ-0007OB-II
        for linux-xfs@vger.kernel.org; Thu, 29 Aug 2019 20:47:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfs: speed up directory bestfree block scanning
Date:   Thu, 29 Aug 2019 20:47:09 +1000
Message-Id: <20190829104710.28239-5-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190829104710.28239-1-david@fromorbit.com>
References: <20190829104710.28239-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=FmdZ9Uzk2mMA:10 a=20KFwNOVAAAA:8
        a=6DkO27ogrPW1xkOiNbQA:9 a=9pmo21znTE8r5vfF:21 a=BqtYXfbjRhmUaEUB:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When running a "create millions inodes in a directory" test
recently, I noticed we were spending a huge amount of time
converting freespace block headers from disk format to in-memory
format:

 31.47%  [kernel]  [k] xfs_dir2_node_addname
 17.86%  [kernel]  [k] xfs_dir3_free_hdr_from_disk
  3.55%  [kernel]  [k] xfs_dir3_free_bests_p

We shouldn't be hitting the best free block scanning code so hard
when doing sequential directory creates, and it turns out there's
a highly suboptimal loop searching the the best free array in
the freespace block - it decodes the block header before checking
each entry inside a loop, instead of decoding the header once before
running the entry search loop.

This makes a massive difference to create rates. Profile now looks
like this:

  13.15%  [kernel]  [k] xfs_dir2_node_addname
   3.52%  [kernel]  [k] xfs_dir3_leaf_check_int
   3.11%  [kernel]  [k] xfs_log_commit_cil

And the wall time/average file create rate differences are
just as stark:

		create time(sec) / rate (files/s)
File count	     vanilla		    patched
  10k		   0.41 / 24.3k		   0.42 / 23.8k
  20k		   0.74	/ 27.0k		   0.76 / 26.3k
 100k		   3.81	/ 26.4k		   3.47 / 28.8k
 200k		   8.58	/ 23.3k		   7.19 / 27.8k
   1M		  85.69	/ 11.7k		  48.53 / 20.6k
   2M		 280.31	/  7.1k		 130.14 / 15.3k

The larger the directory, the bigger the performance improvement.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 97 ++++++++++++-----------------------
 1 file changed, 34 insertions(+), 63 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 93254f45a5f9..a81f56d9e538 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1750,8 +1750,8 @@ xfs_dir2_node_find_freeblk(
 	xfs_dir2_db_t		dbno = -1;
 	xfs_dir2_db_t		fbno = -1;
 	xfs_fileoff_t		fo;
-	__be16			*bests;
-	int			findex;
+	__be16			*bests = NULL;
+	int			findex = 0;
 	int			error;
 
 	/*
@@ -1781,14 +1781,14 @@ xfs_dir2_node_find_freeblk(
 		 */
 		ifbno = fblk->blkno;
 		fbno = ifbno;
+		xfs_trans_brelse(tp, fbp);
+		fbp = NULL;
+		fblk->bp = NULL;
 	}
-	ASSERT(dbno == -1);
-	findex = 0;
 
 	/*
 	 * If we don't have a data block yet, we're going to scan the freespace
-	 * blocks looking for one.  Figure out what the highest freespace block
-	 * number is.
+	 * data for a data block with enough free space in it.
 	 */
 	error = xfs_bmap_last_offset(dp, &fo, XFS_DATA_FORK);
 	if (error)
@@ -1799,70 +1799,41 @@ xfs_dir2_node_find_freeblk(
 	if (fbno == -1)
 		fbno = xfs_dir2_byte_to_db(args->geo, XFS_DIR2_FREE_OFFSET);
 
-	/*
-	 * While we haven't identified a data block, search the freeblock
-	 * data for a good data block.  If we find a null freeblock entry,
-	 * indicating a hole in the data blocks, remember that.
-	 */
-	while (dbno == -1) {
-		/*
-		 * If we don't have a freeblock in hand, get the next one.
-		 */
-		if (fbp == NULL) {
-			/*
-			 * If it's ifbno we already looked at it.
-			 */
-			if (++fbno == ifbno)
-				fbno++;
-			/*
-			 * If it's off the end we're done.
-			 */
-			if (fbno >= lastfbno)
-				break;
-			/*
-			 * Read the block.  There can be holes in the
-			 * freespace blocks, so this might not succeed.
-			 * This should be really rare, so there's no reason
-			 * to avoid it.
-			 */
-			error = xfs_dir2_free_try_read(tp, dp,
-					xfs_dir2_db_to_da(args->geo, fbno),
-					&fbp);
-			if (error)
-				return error;
-			if (!fbp)
-				continue;
-			free = fbp->b_addr;
-			findex = 0;
-		}
+	for ( ; fbno < lastfbno; fbno++) {
+		/* If it's ifbno we already looked at it. */
+		if (fbno == ifbno)
+			continue;
+
 		/*
-		 * Look at the current free entry.  Is it good enough?
-		 *
-		 * The bests initialisation should be where the bufer is read in
-		 * the above branch. But gcc is too stupid to realise that bests
-		 * and the freehdr are actually initialised if they are placed
-		 * there, so we have to do it here to avoid warnings. Blech.
+		 * Read the block.  There can be holes in the freespace blocks,
+		 * so this might not succeed.  This should be really rare, so
+		 * there's no reason to avoid it.
 		 */
+		error = xfs_dir2_free_try_read(tp, dp,
+				xfs_dir2_db_to_da(args->geo, fbno),
+				&fbp);
+		if (error)
+			return error;
+		if (!fbp)
+			continue;
+
+		free = fbp->b_addr;
 		bests = dp->d_ops->free_bests_p(free);
 		dp->d_ops->free_hdr_from_disk(&freehdr, free);
-		if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
-		    be16_to_cpu(bests[findex]) >= length)
-			dbno = freehdr.firstdb + findex;
-		else {
-			/*
-			 * Are we done with the freeblock?
-			 */
-			if (++findex == freehdr.nvalid) {
-				/*
-				 * Drop the block.
-				 */
-				xfs_trans_brelse(tp, fbp);
-				fbp = NULL;
-				if (fblk && fblk->bp)
-					fblk->bp = NULL;
+
+		/* Scan the free entry array for a large enough free space. */
+		for (findex = 0; findex < freehdr.nvalid; findex++) {
+			if (be16_to_cpu(bests[findex]) != NULLDATAOFF &&
+			    be16_to_cpu(bests[findex]) >= length) {
+				dbno = freehdr.firstdb + findex;
+				goto found_block;
 			}
 		}
+
+		/* Didn't find free space, go on to next free block */
+		xfs_trans_brelse(tp, fbp);
 	}
+
 found_block:
 	*dbnop = dbno;
 	*fbpp = fbp;
-- 
2.23.0.rc1

