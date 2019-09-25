Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42544BE765
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Sep 2019 23:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfIYVeo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Sep 2019 17:34:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37494 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727510AbfIYVeo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Sep 2019 17:34:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYeUC058203;
        Wed, 25 Sep 2019 21:34:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+Iesd87YkMxOI/J+X/jVDJxmXkXlWI+yBnYZU+NrZxo=;
 b=Vx3v673X6o//ln5UeVmFk4SVoDUxQbMORxu+8wdO/pBvWTfI8oeSwnPOYPPtaeNJSJIg
 6OV5KGh6U3cqHTf7luMtQOHOBPrrfFzMLhChZNNXBQxtoyLtHYFzhcJTundjENMv+kvT
 /T60VbPObKIjTjP8rp64DWTyC28B7vg7N/1nSbo97NcZ+M5t35bIUcC8u+Trlf1UIv/s
 Bo67bmeD4izca5Is33cIdYZDSPEvTW5A+JTZaYWA2hTO24t8Mw9ZveTA4xPuPae4Gk0v
 V1r+/z/xahyIeZa1M5U0QTcDlnSnUykU7HNiXrkn007niovvCYsxwuGdku1/HjKYMa79 NQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2v5b9tyh11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8PLYNfJ023579;
        Wed, 25 Sep 2019 21:34:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2v7vnyuntm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Sep 2019 21:34:41 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8PLYeAl020087;
        Wed, 25 Sep 2019 21:34:40 GMT
Received: from localhost (/10.145.178.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Sep 2019 14:34:40 -0700
Subject: [PATCH 12/13] xfs_scrub: move all the queue_subdir error reporting
 to callers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Sep 2019 14:34:39 -0700
Message-ID: <156944727937.297677.492739673247248919.stgit@magnolia>
In-Reply-To: <156944720314.297677.12837037497727069563.stgit@magnolia>
References: <156944720314.297677.12837037497727069563.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9391 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909250174
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Change queue_subdir to return a positive error code to callers and move
the error reporting to the callers.  This continues the process of
changing internal functions to return error codes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/vfs.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)


diff --git a/scrub/vfs.c b/scrub/vfs.c
index 49d689af..e0bc3ea4 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -72,7 +72,7 @@ dec_nr_dirs(
 }
 
 /* Queue a directory for scanning. */
-static bool
+static int
 queue_subdir(
 	struct scrub_ctx	*ctx,
 	struct scan_fs_tree	*sft,
@@ -84,14 +84,12 @@ queue_subdir(
 	int			error;
 
 	new_sftd = malloc(sizeof(struct scan_fs_tree_dir));
-	if (!new_sftd) {
-		str_errno(ctx, _("creating directory scan context"));
-		return false;
-	}
+	if (!new_sftd)
+		return errno;
 
 	new_sftd->path = strdup(path);
 	if (!new_sftd->path) {
-		str_errno(ctx, _("creating directory scan path"));
+		error = errno;
 		goto out_sftd;
 	}
 
@@ -106,12 +104,12 @@ queue_subdir(
 		goto out_path;
 	}
 
-	return true;
+	return 0;
 out_path:
 	free(new_sftd->path);
 out_sftd:
 	free(new_sftd);
-	return false;
+	return error;
 }
 
 /* Scan a directory sub tree. */
@@ -187,10 +185,13 @@ scan_fs_dir(
 		/* If directory, call ourselves recursively. */
 		if (S_ISDIR(sb.st_mode) && strcmp(".", dirent->d_name) &&
 		    strcmp("..", dirent->d_name)) {
-			sft->moveon = queue_subdir(ctx, sft, wq, newpath,
-					false);
-			if (!sft->moveon)
+			error = queue_subdir(ctx, sft, wq, newpath, false);
+			if (error) {
+				str_liberror(ctx, error,
+_("queueing subdirectory scan"));
+				sft->moveon = false;
 				break;
+			}
 		}
 	}
 
@@ -233,9 +234,11 @@ scan_fs_tree(
 		return false;
 	}
 
-	sft.moveon = queue_subdir(ctx, &sft, &wq, ctx->mntpoint, true);
-	if (!sft.moveon)
+	ret = queue_subdir(ctx, &sft, &wq, ctx->mntpoint, true);
+	if (ret) {
+		str_liberror(ctx, ret, _("queueing directory scan"));
 		goto out_wq;
+	}
 
 	/*
 	 * Wait for the wakeup to trigger, which should only happen when the

