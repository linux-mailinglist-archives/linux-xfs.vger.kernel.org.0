Return-Path: <linux-xfs+bounces-24835-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B9EB3112D
	for <lists+linux-xfs@lfdr.de>; Fri, 22 Aug 2025 10:06:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4D33620722
	for <lists+linux-xfs@lfdr.de>; Fri, 22 Aug 2025 08:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E76372EB5C1;
	Fri, 22 Aug 2025 08:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EZtN/3SD"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30EC2EDD78;
	Fri, 22 Aug 2025 08:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755849773; cv=none; b=bMkwTRcUwtd9qRr+h/2aDs3XLmhQiZHSvn3Qns5650dkkzo4T82vt092C9s3BjLsrOn6AG059oAPWm4+zBzyogU46jKsDJby2/GWN7cr44Ldw5AYeuKhXjrQc/uwDTq84uBUNc5ZCV8e0UQiHHiE0jyei8JJ9+6VAFBod8FQMag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755849773; c=relaxed/simple;
	bh=5Whlb3M258/hYH1QZfI08fWCJYDAzM4q+pN3fIkE6zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDRb5y0G8J3QUUmHP1ipSJIKmDHOuuJ9+xyLKVqwNmJXOUgxLbnnDxcNf96Nb1PxIlSpK4bT+jfT98wtVrWT60OFxNcoVau0ozeb4aEpOmidvm40fTFk1IW+ITbA3c6NRwnWYcu90a6Km1eqoc4UBTX+Rm6jICWCvnGnHp5VQbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EZtN/3SD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LIsLYl017631;
	Fri, 22 Aug 2025 08:02:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=K/X0pllH+N+VUDutZ
	XHOgTw9gsmcrn73ZXWsZBojlR0=; b=EZtN/3SDICFeMwlRUWXWJbBeDpW1ryAOW
	yidPKDcfZ4jcB5C0E9Zr09H65bRIRl8sbk/OMH8PTk6CTx6TPAnokiBYW4O4yrKb
	Fo8PYe2ggSmlhOJMMgn4aAY7ShCw3gzivAmBoUjYEhCeTYWe2InlEprIKaYnaCp8
	Na9x1mbqFzqmRvuqGkvh+fjw4Z7vTdvs45kdXRNQFAvNhtSMaXnVJ3CIqVNqWJZm
	fejKh4CO+v0MT9JJtryaP8P66UnCd91yjfahxN7STX9om3Q58fJt1+chmbQ1QYlY
	82HZXK3OInhnGEqXpvWFmYWt7epSStpbLekqY60KoA1uhzHHHMNZQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48n38vw9eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Aug 2025 08:02:42 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57M81iUh004049;
	Fri, 22 Aug 2025 08:02:42 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48n38vw9em-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Aug 2025 08:02:42 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57M3hKNC031902;
	Fri, 22 Aug 2025 08:02:41 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48my5ycahv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Aug 2025 08:02:41 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57M82dHc31851004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 08:02:39 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9C0C2004B;
	Fri, 22 Aug 2025 08:02:39 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A1BE20040;
	Fri, 22 Aug 2025 08:02:37 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.210.10])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 22 Aug 2025 08:02:36 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org
Cc: Ritesh Harjani <ritesh.list@gmail.com>, djwong@kernel.org,
        john.g.garry@oracle.com, tytso@mit.edu, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: [PATCH v5 09/12] generic: Add sudden shutdown tests for multi block atomic writes
Date: Fri, 22 Aug 2025 13:32:08 +0530
Message-ID: <2b523de842ada3ac7759cedae80485ae201d7e5d.1755849134.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755849134.git.ojaswin@linux.ibm.com>
References: <cover.1755849134.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: g4cgeJoYBLSLclWQ3D0FY5BvqEmIueOQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDIyMiBTYWx0ZWRfX7UhP28ehQHmd
 a9tQuNv78hDx1HX2DZXHCxxZqGeN38HZFsRk87oFo7qGjjmsPhdcG/sY9utl8fLsDAtHsxNiG7o
 nr97lIRtgNgO9jPSYZ4A3hgOMLdNiUOUtRp8BHv3H+lqLMyaSRMew1ID44QLD6K4W7w3+pQlYmj
 2VVAqbpBPYLG68pfwBXA+XfqfZcwfSAJhTadKXBC6VAdcXu0dDvEU3D9A3uhQlKHRwACL6IPT0l
 fgT6P026DBqMZ0FwPe+2RnqWPDrfTA8GaanRpvED9XaQW7BA39PI6Ar2W7e8liPHs60yAid+Z8Y
 7vztWoqpqPyIo93uVOPSgKAzQERQjeUSH5U0Aqb2DhZwbAki6NQZLUt3mIXWf45a/tv+qWBsdo/
 sQP+Qn8E9QIVeM0Wojg2M08whXvUyw==
X-Proofpoint-GUID: PyMOLHLDRTMwOG2ksl_s5jIRw9q6LeSn
X-Authority-Analysis: v=2.4 cv=KPwDzFFo c=1 sm=1 tr=0 ts=68a82423 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=2OwXVqhp2XgA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=jzLDx6uKbS-OZFe_CzQA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_02,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2508110000 definitions=main-2508190222

This test is intended to ensure that multi blocks atomic writes
maintain atomic guarantees across sudden FS shutdowns.

The way we work is that we lay out a file with random mix of written,
unwritten and hole extents. Then we start performing atomic writes
sequentially on the file while we parallely shutdown the FS. Then we
note the last offset where the atomic write happened just before shut
down and then make sure blocks around it either have completely old
data or completely new data, ie the write was not torn during shutdown.

We repeat the same with completely written, completely unwritten and completely
empty file to ensure these cases are not torn either.  Finally, we have a
similar test for append atomic writes

Suggested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 tests/generic/1230     | 397 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/1230.out |   2 +
 2 files changed, 399 insertions(+)
 create mode 100755 tests/generic/1230
 create mode 100644 tests/generic/1230.out

diff --git a/tests/generic/1230 b/tests/generic/1230
new file mode 100755
index 00000000..cff5adc0
--- /dev/null
+++ b/tests/generic/1230
@@ -0,0 +1,397 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2025 IBM Corporation. All Rights Reserved.
+#
+# FS QA Test No. 1230
+#
+# Test multi block atomic writes with sudden FS shutdowns to ensure
+# the FS is not tearing the write operation
+. ./common/preamble
+. ./common/atomicwrites
+_begin_fstest auto atomicwrites
+
+_require_scratch_write_atomic_multi_fsblock
+_require_atomic_write_test_commands
+_require_scratch_shutdown
+_require_xfs_io_command "truncate"
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount >> $seqres.full
+
+testfile=$SCRATCH_MNT/testfile
+touch $testfile
+
+awu_max=$(_get_atomic_write_unit_max $testfile)
+blksz=$(_get_block_size $SCRATCH_MNT)
+echo "Awu max: $awu_max" >> $seqres.full
+
+num_blocks=$((awu_max / blksz))
+# keep initial value high for dry run. This will be
+# tweaked in dry_run() based on device write speed.
+filesize=$(( 10 * 1024 * 1024 * 1024 ))
+
+_cleanup() {
+	[ -n "$awloop_pid" ] && kill $awloop_pid &> /dev/null
+	wait
+}
+
+atomic_write_loop() {
+	local off=0
+	local size=$awu_max
+	for ((i=0; i<$((filesize / $size )); i++)); do
+		# Due to sudden shutdown this can produce errors so just
+		# redirect them to seqres.full
+		$XFS_IO_PROG -c "open -fsd $testfile" -c "pwrite -S 0x61 -DA -V1 -b $size $off $size" >> /dev/null 2>>$seqres.full
+		echo "Written to offset: $off" >> $tmp.aw
+		off=$((off + $size))
+	done
+}
+
+# This test has the following flow:
+# 1. Start doing sequential atomic writes in bg, upto $filesize
+# 2. Sleep for 0.2s and shutdown the FS
+# 3. kill the atomic write process
+# 4. verify the writes were not torn
+#
+# We ideally want the shutdown to happen while an atomic write is ongoing
+# but this gets tricky since faster devices can actually finish the whole
+# atomic write loop before sleep 0.2s completes, resulting in the shutdown
+# happening after the write loop which is not what we want. A simple solution
+# to this is to increase $filesize so step 1 takes long enough but a big
+# $filesize leads to create_mixed_mappings() taking very long, which is not
+# ideal.
+#
+# Hence, use the dry_run function to figure out the rough device speed and set
+# $filesize accordingly.
+dry_run() {
+	echo >> $seqres.full
+	echo "# Estimating ideal filesize..." >> $seqres.full
+	atomic_write_loop &
+	awloop_pid=$!
+
+	local i=0
+	# Wait for atleast first write to be recorded or 10s
+	while [ ! -f "$tmp.aw" -a $i -le 50 ]; do i=$((i + 1)); sleep 0.2; done
+
+	if [[ $i -gt 50 ]]
+	then
+		_fail "atomic write process took too long to start"
+	fi
+
+	echo >> $seqres.full
+	echo "# Shutting down filesystem while write is running" >> $seqres.full
+	_scratch_shutdown
+
+	kill $awloop_pid 2>/dev/null  # the process might have finished already
+	wait $awloop_pid
+	unset $awloop_pid
+
+	bytes_written=$(tail -n 1 $tmp.aw | cut -d" " -f4)
+	echo "# Bytes written in 0.2s: $bytes_written" >> $seqres.full
+
+	filesize=$((bytes_written * 3))
+	echo "# Setting \$filesize=$filesize" >> $seqres.full
+
+	rm $tmp.aw
+	sleep 0.5
+
+	_scratch_cycle_mount
+
+}
+
+create_mixed_mappings() {
+	local file=$1
+	local size_bytes=$2
+
+	echo "# Filling file $file with alternate mappings till size $size_bytes" >> $seqres.full
+	#Fill the file with alternate written and unwritten blocks
+	local off=0
+	local operations=("W" "U")
+
+	for ((i=0; i<$((size_bytes / blksz )); i++)); do
+		index=$(($i % ${#operations[@]}))
+		map="${operations[$index]}"
+
+		case "$map" in
+		    "W")
+			$XFS_IO_PROG -fc "pwrite -b $blksz $off $blksz" $file  >> /dev/null
+			;;
+		    "U")
+			$XFS_IO_PROG -fc "falloc $off $blksz" $file >> /dev/null
+			;;
+		esac
+		off=$((off + blksz))
+	done
+
+	sync $file
+}
+
+populate_expected_data() {
+	# create a dummy file with expected old data for different cases
+	create_mixed_mappings $testfile.exp_old_mixed $awu_max
+	expected_data_old_mixed=$(od -An -t x1 -j 0 -N $awu_max $testfile.exp_old_mixed)
+
+	$XFS_IO_PROG -fc "falloc 0 $awu_max" $testfile.exp_old_zeroes >> $seqres.full
+	expected_data_old_zeroes=$(od -An -t x1 -j 0 -N $awu_max $testfile.exp_old_zeroes)
+
+	$XFS_IO_PROG -fc "pwrite -b $awu_max 0 $awu_max" $testfile.exp_old_mapped >> $seqres.full
+	expected_data_old_mapped=$(od -An -t x1 -j 0 -N $awu_max $testfile.exp_old_mapped)
+
+	# create a dummy file with expected new data
+	$XFS_IO_PROG -fc "pwrite -S 0x61 -b $awu_max 0 $awu_max" $testfile.exp_new >> $seqres.full
+	expected_data_new=$(od -An -t x1 -j 0 -N $awu_max $testfile.exp_new)
+}
+
+verify_data_blocks() {
+	local verify_start=$1
+	local verify_end=$2
+	local expected_data_old="$3"
+	local expected_data_new="$4"
+
+	echo >> $seqres.full
+	echo "# Checking data integrity from $verify_start to $verify_end" >> $seqres.full
+
+	# After an atomic write, for every chunk we ensure that the underlying
+	# data is either the old data or new data as writes shouldn't get torn.
+	local off=$verify_start
+	while [[ "$off" -lt "$verify_end" ]]
+	do
+		#actual_data=$(xxd -s $off -l $awu_max -p $testfile)
+		actual_data=$(od -An -t x1 -j $off -N $awu_max $testfile)
+		if [[ "$actual_data" != "$expected_data_new" ]] && [[ "$actual_data" != "$expected_data_old" ]]
+		then
+			echo "Checksum match failed at off: $off size: $awu_max"
+			echo "Expected contents: (Either of the 2 below):"
+			echo
+			echo "Expected old: "
+			echo "$expected_data_old"
+			echo
+			echo "Expected new: "
+			echo "$expected_data_new"
+			echo
+			echo "Actual contents: "
+			echo "$actual_data"
+
+			_fail
+		fi
+		echo -n "Check at offset $off suceeded! " >> $seqres.full
+		if [[ "$actual_data" == "$expected_data_new" ]]
+		then
+			echo "matched new" >> $seqres.full
+		elif [[ "$actual_data" == "$expected_data_old" ]]
+		then
+			echo "matched old" >> $seqres.full
+		fi
+		off=$(( off + awu_max ))
+	done
+}
+
+# test data integrity for file by shutting down in between atomic writes
+test_data_integrity() {
+	echo >> $seqres.full
+	echo "# Writing atomically to file in background" >> $seqres.full
+	atomic_write_loop &
+	awloop_pid=$!
+
+	local i=0
+	# Wait for atleast first write to be recorded or 10s
+	while [ ! -f "$tmp.aw" -a $i -le 50 ]; do i=$((i + 1)); sleep 0.2; done
+
+	if [[ $i -gt 50 ]]
+	then
+		_fail "atomic write process took too long to start"
+	fi
+
+	echo >> $seqres.full
+	echo "# Shutting down filesystem while write is running" >> $seqres.full
+	_scratch_shutdown
+
+	kill $awloop_pid 2>/dev/null  # the process might have finished already
+	wait $awloop_pid
+	unset $awloop_pid
+
+	last_offset=$(tail -n 1 $tmp.aw | cut -d" " -f4)
+	if [[ -z $last_offset ]]
+	then
+		last_offset=0
+	fi
+
+	echo >> $seqres.full
+	echo "# Last offset of atomic write: $last_offset" >> $seqres.full
+
+	rm $tmp.aw
+	sleep 0.5
+
+	_scratch_cycle_mount
+
+	# we want to verify all blocks around which the shutdown happended
+	verify_start=$(( last_offset - (awu_max * 5)))
+	if [[ $verify_start < 0 ]]
+	then
+		verify_start=0
+	fi
+
+	verify_end=$(( last_offset + (awu_max * 5)))
+	if [[ "$verify_end" -gt "$filesize" ]]
+	then
+		verify_end=$filesize
+	fi
+}
+
+# test data integrity for file wiht written and unwritten mappings
+test_data_integrity_mixed() {
+	$XFS_IO_PROG -fc "truncate 0" $testfile >> $seqres.full
+
+	echo >> $seqres.full
+	echo "# Creating testfile with mixed mappings" >> $seqres.full
+	create_mixed_mappings $testfile $filesize
+
+	test_data_integrity
+
+	verify_data_blocks $verify_start $verify_end "$expected_data_old_mixed" "$expected_data_new"
+}
+
+# test data integrity for file with completely written mappings
+test_data_integrity_writ() {
+	$XFS_IO_PROG -fc "truncate 0" $testfile >> $seqres.full
+
+	echo >> $seqres.full
+	echo "# Creating testfile with fully written mapping" >> $seqres.full
+	$XFS_IO_PROG -c "pwrite -b $filesize 0 $filesize" $testfile >> $seqres.full
+	sync $testfile
+
+	test_data_integrity
+
+	verify_data_blocks $verify_start $verify_end "$expected_data_old_mapped" "$expected_data_new"
+}
+
+# test data integrity for file with completely unwritten mappings
+test_data_integrity_unwrit() {
+	$XFS_IO_PROG -fc "truncate 0" $testfile >> $seqres.full
+
+	echo >> $seqres.full
+	echo "# Creating testfile with fully unwritten mappings" >> $seqres.full
+	$XFS_IO_PROG -c "falloc 0 $filesize" $testfile >> $seqres.full
+	sync $testfile
+
+	test_data_integrity
+
+	verify_data_blocks $verify_start $verify_end "$expected_data_old_zeroes" "$expected_data_new"
+}
+
+# test data integrity for file with no mappings
+test_data_integrity_hole() {
+	$XFS_IO_PROG -fc "truncate 0" $testfile >> $seqres.full
+
+	echo >> $seqres.full
+	echo "# Creating testfile with no mappings" >> $seqres.full
+	$XFS_IO_PROG -c "truncate $filesize" $testfile >> $seqres.full
+	sync $testfile
+
+	test_data_integrity
+
+	verify_data_blocks $verify_start $verify_end "$expected_data_old_zeroes" "$expected_data_new"
+}
+
+test_filesize_integrity() {
+	$XFS_IO_PROG -c "truncate 0" $testfile >> $seqres.full
+
+	echo >> $seqres.full
+	echo "# Performing extending atomic writes over file in background" >> $seqres.full
+	atomic_write_loop &
+	awloop_pid=$!
+
+	local i=0
+	# Wait for atleast first write to be recorded or 10s
+	while [ ! -f "$tmp.aw" -a $i -le 50 ]; do i=$((i + 1)); sleep 0.2; done
+
+	if [[ $i -gt 50 ]]
+	then
+		_fail "atomic write process took too long to start"
+	fi
+
+	echo >> $seqres.full
+	echo "# Shutting down filesystem while write is running" >> $seqres.full
+	_scratch_shutdown
+
+	kill $awloop_pid 2>/dev/null  # the process might have finished already
+	wait $awloop_pid
+	unset $awloop_pid
+
+	local last_offset=$(tail -n 1 $tmp.aw | cut -d" " -f4)
+	if [[ -z $last_offset ]]
+	then
+		last_offset=0
+	fi
+
+	echo >> $seqres.full
+	echo "# Last offset of atomic write: $last_offset" >> $seqres.full
+	rm $tmp.aw
+	sleep 0.5
+
+	_scratch_cycle_mount
+	local filesize=$(_get_filesize $testfile)
+	echo >> $seqres.full
+	echo "# Filesize after shutdown: $filesize" >> $seqres.full
+
+	# To confirm that the write went atomically, we check:
+	# 1. The last block should be a multiple of awu_max
+	# 2. The last block should be the completely new data
+
+	if (( $filesize % $awu_max ))
+	then
+		echo "Filesize after shutdown ($filesize) not a multiple of atomic write unit ($awu_max)"
+	fi
+
+	verify_start=$(( filesize - (awu_max * 5)))
+	if [[ $verify_start < 0 ]]
+	then
+		verify_start=0
+	fi
+
+	local verify_end=$filesize
+
+	# Here the blocks should always match new data hence, for simplicity of
+	# code, just corrupt the $expected_data_old buffer so it never matches
+	local expected_data_old="POISON"
+	verify_data_blocks $verify_start $verify_end "$expected_data_old" "$expected_data_new"
+}
+
+$XFS_IO_PROG -fc "truncate 0" $testfile >> $seqres.full
+
+dry_run
+
+echo >> $seqres.full
+echo "# Populating expected data buffers" >> $seqres.full
+populate_expected_data
+
+# Loop 20 times to shake out any races due to shutdown
+for ((iter=0; iter<20; iter++))
+do
+	echo >> $seqres.full
+	echo "------ Iteration $iter ------" >> $seqres.full
+
+	echo >> $seqres.full
+	echo "# Starting data integrity test for atomic writes over mixed mapping" >> $seqres.full
+	test_data_integrity_mixed
+
+	echo >> $seqres.full
+	echo "# Starting data integrity test for atomic writes over fully written mapping" >> $seqres.full
+	test_data_integrity_writ
+
+	echo >> $seqres.full
+	echo "# Starting data integrity test for atomic writes over fully unwritten mapping" >> $seqres.full
+	test_data_integrity_unwrit
+
+	echo >> $seqres.full
+	echo "# Starting data integrity test for atomic writes over holes" >> $seqres.full
+	test_data_integrity_hole
+
+	echo >> $seqres.full
+	echo "# Starting filesize integrity test for atomic writes" >> $seqres.full
+	test_filesize_integrity
+done
+
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/1230.out b/tests/generic/1230.out
new file mode 100644
index 00000000..d01f54ea
--- /dev/null
+++ b/tests/generic/1230.out
@@ -0,0 +1,2 @@
+QA output created by 1230
+Silence is golden
-- 
2.49.0


