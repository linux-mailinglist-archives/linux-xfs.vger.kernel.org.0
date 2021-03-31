Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C5734F5BB
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Mar 2021 03:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhCaBIu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Mar 2021 21:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232600AbhCaBIY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 21:08:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99318619C1;
        Wed, 31 Mar 2021 01:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617152903;
        bh=V3Ir2HR9Bqa+4K+Dbkak7Wqr7clwpvD3UDTHG1mTut0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Dlx9Lo+LcBFfMXfDhgis/wSdrr7yNS9Z6+qcliQm3Z4tmJjo6a73SJykSpi+HriBo
         GI/bl1qpaJG6OLwtqYEvoCVLcnVfeh2xcnCdVB5K57O8f2JkX7rgb1ec9ixxlGy9mY
         OayT3Oo62ZqZrkJbKjhJ0TIRzMt5vJqwgIx14Rr7OqgtgoHIboduOYkp/QODUNvCiE
         dFy5HjwyAO896oHwlN4Boi6NboaNv50R00tqztH6UdhQXnSSFkn4U+askx6rnSH4Of
         EF8oyEmYzrCac4Up56T5mDt9BRPUazMAAvEVsuMf1E+2/EfBdKN/IwUyaVyGoB20PH
         zT1OysFHScuFw==
Subject: [PATCH 3/3] xfs: test that the needsrepair feature works as
 advertised
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 30 Mar 2021 18:08:21 -0700
Message-ID: <161715290127.2703773.4292037416016401516.stgit@magnolia>
In-Reply-To: <161715288469.2703773.13448230101596914371.stgit@magnolia>
References: <161715288469.2703773.13448230101596914371.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure that the needsrepair feature flag can be cleared only by
repair and that mounts are prohibited when the feature is set.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs        |   21 +++++++++++
 tests/xfs/768     |   82 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/768.out |    4 ++
 tests/xfs/770     |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/770.out |    2 +
 tests/xfs/group   |    2 +
 6 files changed, 212 insertions(+)
 create mode 100755 tests/xfs/768
 create mode 100644 tests/xfs/768.out
 create mode 100755 tests/xfs/770
 create mode 100644 tests/xfs/770.out


diff --git a/common/xfs b/common/xfs
index c97e08ba..051e5652 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1091,3 +1091,24 @@ _require_xfs_copy()
 	[ "$USE_EXTERNAL" = yes ] && \
 		_notrun "Cannot xfs_copy with external devices"
 }
+
+# Print the status of the given features on the scratch filesystem.
+# Returns 0 if all features are found, 1 otherwise.
+_check_scratch_xfs_features()
+{
+	local features="$(_scratch_xfs_db -c 'version')"
+	local output=("FEATURES:")
+	local found=0
+
+	for feature in "$@"; do
+		local status="NO"
+		if echo "${features}" | grep -q -w "${feature}"; then
+			status="YES"
+			found=$((found + 1))
+		fi
+		output+=("${feature}:${status}")
+	done
+
+	echo "${output[@]}"
+	test "${found}" -eq "$#"
+}
diff --git a/tests/xfs/768 b/tests/xfs/768
new file mode 100755
index 00000000..7b909b76
--- /dev/null
+++ b/tests/xfs/768
@@ -0,0 +1,82 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 768
+#
+# Make sure that the kernel won't mount a filesystem if repair forcibly sets
+# NEEDSREPAIR while fixing metadata.  Corrupt a directory in such a way as
+# to force repair to write an invalid dirent value as a sentinel to trigger a
+# repair activity in a later phase.  Use a debug knob in xfs_repair to abort
+# the repair immediately after forcing the flag on.
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
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+grep -q LIBXFS_DEBUG_WRITE_CRASH $XFS_REPAIR_PROG || \
+		_notrun "libxfs write failure injection hook not detected?"
+
+rm -f $seqres.full
+
+# Set up a real filesystem for our actual test
+_scratch_mkfs -m crc=1 >> $seqres.full
+
+# Create a directory large enough to have a dir data block.  2k worth of
+# dirent names ought to do it.
+_scratch_mount
+mkdir -p $SCRATCH_MNT/fubar
+for i in $(seq 0 256 2048); do
+	fname=$(printf "%0255d" $i)
+	ln -s -f urk $SCRATCH_MNT/fubar/$fname
+done
+inum=$(stat -c '%i' $SCRATCH_MNT/fubar)
+_scratch_unmount
+
+# Fuzz the directory
+_scratch_xfs_db -x -c "inode $inum" -c "dblock 0" \
+	-c "fuzz -d bu[2].inumber add" >> $seqres.full
+
+# Try to repair the directory, force it to crash after setting needsrepair
+LIBXFS_DEBUG_WRITE_CRASH=ddev=2 _scratch_xfs_repair 2>> $seqres.full
+test $? -eq 137 || echo "repair should have been killed??"
+_scratch_xfs_db -c 'version' >> $seqres.full
+
+# We can't mount, right?
+_check_scratch_xfs_features NEEDSREPAIR
+_try_scratch_mount &> $tmp.mount
+res=$?
+_filter_scratch < $tmp.mount
+if [ $res -eq 0 ]; then
+	echo "Should not be able to mount after needsrepair crash"
+	_scratch_unmount
+fi
+
+# Repair properly this time and retry the mount
+_scratch_xfs_repair 2>> $seqres.full
+_scratch_xfs_db -c 'version' >> $seqres.full
+_check_scratch_xfs_features NEEDSREPAIR
+
+_scratch_mount
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/768.out b/tests/xfs/768.out
new file mode 100644
index 00000000..1168ba25
--- /dev/null
+++ b/tests/xfs/768.out
@@ -0,0 +1,4 @@
+QA output created by 768
+FEATURES: NEEDSREPAIR:YES
+mount: SCRATCH_MNT: mount(2) system call failed: Structure needs cleaning.
+FEATURES: NEEDSREPAIR:NO
diff --git a/tests/xfs/770 b/tests/xfs/770
new file mode 100755
index 00000000..1d0effd9
--- /dev/null
+++ b/tests/xfs/770
@@ -0,0 +1,101 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 770
+#
+# Populate a filesystem with all types of metadata, then run repair with the
+# libxfs write failure trigger set to go after a single write.  Check that the
+# injected error trips, causing repair to abort, that needsrepair is set on the
+# fs, the kernel won't mount; and that a non-injecting repair run clears
+# needsrepair and makes the filesystem mountable again.
+#
+# Repeat with the trip point set to successively higher numbers of writes until
+# we hit ~200 writes or repair manages to run to completion without tripping.
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
+. ./common/populate
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+
+_require_scratch_xfs_crc		# needsrepair only exists for v5
+_require_populate_commands
+
+rm -f ${RESULT_DIR}/require_scratch	# we take care of checking the fs
+rm -f $seqres.full
+
+max_writes=200			# 200 loops should be enough for anyone
+nr_incr=$((13 / TIME_FACTOR))
+test $nr_incr -lt 1 && nr_incr=1
+for ((nr_writes = 1; nr_writes < max_writes; nr_writes += nr_incr)); do
+	test -w /dev/ttyprintk && \
+		echo "fail after $nr_writes writes" >> /dev/ttyprintk
+	echo "fail after $nr_writes writes" >> $seqres.full
+
+	# Populate the filesystem
+	_scratch_populate_cached nofill >> $seqres.full 2>&1
+
+	# Start a repair and force it to abort after some number of writes
+	LIBXFS_DEBUG_WRITE_CRASH=ddev=$nr_writes _scratch_xfs_repair 2>> $seqres.full
+	res=$?
+	if [ $res -ne 0 ] && [ $res -ne 137 ]; then
+		echo "repair failed with $res??"
+		break
+	elif [ $res -eq 0 ]; then
+		[ $nr_writes -eq 1 ] && \
+			echo "ran to completion on the first try?"
+		break
+	fi
+
+	_scratch_xfs_db -c 'version' >> $seqres.full
+	if _check_scratch_xfs_features NEEDSREPAIR > /dev/null; then
+		# NEEDSREPAIR is set, so check that we can't mount.
+		_try_scratch_mount &>> $seqres.full
+		if [ $? -eq 0 ]; then
+			echo "Should not be able to mount after repair crash"
+			_scratch_unmount
+		fi
+	elif _scratch_xfs_repair -n &>> $seqres.full; then
+		# NEEDSREPAIR was not set, but repair -n didn't find problems.
+		# It's possible that the write failure injector triggered on
+		# the write that clears NEEDSREPAIR.
+		true
+	else
+		# NEEDSREPAIR was not set, but there are errors!
+		echo "NEEDSREPAIR should be set on corrupt fs"
+	fi
+
+	# Repair properly this time and retry the mount
+	_scratch_xfs_repair 2>> $seqres.full
+	_scratch_xfs_db -c 'version' >> $seqres.full
+	_check_scratch_xfs_features NEEDSREPAIR > /dev/null && \
+		echo "Repair failed to clear NEEDSREPAIR on the $nr_writes writes test"
+
+	# Make sure all the checking tools think this fs is ok
+	_scratch_mount
+	_check_scratch_fs
+	_scratch_unmount
+done
+
+# success, all done
+echo Silence is golden.
+status=0
+exit
diff --git a/tests/xfs/770.out b/tests/xfs/770.out
new file mode 100644
index 00000000..725d740b
--- /dev/null
+++ b/tests/xfs/770.out
@@ -0,0 +1,2 @@
+QA output created by 770
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index fe83f82d..09fddb5a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -520,3 +520,5 @@
 537 auto quick
 538 auto stress
 539 auto quick mount
+768 auto quick repair
+770 auto repair

