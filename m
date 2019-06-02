Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496F23234C
	for <lists+linux-xfs@lfdr.de>; Sun,  2 Jun 2019 14:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfFBMl1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 2 Jun 2019 08:41:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40884 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfFBMl1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Jun 2019 08:41:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id u16so3380966wmc.5;
        Sun, 02 Jun 2019 05:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YvfcaysMqm5sUoN6yrpm+q3A2ssaIwvLl370KrpnxxA=;
        b=gmLN8a5wDYlbNnehooC3TjyfEIEm23Ahlg66msFPdV2p0W9szeK0bHqQ5jJmqTdxPi
         6xMru9nCidIr+OoJ0I/+9oTDeO7OvfI0m2o8fedxCKtGUOjjkrRj12rnR1VzOAuOcsj8
         /BMkFSO21bvwgWaXdrW3vhqzA2d8ERpcXc0lc9Tm6/PBWPSItogV8VYH9TILBt2NlPyn
         UPZnNukgdi3mMk22pP20LAsy0DQufImcg7qFvwBV0xVv/5RLUNZyqVtwSENtXVnUK2nK
         1xVSs4FsmqL3nEwMkClifxXlyygCLgDmiWriVsmthDeNpLNALpiyLwSfCzLuctnG2GHs
         Qdbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YvfcaysMqm5sUoN6yrpm+q3A2ssaIwvLl370KrpnxxA=;
        b=quoJuNrhHPwT0yL80JpSKLyJt2q/FUQphGTmcUogphDO14BDCcL5C7v/qpCnOSzsqb
         ikUzXWI0C36BTaIHH2Xv8M4prSRKlHVKYox8idyBCSK/8kfyNLBCwLLbRniKpKUiA8ua
         z4wQXf0wro3Zy0QFp869eUhwDxyKLMYXIzYgUO+oZz2dZqVv6Zd9SKo5DGNfT6nDG5VM
         J/4j/w3WIqrONbmExntpeWsZHxpxn2Fj8v8SqepT3hw6i+51a0ftyah7xyULzM6ZujfF
         //49HojEo2qLlxk7nrprMCi0FU9UIaX2vzzHK4nMM/IW9RtJC+W5RTYg4OVf76JynByj
         YXfA==
X-Gm-Message-State: APjAAAUDAHdcZjDzua7EHafHPdAYAoAsiATaw/EkKZEGcMYMjrHl8A+L
        FsIar5LhPzkSVBziU98cF5o=
X-Google-Smtp-Source: APXvYqw7J5qZG6dl3M/TaeaootiuJWUgGpHgpwykQdUyQlrxyXZKxn52XQnXSjqroLUUKIhiaUrmbQ==
X-Received: by 2002:a1c:480a:: with SMTP id v10mr11202031wma.120.1559479284244;
        Sun, 02 Jun 2019 05:41:24 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id g185sm11214827wmf.30.2019.06.02.05.41.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 05:41:23 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v3 2/6] generic: copy_file_range immutable file test
Date:   Sun,  2 Jun 2019 15:41:10 +0300
Message-Id: <20190602124114.26810-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602124114.26810-1-amir73il@gmail.com>
References: <20190602124114.26810-1-amir73il@gmail.com>
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

