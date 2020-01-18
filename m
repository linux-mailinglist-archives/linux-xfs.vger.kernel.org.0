Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D12141A38
	for <lists+linux-xfs@lfdr.de>; Sat, 18 Jan 2020 23:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgARWuv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 18 Jan 2020 17:50:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbgARWuu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jan 2020 17:50:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMcw7H056519
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=lmskT+9ncyzYs6XIXB+OPLA/znGMLjhYEg/f6e9uXTg=;
 b=h0/rL8NMo/SzZbQDG1lWL7Z0l4aQ+miKxK3en+Sq9xL8rCBdbYmZoEHpLzL7nhKENm6O
 /rZQKYuNiMj6zLIpPHcuaG32D+/8NOvXA2q6QZYYfvsBZyZ2yw/pjDm4kLSrokeDNWji
 F73xOe7IYwZD8fS7kA0hQakluEpVWS7iOFPvghNB5pyVRYejCYgoFm5bOccHr/ZzWzAc
 PrIN5PJgGJTFc4gP8R53zEXVq5u4IwbKHa2Zdw0OEQOfFgorM+052Cr9OYJQbWdTN62L
 oK2m6ApYorHaoGGHvIOYIRLk5kkc6S5jp8DGsQNmYmzJNxYYdT/SzKYvXMy5Z/Kmbxic kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2xksypt05b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00IMctk9162191
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2xksc4ad09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:48 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00IMoldq030836
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jan 2020 22:50:47 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 18 Jan 2020 14:50:47 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v6 13/16] xfs: Add helper function xfs_attr_rmtval_unmap
Date:   Sat, 18 Jan 2020 15:50:32 -0700
Message-Id: <20200118225035.19503-14-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200118225035.19503-1-allison.henderson@oracle.com>
References: <20200118225035.19503-1-allison.henderson@oracle.com>
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
 fs/xfs/libxfs/xfs_attr_remote.c | 27 +++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_remote.h |  1 +
 2 files changed, 28 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 9b4fa2a..f2ee0b8 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -684,3 +684,30 @@ xfs_attr_rmtval_remove(
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
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 85f2593..7ab3770 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -12,4 +12,5 @@ int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
+int xfs_attr_rmtval_unmap(struct xfs_da_args *args);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4

