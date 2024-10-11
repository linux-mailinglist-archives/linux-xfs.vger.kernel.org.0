Return-Path: <linux-xfs+bounces-13947-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ACAD7999910
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 03:20:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEF8D1C24186
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 01:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA7F3D268;
	Fri, 11 Oct 2024 01:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXtDQn56"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D6B9450
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609625; cv=none; b=dhKN3VVwS8Ycm9B/Zya96AiZbeasacXEuRFVVm/bDW22CxJHch2iFCI8Tfk3Wzhe8/6wr5tIduw5oYfhIKeFNBAi9BRFZ8ourl1bLHYVgU9vQlSL5x+00YDI8BtN5oVznOa1XTDSpYwkhjht8NnMYzqgkujvvvCv+QcIKpbZ9/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609625; c=relaxed/simple;
	bh=J5/FEzJ5SIus0gbJ6bx3dte7E6mrWMKd+KAaB4pySYM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G7Rmjx0uQQ5tFazVkoTnz8lU3UbsILI0/HLPnyFM0lIx6DzsCM3xC2MLlV+lLUu9vjoDg7DPAsnpu08JH2b7pA2drwnRkVxCpE6nCmn4n4N5qbGJiCGOkOq3mhNeFNynHvNTYlXQfzApFbYppvX9JxIvmT0e/ePgG/D9OV9u5bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXtDQn56; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB53C4CEC5;
	Fri, 11 Oct 2024 01:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609625;
	bh=J5/FEzJ5SIus0gbJ6bx3dte7E6mrWMKd+KAaB4pySYM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jXtDQn56wGrSWFWyAdVCOpqZMMt3VZ/JmJm5qsiO+0pwCBCd6pBkmj0Rrc75nVUPG
	 yzTJlmtno1aYvF+nRM/8nsWVnHGZLUyDvxmN25NntdD4Ty1idtSiqKyYb4hB4Ik8vc
	 Tt4zIXANnpLCnDdP99Iss6fGc4nByihg3jltdVancu+CFwknrrdKitweP2bE2jRe4v
	 DDaG0BkV+5yK7feJJBY2bBAmDFdjo0mjCk3dHc2bA5CX/E/02hl/IF3CizHiOMnN7j
	 YgZtKdvt6voMIT0gnf5y/lXs54KZAo1oQlCwaCwzd3LNWliRqkeWWmOF0+TyOdRG92
	 aV45U9ebbkTtg==
Date: Thu, 10 Oct 2024 18:20:24 -0700
Subject: [PATCH 24/38] xfs_repair: use libxfs_metafile_iget for quota/rt
 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654345.4183231.2415698670632295557.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Use the new iget function for these metadata files so that we can check
types, etc.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c     |   23 +++++++++--------------
 repair/quotacheck.c |   17 ++++++++++++++---
 repair/rt.c         |   29 ++++++++++++++++++++++-------
 3 files changed, 45 insertions(+), 24 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index e15d728ddc0469..84d2676e34fa53 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -484,6 +484,11 @@ ensure_rtino(
 	struct xfs_mount		*mp = tp->t_mountp;
 	int				error;
 
+	/*
+	 * Don't use metafile iget here because we're resetting sb-rooted
+	 * inodes that live at fixed inumbers, but these inodes could be in
+	 * an arbitrary state.
+	 */
 	error = -libxfs_iget(mp, tp, ino, 0, ipp);
 	if (error)
 		return error;
@@ -524,16 +529,11 @@ static void
 fill_rbmino(
 	struct xfs_mount	*mp)
 {
-	struct xfs_trans	*tp;
 	struct xfs_inode	*ip;
 	int			error;
 
-	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
-	if (error)
-		res_failed(error);
-
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rbmino, 0, &ip);
-	libxfs_trans_cancel(tp);
+	error = -libxfs_metafile_iget(mp, mp->m_sb.sb_rbmino,
+			XFS_METAFILE_RTBITMAP, &ip);
 	if (error)
 		do_error(
 _("couldn't iget realtime bitmap inode, error %d\n"), error);
@@ -551,16 +551,11 @@ static void
 fill_rsumino(
 	struct xfs_mount	*mp)
 {
-	struct xfs_trans	*tp;
 	struct xfs_inode	*ip;
 	int			error;
 
-	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
-	if (error)
-		res_failed(error);
-
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rsumino, 0, &ip);
-	libxfs_trans_cancel(tp);
+	error = -libxfs_metafile_iget(mp, mp->m_sb.sb_rsumino,
+			XFS_METAFILE_RTSUMMARY, &ip);
 	if (error)
 		do_error(
 _("couldn't iget realtime summary inode, error %d\n"), error);
diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index 4cb38db3ddd6d7..d9e08059927f80 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -403,21 +403,26 @@ quotacheck_verify(
 	struct xfs_ifork	*ifp;
 	struct qc_dquots	*dquots = NULL;
 	struct avl64node	*node, *n;
+	struct xfs_trans	*tp;
 	xfs_ino_t		ino = NULLFSINO;
+	enum xfs_metafile_type	metafile_type;
 	int			error;
 
 	switch (type) {
 	case XFS_DQTYPE_USER:
 		ino = mp->m_sb.sb_uquotino;
 		dquots = user_dquots;
+		metafile_type = XFS_METAFILE_USRQUOTA;
 		break;
 	case XFS_DQTYPE_GROUP:
 		ino = mp->m_sb.sb_gquotino;
 		dquots = group_dquots;
+		metafile_type = XFS_METAFILE_GRPQUOTA;
 		break;
 	case XFS_DQTYPE_PROJ:
 		ino = mp->m_sb.sb_pquotino;
 		dquots = proj_dquots;
+		metafile_type = XFS_METAFILE_PRJQUOTA;
 		break;
 	}
 
@@ -429,17 +434,21 @@ quotacheck_verify(
 	if (!dquots || !chkd_flags)
 		return;
 
-	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		do_error(_("could not alloc transaction to open quota file\n"));
+
+	error = -libxfs_trans_metafile_iget(tp, ino, metafile_type, &ip);
 	if (error) {
 		do_warn(
 	_("could not open %s inode %"PRIu64" for quotacheck, err=%d\n"),
 			qflags_typestr(type), ino, error);
 		chkd_flags = 0;
-		return;
+		goto out_trans;
 	}
 
 	ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
-	error = -libxfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+	error = -libxfs_iread_extents(tp, ip, XFS_DATA_FORK);
 	if (error) {
 		do_warn(
 	_("could not read %s inode %"PRIu64" extents, err=%d\n"),
@@ -477,6 +486,8 @@ _("%s record for id %u not found on disk (bcount %"PRIu64" rtbcount %"PRIu64" ic
 	}
 err:
 	libxfs_irele(ip);
+out_trans:
+	libxfs_trans_cancel(tp);
 }
 
 /*
diff --git a/repair/rt.c b/repair/rt.c
index 721c363cc1dd10..9ae421168e84b4 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -144,18 +144,34 @@ generate_rtinfo(
 static void
 check_rtfile_contents(
 	struct xfs_mount	*mp,
-	const char		*filename,
-	xfs_ino_t		ino,
-	void			*buf,
+	enum xfs_metafile_type	metafile_type,
 	xfs_fileoff_t		filelen)
 {
 	struct xfs_bmbt_irec	map;
 	struct xfs_buf		*bp;
 	struct xfs_inode	*ip;
+	const char		*filename;
+	void			*buf;
+	xfs_ino_t		ino;
 	xfs_fileoff_t		bno = 0;
 	int			error;
 
-	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
+	switch (metafile_type) {
+	case XFS_METAFILE_RTBITMAP:
+		ino = mp->m_sb.sb_rbmino;
+		filename = "rtbitmap";
+		buf = btmcompute;
+		break;
+	case XFS_METAFILE_RTSUMMARY:
+		ino = mp->m_sb.sb_rsumino;
+		filename = "rtsummary";
+		buf = sumcompute;
+		break;
+	default:
+		return;
+	}
+
+	error = -libxfs_metafile_iget(mp, ino, metafile_type, &ip);
 	if (error) {
 		do_warn(_("unable to open %s file, err %d\n"), filename, error);
 		return;
@@ -216,7 +232,7 @@ check_rtbitmap(
 	if (need_rbmino)
 		return;
 
-	check_rtfile_contents(mp, "rtbitmap", mp->m_sb.sb_rbmino, btmcompute,
+	check_rtfile_contents(mp, XFS_METAFILE_RTBITMAP,
 			mp->m_sb.sb_rbmblocks);
 }
 
@@ -227,6 +243,5 @@ check_rtsummary(
 	if (need_rsumino)
 		return;
 
-	check_rtfile_contents(mp, "rtsummary", mp->m_sb.sb_rsumino, sumcompute,
-			mp->m_rsumblocks);
+	check_rtfile_contents(mp, XFS_METAFILE_RTSUMMARY, mp->m_rsumblocks);
 }


