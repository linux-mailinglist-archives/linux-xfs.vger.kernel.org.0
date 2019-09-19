Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 751CBB772D
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Sep 2019 12:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388871AbfISKLt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 19 Sep 2019 06:11:49 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:48619 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727980AbfISKLt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Sep 2019 06:11:49 -0400
X-IronPort-AV: E=Sophos;i="5.64,523,1559491200"; 
   d="scan'208";a="75705416"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 19 Sep 2019 18:11:47 +0800
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id E87C84CE14E8;
        Thu, 19 Sep 2019 18:11:45 +0800 (CST)
Received: from localhost.localdomain (10.167.220.84) by
 G08CNEXCHPEKD02.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Thu, 19 Sep 2019 18:11:45 +0800
From:   Yang Xu <xuyang2018.jy@cn.fujitsu.com>
To:     <darrick.wong@oracle.com>, <david@fromorbit.com>,
        <guaneryu@gmail.com>
CC:     <fstests@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Subject: [PATCH] xfs/148-149: Remove xfs_prepair64 and xfs_prepair tests
Date:   Thu, 19 Sep 2019 18:08:15 +0800
Message-ID: <1568887695-3508-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.220.84]
X-yoursite-MailScanner-ID: E87C84CE14E8.A486F
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: xuyang2018.jy@cn.fujitsu.com
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The two commands have obsoleted long time ago, they don't run
on most systems. So I think we can remove them.

Signed-off-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
---
 tests/xfs/148     |  93 --------------
 tests/xfs/148.out | 299 ----------------------------------------------
 tests/xfs/149     | 112 -----------------
 tests/xfs/149.out | 123 -------------------
 tests/xfs/group   |   2 -
 5 files changed, 629 deletions(-)
 delete mode 100755 tests/xfs/148
 delete mode 100644 tests/xfs/148.out
 delete mode 100755 tests/xfs/149
 delete mode 100644 tests/xfs/149.out

diff --git a/tests/xfs/148 b/tests/xfs/148
deleted file mode 100755
index d9d7d221..00000000
--- a/tests/xfs/148
+++ /dev/null
@@ -1,93 +0,0 @@
-#! /bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# FS QA Test No. 148
-#
-# Exercise xfs parallel repair on broken filesystems
-# This is a clone of test 030 useing xfs_prepair64 instead of xfs_repair
-#
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1	# failure is the default!
-
-_cleanup()
-{
-	cd /
-	_scratch_unmount 2>/dev/null
-	rm -f $tmp.*
-}
-
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-# get standard environment, filters and checks
-. ./common/rc
-. ./common/filter
-. ./common/repair
-
-[ -z "$XFS_PARALLEL_REPAIR64_PROG" ] && _notrun "parallel repair binary xfs_prepair64 is not installed"
-
-# force use of parallel repair
-export XFS_REPAIR_PROG=$XFS_PARALLEL_REPAIR64_PROG
-
-# nuke the superblock, AGI, AGF, AGFL; then try repair the damage
-# 
-_check_ag()
-{
-	for structure in 'sb 0' 'agf 0' 'agi 0' 'agfl 0'
-	do
-		echo "Corrupting $structure - setting bits to $1"
-		_check_repair $1 "$structure"
-	done
-}
-
-# real QA test starts here
-_supported_fs xfs
-_supported_os Linux
-
-_require_scratch
-_require_no_large_scratch_dev
-
-DSIZE="-dsize=100m"
-
-# first we need to ensure there are no bogus secondary
-# superblocks between the primary and first secondary
-# superblock (hanging around from earlier tests)...
-#
-
-_scratch_mkfs_xfs $DSIZE >/dev/null 2>&1
-if [ $? -ne 0 ]		# probably don't have a big enough scratch
-then
-	_notrun "SCRATCH_DEV too small, results would be non-deterministic"
-else
-	_scratch_mount
-	src/feature -U $SCRATCH_DEV && \
-		_notrun "UQuota are enabled, test needs controlled sb recovery"
-	src/feature -G $SCRATCH_DEV && \
-		_notrun "GQuota are enabled, test needs controlled sb recovery"
-	src/feature -P $SCRATCH_DEV && \
-		_notrun "PQuota are enabled, test needs controlled sb recovery"
-	_scratch_unmount
-fi
-clear=""
-eval `xfs_db -r -c "sb 1" -c stack $SCRATCH_DEV | $PERL_PROG -ne '
-	if (/byte offset (\d+), length (\d+)/) {
-		print "clear=", $1 / 512, "\n"; exit
-	}'`
-[ -z "$clear" ] && echo "Cannot calculate length to clear"
-src/devzero -v -1 -n "$clear" $SCRATCH_DEV >/dev/null
-
-# now kick off the real prepair test...
-#
-_scratch_mkfs_xfs $DSIZE | _filter_mkfs 2>$tmp.mkfs
-. $tmp.mkfs
-_check_ag 0
-_check_ag -1
-
-# success, all done
-status=0
-exit
diff --git a/tests/xfs/148.out b/tests/xfs/148.out
deleted file mode 100644
index c8fb5511..00000000
--- a/tests/xfs/148.out
+++ /dev/null
@@ -1,299 +0,0 @@
-QA output created by 148
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
-Corrupting sb 0 - setting bits to 0
-Wrote X.XXKb (value 0x0)
-Phase 1 - find and verify superblock...
-bad primary superblock - bad magic number !!!
-
-attempting to find secondary superblock...
-found candidate secondary superblock...
-verified secondary superblock...
-writing modified primary superblock
-sb root inode value INO inconsistent with calculated value INO
-resetting superblock root inode pointer to INO
-sb realtime bitmap inode INO inconsistent with calculated value INO
-resetting superblock realtime bitmap ino pointer to INO
-sb realtime summary inode INO inconsistent with calculated value INO
-resetting superblock realtime summary ino pointer to INO
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - clear lost+found (if it exists) ...
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-        - resetting contents of realtime bitmap and summary inodes
-        - ensuring existence of lost+found directory
-        - traversing filesystem starting at / ... 
-        - traversal finished ... 
-        - traversing all unattached subtrees ... 
-        - traversals finished ... 
-        - moving disconnected inodes to lost+found ... 
-Phase 7 - verify and correct link counts...
-Note - stripe unit (SU) and width (SW) fields have been reset.
-Please set with mount -o sunit=<value>,swidth=<value>
-done
-Corrupting agf 0 - setting bits to 0
-Wrote X.XXKb (value 0x0)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-bad magic # 0x0 for agf 0
-bad version # 0 for agf 0
-bad length 0 for agf 0, should be LENGTH
-reset bad agf for ag 0
-bad agbno AGBNO for btbno root, agno 0
-bad agbno AGBNO for btbcnt root, agno 0
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - clear lost+found (if it exists) ...
-        - clearing existing "lost+found" inode
-        - deleting existing "lost+found" entry
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-        - resetting contents of realtime bitmap and summary inodes
-        - ensuring existence of lost+found directory
-        - traversing filesystem starting at / ... 
-        - traversal finished ... 
-        - traversing all unattached subtrees ... 
-        - traversals finished ... 
-        - moving disconnected inodes to lost+found ... 
-Phase 7 - verify and correct link counts...
-done
-Corrupting agi 0 - setting bits to 0
-Wrote X.XXKb (value 0x0)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-bad magic # 0x0 for agi 0
-bad version # 0 for agi 0
-bad length # 0 for agi 0, should be LENGTH
-reset bad agi for ag 0
-bad agbno AGBNO for inobt root, agno 0
-root inode chunk not found
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-error following ag 0 unlinked list
-        - process known inodes and perform inode discovery...
-imap claims in-use inode INO is free, correcting imap
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - clear lost+found (if it exists) ...
-        - clearing existing "lost+found" inode
-        - deleting existing "lost+found" entry
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-        - resetting contents of realtime bitmap and summary inodes
-        - ensuring existence of lost+found directory
-        - traversing filesystem starting at / ... 
-        - traversal finished ... 
-        - traversing all unattached subtrees ... 
-        - traversals finished ... 
-        - moving disconnected inodes to lost+found ... 
-Phase 7 - verify and correct link counts...
-done
-Corrupting agfl 0 - setting bits to 0
-Wrote X.XXKb (value 0x0)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - clear lost+found (if it exists) ...
-        - clearing existing "lost+found" inode
-        - deleting existing "lost+found" entry
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-        - resetting contents of realtime bitmap and summary inodes
-        - ensuring existence of lost+found directory
-        - traversing filesystem starting at / ... 
-        - traversal finished ... 
-        - traversing all unattached subtrees ... 
-        - traversals finished ... 
-        - moving disconnected inodes to lost+found ... 
-Phase 7 - verify and correct link counts...
-done
-Corrupting sb 0 - setting bits to -1
-Wrote X.XXKb (value 0xffffffff)
-Phase 1 - find and verify superblock...
-bad primary superblock - bad magic number !!!
-
-attempting to find secondary superblock...
-found candidate secondary superblock...
-verified secondary superblock...
-writing modified primary superblock
-sb root inode value INO inconsistent with calculated value INO
-resetting superblock root inode pointer to INO
-sb realtime bitmap inode INO inconsistent with calculated value INO
-resetting superblock realtime bitmap ino pointer to INO
-sb realtime summary inode INO inconsistent with calculated value INO
-resetting superblock realtime summary ino pointer to INO
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - clear lost+found (if it exists) ...
-        - clearing existing "lost+found" inode
-        - deleting existing "lost+found" entry
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-        - resetting contents of realtime bitmap and summary inodes
-        - ensuring existence of lost+found directory
-        - traversing filesystem starting at / ... 
-        - traversal finished ... 
-        - traversing all unattached subtrees ... 
-        - traversals finished ... 
-        - moving disconnected inodes to lost+found ... 
-Phase 7 - verify and correct link counts...
-Note - stripe unit (SU) and width (SW) fields have been reset.
-Please set with mount -o sunit=<value>,swidth=<value>
-done
-Corrupting agf 0 - setting bits to -1
-Wrote X.XXKb (value 0xffffffff)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-bad magic # 0xffffffff for agf 0
-bad version # -1 for agf 0
-bad sequence # -1 for agf 0
-bad length -1 for agf 0, should be LENGTH
-flfirst -1 in agf 0 too large (max = MAX)
-fllast -1 in agf 0 too large (max = MAX)
-reset bad agf for ag 0
-freeblk count 1 != flcount -1 in ag 0
-bad agbno AGBNO for btbno root, agno 0
-bad agbno AGBNO for btbcnt root, agno 0
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - clear lost+found (if it exists) ...
-        - clearing existing "lost+found" inode
-        - deleting existing "lost+found" entry
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-        - resetting contents of realtime bitmap and summary inodes
-        - ensuring existence of lost+found directory
-        - traversing filesystem starting at / ... 
-        - traversal finished ... 
-        - traversing all unattached subtrees ... 
-        - traversals finished ... 
-        - moving disconnected inodes to lost+found ... 
-Phase 7 - verify and correct link counts...
-done
-Corrupting agi 0 - setting bits to -1
-Wrote X.XXKb (value 0xffffffff)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-bad magic # 0xffffffff for agi 0
-bad version # -1 for agi 0
-bad sequence # -1 for agi 0
-bad length # -1 for agi 0, should be LENGTH
-reset bad agi for ag 0
-bad agbno AGBNO for inobt root, agno 0
-root inode chunk not found
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-imap claims in-use inode INO is free, correcting imap
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - clear lost+found (if it exists) ...
-        - clearing existing "lost+found" inode
-        - deleting existing "lost+found" entry
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-        - resetting contents of realtime bitmap and summary inodes
-        - ensuring existence of lost+found directory
-        - traversing filesystem starting at / ... 
-        - traversal finished ... 
-        - traversing all unattached subtrees ... 
-        - traversals finished ... 
-        - moving disconnected inodes to lost+found ... 
-Phase 7 - verify and correct link counts...
-done
-Corrupting agfl 0 - setting bits to -1
-Wrote X.XXKb (value 0xffffffff)
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-        - zero log...
-        - scan filesystem freespace and inode maps...
-bad agbno AGBNO in agfl, agno 0
-bad agbno AGBNO in agfl, agno 0
-bad agbno AGBNO in agfl, agno 0
-bad agbno AGBNO in agfl, agno 0
-        - found root inode chunk
-Phase 3 - for each AG...
-        - scan and clear agi unlinked lists...
-        - process known inodes and perform inode discovery...
-        - process newly discovered inodes...
-Phase 4 - check for duplicate blocks...
-        - setting up duplicate extent list...
-        - clear lost+found (if it exists) ...
-        - clearing existing "lost+found" inode
-        - deleting existing "lost+found" entry
-        - check for inodes claiming duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-        - reset superblock...
-Phase 6 - check inode connectivity...
-        - resetting contents of realtime bitmap and summary inodes
-        - ensuring existence of lost+found directory
-        - traversing filesystem starting at / ... 
-        - traversal finished ... 
-        - traversing all unattached subtrees ... 
-        - traversals finished ... 
-        - moving disconnected inodes to lost+found ... 
-Phase 7 - verify and correct link counts...
-done
diff --git a/tests/xfs/149 b/tests/xfs/149
deleted file mode 100755
index fbf66872..00000000
--- a/tests/xfs/149
+++ /dev/null
@@ -1,112 +0,0 @@
-#! /bin/bash
-# SPDX-License-Identifier: GPL-2.0
-# Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# FS QA Test No. 149
-#
-# Exercise xfs_prepair - ensure repeated use doesn't corrupt
-# This is a clone of test 031 using xfs_prepair instead of xfs_repair
-#
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
-rm -f $seqres.full
-
-# get standard environment, filters and checks
-. ./common/rc
-. ./common/repair
-. ./common/filter
-
-[ -z "$XFS_PARALLEL_REPAIR_PROG" ] && _notrun "parallel repair binary xfs_prepair is not installed"
-
-# force use of parallel repair
-export XFS_REPAIR_PROG=$XFS_PARALLEL_REPAIR_PROG
-
-_check_repair()
-{
-	echo "Repairing, round 0" >> $seqres.full
-	_scratch_xfs_repair 2>&1 | _filter_repair | tee -a $seqres.full >$tmp.0
-	for i in 1 2 3 4
-	do
-		echo "Repairing, iteration $i" | tee -a $seqres.full
-		_scratch_xfs_repair 2>&1 | _filter_repair >$tmp.$i
-		diff $tmp.0 $tmp.$i >> $seqres.full
-		if [ $? -ne 0 ]; then
-			echo "ERROR: repair round $i differs to round 0 (see $seqres.full)" | tee -a $seqres.full
-			break
-		fi
-		# echo all interesting stuff...
-		perl -ne '
-			s/(rebuilding directory inode) (\d+)/\1 INO/g;
-			s/internal log/<TYPEOF> log/g;
-			s/external log on \S+/<TYPEOF> log/g;
-			/^\S+/ && print;
-		' $tmp.$i
-	done
-	echo
-}
-
-# prototype file to create various directory forms
-_create_proto()
-{
-	total=$1
-	count=0
-
-	# take inode size into account for non-shortform directories...
-	[ $total -gt 0 ] && total=`expr $total \* $isize / 512`
-
-	cat >$tmp.proto <<EOF
-DUMMY1
-0 0
-: root directory
-d--777 3 1
-lost+found d--755 3 1
-$
-EOF
-
-	while [ $count -lt $total ]
-	do
-		let count=$count+1
-		cat >>$tmp.proto <<EOF
-${count}_of_${total}_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx ---755 3 1 /bin/true
-EOF
-	done
-	echo '$' >>$tmp.proto
-}
-
-# real QA test starts here
-_supported_fs xfs
-_supported_os Linux
-
-_require_scratch
-_require_no_large_scratch_dev
-
-# sanity test - default + one root directory entry
-# Note: must do this proto/mkfs now for later inode size calcs
-_create_proto 0
-echo "=== one entry (shortform)"
-_scratch_mkfs_xfs -p $tmp.proto >$tmp.mkfs0 2>&1
-_filter_mkfs <$tmp.mkfs0 >/dev/null 2>$tmp.mkfs
-. $tmp.mkfs
-_check_repair
-
-# block-form root directory & repeat
-_create_proto 20
-echo "=== twenty entries (block form)"
-_scratch_mkfs_xfs -p $tmp.proto | _filter_mkfs >/dev/null 2>&1
-_check_repair
-
-# leaf-form root directory & repeat
-_create_proto 1000
-echo "=== thousand entries (leaf form)"
-_scratch_mkfs_xfs -p $tmp.proto | _filter_mkfs >/dev/null 2>&1
-_check_repair
-
-# success, all done
-status=0
-exit
diff --git a/tests/xfs/149.out b/tests/xfs/149.out
deleted file mode 100644
index 0c65cd98..00000000
--- a/tests/xfs/149.out
+++ /dev/null
@@ -1,123 +0,0 @@
-QA output created by 149
-=== one entry (shortform)
-Repairing, iteration 1
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-Phase 3 - for each AG...
-Phase 4 - check for duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-Phase 6 - check inode connectivity...
-Phase 7 - verify and correct link counts...
-done
-Repairing, iteration 2
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-Phase 3 - for each AG...
-Phase 4 - check for duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-Phase 6 - check inode connectivity...
-Phase 7 - verify and correct link counts...
-done
-Repairing, iteration 3
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-Phase 3 - for each AG...
-Phase 4 - check for duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-Phase 6 - check inode connectivity...
-Phase 7 - verify and correct link counts...
-done
-Repairing, iteration 4
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-Phase 3 - for each AG...
-Phase 4 - check for duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-Phase 6 - check inode connectivity...
-Phase 7 - verify and correct link counts...
-done
-
-=== twenty entries (block form)
-Repairing, iteration 1
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-Phase 3 - for each AG...
-Phase 4 - check for duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-Phase 6 - check inode connectivity...
-rebuilding directory inode INO
-Phase 7 - verify and correct link counts...
-done
-Repairing, iteration 2
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-Phase 3 - for each AG...
-Phase 4 - check for duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-Phase 6 - check inode connectivity...
-rebuilding directory inode INO
-Phase 7 - verify and correct link counts...
-done
-Repairing, iteration 3
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-Phase 3 - for each AG...
-Phase 4 - check for duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-Phase 6 - check inode connectivity...
-rebuilding directory inode INO
-Phase 7 - verify and correct link counts...
-done
-Repairing, iteration 4
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-Phase 3 - for each AG...
-Phase 4 - check for duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-Phase 6 - check inode connectivity...
-rebuilding directory inode INO
-Phase 7 - verify and correct link counts...
-done
-
-=== thousand entries (leaf form)
-Repairing, iteration 1
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-Phase 3 - for each AG...
-Phase 4 - check for duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-Phase 6 - check inode connectivity...
-rebuilding directory inode INO
-Phase 7 - verify and correct link counts...
-done
-Repairing, iteration 2
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-Phase 3 - for each AG...
-Phase 4 - check for duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-Phase 6 - check inode connectivity...
-rebuilding directory inode INO
-Phase 7 - verify and correct link counts...
-done
-Repairing, iteration 3
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-Phase 3 - for each AG...
-Phase 4 - check for duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-Phase 6 - check inode connectivity...
-rebuilding directory inode INO
-Phase 7 - verify and correct link counts...
-done
-Repairing, iteration 4
-Phase 1 - find and verify superblock...
-Phase 2 - using <TYPEOF> log
-Phase 3 - for each AG...
-Phase 4 - check for duplicate blocks...
-Phase 5 - rebuild AG headers and trees...
-Phase 6 - check inode connectivity...
-rebuilding directory inode INO
-Phase 7 - verify and correct link counts...
-done
-
diff --git a/tests/xfs/group b/tests/xfs/group
index a7ad300e..f4ebcd8c 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -145,8 +145,6 @@
 145 dmapi
 146 dmapi
 147 dmapi
-148 repair auto
-149 repair auto
 150 dmapi
 151 dmapi
 152 dmapi
-- 
2.18.1



