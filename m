Return-Path: <linux-xfs+bounces-1344-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49E2B820DC3
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:34:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C80E71F21FD2
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 20:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24034F9CC;
	Sun, 31 Dec 2023 20:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="psy7ga3x"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50BDF9C8
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAECC433C7;
	Sun, 31 Dec 2023 20:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054865;
	bh=UnHqkJ0DAUkjx9Kf8E1T3tGFD+Y+7ISp2oZmtgCkoAs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=psy7ga3xxI3CY2pbf4ZsUHi+GxSpdfTusapajgAmbKU2XvcbU16Fo4hoUrp9zFJhq
	 exX9ZIWOiruqj9hj6qga43hzR0Cs0VH1AXb2BPEpvaF/l17+/WEaTj23uYhAIYk1RN
	 IIcpHoxSZrUssjMN26BZ+y46YvUYDgSWfGhzzBBS2wJixTeeD/a3DajdyQzM8LqJPG
	 hNDsq9hI5FZlbyw1Gmq0R0rxWYZ775qYX9tkmk97UhxGGzco7t6VPEsg3Uel6Nq6Yy
	 XwCo2jhqhGmXyKh7hJb0bBWi9BP0AJ4yAzloCdCB4A0yIt+xE1FeaLYIq8Gs+25ISQ
	 XhszwNZUyv/yw==
Date: Sun, 31 Dec 2023 12:34:24 -0800
Subject: [PATCH 7/9] xfs: validate explicit directory data buffer owners
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404834813.1753044.4196487851473190129.stgit@frogsfrogsfrogs>
In-Reply-To: <170404834676.1753044.18168629400918360020.stgit@frogsfrogsfrogs>
References: <170404834676.1753044.18168629400918360020.stgit@frogsfrogsfrogs>
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

Port the existing directory data header checking function to accept an
owner number instead of an xfs_inode, then update the callsites to use
xfs_da_args.owner when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.h       |    1 +
 fs/xfs/libxfs/xfs_dir2_block.c |    3 ++-
 fs/xfs/libxfs/xfs_dir2_data.c  |   15 +++++++++------
 fs/xfs/libxfs/xfs_dir2_leaf.c  |   21 +++++++++++----------
 fs/xfs/libxfs/xfs_dir2_node.c  |    7 +++----
 fs/xfs/libxfs/xfs_dir2_priv.h  |    3 ++-
 fs/xfs/scrub/dir.c             |   14 +++++++-------
 fs/xfs/scrub/readdir.c         |    2 +-
 fs/xfs/xfs_dir2_readdir.c      |    3 ++-
 9 files changed, 38 insertions(+), 31 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 0b01dd6ccf1eb..537596b9de4a4 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -99,6 +99,7 @@ extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
 xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_dir3_data_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 6bda6a4906718..184341bb1f6af 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -982,7 +982,8 @@ xfs_dir2_leaf_to_block(
 	 * Read the data block if we don't already have it, give up if it fails.
 	 */
 	if (!dbp) {
-		error = xfs_dir3_data_read(tp, dp, args->geo->datablk, 0, &dbp);
+		error = xfs_dir3_data_read(tp, dp, args->owner,
+				args->geo->datablk, 0, &dbp);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index c3ef720b5ff6e..00c2061aed346 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -395,17 +395,19 @@ static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
 	.verify_write = xfs_dir3_data_write_verify,
 };
 
-static xfs_failaddr_t
+xfs_failaddr_t
 xfs_dir3_data_header_check(
-	struct xfs_inode	*dp,
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	xfs_ino_t		owner)
 {
-	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 
 	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_data_hdr *hdr3 = bp->b_addr;
 
-		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
+		ASSERT(hdr3->hdr.magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC));
+
+		if (be64_to_cpu(hdr3->hdr.owner) != owner)
 			return __this_address;
 	}
 
@@ -416,6 +418,7 @@ int
 xfs_dir3_data_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	xfs_dablk_t		bno,
 	unsigned int		flags,
 	struct xfs_buf		**bpp)
@@ -429,7 +432,7 @@ xfs_dir3_data_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	fa = xfs_dir3_data_header_check(dp, *bpp);
+	fa = xfs_dir3_data_header_check(*bpp, owner);
 	if (fa) {
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 16a581e225a37..a6eee26044875 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -884,9 +884,9 @@ xfs_dir2_leaf_addname(
 		 * Already had space in some data block.
 		 * Just read that one in.
 		 */
-		error = xfs_dir3_data_read(tp, dp,
-				   xfs_dir2_db_to_da(args->geo, use_block),
-				   0, &dbp);
+		error = xfs_dir3_data_read(tp, dp, args->owner,
+				xfs_dir2_db_to_da(args->geo, use_block), 0,
+				&dbp);
 		if (error) {
 			xfs_trans_brelse(tp, lbp);
 			return error;
@@ -1327,9 +1327,9 @@ xfs_dir2_leaf_lookup_int(
 		if (newdb != curdb) {
 			if (dbp)
 				xfs_trans_brelse(tp, dbp);
-			error = xfs_dir3_data_read(tp, dp,
-					   xfs_dir2_db_to_da(args->geo, newdb),
-					   0, &dbp);
+			error = xfs_dir3_data_read(tp, dp, args->owner,
+					xfs_dir2_db_to_da(args->geo, newdb), 0,
+					&dbp);
 			if (error) {
 				xfs_trans_brelse(tp, lbp);
 				return error;
@@ -1369,9 +1369,9 @@ xfs_dir2_leaf_lookup_int(
 		ASSERT(cidb != -1);
 		if (cidb != curdb) {
 			xfs_trans_brelse(tp, dbp);
-			error = xfs_dir3_data_read(tp, dp,
-					   xfs_dir2_db_to_da(args->geo, cidb),
-					   0, &dbp);
+			error = xfs_dir3_data_read(tp, dp, args->owner,
+					xfs_dir2_db_to_da(args->geo, cidb), 0,
+					&dbp);
 			if (error) {
 				xfs_trans_brelse(tp, lbp);
 				return error;
@@ -1665,7 +1665,8 @@ xfs_dir2_leaf_trim_data(
 	/*
 	 * Read the offending data block.  We need its buffer.
 	 */
-	error = xfs_dir3_data_read(tp, dp, xfs_dir2_db_to_da(geo, db), 0, &dbp);
+	error = xfs_dir3_data_read(tp, dp, args->owner,
+			xfs_dir2_db_to_da(geo, db), 0, &dbp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index e21965788188b..dc85197b8448e 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -863,7 +863,7 @@ xfs_dir2_leafn_lookup_for_entry(
 				ASSERT(state->extravalid);
 				curbp = state->extrablk.bp;
 			} else {
-				error = xfs_dir3_data_read(tp, dp,
+				error = xfs_dir3_data_read(tp, dp, args->owner,
 						xfs_dir2_db_to_da(args->geo,
 								  newdb),
 						0, &curbp);
@@ -1949,9 +1949,8 @@ xfs_dir2_node_addname_int(
 						  &freehdr, &findex);
 	} else {
 		/* Read the data block in. */
-		error = xfs_dir3_data_read(tp, dp,
-					   xfs_dir2_db_to_da(args->geo, dbno),
-					   0, &dbp);
+		error = xfs_dir3_data_read(tp, dp, args->owner,
+				xfs_dir2_db_to_da(args->geo, dbno), 0, &dbp);
 	}
 	if (error)
 		return error;
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 2f0e3ad47b371..879aa2e9fd730 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -78,7 +78,8 @@ extern void xfs_dir3_data_check(struct xfs_inode *dp, struct xfs_buf *bp);
 extern xfs_failaddr_t __xfs_dir3_data_check(struct xfs_inode *dp,
 		struct xfs_buf *bp);
 int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
-		xfs_dablk_t bno, unsigned int flags, struct xfs_buf **bpp);
+		xfs_ino_t owner, xfs_dablk_t bno, unsigned int flags,
+		struct xfs_buf **bpp);
 int xfs_dir3_data_readahead(struct xfs_inode *dp, xfs_dablk_t bno,
 		unsigned int flags);
 
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index d94e265a8e1f2..6b572196bb43d 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -196,8 +196,8 @@ xchk_dir_rec(
 		xchk_da_set_corrupt(ds, level);
 		goto out;
 	}
-	error = xfs_dir3_data_read(ds->dargs.trans, dp, rec_bno,
-			XFS_DABUF_MAP_HOLE_OK, &bp);
+	error = xfs_dir3_data_read(ds->dargs.trans, dp, ds->dargs.owner,
+			rec_bno, XFS_DABUF_MAP_HOLE_OK, &bp);
 	if (!xchk_fblock_process_error(ds->sc, XFS_DATA_FORK, rec_bno,
 			&error))
 		goto out;
@@ -318,7 +318,8 @@ xchk_directory_data_bestfree(
 		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
 	} else {
 		/* dir data format */
-		error = xfs_dir3_data_read(sc->tp, sc->ip, lblk, 0, &bp);
+		error = xfs_dir3_data_read(sc->tp, sc->ip, sc->ip->i_ino, lblk,
+				0, &bp);
 	}
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		goto out;
@@ -531,10 +532,9 @@ xchk_directory_leaf1_bestfree(
 	/* Check all the bestfree entries. */
 	for (i = 0; i < bestcount; i++, bestp++) {
 		best = be16_to_cpu(*bestp);
-		error = xfs_dir3_data_read(sc->tp, sc->ip,
+		error = xfs_dir3_data_read(sc->tp, sc->ip, args->owner,
 				xfs_dir2_db_to_da(args->geo, i),
-				XFS_DABUF_MAP_HOLE_OK,
-				&dbp);
+				XFS_DABUF_MAP_HOLE_OK, &dbp);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
 				&error))
 			break;
@@ -597,7 +597,7 @@ xchk_directory_free_bestfree(
 			stale++;
 			continue;
 		}
-		error = xfs_dir3_data_read(sc->tp, sc->ip,
+		error = xfs_dir3_data_read(sc->tp, sc->ip, args->owner,
 				(freehdr.firstdb + i) * args->geo->fsbcount,
 				0, &dbp);
 		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk,
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index 20375c0972db9..33035b98d25cf 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -177,7 +177,7 @@ xchk_read_leaf_dir_buf(
 	if (new_off > *curoff)
 		*curoff = new_off;
 
-	return xfs_dir3_data_read(tp, dp, map.br_startoff, 0, bpp);
+	return xfs_dir3_data_read(tp, dp, dp->i_ino, map.br_startoff, 0, bpp);
 }
 
 /* Call a function for every entry in a leaf directory. */
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 263a897bee49e..260943447be9b 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -284,7 +284,8 @@ xfs_dir2_leaf_readbuf(
 	new_off = xfs_dir2_da_to_byte(geo, map.br_startoff);
 	if (new_off > *cur_off)
 		*cur_off = new_off;
-	error = xfs_dir3_data_read(args->trans, dp, map.br_startoff, 0, &bp);
+	error = xfs_dir3_data_read(args->trans, dp, args->owner,
+			map.br_startoff, 0, &bp);
 	if (error)
 		goto out;
 


