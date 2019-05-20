Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71BE624405
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfETXRr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:17:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38744 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfETXRq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:17:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNER6H149957;
        Mon, 20 May 2019 23:17:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=suHoFf87nkSELQARrszGrrHCfAPho90ddWTyD+qVcic=;
 b=Cmtkd+9JD4kddiYidk37HA/M3ybfs8f4ybM/y5HxciMem4a0jsL/fePr9VtCON9GSJe4
 +LwLftodPmFgnK7nJ0wpbJhys7S6BYlLXmv4DKxzbAjnq0stunY4FSTb+bLqFQLOq6v0
 iaql5H+f7C4jG1tGQlDUoknVLAzQwMRM7CStyWCiB5VfC6kaHzYSEng93q2zm9VCSWdz
 mfcXniUpIgnTTBLWd8FNvmFQZkIwQXmm6KlfD34QnY0in7cuFxuzUj+j/MUMzlXeWBrm
 Jx4BnoiyUW6HZGR1t2oQUnq9F11yzeGVT44xtVX9uA6I2EIp/+6mZwMl/bp+l2MJVb+h eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2sjapq9uc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:17:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNHfbO077783;
        Mon, 20 May 2019 23:17:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2skudb28ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:17:44 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4KNHhwT008149;
        Mon, 20 May 2019 23:17:43 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 23:17:43 +0000
Subject: [PATCH 09/12] xfs_scrub: fix background-mode sleep throttling
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 May 2019 16:17:37 -0700
Message-ID: <155839425742.68606.18377767804648563349.stgit@magnolia>
In-Reply-To: <155839420081.68606.4573219764134939943.stgit@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=991
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200143
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The comment preceding background_sleep() is wrong -- the function sleeps
100us, not 100ms, for every '-b' passed in after the first one.  This is
really not obvious from the magic numbers, so fix the comment and use
symbolic constants for easier reading.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/common.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)


diff --git a/scrub/common.c b/scrub/common.c
index c877c7c8..1cd2b7ba 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -253,21 +253,23 @@ scrub_nproc_workqueue(
 }
 
 /*
- * Sleep for 100ms * however many -b we got past the initial one.
+ * Sleep for 100us * however many -b we got past the initial one.
  * This is an (albeit clumsy) way to throttle scrub activity.
  */
+#define NSEC_PER_SEC	1000000000ULL
+#define NSEC_PER_USEC	1000ULL
 void
 background_sleep(void)
 {
-	unsigned long long	time;
+	unsigned long long	time_ns;
 	struct timespec		tv;
 
 	if (bg_mode < 2)
 		return;
 
-	time = 100000ULL * (bg_mode - 1);
-	tv.tv_sec = time / 1000000;
-	tv.tv_nsec = time % 1000000;
+	time_ns =  100 * NSEC_PER_USEC * (bg_mode - 1);
+	tv.tv_sec = time_ns / NSEC_PER_SEC;
+	tv.tv_nsec = time_ns % NSEC_PER_SEC;
 	nanosleep(&tv, NULL);
 }
 

