Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023471B34DF
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Apr 2020 04:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgDVCKD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 Apr 2020 22:10:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44538 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgDVCKD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:10:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M29FkM121720
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:10:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tlkxcsdbzMzROYiwlXh3gTddZjOPogN/a08QTXGLtZ8=;
 b=DR6B1wfHGSJRP494YEDCEx1J5tYelnvSH16dA9ux4LbWkkz9yonw7aQ7FwLn2m9PuCw6
 qJ2yZmCe7apihRmGg4Zcpg5/+4FEag+jA7ey/ugvoMfvCaw7dNuhnD0jVbYXYm6JVfaA
 iAstobuXEld3Euo/Xmp1eWfb1FD8JyRsSTp2HNvm+saQDp+dl6B2HoX5QqHUTrnK42cv
 JjHOoqeN777+Ai0xE6+pO0S4/mGl5C/5+O6bTgVU+T/N3xPSBByzgPicROXqOQ0CXE6d
 GrpWSqlEPBqzp1q69sEYTX2B4NCSgweqyjYpZqTxX/Qq9ZdNYvOwB46yAYmwRCXZbIsI 4w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30fsgm03p2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:10:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M22X4K053781
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30gbbfgh8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:01 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03M280NL015598
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:08:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:08:00 -0700
Subject: [PATCH 18/19] xfs: remove xlog_item_is_intent
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:07:58 -0700
Message-ID: <158752127891.2140829.17487418709645913944.stgit@magnolia>
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=1 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=1 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've parameterized all of the log intent types, get rid of
this redundant predicate.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log_recover.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 51a7d4b963cd..250f04419035 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2653,20 +2653,6 @@ xlog_recover_process_data(
 	return 0;
 }
 
-/* Is this log item a deferred action intent? */
-static inline bool xlog_item_is_intent(struct xfs_log_item *lip)
-{
-	switch (lip->li_type) {
-	case XFS_LI_EFI:
-	case XFS_LI_RUI:
-	case XFS_LI_CUI:
-	case XFS_LI_BUI:
-		return true;
-	default:
-		return false;
-	}
-}
-
 /* Take all the collected deferred ops and finish them in order. */
 static int
 xlog_finish_defer_ops(
@@ -2760,7 +2746,7 @@ xlog_recover_process_intents(
 		if (!type) {
 #ifdef DEBUG
 			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
-				ASSERT(!xlog_item_is_intent(lip));
+				ASSERT(!xlog_intent_for_type(lip->li_type));
 #endif
 			break;
 		}
@@ -2819,7 +2805,7 @@ xlog_recover_cancel_intents(
 		if (!type) {
 #ifdef DEBUG
 			for (; lip; lip = xfs_trans_ail_cursor_next(ailp, &cur))
-				ASSERT(!xlog_item_is_intent(lip));
+				ASSERT(!xlog_intent_for_type(lip->li_type));
 #endif
 			break;
 		}

