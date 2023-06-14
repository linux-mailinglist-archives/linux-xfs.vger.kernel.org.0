Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D189E711CE1
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 03:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbjEZBlh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 21:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjEZBlf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:41:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14B0189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C4A864C02
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B75DC433D2;
        Fri, 26 May 2023 01:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065292;
        bh=s1aTR+uuRg9B1keRVjy8ZTD99KrGdahtWrS9xKkWIyY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=coMOYzB41vnY9BkAIg801gwwhng/Sa/oW/uR06N9ckQVMW52o62SeeuTwtqTDuuh0
         BM3Vm6wdndUOzcoBtP5+Zkg+zxoZvGcs4sD3Ub95CCPLSTN9+bEZi1r/kUk9ASoPBT
         GoTQ9PqrveTEawmO5tqtJg3MmaQ4l/nDjJx1OFnrPxEbxypv/ddXCgr8zhWk+HC7z2
         z1jolFkjbRFPx9Brt7KMJdpao0uGfOkY5Lj1UR2c9gTEEnRbqzipVieXaUo8kSZ4w6
         IozTarrS34Iknxlnh123Suw0bWi2lRoPAUxTpIkeU1ASFb1ZIqsxdF9JOMHkB3tESn
         0I4jsiSl40cOQ==
Date:   Thu, 25 May 2023 18:41:32 -0700
Subject: [PATCH 4/7] xfs_scrub: move repair functions to repair.c
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506071364.3742205.4869800041467957097.stgit@frogsfrogsfrogs>
In-Reply-To: <168506071314.3742205.8114181660121831202.stgit@frogsfrogsfrogs>
References: <168506071314.3742205.8114181660121831202.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move all the repair functions to repair.c.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c        |    2 
 scrub/repair.c        |  169 +++++++++++++++++++++++++++++++++++++++++
 scrub/scrub.c         |  204 +------------------------------------------------
 scrub/scrub.h         |    6 -
 scrub/scrub_private.h |   55 +++++++++++++
 5 files changed, 230 insertions(+), 206 deletions(-)
 create mode 100644 scrub/scrub_private.h


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 37290946ef1..3c1341a6da7 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -210,7 +210,7 @@ _("Kernel metadata scrubbing facility is not available."));
 	}
 
 	/* Do we need kernel-assisted metadata repair? */
-	if (ctx->mode != SCRUB_MODE_DRY_RUN && !xfs_can_repair(ctx)) {
+	if (ctx->mode != SCRUB_MODE_DRY_RUN && !can_repair(ctx)) {
 		str_error(ctx, ctx->mntpoint,
 _("Kernel metadata repair facility is not available.  Use -n to scrub."));
 		return ECANCELED;
diff --git a/scrub/repair.c b/scrub/repair.c
index cddb834af1d..b6f1f4be0fb 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -10,11 +10,180 @@
 #include <sys/statvfs.h>
 #include "list.h"
 #include "libfrog/paths.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/scrub.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "scrub.h"
 #include "progress.h"
 #include "repair.h"
+#include "descr.h"
+#include "scrub_private.h"
+
+/* General repair routines. */
+
+/* Repair some metadata. */
+static enum check_outcome
+xfs_repair_metadata(
+	struct scrub_ctx		*ctx,
+	struct xfs_fd			*xfdp,
+	struct action_item		*aitem,
+	unsigned int			repair_flags)
+{
+	struct xfs_scrub_metadata	meta = { 0 };
+	struct xfs_scrub_metadata	oldm;
+	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
+	int				error;
+
+	assert(aitem->type < XFS_SCRUB_TYPE_NR);
+	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
+	meta.sm_type = aitem->type;
+	meta.sm_flags = aitem->flags | XFS_SCRUB_IFLAG_REPAIR;
+	if (use_force_rebuild)
+		meta.sm_flags |= XFS_SCRUB_IFLAG_FORCE_REBUILD;
+	switch (xfrog_scrubbers[aitem->type].group) {
+	case XFROG_SCRUB_GROUP_AGHEADER:
+	case XFROG_SCRUB_GROUP_PERAG:
+		meta.sm_agno = aitem->agno;
+		break;
+	case XFROG_SCRUB_GROUP_INODE:
+		meta.sm_ino = aitem->ino;
+		meta.sm_gen = aitem->gen;
+		break;
+	default:
+		break;
+	}
+
+	if (!is_corrupt(&meta) && (repair_flags & XRM_REPAIR_ONLY))
+		return CHECK_RETRY;
+
+	memcpy(&oldm, &meta, sizeof(oldm));
+	descr_set(&dsc, &oldm);
+
+	if (needs_repair(&meta))
+		str_info(ctx, descr_render(&dsc), _("Attempting repair."));
+	else if (debug || verbose)
+		str_info(ctx, descr_render(&dsc),
+				_("Attempting optimization."));
+
+	error = -xfrog_scrub_metadata(xfdp, &meta);
+	switch (error) {
+	case 0:
+		/* No operational errors encountered. */
+		break;
+	case EDEADLOCK:
+	case EBUSY:
+		/* Filesystem is busy, try again later. */
+		if (debug || verbose)
+			str_info(ctx, descr_render(&dsc),
+_("Filesystem is busy, deferring repair."));
+		return CHECK_RETRY;
+	case ESHUTDOWN:
+		/* Filesystem is already shut down, abort. */
+		str_error(ctx, descr_render(&dsc),
+_("Filesystem is shut down, aborting."));
+		return CHECK_ABORT;
+	case ENOTTY:
+	case EOPNOTSUPP:
+		/*
+		 * If the kernel cannot perform the optimization that we
+		 * requested; or we forced a repair but the kernel doesn't know
+		 * how to perform the repair, don't requeue the request.  Mark
+		 * it done and move on.
+		 */
+		if (is_unoptimized(&oldm) ||
+		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
+			return CHECK_DONE;
+		/*
+		 * If we're in no-complain mode, requeue the check for
+		 * later.  It's possible that an error in another
+		 * component caused us to flag an error in this
+		 * component.  Even if the kernel didn't think it
+		 * could fix this, it's at least worth trying the scan
+		 * again to see if another repair fixed it.
+		 */
+		if (!(repair_flags & XRM_FINAL_WARNING))
+			return CHECK_RETRY;
+		fallthrough;
+	case EINVAL:
+		/* Kernel doesn't know how to repair this? */
+		str_corrupt(ctx, descr_render(&dsc),
+_("Don't know how to fix; offline repair required."));
+		return CHECK_DONE;
+	case EROFS:
+		/* Read-only filesystem, can't fix. */
+		if (verbose || debug || needs_repair(&oldm))
+			str_error(ctx, descr_render(&dsc),
+_("Read-only filesystem; cannot make changes."));
+		return CHECK_ABORT;
+	case ENOENT:
+		/* Metadata not present, just skip it. */
+		return CHECK_DONE;
+	case ENOMEM:
+	case ENOSPC:
+		/* Don't care if preen fails due to low resources. */
+		if (is_unoptimized(&oldm) && !needs_repair(&oldm))
+			return CHECK_DONE;
+		fallthrough;
+	default:
+		/*
+		 * Operational error.  If the caller doesn't want us
+		 * to complain about repair failures, tell the caller
+		 * to requeue the repair for later and don't say a
+		 * thing.  Otherwise, print error and bail out.
+		 */
+		if (!(repair_flags & XRM_FINAL_WARNING))
+			return CHECK_RETRY;
+		str_liberror(ctx, error, descr_render(&dsc));
+		return CHECK_DONE;
+	}
+
+	if (repair_flags & XRM_FINAL_WARNING)
+		scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
+	if (needs_repair(&meta)) {
+		/*
+		 * Still broken; if we've been told not to complain then we
+		 * just requeue this and try again later.  Otherwise we
+		 * log the error loudly and don't try again.
+		 */
+		if (!(repair_flags & XRM_FINAL_WARNING))
+			return CHECK_RETRY;
+		str_corrupt(ctx, descr_render(&dsc),
+_("Repair unsuccessful; offline repair required."));
+	} else if (xref_failed(&meta)) {
+		/*
+		 * This metadata object itself looks ok, but we still noticed
+		 * inconsistencies when comparing it with the other filesystem
+		 * metadata.  If we're in "final warning" mode, advise the
+		 * caller to run xfs_repair; otherwise, we'll keep trying to
+		 * reverify the cross-referencing as repairs progress.
+		 */
+		if (repair_flags & XRM_FINAL_WARNING) {
+			str_info(ctx, descr_render(&dsc),
+ _("Seems correct but cross-referencing failed; offline repair recommended."));
+		} else {
+			if (verbose)
+				str_info(ctx, descr_render(&dsc),
+ _("Seems correct but cross-referencing failed; will keep checking."));
+			return CHECK_RETRY;
+		}
+	} else {
+		/* Clean operation, no corruption detected. */
+		if (is_corrupt(&oldm))
+			record_repair(ctx, descr_render(&dsc),
+ _("Repairs successful."));
+		else if (xref_disagrees(&oldm))
+			record_repair(ctx, descr_render(&dsc),
+ _("Repairs successful after disrepancy in cross-referencing."));
+		else if (xref_failed(&oldm))
+			record_repair(ctx, descr_render(&dsc),
+ _("Repairs successful after cross-referencing failure."));
+		else
+			record_preen(ctx, descr_render(&dsc),
+ _("Optimization successful."));
+	}
+	return CHECK_DONE;
+}
 
 /*
  * Prioritize action items in order of how long we can wait.
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 4f30949ca0e..93a49ddebb6 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -20,11 +20,12 @@
 #include "scrub.h"
 #include "repair.h"
 #include "descr.h"
+#include "scrub_private.h"
 
 /* Online scrub and repair wrappers. */
 
 /* Format a scrub description. */
-static int
+int
 format_scrub_descr(
 	struct scrub_ctx		*ctx,
 	char				*buf,
@@ -52,46 +53,8 @@ format_scrub_descr(
 	return -1;
 }
 
-/* Predicates for scrub flag state. */
-
-static inline bool is_corrupt(struct xfs_scrub_metadata *sm)
-{
-	return sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT;
-}
-
-static inline bool is_unoptimized(struct xfs_scrub_metadata *sm)
-{
-	return sm->sm_flags & XFS_SCRUB_OFLAG_PREEN;
-}
-
-static inline bool xref_failed(struct xfs_scrub_metadata *sm)
-{
-	return sm->sm_flags & XFS_SCRUB_OFLAG_XFAIL;
-}
-
-static inline bool xref_disagrees(struct xfs_scrub_metadata *sm)
-{
-	return sm->sm_flags & XFS_SCRUB_OFLAG_XCORRUPT;
-}
-
-static inline bool is_incomplete(struct xfs_scrub_metadata *sm)
-{
-	return sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE;
-}
-
-static inline bool is_suspicious(struct xfs_scrub_metadata *sm)
-{
-	return sm->sm_flags & XFS_SCRUB_OFLAG_WARNING;
-}
-
-/* Should we fix it? */
-static inline bool needs_repair(struct xfs_scrub_metadata *sm)
-{
-	return is_corrupt(sm) || xref_disagrees(sm);
-}
-
 /* Warn about strange circumstances after scrub. */
-static inline void
+void
 scrub_warn_incomplete_scrub(
 	struct scrub_ctx		*ctx,
 	struct descr			*dsc,
@@ -647,7 +610,7 @@ can_scrub_parent(
 }
 
 bool
-xfs_can_repair(
+can_repair(
 	struct scrub_ctx	*ctx)
 {
 	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE, XFS_SCRUB_IFLAG_REPAIR);
@@ -660,162 +623,3 @@ can_force_rebuild(
 	return __scrub_test(ctx, XFS_SCRUB_TYPE_PROBE,
 			XFS_SCRUB_IFLAG_REPAIR | XFS_SCRUB_IFLAG_FORCE_REBUILD);
 }
-
-/* General repair routines. */
-
-/* Repair some metadata. */
-enum check_outcome
-xfs_repair_metadata(
-	struct scrub_ctx		*ctx,
-	struct xfs_fd			*xfdp,
-	struct action_item		*aitem,
-	unsigned int			repair_flags)
-{
-	struct xfs_scrub_metadata	meta = { 0 };
-	struct xfs_scrub_metadata	oldm;
-	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
-	int				error;
-
-	assert(aitem->type < XFS_SCRUB_TYPE_NR);
-	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
-	meta.sm_type = aitem->type;
-	meta.sm_flags = aitem->flags | XFS_SCRUB_IFLAG_REPAIR;
-	if (use_force_rebuild)
-		meta.sm_flags |= XFS_SCRUB_IFLAG_FORCE_REBUILD;
-	switch (xfrog_scrubbers[aitem->type].group) {
-	case XFROG_SCRUB_GROUP_AGHEADER:
-	case XFROG_SCRUB_GROUP_PERAG:
-		meta.sm_agno = aitem->agno;
-		break;
-	case XFROG_SCRUB_GROUP_INODE:
-		meta.sm_ino = aitem->ino;
-		meta.sm_gen = aitem->gen;
-		break;
-	default:
-		break;
-	}
-
-	if (!is_corrupt(&meta) && (repair_flags & XRM_REPAIR_ONLY))
-		return CHECK_RETRY;
-
-	memcpy(&oldm, &meta, sizeof(oldm));
-	descr_set(&dsc, &oldm);
-
-	if (needs_repair(&meta))
-		str_info(ctx, descr_render(&dsc), _("Attempting repair."));
-	else if (debug || verbose)
-		str_info(ctx, descr_render(&dsc),
-				_("Attempting optimization."));
-
-	error = -xfrog_scrub_metadata(xfdp, &meta);
-	switch (error) {
-	case 0:
-		/* No operational errors encountered. */
-		break;
-	case EDEADLOCK:
-	case EBUSY:
-		/* Filesystem is busy, try again later. */
-		if (debug || verbose)
-			str_info(ctx, descr_render(&dsc),
-_("Filesystem is busy, deferring repair."));
-		return CHECK_RETRY;
-	case ESHUTDOWN:
-		/* Filesystem is already shut down, abort. */
-		str_error(ctx, descr_render(&dsc),
-_("Filesystem is shut down, aborting."));
-		return CHECK_ABORT;
-	case ENOTTY:
-	case EOPNOTSUPP:
-		/*
-		 * If the kernel cannot perform the optimization that we
-		 * requested; or we forced a repair but the kernel doesn't know
-		 * how to perform the repair, don't requeue the request.  Mark
-		 * it done and move on.
-		 */
-		if (is_unoptimized(&oldm) ||
-		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
-			return CHECK_DONE;
-		/*
-		 * If we're in no-complain mode, requeue the check for
-		 * later.  It's possible that an error in another
-		 * component caused us to flag an error in this
-		 * component.  Even if the kernel didn't think it
-		 * could fix this, it's at least worth trying the scan
-		 * again to see if another repair fixed it.
-		 */
-		if (!(repair_flags & XRM_FINAL_WARNING))
-			return CHECK_RETRY;
-		fallthrough;
-	case EINVAL:
-		/* Kernel doesn't know how to repair this? */
-		str_corrupt(ctx, descr_render(&dsc),
-_("Don't know how to fix; offline repair required."));
-		return CHECK_DONE;
-	case EROFS:
-		/* Read-only filesystem, can't fix. */
-		if (verbose || debug || needs_repair(&oldm))
-			str_error(ctx, descr_render(&dsc),
-_("Read-only filesystem; cannot make changes."));
-		return CHECK_ABORT;
-	case ENOENT:
-		/* Metadata not present, just skip it. */
-		return CHECK_DONE;
-	case ENOMEM:
-	case ENOSPC:
-		/* Don't care if preen fails due to low resources. */
-		if (is_unoptimized(&oldm) && !needs_repair(&oldm))
-			return CHECK_DONE;
-		fallthrough;
-	default:
-		/*
-		 * Operational error.  If the caller doesn't want us
-		 * to complain about repair failures, tell the caller
-		 * to requeue the repair for later and don't say a
-		 * thing.  Otherwise, print error and bail out.
-		 */
-		if (!(repair_flags & XRM_FINAL_WARNING))
-			return CHECK_RETRY;
-		str_liberror(ctx, error, descr_render(&dsc));
-		return CHECK_DONE;
-	}
-
-	if (repair_flags & XRM_FINAL_WARNING)
-		scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
-	if (needs_repair(&meta)) {
-		/*
-		 * Still broken; if we've been told not to complain then we
-		 * just requeue this and try again later.  Otherwise we
-		 * log the error loudly and don't try again.
-		 */
-		if (!(repair_flags & XRM_FINAL_WARNING))
-			return CHECK_RETRY;
-		str_corrupt(ctx, descr_render(&dsc),
-_("Repair unsuccessful; offline repair required."));
-	} else if (xref_failed(&meta)) {
-		/*
-		 * This metadata object itself looks ok, but we still noticed
-		 * inconsistencies when comparing it with the other filesystem
-		 * metadata.  If we're in "final warning" mode, advise the
-		 * caller to run xfs_repair; otherwise, we'll keep trying to
-		 * reverify the cross-referencing as repairs progress.
-		 */
-		if (repair_flags & XRM_FINAL_WARNING) {
-			str_info(ctx, descr_render(&dsc),
- _("Seems correct but cross-referencing failed; offline repair recommended."));
-		} else {
-			if (verbose)
-				str_info(ctx, descr_render(&dsc),
- _("Seems correct but cross-referencing failed; will keep checking."));
-			return CHECK_RETRY;
-		}
-	} else {
-		/* Clean operation, no corruption detected. */
-		if (needs_repair(&oldm))
-			record_repair(ctx, descr_render(&dsc),
-					_("Repairs successful."));
-		else
-			record_preen(ctx, descr_render(&dsc),
-					_("Optimization successful."));
-	}
-	return CHECK_DONE;
-}
diff --git a/scrub/scrub.h b/scrub/scrub.h
index b2b174be1a9..39e8439cb8b 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -38,7 +38,7 @@ bool can_scrub_dir(struct scrub_ctx *ctx);
 bool can_scrub_attr(struct scrub_ctx *ctx);
 bool can_scrub_symlink(struct scrub_ctx *ctx);
 bool can_scrub_parent(struct scrub_ctx *ctx);
-bool xfs_can_repair(struct scrub_ctx *ctx);
+bool can_repair(struct scrub_ctx *ctx);
 bool can_force_rebuild(struct scrub_ctx *ctx);
 
 int scrub_file(struct scrub_ctx *ctx, int fd, const struct xfs_bulkstat *bstat,
@@ -54,8 +54,4 @@ struct action_item {
 	__u32			agno;
 };
 
-enum check_outcome xfs_repair_metadata(struct scrub_ctx *ctx,
-		struct xfs_fd *xfdp, struct action_item *aitem,
-		unsigned int repair_flags);
-
 #endif /* XFS_SCRUB_SCRUB_H_ */
diff --git a/scrub/scrub_private.h b/scrub/scrub_private.h
new file mode 100644
index 00000000000..2c1cd1a84d4
--- /dev/null
+++ b/scrub/scrub_private.h
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2021-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef XFS_SCRUB_SCRUB_PRIVATE_H_
+#define XFS_SCRUB_SCRUB_PRIVATE_H_
+
+/* Shared code between scrub.c and repair.c. */
+
+int format_scrub_descr(struct scrub_ctx *ctx, char *buf, size_t buflen,
+		void *where);
+
+/* Predicates for scrub flag state. */
+
+static inline bool is_corrupt(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT;
+}
+
+static inline bool is_unoptimized(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_PREEN;
+}
+
+static inline bool xref_failed(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_XFAIL;
+}
+
+static inline bool xref_disagrees(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_XCORRUPT;
+}
+
+static inline bool is_incomplete(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE;
+}
+
+static inline bool is_suspicious(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & XFS_SCRUB_OFLAG_WARNING;
+}
+
+/* Should we fix it? */
+static inline bool needs_repair(struct xfs_scrub_metadata *sm)
+{
+	return is_corrupt(sm) || xref_disagrees(sm);
+}
+
+void scrub_warn_incomplete_scrub(struct scrub_ctx *ctx, struct descr *dsc,
+		struct xfs_scrub_metadata *meta);
+
+#endif /* XFS_SCRUB_SCRUB_PRIVATE_H_ */

