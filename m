Return-Path: <linux-xfs+bounces-17196-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BCD09F843A
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Dec 2024 20:28:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48E2C189325A
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Dec 2024 19:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45251B041E;
	Thu, 19 Dec 2024 19:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1uG/YrJ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940921AAA0D
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636470; cv=none; b=ZGC3nkFUx1AO8kGRzS18uU0hZJRsztxpVnB6v5kbGcTL5v78e8DSYrEAL5cXosnNxT/0Bebo/jecgao1OXQc2r5LOzPppknre9fW/JhpjyN7SrJ9S1PdPW+tlIfnozYswRPGqeu2Ho8heudoBxhSlKaO+O6XIv29vLtn647F9AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636470; c=relaxed/simple;
	bh=Z/5mEe0s8Y5uJE9GkSsnWI/fWPNaJwg9Xcptz7rZlHU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HjE3kGQKtDq64TAoTaVKLidyckVThGpNHMCTPY0FWF6GL61OmoALwyMSuVqSu0I5VX03qTPDUNCGbBZPiNtdS+f1YIuL9cHZMiOlCa9EM4N79t36ASHebU+rd+dIMv4EGmCs/VNANIQ+cMDDjHVMpVsveM5TPWBFPZ6aYyHt1b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1uG/YrJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B74CC4CED0;
	Thu, 19 Dec 2024 19:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636470;
	bh=Z/5mEe0s8Y5uJE9GkSsnWI/fWPNaJwg9Xcptz7rZlHU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A1uG/YrJ209A3s1FKp+wMvDyNADE4nZj/K/p9efPwStfZ5kCpW7sm5Te3ZeTS+ScG
	 cqcoJ5lT4Pn0DRLwDpX2GWD2fETudGq7962B51rr/N8ITuQ85BndV8lqkmEUlXWTun
	 gzKF6lazXuNgze4ecpm4Iidfz3uCqUQRYzjZCIj60wqLSfAxdJ9kQMjUF2n+CwGopY
	 4vgdk7YOXFSo27zsbYXsRvEZJ36sHqQ3RUpDC8/hGvfb3S2Mr8FlOAw5xiJWJlS0L0
	 PH8kHH0uexx1Qc3QQVQ57dJ7yCtWaiffeVwzUVGzm9wA9cIpmXITaKnyHBAJ1X7weE
	 inIBCm7/jbRHA==
Date: Thu, 19 Dec 2024 11:27:49 -0800
Subject: [PATCH 17/37] xfs: wire up getfsmap to the realtime reverse mapping
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463580048.1571512.16802650750374605017.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Connect the getfsmap ioctl to the realtime rmapbt.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsmap.c |  174 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 173 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 3290dd8524a69a..3e3ef16f65a335 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -26,6 +26,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_ag.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 static void
@@ -832,6 +833,174 @@ xfs_getfsmap_rtdev_rtbitmap(
 
 	return error;
 }
+
+/* Transform a realtime rmapbt record into a fsmap */
+STATIC int
+xfs_getfsmap_rtdev_rmapbt_helper(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xfs_fsmap_irec		frec = {
+		.owner			= rec->rm_owner,
+		.offset			= rec->rm_offset,
+		.rm_flags		= rec->rm_flags,
+		.rec_key		= rec->rm_startblock,
+	};
+	struct xfs_getfsmap_info	*info = priv;
+
+	return xfs_getfsmap_group_helper(info, cur->bc_tp, cur->bc_group,
+			rec->rm_startblock, rec->rm_blockcount, &frec);
+}
+
+/* Actually query the rtrmap btree. */
+STATIC int
+xfs_getfsmap_rtdev_rmapbt_query(
+	struct xfs_trans		*tp,
+	struct xfs_getfsmap_info	*info,
+	struct xfs_btree_cur		**curpp)
+{
+	struct xfs_rtgroup		*rtg = to_rtg(info->group);
+
+	/* Query the rtrmapbt */
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+	*curpp = xfs_rtrmapbt_init_cursor(tp, rtg);
+	return xfs_rmap_query_range(*curpp, &info->low, &info->high,
+			xfs_getfsmap_rtdev_rmapbt_helper, info);
+}
+
+/* Execute a getfsmap query against the realtime device rmapbt. */
+STATIC int
+xfs_getfsmap_rtdev_rmapbt(
+	struct xfs_trans		*tp,
+	const struct xfs_fsmap		*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_rtgroup		*rtg = NULL;
+	struct xfs_btree_cur		*bt_cur = NULL;
+	xfs_rtblock_t			start_rtb;
+	xfs_rtblock_t			end_rtb;
+	xfs_rgnumber_t			start_rg, end_rg;
+	uint64_t			eofs;
+	int				error = 0;
+
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	if (keys[0].fmr_physical >= eofs)
+		return 0;
+	start_rtb = xfs_daddr_to_rtb(mp, keys[0].fmr_physical);
+	end_rtb = xfs_daddr_to_rtb(mp, min(eofs - 1, keys[1].fmr_physical));
+
+	info->missing_owner = XFS_FMR_OWN_FREE;
+
+	/*
+	 * Convert the fsmap low/high keys to rtgroup based keys.  Initialize
+	 * low to the fsmap low key and max out the high key to the end
+	 * of the rtgroup.
+	 */
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
+	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
+	if (error)
+		return error;
+	info->low.rm_blockcount = XFS_BB_TO_FSBT(mp, keys[0].fmr_length);
+	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
+
+	/* Adjust the low key if we are continuing from where we left off. */
+	if (info->low.rm_blockcount == 0) {
+		/* No previous record from which to continue */
+	} else if (rmap_not_shareable(mp, &info->low)) {
+		/* Last record seen was an unshareable extent */
+		info->low.rm_owner = 0;
+		info->low.rm_offset = 0;
+
+		start_rtb += info->low.rm_blockcount;
+		if (xfs_rtb_to_daddr(mp, start_rtb) >= eofs)
+			return 0;
+	} else {
+		/* Last record seen was a shareable file data extent */
+		info->low.rm_offset += info->low.rm_blockcount;
+	}
+	info->low.rm_startblock = xfs_rtb_to_rgbno(mp, start_rtb);
+
+	info->high.rm_startblock = -1U;
+	info->high.rm_owner = ULLONG_MAX;
+	info->high.rm_offset = ULLONG_MAX;
+	info->high.rm_blockcount = 0;
+	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
+
+	start_rg = xfs_rtb_to_rgno(mp, start_rtb);
+	end_rg = xfs_rtb_to_rgno(mp, end_rtb);
+
+	while ((rtg = xfs_rtgroup_next_range(mp, rtg, start_rg, end_rg))) {
+		/*
+		 * Set the rtgroup high key from the fsmap high key if this
+		 * is the last rtgroup that we're querying.
+		 */
+		info->group = rtg_group(rtg);
+		if (rtg_rgno(rtg) == end_rg) {
+			info->high.rm_startblock =
+				xfs_rtb_to_rgbno(mp, end_rtb);
+			info->high.rm_offset =
+				XFS_BB_TO_FSBT(mp, keys[1].fmr_offset);
+			error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
+			if (error)
+				break;
+			xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
+		}
+
+		if (bt_cur) {
+			xfs_rtgroup_unlock(to_rtg(bt_cur->bc_group),
+					XFS_RTGLOCK_RMAP);
+			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+			bt_cur = NULL;
+		}
+
+		trace_xfs_fsmap_low_group_key(mp, info->dev, rtg_rgno(rtg),
+				&info->low);
+		trace_xfs_fsmap_high_group_key(mp, info->dev, rtg_rgno(rtg),
+				&info->high);
+
+		error = xfs_getfsmap_rtdev_rmapbt_query(tp, info, &bt_cur);
+		if (error)
+			break;
+
+		/*
+		 * Set the rtgroup low key to the start of the rtgroup prior to
+		 * moving on to the next rtgroup.
+		 */
+		if (rtg_rgno(rtg) == start_rg)
+			memset(&info->low, 0, sizeof(info->low));
+
+		/*
+		 * If this is the last rtgroup, report any gap at the end of it
+		 * before we drop the reference to the perag when the loop
+		 * terminates.
+		 */
+		if (rtg_rgno(rtg) == end_rg) {
+			info->last = true;
+			error = xfs_getfsmap_rtdev_rmapbt_helper(bt_cur,
+					&info->high, info);
+			if (error)
+				break;
+		}
+		info->group = NULL;
+	}
+
+	if (bt_cur) {
+		xfs_rtgroup_unlock(to_rtg(bt_cur->bc_group),
+				XFS_RTGLOCK_RMAP);
+		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
+							 XFS_BTREE_NOERROR);
+	}
+
+	/* loop termination case */
+	if (rtg) {
+		info->group = NULL;
+		xfs_rtgroup_rele(rtg);
+	}
+
+	return error;
+}
 #endif /* CONFIG_XFS_RT */
 
 /* Do we recognize the device? */
@@ -971,7 +1140,10 @@ xfs_getfsmap(
 	if (mp->m_rtdev_targp) {
 		handlers[2].nr_sectors = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
 		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
-		handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
+		if (use_rmap)
+			handlers[2].fn = xfs_getfsmap_rtdev_rmapbt;
+		else
+			handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
 	}
 #endif /* CONFIG_XFS_RT */
 


