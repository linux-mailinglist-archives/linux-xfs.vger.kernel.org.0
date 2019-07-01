Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BD64AD09
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 23:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731181AbfFRVIJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 17:08:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35286 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730469AbfFRVII (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 17:08:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IL4NLs034952;
        Tue, 18 Jun 2019 21:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=oh3rd2CPAuLvDUkCQijdNZGH97El3oEDn32K2pc8rtE=;
 b=oleokJuHCu9lK0ObWirIofxtYwJ6lspP+U0cLAJ5vrT2fXaWCYfA7MVcbDhhiyoyLN4M
 CDZukjnQuk9fIpvxdBt/bfGRoTvtpcpH/NfLx46SCVuW8PL4NpXJCnbRZLetyaPgdVN2
 t5XHm4s/9DlVcmOzgd8Qo3+N3UL8LSNn4vCDXIDYiD164GnbN2KFqKRysbqshnwNWqrW
 fH9C9HKZg+UO2L+WWuOn0asSZKeXoMvgWOjj8WlZPaWCEdpa14T9IolIxOfEhrvCOByQ
 GJzherfwGuqoWn7Gr3ZWyOxt2dmPOCWl66DzjmHWO15sXZ7EE8vo7ZvAVZwtMS9Ma8np nQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2t4r3tpuwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 21:07:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IL6R0e061246;
        Tue, 18 Jun 2019 21:07:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2t5mgc6msw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 21:07:39 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5IL7dpV028772;
        Tue, 18 Jun 2019 21:07:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 14:07:38 -0700
Subject: [PATCH 1/1] xfs: check for COW overflows in i_delayed_blks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com,
        fstests@vger.kernel.org
Date:   Tue, 18 Jun 2019 14:07:37 -0700
Message-ID: <156089205776.347309.3970978868590991055.stgit@magnolia>
In-Reply-To: <156089205119.347309.8343884194087205290.stgit@magnolia>
References: <156089205119.347309.8343884194087205290.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180167
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
 tests/xfs/907     |  199 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/907.out |    8 ++
 tests/xfs/group   |    1 
 3 files changed, 208 insertions(+)
 create mode 100755 tests/xfs/907
 create mode 100644 tests/xfs/907.out


diff --git a/tests/xfs/907 b/tests/xfs/907
new file mode 100755
index 00000000..92cd0399
--- /dev/null
+++ b/tests/xfs/907
@@ -0,0 +1,199 @@
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
+# In practice, the author observed that the space required on the scratch fs
+# never exceeded ~800M even for a 300T 6k-block filesystem, so we'll just ask
+# for about 1.2GB.
+blksz=$(_get_file_block_size "$SCRATCH_MNT")
+nr_cows="$(( ((2 ** 32) / MAXEXTLEN) + 100 ))"
+blks_needed="$(( nr_cows * (1 + MAXEXTLEN) ))"
+loop_file_sz="$(( ((blksz * blks_needed) * 12 / 10) / 512 * 512 ))"
+_require_fs_space $SCRATCH_MNT 1234567
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
+# Make sure the test actually set us up for the overflow.
+echo "datablocks is $datablocks" >> $seqres.full
+echo "attrblocks is $attrblocks" >> $seqres.full
+echo "cowblocks is $cowblocks" >> $seqres.full
+test "$cowblocks" -lt $((2 ** 32)) && \
+	echo "cowblocks (${cowblocks}) should be more than 2^32!"
+
+# Does stat's block allocation count exceed 2^32?
+# This is how we detect the incore delalloc count overflow.
+echo "stat blocks is $allocated_fsblocks" >> $seqres.full
+test "$allocated_fsblocks" -lt $((2 ** 32)) && \
+	echo "stat blocks (${allocated_fsblocks}) should be more than 2^32!"
+
+# Finally, does st_blocks match what we computed from the forks?
+# Sanity check the values computed from the forks.
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

