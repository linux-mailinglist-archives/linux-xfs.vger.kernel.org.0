Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F56331DFF
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Mar 2021 05:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhCIEkm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Mar 2021 23:40:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:32878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230140AbhCIEkU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Mar 2021 23:40:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5102065275;
        Tue,  9 Mar 2021 04:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615264820;
        bh=/34Q4K6Ae87lq3+BnoM2xICN4SUmvFlYJ9HGAm/kpHg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FYvfkGSg0abVCGbbgl6DG5Uvi3UYCR8hzrJtfonQvdeGa+Ydd5T55+G8gIfbFicWn
         gj+OXuXkJFqvFRACeNg1gRVqeOZzlt+xCllh7zV7QCMEYtV0Y5aosA/o1n6z2QAKAn
         hYEd7dqXnz4oyIKtvgI9lVjRmFNG8wkA65YyZve+afG2t4wJp26eEiIEZ0hHfcRpIt
         w1r0EsOY6ZBAAFMUVT5aq+aGzPQkU2RcKEVSlheX7ON5gCKf/3qIgTsgL1BWWfk17F
         eh4lwZqcf1M37SPBlrlaolMtxEE6SLYkToUkT/fkYFtybYkXf5gShJOf49fiDXenpC
         knWzlO8TlkaqQ==
Subject: [PATCH 03/10] xfs: test rtalloc alignment and math errors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 08 Mar 2021 20:40:20 -0800
Message-ID: <161526482015.1214319.6227125326960502859.stgit@magnolia>
In-Reply-To: <161526480371.1214319.3263690953532787783.stgit@magnolia>
References: <161526480371.1214319.3263690953532787783.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a couple of regression tests for "xfs: make sure the rt allocator
doesn't run off the end" and "xfs: ensure that fpunch, fcollapse, and
finsert operations are aligned to rt extent size".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/759     |  100 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/759.out |    2 +
 tests/xfs/760     |   68 ++++++++++++++++++++++++++++++++++++
 tests/xfs/760.out |    9 +++++
 tests/xfs/group   |    2 +
 5 files changed, 181 insertions(+)
 create mode 100755 tests/xfs/759
 create mode 100644 tests/xfs/759.out
 create mode 100755 tests/xfs/760
 create mode 100644 tests/xfs/760.out


diff --git a/tests/xfs/759 b/tests/xfs/759
new file mode 100755
index 00000000..8558fe30
--- /dev/null
+++ b/tests/xfs/759
@@ -0,0 +1,100 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 759
+#
+# This is a regression test for commit 2a6ca4baed62 ("xfs: make sure the rt
+# allocator doesn't run off the end") which fixes an overflow error in the
+# _near realtime allocator.  If the rt bitmap ends exactly at the end of a
+# block and the number of rt extents is large enough to allow an allocation
+# request larger than the maximum extent size, it's possible that during a
+# large allocation request, the allocator will fail to constrain maxlen on the
+# second run through the loop, and the rt bitmap range check will run right off
+# the end of the rtbitmap file.  When this happens, xfs triggers a verifier
+# error and returns EFSCORRUPTED.
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
+_require_realtime
+_require_test_program "punch-alternating"
+
+rm -f $seqres.full
+
+# Format filesystem to get the block size
+_scratch_mkfs > $seqres.full
+_scratch_mount >> $seqres.full
+
+blksz=$(_get_block_size $SCRATCH_MNT)
+rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
+rextblks=$((rextsize / blksz))
+
+echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
+
+_scratch_unmount
+
+# Format filesystem with a realtime volume whose size fits the following:
+# 1. Longer than (XFS MAXEXTLEN * blocksize) bytes.
+# 2. Exactly a multiple of (NBBY * blksz * rextsize) bytes.
+
+rtsize1=$((2097151 * blksz))
+rtsize2=$((8 * blksz * rextsize))
+rtsize=$(( $(blockdev --getsz $SCRATCH_RTDEV) * 512 ))
+
+echo "rtsize1 $rtsize1 rtsize2 $rtsize2 rtsize $rtsize" >> $seqres.full
+
+test $rtsize -gt $rtsize1 || \
+	_notrun "scratch rt device too small, need $rtsize1 bytes"
+test $rtsize -gt $rtsize2 || \
+	_notrun "scratch rt device too small, need $rtsize2 bytes"
+
+rtsize=$((rtsize - (rtsize % rtsize2)))
+
+echo "rt size will be $rtsize" >> $seqres.full
+
+_scratch_mkfs -r size=$rtsize >> $seqres.full
+_scratch_mount >> $seqres.full
+
+# Make sure the root directory has rtinherit set so our test file will too
+$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
+
+# Allocate some stuff at the start, to force the first falloc of the ouch file
+# to happen somewhere in the middle of the rt volume
+$XFS_IO_PROG -f -c 'falloc 0 64m' "$SCRATCH_MNT/b"
+$here/src/punch-alternating -i $((rextblks * 2)) -s $((rextblks)) "$SCRATCH_MNT/b"
+
+avail="$(df -P "$SCRATCH_MNT" | awk 'END {print $4}')"1
+toobig="$((avail * 2))"
+
+# falloc the ouch file in the middle of the rt extent to exercise the near
+# allocator in the last step.
+$XFS_IO_PROG -f -c 'falloc 0 1g' "$SCRATCH_MNT/ouch"
+
+# Try to get the near allocator to overflow on an allocation that matches
+# exactly one of the rtsummary size levels.  This should return ENOSPC and
+# not EFSCORRUPTED.
+$XFS_IO_PROG -f -c "falloc 0 ${toobig}k" "$SCRATCH_MNT/ouch"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/759.out b/tests/xfs/759.out
new file mode 100644
index 00000000..df693d50
--- /dev/null
+++ b/tests/xfs/759.out
@@ -0,0 +1,2 @@
+QA output created by 759
+fallocate: No space left on device
diff --git a/tests/xfs/760 b/tests/xfs/760
new file mode 100755
index 00000000..7f2b52d4
--- /dev/null
+++ b/tests/xfs/760
@@ -0,0 +1,68 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 760
+#
+# Make sure we validate realtime extent size alignment for fallocate modes.
+# This is a regression test for fe341eb151ec ("xfs: ensure that fpunch,
+# fcollapse, and finsert operations are aligned to rt extent size")
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
+_require_realtime
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "finsert"
+_require_xfs_io_command "funshare"
+_require_xfs_io_command "fzero"
+_require_xfs_io_command "falloc"
+
+rm -f $seqres.full
+
+# Format filesystem with a 256k realtime extent size
+_scratch_mkfs -r extsize=256k > $seqres.full
+_scratch_mount >> $seqres.full
+
+blksz=$(_get_block_size $SCRATCH_MNT)
+rextsize=$($XFS_INFO_PROG $SCRATCH_MNT | grep realtime.*extsz | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
+rextblks=$((rextsize / blksz))
+
+echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
+
+# Make sure the root directory has rtinherit set so our test file will too
+$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
+
+sz=$((rextsize * 100))
+range="$((blksz * 3)) $blksz"
+
+for verb in fpunch finsert fcollapse fzero funshare falloc; do
+	echo "test $verb"
+	$XFS_IO_PROG -f -c "falloc 0 $sz" "$SCRATCH_MNT/b"
+	$XFS_IO_PROG -f -c "$verb $range" "$SCRATCH_MNT/b"
+	rm -f "$SCRATCH_MNT/b"
+	_scratch_cycle_mount
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/760.out b/tests/xfs/760.out
new file mode 100644
index 00000000..3d73c6fa
--- /dev/null
+++ b/tests/xfs/760.out
@@ -0,0 +1,9 @@
+QA output created by 760
+test fpunch
+test finsert
+fallocate: Invalid argument
+test fcollapse
+fallocate: Invalid argument
+test fzero
+test funshare
+test falloc
diff --git a/tests/xfs/group b/tests/xfs/group
index 4dd9901f..318468b5 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -501,4 +501,6 @@
 526 auto quick mkfs
 527 auto quick quota
 758 auto quick rw attr realtime
+759 auto quick rw realtime
+760 auto quick rw collapse punch insert zero prealloc
 763 auto quick rw realtime

