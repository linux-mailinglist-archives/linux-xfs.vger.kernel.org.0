Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF4E169694
	for <lists+linux-xfs@lfdr.de>; Sun, 23 Feb 2020 08:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgBWH2u (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 23 Feb 2020 02:28:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5404 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725980AbgBWH2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 02:28:50 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01N7OfmV133199;
        Sun, 23 Feb 2020 02:28:48 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yax36ew27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 02:28:47 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01N7Ohn0133364;
        Sun, 23 Feb 2020 02:28:47 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yax36ew21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 02:28:47 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01N7P3E7015122;
        Sun, 23 Feb 2020 07:28:46 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 2yaux640kp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 07:28:46 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01N7Sjuq53150078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 07:28:46 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE444AC059;
        Sun, 23 Feb 2020 07:28:45 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FE32AC05B;
        Sun, 23 Feb 2020 07:28:43 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.102.2.13])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 23 Feb 2020 07:28:43 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com
Subject: [PATCH V4 4/7] xfs: Introduce struct xfs_attr_set_resv
Date:   Sun, 23 Feb 2020 13:01:17 +0530
Message-Id: <20200223073120.14324-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200223073120.14324-1-chandanrlinux@gmail.com>
References: <20200223073120.14324-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-22_08:2020-02-21,2020-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 bulkscore=0 spamscore=0 suspectscore=1 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 clxscore=1034 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230063
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The intermediate numbers calculated by xfs_attr_calc_size() will be needed by
a future commit to correctly calculate log reservation for xattr set
operation. Towards this goal, this commit introduces 'struct
xfs_attr_set_resv' to collect,
1. Number of dabtree blocks.
2. Number of remote blocks.
3. Number of Bmbt blocks.
4. Total number of blocks we need to reserve.

This will be returned as an out argument by xfs_attr_calc_size().

Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 48 +++++++++++++++++++++++++----------------------
 libxfs/xfs_attr.h | 13 +++++++++++++
 2 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 967aac1d..23fcb110 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -136,16 +136,14 @@ xfs_attr_get(
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-STATIC int
+STATIC void
 xfs_attr_calc_size(
-	struct xfs_da_args	*args,
-	int			*local)
+	struct xfs_da_args		*args,
+	struct xfs_attr_set_resv	*resv,
+	int				*local)
 {
-	struct xfs_mount	*mp = args->dp->i_mount;
-	unsigned int		total_dablks;
-	unsigned int		bmbt_blks;
-	unsigned int		rmt_blks;
-	int			size;
+	struct xfs_mount		*mp = args->dp->i_mount;
+	int				size;
 
 	/*
 	 * Determine space new attribute will use, and if it would be
@@ -153,25 +151,27 @@ xfs_attr_calc_size(
 	 */
 	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
 			args->valuelen, local);
-	total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
+	resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
 	if (*local) {
 		if (size > (args->geo->blksize / 2)) {
 			/* Double split possible */
-			total_dablks *= 2;
+			resv->total_dablks *= 2;
 		}
-		rmt_blks = 0;
+		resv->rmt_blks = 0;
 	} else {
 		/*
 		 * Out of line attribute, cannot double split, but
 		 * make room for the attribute value itself.
 		 */
-		rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
+		resv->rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
 	}
 
-	bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp, total_dablks + rmt_blks,
-			XFS_ATTR_FORK);
+	resv->bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp,
+				resv->total_dablks + resv->rmt_blks,
+				XFS_ATTR_FORK);
 
-	return total_dablks + rmt_blks + bmbt_blks;
+	resv->alloc_blks = resv->total_dablks + resv->rmt_blks +
+		resv->bmbt_blks;
 }
 
 STATIC int
@@ -297,12 +297,15 @@ int
 xfs_attr_set(
 	struct xfs_da_args	*args)
 {
-	struct xfs_inode	*dp = args->dp;
-	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_trans_res	tres;
-	bool			rsvd = (args->attr_namespace & XFS_ATTR_ROOT);
-	int			error, local;
-	unsigned int		total;
+	struct xfs_inode		*dp = args->dp;
+	struct xfs_mount		*mp = dp->i_mount;
+	struct xfs_attr_set_resv	resv;
+	struct xfs_trans_res		tres;
+	bool				rsvd;
+	int				error, local;
+	unsigned int			total;
+
+	rsvd = (args->attr_namespace & XFS_ATTR_ROOT);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
@@ -326,7 +329,8 @@ xfs_attr_set(
 		XFS_STATS_INC(mp, xs_attr_set);
 
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		args->total = xfs_attr_calc_size(args, &local);
+		xfs_attr_calc_size(args, &resv, &local);
+		args->total = resv.alloc_blks;
 
 		/*
 		 * If the inode doesn't have an attribute fork, add one.
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 861c81f9..dc08bdfb 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -73,6 +73,19 @@ struct xfs_attr_list_context {
 	int			index;		/* index into output buffer */
 };
 
+struct xfs_attr_set_resv {
+	/* Number of unlogged blocks needed to store the remote attr value. */
+	unsigned int		rmt_blks;
+
+	/* Number of filesystem blocks to allocate for the da btree. */
+	unsigned int		total_dablks;
+
+	/* Blocks we might need to create all the new attr fork mappings. */
+	unsigned int		bmbt_blks;
+
+	/* Total number of blocks we might have to allocate. */
+	unsigned int		alloc_blks;
+};
 
 /*========================================================================
  * Function prototypes for the kernel.
-- 
2.19.1

