Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20BBD672B9D
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Jan 2023 23:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjARWsR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Jan 2023 17:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjARWsC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:48:02 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7D66603D
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:53 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id 20so588253plo.3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ywVcLFRLHCjudPtvOIzM/bnfKbnu3wI5GJNOsA+GD9k=;
        b=ki04V/SNegOuRPRsHJHPwq9ZELvOMTkcjDke+8hii49jEvHybCyjNpc8FitnwkJgUf
         oXeN4AFxYnBA7klDjZorH3cdon+mjuTweEuDfnGTzGCdhpOQq29oX1Ong5DndP6Zqt2b
         JQ0XSm1vcaKvUewXvkddp2AW4nJu9TXTsuVd5HCN6ThznPcEY2cSRgUxKeVrJyaxIGsp
         nRDdYlXLO85s5CmL6D0W8VeJK1g6Pu+h6TxBsF7sTnGUohWB8Xf3wzkeWmob1mNIP0sW
         P75/rftmNuQoatN3gd++ZFBepC+/FPg0xmKn7jlNxBDoz1RoatGkUbgVVaBlAr2PT6pc
         AkRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ywVcLFRLHCjudPtvOIzM/bnfKbnu3wI5GJNOsA+GD9k=;
        b=6lxmM0hOUaQmNaG91soT13xcrkJTC2GRL6wkfxn90wkMrKSHKBGTP8Dnpg4GnY76gv
         WQVfU1HyC8vk+Id4sGVuSmjCMIsbWcJNEfv1sicmYqCUFsLFaQWz9Fl2QslHyfv6EK4c
         HAbR7+dr9lzxsLQV0qvBzN2yH586zsw7YndVM/1kxwZkdYwuEz28QD5+zW4c1UJLYYrG
         bVz+yP/XlnL56YLw/2n2dWFkTXj2dtuoeXI8fWzju8nuuAOoNF6Le0VXQE59brZUFOav
         11aWNENAPgnZyxPCgfkxyAAh2+wziyeJgAu0nD2uThryN2gSqULQSSqtThFbfu7ypPWx
         BVEg==
X-Gm-Message-State: AFqh2krLMdaI77m+14G1g/lZIz4kzX//REHWYoJ5szh+qNKqg5PzQH5c
        DdaRqBr2M3At5Nm5XAijzx7qcrDPzrdpS2P5
X-Google-Smtp-Source: AMrXdXtE/hgckTOB2K0QeULsFi/bwqgr90z/YpkODWNM6A13Af9VWdBcJIw++UyNOEYAGRxEMcEZrA==
X-Received: by 2002:a17:902:8c94:b0:192:9d79:d3d6 with SMTP id t20-20020a1709028c9400b001929d79d3d6mr8933600plo.69.1674082072667;
        Wed, 18 Jan 2023 14:47:52 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id b6-20020a170902650600b00192d4ba98eesm23652111plk.167.2023.01.18.14.47.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:47:52 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXe-DX
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FEH-1M
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 22/42] xfs: introduce xfs_alloc_vextent_near_bno()
Date:   Thu, 19 Jan 2023 09:44:45 +1100
Message-Id: <20230118224505.1964941-23-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The remaining callers of xfs_alloc_vextent() are all doing NEAR_BNO
allocations. We can replace that function with a new
xfs_alloc_vextent_near_bno() function that does this explicitly.

We also multiplex NEAR_BNO allocations through
xfs_alloc_vextent_this_ag via args->type. Replace all of these with
direct calls to xfs_alloc_vextent_near_bno(), too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c          | 50 ++++++++++++++++++------------
 fs/xfs/libxfs/xfs_alloc.h          | 14 ++++-----
 fs/xfs/libxfs/xfs_bmap.c           |  6 ++--
 fs/xfs/libxfs/xfs_ialloc.c         | 27 ++++++----------
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  5 ++-
 fs/xfs/libxfs/xfs_refcount_btree.c |  7 ++---
 6 files changed, 55 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 294f80d596d9..485a73eab9d9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3479,35 +3479,47 @@ int
 }
 
 /*
- * Allocate an extent (variable-size).
- * Depending on the allocation type, we either look in a single allocation
- * group or loop over the allocation groups to find the result.
+ * Allocate an extent as close to the target as possible. If there are not
+ * viable candidates in the AG, then fail the allocation.
  */
 int
-xfs_alloc_vextent(
-	struct xfs_alloc_arg	*args)
+xfs_alloc_vextent_near_bno(
+	struct xfs_alloc_arg	*args,
+	xfs_rfsblock_t		target)
 {
+	struct xfs_mount	*mp = args->mp;
+	bool			need_pag = !args->pag;
 	xfs_agnumber_t		minimum_agno = 0;
 	int			error;
 
 	if (args->tp->t_highest_agno != NULLAGNUMBER)
 		minimum_agno = args->tp->t_highest_agno;
 
-	switch (args->type) {
-	case XFS_ALLOCTYPE_THIS_AG:
-	case XFS_ALLOCTYPE_NEAR_BNO:
-	case XFS_ALLOCTYPE_THIS_BNO:
-		args->pag = xfs_perag_get(args->mp,
-				XFS_FSB_TO_AGNO(args->mp, args->fsbno));
-		error = xfs_alloc_vextent_this_ag(args);
-		xfs_perag_put(args->pag);
-		break;
-	default:
-		error = -EFSCORRUPTED;
-		ASSERT(0);
-		break;
+	error = xfs_alloc_vextent_check_args(args, target);
+	if (error) {
+		if (error == -ENOSPC)
+			return 0;
+		return error;
 	}
-	return error;
+
+	args->agno = XFS_FSB_TO_AGNO(mp, target);
+	if (minimum_agno > args->agno) {
+		trace_xfs_alloc_vextent_skip_deadlock(args);
+		return 0;
+	}
+
+	args->agbno = XFS_FSB_TO_AGBNO(mp, target);
+	args->type = XFS_ALLOCTYPE_NEAR_BNO;
+	if (need_pag)
+		args->pag = xfs_perag_get(args->mp, args->agno);
+	error = xfs_alloc_ag_vextent(args);
+	if (need_pag)
+		xfs_perag_put(args->pag);
+	if (error)
+		return error;
+
+	xfs_alloc_vextent_set_fsbno(args, minimum_agno);
+	return 0;
 }
 
 /* Ensure that the freelist is at full capacity. */
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 5487dff3d68a..f38a2f8e20fb 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -113,19 +113,19 @@ xfs_alloc_log_agf(
 	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
 	uint32_t	fields);/* mask of fields to be logged (XFS_AGF_...) */
 
-/*
- * Allocate an extent (variable-size).
- */
-int				/* error */
-xfs_alloc_vextent(
-	xfs_alloc_arg_t	*args);	/* allocation argument structure */
-
 /*
  * Allocate an extent in the specific AG defined by args->fsbno. If there is no
  * space in that AG, then the allocation will fail.
  */
 int xfs_alloc_vextent_this_ag(struct xfs_alloc_arg *args);
 
+/*
+ * Allocate an extent as close to the target as possible. If there are not
+ * viable candidates in the AG, then fail the allocation.
+ */
+int xfs_alloc_vextent_near_bno(struct xfs_alloc_arg *args,
+		xfs_rfsblock_t target);
+
 /*
  * Best effort full filesystem allocation scan.
  *
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index aefcdf2bfd57..4446b035eed5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3246,7 +3246,6 @@ xfs_bmap_btalloc_filestreams(
 	int			notinit = 0;
 	int			error;
 
-	args->type = XFS_ALLOCTYPE_NEAR_BNO;
 	args->total = ap->total;
 
 	start_agno = XFS_FSB_TO_AGNO(mp, ap->blkno);
@@ -3565,7 +3564,7 @@ xfs_bmap_btalloc_at_eof(
 	}
 
 	if (ag_only)
-		error = xfs_alloc_vextent(args);
+		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
 	else
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error)
@@ -3612,7 +3611,6 @@ xfs_bmap_btalloc_best_length(
 		ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
 	}
 	xfs_bmap_adjacent(ap);
-	args->fsbno = ap->blkno;
 
 	/*
 	 * Search for an allocation group with a single extent large enough for
@@ -3653,7 +3651,7 @@ xfs_bmap_btalloc_best_length(
 	}
 
 	if (is_filestream)
-		error = xfs_alloc_vextent(args);
+		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
 	else
 		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
 	if (error)
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 2f3e47cb9332..daa6f7055bba 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -717,23 +717,17 @@ xfs_ialloc_ag_alloc(
 			isaligned = 1;
 		} else
 			args.alignment = igeo->cluster_align;
-		/*
-		 * Need to figure out where to allocate the inode blocks.
-		 * Ideally they should be spaced out through the a.g.
-		 * For now, just allocate blocks up front.
-		 */
-		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
 		/*
 		 * Allocate a fixed-size extent of inodes.
 		 */
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
 		args.prod = 1;
 		/*
 		 * Allow space for the inode btree to split.
 		 */
 		args.minleft = igeo->inobt_maxlevels;
-		error = xfs_alloc_vextent_this_ag(&args);
+		error = xfs_alloc_vextent_near_bno(&args,
+				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
+						be32_to_cpu(agi->agi_root)));
 		if (error)
 			return error;
 	}
@@ -743,11 +737,11 @@ xfs_ialloc_ag_alloc(
 	 * alignment.
 	 */
 	if (isaligned && args.fsbno == NULLFSBLOCK) {
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
 		args.alignment = igeo->cluster_align;
-		if ((error = xfs_alloc_vextent(&args)))
+		error = xfs_alloc_vextent_near_bno(&args,
+				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
+						be32_to_cpu(agi->agi_root)));
+		if (error)
 			return error;
 	}
 
@@ -759,9 +753,6 @@ xfs_ialloc_ag_alloc(
 	    igeo->ialloc_min_blks < igeo->ialloc_blks &&
 	    args.fsbno == NULLFSBLOCK) {
 sparse_alloc:
-		args.type = XFS_ALLOCTYPE_NEAR_BNO;
-		args.agbno = be32_to_cpu(agi->agi_root);
-		args.fsbno = XFS_AGB_TO_FSB(args.mp, pag->pag_agno, args.agbno);
 		args.alignment = args.mp->m_sb.sb_spino_align;
 		args.prod = 1;
 
@@ -783,7 +774,9 @@ xfs_ialloc_ag_alloc(
 					    args.mp->m_sb.sb_inoalignmt) -
 				 igeo->ialloc_blks;
 
-		error = xfs_alloc_vextent_this_ag(&args);
+		error = xfs_alloc_vextent_near_bno(&args,
+				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
+						be32_to_cpu(agi->agi_root)));
 		if (error)
 			return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index fa6cd2502970..9b28211d5a4c 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -105,14 +105,13 @@ __xfs_inobt_alloc_block(
 	args.mp = cur->bc_mp;
 	args.pag = cur->bc_ag.pag;
 	args.oinfo = XFS_RMAP_OINFO_INOBT;
-	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_ag.pag->pag_agno, sbno);
 	args.minlen = 1;
 	args.maxlen = 1;
 	args.prod = 1;
-	args.type = XFS_ALLOCTYPE_NEAR_BNO;
 	args.resv = resv;
 
-	error = xfs_alloc_vextent_this_ag(&args);
+	error = xfs_alloc_vextent_near_bno(&args,
+			XFS_AGB_TO_FSB(args.mp, args.pag->pag_agno, sbno));
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index a980fb18bde2..f3b860970b26 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -68,14 +68,13 @@ xfs_refcountbt_alloc_block(
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
 	args.pag = cur->bc_ag.pag;
-	args.type = XFS_ALLOCTYPE_NEAR_BNO;
-	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			xfs_refc_block(args.mp));
 	args.oinfo = XFS_RMAP_OINFO_REFC;
 	args.minlen = args.maxlen = args.prod = 1;
 	args.resv = XFS_AG_RESV_METADATA;
 
-	error = xfs_alloc_vextent_this_ag(&args);
+	error = xfs_alloc_vextent_near_bno(&args,
+			XFS_AGB_TO_FSB(args.mp, args.pag->pag_agno,
+					xfs_refc_block(args.mp)));
 	if (error)
 		goto out_error;
 	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-- 
2.39.0

