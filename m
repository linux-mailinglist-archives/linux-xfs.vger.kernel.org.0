Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E50B7EA1AE
	for <lists+linux-xfs@lfdr.de>; Mon, 13 Nov 2023 18:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjKMRIf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Nov 2023 12:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjKMRIf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 12:08:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5730FD79
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 09:08:31 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E914FC433C7;
        Mon, 13 Nov 2023 17:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699895311;
        bh=chtICAFC4cp6yLiugdN5zdoxKw1aMxph/fKrOEtW9V4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uTazUR5tnAdl9WZmCll4pREkwXqkImi6w5zi9H9Zyxs1v8Iu3k5ArF7NwayOebOpc
         A4WHA94XcXRP36nG5eVGJ+iis6C+cSHxojeQfXW25J9/86vIuMebh6y4QZMFkVtcsX
         5J8dBePpjNtaga0xNO7X//PqsXvwjiBtr1PinC7uk/a0enfn42rn1cqWh6P71axh97
         r+zM32iBSgNZcHQp2R4kEggNWO6JroHpbGkOQClBKRsdR3OtVBHhsvAr/VFjCj6Sk/
         YZrvLkn7BeJrRbrwqPMvn544dZN/wyTPy85fbykgCpdnntig2LYQX0qFeyo/J8DRJA
         8UG/nBGcXQLSg==
Subject: [PATCH 2/2] xfs: test unlinked inode list repair on demand
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 13 Nov 2023 09:08:30 -0800
Message-ID: <169989531041.1034375.764357370786262342.stgit@frogsfrogsfrogs>
In-Reply-To: <169989529888.1034375.6695143880673011270.stgit@frogsfrogsfrogs>
References: <169989529888.1034375.6695143880673011270.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a test to exercise recovery of unlinked inodes on a clean
filesystem.  This was definitely possible on old kernels that on an ro
mount would clean the log without processing the iunlink list.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc          |    4 +
 tests/xfs/1872     |  111 +++++++++++++++++++++++++++
 tests/xfs/1872.out |    5 +
 tests/xfs/1873     |  215 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1873.out |    6 +
 5 files changed, 340 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/1872
 create mode 100644 tests/xfs/1872.out
 create mode 100755 tests/xfs/1873
 create mode 100644 tests/xfs/1873.out


diff --git a/common/rc b/common/rc
index 7d10f8425e..ee3e7cbcf3 100644
--- a/common/rc
+++ b/common/rc
@@ -2668,9 +2668,11 @@ _require_xfs_io_command()
 		param_checked="$pwrite_opts $param"
 		;;
 	"scrub"|"repair")
-		testio=`$XFS_IO_PROG -x -c "$command probe" $TEST_DIR 2>&1`
+		test -z "$param" && param="probe"
+		testio=`$XFS_IO_PROG -x -c "$command $param" $TEST_DIR 2>&1`
 		echo $testio | grep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command support is missing"
+		param_checked="$param"
 		;;
 	"startupdate"|"commitupdate"|"cancelupdate")
 		$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 128k -b 128k' $testfile > /dev/null
diff --git a/tests/xfs/1872 b/tests/xfs/1872
new file mode 100755
index 0000000000..289fc99612
--- /dev/null
+++ b/tests/xfs/1872
@@ -0,0 +1,111 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1872
+#
+# Test using runtime code to fix unlinked inodes on a clean filesystem that
+# never got cleaned up.
+#
+. ./common/preamble
+_begin_fstest auto quick unlink
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/quota
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_xfs_db_command iunlink
+_require_scratch_nocheck	# we'll run repair ourselves
+
+# From the AGI definition
+XFS_AGI_UNLINKED_BUCKETS=64
+
+# Try to make each iunlink bucket have this many inodes in it.
+IUNLINK_BUCKETLEN=5
+
+# Disable quota since quotacheck will break this test
+orig_mount_options="$MOUNT_OPTIONS"
+_qmount_option 'noquota'
+
+format_scratch() {
+	_scratch_mkfs -d agcount=1 | _filter_mkfs 2> "${tmp}.mkfs" >> $seqres.full
+	source "${tmp}.mkfs"
+	test "${agcount}" -eq 1 || _notrun "test requires 1 AG for error injection"
+
+	local nr_iunlinks="$((IUNLINK_BUCKETLEN * XFS_AGI_UNLINKED_BUCKETS))"
+	readarray -t BADINODES < <(_scratch_xfs_db -x -c "iunlink -n $nr_iunlinks" | awk '{print $4}')
+}
+
+__repair_check_scratch() {
+	_scratch_xfs_repair -o force_geometry -n 2>&1 | \
+		tee -a $seqres.full | \
+		grep -E '(disconnected inode.*would move|next_unlinked in inode|unlinked bucket.*is.*in ag)'
+	return "${PIPESTATUS[0]}"
+}
+
+exercise_scratch() {
+	# Create a bunch of files...
+	declare -A inums
+	for ((i = 0; i < (XFS_AGI_UNLINKED_BUCKETS * 2); i++)); do
+		touch "${SCRATCH_MNT}/${i}" || break
+		inums["${i}"]="$(stat -c %i "${SCRATCH_MNT}/${i}")"
+	done
+
+	# ...then delete them to exercise the unlinked buckets
+	for ((i = 0; i < (XFS_AGI_UNLINKED_BUCKETS * 2); i++)); do
+		if ! rm -f "${SCRATCH_MNT}/${i}"; then
+			echo "rm failed on inum ${inums[$i]}"
+			break
+		fi
+	done
+}
+
+# Offline repair should not find anything
+final_check_scratch() {
+	__repair_check_scratch
+	res=$?
+	if [ $res -eq 2 ]; then
+		echo "scratch fs went offline?"
+		_scratch_mount
+		_scratch_unmount
+		__repair_check_scratch
+	fi
+	test "$res" -ne 0 && echo "repair returned $res?"
+}
+
+echo "+ Part 0: See if runtime can recover the unlinked list" | tee -a $seqres.full
+format_scratch
+_kernlog "part 0"
+_scratch_mount
+exercise_scratch
+_scratch_unmount
+final_check_scratch
+
+echo "+ Part 1: See if bulkstat can recover the unlinked list" | tee -a $seqres.full
+format_scratch
+_kernlog "part 1"
+_scratch_mount
+$XFS_IO_PROG -c 'bulkstat' $SCRATCH_MNT > /dev/null
+exercise_scratch
+_scratch_unmount
+final_check_scratch
+
+echo "+ Part 2: See if quotacheck can recover the unlinked list" | tee -a $seqres.full
+if [ -f /proc/fs/xfs/xqmstat ]; then
+	MOUNT_OPTIONS="$orig_mount_options"
+	_qmount_option 'quota'
+	format_scratch
+	_kernlog "part 2"
+	_scratch_mount
+	exercise_scratch
+	_scratch_unmount
+	final_check_scratch
+fi
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1872.out b/tests/xfs/1872.out
new file mode 100644
index 0000000000..248f0e2416
--- /dev/null
+++ b/tests/xfs/1872.out
@@ -0,0 +1,5 @@
+QA output created by 1872
++ Part 0: See if runtime can recover the unlinked list
++ Part 1: See if bulkstat can recover the unlinked list
++ Part 2: See if quotacheck can recover the unlinked list
+Silence is golden
diff --git a/tests/xfs/1873 b/tests/xfs/1873
new file mode 100755
index 0000000000..5d9fc620dc
--- /dev/null
+++ b/tests/xfs/1873
@@ -0,0 +1,215 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1873
+#
+# Functional test of using online repair to fix unlinked inodes on a clean
+# filesystem that never got cleaned up.
+#
+. ./common/preamble
+_begin_fstest auto online_repair
+
+. ./common/filter
+. ./common/fuzzy
+. ./common/quota
+
+# real QA test starts here
+
+_supported_fs xfs
+_require_xfs_db_command iunlink
+# The iunlink bucket repair code wasn't added to the AGI repair code
+# until after the directory repair code was merged
+_require_xfs_io_command repair -R directory
+_require_scratch_nocheck	# repair doesn't like single-AG fs
+
+# From the AGI definition
+XFS_AGI_UNLINKED_BUCKETS=64
+
+# Try to make each iunlink bucket have this many inodes in it.
+IUNLINK_BUCKETLEN=5
+
+# Disable quota since quotacheck will break this test
+_qmount_option 'noquota'
+
+format_scratch() {
+	_scratch_mkfs -d agcount=1 | _filter_mkfs 2> "${tmp}.mkfs" >> $seqres.full
+	source "${tmp}.mkfs"
+	test "${agcount}" -eq 1 || _notrun "test requires 1 AG for error injection"
+
+	local nr_iunlinks="$((IUNLINK_BUCKETLEN * XFS_AGI_UNLINKED_BUCKETS))"
+	readarray -t BADINODES < <(_scratch_xfs_db -x -c "iunlink -n $nr_iunlinks" | awk '{print $4}')
+}
+
+__repair_check_scratch() {
+	_scratch_xfs_repair -o force_geometry -n 2>&1 | \
+		tee -a $seqres.full | \
+		grep -E '(disconnected inode.*would move|next_unlinked in inode|unlinked bucket.*is.*in ag)'
+	return "${PIPESTATUS[0]}"
+}
+
+corrupt_scratch() {
+	# How far into the iunlink bucket chain do we target inodes for corruption?
+	# 1 = target the inode pointed to by the AGI
+	# 3 = middle of bucket list
+	# 5 = last element in bucket
+	local corruption_bucket_depth="$1"
+	if ((corruption_bucket_depth < 1 || corruption_bucket_depth > IUNLINK_BUCKETLEN)); then
+		echo "${corruption_bucket_depth}: Value must be between 1 and ${IUNLINK_BUCKETLEN}."
+		return 1
+	fi
+
+	# Index of the inode numbers within BADINODES
+	local bad_ino1_idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth) * XFS_AGI_UNLINKED_BUCKETS))
+	local bad_ino2_idx=$((bad_ino1_idx + 1))
+
+	# Inode numbers to target
+	local bad_ino1="${BADINODES[bad_ino1_idx]}"
+	local bad_ino2="${BADINODES[bad_ino2_idx]}"
+	printf "bad: 0x%x 0x%x\n" "${bad_ino1}" "${bad_ino2}" | _tee_kernlog >> $seqres.full
+
+	# Bucket within AGI 0's iunlinked array.
+	local ino1_bucket="$((bad_ino1 % XFS_AGI_UNLINKED_BUCKETS))"
+	local ino2_bucket="$((bad_ino2 % XFS_AGI_UNLINKED_BUCKETS))"
+
+	# The first bad inode stays on the unlinked list but gets a nonzero
+	# nlink; the second bad inode is removed from the unlinked list but
+	# keeps its zero nlink
+	_scratch_xfs_db -x \
+		-c "inode ${bad_ino1}" -c "write -d core.nlinkv2 5555" \
+		-c "agi 0" -c "fuzz -d unlinked[${ino2_bucket}] ones" -c "print unlinked" >> $seqres.full
+
+	local iwatch=()
+	local idx
+
+	# Make a list of the adjacent iunlink bucket inodes for the first inode
+	# that we targeted.
+	if [ "${corruption_bucket_depth}" -gt 1 ]; then
+		# Previous ino in bucket
+		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth + 1) * XFS_AGI_UNLINKED_BUCKETS))
+		iwatch+=("${BADINODES[idx]}")
+	fi
+	iwatch+=("${bad_ino1}")
+	if [ "$((corruption_bucket_depth + 1))" -lt "${IUNLINK_BUCKETLEN}" ]; then
+		# Next ino in bucket
+		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth - 1) * XFS_AGI_UNLINKED_BUCKETS))
+		iwatch+=("${BADINODES[idx]}")
+	fi
+
+	# Make a list of the adjacent iunlink bucket inodes for the second
+	# inode that we targeted.
+	if [ "${corruption_bucket_depth}" -gt 1 ]; then
+		# Previous ino in bucket
+		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth + 1) * XFS_AGI_UNLINKED_BUCKETS))
+		iwatch+=("${BADINODES[idx + 1]}")
+	fi
+	iwatch+=("${bad_ino2}")
+	if [ "$((corruption_bucket_depth + 1))" -lt "${IUNLINK_BUCKETLEN}" ]; then
+		# Next ino in bucket
+		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth - 1) * XFS_AGI_UNLINKED_BUCKETS))
+		iwatch+=("${BADINODES[idx + 1]}")
+	fi
+
+	# Construct a grep string for tracepoints.
+	GREP_STR="(xrep_attempt|xrep_done|bucket ${ino1_bucket} |bucket ${ino2_bucket} |bucket ${fuzz_bucket} "
+	GREP_STR="(xrep_attempt|xrep_done|bucket ${ino1_bucket} |bucket ${ino2_bucket} "
+	for ino in "${iwatch[@]}"; do
+		f="$(printf "|ino 0x%x" "${ino}")"
+		GREP_STR="${GREP_STR}${f}"
+	done
+	GREP_STR="${GREP_STR})"
+	echo "grep -E \"${GREP_STR}\"" >> $seqres.full
+
+	# Dump everything we did to to the full file.
+	local db_dump=(-c 'agi 0' -c 'print unlinked')
+	db_dump+=(-c 'addr root' -c 'print')
+	test "${ino1_bucket}" -gt 0 && \
+		db_dump+=(-c "dump_iunlinked -a 0 -b $((ino1_bucket - 1))")
+	db_dump+=(-c "dump_iunlinked -a 0 -b ${ino1_bucket}")
+	db_dump+=(-c "dump_iunlinked -a 0 -b ${ino2_bucket}")
+	test "${ino2_bucket}" -lt 63 && \
+		db_dump+=(-c "dump_iunlinked -a 0 -b $((ino2_bucket + 1))")
+	db_dump+=(-c "inode $bad_ino1" -c 'print core.nlinkv2 v3.inumber next_unlinked')
+	db_dump+=(-c "inode $bad_ino2" -c 'print core.nlinkv2 v3.inumber next_unlinked')
+	_scratch_xfs_db "${db_dump[@]}" >> $seqres.full
+
+	# Test run of repair to make sure we find disconnected inodes
+	__repair_check_scratch | \
+		sed -e 's/disconnected inode \([0-9]*\)/disconnected inode XXXXXX/g' \
+		    -e 's/next_unlinked in inode \([0-9]*\)/next_unlinked in inode XXXXXX/g' \
+		    -e 's/unlinked bucket \([0-9]*\) is \([0-9]*\) in ag \([0-9]*\) .inode=\([0-9]*\)/unlinked bucket YY is XXXXXX in ag Z (inode=AAAAAA/g' | \
+		uniq -c >> $seqres.full
+	res=${PIPESTATUS[0]}
+	test "$res" -ne 0 || echo "repair returned $res after corruption?"
+}
+
+exercise_scratch() {
+	# Create a bunch of files...
+	declare -A inums
+	for ((i = 0; i < (XFS_AGI_UNLINKED_BUCKETS * 2); i++)); do
+		touch "${SCRATCH_MNT}/${i}" || break
+		inums["${i}"]="$(stat -c %i "${SCRATCH_MNT}/${i}")"
+	done
+
+	# ...then delete them to exercise the unlinked buckets
+	for ((i = 0; i < (XFS_AGI_UNLINKED_BUCKETS * 2); i++)); do
+		if ! rm -f "${SCRATCH_MNT}/${i}"; then
+			echo "rm failed on inum ${inums[$i]}"
+			break
+		fi
+	done
+}
+
+# Offline repair should not find anything
+final_check_scratch() {
+	__repair_check_scratch
+	res=$?
+	if [ $res -eq 2 ]; then
+		echo "scratch fs went offline?"
+		_scratch_mount
+		_scratch_unmount
+		__repair_check_scratch
+	fi
+	test "$res" -ne 0 && echo "repair returned $res?"
+}
+
+echo "+ Part 1: See if scrub can recover the unlinked list" | tee -a $seqres.full
+format_scratch
+_kernlog "no bad inodes"
+_scratch_mount
+_scratch_scrub >> $seqres.full
+exercise_scratch
+_scratch_unmount
+final_check_scratch
+
+echo "+ Part 2: Corrupt the first inode in the bucket" | tee -a $seqres.full
+format_scratch
+corrupt_scratch 1
+_scratch_mount
+_scratch_scrub >> $seqres.full
+exercise_scratch
+_scratch_unmount
+final_check_scratch
+
+echo "+ Part 3: Corrupt the middle inode in the bucket" | tee -a $seqres.full
+format_scratch
+corrupt_scratch 3
+_scratch_mount
+_scratch_scrub >> $seqres.full
+exercise_scratch
+_scratch_unmount
+final_check_scratch
+
+echo "+ Part 4: Corrupt the last inode in the bucket" | tee -a $seqres.full
+format_scratch
+corrupt_scratch 5
+_scratch_mount
+_scratch_scrub >> $seqres.full
+exercise_scratch
+_scratch_unmount
+final_check_scratch
+
+# success, all done
+echo Silence is golden
+status=0
+exit
diff --git a/tests/xfs/1873.out b/tests/xfs/1873.out
new file mode 100644
index 0000000000..0e36bd2304
--- /dev/null
+++ b/tests/xfs/1873.out
@@ -0,0 +1,6 @@
+QA output created by 1873
++ Part 1: See if scrub can recover the unlinked list
++ Part 2: Corrupt the first inode in the bucket
++ Part 3: Corrupt the middle inode in the bucket
++ Part 4: Corrupt the last inode in the bucket
+Silence is golden

