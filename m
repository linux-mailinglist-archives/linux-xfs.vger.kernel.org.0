Return-Path: <linux-xfs+bounces-15087-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A53EF9BD889
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2024 23:25:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BC4B283BCD
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2024 22:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB83C216447;
	Tue,  5 Nov 2024 22:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vn2JW0Cf"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D042141D0
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845529; cv=none; b=KQaM7UnMgW0DXLDjLVQHEB3U5LQHuqbXFxZRYZct+6pkFZsL6s+jExdNcesdPj/YHTJltyf+eCfSMPiGYzjEr/jR9OIO9DUPhicJogpC7P5hRdRKiNQyy2mn76AHgrpEJPx//aFFKONLb6LqISFy/JCdgAUqsOkCsGZ/D2Qi08I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845529; c=relaxed/simple;
	bh=zED6BgYCeoo7Odc6oY4nSW0TUk79h4+6KZG+A0M5pvk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W/9PR9XfTND45fHbq/x+cG+RA61YOBVQ8ooq8AWkPA1ipJpdz2Morq6t7x1IaCV2U7c2tl/f5Z/z9AB1srX6T3RiXbxnNzKDZXIwDhWgD3ByMkK7bwqFg/Z+gBMcUoknUsj29BPc5YJk0poaSVSeq75KWvz8rhaDD1stEdIXidM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vn2JW0Cf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79840C4CECF;
	Tue,  5 Nov 2024 22:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845529;
	bh=zED6BgYCeoo7Odc6oY4nSW0TUk79h4+6KZG+A0M5pvk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vn2JW0CfS6RbjecEn6vCY2sdNu2+cp+GUFQhuOMyFfcpSlVVu8KCh26Zh1C2OO/JG
	 P/Jly8Ceio7PA/HEGCVZz6Mrl0dTk2dbl00KN9xPkPKD70WJt/bC5rgIKoxSvdRbsg
	 hNzQ0LtMH+/0xdYYUaPYWIG3yKYL0WKg00igijKLCL4Td4BJ3COhRLNNjRIWa3Ta/g
	 ohXEpNQHjFfaufTJH1fQ/FGKO/D1FSxXQa3ASo4XwbwWHdGFB8+9b7ydg819YaeonO
	 O8dXDwLll8KBEVvlLjTRtotgg/n0ZjU1zCiDjyxifQmZzzzK6vyoIk8kbEeVvUq/bj
	 xUk+Zh2tod+RQ==
Date: Tue, 05 Nov 2024 14:25:29 -0800
Subject: [PATCH 06/21] xfs: add rtgroup-based realtime scrubbing context
 management
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084397042.1871025.7893069497464446080.stgit@frogsfrogsfrogs>
In-Reply-To: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
References: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a state tracking structure and helpers to initialize the tracking
structure so that we can check metadata records against the realtime
space management metadata.  Right now this is limited to grabbing the
incore rtgroup object, but we'll eventually add to the tracking
structure the ILOCK state and btree cursors.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h |   30 +++++++++++++++++++
 fs/xfs/scrub/repair.c |   24 +++++++++++++++
 fs/xfs/scrub/repair.h |    7 ++++
 fs/xfs/scrub/scrub.c  |   29 ++++++++++++++++++
 fs/xfs/scrub/scrub.h  |   13 ++++++++
 6 files changed, 181 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index c26a3314237a69..5cbd94b56582a4 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -34,6 +34,7 @@
 #include "xfs_quota.h"
 #include "xfs_exchmaps.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -121,6 +122,17 @@ xchk_process_error(
 			XFS_SCRUB_OFLAG_CORRUPT, __return_address);
 }
 
+bool
+xchk_process_rt_error(
+	struct xfs_scrub	*sc,
+	xfs_rgnumber_t		rgno,
+	xfs_rgblock_t		rgbno,
+	int			*error)
+{
+	return __xchk_process_error(sc, rgno, rgbno, error,
+			XFS_SCRUB_OFLAG_CORRUPT, __return_address);
+}
+
 bool
 xchk_xref_process_error(
 	struct xfs_scrub	*sc,
@@ -684,6 +696,72 @@ xchk_ag_init(
 	return 0;
 }
 
+#ifdef CONFIG_XFS_RT
+/*
+ * For scrubbing a realtime group, grab all the in-core resources we'll need to
+ * check the metadata, which means taking the ILOCK of the realtime group's
+ * metadata inodes.  Callers must not join these inodes to the transaction with
+ * non-zero lockflags or concurrency problems will result.  The @rtglock_flags
+ * argument takes XFS_RTGLOCK_* flags.
+ */
+int
+xchk_rtgroup_init(
+	struct xfs_scrub	*sc,
+	xfs_rgnumber_t		rgno,
+	struct xchk_rt		*sr)
+{
+	ASSERT(sr->rtg == NULL);
+	ASSERT(sr->rtlock_flags == 0);
+
+	sr->rtg = xfs_rtgroup_get(sc->mp, rgno);
+	if (!sr->rtg)
+		return -ENOENT;
+	return 0;
+}
+
+void
+xchk_rtgroup_lock(
+	struct xchk_rt		*sr,
+	unsigned int		rtglock_flags)
+{
+	xfs_rtgroup_lock(sr->rtg, rtglock_flags);
+	sr->rtlock_flags = rtglock_flags;
+}
+
+/*
+ * Unlock the realtime group.  This must be done /after/ committing (or
+ * cancelling) the scrub transaction.
+ */
+static void
+xchk_rtgroup_unlock(
+	struct xchk_rt		*sr)
+{
+	ASSERT(sr->rtg != NULL);
+
+	if (sr->rtlock_flags) {
+		xfs_rtgroup_unlock(sr->rtg, sr->rtlock_flags);
+		sr->rtlock_flags = 0;
+	}
+}
+
+/*
+ * Unlock the realtime group and release its resources.  This must be done
+ * /after/ committing (or cancelling) the scrub transaction.
+ */
+void
+xchk_rtgroup_free(
+	struct xfs_scrub	*sc,
+	struct xchk_rt		*sr)
+{
+	ASSERT(sr->rtg != NULL);
+
+	xchk_rtgroup_unlock(sr);
+
+	xfs_rtgroup_put(sr->rtg);
+	sr->rtg = NULL;
+}
+#endif /* CONFIG_XFS_RT */
+
 /* Per-scrubber setup functions */
 
 void
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index b2a81e85ded9cf..672ed48d4a9fc3 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -12,6 +12,8 @@ void xchk_trans_cancel(struct xfs_scrub *sc);
 
 bool xchk_process_error(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		xfs_agblock_t bno, int *error);
+bool xchk_process_rt_error(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
+		xfs_rgblock_t rgbno, int *error);
 bool xchk_fblock_process_error(struct xfs_scrub *sc, int whichfork,
 		xfs_fileoff_t offset, int *error);
 
@@ -118,6 +120,34 @@ xchk_ag_init_existing(
 	return error == -ENOENT ? -EFSCORRUPTED : error;
 }
 
+#ifdef CONFIG_XFS_RT
+
+/* All the locks we need to check an rtgroup. */
+#define XCHK_RTGLOCK_ALL	(XFS_RTGLOCK_BITMAP)
+
+int xchk_rtgroup_init(struct xfs_scrub *sc, xfs_rgnumber_t rgno,
+		struct xchk_rt *sr);
+
+static inline int
+xchk_rtgroup_init_existing(
+	struct xfs_scrub	*sc,
+	xfs_rgnumber_t		rgno,
+	struct xchk_rt		*sr)
+{
+	int			error = xchk_rtgroup_init(sc, rgno, sr);
+
+	return error == -ENOENT ? -EFSCORRUPTED : error;
+}
+
+void xchk_rtgroup_lock(struct xchk_rt *sr, unsigned int rtglock_flags);
+void xchk_rtgroup_free(struct xfs_scrub *sc, struct xchk_rt *sr);
+#else
+# define xchk_rtgroup_init(sc, rgno, sr)		(-EFSCORRUPTED)
+# define xchk_rtgroup_init_existing(sc, rgno, sr)	(-EFSCORRUPTED)
+# define xchk_rtgroup_lock(sc, lockflags)		do { } while (0)
+# define xchk_rtgroup_free(sc, sr)			do { } while (0)
+#endif /* CONFIG_XFS_RT */
+
 int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		struct xchk_ag *sa);
 void xchk_ag_btcur_free(struct xchk_ag *sa);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f80000d7755242..5fdd00029cd6c0 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -21,6 +21,7 @@
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_rtgroup.h"
 #include "xfs_extent_busy.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
@@ -952,6 +953,29 @@ xrep_ag_init(
 	return 0;
 }
 
+#ifdef CONFIG_XFS_RT
+/*
+ * Given a reference to a rtgroup structure, lock rtgroup btree inodes and
+ * create btree cursors.  Must only be called to repair a regular rt file.
+ */
+int
+xrep_rtgroup_init(
+	struct xfs_scrub	*sc,
+	struct xfs_rtgroup	*rtg,
+	struct xchk_rt		*sr,
+	unsigned int		rtglock_flags)
+{
+	ASSERT(sr->rtg == NULL);
+
+	xfs_rtgroup_lock(rtg, rtglock_flags);
+	sr->rtlock_flags = rtglock_flags;
+
+	/* Grab our own passive reference from the caller's ref. */
+	sr->rtg = xfs_rtgroup_hold(rtg);
+	return 0;
+}
+#endif /* CONFIG_XFS_RT */
+
 /* Reinitialize the per-AG block reservation for the AG we just fixed. */
 int
 xrep_reset_perag_resv(
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 90f9cb3b5ad8ba..4052185743910d 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -8,6 +8,7 @@
 
 #include "xfs_quota_defs.h"
 
+struct xfs_rtgroup;
 struct xchk_stats_run;
 
 static inline int xrep_notsupported(struct xfs_scrub *sc)
@@ -106,6 +107,12 @@ int xrep_setup_inode(struct xfs_scrub *sc, const struct xfs_imap *imap);
 void xrep_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xrep_ag_init(struct xfs_scrub *sc, struct xfs_perag *pag,
 		struct xchk_ag *sa);
+#ifdef CONFIG_XFS_RT
+int xrep_rtgroup_init(struct xfs_scrub *sc, struct xfs_rtgroup *rtg,
+		struct xchk_rt *sr, unsigned int rtglock_flags);
+#else
+# define xrep_rtgroup_init(sc, rtg, sr, lockflags)	(-ENOSYS)
+#endif /* CONFIG_XFS_RT */
 
 /* Metadata revalidators */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 1ac33bea6f0a72..03770b9f905c3d 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -225,6 +225,8 @@ xchk_teardown(
 			xfs_trans_cancel(sc->tp);
 		sc->tp = NULL;
 	}
+	if (sc->sr.rtg)
+		xchk_rtgroup_free(sc, &sc->sr);
 	if (sc->ip) {
 		if (sc->ilock_flags)
 			xchk_iunlock(sc, sc->ilock_flags);
@@ -498,6 +500,33 @@ xchk_validate_inputs(
 		break;
 	case ST_GENERIC:
 		break;
+	case ST_RTGROUP:
+		if (sm->sm_ino || sm->sm_gen)
+			goto out;
+		if (xfs_has_rtgroups(mp)) {
+			/*
+			 * On a rtgroups filesystem, there won't be an rtbitmap
+			 * or rtsummary file for group 0 unless there's
+			 * actually a realtime volume attached.  However, older
+			 * xfs_scrub always calls the rtbitmap/rtsummary
+			 * scrubbers with sm_agno==0 so transform the error
+			 * code to ENOENT.
+			 */
+			if (sm->sm_agno >= mp->m_sb.sb_rgcount) {
+				if (sm->sm_agno == 0)
+					error = -ENOENT;
+				goto out;
+			}
+		} else {
+			/*
+			 * Prior to rtgroups, the rtbitmap/rtsummary scrubbers
+			 * accepted sm_agno==0, so we still accept that for
+			 * scrubbing pre-rtgroups filesystems.
+			 */
+			if (sm->sm_agno != 0)
+				goto out;
+		}
+		break;
 	default:
 		goto out;
 	}
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index c688ff4fc7fc4c..f73c6d0d90a11a 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -74,6 +74,7 @@ enum xchk_type {
 	ST_FS,		/* per-FS metadata */
 	ST_INODE,	/* per-inode metadata */
 	ST_GENERIC,	/* determined by the scrubber */
+	ST_RTGROUP,	/* rtgroup metadata */
 };
 
 struct xchk_meta_ops {
@@ -118,6 +119,15 @@ struct xchk_ag {
 	struct xfs_btree_cur	*refc_cur;
 };
 
+/* Inode lock state for the RT volume. */
+struct xchk_rt {
+	/* incore rtgroup, if applicable */
+	struct xfs_rtgroup	*rtg;
+
+	/* XFS_RTGLOCK_* lock state if locked */
+	unsigned int		rtlock_flags;
+};
+
 struct xfs_scrub {
 	/* General scrub state. */
 	struct xfs_mount		*mp;
@@ -179,6 +189,9 @@ struct xfs_scrub {
 
 	/* State tracking for single-AG operations. */
 	struct xchk_ag			sa;
+
+	/* State tracking for realtime operations. */
+	struct xchk_rt			sr;
 };
 
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */


