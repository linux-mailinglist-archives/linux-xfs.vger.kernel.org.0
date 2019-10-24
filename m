Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F578E275D
	for <lists+linux-xfs@lfdr.de>; Thu, 24 Oct 2019 02:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389946AbfJXAdM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 23 Oct 2019 20:33:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53280 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388218AbfJXAdM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Oct 2019 20:33:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9O0DXKS126625;
        Thu, 24 Oct 2019 00:33:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=d8UFSEH+Rs/WbpqACyX9R/6kc084HbjEoc+RebD09e0=;
 b=CngUBRgOASB/bLDAIOXI7LbmGQLzf+wMUTIeF1CWjZu+tm7HafErEupOqX86h2xLt639
 LZpaBrdEouQSq5KbmKh9uM0UnHbgD7I4RuSxo77ViNEKf/uTLNcFEkLXzX8r3JBYIHmA
 NgpI5WRyAn+BL/DYEGKWQ47k4u7cxxpd3Abg1kNOq8zIMAbeNXhxXLFH4jS6ZiUazSfV
 5160D0EnFzranbnbY+uddnGvyDL+4Ztbk+g+K//RGGMqRLLwug4/umXIcnSIS/K4mKHQ
 /4Wa0E2m4JYy7whqLt371qsWPlmGL9CBX/mqD2uBqFcjiOWy5paAksXXFo95vQfXWq9d Wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vqswtrn4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 00:33:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9O0CxiP195434;
        Thu, 24 Oct 2019 00:31:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vtm23a5s6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 00:31:08 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9O0V7Av007315;
        Thu, 24 Oct 2019 00:31:07 GMT
Received: from localhost (/10.159.148.95)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Oct 2019 17:31:07 -0700
Date:   Wed, 23 Oct 2019 17:31:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2 2/2] xfs: make sure the kernel and repair tools catch bad
 names
Message-ID: <20191024003106.GD6706@magnolia>
References: <157170897992.1172383.2128928990011336996.stgit@magnolia>
 <157170899277.1172383.10473571682266133494.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157170899277.1172383.10473571682266133494.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910240000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we actually catch bad names in the kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: fix various things as pointed out by Eryu
---
 tests/xfs/749     |  106 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/749.out |    3 ++
 tests/xfs/group   |    1 +
 3 files changed, 110 insertions(+)
 create mode 100755 tests/xfs/749
 create mode 100644 tests/xfs/749.out

diff --git a/tests/xfs/749 b/tests/xfs/749
new file mode 100755
index 00000000..e8371351
--- /dev/null
+++ b/tests/xfs/749
@@ -0,0 +1,106 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-newer
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 749
+#
+# See if we catch corrupt directory names or attr names with nulls or slashes
+# in them.
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
+	$UMOUNT_PROG $mntpt > /dev/null 2>&1
+	test -n "$loopdev" && _destroy_loop_device $loopdev > /dev/null 2>&1
+	rm -r -f $imgfile $mntpt $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_test
+_require_attrs
+
+rm -f $seqres.full
+
+imgfile=$TEST_DIR/img-$seq
+mntpt=$TEST_DIR/mount-$seq
+testdir=$mntpt/testdir
+testfile=$mntpt/testfile
+nullstr="too_many_beans"
+slashstr="are_bad_for_you"
+
+# Format image file
+$XFS_IO_PROG -f -c 'truncate 40m' $imgfile
+loopdev=$(_create_loop_device $imgfile)
+_mkfs_dev $loopdev >> $seqres.full
+
+# Mount image file
+mkdir -p $mntpt
+_mount $loopdev $mntpt
+
+# Create directory entries
+mkdir -p $testdir
+touch $testdir/$nullstr
+touch $testdir/$slashstr
+
+# Create attrs
+touch $testfile
+$ATTR_PROG -s $nullstr -V heh $testfile >> $seqres.full
+$ATTR_PROG -s $slashstr -V heh $testfile >> $seqres.full
+
+# Corrupt the entries
+$UMOUNT_PROG $mntpt
+_destroy_loop_device $loopdev
+cp $imgfile $imgfile.old
+sed -b \
+	-e "s/$nullstr/too_many\x00beans/g" \
+	-e "s/$slashstr/are_bad\/for_you/g" \
+	-i $imgfile
+test "$(md5sum < $imgfile)" != "$(md5sum < $imgfile.old)" ||
+	_fail "sed failed to change the image file?"
+rm -f $imgfile.old
+loopdev=$(_create_loop_device $imgfile)
+_mount $loopdev $mntpt
+
+# Try to access the corrupt metadata
+ls $testdir >> $seqres.full 2> $tmp.err
+$ATTR_PROG -l $testfile >> $seqres.full 2>> $tmp.err
+cat $tmp.err >> $seqres.full
+cat $tmp.err | _filter_test_dir | sed -e '/Could not list/d'
+
+# Does scrub complain about this?
+if _supports_xfs_scrub $mntpt $loopdev; then
+	$XFS_SCRUB_PROG -n $mntpt >> $seqres.full 2>&1
+	res=$?
+	test $((res & 1)) -eq 0 && \
+		echo "scrub failed to report corruption ($res)"
+fi
+
+# Does repair complain about this?
+$UMOUNT_PROG $mntpt
+$XFS_REPAIR_PROG -n $loopdev >> $seqres.full 2>&1
+res=$?
+test $res -eq 1 || \
+	echo "repair failed to report corruption ($res)"
+
+_destroy_loop_device $loopdev
+loopdev=
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/749.out b/tests/xfs/749.out
new file mode 100644
index 00000000..db3b1beb
--- /dev/null
+++ b/tests/xfs/749.out
@@ -0,0 +1,3 @@
+QA output created by 749
+ls: cannot access 'TEST_DIR/mount-749/testdir': Structure needs cleaning
+attr_list: Structure needs cleaning
diff --git a/tests/xfs/group b/tests/xfs/group
index f4ebcd8c..9600cb4e 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -507,3 +507,4 @@
 509 auto ioctl
 510 auto ioctl quick
 511 auto quick quota
+749 auto quick fuzzers
