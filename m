Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78243167FB7
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 15:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgBUOL4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 09:11:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgBUOL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:11:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=sGCmx40qH6mh36PCj7qMMVQ173hYYfpyj5PT25Z7dsg=; b=ArokZjit5wVNRhNZty1JW5HPZR
        hNalMsuW0WQVA54IpvCaLIs3xImB8ZXP5Y70JAOrhfgh1+cJbgiH6S6b8f3v1pyyZEMGNDmvK7WAY
        zSatAtFSfQUihxS5+VH7YL5PhPM0+FeAUEAa7wmQOItxsrFApuK0nKzXfWRPYzc/99QA5/BxcZZiB
        a8m/82kRaGxq4znrM5uhkZfaaV3AKK7iYHOVzoSeUleWagjqMJHTJXhtwR9NB6lt5W7YgEBBJeNRE
        JyGVhSl7CQNrdj46qDrQ8ZoPIZSBDWrvgMLCkR9TbRAG9Hi7ukFqokAXqjJMvnTX+Q3q5ucSFlPQm
        L2QT03Ew==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5923-0000GH-GG; Fri, 21 Feb 2020 14:11:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>
Subject: [PATCH 03/31] xfs: merge xfs_attr_remove into xfs_attr_set
Date:   Fri, 21 Feb 2020 06:11:26 -0800
Message-Id: <20200221141154.476496-4-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221141154.476496-1-hch@lst.de>
References: <20200221141154.476496-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The Linux xattr and acl APIs use a single call for set and remove.
Modify the high-level XFS API to match that and let xfs_attr_set handle
removing attributes as well.  With a little bit of reordering this
removes a lot of code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 178 ++++++++++++++-------------------------
 fs/xfs/libxfs/xfs_attr.h |   2 -
 fs/xfs/xfs_acl.c         |  33 +++-----
 fs/xfs/xfs_ioctl.c       |   4 +-
 fs/xfs/xfs_xattr.c       |   9 +-
 5 files changed, 77 insertions(+), 149 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e6149720ce02..bb391b96cd78 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -336,6 +336,10 @@ xfs_attr_remove_args(
 	return error;
 }
 
+/*
+ * Note: If value is NULL the attribute will be removed, just like the
+ * Linux ->setattr API.
+ */
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
@@ -350,149 +354,92 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	int			rsvd = (flags & ATTR_ROOT) != 0;
 	int			error, local;
-
-	XFS_STATS_INC(mp, xs_attr_set);
+	unsigned int		total;
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
-	if (error)
-		return error;
-
-	args.value = value;
-	args.valuelen = valuelen;
-	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
-	args.total = xfs_attr_calc_size(&args, &local);
-
 	error = xfs_qm_dqattach(dp);
 	if (error)
 		return error;
 
-	/*
-	 * If the inode doesn't have an attribute fork, add one.
-	 * (inode must not be locked when we call this routine)
-	 */
-	if (XFS_IFORK_Q(dp) == 0) {
-		int sf_size = sizeof(xfs_attr_sf_hdr_t) +
-			XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, valuelen);
-
-		error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
-		if (error)
-			return error;
-	}
-
-	tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
-			 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
-	tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
-	tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
-
-	/*
-	 * Root fork attributes can use reserved data blocks for this
-	 * operation if necessary
-	 */
-	error = xfs_trans_alloc(mp, &tres, args.total, 0,
-			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
-	xfs_ilock(dp, XFS_ILOCK_EXCL);
-	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
-				rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
-				       XFS_QMOPT_RES_REGBLKS);
-	if (error)
-		goto out_trans_cancel;
-
-	xfs_trans_ijoin(args.trans, dp, 0);
-	error = xfs_attr_set_args(&args);
-	if (error)
-		goto out_trans_cancel;
-	if (!args.trans) {
-		/* shortform attribute has already been committed */
-		goto out_unlock;
-	}
-
-	/*
-	 * If this is a synchronous mount, make sure that the
-	 * transaction goes to disk before returning to the user.
-	 */
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
-		xfs_trans_set_sync(args.trans);
-
-	if ((flags & ATTR_KERNOTIME) == 0)
-		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
+	args.value = value;
+	args.valuelen = valuelen;
 
 	/*
-	 * Commit the last in the sequence of transactions.
+	 * We have no control over the attribute names that userspace passes us
+	 * to remove, so we have to allow the name lookup prior to attribute
+	 * removal to fail as well.
 	 */
-	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
-	error = xfs_trans_commit(args.trans);
-out_unlock:
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	return error;
-
-out_trans_cancel:
-	if (args.trans)
-		xfs_trans_cancel(args.trans);
-	goto out_unlock;
-}
+	args.op_flags = XFS_DA_OP_OKNOENT;
 
-/*
- * Generic handler routine to remove a name from an attribute list.
- * Transitions attribute list from Btree to shortform as necessary.
- */
-int
-xfs_attr_remove(
-	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	int			flags)
-{
-	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_da_args	args;
-	int			error;
+	if (value) {
+		XFS_STATS_INC(mp, xs_attr_set);
 
-	XFS_STATS_INC(mp, xs_attr_remove);
+		args.op_flags |= XFS_DA_OP_ADDNAME;
+		args.total = xfs_attr_calc_size(&args, &local);
 
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return -EIO;
+		/*
+		 * If the inode doesn't have an attribute fork, add one.
+		 * (inode must not be locked when we call this routine)
+		 */
+		if (XFS_IFORK_Q(dp) == 0) {
+			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
+				XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen,
+						valuelen);
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
-	if (error)
-		return error;
+			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
+			if (error)
+				return error;
+		}
 
-	/*
-	 * we have no control over the attribute names that userspace passes us
-	 * to remove, so we have to allow the name lookup prior to attribute
-	 * removal to fail.
-	 */
-	args.op_flags = XFS_DA_OP_OKNOENT;
+		tres.tr_logres = M_RES(mp)->tr_attrsetm.tr_logres +
+				 M_RES(mp)->tr_attrsetrt.tr_logres * args.total;
+		tres.tr_logcount = XFS_ATTRSET_LOG_COUNT;
+		tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+		total = args.total;
+	} else {
+		XFS_STATS_INC(mp, xs_attr_remove);
 
-	error = xfs_qm_dqattach(dp);
-	if (error)
-		return error;
+		tres = M_RES(mp)->tr_attrrm;
+		total = XFS_ATTRRM_SPACE_RES(mp);
+	}
 
 	/*
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
-			XFS_ATTRRM_SPACE_RES(mp), 0,
-			(flags & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
-			&args.trans);
+	error = xfs_trans_alloc(mp, &tres, total, 0,
+			rsvd ? XFS_TRANS_RESERVE : 0, &args.trans);
 	if (error)
 		return error;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
-	/*
-	 * No need to make quota reservations here. We expect to release some
-	 * blocks not allocate in the common case.
-	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
+	if (value) {
+		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
 
-	error = xfs_attr_remove_args(&args);
-	if (error)
-		goto out;
+		if (rsvd)
+			quota_flags |= XFS_QMOPT_FORCE_RES;
+		error = xfs_trans_reserve_quota_nblks(args.trans, dp,
+				args.total, 0, quota_flags);
+		if (error)
+			goto out_trans_cancel;
+		error = xfs_attr_set_args(&args);
+		if (error)
+			goto out_trans_cancel;
+		/* shortform attribute has already been committed */
+		if (!args.trans)
+			goto out_unlock;
+	} else {
+		error = xfs_attr_remove_args(&args);
+		if (error)
+			goto out_trans_cancel;
+	}
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -509,15 +456,14 @@ xfs_attr_remove(
 	 */
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
 	error = xfs_trans_commit(args.trans);
+out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
 	return error;
 
-out:
+out_trans_cancel:
 	if (args.trans)
 		xfs_trans_cancel(args.trans);
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	return error;
+	goto out_unlock;
 }
 
 /*========================================================================
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 71bcf1298e4c..db58a6c7dea5 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -152,8 +152,6 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 size_t namelen, unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
-		    size_t namelen, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index cd743fad8478..4e76063ff956 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -168,6 +168,8 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	struct xfs_inode *ip = XFS_I(inode);
 	unsigned char *ea_name;
+	struct xfs_acl *xfs_acl = NULL;
+	int len = 0;
 	int error;
 
 	switch (type) {
@@ -184,9 +186,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	}
 
 	if (acl) {
-		struct xfs_acl *xfs_acl;
-		int len = XFS_ACL_MAX_SIZE(ip->i_mount);
-
+		len = XFS_ACL_MAX_SIZE(ip->i_mount);
 		xfs_acl = kmem_zalloc_large(len, 0);
 		if (!xfs_acl)
 			return -ENOMEM;
@@ -196,26 +196,17 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		/* subtract away the unused acl entries */
 		len -= sizeof(struct xfs_acl_entry) *
 			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
-
-		error = xfs_attr_set(ip, ea_name, strlen(ea_name),
-				     (unsigned char *)xfs_acl, len, ATTR_ROOT);
-
-		kmem_free(xfs_acl);
-	} else {
-		/*
-		 * A NULL ACL argument means we want to remove the ACL.
-		 */
-		error = xfs_attr_remove(ip, ea_name,
-					strlen(ea_name),
-					ATTR_ROOT);
-
-		/*
-		 * If the attribute didn't exist to start with that's fine.
-		 */
-		if (error == -ENOATTR)
-			error = 0;
 	}
 
+	error = xfs_attr_set(ip, ea_name, strlen(ea_name),
+			(unsigned char *)xfs_acl, len, ATTR_ROOT);
+	kmem_free(xfs_acl);
+
+	/*
+	 * If the attribute didn't exist to start with that's fine.
+	 */
+	if (!acl && error == -ENOATTR)
+		error = 0;
 	if (!error)
 		set_cached_acl(inode, type, acl);
 	return error;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d974bf099d45..79c418888e9a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -417,12 +417,10 @@ xfs_attrmulti_attr_remove(
 	uint32_t		flags)
 {
 	int			error;
-	size_t			namelen;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
-	namelen = strlen(name);
-	error = xfs_attr_remove(XFS_I(inode), name, namelen, flags);
+	error = xfs_attr_set(XFS_I(inode), name, strlen(name), NULL, 0, flags);
 	if (!error)
 		xfs_forget_acl(inode, name, flags);
 	return error;
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index b0fedb543f97..1670bfbc9ad2 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -69,7 +69,6 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 	int			xflags = handler->flags;
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error;
-	size_t			namelen = strlen(name);
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
 	if (flags & XATTR_CREATE)
@@ -77,14 +76,10 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 	if (flags & XATTR_REPLACE)
 		xflags |= ATTR_REPLACE;
 
-	if (value)
-		error = xfs_attr_set(ip, name, namelen, (void *)value, size,
-				xflags);
-	else
-		error = xfs_attr_remove(ip, name, namelen, xflags);
+	error = xfs_attr_set(ip, (unsigned char *)name, strlen(name),
+				(void *)value, size, xflags);
 	if (!error)
 		xfs_forget_acl(inode, name, xflags);
-
 	return error;
 }
 
-- 
2.24.1

