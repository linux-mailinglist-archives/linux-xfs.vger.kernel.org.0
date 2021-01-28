Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C0B306D3A
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Jan 2021 07:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhA1GCh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Jan 2021 01:02:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:37782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229847AbhA1GCc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:02:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2874761492;
        Thu, 28 Jan 2021 06:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813702;
        bh=jYd+JbAP34XHZDUVi00uvStLd9BuNdUAjxUxLgBwhg4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nB6zFvNvgHPkJC3sn1alFS/6TCHYDEds22J9NwM25aMm/Ltu4Q02AdcUsBd5Qn8oV
         8jHtYfeucqJIurPFUYOY9ludbYj1e1GnNL3S+9YZr+G+OaSuUU4PsOxkzhsx76ONky
         VCXq7tbXKAhGSILrfk05qpvaszuVo4dIQwqm7IQCugoYw6UUZIxVkjTyI0nP6/E8TJ
         7N4T1zZiBhYJlIwj3wPZ655EEGrBbrHUskHIroDM2YyjY+n76BIf4QCN34n4w8tHNi
         W33vVz3pj4KGys7Urqpn+BaRb8MZJJ2Q/hkVfswTz52wTNAICSi/NPho/DaZpn0cv+
         BhLpZrTY2vJ3A==
Subject: [PATCH 06/13] xfs: reserve data and rt quota at the same time
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:01:38 -0800
Message-ID: <161181369834.1523592.7003018155732921879.stgit@magnolia>
In-Reply-To: <161181366379.1523592.9213241916555622577.stgit@magnolia>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Modify xfs_trans_reserve_quota_nblks so that we can reserve data and
realtime blocks from the dquot at the same time.  This change has the
theoretical side effect that for allocations to realtime files we will
reserve from the dquot both the number of rtblocks being allocated and
the number of bmbt blocks that might be needed to add the mapping.
However, since the mount code disables quota if it finds a realtime
device, this should not result in any behavior changes.

This also replaces the flags argument with a force? boolean since we
don't need to distinguish between data and rt quota reservations any
more, and the only other flag being passed in was FORCE_RES.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    6 +-----
 fs/xfs/libxfs/xfs_bmap.c |    4 +---
 fs/xfs/xfs_bmap_util.c   |   20 +++++++++-----------
 fs/xfs/xfs_iomap.c       |   26 +++++++++++++-------------
 fs/xfs/xfs_quota.h       |   10 +++++-----
 fs/xfs/xfs_reflink.c     |    6 ++----
 fs/xfs/xfs_trans_dquot.c |   42 ++++++++++++++++++++++++++++--------------
 7 files changed, 59 insertions(+), 55 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index be51e7068dcd..e05dc0bc4a8f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -474,12 +474,8 @@ xfs_attr_set(
 	}
 
 	if (args->value) {
-		unsigned int	quota_flags = XFS_QMOPT_RES_REGBLKS;
-
-		if (rsvd)
-			quota_flags |= XFS_QMOPT_FORCE_RES;
 		error = xfs_trans_reserve_quota_nblks(args->trans, dp,
-				args->total, 0, quota_flags);
+				args->total, 0, rsvd);
 		if (error)
 			goto out_trans_cancel;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6edf1b5711c8..043bb8c634b0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1085,9 +1085,7 @@ xfs_bmap_add_attrfork(
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
-			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
-			XFS_QMOPT_RES_REGBLKS);
+	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd);
 	if (error)
 		goto trans_cancel;
 	if (XFS_IFORK_Q(ip))
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f0a8f3377281..d54d9f02d3dd 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -727,7 +727,6 @@ xfs_alloc_file_space(
 	xfs_fileoff_t		startoffset_fsb;
 	xfs_fileoff_t		endoffset_fsb;
 	int			nimaps;
-	int			quota_flag;
 	int			rt;
 	xfs_trans_t		*tp;
 	xfs_bmbt_irec_t		imaps[1], *imapp;
@@ -761,6 +760,7 @@ xfs_alloc_file_space(
 	 */
 	while (allocatesize_fsb && !error) {
 		xfs_fileoff_t	s, e;
+		unsigned int	dblocks, rblocks;
 
 		/*
 		 * Determine space reservations for data/realtime.
@@ -792,18 +792,17 @@ xfs_alloc_file_space(
 		if (unlikely(rt)) {
 			resrtextents = qblocks = resblks;
 			resrtextents /= mp->m_sb.sb_rextsize;
-			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
-			quota_flag = XFS_QMOPT_RES_RTBLKS;
+			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+			rblocks = resblks;
 		} else {
-			resrtextents = 0;
-			resblks = qblocks = XFS_DIOSTRAT_SPACE_RES(mp, resblks);
-			quota_flag = XFS_QMOPT_RES_REGBLKS;
+			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resblks);
+			rblocks = 0;
 		}
 
 		/*
 		 * Allocate and setup the transaction.
 		 */
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, dblocks,
 				resrtextents, 0, &tp);
 
 		/*
@@ -817,8 +816,8 @@ xfs_alloc_file_space(
 			break;
 		}
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks,
-						      0, quota_flag);
+		error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks,
+				false);
 		if (error)
 			goto error1;
 
@@ -881,8 +880,7 @@ xfs_unmap_extent(
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
-			XFS_QMOPT_RES_REGBLKS);
+	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0, false);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index de0e371ba4dd..ef29d44c656a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -194,25 +194,25 @@ xfs_iomap_write_direct(
 	struct xfs_trans	*tp;
 	xfs_filblks_t		resaligned;
 	int			nimaps;
-	int			quota_flag;
-	uint			qblocks, resblks;
+	unsigned int		dblocks, rblocks;
 	unsigned int		resrtextents = 0;
 	int			error;
 	int			bmapi_flags = XFS_BMAPI_PREALLOC;
-	uint			tflags = 0;
+	int			tflags = 0;
+	bool			force = false;
 
 	ASSERT(count_fsb > 0);
 
 	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
 					   xfs_get_extsz_hint(ip));
 	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
-		resrtextents = qblocks = resaligned;
+		resrtextents = resaligned;
 		resrtextents /= mp->m_sb.sb_rextsize;
-		resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
-		quota_flag = XFS_QMOPT_RES_RTBLKS;
+		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
+		rblocks = resaligned;
 	} else {
-		resblks = qblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
-		quota_flag = XFS_QMOPT_RES_REGBLKS;
+		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
+		rblocks = 0;
 	}
 
 	error = xfs_qm_dqattach(ip);
@@ -235,18 +235,19 @@ xfs_iomap_write_direct(
 	if (IS_DAX(VFS_I(ip))) {
 		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
 		if (imap->br_state == XFS_EXT_UNWRITTEN) {
+			force = true;
 			tflags |= XFS_TRANS_RESERVE;
-			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
+			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
 		}
 	}
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, resrtextents,
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, dblocks, resrtextents,
 			tflags, &tp);
 	if (error)
 		return error;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
+	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
 	if (error)
 		goto out_trans_cancel;
 
@@ -559,8 +560,7 @@ xfs_iomap_write_unwritten(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, 0);
 
-		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
-				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES);
+		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0, true);
 		if (error)
 			goto error_on_bmapi_transaction;
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 72f4cfc49048..efd04f84d9b4 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -81,8 +81,8 @@ extern void xfs_trans_mod_dquot_byino(struct xfs_trans *, struct xfs_inode *,
 		uint, int64_t);
 extern void xfs_trans_apply_dquot_deltas(struct xfs_trans *);
 extern void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *);
-extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
-		struct xfs_inode *, int64_t, long, uint);
+int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
+		int64_t dblocks, int64_t rblocks, bool force);
 extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
 		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
@@ -114,8 +114,7 @@ extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 static inline int
 xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t dblocks)
 {
-	return xfs_trans_reserve_quota_nblks(NULL, ip, dblocks, 0,
-			XFS_QMOPT_RES_REGBLKS);
+	return xfs_trans_reserve_quota_nblks(NULL, ip, dblocks, 0, false);
 }
 #else
 static inline int
@@ -134,7 +133,8 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
 #define xfs_trans_apply_dquot_deltas(tp)
 #define xfs_trans_unreserve_and_mod_dquots(tp)
 static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,
-		struct xfs_inode *ip, int64_t nblks, long ninos, uint flags)
+		struct xfs_inode *ip, int64_t dblocks, int64_t rblocks,
+		bool force)
 {
 	return 0;
 }
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 15435229bc1f..0778b5810c26 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -398,8 +398,7 @@ xfs_reflink_allocate_cow(
 		goto convert;
 	}
 
-	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
-			XFS_QMOPT_RES_REGBLKS);
+	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0, false);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1090,8 +1089,7 @@ xfs_reflink_remap_extent(
 	if (!smap_real && dmap_written)
 		qres += dmap->br_blockcount;
 	if (qres > 0) {
-		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
-				XFS_QMOPT_RES_REGBLKS);
+		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0, false);
 		if (error)
 			goto out_cancel;
 	}
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 22aa875b84f7..a1a72b7900c5 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -780,28 +780,42 @@ int
 xfs_trans_reserve_quota_nblks(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
-	int64_t			nblks,
-	long			ninos,
-	uint			flags)
+	int64_t			dblocks,
+	int64_t			rblocks,
+	bool			force)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		qflags = 0;
+	int			error;
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
 
 	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
-
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_RTBLKS ||
-	       (flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_BLKS);
-
-	/*
-	 * Reserve nblks against these dquots, with trans as the mediator.
-	 */
-	return xfs_trans_reserve_quota_bydquots(tp, mp,
-						ip->i_udquot, ip->i_gdquot,
-						ip->i_pdquot,
-						nblks, ninos, flags);
+
+	if (force)
+		qflags |= XFS_QMOPT_FORCE_RES;
+
+	/* Reserve data device quota against the inode's dquots. */
+	error = xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
+			ip->i_gdquot, ip->i_pdquot, dblocks, 0,
+			XFS_QMOPT_RES_REGBLKS | qflags);
+	if (error)
+		return error;
+
+	/* Do the same but for realtime blocks. */
+	error = xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
+			ip->i_gdquot, ip->i_pdquot, rblocks, 0,
+			XFS_QMOPT_RES_RTBLKS | qflags);
+	if (error) {
+		xfs_trans_reserve_quota_bydquots(tp, mp, ip->i_udquot,
+				ip->i_gdquot, ip->i_pdquot, -dblocks, 0,
+				XFS_QMOPT_RES_REGBLKS);
+		return error;
+	}
+
+	return 0;
 }
 
 /* Change the quota reservations for an inode creation activity. */

