Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C88B7CC809
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Oct 2023 17:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344027AbjJQPwF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Oct 2023 11:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343939AbjJQPwF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:52:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D4295
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:52:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DDDC433C7;
        Tue, 17 Oct 2023 15:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557923;
        bh=UkpyFiVgvfAQaeiK6vCqTjaFFlJ1X0j+kCeA8CyVsaI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Kcz4CacxyDQT4XYOoc9eeN2EHRTfX8pRMtqToPj6Wr+xtPyuY3jM3GnY4l1APIxhw
         il3jOinx3YWZvIFPPVSlvkfWP93cq7Ml/2I/xD+cHmUkkV5NsVxue9rfucbGD4o+zv
         gHu0O9IWv2baReztbPYvLgSHyiWjSRbyFhOUPAN7bTPm6uwWVub57P6IUiC6Y4LVtr
         /sBUfH3bCTkTUWqTDpoCizwQoJObDSv2jnbkvVE5VfadI0ykEp/gTwV8gQb1/Mas7F
         94xFJI3+n04VKZT59lJEQY0uwJBAD2gSYH+NNziYm/jn/OLuajPlOeeNsjzgJ7g0Lx
         4FBAiRVnBRHkw==
Date:   Tue, 17 Oct 2023 08:52:02 -0700
Subject: [PATCH 1/8] xfs: convert the rtbitmap block and bit macros to static
 inline functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755742161.3167663.2997632418806236639.stgit@frogsfrogsfrogs>
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

Replace these macros with typechecked helper functions.  Eventually
we're going to add more logic to the helpers and it'll be easier if we
don't have to macro it up.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h   |    5 -----
 fs/xfs/libxfs/xfs_rtbitmap.c |   22 +++++++++++-----------
 fs/xfs/libxfs/xfs_rtbitmap.h |   27 +++++++++++++++++++++++++++
 fs/xfs/scrub/rtsummary.c     |    2 +-
 fs/xfs/xfs_rtalloc.c         |   20 ++++++++++----------
 5 files changed, 49 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 20acb8573d7a..0e2ee8202402 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1155,11 +1155,6 @@ static inline bool xfs_dinode_has_large_extent_counts(
 	((xfs_suminfo_t *)((bp)->b_addr + \
 		(((so) * (uint)sizeof(xfs_suminfo_t)) & XFS_BLOCKMASK(mp))))
 
-#define	XFS_BITTOBLOCK(mp,bi)	((bi) >> (mp)->m_blkbit_log)
-#define	XFS_BLOCKTOBIT(mp,bb)	((bb) << (mp)->m_blkbit_log)
-#define	XFS_BITTOWORD(mp,bi)	\
-	((int)(((bi) >> XFS_NBWORDLOG) & XFS_BLOCKWMASK(mp)))
-
 #define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
 #define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 383c6437e042..f7c744f1600a 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -116,7 +116,7 @@ xfs_rtfind_back(
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
 	if (error) {
 		return error;
@@ -125,7 +125,7 @@ xfs_rtfind_back(
 	/*
 	 * Get the first word's index & point to it.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	len = start - limit + 1;
@@ -291,7 +291,7 @@ xfs_rtfind_forw(
 	/*
 	 * Compute and read in starting bitmap block for starting block.
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
 	if (error) {
 		return error;
@@ -300,7 +300,7 @@ xfs_rtfind_forw(
 	/*
 	 * Get the first word's index & point to it.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	len = limit - start + 1;
@@ -552,7 +552,7 @@ xfs_rtmodify_range(
 	/*
 	 * Compute starting bitmap block number.
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	/*
 	 * Read the bitmap block, and point to its data.
 	 */
@@ -564,7 +564,7 @@ xfs_rtmodify_range(
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	first = b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
@@ -730,7 +730,7 @@ xfs_rtfree_range(
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(start - preblock),
-			XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
+			xfs_rtx_to_rbmblock(mp, preblock), -1, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -742,7 +742,7 @@ xfs_rtfree_range(
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(postblock - end),
-			XFS_BITTOBLOCK(mp, end + 1), -1, rbpp, rsb);
+			xfs_rtx_to_rbmblock(mp, end + 1), -1, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -753,7 +753,7 @@ xfs_rtfree_range(
 	 */
 	error = xfs_rtmodify_summary(mp, tp,
 		XFS_RTBLOCKLOG(postblock + 1 - preblock),
-		XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
+		xfs_rtx_to_rbmblock(mp, preblock), 1, rbpp, rsb);
 	return error;
 }
 
@@ -786,7 +786,7 @@ xfs_rtcheck_range(
 	/*
 	 * Compute starting bitmap block number
 	 */
-	block = XFS_BITTOBLOCK(mp, start);
+	block = xfs_rtx_to_rbmblock(mp, start);
 	/*
 	 * Read the bitmap block.
 	 */
@@ -798,7 +798,7 @@ xfs_rtcheck_range(
 	/*
 	 * Compute the starting word's address, and starting bit.
 	 */
-	word = XFS_BITTOWORD(mp, start);
+	word = xfs_rtx_to_rbmword(mp, start);
 	b = &bufp[word];
 	bit = (int)(start & (XFS_NBWORD - 1));
 	/*
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 3686a53e0aed..5c4325702cb1 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -131,6 +131,33 @@ xfs_rtb_rounddown_rtx(
 	return rounddown_64(rtbno, mp->m_sb.sb_rextsize);
 }
 
+/* Convert an rt extent number to a file block offset in the rt bitmap file. */
+static inline xfs_fileoff_t
+xfs_rtx_to_rbmblock(
+	struct xfs_mount	*mp,
+	xfs_rtxnum_t		rtx)
+{
+	return rtx >> mp->m_blkbit_log;
+}
+
+/* Convert an rt extent number to a word offset within an rt bitmap block. */
+static inline unsigned int
+xfs_rtx_to_rbmword(
+	struct xfs_mount	*mp,
+	xfs_rtxnum_t		rtx)
+{
+	return (rtx >> XFS_NBWORDLOG) & XFS_BLOCKWMASK(mp);
+}
+
+/* Convert a file block offset in the rt bitmap file to an rt extent number. */
+static inline xfs_rtxnum_t
+xfs_rbmblock_to_rtx(
+	struct xfs_mount	*mp,
+	xfs_fileoff_t		rbmoff)
+{
+	return rbmoff << mp->m_blkbit_log;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index d363286e8b72..169b7b0dcaa5 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -130,7 +130,7 @@ xchk_rtsum_record_free(
 		return error;
 
 	/* Compute the relevant location in the rtsum file. */
-	rbmoff = XFS_BITTOBLOCK(mp, rec->ar_startext);
+	rbmoff = xfs_rtx_to_rbmblock(mp, rec->ar_startext);
 	lenlog = XFS_RTBLOCKLOG(rec->ar_extcount);
 	offs = XFS_SUMOFFS(mp, lenlog, rbmoff);
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e5a3200cea72..fdfb22baa6da 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -177,7 +177,7 @@ xfs_rtallocate_range(
 	 */
 	error = xfs_rtmodify_summary(mp, tp,
 		XFS_RTBLOCKLOG(postblock + 1 - preblock),
-		XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
+		xfs_rtx_to_rbmblock(mp, preblock), -1, rbpp, rsb);
 	if (error) {
 		return error;
 	}
@@ -188,7 +188,7 @@ xfs_rtallocate_range(
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(start - preblock),
-			XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
+			xfs_rtx_to_rbmblock(mp, preblock), 1, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -200,7 +200,7 @@ xfs_rtallocate_range(
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(postblock - end),
-			XFS_BITTOBLOCK(mp, end + 1), 1, rbpp, rsb);
+			xfs_rtx_to_rbmblock(mp, end + 1), 1, rbpp, rsb);
 		if (error) {
 			return error;
 		}
@@ -261,8 +261,8 @@ xfs_rtallocate_extent_block(
 	 * Loop over all the extents starting in this bitmap block,
 	 * looking for one that's long enough.
 	 */
-	for (i = XFS_BLOCKTOBIT(mp, bbno), besti = -1, bestlen = 0,
-		end = XFS_BLOCKTOBIT(mp, bbno + 1) - 1;
+	for (i = xfs_rbmblock_to_rtx(mp, bbno), besti = -1, bestlen = 0,
+		end = xfs_rbmblock_to_rtx(mp, bbno + 1) - 1;
 	     i <= end;
 	     i++) {
 		/* Make sure we don't scan off the end of the rt volume. */
@@ -489,7 +489,7 @@ xfs_rtallocate_extent_near(
 		*rtx = r;
 		return 0;
 	}
-	bbno = XFS_BITTOBLOCK(mp, start);
+	bbno = xfs_rtx_to_rbmblock(mp, start);
 	i = 0;
 	ASSERT(minlen != 0);
 	log2len = xfs_highbit32(minlen);
@@ -708,8 +708,8 @@ xfs_rtallocate_extent_size(
 			 * allocator is beyond the next bitmap block,
 			 * skip to that bitmap block.
 			 */
-			if (XFS_BITTOBLOCK(mp, n) > i + 1)
-				i = XFS_BITTOBLOCK(mp, n) - 1;
+			if (xfs_rtx_to_rbmblock(mp, n) > i + 1)
+				i = xfs_rtx_to_rbmblock(mp, n) - 1;
 		}
 	}
 	/*
@@ -771,8 +771,8 @@ xfs_rtallocate_extent_size(
 			 * allocator is beyond the next bitmap block,
 			 * skip to that bitmap block.
 			 */
-			if (XFS_BITTOBLOCK(mp, n) > i + 1)
-				i = XFS_BITTOBLOCK(mp, n) - 1;
+			if (xfs_rtx_to_rbmblock(mp, n) > i + 1)
+				i = xfs_rtx_to_rbmblock(mp, n) - 1;
 		}
 	}
 	/*

