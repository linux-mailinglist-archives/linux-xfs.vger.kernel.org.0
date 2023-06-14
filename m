Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5B59711CE7
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 03:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjEZBmy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 21:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjEZBmw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:42:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D31189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:42:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14DFA646CD
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7393CC433EF;
        Fri, 26 May 2023 01:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065370;
        bh=kdr8ziTw/9EyORl6yKAR32rqxUTCSOHAfcnbP2eiLaA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=IP6TG7YP/3VJlc8E2T33V4BzB3xzPTev5uXxTaFfqwQyE8K/+wJ7U/aCE223ciB1W
         aBesCW3KxkmkwtA+YnueYaTeUV9Y+A8JQktS1MV1ldF8lm4CU0QrgV5UbzdVuxAECh
         4yBvxj0s9K24iO5tf4WI9pttIw+35zSMuLao33lBh9ysMKO9uzIa6ikF0e3YhYxnTg
         OIeqtkb72gEZBcZpLzfqvmDkSnJVr18BIZH9CZSnHpfyjD+cXBQjgp6PFSMMLVyLAT
         /GcrLnRkMUnLKiMhWOUqD54vN9lQy6a0VfhwulZRCUnFEZFJRjIJ+vyLozdJLII0hG
         0pVz67dcvaoeQ==
Date:   Thu, 25 May 2023 18:42:50 -0700
Subject: [PATCH 2/6] xfs_scrub: get rid of trivial fs metadata scanner helpers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506071692.3742978.692117192547774476.stgit@frogsfrogsfrogs>
In-Reply-To: <168506071665.3742978.12693465390096953510.stgit@frogsfrogsfrogs>
References: <168506071665.3742978.12693465390096953510.stgit@frogsfrogsfrogs>
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

Get rid of these pointless wrappers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c |    2 +-
 scrub/phase4.c |    9 +++++----
 scrub/phase5.c |   14 ++++++--------
 scrub/scrub.c  |   36 ------------------------------------
 scrub/scrub.h  |    4 ----
 5 files changed, 12 insertions(+), 53 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 3c1341a6da7..1c953b9fdd9 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -61,7 +61,7 @@ report_to_kernel(
 		return 0;
 
 	action_list_init(&alist);
-	ret = scrub_clean_health(ctx, &alist);
+	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_HEALTHY, 0, &alist);
 	if (ret)
 		return ret;
 
diff --git a/scrub/phase4.c b/scrub/phase4.c
index f14c3ad58f2..8c248d4f3b5 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -136,14 +136,14 @@ phase4_func(
 		goto maybe_trim;
 
 	/*
-	 * Check the summary counters early.  Normally we do this during phase
-	 * seven, but some of the cross-referencing requires fairly accurate
+	 * Check the resource usage counters early.  Normally we do this during
+	 * phase 7, but some of the cross-referencing requires fairly accurate
 	 * summary counters.  Check and try to repair them now to minimize the
 	 * chance that repairs of primary metadata fail due to secondary
 	 * metadata.  If repairs fails, we'll come back during phase 7.
 	 */
 	action_list_init(&alist);
-	ret = scrub_fs_counters(ctx, &alist);
+	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, &alist);
 	if (ret)
 		return ret;
 
@@ -158,7 +158,8 @@ phase4_func(
 		return ret;
 
 	if (fsgeom.sick & XFS_FSOP_GEOM_SICK_QUOTACHECK) {
-		ret = scrub_quotacheck(ctx, &alist);
+		ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_QUOTACHECK, 0,
+				&alist);
 		if (ret)
 			return ret;
 	}
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 3af17e8305c..3c57dc844e4 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -383,12 +383,10 @@ check_fs_label(
 	return error;
 }
 
-typedef int (*iscan_item_fn)(struct scrub_ctx *, struct action_list *);
-
 struct iscan_item {
 	struct action_list	alist;
 	bool			*abortedp;
-	iscan_item_fn		scrub_fn;
+	unsigned int		scrub_type;
 };
 
 /* Run one inode-scan scrubber in this thread. */
@@ -413,7 +411,7 @@ iscan_worker(
 		nanosleep(&tv, NULL);
 	}
 
-	ret = item->scrub_fn(ctx, &item->alist);
+	ret = scrub_meta_type(ctx, item->scrub_type, 0, &item->alist);
 	if (ret) {
 		str_liberror(ctx, ret, _("checking iscan metadata"));
 		*item->abortedp = true;
@@ -439,7 +437,7 @@ queue_iscan(
 	struct workqueue	*wq,
 	bool			*abortedp,
 	xfs_agnumber_t		nr,
-	iscan_item_fn		scrub_fn)
+	unsigned int		scrub_type)
 {
 	struct iscan_item	*item;
 	struct scrub_ctx	*ctx = wq->wq_ctx;
@@ -452,7 +450,7 @@ queue_iscan(
 		return ret;
 	}
 	action_list_init(&item->alist);
-	item->scrub_fn = scrub_fn;
+	item->scrub_type = scrub_type;
 	item->abortedp = abortedp;
 
 	ret = -workqueue_add(wq, iscan_worker, nr, item);
@@ -484,14 +482,14 @@ run_kernel_iscan_scrubbers(
 	 * The nlinks scanner is much faster than quotacheck because it only
 	 * walks directories, so we start it first.
 	 */
-	ret = queue_iscan(&wq_iscan, &aborted, nr, scrub_nlinks);
+	ret = queue_iscan(&wq_iscan, &aborted, nr, XFS_SCRUB_TYPE_NLINKS);
 	if (ret)
 		goto wait;
 
 	if (nr_threads > 1)
 		nr++;
 
-	ret = queue_iscan(&wq_iscan, &aborted, nr, scrub_quotacheck);
+	ret = queue_iscan(&wq_iscan, &aborted, nr, XFS_SCRUB_TYPE_QUOTACHECK);
 	if (ret)
 		goto wait;
 
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 06433aea197..5d076ae1b47 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -366,42 +366,6 @@ scrub_summary_metadata(
 	return scrub_group(ctx, XFROG_SCRUB_GROUP_SUMMARY, 0, alist);
 }
 
-/* Scrub /only/ the superblock summary counters. */
-int
-scrub_fs_counters(
-	struct scrub_ctx		*ctx,
-	struct action_list		*alist)
-{
-	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, alist);
-}
-
-/* Scrub /only/ the quota counters. */
-int
-scrub_quotacheck(
-	struct scrub_ctx		*ctx,
-	struct action_list		*alist)
-{
-	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_QUOTACHECK, 0, alist);
-}
-
-/* Scrub /only/ the file link counters. */
-int
-scrub_nlinks(
-	struct scrub_ctx		*ctx,
-	struct action_list		*alist)
-{
-	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_NLINKS, 0, alist);
-}
-
-/* Update incore health records if we were clean. */
-int
-scrub_clean_health(
-	struct scrub_ctx		*ctx,
-	struct action_list		*alist)
-{
-	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_HEALTHY, 0, alist);
-}
-
 /* How many items do we have to check? */
 unsigned int
 scrub_estimate_ag_work(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 4ae8e142ce9..e51bdb40444 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -25,10 +25,6 @@ int scrub_metadata_file(struct scrub_ctx *ctx, unsigned int scrub_type,
 		struct action_list *alist);
 int scrub_iscan_metadata(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_summary_metadata(struct scrub_ctx *ctx, struct action_list *alist);
-int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
-int scrub_quotacheck(struct scrub_ctx *ctx, struct action_list *alist);
-int scrub_nlinks(struct scrub_ctx *ctx, struct action_list *alist);
-int scrub_clean_health(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_meta_type(struct scrub_ctx *ctx, unsigned int type,
 		xfs_agnumber_t agno, struct action_list *alist);
 

