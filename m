Return-Path: <linux-xfs+bounces-19258-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C98D5A2B654
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Feb 2025 00:03:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03D573A56A5
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Feb 2025 23:03:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 276D22417C6;
	Thu,  6 Feb 2025 23:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yg/XM9cI"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CF82417C0
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738883013; cv=none; b=mw3DpLsTd/9lw+Zq00ABM845lFSnVYJrLLV7CaTlmcm9HgQKS/huk6t3SYseO7V0N/ObYVpk0aKvceKfkjp+jROhDtucqB3KPQl5Bx4Dbp6uNxqyAwRtyYHxrDPhWqa0y1YeNzbfU3QY7Hp5NIj1JidhudQ7fQVBc5OO+Rw3DeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738883013; c=relaxed/simple;
	bh=cF+upmzWhdgCy0DD2SMxRbwkJCOnjM37DogHex+jwNE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nVG8j1IfydYBonYvVL1AfALWMk02xRE7HP/B0lRYqX2OAzEEYCiIZf+Ne8d9ipnmWcO4MiuGxm5sbbO6EE39Ce/HohOPTLgQWF3qxoQgaxS2BQ+kH7y/hOy8MKSXUnIp69F4UhJnhsau3M91PyidX5AtXa99slXmWYtdqZrIgYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yg/XM9cI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D05C4CEDD;
	Thu,  6 Feb 2025 23:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738883013;
	bh=cF+upmzWhdgCy0DD2SMxRbwkJCOnjM37DogHex+jwNE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Yg/XM9cIO5Ib3CBGc66u2l77rTwTpBIu26uSn8ZCzhyMUY0HlsSlgAqvETRPklwvD
	 O46MnnKol7mdbVY2rtLU5x7yOIrMpZwUzHzRFGNWmAqtFTOnA304G/x9EXt+foS9Eu
	 k/d2eY0fe6SlhjcSJdqWXdpMjAms1NufWCGKrueNemfqQeAPcjt8l7T7Ix+jvmdm/9
	 VKCn3tH1f728poGteK4Q/5QaoxJSD3fyZK7z8FU+0Qp9iKg/5JdipfHomZGa1wmIZr
	 oDNnLI4+LX6vunfBRV8AGxAXgsQ3SzYVC74pKf1a0u1Y2kG4I5igTFJ1FQjYj5jYOZ
	 Di3t8OvkuwpDg==
Date: Thu, 06 Feb 2025 15:03:32 -0800
Subject: [PATCH 4/4] xfs_db: add command to copy directory trees out of
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089664.2742734.11946589861684958797.stgit@frogsfrogsfrogs>
In-Reply-To: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Aheada of deprecating V4 support in the kernel, let's give people a way
to extract their files from a filesystem without needing to mount.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/Makefile              |    3 
 db/command.c             |    1 
 db/command.h             |    1 
 db/namei.c               |    5 
 db/namei.h               |   18 +
 db/rdump.c               |  999 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    2 
 man/man8/xfs_db.8        |   26 +
 8 files changed, 1052 insertions(+), 3 deletions(-)
 create mode 100644 db/namei.h
 create mode 100644 db/rdump.c


diff --git a/db/Makefile b/db/Makefile
index 02eeead25b49d0..e36e775eee6021 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -45,6 +45,7 @@ HFILES = \
 	logformat.h \
 	malloc.h \
 	metadump.h \
+	namei.h \
 	obfuscate.h \
 	output.h \
 	print.h \
@@ -64,7 +65,7 @@ CFILES = $(HFILES:.h=.c) \
 	convert.c \
 	info.c \
 	iunlink.c \
-	namei.c \
+	rdump.c \
 	timelimit.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
diff --git a/db/command.c b/db/command.c
index 1b46c3fec08a0e..15bdabbcb7d728 100644
--- a/db/command.c
+++ b/db/command.c
@@ -145,4 +145,5 @@ init_commands(void)
 	timelimit_init();
 	iunlink_init();
 	bmapinflate_init();
+	rdump_init();
 }
diff --git a/db/command.h b/db/command.h
index 2c2926afd7b516..21419bbe65bfeb 100644
--- a/db/command.h
+++ b/db/command.h
@@ -36,3 +36,4 @@ extern void		timelimit_init(void);
 extern void		namei_init(void);
 extern void		iunlink_init(void);
 extern void		bmapinflate_init(void);
+extern void		rdump_init(void);
diff --git a/db/namei.c b/db/namei.c
index 6f277a65ed91ac..2586e0591c2357 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -14,6 +14,7 @@
 #include "fprint.h"
 #include "field.h"
 #include "inode.h"
+#include "namei.h"
 
 /* Path lookup */
 
@@ -144,7 +145,7 @@ path_navigate(
 }
 
 /* Walk a directory path to an inode and set the io cursor to that inode. */
-static int
+int
 path_walk(
 	xfs_ino_t	rootino,
 	const char	*path)
@@ -493,7 +494,7 @@ list_leafdir(
 }
 
 /* Read the directory, display contents. */
-static int
+int
 listdir(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
diff --git a/db/namei.h b/db/namei.h
new file mode 100644
index 00000000000000..05c384bc9a6c35
--- /dev/null
+++ b/db/namei.h
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef DB_NAMEI_H_
+#define DB_NAMEI_H_
+
+int path_walk(xfs_ino_t rootino, const char *path);
+
+typedef int (*dir_emit_t)(struct xfs_trans *tp, struct xfs_inode *dp,
+		xfs_dir2_dataptr_t off, char *name, ssize_t namelen,
+		xfs_ino_t ino, uint8_t dtype, void *private);
+
+int listdir(struct xfs_trans *tp, struct xfs_inode *dp, dir_emit_t dir_emit,
+		void *private);
+
+#endif /* DB_NAMEI_H_ */
diff --git a/db/rdump.c b/db/rdump.c
new file mode 100644
index 00000000000000..1e31b40a072bdc
--- /dev/null
+++ b/db/rdump.c
@@ -0,0 +1,999 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs.h"
+#include "command.h"
+#include "output.h"
+#include "init.h"
+#include "io.h"
+#include "namei.h"
+#include "type.h"
+#include "input.h"
+#include "faddr.h"
+#include "fprint.h"
+#include "field.h"
+#include "inode.h"
+#include "listxattr.h"
+#include <sys/xattr.h>
+#include <linux/xattr.h>
+
+static bool strict_errors;
+
+/* file attributes that we might have lost */
+#define LOST_OWNER		(1U << 0)
+#define LOST_MODE		(1U << 1)
+#define LOST_TIME		(1U << 2)
+#define LOST_SOME_FSXATTR	(1U << 3)
+#define LOST_FSXATTR		(1U << 4)
+#define LOST_XATTR		(1U << 5)
+
+static unsigned int lost_mask;
+
+static void
+rdump_help(void)
+{
+	dbprintf(_(
+"\n"
+" Recover files out of the filesystem into a directory.\n"
+"\n"
+" Options:\n"
+"   -s      -- Fail on errors when reading content from the filesystem.\n"
+"   paths   -- Copy only these paths.  If no paths are given, copy everything.\n"
+"   destdir -- The destination into which files are recovered.\n"
+	));
+}
+
+struct destdir {
+	int	fd;
+	char	*path;
+	char	*sep;
+};
+
+struct pathbuf {
+	size_t	len;
+	char	path[PATH_MAX + 1];
+};
+
+static int rdump_file(struct xfs_trans *tp, xfs_ino_t ino,
+		const struct destdir *destdir, struct pathbuf *pbuf);
+
+static inline unsigned int xflags2getflags(const struct fsxattr *fa)
+{
+	unsigned int	ret = 0;
+
+	if (fa->fsx_xflags & FS_XFLAG_IMMUTABLE)
+		ret |= FS_IMMUTABLE_FL;
+	if (fa->fsx_xflags & FS_XFLAG_APPEND)
+		ret |= FS_APPEND_FL;
+	if (fa->fsx_xflags & FS_XFLAG_SYNC)
+		ret |= FS_SYNC_FL;
+	if (fa->fsx_xflags & FS_XFLAG_NOATIME)
+		ret |= FS_NOATIME_FL;
+	if (fa->fsx_xflags & FS_XFLAG_NODUMP)
+		ret |= FS_NODUMP_FL;
+	if (fa->fsx_xflags & FS_XFLAG_DAX)
+		ret |= FS_DAX_FL;
+	if (fa->fsx_xflags & FS_XFLAG_PROJINHERIT)
+		ret |= FS_PROJINHERIT_FL;
+	return ret;
+}
+
+/* Copy common file attributes to this fd */
+static int
+rdump_fileattrs_fd(
+	struct xfs_inode	*ip,
+	const struct destdir	*destdir,
+	const struct pathbuf	*pbuf,
+	int			fd)
+{
+	struct fsxattr		fsxattr = {
+		.fsx_extsize	= ip->i_extsize,
+		.fsx_projid	= ip->i_projid,
+		.fsx_cowextsize	= ip->i_cowextsize,
+		.fsx_xflags	= xfs_ip2xflags(ip),
+	};
+	int			ret;
+
+	ret = fchmod(fd, VFS_I(ip)->i_mode & ~S_IFMT);
+	if (ret) {
+		if (errno == EPERM)
+			lost_mask |= LOST_MODE;
+		else
+			dbprintf(_("%s%s%s: fchmod %s\n"), destdir->path,
+					destdir->sep, pbuf->path,
+					strerror(errno));
+		if (strict_errors)
+			return 1;
+	}
+
+	ret = fchown(fd, i_uid_read(VFS_I(ip)), i_gid_read(VFS_I(ip)));
+	if (ret) {
+		if (errno == EPERM)
+			lost_mask |= LOST_OWNER;
+		else
+			dbprintf(_("%s%s%s: fchown %s\n"), destdir->path,
+					destdir->sep, pbuf->path,
+					strerror(errno));
+		if (strict_errors)
+			return 1;
+	}
+
+	ret = ioctl(fd, XFS_IOC_FSSETXATTR, &fsxattr);
+	if (ret) {
+		unsigned int	getflags = xflags2getflags(&fsxattr);
+
+		/* try to use setflags if the target is not xfs */
+		if (errno == EOPNOTSUPP || errno == ENOTTY) {
+			lost_mask |= LOST_SOME_FSXATTR;
+			ret = ioctl(fd, FS_IOC_SETFLAGS, &getflags);
+		}
+
+		if (errno == EOPNOTSUPP || errno == EPERM || errno == ENOTTY)
+			lost_mask |= LOST_FSXATTR;
+		else
+			dbprintf(_("%s%s%s: fssetxattr %s\n"), destdir->path,
+					destdir->sep, pbuf->path,
+					strerror(errno));
+		if (strict_errors)
+			return 1;
+	}
+
+	return 0;
+}
+
+/* Copy common file attributes to this path */
+static int
+rdump_fileattrs_path(
+	struct xfs_inode	*ip,
+	const struct destdir	*destdir,
+	const struct pathbuf	*pbuf)
+{
+	int			ret;
+
+	ret = fchmodat(destdir->fd, pbuf->path, VFS_I(ip)->i_mode & ~S_IFMT,
+			AT_SYMLINK_NOFOLLOW);
+	if (ret) {
+		/* fchmodat on a symlink is not supported */
+		if (errno == EPERM || errno == EOPNOTSUPP)
+			lost_mask |= LOST_MODE;
+		else
+			dbprintf(_("%s%s%s: fchmodat %s\n"), destdir->path,
+					destdir->sep, pbuf->path,
+					strerror(errno));
+		if (strict_errors)
+			return 1;
+	}
+
+	ret = fchownat(destdir->fd, pbuf->path, i_uid_read(VFS_I(ip)),
+			i_gid_read(VFS_I(ip)), AT_SYMLINK_NOFOLLOW);
+	if (ret) {
+		if (errno == EPERM)
+			lost_mask |= LOST_OWNER;
+		else
+			dbprintf(_("%s%s%s: fchownat %s\n"), destdir->path,
+					destdir->sep, pbuf->path,
+					strerror(errno));
+		if (strict_errors)
+			return 1;
+	}
+
+	/* XXX cannot copy fsxattrs */
+
+	return 0;
+}
+
+/* Copy access and modification timestamps to this fd. */
+static int
+rdump_timestamps_fd(
+	struct xfs_inode	*ip,
+	const struct destdir	*destdir,
+	const struct pathbuf	*pbuf,
+	int			fd)
+{
+	struct timespec		times[2] = {
+		[0] = {
+			.tv_sec  = inode_get_atime_sec(VFS_I(ip)),
+			.tv_nsec = inode_get_atime_nsec(VFS_I(ip)),
+		},
+		[1] = {
+			.tv_sec  = inode_get_mtime_sec(VFS_I(ip)),
+			.tv_nsec = inode_get_mtime_nsec(VFS_I(ip)),
+		},
+	};
+	int			ret;
+
+	/* XXX cannot copy ctime or btime */
+
+	ret = futimens(fd, times);
+	if (ret) {
+		if (errno == EPERM)
+			lost_mask |= LOST_TIME;
+		else
+			dbprintf(_("%s%s%s: futimens %s\n"), destdir->path,
+					destdir->sep, pbuf->path,
+					strerror(errno));
+		if (strict_errors)
+			return 1;
+	}
+
+	return 0;
+}
+
+/* Copy access and modification timestamps to this path. */
+static int
+rdump_timestamps_path(
+	struct xfs_inode	*ip,
+	const struct destdir	*destdir,
+	const struct pathbuf	*pbuf)
+{
+	struct timespec		times[2] = {
+		[0] = {
+			.tv_sec  = inode_get_atime_sec(VFS_I(ip)),
+			.tv_nsec = inode_get_atime_nsec(VFS_I(ip)),
+		},
+		[1] = {
+			.tv_sec  = inode_get_mtime_sec(VFS_I(ip)),
+			.tv_nsec = inode_get_mtime_nsec(VFS_I(ip)),
+		},
+	};
+	int			ret;
+
+	/* XXX cannot copy ctime or btime */
+
+	ret = utimensat(destdir->fd, pbuf->path, times, AT_SYMLINK_NOFOLLOW);
+	if (ret) {
+		if (errno == EPERM)
+			lost_mask |= LOST_TIME;
+		else
+			dbprintf(_("%s%s%s: utimensat %s\n"), destdir->path,
+					destdir->sep, pbuf->path,
+					strerror(errno));
+		if (strict_errors)
+			return 1;
+	}
+
+	return 0;
+}
+
+struct copyxattr {
+	const struct destdir	*destdir;
+	const struct pathbuf	*pbuf;
+	int			fd;
+	char			name[XATTR_NAME_MAX + 1];
+	char			value[XATTR_SIZE_MAX];
+};
+
+/* Copy one extended attribute */
+static int
+rdump_xattr(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	const char		*nsp;
+	struct copyxattr	*cx = priv;
+	const size_t		remaining = sizeof(cx->name);
+	ssize_t			added;
+	int			ret;
+
+	if (attr_flags & XFS_ATTR_PARENT)
+		return 0;
+
+	/* Format xattr name */
+	if (attr_flags & XFS_ATTR_ROOT)
+		nsp = XATTR_TRUSTED_PREFIX;
+	else if (attr_flags & XFS_ATTR_SECURE)
+		nsp = XATTR_SECURITY_PREFIX;
+	else
+		nsp = XATTR_USER_PREFIX;
+	added = snprintf(cx->name, remaining, "%s.%.*s", nsp, namelen, name);
+	if (added > remaining) {
+		dbprintf(_("%s%s%s: ran out of space formatting xattr name\n"),
+				cx->destdir->path, cx->destdir->sep,
+				cx->pbuf->path);
+		return strict_errors ? ECANCELED : 0;
+	}
+
+	/* Retrieve xattr value if needed */
+	if (valuelen > 0 && !value) {
+		struct xfs_da_args	args = {
+			.trans		= tp,
+			.dp		= ip,
+			.geo		= mp->m_attr_geo,
+			.owner		= ip->i_ino,
+			.attr_filter	= attr_flags & XFS_ATTR_NSP_ONDISK_MASK,
+			.namelen	= namelen,
+			.name		= name,
+			.value		= cx->value,
+			.valuelen	= valuelen,
+		};
+
+		ret = -libxfs_attr_rmtval_get(&args);
+		if (ret) {
+			dbprintf(_("%s: reading xattr \"%.*s\" value %s\n"),
+					cx->pbuf->path, namelen, name,
+					strerror(ret));
+			return strict_errors ? ECANCELED : 0;
+		}
+	}
+
+	ret = fsetxattr(cx->fd, cx->name, cx->value, valuelen, 0);
+	if (ret) {
+		if (ret == EOPNOTSUPP)
+			lost_mask |= LOST_XATTR;
+		else
+			dbprintf(_("%s%s%s: fsetxattr \"%.*s\" %s\n"),
+					cx->destdir->path, cx->destdir->sep,
+					cx->pbuf->path, namelen, name,
+					strerror(errno));
+		if (strict_errors)
+			return ECANCELED;
+	}
+
+	return 0;
+}
+
+/* Copy extended attributes */
+static int
+rdump_xattrs(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	const struct destdir	*destdir,
+	const struct pathbuf	*pbuf,
+	int			fd)
+{
+	struct copyxattr	*cx;
+	int			ret;
+
+	cx = calloc(1, sizeof(struct copyxattr));
+	if (!cx) {
+		dbprintf(_("%s%s%s: allocating xattr buffer %s\n"),
+				destdir->path, destdir->sep, pbuf->path,
+				strerror(errno));
+		return 1;
+	}
+	cx->destdir = destdir;
+	cx->pbuf = pbuf;
+	cx->fd = fd;
+
+	ret = xattr_walk(tp, ip, rdump_xattr, cx);
+	if (ret && ret != ECANCELED) {
+		dbprintf(_("%s%s%s: listxattr %s\n"), destdir->path,
+				destdir->sep, pbuf->path, strerror(errno));
+		if (strict_errors)
+			return 1;
+	}
+
+	free(cx);
+	return 0;
+}
+
+struct copydirent {
+	const struct destdir	*destdir;
+	struct pathbuf		*pbuf;
+	int			fd;
+};
+
+/* Copy a directory entry. */
+static int
+rdump_dirent(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	xfs_dir2_dataptr_t	off,
+	char			*name,
+	ssize_t			namelen,
+	xfs_ino_t		ino,
+	uint8_t			dtype,
+	void			*private)
+{
+	struct copydirent	*cd = private;
+	size_t			oldlen = cd->pbuf->len;
+	const size_t		remaining = PATH_MAX + 1 - oldlen;
+	ssize_t			added;
+	int			ret;
+
+	/* Negative length means name is null-terminated */
+	if (namelen < 0)
+		namelen = -namelen;
+
+	/* Ignore dot and dotdot */
+	if (namelen == 1 && name[0] == '.')
+		return 0;
+	if (namelen == 2 && name[0] == '.' && name[1] == '.')
+		return 0;
+
+	if (namelen > FILENAME_MAX) {
+		dbprintf(_("%s%s%s: %s\n"),
+				cd->destdir->path, cd->destdir->sep,
+				cd->pbuf->path, strerror(ENAMETOOLONG));
+		return strict_errors ? ECANCELED : 0;
+	}
+
+	added = snprintf(&cd->pbuf->path[oldlen], remaining, "%s%.*s",
+			oldlen ? "/" : "", (int)namelen, name);
+	if (added > remaining) {
+		dbprintf(_("%s%s%s: ran out of space formatting file name\n"),
+				cd->destdir->path, cd->destdir->sep,
+				cd->pbuf->path);
+		return strict_errors ? ECANCELED : 0;
+	}
+
+	cd->pbuf->len += added;
+	ret = rdump_file(tp, ino, cd->destdir, cd->pbuf);
+	cd->pbuf->len = oldlen;
+	cd->pbuf->path[oldlen] = 0;
+	return ret;
+}
+
+/* Copy a directory */
+static int
+rdump_directory(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	const struct destdir	*destdir,
+	struct pathbuf		*pbuf)
+{
+	struct copydirent	*cd;
+	int			ret, ret2;
+
+	cd = calloc(1, sizeof(struct copydirent));
+	if (!cd) {
+		dbprintf(_("%s%s%s: %s\n"), destdir->path, destdir->sep,
+				pbuf->path, strerror(errno));
+		return 1;
+	}
+	cd->destdir = destdir;
+	cd->pbuf = pbuf;
+
+	if (pbuf->len) {
+		/*
+		 * If path is non-empty, we want to create a child somewhere
+		 * underneath the target directory.
+		 */
+		ret = mkdirat(destdir->fd, pbuf->path, 0600);
+		if (ret && errno != EEXIST) {
+			dbprintf(_("%s%s%s: %s\n"), destdir->path,
+					destdir->sep, pbuf->path,
+					strerror(errno));
+			goto out_cd;
+		}
+
+		cd->fd = openat(destdir->fd, pbuf->path,
+				O_RDONLY | O_DIRECTORY);
+		if (cd->fd < 0) {
+			dbprintf(_("%s%s%s: %s\n"), destdir->path,
+					destdir->sep, pbuf->path,
+					strerror(errno));
+			ret = 1;
+			goto out_cd;
+		}
+	} else {
+		/*
+		 * If path is empty, then we're copying the children of a
+		 * directory into the target directory.
+		 */
+		cd->fd = destdir->fd;
+	}
+
+	ret = rdump_fileattrs_fd(dp, destdir, pbuf, cd->fd);
+	if (ret && strict_errors)
+		goto out_close;
+
+	if (xfs_inode_has_attr_fork(dp)) {
+		ret = rdump_xattrs(tp, dp, destdir, pbuf, cd->fd);
+		if (ret && strict_errors)
+			goto out_close;
+	}
+
+	ret = listdir(tp, dp, rdump_dirent, cd);
+	if (ret && ret != ECANCELED) {
+		dbprintf(_("%s%s%s: readdir %s\n"), destdir->path,
+				destdir->sep, pbuf->path, strerror(ret));
+		if (strict_errors)
+			goto out_close;
+	}
+
+	ret = rdump_timestamps_fd(dp, destdir, pbuf, cd->fd);
+	if (ret && strict_errors)
+		goto out_close;
+
+	ret = 0;
+
+out_close:
+	if (cd->fd != destdir->fd) {
+		ret2 = close(cd->fd);
+		if (ret2) {
+			if (!ret)
+				ret = ret2;
+			dbprintf(_("%s%s%s: %s\n"), destdir->path,
+					destdir->sep, pbuf->path,
+					strerror(errno));
+		}
+	}
+
+out_cd:
+	free(cd);
+	return ret;
+}
+
+/* Copy file data */
+static int
+rdump_regfile_data(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	const struct destdir	*destdir,
+	const struct pathbuf	*pbuf,
+	int			fd)
+{
+	struct xfs_bmbt_irec	irec = { };
+	struct xfs_buftarg	*btp;
+	int			nmaps;
+	off_t			pos = 0;
+	const off_t		isize = ip->i_disk_size;
+	int			ret;
+
+	if (XFS_IS_REALTIME_INODE(ip))
+		btp = ip->i_mount->m_rtdev_targp;
+	else
+		btp = ip->i_mount->m_ddev_targp;
+
+	for (;
+	     pos < isize;
+	     pos = XFS_FSB_TO_B(mp, irec.br_startoff + irec.br_blockcount)) {
+		struct xfs_buf	*bp;
+		off_t		buf_pos;
+		off_t		fd_pos;
+		xfs_fileoff_t	off = XFS_B_TO_FSBT(mp, pos);
+		xfs_filblks_t	max_read = XFS_B_TO_FSB(mp, 1048576);
+		xfs_daddr_t	daddr;
+		size_t		count;
+
+		nmaps = 1;
+		ret = -libxfs_bmapi_read(ip, off, max_read, &irec, &nmaps, 0);
+		if (ret) {
+			dbprintf(_("%s: %s\n"), pbuf->path, strerror(ret));
+			if (strict_errors)
+				return 1;
+			continue;
+		}
+		if (!nmaps)
+			break;
+
+		if (!xfs_bmap_is_written_extent(&irec))
+			continue;
+
+		fd_pos = XFS_FSB_TO_B(mp, irec.br_startoff);
+		if (XFS_IS_REALTIME_INODE(ip))
+			daddr =  xfs_rtb_to_daddr(mp, irec.br_startblock);
+		else
+			daddr = XFS_FSB_TO_DADDR(mp, irec.br_startblock);
+
+		ret = -libxfs_buf_read_uncached(btp, daddr,
+				XFS_FSB_TO_BB(mp, irec.br_blockcount), 0, &bp,
+				NULL);
+		if (ret) {
+			dbprintf(_("%s: reading pos 0x%llx %s\n"), pbuf->path,
+					fd_pos, strerror(ret));
+			if (strict_errors)
+				return 1;
+			continue;
+		}
+
+		count = XFS_FSB_TO_B(mp, irec.br_blockcount);
+		if (fd_pos + count > isize)
+			count = isize - fd_pos;
+
+		buf_pos = 0;
+		while (count > 0) {
+			ssize_t	written;
+
+			written = pwrite(fd, bp->b_addr + buf_pos, count,
+					fd_pos);
+			if (written < 0) {
+				libxfs_buf_relse(bp);
+				dbprintf(_("%s%s%s: writing pos 0x%llx %s\n"),
+						destdir->path, destdir->sep,
+						pbuf->path, fd_pos,
+						strerror(errno));
+				return 1;
+			}
+			if (!written) {
+				libxfs_buf_relse(bp);
+				dbprintf(
+ _("%s%s%s: wrote zero at pos 0x%llx %s\n"),
+						destdir->path, destdir->sep,
+						pbuf->path, fd_pos);
+				return 1;
+			}
+
+			fd_pos += written;
+			buf_pos += written;
+			count -= written;
+		}
+
+		libxfs_buf_relse(bp);
+	}
+
+	ret = ftruncate(fd, isize);
+	if (ret) {
+		dbprintf(_("%s%s%s: setting file length 0x%llx %s\n"),
+				destdir->path, destdir->sep, pbuf->path,
+				isize, strerror(errno));
+		return 1;
+	}
+
+	return 0;
+}
+
+/* Copy a regular file */
+static int
+rdump_regfile(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	const struct destdir	*destdir,
+	const struct pathbuf	*pbuf)
+{
+	int			fd;
+	int			ret, ret2;
+
+	fd = openat(destdir->fd, pbuf->path, O_RDWR | O_CREAT | O_TRUNC, 0600);
+	if (fd < 0) {
+		dbprintf(_("%s%s%s: %s\n"), destdir->path, destdir->sep,
+				pbuf->path, strerror(errno));
+		return 1;
+	}
+
+	ret = rdump_fileattrs_fd(ip, destdir, pbuf, fd);
+	if (ret && strict_errors)
+		goto out_close;
+
+	if (xfs_inode_has_attr_fork(ip)) {
+		ret = rdump_xattrs(tp, ip, destdir, pbuf, fd);
+		if (ret && strict_errors)
+			goto out_close;
+	}
+
+	ret = rdump_regfile_data(tp, ip, destdir, pbuf, fd);
+	if (ret && strict_errors)
+		goto out_close;
+
+	ret = rdump_timestamps_fd(ip, destdir, pbuf, fd);
+	if (ret && strict_errors)
+		goto out_close;
+
+out_close:
+	ret2 = close(fd);
+	if (ret2) {
+		if (!ret)
+			ret = ret2;
+		dbprintf(_("%s%s%s: %s\n"), destdir->path, destdir->sep,
+				pbuf->path, strerror(errno));
+		return 1;
+	}
+
+	return ret;
+}
+
+/* Copy a symlink */
+static int
+rdump_symlink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	const struct destdir	*destdir,
+	const struct pathbuf	*pbuf)
+{
+	char			target[XFS_SYMLINK_MAXLEN + 1];
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	unsigned int		targetlen = ip->i_disk_size;
+	int			ret;
+
+	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
+		memcpy(target, ifp->if_data, targetlen);
+	} else {
+		ret = -libxfs_symlink_remote_read(ip, target);
+		if (ret) {
+			dbprintf(_("%s: %s\n"), pbuf->path, strerror(ret));
+			return strict_errors ? 1 : 0;
+		}
+	}
+	target[targetlen] = 0;
+
+	ret = symlinkat(target, destdir->fd, pbuf->path);
+	if (ret) {
+		dbprintf(_("%s%s%s: %s\n"), destdir->path, destdir->sep,
+				pbuf->path, strerror(errno));
+		return 1;
+	}
+
+	ret = rdump_fileattrs_path(ip, destdir, pbuf);
+	if (ret && strict_errors)
+		goto out;
+
+	ret = rdump_timestamps_path(ip, destdir, pbuf);
+	if (ret && strict_errors)
+		goto out;
+
+	ret = 0;
+out:
+	return ret;
+}
+
+/* Copy a special file */
+static int
+rdump_special(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	const struct destdir	*destdir,
+	const struct pathbuf	*pbuf)
+{
+	const unsigned int	major = IRIX_DEV_MAJOR(VFS_I(ip)->i_rdev);
+	const unsigned int	minor = IRIX_DEV_MINOR(VFS_I(ip)->i_rdev);
+	int			ret;
+
+	ret = mknodat(destdir->fd, pbuf->path, VFS_I(ip)->i_mode & S_IFMT,
+			makedev(major, minor));
+	if (ret) {
+		dbprintf(_("%s%s%s: %s\n"), destdir->path, destdir->sep,
+				pbuf->path, strerror(errno));
+		return 1;
+	}
+
+	ret = rdump_fileattrs_path(ip, destdir, pbuf);
+	if (ret && strict_errors)
+		goto out;
+
+	ret = rdump_timestamps_path(ip, destdir, pbuf);
+	if (ret && strict_errors)
+		goto out;
+
+	ret = 0;
+out:
+	return ret;
+}
+
+/* Dump some kind of file. */
+static int
+rdump_file(
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	const struct destdir	*destdir,
+	struct pathbuf		*pbuf)
+{
+	struct xfs_inode	*ip;
+	int			ret;
+
+	ret = -libxfs_iget(mp, tp, ino, 0, &ip);
+	if (ret) {
+		dbprintf(_("%s: %s\n"), pbuf->path, strerror(ret));
+		return strict_errors ? ret : 0;
+	}
+
+	switch(VFS_I(ip)->i_mode & S_IFMT) {
+	case S_IFDIR:
+		ret = rdump_directory(tp, ip, destdir, pbuf);
+		break;
+	case S_IFREG:
+		ret = rdump_regfile(tp, ip, destdir, pbuf);
+		break;
+	case S_IFLNK:
+		ret = rdump_symlink(tp, ip, destdir, pbuf);
+		break;
+	default:
+		ret = rdump_special(tp, ip, destdir, pbuf);
+		break;
+	}
+
+	libxfs_irele(ip);
+	return ret;
+}
+
+/* Copy one path out of the filesystem. */
+static int
+rdump_path(
+	struct xfs_mount	*mp,
+	bool			sole_path,
+	const char		*path,
+	const struct destdir	*destdir)
+{
+	struct xfs_trans	*tp;
+	struct pathbuf		*pbuf;
+	const char		*basename;
+	ssize_t			pathlen = strlen(path);
+	int			ret = 1;
+
+	/* Set up destination path data */
+	if (pathlen > PATH_MAX) {
+		dbprintf(_("%s: %s\n"), path, strerror(ENAMETOOLONG));
+		return 1;
+	}
+
+	pbuf = calloc(1, sizeof(struct pathbuf));
+	if (!pbuf) {
+		dbprintf(_("allocating path buf: %s\n"), strerror(errno));
+		return 1;
+	}
+	basename = strrchr(path, '/');
+	if (basename) {
+		pbuf->len = pathlen - (basename + 1 - path);
+		memcpy(pbuf->path, basename + 1, pbuf->len);
+	} else {
+		pbuf->len = pathlen;
+		memcpy(pbuf->path, path, pbuf->len);
+	}
+	pbuf->path[pbuf->len] = 0;
+
+	/* Dump the inode referenced. */
+	if (pathlen) {
+		ret = path_walk(mp->m_sb.sb_rootino, path);
+		if (ret) {
+			dbprintf(_("%s: %s\n"), path, strerror(ret));
+			return 1;
+		}
+
+		if (sole_path) {
+			struct xfs_dinode	*dip = iocur_top->data;
+
+			/*
+			 * If this is the only path to copy out and it's a dir,
+			 * then we can copy the children directly into the
+			 * target.
+			 */
+			if (S_ISDIR(be16_to_cpu(dip->di_mode))) {
+				pbuf->len = 0;
+				pbuf->path[0] = 0;
+			}
+		}
+	} else {
+		set_cur_inode(mp->m_sb.sb_rootino);
+	}
+
+	ret = -libxfs_trans_alloc_empty(mp, &tp);
+	if (ret) {
+		dbprintf(_("allocating state: %s\n"), strerror(ret));
+		goto out_pbuf;
+	}
+
+	ret = rdump_file(tp, iocur_top->ino, destdir, pbuf);
+	libxfs_trans_cancel(tp);
+out_pbuf:
+	free(pbuf);
+	return ret;
+}
+
+static int
+rdump_f(
+	int		argc,
+	char		*argv[])
+{
+	struct destdir	destdir;
+	int		i;
+	int		c;
+	int		ret;
+
+	lost_mask = 0;
+	strict_errors = false;
+	while ((c = getopt(argc, argv, "s")) != -1) {
+		switch (c) {
+		case 's':
+			strict_errors = true;
+			break;
+		default:
+			rdump_help();
+			return 0;
+		}
+	}
+
+	if (argc < optind + 1) {
+		dbprintf(
+ _("Must supply destination directory.\n"));
+		return 0;
+	}
+
+	/* Create and open destination directory */
+	destdir.path = argv[argc - 1];
+	ret = mkdir(destdir.path, 0755);
+	if (ret && errno != EEXIST) {
+		dbprintf(_("%s: %s\n"), destdir.path, strerror(errno));
+		exitcode = 1;
+		return 0;
+	}
+
+	if (destdir.path[0] == 0) {
+		dbprintf(
+ _("Destination dir must be at least one character.\n"));
+		exitcode = 1;
+		return 0;
+	}
+
+	if (destdir.path[strlen(destdir.path) - 1] != '/')
+		destdir.sep = "/";
+	else
+		destdir.sep = "";
+	destdir.fd = open(destdir.path, O_DIRECTORY | O_RDONLY);
+	if (destdir.fd < 0) {
+		dbprintf(_("%s: %s\n"), destdir.path, strerror(errno));
+		exitcode = 1;
+		return 0;
+	}
+
+	if (optind == argc - 1) {
+		/* no dirs given, just do the whole fs */
+		push_cur();
+		ret = rdump_path(mp, false, "", &destdir);
+		pop_cur();
+		if (ret)
+			exitcode = 1;
+		goto out_close;
+	}
+
+	for (i = optind; i < argc - 1; i++) {
+		size_t	len = strlen(argv[i]);
+
+		/* trim trailing slashes */
+		while (len && argv[i][len - 1] == '/')
+			len--;
+		argv[i][len] = 0;
+
+		push_cur();
+		ret = rdump_path(mp, argc == optind + 2, argv[i], &destdir);
+		pop_cur();
+
+		if (ret) {
+			exitcode = 1;
+			if (strict_errors)
+				break;
+		}
+	}
+
+out_close:
+	ret = close(destdir.fd);
+	if (ret) {
+		dbprintf(_("%s: %s\n"), destdir.path, strerror(errno));
+		exitcode = 1;
+	}
+
+	if (lost_mask & LOST_OWNER)
+		dbprintf(_("%s: some uid/gid could not be set\n"),
+				destdir.path);
+	if (lost_mask & LOST_MODE)
+		dbprintf(_("%s: some file modes could not be set\n"),
+				destdir.path);
+	if (lost_mask & LOST_TIME)
+		dbprintf(_("%s: some timestamps could not be set\n"),
+				destdir.path);
+	if (lost_mask & LOST_SOME_FSXATTR)
+		dbprintf(_("%s: some xfs file attr bits could not be set\n"),
+				destdir.path);
+	if (lost_mask & LOST_FSXATTR)
+		dbprintf(_("%s: some xfs file attrs could not be set\n"),
+				destdir.path);
+	if (lost_mask & LOST_XATTR)
+		dbprintf(_("%s: some extended xattrs could not be set\n"),
+				destdir.path);
+
+	return 0;
+}
+
+static struct cmdinfo rdump_cmd = {
+	.name		= "rdump",
+	.cfunc		= rdump_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.canpush	= 0,
+	.args		= "[-s] [paths...] dest_directory",
+	.help		= rdump_help,
+};
+
+void
+rdump_init(void)
+{
+	rdump_cmd.oneline = _("recover files out of a filesystem");
+	add_command(&rdump_cmd);
+}
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 530feef2a47db8..14a67c8c24dd7e 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -47,6 +47,7 @@
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
 #define xfs_attr_removename		libxfs_attr_removename
+#define xfs_attr_rmtval_get		libxfs_attr_rmtval_get
 #define xfs_attr_set			libxfs_attr_set
 #define xfs_attr_sethash		libxfs_attr_sethash
 #define xfs_attr_sf_firstentry		libxfs_attr_sf_firstentry
@@ -353,6 +354,7 @@
 #define xfs_sb_version_to_features	libxfs_sb_version_to_features
 #define xfs_symlink_blocks		libxfs_symlink_blocks
 #define xfs_symlink_hdr_ok		libxfs_symlink_hdr_ok
+#define xfs_symlink_remote_read		libxfs_symlink_remote_read
 #define xfs_symlink_write_target	libxfs_symlink_write_target
 
 #define xfs_trans_add_item		libxfs_trans_add_item
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 08f38f37ca01cc..2a9322560584b0 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1132,6 +1132,32 @@ .SH COMMANDS
 Exit
 .BR xfs_db .
 .TP
+.BI "rdump [-s] [" "paths..." "] " "destination_dir"
+Recover the files given by the
+.B path
+arguments by copying them of the filesystem into the directory specified in
+.BR destination_dir .
+
+If the
+.B -s
+option is specified, errors are fatal.
+By default, read errors are ignored in favor of recovering as much data from
+the filesystem as possible.
+
+If zero
+.B paths
+are specified, the entire filesystem is dumped.
+If only one
+.B path
+is specified and it is a directory, the children of that directory will be
+copied directly to the destination.
+If multiple
+.B paths
+are specified, each file is copied into the directory as a new child.
+
+If possible, sparse holes, xfs file attributes, and extended attributes will be
+preserved.
+.TP
 .BI "rgresv [" rgno ]
 Displays the per-rtgroup reservation size, and per-rtgroup
 reservation usage for a given realtime allocation group.


