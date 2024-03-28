Return-Path: <linux-xfs+bounces-4928-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D912487A192
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Mar 2024 03:17:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 38430B20E65
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Mar 2024 02:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B464BA37;
	Wed, 13 Mar 2024 02:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pCeURJ08"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7F1AD21
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710296252; cv=none; b=fTcOrMMmC22i12Qmo42BGOZShKCTtv++mkj2JjQqB4yadpApRxfvJjK68+hxkcQzgoWp/uFwqa9+uDcDrY5qrLPipOUD+2yXDXlolz0AvBIDNte4vhHxvnIBzC6Q/cgjmL+vBYY/9r3qWxkfqOFrKMtWe5KZT3QaUVXzYNVmEno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710296252; c=relaxed/simple;
	bh=DZMVo8ohj80KEVGlsH9qPBZ7fC4ElR/w1WpSGPRLdbI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O5JNf9+TErYUEA0j529g6MUcAtS1cFD776dDs5v8vFqBGJ56M2LKM3Gdae4wg7e9EqyYvgj6ImrRfEE2rcCkCj/rxJWcTf2pzvBesyGyxtta6gRMY3nYW/WSncrRgHEFWaAL7wAljg7BPMfaWP3XVQuEwnzYRUB057VCZY7hkNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pCeURJ08; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA43AC433F1;
	Wed, 13 Mar 2024 02:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710296252;
	bh=DZMVo8ohj80KEVGlsH9qPBZ7fC4ElR/w1WpSGPRLdbI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pCeURJ08/uco6mifMevQ5Dvph2JDZXe0LX1IULydOSBd3miyCczRj+sQq5ewtk3d9
	 gsNeqCeHm71oPdGAZLIePneDAgbjxjxeWsIr78ULGaXC6vKMVgAK2WWXrtEXeuDXUc
	 Mr25x5vQjaf6JO3Kfa5+Eb/x/08LzIoZpapIVmLccdvV2fu1aFaoYl3l7jIEavebT7
	 eve5B4qUCCJHHG/H41OXOYDcAJFC3NnQ1wtSnOuU6v5QBuV68RYJOPKtSk04hI9vVW
	 xkDI4P8z6xdW95Rx0j7R74Q5bfIE3FuBvroo6OZ8197OfqaRcUrUP3IB5uWOqNEor+
	 /J71t+jk4oYuw==
Date: Tue, 12 Mar 2024 19:17:32 -0700
Subject: [PATCH 3/3] libfrog: create a new scrub group for things requiring
 full inode scans
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029435218.2066071.72866513594224796.stgit@frogsfrogsfrogs>
In-Reply-To: <171029435171.2066071.3261378354922412284.stgit@frogsfrogsfrogs>
References: <171029435171.2066071.3261378354922412284.stgit@frogsfrogsfrogs>
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

Subsequent patches will add online fsck types (quotacheck, link counts)
that require us to walk every inode in the entire filesystem.  This
requires the AG metadata and the inodes to be in good enough shape to
complete the scan without hitting corruption errors.  As such, they
ought to run after phases 2-4 and before phase 7, which summarizes what
we've found.

Phase 5 seems like a reasonable place to do this, since it already walks
every xattr and directory entry in the filesystem to look for suspicious
looking names.  Add a new XFROG_SCRUB_GROUP, and add it to phase 5.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/scrub.c        |    1 +
 libfrog/scrub.h   |    1 +
 scrub/phase5.c    |   22 ++++++++++++++++++++--
 scrub/scrub.c     |   33 +++++++++++++++++++++++++++++++++
 scrub/scrub.h     |    1 +
 scrub/xfs_scrub.h |    1 +
 6 files changed, 57 insertions(+), 2 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index 70301c0676c4..a77cd872fede 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -184,6 +184,7 @@ parse_args(
 	case XFROG_SCRUB_GROUP_FS:
 	case XFROG_SCRUB_GROUP_NONE:
 	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
 		if (!parse_none(argc, optind)) {
 			exitcode = 1;
 			return command_usage(cmdinfo);
diff --git a/libfrog/scrub.h b/libfrog/scrub.h
index 68f1a968103e..27230c62f71a 100644
--- a/libfrog/scrub.h
+++ b/libfrog/scrub.h
@@ -13,6 +13,7 @@ enum xfrog_scrub_group {
 	XFROG_SCRUB_GROUP_PERAG,	/* per-AG metadata */
 	XFROG_SCRUB_GROUP_FS,		/* per-FS metadata */
 	XFROG_SCRUB_GROUP_INODE,	/* per-inode metadata */
+	XFROG_SCRUB_GROUP_ISCAN,	/* metadata requiring full inode scan */
 	XFROG_SCRUB_GROUP_SUMMARY,	/* summary metadata */
 };
 
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 7e0eaca90422..0a91e4f0640b 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -16,6 +16,8 @@
 #include "list.h"
 #include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/scrub.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "inodes.h"
@@ -23,8 +25,9 @@
 #include "scrub.h"
 #include "descr.h"
 #include "unicrash.h"
+#include "repair.h"
 
-/* Phase 5: Check directory connectivity. */
+/* Phase 5: Full inode scans and check directory connectivity. */
 
 /*
  * Warn about problematic bytes in a directory/attribute name.  That means
@@ -386,9 +389,24 @@ int
 phase5_func(
 	struct scrub_ctx	*ctx)
 {
+	struct action_list	alist;
 	bool			aborted = false;
 	int			ret;
 
+	/*
+	 * Check and fix anything that requires a full inode scan.  We do this
+	 * after we've checked all inodes and repaired anything that could get
+	 * in the way of a scan.
+	 */
+	action_list_init(&alist);
+	ret = scrub_iscan_metadata(ctx, &alist);
+	if (ret)
+		return ret;
+	ret = action_list_process(ctx, ctx->mnt.fd, &alist,
+			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
+	if (ret)
+		return ret;
+
 	if (ctx->corruptions_found || ctx->unfixable_errors) {
 		str_info(ctx, ctx->mntpoint,
 _("Filesystem has errors, skipping connectivity checks."));
@@ -417,7 +435,7 @@ phase5_estimate(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	*items = ctx->mnt_sv.f_files - ctx->mnt_sv.f_ffree;
+	*items = scrub_estimate_iscan_work(ctx);
 	*nr_threads = scrub_nproc(ctx);
 	*rshift = 0;
 	return 0;
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 1c53260cc26c..023cc2c2cd2c 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -47,6 +47,7 @@ format_scrub_descr(
 		break;
 	case XFROG_SCRUB_GROUP_FS:
 	case XFROG_SCRUB_GROUP_SUMMARY:
+	case XFROG_SCRUB_GROUP_ISCAN:
 		return snprintf(buf, buflen, _("%s"), _(sc->descr));
 		break;
 	case XFROG_SCRUB_GROUP_NONE:
@@ -421,6 +422,15 @@ scrub_summary_metadata(
 	return scrub_group(ctx, XFROG_SCRUB_GROUP_SUMMARY, 0, alist);
 }
 
+/* Scrub all metadata requiring a full inode scan. */
+int
+scrub_iscan_metadata(
+	struct scrub_ctx		*ctx,
+	struct action_list		*alist)
+{
+	return scrub_group(ctx, XFROG_SCRUB_GROUP_ISCAN, 0, alist);
+}
+
 /* Scrub /only/ the superblock summary counters. */
 int
 scrub_fs_counters(
@@ -456,6 +466,29 @@ scrub_estimate_ag_work(
 	return estimate;
 }
 
+/*
+ * How many kernel calls will we make to scrub everything requiring a full
+ * inode scan?
+ */
+unsigned int
+scrub_estimate_iscan_work(
+	struct scrub_ctx		*ctx)
+{
+	const struct xfrog_scrub_descr	*sc;
+	int				type;
+	unsigned int			estimate;
+
+	estimate = ctx->mnt_sv.f_files - ctx->mnt_sv.f_ffree;
+
+	sc = xfrog_scrubbers;
+	for (type = 0; type < XFS_SCRUB_TYPE_NR; type++, sc++) {
+		if (sc->group == XFROG_SCRUB_GROUP_ISCAN)
+			estimate++;
+	}
+
+	return estimate;
+}
+
 /*
  * Scrub file metadata of some sort.  If errors occur, this function will log
  * them and return nonzero.
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 8a999da6a965..0033fe7ed931 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -24,6 +24,7 @@ int scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct action_list *alist);
 int scrub_fs_metadata(struct scrub_ctx *ctx, unsigned int scrub_type,
 		struct action_list *alist);
+int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
 
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 7aea79d9555e..34d850d8db36 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -99,6 +99,7 @@ int phase7_func(struct scrub_ctx *ctx);
 
 /* Progress estimator functions */
 unsigned int scrub_estimate_ag_work(struct scrub_ctx *ctx);
+unsigned int scrub_estimate_iscan_work(struct scrub_ctx *ctx);
 int phase2_estimate(struct scrub_ctx *ctx, uint64_t *items,
 		    unsigned int *nr_threads, int *rshift);
 int phase3_estimate(struct scrub_ctx *ctx, uint64_t *items,


