Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4305226985
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2019 20:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbfEVSFs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 May 2019 14:05:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbfEVSFs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 May 2019 14:05:48 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 90FE330044C9
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:47 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E7AC1B465
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2019 18:05:47 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 01/11] xfs: clean up small allocation helper
Date:   Wed, 22 May 2019 14:05:36 -0400
Message-Id: <20190522180546.17063-2-bfoster@redhat.com>
In-Reply-To: <20190522180546.17063-1-bfoster@redhat.com>
References: <20190522180546.17063-1-bfoster@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 22 May 2019 18:05:47 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_alloc_ag_vextent_small() is kind of a mess. Clean it up in
preparation for future changes. No functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c | 133 +++++++++++++++++---------------------
 1 file changed, 61 insertions(+), 72 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a9ff3cf82cce..9751531d3000 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1583,92 +1583,81 @@ xfs_alloc_ag_vextent_size(
 }
 
 /*
- * Deal with the case where only small freespaces remain.
- * Either return the contents of the last freespace record,
- * or allocate space from the freelist if there is nothing in the tree.
+ * Deal with the case where only small freespaces remain. Either return the
+ * contents of the last freespace record, or allocate space from the freelist if
+ * there is nothing in the tree.
  */
 STATIC int			/* error */
 xfs_alloc_ag_vextent_small(
-	xfs_alloc_arg_t	*args,	/* allocation argument structure */
-	xfs_btree_cur_t	*ccur,	/* by-size cursor */
-	xfs_agblock_t	*fbnop,	/* result block number */
-	xfs_extlen_t	*flenp,	/* result length */
-	int		*stat)	/* status: 0-freelist, 1-normal/none */
+	struct xfs_alloc_arg	*args,	/* allocation argument structure */
+	struct xfs_btree_cur	*ccur,	/* optional by-size cursor */
+	xfs_agblock_t		*fbnop,	/* result block number */
+	xfs_extlen_t		*flenp,	/* result length */
+	int			*stat)	/* status: 0-freelist, 1-normal/none */
 {
-	int		error;
-	xfs_agblock_t	fbno;
-	xfs_extlen_t	flen;
-	int		i;
+	int			error = 0;
+	xfs_agblock_t		fbno = NULLAGBLOCK;
+	xfs_extlen_t		flen = 0;
+	int			i;
 
-	if ((error = xfs_btree_decrement(ccur, 0, &i)))
-		goto error0;
+	error = xfs_btree_decrement(ccur, 0, &i);
+	if (error)
+		goto error;
 	if (i) {
-		if ((error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i)))
-			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
-	}
-	/*
-	 * Nothing in the btree, try the freelist.  Make sure
-	 * to respect minleft even when pulling from the
-	 * freelist.
-	 */
-	else if (args->minlen == 1 && args->alignment == 1 &&
-		 args->resv != XFS_AG_RESV_AGFL &&
-		 (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount)
-		  > args->minleft)) {
-		error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
+		error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i);
 		if (error)
-			goto error0;
-		if (fbno != NULLAGBLOCK) {
-			xfs_extent_busy_reuse(args->mp, args->agno, fbno, 1,
-			      xfs_alloc_allow_busy_reuse(args->datatype));
+			goto error;
+		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
+		goto out;
+	}
 
-			if (xfs_alloc_is_userdata(args->datatype)) {
-				xfs_buf_t	*bp;
+	if (args->minlen != 1 || args->alignment != 1 ||
+	    args->resv == XFS_AG_RESV_AGFL ||
+	    (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount) <=
+	     args->minleft))
+		goto out;
 
-				bp = xfs_btree_get_bufs(args->mp, args->tp,
-					args->agno, fbno, 0);
-				if (!bp) {
-					error = -EFSCORRUPTED;
-					goto error0;
-				}
-				xfs_trans_binval(args->tp, bp);
-			}
-			args->len = 1;
-			args->agbno = fbno;
-			XFS_WANT_CORRUPTED_GOTO(args->mp,
-				args->agbno + args->len <=
-				be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
-				error0);
-			args->wasfromfl = 1;
-			trace_xfs_alloc_small_freelist(args);
+	error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
+	if (error)
+		goto error;
+	if (fbno == NULLAGBLOCK)
+		goto out;
 
-			/*
-			 * If we're feeding an AGFL block to something that
-			 * doesn't live in the free space, we need to clear
-			 * out the OWN_AG rmap.
-			 */
-			error = xfs_rmap_free(args->tp, args->agbp, args->agno,
-					fbno, 1, &XFS_RMAP_OINFO_AG);
-			if (error)
-				goto error0;
+	xfs_extent_busy_reuse(args->mp, args->agno, fbno, 1,
+			      xfs_alloc_allow_busy_reuse(args->datatype));
 
-			*stat = 0;
-			return 0;
+	if (xfs_alloc_is_userdata(args->datatype)) {
+		struct xfs_buf	*bp;
+
+		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno,
+					0);
+		if (!bp) {
+			error = -EFSCORRUPTED;
+			goto error;
 		}
-		/*
-		 * Nothing in the freelist.
-		 */
-		else
-			flen = 0;
+		xfs_trans_binval(args->tp, bp);
 	}
+	args->len = 1;
+	args->agbno = fbno;
+	XFS_WANT_CORRUPTED_GOTO(args->mp,
+		fbno < be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
+		error);
+	args->wasfromfl = 1;
+	trace_xfs_alloc_small_freelist(args);
+
 	/*
-	 * Can't allocate from the freelist for some reason.
+	 * If we're feeding an AGFL block to something that doesn't live in the
+	 * free space, we need to clear out the OWN_AG rmap.
 	 */
-	else {
-		fbno = NULLAGBLOCK;
-		flen = 0;
-	}
+	error = xfs_rmap_free(args->tp, args->agbp, args->agno, fbno, 1,
+			      &XFS_RMAP_OINFO_AG);
+	if (error)
+		goto error;
+
+	*stat = 0;
+	return 0;
+
+out:
 	/*
 	 * Can't do the allocation, give up.
 	 */
@@ -1683,7 +1672,7 @@ xfs_alloc_ag_vextent_small(
 	trace_xfs_alloc_small_done(args);
 	return 0;
 
-error0:
+error:
 	trace_xfs_alloc_small_error(args);
 	return error;
 }
-- 
2.17.2

