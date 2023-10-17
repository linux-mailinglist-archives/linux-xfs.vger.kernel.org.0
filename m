Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C12F17CC7F0
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Oct 2023 17:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344015AbjJQPto (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Oct 2023 11:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343939AbjJQPtn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:49:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BC9B0
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:49:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E69C4339A;
        Tue, 17 Oct 2023 15:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557781;
        bh=lqV0iskL4NVlAXcgAodf7xbUeOxCjPQ9CSOLMQdVn2Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rNBsiyjgX0cfQD6gwqY0XM8cQYFzV8leESIiLtuTdxe5PcTu81ZAx5ggCA8nUeKDS
         Hfml9C8JDCTj6abAV+QXpZh90oIIMCyZI9rWHEnPgyYC9dlTIY3boLJEUOUmE5VkXk
         KANgGbldO650oFqtQ1CfJYBG2f7M7kb6pw23ULPDGiPDCCbUqGzn+ewoFPWmO3dvh+
         Glg6YCI3EIFAwxHH85bmHhcKa/ixuKB0zQi9cciyoWA7R0WPWJCHeEo51PDG/tYWXT
         86q6q3tytKvJg7oYmkQmo9SM0LP2DYWgiep6HCsP8rZSABamaokpuK42iX5cRifWqg
         ZYFsDVOdHotBw==
Date:   Tue, 17 Oct 2023 08:49:41 -0700
Subject: [PATCH 7/8] xfs: rename xfs_verify_rtext to xfs_verify_rtbext
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755741387.3165534.16350115018713164849.stgit@frogsfrogsfrogs>
In-Reply-To: <169755741268.3165534.11886536508035251574.stgit@frogsfrogsfrogs>
References: <169755741268.3165534.11886536508035251574.stgit@frogsfrogsfrogs>
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

This helper function validates that a range of *blocks* in the
realtime section is completely contained within the realtime section.
It does /not/ validate ranges of *rtextents*.  Rename the function to
avoid suggesting that it does, and change the type of the @len parameter
since xfs_rtblock_t is a position unit, not a length unit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c  |    4 ++--
 fs/xfs/libxfs/xfs_types.c |    4 ++--
 fs/xfs/libxfs/xfs_types.h |    4 ++--
 fs/xfs/scrub/bmap.c       |    2 +-
 fs/xfs/scrub/rtbitmap.c   |    4 ++--
 fs/xfs/scrub/rtsummary.c  |    2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a47da8d3d1bc..4e7de4f2fd7a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6196,8 +6196,8 @@ xfs_bmap_validate_extent(
 		return __this_address;
 
 	if (XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK) {
-		if (!xfs_verify_rtext(mp, irec->br_startblock,
-					  irec->br_blockcount))
+		if (!xfs_verify_rtbext(mp, irec->br_startblock,
+					   irec->br_blockcount))
 			return __this_address;
 	} else {
 		if (!xfs_verify_fsbext(mp, irec->br_startblock,
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 5c2765934732..c299b16c9365 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -148,10 +148,10 @@ xfs_verify_rtbno(
 
 /* Verify that a realtime device extent is fully contained inside the volume. */
 bool
-xfs_verify_rtext(
+xfs_verify_rtbext(
 	struct xfs_mount	*mp,
 	xfs_rtblock_t		rtbno,
-	xfs_rtblock_t		len)
+	xfs_filblks_t		len)
 {
 	if (rtbno + len <= rtbno)
 		return false;
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 9af98a975239..9e45f13f6d70 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -231,8 +231,8 @@ bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
-bool xfs_verify_rtext(struct xfs_mount *mp, xfs_rtblock_t rtbno,
-		xfs_rtblock_t len);
+bool xfs_verify_rtbext(struct xfs_mount *mp, xfs_rtblock_t rtbno,
+		xfs_filblks_t len);
 bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
 bool xfs_verify_dablk(struct xfs_mount *mp, xfs_fileoff_t off);
 void xfs_icount_range(struct xfs_mount *mp, unsigned long long *min,
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 75588915572e..06d8c1996a33 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -410,7 +410,7 @@ xchk_bmap_iextent(
 
 	/* Make sure the extent points to a valid place. */
 	if (info->is_rt &&
-	    !xfs_verify_rtext(mp, irec->br_startblock, irec->br_blockcount))
+	    !xfs_verify_rtbext(mp, irec->br_startblock, irec->br_blockcount))
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (!info->is_rt &&
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 71d3e8b85844..8c8a611cc6d4 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -48,12 +48,12 @@ xchk_rtbitmap_rec(
 {
 	struct xfs_scrub	*sc = priv;
 	xfs_rtblock_t		startblock;
-	xfs_rtblock_t		blockcount;
+	xfs_filblks_t		blockcount;
 
 	startblock = rec->ar_startext * mp->m_sb.sb_rextsize;
 	blockcount = rec->ar_extcount * mp->m_sb.sb_rextsize;
 
-	if (!xfs_verify_rtext(mp, startblock, blockcount))
+	if (!xfs_verify_rtbext(mp, startblock, blockcount))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 	return 0;
 }
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index f4635a920470..d998f0c378a4 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -137,7 +137,7 @@ xchk_rtsum_record_free(
 	rtbno = rec->ar_startext * mp->m_sb.sb_rextsize;
 	rtlen = rec->ar_extcount * mp->m_sb.sb_rextsize;
 
-	if (!xfs_verify_rtext(mp, rtbno, rtlen)) {
+	if (!xfs_verify_rtbext(mp, rtbno, rtlen)) {
 		xchk_ino_xref_set_corrupt(sc, mp->m_rbmip->i_ino);
 		return -EFSCORRUPTED;
 	}

