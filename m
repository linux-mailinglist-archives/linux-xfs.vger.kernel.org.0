Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910641AEBF
	for <lists+linux-xfs@lfdr.de>; Mon, 13 May 2019 03:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfEMBt4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 12 May 2019 21:49:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbfEMBt4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 12 May 2019 21:49:56 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E505FC00C7DD;
        Mon, 13 May 2019 01:49:55 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-112.pek2.redhat.com [10.72.12.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CEEE60BCD;
        Mon, 13 May 2019 01:49:53 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH] generic: test statfs on project quota directory
Date:   Mon, 13 May 2019 09:49:51 +0800
Message-Id: <20190513014951.4357-1-zlang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 13 May 2019 01:49:56 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There's a bug on xfs cause statfs get negative f_ffree value from
a project quota directory. It's fixed by "de7243057 fs/xfs: fix
f_ffree value for statfs when project quota is set". So add statfs
testing on project quota block and inode count limit.

For testing foreign fs quota, change _qmount() function, turn on
project if quotaon support.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

(Long time passed, re-send this patch again to get reviewing)

There's one thing I don't understand, so CC ext4 mail list. Please
feel free to reply, if anyone knows that:

$ mkfs.ext4 $SCRATCH_DEV
$ tune2fs -O quota,project $SCRATCH_DEV
$ mount $SCRATCH_DEV $SCRATCH_MNT -o prjquota
$ quotaon -P $SCRATCH_MNT
$ mkdir $SCRATCH_MNT/t
$ xfs_quota -f -x -c "project -p $SCRATCH_MNT/t -s 42" $SCRATCH_MNT
$ xfs_quota -f -x -c "limit -p bsoft=100m answer" $SCRATCH_MNT
$ df -k $SCRATCH_MNT/t
Filesystem    1K-blocks  Used Available Use% Mounted on
SCRATCH_DEV    102400     4    102396   1% SCRATCH_MNT

On XFS, the 'Used' field always shows '0'. But why ext4 always has
more 4k? Is it a bug or expected.

Thanks,
Zorro


 common/quota          |  4 +++
 tests/generic/999     | 74 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  3 ++
 tests/generic/group   |  1 +
 4 files changed, 82 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/common/quota b/common/quota
index f19f81a1..315df8cb 100644
--- a/common/quota
+++ b/common/quota
@@ -200,6 +200,10 @@ _qmount()
     if [ "$FSTYP" != "xfs" ]; then
         quotacheck -ug $SCRATCH_MNT >>$seqres.full 2>&1
         quotaon -ug $SCRATCH_MNT >>$seqres.full 2>&1
+	# try to turn on project quota if it's supported
+	if quotaon --help 2>&1 | grep -q '\-\-project'; then
+		quotaon --project $SCRATCH_MNT >>$seqres.full 2>&1
+	fi
     fi
     chmod ugo+rwx $SCRATCH_MNT
 }
diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 00000000..555341f1
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,74 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 999
+#
+# Test statfs when project quota is set.
+# Uncover de7243057 fs/xfs: fix f_ffree value for statfs when project quota is set
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
+	_scratch_unmount
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/quota
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_quota
+_require_xfs_quota_foreign
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_enable_pquota
+_qmount_option "prjquota"
+_qmount
+_require_prjquota $SCRATCH_DEV
+
+# Create a directory to be project object, and create a file to take 64k space
+mkdir $SCRATCH_MNT/t
+$XFS_IO_PROG -f -c "pwrite 0 65536" -c sync $SCRATCH_MNT/t/file >>$seqres.full
+
+# Setup temporary replacements for /etc/projects and /etc/projid
+cat >$tmp.projects <<EOF
+42:$SCRATCH_MNT/t
+EOF
+
+cat >$tmp.projid <<EOF
+answer:42
+EOF
+
+quota_cmd="$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid"
+$quota_cmd -x -c 'project -s answer' $SCRATCH_MNT >/dev/null 2>&1
+$quota_cmd -x -c 'limit -p isoft=53 bsoft=100m answer' $SCRATCH_MNT
+
+# The itotal and size should be 53 and 102400(k), as above project quota limit.
+# The isued and used should be 2 and 64(k), as this case takes. But ext4 always
+# shows more 4k 'used' space than XFS, it prints 68k at here. So filter the
+# 6[48] at the end.
+df -k --output=file,itotal,iused,size,used $SCRATCH_MNT/t | \
+	_filter_scratch | _filter_spaces | \
+	sed -e "/SCRATCH_MNT/s/6[48]/N/"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 00000000..1bebabd4
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,3 @@
+QA output created by 999
+File Inodes IUsed 1K-blocks Used
+SCRATCH_MNT/t 53 2 102400 N
diff --git a/tests/generic/group b/tests/generic/group
index 9f4845c6..35da10a5 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -542,3 +542,4 @@
 537 auto quick trim
 538 auto quick aio
 539 auto quick punch seek
+999 auto quick quota
-- 
2.17.2

