Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855DA24379
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 00:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfETWb5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 18:31:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38392 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbfETWb4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 18:31:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KMSXna106745;
        Mon, 20 May 2019 22:31:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=qpalY7AsLZGH4qkDYY1pYCSNv595Q67uCAf7hJr2Qgs=;
 b=fMNztmzdisU4lhwIrLHWzJFuS7YpxRpExocXXbzPgS20mSqL59ydL+HhzbFZqT7TgkBT
 4zXK1UtfwYwnZEd7NicW6aJmC46HbJ/ISVSBceJQfhsDSXFbEy9TDv77fYIZR+TYuwGM
 XVw+kexqMlHATGqOm/GbdCj+EwMLTahMqH8HJTdd1rXyjXp6OLPgsiNKruDz3rhO6kFA
 Edh6bEnzZzMyoGSR3JzuHeHNiD1NHfVaaqMDIhHcVz1sD7GtPRo9yW7t4Ysj5ZGqQCdG
 xdSqYFtdQHR23aq2eMxhN/n3aMTmOM/t6jpnxc7K/jbjtI/Yw3aORA5+lsjfvA5JsS+h kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2sj9ft9vn7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:31:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KMVcp8177885;
        Mon, 20 May 2019 22:31:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2sks1j3u4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:31:54 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KMVrxW026194;
        Mon, 20 May 2019 22:31:53 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 22:31:53 +0000
Subject: [PATCH ] xfs: check for COW overflows in i_delayed_blks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 20 May 2019 15:31:52 -0700
Message-ID: <155839151219.62947.9627045046429149685.stgit@magnolia>
In-Reply-To: <155839150599.62947.16097306072591964009.stgit@magnolia>
References: <155839150599.62947.16097306072591964009.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200138
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200138
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
 tests/xfs/907     |  180 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/907.out |    8 ++
 tests/xfs/group   |    1 
 3 files changed, 189 insertions(+)
 create mode 100755 tests/xfs/907
 create mode 100644 tests/xfs/907.out


diff --git a/tests/xfs/907 b/tests/xfs/907
new file mode 100755
index 00000000..2c21ac8e
--- /dev/null
+++ b/tests/xfs/907
@@ -0,0 +1,180 @@
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
+	umount $loop_mount > /dev/null 2>&1
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
+_require_loop
+_require_xfs_debug	# needed for xfs_bmap -c
+
+MAXEXTLEN=2097151	# cowextsize can't be more than MAXEXTLEN
+
+# Create a huge sparse filesystem on the scratch device because that's what
+# we're going to need to guarantee that we have enough blocks to overflow in
+# the first place.  In the worst case we have a 64k-block filesystem in which
+# we have to be able to reserve 2^32 blocks.  Adding in 20% overhead and a
+# 128M log, we get about 300T.
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+_require_fs_space $SCRATCH_MNT 200000	# 300T fs requires ~200MB of space
+
+loop_file=$SCRATCH_MNT/a.img
+loop_mount=$SCRATCH_MNT/a
+truncate -s 300T $loop_file
+loop_dev=$(_create_loop_device $loop_file)
+
+# Now we have to create the source file.  The goal is to overflow a 32-bit
+# i_delayed_blks, which means that we have to create at least that many delayed
+# allocation block reservations.  Take advantage of the fact that a cowextsize
+# hint causes creation of large speculative delalloc reservations in the cow
+# fork to reduce the amount of work we have to do.
+#
+# The maximum cowextsize is going to be MAXEXTLEN fs blocks on a 100T
+# filesystem, so start by setting up the hint.  Note that the current fsxattr
+# interface specifies its u32 cowextsize hint in units of bytes and therefore
+# can't handle MAXEXTLEN * blksz on most filesystems, so we set it via mkfs
+# because mkfs takes units of fs blocks, not bytes.
+
+_mkfs_dev -d cowextsize=$MAXEXTLEN -l size=128m $loop_dev >> $seqres.full
+mkdir $loop_mount
+mount -t xfs $loop_dev $loop_mount
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
+nr="$(( ((2 ** 32) / MAXEXTLEN) + 100 ))"
+seq $nr -1 0 | while read n; do
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
+seq $nr -1 0 | while read n; do
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
+	awk "
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
+_check_xfs_filesystem $loop_dev none none
+umount $loop_mount
+_destroy_loop_device $loop_dev
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
index 5a4ef4bf..e0c7fc97 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -504,3 +504,4 @@
 739 auto quick mkfs label
 742 auto quick spaceman
 743 auto quick health
+907 clone

