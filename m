Return-Path: <linux-xfs+bounces-7115-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 882A18A8DFB
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 23:30:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E4941F218F1
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 21:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05B5A65190;
	Wed, 17 Apr 2024 21:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J6I49SCl"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5508F4A
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389439; cv=none; b=neo7/iQ2P72WKDdoeESYgvrTYD1A04Crgyjc6YNTAri0Lu90c1wWnO2kaGXaX1DEc39NmIdZzc666CGcdbOIqAOCQcIqzROm1X+Gs5woXHDMKKEt9j6OoBWm8UBt/xNVdTRSey84h0KqmIO19m8hccQAmI+eyASjN4136wcwsFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389439; c=relaxed/simple;
	bh=SFoFj0jHNTdMTi9BB8BhP3kWCqfW0HM7KroR7M5LvLA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PmjoaxqFdHiOY5RYa2VHDku9qnVJLp3HgoUkpqip1WaqsPPalBEs40GevgNE6w9C3M56/naUT+K4K/M3rl6tdMwTJtgwUrrbNA3+RPu6E93IFHEdSMpyOIoodMHUUDXwCy9c6ntYIEJsAzhFw3py8TFkBaWS/PlmTlRKQ1zn7zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J6I49SCl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC45C072AA;
	Wed, 17 Apr 2024 21:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389439;
	bh=SFoFj0jHNTdMTi9BB8BhP3kWCqfW0HM7KroR7M5LvLA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J6I49SCl5MQc6VXZSY8syS6k4eNEis2UgsrTRO4IIH6aOxAwxo1nlzsxBIBUUoFtD
	 a65BU/YLx7SEZDaq9EPPVfk2UpBwKw/MEhxviunibnaAzbM9ks9WfInOC9tWwpj9GE
	 lk4FsQfzoro4ERJK/c10jVbAvYQKMMz9bpyNhrXZM8CMzt3qm/xEJTkWvQnTMvQu5e
	 eoU5YtVWs2D054mBGvmb2Qdlx7y4I2AT0eBJyWMIe4W2Xi94xCcS31TjgH6FmRb+WX
	 gZHdtUFHb2lFWWjyqaKqgqlF867s0WwsgqLvOq7WH8Vgei8MEAxDbSehE6dsBVIv1u
	 fUYOnwvdZQd2g==
Date: Wed, 17 Apr 2024 14:30:38 -0700
Subject: [PATCH 34/67] xfs: repair free space btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338842851.1853449.13157860239600549640.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4bdfd7d15747b170ce93a06fafccaf20544b6684

Rebuild the free space btrees from the gaps in the rmap btree.  Refer to
the case study in Documentation/filesystems/xfs-online-fsck-design.rst
for more details.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_ag.h          |    9 +++++++++
 libxfs/xfs_ag_resv.c     |    2 ++
 libxfs/xfs_alloc.c       |   10 ++++------
 libxfs/xfs_alloc.h       |    2 +-
 libxfs/xfs_alloc_btree.c |   13 ++++++++++++-
 libxfs/xfs_types.h       |    7 +++++++
 6 files changed, 35 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 2e0aef87d..f16cb7a17 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -80,6 +80,15 @@ struct xfs_perag {
 	 */
 	uint16_t	pag_checked;
 	uint16_t	pag_sick;
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+	/*
+	 * Alternate btree heights so that online repair won't trip the write
+	 * verifiers while rebuilding the AG btrees.
+	 */
+	uint8_t		pagf_repair_levels[XFS_BTNUM_AGF];
+#endif
+
 	spinlock_t	pag_state_lock;
 
 	spinlock_t	pagb_lock;	/* lock for pagb_tree */
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
index 29bbcb55d..3a80b1613 100644
--- a/libxfs/xfs_ag_resv.c
+++ b/libxfs/xfs_ag_resv.c
@@ -410,6 +410,8 @@ xfs_ag_resv_free_extent(
 		fallthrough;
 	case XFS_AG_RESV_NONE:
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
+		fallthrough;
+	case XFS_AG_RESV_IGNORE:
 		return;
 	}
 
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index aaa159615..352efbeca 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -242,11 +242,9 @@ xfs_alloc_btrec_to_irec(
 /* Simple checks for free space records. */
 xfs_failaddr_t
 xfs_alloc_check_irec(
-	struct xfs_btree_cur		*cur,
-	const struct xfs_alloc_rec_incore *irec)
+	struct xfs_perag			*pag,
+	const struct xfs_alloc_rec_incore	*irec)
 {
-	struct xfs_perag		*pag = cur->bc_ag.pag;
-
 	if (irec->ar_blockcount == 0)
 		return __this_address;
 
@@ -295,7 +293,7 @@ xfs_alloc_get_rec(
 		return error;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
-	fa = xfs_alloc_check_irec(cur, &irec);
+	fa = xfs_alloc_check_irec(cur->bc_ag.pag, &irec);
 	if (fa)
 		return xfs_alloc_complain_bad_rec(cur, fa, &irec);
 
@@ -3940,7 +3938,7 @@ xfs_alloc_query_range_helper(
 	xfs_failaddr_t				fa;
 
 	xfs_alloc_btrec_to_irec(rec, &irec);
-	fa = xfs_alloc_check_irec(cur, &irec);
+	fa = xfs_alloc_check_irec(cur->bc_ag.pag, &irec);
 	if (fa)
 		return xfs_alloc_complain_bad_rec(cur, fa, &irec);
 
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 851cafbd6..0b956f8b9 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -185,7 +185,7 @@ xfs_alloc_get_rec(
 union xfs_btree_rec;
 void xfs_alloc_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_alloc_rec_incore *irec);
-xfs_failaddr_t xfs_alloc_check_irec(struct xfs_btree_cur *cur,
+xfs_failaddr_t xfs_alloc_check_irec(struct xfs_perag *pag,
 		const struct xfs_alloc_rec_incore *irec);
 
 int xfs_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 5ec14288d..a472ec6d2 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -321,7 +321,18 @@ xfs_allocbt_verify(
 	if (bp->b_ops->magic[0] == cpu_to_be32(XFS_ABTC_MAGIC))
 		btnum = XFS_BTNUM_CNTi;
 	if (pag && xfs_perag_initialised_agf(pag)) {
-		if (level >= pag->pagf_levels[btnum])
+		unsigned int	maxlevel = pag->pagf_levels[btnum];
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+		/*
+		 * Online repair could be rewriting the free space btrees, so
+		 * we'll validate against the larger of either tree while this
+		 * is going on.
+		 */
+		maxlevel = max_t(unsigned int, maxlevel,
+				 pag->pagf_repair_levels[btnum]);
+#endif
+		if (level >= maxlevel)
 			return __this_address;
 	} else if (level >= mp->m_alloc_maxlevels)
 		return __this_address;
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 533200c4c..035bf703d 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -208,6 +208,13 @@ enum xfs_ag_resv_type {
 	XFS_AG_RESV_AGFL,
 	XFS_AG_RESV_METADATA,
 	XFS_AG_RESV_RMAPBT,
+
+	/*
+	 * Don't increase fdblocks when freeing extent.  This is a pony for
+	 * the bnobt repair functions to re-free the free space without
+	 * altering fdblocks.  If you think you need this you're wrong.
+	 */
+	XFS_AG_RESV_IGNORE,
 };
 
 /* Results of scanning a btree keyspace to check occupancy. */


