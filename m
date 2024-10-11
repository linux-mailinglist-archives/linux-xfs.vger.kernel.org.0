Return-Path: <linux-xfs+bounces-14009-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A19E899998E
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 03:36:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DF9E284E0E
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 01:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC1718027;
	Fri, 11 Oct 2024 01:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIwYBhko"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00B217BCA
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610594; cv=none; b=p7u7z+moBm+AoUe3oW138fyrcpSVR4ADOY5qzio0OpPTiF3jZpUVcj/8w0hmFpQULZVHQ3hnpyWPE4IKvKVXccf2xlspAPlzE6Ac7jP/D4CYaiXRbi5eVVf4xNhu9eSSqf79/yERUBwwE75aFSEp9WfRodnpsDKrttBmHWZ3ZfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610594; c=relaxed/simple;
	bh=YJHv4gGeknTlBzqUoLQy/OJGovdEMOfizpTELswFUTc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z4aLrTQTFKvzjaGJ19rhyb4zdxT0I1oRSjjNmB5VA4Dae9A/cuEJl3UNaxTpllCt5kMiCt3vFVcq8bQIpwl6KOVlj/VqlpswRuTOIOier5QGoPQuSe0BU+ReqU4qYrN49qQVczuo02YpQQJOHaHAdK7s7x4i+0tkWqrZl2l2/OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIwYBhko; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71341C4CEC5;
	Fri, 11 Oct 2024 01:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610593;
	bh=YJHv4gGeknTlBzqUoLQy/OJGovdEMOfizpTELswFUTc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JIwYBhkoId+tJ+ppjW4jalg4JfVhN14yClUGcT/oGh83D8+gavR7XEhvLLp8m6Iwg
	 MHGcP5IJDbCNKUUuRuhDkNWMpA/oirZgq/ZKpesmV1K2WMKK/MALtAqW/aRESnNlF1
	 57o6fhFFKhBRCLAlPrUohwOpT8CNwFuNUq0lO52uoYzJ/KobdYK3LuYOA1ljQ0e3hp
	 8arX5uGKf7GMUtxbf632/xlJpLx5xHrdXViYEXMk9Z3zw4FX9bxUrSscYFs71Dfxlo
	 uoTummRZhvdIx22aEJuZpxRJX6PpI/GP+hk0/sc6kv56SOp0dHITd8Jr3s9cyfPng4
	 Oh+NcpMDEQikA==
Date: Thu, 10 Oct 2024 18:36:32 -0700
Subject: [PATCH 3/7] xfs_repair: refactor quota inumber handling
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860656419.4186076.15282130602183093918.stgit@frogsfrogsfrogs>
In-Reply-To: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
References: <172860656360.4186076.16173495385344323783.stgit@frogsfrogsfrogs>
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

In preparation for putting quota files in the metadata directory tree,
refactor repair's quota inumber handling to use its own variables
instead of the xfs_mount's.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c     |   18 ++++----
 repair/dir2.c       |   12 +++---
 repair/globals.c    |  111 ++++++++++++++++++++++++++++++++++++++++++++++++---
 repair/globals.h    |   15 ++++---
 repair/phase4.c     |   96 ++++++++++++++++++--------------------------
 repair/phase6.c     |   12 +++---
 repair/quotacheck.c |   47 +++++++++++++++-------
 repair/quotacheck.h |    2 +
 repair/versions.c   |    9 +---
 repair/xfs_repair.c |   12 ++++--
 10 files changed, 221 insertions(+), 113 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 3cf93eacc83462..8a926b24d4b5aa 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1662,29 +1662,29 @@ process_check_metadata_inodes(
 		}
 		return 0;
 	}
-	if (lino == mp->m_sb.sb_uquotino)  {
+	if (is_quota_inode(XFS_DQTYPE_USER, lino))  {
 		if (*type != XR_INO_UQUOTA)  {
 			do_warn(_("user quota inode %" PRIu64 " has bad type 0x%x\n"),
 				lino, dinode_fmt(dinoc));
-			mp->m_sb.sb_uquotino = NULLFSINO;
+			clear_quota_inode(XFS_DQTYPE_USER);
 			return 1;
 		}
 		return 0;
 	}
-	if (lino == mp->m_sb.sb_gquotino)  {
+	if (is_quota_inode(XFS_DQTYPE_GROUP, lino))  {
 		if (*type != XR_INO_GQUOTA)  {
 			do_warn(_("group quota inode %" PRIu64 " has bad type 0x%x\n"),
 				lino, dinode_fmt(dinoc));
-			mp->m_sb.sb_gquotino = NULLFSINO;
+			clear_quota_inode(XFS_DQTYPE_GROUP);
 			return 1;
 		}
 		return 0;
 	}
-	if (lino == mp->m_sb.sb_pquotino)  {
+	if (is_quota_inode(XFS_DQTYPE_PROJ, lino))  {
 		if (*type != XR_INO_PQUOTA)  {
 			do_warn(_("project quota inode %" PRIu64 " has bad type 0x%x\n"),
 				lino, dinode_fmt(dinoc));
-			mp->m_sb.sb_pquotino = NULLFSINO;
+			clear_quota_inode(XFS_DQTYPE_PROJ);
 			return 1;
 		}
 		return 0;
@@ -2980,11 +2980,11 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 		else if (lino == mp->m_sb.sb_rsumino ||
 			 is_rtsummary_inode(lino))
 			type = XR_INO_RTSUM;
-		else if (lino == mp->m_sb.sb_uquotino)
+		else if (is_quota_inode(XFS_DQTYPE_USER, lino))
 			type = XR_INO_UQUOTA;
-		else if (lino == mp->m_sb.sb_gquotino)
+		else if (is_quota_inode(XFS_DQTYPE_GROUP, lino))
 			type = XR_INO_GQUOTA;
-		else if (lino == mp->m_sb.sb_pquotino)
+		else if (is_quota_inode(XFS_DQTYPE_PROJ, lino))
 			type = XR_INO_PQUOTA;
 		else
 			type = XR_INO_DATA;
diff --git a/repair/dir2.c b/repair/dir2.c
index ca747c90175e93..ed615662009957 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -265,13 +265,13 @@ process_sf_dir2(
 		           is_rtsummary_inode(lino)) {
 			junkit = 1;
 			junkreason = _("realtime summary");
-		} else if (lino == mp->m_sb.sb_uquotino)  {
+		} else if (is_quota_inode(XFS_DQTYPE_USER, lino)) {
 			junkit = 1;
 			junkreason = _("user quota");
-		} else if (lino == mp->m_sb.sb_gquotino)  {
+		} else if (is_quota_inode(XFS_DQTYPE_GROUP, lino)) {
 			junkit = 1;
 			junkreason = _("group quota");
-		} else if (lino == mp->m_sb.sb_pquotino)  {
+		} else if (is_quota_inode(XFS_DQTYPE_PROJ, lino)) {
 			junkit = 1;
 			junkreason = _("project quota");
 		} else if (lino == mp->m_sb.sb_metadirino)  {
@@ -746,11 +746,11 @@ process_dir2_data(
 		} else if (ent_ino == mp->m_sb.sb_rsumino ||
 		           is_rtsummary_inode(ent_ino)) {
 			clearreason = _("realtime summary");
-		} else if (ent_ino == mp->m_sb.sb_uquotino) {
+		} else if (is_quota_inode(XFS_DQTYPE_USER, ent_ino)) {
 			clearreason = _("user quota");
-		} else if (ent_ino == mp->m_sb.sb_gquotino) {
+		} else if (is_quota_inode(XFS_DQTYPE_GROUP, ent_ino)) {
 			clearreason = _("group quota");
-		} else if (ent_ino == mp->m_sb.sb_pquotino) {
+		} else if (is_quota_inode(XFS_DQTYPE_PROJ, ent_ino)) {
 			clearreason = _("project quota");
 		} else if (ent_ino == mp->m_sb.sb_metadirino)  {
 			clearreason = _("metadata directory root");
diff --git a/repair/globals.c b/repair/globals.c
index 30995f5298d5a1..99291d6afd61b9 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -73,12 +73,6 @@ int	need_rbmino;
 int	need_rsumino;
 
 int	lost_quotas;
-int	have_uquotino;
-int	have_gquotino;
-int	have_pquotino;
-int	lost_uquotino;
-int	lost_gquotino;
-int	lost_pquotino;
 
 /* configuration vars -- fs geometry dependent */
 
@@ -119,3 +113,108 @@ int		thread_count;
 
 /* If nonzero, simulate failure after this phase. */
 int		fail_after_phase;
+
+/* quota inode numbers */
+enum quotino_state {
+	QI_STATE_UNKNOWN,
+	QI_STATE_HAVE,
+	QI_STATE_LOST,
+};
+
+static xfs_ino_t quotinos[3] = { NULLFSINO, NULLFSINO, NULLFSINO };
+static enum quotino_state quotino_state[3];
+
+static inline unsigned int quotino_off(xfs_dqtype_t type)
+{
+	switch (type) {
+	case XFS_DQTYPE_USER:
+		return 0;
+	case XFS_DQTYPE_GROUP:
+		return 1;
+	case XFS_DQTYPE_PROJ:
+		return 2;
+	}
+
+	ASSERT(0);
+	return -1;
+}
+
+void
+set_quota_inode(
+	xfs_dqtype_t	type,
+	xfs_ino_t	ino)
+{
+	unsigned int	off = quotino_off(type);
+
+	quotinos[off] = ino;
+	quotino_state[off] = QI_STATE_HAVE;
+}
+
+void
+lose_quota_inode(
+	xfs_dqtype_t	type)
+{
+	unsigned int	off = quotino_off(type);
+
+	quotinos[off] = NULLFSINO;
+	quotino_state[off] = QI_STATE_LOST;
+}
+
+void
+clear_quota_inode(
+	xfs_dqtype_t	type)
+{
+	unsigned int	off = quotino_off(type);
+
+	quotinos[off] = NULLFSINO;
+	quotino_state[off] = QI_STATE_UNKNOWN;
+}
+
+xfs_ino_t
+get_quota_inode(
+	xfs_dqtype_t	type)
+{
+	unsigned int	off = quotino_off(type);
+
+	return quotinos[off];
+}
+
+bool
+is_quota_inode(
+	xfs_dqtype_t	type,
+	xfs_ino_t	ino)
+{
+	unsigned int	off = quotino_off(type);
+
+	return quotinos[off] == ino;
+}
+
+bool
+is_any_quota_inode(
+	xfs_ino_t		ino)
+{
+	unsigned int		i;
+
+	for(i = 0; i < ARRAY_SIZE(quotinos); i++)
+		if (quotinos[i] == ino)
+			return true;
+	return false;
+}
+
+bool
+lost_quota_inode(
+	xfs_dqtype_t	type)
+{
+	unsigned int	off = quotino_off(type);
+
+	return quotino_state[off] == QI_STATE_LOST;
+}
+
+bool
+has_quota_inode(
+	xfs_dqtype_t	type)
+{
+	unsigned int	off = quotino_off(type);
+
+	return quotino_state[off] == QI_STATE_HAVE;
+}
diff --git a/repair/globals.h b/repair/globals.h
index 7c2d9c56c8f8a7..b23a06af6cc81b 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -114,12 +114,6 @@ extern int		need_rbmino;
 extern int		need_rsumino;
 
 extern int		lost_quotas;
-extern int		have_uquotino;
-extern int		have_gquotino;
-extern int		have_pquotino;
-extern int		lost_uquotino;
-extern int		lost_gquotino;
-extern int		lost_pquotino;
 
 /* configuration vars -- fs geometry dependent */
 
@@ -165,4 +159,13 @@ extern int		fail_after_phase;
 
 extern struct libxfs_init x;
 
+void set_quota_inode(xfs_dqtype_t type, xfs_ino_t);
+void lose_quota_inode(xfs_dqtype_t type);
+void clear_quota_inode(xfs_dqtype_t type);
+xfs_ino_t get_quota_inode(xfs_dqtype_t type);
+bool is_quota_inode(xfs_dqtype_t type, xfs_ino_t ino);
+bool is_any_quota_inode(xfs_ino_t ino);
+bool lost_quota_inode(xfs_dqtype_t type);
+bool has_quota_inode(xfs_dqtype_t type);
+
 #endif /* _XFS_REPAIR_GLOBAL_H */
diff --git a/repair/phase4.c b/repair/phase4.c
index f43f8ecd84e25b..a4183c557a1891 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -23,6 +23,35 @@
 
 bool collect_rmaps;
 
+static inline void
+quotino_check_one(
+	struct xfs_mount	*mp,
+	xfs_dqtype_t		type)
+{
+	struct ino_tree_node	*irec;
+	xfs_ino_t		ino;
+
+	if (!has_quota_inode(type))
+		return;
+
+	ino = get_quota_inode(type);
+	if (!libxfs_verify_ino(mp, ino))
+		goto bad;
+
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
+			XFS_INO_TO_AGINO(mp, ino));
+	if (!irec)
+		goto bad;
+
+	if (is_inode_free(irec, ino - irec->ino_startnum))
+		goto bad;
+
+	return;
+
+bad:
+	lose_quota_inode(type);
+}
+
 /*
  * null out quota inode fields in sb if they point to non-existent inodes.
  * this isn't as redundant as it looks since it's possible that the sb field
@@ -31,57 +60,12 @@ bool collect_rmaps;
  * be cleared by process_dinode().
  */
 static void
-quotino_check(xfs_mount_t *mp)
+quotino_check(
+	struct xfs_mount	*mp)
 {
-	ino_tree_node_t *irec;
-
-	if (mp->m_sb.sb_uquotino != NULLFSINO && mp->m_sb.sb_uquotino != 0)  {
-		if (!libxfs_verify_ino(mp, mp->m_sb.sb_uquotino))
-			irec = NULL;
-		else
-			irec = find_inode_rec(mp,
-				XFS_INO_TO_AGNO(mp, mp->m_sb.sb_uquotino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_uquotino));
-
-		if (irec == NULL || is_inode_free(irec,
-				mp->m_sb.sb_uquotino - irec->ino_startnum))  {
-			mp->m_sb.sb_uquotino = NULLFSINO;
-			lost_uquotino = 1;
-		} else
-			lost_uquotino = 0;
-	}
-
-	if (mp->m_sb.sb_gquotino != NULLFSINO && mp->m_sb.sb_gquotino != 0)  {
-		if (!libxfs_verify_ino(mp, mp->m_sb.sb_gquotino))
-			irec = NULL;
-		else
-			irec = find_inode_rec(mp,
-				XFS_INO_TO_AGNO(mp, mp->m_sb.sb_gquotino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_gquotino));
-
-		if (irec == NULL || is_inode_free(irec,
-				mp->m_sb.sb_gquotino - irec->ino_startnum))  {
-			mp->m_sb.sb_gquotino = NULLFSINO;
-			lost_gquotino = 1;
-		} else
-			lost_gquotino = 0;
-	}
-
-	if (mp->m_sb.sb_pquotino != NULLFSINO && mp->m_sb.sb_pquotino != 0)  {
-		if (!libxfs_verify_ino(mp, mp->m_sb.sb_pquotino))
-			irec = NULL;
-		else
-			irec = find_inode_rec(mp,
-				XFS_INO_TO_AGNO(mp, mp->m_sb.sb_pquotino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_pquotino));
-
-		if (irec == NULL || is_inode_free(irec,
-				mp->m_sb.sb_pquotino - irec->ino_startnum))  {
-			mp->m_sb.sb_pquotino = NULLFSINO;
-			lost_pquotino = 1;
-		} else
-			lost_pquotino = 0;
-	}
+	quotino_check_one(mp, XFS_DQTYPE_USER);
+	quotino_check_one(mp, XFS_DQTYPE_GROUP);
+	quotino_check_one(mp, XFS_DQTYPE_PROJ);
 }
 
 static void
@@ -107,14 +91,14 @@ quota_sb_check(xfs_mount_t *mp)
 	 */
 
 	if (fs_quotas &&
-	    (mp->m_sb.sb_uquotino == NULLFSINO || mp->m_sb.sb_uquotino == 0) &&
-	    (mp->m_sb.sb_gquotino == NULLFSINO || mp->m_sb.sb_gquotino == 0) &&
-	    (mp->m_sb.sb_pquotino == NULLFSINO || mp->m_sb.sb_pquotino == 0))  {
+	    !has_quota_inode(XFS_DQTYPE_USER) &&
+	    !has_quota_inode(XFS_DQTYPE_GROUP) &&
+	    !has_quota_inode(XFS_DQTYPE_PROJ))  {
 		lost_quotas = 1;
 		fs_quotas = 0;
-	} else if (libxfs_verify_ino(mp, mp->m_sb.sb_uquotino) &&
-		   libxfs_verify_ino(mp, mp->m_sb.sb_gquotino) &&
-		   libxfs_verify_ino(mp, mp->m_sb.sb_pquotino)) {
+	} else if (libxfs_verify_ino(mp, get_quota_inode(XFS_DQTYPE_USER)) &&
+		   libxfs_verify_ino(mp, get_quota_inode(XFS_DQTYPE_GROUP)) &&
+		   libxfs_verify_ino(mp, get_quota_inode(XFS_DQTYPE_PROJ))) {
 		fs_quotas = 1;
 	}
 }
diff --git a/repair/phase6.c b/repair/phase6.c
index 5dffa8edc87684..acd3051751a6e3 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3192,12 +3192,12 @@ mark_standalone_inodes(xfs_mount_t *mp)
 	if (!fs_quotas)
 		return;
 
-	if (mp->m_sb.sb_uquotino && mp->m_sb.sb_uquotino != NULLFSINO)
-		mark_inode(mp, mp->m_sb.sb_uquotino);
-	if (mp->m_sb.sb_gquotino && mp->m_sb.sb_gquotino != NULLFSINO)
-		mark_inode(mp, mp->m_sb.sb_gquotino);
-	if (mp->m_sb.sb_pquotino && mp->m_sb.sb_pquotino != NULLFSINO)
-		mark_inode(mp, mp->m_sb.sb_pquotino);
+	if (has_quota_inode(XFS_DQTYPE_USER))
+		mark_inode(mp, get_quota_inode(XFS_DQTYPE_USER));
+	if (has_quota_inode(XFS_DQTYPE_GROUP))
+		mark_inode(mp, get_quota_inode(XFS_DQTYPE_GROUP));
+	if (has_quota_inode(XFS_DQTYPE_PROJ))
+		mark_inode(mp, get_quota_inode(XFS_DQTYPE_PROJ));
 }
 
 static void
diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index 11e2d64eb34791..c4baf70e41d6b1 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -203,9 +203,7 @@ quotacheck_adjust(
 		return;
 
 	/* Quota files are not included in quota counts. */
-	if (ino == mp->m_sb.sb_uquotino ||
-	    ino == mp->m_sb.sb_gquotino ||
-	    ino == mp->m_sb.sb_pquotino)
+	if (is_any_quota_inode(ino))
 		return;
 
 	error = -libxfs_iget(mp, NULL, ino, 0, &ip);
@@ -415,20 +413,20 @@ quotacheck_verify(
 
 	switch (type) {
 	case XFS_DQTYPE_USER:
-		ino = mp->m_sb.sb_uquotino;
 		dquots = user_dquots;
 		metafile_type = XFS_METAFILE_USRQUOTA;
 		break;
 	case XFS_DQTYPE_GROUP:
-		ino = mp->m_sb.sb_gquotino;
 		dquots = group_dquots;
 		metafile_type = XFS_METAFILE_GRPQUOTA;
 		break;
 	case XFS_DQTYPE_PROJ:
-		ino = mp->m_sb.sb_pquotino;
 		dquots = proj_dquots;
 		metafile_type = XFS_METAFILE_PRJQUOTA;
 		break;
+	default:
+		ASSERT(0);
+		return;
 	}
 
 	/*
@@ -443,6 +441,7 @@ quotacheck_verify(
 	if (error)
 		do_error(_("could not alloc transaction to open quota file\n"));
 
+	ino = get_quota_inode(type);
 	error = -libxfs_trans_metafile_iget(tp, ino, metafile_type, &ip);
 	if (error) {
 		do_warn(
@@ -505,34 +504,28 @@ qc_has_quotafile(
 	struct xfs_mount	*mp,
 	xfs_dqtype_t		type)
 {
-	bool			lost;
 	xfs_ino_t		ino;
 	unsigned int		qflag;
 
 	switch (type) {
 	case XFS_DQTYPE_USER:
-		lost = lost_uquotino;
-		ino = mp->m_sb.sb_uquotino;
 		qflag = XFS_UQUOTA_CHKD;
 		break;
 	case XFS_DQTYPE_GROUP:
-		lost = lost_gquotino;
-		ino = mp->m_sb.sb_gquotino;
 		qflag = XFS_GQUOTA_CHKD;
 		break;
 	case XFS_DQTYPE_PROJ:
-		lost = lost_pquotino;
-		ino = mp->m_sb.sb_pquotino;
 		qflag = XFS_PQUOTA_CHKD;
 		break;
 	default:
 		return false;
 	}
 
-	if (lost)
+	if (lost_quota_inode(type))
 		return false;
 	if (!(mp->m_sb.sb_qflags & qflag))
 		return false;
+	ino = get_quota_inode(type);
 	if (ino == NULLFSINO || ino == 0)
 		return false;
 	return true;
@@ -626,3 +619,29 @@ quotacheck_teardown(void)
 	qc_purge(&group_dquots);
 	qc_purge(&proj_dquots);
 }
+
+void
+update_sb_quotinos(
+	struct xfs_mount	*mp,
+	struct xfs_buf		*sbp)
+{
+	bool			dirty = false;
+
+	if (mp->m_sb.sb_uquotino != get_quota_inode(XFS_DQTYPE_USER)) {
+		mp->m_sb.sb_uquotino = get_quota_inode(XFS_DQTYPE_USER);
+		dirty = true;
+	}
+
+	if (mp->m_sb.sb_gquotino != get_quota_inode(XFS_DQTYPE_GROUP)) {
+		mp->m_sb.sb_gquotino = get_quota_inode(XFS_DQTYPE_GROUP);
+		dirty = true;
+	}
+
+	if (mp->m_sb.sb_pquotino != get_quota_inode(XFS_DQTYPE_PROJ)) {
+		mp->m_sb.sb_pquotino = get_quota_inode(XFS_DQTYPE_PROJ);
+		dirty = true;
+	}
+
+	if (dirty)
+		libxfs_sb_to_disk(sbp->b_addr, &mp->m_sb);
+}
diff --git a/repair/quotacheck.h b/repair/quotacheck.h
index dcbf1623947b48..36f9f5a12f7f3e 100644
--- a/repair/quotacheck.h
+++ b/repair/quotacheck.h
@@ -13,4 +13,6 @@ uint16_t quotacheck_results(void);
 int quotacheck_setup(struct xfs_mount *mp);
 void quotacheck_teardown(void);
 
+void update_sb_quotinos(struct xfs_mount *mp, struct xfs_buf *sbp);
+
 #endif /* __XFS_REPAIR_QUOTACHECK_H__ */
diff --git a/repair/versions.c b/repair/versions.c
index 7dc91b4597eece..689cc471176da0 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -104,9 +104,6 @@ parse_sb_version(
 	fs_sb_feature_bits = 0;
 	fs_ino_alignment = 0;
 	fs_has_extflgbit = 1;
-	have_uquotino = 0;
-	have_gquotino = 0;
-	have_pquotino = 0;
 
 	if (mp->m_sb.sb_versionnum & XFS_SB_VERSION_SHAREDBIT) {
 		do_warn(_("Shared Version bit set. Not supported. Ever.\n"));
@@ -166,13 +163,13 @@ _("WARNING: you have a V1 inode filesystem. It would be converted to a\n"
 		fs_quotas = 1;
 
 		if (mp->m_sb.sb_uquotino != 0 && mp->m_sb.sb_uquotino != NULLFSINO)
-			have_uquotino = 1;
+			set_quota_inode(XFS_DQTYPE_USER, mp->m_sb.sb_uquotino);
 
 		if (mp->m_sb.sb_gquotino != 0 && mp->m_sb.sb_gquotino != NULLFSINO)
-			have_gquotino = 1;
+			set_quota_inode(XFS_DQTYPE_GROUP, mp->m_sb.sb_gquotino);
 
 		if (mp->m_sb.sb_pquotino != 0 && mp->m_sb.sb_pquotino != NULLFSINO)
-			have_pquotino = 1;
+			set_quota_inode(XFS_DQTYPE_PROJ, mp->m_sb.sb_pquotino);
 	}
 
 	if (xfs_has_align(mp))  {
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 2a8a72e7027591..363f8260bd575a 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -1404,7 +1404,9 @@ _("Inode allocation btrees are too corrupted, skipping phases 6 and 7\n"));
 		free_rtgroup_inodes();
 	}
 
-	if (lost_quotas && !have_uquotino && !have_gquotino && !have_pquotino) {
+	if (lost_quotas && !has_quota_inode(XFS_DQTYPE_USER) &&
+	    !has_quota_inode(XFS_DQTYPE_GROUP) &&
+	    !has_quota_inode(XFS_DQTYPE_PROJ)) {
 		if (!no_modify)  {
 			do_warn(
 _("Warning:  no quota inodes were found.  Quotas disabled.\n"));
@@ -1421,7 +1423,7 @@ _("Warning:  quota inodes were cleared.  Quotas disabled.\n"));
 _("Warning:  quota inodes would be cleared.  Quotas would be disabled.\n"));
 		}
 	} else  {
-		if (lost_uquotino)  {
+		if (lost_quota_inode(XFS_DQTYPE_USER))  {
 			if (!no_modify)  {
 				do_warn(
 _("Warning:  user quota information was cleared.\n"
@@ -1433,7 +1435,7 @@ _("Warning:  user quota information would be cleared.\n"
 			}
 		}
 
-		if (lost_gquotino)  {
+		if (lost_quota_inode(XFS_DQTYPE_GROUP))  {
 			if (!no_modify)  {
 				do_warn(
 _("Warning:  group quota information was cleared.\n"
@@ -1445,7 +1447,7 @@ _("Warning:  group quota information would be cleared.\n"
 			}
 		}
 
-		if (lost_pquotino)  {
+		if (lost_quota_inode(XFS_DQTYPE_PROJ))  {
 			if (!no_modify)  {
 				do_warn(
 _("Warning:  project quota information was cleared.\n"
@@ -1485,6 +1487,8 @@ _("Warning:  project quota information would be cleared.\n"
 	if (!sbp)
 		do_error(_("couldn't get superblock\n"));
 
+	update_sb_quotinos(mp, sbp);
+
 	if ((mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD) != quotacheck_results()) {
 		do_warn(_("Note - quota info will be regenerated on next "
 			"quota mount.\n"));


