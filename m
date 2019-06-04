Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341DD35234
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 23:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfFDVtu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 17:49:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36800 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDVtu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:49:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54Lndhd060600
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=GWYDnFE03RVp43hatnjw4oNZGgYS4y4yhfqhC20MhCI=;
 b=ekS0q0AAmmMF1FlbvPaRrC6QDkNEVlMyPi1LJ7Z/ElzhzLaOWXjS0nK1mnf4/KufCGt5
 mdbKT87yXEvDY8/K6QCkl+ShtwTHAJ9VSupq2aoH8O8/tkhQakTb3i6rAe6ylfyVFWL/
 K2RxJBxmtQrS+23KEa+mSK020e/uynDdH8gR2S1ViPGbCL3m2gWqc+nktkX9HM1YSQvP
 uHGpohe1lndyiqjfFgh/6Qy/0enqrgPWa68YYEDP57IxW2fm09/t5n1S8Q6LEIvM7XHd
 HQSyg8fXK1LsEPkEOXK9rUvc3Pbia68NQRil74Yu+peU4VHFJl7EhNom9FhqTt39OVYn ZA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2suj0qfjua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:49:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LmpPG172125
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:49:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2swngkkhwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:49:48 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x54LnmW6024903
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:49:48 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 14:49:48 -0700
Subject: [PATCH 03/10] xfs: bulkstat should copy lastip whenever userspace
 supplies one
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 04 Jun 2019 14:49:47 -0700
Message-ID: <155968498711.1657646.16552958514650953190.stgit@magnolia>
In-Reply-To: <155968496814.1657646.13743491598480818627.stgit@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=904
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=936 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When userspace passes in a @lastip pointer we should copy the results
back, even if the @ocount pointer is NULL.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   |   13 ++++++-------
 fs/xfs/xfs_ioctl32.c |   13 ++++++-------
 2 files changed, 12 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d7dfc13f30f5..5ffbdcff3dba 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -768,14 +768,13 @@ xfs_ioc_bulkstat(
 	if (error)
 		return error;
 
-	if (bulkreq.ocount != NULL) {
-		if (copy_to_user(bulkreq.lastip, &inlast,
-						sizeof(xfs_ino_t)))
-			return -EFAULT;
+	if (bulkreq.lastip != NULL &&
+	    copy_to_user(bulkreq.lastip, &inlast, sizeof(xfs_ino_t)))
+		return -EFAULT;
 
-		if (copy_to_user(bulkreq.ocount, &count, sizeof(count)))
-			return -EFAULT;
-	}
+	if (bulkreq.ocount != NULL &&
+	    copy_to_user(bulkreq.ocount, &count, sizeof(count)))
+		return -EFAULT;
 
 	return 0;
 }
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 614fc6886d24..814ffe6fbab7 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -310,14 +310,13 @@ xfs_compat_ioc_bulkstat(
 	if (error)
 		return error;
 
-	if (bulkreq.ocount != NULL) {
-		if (copy_to_user(bulkreq.lastip, &inlast,
-						sizeof(xfs_ino_t)))
-			return -EFAULT;
+	if (bulkreq.lastip != NULL &&
+	    copy_to_user(bulkreq.lastip, &inlast, sizeof(xfs_ino_t)))
+		return -EFAULT;
 
-		if (copy_to_user(bulkreq.ocount, &count, sizeof(count)))
-			return -EFAULT;
-	}
+	if (bulkreq.ocount != NULL &&
+	    copy_to_user(bulkreq.ocount, &count, sizeof(count)))
+		return -EFAULT;
 
 	return 0;
 }

