Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBB8351BD
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 23:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFDVRS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 17:17:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58830 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfFDVRR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:17:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54KwVCU014962;
        Tue, 4 Jun 2019 21:17:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Wht9R9NbLYEU/lD91E1h08KbdyltoXxCnzS6FZ8hY0M=;
 b=zkTvt+jFU+wZLQaplY4j1Y2NJ+eoSvHI4NrsucCu+92Pl1CpEIACEP/OMTIWsyYPqj6r
 egzyESHJL6n0n8zFOT28IG9yNfnxy2rjM5hKTvzQXOegdJEfccw2EMsG6c5L553Um5L5
 zn3cWITe3VuBoGA2OylQ2rl+cYfZXbW7LCeR77C/kTkfIV3PK24/C0Fh/qjPqNxq8TRR
 7PrPAzbm1jK2VFuU61EBmwVmwdVBBvbeXueoXIp5qITILHshwdATAJiTUDyPJD3/Fqkl
 phoBQ//ZFZtq3Gzr9Q3PKqsFZpfbwE/MKVw5km5Sg4qxoR2TMGpS+8UYD2QMctXRCeHe kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2sugstfjkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 21:17:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LGUH2147641;
        Tue, 4 Jun 2019 21:17:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2swnh9twpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 21:17:12 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x54LHCHG026410;
        Tue, 4 Jun 2019 21:17:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 14:17:11 -0700
Subject: [PATCH 1/1] xfs: check for COW overflows in i_delayed_blks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 04 Jun 2019 14:17:10 -0700
Message-ID: <155968303075.1647082.5031279746723706503.stgit@magnolia>
In-Reply-To: <155968302402.1647082.16959798703857853077.stgit@magnolia>
References: <155968302402.1647082.16959798703857853077.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040133
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

With the new copy on write functionality it's possible to reserve so
much COW space for a file that we end up overflowing i_delayed_blks.
The only user-visible effect of this is to cause totally wrong i_blocks
output in stat, so check for that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/907     |  223 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/907.out |    8 ++
 tests/xfs/group   |    1 
 3 files changed, 232 insertions(+)
 create mode 100755 tests/xfs/907
 create mode 100644 tests/xfs/907.out


diff --git a/tests/xfs/907 b/tests/xfs/907
new file mode 100755
index 00000000..d85f12da
--- /dev/null
+++ b/tests/xfs/907
@@ -0,0 +1,223 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 907
+#
+# Try to overflow i_delayed_blks by setting the largest cowextsize hint
+# possible, creating a sparse file with a single byte every cowextsize bytes,
+# reflinking it, and retouching every written byte to see if we can create
+# enough speculative COW reservations to overflow i_delayed_blks.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	test -n "$loop_mount" && $UMOUNT_PROG $loop_mount > /dev/null 2>&1
+	test -n "$loop_dev" && _destroy_loop_device $loop_dev
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/reflink
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_cp_reflink
+_require_loop
+_require_xfs_debug	# needed for xfs_bmap -c
+
+MAXEXTLEN=2097151	# cowextsize can't be more than MAXEXTLEN
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+# Create a huge sparse filesystem on the scratch device because that's what
+# we're going to need to guarantee that we have enough blocks to overflow in
+# the first place.  We need to have at least enough free space on that huge fs
+# to handle one written block every MAXEXTLEN blocks and to reserve 2^32 blocks
+# in the COW fork.  There needs to be sufficient space in the scratch
+# filesystem to handle a 256M log, all the per-AG metadata, and all the data
+# written to the test file.
+#
+# Worst case, a 64k-block fs needs to be about 300TB.  Best case, a 1k block
+# filesystem needs ~5TB.  For the most common 4k case we only need a ~20TB fs.
+#
+# nr_cows is the number of writes we make to the filesystem.
+# blks_needed is the number of free blocks we need in the fs to trigger the
+#     overflow.  The destination file needs to have more than 2^32 blocks
+#     reserved for COW, and the source file needs to have 1 block written every
+#     MAXEXTLEN blocks (i.e. 2^32/MAXEXTLEN blocks) to set up the destination
+#     file.
+# loop_file_sz is the size of the filesystem we have to create to produce the
+#     overflow problems.  This is 20% more than blks_needed, and rounded to the
+#     nearest 512b so losetup doesn't whine.
+# est_nr_ags is a guess at the AG count, assuming that we'll have one AG per
+#     terabyte (which assumes that we need a multi-terabyte filesystem for this
+#     test).  We assume we'll need 16 blocks for AG metadata and 128K for inode
+#     chunks.
+# space_reqd_kb is the size of the huge sparse filesystem --
+#     256M for the log, per-AG metadata, and 10% more space than however much
+#     we will write to both test files.
+blksz=$(_get_file_block_size "$SCRATCH_MNT")
+nr_cows="$(( ((2 ** 32) / MAXEXTLEN) + 100 ))"
+blks_needed="$(( nr_cows * (1 + MAXEXTLEN) ))"
+loop_file_sz="$(( ((blksz * blks_needed) * 12 / 10) / 512 * 512 ))"
+est_nr_ags="$(( (loop_file_sz / (2 ** 40)) + 1 ))"
+est_ag_space_kb="$(( (est_nr_ags * 16 * blksz / 1024) + 128 ))"
+est_file_space_kb="$(( (((nr_cows * blksz) * 11 / 10) / 1024) ))"
+space_reqd_kb="$(( 262144 + est_ag_space_kb + 2 * est_file_space_kb ))"
+cat >> $seqres.full << ENDL
+blksz: $blksz
+nr_cows: $nr_cows
+blks_needed: $blks_needed
+loop_file_sz: $loop_file_sz
+est_nr_ags: $est_nr_ags
+est_ag_space_kb: $est_ag_space_kb
+est_file_space_kb: $est_file_space_kb
+space_reqd_kb: $space_reqd_kb
+ENDL
+_require_fs_space $SCRATCH_MNT $space_reqd_kb
+
+loop_file=$SCRATCH_MNT/a.img
+loop_mount=$SCRATCH_MNT/a
+$XFS_IO_PROG -f -c "truncate $loop_file_sz" $loop_file
+loop_dev=$(_create_loop_device $loop_file)
+
+# Now we have to create the source file.  The goal is to overflow a 32-bit
+# i_delayed_blks, which means that we have to create at least that many delayed
+# allocation block reservations.  Take advantage of the fact that a cowextsize
+# hint causes creation of large speculative delalloc reservations in the cow
+# fork to reduce the amount of work we have to do.
+#
+# The maximum cowextsize can only be set to MAXEXTLEN fs blocks on a filesystem
+# whose AGs each have more than MAXEXTLEN * 2 blocks.  This we can do easily
+# with a multi-terabyte filesystem, so start by setting up the hint.  Note that
+# the current fsxattr interface specifies its u32 cowextsize hint in units of
+# bytes and therefore can't handle MAXEXTLEN * blksz on most filesystems, so we
+# set it via mkfs because mkfs takes units of fs blocks, not bytes.
+
+_mkfs_dev -d cowextsize=$MAXEXTLEN -l size=256m $loop_dev >> $seqres.full
+mkdir $loop_mount
+mount $loop_dev $loop_mount
+
+echo "Create crazy huge file"
+huge_file="$loop_mount/a"
+touch "$huge_file"
+blksz=$(_get_file_block_size "$loop_mount")
+extsize_bytes="$(( MAXEXTLEN * blksz ))"
+
+# Make sure it actually set a hint.
+curr_cowextsize_str="$($XFS_IO_PROG -c 'cowextsize' "$huge_file")"
+echo "$curr_cowextsize_str" >> $seqres.full
+cowextsize_bytes="$(echo "$curr_cowextsize_str" | sed -e 's/^.\([0-9]*\).*$/\1/g')"
+test "$cowextsize_bytes" -eq 0 && echo "could not set cowextsize?"
+
+# Now we have to seed the file with sparse contents.  Remember, the goal is to
+# create a little more than 2^32 delayed allocation blocks in the COW fork with
+# as little effort as possible.  We know that speculative COW preallocation
+# will create MAXEXTLEN-length reservations for us, so that means we should
+# be able to get away with touching a single byte every extsize_bytes.  We
+# do this backwards to avoid having to move EOF.
+seq $nr_cows -1 0 | while read n; do
+	off="$((n * extsize_bytes))"
+	$XFS_IO_PROG -c "pwrite $off 1" "$huge_file" > /dev/null
+done
+
+echo "Reflink crazy huge file"
+_cp_reflink "$huge_file" "$huge_file.b"
+
+# Now that we've shared all the blocks in the file, we touch them all again
+# to create speculative COW preallocations.
+echo "COW crazy huge file"
+seq $nr_cows -1 0 | while read n; do
+	off="$((n * extsize_bytes))"
+	$XFS_IO_PROG -c "pwrite $off 1" "$huge_file" > /dev/null
+done
+
+# Compare the number of blocks allocated to this file (as reported by stat)
+# against the number of blocks that are in the COW fork.  If either one is
+# less than 2^32 then we have evidence of an overflow problem.
+echo "Check crazy huge file"
+allocated_stat_blocks="$(stat -c %b "$huge_file")"
+stat_blksz="$(stat -c %B "$huge_file")"
+allocated_fsblocks=$(( allocated_stat_blocks * stat_blksz / blksz ))
+
+# Make sure we got enough COW reservations to overflow a 32-bit counter.
+
+# Return the number of delalloc & real blocks given bmap output for a fork of a
+# file.  Output is in units of 512-byte blocks.
+count_fork_blocks() {
+	$AWK_PROG "
+{
+	if (\$3 == \"delalloc\") {
+		x += \$4;
+	} else if (\$3 == \"hole\") {
+		;
+	} else {
+		x += \$6;
+	}
+}
+END {
+	print(x);
+}
+"
+}
+
+# Count the number of blocks allocated to a file based on the xfs_bmap output.
+# Output is in units of filesystem blocks.
+count_file_fork_blocks() {
+	local tag="$1"
+	local file="$2"
+	local args="$3"
+
+	$XFS_IO_PROG -c "bmap $args -l -p -v" "$huge_file" > $tmp.extents
+	echo "$tag fork map" >> $seqres.full
+	cat $tmp.extents >> $seqres.full
+	local sectors="$(count_fork_blocks < $tmp.extents)"
+	echo "$(( sectors / (blksz / 512) ))"
+}
+
+cowblocks=$(count_file_fork_blocks cow "$huge_file" "-c")
+attrblocks=$(count_file_fork_blocks attr "$huge_file" "-a")
+datablocks=$(count_file_fork_blocks data "$huge_file" "")
+
+# Did we create more than 2^32 blocks in the cow fork?
+echo "datablocks is $datablocks" >> $seqres.full
+echo "attrblocks is $attrblocks" >> $seqres.full
+echo "cowblocks is $cowblocks" >> $seqres.full
+test "$cowblocks" -lt $((2 ** 32)) && \
+	echo "cowblocks (${cowblocks}) should be more than 2^32!"
+
+# Does stat's block allocation count exceed 2^32?
+echo "stat blocks is $allocated_fsblocks" >> $seqres.full
+test "$allocated_fsblocks" -lt $((2 ** 32)) && \
+	echo "stat blocks (${allocated_fsblocks}) should be more than 2^32!"
+
+# Finally, does st_blocks match what we computed from the forks?
+expected_allocated_fsblocks=$((datablocks + cowblocks + attrblocks))
+echo "expected stat blocks is $expected_allocated_fsblocks" >> $seqres.full
+
+_within_tolerance "st_blocks" $allocated_fsblocks $expected_allocated_fsblocks 2% -v
+
+echo "Test done"
+# Quick check the large sparse fs, but skip xfs_db because it doesn't scale
+# well on a multi-terabyte filesystem.
+LARGE_SCRATCH_DEV=yes _check_xfs_filesystem $loop_dev none none
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/907.out b/tests/xfs/907.out
new file mode 100644
index 00000000..cc07d659
--- /dev/null
+++ b/tests/xfs/907.out
@@ -0,0 +1,8 @@
+QA output created by 907
+Format and mount
+Create crazy huge file
+Reflink crazy huge file
+COW crazy huge file
+Check crazy huge file
+st_blocks is in range
+Test done
diff --git a/tests/xfs/group b/tests/xfs/group
index ffe4ae12..e528c559 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -504,3 +504,4 @@
 504 auto quick mkfs label
 505 auto quick spaceman
 506 auto quick health
+907 clone

