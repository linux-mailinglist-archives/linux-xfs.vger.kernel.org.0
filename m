Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24F48AB159
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Sep 2019 05:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388391AbfIFDm5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Sep 2019 23:42:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41642 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388694AbfIFDm4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:42:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863gJec110705;
        Fri, 6 Sep 2019 03:42:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=+OFWqtT0bngg/JNR/NjSkLBnEs7OolpJNIGenFrZ3ck=;
 b=L33Zu4RSdBSNwesm0thpNBxZOINmq3NsZexB/HKBIcdANo/KyMUCkTv40EmNsn/IFsuR
 JMiM8waVpwSh7Sv8Bj7rv0MTa7e1r4FOEEZg+PEhWkuFhWEyAYuQM8jQmkS0O15N/Ado
 hC7kRVUgI++aPimuEf7zNmXJmRbJWBeTUJ+wOdhczjukKsXIH2wu3j9VGo1SQdPb67s8
 k/EsZifvr+wn5kSjkDtypR6uZ1yyIubEXlrRkpcGT62ABwjdTyVTdB3zWrVXjv8EENms
 WKTMKHToWjGisuUhIq19SkB75ZCBksnsgnZeHkrijvOX4EqWNB2O7Ltwuaa5pYGfWbuX Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uufsar049-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:42:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863cQmT078019;
        Fri, 6 Sep 2019 03:40:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2utvr4k224-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:40:53 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x863erYH017042;
        Fri, 6 Sep 2019 03:40:53 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:40:52 -0700
Subject: [PATCH 3/3] xfs_scrub: relabel verified data block counts in output
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:40:52 -0700
Message-ID: <156774125207.2646704.16836517557282368220.stgit@magnolia>
In-Reply-To: <156774123336.2646704.1827381294403838403.stgit@magnolia>
References: <156774123336.2646704.1827381294403838403.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Relabel the count of verified data blocks to make it more obvious that
we were only looking for file data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase7.c    |   13 ++++++++-----
 scrub/xfs_scrub.c |    2 ++
 2 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/scrub/phase7.c b/scrub/phase7.c
index 570ceb3f..2622bc45 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -116,6 +116,7 @@ xfs_scan_summary(
 	unsigned long long	f_free;
 	bool			moveon;
 	bool			complain;
+	bool			scrub_all = scrub_data > 1;
 	int			ip;
 	int			error;
 
@@ -244,14 +245,15 @@ _("%.*f%s inodes counted; %.*f%s inodes checked.\n"),
 	}
 
 	/*
-	 * Complain if the checked block counts are off, which
+	 * Complain if the data file verification block counts are off, which
 	 * implies an incomplete check.
 	 */
-	if (ctx->bytes_checked &&
+	if (scrub_data &&
 	    (verbose ||
 	     !within_range(ctx, used_data + used_rt,
 			ctx->bytes_checked, absdiff, 1, 10,
-			_("verified blocks")))) {
+			scrub_all ? _("verified blocks") :
+				    _("verified file data blocks")))) {
 		double		b1, b2;
 		char		*b1u, *b2u;
 
@@ -262,8 +264,9 @@ _("%.*f%s inodes counted; %.*f%s inodes checked.\n"),
 
 		b1 = auto_space_units(used_data + used_rt, &b1u);
 		b2 = auto_space_units(ctx->bytes_checked, &b2u);
-		fprintf(stdout,
-_("%.1f%s data counted; %.1f%s data verified.\n"),
+		fprintf(stdout, scrub_all ?
+_("%.1f%s data counted; %.1f%s disk media verified.\n") :
+_("%.1f%s data counted; %.1f%s file data media verified.\n"),
 				b1, b1u, b2, b2u);
 		fflush(stdout);
 	}
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 46876522..89f6c96a 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -432,6 +432,8 @@ run_scrub_phases(
 		/* Turn on certain phases if user said to. */
 		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data) {
 			sp->fn = xfs_scan_blocks;
+			if (scrub_data > 1)
+				sp->descr = _("Verify disk integrity.");
 		} else if (sp->fn == REPAIR_DUMMY_FN &&
 			   ctx->mode == SCRUB_MODE_REPAIR) {
 			sp->descr = _("Repair filesystem.");

