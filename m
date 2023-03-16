Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559A66BD921
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Mar 2023 20:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjCPT2f (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Mar 2023 15:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjCPT2d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:28:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126517D9F
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:28:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F4D7620F8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2C1C433D2;
        Thu, 16 Mar 2023 19:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994911;
        bh=5MMyRE+PlSXHsw6Justu+e7FyMHrGXrBqKyA9QNXtcA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qDi1SInNX/T3COGzwNxYVN/4JpvB2iWMlB0bYNWuGTqy4WWbHk98Q/X/WyVXZAVsu
         H9273DzONF/iaMKYwYl47WJxQ0u2TkZzwovn7FDDiAG3kSlgoPHrhnQvH7184RWaQb
         63IirW/VH5k0TUCE+A+uPTpAL+MUOz9fpHeDN8+shNy/oaAwNvoQRZV3pxMMxcvF9y
         hfmICMjQhcnNe6qaXk7Ao0dhyrxru65MBE3E7aj7FIPWML9BmdnOx2FNuultI0GPq9
         punSYKCJwOFlqNQxC7f5krQQqpaW+OiEyupbjWX+gL4imZdpxKOMYoqQalt5L5TNdE
         ILKOqPyEMUtNQ==
Date:   Thu, 16 Mar 2023 12:28:30 -0700
Subject: [PATCH 1/2] xfs_scrub: revert unnecessary code from "implement the
 upper half of parent pointers"
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899415780.16530.8375616009526001401.stgit@frogsfrogsfrogs>
In-Reply-To: <167899415768.16530.9685924832572537457.stgit@frogsfrogsfrogs>
References: <167899415768.16530.9685924832572537457.stgit@frogsfrogsfrogs>
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

Revert this piece which is no longer necessary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/inodes.c |   26 --------------------------
 scrub/inodes.h |    2 --
 2 files changed, 28 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 245dd713d..78f0914b8 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -19,7 +19,6 @@
 #include "descr.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/bulkstat.h"
-#include "parent.h"
 
 /*
  * Iterate a range of inodes.
@@ -450,28 +449,3 @@ scrub_open_handle(
 	return open_by_fshandle(handle, sizeof(*handle),
 			O_RDONLY | O_NOATIME | O_NOFOLLOW | O_NOCTTY);
 }
-
-/* Construct a description for an inode. */
-void
-xfs_scrub_ino_descr(
-	struct scrub_ctx	*ctx,
-	struct xfs_handle	*handle,
-	char			*buf,
-	size_t			buflen)
-{
-	uint64_t		ino;
-	xfs_agnumber_t		agno;
-	xfs_agino_t		agino;
-	int			ret;
-
-	ret = handle_to_path(handle, sizeof(struct xfs_handle), buf, buflen);
-	if (ret >= 0)
-		return;
-
-	ino = handle->ha_fid.fid_ino;
-	agno = ino / (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
-	agino = ino % (1ULL << (ctx->mnt.inopblog + ctx->mnt.agblklog));
-	snprintf(buf, buflen, _("inode %"PRIu64" (%u/%u)"), ino, agno,
-			agino);
-}
-
diff --git a/scrub/inodes.h b/scrub/inodes.h
index 189fa282d..f03180458 100644
--- a/scrub/inodes.h
+++ b/scrub/inodes.h
@@ -21,7 +21,5 @@ int scrub_scan_all_inodes(struct scrub_ctx *ctx, scrub_inode_iter_fn fn,
 		void *arg);
 
 int scrub_open_handle(struct xfs_handle *handle);
-void xfs_scrub_ino_descr(struct scrub_ctx *ctx, struct xfs_handle *handle,
-		char *buf, size_t buflen);
 
 #endif /* XFS_SCRUB_INODES_H_ */

