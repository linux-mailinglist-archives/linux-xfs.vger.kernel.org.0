Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 872832A917
	for <lists+linux-xfs@lfdr.de>; Sun, 26 May 2019 10:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfEZIpu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 May 2019 04:45:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33071 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727546AbfEZIpt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 04:45:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id d9so13855498wrx.0;
        Sun, 26 May 2019 01:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MqkblXOxVV9ASw3P2jXOp/Vdq1sqhgvgEl0BfGnSzus=;
        b=vNl8P5QsEvVHyTGavSu+EeAg67Uq4qsIJY7FVdzXEA/K2ApUr168PNqyNgGVSKfLwu
         ppndZCiurKpazssaAVfP+RgpauSJiRA2eXrZ2MvzA2V0cjFuAOs6A2BZ2I4nze5p2466
         QTh0WwCslELKqTvScUicacxip9Cl/R/xXEkjPlcHPLTupEta9gXeZ2S25bh4+HZq+dA2
         WMvye/o2MFv6FsQ6xgPRU99R61RMNcRttRCLlLAgN8r6+WZEfr32TxwY1a/+qL/FCvWw
         OJp4WAWGNplvH7YvMOaF13cWlJ/Cu8wRMf3R1fkGlGfwShrCBz+abA8z7niR3JNjNUFj
         9ULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MqkblXOxVV9ASw3P2jXOp/Vdq1sqhgvgEl0BfGnSzus=;
        b=crOwGBRKp4OeUvZf0Cn+OPp46OTpcS6lKKgmZfje1JpjwQN+lyHKSFQzQSq9hDdEHu
         BHXkvNcka9MwNRI8GyZBVeAQhMOhramKHWnpWygIy59B1OSQBsuRypSIUukcuiRmXCJe
         UjT5z80sZwi3m75WMHtag3ReHtEPa914h4WTHoX45IvCevcjoNhRRbk8tTx4hIVYu8Al
         cOPcDottEzsq3cSGKxbfmA4X2djYCuNx4drrJmgg+E6yiWYoVV6fMNkSU2qtaztKF6qb
         I+P4BpqQoggcLf0zAV0htNdRDY4H6edhqzwcmp6R7lI/rlXdmsxZjf0R7e6bgWaVLeN6
         Yy4A==
X-Gm-Message-State: APjAAAULHN8sDJWyT/IrzZNED/EeqPo0+7Qv/885YA6mwY2qcLHVwX+P
        9Wq5HOPO4W/C10RQ514+n4w=
X-Google-Smtp-Source: APXvYqzMQYiOsBWKs5vsfboziHLSdehUvg70O0ugPeru/xCN2wzH+KTgeOqOC+19WH4mMvPqJZxQiA==
X-Received: by 2002:adf:e3cd:: with SMTP id k13mr2655347wrm.200.1558860347709;
        Sun, 26 May 2019 01:45:47 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id q11sm7089717wmc.15.2019.05.26.01.45.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 01:45:47 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v2 4/5] generic: copy_file_range bounds test
Date:   Sun, 26 May 2019 11:45:34 +0300
Message-Id: <20190526084535.999-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190526084535.999-1-amir73il@gmail.com>
References: <20190526084535.999-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Test that copy_file_range will return the correct errors for various
error conditions and boundary constraints.

[Amir] Split out cross-device copy_range test and use only scratch dev.
Split out immutable/swapfile test cases to reduce the requirements to
run the bounds check to minimum and get coverage for more filesystems.
Remove the tests for read past EOF and write after chmod -r,
because we decided to stick with read(2)/write(2) semantics.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/990     | 123 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/990.out |  37 +++++++++++++
 tests/generic/group   |   1 +
 3 files changed, 161 insertions(+)
 create mode 100755 tests/generic/990
 create mode 100644 tests/generic/990.out

diff --git a/tests/generic/990 b/tests/generic/990
new file mode 100755
index 00000000..5e2421b6
--- /dev/null
+++ b/tests/generic/990
@@ -0,0 +1,123 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 990
+#
+# Exercise copy_file_range() syscall error conditions.
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
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs generic
+
+rm -f $seqres.full
+
+_require_test
+_require_xfs_io_command "copy_range"
+#
+# This test effectively requires xfs_io v4.20 with the commits
+#  2a42470b xfs_io: copy_file_range length is a size_t
+#  1a05efba io: open pipes in non-blocking mode
+#
+# The same xfs_io release also included the new 'chmod' command.
+# Use this fake requirement to prevent the test case of copy_range with fifo
+# from hanging the test with old xfs_io.
+#
+_require_xfs_io_command "chmod"
+
+testdir="$TEST_DIR/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+rm -f $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 128k" $testdir/file >> $seqres.full 2>&1
+
+echo source range overlaps destination range in same file returns EINVAL
+$XFS_IO_PROG -f -c "copy_range -s 32k -d 48k -l 32k $testdir/file" $testdir/file
+
+echo
+echo destination file O_RDONLY returns EBADF
+$XFS_IO_PROG -f -r -c "copy_range -l 32k $testdir/file" $testdir/copy
+
+echo
+echo destination file O_APPEND returns EBADF
+$XFS_IO_PROG -f -a -c "copy_range -l 32k $testdir/file" $testdir/copy
+
+echo
+echo source/destination as directory returns EISDIR
+$XFS_IO_PROG -c "copy_range -l 32k $testdir/file" $testdir
+$XFS_IO_PROG -f -c "copy_range -l 32k $testdir" $testdir/copy
+
+echo
+echo source/destination as blkdev returns EINVAL
+mknod $testdir/dev1 b 1 3
+$XFS_IO_PROG -c "copy_range -l 32k $testdir/file" $testdir/dev1
+$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/dev1" $testdir/copy
+
+echo
+echo source/destination as chardev returns EINVAL
+mknod $testdir/dev2 c 1 3
+$XFS_IO_PROG -c "copy_range -l 32k $testdir/file" $testdir/dev2
+$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/dev2" $testdir/copy
+
+echo
+echo source/destination as FIFO returns EINVAL
+mkfifo $testdir/fifo
+$XFS_IO_PROG -c "copy_range -l 32k $testdir/file" $testdir/fifo
+$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/fifo" $testdir/copy
+
+max_off=$((8 * 2**60 - 65536 - 1))
+min_off=65537
+
+echo
+echo length beyond 8EiB wraps around 0 returns EOVERFLOW
+$XFS_IO_PROG -f -c "copy_range -l 10e -s $max_off $testdir/file" $testdir/copy
+$XFS_IO_PROG -f -c "copy_range -l 10e -d $max_off $testdir/file" $testdir/copy
+
+echo
+echo source range beyond 8TiB returns 0
+$XFS_IO_PROG -c "copy_range -s $max_off -l $min_off -d 0 $testdir/file" $testdir/copy
+
+echo
+echo destination range beyond 8TiB returns EFBIG
+$XFS_IO_PROG -c "copy_range -l $min_off -s 0 -d $max_off $testdir/file" $testdir/copy
+
+echo
+echo destination larger than rlimit returns EFBIG
+rm -f $testdir/copy
+$XFS_IO_PROG -c "truncate 128k" $testdir/file
+
+# need a wrapper so the "File size limit exceeded" error can be filtered
+do_rlimit_copy()
+{
+	$XFS_IO_PROG -f -c "copy_range -l 32k -s 0 -d 16m $testdir/file" $testdir/copy
+}
+
+ulimit -f $((8 * 1024))
+ulimit -c 0
+do_rlimit_copy 2>&1 | grep -o "File size limit exceeded"
+ulimit -f unlimited
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/990.out b/tests/generic/990.out
new file mode 100644
index 00000000..05d137de
--- /dev/null
+++ b/tests/generic/990.out
@@ -0,0 +1,37 @@
+QA output created by 990
+source range overlaps destination range in same file returns EINVAL
+copy_range: Invalid argument
+
+destination file O_RDONLY returns EBADF
+copy_range: Bad file descriptor
+
+destination file O_APPEND returns EBADF
+copy_range: Bad file descriptor
+
+source/destination as directory returns EISDIR
+copy_range: Is a directory
+copy_range: Is a directory
+
+source/destination as blkdev returns EINVAL
+copy_range: Invalid argument
+copy_range: Invalid argument
+
+source/destination as chardev returns EINVAL
+copy_range: Invalid argument
+copy_range: Invalid argument
+
+source/destination as FIFO returns EINVAL
+copy_range: Invalid argument
+copy_range: Invalid argument
+
+length beyond 8EiB wraps around 0 returns EOVERFLOW
+copy_range: Value too large for defined data type
+copy_range: Value too large for defined data type
+
+source range beyond 8TiB returns 0
+
+destination range beyond 8TiB returns EFBIG
+copy_range: File too large
+
+destination larger than rlimit returns EFBIG
+File size limit exceeded
diff --git a/tests/generic/group b/tests/generic/group
index 4c100781..86802d54 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -552,3 +552,4 @@
 547 auto quick log
 988 auto quick copy_range
 989 auto quick copy_range swap
+990 auto quick copy_range
-- 
2.17.1

