Return-Path: <linux-xfs+bounces-7336-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DBCCE8AD23A
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Apr 2024 18:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6CC2B24972
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Apr 2024 16:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 847AD154C12;
	Mon, 22 Apr 2024 16:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nyQhufKs"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EE96A039
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804000; cv=none; b=QIGW3ShfWfHyIHLBeOjlISy5FVlR6o6+SLrEigrWwcQrMq/WdPM0pEsIttnvhh9qUKdarPn0jEI+XpfQ9WaFTxfh67F4iNUEEoFC4xGbFTgsSovJN94wfa7nVUSe/4qXfrROam/EWPHfDgDiV5c83XHdReWW+rA7um4bmtiLsq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804000; c=relaxed/simple;
	bh=GQjrV1YIt6nsqALvikL/YeliW4jr3cFkets2jHSHHNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drkGYkxjmeLVP0qpJxeMuQCQOTlz7bgEHsWGFWWM7JlG0I/7s01vJb9l1qEuv9/BRa9qJ2XzKzmIBEQWzrcJysD8mTwmMQz+ChbSa+7ygKf/kKtpn5Yb5Qi5a2iT2017527H2H4IaPl7ZJSYfxUwn3aarIO/EqtIhaDIj57TwJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nyQhufKs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33951C116B1;
	Mon, 22 Apr 2024 16:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804000;
	bh=GQjrV1YIt6nsqALvikL/YeliW4jr3cFkets2jHSHHNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nyQhufKs3IxzUCeYqnfoui1vKEngVfncpyAZl8FLtE03hds8KDvfedMFMK406kaVc
	 CuvXnRzdruKJceY8DxlLBMXEslKQA4+X49dlekYdfaoPPL52R0nmXEIXbNlRDbG97I
	 6EL8tpmQo9jQMTkL4GNxBCISHId9cuTOLZQ6gm2/R1NDUCS3V1rNdevDTgdM9Q7C3i
	 m2oLqMS/CQiuUWWO6MW7j81eZkUPOwBN2OCZySvdckuZlq/88b5+saevpflipEuWQl
	 gJmuF7GYM9cQc8QCAl78nyU7FtLnHaIqhIQ7z62ktLr7X0R56kLChDEkasjjxTPOFe
	 eHcTBwtFHzcsg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 34/67] xfs: repair free space btrees
Date: Mon, 22 Apr 2024 18:25:56 +0200
Message-ID: <20240422163832.858420-36-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 4bdfd7d15747b170ce93a06fafccaf20544b6684

Rebuild the free space btrees from the gaps in the rmap btree.  Refer to
the case study in Documentation/filesystems/xfs-online-fsck-design.rst
for more details.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ag.h          |  9 +++++++++
 libxfs/xfs_ag_resv.c     |  2 ++
 libxfs/xfs_alloc.c       | 10 ++++------
 libxfs/xfs_alloc.h       |  2 +-
 libxfs/xfs_alloc_btree.c | 13 ++++++++++++-
 libxfs/xfs_types.h       |  7 +++++++
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
-- 
2.44.0


