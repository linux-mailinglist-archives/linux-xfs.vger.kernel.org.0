Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 251408851D
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfHIVj2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:39:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60698 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfHIVj2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:39:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYbFO084554
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:39:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=cqlnqXl4D2d2/udYlasfNOL9sXDrL/cJJTALmQqidIU=;
 b=GgJL4yiDjvd29Z0Lh9jGr4xv9Xi0fESstltRMHq8QWx6NtmoSFwEre+s8LPTcGq99B+x
 kzhz9xF6hi1sRVdWc7AEwTLxo8DWUt1Kn8yAJCy1Sh9J8qphtQB0MXWTQftkfTUHEZFw
 86TpdLlOGST5Fv5tCbiClX9KUg2POaSrEGnYI0F3p6kvvFmEw/4Ze5SD3rmDVP+vLRil
 LxVyEnck1IYlQRi0YWMk0kbNY0PPei1oRSiQDthIpcjvWC2AgeYRnwj9hJWgeYTx4BFI
 ropxLk3sQ0vAKyRxZbIaDKoYLckJXeEISJYb4IueKVPCY8+rBwKZ5b5OtaMsKcxfFhBW GQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=cqlnqXl4D2d2/udYlasfNOL9sXDrL/cJJTALmQqidIU=;
 b=tg+X2pyOciMP0D+251j/kMK7MHIiFkfceLuD3nB3QezMnWDeMgqdYhjF+KTYPs4VMx7N
 T0/QHRI+IW0hG086x4eLpjM6lt9i/HLkjwazpPlWc4HWW2DjT15zplgXNQ0IyHHgqtpO
 ojg5ZqiNwU77fBapanOnzIxIXqxRiicIxD5NC4bW+WQd7yIlrELsaLeRJrUZjY46HGqY
 mUhhEkrbnMvbjQVQh4XbUuz2v4eNEidajiNERPR9zj/QGfazIInh8dHx2tNLZQdXvDPn
 HMFTzumHu3x5hyKEKFV4lRiSsDCdE5CCggStYt3D89mNZ0xUKprjJs1Sl/ANJvvnfrje zA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u8hgpa81x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:39:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LdJBw048096
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:39:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2u8x1h6w8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:39:20 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x79LcY9x005260
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:34 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:34 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 1/1] xfstests: Add Delayed Attribute test
Date:   Fri,  9 Aug 2019 14:38:29 -0700
Message-Id: <20190809213829.383-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213829.383-1-allison.henderson@oracle.com>
References: <20190809213829.383-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090208
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch adds a test to exercise the delayed attribute error
inject and log replay

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 tests/xfs/512     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/512.out |  18 ++++++++++
 tests/xfs/group   |   1 +
 3 files changed, 121 insertions(+)

diff --git a/tests/xfs/512 b/tests/xfs/512
new file mode 100644
index 0000000..957525c
--- /dev/null
+++ b/tests/xfs/512
@@ -0,0 +1,102 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 512
+#
+# Delayed attr log replay test
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=0	# success is the default!
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/inject
+
+_cleanup()
+{
+	echo "*** unmount"
+	_scratch_unmount 2>/dev/null
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_attr()
+{
+	${ATTR_PROG} $* 2>$tmp.err >$tmp.out
+	exit=$?
+	sed \
+	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
+	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \
+		$tmp.out
+	sed \
+	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
+	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \
+		$tmp.err 1>&2
+	return $exit
+}
+
+do_getfattr()
+{
+	_getfattr $* 2>$tmp.err >$tmp.out
+	exit=$?
+	sed \
+	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
+	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \
+		$tmp.out
+	sed \
+	    -e "s#$SCRATCH_MNT[^ .:]*#<TESTFILE>#g" \
+	    -e "s#$tmp[^ :]*#<TMPFILE>#g;" \
+		$tmp.err 1>&2
+	return $exit
+}
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+_require_attrs
+_require_xfs_io_error_injection "delayed_attr"
+
+rm -f $seqres.full
+_scratch_unmount >/dev/null 2>&1
+
+echo "*** mkfs"
+_scratch_mkfs_xfs >/dev/null \
+	|| _fail "mkfs failed"
+
+echo "*** mount FS"
+_scratch_mount
+
+testfile=$SCRATCH_MNT/testfile
+echo "*** make test file 1"
+
+touch $testfile.1
+
+echo "Inject error"
+_scratch_inject_error "delayed_attr"
+
+echo "Set attribute"
+echo "attr_value" | _attr -s "attr_name" $testfile.1 >/dev/null
+
+echo "FS should be shut down, touch will fail"
+touch $testfile.1
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "FS should be online, touch should succeed" 
+touch $testfile.1
+
+echo "Verify attr recovery"
+do_getfattr --absolute-names $testfile.1
+
+echo "*** done"
+exit
diff --git a/tests/xfs/512.out b/tests/xfs/512.out
new file mode 100644
index 0000000..71bff79
--- /dev/null
+++ b/tests/xfs/512.out
@@ -0,0 +1,18 @@
+QA output created by 512
+*** mkfs
+*** mount FS
+*** make test file 1
+Inject error
+Set attribute
+attr_set: Input/output error
+Could not set "attr_name" for <TESTFILE>.1
+FS should be shut down, touch will fail
+touch: cannot touch '/mnt/scratch/testfile.1': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Verify attr recovery
+# file: <TESTFILE>.1
+user.attr_name
+
+*** done
+*** unmount
diff --git a/tests/xfs/group b/tests/xfs/group
index a7ad300..a9dab7c 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -509,3 +509,4 @@
 509 auto ioctl
 510 auto ioctl quick
 511 auto quick quota
+512 auto quick attr
-- 
2.7.4

