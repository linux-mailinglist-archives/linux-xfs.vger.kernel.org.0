Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34E23036A7
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Jan 2021 07:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388516AbhAZGgM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 26 Jan 2021 01:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729274AbhAZGfi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 01:35:38 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F129FC0617AB
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:30 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id u11so9230696plg.13
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 22:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LWfZ7yCfQ02GgWSCzQ+6jSMmvQ5C2R60I4IZHml8KhI=;
        b=ih8aghb9+Hl6jJF2VMh7O9a3jBtPQv1xYXylsBo7kDNe8tKOnIXVSqOHcLcKpS1aC7
         S7crBB0B2AK9CCQGEl/TJsRGok3aTtJGMDCjUXLmHePBi9kp6u7LKapjChAUTK7DQpe5
         VlXmhc7CGlgXLFwCBFVeusrbtpRQlBOxtMsja8eVr7OA9DpBYX59uqAXdqv+XXh0ukTC
         LXcbqbogNyzZSUb+gz7CZfpRncVspZYexjtcSmw/pPTGL5dQHfRyUbjgMbEfwHAuJyi4
         avwHpfZ8lU6ag3vTrOiQcZy86BhlHJUFXw1/U7Fm/RuiGPRTRgvR44z6SWFRLwi7RfFV
         X/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LWfZ7yCfQ02GgWSCzQ+6jSMmvQ5C2R60I4IZHml8KhI=;
        b=Bfs/9Rb/eQuSEv/G9qpVebsxnKUHL0mIKULrBOPtJKNEHtm6gRPfLVNav93HUvZAef
         OZzZvQLdvI5Q1YdeItBu6esn0cBMbYvX624yDbePH5Ew/Sk0wpXt4mNnjjpEVBA5sXHP
         q0XLiiv7SSkpVSGoPwZv0Oug56olpGDMbPGpDhhcSKezQwyjrj+8cLpO1v/6MV1BiLRC
         VFKahPIYfu6qugJapzrrY2X5ffXNTDcFtrk/84reKitFIz+/ym+kV0terUXXke74mIEG
         /wHRl5aOvoLIL/j+4Ic8J1s7kZujTkA2CYJdesPxMN9AKFbaOYD9/V/5g30aIFjw4xhw
         Q+7A==
X-Gm-Message-State: AOAM531tZKkT6WZ9U0Ewrw9v8SjUD6vESfnvnGOR8e33HNKHKZyjZhPw
        6MIWVD/Lf4Mo4TXxtAN4aoDwGkibD8Q=
X-Google-Smtp-Source: ABdhPJx8tf4ZzdPL8iT8RK/PN384b/++BB6s295/yo0c7x5S8wkO0SJc0cR7ErWOjV1qxR8iIWviKg==
X-Received: by 2002:a17:90a:dac6:: with SMTP id g6mr4492920pjx.178.1611642810256;
        Mon, 25 Jan 2021 22:33:30 -0800 (PST)
Received: from localhost.localdomain ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id w21sm17296578pff.220.2021.01.25.22.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 22:33:29 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org,
        hch@lst.de, allison.henderson@oracle.com,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH V15 16/16] xfs: Introduce error injection to allocate only minlen size extents for files
Date:   Tue, 26 Jan 2021 12:02:32 +0530
Message-Id: <20210126063232.3648053-17-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126063232.3648053-1-chandanrlinux@gmail.com>
References: <20210126063232.3648053-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag which
helps userspace test programs to get xfs_bmap_btalloc() to always
allocate minlen sized extents.

This is required for test programs which need a guarantee that minlen
extents allocated for a file do not get merged with their existing
neighbours in the inode's BMBT. "Inode fork extent overflow check" for
Directories, Xattrs and extension of realtime inodes need this since the
file offset at which the extents are being allocated cannot be
explicitly controlled from userspace.

One way to use this error tag is to,
1. Consume all of the free space by sequentially writing to a file.
2. Punch alternate blocks of the file. This causes CNTBT to contain
   sufficient number of one block sized extent records.
3. Inject XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag.
After step 3, xfs_bmap_btalloc() will issue space allocation
requests for minlen sized extents only.

ENOSPC error code is returned to userspace when there aren't any "one
block sized" extents left in any of the AGs.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_alloc.c    |  50 ++++++++++++++
 fs/xfs/libxfs/xfs_alloc.h    |   3 +
 fs/xfs/libxfs/xfs_bmap.c     | 124 ++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_errortag.h |   4 +-
 fs/xfs/xfs_error.c           |   3 +
 5 files changed, 159 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7cb9f064ac64..0c623d3c1036 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2474,6 +2474,47 @@ xfs_defer_agfl_block(
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &new->xefi_list);
 }
 
+#ifdef DEBUG
+/*
+ * Check if an AGF has a free extent record whose length is equal to
+ * args->minlen.
+ */
+STATIC int
+xfs_exact_minlen_extent_available(
+	struct xfs_alloc_arg	*args,
+	struct xfs_buf		*agbp,
+	int			*stat)
+{
+	struct xfs_btree_cur	*cnt_cur;
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
+	int			error = 0;
+
+	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, agbp,
+			args->agno, XFS_BTNUM_CNT);
+	error = xfs_alloc_lookup_ge(cnt_cur, 0, args->minlen, stat);
+	if (error)
+		goto out;
+
+	if (*stat == 0) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, stat);
+	if (error)
+		goto out;
+
+	if (*stat == 1 && flen != args->minlen)
+		*stat = 0;
+
+out:
+	xfs_btree_del_cursor(cnt_cur, error);
+
+	return error;
+}
+#endif
+
 /*
  * Decide whether to use this allocation group for this allocation.
  * If so, fix up the btree freelist's size.
@@ -2545,6 +2586,15 @@ xfs_alloc_fix_freelist(
 	if (!xfs_alloc_space_available(args, need, flags))
 		goto out_agbp_relse;
 
+#ifdef DEBUG
+	if (args->alloc_minlen_only) {
+		int stat;
+
+		error = xfs_exact_minlen_extent_available(args, agbp, &stat);
+		if (error || !stat)
+			goto out_agbp_relse;
+	}
+#endif
 	/*
 	 * Make the freelist shorter if it's too long.
 	 *
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 6c22b12176b8..a4427c5775c2 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -75,6 +75,9 @@ typedef struct xfs_alloc_arg {
 	char		wasfromfl;	/* set if allocation is from freelist */
 	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 	enum xfs_ag_resv_type	resv;	/* block reservation to use */
+#ifdef DEBUG
+	bool		alloc_minlen_only; /* allocate exact minlen extent */
+#endif
 } xfs_alloc_arg_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ee2c0a4295c6..33117aef79e5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3552,34 +3552,101 @@ xfs_bmap_process_allocated_extent(
 	xfs_bmap_btalloc_accounting(ap, args);
 }
 
-STATIC int
-xfs_bmap_btalloc(
-	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
+#ifdef DEBUG
+static int
+xfs_bmap_exact_minlen_extent_alloc(
+	struct xfs_bmalloca	*ap)
 {
-	xfs_mount_t	*mp;		/* mount point structure */
-	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
-	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
-	xfs_agnumber_t	ag;
-	xfs_alloc_arg_t	args;
-	xfs_fileoff_t	orig_offset;
-	xfs_extlen_t	orig_length;
-	xfs_extlen_t	blen;
-	xfs_extlen_t	nextminlen = 0;
-	int		nullfb;		/* true if ap->firstblock isn't set */
-	int		isaligned;
-	int		tryagain;
-	int		error;
-	int		stripe_align;
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
+	xfs_fileoff_t		orig_offset;
+	xfs_extlen_t		orig_length;
+	int			error;
 
 	ASSERT(ap->length);
+
+	if (ap->minlen != 1) {
+		ap->blkno = NULLFSBLOCK;
+		ap->length = 0;
+		return 0;
+	}
+
 	orig_offset = ap->offset;
 	orig_length = ap->length;
 
-	mp = ap->ip->i_mount;
+	args.alloc_minlen_only = 1;
 
-	memset(&args, 0, sizeof(args));
-	args.tp = ap->tp;
-	args.mp = mp;
+	xfs_bmap_compute_alignments(ap, &args);
+
+	if (ap->tp->t_firstblock == NULLFSBLOCK) {
+		/*
+		 * Unlike the longest extent available in an AG, we don't track
+		 * the length of an AG's shortest extent.
+		 * XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is a debug only knob and
+		 * hence we can afford to start traversing from the 0th AG since
+		 * we need not be concerned about a drop in performance in
+		 * "debug only" code paths.
+		 */
+		ap->blkno = XFS_AGB_TO_FSB(mp, 0, 0);
+	} else {
+		ap->blkno = ap->tp->t_firstblock;
+	}
+
+	args.fsbno = ap->blkno;
+	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
+	args.type = XFS_ALLOCTYPE_FIRST_AG;
+	args.total = args.minlen = args.maxlen = ap->minlen;
+
+	args.alignment = 1;
+	args.minalignslop = 0;
+
+	args.minleft = ap->minleft;
+	args.wasdel = ap->wasdel;
+	args.resv = XFS_AG_RESV_NONE;
+	args.datatype = ap->datatype;
+
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		return error;
+
+	if (args.fsbno != NULLFSBLOCK) {
+		xfs_bmap_process_allocated_extent(ap, &args, orig_offset,
+			orig_length);
+	} else {
+		ap->blkno = NULLFSBLOCK;
+		ap->length = 0;
+	}
+
+	return 0;
+}
+#else
+
+#define xfs_bmap_exact_minlen_extent_alloc(bma) (-EFSCORRUPTED)
+
+#endif
+
+STATIC int
+xfs_bmap_btalloc(
+	struct xfs_bmalloca	*ap)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
+	xfs_alloctype_t		atype = 0;
+	xfs_agnumber_t		fb_agno;	/* ag number of ap->firstblock */
+	xfs_agnumber_t		ag;
+	xfs_fileoff_t		orig_offset;
+	xfs_extlen_t		orig_length;
+	xfs_extlen_t		blen;
+	xfs_extlen_t		nextminlen = 0;
+	int			nullfb; /* true if ap->firstblock isn't set */
+	int			isaligned;
+	int			tryagain;
+	int			error;
+	int			stripe_align;
+
+	ASSERT(ap->length);
+	orig_offset = ap->offset;
+	orig_length = ap->length;
 
 	stripe_align = xfs_bmap_compute_alignments(ap, &args);
 
@@ -4113,6 +4180,10 @@ xfs_bmap_alloc_userdata(
 			return xfs_bmap_rtalloc(bma);
 	}
 
+	if (unlikely(XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
+		return xfs_bmap_exact_minlen_extent_alloc(bma);
+
 	return xfs_bmap_btalloc(bma);
 }
 
@@ -4149,10 +4220,15 @@ xfs_bmapi_allocate(
 	else
 		bma->minlen = 1;
 
-	if (bma->flags & XFS_BMAPI_METADATA)
-		error = xfs_bmap_btalloc(bma);
-	else
+	if (bma->flags & XFS_BMAPI_METADATA) {
+		if (unlikely(XFS_TEST_ERROR(false, mp,
+				XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
+			error = xfs_bmap_exact_minlen_extent_alloc(bma);
+		else
+			error = xfs_bmap_btalloc(bma);
+	} else {
 		error = xfs_bmap_alloc_userdata(bma);
+	}
 	if (error || bma->blkno == NULLFSBLOCK)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
index 1c56fcceeea6..6ca9084b6934 100644
--- a/fs/xfs/libxfs/xfs_errortag.h
+++ b/fs/xfs/libxfs/xfs_errortag.h
@@ -57,7 +57,8 @@
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
 #define XFS_ERRTAG_BUF_IOERROR				35
 #define XFS_ERRTAG_REDUCE_MAX_IEXTENTS			36
-#define XFS_ERRTAG_MAX					37
+#define XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT		37
+#define XFS_ERRTAG_MAX					38
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -99,5 +100,6 @@
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
 #define XFS_RANDOM_BUF_IOERROR				XFS_RANDOM_DEFAULT
 #define XFS_RANDOM_REDUCE_MAX_IEXTENTS			1
+#define XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT		1
 
 #endif /* __XFS_ERRORTAG_H_ */
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 3780b118cc47..185b4915b7bf 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -55,6 +55,7 @@ static unsigned int xfs_errortag_random_default[] = {
 	XFS_RANDOM_IUNLINK_FALLBACK,
 	XFS_RANDOM_BUF_IOERROR,
 	XFS_RANDOM_REDUCE_MAX_IEXTENTS,
+	XFS_RANDOM_BMAP_ALLOC_MINLEN_EXTENT,
 };
 
 struct xfs_errortag_attr {
@@ -166,6 +167,7 @@ XFS_ERRORTAG_ATTR_RW(bad_summary,	XFS_ERRTAG_FORCE_SUMMARY_RECALC);
 XFS_ERRORTAG_ATTR_RW(iunlink_fallback,	XFS_ERRTAG_IUNLINK_FALLBACK);
 XFS_ERRORTAG_ATTR_RW(buf_ioerror,	XFS_ERRTAG_BUF_IOERROR);
 XFS_ERRORTAG_ATTR_RW(reduce_max_iextents,	XFS_ERRTAG_REDUCE_MAX_IEXTENTS);
+XFS_ERRORTAG_ATTR_RW(bmap_alloc_minlen_extent,	XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT);
 
 static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(noerror),
@@ -205,6 +207,7 @@ static struct attribute *xfs_errortag_attrs[] = {
 	XFS_ERRORTAG_ATTR_LIST(iunlink_fallback),
 	XFS_ERRORTAG_ATTR_LIST(buf_ioerror),
 	XFS_ERRORTAG_ATTR_LIST(reduce_max_iextents),
+	XFS_ERRORTAG_ATTR_LIST(bmap_alloc_minlen_extent),
 	NULL,
 };
 
-- 
2.29.2

