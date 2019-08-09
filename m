Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 455A7884C6
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbfHIVhq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:37:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49632 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbfHIVhq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:37:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYP05071872
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=A1EmyySsA9/MSiXuFcLN+UZMfhLHL13r6eSqPwodfCM=;
 b=cnaPdomubtVrRTKRuUpQufGLQPNoPJMZ14vhNP0FjvSbB+SO/T8x6yz8l7vxonXLVUjg
 2sPCuWkN4RRi8KLq5AZTy3+rbwRqb3AvsClQpAx4V6osDBlRSpgDKIlqIuuodnTk5pSV
 k8dfY6LarURgXoOE1XZZ0MAUAEkAUhSjuuoYyF5t6vY/Hb6AbIEiTkokXwIZwPRC5nVb
 6NZ7D6H4wGscDaJn/GcfkfAo6P8bH4YQXeUB6kWC/Prl0Lvc5HRbfWENgfvhfiQK1aqc
 1r1Wa1g/5cyCg87glL0jQYlKA+MyvUzzhf6Bc7JrlU0nLEd6d14iKHW+avivaZIzKzIX kQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=A1EmyySsA9/MSiXuFcLN+UZMfhLHL13r6eSqPwodfCM=;
 b=W4xwBGs+IaHWppz/7vTO8wCJFfd/VwS5/dq1aiAe684b16QGhiIDV5dGpcCz8i1dWtJP
 4tFCr2e2d79EamvLPjjuvgGWOfsOnyqRi6j1CYEvpneok6/E13zMjsXIYwSvXwAhX+SC
 NmX4VCVKlWC3REX2rwlOtrON3Se7ixwHgWYBDnteizbL3v3S46OQF9q5mkQZL2/e9dmu
 Q8l1/96z4RJwetS16vOQhCHgy0cNtLh2fVloXXtODi3A7iSfYENmVCuFhBXIQgFr5pni
 +3bgyiwwDGyxAwcSs2XpWoLWh41dlSHK5DuV/XdcqNninOIu3FnnPWzFKHDoKlDhPKR8 Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u8hpsa4wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNU5h056445
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2u8pj9m41p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LbhJV018996
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:37:36 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 12/18] xfs: Factor out xfs_attr_rmtval_remove_value
Date:   Fri,  9 Aug 2019 14:37:20 -0700
Message-Id: <20190809213726.32336-13-allison.henderson@oracle.com>
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

Because new delayed attribute routines cannot roll
transactions, we carve off the parts of
xfs_attr_rmtval_remove that we can use.  This will help to
reduce repetitive code later when we introduce delayed
attributes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 25 +++++++++++++++++++------
 fs/xfs/libxfs/xfs_attr_remote.h |  1 +
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index c421412..f030365 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -586,19 +586,14 @@ xfs_attr_rmtval_set_value(
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
 
@@ -642,7 +637,25 @@ xfs_attr_rmtval_remove(
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
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 2a73cd9..9a58a23 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
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

