Return-Path: <linux-xfs+bounces-1677-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CC76820F47
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 23:01:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE6161F2202D
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 22:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF067C12B;
	Sun, 31 Dec 2023 22:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rOiY5pzG"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0B1C127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F194CC433C7;
	Sun, 31 Dec 2023 22:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060076;
	bh=YgmmpQbX5hop6oq1XSXF8U7+XI2Mc4waI+U94unp/A4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rOiY5pzGIYDS9Q9RLM11RxeIWqGjYzUuCerqrXyFkZvsfRzu33i+CXYaIWF/x+Tm9
	 aIse6J+yhtqGCR2wqzHTkqY9MEW72cG0CmN4rScIwVrqvYz3n2qvufUivfXUGsr+wn
	 CWdfF6IBpe7/Zryl/i25WO9IRmNu4nfcjLp2Ta19s4LmgSBTOYVFnYioYpyBo5tCFk
	 56Y0ImUfUx0CxWP+7dXh/fVomY4bQRXYSZrInelhl5ONk6HUQ6C081dsngyZRK9DxK
	 jVt34BYz33AaCHYLru+ZCtts7ldIa/CxYQ12uEv8jU2L7xV26j/yjrUdrsJiZWR2Lk
	 a6Hoh1Lb7OX+Q==
Date: Sun, 31 Dec 2023 14:01:15 -0800
Subject: [PATCH 2/5] xfs: whine to dmesg when we encounter errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404854753.1769671.12991524814359250998.stgit@frogsfrogsfrogs>
In-Reply-To: <170404854709.1769671.12231107418026207335.stgit@frogsfrogsfrogs>
References: <170404854709.1769671.12231107418026207335.stgit@frogsfrogsfrogs>
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

Forward everything scrub whines about to dmesg.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig         |   13 ++++++
 fs/xfs/scrub/btree.c   |   88 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c  |  107 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h  |    1 
 fs/xfs/scrub/dabtree.c |   24 +++++++++++
 fs/xfs/scrub/inode.c   |    4 ++
 fs/xfs/scrub/scrub.c   |   40 ++++++++++++++++++
 fs/xfs/scrub/trace.c   |   22 ++++++++++
 fs/xfs/scrub/trace.h   |    2 +
 fs/xfs/xfs_globals.c   |    5 ++
 fs/xfs/xfs_sysctl.h    |    1 
 fs/xfs/xfs_sysfs.c     |   32 ++++++++++++++
 12 files changed, 339 insertions(+)


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 0ed89b2381936..be17dbeb0eb43 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -172,6 +172,19 @@ config XFS_ONLINE_SCRUB_STATS
 
 	  If unsure, say N.
 
+config XFS_ONLINE_SCRUB_WHINE
+	bool "XFS online metadata verbose logging by default"
+	default y
+	depends on XFS_ONLINE_SCRUB
+	help
+	  If you say Y here, the kernel will by default log the outcomes of all
+	  scrub and repair operations, as well as any corruptions found.  This
+	  may slow down scrub due to printk logging overhead timers.
+
+	  This value can be changed by editing /sys/fs/xfs/debug/scrub_whine
+
+	  If unsure, say N.
+
 choice
 	prompt "XFS hook implementation"
 	depends on XFS_FS && XFS_LIVE_HOOKS && XFS_ONLINE_SCRUB
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 1935b9ce1885c..e1b22ac074d34 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -11,6 +11,8 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_log_format.h"
+#include "xfs_ag.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -18,6 +20,62 @@
 
 /* btree scrubbing */
 
+/* Figure out which block the btree cursor was pointing to. */
+static inline xfs_fsblock_t
+xchk_btree_cur_fsbno(
+	struct xfs_btree_cur		*cur,
+	int				level)
+{
+	if (level < cur->bc_nlevels && cur->bc_levels[level].bp)
+		return XFS_DADDR_TO_FSB(cur->bc_mp,
+				xfs_buf_daddr(cur->bc_levels[level].bp));
+	else if (level == cur->bc_nlevels - 1 &&
+		 (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
+		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
+	else if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS))
+		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno, 0);
+	return NULLFSBLOCK;
+}
+
+static inline void
+process_error_whine(
+	struct xfs_scrub	*sc,
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			*error,
+	__u32			errflag,
+	void			*ret_ip)
+{
+	xfs_fsblock_t		fsbno = xchk_btree_cur_fsbno(cur, level);
+
+	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+		xchk_whine(sc->mp, "ino 0x%llx fork %d type %s btnum %d level %d ptr %d agno 0x%x agbno 0x%x error %d errflag 0x%x ret_ip %pS",
+				cur->bc_ino.ip->i_ino,
+				cur->bc_ino.whichfork,
+				xchk_type_string(sc->sm->sm_type),
+				cur->bc_btnum,
+				level,
+				cur->bc_levels[level].ptr,
+				XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
+				XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
+				*error,
+				errflag,
+				ret_ip);
+		return;
+	}
+
+	xchk_whine(sc->mp, "type %s btnum %d level %d ptr %d agno 0x%x agbno 0x%x error %d errflag 0x%x ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type),
+			cur->bc_btnum,
+			level,
+			cur->bc_levels[level].ptr,
+			XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
+			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
+			*error,
+			errflag,
+			ret_ip);
+}
+
 /*
  * Check for btree operation errors.  See the section about handling
  * operational errors in common.c.
@@ -44,9 +102,13 @@ __xchk_btree_process_error(
 	case -EFSCORRUPTED:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		process_error_whine(sc, cur, level, error, errflag, ret_ip);
 		*error = 0;
 		fallthrough;
 	default:
+		if (*error)
+			process_error_whine(sc, cur, level, error, errflag,
+					ret_ip);
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			trace_xchk_ifork_btree_op_error(sc, cur, level,
 					*error, ret_ip);
@@ -92,11 +154,37 @@ __xchk_btree_set_corrupt(
 	sc->sm->sm_flags |= errflag;
 
 	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+	{
+		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
+		xchk_whine(sc->mp, "ino 0x%llx fork %d type %s btnum %d level %d ptr %d agno 0x%x agbno 0x%x errflag 0x%x ret_ip %pS",
+				cur->bc_ino.ip->i_ino,
+				cur->bc_ino.whichfork,
+				xchk_type_string(sc->sm->sm_type),
+				cur->bc_btnum,
+				level,
+				cur->bc_levels[level].ptr,
+				XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
+				XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
+				errflag,
+				ret_ip);
 		trace_xchk_ifork_btree_error(sc, cur, level,
 				ret_ip);
+	}
 	else
+	{
+		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
+		xchk_whine(sc->mp, "type %s btnum %d level %d ptr %d agno 0x%x agbno 0x%x errflag 0x%x ret_ip %pS",
+				xchk_type_string(sc->sm->sm_type),
+				cur->bc_btnum,
+				level,
+				cur->bc_levels[level].ptr,
+				XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
+				XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
+				errflag,
+				ret_ip);
 		trace_xchk_btree_error(sc, cur, level,
 				ret_ip);
+	}
 }
 
 void
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index a9801a5bb0383..2a9741235d310 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -105,9 +105,23 @@ __xchk_process_error(
 	case -EFSCORRUPTED:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		xchk_whine(sc->mp, "type %s agno 0x%x agbno 0x%x error %d errflag 0x%x ret_ip %pS",
+				xchk_type_string(sc->sm->sm_type),
+				agno,
+				bno,
+				*error,
+				errflag,
+				ret_ip);
 		*error = 0;
 		fallthrough;
 	default:
+		if (*error)
+			xchk_whine(sc->mp, "type %s agno 0x%x agbno 0x%x error %d ret_ip %pS",
+					xchk_type_string(sc->sm->sm_type),
+					agno,
+					bno,
+					*error,
+					ret_ip);
 		trace_xchk_op_error(sc, agno, bno, *error, ret_ip);
 		break;
 	}
@@ -190,9 +204,25 @@ __xchk_fblock_process_error(
 	case -EFSCORRUPTED:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		xchk_whine(sc->mp, "ino 0x%llx fork %d type %s offset %llu error %d errflag 0x%x ret_ip %pS",
+				sc->ip->i_ino,
+				whichfork,
+				xchk_type_string(sc->sm->sm_type),
+				offset,
+				*error,
+				errflag,
+				ret_ip);
 		*error = 0;
 		fallthrough;
 	default:
+		if (*error)
+			xchk_whine(sc->mp, "ino 0x%llx fork %d type %s offset %llu error %d ret_ip %pS",
+					sc->ip->i_ino,
+					whichfork,
+					xchk_type_string(sc->sm->sm_type),
+					offset,
+					*error,
+					ret_ip);
 		trace_xchk_file_op_error(sc, whichfork, offset, *error,
 				ret_ip);
 		break;
@@ -264,6 +294,8 @@ xchk_set_corrupt(
 	struct xfs_scrub	*sc)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	xchk_whine(sc->mp, "type %s ret_ip %pS", xchk_type_string(sc->sm->sm_type),
+			__return_address);
 	trace_xchk_fs_error(sc, 0, __return_address);
 }
 
@@ -275,6 +307,11 @@ xchk_block_set_corrupt(
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 	trace_xchk_block_error(sc, xfs_buf_daddr(bp), __return_address);
+	xchk_whine(sc->mp, "type %s agno 0x%x agbno 0x%x ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type),
+			xfs_daddr_to_agno(sc->mp, xfs_buf_daddr(bp)),
+			xfs_daddr_to_agbno(sc->mp, xfs_buf_daddr(bp)),
+			__return_address);
 }
 
 #ifdef CONFIG_XFS_QUOTA
@@ -286,6 +323,8 @@ xchk_qcheck_set_corrupt(
 	xfs_dqid_t		id)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	xchk_whine(sc->mp, "type %s dqtype %u id %u ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type), dqtype, id, __return_address);
 	trace_xchk_qcheck_error(sc, dqtype, id, __return_address);
 }
 #endif /* CONFIG_XFS_QUOTA */
@@ -298,6 +337,11 @@ xchk_block_xref_set_corrupt(
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
 	trace_xchk_block_error(sc, xfs_buf_daddr(bp), __return_address);
+	xchk_whine(sc->mp, "type %s agno 0x%x agbno 0x%x ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type),
+			xfs_daddr_to_agno(sc->mp, xfs_buf_daddr(bp)),
+			xfs_daddr_to_agbno(sc->mp, xfs_buf_daddr(bp)),
+			__return_address);
 }
 
 /*
@@ -311,6 +355,8 @@ xchk_ino_set_corrupt(
 	xfs_ino_t		ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	xchk_whine(sc->mp, "ino 0x%llx type %s ret_ip %pS",
+			ino, xchk_type_string(sc->sm->sm_type), __return_address);
 	trace_xchk_ino_error(sc, ino, __return_address);
 }
 
@@ -321,6 +367,8 @@ xchk_ino_xref_set_corrupt(
 	xfs_ino_t		ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
+	xchk_whine(sc->mp, "ino 0x%llx type %s ret_ip %pS",
+			ino, xchk_type_string(sc->sm->sm_type), __return_address);
 	trace_xchk_ino_error(sc, ino, __return_address);
 }
 
@@ -332,6 +380,12 @@ xchk_fblock_set_corrupt(
 	xfs_fileoff_t		offset)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	xchk_whine(sc->mp, "ino 0x%llx fork %d type %s offset %llu ret_ip %pS",
+			sc->ip->i_ino,
+			whichfork,
+			xchk_type_string(sc->sm->sm_type),
+			offset,
+			__return_address);
 	trace_xchk_fblock_error(sc, whichfork, offset, __return_address);
 }
 
@@ -343,6 +397,12 @@ xchk_fblock_xref_set_corrupt(
 	xfs_fileoff_t		offset)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
+	xchk_whine(sc->mp, "ino 0x%llx fork %d type %s offset %llu ret_ip %pS",
+			sc->ip->i_ino,
+			whichfork,
+			xchk_type_string(sc->sm->sm_type),
+			offset,
+			__return_address);
 	trace_xchk_fblock_error(sc, whichfork, offset, __return_address);
 }
 
@@ -356,6 +416,8 @@ xchk_ino_set_warning(
 	xfs_ino_t		ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
+	xchk_whine(sc->mp, "ino 0x%llx type %s ret_ip %pS",
+			ino, xchk_type_string(sc->sm->sm_type), __return_address);
 	trace_xchk_ino_warning(sc, ino, __return_address);
 }
 
@@ -367,6 +429,12 @@ xchk_fblock_set_warning(
 	xfs_fileoff_t		offset)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
+	xchk_whine(sc->mp, "ino 0x%llx fork %d type %s offset %llu ret_ip %pS",
+			sc->ip->i_ino,
+			whichfork,
+			xchk_type_string(sc->sm->sm_type),
+			offset,
+			__return_address);
 	trace_xchk_fblock_warning(sc, whichfork, offset, __return_address);
 }
 
@@ -1312,6 +1380,10 @@ xchk_iget_for_scrubbing(
 out_cancel:
 	xchk_trans_cancel(sc);
 out_error:
+	xchk_whine(mp, "type %s agno 0x%x agbno 0x%x error %d ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type), agno,
+			XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino), error,
+			__return_address);
 	trace_xchk_op_error(sc, agno, XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino),
 			error, __return_address);
 	return error;
@@ -1453,6 +1525,10 @@ xchk_should_check_xref(
 	}
 
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XFAIL;
+	xchk_whine(sc->mp, "type %s xref error %d ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type),
+			*error,
+			__return_address);
 	trace_xchk_xref_error(sc, *error, __return_address);
 
 	/*
@@ -1484,6 +1560,11 @@ xchk_buffer_recheck(
 		return;
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 	trace_xchk_block_error(sc, xfs_buf_daddr(bp), fa);
+	xchk_whine(sc->mp, "type %s agno 0x%x agbno 0x%x ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type),
+			xfs_daddr_to_agno(sc->mp, xfs_buf_daddr(bp)),
+			xfs_daddr_to_agbno(sc->mp, xfs_buf_daddr(bp)),
+			fa);
 }
 
 static inline int
@@ -1793,3 +1874,29 @@ xchk_inode_count_blocks(
 	*count = btblocks - 1;
 	return 0;
 }
+
+/* Complain about failures... */
+void
+xchk_whine(
+	const struct xfs_mount	*mp,
+	const char		*fmt,
+	...)
+{
+	struct va_format	vaf;
+	va_list			args;
+
+	if (!xfs_globals.scrub_whine)
+		return;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_INFO "XFS (%s) %pS: %pV\n", mp->m_super->s_id,
+			__return_address, &vaf);
+	va_end(args);
+
+	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
+		xfs_stack_trace();
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index ed22e1403d0f0..53f4de067369a 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -188,6 +188,7 @@ bool xchk_ilock_nowait(struct xfs_scrub *sc, unsigned int ilock_flags);
 void xchk_iunlock(struct xfs_scrub *sc, unsigned int ilock_flags);
 
 void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
+void xchk_whine(const struct xfs_mount *mp, const char *fmt, ...);
 
 /*
  * Grab the inode at @inum.  The caller must have created a scrub transaction
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 056de4819f866..ae64db9f0bba2 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -47,9 +47,26 @@ xchk_da_process_error(
 	case -EFSCORRUPTED:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+		xchk_whine(sc->mp, "ino 0x%llx fork %d type %s dablk 0x%llx error %d ret_ip %pS",
+				sc->ip->i_ino,
+				ds->dargs.whichfork,
+				xchk_type_string(sc->sm->sm_type),
+				xfs_dir2_da_to_db(ds->dargs.geo,
+					ds->state->path.blk[level].blkno),
+				*error,
+				__return_address);
 		*error = 0;
 		fallthrough;
 	default:
+		if (*error)
+			xchk_whine(sc->mp, "ino 0x%llx fork %d type %s dablk 0x%llx error %d ret_ip %pS",
+					sc->ip->i_ino,
+					ds->dargs.whichfork,
+					xchk_type_string(sc->sm->sm_type),
+					xfs_dir2_da_to_db(ds->dargs.geo,
+						ds->state->path.blk[level].blkno),
+					*error,
+					__return_address);
 		trace_xchk_file_op_error(sc, ds->dargs.whichfork,
 				xfs_dir2_da_to_db(ds->dargs.geo,
 					ds->state->path.blk[level].blkno),
@@ -72,6 +89,13 @@ xchk_da_set_corrupt(
 
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 
+	xchk_whine(sc->mp, "ino 0x%llx fork %d type %s dablk 0x%llx ret_ip %pS",
+			sc->ip->i_ino,
+			ds->dargs.whichfork,
+			xchk_type_string(sc->sm->sm_type),
+			xfs_dir2_da_to_db(ds->dargs.geo,
+				ds->state->path.blk[level].blkno),
+			__return_address);
 	trace_xchk_fblock_error(sc, ds->dargs.whichfork,
 			xfs_dir2_da_to_db(ds->dargs.geo,
 				ds->state->path.blk[level].blkno),
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index e52e12e9a1b4b..cb2530a93a001 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -217,6 +217,10 @@ xchk_setup_inode(
 out_cancel:
 	xchk_trans_cancel(sc);
 out_error:
+	xchk_whine(mp, "type %s agno 0x%x agbno 0x%x error %d ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type), agno,
+			XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino), error,
+			__return_address);
 	trace_xchk_op_error(sc, agno, XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino),
 			error, __return_address);
 	return error;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 94a733975879a..1a098a8913925 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -632,6 +632,45 @@ xchk_scrub_create_subord(
 	return sub;
 }
 
+static inline void
+repair_outcomes(struct xfs_scrub *sc, int error)
+{
+	struct xfs_scrub_metadata *sm = sc->sm;
+	const char *wut = NULL;
+
+	if (!xfs_globals.scrub_whine)
+		return;
+
+	if (sc->flags & XREP_ALREADY_FIXED) {
+		wut = "*** REPAIR SUCCESS";
+		error = 0;
+	} else if (error == -EBUSY) {
+		wut = "??? FILESYSTEM BUSY";
+	} else if (error == -EAGAIN) {
+		wut = "??? REPAIR DEFERRED";
+	} else if (error == -ECANCELED) {
+		wut = "??? REPAIR CANCELLED";
+	} else if (error == -EINTR) {
+		wut = "??? REPAIR INTERRUPTED";
+	} else if (error != -EOPNOTSUPP && error != -ENOENT) {
+		wut = "!!! REPAIR FAILED";
+		xfs_info(sc->mp,
+"%s ino 0x%llx type %s agno 0x%x inum 0x%llx gen 0x%x flags 0x%x error %d",
+				wut, XFS_I(file_inode(sc->file))->i_ino,
+				xchk_type_string(sm->sm_type), sm->sm_agno,
+				sm->sm_ino, sm->sm_gen, sm->sm_flags, error);
+		return;
+	} else {
+		return;
+	}
+
+	xfs_info_ratelimited(sc->mp,
+"%s ino 0x%llx type %s agno 0x%x inum 0x%llx gen 0x%x flags 0x%x error %d",
+			wut, XFS_I(file_inode(sc->file))->i_ino,
+			xchk_type_string(sm->sm_type), sm->sm_agno, sm->sm_ino,
+			sm->sm_gen, sm->sm_flags, error);
+}
+
 /* Dispatch metadata scrubbing. */
 int
 xfs_scrub_metadata(
@@ -729,6 +768,7 @@ xfs_scrub_metadata(
 		 * already tried to fix it, then attempt a repair.
 		 */
 		error = xrep_attempt(sc, &run);
+		repair_outcomes(sc, error);
 		if (error == -EAGAIN) {
 			/*
 			 * Either the repair function succeeded or it couldn't
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 4d0a6dceaa6c6..24a75e9e1a821 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -69,3 +69,25 @@ xfbtree_ino(
  */
 #define CREATE_TRACE_POINTS
 #include "scrub/trace.h"
+
+/* xchk_whine stuff */
+struct xchk_tstr {
+	unsigned int	type;
+	const char	*tag;
+};
+
+static const struct xchk_tstr xchk_tstr_tags[] = { XFS_SCRUB_TYPE_STRINGS };
+
+const char *
+xchk_type_string(
+	unsigned int	type)
+{
+	unsigned int	i;
+
+	for (i = 0; i < ARRAY_SIZE(xchk_tstr_tags); i++) {
+		if (xchk_tstr_tags[i].type == type)
+			return xchk_tstr_tags[i].tag;
+	}
+
+	return "???";
+}
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 2c6f7e3b7578d..cfd882edb2937 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -127,6 +127,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTREFCBT);
 	{ XFS_SCRUB_TYPE_RTRMAPBT,	"rtrmapbt" }, \
 	{ XFS_SCRUB_TYPE_RTREFCBT,	"rtrefcountbt" }
 
+const char *xchk_type_string(unsigned int type);
+
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \
 	{ XFS_SCRUB_OFLAG_CORRUPT,		"corrupt" }, \
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index f18fec0adf666..f5fe896b9a8ec 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -44,6 +44,11 @@ struct xfs_globals xfs_globals = {
 	.pwork_threads		=	-1,	/* automatic thread detection */
 	.larp			=	false,	/* log attribute replay */
 #endif
+#ifdef CONFIG_XFS_ONLINE_SCRUB_WHINE
+	.scrub_whine		=	true,
+#else
+	.scrub_whine		=	false,
+#endif
 
 	/*
 	 * Leave this many record slots empty when bulk loading btrees.  By
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 276696a07040c..b0939ac370fba 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -91,6 +91,7 @@ struct xfs_globals {
 	int	mount_delay;		/* mount setup delay (secs) */
 	bool	bug_on_assert;		/* BUG() the kernel on assert failure */
 	bool	always_cow;		/* use COW fork for all overwrites */
+	bool	scrub_whine;		/* noisier output from scrub */
 };
 extern struct xfs_globals	xfs_globals;
 
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 17485666b6723..b9ba47dcee8c1 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -262,6 +262,37 @@ larp_show(
 XFS_SYSFS_ATTR_RW(larp);
 #endif /* DEBUG */
 
+/* Logging of the outcomes of everything that scrub does */
+STATIC ssize_t
+scrub_whine_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	int		ret;
+	int		val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val < -1 || val > num_possible_cpus())
+		return -EINVAL;
+
+	xfs_globals.scrub_whine = val;
+
+	return count;
+}
+
+STATIC ssize_t
+scrub_whine_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	return sysfs_emit(buf, "%d\n", xfs_globals.scrub_whine);
+}
+XFS_SYSFS_ATTR_RW(scrub_whine);
+
 STATIC ssize_t
 bload_leaf_slack_store(
 	struct kobject	*kobject,
@@ -323,6 +354,7 @@ static struct attribute *xfs_dbg_attrs[] = {
 	ATTR_LIST(pwork_threads),
 	ATTR_LIST(larp),
 #endif
+	ATTR_LIST(scrub_whine),
 	ATTR_LIST(bload_leaf_slack),
 	ATTR_LIST(bload_node_slack),
 	NULL,


