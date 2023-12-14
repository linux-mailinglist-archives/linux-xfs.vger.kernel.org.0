Return-Path: <linux-xfs+bounces-756-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CFCF812842
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Dec 2023 07:35:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A174EB2115C
	for <lists+linux-xfs@lfdr.de>; Thu, 14 Dec 2023 06:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D36AFD51C;
	Thu, 14 Dec 2023 06:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SxFQgtOH"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7487E4
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jgS1TR0jWIf2tkwWKP+RPWhKD7ERzqVgSnzSsQhzmKs=; b=SxFQgtOHc8gQKBlqVNs1o59ABJ
	dsbna8/RhLdkmoo6gPmIcj1UkN3Iil4zBt/GySWeer8zUzQANwgvwEJeu0w1G3ZzWvgS2CL2ud5oE
	kLmOmOTJ6/gF/KmA1JTumreLWCPseig59Fb3jw513xnAvVu01+ske2gOilY9VcvUwpmtO7UnXKU0B
	z09+3rpOsiudmYsAQ2AjLOVqpgW1AthoUC24w7yzEA/etYGRw2CpYDybfwYNY1dAIE8lGG59sf0FT
	y2bFB9gZ3XmoJh4EOytLVSrLQRm6NAc+In1mpm1IOb1y0JYxlBEhFr/pu6A9EGq/SIEHO4htoT+qO
	CDmakDEg==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfJE-00GzLO-0n;
	Thu, 14 Dec 2023 06:35:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/19] xfs: reflow the tail end of xfs_bmap_rtalloc
Date: Thu, 14 Dec 2023 07:34:26 +0100
Message-Id: <20231214063438.290538-8-hch@lst.de>
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

Reorder the tail end of xfs_bmap_rtalloc so that the successfully
allocation is in the main path, and the error handling is on a branch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 60 ++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index dac148d53af3ec..158a631379378e 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1479,39 +1479,39 @@ xfs_bmap_rtalloc(
 	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
 	error = xfs_rtallocate_extent(ap->tp, rtx, raminlen, ralen, &ralen,
 			ap->wasdel, prod, &rtx);
-	if (!error) {
-		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
-		ap->length = xfs_rtxlen_to_extlen(mp, ralen);
-		xfs_bmap_alloc_account(ap);
-		return 0;
-	}
-
-	if (error != -ENOSPC)
-		return error;
+	if (error == -ENOSPC) {
+		if (align > mp->m_sb.sb_rextsize) {
+			/*
+			 * We previously enlarged the request length to try to
+			 * satisfy an extent size hint.  The allocator didn't
+			 * return anything, so reset the parameters to the
+			 * original values and try again without alignment
+			 * criteria.
+			 */
+			ap->offset = orig_offset;
+			ap->length = orig_length;
+			minlen = align = mp->m_sb.sb_rextsize;
+			goto retry;
+		}
 
-	if (align > mp->m_sb.sb_rextsize) {
-		/*
-		 * We previously enlarged the request length to try to satisfy
-		 * an extent size hint.  The allocator didn't return anything,
-		 * so reset the parameters to the original values and try again
-		 * without alignment criteria.
-		 */
-		ap->offset = orig_offset;
-		ap->length = orig_length;
-		minlen = align = mp->m_sb.sb_rextsize;
-		goto retry;
-	}
+		if (!ignore_locality && ap->blkno != 0) {
+			/*
+			 * If we can't allocate near a specific rt extent, try
+			 * again without locality criteria.
+			 */
+			ignore_locality = true;
+			goto retry;
+		}
 
-	if (!ignore_locality && ap->blkno != 0) {
-		/*
-		 * If we can't allocate near a specific rt extent, try again
-		 * without locality criteria.
-		 */
-		ignore_locality = true;
-		goto retry;
+		ap->blkno = NULLFSBLOCK;
+		ap->length = 0;
+		return 0;
 	}
+	if (error)
+		return error;
 
-	ap->blkno = NULLFSBLOCK;
-	ap->length = 0;
+	ap->blkno = xfs_rtx_to_rtb(mp, rtx);
+	ap->length = xfs_rtxlen_to_extlen(mp, ralen);
+	xfs_bmap_alloc_account(ap);
 	return 0;
 }
-- 
2.39.2


