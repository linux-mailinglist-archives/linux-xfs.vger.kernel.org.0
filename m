Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4872ED621
	for <lists+linux-xfs@lfdr.de>; Sun,  3 Nov 2019 23:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfKCWYt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 3 Nov 2019 17:24:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39554 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfKCWYt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 17:24:49 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOJsR086411
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=uhqc0pmWQzfUs0pKc2xTdxTbQAqbVh5URMPtFk+MVD4=;
 b=BKZSBtdizsUL2Yhw8EuR+e046JQCi9myXGlPml/GvXgfs3/XNnnyo+9qA1FAmeN9E64b
 /nE3OopkrXVAJmwnKZjnCWxEMsetCQe1U6lb6wYo6SoXGO0dLemHxCsdzvHzeyfa05IZ
 vCwMzjUaXi0SbhCZyRKUGpzVyHKH6ZimN4pt+37QibmYYs/M53AmMLUlPazpJWsdIH4y
 eG1EVtWfn/XJYXxlFJdqfNr3ZaSfaMykxMY5qe9CBa63/61tJzDOv6wJY1wxTZSC8nYe
 hkehQd6VMjs5zNgsLHqy4XidnJL9umYzKM97L/5zgV0l7NHps0dEDTFLMltoELoyrb6U LA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w117tm600-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MOJIV136788
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:39 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w1kxc3mr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:24:38 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA3MOc9W017908
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:24:38 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 14:24:37 -0800
Subject: [PATCH 5/6] xfs: kill the XFS_WANT_CORRUPT_* macros
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 03 Nov 2019 14:24:36 -0800
Message-ID: <157281987614.4151907.10140202718414794224.stgit@magnolia>
In-Reply-To: <157281984457.4151907.11281776450827989936.stgit@magnolia>
References: <157281984457.4151907.11281776450827989936.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911030234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911030234
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The XFS_WANT_CORRUPT_* macros conceal subtle side effects such as the
creation of local variables and redirections of the code flow.  This is
pretty ugly, so replace them with explicit XFS_CORRUPT_ON tests that
remove both of those ugly points.  The change was performed with the
following coccinelle script:

@@
expression mp, test;
identifier label;
@@

- XFS_WANT_CORRUPTED_GOTO(mp, test, label);
+ if (XFS_CORRUPT_ON(mp, !test)) { error = -EFSCORRUPTED; goto label; }

@@
expression mp, test;
@@

- XFS_WANT_CORRUPTED_RETURN(mp, test);
+ if (XFS_CORRUPT_ON(mp, !test)) return -EFSCORRUPTED;

@@
expression mp, lval, rval;
@@

- XFS_CORRUPT_ON(mp, !(lval == rval))
+ XFS_CORRUPT_ON(mp, lval != rval)

@@
expression mp, e1, e2;
@@

- XFS_CORRUPT_ON(mp, !(e1 && e2))
+ XFS_CORRUPT_ON(mp, !e1 || !e2)

@@
expression e1, e2;
@@

- !(e1 == e2)
+ e1 != e2

@@
expression e1, e2, e3, e4, e5, e6;
@@

- !(e1 == e2 && e3 == e4) || e5 != e6
+ e1 != e2 || e3 != e4 || e5 != e6

@@
expression e1, e2, e3, e4, e5, e6;
@@

- !(e1 == e2 || (e3 <= e4 && e5 <= e6))
+ e1 != e2 && (e3 > e4 || e5 > e6)

@@
expression mp, e1, e2;
@@

- XFS_CORRUPT_ON(mp, !(e1 <= e2))
+ XFS_CORRUPT_ON(mp, e1 > e2)

@@
expression mp, e1, e2;
@@

- XFS_CORRUPT_ON(mp, !(e1 < e2))
+ XFS_CORRUPT_ON(mp, e1 >= e2)

@@
expression mp, e1;
@@

- XFS_CORRUPT_ON(mp, !!e1)
+ XFS_CORRUPT_ON(mp, e1)

@@
expression mp, e1, e2;
@@

- XFS_CORRUPT_ON(mp, !(e1 || e2))
+ XFS_CORRUPT_ON(mp, !e1 && !e2)

@@
expression mp, e1, e2, e3, e4;
@@

- XFS_CORRUPT_ON(mp, !(e1 == e2) && !(e3 == e4))
+ XFS_CORRUPT_ON(mp, e1 != e2 && e3 != e4)

@@
expression mp, e1, e2, e3, e4;
@@

- XFS_CORRUPT_ON(mp, !(e1 <= e2) || !(e3 >= e4))
+ XFS_CORRUPT_ON(mp, e1 > e2 || e3 < e4)

@@
expression mp, e1, e2, e3, e4;
@@

- XFS_CORRUPT_ON(mp, !(e1 == e2) && !(e3 <= e4))
+ XFS_CORRUPT_ON(mp, e1 != e2 && e3 > e4)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c    |  229 +++++++++++++++++++-------
 fs/xfs/libxfs/xfs_bmap.c     |  299 +++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_btree.c    |   53 +++++-
 fs/xfs/libxfs/xfs_ialloc.c   |  117 ++++++++++---
 fs/xfs/libxfs/xfs_refcount.c |  167 ++++++++++++++-----
 fs/xfs/libxfs/xfs_rmap.c     |  369 ++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_discard.c         |    5 -
 fs/xfs/xfs_error.h           |   26 ---
 fs/xfs/xfs_iwalk.c           |    3 
 9 files changed, 939 insertions(+), 329 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f7a4b54c5bc2..c30b9d975cd7 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -451,13 +451,15 @@ xfs_alloc_fixup_trees(
 #ifdef DEBUG
 		if ((error = xfs_alloc_get_rec(cnt_cur, &nfbno1, &nflen1, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(mp,
-			i == 1 && nfbno1 == fbno && nflen1 == flen);
+		if (XFS_CORRUPT_ON(mp,
+		    i != 1 || nfbno1 != fbno || nflen1 != flen))
+			return -EFSCORRUPTED;
 #endif
 	} else {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, fbno, flen, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
+		if (XFS_CORRUPT_ON(mp, i != 1))
+			return -EFSCORRUPTED;
 	}
 	/*
 	 * Look up the record in the by-block tree if necessary.
@@ -466,13 +468,15 @@ xfs_alloc_fixup_trees(
 #ifdef DEBUG
 		if ((error = xfs_alloc_get_rec(bno_cur, &nfbno1, &nflen1, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(mp,
-			i == 1 && nfbno1 == fbno && nflen1 == flen);
+		if (XFS_CORRUPT_ON(mp,
+		    i != 1 || nfbno1 != fbno || nflen1 != flen))
+			return -EFSCORRUPTED;
 #endif
 	} else {
 		if ((error = xfs_alloc_lookup_eq(bno_cur, fbno, flen, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
+		if (XFS_CORRUPT_ON(mp, i != 1))
+			return -EFSCORRUPTED;
 	}
 
 #ifdef DEBUG
@@ -483,8 +487,9 @@ xfs_alloc_fixup_trees(
 		bnoblock = XFS_BUF_TO_BLOCK(bno_cur->bc_bufs[0]);
 		cntblock = XFS_BUF_TO_BLOCK(cnt_cur->bc_bufs[0]);
 
-		XFS_WANT_CORRUPTED_RETURN(mp,
-			bnoblock->bb_numrecs == cntblock->bb_numrecs);
+		if (XFS_CORRUPT_ON(mp,
+		    bnoblock->bb_numrecs != cntblock->bb_numrecs))
+			return -EFSCORRUPTED;
 	}
 #endif
 
@@ -514,25 +519,30 @@ xfs_alloc_fixup_trees(
 	 */
 	if ((error = xfs_btree_delete(cnt_cur, &i)))
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
+	if (XFS_CORRUPT_ON(mp, i != 1))
+		return -EFSCORRUPTED;
 	/*
 	 * Add new by-size btree entry(s).
 	 */
 	if (nfbno1 != NULLAGBLOCK) {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno1, nflen1, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(mp, i == 0);
+		if (XFS_CORRUPT_ON(mp, i != 0))
+			return -EFSCORRUPTED;
 		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
+		if (XFS_CORRUPT_ON(mp, i != 1))
+			return -EFSCORRUPTED;
 	}
 	if (nfbno2 != NULLAGBLOCK) {
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, nfbno2, nflen2, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(mp, i == 0);
+		if (XFS_CORRUPT_ON(mp, i != 0))
+			return -EFSCORRUPTED;
 		if ((error = xfs_btree_insert(cnt_cur, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
+		if (XFS_CORRUPT_ON(mp, i != 1))
+			return -EFSCORRUPTED;
 	}
 	/*
 	 * Fix up the by-block btree entry(s).
@@ -543,7 +553,8 @@ xfs_alloc_fixup_trees(
 		 */
 		if ((error = xfs_btree_delete(bno_cur, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
+		if (XFS_CORRUPT_ON(mp, i != 1))
+			return -EFSCORRUPTED;
 	} else {
 		/*
 		 * Update the by-block entry to start later|be shorter.
@@ -557,10 +568,12 @@ xfs_alloc_fixup_trees(
 		 */
 		if ((error = xfs_alloc_lookup_eq(bno_cur, nfbno2, nflen2, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(mp, i == 0);
+		if (XFS_CORRUPT_ON(mp, i != 0))
+			return -EFSCORRUPTED;
 		if ((error = xfs_btree_insert(bno_cur, &i)))
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
+		if (XFS_CORRUPT_ON(mp, i != 1))
+			return -EFSCORRUPTED;
 	}
 	return 0;
 }
@@ -821,7 +834,8 @@ xfs_alloc_cur_check(
 	error = xfs_alloc_get_rec(cur, &bno, &len, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(args->mp, i == 1);
+	if (XFS_CORRUPT_ON(args->mp, i != 1))
+		return -EFSCORRUPTED;
 
 	/*
 	 * Check minlen and deactivate a cntbt cursor if out of acceptable size
@@ -1026,7 +1040,10 @@ xfs_alloc_ag_vextent_small(
 		error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i);
 		if (error)
 			goto error;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
+		if (XFS_CORRUPT_ON(args->mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error;
+		}
 		goto out;
 	}
 
@@ -1058,9 +1075,11 @@ xfs_alloc_ag_vextent_small(
 	}
 	*fbnop = args->agbno = fbno;
 	*flenp = args->len = 1;
-	XFS_WANT_CORRUPTED_GOTO(args->mp,
-		fbno < be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
-		error);
+	if (XFS_CORRUPT_ON(args->mp,
+	    fbno >= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length))) {
+		error = -EFSCORRUPTED;
+		goto error;
+	}
 	args->wasfromfl = 1;
 	trace_xfs_alloc_small_freelist(args);
 
@@ -1215,7 +1234,10 @@ xfs_alloc_ag_vextent_exact(
 	error = xfs_alloc_get_rec(bno_cur, &fbno, &flen, &i);
 	if (error)
 		goto error0;
-	XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
+	if (XFS_CORRUPT_ON(args->mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto error0;
+	}
 	ASSERT(fbno <= args->agbno);
 
 	/*
@@ -1550,7 +1572,10 @@ xfs_alloc_ag_vextent_near(
 						&i);
 				if (error)
 					goto out;
-				XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
+				if (XFS_CORRUPT_ON(args->mp, i != 1)) {
+					error = -EFSCORRUPTED;
+					goto out;
+				}
 				if (len >= args->minlen)
 					break;
 				error = xfs_btree_increment(acur.cnt, 0, &i);
@@ -1675,7 +1700,10 @@ xfs_alloc_ag_vextent_size(
 			error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen, &i);
 			if (error)
 				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
+			if (XFS_CORRUPT_ON(args->mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto error0;
+			}
 
 			busy = xfs_alloc_compute_aligned(args, fbno, flen,
 					&rbno, &rlen, &busy_gen);
@@ -1709,8 +1737,11 @@ xfs_alloc_ag_vextent_size(
 	 * This can't happen in the second case above.
 	 */
 	rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
-	XFS_WANT_CORRUPTED_GOTO(args->mp, rlen == 0 ||
-			(rlen <= flen && rbno + rlen <= fbno + flen), error0);
+	if (XFS_CORRUPT_ON(args->mp,
+	    rlen != 0 && (rlen > flen || rbno + rlen > fbno + flen))) {
+		error = -EFSCORRUPTED;
+		goto error0;
+	}
 	if (rlen < args->maxlen) {
 		xfs_agblock_t	bestfbno;
 		xfs_extlen_t	bestflen;
@@ -1729,15 +1760,21 @@ xfs_alloc_ag_vextent_size(
 			if ((error = xfs_alloc_get_rec(cnt_cur, &fbno, &flen,
 					&i)))
 				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
+			if (XFS_CORRUPT_ON(args->mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto error0;
+			}
 			if (flen < bestrlen)
 				break;
 			busy = xfs_alloc_compute_aligned(args, fbno, flen,
 					&rbno, &rlen, &busy_gen);
 			rlen = XFS_EXTLEN_MIN(args->maxlen, rlen);
-			XFS_WANT_CORRUPTED_GOTO(args->mp, rlen == 0 ||
-				(rlen <= flen && rbno + rlen <= fbno + flen),
-				error0);
+			if (XFS_CORRUPT_ON(args->mp,
+			    rlen != 0 &&
+			    (rlen > flen || rbno + rlen > fbno + flen))) {
+				error = -EFSCORRUPTED;
+				goto error0;
+			}
 			if (rlen > bestrlen) {
 				bestrlen = rlen;
 				bestrbno = rbno;
@@ -1750,7 +1787,10 @@ xfs_alloc_ag_vextent_size(
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, bestfbno, bestflen,
 				&i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(args->mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		rlen = bestrlen;
 		rbno = bestrbno;
 		flen = bestflen;
@@ -1773,7 +1813,10 @@ xfs_alloc_ag_vextent_size(
 	xfs_alloc_fix_len(args);
 
 	rlen = args->len;
-	XFS_WANT_CORRUPTED_GOTO(args->mp, rlen <= flen, error0);
+	if (XFS_CORRUPT_ON(args->mp, rlen > flen)) {
+		error = -EFSCORRUPTED;
+		goto error0;
+	}
 	/*
 	 * Allocate and initialize a cursor for the by-block tree.
 	 */
@@ -1787,10 +1830,12 @@ xfs_alloc_ag_vextent_size(
 	cnt_cur = bno_cur = NULL;
 	args->len = rlen;
 	args->agbno = rbno;
-	XFS_WANT_CORRUPTED_GOTO(args->mp,
-		args->agbno + args->len <=
-			be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
-		error0);
+	if (XFS_CORRUPT_ON(args->mp,
+	    args->agbno + args->len >
+	    be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length))) {
+		error = -EFSCORRUPTED;
+		goto error0;
+	}
 	trace_xfs_alloc_size_done(args);
 	return 0;
 
@@ -1862,7 +1907,10 @@ xfs_free_ag_extent(
 		 */
 		if ((error = xfs_alloc_get_rec(bno_cur, &ltbno, &ltlen, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		/*
 		 * It's not contiguous, though.
 		 */
@@ -1874,8 +1922,10 @@ xfs_free_ag_extent(
 			 * space was invalid, it's (partly) already free.
 			 * Very bad.
 			 */
-			XFS_WANT_CORRUPTED_GOTO(mp,
-						ltbno + ltlen <= bno, error0);
+			if (XFS_CORRUPT_ON(mp, ltbno + ltlen > bno)) {
+				error = -EFSCORRUPTED;
+				goto error0;
+			}
 		}
 	}
 	/*
@@ -1890,7 +1940,10 @@ xfs_free_ag_extent(
 		 */
 		if ((error = xfs_alloc_get_rec(bno_cur, &gtbno, &gtlen, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		/*
 		 * It's not contiguous, though.
 		 */
@@ -1902,7 +1955,10 @@ xfs_free_ag_extent(
 			 * space was invalid, it's (partly) already free.
 			 * Very bad.
 			 */
-			XFS_WANT_CORRUPTED_GOTO(mp, gtbno >= bno + len, error0);
+			if (XFS_CORRUPT_ON(mp, bno + len > gtbno)) {
+				error = -EFSCORRUPTED;
+				goto error0;
+			}
 		}
 	}
 	/*
@@ -1919,31 +1975,49 @@ xfs_free_ag_extent(
 		 */
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		/*
 		 * Delete the old by-size entry on the right.
 		 */
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		/*
 		 * Delete the old by-block entry for the right block.
 		 */
 		if ((error = xfs_btree_delete(bno_cur, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		/*
 		 * Move the by-block cursor back to the left neighbor.
 		 */
 		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 #ifdef DEBUG
 		/*
 		 * Check that this is the right record: delete didn't
@@ -1956,9 +2030,11 @@ xfs_free_ag_extent(
 			if ((error = xfs_alloc_get_rec(bno_cur, &xxbno, &xxlen,
 					&i)))
 				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(mp,
-				i == 1 && xxbno == ltbno && xxlen == ltlen,
-				error0);
+			if (XFS_CORRUPT_ON(mp,
+			    i != 1 || xxbno != ltbno || xxlen != ltlen)) {
+				error = -EFSCORRUPTED;
+				goto error0;
+			}
 		}
 #endif
 		/*
@@ -1979,17 +2055,26 @@ xfs_free_ag_extent(
 		 */
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, ltbno, ltlen, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		/*
 		 * Back up the by-block cursor to the left neighbor, and
 		 * update its length.
 		 */
 		if ((error = xfs_btree_decrement(bno_cur, 0, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		nbno = ltbno;
 		nlen = len + ltlen;
 		if ((error = xfs_alloc_update(bno_cur, nbno, nlen)))
@@ -2005,10 +2090,16 @@ xfs_free_ag_extent(
 		 */
 		if ((error = xfs_alloc_lookup_eq(cnt_cur, gtbno, gtlen, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		if ((error = xfs_btree_delete(cnt_cur, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		/*
 		 * Update the starting block and length of the right
 		 * neighbor in the by-block tree.
@@ -2027,7 +2118,10 @@ xfs_free_ag_extent(
 		nlen = len;
 		if ((error = xfs_btree_insert(bno_cur, &i)))
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 	}
 	xfs_btree_del_cursor(bno_cur, XFS_BTREE_NOERROR);
 	bno_cur = NULL;
@@ -2036,10 +2130,16 @@ xfs_free_ag_extent(
 	 */
 	if ((error = xfs_alloc_lookup_eq(cnt_cur, nbno, nlen, &i)))
 		goto error0;
-	XFS_WANT_CORRUPTED_GOTO(mp, i == 0, error0);
+	if (XFS_CORRUPT_ON(mp, i != 0)) {
+		error = -EFSCORRUPTED;
+		goto error0;
+	}
 	if ((error = xfs_btree_insert(cnt_cur, &i)))
 		goto error0;
-	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto error0;
+	}
 	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
 	cnt_cur = NULL;
 
@@ -3164,12 +3264,17 @@ __xfs_free_extent(
 	if (error)
 		return error;
 
-	XFS_WANT_CORRUPTED_GOTO(mp, agbno < mp->m_sb.sb_agblocks, err);
+	if (XFS_CORRUPT_ON(mp, agbno >= mp->m_sb.sb_agblocks)) {
+		error = -EFSCORRUPTED;
+		goto err;
+	}
 
 	/* validate the extent size is legal now we have the agf locked */
-	XFS_WANT_CORRUPTED_GOTO(mp,
-		agbno + len <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length),
-				err);
+	if (XFS_CORRUPT_ON(mp,
+	    agbno + len > be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length))) {
+		error = -EFSCORRUPTED;
+		goto err;
+	}
 
 	error = xfs_free_ag_extent(tp, agbp, agno, agbno, len, oinfo, type);
 	if (error)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 64f623d07f82..3ef93db2da98 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -384,8 +384,10 @@ xfs_bmap_check_leaf_extents(
 		xfs_check_block(block, mp, 0, 0);
 		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
 		bno = be64_to_cpu(*pp);
-		XFS_WANT_CORRUPTED_GOTO(mp,
-					xfs_verify_fsbno(mp, bno), error0);
+		if (XFS_CORRUPT_ON(mp, !xfs_verify_fsbno(mp, bno))) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		if (bp_release) {
 			bp_release = 0;
 			xfs_trans_brelse(NULL, bp);
@@ -612,8 +614,8 @@ xfs_bmap_btree_to_extents(
 	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
 #ifdef DEBUG
-	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp,
-			xfs_btree_check_lptr(cur, cbno, 1));
+	if (XFS_CORRUPT_ON(cur->bc_mp, !xfs_btree_check_lptr(cur, cbno, 1)))
+		return -EFSCORRUPTED;
 #endif
 	error = xfs_btree_read_bufl(mp, tp, cbno, &cbp, XFS_BMAP_BTREE_REF,
 				&xfs_bmbt_buf_ops);
@@ -938,7 +940,10 @@ xfs_bmap_add_attrfork_btree(
 		if (error)
 			goto error0;
 		/* must be at least one entry */
-		XFS_WANT_CORRUPTED_GOTO(mp, stat == 1, error0);
+		if (XFS_CORRUPT_ON(mp, stat != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		if ((error = xfs_btree_new_iroot(cur, flags, &stat)))
 			goto error0;
 		if (stat == 0) {
@@ -1621,15 +1626,24 @@ xfs_bmap_add_extent_delay_real(
 			error = xfs_bmbt_lookup_eq(bma->cur, &RIGHT, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_btree_delete(bma->cur, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_btree_decrement(bma->cur, 0, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(bma->cur, &LEFT);
 			if (error)
 				goto done;
@@ -1655,7 +1669,10 @@ xfs_bmap_add_extent_delay_real(
 			error = xfs_bmbt_lookup_eq(bma->cur, &old, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(bma->cur, &LEFT);
 			if (error)
 				goto done;
@@ -1685,7 +1702,10 @@ xfs_bmap_add_extent_delay_real(
 			error = xfs_bmbt_lookup_eq(bma->cur, &RIGHT, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(bma->cur, &PREV);
 			if (error)
 				goto done;
@@ -1710,11 +1730,17 @@ xfs_bmap_add_extent_delay_real(
 			error = xfs_bmbt_lookup_eq(bma->cur, new, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
+			if (XFS_CORRUPT_ON(mp, i != 0)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 		}
 		break;
 
@@ -1745,7 +1771,10 @@ xfs_bmap_add_extent_delay_real(
 			error = xfs_bmbt_lookup_eq(bma->cur, &old, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(bma->cur, &LEFT);
 			if (error)
 				goto done;
@@ -1766,11 +1795,17 @@ xfs_bmap_add_extent_delay_real(
 			error = xfs_bmbt_lookup_eq(bma->cur, new, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
+			if (XFS_CORRUPT_ON(mp, i != 0)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 		}
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
@@ -1811,7 +1846,10 @@ xfs_bmap_add_extent_delay_real(
 			error = xfs_bmbt_lookup_eq(bma->cur, &old, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(bma->cur, &RIGHT);
 			if (error)
 				goto done;
@@ -1843,11 +1881,17 @@ xfs_bmap_add_extent_delay_real(
 			error = xfs_bmbt_lookup_eq(bma->cur, new, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
+			if (XFS_CORRUPT_ON(mp, i != 0)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 		}
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
@@ -1923,11 +1967,17 @@ xfs_bmap_add_extent_delay_real(
 			error = xfs_bmbt_lookup_eq(bma->cur, new, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
+			if (XFS_CORRUPT_ON(mp, i != 0)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_btree_insert(bma->cur, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 		}
 
 		if (xfs_bmap_needs_btree(bma->ip, whichfork)) {
@@ -2121,19 +2171,34 @@ xfs_bmap_add_extent_unwritten_real(
 			error = xfs_bmbt_lookup_eq(cur, &RIGHT, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(cur, &LEFT);
 			if (error)
 				goto done;
@@ -2159,13 +2224,22 @@ xfs_bmap_add_extent_unwritten_real(
 			error = xfs_bmbt_lookup_eq(cur, &PREV, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(cur, &LEFT);
 			if (error)
 				goto done;
@@ -2194,13 +2268,22 @@ xfs_bmap_add_extent_unwritten_real(
 			error = xfs_bmbt_lookup_eq(cur, &RIGHT, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			if ((error = xfs_btree_delete(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			if ((error = xfs_btree_decrement(cur, 0, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(cur, &PREV);
 			if (error)
 				goto done;
@@ -2223,7 +2306,10 @@ xfs_bmap_add_extent_unwritten_real(
 			error = xfs_bmbt_lookup_eq(cur, new, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(cur, &PREV);
 			if (error)
 				goto done;
@@ -2253,7 +2339,10 @@ xfs_bmap_add_extent_unwritten_real(
 			error = xfs_bmbt_lookup_eq(cur, &old, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(cur, &PREV);
 			if (error)
 				goto done;
@@ -2287,14 +2376,20 @@ xfs_bmap_add_extent_unwritten_real(
 			error = xfs_bmbt_lookup_eq(cur, &old, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(cur, &PREV);
 			if (error)
 				goto done;
 			cur->bc_rec.b = *new;
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 		}
 		break;
 
@@ -2321,7 +2416,10 @@ xfs_bmap_add_extent_unwritten_real(
 			error = xfs_bmbt_lookup_eq(cur, &old, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(cur, &PREV);
 			if (error)
 				goto done;
@@ -2355,17 +2453,26 @@ xfs_bmap_add_extent_unwritten_real(
 			error = xfs_bmbt_lookup_eq(cur, &old, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(cur, &PREV);
 			if (error)
 				goto done;
 			error = xfs_bmbt_lookup_eq(cur, new, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
+			if (XFS_CORRUPT_ON(mp, i != 0)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 		}
 		break;
 
@@ -2399,7 +2506,10 @@ xfs_bmap_add_extent_unwritten_real(
 			error = xfs_bmbt_lookup_eq(cur, &old, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			/* new right extent - oldext */
 			error = xfs_bmbt_update(cur, &r[1]);
 			if (error)
@@ -2408,7 +2518,10 @@ xfs_bmap_add_extent_unwritten_real(
 			cur->bc_rec.b = PREV;
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			/*
 			 * Reset the cursor to the position of the new extent
 			 * we are about to insert as we can't trust it after
@@ -2417,11 +2530,17 @@ xfs_bmap_add_extent_unwritten_real(
 			error = xfs_bmbt_lookup_eq(cur, new, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
+			if (XFS_CORRUPT_ON(mp, i != 0)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			/* new middle extent - newext */
 			if ((error = xfs_btree_insert(cur, &i)))
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 		}
 		break;
 
@@ -2704,15 +2823,24 @@ xfs_bmap_add_extent_hole_real(
 			error = xfs_bmbt_lookup_eq(cur, &right, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_btree_delete(cur, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_btree_decrement(cur, 0, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(cur, &left);
 			if (error)
 				goto done;
@@ -2738,7 +2866,10 @@ xfs_bmap_add_extent_hole_real(
 			error = xfs_bmbt_lookup_eq(cur, &old, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(cur, &left);
 			if (error)
 				goto done;
@@ -2765,7 +2896,10 @@ xfs_bmap_add_extent_hole_real(
 			error = xfs_bmbt_lookup_eq(cur, &old, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_bmbt_update(cur, &right);
 			if (error)
 				goto done;
@@ -2788,11 +2922,17 @@ xfs_bmap_add_extent_hole_real(
 			error = xfs_bmbt_lookup_eq(cur, new, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
+			if (XFS_CORRUPT_ON(mp, i != 0)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 			error = xfs_btree_insert(cur, &i);
 			if (error)
 				goto done;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 		}
 		break;
 	}
@@ -4984,7 +5124,10 @@ xfs_bmap_del_extent_real(
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 	}
 
 	if (got.br_startoff == del->br_startoff)
@@ -5008,7 +5151,10 @@ xfs_bmap_del_extent_real(
 		}
 		if ((error = xfs_btree_delete(cur, &i)))
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		break;
 	case BMAP_LEFT_FILLING:
 		/*
@@ -5079,7 +5225,10 @@ xfs_bmap_del_extent_real(
 				error = xfs_bmbt_lookup_eq(cur, &got, &i);
 				if (error)
 					goto done;
-				XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+				if (XFS_CORRUPT_ON(mp, i != 1)) {
+					error = -EFSCORRUPTED;
+					goto done;
+				}
 				/*
 				 * Update the btree record back
 				 * to the original value.
@@ -5096,7 +5245,10 @@ xfs_bmap_del_extent_real(
 				error = -ENOSPC;
 				goto done;
 			}
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto done;
+			}
 		} else
 			flags |= xfs_ilog_fext(whichfork);
 		XFS_IFORK_NEXT_SET(ip, whichfork,
@@ -5581,18 +5733,21 @@ xfs_bmse_merge(
 	error = xfs_bmbt_lookup_eq(cur, got, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
+	if (XFS_CORRUPT_ON(mp, i != 1))
+		return -EFSCORRUPTED;
 
 	error = xfs_btree_delete(cur, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
+	if (XFS_CORRUPT_ON(mp, i != 1))
+		return -EFSCORRUPTED;
 
 	/* lookup and update size of the previous extent */
 	error = xfs_bmbt_lookup_eq(cur, left, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
+	if (XFS_CORRUPT_ON(mp, i != 1))
+		return -EFSCORRUPTED;
 
 	error = xfs_bmbt_update(cur, &new);
 	if (error)
@@ -5640,7 +5795,8 @@ xfs_bmap_shift_update_extent(
 		error = xfs_bmbt_lookup_eq(cur, &prev, &i);
 		if (error)
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(mp, i == 1);
+		if (XFS_CORRUPT_ON(mp, i != 1))
+			return -EFSCORRUPTED;
 
 		error = xfs_bmbt_update(cur, got);
 		if (error)
@@ -5704,8 +5860,10 @@ xfs_bmap_collapse_extents(
 		*done = true;
 		goto del_cursor;
 	}
-	XFS_WANT_CORRUPTED_GOTO(mp, !isnullstartblock(got.br_startblock),
-				del_cursor);
+	if (XFS_CORRUPT_ON(mp, isnullstartblock(got.br_startblock))) {
+		error = -EFSCORRUPTED;
+		goto del_cursor;
+	}
 
 	new_startoff = got.br_startoff - offset_shift_fsb;
 	if (xfs_iext_peek_prev_extent(ifp, &icur, &prev)) {
@@ -5831,8 +5989,10 @@ xfs_bmap_insert_extents(
 			goto del_cursor;
 		}
 	}
-	XFS_WANT_CORRUPTED_GOTO(mp, !isnullstartblock(got.br_startblock),
-				del_cursor);
+	if (XFS_CORRUPT_ON(mp, isnullstartblock(got.br_startblock))) {
+		error = -EFSCORRUPTED;
+		goto del_cursor;
+	}
 
 	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
 		ASSERT(0);
@@ -5940,7 +6100,10 @@ xfs_bmap_split_extent_at(
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
 			goto del_cursor;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, del_cursor);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto del_cursor;
+		}
 	}
 
 	got.br_blockcount = gotblkcnt;
@@ -5965,11 +6128,17 @@ xfs_bmap_split_extent_at(
 		error = xfs_bmbt_lookup_eq(cur, &new, &i);
 		if (error)
 			goto del_cursor;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 0, del_cursor);
+		if (XFS_CORRUPT_ON(mp, i != 0)) {
+			error = -EFSCORRUPTED;
+			goto del_cursor;
+		}
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto del_cursor;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, del_cursor);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto del_cursor;
+		}
 	}
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 98843f1258b8..629703350652 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1990,7 +1990,8 @@ xfs_btree_lookup(
 			error = xfs_btree_increment(cur, 0, &i);
 			if (error)
 				goto error0;
-			XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
+			if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+				return -EFSCORRUPTED;
 			*stat = 1;
 			return 0;
 		}
@@ -2445,7 +2446,10 @@ xfs_btree_lshift(
 		if (error)
 			goto error0;
 		i = xfs_btree_firstrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(tcur->bc_mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(tcur->bc_mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
 		if (error)
@@ -2612,7 +2616,10 @@ xfs_btree_rshift(
 	if (error)
 		goto error0;
 	i = xfs_btree_lastrec(tcur, level);
-	XFS_WANT_CORRUPTED_GOTO(tcur->bc_mp, i == 1, error0);
+	if (XFS_CORRUPT_ON(tcur->bc_mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto error0;
+	}
 
 	error = xfs_btree_increment(tcur, level, &i);
 	if (error)
@@ -3466,7 +3473,10 @@ xfs_btree_insert(
 			goto error0;
 		}
 
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		level++;
 
 		/*
@@ -3870,15 +3880,24 @@ xfs_btree_delrec(
 		 * Actually any entry but the first would suffice.
 		 */
 		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 
 		error = xfs_btree_increment(tcur, level, &i);
 		if (error)
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 
 		i = xfs_btree_lastrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 
 		/* Grab a pointer to the block. */
 		right = xfs_btree_get_block(tcur, level, &rbp);
@@ -3922,12 +3941,18 @@ xfs_btree_delrec(
 		rrecs = xfs_btree_get_numrecs(right);
 		if (!xfs_btree_ptr_is_null(cur, &lptr)) {
 			i = xfs_btree_firstrec(tcur, level);
-			XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
+			if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto error0;
+			}
 
 			error = xfs_btree_decrement(tcur, level, &i);
 			if (error)
 				goto error0;
-			XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
+			if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto error0;
+			}
 		}
 	}
 
@@ -3941,13 +3966,19 @@ xfs_btree_delrec(
 		 * previous block.
 		 */
 		i = xfs_btree_firstrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 
 		error = xfs_btree_decrement(tcur, level, &i);
 		if (error)
 			goto error0;
 		i = xfs_btree_firstrec(tcur, level);
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 
 		/* Grab a pointer to the block. */
 		left = xfs_btree_get_block(tcur, level, &lbp);
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 588d44613094..9232d9a03ebb 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -544,7 +544,10 @@ xfs_inobt_insert_sprec(
 					     nrec->ir_free, &i);
 		if (error)
 			goto error;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error;
+		}
 
 		goto out;
 	}
@@ -557,17 +560,23 @@ xfs_inobt_insert_sprec(
 		error = xfs_inobt_get_rec(cur, &rec, &i);
 		if (error)
 			goto error;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error);
-		XFS_WANT_CORRUPTED_GOTO(mp,
-					rec.ir_startino == nrec->ir_startino,
-					error);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error;
+		}
+		if (XFS_CORRUPT_ON(mp, rec.ir_startino != nrec->ir_startino)) {
+			error = -EFSCORRUPTED;
+			goto error;
+		}
 
 		/*
 		 * This should never fail. If we have coexisting records that
 		 * cannot merge, something is seriously wrong.
 		 */
-		XFS_WANT_CORRUPTED_GOTO(mp, __xfs_inobt_can_merge(nrec, &rec),
-					error);
+		if (XFS_CORRUPT_ON(mp, !__xfs_inobt_can_merge(nrec, &rec))) {
+			error = -EFSCORRUPTED;
+			goto error;
+		}
 
 		trace_xfs_irec_merge_pre(mp, agno, rec.ir_startino,
 					 rec.ir_holemask, nrec->ir_startino,
@@ -1057,7 +1066,8 @@ xfs_ialloc_next_rec(
 		error = xfs_inobt_get_rec(cur, rec, &i);
 		if (error)
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
+		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+			return -EFSCORRUPTED;
 	}
 
 	return 0;
@@ -1081,7 +1091,8 @@ xfs_ialloc_get_rec(
 		error = xfs_inobt_get_rec(cur, rec, &i);
 		if (error)
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
+		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+			return -EFSCORRUPTED;
 	}
 
 	return 0;
@@ -1161,12 +1172,18 @@ xfs_dialloc_ag_inobt(
 		error = xfs_inobt_lookup(cur, pagino, XFS_LOOKUP_LE, &i);
 		if (error)
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 
 		error = xfs_inobt_get_rec(cur, &rec, &j);
 		if (error)
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, j == 1, error0);
+		if (XFS_CORRUPT_ON(mp, j != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 
 		if (rec.ir_freecount > 0) {
 			/*
@@ -1321,19 +1338,28 @@ xfs_dialloc_ag_inobt(
 	error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
 	if (error)
 		goto error0;
-	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto error0;
+	}
 
 	for (;;) {
 		error = xfs_inobt_get_rec(cur, &rec, &i);
 		if (error)
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 		if (rec.ir_freecount > 0)
 			break;
 		error = xfs_btree_increment(cur, 0, &i);
 		if (error)
 			goto error0;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto error0;
+		}
 	}
 
 alloc_inode:
@@ -1393,7 +1419,8 @@ xfs_dialloc_ag_finobt_near(
 		error = xfs_inobt_get_rec(lcur, rec, &i);
 		if (error)
 			return error;
-		XFS_WANT_CORRUPTED_RETURN(lcur->bc_mp, i == 1);
+		if (XFS_CORRUPT_ON(lcur->bc_mp, i != 1))
+			return -EFSCORRUPTED;
 
 		/*
 		 * See if we've landed in the parent inode record. The finobt
@@ -1416,10 +1443,16 @@ xfs_dialloc_ag_finobt_near(
 		error = xfs_inobt_get_rec(rcur, &rrec, &j);
 		if (error)
 			goto error_rcur;
-		XFS_WANT_CORRUPTED_GOTO(lcur->bc_mp, j == 1, error_rcur);
+		if (XFS_CORRUPT_ON(lcur->bc_mp, j != 1)) {
+			error = -EFSCORRUPTED;
+			goto error_rcur;
+		}
 	}
 
-	XFS_WANT_CORRUPTED_GOTO(lcur->bc_mp, i == 1 || j == 1, error_rcur);
+	if (XFS_CORRUPT_ON(lcur->bc_mp, i != 1 && j != 1)) {
+		error = -EFSCORRUPTED;
+		goto error_rcur;
+	}
 	if (i == 1 && j == 1) {
 		/*
 		 * Both the left and right records are valid. Choose the closer
@@ -1472,7 +1505,8 @@ xfs_dialloc_ag_finobt_newino(
 			error = xfs_inobt_get_rec(cur, rec, &i);
 			if (error)
 				return error;
-			XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
+			if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+				return -EFSCORRUPTED;
 			return 0;
 		}
 	}
@@ -1483,12 +1517,14 @@ xfs_dialloc_ag_finobt_newino(
 	error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
+	if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+		return -EFSCORRUPTED;
 
 	error = xfs_inobt_get_rec(cur, rec, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
+	if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+		return -EFSCORRUPTED;
 
 	return 0;
 }
@@ -1510,20 +1546,24 @@ xfs_dialloc_ag_update_inobt(
 	error = xfs_inobt_lookup(cur, frec->ir_startino, XFS_LOOKUP_EQ, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
+	if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+		return -EFSCORRUPTED;
 
 	error = xfs_inobt_get_rec(cur, &rec, &i);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, i == 1);
+	if (XFS_CORRUPT_ON(cur->bc_mp, i != 1))
+		return -EFSCORRUPTED;
 	ASSERT((XFS_AGINO_TO_OFFSET(cur->bc_mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
 
 	rec.ir_free &= ~XFS_INOBT_MASK(offset);
 	rec.ir_freecount--;
 
-	XFS_WANT_CORRUPTED_RETURN(cur->bc_mp, (rec.ir_free == frec->ir_free) &&
-				  (rec.ir_freecount == frec->ir_freecount));
+	if (XFS_CORRUPT_ON(cur->bc_mp,
+	    rec.ir_free != frec->ir_free ||
+	    rec.ir_freecount != frec->ir_freecount))
+		return -EFSCORRUPTED;
 
 	return xfs_inobt_update(cur, &rec);
 }
@@ -1933,14 +1973,20 @@ xfs_difree_inobt(
 			__func__, error);
 		goto error0;
 	}
-	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto error0;
+	}
 	error = xfs_inobt_get_rec(cur, &rec, &i);
 	if (error) {
 		xfs_warn(mp, "%s: xfs_inobt_get_rec() returned error %d.",
 			__func__, error);
 		goto error0;
 	}
-	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto error0;
+	}
 	/*
 	 * Get the offset in the inode chunk.
 	 */
@@ -2052,7 +2098,10 @@ xfs_difree_finobt(
 		 * freed an inode in a previously fully allocated chunk. If not,
 		 * something is out of sync.
 		 */
-		XFS_WANT_CORRUPTED_GOTO(mp, ibtrec->ir_freecount == 1, error);
+		if (XFS_CORRUPT_ON(mp, ibtrec->ir_freecount != 1)) {
+			error = -EFSCORRUPTED;
+			goto error;
+		}
 
 		error = xfs_inobt_insert_rec(cur, ibtrec->ir_holemask,
 					     ibtrec->ir_count,
@@ -2075,14 +2124,20 @@ xfs_difree_finobt(
 	error = xfs_inobt_get_rec(cur, &rec, &i);
 	if (error)
 		goto error;
-	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error);
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto error;
+	}
 
 	rec.ir_free |= XFS_INOBT_MASK(offset);
 	rec.ir_freecount++;
 
-	XFS_WANT_CORRUPTED_GOTO(mp, (rec.ir_free == ibtrec->ir_free) &&
-				(rec.ir_freecount == ibtrec->ir_freecount),
-				error);
+	if (XFS_CORRUPT_ON(mp,
+	    rec.ir_free != ibtrec->ir_free ||
+	    rec.ir_freecount != ibtrec->ir_freecount)) {
+		error = -EFSCORRUPTED;
+		goto error;
+	}
 
 	/*
 	 * The content of inobt records should always match between the inobt
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 78236bd6c64f..de6620ad5001 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -200,7 +200,10 @@ xfs_refcount_insert(
 	error = xfs_btree_insert(cur, i);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, *i == 1, out_error);
+	if (XFS_CORRUPT_ON(cur->bc_mp, *i != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 out_error:
 	if (error)
@@ -227,10 +230,16 @@ xfs_refcount_delete(
 	error = xfs_refcount_get_rec(cur, &irec, &found_rec);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_private.a.agno, &irec);
 	error = xfs_btree_delete(cur, i);
-	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, *i == 1, out_error);
+	if (XFS_CORRUPT_ON(cur->bc_mp, *i != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 	if (error)
 		goto out_error;
 	error = xfs_refcount_lookup_ge(cur, irec.rc_startblock, &found_rec);
@@ -349,7 +358,10 @@ xfs_refcount_split_extent(
 	error = xfs_refcount_get_rec(cur, &rcext, &found_rec);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 	if (rcext.rc_startblock == agbno || xfs_refc_next(&rcext) <= agbno)
 		return 0;
 
@@ -371,7 +383,10 @@ xfs_refcount_split_extent(
 	error = xfs_refcount_insert(cur, &tmp, &found_rec);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 	return error;
 
 out_error:
@@ -410,19 +425,27 @@ xfs_refcount_merge_center_extents(
 			&found_rec);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	error = xfs_refcount_delete(cur, &found_rec);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	if (center->rc_refcount > 1) {
 		error = xfs_refcount_delete(cur, &found_rec);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
-				out_error);
+		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 	}
 
 	/* Enlarge the left extent. */
@@ -430,7 +453,10 @@ xfs_refcount_merge_center_extents(
 			&found_rec);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	left->rc_blockcount = extlen;
 	error = xfs_refcount_update(cur, left);
@@ -469,14 +495,18 @@ xfs_refcount_merge_left_extent(
 				&found_rec);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
-				out_error);
+		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 
 		error = xfs_refcount_delete(cur, &found_rec);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
-				out_error);
+		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 	}
 
 	/* Enlarge the left extent. */
@@ -484,7 +514,10 @@ xfs_refcount_merge_left_extent(
 			&found_rec);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	left->rc_blockcount += cleft->rc_blockcount;
 	error = xfs_refcount_update(cur, left);
@@ -526,14 +559,18 @@ xfs_refcount_merge_right_extent(
 			&found_rec);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
-				out_error);
+		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 
 		error = xfs_refcount_delete(cur, &found_rec);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
-				out_error);
+		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 	}
 
 	/* Enlarge the right extent. */
@@ -541,7 +578,10 @@ xfs_refcount_merge_right_extent(
 			&found_rec);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	right->rc_startblock -= cright->rc_blockcount;
 	right->rc_blockcount += cright->rc_blockcount;
@@ -587,7 +627,10 @@ xfs_refcount_find_left_extents(
 	error = xfs_refcount_get_rec(cur, &tmp, &found_rec);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	if (xfs_refc_next(&tmp) != agbno)
 		return 0;
@@ -605,8 +648,10 @@ xfs_refcount_find_left_extents(
 		error = xfs_refcount_get_rec(cur, &tmp, &found_rec);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
-				out_error);
+		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 
 		/* if tmp starts at the end of our range, just use that */
 		if (tmp.rc_startblock == agbno)
@@ -671,7 +716,10 @@ xfs_refcount_find_right_extents(
 	error = xfs_refcount_get_rec(cur, &tmp, &found_rec);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	if (tmp.rc_startblock != agbno + aglen)
 		return 0;
@@ -689,8 +737,10 @@ xfs_refcount_find_right_extents(
 		error = xfs_refcount_get_rec(cur, &tmp, &found_rec);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
-				out_error);
+		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 
 		/* if tmp ends at the end of our range, just use that */
 		if (xfs_refc_next(&tmp) == agbno + aglen)
@@ -913,8 +963,11 @@ xfs_refcount_adjust_extents(
 						&found_tmp);
 				if (error)
 					goto out_error;
-				XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
-						found_tmp == 1, out_error);
+				if (XFS_CORRUPT_ON(cur->bc_mp,
+						   found_tmp != 1)) {
+					error = -EFSCORRUPTED;
+					goto out_error;
+				}
 				cur->bc_private.a.priv.refc.nr_ops++;
 			} else {
 				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
@@ -955,8 +1008,10 @@ xfs_refcount_adjust_extents(
 			error = xfs_refcount_delete(cur, &found_rec);
 			if (error)
 				goto out_error;
-			XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
-					found_rec == 1, out_error);
+			if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+				error = -EFSCORRUPTED;
+				goto out_error;
+			}
 			cur->bc_private.a.priv.refc.nr_ops++;
 			goto advloop;
 		} else {
@@ -1272,7 +1327,10 @@ xfs_refcount_find_shared(
 	error = xfs_refcount_get_rec(cur, &tmp, &i);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, out_error);
+	if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	/* If the extent ends before the start, look at the next one */
 	if (tmp.rc_startblock + tmp.rc_blockcount <= agbno) {
@@ -1284,7 +1342,10 @@ xfs_refcount_find_shared(
 		error = xfs_refcount_get_rec(cur, &tmp, &i);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, out_error);
+		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 	}
 
 	/* If the extent starts after the range we want, bail out */
@@ -1312,7 +1373,10 @@ xfs_refcount_find_shared(
 		error = xfs_refcount_get_rec(cur, &tmp, &i);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, i == 1, out_error);
+		if (XFS_CORRUPT_ON(cur->bc_mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 		if (tmp.rc_startblock >= agbno + aglen ||
 		    tmp.rc_startblock != *fbno + *flen)
 			break;
@@ -1413,8 +1477,11 @@ xfs_refcount_adjust_cow_extents(
 	switch (adj) {
 	case XFS_REFCOUNT_ADJUST_COW_ALLOC:
 		/* Adding a CoW reservation, there should be nothing here. */
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
-				ext.rc_startblock >= agbno + aglen, out_error);
+		if (XFS_CORRUPT_ON(cur->bc_mp,
+		    agbno + aglen > ext.rc_startblock)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 
 		tmp.rc_startblock = agbno;
 		tmp.rc_blockcount = aglen;
@@ -1426,17 +1493,25 @@ xfs_refcount_adjust_cow_extents(
 				&found_tmp);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
-				found_tmp == 1, out_error);
+		if (XFS_CORRUPT_ON(cur->bc_mp, found_tmp != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 		break;
 	case XFS_REFCOUNT_ADJUST_COW_FREE:
 		/* Removing a CoW reservation, there should be one extent. */
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
-			ext.rc_startblock == agbno, out_error);
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
-			ext.rc_blockcount == aglen, out_error);
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
-			ext.rc_refcount == 1, out_error);
+		if (XFS_CORRUPT_ON(cur->bc_mp, ext.rc_startblock != agbno)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
+		if (XFS_CORRUPT_ON(cur->bc_mp, ext.rc_blockcount != aglen)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
+		if (XFS_CORRUPT_ON(cur->bc_mp, ext.rc_refcount != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 
 		ext.rc_refcount = 0;
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
@@ -1444,8 +1519,10 @@ xfs_refcount_adjust_cow_extents(
 		error = xfs_refcount_delete(cur, &found_rec);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
-				found_rec == 1, out_error);
+		if (XFS_CORRUPT_ON(cur->bc_mp, found_rec != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 		break;
 	default:
 		ASSERT(0);
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 38e9414878b3..a2b2b762adf2 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -113,7 +113,10 @@ xfs_rmap_insert(
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
 	if (error)
 		goto done;
-	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 0, done);
+	if (XFS_CORRUPT_ON(rcur->bc_mp, i != 0)) {
+		error = -EFSCORRUPTED;
+		goto done;
+	}
 
 	rcur->bc_rec.r.rm_startblock = agbno;
 	rcur->bc_rec.r.rm_blockcount = len;
@@ -123,7 +126,10 @@ xfs_rmap_insert(
 	error = xfs_btree_insert(rcur, &i);
 	if (error)
 		goto done;
-	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+	if (XFS_CORRUPT_ON(rcur->bc_mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto done;
+	}
 done:
 	if (error)
 		trace_xfs_rmap_insert_error(rcur->bc_mp,
@@ -149,12 +155,18 @@ xfs_rmap_delete(
 	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, flags, &i);
 	if (error)
 		goto done;
-	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+	if (XFS_CORRUPT_ON(rcur->bc_mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto done;
+	}
 
 	error = xfs_btree_delete(rcur, &i);
 	if (error)
 		goto done;
-	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+	if (XFS_CORRUPT_ON(rcur->bc_mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto done;
+	}
 done:
 	if (error)
 		trace_xfs_rmap_delete_error(rcur->bc_mp,
@@ -406,24 +418,39 @@ xfs_rmap_free_check_owner(
 		return 0;
 
 	/* Make sure the unwritten flag matches. */
-	XFS_WANT_CORRUPTED_GOTO(mp, (flags & XFS_RMAP_UNWRITTEN) ==
-			(rec->rm_flags & XFS_RMAP_UNWRITTEN), out);
+	if (XFS_CORRUPT_ON(mp,
+	    (flags & XFS_RMAP_UNWRITTEN) !=
+	    (rec->rm_flags & XFS_RMAP_UNWRITTEN))) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
 
 	/* Make sure the owner matches what we expect to find in the tree. */
-	XFS_WANT_CORRUPTED_GOTO(mp, owner == rec->rm_owner, out);
+	if (XFS_CORRUPT_ON(mp, owner != rec->rm_owner)) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
 
 	/* Check the offset, if necessary. */
 	if (XFS_RMAP_NON_INODE_OWNER(owner))
 		goto out;
 
 	if (flags & XFS_RMAP_BMBT_BLOCK) {
-		XFS_WANT_CORRUPTED_GOTO(mp, rec->rm_flags & XFS_RMAP_BMBT_BLOCK,
-				out);
+		if (XFS_CORRUPT_ON(mp,
+		    !(rec->rm_flags & XFS_RMAP_BMBT_BLOCK))) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
 	} else {
-		XFS_WANT_CORRUPTED_GOTO(mp, rec->rm_offset <= offset, out);
-		XFS_WANT_CORRUPTED_GOTO(mp,
-				ltoff + rec->rm_blockcount >= offset + len,
-				out);
+		if (XFS_CORRUPT_ON(mp, rec->rm_offset > offset)) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
+		if (XFS_CORRUPT_ON(mp,
+		    offset + len > ltoff + rec->rm_blockcount)) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
 	}
 
 out:
@@ -482,12 +509,18 @@ xfs_rmap_unmap(
 	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, flags, &i);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	error = xfs_rmap_get_rec(cur, &ltrec, &i);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
 			cur->bc_private.a.agno, ltrec.rm_startblock,
 			ltrec.rm_blockcount, ltrec.rm_owner,
@@ -502,8 +535,11 @@ xfs_rmap_unmap(
 	 * be the case that the "left" extent goes all the way to EOFS.
 	 */
 	if (owner == XFS_RMAP_OWN_NULL) {
-		XFS_WANT_CORRUPTED_GOTO(mp, bno >= ltrec.rm_startblock +
-						ltrec.rm_blockcount, out_error);
+		if (XFS_CORRUPT_ON(mp,
+		    bno < ltrec.rm_startblock + ltrec.rm_blockcount)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 		goto out_done;
 	}
 
@@ -526,15 +562,21 @@ xfs_rmap_unmap(
 		error = xfs_rmap_get_rec(cur, &rtrec, &i);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 		if (rtrec.rm_startblock >= bno + len)
 			goto out_done;
 	}
 
 	/* Make sure the extent we found covers the entire freeing range. */
-	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno &&
-			ltrec.rm_startblock + ltrec.rm_blockcount >=
-			bno + len, out_error);
+	if (XFS_CORRUPT_ON(mp,
+	    ltrec.rm_startblock > bno ||
+	    ltrec.rm_startblock + ltrec.rm_blockcount < bno + len)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	/* Check owner information. */
 	error = xfs_rmap_free_check_owner(mp, ltoff, &ltrec, len, owner,
@@ -551,7 +593,10 @@ xfs_rmap_unmap(
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 	} else if (ltrec.rm_startblock == bno) {
 		/*
 		 * overlap left hand side of extent: move the start, trim the
@@ -743,7 +788,10 @@ xfs_rmap_map(
 		error = xfs_rmap_get_rec(cur, &ltrec, &have_lt);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(mp, have_lt == 1, out_error);
+		if (XFS_CORRUPT_ON(mp, have_lt != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 		trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
 				cur->bc_private.a.agno, ltrec.rm_startblock,
 				ltrec.rm_blockcount, ltrec.rm_owner,
@@ -753,9 +801,11 @@ xfs_rmap_map(
 			have_lt = 0;
 	}
 
-	XFS_WANT_CORRUPTED_GOTO(mp,
-		have_lt == 0 ||
-		ltrec.rm_startblock + ltrec.rm_blockcount <= bno, out_error);
+	if (XFS_CORRUPT_ON(mp,
+	    have_lt != 0 && ltrec.rm_startblock + ltrec.rm_blockcount > bno)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	/*
 	 * Increment the cursor to see if we have a right-adjacent record to our
@@ -769,9 +819,14 @@ xfs_rmap_map(
 		error = xfs_rmap_get_rec(cur, &gtrec, &have_gt);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 1, out_error);
-		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= gtrec.rm_startblock,
-					out_error);
+		if (XFS_CORRUPT_ON(mp, have_gt != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
+		if (XFS_CORRUPT_ON(mp, bno + len > gtrec.rm_startblock)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
 			cur->bc_private.a.agno, gtrec.rm_startblock,
 			gtrec.rm_blockcount, gtrec.rm_owner,
@@ -821,7 +876,10 @@ xfs_rmap_map(
 			error = xfs_btree_delete(cur, &i);
 			if (error)
 				goto out_error;
-			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+			if (XFS_CORRUPT_ON(mp, i != 1)) {
+				error = -EFSCORRUPTED;
+				goto out_error;
+			}
 		}
 
 		/* point the cursor back to the left record and update */
@@ -865,7 +923,10 @@ xfs_rmap_map(
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 	}
 
 	trace_xfs_rmap_map_done(mp, cur->bc_private.a.agno, bno, len,
@@ -957,12 +1018,18 @@ xfs_rmap_convert(
 	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, oldext, &i);
 	if (error)
 		goto done;
-	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto done;
+	}
 
 	error = xfs_rmap_get_rec(cur, &PREV, &i);
 	if (error)
 		goto done;
-	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto done;
+	}
 	trace_xfs_rmap_lookup_le_range_result(cur->bc_mp,
 			cur->bc_private.a.agno, PREV.rm_startblock,
 			PREV.rm_blockcount, PREV.rm_owner,
@@ -995,10 +1062,15 @@ xfs_rmap_convert(
 		error = xfs_rmap_get_rec(cur, &LEFT, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-		XFS_WANT_CORRUPTED_GOTO(mp,
-				LEFT.rm_startblock + LEFT.rm_blockcount <= bno,
-				done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
+		if (XFS_CORRUPT_ON(mp,
+		    LEFT.rm_startblock + LEFT.rm_blockcount > bno)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		trace_xfs_rmap_find_left_neighbor_result(cur->bc_mp,
 				cur->bc_private.a.agno, LEFT.rm_startblock,
 				LEFT.rm_blockcount, LEFT.rm_owner,
@@ -1017,7 +1089,10 @@ xfs_rmap_convert(
 	error = xfs_btree_increment(cur, 0, &i);
 	if (error)
 		goto done;
-	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto done;
+	}
 	error = xfs_btree_increment(cur, 0, &i);
 	if (error)
 		goto done;
@@ -1026,9 +1101,14 @@ xfs_rmap_convert(
 		error = xfs_rmap_get_rec(cur, &RIGHT, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= RIGHT.rm_startblock,
-					done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
+		if (XFS_CORRUPT_ON(mp, bno + len > RIGHT.rm_startblock)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
 				cur->bc_private.a.agno, RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
@@ -1055,7 +1135,10 @@ xfs_rmap_convert(
 	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, oldext, &i);
 	if (error)
 		goto done;
-	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto done;
+	}
 
 	/*
 	 * Switch out based on the FILLING and CONTIG state bits.
@@ -1071,7 +1154,10 @@ xfs_rmap_convert(
 		error = xfs_btree_increment(cur, 0, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
 				RIGHT.rm_startblock, RIGHT.rm_blockcount,
 				RIGHT.rm_owner, RIGHT.rm_offset,
@@ -1079,11 +1165,17 @@ xfs_rmap_convert(
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
 				PREV.rm_startblock, PREV.rm_blockcount,
 				PREV.rm_owner, PREV.rm_offset,
@@ -1091,11 +1183,17 @@ xfs_rmap_convert(
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		NEW = LEFT;
 		NEW.rm_blockcount += PREV.rm_blockcount + RIGHT.rm_blockcount;
 		error = xfs_rmap_update(cur, &NEW);
@@ -1115,11 +1213,17 @@ xfs_rmap_convert(
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		NEW = LEFT;
 		NEW.rm_blockcount += PREV.rm_blockcount;
 		error = xfs_rmap_update(cur, &NEW);
@@ -1135,7 +1239,10 @@ xfs_rmap_convert(
 		error = xfs_btree_increment(cur, 0, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		trace_xfs_rmap_delete(mp, cur->bc_private.a.agno,
 				RIGHT.rm_startblock, RIGHT.rm_blockcount,
 				RIGHT.rm_owner, RIGHT.rm_offset,
@@ -1143,11 +1250,17 @@ xfs_rmap_convert(
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		error = xfs_btree_decrement(cur, 0, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		NEW = PREV;
 		NEW.rm_blockcount = len + RIGHT.rm_blockcount;
 		NEW.rm_flags = newext;
@@ -1214,7 +1327,10 @@ xfs_rmap_convert(
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		break;
 
 	case RMAP_RIGHT_FILLING | RMAP_RIGHT_CONTIG:
@@ -1253,7 +1369,10 @@ xfs_rmap_convert(
 				oldext, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
+		if (XFS_CORRUPT_ON(mp, i != 0)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		NEW.rm_startblock = bno;
 		NEW.rm_owner = owner;
 		NEW.rm_offset = offset;
@@ -1265,7 +1384,10 @@ xfs_rmap_convert(
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		break;
 
 	case 0:
@@ -1295,7 +1417,10 @@ xfs_rmap_convert(
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		/*
 		 * Reset the cursor to the position of the new extent
 		 * we are about to insert as we can't trust it after
@@ -1305,7 +1430,10 @@ xfs_rmap_convert(
 				oldext, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 0, done);
+		if (XFS_CORRUPT_ON(mp, i != 0)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		/* new middle extent - newext */
 		cur->bc_rec.r.rm_flags &= ~XFS_RMAP_UNWRITTEN;
 		cur->bc_rec.r.rm_flags |= newext;
@@ -1314,7 +1442,10 @@ xfs_rmap_convert(
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		break;
 
 	case RMAP_LEFT_FILLING | RMAP_LEFT_CONTIG | RMAP_RIGHT_CONTIG:
@@ -1383,7 +1514,10 @@ xfs_rmap_convert_shared(
 			&PREV, &i);
 	if (error)
 		goto done;
-	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto done;
+	}
 
 	ASSERT(PREV.rm_offset <= offset);
 	ASSERT(PREV.rm_offset + PREV.rm_blockcount >= new_endoff);
@@ -1406,9 +1540,11 @@ xfs_rmap_convert_shared(
 		goto done;
 	if (i) {
 		state |= RMAP_LEFT_VALID;
-		XFS_WANT_CORRUPTED_GOTO(mp,
-				LEFT.rm_startblock + LEFT.rm_blockcount <= bno,
-				done);
+		if (XFS_CORRUPT_ON(mp,
+		    LEFT.rm_startblock + LEFT.rm_blockcount > bno)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		if (xfs_rmap_is_mergeable(&LEFT, owner, newext))
 			state |= RMAP_LEFT_CONTIG;
 	}
@@ -1423,9 +1559,14 @@ xfs_rmap_convert_shared(
 		error = xfs_rmap_get_rec(cur, &RIGHT, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
-		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= RIGHT.rm_startblock,
-				done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
+		if (XFS_CORRUPT_ON(mp, bno + len > RIGHT.rm_startblock)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
 				cur->bc_private.a.agno, RIGHT.rm_startblock,
 				RIGHT.rm_blockcount, RIGHT.rm_owner,
@@ -1472,7 +1613,10 @@ xfs_rmap_convert_shared(
 				NEW.rm_offset, NEW.rm_flags, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		NEW.rm_blockcount += PREV.rm_blockcount + RIGHT.rm_blockcount;
 		error = xfs_rmap_update(cur, &NEW);
 		if (error)
@@ -1495,7 +1639,10 @@ xfs_rmap_convert_shared(
 				NEW.rm_offset, NEW.rm_flags, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		NEW.rm_blockcount += PREV.rm_blockcount;
 		error = xfs_rmap_update(cur, &NEW);
 		if (error)
@@ -1518,7 +1665,10 @@ xfs_rmap_convert_shared(
 				NEW.rm_offset, NEW.rm_flags, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		NEW.rm_blockcount += RIGHT.rm_blockcount;
 		NEW.rm_flags = RIGHT.rm_flags;
 		error = xfs_rmap_update(cur, &NEW);
@@ -1538,7 +1688,10 @@ xfs_rmap_convert_shared(
 				NEW.rm_offset, NEW.rm_flags, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		NEW.rm_flags = newext;
 		error = xfs_rmap_update(cur, &NEW);
 		if (error)
@@ -1570,7 +1723,10 @@ xfs_rmap_convert_shared(
 				NEW.rm_offset, NEW.rm_flags, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		NEW.rm_blockcount += len;
 		error = xfs_rmap_update(cur, &NEW);
 		if (error)
@@ -1612,7 +1768,10 @@ xfs_rmap_convert_shared(
 				NEW.rm_offset, NEW.rm_flags, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		NEW.rm_blockcount = offset - NEW.rm_offset;
 		error = xfs_rmap_update(cur, &NEW);
 		if (error)
@@ -1644,7 +1803,10 @@ xfs_rmap_convert_shared(
 				NEW.rm_offset, NEW.rm_flags, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		NEW.rm_blockcount -= len;
 		error = xfs_rmap_update(cur, &NEW);
 		if (error)
@@ -1679,7 +1841,10 @@ xfs_rmap_convert_shared(
 				NEW.rm_offset, NEW.rm_flags, &i);
 		if (error)
 			goto done;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto done;
+		}
 		NEW.rm_blockcount = offset - NEW.rm_offset;
 		error = xfs_rmap_update(cur, &NEW);
 		if (error)
@@ -1765,25 +1930,43 @@ xfs_rmap_unmap_shared(
 			&ltrec, &i);
 	if (error)
 		goto out_error;
-	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	if (XFS_CORRUPT_ON(mp, i != 1)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 	ltoff = ltrec.rm_offset;
 
 	/* Make sure the extent we found covers the entire freeing range. */
-	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno &&
-		ltrec.rm_startblock + ltrec.rm_blockcount >=
-		bno + len, out_error);
+	if (XFS_CORRUPT_ON(mp,
+	    ltrec.rm_startblock > bno ||
+	    ltrec.rm_startblock + ltrec.rm_blockcount < bno + len)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	/* Make sure the owner matches what we expect to find in the tree. */
-	XFS_WANT_CORRUPTED_GOTO(mp, owner == ltrec.rm_owner, out_error);
+	if (XFS_CORRUPT_ON(mp, owner != ltrec.rm_owner)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	/* Make sure the unwritten flag matches. */
-	XFS_WANT_CORRUPTED_GOTO(mp, (flags & XFS_RMAP_UNWRITTEN) ==
-			(ltrec.rm_flags & XFS_RMAP_UNWRITTEN), out_error);
+	if (XFS_CORRUPT_ON(mp,
+	    (flags & XFS_RMAP_UNWRITTEN) !=
+	    (ltrec.rm_flags & XFS_RMAP_UNWRITTEN))) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	/* Check the offset. */
-	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_offset <= offset, out_error);
-	XFS_WANT_CORRUPTED_GOTO(mp, offset <= ltoff + ltrec.rm_blockcount,
-			out_error);
+	if (XFS_CORRUPT_ON(mp, ltrec.rm_offset > offset)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
+	if (XFS_CORRUPT_ON(mp, offset > ltoff + ltrec.rm_blockcount)) {
+		error = -EFSCORRUPTED;
+		goto out_error;
+	}
 
 	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
 		/* Exact match, simply remove the record from rmap tree. */
@@ -1836,7 +2019,10 @@ xfs_rmap_unmap_shared(
 				ltrec.rm_offset, ltrec.rm_flags, &i);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 		ltrec.rm_blockcount -= len;
 		error = xfs_rmap_update(cur, &ltrec);
 		if (error)
@@ -1862,7 +2048,10 @@ xfs_rmap_unmap_shared(
 				ltrec.rm_offset, ltrec.rm_flags, &i);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 		ltrec.rm_blockcount = bno - ltrec.rm_startblock;
 		error = xfs_rmap_update(cur, &ltrec);
 		if (error)
@@ -1938,7 +2127,10 @@ xfs_rmap_map_shared(
 		error = xfs_rmap_get_rec(cur, &gtrec, &have_gt);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(mp, have_gt == 1, out_error);
+		if (XFS_CORRUPT_ON(mp, have_gt != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 		trace_xfs_rmap_find_right_neighbor_result(cur->bc_mp,
 			cur->bc_private.a.agno, gtrec.rm_startblock,
 			gtrec.rm_blockcount, gtrec.rm_owner,
@@ -1987,7 +2179,10 @@ xfs_rmap_map_shared(
 				ltrec.rm_offset, ltrec.rm_flags, &i);
 		if (error)
 			goto out_error;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_error;
+		}
 
 		error = xfs_rmap_update(cur, &ltrec);
 		if (error)
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 8ec7aab89044..025af21be953 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -70,7 +70,10 @@ xfs_trim_extents(
 		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
 		if (error)
 			goto out_del_cursor;
-		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_del_cursor);
+		if (XFS_CORRUPT_ON(mp, i != 1)) {
+			error = -EFSCORRUPTED;
+			goto out_del_cursor;
+		}
 		ASSERT(flen <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest));
 
 		/*
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index c319379f7d1a..31a5d321ba9a 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -38,32 +38,6 @@ extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
 /* Dump 128 bytes of any corrupt buffer */
 #define XFS_CORRUPTION_DUMP_LEN		(128)
 
-/*
- * Macros to set EFSCORRUPTED & return/branch.
- */
-#define	XFS_WANT_CORRUPTED_GOTO(mp, x, l)	\
-	{ \
-		int fs_is_ok = (x); \
-		ASSERT(fs_is_ok); \
-		if (unlikely(!fs_is_ok)) { \
-			XFS_ERROR_REPORT("XFS_WANT_CORRUPTED_GOTO", \
-					 XFS_ERRLEVEL_LOW, mp); \
-			error = -EFSCORRUPTED; \
-			goto l; \
-		} \
-	}
-
-#define	XFS_WANT_CORRUPTED_RETURN(mp, x)	\
-	{ \
-		int fs_is_ok = (x); \
-		ASSERT(fs_is_ok); \
-		if (unlikely(!fs_is_ok)) { \
-			XFS_ERROR_REPORT("XFS_WANT_CORRUPTED_RETURN", \
-					 XFS_ERRLEVEL_LOW, mp); \
-			return -EFSCORRUPTED; \
-		} \
-	}
-
 #ifdef DEBUG
 extern int xfs_errortag_init(struct xfs_mount *mp);
 extern void xfs_errortag_del(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index aa375cf53021..9820037be458 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -298,7 +298,8 @@ xfs_iwalk_ag_start(
 	error = xfs_inobt_get_rec(*curpp, irec, has_more);
 	if (error)
 		return error;
-	XFS_WANT_CORRUPTED_RETURN(mp, *has_more == 1);
+	if (XFS_CORRUPT_ON(mp, *has_more != 1))
+		return -EFSCORRUPTED;
 
 	/*
 	 * If the LE lookup yielded an inobt record before the cursor position,

