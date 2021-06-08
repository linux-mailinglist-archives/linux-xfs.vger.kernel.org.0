Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACDB39FD76
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Jun 2021 19:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbhFHRVy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 8 Jun 2021 13:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:55084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233094AbhFHRVx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 13:21:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF5E461351;
        Tue,  8 Jun 2021 17:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623172800;
        bh=BgXFEOXna1yigrn3pK6pGXGSB21BeeoLctSeCC+yQjo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=k3fYomdnxzjnIMAIrA5NcUxopXDd+Xvrqqd/PkX3KaFTpzvj2TBT14Lty//eCY8Ua
         MA9mehwSBv5y1SwhjkNIZ/qIU1XI5CM19zS9hKg2g2F5TeJi5vDFueCS4tAZsV7uzU
         T31zrCD4QGQ/xvU2I+gi8n1hhGnIW1NyC0EJQzPW7iDOwnp44mplReudKVSqjE1vDw
         lKt+aT5fHz0kc0sWdX2EemqcReBu1QiS+4QmVT6TdWgyeVoQpyYVPuB0++9pVCrUqE
         +qv5RFJxqkRnr9rQMpzZ8aDHBuL40Ed7rSi1iAtunX8XY+ca0bZlHgPLFY4OTCm7lM
         ydyOdqRGVgWKw==
Subject: [PATCH 07/13] fstests: automatically generate group files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com, ebiggers@kernel.org
Date:   Tue, 08 Jun 2021 10:20:00 -0700
Message-ID: <162317280046.653489.3322406175723320960.stgit@locust>
In-Reply-To: <162317276202.653489.13006238543620278716.stgit@locust>
References: <162317276202.653489.13006238543620278716.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've moved the group membership details into the test case
files themselves, automatically generate the group files during build.
The autogenerated files are named "group.list" instead of "group" to
avoid conflicts between generated and (stale) SCM files as everyone
rebases.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .gitignore             |    3 +++
 common/preamble        |    8 ++++++++
 include/buildgrouplist |    8 ++++++++
 tests/Makefile         |    4 ++++
 tests/btrfs/Makefile   |    4 ++++
 tests/ceph/Makefile    |    4 ++++
 tests/cifs/Makefile    |    4 ++++
 tests/ext4/Makefile    |    4 ++++
 tests/f2fs/Makefile    |    4 ++++
 tests/generic/Makefile |    4 ++++
 tests/nfs/Makefile     |    4 ++++
 tests/ocfs2/Makefile   |    4 ++++
 tests/overlay/Makefile |    4 ++++
 tests/perf/Makefile    |    4 ++++
 tests/shared/Makefile  |    4 ++++
 tests/udf/Makefile     |    4 ++++
 tests/xfs/Makefile     |    4 ++++
 tools/mkgroupfile      |   42 ++++++++++++++++++++++++++++++++++++++++++
 18 files changed, 117 insertions(+)
 create mode 100644 include/buildgrouplist
 create mode 100755 tools/mkgroupfile


diff --git a/.gitignore b/.gitignore
index c62c1556..ab366961 100644
--- a/.gitignore
+++ b/.gitignore
@@ -11,6 +11,9 @@ tags
 /local.config
 /results
 
+# autogenerated group files
+/tests/*/group.list
+
 # autoconf generated files
 /aclocal.m4
 /autom4te.cache
diff --git a/common/preamble b/common/preamble
index 63f66957..4fe8fd3f 100644
--- a/common/preamble
+++ b/common/preamble
@@ -32,6 +32,14 @@ _begin_fstest()
 	fi
 
 	seq=`basename $0`
+
+	# If we're only running the test to generate a group.list file,
+	# spit out the group data and exit.
+	if [ -n "$GENERATE_GROUPS" ]; then
+		echo "$seq $@"
+		exit 0
+	fi
+
 	seqres=$RESULT_DIR/$seq
 	echo "QA output created by $seq"
 
diff --git a/include/buildgrouplist b/include/buildgrouplist
new file mode 100644
index 00000000..d898efa3
--- /dev/null
+++ b/include/buildgrouplist
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
+#
+.PHONY: group.list
+
+group.list:
+	@echo " [GROUP] $$PWD/$@"
+	$(Q)$(TOPDIR)/tools/mkgroupfile $@
diff --git a/tests/Makefile b/tests/Makefile
index 8ce8f209..5c8f0b10 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -7,6 +7,10 @@ include $(TOPDIR)/include/builddefs
 
 TESTS_SUBDIRS = $(sort $(dir $(wildcard $(CURDIR)/[[:lower:]]*/)))
 
+SUBDIRS = $(wildcard [[:lower:]]*)
+
+default: $(SUBDIRS)
+
 include $(BUILDRULES)
 
 install: $(addsuffix -install,$(TESTS_SUBDIRS))
diff --git a/tests/btrfs/Makefile b/tests/btrfs/Makefile
index 2d936421..cc2b2fc9 100644
--- a/tests/btrfs/Makefile
+++ b/tests/btrfs/Makefile
@@ -4,9 +4,13 @@
 
 TOPDIR = ../..
 include $(TOPDIR)/include/builddefs
+include $(TOPDIR)/include/buildgrouplist
 
 BTRFS_DIR = btrfs
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(BTRFS_DIR)
+DIRT = group.list
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/ceph/Makefile b/tests/ceph/Makefile
index 55e35d77..61ab01d4 100644
--- a/tests/ceph/Makefile
+++ b/tests/ceph/Makefile
@@ -2,9 +2,13 @@
 
 TOPDIR = ../..
 include $(TOPDIR)/include/builddefs
+include $(TOPDIR)/include/buildgrouplist
 
 CEPH_DIR = ceph
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(CEPH_DIR)
+DIRT = group.list
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/cifs/Makefile b/tests/cifs/Makefile
index 0c5cf3be..5356a682 100644
--- a/tests/cifs/Makefile
+++ b/tests/cifs/Makefile
@@ -4,9 +4,13 @@
 
 TOPDIR = ../..
 include $(TOPDIR)/include/builddefs
+include $(TOPDIR)/include/buildgrouplist
 
 CIFS_DIR = cifs
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(CIFS_DIR)
+DIRT = group.list
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/ext4/Makefile b/tests/ext4/Makefile
index beb1541f..9c765497 100644
--- a/tests/ext4/Makefile
+++ b/tests/ext4/Makefile
@@ -4,9 +4,13 @@
 
 TOPDIR = ../..
 include $(TOPDIR)/include/builddefs
+include $(TOPDIR)/include/buildgrouplist
 
 EXT4_DIR = ext4
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(EXT4_DIR)
+DIRT = group.list
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/f2fs/Makefile b/tests/f2fs/Makefile
index d13bca3f..d2374018 100644
--- a/tests/f2fs/Makefile
+++ b/tests/f2fs/Makefile
@@ -5,9 +5,13 @@
 
 TOPDIR = ../..
 include $(TOPDIR)/include/builddefs
+include $(TOPDIR)/include/buildgrouplist
 
 F2FS_DIR = f2fs
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(F2FS_DIR)
+DIRT = group.list
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/generic/Makefile b/tests/generic/Makefile
index 3878d05c..95cd403c 100644
--- a/tests/generic/Makefile
+++ b/tests/generic/Makefile
@@ -4,9 +4,13 @@
 
 TOPDIR = ../..
 include $(TOPDIR)/include/builddefs
+include $(TOPDIR)/include/buildgrouplist
 
 GENERIC_DIR = generic
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(GENERIC_DIR)
+DIRT = group.list
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/nfs/Makefile b/tests/nfs/Makefile
index 754f2b25..e372b305 100644
--- a/tests/nfs/Makefile
+++ b/tests/nfs/Makefile
@@ -4,9 +4,13 @@
 
 TOPDIR = ../..
 include $(TOPDIR)/include/builddefs
+include $(TOPDIR)/include/buildgrouplist
 
 NFS_DIR = nfs
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(NFS_DIR)
+DIRT = group.list
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/ocfs2/Makefile b/tests/ocfs2/Makefile
index e1337908..d85c4fd3 100644
--- a/tests/ocfs2/Makefile
+++ b/tests/ocfs2/Makefile
@@ -4,9 +4,13 @@
 
 TOPDIR = ../..
 include $(TOPDIR)/include/builddefs
+include $(TOPDIR)/include/buildgrouplist
 
 OCFS2_DIR = ocfs2
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(OCFS2_DIR)
+DIRT = group.list
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/overlay/Makefile b/tests/overlay/Makefile
index b07f8925..b995a6ec 100644
--- a/tests/overlay/Makefile
+++ b/tests/overlay/Makefile
@@ -4,9 +4,13 @@
 
 TOPDIR = ../..
 include $(TOPDIR)/include/builddefs
+include $(TOPDIR)/include/buildgrouplist
 
 TEST_DIR = overlay
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(TEST_DIR)
+DIRT = group.list
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/perf/Makefile b/tests/perf/Makefile
index 620f1dbf..5d82cccc 100644
--- a/tests/perf/Makefile
+++ b/tests/perf/Makefile
@@ -4,9 +4,13 @@
 
 TOPDIR = ../..
 include $(TOPDIR)/include/builddefs
+include $(TOPDIR)/include/buildgrouplist
 
 PERF_DIR = perf
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(PERF_DIR)
+DIRT = group.list
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/shared/Makefile b/tests/shared/Makefile
index 8a832782..6c6533c8 100644
--- a/tests/shared/Makefile
+++ b/tests/shared/Makefile
@@ -4,9 +4,13 @@
 
 TOPDIR = ../..
 include $(TOPDIR)/include/builddefs
+include $(TOPDIR)/include/buildgrouplist
 
 SHARED_DIR = shared
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(SHARED_DIR)
+DIRT = group.list
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/udf/Makefile b/tests/udf/Makefile
index c9c9f1bd..bfaa1b0e 100644
--- a/tests/udf/Makefile
+++ b/tests/udf/Makefile
@@ -4,9 +4,13 @@
 
 TOPDIR = ../..
 include $(TOPDIR)/include/builddefs
+include $(TOPDIR)/include/buildgrouplist
 
 UDF_DIR = udf
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(UDF_DIR)
+DIRT = group.list
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tests/xfs/Makefile b/tests/xfs/Makefile
index d64800ea..c2f0ba48 100644
--- a/tests/xfs/Makefile
+++ b/tests/xfs/Makefile
@@ -4,9 +4,13 @@
 
 TOPDIR = ../..
 include $(TOPDIR)/include/builddefs
+include $(TOPDIR)/include/buildgrouplist
 
 XFS_DIR = xfs
 TARGET_DIR = $(PKG_LIB_DIR)/$(TESTS_DIR)/$(XFS_DIR)
+DIRT = group.list
+
+default: $(DIRT)
 
 include $(BUILDRULES)
 
diff --git a/tools/mkgroupfile b/tools/mkgroupfile
new file mode 100755
index 00000000..0681e5d2
--- /dev/null
+++ b/tools/mkgroupfile
@@ -0,0 +1,42 @@
+#!/bin/bash
+
+# Generate a group file from the _begin_fstest call in each test.
+
+if [ "$1" = "--help" ]; then
+	echo "Usage: (cd tests/XXX/ ; ../../tools/mkgroupfile [output])"
+	exit 1
+fi
+
+test_dir="$PWD"
+groupfile="$1"
+
+if [ ! -x ../../check ]; then
+	echo "$0: Run this from tests/XXX/."
+	exit 1
+fi
+
+generate_groupfile() {
+	cat << ENDL
+# QA groups control file, automatically generated.
+# See _begin_fstest in each test for details.
+
+ENDL
+	cd ../../
+	export GENERATE_GROUPS=yes
+	grep -R -l "^_begin_fstest" "$test_dir/" 2>/dev/null | while read testfile; do
+		test -x "$testfile" && "$testfile"
+	done | sort -g
+	cd "$test_dir"
+}
+
+if [ -z "$groupfile" ] || [ "$groupfile" = "-" ]; then
+	# Dump the group file to stdout and exit
+	generate_groupfile
+	exit 0
+fi
+
+# Otherwise, write the group file to disk somewhere.
+ngroupfile="${groupfile}.new"
+rm -f "$ngroupfile"
+generate_groupfile >> "$ngroupfile"
+mv "$ngroupfile" "$groupfile"

