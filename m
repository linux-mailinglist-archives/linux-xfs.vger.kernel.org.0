Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452D5884CA
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbfHIVhr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:37:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58650 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728160AbfHIVhq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:37:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYbFI084554
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=XdMsJ9PsS6bH/yiXFwxJybpoSoP9tYzqXQ/KcQnx9sY=;
 b=RYkmAriRgw0iHnWAu7gCNlEruTsOFbK5J80ZORfJrHZ3Heo9V9GSey3wZHYzrdMmhGN/
 qNbk7LBpuCc2hyoKuKYHng79qxjrywnw2P4ORhos0qyzi93mZz/W0UuA7CRbPOcJ9IR1
 L66sqBGM8rcP4Z5U2h+ZH7EmhLPLWO57zU56eTMpTL2PBClz0jLFCHJUlleiHG0qjD2Q
 iaIPsepke0tuk2+kKFk5O2fpxX9XN3SNXglgQoPq8k7rtLXoxW4ZS2yy08ws/SdrGwR+
 RfN9uRndYWPMTYINuOQ0iCVzlNd/ocY3YvKE4D7fsb1MemcctVDqaEUKd2saWF1+M7Yt LQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=XdMsJ9PsS6bH/yiXFwxJybpoSoP9tYzqXQ/KcQnx9sY=;
 b=HSXwlsthlXHv7ps+snOEHwjXPZxaae6CKXpxwp1R8Ut427/+rle1uhIlkKFhgPQd9QGF
 z338rIeuU1kTCXbsDZX/N0O5Df8MW3/lYKPRGWQtMutKH5oYnP6p8ANPk7HkrSDSsrZx
 w0y7oS5PqB4typLbR3CqnUoTv7hxFjUwUof983E+g7Oa47Ucjq196zKemFTjrQaw59sQ
 uniRRg1Ec0FNcCtKrubWBBqSDkJ8/Y9ji7bN+SZ9CgB5R60yN1UuGNWaWZ6dZE5xhTOv
 NiGkTrBTRyi2Wd7bcLDTAwtm5WytDzpSZUSsd06OxzlJQsB2SK0gYlCbu5QVQL/FejJL 8w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u8hgpa7wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LO4Kc008114
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2u8x1h6vkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LbhHE001874
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:37:34 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 06/18] xfs: Factor out new helper functions xfs_attr_rmtval_set
Date:   Fri,  9 Aug 2019 14:37:14 -0700
Message-Id: <20190809213726.32336-7-allison.henderson@oracle.com>
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

Break xfs_attr_rmtval_set into two helper functions
xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
xfs_attr_rmtval_set rolls the transaction between the
helpers, but delayed operations cannot.  We will use
the helpers later when constructing new delayed
attribute routines.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 73 +++++++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_attr_remote.h |  4 ++-
 2 files changed, 58 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 4eb30d3..c421412 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -21,6 +21,7 @@
 #include "xfs_attr.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
+#include "xfs_attr_remote.h"
 
 #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
 
@@ -430,34 +431,18 @@ xfs_attr_rmtval_set(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
-	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_bmbt_irec	map;
 	xfs_dablk_t		lblkno;
 	xfs_fileoff_t		lfileoff = 0;
-	uint8_t			*src = args->value;
 	int			blkcnt;
-	int			valuelen;
 	int			nmap;
 	int			error;
-	int			offset = 0;
 
-	trace_xfs_attr_rmtval_set(args);
-
-	/*
-	 * Find a "hole" in the attribute address space large enough for
-	 * us to drop the new attribute's value into. Because CRC enable
-	 * attributes have headers, we can't just do a straight byte to FSB
-	 * conversion and have to take the header space into account.
-	 */
-	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
-	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
-						   XFS_ATTR_FORK);
+	error = xfs_attr_rmt_find_hole(args, &blkcnt, &lfileoff);
 	if (error)
 		return error;
 
-	args->rmtblkno = lblkno = (xfs_dablk_t)lfileoff;
-	args->rmtblkcnt = blkcnt;
-
+	lblkno = (xfs_dablk_t)lfileoff;
 	/*
 	 * Roll through the "value", allocating blocks on disk as required.
 	 */
@@ -498,6 +483,58 @@ xfs_attr_rmtval_set(
 			return error;
 	}
 
+	error = xfs_attr_rmtval_set_value(args);
+	return error;
+}
+
+
+
+int
+xfs_attr_rmt_find_hole(
+	struct xfs_da_args	*args,
+	int			*blkcnt,
+	xfs_fileoff_t		*lfileoff)
+{
+	struct xfs_inode        *dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	int			error;
+
+	trace_xfs_attr_rmtval_set(args);
+
+	/*
+	 * Find a "hole" in the attribute address space large enough for
+	 * us to drop the new attribute's value into. Because CRC enable
+	 * attributes have headers, we can't just do a straight byte to FSB
+	 * conversion and have to take the header space into account.
+	 */
+	*blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
+	error = xfs_bmap_first_unused(args->trans, args->dp, *blkcnt, lfileoff,
+						   XFS_ATTR_FORK);
+	if (error)
+		return error;
+
+	args->rmtblkno = (xfs_dablk_t)*lfileoff;
+	args->rmtblkcnt = *blkcnt;
+
+	return 0;
+}
+
+int
+xfs_attr_rmtval_set_value(
+	struct xfs_da_args	*args)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_bmbt_irec	map;
+	xfs_dablk_t		lblkno;
+	uint8_t			*src = args->value;
+	int			blkcnt;
+	int			valuelen;
+	int			nmap;
+	int			error;
+	int			offset = 0;
+
+
 	/*
 	 * Roll through the "value", copying the attribute value to the
 	 * already-allocated blocks.  Blocks are written synchronously
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 9d20b66..2a73cd9 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -11,5 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
-
+int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
+int xfs_attr_rmt_find_hole(struct xfs_da_args *args, int *blkcnt,
+			   xfs_fileoff_t *lfileoff);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4

