Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39A09F25C3
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2019 04:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfKGDDv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 6 Nov 2019 22:03:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45852 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732304AbfKGDDv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:03:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72x43S049374
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=SK/5Wwdir6K7kPAxJyjbOfh3g5ki/5gPiJiLZKo4kPU=;
 b=dgi7XH0yg/Q2tXafToTubu5PeKA7gcJMlFstf7EMGI3cMM9ROJ6HyiV8VbHYBg7t/HBH
 pwR1CLUen/JAMVVZgzW3MPfklTCzKL3BTuzGfD3d2JXtemJHGfvfy9pROoWdUlB/8Pys
 fEN73iJlVdjaLhdwBfsTK5kEufRiuzQaEOBwxve9gJLrGtO5cPFkf9VI+XMYdrAUNjhx
 9giQS3UnTU++W5toYBoWKznGcDXy5C+9tL0q/Bvu/s4fPqs4wQupsBFquGY+ucgfv+GP
 tKuGNvfjIx6JTFcYtPVzdZ+zL+Qx8TV+9yDd3QR/jlzov7t6/6HW5lWQU/9mAO4r5QHs tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2w41w130h6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:03:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA733jat180799
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2w41wds6jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:03:47 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA733Hi7029147
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:03:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:03:17 -0800
Subject: [PATCH 02/10] xfs: report ag header corruption errors to the health
 tracking system
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 06 Nov 2019 19:03:16 -0800
Message-ID: <157309579646.46704.15079864547473525944.stgit@magnolia>
In-Reply-To: <157309578380.46704.8292405543138526332.stgit@magnolia>
References: <157309578380.46704.8292405543138526332.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Whenever we encounter a corrupt AG header, we should report that to the
health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c    |    6 ++++++
 fs/xfs/libxfs/xfs_health.h   |   14 +++++++++++---
 fs/xfs/libxfs/xfs_ialloc.c   |    3 +++
 fs/xfs/libxfs/xfs_refcount.c |    1 +
 fs/xfs/libxfs/xfs_rmap.c     |    1 +
 fs/xfs/libxfs/xfs_sb.c       |    2 ++
 fs/xfs/xfs_health.c          |   17 +++++++++++++++++
 fs/xfs/xfs_inode.c           |    9 +++++++++
 8 files changed, 50 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 4ba5557f4ae0..fda1185aa63c 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_log.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 extern kmem_zone_t	*xfs_bmap_free_item_zone;
 
@@ -694,6 +695,8 @@ xfs_alloc_read_agfl(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_agfl_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGFL);
 	if (error)
 		return error;
 	xfs_buf_set_ref(bp, XFS_AGFL_REF);
@@ -717,6 +720,7 @@ xfs_alloc_update_counters(
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
 		     be32_to_cpu(agf->agf_length))) {
 		xfs_buf_corruption_error(agbp);
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
 		return -EFSCORRUPTED;
 	}
 
@@ -2934,6 +2938,8 @@ xfs_read_agf(
 			mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), flags, bpp, &xfs_agf_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGF);
 	if (error)
 		return error;
 	if (!*bpp)
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 96919a257870..ce8954a10c66 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -26,9 +26,11 @@
  * and the "sick" field tells us if that piece was found to need repairs.
  * Therefore we can conclude that for a given sick flag value:
  *
- *  - checked && sick  => metadata needs repair
- *  - checked && !sick => metadata is ok
- *  - !checked         => has not been examined since mount
+ *  - checked && sick   => metadata needs repair
+ *  - checked && !sick  => metadata is ok
+ *  - !checked && sick  => errors have been observed during normal operation,
+ *                         but the metadata has not been checked thoroughly
+ *  - !checked && !sick => has not been examined since mount
  */
 
 struct xfs_mount;
@@ -121,6 +123,8 @@ void xfs_rt_mark_healthy(struct xfs_mount *mp, unsigned int mask);
 void xfs_rt_measure_sickness(struct xfs_mount *mp, unsigned int *sick,
 		unsigned int *checked);
 
+void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
+		unsigned int mask);
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_checked(struct xfs_perag *pag, unsigned int mask);
 void xfs_ag_mark_healthy(struct xfs_perag *pag, unsigned int mask);
@@ -201,4 +205,8 @@ void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
 void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
+#define xfs_metadata_is_sick(error) \
+	(unlikely((error) == -EFSCORRUPTED || (error) == -EIO || \
+		  (error) == -EFSBADCRC))
+
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index cc29b61b35d7..cc552ac6721e 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_rmap.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2635,6 +2636,8 @@ xfs_read_agi(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, bpp, &xfs_agi_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
 	if (error)
 		return error;
 	if (tp)
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 2bcebd482488..a0068bc2738e 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1178,6 +1178,7 @@ xfs_refcount_finish_one(
 		if (error)
 			return error;
 		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
+			xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGF);
 			return -EFSCORRUPTED;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 869ac664f8fb..c12ec321040d 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2395,6 +2395,7 @@ xfs_rmap_finish_one(
 		if (error)
 			return error;
 		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
+			xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGF);
 			return -EFSCORRUPTED;
 		}
 
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 0ac69751fe85..4a923545465d 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1169,6 +1169,8 @@ xfs_sb_read_secondary(
 	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 			XFS_AG_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_SB);
 	if (error)
 		return error;
 	xfs_buf_set_ref(bp, XFS_SSB_REF);
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 860dc70c99e7..36c32b108b39 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -200,6 +200,23 @@ xfs_rt_measure_sickness(
 	spin_unlock(&mp->m_sb_lock);
 }
 
+/* Mark unhealthy per-ag metadata given a raw AG number. */
+void
+xfs_agno_mark_sick(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	unsigned int		mask)
+{
+	struct xfs_perag	*pag = xfs_perag_get(mp, agno);
+
+	/* per-ag structure not set up yet? */
+	if (!pag)
+		return;
+
+	xfs_ag_mark_sick(pag, mask);
+	xfs_perag_put(pag);
+}
+
 /* Mark unhealthy per-ag metadata. */
 void
 xfs_ag_mark_sick(
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a92d4521748d..d02246e2fb21 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -35,6 +35,7 @@
 #include "xfs_log.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_reflink.h"
+#include "xfs_health.h"
 
 kmem_zone_t *xfs_inode_zone;
 
@@ -787,6 +788,8 @@ xfs_ialloc(
 	 */
 	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
 		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
+		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
+				XFS_SICK_AG_INOBT);
 		return -EFSCORRUPTED;
 	}
 
@@ -2138,6 +2141,7 @@ xfs_iunlink_update_bucket(
 	 */
 	if (old_value == new_agino) {
 		xfs_buf_corruption_error(agibp);
+		xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 
@@ -2204,6 +2208,7 @@ xfs_iunlink_update_inode(
 	if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
 				sizeof(*dip), __this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -2218,6 +2223,7 @@ xfs_iunlink_update_inode(
 		if (next_agino != NULLAGINO) {
 			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
 					dip, sizeof(*dip), __this_address);
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 			error = -EFSCORRUPTED;
 		}
 		goto out;
@@ -2272,6 +2278,7 @@ xfs_iunlink(
 	if (next_agino == agino ||
 	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
 		xfs_buf_corruption_error(agibp);
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 
@@ -2409,6 +2416,7 @@ xfs_iunlink_map_prev(
 			XFS_CORRUPTION_ERROR(__func__,
 					XFS_ERRLEVEL_LOW, mp,
 					*dipp, sizeof(**dipp));
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 			error = -EFSCORRUPTED;
 			return error;
 		}
@@ -2455,6 +2463,7 @@ xfs_iunlink_remove(
 	if (!xfs_verify_agino(mp, agno, head_agino)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				agi, sizeof(*agi));
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
 		return -EFSCORRUPTED;
 	}
 

