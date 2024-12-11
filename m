Return-Path: <linux-xfs+bounces-16483-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 617C79EC811
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Dec 2024 09:58:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA0E5160740
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Dec 2024 08:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 250D51F0E23;
	Wed, 11 Dec 2024 08:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ot6yAQ2L"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884641EC4EC
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907511; cv=none; b=BwS8cHUXBcU/A2YGLPoXbP3lOKCJUxBxeBptgm2VeLcxfHAIMvf2iH8Vl9aAU9RkZJmJL2R73nYcRrtM4SdSTpVXcmpwq5wWyxOrw2FqnBt6y7cYz1dRsaVKWo5cIPGNYcvfVkNjpjQef44igL694PhPxhJ+QqurzoK7q1fdOaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907511; c=relaxed/simple;
	bh=TR9yQtwSU0fNBtZhLMypW8lcpVEToCRPlZjwFMKCme8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4mWa2Bajsj7NsgRne6PH4MgsIfZCuNkD9BgwpjNdkYbpYOARPGUbE0RFhvXKKxEnc9yGXdvZtMcNUocmTktyxhAEwDSOshsNkgknvGboSq0gbUk+5uvccEnMCH8CVzc3SGgERE8c1osJortZgyU2wnq762xJRCnV0e2ESdPQGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ot6yAQ2L; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ruARtnzUoqf2ynm93EQpuqLCqjbRj8vgr2/HwdTeTMs=; b=Ot6yAQ2LKIUuJlcmKHsRXxSs3T
	si3co8+eeHmhh57MLE0D3InXeo/xpSkg5T4K6uPMORUZXgBpLuNEwKQ/sbE55cO/GW5n0F+HM4WEm
	XzbgYVHXsrkqCV9OBFdlrCDzt6fq9dTPYtjZXqabdlqZVwlfVJKPKKzvbceS6AdoNAe/wq/w4oCT7
	vIKAvqrupM9H98iAxhUOsVOIn3AKp4oMIyNRMeQxeTO1+PU+1xH6XP98IoUkcJ5DC/T6bYzmfkfAe
	HcpO/S/eJ7c/1Y1MQgbxs19FF47jfSnSc02oXzv/bfb+p2as20Y6/1dfzQvRa+Bk1NFMhv6bhAXyo
	+B3iDPVA==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIY9-0000000EJVb-3jea;
	Wed, 11 Dec 2024 08:58:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 39/43] xfs: support zone gaps
Date: Wed, 11 Dec 2024 09:55:04 +0100
Message-ID: <20241211085636.1380516-40-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Zoned devices can have gaps beyond the usable capacity of a zone and the
end in the LBA/daddr address space.  In other words, the hardware
equivalent to the RT groups already takes care of the power of 2
alignment for us.  In this case the sparse FSB/RTB address space maps 1:1
to the device address space.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h  |  4 +++-
 fs/xfs/libxfs/xfs_group.h   |  6 +++++-
 fs/xfs/libxfs/xfs_rtgroup.h | 13 ++++++++-----
 fs/xfs/libxfs/xfs_sb.c      |  3 +++
 fs/xfs/libxfs/xfs_zones.c   | 19 +++++++++++++++++--
 fs/xfs/xfs_mount.h          |  9 +++++++++
 6 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index fc56de8fe696..9491a09f6aa7 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -398,6 +398,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_PARENT	(1 << 7)  /* parent pointers */
 #define XFS_SB_FEAT_INCOMPAT_METADIR	(1 << 8)  /* metadata dir tree */
 #define XFS_SB_FEAT_INCOMPAT_ZONED	(1U << 31)/* zoned RT allocator */
+#define XFS_SB_FEAT_INCOMPAT_ZONE_GAPS	(1U << 30)/* RTGs have LBA gaps */
 
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
@@ -409,7 +410,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
 		 XFS_SB_FEAT_INCOMPAT_PARENT | \
 		 XFS_SB_FEAT_INCOMPAT_METADIR | \
-		 XFS_SB_FEAT_INCOMPAT_ZONED)
+		 XFS_SB_FEAT_INCOMPAT_ZONED | \
+		 XFS_SB_FEAT_INCOMPAT_ZONE_GAPS)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 430a43e1591e..996b29313bc2 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -117,7 +117,11 @@ xfs_gbno_to_daddr(
 	struct xfs_groups	*g = &mp->m_groups[xg->xg_type];
 	xfs_fsblock_t		fsbno;
 
-	fsbno = (xfs_fsblock_t)xg->xg_gno * g->blocks + gbno;
+	if (g->has_daddr_gaps)
+		fsbno = xfs_gbno_to_fsb(xg, gbno);
+	else
+		fsbno = (xfs_fsblock_t)xg->xg_gno * g->blocks + gbno;
+
 	return XFS_FSB_TO_BB(mp, g->start_fsb + fsbno);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 85d8d329d417..5b3305e09ec3 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -245,11 +245,14 @@ xfs_rtb_to_daddr(
 	xfs_rtblock_t		rtbno)
 {
 	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
-	xfs_rgnumber_t		rgno = xfs_rtb_to_rgno(mp, rtbno);
-	uint64_t		start_bno = (xfs_rtblock_t)rgno * g->blocks;
 
-	return XFS_FSB_TO_BB(mp,
-		g->start_fsb + start_bno + (rtbno & g->blkmask));
+	if (xfs_has_rtgroups(mp) && !g->has_daddr_gaps) {
+		xfs_rgnumber_t	rgno = xfs_rtb_to_rgno(mp, rtbno);
+
+		rtbno = (xfs_rtblock_t)rgno * g->blocks + (rtbno & g->blkmask);
+	}
+
+	return XFS_FSB_TO_BB(mp, g->start_fsb + rtbno);
 }
 
 static inline xfs_rtblock_t
@@ -261,7 +264,7 @@ xfs_daddr_to_rtb(
 	xfs_rfsblock_t		bno;
 
 	bno = XFS_BB_TO_FSBT(mp, daddr) - g->start_fsb;
-	if (xfs_has_rtgroups(mp)) {
+	if (xfs_has_rtgroups(mp) && !g->has_daddr_gaps) {
 		xfs_rgnumber_t	rgno;
 		uint32_t	rgbno;
 
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index ee56fc22fd06..18e4c4908f94 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1176,6 +1176,9 @@ xfs_sb_mount_rextsize(
 		rgs->blklog = mp->m_sb.sb_rgblklog;
 		rgs->blkmask = xfs_mask32lo(mp->m_sb.sb_rgblklog);
 		rgs->start_fsb = mp->m_sb.sb_rtstart;
+		if (xfs_sb_has_incompat_feature(sbp,
+				XFS_SB_FEAT_INCOMPAT_ZONE_GAPS))
+			rgs->has_daddr_gaps = true;
 	} else {
 		rgs->blocks = 0;
 		rgs->blklog = 0;
diff --git a/fs/xfs/libxfs/xfs_zones.c b/fs/xfs/libxfs/xfs_zones.c
index e170d7c13533..c17111f40821 100644
--- a/fs/xfs/libxfs/xfs_zones.c
+++ b/fs/xfs/libxfs/xfs_zones.c
@@ -135,6 +135,7 @@ xfs_zone_validate(
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
+	uint32_t		expected_size;
 
 	/*
 	 * Check that the zone capacity matches the rtgroup size stored in the
@@ -149,11 +150,25 @@ xfs_zone_validate(
 		return -EIO;
 	}
 
-	if (XFS_BB_TO_FSB(mp, zone->len) != 1 << g->blklog) {
+	if (g->has_daddr_gaps) {
+		expected_size = 1 << g->blklog;
+	} else {
+		if (zone->len != zone->capacity) {
+			xfs_warn(mp,
+"zone %u has capacity != size ((0x%llx vs 0x%llx)",
+				rtg_rgno(rtg),
+				XFS_BB_TO_FSB(mp, zone->len),
+				XFS_BB_TO_FSB(mp, zone->capacity));
+			return -EIO;
+		}
+		expected_size = g->blocks;
+	}
+
+	if (XFS_BB_TO_FSB(mp, zone->len) != expected_size) {
 		xfs_warn(mp,
 "zone %u length (0x%llx) does match geometry (0x%x).",
 			rtg_rgno(rtg), XFS_BB_TO_FSB(mp, zone->len),
-			1 << g->blklog);
+			expected_size);
 	}
 
 	switch (zone->type) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 831d9e09fe72..ec8612c8b71d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -97,6 +97,15 @@ struct xfs_groups {
 	 */
 	uint8_t			blklog;
 
+	/*
+	 * Zoned devices can have gaps beyond the usable capacity of a zone and
+	 * the end in the LBA/daddr address space.  In other words, the hardware
+	 * equivalent to the RT groups already takes care of the power of 2
+	 * alignment for us.  In this case the sparse FSB/RTB address space maps
+	 * 1:1 to the device address space.
+	 */
+	bool			has_daddr_gaps;
+
 	/*
 	 * Mask to extract the group-relative block number from a FSB.
 	 * For a pre-rtgroups filesystem we pretend to have one very large
-- 
2.45.2


