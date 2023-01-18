Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849F1672B72
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Jan 2023 23:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjARWpV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Jan 2023 17:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjARWpP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:15 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525FF5FD60
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o13so574265pjg.2
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y25zJwP0StYPGXgFaiX2SPH81kZh9kcaa464zrV/Cx4=;
        b=2/JA8lApyH0HBFGe0KPxCROww1e0qbqxMRvoIGJReRQZe5To718zs69i78zVeQS23A
         l6r+DFnEFo5MTdMemuqBFB7uvcAfoCGqsZ3lLa7KqS8kk0SzTtf0MON7mMbDKur5FbaP
         nVO2XiLMRZ0dqJZ1phxek737AOhEj+u95EMs9Sb/fKP8mr0r3M3JUFZxTAlykRWLpGxc
         dXQXthnTt8SKtOi/YTKUHGwznLAIpcLbhFnxl9yGZk4IYckDZBU7TIlLigpBGp1WRfyZ
         MZ/rEfo6WHNFNTMliBIWGxu9FP5o3mYXfeBElQiaWmBMjB1smpD15LsinY4boUBv4Scg
         KlOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y25zJwP0StYPGXgFaiX2SPH81kZh9kcaa464zrV/Cx4=;
        b=YQZZwpFmFZXm7cdN3hGVbRovUfg5v1+mxnb0QEzz+OFaArsyk/yDr9Zh/g1Vz5nn68
         Wp2LxBYhAxRTM/7s5TMphyw3wC8k7J0wnz3ycw1DNVUCBV9DUTHGoo5/XU8V6NEieBm+
         k9MDZbBikOEECqwX/xmApOGegDDpSFieff1OCKaUyM5egva+NEQVUOUE1qgBadApiS0X
         FnPdnugFecULsgPTCOdY+UzOpLnMiIWBoeNB8S3TxRXvClpq/8+ZlXVZgRKViCTKuOol
         BzzRrz6lfCDnh1JlficmYLByv119UP1PFt7uRDO8Plem7pLT1n/djVCpJusYK0MuXeEH
         PkIg==
X-Gm-Message-State: AFqh2kquL6ojOLRsjBUgafbwqSfyVQvXJyqYcjsmJNlrutF/RhmjzT5F
        Ah5s1amxnAIgy1wXTa7/EGors7Ja/B8XDfBL
X-Google-Smtp-Source: AMrXdXuUU3ubz/Ir3WDgZaYjShbncomYxI522up/e3B1PmpCNegqOoTNMwvrdr+VXoN8AjbHBg7n3g==
X-Received: by 2002:a17:902:ec82:b0:194:3fd8:f56a with SMTP id x2-20020a170902ec8200b001943fd8f56amr11709963plg.55.1674081913884;
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id s1-20020a170902ea0100b001913c5fc051sm12471753plg.274.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iX4-2S
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FDJ-0F
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 10/42] xfs: use active perag references for inode allocation
Date:   Thu, 19 Jan 2023 09:44:33 +1100
Message-Id: <20230118224505.1964941-11-david@fromorbit.com>
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

Convert the inode allocation routines to use active perag references
or references held by callers rather than grab their own. Also drive
the perag further inwards to replace xfs_mounts when doing
operations on a specific AG.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.c     |  3 +-
 fs/xfs/libxfs/xfs_ialloc.c | 63 +++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_ialloc.h |  2 +-
 3 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 7cff61875340..a3bdcde95845 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -925,8 +925,7 @@ xfs_ag_shrink_space(
 	 * Make sure that the last inode cluster cannot overlap with the new
 	 * end of the AG, even if it's sparse.
 	 */
-	error = xfs_ialloc_check_shrink(*tpp, pag->pag_agno, agibp,
-			aglen - delta);
+	error = xfs_ialloc_check_shrink(pag, *tpp, agibp, aglen - delta);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 2b4961ff2e24..a1a482ec3065 100644
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
@@ -1790,9 +1792,9 @@ xfs_dialloc(
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
@@ -1813,12 +1815,12 @@ xfs_dialloc(
 			if (low_space)
 				ok_alloc = true;
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
 
@@ -1902,14 +1904,14 @@ xfs_difree_inode_chunk(
 
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
@@ -2036,13 +2038,13 @@ xfs_difree_inobt(
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
@@ -2196,7 +2198,7 @@ xfs_difree(
 	/*
 	 * Fix up the inode allocation btree.
 	 */
-	error = xfs_difree_inobt(mp, tp, agbp, pag, agino, xic, &rec);
+	error = xfs_difree_inobt(pag, tp, agbp, agino, xic, &rec);
 	if (error)
 		goto error0;
 
@@ -2204,7 +2206,7 @@ xfs_difree(
 	 * Fix up the free inode btree.
 	 */
 	if (xfs_has_finobt(mp)) {
-		error = xfs_difree_finobt(mp, tp, agbp, pag, agino, &rec);
+		error = xfs_difree_finobt(pag, tp, agbp, agino, &rec);
 		if (error)
 			goto error0;
 	}
@@ -2928,15 +2930,14 @@ xfs_ialloc_calc_rootino(
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
@@ -2944,7 +2945,6 @@ xfs_ialloc_check_shrink(
 	if (!xfs_has_sparseinodes(mp))
 		return 0;
 
-	pag = xfs_perag_get(mp, agno);
 	cur = xfs_inobt_init_cursor(mp, tp, agibp, pag, XFS_BTNUM_INO);
 
 	/* Look up the inobt record that would correspond to the new EOFS. */
@@ -2968,6 +2968,5 @@ xfs_ialloc_check_shrink(
 	}
 out:
 	xfs_btree_del_cursor(cur, error);
-	xfs_perag_put(pag);
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 4cfce2eebe7e..ab8c30b4ec22 100644
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
2.39.0

