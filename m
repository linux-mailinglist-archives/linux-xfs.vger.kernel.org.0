Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC27F14CF18
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jan 2020 18:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgA2RDs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jan 2020 12:03:48 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46658 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgA2RDs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:03:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0woTC2NbUwkV4MiwSjYf+0toMfdw6AY9FC75AJH0Lwc=; b=PlLW9UX0g/AD8o98kDAsL2Yuhh
        /JfV7tCcGZ+WzcA+Sky2OpFEB5isvLic72BpgLWMD9wM3TBBlfBhFqTRAfVVo5UUkwBJQ3nxjkkla
        YQ9Qjo8gQmkJjc2y9VozL14ogSnBW0r9yQF4g5z0mivz/rXumXW0amZCHeTbhUFVernntkvWlz7/I
        6FbOtTWf1h3RksLbld4ZCpj+5waGlnOXyfW61TOdzQYoF7+VifrUdDDl8LvLiwIoeZ0pR8utRw0yl
        BOzNWT7SQjIWnr0MzWHLnzoBCtsdI9hC0wTIfAURscdeKfxbfD00NxUmuTyevj7v5CyRfUDy0M2pb
        0tPYJrCA==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwqkl-0006v1-Oh; Wed, 29 Jan 2020 17:03:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 14/30] xfs: remove ATTR_KERNOVAL
Date:   Wed, 29 Jan 2020 18:02:53 +0100
Message-Id: <20200129170310.51370-15-hch@lst.de>
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

We can just pass down the Linux convention of a zero valuelen to just
query for the existance of an attribute to the low-level code instead.
The use in the legacy xfs_attr_list code only used by the ioctl
interface was already dead code, as the callers check that the flag
is not present.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        |  8 ++++----
 fs/xfs/libxfs/xfs_attr.h        |  4 +---
 fs/xfs/libxfs/xfs_attr_leaf.c   | 14 +++++++-------
 fs/xfs/libxfs/xfs_attr_remote.c |  2 +-
 fs/xfs/xfs_attr_list.c          |  3 ---
 fs/xfs/xfs_xattr.c              |  4 ----
 6 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fd095e3d4a9a..469417786bfc 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -94,9 +94,9 @@ xfs_attr_get_ilocked(
 /*
  * Retrieve an extended attribute by name, and its value if requested.
  *
- * If ATTR_KERNOVAL is set in args->flags, then the caller does not want the
- * value, just an indication whether the attribute exists and the size of the
- * value if it exists. The size is returned in args.valuelen.
+ * If args->valuelen is zero, then the caller does not want the value, just an
+ * indication whether the attribute exists and the size of the value if it
+ * exists. The size is returned in args.valuelen.
  *
  * If the attribute is found, but exceeds the size limit set by the caller in
  * args->valuelen, return -ERANGE with the size of the attribute that was found
@@ -115,7 +115,7 @@ xfs_attr_get(
 	uint			lock_mode;
 	int			error;
 
-	ASSERT((args->flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || args->value);
+	ASSERT((args->flags & ATTR_ALLOC) || !args->valuelen || args->value);
 
 	XFS_STATS_INC(args->dp->i_mount, xs_attr_get);
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index b8c4ed27f626..fe064cd81747 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -34,12 +34,11 @@ struct xfs_attr_list_context;
 #define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
 
 #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
-#define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
 
 #define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
 
 #define ATTR_KERNEL_FLAGS \
-	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_ALLOC)
+	(ATTR_KERNOTIME | ATTR_ALLOC)
 
 #define XFS_ATTR_FLAGS \
 	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
@@ -49,7 +48,6 @@ struct xfs_attr_list_context;
 	{ ATTR_CREATE,		"CREATE" }, \
 	{ ATTR_REPLACE,		"REPLACE" }, \
 	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
-	{ ATTR_KERNOVAL,	"KERNOVAL" }, \
 	{ ATTR_ALLOC,		"ALLOC" }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index fed537a4353d..5e700dfc48a9 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -464,7 +464,7 @@ xfs_attr_copy_value(
 	/*
 	 * No copy if all we have to do is get the length
 	 */
-	if (args->flags & ATTR_KERNOVAL) {
+	if (!args->valuelen) {
 		args->valuelen = valuelen;
 		return 0;
 	}
@@ -830,9 +830,9 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 /*
  * Retrieve the attribute value and length.
  *
- * If ATTR_KERNOVAL is specified, only the length needs to be returned.
- * Unlike a lookup, we only return an error if the attribute does not
- * exist or we can't retrieve the value.
+ * If args->valuelen is zero, only the length needs to be returned.  Unlike a
+ * lookup, we only return an error if the attribute does not exist or we can't
+ * retrieve the value.
  */
 int
 xfs_attr_shortform_getvalue(
@@ -2444,9 +2444,9 @@ xfs_attr3_leaf_lookup_int(
  * Get the value associated with an attribute name from a leaf attribute
  * list structure.
  *
- * If ATTR_KERNOVAL is specified, only the length needs to be returned.
- * Unlike a lookup, we only return an error if the attribute does not
- * exist or we can't retrieve the value.
+ * If args->valuelen is zero, only the length needs to be returned.  Unlike a
+ * lookup, we only return an error if the attribute does not exist or we can't
+ * retrieve the value.
  */
 int
 xfs_attr3_leaf_getvalue(
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index a266d05df146..023ac8b85b4a 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -397,7 +397,7 @@ xfs_attr_rmtval_get(
 
 	trace_xfs_attr_rmtval_get(args);
 
-	ASSERT(!(args->flags & ATTR_KERNOVAL));
+	ASSERT(args->valuelen != 0);
 	ASSERT(args->rmtvaluelen == args->valuelen);
 
 	valuelen = args->rmtvaluelen;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 5139ef983cd6..ac8dc64447d6 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -568,7 +568,6 @@ xfs_attr_put_listent(
 	int arraytop;
 
 	ASSERT(!context->seen_enough);
-	ASSERT(!(context->flags & ATTR_KERNOVAL));
 	ASSERT(context->count >= 0);
 	ASSERT(context->count < (ATTR_MAX_VALUELEN/8));
 	ASSERT(context->firstu >= sizeof(*alist));
@@ -637,8 +636,6 @@ xfs_attr_list(
 	 */
 	if (((long)buffer) & (sizeof(int)-1))
 		return -EFAULT;
-	if (flags & ATTR_KERNOVAL)
-		bufsize = 0;
 
 	/*
 	 * Initialize the output buffer.
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index b3ce5e8777f9..c9c44f8aebed 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -31,10 +31,6 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 	};
 	int			error;
 
-	/* Convert Linux syscall to XFS internal ATTR flags */
-	if (!size)
-		args.flags |= ATTR_KERNOVAL;
-
 	error = xfs_attr_get(&args);
 	if (error)
 		return error;
-- 
2.24.1

