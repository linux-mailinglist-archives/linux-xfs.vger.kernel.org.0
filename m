Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501BF65A21E
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 04:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbiLaDCP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 22:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236286AbiLaDCP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:02:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C186B15816
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:02:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F7C861D1B
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E45DC433EF;
        Sat, 31 Dec 2022 03:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455732;
        bh=K792e86Wt5JIB5nxBk3CBlSUF2YEHQXayX4wbVma94M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RKKBQfAaVxYG16yLBjsbv/hBtBryyoGEDWNfXsTsmnKwVlQbmbS9RopZGLm6AqZ8o
         2j9F4WVMKYXJ1uX50ACkzUapGs3i04BQdo8fPGWJib2w27wwYx05jXqNS0yC6PbD+U
         ZoZ0Z9nCvt2g8LE6vxLVML539fJj2+dyl9YURtxpjA+S1/hKpPfwgPmaxfcna7GDPn
         XgrT/s8FAUof57jcKR6f8kAj+SDJVBM7EXMNo+gZoK0shfDZqFO49781O8h1cM3uCD
         U+7aaqU3CfV3jW7HuTut5fa349uTKA+loy2SmKrEzZm2spWKe2XTQRXl+cssTq6fjE
         /HNhac7RIwTBA==
Subject: [PATCH 31/41] xfs_repair: use realtime refcount btree data to check
 block types
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:11 -0800
Message-ID: <167243881180.734096.190442967255073165.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the realtime refcount btree to pre-populate the block type information
so that when repair iterates the primary metadata, we can confirm the
block type.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |  152 ++++++++++++++++++++++++++++
 repair/rmap.c   |    9 ++
 repair/rmap.h   |    3 +
 repair/scan.c   |  299 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 repair/scan.h   |   33 ++++++
 5 files changed, 490 insertions(+), 6 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index b2c27984671..7722d7762d2 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -274,6 +274,8 @@ _("bad state in rt extent map %" PRIu64 "\n"),
 			break;
 		case XR_E_INUSE:
 		case XR_E_MULT:
+			if (xfs_has_rtreflink(mp))
+				break;
 			set_rtbmap(ext, XR_E_MULT);
 			break;
 		case XR_E_FREE1:
@@ -348,6 +350,8 @@ _("data fork in rt inode %" PRIu64 " found rt metadata extent %" PRIu64 " in rt
 			return 1;
 		case XR_E_INUSE:
 		case XR_E_MULT:
+			if (xfs_has_rtreflink(mp))
+				break;
 			do_warn(
 _("data fork in rt inode %" PRIu64 " claims used rt extent %" PRIu64 "\n"),
 				ino, b);
@@ -1012,6 +1016,148 @@ _("bad rtrmap btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
 	return suspect ? 1 : 0;
 }
 
+/*
+ * return 1 if inode should be cleared, 0 otherwise
+ */
+static int
+process_rtrefc(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno,
+	xfs_agino_t			ino,
+	struct xfs_dinode		*dip,
+	int				type,
+	int				*dirty,
+	xfs_rfsblock_t			*tot,
+	uint64_t			*nex,
+	blkmap_t			**blkmapp,
+	int				check_dups)
+{
+	struct refc_priv		priv = { .nr_blocks = 0 };
+	struct xfs_rtrefcount_root	*dib;
+	xfs_rtrefcount_ptr_t		*pp;
+	struct xfs_refcount_key		*kp;
+	struct xfs_refcount_rec		*rp;
+	char				*forkname = get_forkname(XFS_DATA_FORK);
+	xfs_rgblock_t			oldkey, key;
+	xfs_ino_t			lino;
+	xfs_fsblock_t			bno;
+	size_t				droot_sz;
+	int				i;
+	int				level;
+	int				numrecs;
+	int				dmxr;
+	int				suspect = 0;
+	int				error;
+
+	/* We rebuild the rtrefcountbt, so no need to process blocks again. */
+	if (check_dups) {
+		*tot = be64_to_cpu(dip->di_nblocks);
+		return 0;
+	}
+
+	lino = XFS_AGINO_TO_INO(mp, agno, ino);
+
+	/*
+	 * This refcount btree inode must be a metadata inode reachable via
+	 * /realtime/$rgno.refcount in the metadata directory tree.
+	 */
+	if (!(dip->di_flags2 & be64_to_cpu(XFS_DIFLAG2_METADATA))) {
+		do_warn(
+_("rtrefcount inode %" PRIu64 " not flagged as metadata\n"),
+			lino);
+		return 1;
+	}
+
+	priv.rgno = rtgroup_for_rtrefcount_inode(mp, ino);
+	if (priv.rgno == NULLRGNUMBER) {
+		do_warn(
+_("could not associate refcount inode %" PRIu64 " with any rtgroup\n"),
+			lino);
+		return 1;
+	}
+
+	dib = (struct xfs_rtrefcount_root *)XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	*tot = 0;
+	*nex = 0;
+
+	level = be16_to_cpu(dib->bb_level);
+	numrecs = be16_to_cpu(dib->bb_numrecs);
+
+	if (level > mp->m_rtrefc_maxlevels) {
+		do_warn(
+_("bad level %d in inode %" PRIu64 " rtrefcount btree root block\n"),
+			level, lino);
+		return 1;
+	}
+
+	/*
+	 * use rtroot/dfork_dsize since the root block is in the data fork
+	 */
+	droot_sz = xfs_rtrefcount_droot_space_calc(level, numrecs);
+	if (droot_sz > XFS_DFORK_SIZE(dip, mp, XFS_DATA_FORK)) {
+		do_warn(
+_("computed size of rtrefcountbt root (%zu bytes) is greater than space in "
+	  "inode %" PRIu64 " %s fork\n"),
+				droot_sz, lino, forkname);
+		return 1;
+	}
+
+	if (level == 0) {
+		rp = xfs_rtrefcount_droot_rec_addr(dib, 1);
+		error = process_rtrefc_reclist(mp, rp, numrecs,
+				&priv, "rtrefcountbt root");
+		if (error) {
+			refcount_avoid_check();
+			return 1;
+		}
+		return 0;
+	}
+
+	dmxr = libxfs_rtrefcountbt_droot_maxrecs(
+			XFS_DFORK_SIZE(dip, mp, XFS_DATA_FORK), false);
+	pp = xfs_rtrefcount_droot_ptr_addr(dib, 1, dmxr);
+
+	/* check for in-order keys */
+	for (i = 0; i < numrecs; i++)  {
+		kp = xfs_rtrefcount_droot_key_addr(dib, i + 1);
+
+		key = be32_to_cpu(kp->rc_startblock);
+		if (i == 0) {
+			oldkey = key;
+			continue;
+		}
+		if (key < oldkey) {
+			do_warn(
+_("out of order key %u in rtrefcount root ino %" PRIu64 "\n"),
+				i, lino);
+			suspect++;
+			continue;
+		}
+		oldkey = key;
+	}
+
+	/* probe keys */
+	for (i = 0; i < numrecs; i++)  {
+		bno = get_unaligned_be64(&pp[i]);
+
+		if (!libxfs_verify_fsbno(mp, bno))  {
+			do_warn(
+_("bad rtrefcount btree ptr 0x%" PRIx64 " in ino %" PRIu64 "\n"),
+				bno, lino);
+			return 1;
+		}
+
+		if (scan_lbtree(bno, level, scan_rtrefcbt,
+				type, XFS_DATA_FORK, lino, tot, nex, blkmapp,
+				NULL, 0, 1, check_dups, XFS_RTREFC_CRC_MAGIC,
+				&priv, &xfs_rtrefcountbt_buf_ops))
+			return 1;
+	}
+
+	*tot = priv.nr_blocks;
+	return suspect ? 1 : 0;
+}
+
 /*
  * return 1 if inode should be cleared, 0 otherwise
  */
@@ -1807,6 +1953,7 @@ check_dinode_mode_format(
 		case XFS_DINODE_FMT_RMAP:
 		case XFS_DINODE_FMT_EXTENTS:
 		case XFS_DINODE_FMT_BTREE:
+		case XFS_DINODE_FMT_REFCOUNT:
 			return 0;
 		}
 		return -1;
@@ -2236,6 +2383,10 @@ process_inode_data_fork(
 		err = process_rtrmap(mp, agno, ino, dino, type, dirty,
 				totblocks, nextents, dblkmap, check_dups);
 		break;
+	case XFS_DINODE_FMT_REFCOUNT:
+		err = process_rtrefc(mp, agno, ino, dino, type, dirty,
+			totblocks, nextents, dblkmap, check_dups);
+		break;
 	case XFS_DINODE_FMT_DEV:
 		err = 0;
 		break;
@@ -2296,6 +2447,7 @@ _("would have tried to rebuild inode %"PRIu64" data fork\n"),
 			break;
 		case XFS_DINODE_FMT_DEV:
 		case XFS_DINODE_FMT_RMAP:
+		case XFS_DINODE_FMT_REFCOUNT:
 			err = 0;
 			break;
 		default:
diff --git a/repair/rmap.c b/repair/rmap.c
index 15a3e2ecaec..69954b448ed 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -250,6 +250,15 @@ bool is_rtrmap_inode(xfs_ino_t ino)
 	return bitmap_test(rmap_inodes, ino, 1);
 }
 
+xfs_rgnumber_t
+rtgroup_for_rtrefcount_inode(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	/* This will be implemented later. */
+	return NULLRGNUMBER;
+}
+
 /*
  * Initialize per-AG reverse map data.
  */
diff --git a/repair/rmap.h b/repair/rmap.h
index 64a85b32341..83331c825ec 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -66,4 +66,7 @@ bool is_rtrmap_inode(xfs_ino_t ino);
 xfs_ino_t rtgroup_rmap_ino(struct xfs_rtgroup *rtg);
 int populate_rtgroup_rmapbt(struct xfs_rtgroup *rtg, struct xfs_inode *ip);
 
+xfs_rgnumber_t rtgroup_for_rtrefcount_inode(struct xfs_mount *mp,
+		xfs_ino_t ino);
+
 #endif /* RMAP_H_ */
diff --git a/repair/scan.c b/repair/scan.c
index c9209ebc3d7..0a37137f019 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1752,12 +1752,6 @@ _("bad %s btree ptr 0x%llx in ino %" PRIu64 "\n"),
 	return 0;
 }
 
-struct refc_priv {
-	struct xfs_refcount_irec	last_rec;
-	xfs_agblock_t			nr_blocks;
-};
-
-
 static void
 scan_refcbt(
 	struct xfs_btree_block	*block,
@@ -1995,6 +1989,299 @@ _("extent (%u/%u) len %u claimed, state is %d\n"),
 	return;
 }
 
+
+int
+process_rtrefc_reclist(
+	struct xfs_mount	*mp,
+	struct xfs_refcount_rec	*rp,
+	int			numrecs,
+	struct refc_priv	*refc_priv,
+	const char		*name)
+{
+	xfs_rtblock_t		lastblock = 0;
+	xfs_rtblock_t		rtbno, next_rtbno;
+	int			state;
+	int			suspect = 0;
+	int			i;
+
+	for (i = 0; i < numrecs; i++) {
+		enum xfs_refc_domain	domain;
+		xfs_rgblock_t		b, rgbno, end;
+		xfs_extlen_t		len;
+		xfs_nlink_t		nr;
+
+		b = rgbno = be32_to_cpu(rp[i].rc_startblock);
+		len = be32_to_cpu(rp[i].rc_blockcount);
+		nr = be32_to_cpu(rp[i].rc_refcount);
+
+		if (b & XFS_REFC_COWFLAG) {
+			domain = XFS_REFC_DOMAIN_COW;
+			rgbno &= ~XFS_REFC_COWFLAG;
+		} else {
+			domain = XFS_REFC_DOMAIN_SHARED;
+		}
+
+		if (domain == XFS_REFC_DOMAIN_COW && nr != 1) {
+			do_warn(
+_("leftover rt CoW extent has incorrect refcount in record %u of %s\n"),
+					i, name);
+			suspect++;
+		}
+		if (nr == 1) {
+			if (domain != XFS_REFC_DOMAIN_COW) {
+				do_warn(
+_("leftover rt CoW extent has invalid startblock in record %u of %s\n"),
+					i, name);
+				suspect++;
+			}
+		}
+		end = rgbno + len;
+
+		rtbno = xfs_rgbno_to_rtb(mp, refc_priv->rgno, rgbno);
+		if (!libxfs_verify_rtbno(mp, rtbno)) {
+			do_warn(
+_("invalid start block %llu in record %u of %s\n"),
+					(unsigned long long)b, i, name);
+			suspect++;
+			continue;
+		}
+
+		next_rtbno = xfs_rgbno_to_rtb(mp, refc_priv->rgno, end);
+		if (len == 0 || end <= rgbno ||
+		    !libxfs_verify_rtbno(mp, next_rtbno - 1)) {
+			do_warn(
+_("invalid length %llu in record %u of %s\n"),
+					(unsigned long long)len, i, name);
+			suspect++;
+			continue;
+		}
+
+		if (nr == 1) {
+			xfs_rtxnum_t	rtx, next_rtx;
+
+			rtx = xfs_rtb_to_rtxt(mp, rtbno);
+			next_rtx = xfs_rtb_to_rtxt(mp, next_rtbno);
+			for (; rtx < next_rtx; rtx++) {
+				state = get_rtbmap(rtx);
+				switch (state) {
+				case XR_E_UNKNOWN:
+				case XR_E_COW:
+					do_warn(
+_("leftover CoW rtextent (%llu)\n"),
+						(unsigned long long)rtx);
+					suspect++;
+					set_rtbmap(rtx, XR_E_FREE);
+					break;
+				default:
+					do_warn(
+_("rtextent (%llu) claimed, state is %d\n"),
+						(unsigned long long)rtx, state);
+					suspect++;
+					break;
+				}
+			}
+		} else if (nr < 2 || nr > XFS_REFC_REFCOUNT_MAX) {
+			do_warn(
+_("invalid rt reference count %u in record %u of %s\n"),
+					nr, i, name);
+			suspect++;
+			continue;
+		}
+
+		if (b && b <= lastblock) {
+			do_warn(_(
+"out-of-order %s btree record %d (%llu %llu) in %s\n"),
+					name, i, (unsigned long long)b,
+					(unsigned long long)len, name);
+			suspect++;
+		} else {
+			lastblock = end - 1;
+		}
+
+		/* Is this record mergeable with the last one? */
+		if (refc_priv->last_rec.rc_domain == domain &&
+		    refc_priv->last_rec.rc_startblock +
+		    refc_priv->last_rec.rc_blockcount == rgbno &&
+		    refc_priv->last_rec.rc_refcount == nr) {
+			do_warn(
+_("record %d of %s tree should be merged with previous record\n"),
+					i, name);
+			suspect++;
+			refc_priv->last_rec.rc_blockcount += len;
+		} else {
+			refc_priv->last_rec.rc_domain = domain;
+			refc_priv->last_rec.rc_startblock = rgbno;
+			refc_priv->last_rec.rc_blockcount = len;
+			refc_priv->last_rec.rc_refcount = nr;
+		}
+
+		/* XXX: probably want to mark the reflinked areas? */
+	}
+
+	return suspect;
+}
+
+int
+scan_rtrefcbt(
+	struct xfs_btree_block		*block,
+	int				level,
+	int				type,
+	int				whichfork,
+	xfs_fsblock_t			fsbno,
+	xfs_ino_t			ino,
+	xfs_rfsblock_t			*tot,
+	uint64_t			*nex,
+	struct blkmap			**blkmapp,
+	bmap_cursor_t			*bm_cursor,
+	int				suspect,
+	int				isroot,
+	int				check_dups,
+	int				*dirty,
+	uint64_t			magic,
+	void				*priv)
+{
+	const char			*name = "rtrefcount";
+	char				rootname[256];
+	int				i;
+	xfs_rtrefcount_ptr_t		*pp;
+	struct xfs_refcount_rec	*rp;
+	struct refc_priv		*refc_priv = priv;
+	int				hdr_errors = 0;
+	int				numrecs;
+	int				state;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			agbno;
+	int				error;
+
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+
+	if (magic != XFS_RTREFC_CRC_MAGIC) {
+		name = "(unknown)";
+		hdr_errors++;
+		suspect++;
+		goto out;
+	}
+
+	if (be32_to_cpu(block->bb_magic) != magic) {
+		do_warn(_("bad magic # %#x in %s btree block %d/%d\n"),
+				be32_to_cpu(block->bb_magic), name, agno,
+				agbno);
+		hdr_errors++;
+		if (suspect)
+			goto out;
+	}
+
+	if (be16_to_cpu(block->bb_level) != level) {
+		do_warn(_("expected level %d got %d in %s btree block %d/%d\n"),
+				level, be16_to_cpu(block->bb_level), name,
+				agno, agbno);
+		hdr_errors++;
+		if (suspect)
+			goto out;
+	}
+
+	refc_priv->nr_blocks++;
+
+	/*
+	 * Check for btree blocks multiply claimed.  We're going to regenerate
+	 * the btree anyway, so mark the blocks as metadata so they get freed.
+	 */
+	state = get_bmap(agno, agbno);
+	if (!(state == XR_E_UNKNOWN || state == XR_E_INUSE1))  {
+		do_warn(
+_("%s btree block claimed (state %d), agno %d, agbno %d, suspect %d\n"),
+				name, state, agno, agbno, suspect);
+		goto out;
+	}
+	set_bmap(agno, agbno, XR_E_METADATA);
+
+	numrecs = be16_to_cpu(block->bb_numrecs);
+	if (level == 0) {
+		if (numrecs > mp->m_rtrefc_mxr[0])  {
+			numrecs = mp->m_rtrefc_mxr[0];
+			hdr_errors++;
+		}
+		if (isroot == 0 && numrecs < mp->m_rtrefc_mnr[0])  {
+			numrecs = mp->m_rtrefc_mnr[0];
+			hdr_errors++;
+		}
+
+		if (hdr_errors) {
+			do_warn(
+	_("bad btree nrecs (%u, min=%u, max=%u) in %s btree block %u/%u\n"),
+					be16_to_cpu(block->bb_numrecs),
+					mp->m_rtrefc_mnr[0],
+					mp->m_rtrefc_mxr[0], name, agno, agbno);
+			suspect++;
+		}
+
+		rp = xfs_rtrefcount_rec_addr(block, 1);
+		snprintf(rootname, 256, "%s btree block %u/%u", name, agno,
+				agbno);
+		error = process_rtrefc_reclist(mp, rp, numrecs, refc_priv,
+				rootname);
+		if (error)
+			suspect++;
+		goto out;
+	}
+
+	/*
+	 * interior record
+	 */
+	pp = xfs_rtrefcount_ptr_addr(block, 1, mp->m_rtrefc_mxr[1]);
+
+	if (numrecs > mp->m_rtrefc_mxr[1])  {
+		numrecs = mp->m_rtrefc_mxr[1];
+		hdr_errors++;
+	}
+	if (isroot == 0 && numrecs < mp->m_rtrefc_mnr[1])  {
+		numrecs = mp->m_rtrefc_mnr[1];
+		hdr_errors++;
+	}
+
+	/*
+	 * don't pass bogus tree flag down further if this block
+	 * looked ok.  bail out if two levels in a row look bad.
+	 */
+	if (hdr_errors)  {
+		do_warn(
+	_("bad btree nrecs (%u, min=%u, max=%u) in %s btree block %u/%u\n"),
+				be16_to_cpu(block->bb_numrecs),
+				mp->m_rtrefc_mnr[1], mp->m_rtrefc_mxr[1], name,
+				agno, agbno);
+		if (suspect)
+			goto out;
+		suspect++;
+	} else if (suspect) {
+		suspect = 0;
+	}
+
+	for (i = 0; i < numrecs; i++)  {
+		xfs_fsblock_t		pbno = be64_to_cpu(pp[i]);
+
+		if (!libxfs_verify_fsbno(mp, pbno)) {
+			do_warn(
+	_("bad btree pointer (%u) in %sbt block %u/%u\n"),
+					agbno, name, agno, agbno);
+			suspect++;
+			return 0;
+		}
+
+		scan_lbtree(pbno, level, scan_rtrefcbt, type, whichfork, ino,
+				tot, nex, blkmapp, bm_cursor, suspect, 0,
+				check_dups, magic, refc_priv,
+				&xfs_rtrefcountbt_buf_ops);
+	}
+out:
+	if (suspect) {
+		refcount_avoid_check();
+		return 1;
+	}
+
+	return 0;
+}
+
 /*
  * The following helpers are to help process and validate individual on-disk
  * inode btree records. We have two possible inode btrees with slightly
diff --git a/repair/scan.h b/repair/scan.h
index a624c882734..1643a2397ae 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -100,4 +100,37 @@ int scan_rtrmapbt(
 	uint64_t		magic,
 	void			*priv);
 
+struct refc_priv {
+	struct xfs_refcount_irec	last_rec;
+	xfs_agblock_t			nr_blocks;
+	xfs_rgnumber_t			rgno;
+};
+
+int
+process_rtrefc_reclist(
+	struct xfs_mount	*mp,
+	struct xfs_refcount_rec	*rp,
+	int			numrecs,
+	struct refc_priv	*refc_priv,
+	const char		*name);
+
+int
+scan_rtrefcbt(
+	struct xfs_btree_block	*block,
+	int			level,
+	int			type,
+	int			whichfork,
+	xfs_fsblock_t		bno,
+	xfs_ino_t		ino,
+	xfs_rfsblock_t		*tot,
+	uint64_t		*nex,
+	struct blkmap		**blkmapp,
+	bmap_cursor_t		*bm_cursor,
+	int			suspect,
+	int			isroot,
+	int			check_dups,
+	int			*dirty,
+	uint64_t		magic,
+	void			*priv);
+
 #endif /* _XR_SCAN_H */

