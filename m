Return-Path: <linux-xfs+bounces-1241-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AF4A820D4F
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:07:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 757921F21E9D
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 20:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13631BA34;
	Sun, 31 Dec 2023 20:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDYvjBUL"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D269ABA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907B3C433C8;
	Sun, 31 Dec 2023 20:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053270;
	bh=qPPKkFC4UZHKZdweSupFVKcX84QlYY6DFMvFWQvimhI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WDYvjBULRp9x3izQEn3v8zB5u41+8lE4XOyuI1D/z6Gv1isIDyi90bsBqKbhD6Kjj
	 i63BLwhWVU4TV+u/MpdfZLCFgzHgR4LviTEM+d/7WdXHNQdkBkXSBp3eB5SVZAkmmG
	 mBHihXemoqCkaYOCMhbK36mpqLunFFz/XGsgkS8ip5w3B0zul211oCzLR1/Hvl4qLI
	 dRswSdtyDcZE8YZ4Vxcss7IsN7wHuqqt52YSExWOyW5F23jYHJX+rCP9PqbGx00Dt4
	 BsS9m29/hXHhM1z2ef7eKJo2FC+VzsvW9ldA74TEb4/VOj6J+wnBkFHsaEYYHH31bV
	 88dnl0FJg9CUA==
Date: Sun, 31 Dec 2023 12:07:50 -0800
Subject: [PATCH 2/5] xfs: implement live quotacheck inode scan
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404827425.1748002.12122438465318717193.stgit@frogsfrogsfrogs>
In-Reply-To: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
References: <170404827380.1748002.1474710373694082536.stgit@frogsfrogsfrogs>
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

Create a new trio of scrub functions to check quota counters.  While the
dquots themselves are filesystem metadata and should be checked early,
the dquot counter values are computed from other metadata and are
therefore summary counters.  We don't plug these into the scrub dispatch
just yet, because we still need to be able to watch quota updates while
doing our scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile           |    1 
 fs/xfs/libxfs/xfs_fs.h    |    3 
 fs/xfs/scrub/common.c     |   43 ++++
 fs/xfs/scrub/common.h     |   11 +
 fs/xfs/scrub/fscounters.c |    2 
 fs/xfs/scrub/health.c     |    1 
 fs/xfs/scrub/quotacheck.c |  512 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/quotacheck.h |   67 ++++++
 fs/xfs/scrub/scrub.c      |    6 +
 fs/xfs/scrub/scrub.h      |    6 +
 fs/xfs/scrub/stats.c      |    1 
 fs/xfs/scrub/trace.h      |   28 ++
 fs/xfs/scrub/xfarray.h    |   19 ++
 fs/xfs/xfs_inode.c        |   21 ++
 fs/xfs/xfs_inode.h        |    2 
 15 files changed, 718 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/scrub/quotacheck.c
 create mode 100644 fs/xfs/scrub/quotacheck.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7a5c637e449e5..12266812fa107 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -181,6 +181,7 @@ xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix scrub/, \
 				   dqiterate.o \
 				   quota.o \
+				   quotacheck.o \
 				   )
 
 # online repair
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 711e0fc7efab6..07acbed9235c5 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -710,9 +710,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_GQUOTA	22	/* group quotas */
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
+#define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	25
+#define XFS_SCRUB_TYPE_NR	26
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 81f2b96bb5a74..fc23bd9d38195 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -29,6 +29,7 @@
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
+#include "xfs_error.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -82,6 +83,15 @@ __xchk_process_error(
 				sc->ip ? sc->ip : XFS_I(file_inode(sc->file)),
 				sc->sm, *error);
 		break;
+	case -ECANCELED:
+		/*
+		 * ECANCELED here means that the caller set one of the scrub
+		 * outcome flags (corrupt, xfail, xcorrupt) and wants to exit
+		 * quickly.  Set error to zero and do not continue.
+		 */
+		trace_xchk_op_error(sc, agno, bno, *error, ret_ip);
+		*error = 0;
+		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
 		/* Note the badness but don't abort. */
@@ -89,8 +99,7 @@ __xchk_process_error(
 		*error = 0;
 		fallthrough;
 	default:
-		trace_xchk_op_error(sc, agno, bno, *error,
-				ret_ip);
+		trace_xchk_op_error(sc, agno, bno, *error, ret_ip);
 		break;
 	}
 	return false;
@@ -136,6 +145,16 @@ __xchk_fblock_process_error(
 		/* Used to restart an op with deadlock avoidance. */
 		trace_xchk_deadlock_retry(sc->ip, sc->sm, *error);
 		break;
+	case -ECANCELED:
+		/*
+		 * ECANCELED here means that the caller set one of the scrub
+		 * outcome flags (corrupt, xfail, xcorrupt) and wants to exit
+		 * quickly.  Set error to zero and do not continue.
+		 */
+		trace_xchk_file_op_error(sc, whichfork, offset, *error,
+				ret_ip);
+		*error = 0;
+		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
 		/* Note the badness but don't abort. */
@@ -227,6 +246,19 @@ xchk_block_set_corrupt(
 	trace_xchk_block_error(sc, xfs_buf_daddr(bp), __return_address);
 }
 
+#ifdef CONFIG_XFS_QUOTA
+/* Record a corrupt quota counter. */
+void
+xchk_qcheck_set_corrupt(
+	struct xfs_scrub	*sc,
+	unsigned int		dqtype,
+	xfs_dqid_t		id)
+{
+	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	trace_xchk_qcheck_error(sc, dqtype, id, __return_address);
+}
+#endif /* CONFIG_XFS_QUOTA */
+
 /* Record a corruption while cross-referencing. */
 void
 xchk_block_xref_set_corrupt(
@@ -653,6 +685,13 @@ xchk_trans_cancel(
 	sc->tp = NULL;
 }
 
+int
+xchk_trans_alloc_empty(
+	struct xfs_scrub	*sc)
+{
+	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
+}
+
 /*
  * Grab an empty transaction so that we can re-grab locked buffers if
  * one of our btrees turns out to be cyclic.
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index da09580b454a0..79516d1f4983a 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -32,6 +32,7 @@ xchk_should_terminate(
 }
 
 int xchk_trans_alloc(struct xfs_scrub *sc, uint resblks);
+int xchk_trans_alloc_empty(struct xfs_scrub *sc);
 void xchk_trans_cancel(struct xfs_scrub *sc);
 
 bool xchk_process_error(struct xfs_scrub *sc, xfs_agnumber_t agno,
@@ -54,6 +55,10 @@ void xchk_block_set_corrupt(struct xfs_scrub *sc,
 void xchk_ino_set_corrupt(struct xfs_scrub *sc, xfs_ino_t ino);
 void xchk_fblock_set_corrupt(struct xfs_scrub *sc, int whichfork,
 		xfs_fileoff_t offset);
+#ifdef CONFIG_XFS_QUOTA
+void xchk_qcheck_set_corrupt(struct xfs_scrub *sc, unsigned int dqtype,
+		xfs_dqid_t id);
+#endif /* CONFIG_XFS_QUOTA */
 
 void xchk_block_xref_set_corrupt(struct xfs_scrub *sc,
 		struct xfs_buf *bp);
@@ -105,6 +110,7 @@ xchk_setup_rtsummary(struct xfs_scrub *sc)
 #ifdef CONFIG_XFS_QUOTA
 int xchk_ino_dqattach(struct xfs_scrub *sc);
 int xchk_setup_quota(struct xfs_scrub *sc);
+int xchk_setup_quotacheck(struct xfs_scrub *sc);
 #else
 static inline int
 xchk_ino_dqattach(struct xfs_scrub *sc)
@@ -116,6 +122,11 @@ xchk_setup_quota(struct xfs_scrub *sc)
 {
 	return -ENOENT;
 }
+static inline int
+xchk_setup_quotacheck(struct xfs_scrub *sc)
+{
+	return -ENOENT;
+}
 #endif
 int xchk_setup_fscounters(struct xfs_scrub *sc);
 
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 5799e9a94f1f6..893c5a6e3ddb0 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -242,7 +242,7 @@ xchk_setup_fscounters(
 			return error;
 	}
 
-	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
+	return xchk_trans_alloc_empty(sc);
 }
 
 /*
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index df716da11226b..55313a26ae9a7 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -107,6 +107,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_GQUOTA]		= { XHG_FS,  XFS_SICK_FS_GQUOTA },
 	[XFS_SCRUB_TYPE_PQUOTA]		= { XHG_FS,  XFS_SICK_FS_PQUOTA },
 	[XFS_SCRUB_TYPE_FSCOUNTERS]	= { XHG_FS,  XFS_SICK_FS_COUNTERS },
+	[XFS_SCRUB_TYPE_QUOTACHECK]	= { XHG_FS,  XFS_SICK_FS_QUOTACHECK },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
new file mode 100644
index 0000000000000..79a6ac25419d7
--- /dev/null
+++ b/fs/xfs/scrub/quotacheck.c
@@ -0,0 +1,512 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+#include "xfs_quota.h"
+#include "xfs_qm.h"
+#include "xfs_icache.h"
+#include "xfs_bmap_util.h"
+#include "xfs_ialloc.h"
+#include "xfs_ag.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/repair.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/iscan.h"
+#include "scrub/quota.h"
+#include "scrub/quotacheck.h"
+#include "scrub/trace.h"
+
+/*
+ * Live Quotacheck
+ * ===============
+ *
+ * Quota counters are "summary" metadata, in the sense that they are computed
+ * as the summation of the block usage counts for every file on the filesystem.
+ * Therefore, we compute the correct icount, bcount, and rtbcount values by
+ * creating a shadow quota counter structure and walking every inode.
+ */
+
+/* Set us up to scrub quota counters. */
+int
+xchk_setup_quotacheck(
+	struct xfs_scrub	*sc)
+{
+	/* Not ready for general consumption yet. */
+	return -EOPNOTSUPP;
+
+	if (!XFS_IS_QUOTA_ON(sc->mp))
+		return -ENOENT;
+
+	sc->buf = kzalloc(sizeof(struct xqcheck), XCHK_GFP_FLAGS);
+	if (!sc->buf)
+		return -ENOMEM;
+
+	return xchk_setup_fs(sc);
+}
+
+/*
+ * Part 1: Collecting dquot resource usage counts.  For each xfs_dquot attached
+ * to each inode, we create a shadow dquot, and compute the inode count and add
+ * the data/rt block usage from what we see.
+ *
+ * To avoid false corruption reports in part 2, any failure in this part must
+ * set the INCOMPLETE flag even when a negative errno is returned.  This care
+ * must be taken with certain errno values (i.e. EFSBADCRC, EFSCORRUPTED,
+ * ECANCELED) that are absorbed into a scrub state flag update by
+ * xchk_*_process_error.
+ */
+
+/* Update an incore dquot counter information from a live update. */
+static int
+xqcheck_update_incore_counts(
+	struct xqcheck		*xqc,
+	struct xfarray		*counts,
+	xfs_dqid_t		id,
+	int64_t			inodes,
+	int64_t			nblks,
+	int64_t			rtblks)
+{
+	struct xqcheck_dquot	xcdq;
+	int			error;
+
+	error = xfarray_load_sparse(counts, id, &xcdq);
+	if (error)
+		return error;
+
+	xcdq.flags |= XQCHECK_DQUOT_WRITTEN;
+	xcdq.icount += inodes;
+	xcdq.bcount += nblks;
+	xcdq.rtbcount += rtblks;
+
+	error = xfarray_store(counts, id, &xcdq);
+	if (error == -EFBIG) {
+		/*
+		 * EFBIG means we tried to store data at too high a byte offset
+		 * in the sparse array.  IOWs, we cannot complete the check and
+		 * must notify userspace that the check was incomplete.
+		 */
+		error = -ECANCELED;
+	}
+	return error;
+}
+
+/* Record this inode's quota usage in our shadow quota counter data. */
+STATIC int
+xqcheck_collect_inode(
+	struct xqcheck		*xqc,
+	struct xfs_inode	*ip)
+{
+	struct xfs_trans	*tp = xqc->sc->tp;
+	xfs_filblks_t		nblks, rtblks;
+	uint			ilock_flags = 0;
+	xfs_dqid_t		id;
+	bool			isreg = S_ISREG(VFS_I(ip)->i_mode);
+	int			error = 0;
+
+	if (xfs_is_quota_inode(&tp->t_mountp->m_sb, ip->i_ino)) {
+		/*
+		 * Quota files are never counted towards quota, so we do not
+		 * need to take the lock.
+		 */
+		xchk_iscan_mark_visited(&xqc->iscan, ip);
+		return 0;
+	}
+
+	/* Figure out the data / rt device block counts. */
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	if (isreg)
+		xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		ilock_flags = xfs_ilock_data_map_shared(ip);
+		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
+		if (error)
+			goto out_incomplete;
+	} else {
+		ilock_flags = XFS_ILOCK_SHARED;
+		xfs_ilock(ip, XFS_ILOCK_SHARED);
+	}
+	xfs_inode_count_blocks(tp, ip, &nblks, &rtblks);
+
+	/* Update the shadow dquot counters. */
+	mutex_lock(&xqc->lock);
+	if (xqc->ucounts) {
+		id = xfs_qm_id_for_quotatype(ip, XFS_DQTYPE_USER);
+		error = xqcheck_update_incore_counts(xqc, xqc->ucounts, id, 1,
+				nblks, rtblks);
+		if (error)
+			goto out_mutex;
+	}
+
+	if (xqc->gcounts) {
+		id = xfs_qm_id_for_quotatype(ip, XFS_DQTYPE_GROUP);
+		error = xqcheck_update_incore_counts(xqc, xqc->gcounts, id, 1,
+				nblks, rtblks);
+		if (error)
+			goto out_mutex;
+	}
+
+	if (xqc->pcounts) {
+		id = xfs_qm_id_for_quotatype(ip, XFS_DQTYPE_PROJ);
+		error = xqcheck_update_incore_counts(xqc, xqc->pcounts, id, 1,
+				nblks, rtblks);
+		if (error)
+			goto out_mutex;
+	}
+	mutex_unlock(&xqc->lock);
+
+	xchk_iscan_mark_visited(&xqc->iscan, ip);
+	goto out_ilock;
+
+out_mutex:
+	mutex_unlock(&xqc->lock);
+out_incomplete:
+	xchk_set_incomplete(xqc->sc);
+out_ilock:
+	xfs_iunlock(ip, ilock_flags);
+	if (isreg)
+		xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+	return error;
+}
+
+/* Walk all the allocated inodes and run a quota scan on them. */
+STATIC int
+xqcheck_collect_counts(
+	struct xqcheck		*xqc)
+{
+	struct xfs_scrub	*sc = xqc->sc;
+	struct xfs_inode	*ip;
+	int			error;
+
+	/*
+	 * Set up for a potentially lengthy filesystem scan by reducing our
+	 * transaction resource usage for the duration.  Specifically:
+	 *
+	 * Cancel the transaction to release the log grant space while we scan
+	 * the filesystem.
+	 *
+	 * Create a new empty transaction to eliminate the possibility of the
+	 * inode scan deadlocking on cyclical metadata.
+	 *
+	 * We pass the empty transaction to the file scanning function to avoid
+	 * repeatedly cycling empty transactions.  This can be done without
+	 * risk of deadlock between sb_internal and the IOLOCK (we take the
+	 * IOLOCK to quiesce the file before scanning) because empty
+	 * transactions do not take sb_internal.
+	 */
+	xchk_trans_cancel(sc);
+	error = xchk_trans_alloc_empty(sc);
+	if (error)
+		return error;
+
+	while ((error = xchk_iscan_iter(&xqc->iscan, &ip)) == 1) {
+		error = xqcheck_collect_inode(xqc, ip);
+		xchk_irele(sc, ip);
+		if (error)
+			break;
+
+		if (xchk_should_terminate(sc, &error))
+			break;
+	}
+	xchk_iscan_iter_finish(&xqc->iscan);
+	if (error) {
+		xchk_set_incomplete(sc);
+		/*
+		 * If we couldn't grab an inode that was busy with a state
+		 * change, change the error code so that we exit to userspace
+		 * as quickly as possible.
+		 */
+		if (error == -EBUSY)
+			return -ECANCELED;
+		return error;
+	}
+
+	/*
+	 * Switch out for a real transaction in preparation for building a new
+	 * tree.
+	 */
+	xchk_trans_cancel(sc);
+	return xchk_setup_fs(sc);
+}
+
+/*
+ * Part 2: Comparing dquot resource counters.  Walk each xfs_dquot, comparing
+ * the resource usage counters against our shadow dquots; and then walk each
+ * shadow dquot (that wasn't covered in the first part), comparing it against
+ * the xfs_dquot.
+ */
+
+/*
+ * Check the dquot data against what we observed.  Caller must hold the dquot
+ * lock.
+ */
+STATIC int
+xqcheck_compare_dquot(
+	struct xqcheck		*xqc,
+	xfs_dqtype_t		dqtype,
+	struct xfs_dquot	*dq)
+{
+	struct xqcheck_dquot	xcdq;
+	struct xfarray		*counts = xqcheck_counters_for(xqc, dqtype);
+	int			error;
+
+	mutex_lock(&xqc->lock);
+	error = xfarray_load_sparse(counts, dq->q_id, &xcdq);
+	if (error)
+		goto out_unlock;
+
+	if (xcdq.icount != dq->q_ino.count)
+		xchk_qcheck_set_corrupt(xqc->sc, dqtype, dq->q_id);
+
+	if (xcdq.bcount != dq->q_blk.count)
+		xchk_qcheck_set_corrupt(xqc->sc, dqtype, dq->q_id);
+
+	if (xcdq.rtbcount != dq->q_rtb.count)
+		xchk_qcheck_set_corrupt(xqc->sc, dqtype, dq->q_id);
+
+	xcdq.flags |= (XQCHECK_DQUOT_COMPARE_SCANNED | XQCHECK_DQUOT_WRITTEN);
+	error = xfarray_store(counts, dq->q_id, &xcdq);
+	if (error == -EFBIG) {
+		/*
+		 * EFBIG means we tried to store data at too high a byte offset
+		 * in the sparse array.  IOWs, we cannot complete the check and
+		 * must notify userspace that the check was incomplete.  This
+		 * should never happen, since we just read the record.
+		 */
+		xchk_set_incomplete(xqc->sc);
+		error = -ECANCELED;
+	}
+	mutex_unlock(&xqc->lock);
+	if (error)
+		return error;
+
+	if (xqc->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return -ECANCELED;
+
+	return 0;
+
+out_unlock:
+	mutex_unlock(&xqc->lock);
+	return error;
+}
+
+/*
+ * Walk all the observed dquots, and make sure there's a matching incore
+ * dquot and that its counts match ours.
+ */
+STATIC int
+xqcheck_walk_observations(
+	struct xqcheck		*xqc,
+	xfs_dqtype_t		dqtype)
+{
+	struct xqcheck_dquot	xcdq;
+	struct xfs_dquot	*dq;
+	struct xfarray		*counts = xqcheck_counters_for(xqc, dqtype);
+	xfarray_idx_t		cur = XFARRAY_CURSOR_INIT;
+	int			error;
+
+	mutex_lock(&xqc->lock);
+	while ((error = xfarray_iter(counts, &cur, &xcdq)) == 1) {
+		xfs_dqid_t	id = cur - 1;
+
+		if (xcdq.flags & XQCHECK_DQUOT_COMPARE_SCANNED)
+			continue;
+
+		mutex_unlock(&xqc->lock);
+
+		error = xfs_qm_dqget(xqc->sc->mp, id, dqtype, false, &dq);
+		if (error == -ENOENT) {
+			xchk_qcheck_set_corrupt(xqc->sc, dqtype, id);
+			return 0;
+		}
+		if (error)
+			return error;
+
+		error = xqcheck_compare_dquot(xqc, dqtype, dq);
+		xfs_qm_dqput(dq);
+		if (error)
+			return error;
+
+		if (xchk_should_terminate(xqc->sc, &error))
+			return error;
+
+		mutex_lock(&xqc->lock);
+	}
+	mutex_unlock(&xqc->lock);
+
+	return error;
+}
+
+/* Compare the quota counters we observed against the live dquots. */
+STATIC int
+xqcheck_compare_dqtype(
+	struct xqcheck		*xqc,
+	xfs_dqtype_t		dqtype)
+{
+	struct xchk_dqiter	cursor = { };
+	struct xfs_scrub	*sc = xqc->sc;
+	struct xfs_dquot	*dq;
+	int			error;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return 0;
+
+	/* If the quota CHKD flag is cleared, we need to repair this quota. */
+	if (!(xfs_quota_chkd_flag(dqtype) & sc->mp->m_qflags)) {
+		xchk_qcheck_set_corrupt(xqc->sc, dqtype, 0);
+		return 0;
+	}
+
+	/* Compare what we observed against the actual dquots. */
+	xchk_dqiter_init(&cursor, sc, dqtype);
+	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
+		error = xqcheck_compare_dquot(xqc, dqtype, dq);
+		xfs_qm_dqput(dq);
+		if (error)
+			break;
+	}
+	if (error)
+		return error;
+
+	/* Walk all the observed dquots and compare to the incore ones. */
+	return xqcheck_walk_observations(xqc, dqtype);
+}
+
+/* Tear down everything associated with a quotacheck. */
+static void
+xqcheck_teardown_scan(
+	void			*priv)
+{
+	struct xqcheck		*xqc = priv;
+
+	if (xqc->pcounts) {
+		xfarray_destroy(xqc->pcounts);
+		xqc->pcounts = NULL;
+	}
+
+	if (xqc->gcounts) {
+		xfarray_destroy(xqc->gcounts);
+		xqc->gcounts = NULL;
+	}
+
+	if (xqc->ucounts) {
+		xfarray_destroy(xqc->ucounts);
+		xqc->ucounts = NULL;
+	}
+
+	xchk_iscan_teardown(&xqc->iscan);
+	mutex_destroy(&xqc->lock);
+	xqc->sc = NULL;
+}
+
+/*
+ * Scan all inodes in the entire filesystem to generate quota counter data.
+ * If the scan is successful, the quota data will be left alive for a repair.
+ * If any error occurs, we'll tear everything down.
+ */
+STATIC int
+xqcheck_setup_scan(
+	struct xfs_scrub	*sc,
+	struct xqcheck		*xqc)
+{
+	char			*descr;
+	unsigned long long	max_dquots = XFS_DQ_ID_MAX + 1ULL;
+	int			error;
+
+	ASSERT(xqc->sc == NULL);
+	xqc->sc = sc;
+
+	mutex_init(&xqc->lock);
+
+	/* Retry iget every tenth of a second for up to 30 seconds. */
+	xchk_iscan_start(sc, 30000, 100, &xqc->iscan);
+
+	error = -ENOMEM;
+	if (xfs_this_quota_on(sc->mp, XFS_DQTYPE_USER)) {
+		descr = xchk_xfile_descr(sc, "user dquot records");
+		error = xfarray_create(descr, max_dquots,
+				sizeof(struct xqcheck_dquot), &xqc->ucounts);
+		kfree(descr);
+		if (error)
+			goto out_teardown;
+	}
+
+	if (xfs_this_quota_on(sc->mp, XFS_DQTYPE_GROUP)) {
+		descr = xchk_xfile_descr(sc, "group dquot records");
+		error = xfarray_create(descr, max_dquots,
+				sizeof(struct xqcheck_dquot), &xqc->gcounts);
+		kfree(descr);
+		if (error)
+			goto out_teardown;
+	}
+
+	if (xfs_this_quota_on(sc->mp, XFS_DQTYPE_PROJ)) {
+		descr = xchk_xfile_descr(sc, "project dquot records");
+		error = xfarray_create(descr, max_dquots,
+				sizeof(struct xqcheck_dquot), &xqc->pcounts);
+		kfree(descr);
+		if (error)
+			goto out_teardown;
+	}
+
+	/* Use deferred cleanup to pass the quota count data to repair. */
+	sc->buf_cleanup = xqcheck_teardown_scan;
+	return 0;
+
+out_teardown:
+	xqcheck_teardown_scan(xqc);
+	return error;
+}
+
+/* Scrub all counters for a given quota type. */
+int
+xchk_quotacheck(
+	struct xfs_scrub	*sc)
+{
+	struct xqcheck		*xqc = sc->buf;
+	int			error = 0;
+
+	/* Check quota counters on the live filesystem. */
+	error = xqcheck_setup_scan(sc, xqc);
+	if (error)
+		return error;
+
+	/* Walk all inodes, picking up quota information. */
+	error = xqcheck_collect_counts(xqc);
+	if (!xchk_xref_process_error(sc, 0, 0, &error))
+		return error;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
+		return 0;
+
+	/* Compare quota counters. */
+	if (xqc->ucounts) {
+		error = xqcheck_compare_dqtype(xqc, XFS_DQTYPE_USER);
+		if (!xchk_xref_process_error(sc, 0, 0, &error))
+			return error;
+	}
+	if (xqc->gcounts) {
+		error = xqcheck_compare_dqtype(xqc, XFS_DQTYPE_GROUP);
+		if (!xchk_xref_process_error(sc, 0, 0, &error))
+			return error;
+	}
+	if (xqc->pcounts) {
+		error = xqcheck_compare_dqtype(xqc, XFS_DQTYPE_PROJ);
+		if (!xchk_xref_process_error(sc, 0, 0, &error))
+			return error;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/quotacheck.h b/fs/xfs/scrub/quotacheck.h
new file mode 100644
index 0000000000000..99eae596dd410
--- /dev/null
+++ b/fs/xfs/scrub/quotacheck.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_QUOTACHECK_H__
+#define __XFS_SCRUB_QUOTACHECK_H__
+
+/* Quota counters for live quotacheck. */
+struct xqcheck_dquot {
+	/* block usage count */
+	int64_t			bcount;
+
+	/* inode usage count */
+	int64_t			icount;
+
+	/* realtime block usage count */
+	int64_t			rtbcount;
+
+	/* Record state */
+	unsigned int		flags;
+};
+
+/*
+ * This incore dquot record has been written at least once.  We never want to
+ * store an xqcheck_dquot that looks uninitialized.
+ */
+#define XQCHECK_DQUOT_WRITTEN		(1U << 0)
+
+/* Already checked this dquot. */
+#define XQCHECK_DQUOT_COMPARE_SCANNED	(1U << 1)
+
+/* Live quotacheck control structure. */
+struct xqcheck {
+	struct xfs_scrub	*sc;
+
+	/* Shadow dquot counter data. */
+	struct xfarray		*ucounts;
+	struct xfarray		*gcounts;
+	struct xfarray		*pcounts;
+
+	/* Lock protecting quotacheck count observations */
+	struct mutex		lock;
+
+	struct xchk_iscan	iscan;
+};
+
+/* Return the incore counter array for a given quota type. */
+static inline struct xfarray *
+xqcheck_counters_for(
+	struct xqcheck		*xqc,
+	xfs_dqtype_t		dqtype)
+{
+	switch (dqtype) {
+	case XFS_DQTYPE_USER:
+		return xqc->ucounts;
+	case XFS_DQTYPE_GROUP:
+		return xqc->gcounts;
+	case XFS_DQTYPE_PROJ:
+		return xqc->pcounts;
+	}
+
+	ASSERT(0);
+	return NULL;
+}
+
+#endif /* __XFS_SCRUB_QUOTACHECK_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index caf324c2b9910..d9fcf992d5899 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -360,6 +360,12 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.scrub	= xchk_fscounters,
 		.repair	= xrep_notsupported,
 	},
+	[XFS_SCRUB_TYPE_QUOTACHECK] = {	/* quota counters */
+		.type	= ST_FS,
+		.setup	= xchk_setup_quotacheck,
+		.scrub	= xchk_quotacheck,
+		.repair	= xrep_notsupported,
+	},
 };
 
 static int
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 7fc50654c4fe7..779f37b1cb1a6 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -167,12 +167,18 @@ xchk_rtsummary(struct xfs_scrub *sc)
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_quota(struct xfs_scrub *sc);
+int xchk_quotacheck(struct xfs_scrub *sc);
 #else
 static inline int
 xchk_quota(struct xfs_scrub *sc)
 {
 	return -ENOENT;
 }
+static inline int
+xchk_quotacheck(struct xfs_scrub *sc)
+{
+	return -ENOENT;
+}
 #endif
 int xchk_fscounters(struct xfs_scrub *sc);
 
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index cd91db4a55489..d716a432227b0 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -77,6 +77,7 @@ static const char *name_map[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_GQUOTA]		= "grpquota",
 	[XFS_SCRUB_TYPE_PQUOTA]		= "prjquota",
 	[XFS_SCRUB_TYPE_FSCOUNTERS]	= "fscounters",
+	[XFS_SCRUB_TYPE_QUOTACHECK]	= "quotacheck",
 };
 
 /* Format the scrub stats into a text buffer, similar to pcp style. */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 790982b769f72..499ba68d1fb2a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -15,6 +15,7 @@
 
 #include <linux/tracepoint.h>
 #include "xfs_bit.h"
+#include "xfs_quota_defs.h"
 
 struct xfs_scrub;
 struct xfile;
@@ -65,6 +66,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_UQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_GQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_QUOTACHECK);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -91,7 +93,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 	{ XFS_SCRUB_TYPE_UQUOTA,	"usrquota" }, \
 	{ XFS_SCRUB_TYPE_GQUOTA,	"grpquota" }, \
 	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }, \
-	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }
+	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }, \
+	{ XFS_SCRUB_TYPE_QUOTACHECK,	"quotacheck" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \
@@ -397,6 +400,29 @@ DEFINE_SCRUB_DQITER_EVENT(xchk_dquot_iter_revalidate_bmap);
 DEFINE_SCRUB_DQITER_EVENT(xchk_dquot_iter_advance_bmap);
 DEFINE_SCRUB_DQITER_EVENT(xchk_dquot_iter_advance_incore);
 DEFINE_SCRUB_DQITER_EVENT(xchk_dquot_iter);
+
+TRACE_EVENT(xchk_qcheck_error,
+	TP_PROTO(struct xfs_scrub *sc, xfs_dqtype_t dqtype, xfs_dqid_t id,
+		 void *ret_ip),
+	TP_ARGS(sc, dqtype, id, ret_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_dqtype_t, dqtype)
+		__field(xfs_dqid_t, id)
+		__field(void *, ret_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->dqtype = dqtype;
+		__entry->id = id;
+		__entry->ret_ip = ret_ip;
+	),
+	TP_printk("dev %d:%d dquot type %s id 0x%x ret_ip %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->dqtype, XFS_DQTYPE_STRINGS),
+		  __entry->id,
+		  __entry->ret_ip)
+);
 #endif /* CONFIG_XFS_QUOTA */
 
 TRACE_EVENT(xchk_incomplete,
diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index 62b9c506fdd1b..0f1dac3aa1916 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -45,6 +45,25 @@ int xfarray_store(struct xfarray *array, xfarray_idx_t idx, const void *ptr);
 int xfarray_store_anywhere(struct xfarray *array, const void *ptr);
 bool xfarray_element_is_null(struct xfarray *array, const void *ptr);
 
+/*
+ * Load an array element, but zero the buffer if there's no data because we
+ * haven't stored to that array element yet.
+ */
+static inline int
+xfarray_load_sparse(
+	struct xfarray	*array,
+	uint64_t	idx,
+	void		*rec)
+{
+	int		error = xfarray_load(array, idx, rec);
+
+	if (error == -ENODATA) {
+		memset(rec, 0, array->obj_size);
+		return 0;
+	}
+	return error;
+}
+
 /* Append an element to the array. */
 static inline int xfarray_append(struct xfarray *array, const void *ptr)
 {
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1ffc8dfa2a52c..078073168fdfd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3777,3 +3777,24 @@ xfs_ifork_zapped(
 		return false;
 	}
 }
+
+/* Compute the number of data and realtime blocks used by a file. */
+void
+xfs_inode_count_blocks(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_filblks_t		*dblocks,
+	xfs_filblks_t		*rblocks)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+
+	if (!XFS_IS_REALTIME_INODE(ip)) {
+		*dblocks = ip->i_nblocks;
+		*rblocks = 0;
+		return;
+	}
+
+	*rblocks = 0;
+	xfs_bmap_count_leaves(ifp, rblocks);
+	*dblocks = ip->i_nblocks - *rblocks;
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 97f63bacd4c2b..15a16e1404eea 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -623,5 +623,7 @@ int xfs_inode_reload_unlinked_bucket(struct xfs_trans *tp, struct xfs_inode *ip)
 int xfs_inode_reload_unlinked(struct xfs_inode *ip);
 
 bool xfs_ifork_zapped(const struct xfs_inode *ip, int whichfork);
+void xfs_inode_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_filblks_t *dblocks, xfs_filblks_t *rblocks);
 
 #endif	/* __XFS_INODE_H__ */


