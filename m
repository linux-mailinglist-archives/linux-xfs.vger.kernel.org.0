Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F25422A918
	for <lists+linux-xfs@lfdr.de>; Sun, 26 May 2019 10:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfEZIpu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 May 2019 04:45:50 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37203 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfEZIpu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 04:45:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id e15so13852309wrs.4;
        Sun, 26 May 2019 01:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KAqTSWaCfZ2eRPTYfukH/E0JoydIlA6rQXV7TtACnYY=;
        b=Wq3BOf/joym/GwGVtB6iR/Y5aWF4YRCmMLjSfRdEPL4a0YGl9MORdY0kQ0MkHVy/EN
         yd4SwBNFzv2+XALN+WEVy7MDC0TIibbkofu1mlY4+E/PR9RffxKi8QZs1fbTArIkxKhz
         oubNF0Rav6+ICvESaOC28IFb8oj4ocNQiCf8mnVNrmj7ZC+MNUjpuDKxnzr/Oqm3s2as
         CiUiqSilArE5Iip3VmxNN27LjYDjLsyC0+5ja2+kPBd8jLpa76QyZXu3SbyHJ6r+yMh0
         BYt122vZTHDZwQ3xg2jDFFkr2vXecTdYL8nBwLkWqF+/qFRrKd0LCk4LjJvmMBF4fT1S
         azjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KAqTSWaCfZ2eRPTYfukH/E0JoydIlA6rQXV7TtACnYY=;
        b=PhsKmTdmoRb/Zu/QoTlHrO9wvUOlOrAKGwBOnqC7NQOJ2WMsJP2RaBxOxjSRae1mXl
         TedR866pBr24r+HCvJ4Pa+5K08CZ/OOcxMpe3TvKOdBBxLpEXirDnhhD6XkAVa6XDbAo
         bVEjPDIfGgWaKncyL1dB4own8Vq5zZ2D8CYu4NnGiBEKwfeAwBMJ72BvoMFt51VSfkty
         PX3ADmSoIr5aO508CTFsnWdUMSNoZe8pSu8+t4du1vioY6p3kbfNUeg4vRA+tN7BCegB
         GYDyvU6I1A/iQjZQrPMnLxwurc8O4XWG6inccgAhQ/giCvjswXr0lyeiw9rRg5MUNirW
         PvqA==
X-Gm-Message-State: APjAAAUhqcdXKsFXdNCWo6BA+63mDByOVVXr486Yc3gSaCIsZsT/xeMW
        YJojZ23PMeh+5Su2md4jLHg=
X-Google-Smtp-Source: APXvYqwi3ooBt8E8X6grWk/xnqmGLIx9P0ANZCcG2R52nq7uU6R9IjfX2D87daGE/ojirOe2jva0vA==
X-Received: by 2002:a05:6000:1284:: with SMTP id f4mr58969334wrx.325.1558860348963;
        Sun, 26 May 2019 01:45:48 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id q11sm7089717wmc.15.2019.05.26.01.45.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 01:45:48 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v2 5/5] generic: cross-device copy_file_range test
Date:   Sun, 26 May 2019 11:45:35 +0300
Message-Id: <20190526084535.999-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190526084535.999-1-amir73il@gmail.com>
References: <20190526084535.999-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Old kernels do not support cross-device copy_file_range.
A new patch set is aimed at allowing cross-device copy_file_range
using the default in-kernel copy implementation.

[Amir] Split out cross-device copy_range test to a new test.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/991     | 56 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/991.out |  4 ++++
 tests/generic/group   |  1 +
 3 files changed, 61 insertions(+)
 create mode 100755 tests/generic/991
 create mode 100644 tests/generic/991.out

diff --git a/tests/generic/991 b/tests/generic/991
new file mode 100755
index 00000000..94266e89
--- /dev/null
+++ b/tests/generic/991
@@ -0,0 +1,56 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 991
+#
+# Exercise copy_file_range() across devices
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
+_require_scratch
+_require_xfs_io_command "copy_range"
+
+_scratch_mkfs 2>&1 >> $seqres.full
+_scratch_mount
+
+
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
+rm -f $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 128k" $testdir/file >> $seqres.full 2>&1
+
+$XFS_IO_PROG -f -c "copy_range -l 128k $testdir/file" $SCRATCH_MNT/copy
+cmp $testdir/file $SCRATCH_MNT/copy
+echo "md5sums after xdev copy:"
+md5sum $testdir/file $SCRATCH_MNT/copy | _filter_test_dir | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/991.out b/tests/generic/991.out
new file mode 100644
index 00000000..19c22dfe
--- /dev/null
+++ b/tests/generic/991.out
@@ -0,0 +1,4 @@
+QA output created by 991
+md5sums after xdev copy:
+81615449a98aaaad8dc179b3bec87f38  TEST_DIR/test-991/file
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/copy
diff --git a/tests/generic/group b/tests/generic/group
index 86802d54..bc5dac3b 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -553,3 +553,4 @@
 988 auto quick copy_range
 989 auto quick copy_range swap
 990 auto quick copy_range
+991 auto quick copy_range
-- 
2.17.1

