Return-Path: <linux-xfs+bounces-19067-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D02B7A2A18B
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Feb 2025 07:50:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52C433AA196
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Feb 2025 06:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F68225799;
	Thu,  6 Feb 2025 06:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2rSEwQ3d"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA4922578B
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824409; cv=none; b=MJoysLFY0yV0eUVgtDxh9S70HOJ4YEKnBh1f7HeqBtT4xd24bl57EXa9E21u/SyUtF0WbIrXnLgPIeuFM+64nRVOVJ7c+zZjLC9wsRCW9YLm2Vol48NDhWlCwkuFAT7G28qZp8xPNYuVaoi/SNNG2I2NTW5tuf10Mmd0QRn056M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824409; c=relaxed/simple;
	bh=ZkEpX5h8++d2gBq3NM+5H84lun7YWMR8vrH33zZpa8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiK7YW2Gq+QAZIpmYCMZo6OPDV5/+Tdh5pb5QuWkybYlMYF5tVnVrpkqoFF8iXyHf7yCAiduC1Nh6xLGLOXc8qw6jSrheeu4PQpfbPN/+aYWfO3nhb7U235riK1KgUuz5qPI6ixZN/U+Dd7WZDukvwtEqzOEmVVc15u2qD5ZNts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2rSEwQ3d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KShRVf/arT9RONGG3g/D1/+kucxBWF6BTO/mEA7sJpc=; b=2rSEwQ3dIHodfsjzYN2B5K5OWd
	WRBnwff/3wx/D1JJtnPX5c6VVi8QXX1Fvql7VquIXUC+EKDsrlX5NMS7jzFDh4QIuewf6hBP6rt28
	UqedkfYnIwbmwkaK9UYTLVShYvPd8Nn8KHfe7VgwaaRPfQzeSEMkUwlrG0I/PdfiKKCdXR1tGLg6E
	AXRyBzZcb4dY+PbcBhOZscJxm1uYU4yRaHVFtlT6DZVM6Uq3ItX2iJwJtMdmLp74hXJ9BNbL5E13B
	/x8h9tqx2fxnR7EneoQWvenyN5uU0QOjciC2fwZrzLGgzIsC6SybtXbGQ2XAo+JKAMYO7260zIy8w
	4VEab9IQ==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvex-00000005Qli-1dtS;
	Thu, 06 Feb 2025 06:46:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 33/43] xfs: enable fsmap reporting for internal RT devices
Date: Thu,  6 Feb 2025 07:44:49 +0100
Message-ID: <20250206064511.2323878-34-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

File system with internal RT devices are a bit odd in that we need
to report AGs and RGs.  To make this happen use separate synthetic
fmr_device values for the different sections instead of the dev_t
mapping used by other XFS configurations.

The data device is reported as file system metadata before the
start of the RGs for the synthetic RT fmr_device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h |  9 +++++
 fs/xfs/xfs_fsmap.c     | 80 +++++++++++++++++++++++++++++++++---------
 2 files changed, 72 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 5e66fb2b2cc7..12463ba766da 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -1082,6 +1082,15 @@ struct xfs_rtgroup_geometry {
 #define XFS_IOC_COMMIT_RANGE	     _IOW ('X', 131, struct xfs_commit_range)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
+/*
+ * Devices supported by a single XFS file system.  Reported in fsmaps fmr_device
+ * when using internal RT devices.
+ */
+enum xfs_device {
+	XFS_DEV_DATA	= 1,
+	XFS_DEV_LOG	= 2,
+	XFS_DEV_RT	= 3,
+};
 
 #ifndef HAVE_BBMACROS
 /*
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 917d4d0e51b3..a4bc1642fe56 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -879,17 +879,39 @@ xfs_getfsmap_rtdev_rmapbt(
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_rtgroup		*rtg = NULL;
 	struct xfs_btree_cur		*bt_cur = NULL;
+	xfs_daddr_t			rtstart_daddr;
 	xfs_rtblock_t			start_rtb;
 	xfs_rtblock_t			end_rtb;
 	xfs_rgnumber_t			start_rg, end_rg;
 	uint64_t			eofs;
 	int				error = 0;
 
-	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart + mp->m_sb.sb_rblocks);
 	if (keys[0].fmr_physical >= eofs)
 		return 0;
-	start_rtb = xfs_daddr_to_rtb(mp, keys[0].fmr_physical);
-	end_rtb = xfs_daddr_to_rtb(mp, min(eofs - 1, keys[1].fmr_physical));
+
+	rtstart_daddr = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
+	if (keys[0].fmr_physical < rtstart_daddr) {
+		struct xfs_fsmap_irec		frec = {
+			.owner			= XFS_RMAP_OWN_FS,
+			.len_daddr		= rtstart_daddr,
+		};
+
+		/* Adjust the low key if we are continuing from where we left off. */
+		if (keys[0].fmr_length > 0) {
+			info->low_daddr = keys[0].fmr_physical + keys[0].fmr_length;
+			return 0;
+		}
+
+		/* Fabricate an rmap entry for space occupied by the data dev */
+		error = xfs_getfsmap_helper(tp, info, &frec);
+		if (error)
+			return error;
+	}
+
+	start_rtb = xfs_daddr_to_rtb(mp, rtstart_daddr + keys[0].fmr_physical);
+	end_rtb = xfs_daddr_to_rtb(mp, rtstart_daddr +
+			min(eofs - 1, keys[1].fmr_physical));
 
 	info->missing_owner = XFS_FMR_OWN_FREE;
 
@@ -1004,22 +1026,40 @@ xfs_getfsmap_rtdev_rmapbt(
 }
 #endif /* CONFIG_XFS_RT */
 
+static uint32_t
+xfs_getfsmap_device(
+	struct xfs_mount	*mp,
+	enum xfs_device		dev)
+{
+	if (mp->m_sb.sb_rtstart)
+		return dev;
+
+	switch (dev) {
+	case XFS_DEV_DATA:
+		return new_encode_dev(mp->m_ddev_targp->bt_dev);
+	case XFS_DEV_LOG:
+		return new_encode_dev(mp->m_logdev_targp->bt_dev);
+	case XFS_DEV_RT:
+		if (!mp->m_rtdev_targp)
+			break;
+		return new_encode_dev(mp->m_rtdev_targp->bt_dev);
+	}
+
+	return -1;
+}
+
 /* Do we recognize the device? */
 STATIC bool
 xfs_getfsmap_is_valid_device(
 	struct xfs_mount	*mp,
 	struct xfs_fsmap	*fm)
 {
-	if (fm->fmr_device == 0 || fm->fmr_device == UINT_MAX ||
-	    fm->fmr_device == new_encode_dev(mp->m_ddev_targp->bt_dev))
-		return true;
-	if (mp->m_logdev_targp &&
-	    fm->fmr_device == new_encode_dev(mp->m_logdev_targp->bt_dev))
-		return true;
-	if (mp->m_rtdev_targp &&
-	    fm->fmr_device == new_encode_dev(mp->m_rtdev_targp->bt_dev))
-		return true;
-	return false;
+	return fm->fmr_device == 0 ||
+		fm->fmr_device == UINT_MAX ||
+		fm->fmr_device == xfs_getfsmap_device(mp, XFS_DEV_DATA) ||
+		fm->fmr_device == xfs_getfsmap_device(mp, XFS_DEV_LOG) ||
+		(mp->m_rtdev_targp &&
+		 fm->fmr_device == xfs_getfsmap_device(mp, XFS_DEV_RT));
 }
 
 /* Ensure that the low key is less than the high key. */
@@ -1126,7 +1166,7 @@ xfs_getfsmap(
 	/* Set up our device handlers. */
 	memset(handlers, 0, sizeof(handlers));
 	handlers[0].nr_sectors = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
-	handlers[0].dev = new_encode_dev(mp->m_ddev_targp->bt_dev);
+	handlers[0].dev = xfs_getfsmap_device(mp, XFS_DEV_DATA);
 	if (use_rmap)
 		handlers[0].fn = xfs_getfsmap_datadev_rmapbt;
 	else
@@ -1134,7 +1174,7 @@ xfs_getfsmap(
 	if (mp->m_logdev_targp != mp->m_ddev_targp) {
 		handlers[1].nr_sectors = XFS_FSB_TO_BB(mp,
 						       mp->m_sb.sb_logblocks);
-		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
+		handlers[1].dev = xfs_getfsmap_device(mp, XFS_DEV_LOG);
 		handlers[1].fn = xfs_getfsmap_logdev;
 	}
 #ifdef CONFIG_XFS_RT
@@ -1144,7 +1184,7 @@ xfs_getfsmap(
 	 */
 	if (mp->m_rtdev_targp && (use_rmap || !xfs_has_zoned(mp))) {
 		handlers[2].nr_sectors = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
-		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
+		handlers[2].dev = xfs_getfsmap_device(mp, XFS_DEV_RT);
 		if (use_rmap)
 			handlers[2].fn = xfs_getfsmap_rtdev_rmapbt;
 		else
@@ -1234,7 +1274,13 @@ xfs_getfsmap(
 
 	if (tp)
 		xfs_trans_cancel(tp);
-	head->fmh_oflags = FMH_OF_DEV_T;
+
+	/*
+	 * For internal RT device we need to report different synthetic devices
+	 * for a single physical device, and thus can't report the actual dev_t.
+	 */
+	if (!mp->m_sb.sb_rtstart)
+		head->fmh_oflags = FMH_OF_DEV_T;
 	return error;
 }
 
-- 
2.45.2


