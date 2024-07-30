Return-Path: <linux-xfs+bounces-11106-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E5D94035C
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 03:20:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CB1C1F23EAE
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 01:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E54DA2C95;
	Tue, 30 Jul 2024 01:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/JXsDsQ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A302F28EB
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302425; cv=none; b=Oh5fVGPufpFQUlEDlr7fozmZhM6t6uP4hmcgrsyqIIYRgMk5ptbmtF8itSX5zEqNVgpRC7MRSInYg2J6Fc1ivkEGoZEbVqaRrwukxClw7B0BDJ8QFzs40FLYRvTJZ9Swk2GQdHLLTEM8dRmOboE4sXElw8WsEeGFmqL7j5ZmKso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302425; c=relaxed/simple;
	bh=nyJmCVSYyoMqnMR1MYXE44xZCkgvzOAaHeL7Pmq1dO4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WUm9o1Idnci6pnK8QfdOie0XqrS8lI2zswPd6pkf+OAt/cgjRkbX75UM2U3DyreyNMy3CSUsO3N6NUu9CYr/PHWNWkf/64V8dmaCxbPkMgwBHW6m7bKhGBqYt5RUU/3DD69M1yTMpwRqKaKUVoMlWDsjyyzQBw2kbAZUNstS4QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/JXsDsQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75708C32786;
	Tue, 30 Jul 2024 01:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302425;
	bh=nyJmCVSYyoMqnMR1MYXE44xZCkgvzOAaHeL7Pmq1dO4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X/JXsDsQAbZ9HXB5p2RnD9ksmtkuwW3xUgWODZiGz3E+U2X62yD2E5kMzM1HV1Cz0
	 mZMxxnhQeNaO/xWSI2pgpQkBdWHALUiTuaF/d3oQ43Jjt7uNrZGyJs2tX99al7drhu
	 w/6/+AEtdE1EhcpjjBvDcb/w6MYKry4nSmkDJYJBkrlu209/OUi9EWm6b8KwWQ+00u
	 UWLgcVqVnQ0RPJq0xL6TBzA53aXu9HUJtNQ0eD/iTAR9Pt2xYb8BdTT/WNNVwbclLf
	 XTVOBA/9ZylwcF/7ftCqD5hUnvy7Ip5+/jPKH+3q8ZxTjgFL9/jW/vLxlwGkH/9FF7
	 rMCnReldXdzsQ==
Date: Mon, 29 Jul 2024 18:20:24 -0700
Subject: [PATCH 06/24] libfrog: add parent pointer support code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850601.1350924.3542258079443836387.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
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

Add some support code to libfrog so that client programs can walk file
descriptors and handles upwards through the directory tree; and obtain a
reasonable file path from a file descriptor/handle.  This code will be
used in xfsprogs utilities.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/handle.h     |    1 
 libfrog/Makefile     |    2 
 libfrog/getparents.c |  355 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/getparents.h |   42 ++++++
 libfrog/paths.c      |  168 ++++++++++++++++++++++++
 libfrog/paths.h      |   25 ++++
 libhandle/handle.c   |    7 +
 7 files changed, 597 insertions(+), 3 deletions(-)
 create mode 100644 libfrog/getparents.c
 create mode 100644 libfrog/getparents.h


diff --git a/include/handle.h b/include/handle.h
index 34246f385..ba0650051 100644
--- a/include/handle.h
+++ b/include/handle.h
@@ -17,6 +17,7 @@ struct parent;
 extern int  path_to_handle (char *__path, void **__hanp, size_t *__hlen);
 extern int  path_to_fshandle (char *__path, void **__fshanp, size_t *__fshlen);
 extern int  fd_to_handle (int fd, void **hanp, size_t *hlen);
+extern int  handle_to_fsfd(void *, char **);
 extern int  handle_to_fshandle (void *__hanp, size_t __hlen, void **__fshanp,
 				size_t *__fshlen);
 extern void free_handle (void *__hanp, size_t __hlen);
diff --git a/libfrog/Makefile b/libfrog/Makefile
index acfa228bc..0b5b23893 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -20,6 +20,7 @@ convert.c \
 crc32.c \
 file_exchange.c \
 fsgeom.c \
+getparents.c \
 histogram.c \
 list_sort.c \
 linux.c \
@@ -46,6 +47,7 @@ dahashselftest.h \
 div64.h \
 file_exchange.h \
 fsgeom.h \
+getparents.h \
 histogram.h \
 logging.h \
 paths.h \
diff --git a/libfrog/getparents.c b/libfrog/getparents.c
new file mode 100644
index 000000000..9118b0ff3
--- /dev/null
+++ b/libfrog/getparents.c
@@ -0,0 +1,355 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2017-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "platform_defs.h"
+#include "xfs.h"
+#include "xfs_arch.h"
+#include "list.h"
+#include "paths.h"
+#include "handle.h"
+#include "libfrog/getparents.h"
+
+/* Allocate a buffer for the xfs_getparent_rec array. */
+static void *
+alloc_records(
+	struct xfs_getparents	*gp,
+	size_t			bufsize)
+{
+	void			*buf;
+
+	if (bufsize >= UINT32_MAX) {
+		errno = ENOMEM;
+		return NULL;
+	} else if (!bufsize) {
+		bufsize = XFS_XATTR_LIST_MAX;
+	}
+
+	buf = malloc(bufsize);
+	if (!buf)
+		return NULL;
+
+	gp->gp_buffer = (uintptr_t)buf;
+	gp->gp_bufsize = bufsize;
+	return buf;
+}
+
+/* Copy a file handle. */
+static inline void
+copy_handle(
+	struct xfs_handle	*dest,
+	const struct xfs_handle	*src)
+{
+	memcpy(dest, src, sizeof(struct xfs_handle));
+}
+
+/* Initiate a callback for each parent pointer. */
+static int
+walk_parent_records(
+	struct xfs_getparents	*gp,
+	walk_parent_fn		fn,
+	void			*arg)
+{
+	struct xfs_getparents_rec *gpr;
+	int			ret;
+
+	if (gp->gp_oflags & XFS_GETPARENTS_OFLAG_ROOT) {
+		struct parent_rec	rec = {
+			.p_flags	= PARENTREC_FILE_IS_ROOT,
+		};
+
+		return fn(&rec, arg);
+	}
+
+	for (gpr = xfs_getparents_first_rec(gp);
+	     gpr != NULL;
+	     gpr = xfs_getparents_next_rec(gp, gpr)) {
+		struct parent_rec	rec = { };
+
+		if (gpr->gpr_name[0] == 0)
+			break;
+
+		copy_handle(&rec.p_handle, &gpr->gpr_parent);
+		rec.p_name = gpr->gpr_name;
+
+		ret = fn(&rec, arg);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* Walk all parent pointers of this fd.  Returns 0 or positive errno. */
+int
+fd_walk_parents(
+	int			fd,
+	size_t			bufsize,
+	walk_parent_fn		fn,
+	void			*arg)
+{
+	struct xfs_getparents	gp = { };
+	void			*buf;
+	int			ret;
+
+	buf = alloc_records(&gp, bufsize);
+	if (!buf)
+		return errno;
+
+	while ((ret = ioctl(fd, XFS_IOC_GETPARENTS, &gp)) == 0) {
+		ret = walk_parent_records(&gp, fn, arg);
+		if (ret)
+			goto out_buf;
+		if (gp.gp_oflags & XFS_GETPARENTS_OFLAG_DONE)
+			break;
+	}
+	if (ret)
+		ret = errno;
+
+out_buf:
+	free(buf);
+	return ret;
+}
+
+/* Walk all parent pointers of this handle.  Returns 0 or positive errno. */
+int
+handle_walk_parents(
+	const void		*hanp,
+	size_t			hlen,
+	size_t			bufsize,
+	walk_parent_fn		fn,
+	void			*arg)
+{
+	struct xfs_getparents_by_handle	gph = { };
+	void			*buf;
+	char			*mntpt;
+	int			fd;
+	int			ret;
+
+	if (hlen != sizeof(struct xfs_handle))
+		return EINVAL;
+
+	/*
+	 * This function doesn't modify the handle, but we don't want to have
+	 * to bump the libhandle major version just to change that.
+	 */
+	fd = handle_to_fsfd((void *)hanp, &mntpt);
+	if (fd < 0)
+		return errno;
+
+	buf = alloc_records(&gph.gph_request, bufsize);
+	if (!buf)
+		return errno;
+
+	copy_handle(&gph.gph_handle, hanp);
+	while ((ret = ioctl(fd, XFS_IOC_GETPARENTS_BY_HANDLE, &gph)) == 0) {
+		ret = walk_parent_records(&gph.gph_request, fn, arg);
+		if (ret)
+			goto out_buf;
+		if (gph.gph_request.gp_oflags & XFS_GETPARENTS_OFLAG_DONE)
+			break;
+	}
+	if (ret)
+		ret = errno;
+
+out_buf:
+	free(buf);
+	return ret;
+}
+
+struct walk_ppaths_info {
+	/* Callback */
+	walk_path_fn		fn;
+	void			*arg;
+
+	/* Mountpoint of this filesystem. */
+	char			*mntpt;
+
+	/* Path that we're constructing. */
+	struct path_list	*path;
+
+	size_t			ioctl_bufsize;
+};
+
+/*
+ * Recursively walk upwards through the directory tree, changing out the path
+ * components as needed.  Call the callback when we have a complete path.
+ */
+static int
+find_parent_component(
+	const struct parent_rec	*rec,
+	void			*arg)
+{
+	struct walk_ppaths_info	*wpi = arg;
+	struct path_component	*pc;
+	int			ret;
+
+	if (rec->p_flags & PARENTREC_FILE_IS_ROOT)
+		return wpi->fn(wpi->mntpt, wpi->path, wpi->arg);
+
+	/*
+	 * If we detect a directory tree cycle, give up.  We never made any
+	 * guarantees about concurrent tree updates.
+	 */
+	if (path_will_loop(wpi->path, rec->p_handle.ha_fid.fid_ino))
+		return 0;
+
+	pc = path_component_init(rec->p_name, rec->p_handle.ha_fid.fid_ino);
+	if (!pc)
+		return errno;
+	path_list_add_parent_component(wpi->path, pc);
+
+	ret = handle_walk_parents(&rec->p_handle, sizeof(rec->p_handle),
+			wpi->ioctl_bufsize, find_parent_component, wpi);
+
+	path_list_del_component(wpi->path, pc);
+	path_component_free(pc);
+	return ret;
+}
+
+/*
+ * Call the given function on all known paths from the vfs root to the inode
+ * described in the handle.  Returns 0 for success or positive errno.
+ */
+int
+handle_walk_paths(
+	const void		*hanp,
+	size_t			hlen,
+	size_t			ioctl_bufsize,
+	walk_path_fn		fn,
+	void			*arg)
+{
+	struct walk_ppaths_info	wpi = {
+		.ioctl_bufsize	= ioctl_bufsize,
+	};
+	int			ret;
+
+	/*
+	 * This function doesn't modify the handle, but we don't want to have
+	 * to bump the libhandle major version just to change that.
+	 */
+	ret = handle_to_fsfd((void *)hanp, &wpi.mntpt);
+	if (ret < 0)
+		return errno;
+
+	wpi.path = path_list_init();
+	if (!wpi.path)
+		return errno;
+	wpi.fn = fn;
+	wpi.arg = arg;
+
+	ret = handle_walk_parents(hanp, hlen, ioctl_bufsize,
+			find_parent_component, &wpi);
+
+	path_list_free(wpi.path);
+	return ret;
+}
+
+/*
+ * Call the given function on all known paths from the vfs root to the inode
+ * referred to by the file description.  Returns 0 or positive errno.
+ */
+int
+fd_walk_paths(
+	int			fd,
+	size_t			ioctl_bufsize,
+	walk_path_fn		fn,
+	void			*arg)
+{
+	void			*hanp;
+	size_t			hlen;
+	int			ret;
+
+	ret = fd_to_handle(fd, &hanp, &hlen);
+	if (ret)
+		return errno;
+
+	ret = handle_walk_paths(hanp, hlen, ioctl_bufsize, fn, arg);
+	free_handle(hanp, hlen);
+	return ret;
+}
+
+struct gather_path_info {
+	char			*buf;
+	size_t			len;
+	size_t			written;
+};
+
+/* Helper that stringifies the first full path that we find. */
+static int
+path_to_string(
+	const char		*mntpt,
+	const struct path_list	*path,
+	void			*arg)
+{
+	struct gather_path_info	*gpi = arg;
+	int			mntpt_len = strlen(mntpt);
+	int			ret;
+
+	/* Trim trailing slashes from the mountpoint */
+	while (mntpt_len > 0 && mntpt[mntpt_len - 1] == '/')
+		mntpt_len--;
+
+	ret = snprintf(gpi->buf, gpi->len, "%.*s", mntpt_len, mntpt);
+	if (ret != mntpt_len)
+		return ENAMETOOLONG;
+	gpi->written += ret;
+
+	ret = path_list_to_string(path, gpi->buf + ret, gpi->len - ret);
+	if (ret < 0)
+		return ENAMETOOLONG;
+
+	gpi->written += ret;
+	return ECANCELED;
+}
+
+/*
+ * Return any eligible path to this file handle.  Returns 0 for success or
+ * positive errno.
+ */
+int
+handle_to_path(
+	const void		*hanp,
+	size_t			hlen,
+	size_t			ioctl_bufsize,
+	char			*path,
+	size_t			pathlen)
+{
+	struct gather_path_info	gpi = { .buf = path, .len = pathlen };
+	int			ret;
+
+	ret = handle_walk_paths(hanp, hlen, ioctl_bufsize, path_to_string,
+			&gpi);
+	if (ret && ret != ECANCELED)
+		return ret;
+	if (!gpi.written)
+		return ENODATA;
+
+	path[gpi.written] = 0;
+	return 0;
+}
+
+/*
+ * Return any eligible path to this file description.  Returns 0 for success
+ * or positive errno.
+ */
+int
+fd_to_path(
+	int			fd,
+	size_t			ioctl_bufsize,
+	char			*path,
+	size_t			pathlen)
+{
+	struct gather_path_info	gpi = { .buf = path, .len = pathlen };
+	int			ret;
+
+	ret = fd_walk_paths(fd, ioctl_bufsize, path_to_string, &gpi);
+	if (ret && ret != ECANCELED)
+		return ret;
+	if (!gpi.written)
+		return ENODATA;
+
+	path[gpi.written] = 0;
+	return 0;
+}
diff --git a/libfrog/getparents.h b/libfrog/getparents.h
new file mode 100644
index 000000000..8098d5942
--- /dev/null
+++ b/libfrog/getparents.h
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef	__LIBFROG_GETPARENTS_H_
+#define	__LIBFROG_GETPARENTS_H_
+
+struct path_list;
+
+struct parent_rec {
+	/* File handle to parent directory */
+	struct xfs_handle	p_handle;
+
+	/* Null-terminated directory entry name in the parent */
+	char			*p_name;
+
+	/* Flags for this record; see PARENTREC_* below */
+	uint32_t		p_flags;
+};
+
+/* This is the root directory. */
+#define PARENTREC_FILE_IS_ROOT	(1U << 0)
+
+typedef int (*walk_parent_fn)(const struct parent_rec *rec, void *arg);
+
+int fd_walk_parents(int fd, size_t ioctl_bufsize, walk_parent_fn fn, void *arg);
+int handle_walk_parents(const void *hanp, size_t hanlen, size_t ioctl_bufsize,
+		walk_parent_fn fn, void *arg);
+
+typedef int (*walk_path_fn)(const char *mntpt, const struct path_list *path,
+		void *arg);
+
+int fd_walk_paths(int fd, size_t ioctl_bufsize, walk_path_fn fn, void *arg);
+int handle_walk_paths(const void *hanp, size_t hanlen, size_t ioctl_bufsize,
+		walk_path_fn fn, void *arg);
+
+int fd_to_path(int fd, size_t ioctl_bufsize, char *path, size_t pathlen);
+int handle_to_path(const void *hanp, size_t hlen, size_t ioctl_bufsize,
+		char *path, size_t pathlen);
+
+#endif /* __LIBFROG_GETPARENTS_H_ */
diff --git a/libfrog/paths.c b/libfrog/paths.c
index 320b26dbf..a5dfab48e 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -16,6 +16,7 @@
 #include "input.h"
 #include "projects.h"
 #include <mntent.h>
+#include "list.h"
 #include <limits.h>
 
 extern char *progname;
@@ -560,3 +561,170 @@ fs_table_insert_project_path(
 
 	return error;
 }
+
+/* Structured path components. */
+
+struct path_list {
+	struct list_head	p_head;
+};
+
+struct path_component {
+	struct list_head	pc_list;
+	uint64_t		pc_ino;
+	char			*pc_fname;
+};
+
+/* Initialize a path component with a given name. */
+struct path_component *
+path_component_init(
+	const char		*name,
+	uint64_t		ino)
+{
+	struct path_component	*pc;
+
+	pc = malloc(sizeof(struct path_component));
+	if (!pc)
+		return NULL;
+	INIT_LIST_HEAD(&pc->pc_list);
+	pc->pc_fname = strdup(name);
+	if (!pc->pc_fname) {
+		free(pc);
+		return NULL;
+	}
+	pc->pc_ino = ino;
+	return pc;
+}
+
+/* Free a path component. */
+void
+path_component_free(
+	struct path_component	*pc)
+{
+	free(pc->pc_fname);
+	free(pc);
+}
+
+/* Initialize a pathname or returns positive errno. */
+struct path_list *
+path_list_init(void)
+{
+	struct path_list	*path;
+
+	path = malloc(sizeof(struct path_list));
+	if (!path)
+		return NULL;
+	INIT_LIST_HEAD(&path->p_head);
+	return path;
+}
+
+/* Empty out a pathname. */
+void
+path_list_free(
+	struct path_list	*path)
+{
+	struct path_component	*pos;
+	struct path_component	*n;
+
+	list_for_each_entry_safe(pos, n, &path->p_head, pc_list) {
+		path_list_del_component(path, pos);
+		path_component_free(pos);
+	}
+	free(path);
+}
+
+/* Add a parent component to a pathname. */
+void
+path_list_add_parent_component(
+	struct path_list	*path,
+	struct path_component	*pc)
+{
+	list_add(&pc->pc_list, &path->p_head);
+}
+
+/* Add a component to a pathname. */
+void
+path_list_add_component(
+	struct path_list	*path,
+	struct path_component	*pc)
+{
+	list_add_tail(&pc->pc_list, &path->p_head);
+}
+
+/* Remove a component from a pathname. */
+void
+path_list_del_component(
+	struct path_list	*path,
+	struct path_component	*pc)
+{
+	list_del_init(&pc->pc_list);
+}
+
+/*
+ * Convert a pathname into a string or returns -1 if the buffer isn't long
+ * enough.
+ */
+ssize_t
+path_list_to_string(
+	const struct path_list	*path,
+	char			*buf,
+	size_t			buflen)
+{
+	struct path_component	*pos;
+	char			*buf_end = buf + buflen;
+	ssize_t			bytes = 0;
+	int			ret;
+
+	list_for_each_entry(pos, &path->p_head, pc_list) {
+		if (buf >= buf_end)
+			return -1;
+
+		ret = snprintf(buf, buflen, "/%s", pos->pc_fname);
+		if (ret < 0 || ret >= buflen)
+			return -1;
+
+		bytes += ret;
+		buf += ret;
+		buflen -= ret;
+	}
+	return bytes;
+}
+
+/* Walk each component of a path. */
+int
+path_walk_components(
+	const struct path_list	*path,
+	path_walk_fn_t		fn,
+	void			*arg)
+{
+	struct path_component	*pos;
+	int			ret;
+
+	list_for_each_entry(pos, &path->p_head, pc_list) {
+		ret = fn(pos->pc_fname, pos->pc_ino, arg);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* Will this path contain a loop if we add this inode? */
+bool
+path_will_loop(
+	const struct path_list	*path_list,
+	uint64_t		ino)
+{
+	struct path_component	*pc;
+	unsigned int		nr = 0;
+
+	list_for_each_entry(pc, &path_list->p_head, pc_list) {
+		if (pc->pc_ino == ino)
+			return true;
+
+		/* 256 path components should be enough for anyone. */
+		if (++nr > 256)
+			return true;
+	}
+
+	return false;
+}
diff --git a/libfrog/paths.h b/libfrog/paths.h
index f20a2c3ef..306fd3cb8 100644
--- a/libfrog/paths.h
+++ b/libfrog/paths.h
@@ -58,4 +58,29 @@ typedef struct fs_cursor {
 extern void fs_cursor_initialise(char *__dir, uint __flags, fs_cursor_t *__cp);
 extern fs_path_t *fs_cursor_next_entry(fs_cursor_t *__cp);
 
+/* Path information. */
+
+struct path_list;
+struct path_component;
+
+struct path_component *path_component_init(const char *name, uint64_t ino);
+void path_component_free(struct path_component *pc);
+
+struct path_list *path_list_init(void);
+void path_list_free(struct path_list *path);
+void path_list_add_parent_component(struct path_list *path,
+		struct path_component *pc);
+void path_list_add_component(struct path_list *path, struct path_component *pc);
+void path_list_del_component(struct path_list *path, struct path_component *pc);
+
+ssize_t path_list_to_string(const struct path_list *path, char *buf,
+		size_t buflen);
+
+typedef int (*path_walk_fn_t)(const char *name, uint64_t ino, void *arg);
+
+int path_walk_components(const struct path_list *path, path_walk_fn_t fn,
+		void *arg);
+
+bool path_will_loop(const struct path_list *path, uint64_t ino);
+
 #endif	/* __LIBFROG_PATH_H__ */
diff --git a/libhandle/handle.c b/libhandle/handle.c
index 333c21909..1e8fe9ac5 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -29,7 +29,6 @@ typedef union {
 } comarg_t;
 
 static int obj_to_handle(char *, int, unsigned int, comarg_t, void**, size_t*);
-static int handle_to_fsfd(void *, char **);
 static char *path_to_fspath(char *path);
 
 
@@ -203,8 +202,10 @@ handle_to_fshandle(
 	return 0;
 }
 
-static int
-handle_to_fsfd(void *hanp, char **path)
+int
+handle_to_fsfd(
+	void		*hanp,
+	char		**path)
 {
 	struct fdhash	*fdhp;
 


