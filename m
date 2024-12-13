Return-Path: <linux-xfs+bounces-16621-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA469F0170
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 02:01:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9ED76188A22D
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 01:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8812C8BEC;
	Fri, 13 Dec 2024 01:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F/VCpc/E"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460687485
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051714; cv=none; b=MBiJZMf7cfhf8JgMNW/vExFR8ObqRsLtqeJ091Fr/E978wt3YdGc3fm+h3Lh6QriFoA30rFWl1BrAnGIUXX7mE7DNQbpZtvEwrQjyTC4KPXmRolmbP6xPKNx5vmOyD3+tq64IIPtr/2SJFWYJIiPUW+fzMd87KqyDV5kp4mCRUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051714; c=relaxed/simple;
	bh=lIwZew1L2geLGB9vn4+JuQwT6Sh4NZt+BA6+78TQRG0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jarYAc1IpAG7ExV88XhVO72yExStRA5iVjn1g1RsFCB03jprzfZ7fNYPbMu6941ebX8zDPQ5BI8vWtkz5jhvHTaiHCbbdCuugfjrFg3xktyjIe8t8dzgDWKt1sBvSjiVsBAHCyy+EmtEK0C6d67d5NXqkONjSKPmvA8Et/dFjgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F/VCpc/E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EE7C4CECE;
	Fri, 13 Dec 2024 01:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051713;
	bh=lIwZew1L2geLGB9vn4+JuQwT6Sh4NZt+BA6+78TQRG0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F/VCpc/EOlrNQctElDFNfSaAIDHB2X+MSs32Zol3GSLRJBige0qjR7WHXyDGfpNLM
	 X+++BVTpCm9M5yIxooZuUw/DOAvC+rccSNX9NYWNAay8LG2do0R60O7Ln83P+aLINw
	 i8sQyUoTYrnXUH5hkG8MNGnJetopjYK3ZPLPKIP3/eJXra7sIzD04JkrjfFnoabV6l
	 2SY141YcFLEmvVHMlThPX8oVzHq7kq3WDOHnOn3nBK2Sdwl4Twl+wwklCnN5Al/T8u
	 C37EEbmrXopBrg1S9dPlC9qhd8J1oD+k9f7wGNfiF0HVVOxue1IBzoWc8fTwrjvLsW
	 p77oLwP87uejg==
Date: Thu, 12 Dec 2024 17:01:53 -0800
Subject: [PATCH 05/37] xfs: realtime rmap btree transaction reservations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123399.1181370.1254278860717277218.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure that there's enough log reservation to handle mapping
and unmapping realtime extents.  We have to reserve enough space
to handle a split in the rtrmapbt to add the record and a second
split in the regular rmapbt to record the rtrmapbt split.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_exchmaps.c    |    4 +++-
 fs/xfs/libxfs/xfs_trans_resv.c  |   12 ++++++++++--
 fs/xfs/libxfs/xfs_trans_space.h |   13 +++++++++++++
 3 files changed, 26 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 2021396651de27..3f1d6a98c11819 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -662,7 +662,9 @@ xfs_exchmaps_rmapbt_blocks(
 	if (!xfs_has_rmapbt(mp))
 		return 0;
 	if (XFS_IS_REALTIME_INODE(req->ip1))
-		return 0;
+		return howmany_64(req->nr_exchanges,
+					XFS_MAX_CONTIG_RTRMAPS_PER_BLOCK(mp)) *
+			XFS_RTRMAPADD_SPACE_RES(mp);
 
 	return howmany_64(req->nr_exchanges,
 					XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)) *
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index bab402340b5da8..f3392eb2d7f41f 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -213,7 +213,9 @@ xfs_calc_inode_chunk_res(
  * Per-extent log reservation for the btree changes involved in freeing or
  * allocating a realtime extent.  We have to be able to log as many rtbitmap
  * blocks as needed to mark inuse XFS_BMBT_MAX_EXTLEN blocks' worth of realtime
- * extents, as well as the realtime summary block.
+ * extents, as well as the realtime summary block (t1).  Realtime rmap btree
+ * operations happen in a second transaction, so factor in a couple of rtrmapbt
+ * splits (t2).
  */
 static unsigned int
 xfs_rtalloc_block_count(
@@ -222,10 +224,16 @@ xfs_rtalloc_block_count(
 {
 	unsigned int		rtbmp_blocks;
 	xfs_rtxlen_t		rtxlen;
+	unsigned int		t1, t2 = 0;
 
 	rtxlen = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN);
 	rtbmp_blocks = xfs_rtbitmap_blockcount_len(mp, rtxlen);
-	return (rtbmp_blocks + 1) * num_ops;
+	t1 = (rtbmp_blocks + 1) * num_ops;
+
+	if (xfs_has_rmapbt(mp))
+		t2 = num_ops * (2 * mp->m_rtrmap_maxlevels - 1);
+
+	return max(t1, t2);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 1155ff2d37e29f..d89b570aafcc64 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -14,6 +14,19 @@
 #define XFS_MAX_CONTIG_BMAPS_PER_BLOCK(mp)    \
 		(((mp)->m_bmap_dmxr[0]) - ((mp)->m_bmap_dmnr[0]))
 
+/* Worst case number of realtime rmaps that can be held in a block. */
+#define XFS_MAX_CONTIG_RTRMAPS_PER_BLOCK(mp)    \
+		(((mp)->m_rtrmap_mxr[0]) - ((mp)->m_rtrmap_mnr[0]))
+
+/* Adding one realtime rmap could split every level to the top of the tree. */
+#define XFS_RTRMAPADD_SPACE_RES(mp) ((mp)->m_rtrmap_maxlevels)
+
+/* Blocks we might need to add "b" realtime rmaps to a tree. */
+#define XFS_NRTRMAPADD_SPACE_RES(mp, b) \
+	((((b) + XFS_MAX_CONTIG_RTRMAPS_PER_BLOCK(mp) - 1) / \
+	  XFS_MAX_CONTIG_RTRMAPS_PER_BLOCK(mp)) * \
+	  XFS_RTRMAPADD_SPACE_RES(mp))
+
 /* Worst case number of rmaps that can be held in a block. */
 #define XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)    \
 		(((mp)->m_rmap_mxr[0]) - ((mp)->m_rmap_mnr[0]))


