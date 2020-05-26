Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D0C1CA40A
	for <lists+linux-xfs@lfdr.de>; Fri,  8 May 2020 08:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgEHGep (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 May 2020 02:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727094AbgEHGeo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 02:34:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4484C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 23:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=nvwYU3l5cqmbGZqiIDF1abfv5hXcY7tw1D3Ey1ieO44=; b=Ei60N2nFUoDqnBCsGBj1Z8pgmt
        Znslicyg8DT22IuJR/PS0iuHUbKf3QpSeEvKto4JJOW9JnHAOnhsyjBGNNRo92g0xv1zm2IHJUcTo
        UayYyY3NaEWasqUAlvwzRHSrWR/JOzpDKmQ18DrCFsk0CIQz+gKotaMDJ8iQhTQJW89HmAzwrb/MB
        muLFrIIRZwjyi2v6+gpcR7QQOeiPOkYxP5wxulPeU5NA4zNImNatTCajNKne1wnt3Ehms0CvkXve9
        2llOwW36A9oG9QdrmDUlmEeGlt8cEdcfjPXfnNgF/zredoPOTuE9YUdyYQjtitGrW+VUpy7xHBEKR
        OAq2dBew==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWwaq-0002vn-Ax
        for linux-xfs@vger.kernel.org; Fri, 08 May 2020 06:34:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/12] xfs: remove xfs_ifork_ops
Date:   Fri,  8 May 2020 08:34:19 +0200
Message-Id: <20200508063423.482370-9-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508063423.482370-1-hch@lst.de>
References: <20200508063423.482370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_ifork_ops add up to two indirect calls per inode read and flush,
despite just having a single instance in the kernel.  In xfsprogs
phase6 in xfs_repair overrides the verify_dir method to deal with inodes
that do not have a valid parent, but that can be fixed pretty easily
by ensuring they always have a valid looking parent.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 19 +++++--------------
 fs/xfs/libxfs/xfs_inode_fork.h | 15 ++-------------
 fs/xfs/xfs_inode.c             |  4 ++--
 3 files changed, 9 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 5fadfa9a17eb9..e346e143f1053 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -673,18 +673,10 @@ xfs_ifork_init_cow(
 	ip->i_cnextents = 0;
 }
 
-/* Default fork content verifiers. */
-struct xfs_ifork_ops xfs_default_ifork_ops = {
-	.verify_attr	= xfs_attr_shortform_verify,
-	.verify_dir	= xfs_dir2_sf_verify,
-	.verify_symlink	= xfs_symlink_shortform_verify,
-};
-
 /* Verify the inline contents of the data fork of an inode. */
 xfs_failaddr_t
 xfs_ifork_verify_data(
-	struct xfs_inode	*ip,
-	struct xfs_ifork_ops	*ops)
+	struct xfs_inode	*ip)
 {
 	/* Non-local data fork, we're done. */
 	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
@@ -693,9 +685,9 @@ xfs_ifork_verify_data(
 	/* Check the inline data fork if there is one. */
 	switch (VFS_I(ip)->i_mode & S_IFMT) {
 	case S_IFDIR:
-		return ops->verify_dir(ip);
+		return xfs_dir2_sf_verify(ip);
 	case S_IFLNK:
-		return ops->verify_symlink(ip);
+		return xfs_symlink_shortform_verify(ip);
 	default:
 		return NULL;
 	}
@@ -704,13 +696,12 @@ xfs_ifork_verify_data(
 /* Verify the inline contents of the attr fork of an inode. */
 xfs_failaddr_t
 xfs_ifork_verify_attr(
-	struct xfs_inode	*ip,
-	struct xfs_ifork_ops	*ops)
+	struct xfs_inode	*ip)
 {
 	/* There has to be an attr fork allocated if aformat is local. */
 	if (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
 		return NULL;
 	if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
 		return __this_address;
-	return ops->verify_attr(ip);
+	return xfs_attr_shortform_verify(ip);
 }
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 8487b0c88a75e..3f84d33abd3b7 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -176,18 +176,7 @@ extern struct kmem_zone	*xfs_ifork_zone;
 
 extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
-typedef xfs_failaddr_t (*xfs_ifork_verifier_t)(struct xfs_inode *);
-
-struct xfs_ifork_ops {
-	xfs_ifork_verifier_t	verify_symlink;
-	xfs_ifork_verifier_t	verify_dir;
-	xfs_ifork_verifier_t	verify_attr;
-};
-extern struct xfs_ifork_ops	xfs_default_ifork_ops;
-
-xfs_failaddr_t xfs_ifork_verify_data(struct xfs_inode *ip,
-		struct xfs_ifork_ops *ops);
-xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_inode *ip,
-		struct xfs_ifork_ops *ops);
+xfs_failaddr_t xfs_ifork_verify_data(struct xfs_inode *ip);
+xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_inode *ip);
 
 #endif	/* __XFS_INODE_FORK_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ab31a5dec7aab..25c00ffe18409 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3718,7 +3718,7 @@ xfs_inode_verify_forks(
 	struct xfs_ifork	*ifp;
 	xfs_failaddr_t		fa;
 
-	fa = xfs_ifork_verify_data(ip, &xfs_default_ifork_ops);
+	fa = xfs_ifork_verify_data(ip);
 	if (fa) {
 		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
@@ -3726,7 +3726,7 @@ xfs_inode_verify_forks(
 		return false;
 	}
 
-	fa = xfs_ifork_verify_attr(ip, &xfs_default_ifork_ops);
+	fa = xfs_ifork_verify_attr(ip);
 	if (fa) {
 		ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
-- 
2.26.2

