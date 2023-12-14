Return-Path: <linux-xfs+bounces-767-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17BAA81284D
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Dec 2023 07:35:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E6F31C208DB
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Dec 2023 06:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A860D50E;
	Thu, 14 Dec 2023 06:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BkxP/clB"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D88A6
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2FRn+6Ji98wfPJICaA1GmgPBxn/6Ra1KP+pTgABMQg0=; b=BkxP/clB/Kclkhb5cIITIbOxzu
	psLDLTLHdxmcDVtXNbB1VXZ1jhhmnIPzQ+nvEWkjnVbIPpzsSYdMNQZaz1xEtu+tJbJsNrRefdXN2
	gI5B3kvZfo610CPy8tcPh/vdMWnWZo8iZ3uBSLX2x6EIkG5KSKtBObdVoLqloRVSXY54egiZ9DqfG
	tTwm/91/Sfde9vk6FJpy+yWJ4CRTgYBFvZ9i4PErg4kmQAmYFN6R0KDCTV/37oF+ul4mKogSbI9vL
	wBnxpjK6epJIS6zTfcuiKHxIaAcjXDGFMfuUYsfFBoQswwUr6iELBwNsW5a3wvuV/HVk/n12jol3b
	4cBxzOuQ==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfJg-00GzVL-2s;
	Thu, 14 Dec 2023 06:35:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 18/19] xfs: simplify and optimize the RT allocation fallback cascade
Date: Thu, 14 Dec 2023 07:34:37 +0100
Message-Id: <20231214063438.290538-19-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231214063438.290538-1-hch@lst.de>
References: <20231214063438.290538-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There are currently multiple levels of fall back if an RT allocation
can not be satisfied:

 1) xfs_rtallocate_extent extents the minlen and reduces the maxlen due
    to the extent size hint.  If that can't be done, it return -ENOSPC
    and let's xfs_bmap_rtalloc retry, which then not only drops the
    extent size hint based alignment, but also the minlen adjustment
 2) if xfs_rtallocate_extent gets -ENOSPC from the underlying functions,
    it only drops the extent size hint based alignment and retries
 3) if that still does not succeed, xfs_rtallocate_extent drops the
    extent size hint (which is a complex no-op at this point) and the
    minlen using the same code as (1) above
 4) if that still doesn't success and the caller wanted an allocation
    near a blkno, drop that blkno hint.

The handling in 1 is rather inefficient as we could just drop the
alignment and continue, and 2/3 interact in really weird ways due to
the duplicate policy.

Move aligning the min and maxlen out of xfs_rtallocate_extent and into
a helper called directly by xfs_bmap_rtalloc.  This allows just
continuing with the allocation if we have to drop the alignment instead
of going through the retry loop and also dropping the perfectly the
minlen adjustment that didn't cause the problem, and then just use
a single retry that drops both the minlen and alignment requirement
when we really are out of space, thus consolidating cases (2) and (3)
above.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 58 ++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 595740d18dc4c3..16255617629ef5 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1088,21 +1088,6 @@ xfs_rtallocate_extent(
 	ASSERT(xfs_isilocked(args.mp->m_rbmip, XFS_ILOCK_EXCL));
 	ASSERT(minlen > 0 && minlen <= maxlen);
 
-	/*
-	 * If prod is set then figure out what to do to minlen and maxlen.
-	 */
-	if (prod > 1) {
-		xfs_rtxlen_t	i;
-
-		if ((i = maxlen % prod))
-			maxlen -= i;
-		if ((i = minlen % prod))
-			minlen += prod - i;
-		if (maxlen < minlen)
-			return -ENOSPC;
-	}
-
-retry:
 	if (start == 0) {
 		error = xfs_rtallocate_extent_size(&args, minlen,
 				maxlen, len, prod, rtx);
@@ -1111,13 +1096,8 @@ xfs_rtallocate_extent(
 				maxlen, len, prod, rtx);
 	}
 	xfs_rtbuf_cache_relse(&args);
-	if (error) {
-		if (error == -ENOSPC && prod > 1) {
-			prod = 1;
-			goto retry;
-		}
+	if (error)
 		return error;
-	}
 
 	/*
 	 * If it worked, update the superblock.
@@ -1348,6 +1328,35 @@ xfs_rtpick_extent(
 	return 0;
 }
 
+static void
+xfs_rtalloc_align_minmax(
+	xfs_rtxlen_t		*raminlen,
+	xfs_rtxlen_t		*ramaxlen,
+	xfs_rtxlen_t		*prod)
+{
+	xfs_rtxlen_t		newmaxlen = *ramaxlen;
+	xfs_rtxlen_t		newminlen = *raminlen;
+	xfs_rtxlen_t		slack;
+
+	slack = newmaxlen % *prod;
+	if (slack)
+		newmaxlen -= slack;
+	slack = newminlen % *prod;
+	if (slack)
+		newminlen += *prod - slack;
+
+	/*
+	 * If adjusting for extent size hint alignment produces an invalid
+	 * min/max len combination, go ahead without it.
+	 */
+	if (newmaxlen < newminlen) {
+		*prod = 1;
+		return;
+	}
+	*ramaxlen = newmaxlen;
+	*raminlen = newminlen;
+}
+
 int
 xfs_bmap_rtalloc(
 	struct xfs_bmalloca	*ap)
@@ -1430,10 +1439,13 @@ xfs_bmap_rtalloc(
 	 * perfectly aligned, otherwise it will just get us in trouble.
 	 */
 	div_u64_rem(ap->offset, align, &mod);
-	if (mod || ap->length % align)
+	if (mod || ap->length % align) {
 		prod = 1;
-	else
+	} else {
 		prod = xfs_extlen_to_rtxlen(mp, align);
+		if (prod > 1)
+			xfs_rtalloc_align_minmax(&raminlen, &ralen, &prod);
+	}
 
 	error = xfs_rtallocate_extent(ap->tp, start, raminlen, ralen, &ralen,
 			ap->wasdel, prod, &rtx);
-- 
2.39.2


