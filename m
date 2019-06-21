Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4954EFB1
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 21:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfFUT5F (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 15:57:05 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40088 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfFUT5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 15:57:05 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LJs6Ov001887;
        Fri, 21 Jun 2019 19:57:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=MRIygYJvFZ/uvy31cmr69RJhJSBOLlFcyTlp0eDk6dQ=;
 b=QT2fV6xEg/Xa5L8odN0tDe8kPEd/GXTQExg6EJaWWQ3FGDEucjku4C/50jrNj3hMusIB
 uF9/m7gRPm1rr0lZXSV/Y0OjuIjiHRwfaeEJOF5hIonDd2kaird9d+NztIMXWrs4/nFC
 uqSsuyN4/MOx8/R/klH+8sRBFDTXtY2iwf33nZAeGs9hq7qIawIm38CL8+aimfj3WoGC
 zCCEmfdfdJQcJQM9koFwEpgYsdrMVK+cCYHssBPVU8af6QSLZydm4D9tauv02vb7g57L
 2IqnQkjHmbgq4kocR9uTMyYdpRW8HqYNwg86wuI5vIagU8PbZ86msmn53RylEDf512Y7 rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t7809r5sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:57:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LJtpXF178565;
        Fri, 21 Jun 2019 19:57:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t77ypcdye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:57:02 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5LJv1wL007100;
        Fri, 21 Jun 2019 19:57:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 12:57:01 -0700
Subject: [PATCH 1/6] xfs: refactor free space btree record initialization
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Date:   Fri, 21 Jun 2019 12:57:00 -0700
Message-ID: <156114702011.1643538.11896501170862991755.stgit@magnolia>
In-Reply-To: <156114701371.1643538.316410894576032261.stgit@magnolia>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the code that populates the free space btrees of a new AG so
that we can avoid code duplication once things start getting
complicated.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_ag.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 8ee45699..fe79693e 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -57,37 +57,42 @@ xfs_btroot_init(
 	xfs_btree_init_block(mp, bp, id->type, 0, 0, id->agno);
 }
 
-/*
- * Alloc btree root block init functions
- */
+/* Finish initializing a free space btree. */
 static void
-xfs_bnoroot_init(
+xfs_freesp_init_recs(
 	struct xfs_mount	*mp,
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
 	struct xfs_alloc_rec	*arec;
 
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, id->agno);
 	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
 	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
 	arec->ar_blockcount = cpu_to_be32(id->agsize -
 					  be32_to_cpu(arec->ar_startblock));
 }
 
+/*
+ * Alloc btree root block init functions
+ */
 static void
-xfs_cntroot_init(
+xfs_bnoroot_init(
 	struct xfs_mount	*mp,
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	struct xfs_alloc_rec	*arec;
+	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, id->agno);
+	xfs_freesp_init_recs(mp, bp, id);
+}
 
+static void
+xfs_cntroot_init(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*bp,
+	struct aghdr_init_data	*id)
+{
 	xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 1, id->agno);
-	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
-	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
-	arec->ar_blockcount = cpu_to_be32(id->agsize -
-					  be32_to_cpu(arec->ar_startblock));
+	xfs_freesp_init_recs(mp, bp, id);
 }
 
 /*

