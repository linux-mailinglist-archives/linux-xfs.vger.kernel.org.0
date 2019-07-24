Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E5873330
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 17:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfGXP4R (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 11:56:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41012 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGXP4R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 11:56:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6OFnACV149988;
        Wed, 24 Jul 2019 15:56:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=a8O9hlf+hW6/rtEFQ1VPhQMJaK6X/g/S1Gs6akuO1uo=;
 b=qG1/20/ymt5G8pI2MiK4sWR/rLw6M5f241f7ngC7cfbyY69VOsorSvrZn2TGK711Le4q
 BGbilud1F6C/iERS5erXlmRbQ4pY0YVSZwwJOK90gUMRiFntjQMBQsGAnhi165zSisfb
 7ADk5BTj7vDN/EI6l4nPSHndxbprn+Y0VpaPCU6yuaNvITzQ7OKfyFUd5JokUDs+33+4
 kHgXIC7USOw3mReI3WIyxt7pZR9M8IxzDzxgkt501PnaWo31PrAo8cpfBinkUj33YtDy
 IApL2XZG7G9o1oMs0m/BgE3Wm/GuVWiCPcE/uA5KcCt7tBsMKZjStaJF9FcFmmwErYhh 2A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2tx61bxdpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 15:56:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6OFr4u7139037;
        Wed, 24 Jul 2019 15:56:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tx60xt8tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 15:56:13 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6OFuCMd003863;
        Wed, 24 Jul 2019 15:56:12 GMT
Received: from localhost (/50.206.22.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jul 2019 08:56:12 -0700
Date:   Wed, 24 Jul 2019 08:56:10 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 5/3] various: disable quotas before running test
Message-ID: <20190724155610.GF7084@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394156831.1850719.2997473679130010771.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907240172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907240172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

For all the tests which require that quotas be disabled, remove the
quota mount options before mounting the scratch filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/384 |    4 ++--
 tests/xfs/030     |    2 ++
 tests/xfs/033     |    2 ++
 tests/xfs/065     |    2 ++
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tests/generic/384 b/tests/generic/384
index b7c940d7..33098a38 100755
--- a/tests/generic/384
+++ b/tests/generic/384
@@ -37,8 +37,8 @@ _require_quota
 _require_xfs_quota_foreign
 _require_xfs_io_command "chproj"
 
-# we can't run with group quotas
-_exclude_scratch_mount_option "gquota" "grpquota"
+# we can't run with group quotas (on v4 xfs); the mount options for group
+# quotas will be filtered out by _qmount_option below.
 
 dir=$SCRATCH_MNT/project
 
diff --git a/tests/xfs/030 b/tests/xfs/030
index 5ed99628..10854c8a 100755
--- a/tests/xfs/030
+++ b/tests/xfs/030
@@ -28,6 +28,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common/rc
 . ./common/filter
 . ./common/repair
+. ./common/quota
 
 # nuke the superblock, AGI, AGF, AGFL; then try repair the damage
 #
@@ -65,6 +66,7 @@ if [ $? -ne 0 ]		# probably don't have a big enough scratch
 then
 	_notrun "SCRATCH_DEV too small, results would be non-deterministic"
 else
+	_qmount_option noquota
 	_scratch_mount
 	src/feature -U $SCRATCH_DEV && \
 		_notrun "UQuota are enabled, test needs controlled sb recovery"
diff --git a/tests/xfs/033 b/tests/xfs/033
index 5af0aefc..75b44f38 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -28,6 +28,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common/rc
 . ./common/filter
 . ./common/repair
+. ./common/quota
 
 # nuke the root, rt bitmap, and rt summary inodes
 # 
@@ -80,6 +81,7 @@ _link_out_file_named $seqfull.out "$FEATURES"
 	sed -e 's/ //g' -e 's/^/export /'`
 
 # check we won't get any quota inodes setup on mount
+_qmount_option noquota
 _scratch_mount
 src/feature -U $SCRATCH_DEV && \
 	_notrun "UQuota are enabled, test needs controlled sb recovery"
diff --git a/tests/xfs/065 b/tests/xfs/065
index f09bd947..b1533666 100755
--- a/tests/xfs/065
+++ b/tests/xfs/065
@@ -29,6 +29,7 @@ _cleanup()
 . ./common/rc
 . ./common/filter
 . ./common/dump
+. ./common/quota
 
 #
 # list recursively the directory
@@ -57,6 +58,7 @@ _require_scratch
 # so don't run it
 #
 _scratch_mkfs_xfs >> $seqres.full
+_qmount_option noquota
 _scratch_mount
 $here/src/feature -U $SCRATCH_DEV && \
 	_notrun "UQuota enabled, test needs controlled xfsdump output"
