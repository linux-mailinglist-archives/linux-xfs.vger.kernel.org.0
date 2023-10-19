Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6637CFF87
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Oct 2023 18:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbjJSQ1U (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 19 Oct 2023 12:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbjJSQ1T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:27:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C4C9B
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:27:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49260C433C8;
        Thu, 19 Oct 2023 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732837;
        bh=ma/OIo8C1XJ+mPhFihW/l4CvQIUWFQRqyu2nwP35kek=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=pS/YRb91aLEu8CKSv+O0MzPxJagqQx3gU34jI+ZU4aCpbIlYT3G97IBuqwsjNZttV
         S6Awrqo07EKBGERbYTEGPyS1hUi9W3GDdDOaxlkw/GIP1+7lRdAwMBXFdNvAh1Y1IW
         lE0vGfPhYiNmww7KUXtRifQOL3a+WN7NJJrjn7AgTPpfSDLvfIWb+Ti1JEqQklDih/
         g/WOBIo3DNhUEnWBdXR/yzbncqQeTgh7wyn4Ix5K/mNM/20/D393TMLMpxvMZEedui
         R7Q5VsF+RaPMHBpzcd1sI8cS+TTrCWabBA21qL5n5+drwKpqEVyUqBk6VTL+4INppD
         tsAehJJP5Dxqg==
Date:   Thu, 19 Oct 2023 09:27:16 -0700
Subject: [PATCH 4/5] xfs: convert rt summary macros to helpers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773211030.225536.5324497649482617446.stgit@frogsfrogsfrogs>
In-Reply-To: <169773210961.225536.12900854938759335651.stgit@frogsfrogsfrogs>
References: <169773210961.225536.12900854938759335651.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the realtime summary file macros to helper functions so that we
can improve type checking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h   |    9 +-------
 fs/xfs/libxfs/xfs_rtbitmap.c |   10 +++++---
 fs/xfs/libxfs/xfs_rtbitmap.h |   50 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.h    |    2 ++
 fs/xfs/scrub/rtsummary.c     |   14 +++++++-----
 5 files changed, 67 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ac6dd102342d..d48e3a395bd9 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1144,15 +1144,8 @@ static inline bool xfs_dinode_has_large_extent_counts(
 #define	XFS_BLOCKMASK(mp)	((mp)->m_blockmask)
 
 /*
- * RT Summary and bit manipulation macros.
+ * RT bit manipulation macros.
  */
-#define	XFS_SUMOFFS(mp,ls,bb)	((int)((ls) * (mp)->m_sb.sb_rbmblocks + (bb)))
-#define	XFS_SUMOFFSTOBLOCK(mp,s)	\
-	(((s) * (uint)sizeof(xfs_suminfo_t)) >> (mp)->m_sb.sb_blocklog)
-#define	XFS_SUMPTR(mp,bp,so)	\
-	((xfs_suminfo_t *)((bp)->b_addr + \
-		(((so) * (uint)sizeof(xfs_suminfo_t)) & XFS_BLOCKMASK(mp))))
-
 #define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
 #define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index cc3e70b7fbe5..efa084de58c2 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -455,17 +455,18 @@ xfs_rtmodify_summary_int(
 	struct xfs_buf	*bp;		/* buffer for the summary block */
 	int		error;		/* error value */
 	xfs_fileoff_t	sb;		/* summary fsblock */
-	int		so;		/* index into the summary file */
+	xfs_rtsumoff_t	so;		/* index into the summary file */
 	xfs_suminfo_t	*sp;		/* pointer to returned data */
+	unsigned int	infoword;
 
 	/*
 	 * Compute entry number in the summary file.
 	 */
-	so = XFS_SUMOFFS(mp, log, bbno);
+	so = xfs_rtsumoffs(mp, log, bbno);
 	/*
 	 * Compute the block number in the summary file.
 	 */
-	sb = XFS_SUMOFFSTOBLOCK(mp, so);
+	sb = xfs_rtsumoffs_to_block(mp, so);
 	/*
 	 * If we have an old buffer, and the block number matches, use that.
 	 */
@@ -493,7 +494,8 @@ xfs_rtmodify_summary_int(
 	/*
 	 * Point to the summary information, modify/log it, and/or copy it out.
 	 */
-	sp = XFS_SUMPTR(mp, bp, so);
+	infoword = xfs_rtsumoffs_to_infoword(mp, so);
+	sp = xfs_rsumblock_infoptr(bp, infoword);
 	if (delta) {
 		uint first = (uint)((char *)sp - (char *)bp->b_addr);
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 3252ed217a6a..79ade6d2361b 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -169,6 +169,56 @@ xfs_rbmblock_wordptr(
 	return words + index;
 }
 
+/*
+ * Convert a rt extent length and rt bitmap block number to a xfs_suminfo_t
+ * offset within the rt summary file.
+ */
+static inline xfs_rtsumoff_t
+xfs_rtsumoffs(
+	struct xfs_mount	*mp,
+	int			log2_len,
+	xfs_fileoff_t		rbmoff)
+{
+	return log2_len * mp->m_sb.sb_rbmblocks + rbmoff;
+}
+
+/*
+ * Convert an xfs_suminfo_t offset to a file block offset within the rt summary
+ * file.
+ */
+static inline xfs_fileoff_t
+xfs_rtsumoffs_to_block(
+	struct xfs_mount	*mp,
+	xfs_rtsumoff_t		rsumoff)
+{
+	return XFS_B_TO_FSBT(mp, rsumoff * sizeof(xfs_suminfo_t));
+}
+
+/*
+ * Convert an xfs_suminfo_t offset to an info word offset within an rt summary
+ * block.
+ */
+static inline unsigned int
+xfs_rtsumoffs_to_infoword(
+	struct xfs_mount	*mp,
+	xfs_rtsumoff_t		rsumoff)
+{
+	unsigned int		mask = mp->m_blockmask >> XFS_SUMINFOLOG;
+
+	return rsumoff & mask;
+}
+
+/* Return a pointer to a summary info word within a rt summary block. */
+static inline xfs_suminfo_t *
+xfs_rsumblock_infoptr(
+	struct xfs_buf		*bp,
+	unsigned int		index)
+{
+	xfs_suminfo_t		*info = bp->b_addr;
+
+	return info + index;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index c78237852e27..533200c4ccc2 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -19,6 +19,7 @@ typedef int64_t		xfs_fsize_t;	/* bytes in a file */
 typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
 
 typedef int32_t		xfs_suminfo_t;	/* type of bitmap summary info */
+typedef uint32_t	xfs_rtsumoff_t;	/* offset of an rtsummary info word */
 typedef uint32_t	xfs_rtword_t;	/* word type for bitmap manipulations */
 
 typedef int64_t		xfs_lsn_t;	/* log sequence number */
@@ -149,6 +150,7 @@ typedef uint32_t	xfs_dqid_t;
  */
 #define	XFS_NBBYLOG	3		/* log2(NBBY) */
 #define	XFS_WORDLOG	2		/* log2(sizeof(xfs_rtword_t)) */
+#define	XFS_SUMINFOLOG	2		/* log2(sizeof(xfs_suminfo_t)) */
 #define	XFS_NBWORDLOG	(XFS_NBBYLOG + XFS_WORDLOG)
 #define	XFS_NBWORD	(1 << XFS_NBWORDLOG)
 #define	XFS_WORDMASK	((1 << XFS_WORDLOG) - 1)
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 169b7b0dcaa5..3c8a6cc33800 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -81,7 +81,7 @@ typedef unsigned int xchk_rtsumoff_t;
 static inline int
 xfsum_load(
 	struct xfs_scrub	*sc,
-	xchk_rtsumoff_t		sumoff,
+	xfs_rtsumoff_t		sumoff,
 	xfs_suminfo_t		*info)
 {
 	return xfile_obj_load(sc->xfile, info, sizeof(xfs_suminfo_t),
@@ -91,7 +91,7 @@ xfsum_load(
 static inline int
 xfsum_store(
 	struct xfs_scrub	*sc,
-	xchk_rtsumoff_t		sumoff,
+	xfs_rtsumoff_t		sumoff,
 	const xfs_suminfo_t	info)
 {
 	return xfile_obj_store(sc->xfile, &info, sizeof(xfs_suminfo_t),
@@ -101,7 +101,7 @@ xfsum_store(
 static inline int
 xfsum_copyout(
 	struct xfs_scrub	*sc,
-	xchk_rtsumoff_t		sumoff,
+	xfs_rtsumoff_t		sumoff,
 	xfs_suminfo_t		*info,
 	unsigned int		nr_words)
 {
@@ -121,7 +121,7 @@ xchk_rtsum_record_free(
 	xfs_fileoff_t			rbmoff;
 	xfs_rtblock_t			rtbno;
 	xfs_filblks_t			rtlen;
-	xchk_rtsumoff_t			offs;
+	xfs_rtsumoff_t			offs;
 	unsigned int			lenlog;
 	xfs_suminfo_t			v = 0;
 	int				error = 0;
@@ -132,7 +132,7 @@ xchk_rtsum_record_free(
 	/* Compute the relevant location in the rtsum file. */
 	rbmoff = xfs_rtx_to_rbmblock(mp, rec->ar_startext);
 	lenlog = XFS_RTBLOCKLOG(rec->ar_extcount);
-	offs = XFS_SUMOFFS(mp, lenlog, rbmoff);
+	offs = xfs_rtsumoffs(mp, lenlog, rbmoff);
 
 	rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
 	rtlen = xfs_rtx_to_rtb(mp, rec->ar_extcount);
@@ -185,6 +185,7 @@ xchk_rtsum_compare(
 	int			nmap;
 
 	for (off = 0; off < XFS_B_TO_FSB(mp, mp->m_rsumsize); off++) {
+		xfs_suminfo_t	*ondisk_info;
 		int		error = 0;
 
 		if (xchk_should_terminate(sc, &error))
@@ -216,7 +217,8 @@ xchk_rtsum_compare(
 			return error;
 		}
 
-		if (memcmp(bp->b_addr, sc->buf,
+		ondisk_info = xfs_rsumblock_infoptr(bp, 0);
+		if (memcmp(ondisk_info, sc->buf,
 					mp->m_blockwsize << XFS_WORDLOG) != 0)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, off);
 

