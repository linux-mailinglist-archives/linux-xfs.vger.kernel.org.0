Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10201C0F31
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 10:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgEAIOe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 04:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgEAIOd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:14:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4A8C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=IwpRKFWXhIV1dSUrkuppn+Vnl2uK6ZJnfm2Kyl084l4=; b=Ookzoe3pWszqpwG30eTZn91MZs
        OmlGFZ5MJab8OjWluRlGin8a6IBsk/80cNzTJfaH2aFoN7/6+bPbjPkBiF2V0IUoUICxIouabeLG+
        0n4tg1Qaj9ahwykfcx0s6yR9nL5h57TXudpKHTWVqqzbMMCeUWUj7gZXikrazNGR/56hBz1w+2SPJ
        8vklfazKVo0bFDm3zH2R7ohQGzWwGinnAGo4TtxupqrXFzV8r6VDyr+2KdoKNQbee4UHB4nmORI8A
        CkSktsl5cIq2WK9cuYYbXVUt3OuoUa1vDuvsM3wG/pAHFXHR7SY7g/ELkHkmRGor7HP1O3iZ+SKj7
        7Wg0xPbg==;
Received: from [2001:4bb8:18c:10bd:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQob-0002sj-Bj
        for linux-xfs@vger.kernel.org; Fri, 01 May 2020 08:14:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/12] xfs: split xfs_iformat_fork
Date:   Fri,  1 May 2020 10:14:15 +0200
Message-Id: <20200501081424.2598914-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501081424.2598914-1-hch@lst.de>
References: <20200501081424.2598914-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_iformat_fork is a weird catchall.  Split it into one helper for
the data fork and one for the attr fork, and then call both helper
as well as the COW fork initialization from xfs_inode_from_disk.  Order
the COW fork initialization after the attr fork initialization given
that it can't fail to simplify the error handling.

Note that the newly split helpers are moved down the file in
xfs_inode_fork.c to avoid the need for forward declarations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c  |  20 +++-
 fs/xfs/libxfs/xfs_inode_fork.c | 186 +++++++++++++++------------------
 fs/xfs/libxfs/xfs_inode_fork.h |   3 +-
 3 files changed, 103 insertions(+), 106 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 02f06dec0a5a6..983beb680e81a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -193,6 +193,10 @@ xfs_inode_from_disk(
 {
 	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
+	int			error;
+
+	ASSERT(ip->i_cowfp == NULL);
+	ASSERT(ip->i_afp == NULL);
 
 	/*
 	 * Convert v1 inodes immediately to v2 inode format as this is the
@@ -248,7 +252,21 @@ xfs_inode_from_disk(
 		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
 
-	return xfs_iformat_fork(ip, from);
+	error = xfs_iformat_data_fork(ip, from);
+	if (error)
+		return error;
+	if (XFS_DFORK_Q(from)) {
+		error = xfs_iformat_attr_fork(ip, from);
+		if (error)
+			goto out_destroy_data_fork;
+	}
+	if (xfs_is_reflink_inode(ip))
+		xfs_ifork_init_cow(ip);
+	return 0;
+
+out_destroy_data_fork:
+	xfs_idestroy_fork(ip, XFS_DATA_FORK);
+	return error;
 }
 
 void
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 518c6f0ec3a61..f30d43364aa92 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -26,110 +26,6 @@
 
 kmem_zone_t *xfs_ifork_zone;
 
-STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
-STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
-STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
-
-/*
- * Copy inode type and data and attr format specific information from the
- * on-disk inode to the in-core inode and fork structures.  For fifos, devices,
- * and sockets this means set i_rdev to the proper value.  For files,
- * directories, and symlinks this means to bring in the in-line data or extent
- * pointers as well as the attribute fork.  For a fork in B-tree format, only
- * the root is immediately brought in-core.  The rest will be read in later when
- * first referenced (see xfs_iread_extents()).
- */
-int
-xfs_iformat_fork(
-	struct xfs_inode	*ip,
-	struct xfs_dinode	*dip)
-{
-	struct inode		*inode = VFS_I(ip);
-	struct xfs_attr_shortform *atp;
-	int			size;
-	int			error = 0;
-	xfs_fsize_t             di_size;
-
-	switch (inode->i_mode & S_IFMT) {
-	case S_IFIFO:
-	case S_IFCHR:
-	case S_IFBLK:
-	case S_IFSOCK:
-		ip->i_d.di_size = 0;
-		inode->i_rdev = xfs_to_linux_dev_t(xfs_dinode_get_rdev(dip));
-		break;
-
-	case S_IFREG:
-	case S_IFLNK:
-	case S_IFDIR:
-		switch (dip->di_format) {
-		case XFS_DINODE_FMT_LOCAL:
-			di_size = be64_to_cpu(dip->di_size);
-			size = (int)di_size;
-			error = xfs_iformat_local(ip, dip, XFS_DATA_FORK, size);
-			break;
-		case XFS_DINODE_FMT_EXTENTS:
-			error = xfs_iformat_extents(ip, dip, XFS_DATA_FORK);
-			break;
-		case XFS_DINODE_FMT_BTREE:
-			error = xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
-			break;
-		default:
-			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
-					dip, sizeof(*dip), __this_address);
-			return -EFSCORRUPTED;
-		}
-		break;
-
-	default:
-		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
-				sizeof(*dip), __this_address);
-		return -EFSCORRUPTED;
-	}
-	if (error)
-		return error;
-
-	if (xfs_is_reflink_inode(ip)) {
-		ASSERT(ip->i_cowfp == NULL);
-		xfs_ifork_init_cow(ip);
-	}
-
-	if (!XFS_DFORK_Q(dip))
-		return 0;
-
-	ASSERT(ip->i_afp == NULL);
-	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
-
-	switch (dip->di_aformat) {
-	case XFS_DINODE_FMT_LOCAL:
-		atp = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
-		size = be16_to_cpu(atp->hdr.totsize);
-
-		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK, size);
-		break;
-	case XFS_DINODE_FMT_EXTENTS:
-		error = xfs_iformat_extents(ip, dip, XFS_ATTR_FORK);
-		break;
-	case XFS_DINODE_FMT_BTREE:
-		error = xfs_iformat_btree(ip, dip, XFS_ATTR_FORK);
-		break;
-	default:
-		xfs_inode_verifier_error(ip, error, __func__, dip,
-				sizeof(*dip), __this_address);
-		error = -EFSCORRUPTED;
-		break;
-	}
-	if (error) {
-		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
-		ip->i_afp = NULL;
-		if (ip->i_cowfp)
-			kmem_cache_free(xfs_ifork_zone, ip->i_cowfp);
-		ip->i_cowfp = NULL;
-		xfs_idestroy_fork(ip, XFS_DATA_FORK);
-	}
-	return error;
-}
-
 void
 xfs_init_local_fork(
 	struct xfs_inode	*ip,
@@ -325,6 +221,88 @@ xfs_iformat_btree(
 	return 0;
 }
 
+int
+xfs_iformat_data_fork(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	switch (inode->i_mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		ip->i_d.di_size = 0;
+		inode->i_rdev = xfs_to_linux_dev_t(xfs_dinode_get_rdev(dip));
+		return 0;
+	case S_IFREG:
+	case S_IFLNK:
+	case S_IFDIR:
+		switch (dip->di_format) {
+		case XFS_DINODE_FMT_LOCAL:
+			return xfs_iformat_local(ip, dip, XFS_DATA_FORK,
+					be64_to_cpu(dip->di_size));
+		case XFS_DINODE_FMT_EXTENTS:
+			return xfs_iformat_extents(ip, dip, XFS_DATA_FORK);
+		case XFS_DINODE_FMT_BTREE:
+			return xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
+		default:
+			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
+					dip, sizeof(*dip), __this_address);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+				sizeof(*dip), __this_address);
+		return -EFSCORRUPTED;
+	}
+}
+
+static uint16_t
+xfs_dfork_attr_shortform_size(
+	struct xfs_dinode		*dip)
+{
+	struct xfs_attr_shortform	*atp =
+		(struct xfs_attr_shortform *)XFS_DFORK_APTR(dip);
+
+	return be16_to_cpu(atp->hdr.totsize);
+}
+
+int
+xfs_iformat_attr_fork(
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip)
+{
+	int			error = 0;
+
+	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
+	switch (dip->di_aformat) {
+	case XFS_DINODE_FMT_LOCAL:
+		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK,
+				xfs_dfork_attr_shortform_size(dip));
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+		error = xfs_iformat_extents(ip, dip, XFS_ATTR_FORK);
+		break;
+	case XFS_DINODE_FMT_BTREE:
+		error = xfs_iformat_btree(ip, dip, XFS_ATTR_FORK);
+		break;
+	default:
+		xfs_inode_verifier_error(ip, error, __func__, dip,
+				sizeof(*dip), __this_address);
+		error = -EFSCORRUPTED;
+		break;
+	}
+
+	if (error) {
+		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
+		ip->i_afp = NULL;
+	}
+	return error;
+}
+
 /*
  * Reallocate the space for if_broot based on the number of records
  * being added or deleted as indicated in rec_diff.  Move the records
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 668ee942be224..8487b0c88a75e 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -88,7 +88,8 @@ struct xfs_ifork {
 
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
 
-int		xfs_iformat_fork(struct xfs_inode *, struct xfs_dinode *);
+int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
+int		xfs_iformat_attr_fork(struct xfs_inode *, struct xfs_dinode *);
 void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
 				struct xfs_inode_log_item *, int);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
-- 
2.26.2

