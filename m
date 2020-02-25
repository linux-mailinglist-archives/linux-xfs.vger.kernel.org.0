Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38B7E16F2FC
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Feb 2020 00:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgBYXKU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 18:10:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53296 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729326AbgBYXKU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 18:10:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=DortFVZeqGS+WRF6YCt74M1dd4NCT0gKAib5SrRIAGA=; b=ZrAQ5SlIrsuOJ8LXFXtdI/TX5j
        3xxnHhkRCbVNpH+h1A3AcKCpKLH/Kg4XsXx2AXUCnYEzGbZjLz9cdbifwwSjilgCKl0ChKQLycy56
        2p8Tm2VtBxYb91UcbvaT7uAx1tLOTlBlXk3yzf6HZ4UiBFggLz+rEc+xmv+Vp9awyshwFBOIVuZz6
        e6YOkM8HeYeCQGg+fXg4jDqw7RA177Da5e5+C2Pzg5v+xnVhF9lGaoM44CH6qjx3/X50+poGUoXj7
        hoe+g+MDOFMr9fGV+V4UN4uekaQmbAxYj68dWQFaJUH/0AP2g2FIzkKJsIzRRTypmbQ4ELHKKM+12
        5IklbsKw==;
Received: from [4.28.11.157] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6jLH-00037k-O3; Tue, 25 Feb 2020 23:10:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/30] xfs: pass an initialized xfs_da_args structure to xfs_attr_set
Date:   Tue, 25 Feb 2020 15:09:52 -0800
Message-Id: <20200225231012.735245-11-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200225231012.735245-1-hch@lst.de>
References: <20200225231012.735245-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Instead of converting from one style of arguments to another in
xfs_attr_set, pass the structure from higher up in the call chain.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 69 ++++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_attr.h |  3 +-
 fs/xfs/xfs_acl.c         | 33 ++++++++++---------
 fs/xfs/xfs_ioctl.c       | 22 ++++++++-----
 fs/xfs/xfs_iops.c        | 13 +++++---
 fs/xfs/xfs_xattr.c       | 21 ++++++++----
 6 files changed, 87 insertions(+), 74 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f887d62e0956..eea6d90af276 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -330,22 +330,17 @@ xfs_attr_remove_args(
 }
 
 /*
- * Note: If value is NULL the attribute will be removed, just like the
+ * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
  */
 int
 xfs_attr_set(
-	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	unsigned char		*value,
-	int			valuelen,
-	int			flags)
+	struct xfs_da_args	*args)
 {
+	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
-	int			rsvd = (flags & ATTR_ROOT) != 0;
+	int			rsvd = (args->flags & ATTR_ROOT) != 0;
 	int			error, local;
 	unsigned int		total;
 
@@ -356,25 +351,22 @@ xfs_attr_set(
 	if (error)
 		return error;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
-	if (error)
-		return error;
-
-	args.value = value;
-	args.valuelen = valuelen;
+	args->geo = mp->m_attr_geo;
+	args->whichfork = XFS_ATTR_FORK;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
 
 	/*
 	 * We have no control over the attribute names that userspace passes us
 	 * to remove, so we have to allow the name lookup prior to attribute
 	 * removal to fail as well.
 	 */
-	args.op_flags = XFS_DA_OP_OKNOENT;
+	args->op_flags = XFS_DA_OP_OKNOENT;
 
-	if (value) {
+	if (args->value) {
 		XFS_STATS_INC(mp, xs_attr_set);
 
-		args.op_flags |= XFS_DA_OP_ADDNAME;
-		args.total = xfs_attr_calc_size(&args, &local);
+		args->op_flags |= XFS_DA_OP_ADDNAME;
+		args->total = xfs_attr_calc_size(args, &local);
 
 		/*
 		 * If the inode doesn't have an attribute fork, add one.
@@ -382,8 +374,8 @@ xfs_attr_set(
 		 */
 		if (XFS_IFORK_Q(dp) == 0) {
 			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
-				XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen,
-						valuelen);
+				XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen,
+						args->valuelen);
 
 			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
 			if (error)
@@ -391,10 +383,11 @@ xfs_attr_set(
 		}
 
 		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-				 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
+				 M_RES(mp)->tr_attrsetrt.tr_logres *
+					args->total;
 		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
 		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-		total = args.total;
+		total = args->total;
 	} else {
 		XFS_STATS_INC(mp, xs_attr_remove);
 
@@ -407,29 +400,29 @@ xfs_attr_set(
 	 * operation if necessary
 	 */
 	error = xfs_trans_alloc(mp, &tres, total, 0,
-			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
+			rsvd ? XFS_TRANS_RESERVE : 0, &args->trans);
 	if (error)
 		return error;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(args.trans, dp, 0);
-	if (value) {
+	xfs_trans_ijoin(args->trans, dp, 0);
+	if (args->value) {
 		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
 
 		if (rsvd)
 			quota_flags |= XFS_QMOPT_FORCE_RES;
-		error = xfs_trans_reserve_quota_nblks(args.trans, dp,
-				args.total, 0, quota_flags);
+		error = xfs_trans_reserve_quota_nblks(args->trans, dp,
+				args->total, 0, quota_flags);
 		if (error)
 			goto out_trans_cancel;
-		error = xfs_attr_set_args(&args);
+		error = xfs_attr_set_args(args);
 		if (error)
 			goto out_trans_cancel;
 		/* shortform attribute has already been committed */
-		if (!args.trans)
+		if (!args->trans)
 			goto out_unlock;
 	} else {
-		error = xfs_attr_remove_args(&args);
+		error = xfs_attr_remove_args(args);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -439,23 +432,23 @@ xfs_attr_set(
 	 * transaction goes to disk before returning to the user.
 	 */
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
-		xfs_trans_set_sync(args.trans);
+		xfs_trans_set_sync(args->trans);
 
-	if ((flags & ATTR_KERNOTIME) == 0)
-		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
+	if ((args->flags & ATTR_KERNOTIME) == 0)
+		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
 	 * Commit the last in the sequence of transactions.
 	 */
-	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
-	error = xfs_trans_commit(args.trans);
+	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
+	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 
 out_trans_cancel:
-	if (args.trans)
-		xfs_trans_cancel(args.trans);
+	if (args->trans)
+		xfs_trans_cancel(args->trans);
 	goto out_unlock;
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index db58a6c7dea5..07ca543db831 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -149,8 +149,7 @@ int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 		 size_t namelen, unsigned char **value, int *valuelenp,
 		 int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int valuelen, int flags);
+int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 4e76063ff956..6ec0e0ec813e 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -14,6 +14,8 @@
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_acl.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 
 #include <linux/posix_acl_xattr.h>
 
@@ -166,41 +168,42 @@ xfs_get_acl(struct inode *inode, int type)
 int
 __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
-	struct xfs_inode *ip = XFS_I(inode);
-	unsigned char *ea_name;
-	struct xfs_acl *xfs_acl = NULL;
-	int len = 0;
-	int error;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_da_args	args = {
+		.dp		= ip,
+		.flags		= ATTR_ROOT,
+	};
+	int			error;
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
-		ea_name = SGI_ACL_FILE;
+		args.name = SGI_ACL_FILE;
 		break;
 	case ACL_TYPE_DEFAULT:
 		if (!S_ISDIR(inode->i_mode))
 			return acl ? -EACCES : 0;
-		ea_name = SGI_ACL_DEFAULT;
+		args.name = SGI_ACL_DEFAULT;
 		break;
 	default:
 		return -EINVAL;
 	}
+	args.namelen = strlen(args.name);
 
 	if (acl) {
-		len = XFS_ACL_MAX_SIZE(ip->i_mount);
-		xfs_acl = kmem_zalloc_large(len, 0);
-		if (!xfs_acl)
+		args.valuelen = XFS_ACL_MAX_SIZE(ip->i_mount);
+		args.value = kmem_zalloc_large(args.valuelen, 0);
+		if (!args.value)
 			return -ENOMEM;
 
-		xfs_acl_to_disk(xfs_acl, acl);
+		xfs_acl_to_disk(args.value, acl);
 
 		/* subtract away the unused acl entries */
-		len -= sizeof(struct xfs_acl_entry) *
+		args.valuelen -= sizeof(struct xfs_acl_entry) *
 			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
 	}
 
-	error = xfs_attr_set(ip, ea_name, strlen(ea_name),
-			(unsigned char *)xfs_acl, len, ATTR_ROOT);
-	kmem_free(xfs_acl);
+	error = xfs_attr_set(&args);
+	kmem_free(args.value);
 
 	/*
 	 * If the attribute didn't exist to start with that's fine.
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index b17458c8947e..fed4f359ef20 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -35,6 +35,8 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -389,9 +391,13 @@ xfs_attrmulti_attr_set(
 	uint32_t		len,
 	uint32_t		flags)
 {
-	unsigned char		*kbuf = NULL;
+	struct xfs_da_args	args = {
+		.dp		= XFS_I(inode),
+		.flags		= flags,
+		.name		= name,
+		.namelen	= strlen(name),
+	};
 	int			error;
-	size_t			namelen;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
@@ -399,16 +405,16 @@ xfs_attrmulti_attr_set(
 	if (ubuf) {
 		if (len > XFS_XATTR_SIZE_MAX)
 			return -EINVAL;
-		kbuf = memdup_user(ubuf, len);
-		if (IS_ERR(kbuf))
-			return PTR_ERR(kbuf);
+		args.value = memdup_user(ubuf, len);
+		if (IS_ERR(args.value))
+			return PTR_ERR(args.value);
+		args.valuelen = len;
 	}
 
-	namelen = strlen(name);
-	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
+	error = xfs_attr_set(&args);
 	if (!error)
 		xfs_forget_acl(inode, name, flags);
-	kfree(kbuf);
+	kfree(args.value);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 81f2f93caec0..94cd4254656c 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -50,10 +50,15 @@ xfs_initxattrs(
 	int			error = 0;
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
-		error = xfs_attr_set(ip, xattr->name,
-				     strlen(xattr->name),
-				     xattr->value, xattr->value_len,
-				     ATTR_SECURE);
+		struct xfs_da_args	args = {
+			.dp		= ip,
+			.flags		= ATTR_SECURE,
+			.name		= xattr->name,
+			.namelen	= strlen(xattr->name),
+			.value		= xattr->value,
+			.valuelen	= xattr->value_len,
+		};
+		error = xfs_attr_set(&args);
 		if (error < 0)
 			break;
 	}
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 1670bfbc9ad2..bd770094b95a 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -12,6 +12,8 @@
 #include "xfs_inode.h"
 #include "xfs_attr.h"
 #include "xfs_acl.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 
 #include <linux/posix_acl_xattr.h>
 #include <linux/xattr.h>
@@ -66,20 +68,25 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 		struct inode *inode, const char *name, const void *value,
 		size_t size, int flags)
 {
-	int			xflags = handler->flags;
-	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_da_args	args = {
+		.dp		= XFS_I(inode),
+		.flags		= handler->flags,
+		.name		= name,
+		.namelen	= strlen(name),
+		.value		= (void *)value,
+		.valuelen	= size,
+	};
 	int			error;
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
 	if (flags & XATTR_CREATE)
-		xflags |= ATTR_CREATE;
+		args.flags |= ATTR_CREATE;
 	if (flags & XATTR_REPLACE)
-		xflags |= ATTR_REPLACE;
+		args.flags |= ATTR_REPLACE;
 
-	error = xfs_attr_set(ip, (unsigned char *)name, strlen(name),
-				(void *)value, size, xflags);
+	error = xfs_attr_set(&args);
 	if (!error)
-		xfs_forget_acl(inode, name, xflags);
+		xfs_forget_acl(inode, name, args.flags);
 	return error;
 }
 
-- 
2.24.1

