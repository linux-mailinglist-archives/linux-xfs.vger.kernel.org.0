Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C27D14CF1F
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jan 2020 18:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgA2REF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jan 2020 12:04:05 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46730 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgA2REF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:04:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8PBY+ZdfvsaitXVgNNbCgTEqwwxB5uFi4e0s43Re9XY=; b=c6JwZSHh9LcCWD8RG52ptutNm/
        KFNxBZSTU6bWKc1aWRFlXLN+5MYL0942PrUbCTIO+UO6naiSt8zS5RxiJXdeyWRRuAza2hWpt53FL
        TeIKj2/E3LJ+g6MBjwX31cb88i8O6CqMaEbE5jFJLKbpA1nyeQuThdpbEl3h8bU6kAofee5Qyi7ME
        PHep+60BAbLymFkXu7mFaeDlbnMaDvVBMWrLWvJilvq5vXax6xH8CcUI+utAK7s54vpJq0NSqSfgK
        ETHzlipFZE9uUKY8xt8gvTs5vHlNaWHkLnf7AN77HkefjYBif0R5oFuke0Ah78gGFe04nfHNpqTwW
        RaO0BwaQ==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwql3-0006y5-53; Wed, 29 Jan 2020 17:04:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 21/30] xfs: move the legacy xfs_attr_list to xfs_ioctl.c
Date:   Wed, 29 Jan 2020 18:03:00 +0100
Message-Id: <20200129170310.51370-22-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129170310.51370-1-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The old xfs_attr_list code is only used by the attrlist by handle
ioctl.  Move it to xfs_ioctl.c with its user.  Also move the
attrlist and attrlist_ent structure to xfs_fs.h, as they are exposed
user ABIs.  They are used through libattr headers with the same name
by at least xfsdump.  Also document this relation so that it doesn't
require a research project to figure out.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.h |  23 --------
 fs/xfs/libxfs/xfs_fs.h   |  26 +++++++++
 fs/xfs/xfs_attr_list.c   | 113 ---------------------------------------
 fs/xfs/xfs_ioctl.c       | 110 ++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_ioctl.h       |  12 +++--
 fs/xfs/xfs_ioctl32.c     |   4 +-
 6 files changed, 144 insertions(+), 144 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 31c0ffde4f59..0e3c213f78ce 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -48,27 +48,6 @@ struct xfs_attr_list_context;
  */
 #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
 
-/*
- * Define how lists of attribute names are returned to the user from
- * the attr_list() call.  A large, 32bit aligned, buffer is passed in
- * along with its size.  We put an array of offsets at the top that each
- * reference an attrlist_ent_t and pack the attrlist_ent_t's at the bottom.
- */
-typedef struct attrlist {
-	__s32	al_count;	/* number of entries in attrlist */
-	__s32	al_more;	/* T/F: more attrs (do call again) */
-	__s32	al_offset[1];	/* byte offsets of attrs [var-sized] */
-} attrlist_t;
-
-/*
- * Show the interesting info about one attribute.  This is what the
- * al_offset[i] entry points to.
- */
-typedef struct attrlist_ent {	/* data from attr_list() */
-	__u32	a_valuelen;	/* number bytes in value of attr */
-	char	a_name[1];	/* attr name (NULL terminated) */
-} attrlist_ent_t;
-
 /*
  * Kernel-internal version of the attrlist cursor.
  */
@@ -131,8 +110,6 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
-int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
-		  int flags, struct attrlist_cursor_kern *cursor);
 bool xfs_attr_namecheck(const void *name, size_t length);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index ef95ca07d084..2c2b6e2b58f4 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -572,6 +572,32 @@ typedef struct xfs_attrlist_cursor {
 	__u32		opaque[4];
 } xfs_attrlist_cursor_t;
 
+/*
+ * Define how lists of attribute names are returned to the user from
+ * the attr_list() call.  A large, 32bit aligned, buffer is passed in
+ * along with its size.  We put an array of offsets at the top that each
+ * reference an attrlist_ent_t and pack the attrlist_ent_t's at the bottom.
+ *
+ * NOTE: struct xfs_attrlist must match struct attrlist defined in libattr.
+ */
+struct xfs_attrlist {
+	__s32	al_count;	/* number of entries in attrlist */
+	__s32	al_more;	/* T/F: more attrs (do call again) */
+	__s32	al_offset[1];	/* byte offsets of attrs [var-sized] */
+};
+
+/*
+ * Show the interesting info about one attribute.  This is what the
+ * al_offset[i] entry points to.
+ *
+ * NOTE: struct xfs_attrlist_ent must match struct attrlist_ent defined in
+ * libattr.
+ */
+struct xfs_attrlist_ent {	/* data from attr_list() */
+	__u32	a_valuelen;	/* number bytes in value of attr */
+	char	a_name[1];	/* attr name (NULL terminated) */
+};
+
 typedef struct xfs_fsop_attrlist_handlereq {
 	struct xfs_fsop_handlereq	hreq; /* handle interface structure */
 	struct xfs_attrlist_cursor	pos; /* opaque cookie, list offset */
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index f1ca8ef8be22..369ce1d3dd45 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -544,116 +544,3 @@ xfs_attr_list_int(
 	xfs_iunlock(dp, lock_mode);
 	return error;
 }
-
-/*
- * Format an attribute and copy it out to the user's buffer.
- * Take care to check values and protect against them changing later,
- * we may be reading them directly out of a user buffer.
- */
-STATIC void
-xfs_attr_put_listent(
-	struct xfs_attr_list_context	*context,
-	int			flags,
-	unsigned char		*name,
-	int			namelen,
-	int			valuelen)
-{
-	struct attrlist		*alist = context->buffer;
-	struct attrlist_ent	*aep;
-	int			arraytop;
-
-	ASSERT(!context->seen_enough);
-	ASSERT(context->count >= 0);
-	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
-	ASSERT(context->firstu >= sizeof(*alist));
-	ASSERT(context->firstu <= context->bufsize);
-
-	/*
-	 * Only list entries in the right namespace.
-	 */
-	if (((context->flags & ATTR_SECURE) == 0) !=
-	    ((flags & XFS_ATTR_SECURE) == 0))
-		return;
-	if (((context->flags & ATTR_ROOT) == 0) !=
-	    ((flags & XFS_ATTR_ROOT) == 0))
-		return;
-
-	arraytop = sizeof(*alist) +
-			context->count * sizeof(alist->al_offset[0]);
-
-	/* decrement by the actual bytes used by the attr */
-	context->firstu -= round_up(offsetof(struct attrlist_ent, a_name) +
-			namelen + 1, sizeof(uint32_t));
-	if (context->firstu < arraytop) {
-		trace_xfs_attr_list_full(context);
-		alist->al_more = 1;
-		context->seen_enough = 1;
-		return;
-	}
-
-	aep = context->buffer + context->firstu;
-	aep->a_valuelen = valuelen;
-	memcpy(aep->a_name, name, namelen);
-	aep->a_name[namelen] = 0;
-	alist->al_offset[context->count++] = context->firstu;
-	alist->al_count = context->count;
-	trace_xfs_attr_list_add(context);
-	return;
-}
-
-/*
- * Generate a list of extended attribute names and optionally
- * also value lengths.  Positive return value follows the XFS
- * convention of being an error, zero or negative return code
- * is the length of the buffer returned (negated), indicating
- * success.
- */
-int
-xfs_attr_list(
-	struct xfs_inode		*dp,
-	char				*buffer,
-	int				bufsize,
-	int				flags,
-	struct attrlist_cursor_kern	*cursor)
-{
-	struct xfs_attr_list_context	context;
-	struct attrlist			*alist;
-	int				error;
-
-	/*
-	 * Validate the cursor.
-	 */
-	if (cursor->pad1 || cursor->pad2)
-		return -EINVAL;
-	if ((cursor->initted == 0) &&
-	    (cursor->hashval || cursor->blkno || cursor->offset))
-		return -EINVAL;
-
-	/*
-	 * Check for a properly aligned buffer.
-	 */
-	if (((long)buffer) & (sizeof(int)-1))
-		return -EFAULT;
-
-	/*
-	 * Initialize the output buffer.
-	 */
-	memset(&context, 0, sizeof(context));
-	context.dp = dp;
-	context.cursor = cursor;
-	context.resynch = 1;
-	context.flags = flags;
-	context.buffer = buffer;
-	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
-	context.firstu = context.bufsize;
-	context.put_listent = xfs_attr_put_listent;
-
-	alist = context.buffer;
-	alist->al_count = 0;
-	alist->al_more = 0;
-	alist->al_offset[0] = context.bufsize;
-
-	error = xfs_attr_list_int(&context);
-	ASSERT(error <= 0);
-	return error;
-}
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index dd1cb8c50518..47c39895977b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -35,6 +35,7 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
+#include "xfs_da_format.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -292,6 +293,111 @@ xfs_readlink_by_handle(
 	return error;
 }
 
+/*
+ * Format an attribute and copy it out to the user's buffer.
+ * Take care to check values and protect against them changing later,
+ * we may be reading them directly out of a user buffer.
+ */
+static void
+xfs_ioc_attr_put_listent(
+	struct xfs_attr_list_context *context,
+	int			flags,
+	unsigned char		*name,
+	int			namelen,
+	int			valuelen)
+{
+	struct xfs_attrlist	*alist = context->buffer;
+	struct xfs_attrlist_ent	*aep;
+	int			arraytop;
+
+	ASSERT(!context->seen_enough);
+	ASSERT(context->count >= 0);
+	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
+	ASSERT(context->firstu >= sizeof(*alist));
+	ASSERT(context->firstu <= context->bufsize);
+
+	/*
+	 * Only list entries in the right namespace.
+	 */
+	if (((context->flags & ATTR_SECURE) == 0) !=
+	    ((flags & XFS_ATTR_SECURE) == 0))
+		return;
+	if (((context->flags & ATTR_ROOT) == 0) !=
+	    ((flags & XFS_ATTR_ROOT) == 0))
+		return;
+
+	arraytop = sizeof(*alist) +
+			context->count * sizeof(alist->al_offset[0]);
+
+	/* decrement by the actual bytes used by the attr */
+	context->firstu -= round_up(offsetof(struct xfs_attrlist_ent, a_name) +
+			namelen + 1, sizeof(uint32_t));
+	if (context->firstu < arraytop) {
+		trace_xfs_attr_list_full(context);
+		alist->al_more = 1;
+		context->seen_enough = 1;
+		return;
+	}
+
+	aep = context->buffer + context->firstu;
+	aep->a_valuelen = valuelen;
+	memcpy(aep->a_name, name, namelen);
+	aep->a_name[namelen] = 0;
+	alist->al_offset[context->count++] = context->firstu;
+	alist->al_count = context->count;
+	trace_xfs_attr_list_add(context);
+}
+
+int
+xfs_ioc_attr_list(
+	struct xfs_inode		*dp,
+	char				*buffer,
+	int				bufsize,
+	int				flags,
+	struct attrlist_cursor_kern	*cursor)
+{
+	struct xfs_attr_list_context	context;
+	struct xfs_attrlist		*alist;
+	int				error;
+
+	/*
+	 * Validate the cursor.
+	 */
+	if (cursor->pad1 || cursor->pad2)
+		return -EINVAL;
+	if ((cursor->initted == 0) &&
+	    (cursor->hashval || cursor->blkno || cursor->offset))
+		return -EINVAL;
+
+	/*
+	 * Check for a properly aligned buffer.
+	 */
+	if (((long)buffer) & (sizeof(int)-1))
+		return -EFAULT;
+
+	/*
+	 * Initialize the output buffer.
+	 */
+	memset(&context, 0, sizeof(context));
+	context.dp = dp;
+	context.cursor = cursor;
+	context.resynch = 1;
+	context.flags = flags;
+	context.buffer = buffer;
+	context.bufsize = (bufsize & ~(sizeof(int)-1));  /* align */
+	context.firstu = context.bufsize;
+	context.put_listent = xfs_ioc_attr_put_listent;
+
+	alist = context.buffer;
+	alist->al_count = 0;
+	alist->al_more = 0;
+	alist->al_offset[0] = context.bufsize;
+
+	error = xfs_attr_list_int(&context);
+	ASSERT(error <= 0);
+	return error;
+}
+
 STATIC int
 xfs_attrlist_by_handle(
 	struct file		*parfilp,
@@ -308,7 +414,7 @@ xfs_attrlist_by_handle(
 		return -EPERM;
 	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
 		return -EFAULT;
-	if (al_hreq.buflen < sizeof(struct attrlist) ||
+	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
 	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
 		return -EINVAL;
 
@@ -329,7 +435,7 @@ xfs_attrlist_by_handle(
 		goto out_dput;
 
 	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
-	error = xfs_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
+	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
 					al_hreq.flags, cursor);
 	if (error)
 		goto out_kfree;
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index bb50cb3dc61f..cb7b94c576a7 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -6,6 +6,12 @@
 #ifndef __XFS_IOCTL_H__
 #define __XFS_IOCTL_H__
 
+struct attrlist_cursor_kern;
+struct xfs_bstat;
+struct xfs_ibulk;
+struct xfs_inogrp;
+
+
 extern int
 xfs_ioc_space(
 	struct file		*filp,
@@ -33,6 +39,8 @@ xfs_readlink_by_handle(
 int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 		uint32_t opcode, void __user *uname, void __user *value,
 		uint32_t *len, uint32_t flags);
+int xfs_ioc_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
+	int flags, struct attrlist_cursor_kern *cursor);
 
 extern struct dentry *
 xfs_handle_to_dentry(
@@ -52,10 +60,6 @@ xfs_file_compat_ioctl(
 	unsigned int		cmd,
 	unsigned long		arg);
 
-struct xfs_ibulk;
-struct xfs_bstat;
-struct xfs_inogrp;
-
 int xfs_fsbulkstat_one_fmt(struct xfs_ibulk *breq,
 			   const struct xfs_bulkstat *bstat);
 int xfs_fsinumbers_fmt(struct xfs_ibulk *breq, const struct xfs_inumbers *igrp);
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index e1daf095c585..10ea0222954c 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -366,7 +366,7 @@ xfs_compat_attrlist_by_handle(
 	if (copy_from_user(&al_hreq, arg,
 			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
 		return -EFAULT;
-	if (al_hreq.buflen < sizeof(struct attrlist) ||
+	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
 	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
 		return -EINVAL;
 
@@ -388,7 +388,7 @@ xfs_compat_attrlist_by_handle(
 		goto out_dput;
 
 	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
-	error = xfs_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
+	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
 					al_hreq.flags, cursor);
 	if (error)
 		goto out_kfree;
-- 
2.24.1

