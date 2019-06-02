Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 382F33234B
	for <lists+linux-xfs@lfdr.de>; Sun,  2 Jun 2019 14:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfFBMl2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 2 Jun 2019 08:41:28 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54906 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfFBMl2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Jun 2019 08:41:28 -0400
Received: by mail-wm1-f67.google.com with SMTP id g135so5563460wme.4;
        Sun, 02 Jun 2019 05:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tHETMryGVwSaOgR/Yx7oTEa1ui+4bN17f008odA0yXI=;
        b=iBDyQp+vCMkD1IDTu/UzXp7v4MtbunVlvFVsLEL39rm9C/JMMI5ZFVQsDF6cl7eoPM
         lTxZNTNFHR/YGg2gnq94QUKvVYocO+gt12Ar3R22rSZmTXOIvpjHSsmRig5jobkGdRAv
         Aok3SXNXmEZBKXGXwk3nmd1nL+YIx+tSy1CAtXn+pdayWs4GCAF4dAMR8SGxFRfOAzSd
         nChWInisP05UVuxObJyUCLE/oGtHYocG5mjrCJUhK93BAqZCH0Jb6GsIJp3y9exibj6h
         lCpvswp47qbKREHSnJ6LPdcgVRHDVGoOxuJ4ghIu/t+/DitMfcxEPfp0Y4WRI7t7TyF6
         CK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tHETMryGVwSaOgR/Yx7oTEa1ui+4bN17f008odA0yXI=;
        b=aZHK/Zh3ov46A/FdQxFtM65lMJrRuQG/MN6HFsfYkKolFuL0kbpVHUk9CiMGfanbKS
         X+b9cPfpBddG85eAcU4s2dp+FZ21tCbqdYC76YjwqQoK7sDptUUxIwEumnlN1gBHGlgz
         wVhgWE1ilOc71oHIonorFFbQkA76kseH4vvpBkNx91zcw2bJiVFmBGOuOMk1hnOS2WC0
         vN4gJI7w3s1r6KbXJO+G51q+QnXg9Dc7SKCR29X8lS+lR65YA/koYXevAXGNzFCLUpsl
         1s0p/shZwCmHXSmg16B7YrB1M8qwj8RkblbPPqPe6kZHJgss8ybC1Uo1cu8qgXaurso5
         q1vA==
X-Gm-Message-State: APjAAAWBA0twF/odGnFm67Eq5qDnxp90gIKPSMSNeP803XIOzcz5Y7ux
        Cw2FhzkRy7yhezg8BkSY48Vt5qsK
X-Google-Smtp-Source: APXvYqyuBU7fGb6Ot08Hk7RHDIPOo0ZmbAylFLvhLyFSkNT7WP3DuMbQEfAan07u1QmA0EtRgEzpdw==
X-Received: by 2002:a1c:2358:: with SMTP id j85mr11365061wmj.46.1559479285649;
        Sun, 02 Jun 2019 05:41:25 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id g185sm11214827wmf.30.2019.06.02.05.41.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 05:41:25 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v3 3/6] generic: copy_file_range swapfile test
Date:   Sun,  2 Jun 2019 15:41:11 +0300
Message-Id: <20190602124114.26810-4-amir73il@gmail.com>
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

