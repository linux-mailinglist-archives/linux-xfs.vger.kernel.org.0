Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDDD13A2B6
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jan 2020 09:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgANIQS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jan 2020 03:16:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42294 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgANIQR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 03:16:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HTrF1h/XwM5DdH1ju19/35T9rIq6bKtb2cePSBfhhKU=; b=sTSauKG27mBdd5R1EG6bokUkeK
        eKJUyWgIJNCnm4GMkSecPdxUD0hAgcsYc2WPGmY+bekLo1YypzYmVho/svfBy+xk3loiUtkIoUtaq
        yOmvyx/oCfoqbz7SRymtl7FmisDRLbWxatV9UlAQM/qvQkhSmpdy0BhnlEe3MGv0M+YZ4LefdtWeG
        nBYJ20wl/c5fjJIkYhb5OStRQ02QBZBcPk1AwfNroqi8stwkFOdhy4hLVdXM0KESmhPqRMDQyeMw4
        ML0IIXDYgM8tuS1sLRDgl+/YmPD1vXThxmfxUCcerNT+LhzYfgW37/+l24kqzjUuxSObwlPJK1upC
        eprNxDEQ==;
Received: from [2001:4bb8:18c:4f54:fcbb:a92b:61e1:719] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irHN3-000744-AO; Tue, 14 Jan 2020 08:16:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 21/29] xfs: rename xfs_attr_list_int to xfs_attr_list
Date:   Tue, 14 Jan 2020 09:10:43 +0100
Message-Id: <20200114081051.297488-22-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114081051.297488-1-hch@lst.de>
References: <20200114081051.297488-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The version taking the context structure is the main interface to list
attributes, so drop the _int postfix.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.h | 4 ++--
 fs/xfs/scrub/attr.c      | 4 ++--
 fs/xfs/xfs_attr_list.c   | 6 +++---
 fs/xfs/xfs_ioctl.c       | 2 +-
 fs/xfs/xfs_xattr.c       | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0e3c213f78ce..8d42f5782ff7 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -102,8 +102,8 @@ struct xfs_attr_list_context {
  * Overall external interface routines.
  */
 int xfs_attr_inactive(struct xfs_inode *dp);
-int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
-int xfs_attr_list_int(struct xfs_attr_list_context *);
+int xfs_attr_list_ilocked(struct xfs_attr_list_context *);
+int xfs_attr_list(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 05537627211d..9e336d797616 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -98,7 +98,7 @@ struct xchk_xattr {
 /*
  * Check that an extended attribute key can be looked up by hash.
  *
- * We use the XFS attribute list iterator (i.e. xfs_attr_list_int_ilocked)
+ * We use the XFS attribute list iterator (i.e. xfs_attr_list_ilocked)
  * to call this function for every attribute key in an inode.  Once
  * we're here, we load the attribute value to see if any errors happen,
  * or if we get more or less data than we expected.
@@ -516,7 +516,7 @@ xchk_xattr(
 	 * iteration, which doesn't really follow the usual buffer
 	 * locking order.
 	 */
-	error = xfs_attr_list_int_ilocked(&sx.context);
+	error = xfs_attr_list_ilocked(&sx.context);
 	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
 		goto out;
 
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 369ce1d3dd45..ea79219859a0 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -507,7 +507,7 @@ xfs_attr_leaf_list(
 }
 
 int
-xfs_attr_list_int_ilocked(
+xfs_attr_list_ilocked(
 	struct xfs_attr_list_context	*context)
 {
 	struct xfs_inode		*dp = context->dp;
@@ -527,7 +527,7 @@ xfs_attr_list_int_ilocked(
 }
 
 int
-xfs_attr_list_int(
+xfs_attr_list(
 	struct xfs_attr_list_context	*context)
 {
 	struct xfs_inode		*dp = context->dp;
@@ -540,7 +540,7 @@ xfs_attr_list_int(
 		return -EIO;
 
 	lock_mode = xfs_ilock_attr_map_shared(dp);
-	error = xfs_attr_list_int_ilocked(context);
+	error = xfs_attr_list_ilocked(context);
 	xfs_iunlock(dp, lock_mode);
 	return error;
 }
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2e64dae3743f..639abd2bd723 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -395,7 +395,7 @@ xfs_ioc_attr_list(
 	alist->al_more = 0;
 	alist->al_offset[0] = context.bufsize;
 
-	error = xfs_attr_list_int(&context);
+	error = xfs_attr_list(&context);
 	ASSERT(error <= 0);
 	return error;
 }
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 8880dee3400f..e1951d2b878e 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -232,7 +232,7 @@ xfs_vn_listxattr(
 	context.firstu = context.bufsize;
 	context.put_listent = xfs_xattr_put_listent;
 
-	error = xfs_attr_list_int(&context);
+	error = xfs_attr_list(&context);
 	if (error)
 		return error;
 	if (context.count < 0)
-- 
2.24.1

