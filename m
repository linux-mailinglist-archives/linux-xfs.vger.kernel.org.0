Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087F21B90F7
	for <lists+linux-xfs@lfdr.de>; Sun, 26 Apr 2020 16:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgDZOvv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 Apr 2020 10:51:51 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41513 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725876AbgDZOvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Apr 2020 10:51:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587912708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Zo9BiW1I6VkbXEMDxxnU6gBXGQSRMnquYpj4uTNnRJ0=;
        b=aLzezXRXpyvpyi6jFe1Q3f9NFstluXyp/oAqWbJ94zu3Z87anAZy6WskTHnXSXthDYwyqz
        G8XwQJdaEsdOkRcyxcFQeVtBu5nGsWXo7ZvTvs3P5UnEGLteMtk56ISSH991i2ImXfjlib
        UV9lgaIZvI5jZY3Y2N9FQ5qWyCKwmQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-zy_ewKc2NSi0jSecu5yWlQ-1; Sun, 26 Apr 2020 10:51:46 -0400
X-MC-Unique: zy_ewKc2NSi0jSecu5yWlQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F151107ACCA;
        Sun, 26 Apr 2020 14:51:45 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-13-119.pek2.redhat.com [10.72.13.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D29CE60300;
        Sun, 26 Apr 2020 14:51:43 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] generic: test per-type quota softlimit enforcement timeout
Date:   Sun, 26 Apr 2020 22:51:41 +0800
Message-Id: <20200426145141.22932-1-zlang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Set different block & inode grace timers for user, group and project
quotas, then test softlimit enforcement timeout, make sure different
grace timers as expected.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

After generic/594 got merge, I'd like to re-send this case again. It stil=
l
fails on XFS, but pass on ext4.

V2 add _require_setquota_project

Thanks,
Zorro

 common/quota          |   4 +
 tests/generic/597     | 180 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/597.out |  41 ++++++++++
 tests/generic/group   |   1 +
 4 files changed, 226 insertions(+)
 create mode 100755 tests/generic/597
 create mode 100644 tests/generic/597.out

diff --git a/common/quota b/common/quota
index 240e0bbc..1437d5f7 100644
--- a/common/quota
+++ b/common/quota
@@ -217,6 +217,10 @@ _qmount()
     if [ "$FSTYP" !=3D "xfs" ]; then
         quotacheck -ug $SCRATCH_MNT >>$seqres.full 2>&1
         quotaon -ug $SCRATCH_MNT >>$seqres.full 2>&1
+        # try to turn on project quota if it's supported
+        if quotaon --help 2>&1 | grep -q '\-\-project'; then
+            quotaon --project $SCRATCH_MNT >>$seqres.full 2>&1
+        fi
     fi
     chmod ugo+rwx $SCRATCH_MNT
 }
diff --git a/tests/generic/597 b/tests/generic/597
new file mode 100755
index 00000000..52138b80
--- /dev/null
+++ b/tests/generic/597
@@ -0,0 +1,180 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 597
+#
+# Test per-type(user, group and project) filesystem quota timers, make s=
ure
+# enforcement
+#
+seq=3D`basename $0`
+seqres=3D$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=3D`pwd`
+tmp=3D/tmp/$$
+status=3D1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	restore_project
+	cd /
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
+require_project()
+{
+	rm -f $tmp.projects $tmp.projid
+	if [ -f /etc/projects ];then
+		cat /etc/projects > $tmp.projects
+	fi
+	if [ -f /etc/projid ];then
+		cat /etc/projid > $tmp.projid
+	fi
+
+	cat >/etc/projects <<EOF
+100:$SCRATCH_MNT/t
+EOF
+	cat >/etc/projid <<EOF
+$qa_user:100
+EOF
+	PROJECT_CHANGED=3D1
+}
+
+restore_project()
+{
+	if [ "$PROJECT_CHANGED" =3D "1" ];then
+		rm -f /etc/projects /etc/projid
+		if [ -f $tmp.projects ];then
+			cat $tmp.projects > /etc/projects
+		fi
+		if [ -f $tmp.projid ];then
+			cat $tmp.projid > /etc/projid
+		fi
+	fi
+}
+
+init_files()
+{
+	local dir=3D$1
+
+	echo "### Initialize files, and their mode and ownership"
+	touch $dir/file{1,2} 2>/dev/null
+	chown $qa_user $dir/file{1,2} 2>/dev/null
+	chgrp $qa_user $dir/file{1,2} 2>/dev/null
+	chmod 777 $dir 2>/dev/null
+}
+
+cleanup_files()
+{
+	echo "### Remove all files"
+	rm -f ${1}/file{1,2,3,4,5,6}
+}
+
+test_grace()
+{
+	local type=3D$1
+	local dir=3D$2
+	local bgrace=3D$3
+	local igrace=3D$4
+
+	init_files $dir
+	echo "--- Test block quota ---"
+	# Firstly fit below block soft limit
+	echo "Write 225 blocks..."
+	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 $((225 * $BLOCK_SIZE))' \
+		-c fsync $dir/file1" 2>&1 >>$seqres.full | \
+		_filter_xfs_io_error | tee -a $seqres.full
+	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
+	# Secondly overcome block soft limit
+	echo "Rewrite 250 blocks plus 1 byte, over the block softlimit..."
+	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 $((250 * $BLOCK_SIZE + 1))' \
+		-c fsync $dir/file1" 2>&1 >>$seqres.full | \
+		_filter_xfs_io_error | tee -a $seqres.full
+	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
+	# Reset grace time here, make below grace time test more accurate
+	setquota -$type $qa_user -T $bgrace $igrace $SCRATCH_MNT 2>/dev/null
+	# Now sleep enough grace time and check that softlimit got enforced
+	sleep $((bgrace + 1))
+	echo "Try to write 1 one more block after grace..."
+	su $qa_user -c "$XFS_IO_PROG -c 'truncate 0' -c 'pwrite 0 $BLOCK_SIZE' =
\
+		$dir/file2" 2>&1 >>$seqres.full | _filter_xfs_io_error | \
+		tee -a $seqres.full
+	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
+	echo "--- Test inode quota ---"
+	# And now the softlimit test for inodes
+	# First reset space limits so that we don't have problems with
+	# space reservations on XFS
+	setquota -$type $qa_user 0 0 3 100 $SCRATCH_MNT
+	echo "Create 2 more files, over the inode softlimit..."
+	su $qa_user -c "touch $dir/file3 $dir/file4" 2>&1 >>$seqres.full | \
+		_filter_scratch | tee -a $seqres.full
+	repquota -v -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
+	# Reset grace time here, make below grace time test more accurate
+	setquota -$type $qa_user -T $bgrace $igrace $SCRATCH_MNT 2>/dev/null
+	# Wait and check grace time enforcement
+	sleep $((igrace+1))
+	echo "Try to create one more inode after grace..."
+	su $qa_user -c "touch $dir/file5" 2>&1 >>$seqres.full |
+		_filter_scratch | tee -a $seqres.full
+	repquota -v -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
+	cleanup_files $dir
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_setquota_project
+_require_quota
+_require_user
+_require_group
+
+_scratch_mkfs >$seqres.full 2>&1
+_scratch_enable_pquota
+_qmount_option "usrquota,grpquota,prjquota"
+_qmount
+_require_prjquota $SCRATCH_DEV
+BLOCK_SIZE=3D$(_get_file_block_size $SCRATCH_MNT)
+rm -rf $SCRATCH_MNT/t
+mkdir $SCRATCH_MNT/t
+$XFS_IO_PROG -r -c "chproj 100" -c "chattr +P" $SCRATCH_MNT/t
+require_project
+
+echo "### Set up different grace timers to each type of quota"
+UBGRACE=3D12
+UIGRACE=3D10
+GBGRACE=3D4
+GIGRACE=3D2
+PBGRACE=3D8
+PIGRACE=3D6
+
+setquota -u $qa_user $((250 * $BLOCK_SIZE / 1024)) \
+	$((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
+setquota -u -t $UBGRACE $UIGRACE $SCRATCH_MNT
+setquota -g $qa_user $((250 * $BLOCK_SIZE / 1024)) \
+         $((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
+setquota -g -t $GBGRACE $GIGRACE $SCRATCH_MNT
+setquota -P $qa_user $((250 * $BLOCK_SIZE / 1024)) \
+         $((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
+setquota -P -t $PBGRACE $PIGRACE $SCRATCH_MNT
+
+echo; echo "### Test user quota softlimit and grace time"
+test_grace u $SCRATCH_MNT $UBGRACE $UIGRACE
+echo; echo "### Test group quota softlimit and grace time"
+test_grace g $SCRATCH_MNT $GBGRACE $GIGRACE
+echo; echo "### Test project quota softlimit and grace time"
+test_grace P $SCRATCH_MNT/t $PBGRACE $PIGRACE
+
+# success, all done
+status=3D0
+exit
diff --git a/tests/generic/597.out b/tests/generic/597.out
new file mode 100644
index 00000000..57a68ee1
--- /dev/null
+++ b/tests/generic/597.out
@@ -0,0 +1,41 @@
+QA output created by 597
+### Set up different grace timers to each type of quota
+
+### Test user quota softlimit and grace time
+### Initialize files, and their mode and ownership
+--- Test block quota ---
+Write 225 blocks...
+Rewrite 250 blocks plus 1 byte, over the block softlimit...
+Try to write 1 one more block after grace...
+pwrite: Disk quota exceeded
+--- Test inode quota ---
+Create 2 more files, over the inode softlimit...
+Try to create one more inode after grace...
+touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded
+### Remove all files
+
+### Test group quota softlimit and grace time
+### Initialize files, and their mode and ownership
+--- Test block quota ---
+Write 225 blocks...
+Rewrite 250 blocks plus 1 byte, over the block softlimit...
+Try to write 1 one more block after grace...
+pwrite: Disk quota exceeded
+--- Test inode quota ---
+Create 2 more files, over the inode softlimit...
+Try to create one more inode after grace...
+touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded
+### Remove all files
+
+### Test project quota softlimit and grace time
+### Initialize files, and their mode and ownership
+--- Test block quota ---
+Write 225 blocks...
+Rewrite 250 blocks plus 1 byte, over the block softlimit...
+Try to write 1 one more block after grace...
+pwrite: Disk quota exceeded
+--- Test inode quota ---
+Create 2 more files, over the inode softlimit...
+Try to create one more inode after grace...
+touch: cannot touch 'SCRATCH_MNT/t/file5': Disk quota exceeded
+### Remove all files
diff --git a/tests/generic/group b/tests/generic/group
index 718575ba..10af4c41 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -598,3 +598,4 @@
 594 auto quick quota
 595 auto quick encrypt
 596 auto quick
+597 auto quick quota
--=20
2.20.1

