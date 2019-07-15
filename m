Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14DB868A0C
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Jul 2019 14:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbfGOMz3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Jul 2019 08:55:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33279 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730046AbfGOMz3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 08:55:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so17044128wru.0;
        Mon, 15 Jul 2019 05:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vLeoU+hrQeU5oCVVzoS+w8oqWbkmdrGKWbcspdAxY7w=;
        b=fue0ema9+B4XL6b3/Oe7JXkRrJwRPoJ3MOmFRsWlCM63aYcfdmjwo492gT8ll8/MTv
         KG2nQ9dPQrJVBAXLBSU3Li5wnIMxgnkPyzuJdfhcW5MqO2ZPPCXL9ZmrBpLudCGu9FA2
         yUiKeSPDqbhjUvTkLTXsaEOrIh1x2VMgOk04VBVw68vfd71UmrMUTB5pn5OWG70KpCNR
         UTByVFYxWonmktIrb6MLz3yDG8NtoqFcUayxUXMB59Yz0C7WUsL6TrgrORQaWwpihePC
         v87ZcJE6n+wvkocdTbUlX1NQ+8Vcw2LmHK0dIetxkrLYNWUR6Z8dihsyVFc8NpXXrwKy
         dgjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vLeoU+hrQeU5oCVVzoS+w8oqWbkmdrGKWbcspdAxY7w=;
        b=Dkhdf1QL4WanO6o8dopPFOwoyoP0nYc9m3Gh2yAHHuTbGKg6Pq+W+jICAa54yx+Koh
         W0CIh9zCCL26GwOBdBD4Vu7/r9AaRGAIp5u82QgBnDQoqJPKL1vUcWZriRPGYr78dVcB
         CjnRyw8hgGg13JzLaFIRWYgdaJOXSAw3EkZu+WCKMmBNiStrgG/DRfq34i16L2/EHWCi
         HU41n45nUhdWdGjaBRfeamnnUJqyiKZ0zgxmGZsLbR6zirBGpdzAupqMAqEPi77FwYa9
         L8GiHm1MsMwIf0K1LemMNQR9o7yXuglbjZwbb4rQtDGLwNcjtRXzWZbMRoAo4p2uZSx8
         gR1A==
X-Gm-Message-State: APjAAAWw4g9fVQWJ8IynFAC8TsDZhhlRhYWAGgddMeXdVOSw09ccGhgm
        xUkiaZa3hMWHytHE7ZQ3zAIsgVhk
X-Google-Smtp-Source: APXvYqz90+Vmm9xgZAEnRpg4C+kYVITgHPcXLbEx6iPzzUEH37tYsNgZwbh6z04YLulWc12is7ZyiQ==
X-Received: by 2002:adf:afe7:: with SMTP id y39mr28394197wrd.350.1563195326720;
        Mon, 15 Jul 2019 05:55:26 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id u6sm20747920wml.9.2019.07.15.05.55.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 05:55:26 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v4 3/3] generic: cross-device copy_file_range test
Date:   Mon, 15 Jul 2019 15:55:16 +0300
Message-Id: <20190715125516.7367-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190715125516.7367-1-amir73il@gmail.com>
References: <20190715125516.7367-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Old kernels do not support cross-device copy_file_range.

This is a regression test for kernel commit:

  5dae222a5ff0 vfs: allow copy_file_range to copy across devices

[Amir] Split out cross-device copy_range test to a new test and
_notrun if kernel/filesystem do not support cross-device copy_range.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/991     | 64 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/991.out |  4 +++
 tests/generic/group   |  1 +
 3 files changed, 69 insertions(+)
 create mode 100755 tests/generic/991
 create mode 100644 tests/generic/991.out

diff --git a/tests/generic/991 b/tests/generic/991
new file mode 100755
index 00000000..69b8d3d5
--- /dev/null
+++ b/tests/generic/991
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 991
+#
+# Exercise copy_file_range() across devices supported by some
+# filesystems since kernel commit:
+#
+# 5dae222a5ff0 vfs: allow copy_file_range to copy across devices
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
+# expect success or EXDEV on filesystem/kernel that do not support
+# cross-device copy_range
+testio=`$XFS_IO_PROG -f -c "copy_range -l 128k $testdir/file" $SCRATCH_MNT/copy 2>&1`
+echo $testio | grep -q "cross-device" && \
+	_notrun "$FSTYP does not support cross-device copy_file_range"
+echo -n $testio
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
index 8e764597..b1a7c594 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -566,3 +566,4 @@
 561 auto stress dedupe
 562 auto clone
 990 auto quick copy_range
+991 auto quick copy_range
-- 
2.17.1

