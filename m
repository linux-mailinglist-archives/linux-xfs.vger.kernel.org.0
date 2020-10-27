Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F2F29C84C
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Oct 2020 20:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829333AbgJ0TEn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Oct 2020 15:04:43 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50674 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1829330AbgJ0TEn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 15:04:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIsvGh111768;
        Tue, 27 Oct 2020 19:04:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=qsNfI1wuTKWJ8pWR0QHvQzeLVrIEeYFFqFbpNG8gLbs=;
 b=dNy2H4lrTv8jd6LigQym5lKgqrRHXOXx8gXjiy77v5YoRJWD9H0CAkeJAYxmAHpDJuyS
 9xj2JBLEo462LX0rTazgGPa3jGO0gLbkjfmCETy0Gh5aemAIz7yB0pgsN2i6+xdwm100
 bqZ7NUd6p5iHWGyB/uLY40dHEX1gk8EFCkbFAEkzevqt+Qz2vzl0xdiVJyr+zjUp6pFn
 iEMxmc1oI1egojfbrrD+gHBvIh/8SUNpvkkoeOvlmDWXxRPgCMvOgCdp41IBTBbcSPTK
 rHw5A5oE2N7lXYTCg7C2Ht+1SYQ6PyvKzJEW/MUVn7AQNr57kcSF56tSCxFmdYHaydNI xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm41fbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 19:04:40 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIuK5W090794;
        Tue, 27 Oct 2020 19:02:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cx1r3ux7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 19:02:39 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RJ2cnC006321;
        Tue, 27 Oct 2020 19:02:38 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 12:02:38 -0700
Subject: [PATCH 1/7] xfs: test fallocate ops when rt extent size is and isn't
 a power of 2
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 27 Oct 2020 12:02:37 -0700
Message-ID: <160382535741.1203387.10647004373989609905.stgit@magnolia>
In-Reply-To: <160382535113.1203387.16777876271740782481.stgit@magnolia>
References: <160382535113.1203387.16777876271740782481.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that fallocate works when the rt extent size is and isn't a
power of 2.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/763     |  181 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/763.out |   91 +++++++++++++++++++++++++++
 tests/xfs/group   |    1 
 3 files changed, 273 insertions(+)
 create mode 100755 tests/xfs/763
 create mode 100644 tests/xfs/763.out


diff --git a/tests/xfs/763 b/tests/xfs/763
new file mode 100755
index 00000000..4b0b08a0
--- /dev/null
+++ b/tests/xfs/763
@@ -0,0 +1,181 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 763
+#
+# Make sure that regular fallocate functions work ok when the realtime extent
+# size is and isn't a power of 2.
+#
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
+	_scratch_unmount >> $seqres.full 2>&1
+	test -e "$rtdev" && losetup -d $rtdev >> $seqres.full 2>&1
+	rm -f $tmp.* $TEST_DIR/$seq.rtvol
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "fzero"
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "finsert"
+# Note that we don't _require_realtime because we synthesize a rt volume
+# below.  This also means we cannot run the post-test check.
+_require_scratch_nocheck
+
+log() {
+	echo "$@" | tee -a $seqres.full
+}
+
+mk_file() {
+	local file="$1"
+	local rextsize="$2"
+
+	$XFS_IO_PROG -f \
+		-c "pwrite -S 0x57 -b $rextsize 0 $rextsize" \
+		-c "pwrite -S 0x58 -b $rextsize $rextsize $rextsize" \
+		-c "pwrite -S 0x59 -b $rextsize $((rextsize * 2)) $rextsize" \
+		-c fsync \
+		"$file" >> $seqres.full
+}
+
+check_file() {
+	filefrag -v "$1" >> $seqres.full
+	od -tx1 -Ad -c "$1" >> $seqres.full
+	md5sum "$1" | _filter_scratch | tee -a $seqres.full
+}
+
+test_ops() {
+	local rextsize=$1
+	local sz=$((rextsize * 3))
+	local unaligned_sz=65536
+	local unaligned_off=$((rextsize * 2 + unaligned_sz))
+	local lunaligned_sz=$((rextsize * 2))
+	local lunaligned_off=$unaligned_sz
+
+	log "Format rtextsize=$rextsize"
+	_scratch_unmount
+	_scratch_mkfs -r extsize=$rextsize >> $seqres.full
+	_scratch_mount || \
+		_notrun "Could not mount rextsize=$rextsize with synthetic rt volume"
+
+	# Force all files to be realtime files
+	$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
+
+	log "Test regular write, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/write $rextsize
+	check_file $SCRATCH_MNT/write
+
+	log "Test aligned falloc, rextsize=$rextsize"
+	$XFS_IO_PROG -f -c "falloc 0 $sz" $SCRATCH_MNT/falloc >> $seqres.full
+	check_file $SCRATCH_MNT/falloc
+
+	log "Test aligned fcollapse, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/collapse $rextsize
+	$XFS_IO_PROG -f -c "fcollapse $rextsize $rextsize" $SCRATCH_MNT/collapse >> $seqres.full
+	check_file $SCRATCH_MNT/collapse
+
+	log "Test aligned finsert, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/insert $rextsize
+	$XFS_IO_PROG -f -c "finsert $rextsize $rextsize" $SCRATCH_MNT/insert >> $seqres.full
+	check_file $SCRATCH_MNT/insert
+
+	log "Test aligned fzero, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/zero $rextsize
+	$XFS_IO_PROG -f -c "fzero $rextsize $rextsize" $SCRATCH_MNT/zero >> $seqres.full
+	check_file $SCRATCH_MNT/zero
+
+	log "Test aligned fpunch, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/punch $rextsize
+	$XFS_IO_PROG -f -c "fpunch $rextsize $rextsize" $SCRATCH_MNT/punch >> $seqres.full
+	check_file $SCRATCH_MNT/punch
+
+	log "Test unaligned falloc, rextsize=$rextsize"
+	$XFS_IO_PROG -f -c "falloc $unaligned_off $unaligned_sz" $SCRATCH_MNT/ufalloc >> $seqres.full
+	check_file $SCRATCH_MNT/ufalloc
+
+	log "Test unaligned fcollapse, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/ucollapse $rextsize
+	$XFS_IO_PROG -f -c "fcollapse $unaligned_off $unaligned_sz" $SCRATCH_MNT/ucollapse >> $seqres.full
+	check_file $SCRATCH_MNT/ucollapse
+
+	log "Test unaligned finsert, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/uinsert $rextsize
+	$XFS_IO_PROG -f -c "finsert $unaligned_off $unaligned_sz" $SCRATCH_MNT/uinsert >> $seqres.full
+	check_file $SCRATCH_MNT/uinsert
+
+	log "Test unaligned fzero, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/uzero $rextsize
+	$XFS_IO_PROG -f -c "fzero $unaligned_off $unaligned_sz" $SCRATCH_MNT/uzero >> $seqres.full
+	check_file $SCRATCH_MNT/uzero
+
+	log "Test unaligned fpunch, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/upunch $rextsize
+	$XFS_IO_PROG -f -c "fpunch $unaligned_off $unaligned_sz" $SCRATCH_MNT/upunch >> $seqres.full
+	check_file $SCRATCH_MNT/upunch
+
+	log "Test large unaligned fzero, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/luzero $rextsize
+	$XFS_IO_PROG -f -c "fzero $lunaligned_off $lunaligned_sz" $SCRATCH_MNT/luzero >> $seqres.full
+	check_file $SCRATCH_MNT/luzero
+
+	log "Test large unaligned fpunch, rextsize=$rextsize"
+	mk_file $SCRATCH_MNT/lpunch $rextsize
+	$XFS_IO_PROG -f -c "fpunch $lunaligned_off $lunaligned_sz" $SCRATCH_MNT/lpunch >> $seqres.full
+	check_file $SCRATCH_MNT/lpunch
+
+	log "Remount and compare"
+	_scratch_cycle_mount
+	check_file $SCRATCH_MNT/write
+	check_file $SCRATCH_MNT/falloc
+	check_file $SCRATCH_MNT/collapse
+	check_file $SCRATCH_MNT/insert
+	check_file $SCRATCH_MNT/zero
+	check_file $SCRATCH_MNT/punch
+	check_file $SCRATCH_MNT/ufalloc
+	check_file $SCRATCH_MNT/ucollapse
+	check_file $SCRATCH_MNT/uinsert
+	check_file $SCRATCH_MNT/uzero
+	check_file $SCRATCH_MNT/upunch
+	check_file $SCRATCH_MNT/luzero
+	check_file $SCRATCH_MNT/lpunch
+
+	log "Check everything, rextsize=$rextsize"
+	_check_scratch_fs
+}
+
+echo "Create fake rt volume"
+truncate -s 400m $TEST_DIR/$seq.rtvol
+rtdev=$(_create_loop_device $TEST_DIR/$seq.rtvol)
+
+echo "Make sure synth rt volume works"
+export USE_EXTERNAL=yes
+export SCRATCH_RTDEV=$rtdev
+_scratch_mkfs > $seqres.full
+_scratch_mount || \
+	_notrun "Could not mount with synthetic rt volume"
+
+# power of two
+test_ops 262144
+
+# not a power of two
+test_ops 327680
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/763.out b/tests/xfs/763.out
new file mode 100644
index 00000000..27c87bab
--- /dev/null
+++ b/tests/xfs/763.out
@@ -0,0 +1,91 @@
+QA output created by 763
+Create fake rt volume
+Make sure synth rt volume works
+Format rtextsize=262144
+Test regular write, rextsize=262144
+2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/write
+Test aligned falloc, rextsize=262144
+cb18a5d28e77522dfec6a6255bc3847e  SCRATCH_MNT/falloc
+Test aligned fcollapse, rextsize=262144
+2e94746ab733025c21a9cae7d19c18d0  SCRATCH_MNT/collapse
+Test aligned finsert, rextsize=262144
+24e228d3d5f68b612eceec47f8416a7d  SCRATCH_MNT/insert
+Test aligned fzero, rextsize=262144
+ecb6eb78ceb5c43ce86d523437b1fa95  SCRATCH_MNT/zero
+Test aligned fpunch, rextsize=262144
+ecb6eb78ceb5c43ce86d523437b1fa95  SCRATCH_MNT/punch
+Test unaligned falloc, rextsize=262144
+157e39521e47ad1c923a94edd69ad59c  SCRATCH_MNT/ufalloc
+Test unaligned fcollapse, rextsize=262144
+fallocate: Invalid argument
+2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/ucollapse
+Test unaligned finsert, rextsize=262144
+fallocate: Invalid argument
+2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/uinsert
+Test unaligned fzero, rextsize=262144
+4402ca12d4425d7f94c9f536b756d924  SCRATCH_MNT/uzero
+Test unaligned fpunch, rextsize=262144
+4402ca12d4425d7f94c9f536b756d924  SCRATCH_MNT/upunch
+Test large unaligned fzero, rextsize=262144
+be43c5a0de0b510a6a573d682b0df726  SCRATCH_MNT/luzero
+Test large unaligned fpunch, rextsize=262144
+be43c5a0de0b510a6a573d682b0df726  SCRATCH_MNT/lpunch
+Remount and compare
+2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/write
+cb18a5d28e77522dfec6a6255bc3847e  SCRATCH_MNT/falloc
+2e94746ab733025c21a9cae7d19c18d0  SCRATCH_MNT/collapse
+24e228d3d5f68b612eceec47f8416a7d  SCRATCH_MNT/insert
+ecb6eb78ceb5c43ce86d523437b1fa95  SCRATCH_MNT/zero
+ecb6eb78ceb5c43ce86d523437b1fa95  SCRATCH_MNT/punch
+157e39521e47ad1c923a94edd69ad59c  SCRATCH_MNT/ufalloc
+2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/ucollapse
+2dce060217cb2293dde96f7fdb3b9232  SCRATCH_MNT/uinsert
+4402ca12d4425d7f94c9f536b756d924  SCRATCH_MNT/uzero
+4402ca12d4425d7f94c9f536b756d924  SCRATCH_MNT/upunch
+be43c5a0de0b510a6a573d682b0df726  SCRATCH_MNT/luzero
+be43c5a0de0b510a6a573d682b0df726  SCRATCH_MNT/lpunch
+Check everything, rextsize=262144
+Format rtextsize=327680
+Test regular write, rextsize=327680
+dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/write
+Test aligned falloc, rextsize=327680
+63a6c5a8b8da92e30cd0ef23c56d4f06  SCRATCH_MNT/falloc
+Test aligned fcollapse, rextsize=327680
+8bdd728a7a4af4ac18bbcbe39dea14d5  SCRATCH_MNT/collapse
+Test aligned finsert, rextsize=327680
+2b178c860f7bef4c0e55399be5172c5e  SCRATCH_MNT/insert
+Test aligned fzero, rextsize=327680
+350defefe2530d8eb8d6a6772c81c206  SCRATCH_MNT/zero
+Test aligned fpunch, rextsize=327680
+350defefe2530d8eb8d6a6772c81c206  SCRATCH_MNT/punch
+Test unaligned falloc, rextsize=327680
+cb18a5d28e77522dfec6a6255bc3847e  SCRATCH_MNT/ufalloc
+Test unaligned fcollapse, rextsize=327680
+fallocate: Invalid argument
+dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/ucollapse
+Test unaligned finsert, rextsize=327680
+fallocate: Invalid argument
+dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/uinsert
+Test unaligned fzero, rextsize=327680
+c9c7b8791f445ec8c5fbbf82cb26b33c  SCRATCH_MNT/uzero
+Test unaligned fpunch, rextsize=327680
+c9c7b8791f445ec8c5fbbf82cb26b33c  SCRATCH_MNT/upunch
+Test large unaligned fzero, rextsize=327680
+d8bf9fa95e4a7dd228d0b03768045db9  SCRATCH_MNT/luzero
+Test large unaligned fpunch, rextsize=327680
+d8bf9fa95e4a7dd228d0b03768045db9  SCRATCH_MNT/lpunch
+Remount and compare
+dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/write
+63a6c5a8b8da92e30cd0ef23c56d4f06  SCRATCH_MNT/falloc
+8bdd728a7a4af4ac18bbcbe39dea14d5  SCRATCH_MNT/collapse
+2b178c860f7bef4c0e55399be5172c5e  SCRATCH_MNT/insert
+350defefe2530d8eb8d6a6772c81c206  SCRATCH_MNT/zero
+350defefe2530d8eb8d6a6772c81c206  SCRATCH_MNT/punch
+cb18a5d28e77522dfec6a6255bc3847e  SCRATCH_MNT/ufalloc
+dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/ucollapse
+dcc4a2d49adcac61bceae7db66611880  SCRATCH_MNT/uinsert
+c9c7b8791f445ec8c5fbbf82cb26b33c  SCRATCH_MNT/uzero
+c9c7b8791f445ec8c5fbbf82cb26b33c  SCRATCH_MNT/upunch
+d8bf9fa95e4a7dd228d0b03768045db9  SCRATCH_MNT/luzero
+d8bf9fa95e4a7dd228d0b03768045db9  SCRATCH_MNT/lpunch
+Check everything, rextsize=327680
diff --git a/tests/xfs/group b/tests/xfs/group
index b89c0a4e..ffd18166 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -519,3 +519,4 @@
 519 auto quick reflink
 520 auto quick reflink
 521 auto quick realtime growfs
+763 auto quick rw realtime

