Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F3F8EF38
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Aug 2019 17:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbfHOPVL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Aug 2019 11:21:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55858 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728728AbfHOPVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Aug 2019 11:21:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FFJNnp125197;
        Thu, 15 Aug 2019 15:21:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=N8jHNBN/gLdtrVaGon92+1hJJ//nddUZJmWZ1OP5xnk=;
 b=fY/yJhPH+SntOS1Ycrlu9km3o5aHsk6wx3e47vJx2SioElNYaeqD7dpIG2TP2clZA6eZ
 ptT8tYfA8/yXEhmQVxdJG4zBHS2Cug4LBZShZWauMBdJv2ravgv6JMhO9OrHXDvVCA/J
 sSufbV8Dn3bF0/3Xq7il/bWTi9ycYL7I+bHqOkkITTHBiKUwMqfUl+ZC95WN5aUprWHB
 Iu63f5xFwxOA9PkehtxaPI9C7wa/RPvzL+z+u+t70EGun4M7OVVr6uMsvCoJiSkeS0UY
 Cuay46e9NNlE5ihn9/3a2krOOmM2Bxh+rfp7ueJXJruR+H5LJgc5yhWiD+dTXztz+bTJ 0g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u9nbtubcv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 15:21:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FFI6UY156709;
        Thu, 15 Aug 2019 15:19:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ucmwjsq5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 15:19:08 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7FFJ7O7011812;
        Thu, 15 Aug 2019 15:19:07 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 08:19:07 -0700
Subject: [PATCH 2/3] generic/561: kill duperemove directly
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Thu, 15 Aug 2019 08:19:06 -0700
Message-ID: <156588234658.24775.14952503026602339377.stgit@magnolia>
In-Reply-To: <156588233330.24775.15183725500886844319.stgit@magnolia>
References: <156588233330.24775.15183725500886844319.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=831
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908150152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=881 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150152
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

While the kill statement added in the previous patch usually suffices to
shut down the bash loop that runs the duperemove processes, for whatever
reason this sometimes fails to kill duperemove.  Kill the duperemove
processes directly after removing the run file, which should cause the
bash loop to exit immediately.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/561 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/generic/561 b/tests/generic/561
index 2f3eff3c..26ecff5d 100755
--- a/tests/generic/561
+++ b/tests/generic/561
@@ -47,7 +47,7 @@ function end_test()
 	# stop duperemove running
 	if [ -e $dupe_run ]; then
 		rm -f $dupe_run
-		kill -INT $dedup_pids
+		$KILLALL_PROG -q $DUPEREMOVE_PROG > /dev/null 2>&1
 		wait $dedup_pids
 	fi
 
@@ -74,7 +74,7 @@ for ((i = 0; i < $((2 * LOAD_FACTOR)); i++)); do
 	while [ -e $dupe_run ]; do
 		$DUPEREMOVE_PROG -dr --dedupe-options=same $testdir \
 			>>$seqres.full 2>&1
-	done &
+	done 2>&1 | sed -e '/Terminated/d' &
 	dedup_pids="$! $dedup_pids"
 done
 

