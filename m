Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876DD214C68
	for <lists+linux-xfs@lfdr.de>; Sun,  5 Jul 2020 14:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGEM2y (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 5 Jul 2020 08:28:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50655 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726833AbgGEM2y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jul 2020 08:28:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593952131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9Mox07/fdll6Mtrx9uRpV2KKeKeY3pPkiE7vmB9cN2U=;
        b=hNm2HiAryF2h8ymXp1PHNwfhSVVUBgiWNqxU0AjZPk4kG//R1xoRathjDaxgBEjYZbUIpH
        FWvLm0DHYDgU5dvuw5p853HIiZuzC/78cxzwVOWu0HXPDdK/87WzH0uYRyoQ4cEN9B9yo8
        rdGxKZAd7AmWZmWhMS5ey+8pS0Vu06Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-hZ7qzvlkNLWYUDoI45o6Pw-1; Sun, 05 Jul 2020 08:28:49 -0400
X-MC-Unique: hZ7qzvlkNLWYUDoI45o6Pw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 805F41005510;
        Sun,  5 Jul 2020 12:28:48 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-12-31.pek2.redhat.com [10.72.12.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EED7710013C2;
        Sun,  5 Jul 2020 12:28:46 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v4] generic: test per-type quota softlimit enforcement timeout
Date:   Sun,  5 Jul 2020 20:28:42 +0800
Message-Id: <20200705122842.10133-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

V4 add a new function filter_enospc_edquot(), to deal with project quota.

After Eric's patch (c8d329f311c4d3d8f8e6dc5897ec235e37f48ae8) merged, xfs has
a fixed return value when project quota is exceeded. But for current linux
kernel, different filesystems have different return value. Some filesystems
return ENOSPC (e.g. XFS), some filsystems return EDQUOT(e.g. ext4). The behavior
isn't definitized. So filter the ENOSPC and EDQUOT output.

Thanks,
Zorro

 common/quota          |   4 +
 tests/generic/603     | 202 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/603.out |  41 +++++++++
 tests/generic/group   |   1 +
 4 files changed, 248 insertions(+)
 create mode 100755 tests/generic/603
 create mode 100644 tests/generic/603.out

diff --git a/common/quota b/common/quota
index 240e0bbc..1437d5f7 100644
--- a/common/quota
+++ b/common/quota
@@ -217,6 +217,10 @@ _qmount()
     if [ "$FSTYP" != "xfs" ]; then
         quotacheck -ug $SCRATCH_MNT >>$seqres.full 2>&1
         quotaon -ug $SCRATCH_MNT >>$seqres.full 2>&1
+        # try to turn on project quota if it's supported
+        if quotaon --help 2>&1 | grep -q '\-\-project'; then
+            quotaon --project $SCRATCH_MNT >>$seqres.full 2>&1
+        fi
     fi
     chmod ugo+rwx $SCRATCH_MNT
 }
diff --git a/tests/generic/603 b/tests/generic/603
new file mode 100755
index 00000000..54deaf13
--- /dev/null
+++ b/tests/generic/603
@@ -0,0 +1,202 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 603
+#
+# Test per-type(user, group and project) filesystem quota timers, make sure
+# enforcement
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
+	PROJECT_CHANGED=1
+}
+
+restore_project()
+{
+	if [ "$PROJECT_CHANGED" = "1" ];then
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
+	local dir=$1
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
+# When project quota is exceeded, some filesystems return ENOSPC (e.g. XFS),
+# some filsystems return EDQUOT(e.g. ext4). The behavior isn't definitized.
+# So filter the ENOSPC and EDQUOT output.
+filter_enospc_edquot()
+{
+	# The filter is only for project quota
+	if [ "$1" = "P" ];then
+		sed -e "s,Disk quota exceeded,EDQUOT|ENOSPC,g" \
+		    -e "s,No space left on device,EDQUOT|ENOSPC,g"
+	else
+		cat -
+	fi
+}
+
+test_grace()
+{
+	local type=$1
+	local dir=$2
+	local bgrace=$3
+	local igrace=$4
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
+	su $qa_user -c "$XFS_IO_PROG -c 'truncate 0' -c 'pwrite 0 $BLOCK_SIZE' \
+		$dir/file2" 2>&1 >>$seqres.full | _filter_xfs_io_error | \
+		filter_enospc_edquot $type | tee -a $seqres.full
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
+	su $qa_user -c "touch $dir/file5" 2>&1 >>$seqres.full | \
+		filter_enospc_edquot $type | _filter_scratch | \
+		tee -a $seqres.full
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
+BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
+rm -rf $SCRATCH_MNT/t
+mkdir $SCRATCH_MNT/t
+$XFS_IO_PROG -r -c "chproj 100" -c "chattr +P" $SCRATCH_MNT/t
+require_project
+
+echo "### Set up different grace timers to each type of quota"
+UBGRACE=12
+UIGRACE=10
+GBGRACE=4
+GIGRACE=2
+PBGRACE=8
+PIGRACE=6
+
+setquota -u $qa_user $((250 * $BLOCK_SIZE / 1024)) \
+	$((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
+setquota -u -t $UBGRACE $UIGRACE $SCRATCH_MNT
+echo; echo "### Test user quota softlimit and grace time"
+test_grace u $SCRATCH_MNT $UBGRACE $UIGRACE
+# Reset the user quota space & inode limits, avoid it affect later test
+setquota -u $qa_user 0 0 0 0 $SCRATCH_MNT
+
+setquota -g $qa_user $((250 * $BLOCK_SIZE / 1024)) \
+	$((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
+setquota -g -t $GBGRACE $GIGRACE $SCRATCH_MNT
+echo; echo "### Test group quota softlimit and grace time"
+test_grace g $SCRATCH_MNT $GBGRACE $GIGRACE
+# Reset the group quota space & inode limits, avoid it affect later test
+setquota -g $qa_user 0 0 0 0 $SCRATCH_MNT
+
+setquota -P $qa_user $((250 * $BLOCK_SIZE / 1024)) \
+	$((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
+setquota -P -t $PBGRACE $PIGRACE $SCRATCH_MNT
+echo; echo "### Test project quota softlimit and grace time"
+test_grace P $SCRATCH_MNT/t $PBGRACE $PIGRACE
+# Reset the project quota space & inode limits
+setquota -P $qa_user 0 0 0 0 $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/603.out b/tests/generic/603.out
new file mode 100644
index 00000000..96a7f467
--- /dev/null
+++ b/tests/generic/603.out
@@ -0,0 +1,41 @@
+QA output created by 603
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
+pwrite: EDQUOT|ENOSPC
+--- Test inode quota ---
+Create 2 more files, over the inode softlimit...
+Try to create one more inode after grace...
+touch: cannot touch 'SCRATCH_MNT/t/file5': EDQUOT|ENOSPC
+### Remove all files
diff --git a/tests/generic/group b/tests/generic/group
index d9ab9a31..b1b1bd07 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -605,3 +605,4 @@
 600 auto quick quota
 601 auto quick quota
 602 auto quick encrypt
+603 auto quick quota
-- 
2.20.1

