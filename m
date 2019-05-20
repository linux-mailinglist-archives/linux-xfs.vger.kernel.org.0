Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7BD24377
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 00:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfETWbq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 18:31:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58808 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfETWbq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 18:31:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KMShx4119787;
        Mon, 20 May 2019 22:31:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=hWzdXj8tO9nXyTW3NGp8iH3fVg9YAxHS7ca/6gkKvoE=;
 b=Drqh0GF38oWCnXOlbyqITRcLRx+1Z8n6HByHXQBQr5TZOiOvVVgN5W7Cq2mMwwWFIZNl
 Ru262HxRdUrtIPTfito2iuJOgw3sHcrteoFm6S5ORZ5K3RTES79HGtkMOUys5FEiauvo
 rt6k16OdqBTp5QnS5WnSbB6FQrQS8cdsSaF/HkuPBwu8yrfeIlbeIX2IZD+P8q4MKOsf
 LLwHWp802Pe3d9EyQU2CMMNkXLsXNJAOXHqV8zkOBRyjLlZt24aSJzwqtNe6BrTsJrYR
 9Z9K1zz1Dsw1sGQK794xh/Zsdts8iN/AiPlOVQR+kkHXFrurRSTGGZMtvCVhRYgDhXl1 Qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2sjapq9qhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:31:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KMUGFD186169;
        Mon, 20 May 2019 22:31:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2skudb1tna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:31:43 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KMVghB017069;
        Mon, 20 May 2019 22:31:42 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 22:31:42 +0000
Subject: [PATCH ] xfs: basic testing of new xfs_spaceman health command
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Mon, 20 May 2019 15:31:41 -0700
Message-ID: <155839150130.62876.6329606122510578337.stgit@magnolia>
In-Reply-To: <155839149301.62876.7233006456381129816.stgit@magnolia>
References: <155839149301.62876.7233006456381129816.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200138
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Basic tests to make sure xfs_spaceman health command works properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs        |    7 ++++
 tests/xfs/742     |   52 +++++++++++++++++++++++++++++++++
 tests/xfs/742.out |    2 +
 tests/xfs/743     |   84 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/743.out |    4 +++
 tests/xfs/group   |    2 +
 6 files changed, 151 insertions(+)
 create mode 100755 tests/xfs/742
 create mode 100644 tests/xfs/742.out
 create mode 100755 tests/xfs/743
 create mode 100644 tests/xfs/743.out


diff --git a/common/xfs b/common/xfs
index 42f02ff7..f8dafc6c 100644
--- a/common/xfs
+++ b/common/xfs
@@ -773,7 +773,12 @@ _require_xfs_spaceman_command()
 	_require_command "$XFS_SPACEMAN_PROG" "xfs_spaceman"
 
 	testfile=$TEST_DIR/$$.xfs_spaceman
+	touch $testfile
 	case $command in
+	"health")
+		testio=`$XFS_SPACEMAN_PROG -c "health $param" $TEST_DIR 2>&1`
+		param_checked=1
+		;;
 	*)
 		testio=`$XFS_SPACEMAN_PROG -c "help $command" $TEST_DIR 2>&1`
 	esac
@@ -787,6 +792,8 @@ _require_xfs_spaceman_command()
 		_notrun "xfs_spaceman $command failed (old kernel/wrong fs/bad args?)"
 	echo $testio | grep -q "foreign file active" && \
 		_notrun "xfs_spaceman $command not supported on $FSTYP"
+	echo $testio | grep -q "Inappropriate ioctl for device" && \
+		_notrun "xfs_spaceman $command support is missing (missing ioctl?)"
 	echo $testio | grep -q "Function not implemented" && \
 		_notrun "xfs_spaceman $command support is missing (missing syscall?)"
 
diff --git a/tests/xfs/742 b/tests/xfs/742
new file mode 100755
index 00000000..2529c40a
--- /dev/null
+++ b/tests/xfs/742
@@ -0,0 +1,52 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 742
+#
+# Ensure all xfs_spaceman commands are documented.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_command "$XFS_SPACEMAN_PROG" "xfs_spaceman"
+_require_command "$MAN_PROG" man
+
+echo "Silence is golden"
+
+MANPAGE=$($MAN_PROG --path xfs_spaceman)
+
+case "$MANPAGE" in
+*.gz|*.z\|*.Z)	CAT=zcat;;
+*.bz2)		CAT=bzcat;;
+*.xz)		CAT=xzcat;;
+*)		CAT=cat;;
+esac
+_require_command `which $CAT` $CAT
+
+for COMMAND in `$XFS_SPACEMAN_PROG -c help $TEST_DIR | awk '{print $1}' | grep -v "^Use"`; do
+  $CAT "$MANPAGE" | egrep -q "^\.B.*$COMMAND" || \
+	echo "$COMMAND not documented in the xfs_spaceman manpage"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/742.out b/tests/xfs/742.out
new file mode 100644
index 00000000..ef4f23cd
--- /dev/null
+++ b/tests/xfs/742.out
@@ -0,0 +1,2 @@
+QA output created by 742
+Silence is golden
diff --git a/tests/xfs/743 b/tests/xfs/743
new file mode 100755
index 00000000..d0b7b3b0
--- /dev/null
+++ b/tests/xfs/743
@@ -0,0 +1,84 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 743
+#
+# Basic tests of the xfs_spaceman health command.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/fuzzy
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_scratch_nocheck
+_require_scrub
+_require_xfs_spaceman_command "health"
+
+rm -f $seqres.full
+
+_scratch_mkfs > $tmp.mkfs
+_scratch_mount
+
+# Haven't checked anything, it should tell us to run scrub
+$XFS_SPACEMAN_PROG -c "health" $SCRATCH_MNT
+
+echo "Silence is golden"
+
+# Run scrub to collect health info.
+_scratch_scrub -n >> $seqres.full
+
+query() {
+	$XFS_SPACEMAN_PROG -c "$@" $SCRATCH_MNT | tee -a $seqres.full
+}
+
+query_health() {
+	query "$@" | grep -q ": ok$"
+}
+
+query_sick() {
+	query "$@" | grep -q ": unhealthy$"
+}
+
+# Let's see if we get at least one healthy rating for each health reporting
+# group.
+query_health "health -f" || \
+	echo "Didn't see a single healthy fs metadata?"
+
+query_health "health -a 0" || \
+	echo "Didn't see a single healthy ag metadata?"
+
+query_health "health $SCRATCH_MNT" || \
+	echo "Didn't see a single healthy file metadata?"
+
+# Unmount, corrupt filesystem
+_scratch_unmount
+_scratch_xfs_db -x -c 'sb 1' -c 'fuzz -d magicnum random' >> $seqres.full
+
+# Now let's see what the AG report says
+_scratch_mount
+_scratch_scrub -n >> $seqres.full 2>&1
+query_sick "health -a 1" || \
+	echo "Didn't see the expected unhealthy metadata?"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/743.out b/tests/xfs/743.out
new file mode 100644
index 00000000..85232e52
--- /dev/null
+++ b/tests/xfs/743.out
@@ -0,0 +1,4 @@
+QA output created by 743
+Health status has not been collected for this filesystem.
+Please run xfs_scrub(8) to remedy this situation.
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index c8620d72..5a4ef4bf 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -502,3 +502,5 @@
 502 auto quick unlink
 503 auto copy metadump
 739 auto quick mkfs label
+742 auto quick spaceman
+743 auto quick health

