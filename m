Return-Path: <linux-xfs+bounces-10139-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFD6291ECA0
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 03:23:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF8D6B217EB
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 01:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E40C38C07;
	Tue,  2 Jul 2024 01:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOLC5Hqj"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A798BFA
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883377; cv=none; b=EqcBOVLVxIk5i/emDctyHXLZkGLRfS9isesJJMdoZ7tpotQEGDQVlU+1t+ATH6clj7bqZisEEM8gK8JlEcSp72tiUewoQTs8tafqJeuMkJ9YEqD1mO+OBxZpfbyo7JM0RcK6QXbRiPeEyK5erjomCYN8Kz+Gs22gg2VJFvK0HOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883377; c=relaxed/simple;
	bh=wyq3fGXBf1/wf4HczWQ2bhOAhHPvHxyeqpjD6GhMr0s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mVY5+V9MJeL5okhZHNo9uDWbop2pR2cIM/v7DkAqgz1wua9YC1tkmbKbTfDAfExWzLpPozFeUz6J2gEa5+RepIUJtSaaCfdNEmrHpBD0XV5RMIApUqcTBZp+wRSf6FsPoCjRxp9U2nS+DXiAlOabD+zQMQp9AjFggX5bvNTtbPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOLC5Hqj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2857DC2BD10;
	Tue,  2 Jul 2024 01:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883377;
	bh=wyq3fGXBf1/wf4HczWQ2bhOAhHPvHxyeqpjD6GhMr0s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OOLC5HqjjPwDm+z33FIzF674zEbMA7axyXFZi4a2OhPAPbko+m7s6qHinmrsGScwb
	 X3JF+bsHWpKHB+gQDINbqHLBFlw9CZEXuAUG2vXB7Sqhi9cAZrj/8UWDdXFqRxMQls
	 TfD01M2J58EmDal99wvGvVb2Wmai30fX3m1ldOSgGe6RH8RpBwTVJ3mQy6K3dNRl/+
	 0h7DqyeSoa11xJ6NHFAz1Oc6cFvYmYbWqDyspV+BxlywhM++j0wFwb5yYBw9Q1DhbE
	 klTaaXpkkgjSinPr0eRGEglL6GTzCK2RwQnJcEZlX+I8CWym5E1o4MUWGxf2w6k1YJ
	 nK5OrF7hxrvjg==
Date: Mon, 01 Jul 2024 18:22:56 -0700
Subject: [PATCH 04/10] xfs_scrub: split the scrub epilogue code into a
 separate function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988123196.2012546.11764956166230017274.stgit@frogsfrogsfrogs>
In-Reply-To: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs>
References: <171988123120.2012546.17403096510880884928.stgit@frogsfrogsfrogs>
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

Move all the code that updates the internal state in response to a scrub
ioctl() call completion into a separate function.  This will help with
vectorizing scrub calls later on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/scrub.c |   52 ++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 38 insertions(+), 14 deletions(-)


diff --git a/scrub/scrub.c b/scrub/scrub.c
index 1b0609e7418b..c4b4367e458f 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -22,6 +22,10 @@
 #include "descr.h"
 #include "scrub_private.h"
 
+static int scrub_epilogue(struct scrub_ctx *ctx, struct descr *dsc,
+		struct scrub_item *sri, struct xfs_scrub_metadata *meta,
+		int error);
+
 /* Online scrub and repair wrappers. */
 
 /* Format a scrub description. */
@@ -117,12 +121,32 @@ xfs_check_metadata(
 	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta.sm_flags);
 
 	error = -xfrog_scrub_metadata(xfdp, &meta);
+	return scrub_epilogue(ctx, &dsc, sri, &meta, error);
+}
+
+/*
+ * Update all internal state after a scrub ioctl call.
+ * Returns 0 for success, or ECANCELED to abort the program.
+ */
+static int
+scrub_epilogue(
+	struct scrub_ctx		*ctx,
+	struct descr			*dsc,
+	struct scrub_item		*sri,
+	struct xfs_scrub_metadata	*meta,
+	int				error)
+{
+	unsigned int			scrub_type = meta->sm_type;
+	enum xfrog_scrub_group		group;
+
+	group = xfrog_scrubbers[scrub_type].group;
+
 	switch (error) {
 	case 0:
 		/* No operational errors encountered. */
 		if (!sri->sri_revalidate &&
 		    debug_tweak_on("XFS_SCRUB_FORCE_REPAIR"))
-			meta.sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+			meta->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		break;
 	case ENOENT:
 		/* Metadata not present, just skip it. */
@@ -130,13 +154,13 @@ xfs_check_metadata(
 		return 0;
 	case ESHUTDOWN:
 		/* FS already crashed, give up. */
-		str_error(ctx, descr_render(&dsc),
+		str_error(ctx, descr_render(dsc),
 _("Filesystem is shut down, aborting."));
 		return ECANCELED;
 	case EIO:
 	case ENOMEM:
 		/* Abort on I/O errors or insufficient memory. */
-		str_liberror(ctx, error, descr_render(&dsc));
+		str_liberror(ctx, error, descr_render(dsc));
 		return ECANCELED;
 	case EDEADLOCK:
 	case EBUSY:
@@ -152,7 +176,7 @@ _("Filesystem is shut down, aborting."));
 		return 0;
 	default:
 		/* Operational error.  Log it and move on. */
-		str_liberror(ctx, error, descr_render(&dsc));
+		str_liberror(ctx, error, descr_render(dsc));
 		scrub_item_clean_state(sri, scrub_type);
 		return 0;
 	}
@@ -163,27 +187,27 @@ _("Filesystem is shut down, aborting."));
 	 * we'll try the scan again, just in case the fs was busy.
 	 * Only retry so many times.
 	 */
-	if (want_retry(&meta) && scrub_item_schedule_retry(sri, scrub_type))
+	if (want_retry(meta) && scrub_item_schedule_retry(sri, scrub_type))
 		return 0;
 
 	/* Complain about incomplete or suspicious metadata. */
-	scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
+	scrub_warn_incomplete_scrub(ctx, dsc, meta);
 
 	/*
 	 * If we need repairs or there were discrepancies, schedule a
 	 * repair if desired, otherwise complain.
 	 */
-	if (is_corrupt(&meta) || xref_disagrees(&meta)) {
+	if (is_corrupt(meta) || xref_disagrees(meta)) {
 		if (ctx->mode != SCRUB_MODE_REPAIR) {
 			/* Dry-run mode, so log an error and forget it. */
-			str_corrupt(ctx, descr_render(&dsc),
+			str_corrupt(ctx, descr_render(dsc),
 _("Repairs are required."));
 			scrub_item_clean_state(sri, scrub_type);
 			return 0;
 		}
 
 		/* Schedule repairs. */
-		scrub_item_save_state(sri, scrub_type, meta.sm_flags);
+		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
 		return 0;
 	}
 
@@ -191,12 +215,12 @@ _("Repairs are required."));
 	 * If we could optimize, schedule a repair if desired,
 	 * otherwise complain.
 	 */
-	if (is_unoptimized(&meta)) {
+	if (is_unoptimized(meta)) {
 		if (ctx->mode == SCRUB_MODE_DRY_RUN) {
 			/* Dry-run mode, so log an error and forget it. */
 			if (group != XFROG_SCRUB_GROUP_INODE) {
 				/* AG or FS metadata, always warn. */
-				str_info(ctx, descr_render(&dsc),
+				str_info(ctx, descr_render(dsc),
 _("Optimization is possible."));
 			} else if (!ctx->preen_triggers[scrub_type]) {
 				/* File metadata, only warn once per type. */
@@ -210,7 +234,7 @@ _("Optimization is possible."));
 		}
 
 		/* Schedule optimizations. */
-		scrub_item_save_state(sri, scrub_type, meta.sm_flags);
+		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
 		return 0;
 	}
 
@@ -221,8 +245,8 @@ _("Optimization is possible."));
 	 * re-examine the object as repairs progress to see if the kernel will
 	 * deem it completely consistent at some point.
 	 */
-	if (xref_failed(&meta) && ctx->mode == SCRUB_MODE_REPAIR) {
-		scrub_item_save_state(sri, scrub_type, meta.sm_flags);
+	if (xref_failed(meta) && ctx->mode == SCRUB_MODE_REPAIR) {
+		scrub_item_save_state(sri, scrub_type, meta->sm_flags);
 		return 0;
 	}
 


