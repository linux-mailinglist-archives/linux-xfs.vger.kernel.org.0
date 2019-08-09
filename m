Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0C1884FE
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfHIVij (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:38:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50764 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbfHIVii (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYPQo071860
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=M0jzhPRCsqHb+LX0hc9PORVKNu/lTs7dGAFDEsanXHk=;
 b=FngrHduoOQsyy1U/xkYZ68rDO+RMbdbWzqBSIMlbIo7lGi130RU83uqtQBQKDxYDomPj
 P5Dz25FsbOZXy9x0oALNi+CPbHuxglfufzAqFNiynlrltA0K6buHvWTw8G8vMjL9SJR6
 5q1ISiV4dsooCNJEb9keHLx0XV1VHdwMR+kBpDmmNOrDMaWmXL8Wgg+bkRHyyFGOym6N
 uM0jEX6g8REJqpCQSg5IR0jbwDLhjqNZr0GovaEee1X9QKhde3MWQsU6lGrVfkJr85Jz
 QBCxF09iFQFrugt0Cf/1jYXWkjf9ZnEzs+VOB8a5+I3YU5yfNiYMNULXnyeVE+iIgy48 Ug== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=M0jzhPRCsqHb+LX0hc9PORVKNu/lTs7dGAFDEsanXHk=;
 b=ZvkobRA32p1YW1wYU+P+jMG4bKf0wJ02yBE61LbkbX8mkWC31qk6FVnm659/BgB3jw8t
 9PiHGt5b22yjq4TzwjxRMfdE8bwv4W+0XlXz6Hwo1VpERK9TMyvAtHhQyNW2ubKpol2b
 hURFfIf4ACCwMjQBtfw4e7DrPqa8zAwFTcffC9kiccoCWuy9GUaaCKxRAVHj+rOZG/pp
 1vZoE7k3jGLyjAUQro3MCqJopvgBZld+07umc/N+XD07sPctCnxgGbw2EAXCRFbYlmo4
 od/6Il7IH4ehIjXSnYCpV7BUPu+J82HhKUY6sldQrBm55+YMO5LlDsi++pcrb6M2X9W0 Vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u8hpsa504-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LcZFU097348
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2u8pj9m4k8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:36 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcKue002216
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:20 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:20 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 12/19] xfsprogs: Factor out xfs_attr_rmtval_remove_value
Date:   Fri,  9 Aug 2019 14:37:57 -0700
Message-Id: <20190809213804.32628-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213804.32628-1-allison.henderson@oracle.com>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090208
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Because new delayed attribute routines cannot roll
transactions, we carve off the parts of
xfs_attr_rmtval_remove that we can use.  This will help to
reduce repetitive code later when we introduce delayed
attributes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr_remote.c | 25 +++++++++++++++++++------
 libxfs/xfs_attr_remote.h |  1 +
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 5452de4..6904b86 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -589,19 +589,14 @@ xfs_attr_rmtval_set_value(
 	return 0;
 }
 
-/*
- * Remove the value associated with an attribute by deleting the
- * out-of-line buffer that it is stored on.
- */
 int
-xfs_attr_rmtval_remove(
+xfs_attr_rmtval_remove_value(
 	struct xfs_da_args	*args)
 {
 	struct xfs_mount	*mp = args->dp->i_mount;
 	xfs_dablk_t		lblkno;
 	int			blkcnt;
 	int			error;
-	int			done;
 
 	trace_xfs_attr_rmtval_remove(args);
 
@@ -645,7 +640,25 @@ xfs_attr_rmtval_remove(
 		lblkno += map.br_blockcount;
 		blkcnt -= map.br_blockcount;
 	}
+	return 0;
+}
 
+/*
+ * Remove the value associated with an attribute by deleting the
+ * out-of-line buffer that it is stored on.
+ */
+int
+xfs_attr_rmtval_remove(
+	struct xfs_da_args      *args)
+{
+	xfs_dablk_t		lblkno;
+	int			blkcnt;
+	int			error = 0;
+	int			done = 0;
+
+	error = xfs_attr_rmtval_remove_value(args);
+	if (error)
+		return error;
 	/*
 	 * Keep de-allocating extents until the remote-value region is gone.
 	 */
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 2a73cd9..9a58a23 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -11,6 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
+int xfs_attr_rmtval_remove_value(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args, int *blkcnt,
 			   xfs_fileoff_t *lfileoff);
-- 
2.7.4

