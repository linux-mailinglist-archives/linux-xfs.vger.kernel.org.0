Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0856A65FC
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Mar 2023 03:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjCAC7V (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 28 Feb 2023 21:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjCAC7U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2023 21:59:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5EE4C14;
        Tue, 28 Feb 2023 18:59:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37B9EB80E95;
        Wed,  1 Mar 2023 02:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CB5C433D2;
        Wed,  1 Mar 2023 02:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677639555;
        bh=z5jAZdyweqsbJxuPAl7Txq4qb0aWFYzUx5yfHvBpjGU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hY7PKxbZXx3gfiL9wUemnxyfHqCjqlpjd/YskDyFL2fn8k0+qzRSNqzKIG6BYHX3r
         BUE3/9PNrvoWEJOgDhaKte7ltuiN6ECzjbd6RwCqKKVZtQH3NykzrZInFBCYYXVJap
         /q0IP32vTZmYzZHuYUp4UhevjniI/wkgansbqwUrLp8sEl2A/xwqD+eV4NLUUX69Vo
         0TAh5XKorFn0McrH2NVXrVAw/nc0WBk2TtA/+SSnmSErCnSaGpo7gDG74nPEmeVkkW
         lowiSAaNyAfspNIq1JYRRGHyH6LNe+8kDOq/O0SeojYvSRjSQBhYfgxAhI3XIzRoNB
         VXAXi3VzDmLdA==
Subject: [PATCH 2/7] generic: test old xfs extent swapping ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Feb 2023 18:59:15 -0800
Message-ID: <167763955534.3796922.18393943074107557823.stgit@magnolia>
In-Reply-To: <167763954409.3796922.11086772690906428270.stgit@magnolia>
References: <167763954409.3796922.11086772690906428270.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add some tests to check the operation of the old xfs swapext ioctl.
There aren't any xfs-specific pieces in here, so they're in generic/

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc              |   11 +++++++++
 doc/group-names.txt    |    2 ++
 tests/generic/1200     |   55 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1200.out |    3 ++
 tests/generic/1201     |   53 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1201.out |    4 +++
 tests/generic/1202     |   47 ++++++++++++++++++++++++++++++++++++++
 tests/generic/1202.out |    2 ++
 tests/xfs/1202         |   59 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1202.out     |   12 ++++++++++
 tests/xfs/537          |    2 +-
 11 files changed, 249 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/1200
 create mode 100644 tests/generic/1200.out
 create mode 100755 tests/generic/1201
 create mode 100644 tests/generic/1201.out
 create mode 100755 tests/generic/1202
 create mode 100644 tests/generic/1202.out
 create mode 100755 tests/xfs/1202
 create mode 100644 tests/xfs/1202.out


diff --git a/common/rc b/common/rc
index 6852af79b4..caf87db47b 100644
--- a/common/rc
+++ b/common/rc
@@ -2581,6 +2581,17 @@ _require_xfs_io_command()
 		echo $testio | grep -q "Inappropriate ioctl" && \
 			_notrun "xfs_io $command support is missing"
 		;;
+	"swapext")
+		$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 128k -b 128k' $testfile > /dev/null
+		$XFS_IO_PROG -f -c 'truncate 128k' $testfile.1 > /dev/null
+		testio=`$XFS_IO_PROG -c "$command $param $testfile.1" $testfile 2>&1`
+		echo $testio | grep -q "bad argument count" && \
+			_notrun "xfs_io $command $param support is missing"
+		echo $testio | grep -q "Inappropriate ioctl" && \
+			_notrun "xfs_io $command $param ioctl support is missing"
+		rm -f $testfile.1
+		param_checked="$param"
+		;;
 	"utimes" )
 		testio=`$XFS_IO_PROG -f -c "utimes 0 0 0 0" $testfile 2>&1`
 		;;
diff --git a/doc/group-names.txt b/doc/group-names.txt
index ace59e05d9..a0ae6965a8 100644
--- a/doc/group-names.txt
+++ b/doc/group-names.txt
@@ -52,6 +52,7 @@ enospc			ENOSPC error reporting
 exportfs		file handles
 fiemap			fiemap ioctl
 filestreams		XFS filestreams allocator
+fiexchange		FIEXCHANGE_RANGE ioctl
 freeze			filesystem freeze tests
 fsck			general fsck tests
 fsmap			FS_IOC_GETFSMAP ioctl
@@ -123,6 +124,7 @@ splice			splice system call
 stress			fsstress filesystem exerciser
 subvol			btrfs subvolumes
 swap			swap files
+swapext			XFS_IOC_SWAPEXT ioctl
 symlink			symbolic links
 tape			dump and restore with a tape
 thin			thin provisioning
diff --git a/tests/generic/1200 b/tests/generic/1200
new file mode 100755
index 0000000000..58b93e2b6e
--- /dev/null
+++ b/tests/generic/1200
@@ -0,0 +1,55 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1200
+#
+# Can we use swapext to make the quota accounting incorrect?
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext quota
+
+# Import common functions.
+. ./common/filter
+. ./common/quota
+
+# real QA test starts here
+_require_xfs_io_command swapext '-v vfs'
+_require_user
+_require_nobody
+_require_quota
+_require_xfs_quota
+_require_scratch
+
+# Format filesystem and set up quota limits
+_scratch_mkfs > $seqres.full
+_qmount_option "usrquota,grpquota"
+_qmount >> $seqres.full
+
+# Set up initial files
+$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 256k -b 1m' $SCRATCH_MNT/a >> $seqres.full
+chown $qa_user $SCRATCH_MNT/a
+$XFS_IO_PROG -f -c 'pwrite -S 0x59 0 64k -b 64k' -c 'truncate 256k' $SCRATCH_MNT/b >> $seqres.full
+chown nobody $SCRATCH_MNT/b
+
+echo before swapext >> $seqres.full
+$XFS_QUOTA_PROG -x -c 'report -a' $SCRATCH_MNT >> $seqres.full
+stat $SCRATCH_MNT/* >> $seqres.full
+
+# Now try to swap the extents of the two files.  The command is allowed to
+# fail with -EINVAL (since that's what the first kernel fix does) or succeed
+# (because subsequent rewrites can handle quota).  Whatever the outcome, the
+# quota usage check at the end should never show a discrepancy.
+$XFS_IO_PROG -c "swapext $SCRATCH_MNT/b" $SCRATCH_MNT/a &> $tmp.swap
+cat $tmp.swap >> $seqres.full
+grep -v 'Invalid argument' $tmp.swap
+
+echo after swapext >> $seqres.full
+$XFS_QUOTA_PROG -x -c 'report -a' $SCRATCH_MNT >> $seqres.full
+stat $SCRATCH_MNT/* >> $seqres.full
+
+_check_quota_usage
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1200.out b/tests/generic/1200.out
new file mode 100644
index 0000000000..b1a6357719
--- /dev/null
+++ b/tests/generic/1200.out
@@ -0,0 +1,3 @@
+QA output created by 1200
+Comparing user usage
+Comparing group usage
diff --git a/tests/generic/1201 b/tests/generic/1201
new file mode 100755
index 0000000000..91e3773eaa
--- /dev/null
+++ b/tests/generic/1201
@@ -0,0 +1,53 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1201
+#
+# Can we use swapext to exceed the quota enforcement?
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext quota
+
+# Import common functions.
+. ./common/filter
+. ./common/quota
+
+# real QA test starts here
+_require_xfs_io_command swapext '-v vfs'
+_require_user
+_require_nobody
+_require_quota
+_require_xfs_quota
+_require_scratch
+
+# Format filesystem and set up quota limits
+_scratch_mkfs > $seqres.full
+_qmount_option "usrquota,grpquota"
+_qmount >> $seqres.full
+
+# Set up initial files
+$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 256k -b 1m' $SCRATCH_MNT/a >> $seqres.full
+chown $qa_user $SCRATCH_MNT/a
+$XFS_IO_PROG -f -c 'pwrite -S 0x59 0 64k -b 64k' -c 'truncate 256k' $SCRATCH_MNT/b >> $seqres.full
+chown nobody $SCRATCH_MNT/b
+
+# Set up a quota limit
+$XFS_QUOTA_PROG -x -c "limit -u bhard=70k nobody" $SCRATCH_MNT
+
+echo before swapext >> $seqres.full
+$XFS_QUOTA_PROG -x -c 'report -a' $SCRATCH_MNT >> $seqres.full
+stat $SCRATCH_MNT/* >> $seqres.full
+
+# Now try to swapext
+$XFS_IO_PROG -c "swapext $SCRATCH_MNT/b" $SCRATCH_MNT/a
+
+echo after swapext >> $seqres.full
+$XFS_QUOTA_PROG -x -c 'report -a' $SCRATCH_MNT >> $seqres.full
+stat $SCRATCH_MNT/* >> $seqres.full
+
+_check_quota_usage
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1201.out b/tests/generic/1201.out
new file mode 100644
index 0000000000..9001a59958
--- /dev/null
+++ b/tests/generic/1201.out
@@ -0,0 +1,4 @@
+QA output created by 1201
+swapext: Disk quota exceeded
+Comparing user usage
+Comparing group usage
diff --git a/tests/generic/1202 b/tests/generic/1202
new file mode 100755
index 0000000000..2afa546f1f
--- /dev/null
+++ b/tests/generic/1202
@@ -0,0 +1,47 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1202
+#
+# Make sure that swapext won't touch a swap file.
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	test -e "$dir/a" && swapoff $dir/a
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_require_xfs_io_command swapext '-v vfs'
+_require_test
+
+dir=$TEST_DIR/test-$seq
+mkdir -p $dir
+
+# Set up a fragmented swapfile and a dummy donor file.
+$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 32m -b 1m' -c fsync $dir/a >> $seqres.full
+$here/src/punch-alternating $dir/a
+$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 32m -b 1m' -c fsync $dir/a >> $seqres.full
+$MKSWAP_PROG $dir/a >> $seqres.full
+
+$XFS_IO_PROG -f -c 'pwrite -S 0x59 0 32m -b 1m' $dir/b >> $seqres.full
+
+swapon $dir/a || _notrun 'failed to swapon'
+
+# Now try to swapext.  The old code would return EINVAL for swapfiles
+# even though everything else in the VFS returns ETXTBSY.
+$XFS_IO_PROG -c "swapext $dir/b" $dir/a 2>&1 | \
+	sed -e 's/swapext: Invalid argument/swapext: Text file busy/g'
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/1202.out b/tests/generic/1202.out
new file mode 100644
index 0000000000..029d65e4d0
--- /dev/null
+++ b/tests/generic/1202.out
@@ -0,0 +1,2 @@
+QA output created by 1202
+swapext: Text file busy
diff --git a/tests/xfs/1202 b/tests/xfs/1202
new file mode 100755
index 0000000000..73e56641af
--- /dev/null
+++ b/tests/xfs/1202
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2022 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1202
+#
+# Simple tests of the old xfs swapext ioctl
+
+. ./common/preamble
+_begin_fstest auto quick fiexchange swapext
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.* $dir
+}
+
+# Import common functions.
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_xfs_io_command swapext '-v vfs'
+_require_test
+
+# We can't do any reasonable swapping if the files we're going to create are
+# realtime files, the rt extent size is greater than 1 block, and we can't use
+# atomic extent swapping to make sure that partially written extents are fully
+# swapped.
+file_blksz=$(_get_file_block_size $TEST_DIR)
+fs_blksz=$(_get_block_size $TEST_DIR)
+if (( $file_blksz != $fs_blksz )); then
+	_xfs_has_feature $TEST_DIR reflink || \
+		_notrun "test requires atomic extent swapping for rextsize=$((file_blksz / fs_blksz))"
+fi
+
+dir=$TEST_DIR/test-$seq
+mkdir -p $dir
+
+$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 256k -b 1m' $dir/a >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x59 0 256k -b 1m' $dir/b >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x60 0 256k -b 1m' $dir/c >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 128k -b 1m' $dir/d >> $seqres.full
+md5sum $dir/a $dir/b $dir/c $dir/d | _filter_test_dir
+
+# Swap two files that are the same length
+echo swap
+$XFS_IO_PROG -c "swapext $dir/b" $dir/a
+md5sum $dir/a $dir/b | _filter_test_dir
+
+# Try to swap two files that are not the same length
+echo fail swap
+$XFS_IO_PROG -c "swapext $dir/c" $dir/d
+md5sum $dir/c $dir/d | _filter_test_dir
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/1202.out b/tests/xfs/1202.out
new file mode 100644
index 0000000000..23127eb7b7
--- /dev/null
+++ b/tests/xfs/1202.out
@@ -0,0 +1,12 @@
+QA output created by 1202
+af5c6e2d6c297f3139a4e99df396c072  TEST_DIR/test-1202/a
+fba5c83875b2ab054e06a0284346ebdf  TEST_DIR/test-1202/b
+40c08c6f2aca19bb0d2cf1dbd8bc1b1c  TEST_DIR/test-1202/c
+81615449a98aaaad8dc179b3bec87f38  TEST_DIR/test-1202/d
+swap
+fba5c83875b2ab054e06a0284346ebdf  TEST_DIR/test-1202/a
+af5c6e2d6c297f3139a4e99df396c072  TEST_DIR/test-1202/b
+fail swap
+swapext: Bad address
+40c08c6f2aca19bb0d2cf1dbd8bc1b1c  TEST_DIR/test-1202/c
+81615449a98aaaad8dc179b3bec87f38  TEST_DIR/test-1202/d
diff --git a/tests/xfs/537 b/tests/xfs/537
index 7e11488799..6364db9b5d 100755
--- a/tests/xfs/537
+++ b/tests/xfs/537
@@ -7,7 +7,7 @@
 # Verify that XFS does not cause inode fork's extent count to overflow when
 # swapping forks between files
 . ./common/preamble
-_begin_fstest auto quick collapse
+_begin_fstest auto quick collapse swapext
 
 # Import common functions.
 . ./common/filter

