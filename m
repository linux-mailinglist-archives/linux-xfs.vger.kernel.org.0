Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2088EF31
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Aug 2019 17:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfHOPTF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Aug 2019 11:19:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52860 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfHOPTF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 11:19:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FF3jJb111426;
        Thu, 15 Aug 2019 15:19:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Lzd7vj/D2lRRjH0paw5QJ3I0kaTQKScSRAJbCPvWc/4=;
 b=Q5aw4ZH4vwl47WI78KMFORIia9eaTlBAs4+6CHQJSP8cniHWER/mtpRF7omXZYpcpDmP
 OzGYy/IcRtzsYJGUDu+Fs1zXSTT20vujYQcUXYCIWggINXYF9K5loYKvRkmDsH5N5zmZ
 S3A11tLHc4YLGkLBShORMbdbH+SxZwQrd1yTaMghIfLrPRxnekMSulqNUwY8obNKlJBE
 JP+DuCMmjPhFFIGIoLRFA+AbjyXpYlKaiWz8K+UI3LxWdKMkL26saDlAo79fzCfWdXHC
 8iFWTK8KFcBmtwJJ8e8b/8dSTYh6CnM70KB+oEXDa0bfHrqx9rUFRBfEk+PRZehZHpkh kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u9nbtub1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 15:19:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FFI3DK156368;
        Thu, 15 Aug 2019 15:19:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ucmwjsq2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 15:19:02 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7FFJ1Au014502;
        Thu, 15 Aug 2019 15:19:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 08:19:01 -0700
Subject: [PATCH 1/3] generic/081: fix lvm config not being cleaned up
 properly
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 15 Aug 2019 08:18:59 -0700
Message-ID: <156588233944.24775.714828611169800436.stgit@magnolia>
In-Reply-To: <156588233330.24775.15183725500886844319.stgit@magnolia>
References: <156588233330.24775.15183725500886844319.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908150152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix a race between _cleanup and dmeventd that causes the lvm
configuration not to be cleaned up and subsequent tests to fail.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/081 |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)


diff --git a/tests/generic/081 b/tests/generic/081
index 10f4a186..e8f4f5b5 100755
--- a/tests/generic/081
+++ b/tests/generic/081
@@ -19,12 +19,29 @@ _cleanup()
 {
 	cd /
 	rm -f $tmp.*
-	# lvm may have umounted it on I/O error, but in case it does not
-	# wait a bit for lvm to settle, sigh..
-	sleep 2
-	$UMOUNT_PROG $mnt >/dev/null 2>&1
-	$LVM_PROG vgremove -f $vgname >>$seqres.full 2>&1
-	$LVM_PROG pvremove -f $SCRATCH_DEV >>$seqres.full 2>&1
+
+	# Tear down the lvm vg and snapshot.
+	#
+	# NOTE: We do the unmount and {vg,pv}remove in a loop here because
+	# dmeventd could be configured to unmount the filesystem automatically
+	# after the IO errors.  That is racy with the umount we're trying to do
+	# here because there's a window in which the directory tree has been
+	# removed from the mount namespaces (so the umount call here sees no
+	# mount and exits) but the filesystem hasn't yet released the block
+	# device, which causes the vgremove here to fail.
+	#
+	# We "solve" the race by repeating the umount/lvm teardown until the
+	# block device goes away, because we cannot exit this test without
+	# removing the lvm devices from the scratch device -- this will cause
+	# other tests to fail.
+	while test -e /dev/mapper/$vgname-$snapname || \
+	      test -e /dev/mapper/$vgname-$lvname; do
+		$UMOUNT_PROG $mnt >> $seqres.full 2>&1
+		$LVM_PROG vgremove -f $vgname >>$seqres.full 2>&1
+		$LVM_PROG pvremove -f $SCRATCH_DEV >>$seqres.full 2>&1
+		test $? -eq 0 && break
+		sleep 2
+	done
 }
 
 # get standard environment, filters and checks

