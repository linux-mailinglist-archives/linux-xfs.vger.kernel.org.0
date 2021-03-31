Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F18534F5C5
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Mar 2021 03:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhCaBJX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Mar 2021 21:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232892AbhCaBIz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 21:08:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3E0361953;
        Wed, 31 Mar 2021 01:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617152934;
        bh=EUtYJujld5xMWf0YgJU+o1zPR1fKikX1eGVwQtc9oDo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hpUgDeRtJTnws6nQY/tOadOuYQri//sFXcUT+6GQwPKEK+eR53U9j79aD+rvFg5qI
         jSKw8iu+GWpLsx7/jF4yfaKouvJeDbbFk4pzhaGHodMt2VppcemdjrqEAqO9+zULaa
         ZN6vOZC7fK3dvUlckKZbia9MshvYLLUijh5+PRlHN+7nD/yiOgHYDKa2dmn0SdSosR
         mVavGpIJbMmuWGvK+9NEbN31vyApgv+lSfsf69qh2/jzjEl/4sadx1orWK6dUYzYLy
         /oU4+hvMC8zr5GgAzY/ftqsHM+1UxejIHB0XUZ2aXma2MM9K3YCS2/M2gt/hF0WkuB
         MLQWN/dEOZLDQ==
Subject: [PATCH 3/4] xfs: detect time limits from filesystem
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 30 Mar 2021 18:08:52 -0700
Message-ID: <161715293237.2703979.18399191447470372230.stgit@magnolia>
In-Reply-To: <161715291588.2703979.11541640936666929011.stgit@magnolia>
References: <161715291588.2703979.11541640936666929011.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach fstests to extract timestamp limits of a filesystem using the new
xfs_db timelimit command.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc         |    2 +-
 common/xfs        |   19 +++++++++++++++++++
 tests/xfs/911     |   44 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/911.out |   15 +++++++++++++++
 tests/xfs/group   |    1 +
 5 files changed, 80 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/911
 create mode 100644 tests/xfs/911.out


diff --git a/common/rc b/common/rc
index 23f86ce6..21b87557 100644
--- a/common/rc
+++ b/common/rc
@@ -2054,7 +2054,7 @@ _filesystem_timestamp_range()
 		echo "0 $u32max"
 		;;
 	xfs)
-		echo "$s32min $s32max"
+		_xfs_timestamp_range "$device"
 		;;
 	btrfs)
 		echo "$s64min $s64max"
diff --git a/common/xfs b/common/xfs
index a65eeb58..37658788 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1133,3 +1133,22 @@ _require_xfs_scratch_inobtcount()
 		_notrun "inobtcount not supported by scratch filesystem type: $FSTYP"
 	_scratch_unmount
 }
+
+_xfs_timestamp_range()
+{
+	local device="$1"
+	local use_db=0
+	local dbprog="$XFS_DB_PROG $device"
+	test "$device" = "$SCRATCH_DEV" && dbprog=_scratch_xfs_db
+
+	$dbprog -f -c 'help timelimit' | grep -v -q 'not found' && use_db=1
+	if [ $use_db -eq 0 ]; then
+		# The "timelimit" command was added to xfs_db at the same time
+		# that bigtime was added to xfsprogs.  Therefore, we can assume
+		# the old timestamp range if the command isn't present.
+		echo "-$((1<<31)) $(((1<<31)-1))"
+	else
+		$dbprog -f -c 'timelimit --compact' | \
+			awk '{printf("%s %s", $1, $2);}'
+	fi
+}
diff --git a/tests/xfs/911 b/tests/xfs/911
new file mode 100755
index 00000000..01ddb856
--- /dev/null
+++ b/tests/xfs/911
@@ -0,0 +1,44 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 911
+#
+# Check that the xfs_db timelimit command prints the ranges that we expect.
+# This in combination with an xfs_ondisk.h build time check in the kernel
+# ensures that the kernel agrees with userspace.
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
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_xfs_db_command timelimit
+
+rm -f $seqres.full
+
+# Format filesystem without bigtime support and populate it
+_scratch_mkfs > $seqres.full
+echo classic xfs timelimits
+_scratch_xfs_db -c 'timelimit --classic'
+echo bigtime xfs timelimits
+_scratch_xfs_db -c 'timelimit --bigtime'
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/911.out b/tests/xfs/911.out
new file mode 100644
index 00000000..84dc475b
--- /dev/null
+++ b/tests/xfs/911.out
@@ -0,0 +1,15 @@
+QA output created by 911
+classic xfs timelimits
+time.min = -2147483648
+time.max = 2147483647
+dqtimer.min = 1
+dqtimer.max = 4294967295
+dqgrace.min = 0
+dqgrace.min = 4294967295
+bigtime xfs timelimits
+time.min = -2147483648
+time.max = 16299260424
+dqtimer.min = 4
+dqtimer.max = 16299260424
+dqgrace.min = 0
+dqgrace.min = 4294967295
diff --git a/tests/xfs/group b/tests/xfs/group
index 0dc8038a..e212fd46 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -525,3 +525,4 @@
 770 auto repair
 773 auto quick repair
 910 auto quick inobtcount
+911 auto quick bigtime

