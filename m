Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A8BE9A08
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Oct 2019 11:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbfJ3KeX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 30 Oct 2019 06:34:23 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48291 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726046AbfJ3KeX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 06:34:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572431662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xVermggFmUZX5KgDLcs8Tz6XDFrKSCHfytqJ4Sb09vk=;
        b=gjklNrvIsOw5lvqskdrzETBM2U0JqjOcOYZDUOYQjiRc5/iMxIfqKpXTDt3PebrLHlrX4M
        7AkeVKgjlexCJhlG6Mkmm2QwWeJKefZptgj2zj7CihQiVU4UI7zQM53bTD8DsRkdLnmMrk
        BIJmx/1MbrYnKz7S7PFNwOYC5qMUZSo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-_Yo5RX8POHqtrsh_7X6c8A-1; Wed, 30 Oct 2019 06:34:18 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51817800C61;
        Wed, 30 Oct 2019 10:34:17 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-92.pek2.redhat.com [10.72.12.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81CFF19C78;
        Wed, 30 Oct 2019 10:34:15 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfstests: xfs mount option sanity test
Date:   Wed, 30 Oct 2019 18:34:10 +0800
Message-Id: <20191030103410.2239-1-zlang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: _Yo5RX8POHqtrsh_7X6c8A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS is changing to suit the new mount API, so add this case to make
sure the changing won't bring in regression issue on xfs mount option
parse phase, and won't change some default behaviors either.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

V2 did below changes:
1) Fix wrong output messages in _do_test function
2) Remove logbufs=3DN and logbsize=3DN default display test. Lastest upstre=
am
   kernel displays these options in /proc/mounts by default, but old kernel
   doesn't show them except user indicate these options when mount xfs.
   Refer to https://marc.info/?l=3Dfstests&m=3D157199699615477&w=3D2

Thanks,
Zorro

 tests/xfs/148     | 320 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/148.out |   6 +
 tests/xfs/group   |   1 +
 3 files changed, 327 insertions(+)
 create mode 100755 tests/xfs/148
 create mode 100644 tests/xfs/148.out

diff --git a/tests/xfs/148 b/tests/xfs/148
new file mode 100755
index 00000000..a662f6f7
--- /dev/null
+++ b/tests/xfs/148
@@ -0,0 +1,320 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Red Hat, Inc. All Rights Reserved.
+#
+# FS QA Test 148
+#
+# XFS mount options sanity check, refer to 'man 5 xfs'.
+#
+seq=3D`basename $0`
+seqres=3D$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=3D`pwd`
+tmp=3D/tmp/$$
+status=3D1=09# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+=09cd /
+=09rm -f $tmp.*
+=09$UMOUNT_PROG $LOOP_MNT 2>/dev/null
+=09if [ -n "$LOOP_DEV" ];then
+=09=09_destroy_loop_device $LOOP_DEV 2>/dev/null
+=09fi
+=09if [ -n "$LOOP_SPARE_DEV" ];then
+=09=09_destroy_loop_device $LOOP_SPARE_DEV 2>/dev/null
+=09fi
+=09rm -f $LOOP_IMG
+=09rm -f $LOOP_SPARE_IMG
+=09rmdir $LOOP_MNT
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_test
+_require_loop
+_require_xfs_io_command "falloc"
+
+LOOP_IMG=3D$TEST_DIR/$seq.dev
+LOOP_SPARE_IMG=3D$TEST_DIR/$seq.logdev
+LOOP_MNT=3D$TEST_DIR/$seq.mnt
+
+echo "** create loop device"
+$XFS_IO_PROG -f -c "falloc 0 1g" $LOOP_IMG
+LOOP_DEV=3D`_create_loop_device $LOOP_IMG`
+
+echo "** create loop log device"
+$XFS_IO_PROG -f -c "falloc 0 512m" $LOOP_SPARE_IMG
+LOOP_SPARE_DEV=3D`_create_loop_device $LOOP_SPARE_IMG`
+
+echo "** create loop mount point"
+rmdir $LOOP_MNT 2>/dev/null
+mkdir -p $LOOP_MNT || _fail "cannot create loopback mount point"
+
+# avoid the effection from MKFS_OPTIONS
+MKFS_OPTIONS=3D""
+do_mkfs()
+{
+=09$MKFS_XFS_PROG -f $* $LOOP_DEV | _filter_mkfs >$seqres.full 2>$tmp.mkfs
+=09if [ "${PIPESTATUS[0]}" -ne 0 ]; then
+=09=09_fail "Fails on _mkfs_dev $* $LOOP_DEV"
+=09fi
+=09. $tmp.mkfs
+}
+
+is_dev_mounted()
+{
+=09findmnt --source $LOOP_DEV >/dev/null
+=09return $?
+}
+
+get_mount_info()
+{
+=09findmnt --source $LOOP_DEV -o OPTIONS -n
+}
+
+force_unmount()
+{
+=09$UMOUNT_PROG $LOOP_MNT >/dev/null 2>&1
+}
+
+# _do_test <mount options> <should be mounted?> [<key string> <key should =
be found?>]
+_do_test()
+{
+=09local opts=3D"$1"
+=09local mounted=3D"$2"=09# pass or fail
+=09local key=3D"$3"
+=09local found=3D"$4"=09# true or false
+=09local rc
+=09local info
+
+=09# mount test
+=09_mount $LOOP_DEV $LOOP_MNT $opts 2>/dev/null
+=09rc=3D$?
+=09if [ $rc -eq 0 ];then
+=09=09if [ "${mounted}" =3D "fail" ];then
+=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+=09=09=09echo "ERROR: expect ${mounted}, but pass"
+=09=09=09return 1
+=09=09fi
+=09=09is_dev_mounted
+=09=09if [ $? -ne 0 ];then
+=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+=09=09=09echo "ERROR: fs not mounted even mount return 0"
+=09=09=09return 1
+=09=09fi
+=09else
+=09=09if [ "${mount_ret}" =3D "pass" ];then
+=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+=09=09=09echo "ERROR: expect ${mounted}, but fail"
+=09=09=09return 1
+=09=09fi
+=09=09is_dev_mounted
+=09=09if [ $? -eq 0 ];then
+=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+=09=09=09echo "ERROR: fs is mounted even mount return non-zero"
+=09=09=09return 1
+=09=09fi
+=09fi
+
+=09# Skip below checking if "$key" argument isn't specified
+=09if [ -z "$key" ];then
+=09=09return 0
+=09fi
+=09# Check the mount options after fs mounted.
+=09info=3D`get_mount_info`
+=09echo $info | grep -q "${key}"
+=09rc=3D$?
+=09if [ $rc -eq 0 ];then
+=09=09if [ "$found" !=3D "true" ];then
+=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+=09=09=09echo "ERROR: expect there's not $key in $info, but not found"
+=09=09=09return 1
+=09=09fi
+=09else
+=09=09if [ "$found" !=3D "false" ];then
+=09=09=09echo "[FAILED]: mount $LOOP_DEV $LOOP_MNT $opts"
+=09=09=09echo "ERROR: expect there's $key in $info, but found"
+=09=09=09return 1
+=09=09fi
+=09fi
+
+=09return 0
+}
+
+do_test()
+{
+=09# force unmount before testing
+=09force_unmount
+=09_do_test "$@"
+=09# force unmount after testing
+=09force_unmount
+}
+
+echo "** start xfs mount testing ..."
+# Test allocsize=3Dsize
+# Valid values for this option are page size (typically 4KiB) through to 1=
GiB
+do_mkfs
+if [ $dbsize -ge 1024 ];then
+=09blsize=3D"$((dbsize / 1024))k"
+fi
+do_test "" pass "allocsize" "false"
+do_test "-o allocsize=3D$blsize" pass "allocsize=3D$blsize" "true"
+do_test "-o allocsize=3D1048576k" pass "allocsize=3D1048576k" "true"
+do_test "-o allocsize=3D$((dbsize / 2))" fail
+do_test "-o allocsize=3D2g" fail
+
+# Test attr2
+do_mkfs -m crc=3D1
+do_test "" pass "attr2" "true"
+do_test "-o attr2" pass "attr2" "true"
+do_test "-o noattr2" fail
+do_mkfs -m crc=3D0
+do_test "" pass "attr2" "true"
+do_test "-o attr2" pass "attr2" "true"
+do_test "-o noattr2" pass "attr2" "false"
+
+# Test discard
+do_mkfs
+do_test "" pass "discard" "false"
+do_test "-o discard" pass "discard" "true"
+do_test "-o nodiscard" pass "discard" "false"
+
+# Test grpid|bsdgroups|nogrpid|sysvgroups
+do_test "" pass "grpid" "false"
+do_test "-o grpid" pass "grpid" "true"
+do_test "-o bsdgroups" pass "grpid" "true"
+do_test "-o nogrpid" pass "grpid" "false"
+do_test "-o sysvgroups" pass "grpid" "false"
+
+# Test filestreams
+do_test "" pass "filestreams" "false"
+do_test "-o filestreams" pass "filestreams" "true"
+
+# Test ikeep
+do_test "" pass "ikeep" "false"
+do_test "-o ikeep" pass "ikeep" "true"
+do_test "-o noikeep" pass "ikeep" "false"
+
+# Test inode32|inode64
+do_test "" pass "inode64" "true"
+do_test "-o inode32" pass "inode32" "true"
+do_test "-o inode64" pass "inode64" "true"
+
+# Test largeio
+do_test "" pass "largeio" "false"
+do_test "-o largeio" pass "largeio" "true"
+do_test "-o nolargeio" pass "largeio" "false"
+
+# Test logbufs=3Dvalue. Valid numbers range from 2=E2=80=938 inclusive.
+# New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_siz=
e)
+# prints "logbufs=3DN" in /proc/mounts, but old kernel not. So the default
+# 'display' about logbufs can't be expected, disable this test.
+#do_test "" pass "logbufs" "false"
+do_test "-o logbufs=3D8" pass "logbufs=3D8" "true"
+do_test "-o logbufs=3D2" pass "logbufs=3D2" "true"
+do_test "-o logbufs=3D1" fail
+do_test "-o logbufs=3D9" fail
+do_test "-o logbufs=3D99999999999999" fail
+
+# Test logbsize=3Dvalue.
+do_mkfs -m crc=3D1 -l version=3D2
+# New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_siz=
e)
+# prints "logbsize=3DN" in /proc/mounts, but old kernel not. So the defaul=
t
+# 'display' about logbsize can't be expected, disable this test.
+#do_test "" pass "logbsize" "false"
+do_test "-o logbsize=3D16384" pass "logbsize=3D16k" "true"
+do_test "-o logbsize=3D16k" pass "logbsize=3D16k" "true"
+do_test "-o logbsize=3D32k" pass "logbsize=3D32k" "true"
+do_test "-o logbsize=3D64k" pass "logbsize=3D64k" "true"
+do_test "-o logbsize=3D128k" pass "logbsize=3D128k" "true"
+do_test "-o logbsize=3D256k" pass "logbsize=3D256k" "true"
+do_test "-o logbsize=3D8k" fail
+do_test "-o logbsize=3D512k" fail
+do_mkfs -m crc=3D0 -l version=3D1
+# New kernel (refer to 4f62282a3696 xfs: cleanup xlog_get_iclog_buffer_siz=
e)
+# prints "logbsize=3DN" in /proc/mounts, but old kernel not. So the defaul=
t
+# 'display' about logbsize can't be expected, disable this test.
+#do_test "" pass "logbsize" "false"
+do_test "-o logbsize=3D16384" pass "logbsize=3D16k" "true"
+do_test "-o logbsize=3D16k" pass "logbsize=3D16k" "true"
+do_test "-o logbsize=3D32k" pass "logbsize=3D32k" "true"
+do_test "-o logbsize=3D64k" fail
+
+# Test logdev
+do_mkfs
+do_test "" pass "logdev" "false"
+do_test "-o logdev=3D$LOOP_SPARE_DEV" fail
+do_mkfs -l logdev=3D$LOOP_SPARE_DEV
+do_test "-o logdev=3D$LOOP_SPARE_DEV" pass "logdev=3D$LOOP_SPARE_DEV" "tru=
e"
+do_test "" fail
+
+# Test noalign
+do_mkfs
+do_test "" pass "noalign" "false"
+do_test "-o noalign" pass "noalign" "true"
+
+# Test norecovery
+do_test "" pass "norecovery" "false"
+do_test "-o norecovery,ro" pass "norecovery" "true"
+do_test "-o norecovery" fail
+
+# Test nouuid
+do_test "" pass "nouuid" "false"
+do_test "-o nouuid" pass "nouuid" "true"
+
+# Test noquota
+do_test "" pass "noquota" "true"
+do_test "-o noquota" pass "noquota" "true"
+
+# Test uquota/usrquota/quota/uqnoenforce/qnoenforce
+do_test "" pass "usrquota" "false"
+do_test "-o uquota" pass "usrquota" "true"
+do_test "-o usrquota" pass "usrquota" "true"
+do_test "-o quota" pass "usrquota" "true"
+do_test "-o uqnoenforce" pass "usrquota" "true"
+do_test "-o qnoenforce" pass "usrquota" "true"
+
+# Test gquota/grpquota/gqnoenforce
+do_test "" pass "grpquota" "false"
+do_test "-o gquota" pass "grpquota" "true"
+do_test "-o grpquota" pass "grpquota" "true"
+do_test "-o gqnoenforce" pass "gqnoenforce" "true"
+
+# Test pquota/prjquota/pqnoenforce
+do_test "" pass "prjquota" "false"
+do_test "-o pquota" pass "prjquota" "true"
+do_test "-o prjquota" pass "prjquota" "true"
+do_test "-o pqnoenforce" pass "pqnoenforce" "true"
+
+# Test sunit=3Dvalue and swidth=3Dvalue
+do_mkfs -d sunit=3D128,swidth=3D128
+do_test "-o sunit=3D8,swidth=3D8" pass "sunit=3D8,swidth=3D8" "true"
+do_test "-o sunit=3D8,swidth=3D64" pass "sunit=3D8,swidth=3D64" "true"
+do_test "-o sunit=3D128,swidth=3D128" pass "sunit=3D128,swidth=3D128" "tru=
e"
+do_test "-o sunit=3D256,swidth=3D256" pass "sunit=3D256,swidth=3D256" "tru=
e"
+do_test "-o sunit=3D2,swidth=3D2" fail
+
+# Test swalloc
+do_mkfs
+do_test "" pass "swalloc" "false"
+do_test "-o swalloc" pass "swalloc" "true"
+
+# Test wsync
+do_test "" pass "wsync" "false"
+do_test "-o wsync" pass "wsync" "true"
+
+echo "** end of testing"
+# success, all done
+status=3D0
+exit
diff --git a/tests/xfs/148.out b/tests/xfs/148.out
new file mode 100644
index 00000000..a71d9231
--- /dev/null
+++ b/tests/xfs/148.out
@@ -0,0 +1,6 @@
+QA output created by 148
+** create loop device
+** create loop log device
+** create loop mount point
+** start xfs mount testing ...
+** end of testing
diff --git a/tests/xfs/group b/tests/xfs/group
index f4ebcd8c..019aebad 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -145,6 +145,7 @@
 145 dmapi
 146 dmapi
 147 dmapi
+148 auto quick mount
 150 dmapi
 151 dmapi
 152 dmapi
--=20
2.20.1

