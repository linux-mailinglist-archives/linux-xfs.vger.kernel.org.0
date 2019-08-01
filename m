Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214A57D2F7
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 03:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfHABnY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Jul 2019 21:43:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50394 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfHABnY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 21:43:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x711Y7K3155713;
        Thu, 1 Aug 2019 01:43:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=pkXpqhaw36NG9VT8YLc3m4Eejeg6jrTNQR/Ub+CzEp4=;
 b=cOZ/BG9QbJia5SoV+CtXgyh9kQSMTXu7nqQ+/uAdv04/RRFHP7/zZwHk7tcDdcOc4/bM
 4px+PpyUcBan9XMcH5Jn+dbHeXKNGR4aEeYDxYHXCVoFDzROEklwTxmSdvC8QCgtrLpT
 uXNjS/4PznohnIW4yWmfKaghxoAYsf7VZJKwRC8ehJXKQ5Soc5k7ntHxeg3NrReBQUbn
 o7bRJoZK3rWyDRGn7Cd9SgKFauCbMWKBEP8Rkw/tC9mdDi8nnIetQn2Ejc+1qVVzIOyO
 TagZxzej6ydk1LKK3DhAKjMwgSwXjCVizylAjH40EunqqYrY90rt60d+TT+a0A4Owxvx 8A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u0ejprhhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 01:43:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x711WrLT103728;
        Thu, 1 Aug 2019 01:43:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2u2jp5nufg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 01:43:06 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x711h5Jn011301;
        Thu, 1 Aug 2019 01:43:05 GMT
Received: from localhost (/10.159.254.175)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 31 Jul 2019 18:43:05 -0700
Subject: [PATCH 4/5] common/xfs: refactor agcount calculation for mounted
 filesystems
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com,
        fstests@vger.kernel.org
Date:   Wed, 31 Jul 2019 18:43:04 -0700
Message-ID: <156462378413.2945299.7028294865508807696.stgit@magnolia>
In-Reply-To: <156462375516.2945299.16564635037236083118.stgit@magnolia>
References: <156462375516.2945299.16564635037236083118.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908010012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908010012
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a helper function to return the number of AGs of a mounted
filesystem so that we can get rid of the open-coded versions in various
tests.  The new helper will be used in a subsequent patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs    |    6 ++++++
 tests/xfs/085 |    2 +-
 tests/xfs/086 |    2 +-
 tests/xfs/087 |    2 +-
 tests/xfs/088 |    2 +-
 tests/xfs/089 |    2 +-
 tests/xfs/091 |    2 +-
 tests/xfs/093 |    2 +-
 tests/xfs/097 |    2 +-
 tests/xfs/130 |    2 +-
 tests/xfs/235 |    2 +-
 tests/xfs/271 |    2 +-
 12 files changed, 17 insertions(+), 11 deletions(-)


diff --git a/common/xfs b/common/xfs
index 2b38e94b..1bce3c18 100644
--- a/common/xfs
+++ b/common/xfs
@@ -878,3 +878,9 @@ _force_xfsv4_mount_options()
 	fi
 	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seqres.full
 }
+
+# Find AG count of mounted filesystem
+_xfs_mount_agcount()
+{
+	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
+}
diff --git a/tests/xfs/085 b/tests/xfs/085
index 23095413..18ddeff8 100755
--- a/tests/xfs/085
+++ b/tests/xfs/085
@@ -63,7 +63,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/086 b/tests/xfs/086
index 8602a565..7429d39d 100755
--- a/tests/xfs/086
+++ b/tests/xfs/086
@@ -64,7 +64,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 test "${agcount}" -gt 1 || _notrun "Single-AG XFS not supported"
 umount "${SCRATCH_MNT}"
 
diff --git a/tests/xfs/087 b/tests/xfs/087
index ede8e447..b3d3bca9 100755
--- a/tests/xfs/087
+++ b/tests/xfs/087
@@ -64,7 +64,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/088 b/tests/xfs/088
index 6f36efab..74b45163 100755
--- a/tests/xfs/088
+++ b/tests/xfs/088
@@ -64,7 +64,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/089 b/tests/xfs/089
index 5c398299..bcbc6363 100755
--- a/tests/xfs/089
+++ b/tests/xfs/089
@@ -64,7 +64,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/091 b/tests/xfs/091
index 5d6cd363..be56d8ae 100755
--- a/tests/xfs/091
+++ b/tests/xfs/091
@@ -64,7 +64,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/093 b/tests/xfs/093
index e09e8499..4c4fbdc4 100755
--- a/tests/xfs/093
+++ b/tests/xfs/093
@@ -64,7 +64,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/097 b/tests/xfs/097
index db355de6..68eae1d4 100755
--- a/tests/xfs/097
+++ b/tests/xfs/097
@@ -67,7 +67,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/130 b/tests/xfs/130
index 71c1181f..f15366a6 100755
--- a/tests/xfs/130
+++ b/tests/xfs/130
@@ -43,7 +43,7 @@ _scratch_mkfs_xfs > /dev/null
 echo "+ mount fs image"
 _scratch_mount
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 
 echo "+ make some files"
 _pwrite_byte 0x62 0 $((blksz * 64)) "${SCRATCH_MNT}/file0" >> "$seqres.full"
diff --git a/tests/xfs/235 b/tests/xfs/235
index 669f58b0..64b0a0b5 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -41,7 +41,7 @@ _scratch_mkfs_xfs > /dev/null
 echo "+ mount fs image"
 _scratch_mount
 blksz=$(stat -f -c '%s' ${SCRATCH_MNT})
-agcount=$($XFS_INFO_PROG ${SCRATCH_MNT} | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')
+agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
 
 echo "+ make some files"
 _pwrite_byte 0x62 0 $((blksz * 64)) ${SCRATCH_MNT}/file0 >> $seqres.full
diff --git a/tests/xfs/271 b/tests/xfs/271
index db14bfec..38844246 100755
--- a/tests/xfs/271
+++ b/tests/xfs/271
@@ -37,7 +37,7 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 
-agcount=$($XFS_INFO_PROG $SCRATCH_MNT | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')
+agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
 
 echo "Get fsmap" | tee -a $seqres.full
 $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT > $TEST_DIR/fsmap

