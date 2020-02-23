Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF56F169303
	for <lists+linux-xfs@lfdr.de>; Sun, 23 Feb 2020 03:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgBWCG0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 22 Feb 2020 21:06:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45888 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbgBWCGZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:25 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N21JsR189253
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ouyg2xk1QSrhFMdPUMT//2Rm7yXLRHYNKXkNTmMDvkI=;
 b=CAun5mEgpPP8oXvqcvMxjTzF/LidMS6uHfIb3vh2S38/Vk3Mez6e50zOZKvsyxRS+5eO
 MlT3VO2C7SWoUC8reYRmS3yoxXUcOwrk24z0qdyMSwMci0xk/rozE7lrazxp0zZGgCte
 Ct1MXIVtXzJPUDbL2Eugk6vdo7nrFbgr61Dql6hlYRaoj4hH0ZwhKeBxyEvTjoJwaWQ4
 TMKPyOEmaWNb2icbMZfd2SstzlSh40XOwUYK7wA8B0D7n7wjrRjwfkHeXkX9j5Jc/TA9
 mTuZmAztOmBaYbStbhzpJNHrBIDp1tBcj9uRFjJO+8F5WXkDpjahfaQ993X1ZekX+ERl 2A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2yauqu21xr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N26Niw184167
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ybdure4eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:23 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01N26IGg031451
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:18 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:18 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 01/19] xfs: Replace attribute parameters with struct xfs_name
Date:   Sat, 22 Feb 2020 19:05:53 -0700
Message-Id: <20200223020611.1802-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223020611.1802-1-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=3
 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 bulkscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch replaces the attribute name and length parameters with a single struct
xfs_name parameter.  This helps to clean up the numbers of parameters being passed
around and pre-simplifies the code some.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c  | 22 +++++++++-------------
 fs/xfs/libxfs/xfs_attr.h  | 12 +++++-------
 fs/xfs/libxfs/xfs_types.c | 11 +++++++++++
 fs/xfs/libxfs/xfs_types.h |  1 +
 fs/xfs/xfs_acl.c          | 25 +++++++++++--------------
 fs/xfs/xfs_ioctl.c        | 23 +++++++++++++----------
 fs/xfs/xfs_iops.c         |  6 +++---
 fs/xfs/xfs_xattr.c        | 28 ++++++++++++++++------------
 8 files changed, 69 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index e614972..6717f47 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -61,8 +61,7 @@ STATIC int
 xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	int			flags)
 {
 
@@ -74,8 +73,8 @@ xfs_attr_args_init(
 	args->whichfork = XFS_ATTR_FORK;
 	args->dp = dp;
 	args->flags = flags;
-	args->name = name;
-	args->namelen = namelen;
+	args->name = name->name;
+	args->namelen = name->len;
 	if (args->namelen >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
@@ -139,8 +138,7 @@ xfs_attr_get_ilocked(
 int
 xfs_attr_get(
 	struct xfs_inode	*ip,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	unsigned char		**value,
 	int			*valuelenp,
 	int			flags)
@@ -156,7 +154,7 @@ xfs_attr_get(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
+	error = xfs_attr_args_init(&args, ip, name, flags);
 	if (error)
 		return error;
 
@@ -339,8 +337,7 @@ xfs_attr_remove_args(
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	unsigned char		*value,
 	int			valuelen,
 	int			flags)
@@ -356,7 +353,7 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
+	error = xfs_attr_args_init(&args, dp, name, flags);
 	if (error)
 		return error;
 
@@ -444,8 +441,7 @@ xfs_attr_set(
 int
 xfs_attr_remove(
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	int			flags)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -457,7 +453,7 @@ xfs_attr_remove(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
+	error = xfs_attr_args_init(&args, dp, name, flags);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 4243b22..35043db 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -147,14 +147,12 @@ int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
-int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 size_t namelen, unsigned char **value, int *valuelenp,
-		 int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int valuelen, int flags);
+int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
+		 unsigned char **value, int *valuelenp, int flags);
+int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
+		 unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
-		    size_t namelen, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 4f59554..781a5a9 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -12,6 +12,17 @@
 #include "xfs_bit.h"
 #include "xfs_mount.h"
 
+/* Initialize a struct xfs_name with a null terminated string name */
+void
+xfs_name_init(
+	struct xfs_name *xname,
+	const char *name)
+{
+	xname->name = (unsigned char *)name;
+	xname->len = strlen(name);
+	xname->type = 0;
+}
+
 /* Find the size of the AG, in blocks. */
 xfs_agblock_t
 xfs_ag_block_count(
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 397d947..b94acb5 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -180,6 +180,7 @@ enum xfs_ag_resv_type {
  */
 struct xfs_mount;
 
+void xfs_name_init(struct xfs_name *xname, const char *name);
 xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
 bool xfs_verify_agbno(struct xfs_mount *mp, xfs_agnumber_t agno,
 		xfs_agblock_t agbno);
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index cd743fad..42ac847 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -123,7 +123,7 @@ xfs_get_acl(struct inode *inode, int type)
 	struct xfs_inode *ip = XFS_I(inode);
 	struct posix_acl *acl = NULL;
 	struct xfs_acl *xfs_acl = NULL;
-	unsigned char *ea_name;
+	struct xfs_name name;
 	int error;
 	int len;
 
@@ -131,10 +131,10 @@ xfs_get_acl(struct inode *inode, int type)
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
-		ea_name = SGI_ACL_FILE;
+		xfs_name_init(&name, SGI_ACL_FILE);
 		break;
 	case ACL_TYPE_DEFAULT:
-		ea_name = SGI_ACL_DEFAULT;
+		xfs_name_init(&name, SGI_ACL_DEFAULT);
 		break;
 	default:
 		BUG();
@@ -145,9 +145,8 @@ xfs_get_acl(struct inode *inode, int type)
 	 * go out to the disk.
 	 */
 	len = XFS_ACL_MAX_SIZE(ip->i_mount);
-	error = xfs_attr_get(ip, ea_name, strlen(ea_name),
-				(unsigned char **)&xfs_acl, &len,
-				ATTR_ALLOC | ATTR_ROOT);
+	error = xfs_attr_get(ip, &name, (unsigned char **)&xfs_acl, &len,
+			     ATTR_ALLOC | ATTR_ROOT);
 	if (error) {
 		/*
 		 * If the attribute doesn't exist make sure we have a negative
@@ -167,17 +166,17 @@ int
 __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 {
 	struct xfs_inode *ip = XFS_I(inode);
-	unsigned char *ea_name;
+	struct xfs_name name;
 	int error;
 
 	switch (type) {
 	case ACL_TYPE_ACCESS:
-		ea_name = SGI_ACL_FILE;
+		xfs_name_init(&name, SGI_ACL_FILE);
 		break;
 	case ACL_TYPE_DEFAULT:
 		if (!S_ISDIR(inode->i_mode))
 			return acl ? -EACCES : 0;
-		ea_name = SGI_ACL_DEFAULT;
+		xfs_name_init(&name, SGI_ACL_DEFAULT);
 		break;
 	default:
 		return -EINVAL;
@@ -197,17 +196,15 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		len -= sizeof(struct xfs_acl_entry) *
 			 (XFS_ACL_MAX_ENTRIES(ip->i_mount) - acl->a_count);
 
-		error = xfs_attr_set(ip, ea_name, strlen(ea_name),
-				     (unsigned char *)xfs_acl, len, ATTR_ROOT);
+		error = xfs_attr_set(ip, &name, (unsigned char *)xfs_acl, len,
+				     ATTR_ROOT);
 
 		kmem_free(xfs_acl);
 	} else {
 		/*
 		 * A NULL ACL argument means we want to remove the ACL.
 		 */
-		error = xfs_attr_remove(ip, ea_name,
-					strlen(ea_name),
-					ATTR_ROOT);
+		error = xfs_attr_remove(ip, &name, ATTR_ROOT);
 
 		/*
 		 * If the attribute didn't exist to start with that's fine.
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d42de92..28c07c9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -357,7 +357,9 @@ xfs_attrmulti_attr_get(
 {
 	unsigned char		*kbuf;
 	int			error = -EFAULT;
-	size_t			namelen;
+	struct xfs_name		xname;
+
+	xfs_name_init(&xname, name);
 
 	if (*len > XFS_XATTR_SIZE_MAX)
 		return -EINVAL;
@@ -365,9 +367,7 @@ xfs_attrmulti_attr_get(
 	if (!kbuf)
 		return -ENOMEM;
 
-	namelen = strlen(name);
-	error = xfs_attr_get(XFS_I(inode), name, namelen, &kbuf, (int *)len,
-			     flags);
+	error = xfs_attr_get(XFS_I(inode), &xname, &kbuf, (int *)len, flags);
 	if (error)
 		goto out_kfree;
 
@@ -389,7 +389,9 @@ xfs_attrmulti_attr_set(
 {
 	unsigned char		*kbuf;
 	int			error;
-	size_t			namelen;
+	struct xfs_name		xname;
+
+	xfs_name_init(&xname, name);
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
@@ -400,8 +402,7 @@ xfs_attrmulti_attr_set(
 	if (IS_ERR(kbuf))
 		return PTR_ERR(kbuf);
 
-	namelen = strlen(name);
-	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
+	error = xfs_attr_set(XFS_I(inode), &xname, kbuf, len, flags);
 	if (!error)
 		xfs_forget_acl(inode, name, flags);
 	kfree(kbuf);
@@ -415,12 +416,14 @@ xfs_attrmulti_attr_remove(
 	uint32_t		flags)
 {
 	int			error;
-	size_t			namelen;
+	struct xfs_name		xname;
+
+	xfs_name_init(&xname, name);
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
-	namelen = strlen(name);
-	error = xfs_attr_remove(XFS_I(inode), name, namelen, flags);
+
+	error = xfs_attr_remove(XFS_I(inode), &xname, flags);
 	if (!error)
 		xfs_forget_acl(inode, name, flags);
 	return error;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 81f2f93..e85bbf5 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -48,11 +48,11 @@ xfs_initxattrs(
 	const struct xattr	*xattr;
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error = 0;
+	struct xfs_name		name;
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
-		error = xfs_attr_set(ip, xattr->name,
-				     strlen(xattr->name),
-				     xattr->value, xattr->value_len,
+		xfs_name_init(&name, xattr->name);
+		error = xfs_attr_set(ip, &name, xattr->value, xattr->value_len,
 				     ATTR_SECURE);
 		if (error < 0)
 			break;
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index b0fedb5..74133a5 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -21,10 +21,12 @@ static int
 xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 		struct inode *inode, const char *name, void *value, size_t size)
 {
-	int xflags = handler->flags;
-	struct xfs_inode *ip = XFS_I(inode);
-	int error, asize = size;
-	size_t namelen = strlen(name);
+	int			xflags = handler->flags;
+	struct xfs_inode	*ip = XFS_I(inode);
+	int			error, asize = size;
+	struct xfs_name		xname;
+
+	xfs_name_init(&xname, name);
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
 	if (!size) {
@@ -32,8 +34,8 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 		value = NULL;
 	}
 
-	error = xfs_attr_get(ip, name, namelen, (unsigned char **)&value,
-			     &asize, xflags);
+	error = xfs_attr_get(ip, &xname, (unsigned char **)&value, &asize,
+			     xflags);
 	if (error)
 		return error;
 	return asize;
@@ -69,7 +71,9 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 	int			xflags = handler->flags;
 	struct xfs_inode	*ip = XFS_I(inode);
 	int			error;
-	size_t			namelen = strlen(name);
+	struct xfs_name		xname;
+
+	xfs_name_init(&xname, name);
 
 	/* Convert Linux syscall to XFS internal ATTR flags */
 	if (flags & XATTR_CREATE)
@@ -77,11 +81,11 @@ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *unused,
 	if (flags & XATTR_REPLACE)
 		xflags |= ATTR_REPLACE;
 
-	if (value)
-		error = xfs_attr_set(ip, name, namelen, (void *)value, size,
-				xflags);
-	else
-		error = xfs_attr_remove(ip, name, namelen, xflags);
+        if (value)
+               error = xfs_attr_set(ip, &xname, (void *)value, size, xflags);
+        else
+               error = xfs_attr_remove(ip, &xname, xflags);
+
 	if (!error)
 		xfs_forget_acl(inode, name, xflags);
 
-- 
2.7.4

