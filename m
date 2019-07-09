Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE79263A4A
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jul 2019 19:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbfGIRtv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jul 2019 13:49:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44504 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfGIRtv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 13:49:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69HmX1V021455;
        Tue, 9 Jul 2019 17:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=OPxhHe5W8+0Fn2/hzfDM6IFNGg9KAAP8l6936U6undM=;
 b=Xft0G90jRDcN/bo8E61BZfDGuoDUZWG3ShJWSeHyFfIWmeH4wwmjXeLKIvbAKgEsh4fH
 zgNSjJGkYEK/qNr17LBvJGTtDbY5G6HAhMaVlfenJszpa5P7KTs9YfoqhUNx6r9ww51G
 KrZV6JKRhx9uG34+PZOvUqcUtUiGRM1PGVyAkDSRfIdJIS92F25PgMZUoT+ieBwghiJM
 vaikCxpVQ8mJxERnwnf0PXtSpb8hMqFXWgrakkktadMDkq1pOvIYMfnX4DG0FOoP5QE+
 DYKwpwavdbbKT+GrTzl7x0nFKJKQHSqUNwQlYA8dzm2aBrsigSwUVy7VRUvLataolxlW Dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tjkkpnsv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 17:49:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69Hm2JF069556;
        Tue, 9 Jul 2019 17:49:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tmmh33pfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 17:49:48 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x69HnmJg004447;
        Tue, 9 Jul 2019 17:49:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 10:49:48 -0700
Subject: [PATCH 2/3] xfs/016: calculate minimum log size and end locations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 09 Jul 2019 10:49:47 -0700
Message-ID: <156269458726.3039184.17039026702574378051.stgit@magnolia>
In-Reply-To: <156269457497.3039184.4886490143800432410.stgit@magnolia>
References: <156269457497.3039184.4886490143800432410.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907090210
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907090210
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs/016 looks for corruption in the log when the log wraps.  However,
it hardcodes the minimum log size and the "95%" point where it wants to
start the "nudge and check for corruption" part of the test.  New
features require larger logs, which causes the test to fail when it
can't mkfs with the smaller log size and when that 95% point doesn't put
us within 20x "_log_traffic 2"s of the end of the log.

Fix the first problem by using the new min log size helper and replace
the 95% figure with an estimate of where we need to be to guarantee that
the 20x loop wraps the log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/016     |   66 +++++++++++++++++++++++++++++++++++++++++++----------
 tests/xfs/016.out |    1 +
 2 files changed, 54 insertions(+), 13 deletions(-)


diff --git a/tests/xfs/016 b/tests/xfs/016
index 3407a4b1..2b41127e 100755
--- a/tests/xfs/016
+++ b/tests/xfs/016
@@ -44,10 +44,21 @@ _block_filter()
 
 _init()
 {
+    echo "*** determine log size"
+    local sz_mb=50
+    local dsize="-d size=${sz_mb}m"
+    local lsize="-l size=$(_scratch_find_xfs_min_logblocks $dsize)b"
+    local force_opts="$dsize $lsize"
+    _scratch_mkfs_xfs $force_opts >> $seqres.full 2>&1
+
+    # set log_size and log_size_bb globally
+    log_size_bb=`_log_size`
+    log_size=$((log_size_bb * 512))
+    echo "log_size_bb = $log_size_bb log_size = $log_size" >> $seqres.full
+
     echo "*** reset partition"
-    $here/src/devzero -b 2048 -n 50 -v 198 $SCRATCH_DEV
+    $here/src/devzero -b 2048 -n $sz_mb -v 198 $SCRATCH_DEV # write 0xc6
     echo "*** mkfs"
-    force_opts="-dsize=50m -lsize=$log_size"
     #
     # Do not discard blocks as we check for patterns in free space.
     # 
@@ -65,6 +76,9 @@ _init()
     . $tmp.mkfs
     [ $logsunit -ne 0 ] && \
         _notrun "Cannot run this test using log MKFS_OPTIONS specified"
+
+    # quotas generate extra log traffic so force it off
+    _qmount_option noquota
 }
 
 _log_traffic()
@@ -157,6 +171,7 @@ _check_corrupt()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/quota
 
 # real QA test starts here
 _supported_fs xfs
@@ -164,10 +179,6 @@ _supported_os Linux
 
 rm -f $seqres.full
 
-# mkfs sizes
-log_size=3493888
-log_size_bb=`expr $log_size / 512`
-
 _require_scratch
 _init
 
@@ -188,18 +199,30 @@ echo "log sunit = $lsunit"			>>$seqres.full
 [ $head -eq 2 -o $head -eq $((lsunit/512)) ] || \
     _fail "!!! unexpected initial log position $head vs. $((lsunit/512))"
 
-# find how how many blocks per op for 100 ops
-# ignore the fact that it will also include an unmount record etc...
-# this should be small overall
+# Step 1: Run 200 ops to estimate how how many log blocks are used for each op.
+# Ignore the fact that it will also include an unmount record; this should be
+# small overall.
 echo "    lots of traffic for sampling" >>$seqres.full
-sample_size_ops=100
+sample_size_ops=200
 _log_traffic $sample_size_ops
 head1=`_log_head`
 num_blocks=`expr $head1 - $head`
 blocks_per_op=`echo "scale=3; $num_blocks / $sample_size_ops" | bc`
+echo "log position = $head1; old log position: $head" >> $seqres.full
 echo "blocks_per_op = $blocks_per_op" >>$seqres.full
-num_expected_ops=`echo "$log_size_bb / $blocks_per_op" | bc`
+
+# Step 2: Quickly advance the log from wherever step 1 left us to the point
+# where the log is now 80% full on its first cycle.
+
+# Estimate the number of ops needed to get the log head close to but not past
+# near_end_min for a single mount.  We'd rather fall short and have to step our
+# way closer to the end than run past the end, so our target for this second
+# step is to fill 80% of the first cycle of the log.
+num_expected_ops=$(( 8 * $(echo "$log_size_bb / $blocks_per_op" | bc) / 10))
 echo "num_expected_ops = $num_expected_ops" >>$seqres.full
+
+# Compute the number of ops needed to get from wherever we are right now in
+# the log cycle to the 80% point.
 num_expected_to_go=`echo "$num_expected_ops - $sample_size_ops" | bc`
 echo "num_expected_to_go = $num_expected_to_go" >>$seqres.full
 
@@ -208,13 +231,30 @@ _log_traffic $num_expected_to_go
 head=`_log_head`
 echo "log position = $head"                     >>$seqres.full
 
-# e.g. 3891
-near_end_min=`echo "0.95 * $log_size_bb" | bc | sed 's/\..*//'`
+# Step 3: Gradually advance log traffic to get us from wherever step 2 left us
+# to the point where the log is within approximately 20 ops of wrapping into
+# the second cycle.
+
+# Since this is a log wrapping test, it's critical to push the log head to the
+# point where it will wrap around within twenty rounds of ops.  Compute the
+# expected value of the log head when we get to this point.  This "/ 1" piece
+# tricks bc into printing integer numbers.
+near_end_min=$(echo "$log_size_bb - (20 * $blocks_per_op / 1)" | bc)
 echo "near_end_min = $near_end_min" >>$seqres.full
 
+# Step us (in batches of 10 ops) to our goal.
+while [ $head -lt $near_end_min ]; do
+	echo "    bump traffic from $head towards $near_end_min" >> $seqres.full
+	_log_traffic 10 > /dev/null 2>&1
+	head=$(_log_head)
+done
+
 [ $head -gt $near_end_min -a $head -lt $log_size_bb ] || \
     _fail "!!! unexpected near end log position $head"
 
+# Step 4: Try to wrap the log, checking for corruption with each advance.
+# This is the functionality that we're actually trying to test.  We will try
+# 40 ops (in batches of 2) to try to wrap the log.
 for c in `seq 0 20`
 do
     echo "   little traffic"            >>$seqres.full
diff --git a/tests/xfs/016.out b/tests/xfs/016.out
index f7844cdf..f4c8f88d 100644
--- a/tests/xfs/016.out
+++ b/tests/xfs/016.out
@@ -1,4 +1,5 @@
 QA output created by 016
+*** determine log size
 *** reset partition
 Wrote 51200.00Kb (value 0xc6)
 *** mkfs

