Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD49731AA32
	for <lists+linux-xfs@lfdr.de>; Sat, 13 Feb 2021 06:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhBMFes (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 13 Feb 2021 00:34:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230458AbhBMFes (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:34:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B1C864EA1;
        Sat, 13 Feb 2021 05:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613194436;
        bh=vu0MvIR3dAlj46AyMBx6LXN3945n1evZBPZaV59yUOo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Q/ZtXEg9GbscZhV9fhIZwKVysCPPOMCo5bsE8AqGAAOJriSXKhedRHhoVYs2Zb58j
         xCsd5qyVr7zHDfemtNF/ohZpqLPn75ABXgJoODbJbEj61kwxsj9QvWK6nhiq3p7ZXB
         6sHNj6sLTSflZd4zB4SgEMkbFZ7i0oCYS3CFEmBX/fspD/6pKmU14GF7froVm/AjF/
         oKIRzyH0QWr64Ajo+dZ713qMjbygxUPDZ3IXkZZOIrxvb0YJwRVTd+7AgB8Ajw2eqs
         Ve6CiMF6/lqLzkIj56vORiCtxv/4xAdRn9rRGC7biBJ+ugP9NFafKngRBirjvKS87m
         MlX5kroj4IGlg==
Subject: [PATCH 1/4] generic: check userspace handling of extreme timestamps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org
Date:   Fri, 12 Feb 2021 21:33:56 -0800
Message-ID: <161319443599.403615.9707875462807514719.stgit@magnolia>
In-Reply-To: <161319443045.403615.18346950431837086632.stgit@magnolia>
References: <161319443045.403615.18346950431837086632.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

These two tests ensure we can store and retrieve timestamps on the
extremes of the date ranges supported by userspace, and the common
places where overflows can happen.

They differ from generic/402 in that they don't constrain the dates
tested to the range that the filesystem claims to support; we attempt
various things that /userspace/ can parse, and then check that the vfs
clamps and persists the values correctly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/721     |  123 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/721.out |    2 +
 tests/generic/722     |  125 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/722.out |    1 
 tests/generic/group   |    6 ++
 5 files changed, 255 insertions(+), 2 deletions(-)
 create mode 100755 tests/generic/721
 create mode 100644 tests/generic/721.out
 create mode 100755 tests/generic/722
 create mode 100644 tests/generic/722.out


diff --git a/tests/generic/721 b/tests/generic/721
new file mode 100755
index 00000000..9198b6b4
--- /dev/null
+++ b/tests/generic/721
@@ -0,0 +1,123 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 721
+#
+# Make sure we can store and retrieve timestamps on the extremes of the
+# date ranges supported by userspace, and the common places where overflows
+# can happen.
+#
+# This differs from generic/402 in that we don't constrain ourselves to the
+# range that the filesystem claims to support; we attempt various things that
+# /userspace/ can parse, and then check that the vfs clamps and persists the
+# values correctly.
+#
+# NOTE: Old kernels (pre 5.4) allow filesystems to truncate timestamps silently
+# when writing timestamps to disk!  This test detects this silent truncation
+# and fails.  If you see a failure on such a kernel, contact your distributor
+# for an update.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch
+
+rm -f $seqres.full
+
+_scratch_mkfs > $seqres.full
+_scratch_mount
+
+# Does our userspace even support large dates?
+test_bigdates=1
+touch -d 'May 30 01:53:03 UTC 2514' $SCRATCH_MNT 2>/dev/null || test_bigdates=0
+
+# And can we do statx?
+test_statx=1
+($XFS_IO_PROG -c 'help statx' | grep -q 'Print raw statx' && \
+ $XFS_IO_PROG -c 'statx -r' $SCRATCH_MNT 2>/dev/null | grep -q 'stat.mtime') || \
+	test_statx=0
+
+echo "Userspace support of large timestamps: $test_bigdates" >> $seqres.full
+echo "xfs_io support of statx: $test_statx" >> $seqres.full
+
+touchme() {
+	local arg="$1"
+	local name="$2"
+
+	echo "$arg" > $SCRATCH_MNT/t_$name
+	touch -d "$arg" $SCRATCH_MNT/t_$name
+}
+
+report() {
+	local files=($SCRATCH_MNT/t_*)
+	for file in "${files[@]}"; do
+		echo "${file}: $(cat "${file}")"
+		TZ=UTC stat -c '%y %Y %n' "${file}"
+		test $test_statx -gt 0 && \
+			$XFS_IO_PROG -c 'statx -r' "${file}" | grep 'stat.mtime'
+	done
+}
+
+# -2147483648 (S32_MIN, or classic unix min)
+touchme 'Dec 13 20:45:52 UTC 1901' s32_min
+
+# 2147483647 (S32_MAX, or classic unix max)
+touchme 'Jan 19 03:14:07 UTC 2038' s32_max
+
+# 7956915742, all twos
+touchme 'Feb 22 22:22:22 UTC 2222' all_twos
+
+if [ $test_bigdates -gt 0 ]; then
+	# 16299260424 (u64 nsec counter from s32_min, like xfs does)
+	touchme 'Tue Jul  2 20:20:24 UTC 2486' u64ns_from_s32_min
+
+	# 15032385535 (u34 time if you start from s32_min, like ext4 does)
+	touchme 'May 10 22:38:55 UTC 2446' u34_from_s32_min
+
+	# 17179869183 (u34 time if you start from the unix epoch)
+	touchme 'May 30 01:53:03 UTC 2514' u34_max
+
+	# Latest date we can synthesize(?)
+	touchme 'Dec 31 23:59:59 UTC 2147483647' abs_max_time
+
+	# Earliest date we can synthesize(?)
+	touchme 'Jan 1 00:00:00 UTC 0' abs_min_time
+fi
+
+# Query timestamps from incore
+echo before >> $seqres.full
+report > $tmp.before_remount
+cat $tmp.before_remount >> $seqres.full
+
+_scratch_cycle_mount
+
+# Query timestamps from disk
+echo after >> $seqres.full
+report > $tmp.after_remount
+cat $tmp.after_remount >> $seqres.full
+
+# Did they match?
+cmp -s $tmp.before_remount $tmp.after_remount
+
+# success, all done
+echo Silence is golden.
+status=0
+exit
diff --git a/tests/generic/721.out b/tests/generic/721.out
new file mode 100644
index 00000000..b2bc6d58
--- /dev/null
+++ b/tests/generic/721.out
@@ -0,0 +1,2 @@
+QA output created by 721
+Silence is golden.
diff --git a/tests/generic/722 b/tests/generic/722
new file mode 100755
index 00000000..305c3bd6
--- /dev/null
+++ b/tests/generic/722
@@ -0,0 +1,125 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 722
+#
+# Make sure we can store and retrieve timestamps on the extremes of the
+# date ranges supported by userspace, and the common places where overflows
+# can happen.  This test also ensures that the timestamps are persisted
+# correctly after a shutdown.
+#
+# This differs from generic/402 in that we don't constrain ourselves to the
+# range that the filesystem claims to support; we attempt various things that
+# /userspace/ can parse, and then check that the vfs clamps and persists the
+# values correctly.
+#
+# NOTE: Old kernels (pre 5.4) allow filesystems to truncate timestamps silently
+# when writing timestamps to disk!  This test detects this silent truncation
+# and fails.  If you see a failure on such a kernel, contact your distributor
+# for an update.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch
+_require_scratch_shutdown
+
+rm -f $seqres.full
+
+_scratch_mkfs > $seqres.full
+_scratch_mount
+
+# Does our userspace even support large dates?
+test_bigdates=1
+touch -d 'May 30 01:53:03 UTC 2514' $SCRATCH_MNT 2>/dev/null || test_bigdates=0
+
+# And can we do statx?
+test_statx=1
+($XFS_IO_PROG -c 'help statx' | grep -q 'Print raw statx' && \
+ $XFS_IO_PROG -c 'statx -r' $SCRATCH_MNT 2>/dev/null | grep -q 'stat.mtime') || \
+	test_statx=0
+
+echo "Userspace support of large timestamps: $test_bigdates" >> $seqres.full
+echo "xfs_io support of statx: $test_statx" >> $seqres.full
+
+touchme() {
+	local arg="$1"
+	local name="$2"
+
+	echo "$arg" > $SCRATCH_MNT/t_$name
+	touch -d "$arg" $SCRATCH_MNT/t_$name
+}
+
+report() {
+	local files=($SCRATCH_MNT/t_*)
+	for file in "${files[@]}"; do
+		echo "${file}: $(cat "${file}")"
+		TZ=UTC stat -c '%y %Y %n' "${file}"
+		test $test_statx -gt 0 && \
+			$XFS_IO_PROG -c 'statx -r' "${file}" | grep 'stat.mtime'
+	done
+}
+
+# -2147483648 (S32_MIN, or classic unix min)
+touchme 'Dec 13 20:45:52 UTC 1901' s32_min
+
+# 2147483647 (S32_MAX, or classic unix max)
+touchme 'Jan 19 03:14:07 UTC 2038' s32_max
+
+# 7956915742, all twos
+touchme 'Feb 22 22:22:22 UTC 2222' all_twos
+
+if [ $test_bigdates -gt 0 ]; then
+	# 16299260424 (u64 nsec counter from s32_min, like xfs does)
+	touchme 'Tue Jul  2 20:20:24 UTC 2486' u64ns_from_s32_min
+
+	# 15032385535 (u34 time if you start from s32_min, like ext4 does)
+	touchme 'May 10 22:38:55 UTC 2446' u34_from_s32_min
+
+	# 17179869183 (u34 time if you start from the unix epoch)
+	touchme 'May 30 01:53:03 UTC 2514' u34_max
+
+	# Latest date we can synthesize(?)
+	touchme 'Dec 31 23:59:59 UTC 2147483647' abs_max_time
+
+	# Earliest date we can synthesize(?)
+	touchme 'Jan 1 00:00:00 UTC 0' abs_min_time
+fi
+
+# Query timestamps from incore
+echo before >> $seqres.full
+report > $tmp.before_crash
+cat $tmp.before_crash >> $seqres.full
+
+_scratch_shutdown -f
+_scratch_cycle_mount
+
+# Query timestamps from disk
+echo after >> $seqres.full
+report > $tmp.after_crash
+cat $tmp.after_crash >> $seqres.full
+
+# Did they match?
+cmp -s $tmp.before_crash $tmp.after_crash
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/722.out b/tests/generic/722.out
new file mode 100644
index 00000000..83acd5cf
--- /dev/null
+++ b/tests/generic/722.out
@@ -0,0 +1 @@
+QA output created by 722
diff --git a/tests/generic/group b/tests/generic/group
index 7c0a6ca6..9b892462 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -260,7 +260,7 @@
 255 auto quick prealloc punch
 256 auto quick punch
 257 dir auto quick
-258 auto quick
+258 auto quick bigtime
 259 auto quick clone zero
 260 auto quick trim
 261 auto quick clone collapse
@@ -404,7 +404,7 @@
 399 auto encrypt
 400 auto quick quota
 401 auto quick
-402 auto quick rw
+402 auto quick rw bigtime
 403 auto quick attr
 404 auto quick insert
 405 auto mkfs thin
@@ -625,6 +625,8 @@
 620 auto mount quick
 621 auto quick encrypt
 622 auto shutdown metadata atime
+721 auto quick atime bigtime
+722 auto quick atime bigtime shutdown
 947 auto quick rw clone
 948 auto quick rw copy_range
 949 auto quick rw dedupe clone

