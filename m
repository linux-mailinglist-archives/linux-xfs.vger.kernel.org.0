Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E7B4EFB2
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2019 21:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfFUT5M (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 15:57:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57492 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfFUT5M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 15:57:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LJs3vJ100439;
        Fri, 21 Jun 2019 19:57:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=O2cqZr73xXERGaHZcosQsp2ip7rKILFMmCFLVIVzkk0=;
 b=AQPhVXhlF/WXuLxs2w8w8AtWLrO+HO6mf+IT2ywz54d8KKeadPJiqQf+snpSf9o4M/Z5
 w44xhcQZvmcsVkAtFDxcEB5/HwUhG9s7JPy6/woWtaSIPUjsLMyk2hGTtElS0jo3gzci
 U1Yymnf5c0ztaqVmDbs1OxWm3aJH2iZmIdkK3vcaIUr5wls6v9KCkXhYUBiwfMWgtMJj
 /2YY33cvCXNRHhK5jD8kfmpOLeF3XSlqhBxHUIRzLFiM5+EE44MkutfZ0c/3bmXfSPYZ
 X66FzwJDUzWhEvmHTAUfRf7lJgGMuTsiX0gNrf9GHEdtgO4WnlFDskU6IVymAIUYRPol 6A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2t7809r6k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:57:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LJthKI178257;
        Fri, 21 Jun 2019 19:57:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t77ypce12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 19:57:09 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5LJv7sk015749;
        Fri, 21 Jun 2019 19:57:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 12:57:07 -0700
Subject: [PATCH 2/6] xfs: account for log space when formatting new AGs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Date:   Fri, 21 Jun 2019 12:57:06 -0700
Message-ID: <156114702648.1643538.14530619220062934565.stgit@magnolia>
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

When we're writing out a fresh new AG, make sure that we don't list an
internal log as free and that we create the rmap for the region.  growfs
never does this, but we will need it when we hook up mkfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_ag.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index fe79693e..237d6c53 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -11,6 +11,7 @@
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
+#include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
@@ -45,6 +46,12 @@ xfs_get_aghdr_buf(
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
@@ -65,11 +72,50 @@ xfs_freesp_init_recs(
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
@@ -155,6 +201,18 @@ xfs_rmaproot_init(
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
@@ -215,6 +273,14 @@ xfs_agfblock_init(
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

