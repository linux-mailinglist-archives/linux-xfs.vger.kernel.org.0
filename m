Return-Path: <linux-xfs+bounces-8506-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB318CB932
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 04:54:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A04D8281FF7
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 02:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C65F8200B7;
	Wed, 22 May 2024 02:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b/mnFJOg"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867F21DFD0
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346439; cv=none; b=pnXeC7Di/yLTzatQi3vUov3MzVHwhMtdmSVBMWqMPTy70Tn1ZDefwbBPpdMwi82/3kS3eqTMR4VG+8qiBWYCsRuwDFAW9shD15+fXhd94ruIUgmN94QpriD7v8FfANi327HyiKiDOojDk+qk1nj7PYAc3m90hCX59a3P5vM5qsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346439; c=relaxed/simple;
	bh=w2o+OFeOWMFz/vHT+ZPq4WEQuW81I+SPKNx+JF8AIlw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rDrSeDpR9c+TqbGNh2UskfLULOUvlv6mfT3AAr+fCDlWP3HcGOoipfxigCrzxjhwNfhBIwgfztvBMbhc71+w3jMlGVbm3z/jy6rWU9SJf2eHMoOag3uaAC+7aVvBVPL5JzEz39Q5zQp8X5AOH9kzF9iSK3Piwnbcbb4iNsaGNyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b/mnFJOg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D39AC2BD11;
	Wed, 22 May 2024 02:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346439;
	bh=w2o+OFeOWMFz/vHT+ZPq4WEQuW81I+SPKNx+JF8AIlw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b/mnFJOg3Vx95a8VBy2bmQPvCtzzMbfHVeZCDAwIVVa6BAmHVBWKF33HQgCm3+r5A
	 jrmw44ezhKOdhROYnHM5B70JxyU3NBxfQdp7xc/CIY2rp+vuD591SfH1bXrOv/dkYZ
	 2CQbE+DBf+ogYGxQ9TcWaZUIFlc56j+47Mq+kJqw7QDPvs0XRgBqFC9Vhm1DayjinT
	 HBE7j+nJiMDq6W6Hy5blto2v7TL381CqbskLhtvEMbbcDMYChDFZy1gS9Y5e/9RK35
	 sfv0THX8Z+XnOlvyxbn+BSrgVb9JRQ0rDueZWPxPAVV4vpYs7W0y6G2h8QesyomEMm
	 vZsdP/ZLj/bhg==
Date: Tue, 21 May 2024 19:53:58 -0700
Subject: [PATCH 020/111] xfs: report btree block corruption errors to the
 health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532011.2478931.16233258605680592398.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: a78d10f45b23149f1b23019a4f4fb57dcf852e39

Whenever we encounter corrupt btree blocks, we should report that to the
health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/util.c         |    1 +
 libxfs/xfs_alloc.c    |    2 ++
 libxfs/xfs_bmap.c     |    6 ++++++
 libxfs/xfs_btree.c    |   25 ++++++++++++++++++++++---
 libxfs/xfs_health.h   |    2 ++
 libxfs/xfs_ialloc.c   |    1 +
 libxfs/xfs_refcount.c |    6 +++++-
 libxfs/xfs_rmap.c     |    6 +++++-
 8 files changed, 44 insertions(+), 5 deletions(-)


diff --git a/libxfs/util.c b/libxfs/util.c
index 2403d64b4..b45d67065 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -733,3 +733,4 @@ void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int mask) { }
 void xfs_ag_mark_sick(struct xfs_perag *pag, unsigned int mask) { }
 void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork) { }
+void xfs_btree_mark_sick(struct xfs_btree_cur *cur) { }
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 1894a0913..aa084120c 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -271,6 +271,7 @@ xfs_alloc_complain_bad_rec(
 	xfs_warn(mp,
 		"start block 0x%x block count 0x%x", irec->ar_startblock,
 		irec->ar_blockcount);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -2698,6 +2699,7 @@ xfs_exact_minlen_extent_available(
 		goto out;
 
 	if (*stat == 0) {
+		xfs_btree_mark_sick(cnt_cur);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4d21720e9..f15631818 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -362,6 +362,8 @@ xfs_bmap_check_leaf_extents(
 			error = xfs_btree_read_bufl(mp, NULL, bno, &bp,
 						XFS_BMAP_BTREE_REF,
 						&xfs_bmbt_buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_btree_mark_sick(cur);
 			if (error)
 				goto error_norelse;
 		}
@@ -448,6 +450,8 @@ xfs_bmap_check_leaf_extents(
 			error = xfs_btree_read_bufl(mp, NULL, bno, &bp,
 						XFS_BMAP_BTREE_REF,
 						&xfs_bmbt_buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_btree_mark_sick(cur);
 			if (error)
 				goto error_norelse;
 		}
@@ -562,6 +566,8 @@ xfs_bmap_btree_to_extents(
 #endif
 	error = xfs_btree_read_bufl(mp, tp, cbno, &cbp, XFS_BMAP_BTREE_REF,
 				&xfs_bmbt_buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_btree_mark_sick(cur);
 	if (error)
 		return error;
 	cblock = XFS_BUF_TO_BLOCK(cbp);
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 663439ec3..359d3f99e 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -24,6 +24,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_health.h"
 
 /*
  * Btree magic numbers.
@@ -174,6 +175,7 @@ xfs_btree_check_lblock(
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_LBLOCK)) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}
 	return 0;
@@ -240,6 +242,7 @@ xfs_btree_check_sblock(
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_SBLOCK)) {
 		if (bp)
 			trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}
 	return 0;
@@ -315,6 +318,7 @@ xfs_btree_check_ptr(
 				level, index);
 	}
 
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -495,6 +499,8 @@ xfs_btree_dup_cursor(
 						   xfs_buf_daddr(bp), mp->m_bsize,
 						   0, &bp,
 						   cur->bc_ops->buf_ops);
+			if (xfs_metadata_is_sick(error))
+				xfs_btree_mark_sick(new);
 			if (error) {
 				xfs_btree_del_cursor(new, error);
 				*ncur = NULL;
@@ -1348,6 +1354,8 @@ xfs_btree_read_buf_block(
 	error = xfs_trans_read_buf(mp, cur->bc_tp, mp->m_ddev_targp, d,
 				   mp->m_bsize, flags, bpp,
 				   cur->bc_ops->buf_ops);
+	if (xfs_metadata_is_sick(error))
+		xfs_btree_mark_sick(cur);
 	if (error)
 		return error;
 
@@ -1658,6 +1666,7 @@ xfs_btree_increment(
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			goto out0;
 		ASSERT(0);
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1751,6 +1760,7 @@ xfs_btree_decrement(
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			goto out0;
 		ASSERT(0);
+		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
 		goto error0;
 	}
@@ -1843,6 +1853,7 @@ xfs_btree_lookup_get_block(
 	*blkp = NULL;
 	xfs_buf_mark_corrupt(bp);
 	xfs_trans_brelse(cur->bc_tp, bp);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -1889,8 +1900,10 @@ xfs_btree_lookup(
 	XFS_BTREE_STATS_INC(cur, lookup);
 
 	/* No such thing as a zero-level tree. */
-	if (XFS_IS_CORRUPT(cur->bc_mp, cur->bc_nlevels == 0))
+	if (XFS_IS_CORRUPT(cur->bc_mp, cur->bc_nlevels == 0)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	block = NULL;
 	keyno = 0;
@@ -1933,6 +1946,7 @@ xfs_btree_lookup(
 							XFS_ERRLEVEL_LOW,
 							cur->bc_mp, block,
 							sizeof(*block));
+					xfs_btree_mark_sick(cur);
 					return -EFSCORRUPTED;
 				}
 
@@ -4366,12 +4380,16 @@ xfs_btree_visit_block(
 	 */
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
 		if (be64_to_cpu(rptr.l) == XFS_DADDR_TO_FSB(cur->bc_mp,
-							xfs_buf_daddr(bp)))
+							xfs_buf_daddr(bp))) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 	} else {
 		if (be32_to_cpu(rptr.s) == xfs_daddr_to_agbno(cur->bc_mp,
-							xfs_buf_daddr(bp)))
+							xfs_buf_daddr(bp))) {
+			xfs_btree_mark_sick(cur);
 			return -EFSCORRUPTED;
+		}
 	}
 	return xfs_btree_lookup_get_block(cur, level, &rptr, &block);
 }
@@ -5230,6 +5248,7 @@ xfs_btree_goto_left_edge(
 		return error;
 	if (stat != 0) {
 		ASSERT(0);
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 3c8fd0607..8f566a787 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -37,6 +37,7 @@ struct xfs_mount;
 struct xfs_perag;
 struct xfs_inode;
 struct xfs_fsop_geom;
+struct xfs_btree_cur;
 
 /* Observable health issues for metadata spanning the entire filesystem. */
 #define XFS_SICK_FS_COUNTERS	(1 << 0)  /* summary counters */
@@ -160,6 +161,7 @@ void xfs_inode_measure_sickness(struct xfs_inode *ip, unsigned int *sick,
 
 void xfs_health_unmount(struct xfs_mount *mp);
 void xfs_bmap_mark_sick(struct xfs_inode *ip, int whichfork);
+void xfs_btree_mark_sick(struct xfs_btree_cur *cur);
 
 /* Now some helpers. */
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index c801250a3..92ca3d460 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -143,6 +143,7 @@ xfs_inobt_complain_bad_rec(
 "start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
 		irec->ir_startino, irec->ir_count, irec->ir_freecount,
 		irec->ir_free, irec->ir_holemask);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 36dd06e63..00df1e64a 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -22,6 +22,7 @@
 #include "xfs_refcount.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_refcount_intent_cache;
 
@@ -155,6 +156,7 @@ xfs_refcount_complain_bad_rec(
 	xfs_warn(mp,
 		"Start block 0x%x, block count 0x%x, references 0x%x",
 		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 
@@ -1888,8 +1890,10 @@ xfs_refcount_recover_extent(
 	struct xfs_refcount_recovery	*rr;
 
 	if (XFS_IS_CORRUPT(cur->bc_mp,
-			   be32_to_cpu(rec->refc.rc_refcount) != 1))
+			   be32_to_cpu(rec->refc.rc_refcount) != 1)) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	rr = kmalloc(sizeof(struct xfs_refcount_recovery),
 			GFP_KERNEL | __GFP_NOFAIL);
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index e7681c7c8..8fbc9583d 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -22,6 +22,7 @@
 #include "xfs_errortag.h"
 #include "xfs_inode.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_rmap_intent_cache;
 
@@ -55,8 +56,10 @@ xfs_rmap_lookup_le(
 	error = xfs_rmap_get_rec(cur, irec, &get_stat);
 	if (error)
 		return error;
-	if (!get_stat)
+	if (!get_stat) {
+		xfs_btree_mark_sick(cur);
 		return -EFSCORRUPTED;
+	}
 
 	return 0;
 }
@@ -276,6 +279,7 @@ xfs_rmap_complain_bad_rec(
 		"Owner 0x%llx, flags 0x%x, start block 0x%x block count 0x%x",
 		irec->rm_owner, irec->rm_flags, irec->rm_startblock,
 		irec->rm_blockcount);
+	xfs_btree_mark_sick(cur);
 	return -EFSCORRUPTED;
 }
 


