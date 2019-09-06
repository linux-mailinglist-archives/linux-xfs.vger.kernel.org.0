Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 448C8AB116
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Sep 2019 05:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387624AbfIFDhJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Sep 2019 23:37:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50764 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732799AbfIFDhJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:37:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YecL110274;
        Fri, 6 Sep 2019 03:37:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=57v6OlE4fKldtseXRurmX6ES/7SqMpzP00s49qCPjm8=;
 b=IkwUUIx4UrHBlL57GR5qxBblVTeTAlwrnn3KruBJPkhGQoYF9+M2m1/f0YxOKnu83yMw
 +IFwSWGmD3GQyS60c8v6LQLFWKxvfsKFIIRIwTuJ4z6xEKOYW4Lakc2tkZOdF1GyC7Mk
 059tIiFSfPDOdJvGSzH9i3CMFOBC3psfyNOGo1h3oGe3TNMYMyb3H7sPg885GmuHJA35
 wWF1VWUBvGzo2/4RWa23pLnJS9Kmg/rKo4Cjjh/zUJZhOsx05m1KNOsbZHc2ssfnU8Ea
 eYeitzbAxAOGvANVtWxBG7nxDz1gATPUnO/WYja1MW3uZhOU2hBN5e9/UIu5h+C9nTtU CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uuf4n03b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:37:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863YPjF088664;
        Fri, 6 Sep 2019 03:37:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uu1b99s6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:37:06 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863b53M019102;
        Fri, 6 Sep 2019 03:37:05 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:37:05 -0700
Subject: [PATCH 08/13] libfrog: fix missing error checking in bitmap code
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:37:04 -0700
Message-ID: <156774102466.2644719.5744022638045647382.stgit@magnolia>
In-Reply-To: <156774097496.2644719.4441145106129821110.stgit@magnolia>
References: <156774097496.2644719.4441145106129821110.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060039
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check library calls for error codes being returned.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libfrog/bitmap.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)


diff --git a/libfrog/bitmap.c b/libfrog/bitmap.c
index be95965f..a75d085a 100644
--- a/libfrog/bitmap.c
+++ b/libfrog/bitmap.c
@@ -72,21 +72,30 @@ bitmap_alloc(
 	struct bitmap		**bmapp)
 {
 	struct bitmap		*bmap;
+	int			ret;
 
 	bmap = calloc(1, sizeof(struct bitmap));
 	if (!bmap)
 		return errno;
 	bmap->bt_tree = malloc(sizeof(struct avl64tree_desc));
 	if (!bmap->bt_tree) {
-		free(bmap);
-		return errno;
+		ret = errno;
+		goto out;
 	}
 
-	pthread_mutex_init(&bmap->bt_lock, NULL);
+	ret = pthread_mutex_init(&bmap->bt_lock, NULL);
+	if (ret)
+		goto out_tree;
+
 	avl64_init_tree(bmap->bt_tree, &bitmap_ops);
 	*bmapp = bmap;
 
 	return 0;
+out_tree:
+	free(bmap->bt_tree);
+out:
+	free(bmap);
+	return ret;
 }
 
 /* Free a bitmap. */

