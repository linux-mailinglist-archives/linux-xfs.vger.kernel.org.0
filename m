Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0259E26D1AF
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 05:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgIQD3L (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Sep 2020 23:29:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49314 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbgIQD3C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Sep 2020 23:29:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Nw5G162281;
        Thu, 17 Sep 2020 03:28:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=r3w/mvgzr8jHsTQ681UJz0vqhGz7hDs5M3t75buWsIo=;
 b=GdyUI42txmC6zTlwRJ+W2/orSbs/tRpq1doy8OO+peoXTNuaVdwCN9mk4hB/WYm0jaNq
 +oaJm6RtO4lH6CQiXp99ot9xuBe8dwerZ6wDtjdHaAPhK5uBXfCyJRz4ZsTW20QDX8i8
 TicipcEikwZtFps/avS20QMxMkPt9VqWjx2jGc06yIumtCWXTCUGKNQMQyZj0KPmONdF
 iLhxtgjrhjT5+eMkgXExppYVB6Bla4H+KE8SQVLhdHYXfHr7ZhWxPiai8NIVqdcxPt4X
 fucAo7Rv/WnqtbodncXLedSceb5lpDau1mw6/qrki0/XXWNa90Ft5rG3uTFrFVYdCCzp ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33gnrr6j7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 03:28:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08H3Ptv7181746;
        Thu, 17 Sep 2020 03:28:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33hm340rk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 03:28:58 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08H3Sv3I006842;
        Thu, 17 Sep 2020 03:28:57 GMT
Received: from localhost (/10.159.158.133)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 03:28:57 +0000
Subject: [PATCH 2/2] xfs: attach inode to dquot in xfs_bui_item_recover
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 16 Sep 2020 20:28:56 -0700
Message-ID: <160031333615.3624373.7775190767495604737.stgit@magnolia>
In-Reply-To: <160031332353.3624373.16349101558356065522.stgit@magnolia>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9746 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170023
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In the bmap intent item recovery code, we must be careful to attach the
inode to its dquots (if quotas are enabled) so that a change in the
shape of the bmap btree doesn't cause the quota counters to be
incorrect.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 815a0563288f..598f713831c9 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -24,6 +24,7 @@
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_quota.h"
 
 kmem_zone_t	*xfs_bui_zone;
 kmem_zone_t	*xfs_bud_zone;
@@ -498,6 +499,10 @@ xfs_bui_item_recover(
 	if (error)
 		goto err_inode;
 
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		goto err_inode;
+
 	if (VFS_I(ip)->i_nlink == 0)
 		xfs_iflags_set(ip, XFS_IRECOVERY);
 

