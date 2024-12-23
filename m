Return-Path: <linux-xfs+bounces-17379-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 247999FB67C
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Dec 2024 22:52:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 729A91884105
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Dec 2024 21:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4EE1C3F3B;
	Mon, 23 Dec 2024 21:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="McJqj4WU"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B5819259D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990718; cv=none; b=oE0huP3NgyZkwk9TA0tZe1CXO2Yct982bnzYNzuX0UuICfH4jdZVayfytu/0Q1QFFbalgqFCY45AoK+486qAFeqqhbgvxu9K3T9GjZcF/vFNRisNQIjM45mDooQG98LxhOMlOfM23Tm+E+hgSf4ElDBbRUpPxyMrDmbWbVdgZjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990718; c=relaxed/simple;
	bh=FgzZpeR99ojtU5dEYF7oxzk1+nbCCYqfKmkQMWZwstI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B/XIxRG4qE7IgBUuq45xUSp6iF8tEtDyQ08+vMwIbdQCJT+fvpllFWxu1TGebTcLGNFl1NqWlbYVZw/slCvQN2aKMD2eO1Eg5mZIFJvlze3GA4q6e/939ndg1hisL1iMjod6ilyRU7iTOQu6SUuUWuWBDYSMxvpB4hutlPVxkc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=McJqj4WU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D74C4CED3;
	Mon, 23 Dec 2024 21:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990718;
	bh=FgzZpeR99ojtU5dEYF7oxzk1+nbCCYqfKmkQMWZwstI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=McJqj4WUlIui5dNhPV1LQ57ESrEQyHUstvNIBglpJMWEUDeJn3u0Cx2ySzf5CVTLe
	 y1jfBMX6oxTD6jKMNTAX2Ahwdk2mh3Ls1v+cYbDewO/i9KO2p8LVHxByXZggDhEd9d
	 j49gULPDk/OjJYoELZSmVTmBvxuXCOJ7gknd22IvM8z/eMpwvASIklZlSxRtpuAv3a
	 2WSz3QTItknLWzUDftzHMnHQUUTojC91j3rgwmNljOo5rNIolZDCTCa/KNF+qZp9vC
	 1YUfU7ILzODJvtcYiW1aa0MscAucVD4itCF7uYN5hO20WDpTh0MsIllZ5WJ/GVTJ0B
	 ePYrv80HyNEAg==
Date: Mon, 23 Dec 2024 13:51:58 -0800
Subject: [PATCH 21/41] xfs_scrub: re-run metafile scrubbers during phase 5
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941290.2294268.4112620871848234004.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

For metadata files on a metadir filesystem, re-run the scrubbers during
phase 5 to ensure that the metadata files are still connected.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase5.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 scrub/scrub.h  |    7 ++++
 2 files changed, 103 insertions(+), 1 deletion(-)


diff --git a/scrub/phase5.c b/scrub/phase5.c
index 69b1cae5c5e2c0..4d0a76a529b55d 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -745,6 +745,87 @@ run_kernel_fs_scan_scrubbers(
 	return ret;
 }
 
+/* Queue one metapath scrubber. */
+static int
+queue_metapath_scan(
+	struct workqueue	*wq,
+	bool			*abortedp,
+	uint64_t		type)
+{
+	struct fs_scan_item	*item;
+	struct scrub_ctx	*ctx = wq->wq_ctx;
+	int			ret;
+
+	item = malloc(sizeof(struct fs_scan_item));
+	if (!item) {
+		ret = ENOMEM;
+		str_liberror(ctx, ret, _("setting up metapath scan"));
+		return ret;
+	}
+	scrub_item_init_metapath(&item->sri, type);
+	scrub_item_schedule(&item->sri, XFS_SCRUB_TYPE_METAPATH);
+	item->abortedp = abortedp;
+
+	ret = -workqueue_add(wq, fs_scan_worker, 0, item);
+	if (ret)
+		str_liberror(ctx, ret, _("queuing metapath scan work"));
+
+	return ret;
+}
+
+/*
+ * Scrub metadata directory file paths to ensure that fs metadata are still
+ * connected where the fs needs to find them.
+ */
+static int
+run_kernel_metadir_path_scrubbers(
+	struct scrub_ctx	*ctx)
+{
+	struct workqueue	wq;
+	const struct xfrog_scrub_descr	*sc;
+	uint64_t		type;
+	unsigned int		nr_threads = scrub_nproc_workqueue(ctx);
+	bool			aborted = false;
+	int			ret, ret2;
+
+	ret = -workqueue_create(&wq, (struct xfs_mount *)ctx, nr_threads);
+	if (ret) {
+		str_liberror(ctx, ret, _("setting up metapath scan workqueue"));
+		return ret;
+	}
+
+	/*
+	 * Scan all the metadata files in parallel if metadata directories
+	 * are enabled, because the phase 3 scrubbers might have taken out
+	 * parts of the metadir tree.
+	 */
+	for (type = 0; type < XFS_SCRUB_METAPATH_NR; type++) {
+		sc = &xfrog_metapaths[type];
+		if (sc->group != XFROG_SCRUB_GROUP_FS)
+			continue;
+
+		ret = queue_metapath_scan(&wq, &aborted, type);
+		if (ret) {
+			str_liberror(ctx, ret,
+ _("queueing metapath scrub work"));
+			goto wait;
+		}
+	}
+
+wait:
+	ret2 = -workqueue_terminate(&wq);
+	if (ret2) {
+		str_liberror(ctx, ret2, _("joining metapath scan workqueue"));
+		if (!ret)
+			ret = ret2;
+	}
+	if (aborted && !ret)
+		ret = ECANCELED;
+
+	workqueue_destroy(&wq);
+	return ret;
+}
+
 /* Check directory connectivity. */
 int
 phase5_func(
@@ -753,6 +834,16 @@ phase5_func(
 	struct ncheck_state	ncs = { .ctx = ctx };
 	int			ret;
 
+	/*
+	 * Make sure metadata files are still connected to the metadata
+	 * directory tree now that phase 3 pruned all corrupt directory tree
+	 * links.
+	 */
+	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_METADIR) {
+		ret = run_kernel_metadir_path_scrubbers(ctx);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * Check and fix anything that requires a full filesystem scan.  We do
@@ -805,8 +896,12 @@ phase5_estimate(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
+	unsigned int		scans = 2;
+
 	*items = scrub_estimate_iscan_work(ctx);
-	*nr_threads = scrub_nproc(ctx) * 2;
+	if (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_METADIR)
+		scans++;
+	*nr_threads = scrub_nproc(ctx) * scans;
 	*rshift = 0;
 	return 0;
 }
diff --git a/scrub/scrub.h b/scrub/scrub.h
index c3eed1b261d511..3bb3ea1d07bf40 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -108,6 +108,13 @@ scrub_item_init_file(struct scrub_item *sri, const struct xfs_bulkstat *bstat)
 	sri->sri_gen = bstat->bs_gen;
 }
 
+static inline void
+scrub_item_init_metapath(struct scrub_item *sri, uint64_t metapath)
+{
+	memset(sri, 0, sizeof(*sri));
+	sri->sri_ino = metapath;
+}
+
 void scrub_item_dump(struct scrub_item *sri, unsigned int group_mask,
 		const char *tag);
 


