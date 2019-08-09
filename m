Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B457E884C8
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbfHIVhr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:37:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58644 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728090AbfHIVhq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:37:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYjps084828
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=F2rEY2FrmsARCihNmu8DWKVrNkJ/p2FVp8UOAyEInS0=;
 b=ioSWM2R7JWG3khdtBPUxulzyB+vWwUamHUw7mmhjjcYSQJbjK+E7037PxT9Sq3uSyjdM
 Kb9GpumN1K0Bl6BdJxUyOviXDCfsGq8hiB7PoFyUPQW93Tjvtcz0hqp837cMib9fh2KM
 188JpKgZ8wNFDh/oXzX5HxlmZOUh2dV/xhrs+DcuU6Yp/xAULC1JbM5x6GMaPYX1d+er
 gijnVLn2/MRTZL5zp5NPUaVuYdfhdvhUO0Fz1qRHMknfrLqum4Wbsg2zIpjEEaW9a7Ui
 M9mBIGjUxpKa/zSMx1sedYuubOgm587ERkyvasNoBRp3cAYmbUwRzzPQ0BGyHqFeF325 gA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=F2rEY2FrmsARCihNmu8DWKVrNkJ/p2FVp8UOAyEInS0=;
 b=v6wTDQPrmeTFD11e2BYaJLIlyYduZZMk1/Ss1cm/1/pX9Ctp+fmyG4gLKRg+9EwM/BqC
 EZwR09/OtF/p0D4YJOW/aVYOeVMFDci+S8K1qBiJvxTnzrpJQoTazOiCE2Uq8Gbn8kzs
 z4JrtBLPIMI4TekAxt3hrc+m71M1SHd6TCi8NU4gNLmn3YJ8k+1MGmp/8B6Bi9fc+UuY
 tuO/LFzxOu/6Oj2EzUpZjo2ov33i+JQOmfENqVDnVAFJZr7F8hV4LfWaKOV7TfMDH25O
 BlPWKE3LDe4uSxtX/CknF3v+7O0ocswSLHcVwL5cE3Jlk2EXSIFQz3zfRDmAFdoHe0dR Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u8hgpa7wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LO3Of008010
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2u8x1h6vks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x79Lbhwt004870
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:37:35 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 09/18] xfs: Factor up commit from xfs_attr_try_sf_addname
Date:   Fri,  9 Aug 2019 14:37:17 -0700
Message-Id: <20190809213726.32336-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213726.32336-1-allison.henderson@oracle.com>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090207
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

New delayed attribute routines cannot handle transactions,
so factor this up to the calling function.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f9d5e28..6bd87e6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -196,7 +196,7 @@ xfs_attr_try_sf_addname(
 {
 
 	struct xfs_mount	*mp = dp->i_mount;
-	int			error, error2;
+	int			error;
 
 	error = xfs_attr_shortform_addname(args);
 	if (error == -ENOSPC)
@@ -212,9 +212,7 @@ xfs_attr_try_sf_addname(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args->trans);
 
-	error2 = xfs_trans_commit(args->trans);
-	args->trans = NULL;
-	return error ? error : error2;
+	return error;
 }
 
 /*
@@ -226,7 +224,7 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error;
+	int			error, error2 = 0;;
 
 	/*
 	 * If the attribute list is non-existent or a shortform list,
@@ -246,8 +244,11 @@ xfs_attr_set_args(
 		 * Try to add the attr to the attribute list in the inode.
 		 */
 		error = xfs_attr_try_sf_addname(dp, args);
-		if (error != -ENOSPC)
-			return error;
+		if (error != -ENOSPC) {
+			error2 = xfs_trans_commit(args->trans);
+			args->trans = NULL;
+			return error ? error : error2;
+		}
 
 		/*
 		 * It won't fit in the shortform, transform to a leaf block.
-- 
2.7.4

