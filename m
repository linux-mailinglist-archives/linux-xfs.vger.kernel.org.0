Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D496F24373
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 00:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfETWbT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 18:31:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58446 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfETWbT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 18:31:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KMTCLP120379;
        Mon, 20 May 2019 22:31:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=od69YGy0r05gFuikfH71p2D4yWiCZkJ+DwRAV1jKGHM=;
 b=b86Utr7Sz7/1Bfik8MhCdznQJ4oExDd6jX/2t3ZKtufuqOqQIilIxoZB7qXyfhlh9NZS
 6odeXEr/SL/b020Om0wPW6v+Glbfd+V+z5ELLC/8fpsIUw+lyD1r3N4yCi8N1skE/b8N
 lwFknADssmWi0vGdgVg6fUxK/l2pQdkakJvNNkQacuCYX9/4qNYDTKrMadj7/6sEPdzh
 eCSG2qRyp0j0aOMm9VQN2+kmsapEfYmDqZazJ+T5sHgnvWBJY+L7KnX1bDd4oC4TAlmm
 DEsQhDu5wvhgIs/1RlCH9VOTQdh1RI3a2aMj9op82i7FYd7dCqYIJdFUxXSx53dEoun0 MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2sjapq9qgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:31:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KMTcBX173129;
        Mon, 20 May 2019 22:31:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2sks1j3tvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 22:31:13 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4KMVBBK002794;
        Mon, 20 May 2019 22:31:12 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 22:31:11 +0000
Subject: [PATCH 3/3] generic,
 xfs: use _scratch_shutdown instead of calling src/godown
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, jefflexu@linux.alibaba.com,
        amir73il@gmail.com, fstests@vger.kernel.org
Date:   Mon, 20 May 2019 15:31:10 -0700
Message-ID: <155839147057.62682.15559355049172171217.stgit@magnolia>
In-Reply-To: <155839145160.62682.10916303376882370723.stgit@magnolia>
References: <155839145160.62682.10916303376882370723.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200138
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Overlayfs introduces some complexity with regards to what path we have
to use to shut down the scratch filesystem: it's SCRATCH_MNT for regular
filesystems, but it's OVL_BASE_SCRATCH_MNT (i.e. the lower mount of the
overlay) if overlayfs is enabled.  The helper works through all that, so
we might as well use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/050 |    2 +-
 tests/xfs/051     |    2 +-
 tests/xfs/079     |    2 +-
 tests/xfs/121     |    4 ++--
 tests/xfs/181     |    4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)


diff --git a/tests/generic/050 b/tests/generic/050
index 9a327165..91632d2d 100755
--- a/tests/generic/050
+++ b/tests/generic/050
@@ -92,7 +92,7 @@ echo "touch files"
 touch $SCRATCH_MNT/{0,1,2,3,4,5,6,7,8,9}{0,1,2,3,4,5,6,7,8,9}
 
 echo "going down:"
-src/godown -f $SCRATCH_MNT
+_scratch_shutdown -f
 
 echo "unmounting shutdown filesystem:"
 _scratch_unmount 2>&1 | _filter_scratch
diff --git a/tests/xfs/051 b/tests/xfs/051
index bcc824f8..105fa9ff 100755
--- a/tests/xfs/051
+++ b/tests/xfs/051
@@ -47,7 +47,7 @@ _scratch_mount
 # recovery.
 $FSSTRESS_PROG -n 9999 -p 2 -w -d $SCRATCH_MNT > /dev/null 2>&1 &
 sleep 5
-src/godown -f $SCRATCH_MNT
+_scratch_shutdown -f
 $KILLALL_PROG -q $FSSTRESS_PROG
 wait
 _scratch_unmount
diff --git a/tests/xfs/079 b/tests/xfs/079
index bf965a7f..67250495 100755
--- a/tests/xfs/079
+++ b/tests/xfs/079
@@ -56,7 +56,7 @@ _scratch_mount "-o logbsize=32k"
 # Run a workload to dirty the log, wait a bit and shutdown the fs.
 $FSSTRESS_PROG -d $SCRATCH_MNT -p 4 -n 99999999 >> $seqres.full 2>&1 &
 sleep 10
-./src/godown -f $SCRATCH_MNT
+_scratch_shutdown -f
 wait
 
 # Remount with a different log buffer size. Going from 32k to 64k increases the
diff --git a/tests/xfs/121 b/tests/xfs/121
index d82a367f..2e3914b7 100755
--- a/tests/xfs/121
+++ b/tests/xfs/121
@@ -52,7 +52,7 @@ src/multi_open_unlink -f $SCRATCH_MNT/test_file -n $num_files -s $delay &
 sleep 3
 
 echo "godown"
-src/godown -v -f $SCRATCH_MNT >> $seqres.full
+_scratch_shutdown -v -f >> $seqres.full
 
 # time for multi_open_unlink to exit out after its delay
 # so we have no references and can unmount
@@ -69,7 +69,7 @@ _try_scratch_mount $mnt >>$seqres.full 2>&1 \
     || _fail "mount failed: $mnt $MOUNT_OPTIONS"
 
 echo "godown"
-src/godown -v -f $SCRATCH_MNT >> $seqres.full
+_scratch_shutdown -v -f >> $seqres.full
 
 echo "unmount"
 _scratch_unmount
diff --git a/tests/xfs/181 b/tests/xfs/181
index 882a974b..dba69a70 100755
--- a/tests/xfs/181
+++ b/tests/xfs/181
@@ -65,7 +65,7 @@ pid=$!
 sleep 10
 
 echo "godown"
-src/godown -v -f $SCRATCH_MNT >> $seqres.full
+_scratch_shutdown -v -f >> $seqres.full
 
 # kill the multi_open_unlink
 kill $pid 2>/dev/null
@@ -83,7 +83,7 @@ _scratch_mount $mnt >>$seqres.full 2>&1 \
     || _fail "mount failed: $mnt $MOUNT_OPTIONS"
 
 echo "godown"
-src/godown -v -f $SCRATCH_MNT >> $seqres.full
+_scratch_shutdown -v -f >> $seqres.full
 
 echo "unmount"
 _scratch_unmount

