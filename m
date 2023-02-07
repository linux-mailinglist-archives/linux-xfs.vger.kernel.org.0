Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D32968DE69
	for <lists+linux-xfs@lfdr.de>; Tue,  7 Feb 2023 18:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbjBGRBs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 Feb 2023 12:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjBGRBr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2023 12:01:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705D33585;
        Tue,  7 Feb 2023 09:01:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F1F7B81A1D;
        Tue,  7 Feb 2023 17:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06A0C433EF;
        Tue,  7 Feb 2023 17:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675789301;
        bh=An3PMZ3VnMSqD4SFwiUIRoS/DMm/0dSUowih7rT5OjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NZeXDSaIUWR+hEU89ABUdWOUFQpbk8Yz0yip/kbA3/kahwzLCoQLI/V/SWqwClHvK
         R0ejSENk4aSTkv8v4QYM3bMp4P8GfdGdpfmFASfs+tFoHJkVCDBtkltE4TauxTvbSu
         aHRY7JGA0mPI/rTPmExYo2i0hnwcmu/2FrKCwJYmMpLL5BR/wYS+iT4Tm4myWOdwVH
         EEU8b+QJV1cv6fs5XQ8sxe5anvBIl0JNot+90EXUyGOhcuBskBA5CfKWclwdZUueTx
         DW8STkFJw5045WYVpCQEvIqZ2dEZG0O8+Uu1PyIEB4/HPVX7x/ey8lRzTu2gtjskW9
         hewxio5+rhsRQ==
Date:   Tue, 7 Feb 2023 09:01:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v24.1 3/5] fuzzy: add a custom xfs find utility for scrub
 stress tests
Message-ID: <Y+KD9Qf80CuLl2ZD@magnolia>
References: <167243874614.722028.11987534226186856347.stgit@magnolia>
 <167243874650.722028.10607547751700517177.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243874650.722028.10607547751700517177.stgit@magnolia>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new find(1) like utility that doesn't crash on directory tree
changes (like find does due to bugs in its loop detector) and actually
implements the custom xfs attribute predicates that we need for scrub
stress tests.  This program will be needed for a future patch where we
add stress tests for scrub and repair of file metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v24.1: apply some autoupdate love to the m4 macros
---
 configure.ac          |    5 +
 include/builddefs.in  |    4 +
 m4/package_libcdev.m4 |   44 +++++++
 m4/package_xfslibs.m4 |   15 +++
 src/Makefile          |   10 ++
 src/xfsfind.c         |  290 +++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 368 insertions(+)
 create mode 100644 src/xfsfind.c

diff --git a/configure.ac b/configure.ac
index cbf8377988..e92bd6b26d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -66,6 +66,11 @@ AC_PACKAGE_WANT_LINUX_FS_H
 AC_PACKAGE_WANT_LIBBTRFSUTIL
 
 AC_HAVE_COPY_FILE_RANGE
+AC_HAVE_SEEK_DATA
+AC_HAVE_BMV_OF_SHARED
+AC_HAVE_NFTW
+AC_HAVE_RLIMIT_NOFILE
+
 AC_CHECK_FUNCS([renameat2])
 AC_CHECK_FUNCS([reallocarray])
 AC_CHECK_TYPES([struct mount_attr], [], [], [[#include <linux/mount.h>]])
diff --git a/include/builddefs.in b/include/builddefs.in
index 6641209f81..dab10c968f 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -68,6 +68,10 @@ HAVE_FIEMAP = @have_fiemap@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
 HAVE_LIBBTRFSUTIL = @have_libbtrfsutil@
+HAVE_SEEK_DATA = @have_seek_data@
+HAVE_NFTW = @have_nftw@
+HAVE_BMV_OF_SHARED = @have_bmv_of_shared@
+HAVE_RLIMIT_NOFILE = @have_rlimit_nofile@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 5c76c0f73e..98572aecd9 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -110,3 +110,47 @@ AC_DEFUN([AC_HAVE_COPY_FILE_RANGE],
     AC_SUBST(have_copy_file_range)
   ])
 
+# Check if we have SEEK_DATA
+AC_DEFUN([AC_HAVE_SEEK_DATA],
+  [ AC_MSG_CHECKING([for SEEK_DATA])
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <sys/types.h>
+#include <unistd.h>
+    ]], [[
+         lseek(-1, 0, SEEK_DATA);
+    ]])],[have_seek_data=yes
+       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
+    AC_SUBST(have_seek_data)
+  ])
+
+# Check if we have nftw
+AC_DEFUN([AC_HAVE_NFTW],
+  [ AC_MSG_CHECKING([for nftw])
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <stddef.h>
+#include <ftw.h>
+    ]], [[
+         nftw("/", (int (*)(const char *, const struct stat *, int, struct FTW *))1, 0, 0);
+    ]])],[have_nftw=yes
+       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
+    AC_SUBST(have_nftw)
+  ])
+
+# Check if we have RLIMIT_NOFILE
+AC_DEFUN([AC_HAVE_RLIMIT_NOFILE],
+  [ AC_MSG_CHECKING([for RLIMIT_NOFILE])
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <sys/time.h>
+#include <sys/resource.h>
+    ]], [[
+         struct rlimit rlimit;
+
+         rlimit.rlim_cur = 0;
+         getrlimit(RLIMIT_NOFILE, &rlimit);
+    ]])],[have_rlimit_nofile=yes
+       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
+    AC_SUBST(have_rlimit_nofile)
+  ])
diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
index 0746cd1dc5..8ef58cc064 100644
--- a/m4/package_xfslibs.m4
+++ b/m4/package_xfslibs.m4
@@ -104,3 +104,18 @@ AC_DEFUN([AC_PACKAGE_NEED_XFSCTL_MACRO],
         exit 1
       ])
   ])
+
+# Check if we have BMV_OF_SHARED from the GETBMAPX ioctl
+AC_DEFUN([AC_HAVE_BMV_OF_SHARED],
+  [ AC_MSG_CHECKING([for BMV_OF_SHARED])
+    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <xfs/xfs.h>
+    ]], [[
+         struct getbmapx obj;
+         ioctl(-1, XFS_IOC_GETBMAPX, &obj);
+         obj.bmv_oflags |= BMV_OF_SHARED;
+    ]])],[have_bmv_of_shared=yes
+       AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
+    AC_SUBST(have_bmv_of_shared)
+  ])
diff --git a/src/Makefile b/src/Makefile
index f270015ce8..a574f7bd03 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -83,6 +83,16 @@ ifeq ($(HAVE_LIBCAP), true)
 LLDLIBS += -lcap
 endif
 
+ifeq ($(HAVE_SEEK_DATA), yes)
+ ifeq ($(HAVE_NFTW), yes)
+  ifeq ($(HAVE_BMV_OF_SHARED), yes)
+   ifeq ($(HAVE_RLIMIT_NOFILE), yes)
+     TARGETS += xfsfind
+   endif
+  endif
+ endif
+endif
+
 CFILES = $(TARGETS:=.c)
 LDIRT = $(TARGETS) fssum
 
diff --git a/src/xfsfind.c b/src/xfsfind.c
new file mode 100644
index 0000000000..6b0a93e793
--- /dev/null
+++ b/src/xfsfind.c
@@ -0,0 +1,290 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * find(1) but with special predicates for finding XFS attributes.
+ * Copyright (C) 2022 Oracle.
+ */
+#include <sys/time.h>
+#include <sys/resource.h>
+#include <sys/types.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <ftw.h>
+#include <linux/fs.h>
+#include <xfs/xfs.h>
+
+#include "global.h"
+
+static int want_anyfile;
+static int want_datafile;
+static int want_attrfile;
+static int want_dir;
+static int want_regfile;
+static int want_sharedfile;
+static int report_errors = 1;
+
+static int
+check_datafile(
+	const char		*path,
+	int			fd)
+{
+	off_t			off;
+
+	off = lseek(fd, 0, SEEK_DATA);
+	if (off >= 0)
+		return 1;
+
+	if (errno == ENXIO)
+		return 0;
+
+	if (report_errors)
+		perror(path);
+
+	return -1;
+}
+
+static int
+check_attrfile(
+	const char		*path,
+	int			fd)
+{
+	struct fsxattr		fsx;
+	int			ret;
+
+	ret = ioctl(fd, XFS_IOC_FSGETXATTR, &fsx);
+	if (ret) {
+		if (report_errors)
+			perror(path);
+		return -1;
+	}
+
+	if (want_attrfile && (fsx.fsx_xflags & XFS_XFLAG_HASATTR))
+		return 1;
+	return 0;
+}
+
+#define BMAP_NR			33
+static struct getbmapx		bmaps[BMAP_NR];
+
+static int
+check_sharedfile(
+	const char		*path,
+	int			fd)
+{
+	struct getbmapx		*key = &bmaps[0];
+	unsigned int		i;
+	int			ret;
+
+	memset(key, 0, sizeof(struct getbmapx));
+	key->bmv_length = ULLONG_MAX;
+	/* no holes and don't flush dirty pages */
+	key->bmv_iflags = BMV_IF_DELALLOC | BMV_IF_NO_HOLES;
+	key->bmv_count = BMAP_NR;
+
+	while ((ret = ioctl(fd, XFS_IOC_GETBMAPX, bmaps)) == 0) {
+		struct getbmapx	*p = &bmaps[1];
+		xfs_off_t	new_off;
+
+		for (i = 0; i < key->bmv_entries; i++, p++) {
+			if (p->bmv_oflags & BMV_OF_SHARED)
+				return 1;
+		}
+
+		if (key->bmv_entries == 0)
+			break;
+		p = key + key->bmv_entries;
+		if (p->bmv_oflags & BMV_OF_LAST)
+			return 0;
+
+		new_off = p->bmv_offset + p->bmv_length;
+		key->bmv_length -= new_off - key->bmv_offset;
+		key->bmv_offset = new_off;
+	}
+	if (ret < 0) {
+		if (report_errors)
+			perror(path);
+		return -1;
+	}
+
+	return 0;
+}
+
+static void
+print_help(
+	const char		*name)
+{
+	printf("Usage: %s [OPTIONS] path\n", name);
+	printf("\n");
+	printf("Print all file paths matching any of the given predicates.\n");
+	printf("\n");
+	printf("-a	Match files with xattrs.\n");
+	printf("-b	Match files with data blocks.\n");
+	printf("-d	Match directories.\n");
+	printf("-q	Ignore errors while walking directory tree.\n");
+	printf("-r	Match regular files.\n");
+	printf("-s	Match files with shared blocks.\n");
+	printf("\n");
+	printf("If no matching options are given, match all files found.\n");
+}
+
+static int
+visit(
+	const char		*path,
+	const struct stat	*sb,
+	int			typeflag,
+	struct FTW		*ftwbuf)
+{
+	int			printme = 1;
+	int			fd = -1;
+	int			retval = FTW_CONTINUE;
+
+	if (want_anyfile)
+		goto out;
+	if (want_regfile && typeflag == FTW_F)
+		goto out;
+	if (want_dir && typeflag == FTW_D)
+		goto out;
+
+	/*
+	 * We can only open directories and files; screen out everything else.
+	 * Note that nftw lies and reports FTW_F for device files, so check the
+	 * statbuf mode too.
+	 */
+	if (typeflag != FTW_F && typeflag != FTW_D) {
+		printme = 0;
+		goto out;
+	}
+
+	if (!S_ISREG(sb->st_mode) && !S_ISDIR(sb->st_mode)) {
+		printme = 0;
+		goto out;
+	}
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		if (report_errors) {
+			perror(path);
+			return FTW_STOP;
+		}
+
+		return FTW_CONTINUE;
+	}
+
+	if (want_datafile && typeflag == FTW_F) {
+		int ret = check_datafile(path, fd);
+		if (ret < 0 && report_errors) {
+			printme = 0;
+			retval = FTW_STOP;
+			goto out_fd;
+		}
+
+		if (ret == 1)
+			goto out_fd;
+	}
+
+	if (want_attrfile) {
+		int ret = check_attrfile(path, fd);
+		if (ret < 0 && report_errors) {
+			printme = 0;
+			retval = FTW_STOP;
+			goto out_fd;
+		}
+
+		if (ret == 1)
+			goto out_fd;
+	}
+
+	if (want_sharedfile) {
+		int ret = check_sharedfile(path, fd);
+		if (ret < 0 && report_errors) {
+			printme = 0;
+			retval = FTW_STOP;
+			goto out_fd;
+		}
+
+		if (ret == 1)
+			goto out_fd;
+	}
+
+	printme = 0;
+out_fd:
+	close(fd);
+out:
+	if (printme)
+		printf("%s\n", path);
+	return retval;
+}
+
+static void
+handle_sigabrt(
+	int		signal,
+	siginfo_t	*info,
+	void		*ucontext)
+{
+	fprintf(stderr, "Signal %u, exiting.\n", signal);
+	exit(2);
+}
+
+int
+main(
+	int			argc,
+	char			*argv[])
+{
+	struct rlimit		rlimit;
+	struct sigaction	abrt = {
+		.sa_sigaction	= handle_sigabrt,
+		.sa_flags	= SA_SIGINFO,
+	};
+	int			c;
+	int			ret;
+
+	while ((c = getopt(argc, argv, "abdqrs")) >= 0) {
+		switch (c) {
+		case 'a':	want_attrfile = 1;   break;
+		case 'b':	want_datafile = 1;   break;
+		case 'd':	want_dir = 1;        break;
+		case 'q':	report_errors = 0;   break;
+		case 'r':	want_regfile = 1;    break;
+		case 's':	want_sharedfile = 1; break;
+		default:
+			print_help(argv[0]);
+			return 1;
+		}
+	}
+
+	ret = getrlimit(RLIMIT_NOFILE, &rlimit);
+	if (ret) {
+		perror("RLIMIT_NOFILE");
+		return 1;
+	}
+
+	if (!want_attrfile && !want_datafile && !want_dir && !want_regfile &&
+	    !want_sharedfile)
+		want_anyfile = 1;
+
+	/*
+	 * nftw is known to abort() if a directory it is walking disappears out
+	 * from under it.  Handle this with grace if the caller wants us to run
+	 * quietly.
+	 */
+	if (!report_errors) {
+		ret = sigaction(SIGABRT, &abrt, NULL);
+		if (ret) {
+			perror("SIGABRT handler");
+			return 1;
+		}
+	}
+
+	for (c = optind; c < argc; c++) {
+		ret = nftw(argv[c], visit, rlimit.rlim_cur - 5,
+				FTW_ACTIONRETVAL | FTW_CHDIR | FTW_MOUNT |
+				FTW_PHYS);
+		if (ret && report_errors) {
+			perror(argv[c]);
+			break;
+		}
+	}
+
+	if (ret)
+		return 1;
+	return 0;
+}
