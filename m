Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD12306D3B
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Jan 2021 07:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhA1GCh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Jan 2021 01:02:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:37818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231199AbhA1GCf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:02:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97BE964DD1;
        Thu, 28 Jan 2021 06:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813713;
        bh=J/9KtHQZ/gpKJYlMsQ+EuaRBZ0ojljp1QEOdvnMqSwo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KhC+O5rdTDmmjO5YYFkiGLchM8h/8humyNH3qv2c64V+YBl0zGQXWYhSB9XJam8Ax
         +qy3m8jQk08fXoz904MJ180Lc0Vs+hwDh9Kffg2h23RqaD5pbpNCGysENubMtaGn2u
         8gSvlJRFCFmzF2If5vatI1jcgek4SBmCgfmoEHNOkP4z9Zr2MRQ2oKCtBVUG6Zslsw
         M1fpFkAdyqMaASKLqWu7XoCnfty3bCMH1OhIc8kHdoj98exkHRxLa+OLximDQ2Gtfv
         6b7UmyPkjA93/Q4N1q+UyN8HwjayQqhxDscj65dQrEUuXhg1OvUgh5Y3ZlyzYlE6Ql
         QvMFMBVbhm97A==
Subject: [PATCH 08/13] xfs: allow reservation of rtblocks with
 xfs_trans_alloc_inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:01:49 -0800
Message-ID: <161181370983.1523592.13034713028988213055.stgit@magnolia>
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

Make it so that we can reserve rt blocks with the xfs_trans_alloc_inode
wrapper function, then convert a few more callsites.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    2 +-
 fs/xfs/libxfs/xfs_bmap.c |    2 +-
 fs/xfs/xfs_bmap_util.c   |   29 +++++------------------------
 fs/xfs/xfs_iomap.c       |   22 +++++-----------------
 fs/xfs/xfs_trans.c       |    6 ++++--
 fs/xfs/xfs_trans.h       |    3 ++-
 6 files changed, 18 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index cb95bc77fe59..472b3039eabb 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -458,7 +458,7 @@ xfs_attr_set(
 	 * Root fork attributes can use reserved data blocks for this
 	 * operation if necessary
 	 */
-	error = xfs_trans_alloc_inode(dp, &tres, total, rsvd, &args->trans);
+	error = xfs_trans_alloc_inode(dp, &tres, total, 0, rsvd, &args->trans);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f78fa694f3c2..8131bc5f4bad 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1079,7 +1079,7 @@ xfs_bmap_add_attrfork(
 
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
 
-	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_addafork, blks,
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_addafork, blks, 0,
 			rsvd, &tp);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 94ffdeb2dd73..c3b7dff21887 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -730,7 +730,6 @@ xfs_alloc_file_space(
 	int			rt;
 	xfs_trans_t		*tp;
 	xfs_bmbt_irec_t		imaps[1], *imapp;
-	uint			qblocks, resblks, resrtextents;
 	int			error;
 
 	trace_xfs_alloc_file_space(ip);
@@ -760,7 +759,7 @@ xfs_alloc_file_space(
 	 */
 	while (allocatesize_fsb && !error) {
 		xfs_fileoff_t	s, e;
-		unsigned int	dblocks, rblocks;
+		unsigned int	dblocks, rblocks, resblks;
 
 		/*
 		 * Determine space reservations for data/realtime.
@@ -790,8 +789,6 @@ xfs_alloc_file_space(
 		 */
 		resblks = min_t(xfs_fileoff_t, (e - s), (MAXEXTLEN * nimaps));
 		if (unlikely(rt)) {
-			resrtextents = qblocks = resblks;
-			resrtextents /= mp->m_sb.sb_rextsize;
 			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 			rblocks = resblks;
 		} else {
@@ -802,32 +799,16 @@ xfs_alloc_file_space(
 		/*
 		 * Allocate and setup the transaction.
 		 */
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, dblocks,
-				resrtextents, 0, &tp);
-
-		/*
-		 * Check for running out of space
-		 */
-		if (error) {
-			/*
-			 * Free the transaction structure.
-			 */
-			ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
-			break;
-		}
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks,
-				false);
+		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
+				dblocks, rblocks, false, &tp);
 		if (error)
-			goto error1;
+			break;
 
 		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto error1;
 
-		xfs_trans_ijoin(tp, ip, 0);
-
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
 					allocatesize_fsb, alloc_type, 0, imapp,
 					&nimaps);
@@ -873,7 +854,7 @@ xfs_unmap_extent(
 	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 	int			error;
 
-	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks,
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
 			false, &tp);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 05de1be20426..f34a76529602 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -195,19 +195,15 @@ xfs_iomap_write_direct(
 	xfs_filblks_t		resaligned;
 	int			nimaps;
 	unsigned int		dblocks, rblocks;
-	unsigned int		resrtextents = 0;
+	bool			force = false;
 	int			error;
 	int			bmapi_flags = XFS_BMAPI_PREALLOC;
-	int			tflags = 0;
-	bool			force = false;
 
 	ASSERT(count_fsb > 0);
 
 	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
 					   xfs_get_extsz_hint(ip));
 	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
-		resrtextents = resaligned;
-		resrtextents /= mp->m_sb.sb_rextsize;
 		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 		rblocks = resaligned;
 	} else {
@@ -236,28 +232,20 @@ xfs_iomap_write_direct(
 		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
 		if (imap->br_state == XFS_EXT_UNWRITTEN) {
 			force = true;
-			tflags |= XFS_TRANS_RESERVE;
 			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
 		}
 	}
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, dblocks, resrtextents,
-			tflags, &tp);
+
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
+			rblocks, force, &tp);
 	if (error)
 		return error;
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
-	if (error)
-		goto out_trans_cancel;
-
 	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_trans_ijoin(tp, ip, 0);
-
 	/*
 	 * From this point onwards we overwrite the imap pointer that the
 	 * caller gave to us.
@@ -553,7 +541,7 @@ xfs_iomap_write_unwritten(
 		 * complete here and might deadlock on the iolock.
 		 */
 		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks,
-				true, &tp);
+				0, true, &tp);
 		if (error)
 			return error;
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 156b9ed8534f..151f274eee43 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1038,6 +1038,7 @@ xfs_trans_alloc_inode(
 	struct xfs_inode	*ip,
 	struct xfs_trans_res	*resv,
 	unsigned int		dblocks,
+	unsigned int		rblocks,
 	bool			force,
 	struct xfs_trans	**tpp)
 {
@@ -1045,7 +1046,8 @@ xfs_trans_alloc_inode(
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error;
 
-	error = xfs_trans_alloc(mp, resv, dblocks, 0,
+	error = xfs_trans_alloc(mp, resv, dblocks,
+			rblocks / mp->m_sb.sb_rextsize,
 			force ? XFS_TRANS_RESERVE : 0, &tp);
 	if (error)
 		return error;
@@ -1060,7 +1062,7 @@ xfs_trans_alloc_inode(
 		goto out_cancel;
 	}
 
-	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, 0, force);
+	error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
 	if (error)
 		goto out_cancel;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index aa50be244432..52bbd7e6a552 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -269,6 +269,7 @@ xfs_trans_item_relog(
 }
 
 int xfs_trans_alloc_inode(struct xfs_inode *ip, struct xfs_trans_res *resv,
-		unsigned int dblocks, bool force, struct xfs_trans **tpp);
+		unsigned int dblocks, unsigned int rblocks, bool force,
+		struct xfs_trans **tpp);
 
 #endif	/* __XFS_TRANS_H__ */

