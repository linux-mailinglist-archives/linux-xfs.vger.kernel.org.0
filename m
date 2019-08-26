Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D79459D840
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Aug 2019 23:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbfHZV3v (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Aug 2019 17:29:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33332 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728431AbfHZV3v (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:29:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLDmf9000868;
        Mon, 26 Aug 2019 21:29:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=GHSZVRzUNO1CE1KZ+4FEocZs93YANVSeKXtaye6xAkg=;
 b=aLcwym48Ez1lkniTVMr6cNVtlB3yDdsAnoLM6x45fxgz2Q/ZHWWNTmT6PbNuAdz4IuAG
 DRJkVhBE73LoyhPtlQ/zQyqk6yCkZbaAxzfDiMU64g5meqMqsQRSuFqA9cPnXG/DJn/d
 S1jefsuHowyYAWnA8OoDa3sGFNkZKUChdonk9NGEhG2UKBmH+5wXTclWxAXo7yncFJiQ
 qQ/cACW3HLzw1SuZqOs5czBHwPRMbps6tan8GKTFEEgNCut0Ga+6LHQ0vjBzHS0Dl9OK
 ZeNlYlGX0H2RuSSPqAAZcSKm5oOJB7Vh16WNIubMTfj6l7iODYru1nif+gFBaepvSxlC lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2umpxx05d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLIKGc170013;
        Mon, 26 Aug 2019 21:29:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2umj278790-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Aug 2019 21:29:48 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7QLTmrP028842;
        Mon, 26 Aug 2019 21:29:48 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:29:47 -0700
Subject: [PATCH 13/13] xfs_scrub: fix error handling problems in vfs.c
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:29:47 -0700
Message-ID: <156685498699.2841546.6920189234126030387.stgit@magnolia>
In-Reply-To: <156685489821.2841546.10616502094098044568.stgit@magnolia>
References: <156685489821.2841546.10616502094098044568.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix all the places where we drop or screw up error handling in
scan_fs_tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/vfs.c |   34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)


diff --git a/scrub/vfs.c b/scrub/vfs.c
index 7053dbd6..8bb49eeb 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -215,6 +215,7 @@ scan_fs_tree(
 {
 	struct workqueue	wq;
 	struct scan_fs_tree	sft;
+	bool			moveon = false;
 	int			ret;
 
 	sft.moveon = true;
@@ -223,14 +224,22 @@ scan_fs_tree(
 	sft.dir_fn = dir_fn;
 	sft.dirent_fn = dirent_fn;
 	sft.arg = arg;
-	pthread_mutex_init(&sft.lock, NULL);
-	pthread_cond_init(&sft.wakeup, NULL);
+	ret = pthread_mutex_init(&sft.lock, NULL);
+	if (ret) {
+		str_liberror(ctx, ret, _("creating directory scan lock"));
+		return false;
+	}
+	ret = pthread_cond_init(&sft.wakeup, NULL);
+	if (ret) {
+		str_liberror(ctx, ret, _("creating directory scan signal"));
+		goto out_mutex;
+	}
 
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
-		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
-		return false;
+		str_liberror(ctx, ret, _("creating directory scan workqueue"));
+		goto out_cond;
 	}
 
 	ret = queue_subdir(ctx, &sft, &wq, ctx->mntpoint, true);
@@ -239,7 +248,12 @@ scan_fs_tree(
 		goto out_wq;
 	}
 
-	pthread_mutex_lock(&sft.lock);
+	ret = pthread_mutex_lock(&sft.lock);
+	if (ret) {
+		str_liberror(ctx, ret, _("locking directory scan lock"));
+		goto out_wq;
+	}
+
 	if (sft.nr_dirs)
 		pthread_cond_wait(&sft.wakeup, &sft.lock);
 	assert(sft.nr_dirs == 0);
@@ -247,12 +261,18 @@ scan_fs_tree(
 
 	ret = workqueue_terminate(&wq);
 	if (ret) {
-		sft.moveon = false;
 		str_liberror(ctx, ret, _("finishing directory scan work"));
+		goto out_wq;
 	}
+
+	moveon = sft.moveon;
 out_wq:
 	workqueue_destroy(&wq);
-	return sft.moveon;
+out_cond:
+	pthread_cond_destroy(&sft.wakeup);
+out_mutex:
+	pthread_mutex_destroy(&sft.lock);
+	return moveon;
 }
 
 #ifndef FITRIM

