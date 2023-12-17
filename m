Return-Path: <linux-xfs+bounces-870-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D99881609F
	for <lists+linux-xfs@lfdr.de>; Sun, 17 Dec 2023 18:04:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 529871C22047
	for <lists+linux-xfs@lfdr.de>; Sun, 17 Dec 2023 17:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1286A46541;
	Sun, 17 Dec 2023 17:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dsZPVZGk"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D2A46445
	for <linux-xfs@vger.kernel.org>; Sun, 17 Dec 2023 17:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hGSyyiuIM2hivz3lCbxR1bwmmujjQou/Nc0al7NWfIo=; b=dsZPVZGkPXpNI5SoUhs+rnmlvh
	vrWVZbaY9sLmB7ONypkvtJPFQe4Ro+lR+xX7sK80VyZBqgSREn1WklqQsDpTIlxnC6W2qNnLMS+q5
	EiVflxEsLBrdwuO9zb6IVNCqIIWXHGxpCCEkfhWPxKnPXvSK3pwVx+hrbhwJXxIjlavlropkB2smc
	e/isMQnmG4SmgzRXUTyrGi9qYbAxbZBpDLpLjD1AWMqp1Yyxkd7JwFXB+LKWgBKDc4FdF3GRDn4AZ
	6tqpCymmQukkrHij6DF/rnEsLPOL9eut5WuPuK2KdJHoPkYW5MV9z/8u2WseLRGwuXVI5VFg8llxV
	FQKVFsAg==;
Received: from [88.128.92.84] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rEuYe-008AGi-1O;
	Sun, 17 Dec 2023 17:04:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfs: simplify xfs_attr_sf_findname
Date: Sun, 17 Dec 2023 18:03:46 +0100
Message-Id: <20231217170350.605812-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231217170350.605812-1-hch@lst.de>
References: <20231217170350.605812-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_attr_sf_findname has the simple job of finding a xfs_attr_sf_entry in
the attr fork, but the convoluted calling convention obfuscates that.

Return the found entry as the return value instead of an pointer
argument, as the -ENOATTR/-EEXIST can be trivally derived from that, and
remove the basep argument, as it is equivalent of the offset of sfe in
the data for if an sfe was found, or an offset of totsize if not was
found.  To simplify the totsize computation add a xfs_attr_sf_endptr
helper that returns the imaginative xfs_attr_sf_entry at the end of
the current attrs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c      |  7 ++-
 fs/xfs/libxfs/xfs_attr_leaf.c | 96 +++++++++++++----------------------
 fs/xfs/libxfs/xfs_attr_leaf.h |  4 +-
 fs/xfs/libxfs/xfs_attr_sf.h   |  6 +++
 4 files changed, 47 insertions(+), 66 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 7f822e72dfcd3e..bcf8748cb1a333 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -862,8 +862,11 @@ xfs_attr_lookup(
 	if (!xfs_inode_hasattr(dp))
 		return -ENOATTR;
 
-	if (dp->i_af.if_format == XFS_DINODE_FMT_LOCAL)
-		return xfs_attr_sf_findname(args, NULL, NULL);
+	if (dp->i_af.if_format == XFS_DINODE_FMT_LOCAL) {
+		if (xfs_attr_sf_findname(args))
+			return -EEXIST;
+		return -ENOATTR;
+	}
 
 	if (xfs_attr_is_leaf(dp)) {
 		error = xfs_attr_leaf_hasname(args, &bp);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 37474af8ee4633..7a623efd23a6a4 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -698,47 +698,24 @@ xfs_attr_shortform_create(
 }
 
 /*
- * Return -EEXIST if attr is found, or -ENOATTR if not
- * args:  args containing attribute name and namelen
- * sfep:  If not null, pointer will be set to the last attr entry found on
-	  -EEXIST.  On -ENOATTR pointer is left at the last entry in the list
- * basep: If not null, pointer is set to the byte offset of the entry in the
- *	  list on -EEXIST.  On -ENOATTR, pointer is left at the byte offset of
- *	  the last entry in the list
+ * Return the entry if the attr in args is found, or NULL if not.
  */
-int
+struct xfs_attr_sf_entry *
 xfs_attr_sf_findname(
-	struct xfs_da_args	 *args,
-	struct xfs_attr_sf_entry **sfep,
-	unsigned int		 *basep)
+	struct xfs_da_args		*args)
 {
-	struct xfs_attr_shortform *sf = args->dp->i_af.if_data;
-	struct xfs_attr_sf_entry *sfe;
-	unsigned int		base = sizeof(struct xfs_attr_sf_hdr);
-	int			size = 0;
-	int			end;
-	int			i;
+	struct xfs_attr_shortform	*sf = args->dp->i_af.if_data;
+	struct xfs_attr_sf_entry	*sfe;
 
-	sfe = &sf->list[0];
-	end = sf->hdr.count;
-	for (i = 0; i < end; sfe = xfs_attr_sf_nextentry(sfe),
-			     base += size, i++) {
-		size = xfs_attr_sf_entsize(sfe);
-		if (!xfs_attr_match(args, sfe->namelen, sfe->nameval,
-				    sfe->flags))
-			continue;
-		break;
+	for (sfe = &sf->list[0];
+	     sfe < xfs_attr_sf_endptr(sf);
+	     sfe = xfs_attr_sf_nextentry(sfe)) {
+		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->flags))
+			return sfe;
 	}
 
-	if (sfep != NULL)
-		*sfep = sfe;
-
-	if (basep != NULL)
-		*basep = base;
-
-	if (i == end)
-		return -ENOATTR;
-	return -EEXIST;
+	return NULL;
 }
 
 /*
@@ -755,21 +732,19 @@ xfs_attr_shortform_add(
 	struct xfs_ifork		*ifp = &dp->i_af;
 	struct xfs_attr_shortform	*sf = ifp->if_data;
 	struct xfs_attr_sf_entry	*sfe;
-	int				offset, size;
+	int				size;
 
 	trace_xfs_attr_sf_add(args);
 
 	dp->i_forkoff = forkoff;
 
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
-	if (xfs_attr_sf_findname(args, &sfe, NULL) == -EEXIST)
-		ASSERT(0);
+	ASSERT(!xfs_attr_sf_findname(args));
 
-	offset = (char *)sfe - (char *)sf;
 	size = xfs_attr_sf_entsize_byname(args->namelen, args->valuelen);
 	sf = xfs_idata_realloc(dp, size, XFS_ATTR_FORK);
-	sfe = (struct xfs_attr_sf_entry *)((char *)sf + offset);
 
+	sfe = xfs_attr_sf_endptr(sf);
 	sfe->namelen = args->namelen;
 	sfe->valuelen = args->valuelen;
 	sfe->flags = args->attr_filter;
@@ -809,39 +784,38 @@ xfs_attr_sf_removename(
 	struct xfs_mount		*mp = dp->i_mount;
 	struct xfs_attr_shortform	*sf = dp->i_af.if_data;
 	struct xfs_attr_sf_entry	*sfe;
-	int				size = 0, end, totsize;
-	unsigned int			base;
-	int				error;
+	uint16_t			totsize = be16_to_cpu(sf->hdr.totsize);
+	void				*next, *end;
+	int				size = 0;
 
 	trace_xfs_attr_sf_remove(args);
 
-	error = xfs_attr_sf_findname(args, &sfe, &base);
-
-	/*
-	 * If we are recovering an operation, finding nothing to
-	 * remove is not an error - it just means there was nothing
-	 * to clean up.
-	 */
-	if (error == -ENOATTR && (args->op_flags & XFS_DA_OP_RECOVERY))
-		return 0;
-	if (error != -EEXIST)
-		return error;
-	size = xfs_attr_sf_entsize(sfe);
+	sfe = xfs_attr_sf_findname(args);
+	if (!sfe) {
+		/*
+		 * If we are recovering an operation, finding nothing to remove
+		 * is not an error, it just means there was nothing to clean up.
+		 */
+		if (args->op_flags & XFS_DA_OP_RECOVERY)
+			return 0;
+		return -ENOATTR;
+	}
 
 	/*
 	 * Fix up the attribute fork data, covering the hole
 	 */
-	end = base + size;
-	totsize = be16_to_cpu(sf->hdr.totsize);
-	if (end != totsize)
-		memmove(&((char *)sf)[base], &((char *)sf)[end], totsize - end);
+	size = xfs_attr_sf_entsize(sfe);
+	next = xfs_attr_sf_nextentry(sfe);
+	end = xfs_attr_sf_endptr(sf);
+	if (next < end)
+		memmove(sfe, next, end - next);
 	sf->hdr.count--;
-	be16_add_cpu(&sf->hdr.totsize, -size);
+	totsize -= size;
+	sf->hdr.totsize = cpu_to_be16(totsize);
 
 	/*
 	 * Fix up the start offset of the attribute fork
 	 */
-	totsize -= size;
 	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
 	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index ce6743463c8681..56fcd689eedfe7 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -51,9 +51,7 @@ int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
 int	xfs_attr_sf_removename(struct xfs_da_args *args);
-int	xfs_attr_sf_findname(struct xfs_da_args *args,
-			     struct xfs_attr_sf_entry **sfep,
-			     unsigned int *basep);
+struct xfs_attr_sf_entry *xfs_attr_sf_findname(struct xfs_da_args *args);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
 xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_attr_shortform *sfp,
diff --git a/fs/xfs/libxfs/xfs_attr_sf.h b/fs/xfs/libxfs/xfs_attr_sf.h
index 37578b369d9b98..db5819cbea0f91 100644
--- a/fs/xfs/libxfs/xfs_attr_sf.h
+++ b/fs/xfs/libxfs/xfs_attr_sf.h
@@ -48,4 +48,10 @@ xfs_attr_sf_nextentry(struct xfs_attr_sf_entry *sfep)
 	return (void *)sfep + xfs_attr_sf_entsize(sfep);
 }
 
+static inline struct xfs_attr_sf_entry *
+xfs_attr_sf_endptr(struct xfs_attr_shortform *sf)
+{
+	return (void *)sf + be16_to_cpu(sf->hdr.totsize);
+}
+
 #endif	/* __XFS_ATTR_SF_H__ */
-- 
2.39.2


