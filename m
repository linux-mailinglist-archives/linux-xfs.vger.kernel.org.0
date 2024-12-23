Return-Path: <linux-xfs+bounces-17399-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FDE99FB696
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Dec 2024 22:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56445166678
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Dec 2024 21:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ACD21B395B;
	Mon, 23 Dec 2024 21:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ga6biTF0"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7BB1422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991015; cv=none; b=XuQlhtJHiDoencKosH6uJWXNtvutAB8pQhim8QMFJ2YKVWjdw8JnD/pxhs8K5I5BVkxSo3eeg1IGsLtXKUEnd30Mj6b2+4gM1ByluZNxumUY4ivBsxEmz+UbvfFyP/E2mSD7OYg33WvLzERrrFA22SMeRc1WXPpKpPiNxckjbTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991015; c=relaxed/simple;
	bh=oDv/LMlfq1OwKKxbi0xHhiAI8bRkuM2m4+EjLXNhm/c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XD/TB8QpeNxkSDCO29jO0/1HI3j7DqP62RcgwVe1/egsGQxrqrRnWk/W1Yc2XUONGacD6x93j7TjnM47Q/ybfsIit3J9NjE6JaaE03z5nFr9sIMpuinOJ48DjFE3a8AYtj9QMOBYNGa9OEHkpoaimj7FohDT6oF+FqilHLu2Kl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ga6biTF0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C269C4CED3;
	Mon, 23 Dec 2024 21:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991015;
	bh=oDv/LMlfq1OwKKxbi0xHhiAI8bRkuM2m4+EjLXNhm/c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ga6biTF0gdaPmEKgHTY+8oNVkKV561roEcSgrrTFxmxcoS2eU5CVT7vQ/hlN9l6fL
	 gqIykZ73rDYr8afAysHznudAOy7fFt5gMN4VaBzSjY1Cb7GzS4uw5Q/0y3/ArX613a
	 EBfHywDiag1dLamdrme9CDWfEu/7dr2gf64D6IJbonzDNmXrvaDDEvbQotJSaR8mu4
	 TSEiIjJssbQP9C7/mEGRYOVvZiORbqDp3HolR0Bdr/B+w7GJkx+BqvxnLGq6+PTZda
	 e5WwhNwviD2OF0R/whksJjEOYBQucsfdcEoDK5IV5sghpM63033VRgWDh30yIEZXTH
	 FYHx9K2jvAC1w==
Date: Mon, 23 Dec 2024 13:56:55 -0800
Subject: [PATCH 40/41] xfs_repair: refactor generate_rtinfo
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941582.2294268.16026971866728598437.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Move the allocation of the computed values into generate_rtinfo, and thus
make the variables holding them private in rt.c, and clean up a few
formatting nits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
[djwong: move functions to fix build errors]
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/globals.c |    5 --
 repair/globals.h |    5 --
 repair/phase5.c  |    3 -
 repair/phase6.c  |   51 +----------------
 repair/rt.c      |  160 ++++++++++++++++++++++++++++++++----------------------
 repair/rt.h      |   12 +---
 6 files changed, 104 insertions(+), 132 deletions(-)


diff --git a/repair/globals.c b/repair/globals.c
index b63931be9fdb70..bd07a9656d193b 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -87,11 +87,6 @@ unsigned int	glob_agcount;
 int		chunks_pblock;	/* # of 64-ino chunks per allocation */
 int		max_symlink_blocks;
 
-/* realtime info */
-
-union xfs_rtword_raw	*btmcompute;
-union xfs_suminfo_raw	*sumcompute;
-
 /* inode tree records have full or partial backptr fields ? */
 
 int	full_ino_ex_data;	/*
diff --git a/repair/globals.h b/repair/globals.h
index 1dc85ce7f8114c..ebe8d5ee132b8d 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -128,11 +128,6 @@ extern unsigned int	glob_agcount;
 extern int		chunks_pblock;	/* # of 64-ino chunks per allocation */
 extern int		max_symlink_blocks;
 
-/* realtime info */
-
-extern union xfs_rtword_raw		*btmcompute;
-extern union xfs_suminfo_raw		*sumcompute;
-
 /* inode tree records have full or partial backptr fields ? */
 
 extern int		full_ino_ex_data;/*
diff --git a/repair/phase5.c b/repair/phase5.c
index a5e19998b97061..91c4a8662a69f2 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -627,8 +627,7 @@ void
 check_rtmetadata(
 	struct xfs_mount	*mp)
 {
-	rtinit(mp);
-	generate_rtinfo(mp, btmcompute, sumcompute);
+	generate_rtinfo(mp);
 	check_rtbitmap(mp);
 	check_rtsummary(mp);
 }
diff --git a/repair/phase6.c b/repair/phase6.c
index 3dd67f7e0ec051..44677096873a54 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -19,6 +19,7 @@
 #include "progress.h"
 #include "versions.h"
 #include "repair/pptr.h"
+#include "repair/rt.h"
 
 static xfs_ino_t		orphanage_ino;
 
@@ -556,52 +557,6 @@ mk_rbmino(
 	libxfs_irele(ip);
 }
 
-static void
-fill_rbmino(
-	struct xfs_mount	*mp)
-{
-	struct xfs_inode	*ip;
-	int			error;
-
-	error = -libxfs_metafile_iget(mp, mp->m_sb.sb_rbmino,
-			XFS_METAFILE_RTBITMAP, &ip);
-	if (error)
-		do_error(
-_("couldn't iget realtime bitmap inode, error %d\n"), error);
-
-	error = -libxfs_rtfile_initialize_blocks(ip, 0, mp->m_sb.sb_rbmblocks,
-			btmcompute);
-	if (error)
-		do_error(
-_("couldn't re-initialize realtime bitmap inode, error %d\n"), error);
-
-	libxfs_irele(ip);
-}
-
-static void
-fill_rsumino(
-	struct xfs_mount	*mp)
-{
-	struct xfs_inode	*ip;
-	int			error;
-
-	error = -libxfs_metafile_iget(mp, mp->m_sb.sb_rsumino,
-			XFS_METAFILE_RTSUMMARY, &ip);
-	if (error)
-		do_error(
-_("couldn't iget realtime summary inode, error %d\n"), error);
-
-	mp->m_rsumip = ip;
-	error = -libxfs_rtfile_initialize_blocks(ip, 0, mp->m_rsumblocks,
-			sumcompute);
-	mp->m_rsumip = NULL;
-	if (error)
-		do_error(
-_("couldn't re-initialize realtime summary inode, error %d\n"), error);
-
-	libxfs_irele(ip);
-}
-
 static void
 mk_rsumino(
 	struct xfs_mount	*mp)
@@ -3335,8 +3290,8 @@ phase6(xfs_mount_t *mp)
 	if (!no_modify)  {
 		do_log(
 _("        - resetting contents of realtime bitmap and summary inodes\n"));
-		fill_rbmino(mp);
-		fill_rsumino(mp);
+		fill_rtbitmap(mp);
+		fill_rtsummary(mp);
 	}
 
 	mark_standalone_inodes(mp);
diff --git a/repair/rt.c b/repair/rt.c
index 9ae421168e84b4..d0a171020c4b49 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -14,31 +14,9 @@
 #include "err_protos.h"
 #include "rt.h"
 
-void
-rtinit(xfs_mount_t *mp)
-{
-	unsigned long long	wordcnt;
-
-	if (mp->m_sb.sb_rblocks == 0)
-		return;
-
-	/*
-	 * Allocate buffers for formatting the collected rt free space
-	 * information.  The rtbitmap buffer must be large enough to compare
-	 * against any unused bytes in the last block of the file.
-	 */
-	wordcnt = XFS_FSB_TO_B(mp, mp->m_sb.sb_rbmblocks) >> XFS_WORDLOG;
-	btmcompute = calloc(wordcnt, sizeof(union xfs_rtword_raw));
-	if (!btmcompute)
-		do_error(
-	_("couldn't allocate memory for incore realtime bitmap.\n"));
-
-	wordcnt = XFS_FSB_TO_B(mp, mp->m_rsumblocks) >> XFS_WORDLOG;
-	sumcompute = calloc(wordcnt, sizeof(union xfs_suminfo_raw));
-	if (!sumcompute)
-		do_error(
-	_("couldn't allocate memory for incore realtime summary info.\n"));
-}
+/* Computed rt bitmap/summary data */
+static union xfs_rtword_raw	*btmcompute;
+static union xfs_suminfo_raw	*sumcompute;
 
 static inline void
 set_rtword(
@@ -64,58 +42,66 @@ inc_sumcount(
  * generate the real-time bitmap and summary info based on the
  * incore realtime extent map.
  */
-int
+void
 generate_rtinfo(
-	struct xfs_mount	*mp,
-	union xfs_rtword_raw	*words,
-	union xfs_suminfo_raw	*sumcompute)
+	struct xfs_mount	*mp)
 {
-	xfs_rtxnum_t	extno;
-	xfs_rtxnum_t	start_ext;
-	int		bitsperblock;
-	int		bmbno;
-	xfs_rtword_t	freebit;
-	xfs_rtword_t	bits;
-	int		start_bmbno;
-	int		i;
-	int		offs;
-	int		log;
-	int		len;
-	int		in_extent;
+	unsigned int		bitsperblock =
+		mp->m_blockwsize << XFS_NBWORDLOG;
+	xfs_rtxnum_t		extno = 0;
+	xfs_rtxnum_t		start_ext = 0;
+	int			bmbno = 0;
+	int			start_bmbno = 0;
+	bool			in_extent = false;
+	unsigned long long	wordcnt;
+	union xfs_rtword_raw	*words;
+
+	wordcnt = XFS_FSB_TO_B(mp, mp->m_sb.sb_rbmblocks) >> XFS_WORDLOG;
+	btmcompute = calloc(wordcnt, sizeof(union xfs_rtword_raw));
+	if (!btmcompute)
+		do_error(
+_("couldn't allocate memory for incore realtime bitmap.\n"));
+	words = btmcompute;
+
+	wordcnt = XFS_FSB_TO_B(mp, mp->m_rsumblocks) >> XFS_WORDLOG;
+	sumcompute = calloc(wordcnt, sizeof(union xfs_suminfo_raw));
+	if (!sumcompute)
+		do_error(
+_("couldn't allocate memory for incore realtime summary info.\n"));
 
 	ASSERT(mp->m_rbmip == NULL);
 
-	bitsperblock = mp->m_blockwsize << XFS_NBWORDLOG;
-	extno = start_ext = 0;
-	bmbno = in_extent = start_bmbno = 0;
-
 	/*
-	 * slower but simple, don't play around with trying to set
-	 * things one word at a time, just set bit as required.
-	 * Have to * track start and end (size) of each range of
-	 * free extents to set the summary info properly.
+	 * Slower but simple, don't play around with trying to set things one
+	 * word at a time, just set bit as required.  Have to track start and
+	 * end (size) of each range of free extents to set the summary info
+	 * properly.
 	 */
 	while (extno < mp->m_sb.sb_rextents)  {
-		freebit = 1;
+		xfs_rtword_t		freebit = 1;
+		xfs_rtword_t		bits = 0;
+		int			i;
+
 		set_rtword(mp, words, 0);
-		bits = 0;
 		for (i = 0; i < sizeof(xfs_rtword_t) * NBBY &&
 				extno < mp->m_sb.sb_rextents; i++, extno++)  {
 			if (get_rtbmap(extno) == XR_E_FREE)  {
 				sb_frextents++;
 				bits |= freebit;
 
-				if (in_extent == 0) {
+				if (!in_extent) {
 					start_ext = extno;
 					start_bmbno = bmbno;
-					in_extent = 1;
+					in_extent = true;
 				}
-			} else if (in_extent == 1) {
-				len = (int) (extno - start_ext);
-				log = libxfs_highbit64(len);
-				offs = xfs_rtsumoffs(mp, log, start_bmbno);
+			} else if (in_extent) {
+				uint64_t	len = extno - start_ext;
+				xfs_rtsumoff_t	offs;
+
+				offs = xfs_rtsumoffs(mp, libxfs_highbit64(len),
+						start_bmbno);
 				inc_sumcount(mp, sumcompute, offs);
-				in_extent = 0;
+				in_extent = false;
 			}
 
 			freebit <<= 1;
@@ -126,10 +112,12 @@ generate_rtinfo(
 		if (extno % bitsperblock == 0)
 			bmbno++;
 	}
-	if (in_extent == 1) {
-		len = (int) (extno - start_ext);
-		log = libxfs_highbit64(len);
-		offs = xfs_rtsumoffs(mp, log, start_bmbno);
+
+	if (in_extent) {
+		uint64_t	len = extno - start_ext;
+		xfs_rtsumoff_t	offs;
+
+		offs = xfs_rtsumoffs(mp, libxfs_highbit64(len), start_bmbno);
 		inc_sumcount(mp, sumcompute, offs);
 	}
 
@@ -137,8 +125,6 @@ generate_rtinfo(
 		do_warn(_("sb_frextents %" PRIu64 ", counted %" PRIu64 "\n"),
 				mp->m_sb.sb_frextents, sb_frextents);
 	}
-
-	return(0);
 }
 
 static void
@@ -245,3 +231,49 @@ check_rtsummary(
 
 	check_rtfile_contents(mp, XFS_METAFILE_RTSUMMARY, mp->m_rsumblocks);
 }
+
+void
+fill_rtbitmap(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inode	*ip;
+	int			error;
+
+	error = -libxfs_metafile_iget(mp, mp->m_sb.sb_rbmino,
+			XFS_METAFILE_RTBITMAP, &ip);
+	if (error)
+		do_error(
+_("couldn't iget realtime bitmap inode, error %d\n"), error);
+
+	error = -libxfs_rtfile_initialize_blocks(ip, 0, mp->m_sb.sb_rbmblocks,
+			btmcompute);
+	if (error)
+		do_error(
+_("couldn't re-initialize realtime bitmap inode, error %d\n"), error);
+
+	libxfs_irele(ip);
+}
+
+void
+fill_rtsummary(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inode	*ip;
+	int			error;
+
+	error = -libxfs_metafile_iget(mp, mp->m_sb.sb_rsumino,
+			XFS_METAFILE_RTSUMMARY, &ip);
+	if (error)
+		do_error(
+_("couldn't iget realtime summary inode, error %d\n"), error);
+
+	mp->m_rsumip = ip;
+	error = -libxfs_rtfile_initialize_blocks(ip, 0, mp->m_rsumblocks,
+			sumcompute);
+	mp->m_rsumip = NULL;
+	if (error)
+		do_error(
+_("couldn't re-initialize realtime summary inode, error %d\n"), error);
+
+	libxfs_irele(ip);
+}
diff --git a/repair/rt.h b/repair/rt.h
index 862695487bcd4c..f8caa5dc874ec2 100644
--- a/repair/rt.h
+++ b/repair/rt.h
@@ -6,15 +6,11 @@
 #ifndef _XFS_REPAIR_RT_H_
 #define _XFS_REPAIR_RT_H_
 
-struct blkmap;
-
-void
-rtinit(xfs_mount_t		*mp);
-
-int generate_rtinfo(struct xfs_mount *mp, union xfs_rtword_raw *words,
-		union xfs_suminfo_raw *sumcompute);
-
+void generate_rtinfo(struct xfs_mount *mp);
 void check_rtbitmap(struct xfs_mount *mp);
 void check_rtsummary(struct xfs_mount *mp);
 
+void fill_rtbitmap(struct xfs_mount *mp);
+void fill_rtsummary(struct xfs_mount *mp);
+
 #endif /* _XFS_REPAIR_RT_H_ */


