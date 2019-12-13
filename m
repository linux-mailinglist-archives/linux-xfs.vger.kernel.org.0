Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A4411E7D5
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2019 17:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbfLMQOA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 Dec 2019 11:14:00 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59348 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfLMQOA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Dec 2019 11:14:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDG9YcW075398;
        Fri, 13 Dec 2019 16:13:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=dqA608+zZxM2aN/ciC7jzD+isbNfWh5l+87W5aPzcrs=;
 b=D8JgShJwBYCwNMh+km4KxQ35e34hB6lnWUkmmGPFmkKmInoYEiAtIg85fB/TpnOopfXh
 YBkwDeACh6LHQ/8zsqF7flYTCSPY4rtxc3CB6vbYyBs3PpRZAGSOSWaP0lMaDZhpUn3/
 VIdSYx2v+Nyc/WtJBgs7iw/oeC7RtlIQHVznJoqDhHGZAfBqrSScneSt79rBMfZJ0Yuj
 8RunhD/QmNAIOMJkG/S/Q2hJqKoy/5xxWwhGy7RbtDsR8pgIGZQMYj49QgdQjkpHMsEU
 GLl2rCTmvewwBDHRtZNe7bblHYdfumdCMW/WsGvb9Zrq280+U21IyQVHjBSe6RTFcDKs xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2wrw4npudh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 16:13:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBDGDeNZ155355;
        Fri, 13 Dec 2019 16:13:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2wvb997dhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Dec 2019 16:13:54 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBDGDr9n017526;
        Fri, 13 Dec 2019 16:13:53 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Dec 2019 08:13:52 -0800
Date:   Fri, 13 Dec 2019 08:13:49 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Alex Lyakas <alex@zadara.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2] xfs: don't commit sunit/swidth updates to disk if that
 would cause repair failures
Message-ID: <20191213161349.GH99875@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912130132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9470 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912130132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Alex Lyakas reported[1] that mounting an xfs filesystem with new sunit
and swidth values could cause xfs_repair to fail loudly.  The problem
here is that repair calculates the where mkfs should have allocated the
root inode, based on the superblock geometry.  The allocation decisions
depend on sunit, which means that we really can't go updating sunit if
it would lead to a subsequent repair failure on an otherwise correct
filesystem.

Port from xfs_repair some code that computes the location of the root
inode and teach mount to skip the ondisk update if it would cause
problems for repair.  Along the way we'll update the documentation,
provide a function for computing the minimum AGFL size instead of
open-coding it, and cut down some indenting in the mount code.

Note that we allow the mount to proceed (and new allocations will
reflect this new geometry) because we've never screened this kind of
thing before.  We'll have to wait for a new future incompat feature to
enforce correct behavior, alas.

Note that the geometry reporting always uses the superblock values, not
the incore ones, so that is what xfs_info and xfs_growfs will report.

[1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/T/#m00f9594b511e076e2fcdd489d78bc30216d72a7d

Reported-by: Alex Lyakas <alex@zadara.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: refactor the agfl length calculations, clarify the fsgeometry ioctl
behavior, fix a bunch of the comments and make it clearer how we compute
the rootino location
---
 fs/xfs/libxfs/xfs_alloc.c  |   18 ++++++---
 fs/xfs/libxfs/xfs_ialloc.c |   70 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.h |    1 
 fs/xfs/xfs_mount.c         |   90 ++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_trace.h         |   21 ++++++++++
 5 files changed, 166 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index c284e10af491..fc93fd88ec89 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2248,24 +2248,32 @@ xfs_alloc_longest_free_extent(
 	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
 }
 
+/*
+ * Compute the minimum length of the AGFL in the given AG.  If @pag is NULL,
+ * return the largest possible minimum length.
+ */
 unsigned int
 xfs_alloc_min_freelist(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag)
 {
+	/* AG btrees have at least 1 level. */
+	static const uint8_t	fake_levels[XFS_BTNUM_AGF] = {1, 1, 1};
+	const uint8_t		*levels = pag ? pag->pagf_levels : fake_levels;
 	unsigned int		min_free;
 
+	ASSERT(mp->m_ag_maxlevels > 0);
+
 	/* space needed by-bno freespace btree */
-	min_free = min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_BNOi] + 1,
+	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
 				       mp->m_ag_maxlevels);
 	/* space needed by-size freespace btree */
-	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_CNTi] + 1,
+	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
 				       mp->m_ag_maxlevels);
 	/* space needed reverse mapping used space btree */
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		min_free += min_t(unsigned int,
-				  pag->pagf_levels[XFS_BTNUM_RMAPi] + 1,
-				  mp->m_rmap_maxlevels);
+		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
+						mp->m_rmap_maxlevels);
 
 	return min_free;
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 988cde7744e6..7b4e76c75c58 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2909,3 +2909,73 @@ xfs_ialloc_setup_geometry(
 	else
 		igeo->ialloc_align = 0;
 }
+
+/*
+ * Compute the location of the root directory inode that is laid out by mkfs.
+ * The @sunit parameter will be copied from the superblock if it is negative.
+ */
+xfs_ino_t
+xfs_ialloc_calc_rootino(
+	struct xfs_mount	*mp,
+	int			sunit)
+{
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_agblock_t		first_bno;
+
+	if (sunit < 0)
+		sunit = mp->m_sb.sb_unit;
+
+	/*
+	 * Pre-calculate the geometry of AG 0.  We know what it looks like
+	 * because libxfs knows how to create allocation groups now.
+	 *
+	 * first_bno is the first block in which mkfs could possibly have
+	 * allocated the root directory inode, once we factor in the metadata
+	 * that mkfs formats before it.  Namely, the four AG headers...
+	 */
+	first_bno = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
+
+	/* ...the two free space btree roots... */
+	first_bno += 2;
+
+	/* ...the inode btree root... */
+	first_bno += 1;
+
+	/* ...the initial AGFL... */
+	first_bno += xfs_alloc_min_freelist(mp, NULL);
+
+	/* ...the free inode btree root... */
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		first_bno++;
+
+	/* ...the reverse mapping btree root... */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		first_bno++;
+
+	/* ...the reference count btree... */
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		first_bno++;
+
+	/*
+	 * ...and the log, if it is allocated in the first allocation group.
+	 *
+	 * This can happens with filesystems that only have a single
+	 * allocation group, or very odd geometries created by old mkfs
+	 * versions on very small filesystems.
+	 */
+	if (mp->m_sb.sb_logstart &&
+	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0)
+		 first_bno += mp->m_sb.sb_logblocks;
+
+	/*
+	 * Now round first_bno up to whatever allocation alignment is given
+	 * by the filesystem or was passed in.
+	 */
+	if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0)
+		first_bno = roundup(first_bno, sunit);
+	else if (xfs_sb_version_hasalign(&mp->m_sb) &&
+			mp->m_sb.sb_inoalignmt > 1)
+		first_bno = roundup(first_bno, mp->m_sb.sb_inoalignmt);
+
+	return XFS_AGINO_TO_INO(mp, 0, XFS_AGB_TO_AGINO(mp, first_bno));
+}
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 323592d563d5..72b3468b97b1 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -152,5 +152,6 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
 
 int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
+xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, int sunit);
 
 #endif	/* __XFS_IALLOC_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fca65109cf24..19e0c77bf64c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -31,7 +31,7 @@
 #include "xfs_reflink.h"
 #include "xfs_extent_busy.h"
 #include "xfs_health.h"
-
+#include "xfs_trace.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
@@ -359,13 +359,46 @@ xfs_readsb(
 	return error;
 }
 
+/*
+ * If the sunit/swidth change would move the precomputed root inode value, we
+ * must reject the ondisk change because repair will stumble over that.
+ * However, we allow the mount to proceed because we never rejected this
+ * combination before.
+ */
+static inline void
+xfs_check_new_dalign(
+	struct xfs_mount	*mp,
+	int			new_dalign)
+{
+	struct xfs_sb		*sbp = &mp->m_sb;
+	xfs_ino_t		calc_ino;
+
+	calc_ino = xfs_ialloc_calc_rootino(mp, new_dalign);
+	trace_xfs_check_new_dalign(mp, new_dalign, calc_ino);
+
+	if (sbp->sb_rootino == calc_ino)
+		return;
+
+	xfs_warn(mp,
+"Cannot change stripe alignment; would require moving root inode.");
+
+	/*
+	 * XXX: Next time we add a new incompat feature, this should start
+	 * returning -EINVAL.  Until then, spit out a warning that we're
+	 * ignoring the administrator's instructions.
+	 */
+	xfs_warn(mp, "Skipping superblock stripe alignment update.");
+	return;
+}
+
 /*
  * Update alignment values based on mount options and sb values
  */
 STATIC int
-xfs_update_alignment(xfs_mount_t *mp)
+xfs_update_alignment(
+	struct xfs_mount	*mp)
 {
-	xfs_sb_t	*sbp = &(mp->m_sb);
+	struct xfs_sb		*sbp = &mp->m_sb;
 
 	if (mp->m_dalign) {
 		/*
@@ -398,28 +431,26 @@ xfs_update_alignment(xfs_mount_t *mp)
 			}
 		}
 
-		/*
-		 * Update superblock with new values
-		 * and log changes
-		 */
-		if (xfs_sb_version_hasdalign(sbp)) {
-			if (sbp->sb_unit != mp->m_dalign) {
-				sbp->sb_unit = mp->m_dalign;
-				mp->m_update_sb = true;
-			}
-			if (sbp->sb_width != mp->m_swidth) {
-				sbp->sb_width = mp->m_swidth;
-				mp->m_update_sb = true;
-			}
-		} else {
+		/* Update superblock with new values and log changes. */
+		if (!xfs_sb_version_hasdalign(sbp)) {
 			xfs_warn(mp,
 	"cannot change alignment: superblock does not support data alignment");
 			return -EINVAL;
 		}
+
+		if (sbp->sb_unit == mp->m_dalign &&
+		    sbp->sb_width == mp->m_swidth)
+			return 0;
+
+		xfs_check_new_dalign(mp, mp->m_dalign);
+
+		sbp->sb_unit = mp->m_dalign;
+		sbp->sb_width = mp->m_swidth;
+		mp->m_update_sb = true;
 	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
 		    xfs_sb_version_hasdalign(&mp->m_sb)) {
-			mp->m_dalign = sbp->sb_unit;
-			mp->m_swidth = sbp->sb_width;
+		mp->m_dalign = sbp->sb_unit;
+		mp->m_swidth = sbp->sb_width;
 	}
 
 	return 0;
@@ -647,16 +678,6 @@ xfs_mountfs(
 		mp->m_update_sb = true;
 	}
 
-	/*
-	 * Check if sb_agblocks is aligned at stripe boundary
-	 * If sb_agblocks is NOT aligned turn off m_dalign since
-	 * allocator alignment is within an ag, therefore ag has
-	 * to be aligned at stripe boundary.
-	 */
-	error = xfs_update_alignment(mp);
-	if (error)
-		goto out;
-
 	xfs_alloc_compute_maxlevels(mp);
 	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
@@ -664,6 +685,17 @@ xfs_mountfs(
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
+	/*
+	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
+	 * is NOT aligned turn off m_dalign since allocator alignment is within
+	 * an ag, therefore ag has to be aligned at stripe boundary.  Note that
+	 * we must compute the free space and rmap btree geometry before doing
+	 * this.
+	 */
+	error = xfs_update_alignment(mp);
+	if (error)
+		goto out;
+
 	/* enable fail_at_unmount as default */
 	mp->m_fail_unmount = true;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c13bb3655e48..a86be7f807ee 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3573,6 +3573,27 @@ DEFINE_KMEM_EVENT(kmem_alloc_large);
 DEFINE_KMEM_EVENT(kmem_realloc);
 DEFINE_KMEM_EVENT(kmem_zone_alloc);
 
+TRACE_EVENT(xfs_check_new_dalign,
+	TP_PROTO(struct xfs_mount *mp, int new_dalign, xfs_ino_t calc_rootino),
+	TP_ARGS(mp, new_dalign, calc_rootino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(int, new_dalign)
+		__field(xfs_ino_t, sb_rootino)
+		__field(xfs_ino_t, calc_rootino)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->new_dalign = new_dalign;
+		__entry->sb_rootino = mp->m_sb.sb_rootino;
+		__entry->calc_rootino = calc_rootino;
+	),
+	TP_printk("dev %d:%d new_dalign %d sb_rootino %llu calc_rootino %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->new_dalign, __entry->sb_rootino,
+		  __entry->calc_rootino)
+)
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
