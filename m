Return-Path: <linux-xfs+bounces-5246-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6134087F284
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Mar 2024 22:48:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9139E1C2125E
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Mar 2024 21:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A8355917B;
	Mon, 18 Mar 2024 21:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJwF/5qU"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5919655E41
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798527; cv=none; b=EK/YYhhbsOur2AYuqqkX//EzdJ5H6IApGmckXZOWswqKXQNC+QjHnOMHIVgzKLphUELE3zL5YgQyIwmxH5YOndK31YBex2XrHjAc9mLdGlgHta2BaJyJdEbtaByRSmLm+4Q+poUatHYUo4PVfEoTGQ0tPNmAHzZak9fjvXVjzmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798527; c=relaxed/simple;
	bh=Skw11qgpcjaUUG/oWTVD7Ug1TWXAHS9pGEiv65mdcmE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lzrUXGibUP2eh/YwRj4Iggv1Y9vWRJ4B5w6IdgYbFe+aCejze2uTRDeohRSou31CdJU6xv4McMj70MBrfuoGb4b/ZqNcmacyzqd7sL2/9POnmtaKUBqFwWkJsRjfDv1eYkk2szWIi9/vqa8sQCNm1q06NAh0egKyLIPC44uVJOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bJwF/5qU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31030C433F1;
	Mon, 18 Mar 2024 21:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798527;
	bh=Skw11qgpcjaUUG/oWTVD7Ug1TWXAHS9pGEiv65mdcmE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bJwF/5qUIHRDLRUfWaQ/QCt59/8HjCvph8yXhl/+bBco/Q3ng7sxtku1OvuZcdPQA
	 8eVz1afxfInDPUbWh66UpO115lIF1cmyjtoSSlt8xa1T0M37TcCNpcu/8iw6ifcYVL
	 wTOB7ccnHfHhLKpyHMrXhjiFNEo88l4ZD28nsOjt3GBnFGtHeTea7FTLtfDMDze+9N
	 aBFQkMoRJ9lwyxcRacfGRo79zGulMs3a4Zoh5MSrZdZfaDEaCRF6bsoeTXWRiaIt6O
	 LUjVnGTFruv28FvsXgSM9LM4xKuzWyTWuzh3f3RXCqoKrBZ8fwKwJKlywty44aeqdZ
	 bp5BYYWFUdCYw==
Date: Mon, 18 Mar 2024 14:48:46 -0700
Subject: [PATCH 03/23] xfs: create a parent pointer walk function for
 scrubbers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802743.3808642.877387028852449596.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Build a parent pointer iteration function off of the existing xattr
walking code.  This will be used by subsequent patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/listxattr.c |   84 +++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/listxattr.h |    9 +++++
 2 files changed, 88 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/listxattr.c b/fs/xfs/scrub/listxattr.c
index 40a686901bcdc..afae7352c1e06 100644
--- a/fs/xfs/scrub/listxattr.c
+++ b/fs/xfs/scrub/listxattr.c
@@ -17,11 +17,46 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_sf.h"
 #include "xfs_trans.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/bitmap.h"
 #include "scrub/dab_bitmap.h"
 #include "scrub/listxattr.h"
 
+struct xchk_pptr_walk {
+	struct xfs_parent_name_irec	*pptr_buf;
+	xchk_pptr_fn			fn;
+	void				*priv;
+};
+
+/* Call the parent pointer callback if this xattr is a valid parent pointer. */
+STATIC int
+xchk_pptr_walk_attr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct xchk_pptr_walk	*pw = priv;
+	const struct xfs_parent_name_rec *rec = (const void *)name;
+
+	/* Ignore anything that isn't a parent pointer. */
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return 0;
+
+	if (!xfs_parent_namecheck(sc->mp, rec, namelen, attr_flags))
+		return -EFSCORRUPTED;
+	if (!xfs_parent_valuecheck(sc->mp, value, valuelen))
+		return -EFSCORRUPTED;
+
+	xfs_parent_irec_from_disk(pw->pptr_buf, rec, value, valuelen);
+	return pw->fn(sc, ip, pw->pptr_buf, pw->priv);
+}
+
 /* Call a function for every entry in a shortform xattr structure. */
 STATIC int
 xchk_xattr_walk_sf(
@@ -37,9 +72,16 @@ xchk_xattr_walk_sf(
 
 	sfe = xfs_attr_sf_firstentry(hdr);
 	for (i = 0; i < hdr->count; i++) {
-		error = attr_fn(sc, ip, sfe->flags, sfe->nameval, sfe->namelen,
-				&sfe->nameval[sfe->namelen], sfe->valuelen,
-				priv);
+		if (attr_fn == xchk_pptr_walk_attr)
+			error = xchk_pptr_walk_attr(sc, ip, sfe->flags,
+					sfe->nameval, sfe->namelen,
+					&sfe->nameval[sfe->namelen],
+					sfe->valuelen, priv);
+		else
+			error = attr_fn(sc, ip, sfe->flags,
+					sfe->nameval, sfe->namelen,
+					&sfe->nameval[sfe->namelen],
+					sfe->valuelen, priv);
 		if (error)
 			return error;
 
@@ -91,8 +133,12 @@ xchk_xattr_walk_leaf_entries(
 			valuelen = be32_to_cpu(name_rmt->valuelen);
 		}
 
-		error = attr_fn(sc, ip, entry->flags, name, namelen, value,
-				valuelen, priv);
+		if (attr_fn == xchk_pptr_walk_attr)
+			error = xchk_pptr_walk_attr(sc, ip, entry->flags, name,
+					namelen, value, valuelen, priv);
+		else
+			error = attr_fn(sc, ip, entry->flags, name, namelen,
+					value, valuelen, priv);
 		if (error)
 			return error;
 
@@ -310,3 +356,31 @@ xchk_xattr_walk(
 
 	return xchk_xattr_walk_node(sc, ip, attr_fn, priv);
 }
+
+/*
+ * Walk every parent pointer of this file.  The parent pointer will be
+ * formatted into the provided @pptr_buf, which is then passed to the callback
+ * function.
+ *
+ * The callback function must decide if an invalid parent_ino or invalid name
+ * should halt the parent pointer walk; the only validation done here is the
+ * structure of the xattrs themselves.
+ */
+int
+xchk_pptr_walk(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	xchk_pptr_fn			pptr_fn,
+	struct xfs_parent_name_irec	*pptr_buf,
+	void				*priv)
+{
+	struct xchk_pptr_walk		pw = {
+		.fn			= pptr_fn,
+		.pptr_buf		= pptr_buf,
+		.priv			= priv,
+	};
+
+	ASSERT(xfs_has_parent(sc->mp));
+
+	return xchk_xattr_walk(sc, ip, xchk_pptr_walk_attr, &pw);
+}
diff --git a/fs/xfs/scrub/listxattr.h b/fs/xfs/scrub/listxattr.h
index 48fe89d05946b..7e4bd3ae75e15 100644
--- a/fs/xfs/scrub/listxattr.h
+++ b/fs/xfs/scrub/listxattr.h
@@ -14,4 +14,13 @@ typedef int (*xchk_xattr_fn)(struct xfs_scrub *sc, struct xfs_inode *ip,
 int xchk_xattr_walk(struct xfs_scrub *sc, struct xfs_inode *ip,
 		xchk_xattr_fn attr_fn, void *priv);
 
+struct xfs_parent_name_irec;
+
+typedef int (*xchk_pptr_fn)(struct xfs_scrub *sc, struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *pptr, void *priv);
+
+int xchk_pptr_walk(struct xfs_scrub *sc, struct xfs_inode *ip,
+		xchk_pptr_fn pptr_fn, struct xfs_parent_name_irec *pptr_buf,
+		void *priv);
+
 #endif /* __XFS_SCRUB_LISTXATTR_H__ */


