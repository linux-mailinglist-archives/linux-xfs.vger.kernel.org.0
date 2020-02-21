Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14CB5167FCC
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 15:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgBUOL7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 09:11:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59386 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728748AbgBUOL6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:11:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=TWsUOmTZqICvrihUP1F0vQL/xkZYIDbZkXGE/7U5I08=; b=OR/mOvwhbyZphV2Y/hQkliXmy/
        tzQchOHQPuxKsZ5655qv4e+G7lbdEQg+GTLjuPZVN4ChjPrl6EKN0sA0AljNsNHSEmKZzP6dwaA8a
        KUOEhpp5Nr7X7iiLf8zXadJiYGBurqy9zikjqoTItPcvFdbPfAS60mFMvsj06GStoZjW2yHlLRNBX
        QSQEPjOhaAFUMipSZQaO99kQFMXAR9p2T6U44g59y3mYj8kp6sZGmOKSn57yQfEgajyLCH2oBPZPo
        dhMcT8JrQhrRNgNhhCC/KbwBG1PvTPXOR5AAeOx7JkbppD3oei+xLewOb4vIPKHdtqu2nQDDbkYTV
        C7bUYtjg==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5926-0000Ib-KW; Fri, 21 Feb 2020 14:11:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 17/31] xfs: factor out a xfs_attr_match helper
Date:   Fri, 21 Feb 2020 06:11:40 -0800
Message-Id: <20200221141154.476496-18-hch@lst.de>
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

Factor out a helper that compares an on-disk attr vs the name, length and
flags specified in struct xfs_da_args.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 80 +++++++++++++----------------------
 1 file changed, 30 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b0658eb8fbcc..8852754153ba 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -445,14 +445,21 @@ xfs_attr3_leaf_read(
  * Namespace helper routines
  *========================================================================*/
 
-/*
- * If namespace bits don't match return 0.
- * If all match then return 1.
- */
-STATIC int
-xfs_attr_namesp_match(int arg_flags, int ondisk_flags)
+static bool
+xfs_attr_match(
+	struct xfs_da_args	*args,
+	uint8_t			namelen,
+	unsigned char		*name,
+	int			flags)
 {
-	return XFS_ATTR_NSP_ONDISK(ondisk_flags) == XFS_ATTR_NSP_ARGS_TO_ONDISK(arg_flags);
+	if (args->namelen != namelen)
+		return false;
+	if (memcmp(args->name, name, namelen) != 0)
+		return false;
+	if (XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags) !=
+	    XFS_ATTR_NSP_ONDISK(flags))
+		return false;
+	return true;
 }
 
 static int
@@ -678,15 +685,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-#ifdef DEBUG
-		if (sfe->namelen != args->namelen)
-			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		ASSERT(0);
-#endif
+		ASSERT(!xfs_attr_match(args, sfe->namelen, sfe->nameval,
+			sfe->flags));
 	}
 
 	offset = (char *)sfe - (char *)sf;
@@ -749,13 +749,9 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
 					base += size, i++) {
 		size = XFS_ATTR_SF_ENTSIZE(sfe);
-		if (sfe->namelen != args->namelen)
-			continue;
-		if (memcmp(sfe->nameval, args->name, args->namelen) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		break;
+		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->flags))
+			break;
 	}
 	if (i == end)
 		return -ENOATTR;
@@ -816,13 +812,9 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-		if (sfe->namelen != args->namelen)
-			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		return -EEXIST;
+		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->flags))
+			return -EEXIST;
 	}
 	return -ENOATTR;
 }
@@ -847,14 +839,10 @@ xfs_attr_shortform_getvalue(
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-		if (sfe->namelen != args->namelen)
-			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
-						sfe->valuelen);
+		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->flags))
+			return xfs_attr_copy_value(args,
+				&sfe->nameval[args->namelen], sfe->valuelen);
 	}
 	return -ENOATTR;
 }
@@ -2409,23 +2397,15 @@ xfs_attr3_leaf_lookup_int(
 		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
 			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
-			if (name_loc->namelen != args->namelen)
-				continue;
-			if (memcmp(args->name, name_loc->nameval,
-							args->namelen) != 0)
-				continue;
-			if (!xfs_attr_namesp_match(args->flags, entry->flags))
+			if (!xfs_attr_match(args, name_loc->namelen,
+					name_loc->nameval, entry->flags))
 				continue;
 			args->index = probe;
 			return -EEXIST;
 		} else {
 			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
-			if (name_rmt->namelen != args->namelen)
-				continue;
-			if (memcmp(args->name, name_rmt->name,
-							args->namelen) != 0)
-				continue;
-			if (!xfs_attr_namesp_match(args->flags, entry->flags))
+			if (!xfs_attr_match(args, name_rmt->namelen,
+					name_rmt->name, entry->flags))
 				continue;
 			args->index = probe;
 			args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
-- 
2.24.1

