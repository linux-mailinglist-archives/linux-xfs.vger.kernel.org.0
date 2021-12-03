Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20056466E2C
	for <lists+linux-xfs@lfdr.de>; Fri,  3 Dec 2021 01:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377743AbhLCAEs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 2 Dec 2021 19:04:48 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:37189 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377734AbhLCAEs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Dec 2021 19:04:48 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id B75B8869DA1
        for <linux-xfs@vger.kernel.org>; Fri,  3 Dec 2021 11:01:23 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00G1KU-Ly
        for linux-xfs@vger.kernel.org; Fri, 03 Dec 2021 11:01:14 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1msw0o-00BkhA-KT
        for linux-xfs@vger.kernel.org;
        Fri, 03 Dec 2021 11:01:14 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/36] xfs: Pre-calculate per-AG agino geometry
Date:   Fri,  3 Dec 2021 11:00:47 +1100
Message-Id: <20211203000111.2800982-13-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203000111.2800982-1-david@fromorbit.com>
References: <20211203000111.2800982-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61a95e53
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=IOMw9HtfNCkA:10 a=20KFwNOVAAAA:8 a=bBAovAi8A5TlA2pvHlEA:9
        a=zIcJ-Kr0tPI675qt:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

There is a lot of overhead in functions like xfs_verify_agino() that
repeatedly calculate the geometry limits of an AG. These can be
pre-calculated as they are static and the verification context has
a per-ag context it can quickly reference.

In the case of xfs_verify_agino(), we now always have a perag
context handy, so we can store the minimum and maximum agino values
in the AG in the perag. This means we don't have to calculate
it on every call and it can be inlined in callers if we move it
to xfs_ag.h.

xfs_verify_agino_or_null() gets the same perag treatment.

xfs_agino_range() is moved to xfs_ag.c as it's not really a type
function, and it's use is largely restricted as the first and last
aginos can be grabbed straight from the perag in most cases.

Note that we leave the original xfs_verify_agino in place in
xfs_types.c as a static function as other callers in that file do
not have per-ag contexts so still need to go the long way. It's been
renamed to xfs_verify_agno_agino() to indicate it takes both an agno
and an agino to differentiate it from new function.

$ size --totals fs/xfs/built-in.a
	   text    data     bss     dec     hex filename
before	1136681  322835     484 1460000  164720 (TOTALS)
after	1136315  322835     484 1459634  1645b2 (TOTALS)

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c        | 39 +++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_ag.h        | 30 +++++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc.c    |  6 ++--
 fs/xfs/libxfs/xfs_inode_buf.c |  3 +-
 fs/xfs/libxfs/xfs_sb.c        |  9 ++++++
 fs/xfs/libxfs/xfs_types.c     | 55 ++++-------------------------------
 fs/xfs/libxfs/xfs_types.h     |  6 ----
 fs/xfs/scrub/agheader.c       |  6 ++--
 fs/xfs/scrub/ialloc.c         |  6 ++--
 fs/xfs/scrub/repair.c         |  9 ++----
 fs/xfs/xfs_inode.c            | 14 ++++-----
 11 files changed, 104 insertions(+), 79 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index d6af12d2510b..730170dc83a9 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -226,6 +226,41 @@ xfs_ag_block_count(
 			mp->m_sb.sb_dblocks);
 }
 
+/* Calculate the first and last possible inode number in an AG. */
+static void
+__xfs_agino_range(
+	struct xfs_mount	*mp,
+	xfs_agblock_t		eoag,
+	xfs_agino_t		*first,
+	xfs_agino_t		*last)
+{
+	xfs_agblock_t		bno;
+
+	/*
+	 * Calculate the first inode, which will be in the first
+	 * cluster-aligned block after the AGFL.
+	 */
+	bno = round_up(XFS_AGFL_BLOCK(mp) + 1, M_IGEO(mp)->cluster_align);
+	*first = XFS_AGB_TO_AGINO(mp, bno);
+
+	/*
+	 * Calculate the last inode, which will be at the end of the
+	 * last (aligned) cluster that can be allocated in the AG.
+	 */
+	bno = round_down(eoag, M_IGEO(mp)->cluster_align);
+	*last = XFS_AGB_TO_AGINO(mp, bno) - 1;
+}
+
+void
+xfs_agino_range(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		*first,
+	xfs_agino_t		*last)
+{
+	return __xfs_agino_range(mp, xfs_ag_block_count(mp, agno), first, last);
+}
+
 int
 xfs_initialize_perag(
 	struct xfs_mount	*mp,
@@ -303,6 +338,8 @@ xfs_initialize_perag(
 		pag->block_count = __xfs_ag_block_count(mp, index, agcount,
 				dblocks);
 		pag->min_block = XFS_AGFL_BLOCK(mp);
+		__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
+				&pag->agino_max);
 	}
 
 	index = xfs_set_inode_alloc(mp, agcount);
@@ -968,6 +1005,8 @@ xfs_ag_extend_space(
 
 	/* Update perag geometry */
 	pag->block_count = be32_to_cpu(agf->agf_length);
+	__xfs_agino_range(pag->pag_mount, pag->block_count, &pag->agino_min,
+				&pag->agino_max);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 77640f1409fd..bb9e91bd38e2 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -70,6 +70,8 @@ struct xfs_perag {
 	/* Precalculated geometry info */
 	xfs_agblock_t		block_count;
 	xfs_agblock_t		min_block;
+	xfs_agino_t		agino_min;
+	xfs_agino_t		agino_max;
 
 #ifdef __KERNEL__
 	/* -- kernel only structures below this line -- */
@@ -124,6 +126,8 @@ void xfs_perag_put(struct xfs_perag *pag);
  * Per-ag geometry infomation and validation
  */
 xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
+void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_agino_t *first, xfs_agino_t *last);
 
 static inline bool
 xfs_verify_agbno(struct xfs_perag *pag, xfs_agblock_t agbno)
@@ -135,6 +139,32 @@ xfs_verify_agbno(struct xfs_perag *pag, xfs_agblock_t agbno)
 	return true;
 }
 
+/*
+ * Verify that an AG inode number pointer neither points outside the AG
+ * nor points at static metadata.
+ */
+static inline bool
+xfs_verify_agino(struct xfs_perag *pag, xfs_agino_t agino)
+{
+	if (agino < pag->agino_min)
+		return false;
+	if (agino > pag->agino_max)
+		return false;
+	return true;
+}
+
+/*
+ * Verify that an AG inode number pointer neither points outside the AG
+ * nor points at static metadata, or is NULLAGINO.
+ */
+static inline bool
+xfs_verify_agino_or_null(struct xfs_perag *pag, xfs_agino_t agino)
+{
+	if (agino == NULLAGINO)
+		return true;
+	return xfs_verify_agino(pag, agino);
+}
+
 /*
  * Perag iteration APIs
  */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b4fef0de2bb8..459a352e1790 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -105,7 +105,6 @@ xfs_inobt_get_rec(
 	int				*stat)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
-	xfs_agnumber_t			agno = cur->bc_ag.pag->pag_agno;
 	union xfs_btree_rec		*rec;
 	int				error;
 	uint64_t			realfree;
@@ -116,7 +115,7 @@ xfs_inobt_get_rec(
 
 	xfs_inobt_btrec_to_irec(mp, rec, irec);
 
-	if (!xfs_verify_agino(mp, agno, irec->ir_startino))
+	if (!xfs_verify_agino(cur->bc_ag.pag, irec->ir_startino))
 		goto out_bad_rec;
 	if (irec->ir_count < XFS_INODES_PER_HOLEMASK_BIT ||
 	    irec->ir_count > XFS_INODES_PER_CHUNK)
@@ -137,7 +136,8 @@ xfs_inobt_get_rec(
 out_bad_rec:
 	xfs_warn(mp,
 		"%s Inode BTree record corruption in AG %d detected!",
-		cur->bc_btnum == XFS_BTNUM_INO ? "Used" : "Free", agno);
+		cur->bc_btnum == XFS_BTNUM_INO ? "Used" : "Free",
+		cur->bc_ag.pag->pag_agno);
 	xfs_warn(mp,
 "start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
 		irec->ir_startino, irec->ir_count, irec->ir_freecount,
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index cae9708c8587..9bb1e785245c 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -10,6 +10,7 @@
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_ag.h"
 #include "xfs_inode.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
@@ -59,7 +60,7 @@ xfs_inode_buf_verify(
 		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
 		di_ok = xfs_verify_magic16(bp, dip->di_magic) &&
 			xfs_dinode_good_version(mp, dip->di_version) &&
-			xfs_verify_agino_or_null(mp, agno, unlinked_ino);
+			xfs_verify_agino_or_null(bp->b_pag, unlinked_ino);
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP))) {
 			if (readahead) {
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f4e84aa1d50a..96f06e11ce58 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -196,6 +196,15 @@ xfs_validate_sb_write(
 	    (sbp->sb_fdblocks > sbp->sb_dblocks ||
 	     !xfs_verify_icount(mp, sbp->sb_icount) ||
 	     sbp->sb_ifree > sbp->sb_icount)) {
+	     /*
+		printk("pag blocks %d agblocks %d min_ino %d max_ino %d\n",
+			bp->b_pag->block_count,
+			xfs_ag_block_count(mp, bp->b_pag->pag_agno),
+			bp->b_pag->agino_min, bp->b_pag->agino_max);
+		*/
+		printk("sb dblocks %lld fdblocks %lld icount %lld, ifree %lld\n",
+			sbp->sb_dblocks, sbp->sb_fdblocks, sbp->sb_icount,
+			sbp->sb_ifree);
 		xfs_warn(mp, "SB summary counter sanity check failed");
 		return -EFSCORRUPTED;
 	}
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index b3c6b0274e95..5c2765934732 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -73,40 +73,12 @@ xfs_verify_fsbext(
 		XFS_FSB_TO_AGNO(mp, fsbno + len - 1);
 }
 
-/* Calculate the first and last possible inode number in an AG. */
-inline void
-xfs_agino_range(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	xfs_agino_t		*first,
-	xfs_agino_t		*last)
-{
-	xfs_agblock_t		bno;
-	xfs_agblock_t		eoag;
-
-	eoag = xfs_ag_block_count(mp, agno);
-
-	/*
-	 * Calculate the first inode, which will be in the first
-	 * cluster-aligned block after the AGFL.
-	 */
-	bno = round_up(XFS_AGFL_BLOCK(mp) + 1, M_IGEO(mp)->cluster_align);
-	*first = XFS_AGB_TO_AGINO(mp, bno);
-
-	/*
-	 * Calculate the last inode, which will be at the end of the
-	 * last (aligned) cluster that can be allocated in the AG.
-	 */
-	bno = round_down(eoag, M_IGEO(mp)->cluster_align);
-	*last = XFS_AGB_TO_AGINO(mp, bno) - 1;
-}
-
 /*
  * Verify that an AG inode number pointer neither points outside the AG
  * nor points at static metadata.
  */
-inline bool
-xfs_verify_agino(
+static inline bool
+xfs_verify_agno_agino(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	xfs_agino_t		agino)
@@ -118,19 +90,6 @@ xfs_verify_agino(
 	return agino >= first && agino <= last;
 }
 
-/*
- * Verify that an AG inode number pointer neither points outside the AG
- * nor points at static metadata, or is NULLAGINO.
- */
-bool
-xfs_verify_agino_or_null(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno,
-	xfs_agino_t		agino)
-{
-	return agino == NULLAGINO || xfs_verify_agino(mp, agno, agino);
-}
-
 /*
  * Verify that an FS inode number pointer neither points outside the
  * filesystem nor points at static AG metadata.
@@ -147,7 +106,7 @@ xfs_verify_ino(
 		return false;
 	if (XFS_AGINO_TO_INO(mp, agno, agino) != ino)
 		return false;
-	return xfs_verify_agino(mp, agno, agino);
+	return xfs_verify_agno_agino(mp, agno, agino);
 }
 
 /* Is this an internal inode number? */
@@ -217,12 +176,8 @@ xfs_icount_range(
 	/* root, rtbitmap, rtsum all live in the first chunk */
 	*min = XFS_INODES_PER_CHUNK;
 
-	for_each_perag(mp, agno, pag) {
-		xfs_agino_t	first, last;
-
-		xfs_agino_range(mp, agno, &first, &last);
-		nr_inos += last - first + 1;
-	}
+	for_each_perag(mp, agno, pag)
+		nr_inos += pag->agino_max - pag->agino_min + 1;
 	*max = nr_inos;
 }
 
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index b417e8929235..ebf07c99c1ba 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -190,12 +190,6 @@ bool xfs_verify_fsbno(struct xfs_mount *mp, xfs_fsblock_t fsbno);
 bool xfs_verify_fsbext(struct xfs_mount *mp, xfs_fsblock_t fsbno,
 		xfs_fsblock_t len);
 
-void xfs_agino_range(struct xfs_mount *mp, xfs_agnumber_t agno,
-		xfs_agino_t *first, xfs_agino_t *last);
-bool xfs_verify_agino(struct xfs_mount *mp, xfs_agnumber_t agno,
-		xfs_agino_t agino);
-bool xfs_verify_agino_or_null(struct xfs_mount *mp, xfs_agnumber_t agno,
-		xfs_agino_t agino);
 bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 60d7a7d5ea97..94d000fd97b7 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -902,17 +902,17 @@ xchk_agi(
 
 	/* Check inode pointers */
 	agino = be32_to_cpu(agi->agi_newino);
-	if (!xfs_verify_agino_or_null(mp, agno, agino))
+	if (!xfs_verify_agino_or_null(pag, agino))
 		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 	agino = be32_to_cpu(agi->agi_dirino);
-	if (!xfs_verify_agino_or_null(mp, agno, agino))
+	if (!xfs_verify_agino_or_null(pag, agino))
 		xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 
 	/* Check unlinked inode buckets */
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
 		agino = be32_to_cpu(agi->agi_unlinked[i]);
-		if (!xfs_verify_agino_or_null(mp, agno, agino))
+		if (!xfs_verify_agino_or_null(pag, agino))
 			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
 	}
 
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index b80a54be8634..e1026e07bf94 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -421,10 +421,10 @@ xchk_iallocbt_rec(
 	const union xfs_btree_rec	*rec)
 {
 	struct xfs_mount		*mp = bs->cur->bc_mp;
+	struct xfs_perag		*pag = bs->cur->bc_ag.pag;
 	struct xchk_iallocbt		*iabt = bs->private;
 	struct xfs_inobt_rec_incore	irec;
 	uint64_t			holes;
-	xfs_agnumber_t			agno = bs->cur->bc_ag.pag->pag_agno;
 	xfs_agino_t			agino;
 	xfs_extlen_t			len;
 	int				holecount;
@@ -446,8 +446,8 @@ xchk_iallocbt_rec(
 
 	agino = irec.ir_startino;
 	/* Record has to be properly aligned within the AG. */
-	if (!xfs_verify_agino(mp, agno, agino) ||
-	    !xfs_verify_agino(mp, agno, agino + XFS_INODES_PER_CHUNK - 1)) {
+	if (!xfs_verify_agino(pag, agino) ||
+	    !xfs_verify_agino(pag, agino + XFS_INODES_PER_CHUNK - 1)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 		goto out;
 	}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 7c519cebb362..d8da7f994669 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -219,16 +219,13 @@ xrep_calc_ag_resblks(
 		usedlen = aglen - freelen;
 		xfs_buf_relse(bp);
 	}
-	xfs_perag_put(pag);
 
 	/* If the icount is impossible, make some worst-case assumptions. */
 	if (icount == NULLAGINO ||
-	    !xfs_verify_agino(mp, sm->sm_agno, icount)) {
-		xfs_agino_t	first, last;
-
-		xfs_agino_range(mp, sm->sm_agno, &first, &last);
-		icount = last - first + 1;
+	    !xfs_verify_agino(pag, icount)) {
+		icount = pag->agino_max - pag->agino_min + 1;
 	}
+	xfs_perag_put(pag);
 
 	/* If the block counts are impossible, make worst-case assumptions. */
 	if (aglen == NULLAGBLOCK ||
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c07043393643..52b296d76d11 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2034,7 +2034,7 @@ xfs_iunlink_update_bucket(
 	xfs_agino_t		old_value;
 	int			offset;
 
-	ASSERT(xfs_verify_agino_or_null(tp->t_mountp, pag->pag_agno, new_agino));
+	ASSERT(xfs_verify_agino_or_null(pag, new_agino));
 
 	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 	trace_xfs_iunlink_update_bucket(tp->t_mountp, pag->pag_agno, bucket_index,
@@ -2071,7 +2071,7 @@ xfs_iunlink_update_dinode(
 	struct xfs_mount	*mp = tp->t_mountp;
 	int			offset;
 
-	ASSERT(xfs_verify_agino_or_null(mp, pag->pag_agno, next_agino));
+	ASSERT(xfs_verify_agino_or_null(pag, next_agino));
 
 	trace_xfs_iunlink_update_dinode(mp, pag->pag_agno, agino,
 			be32_to_cpu(dip->di_next_unlinked), next_agino);
@@ -2101,7 +2101,7 @@ xfs_iunlink_update_inode(
 	xfs_agino_t		old_value;
 	int			error;
 
-	ASSERT(xfs_verify_agino_or_null(mp, pag->pag_agno, next_agino));
+	ASSERT(xfs_verify_agino_or_null(pag, next_agino));
 
 	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
 	if (error)
@@ -2110,7 +2110,7 @@ xfs_iunlink_update_inode(
 
 	/* Make sure the old pointer isn't garbage. */
 	old_value = be32_to_cpu(dip->di_next_unlinked);
-	if (!xfs_verify_agino_or_null(mp, pag->pag_agno, old_value)) {
+	if (!xfs_verify_agino_or_null(pag, old_value)) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
 				sizeof(*dip), __this_address);
 		error = -EFSCORRUPTED;
@@ -2181,7 +2181,7 @@ xfs_iunlink(
 	 */
 	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 	if (next_agino == agino ||
-	    !xfs_verify_agino_or_null(mp, pag->pag_agno, next_agino)) {
+	    !xfs_verify_agino_or_null(pag, next_agino)) {
 		xfs_buf_mark_corrupt(agibp);
 		error = -EFSCORRUPTED;
 		goto out;
@@ -2317,7 +2317,7 @@ xfs_iunlink_map_prev(
 		 * Make sure this pointer is valid and isn't an obvious
 		 * infinite loop.
 		 */
-		if (!xfs_verify_agino(mp, pag->pag_agno, unlinked_agino) ||
+		if (!xfs_verify_agino(pag, unlinked_agino) ||
 		    next_agino == unlinked_agino) {
 			XFS_CORRUPTION_ERROR(__func__,
 					XFS_ERRLEVEL_LOW, mp,
@@ -2364,7 +2364,7 @@ xfs_iunlink_remove(
 	 * go on.  Make sure the head pointer isn't garbage.
 	 */
 	head_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	if (!xfs_verify_agino(mp, pag->pag_agno, head_agino)) {
+	if (!xfs_verify_agino(pag, head_agino)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				agi, sizeof(*agi));
 		return -EFSCORRUPTED;
-- 
2.33.0

