Return-Path: <linux-xfs+bounces-1925-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 632708210B7
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:06:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 875521C21B82
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 23:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46EC4C154;
	Sun, 31 Dec 2023 23:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJ55YpMr"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11670C147
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC97AC433C8;
	Sun, 31 Dec 2023 23:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063953;
	bh=Nv9UgbWwUVzaXuBtiJaiee+HLUDfgH/HYL7zyLUAecU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cJ55YpMr71Ay7IIi3RwziSyPoF5cWT4h2Fb3tJJlCTHtDj8PMV9HCsLygJHly6uqP
	 nngGeZlSJxMUvnQuPgKojHLugcLOYzdAxDSCGIyJojGTIjyXz2+gaTEjxJhQV6Wgaj
	 WLMZ2mhWrxtuWIEw+Nj3+PhJ7xAmZEPhyCVXvBuZECGgU17os8oi4MgddEl9Pu2wmQ
	 wwMavL9Q8mARORGw5OaSJbdzvC/KCWZ5d1ozq0n0coTjvMXaAsoUj9Xbjg4B7iBjAU
	 S0BKBMPQ50UVfOpcy2VjZYmtrgorH6a5VltQ3HRfYfCt1W8xjOhjm6eSWNbP39dwIe
	 QLfeEZr46Lxcg==
Date: Sun, 31 Dec 2023 15:05:53 -0800
Subject: [PATCH 03/32] xfs: add parent pointer validator functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006142.1804688.593744446205743406.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
References: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Allison Henderson <allison.henderson@oracle.com>

Attribute names of parent pointers are not strings.  So we need to
modify attr_namecheck to verify parent pointer records when the
XFS_ATTR_PARENT flag is set.  At the same time, we need to validate attr
values during log recovery if the xattr is really a parent pointer.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: move functions to xfs_parent.c, adjust for new disk format]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/Makefile        |    2 +
 libxfs/xfs_attr.c      |   10 +++-
 libxfs/xfs_attr.h      |    3 +
 libxfs/xfs_da_format.h |    8 +++
 libxfs/xfs_parent.c    |  114 ++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h    |   19 ++++++++
 repair/attr_repair.c   |   19 +++++---
 7 files changed, 165 insertions(+), 10 deletions(-)
 create mode 100644 libxfs/xfs_parent.c
 create mode 100644 libxfs/xfs_parent.h


diff --git a/libxfs/Makefile b/libxfs/Makefile
index 0fb8f7b39bc..38594965882 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -50,6 +50,7 @@ HFILES = \
 	xfs_ialloc_btree.h \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
+	xfs_parent.h \
 	xfs_quota_defs.h \
 	xfs_refcount.h \
 	xfs_refcount_btree.h \
@@ -101,6 +102,7 @@ CFILES = cache.c \
 	xfs_inode_fork.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
+	xfs_parent.c \
 	xfs_refcount.c \
 	xfs_refcount_btree.c \
 	xfs_rmap.c \
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 78884485c08..04561f0318a 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -24,6 +24,7 @@
 #include "xfs_quota_defs.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
 
@@ -1543,9 +1544,14 @@ xfs_attr_node_get(
 /* Returns true if the attribute entry name is valid. */
 bool
 xfs_attr_namecheck(
-	const void	*name,
-	size_t		length)
+	struct xfs_mount	*mp,
+	const void		*name,
+	size_t			length,
+	unsigned int		flags)
 {
+	if (flags & XFS_ATTR_PARENT)
+		return xfs_parent_namecheck(mp, name, length, flags);
+
 	/*
 	 * MAXNAMELEN includes the trailing null, but (name/length) leave it
 	 * out, so use >= for the length check.
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index b4e8ecee3e0..5b3a0d4b158 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -552,7 +552,8 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
+		unsigned int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index edbd901d906..a63387796a2 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -757,6 +757,14 @@ xfs_attr3_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
 	return &((char *)leafp)[be16_to_cpu(entries[idx].nameidx)];
 }
 
+static inline int
+xfs_attr3_leaf_flags(xfs_attr_leafblock_t *leafp, int idx)
+{
+	struct xfs_attr_leaf_entry *entries = xfs_attr3_leaf_entryp(leafp);
+
+	return entries[idx].flags;
+}
+
 static inline xfs_attr_leaf_name_remote_t *
 xfs_attr3_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
 {
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
new file mode 100644
index 00000000000..6874d8afe23
--- /dev/null
+++ b/libxfs/xfs_parent.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022-2024 Oracle.
+ * All rights reserved.
+ */
+#include "libxfs_priv.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_trace.h"
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_da_format.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_parent.h"
+#include "xfs_da_format.h"
+#include "xfs_format.h"
+#include "xfs_trans_space.h"
+
+/*
+ * Parent pointer attribute handling.
+ *
+ * Because the attribute value is a filename component, it will never be longer
+ * than 255 bytes. This means the attribute will always be a local format
+ * attribute as it is xfs_attr_leaf_entsize_local_max() for v5 filesystems will
+ * always be larger than this (max is 75% of block size).
+ *
+ * Creating a new parent attribute will always create a new attribute - there
+ * should never, ever be an existing attribute in the tree for a new inode.
+ * ENOSPC behavior is problematic - creating the inode without the parent
+ * pointer is effectively a corruption, so we allow parent attribute creation
+ * to dip into the reserve block pool to avoid unexpected ENOSPC errors from
+ * occurring.
+ */
+
+/* Return true if parent pointer EA name is valid. */
+bool
+xfs_parent_namecheck(
+	struct xfs_mount			*mp,
+	const struct xfs_parent_name_rec	*rec,
+	size_t					reclen,
+	unsigned int				attr_flags)
+{
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return false;
+
+	/* pptr updates use logged xattrs, so we should never see this flag */
+	if (attr_flags & XFS_ATTR_INCOMPLETE)
+		return false;
+
+	if (reclen != sizeof(struct xfs_parent_name_rec))
+		return false;
+
+	/* Only one namespace bit allowed. */
+	if (hweight32(attr_flags & XFS_ATTR_NSP_ONDISK_MASK) > 1)
+		return false;
+
+	return true;
+}
+
+/* Return true if parent pointer EA value is valid. */
+bool
+xfs_parent_valuecheck(
+	struct xfs_mount		*mp,
+	const void			*value,
+	size_t				valuelen)
+{
+	if (valuelen == 0 || valuelen > XFS_PARENT_DIRENT_NAME_MAX_SIZE)
+		return false;
+
+	if (value == NULL)
+		return false;
+
+	return true;
+}
+
+/* Return true if the ondisk parent pointer is consistent. */
+bool
+xfs_parent_hashcheck(
+	struct xfs_mount		*mp,
+	const struct xfs_parent_name_rec *rec,
+	const void			*value,
+	size_t				valuelen)
+{
+	struct xfs_name			dname = {
+		.name			= value,
+		.len			= valuelen,
+	};
+	xfs_ino_t			p_ino;
+
+	/* Valid dirent name? */
+	if (!xfs_dir2_namecheck(value, valuelen))
+		return false;
+
+	/* Valid inode number? */
+	p_ino = be64_to_cpu(rec->p_ino);
+	if (!xfs_verify_dir_ino(mp, p_ino))
+		return false;
+
+	/* Namehash matches name? */
+	return be32_to_cpu(rec->p_namehash) == xfs_dir2_hashname(mp, &dname);
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
new file mode 100644
index 00000000000..fcfeddb645f
--- /dev/null
+++ b/libxfs/xfs_parent.h
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022-2024 Oracle.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_PARENT_H__
+#define	__XFS_PARENT_H__
+
+/* Metadata validators */
+bool xfs_parent_namecheck(struct xfs_mount *mp,
+		const struct xfs_parent_name_rec *rec, size_t reclen,
+		unsigned int attr_flags);
+bool xfs_parent_valuecheck(struct xfs_mount *mp, const void *value,
+		size_t valuelen);
+bool xfs_parent_hashcheck(struct xfs_mount *mp,
+		const struct xfs_parent_name_rec *rec, const void *value,
+		size_t valuelen);
+
+#endif /* __XFS_PARENT_H__ */
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index b7ebf103dd6..314a9cb4d6e 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -294,8 +294,9 @@ process_shortform_attr(
 		}
 
 		/* namecheck checks for null chars in attr names. */
-		if (!libxfs_attr_namecheck(currententry->nameval,
-					   currententry->namelen)) {
+		if (!libxfs_attr_namecheck(mp, currententry->nameval,
+					   currententry->namelen,
+					   currententry->flags)) {
 			do_warn(
 	_("entry contains illegal character in shortform attribute name\n"));
 			junkit = 1;
@@ -471,12 +472,14 @@ process_leaf_attr_local(
 	xfs_dablk_t		da_bno,
 	xfs_ino_t		ino)
 {
-	xfs_attr_leaf_name_local_t *local;
+	xfs_attr_leaf_name_local_t	*local;
+	int				flags;
 
 	local = xfs_attr3_leaf_name_local(leaf, i);
+	flags = xfs_attr3_leaf_flags(leaf, i);
 	if (local->namelen == 0 ||
-	    !libxfs_attr_namecheck(local->nameval,
-				   local->namelen)) {
+	    !libxfs_attr_namecheck(mp, local->nameval,
+				   local->namelen, flags)) {
 		do_warn(
 	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
 			i, da_bno, ino, local->namelen);
@@ -527,12 +530,14 @@ process_leaf_attr_remote(
 {
 	xfs_attr_leaf_name_remote_t *remotep;
 	char*			value;
+	int			flags;
 
 	remotep = xfs_attr3_leaf_name_remote(leaf, i);
+	flags = xfs_attr3_leaf_flags(leaf, i);
 
 	if (remotep->namelen == 0 ||
-	    !libxfs_attr_namecheck(remotep->name,
-				   remotep->namelen) ||
+	    !libxfs_attr_namecheck(mp, remotep->name,
+				   remotep->namelen, flags) ||
 	    be32_to_cpu(entry->hashval) !=
 			libxfs_da_hashname((unsigned char *)&remotep->name[0],
 					   remotep->namelen) ||


