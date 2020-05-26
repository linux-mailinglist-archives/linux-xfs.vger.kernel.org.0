Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451B219E0BA
	for <lists+linux-xfs@lfdr.de>; Sat,  4 Apr 2020 00:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgDCWKP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 3 Apr 2020 18:10:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45522 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgDCWKP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:10:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M9xoN082813
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=bTejOhKZqVKh6SQWOPr2NLDulRWOGtwTu/mBk+IYqL8=;
 b=oZEOFUtHMz84TJgF3jREatYoZ7oFmpLzhwH5DDq0pWrkYHP/03Dl10GPTzl1HuVHFJWa
 5knFLtwxj1NrzUtgpKaEW0SPHGxR1P/CTbMDUuhrwONHCYv21TUMlrDTZtXv3fmcOhwI
 MlAthayPAipgd0yvpyMlAEc1y/W2d8rM+I42PTyKKFkTY8R7VckN0nLkQZLyezz6TaX0
 9uhrjdRqUOVTtQ7o5LYyTwtAUV1LEqkw8037PQLaCgKvwa1sz/gE/kjMfI9GJLZBAVco
 uBDkDz/Pr2GCx+PSIRD4xoy4oC80UB6gI878Tb2ON0TTH1sLZ+h5y/UrCV7t4+NUswpl 6A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 303cevkdhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M7AgT170948
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 302g2p2by1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:13 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033MACcs028182
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:12 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:12 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 25/39] xfsprogs: Refactor xfs_attr_try_sf_addname
Date:   Fri,  3 Apr 2020 15:09:44 -0700
Message-Id: <20200403220958.4944-26-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To help pre-simplify xfs_attr_set_args, we need to hoist transaction
handling up, while modularizing the adjacent code down into helpers. In
this patch, hoist the commit in xfs_attr_try_sf_addname up into the
calling function, and also pull the attr list creation down.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index a5fc323..e020bad 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -179,8 +179,13 @@ xfs_attr_try_sf_addname(
 	struct xfs_da_args	*args)
 {
 
-	struct xfs_mount	*mp = dp->i_mount;
-	int			error, error2;
+	int			error;
+
+	/*
+	 * Build initial attribute list (if required).
+	 */
+	if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
+		xfs_attr_shortform_create(args);
 
 	error = xfs_attr_shortform_addname(args);
 	if (error == -ENOSPC)
@@ -193,12 +198,10 @@ xfs_attr_try_sf_addname(
 	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
 		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
-	if (mp->m_flags & XFS_MOUNT_WSYNC)
+	if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args->trans);
 
-	error2 = xfs_trans_commit(args->trans);
-	args->trans = NULL;
-	return error ? error : error2;
+	return error;
 }
 
 /*
@@ -210,7 +213,7 @@ xfs_attr_set_args(
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_buf          *leaf_bp = NULL;
-	int			error;
+	int			error, error2 = 0;
 
 	/*
 	 * If the attribute list is non-existent or a shortform list,
@@ -221,17 +224,14 @@ xfs_attr_set_args(
 	     dp->i_d.di_anextents == 0)) {
 
 		/*
-		 * Build initial attribute list (if required).
-		 */
-		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
-			xfs_attr_shortform_create(args);
-
-		/*
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

