Return-Path: <linux-xfs+bounces-2178-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC87C8211D0
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 01:11:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E99491C21C6B
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98174392;
	Mon,  1 Jan 2024 00:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M0dkevy1"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638F638E
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4A9C433C7;
	Mon,  1 Jan 2024 00:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067894;
	bh=ecr4JB+EOM0hNgnbAwUhRoCmEACQjsvd2/rYYjQk5PY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M0dkevy1gexoQLrKLftcsK58+DqN9OYjGjT8HSfmY6BoHVgszLTpRUj6RzNrQdkfB
	 DKgJSyxryTUFMveFWGJjjSS0nKwy1TzwIb4lA0O+RAOFTVFHMeZNDAQYnEKBca3laI
	 K6fAtcn6Ll1rjIqJTaNaB4xQ3RKrWdmGm3lYCFruXCcGrrvI4E6ChD8iaQvUHUu8RX
	 K4I2sUzAcStE1F6kjwHvABxU1LRUuZYtuOm6N5Ujk5KXujN3Px7LH9eF5BpObSEEo/
	 Rug3uWJNiIqO/RQZwsVimGOTi0doqlNGdr7blsqqERxUMya/PODUHiaNGIGtvWqwf5
	 d6mTvVn7cCGog==
Date: Sun, 31 Dec 2023 16:11:33 +9900
Subject: [PATCH 04/47] xfs: realtime rmap btree transaction reservations
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015366.1815505.12519901492978076894.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_swapext.c     |    4 +++-
 libxfs/xfs_trans_resv.c  |   12 ++++++++++--
 libxfs/xfs_trans_space.h |   13 +++++++++++++
 3 files changed, 26 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index 1f7fbe76a89..36283ea72cd 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -759,7 +759,9 @@ xfs_swapext_rmapbt_blocks(
 	if (!xfs_has_rmapbt(mp))
 		return 0;
 	if (XFS_IS_REALTIME_INODE(req->ip1))
-		return 0;
+		return howmany_64(req->nr_exchanges,
+					XFS_MAX_CONTIG_RTRMAPS_PER_BLOCK(mp)) *
+			XFS_RTRMAPADD_SPACE_RES(mp);
 
 	return howmany_64(req->nr_exchanges,
 					XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)) *
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 800a2f9ecb8..18efae57975 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -211,7 +211,9 @@ xfs_calc_inode_chunk_res(
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
@@ -220,10 +222,16 @@ xfs_rtalloc_block_count(
 {
 	unsigned int		rtbmp_blocks;
 	xfs_rtxlen_t		rtxlen;
+	unsigned int		t1, t2 = 0;
 
 	rtxlen = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN);
 	rtbmp_blocks = xfs_rtbitmap_blockcount(mp, rtxlen);
-	return (rtbmp_blocks + 1) * num_ops;
+	t1 = (rtbmp_blocks + 1) * num_ops;
+
+	if (xfs_has_rmapbt(mp))
+		t2 = num_ops * (2 * mp->m_rtrmap_maxlevels - 1);
+
+	return max(t1, t2);
 }
 
 /*
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 1155ff2d37e..d89b570aafc 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
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


