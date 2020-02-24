Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC62D169CCE
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2020 04:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbgBXD7M (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 23 Feb 2020 22:59:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60674 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727168AbgBXD7M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 22:59:12 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01O3wAwU092555;
        Sun, 23 Feb 2020 22:59:08 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb008sugx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:59:08 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01O3wBMN092572;
        Sun, 23 Feb 2020 22:59:08 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb008sugr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 22:59:08 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01O3wsTb009996;
        Mon, 24 Feb 2020 03:59:07 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01wdc.us.ibm.com with ESMTP id 2yaux607wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 03:59:07 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01O3x6ZC23724344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 03:59:06 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D31E6E052;
        Mon, 24 Feb 2020 03:59:06 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5C3B6E04C;
        Mon, 24 Feb 2020 03:59:03 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.91.136])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 03:59:03 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com,
        amir73il@gmail.com
Subject: [PATCH V4 RESEND 5/7] xfsprogs: xfs_attr_calc_size: Explicitly pass mp, namelen and valuelen args
Date:   Mon, 24 Feb 2020 09:31:34 +0530
Message-Id: <20200224040136.31078-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200224040136.31078-1-chandanrlinux@gmail.com>
References: <20200224040136.31078-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-23_07:2020-02-21,2020-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1034 impostorscore=0
 suspectscore=1 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240032
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In a future commit, xfs_attr_calc_size() will be invoked from a function that
does not have a 'struct xfs_da_args' handy. Hence this commit changes
xfs_attr_calc_size() to let invokers to explicitly pass 'struct xfs_mount *',
namelen and valuelen arguments.

Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 libxfs/xfs_attr.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 23fcb110..78127dfc 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -138,22 +138,24 @@ xfs_attr_get(
  */
 STATIC void
 xfs_attr_calc_size(
-	struct xfs_da_args		*args,
+	struct xfs_mount		*mp,
 	struct xfs_attr_set_resv	*resv,
+	int				namelen,
+	int				valuelen,
 	int				*local)
 {
-	struct xfs_mount		*mp = args->dp->i_mount;
+	unsigned int			blksize = mp->m_attr_geo->blksize;
 	int				size;
 
 	/*
 	 * Determine space new attribute will use, and if it would be
 	 * "local" or "remote" (note: local != inline).
 	 */
-	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
-			args->valuelen, local);
+	size = xfs_attr_leaf_newentsize(mp->m_attr_geo, namelen, valuelen,
+			local);
 	resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
 	if (*local) {
-		if (size > (args->geo->blksize / 2)) {
+		if (size > (blksize / 2)) {
 			/* Double split possible */
 			resv->total_dablks *= 2;
 		}
@@ -163,7 +165,7 @@ xfs_attr_calc_size(
 		 * Out of line attribute, cannot double split, but
 		 * make room for the attribute value itself.
 		 */
-		resv->rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
+		resv->rmt_blks = xfs_attr3_rmt_blocks(mp, valuelen);
 	}
 
 	resv->bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp,
@@ -329,7 +331,8 @@ xfs_attr_set(
 		XFS_STATS_INC(mp, xs_attr_set);
 
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		xfs_attr_calc_size(args, &resv, &local);
+		xfs_attr_calc_size(mp, &resv, args->namelen, args->valuelen,
+				&local);
 		args->total = resv.alloc_blks;
 
 		/*
-- 
2.19.1

