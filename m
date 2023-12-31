Return-Path: <linux-xfs+bounces-1551-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5537820EB1
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 22:28:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 029651C2199D
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:28:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93028BA2E;
	Sun, 31 Dec 2023 21:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4gk7Oun"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E59EBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D75C433C8;
	Sun, 31 Dec 2023 21:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058104;
	bh=W/6jn+quTdDPnBCZesEYPPPgNI0Xr8F+lM/xcvhPvd8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Z4gk7Ouna7TAzQFp3neMSnclucY3u9iT0rUYTITWzRE7OLt2RXiu2+5MrqGPIFXAP
	 q8CSv0444H59GGL8X/A/VVIvYjPWqwZlJ6d5y1SB5LAKDY+tijwUzXTfDNXLWdXPN7
	 dzx4KaQyJzGjwCEPPCd/lH+a1mNBztuJbTdjbDBBiHpqhUOxQDBF+NuM4HwsYDe+7P
	 HJtW/Xf/XK9zhGGaEvDXFwXB5DD4uF42HlmX+lQ3hspz9Vfd3Afm70fxlnnY009wSK
	 8YBcAP/8wHIx+RSJXrBvTzxrFGmNJ4o34LA2ei86DFTcZykw8BXymPOJUH8ss+367w
	 +z2IEX5NB6IUw==
Date: Sun, 31 Dec 2023 13:28:23 -0800
Subject: [PATCH 8/9] xfs: remove xfs_defer_agfl_block
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170404848464.1764329.16504824624090286076.stgit@frogsfrogsfrogs>
In-Reply-To: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
References: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

xfs_free_extent_later can handle the extra AGFL special casing with
very little extra logic.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   67 +++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 45 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ca4df5e0b2a31..0227985676042 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2538,48 +2538,6 @@ xfs_agfl_reset(
 	clear_bit(XFS_AGSTATE_AGFL_NEEDS_RESET, &pag->pag_opstate);
 }
 
-/*
- * Defer an AGFL block free. This is effectively equivalent to
- * xfs_free_extent_later() with some special handling particular to AGFL blocks.
- *
- * Deferring AGFL frees helps prevent log reservation overruns due to too many
- * allocation operations in a transaction. AGFL frees are prone to this problem
- * because for one they are always freed one at a time. Further, an immediate
- * AGFL block free can cause a btree join and require another block free before
- * the real allocation can proceed. Deferring the free disconnects freeing up
- * the AGFL slot from freeing the block.
- */
-static int
-xfs_defer_agfl_block(
-	struct xfs_trans		*tp,
-	xfs_agnumber_t			agno,
-	xfs_agblock_t			agbno,
-	struct xfs_owner_info		*oinfo)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_extent_free_item	*xefi;
-	xfs_fsblock_t			fsbno = XFS_AGB_TO_FSB(mp, agno, agbno);
-
-	ASSERT(xfs_extfree_item_cache != NULL);
-	ASSERT(oinfo != NULL);
-
-	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbno(mp, fsbno)))
-		return -EFSCORRUPTED;
-
-	xefi = kmem_cache_zalloc(xfs_extfree_item_cache,
-			       GFP_KERNEL | __GFP_NOFAIL);
-	xefi->xefi_startblock = fsbno;
-	xefi->xefi_blockcount = 1;
-	xefi->xefi_owner = oinfo->oi_owner;
-	xefi->xefi_agresv = XFS_AG_RESV_AGFL;
-
-	trace_xfs_agfl_free_defer(mp, xefi);
-
-	xfs_extent_free_get_group(mp, xefi);
-	xfs_defer_add(tp, &xefi->xefi_list, &xfs_agfl_free_defer_type);
-	return 0;
-}
-
 /*
  * Add the extent to the list of extents to be free at transaction end.
  * The list is maintained sorted (by block number).
@@ -2627,7 +2585,13 @@ xfs_defer_extent_free(
 	trace_xfs_extent_free_defer(mp, xefi);
 
 	xfs_extent_free_get_group(mp, xefi);
-	*dfpp = xfs_defer_add(tp, &xefi->xefi_list, &xfs_extent_free_defer_type);
+
+	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
+		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
+				&xfs_agfl_free_defer_type);
+	else
+		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
+				&xfs_extent_free_defer_type);
 	return 0;
 }
 
@@ -2885,8 +2849,21 @@ xfs_alloc_fix_freelist(
 		if (error)
 			goto out_agbp_relse;
 
-		/* defer agfl frees */
-		error = xfs_defer_agfl_block(tp, args->agno, bno, &targs.oinfo);
+		/*
+		 * Defer the AGFL block free.
+		 *
+		 * This helps to prevent log reservation overruns due to too
+		 * many allocation operations in a transaction. AGFL frees are
+		 * prone to this problem because for one they are always freed
+		 * one at a time.  Further, an immediate AGFL block free can
+		 * cause a btree join and require another block free before the
+		 * real allocation can proceed.
+		 * Deferring the free disconnects freeing up the AGFL slot from
+		 * freeing the block.
+		 */
+		error = xfs_free_extent_later(tp,
+				XFS_AGB_TO_FSB(mp, args->agno, bno), 1,
+				&targs.oinfo, XFS_AG_RESV_AGFL, 0);
 		if (error)
 			goto out_agbp_relse;
 	}


