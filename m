Return-Path: <linux-xfs+bounces-19688-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1D67A394B5
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Feb 2025 09:13:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D7443B3272
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Feb 2025 08:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F43522B58E;
	Tue, 18 Feb 2025 08:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qd+GzEpl"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866A822AE74
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866365; cv=none; b=KQZbSzhXb2JieFuhb/+v7zdBY01KK8HsSN/Z9pkk+A4QaS4g37XCmzeyKJDH5biWLmTNBe00xFGQkYzAqs70W7wJneK1+txmGlotd2SH+q2kw/+zLOBg1XUh3MDBOo+KL7NkeR2TCLOcw3pbjVXlD3Vz0mNpbXrFPMsdGjtC5F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866365; c=relaxed/simple;
	bh=cXn7SYDo/HQljYWDDFF8fdX6i6ps3tzeGoHP3yN8SHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCgJGCccacvAxJus4vYc+fNKWZ2VwuJ0bcc85lLrrBp7p/kTh8sMN4HHcCIGrprc8GjL+MjTye9zEWgfHQJoqA8a4IK53Rl+16zQeLRIbjjgzq9CheJd6CdZiUl3x4IjvqoUU4B4M5QpURTM1nIpbaKAGfY1LePBEdePO17U5mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qd+GzEpl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3JsT7pk/rvuv3lHfBltf7qyMRYAiPVGrk+72Iht/Wp8=; b=Qd+GzEplSPMPN3S5Ah4XpON/s8
	YD3G4YAVXgsGV4K32qeNyBN3nhX7wm2X9Bakp4kXASgB3GMvCpF6Xda3J4sLF/0C8VLr2GQmGHHrh
	HdTaWRN4NPgqqJwi9LCQeh/rHVZyU5ouWmFPGwAj8jyNKaebgORc5iMiVRJYSdQBcZUfRxnPN5zHt
	ORi9h++T8R42hyuc6mHmBMfKZ9U7yfrf0nvPE5Eio1JWTibf5qliwkJMvG2Vbbj7Ske35XAQ/rzLi
	/9BCc4L5WNyAZwQMOO/3NPNzrnSaoWeNDdOgauDDM3chOdja2Mb4FZ0ozFSC9R2+7A8N4sMBkNz9j
	8fjKNseg==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIih-00000007CVm-3Qt7;
	Tue, 18 Feb 2025 08:12:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 18/45] xfs: export zoned geometry via XFS_FSOP_GEOM
Date: Tue, 18 Feb 2025 09:10:21 +0100
Message-ID: <20250218081153.3889537-19-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Export the zoned geometry information so that userspace can query it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h | 5 ++++-
 fs/xfs/libxfs/xfs_sb.c | 6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2c3171262b44..5e66fb2b2cc7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -189,7 +189,9 @@ struct xfs_fsop_geom {
 	uint32_t	checked;	/* o: checked fs & rt metadata	*/
 	__u32		rgextents;	/* rt extents in a realtime group */
 	__u32		rgcount;	/* number of realtime groups	*/
-	__u64		reserved[16];	/* reserved space		*/
+	__u64		rtstart;	/* start of internal rt section */
+	__u64		rtreserved;	/* RT (zoned) reserved blocks	*/
+	__u64		reserved[14];	/* reserved space		*/
 };
 
 #define XFS_FSOP_GEOM_SICK_COUNTERS	(1 << 0)  /* summary counters */
@@ -247,6 +249,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE (1 << 24) /* exchange range */
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 #define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
+#define XFS_FSOP_GEOM_FLAGS_ZONED	(1 << 27) /* zoned rt device */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 52a04aae44e8..3b886886ea69 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1569,6 +1569,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
 	if (xfs_has_metadir(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
+	if (xfs_has_zoned(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_ZONED;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
@@ -1589,6 +1591,10 @@ xfs_fs_geometry(
 		geo->rgcount = sbp->sb_rgcount;
 		geo->rgextents = sbp->sb_rgextents;
 	}
+	if (xfs_has_zoned(mp)) {
+		geo->rtstart = sbp->sb_rtstart;
+		geo->rtreserved = sbp->sb_rtreserved;
+	}
 }
 
 /* Read a secondary superblock. */
-- 
2.45.2


