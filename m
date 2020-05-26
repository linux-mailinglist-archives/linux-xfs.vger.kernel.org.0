Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6885F1BED1B
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Apr 2020 02:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgD3As2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Apr 2020 20:48:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45692 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgD3As1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 20:48:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0J8KH151044
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=S5BwpzqoCjVaZrdoy3t+NR0KLNUdRQYAm5QYQKnb4/A=;
 b=pgWRKVeoWBM69lGvqjGu3qcl4g2/O0igN0OeVH2LlCxPuQUUQzzI2Ip3ps5AMbCPp/rH
 h8k5NxLzy2d5yeZ5zLSFvcnIdZs7tsIsVGyjB/VXcWjPSmHPrCdENI7q8OZIi2PAvIeT
 CIcDsnNcUxuCnkUQnw47Hi43eY5eOfLWEDB9cTClh0N45QtSm5+5J8V7QH3Q45qOVnL2
 dneI6i6Dt39uN2iYgm+Pe2gjtsv6q524a4SAzrnCaxo6Ia+aVwzO64O+4hqKgrpFp4BC
 aCYR/eMVCPYzKzs88Spu7JkOh3D00+3aUB2j73cWuc9EUflQg2zbLsZH4TfzjuC8FphH 7Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucg8q89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U0kk5h087500
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30mxpma4pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:23 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03U0mMlS009449
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 00:48:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Apr 2020 17:48:21 -0700
Subject: [PATCH 07/21] xfs: refactor log recovery icreate item dispatch for
 pass2 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 29 Apr 2020 17:48:20 -0700
Message-ID: <158820770082.467894.7639027771832654915.stgit@magnolia>
In-Reply-To: <158820765488.467894.15408191148091671053.stgit@magnolia>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=1 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the log icreate item pass2 commit code into the per-item source code
files and use the dispatch function to call it.  We do these one at a
time because there's a lot of code to move.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icreate_item.c |  132 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c  |  126 -------------------------------------------
 2 files changed, 132 insertions(+), 126 deletions(-)


diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 9f38a3c200a3..602a8c91371f 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -6,13 +6,19 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_icreate_item.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_ialloc.h"
+#include "xfs_trace.h"
 
 kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
 
@@ -117,6 +123,132 @@ xlog_icreate_reorder(
 	return XLOG_REORDER_BUFFER_LIST;
 }
 
+/*
+ * This routine is called when an inode create format structure is found in a
+ * committed transaction in the log.  It's purpose is to initialise the inodes
+ * being allocated on disk. This requires us to get inode cluster buffers that
+ * match the range to be initialised, stamped with inode templates and written
+ * by delayed write so that subsequent modifications will hit the cached buffer
+ * and only need writing out at the end of recovery.
+ */
+STATIC int
+xlog_recover_do_icreate_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_icreate_log		*icl;
+	struct xfs_ino_geometry		*igeo = M_IGEO(mp);
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	unsigned int			count;
+	unsigned int			isize;
+	xfs_agblock_t			length;
+	int				bb_per_cluster;
+	int				cancel_count;
+	int				nbufs;
+	int				i;
+
+	icl = (struct xfs_icreate_log *)item->ri_buf[0].i_addr;
+	if (icl->icl_type != XFS_LI_ICREATE) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad type");
+		return -EINVAL;
+	}
+
+	if (icl->icl_size != 1) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad icl size");
+		return -EINVAL;
+	}
+
+	agno = be32_to_cpu(icl->icl_ag);
+	if (agno >= mp->m_sb.sb_agcount) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agno");
+		return -EINVAL;
+	}
+	agbno = be32_to_cpu(icl->icl_agbno);
+	if (!agbno || agbno == NULLAGBLOCK || agbno >= mp->m_sb.sb_agblocks) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agbno");
+		return -EINVAL;
+	}
+	isize = be32_to_cpu(icl->icl_isize);
+	if (isize != mp->m_sb.sb_inodesize) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad isize");
+		return -EINVAL;
+	}
+	count = be32_to_cpu(icl->icl_count);
+	if (!count) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count");
+		return -EINVAL;
+	}
+	length = be32_to_cpu(icl->icl_length);
+	if (!length || length >= mp->m_sb.sb_agblocks) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad length");
+		return -EINVAL;
+	}
+
+	/*
+	 * The inode chunk is either full or sparse and we only support
+	 * m_ino_geo.ialloc_min_blks sized sparse allocations at this time.
+	 */
+	if (length != igeo->ialloc_blks &&
+	    length != igeo->ialloc_min_blks) {
+		xfs_warn(log->l_mp,
+			 "%s: unsupported chunk length", __FUNCTION__);
+		return -EINVAL;
+	}
+
+	/* verify inode count is consistent with extent length */
+	if ((count >> mp->m_sb.sb_inopblog) != length) {
+		xfs_warn(log->l_mp,
+			 "%s: inconsistent inode count and chunk length",
+			 __FUNCTION__);
+		return -EINVAL;
+	}
+
+	/*
+	 * The icreate transaction can cover multiple cluster buffers and these
+	 * buffers could have been freed and reused. Check the individual
+	 * buffers for cancellation so we don't overwrite anything written after
+	 * a cancellation.
+	 */
+	bb_per_cluster = XFS_FSB_TO_BB(mp, igeo->blocks_per_cluster);
+	nbufs = length / igeo->blocks_per_cluster;
+	for (i = 0, cancel_count = 0; i < nbufs; i++) {
+		xfs_daddr_t	daddr;
+
+		daddr = XFS_AGB_TO_DADDR(mp, agno,
+				agbno + i * igeo->blocks_per_cluster);
+		if (xlog_is_buffer_cancelled(log, daddr, bb_per_cluster))
+			cancel_count++;
+	}
+
+	/*
+	 * We currently only use icreate for a single allocation at a time. This
+	 * means we should expect either all or none of the buffers to be
+	 * cancelled. Be conservative and skip replay if at least one buffer is
+	 * cancelled, but warn the user that something is awry if the buffers
+	 * are not consistent.
+	 *
+	 * XXX: This must be refined to only skip cancelled clusters once we use
+	 * icreate for multiple chunk allocations.
+	 */
+	ASSERT(!cancel_count || cancel_count == nbufs);
+	if (cancel_count) {
+		if (cancel_count != nbufs)
+			xfs_warn(mp,
+	"WARNING: partial inode chunk cancellation, skipped icreate.");
+		trace_xfs_log_recover_icreate_cancel(log, icl);
+		return 0;
+	}
+
+	trace_xfs_log_recover_icreate_recover(log, icl);
+	return xfs_ialloc_inode_init(mp, NULL, buffer_list, count, agno, agbno,
+				     length, be32_to_cpu(icl->icl_gen));
+}
+
 const struct xlog_recover_item_type xlog_icreate_item_type = {
 	.reorder_fn		= xlog_icreate_reorder,
+	.commit_pass2_fn	= xlog_recover_do_icreate_commit_pass2,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 58a54d9e6847..6ba3d64d08de 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2489,130 +2489,6 @@ xlog_recover_bud_pass2(
 	return 0;
 }
 
-/*
- * This routine is called when an inode create format structure is found in a
- * committed transaction in the log.  It's purpose is to initialise the inodes
- * being allocated on disk. This requires us to get inode cluster buffers that
- * match the range to be initialised, stamped with inode templates and written
- * by delayed write so that subsequent modifications will hit the cached buffer
- * and only need writing out at the end of recovery.
- */
-STATIC int
-xlog_recover_do_icreate_pass2(
-	struct xlog		*log,
-	struct list_head	*buffer_list,
-	xlog_recover_item_t	*item)
-{
-	struct xfs_mount	*mp = log->l_mp;
-	struct xfs_icreate_log	*icl;
-	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
-	xfs_agnumber_t		agno;
-	xfs_agblock_t		agbno;
-	unsigned int		count;
-	unsigned int		isize;
-	xfs_agblock_t		length;
-	int			bb_per_cluster;
-	int			cancel_count;
-	int			nbufs;
-	int			i;
-
-	icl = (struct xfs_icreate_log *)item->ri_buf[0].i_addr;
-	if (icl->icl_type != XFS_LI_ICREATE) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad type");
-		return -EINVAL;
-	}
-
-	if (icl->icl_size != 1) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad icl size");
-		return -EINVAL;
-	}
-
-	agno = be32_to_cpu(icl->icl_ag);
-	if (agno >= mp->m_sb.sb_agcount) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agno");
-		return -EINVAL;
-	}
-	agbno = be32_to_cpu(icl->icl_agbno);
-	if (!agbno || agbno == NULLAGBLOCK || agbno >= mp->m_sb.sb_agblocks) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agbno");
-		return -EINVAL;
-	}
-	isize = be32_to_cpu(icl->icl_isize);
-	if (isize != mp->m_sb.sb_inodesize) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad isize");
-		return -EINVAL;
-	}
-	count = be32_to_cpu(icl->icl_count);
-	if (!count) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count");
-		return -EINVAL;
-	}
-	length = be32_to_cpu(icl->icl_length);
-	if (!length || length >= mp->m_sb.sb_agblocks) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad length");
-		return -EINVAL;
-	}
-
-	/*
-	 * The inode chunk is either full or sparse and we only support
-	 * m_ino_geo.ialloc_min_blks sized sparse allocations at this time.
-	 */
-	if (length != igeo->ialloc_blks &&
-	    length != igeo->ialloc_min_blks) {
-		xfs_warn(log->l_mp,
-			 "%s: unsupported chunk length", __FUNCTION__);
-		return -EINVAL;
-	}
-
-	/* verify inode count is consistent with extent length */
-	if ((count >> mp->m_sb.sb_inopblog) != length) {
-		xfs_warn(log->l_mp,
-			 "%s: inconsistent inode count and chunk length",
-			 __FUNCTION__);
-		return -EINVAL;
-	}
-
-	/*
-	 * The icreate transaction can cover multiple cluster buffers and these
-	 * buffers could have been freed and reused. Check the individual
-	 * buffers for cancellation so we don't overwrite anything written after
-	 * a cancellation.
-	 */
-	bb_per_cluster = XFS_FSB_TO_BB(mp, igeo->blocks_per_cluster);
-	nbufs = length / igeo->blocks_per_cluster;
-	for (i = 0, cancel_count = 0; i < nbufs; i++) {
-		xfs_daddr_t	daddr;
-
-		daddr = XFS_AGB_TO_DADDR(mp, agno,
-				agbno + i * igeo->blocks_per_cluster);
-		if (xlog_is_buffer_cancelled(log, daddr, bb_per_cluster))
-			cancel_count++;
-	}
-
-	/*
-	 * We currently only use icreate for a single allocation at a time. This
-	 * means we should expect either all or none of the buffers to be
-	 * cancelled. Be conservative and skip replay if at least one buffer is
-	 * cancelled, but warn the user that something is awry if the buffers
-	 * are not consistent.
-	 *
-	 * XXX: This must be refined to only skip cancelled clusters once we use
-	 * icreate for multiple chunk allocations.
-	 */
-	ASSERT(!cancel_count || cancel_count == nbufs);
-	if (cancel_count) {
-		if (cancel_count != nbufs)
-			xfs_warn(mp,
-	"WARNING: partial inode chunk cancellation, skipped icreate.");
-		trace_xfs_log_recover_icreate_cancel(log, icl);
-		return 0;
-	}
-
-	trace_xfs_log_recover_icreate_recover(log, icl);
-	return xfs_ialloc_inode_init(mp, NULL, buffer_list, count, agno, agbno,
-				     length, be32_to_cpu(icl->icl_gen));
-}
-
 STATIC int
 xlog_recover_commit_pass1(
 	struct xlog			*log,
@@ -2662,8 +2538,6 @@ xlog_recover_commit_pass2(
 		return xlog_recover_bui_pass2(log, item, trans->r_lsn);
 	case XFS_LI_BUD:
 		return xlog_recover_bud_pass2(log, item);
-	case XFS_LI_ICREATE:
-		return xlog_recover_do_icreate_pass2(log, buffer_list, item);
 	case XFS_LI_QUOTAOFF:
 		/* nothing to do in pass2 */
 		return 0;

