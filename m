Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4D469131D
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Feb 2023 23:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjBIWSw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 9 Feb 2023 17:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjBIWSm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Feb 2023 17:18:42 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4345F6ADF2
        for <linux-xfs@vger.kernel.org>; Thu,  9 Feb 2023 14:18:39 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d8so3315894plr.10
        for <linux-xfs@vger.kernel.org>; Thu, 09 Feb 2023 14:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a1Sxyl2hZMmTiuuJQFPvgGEZcQfPh7fu41/wFIeWuI4=;
        b=K40OVfZDjwU/ee4aMtJTAgLhBHG/RWCE+VqxiuFRQEV9vd1lUmtnvIw2velk4U4s2z
         zcbbfa64PDYhZPc8jKbtYRibh6S5K1FZLnhQ4GNYto4Vhkgr3xw227Yhhm9JPRs2aM8w
         DwEtY9nCtGp7Ciprd/U47zdNEB50eCF4Lw2R4soSwfGebI2FXPwPi4yCXq/WX3yx1Mpa
         13y2Jb2Uqgm08ed9DLLyBflrHypMdFaBhOtg4DpvYfbZ8rjKOSfAEWOl/lJIekHxXS3Y
         Ly7SzVk2pIrBJbApMIgNlqnJN+SLm9nnd+P603q4CFKrZoGb2S6KT2V4NYmkPVeMHHCa
         kvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a1Sxyl2hZMmTiuuJQFPvgGEZcQfPh7fu41/wFIeWuI4=;
        b=SrL8eSadA73eadexK4pGiN3LSAi7BOiabClowbKq6xTb0O31fWudpdjGCTGNLTpaBn
         mOZyIw1D1qmufL9D/1H5+1bdK9Z4TxxNN/L6O362eltD/dkMMZHKUivmslLisLVfSWte
         n/EaXz6+FtMYrRsWdyQdRFDK/3aqJpH0419dSd6zBIBGrw1VqpAdey+4kyRC8kciCkbc
         O4wnGYBYB85jg0+1KP7am0vXztp1+HZyysg4OtxTB66gG6gGsv4CVDF8pP+DenomHbke
         KSCE5smYMAnmMXc6wunc0aAQlnzwzyM809ZQzW4MZg7ChVJigcGeoje+DuROTmXrxt8p
         DB5w==
X-Gm-Message-State: AO0yUKWWSXs6g0tRnuP6xxu/s0h6TPoNsfJm4+j8l8KV5dMfJxoSTrHG
        aHjevgJZEdd/HCyS6Cmudv7COgDTnYrzZEh1
X-Google-Smtp-Source: AK7set9j3Z6lNvzoabw1O+6ZCpAESca3/PFWD6+valu4QSnVU19E+6FFG+PuF9itFQEG1IDUQvgyTA==
X-Received: by 2002:a05:6a20:1590:b0:bc:6df2:f0cd with SMTP id h16-20020a056a20159000b000bc6df2f0cdmr16936841pzj.35.1675981118134;
        Thu, 09 Feb 2023 14:18:38 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id e23-20020a62ee17000000b00594235980e4sm1921861pfi.181.2023.02.09.14.18.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 14:18:36 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pQFFM-00DOVP-C9
        for linux-xfs@vger.kernel.org; Fri, 10 Feb 2023 09:18:28 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pQFFM-00FcNR-1B
        for linux-xfs@vger.kernel.org;
        Fri, 10 Feb 2023 09:18:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 19/42] xfs: factor xfs_bmap_btalloc()
Date:   Fri, 10 Feb 2023 09:18:02 +1100
Message-Id: <20230209221825.3722244-20-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209221825.3722244-1-david@fromorbit.com>
References: <20230209221825.3722244-1-david@fromorbit.com>
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

There are several different contexts xfs_bmap_btalloc() handles, and
large chunks of the code execute independent allocation contexts.
Try to untangle this mess a bit.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 355 +++++++++++++++++++++++----------------
 1 file changed, 207 insertions(+), 148 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index baf11bc4d091..a28d57b82396 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3196,13 +3196,13 @@ xfs_bmap_select_minlen(
 	}
 }
 
-STATIC int
+static int
 xfs_bmap_btalloc_select_lengths(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
 	xfs_extlen_t		*blen)
 {
-	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_mount	*mp = args->mp;
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno, startag;
 	int			notinit = 0;
@@ -3216,7 +3216,7 @@ xfs_bmap_btalloc_select_lengths(
 	}
 
 	args->total = ap->total;
-	startag = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	startag = XFS_FSB_TO_AGNO(mp, ap->blkno);
 	if (startag == NULLAGNUMBER)
 		startag = 0;
 
@@ -3258,7 +3258,7 @@ xfs_bmap_btalloc_filestreams(
 	args->type = XFS_ALLOCTYPE_NEAR_BNO;
 	args->total = ap->total;
 
-	start_agno = XFS_FSB_TO_AGNO(mp, args->fsbno);
+	start_agno = XFS_FSB_TO_AGNO(mp, ap->blkno);
 	if (start_agno == NULLAGNUMBER)
 		start_agno = 0;
 
@@ -3496,170 +3496,229 @@ xfs_bmap_exact_minlen_extent_alloc(
 
 #endif
 
-STATIC int
-xfs_bmap_btalloc(
-	struct xfs_bmalloca	*ap)
+/*
+ * If we are not low on available data blocks and we are allocating at
+ * EOF, optimise allocation for contiguous file extension and/or stripe
+ * alignment of the new extent.
+ *
+ * NOTE: ap->aeof is only set if the allocation length is >= the
+ * stripe unit and the allocation offset is at the end of file.
+ */
+static int
+xfs_bmap_btalloc_at_eof(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	xfs_extlen_t		blen,
+	int			stripe_align)
 {
-	struct xfs_mount	*mp = ap->ip->i_mount;
-	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
-	xfs_alloctype_t		atype = 0;
-	xfs_agnumber_t		ag;
-	xfs_fileoff_t		orig_offset;
-	xfs_extlen_t		orig_length;
-	xfs_extlen_t		blen;
-	xfs_extlen_t		nextminlen = 0;
-	int			isaligned = 0;
+	struct xfs_mount	*mp = args->mp;
+	xfs_alloctype_t		atype;
 	int			error;
-	int			stripe_align;
 
-	ASSERT(ap->length);
-	orig_offset = ap->offset;
-	orig_length = ap->length;
+	/*
+	 * If there are already extents in the file, try an exact EOF block
+	 * allocation to extend the file as a contiguous extent. If that fails,
+	 * or it's the first allocation in a file, just try for a stripe aligned
+	 * allocation.
+	 */
+	if (ap->offset) {
+		xfs_extlen_t	nextminlen = 0;
 
-	stripe_align = xfs_bmap_compute_alignments(ap, &args);
+		atype = args->type;
+		args->type = XFS_ALLOCTYPE_THIS_BNO;
+		args->alignment = 1;
 
+		/*
+		 * Compute the minlen+alignment for the next case.  Set slop so
+		 * that the value of minlen+alignment+slop doesn't go up between
+		 * the calls.
+		 */
+		if (blen > stripe_align && blen <= args->maxlen)
+			nextminlen = blen - stripe_align;
+		else
+			nextminlen = args->minlen;
+		if (nextminlen + stripe_align > args->minlen + 1)
+			args->minalignslop = nextminlen + stripe_align -
+					args->minlen - 1;
+		else
+			args->minalignslop = 0;
+
+		args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, args->fsbno));
+		error = xfs_alloc_vextent_this_ag(args);
+		xfs_perag_put(args->pag);
+		if (error)
+			return error;
+
+		if (args->fsbno != NULLFSBLOCK)
+			return 0;
+		/*
+		 * Exact allocation failed. Reset to try an aligned allocation
+		 * according to the original allocation specification.
+		 */
+		args->pag = NULL;
+		args->type = atype;
+		args->fsbno = ap->blkno;
+		args->alignment = stripe_align;
+		args->minlen = nextminlen;
+		args->minalignslop = 0;
+	} else {
+		args->alignment = stripe_align;
+		atype = args->type;
+		/*
+		 * Adjust minlen to try and preserve alignment if we
+		 * can't guarantee an aligned maxlen extent.
+		 */
+		if (blen > args->alignment &&
+		    blen <= args->maxlen + args->alignment)
+			args->minlen = blen - args->alignment;
+		args->minalignslop = 0;
+	}
+
+	error = xfs_alloc_vextent(args);
+	if (error)
+		return error;
+
+	if (args->fsbno != NULLFSBLOCK)
+		return 0;
+
+	/*
+	 * Allocation failed, so turn return the allocation args to their
+	 * original non-aligned state so the caller can proceed on allocation
+	 * failure as if this function was never called.
+	 */
+	args->type = atype;
+	args->fsbno = ap->blkno;
+	args->alignment = 1;
+	return 0;
+}
+
+static int
+xfs_bmap_btalloc_best_length(
+	struct xfs_bmalloca	*ap,
+	struct xfs_alloc_arg	*args,
+	int			stripe_align)
+{
+	struct xfs_mount	*mp = args->mp;
+	xfs_extlen_t		blen = 0;
+	int			error;
+
+	/*
+	 * Determine the initial block number we will target for allocation.
+	 */
 	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
 	    xfs_inode_is_filestream(ap->ip)) {
-		ag = xfs_filestream_lookup_ag(ap->ip);
-		ag = (ag != NULLAGNUMBER) ? ag : 0;
-		ap->blkno = XFS_AGB_TO_FSB(mp, ag, 0);
+		xfs_agnumber_t	agno = xfs_filestream_lookup_ag(ap->ip);
+		if (agno == NULLAGNUMBER)
+			agno = 0;
+		ap->blkno = XFS_AGB_TO_FSB(mp, agno, 0);
 	} else {
 		ap->blkno = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
 	}
-
 	xfs_bmap_adjacent(ap);
+	args->fsbno = ap->blkno;
 
-	args.fsbno = ap->blkno;
-	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
+	/*
+	 * Search for an allocation group with a single extent large enough for
+	 * the request.  If one isn't found, then adjust the minimum allocation
+	 * size to the largest space found.
+	 */
+	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
+	    xfs_inode_is_filestream(ap->ip))
+		error = xfs_bmap_btalloc_filestreams(ap, args, &blen);
+	else
+		error = xfs_bmap_btalloc_select_lengths(ap, args, &blen);
+	if (error)
+		return error;
+
+	/*
+	 * Don't attempt optimal EOF allocation if previous allocations barely
+	 * succeeded due to being near ENOSPC. It is highly unlikely we'll get
+	 * optimal or even aligned allocations in this case, so don't waste time
+	 * trying.
+	 */
+	if (ap->aeof && !(ap->tp->t_flags & XFS_TRANS_LOWMODE)) {
+		error = xfs_bmap_btalloc_at_eof(ap, args, blen, stripe_align);
+		if (error)
+			return error;
+		if (args->fsbno != NULLFSBLOCK)
+			return 0;
+	}
+
+	error = xfs_alloc_vextent(args);
+	if (error)
+		return error;
+	if (args->fsbno != NULLFSBLOCK)
+		return 0;
+
+	/*
+	 * Try a locality first full filesystem minimum length allocation whilst
+	 * still maintaining necessary total block reservation requirements.
+	 */
+	if (args->minlen > ap->minlen) {
+		args->minlen = ap->minlen;
+		args->type = XFS_ALLOCTYPE_START_BNO;
+		args->fsbno = ap->blkno;
+		error = xfs_alloc_vextent(args);
+		if (error)
+			return error;
+	}
+	if (args->fsbno != NULLFSBLOCK)
+		return 0;
+
+	/*
+	 * We are now critically low on space, so this is a last resort
+	 * allocation attempt: no reserve, no locality, blocking, minimum
+	 * length, full filesystem free space scan. We also indicate to future
+	 * allocations in this transaction that we are critically low on space
+	 * so they don't waste time on allocation modes that are unlikely to
+	 * succeed.
+	 */
+	args->fsbno = 0;
+	args->type = XFS_ALLOCTYPE_FIRST_AG;
+	args->total = ap->minlen;
+	error = xfs_alloc_vextent(args);
+	if (error)
+		return error;
+	ap->tp->t_flags |= XFS_TRANS_LOWMODE;
+	return 0;
+}
+
+static int
+xfs_bmap_btalloc(
+	struct xfs_bmalloca	*ap)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_alloc_arg	args = {
+		.tp		= ap->tp,
+		.mp		= mp,
+		.fsbno		= NULLFSBLOCK,
+		.oinfo		= XFS_RMAP_OINFO_SKIP_UPDATE,
+		.minleft	= ap->minleft,
+		.wasdel		= ap->wasdel,
+		.resv		= XFS_AG_RESV_NONE,
+		.datatype	= ap->datatype,
+		.alignment	= 1,
+		.minalignslop	= 0,
+	};
+	xfs_fileoff_t		orig_offset;
+	xfs_extlen_t		orig_length;
+	int			error;
+	int			stripe_align;
+
+	ASSERT(ap->length);
+	orig_offset = ap->offset;
+	orig_length = ap->length;
+
+	stripe_align = xfs_bmap_compute_alignments(ap, &args);
 
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = min(ap->length, mp->m_ag_max_usable);
-	blen = 0;
 
-	/*
-	 * Search for an allocation group with a single extent large
-	 * enough for the request.  If one isn't found, then adjust
-	 * the minimum allocation size to the largest space found.
-	 */
-	if ((ap->datatype & XFS_ALLOC_USERDATA) &&
-	    xfs_inode_is_filestream(ap->ip))
-		error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
-	else
-		error = xfs_bmap_btalloc_select_lengths(ap, &args, &blen);
+	error = xfs_bmap_btalloc_best_length(ap, &args, stripe_align);
 	if (error)
 		return error;
 
-	/*
-	 * If we are not low on available data blocks, and the underlying
-	 * logical volume manager is a stripe, and the file offset is zero then
-	 * try to allocate data blocks on stripe unit boundary. NOTE: ap->aeof
-	 * is only set if the allocation length is >= the stripe unit and the
-	 * allocation offset is at the end of file.
-	 */
-	if (!(ap->tp->t_flags & XFS_TRANS_LOWMODE) && ap->aeof) {
-		if (!ap->offset) {
-			args.alignment = stripe_align;
-			atype = args.type;
-			isaligned = 1;
-			/*
-			 * Adjust minlen to try and preserve alignment if we
-			 * can't guarantee an aligned maxlen extent.
-			 */
-			if (blen > args.alignment &&
-			    blen <= args.maxlen + args.alignment)
-				args.minlen = blen - args.alignment;
-			args.minalignslop = 0;
-		} else {
-			/*
-			 * First try an exact bno allocation.
-			 * If it fails then do a near or start bno
-			 * allocation with alignment turned on.
-			 */
-			atype = args.type;
-			args.type = XFS_ALLOCTYPE_THIS_BNO;
-			args.alignment = 1;
-
-			/*
-			 * Compute the minlen+alignment for the
-			 * next case.  Set slop so that the value
-			 * of minlen+alignment+slop doesn't go up
-			 * between the calls.
-			 */
-			if (blen > stripe_align && blen <= args.maxlen)
-				nextminlen = blen - stripe_align;
-			else
-				nextminlen = args.minlen;
-			if (nextminlen + stripe_align > args.minlen + 1)
-				args.minalignslop =
-					nextminlen + stripe_align -
-					args.minlen - 1;
-			else
-				args.minalignslop = 0;
-
-			args.pag = xfs_perag_get(mp,
-					XFS_FSB_TO_AGNO(mp, args.fsbno));
-			error = xfs_alloc_vextent_this_ag(&args);
-			xfs_perag_put(args.pag);
-			if (error)
-				return error;
-
-			if (args.fsbno != NULLFSBLOCK)
-				goto out_success;
-			/*
-			 * Exact allocation failed. Now try with alignment
-			 * turned on.
-			 */
-			args.pag = NULL;
-			args.type = atype;
-			args.fsbno = ap->blkno;
-			args.alignment = stripe_align;
-			args.minlen = nextminlen;
-			args.minalignslop = 0;
-			isaligned = 1;
-		}
-	} else {
-		args.alignment = 1;
-		args.minalignslop = 0;
-	}
-
-	error = xfs_alloc_vextent(&args);
-	if (error)
-		return error;
-
-	if (isaligned && args.fsbno == NULLFSBLOCK) {
-		/*
-		 * allocation failed, so turn off alignment and
-		 * try again.
-		 */
-		args.type = atype;
-		args.fsbno = ap->blkno;
-		args.alignment = 0;
-		if ((error = xfs_alloc_vextent(&args)))
-			return error;
-	}
-	if (args.fsbno == NULLFSBLOCK &&
-	    args.minlen > ap->minlen) {
-		args.minlen = ap->minlen;
-		args.type = XFS_ALLOCTYPE_START_BNO;
-		args.fsbno = ap->blkno;
-		if ((error = xfs_alloc_vextent(&args)))
-			return error;
-	}
-	if (args.fsbno == NULLFSBLOCK) {
-		args.fsbno = 0;
-		args.type = XFS_ALLOCTYPE_FIRST_AG;
-		args.total = ap->minlen;
-		if ((error = xfs_alloc_vextent(&args)))
-			return error;
-		ap->tp->t_flags |= XFS_TRANS_LOWMODE;
-	}
-	args.minleft = ap->minleft;
-	args.wasdel = ap->wasdel;
-	args.resv = XFS_AG_RESV_NONE;
-	args.datatype = ap->datatype;
-
 	if (args.fsbno != NULLFSBLOCK) {
-out_success:
 		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
 			orig_length);
 	} else {
-- 
2.39.0

