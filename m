Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD1E2248B1
	for <lists+linux-xfs@lfdr.de>; Sat, 18 Jul 2020 06:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgGREd5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 18 Jul 2020 00:33:57 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59550 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbgGREd4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jul 2020 00:33:56 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4XuJt052588
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=UrrX0EKu8yHPP9N5koZoUgZ5i4S3Er1DEh2Ti8DWg+Y=;
 b=JseedjqoujpL0gEUC/aIJq+19ylOF7zU1a32wHQ8i8shpTefKIix2/mwwOc6qtzMVf5b
 f+ZTFJB7cG3frm5tnCupqcH7Ew8g+awQB0KajD1yOsl7tKdl7arqtlOgqycWu1ZEPVIf
 tAh4sqYmbZAevAuQCHSLAFLSGypvOTOglIaZv6KulReQMVepUd8cIT4p1aRfGQ72N1bt
 N9LNlNimQlXbpeM3Y9fJhIjU7GqUpCHFWrsp2btVn3e6cfuYiGaqJs4fszrTBS2ixTV3
 d8N93Hh3mDvF9IuxQ2xYxxqMggCjEVtqGzinN6wMNbCv+Jy8oufjdIxBiuSVqC/oaH+K RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 32bpkarbja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4XpS2169497
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 32brw1w7b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:55 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06I4Xt58019775
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:55 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 21:33:54 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 15/26] xfsprogs: Remove xfs_trans_roll in xfs_attr_node_removename
Date:   Fri, 17 Jul 2020 21:33:31 -0700
Message-Id: <20200718043342.6432-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200718043342.6432-1-allison.henderson@oracle.com>
References: <20200718043342.6432-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007180030
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A transaction roll is not necessary immediately after setting the
INCOMPLETE flag when removing a node xattr entry with remote value
blocks. The remote block invalidation that immediately follows setting
the flag is an in-core only change. The next step after that is to start
unmapping the remote blocks from the attr fork, but the xattr remove
transaction reservation includes reservation for full tree splits of the
dabtree and bmap tree. The remote block unmap code will roll the
transaction as extents are unmapped and freed.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_attr.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 0b81bf5..a743900 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1148,10 +1148,6 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 
-		error = xfs_trans_roll_inode(&args->trans, args->dp);
-		if (error)
-			goto out;
-
 		error = xfs_attr_rmtval_invalidate(args);
 		if (error)
 			return error;
-- 
2.7.4

