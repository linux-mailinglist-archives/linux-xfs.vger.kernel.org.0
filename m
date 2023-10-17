Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A849C7CC80D
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Oct 2023 17:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344086AbjJQPwh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Oct 2023 11:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343979AbjJQPwh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:52:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F02F1
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:52:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A095BC433C8;
        Tue, 17 Oct 2023 15:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557954;
        bh=sEkphj8T8UFZ+aoFmXOV4kjL3t8K4vcvFb3PiCM6aOk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=XHNZnPuR8T9xgxh7uAgql+TXyeV3b8x6+e8sWAkkZSEKwbZI6XYykVp+qDT6DBIKS
         uoRAg6BhHw7ab4r/6xeex5q4ezztcNcPhLvnDoIOBgrdTEv1cpfabcUEpI4R6mEljB
         rsaWgkZy317W8gPtCsINyGAg+UP5W1XHAYiejpdDdyBaLVYWimPUEYwCT9p4Q3HynR
         nrPAxRHgZy0ZcZd9ukGRfTD4ZWpOE9qRGn+XuBHwHnOAyFpefCXOgqVDsABkX9bUSP
         fkiGY7SA1T4OM+MIb+iqPg2so+z0tRjCeu/SRmST0xjKRkjEIEa/96pxYy8MZ02P1B
         3goDHZqZJoPtA==
Date:   Tue, 17 Oct 2023 08:52:34 -0700
Subject: [PATCH 3/8] xfs: convert open-coded xfs_rtword_t pointer accesses to
 helper
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     osandov@fb.com, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755742192.3167663.6373038058626360513.stgit@frogsfrogsfrogs>
In-Reply-To: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs>
References: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are a bunch of places where we use open-coded logic to find a
pointer to an xfs_rtword_t within a rt bitmap buffer.  Convert all that
to helper functions for better type safety.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   59 ++++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |   11 ++++++++
 2 files changed, 42 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 6ec539aa1b92..ce8a218f8e65 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -103,7 +103,6 @@ xfs_rtfind_back(
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtxnum_t	firstbit;	/* first useful bit in the word */
 	xfs_rtxnum_t	i;		/* current bit number rel. to start */
@@ -121,12 +120,12 @@ xfs_rtfind_back(
 	if (error) {
 		return error;
 	}
-	bufp = bp->b_addr;
+
 	/*
 	 * Get the first word's index & point to it.
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
-	b = &bufp[word];
+	b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	len = start - limit + 1;
 	/*
@@ -173,9 +172,9 @@ xfs_rtfind_back(
 			if (error) {
 				return error;
 			}
-			bufp = bp->b_addr;
+
 			word = mp->m_blockwsize - 1;
-			b = &bufp[word];
+			b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the previous word in the buffer.
@@ -219,9 +218,9 @@ xfs_rtfind_back(
 			if (error) {
 				return error;
 			}
-			bufp = bp->b_addr;
+
 			word = mp->m_blockwsize - 1;
-			b = &bufp[word];
+			b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the previous word in the buffer.
@@ -278,7 +277,6 @@ xfs_rtfind_forw(
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtxnum_t	i;		/* current bit number rel. to start */
 	xfs_rtxnum_t	lastbit;	/* last useful bit in the word */
@@ -296,12 +294,12 @@ xfs_rtfind_forw(
 	if (error) {
 		return error;
 	}
-	bufp = bp->b_addr;
+
 	/*
 	 * Get the first word's index & point to it.
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
-	b = &bufp[word];
+	b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	len = limit - start + 1;
 	/*
@@ -347,8 +345,9 @@ xfs_rtfind_forw(
 			if (error) {
 				return error;
 			}
-			b = bufp = bp->b_addr;
+
 			word = 0;
+			b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the previous word in the buffer.
@@ -392,8 +391,9 @@ xfs_rtfind_forw(
 			if (error) {
 				return error;
 			}
-			b = bufp = bp->b_addr;
+
 			word = 0;
+			b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the next word in the buffer.
@@ -541,7 +541,6 @@ xfs_rtmodify_range(
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtword_t	*first;		/* first used word in the buffer */
 	int		i;		/* current bit number rel. to start */
@@ -560,12 +559,12 @@ xfs_rtmodify_range(
 	if (error) {
 		return error;
 	}
-	bufp = bp->b_addr;
+
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
-	first = b = &bufp[word];
+	first = b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
 	 * 0 (allocated) => all zeroes; 1 (free) => all ones.
@@ -599,14 +598,15 @@ xfs_rtmodify_range(
 			 * Get the next one.
 			 */
 			xfs_trans_log_buf(tp, bp,
-				(uint)((char *)first - (char *)bufp),
-				(uint)((char *)b - (char *)bufp));
+				(uint)((char *)first - (char *)bp->b_addr),
+				(uint)((char *)b - (char *)bp->b_addr));
 			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
-			first = b = bufp = bp->b_addr;
+
 			word = 0;
+			first = b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the next word in the buffer
@@ -639,14 +639,15 @@ xfs_rtmodify_range(
 			 * Get the next one.
 			 */
 			xfs_trans_log_buf(tp, bp,
-				(uint)((char *)first - (char *)bufp),
-				(uint)((char *)b - (char *)bufp));
+				(uint)((char *)first - (char *)bp->b_addr),
+				(uint)((char *)b - (char *)bp->b_addr));
 			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
 			if (error) {
 				return error;
 			}
-			first = b = bufp = bp->b_addr;
+
 			word = 0;
+			first = b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the next word in the buffer
@@ -676,8 +677,9 @@ xfs_rtmodify_range(
 	 * Log any remaining changed bytes.
 	 */
 	if (b > first)
-		xfs_trans_log_buf(tp, bp, (uint)((char *)first - (char *)bufp),
-			(uint)((char *)b - (char *)bufp - 1));
+		xfs_trans_log_buf(tp, bp,
+			(uint)((char *)first - (char *)bp->b_addr),
+			(uint)((char *)b - (char *)bp->b_addr - 1));
 	return 0;
 }
 
@@ -775,7 +777,6 @@ xfs_rtcheck_range(
 	int		bit;		/* bit number in the word */
 	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
 	xfs_rtxnum_t	i;		/* current bit number rel. to start */
 	xfs_rtxnum_t	lastbit;	/* last useful bit in word */
@@ -794,12 +795,12 @@ xfs_rtcheck_range(
 	if (error) {
 		return error;
 	}
-	bufp = bp->b_addr;
+
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
 	word = xfs_rtx_to_rbmword(mp, start);
-	b = &bufp[word];
+	b = xfs_rbmblock_wordptr(bp, word);
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
 	 * 0 (allocated) => all zero's; 1 (free) => all one's.
@@ -845,8 +846,9 @@ xfs_rtcheck_range(
 			if (error) {
 				return error;
 			}
-			b = bufp = bp->b_addr;
+
 			word = 0;
+			b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the next word in the buffer.
@@ -891,8 +893,9 @@ xfs_rtcheck_range(
 			if (error) {
 				return error;
 			}
-			b = bufp = bp->b_addr;
+
 			word = 0;
+			b = xfs_rbmblock_wordptr(bp, word);
 		} else {
 			/*
 			 * Go on to the next word in the buffer.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index a382b38c6c30..3252ed217a6a 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -158,6 +158,17 @@ xfs_rbmblock_to_rtx(
 	return rbmoff << mp->m_blkbit_log;
 }
 
+/* Return a pointer to a bitmap word within a rt bitmap block. */
+static inline xfs_rtword_t *
+xfs_rbmblock_wordptr(
+	struct xfs_buf		*bp,
+	unsigned int		index)
+{
+	xfs_rtword_t		*words = bp->b_addr;
+
+	return words + index;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */

