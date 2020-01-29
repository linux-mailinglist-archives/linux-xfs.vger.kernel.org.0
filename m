Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4DA14CF28
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jan 2020 18:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgA2RE3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jan 2020 12:04:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46816 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgA2RE3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:04:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=r33mN/tdMJZELAW8D8mp/mVhbOWGubBKHf6GfR18B0s=; b=glfm7/EzLOyDOAyLU01lfAV0YP
        xc9jMGekYPqTX2zr3dsx+rs+EJ8eMqhvWmN3Gs2WsT0nIKiVC9arzbFQ1yQM2+rNnhtgpG1elBIyQ
        qcH1uk5D4jBNST9xeHMgDlocBoMnLGBIs+fD2yTvSDQoMFVyrf8hhsoPTLhxBq+cq5UKymqkbyGag
        wle5f8lpC+6pLdh38H4flQXfYK5LFrHHnoLLMqNuGdn0Z22qfnu2jv9ZOA0TbApMXeIOpmQfjPpw/
        ssFmCR31bG36SV/Uthk7n1tH8Jocy18hbDVN0YlzZOBGJ689AG3h5+htipcbCKwCQ+GyyAIWahmVA
        UFv2ED+Q==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwqlQ-00071r-DA; Wed, 29 Jan 2020 17:04:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 30/30] xfs: embedded the attrlist cursor into struct xfs_attr_list_context
Date:   Wed, 29 Jan 2020 18:03:09 +0100
Message-Id: <20200129170310.51370-31-hch@lst.de>
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

The attrlist cursor only exists as part of an attr list context, so
embedd the structure instead of pointing to it.  Also give it a proper
xfs_ prefix and remove the obsolete typedef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h      |  6 +++---
 fs/xfs/libxfs/xfs_attr_leaf.h |  1 -
 fs/xfs/scrub/attr.c           |  2 --
 fs/xfs/xfs_attr_list.c        | 19 ++++++-------------
 fs/xfs/xfs_ioctl.c            | 16 +++++++---------
 fs/xfs/xfs_ioctl.h            |  1 -
 fs/xfs/xfs_trace.h            | 12 ++++++------
 fs/xfs/xfs_xattr.c            |  2 --
 8 files changed, 22 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 7a3525dff411..861c81f9bb91 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -31,14 +31,14 @@ struct xfs_attr_list_context;
 /*
  * Kernel-internal version of the attrlist cursor.
  */
-typedef struct attrlist_cursor_kern {
+struct xfs_attrlist_cursor_kern {
 	__u32	hashval;	/* hash value of next entry to add */
 	__u32	blkno;		/* block containing entry (suggestion) */
 	__u32	offset;		/* offset in list of equal-hashvals */
 	__u16	pad1;		/* padding to match user-level */
 	__u8	pad2;		/* padding to match user-level */
 	__u8	initted;	/* T/F: cursor has been initialized */
-} attrlist_cursor_kern_t;
+};
 
 
 /*========================================================================
@@ -53,7 +53,7 @@ typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
 struct xfs_attr_list_context {
 	struct xfs_trans	*tp;
 	struct xfs_inode	*dp;		/* inode */
-	struct attrlist_cursor_kern *cursor;	/* position in list */
+	struct xfs_attrlist_cursor_kern cursor;	/* position in list */
 	void			*buffer;	/* output buffer */
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 73615b1dd1a8..6dd2d937a42a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -8,7 +8,6 @@
 #define	__XFS_ATTR_LEAF_H__
 
 struct attrlist;
-struct attrlist_cursor_kern;
 struct xfs_attr_list_context;
 struct xfs_da_args;
 struct xfs_da_state;
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index d84237af5455..6dd3f5f78251 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -471,7 +471,6 @@ xchk_xattr(
 	struct xfs_scrub		*sc)
 {
 	struct xchk_xattr		sx;
-	struct attrlist_cursor_kern	cursor = { 0 };
 	xfs_dablk_t			last_checked = -1U;
 	int				error = 0;
 
@@ -490,7 +489,6 @@ xchk_xattr(
 
 	/* Check that every attr key can also be looked up by hash. */
 	sx.context.dp = sc->ip;
-	sx.context.cursor = &cursor;
 	sx.context.resynch = 1;
 	sx.context.put_listent = xchk_xattr_listent;
 	sx.context.tp = sc->tp;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index ea79219859a0..6af71edaa30e 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -52,24 +52,19 @@ static int
 xfs_attr_shortform_list(
 	struct xfs_attr_list_context	*context)
 {
-	struct attrlist_cursor_kern	*cursor;
+	struct xfs_attrlist_cursor_kern	*cursor = &context->cursor;
+	struct xfs_inode		*dp = context->dp;
 	struct xfs_attr_sf_sort		*sbuf, *sbp;
 	struct xfs_attr_shortform	*sf;
 	struct xfs_attr_sf_entry	*sfe;
-	struct xfs_inode		*dp;
 	int				sbsize, nsbuf, count, i;
 	int				error = 0;
 
-	ASSERT(context != NULL);
-	dp = context->dp;
-	ASSERT(dp != NULL);
 	ASSERT(dp->i_afp != NULL);
 	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
 		return 0;
-	cursor = context->cursor;
-	ASSERT(cursor != NULL);
 
 	trace_xfs_attr_list_sf(context);
 
@@ -205,7 +200,7 @@ xfs_attr_shortform_list(
 STATIC int
 xfs_attr_node_list_lookup(
 	struct xfs_attr_list_context	*context,
-	struct attrlist_cursor_kern	*cursor,
+	struct xfs_attrlist_cursor_kern	*cursor,
 	struct xfs_buf			**pbp)
 {
 	struct xfs_da3_icnode_hdr	nodehdr;
@@ -288,8 +283,8 @@ STATIC int
 xfs_attr_node_list(
 	struct xfs_attr_list_context	*context)
 {
+	struct xfs_attrlist_cursor_kern	*cursor = &context->cursor;
 	struct xfs_attr3_icleaf_hdr	leafhdr;
-	struct attrlist_cursor_kern	*cursor;
 	struct xfs_attr_leafblock	*leaf;
 	struct xfs_da_intnode		*node;
 	struct xfs_buf			*bp;
@@ -299,7 +294,6 @@ xfs_attr_node_list(
 
 	trace_xfs_attr_node_list(context);
 
-	cursor = context->cursor;
 	cursor->initted = 1;
 
 	/*
@@ -394,7 +388,7 @@ xfs_attr3_leaf_list_int(
 	struct xfs_buf			*bp,
 	struct xfs_attr_list_context	*context)
 {
-	struct attrlist_cursor_kern	*cursor;
+	struct xfs_attrlist_cursor_kern	*cursor = &context->cursor;
 	struct xfs_attr_leafblock	*leaf;
 	struct xfs_attr3_icleaf_hdr	ichdr;
 	struct xfs_attr_leaf_entry	*entries;
@@ -408,7 +402,6 @@ xfs_attr3_leaf_list_int(
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
 
-	cursor = context->cursor;
 	cursor->initted = 1;
 
 	/*
@@ -496,7 +489,7 @@ xfs_attr_leaf_list(
 
 	trace_xfs_attr_leaf_list(context);
 
-	context->cursor->blkno = 0;
+	context->cursor.blkno = 0;
 	error = xfs_attr3_leaf_read(context->tp, context->dp, 0, &bp);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d2318857497b..2e8e86d5c01c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -374,8 +374,7 @@ xfs_ioc_attr_list(
 	int				flags,
 	struct xfs_attrlist_cursor __user *ucursor)
 {
-	struct xfs_attr_list_context	context;
-	struct attrlist_cursor_kern	cursor;
+	struct xfs_attr_list_context	context = { 0 };
 	struct xfs_attrlist		*alist;
 	void				*buffer;
 	int				error;
@@ -395,12 +394,13 @@ xfs_ioc_attr_list(
 	/*
 	 * Validate the cursor.
 	 */
-	if (copy_from_user(&cursor, ucursor, sizeof(cursor)))
+	if (copy_from_user(&context.cursor, ucursor, sizeof(context.cursor)))
 		return -EFAULT;
-	if (cursor.pad1 || cursor.pad2)
+	if (context.cursor.pad1 || context.cursor.pad2)
 		return -EINVAL;
-	if ((cursor.initted == 0) &&
-	    (cursor.hashval || cursor.blkno || cursor.offset))
+	if (!context.cursor.initted &&
+	    (context.cursor.hashval || context.cursor.blkno ||
+	     context.cursor.offset))
 		return -EINVAL;
 
 	buffer = kmem_zalloc_large(bufsize, 0);
@@ -410,9 +410,7 @@ xfs_ioc_attr_list(
 	/*
 	 * Initialize the output buffer.
 	 */
-	memset(&context, 0, sizeof(context));
 	context.dp = dp;
-	context.cursor = &cursor;
 	context.resynch = 1;
 	context.attr_namespace = xfs_attr_namespace(flags);
 	context.buffer = buffer;
@@ -430,7 +428,7 @@ xfs_ioc_attr_list(
 		goto out_free;
 
 	if (copy_to_user(ubuf, buffer, bufsize) ||
-	    copy_to_user(ucursor, &cursor, sizeof(cursor)))
+	    copy_to_user(ucursor, &context.cursor, sizeof(context.cursor)))
 		error = -EFAULT;
 out_free:
 	kmem_free(buffer);
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index d6e8000ad825..bab6a5a92407 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -6,7 +6,6 @@
 #ifndef __XFS_IOCTL_H__
 #define __XFS_IOCTL_H__
 
-struct attrlist_cursor_kern;
 struct xfs_bstat;
 struct xfs_ibulk;
 struct xfs_inogrp;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a064b1523fa5..f886c0a5dbe1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -59,9 +59,9 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_fast_assign(
 		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
 		__entry->ino = ctx->dp->i_ino;
-		__entry->hashval = ctx->cursor->hashval;
-		__entry->blkno = ctx->cursor->blkno;
-		__entry->offset = ctx->cursor->offset;
+		__entry->hashval = ctx->cursor.hashval;
+		__entry->blkno = ctx->cursor.blkno;
+		__entry->offset = ctx->cursor.offset;
 		__entry->buffer = ctx->buffer;
 		__entry->bufsize = ctx->bufsize;
 		__entry->count = ctx->count;
@@ -186,9 +186,9 @@ TRACE_EVENT(xfs_attr_list_node_descend,
 	TP_fast_assign(
 		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
 		__entry->ino = ctx->dp->i_ino;
-		__entry->hashval = ctx->cursor->hashval;
-		__entry->blkno = ctx->cursor->blkno;
-		__entry->offset = ctx->cursor->offset;
+		__entry->hashval = ctx->cursor.hashval;
+		__entry->blkno = ctx->cursor.blkno;
+		__entry->offset = ctx->cursor.offset;
 		__entry->buffer = ctx->buffer;
 		__entry->bufsize = ctx->bufsize;
 		__entry->count = ctx->count;
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 1d2c8615b335..b4e740a6b372 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -188,7 +188,6 @@ xfs_vn_listxattr(
 	size_t		size)
 {
 	struct xfs_attr_list_context context;
-	struct attrlist_cursor_kern cursor = { 0 };
 	struct inode	*inode = d_inode(dentry);
 	int		error;
 
@@ -197,7 +196,6 @@ xfs_vn_listxattr(
 	 */
 	memset(&context, 0, sizeof(context));
 	context.dp = XFS_I(inode);
-	context.cursor = &cursor;
 	context.resynch = 1;
 	context.buffer = size ? data : NULL;
 	context.bufsize = size;
-- 
2.24.1

