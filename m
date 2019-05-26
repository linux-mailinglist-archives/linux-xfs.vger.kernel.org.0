Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132A32A916
	for <lists+linux-xfs@lfdr.de>; Sun, 26 May 2019 10:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfEZIps (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 May 2019 04:45:48 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44092 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfEZIps (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 May 2019 04:45:48 -0400
Received: by mail-wr1-f65.google.com with SMTP id w13so5476924wru.11;
        Sun, 26 May 2019 01:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tHETMryGVwSaOgR/Yx7oTEa1ui+4bN17f008odA0yXI=;
        b=QEOxZ33OOFRHrOrc3+DmWTWa6pWMgSjYVeeYJj9nxGy9+xFrF5h0nclJcTdiK0CGWV
         cAc/f9XA2mwpXJKxvPwF3zQ2DYSVkyu5r7dyQd5+aBMJE8dA4YEzY1s7bQ8BGea1O4lZ
         l0JYC3SmskhaiMwRHmOMvUMDcU/E7wnG6SInKtO6qcDyqrZ2w2B06fil/zLsG5gfX9uP
         B+73+SDKLLTtCFPgwsgb1I6B5hTm1Cp/y9MNQd3yE7/Nk42EtHp9gpYP6a9gCneX7p1N
         +Jlcu3lw7lWhcdwYEtX5ykZBsHROeliNQak/uhErVcBszbQ/YoFS4vTRDhIU9M1IorJ5
         mxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tHETMryGVwSaOgR/Yx7oTEa1ui+4bN17f008odA0yXI=;
        b=Ge61kUqJ+rbsQtnHTPJJK8KqUSiOsYtZMr3raLt6wn+WmY9/eH9lIZZiK8t+fiQUCb
         rQf5f50g07w5ZirGE1MJvg8dkbEGu/8AdSon7ZEMQwQ7hj4CCia2Fzn4+R5YonQ9X7mc
         5C8vHE87ItLQd21Q/jH6eKak6lv3BR0k130akwSDIcfGxF/uElEW9hdjyhUajl1jH4JX
         Whq22zf1XhrrIdG9mxxS2lqz069juILqGPgdHphY07bCheWl/XWQIqF8N7klPq5g3ko6
         9ay23PfBizWtNbbjY5l8CatCa0u262VtlU6igAiGWT1Jd5qm4hx9FHQWxBdnnXexhxtH
         +XoA==
X-Gm-Message-State: APjAAAU3xtmi4XpFDpPnmnGFcflvQ22ss4ODtsPsN6qc0mgnKzcSFikS
        8tSKVZl0GEIV4uR6bK8+ysk=
X-Google-Smtp-Source: APXvYqy21bIG21eVFJtCGEF6Zhn/cDGqqbuiX/DJs1FWRlS+jHK1wUv9wOIvWm3LLybFCSvDt7rOjA==
X-Received: by 2002:adf:f00d:: with SMTP id j13mr3229483wro.178.1558860346353;
        Sun, 26 May 2019 01:45:46 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id q11sm7089717wmc.15.2019.05.26.01.45.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 01:45:45 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v2 3/5] generic: copy_file_range swapfile test
Date:   Sun, 26 May 2019 11:45:33 +0300
Message-Id: <20190526084535.999-4-amir73il@gmail.com>
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
 tests/generic/989     | 56 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/989.out |  4 ++++
 tests/generic/group   |  1 +
 3 files changed, 61 insertions(+)
 create mode 100755 tests/generic/989
 create mode 100644 tests/generic/989.out

diff --git a/tests/generic/989 b/tests/generic/989
new file mode 100755
index 00000000..27c10296
--- /dev/null
+++ b/tests/generic/989
@@ -0,0 +1,56 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 989
+#
+# Check that we cannot copy_file_range() to/from a swapfile
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
+_require_scratch
+_require_xfs_io_command "copy_range"
+_require_scratch_swapfile
+
+_scratch_mkfs 2>&1 >> $seqres.full
+_scratch_mount
+
+testdir=$SCRATCH_MNT
+
+rm -f $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 128k" $testdir/file >> $seqres.full 2>&1
+
+echo swap files return ETXTBUSY
+_format_swapfile $testdir/swapfile 16m
+swapon $testdir/swapfile
+$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/file" $testdir/swapfile
+$XFS_IO_PROG -f -c "copy_range -l 32k $testdir/swapfile" $testdir/copy
+swapoff $testdir/swapfile
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/989.out b/tests/generic/989.out
new file mode 100644
index 00000000..32da0ce9
--- /dev/null
+++ b/tests/generic/989.out
@@ -0,0 +1,4 @@
+QA output created by 989
+swap files return ETXTBUSY
+copy_range: Text file busy
+copy_range: Text file busy
diff --git a/tests/generic/group b/tests/generic/group
index 20b95c14..4c100781 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -551,3 +551,4 @@
 546 auto quick clone enospc log
 547 auto quick log
 988 auto quick copy_range
+989 auto quick copy_range swap
-- 
2.17.1

