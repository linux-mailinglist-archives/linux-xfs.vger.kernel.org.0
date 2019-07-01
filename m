Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20EB54D99E
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2019 20:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfFTSnG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Jun 2019 14:43:06 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48136 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfFTSnG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jun 2019 14:43:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KIcu7i154526
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:43:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=SGxoeVkfYGhZrxRJDq8WDsOspB4lLmTiuZkkplE1qjA=;
 b=l3XVVRhrnBcHBQSoYslPKYlgPu3DXM5s5V5wasoZAH+eqfAy4figq2kUNvFRWbMRX9nF
 E/6xIWE++aVqH+l5QX/dKPoJXGQeoKMolo54K6m3Ss3UIlTPCZlDHIgXpMDCSqtNLgAL
 WOZrU88pZpVDS8KBRxY0iuvhXAMaaI6oPRFGu7VEUSipJf8uEEJ+xVOsYcMpfgb5Rcpr
 fdjFyERwYNfcOgokXHxd3YS+7dkKJ60DdQhHQRFz0X280GZWA+S6c4MC6rftyM0DHVYY
 EWT3Plp/e89H+Xm06wDdqN0AcVD1ohdhkglJ9qn9BtvzAPgUzYktR5LZZgAfZ+UqgsBX cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t7809jrtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:43:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5KIgY6q025359
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:43:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t77ynsguq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:43:03 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5KIh3xn019771
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2019 18:43:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Jun 2019 11:43:02 -0700
Subject: [PATCH 2/2] xfs: account for log space when formatting new AGs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 20 Jun 2019 11:43:01 -0700
Message-ID: <156105618181.1200596.7381990220006852218.stgit@magnolia>
In-Reply-To: <156105616866.1200596.7212155126558008316.stgit@magnolia>
References: <156105616866.1200596.7212155126558008316.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906200135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9294 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906200135
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're writing out a fresh new AG, make sure that we don't list an
internal log as free and that we create the rmap for the region.  growfs
never does this, but we will need it when we hook up mkfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_ag.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 80a3df7ccab3..57aa85d8e3aa 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -10,6 +10,7 @@
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
+#include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
@@ -44,6 +45,12 @@ xfs_get_aghdr_buf(
 	return bp;
 }
 
+static inline bool is_log_ag(struct xfs_mount *mp, struct aghdr_init_data *id)
+{
+	return mp->m_sb.sb_logstart > 0 &&
+	       id->agno == XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart);
+}
+
 /*
  * Generic btree root block init function
  */
@@ -64,11 +71,50 @@ xfs_freesp_init_recs(
 	struct aghdr_init_data	*id)
 {
 	struct xfs_alloc_rec	*arec;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 
 	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
 	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
+
+	if (is_log_ag(mp, id)) {
+		struct xfs_alloc_rec	*nrec;
+		xfs_agblock_t		start = XFS_FSB_TO_AGBNO(mp,
+							mp->m_sb.sb_logstart);
+
+		ASSERT(start >= mp->m_ag_prealloc_blocks);
+		if (start != mp->m_ag_prealloc_blocks) {
+			/*
+			 * Modify first record to pad stripe align of log
+			 */
+			arec->ar_blockcount = cpu_to_be32(start -
+						mp->m_ag_prealloc_blocks);
+			nrec = arec + 1;
+			/*
+			 * Insert second record at start of internal log
+			 * which then gets trimmed.
+			 */
+			nrec->ar_startblock = cpu_to_be32(
+					be32_to_cpu(arec->ar_startblock) +
+					be32_to_cpu(arec->ar_blockcount));
+			arec = nrec;
+			be16_add_cpu(&block->bb_numrecs, 1);
+		}
+		/*
+		 * Change record start to after the internal log
+		 */
+		be32_add_cpu(&arec->ar_startblock, mp->m_sb.sb_logblocks);
+	}
+
+	/*
+	 * Calculate the record block count and check for the case where
+	 * the log might have consumed all available space in the AG. If
+	 * so, reset the record count to 0 to avoid exposure of an invalid
+	 * record start block.
+	 */
 	arec->ar_blockcount = cpu_to_be32(id->agsize -
 					  be32_to_cpu(arec->ar_startblock));
+	if (!arec->ar_blockcount)
+		block->bb_numrecs = 0;
 }
 
 /*
@@ -154,6 +200,18 @@ xfs_rmaproot_init(
 		rrec->rm_offset = 0;
 		be16_add_cpu(&block->bb_numrecs, 1);
 	}
+
+	/* account for the log space */
+	if (is_log_ag(mp, id)) {
+		rrec = XFS_RMAP_REC_ADDR(block,
+				be16_to_cpu(block->bb_numrecs) + 1);
+		rrec->rm_startblock = cpu_to_be32(
+				XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart));
+		rrec->rm_blockcount = cpu_to_be32(mp->m_sb.sb_logblocks);
+		rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_LOG);
+		rrec->rm_offset = 0;
+		be16_add_cpu(&block->bb_numrecs, 1);
+	}
 }
 
 /*
@@ -214,6 +272,14 @@ xfs_agfblock_init(
 		agf->agf_refcount_level = cpu_to_be32(1);
 		agf->agf_refcount_blocks = cpu_to_be32(1);
 	}
+
+	if (is_log_ag(mp, id)) {
+		int64_t	logblocks = mp->m_sb.sb_logblocks;
+
+		be32_add_cpu(&agf->agf_freeblks, -logblocks);
+		agf->agf_longest = cpu_to_be32(id->agsize -
+			XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart) - logblocks);
+	}
 }
 
 static void

