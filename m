Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11447CC7FF
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Oct 2023 17:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbjJQPur (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Oct 2023 11:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235082AbjJQPuq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:50:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700EBF2
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:50:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A35CC433C8;
        Tue, 17 Oct 2023 15:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557844;
        bh=hHBYxqlFJX3D+BREoPo7WWLy2SxREfA86S9xVcxVk+U=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=QlNo7nu38gs6mhSWEAQYEsMEA+tDMt9BhAjC7JpRZ8IOl2vSHbzmDdhit7B0jCo7p
         a9ZEqcDX5mQDJeqHktfeg8FTfChBWbzVf4dZJyiUpO0Dx80nyCwr7wzt+aVZo/s9s8
         lkQaqDkO7+/xHSZEJ82HRF0cyQq1yDKcGgAYFV+mGFSXIFFTK6Jsu8/98hPdBzGZGy
         vXl8QNVFWyBuXPWf1JqWqstfflpTlLRFMos4Y0Q0D6/nb5lbgNjjvF5eOmgV7uxTQZ
         8Aop8BYSX+VY3FV1k8jgeQi0n2llOBglFJ50yBZOEmHpwHdSquiabFNdhe8v+aoJ89
         X9nsrWYMZUKeg==
Date:   Tue, 17 Oct 2023 08:50:43 -0700
Subject: [PATCH 3/7] xfs: create a helper to convert extlen to rtextlen
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755741773.3165781.6862712999038809419.stgit@frogsfrogsfrogs>
In-Reply-To: <169755741717.3165781.12142780069035126128.stgit@frogsfrogsfrogs>
References: <169755741717.3165781.12142780069035126128.stgit@frogsfrogsfrogs>
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

Create a helper to compute the realtime extent (xfs_rtxlen_t) from an
extent length (xfs_extlen_t) value.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.h   |    8 ++++++++
 fs/xfs/libxfs/xfs_trans_resv.c |    3 ++-
 fs/xfs/xfs_bmap_util.c         |   11 ++++-------
 fs/xfs/xfs_trans.c             |    3 ++-
 4 files changed, 16 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index b6a4c46bddc0..e2a36fc157c4 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -31,6 +31,14 @@ xfs_extlen_to_rtxmod(
 	return len % mp->m_sb.sb_rextsize;
 }
 
+static inline xfs_rtxlen_t
+xfs_extlen_to_rtxlen(
+	struct xfs_mount	*mp,
+	xfs_extlen_t		len)
+{
+	return len / mp->m_sb.sb_rextsize;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5b2f27cbdb80..4629f10d2f67 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -19,6 +19,7 @@
 #include "xfs_trans.h"
 #include "xfs_qm.h"
 #include "xfs_trans_space.h"
+#include "xfs_rtbitmap.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -220,7 +221,7 @@ xfs_rtalloc_block_count(
 	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
 	unsigned int		rtbmp_bytes;
 
-	rtbmp_bytes = (XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize) / NBBY;
+	rtbmp_bytes = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN) / NBBY;
 	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
 }
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8895184ff90a..4f53f784f06d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -90,7 +90,7 @@ xfs_bmap_rtalloc(
 
 	align = xfs_get_extsz_hint(ap->ip);
 retry:
-	prod = align / mp->m_sb.sb_rextsize;
+	prod = xfs_extlen_to_rtxlen(mp, align);
 	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 					align, 1, ap->eof, 0,
 					ap->conv, &ap->offset, &ap->length);
@@ -117,17 +117,14 @@ xfs_bmap_rtalloc(
 		prod = 1;
 	/*
 	 * Set ralen to be the actual requested length in rtextents.
-	 */
-	ralen = ap->length / mp->m_sb.sb_rextsize;
-	/*
+	 *
 	 * If the old value was close enough to XFS_BMBT_MAX_EXTLEN that
 	 * we rounded up to it, cut it back so it's valid again.
 	 * Note that if it's a really large request (bigger than
 	 * XFS_BMBT_MAX_EXTLEN), we don't hear about that number, and can't
 	 * adjust the starting point to match it.
 	 */
-	if (xfs_rtxlen_to_extlen(mp, ralen) >= XFS_MAX_BMBT_EXTLEN)
-		ralen = XFS_MAX_BMBT_EXTLEN / mp->m_sb.sb_rextsize;
+	ralen = xfs_extlen_to_rtxlen(mp, min(ap->length, XFS_MAX_BMBT_EXTLEN));
 
 	/*
 	 * Lock out modifications to both the RT bitmap and summary inodes
@@ -164,7 +161,7 @@ xfs_bmap_rtalloc(
 		do_div(ap->blkno, mp->m_sb.sb_rextsize);
 	rtx = ap->blkno;
 	ap->length = ralen;
-	raminlen = max_t(xfs_extlen_t, 1, minlen / mp->m_sb.sb_rextsize);
+	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
 	error = xfs_rtallocate_extent(ap->tp, ap->blkno, raminlen, ap->length,
 			&ralen, ap->wasdel, prod, &rtx);
 	if (error)
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8c0bfc9a33b1..338dd3774507 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -24,6 +24,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_icache.h"
+#include "xfs_rtbitmap.h"
 
 struct kmem_cache	*xfs_trans_cache;
 
@@ -1196,7 +1197,7 @@ xfs_trans_alloc_inode(
 
 retry:
 	error = xfs_trans_alloc(mp, resv, dblocks,
-			rblocks / mp->m_sb.sb_rextsize,
+			xfs_extlen_to_rtxlen(mp, rblocks),
 			force ? XFS_TRANS_RESERVE : 0, &tp);
 	if (error)
 		return error;

