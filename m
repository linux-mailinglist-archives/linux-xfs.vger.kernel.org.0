Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D534EAAB3
	for <lists+linux-xfs@lfdr.de>; Thu, 31 Oct 2019 07:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfJaGmA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 31 Oct 2019 02:42:00 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39028 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfJaGmA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Oct 2019 02:42:00 -0400
Received: by mail-pf1-f194.google.com with SMTP id x28so375225pfo.6;
        Wed, 30 Oct 2019 23:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=w9zY2lPZZtHSlyRMoIj997ehNCeQwDNAoaR1Qgpivbc=;
        b=rxP96bRovTLcUi/WBG9tALOoV44zSUNH27OCwwtWYF48OIuGsEeQEQurVXtLlqP94Q
         ggPewAmqTaWwK1q0iaoZ/DPwEcmdG8EzAxB6sYvh2gesQeGrp/tGS12xmpO/u6YPDdJR
         aCGZvGfLzFMVfPE0mx3ZvZ1/pm3LdagIB1ud9FVpwQEmQ2mRsr37PJdu9POfop3vMzA/
         MwjnzXNjoiVefv3I2t3tFWuxcuJthbrEYUE9SaSdksVWaZ4cpoVWpc5mUcdm6p02WlxL
         FwnPMxZ0q51Jky8LOlccU2bgW0s/Q9qzm8GkC+kKh+VtUukZKHgcxz8p1BvsrMyMM4AB
         wFGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=w9zY2lPZZtHSlyRMoIj997ehNCeQwDNAoaR1Qgpivbc=;
        b=KY7VjTLNjeeanLF0e8eW2z0PX/f7B8BaCbJ8FvKsziGOZlWtVYW/00pONtpDvpbJv0
         Qk2FLipRBs0bMWeBXwwVU2EBT/V55eZZCvpO+3Q2MdbPQlSpYU1qFOJ77myGim6sZ8Vu
         HIa6ryytC62uzBqda/i3c6ZFQhdWznP0zZNuhdKYHGqq+t1BF0Vmqseo0/Js78IiAwOC
         qGxl90M/mn5pziG8L2eqvgIU6QQAZp9mkA3tuUKoQFA+yAtlQtVeGZ2zxWgBk6UqptNt
         Uj6ZaCW5DKEspfD/eQgaQ6dlYNpGufr6dNdKFAceHoqQrxBfIx9uhQtocFb7TpCpdQ16
         ukew==
X-Gm-Message-State: APjAAAWHjoue1eeM1UoVBFsGIUlD0MheQi7BPO9ms2k34h/c50/yOA79
        qbEKUtWbkuM4xE54UtCVmB1JW5kXMg==
X-Google-Smtp-Source: APXvYqzA3aCTadtABMcx8INZBxn2eA6XHYxHK2Eb5uB9KbqhEftA4I7JaG0csI0iflbAop8D4zqFsg==
X-Received: by 2002:a63:6782:: with SMTP id b124mr4687201pgc.220.1572504118399;
        Wed, 30 Oct 2019 23:41:58 -0700 (PDT)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id x7sm2218815pff.0.2019.10.30.23.41.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 23:41:57 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
X-Google-Original-From: kaixuxia <kaixuxia@tencent.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, guaneryu@gmail.com, bfoster@redhat.com,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: [PATCH v3 4/4] xfs: test the deadlock between the AGI and AGF with RENAME_WHITEOUT
Date:   Thu, 31 Oct 2019 14:41:49 +0800
Message-Id: <d967ddb55c0a241cd001a5a7b2daee6d38d2ec33.1572503039.git.kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1572503039.git.kaixuxia@tencent.com>
References: <cover.1572503039.git.kaixuxia@tencent.com>
In-Reply-To: <cover.1572503039.git.kaixuxia@tencent.com>
References: <cover.1572503039.git.kaixuxia@tencent.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is ABBA deadlock bug between the AGI and AGF when performing
rename() with RENAME_WHITEOUT flag, and add this testcase to make
sure the rename() call works well.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 tests/generic/585     | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/585.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 59 insertions(+)
 create mode 100755 tests/generic/585
 create mode 100644 tests/generic/585.out

diff --git a/tests/generic/585 b/tests/generic/585
new file mode 100755
index 0000000..f815da5
--- /dev/null
+++ b/tests/generic/585
@@ -0,0 +1,56 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Tencent.  All Rights Reserved.
+#
+# FS QA Test No. 585
+#
+# Regression test for:
+#    bc56ad8c74b8: ("xfs: Fix deadlock between AGI and AGF with RENAME_WHITEOUT")
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1        # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+        cd /
+        rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/renameat2
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs generic
+_require_scratch
+_require_renameat2 whiteout
+
+_scratch_mkfs > $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount >> $seqres.full 2>&1
+
+# start a create and rename(rename_whiteout) workload. These processes
+# occur simultaneously may cause the deadlock between AGI and AGF with
+# RENAME_WHITEOUT.
+$FSSTRESS_PROG -z -n 150 -p 100 \
+		-f mknod=5 \
+		-f rwhiteout=5 \
+		-d $SCRATCH_MNT/fsstress >> $seqres.full 2>&1
+
+echo Silence is golden
+
+# Failure comes in the form of a deadlock.
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/585.out b/tests/generic/585.out
new file mode 100644
index 0000000..e4dd43b
--- /dev/null
+++ b/tests/generic/585.out
@@ -0,0 +1,2 @@
+QA output created by 585
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 42ca2b9..e5d0c1d 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -587,3 +587,4 @@
 582 auto quick encrypt
 583 auto quick encrypt
 584 auto quick encrypt
+585 auto rename
-- 
1.8.3.1

