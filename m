Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3938A253B16
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Aug 2020 02:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgH0AbR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 26 Aug 2020 20:31:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38846 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgH0AbR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:31:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0U0Ws165561
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:31:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=S6aNBUz3Fszfbtv01QuNGGU1bzWYIPWn4oHQPYwBAc4=;
 b=NOBetaATOrfRkDZ+X4b8OMWwptpZJNCjOx3jh+CGL1tSeBL1fXuxODi5nk7CJTbwik9G
 cOYi1K+B8QDyTKEz9qIBlKLko9LwCJLiimAN4xQvb+9TEfTg3ydHQrng5lzt9TiprjFN
 pZhXBZJXMVj7z9KQts6eg4Bb/8IJeaSfsbUdECvCybqNrTi44dyll8EtDlmk7BKUTn3e
 njzk/hsBIhh394Dk6Uj18ti9L7EJ2TlVILYdrEzMVJJu464MUeazPKlHlKvOuguw1FOT
 Xqe9EkXcRkm8ih7Itl2l8Q08FiHDd1pWR9XGlo1jOfACmiNNERb5MGeI9MqYpq6bWPHD FQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 333w6u201r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:31:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0BNVP038170
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:15 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 333r9mk53c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:15 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07R0TExJ019005
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:14 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:29:14 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 16/32] xfsprogs: Add helper function xfs_attr_leaf_mark_incomplete
Date:   Wed, 26 Aug 2020 17:28:40 -0700
Message-Id: <20200827002856.1131-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827002856.1131-1-allison.henderson@oracle.com>
References: <20200827002856.1131-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=1 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch helps to simplify xfs_attr_node_removename by modularizing
the code around the transactions into helper functions.  This will make
the function easier to follow when we introduce delayed attributes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 07c0614..11fc469 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1138,6 +1138,32 @@ xfs_attr_node_shrink(
 }
 
 /*
+ * Mark an attribute entry INCOMPLETE and save pointers to the relevant buffers
+ * for later deletion of the entry.
+ */
+STATIC int
+xfs_attr_leaf_mark_incomplete(
+	struct xfs_da_args	*args,
+	struct xfs_da_state	*state)
+{
+	int			error;
+
+	/*
+	 * Fill in disk block numbers in the state structure
+	 * so that we can get the buffers back after we commit
+	 * several transactions in the following calls.
+	 */
+	error = xfs_attr_fillstate(state);
+	if (error)
+		return error;
+
+	/*
+	 * Mark the attribute as INCOMPLETE
+	 */
+	return xfs_attr3_leaf_setflag(args);
+}
+
+/*
  * Remove a name from a B-tree attribute list.
  *
  * This will involve walking down the Btree, and may involve joining
@@ -1168,20 +1194,7 @@ xfs_attr_node_removename(
 	ASSERT(blk->bp != NULL);
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
 	if (args->rmtblkno > 0) {
-		/*
-		 * Fill in disk block numbers in the state structure
-		 * so that we can get the buffers back after we commit
-		 * several transactions in the following calls.
-		 */
-		error = xfs_attr_fillstate(state);
-		if (error)
-			goto out;
-
-		/*
-		 * Mark the attribute as INCOMPLETE, then bunmapi() the
-		 * remote value.
-		 */
-		error = xfs_attr3_leaf_setflag(args);
+		error = xfs_attr_leaf_mark_incomplete(args, state);
 		if (error)
 			goto out;
 
-- 
2.7.4

