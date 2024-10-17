Return-Path: <linux-xfs+bounces-14437-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A291C9A2D67
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Oct 2024 21:10:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F8471F2884A
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Oct 2024 19:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44B6021BAEB;
	Thu, 17 Oct 2024 19:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FWIHQNvx"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A541E0DC3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192213; cv=none; b=Qhhe9f3wM9S5tSI8DxtADMX5dVTplo5uJXhAuik8wUSE7oUidsm09xezUUMn+6cP4kCQn0Mex47juKKfnH0QEGRAdo/NxupsEaofgmVO6J4KoF79EbQQtMqGQiLdsk0RL1aYcfRbRydM8Gy0x33izltAylqhQ1ofnUXmKuI4QwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192213; c=relaxed/simple;
	bh=fv9YCJd3pfZdGHemSmALjKqFXFkGOMIaQjiJ3nPHsns=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qU+3i+zi8KsLK1ILmMY5aLCJgHYuTNbIy44mubiOFVhH0CkIBHH29HWAcyKAII296LFteMbsCztteBecLMYyhrr0KiduyXOkVoFJ3Us5XXjETplDvA6UflYJHAVn6eaP7rI8LgZEz8PDYHJDIqCDhtWHH3hSqoSn1LOpk5r2/mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FWIHQNvx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9668BC4CEC3;
	Thu, 17 Oct 2024 19:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192212;
	bh=fv9YCJd3pfZdGHemSmALjKqFXFkGOMIaQjiJ3nPHsns=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FWIHQNvxvPq1X4sUJQkmgPz7g7N3DpZ0jrgX0UzPazJrL9mzcNqRlv7NgyDSW8+BN
	 aJB3v9nQNIgoQy+qpRFZv4qtw4fUGnuOVrP+kRzDajmNY7XyTxgPsmiQeSmL8bGTjz
	 xNOPhOeplumY87SRYFWAwm9UvQ4x5E7+SLCQu5cArHJ3FzuyYUd+iPfYxHBPtl4k0/
	 FHFvSoM8mDvlWC3EyzbZeQL144HxFAcMXJhmJ9Smycv6CsIUX+UanCYAEySVDxDJe7
	 JYD/mxdb9uCDqy5H3w4L0+xGnjrfHGHlIr4QLO2fPJ3u7heyrEYeQf2lXKguBoUTPc
	 1uPW+z1oO532A==
Date: Thu, 17 Oct 2024 12:10:12 -0700
Subject: [PATCH 2/4] xfs: use metadir for quota inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919072663.3454331.12662841704832459971.stgit@frogsfrogsfrogs>
In-Reply-To: <172919072618.3454331.12971255439040173668.stgit@frogsfrogsfrogs>
References: <172919072618.3454331.12971255439040173668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Store the quota inodes in the /quota metadata directory if metadir is
enabled.  This enables us to stop using the sb_[ugp]uotino fields in the
superblock.  From this point on, all metadata files will be children of
the metadata directory tree root.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |  190 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_quota_defs.h |   43 +++++++++
 fs/xfs/libxfs/xfs_sb.c         |    1 
 fs/xfs/xfs_qm.c                |  197 +++++++++++++++++++++++++++++++++++-----
 4 files changed, 407 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index 15a362e2f5ea70..dceef2abd4e2a3 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -16,6 +16,9 @@
 #include "xfs_trans.h"
 #include "xfs_qm.h"
 #include "xfs_error.h"
+#include "xfs_health.h"
+#include "xfs_metadir.h"
+#include "xfs_metafile.h"
 
 int
 xfs_calc_dquots_per_chunk(
@@ -323,3 +326,190 @@ xfs_dquot_to_disk_ts(
 
 	return cpu_to_be32(t);
 }
+
+inline unsigned int
+xfs_dqinode_sick_mask(xfs_dqtype_t type)
+{
+	switch (type) {
+	case XFS_DQTYPE_USER:
+		return XFS_SICK_FS_UQUOTA;
+	case XFS_DQTYPE_GROUP:
+		return XFS_SICK_FS_GQUOTA;
+	case XFS_DQTYPE_PROJ:
+		return XFS_SICK_FS_PQUOTA;
+	}
+
+	ASSERT(0);
+	return 0;
+}
+
+/*
+ * Load the inode for a given type of quota, assuming that the sb fields have
+ * been sorted out.  This is not true when switching quota types on a V4
+ * filesystem, so do not use this function for that.  If metadir is enabled,
+ * @dp must be the /quota metadir.
+ *
+ * Returns -ENOENT if the quota inode field is NULLFSINO; 0 and an inode on
+ * success; or a negative errno.
+ */
+int
+xfs_dqinode_load(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dqtype_t		type,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*ip;
+	enum xfs_metafile_type	metafile_type = xfs_dqinode_metafile_type(type);
+	int			error;
+
+	if (!xfs_has_metadir(mp)) {
+		xfs_ino_t	ino;
+
+		switch (type) {
+		case XFS_DQTYPE_USER:
+			ino = mp->m_sb.sb_uquotino;
+			break;
+		case XFS_DQTYPE_GROUP:
+			ino = mp->m_sb.sb_gquotino;
+			break;
+		case XFS_DQTYPE_PROJ:
+			ino = mp->m_sb.sb_pquotino;
+			break;
+		default:
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+
+		/* Should have set 0 to NULLFSINO when loading superblock */
+		if (ino == NULLFSINO)
+			return -ENOENT;
+
+		error = xfs_trans_metafile_iget(tp, ino, metafile_type, &ip);
+	} else {
+		error = xfs_metadir_load(tp, dp, xfs_dqinode_path(type),
+				metafile_type, &ip);
+		if (error == -ENOENT)
+			return error;
+	}
+	if (error) {
+		if (xfs_metadata_is_sick(error))
+			xfs_fs_mark_sick(mp, xfs_dqinode_sick_mask(type));
+		return error;
+	}
+
+	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
+			       ip->i_df.if_format != XFS_DINODE_FMT_BTREE)) {
+		xfs_irele(ip);
+		xfs_fs_mark_sick(mp, xfs_dqinode_sick_mask(type));
+		return -EFSCORRUPTED;
+	}
+
+	if (XFS_IS_CORRUPT(mp, ip->i_projid != 0)) {
+		xfs_irele(ip);
+		xfs_fs_mark_sick(mp, xfs_dqinode_sick_mask(type));
+		return -EFSCORRUPTED;
+	}
+
+	*ipp = ip;
+	return 0;
+}
+
+/* Create a metadata directory quota inode. */
+int
+xfs_dqinode_metadir_create(
+	struct xfs_inode		*dp,
+	xfs_dqtype_t			type,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_metadir_update	upd = {
+		.dp			= dp,
+		.metafile_type		= xfs_dqinode_metafile_type(type),
+		.path			= xfs_dqinode_path(type),
+	};
+	int				error;
+
+	error = xfs_metadir_start_create(&upd);
+	if (error)
+		return error;
+
+	error = xfs_metadir_create(&upd, S_IFREG);
+	if (error)
+		return error;
+
+	xfs_trans_log_inode(upd.tp, upd.ip, XFS_ILOG_CORE);
+
+	error = xfs_metadir_commit(&upd);
+	if (error)
+		return error;
+
+	xfs_finish_inode_setup(upd.ip);
+	*ipp = upd.ip;
+	return 0;
+}
+
+#ifndef __KERNEL__
+/* Link a metadata directory quota inode. */
+int
+xfs_dqinode_metadir_link(
+	struct xfs_inode		*dp,
+	xfs_dqtype_t			type,
+	struct xfs_inode		*ip)
+{
+	struct xfs_metadir_update	upd = {
+		.dp			= dp,
+		.metafile_type		= xfs_dqinode_metafile_type(type),
+		.path			= xfs_dqinode_path(type),
+		.ip			= ip,
+	};
+	int				error;
+
+	error = xfs_metadir_start_link(&upd);
+	if (error)
+		return error;
+
+	error = xfs_metadir_link(&upd);
+	if (error)
+		return error;
+
+	xfs_trans_log_inode(upd.tp, upd.ip, XFS_ILOG_CORE);
+
+	return xfs_metadir_commit(&upd);
+}
+#endif /* __KERNEL__ */
+
+/* Create the parent directory for all quota inodes and load it. */
+int
+xfs_dqinode_mkdir_parent(
+	struct xfs_mount	*mp,
+	struct xfs_inode	**dpp)
+{
+	if (!mp->m_metadirip) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
+		return -EFSCORRUPTED;
+	}
+
+	return xfs_metadir_mkdir(mp->m_metadirip, "quota", dpp);
+}
+
+/*
+ * Load the parent directory of all quota inodes.  Pass the inode to the caller
+ * because quota functions (e.g. QUOTARM) can be called on the quota files even
+ * if quotas are not enabled.
+ */
+int
+xfs_dqinode_load_parent(
+	struct xfs_trans	*tp,
+	struct xfs_inode	**dpp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+
+	if (!mp->m_metadirip) {
+		xfs_fs_mark_sick(mp, XFS_SICK_FS_METADIR);
+		return -EFSCORRUPTED;
+	}
+
+	return xfs_metadir_load(tp, mp->m_metadirip, "quota", XFS_METAFILE_DIR,
+			dpp);
+}
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index fb05f44f6c754a..763d941a8420c5 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -143,4 +143,47 @@ time64_t xfs_dquot_from_disk_ts(struct xfs_disk_dquot *ddq,
 		__be32 dtimer);
 __be32 xfs_dquot_to_disk_ts(struct xfs_dquot *ddq, time64_t timer);
 
+static inline const char *
+xfs_dqinode_path(xfs_dqtype_t type)
+{
+	switch (type) {
+	case XFS_DQTYPE_USER:
+		return "user";
+	case XFS_DQTYPE_GROUP:
+		return "group";
+	case XFS_DQTYPE_PROJ:
+		return "project";
+	}
+
+	ASSERT(0);
+	return NULL;
+}
+
+static inline enum xfs_metafile_type
+xfs_dqinode_metafile_type(xfs_dqtype_t type)
+{
+	switch (type) {
+	case XFS_DQTYPE_USER:
+		return XFS_METAFILE_USRQUOTA;
+	case XFS_DQTYPE_GROUP:
+		return XFS_METAFILE_GRPQUOTA;
+	case XFS_DQTYPE_PROJ:
+		return XFS_METAFILE_PRJQUOTA;
+	}
+
+	ASSERT(0);
+	return XFS_METAFILE_UNKNOWN;
+}
+
+unsigned int xfs_dqinode_sick_mask(xfs_dqtype_t type);
+
+int xfs_dqinode_load(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_dqtype_t type, struct xfs_inode **ipp);
+int xfs_dqinode_metadir_create(struct xfs_inode *dp, xfs_dqtype_t type,
+		struct xfs_inode **ipp);
+int xfs_dqinode_metadir_link(struct xfs_inode *dp, xfs_dqtype_t type,
+		struct xfs_inode *ip);
+int xfs_dqinode_mkdir_parent(struct xfs_mount *mp, struct xfs_inode **dpp);
+int xfs_dqinode_load_parent(struct xfs_trans *tp, struct xfs_inode **dpp);
+
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 6a31f48a2c5424..30c7c5238437bc 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -844,6 +844,7 @@ xfs_sb_quota_to_disk(
 
 	if (xfs_sb_is_v5(from) &&
 	    (from->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR)) {
+		to->sb_qflags = cpu_to_be16(from->sb_qflags);
 		to->sb_uquotino = cpu_to_be64(0);
 		to->sb_gquotino = cpu_to_be64(0);
 		to->sb_pquotino = cpu_to_be64(0);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index b37e80fe7e86a6..d9d09195eabb0d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -645,6 +645,157 @@ xfs_qm_init_timelimits(
 	xfs_qm_dqdestroy(dqp);
 }
 
+static int
+xfs_qm_load_metadir_qinos(
+	struct xfs_mount	*mp,
+	struct xfs_quotainfo	*qi,
+	struct xfs_inode	**dpp)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	error = xfs_dqinode_load_parent(tp, dpp);
+	if (error == -ENOENT) {
+		/* no quota dir directory, but we'll create one later */
+		error = 0;
+		goto out_trans;
+	}
+	if (error)
+		goto out_trans;
+
+	if (XFS_IS_UQUOTA_ON(mp)) {
+		error = xfs_dqinode_load(tp, *dpp, XFS_DQTYPE_USER,
+				&qi->qi_uquotaip);
+		if (error && error != -ENOENT)
+			goto out_trans;
+	}
+
+	if (XFS_IS_GQUOTA_ON(mp)) {
+		error = xfs_dqinode_load(tp, *dpp, XFS_DQTYPE_GROUP,
+				&qi->qi_gquotaip);
+		if (error && error != -ENOENT)
+			goto out_trans;
+	}
+
+	if (XFS_IS_PQUOTA_ON(mp)) {
+		error = xfs_dqinode_load(tp, *dpp, XFS_DQTYPE_PROJ,
+				&qi->qi_pquotaip);
+		if (error && error != -ENOENT)
+			goto out_trans;
+	}
+
+	error = 0;
+out_trans:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+/* Create quota inodes in the metadata directory tree. */
+STATIC int
+xfs_qm_create_metadir_qinos(
+	struct xfs_mount	*mp,
+	struct xfs_quotainfo	*qi,
+	struct xfs_inode	**dpp)
+{
+	int			error;
+
+	if (!*dpp) {
+		error = xfs_dqinode_mkdir_parent(mp, dpp);
+		if (error && error != -EEXIST)
+			return error;
+	}
+
+	if (XFS_IS_UQUOTA_ON(mp) && !qi->qi_uquotaip) {
+		error = xfs_dqinode_metadir_create(*dpp, XFS_DQTYPE_USER,
+				&qi->qi_uquotaip);
+		if (error)
+			return error;
+	}
+
+	if (XFS_IS_GQUOTA_ON(mp) && !qi->qi_gquotaip) {
+		error = xfs_dqinode_metadir_create(*dpp, XFS_DQTYPE_GROUP,
+				&qi->qi_gquotaip);
+		if (error)
+			return error;
+	}
+
+	if (XFS_IS_PQUOTA_ON(mp) && !qi->qi_pquotaip) {
+		error = xfs_dqinode_metadir_create(*dpp, XFS_DQTYPE_PROJ,
+				&qi->qi_pquotaip);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Add QUOTABIT to sb_versionnum and initialize qflags in preparation for
+ * creating quota files on a metadir filesystem.
+ */
+STATIC int
+xfs_qm_prep_metadir_sb(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	spin_lock(&mp->m_sb_lock);
+
+	xfs_add_quota(mp);
+
+	/* qflags will get updated fully _after_ quotacheck */
+	mp->m_sb.sb_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
+
+	spin_unlock(&mp->m_sb_lock);
+	xfs_log_sb(tp);
+
+	return xfs_trans_commit(tp);
+}
+
+/*
+ * Load existing quota inodes or create them.  Since this is a V5 filesystem,
+ * we don't have to deal with the grp/prjquota switcheroo thing from V4.
+ */
+STATIC int
+xfs_qm_init_metadir_qinos(
+	struct xfs_mount	*mp)
+{
+	struct xfs_quotainfo	*qi = mp->m_quotainfo;
+	struct xfs_inode	*dp = NULL;
+	int			error;
+
+	if (!xfs_has_quota(mp)) {
+		error = xfs_qm_prep_metadir_sb(mp);
+		if (error)
+			return error;
+	}
+
+	error = xfs_qm_load_metadir_qinos(mp, qi, &dp);
+	if (error)
+		goto out_err;
+
+	error = xfs_qm_create_metadir_qinos(mp, qi, &dp);
+	if (error)
+		goto out_err;
+
+	xfs_irele(dp);
+	return 0;
+out_err:
+	xfs_qm_destroy_quotainos(mp->m_quotainfo);
+	if (dp)
+		xfs_irele(dp);
+	return error;
+}
+
 /*
  * This initializes all the quota information that's kept in the
  * mount structure
@@ -669,7 +820,10 @@ xfs_qm_init_quotainfo(
 	 * See if quotainodes are setup, and if not, allocate them,
 	 * and change the superblock accordingly.
 	 */
-	error = xfs_qm_init_quotainos(mp);
+	if (xfs_has_metadir(mp))
+		error = xfs_qm_init_metadir_qinos(mp);
+	else
+		error = xfs_qm_init_quotainos(mp);
 	if (error)
 		goto out_free_lru;
 
@@ -1581,7 +1735,7 @@ xfs_qm_mount_quotas(
 	}
 
 	if (error) {
-		xfs_warn(mp, "Failed to initialize disk quotas.");
+		xfs_warn(mp, "Failed to initialize disk quotas, err %d.", error);
 		return;
 	}
 }
@@ -1600,31 +1754,26 @@ xfs_qm_qino_load(
 	xfs_dqtype_t		type,
 	struct xfs_inode	**ipp)
 {
-	xfs_ino_t		ino = NULLFSINO;
-	enum xfs_metafile_type	metafile_type = XFS_METAFILE_UNKNOWN;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*dp = NULL;
+	int			error;
 
-	switch (type) {
-	case XFS_DQTYPE_USER:
-		ino = mp->m_sb.sb_uquotino;
-		metafile_type = XFS_METAFILE_USRQUOTA;
-		break;
-	case XFS_DQTYPE_GROUP:
-		ino = mp->m_sb.sb_gquotino;
-		metafile_type = XFS_METAFILE_GRPQUOTA;
-		break;
-	case XFS_DQTYPE_PROJ:
-		ino = mp->m_sb.sb_pquotino;
-		metafile_type = XFS_METAFILE_PRJQUOTA;
-		break;
-	default:
-		ASSERT(0);
-		return -EFSCORRUPTED;
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	if (xfs_has_metadir(mp)) {
+		error = xfs_dqinode_load_parent(tp, &dp);
+		if (error)
+			goto out_cancel;
 	}
 
-	if (ino == NULLFSINO)
-		return -ENOENT;
-
-	return xfs_metafile_iget(mp, ino, metafile_type, ipp);
+	error = xfs_dqinode_load(tp, dp, type, ipp);
+	if (dp)
+		xfs_irele(dp);
+out_cancel:
+	xfs_trans_cancel(tp);
+	return error;
 }
 
 /*


