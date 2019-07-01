Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4093926987
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2019 20:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbfEVSFt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 May 2019 14:05:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49982 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728615AbfEVSFs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 May 2019 14:05:48 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 01E303082B5F
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:48 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1AA05C296
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:47 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 02/11] xfs: move small allocation helper
Date:   Wed, 22 May 2019 14:05:37 -0400
Message-Id: <20190522180546.17063-3-bfoster@redhat.com>
In-Reply-To: <20190522180546.17063-1-bfoster@redhat.com>
References: <20190522180546.17063-1-bfoster@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 22 May 2019 18:05:48 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the small allocation helper further up in the file to avoid the
need for a function declaration. The remaining declarations will be
removed by followup patches. No functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 192 +++++++++++++++++++-------------------
 1 file changed, 95 insertions(+), 97 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9751531d3000..b345fe771c54 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -41,8 +41,6 @@ struct workqueue_struct *xfs_alloc_wq;
 STATIC int xfs_alloc_ag_vextent_exact(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_near(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
-STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
-		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
 
 /*
  * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of slots in
@@ -699,6 +697,101 @@ xfs_alloc_update_counters(
  * Allocation group level functions.
  */
 
+/*
+ * Deal with the case where only small freespaces remain. Either return the
+ * contents of the last freespace record, or allocate space from the freelist if
+ * there is nothing in the tree.
+ */
+STATIC int			/* error */
+xfs_alloc_ag_vextent_small(
+	struct xfs_alloc_arg	*args,	/* allocation argument structure */
+	struct xfs_btree_cur	*ccur,	/* optional by-size cursor */
+	xfs_agblock_t		*fbnop,	/* result block number */
+	xfs_extlen_t		*flenp,	/* result length */
+	int			*stat)	/* status: 0-freelist, 1-normal/none */
+{
+	int			error = 0;
+	xfs_agblock_t		fbno = NULLAGBLOCK;
+	xfs_extlen_t		flen = 0;
+	int			i;
+
+	error = xfs_btree_decrement(ccur, 0, &i);
+	if (error)
+		goto error;
+	if (i) {
+		error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i);
+		if (error)
+			goto error;
+		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
+		goto out;
+	}
+
+	if (args->minlen != 1 || args->alignment != 1 ||
+	    args->resv == XFS_AG_RESV_AGFL ||
+	    (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount) <=
+	     args->minleft))
+		goto out;
+
+	error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
+	if (error)
+		goto error;
+	if (fbno == NULLAGBLOCK)
+		goto out;
+
+	xfs_extent_busy_reuse(args->mp, args->agno, fbno, 1,
+			      xfs_alloc_allow_busy_reuse(args->datatype));
+
+	if (xfs_alloc_is_userdata(args->datatype)) {
+		struct xfs_buf	*bp;
+
+		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno,
+					0);
+		if (!bp) {
+			error = -EFSCORRUPTED;
+			goto error;
+		}
+		xfs_trans_binval(args->tp, bp);
+	}
+	args->len = 1;
+	args->agbno = fbno;
+	XFS_WANT_CORRUPTED_GOTO(args->mp,
+		fbno < be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
+		error);
+	args->wasfromfl = 1;
+	trace_xfs_alloc_small_freelist(args);
+
+	/*
+	 * If we're feeding an AGFL block to something that doesn't live in the
+	 * free space, we need to clear out the OWN_AG rmap.
+	 */
+	error = xfs_rmap_free(args->tp, args->agbp, args->agno, fbno, 1,
+			      &XFS_RMAP_OINFO_AG);
+	if (error)
+		goto error;
+
+	*stat = 0;
+	return 0;
+
+out:
+	/*
+	 * Can't do the allocation, give up.
+	 */
+	if (flen < args->minlen) {
+		args->agbno = NULLAGBLOCK;
+		trace_xfs_alloc_small_notenough(args);
+		flen = 0;
+	}
+	*fbnop = fbno;
+	*flenp = flen;
+	*stat = 1;
+	trace_xfs_alloc_small_done(args);
+	return 0;
+
+error:
+	trace_xfs_alloc_small_error(args);
+	return error;
+}
+
 /*
  * Allocate a variable extent in the allocation group agno.
  * Type and bno are used to determine where in the allocation group the
@@ -1582,101 +1675,6 @@ xfs_alloc_ag_vextent_size(
 	return 0;
 }
 
-/*
- * Deal with the case where only small freespaces remain. Either return the
- * contents of the last freespace record, or allocate space from the freelist if
- * there is nothing in the tree.
- */
-STATIC int			/* error */
-xfs_alloc_ag_vextent_small(
-	struct xfs_alloc_arg	*args,	/* allocation argument structure */
-	struct xfs_btree_cur	*ccur,	/* optional by-size cursor */
-	xfs_agblock_t		*fbnop,	/* result block number */
-	xfs_extlen_t		*flenp,	/* result length */
-	int			*stat)	/* status: 0-freelist, 1-normal/none */
-{
-	int			error = 0;
-	xfs_agblock_t		fbno = NULLAGBLOCK;
-	xfs_extlen_t		flen = 0;
-	int			i;
-
-	error = xfs_btree_decrement(ccur, 0, &i);
-	if (error)
-		goto error;
-	if (i) {
-		error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i);
-		if (error)
-			goto error;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
-		goto out;
-	}
-
-	if (args->minlen != 1 || args->alignment != 1 ||
-	    args->resv == XFS_AG_RESV_AGFL ||
-	    (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount) <=
-	     args->minleft))
-		goto out;
-
-	error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
-	if (error)
-		goto error;
-	if (fbno == NULLAGBLOCK)
-		goto out;
-
-	xfs_extent_busy_reuse(args->mp, args->agno, fbno, 1,
-			      xfs_alloc_allow_busy_reuse(args->datatype));
-
-	if (xfs_alloc_is_userdata(args->datatype)) {
-		struct xfs_buf	*bp;
-
-		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno,
-					0);
-		if (!bp) {
-			error = -EFSCORRUPTED;
-			goto error;
-		}
-		xfs_trans_binval(args->tp, bp);
-	}
-	args->len = 1;
-	args->agbno = fbno;
-	XFS_WANT_CORRUPTED_GOTO(args->mp,
-		fbno < be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
-		error);
-	args->wasfromfl = 1;
-	trace_xfs_alloc_small_freelist(args);
-
-	/*
-	 * If we're feeding an AGFL block to something that doesn't live in the
-	 * free space, we need to clear out the OWN_AG rmap.
-	 */
-	error = xfs_rmap_free(args->tp, args->agbp, args->agno, fbno, 1,
-			      &XFS_RMAP_OINFO_AG);
-	if (error)
-		goto error;
-
-	*stat = 0;
-	return 0;
-
-out:
-	/*
-	 * Can't do the allocation, give up.
-	 */
-	if (flen < args->minlen) {
-		args->agbno = NULLAGBLOCK;
-		trace_xfs_alloc_small_notenough(args);
-		flen = 0;
-	}
-	*fbnop = fbno;
-	*flenp = flen;
-	*stat = 1;
-	trace_xfs_alloc_small_done(args);
-	return 0;
-
-error:
-	trace_xfs_alloc_small_error(args);
-	return error;
-}
-
 /*
  * Free the extent starting at agno/bno for length.
  */
-- 
2.17.2

