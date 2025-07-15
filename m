Return-Path: <linux-xfs+bounces-24008-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E259BB059EF
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Jul 2025 14:26:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F4634E04B4
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Jul 2025 12:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E06CF2D5420;
	Tue, 15 Jul 2025 12:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XvT0MJ1r"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7482DE6FC
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 12:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752582370; cv=none; b=WEzZvzzTqmmLXOb1kwpZW34/d0dD39/8+ShkVlw2u5XObu3nKDgNwR78thjOW6Vo65HJBXN/ahmSH+MTHJYhHMvGBIEM8MkRNLMb8YMdk8r1opGwG04bX8+uXaSbKZvmxX2/NEyTlzH1MQlQ+OHciLStr5Q+G1RvEFw25EZLm7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752582370; c=relaxed/simple;
	bh=Iuz59y8/IJbbctqTg/VSIfThZ0btC2J6ODSpm7ZiqDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=du+yxvuWHjJIUXaXC1fmBzXpm6R7H3hcIypO+ftGobVDzDQJhNDl+kPF4FNApUFBwNYhTMqbILh3ZaUOyGwYE2qZYkSCuj+LH1g3DYnh24A4Q1PgJDt2nIPFTJ/gYJM6LvGx/lGutpr+4h0zHUefr/OROeKYWMnrzPoP52jMMNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XvT0MJ1r; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YCChjzgxDeeDRueZMOFvawFWASDFEPrttXYZt28ja2s=; b=XvT0MJ1rJfuq1dAOuYVoj9+5p+
	3js7BeWOu9mPuBgPnOE/iPBvxxILJecHE6TD4Ql2s9oLMU3bePz2nOlOfyIPtWsrjmTgdkbAsbsVd
	fEny6PvSKlDxnoTfqPu7zLCE/MLvr3h2WFuhsUb3oqn5nrLdY6NYw+I27XjXP7ioADKdCP1AtZDGo
	jlqpeUOrSVD5GvkJi0GSfMc+1DZZqJrEl+OgFaffJTSKtgSZwJ7o1kavAQzvOMpmWsnvEc520EbiI
	usx1vCZcaX4DdBKArnHPmVFA6eSAMtf8YbmIw3Eg90ESl+PlkhNCGXr9r/HmNbpN+8VvylRPjtlPu
	f9Mg7NxQ==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubejY-0000000540U-1FQY;
	Tue, 15 Jul 2025 12:26:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: return the allocated transaction from xchk_trans_alloc_empty
Date: Tue, 15 Jul 2025 14:25:39 +0200
Message-ID: <20250715122544.1943403-7-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250715122544.1943403-1-hch@lst.de>
References: <20250715122544.1943403-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xchk_trans_alloc_empty can't return errors, so return the allocated
transaction directly instead of an output double pointer argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c        |  6 +++---
 fs/xfs/scrub/common.h        |  2 +-
 fs/xfs/scrub/dir_repair.c    |  8 ++------
 fs/xfs/scrub/fscounters.c    |  3 ++-
 fs/xfs/scrub/metapath.c      |  4 +---
 fs/xfs/scrub/nlinks.c        |  8 ++------
 fs/xfs/scrub/nlinks_repair.c |  4 +---
 fs/xfs/scrub/parent_repair.c | 12 +++---------
 fs/xfs/scrub/quotacheck.c    |  4 +---
 fs/xfs/scrub/rmap_repair.c   |  4 +---
 fs/xfs/scrub/rtrmap_repair.c |  4 +---
 11 files changed, 18 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index d080f4e6e9d8..2ef7742be7d3 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -866,12 +866,11 @@ xchk_trans_cancel(
 	sc->tp = NULL;
 }
 
-int
+void
 xchk_trans_alloc_empty(
 	struct xfs_scrub	*sc)
 {
 	sc->tp = xfs_trans_alloc_empty(sc->mp);
-	return 0;
 }
 
 /*
@@ -893,7 +892,8 @@ xchk_trans_alloc(
 		return xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_itruncate,
 				resblks, 0, 0, &sc->tp);
 
-	return xchk_trans_alloc_empty(sc);
+	xchk_trans_alloc_empty(sc);
+	return 0;
 }
 
 /* Set us up with a transaction and an empty context. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 19877d99f255..ddbc065c798c 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -7,7 +7,7 @@
 #define __XFS_SCRUB_COMMON_H__
 
 int xchk_trans_alloc(struct xfs_scrub *sc, uint resblks);
-int xchk_trans_alloc_empty(struct xfs_scrub *sc);
+void xchk_trans_alloc_empty(struct xfs_scrub *sc);
 void xchk_trans_cancel(struct xfs_scrub *sc);
 
 bool xchk_process_error(struct xfs_scrub *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 249313882108..8d3b550990b5 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1289,9 +1289,7 @@ xrep_dir_scan_dirtree(
 	if (sc->ilock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL))
 		xchk_iunlock(sc, sc->ilock_flags & (XFS_ILOCK_SHARED |
 						    XFS_ILOCK_EXCL));
-	error = xchk_trans_alloc_empty(sc);
-	if (error)
-		return error;
+	xchk_trans_alloc_empty(sc);
 
 	while ((error = xchk_iscan_iter(&rd->pscan.iscan, &ip)) == 1) {
 		bool		flush;
@@ -1317,9 +1315,7 @@ xrep_dir_scan_dirtree(
 			if (error)
 				break;
 
-			error = xchk_trans_alloc_empty(sc);
-			if (error)
-				break;
+			xchk_trans_alloc_empty(sc);
 		}
 
 		if (xchk_should_terminate(sc, &error))
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 9b598c5790ad..cebd0d526926 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -237,7 +237,8 @@ xchk_setup_fscounters(
 			return error;
 	}
 
-	return xchk_trans_alloc_empty(sc);
+	xchk_trans_alloc_empty(sc);
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index e21c16fbd15d..14939d7de349 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -318,9 +318,7 @@ xchk_metapath(
 		return 0;
 	}
 
-	error = xchk_trans_alloc_empty(sc);
-	if (error)
-		return error;
+	xchk_trans_alloc_empty(sc);
 
 	error = xchk_metapath_ilock_both(mpath);
 	if (error)
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 4a47d0aabf73..26721fab5cab 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -555,9 +555,7 @@ xchk_nlinks_collect(
 	 * do not take sb_internal.
 	 */
 	xchk_trans_cancel(sc);
-	error = xchk_trans_alloc_empty(sc);
-	if (error)
-		return error;
+	xchk_trans_alloc_empty(sc);
 
 	while ((error = xchk_iscan_iter(&xnc->collect_iscan, &ip)) == 1) {
 		if (S_ISDIR(VFS_I(ip)->i_mode))
@@ -880,9 +878,7 @@ xchk_nlinks_compare(
 	 * inactivation workqueue.
 	 */
 	xchk_trans_cancel(sc);
-	error = xchk_trans_alloc_empty(sc);
-	if (error)
-		return error;
+	xchk_trans_alloc_empty(sc);
 
 	/*
 	 * Use the inobt to walk all allocated inodes to compare the link
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 4ebdee095428..6ef2ee9c3814 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -340,9 +340,7 @@ xrep_nlinks(
 		 * We can only push the inactivation workqueues with an empty
 		 * transaction.
 		 */
-		error = xchk_trans_alloc_empty(sc);
-		if (error)
-			break;
+		xchk_trans_alloc_empty(sc);
 	}
 	xchk_iscan_iter_finish(&xnc->compare_iscan);
 	xchk_iscan_teardown(&xnc->compare_iscan);
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 31bfe10be22a..2949feda6271 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -569,9 +569,7 @@ xrep_parent_scan_dirtree(
 	if (sc->ilock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL))
 		xchk_iunlock(sc, sc->ilock_flags & (XFS_ILOCK_SHARED |
 						    XFS_ILOCK_EXCL));
-	error = xchk_trans_alloc_empty(sc);
-	if (error)
-		return error;
+	xchk_trans_alloc_empty(sc);
 
 	while ((error = xchk_iscan_iter(&rp->pscan.iscan, &ip)) == 1) {
 		bool		flush;
@@ -597,9 +595,7 @@ xrep_parent_scan_dirtree(
 			if (error)
 				break;
 
-			error = xchk_trans_alloc_empty(sc);
-			if (error)
-				break;
+			xchk_trans_alloc_empty(sc);
 		}
 
 		if (xchk_should_terminate(sc, &error))
@@ -1099,9 +1095,7 @@ xrep_parent_flush_xattrs(
 	xrep_tempfile_iounlock(rp->sc);
 
 	/* Recreate the empty transaction and relock the inode. */
-	error = xchk_trans_alloc_empty(rp->sc);
-	if (error)
-		return error;
+	xchk_trans_alloc_empty(rp->sc);
 	xchk_ilock(rp->sc, XFS_ILOCK_EXCL);
 	return 0;
 }
diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index dc4033b91e44..e4105aaafe84 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -505,9 +505,7 @@ xqcheck_collect_counts(
 	 * transactions do not take sb_internal.
 	 */
 	xchk_trans_cancel(sc);
-	error = xchk_trans_alloc_empty(sc);
-	if (error)
-		return error;
+	xchk_trans_alloc_empty(sc);
 
 	while ((error = xchk_iscan_iter(&xqc->iscan, &ip)) == 1) {
 		error = xqcheck_collect_inode(xqc, ip);
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index f5f73078ffe2..bf1e632b449a 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -951,9 +951,7 @@ xrep_rmap_find_rmaps(
 	sa->agf_bp = NULL;
 	sa->agi_bp = NULL;
 	xchk_trans_cancel(sc);
-	error = xchk_trans_alloc_empty(sc);
-	if (error)
-		return error;
+	xchk_trans_alloc_empty(sc);
 
 	/* Iterate all AGs for inodes rmaps. */
 	while ((error = xchk_iscan_iter(&rr->iscan, &ip)) == 1) {
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index fc2592c53af5..4a56726d9952 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -580,9 +580,7 @@ xrep_rtrmap_find_rmaps(
 	 */
 	xchk_trans_cancel(sc);
 	xchk_rtgroup_unlock(&sc->sr);
-	error = xchk_trans_alloc_empty(sc);
-	if (error)
-		return error;
+	xchk_trans_alloc_empty(sc);
 
 	while ((error = xchk_iscan_iter(&rr->iscan, &ip)) == 1) {
 		error = xrep_rtrmap_scan_inode(rr, ip);
-- 
2.47.2


