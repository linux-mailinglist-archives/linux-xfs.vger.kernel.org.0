Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9B27376A6
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Jun 2023 23:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjFTVc2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 20 Jun 2023 17:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjFTVc1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 17:32:27 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316C7170D
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 14:32:24 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-54f75f85a17so2777687a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 14:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20221208.gappssmtp.com; s=20221208; t=1687296743; x=1689888743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UmRPyLfBt9DWl3eoPuPkEqyGs8muqdG95XqIxc2t7qU=;
        b=g+BgUeLGWj+TRqtF7YxYhd+lKuWEcIH4Rq3jBV2KTESmDZC8zfDryI+RxZeuzxbeNV
         t1XI7e2wJhHoGUkublH4G6RuCw6VCqQbrjCQVYKt9kUlGyfW60VWB9f5CFocf3OjnMGO
         Odw5WKiwbpMPrt5N/bogN7UPUTWgZPWI0sq7n2OHjQ5RV02fhLrm9ID5z0cm5rkeMFcX
         muJVfFTgwxuas6NQKyDUw8HowLMdCy1HbD0n2naTup1zA48Kk/6JkDpRGJjI2VLSI8Kl
         vlEVP1lSB1S1THXBAHHKtQsLhpHtgACK3anFHMe2mNz/+uefSDs7iQcyo/XL+Ras26Kc
         PYnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687296743; x=1689888743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UmRPyLfBt9DWl3eoPuPkEqyGs8muqdG95XqIxc2t7qU=;
        b=LJrP3Wlab3tm5D0gtgliyqhrO46d0Pq2CigspjMuUWBTYpXtbeCDSr8h2GpszTEECl
         Qm8bU3ZUI8wYavBuujP+rFnxKpV+oC5MVHYMUTOLyeGzBCT6vWyolr+bWyKr1IgNtKhf
         6sUoT2hfZRRycS14TvTjkQQNeNqvt0KNWtadXmkq45AgjfQucYi7vAD26+rd4PCihEGH
         5+NBbWQwIhKI7KU0GIwa7OG5CmRYe3jDtKQCee+czWx/7Kq1YDcb632OuJzba2aRM+Y5
         rlrnn+H12yGfZEprE4qlHZyithjev/lOL1s9v/M9gQ7jNIBQJmuffPOgICghuH3EjhPB
         qnWA==
X-Gm-Message-State: AC+VfDyCIjCXc6qLDNfLxv1UmtM6oECyIxjSKetQLmqQHGmTOXmnF/6a
        R33FpUsBANksWEHXy6b45sm2L7035cpsxC+CKPc=
X-Google-Smtp-Source: ACHHUZ6pnj+WbDoYBMVBLownyh/zDjSBIFptdrvORusj7BCKrf5lbR2NdOdS16eyUOHBGc09TtOfIg==
X-Received: by 2002:a05:6a21:3005:b0:11d:1f5a:d708 with SMTP id yd5-20020a056a21300500b0011d1f5ad708mr7406906pzb.33.1687296742610;
        Tue, 20 Jun 2023 14:32:22 -0700 (PDT)
Received: from telecaster.hsd1.wa.comcast.net ([2620:10d:c090:400::5:ea8e])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79205000000b0064d3a9def35sm1688188pfo.188.2023.06.20.14.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 14:32:22 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>, kernel-team@fb.com,
        Prashant Nema <pnema@fb.com>
Subject: [PATCH 1/6] xfs: cache last bitmap block in realtime allocator
Date:   Tue, 20 Jun 2023 14:32:11 -0700
Message-ID: <32d2288968c76dc51b2e735e557138925aa09e60.1687296675.git.osandov@osandov.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1687296675.git.osandov@osandov.com>
References: <cover.1687296675.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Profiling a workload on a highly fragmented realtime device showed a ton
of CPU cycles being spent in xfs_trans_read_buf() called by
xfs_rtbuf_get(). Further tracing showed that much of that was repeated
calls to xfs_rtbuf_get() for the same block of the realtime bitmap.
These come from xfs_rtallocate_extent_block(): as it walks through
ranges of free bits in the bitmap, each call to xfs_rtcheck_range() and
xfs_rtfind_{forw,back}() gets the same bitmap block. If the bitmap block
is very fragmented, then this is _a lot_ of buffer lookups.

The realtime allocator already passes around a cache of the last used
realtime summary block to avoid repeated reads (the parameters rbpp and
rsb). We can do the same for the realtime bitmap.

This replaces rbpp and rsb with a struct xfs_rtbuf_cache, which caches
the most recently used block for both the realtime bitmap and summary.
xfs_rtbuf_get() now handles the caching instead of the callers, which
requires plumbing xfs_rtbuf_cache to more functions but also makes sure
we don't miss anything.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 167 ++++++++++++++++++-----------------
 fs/xfs/xfs_rtalloc.c         | 107 ++++++++++------------
 fs/xfs/xfs_rtalloc.h         |  28 ++++--
 3 files changed, 154 insertions(+), 148 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index fa180ab66b73..1a832c9a412f 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -46,6 +46,21 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
 	.verify_write = xfs_rtbuf_verify_write,
 };
 
+static void
+xfs_rtbuf_cache_relse(
+	xfs_trans_t	*tp,		/* transaction pointer */
+	struct xfs_rtbuf_cache *cache)	/* cached blocks */
+{
+	if (cache->bbuf) {
+		xfs_trans_brelse(tp, cache->bbuf);
+		cache->bbuf = NULL;
+	}
+	if (cache->sbuf) {
+		xfs_trans_brelse(tp, cache->sbuf);
+		cache->sbuf = NULL;
+	}
+}
+
 /*
  * Get a buffer for the bitmap or summary file block specified.
  * The buffer is returned read and locked.
@@ -56,14 +71,35 @@ xfs_rtbuf_get(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	block,		/* block number in bitmap or summary */
 	int		issum,		/* is summary not bitmap */
+	struct xfs_rtbuf_cache *cache,	/* in/out: cached blocks */
 	struct xfs_buf	**bpp)		/* output: buffer for the block */
 {
+	struct xfs_buf	**cbpp;		/* cached block buffer */
+	xfs_fsblock_t	*cbp;		/* cached block number */
 	struct xfs_buf	*bp;		/* block buffer, result */
 	xfs_inode_t	*ip;		/* bitmap or summary inode */
 	xfs_bmbt_irec_t	map;
 	int		nmap = 1;
 	int		error;		/* error value */
 
+	cbpp = issum ? &cache->bbuf : &cache->sbuf;
+	cbp = issum ? &cache->bblock : &cache->sblock;
+	/*
+	 * If we have a cached buffer, and the block number matches, use that.
+	 */
+	if (*cbpp && *cbp == block) {
+		*bpp = *cbpp;
+		return 0;
+	}
+	/*
+	 * Otherwise we have to have to get the buffer.  If there was an old
+	 * one, get rid of it first.
+	 */
+	if (*cbpp) {
+		xfs_trans_brelse(tp, *cbpp);
+		*cbpp = NULL;
+	}
+
 	ip = issum ? mp->m_rsumip : mp->m_rbmip;
 
 	error = xfs_bmapi_read(ip, block, 1, &map, &nmap, 0);
@@ -82,7 +118,8 @@ xfs_rtbuf_get(
 
 	xfs_trans_buf_set_type(tp, bp, issum ? XFS_BLFT_RTSUMMARY_BUF
 					     : XFS_BLFT_RTBITMAP_BUF);
-	*bpp = bp;
+	*cbpp = *bpp = bp;
+	*cbp = block;
 	return 0;
 }
 
@@ -96,6 +133,7 @@ xfs_rtfind_back(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block to look at */
 	xfs_rtblock_t	limit,		/* last block to look at */
+	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
 	xfs_rtblock_t	*rtblock)	/* out: start block found */
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
@@ -116,7 +154,7 @@ xfs_rtfind_back(
 	 * Compute and read in starting bitmap block for starting block.
 	 */
 	block = XFS_BITTOBLOCK(mp, start);
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(mp, tp, block, 0, rtbufc, &bp);
 	if (error) {
 		return error;
 	}
@@ -153,7 +191,6 @@ xfs_rtfind_back(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
 			i = bit - XFS_RTHIBIT(wdiff);
 			*rtblock = start - i + 1;
 			return 0;
@@ -167,8 +204,7 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, --block, 0, &bp);
+			error = xfs_rtbuf_get(mp, tp, --block, 0, rtbufc, &bp);
 			if (error) {
 				return error;
 			}
@@ -199,7 +235,6 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
 			*rtblock = start - i + 1;
 			return 0;
@@ -213,8 +248,7 @@ xfs_rtfind_back(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, --block, 0, &bp);
+			error = xfs_rtbuf_get(mp, tp, --block, 0, rtbufc, &bp);
 			if (error) {
 				return error;
 			}
@@ -246,7 +280,6 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
 			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
 			*rtblock = start - i + 1;
 			return 0;
@@ -256,7 +289,6 @@ xfs_rtfind_back(
 	/*
 	 * No match, return that we scanned the whole area.
 	 */
-	xfs_trans_brelse(tp, bp);
 	*rtblock = start - i + 1;
 	return 0;
 }
@@ -271,6 +303,7 @@ xfs_rtfind_forw(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block to look at */
 	xfs_rtblock_t	limit,		/* last block to look at */
+	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
 	xfs_rtblock_t	*rtblock)	/* out: start block found */
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
@@ -291,7 +324,7 @@ xfs_rtfind_forw(
 	 * Compute and read in starting bitmap block for starting block.
 	 */
 	block = XFS_BITTOBLOCK(mp, start);
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(mp, tp, block, 0, rtbufc, &bp);
 	if (error) {
 		return error;
 	}
@@ -327,7 +360,6 @@ xfs_rtfind_forw(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
 			*rtblock = start + i - 1;
 			return 0;
@@ -341,8 +373,7 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the previous one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			error = xfs_rtbuf_get(mp, tp, ++block, 0, rtbufc, &bp);
 			if (error) {
 				return error;
 			}
@@ -372,7 +403,6 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*rtblock = start + i - 1;
 			return 0;
@@ -386,8 +416,7 @@ xfs_rtfind_forw(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			error = xfs_rtbuf_get(mp, tp, ++block, 0, rtbufc, &bp);
 			if (error) {
 				return error;
 			}
@@ -416,7 +445,6 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			xfs_trans_brelse(tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*rtblock = start + i - 1;
 			return 0;
@@ -426,7 +454,6 @@ xfs_rtfind_forw(
 	/*
 	 * No match, return that we scanned the whole area.
 	 */
-	xfs_trans_brelse(tp, bp);
 	*rtblock = start + i - 1;
 	return 0;
 }
@@ -447,8 +474,7 @@ xfs_rtmodify_summary_int(
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
 	struct xfs_buf	*bp;		/* buffer for the summary block */
@@ -465,30 +491,9 @@ xfs_rtmodify_summary_int(
 	 * Compute the block number in the summary file.
 	 */
 	sb = XFS_SUMOFFSTOBLOCK(mp, so);
-	/*
-	 * If we have an old buffer, and the block number matches, use that.
-	 */
-	if (*rbpp && *rsb == sb)
-		bp = *rbpp;
-	/*
-	 * Otherwise we have to get the buffer.
-	 */
-	else {
-		/*
-		 * If there was an old one, get rid of it first.
-		 */
-		if (*rbpp)
-			xfs_trans_brelse(tp, *rbpp);
-		error = xfs_rtbuf_get(mp, tp, sb, 1, &bp);
-		if (error) {
-			return error;
-		}
-		/*
-		 * Remember this buffer and block for the next call.
-		 */
-		*rbpp = bp;
-		*rsb = sb;
-	}
+	error = xfs_rtbuf_get(mp, tp, sb, 1, rtbufc, &bp);
+	if (error)
+		return error;
 	/*
 	 * Point to the summary information, modify/log it, and/or copy it out.
 	 */
@@ -517,11 +522,9 @@ xfs_rtmodify_summary(
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+	struct xfs_rtbuf_cache *rtbufc)	/* in/out: cache of realtime blocks */
 {
-	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
-					delta, rbpp, rsb, NULL);
+	return xfs_rtmodify_summary_int(mp, tp, log, bbno, delta, rtbufc, NULL);
 }
 
 /*
@@ -534,7 +537,8 @@ xfs_rtmodify_range(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block to modify */
 	xfs_extlen_t	len,		/* length of extent to modify */
-	int		val)		/* 1 for free, 0 for allocated */
+	int		val,		/* 1 for free, 0 for allocated */
+	struct xfs_rtbuf_cache *rtbufc)	/* in/out: cache of realtime blocks */
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
@@ -555,7 +559,7 @@ xfs_rtmodify_range(
 	/*
 	 * Read the bitmap block, and point to its data.
 	 */
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(mp, tp, block, 0, rtbufc, &bp);
 	if (error) {
 		return error;
 	}
@@ -600,7 +604,7 @@ xfs_rtmodify_range(
 			xfs_trans_log_buf(tp, bp,
 				(uint)((char *)first - (char *)bufp),
 				(uint)((char *)b - (char *)bufp));
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			error = xfs_rtbuf_get(mp, tp, ++block, 0, rtbufc, &bp);
 			if (error) {
 				return error;
 			}
@@ -640,7 +644,7 @@ xfs_rtmodify_range(
 			xfs_trans_log_buf(tp, bp,
 				(uint)((char *)first - (char *)bufp),
 				(uint)((char *)b - (char *)bufp));
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			error = xfs_rtbuf_get(mp, tp, ++block, 0, rtbufc, &bp);
 			if (error) {
 				return error;
 			}
@@ -690,8 +694,7 @@ xfs_rtfree_range(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block to free */
 	xfs_extlen_t	len,		/* length to free */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+	struct xfs_rtbuf_cache *rtbufc)	/* in/out: cache of realtime blocks */
 {
 	xfs_rtblock_t	end;		/* end of the freed extent */
 	int		error;		/* error value */
@@ -702,7 +705,7 @@ xfs_rtfree_range(
 	/*
 	 * Modify the bitmap to mark this extent freed.
 	 */
-	error = xfs_rtmodify_range(mp, tp, start, len, 1);
+	error = xfs_rtmodify_range(mp, tp, start, len, 1, rtbufc);
 	if (error) {
 		return error;
 	}
@@ -711,7 +714,7 @@ xfs_rtfree_range(
 	 * We need to find the beginning and end of the extent so we can
 	 * properly update the summary.
 	 */
-	error = xfs_rtfind_back(mp, tp, start, 0, &preblock);
+	error = xfs_rtfind_back(mp, tp, start, 0, rtbufc, &preblock);
 	if (error) {
 		return error;
 	}
@@ -719,7 +722,7 @@ xfs_rtfree_range(
 	 * Find the next allocated block (end of allocated extent).
 	 */
 	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
-		&postblock);
+		rtbufc, &postblock);
 	if (error)
 		return error;
 	/*
@@ -729,7 +732,7 @@ xfs_rtfree_range(
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(start - preblock),
-			XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
+			XFS_BITTOBLOCK(mp, preblock), -1, rtbufc);
 		if (error) {
 			return error;
 		}
@@ -741,7 +744,7 @@ xfs_rtfree_range(
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(postblock - end),
-			XFS_BITTOBLOCK(mp, end + 1), -1, rbpp, rsb);
+			XFS_BITTOBLOCK(mp, end + 1), -1, rtbufc);
 		if (error) {
 			return error;
 		}
@@ -752,7 +755,7 @@ xfs_rtfree_range(
 	 */
 	error = xfs_rtmodify_summary(mp, tp,
 		XFS_RTBLOCKLOG(postblock + 1 - preblock),
-		XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
+		XFS_BITTOBLOCK(mp, preblock), 1, rtbufc);
 	return error;
 }
 
@@ -767,6 +770,7 @@ xfs_rtcheck_range(
 	xfs_rtblock_t	start,		/* starting block number of extent */
 	xfs_extlen_t	len,		/* length of extent */
 	int		val,		/* 1 for free, 0 for allocated */
+	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
 	xfs_rtblock_t	*new,		/* out: first block not matching */
 	int		*stat)		/* out: 1 for matches, 0 for not */
 {
@@ -789,7 +793,7 @@ xfs_rtcheck_range(
 	/*
 	 * Read the bitmap block.
 	 */
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
+	error = xfs_rtbuf_get(mp, tp, block, 0, rtbufc, &bp);
 	if (error) {
 		return error;
 	}
@@ -824,7 +828,6 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(tp, bp);
 			i = XFS_RTLOBIT(wdiff) - bit;
 			*new = start + i;
 			*stat = 0;
@@ -839,8 +842,7 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			error = xfs_rtbuf_get(mp, tp, ++block, 0, rtbufc, &bp);
 			if (error) {
 				return error;
 			}
@@ -870,7 +872,6 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*new = start + i;
 			*stat = 0;
@@ -885,8 +886,7 @@ xfs_rtcheck_range(
 			/*
 			 * If done with this block, get the next one.
 			 */
-			xfs_trans_brelse(tp, bp);
-			error = xfs_rtbuf_get(mp, tp, ++block, 0, &bp);
+			error = xfs_rtbuf_get(mp, tp, ++block, 0, rtbufc, &bp);
 			if (error) {
 				return error;
 			}
@@ -915,7 +915,6 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			xfs_trans_brelse(tp, bp);
 			i += XFS_RTLOBIT(wdiff);
 			*new = start + i;
 			*stat = 0;
@@ -926,7 +925,6 @@ xfs_rtcheck_range(
 	/*
 	 * Successful, return.
 	 */
-	xfs_trans_brelse(tp, bp);
 	*new = start + i;
 	*stat = 1;
 	return 0;
@@ -941,20 +939,21 @@ xfs_rtcheck_alloc_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	bno,		/* starting block number of extent */
-	xfs_extlen_t	len)		/* length of extent */
+	xfs_extlen_t	len,		/* length of extent */
+	struct xfs_rtbuf_cache *rtbufc)	/* in/out: cached blocks */
 {
 	xfs_rtblock_t	new;		/* dummy for xfs_rtcheck_range */
 	int		stat;
 	int		error;
 
-	error = xfs_rtcheck_range(mp, tp, bno, len, 0, &new, &stat);
+	error = xfs_rtcheck_range(mp, tp, bno, len, 0, rtbufc, &new, &stat);
 	if (error)
 		return error;
 	ASSERT(stat);
 	return 0;
 }
 #else
-#define xfs_rtcheck_alloc_range(m,t,b,l)	(0)
+#define xfs_rtcheck_alloc_range(m,t,b,l,r)	(0)
 #endif
 /*
  * Free an extent in the realtime subvolume.  Length is expressed in
@@ -968,22 +967,21 @@ xfs_rtfree_extent(
 {
 	int		error;		/* error value */
 	xfs_mount_t	*mp;		/* file system mount structure */
-	xfs_fsblock_t	sb;		/* summary file block number */
-	struct xfs_buf	*sumbp = NULL;	/* summary file block buffer */
+	struct xfs_rtbuf_cache rtbufc = {}; /* cache of realtime blocks */
 
 	mp = tp->t_mountp;
 
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
-	error = xfs_rtcheck_alloc_range(mp, tp, bno, len);
+	error = xfs_rtcheck_alloc_range(mp, tp, bno, len, &rtbufc);
 	if (error)
 		return error;
 
 	/*
 	 * Free the range of realtime blocks.
 	 */
-	error = xfs_rtfree_range(mp, tp, bno, len, &sumbp, &sb);
+	error = xfs_rtfree_range(mp, tp, bno, len, &rtbufc);
 	if (error) {
 		return error;
 	}
@@ -1021,6 +1019,7 @@ xfs_rtalloc_query_range(
 	xfs_rtblock_t			high_key;
 	int				is_free;
 	int				error = 0;
+	struct xfs_rtbuf_cache		rtbufc = {};
 
 	if (low_rec->ar_startext > high_rec->ar_startext)
 		return -EINVAL;
@@ -1034,13 +1033,14 @@ xfs_rtalloc_query_range(
 	rtstart = low_rec->ar_startext;
 	while (rtstart <= high_key) {
 		/* Is the first block free? */
-		error = xfs_rtcheck_range(mp, tp, rtstart, 1, 1, &rtend,
-				&is_free);
+		error = xfs_rtcheck_range(mp, tp, rtstart, 1, 1, &rtbufc,
+				&rtend, &is_free);
 		if (error)
 			break;
 
 		/* How long does the extent go for? */
-		error = xfs_rtfind_forw(mp, tp, rtstart, high_key, &rtend);
+		error = xfs_rtfind_forw(mp, tp, rtstart, high_key, &rtbufc,
+					&rtend);
 		if (error)
 			break;
 
@@ -1056,6 +1056,8 @@ xfs_rtalloc_query_range(
 		rtstart = rtend + 1;
 	}
 
+	xfs_rtbuf_cache_relse(tp, &rtbufc);
+
 	return error;
 }
 
@@ -1085,11 +1087,14 @@ xfs_rtalloc_extent_is_free(
 	xfs_extlen_t			len,
 	bool				*is_free)
 {
+	struct xfs_rtbuf_cache		rtbufc = {};
 	xfs_rtblock_t			end;
 	int				matches;
 	int				error;
 
-	error = xfs_rtcheck_range(mp, tp, start, len, 1, &end, &matches);
+	error = xfs_rtcheck_range(mp, tp, start, len, 1, &rtbufc, &end,
+				  &matches);
+	xfs_rtbuf_cache_relse(tp, &rtbufc);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 16534e9873f6..61ef13286654 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -32,11 +32,10 @@ xfs_rtget_summary(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		log,		/* log2 of extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
-	return xfs_rtmodify_summary_int(mp, tp, log, bbno, 0, rbpp, rsb, sum);
+	return xfs_rtmodify_summary_int(mp, tp, log, bbno, 0, rtbufc, sum);
 }
 
 /*
@@ -50,8 +49,7 @@ xfs_rtany_summary(
 	int		low,		/* low log2 extent size */
 	int		high,		/* high log2 extent size */
 	xfs_rtblock_t	bbno,		/* bitmap block number */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
 	int		*stat)		/* out: any good extents here? */
 {
 	int		error;		/* error value */
@@ -69,7 +67,7 @@ xfs_rtany_summary(
 		/*
 		 * Get one summary datum.
 		 */
-		error = xfs_rtget_summary(mp, tp, log, bbno, rbpp, rsb, &sum);
+		error = xfs_rtget_summary(mp, tp, log, bbno, rtbufc, &sum);
 		if (error) {
 			return error;
 		}
@@ -104,29 +102,27 @@ xfs_rtcopy_summary(
 	xfs_trans_t	*tp)		/* transaction pointer */
 {
 	xfs_rtblock_t	bbno;		/* bitmap block number */
-	struct xfs_buf	*bp;		/* summary buffer */
+	struct xfs_rtbuf_cache rtbufc = {}; /* cache of realtime blocks */
 	int		error;		/* error return value */
 	int		log;		/* summary level number (log length) */
 	xfs_suminfo_t	sum;		/* summary data */
-	xfs_fsblock_t	sumbno;		/* summary block number */
 
-	bp = NULL;
 	for (log = omp->m_rsumlevels - 1; log >= 0; log--) {
 		for (bbno = omp->m_sb.sb_rbmblocks - 1;
 		     (xfs_srtblock_t)bbno >= 0;
 		     bbno--) {
-			error = xfs_rtget_summary(omp, tp, log, bbno, &bp,
-				&sumbno, &sum);
+			error = xfs_rtget_summary(omp, tp, log, bbno, &rtbufc,
+				&sum);
 			if (error)
 				return error;
 			if (sum == 0)
 				continue;
 			error = xfs_rtmodify_summary(omp, tp, log, bbno, -sum,
-				&bp, &sumbno);
+				&rtbufc);
 			if (error)
 				return error;
 			error = xfs_rtmodify_summary(nmp, tp, log, bbno, sum,
-				&bp, &sumbno);
+				&rtbufc);
 			if (error)
 				return error;
 			ASSERT(sum > 0);
@@ -144,8 +140,7 @@ xfs_rtallocate_range(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* start block to allocate */
 	xfs_extlen_t	len,		/* length to allocate */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+	struct xfs_rtbuf_cache *rtbufc)	/* in/out: cache of realtime blocks */
 {
 	xfs_rtblock_t	end;		/* end of the allocated extent */
 	int		error;		/* error value */
@@ -158,14 +153,14 @@ xfs_rtallocate_range(
 	 * We need to find the beginning and end of the extent so we can
 	 * properly update the summary.
 	 */
-	error = xfs_rtfind_back(mp, tp, start, 0, &preblock);
+	error = xfs_rtfind_back(mp, tp, start, 0, rtbufc, &preblock);
 	if (error) {
 		return error;
 	}
 	/*
 	 * Find the next allocated block (end of free extent).
 	 */
-	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1,
+	error = xfs_rtfind_forw(mp, tp, end, mp->m_sb.sb_rextents - 1, rtbufc,
 		&postblock);
 	if (error) {
 		return error;
@@ -176,7 +171,7 @@ xfs_rtallocate_range(
 	 */
 	error = xfs_rtmodify_summary(mp, tp,
 		XFS_RTBLOCKLOG(postblock + 1 - preblock),
-		XFS_BITTOBLOCK(mp, preblock), -1, rbpp, rsb);
+		XFS_BITTOBLOCK(mp, preblock), -1, rtbufc);
 	if (error) {
 		return error;
 	}
@@ -187,7 +182,7 @@ xfs_rtallocate_range(
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(start - preblock),
-			XFS_BITTOBLOCK(mp, preblock), 1, rbpp, rsb);
+			XFS_BITTOBLOCK(mp, preblock), 1, rtbufc);
 		if (error) {
 			return error;
 		}
@@ -199,7 +194,7 @@ xfs_rtallocate_range(
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(mp, tp,
 			XFS_RTBLOCKLOG(postblock - end),
-			XFS_BITTOBLOCK(mp, end + 1), 1, rbpp, rsb);
+			XFS_BITTOBLOCK(mp, end + 1), 1, rtbufc);
 		if (error) {
 			return error;
 		}
@@ -207,7 +202,7 @@ xfs_rtallocate_range(
 	/*
 	 * Modify the bitmap to mark this extent allocated.
 	 */
-	error = xfs_rtmodify_range(mp, tp, start, len, 0);
+	error = xfs_rtmodify_range(mp, tp, start, len, 0, rtbufc);
 	return error;
 }
 
@@ -226,8 +221,7 @@ xfs_rtallocate_extent_block(
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
 	xfs_rtblock_t	*nextp,		/* out: next block to try */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
@@ -254,7 +248,8 @@ xfs_rtallocate_extent_block(
 		 * See if there's a free extent of maxlen starting at i.
 		 * If it's not so then next will contain the first non-free.
 		 */
-		error = xfs_rtcheck_range(mp, tp, i, maxlen, 1, &next, &stat);
+		error = xfs_rtcheck_range(mp, tp, i, maxlen, 1, rtbufc, &next,
+					  &stat);
 		if (error) {
 			return error;
 		}
@@ -262,8 +257,7 @@ xfs_rtallocate_extent_block(
 			/*
 			 * i for maxlen is all free, allocate and return that.
 			 */
-			error = xfs_rtallocate_range(mp, tp, i, maxlen, rbpp,
-				rsb);
+			error = xfs_rtallocate_range(mp, tp, i, maxlen, rtbufc);
 			if (error) {
 				return error;
 			}
@@ -290,7 +284,7 @@ xfs_rtallocate_extent_block(
 		 * If not done yet, find the start of the next free space.
 		 */
 		if (next < end) {
-			error = xfs_rtfind_forw(mp, tp, next, end, &i);
+			error = xfs_rtfind_forw(mp, tp, next, end, rtbufc, &i);
 			if (error) {
 				return error;
 			}
@@ -315,7 +309,7 @@ xfs_rtallocate_extent_block(
 		/*
 		 * Allocate besti for bestlen & return that.
 		 */
-		error = xfs_rtallocate_range(mp, tp, besti, bestlen, rbpp, rsb);
+		error = xfs_rtallocate_range(mp, tp, besti, bestlen, rtbufc);
 		if (error) {
 			return error;
 		}
@@ -344,9 +338,8 @@ xfs_rtallocate_extent_exact(
 	xfs_rtblock_t	bno,		/* starting block number to allocate */
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
+	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
@@ -359,7 +352,8 @@ xfs_rtallocate_extent_exact(
 	/*
 	 * Check if the range in question (for maxlen) is free.
 	 */
-	error = xfs_rtcheck_range(mp, tp, bno, maxlen, 1, &next, &isfree);
+	error = xfs_rtcheck_range(mp, tp, bno, maxlen, 1, rtbufc, &next,
+				  &isfree);
 	if (error) {
 		return error;
 	}
@@ -367,7 +361,7 @@ xfs_rtallocate_extent_exact(
 		/*
 		 * If it is, allocate it and return success.
 		 */
-		error = xfs_rtallocate_range(mp, tp, bno, maxlen, rbpp, rsb);
+		error = xfs_rtallocate_range(mp, tp, bno, maxlen, rtbufc);
 		if (error) {
 			return error;
 		}
@@ -402,7 +396,7 @@ xfs_rtallocate_extent_exact(
 	/*
 	 * Allocate what we can and return it.
 	 */
-	error = xfs_rtallocate_range(mp, tp, bno, maxlen, rbpp, rsb);
+	error = xfs_rtallocate_range(mp, tp, bno, maxlen, rtbufc);
 	if (error) {
 		return error;
 	}
@@ -424,8 +418,7 @@ xfs_rtallocate_extent_near(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
@@ -456,8 +449,8 @@ xfs_rtallocate_extent_near(
 	/*
 	 * Try the exact allocation first.
 	 */
-	error = xfs_rtallocate_extent_exact(mp, tp, bno, minlen, maxlen, len,
-		rbpp, rsb, prod, &r);
+	error = xfs_rtallocate_extent_exact(mp, tp, bno, minlen, maxlen, rtbufc,
+		len, prod, &r);
 	if (error) {
 		return error;
 	}
@@ -481,7 +474,7 @@ xfs_rtallocate_extent_near(
 		 * starting in this bitmap block.
 		 */
 		error = xfs_rtany_summary(mp, tp, log2len, mp->m_rsumlevels - 1,
-			bbno + i, rbpp, rsb, &any);
+			bbno + i, rtbufc, &any);
 		if (error) {
 			return error;
 		}
@@ -499,8 +492,8 @@ xfs_rtallocate_extent_near(
 				 * this block.
 				 */
 				error = xfs_rtallocate_extent_block(mp, tp,
-					bbno + i, minlen, maxlen, len, &n, rbpp,
-					rsb, prod, &r);
+					bbno + i, minlen, maxlen, len, &n,
+					rtbufc, prod, &r);
 				if (error) {
 					return error;
 				}
@@ -529,7 +522,7 @@ xfs_rtallocate_extent_near(
 					 */
 					error = xfs_rtany_summary(mp, tp,
 						log2len, mp->m_rsumlevels - 1,
-						bbno + j, rbpp, rsb, &any);
+						bbno + j, rtbufc, &any);
 					if (error) {
 						return error;
 					}
@@ -545,7 +538,7 @@ xfs_rtallocate_extent_near(
 						continue;
 					error = xfs_rtallocate_extent_block(mp,
 						tp, bbno + j, minlen, maxlen,
-						len, &n, rbpp, rsb, prod, &r);
+						len, &n, rtbufc, prod, &r);
 					if (error) {
 						return error;
 					}
@@ -566,8 +559,8 @@ xfs_rtallocate_extent_near(
 				 * that we found.
 				 */
 				error = xfs_rtallocate_extent_block(mp, tp,
-					bbno + i, minlen, maxlen, len, &n, rbpp,
-					rsb, prod, &r);
+					bbno + i, minlen, maxlen, len, &n,
+					rtbufc, prod, &r);
 				if (error) {
 					return error;
 				}
@@ -626,8 +619,7 @@ xfs_rtallocate_extent_size(
 	xfs_extlen_t	minlen,		/* minimum length to allocate */
 	xfs_extlen_t	maxlen,		/* maximum length to allocate */
 	xfs_extlen_t	*len,		/* out: actual length allocated */
-	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	struct xfs_rtbuf_cache *rtbufc,	/* in/out: cache of realtime blocks */
 	xfs_extlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
@@ -656,7 +648,7 @@ xfs_rtallocate_extent_size(
 			/*
 			 * Get the summary for this level/block.
 			 */
-			error = xfs_rtget_summary(mp, tp, l, i, rbpp, rsb,
+			error = xfs_rtget_summary(mp, tp, l, i, rtbufc,
 				&sum);
 			if (error) {
 				return error;
@@ -670,7 +662,7 @@ xfs_rtallocate_extent_size(
 			 * Try allocating the extent.
 			 */
 			error = xfs_rtallocate_extent_block(mp, tp, i, maxlen,
-				maxlen, len, &n, rbpp, rsb, prod, &r);
+				maxlen, len, &n, rtbufc, prod, &r);
 			if (error) {
 				return error;
 			}
@@ -715,7 +707,7 @@ xfs_rtallocate_extent_size(
 			/*
 			 * Get the summary information for this level/block.
 			 */
-			error =	xfs_rtget_summary(mp, tp, l, i, rbpp, rsb,
+			error =	xfs_rtget_summary(mp, tp, l, i, rtbufc,
 						  &sum);
 			if (error) {
 				return error;
@@ -733,7 +725,7 @@ xfs_rtallocate_extent_size(
 			error = xfs_rtallocate_extent_block(mp, tp, i,
 					XFS_RTMAX(minlen, 1 << l),
 					XFS_RTMIN(maxlen, (1 << (l + 1)) - 1),
-					len, &n, rbpp, rsb, prod, &r);
+					len, &n, rtbufc, prod, &r);
 			if (error) {
 				return error;
 			}
@@ -922,7 +914,6 @@ xfs_growfs_rt(
 	xfs_extlen_t	rbmblocks;	/* current number of rt bitmap blocks */
 	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
 	xfs_sb_t	*sbp;		/* old superblock */
-	xfs_fsblock_t	sumbno;		/* summary block number */
 	uint8_t		*rsum_cache;	/* old summary cache */
 
 	sbp = &mp->m_sb;
@@ -1025,6 +1016,7 @@ xfs_growfs_rt(
 	     bmbno++) {
 		struct xfs_trans	*tp;
 		xfs_rfsblock_t		nrblocks_step;
+		struct xfs_rtbuf_cache rtbufc = {}; /* cache of realtime blocks */
 
 		*nmp = *mp;
 		nsbp = &nmp->m_sb;
@@ -1111,9 +1103,8 @@ xfs_growfs_rt(
 		/*
 		 * Free new extent.
 		 */
-		bp = NULL;
 		error = xfs_rtfree_range(nmp, tp, sbp->sb_rextents,
-			nsbp->sb_rextents - sbp->sb_rextents, &bp, &sumbno);
+			nsbp->sb_rextents - sbp->sb_rextents, &rtbufc);
 		if (error) {
 error_cancel:
 			xfs_trans_cancel(tp);
@@ -1185,8 +1176,7 @@ xfs_rtallocate_extent(
 	xfs_mount_t	*mp = tp->t_mountp;
 	int		error;		/* error value */
 	xfs_rtblock_t	r;		/* result allocated block */
-	xfs_fsblock_t	sb;		/* summary file block number */
-	struct xfs_buf	*sumbp;		/* summary file block buffer */
+	struct xfs_rtbuf_cache rtbufc = {}; /* cache of realtime blocks */
 
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 	ASSERT(minlen > 0 && minlen <= maxlen);
@@ -1208,13 +1198,14 @@ xfs_rtallocate_extent(
 	}
 
 retry:
-	sumbp = NULL;
+	rtbufc.bbuf = NULL;
+	rtbufc.sbuf = NULL;
 	if (bno == 0) {
 		error = xfs_rtallocate_extent_size(mp, tp, minlen, maxlen, len,
-				&sumbp,	&sb, prod, &r);
+				&rtbufc, prod, &r);
 	} else {
 		error = xfs_rtallocate_extent_near(mp, tp, bno, minlen, maxlen,
-				len, &sumbp, &sb, prod, &r);
+				len, &rtbufc, prod, &r);
 	}
 
 	if (error)
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 62c7ad79cbb6..888552c4f287 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -101,29 +101,39 @@ xfs_growfs_rt(
 /*
  * From xfs_rtbitmap.c
  */
+struct xfs_rtbuf_cache {
+	struct xfs_buf *bbuf;	/* bitmap block buffer */
+	xfs_fsblock_t bblock;	/* bitmap block number */
+	struct xfs_buf *sbuf;	/* summary block buffer */
+	xfs_fsblock_t sblock;	/* summary block number */
+};
+
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
-		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
+		  xfs_rtblock_t block, int issum, struct xfs_rtbuf_cache *cache,
+		  struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		      xfs_rtblock_t start, xfs_extlen_t len, int val,
-		      xfs_rtblock_t *new, int *stat);
+		      struct xfs_rtbuf_cache *rtbufc, xfs_rtblock_t *new,
+		      int *stat);
 int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
 		    xfs_rtblock_t start, xfs_rtblock_t limit,
-		    xfs_rtblock_t *rtblock);
+		    struct xfs_rtbuf_cache *rtbufc, xfs_rtblock_t *rtblock);
 int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
 		    xfs_rtblock_t start, xfs_rtblock_t limit,
-		    xfs_rtblock_t *rtblock);
+		    struct xfs_rtbuf_cache *rtbufc, xfs_rtblock_t *rtblock);
 int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		       xfs_rtblock_t start, xfs_extlen_t len, int val);
+		       xfs_rtblock_t start, xfs_extlen_t len, int val,
+		       struct xfs_rtbuf_cache *rtbufc);
 int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
 			     int log, xfs_rtblock_t bbno, int delta,
-			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
+			     struct xfs_rtbuf_cache *rtbufc,
 			     xfs_suminfo_t *sum);
 int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
-			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
-			 xfs_fsblock_t *rsb);
+			 xfs_rtblock_t bbno, int delta,
+			 struct xfs_rtbuf_cache *rtbufc);
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		     xfs_rtblock_t start, xfs_extlen_t len,
-		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
+		     struct xfs_rtbuf_cache *rtbufc);
 int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		const struct xfs_rtalloc_rec *low_rec,
 		const struct xfs_rtalloc_rec *high_rec,
-- 
2.41.0

