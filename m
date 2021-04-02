Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453A2352B66
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Apr 2021 16:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhDBOYU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Apr 2021 10:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbhDBOYT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 10:24:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DD2C0613E6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Apr 2021 07:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=FxQ0IDuvjRqZs/cPgAtCifNB5zo9XlovAFSenwG+fOQ=; b=XGT4ozrl77QQmxWGgg9TjxNajS
        4OZHJBu/jALm3pMz2jYkxizYBGSbqRn1iblGk/pidcGfCoH+1klSi/zE+LItFc+D4A/Re2ZHidmn3
        UzLjcvm6s893I9QSgYxOSzjhARVBvNt/ViiPQe8YqLB8LKevjmwpJmEEUUmxEcKBWW6jU242OPZLU
        rishFqocVZmrr9SSOes3Y9wvpzBQkeZLgOFC7UucbEaPExiUBBicsAk2zkUxd5ITrNA8ViclCm7vk
        TRehpFa9MNPAiok9ekT+flRuGwVmgxWG1ZrEzvpp6uDjFxQhiX+LnRuWWEbx6d7lqa/RY4cxzLA/n
        qtkuYCRQ==;
Received: from [2001:4bb8:180:7517:6acc:e698:6fa4:15da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lSKif-00FA5a-P2
        for linux-xfs@vger.kernel.org; Fri, 02 Apr 2021 14:24:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/7] xfs: rename and simplify xfs_bmap_one_block
Date:   Fri,  2 Apr 2021 16:24:04 +0200
Message-Id: <20210402142409.372050-3-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210402142409.372050-1-hch@lst.de>
References: <20210402142409.372050-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_bmap_one_block is only called for the attribute fork.  Move it to
xfs_attr.c, drop the unused whichfork argument and code only executed for
the data fork and rename the result to xfs_attr_is_leaf.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c | 30 +++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_attr.h |  1 +
 fs/xfs/libxfs/xfs_bmap.c | 32 --------------------------------
 fs/xfs/libxfs/xfs_bmap.h |  1 -
 fs/xfs/xfs_attr_list.c   |  2 +-
 5 files changed, 27 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 472b3039eabbf1..0146f70b71b1e2 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -70,6 +70,26 @@ xfs_inode_hasattr(
 	return 1;
 }
 
+/*
+ * Returns true if the there is exactly only block in the attr fork, in which
+ * case the attribute fork consists of a single leaf block entry.
+ */
+bool
+xfs_attr_is_leaf(
+	struct xfs_inode	*ip)
+{
+	struct xfs_ifork	*ifp = ip->i_afp;
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	imap;
+
+	if (ifp->if_nextents != 1 || ifp->if_format != XFS_DINODE_FMT_EXTENTS)
+		return false;
+
+	xfs_iext_first(ifp, &icur);
+	xfs_iext_get_extent(ifp, &icur, &imap);
+	return imap.br_startoff == 0 && imap.br_blockcount == 1;
+}
+
 /*========================================================================
  * Overall external interface routines.
  *========================================================================*/
@@ -89,7 +109,7 @@ xfs_attr_get_ilocked(
 
 	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_shortform_getvalue(args);
-	if (xfs_bmap_one_block(args->dp, XFS_ATTR_FORK))
+	if (xfs_attr_is_leaf(args->dp))
 		return xfs_attr_leaf_get(args);
 	return xfs_attr_node_get(args);
 }
@@ -293,7 +313,7 @@ xfs_attr_set_args(
 			return error;
 	}
 
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+	if (xfs_attr_is_leaf(dp)) {
 		error = xfs_attr_leaf_addname(args);
 		if (error != -ENOSPC)
 			return error;
@@ -347,7 +367,7 @@ xfs_has_attr(
 		return xfs_attr_sf_findname(args, NULL, NULL);
 	}
 
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+	if (xfs_attr_is_leaf(dp)) {
 		error = xfs_attr_leaf_hasname(args, &bp);
 
 		if (bp)
@@ -374,7 +394,7 @@ xfs_attr_remove_args(
 	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
 		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
 		error = xfs_attr_shortform_remove(args);
-	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
+	} else if (xfs_attr_is_leaf(dp)) {
 		error = xfs_attr_leaf_removename(args);
 	} else {
 		error = xfs_attr_node_removename(args);
@@ -1282,7 +1302,7 @@ xfs_attr_node_removename(
 	/*
 	 * If the result is small enough, push it all into the inode.
 	 */
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+	if (xfs_attr_is_leaf(dp))
 		error = xfs_attr_node_shrink(args, state);
 
 out:
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 3e97a935e7121f..2b1f61987a9dec 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -85,6 +85,7 @@ int xfs_attr_inactive(struct xfs_inode *dp);
 int xfs_attr_list_ilocked(struct xfs_attr_list_context *);
 int xfs_attr_list(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
+bool xfs_attr_is_leaf(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index b8cab14ca8ce8d..e11f8faaf8898b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1435,38 +1435,6 @@ xfs_bmap_last_offset(
 	return 0;
 }
 
-/*
- * Returns whether the selected fork of the inode has exactly one
- * block or not.  For the data fork we check this matches di_size,
- * implying the file's range is 0..bsize-1.
- */
-int					/* 1=>1 block, 0=>otherwise */
-xfs_bmap_one_block(
-	struct xfs_inode	*ip,		/* incore inode */
-	int			whichfork)	/* data or attr fork */
-{
-	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
-	int			rval;		/* return value */
-	struct xfs_bmbt_irec	s;		/* internal version of extent */
-	struct xfs_iext_cursor icur;
-
-#ifndef DEBUG
-	if (whichfork == XFS_DATA_FORK)
-		return XFS_ISIZE(ip) == ip->i_mount->m_sb.sb_blocksize;
-#endif	/* !DEBUG */
-	if (ifp->if_nextents != 1)
-		return 0;
-	if (ifp->if_format != XFS_DINODE_FMT_EXTENTS)
-		return 0;
-	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
-	xfs_iext_first(ifp, &icur);
-	xfs_iext_get_extent(ifp, &icur, &s);
-	rval = s.br_startoff == 0 && s.br_blockcount == 1;
-	if (rval && whichfork == XFS_DATA_FORK)
-		ASSERT(XFS_ISIZE(ip) == ip->i_mount->m_sb.sb_blocksize);
-	return rval;
-}
-
 /*
  * Extent tree manipulation functions used during allocation.
  */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 6747e97a794901..59fa4834a761fe 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -199,7 +199,6 @@ int	xfs_bmap_last_before(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *last_block, int whichfork);
 int	xfs_bmap_last_offset(struct xfs_inode *ip, xfs_fileoff_t *unused,
 		int whichfork);
-int	xfs_bmap_one_block(struct xfs_inode *ip, int whichfork);
 int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 		xfs_filblks_t len, struct xfs_bmbt_irec *mval,
 		int *nmap, int flags);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 8f8837fe21cf02..25dcc98d50e6da 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -514,7 +514,7 @@ xfs_attr_list_ilocked(
 		return 0;
 	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_shortform_list(context);
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+	if (xfs_attr_is_leaf(dp))
 		return xfs_attr_leaf_list(context);
 	return xfs_attr_node_list(context);
 }
-- 
2.30.1

