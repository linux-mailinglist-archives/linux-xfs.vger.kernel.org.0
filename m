Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C342D864AD
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Aug 2019 16:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbfHHOrG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 8 Aug 2019 10:47:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58386 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387769AbfHHOrG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Aug 2019 10:47:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x78Ehc5G094907
        for <linux-xfs@vger.kernel.org>; Thu, 8 Aug 2019 14:47:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=fR18f/gO88ghE6X0IF3KwHpERfa1dkj3yYPYnt8RxpQ=;
 b=USrcU5P4Ng8FsS5gPuO+tnbtrs8snoVABhOTYrBkrN0AT2UgKDEMoKVbkLUa2H82MTO7
 4CzDGdHHgB9H+K5XwCf9Z403ENv1UYv4F/e+0I+wz4vdPSP06jc+728U+qvsEAlcV4lW
 O5A/dVuqC44V87Y9Nh8u0RzixDuqwilWYbD085jyJncdfFcK/A68ChyE6icavBZQk/eA
 PCvFXmLbh5BWZSDqe2X4PL65LDY+JBLsao9YiS6rbnKuKZ4SLqR7Vf4pKpEKza5DjWx5
 C8XuRueQQbf0TWgG2wTmwiDG7nOsTiqInM3poqk2XnBT4KbTCoddwqx8kn0OwLk9ckE0 VA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=fR18f/gO88ghE6X0IF3KwHpERfa1dkj3yYPYnt8RxpQ=;
 b=sKUgU8ypqekd5t44F3mX3CHFWKWbWur2rgZLiQ6aw/ovuvwiDLfvRG/Lc31I7b8fo0yk
 ELbemIDoNpNg5mTeB7/x2I8WHG6ZfGF3FCHpTvf09RHV/MyORANBYckDWRbmsEAgDcQS
 Hur3ihpVCLaNLuksIo0l5XJnkr02usQNOBFMTd57PGxGV4H43WTZGL5yJ/ORtdH/GnbK
 V5r2pAVFAfpiVAnZVeVuLI03mS/Y4QJmOdTbFA6KT9X4rCMMQxdxAyWQ6YvR0ItTynfp
 /PqmhQYSOfiLWowceUALYMSfEEGqPWY5STnT4tzCq+FY56L/12T2+ymO1lRz6PBcoiNQ xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u8has9sjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2019 14:47:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x78Egv9C100142
        for <linux-xfs@vger.kernel.org>; Thu, 8 Aug 2019 14:47:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2u75bxrsf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2019 14:47:03 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x78El3Yk007354
        for <linux-xfs@vger.kernel.org>; Thu, 8 Aug 2019 14:47:03 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Aug 2019 07:47:03 -0700
Subject: [PATCH 2/3] xfs: remove more ondisk directory corruption asserts
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 08 Aug 2019 07:47:02 -0700
Message-ID: <156527562244.1960675.10725983010213633067.stgit@magnolia>
In-Reply-To: <156527561023.1960675.17007470833732765300.stgit@magnolia>
References: <156527561023.1960675.17007470833732765300.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=6 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=864
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=6 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=908 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Continue our game of replacing ASSERTs for corrupt ondisk metadata with
EFSCORRUPTED returns.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c  |   19 ++++++++++++-------
 fs/xfs/libxfs/xfs_dir2_node.c |    3 ++-
 2 files changed, 14 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index d1c77fd0815d..0bf56e94bfe9 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -487,10 +487,8 @@ xfs_da3_split(
 	ASSERT(state->path.active == 0);
 	oldblk = &state->path.blk[0];
 	error = xfs_da3_root_split(state, oldblk, addblk);
-	if (error) {
-		addblk->bp = NULL;
-		return error;	/* GROT: dir is inconsistent */
-	}
+	if (error)
+		goto out;
 
 	/*
 	 * Update pointers to the node which used to be block 0 and just got
@@ -505,7 +503,10 @@ xfs_da3_split(
 	 */
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
-		ASSERT(be32_to_cpu(node->hdr.info.forw) == addblk->blkno);
+		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
 		node = addblk->bp->b_addr;
 		node->hdr.info.back = cpu_to_be32(oldblk->blkno);
 		xfs_trans_log_buf(state->args->trans, addblk->bp,
@@ -514,15 +515,19 @@ xfs_da3_split(
 	}
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.back) {
-		ASSERT(be32_to_cpu(node->hdr.info.back) == addblk->blkno);
+		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
 		node = addblk->bp->b_addr;
 		node->hdr.info.forw = cpu_to_be32(oldblk->blkno);
 		xfs_trans_log_buf(state->args->trans, addblk->bp,
 				  XFS_DA_LOGRANGE(node, &node->hdr.info,
 				  sizeof(node->hdr.info)));
 	}
+out:
 	addblk->bp = NULL;
-	return 0;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index afcc6642690a..1fc44efc344d 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -741,7 +741,8 @@ xfs_dir2_leafn_lookup_for_entry(
 	ents = dp->d_ops->leaf_ents_p(leaf);
 
 	xfs_dir3_leaf_check(dp, bp);
-	ASSERT(leafhdr.count > 0);
+	if (leafhdr.count <= 0)
+		return -EFSCORRUPTED;
 
 	/*
 	 * Look up the hash value in the leaf entries.

