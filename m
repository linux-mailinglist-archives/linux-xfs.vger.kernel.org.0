Return-Path: <linux-xfs+bounces-3196-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1D0E841B55
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jan 2024 06:13:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F40E3B23630
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jan 2024 05:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 197AE37702;
	Tue, 30 Jan 2024 05:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i/Vo9cx/"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE94E381CC
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591588; cv=none; b=oC1lZkyA0UIWF2grpV0ca17LQ+BM8kneDxP40/ZGpfRAE2BchvsrPBbfIKQL5Js0/y/ncNBmk3xIlGRtlMEl37rqRx3Vg1TyFoDns/dvhcbiWrjERdAZ5IUmrniG3r367XYv/xzPWCc1P+oiYwjDU0VUZGuS2aJfReqQcsGaoz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591588; c=relaxed/simple;
	bh=h7aWO4KsjgqTuzOL1T/GQwklcPfyzF6Qgsw2UNQCB7M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fVtGvGFuIwdhKLzFfo+/xrdUmuPzzGtlFcdtteyLE3EnUuxmSrbgx7xorL35yVdcjqIi7xX8tgh1kKVvG+yB3iA/ZGhlbARH2kXJHTTHI2e5KriAQeBcTpks/3m+zeEt+KG7dYyZ1JbqB1eJJxfJEh9HSTGQsx1NxYq6zLCxvyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i/Vo9cx/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B588C43399;
	Tue, 30 Jan 2024 05:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591588;
	bh=h7aWO4KsjgqTuzOL1T/GQwklcPfyzF6Qgsw2UNQCB7M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i/Vo9cx/cppj9QP2dOdhi73ROjFLP70Dwf//IjRvzxhmY8lgMh7eENk3Ri3pIpkto
	 3yqKdwBsagQ5iiUd84RIoRMGbjYRqhihRwxtW87sIMc+iKbj42hClabQW0XmISmMNK
	 uzUYT7ApoXaHVHguYaBMLDjQsUosUZdIuaKC2ZbiF3Kpc57cmkn1L6GaGlkQen0P47
	 IsYgZqiU116phFlQtOmSVT+EugLJmDQ67bMemoo2WG/Ipmv18981ZDCHyuR/rfvUle
	 J97bagBJAIyVFTlcr0g8ycTGm+8TbOtFloxrNC0rlunQOcFtdP2Y83tNTzil/MX1/H
	 c0/KJziZO+FpQ==
Date: Mon, 29 Jan 2024 21:13:08 -0800
Subject: [PATCH 1/1] xfs: repair summary counters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659064680.3354357.8730868858719112172.stgit@frogsfrogsfrogs>
In-Reply-To: <170659064662.3354357.16936859621849391669.stgit@frogsfrogsfrogs>
References: <170659064662.3354357.16936859621849391669.stgit@frogsfrogsfrogs>
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

Use the same summary counter calculation infrastructure to generate new
values for the in-core summary counters.   The difference between the
scrubber and the repairer is that the repairer will freeze the fs during
setup, which means that the values should match exactly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile                  |    1 +
 fs/xfs/scrub/fscounters.c        |   27 +++++++-------
 fs/xfs/scrub/fscounters.h        |   20 +++++++++++
 fs/xfs/scrub/fscounters_repair.c |   72 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h            |    2 +
 fs/xfs/scrub/scrub.c             |    2 +
 fs/xfs/scrub/trace.c             |    1 +
 fs/xfs/scrub/trace.h             |   21 +++++++++--
 8 files changed, 128 insertions(+), 18 deletions(-)
 create mode 100644 fs/xfs/scrub/fscounters.h
 create mode 100644 fs/xfs/scrub/fscounters_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 1efc3b7727dc0..a6a455ac5a38b 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -192,6 +192,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   alloc_repair.o \
 				   bmap_repair.o \
 				   cow_repair.o \
+				   fscounters_repair.o \
 				   ialloc_repair.o \
 				   inode_repair.o \
 				   newbt.o \
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 893c5a6e3ddb0..d310737c88236 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -22,6 +22,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
+#include "scrub/fscounters.h"
 
 /*
  * FS Summary Counters
@@ -48,17 +49,6 @@
  * our tolerance for mismatch between expected and actual counter values.
  */
 
-struct xchk_fscounters {
-	struct xfs_scrub	*sc;
-	uint64_t		icount;
-	uint64_t		ifree;
-	uint64_t		fdblocks;
-	uint64_t		frextents;
-	unsigned long long	icount_min;
-	unsigned long long	icount_max;
-	bool			frozen;
-};
-
 /*
  * Since the expected value computation is lockless but only browses incore
  * values, the percpu counters should be fairly close to each other.  However,
@@ -235,8 +225,13 @@ xchk_setup_fscounters(
 	 * Pause all writer activity in the filesystem while we're scrubbing to
 	 * reduce the likelihood of background perturbations to the counters
 	 * throwing off our calculations.
+	 *
+	 * If we're repairing, we need to prevent any other thread from
+	 * changing the global fs summary counters while we're repairing them.
+	 * This requires the fs to be frozen, which will disable background
+	 * reclaim and purge all inactive inodes.
 	 */
-	if (sc->flags & XCHK_TRY_HARDER) {
+	if ((sc->flags & XCHK_TRY_HARDER) || xchk_could_repair(sc)) {
 		error = xchk_fscounters_freeze(sc);
 		if (error)
 			return error;
@@ -254,7 +249,9 @@ xchk_setup_fscounters(
  * set the INCOMPLETE flag even when a negative errno is returned.  This care
  * must be taken with certain errno values (i.e. EFSBADCRC, EFSCORRUPTED,
  * ECANCELED) that are absorbed into a scrub state flag update by
- * xchk_*_process_error.
+ * xchk_*_process_error.  Scrub and repair share the same incore data
+ * structures, so the INCOMPLETE flag is critical to prevent a repair based on
+ * insufficient information.
  */
 
 /* Count free space btree blocks manually for pre-lazysbcount filesystems. */
@@ -482,6 +479,10 @@ xchk_fscount_within_range(
 	if (curr_value == expected)
 		return true;
 
+	/* We require exact matches when repair is running. */
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
+		return false;
+
 	min_value = min(old_value, curr_value);
 	max_value = max(old_value, curr_value);
 
diff --git a/fs/xfs/scrub/fscounters.h b/fs/xfs/scrub/fscounters.h
new file mode 100644
index 0000000000000..461a13d25f4b3
--- /dev/null
+++ b/fs/xfs/scrub/fscounters.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_FSCOUNTERS_H__
+#define __XFS_SCRUB_FSCOUNTERS_H__
+
+struct xchk_fscounters {
+	struct xfs_scrub	*sc;
+	uint64_t		icount;
+	uint64_t		ifree;
+	uint64_t		fdblocks;
+	uint64_t		frextents;
+	unsigned long long	icount_min;
+	unsigned long long	icount_max;
+	bool			frozen;
+};
+
+#endif /* __XFS_SCRUB_FSCOUNTERS_H__ */
diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
new file mode 100644
index 0000000000000..94cdb852bee46
--- /dev/null
+++ b/fs/xfs/scrub/fscounters_repair.c
@@ -0,0 +1,72 @@
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
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_rmap.h"
+#include "xfs_health.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/fscounters.h"
+
+/*
+ * FS Summary Counters
+ * ===================
+ *
+ * We correct errors in the filesystem summary counters by setting them to the
+ * values computed during the obligatory scrub phase.  However, we must be
+ * careful not to allow any other thread to change the counters while we're
+ * computing and setting new values.  To achieve this, we freeze the
+ * filesystem for the whole operation if the REPAIR flag is set.  The checking
+ * function is stricter when we've frozen the fs.
+ */
+
+/*
+ * Reset the superblock counters.  Caller is responsible for freezing the
+ * filesystem during the calculation and reset phases.
+ */
+int
+xrep_fscounters(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xchk_fscounters	*fsc = sc->buf;
+
+	/*
+	 * Reinitialize the in-core counters from what we computed.  We froze
+	 * the filesystem, so there shouldn't be anyone else trying to modify
+	 * these counters.
+	 */
+	if (!fsc->frozen) {
+		ASSERT(fsc->frozen);
+		return -EFSCORRUPTED;
+	}
+
+	trace_xrep_reset_counters(mp, fsc);
+
+	percpu_counter_set(&mp->m_icount, fsc->icount);
+	percpu_counter_set(&mp->m_ifree, fsc->ifree);
+	percpu_counter_set(&mp->m_fdblocks, fsc->fdblocks);
+	percpu_counter_set(&mp->m_frextents, fsc->frextents);
+	mp->m_sb.sb_frextents = fsc->frextents;
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 8edac0150e960..2ff2bb79c540c 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -117,6 +117,7 @@ int xrep_bmap_data(struct xfs_scrub *sc);
 int xrep_bmap_attr(struct xfs_scrub *sc);
 int xrep_bmap_cow(struct xfs_scrub *sc);
 int xrep_nlinks(struct xfs_scrub *sc);
+int xrep_fscounters(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -198,6 +199,7 @@ xrep_setup_nothing(
 #define xrep_quota			xrep_notsupported
 #define xrep_quotacheck			xrep_notsupported
 #define xrep_nlinks			xrep_notsupported
+#define xrep_fscounters			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 0f23b7f36d4a5..aeac9cae4ad4c 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -364,7 +364,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_FS,
 		.setup	= xchk_setup_fscounters,
 		.scrub	= xchk_fscounters,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_fscounters,
 	},
 	[XFS_SCRUB_TYPE_QUOTACHECK] = {	/* quota counters */
 		.type	= ST_FS,
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 2d5a330afe10c..b8f3795f7d9b4 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -24,6 +24,7 @@
 #include "scrub/quota.h"
 #include "scrub/iscan.h"
 #include "scrub/nlinks.h"
+#include "scrub/fscounters.h"
 
 /* Figure out which block the btree cursor was pointing to. */
 static inline xfs_fsblock_t
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index b4e65f148e7b6..1e448d0c5aeef 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -24,6 +24,7 @@ struct xfarray_sortinfo;
 struct xchk_dqiter;
 struct xchk_iscan;
 struct xchk_nlink;
+struct xchk_fscounters;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -1804,16 +1805,28 @@ TRACE_EVENT(xrep_calc_ag_resblks_btsize,
 		  __entry->refcbt_sz)
 )
 TRACE_EVENT(xrep_reset_counters,
-	TP_PROTO(struct xfs_mount *mp),
-	TP_ARGS(mp),
+	TP_PROTO(struct xfs_mount *mp, struct xchk_fscounters *fsc),
+	TP_ARGS(mp, fsc),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(uint64_t, icount)
+		__field(uint64_t, ifree)
+		__field(uint64_t, fdblocks)
+		__field(uint64_t, frextents)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
+		__entry->icount = fsc->icount;
+		__entry->ifree = fsc->ifree;
+		__entry->fdblocks = fsc->fdblocks;
+		__entry->frextents = fsc->frextents;
 	),
-	TP_printk("dev %d:%d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev))
+	TP_printk("dev %d:%d icount %llu ifree %llu fdblocks %llu frextents %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->icount,
+		  __entry->ifree,
+		  __entry->fdblocks,
+		  __entry->frextents)
 )
 
 DECLARE_EVENT_CLASS(xrep_newbt_extent_class,


