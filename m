Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F044A65A07F
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 02:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236083AbiLaBWH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 20:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236085AbiLaBWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:22:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A779FE3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:22:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AE39B81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE98C433F0;
        Sat, 31 Dec 2022 01:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449721;
        bh=8QkNWMdYUrtBLLJcnaWgB2uCs0G6qg1j85N5HOEv9YY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O2wlLbQ7d58BmdjlTxtsLyeqb7GbG4C4Q5MPvGQGMtQHYayg8aC25bo+PR/dm6SsT
         dowUfhxrZQGzzBchyTiruX7xBinbYAgNMPX+j/qMqJl1M2i1P1tkpfO+8iOa3tebKZ
         pngZJfJTJz6nP/PtN2mmrTKm7jiz/pyw+O9O8wult5q0Bf3XUSQbi2ajJuIEFw+aOg
         +xLPp6DHA7XO7ecgSr23CbCtccQfMcoslS/5L/9Y86E+OORXXaRTUepbwPxPPlO+fi
         eLFbXyTn8Rf711oFRTTj6J+E77XmXDWbVmwx3I/O4NgWOl+d+XTeSUaoCn3lHw/bnf
         fV2vKpXXbBZmg==
Subject: [PATCH 08/11] xfs: convert rt bitmap/summary block numbers to
 xfs_fileoff_t
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:37 -0800
Message-ID: <167243865731.709511.17431431600080726993.stgit@magnolia>
In-Reply-To: <167243865605.709511.15650588946095003543.stgit@magnolia>
References: <167243865605.709511.15650588946095003543.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We should use xfs_fileoff_t to store the file block offset of any
location within the realtime bitmap or summary files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   22 +++++++++++-----------
 fs/xfs/libxfs/xfs_rtbitmap.h |   12 ++++++------
 fs/xfs/scrub/rtbitmap.c      |    2 +-
 fs/xfs/xfs_rtalloc.c         |   34 +++++++++++++++++-----------------
 4 files changed, 35 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index b90d2f2d5bde..50a9d23c00c6 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -56,7 +56,7 @@ int
 xfs_rtbuf_get(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	block,		/* block number in bitmap or summary */
+	xfs_fileoff_t	block,		/* block number in bitmap or summary */
 	int		issum,		/* is summary not bitmap */
 	struct xfs_buf	**bpp)		/* output: buffer for the block */
 {
@@ -108,7 +108,7 @@ xfs_rtfind_back(
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
@@ -283,7 +283,7 @@ xfs_rtfind_forw(
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
@@ -453,15 +453,15 @@ xfs_rtmodify_summary_int(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		log,		/* log2 of extent size */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
+	xfs_fileoff_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
 	struct xfs_buf	*bp;		/* buffer for the summary block */
 	int		error;		/* error value */
-	xfs_fsblock_t	sb;		/* summary fsblock */
+	xfs_fileoff_t	sb;		/* summary fsblock */
 	int		so;		/* index into the summary file */
 	xfs_suminfo_t	*sp;		/* pointer to returned data */
 
@@ -523,10 +523,10 @@ xfs_rtmodify_summary(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		log,		/* log2 of extent size */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
+	xfs_fileoff_t	bbno,		/* bitmap block number */
 	int		delta,		/* change to make to summary info */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb)		/* in/out: summary block number */
 {
 	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
 					delta, rbpp, rsb, NULL);
@@ -546,7 +546,7 @@ xfs_rtmodify_range(
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
@@ -699,7 +699,7 @@ xfs_rtfree_range(
 	xfs_rtblock_t	start,		/* starting block to free */
 	xfs_rtxlen_t	len,		/* length to free */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb)		/* in/out: summary block number */
 {
 	xfs_rtblock_t	end;		/* end of the freed extent */
 	int		error;		/* error value */
@@ -780,7 +780,7 @@ xfs_rtcheck_range(
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
 	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
+	xfs_fileoff_t	block;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* buf for the block */
 	xfs_rtword_t	*bufp;		/* starting word in buffer */
 	int		error;		/* error value */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index d4449610154a..e2ea6d31c38b 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -24,7 +24,7 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 
 #ifdef CONFIG_XFS_RT
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
-		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
+		  xfs_fileoff_t block, int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		      xfs_rtblock_t start, xfs_rtxlen_t len, int val,
 		      xfs_rtblock_t *new, int *stat);
@@ -37,15 +37,15 @@ int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		       xfs_rtblock_t start, xfs_rtxlen_t len, int val);
 int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
-			     int log, xfs_rtblock_t bbno, int delta,
-			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
+			     int log, xfs_fileoff_t bbno, int delta,
+			     struct xfs_buf **rbpp, xfs_fileoff_t *rsb,
 			     xfs_suminfo_t *sum);
 int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
-			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
-			 xfs_fsblock_t *rsb);
+			 xfs_fileoff_t bbno, int delta, struct xfs_buf **rbpp,
+			 xfs_fileoff_t *rsb);
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		     xfs_rtblock_t start, xfs_rtxlen_t len,
-		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
+		     struct xfs_buf **rbpp, xfs_fileoff_t *rsb);
 int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		const struct xfs_rtalloc_rec *low_rec,
 		const struct xfs_rtalloc_rec *high_rec,
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 86f726577ca7..6f8becb557bd 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -77,7 +77,7 @@ xchk_rtbitmap_check_extents(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_bmbt_irec	map;
-	xfs_rtblock_t		off;
+	xfs_fileoff_t		off;
 	int			nmap;
 	int			error = 0;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 21f0ac611ef8..12d1fe425d22 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -37,9 +37,9 @@ xfs_rtget_summary(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		log,		/* log2 of extent size */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
+	xfs_fileoff_t	bbno,		/* bitmap block number */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_suminfo_t	*sum)		/* out: summary info for this block */
 {
 	return xfs_rtmodify_summary_int(mp, tp, log, bbno, 0, rbpp, rsb, sum);
@@ -55,9 +55,9 @@ xfs_rtany_summary(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	int		low,		/* low log2 extent size */
 	int		high,		/* high log2 extent size */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
+	xfs_fileoff_t	bbno,		/* bitmap block number */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	int		*stat)		/* out: any good extents here? */
 {
 	int		error;		/* error value */
@@ -109,12 +109,12 @@ xfs_rtcopy_summary(
 	xfs_mount_t	*nmp,		/* new file system mount point */
 	xfs_trans_t	*tp)		/* transaction pointer */
 {
-	xfs_rtblock_t	bbno;		/* bitmap block number */
+	xfs_fileoff_t	bbno;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* summary buffer */
 	int		error;		/* error return value */
 	int		log;		/* summary level number (log length) */
 	xfs_suminfo_t	sum;		/* summary data */
-	xfs_fsblock_t	sumbno;		/* summary block number */
+	xfs_fileoff_t	sumbno;		/* summary block number */
 
 	bp = NULL;
 	for (log = omp->m_rsumlevels - 1; log >= 0; log--) {
@@ -151,7 +151,7 @@ xfs_rtallocate_range(
 	xfs_rtblock_t	start,		/* start block to allocate */
 	xfs_rtxlen_t	len,		/* length to allocate */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb)		/* in/out: summary block number */
 {
 	xfs_rtblock_t	end;		/* end of the allocated extent */
 	int		error;		/* error value */
@@ -227,13 +227,13 @@ STATIC int				/* error */
 xfs_rtallocate_extent_block(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	bbno,		/* bitmap block number */
+	xfs_fileoff_t	bbno,		/* bitmap block number */
 	xfs_rtxlen_t	minlen,		/* minimum length to allocate */
 	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	xfs_rtblock_t	*nextp,		/* out: next block to try */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
@@ -357,7 +357,7 @@ xfs_rtallocate_extent_exact(
 	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
@@ -437,12 +437,12 @@ xfs_rtallocate_extent_near(
 	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
 	int		any;		/* any useful extents from summary */
-	xfs_rtblock_t	bbno;		/* bitmap block number */
+	xfs_fileoff_t	bbno;		/* bitmap block number */
 	int		error;		/* error value */
 	int		i;		/* bitmap block offset (loop control) */
 	int		j;		/* secondary loop control */
@@ -646,12 +646,12 @@ xfs_rtallocate_extent_size(
 	xfs_rtxlen_t	maxlen,		/* maximum length to allocate */
 	xfs_rtxlen_t	*len,		/* out: actual length allocated */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
-	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
+	xfs_fileoff_t	*rsb,		/* in/out: summary block number */
 	xfs_rtxlen_t	prod,		/* extent product factor */
 	xfs_rtblock_t	*rtblock)	/* out: start block allocated */
 {
 	int		error;		/* error value */
-	int		i;		/* bitmap block number */
+	xfs_fileoff_t	i;		/* bitmap block number */
 	int		l;		/* level number (loop control) */
 	xfs_rtblock_t	n;		/* next block to be tried */
 	xfs_rtblock_t	r;		/* result block number */
@@ -927,7 +927,7 @@ xfs_growfs_rt(
 	xfs_mount_t	*mp,		/* mount point for filesystem */
 	xfs_growfs_rt_t	*in)		/* growfs rt input struct */
 {
-	xfs_rtblock_t	bmbno;		/* bitmap block number */
+	xfs_fileoff_t	bmbno;		/* bitmap block number */
 	struct xfs_buf	*bp;		/* temporary buffer */
 	int		error;		/* error return value */
 	xfs_mount_t	*nmp;		/* new (fake) mount structure */
@@ -942,7 +942,7 @@ xfs_growfs_rt(
 	xfs_extlen_t	rbmblocks;	/* current number of rt bitmap blocks */
 	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
 	xfs_sb_t	*sbp;		/* old superblock */
-	xfs_fsblock_t	sumbno;		/* summary block number */
+	xfs_fileoff_t	sumbno;		/* summary block number */
 	uint8_t		*rsum_cache;	/* old summary cache */
 
 	sbp = &mp->m_sb;
@@ -1205,7 +1205,7 @@ xfs_rtallocate_extent(
 	xfs_mount_t	*mp = tp->t_mountp;
 	int		error;		/* error value */
 	xfs_rtblock_t	r;		/* result allocated block */
-	xfs_fsblock_t	sb;		/* summary file block number */
+	xfs_fileoff_t	sb;		/* summary file block number */
 	struct xfs_buf	*sumbp;		/* summary file block buffer */
 
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));

