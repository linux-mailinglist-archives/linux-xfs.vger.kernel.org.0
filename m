Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD3E740697
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jun 2023 00:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjF0Wo3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Jun 2023 18:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjF0Wo0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jun 2023 18:44:26 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EFB26A3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:20 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-2632a72f289so567226a91.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jun 2023 15:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1687905860; x=1690497860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aWhBapU75WqXp3rBQnncpYPP9KljAfbysUq2fskWm48=;
        b=pIvizUS4zLEGKzIiqdgB/83Lact5bQ5Fyge++x94J8tX2sD7ggX+vjaEJmG9ixMA0s
         vABHdUaTo7yY91IRYcwgQSrwa6tGKgucaU16fNxrRNGnk/0vLGrbmSJZagbLlXjHz5Lo
         qFcOdU7+23KTT43z9v6Q/UT4NKvtwYhc9RpIGrFT2wLzK9JAgDCwNWeh3uq1GX1WCEfb
         tbHRf/aiyQJjokoszosK7o5U20Otcwf8OffzahbK1NEpF6KOZwJnAmMsmp+69J/PfDG8
         0quTAY9mmJdol04BNsoW1YOYICWyUhxc/MgURtgyVswN1G7RhbFqxtqxHWaMnd1zEh3I
         tLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687905860; x=1690497860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aWhBapU75WqXp3rBQnncpYPP9KljAfbysUq2fskWm48=;
        b=XgQ9ABRSMafadhaTZYm0J1LJS9C13DnuTCjY8eNKPb9EhH17kkITxwiK0M1VXbQj0e
         C4lmY51ZXa0Lh4zBwQUq4P05n+jGtAJpmg6xmGz8nFSIbkdHr9f55PE2v4NKJVMCRVVC
         flWtCKvfrSQMFeOd9WN/b+u3h1+AWoPPvZgI3EgB34TF/beLxRl4IQq2j77GHG7WRXkT
         PgwjEelBW5w21yp2eyOMyWrHIosE3q12JmkXg1HogOc18QFCcGFvkTZiVaqHWvQ7zxGq
         XUTyCIaA35Sh0N9XE9BN7VK9NXuBYStSeTy5bq5azIxA+uuCp7GOh40I/ZQwzMb81v/Y
         5HWQ==
X-Gm-Message-State: AC+VfDwfCp0hBaIDWRTK54oKyq0HyP/saOoBpJFDufI9RV8nNDlXCUKe
        +3lEYCRXvB2cAoo2VMkq24KiCxSrP4pu49fzaIA=
X-Google-Smtp-Source: ACHHUZ7iVuIG7upCLL//q7OessuDj8ZOwLRAbumCN/soSxUXhgtiWGhngKRBtIOK1bWrnPN6BxHxrA==
X-Received: by 2002:a17:90a:898c:b0:256:cf39:afce with SMTP id v12-20020a17090a898c00b00256cf39afcemr22523164pjn.43.1687905860172;
        Tue, 27 Jun 2023 15:44:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-94-37.pa.vic.optusnet.com.au. [49.186.94.37])
        by smtp.gmail.com with ESMTPSA id v8-20020a17090ad58800b00256a4d59bfasm8326551pju.23.2023.06.27.15.44.17
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 15:44:18 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qEHPz-00GzwY-1J
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:15 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qEHPz-009ZmG-0B
        for linux-xfs@vger.kernel.org;
        Wed, 28 Jun 2023 08:44:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: pass alloc flags through to xfs_extent_busy_flush()
Date:   Wed, 28 Jun 2023 08:44:07 +1000
Message-Id: <20230627224412.2242198-4-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230627224412.2242198-1-david@fromorbit.com>
References: <20230627224412.2242198-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To avoid blocking in xfs_extent_busy_flush() when freeing extents
and the only busy extents are held by the current transaction, we
need to pass the XFS_ALLOC_FLAG_FREEING flag context all the way
into xfs_extent_busy_flush().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 96 +++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_alloc.h |  2 +-
 fs/xfs/xfs_extent_busy.c  |  3 +-
 fs/xfs/xfs_extent_busy.h  |  2 +-
 4 files changed, 56 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index cc3f7b905ea1..ba929f6b5c9b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1536,7 +1536,8 @@ xfs_alloc_ag_vextent_lastblock(
  */
 STATIC int
 xfs_alloc_ag_vextent_near(
-	struct xfs_alloc_arg	*args)
+	struct xfs_alloc_arg	*args,
+	uint32_t		alloc_flags)
 {
 	struct xfs_alloc_cur	acur = {};
 	int			error;		/* error code */
@@ -1612,7 +1613,7 @@ xfs_alloc_ag_vextent_near(
 		if (acur.busy) {
 			trace_xfs_alloc_near_busy(args);
 			xfs_extent_busy_flush(args->mp, args->pag,
-					      acur.busy_gen);
+					      acur.busy_gen, alloc_flags);
 			goto restart;
 		}
 		trace_xfs_alloc_size_neither(args);
@@ -1635,21 +1636,22 @@ xfs_alloc_ag_vextent_near(
  * and of the form k * prod + mod unless there's nothing that large.
  * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
  */
-STATIC int				/* error */
+static int
 xfs_alloc_ag_vextent_size(
-	xfs_alloc_arg_t	*args)		/* allocation argument structure */
+	struct xfs_alloc_arg	*args,
+	uint32_t		alloc_flags)
 {
-	struct xfs_agf	*agf = args->agbp->b_addr;
-	struct xfs_btree_cur *bno_cur;	/* cursor for bno btree */
-	struct xfs_btree_cur *cnt_cur;	/* cursor for cnt btree */
-	int		error;		/* error result */
-	xfs_agblock_t	fbno;		/* start of found freespace */
-	xfs_extlen_t	flen;		/* length of found freespace */
-	int		i;		/* temp status variable */
-	xfs_agblock_t	rbno;		/* returned block number */
-	xfs_extlen_t	rlen;		/* length of returned extent */
-	bool		busy;
-	unsigned	busy_gen;
+	struct xfs_agf		*agf = args->agbp->b_addr;
+	struct xfs_btree_cur	*bno_cur;
+	struct xfs_btree_cur	*cnt_cur;
+	xfs_agblock_t		fbno;		/* start of found freespace */
+	xfs_extlen_t		flen;		/* length of found freespace */
+	xfs_agblock_t		rbno;		/* returned block number */
+	xfs_extlen_t		rlen;		/* length of returned extent */
+	bool			busy;
+	unsigned		busy_gen;
+	int			error;
+	int			i;
 
 restart:
 	/*
@@ -1717,8 +1719,8 @@ xfs_alloc_ag_vextent_size(
 				xfs_btree_del_cursor(cnt_cur,
 						     XFS_BTREE_NOERROR);
 				trace_xfs_alloc_size_busy(args);
-				xfs_extent_busy_flush(args->mp,
-							args->pag, busy_gen);
+				xfs_extent_busy_flush(args->mp, args->pag,
+						busy_gen, alloc_flags);
 				goto restart;
 			}
 		}
@@ -1802,7 +1804,8 @@ xfs_alloc_ag_vextent_size(
 		if (busy) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 			trace_xfs_alloc_size_busy(args);
-			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
+			xfs_extent_busy_flush(args->mp, args->pag, busy_gen,
+					alloc_flags);
 			goto restart;
 		}
 		goto out_nominleft;
@@ -2572,7 +2575,7 @@ xfs_exact_minlen_extent_available(
 int			/* error */
 xfs_alloc_fix_freelist(
 	struct xfs_alloc_arg	*args,	/* allocation argument structure */
-	int			flags)	/* XFS_ALLOC_FLAG_... */
+	uint32_t		alloc_flags)
 {
 	struct xfs_mount	*mp = args->mp;
 	struct xfs_perag	*pag = args->pag;
@@ -2588,7 +2591,7 @@ xfs_alloc_fix_freelist(
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	if (!xfs_perag_initialised_agf(pag)) {
-		error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
+		error = xfs_alloc_read_agf(pag, tp, alloc_flags, &agbp);
 		if (error) {
 			/* Couldn't lock the AGF so skip this AG. */
 			if (error == -EAGAIN)
@@ -2604,13 +2607,13 @@ xfs_alloc_fix_freelist(
 	 */
 	if (xfs_perag_prefers_metadata(pag) &&
 	    (args->datatype & XFS_ALLOC_USERDATA) &&
-	    (flags & XFS_ALLOC_FLAG_TRYLOCK)) {
-		ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
+	    (alloc_flags & XFS_ALLOC_FLAG_TRYLOCK)) {
+		ASSERT(!(alloc_flags & XFS_ALLOC_FLAG_FREEING));
 		goto out_agbp_relse;
 	}
 
 	need = xfs_alloc_min_freelist(mp, pag);
-	if (!xfs_alloc_space_available(args, need, flags |
+	if (!xfs_alloc_space_available(args, need, alloc_flags |
 			XFS_ALLOC_FLAG_CHECK))
 		goto out_agbp_relse;
 
@@ -2619,7 +2622,7 @@ xfs_alloc_fix_freelist(
 	 * Can fail if we're not blocking on locks, and it's held.
 	 */
 	if (!agbp) {
-		error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
+		error = xfs_alloc_read_agf(pag, tp, alloc_flags, &agbp);
 		if (error) {
 			/* Couldn't lock the AGF so skip this AG. */
 			if (error == -EAGAIN)
@@ -2634,7 +2637,7 @@ xfs_alloc_fix_freelist(
 
 	/* If there isn't enough total space or single-extent, reject it. */
 	need = xfs_alloc_min_freelist(mp, pag);
-	if (!xfs_alloc_space_available(args, need, flags))
+	if (!xfs_alloc_space_available(args, need, alloc_flags))
 		goto out_agbp_relse;
 
 #ifdef DEBUG
@@ -2672,11 +2675,12 @@ xfs_alloc_fix_freelist(
 	 */
 	memset(&targs, 0, sizeof(targs));
 	/* struct copy below */
-	if (flags & XFS_ALLOC_FLAG_NORMAP)
+	if (alloc_flags & XFS_ALLOC_FLAG_NORMAP)
 		targs.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 	else
 		targs.oinfo = XFS_RMAP_OINFO_AG;
-	while (!(flags & XFS_ALLOC_FLAG_NOSHRINK) && pag->pagf_flcount > need) {
+	while (!(alloc_flags & XFS_ALLOC_FLAG_NOSHRINK) &&
+			pag->pagf_flcount > need) {
 		error = xfs_alloc_get_freelist(pag, tp, agbp, &bno, 0);
 		if (error)
 			goto out_agbp_relse;
@@ -2704,7 +2708,7 @@ xfs_alloc_fix_freelist(
 		targs.resv = XFS_AG_RESV_AGFL;
 
 		/* Allocate as many blocks as possible at once. */
-		error = xfs_alloc_ag_vextent_size(&targs);
+		error = xfs_alloc_ag_vextent_size(&targs, alloc_flags);
 		if (error)
 			goto out_agflbp_relse;
 
@@ -2714,7 +2718,7 @@ xfs_alloc_fix_freelist(
 		 * on a completely full ag.
 		 */
 		if (targs.agbno == NULLAGBLOCK) {
-			if (flags & XFS_ALLOC_FLAG_FREEING)
+			if (alloc_flags & XFS_ALLOC_FLAG_FREEING)
 				break;
 			goto out_agflbp_relse;
 		}
@@ -3230,7 +3234,7 @@ xfs_alloc_vextent_check_args(
 static int
 xfs_alloc_vextent_prepare_ag(
 	struct xfs_alloc_arg	*args,
-	uint32_t		flags)
+	uint32_t		alloc_flags)
 {
 	bool			need_pag = !args->pag;
 	int			error;
@@ -3239,7 +3243,7 @@ xfs_alloc_vextent_prepare_ag(
 		args->pag = xfs_perag_get(args->mp, args->agno);
 
 	args->agbp = NULL;
-	error = xfs_alloc_fix_freelist(args, flags);
+	error = xfs_alloc_fix_freelist(args, alloc_flags);
 	if (error) {
 		trace_xfs_alloc_vextent_nofix(args);
 		if (need_pag)
@@ -3361,6 +3365,7 @@ xfs_alloc_vextent_this_ag(
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		minimum_agno;
+	uint32_t		alloc_flags = 0;
 	int			error;
 
 	ASSERT(args->pag != NULL);
@@ -3379,9 +3384,9 @@ xfs_alloc_vextent_this_ag(
 		return error;
 	}
 
-	error = xfs_alloc_vextent_prepare_ag(args, 0);
+	error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
 	if (!error && args->agbp)
-		error = xfs_alloc_ag_vextent_size(args);
+		error = xfs_alloc_ag_vextent_size(args, alloc_flags);
 
 	return xfs_alloc_vextent_finish(args, minimum_agno, error, false);
 }
@@ -3410,20 +3415,20 @@ xfs_alloc_vextent_iterate_ags(
 	xfs_agnumber_t		minimum_agno,
 	xfs_agnumber_t		start_agno,
 	xfs_agblock_t		target_agbno,
-	uint32_t		flags)
+	uint32_t		alloc_flags)
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		restart_agno = minimum_agno;
 	xfs_agnumber_t		agno;
 	int			error = 0;
 
-	if (flags & XFS_ALLOC_FLAG_TRYLOCK)
+	if (alloc_flags & XFS_ALLOC_FLAG_TRYLOCK)
 		restart_agno = 0;
 restart:
 	for_each_perag_wrap_range(mp, start_agno, restart_agno,
 			mp->m_sb.sb_agcount, agno, args->pag) {
 		args->agno = agno;
-		error = xfs_alloc_vextent_prepare_ag(args, flags);
+		error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
 		if (error)
 			break;
 		if (!args->agbp) {
@@ -3437,10 +3442,10 @@ xfs_alloc_vextent_iterate_ags(
 		 */
 		if (args->agno == start_agno && target_agbno) {
 			args->agbno = target_agbno;
-			error = xfs_alloc_ag_vextent_near(args);
+			error = xfs_alloc_ag_vextent_near(args, alloc_flags);
 		} else {
 			args->agbno = 0;
-			error = xfs_alloc_ag_vextent_size(args);
+			error = xfs_alloc_ag_vextent_size(args, alloc_flags);
 		}
 		break;
 	}
@@ -3457,8 +3462,8 @@ xfs_alloc_vextent_iterate_ags(
 	 * constraining flags by the caller, drop them and retry the allocation
 	 * without any constraints being set.
 	 */
-	if (flags) {
-		flags = 0;
+	if (alloc_flags & XFS_ALLOC_FLAG_TRYLOCK) {
+		alloc_flags &= ~XFS_ALLOC_FLAG_TRYLOCK;
 		restart_agno = minimum_agno;
 		goto restart;
 	}
@@ -3486,6 +3491,7 @@ xfs_alloc_vextent_start_ag(
 	xfs_agnumber_t		start_agno;
 	xfs_agnumber_t		rotorstep = xfs_rotorstep;
 	bool			bump_rotor = false;
+	uint32_t		alloc_flags = XFS_ALLOC_FLAG_TRYLOCK;
 	int			error;
 
 	ASSERT(args->pag == NULL);
@@ -3512,7 +3518,7 @@ xfs_alloc_vextent_start_ag(
 
 	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
 	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
-			XFS_FSB_TO_AGBNO(mp, target), XFS_ALLOC_FLAG_TRYLOCK);
+			XFS_FSB_TO_AGBNO(mp, target), alloc_flags);
 
 	if (bump_rotor) {
 		if (args->agno == start_agno)
@@ -3539,6 +3545,7 @@ xfs_alloc_vextent_first_ag(
 	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		minimum_agno;
 	xfs_agnumber_t		start_agno;
+	uint32_t		alloc_flags = XFS_ALLOC_FLAG_TRYLOCK;
 	int			error;
 
 	ASSERT(args->pag == NULL);
@@ -3557,7 +3564,7 @@ xfs_alloc_vextent_first_ag(
 
 	start_agno = max(minimum_agno, XFS_FSB_TO_AGNO(mp, target));
 	error = xfs_alloc_vextent_iterate_ags(args, minimum_agno, start_agno,
-			XFS_FSB_TO_AGBNO(mp, target), 0);
+			XFS_FSB_TO_AGBNO(mp, target), alloc_flags);
 	return xfs_alloc_vextent_finish(args, minimum_agno, error, true);
 }
 
@@ -3610,6 +3617,7 @@ xfs_alloc_vextent_near_bno(
 	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		minimum_agno;
 	bool			needs_perag = args->pag == NULL;
+	uint32_t		alloc_flags = 0;
 	int			error;
 
 	if (!needs_perag)
@@ -3630,9 +3638,9 @@ xfs_alloc_vextent_near_bno(
 	if (needs_perag)
 		args->pag = xfs_perag_grab(mp, args->agno);
 
-	error = xfs_alloc_vextent_prepare_ag(args, 0);
+	error = xfs_alloc_vextent_prepare_ag(args, alloc_flags);
 	if (!error && args->agbp)
-		error = xfs_alloc_ag_vextent_near(args);
+		error = xfs_alloc_ag_vextent_near(args, alloc_flags);
 
 	return xfs_alloc_vextent_finish(args, minimum_agno, error, needs_perag);
 }
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 121faf1e11ad..50119ebaede9 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -195,7 +195,7 @@ int xfs_alloc_read_agfl(struct xfs_perag *pag, struct xfs_trans *tp,
 		struct xfs_buf **bpp);
 int xfs_free_agfl_block(struct xfs_trans *, xfs_agnumber_t, xfs_agblock_t,
 			struct xfs_buf *, struct xfs_owner_info *);
-int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, int flags);
+int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, uint32_t alloc_flags);
 int xfs_free_extent_fix_freelist(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_buf **agbp);
 
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index f3d328e4a440..5f44936eae1c 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -571,7 +571,8 @@ void
 xfs_extent_busy_flush(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
-	unsigned		busy_gen)
+	unsigned		busy_gen,
+	uint32_t		alloc_flags)
 {
 	DEFINE_WAIT		(wait);
 	int			error;
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 4a118131059f..7a82c689bfa4 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -53,7 +53,7 @@ xfs_extent_busy_trim(struct xfs_alloc_arg *args, xfs_agblock_t *bno,
 
 void
 xfs_extent_busy_flush(struct xfs_mount *mp, struct xfs_perag *pag,
-	unsigned busy_gen);
+	unsigned busy_gen, uint32_t alloc_flags);
 
 void
 xfs_extent_busy_wait_all(struct xfs_mount *mp);
-- 
2.40.1

