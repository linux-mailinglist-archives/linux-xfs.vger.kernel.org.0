Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0837884EE
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbfHIVi2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:38:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50520 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbfHIVi1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYVck071898
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=ouc3YThaI6Y0UAcXZpiD6qApQPbUX3YPq/OlveGYzD8=;
 b=QbX4FHEbLoUJ6PC7bE0chTToY3koMySy3aWq+ay0s6JCL4FqrJVClbrNUI/hrlwuFu0v
 1dYm3NQ9PdCKUEHr28+5Rr09MiF7/VdvwBT844zG3/sQw15lkwC00G2jtPqKLToSzSKD
 nxTty8PQlAitgTyG3vfH4FP49BJ9WGFGTvLvp7ec4Gj0FTUuYhVvPVRYZrEdYE4gVsGP
 603Ln1rHW0Q4tO7C/weWzPSDuAVc0jN4ROVe87596vrz5Vfy53V01D8KxIeDQx/Se0T8
 ocNI8QLoYNXEghI2pIhoA6Q0lrPrJn+tAcHJfUcO7j8J44VB49D/Bza32SB9xeYIMsXQ tQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=ouc3YThaI6Y0UAcXZpiD6qApQPbUX3YPq/OlveGYzD8=;
 b=p8DlqnN0yBK2SINjKBhFEKdAiJ7q7Miywyjmk45+5E+R/whM9j2tc0CiQztqTg0UMsUh
 WNdm/pCXRyLbUMi8ARMoJWs2ujuVHwGAelVP1OuChYSnc708TRkapGZaNWT2SlrVmr20
 pNohxQkxDVZzKu/3JZMmTJDiAldAEz0exLY14vVb96bZzGTvhwsbDdPk/e7cdqWrBhmr
 XgxeuWa8JWpEyGu/qyCBTvO5Ygu7JZrQsyBBQm6O6xE0MQenSjV89f2QXMo2TOvfpL3V
 2Ddq6PqW0LTYxD9X0KpXBkC+0j3F5eT0hL9QTg7XOgLi83Rl0kvOa3ekUf5q21WFLvYp LQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u8hpsa4yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LcObP112194
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2u8x9fxkc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:25 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcNUs019449
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:23 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:23 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 18/19] xfsprogs: Add delayed attributes error tag
Date:   Fri,  9 Aug 2019 14:38:03 -0700
Message-Id: <20190809213804.32628-19-allison.henderson@oracle.com>
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

This patch adds an error tag that we can use to test
delayed attribute recovery and replay

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_errortag.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index cabfc3e..05bd4db 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -54,6 +54,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_FORCE_SCRUB_REPAIR,	"force_repair" },
 		{ XFS_ERRTAG_FORCE_SUMMARY_RECALC,	"bad_summary" },
 		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
+		{ XFS_ERRTAG_DELAYED_ATTR,		"delayed_attr" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 79e6c4f..85d5850 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -55,7 +55,8 @@
 #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
-#define XFS_ERRTAG_MAX					35
+#define XFS_ERRTAG_DELAYED_ATTR				35
+#define XFS_ERRTAG_MAX					36
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -95,5 +96,6 @@
 #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
+#define XFS_RANDOM_DELAYED_ATTR				1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.7.4

