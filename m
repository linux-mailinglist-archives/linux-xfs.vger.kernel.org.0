Return-Path: <linux-xfs+bounces-16682-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 08D749F01E7
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 02:17:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12FB01673DA
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 01:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 389D817BA1;
	Fri, 13 Dec 2024 01:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p0bsQcsu"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA161426C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052669; cv=none; b=GPbuOIjZN3+eFm0/S2bNKiGN2Oftsu0SP79rLui5vGnduVdL5yBPDeCbsOuOnZX/3B0rYl7US50weXdosE2URAxBgi9BMLqLOgclMNXKh47e786FyPTf9lxkmkYHwhjFGszYXv9HMJ2PPPoG3Hssu5nmfF87OE3evsvY+2tXwPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052669; c=relaxed/simple;
	bh=53He2ickB6V6fbe+olOwRWjQDNI30L5w4a0rurv2d2k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JfVvUvfdDCApkZh3k3LO1pXx3rigkAaXz/Wvb/l9XCAO02J34xTwq89HzruNiQXKbvsERZ+VGOz9Nc7DypgI61E9WOy/uBSqyKbXsDq9DJAOWw7ys7o7vubC3kxpwQ6kbe++suI262RPzrxIwJShz+RNQkYN9joN9A28UcQygL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p0bsQcsu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723F4C4CECE;
	Fri, 13 Dec 2024 01:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052668;
	bh=53He2ickB6V6fbe+olOwRWjQDNI30L5w4a0rurv2d2k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=p0bsQcsuaXH4QRYmh/ZB/eravvKG0LkdHG4YUoGQ6T5nU98XOBt1cEt/+1KRozJHs
	 ismprh0VODTUpavKQ4f01OQFEo1vTzRvA43OBxfIwKl6Z7BsojvLq1pv26LaAMzCBK
	 zP/YnEAbfYchE6RTnckhUW0PMYLVSTHcwjM6D6tA7vplQc+4dHhfEBrXP5p8mytJKS
	 vzyrP4ZTYcm5XFPe1ldWOR3wzxUEeGT6GVd3QrlReSoWPiylP+IkdgeWcP5v0IwGsk
	 AMgqMicN+cTFExaatmDLg/+uZiw8fvx4Sy8o+Cv+RPtpc3NLVqh6uNVrIxePW+Bp2V
	 RqyepYA2hl3ow==
Date: Thu, 12 Dec 2024 17:17:48 -0800
Subject: [PATCH 29/43] xfs: cross-reference checks with the rt refcount btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125064.1182620.4358632903814082823.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use the realtime refcount btree to implement cross-reference checks in
other data structures.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c       |   30 +++++++++++++---
 fs/xfs/scrub/rtbitmap.c   |    2 +
 fs/xfs/scrub/rtrefcount.c |   86 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtrmap.c     |   37 +++++++++++++++++++
 fs/xfs/scrub/scrub.h      |    9 +++++
 5 files changed, 158 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index f6077b0cba8a14..66da7d4d56ba74 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -347,13 +347,31 @@ xchk_bmap_rt_iextent_xref(
 		goto out_cur;
 
 	rgbno = xfs_rtb_to_rgbno(info->sc->mp, irec->br_startblock);
-	xchk_bmap_xref_rmap(info, irec, rgbno);
-
-	xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino, info->whichfork,
-			irec->br_startoff);
-	xchk_xref_is_only_rt_owned_by(info->sc, rgbno,
-			irec->br_blockcount, &oinfo);
 
+	switch (info->whichfork) {
+	case XFS_DATA_FORK:
+		xchk_bmap_xref_rmap(info, irec, rgbno);
+		if (!xfs_is_reflink_inode(info->sc->ip)) {
+			xfs_rmap_ino_owner(&oinfo, info->sc->ip->i_ino,
+					info->whichfork, irec->br_startoff);
+			xchk_xref_is_only_rt_owned_by(info->sc, rgbno,
+					irec->br_blockcount, &oinfo);
+			xchk_xref_is_not_rt_shared(info->sc, rgbno,
+					irec->br_blockcount);
+		}
+		xchk_xref_is_not_rt_cow_staging(info->sc, rgbno,
+				irec->br_blockcount);
+		break;
+	case XFS_COW_FORK:
+		xchk_bmap_xref_rmap_cow(info, irec, rgbno);
+		xchk_xref_is_only_rt_owned_by(info->sc, rgbno,
+				irec->br_blockcount, &XFS_RMAP_OINFO_COW);
+		xchk_xref_is_rt_cow_staging(info->sc, rgbno,
+				irec->br_blockcount);
+		xchk_xref_is_not_rt_shared(info->sc, rgbno,
+				irec->br_blockcount);
+		break;
+	}
 out_cur:
 	xchk_rtgroup_btcur_free(&info->sc->sr);
 out_free:
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 28c90a31f4c32b..e8c776a34c1df1 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -105,6 +105,8 @@ xchk_rtbitmap_xref(
 		return;
 
 	xchk_xref_has_no_rt_owner(sc, rgbno, blockcount);
+	xchk_xref_is_not_rt_shared(sc, rgbno, blockcount);
+	xchk_xref_is_not_rt_cow_staging(sc, rgbno, blockcount);
 
 	if (rtb->next_free_rgbno < rgbno)
 		xchk_xref_has_rt_owner(sc, rtb->next_free_rgbno,
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 92ae2e15ae9f79..f56f2cb7a9f707 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -485,3 +485,89 @@ xchk_rtrefcountbt(
 
 	return 0;
 }
+
+/* xref check that a cow staging extent is marked in the rtrefcountbt. */
+void
+xchk_xref_is_rt_cow_staging(
+	struct xfs_scrub		*sc,
+	xfs_rgblock_t			bno,
+	xfs_extlen_t			len)
+{
+	struct xfs_refcount_irec	rc;
+	int				has_refcount;
+	int				error;
+
+	if (!sc->sr.refc_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	/* Find the CoW staging extent. */
+	error = xfs_refcount_lookup_le(sc->sr.refc_cur, XFS_REFC_DOMAIN_COW,
+			bno, &has_refcount);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.refc_cur))
+		return;
+	if (!has_refcount) {
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
+		return;
+	}
+
+	error = xfs_refcount_get_rec(sc->sr.refc_cur, &rc, &has_refcount);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.refc_cur))
+		return;
+	if (!has_refcount) {
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
+		return;
+	}
+
+	/* CoW lookup returned a shared extent record? */
+	if (rc.rc_domain != XFS_REFC_DOMAIN_COW)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
+
+	/* Must be at least as long as what was passed in */
+	if (rc.rc_blockcount < len)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
+}
+
+/*
+ * xref check that the extent is not shared.  Only file data blocks
+ * can have multiple owners.
+ */
+void
+xchk_xref_is_not_rt_shared(
+	struct xfs_scrub	*sc,
+	xfs_rgblock_t		bno,
+	xfs_extlen_t		len)
+{
+	enum xbtree_recpacking	outcome;
+	int			error;
+
+	if (!sc->sr.refc_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	error = xfs_refcount_has_records(sc->sr.refc_cur,
+			XFS_REFC_DOMAIN_SHARED, bno, len, &outcome);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.refc_cur))
+		return;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
+}
+
+/* xref check that the extent is not being used for CoW staging. */
+void
+xchk_xref_is_not_rt_cow_staging(
+	struct xfs_scrub	*sc,
+	xfs_rgblock_t		bno,
+	xfs_extlen_t		len)
+{
+	enum xbtree_recpacking	outcome;
+	int			error;
+
+	if (!sc->sr.refc_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	error = xfs_refcount_has_records(sc->sr.refc_cur, XFS_REFC_DOMAIN_COW,
+			bno, len, &outcome);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.refc_cur))
+		return;
+	if (outcome != XBTREE_RECPACKING_EMPTY)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
+}
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
index 300a1e85b3d625..3d5419682d6528 100644
--- a/fs/xfs/scrub/rtrmap.c
+++ b/fs/xfs/scrub/rtrmap.c
@@ -22,6 +22,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_rtgroup.h"
 #include "xfs_metafile.h"
+#include "xfs_refcount.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -149,6 +150,37 @@ xchk_rtrmapbt_check_mergeable(
 	memcpy(&cr->prev_rec, irec, sizeof(struct xfs_rmap_irec));
 }
 
+/* Cross-reference a rmap against the refcount btree. */
+STATIC void
+xchk_rtrmapbt_xref_rtrefc(
+	struct xfs_scrub	*sc,
+	struct xfs_rmap_irec	*irec)
+{
+	xfs_rgblock_t		fbno;
+	xfs_extlen_t		flen;
+	bool			is_inode;
+	bool			is_bmbt;
+	bool			is_attr;
+	bool			is_unwritten;
+	int			error;
+
+	if (!sc->sr.refc_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	is_inode = !XFS_RMAP_NON_INODE_OWNER(irec->rm_owner);
+	is_bmbt = irec->rm_flags & XFS_RMAP_BMBT_BLOCK;
+	is_attr = irec->rm_flags & XFS_RMAP_ATTR_FORK;
+	is_unwritten = irec->rm_flags & XFS_RMAP_UNWRITTEN;
+
+	/* If this is shared, must be a data fork extent. */
+	error = xfs_refcount_find_shared(sc->sr.refc_cur, irec->rm_startblock,
+			irec->rm_blockcount, &fbno, &flen, false);
+	if (!xchk_should_check_xref(sc, &error, &sc->sr.refc_cur))
+		return;
+	if (flen != 0 && (!is_inode || is_attr || is_bmbt || is_unwritten))
+		xchk_btree_xref_set_corrupt(sc, sc->sr.refc_cur, 0);
+}
+
 /* Cross-reference with other metadata. */
 STATIC void
 xchk_rtrmapbt_xref(
@@ -161,6 +193,11 @@ xchk_rtrmapbt_xref(
 	xchk_xref_is_used_rt_space(sc,
 			xfs_rgbno_to_rtb(sc->sr.rtg, irec->rm_startblock),
 			irec->rm_blockcount);
+	if (irec->rm_owner == XFS_RMAP_OWN_COW)
+		xchk_xref_is_cow_staging(sc, irec->rm_startblock,
+				irec->rm_blockcount);
+	else
+		xchk_rtrmapbt_xref_rtrefc(sc, irec);
 }
 
 /* Scrub a realtime rmapbt record. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index ab3d221dd9ed2d..a1086f1f06d0d9 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -331,11 +331,20 @@ void xchk_xref_has_rt_owner(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
 		xfs_extlen_t len);
 void xchk_xref_is_only_rt_owned_by(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
 		xfs_extlen_t len, const struct xfs_owner_info *oinfo);
+void xchk_xref_is_rt_cow_staging(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
+		xfs_extlen_t len);
+void xchk_xref_is_not_rt_shared(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
+		xfs_extlen_t len);
+void xchk_xref_is_not_rt_cow_staging(struct xfs_scrub *sc, xfs_rgblock_t rgbno,
+		xfs_extlen_t len);
 #else
 # define xchk_xref_is_used_rt_space(sc, rtbno, len) do { } while (0)
 # define xchk_xref_has_no_rt_owner(sc, rtbno, len) do { } while (0)
 # define xchk_xref_has_rt_owner(sc, rtbno, len) do { } while (0)
 # define xchk_xref_is_only_rt_owned_by(sc, bno, len, oinfo) do { } while (0)
+# define xchk_xref_is_rt_cow_staging(sc, bno, len) do { } while (0)
+# define xchk_xref_is_not_rt_shared(sc, bno, len) do { } while (0)
+# define xchk_xref_is_not_rt_cow_staging(sc, bno, len) do { } while (0)
 #endif
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */


