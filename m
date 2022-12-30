Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FCA659F89
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 01:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbiLaA0C (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 19:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235760AbiLaA0B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:26:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DA7E0D8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:26:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7328B81EA1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6997CC433EF;
        Sat, 31 Dec 2022 00:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446358;
        bh=hPid5sDd1EZX4XITG7kOesEiS2yu1h+NpytY/azsVPo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R8vGSpU+lXYbxawT4GCIAmCrQU4enp4LBo/AYlOcKO94unssu3MNns3K12Aq2aP1N
         ZYylBY4izIo3zu3nzGtyOKb1HKnx3JMyeByBHLwQAnxTVVc5DWUrCqAUXCHwB0NChd
         J3B9kXI98ypVmFOqGv0+s/KxQsrG2DPwqkXmlt+VPlWmFpa3qhQ7WenLgGGKTgSSrH
         jX4/HdILw7iAeukM4TLZnrv3iReQ+4dW7/c/FuS5uHoKJgxzVQXTQICJ+0u9MpcObb
         4rG3v4uNkLt0EtjoAZKPsyNS664q7l3BcmcOOgGEvtSCMMCZX383z/2jW8FqDP8FGW
         ZNPQry6Hpg7KQ==
Subject: [PATCH 1/6] xfs_scrub: collapse trivial superblock scrub helpers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:13 -0800
Message-ID: <167243869380.715119.14385098544986541173.stgit@magnolia>
In-Reply-To: <167243869365.715119.17881025524336922669.stgit@magnolia>
References: <167243869365.715119.17881025524336922669.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove the trivial primary super scrub helper function since it makes
tracing code paths difficult and will become annoying in the patches
that follow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase2.c |    9 +++++----
 scrub/scrub.c  |   16 +---------------
 scrub/scrub.h  |    3 ++-
 3 files changed, 8 insertions(+), 20 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index 774f3a17e9e..7b6933a7475 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -166,12 +166,13 @@ phase2_func(
 	}
 
 	/*
-	 * In case we ever use the primary super scrubber to perform fs
-	 * upgrades (followed by a full scrub), do that before we launch
-	 * anything else.
+	 * Scrub primary superblock.  This will be useful if we ever need to
+	 * hook a filesystem-wide pre-scrub activity (e.g. enable filesystem
+	 * upgrades) off of the sb 0 scrubber (which currently does nothing).
+	 * If errors occur, this function will log them and return nonzero.
 	 */
 	action_list_init(&alist);
-	ret = scrub_primary_super(ctx, &alist);
+	ret = scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, &alist);
 	if (ret)
 		goto out_wq;
 	ret = action_list_process(ctx, -1, &alist,
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 0f080028879..bd33fcb770c 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -259,7 +259,7 @@ scrub_save_repair(
  * Returns 0 for success.  If errors occur, this function will log them and
  * return a positive error code.
  */
-static int
+int
 scrub_meta_type(
 	struct scrub_ctx		*ctx,
 	unsigned int			type,
@@ -325,20 +325,6 @@ scrub_group(
 	return 0;
 }
 
-/*
- * Scrub primary superblock.  This will be useful if we ever need to hook
- * a filesystem-wide pre-scrub activity off of the sb 0 scrubber (which
- * currently does nothing).  If errors occur, this function will log them and
- * return nonzero.
- */
-int
-scrub_primary_super(
-	struct scrub_ctx		*ctx,
-	struct action_list		*alist)
-{
-	return scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, alist);
-}
-
 /* Scrub each AG's header blocks. */
 int
 scrub_ag_headers(
diff --git a/scrub/scrub.h b/scrub/scrub.h
index 9558c29f32d..f228ffb89fc 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -17,7 +17,6 @@ enum check_outcome {
 struct action_item;
 
 void scrub_report_preen_triggers(struct scrub_ctx *ctx);
-int scrub_primary_super(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct action_list *alist);
 int scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
@@ -30,6 +29,8 @@ int scrub_fs_counters(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_quotacheck(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_nlinks(struct scrub_ctx *ctx, struct action_list *alist);
 int scrub_clean_health(struct scrub_ctx *ctx, struct action_list *alist);
+int scrub_meta_type(struct scrub_ctx *ctx, unsigned int type,
+		xfs_agnumber_t agno, struct action_list *alist);
 
 bool can_scrub_fs_metadata(struct scrub_ctx *ctx);
 bool can_scrub_inode(struct scrub_ctx *ctx);

