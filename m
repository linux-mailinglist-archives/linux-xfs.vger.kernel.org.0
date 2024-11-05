Return-Path: <linux-xfs+bounces-15061-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0467C9BD858
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2024 23:18:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27E361C21091
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2024 22:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECD7F1E5022;
	Tue,  5 Nov 2024 22:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZaWyet6E"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6F81DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845123; cv=none; b=SFFwgRFHxRKHFSwWI+60S9mReif5P/gvsLXGg5cbJRbQpsHJHDLEYuHRT6BCzFuNw9/NCHt539NZbdqjBt+/Gpkd3B1W1BpVfrUoFFGBydOqQtj1fICn27sCGObozQiyLduJCLUppzeA2qhHZqvwUf10XbTC2sfitW3p9gbLZx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845123; c=relaxed/simple;
	bh=tYDMJCmJQl2X8wlc0nnOwcatngqi5mBfaOl9q35wumY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kXMtslVPi+PKS8X0g/A+wvy/xjkFRpSrb7ZUG7EjNVLjNKzKtCZ9XffidNfuW8XALRUnn04P0GdK7QMf/Om5+foux3oAK4/8qthOris6J2TQGAAYJ5RmTmY1hBDta0WkVxCfSZ0CX0GeClc+/YqqrX0hbCX7CLODJ4stztUaD3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZaWyet6E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A01C4CED0;
	Tue,  5 Nov 2024 22:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845123;
	bh=tYDMJCmJQl2X8wlc0nnOwcatngqi5mBfaOl9q35wumY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZaWyet6Ec45izuAkJTj0SkESd+8FNLCFtKbxxF8CrtIWynx0bavHJzp4o10TmBlxY
	 YKp4UKf5fFdr6Es7Vy8+bNIyNSjozVe3zL1CEBjYYGgWvg+OMYhnK9KuBqEyoRiZvz
	 LUNKH/p8gG4ZwS421/UwywQaze5ovMUL8hZ120aJ1c+n7E8+UhRWJIT+vZ/dzy9G3W
	 fixR5vCstrC1Tx18YEyy5UaqBAGG3O+p3H9DzsmIG/BvPIfWz4YcrTQgaTwtVui+KT
	 U2EXcB/m0/AR62ua7HUi+rh2mhK7nNgcLtH9KS0YK3gW63nJ8zzlMJJdQj28vj7HoN
	 kYOGJMqaIjalg==
Date: Tue, 05 Nov 2024 14:18:43 -0800
Subject: [PATCH 08/28] xfs: enforce metadata inode flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396157.1870066.1838165459147546920.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
References: <173084395946.1870066.5846370267426919612.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add checks for the metadata inode flag so that we don't ever leak
metadata inodes out to userspace, and we don't ever try to read a
regular inode as metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   70 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.h |    3 ++
 fs/xfs/libxfs/xfs_metafile.h  |   11 ++++++
 fs/xfs/scrub/common.c         |   10 +++++-
 fs/xfs/scrub/inode.c          |   26 ++++++++++++++-
 fs/xfs/scrub/inode_repair.c   |   10 ++++++
 fs/xfs/xfs_icache.c           |   12 ++++++-
 fs/xfs/xfs_inode.c            |   11 ++++++
 8 files changed, 147 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 78febaa0d6923b..424861fbf1bd49 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -19,6 +19,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_dir2.h"
 #include "xfs_health.h"
+#include "xfs_metafile.h"
 
 #include <linux/iversion.h>
 
@@ -489,6 +490,69 @@ xfs_dinode_verify_nrext64(
 	return NULL;
 }
 
+/*
+ * Validate all the picky requirements we have for a file that claims to be
+ * filesystem metadata.
+ */
+xfs_failaddr_t
+xfs_dinode_verify_metadir(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dip,
+	uint16_t		mode,
+	uint16_t		flags,
+	uint64_t		flags2)
+{
+	if (!xfs_has_metadir(mp))
+		return __this_address;
+
+	/* V5 filesystem only */
+	if (dip->di_version < 3)
+		return __this_address;
+
+	if (be16_to_cpu(dip->di_metatype) >= XFS_METAFILE_MAX)
+		return __this_address;
+
+	/* V3 inode fields that are always zero */
+	if ((flags2 & XFS_DIFLAG2_NREXT64) && dip->di_nrext64_pad)
+		return __this_address;
+	if (!(flags2 & XFS_DIFLAG2_NREXT64) && dip->di_flushiter)
+		return __this_address;
+
+	/* Metadata files can only be directories or regular files */
+	if (!S_ISDIR(mode) && !S_ISREG(mode))
+		return __this_address;
+
+	/* They must have zero access permissions */
+	if (mode & 0777)
+		return __this_address;
+
+	/* DMAPI event and state masks are zero */
+	if (dip->di_dmevmask || dip->di_dmstate)
+		return __this_address;
+
+	/*
+	 * User and group IDs must be zero.  The project ID is used for
+	 * grouping inodes.  Metadata inodes are never accounted to quotas.
+	 */
+	if (dip->di_uid || dip->di_gid)
+		return __this_address;
+
+	/* Mandatory inode flags must be set */
+	if (S_ISDIR(mode)) {
+		if ((flags & XFS_METADIR_DIFLAGS) != XFS_METADIR_DIFLAGS)
+			return __this_address;
+	} else {
+		if ((flags & XFS_METAFILE_DIFLAGS) != XFS_METAFILE_DIFLAGS)
+			return __this_address;
+	}
+
+	/* dax flags2 must not be set */
+	if (flags2 & XFS_DIFLAG2_DAX)
+		return __this_address;
+
+	return NULL;
+}
+
 xfs_failaddr_t
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
@@ -673,6 +737,12 @@ xfs_dinode_verify(
 	    !xfs_has_bigtime(mp))
 		return __this_address;
 
+	if (flags2 & XFS_DIFLAG2_METADATA) {
+		fa = xfs_dinode_verify_metadir(mp, dip, mode, flags, flags2);
+		if (fa)
+			return fa;
+	}
+
 	return NULL;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 585ed5a110af4e..8d43d2641c7328 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -28,6 +28,9 @@ int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 
 xfs_failaddr_t xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
 			   struct xfs_dinode *dip);
+xfs_failaddr_t xfs_dinode_verify_metadir(struct xfs_mount *mp,
+		struct xfs_dinode *dip, uint16_t mode, uint16_t flags,
+		uint64_t flags2);
 xfs_failaddr_t xfs_inode_validate_extsize(struct xfs_mount *mp,
 		uint32_t extsize, uint16_t mode, uint16_t flags);
 xfs_failaddr_t xfs_inode_validate_cowextsize(struct xfs_mount *mp,
diff --git a/fs/xfs/libxfs/xfs_metafile.h b/fs/xfs/libxfs/xfs_metafile.h
index 60fe1890611277..c66b0c51b461a8 100644
--- a/fs/xfs/libxfs/xfs_metafile.h
+++ b/fs/xfs/libxfs/xfs_metafile.h
@@ -6,6 +6,17 @@
 #ifndef __XFS_METAFILE_H__
 #define __XFS_METAFILE_H__
 
+/* All metadata files must have these flags set. */
+#define XFS_METAFILE_DIFLAGS	(XFS_DIFLAG_IMMUTABLE | \
+				 XFS_DIFLAG_SYNC | \
+				 XFS_DIFLAG_NOATIME | \
+				 XFS_DIFLAG_NODUMP | \
+				 XFS_DIFLAG_NODEFRAG)
+
+/* All metadata directories must have these flags set. */
+#define XFS_METADIR_DIFLAGS	(XFS_METAFILE_DIFLAGS | \
+				 XFS_DIFLAG_NOSYMLINKS)
+
 /* Code specific to kernel/userspace; must be provided externally. */
 
 int xfs_trans_metafile_iget(struct xfs_trans *tp, xfs_ino_t ino,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 777959f8ec724b..001af49b298818 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -947,9 +947,15 @@ xchk_iget_for_scrubbing(
 	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino)
 		return xchk_install_live_inode(sc, ip_in);
 
-	/* Reject internal metadata files and obviously bad inode numbers. */
-	if (xfs_is_sb_inum(mp, sc->sm->sm_ino))
+	/*
+	 * On pre-metadir filesystems, reject internal metadata files.  For
+	 * metadir filesystems, limited scrubbing of any file in the metadata
+	 * directory tree by handle is allowed, because that is the only way to
+	 * validate the lack of parent pointers in the sb-root metadata inodes.
+	 */
+	if (!xfs_has_metadir(mp) && xfs_is_sb_inum(mp, sc->sm->sm_ino))
 		return -ENOENT;
+	/* Reject obviously bad inode numbers. */
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index a7ac7a4125ff12..ac5c5641653392 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -60,6 +60,22 @@ xchk_install_handle_iscrub(
 	if (error)
 		return error;
 
+	/*
+	 * Don't allow scrubbing by handle of any non-directory inode records
+	 * in the metadata directory tree.  We don't know if any of the scans
+	 * launched by this scrubber will end up indirectly trying to lock this
+	 * file.
+	 *
+	 * Scrubbers of inode-rooted metadata files (e.g. quota files) will
+	 * attach all the resources needed to scrub the inode and call
+	 * xchk_inode directly.  Userspace cannot call this directly.
+	 */
+	if (xfs_is_metadir_inode(ip) && !S_ISDIR(VFS_I(ip)->i_mode)) {
+		xchk_irele(sc, ip);
+		sc->ip = NULL;
+		return -ENOENT;
+	}
+
 	return xchk_prepare_iscrub(sc);
 }
 
@@ -94,9 +110,15 @@ xchk_setup_inode(
 		return xchk_prepare_iscrub(sc);
 	}
 
-	/* Reject internal metadata files and obviously bad inode numbers. */
-	if (xfs_is_sb_inum(mp, sc->sm->sm_ino))
+	/*
+	 * On pre-metadir filesystems, reject internal metadata files.  For
+	 * metadir filesystems, limited scrubbing of any file in the metadata
+	 * directory tree by handle is allowed, because that is the only way to
+	 * validate the lack of parent pointers in the sb-root metadata inodes.
+	 */
+	if (!xfs_has_metadir(mp) && xfs_is_sb_inum(mp, sc->sm->sm_ino))
 		return -ENOENT;
+	/* Reject obviously bad inode numbers. */
 	if (!xfs_verify_ino(sc->mp, sc->sm->sm_ino))
 		return -ENOENT;
 
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 1eec5c6eb11071..486cedbc40bb8e 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -568,6 +568,16 @@ xrep_dinode_flags(
 		dip->di_nrext64_pad = 0;
 	else if (dip->di_version >= 3)
 		dip->di_v3_pad = 0;
+
+	if (flags2 & XFS_DIFLAG2_METADATA) {
+		xfs_failaddr_t	fa;
+
+		fa = xfs_dinode_verify_metadir(sc->mp, dip, mode, flags,
+				flags2);
+		if (fa)
+			flags2 &= ~XFS_DIFLAG2_METADATA;
+	}
+
 	dip->di_flags = cpu_to_be16(flags);
 	dip->di_flags2 = cpu_to_be64(flags2);
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index aa645e35781202..48543bf0f5ce83 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -834,7 +834,8 @@ xfs_iget(
 /*
  * Get a metadata inode.
  *
- * The metafile type must match the file mode exactly.
+ * The metafile type must match the file mode exactly, and for files in the
+ * metadata directory tree, it must match the inode's metatype exactly.
  */
 int
 xfs_trans_metafile_iget(
@@ -863,13 +864,20 @@ xfs_trans_metafile_iget(
 		mode = S_IFREG;
 	if (inode_wrong_type(VFS_I(ip), mode))
 		goto bad_rele;
+	if (xfs_has_metadir(mp)) {
+		if (!xfs_is_metadir_inode(ip))
+			goto bad_rele;
+		if (metafile_type != ip->i_metatype)
+			goto bad_rele;
+	}
 
 	*ipp = ip;
 	return 0;
 bad_rele:
 	xfs_irele(ip);
 whine:
-	xfs_err(mp, "metadata inode 0x%llx is corrupt", ino);
+	xfs_err(mp, "metadata inode 0x%llx type %u is corrupt", ino,
+			metafile_type);
 	return -EFSCORRUPTED;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 12c5ff151edf4c..ae94583ea3bbe7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -555,8 +555,19 @@ xfs_lookup(
 	if (error)
 		goto out_free_name;
 
+	/*
+	 * Fail if a directory entry in the regular directory tree points to
+	 * a metadata file.
+	 */
+	if (XFS_IS_CORRUPT(dp->i_mount, xfs_is_metadir_inode(*ipp))) {
+		error = -EFSCORRUPTED;
+		goto out_irele;
+	}
+
 	return 0;
 
+out_irele:
+	xfs_irele(*ipp);
 out_free_name:
 	if (ci_name)
 		kfree(ci_name->name);


