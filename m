Return-Path: <linux-xfs+bounces-16637-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 518589F018A
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 02:06:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53C8716B333
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 01:06:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4872117BA9;
	Fri, 13 Dec 2024 01:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="grJtWOsN"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0796A17BA1
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051964; cv=none; b=T97IDFbGLhuBxy6L9MwASayCRV7qUSAX31xBmEj+bsaew6/o8cKIhXuYMZdYO4p0J7PeSCnjEwEkKauX3L/jBipA66rBig8j5B4z2LZPUwYaN/gk8InyOv/3XffaqeexSHgm+k+0/Evi0gbw6d3LJoGyABzPMDfS/0xLmXi6dmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051964; c=relaxed/simple;
	bh=WvbX/zre8tTHsRscoOst/TqChXT9zowUsTojYR40fyY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=efi4loVdK9gV12pF3JpfM5XACWVGaivbREbUWuuiIlrChCkyBZjoXahpIa5JXbbJGzmlrzQ0ke1oIwsUHclekmvqirBNmHRckNaNk6k6Ft20S/N6lH6pquZ90pHKYL1L7Wx5uJJI28dylFwel3ZCy/3wQYJbhqA14PDC3DkhTs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=grJtWOsN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36C7C4CECE;
	Fri, 13 Dec 2024 01:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051963;
	bh=WvbX/zre8tTHsRscoOst/TqChXT9zowUsTojYR40fyY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=grJtWOsNl9lPHcm9CrADLHZR2ZMLDhgYM+ml064cX2+Ex08x79iVzSYkEGIwFbFOJ
	 wVCtxjnsmx1XAVUdaV30DHkunYknJueAzIVQeJ2+G9pcWGoh7KLuBiPntUPu4FcZq3
	 8MIgGECIVFSYzH2D0NkN0SCI5YrmKxKeaWE9u17W135oTb9eS1csk2ihtrQo79ESp5
	 3XVrh2lyDBq+3DpS2C7Y3n/Kt34R7oSG3BHWwJ4+fAJhuctD5976ghO4nj7t83F0Bj
	 Hb1U7m/rJjQr0Y/uuGQFAUk/oe8Wav61RsZmFCA9ZHT2iZfHNI7vgXdVGYXVpLLwo9
	 v+rs+SS7Cbp1A==
Date: Thu, 12 Dec 2024 17:06:03 -0800
Subject: [PATCH 21/37] xfs: scrub the realtime rmapbt
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123675.1181370.3767884091836095098.stgit@frogsfrogsfrogs>
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

Check the realtime reverse mapping btree against the rtbitmap, and
modify the rtbitmap scrub to check against the rtrmapbt.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/Makefile             |    1 
 fs/xfs/libxfs/xfs_fs.h      |    3 -
 fs/xfs/scrub/common.c       |   86 ++++++++++++++++++++
 fs/xfs/scrub/common.h       |   10 ++
 fs/xfs/scrub/health.c       |    1 
 fs/xfs/scrub/inode.c        |    6 -
 fs/xfs/scrub/inode_repair.c |    7 +-
 fs/xfs/scrub/repair.c       |    1 
 fs/xfs/scrub/rtrmap.c       |  184 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c        |    9 ++
 fs/xfs/scrub/scrub.h        |    5 +
 fs/xfs/scrub/stats.c        |    1 
 fs/xfs/scrub/trace.h        |    4 +
 13 files changed, 307 insertions(+), 11 deletions(-)
 create mode 100644 fs/xfs/scrub/rtrmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ff45efb2463f73..136a465e00d2b1 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -194,6 +194,7 @@ xfs-$(CONFIG_XFS_ONLINE_SCRUB_STATS) += scrub/stats.o
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   rgsuper.o \
 				   rtbitmap.o \
+				   rtrmap.o \
 				   rtsummary.o \
 				   )
 
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 7cca458ff81245..34fcbcd0bcd5e3 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -737,9 +737,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
 #define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
 #define XFS_SCRUB_TYPE_RGSUPER	30	/* realtime superblock */
+#define XFS_SCRUB_TYPE_RTRMAPBT	31	/* rtgroup reverse mapping btree */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	31
+#define XFS_SCRUB_TYPE_NR	32
 
 /*
  * This special type code only applies to the vectored scrub implementation.
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 613fb54e723ede..ca43dd4f52b2d6 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -35,6 +35,8 @@
 #include "xfs_exchmaps.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_bmap_util.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -791,9 +793,28 @@ xchk_rtgroup_lock(
 	} while (1);
 
 	sr->rtlock_flags = rtglock_flags;
+
+	if (xfs_has_rtrmapbt(sc->mp) && (rtglock_flags & XFS_RTGLOCK_RMAP))
+		sr->rmap_cur = xfs_rtrmapbt_init_cursor(sc->tp, sr->rtg);
+
 	return 0;
 }
 
+/*
+ * Free all the btree cursors and other incore data relating to the realtime
+ * group.  This has to be done /before/ committing (or cancelling) the scrub
+ * transaction.
+ */
+void
+xchk_rtgroup_btcur_free(
+	struct xchk_rt		*sr)
+{
+	if (sr->rmap_cur)
+		xfs_btree_del_cursor(sr->rmap_cur, XFS_BTREE_ERROR);
+
+	sr->rmap_cur = NULL;
+}
+
 /*
  * Unlock the realtime group.  This must be done /after/ committing (or
  * cancelling) the scrub transaction.
@@ -878,6 +899,14 @@ xchk_setup_fs(
 	return xchk_trans_alloc(sc, resblks);
 }
 
+/* Set us up with a transaction and an empty context to repair rt metadata. */
+int
+xchk_setup_rt(
+	struct xfs_scrub	*sc)
+{
+	return xchk_trans_alloc(sc, 0);
+}
+
 /* Set us up with AG headers and btree cursors. */
 int
 xchk_setup_ag_btree(
@@ -1639,3 +1668,60 @@ xchk_inode_rootdir_inum(const struct xfs_inode *ip)
 		return mp->m_metadirip->i_ino;
 	return mp->m_rootip->i_ino;
 }
+
+static int
+xchk_meta_btree_count_blocks(
+	struct xfs_scrub	*sc,
+	xfs_extnum_t		*nextents,
+	xfs_filblks_t		*count)
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	if (!sc->sr.rtg) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	switch (sc->ip->i_metatype) {
+	case XFS_METAFILE_RTRMAP:
+		cur = xfs_rtrmapbt_init_cursor(sc->tp, sc->sr.rtg);
+		break;
+	default:
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	error = xfs_btree_count_blocks(cur, count);
+	xfs_btree_del_cursor(cur, error);
+	if (!error) {
+		*nextents = 0;
+		(*count)--;	/* don't count the btree iroot */
+	}
+	return error;
+}
+
+/* Count the blocks used by a file, even if it's a metadata inode. */
+int
+xchk_inode_count_blocks(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	xfs_extnum_t		*nextents,
+	xfs_filblks_t		*count)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, whichfork);
+
+	if (!ifp) {
+		*nextents = 0;
+		*count = 0;
+		return 0;
+	}
+
+	if (ifp->if_format == XFS_DINODE_FMT_META_BTREE) {
+		ASSERT(whichfork == XFS_DATA_FORK);
+		return xchk_meta_btree_count_blocks(sc, nextents, count);
+	}
+
+	return xfs_bmap_count_blocks(sc->tp, sc->ip, whichfork, nextents,
+			count);
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index e734572a8dd6ec..1576467f724431 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -63,6 +63,7 @@ static inline int xchk_setup_nothing(struct xfs_scrub *sc)
 /* Setup functions */
 int xchk_setup_agheader(struct xfs_scrub *sc);
 int xchk_setup_fs(struct xfs_scrub *sc);
+int xchk_setup_rt(struct xfs_scrub *sc);
 int xchk_setup_ag_allocbt(struct xfs_scrub *sc);
 int xchk_setup_ag_iallocbt(struct xfs_scrub *sc);
 int xchk_setup_ag_rmapbt(struct xfs_scrub *sc);
@@ -80,10 +81,12 @@ int xchk_setup_metapath(struct xfs_scrub *sc);
 int xchk_setup_rtbitmap(struct xfs_scrub *sc);
 int xchk_setup_rtsummary(struct xfs_scrub *sc);
 int xchk_setup_rgsuperblock(struct xfs_scrub *sc);
+int xchk_setup_rtrmapbt(struct xfs_scrub *sc);
 #else
 # define xchk_setup_rtbitmap		xchk_setup_nothing
 # define xchk_setup_rtsummary		xchk_setup_nothing
 # define xchk_setup_rgsuperblock	xchk_setup_nothing
+# define xchk_setup_rtrmapbt		xchk_setup_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_ino_dqattach(struct xfs_scrub *sc);
@@ -125,7 +128,8 @@ xchk_ag_init_existing(
 #ifdef CONFIG_XFS_RT
 
 /* All the locks we need to check an rtgroup. */
-#define XCHK_RTGLOCK_ALL	(XFS_RTGLOCK_BITMAP)
+#define XCHK_RTGLOCK_ALL	(XFS_RTGLOCK_BITMAP | \
+				 XFS_RTGLOCK_RMAP)
 
 int xchk_rtgroup_init(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
 		struct xchk_rt *sr);
@@ -143,11 +147,13 @@ xchk_rtgroup_init_existing(
 
 int xchk_rtgroup_lock(struct xfs_scrub *sc, struct xchk_rt *sr,
 		unsigned int rtglock_flags);
+void xchk_rtgroup_btcur_free(struct xchk_rt *sr);
 void xchk_rtgroup_free(struct xfs_scrub *sc, struct xchk_rt *sr);
 #else
 # define xchk_rtgroup_init(sc, rgno, sr)		(-EFSCORRUPTED)
 # define xchk_rtgroup_init_existing(sc, rgno, sr)	(-EFSCORRUPTED)
 # define xchk_rtgroup_lock(sc, sr, lockflags)		(-EFSCORRUPTED)
+# define xchk_rtgroup_btcur_free(sr)			do { } while (0)
 # define xchk_rtgroup_free(sc, sr)			do { } while (0)
 #endif /* CONFIG_XFS_RT */
 
@@ -275,6 +281,8 @@ void xchk_fsgates_enable(struct xfs_scrub *sc, unsigned int scrub_fshooks);
 
 int xchk_inode_is_allocated(struct xfs_scrub *sc, xfs_agino_t agino,
 		bool *inuse);
+int xchk_inode_count_blocks(struct xfs_scrub *sc, int whichfork,
+		xfs_extnum_t *nextents, xfs_filblks_t *count);
 
 bool xchk_inode_is_dirtree_root(const struct xfs_inode *ip);
 bool xchk_inode_is_sb_rooted(const struct xfs_inode *ip);
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index ccc6ca5934ca6a..bcc4244e3b55db 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -114,6 +114,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_DIRTREE]	= { XHG_INO, XFS_SICK_INO_DIRTREE },
 	[XFS_SCRUB_TYPE_METAPATH]	= { XHG_FS,  XFS_SICK_FS_METAPATH },
 	[XFS_SCRUB_TYPE_RGSUPER]	= { XHG_RTGROUP, XFS_SICK_RG_SUPER },
+	[XFS_SCRUB_TYPE_RTRMAPBT]	= { XHG_RTGROUP, XFS_SICK_RG_RMAPBT },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 2e911f38deaebe..8e702121dc8699 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -690,15 +690,13 @@ xchk_inode_xref_bmap(
 		return;
 
 	/* Walk all the extents to check nextents/naextents/nblocks. */
-	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
-			&nextents, &count);
+	error = xchk_inode_count_blocks(sc, XFS_DATA_FORK, &nextents, &count);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
 	if (nextents < xfs_dfork_data_extents(dip))
 		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
 
-	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
-			&nextents, &acount);
+	error = xchk_inode_count_blocks(sc, XFS_ATTR_FORK, &nextents, &acount);
 	if (!xchk_should_check_xref(sc, &error, NULL))
 		return;
 	if (nextents != xfs_dfork_attr_extents(dip))
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 7faa27472b9129..a94f9df0ca78f6 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1536,8 +1536,7 @@ xrep_inode_blockcounts(
 	trace_xrep_inode_blockcounts(sc);
 
 	/* Set data fork counters from the data fork mappings. */
-	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
-			&nextents, &count);
+	error = xchk_inode_count_blocks(sc, XFS_DATA_FORK, &nextents, &count);
 	if (error)
 		return error;
 	if (xfs_is_reflink_inode(sc->ip)) {
@@ -1561,8 +1560,8 @@ xrep_inode_blockcounts(
 	/* Set attr fork counters from the attr fork mappings. */
 	ifp = xfs_ifork_ptr(sc->ip, XFS_ATTR_FORK);
 	if (ifp) {
-		error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
-				&nextents, &acount);
+		error = xchk_inode_count_blocks(sc, XFS_ATTR_FORK, &nextents,
+				&acount);
 		if (error)
 			return error;
 		if (count >= sc->mp->m_sb.sb_dblocks)
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 91c8bc055a4fd7..e788e3032f8e33 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -62,6 +62,7 @@ xrep_attempt(
 	trace_xrep_attempt(XFS_I(file_inode(sc->file)), sc->sm, error);
 
 	xchk_ag_btcur_free(&sc->sa);
+	xchk_rtgroup_btcur_free(&sc->sr);
 
 	/* Repair whatever's broken. */
 	ASSERT(sc->ops->repair);
diff --git a/fs/xfs/scrub/rtrmap.c b/fs/xfs/scrub/rtrmap.c
new file mode 100644
index 00000000000000..7b5f932bcd947f
--- /dev/null
+++ b/fs/xfs/scrub/rtrmap.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2018-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_rtalloc.h"
+#include "xfs_rtgroup.h"
+#include "xfs_metafile.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+
+/* Set us up with the realtime metadata locked. */
+int
+xchk_setup_rtrmapbt(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	if (xchk_need_intent_drain(sc))
+		xchk_fsgates_enable(sc, XCHK_FSGATES_DRAIN);
+
+	error = xchk_rtgroup_init(sc, sc->sm->sm_agno, &sc->sr);
+	if (error)
+		return error;
+
+	error = xchk_setup_rt(sc);
+	if (error)
+		return error;
+
+	error = xchk_install_live_inode(sc, rtg_rmap(sc->sr.rtg));
+	if (error)
+		return error;
+
+	return xchk_rtgroup_lock(sc, &sc->sr, XCHK_RTGLOCK_ALL);
+}
+
+/* Realtime reverse mapping. */
+
+struct xchk_rtrmap {
+	/*
+	 * The furthest-reaching of the rmapbt records that we've already
+	 * processed.  This enables us to detect overlapping records for space
+	 * allocations that cannot be shared.
+	 */
+	struct xfs_rmap_irec	overlap_rec;
+
+	/*
+	 * The previous rmapbt record, so that we can check for two records
+	 * that could be one.
+	 */
+	struct xfs_rmap_irec	prev_rec;
+};
+
+/* Flag failures for records that overlap but cannot. */
+STATIC void
+xchk_rtrmapbt_check_overlapping(
+	struct xchk_btree		*bs,
+	struct xchk_rtrmap		*cr,
+	const struct xfs_rmap_irec	*irec)
+{
+	xfs_rtblock_t			pnext, inext;
+
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	/* No previous record? */
+	if (cr->overlap_rec.rm_blockcount == 0)
+		goto set_prev;
+
+	/* Do overlap_rec and irec overlap? */
+	pnext = cr->overlap_rec.rm_startblock + cr->overlap_rec.rm_blockcount;
+	if (pnext <= irec->rm_startblock)
+		goto set_prev;
+
+	xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	/* Save whichever rmap record extends furthest. */
+	inext = irec->rm_startblock + irec->rm_blockcount;
+	if (pnext > inext)
+		return;
+
+set_prev:
+	memcpy(&cr->overlap_rec, irec, sizeof(struct xfs_rmap_irec));
+}
+
+/* Decide if two reverse-mapping records can be merged. */
+static inline bool
+xchk_rtrmap_mergeable(
+	struct xchk_rtrmap		*cr,
+	const struct xfs_rmap_irec	*r2)
+{
+	const struct xfs_rmap_irec	*r1 = &cr->prev_rec;
+
+	/* Ignore if prev_rec is not yet initialized. */
+	if (cr->prev_rec.rm_blockcount == 0)
+		return false;
+
+	if (r1->rm_owner != r2->rm_owner)
+		return false;
+	if (r1->rm_startblock + r1->rm_blockcount != r2->rm_startblock)
+		return false;
+	if ((unsigned long long)r1->rm_blockcount + r2->rm_blockcount >
+	    XFS_RMAP_LEN_MAX)
+		return false;
+	if (r1->rm_flags != r2->rm_flags)
+		return false;
+	return r1->rm_offset + r1->rm_blockcount == r2->rm_offset;
+}
+
+/* Flag failures for records that could be merged. */
+STATIC void
+xchk_rtrmapbt_check_mergeable(
+	struct xchk_btree		*bs,
+	struct xchk_rtrmap		*cr,
+	const struct xfs_rmap_irec	*irec)
+{
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return;
+
+	if (xchk_rtrmap_mergeable(cr, irec))
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+
+	memcpy(&cr->prev_rec, irec, sizeof(struct xfs_rmap_irec));
+}
+
+/* Scrub a realtime rmapbt record. */
+STATIC int
+xchk_rtrmapbt_rec(
+	struct xchk_btree		*bs,
+	const union xfs_btree_rec	*rec)
+{
+	struct xchk_rtrmap		*cr = bs->private;
+	struct xfs_rmap_irec		irec;
+
+	if (xfs_rmap_btrec_to_irec(rec, &irec) != NULL ||
+	    xfs_rtrmap_check_irec(to_rtg(bs->cur->bc_group), &irec) != NULL) {
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return 0;
+	}
+
+	if (bs->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return 0;
+
+	xchk_rtrmapbt_check_mergeable(bs, cr, &irec);
+	xchk_rtrmapbt_check_overlapping(bs, cr, &irec);
+	return 0;
+}
+
+/* Scrub the realtime rmap btree. */
+int
+xchk_rtrmapbt(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_inode	*ip = rtg_rmap(sc->sr.rtg);
+	struct xfs_owner_info	oinfo;
+	struct xchk_rtrmap	cr = { };
+	int			error;
+
+	error = xchk_metadata_inode_forks(sc);
+	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+		return error;
+
+	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, XFS_DATA_FORK);
+	return xchk_btree(sc, sc->sr.rmap_cur, xchk_rtrmapbt_rec, &oinfo, &cr);
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 652d347cee9929..09983899c34164 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -218,6 +218,8 @@ xchk_teardown(
 	int			error)
 {
 	xchk_ag_free(sc, &sc->sa);
+	xchk_rtgroup_btcur_free(&sc->sr);
+
 	if (sc->tp) {
 		if (error == 0 && (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
 			error = xfs_trans_commit(sc->tp);
@@ -458,6 +460,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.has	= xfs_has_rtsb,
 		.repair = xrep_rgsuperblock,
 	},
+	[XFS_SCRUB_TYPE_RTRMAPBT] = {	/* realtime group rmapbt */
+		.type	= ST_RTGROUP,
+		.setup	= xchk_setup_rtrmapbt,
+		.scrub	= xchk_rtrmapbt,
+		.has	= xfs_has_rtrmapbt,
+		.repair	= xrep_notsupported,
+	},
 };
 
 static int
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 5dbbe93cb49bfa..0ad5122af486e1 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -126,6 +126,9 @@ struct xchk_rt {
 
 	/* XFS_RTGLOCK_* lock state if locked */
 	unsigned int		rtlock_flags;
+
+	/* rtgroup btrees */
+	struct xfs_btree_cur	*rmap_cur;
 };
 
 struct xfs_scrub {
@@ -280,10 +283,12 @@ int xchk_metapath(struct xfs_scrub *sc);
 int xchk_rtbitmap(struct xfs_scrub *sc);
 int xchk_rtsummary(struct xfs_scrub *sc);
 int xchk_rgsuperblock(struct xfs_scrub *sc);
+int xchk_rtrmapbt(struct xfs_scrub *sc);
 #else
 # define xchk_rtbitmap		xchk_nothing
 # define xchk_rtsummary		xchk_nothing
 # define xchk_rgsuperblock	xchk_nothing
+# define xchk_rtrmapbt		xchk_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_quota(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index a476c7b2ab7597..eb6bb170c902b3 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -82,6 +82,7 @@ static const char *name_map[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_DIRTREE]	= "dirtree",
 	[XFS_SCRUB_TYPE_METAPATH]	= "metapath",
 	[XFS_SCRUB_TYPE_RGSUPER]	= "rgsuper",
+	[XFS_SCRUB_TYPE_RTRMAPBT]	= "rtrmapbt",
 };
 
 /* Format the scrub stats into a text buffer, similar to pcp style. */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d2ae7e93acb08e..5afc440f22f56c 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -72,6 +72,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_DIRTREE);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_BARRIER);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_METAPATH);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGSUPER);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTRMAPBT);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -105,7 +106,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RGSUPER);
 	{ XFS_SCRUB_TYPE_DIRTREE,	"dirtree" }, \
 	{ XFS_SCRUB_TYPE_BARRIER,	"barrier" }, \
 	{ XFS_SCRUB_TYPE_METAPATH,	"metapath" }, \
-	{ XFS_SCRUB_TYPE_RGSUPER,	"rgsuper" }
+	{ XFS_SCRUB_TYPE_RGSUPER,	"rgsuper" }, \
+	{ XFS_SCRUB_TYPE_RTRMAPBT,	"rtrmapbt" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \


