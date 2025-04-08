Return-Path: <linux-xfs+bounces-21216-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E898A7F539
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Apr 2025 08:48:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 829BE17A137
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Apr 2025 06:48:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 495CD26136F;
	Tue,  8 Apr 2025 06:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UuJ3tJNK"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8755A25FA29
	for <linux-xfs@vger.kernel.org>; Tue,  8 Apr 2025 06:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744094854; cv=none; b=Iu4/SP/+FDgn0tR9LUn+TK44PBGDk7dnS0FKz+KrZyAgp+vThuWEOUcTmvlbrWM7EO1/ixrqljtY4q7acvHkEwbGKd1vVfUgh7Nhs5OuMK1+YncG38xTrf61EPCEqIGy/uvy+AD/8cg5xYTFhFG1us6dog2i5U2NF9UenDLfeo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744094854; c=relaxed/simple;
	bh=qbc+46aPjmwMuUASUAXP7hxqeQqMJe9TxPBEnDstwv8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Cr2DvVbnLjUGmFFOspHnzIq3xcHy/++cl9xGCIFPCl3xJEeGqch6EqANWSzrHAgEgxoxD+NGjAiRBtnN7JzJuLTp1GPz3Ztv6e7GtoFrF/jBK6cvUGDckreTD1eoUe+G/0P+KjHY9hGaz0BQlkBt4uD4jJOkLNAeaW7FNRPJ//M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UuJ3tJNK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=YhWJBNpbANVlOf45WKehXN8wmnTrRBEuQUpPyypB1NU=; b=UuJ3tJNK8+XNTnNMmnwvSeUSro
	zN2JfbE6SH5aSfF9Q8tZmRZC4ZHtH3WDZEsARFkmrvzKVtKL0AJObqJTtzu1t+HGc68J89vz1bNsI
	J3G66sPOz8wosRGG7oQ4xPm7vtBiO87O7R3B4odvOYDgxftJSf/2va58ae/hRAHfpusV6wo/i6Dkd
	XQI+0JJXwNEKIYxwuci6rd98IcV5yxnCm162pKakka7lQy/29fP/pzjqiezpb5oxkJiLqBU+WsOdZ
	0AjByyEiHvlhpiaCV1ZguaXd0zBM9Jba0f2WEtetiJ+mqo8le9mAnq3bPtMzspKaoiv5pLcMB63y1
	+gRtIFww==;
Received: from 2a02-8389-2341-5b80-f320-f588-da2a-f4ef.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f320:f588:da2a:f4ef] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u22k7-00000002x5C-2T1k;
	Tue, 08 Apr 2025 06:47:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] design: document the zoned on-disk format
Date: Tue,  8 Apr 2025 08:47:15 +0200
Message-ID: <20250408064727.3211186-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Document the feature flags, superblock fields and new dinode union.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---

Changes since v1:
 - un-but a sentence

 .../ondisk_inode.asciidoc                     | 13 ++++++-
 .../realtime.asciidoc                         | 34 +++++++++++++++++++
 .../superblock.asciidoc                       | 25 ++++++++++++++
 3 files changed, 71 insertions(+), 1 deletion(-)

diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index ab4a503b4da6..ba111ebe6e3a 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -139,7 +139,10 @@ struct xfs_dinode_core {
      __be64                    di_changecount;
      __be64                    di_lsn;
      __be64                    di_flags2;
-     __be32                    di_cowextsize;
+     union {
+             __be32            di_cowextsize;
+             __be32            di_used_blocks;
+     };
      __u8                      di_pad2[12];
      xfs_timestamp_t           di_crtime;
      __be64                    di_ino;
@@ -425,6 +428,14 @@ the source file to the destination file if the sharing operation completely
 overwrites the destination file's contents and the destination file does not
 already have +di_cowextsize+ set.
 
+*di_used_blocks*::
+
+Used only for the xref:Real_time_Reverse_Mapping_Btree[Reverse-Mapping B+tree]
+inode on filesystems with a xref:Zoned[Zoned Real-time Device].  Tracks the
+number of filesystem blocks in the rtgroup that have been written but not
+unmapped, i.e. the number of blocks that are referenced by at least one rmap
+entry.
+
 *di_pad2*::
 Padding for future expansion of the inode.
 
diff --git a/design/XFS_Filesystem_Structure/realtime.asciidoc b/design/XFS_Filesystem_Structure/realtime.asciidoc
index 16641525e201..c826f4b6ced0 100644
--- a/design/XFS_Filesystem_Structure/realtime.asciidoc
+++ b/design/XFS_Filesystem_Structure/realtime.asciidoc
@@ -397,3 +397,37 @@ meta_uuid = 7e55b909-8728-4d69-a1fa-891427314eea
 include::rtrmapbt.asciidoc[]
 
 include::rtrefcountbt.asciidoc[]
+
+[[Zoned]]
+== Zoned Real-time Devices
+
+If the +XFS_SB_FEAT_INCOMPAT_ZONED+ feature is enabled, the real time device
+uses an entirely different space allocator.  This features does not use the
+xref:Real-Time_Bitmap_Inode[Free Space Bitmap Inode] and
+xref:Real-Time_Summary_Inode[Free Space Summary Inode].
+Instead, writes to the storage hardware must always occur sequentially
+from the start to the end of a rtgroup.  To support this requirement,
+file data are always written out of place using the so called copy on write
+or COW write path (which actually just redirects on write and never copies).
+
+When an rtgroup runs out of space to write, free space is reclaimed by
+copying and remapping still valid data from the full rtgroups into
+another rtgroup.  Once the rtgroup is empty, it is written to from the
+beginning again.  For this, the
+xref:Real_time_Reverse_Mapping_Btree[Reverse-Mapping B+tree] is required.
+
+For storage hardware that supports hardware zones, each rtgroup is mapped
+to exactly one zone.  When a file system is created on a a zoned storage
+device that does support conventional (aka random writable) zones at the
+beginning of the LBA space, those zones are used for the xfs data device
+(which in this case is primarily used for metadata), and the zoned requiring
+sequential writes are presented as the real-time device.  When an external
+real-time device is used, rtgroups might also map to conventional zones.
+
+Filesystems with a zoned real-time device by default use the real-time device
+for all data, and the data device only for metadata, which makes the
+terminology a bit confusing.  But this is merely the default setting.  Like
+any other filesystem with a realtime volume, the +XFS_DIFLAG_REALTIME+ flag
+can be cleared on an empty regular file to target the data device; and the
++XFS_DIFLAG_RTINHERIT+ flag can be cleared on a directory so that new
+children will target the data device."
diff --git a/design/XFS_Filesystem_Structure/superblock.asciidoc b/design/XFS_Filesystem_Structure/superblock.asciidoc
index f04553046357..bd34eb0d3066 100644
--- a/design/XFS_Filesystem_Structure/superblock.asciidoc
+++ b/design/XFS_Filesystem_Structure/superblock.asciidoc
@@ -74,6 +74,8 @@ struct xfs_dsb {
 	__be32		sb_rgextents;
 	__u8		sb_rgblklog;
 	__u8		sb_pad[7];
+	__be64		sb_rtstart;
+	__be64		sb_rtreserved;
 
 	/* must be padded to 64 bit alignment */
 };
@@ -449,6 +451,16 @@ pointers] for more information.
 Metadata directory tree.  See the section about the xref:Metadata_Directories[
 metadata directory tree] for more information.
 
+| +XFS_SB_FEAT_INCOMPAT_ZONED+ |
+Zoned RT device.  See the section about the xref:Zoned[Zoned Real-time Devices]
+for more information.
+
+| +XFS_SB_FEAT_INCOMPAT_ZONE_GAPS+ |
+Each hardware zone has unusable space at the end of its LBA range, which is
+mirrored by unusable filesystem blocks at the end of the rtgroup.  The
++xfs_rtblock_t startblock+ in file mappings is linearly mapped to the
+hardware LBA space.
+
 |=====
 
 *sb_features_log_incompat*::
@@ -505,6 +517,19 @@ generate absolute block numbers defined in extent maps from the segmented
 *sb_pad[7]*::
 Zeroes, if the +XFS_SB_FEAT_RO_INCOMPAT_METADIR+ feature is enabled.
 
+*sb_rtstart*::
+
+If the +XFS_SB_FEAT_INCOMPAT_ZONED+ feature is enabled, this is the start
+of the internal RT section.  That is the RT section is placed on the same
+device as the data device, and starts at this offset into the device.
+The value is in units of file system blocks.
+
+*sb_rtreserved*::
+
+If the +XFS_SB_FEAT_INCOMPAT_ZONED+ feature is enabled, this is the amount
+of space in the realtime section that is reserved for internal use
+by garbage collection and reorganization algorithms.
+
 === xfs_db Superblock Example
 
 A filesystem is made on a single disk with the following command:
-- 
2.47.2


