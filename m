Return-Path: <linux-xfs+bounces-17551-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C0859FB76B
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Dec 2024 23:59:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB9F91884E01
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Dec 2024 22:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19D91A8F6B;
	Mon, 23 Dec 2024 22:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p0opZC7r"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13187462
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994741; cv=none; b=i66sHWLZJlbbNFzE5lPx2K9SiYG7cSXRNkS39kEtXkGWaeoE9Lmht/wSudnZsL6bjVgYx48gyiQKEkmwi0DX2SxXqMf5a7rDrnmdaYY13Fa/J0s1v0GFzSNKScL8sYllCINzTYJp23m7+8YDQ71mO1vU7Tn2juNLSbHWoPbnJ/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994741; c=relaxed/simple;
	bh=j4/+z8XATtYC6MA0NIbY4FufmbJlL5R4ffS0qafyohc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CgeXQtM58OfCRXbowyj/elZzbkcUfLPt8wcIv0HspiihORvWhXDzO9d4RUDpDIBevg1j5LkSORNSnT3yNDMYtUlWLq2hgZkGYa8m+/ZJ6grKQQMM+qc350cYHi/T63g9GSx7KobN47JzcvFaB4HrMKK/aJ6l06dQr1KRfmDFHrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p0opZC7r; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B71C4CED3;
	Mon, 23 Dec 2024 22:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994740;
	bh=j4/+z8XATtYC6MA0NIbY4FufmbJlL5R4ffS0qafyohc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p0opZC7rVQmpD4bM0r4me+RQqdkWOBkvhB5o+QQApzPUBEW+G4ypiIonoNhTDvlf6
	 6ojyFC44Wh+1rL2aomINaw2q2gqxHVX+kFvWR+i0kZ8dfFAWAiuDn6TxggLmkp5lzg
	 XJtSEWqTGtZBnzbOlGLUTIIyiT2nunuXPqqM4we8wVXqvQZ+wtb6VqXiCAgEJlkxcd
	 +wLaWlnoMgEmdLltxDe0lSQiKxPdI/rQQzWkLpSeIo18cCZkqu+TCYe1J/st8y9Q47
	 BLHvznUswvBpWCIrg1gNColul6N+cq9CvXJ/reyWz3nuoV/oihh79cZO/kO7htGxhs
	 RNgoyz+1PSOXw==
Date: Mon, 23 Dec 2024 14:58:59 -0800
Subject: [PATCH 09/37] xfs: support recovering rmap intent items targetting
 realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499418869.2380130.18353525538860365992.stgit@frogsfrogsfrogs>
In-Reply-To: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
References: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we have rmap on the realtime device and rmap intent items that
target the realtime device, log recovery has to support remapping
extents on the realtime volume.  Make this work.  Identify rtrmapbt
blocks in the log correctly so that we can validate them during log
recovery.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item_recover.c |    4 ++++
 fs/xfs/xfs_rmap_item.c        |   15 ++++++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 3d0c6402cb3634..4f2e4ea29e1f57 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -262,6 +262,9 @@ xlog_recover_validate_buf_type(
 		case XFS_BMAP_MAGIC:
 			bp->b_ops = &xfs_bmbt_buf_ops;
 			break;
+		case XFS_RTRMAP_CRC_MAGIC:
+			bp->b_ops = &xfs_rtrmapbt_buf_ops;
+			break;
 		case XFS_RMAP_CRC_MAGIC:
 			bp->b_ops = &xfs_rmapbt_buf_ops;
 			break;
@@ -855,6 +858,7 @@ xlog_recover_get_buf_lsn(
 		uuid = &btb->bb_u.s.bb_uuid;
 		break;
 	}
+	case XFS_RTRMAP_CRC_MAGIC:
 	case XFS_BMAP_CRC_MAGIC:
 	case XFS_BMAP_MAGIC: {
 		struct xfs_btree_block *btb = blk;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index e8caa600a95cae..89decffe76c8b5 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -459,6 +459,7 @@ xfs_rmap_update_abort_intent(
 static inline bool
 xfs_rui_validate_map(
 	struct xfs_mount		*mp,
+	bool				isrt,
 	struct xfs_map_extent		*map)
 {
 	if (!xfs_has_rmapbt(mp))
@@ -488,6 +489,9 @@ xfs_rui_validate_map(
 	if (!xfs_verify_fileext(mp, map->me_startoff, map->me_len))
 		return false;
 
+	if (isrt)
+		return xfs_verify_rtbext(mp, map->me_startblock, map->me_len);
+
 	return xfs_verify_fsbext(mp, map->me_startblock, map->me_len);
 }
 
@@ -495,6 +499,7 @@ static inline void
 xfs_rui_recover_work(
 	struct xfs_mount		*mp,
 	struct xfs_defer_pending	*dfp,
+	bool				isrt,
 	const struct xfs_map_extent	*map)
 {
 	struct xfs_rmap_intent		*ri;
@@ -539,7 +544,9 @@ xfs_rui_recover_work(
 	ri->ri_bmap.br_blockcount = map->me_len;
 	ri->ri_bmap.br_state = (map->me_flags & XFS_RMAP_EXTENT_UNWRITTEN) ?
 			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
-	ri->ri_group = xfs_group_intent_get(mp, map->me_startblock, XG_TYPE_AG);
+	ri->ri_group = xfs_group_intent_get(mp, map->me_startblock,
+			isrt ? XG_TYPE_RTG : XG_TYPE_AG);
+	ri->ri_realtime = isrt;
 
 	xfs_defer_add_item(dfp, &ri->ri_list);
 }
@@ -558,6 +565,7 @@ xfs_rmap_recover_work(
 	struct xfs_rui_log_item		*ruip = RUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
+	bool				isrt = xfs_rui_item_isrt(lip);
 	int				i;
 	int				error = 0;
 
@@ -567,7 +575,7 @@ xfs_rmap_recover_work(
 	 * just toss the RUI.
 	 */
 	for (i = 0; i < ruip->rui_format.rui_nextents; i++) {
-		if (!xfs_rui_validate_map(mp,
+		if (!xfs_rui_validate_map(mp, isrt,
 					&ruip->rui_format.rui_extents[i])) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					&ruip->rui_format,
@@ -575,7 +583,8 @@ xfs_rmap_recover_work(
 			return -EFSCORRUPTED;
 		}
 
-		xfs_rui_recover_work(mp, dfp, &ruip->rui_format.rui_extents[i]);
+		xfs_rui_recover_work(mp, dfp, isrt,
+				&ruip->rui_format.rui_extents[i]);
 	}
 
 	resv = xlog_recover_resv(&M_RES(mp)->tr_itruncate);


