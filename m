Return-Path: <linux-xfs+bounces-16647-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E969F019A
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 02:08:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31F9A16A956
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 01:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03018286A1;
	Fri, 13 Dec 2024 01:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vRTEq2Mf"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EBC2629D
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052121; cv=none; b=eTrfrxuGrDOCZBxVSe6FRfncDZ+5GGEjlup8YKHrSo3FF58sQA8MXGHVyv8O/2WZOOwLLBAVe+4ugx1UTgiHYwRIYHpugKAuvY7+V/oqe02jzYW4Nc1+wxAfHmZP8urdPtORJubDRHozaMXwZ8MJ+3dxDfkY7cfclUqI+I0oM7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052121; c=relaxed/simple;
	bh=0XR9nzjOOnXEdk0J6r9drqwcJPLcxFbSP6mfMnCugWU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RCQoc9a2jSfwIPFyc/JteXdVHHy/TTz7WrRdHYXycDCR6oShFRdZ+3hfSET0fdxGmEHvb0yuvUgsYgABc/RDWLhHW52Qe1nSGYV9BZyUo7b0X3kyYgFySomXsxzypEFuSgg2Pbk+31CJS+csFPPPQn5BL7BC1lcbbf8JPE4wi4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vRTEq2Mf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930B7C4CECE;
	Fri, 13 Dec 2024 01:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052121;
	bh=0XR9nzjOOnXEdk0J6r9drqwcJPLcxFbSP6mfMnCugWU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vRTEq2MfUmuneSvspbdDgWSdxybJ8RRngtjM0iJZ8M+U7uVWvjS9NQmAdokUGyHp9
	 UODB8l/0VFrmvdfILgyd7n20fyGT75cpFucaOc2zVcBYq1y8thwc2rlxFNT2HPoJCS
	 Ej3+b+s30kopQovdNCRGBCcPd4a5I33B2iJvIh0poFgiIgcbKwhZhyYpkuJ9lnTHI6
	 JludF5xy0xtiJNnUGDVtRQ1/JCtKSujaNcTF//9EPGjIMqmbdo5XdMfLy2ixZ5vGfu
	 7mf2mX0uGiXmF4UophUIido5h+B21CbMNQLk8BLm/hpB99rSlKkle+UgUsw42F3Ius
	 jkEiyYUys5MNA==
Date: Thu, 12 Dec 2024 17:08:41 -0800
Subject: [PATCH 31/37] xfs: support repairing metadata btrees rooted in
 metadir inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123847.1181370.11971021393841190421.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Adapt the repair code so that we can stage a new btree in the data fork
area of a metadir inode and reap the old blocks.  We already have nearly
all of the infrastructure; the only parts that were missing were the
metadata inode reservation handling.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/newbt.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.h |    1 +
 fs/xfs/scrub/reap.c  |   41 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/reap.h  |    2 ++
 4 files changed, 86 insertions(+)


diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 70af27d987342f..ac38f584309029 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -19,6 +19,8 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 #include "xfs_defer.h"
+#include "xfs_metafile.h"
+#include "xfs_quota.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -120,6 +122,43 @@ xrep_newbt_init_inode(
 	return 0;
 }
 
+/*
+ * Initialize accounting resources for staging a new metadata inode btree.
+ * If the metadata file has a space reservation, the caller must adjust that
+ * reservation when committing the new ondisk btree.
+ */
+int
+xrep_newbt_init_metadir_inode(
+	struct xrep_newbt		*xnr,
+	struct xfs_scrub		*sc)
+{
+	struct xfs_owner_info		oinfo;
+	struct xfs_ifork		*ifp;
+
+	ASSERT(xfs_is_metadir_inode(sc->ip));
+
+	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
+
+	ifp = kmem_cache_zalloc(xfs_ifork_cache, XCHK_GFP_FLAGS);
+	if (!ifp)
+		return -ENOMEM;
+
+	/*
+	 * Allocate new metadir btree blocks with XFS_AG_RESV_NONE because the
+	 * inode metadata space reservations can only account allocated space
+	 * to the i_nblocks.  We do not want to change the inode core fields
+	 * until we're ready to commit the new tree, so we allocate the blocks
+	 * as if they were regular file blocks.  This exposes us to a higher
+	 * risk of the repair being cancelled due to ENOSPC.
+	 */
+	xrep_newbt_init_ag(xnr, sc, &oinfo,
+			XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino),
+			XFS_AG_RESV_NONE);
+	xnr->ifake.if_fork = ifp;
+	xnr->ifake.if_fork_size = xfs_inode_fork_size(sc->ip, XFS_DATA_FORK);
+	return 0;
+}
+
 /*
  * Initialize accounting resources for staging a new btree.  Callers are
  * expected to add their own reservations (and clean them up) manually.
@@ -224,6 +263,7 @@ xrep_newbt_alloc_ag_blocks(
 	int			error = 0;
 
 	ASSERT(sc->sa.pag != NULL);
+	ASSERT(xnr->resv != XFS_AG_RESV_METAFILE);
 
 	while (nr_blocks > 0) {
 		struct xfs_alloc_arg	args = {
@@ -297,6 +337,8 @@ xrep_newbt_alloc_file_blocks(
 	struct xfs_mount	*mp = sc->mp;
 	int			error = 0;
 
+	ASSERT(xnr->resv != XFS_AG_RESV_METAFILE);
+
 	while (nr_blocks > 0) {
 		struct xfs_alloc_arg	args = {
 			.tp		= sc->tp,
diff --git a/fs/xfs/scrub/newbt.h b/fs/xfs/scrub/newbt.h
index 3d804d31af24a8..5ce785599287be 100644
--- a/fs/xfs/scrub/newbt.h
+++ b/fs/xfs/scrub/newbt.h
@@ -63,6 +63,7 @@ void xrep_newbt_init_ag(struct xrep_newbt *xnr, struct xfs_scrub *sc,
 		enum xfs_ag_resv_type resv);
 int xrep_newbt_init_inode(struct xrep_newbt *xnr, struct xfs_scrub *sc,
 		int whichfork, const struct xfs_owner_info *oinfo);
+int xrep_newbt_init_metadir_inode(struct xrep_newbt *xnr, struct xfs_scrub *sc);
 int xrep_newbt_alloc_blocks(struct xrep_newbt *xnr, uint64_t nr_blocks);
 int xrep_newbt_add_extent(struct xrep_newbt *xnr, struct xfs_perag *pag,
 		xfs_agblock_t agbno, xfs_extlen_t len);
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index 08230952053b7d..4d7f1b82dc559d 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -33,6 +33,7 @@
 #include "xfs_attr.h"
 #include "xfs_attr_remote.h"
 #include "xfs_defer.h"
+#include "xfs_metafile.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -390,6 +391,8 @@ xreap_agextent_iter(
 	xfs_fsblock_t		fsbno;
 	int			error = 0;
 
+	ASSERT(rs->resv != XFS_AG_RESV_METAFILE);
+
 	fsbno = xfs_agbno_to_fsb(sc->sa.pag, agbno);
 
 	/*
@@ -675,6 +678,44 @@ xrep_reap_fsblocks(
 	return 0;
 }
 
+/*
+ * Dispose of every block of an old metadata btree that used to be rooted in a
+ * metadata directory file.
+ */
+int
+xrep_reap_metadir_fsblocks(
+	struct xfs_scrub		*sc,
+	struct xfsb_bitmap		*bitmap)
+{
+	/*
+	 * Reap old metadir btree blocks with XFS_AG_RESV_NONE because the old
+	 * blocks are no longer mapped by the inode, and inode metadata space
+	 * reservations can only account freed space to the i_nblocks.
+	 */
+	struct xfs_owner_info		oinfo;
+	struct xreap_state		rs = {
+		.sc			= sc,
+		.oinfo			= &oinfo,
+		.resv			= XFS_AG_RESV_NONE,
+	};
+	int				error;
+
+	ASSERT(xfs_has_rmapbt(sc->mp));
+	ASSERT(sc->ip != NULL);
+	ASSERT(xfs_is_metadir_inode(sc->ip));
+
+	xfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
+
+	error = xfsb_bitmap_walk(bitmap, xreap_fsmeta_extent, &rs);
+	if (error)
+		return error;
+
+	if (xreap_dirty(&rs))
+		return xrep_defer_finish(sc);
+
+	return 0;
+}
+
 /*
  * Metadata files are not supposed to share blocks with anything else.
  * If blocks are shared, we remove the reverse mapping (thus reducing the
diff --git a/fs/xfs/scrub/reap.h b/fs/xfs/scrub/reap.h
index 3f2f1775e29db4..70e5e6bbb8d38d 100644
--- a/fs/xfs/scrub/reap.h
+++ b/fs/xfs/scrub/reap.h
@@ -14,6 +14,8 @@ int xrep_reap_agblocks(struct xfs_scrub *sc, struct xagb_bitmap *bitmap,
 int xrep_reap_fsblocks(struct xfs_scrub *sc, struct xfsb_bitmap *bitmap,
 		const struct xfs_owner_info *oinfo);
 int xrep_reap_ifork(struct xfs_scrub *sc, struct xfs_inode *ip, int whichfork);
+int xrep_reap_metadir_fsblocks(struct xfs_scrub *sc,
+		struct xfsb_bitmap *bitmap);
 
 /* Buffer cache scan context. */
 struct xrep_bufscan {


