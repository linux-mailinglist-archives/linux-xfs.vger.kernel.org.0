Return-Path: <linux-xfs+bounces-24264-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D87BB14331
	for <lists+linux-xfs@lfdr.de>; Mon, 28 Jul 2025 22:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A165F18C2D8E
	for <lists+linux-xfs@lfdr.de>; Mon, 28 Jul 2025 20:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6359F284684;
	Mon, 28 Jul 2025 20:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vi3LNLLq"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED3D279359
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734709; cv=none; b=YTpiVhbVPfJILxy/+RIiG+HczzrNvR6rPRNWASxQJyZw5ONyXH6LzcSkEe3IS3gBo33TgM8DKPuOb7ZejEVdvq/eS+708DUe/8+P94jRM81l+tiaxGU0DT+d4U9c8RfiGSswbOd5nEtI9kJvLwQdERmOwV4w1L1gQVTyg07gMQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734709; c=relaxed/simple;
	bh=zFHhV3A4VRERELzL+YDL6aNf651rMB4cYqz12FyBTEU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KSdHMAqw/Ki5siKt08Z0CxOInocnP5xGdK+B5iTDFAIHhlHz9D094aUemwKRA0hAYi8jor4VjP48zJzpvhuuYqwSrwItmQGQQP1w18Ql3hyHfCMEtSBWAE2h3S7Gp7gvfsxRVma3yf5ODSZXYxcF/vxybIVa3hCrsdwXrC1EFgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vi3LNLLq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yq9Xq0p4Kyl8EuYWwO58p1nE1BbmwsYnee/jNWAUYW8=;
	b=Vi3LNLLqMg8kZl1LT9uGU0MIL7ghiVDviZrzC3vScqpX+VGVoCES+tFhQI6KxMXlXNUeXJ
	8OFvHJJ8VPWMPpDcOE9dfIf/joVBzh00UpSGDbqTD9s9WQjUWvF99Vzh9viIqLrWkU7TWt
	dGwtSZ9uK0Lj/igX3F9F9GW9bF7kULU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-jgblFHtpNxCj_8eMDMFwPg-1; Mon, 28 Jul 2025 16:31:44 -0400
X-MC-Unique: jgblFHtpNxCj_8eMDMFwPg-1
X-Mimecast-MFC-AGG-ID: jgblFHtpNxCj_8eMDMFwPg_1753734703
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-61543f038dbso853060a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734703; x=1754339503;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yq9Xq0p4Kyl8EuYWwO58p1nE1BbmwsYnee/jNWAUYW8=;
        b=BB0eZrBifVHud+DiFf2+pbKgyKYfLRL1I+E1EmolQAd4lpa7ngwL/GhUNi+WUdHuu4
         dE2z9zj7EUTNxqJeKrxvAl1rJXvRhO+ZKLn05lePiIjbumt8fbMeSHSaSX3W7aB2Kry2
         jqCugE+OdXz5IBsB9DvAW9ENvk8JoxaiZzokf73Msu2pMnm0i2SUlIKeCvduJRJR2PXk
         9v7+0JWYvfQ1Dsipa+pD+elFXzHYN6tow/G1IdinCSL1uRyq+65nfzx8rxj9od6khAf8
         8DsrYrmUSuzqgxSm35vCJfIX5C8TNyIOKj4BN7RAHqtqW1VqD0u/HsozPah6c9LpU7XA
         zE4w==
X-Forwarded-Encrypted: i=1; AJvYcCWBeRtERQ2Q5dOIJJF8KjZOTlgcQMc3+54L2NQ0BKIC4wVk+u2ewQXpnwDBI8dxraqUXNoCYDm8OCA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzlv6DZoW/kpj9GsqaMzzuvXSSWiNvUG6rMMem85gDXvI+vzCQ5
	ERQZeiN1/K6A2qUdR8oTbFe4LVvC5Yc7fo/ys/rCZir7cYUlCXxfQ3IHGSuE5brl/tZXaf0/sEf
	fdWvNtDWPs5R/pIASczIeOc3YU1xvr6xc9xlBMgFpt8n/BJT09jXrjpkbqOBb
X-Gm-Gg: ASbGncuL1tkhaK0oHfzCBPjbuVXemc+Lig5exz5P0exsqU3L0Cf+BGqNKJ3+HiEUAWY
	R2yOshS2QXJqFTyt2XJch+3S2X1LczcF+MrE85WhSUP1hJ4l/19k98z5CL/WbE0pTD5/JRZa2JJ
	tMeEweT9tV3UcM61U7b6e1SzwsqBQZuQb3VYX54S/Bbr2u1m5vHOed7mcuNVD8uZLL8SjtFD7xu
	jKU+o2kz5DC5nPXFEspRxV2tbzq5KlHcqJjvq1SnD222BUVXnc+L4X81cvWrbtgKJyjLkmvdEGZ
	6nU9Nz+OY8mrYBdDH3a80JxNvp9wsK9yX7VkUrowshRVSw==
X-Received: by 2002:a05:6402:5252:b0:615:826:208d with SMTP id 4fb4d7f45d1cf-6150826251emr8895835a12.24.1753734703014;
        Mon, 28 Jul 2025 13:31:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHotbz1zzXiAp3mFxC1FxOHtx3KJJ/NCXrHkEbHkWBC21blZaP7Nz24mapHYsmFhmkQnipfRQ==
X-Received: by 2002:a05:6402:5252:b0:615:826:208d with SMTP id 4fb4d7f45d1cf-6150826251emr8895805a12.24.1753734702448;
        Mon, 28 Jul 2025 13:31:42 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:41 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:26 +0200
Subject: [PATCH RFC 22/29] xfs: add fs-verity support
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250728-fsverity-v1-22-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=14218; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=zFHhV3A4VRERELzL+YDL6aNf651rMB4cYqz12FyBTEU=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvSTSd913ndmjv51J3YyfxHNuSzXXzLL6lODq1c
 gcd991yf21HKQuDGBeDrJgiyzppralJRVL5Rwxq5GHmsDKBDGHg4hSAiRQ+YPhnm5i3+NGnbSlP
 7fmTWY7d3rVWTUN3StKVpTd7zq/siXzfw8hwiEWjLnbWurVKDE0rWcx3qtVMinX5fHVxGRtbnZX
 mdzEOAH8QRws=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Add integration with fs-verity. XFS stores fs-verity descriptor in
the extended file attributes and the Merkle tree is store in data fork
beyond EOF.

The descriptor is stored under "vdesc" extended attribute.

The Merkle tree reading/writing is done through iomap interface. The
data itself are at offset 1 << 53 in the inode's page cache. When XFS
reads from this region iomap doesn't call into fsverity to verify it
against Merkle tree. For data, verification is done on BIO completion.

When fs-verity is enabled on an inode, the XFS_IVERITY_CONSTRUCTION
flag is set meaning that the Merkle tree is being build. The
initialization ends with storing of verity descriptor and setting
inode on-disk flag (XFS_DIFLAG2_VERITY).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/Makefile               |   1 +
 fs/xfs/libxfs/xfs_da_format.h |   4 +
 fs/xfs/xfs_bmap_util.c        |   7 +
 fs/xfs/xfs_fsverity.c         | 311 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h         |  28 ++++
 fs/xfs/xfs_inode.h            |   6 +
 fs/xfs/xfs_super.c            |  20 +++
 7 files changed, 377 insertions(+)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5bf501cf8271..ad66439db7bf 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -147,6 +147,7 @@ xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
 xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
+xfs-$(CONFIG_FS_VERITY)		+= xfs_fsverity.o
 
 # notify failure
 ifeq ($(CONFIG_MEMORY_FAILURE),y)
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index e5274be2fe9c..b17fdbbb48aa 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -909,4 +909,8 @@ struct xfs_parent_rec {
 	__be32	p_gen;
 } __packed;
 
+/* fs-verity ondisk xattr name used for the fsverity descriptor */
+#define XFS_VERITY_DESCRIPTOR_NAME	"vdesc"
+#define XFS_VERITY_DESCRIPTOR_NAME_LEN	(sizeof(XFS_VERITY_DESCRIPTOR_NAME) - 1)
+
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 06ca11731e43..af1933129647 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -31,6 +31,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
 #include "xfs_zone_alloc.h"
+#include <linux/fsverity.h>
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -553,6 +554,12 @@ xfs_can_free_eofblocks(
 	if (last_fsb <= end_fsb)
 		return false;
 
+	/*
+	 * Nothing to clean on fsverity inodes as they are read-only
+	 */
+	if (IS_VERITY(VFS_I(ip)))
+		return false;
+
 	/*
 	 * Check if there is an post-EOF extent to free.  If there are any
 	 * delalloc blocks attached to the inode (data fork delalloc
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
new file mode 100644
index 000000000000..ec7dea4289d5
--- /dev/null
+++ b/fs/xfs/xfs_fsverity.c
@@ -0,0 +1,311 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2023 Red Hat, Inc.
+ */
+#include "xfs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_log_format.h"
+#include "xfs_attr.h"
+#include "xfs_bmap_util.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_attr_leaf.h"
+#include "xfs_trace.h"
+#include "xfs_quota.h"
+#include "xfs_ag.h"
+#include "xfs_fsverity.h"
+#include "xfs_iomap.h"
+#include <linux/fsverity.h>
+#include <linux/pagemap.h>
+
+/*
+ * Initialize an args structure to load or store the fsverity descriptor.
+ * Caller must ensure @args is zeroed except for value and valuelen.
+ */
+static inline void
+xfs_fsverity_init_vdesc_args(
+	struct xfs_inode	*ip,
+	struct xfs_da_args	*args)
+{
+	args->geo = ip->i_mount->m_attr_geo;
+	args->whichfork = XFS_ATTR_FORK;
+	args->attr_filter = XFS_ATTR_VERITY;
+	args->op_flags = XFS_DA_OP_OKNOENT;
+	args->dp = ip;
+	args->owner = ip->i_ino;
+	args->name = XFS_VERITY_DESCRIPTOR_NAME;
+	args->namelen = XFS_VERITY_DESCRIPTOR_NAME_LEN;
+	xfs_attr_sethash(args);
+}
+
+/* Delete the verity descriptor. */
+static int
+xfs_fsverity_delete_descriptor(
+	struct xfs_inode	*ip)
+{
+	struct xfs_da_args	args = { };
+
+	xfs_fsverity_init_vdesc_args(ip, &args);
+	return xfs_attr_set(&args, XFS_ATTRUPDATE_REMOVE, false);
+}
+
+/* Retrieve the verity descriptor. */
+static int
+xfs_fsverity_get_descriptor(
+	struct inode		*inode,
+	void			*buf,
+	size_t			buf_size)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_da_args	args = {
+		.value		= buf,
+		.valuelen	= buf_size,
+	};
+	int			error = 0;
+
+	/*
+	 * The fact that (returned attribute size) == (provided buf_size) is
+	 * checked by xfs_attr_copy_value() (returns -ERANGE).  No descriptor
+	 * is treated as a short read so that common fsverity code will
+	 * complain.
+	 */
+	xfs_fsverity_init_vdesc_args(ip, &args);
+	error = xfs_attr_get(&args);
+	if (error == -ENOATTR)
+		return 0;
+	if (error)
+		return error;
+
+	return args.valuelen;
+}
+
+/* Try to remove all the fsverity metadata after a failed enablement. */
+static int
+xfs_fsverity_delete_metadata(
+	struct xfs_inode	*ip)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
+	if (error) {
+		ASSERT(xfs_is_shutdown(mp));
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, 0);
+
+	/*
+	 * As only merkle tree is getting removed, no need to change inode size
+	 */
+	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, XFS_ISIZE(ip));
+	if (error)
+		goto err_cancel;
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error)
+		return error;
+
+	error = xfs_fsverity_delete_descriptor(ip);
+	return error != -ENOATTR ? error : 0;
+
+err_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+
+/* Prepare to enable fsverity by clearing old metadata. */
+static int
+xfs_fsverity_begin_enable(
+	struct file		*filp)
+{
+	struct inode		*inode = file_inode(filp);
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			error;
+
+	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
+
+	if (IS_DAX(inode))
+		return -EINVAL;
+
+	if (inode->i_size > XFS_FSVERITY_MTREE_OFFSET)
+		return -EFBIG;
+
+	if (xfs_iflags_test_and_set(ip, XFS_VERITY_CONSTRUCTION))
+		return -EBUSY;
+
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
+
+	return xfs_fsverity_delete_metadata(ip);
+}
+
+/* Complete (or fail) the process of enabling fsverity. */
+static int
+xfs_fsverity_end_enable(
+	struct file		*filp,
+	const void		*desc,
+	size_t			desc_size,
+	u64			merkle_tree_size)
+{
+	struct xfs_da_args	args = {
+		.value		= (void *)desc,
+		.valuelen	= desc_size,
+	};
+	struct inode		*inode = file_inode(filp);
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error = 0;
+
+	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
+
+	/* fs-verity failed, just cleanup */
+	if (desc == NULL)
+		goto out;
+
+	xfs_fsverity_init_vdesc_args(ip, &args);
+	error = xfs_attr_set(&args, XFS_ATTRUPDATE_UPSERT, false);
+	if (error)
+		goto out;
+
+	/*
+	 * Wait for Merkel tree get written to disk before setting on-disk inode
+	 * flag and clering XFS_VERITY_CONSTRUCTION
+	 */
+	error = filemap_write_and_wait(inode->i_mapping);
+	if (error)
+		return error;
+
+	/* Set fsverity inode flag */
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange,
+			0, 0, false, &tp);
+	if (error)
+		goto out;
+
+	/*
+	 * Ensure that we've persisted the verity information before we enable
+	 * it on the inode and tell the caller we have sealed the inode.
+	 */
+	ip->i_diflags2 |= XFS_DIFLAG2_VERITY;
+
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	xfs_trans_set_sync(tp);
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	if (!error)
+		inode->i_flags |= S_VERITY;
+
+out:
+	if (error) {
+		int	error2;
+
+		error2 = xfs_fsverity_delete_metadata(ip);
+		if (error2)
+			xfs_alert(ip->i_mount,
+"ino 0x%llx failed to clean up new fsverity metadata, err %d",
+					ip->i_ino, error2);
+	}
+
+	xfs_iflags_clear(ip, XFS_VERITY_CONSTRUCTION);
+	return error;
+}
+
+static void
+xfs_fsverity_adjust_read(
+		struct ioregion	*region)
+{
+	u8			log_blocksize;
+	unsigned int		block_size;
+	u64			tree_size;
+	u64			position = region->pos & XFS_FSVERITY_MTREE_MASK;
+
+	fsverity_merkle_tree_geometry(region->inode, &log_blocksize,
+				      &block_size, &tree_size);
+
+	if (position + region->length < tree_size)
+		return;
+
+	region->length = tree_size - position;
+}
+
+/* Retrieve a merkle tree block. */
+static struct page *
+xfs_fsverity_read_merkle(
+	struct inode		*inode,
+	pgoff_t			index,
+	unsigned long		num_ra_pages)
+{
+	u64 position		= (index << PAGE_SHIFT) | XFS_FSVERITY_MTREE_OFFSET;
+	struct ioregion region	= {
+		.inode		= inode,
+		.pos		= position,
+		.length		= PAGE_SIZE,
+		.ops		= &xfs_read_iomap_ops,
+	};
+	int			error;
+	struct folio		*folio;
+
+	/*
+	 * As region->length is PAGE_SIZE we have to adjust the length for the
+	 * end of the tree. The case when tree blocks size are smaller then
+	 * PAGE_SIZE.
+	 */
+	xfs_fsverity_adjust_read(&region);
+
+	folio = iomap_read_region(&region);
+	if (IS_ERR(folio))
+		return ERR_PTR(-EIO);
+
+	/* Wait for buffered read to finish */
+	error = folio_wait_locked_killable(folio);
+	if (error)
+		return ERR_PTR(error);
+	if (IS_ERR(folio) || !folio_test_uptodate(folio))
+		return ERR_PTR(-EFSCORRUPTED);
+
+	return folio_file_page(folio, 0);
+}
+
+/* Write a merkle tree block. */
+static int
+xfs_fsverity_write_merkle(
+	struct inode				*inode,
+	const void				*buf,
+	u64					pos,
+	unsigned int				size)
+{
+	struct ioregion region			= {
+		.inode				= inode,
+		.pos				= pos | XFS_FSVERITY_MTREE_OFFSET,
+		.buf				= buf,
+		.length				= size,
+		.ops				= &xfs_buffered_write_iomap_ops,
+	};
+
+	if (region.pos + region.length > inode->i_sb->s_maxbytes)
+		return -EFBIG;
+
+	return iomap_write_region(&region);
+}
+
+const struct fsverity_operations xfs_fsverity_ops = {
+	.begin_enable_verity		= xfs_fsverity_begin_enable,
+	.end_enable_verity		= xfs_fsverity_end_enable,
+	.get_verity_descriptor		= xfs_fsverity_get_descriptor,
+	.read_merkle_tree_page		= xfs_fsverity_read_merkle,
+	.write_merkle_tree_block	= xfs_fsverity_write_merkle,
+};
diff --git a/fs/xfs/xfs_fsverity.h b/fs/xfs/xfs_fsverity.h
new file mode 100644
index 000000000000..e063b7288dc0
--- /dev/null
+++ b/fs/xfs/xfs_fsverity.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Red Hat, Inc.
+ */
+#ifndef __XFS_FSVERITY_H__
+#define __XFS_FSVERITY_H__
+
+/* Merkle tree location in page cache. We take memory region from the inode's
+ * address space for Merkle tree.
+ *
+ * At maximum of 8 levels with 128 hashes per block (32 bytes SHA-256) maximum
+ * tree size is ((128^8 − 1)/(128 − 1)) = 567*10^12 blocks. This should fit in 53
+ * bits address space.
+ *
+ * At this Merkle tree size we can cover 295EB large file. This is much larger
+ * than the currently supported file size.
+ *
+ * As we allocate some pagecache space for fsverity tree we need to limit
+ * maximum fsverity file size.
+ */
+#define XFS_FSVERITY_MTREE_OFFSET (1ULL << 53)
+#define XFS_FSVERITY_MTREE_MASK (XFS_FSVERITY_MTREE_OFFSET - 1)
+
+#ifdef CONFIG_FS_VERITY
+extern const struct fsverity_operations xfs_fsverity_ops;
+#endif	/* CONFIG_FS_VERITY */
+
+#endif	/* __XFS_FSVERITY_H__ */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index d7e2b902ef5c..033e1a71e64b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -404,6 +404,12 @@ static inline bool xfs_inode_can_hw_atomic_write(const struct xfs_inode *ip)
  */
 #define XFS_IREMAPPING		(1U << 15)
 
+/*
+ * fs-verity's Merkle tree is under construction. The file is read-only, the
+ * only writes happening is the ones with Merkle tree blocks.
+ */
+#define XFS_VERITY_CONSTRUCTION	(1U << 16)
+
 /* All inode state flags related to inode reclaim. */
 #define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
 				 XFS_IRECLAIM | \
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7b1ace75955c..10fb23ac672a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -30,6 +30,7 @@
 #include "xfs_filestream.h"
 #include "xfs_quota.h"
 #include "xfs_sysfs.h"
+#include "xfs_fsverity.h"
 #include "xfs_ondisk.h"
 #include "xfs_rmap_item.h"
 #include "xfs_refcount_item.h"
@@ -54,6 +55,7 @@
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
 #include <linux/fsverity.h>
+#include <linux/iomap.h>
 
 static const struct super_operations xfs_super_operations;
 
@@ -1711,6 +1713,9 @@ xfs_fs_fill_super(
 	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
 #endif
 	sb->s_op = &xfs_super_operations;
+#ifdef CONFIG_FS_VERITY
+	sb->s_vop = &xfs_fsverity_ops;
+#endif
 
 	/*
 	 * Delay mount work if the debug hook is set. This is debug
@@ -1964,10 +1969,25 @@ xfs_fs_fill_super(
 		xfs_set_resuming_quotaon(mp);
 	mp->m_qflags &= ~XFS_QFLAGS_MNTOPTS;
 
+	if (xfs_has_verity(mp))
+		xfs_warn(mp,
+	"EXPERIMENTAL fsverity feature in use. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
 
+#ifdef CONFIG_FS_VERITY
+	/*
+	 * Don't use a high priority workqueue like the other fsverity
+	 * implementations because that will lead to conflicts with the xfs log
+	 * workqueue.
+	 */
+	error = iomap_init_fsverity(mp->m_super, 0, 0);
+	if (error)
+		goto out_unmount;
+#endif
+
 	root = igrab(VFS_I(mp->m_rootip));
 	if (!root) {
 		error = -ENOENT;

-- 
2.50.0


