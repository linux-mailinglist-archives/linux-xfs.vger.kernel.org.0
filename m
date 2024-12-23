Return-Path: <linux-xfs+bounces-17390-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B73599FB687
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Dec 2024 22:54:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA8971884A75
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Dec 2024 21:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3509B1C3C0C;
	Mon, 23 Dec 2024 21:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="byQYzlDP"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DE71422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990875; cv=none; b=sOA6XuCSpm9l8hTEnO0UDjoaaGgvLk7gRQ741Za0leFIx1ewA/jgDh9NKgyPGKLXzL4d3YBdpNXEwVNki89R0jIzJdY/6ZY+n8UjB6GBrw/PlL5rrcLy4e2Rf5+7ndGl5YAMRq1v4KZwAYXfNE/m8d14gU32VbCDs9ymtK8kph8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990875; c=relaxed/simple;
	bh=Q0HoA9NzWrmvTFqenbcYZxTrgYq6qwPbdDdSlb3cMu0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=brrIr1ulJpfHHDru2iuxr1pOVhJLJ6UJQ/jdHc6Z+JyU1bU+5C5/CNfZDeiXFvm7NLEe7AQSsbd38sgz/shAYX1JHTcmGsIQeF4XJY0xj5bmfaICBCEShgZOIPeScGFjHIXMdheXmDB7S6DqAsZ7XF6jJCIftIbVS9R4s3+m9T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=byQYzlDP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDE9C4CED3;
	Mon, 23 Dec 2024 21:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990874;
	bh=Q0HoA9NzWrmvTFqenbcYZxTrgYq6qwPbdDdSlb3cMu0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=byQYzlDPa8KUagPdJU8qIp8HbEku1tGM/KZ/0bH58QfdYlswX/I/bXeSvPTYME4E2
	 PKK+mJGcMKVyIfZONG9tjhfXLOvnhKrf9z43Jl5zLZS/EFTEd8/ntjJqsz6igvYQAK
	 7Vu67E6NGh7N8pIN2EwPPYCT6BqZBXkLL1ckxP3rpqVQNv5KxlY+bH0oDVunyoIGJg
	 QbMlluW6svTxlXjxbJrQzgUhFyoFA3npPt5E8d0RFPCS5oOfGRmg89NBYRCpxeW0IM
	 FjPsw3xRtrA39kmbQRXliSWlZZOYHfuFvv32HNf5408HpKJdZpu1ShhEJWHkZCfY0/
	 O2MQIWhTlOrcA==
Date: Mon, 23 Dec 2024 13:54:34 -0800
Subject: [PATCH 31/41] xfs_repair: don't let metadata and regular files mix
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941444.2294268.11205149904208261584.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Track whether or not inodes thought they were metadata inodes.  We
cannot allow metadata inodes to appear in the regular directory tree,
and we cannot allow regular inodes to appear in the metadata directory
tree.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dinode.c     |   21 +++++++++++++++++
 repair/incore.h     |   19 +++++++++++++++
 repair/incore_ino.c |    1 +
 repair/phase2.c     |    7 +++++-
 repair/phase6.c     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 110 insertions(+), 1 deletion(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 5dd7edfa36aed0..60a853d152ccec 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2392,6 +2392,7 @@ process_dinode_int(
 	struct xfs_dinode	*dino = *dinop;
 	xfs_agino_t		unlinked_ino;
 	struct xfs_perag	*pag;
+	bool			is_meta = false;
 
 	*dirty = *isa_dir = 0;
 	*used = is_used;
@@ -2971,6 +2972,18 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	if (collect_rmaps)
 		record_inode_reflink_flag(mp, dino, agno, ino, lino);
 
+	/* Does this inode think it was metadata? */
+	if (dino->di_version >= 3 &&
+	    (dino->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADATA))) {
+		struct ino_tree_node	*irec;
+		int			off;
+
+		irec = find_inode_rec(mp, agno, ino);
+		off = get_inode_offset(mp, lino, irec);
+		set_inode_is_meta(irec, off);
+		is_meta = true;
+	}
+
 	/*
 	 * check data fork -- if it's bad, clear the inode
 	 */
@@ -3057,6 +3070,14 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	*used = is_free;
 	*isa_dir = 0;
 	blkmap_free(dblkmap);
+	if (is_meta) {
+		struct ino_tree_node	*irec;
+		int			off;
+
+		irec = find_inode_rec(mp, agno, ino);
+		off = get_inode_offset(mp, lino, irec);
+		clear_inode_is_meta(irec, off);
+	}
 	return 1;
 }
 
diff --git a/repair/incore.h b/repair/incore.h
index 4f32ad3377faed..568a8c7cb75b7c 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -271,6 +271,7 @@ typedef struct ino_tree_node  {
 	uint64_t		ino_isa_dir;	/* bit == 1 if a directory */
 	uint64_t		ino_was_rl;	/* bit == 1 if reflink flag set */
 	uint64_t		ino_is_rl;	/* bit == 1 if reflink flag should be set */
+	uint64_t		ino_is_meta;	/* bit == 1 if metadata */
 	uint8_t			nlink_size;
 	union ino_nlink		disk_nlinks;	/* on-disk nlinks, set in P3 */
 	union  {
@@ -538,6 +539,24 @@ static inline int inode_is_rl(struct ino_tree_node *irec, int offset)
 	return (irec->ino_is_rl & IREC_MASK(offset)) != 0;
 }
 
+/*
+ * set/clear/test was inode marked as metadata
+ */
+static inline void set_inode_is_meta(struct ino_tree_node *irec, int offset)
+{
+	irec->ino_is_meta |= IREC_MASK(offset);
+}
+
+static inline void clear_inode_is_meta(struct ino_tree_node *irec, int offset)
+{
+	irec->ino_is_meta &= ~IREC_MASK(offset);
+}
+
+static inline int inode_is_meta(struct ino_tree_node *irec, int offset)
+{
+	return (irec->ino_is_meta & IREC_MASK(offset)) != 0;
+}
+
 /*
  * add_inode_reached() is set on inode I only if I has been reached
  * by an inode P claiming to be the parent and if I is a directory,
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index 158e9b4980d984..3189e019faa23d 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -257,6 +257,7 @@ alloc_ino_node(
 	irec->ino_isa_dir = 0;
 	irec->ino_was_rl = 0;
 	irec->ino_is_rl = 0;
+	irec->ino_is_meta = 0;
 	irec->ir_free = (xfs_inofree_t) - 1;
 	irec->ir_sparse = 0;
 	irec->ino_un.ex_data = NULL;
diff --git a/repair/phase2.c b/repair/phase2.c
index 17c16e94a600c2..476a1c74db8c8d 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -557,8 +557,10 @@ phase2(
 		 */
 		ino_rec = set_inode_used_alloc(mp, 0,
 				XFS_INO_TO_AGINO(mp, sb->sb_rootino));
-		for (j = 1; j < inuse; j++)
+		for (j = 1; j < inuse; j++) {
 			set_inode_used(ino_rec, j);
+			set_inode_is_meta(ino_rec, j);
+		}
 
 		for (j = inuse; j < XFS_INODES_PER_CHUNK; j++)
 			set_inode_free(ino_rec, j);
@@ -594,6 +596,7 @@ phase2(
 				else
 					do_warn(_("would correct\n"));
 			}
+			set_inode_is_meta(ino_rec, j);
 			j++;
 		}
 
@@ -605,6 +608,7 @@ phase2(
 			else
 				do_warn(_("would correct\n"));
 		}
+		set_inode_is_meta(ino_rec, j);
 		j++;
 
 		if (is_inode_free(ino_rec, j))  {
@@ -615,6 +619,7 @@ phase2(
 			else
 				do_warn(_("would correct\n"));
 		}
+		set_inode_is_meta(ino_rec, j);
 		j++;
 	}
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 7a8edbad2ebfc2..688eee20bb3e8e 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1610,6 +1610,38 @@ longform_dir2_entry_check_data(
 			continue;
 		}
 
+		/*
+		 * Regular directories cannot point to metadata files.  If
+		 * we find such a thing, blow out the entry.
+		 */
+		if (!xfs_is_metadir_inode(ip) &&
+		    inode_is_meta(irec, ino_offset)) {
+			nbad++;
+			if (entry_junked(
+	_("entry \"%s\" in regular dir %" PRIu64" points to a metadata inode %" PRIu64 ", "),
+					fname, ip->i_ino, inum, NULLFSINO)) {
+				dep->name[0] = '/';
+				libxfs_dir2_data_log_entry(&da, bp, dep);
+			}
+			continue;
+		}
+
+		/*
+		 * Metadata directories cannot point to regular files.  If
+		 * we find such a thing, blow out the entry.
+		 */
+		if (xfs_is_metadir_inode(ip) &&
+		    !inode_is_meta(irec, ino_offset)) {
+			nbad++;
+			if (entry_junked(
+	_("entry \"%s\" in metadata dir %" PRIu64" points to a regular inode %" PRIu64 ", "),
+					fname, ip->i_ino, inum, NULLFSINO)) {
+				dep->name[0] = '/';
+				libxfs_dir2_data_log_entry(&da, bp, dep);
+			}
+			continue;
+		}
+
 		/*
 		 * check if this inode is lost+found dir in the root
 		 */
@@ -2521,6 +2553,37 @@ shortform_dir2_entry_check(
 						ino_dirty);
 			continue;
 		}
+
+		/*
+		 * Regular directories cannot point to metadata files.  If
+		 * we find such a thing, blow out the entry.
+		 */
+		if (!xfs_is_metadir_inode(ip) &&
+		    inode_is_meta(irec, ino_offset)) {
+			do_warn(
+	_("entry \"%s\" in regular dir %" PRIu64" points to a metadata inode %" PRIu64 ", "),
+					fname, ip->i_ino, lino);
+			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
+						&max_size, &i, &bytes_deleted,
+						ino_dirty);
+			continue;
+		}
+
+		/*
+		 * Metadata directories cannot point to regular files.  If
+		 * we find such a thing, blow out the entry.
+		 */
+		if (xfs_is_metadir_inode(ip) &&
+		    !inode_is_meta(irec, ino_offset)) {
+			do_warn(
+	_("entry \"%s\" in metadata dir %" PRIu64" points to a regular inode %" PRIu64 ", "),
+					fname, ip->i_ino, lino);
+			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
+						&max_size, &i, &bytes_deleted,
+						ino_dirty);
+			continue;
+		}
+
 		/*
 		 * check if this inode is lost+found dir in the root
 		 */


