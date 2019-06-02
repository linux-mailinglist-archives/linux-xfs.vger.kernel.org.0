Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55CC33234F
	for <lists+linux-xfs@lfdr.de>; Sun,  2 Jun 2019 14:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfFBMlb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 2 Jun 2019 08:41:31 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44718 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfFBMlb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Jun 2019 08:41:31 -0400
Received: by mail-wr1-f66.google.com with SMTP id w13so9429807wru.11;
        Sun, 02 Jun 2019 05:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KAqTSWaCfZ2eRPTYfukH/E0JoydIlA6rQXV7TtACnYY=;
        b=iXL7h8ypG8InUTHRfiClRAyEZN8C7dteH5eN9LzW4jrc2HK+Jr7J4b8scY9CBmMAWk
         FfsGddp84we9wqQQBu9XkM8aRgesnJ7JmjXJwfHBr9TL5yAWSS4PUk0P6uHeAsYYOJ+z
         7UDmPOFj+qk3VbQfzsqxCSvOTnV5yzeAuGyLk+Xbdi9Amv5GKqdZ0uZYkQDCqXlAcBcr
         6L62CbxOZ5wySAFpHvULSmxw1ijN4nq1eN8W/FD7VioIXhiN72J83Zpm5msH/Uy3gt1d
         QQjCnpdXZdsua0630oKHV2ZZbeHFp5oyFD0HTEqbCcCXrKj9StO21hd59XFg/5LjY9Fr
         5yww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KAqTSWaCfZ2eRPTYfukH/E0JoydIlA6rQXV7TtACnYY=;
        b=PxFETq9D9VPC1M3WfXCTekFruyLS9qdc756hqotifgkGYvrLXPxPdGh+bjsjHdOFJs
         pmJOzCYtJEgkCINgf/5b2GeI7ai2LdBU55bfxtlypsFQG7vp7kxXiut01XavIJjYfdlH
         6UeuxLQt6nHr2OYXF0tWR3S5O4Azd8nyb6PgqB7j6VbXPs54XGDEhdIz2hzPOO5ipf4/
         aU8UAa/Vpg7v0KcLdwqJS/mh4yof7N2NcMhnMIMZj0chLu/YLJkD2WMNCfLBJkVTrNQd
         D8UKT3o2yCVURdWvGSJv5ifRsrd0JX5754DSIxV+tGcZLVK4L17/j5Uf8E9p2JM9S/Rt
         Lt3A==
X-Gm-Message-State: APjAAAW+BQBEiP/WcsRQwdIQoDNbo23rtervM+PWM0nW42e28BhsM1eD
        6kJJRwuygwdTDmurhvaUiXg=
X-Google-Smtp-Source: APXvYqyML6BT7av3tb+8l4fXkBDQfHD18QUHUQBMvtOyMdcfTEaUD2k79MsiZ6INwWqfNfOuLod/hg==
X-Received: by 2002:a5d:4f8b:: with SMTP id d11mr2627736wru.264.1559479289996;
        Sun, 02 Jun 2019 05:41:29 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id g185sm11214827wmf.30.2019.06.02.05.41.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 05:41:29 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v3 6/6] generic: cross-device copy_file_range test
Date:   Sun,  2 Jun 2019 15:41:14 +0300
Message-Id: <20190602124114.26810-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602124114.26810-1-amir73il@gmail.com>
References: <20190602124114.26810-1-amir73il@gmail.com>
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

