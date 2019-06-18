Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A484ACF2
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 23:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731118AbfFRVH1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 17:07:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34902 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730794AbfFRVH1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 17:07:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IL4Epu034895;
        Tue, 18 Jun 2019 21:07:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=PgQv0Bxuz8ap1iForh/dPXBQ3mVwr7eIIWVPaZY0VdQ=;
 b=W2/dlHuEwTyylv6w8DW3Id4KYszh+azeRJ+B0sWpGuGnEm9cEWf4u1FVVTQ3gYwvZpCq
 nz7ZQNcyMeo0AGdJJqqUsrJPBtau3ODgO0SMaoU7nk6/wOkbKbdaTMGiJrBo/bmRKQ8a
 vTqeSedjkXxyfXmppUxtBugEoT09HKqlCJ2yuwx5CpXLTHJxziKl9kUU7N6rWjoMvGVN
 ppkA0d5oWgj5BRtmdNMLBdL/nM1vb0gZROQe3YFO5SCr7tIzaBOKxJCOYp7wU9QGpufo
 vJm3xxiXdmnrvOxzBkin0TrgrGyTs3dLdmkety4mjX4uS0ECwpYk0vdJc6s9fdlUBPrS Og== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2t4r3tpuvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 21:07:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IL7CeF000768;
        Tue, 18 Jun 2019 21:07:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2t5cpe9q5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 21:07:23 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5IL7Mv6023083;
        Tue, 18 Jun 2019 21:07:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 14:07:22 -0700
Subject: [PATCH 3/4] xfs/016: calculate minimum log size and end locations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 18 Jun 2019 14:07:21 -0700
Message-ID: <156089204146.345809.516891823391869532.stgit@magnolia>
In-Reply-To: <156089201978.345809.17444450351199726553.stgit@magnolia>
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180167
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
 tests/xfs/016     |   50 ++++++++++++++++++++++++++++++++++++++------------
 tests/xfs/016.out |    1 +
 2 files changed, 39 insertions(+), 12 deletions(-)


diff --git a/tests/xfs/016 b/tests/xfs/016
index 3407a4b1..aed37dca 100755
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
 
@@ -188,18 +199,29 @@ echo "log sunit = $lsunit"			>>$seqres.full
 [ $head -eq 2 -o $head -eq $((lsunit/512)) ] || \
     _fail "!!! unexpected initial log position $head vs. $((lsunit/512))"
 
-# find how how many blocks per op for 100 ops
+# find how how many blocks per op for 200 ops
 # ignore the fact that it will also include an unmount record etc...
 # this should be small overall
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
+# Since this is a log wrapping test, it's critical to push the log head to
+# the point where it will wrap around within twenty rounds of log traffic.
+near_end_min=$(echo "$log_size_bb - (10 * $blocks_per_op / 1)" | bc)
+echo "near_end_min = $near_end_min" >>$seqres.full
+
+# Estimate the number of ops needed to get the log head close to but not past
+# near_end_min.  We'd rather fall short and have to step our way closer to the
+# end than run past the end.
+num_expected_ops=$(( 8 * $(echo "$log_size_bb / $blocks_per_op" | bc) / 10))
 echo "num_expected_ops = $num_expected_ops" >>$seqres.full
+
 num_expected_to_go=`echo "$num_expected_ops - $sample_size_ops" | bc`
 echo "num_expected_to_go = $num_expected_to_go" >>$seqres.full
 
@@ -208,13 +230,17 @@ _log_traffic $num_expected_to_go
 head=`_log_head`
 echo "log position = $head"                     >>$seqres.full
 
-# e.g. 3891
-near_end_min=`echo "0.95 * $log_size_bb" | bc | sed 's/\..*//'`
-echo "near_end_min = $near_end_min" >>$seqres.full
+# If we fell short of near_end_min, step our way towards it.
+while [ $head -lt $near_end_min ]; do
+	echo "    bump traffic from $head towards $near_end_min" >> $seqres.full
+	_log_traffic 10 > /dev/null 2>&1
+	head=$(_log_head)
+done
 
 [ $head -gt $near_end_min -a $head -lt $log_size_bb ] || \
     _fail "!!! unexpected near end log position $head"
 
+# Try to wrap the log, checking for corruption with each advance.
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

