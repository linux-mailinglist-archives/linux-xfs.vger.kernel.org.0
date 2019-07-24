Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 144C173332
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 17:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfGXP4i (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 11:56:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52048 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfGXP4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 11:56:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6OFn82C038980;
        Wed, 24 Jul 2019 15:56:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=a/oqZzUmf/jcbt5gnbG5g+yEtlBLX2evki3ldhAK+24=;
 b=X6znpryCmwpXxvrGWr1Pl7+dDuATf2FR1GY1gjswmqRuONbsaM3ogvr8XBIswPIkOh2U
 eNiAnWq+/KRvRLHuJV7Wv4edogWOt/zzYYz1xQeOl2a2ftM3IKfEv2zHGIBQBVC4bl56
 zdpG9nNzghxESAYlooBX3bORb3rbDJzisPTDE2UEwzQEmdwitWmVZXCh+SV+R2Y2jr7V
 KdSz+QK+Q2i1jTypBX3HnAuJRCkCWuNLr5QqYjTZva7bw1234d8lleMn+lC7g1sYL3Jp
 0nhvMmoZlOsZz9l4e8Zu7qYoXh2+BC3du+WOhE44GXFIMzCjwlNTXgxTtyX3S8sox5YP gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tx61bxdy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 15:56:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6OFr6AR053987;
        Wed, 24 Jul 2019 15:56:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tx60y614h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 15:56:34 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6OFuWeC017959;
        Wed, 24 Jul 2019 15:56:32 GMT
Received: from localhost (/50.206.22.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jul 2019 08:56:32 -0700
Date:   Wed, 24 Jul 2019 08:56:31 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 6/3] xfs/033: filter out root inode nlink repair
Message-ID: <20190724155631.GG7084@magnolia>
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

A couple of releases ago, xfs_repair was patched to set the root inode
link count correctly when messing around with lost inodes.  However, the
old xfs_repair remains in the golden output, so remove it and filter the
line so that we don't cause 'new' regressions on old software.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/033             |   12 ++++++++++--
 tests/xfs/033.out.crc     |    2 --
 tests/xfs/033.out.default |    2 --
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/tests/xfs/033 b/tests/xfs/033
index 75b44f38..0ce67a9c 100755
--- a/tests/xfs/033
+++ b/tests/xfs/033
@@ -91,9 +91,17 @@ src/feature -P $SCRATCH_DEV && \
 	_notrun "PQuota are enabled, test needs controlled sb recovery"
 _scratch_unmount
 
+# We fixed some bugs in xfs_repair that caused us to have to reset the inode
+# link counts on the root inode twice.  That wasn't related to what this test
+# is checking, so remove the nlink reset line from the golden output and filter
+# old xfsprogs to avoid introducing new regressions.
+filter_repair() {
+	sed -e '/resetting inode INO nlinks from 1 to 2/d'
+}
+
 # rootino, rbmino, and rsumino are now set (lets blow em away!)
-_check_root_inos 0
-_check_root_inos -1 | _filter_bad_ids
+_check_root_inos 0 | filter_repair
+_check_root_inos -1 | filter_repair | _filter_bad_ids
 
 # success, all done
 status=0
diff --git a/tests/xfs/033.out.crc b/tests/xfs/033.out.crc
index 2ab4c432..594060f0 100644
--- a/tests/xfs/033.out.crc
+++ b/tests/xfs/033.out.crc
@@ -30,7 +30,6 @@ reinitializing root directory
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
 Phase 7 - verify and correct link counts...
-resetting inode INO nlinks from 1 to 2
 done
 Corrupting rt bitmap inode - setting bits to 0
 Wrote X.XXKb (value 0x0)
@@ -125,7 +124,6 @@ reinitializing root directory
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
 Phase 7 - verify and correct link counts...
-resetting inode INO nlinks from 1 to 2
 done
 Corrupting rt bitmap inode - setting bits to -1
 Wrote X.XXKb (value 0xffffffff)
diff --git a/tests/xfs/033.out.default b/tests/xfs/033.out.default
index 68bc7810..be297e5a 100644
--- a/tests/xfs/033.out.default
+++ b/tests/xfs/033.out.default
@@ -29,7 +29,6 @@ reinitializing root directory
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
 Phase 7 - verify and correct link counts...
-resetting inode INO nlinks from 1 to 2
 done
 Corrupting rt bitmap inode - setting bits to 0
 Wrote X.XXKb (value 0x0)
@@ -122,7 +121,6 @@ reinitializing root directory
         - traversal finished ...
         - moving disconnected inodes to lost+found ...
 Phase 7 - verify and correct link counts...
-resetting inode INO nlinks from 1 to 2
 done
 Corrupting rt bitmap inode - setting bits to -1
 Wrote X.XXKb (value 0xffffffff)
