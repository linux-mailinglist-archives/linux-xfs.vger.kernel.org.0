Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50399725BC
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 06:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfGXENV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 00:13:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44116 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfGXENV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 00:13:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O49VQJ119871;
        Wed, 24 Jul 2019 04:13:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=zqraTmXXEHnTmZbvkylDgetuQ2M0MS+oQE5hDFC/6qM=;
 b=2aMHHJurMzliKikSnow52XHepD++XyQU46norZefsMwyzoXW+hNunW1WyNnhM3iW1//3
 t9eC69VW7ROjLL5EBNvkc0Dv+tRbU7nz2NaOLW+FRPPgLFZEaU4kPrYJ5QfZElxBKz5e
 iSWyiXrWMDcrHIaYh6lplLH96U4/i332cKEAVZAVkzOjgIBoPnPN7Cd8y3fTyIg2L0u6
 PkDvV1brG1vECqaCvh0CrKOfgpOZiKX9RLGP33Ma6ESPgvBa/7iog6Y7rqFJBwhZrCAi
 tMiLCie52mA45qjEuqJp2p5B01UJHSlpXgx4VPwy/s6KSGrel8/vYgpC8sysS5OBRXn1 ZA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tx61btjt4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 04:13:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O4DIGR119938;
        Wed, 24 Jul 2019 04:13:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2tx60xn9k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 04:13:18 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6O4DDpe012973;
        Wed, 24 Jul 2019 04:13:13 GMT
Received: from localhost (/50.206.22.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jul 2019 21:13:13 -0700
Subject: [PATCH 3/3] generic/561: kill duperemove after sleep_time
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 23 Jul 2019 21:13:06 -0700
Message-ID: <156394158687.1850719.7335587409056156645.stgit@magnolia>
In-Reply-To: <156394156831.1850719.2997473679130010771.stgit@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=942
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907240046
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=987 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907240045
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

generic/561 can take a very long time to run on XFS (45+ minutes)
because it kicks off fsstress and a lot of duperemove processes, waits
50 seconds, and then waits for the duperemove processes to finish.
duperemove, however, fights with fsstress for file locks and can take
a very long time to make even a single pass over the filesystem and
exit, which means the test just takes forever to run.

Once we've decided to tear down the duperemove processes let's just send
them SIGINT and then wait for them to exit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/561 |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tests/generic/561 b/tests/generic/561
index c11d5bfa..2f3eff3c 100755
--- a/tests/generic/561
+++ b/tests/generic/561
@@ -47,6 +47,7 @@ function end_test()
 	# stop duperemove running
 	if [ -e $dupe_run ]; then
 		rm -f $dupe_run
+		kill -INT $dedup_pids
 		wait $dedup_pids
 	fi
 

