Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25325AFD8C
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Sep 2019 15:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfIKNR3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Sep 2019 09:17:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33142 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfIKNR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Sep 2019 09:17:29 -0400
Received: by mail-pg1-f195.google.com with SMTP id n190so11531294pgn.0;
        Wed, 11 Sep 2019 06:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=SJuemVKdakoe9Qe78wYoOM+kizpfsD6VTjlf19fgmGY=;
        b=oeY1WK1wwIzcaysTFUNOdC+20FDh5ICtl5LFDT8S+uY5797Jr9h36kxn4+IBnMOtS+
         EuppzHxd2EiWehLQO13hlC0/b/Z9EKY+Uj0gWCiD4Big45K1yX6WAUmk3rkS8s2mo0b4
         GwrvEWiRhNvOBVFjPVyCqR+MHEBNslBqXxxpwR/NTijMbdh4bfCItMwmStkzWYxKJTob
         7lAQ13E/4qU+teSfDkSJTxRbFsfH9RmhN3amArTYZSCkLR45U5x6tnktYfiGvDPwgFwu
         xPwsV1S3NT/BTlcTa+PvlULMKlWfMu/auyLga3/AQtAYWfthcPOq2UHT4bJSGCAEZ9jf
         l2Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=SJuemVKdakoe9Qe78wYoOM+kizpfsD6VTjlf19fgmGY=;
        b=OgsQw97ft5W0gEFeID/TkyFf+4/5t+9E8zpKs2AuAIsUbvYcLQcbuhYaHnzT/xoIv3
         GC/cvv1kP3/zLtBGfrB4DZsG908GPBzN/5mA2UmWoZlAhpHWFFoxM8PGFwAH+OVWoAGv
         2XD/FXPzqHEN6gFV11pLw63EasIqWawjsaM7JoTOJxo1RTvFod53gHQKx9XK3U194ZRE
         bnstJxFyarJu5XZQ/OgFMiqC1QHU3FPpL/KchH8PAvAeCYV3awaqwfSpMBd+9JMu6P1P
         dsLK2VAi7XBD8o9upHYCiZ1fRgiyDwfT7wL9yXAS0HGZIwbtNjbm2w2j0RNp4K3AAa10
         hN3Q==
X-Gm-Message-State: APjAAAWGTWj5FWW8+wRgVgA84G8Ztki2DfYyj0jpQVonQv9Gsv3jZ3Uf
        bns5oGWZl+u+6u7TbVvge39hBkI=
X-Google-Smtp-Source: APXvYqwYs08jQiHaYbTlRQvVHoX5HrfLmfpJ435bu15zbkMzsz2ii4w2ZO04pFYLyrUVUZWj/ydOjQ==
X-Received: by 2002:a63:1521:: with SMTP id v33mr2670356pgl.21.1568207847646;
        Wed, 11 Sep 2019 06:17:27 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id k4sm2621026pjl.9.2019.09.11.06.17.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 06:17:27 -0700 (PDT)
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH 2/2] xfs: test the deadlock between the AGI and AGF with
 RENAME_WHITEOUT
Message-ID: <58163375-dcd9-b954-c8d2-89fef20b8246@gmail.com>
Date:   Wed, 11 Sep 2019 21:17:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is ABBA deadlock bug between the AGI and AGF when performing
rename() with RENAME_WHITEOUT flag, and add this testcase to make
sure the rename() call works well.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
 tests/xfs/512     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/512.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 102 insertions(+)
 create mode 100755 tests/xfs/512
 create mode 100644 tests/xfs/512.out

diff --git a/tests/xfs/512 b/tests/xfs/512
new file mode 100755
index 0000000..754f102
--- /dev/null
+++ b/tests/xfs/512
@@ -0,0 +1,99 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Tencent.  All Rights Reserved.
+#
+# FS QA Test 512
+#
+# Test the ABBA deadlock case between the AGI and AGF When performing
+# rename operation with RENAME_WHITEOUT flag.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/renameat2
+
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_scratch_nocheck
+_requires_renameat2 whiteout
+
+prepare_file()
+{
+	# create many small files for the rename with RENAME_WHITEOUT
+	i=0
+	while [ $i -le $files ]; do
+		file=$SCRATCH_MNT/f$i
+		echo > $file >/dev/null 2>&1
+		let i=$i+1
+	done
+}
+
+rename_whiteout()
+{
+	# create the rename targetdir
+	renamedir=$SCRATCH_MNT/renamedir
+	mkdir $renamedir
+
+	# a long filename could increase the possibility that target_dp
+	# allocate new blocks(acquire the AGF lock) to store the filename
+	longnamepre=FFFsafdsagafsadfagasdjfalskdgakdlsglkasdg
+
+	# now try to do rename with RENAME_WHITEOUT flag
+	i=0
+	while [ $i -le $files ]; do
+		src/renameat2 -w $SCRATCH_MNT/f$i $renamedir/$longnamepre$i >/dev/null 2>&1
+		let i=$i+1
+	done
+}
+
+create_file()
+{
+	# create the targetdir
+	createdir=$SCRATCH_MNT/createdir
+	mkdir $createdir
+
+	# try to create file at the same time to hit the deadlock
+	i=0
+	while [ $i -le $files ]; do
+		file=$createdir/f$i
+		echo > $file >/dev/null 2>&1
+		let i=$i+1
+	done
+}
+
+_scratch_mkfs_xfs -bsize=1024 -dagcount=1 >> $seqres.full 2>&1 ||
+	_fail "mkfs failed"
+_scratch_mount
+
+files=250000
+
+prepare_file
+rename_whiteout &
+create_file &
+
+wait
+echo Silence is golden
+
+# Failure comes in the form of a deadlock.
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/512.out b/tests/xfs/512.out
new file mode 100644
index 0000000..0aabdef
--- /dev/null
+++ b/tests/xfs/512.out
@@ -0,0 +1,2 @@
+QA output created by 512
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index a7ad300..ed250d6 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -509,3 +509,4 @@
 509 auto ioctl
 510 auto ioctl quick
 511 auto quick quota
+512 auto rename
-- 
1.8.3.1

-- 
kaixuxia
