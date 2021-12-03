Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6697466E1F
	for <lists+linux-xfs@lfdr.de>; Fri,  3 Dec 2021 01:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377716AbhLCAEn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 2 Dec 2021 19:04:43 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:35759 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349677AbhLCAEm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:42 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id CC959869D48
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:16 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00G1Km-TV
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:14 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00Bkhe-Rj
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 18/36] xfs: use active perag references for inode allocation
Date:   Fri,  3 Dec 2021 11:00:53 +1100
Message-Id: <20211203000111.2800982-19-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61a95e4c
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=hyD8EJl_wcQEvN-__RsA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Convert the inode allocation routines to use active perag references
or references held by callers rather than grab their own. Also drive
the perag further inwards to replace xfs_mounts when doing
operations on a specific AG.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c     |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c | 63 +++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_ialloc.h |  2 +-
 3 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 3b68706a0691..c866274cb8ce 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -934,7 +934,7 @@ xfs_ag_shrink_space(
 	 * Make sure that the last inode cluster cannot overlap with the new
 	 * end of the AG, even if it's sparse.
 	 */
-	error = xfs_ialloc_check_shrink(*tpp, pag->pag_agno, agibp, aglen - delta);
+	error = xfs_ialloc_check_shrink(pag, *tpp, agibp, aglen - delta);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b444fa68213b..894810fece4f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -169,14 +169,14 @@ xfs_inobt_insert_rec(
  */
 STATIC int
 xfs_inobt_insert(
-	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag,
 	xfs_agino_t		newino,
 	xfs_agino_t		newlen,
 	xfs_btnum_t		btnum)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_btree_cur	*cur;
 	xfs_agino_t		thisino;
 	int			i;
@@ -514,14 +514,14 @@ __xfs_inobt_rec_merge(
  */
 STATIC int
 xfs_inobt_insert_sprec(
-	struct xfs_mount		*mp,
+	struct xfs_perag		*pag,
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
-	struct xfs_perag		*pag,
 	int				btnum,
 	struct xfs_inobt_rec_incore	*nrec,	/* in/out: new/merged rec. */
 	bool				merge)	/* merge or replace */
 {
+	struct xfs_mount		*mp = pag->pag_mount;
 	struct xfs_btree_cur		*cur;
 	int				error;
 	int				i;
@@ -609,9 +609,9 @@ xfs_inobt_insert_sprec(
  */
 STATIC int
 xfs_ialloc_ag_alloc(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag)
+	struct xfs_buf		*agbp)
 {
 	struct xfs_agi		*agi;
 	struct xfs_alloc_arg	args;
@@ -831,7 +831,7 @@ xfs_ialloc_ag_alloc(
 		 * if necessary. If a merge does occur, rec is updated to the
 		 * merged record.
 		 */
-		error = xfs_inobt_insert_sprec(args.mp, tp, agbp, pag,
+		error = xfs_inobt_insert_sprec(pag, tp, agbp,
 				XFS_BTNUM_INO, &rec, true);
 		if (error == -EFSCORRUPTED) {
 			xfs_alert(args.mp,
@@ -856,20 +856,20 @@ xfs_ialloc_ag_alloc(
 		 * existing record with this one.
 		 */
 		if (xfs_has_finobt(args.mp)) {
-			error = xfs_inobt_insert_sprec(args.mp, tp, agbp, pag,
+			error = xfs_inobt_insert_sprec(pag, tp, agbp,
 				       XFS_BTNUM_FINO, &rec, false);
 			if (error)
 				return error;
 		}
 	} else {
 		/* full chunk - insert new records to both btrees */
-		error = xfs_inobt_insert(args.mp, tp, agbp, pag, newino, newlen,
+		error = xfs_inobt_insert(pag, tp, agbp, newino, newlen,
 					 XFS_BTNUM_INO);
 		if (error)
 			return error;
 
 		if (xfs_has_finobt(args.mp)) {
-			error = xfs_inobt_insert(args.mp, tp, agbp, pag, newino,
+			error = xfs_inobt_insert(pag, tp, agbp, newino,
 						 newlen, XFS_BTNUM_FINO);
 			if (error)
 				return error;
@@ -981,9 +981,9 @@ xfs_inobt_first_free_inode(
  */
 STATIC int
 xfs_dialloc_ag_inobt(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag,
 	xfs_ino_t		parent,
 	xfs_ino_t		*inop)
 {
@@ -1429,9 +1429,9 @@ xfs_dialloc_ag_update_inobt(
  */
 static int
 xfs_dialloc_ag(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag,
 	xfs_ino_t		parent,
 	xfs_ino_t		*inop)
 {
@@ -1448,7 +1448,7 @@ xfs_dialloc_ag(
 	int				i;
 
 	if (!xfs_has_finobt(mp))
-		return xfs_dialloc_ag_inobt(tp, agbp, pag, parent, inop);
+		return xfs_dialloc_ag_inobt(pag, tp, agbp, parent, inop);
 
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
@@ -1594,8 +1594,8 @@ xfs_ialloc_next_ag(
 
 static bool
 xfs_dialloc_good_ag(
-	struct xfs_trans	*tp,
 	struct xfs_perag	*pag,
+	struct xfs_trans	*tp,
 	umode_t			mode,
 	int			flags,
 	bool			ok_alloc)
@@ -1606,6 +1606,8 @@ xfs_dialloc_good_ag(
 	int			needspace;
 	int			error;
 
+	if (!pag)
+		return false;
 	if (!pag->pagi_inodeok)
 		return false;
 
@@ -1665,8 +1667,8 @@ xfs_dialloc_good_ag(
 
 static int
 xfs_dialloc_try_ag(
-	struct xfs_trans	**tpp,
 	struct xfs_perag	*pag,
+	struct xfs_trans	**tpp,
 	xfs_ino_t		parent,
 	xfs_ino_t		*new_ino,
 	bool			ok_alloc)
@@ -1689,7 +1691,7 @@ xfs_dialloc_try_ag(
 			goto out_release;
 		}
 
-		error = xfs_ialloc_ag_alloc(*tpp, agbp, pag);
+		error = xfs_ialloc_ag_alloc(pag, *tpp, agbp);
 		if (error < 0)
 			goto out_release;
 
@@ -1705,7 +1707,7 @@ xfs_dialloc_try_ag(
 	}
 
 	/* Allocate an inode in the found AG */
-	error = xfs_dialloc_ag(*tpp, agbp, pag, parent, &ino);
+	error = xfs_dialloc_ag(pag, *tpp, agbp, parent, &ino);
 	if (!error)
 		*new_ino = ino;
 	return error;
@@ -1775,9 +1777,9 @@ xfs_dialloc(
 	agno = start_agno;
 	flags = XFS_ALLOC_FLAG_TRYLOCK;
 	for (;;) {
-		pag = xfs_perag_get(mp, agno);
-		if (xfs_dialloc_good_ag(*tpp, pag, mode, flags, ok_alloc)) {
-			error = xfs_dialloc_try_ag(tpp, pag, parent,
+		pag = xfs_perag_grab(mp, agno);
+		if (xfs_dialloc_good_ag(pag, *tpp, mode, flags, ok_alloc)) {
+			error = xfs_dialloc_try_ag(pag, tpp, parent,
 					&ino, ok_alloc);
 			if (error != -EAGAIN)
 				break;
@@ -1796,12 +1798,12 @@ xfs_dialloc(
 			}
 			flags = 0;
 		}
-		xfs_perag_put(pag);
+		xfs_perag_rele(pag);
 	}
 
 	if (!error)
 		*new_ino = ino;
-	xfs_perag_put(pag);
+	xfs_perag_rele(pag);
 	return error;
 }
 
@@ -1885,14 +1887,14 @@ xfs_difree_inode_chunk(
 
 STATIC int
 xfs_difree_inobt(
-	struct xfs_mount		*mp,
+	struct xfs_perag		*pag,
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
-	struct xfs_perag		*pag,
 	xfs_agino_t			agino,
 	struct xfs_icluster		*xic,
 	struct xfs_inobt_rec_incore	*orec)
 {
+	struct xfs_mount		*mp = pag->pag_mount;
 	struct xfs_agi			*agi = agbp->b_addr;
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
@@ -2019,13 +2021,13 @@ xfs_difree_inobt(
  */
 STATIC int
 xfs_difree_finobt(
-	struct xfs_mount		*mp,
+	struct xfs_perag		*pag,
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
-	struct xfs_perag		*pag,
 	xfs_agino_t			agino,
 	struct xfs_inobt_rec_incore	*ibtrec) /* inobt record */
 {
+	struct xfs_mount		*mp = pag->pag_mount;
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
 	int				offset = agino - ibtrec->ir_startino;
@@ -2179,7 +2181,7 @@ xfs_difree(
 	/*
 	 * Fix up the inode allocation btree.
 	 */
-	error = xfs_difree_inobt(mp, tp, agbp, pag, agino, xic, &rec);
+	error = xfs_difree_inobt(pag, tp, agbp, agino, xic, &rec);
 	if (error)
 		goto error0;
 
@@ -2187,7 +2189,7 @@ xfs_difree(
 	 * Fix up the free inode btree.
 	 */
 	if (xfs_has_finobt(mp)) {
-		error = xfs_difree_finobt(mp, tp, agbp, pag, agino, &rec);
+		error = xfs_difree_finobt(pag, tp, agbp, agino, &rec);
 		if (error)
 			goto error0;
 	}
@@ -2909,15 +2911,14 @@ xfs_ialloc_calc_rootino(
  */
 int
 xfs_ialloc_check_shrink(
+	struct xfs_perag	*pag,
 	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
 	struct xfs_buf		*agibp,
 	xfs_agblock_t		new_length)
 {
 	struct xfs_inobt_rec_incore rec;
 	struct xfs_btree_cur	*cur;
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_perag	*pag;
 	xfs_agino_t		agino = XFS_AGB_TO_AGINO(mp, new_length);
 	int			has;
 	int			error;
@@ -2925,7 +2926,6 @@ xfs_ialloc_check_shrink(
 	if (!xfs_has_sparseinodes(mp))
 		return 0;
 
-	pag = xfs_perag_get(mp, agno);
 	cur = xfs_inobt_init_cursor(mp, tp, agibp, pag, XFS_BTNUM_INO);
 
 	/* Look up the inobt record that would correspond to the new EOFS. */
@@ -2949,6 +2949,5 @@ xfs_ialloc_check_shrink(
 	}
 out:
 	xfs_btree_del_cursor(cur, error);
-	xfs_perag_put(pag);
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 85462e466029..6cab50e1c3d7 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -107,7 +107,7 @@ int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
 void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
 xfs_ino_t xfs_ialloc_calc_rootino(struct xfs_mount *mp, int sunit);
 
-int xfs_ialloc_check_shrink(struct xfs_trans *tp, xfs_agnumber_t agno,
+int xfs_ialloc_check_shrink(struct xfs_perag *pag, struct xfs_trans *tp,
 		struct xfs_buf *agibp, xfs_agblock_t new_length);
 
 #endif	/* __XFS_IALLOC_H__ */
-- 
2.33.0

