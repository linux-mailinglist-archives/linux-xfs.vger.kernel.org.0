Return-Path: <linux-xfs+bounces-19784-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9F2A3AE40
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 02:01:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3431B7A5EFF
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Feb 2025 01:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0E01BD01E;
	Wed, 19 Feb 2025 00:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pmaP/g70"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C582B9AA;
	Wed, 19 Feb 2025 00:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739926658; cv=none; b=IeyKZrgfV43fnaGjNn22hVFjfNopfK6koIIxQqltX5yRqpfqidpU7PNCr9wwpLUF2CRHfYFP9WsKx6Oo+nM/zcBkJ/FOfUBMw13AQ7F87EzVPRkqqU1AdI47Zp745eHn914Ym2Cep7ywIxMOWAPTu6sZVUAZkLvct5aUPo+jX18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739926658; c=relaxed/simple;
	bh=E8Bx7fHqW68jOvRqUhWU/y3y1ScL0GlfO67R68My53Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aYR9UAE9APcQf1D7sjw7mFvEoYlqUcv5pqIupVkZzZQv+GZZa9ejzOPCIuTgazLKG0nD3JFS9FlWafLcVmzHzG4LBlJEKK6/NHhHSBEAT0B4Voa89bW1T8CwIGdrfaQCUQ7ukYuAxgY2o9EVOr17v7m5S+yiK6E2S23yrv6XiuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pmaP/g70; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064E7C4CEE2;
	Wed, 19 Feb 2025 00:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739926658;
	bh=E8Bx7fHqW68jOvRqUhWU/y3y1ScL0GlfO67R68My53Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pmaP/g700frSXbtyDDbXVd7zFENm9CPdELa4vHv30ls9lesbz8Y8oGO7HtrVCEOIH
	 XsgaJ4ecNX6Bu8wSEZ14Tk1e8JY4TWOnR8PRPW7dMiu4oyBuzyrfxT9ZSFVLcv2pBw
	 A7LrKp9YHaBIayHsyyB956SXO8ESaaYs7bUA2ZR1lrKfgsbEcXlGQe/GscAoN2t7zr
	 TyQoZco1F1k7/6JCMuxhjpTQQkYrTHY/IGs2oJs4J4QHem+YUeiSWD4Np6DYud0rY6
	 a0hwpPvFGasZKZC2GyHmLUvQpoyyX6JVZ+0abSeX+tEcZl93JnfZSKwFsOVuXd+BVz
	 7/k50jx9i+aZg==
Date: Tue, 18 Feb 2025 16:57:37 -0800
Subject: [PATCH 4/4] fstests: test mkfs.xfs protofiles with xattr support
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <173992588723.4079248.16411570550903471187.stgit@frogsfrogsfrogs>
In-Reply-To: <173992588634.4079248.2264341183528984054.stgit@frogsfrogsfrogs>
References: <173992588634.4079248.2264341183528984054.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure we can do protofiles with xattr support.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/xfs/1937     |  144 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1937.out |  102 +++++++++++++++++++++++++++++++++++++
 2 files changed, 246 insertions(+)
 create mode 100755 tests/xfs/1937
 create mode 100644 tests/xfs/1937.out


diff --git a/tests/xfs/1937 b/tests/xfs/1937
new file mode 100755
index 00000000000000..aa4143a75ef643
--- /dev/null
+++ b/tests/xfs/1937
@@ -0,0 +1,144 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+# Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 1937
+#
+# mkfs protofile with xattrs test
+#
+. ./common/preamble
+_begin_fstest mkfs auto quick
+
+seqfull="$seqres.full"
+rm -f $seqfull
+
+. ./common/filter
+
+_cleanup()
+{
+	echo "*** unmount"
+	_scratch_unmount 2>/dev/null
+	rm -f $tmp.*
+	rm -f $TEST_DIR/$seq.file
+}
+
+_full()
+{
+	echo ""            >>$seqfull
+	echo "*** $* ***"  >>$seqfull
+	echo ""            >>$seqfull
+}
+
+_filter_stat()
+{
+	sed '
+		/^Access:/d;
+		/^Modify:/d;
+		/^Change:/d;
+		s/Device: *[0-9][0-9]*,[0-9][0-9]*/Device: <DEVICE>/;
+		s/Inode: *[0-9][0-9]*/Inode: <INODE>/;
+		s/Size: *[0-9][0-9]* *Filetype: Dir/Size: <DSIZE> Filetype: Dir/;
+	' | tr -s ' '
+}
+
+_require_command $ATTR_PROG "attr"
+_require_scratch
+
+# mkfs cannot create a filesystem with protofiles if realtime is enabled, so
+# don't run this test if the rtinherit is anywhere in the mkfs options.
+echo "$MKFS_OPTIONS" | grep -q "rtinherit" && \
+	_notrun "Cannot mkfs with a protofile and -d rtinherit."
+
+protofile=$tmp.proto
+tempfile=$TEST_DIR/$seq.file
+
+$XFS_IO_PROG -f -c 'pwrite 64k 28k' -c 'pwrite 1280k 37960' $tempfile >> $seqres.full
+$here/src/devzero -b 2048 -n 2 -c -v 44 $tempfile.2 
+
+$ATTR_PROG -R -s rootdata -V 0test $tempfile &>> $seqres.full
+$ATTR_PROG -S -s acldata -V 1test $tempfile &>> $seqres.full
+$ATTR_PROG -s userdata -V 2test $tempfile &>> $seqres.full
+perl -e 'print "x" x 37960;' | $ATTR_PROG -s bigdata $tempfile &>> $seqres.full
+
+cat >$protofile <<EOF
+DUMMY1
+0 0
+: root directory
+d--777 3 1
+: a directory
+directory d--755 3 1 
+test ---755 3 1 $tempfile
+file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_0 ---755 3 1 $tempfile
+file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_1 ---755 3 1 $tempfile
+file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_2 ---755 3 1 $tempfile
+file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_3 ---755 3 1 $tempfile
+file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_4 ---755 3 1 $tempfile
+$
+: back in the root
+setuid -u-666 0 0 $tempfile
+setgid --g666 0 0 $tempfile
+setugid -ug666 0 0 $tempfile
+directory_setgid d-g755 3 2
+file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5 ---755 3 1 $tempfile
+$
+: back in the root
+block_device b--012 3 1 161 162 
+char_device c--345 3 1 177 178
+pipe p--670 0 0
+symlink l--123 0 0 bigfile
+: a file we actually read
+bigfile ---666 3 0 $tempfile.2
+: done
+$
+EOF
+
+if [ $? -ne 0 ]
+then
+	_fail "failed to create test protofile"
+fi
+
+_verify_fs()
+{
+	echo "*** create FS version $1"
+	VERSION="-n version=$1"
+
+	_scratch_unmount >/dev/null 2>&1
+
+	_full "mkfs"
+	_scratch_mkfs_xfs $VERSION -p $protofile >>$seqfull 2>&1
+
+	echo "*** check FS"
+	_check_scratch_fs
+
+	echo "*** mount FS"
+	_full " mount"
+	_try_scratch_mount >>$seqfull 2>&1 \
+		|| _fail "mount failed"
+
+	$ATTR_PROG -l $SCRATCH_MNT/directory/test | \
+		grep -q 'Attribute.*has a ' || \
+		_notrun "mkfs.xfs protofile does not support xattrs"
+
+	echo "*** verify FS"
+	(cd $SCRATCH_MNT ; find . | LC_COLLATE=POSIX sort \
+		| grep -v ".use_space" \
+		| xargs $here/src/lstat64 | _filter_stat)
+	diff -q $SCRATCH_MNT/bigfile $tempfile.2 \
+		|| _fail "bigfile corrupted"
+	diff -q $SCRATCH_MNT/symlink $tempfile.2 \
+		|| _fail "symlink broken"
+
+	$ATTR_PROG -l $SCRATCH_MNT/directory/test | _filter_scratch
+
+	echo "*** unmount FS"
+	_full "umount"
+	_scratch_unmount >>$seqfull 2>&1 \
+		|| _fail "umount failed"
+}
+
+_verify_fs 2
+
+echo "*** done"
+status=0
+exit
diff --git a/tests/xfs/1937.out b/tests/xfs/1937.out
new file mode 100644
index 00000000000000..050c8318b1abca
--- /dev/null
+++ b/tests/xfs/1937.out
@@ -0,0 +1,102 @@
+QA output created by 1937
+Wrote 2048.00Kb (value 0x2c)
+*** create FS version 2
+*** check FS
+*** mount FS
+*** verify FS
+ File: "."
+ Size: <DSIZE> Filetype: Directory
+ Mode: (0777/drwxrwxrwx) Uid: (3) Gid: (1)
+Device: <DEVICE> Inode: <INODE> Links: 4 
+
+ File: "./bigfile"
+ Size: 2097152 Filetype: Regular File
+ Mode: (0666/-rw-rw-rw-) Uid: (3) Gid: (0)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+
+ File: "./block_device"
+ Size: 0 Filetype: Block Device
+ Mode: (0012/b-----x-w-) Uid: (3) Gid: (1)
+Device: <DEVICE> Inode: <INODE> Links: 1 Device type: 161,162
+
+ File: "./char_device"
+ Size: 0 Filetype: Character Device
+ Mode: (0345/c-wxr--r-x) Uid: (3) Gid: (1)
+Device: <DEVICE> Inode: <INODE> Links: 1 Device type: 177,178
+
+ File: "./directory"
+ Size: <DSIZE> Filetype: Directory
+ Mode: (0755/drwxr-xr-x) Uid: (3) Gid: (1)
+Device: <DEVICE> Inode: <INODE> Links: 2 
+
+ File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_0"
+ Size: 1348680 Filetype: Regular File
+ Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+
+ File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_1"
+ Size: 1348680 Filetype: Regular File
+ Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+
+ File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_2"
+ Size: 1348680 Filetype: Regular File
+ Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+
+ File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_3"
+ Size: 1348680 Filetype: Regular File
+ Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+
+ File: "./directory/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_4"
+ Size: 1348680 Filetype: Regular File
+ Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+
+ File: "./directory/test"
+ Size: 1348680 Filetype: Regular File
+ Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+
+ File: "./directory_setgid"
+ Size: <DSIZE> Filetype: Directory
+ Mode: (2755/drwxr-sr-x) Uid: (3) Gid: (2)
+Device: <DEVICE> Inode: <INODE> Links: 2 
+
+ File: "./directory_setgid/file_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx_5"
+ Size: 1348680 Filetype: Regular File
+ Mode: (0755/-rwxr-xr-x) Uid: (3) Gid: (1)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+
+ File: "./pipe"
+ Size: 0 Filetype: Fifo File
+ Mode: (0670/frw-rwx---) Uid: (0) Gid: (0)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+
+ File: "./setgid"
+ Size: 1348680 Filetype: Regular File
+ Mode: (2666/-rw-rwsrw-) Uid: (0) Gid: (0)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+
+ File: "./setugid"
+ Size: 1348680 Filetype: Regular File
+ Mode: (6666/-rwsrwsrw-) Uid: (0) Gid: (0)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+
+ File: "./setuid"
+ Size: 1348680 Filetype: Regular File
+ Mode: (4666/-rwsrw-rw-) Uid: (0) Gid: (0)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+
+ File: "./symlink"
+ Size: 7 Filetype: Symbolic Link
+ Mode: (0123/l--x-w--wx) Uid: (0) Gid: (0)
+Device: <DEVICE> Inode: <INODE> Links: 1 
+Attribute "userdata" has a 5 byte value for SCRATCH_MNT/directory/test
+Attribute "rootdata" has a 5 byte value for SCRATCH_MNT/directory/test
+Attribute "bigdata" has a 37960 byte value for SCRATCH_MNT/directory/test
+Attribute "acldata" has a 5 byte value for SCRATCH_MNT/directory/test
+*** unmount FS
+*** done
+*** unmount


