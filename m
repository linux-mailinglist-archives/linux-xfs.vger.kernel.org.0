Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B049659E46
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 00:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiL3X37 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 18:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiL3X36 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:29:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A3313F32
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:29:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25AEC61C2C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B7FC433EF;
        Fri, 30 Dec 2022 23:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442995;
        bh=1Fe5fU40iUGvHDMUX1bSFSDNuN9YDrvmtO5DpEj+rjA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jNowNq+dHFRdLtAIs2UTnkDjO/31UuFpXwyGymwNDX1wK9kDB7jSq8qQswFKhv/S4
         Mw2WEAN5kYwoIVl4cJ4aW6tsW/viM+xmWsBjHJ5Mx5i52dXaeGV+BoiQYgyKlhO7HZ
         43+7ZtJ/Jnmx64qaINSuySUSAKsrCu2aGrbsLxr6h6VdOm48hyG0kP5lIfqd9DUllz
         jJCw10mWG8jmrFnXkR5rdvydWxNkgftTbJ6ULut2bgZ3ygbk1lGL8Fkp6Kupom3VPZ
         M5vvU2Zi/PM7sQNc7T4bmt38O4Sngo8v8ninazLrpmCZaJTCTEcHD5uRkeT7DC/74Y
         HYP1CSOE24SmQ==
Subject: [PATCH 3/6] xfs: repair inode records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:52 -0800
Message-ID: <167243837281.694402.16596318884602035434.stgit@magnolia>
In-Reply-To: <167243837231.694402.7473901938296662729.stgit@magnolia>
References: <167243837231.694402.7473901938296662729.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If an inode is so badly damaged that it cannot be loaded into the cache,
fix the ondisk metadata and try again.  If there /is/ a cached inode,
fix any problems and apply any optimizations that can be solved incore.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile             |    1 
 fs/xfs/libxfs/xfs_format.h  |    3 
 fs/xfs/scrub/alloc.c        |    2 
 fs/xfs/scrub/inode.c        |   10 +
 fs/xfs/scrub/inode_repair.c |  774 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c       |   32 ++
 fs/xfs/scrub/repair.h       |   19 +
 fs/xfs/scrub/scrub.c        |    2 
 fs/xfs/scrub/trace.h        |  129 +++++++
 9 files changed, 969 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/inode_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index c448c2a4d691..1f61f299e436 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -179,6 +179,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   alloc_repair.o \
 				   ialloc_repair.o \
+				   inode_repair.o \
 				   newbt.o \
 				   reap.o \
 				   refcount_repair.o \
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 371dc07233e0..5ba2dae7aa2f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -996,7 +996,8 @@ enum xfs_dinode_fmt {
 #define XFS_DFORK_APTR(dip)	\
 	(XFS_DFORK_DPTR(dip) + XFS_DFORK_BOFF(dip))
 #define XFS_DFORK_PTR(dip,w)	\
-	((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : XFS_DFORK_APTR(dip))
+	((void *)((w) == XFS_DATA_FORK ? XFS_DFORK_DPTR(dip) : \
+					 XFS_DFORK_APTR(dip)))
 
 #define XFS_DFORK_FORMAT(dip,w) \
 	((w) == XFS_DATA_FORK ? \
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index e16a48486c6d..0fc412abfc50 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -9,6 +9,8 @@
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
 #include "xfs_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 5c0aaffc6f01..d86a2e1572ee 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -23,6 +23,7 @@
 #include "scrub/common.h"
 #include "scrub/btree.h"
 #include "scrub/trace.h"
+#include "scrub/repair.h"
 
 /* Prepare the attached inode for scrubbing. */
 static inline int
@@ -175,8 +176,11 @@ xchk_setup_inode(
 	 * saying the inode is allocated and the icache being unable to load
 	 * the inode until we can flag the corruption in xchk_inode.  The
 	 * scrub function has to note the corruption, since we're not really
-	 * supposed to do that from the setup function.
+	 * supposed to do that from the setup function.  Save the mapping to
+	 * make repairs to the ondisk inode buffer.
 	 */
+	if (xchk_could_repair(sc))
+		xrep_setup_inode(sc, &imap);
 	return 0;
 
 out_cancel:
@@ -332,6 +336,10 @@ xchk_inode_flags2(
 	if (xfs_dinode_has_bigtime(dip) && !xfs_has_bigtime(mp))
 		goto bad;
 
+	/* no large extent counts without the filesystem feature */
+	if ((flags2 & XFS_DIFLAG2_NREXT64) && !xfs_has_large_extent_counts(mp))
+		goto bad;
+
 	return;
 bad:
 	xchk_ino_set_corrupt(sc, ino);
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
new file mode 100644
index 000000000000..f1490e78766d
--- /dev/null
+++ b/fs/xfs/scrub/inode_repair.c
@@ -0,0 +1,774 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_inode_buf.h"
+#include "xfs_inode_fork.h"
+#include "xfs_ialloc.h"
+#include "xfs_da_format.h"
+#include "xfs_reflink.h"
+#include "xfs_rmap.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_quota_defs.h"
+#include "xfs_quota.h"
+#include "xfs_ag.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/btree.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+
+/*
+ * Inode Repair
+ *
+ * Roughly speaking, inode problems can be classified based on whether or not
+ * they trip the dinode verifiers.  If those trip, then we won't be able to
+ * _iget ourselves the inode.
+ *
+ * Therefore, the xrep_dinode_* functions fix anything that will cause the
+ * inode buffer verifier or the dinode verifier.  The xrep_inode_* functions
+ * fix things on live incore inodes.
+ */
+
+/*
+ * All the information we need to repair the ondisk inode if we can't iget the
+ * incore inode.  We don't allocate this buffer unless we're going to perform
+ * a repair to the ondisk inode cluster buffer.
+ */
+struct xrep_inode {
+	/* Inode mapping that we saved from the initial lookup attempt. */
+	struct xfs_imap		imap;
+
+	struct xfs_scrub	*sc;
+};
+
+/* Setup function for inode repair. */
+int
+xrep_setup_inode(
+	struct xfs_scrub	*sc,
+	struct xfs_imap		*imap)
+{
+	struct xrep_inode	*ri;
+
+	/*
+	 * The only information that needs to be passed between inode scrub and
+	 * repair is the location of the ondisk metadata if iget fails.  The
+	 * rest of struct xrep_inode is context data that we need to massage
+	 * the ondisk inode to the point that iget will work, which means that
+	 * we don't allocate anything at all if the incore inode is loaded.
+	 */
+	if (!imap)
+		return 0;
+
+	sc->buf = kzalloc(sizeof(struct xrep_inode), XCHK_GFP_FLAGS);
+	if (!sc->buf)
+		return -ENOMEM;
+
+	ri = sc->buf;
+	memcpy(&ri->imap, imap, sizeof(struct xfs_imap));
+	ri->sc = sc;
+	return 0;
+}
+
+/* Make sure this inode cluster buffer can pass the inode buffer verifier. */
+STATIC void
+xrep_dinode_buf(
+	struct xfs_scrub	*sc,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_trans	*tp = sc->tp;
+	struct xfs_perag	*pag;
+	struct xfs_dinode	*dip;
+	xfs_agnumber_t		agno;
+	xfs_agino_t		agino;
+	int			ioff;
+	int			i;
+	int			ni;
+	bool			crc_ok;
+	bool			magic_ok;
+	bool			unlinked_ok;
+
+	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
+	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
+	pag = xfs_perag_get(mp, agno);
+	for (i = 0; i < ni; i++) {
+		ioff = i << mp->m_sb.sb_inodelog;
+		dip = xfs_buf_offset(bp, ioff);
+		agino = be32_to_cpu(dip->di_next_unlinked);
+
+		unlinked_ok = magic_ok = crc_ok = false;
+
+		if (xfs_verify_agino_or_null(pag, agino))
+			unlinked_ok = true;
+
+		if (dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
+		    xfs_dinode_good_version(mp, dip->di_version))
+			magic_ok = true;
+
+		if (xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
+				XFS_DINODE_CRC_OFF))
+			crc_ok = true;
+
+		if (magic_ok && unlinked_ok && crc_ok)
+			continue;
+
+		if (!magic_ok) {
+			dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+			dip->di_version = 3;
+		}
+		if (!unlinked_ok)
+			dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
+		xfs_dinode_calc_crc(mp, dip);
+		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
+		xfs_trans_log_buf(tp, bp, ioff, ioff + sizeof(*dip) - 1);
+	}
+	xfs_perag_put(pag);
+}
+
+/* Reinitialize things that never change in an inode. */
+STATIC void
+xrep_dinode_header(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	trace_xrep_dinode_header(sc, dip);
+
+	dip->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+	if (!xfs_dinode_good_version(sc->mp, dip->di_version))
+		dip->di_version = 3;
+	dip->di_ino = cpu_to_be64(sc->sm->sm_ino);
+	uuid_copy(&dip->di_uuid, &sc->mp->m_sb.sb_meta_uuid);
+	dip->di_gen = cpu_to_be32(sc->sm->sm_gen);
+}
+
+/* Turn di_mode into /something/ recognizable. */
+STATIC void
+xrep_dinode_mode(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	uint16_t		mode;
+
+	trace_xrep_dinode_mode(sc, dip);
+
+	mode = be16_to_cpu(dip->di_mode);
+	if (mode == 0 || xfs_mode_to_ftype(mode) != XFS_DIR3_FT_UNKNOWN)
+		return;
+
+	/* bad mode, so we set it to a file that only root can read */
+	mode = S_IFREG;
+	dip->di_mode = cpu_to_be16(mode);
+	dip->di_uid = 0;
+	dip->di_gid = 0;
+}
+
+/* Fix any conflicting flags that the verifiers complain about. */
+STATIC void
+xrep_dinode_flags(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_mount	*mp = sc->mp;
+	uint64_t		flags2;
+	uint16_t		mode;
+	uint16_t		flags;
+
+	trace_xrep_dinode_flags(sc, dip);
+
+	mode = be16_to_cpu(dip->di_mode);
+	flags = be16_to_cpu(dip->di_flags);
+	flags2 = be64_to_cpu(dip->di_flags2);
+
+	if (xfs_has_reflink(mp) && S_ISREG(mode))
+		flags2 |= XFS_DIFLAG2_REFLINK;
+	else
+		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
+	if (flags & XFS_DIFLAG_REALTIME)
+		flags2 &= ~XFS_DIFLAG2_REFLINK;
+	if (flags2 & XFS_DIFLAG2_REFLINK)
+		flags2 &= ~XFS_DIFLAG2_DAX;
+	if (!xfs_has_bigtime(mp))
+		flags2 &= ~XFS_DIFLAG2_BIGTIME;
+	if (!xfs_has_large_extent_counts(mp))
+		flags2 &= ~XFS_DIFLAG2_NREXT64;
+	if (flags2 & XFS_DIFLAG2_NREXT64)
+		dip->di_nrext64_pad = 0;
+	else if (dip->di_version >= 3)
+		dip->di_v3_pad = 0;
+	dip->di_flags = cpu_to_be16(flags);
+	dip->di_flags2 = cpu_to_be64(flags2);
+}
+
+/*
+ * Blow out symlink; now it points to the current dir.  We don't have to worry
+ * about incore state because this inode is failing the verifiers.
+ */
+STATIC void
+xrep_dinode_zap_symlink(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	char			*p;
+
+	trace_xrep_dinode_zap_symlink(sc, dip);
+
+	dip->di_format = XFS_DINODE_FMT_LOCAL;
+	dip->di_size = cpu_to_be64(1);
+	p = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	*p = '.';
+}
+
+/*
+ * Blow out dir, make it point to the root.  In the future repair will
+ * reconstruct this directory for us.  Note that there's no in-core directory
+ * inode because the sf verifier tripped, so we don't have to worry about the
+ * dentry cache.
+ */
+STATIC void
+xrep_dinode_zap_dir(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_dir2_sf_hdr	*sfp;
+	int			i8count;
+
+	trace_xrep_dinode_zap_dir(sc, dip);
+
+	dip->di_format = XFS_DINODE_FMT_LOCAL;
+	i8count = mp->m_sb.sb_rootino > XFS_DIR2_MAX_SHORT_INUM;
+	sfp = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
+	sfp->count = 0;
+	sfp->i8count = i8count;
+	xfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
+	dip->di_size = cpu_to_be64(xfs_dir2_sf_hdr_size(i8count));
+}
+
+/* Make sure we don't have a garbage file size. */
+STATIC void
+xrep_dinode_size(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	uint64_t		size;
+	uint16_t		mode;
+
+	trace_xrep_dinode_size(sc, dip);
+
+	mode = be16_to_cpu(dip->di_mode);
+	size = be64_to_cpu(dip->di_size);
+	switch (mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		/* di_size can't be nonzero for special files */
+		dip->di_size = 0;
+		break;
+	case S_IFREG:
+		/* Regular files can't be larger than 2^63-1 bytes. */
+		dip->di_size = cpu_to_be64(size & ~(1ULL << 63));
+		break;
+	case S_IFLNK:
+		/*
+		 * Truncate ridiculously oversized symlinks.  If the size is
+		 * zero, reset it to point to the current directory.  Both of
+		 * these conditions trigger dinode verifier errors, so there
+		 * is no in-core state to reset.
+		 */
+		if (size > XFS_SYMLINK_MAXLEN)
+			dip->di_size = cpu_to_be64(XFS_SYMLINK_MAXLEN);
+		else if (size == 0)
+			xrep_dinode_zap_symlink(sc, dip);
+		break;
+	case S_IFDIR:
+		/*
+		 * Directories can't have a size larger than 32G.  If the size
+		 * is zero, reset it to an empty directory.  Both of these
+		 * conditions trigger dinode verifier errors, so there is no
+		 * in-core state to reset.
+		 */
+		if (size > XFS_DIR2_SPACE_SIZE)
+			dip->di_size = cpu_to_be64(XFS_DIR2_SPACE_SIZE);
+		else if (size == 0)
+			xrep_dinode_zap_dir(sc, dip);
+		break;
+	}
+}
+
+/* Fix extent size hints. */
+STATIC void
+xrep_dinode_extsize_hints(
+	struct xfs_scrub	*sc,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_mount	*mp = sc->mp;
+	uint64_t		flags2;
+	uint16_t		flags;
+	uint16_t		mode;
+	xfs_failaddr_t		fa;
+
+	trace_xrep_dinode_extsize_hints(sc, dip);
+
+	mode = be16_to_cpu(dip->di_mode);
+	flags = be16_to_cpu(dip->di_flags);
+	flags2 = be64_to_cpu(dip->di_flags2);
+
+	fa = xfs_inode_validate_extsize(mp, be32_to_cpu(dip->di_extsize),
+			mode, flags);
+	if (fa) {
+		dip->di_extsize = 0;
+		dip->di_flags &= ~cpu_to_be16(XFS_DIFLAG_EXTSIZE |
+					      XFS_DIFLAG_EXTSZINHERIT);
+	}
+
+	if (dip->di_version < 3)
+		return;
+
+	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
+			mode, flags, flags2);
+	if (fa) {
+		dip->di_cowextsize = 0;
+		dip->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
+	}
+}
+
+/* Inode didn't pass verifiers, so fix the raw buffer and retry iget. */
+STATIC int
+xrep_dinode_core(
+	struct xrep_inode	*ri)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	struct xfs_buf		*bp;
+	struct xfs_dinode	*dip;
+	xfs_ino_t		ino = sc->sm->sm_ino;
+	bool			dontcare;
+	int			error;
+
+	/* Read the inode cluster buffer. */
+	error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
+			ri->imap.im_blkno, ri->imap.im_len, XBF_UNMAPPED, &bp,
+			NULL);
+	if (error)
+		return error;
+
+	/*
+	 * Make absolutely sure this inode isn't in core, because we don't
+	 * want to create a cache coherence problem.
+	 */
+	error = xfs_icache_inode_is_allocated(sc->mp, sc->tp, ino, &dontcare);
+	if (error == 0) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	/* Make sure we can pass the inode buffer verifier. */
+	xrep_dinode_buf(sc, bp);
+	bp->b_ops = &xfs_inode_buf_ops;
+
+	/* Fix everything the verifier will complain about. */
+	dip = xfs_buf_offset(bp, ri->imap.im_boffset);
+	xrep_dinode_header(sc, dip);
+	xrep_dinode_mode(sc, dip);
+	xrep_dinode_flags(sc, dip);
+	xrep_dinode_size(sc, dip);
+	xrep_dinode_extsize_hints(sc, dip);
+
+	/* Write out the inode. */
+	trace_xrep_dinode_fixed(sc, dip);
+	xfs_dinode_calc_crc(sc->mp, dip);
+	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_DINO_BUF);
+	xfs_trans_log_buf(sc->tp, bp, ri->imap.im_boffset,
+			ri->imap.im_boffset + sc->mp->m_sb.sb_inodesize - 1);
+
+	/*
+	 * Now that we've finished rewriting anything in the ondisk metadata
+	 * that would prevent iget from giving us an incore inode, commit the
+	 * inode cluster buffer updates and drop the AGI buffer that we've been
+	 * holding since scrub setup.
+	 */
+	error = xrep_trans_commit(sc);
+	if (error)
+		return error;
+
+	/* Try again to load the inode. */
+	error = xchk_iget(sc, ino, &sc->ip);
+	if (error)
+		return error;
+
+	xchk_ilock(sc, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+
+	error = xrep_ino_dqattach(sc);
+	if (error)
+		return error;
+
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
+	return 0;
+}
+
+/* Fix everything xfs_dinode_verify cares about. */
+STATIC int
+xrep_dinode_problems(
+	struct xrep_inode	*ri)
+{
+	struct xfs_scrub	*sc = ri->sc;
+	int			error;
+
+	error = xrep_dinode_core(ri);
+	if (error)
+		return error;
+
+	/* We had to fix a totally busted inode, schedule quotacheck. */
+	if (XFS_IS_UQUOTA_ON(sc->mp))
+		xrep_force_quotacheck(sc, XFS_DQTYPE_USER);
+	if (XFS_IS_GQUOTA_ON(sc->mp))
+		xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
+	if (XFS_IS_PQUOTA_ON(sc->mp))
+		xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
+
+	return 0;
+}
+
+/*
+ * Fix problems that the verifiers don't care about.  In general these are
+ * errors that don't cause problems elsewhere in the kernel that we can easily
+ * detect, so we don't check them all that rigorously.
+ */
+
+/* Make sure block and extent counts are ok. */
+STATIC int
+xrep_inode_blockcounts(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_ifork	*ifp;
+	xfs_filblks_t		count;
+	xfs_filblks_t		acount;
+	xfs_extnum_t		nextents;
+	int			error;
+
+	trace_xrep_inode_blockcounts(sc);
+
+	/* Set data fork counters from the data fork mappings. */
+	error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_DATA_FORK,
+			&nextents, &count);
+	if (error)
+		return error;
+	if (xfs_has_reflink(sc->mp)) {
+		; /* data fork blockcount can exceed physical storage */
+	} else if (XFS_IS_REALTIME_INODE(sc->ip)) {
+		if (count >= sc->mp->m_sb.sb_rblocks)
+			return -EFSCORRUPTED;
+	} else {
+		if (count >= sc->mp->m_sb.sb_dblocks)
+			return -EFSCORRUPTED;
+	}
+	error = xrep_ino_ensure_extent_count(sc, XFS_DATA_FORK, nextents);
+	if (error)
+		return error;
+	sc->ip->i_df.if_nextents = nextents;
+
+	/* Set attr fork counters from the attr fork mappings. */
+	ifp = xfs_ifork_ptr(sc->ip, XFS_ATTR_FORK);
+	if (ifp) {
+		error = xfs_bmap_count_blocks(sc->tp, sc->ip, XFS_ATTR_FORK,
+				&nextents, &acount);
+		if (error)
+			return error;
+		if (count >= sc->mp->m_sb.sb_dblocks)
+			return -EFSCORRUPTED;
+		error = xrep_ino_ensure_extent_count(sc, XFS_ATTR_FORK,
+				nextents);
+		if (error)
+			return error;
+		ifp->if_nextents = nextents;
+	} else {
+		acount = 0;
+	}
+
+	sc->ip->i_nblocks = count + acount;
+	return 0;
+}
+
+/* Check for invalid uid/gid/prid. */
+STATIC void
+xrep_inode_ids(
+	struct xfs_scrub	*sc)
+{
+	trace_xrep_inode_ids(sc);
+
+	if (i_uid_read(VFS_I(sc->ip)) == -1U) {
+		i_uid_write(VFS_I(sc->ip), 0);
+		VFS_I(sc->ip)->i_mode &= ~(S_ISUID | S_ISGID);
+		if (XFS_IS_UQUOTA_ON(sc->mp))
+			xrep_force_quotacheck(sc, XFS_DQTYPE_USER);
+	}
+
+	if (i_gid_read(VFS_I(sc->ip)) == -1U) {
+		i_gid_write(VFS_I(sc->ip), 0);
+		VFS_I(sc->ip)->i_mode &= ~(S_ISUID | S_ISGID);
+		if (XFS_IS_GQUOTA_ON(sc->mp))
+			xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
+	}
+
+	if (sc->ip->i_projid == -1U) {
+		sc->ip->i_projid = 0;
+		if (XFS_IS_PQUOTA_ON(sc->mp))
+			xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
+	}
+}
+
+static inline void
+xrep_clamp_nsec(
+	struct timespec64	*ts)
+{
+	ts->tv_nsec = clamp_t(long, ts->tv_nsec, 0, NSEC_PER_SEC);
+}
+
+/* Nanosecond counters can't have more than 1 billion. */
+STATIC void
+xrep_inode_timestamps(
+	struct xfs_inode	*ip)
+{
+	xrep_clamp_nsec(&VFS_I(ip)->i_atime);
+	xrep_clamp_nsec(&VFS_I(ip)->i_mtime);
+	xrep_clamp_nsec(&VFS_I(ip)->i_ctime);
+	xrep_clamp_nsec(&ip->i_crtime);
+}
+
+/* Fix inode flags that don't make sense together. */
+STATIC void
+xrep_inode_flags(
+	struct xfs_scrub	*sc)
+{
+	uint16_t		mode;
+
+	trace_xrep_inode_flags(sc);
+
+	mode = VFS_I(sc->ip)->i_mode;
+
+	/* Clear junk flags */
+	if (sc->ip->i_diflags & ~XFS_DIFLAG_ANY)
+		sc->ip->i_diflags &= ~XFS_DIFLAG_ANY;
+
+	/* NEWRTBM only applies to realtime bitmaps */
+	if (sc->ip->i_ino == sc->mp->m_sb.sb_rbmino)
+		sc->ip->i_diflags |= XFS_DIFLAG_NEWRTBM;
+	else
+		sc->ip->i_diflags &= ~XFS_DIFLAG_NEWRTBM;
+
+	/* These only make sense for directories. */
+	if (!S_ISDIR(mode))
+		sc->ip->i_diflags &= ~(XFS_DIFLAG_RTINHERIT |
+					  XFS_DIFLAG_EXTSZINHERIT |
+					  XFS_DIFLAG_PROJINHERIT |
+					  XFS_DIFLAG_NOSYMLINKS);
+
+	/* These only make sense for files. */
+	if (!S_ISREG(mode))
+		sc->ip->i_diflags &= ~(XFS_DIFLAG_REALTIME |
+					  XFS_DIFLAG_EXTSIZE);
+
+	/* These only make sense for non-rt files. */
+	if (sc->ip->i_diflags & XFS_DIFLAG_REALTIME)
+		sc->ip->i_diflags &= ~XFS_DIFLAG_FILESTREAM;
+
+	/* Immutable and append only?  Drop the append. */
+	if ((sc->ip->i_diflags & XFS_DIFLAG_IMMUTABLE) &&
+	    (sc->ip->i_diflags & XFS_DIFLAG_APPEND))
+		sc->ip->i_diflags &= ~XFS_DIFLAG_APPEND;
+
+	/* Clear junk flags. */
+	if (sc->ip->i_diflags2 & ~XFS_DIFLAG2_ANY)
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_ANY;
+
+	/* No reflink flag unless we support it and it's a file. */
+	if (!xfs_has_reflink(sc->mp) || !S_ISREG(mode))
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+
+	/* DAX only applies to files and dirs. */
+	if (!(S_ISREG(mode) || S_ISDIR(mode)))
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_DAX;
+
+	/* No reflink files on the realtime device. */
+	if (sc->ip->i_diflags & XFS_DIFLAG_REALTIME)
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+
+	/* No mixing reflink and DAX yet. */
+	if (sc->ip->i_diflags2 & XFS_DIFLAG2_REFLINK)
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_DAX;
+}
+
+/*
+ * Fix size problems with block/node format directories.  If we fail to find
+ * the extent list, just bail out and let the bmapbtd repair functions clean
+ * up that mess.
+ */
+STATIC void
+xrep_inode_blockdir_size(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	struct xfs_ifork	*ifp;
+	xfs_fileoff_t		off;
+	int			error;
+
+	trace_xrep_inode_blockdir_size(sc);
+
+	/* Find the last block before 32G; this is the dir size. */
+	error = xfs_iread_extents(sc->tp, sc->ip, XFS_DATA_FORK);
+	if (error)
+		return;
+
+	ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
+	off = XFS_B_TO_FSB(sc->mp, XFS_DIR2_SPACE_SIZE);
+	if (!xfs_iext_lookup_extent_before(sc->ip, ifp, &off, &icur, &got)) {
+		/* zero-extents directory? */
+		return;
+	}
+
+	off = got.br_startoff + got.br_blockcount;
+	sc->ip->i_disk_size = min_t(loff_t, XFS_DIR2_SPACE_SIZE,
+			XFS_FSB_TO_B(sc->mp, off));
+}
+
+/* Fix size problems with short format directories. */
+STATIC void
+xrep_inode_sfdir_size(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_ifork	*ifp;
+
+	trace_xrep_inode_sfdir_size(sc);
+
+	ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
+	sc->ip->i_disk_size = ifp->if_bytes;
+}
+
+/*
+ * Fix any irregularities in an inode's size now that we can iterate extent
+ * maps and access other regular inode data.
+ */
+STATIC void
+xrep_inode_size(
+	struct xfs_scrub	*sc)
+{
+	trace_xrep_inode_size(sc);
+
+	/*
+	 * Currently we only support fixing size on extents or btree format
+	 * directories.  Files can be any size and sizes for the other inode
+	 * special types are fixed by xrep_dinode_size.
+	 */
+	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
+		return;
+	switch (sc->ip->i_df.if_format) {
+	case XFS_DINODE_FMT_EXTENTS:
+	case XFS_DINODE_FMT_BTREE:
+		xrep_inode_blockdir_size(sc);
+		break;
+	case XFS_DINODE_FMT_LOCAL:
+		xrep_inode_sfdir_size(sc);
+		break;
+	}
+}
+
+/* Fix extent size hint problems. */
+STATIC void
+xrep_inode_extsize(
+	struct xfs_scrub	*sc)
+{
+	/* Fix misaligned extent size hints on a directory. */
+	if ((sc->ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+	    (sc->ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
+	    sc->ip->i_extsize % sc->mp->m_sb.sb_rextsize > 0) {
+		sc->ip->i_extsize = 0;
+		sc->ip->i_diflags &= ~XFS_DIFLAG_EXTSZINHERIT;
+	}
+}
+
+/* Fix any irregularities in an inode that the verifiers don't catch. */
+STATIC int
+xrep_inode_problems(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	error = xrep_inode_blockcounts(sc);
+	if (error)
+		return error;
+	xrep_inode_timestamps(sc->ip);
+	xrep_inode_flags(sc);
+	xrep_inode_ids(sc);
+	xrep_inode_size(sc);
+	xrep_inode_extsize(sc);
+
+	trace_xrep_inode_fixed(sc);
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	return xrep_roll_trans(sc);
+}
+
+/* Repair an inode's fields. */
+int
+xrep_inode(
+	struct xfs_scrub	*sc)
+{
+	int			error = 0;
+
+	/*
+	 * No inode?  That means we failed the _iget verifiers.  Repair all
+	 * the things that the inode verifiers care about, then retry _iget.
+	 */
+	if (!sc->ip) {
+		struct xrep_inode	*ri = sc->buf;
+
+		ASSERT(ri != NULL);
+
+		error = xrep_dinode_problems(ri);
+		if (error)
+			return error;
+
+		/* By this point we had better have a working incore inode. */
+		if (!sc->ip)
+			return -EFSCORRUPTED;
+	}
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/* If we found corruption of any kind, try to fix it. */
+	if ((sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT) ||
+	    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)) {
+		error = xrep_inode_problems(sc);
+		if (error)
+			return error;
+	}
+
+	/* See if we can clear the reflink flag. */
+	if (xfs_is_reflink_inode(sc->ip))
+		return xfs_reflink_clear_inode_flag(sc->ip, &sc->tp);
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index e3bcbbcb373e..f06fb50d9082 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -741,6 +741,38 @@ xrep_ino_dqattach(
 }
 #endif /* CONFIG_XFS_QUOTA */
 
+/*
+ * Ensure that the inode being repaired is ready to handle a certain number of
+ * extents, or return EFSCORRUPTED.  Caller must hold the ILOCK of the inode
+ * being repaired and have joined it to the scrub transaction.
+ */
+int
+xrep_ino_ensure_extent_count(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	xfs_extnum_t		nextents)
+{
+	xfs_extnum_t		max_extents;
+	bool			large_extcount;
+
+	large_extcount = xfs_inode_has_large_extent_counts(sc->ip);
+	max_extents = xfs_iext_max_nextents(large_extcount, whichfork);
+	if (nextents <= max_extents)
+		return 0;
+	if (large_extcount)
+		return -EFSCORRUPTED;
+	if (!xfs_has_large_extent_counts(sc->mp))
+		return -EFSCORRUPTED;
+
+	max_extents = xfs_iext_max_nextents(true, whichfork);
+	if (nextents > max_extents)
+		return -EFSCORRUPTED;
+
+	sc->ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	return 0;
+}
+
 /* Initialize all the btree cursors for an AG repair. */
 void
 xrep_ag_btcur_init(
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 441b6b073001..892cb593a716 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -26,6 +26,16 @@ bool xrep_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
 		enum xfs_ag_resv_type type);
 xfs_extlen_t xrep_calc_ag_resblks(struct xfs_scrub *sc);
 
+static inline int
+xrep_trans_commit(
+	struct xfs_scrub	*sc)
+{
+	int			error = xfs_trans_commit(sc->tp);
+
+	sc->tp = NULL;
+	return error;
+}
+
 struct xbitmap;
 struct xagb_bitmap;
 
@@ -57,11 +67,16 @@ int xrep_ino_dqattach(struct xfs_scrub *sc);
 # define xrep_ino_dqattach(sc)			(0)
 #endif /* CONFIG_XFS_QUOTA */
 
+int xrep_ino_ensure_extent_count(struct xfs_scrub *sc, int whichfork,
+		xfs_extnum_t nextents);
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
 
+struct xfs_imap;
+int xrep_setup_inode(struct xfs_scrub *sc, struct xfs_imap *imap);
+
 void xrep_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
 
 /* Metadata revalidators */
@@ -79,6 +94,7 @@ int xrep_agi(struct xfs_scrub *sc);
 int xrep_allocbt(struct xfs_scrub *sc);
 int xrep_iallocbt(struct xfs_scrub *sc);
 int xrep_refcountbt(struct xfs_scrub *sc);
+int xrep_inode(struct xfs_scrub *sc);
 
 int xrep_reinit_pagf(struct xfs_scrub *sc);
 int xrep_reinit_pagi(struct xfs_scrub *sc);
@@ -123,6 +139,8 @@ xrep_setup_nothing(
 }
 #define xrep_setup_ag_allocbt		xrep_setup_nothing
 
+#define xrep_setup_inode(sc, imap)	((void)0)
+
 #define xrep_revalidate_allocbt		(NULL)
 #define xrep_revalidate_iallocbt	(NULL)
 
@@ -134,6 +152,7 @@ xrep_setup_nothing(
 #define xrep_allocbt			xrep_notsupported
 #define xrep_iallocbt			xrep_notsupported
 #define xrep_refcountbt			xrep_notsupported
+#define xrep_inode			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 449c3e623c63..ace21c484cbc 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -283,7 +283,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_inode,
 		.scrub	= xchk_inode,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_inode,
 	},
 	[XFS_SCRUB_TYPE_BMBTD] = {	/* inode data fork */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 8532dcd16630..5313fce1c69d 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1346,6 +1346,135 @@ DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_alloc_blocks);
 DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_free_blocks);
 DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_claim_block);
 
+DECLARE_EVENT_CLASS(xrep_dinode_class,
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_dinode *dip),
+	TP_ARGS(sc, dip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(uint16_t, mode)
+		__field(uint8_t, version)
+		__field(uint8_t, format)
+		__field(uint32_t, uid)
+		__field(uint32_t, gid)
+		__field(uint64_t, size)
+		__field(uint64_t, nblocks)
+		__field(uint32_t, extsize)
+		__field(uint32_t, nextents)
+		__field(uint16_t, anextents)
+		__field(uint8_t, forkoff)
+		__field(uint8_t, aformat)
+		__field(uint16_t, flags)
+		__field(uint32_t, gen)
+		__field(uint64_t, flags2)
+		__field(uint32_t, cowextsize)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->ino = sc->sm->sm_ino;
+		__entry->mode = be16_to_cpu(dip->di_mode);
+		__entry->version = dip->di_version;
+		__entry->format = dip->di_format;
+		__entry->uid = be32_to_cpu(dip->di_uid);
+		__entry->gid = be32_to_cpu(dip->di_gid);
+		__entry->size = be64_to_cpu(dip->di_size);
+		__entry->nblocks = be64_to_cpu(dip->di_nblocks);
+		__entry->extsize = be32_to_cpu(dip->di_extsize);
+		__entry->nextents = be32_to_cpu(dip->di_nextents);
+		__entry->anextents = be16_to_cpu(dip->di_anextents);
+		__entry->forkoff = dip->di_forkoff;
+		__entry->aformat = dip->di_aformat;
+		__entry->flags = be16_to_cpu(dip->di_flags);
+		__entry->gen = be32_to_cpu(dip->di_gen);
+		__entry->flags2 = be64_to_cpu(dip->di_flags2);
+		__entry->cowextsize = be32_to_cpu(dip->di_cowextsize);
+	),
+	TP_printk("dev %d:%d ino 0x%llx mode 0x%x version %u format %u uid %u gid %u disize 0x%llx nblocks 0x%llx extsize %u nextents %u anextents %u forkoff 0x%x aformat %u flags 0x%x gen 0x%x flags2 0x%llx cowextsize %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->mode,
+		  __entry->version,
+		  __entry->format,
+		  __entry->uid,
+		  __entry->gid,
+		  __entry->size,
+		  __entry->nblocks,
+		  __entry->extsize,
+		  __entry->nextents,
+		  __entry->anextents,
+		  __entry->forkoff,
+		  __entry->aformat,
+		  __entry->flags,
+		  __entry->gen,
+		  __entry->flags2,
+		  __entry->cowextsize)
+)
+
+#define DEFINE_REPAIR_DINODE_EVENT(name) \
+DEFINE_EVENT(xrep_dinode_class, name, \
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_dinode *dip), \
+	TP_ARGS(sc, dip))
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_header);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_mode);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_flags);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_size);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_extsize_hints);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_zap_symlink);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_zap_dir);
+DEFINE_REPAIR_DINODE_EVENT(xrep_dinode_fixed);
+
+DECLARE_EVENT_CLASS(xrep_inode_class,
+	TP_PROTO(struct xfs_scrub *sc),
+	TP_ARGS(sc),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_rfsblock_t, nblocks)
+		__field(uint16_t, flags)
+		__field(uint64_t, flags2)
+		__field(uint32_t, nextents)
+		__field(uint8_t, format)
+		__field(uint32_t, anextents)
+		__field(uint8_t, aformat)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->ino = sc->sm->sm_ino;
+		__entry->size = sc->ip->i_disk_size;
+		__entry->nblocks = sc->ip->i_nblocks;
+		__entry->flags = sc->ip->i_diflags;
+		__entry->flags2 = sc->ip->i_diflags2;
+		__entry->nextents = sc->ip->i_df.if_nextents;
+		__entry->format = sc->ip->i_df.if_format;
+		__entry->anextents = sc->ip->i_af.if_nextents;
+		__entry->aformat = sc->ip->i_af.if_format;
+	),
+	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx nblocks 0%llx flags 0x%x flags2 0x%llx nextents %u format %u anextents %u aformat %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->nblocks,
+		  __entry->flags,
+		  __entry->flags2,
+		  __entry->nextents,
+		  __entry->format,
+		  __entry->anextents,
+		  __entry->aformat)
+)
+
+#define DEFINE_REPAIR_INODE_EVENT(name) \
+DEFINE_EVENT(xrep_inode_class, name, \
+	TP_PROTO(struct xfs_scrub *sc), \
+	TP_ARGS(sc))
+DEFINE_REPAIR_INODE_EVENT(xrep_inode_blockcounts);
+DEFINE_REPAIR_INODE_EVENT(xrep_inode_ids);
+DEFINE_REPAIR_INODE_EVENT(xrep_inode_flags);
+DEFINE_REPAIR_INODE_EVENT(xrep_inode_blockdir_size);
+DEFINE_REPAIR_INODE_EVENT(xrep_inode_sfdir_size);
+DEFINE_REPAIR_INODE_EVENT(xrep_inode_size);
+DEFINE_REPAIR_INODE_EVENT(xrep_inode_fixed);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

