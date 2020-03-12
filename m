Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFEAE182777
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Mar 2020 04:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbgCLDpK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Mar 2020 23:45:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35832 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731597AbgCLDpK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Mar 2020 23:45:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3hBgc181365;
        Thu, 12 Mar 2020 03:45:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=aQazCNIy2W3kgODTRdOCMyxSqId+8mrHxb/TsL/MH+Q=;
 b=iL8yH7el8MPm6RPAItmqyFk+YGzIGThLeWXinx1KrrdXAHZsSZ0huBWJq049Ua9mJg4l
 oxYYo9zEY+hc3OI/rR4oBsW9FWq+IXQez5CKyseBeXxUT31nqvf6GghqmdbHSJQYG/Q7
 PukR0+fRxUT3jdhFIIkse9nmI0658fGedLqJG/0UT/QuuNipcgxQmbrhyD+tbou8v8cW
 Labf+x2mciwEPjN6bTOz+9hMI9PRU58o8cawygdLJHgN0E9B3R//lffP4gWzWmPHMfcp
 q+uR9qxD9Sdi2hNnm3DhQ996uqK3Hf3O+Di5GU06h5Q71HJiImyfjLwWp5baNCUyv7fh 6g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ym31uq77k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02C3cD76085343;
        Thu, 12 Mar 2020 03:45:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2yp8q1vgks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 03:45:03 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02C3j2PD028928;
        Thu, 12 Mar 2020 03:45:02 GMT
Received: from localhost (/10.159.134.61)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Mar 2020 20:45:02 -0700
Subject: [PATCH 3/7] xfs: convert btree cursor inode-private member names
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Date:   Wed, 11 Mar 2020 20:45:00 -0700
Message-ID: <158398470079.1307855.5432562936282656815.stgit@magnolia>
In-Reply-To: <158398468107.1307855.8287106235853942996.stgit@magnolia>
References: <158398468107.1307855.8287106235853942996.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=4 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120016
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=4
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120016
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

bc_private.b -> bc_ino conversion via script:

$ sed -i 's/bc_private\.b/bc_ino/g' fs/xfs/*[ch] fs/xfs/*/*[ch]

And then revert the change to the bc_ino #define in
fs/xfs/libxfs/xfs_btree.h manually.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: tweak the subject line slightly]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |   44 ++++++++++++++++++-----------------
 fs/xfs/libxfs/xfs_bmap_btree.c |   50 ++++++++++++++++++++--------------------
 fs/xfs/libxfs/xfs_btree.c      |   50 ++++++++++++++++++++--------------------
 fs/xfs/scrub/bmap.c            |    2 +-
 fs/xfs/scrub/trace.c           |    2 +-
 fs/xfs/scrub/trace.h           |    4 ++-
 6 files changed, 76 insertions(+), 76 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 43ae2ab21084..fc8f6d65576c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -690,7 +690,7 @@ xfs_bmap_extents_to_btree(
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-	cur->bc_private.b.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
+	cur->bc_ino.flags = wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
 	/*
 	 * Convert to a btree with two levels, one record in root.
 	 */
@@ -727,7 +727,7 @@ xfs_bmap_extents_to_btree(
 	ASSERT(tp->t_firstblock == NULLFSBLOCK ||
 	       args.agno >= XFS_FSB_TO_AGNO(mp, tp->t_firstblock));
 	tp->t_firstblock = args.fsbno;
-	cur->bc_private.b.allocated++;
+	cur->bc_ino.allocated++;
 	ip->i_d.di_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
@@ -953,7 +953,7 @@ xfs_bmap_add_attrfork_btree(
 			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 			return -ENOSPC;
 		}
-		cur->bc_private.b.allocated = 0;
+		cur->bc_ino.allocated = 0;
 		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	}
 	return 0;
@@ -980,7 +980,7 @@ xfs_bmap_add_attrfork_extents(
 	error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0, flags,
 					  XFS_DATA_FORK);
 	if (cur) {
-		cur->bc_private.b.allocated = 0;
+		cur->bc_ino.allocated = 0;
 		xfs_btree_del_cursor(cur, error);
 	}
 	return error;
@@ -1178,13 +1178,13 @@ xfs_iread_bmbt_block(
 {
 	struct xfs_iread_state	*ir = priv;
 	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	struct xfs_inode	*ip = cur->bc_ino.ip;
 	struct xfs_btree_block	*block;
 	struct xfs_buf		*bp;
 	struct xfs_bmbt_rec	*frp;
 	xfs_extnum_t		num_recs;
 	xfs_extnum_t		j;
-	int			whichfork = cur->bc_private.b.whichfork;
+	int			whichfork = cur->bc_ino.whichfork;
 
 	block = xfs_btree_get_block(cur, level, &bp);
 
@@ -1528,7 +1528,7 @@ xfs_bmap_add_extent_delay_real(
 
 	ASSERT(!isnullstartblock(new->br_startblock));
 	ASSERT(!bma->cur ||
-	       (bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
+	       (bma->cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -1818,7 +1818,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = PREV.br_blockcount - new->br_blockcount;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock) -
-			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
+			(bma->cur ? bma->cur->bc_ino.allocated : 0));
 
 		PREV.br_startoff = new_endoff;
 		PREV.br_blockcount = temp;
@@ -1904,7 +1904,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = PREV.br_blockcount - new->br_blockcount;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock) -
-			(bma->cur ? bma->cur->bc_private.b.allocated : 0));
+			(bma->cur ? bma->cur->bc_ino.allocated : 0));
 
 		PREV.br_startblock = nullstartblock(da_new);
 		PREV.br_blockcount = temp;
@@ -2025,8 +2025,8 @@ xfs_bmap_add_extent_delay_real(
 		xfs_mod_delalloc(mp, (int64_t)da_new - da_old);
 
 	if (bma->cur) {
-		da_new += bma->cur->bc_private.b.allocated;
-		bma->cur->bc_private.b.allocated = 0;
+		da_new += bma->cur->bc_ino.allocated;
+		bma->cur->bc_ino.allocated = 0;
 	}
 
 	/* adjust for changes in reserved delayed indirect blocks */
@@ -2573,7 +2573,7 @@ xfs_bmap_add_extent_unwritten_real(
 
 	/* clear out the allocated field, done with it now in any case. */
 	if (cur) {
-		cur->bc_private.b.allocated = 0;
+		cur->bc_ino.allocated = 0;
 		*curp = cur;
 	}
 
@@ -2752,7 +2752,7 @@ xfs_bmap_add_extent_hole_real(
 	struct xfs_bmbt_irec	old;
 
 	ASSERT(!isnullstartblock(new->br_startblock));
-	ASSERT(!cur || !(cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
+	ASSERT(!cur || !(cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL));
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
@@ -2955,7 +2955,7 @@ xfs_bmap_add_extent_hole_real(
 
 	/* clear out the allocated field, done with it now in any case. */
 	if (cur)
-		cur->bc_private.b.allocated = 0;
+		cur->bc_ino.allocated = 0;
 
 	xfs_bmap_check_leaf_extents(cur, ip, whichfork);
 done:
@@ -4187,7 +4187,7 @@ xfs_bmapi_allocate(
 	bma->nallocs++;
 
 	if (bma->cur)
-		bma->cur->bc_private.b.flags =
+		bma->cur->bc_ino.flags =
 			bma->wasdel ? XFS_BTCUR_BPRV_WASDEL : 0;
 
 	bma->got.br_startoff = bma->offset;
@@ -4709,7 +4709,7 @@ xfs_bmapi_remap(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.flags = 0;
+		cur->bc_ino.flags = 0;
 	}
 
 	got.br_startoff = bno;
@@ -5364,7 +5364,7 @@ __xfs_bunmapi(
 	if (ifp->if_flags & XFS_IFBROOT) {
 		ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.flags = 0;
+		cur->bc_ino.flags = 0;
 	} else
 		cur = NULL;
 
@@ -5620,7 +5620,7 @@ __xfs_bunmapi(
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (cur) {
 		if (!error)
-			cur->bc_private.b.allocated = 0;
+			cur->bc_ino.allocated = 0;
 		xfs_btree_del_cursor(cur, error);
 	}
 	return error;
@@ -5839,7 +5839,7 @@ xfs_bmap_collapse_extents(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.flags = 0;
+		cur->bc_ino.flags = 0;
 	}
 
 	if (!xfs_iext_lookup_extent(ip, ifp, *next_fsb, &icur, &got)) {
@@ -5956,7 +5956,7 @@ xfs_bmap_insert_extents(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.flags = 0;
+		cur->bc_ino.flags = 0;
 	}
 
 	if (*next_fsb == NULLFSBLOCK) {
@@ -6074,7 +6074,7 @@ xfs_bmap_split_extent(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.flags = 0;
+		cur->bc_ino.flags = 0;
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
 			goto del_cursor;
@@ -6133,7 +6133,7 @@ xfs_bmap_split_extent(
 
 del_cursor:
 	if (cur) {
-		cur->bc_private.b.allocated = 0;
+		cur->bc_ino.allocated = 0;
 		xfs_btree_del_cursor(cur, error);
 	}
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index ffe608d2a2d9..71b60f2a9979 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -166,13 +166,13 @@ xfs_bmbt_dup_cursor(
 	struct xfs_btree_cur	*new;
 
 	new = xfs_bmbt_init_cursor(cur->bc_mp, cur->bc_tp,
-			cur->bc_private.b.ip, cur->bc_private.b.whichfork);
+			cur->bc_ino.ip, cur->bc_ino.whichfork);
 
 	/*
 	 * Copy the firstblock, dfops, and flags values,
 	 * since init cursor doesn't get them.
 	 */
-	new->bc_private.b.flags = cur->bc_private.b.flags;
+	new->bc_ino.flags = cur->bc_ino.flags;
 
 	return new;
 }
@@ -183,12 +183,12 @@ xfs_bmbt_update_cursor(
 	struct xfs_btree_cur	*dst)
 {
 	ASSERT((dst->bc_tp->t_firstblock != NULLFSBLOCK) ||
-	       (dst->bc_private.b.ip->i_d.di_flags & XFS_DIFLAG_REALTIME));
+	       (dst->bc_ino.ip->i_d.di_flags & XFS_DIFLAG_REALTIME));
 
-	dst->bc_private.b.allocated += src->bc_private.b.allocated;
+	dst->bc_ino.allocated += src->bc_ino.allocated;
 	dst->bc_tp->t_firstblock = src->bc_tp->t_firstblock;
 
-	src->bc_private.b.allocated = 0;
+	src->bc_ino.allocated = 0;
 }
 
 STATIC int
@@ -205,8 +205,8 @@ xfs_bmbt_alloc_block(
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
 	args.fsbno = cur->bc_tp->t_firstblock;
-	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_private.b.ip->i_ino,
-			cur->bc_private.b.whichfork);
+	xfs_rmap_ino_bmbt_owner(&args.oinfo, cur->bc_ino.ip->i_ino,
+			cur->bc_ino.whichfork);
 
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
@@ -230,7 +230,7 @@ xfs_bmbt_alloc_block(
 	}
 
 	args.minlen = args.maxlen = args.prod = 1;
-	args.wasdel = cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL;
+	args.wasdel = cur->bc_ino.flags & XFS_BTCUR_BPRV_WASDEL;
 	if (!args.wasdel && args.tp->t_blk_res == 0) {
 		error = -ENOSPC;
 		goto error0;
@@ -259,10 +259,10 @@ xfs_bmbt_alloc_block(
 
 	ASSERT(args.len == 1);
 	cur->bc_tp->t_firstblock = args.fsbno;
-	cur->bc_private.b.allocated++;
-	cur->bc_private.b.ip->i_d.di_nblocks++;
-	xfs_trans_log_inode(args.tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
-	xfs_trans_mod_dquot_byino(args.tp, cur->bc_private.b.ip,
+	cur->bc_ino.allocated++;
+	cur->bc_ino.ip->i_d.di_nblocks++;
+	xfs_trans_log_inode(args.tp, cur->bc_ino.ip, XFS_ILOG_CORE);
+	xfs_trans_mod_dquot_byino(args.tp, cur->bc_ino.ip,
 			XFS_TRANS_DQ_BCOUNT, 1L);
 
 	new->l = cpu_to_be64(args.fsbno);
@@ -280,12 +280,12 @@ xfs_bmbt_free_block(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	struct xfs_inode	*ip = cur->bc_ino.ip;
 	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 	struct xfs_owner_info	oinfo;
 
-	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_private.b.whichfork);
+	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_ino.whichfork);
 	xfs_bmap_add_free(cur->bc_tp, fsbno, 1, &oinfo);
 	ip->i_d.di_nblocks--;
 
@@ -302,8 +302,8 @@ xfs_bmbt_get_minrecs(
 	if (level == cur->bc_nlevels - 1) {
 		struct xfs_ifork	*ifp;
 
-		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip,
-				    cur->bc_private.b.whichfork);
+		ifp = XFS_IFORK_PTR(cur->bc_ino.ip,
+				    cur->bc_ino.whichfork);
 
 		return xfs_bmbt_maxrecs(cur->bc_mp,
 					ifp->if_broot_bytes, level == 0) / 2;
@@ -320,8 +320,8 @@ xfs_bmbt_get_maxrecs(
 	if (level == cur->bc_nlevels - 1) {
 		struct xfs_ifork	*ifp;
 
-		ifp = XFS_IFORK_PTR(cur->bc_private.b.ip,
-				    cur->bc_private.b.whichfork);
+		ifp = XFS_IFORK_PTR(cur->bc_ino.ip,
+				    cur->bc_ino.whichfork);
 
 		return xfs_bmbt_maxrecs(cur->bc_mp,
 					ifp->if_broot_bytes, level == 0);
@@ -347,7 +347,7 @@ xfs_bmbt_get_dmaxrecs(
 {
 	if (level != cur->bc_nlevels - 1)
 		return cur->bc_mp->m_bmap_dmxr[level != 0];
-	return xfs_bmdr_maxrecs(cur->bc_private.b.forksize, level == 0);
+	return xfs_bmdr_maxrecs(cur->bc_ino.forksize, level == 0);
 }
 
 STATIC void
@@ -566,11 +566,11 @@ xfs_bmbt_init_cursor(
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
-	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, whichfork);
-	cur->bc_private.b.ip = ip;
-	cur->bc_private.b.allocated = 0;
-	cur->bc_private.b.flags = 0;
-	cur->bc_private.b.whichfork = whichfork;
+	cur->bc_ino.forksize = XFS_IFORK_SIZE(ip, whichfork);
+	cur->bc_ino.ip = ip;
+	cur->bc_ino.allocated = 0;
+	cur->bc_ino.flags = 0;
+	cur->bc_ino.whichfork = whichfork;
 
 	return cur;
 }
@@ -644,7 +644,7 @@ xfs_bmbt_change_owner(
 	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
 	if (!cur)
 		return -ENOMEM;
-	cur->bc_private.b.flags |= XFS_BTCUR_BPRV_INVALID_OWNER;
+	cur->bc_ino.flags |= XFS_BTCUR_BPRV_INVALID_OWNER;
 
 	error = xfs_btree_change_owner(cur, new_owner, buffer_list);
 	xfs_btree_del_cursor(cur, error);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 7681d48a2b13..8c6e128c8ae8 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -234,8 +234,8 @@ xfs_btree_check_ptr(
 			return 0;
 		xfs_err(cur->bc_mp,
 "Inode %llu fork %d: Corrupt btree %d pointer at level %d index %d.",
-				cur->bc_private.b.ip->i_ino,
-				cur->bc_private.b.whichfork, cur->bc_btnum,
+				cur->bc_ino.ip->i_ino,
+				cur->bc_ino.whichfork, cur->bc_btnum,
 				level, index);
 	} else {
 		if (xfs_btree_check_sptr(cur, be32_to_cpu((&ptr->s)[index]),
@@ -378,7 +378,7 @@ xfs_btree_del_cursor(
 	 * allocated indirect blocks' accounting.
 	 */
 	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP ||
-	       cur->bc_private.b.allocated == 0);
+	       cur->bc_ino.allocated == 0);
 	/*
 	 * Free the cursor.
 	 */
@@ -654,7 +654,7 @@ xfs_btree_get_iroot(
 {
 	struct xfs_ifork	*ifp;
 
-	ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, cur->bc_private.b.whichfork);
+	ifp = XFS_IFORK_PTR(cur->bc_ino.ip, cur->bc_ino.whichfork);
 	return (struct xfs_btree_block *)ifp->if_broot;
 }
 
@@ -1144,7 +1144,7 @@ xfs_btree_init_block_cur(
 	 * code.
 	 */
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		owner = cur->bc_private.b.ip->i_ino;
+		owner = cur->bc_ino.ip->i_ino;
 	else
 		owner = cur->bc_ag.agno;
 
@@ -1393,8 +1393,8 @@ xfs_btree_log_keys(
 				  xfs_btree_key_offset(cur, first),
 				  xfs_btree_key_offset(cur, last + 1) - 1);
 	} else {
-		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
-				xfs_ilog_fbroot(cur->bc_private.b.whichfork));
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_ino.ip,
+				xfs_ilog_fbroot(cur->bc_ino.whichfork));
 	}
 }
 
@@ -1436,8 +1436,8 @@ xfs_btree_log_ptrs(
 				xfs_btree_ptr_offset(cur, first, level),
 				xfs_btree_ptr_offset(cur, last + 1, level) - 1);
 	} else {
-		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
-			xfs_ilog_fbroot(cur->bc_private.b.whichfork));
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_ino.ip,
+			xfs_ilog_fbroot(cur->bc_ino.whichfork));
 	}
 
 }
@@ -1505,8 +1505,8 @@ xfs_btree_log_block(
 		xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
 		xfs_trans_log_buf(cur->bc_tp, bp, first, last);
 	} else {
-		xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip,
-			xfs_ilog_fbroot(cur->bc_private.b.whichfork));
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_ino.ip,
+			xfs_ilog_fbroot(cur->bc_ino.whichfork));
 	}
 }
 
@@ -1743,10 +1743,10 @@ xfs_btree_lookup_get_block(
 
 	/* Check the inode owner since the verifiers don't. */
 	if (xfs_sb_version_hascrc(&cur->bc_mp->m_sb) &&
-	    !(cur->bc_private.b.flags & XFS_BTCUR_BPRV_INVALID_OWNER) &&
+	    !(cur->bc_ino.flags & XFS_BTCUR_BPRV_INVALID_OWNER) &&
 	    (cur->bc_flags & XFS_BTREE_LONG_PTRS) &&
 	    be64_to_cpu((*blkp)->bb_u.l.bb_owner) !=
-			cur->bc_private.b.ip->i_ino)
+			cur->bc_ino.ip->i_ino)
 		goto out_bad;
 
 	/* Did we get the level we were looking for? */
@@ -2938,9 +2938,9 @@ xfs_btree_new_iroot(
 
 	xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
 
-	xfs_iroot_realloc(cur->bc_private.b.ip,
+	xfs_iroot_realloc(cur->bc_ino.ip,
 			  1 - xfs_btree_get_numrecs(cblock),
-			  cur->bc_private.b.whichfork);
+			  cur->bc_ino.whichfork);
 
 	xfs_btree_setbuf(cur, level, cbp);
 
@@ -2953,7 +2953,7 @@ xfs_btree_new_iroot(
 	xfs_btree_log_ptrs(cur, cbp, 1, be16_to_cpu(cblock->bb_numrecs));
 
 	*logflags |=
-		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork);
+		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_ino.whichfork);
 	*stat = 1;
 	return 0;
 error0:
@@ -3105,11 +3105,11 @@ xfs_btree_make_block_unfull(
 
 	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
 	    level == cur->bc_nlevels - 1) {
-		struct xfs_inode *ip = cur->bc_private.b.ip;
+		struct xfs_inode *ip = cur->bc_ino.ip;
 
 		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
 			/* A root block that can be made bigger. */
-			xfs_iroot_realloc(ip, 1, cur->bc_private.b.whichfork);
+			xfs_iroot_realloc(ip, 1, cur->bc_ino.whichfork);
 			*stat = 1;
 		} else {
 			/* A root block that needs replacing */
@@ -3455,8 +3455,8 @@ STATIC int
 xfs_btree_kill_iroot(
 	struct xfs_btree_cur	*cur)
 {
-	int			whichfork = cur->bc_private.b.whichfork;
-	struct xfs_inode	*ip = cur->bc_private.b.ip;
+	int			whichfork = cur->bc_ino.whichfork;
+	struct xfs_inode	*ip = cur->bc_ino.ip;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_block	*block;
 	struct xfs_btree_block	*cblock;
@@ -3514,8 +3514,8 @@ xfs_btree_kill_iroot(
 
 	index = numrecs - cur->bc_ops->get_maxrecs(cur, level);
 	if (index) {
-		xfs_iroot_realloc(cur->bc_private.b.ip, index,
-				  cur->bc_private.b.whichfork);
+		xfs_iroot_realloc(cur->bc_ino.ip, index,
+				  cur->bc_ino.whichfork);
 		block = ifp->if_broot;
 	}
 
@@ -3544,7 +3544,7 @@ xfs_btree_kill_iroot(
 	cur->bc_bufs[level - 1] = NULL;
 	be16_add_cpu(&block->bb_level, -1);
 	xfs_trans_log_inode(cur->bc_tp, ip,
-		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_private.b.whichfork));
+		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_ino.whichfork));
 	cur->bc_nlevels--;
 out0:
 	return 0;
@@ -3712,8 +3712,8 @@ xfs_btree_delrec(
 	 */
 	if (level == cur->bc_nlevels - 1) {
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
-			xfs_iroot_realloc(cur->bc_private.b.ip, -1,
-					  cur->bc_private.b.whichfork);
+			xfs_iroot_realloc(cur->bc_ino.ip, -1,
+					  cur->bc_ino.whichfork);
 
 			error = xfs_btree_kill_iroot(cur);
 			if (error)
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 1c866594ec34..add8598eacd5 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -374,7 +374,7 @@ xchk_bmapbt_rec(
 	struct xfs_bmbt_irec	iext_irec;
 	struct xfs_iext_cursor	icur;
 	struct xchk_bmap_info	*info = bs->private;
-	struct xfs_inode	*ip = bs->cur->bc_private.b.ip;
+	struct xfs_inode	*ip = bs->cur->bc_ino.ip;
 	struct xfs_buf		*bp = NULL;
 	struct xfs_btree_block	*block;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, info->whichfork);
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 731111e1448c..2c6c248be823 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -24,7 +24,7 @@ xchk_btree_cur_fsbno(
 		return XFS_DADDR_TO_FSB(cur->bc_mp, cur->bc_bufs[level]->b_bn);
 	else if (level == cur->bc_nlevels - 1 &&
 		 cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_private.b.ip->i_ino);
+		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
 	else if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS))
 		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.agno, 0);
 	return NULLFSBLOCK;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 096203119934..e46f5cef90da 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -379,7 +379,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->ino = sc->ip->i_ino;
-		__entry->whichfork = cur->bc_private.b.whichfork;
+		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
 		__entry->btnum = cur->bc_btnum;
 		__entry->level = level;
@@ -459,7 +459,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->ino = sc->ip->i_ino;
-		__entry->whichfork = cur->bc_private.b.whichfork;
+		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
 		__entry->btnum = cur->bc_btnum;
 		__entry->level = level;

