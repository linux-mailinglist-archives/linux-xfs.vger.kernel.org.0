Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1B33234E
	for <lists+linux-xfs@lfdr.de>; Sun,  2 Jun 2019 14:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFBMlb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 2 Jun 2019 08:41:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34906 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfFBMlb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Jun 2019 08:41:31 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so5697585wml.0;
        Sun, 02 Jun 2019 05:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rJTcx+QzDUIMX5pQIjEFkRKj1eFGDG37A3wUmJBpxTY=;
        b=EExG5bxkyS06/4Dp2cPnKXZYt3Tc6Map4IbrFIPXJb9s6MKC2uDvlISOMy105IlXyl
         clgF5VUw9lBJotxbSbM+Pezc02/jCSjbkfFECpCATqUNN/nyhyFDBw0XFbA2ElzwoLPo
         nzB58m9ApsaaZnoV3TLrHXakazuBJ8/pUdaHEDu08X0eMjRP+daYwnU30kmAk1H2fpjx
         bfljTGf9vG55o1iMJonuFO8C4pFc80xT5Gdyej4yj/Z+TfiwQPfwfjjdaaJlgqSWRdEi
         3W2ou0fey9zvCUWC7gvLCDN5ykVkiQMxI11AK3BeWtHR/H0qlEVY7bhSvn6uiaKLTA4C
         LeoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rJTcx+QzDUIMX5pQIjEFkRKj1eFGDG37A3wUmJBpxTY=;
        b=feKSuprnZp89FWYD8hb6qw3J4jiIYIOq6TRTdYs8dxBgktoEA5dwC1cVDbgKFxPIyD
         46eRVFlW15sq4RF1ObYNJS1FbGDlpr42yOK3hVhUZHCQnuAaTRKXAPmGYHDQOXccaaFW
         kQtMEOdKdDWbBWwBR8VWrPULZoDMEXfaJ2gk7eT23UJIwajcdzU18ioWGeUqQ899WDr0
         RnHT4tHLMdsihVmrGSDNGLJCA0pGh38PDhEnartEUo9l0pX6lkcXWU3IJNIi2XKnPrEd
         CKMTxFJHTgOYQqKOm9cZmjk+IZ6wU2goVAuGz/5WNPwkiBLeY5RN4puHNYQHu+IcqH+I
         ZQeg==
X-Gm-Message-State: APjAAAVkhRfuAZcYD8yQnpKnU9RnYPE3Yd8BEgLuXSlvFI4sdXynaGxi
        JdNs8ZTH4TJiqr83iZVUGuk=
X-Google-Smtp-Source: APXvYqwwx/N46DSzmeO0t4OCuCqJyTgnJlsVDPhTl/dDxERXv59x1xaCeziaVQCG5UjmakAZGwjIaQ==
X-Received: by 2002:a1c:23c4:: with SMTP id j187mr11593528wmj.176.1559479288529;
        Sun, 02 Jun 2019 05:41:28 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id g185sm11214827wmf.30.2019.06.02.05.41.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 05:41:27 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v3 5/6] generic: copy_file_range bounds test
Date:   Sun,  2 Jun 2019 15:41:13 +0300
Message-Id: <20190602124114.26810-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602124114.26810-1-amir73il@gmail.com>
References: <20190602124114.26810-1-amir73il@gmail.com>
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
Add requirements needed for large size copy tests and fifo test.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/990     | 132 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/990.out |  37 ++++++++++++
 tests/generic/group   |   1 +
 3 files changed, 170 insertions(+)
 create mode 100755 tests/generic/990
 create mode 100644 tests/generic/990.out

diff --git a/tests/generic/990 b/tests/generic/990
new file mode 100755
index 00000000..821aa10b
--- /dev/null
+++ b/tests/generic/990
@@ -0,0 +1,132 @@
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
+# For blockdev copy test case
+_require_loop
+#
+# This test effectively requires xfs_io with these commits
+#  2a42470b xfs_io: copy_file_range length is a size_t
+#  1a05efba io: open pipes in non-blocking mode
+#
+# Without those commits test will hang on old kernel when copying
+# very large size and when copying from a pipe.
+#
+# We require a new xfs_io feature of passing an open file as the
+# copy source, as an indication that the test can run without hanging
+# with large size argument and to avoid opening pipe in blocking mode.
+#
+_require_xfs_io_command "copy_range" "-f"
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
+# We need to use an existing major number otherwise we get ENXIO
+# so we _require_loop and use a loop device major number.
+# We are not going to do I/O so minor number doesn't matter.
+mknod $testdir/dev1 b 7 123
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
+# Pass input pipe as non-blocking open file to avoid old xfs_io (<4.20)
+# opening the pipe in blocking mode and causing the test to hang
+$XFS_IO_PROG -r -n -f -c "open $testdir/copy" -C "copy_range -l 32k -f 0" $testdir/fifo
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

