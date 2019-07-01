Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FE81687D
	for <lists+linux-xfs@lfdr.de>; Tue,  7 May 2019 18:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfEGQ5J (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 May 2019 12:57:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59220 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbfEGQ5I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 12:57:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x47Ghc7f183681;
        Tue, 7 May 2019 16:56:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=tEpd8zINojBtDfNgOw8DY2ZnXQwJRr4H9E6erK341x0=;
 b=h3Yayy9KlGddAF3AMAJ2WpOGE8xk+wFz7qiUzlRVMMFfSPxqUpol5tRmAZYekmpIUQDC
 PHgT/5RGOVnP8hAE7mWKhhuxSN9gI/VAwUvMAYhuHWNn0epXuMlI3eoBNO12oXczYFpT
 VWuRpqQ3jSvTFLGMhd6YyMYgvaD9YiV1Iam5fFeKaiKkwU6HbvnyKvnmJ+FGBOsCQxNJ
 6QS7RNumREMSVTCzciF4/DKF9ZVgPlO6m1RMSnI2RXg9PsYp9saoCItyLDy1YIcOrPKO
 6IBidd8/opY/c9lMJz+vjQiWG34VcQ5QvkYHo9XYV6y93Ll1+7S4/50oS6WRnzOROMEW 9Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2s94b0prtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 16:56:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x47GtLSj159114;
        Tue, 7 May 2019 16:56:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2s94afkk59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 May 2019 16:56:58 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x47GuwuG028313;
        Tue, 7 May 2019 16:56:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 May 2019 09:56:57 -0700
Subject: [PATCH 1/3] xfs: refactor minimum log size formatting code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, xuyang2018.jy@cn.fujitsu.com,
        fstests@vger.kernel.org
Date:   Tue, 07 May 2019 09:56:56 -0700
Message-ID: <155724821672.2624631.8817002340394524781.stgit@magnolia>
In-Reply-To: <155724821034.2624631.4172554705843296757.stgit@magnolia>
References: <155724821034.2624631.4172554705843296757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9250 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905070109
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9250 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905070109
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a new helper function to discover the minimum log size that will
work with the mkfs options provided, then remove all the hardcoded block
sizes from various xfs tests.  This will be necessary when we turn on
reflink or rmap by default and the minimum log size increases.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs    |   36 ++++++++++++++++++++++++++++++++++++
 tests/xfs/104 |    3 ++-
 tests/xfs/119 |    3 ++-
 tests/xfs/291 |    3 ++-
 tests/xfs/295 |    5 +++--
 tests/xfs/297 |    3 ++-
 6 files changed, 47 insertions(+), 6 deletions(-)


diff --git a/common/xfs b/common/xfs
index af2b62ba..42f02ff7 100644
--- a/common/xfs
+++ b/common/xfs
@@ -77,6 +77,42 @@ _scratch_mkfs_xfs_supported()
 	return $mkfs_status
 }
 
+# Returns the minimum XFS log size, in units of log blocks.
+_scratch_find_xfs_min_logblocks()
+{
+	local mkfs_cmd="`_scratch_mkfs_xfs_opts`"
+
+	# The smallest log size we can specify is 2M (XFS_MIN_LOG_BYTES) so
+	# pass that in and see if mkfs succeeds or tells us what is the
+	# minimum log size.
+	local XFS_MIN_LOG_BYTES=2097152
+
+	_scratch_do_mkfs "$mkfs_cmd" "cat" $* -N -l size=$XFS_MIN_LOG_BYTES \
+		2>$tmp.mkfserr 1>$tmp.mkfsstd
+	local mkfs_status=$?
+
+	# mkfs suceeded, so we must pick out the log block size to do the
+	# unit conversion
+	if [ $mkfs_status -eq 0 ]; then
+		local blksz="$(grep '^log.*bsize' $tmp.mkfsstd | \
+			sed -e 's/log.*bsize=\([0-9]*\).*$/\1/g')"
+		echo $((XFS_MIN_LOG_BYTES / blksz))
+		return
+	fi
+
+	# Usually mkfs will tell us the minimum log size...
+	if grep -q 'minimum size is' $tmp.mkfserr; then
+		grep 'minimum size is' $tmp.mkfserr | \
+			sed -e 's/^.*minimum size is \([0-9]*\) blocks/\1/g'
+		return
+	fi
+
+	# Don't know what to do, so fail
+	echo "Cannot determine minimum log size" >&2
+	cat $tmp.mkfsstd >> $seqres.full
+	cat $tmp.mkfserr >> $seqres.full
+}
+
 _scratch_mkfs_xfs()
 {
 	local mkfs_cmd="`_scratch_mkfs_xfs_opts`"
diff --git a/tests/xfs/104 b/tests/xfs/104
index bc38f969..679aced4 100755
--- a/tests/xfs/104
+++ b/tests/xfs/104
@@ -71,7 +71,8 @@ nags=4
 size=`expr 125 \* 1048576`	# 120 megabytes initially
 sizeb=`expr $size / $dbsize`	# in data blocks
 echo "*** creating scratch filesystem"
-_create_scratch -lsize=10m -dsize=${size} -dagcount=${nags}
+logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
+_create_scratch -lsize=${logblks}b -dsize=${size} -dagcount=${nags}
 
 echo "*** using some initial space on scratch filesystem"
 for i in `seq 125 -1 90`; do
diff --git a/tests/xfs/119 b/tests/xfs/119
index bf7f1ca8..8825a5c3 100755
--- a/tests/xfs/119
+++ b/tests/xfs/119
@@ -38,7 +38,8 @@ _require_scratch
 # this may hang
 sync
 
-export MKFS_OPTIONS="-l version=2,size=2560b,su=64k" 
+logblks=$(_scratch_find_xfs_min_logblocks -l version=2,su=64k)
+export MKFS_OPTIONS="-l version=2,size=${logblks}b,su=64k"
 export MOUNT_OPTIONS="-o logbsize=64k"
 _scratch_mkfs_xfs >/dev/null
 
diff --git a/tests/xfs/291 b/tests/xfs/291
index 349d0cd0..8a4b1354 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -31,7 +31,8 @@ _supported_os Linux
 # real QA test starts here
 rm -f $seqres.full
 _require_scratch
-_scratch_mkfs_xfs -n size=16k -l size=10m -d size=133m >> $seqres.full 2>&1
+logblks=$(_scratch_find_xfs_min_logblocks -n size=16k -d size=133m)
+_scratch_mkfs_xfs -n size=16k -l size=${logblks}b -d size=133m >> $seqres.full 2>&1
 _scratch_mount
 
 # First we cause very badly fragmented freespace, then
diff --git a/tests/xfs/295 b/tests/xfs/295
index 7d1c8faf..65da7d65 100755
--- a/tests/xfs/295
+++ b/tests/xfs/295
@@ -36,7 +36,8 @@ _require_attrs
 
 rm -f $seqres.full
 
-_scratch_mkfs -l size=2560b >/dev/null 2>&1
+logblks=$(_scratch_find_xfs_min_logblocks)
+_scratch_mkfs -l size=${logblks}b >/dev/null 2>&1
 
 # Should yield a multiply-logged inode, thanks to xattr
 # Old logprint says this, then coredumps:
@@ -53,7 +54,7 @@ _scratch_xfs_logprint 2>&1 >> $seqres.full
 # match, not as a continued transaction.  If that happens we'll see:
 #	xfs_logprint: unknown log operation type (494e)
 
-_scratch_mkfs -l size=2560b >/dev/null 2>&1
+_scratch_mkfs -l size=${logblks}b >/dev/null 2>&1
 _scratch_mount
 for I in `seq 0 8192`; do
         echo a >> $SCRATCH_MNT/cat
diff --git a/tests/xfs/297 b/tests/xfs/297
index 1a048b4b..4f564add 100755
--- a/tests/xfs/297
+++ b/tests/xfs/297
@@ -36,7 +36,8 @@ _require_freeze
 _require_command "$KILLALL_PROG" killall
 
 rm -f $seqres.full
-_scratch_mkfs_xfs -d agcount=16,su=256k,sw=12 -l su=256k,size=5120b >/dev/null 2>&1
+logblks=$(_scratch_find_xfs_min_logblocks -d agcount=16,su=256k,sw=12 -l su=256k)
+_scratch_mkfs_xfs -d agcount=16,su=256k,sw=12 -l su=256k,size=${logblks}b >/dev/null 2>&1
 _scratch_mount
 
 STRESS_DIR="$SCRATCH_MNT/testdir"

