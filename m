Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D3431AA36
	for <lists+linux-xfs@lfdr.de>; Sat, 13 Feb 2021 06:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhBMFe7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 13 Feb 2021 00:34:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230462AbhBMFe6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:34:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D58AA601FC;
        Sat, 13 Feb 2021 05:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613194452;
        bh=evBbsTAF5FmnaAYzO142P7JPBOe97EHRgRudQx2yc6M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M98cT5TTDdTziMSdlDHDnj5LLTRkixaS6jr5rqA2Rocz6p46SRFYS6aXTGLzW1hrf
         8+kIwPiSQAjl4NjtEKQu+lbIsNPsFiq0UCYDZemGnrOEMZqSqI6E2lkcyZmWDLlhuH
         x/IKvliJODWbbRzIlhze0wUDUwkAM4CWxWTokMsyk7F35OvHJD+2T3Uk2Y4Ii0SDCz
         Rp3uvsmmNkAdvIlTuanEovU2LuR1i+yxs+q+O425gcaTpK9uaJSVHMh97A3TCmFciE
         53MgTNuajuPNr2ylZZl3WGegytGEH6Kw0fXinlkD/9z+NxnkZyYwRzI+RGxOo8Kk7C
         qNpouXpxQ5SIQ==
Subject: [PATCH 4/4] xfs: test upgrading filesystem to bigtime
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 12 Feb 2021 21:34:12 -0800
Message-ID: <161319445254.403615.3608204162643621319.stgit@magnolia>
In-Reply-To: <161319443045.403615.18346950431837086632.stgit@magnolia>
References: <161319443045.403615.18346950431837086632.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Test that we can upgrade an existing filesystem to use bigtime.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs        |   13 +++++
 tests/xfs/908     |   95 ++++++++++++++++++++++++++++++++++
 tests/xfs/908.out |   14 +++++
 tests/xfs/909     |  150 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/909.out |    4 +
 tests/xfs/group   |    2 +
 6 files changed, 278 insertions(+)
 create mode 100755 tests/xfs/908
 create mode 100644 tests/xfs/908.out
 create mode 100755 tests/xfs/909
 create mode 100644 tests/xfs/909.out


diff --git a/common/xfs b/common/xfs
index 294b8c4d..68a0b348 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1084,3 +1084,16 @@ _xfs_timestamp_range()
 			awk '{printf("%s %s", $1, $2);}'
 	fi
 }
+
+_require_xfs_scratch_bigtime()
+{
+	_require_scratch
+
+	_scratch_mkfs -m bigtime=1 &>/dev/null || \
+		_notrun "mkfs.xfs doesn't have bigtime feature"
+	_try_scratch_mount || \
+		_notrun "bigtime not supported by scratch filesystem type: $FSTYP"
+	$XFS_INFO_PROG "$SCRATCH_MNT" | grep -q "bigtime=1" || \
+		_notrun "bigtime feature not advertised on mount?"
+	_scratch_unmount
+}
diff --git a/tests/xfs/908 b/tests/xfs/908
new file mode 100755
index 00000000..dbb41b1d
--- /dev/null
+++ b/tests/xfs/908
@@ -0,0 +1,95 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 908
+#
+# Check that we can upgrade a filesystem to support bigtime and that inode
+# timestamps work properly after the upgrade.
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
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_command "$XFS_ADMIN_PROG" "xfs_admin"
+_require_xfs_scratch_bigtime
+_require_xfs_repair_upgrade bigtime
+
+date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
+	_notrun "Userspace does not support dates past 2038."
+
+rm -f $seqres.full
+
+# Make sure we can't upgrade a V4 filesystem
+_scratch_mkfs -m crc=0 >> $seqres.full
+_scratch_xfs_admin -O bigtime
+_scratch_xfs_db -c 'version' | grep -q BIGTIME && \
+	echo "Should not be able to upgrade to bigtime without V5."
+
+# Can we add bigtime and inobtcount at the same time?
+_scratch_mkfs -m crc=1,bigtime=0,inobtcount=0 >> $seqres.full
+_scratch_xfs_admin -O bigtime=1,inobtcount=1
+
+# Format V5 filesystem without bigtime support and populate it
+_scratch_mkfs -m crc=1,bigtime=0 >> $seqres.full
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
+_scratch_mount >> $seqres.full
+
+touch -d 'Jan 9 19:19:19 UTC 1999' $SCRATCH_MNT/a
+touch -d 'Jan 9 19:19:19 UTC 1999' $SCRATCH_MNT/b
+ls -la $SCRATCH_MNT/* >> $seqres.full
+
+echo before upgrade:
+TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
+TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
+
+_scratch_unmount
+_check_scratch_fs
+
+# Now upgrade to bigtime support
+_scratch_xfs_admin -O bigtime=1
+_scratch_xfs_db -c 'version' | grep -q BIGTIME || \
+	echo "Cannot detect new feature?"
+_check_scratch_fs
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
+
+# Mount again, look at our files
+_scratch_mount >> $seqres.full
+ls -la $SCRATCH_MNT/* >> $seqres.full
+
+# Modify one of the timestamps to stretch beyond 2038
+touch -d 'Feb 22 22:22:22 UTC 2222' $SCRATCH_MNT/b
+
+echo after upgrade:
+TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
+TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
+
+_scratch_cycle_mount
+
+# Did the timestamp survive the remount?
+ls -la $SCRATCH_MNT/* >> $seqres.full
+
+echo after upgrade and remount:
+TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
+TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/908.out b/tests/xfs/908.out
new file mode 100644
index 00000000..f9152439
--- /dev/null
+++ b/tests/xfs/908.out
@@ -0,0 +1,14 @@
+QA output created by 908
+Large timestamp feature only supported on V5 filesystems.
+Adding inode btree counts to filesystem.
+Adding large timestamp support to filesystem.
+before upgrade:
+915909559
+915909559
+Adding large timestamp support to filesystem.
+after upgrade:
+915909559
+7956915742
+after upgrade and remount:
+915909559
+7956915742
diff --git a/tests/xfs/909 b/tests/xfs/909
new file mode 100755
index 00000000..849ac738
--- /dev/null
+++ b/tests/xfs/909
@@ -0,0 +1,150 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) 2021 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 909
+#
+# Check that we can upgrade a filesystem to support bigtime and that quota
+# timers work properly after the upgrade.
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
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/quota
+
+# real QA test starts here
+_supported_fs xfs
+_require_command "$XFS_ADMIN_PROG" "xfs_admin"
+_require_quota
+_require_xfs_scratch_bigtime
+_require_xfs_repair_upgrade bigtime
+
+date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
+	_notrun "Userspace does not support dates past 2038."
+
+rm -f $seqres.full
+
+# Format V5 filesystem without bigtime support and populate it
+_scratch_mkfs -m crc=1,bigtime=0 >> $seqres.full
+_qmount_option "usrquota"
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
+_scratch_mount >> $seqres.full
+
+# Force the block counters for uid 1 and 2 above zero
+_pwrite_byte 0x61 0 64k $SCRATCH_MNT/a >> $seqres.full
+_pwrite_byte 0x61 0 64k $SCRATCH_MNT/b >> $seqres.full
+sync
+chown 1 $SCRATCH_MNT/a
+chown 2 $SCRATCH_MNT/b
+
+# Set quota limits on uid 1 before upgrading
+$XFS_QUOTA_PROG -x -c 'limit -u bsoft=12k bhard=1m 1' $SCRATCH_MNT
+
+# Make sure the grace period is at /some/ point in the future.  We have to
+# use bc because not all bashes can handle integer comparisons with 64-bit
+# numbers.
+repquota -upn $SCRATCH_MNT > $tmp.repquota
+cat $tmp.repquota >> $seqres.full
+grace="$(cat $tmp.repquota | grep '^#1' | awk '{print $6}')"
+now="$(date +%s)"
+res="$(echo "${grace} > ${now}" | $BC_PROG)"
+test $res -eq 1 || echo "Expected timer expiry (${grace}) to be after now (${now})."
+
+_scratch_unmount
+
+# Now upgrade to bigtime support
+_scratch_xfs_admin -O bigtime=1
+_scratch_xfs_db -c 'version' | grep -q BIGTIME || \
+	echo "Cannot detect new feature?"
+_check_scratch_fs
+_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
+
+# Mount again, see if our quota timer survived
+_scratch_mount
+
+# Set a very generous grace period and quota limits on uid 2 after upgrading
+$XFS_QUOTA_PROG -x -c 'timer -u -b -d 2147483647' $SCRATCH_MNT
+$XFS_QUOTA_PROG -x -c 'limit -u bsoft=10000 bhard=150000 2' $SCRATCH_MNT
+
+# Query the grace periods to see if they got set properly after the upgrade.
+repquota -upn $SCRATCH_MNT > $tmp.repquota
+cat $tmp.repquota >> $seqres.full
+grace1="$(repquota -upn $SCRATCH_MNT | grep '^#1' | awk '{print $6}')"
+grace2="$(repquota -upn $SCRATCH_MNT | grep '^#2' | awk '{print $6}')"
+now="$(date +%s)"
+
+# Make sure that uid 1's expiration is in the future...
+res1="$(echo "${grace} > ${now}" | $BC_PROG)"
+test "${res1}" -eq 1 || echo "Expected uid 1 expiry (${grace1}) to be after now (${now})."
+
+# ...and that uid 2's expiration is after uid 1's...
+res2="$(echo "${grace2} > ${grace1}" | $BC_PROG)"
+test "${res2}" -eq 1 || echo "Expected uid 2 expiry (${grace2}) to be after uid 1 (${grace1})."
+
+# ...and that uid 2's expiration is after 2038 if right now is far enough
+# past 1970 that our generous grace period would provide for that.
+res3="$(echo "(${now} < 100) || (${grace2} > 2147483648)" | $BC_PROG)"
+test "${res3}" -eq 1 || echo "Expected uid 2 expiry (${grace2}) to be after 2038."
+
+_scratch_cycle_mount
+
+# Query the grace periods to see if they survived a remount.
+repquota -upn $SCRATCH_MNT > $tmp.repquota
+cat $tmp.repquota >> $seqres.full
+grace1="$(repquota -upn $SCRATCH_MNT | grep '^#1' | awk '{print $6}')"
+grace2="$(repquota -upn $SCRATCH_MNT | grep '^#2' | awk '{print $6}')"
+now="$(date +%s)"
+
+# Make sure that uid 1's expiration is in the future...
+res1="$(echo "${grace} > ${now}" | $BC_PROG)"
+test "${res1}" -eq 1 || echo "Expected uid 1 expiry (${grace1}) to be after now (${now})."
+
+# ...and that uid 2's expiration is after uid 1's...
+res2="$(echo "${grace2} > ${grace1}" | $BC_PROG)"
+test "${res2}" -eq 1 || echo "Expected uid 2 expiry (${grace2}) to be after uid 1 (${grace1})."
+
+# ...and that uid 2's expiration is after 2038 if right now is far enough
+# past 1970 that our generous grace period would provide for that.
+res3="$(echo "(${now} < 100) || (${grace2} > 2147483648)" | $BC_PROG)"
+test "${res3}" -eq 1 || echo "Expected uid 2 expiry (${grace2}) to be after 2038."
+
+# Now try setting uid 2's expiration to Feb 22 22:22:22 UTC 2222
+new_expiry=$(date -d 'Feb 22 22:22:22 UTC 2222' +%s)
+now=$(date +%s)
+test $now -ge $new_expiry && \
+	echo "Now is after February 2222?  Expect problems."
+expiry_delta=$((new_expiry - now))
+
+echo "setting expiration to $new_expiry - $now = $expiry_delta" >> $seqres.full
+$XFS_QUOTA_PROG -x -c "timer -u $expiry_delta 2" -c 'report' $SCRATCH_MNT >> $seqres.full
+
+# Did we get an expiration within 5s of the target range?
+grace2="$(repquota -upn $SCRATCH_MNT | grep '^#2' | awk '{print $6}')"
+echo "grace2 is $grace2" >> $seqres.full
+_within_tolerance "grace2 expiry" $grace2 $new_expiry 5 -v
+
+_scratch_cycle_mount
+
+# ...and is it still within 5s after a remount?
+grace2="$(repquota -upn $SCRATCH_MNT | grep '^#2' | awk '{print $6}')"
+echo "grace2 is $grace2" >> $seqres.full
+_within_tolerance "grace2 expiry after remount" $grace2 $new_expiry 5 -v
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/909.out b/tests/xfs/909.out
new file mode 100644
index 00000000..88898408
--- /dev/null
+++ b/tests/xfs/909.out
@@ -0,0 +1,4 @@
+QA output created by 909
+Adding large timestamp support to filesystem.
+grace2 expiry is in range
+grace2 expiry after remount is in range
diff --git a/tests/xfs/group b/tests/xfs/group
index a585c3b4..58b17ca7 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -509,6 +509,8 @@
 765 auto quick quota
 768 auto quick repair
 770 auto repair
+908 auto quick bigtime
+909 auto quick bigtime quota
 910 auto quick inobtcount
 911 auto quick bigtime
 915 auto quick quota

