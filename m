Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40FA711C9E
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 03:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjEZBaK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 21:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjEZBaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:30:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A44A125
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0177661553
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E010C433EF;
        Fri, 26 May 2023 01:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064606;
        bh=YyPohlVK7AbyYswR1+RBOfBfyyjZbohPfmhvspbzE8Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=JM61wnHCCUO4IQfQjFOfL51Rx7ew/PsLUWDlmYaQKJiSLFfvYGE/eF89sGDYXPh/J
         QAlma6ixIGmB+oNizHdXbjX8p/xvTIlIOn0bhADiimyA2R44C/FTg+v7u5Vne4B8Y/
         U9SBUpiEyGXxpn6pm3v9vXTnkAyBZUIg8xKU0p+wmh57O75G93gzwg9mz1dyMacpZT
         XWn6k+8aOQ2CAobE8u6aCXBekWKutSax5TjY8BQ5+YeY/Q35KietBbk/o0ULQni35h
         m4oCanxDIkwbM3gzOTilerEA9qq4mmLuMayXikXsVPZ4ygn67z2Kto55AJGslJNf5G
         OujJ8alCU2hGA==
Date:   Thu, 25 May 2023 18:30:05 -0700
Subject: [PATCH 2/3] xfs: teach the tempfile to support atomic extent swapping
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506066040.3735250.14274216761974376812.stgit@frogsfrogsfrogs>
In-Reply-To: <168506066008.3735250.5566316565558388079.stgit@frogsfrogsfrogs>
References: <168506066008.3735250.5566316565558388079.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create some new routines to exchange the contents of a temporary file
created to stage a repair with another ondisk file.  This will be used
by the realtime summary repair function to commit atomically the new
rtsummary data, which will be staged in the tempfile.

The rest of XFS coordinates access to the realtime metadata inodes
solely through the ILOCK.  For repair to hold its exclusive access to
the realtime summary file, it has to allocate a single large transaction
and roll it repeatedly throughout the repair while holding the ILOCK.
In turn, this means that for now there's only a partial swapext
implementation for the temporary file, because we can only work within
an existing transaction.  Hence the only tempswap functions needed here
are to estimate the resource requirements of swapext between, reserve
more space/quota to an existing transaction, and kick off the actual
swap.  The rest will be added in a later patch in preparation for
repairing xattrs and directories.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/scrub.c    |   11 ++-
 fs/xfs/scrub/scrub.h    |    7 ++
 fs/xfs/scrub/tempfile.c |  197 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempswap.h |   21 +++++
 fs/xfs/scrub/trace.h    |    1 
 5 files changed, 234 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/tempswap.h


diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 7d9cc19a3262..0bfa9a076582 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -150,14 +150,15 @@ xchk_probe(
 
 /* Scrub setup and teardown */
 
+#define FSGATES_MASK	(XCHK_FSGATES_ALL | XREP_FSGATES_ALL)
 static inline void
 xchk_fsgates_disable(
 	struct xfs_scrub	*sc)
 {
-	if (!(sc->flags & XCHK_FSGATES_ALL))
+	if (!(sc->flags & FSGATES_MASK))
 		return;
 
-	trace_xchk_fsgates_disable(sc, sc->flags & XCHK_FSGATES_ALL);
+	trace_xchk_fsgates_disable(sc, sc->flags & FSGATES_MASK);
 
 	if (sc->flags & XCHK_FSGATES_DRAIN)
 		xfs_drain_wait_disable();
@@ -171,8 +172,12 @@ xchk_fsgates_disable(
 	if (sc->flags & XCHK_FSGATES_RMAP)
 		xfs_rmap_hook_disable();
 
-	sc->flags &= ~XCHK_FSGATES_ALL;
+	if (sc->flags & XREP_FSGATES_ATOMIC_XCHG)
+		xfs_xchg_range_rele_log_assist(sc->mp);
+
+	sc->flags &= ~FSGATES_MASK;
 }
+#undef FSGATES_MASK
 
 /* Free all the resources and finish the transactions. */
 STATIC int
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index f2735f0c6abd..e3a53c3a13a3 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -131,6 +131,7 @@ struct xfs_scrub {
 #define XCHK_FSGATES_QUOTA	(1 << 4)  /* quota live update enabled */
 #define XCHK_FSGATES_DIRENTS	(1 << 5)  /* directory live update enabled */
 #define XCHK_FSGATES_RMAP	(1 << 6)  /* rmapbt live update enabled */
+#define XREP_FSGATES_ATOMIC_XCHG (1 << 29) /* uses atomic file content exchange */
 #define XREP_RESET_PERAG_RESV	(1 << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
@@ -145,6 +146,12 @@ struct xfs_scrub {
 				 XCHK_FSGATES_DIRENTS | \
 				 XCHK_FSGATES_RMAP)
 
+/*
+ * The sole XREP_FSGATES* flag reflects a log intent item that is protected
+ * by a log-incompat feature flag.  No code patching in use here.
+ */
+#define XREP_FSGATES_ALL	(XREP_FSGATES_ATOMIC_XCHG)
+
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
 int xchk_superblock(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index ef8e3f175786..dbc8a1ef37a4 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -19,12 +19,14 @@
 #include "xfs_trans_space.h"
 #include "xfs_dir2.h"
 #include "xfs_xchgrange.h"
+#include "xfs_swapext.h"
 #include "xfs_defer.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
 #include "scrub/trace.h"
 #include "scrub/tempfile.h"
+#include "scrub/tempswap.h"
 #include "scrub/xfile.h"
 
 /*
@@ -444,3 +446,198 @@ xrep_tempfile_roll_trans(
 	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
 	return 0;
 }
+
+/* Enable atomic extent swapping. */
+int
+xrep_tempswap_grab_log_assist(
+	struct xfs_scrub	*sc)
+{
+	bool			need_rele = false;
+	int			error;
+
+	if (sc->flags & XREP_FSGATES_ATOMIC_XCHG)
+		return 0;
+
+	error = xfs_xchg_range_grab_log_assist(sc->mp, true, &need_rele);
+	if (error)
+		return error;
+	if (!need_rele) {
+		ASSERT(need_rele);
+		return -EOPNOTSUPP;
+	}
+
+	trace_xchk_fsgates_enable(sc, XREP_FSGATES_ATOMIC_XCHG);
+
+	sc->flags |= XREP_FSGATES_ATOMIC_XCHG;
+	return 0;
+}
+
+/*
+ * Fill out the swapext request in preparation for swapping the contents of a
+ * metadata file that we've rebuilt in the temp file.
+ */
+STATIC int
+xrep_tempswap_prep_request(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	struct xrep_tempswap	*tx)
+{
+	struct xfs_swapext_req	*req = &tx->req;
+
+	memset(tx, 0, sizeof(struct xrep_tempswap));
+
+	/* COW forks don't exist on disk. */
+	if (whichfork == XFS_COW_FORK) {
+		ASSERT(0);
+		return -EINVAL;
+	}
+
+	/* Both files should have the relevant forks. */
+	if (!xfs_ifork_ptr(sc->ip, whichfork) ||
+	    !xfs_ifork_ptr(sc->tempip, whichfork)) {
+		ASSERT(xfs_ifork_ptr(sc->ip, whichfork) != NULL);
+		ASSERT(xfs_ifork_ptr(sc->tempip, whichfork) != NULL);
+		return -EINVAL;
+	}
+
+	/* Swap all mappings in both forks. */
+	req->ip1 = sc->tempip;
+	req->ip2 = sc->ip;
+	req->startoff1 = 0;
+	req->startoff2 = 0;
+	req->whichfork = whichfork;
+	req->blockcount = XFS_MAX_FILEOFF;
+	req->req_flags = XFS_SWAP_REQ_LOGGED;
+
+	/* Always swap sizes when we're swapping data fork mappings. */
+	if (whichfork == XFS_DATA_FORK)
+		req->req_flags |= XFS_SWAP_REQ_SET_SIZES;
+
+	/*
+	 * If we're repairing symlinks, xattrs, or directories, always try to
+	 * convert ip2 to short format after swapping.
+	 */
+	if (whichfork == XFS_ATTR_FORK || S_ISDIR(VFS_I(sc->ip)->i_mode) ||
+	    S_ISLNK(VFS_I(sc->ip)->i_mode))
+		req->req_flags |= XFS_SWAP_REQ_CVT_INO2_SF;
+
+	return 0;
+}
+
+/*
+ * Obtain a quota reservation to make sure we don't hit EDQUOT.  We can skip
+ * this if quota enforcement is disabled or if both inodes' dquots are the
+ * same.  The qretry structure must be initialized to zeroes before the first
+ * call to this function.
+ */
+STATIC int
+xrep_tempswap_reserve_quota(
+	struct xfs_scrub		*sc,
+	const struct xrep_tempswap	*tx)
+{
+	struct xfs_trans		*tp = sc->tp;
+	const struct xfs_swapext_req	*req = &tx->req;
+	int64_t				ddelta, rdelta;
+	int				error;
+
+	/*
+	 * Don't bother with a quota reservation if we're not enforcing them
+	 * or the two inodes have the same dquots.
+	 */
+	if (!XFS_IS_QUOTA_ON(tp->t_mountp) || req->ip1 == req->ip2 ||
+	    (req->ip1->i_udquot == req->ip2->i_udquot &&
+	     req->ip1->i_gdquot == req->ip2->i_gdquot &&
+	     req->ip1->i_pdquot == req->ip2->i_pdquot))
+		return 0;
+
+	/*
+	 * Quota reservation for each file comes from two sources.  First, we
+	 * need to account for any net gain in mapped blocks during the swap.
+	 * Second, we need reservation for the gross gain in mapped blocks so
+	 * that we don't trip over any quota block reservation assertions.  We
+	 * must reserve the gross gain because the quota code subtracts from
+	 * bcount the number of blocks that we unmap; it does not add that
+	 * quantity back to the quota block reservation.
+	 */
+	ddelta = max_t(int64_t, 0, req->ip2_bcount - req->ip1_bcount);
+	rdelta = max_t(int64_t, 0, req->ip2_rtbcount - req->ip1_rtbcount);
+	error = xfs_trans_reserve_quota_nblks(tp, req->ip1,
+			ddelta + req->ip1_bcount, rdelta + req->ip1_rtbcount,
+			true);
+	if (error)
+		return error;
+
+	ddelta = max_t(int64_t, 0, req->ip1_bcount - req->ip2_bcount);
+	rdelta = max_t(int64_t, 0, req->ip1_rtbcount - req->ip2_rtbcount);
+	return xfs_trans_reserve_quota_nblks(tp, req->ip2,
+			ddelta + req->ip2_bcount, rdelta + req->ip2_rtbcount,
+			true);
+}
+
+/*
+ * Prepare an existing transaction for a swap.  The caller must hold
+ * the ILOCK of both the inode being repaired and the temporary file.
+ * Only use this when those ILOCKs cannot be dropped.
+ *
+ * Fill out the swapext request and resource estimation structures in
+ * preparation for swapping the contents of a metadata file that we've rebuilt
+ * in the temp file, then reserve space and quota to the transaction.
+ */
+int
+xrep_tempswap_trans_reserve(
+	struct xfs_scrub	*sc,
+	int			whichfork,
+	struct xrep_tempswap	*tx)
+{
+	int			error;
+
+	ASSERT(sc->tp != NULL);
+	ASSERT(xfs_isilocked(sc->ip, XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(sc->tempip, XFS_ILOCK_EXCL));
+
+	error = xrep_tempswap_prep_request(sc, whichfork, tx);
+	if (error)
+		return error;
+
+	error = xfs_swapext_estimate(&tx->req);
+	if (error)
+		return error;
+
+	error = xfs_trans_reserve_more(sc->tp, tx->req.resblks, 0);
+	if (error)
+		return error;
+
+	return xrep_tempswap_reserve_quota(sc, tx);
+}
+
+/* Swap forks between the file being repaired and the temporary file. */
+int
+xrep_tempswap_contents(
+	struct xfs_scrub	*sc,
+	struct xrep_tempswap	*tx)
+{
+	int			error;
+
+	ASSERT(sc->flags & XREP_FSGATES_ATOMIC_XCHG);
+
+	xfs_swapext(sc->tp, &tx->req);
+	error = xfs_defer_finish(&sc->tp);
+	if (error)
+		return error;
+
+	/*
+	 * If we swapped the ondisk sizes of two metadata files, we must swap
+	 * the incore sizes as well.  Since online fsck doesn't use swapext on
+	 * the data forks of user-accessible files, the two sizes are always
+	 * the same, so we don't need to log the inodes.
+	 */
+	if (tx->req.req_flags & XFS_SWAP_REQ_SET_SIZES) {
+		loff_t	temp;
+
+		temp = i_size_read(VFS_I(sc->ip));
+		i_size_write(VFS_I(sc->ip), i_size_read(VFS_I(sc->tempip)));
+		i_size_write(VFS_I(sc->tempip), temp);
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/tempswap.h b/fs/xfs/scrub/tempswap.h
new file mode 100644
index 000000000000..4d7d7e1575f8
--- /dev/null
+++ b/fs/xfs/scrub/tempswap.h
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_TEMPSWAP_H__
+#define __XFS_SCRUB_TEMPSWAP_H__
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+struct xrep_tempswap {
+	struct xfs_swapext_req	req;
+};
+
+int xrep_tempswap_grab_log_assist(struct xfs_scrub *sc);
+int xrep_tempswap_trans_reserve(struct xfs_scrub *sc, int whichfork,
+		struct xrep_tempswap *ti);
+
+int xrep_tempswap_contents(struct xfs_scrub *sc, struct xrep_tempswap *ti);
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
+
+#endif /* __XFS_SCRUB_TEMPFILE_H__ */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 5e3240910487..cc4027435992 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -124,6 +124,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 	{ XCHK_FSGATES_QUOTA,			"fsgates_quota" }, \
 	{ XCHK_FSGATES_DIRENTS,			"fsgates_dirents" }, \
 	{ XCHK_FSGATES_RMAP,			"fsgates_rmap" }, \
+	{ XREP_FSGATES_ATOMIC_XCHG,		"fsgates_atomic_swapext" }, \
 	{ XREP_RESET_PERAG_RESV,		"reset_perag_resv" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 

