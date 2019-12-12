Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7689011CB77
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Dec 2019 11:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbfLLKzl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Dec 2019 05:55:41 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53374 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728777AbfLLKzk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:55:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/PR3/bgYKHLGmZjAHBi7eFflTHg1TqWMskEFriFn5Uo=; b=X539g7wuiMdxpX3fFezmqS+Fmd
        b7VV9rfkQBBVMgB3Lb/vUuPaswJ8x7p+87XqsQ17TowjxTgFLXNgE2xq94fT2zDqx4ocfHPHHDIoN
        jT6uGMNcw1gHft2XXin50bJ3DKPZ6wOm8Bku4zF3Gbt0I8nBumHDtwWTwC7SG4wURH5Xi619JHPJC
        w2jZ6GfXd2siomQC7YTtM/8oESM84li8NWPc/aL9AJTv/vdEgxIYddqDuzT77qVer0tuL+DLQwTSR
        vQv56i1uuh4ZJowaWtnv0kqUbDLt/hnuXCzaACAkF/6PbpFOllJYI/PzeHQVK3vHk7yYu8KcOFZQL
        nrvU8rmg==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifM8C-0002Wz-By; Thu, 12 Dec 2019 10:55:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 27/33] xfs: lift buffer allocation into xfs_ioc_attr_list
Date:   Thu, 12 Dec 2019 11:54:27 +0100
Message-Id: <20191212105433.1692-28-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212105433.1692-1-hch@lst.de>
References: <20191212105433.1692-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Lift the buffer allocation from the two callers into xfs_ioc_attr_list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c   | 39 ++++++++++++++++-----------------------
 fs/xfs/xfs_ioctl.h   |  2 +-
 fs/xfs/xfs_ioctl32.c | 22 +++++-----------------
 3 files changed, 22 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2cc53da070e7..f4b1aee0f362 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -353,13 +353,14 @@ xfs_ioc_attr_put_listent(
 int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
-	char				*buffer,
+	void __user			*ubuf,
 	int				bufsize,
 	int				flags,
 	struct attrlist_cursor_kern	*cursor)
 {
 	struct xfs_attr_list_context	context;
 	struct xfs_attrlist		*alist;
+	void				*buffer;
 	int				error;
 
 	if (bufsize < sizeof(struct xfs_attrlist) ||
@@ -381,11 +382,9 @@ xfs_ioc_attr_list(
 	    (cursor->hashval || cursor->blkno || cursor->offset))
 		return -EINVAL;
 
-	/*
-	 * Check for a properly aligned buffer.
-	 */
-	if (((long)buffer) & (sizeof(int)-1))
-		return -EFAULT;
+	buffer = kmem_zalloc_large(bufsize, 0);
+	if (!buffer)
+		return -ENOMEM;
 
 	/*
 	 * Initialize the output buffer.
@@ -406,7 +405,13 @@ xfs_ioc_attr_list(
 	alist->al_offset[0] = context.bufsize;
 
 	error = xfs_attr_list(&context);
-	ASSERT(error <= 0);
+	if (error)
+		goto out_free;
+
+	if (copy_to_user(ubuf, buffer, bufsize))
+		error = -EFAULT;
+out_free:
+	kmem_free(buffer);
 	return error;
 }
 
@@ -420,7 +425,6 @@ xfs_attrlist_by_handle(
 	struct xfs_fsop_attrlist_handlereq __user	*p = arg;
 	xfs_fsop_attrlist_handlereq_t al_hreq;
 	struct dentry		*dentry;
-	char			*kbuf;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -431,26 +435,15 @@ xfs_attrlist_by_handle(
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	kbuf = kmem_zalloc_large(al_hreq.buflen, 0);
-	if (!kbuf)
-		goto out_dput;
-
 	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
-	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
-					al_hreq.flags, cursor);
+	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), al_hreq.buffer,
+				  al_hreq.buflen, al_hreq.flags, cursor);
 	if (error)
-		goto out_kfree;
-
-	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t))) {
-		error = -EFAULT;
-		goto out_kfree;
-	}
+		goto out_dput;
 
-	if (copy_to_user(al_hreq.buffer, kbuf, al_hreq.buflen))
+	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t)))
 		error = -EFAULT;
 
-out_kfree:
-	kmem_free(kbuf);
 out_dput:
 	dput(dentry);
 	return error;
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index cb7b94c576a7..ec6448b259fb 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -39,7 +39,7 @@ xfs_readlink_by_handle(
 int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 		uint32_t opcode, void __user *uname, void __user *value,
 		uint32_t *len, uint32_t flags);
-int xfs_ioc_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
+int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf, int bufsize,
 	int flags, struct attrlist_cursor_kern *cursor);
 
 extern struct dentry *
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index c11d009a9319..79c9f3c64ce6 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -359,7 +359,6 @@ xfs_compat_attrlist_by_handle(
 	compat_xfs_fsop_attrlist_handlereq_t __user *p = arg;
 	compat_xfs_fsop_attrlist_handlereq_t al_hreq;
 	struct dentry		*dentry;
-	char			*kbuf;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -371,27 +370,16 @@ xfs_compat_attrlist_by_handle(
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	error = -ENOMEM;
-	kbuf = kmem_zalloc_large(al_hreq.buflen, 0);
-	if (!kbuf)
-		goto out_dput;
-
 	cursor = (attrlist_cursor_kern_t *)&al_hreq.pos;
-	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)), kbuf, al_hreq.buflen,
-					al_hreq.flags, cursor);
+	error = xfs_ioc_attr_list(XFS_I(d_inode(dentry)),
+			compat_ptr(al_hreq.buffer), al_hreq.buflen,
+			al_hreq.flags, cursor);
 	if (error)
-		goto out_kfree;
-
-	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t))) {
-		error = -EFAULT;
-		goto out_kfree;
-	}
+		goto out_dput;
 
-	if (copy_to_user(compat_ptr(al_hreq.buffer), kbuf, al_hreq.buflen))
+	if (copy_to_user(&p->pos, cursor, sizeof(attrlist_cursor_kern_t)))
 		error = -EFAULT;
 
-out_kfree:
-	kmem_free(kbuf);
 out_dput:
 	dput(dentry);
 	return error;
-- 
2.20.1

