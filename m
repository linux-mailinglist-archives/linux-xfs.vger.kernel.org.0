Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF0C141A2D
	for <lists+linux-xfs@lfdr.de>; Sat, 18 Jan 2020 23:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgARWsT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 18 Jan 2020 17:48:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38490 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgARWsT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jan 2020 17:48:19 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMctVZ093487
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:48:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=fu0jofYDa5Q8jpdRhO0Njz9CKiQDvqtbEvGW9xOKO+M=;
 b=fkXP1NMpTrk4AAEP+YPGHoZXou1kFqedMmsp5oWdgM7Ozh75xI2oHZUoafaeYLXuAhDL
 DF174v75tNtGJzzHYvI5Bf/DWIOAYOHh0jclyOk4Q1BmWIiqScPguzj2jAcgZHivpiy0
 LZp7G2L93eaHn/1udjXI2ZkM7y8DxAHQ5h/3zTIbS6Lc1I/dKYLhOHDGeSxWvxpfNA8g
 7qi+ft6TTaCNr8RgoGj05Af5NANows6n91bYRe5W8ox2gpxvVo4AXdmnTCWSzgZhOKc+
 eGYaqS+eZiUoPc47aju79OIiFMNv79DGzTgZpZ5WdBKvKED31XFiZBzdG95zGr8p+Ozh 0A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xkseu249d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:48:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMctPh046001
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xksuw86p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:17 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00IMkG7W029008
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:46:16 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 18 Jan 2020 14:46:16 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 14/17] xfsprogs: Add helper function xfs_attr_rmtval_unmap
Date:   Sat, 18 Jan 2020 15:45:55 -0700
Message-Id: <20200118224558.19382-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200118224558.19382-1-allison.henderson@oracle.com>
References: <20200118224558.19382-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=943
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001180185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9504 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001180185
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This function is similar to xfs_attr_rmtval_remove, but adapted to
return. EAGAIN for new transactions. We will use this later when we
introduce delayed attributes

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr_remote.c | 27 +++++++++++++++++++++++++++
 libxfs/xfs_attr_remote.h |  1 +
 2 files changed, 28 insertions(+)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index cfeca71..a209b00 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -681,3 +681,30 @@ xfs_attr_rmtval_remove(
 	}
 	return 0;
 }
+
+/*
+ * Unmap value blocks for this attr.  This is similar to
+ * xfs_attr_rmtval_remove, but adapted to to return EAGAIN for new transactions
+ */
+int
+xfs_attr_rmtval_unmap(
+	struct xfs_da_args	*args)
+{
+	int	error, done;
+
+	/*
+	 * Unmap value blocks for this attr.  This is similar to
+	 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
+	 * for new transactions
+	 */
+	error = xfs_bunmapi(args->trans, args->dp,
+		    args->rmtblkno, args->rmtblkcnt,
+		    XFS_BMAPI_ATTRFORK, 1, &done);
+	if (error)
+		return error;
+
+	if (!done)
+		return -EAGAIN;
+
+	return 0;
+}
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 85f2593..7ab3770 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -12,4 +12,5 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
+int xfs_attr_rmtval_unmap(struct xfs_da_args *args);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4

