Return-Path: <linux-xfs+bounces-5620-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8338088B87A
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Mar 2024 04:28:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 108F31F3E1FF
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Mar 2024 03:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB1181292D0;
	Tue, 26 Mar 2024 03:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/JNLUOG"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C43586AC1
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423705; cv=none; b=u2HCbmP9tx55xzaZyCmInCB0EpjSTLTxKVPLHVaGvj08WL/dex/qcopqrnDrJVfbBp9gw1EJRWVc9fxvem/F2tBfAMecRl5IAg6jek4lRcOlAw/Cj79i/O3w4L4ioGH1OzvCeczZ1dFKbDNtZOoa3FTM8D/o7X89HOm/BpwPCOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423705; c=relaxed/simple;
	bh=NEUHjPfPl78O7tVHLQmucpj93XqT5fs3nqdN3ociuBs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nL+l1ynlA8wXlUJfRLwwq9Fkh2cM8IVrsVWdGO4/CT10MB6lx8mttfveWpVR7NhKKZSu2INOI0sbfqlvBzqzk9zVAaCU5ctU1nBhjnkoxq90ERWc/ClszNiVdWK4Ke1Q24iGyfvFDe+FMC9GWTDcBDo4eQ3gCMnHYnrikXp4c5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/JNLUOG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FFEC433C7;
	Tue, 26 Mar 2024 03:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423705;
	bh=NEUHjPfPl78O7tVHLQmucpj93XqT5fs3nqdN3ociuBs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=U/JNLUOG81Lf1oLSfqbUgPqKEOIBRN+3K3eZBXG8VMW1b3ADbNilc993BdGgZBznG
	 4PeVjIGdqkM4IC2PnBAmK1E9dqmKcqTvrUYh83f37aeosZa8Dpjr/yj7ceCghB0XDl
	 jcP0mKmYwLQx08cADYb8H26mmM07RHrhUuFZyU5ibst1MIka2+EuyYyMO4ztV8nZjU
	 1JluzKfHoJFdOK6Hj92knWR4iAWuAp6pkRiw4KyDGpK5almizDfufvOaiY7hwTIIjP
	 D0+pavR4nmVXup91zoKUP/mmOnISXUPKfMXZyG4S18dR4QsAHWqpx22GOCninmSdRB
	 oaZ1DRyxy8tPg==
Date: Mon, 25 Mar 2024 20:28:24 -0700
Subject: [PATCH 3/3] libfrog: create a new scrub group for things requiring
 full inode scans
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142130815.2215041.12259917648551387746.stgit@frogsfrogsfrogs>
In-Reply-To: <171142130769.2215041.13045675877934918888.stgit@frogsfrogsfrogs>
References: <171142130769.2215041.13045675877934918888.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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


