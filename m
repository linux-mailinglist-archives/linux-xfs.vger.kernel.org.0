Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5532A48F1
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Nov 2020 16:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbgKCPHh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 3 Nov 2020 10:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbgKCPHg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 10:07:36 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129F8C0613D1
        for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2020 07:07:36 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id c20so14429065pfr.8
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 07:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kUp2tsAW2OySYVVIjctiIzMx68obd9OOBKUKjhSYFmE=;
        b=U2WHU8yMpLLB+fIKxYXbHMzKR/GUWQ+Oe37BFwBwtjGNemr2h0YtXMxsvn11iqkLDP
         PCX3n5Wiu2UM24k1FR+aItrsw5CNyeVyUsmMIcBNzPuI7WBZirU8TOOXczk02a6bmt34
         uPRFUEP3JR2CY3vOpWEnmt+lByK86VaIYQXRW+IOAU/Od00tk7TUu3Sn5yhyAvaHdk2P
         rg48expggxpMDzb1jlYHKjCXqmIYzbWUZRSdPtxCuA9hJHlNVdd6LBD8fAGLCNSeS8df
         2G9dWeWMrrkfqeTPmEq69YCKWED7QP1t8pF4xJUT7qKsjBf/T+MwioGDq6BgEIurLMQy
         jYWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kUp2tsAW2OySYVVIjctiIzMx68obd9OOBKUKjhSYFmE=;
        b=p4YP0lty0jAxydhwJ6GkTRCWNd8lkwVejCHRRnnhcXL31u/rq+HgYUYDqse3jVkU84
         V9Do6qMZnlZ7qI+ME6T49yIJyjzzFgU/Rz/7IWI3dWaL8bjLu9S+gM9K9TfZhWj5KvOD
         wfKmJke+67taY6rvanX9qdcXxNz7Ry94uTjjmQj3dOMPlJTge82A50UeWkquRZsDxleT
         cl6lDmBx4rr9QE90oT11MPnAQAdOzDt8ZtUHMGDn/4QiZ96febojeqMTmJRcVqQ+kH9v
         mZ9A9gWj1tsDUpspwlXVw7vIFrw97nQHmcTAuHsCxZdLFv/9RH9KqNeP7r+RgcwSKKUe
         Pxjw==
X-Gm-Message-State: AOAM5324REKNWJ4SSMFLzAPwzFieHodx7RkP8ULMbENQdloZIqruHdiV
        fNClHUHMB4y7WfS7fVy3MiPj6qpyxntYxg==
X-Google-Smtp-Source: ABdhPJyORu+CBglgvZAVZbty3ckQxRopnHHG9eeBiHSxEv+1ng0ykqZnF+tKbJgrlLNjj7mMEsNsdg==
X-Received: by 2002:a17:90a:d18c:: with SMTP id fu12mr202183pjb.7.1604416055181;
        Tue, 03 Nov 2020 07:07:35 -0800 (PST)
Received: from localhost.localdomain ([122.179.48.228])
        by smtp.gmail.com with ESMTPSA id 15sm15936955pgs.52.2020.11.03.07.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 07:07:34 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V10 14/14] xfs: Introduce error injection to allocate only minlen size extents for files
Date:   Tue,  3 Nov 2020 20:36:42 +0530
Message-Id: <20201103150642.2032284-15-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103150642.2032284-1-chandanrlinux@gmail.com>
References: <20201103150642.2032284-1-chandanrlinux@gmail.com>
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

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_alloc.c    |  50 ++++++++++++++
 fs/xfs/libxfs/xfs_alloc.h    |   3 +
 fs/xfs/libxfs/xfs_bmap.c     | 124 ++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_errortag.h |   4 +-
 fs/xfs/xfs_error.c           |   3 +
 5 files changed, 159 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 852b536551b5..a7c4eb1d71d5 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2473,6 +2473,47 @@ xfs_defer_agfl_block(
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
@@ -2544,6 +2585,15 @@ xfs_alloc_fix_freelist(
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
index f6cd33684571..4717c5f1808e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3552,35 +3552,102 @@ xfs_bmap_process_allocated_extent(
 	xfs_bmap_btalloc_accounting(ap, args);
 }
 
+#ifdef DEBUG
+static int
+xfs_bmap_exact_minlen_extent_alloc(
+	struct xfs_bmalloca	*ap)
+{
+	struct xfs_mount	*mp = ap->ip->i_mount;
+	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
+	xfs_fileoff_t		orig_offset;
+	xfs_extlen_t		orig_length;
+	int			error;
+
+	ASSERT(ap->length);
+
+	if (ap->minlen != 1) {
+		ap->blkno = NULLFSBLOCK;
+		ap->length = 0;
+		return 0;
+	}
+
+	orig_offset = ap->offset;
+	orig_length = ap->length;
+
+	args.alloc_minlen_only = 1;
+
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
 STATIC int
 xfs_bmap_btalloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
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
+	struct xfs_mount	*mp = ap->ip->i_mount;	/* mount point structure */
+	struct xfs_alloc_arg	args = { .tp = ap->tp, .mp = mp };
+	xfs_alloctype_t		atype = 0;		/* type for allocation routines */
+	xfs_agnumber_t		fb_agno;		/* ag number of ap->firstblock */
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
 
 	ASSERT(ap->length);
 	orig_offset = ap->offset;
 	orig_length = ap->length;
 
-	mp = ap->ip->i_mount;
-
-	memset(&args, 0, sizeof(args));
-	args.tp = ap->tp;
-	args.mp = mp;
-
 	stripe_align = xfs_bmap_compute_alignments(ap, &args);
 
 	nullfb = ap->tp->t_firstblock == NULLFSBLOCK;
@@ -4113,7 +4180,11 @@ xfs_bmap_alloc_userdata(
 			return xfs_bmap_rtalloc(bma);
 	}
 
-	return xfs_bmap_btalloc(bma);
+	if (unlikely(XFS_TEST_ERROR(false, mp,
+			XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT)))
+		return xfs_bmap_exact_minlen_extent_alloc(bma);
+	else
+		return xfs_bmap_btalloc(bma);
 }
 
 static int
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
2.28.0

