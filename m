Return-Path: <linux-xfs+bounces-7326-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 513828AD22A
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Apr 2024 18:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07EC12844DB
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Apr 2024 16:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02390153BDC;
	Mon, 22 Apr 2024 16:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDZxLAUa"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E1C153BCE
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803984; cv=none; b=kl+jTMTrG8s70Px7aZ5Sd4OHAAv8IsMMxDduM6FWzQEUiI7fhaB6bB76yheFx+VtcaHY7v95zDW2v3wW7SGOhn8l69GbmMiPBXLoTjCuW5hHNZDlUZslnBdRUONaaW1sQ6zbjcAlkZMQAs7X0WXUletXijCnWDqvW2l/WEc4XjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803984; c=relaxed/simple;
	bh=hulg6lXaxvq6FFNGxeH+aBjzckylcnCF+SwSTPt8GAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYkSGpsWGm8shHmUeJN/SDeGcQcc2X6LPREFJ3guTFOqUZ5cZu3d0v8HHcGTnEsfRNFZa18Y8oIw48Q4Yzr8b0K7Mr97aHComWJKXnPoUeA50nQMrT9F4Tdt5oRahvB//VTcDUOx9ydbyhQRNKTmelBKE2hT9P/jWlqGEB/MQwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDZxLAUa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850C6C113CC;
	Mon, 22 Apr 2024 16:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803984;
	bh=hulg6lXaxvq6FFNGxeH+aBjzckylcnCF+SwSTPt8GAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XDZxLAUaIsMcVJx0Gq+DiR5OfPCRPTNYEug/tOmjXzrgX6tfm3OCHOHmUD2R67xNb
	 eiEveTVgZfF/DEK5J4DiCN4oqZ/4ptXu4KWPd79LGKK/d2Go2xrSTvYhNp//mCridQ
	 W3pvYZtvFFnOt7OQIpoEzQ4m5z+mxJooH4AmOlqVjlv0MyUcEWXXSww2EJozkwn4CQ
	 hG01IkZMxqBHcwe4Dw24nC8q+2wWnwgHWMj+aoQRMaEa44cNKsq4K7DDDqQEOgtpXq
	 rfNcwK4tYoHrKU1LXngXP6oHW/8lH/oEsNfcUL4eZCePvlbGYnwZwcPcySj4WBtirs
	 0EpN453Hid/SA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 24/67] xfs: move xfs_ondisk.h to libxfs/
Date: Mon, 22 Apr 2024 18:25:46 +0200
Message-ID: <20240422163832.858420-26-cem@kernel.org>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 18793e050504288345eb455a471677b57117bcc6

Move xfs_ondisk.h to libxfs so that we can do the struct sanity checks
in userspace libxfs as well.  This should allow us to retire the
somewhat fragile xfs/122 test on xfstests.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/init.c       |   6 ++
 libxfs/xfs_ondisk.h | 199 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 205 insertions(+)
 create mode 100644 libxfs/xfs_ondisk.h

diff --git a/libxfs/init.c b/libxfs/init.c
index 63c506a69..f7ba4d1b3 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -23,6 +23,11 @@
 #include "xfs_refcount_btree.h"
 #include "libfrog/platform.h"
 
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_ondisk.h"
+
 #include "libxfs.h"		/* for now */
 
 #ifndef HAVE_LIBURCU_ATOMIC64
@@ -248,6 +253,7 @@ libxfs_close_devices(
 int
 libxfs_init(struct libxfs_init *a)
 {
+	xfs_check_ondisk_structs();
 	rcu_init();
 	rcu_register_thread();
 	radix_tree_init();
diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
new file mode 100644
index 000000000..d9c988c5a
--- /dev/null
+++ b/libxfs/xfs_ondisk.h
@@ -0,0 +1,199 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2016 Oracle.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_ONDISK_H
+#define __XFS_ONDISK_H
+
+#define XFS_CHECK_STRUCT_SIZE(structname, size) \
+	static_assert(sizeof(structname) == (size), \
+		"XFS: sizeof(" #structname ") is wrong, expected " #size)
+
+#define XFS_CHECK_OFFSET(structname, member, off) \
+	static_assert(offsetof(structname, member) == (off), \
+		"XFS: offsetof(" #structname ", " #member ") is wrong, " \
+		"expected " #off)
+
+#define XFS_CHECK_VALUE(value, expected) \
+	static_assert((value) == (expected), \
+		"XFS: value of " #value " is wrong, expected " #expected)
+
+static inline void __init
+xfs_check_ondisk_structs(void)
+{
+	/* ag/file structures */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_acl,			4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_acl_entry,		12);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agf,			224);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agfl,			36);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_agi,			344);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_key,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bmbt_rec,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bmdr_block,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_shdr,	48);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block_lhdr,	64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_btree_block,		72);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			264);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_key,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_rec,		12);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
+	XFS_CHECK_STRUCT_SIZE(xfs_timestamp_t,			8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_legacy_timestamp,	8);
+	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
+	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
+	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);
+	XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
+	XFS_CHECK_STRUCT_SIZE(xfs_refcount_ptr_t,		4);
+	XFS_CHECK_STRUCT_SIZE(xfs_rmap_ptr_t,			4);
+
+	/* dir/attr trees */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leaf_hdr,	80);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leafblock,	80);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_rmt_hdr,		56);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_da3_blkinfo,		56);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_da3_intnode,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_da3_node_hdr,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_blk_hdr,		48);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_data_hdr,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free_hdr,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf_hdr,		64);
+	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_entry_t,		8);
+	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_hdr_t,		32);
+	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_map_t,		4);
+	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_local_t,	4);
+
+	/* realtime structures */
+	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_raw,		4);
+	XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_raw,		4);
+
+	/*
+	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to
+	 * 4 bytes anyway so it's not obviously a problem.  Hence for the moment
+	 * we don't check this structure. This can be re-instated when the attr
+	 * definitions are updated to use c99 VLA definitions.
+	 *
+	XFS_CHECK_STRUCT_SIZE(xfs_attr_leaf_name_remote_t,	12);
+	 */
+
+	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, valuelen,	0);
+	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, namelen,	2);
+	XFS_CHECK_OFFSET(xfs_attr_leaf_name_local_t, nameval,	3);
+	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valueblk,	0);
+	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, valuelen,	4);
+	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, namelen,	8);
+	XFS_CHECK_OFFSET(xfs_attr_leaf_name_remote_t, name,	9);
+	XFS_CHECK_STRUCT_SIZE(xfs_attr_leafblock_t,		32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_shortform,	4);
+	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.totsize, 0);
+	XFS_CHECK_OFFSET(struct xfs_attr_shortform, hdr.count,	 2);
+	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].namelen,	4);
+	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].valuelen,	5);
+	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].flags,	6);
+	XFS_CHECK_OFFSET(struct xfs_attr_shortform, list[0].nameval,	7);
+	XFS_CHECK_STRUCT_SIZE(xfs_da_blkinfo_t,			12);
+	XFS_CHECK_STRUCT_SIZE(xfs_da_intnode_t,			16);
+	XFS_CHECK_STRUCT_SIZE(xfs_da_node_entry_t,		8);
+	XFS_CHECK_STRUCT_SIZE(xfs_da_node_hdr_t,		16);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_free_t,		4);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_data_hdr_t,		16);
+	XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, freetag,	0);
+	XFS_CHECK_OFFSET(xfs_dir2_data_unused_t, length,	2);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_hdr_t,		16);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_free_t,			16);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_entry_t,		8);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_hdr_t,		16);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_t,			16);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_leaf_tail_t,		4);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_entry_t,		3);
+	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, namelen,		0);
+	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
+	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
+	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
+
+	/* log structures */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dq_logformat,		24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_32,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efd_log_format_64,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_32,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_efi_log_format_64,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_32,		12);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_extent_64,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_log_dinode,		176);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_icreate_log,		28);
+	XFS_CHECK_STRUCT_SIZE(xfs_log_timestamp_t,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_log_legacy_timestamp,	8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format_32,	52);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bui_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bud_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_cui_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_cud_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rui_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rud_log_format,	16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_map_extent,		32);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_phys_extent,		16);
+
+	XFS_CHECK_OFFSET(struct xfs_bui_log_format, bui_extents,	16);
+	XFS_CHECK_OFFSET(struct xfs_cui_log_format, cui_extents,	16);
+	XFS_CHECK_OFFSET(struct xfs_rui_log_format, rui_extents,	16);
+	XFS_CHECK_OFFSET(struct xfs_efi_log_format, efi_extents,	16);
+	XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
+	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
+
+	/*
+	 * The v5 superblock format extended several v4 header structures with
+	 * additional data. While new fields are only accessible on v5
+	 * superblocks, it's important that the v5 structures place original v4
+	 * fields/headers in the correct location on-disk. For example, we must
+	 * be able to find magic values at the same location in certain blocks
+	 * regardless of superblock version.
+	 *
+	 * The following checks ensure that various v5 data structures place the
+	 * subset of v4 metadata associated with the same type of block at the
+	 * start of the on-disk block. If there is no data structure definition
+	 * for certain types of v4 blocks, traverse down to the first field of
+	 * common metadata (e.g., magic value) and make sure it is at offset
+	 * zero.
+	 */
+	XFS_CHECK_OFFSET(struct xfs_dir3_leaf, hdr.info.hdr,	0);
+	XFS_CHECK_OFFSET(struct xfs_da3_intnode, hdr.info.hdr,	0);
+	XFS_CHECK_OFFSET(struct xfs_dir3_data_hdr, hdr.magic,	0);
+	XFS_CHECK_OFFSET(struct xfs_dir3_free, hdr.hdr.magic,	0);
+	XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
+
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers_req,		64);
+
+	/*
+	 * Make sure the incore inode timestamp range corresponds to hand
+	 * converted values based on the ondisk format specification.
+	 */
+	XFS_CHECK_VALUE(XFS_BIGTIME_TIME_MIN - XFS_BIGTIME_EPOCH_OFFSET,
+			XFS_LEGACY_TIME_MIN);
+	XFS_CHECK_VALUE(XFS_BIGTIME_TIME_MAX - XFS_BIGTIME_EPOCH_OFFSET,
+			16299260424LL);
+
+	/* Do the same with the incore quota expiration range. */
+	XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MIN << XFS_DQ_BIGTIME_SHIFT, 4);
+	XFS_CHECK_VALUE(XFS_DQ_BIGTIME_EXPIRY_MAX << XFS_DQ_BIGTIME_SHIFT,
+			16299260424LL);
+}
+
+#endif /* __XFS_ONDISK_H */
-- 
2.44.0


