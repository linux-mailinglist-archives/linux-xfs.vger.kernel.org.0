Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CD6711BC2
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 02:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjEZAzR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 20:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjEZAzQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:55:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC71012E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:55:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8138B64BF6
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC3EC433EF;
        Fri, 26 May 2023 00:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062513;
        bh=HthIkd81aWzL1WogDFCzu/zQ60cWHPaWxRdNQBMlsxs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ARIhegz+iZt4qJVRCa0a5o5vjPD/c3gNkPyWCysE1WIgV19QK40kNS9Kj5cJIE8qQ
         H8900qPOfpTJvZe70+KFo0Mq28gmPiC+Aqv06kbSoiw+rEkM7bmC8ObeI5F+jQQQMo
         CrRvcadnSYVBjZB974GPO22oyb8KkAEO7tDfwzwgmd7bMHHWzzF3JBiw45SPSmpAk9
         2D1tjFJkuocA2+OOjsH6IWYCRksoJ9MfKFmFVZzsg1Dpjwo6nLgsIMq0pmcd+F6T/k
         W6vqyT5zVck4dRWrQauHz/MtIqR/5OCNv3kqOKYnPloR67ApQPvmb0kD8z2v/rEdcO
         jVPnJXYA15Rqg==
Date:   Thu, 25 May 2023 17:55:13 -0700
Subject: [PATCH 1/4] xfs: repair the inode core and forks of a metadata inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506059115.3730797.7816930083690730445.stgit@frogsfrogsfrogs>
In-Reply-To: <168506059095.3730797.12158750493561425588.stgit@frogsfrogsfrogs>
References: <168506059095.3730797.12158750493561425588.stgit@frogsfrogsfrogs>
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

Add a helper function to repair the core and forks of a metadata inode,
so that we can get move onto the task of repairing higher level metadata
that lives in an inode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap_repair.c |   17 ++++-
 fs/xfs/scrub/repair.c      |  151 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h      |    2 +
 3 files changed, 166 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index aaecf76682c6..807c30e17dc8 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -74,6 +74,9 @@ struct xrep_bmap {
 
 	/* Which fork are we fixing? */
 	int			whichfork;
+
+	/* Do we allow unwritten extents? */
+	bool			allow_unwritten;
 };
 
 /* Remember this reverse-mapping as a series of bmap records. */
@@ -213,6 +216,10 @@ xrep_bmap_walk_rmap(
 	    !(rec->rm_flags & XFS_RMAP_ATTR_FORK))
 		return 0;
 
+	/* Reject unwritten extents if we don't allow those. */
+	if ((rec->rm_flags & XFS_RMAP_UNWRITTEN) && !rb->allow_unwritten)
+		return -EFSCORRUPTED;
+
 	fsbno = XFS_AGB_TO_FSB(mp, cur->bc_ag.pag->pag_agno,
 			rec->rm_startblock);
 
@@ -705,10 +712,11 @@ xrep_bmap_check_inputs(
 }
 
 /* Repair an inode fork. */
-STATIC int
+int
 xrep_bmap(
 	struct xfs_scrub	*sc,
-	int			whichfork)
+	int			whichfork,
+	bool			allow_unwritten)
 {
 	struct xrep_bmap	*rb;
 	unsigned int		max_bmbt_recs;
@@ -726,6 +734,7 @@ xrep_bmap(
 		return -ENOMEM;
 	rb->sc = sc;
 	rb->whichfork = whichfork;
+	rb->allow_unwritten = allow_unwritten;
 
 	/* Set up enough storage to handle the max records for this fork. */
 	large_extcount = xfs_has_large_extent_counts(sc->mp);
@@ -764,7 +773,7 @@ int
 xrep_bmap_data(
 	struct xfs_scrub	*sc)
 {
-	return xrep_bmap(sc, XFS_DATA_FORK);
+	return xrep_bmap(sc, XFS_DATA_FORK, true);
 }
 
 /* Repair an inode's attr fork. */
@@ -772,5 +781,5 @@ int
 xrep_bmap_attr(
 	struct xfs_scrub	*sc)
 {
-	return xrep_bmap(sc, XFS_ATTR_FORK);
+	return xrep_bmap(sc, XFS_ATTR_FORK, false);
 }
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index f77cec95c509..f0d57aceb46d 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -29,6 +29,7 @@
 #include "xfs_defer.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
+#include "xfs_reflink.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -950,3 +951,153 @@ xrep_will_attempt(
 
 	return false;
 }
+
+/* Try to fix some part of a metadata inode by calling another scrubber. */
+STATIC int
+xrep_metadata_inode_subtype(
+	struct xfs_scrub	*sc,
+	unsigned int		scrub_type)
+{
+	__u32			smtype = sc->sm->sm_type;
+	__u32			smflags = sc->sm->sm_flags;
+	int			error;
+
+	/*
+	 * Let's see if the inode needs repair.  We're going to open-code calls
+	 * to the scrub and repair functions so that we can hang on to the
+	 * resources that we already acquired instead of using the standard
+	 * setup/teardown routines.
+	 */
+	sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+	sc->sm->sm_type = scrub_type;
+
+	switch (scrub_type) {
+	case XFS_SCRUB_TYPE_INODE:
+		error = xchk_inode(sc);
+		break;
+	case XFS_SCRUB_TYPE_BMBTD:
+		error = xchk_bmap_data(sc);
+		break;
+	case XFS_SCRUB_TYPE_BMBTA:
+		error = xchk_bmap_attr(sc);
+		break;
+	default:
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+	}
+	if (error)
+		goto out;
+
+	if (!xrep_will_attempt(sc))
+		goto out;
+
+	/*
+	 * Repair some part of the inode.  This will potentially join the inode
+	 * to the transaction.
+	 */
+	switch (scrub_type) {
+	case XFS_SCRUB_TYPE_INODE:
+		error = xrep_inode(sc);
+		break;
+	case XFS_SCRUB_TYPE_BMBTD:
+		error = xrep_bmap(sc, XFS_DATA_FORK, false);
+		break;
+	case XFS_SCRUB_TYPE_BMBTA:
+		error = xrep_bmap(sc, XFS_ATTR_FORK, false);
+		break;
+	}
+	if (error)
+		goto out;
+
+	/*
+	 * Finish all deferred intent items and then roll the transaction so
+	 * that the inode will not be joined to the transaction when we exit
+	 * the function.
+	 */
+	error = xfs_defer_finish(&sc->tp);
+	if (error)
+		goto out;
+	error = xfs_trans_roll(&sc->tp);
+	if (error)
+		goto out;
+
+	/*
+	 * Clear the corruption flags and re-check the metadata that we just
+	 * repaired.
+	 */
+	sc->sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+
+	switch (scrub_type) {
+	case XFS_SCRUB_TYPE_INODE:
+		error = xchk_inode(sc);
+		break;
+	case XFS_SCRUB_TYPE_BMBTD:
+		error = xchk_bmap_data(sc);
+		break;
+	case XFS_SCRUB_TYPE_BMBTA:
+		error = xchk_bmap_attr(sc);
+		break;
+	}
+	if (error)
+		goto out;
+
+	/* If corruption persists, the repair has failed. */
+	if (xchk_needs_repair(sc->sm)) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+out:
+	sc->sm->sm_type = smtype;
+	sc->sm->sm_flags = smflags;
+	return error;
+}
+
+/*
+ * Repair the ondisk forks of a metadata inode.  The caller must ensure that
+ * sc->ip points to the metadata inode and the ILOCK is held on that inode.
+ * The inode must not be joined to the transaction before the call, and will
+ * not be afterwards.
+ */
+int
+xrep_metadata_inode_forks(
+	struct xfs_scrub	*sc)
+{
+	bool			dirty = false;
+	int			error;
+
+	/* Repair the inode record and the data fork. */
+	error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_INODE);
+	if (error)
+		return error;
+
+	error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTD);
+	if (error)
+		return error;
+
+	/* Make sure the attr fork looks ok before we delete it. */
+	error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTA);
+	if (error)
+		return error;
+
+	/* Clear the reflink flag since metadata never shares. */
+	if (xfs_is_reflink_inode(sc->ip)) {
+		dirty = true;
+		xfs_trans_ijoin(sc->tp, sc->ip, 0);
+		error = xfs_reflink_clear_inode_flag(sc->ip, &sc->tp);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * If we modified the inode, roll the transaction but don't rejoin the
+	 * inode to the new transaction because xrep_bmap_data can do that.
+	 */
+	if (dirty) {
+		error = xfs_trans_roll(&sc->tp);
+		if (error)
+			return error;
+		dirty = false;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 2c6733941356..6a1b6cefbfec 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -72,6 +72,8 @@ int xrep_ino_dqattach(struct xfs_scrub *sc);
 int xrep_ino_ensure_extent_count(struct xfs_scrub *sc, int whichfork,
 		xfs_extnum_t nextents);
 int xrep_reset_perag_resv(struct xfs_scrub *sc);
+int xrep_bmap(struct xfs_scrub *sc, int whichfork, bool allow_unwritten);
+int xrep_metadata_inode_forks(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);

