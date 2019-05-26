Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5C62A915
	for <lists+linux-xfs@lfdr.de>; Sun, 26 May 2019 10:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfEZIpr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 May 2019 04:45:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36544 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727546AbfEZIpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 04:45:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id s17so13861458wru.3;
        Sun, 26 May 2019 01:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YvfcaysMqm5sUoN6yrpm+q3A2ssaIwvLl370KrpnxxA=;
        b=T0M5GXcsvuU3HfQD/Pjpk9NuvYovh9/LvCcZ9knf4LFg4BAVJpFo8rdQH0fSXR/aiK
         DK4Fn7IWb520UT/Qo0W+/AOV0A1bqjMNcc82onzyf7kzPDv1kO6kXebhkPzQSc+xrqP/
         XNonZwJgOU18yCqLKAn6srGQCyY9lnd5F9X5N9jjuWRa+KbrKzbujuU5hxdLD6/kj1cG
         oNNqQNVJ0oJ3I1Rep3ATep5NTLXu7yfNcRpFOExUnxclhGgnAafo94aTPsonofvCZBg5
         sQlozAJQMmYePNTdpnJoQ7VGNRmhTKE4KMnP0CsqbPY8ZlsKoEi15MIJJYgMLERmbYeG
         C5hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YvfcaysMqm5sUoN6yrpm+q3A2ssaIwvLl370KrpnxxA=;
        b=VA5FOpT414YAMEuhQLO8nMd7PpMYRRWDPIlA2OvyBcnIg2Nsp58XERvcWgpSCWyIDP
         mH+rb1tXpOmXRoWErvGES/sIRNCajwJJYv8ziwk6gx/s4kGebZwwb/h2Bbp8K9F2auVm
         r+ZffZb3GpKHeQjdheyyllrzHI3HTDyIYg8r85BTt+4xKCELwjQhcrTr7X/sZqEBbVJi
         0CWbg2eMKmsfvXdv7OiPwJ8Dr06b6iF/7PL3Q5Oh1GqvQTDA+09VJLqniV0lhdDRotam
         PcroMkkzkyZZ6ZtQhwDmEdIYHP2DaD0/IwOXR5HWj4S6cktgsVaqe6VLSbEQ9fTSJJEX
         /1eQ==
X-Gm-Message-State: APjAAAVqemYNoyOPXBs4xsa9anAJE3XpHW3IL+oopSCtuzFYIEWSMpNF
        YLKV6SxWgaCb1tMvFPBo1GQ=
X-Google-Smtp-Source: APXvYqz0GRIIbwi0QQkeqQSPvpkNDyMT7XxzeFtYpEPBGp3H9qSDmC1FQlAenFAmsryamUnbqHyldQ==
X-Received: by 2002:adf:b643:: with SMTP id i3mr23738246wre.284.1558860345090;
        Sun, 26 May 2019 01:45:45 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id q11sm7089717wmc.15.2019.05.26.01.45.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 01:45:44 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/5] generic: copy_file_range immutable file test
Date:   Sun, 26 May 2019 11:45:32 +0300
Message-Id: <20190526084535.999-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190526084535.999-1-amir73il@gmail.com>
References: <20190526084535.999-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This test case was split out of Dave Chinner's copy_file_range bounds
check test to reduce the requirements for running the bounds check.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/988     | 59 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/988.out |  5 ++++
 tests/generic/group   |  1 +
 3 files changed, 65 insertions(+)
 create mode 100755 tests/generic/988
 create mode 100644 tests/generic/988.out

diff --git a/tests/generic/988 b/tests/generic/988
new file mode 100755
index 00000000..0f4ee4ea
--- /dev/null
+++ b/tests/generic/988
@@ -0,0 +1,59 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 988
+#
+# Check that we cannot copy_file_range() to/from an immutable file
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
+	$CHATTR_PROG -i $testdir/immutable > /dev/null 2>&1
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
+_require_chattr i
+_require_xfs_io_command "copy_range"
+_require_xfs_io_command "chattr"
+
+testdir="$TEST_DIR/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+rm -f $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 128k" $testdir/file >> $seqres.full 2>&1
+
+# we have to open the file to be immutable rw and hold it open over the
+# chattr command to set it immutable, otherwise we won't be able to open it for
+# writing after it's been made immutable. (i.e. would exercise file mode checks,
+# not immutable inode flag checks).
+echo immutable file returns EPERM
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 64k" -c fsync $testdir/immutable | _filter_xfs_io
+$XFS_IO_PROG -f -c "chattr +i" -c "copy_range -l 32k $testdir/file" $testdir/immutable
+$XFS_IO_PROG -f -r -c "chattr -i" $testdir/immutable
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/988.out b/tests/generic/988.out
new file mode 100644
index 00000000..e74a96bf
--- /dev/null
+++ b/tests/generic/988.out
@@ -0,0 +1,5 @@
+QA output created by 988
+immutable file returns EPERM
+wrote 65536/65536 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+copy_range: Operation not permitted
diff --git a/tests/generic/group b/tests/generic/group
index b498eb56..20b95c14 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -550,3 +550,4 @@
 545 auto quick cap
 546 auto quick clone enospc log
 547 auto quick log
+988 auto quick copy_range
-- 
2.17.1

