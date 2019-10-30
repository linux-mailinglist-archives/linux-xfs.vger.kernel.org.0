Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A83B0E9398
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Oct 2019 00:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfJ2Xaf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Oct 2019 19:30:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41868 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfJ2Xae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:30:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNShfM038166
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=TdUPsrdKWhum8pMbugdYLFZreQd50lGLiVyFDpuc+Io=;
 b=hWRBzn7SEf1qo3kF545adypoNR9Aw2aO93+qEEd3g3nGqYcNis8kDTWyNQnqUdV8sLPI
 zGhA3UUBG3KRiEfR+TKzSePf0i5QNKpP9dHTNrcpXTcEPb+ojUi9+28TWaNExJMJbAvr
 dLm54dS0efcv/31T8IWTQwBdeiRvhUIjPtbZH3FkHuNx01XeujhCZviLPaFg5veluwVg
 0PW+x5L0WggTEnZryobCRKvZEGlUQVMGes8lws0ywcKQunyBHZeQk+DhZlIEs7mm76r7
 2cqFB8ZdAR76zWazCve+yNUPemtAEQFSJFiw/hOk97rIRWV2EA5ORoe0KXFPSpBOM3ys UA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vxwhfgb2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNS6uk178630
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vxwj54w6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:30 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9TNUTQB006725
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2019 23:30:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:30:29 -0700
Subject: [PATCH 4/4] xfs: support staging cursors for per-AG btree types
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:30:28 -0700
Message-ID: <157239182846.1266747.3874603601415674314.stgit@magnolia>
In-Reply-To: <157239180345.1266747.1586648446090389492.stgit@magnolia>
References: <157239180345.1266747.1586648446090389492.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add support for btree staging cursors for the per-AG btree types.  This
is needed both for online repair and also to convert xfs_repair to use
btree bulk loading.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |   97 ++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_alloc_btree.h    |    7 +++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   84 +++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    6 ++
 fs/xfs/libxfs/xfs_refcount_btree.c |   69 ++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_refcount_btree.h |    7 +++
 fs/xfs/libxfs/xfs_rmap_btree.c     |   66 +++++++++++++++++++++---
 fs/xfs/libxfs/xfs_rmap_btree.h     |    6 ++
 8 files changed, 294 insertions(+), 48 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 2a94543857a1..4d6968437c29 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -471,6 +471,40 @@ static const struct xfs_btree_ops xfs_cntbt_ops = {
 	.recs_inorder		= xfs_cntbt_recs_inorder,
 };
 
+/* Allocate most of a new allocation btree cursor. */
+STATIC struct xfs_btree_cur *
+xfs_allocbt_init_common(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
+
+	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
+
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
+
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_btnum = btnum;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+	cur->bc_private.a.agno = agno;
+
+	if (btnum == XFS_BTNUM_CNT) {
+		cur->bc_ops = &xfs_cntbt_ops;
+		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
+	} else {
+		cur->bc_ops = &xfs_bnobt_ops;
+		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
+	}
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
+
+	return cur;
+}
+
 /*
  * Allocate a new allocation btree cursor.
  */
@@ -485,35 +519,64 @@ xfs_allocbt_init_cursor(
 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
 	struct xfs_btree_cur	*cur;
 
-	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
-
-	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
-
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
-	cur->bc_btnum = btnum;
-	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-
+	cur = xfs_allocbt_init_common(mp, tp, agno, btnum);
 	if (btnum == XFS_BTNUM_CNT) {
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
-		cur->bc_ops = &xfs_cntbt_ops;
 		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
-		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
+		cur->bc_flags |= XFS_BTREE_LASTREC_UPDATE;
 	} else {
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
-		cur->bc_ops = &xfs_bnobt_ops;
 		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
 	}
 
 	cur->bc_private.a.agbp = agbp;
-	cur->bc_private.a.agno = agno;
 
-	if (xfs_sb_version_hascrc(&mp->m_sb))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
+	return cur;
+}
+
+/* Create a free space btree cursor with a fake root for staging. */
+struct xfs_btree_cur *
+xfs_allocbt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xbtree_afakeroot	*afake,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
 
+	cur = xfs_allocbt_init_common(mp, tp, agno, btnum);
+	if (btnum == XFS_BTNUM_BNO)
+		xfs_btree_stage_afakeroot(cur, afake, NULL);
+	else
+		xfs_btree_stage_afakeroot(cur, afake, NULL);
 	return cur;
 }
 
+/*
+ * Install a new free space btree root.  Caller is responsible for invalidating
+ * and freeing the old btree blocks.
+ */
+void
+xfs_allocbt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*agbp)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xbtree_afakeroot	*afake = cur->bc_private.a.afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	agf->agf_roots[cur->bc_btnum] = cpu_to_be32(afake->af_root);
+	agf->agf_levels[cur->bc_btnum] = cpu_to_be32(afake->af_levels);
+	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
+
+	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+		xfs_btree_commit_afakeroot(cur, agbp, &xfs_bnobt_ops);
+	} else {
+		cur->bc_flags |= XFS_BTREE_LASTREC_UPDATE;
+		xfs_btree_commit_afakeroot(cur, agbp, &xfs_cntbt_ops);
+	}
+}
+
 /*
  * Calculate number of records in an alloc btree block.
  */
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index c9305ebb69f6..dde324609a89 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
@@ -13,6 +13,7 @@
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
+struct xbtree_afakeroot;
 
 /*
  * Btree block header size depends on a superblock flag.
@@ -48,8 +49,14 @@ struct xfs_mount;
 extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *,
 		xfs_agnumber_t, xfs_btnum_t);
+struct xfs_btree_cur *xfs_allocbt_stage_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xbtree_afakeroot *afake,
+		xfs_agnumber_t agno, xfs_btnum_t btnum);
 extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
 extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
+void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_buf *agbp);
+
 #endif	/* __XFS_ALLOC_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index b82992f795aa..15d8ec692a6e 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -400,32 +400,27 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 };
 
 /*
- * Allocate a new inode btree cursor.
+ * Initialize a new inode btree cursor.
  */
-struct xfs_btree_cur *				/* new inode btree cursor */
-xfs_inobt_init_cursor(
+static struct xfs_btree_cur *
+xfs_inobt_init_common(
 	struct xfs_mount	*mp,		/* file system mount point */
 	struct xfs_trans	*tp,		/* transaction pointer */
-	struct xfs_buf		*agbp,		/* buffer for agi structure */
 	xfs_agnumber_t		agno,		/* allocation group number */
 	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
 {
-	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
 	struct xfs_btree_cur	*cur;
 
 	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
-
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
 	if (btnum == XFS_BTNUM_INO) {
-		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
-		cur->bc_ops = &xfs_inobt_ops;
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
+		cur->bc_ops = &xfs_inobt_ops;
 	} else {
-		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
-		cur->bc_ops = &xfs_finobt_ops;
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
+		cur->bc_ops = &xfs_finobt_ops;
 	}
 
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
@@ -433,12 +428,79 @@ xfs_inobt_init_cursor(
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_private.a.agbp = agbp;
 	cur->bc_private.a.agno = agno;
+	return cur;
+}
 
+/* Create an inode btree cursor. */
+struct xfs_btree_cur *
+xfs_inobt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+
+	cur = xfs_inobt_init_common(mp, tp, agno, btnum);
+	if (btnum == XFS_BTNUM_INO)
+		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
+	else
+		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
+	cur->bc_private.a.agbp = agbp;
 	return cur;
 }
 
+/* Create an inode btree cursor with a fake root for staging. */
+struct xfs_btree_cur *
+xfs_inobt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xbtree_afakeroot	*afake,
+	xfs_agnumber_t		agno,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_inobt_init_common(mp, tp, agno, btnum);
+	if (btnum == XFS_BTNUM_INO)
+		xfs_btree_stage_afakeroot(cur, afake, NULL);
+	else
+		xfs_btree_stage_afakeroot(cur, afake, NULL);
+	return cur;
+}
+
+/*
+ * Install a new inobt btree root.  Caller is responsible for invalidating
+ * and freeing the old btree blocks.
+ */
+void
+xfs_inobt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*agbp)
+{
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agbp);
+	struct xbtree_afakeroot	*afake = cur->bc_private.a.afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	if (cur->bc_btnum == XFS_BTNUM_INO) {
+		agi->agi_root = cpu_to_be32(afake->af_root);
+		agi->agi_level = cpu_to_be32(afake->af_levels);
+		xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_ROOT |
+						     XFS_AGI_LEVEL);
+		xfs_btree_commit_afakeroot(cur, agbp, &xfs_inobt_ops);
+	} else {
+		agi->agi_free_root = cpu_to_be32(afake->af_root);
+		agi->agi_free_level = cpu_to_be32(afake->af_levels);
+		xfs_ialloc_log_agi(cur->bc_tp, agbp, XFS_AGI_FREE_ROOT |
+						     XFS_AGI_FREE_LEVEL);
+		xfs_btree_commit_afakeroot(cur, agbp, &xfs_finobt_ops);
+	}
+}
+
 /*
  * Calculate number of records in an inobt btree block.
  */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 951305ecaae1..9265b3e08c69 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -48,6 +48,9 @@ struct xfs_mount;
 extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *,
 		struct xfs_trans *, struct xfs_buf *, xfs_agnumber_t,
 		xfs_btnum_t);
+struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xbtree_afakeroot *afake,
+		xfs_agnumber_t agno, xfs_btnum_t btnum);
 extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
 
 /* ir_holemask to inode allocation bitmap conversion */
@@ -68,4 +71,7 @@ int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, xfs_btnum_t btnum,
 		struct xfs_btree_cur **curpp, struct xfs_buf **agi_bpp);
 
+void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_buf *agbp);
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 38529dbacd55..9034b40bd5cf 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -311,41 +311,90 @@ static const struct xfs_btree_ops xfs_refcountbt_ops = {
 };
 
 /*
- * Allocate a new refcount btree cursor.
+ * Initialize a new refcount btree cursor.
  */
-struct xfs_btree_cur *
-xfs_refcountbt_init_cursor(
+static struct xfs_btree_cur *
+xfs_refcountbt_init_common(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
 	xfs_agnumber_t		agno)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
 	struct xfs_btree_cur	*cur;
 
 	ASSERT(agno != NULLAGNUMBER);
 	ASSERT(agno < mp->m_sb.sb_agcount);
-	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
 
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = XFS_BTNUM_REFC;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-	cur->bc_ops = &xfs_refcountbt_ops;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
-	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
-
-	cur->bc_private.a.agbp = agbp;
 	cur->bc_private.a.agno = agno;
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	cur->bc_private.a.priv.refc.nr_ops = 0;
 	cur->bc_private.a.priv.refc.shape_changes = 0;
+	cur->bc_ops = &xfs_refcountbt_ops;
+	return cur;
+}
+
+/* Create a btree cursor. */
+struct xfs_btree_cur *
+xfs_refcountbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_btree_cur	*cur;
 
+	cur = xfs_refcountbt_init_common(mp, tp, agno);
+	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
+	cur->bc_private.a.agbp = agbp;
 	return cur;
 }
 
+/* Create a btree cursor with a fake root for staging. */
+struct xfs_btree_cur *
+xfs_refcountbt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xbtree_afakeroot	*afake,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_refcountbt_init_common(mp, tp, agno);
+	xfs_btree_stage_afakeroot(cur, afake, NULL);
+	return cur;
+}
+
+/*
+ * Swap in the new btree root.  Once we pass this point the newly rebuilt btree
+ * is in place and we have to kill off all the old btree blocks.
+ */
+void
+xfs_refcountbt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*agbp)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xbtree_afakeroot	*afake = cur->bc_private.a.afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	agf->agf_refcount_root = cpu_to_be32(afake->af_root);
+	agf->agf_refcount_level = cpu_to_be32(afake->af_levels);
+	agf->agf_refcount_blocks = cpu_to_be32(afake->af_blocks);
+	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS |
+					    XFS_AGF_REFCOUNT_ROOT |
+					    XFS_AGF_REFCOUNT_LEVEL);
+	xfs_btree_commit_afakeroot(cur, agbp, &xfs_refcountbt_ops);
+}
+
 /*
  * Calculate the number of records in a refcount btree block.
  */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index ba416f71c824..978b714be9f4 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -13,6 +13,7 @@
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
+struct xbtree_afakeroot;
 
 /*
  * Btree block header size
@@ -46,6 +47,9 @@ struct xfs_mount;
 extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *agbp,
 		xfs_agnumber_t agno);
+struct xfs_btree_cur *xfs_refcountbt_stage_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xbtree_afakeroot *afake,
+		xfs_agnumber_t agno);
 extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
 extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
 
@@ -58,4 +62,7 @@ extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
 		struct xfs_trans *tp, xfs_agnumber_t agno, xfs_extlen_t *ask,
 		xfs_extlen_t *used);
 
+void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_buf *agbp);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index fc78efa52c94..062aeaaa7a8c 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -448,17 +448,12 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
 };
 
-/*
- * Allocate a new allocation btree cursor.
- */
-struct xfs_btree_cur *
-xfs_rmapbt_init_cursor(
+static struct xfs_btree_cur *
+xfs_rmapbt_init_common(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
 	xfs_agnumber_t		agno)
 {
-	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
 	struct xfs_btree_cur	*cur;
 
 	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
@@ -468,16 +463,67 @@ xfs_rmapbt_init_cursor(
 	cur->bc_btnum = XFS_BTNUM_RMAP;
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
-	cur->bc_ops = &xfs_rmapbt_ops;
-	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
+	cur->bc_private.a.agno = agno;
+	cur->bc_ops = &xfs_rmapbt_ops;
 
+	return cur;
+}
+
+/* Create a new reverse mapping btree cursor. */
+struct xfs_btree_cur *
+xfs_rmapbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_rmapbt_init_common(mp, tp, agno);
+	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
 	cur->bc_private.a.agbp = agbp;
-	cur->bc_private.a.agno = agno;
+	return cur;
+}
+
+/* Create a new reverse mapping btree cursor with a fake root for staging. */
+struct xfs_btree_cur *
+xfs_rmapbt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xbtree_afakeroot	*afake,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_btree_cur	*cur;
 
+	cur = xfs_rmapbt_init_common(mp, tp, agno);
+	xfs_btree_stage_afakeroot(cur, afake, NULL);
 	return cur;
 }
 
+/*
+ * Install a new reverse mapping btree root.  Caller is responsible for
+ * invalidating and freeing the old btree blocks.
+ */
+void
+xfs_rmapbt_commit_staged_btree(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*agbp)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xbtree_afakeroot	*afake = cur->bc_private.a.afake;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	agf->agf_roots[cur->bc_btnum] = cpu_to_be32(afake->af_root);
+	agf->agf_levels[cur->bc_btnum] = cpu_to_be32(afake->af_levels);
+	agf->agf_rmap_blocks = cpu_to_be32(afake->af_blocks);
+	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS |
+					    XFS_AGF_RMAP_BLOCKS);
+	xfs_btree_commit_afakeroot(cur, agbp, &xfs_rmapbt_ops);
+}
+
 /*
  * Calculate number of records in an rmap btree block.
  */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 820d668b063d..c6785c7851a8 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -9,6 +9,7 @@
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
+struct xbtree_afakeroot;
 
 /* rmaps only exist on crc enabled filesystems */
 #define XFS_RMAP_BLOCK_LEN	XFS_BTREE_SBLOCK_CRC_LEN
@@ -43,6 +44,11 @@ struct xfs_mount;
 struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
 				struct xfs_trans *tp, struct xfs_buf *bp,
 				xfs_agnumber_t agno);
+struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xbtree_afakeroot *afake,
+		xfs_agnumber_t agno);
+void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
+		struct xfs_buf *agbp);
 int xfs_rmapbt_maxrecs(int blocklen, int leaf);
 extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
 

