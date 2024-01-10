Return-Path: <linux-xfs+bounces-2065-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D1B6821156
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:42:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9553C1C21C0C
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 23:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2910C2D4;
	Sun, 31 Dec 2023 23:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vz4DorRe"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5B6C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326CBC433C8;
	Sun, 31 Dec 2023 23:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066142;
	bh=qUkzTzm5QKuzlovIRvl2YhL1vFCovFp8kYeddOO3T3A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vz4DorRei2BLorf6IIjmhvNHOPQPbUeGD3Iq8lN9OFaqFnnYu/UKSsDuFvYeMkhkf
	 Z087uDCv/69J/RGiXsoVtvXrjGRa7iXlQrjZ0EEKI68EF8xrL2TlQ6IgORu3Rc07o0
	 X8W7+H92Bs7Fm4pKoClvK0BBc1bSQ8Lb2drY2rTGifsmRo11+t3+7t7IHoH0O0pihD
	 1zp+MEn7hpsBCfXHmltDL4mJ/spS1F9StUeiRU/hUgZteYTpyc04qtgF3GKqQ/sd8L
	 7ot69YYvHDobRh8FH/f8XEV/9Sk2Kd4yKR3O/Y05FUA7qEdGSVqn22+clVixmgCMEY
	 0ar/e66wSWFWw==
Date: Sun, 31 Dec 2023 15:42:21 -0800
Subject: [PATCH 49/58] xfs_repair: mark space used by metadata files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010600.1809361.15192493026697894678.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

Track space used by metadata files as a separate incore extent type.
This ensures that we can warn about cross-linked metadata files, even
though we are going to rebuild the entire metadata directory tree in the
end.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |   31 +++++++++++++
 repair/dinode.c      |  121 ++++++++++++++++++++++++++++++++++++++------------
 repair/dinode.h      |    6 ++
 repair/incore.h      |   39 ++++++++++------
 repair/incore_ino.c  |    2 -
 repair/phase4.c      |    2 +
 repair/scan.c        |   30 +++++++++++-
 7 files changed, 179 insertions(+), 52 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 479dc9db760..7e18991a3d5 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -141,6 +141,16 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		_("uncertain inode block %d/%d already known\n"),
 				agno, agbno);
 			break;
+		case XR_E_METADATA:
+			/*
+			 * Files in the metadata directory tree are always
+			 * reconstructed, so it's ok to let go if this block
+			 * is also a valid inode cluster.
+			 */
+			do_warn(
+		_("inode block %d/%d claimed by metadata file\n"),
+				agno, agbno);
+			fallthrough;
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
@@ -430,6 +440,7 @@ verify_inode_chunk(xfs_mount_t		*mp,
 			set_bmap_ext(agno, cur_agbno, blen, XR_E_MULT);
 			pthread_mutex_unlock(&ag_locks[agno].lock);
 			return 0;
+		case XR_E_METADATA:
 		case XR_E_INO:
 			do_error(
 	_("uncertain inode block overlap, agbno = %d, ino = %" PRIu64 "\n"),
@@ -474,6 +485,16 @@ verify_inode_chunk(xfs_mount_t		*mp,
 		_("uncertain inode block %" PRIu64 " already known\n"),
 				XFS_AGB_TO_FSB(mp, agno, cur_agbno));
 			break;
+		case XR_E_METADATA:
+			/*
+			 * Files in the metadata directory tree are always
+			 * reconstructed, so it's ok to let go if this block
+			 * is also a valid inode cluster.
+			 */
+			do_warn(
+		_("inode block %d/%d claimed by metadata file\n"),
+				agno, agbno);
+			fallthrough;
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
@@ -559,6 +580,16 @@ process_inode_agbno_state(
 	switch (state) {
 	case XR_E_INO:	/* already marked */
 		break;
+	case XR_E_METADATA:
+		/*
+		 * Files in the metadata directory tree are always
+		 * reconstructed, so it's ok to let go if this block is also a
+		 * valid inode cluster.
+		 */
+		do_warn(
+	_("inode block %d/%d claimed by metadata file\n"),
+			agno, agbno);
+		fallthrough;
 	case XR_E_UNKNOWN:
 	case XR_E_FREE:
 	case XR_E_FREE1:
diff --git a/repair/dinode.c b/repair/dinode.c
index 9b7309afcaf..52830a85a6f 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -220,6 +220,7 @@ static int
 process_rt_rec_state(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
+	bool			zap_metadata,
 	struct xfs_bmbt_irec	*irec)
 {
 	xfs_fsblock_t		b = irec->br_startblock;
@@ -256,7 +257,13 @@ _("data fork in rt inode %" PRIu64 " found invalid rt extent %"PRIu64" state %d
 		switch (state)  {
 		case XR_E_FREE:
 		case XR_E_UNKNOWN:
-			set_rtbmap(ext, XR_E_INUSE);
+			set_rtbmap(ext, zap_metadata ? XR_E_METADATA :
+						       XR_E_INUSE);
+			break;
+		case XR_E_METADATA:
+			do_error(
+_("data fork in rt inode %" PRIu64 " found metadata file block %" PRIu64 " in rt bmap\n"),
+				ino, ext);
 			break;
 		case XR_E_BAD_STATE:
 			do_error(
@@ -293,7 +300,8 @@ process_rt_rec(
 	struct xfs_bmbt_irec	*irec,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
-	int			check_dups)
+	int			check_dups,
+	bool			zap_metadata)
 {
 	xfs_fsblock_t		lastb;
 	int			bad;
@@ -333,7 +341,7 @@ _("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
 	if (check_dups)
 		bad = process_rt_rec_dups(mp, ino, irec);
 	else
-		bad = process_rt_rec_state(mp, ino, irec);
+		bad = process_rt_rec_state(mp, ino, zap_metadata, irec);
 	if (bad)
 		return bad;
 
@@ -364,7 +372,8 @@ process_bmbt_reclist_int(
 	xfs_fileoff_t		*first_key,
 	xfs_fileoff_t		*last_key,
 	int			check_dups,
-	int			whichfork)
+	int			whichfork,
+	bool			zap_metadata)
 {
 	xfs_bmbt_irec_t		irec;
 	xfs_filblks_t		cp = 0;		/* prev count */
@@ -443,7 +452,8 @@ _("zero length extent (off = %" PRIu64 ", fsbno = %" PRIu64 ") in ino %" PRIu64
 
 		if (type == XR_INO_RTDATA && whichfork == XFS_DATA_FORK) {
 			pthread_mutex_lock(&rt_lock.lock);
-			error2 = process_rt_rec(mp, &irec, ino, tot, check_dups);
+			error2 = process_rt_rec(mp, &irec, ino, tot, check_dups,
+					zap_metadata);
 			pthread_mutex_unlock(&rt_lock.lock);
 			if (error2)
 				return error2;
@@ -558,6 +568,11 @@ _("%s fork in ino %" PRIu64 " claims free block %" PRIu64 "\n"),
 			case XR_E_INUSE_FS1:
 				do_warn(_("rmap claims metadata use!\n"));
 				fallthrough;
+			case XR_E_METADATA:
+				do_warn(
+_("%s fork in inode %" PRIu64 " claims metadata file block %" PRIu64 "\n"),
+					forkname, ino, b);
+				break;
 			case XR_E_FS_MAP:
 			case XR_E_INO:
 			case XR_E_INUSE_FS:
@@ -614,15 +629,28 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 		for (; agbno < ebno; agbno += blen) {
 			state = get_bmap_ext(agno, agbno, ebno, &blen);
 			switch (state)  {
+			case XR_E_METADATA:
+				/*
+				 * The entire metadata directory tree is rebuilt
+				 * every time, so we can let regular files take
+				 * ownership of this block.
+				 */
+				if (zap_metadata)
+					break;
+				fallthrough;
 			case XR_E_FREE:
 			case XR_E_FREE1:
 			case XR_E_INUSE1:
 			case XR_E_UNKNOWN:
-				set_bmap_ext(agno, agbno, blen, XR_E_INUSE);
+				set_bmap_ext(agno, agbno, blen, zap_metadata ?
+						XR_E_METADATA : XR_E_INUSE);
 				break;
+
 			case XR_E_INUSE:
 			case XR_E_MULT:
-				set_bmap_ext(agno, agbno, blen, XR_E_MULT);
+				if (!zap_metadata)
+					set_bmap_ext(agno, agbno, blen,
+							XR_E_MULT);
 				break;
 			default:
 				break;
@@ -661,10 +689,12 @@ process_bmbt_reclist(
 	blkmap_t		**blkmapp,
 	xfs_fileoff_t		*first_key,
 	xfs_fileoff_t		*last_key,
-	int			whichfork)
+	int			whichfork,
+	bool			zap_metadata)
 {
 	return process_bmbt_reclist_int(mp, rp, numrecs, type, ino, tot,
-				blkmapp, first_key, last_key, 0, whichfork);
+				blkmapp, first_key, last_key, 0, whichfork,
+				zap_metadata);
 }
 
 /*
@@ -679,13 +709,15 @@ scan_bmbt_reclist(
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
-	int			whichfork)
+	int			whichfork,
+	bool			zap_metadata)
 {
 	xfs_fileoff_t		first_key = 0;
 	xfs_fileoff_t		last_key = 0;
 
 	return process_bmbt_reclist_int(mp, rp, numrecs, type, ino, tot,
-				NULL, &first_key, &last_key, 1, whichfork);
+				NULL, &first_key, &last_key, 1, whichfork,
+				zap_metadata);
 }
 
 /*
@@ -760,7 +792,8 @@ process_btinode(
 	xfs_extnum_t		*nex,
 	blkmap_t		**blkmapp,
 	int			whichfork,
-	int			check_dups)
+	int			check_dups,
+	bool			zap_metadata)
 {
 	xfs_bmdr_block_t	*dib;
 	xfs_fileoff_t		last_key;
@@ -839,8 +872,8 @@ _("bad bmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
 
 		if (scan_lbtree(get_unaligned_be64(&pp[i]), level, scan_bmapbt,
 				type, whichfork, lino, tot, nex, blkmapp,
-				&cursor, 1, check_dups, magic, NULL,
-				&xfs_bmbt_buf_ops))
+				&cursor, 1, check_dups, magic,
+				(void *)zap_metadata, &xfs_bmbt_buf_ops))
 			return(1);
 		/*
 		 * fix key (offset) mismatches between the keys in root
@@ -935,7 +968,8 @@ process_exinode(
 	xfs_extnum_t		*nex,
 	blkmap_t		**blkmapp,
 	int			whichfork,
-	int			check_dups)
+	int			check_dups,
+	bool			zap_metadata)
 {
 	xfs_ino_t		lino;
 	xfs_bmbt_rec_t		*rp;
@@ -969,10 +1003,10 @@ process_exinode(
 	if (check_dups == 0)
 		ret = process_bmbt_reclist(mp, rp, &numrecs, type, lino,
 					tot, blkmapp, &first_key, &last_key,
-					whichfork);
+					whichfork, zap_metadata);
 	else
 		ret = scan_bmbt_reclist(mp, rp, &numrecs, type, lino, tot,
-					whichfork);
+					whichfork, zap_metadata);
 
 	*nex = numrecs;
 	return ret;
@@ -1898,7 +1932,8 @@ process_inode_data_fork(
 	xfs_extnum_t		*nextents,
 	blkmap_t		**dblkmap,
 	int			check_dups,
-	struct xfs_buf		**ino_bpp)
+	struct xfs_buf		**ino_bpp,
+	bool			zap_metadata)
 {
 	struct xfs_dinode	*dino = *dinop;
 	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
@@ -1939,14 +1974,14 @@ process_inode_data_fork(
 			try_rebuild = 1;
 		err = process_exinode(mp, agno, ino, dino, type, dirty,
 			totblocks, nextents, dblkmap, XFS_DATA_FORK,
-			check_dups);
+			check_dups, zap_metadata);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (!rmapbt_suspect && try_rebuild == -1)
 			try_rebuild = 1;
 		err = process_btinode(mp, agno, ino, dino, type, dirty,
 			totblocks, nextents, dblkmap, XFS_DATA_FORK,
-			check_dups);
+			check_dups, zap_metadata);
 		break;
 	case XFS_DINODE_FMT_DEV:
 		err = 0;
@@ -1999,12 +2034,12 @@ _("would have tried to rebuild inode %"PRIu64" data fork\n"),
 		case XFS_DINODE_FMT_EXTENTS:
 			err = process_exinode(mp, agno, ino, dino, type,
 				dirty, totblocks, nextents, dblkmap,
-				XFS_DATA_FORK, 0);
+				XFS_DATA_FORK, 0, zap_metadata);
 			break;
 		case XFS_DINODE_FMT_BTREE:
 			err = process_btinode(mp, agno, ino, dino, type,
 				dirty, totblocks, nextents, dblkmap,
-				XFS_DATA_FORK, 0);
+				XFS_DATA_FORK, 0, zap_metadata);
 			break;
 		case XFS_DINODE_FMT_DEV:
 			err = 0;
@@ -2039,7 +2074,8 @@ process_inode_attr_fork(
 	int			check_dups,
 	int			extra_attr_check,
 	int			*retval,
-	struct xfs_buf		**ino_bpp)
+	struct xfs_buf		**ino_bpp,
+	bool			zap_metadata)
 {
 	xfs_ino_t		lino = XFS_AGINO_TO_INO(mp, agno, ino);
 	struct xfs_dinode	*dino = *dinop;
@@ -2087,7 +2123,7 @@ process_inode_attr_fork(
 		*anextents = 0;
 		err = process_exinode(mp, agno, ino, dino, type, dirty,
 				atotblocks, anextents, &ablkmap,
-				XFS_ATTR_FORK, check_dups);
+				XFS_ATTR_FORK, check_dups, zap_metadata);
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		if (!rmapbt_suspect && try_rebuild == -1)
@@ -2096,7 +2132,7 @@ process_inode_attr_fork(
 		*anextents = 0;
 		err = process_btinode(mp, agno, ino, dino, type, dirty,
 				atotblocks, anextents, &ablkmap,
-				XFS_ATTR_FORK, check_dups);
+				XFS_ATTR_FORK, check_dups, zap_metadata);
 		break;
 	default:
 		do_warn(_("illegal attribute format %d, ino %" PRIu64 "\n"),
@@ -2160,12 +2196,12 @@ _("would have tried to rebuild inode %"PRIu64" attr fork or cleared it\n"),
 		case XFS_DINODE_FMT_EXTENTS:
 			err = process_exinode(mp, agno, ino, dino,
 				type, dirty, atotblocks, anextents,
-				&ablkmap, XFS_ATTR_FORK, 0);
+				&ablkmap, XFS_ATTR_FORK, 0, zap_metadata);
 			break;
 		case XFS_DINODE_FMT_BTREE:
 			err = process_btinode(mp, agno, ino, dino,
 				type, dirty, atotblocks, anextents,
-				&ablkmap, XFS_ATTR_FORK, 0);
+				&ablkmap, XFS_ATTR_FORK, 0, zap_metadata);
 			break;
 		default:
 			do_error(_("illegal attribute fmt %d, ino %" PRIu64 "\n"),
@@ -2362,6 +2398,7 @@ process_dinode_int(
 	xfs_agino_t		unlinked_ino;
 	struct xfs_perag	*pag;
 	bool			is_meta = false;
+	bool			zap_metadata = false;
 
 	*dirty = *isa_dir = 0;
 	*used = is_used;
@@ -2944,6 +2981,32 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 		off = get_inode_offset(mp, lino, irec);
 		set_inode_is_meta(irec, off);
 		is_meta = true;
+
+		/*
+		 * We always rebuild the metadata directory tree during phase
+		 * 6, so we use this flag to get all the directory blocks
+		 * marked as free, and any other metadata files whose contents
+		 * we don't want to save.
+		 *
+		 * Currently, there are no metadata files that use xattrs, so
+		 * we always drop the xattr blocks of metadata files.
+		 */
+		switch (type) {
+		case XR_INO_RTBITMAP:
+		case XR_INO_RTSUM:
+		case XR_INO_UQUOTA:
+		case XR_INO_GQUOTA:
+		case XR_INO_PQUOTA:
+			/*
+			 * This inode was recognized as being filesystem
+			 * metadata, so preserve the inode and its contents for
+			 * later checking and repair.
+			 */
+			break;
+		default:
+			zap_metadata = true;
+			break;
+		}
 	}
 
 	/*
@@ -2951,7 +3014,7 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	 */
 	if (process_inode_data_fork(mp, agno, ino, dinop, type, dirty,
 			&totblocks, &nextents, &dblkmap, check_dups,
-			ino_bpp) != 0)
+			ino_bpp, zap_metadata) != 0)
 		goto bad_out;
 	dino = *dinop;
 
@@ -2961,7 +3024,7 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	 */
 	if (process_inode_attr_fork(mp, agno, ino, dinop, type, dirty,
 			&atotblocks, &anextents, check_dups, extra_attr_check,
-			&retval, ino_bpp))
+			&retval, ino_bpp, is_meta))
 		goto bad_out;
 	dino = *dinop;
 
diff --git a/repair/dinode.h b/repair/dinode.h
index 92df83da621..ed2ec4ca238 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -27,7 +27,8 @@ process_bmbt_reclist(xfs_mount_t	*mp,
 		struct blkmap		**blkmapp,
 		uint64_t		*first_key,
 		uint64_t		*last_key,
-		int			whichfork);
+		int			whichfork,
+		bool			zap_metadata);
 
 int
 scan_bmbt_reclist(
@@ -37,7 +38,8 @@ scan_bmbt_reclist(
 	int			type,
 	xfs_ino_t		ino,
 	xfs_rfsblock_t		*tot,
-	int			whichfork);
+	int			whichfork,
+	bool			zap_metadata);
 
 void
 update_rootino(xfs_mount_t *mp);
diff --git a/repair/incore.h b/repair/incore.h
index 90eb1242cd8..645cc5317c8 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -85,18 +85,25 @@ typedef struct rt_extent_tree_node  {
 #define XR_E_UNKNOWN	0	/* unknown state */
 #define XR_E_FREE1	1	/* free block (marked by one fs space tree) */
 #define XR_E_FREE	2	/* free block (marked by both fs space trees) */
-#define XR_E_INUSE	3	/* extent used by file/dir data or metadata */
-#define XR_E_INUSE_FS	4	/* extent used by fs ag header or log */
-#define XR_E_MULT	5	/* extent is multiply referenced */
-#define XR_E_INO	6	/* extent used by inodes (inode blocks) */
-#define XR_E_FS_MAP	7	/* extent used by fs space/inode maps */
-#define XR_E_INUSE1	8	/* used block (marked by rmap btree) */
-#define XR_E_INUSE_FS1	9	/* used by fs ag header or log (rmap btree) */
-#define XR_E_INO1	10	/* used by inodes (marked by rmap btree) */
-#define XR_E_FS_MAP1	11	/* used by fs space/inode maps (rmap btree) */
-#define XR_E_REFC	12	/* used by fs ag reference count btree */
-#define XR_E_COW	13	/* leftover cow extent */
-#define XR_E_BAD_STATE	14
+/*
+ * Space used by metadata files.  The entire metadata directory tree will be
+ * rebuilt from scratch during phase 6, so this value must be less than
+ * XR_E_INUSE so that the space will go back to the free space btrees during
+ * phase 5.
+ */
+#define XR_E_METADATA	3
+#define XR_E_INUSE	4	/* extent used by file/dir data or metadata */
+#define XR_E_INUSE_FS	5	/* extent used by fs ag header or log */
+#define XR_E_MULT	6	/* extent is multiply referenced */
+#define XR_E_INO	7	/* extent used by inodes (inode blocks) */
+#define XR_E_FS_MAP	8	/* extent used by fs space/inode maps */
+#define XR_E_INUSE1	9	/* used block (marked by rmap btree) */
+#define XR_E_INUSE_FS1	10	/* used by fs ag header or log (rmap btree) */
+#define XR_E_INO1	11	/* used by inodes (marked by rmap btree) */
+#define XR_E_FS_MAP1	12	/* used by fs space/inode maps (rmap btree) */
+#define XR_E_REFC	13	/* used by fs ag reference count btree */
+#define XR_E_COW	14	/* leftover cow extent */
+#define XR_E_BAD_STATE	15
 
 /* separate state bit, OR'ed into high (4th) bit of ex_state field */
 
@@ -271,7 +278,7 @@ typedef struct ino_tree_node  {
 	uint64_t		ino_isa_dir;	/* bit == 1 if a directory */
 	uint64_t		ino_was_rl;	/* bit == 1 if reflink flag set */
 	uint64_t		ino_is_rl;	/* bit == 1 if reflink flag should be set */
-	uint64_t		ino_was_meta;	/* bit == 1 if metadata */
+	uint64_t		ino_is_meta;	/* bit == 1 if metadata */
 	uint8_t			nlink_size;
 	union ino_nlink		disk_nlinks;	/* on-disk nlinks, set in P3 */
 	union  {
@@ -544,17 +551,17 @@ static inline int inode_is_rl(struct ino_tree_node *irec, int offset)
  */
 static inline void set_inode_is_meta(struct ino_tree_node *irec, int offset)
 {
-	irec->ino_was_meta |= IREC_MASK(offset);
+	irec->ino_is_meta |= IREC_MASK(offset);
 }
 
 static inline void clear_inode_is_meta(struct ino_tree_node *irec, int offset)
 {
-	irec->ino_was_meta &= ~IREC_MASK(offset);
+	irec->ino_is_meta &= ~IREC_MASK(offset);
 }
 
 static inline int inode_is_meta(struct ino_tree_node *irec, int offset)
 {
-	return (irec->ino_was_meta & IREC_MASK(offset)) != 0;
+	return (irec->ino_is_meta & IREC_MASK(offset)) != 0;
 }
 
 /*
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index e33f7cef758..1b7540d5148 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -254,7 +254,7 @@ alloc_ino_node(
 	irec->ino_isa_dir = 0;
 	irec->ino_was_rl = 0;
 	irec->ino_is_rl = 0;
-	irec->ino_was_meta = 0;
+	irec->ino_is_meta = 0;
 	irec->ir_free = (xfs_inofree_t) - 1;
 	irec->ir_sparse = 0;
 	irec->ino_un.ex_data = NULL;
diff --git a/repair/phase4.c b/repair/phase4.c
index f004111ea4e..e8bd5982147 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -303,6 +303,7 @@ phase4(xfs_mount_t *mp)
 				_("unknown block state, ag %d, blocks %u-%u\n"),
 					i, j, j + blen - 1);
 				fallthrough;
+			case XR_E_METADATA:
 			case XR_E_UNKNOWN:
 			case XR_E_FREE:
 			case XR_E_INUSE:
@@ -335,6 +336,7 @@ phase4(xfs_mount_t *mp)
 	_("unknown rt extent state, extent %" PRIu64 "\n"),
 				rtx);
 			fallthrough;
+		case XR_E_METADATA:
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
diff --git a/repair/scan.c b/repair/scan.c
index 8822f0f05fb..c52ace31c2d 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -227,6 +227,7 @@ scan_bmapbt(
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
 	int			state;
+	bool			zap_metadata = priv != NULL;
 
 	/*
 	 * unlike the ag freeblock btrees, if anything looks wrong
@@ -352,7 +353,20 @@ _("bad back (left) sibling pointer (saw %llu should be NULL (0))\n"
 		case XR_E_UNKNOWN:
 		case XR_E_FREE1:
 		case XR_E_FREE:
-			set_bmap(agno, agbno, XR_E_INUSE);
+			set_bmap(agno, agbno, zap_metadata ? XR_E_METADATA :
+							   XR_E_INUSE);
+			break;
+		case XR_E_METADATA:
+			/*
+			 * bmbt block already claimed by a metadata file.  We
+			 * always reconstruct the entire metadata tree, so if
+			 * this is a regular file we mark it owned by the file.
+			 */
+			do_warn(
+_("inode 0x%" PRIx64 "bmap block 0x%" PRIx64 " claimed by metadata file\n"),
+				ino, bno);
+			if (!zap_metadata)
+				set_bmap(agno, agbno, XR_E_INUSE);
 			break;
 		case XR_E_FS_MAP:
 		case XR_E_INUSE:
@@ -364,7 +378,8 @@ _("bad back (left) sibling pointer (saw %llu should be NULL (0))\n"
 			 * we made it here, the block probably
 			 * contains btree data.
 			 */
-			set_bmap(agno, agbno, XR_E_MULT);
+			if (!zap_metadata)
+				set_bmap(agno, agbno, XR_E_MULT);
 			do_warn(
 _("inode 0x%" PRIx64 "bmap block 0x%" PRIx64 " claimed, state is %d\n"),
 				ino, bno, state);
@@ -440,7 +455,8 @@ _("inode %" PRIu64 " bad # of bmap records (%" PRIu64 ", min - %u, max - %u)\n")
 		if (check_dups == 0)  {
 			err = process_bmbt_reclist(mp, rp, &numrecs, type, ino,
 						   tot, blkmapp, &first_key,
-						   &last_key, whichfork);
+						   &last_key, whichfork,
+						   zap_metadata);
 			if (err)
 				return 1;
 
@@ -470,7 +486,7 @@ _("out-of-order bmap key (file offset) in inode %" PRIu64 ", %s fork, fsbno %" P
 			return 0;
 		} else {
 			return scan_bmbt_reclist(mp, rp, &numrecs, type, ino,
-						 tot, whichfork);
+					tot, whichfork, zap_metadata);
 		}
 	}
 	if (numrecs > mp->m_bmap_dmxr[1] || (isroot == 0 && numrecs <
@@ -860,6 +876,12 @@ process_rmap_rec(
 			break;
 		}
 		break;
+	case XR_E_METADATA:
+		do_warn(
+_("Metadata file block (%d,%d-%d) mismatch in %s tree, state - %d,%" PRIx64 "\n"),
+			agno, b, b + blen - 1,
+			name, state, owner);
+		break;
 	case XR_E_INUSE_FS:
 		if (owner == XFS_RMAP_OWN_FS ||
 		    owner == XFS_RMAP_OWN_LOG)


