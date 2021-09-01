Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6843FD031
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Sep 2021 02:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242998AbhIAAMz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 31 Aug 2021 20:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243026AbhIAAMv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 20:12:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E354C61008;
        Wed,  1 Sep 2021 00:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630455116;
        bh=sC6PTG4ek4/QRwPorslrPDk9HBxUXKLbjFN0/62aMVE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=V1STgHB/6+ltVtgf8YSZHdVZzLn1DxjroTVus7UeF5SPvxn3F0+ACJ6E6zsBj13Im
         1QOGbOFYIS6CS/LhjFmL+zHBcAl2Xw6mSpTWrPD/1mE4w6U51sjWuiqvOSqUHXVl6z
         W6K2Z7YXHwdvaeYx0xfF38iBGCEWMmfBs/oumu9lAND+xTd5EEEaao/QW/ygScmeVP
         2XO+LeWfmnDW0l+QKZ438PfMeoDXykPI2+z0Nto1h6T7ZuIe2J7NIp9Wxtpdafrzis
         cw8j58SmwH3Q2HY/0TyMeZcTG6nfbKpSqI1Ulqad9BKbKV+EdNa6AVmfYLOgctB+tc
         nVQCpA5qq56MQ==
Subject: [PATCH 2/3] generic: test shutdowns of a nested filesystem
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 31 Aug 2021 17:11:55 -0700
Message-ID: <163045511565.770026.4042733663837802604.stgit@magnolia>
In-Reply-To: <163045510470.770026.14067376159951420121.stgit@magnolia>
References: <163045510470.770026.14067376159951420121.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

generic/475, but we're running fsstress on a disk image inside the
scratch filesystem

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc             |   24 +++++++++
 tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/725.out |    2 +
 3 files changed, 162 insertions(+)
 create mode 100755 tests/generic/725
 create mode 100644 tests/generic/725.out


diff --git a/common/rc b/common/rc
index 46b6b220..05c87332 100644
--- a/common/rc
+++ b/common/rc
@@ -631,6 +631,30 @@ _ext4_metadump()
 		$DUMP_COMPRESSOR -f "$dumpfile" &>> "$seqres.full"
 }
 
+# Capture the metadata of a filesystem in a dump file for offline analysis.
+# This is not supported by all filesystem types, so this function should only
+# be used after a test has already failed.
+_metadump_dev() {
+	local device="$1"
+	local dumpfile="$2"
+	local compressopt="$3"
+
+	test "$DUMP_CORRUPT_FS" = 1 || return 0
+
+	case "$FSTYP" in
+	ext*)
+		_ext4_metadump $device $dumpfile $compressopt
+		;;
+	xfs)
+		_xfs_metadump $dumpfile $device none $compressopt
+		;;
+	*)
+		echo "Don't know how to metadump $FSTYP"
+		return 1
+		;;
+	esac
+}
+
 _test_mkfs()
 {
     case $FSTYP in
diff --git a/tests/generic/725 b/tests/generic/725
new file mode 100755
index 00000000..ac008fdb
--- /dev/null
+++ b/tests/generic/725
@@ -0,0 +1,136 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 725
+#
+# Test nested log recovery with repeated (simulated) disk failures.  We kick
+# off fsstress on a loopback filesystem mounted on the scratch fs, then switch
+# out the underlying scratch device with dm-error to see what happens when the
+# disk goes down.  Having taken down both fses in this manner, remount them and
+# repeat.  This test simulates VM hosts crashing to try to shake out CoW bugs
+# in writeback on the host that cause VM guests to fail to recover.
+#
+. ./common/preamble
+_begin_fstest shutdown auto log metadata eio recoveryloop
+
+_cleanup()
+{
+	cd /
+	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
+	wait
+	if [ -n "$loopmnt" ]; then
+		$UMOUNT_PROG $loopmnt 2>/dev/null
+		rm -r -f $loopmnt
+	fi
+	rm -f $tmp.*
+	_dmerror_unmount
+	_dmerror_cleanup
+}
+
+# Import common functions.
+. ./common/dmerror
+. ./common/reflink
+
+# Modify as appropriate.
+_supported_fs generic
+
+_require_scratch_reflink
+_require_cp_reflink
+_require_dm_target error
+_require_command "$KILLALL_PROG" "killall"
+
+echo "Silence is golden."
+
+_scratch_mkfs >> $seqres.full 2>&1
+_require_metadata_journaling $SCRATCH_DEV
+_dmerror_init
+_dmerror_mount
+
+# Create a fs image consuming 1/3 of the scratch fs
+scratch_freesp_bytes=$(_get_available_space $SCRATCH_MNT)
+loopimg_bytes=$((scratch_freesp_bytes / 3))
+
+loopimg=$SCRATCH_MNT/testfs
+truncate -s $loopimg_bytes $loopimg
+_mkfs_dev $loopimg
+
+loopmnt=$tmp.mount
+mkdir -p $loopmnt
+
+scratch_aliveflag=$tmp.runsnap
+snap_aliveflag=$tmp.snapping
+
+snap_loop_fs() {
+	touch "$snap_aliveflag"
+	while [ -e "$scratch_aliveflag" ]; do
+		rm -f $loopimg.a
+		_cp_reflink $loopimg $loopimg.a
+		sleep 1
+	done
+	rm -f "$snap_aliveflag"
+}
+
+fsstress=($FSSTRESS_PROG $FSSTRESS_AVOID -d "$loopmnt" -n 999999 -p "$((LOAD_FACTOR * 4))")
+
+for i in $(seq 1 $((25 * TIME_FACTOR)) ); do
+	touch $scratch_aliveflag
+	snap_loop_fs >> $seqres.full 2>&1 &
+
+	if ! _mount $loopimg $loopmnt -o loop; then
+		rm -f $scratch_aliveflag
+		_metadump_dev $loopimg $seqres.loop.$i.md
+		_fail "iteration $i loopimg mount failed"
+		break
+	fi
+
+	("${fsstress[@]}" >> $seqres.full &) > /dev/null 2>&1
+
+	# purposely include 0 second sleeps to test shutdown immediately after
+	# recovery
+	sleep $((RANDOM % (3 * TIME_FACTOR) ))
+	rm -f $scratch_aliveflag
+
+	# This test aims to simulate sudden disk failure, which means that we
+	# do not want to quiesce the filesystem or otherwise give it a chance
+	# to flush its logs.  Therefore we want to call dmsetup with the
+	# --nolockfs parameter; to make this happen we must call the load
+	# error table helper *without* 'lockfs'.
+	_dmerror_load_error_table
+
+	ps -e | grep fsstress > /dev/null 2>&1
+	while [ $? -eq 0 ]; do
+		$KILLALL_PROG -9 fsstress > /dev/null 2>&1
+		wait > /dev/null 2>&1
+		ps -e | grep fsstress > /dev/null 2>&1
+	done
+	for ((i = 0; i < 10; i++)); do
+		test -e "$snap_aliveflag" || break
+		sleep 1
+	done
+
+	# Mount again to replay log after loading working table, so we have a
+	# consistent fs after test.
+	$UMOUNT_PROG $loopmnt
+	_dmerror_unmount || _fail "iteration $i scratch unmount failed"
+	_dmerror_load_working_table
+	if ! _dmerror_mount; then
+		_metadump_dev $DMERROR_DEV $seqres.scratch.$i.md
+		_fail "iteration $i scratch mount failed"
+	fi
+done
+
+# Make sure the fs image file is ok
+if [ -f "$loopimg" ]; then
+	if _mount $loopimg $loopmnt -o loop; then
+		$UMOUNT_PROG $loopmnt &> /dev/null
+	else
+		_metadump_dev $DMERROR_DEV $seqres.scratch.final.md
+		echo "final scratch mount failed"
+	fi
+	SCRATCH_RTDEV= SCRATCH_LOGDEV= _check_scratch_fs $loopimg
+fi
+
+# success, all done; let the test harness check the scratch fs
+status=0
+exit
diff --git a/tests/generic/725.out b/tests/generic/725.out
new file mode 100644
index 00000000..ed73a9fc
--- /dev/null
+++ b/tests/generic/725.out
@@ -0,0 +1,2 @@
+QA output created by 725
+Silence is golden.

