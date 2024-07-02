Return-Path: <linux-xfs+bounces-10109-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ECD091EC7B
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 03:15:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F9C1281DD6
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 01:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D924C8B;
	Tue,  2 Jul 2024 01:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gw6OLYOZ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF1B20E3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882908; cv=none; b=Ie2zNsN/7kkYwSO8XxF0Wpvx7991bp6Gxr5IXs8B7Ionq6G8FWW3G8VXhGihv6OCuseJ/QpXRywTUoYLYNAdDmtAl70S7ytBe+AhQQgd+00n5J+tgywMVgMNDK6w17WGvAGbiDdat2/gFUNA/saw35feSugtvH5x2Qb26BjaivQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882908; c=relaxed/simple;
	bh=oGsR+F1e4i6D5NWCpoqH6xTf5h+0qqETh/n0NSmbYUc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SMF1ePddpobPL5XlIUaonr1oP+VBs9iSLXNVJ45FEnjbwcuReJoYKeThcUQEBtxZlivsj5PW9NpJHKXsvCXOPz5EVoc52OmQ+Hne4/wgkDWKR6I9MAkJKJ7/dglSouFKP0vdqYy3DVUEgfoOyl5t8I2CPBejBakw4RqVb7CWAsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gw6OLYOZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28E7C2BD10;
	Tue,  2 Jul 2024 01:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882907;
	bh=oGsR+F1e4i6D5NWCpoqH6xTf5h+0qqETh/n0NSmbYUc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gw6OLYOZ+Tr4BmO2tgs0Zw8u+8ctQhk7d8r5LT3Gk/wtcEsAAI/j48lAxv0CRhx2Y
	 cngm7YOWq2PCIiaBaoJDtOGx9sbYTZzISOc2laEX2OKHk5lU0dqK3Zh85/XFdhYFUY
	 XQ0OAHB0BJn6JvVInmcjHPfG4DYTjW8SgpgHHslz8e14cCXbVi+navaWtPlQHhiovB
	 2GQg+KdbrWniAH0717i6kEvG/xXz5LbTEAy6BiMguyeXFjghY2DocIZMK3aGVVXrzk
	 QASL8j7Pva/qWOFeMeuUiGsBEy8j802axW5S11V4ZmNRUay3u9rAmnJw/mStgvuveb
	 hEggsJkelyHwQ==
Date: Mon, 01 Jul 2024 18:15:07 -0700
Subject: [PATCH 17/24] libxfs: export attr3_leaf_hdr_from_disk via
 libxfs_api_defs.h
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121326.2009260.10614225579834518986.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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

Do the xfs -> libxfs switcheroo and cleanups separately so the next
patch doesn't become an even larger mess.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/attr.c                |    2 +-
 db/metadump.c            |    2 +-
 libxfs/libxfs_api_defs.h |    5 +++++
 repair/attr_repair.c     |    6 +++---
 4 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/db/attr.c b/db/attr.c
index 3b556c43def5..0b1f498e457c 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -248,7 +248,7 @@ attr_leaf_entry_walk(
 		return 0;
 
 	off = byteize(startoff);
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
 
 	for (i = 0; i < leafhdr.count; i++) {
diff --git a/db/metadump.c b/db/metadump.c
index e95238fb0471..424544f9f032 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1680,7 +1680,7 @@ process_attr_block(
 	}
 
 	/* Ok, it's a leaf - get header; accounts for crc & non-crc */
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &hdr, leaf);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &hdr, leaf);
 
 	nentries = hdr.count;
 	if (nentries == 0 ||
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index c3dde15116c4..5713e5221fe6 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -36,10 +36,13 @@
 
 #define xfs_ascii_ci_hashname		libxfs_ascii_ci_hashname
 
+#define xfs_attr3_leaf_hdr_from_disk	libxfs_attr3_leaf_hdr_from_disk
+#define xfs_attr3_leaf_read		libxfs_attr3_leaf_read
 #define xfs_attr_check_namespace	libxfs_attr_check_namespace
 #define xfs_attr_get			libxfs_attr_get
 #define xfs_attr_hashname		libxfs_attr_hashname
 #define xfs_attr_hashval		libxfs_attr_hashval
+#define xfs_attr_is_leaf		libxfs_attr_is_leaf
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
 #define xfs_attr_set			libxfs_attr_set
@@ -103,6 +106,7 @@
 #define xfs_compute_rextslog		libxfs_compute_rextslog
 #define xfs_create_space_res		libxfs_create_space_res
 #define xfs_da3_node_hdr_from_disk	libxfs_da3_node_hdr_from_disk
+#define xfs_da3_node_read		libxfs_da3_node_read
 #define xfs_da_get_buf			libxfs_da_get_buf
 #define xfs_da_hashname			libxfs_da_hashname
 #define xfs_da_read_buf			libxfs_da_read_buf
@@ -177,6 +181,7 @@
 #define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
 #define xfs_inode_from_disk		libxfs_inode_from_disk
 #define xfs_inode_from_disk_ts		libxfs_inode_from_disk_ts
+#define xfs_inode_hasattr		libxfs_inode_hasattr
 #define xfs_inode_to_disk		libxfs_inode_to_disk
 #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
 #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 8321c9b679b2..2e97fd9775ba 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -610,7 +610,7 @@ process_leaf_attr_block(
 	da_freemap_t *attr_freemap;
 	struct xfs_attr3_icleaf_hdr leafhdr;
 
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	clearit = usedbs = 0;
 	firstb = mp->m_sb.sb_blocksize;
 	stop = xfs_attr3_leaf_hdr_size(leaf);
@@ -849,7 +849,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 		}
 
 		leaf = bp->b_addr;
-		xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+		libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 
 		/* check magic number for leaf directory btree block */
 		if (!(leafhdr.magic == XFS_ATTR_LEAF_MAGIC ||
@@ -1052,7 +1052,7 @@ process_longform_leaf_root(
 	 * check sibling pointers in leaf block or root block 0 before
 	 * we have to release the btree block
 	 */
-	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, bp->b_addr);
+	libxfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, bp->b_addr);
 	if (leafhdr.forw != 0 || leafhdr.back != 0)  {
 		if (!no_modify)  {
 			do_warn(


