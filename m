Return-Path: <linux-xfs+bounces-7475-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DD438AFF86
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Apr 2024 05:23:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E061285BE9
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Apr 2024 03:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D15785C46;
	Wed, 24 Apr 2024 03:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rd3En5zG"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C2C947E
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928998; cv=none; b=KdK/k9cBK3F6u2PRK/MIzb6+fx+CIcmdm8yHttGvMyds5wn+misAH8ds0TDvmOj6A59kMT7Cq5zH/quito386cnrfGj/CX3vyct7omKuXrNuAoQwpLBSDGC5FTezltCcBnFizAfkR2hNND4Id1UZuCFXx0EHxr74fsnQOy44KCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928998; c=relaxed/simple;
	bh=CAa7YcynXLfmce5qLRw4eYHD21q3lHhHvsNW2LWI7go=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d07t6OqhKngYHTxs7a34BfjFsV3WO1YGPgHlcfSOtA8kz7h5g4/yJCoElF7Oge6YyNCHEkz+NtokSPJSpZE8i87aPiErhFeRogQtxRcNHqxCjaq8r1leRQ8JU1QCPqOUkJC5fTLALSx+njAmghjf4A+RVq64kRThxE0ed8ottRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rd3En5zG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D9FC116B1;
	Wed, 24 Apr 2024 03:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928997;
	bh=CAa7YcynXLfmce5qLRw4eYHD21q3lHhHvsNW2LWI7go=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rd3En5zGhDcC2unrLkgfjtP7L7WJSotmMTBHnWtluY8+Y6N7nqKzOvaekn2nEswxT
	 ZWINGy7ITQC+JUl/tdgbZKJu1lMpMLahhCI6c12hfWVkxaf050n2ZnZb0fkMAZnkAx
	 qX87ukgoLwluvjXdnol0CEx1yq9KmITml1atQAgpySF26CizZtJrLqu0CBugZS4VLk
	 39VTBpvalFPwiEVZc6tlIu2SKXvvjSmaRz64GW0ll70TwuaQEsfUqeioeJ9VDOTF1w
	 UTPMUSqRBdMbWo0d58q/mAiTA7cI+9C6Y0OmZm5TkG/SebkJZ2O9Uc9LZdweBi6MWj
	 cEDDIylrQkkEg==
Date: Tue, 23 Apr 2024 20:23:17 -0700
Subject: [PATCH 04/16] xfs: add raw parent pointer apis to support repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784718.1906420.6375630807564572701.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
References: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
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

Add a couple of utility functions to set or remove parent pointers from
a file.  These functions will be used by repair code, hence they skip
the xattr logging that regular parent pointer updates use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2.c   |    2 +
 fs/xfs/libxfs/xfs_dir2.h   |    2 +
 fs/xfs/libxfs/xfs_parent.c |   64 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |    6 ++++
 4 files changed, 72 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 9da99fa20c75..7634344dc515 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -434,7 +434,7 @@ int
 xfs_dir_removename(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
-	struct xfs_name		*name,
+	const struct xfs_name	*name,
 	xfs_ino_t		ino,
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index eb3a5c35025b..b580a78bcf4f 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -58,7 +58,7 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t ino,
+				const struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 1e53df5f8332..69366c44a701 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -313,3 +313,67 @@ xfs_parent_lookup(
 	xfs_parent_da_args_init(scratch, tp, pptr, ip, ip->i_ino, parent_name);
 	return xfs_attr_get_ilocked(scratch);
 }
+
+/* Sanity-check a parent pointer before we try to perform repairs. */
+static inline bool
+xfs_parent_sanity_check(
+	struct xfs_mount		*mp,
+	const struct xfs_name		*parent_name,
+	const struct xfs_parent_rec	*pptr)
+{
+	if (!xfs_parent_namecheck(XFS_ATTR_PARENT, parent_name->name,
+				parent_name->len))
+		return false;
+
+	if (!xfs_parent_valuecheck(mp, pptr, sizeof(*pptr)))
+		return false;
+
+	return true;
+}
+
+
+/*
+ * Attach the parent pointer (@parent_name -> @pptr) to @ip immediately.
+ * Caller must not have a transaction or hold the ILOCK.  This is for
+ * specialized repair functions only.  The scratchpad need not be initialized.
+ */
+int
+xfs_parent_set(
+	struct xfs_inode	*ip,
+	xfs_ino_t		owner,
+	const struct xfs_name	*parent_name,
+	struct xfs_parent_rec	*pptr,
+	struct xfs_da_args	*scratch)
+{
+	if (!xfs_parent_sanity_check(ip->i_mount, parent_name, pptr)) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	memset(scratch, 0, sizeof(struct xfs_da_args));
+	xfs_parent_da_args_init(scratch, NULL, pptr, ip, owner, parent_name);
+	return xfs_attr_set(scratch, XFS_ATTRUPDATE_CREATE, false);
+}
+
+/*
+ * Remove the parent pointer (@parent_name -> @pptr) from @ip immediately.
+ * Caller must not have a transaction or hold the ILOCK.  This is for
+ * specialized repair functions only.  The scratchpad need not be initialized.
+ */
+int
+xfs_parent_unset(
+	struct xfs_inode		*ip,
+	xfs_ino_t			owner,
+	const struct xfs_name		*parent_name,
+	struct xfs_parent_rec		*pptr,
+	struct xfs_da_args		*scratch)
+{
+	if (!xfs_parent_sanity_check(ip->i_mount, parent_name, pptr)) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	memset(scratch, 0, sizeof(struct xfs_da_args));
+	xfs_parent_da_args_init(scratch, NULL, pptr, ip, owner, parent_name);
+	return xfs_attr_set(scratch, XFS_ATTRUPDATE_REMOVE, false);
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 97788582321a..b8036527cdc7 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -100,5 +100,11 @@ int xfs_parent_from_attr(struct xfs_mount *mp, unsigned int attr_flags,
 int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
 		const struct xfs_name *name, struct xfs_parent_rec *pptr,
 		struct xfs_da_args *scratch);
+int xfs_parent_set(struct xfs_inode *ip, xfs_ino_t owner,
+		const struct xfs_name *name, struct xfs_parent_rec *pptr,
+		struct xfs_da_args *scratch);
+int xfs_parent_unset(struct xfs_inode *ip, xfs_ino_t owner,
+		const struct xfs_name *name, struct xfs_parent_rec *pptr,
+		struct xfs_da_args *scratch);
 
 #endif /* __XFS_PARENT_H__ */


