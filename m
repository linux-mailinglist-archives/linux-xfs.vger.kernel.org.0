Return-Path: <linux-xfs+bounces-4595-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25B1A870A3D
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Mar 2024 20:13:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A0541C21D29
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Mar 2024 19:13:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134CD7A158;
	Mon,  4 Mar 2024 19:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UYqN/Szv"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDE779DA5
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579540; cv=none; b=H0yTwouRc++aFC7AMhMXgUJS7yW+4hH7lG7OroGmN9Th/1zanysKMiO6Wh/+pLzMWUl9lmCfKsnhj/zuWnmSgN45hhiLIR3g07f14v0W6p54PIucFFC284wVePnI0pP7VYvrbVSRuODhpFutHbBLY4WATGKp4AdS86p+va4cRNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579540; c=relaxed/simple;
	bh=ci0FfeM96EeB9lWKNbTR9eYvaxL+beqdoyCcFvRWmhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GStz2F7fnoCVj+GlbkHAms8j+3ON1NiI+Ixq3U46L8hlIco399ggF73j31lRFVrAMeIsZPKhAIL9Fr25IjfsGeK7qFf4y19abnvmzgmS5CEys/sOy5GtGNfKeYXCcH2Ty+znGBMrjV0SmuD+mrsaRzaAIKuClCK8PSQanqCgFEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UYqN/Szv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0n+uFZr/Kow5GjcpVhCgELZq9b7RyWnDiaBhPHsxGIE=;
	b=UYqN/SzvPLRsfvt1TFFl5LZxlFTXc/09ZWyzeiRUnH7eUOqwBMkE/vEifX/JTy2c+bIvSh
	N8UOMnPba/YfHq5Z9MDTwFXgxSJQqK+/UtMMsdkVcQ0riRFJTeUNS2kszoK8w+7PMt/Ntq
	8d69xqPfDm2+yZw3w+ohpr4eoJ1xO2E=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-GsICmF82NNCMtftA8PYcJg-1; Mon, 04 Mar 2024 14:12:16 -0500
X-MC-Unique: GsICmF82NNCMtftA8PYcJg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-567002485e2so2041755a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579534; x=1710184334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0n+uFZr/Kow5GjcpVhCgELZq9b7RyWnDiaBhPHsxGIE=;
        b=b4rQ7RIPBCAxl6pz9gstX07WTzY/VuiISl3lbpTlJlFuO01jUGVv/ARLlbinuFeVJy
         x1E/GuJedJOJ/38eqYdTGeLk8yFADIae83w7Qi7hUC1NBn+q5BA5O9Ia55vyZppBF6y9
         rpVrMXKvK46ZdDsLJpL+F3VxYtuXMKpR5p3r0aMw+md4fAU2QrM8IcgnpaAsAwpBWosT
         OfFspBIQOqVebPfH1IlNpNQpTVZyRCN2IQabhgzm9Lv0ri8gnY8V/j0w2vpo81XoD1//
         UwtqAD7lQptaZWBiVCk49DGfd76vnt7xRGjVlzAcsicmYctypR3opaE4Ijz7s1Wq7tU4
         Mk6A==
X-Forwarded-Encrypted: i=1; AJvYcCXFF4wUZDGwVoE0GNXb+q6JbE8pYS8Uz49omSbDIlMa2C+vICkKvuK3fVTGIvVOSidldwNdKszHZB78OXD4l/8nVaNXaB7lRVUW
X-Gm-Message-State: AOJu0YwxnSUoSxDOK6jF+Xv6Bb4bbSb610PjF9NS2JW6KUY5H4KRHK6v
	+6oPysCaxMHAh/LY2BVkhPoQAjeA5h/NfNKFMA3mtrEKo1UooNGyue1+jwlcijVl6MNDBaIdy1O
	LuMN+5zYh+dX0f+v0LuQo6SqrH5YvHe7tY1wYqEm0TbaLUicvSeJ9o7FPW0Ah00m5
X-Received: by 2002:a17:906:d045:b0:a44:5589:c098 with SMTP id bo5-20020a170906d04500b00a445589c098mr7051652ejb.7.1709579534458;
        Mon, 04 Mar 2024 11:12:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF6jiT77x9PzfXqpjOQ0rV11OPNJD1P3FAvESiqLUsCV3IJKvBKhmkEB0j3Xp+Ywja8OJOpHw==
X-Received: by 2002:a17:906:d045:b0:a44:5589:c098 with SMTP id bo5-20020a170906d04500b00a445589c098mr7051636ejb.7.1709579534138;
        Mon, 04 Mar 2024 11:12:14 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:13 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v5 04/24] xfs: add parent pointer validator functions
Date: Mon,  4 Mar 2024 20:10:27 +0100
Message-ID: <20240304191046.157464-6-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304191046.157464-2-aalbersh@redhat.com>
References: <20240304191046.157464-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 fs/xfs/Makefile               |   1 +
 fs/xfs/libxfs/xfs_attr.c      |  10 ++-
 fs/xfs/libxfs/xfs_attr.h      |   3 +-
 fs/xfs/libxfs/xfs_da_format.h |   8 +++
 fs/xfs/libxfs/xfs_parent.c    | 113 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h    |  19 ++++++
 fs/xfs/scrub/attr.c           |   2 +-
 fs/xfs/xfs_attr_item.c        |   6 +-
 fs/xfs/xfs_attr_list.c        |  14 +++--
 9 files changed, 165 insertions(+), 11 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 76674ad5833e..f8845e65cac7 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -41,6 +41,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
 				   xfs_ag_resv.o \
+				   xfs_parent.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
 				   xfs_refcount.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ff67a684a452..f0b625d45aa4 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -26,6 +26,7 @@
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
 #include "xfs_xattr.h"
+#include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
 
@@ -1515,9 +1516,14 @@ xfs_attr_node_get(
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
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 81be9b3e4004..92711c8d2a9f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -547,7 +547,8 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
+		unsigned int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 67e8c33c4e82..839df0e5401b 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
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
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
new file mode 100644
index 000000000000..1d45f926c13a
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022-2024 Oracle.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_attr_sf.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log.h"
+#include "xfs_xattr.h"
+#include "xfs_parent.h"
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
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
new file mode 100644
index 000000000000..fcfeddb645f6
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_parent.h
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
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 49f91cc85a65..9a1f59f7b5a4 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -195,7 +195,7 @@ xchk_xattr_listent(
 	}
 
 	/* Does this name make sense? */
-	if (!xfs_attr_namecheck(name, namelen)) {
+	if (!xfs_attr_namecheck(sx->sc->mp, name, namelen, flags)) {
 		xchk_fblock_set_corrupt(sx->sc, XFS_ATTR_FORK, args.blkno);
 		goto fail_xref;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 9b4c61e1c22e..703770cf1482 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -591,7 +591,8 @@ xfs_attr_recover_work(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(mp, nv->name.i_addr, nv->name.i_len,
+				attrp->alfi_attr_filter))
 		return -EFSCORRUPTED;
 
 	attr = xfs_attri_recover_work(mp, dfp, attrp, &ip, nv);
@@ -731,7 +732,8 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp->alfi_name_len,
+				attri_formatp->alfi_attr_filter)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				item->ri_buf[1].i_addr, item->ri_buf[1].i_len);
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index a6819a642cc0..fa74378577c5 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -59,6 +59,7 @@ xfs_attr_shortform_list(
 	struct xfs_attr_sf_sort		*sbuf, *sbp;
 	struct xfs_attr_sf_hdr		*sf = dp->i_af.if_data;
 	struct xfs_attr_sf_entry	*sfe;
+	struct xfs_mount		*mp = dp->i_mount;
 	int				sbsize, nsbuf, count, i;
 	int				error = 0;
 
@@ -82,8 +83,9 @@ xfs_attr_shortform_list(
 	     (dp->i_af.if_bytes + sf->count * 16) < context->bufsize)) {
 		for (i = 0, sfe = xfs_attr_sf_firstentry(sf); i < sf->count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-					   !xfs_attr_namecheck(sfe->nameval,
-							       sfe->namelen))) {
+					   !xfs_attr_namecheck(mp, sfe->nameval,
+							       sfe->namelen,
+							       sfe->flags))) {
 				xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
 				return -EFSCORRUPTED;
 			}
@@ -177,8 +179,9 @@ xfs_attr_shortform_list(
 			cursor->offset = 0;
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(sbp->name,
-						       sbp->namelen))) {
+				   !xfs_attr_namecheck(mp, sbp->name,
+						       sbp->namelen,
+						       sbp->flags))) {
 			xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
 			error = -EFSCORRUPTED;
 			goto out;
@@ -474,7 +477,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen))) {
+				   !xfs_attr_namecheck(mp, name, namelen,
+						       entry->flags))) {
 			xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
 			return -EFSCORRUPTED;
 		}
-- 
2.42.0


